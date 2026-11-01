#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
confronto_con_A4.py - Confronto segnale-per-segnale fra la reimplementazione indipendente di A7
(reimpl_segnali.py) e il codice dei segnali di A4 (agents/A4/signals.py), con elenco delle divergenze e causa.

MODI
  python3 -I confronto_con_A4.py                     # SINTETICO: batteria dei pattern piantati + serie a regimi
  python3 -I confronto_con_A4.py --reale DIR --autorizzazione-C0 "<testo>" [--tf 60,30]
        # REALE: RIFIUTATO se manca l'autorizzazione esplicita di C0 (stringa non vuota). Prima di leggere qualunque
        # file verifica gli sha256 dei 4 CSV contro congelati/HASH_DATI.txt e registra l'esecuzione in
        # registro_esecuzioni_A7.txt. NON eseguire senza autorizzazione di C0.

COSA CONFRONTA (per ogni serie e per ogni variante CONT/INV)
  * insieme dei segnali (barra tau, lato);
  * episodi armati (direzione d, barra s) e picco finale p;
  * contatori: armati per direzione.
CAUSA DELLE DIVERGENZE
  Per ogni divergenza si riporta (a) la valutazione dell'A7 alla barra (flag di ogni condizione, da trace) e
  l'episodio A4 che contiene la barra; (b) quali LETTURE ALTERNATIVE della specifica (Cfg.alt_* di reimpl_segnali,
  domande.md Q1-Q6) riconciliano i due insiemi: se una sola alternativa riconcilia, quella e la causa probabile.
  Una divergenza NON riconciliata da nessuna alternativa e un possibile BUG (di A4 o di A7) da esaminare a mano.
"""
import argparse
import hashlib
import importlib.util
import itertools
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
BB = os.path.abspath(os.path.join(HERE, "..", ".."))
A4DIR = os.path.join(BB, "agents", "A4")
sys.path.insert(0, HERE)
import pattern_piantati as PP        # noqa: E402
import autotest_reimpl as AT         # noqa: E402  (regime_series)
R, VG = PP.R, PP.VG

ALT_FLAGS = ["alt_arm_early", "alt_consume_reset_on_new_p", "alt_cont_first_touch_only",
             "alt_eval_from_arm_bar", "alt_warmup_not_consume"]


def load_a4():
    """Carica signals.py e engine.py di A4 SENZA modificarli."""
    if not os.path.exists(os.path.join(A4DIR, "signals.py")):
        raise SystemExit("agents/A4/signals.py non trovato")
    sys.path.insert(0, A4DIR)
    import importlib
    S = importlib.import_module("signals")
    E = importlib.import_module("engine")
    return S, E


def a4_run(S, E, bars, tf_min, variante):
    """Esegue rileva() di A4 su barre gia costruite. Restituisce (set di (j, side), dict risultato)."""
    b = dict(bars)
    if "time" not in b:
        b["time"] = np.arange(len(b["close"]), dtype=np.int64) * tf_min
    br = S.barre_da_dict(b, tf_min)
    ind = E.indicatori(br)
    r = S.rileva(br, ind, variante)
    sig = sorted((int(s["j"]), int(s["side"])) for s in r["segnali"])
    return sig, r


def a7_run(bars, tipo, cfgd=None):
    res = R.detect(bars, R.Cfg(**(cfgd or {})), trace=True)
    sig = sorted((s["bar"], s["side"]) for s in res["signals"] if s["tipo"] == tipo)
    return sig, res


def episodes_a7(res, tipo):
    return sorted((e["d"], e["s"]) for e in res["episodes"])


def episodes_a4(r):
    return sorted((int(e["d"]), int(e["s"])) for e in r["episodi"])


def compare_series(S, E, bars, tf_min, name, verbose=True):
    """Restituisce lista di divergenze (dict) per la serie."""
    divs = []
    for var in ("CONT", "INV"):
        s4, r4 = a4_run(S, E, bars, tf_min, var)
        s7, r7 = a7_run(bars, var)
        only7 = sorted(set(s7) - set(s4))
        only4 = sorted(set(s4) - set(s7))
        # episodi: stesso insieme (d, s)? (in A7 gli episodi sono comuni alle due varianti; in A4 per variante)
        e7 = episodes_a7(r7, var); e4 = episodes_a4(r4)
        ep_ok = (e7 == e4)
        ep_only7 = sorted(set(e7) - set(e4)); ep_only4 = sorted(set(e4) - set(e7))
        p7 = {(e["d"], e["s"]): e["p"] for e in r7["episodes"]}
        p4 = {(int(e["d"]), int(e["s"])): int(e["p"]) for e in r4["episodi"]}
        p_diff = sorted((k, p7[k], p4[k]) for k in set(p7) & set(p4) if p7[k] != p4[k])
        if p_diff:
            ep_ok = False
        armed_ok = (r4["armati"]["+1"] == sum(1 for d, _ in e7 if d == 1) and r4["armati"]["-1"] == sum(1 for d, _ in e7 if d == -1))
        if only7 or only4 or not ep_ok or not armed_ok:
            d = {"serie": name, "tf": tf_min, "variante": var, "solo_A7": only7, "solo_A4": only4,
                 "episodi_uguali": ep_ok, "armati_uguali": armed_ok,
                 "episodi_solo_A7": ep_only7[:12], "episodi_solo_A4": ep_only4[:12], "picchi_diversi_(d,s),pA7,pA4": p_diff[:8],
                 "n_ep_solo_A7": len(ep_only7), "n_ep_solo_A4": len(ep_only4), "n_A7": len(s7), "n_A4": len(s4)}
            d["analisi"] = analizza(bars, tf_min, var, S, E, s4, s7, r7, r4)
            divs.append(d)
        if verbose:
            print("%-6s %-60s A7=%d A4=%d %s" % (var, name[:60], len(s7), len(s4), "OK" if not (only7 or only4 or not ep_ok or not armed_ok) else "DIVERGE"))
    return divs


def analizza(bars, tf_min, var, S, E, s4, s7, r7, r4):
    """Attribuzione: flag A7 alla barra + letture alternative che riconciliano."""
    out = {"flag_A7_alle_barre_divergenti": [], "alternative_che_riconciliano": [], "episodi_A4_alle_barre": []}
    bad = sorted(set(s7) ^ set(s4))
    for j, _ in bad:
        tr = [x for x in (r7.get("trace") or []) if x["t"] == j and x["tipo"] == var]
        out["flag_A7_alle_barre_divergenti"].append((j, tr[:2]))
        out["episodi_A4_alle_barre"].append((j, [{k: e[k] for k in ("id", "d", "s", "p", "t0", "fine", "fine_idx", "stadio")} for e in r4["episodi"]
                                                if e["t0"] <= j <= (e["fine_idx"] if e["fine_idx"] is not None else 10 ** 9)][:2]))
    # alternative: provo tutte le combinazioni di letture alternative (2^5 = 32) e vedo quali riconciliano
    target = set(s4)
    e4 = set(episodes_a4(r4))
    for k in range(1, 4):
        for combo in itertools.combinations(ALT_FLAGS, k):
            cfgd = {c: True for c in combo}
            s7a, r7a = a7_run(bars, var, cfgd)
            if set(s7a) == target and set(episodes_a7(r7a, var)) == e4:
                out["alternative_che_riconciliano"].append(combo)
        if out["alternative_che_riconciliano"]:
            break          # la combinazione piu piccola basta
    return out


def stampa_div(divs, limite=12):
    for d in divs[:limite]:
        print("  DIVERGENZA %s %s tf=%s: solo_A7=%s solo_A4=%s episodi_uguali=%s armati_uguali=%s" %
              (d["serie"], d["variante"], d["tf"], d["solo_A7"][:6], d["solo_A4"][:6], d["episodi_uguali"], d["armati_uguali"]))
        a = d["analisi"]
        for j, tr in a["flag_A7_alle_barre_divergenti"][:3]:
            print("     barra %d: valutazioni A7: %s" % (j, tr if tr else "nessuna valutazione A7 a questa barra"))
        for j, ep in a["episodi_A4_alle_barre"][:3]:
            print("     barra %d: episodi A4 attivi: %s" % (j, ep if ep else "nessuno"))
        print("     letture alternative che riconciliano (min. combinazione): %s" % (a["alternative_che_riconciliano"] or "NESSUNA -> possibile bug, esame a mano"))
        if not d["episodi_uguali"]:
            print("     episodi solo A7 (%d)=%s | solo A4 (%d)=%s | picchi diversi=%s" % (d["n_ep_solo_A7"], d["episodi_solo_A7"], d["n_ep_solo_A4"], d["episodi_solo_A4"], d["picchi_diversi_(d,s),pA7,pA4"]))


def sintetico():
    S, E = load_a4()
    t0 = time.time()
    alldivs = []
    print("=== CONFRONTO SU PATTERN PIANTATI (long e specchio) ===")
    for sc in PP.scenari():
        b = PP.build(sc["deltas"], wick=sc["wick"], n_q=sc["n_q"], dip=sc.get("dip", 0.0))
        for tag, bars in (("L", b), ("S", PP.mirror(b))):
            if sc.get("solo_long") and tag == "S":
                continue
            alldivs += compare_series(S, E, bars, 60, "%s[%s]" % (sc["nome"], tag), verbose=False)
    print("pattern piantati: %d divergenze" % len(alldivs))
    print("\n=== CONFRONTO SU SERIE A REGIMI (6000 barre, 30 semi, TF 60 e 30) ===")
    n0 = len(alldivs)
    tot7 = tot4 = 0
    for seed in range(1, 31):
        bars = AT.regime_series(6000, seed)
        for tf in (60, 30):
            for var in ("CONT", "INV"):
                s4, _ = a4_run(S, E, bars, tf, var); s7, _ = a7_run(bars, var)
                tot7 += len(s7); tot4 += len(s4)
            alldivs += compare_series(S, E, bars, tf, "regimi_seed%d" % seed, verbose=False)
    print("serie a regimi: %d segnali A7, %d segnali A4, %d divergenze" % (tot7, tot4, len(alldivs) - n0))
    print("\n--- DETTAGLIO DIVERGENZE ---")
    stampa_div(alldivs, 25)
    print("\nESITO CONFRONTO SINTETICO: %s (tempo %.1f s)" % ("NESSUNA DIVERGENZA" if not alldivs else "%d DIVERGENZE" % len(alldivs), time.time() - t0))
    return 0 if not alldivs else 2


# --------------------------------------------------------------------------------------------
# MODO REALE (solo con autorizzazione esplicita di C0)
# --------------------------------------------------------------------------------------------
def reale(dirpath, autorizzazione, tfs):
    if not autorizzazione or not autorizzazione.strip():
        print("RIFIUTATO: l'esecuzione sui CSV reali richiede --autorizzazione-C0 con il testo/riferimento dell'autorizzazione. Nessun file letto.")
        return 3
    hashfile = os.path.join(BB, "congelati", "HASH_DATI.txt")
    exp = {}
    with open(hashfile) as f:
        for ln in f:
            p = ln.split()
            if len(p) == 2:
                exp[p[1]] = p[0]
    names = ["ABTG_M1_XAUUSD_2013.csv", "ABTG_M1_XAUUSD_2018.csv", "ABTG_M1_XAUUSD_2020.csv", "ABTG_M1_XAUUSD.csv"]
    for nm in names:
        pth = os.path.join(dirpath, nm)
        h = VG.sha256_file(pth)
        if h != exp.get(nm):
            print("RIFIUTATO: sha256 di %s (%s) diverso da HASH_DATI.txt (%s)" % (nm, h, exp.get(nm)))
            return 4
    reg = os.path.join(HERE, "registro_esecuzioni_A7.txt")
    with open(reg, "a") as f:
        f.write("%s | confronto_con_A4 REALE | autorizzazione C0: %s | dir=%s | tf=%s | hash CSV verificati contro HASH_DATI\n" %
                (time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime()), autorizzazione.strip(), dirpath, tfs))
    S, E = load_a4()
    alldivs = []
    for nm in names:
        m1 = VG.load_m1_csv(os.path.join(dirpath, nm))
        for tf in tfs:
            # barre costruite col MIO aggregatore (indipendente) e confrontate con quelle di A4
            bars = VG.aggregate_m1(m1, tf, min_m1=1)
            m4 = E.carica(os.path.join(dirpath, nm))
            b4 = E.costruisci_barre(m4, tf)
            same_bars = (len(b4.t) == len(bars["time"]) and np.array_equal(b4.t, bars["time"]) and np.array_equal(b4.c, bars["close"])
                         and np.array_equal(b4.h, bars["high"]) and np.array_equal(b4.l, bars["low"]) and np.array_equal(b4.o, bars["open"]))
            print("%s TF=%d: barre A7=%d A4=%d identiche=%s" % (nm, tf, len(bars["time"]), len(b4.t), same_bars))
            alldivs += compare_series(S, E, bars, tf, "%s_tf%d" % (nm, tf), verbose=True)
    print("\n--- DETTAGLIO DIVERGENZE ---")
    stampa_div(alldivs, 50)
    print("\nESITO CONFRONTO REALE: %s" % ("NESSUNA DIVERGENZA" if not alldivs else "%d DIVERGENZE" % len(alldivs)))
    return 0 if not alldivs else 2


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--reale", default=None, help="cartella con i 4 CSV (SOLO con autorizzazione di C0)")
    ap.add_argument("--autorizzazione-C0", default="", dest="aut")
    ap.add_argument("--tf", default="60,30")
    a = ap.parse_args()
    if a.reale:
        return reale(a.reale, a.aut, [int(x) for x in a.tf.split(",")])
    return sintetico()


if __name__ == "__main__":
    sys.exit(main())
