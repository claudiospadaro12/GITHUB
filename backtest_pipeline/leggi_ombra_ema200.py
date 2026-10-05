#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
leggi_ombra_ema200.py -- lettore dei CSV di mql5/Experts/ABTG_EMA200_Ombra.mq5 (05/10/2026).

Legge da UNA cartella (copia di MQL5\\Files\\ABTG_Ombra dal terminale):
  ombra_esiti_AAAAMM.csv   un setup simulato per riga (esito in R)
  ombra_trigger_AAAAMM.csv ogni volta che il segnale scatta (anche senza setup: denominatore)
  ombra_imbuto_AAAAMM.csv  conteggi giornalieri per simbolo x TF (quadratura)

Calcola per gruppo (simbolo/TF/concordanza col TF superiore, poi aggregati): n, PF in R, win rate,
media R, DD in R, esito per lato; un controllo di casualita' (bootstrap a blocchi di GIORNO della media
R: banda del null centrato + IC) e il verdetto con le parole di casa.

REGOLE (scritte PRIMA dei dati, report/EA_EMA200_OMBRA_2026-10-05.md sez. 4):
  - n = setup con ALMENO una gamba riempita (i NON_RIEMPITO valgono 0 R e non entrano nel campione;
    si contano a parte come tasso di riempimento).
  - n < 150 -> "NON ANCORA MISURATO" e "MERITO: NON ANCORA MISURATO". Il RISCHIO (DD in R) si scrive
    SEMPRE, a qualunque n (valvola di casa: il campione sottile sospende il merito, mai il rischio).
  - meno di 20 giorni distinti nel campione -> "NON ANCORA MISURATO" (il bootstrap a blocchi di giorno
    con pochi blocchi da' bande troppo strette: falso EFFETTO).
  - H0: media R = 0 (nessun vantaggio AL NETTO dello spread, che la simulazione paga gia' via bid/ask).
    Null = bootstrap della serie centrata (R - media), a blocchi di giorno.
  - EFFETTO   : media > q97,5 del null, media >= +0,10 R, IC95 basso > 0, e p * K <= 0,05
                (K = gruppi giudicabili nella STESSA tabella: correzione di Bonferroni).
  - CONTRARIO : simmetrico (media <= -0,10 R, IC95 alto < 0, p_basso * K <= 0,05).
  - NULLO     : |media| < 0,05 R, dentro la banda del null, semi-ampiezza IC95 <= 0,10 R.
  - altrimenti ZONA GRIGIA (anche un EFFETTO che non regge la correzione per K).
  - la tabella principale usa SOLO i setup con costo_ok=1 (stop >= 40 x spread); quelli sotto
    frontiera si contano a parte (--includi-sotto-frontiera per giudicarli insieme).

Uso:
  python3 backtest_pipeline/leggi_ombra_ema200.py <cartella>
  python3 backtest_pipeline/leggi_ombra_ema200.py <cartella> --out <cartella_tabelle_csv>
  python3 backtest_pipeline/leggi_ombra_ema200.py --autotest
"""
import argparse
import csv
import datetime as dt
import glob
import math
import os
import re
import sys
import tempfile

import numpy as np

N_MIN = 150
GIORNI_MIN = 20
SOGLIA_EFF = 0.10
SOGLIA_NULLO = 0.05
SEMI_MAX = 0.10
ALFA = 0.05
N_BOOT = 4000
SEME = 20261005
GIORNI_ORIZZONTE = 90       # "in 3 mesi"

# intestazioni: IDENTICHE a Hdr() dell'EA (l'autotest le confronta col sorgente .mq5)
HDR_ESITI = ("id;data_arm_server;barra_tf;simbolo;tf;lato;dist_atr;dist_live_atr;conc_htf;htf;dist_htf_atr;"
             "ema200;atr;ema14;o1;o2;sl;tp_l1;tp_l2;spread_arm_pts;stop_pts;stop_su_spread;costo_ok;"
             "esito;R_finale;pct_teorico;esito1;R1;fill1;spread_fill1;mae1_R;mfe1_R;"
             "esito2;R2;fill2;spread_fill2;mae2_R;mfe2_R;mae_R;mfe_R;attesa_min;durata_min;chiusura_server;fonte;parametri;versione")
HDR_TRIG = ("barra_tf;valutato_server;simbolo;tf;lato;dist_atr;dist_live_atr;conc_htf;htf;dist_htf_atr;"
            "spread_pts;stop_pts;stop_su_spread;costo_ok;stato;id;parametri;versione")
HDR_IMB = ("giorno;simbolo;tf;valutate;non_pronte;fuori_fascia;lato_spento;ema14_contraria;trigger;"
           "armati;occupati;rifiutati;persi_ritardo;persi_spento")

# classi = le tre liste di default della dashboard v4.03
FOREX = set("EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,"
            "AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY".split(","))
INDICI = set("D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY".split(","))
METALLI = set("XAUUSD,XAGUSD".split(","))
ORDINE_TF = {"M5": 0, "M15": 1, "M30": 2, "H1": 3, "H4": 4, "D1": 5}


def classe(sym):
    for nome, ins in (("FOREX", FOREX), ("INDICI", INDICI), ("METALLI", METALLI)):
        if any(sym.startswith(x) for x in ins):
            return nome
    return "ALTRO"


def tempo(s):
    s = (s or "").strip()
    if not s:
        return None
    for f in ("%Y.%m.%d %H:%M:%S", "%Y.%m.%d %H:%M", "%Y.%m.%d"):
        try:
            return dt.datetime.strptime(s, f)
        except ValueError:
            pass
    return None


def num(s, default=float("nan")):
    try:
        return float(s)
    except (TypeError, ValueError):
        return default


# ------------------------------------------------------------------ lettura
def leggi_csv(pattern_files, hdr_atteso):
    righe, problemi = [], []
    cols = hdr_atteso.split(";")
    for fn in sorted(pattern_files):
        with open(fn, newline="", encoding="latin-1") as f:
            rd = csv.reader(f, delimiter=";")
            hdr = None
            for rr in rd:
                if not rr or all(not x.strip() for x in rr):
                    continue
                if rr[0] == cols[0]:
                    hdr = rr
                    if hdr != cols:
                        problemi.append("%s: intestazione diversa da quella attesa" % os.path.basename(fn))
                    continue
                if hdr is None:
                    problemi.append("%s: riga prima dell'intestazione" % os.path.basename(fn))
                    continue
                if len(rr) != len(hdr):
                    problemi.append("%s: riga con %d campi invece di %d" % (os.path.basename(fn), len(rr), len(hdr)))
                    continue
                righe.append(dict(zip(hdr, rr)))
    return righe, problemi


def carica(cartella):
    es, p1 = leggi_csv(glob.glob(os.path.join(cartella, "ombra_esiti_*.csv")), HDR_ESITI)
    tr, p2 = leggi_csv(glob.glob(os.path.join(cartella, "ombra_trigger_*.csv")), HDR_TRIG)
    im, p3 = leggi_csv(glob.glob(os.path.join(cartella, "ombra_imbuto_*.csv")), HDR_IMB)
    # anti-duplicato: lo stesso setup puo' essere scritto due volte se il terminale cade fra
    # la riga e il salvataggio dello stato (scelta voluta dell'EA: meglio un doppione che una perdita)
    visti, esiti, dup_e = set(), [], 0
    for r in es:
        if r["id"] in visti:
            dup_e += 1
            continue
        visti.add(r["id"])
        esiti.append(r)
    vt, trig, dup_t = set(), [], 0
    for r in tr:
        k = (r["simbolo"], r["tf"], r["barra_tf"])
        if k in vt:
            dup_t += 1
            continue
        vt.add(k)
        trig.append(r)
    vi, imb, dup_i = set(), [], 0
    for r in im:
        k = (r["giorno"], r["simbolo"], r["tf"])
        if k in vi:
            dup_i += 1
            continue
        vi.add(k)
        imb.append(r)
    return dict(esiti=esiti, trigger=trig, imbuto=imb, dup=(dup_e, dup_t, dup_i), problemi=p1 + p2 + p3)


# ------------------------------------------------------------------ statistiche
def pf(r):
    pos = float(np.sum(r[r > 0])) if r.size else 0.0
    neg = float(-np.sum(r[r < 0])) if r.size else 0.0
    if neg == 0.0:
        return float("inf") if pos > 0 else float("nan")
    return pos / neg


def dd_r(r_in_ordine):
    """drawdown massimo della curva cumulata in R (il picco parte da 0)."""
    cum, picco, dd = 0.0, 0.0, 0.0
    for x in r_in_ordine:
        cum += x
        picco = max(picco, cum)
        dd = max(dd, picco - cum)
    return dd


def nb_per_k(K):
    """repliche necessarie perche' la correzione per K sia RAGGIUNGIBILE: il p minimo del bootstrap e'
    1/(nb+1), e serve p_min x K <= ALFA con margine x20 (altrimenti EFFETTO e' impossibile per costruzione,
    non per i dati: difetto trovato col contro-esempio T8c il 05/10)."""
    return int(min(200000, max(N_BOOT, math.ceil(20.0 * max(1, K) / ALFA))))


def bootstrap(R, giorni, rng, nb=N_BOOT, blocco=5000):
    """bootstrap a blocchi di giorno della media R. Ritorna lo, hi (IC95), q025, q975 (null centrato),
    p_alto = P(null >= media), p_basso = P(null <= media), M = giorni distinti. A pezzi da 'blocco'."""
    R = np.asarray(R, dtype=float)
    um, inv = np.unique(np.asarray(giorni), return_inverse=True)
    M = len(um)
    media = float(R.mean())
    s = np.bincount(inv, weights=R, minlength=M)
    c = np.bincount(inv, minlength=M).astype(float)
    s0 = s - c * media
    ms, m0s = [], []
    fatti = 0
    while fatti < nb:
        q = min(blocco, nb - fatti)
        W = rng.multinomial(M, np.full(M, 1.0 / M), size=q).astype(float)
        den = W @ c
        ok = den > 0
        ms.append((W @ s)[ok] / den[ok])
        m0s.append((W @ s0)[ok] / den[ok])
        fatti += q
    m = np.concatenate(ms)
    m0 = np.concatenate(m0s)
    lo, hi = float(np.quantile(m, 0.025)), float(np.quantile(m, 0.975))
    q025, q975 = float(np.quantile(m0, 0.025)), float(np.quantile(m0, 0.975))
    p_alto = (float(np.sum(m0 >= media)) + 1.0) / (m0.size + 1.0)
    p_basso = (float(np.sum(m0 <= media)) + 1.0) / (m0.size + 1.0)
    return dict(lo=lo, hi=hi, q025=q025, q975=q975, p_alto=p_alto, p_basso=p_basso, M=M)


def verdetto(n, M, media, b, K):
    if n < N_MIN:
        return "NON ANCORA MISURATO", "n %d < %d" % (n, N_MIN)
    if M < GIORNI_MIN:
        return "NON ANCORA MISURATO", "solo %d giorni distinti (< %d)" % (M, GIORNI_MIN)
    K = max(1, K)
    if media > b["q975"] and media >= SOGLIA_EFF and b["lo"] > 0:
        if b["p_alto"] * K <= ALFA:
            return "EFFETTO", "p %.4f x K %d <= %.2f" % (b["p_alto"], K, ALFA)
        return "ZONA GRIGIA", "EFFETTO che non regge la correzione: p %.4f x K %d > %.2f" % (b["p_alto"], K, ALFA)
    if media < b["q025"] and media <= -SOGLIA_EFF and b["hi"] < 0:
        if b["p_basso"] * K <= ALFA:
            return "CONTRARIO", "p %.4f x K %d <= %.2f" % (b["p_basso"], K, ALFA)
        return "ZONA GRIGIA", "CONTRARIO che non regge la correzione: p %.4f x K %d" % (b["p_basso"], K)
    if abs(media) < SOGLIA_NULLO and b["q025"] <= media <= b["q975"] and (b["hi"] - b["lo"]) / 2 <= SEMI_MAX:
        return "NULLO", "dentro il null e preciso"
    return "ZONA GRIGIA", "ne' effetto ne' nullo preciso"


def riempito(r):
    return r["esito"] != "NON_RIEMPITO"


def misura_gruppo(righe, rng, nb=N_BOOT):
    """righe = esiti di un gruppo (gia' filtrati per costo). Ritorna il dizionario delle metriche."""
    arm = len(righe)
    rr = [r for r in righe if riempito(r)]
    rr.sort(key=lambda r: (tempo(r["chiusura_server"]) or dt.datetime.min, r["id"]))
    R = np.array([num(r["R_finale"], 0.0) for r in rr], dtype=float)
    giorni = [(tempo(r["data_arm_server"]) or dt.datetime.min).date().isoformat() for r in rr]
    out = dict(armati=arm, n=len(rr), riemp=(len(rr) / arm) if arm else float("nan"))
    out["pf"] = pf(R)
    out["wr"] = float(np.mean(R > 0)) if R.size else float("nan")
    out["media"] = float(R.mean()) if R.size else float("nan")
    out["dd"] = dd_r(R)
    for lato in ("LONG", "SHORT"):
        Rl = np.array([num(r["R_finale"], 0.0) for r in rr if r["lato"] == lato], dtype=float)
        out["n_" + lato] = int(Rl.size)
        out["pf_" + lato] = pf(Rl)
        out["media_" + lato] = float(Rl.mean()) if Rl.size else float("nan")
    esiti = {}
    for r in rr:
        esiti[r["esito"]] = esiti.get(r["esito"], 0) + 1
    out["esiti"] = esiti
    if R.size >= 2:
        out["b"] = bootstrap(R, giorni, rng, nb=nb)
        out["M"] = out["b"]["M"]
    else:
        out["b"] = None
        out["M"] = len(set(giorni))
    return out


def tabella(esiti, chiave, rng, titolo):
    gruppi = {}
    for r in esiti:
        gruppi.setdefault(chiave(r), []).append(r)
    # K si conosce PRIMA del bootstrap (dipende solo da n e dai giorni): serve a dimensionare le repliche
    def giudicabile(rr):
        piene = [r for r in rr if riempito(r)]
        gg = set((tempo(r["data_arm_server"]) or dt.datetime.min).date() for r in piene)
        return len(piene) >= N_MIN and len(gg) >= GIORNI_MIN
    K = sum(1 for k in gruppi if giudicabile(gruppi[k]))
    nb = nb_per_k(K)
    righe = []
    for k in sorted(gruppi, key=lambda x: tuple(str(v) for v in x)):
        m = misura_gruppo(gruppi[k], rng, nb=nb if giudicabile(gruppi[k]) else N_BOOT)
        m["chiave"] = k
        righe.append(m)
    for m in righe:
        if m["b"] is None:
            m["verdetto"], m["motivo"] = "NON ANCORA MISURATO", "n %d" % m["n"]
        else:
            m["verdetto"], m["motivo"] = verdetto(m["n"], m["M"], m["media"], m["b"], K)
        m["merito"] = "MERITO: NON ANCORA MISURATO" if m["verdetto"] == "NON ANCORA MISURATO" else "MERITO: " + m["verdetto"]
    return dict(titolo=titolo, righe=righe, K=K)


def fmt(x, d=2):
    if x is None or (isinstance(x, float) and math.isnan(x)):
        return "nd"
    if isinstance(x, float) and math.isinf(x):
        return "inf"
    return ("%." + str(d) + "f") % x


def stampa_tabella(t, out=sys.stdout):
    print("\n## %s   (K giudicabili = %d; regole: n>=%d, giorni>=%d, Bonferroni su K)" % (t["titolo"], t["K"], N_MIN, GIORNI_MIN), file=out)
    print("gruppo | armati | n | riemp | PF_R | WR | media_R | DD_R (RISCHIO) | L n/PF/media | S n/PF/media | "
          "null q97.5 | IC95 | p | verdetto | motivo", file=out)
    for m in t["righe"]:
        b = m["b"]
        print("%s | %d | %d | %s | %s | %s | %s | %s | %d/%s/%s | %d/%s/%s | %s | %s | %s | %s | %s" % (
            " ".join(str(x) for x in m["chiave"]), m["armati"], m["n"], fmt(m["riemp"]), fmt(m["pf"]), fmt(m["wr"]),
            fmt(m["media"], 3), fmt(m["dd"]),
            m["n_LONG"], fmt(m["pf_LONG"]), fmt(m["media_LONG"], 3), m["n_SHORT"], fmt(m["pf_SHORT"]), fmt(m["media_SHORT"], 3),
            fmt(b["q975"], 3) if b else "nd", ("%s..%s" % (fmt(b["lo"], 3), fmt(b["hi"], 3))) if b else "nd",
            fmt(b["p_alto"], 4) if b else "nd", m["verdetto"], m["motivo"]), file=out)


def scrivi_tabella_csv(t, fn):
    with open(fn, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, delimiter=";")
        w.writerow(["gruppo", "armati", "n", "riempimento", "pf_R", "win_rate", "media_R", "dd_R",
                    "n_long", "pf_long", "media_long", "n_short", "pf_short", "media_short",
                    "giorni", "null_q025", "null_q975", "ic_lo", "ic_hi", "p_alto", "K", "verdetto", "merito", "motivo", "esiti"])
        for m in t["righe"]:
            b = m["b"] or {}
            w.writerow([" ".join(str(x) for x in m["chiave"]), m["armati"], m["n"], fmt(m["riemp"], 4), fmt(m["pf"], 4),
                        fmt(m["wr"], 4), fmt(m["media"], 4), fmt(m["dd"], 4), m["n_LONG"], fmt(m["pf_LONG"], 4),
                        fmt(m["media_LONG"], 4), m["n_SHORT"], fmt(m["pf_SHORT"], 4), fmt(m["media_SHORT"], 4),
                        m["M"], fmt(b.get("q025"), 4), fmt(b.get("q975"), 4), fmt(b.get("lo"), 4), fmt(b.get("hi"), 4),
                        fmt(b.get("p_alto"), 5), t["K"], m["verdetto"], m["merito"], m["motivo"],
                        " ".join("%s=%d" % kv for kv in sorted(m["esiti"].items()))])


def conc_segno(r):
    c = r.get("conc_htf", "")
    return c[-1] if c else "?"


# ------------------------------------------------------------------ frequenza e quadratura
def frequenza(dati, esiti_usati):
    """per simbolo x TF: giorni coperti, trigger/giorno, setup riempiti/giorno, giorni per arrivare a n=150."""
    giorni = {}
    for r in dati["imbuto"]:
        if int(num(r["valutate"], 0)) > 0:
            giorni.setdefault((r["simbolo"], r["tf"]), set()).add(r["giorno"])
    trig = {}
    for r in dati["trigger"]:
        trig.setdefault((r["simbolo"], r["tf"]), []).append(r)
    riemp = {}
    for r in esiti_usati:
        if riempito(r):
            riemp[(r["simbolo"], r["tf"])] = riemp.get((r["simbolo"], r["tf"]), 0) + 1
    out = []
    for k in sorted(set(trig) | set(riemp) | set(giorni), key=lambda x: (x[0], ORDINE_TF.get(x[1], 9))):
        if k in giorni:
            g = len(giorni[k])
            fonte = "imbuto"
        else:
            ts = [tempo(r["barra_tf"]) for r in trig.get(k, []) if tempo(r["barra_tf"])]
            g = ((max(ts) - min(ts)).days + 1) if ts else 0
            fonte = "arco trigger"
        nt = len(trig.get(k, []))
        nr = riemp.get(k, 0)
        rate = nr / g if g else float("nan")
        serve = (N_MIN / rate) if (g and rate > 0) else float("inf")
        out.append(dict(sym=k[0], tf=k[1], giorni=g, fonte=fonte, trig_g=(nt / g) if g else float("nan"),
                        riemp_g=rate, n=nr, giorni_150=serve,
                        flag=("ENTRO 3 MESI" if serve <= GIORNI_ORIZZONTE else "OLTRE 3 MESI")))
    return out


def quadratura(imbuto):
    rotte = []
    for r in imbuto:
        v = [int(num(r[c], 0)) for c in HDR_IMB.split(";")[3:]]
        val, nd, fa, la, e14, tr, ar, oc, ri, rt, _sp = v
        if val != nd + fa + la + e14 + tr or tr != ar + oc + ri + rt:
            rotte.append((r["giorno"], r["simbolo"], r["tf"]))
    return rotte


# ------------------------------------------------------------------ rapporto
def rapporto(cartella, out_dir=None, includi_sotto=False, out=sys.stdout):
    dati = carica(cartella)
    rng = np.random.default_rng(SEME)
    es = dati["esiti"]
    usati = es if includi_sotto else [r for r in es if r["costo_ok"] == "1"]
    sotto = [r for r in es if r["costo_ok"] != "1"]
    print("# OMBRA EMA200 -- lettura di %s" % cartella, file=out)
    print("esiti %d (doppioni tolti %d), trigger %d (doppioni %d), righe imbuto %d (doppioni %d)" % (
        len(es), dati["dup"][0], len(dati["trigger"]), dati["dup"][1], len(dati["imbuto"]), dati["dup"][2]), file=out)
    for p in dati["problemi"][:20]:
        print("PROBLEMA: " + p, file=out)
    param = sorted(set(r["parametri"] for r in es))
    if len(param) > 1:
        print("ATTENZIONE: %d set di parametri diversi nei CSV: le tabelle li MESCOLANO. %s" % (len(param), param), file=out)
    fonti = {}
    for r in es:
        fonti[r["fonte"]] = fonti.get(r["fonte"], 0) + 1
    print("fonte dei prezzi simulati: %s (M1 = ripiego conservativo, BUCO = tratto senza dati)" % fonti, file=out)
    print("setup %s; sotto frontiera di costo (stop < 40 x spread) e quindi %s: %d" % (
        "TUTTI" if includi_sotto else "solo costo_ok=1", "INCLUSI" if includi_sotto else "ESCLUSI", len(sotto)), file=out)
    rotte = quadratura(dati["imbuto"])
    print("quadratura imbuto: %d righe rotte su %d %s" % (len(rotte), len(dati["imbuto"]), rotte[:5]), file=out)
    stati = {}
    for r in dati["trigger"]:
        stati[r["stato"]] = stati.get(r["stato"], 0) + 1
    print("trigger per stato: %s" % stati, file=out)

    tabs = [
        tabella(usati, lambda r: (r["simbolo"], r["tf"], r["htf"] + conc_segno(r)), rng,
                "DOVE FUNZIONA: simbolo x TF x concordanza col TF superiore"),
        tabella(usati, lambda r: (r["simbolo"], r["tf"]), rng, "simbolo x TF (concordanza insieme)"),
        tabella(usati, lambda r: (r["tf"],), rng, "FAMIGLIA per TF (tutti i simboli: dice se il motore ha qualcosa, NON dove)"),
        tabella(usati, lambda r: (r["tf"], r["htf"] + conc_segno(r)), rng, "FAMIGLIA per TF x concordanza"),
        tabella(usati, lambda r: (classe(r["simbolo"]), r["tf"]), rng, "classe x TF"),
    ]
    for t in tabs:
        stampa_tabella(t, out)
    print("\n## sotto frontiera di costo (solo descrittivo, nessun verdetto)", file=out)
    g = {}
    for r in sotto:
        g.setdefault((r["simbolo"], r["tf"]), []).append(r)
    for k in sorted(g):
        rr = [num(x["R_finale"], 0.0) for x in g[k] if riempito(x)]
        rat = [num(x["stop_su_spread"]) for x in g[k] if x["stop_su_spread"]]
        print("%s %s | armati %d | riempiti %d | media R %s | stop/spread mediano %s" % (
            k[0], k[1], len(g[k]), len(rr), fmt(float(np.mean(rr)) if rr else float("nan"), 3),
            fmt(float(np.median(rat)) if rat else float("nan"), 1)), file=out)
    print("\n## frequenza: quanto manca a n=%d per simbolo x TF (dai dati, non da stime)" % N_MIN, file=out)
    fr = frequenza(dati, usati)
    for f in fr:
        print("%s %s | giorni %d (%s) | trigger/g %s | riempiti/g %s | n %d | giorni per n=%d %s | %s" % (
            f["sym"], f["tf"], f["giorni"], f["fonte"], fmt(f["trig_g"]), fmt(f["riemp_g"], 3), f["n"], N_MIN,
            fmt(f["giorni_150"], 0), f["flag"]), file=out)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
        for i, t in enumerate(tabs):
            scrivi_tabella_csv(t, os.path.join(out_dir, "ombra_tabella_%d.csv" % (i + 1)))
    return dict(dati=dati, tabelle=tabs, frequenza=fr)


# ------------------------------------------------------------------ AUTOTEST
def _hdr_dal_sorgente():
    """estrae le tre intestazioni da Hdr() del sorgente MQL5 (concatenazioni di stringhe)."""
    qui = os.path.dirname(os.path.abspath(__file__))
    fn = os.path.join(qui, "..", "mql5", "Experts", "ABTG_EMA200_Ombra.mq5")
    if not os.path.exists(fn):
        return None
    src = open(fn, encoding="latin-1").read()
    a = src.find("string Hdr(const int k)")
    b = src.find("bool AppendLine", a)
    corpo = src[a:b]
    blocchi = re.split(r"\breturn\b", corpo)[1:]
    out = []
    for bl in blocchi:
        bl = bl.split(";\n")[0]
        out.append("".join(re.findall(r'"((?:[^"\\]|\\.)*)"', bl)))
    return out


def _riga_esito(i, sym, tf, lato, conc, R, giorno, costo="1", esito=None, ora=10):
    t = dt.datetime(2026, 1, 1, ora, 0, 0) + dt.timedelta(days=giorno)
    ts = t.strftime("%Y.%m.%d %H:%M:%S")
    tc = (t + dt.timedelta(hours=3)).strftime("%Y.%m.%d %H:%M:%S")
    if esito is None:
        esito = "TP" if R > 0 else "SL"
    v = {c: "" for c in HDR_ESITI.split(";")}
    v.update(id="%s_%s_%d_%s" % (sym, tf, i, lato[0]), data_arm_server=ts, barra_tf=ts, simbolo=sym, tf=tf, lato=lato,
             conc_htf=conc, htf=conc[:-1], costo_ok=costo, esito=esito, R_finale="%.4f" % R, chiusura_server=tc,
             fonte="TICK", parametri="P", versione="1.00", stop_su_spread="55.0")
    return ";".join(v[c] for c in HDR_ESITI.split(";"))


def _scrivi(cartella, nome, hdr, righe):
    with open(os.path.join(cartella, nome), "w", encoding="latin-1", newline="") as f:
        f.write(hdr + "\r\n")
        for r in righe:
            f.write(r + "\r\n")


def _campione(rng, n, p_vince, giorni):
    """payoff della cella: -1 R (SL) o +2 R (TP). Media = 3 p - 1 (nulla a p = 1/3)."""
    R = np.where(rng.random(n) < p_vince, 2.0, -1.0)
    g = rng.integers(0, giorni, size=n)
    return R, g


def autotest():
    ok_tot, ko = 0, []

    def chk(nome, cond, info=""):
        nonlocal ok_tot
        if cond:
            ok_tot += 1
            print("OK   " + nome + ("  [" + info + "]" if info else ""))
        else:
            ko.append(nome)
            print("KO   " + nome + ("  [" + info + "]" if info else ""))

    rng = np.random.default_rng(12345)

    # T1 le intestazioni del lettore sono quelle dell'EA (se l'EA cambia una colonna, il lettore lo vede)
    hs = _hdr_dal_sorgente()
    if hs is None:
        chk("T1 intestazioni EA == lettore (sorgente .mq5 non trovato)", False)
    else:
        chk("T1a intestazione esiti identica a Hdr() dell'EA", hs[0] == HDR_ESITI)
        chk("T1b intestazione trigger identica a Hdr() dell'EA", hs[1] == HDR_TRIG)
        chk("T1c intestazione imbuto identica a Hdr() dell'EA", hs[2] == HDR_IMB)
        # l'estrattore non e' vuoto: se leggesse stringhe vuote T1 fallirebbe comunque, ma lo si dice
        chk("T1d estrattore non banale (46/18/14 colonne)",
            [len(h.split(";")) for h in hs] == [46, 18, 14], str([len(h.split(";")) for h in hs]))

    # T2 cella SENZA vantaggio (p = 1/3 -> media 0): non deve uscire EFFETTO
    R, g = _campione(rng, 400, 1.0 / 3.0, 200)
    b = bootstrap(R, g, np.random.default_rng(1))
    v, _ = verdetto(len(R), b["M"], float(R.mean()), b, 1)
    chk("T2 null n=400: non EFFETTO", v != "EFFETTO", "media %.3f verdetto %s" % (R.mean(), v))

    # T3 ATTESA SCRITTA PRIMA: la banda del null a n=400 e' 1,96 x sd/radice(n) = 1,96 x 1,414/20 = 0,139.
    #    Contro-esempio: se la banda fosse calcolata SENZA centrare, la sua meta' alta starebbe sulla media
    #    del campione e non a ~+0,139 attorno a 0.
    semi = (b["q975"] - b["q025"]) / 2.0
    chk("T3 banda del null attorno a 0 e larga come attesa (0,139 +/- 25%)",
        abs((b["q975"] + b["q025"]) / 2.0) < 0.02 and 0.104 <= semi <= 0.174, "centro %.4f semi %.4f" % ((b["q975"] + b["q025"]) / 2.0, semi))

    # T4 vantaggio PIANTATO (p = 0,55 -> media +0,65): EFFETTO a n=400, K=1
    R, g = _campione(rng, 400, 0.55, 200)
    b = bootstrap(R, g, np.random.default_rng(2))
    v, _ = verdetto(len(R), b["M"], float(R.mean()), b, 1)
    chk("T4 piantato n=400: EFFETTO", v == "EFFETTO", "media %.3f" % R.mean())

    # T5 lo stesso vantaggio su n=100: NON ANCORA MISURATO (mai EFFETTO su campione sottile)
    R, g = _campione(rng, 100, 0.55, 80)
    b = bootstrap(R, g, np.random.default_rng(3))
    v, _ = verdetto(len(R), b["M"], float(R.mean()), b, 1)
    chk("T5 piantato n=100: NON ANCORA MISURATO", v == "NON ANCORA MISURATO", v)

    # T6 perdente piantato (p = 0,15 -> media -0,55): CONTRARIO
    R, g = _campione(rng, 300, 0.15, 150)
    b = bootstrap(R, g, np.random.default_rng(4))
    v, _ = verdetto(len(R), b["M"], float(R.mean()), b, 1)
    chk("T6 perdente piantato n=300: CONTRARIO", v == "CONTRARIO", "media %.3f" % R.mean())

    # T7 campione concentrato in 3 giorni: NON ANCORA MISURATO anche se il vantaggio c'e'
    R, g = _campione(rng, 300, 0.55, 3)
    b = bootstrap(R, g, np.random.default_rng(5))
    v, _ = verdetto(len(R), b["M"], float(R.mean()), b, 1)
    chk("T7 n=300 in 3 giorni: NON ANCORA MISURATO", v == "NON ANCORA MISURATO", v)

    # T8 CONTRO-ESEMPIO della correzione per K: 200 celle SENZA vantaggio a n=150.
    #    Senza correzione (K=1) ci si aspettano ~2,5% x 200 = ~5 falsi EFFETTO (meno, perche' serve anche
    #    media >= +0,10). Con K=200 l'attesa e' 0,05 in tutto: si accetta al massimo 1.
    #    Le repliche sono quelle che il lettore usa davvero per K=100 (nb_per_k), altrimenti il test
    #    passerebbe per RISOLUZIONE (p minimo x K > 0,05) e non per merito della correzione.
    KT = 100
    nbK = nb_per_k(KT)
    falsi1, falsiK = 0, 0
    rr = np.random.default_rng(77)
    for _ in range(KT):
        R, g = _campione(rr, 150, 1.0 / 3.0, 60)
        b = bootstrap(R, g, rr, nb=nbK)
        if verdetto(len(R), b["M"], float(R.mean()), b, 1)[0] == "EFFETTO":
            falsi1 += 1
        if verdetto(len(R), b["M"], float(R.mean()), b, KT)[0] == "EFFETTO":
            falsiK += 1
    chk("T8a %d celle nulle, SENZA correzione: compaiono falsi EFFETTO (il pericolo e' reale)" % KT, falsi1 >= 1, "falsi %d" % falsi1)
    chk("T8b %d celle nulle, CON correzione K=%d: al massimo 1 falso EFFETTO" % (KT, KT), falsiK <= 1, "falsi %d" % falsiK)
    # T8c CONTRO-ESEMPIO della risoluzione: con le repliche di nb_per_k un vantaggio vero DEVE ancora
    #     poter uscire EFFETTO a K=100; con 4000 repliche fisse NO (p minimo 1/4001 x 100 = 0,025 ... al
    #     limite; a K=240, la tabella piena, 240/4001 = 0,06 > 0,05: EFFETTO impossibile).
    R, g = _campione(np.random.default_rng(8), 400, 0.55, 200)
    b = bootstrap(R, g, np.random.default_rng(9), nb=nb_per_k(240))
    chk("T8c vantaggio vero a K=240 con nb_per_k: EFFETTO raggiungibile", verdetto(len(R), b["M"], float(R.mean()), b, 240)[0] == "EFFETTO",
        "nb %d p %.6f" % (nb_per_k(240), b["p_alto"]))
    b4 = bootstrap(R, g, np.random.default_rng(9), nb=N_BOOT)
    chk("T8d stesso campione, 4000 repliche fisse a K=240: EFFETTO IMPOSSIBILE (il difetto che nb_per_k toglie)",
        verdetto(len(R), b4["M"], float(R.mean()), b4, 240)[0] != "EFFETTO", "p_min x K = %.4f" % (240.0 / (N_BOOT + 1)))

    # T9 DD in R su una sequenza nota: +1 -1 -1 +2 -3 +1 -> cumulata 1,0,-1,1,-2,-1 -> DD = 1 - (-2) = 3
    chk("T9 DD in R", abs(dd_r([1, -1, -1, 2, -3, 1]) - 3.0) < 1e-12)
    # T10 PF in R: +2 -1 -1 -> 1,0
    chk("T10 PF in R", abs(pf(np.array([2.0, -1.0, -1.0])) - 1.0) < 1e-12)

    # T11-T14 su CSV veri scritti con l'intestazione dell'EA
    with tempfile.TemporaryDirectory() as d:
        righe = []
        rs = np.random.default_rng(9)
        for i in range(200):
            R = 2.0 if rs.random() < 0.6 else -1.0
            righe.append(_riga_esito(i, "U30USD", "H1", "LONG" if i % 2 else "SHORT", "H4+", R, i % 100))
        righe.append(righe[0])                                                     # doppione
        for i in range(30):
            righe.append(_riga_esito(1000 + i, "U30USD", "H1", "LONG", "H4+", 0.0, i, esito="NON_RIEMPITO"))
        for i in range(40):
            righe.append(_riga_esito(2000 + i, "U30USD", "H1", "LONG", "H4+", -1.0, i, costo="0"))
        _scrivi(d, "ombra_esiti_202601.csv", HDR_ESITI, righe)
        _scrivi(d, "ombra_trigger_202601.csv", HDR_TRIG, [])
        imb = ["2026.01.01;U30USD;H1;24;0;10;0;4;10;6;3;1;0;0",     # quadra
               "2026.01.02;U30USD;H1;24;0;10;0;4;10;6;3;0;0;0"]     # rotta: 6+3+0+0 != 10
        _scrivi(d, "ombra_imbuto_202601.csv", HDR_IMB, imb)
        with open(os.devnull, "w") as nul:
            res = rapporto(d, out=nul)
        t1 = res["tabelle"][1]
        m = [x for x in t1["righe"] if x["chiave"] == ("U30USD", "H1")][0]
        chk("T11 doppione tolto", res["dati"]["dup"][0] == 1)
        chk("T12 NON_RIEMPITO fuori da n, dentro gli armati", m["n"] == 200 and m["armati"] == 230, "n %d armati %d" % (m["n"], m["armati"]))
        chk("T13 sotto frontiera ESCLUSI dalla tabella principale", all(x["n"] <= 200 for x in t1["righe"]))
        chk("T14 quadratura imbuto: trovata la riga rotta", len(quadratura(res["dati"]["imbuto"])) == 1)
        chk("T15 colonna RISCHIO presente anche dove il merito non e' misurato",
            all(not math.isnan(x["dd"]) for x in t1["righe"]))

    print("\nAUTOTEST: %d OK, %d KO %s" % (ok_tot, len(ko), ko if ko else ""))
    return 0 if not ko else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cartella", nargs="?", help="cartella con i CSV ombra_*.csv")
    ap.add_argument("--out", help="cartella dove scrivere le tabelle in CSV")
    ap.add_argument("--includi-sotto-frontiera", action="store_true", help="giudica anche i setup con stop < 40 x spread")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(autotest())
    if not a.cartella:
        ap.error("serve la cartella (oppure --autotest)")
    rapporto(a.cartella, a.out, a.includi_sotto_frontiera)


if __name__ == "__main__":
    main()
