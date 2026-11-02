#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""scenari_aggregatore.py - scenari SINTETICI di JSON (formato run_test.py) con esito scritto a mano; confronto fra
agg_indipendente.py (A7) e agents/A4/agg_conferma.py (eseguito come programma, senza leggerne il codice prima).
Uso: python3 -I scenari_aggregatore.py   (nessun CSV)"""
import copy, json, os, re, subprocess, sys, tempfile
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import agg_indipendente as AI
BB = os.path.abspath(os.path.join(HERE, "..", ".."))
TEMPLATE = json.load(open(os.path.join(BB, "final/run_forex/EURUSD.json")))
HASH_V2 = os.path.join(BB, "congelati/HASH_CODICE_V2.txt"); CRITERI = os.path.join(BB, "congelati/criteri_conferma_forex_v1.md")
AGG = os.path.join(BB, "agents/A4/agg_conferma.py")
OLD = {"2013": "2015", "2018": "2017", "2020": "2019", "2025-26": "2022"}


def rename(o):
    if isinstance(o, dict):
        return {ren(k): rename(v) for k, v in o.items()}
    if isinstance(o, list): return [rename(v) for v in o]
    return o


def ren(k):
    k = str(k)
    for a, b in OLD.items():
        if k == a: return b
        if k.endswith("_" + a): return k[: -len(a)] + b
        if k.endswith("_" + a + ".csv"): return k[: -len(a) - 4] + b + ".csv"
    return k


def trade(R, D, c, week, per, var, side):
    t = copy.deepcopy(TEMPLATE["tabelle"]["LOG_TRADE"]["CONT_H1_2013"][0])
    t.update(R=R, R_lordo=R + 0.02, D_atr=D, c_atr=c, costo_spread_R=0.02, periodo=per, variante=var, tf="H1", side=side, settimana=week,
             entry_time=(week * 7 - 3 + 2) * 1440 + 600, exit_time=(week * 7 - 3 + 2) * 1440 + 700)
    return t


def cell(trs, base):
    if not trs: return {"n": 0, "per_motivo": {}}
    c = dict(base); R = np.array([t["R"] for t in trs])
    g = R[R > 0].sum(); p = -R[R < 0].sum()
    c.update(n=len(trs), vincite=int((R > 0).sum()), win_pct=100.0 * float((R > 0).mean()), attesa_R=float(R.mean()), netto_R=float(R.sum()),
             pf_netto=("inf" if p == 0 else float(g / p)), mediana_R=float(np.median(R)),
             pareggio_atteso_medio_pct=100.0 * float(np.mean([(3 + t["c_atr"]) / (3 + t["D_atr"]) for t in trs])), per_motivo={"TP": int((R > 0).sum()), "SL": int((R <= 0).sum())})
    return c


def costruisci(sym, trades, anni=AI.ANNI, mod=None):
    """trades: lista (R, D, c, week) in ordine; periodo/variante/lato assegnati a rotazione."""
    j = rename(copy.deepcopy(TEMPLATE)); T = j["tabelle"]
    I = j["intestazione"]; I["simbolo"] = sym
    I["sha256_csv"] = {a: "%064x" % (i + 1) for i, a in enumerate(anni)}; I["righe_csv"] = {a: 1000 for a in anni}
    I["righe_attese_A3"] = {a: None for a in anni}; I["righe_coincidono_con_A3"] = {a: None for a in anni}
    I["hash_dati_coincidono"] = {"ABTG_M1_%s_%s.csv" % (sym, a): True for a in anni}
    log = {"%s_%s_%s" % (v, tf, a): [] for v in ("CONT", "INV") for tf in ("H1", "M30") for a in anni}
    for i, (R, D, c, w) in enumerate(trades):
        per = anni[i % 4]; var = "CONT" if i % 3 else "INV"
        log["%s_H1_%s" % (var, per)].append(trade(R, D, c, w, per, var, 1 if i % 2 else -1))
    T["LOG_TRADE"] = log
    t2 = {}
    base = next(iter(T["T2_risultati"].values()))
    for v in ("CONT", "INV"):
        for tf in ("H1", "M30"):
            allv = []
            for a in anni:
                t2["%s_%s_%s" % (v, tf, a)] = cell(log["%s_%s_%s" % (v, tf, a)], base); allv += log["%s_%s_%s" % (v, tf, a)]
            t2["%s_%s_TOTALE" % (v, tf)] = cell(allv, base)
    for tf in ("H1", "M30"):
        t2["POOLED_" + tf] = cell([t for v in ("CONT", "INV") for a in anni for t in log["%s_%s_%s" % (v, tf, a)]], base)
    T["T2_risultati"] = t2
    if mod: mod(j)
    j["sha256_risultati"] = AI.hash_risultati(j)
    return j


# ----------------------------------------------------------------------------- scenari
def wk(pi, i, shared=False): return 2300 + i if shared else 2300 + 100 * pi + i

def per_pair(lists, D=1.0, c=0.0, shared=False):
    """lists: 4 liste di R (una per coppia) -> {sym: trades}"""
    return {s: [(R, D, c, wk(pi, i, shared)) for i, R in enumerate(L)] for pi, (s, L) in enumerate(zip(AI.COPPIE, lists))}

def rep(n_win, w, n_loss, l, pos=None):
    L = [w] * n_win + [l] * n_loss
    if pos is not None:                       # sposta le perdite in posizioni sparse, deterministico
        L = [w] * (n_win + n_loss)
        for k in range(n_loss): L[(3 + 5 * k) % len(L)] = l
    return L

SCEN = []
def add(nome, lists, esito, conds=None, alt=None, D=1.0, c=0.0, shared=False, nota=""):
    SCEN.append(dict(nome=nome, per=per_pair(lists, D, c, shared), esito=esito, conds=conds, alt=alt, nota=nota))

T_ = True; F_ = False
add("01 CONFERMATO", [rep(11, .30, 1, -1.0, 1)] * 4, "CONFERMATO", {"1": T_, "2": T_, "3": T_, "4": T_, "5": T_}, nota="4x12: 11 vincite +0,30, 1 perdita -1,0; settimane distinte")
add("02 INCONCLUSIVO N=28", [[.30] * 7] * 4, "INCONCLUSIVO", {"1": F_}, nota="N=28 <30 anche se tutto positivo")
add("03 N=30 al limite", [[.30] * 8, [.30] * 8, [.30] * 7, [.30] * 7], "CONFERMATO", {"1": T_, "2": T_, "3": T_, "4": T_, "5": T_}, nota="N=30 passa la condizione 1")
add("04 N=29 al limite", [[.30] * 8, [.30] * 7, [.30] * 7, [.30] * 7], "INCONCLUSIVO", {"1": F_}, nota="N=29")
add("05 solo cond.2 falsa (IC90 contiene 0)", [rep(6, .35, 2, -1.0, 1), rep(6, .35, 2, -1.0, 1), rep(7, .35, 1, -1.0, 1), rep(7, .35, 1, -1.0, 1)], "NON DIMOSTRATO",
    {"1": T_, "2": F_, "3": T_, "4": T_, "5": T_}, nota="N=32, 26 vincite +0,35 e 6 perdite -1,0: media 0,097, wr 81,25%")
add("06 solo cond.3 falsa (win rate < pareggio+5)", [rep(8, .9, 4, -.5, 1)] * 4, "NON DIMOSTRATO", {"1": T_, "2": T_, "3": F_, "4": T_, "5": T_},
    nota="wr 66,7% < 80%; media 0,43, IC>0")
add("07 solo cond.4 falsa (una coppia trascina)", [[3.0] * 12] + [rep(10, .1, 2, -2.0, 1)] * 3, "NON DIMOSTRATO", {"1": T_, "2": T_, "3": T_, "4": F_, "5": T_},
    nota="EURUSD +3,0 x12; le altre 3 coppie media -0,25: senza EURUSD la media e negativa")
add("08 solo cond.5 falsa (costo extra annulla)", [rep(20, .12, 4, -.35, 1)] * 4 + [], "NON DIMOSTRATO", {"1": T_, "2": T_, "3": T_, "4": T_, "5": F_}, nota="N=96, media 0,042<0,05; IC [0,01;0,07]")
add("09 NESSUN VANTAGGIO RILEVANTE con IC che contiene 0 (D010)", [[.05, -.05] * 6] * 4, "NESSUN VANTAGGIO RILEVANTE", {"1": T_, "2": F_}, alt="NON DIMOSTRATO",
    nota="media 0, IC90 ~[-0,012;0,012]: prevale NVR su NON DIMOSTRATO")
add("10 NESSUN VANTAGGIO RILEVANTE (media negativa)", [[-.30] * 12] * 4, "NESSUN VANTAGGIO RILEVANTE", {"1": T_, "2": F_}, nota="tutti -0,30")
add("11 NON DIMOSTRATO (IC largo, media <0)", [[1.0] * 6 + [-1.2] * 6] * 4, "NON DIMOSTRATO", {"1": T_, "2": F_}, nota="media -0,1, sd 1,1: IC sup ~0,16>0,05")
add("12 pareggio CON costo (D010)", [rep(11, .25, 1, -1.0, 1)] * 4, "NON DIMOSTRATO", {"1": T_, "2": T_, "3": F_, "4": T_, "5": T_}, D=0.5, c=0.1,
    nota="wr 91,67% >= 90,7% (senza costo) ma < 93,57% (con costo c=0,1): la cond.3 e falsa solo se il costo e nel pareggio")
add("13 blocchi settimanali CONDIVISI fra coppie", [[.3] * 10 + [-.8] * 2] * 4, "NON DIMOSTRATO", {"1": T_, "2": F_, "3": T_, "4": T_, "5": T_}, shared=True,
    nota="12 settimane condivise: con blocchi condivisi lo IC inf e <0; con blocchi per coppia (48) sarebbe >0")
add("14 costo extra: media 0,06 passa", [[.06] * 12] * 4, "CONFERMATO", {"1": T_, "2": T_, "3": T_, "4": T_, "5": T_}, nota="0,06-0,05=0,01>0")
add("15 costo extra: media 0,04 non passa", [[.04] * 12] * 4, "NESSUN VANTAGGIO RILEVANTE", {"1": T_, "2": T_, "3": T_, "4": T_, "5": F_},
    nota="IC sup 0,04<0,05: NVR (precedenza); cond.5 falsa")


def esegui_agg(files, out, extra=()):
    cmd = [sys.executable, "-I", AGG, "--json"] + ["%s=%s" % (s, f) for s, f in files.items()] + ["--out", out, "--hash-codice", HASH_V2, "--criteri", CRITERI] + list(extra)
    p = subprocess.run(cmd, capture_output=True, text=True, env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"))
    try:
        return json.load(open(out + ".json")), p
    except Exception:
        return None, p


def main():
    div = []; righe = []
    with tempfile.TemporaryDirectory() as td:
        for sc in SCEN:
            files = {}
            runs = {}
            for sym, trs in sc["per"].items():
                j = costruisci(sym, trs); runs[sym] = j
                files[sym] = os.path.join(td, "%s_%s.json" % (sc["nome"][:2], sym)); json.dump(j, open(files[sym], "w"))
            mio = AI.calcola(runs)
            sens = {AI.calcola(runs, seed=s)["esito"] for s in range(1, 31)}
            a4, p = esegui_agg(files, os.path.join(td, "out_" + sc["nome"][:2]))
            if a4 is None:
                righe.append((sc["nome"], sc["esito"], mio["esito"], "ERRORE", p.stderr[-200:])); div.append((sc["nome"], "errore esecuzione A4: " + p.stderr[-200:])); continue
            V = a4["VERDETTO"]; c4 = {k.split("_")[0]: v for k, v in V["condizioni"].items()}
            ok_atteso = (mio["esito"] == sc["esito"])
            ok_a4 = (V["esito"] == sc["esito"])
            cond_ok = True
            if sc["conds"]:
                for k, v in sc["conds"].items():
                    cond_ok &= (mio["condizioni"].get(k) == v) and (c4.get(k) == v)
            alt_ok = True if sc["alt"] is None else (V.get("esito_lettura_alternativa_letterale") == sc["alt"] and mio["esito_lettura_alternativa"] == sc["alt"])
            righe.append((sc["nome"], sc["esito"], mio["esito"], V["esito"], "integrita=%s cond_ok=%s alt_ok=%s seed_stabile=%s" % (V["controlli_integrita_ok"], cond_ok, alt_ok, len(sens) == 1)))
            if not (ok_atteso and ok_a4 and cond_ok and alt_ok and V["controlli_integrita_ok"]):
                div.append((sc["nome"], "atteso=%s mio=%s A4=%s cond mio=%s A4=%s alt_A4=%s integrita=%s | %s" % (sc["esito"], mio["esito"], V["esito"], mio["condizioni"], c4, V.get("esito_lettura_alternativa_letterale"), V["controlli_integrita_ok"], sc["nota"])))
            # dettagli numerici: confronto IC e medie
            ic4 = V["ic90"]
            if abs(ic4["ic90_lo"] - mio["ic90"][0]) > 1e-9 or abs(ic4["ic90_hi"] - mio["ic90"][1]) > 1e-9 or abs(V["media_R"] - mio["media"]) > 1e-9 or abs(V["pareggio_atteso_medio_pct"] - mio["pareggio_pct"]) > 1e-9:
                div.append((sc["nome"], "numeri diversi: IC A4 [%.5f,%.5f] mio [%.5f,%.5f]; media %.6f/%.6f; pareggio %.4f/%.4f" % (ic4["ic90_lo"], ic4["ic90_hi"], mio["ic90"][0], mio["ic90"][1], V["media_R"], mio["media"], V["pareggio_atteso_medio_pct"], mio["pareggio_pct"])))
    print("%-62s %-28s %-28s %-28s %s" % ("SCENARIO", "ATTESO (a mano)", "MIO", "A4", "controlli"))
    for r in righe: print("%-62s %-28s %-28s %-28s %s" % r)
    print("\nDIVERGENZE / PROBLEMI: %d" % len(div))
    for d in div: print("  -", d[0], ":", d[1])
    n_ok = sum(1 for r in righe if r[1] == r[2] == r[3])
    print("scenari con atteso = mio = A4: %d/%d" % (n_ok, len(righe)))
    return 0 if not div else 1

if __name__ == "__main__":
    sys.exit(main())
