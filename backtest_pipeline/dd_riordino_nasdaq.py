#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
dd_riordino_nasdaq.py -- ASCII puro. NON e' un metodo nuovo.

COSA FA
  Applica lo STESSO metodo di backtest_pipeline/distribuzione_dd_riordino.py
  (che viene importato, non copiato) alla famiglia
  ABTG_Nasdaq_Apertura_US / NASUSD, che in quel file non c'era.

PERCHE' UN FILE A PARTE
  Lo strumento madre e' gia' passato dal cancello del 18/09 e le sue sei righe
  sono gia' pubblicate: non lo si tocca. Qui si importano le sue funzioni e si
  aggiungono SORGENTI. Nessuna formula viene riscritta.

CONTROLLO DI NON-REGRESSIONE (obbligatorio, gira per primo)
  Prima di qualunque numero nuovo, il wrapper rimisura la sedia
  Dow Apertura 770202 (via 770206) e confronta con i numeri GIA' PUBBLICATI in
  report/IL_DRAWDOWN_CHE_NON_ABBIAMO_MISURATO_2026-09-18.md, riga 1 della
  tabella del paragrafo 5. Se non coincidono, il wrapper ha cambiato qualcosa
  e lo dice.

USO
  python3 backtest_pipeline/dd_riordino_nasdaq.py
  python3 backtest_pipeline/dd_riordino_nasdaq.py --riordini 20000 --blocchi 20000 --avversari 5000
"""

import argparse
import collections
import csv
import os
import random
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)

import distribuzione_dd_riordino as M   # noqa: E402

RADICE = M.RADICE

# ---------------------------------------------------------------- sorgenti
# (etichetta, simbolo, magic della sedia viva, percorso per-trade, magic file)
# Tutte da R84 (ablazione dei filtri del corso, NASUSD, tick reali, dep.10.000,
# InpRiskPercent=1). Le serie per-trade di R84 sono SOLO finestra OOS
# (r84_csv/REFERTO_RACCOLTA_R84.txt: "serie per-trade raccolte: 18 (solo
# finestra OOS)").
R84 = "backtest_pipeline/risultati_archivio/r84_csv/"
SORGENTI_NAS = [
    ("R84-A scheletro nudo", "NASUSD", "770201", R84 + "pertrade_r84a_776010.csv", "776010"),
    ("R84-B volumi",         "NASUSD", "770201", R84 + "pertrade_r84b_776020.csv", "776020"),
    ("R84-C atr",            "NASUSD", "770201", R84 + "pertrade_r84c_776030.csv", "776030"),
    ("R84-D volumi OR atr",  "NASUSD", "770201", R84 + "pertrade_r84d_776040.csv", "776040"),
    ("R84-E ema 14/200",     "NASUSD", "770201", R84 + "pertrade_r84e_776050.csv", "776050"),
    ("R84-F supertrend",     "NASUSD", "770201", R84 + "pertrade_r84f_776060.csv", "776060"),
    ("R84-G supertrend x3",  "NASUSD", "770201", R84 + "pertrade_r84g_776070.csv", "776070"),
    ("R84-H corr SPXUSD",    "NASUSD", "770201", R84 + "pertrade_r84h_776080.csv", "776080"),
    ("R84-I metodo completo", "NASUSD", "770201", R84 + "pertrade_r84i_776090.csv", "776090"),
]

# la sedia gia' pubblicata che serve da controllo di non-regressione
REGRESSIONE = ("Dow_Apertura_US", "U30USD", "770202",
               "backtest_pipeline/risultati_prove/trades_portafoglio/"
               "abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv", "770206")
# numeri pubblicati il 18/09 (referto par.5, riga 1) -- NON ricalcolati qui
ATTESI_DOW = {"n_pos": 96, "dd_osservato": 4.2235, "p95": 8.2421,
              "p99": 9.7253, "rapporto_p95": 1.952}


class Cfg(object):
    pass


def costruisci_cfg(a):
    c = Cfg()
    c.riordini = a.riordini
    c.blocchi = a.blocchi
    c.avversari = a.avversari
    c.seed = a.seed
    c.min_posizioni = a.min_posizioni
    c.modello = "moltiplicativo"
    c.tolleranza = 0.005
    return c


def stampa(e, cfg):
    print("")
    print("### %s  %s  magic sedia viva %s  (per-trade: magic %s)"
          % (e["nome"], e["simbolo"], e["magic_rosa"], e["magic_file"]))
    print("    file: %s" % e["percorso"])
    if "errore" in e:
        print("    ERRORE: %s" % e["errore"])
        return
    print("    posizioni=%d  deal=%d  da %s a %s  profitto=%.2f"
          % (e["n_pos"], e["n_deal"], e["da"], e["a"], e["profitto"]))
    if e.get("tester") is None:
        print("    RIGA DEL TESTER NON TROVATA -> deposito non deducibile."
              " SALTATA.")
        return
    print("    riga del tester: %s (file concordi=%d, varianti DD/PF=%d,"
          " univoca=%s)"
          % (e["tester"]["file"], e["tester"]["n_file"],
             e["tester"]["n_varianti"], e["tester"]["univoca"]))
    print("    tester: Equity DD %%=%.4f  PF=%.5f  InpRiskPercent=%s"
          % (e["dd_tester"], e["pf_tester"], e["rischio_tester"]))
    print("    residuo di abbinamento sul Profit: %+.2f (%+.4f%%) -> %s"
          % (e["tester"]["residuo"], e["tester"]["residuo_rel"],
             "ESATTO" if abs(e["tester"]["residuo"]) < 0.02
             else "NON ESATTO, da dichiarare"))
    print("    deposito dedotto=%.0f" % e["deposito"])
    print("    DD ricalcolato (posizioni chiuse)=%.4f%%  scarto=%+.4f pp"
          " (%+.2f%% relativo)"
          % (e["dd_osservato"], e["scarto_pp"], e["scarto_rel"]))
    print("    peggior giornata: ricalcolata=%.4f%%  tester=%.4f%%"
          % (e["pg_osservata"], e["pg_tester"]))
    print("    ACF P/L lag1..5: " + " ".join("%+.4f" % v for v in e["acf"]))
    print("    corsa perdente max=%d" % e["corsa_perdente_max"])
    if e["n_pos"] < cfg.min_posizioni:
        print("    SOTTO SOGLIA (%d < %d): nessuna distribuzione calcolata."
              % (e["n_pos"], cfg.min_posizioni))
        return
    d = e["dd"]
    print("    DD per riordino iid: mediana=%.4f p90=%.4f p95=%.4f p99=%.4f"
          " max=%.4f" % (d["mediana"], d["p90"], d["p95"], d["p99"], d["max"]))
    print("    RAPPORTO p95/oss=%.3f  p99/oss=%.3f"
          % (e["rapporto_p95"], e["rapporto_p99"]))
    b = e["blocchi"]
    print("    BLOCCHI (len=%d): mediana=%.4f p95=%.4f p99=%.4f max=%.4f"
          % (e["blocchi_len"], b["mediana"], b["p95"], b["p99"], b["max"]))
    verso = "SOTTOSTIMA" if b["p95"] > d["p95"] else "SOVRASTIMA"
    print("    -> il riordino iid %s la coda (p95 blocchi %.4f vs iid %.4f)"
          % (verso, b["p95"], d["p95"]))
    g = e["pg"]
    print("    peggior giornata per riordino: mediana=%.4f p95=%.4f p99=%.4f"
          " peggiore=%.4f" % (g["mediana"], g["p95"], g["p99"], g["peggiore"]))
    print("    quota riordini con giornata <= -5%%: %.4f%%"
          % (e["pg_oltre_5pct"] * 100.0))
    print("    quota riordini iid con DD >= 10%%: %.4f%%"
          % (e["dd_oltre_10pct"] * 100.0))
    print("    quota permutazioni a blocchi con DD >= 10%%: %.4f%%"
          % (e["blocchi_oltre_10pct"] * 100.0))
    print("    CONTRO-ESEMPIO A: %s -> DD=%.4f"
          % (e["avv_blocco_traslato_come"], e["avv_blocco_traslato"]))
    print("    CONTRO-ESEMPIO B: peggior permutazione a blocchi -> DD=%.4f"
          % e["avv_perm_blocchi"])
    print("    TETTO NON PLAUSIBILE: DD=%.4f" % e["avv_tetto"])
    print("    posizioni per giornata (media)=%.2f" % e["pos_per_giorno"])


# ------------------------------------------------- il forward della 770201
def forward_770201():
    """Le 10 posizioni vere della sedia 770201 dal registro del campo.
    NON produce un p99: si limita a stampare i fatti che lo impediscono."""
    p = os.path.join(RADICE, "data", "statements", "trades_auto.csv")
    with open(p, encoding="utf-8", errors="replace") as fh:
        righe = [r for r in csv.DictReader(fh, delimiter=";")
                 if r["magic"] == "770201"]
    pl = [float(r["profit"]) + float(r["swap"]) + float(r["commission"])
          for r in righe]
    print("")
    print("### FORWARD VERO -- magic 770201 da data/statements/trades_auto.csv")
    print("    posizioni=%d  simboli=%s  dal %s al %s"
          % (len(pl), sorted(set(r["symbol"] for r in righe)),
             righe[0]["open_time"][:10], righe[-1]["close_time"][:10]))
    print("    somma netta=%.2f  minimo=%.2f  n. posizioni in perdita=%d"
          % (sum(pl), min(pl), sum(1 for v in pl if v < 0)))
    for dep in (100000.0, 10000.0):
        print("    DD a posizioni chiuse con deposito %.0f = %.6f%%"
              % (dep, M.dd_additivo(pl, dep)))
    if all(v >= 0 for v in pl):
        print("    -> NESSUNA PERDITA nella serie: il DD a posizioni chiuse e'"
              " IDENTICAMENTE ZERO per OGNI riordino.")
        print("    -> p99 = 0.0000%% per costruzione. NON e' una misura della"
              " coda: e' una degenerazione. NON si pubblica.")
    return pl


# ------------------------------------------- distribuzione su una lista P/L
def distribuzione_su_lista(pl, deposito, riordini, blocchi, seed):
    """Stesse primitive del modulo madre, applicate a una lista di P/L
    (serve per la prova di stabilita' a meta' campione)."""
    rend = M.rendimenti_relativi(pl, deposito)
    _, _, corsa = M.peggior_striscia(pl)
    lung = max(2, corsa)
    oss = M.dd_moltiplicativo(rend)
    rng = random.Random(seed)
    base = list(rend)
    dds = []
    for _ in range(riordini):
        rng.shuffle(base)
        dds.append(M.dd_moltiplicativo(base))
    dds.sort()
    rng2 = random.Random(seed + 1)
    bl = []
    for _ in range(blocchi):
        bl.append(M.dd_moltiplicativo(
            M.permutazione_a_blocchi(rend, lung, rng2)))
    bl.sort()
    return {"n": len(pl), "oss": oss, "len_blocco": lung,
            "mediana": M.perc(dds, 0.50), "p90": M.perc(dds, 0.90),
            "p95": M.perc(dds, 0.95), "p99": M.perc(dds, 0.99),
            "max": dds[-1],
            "b_p95": M.perc(bl, 0.95), "b_p99": M.perc(bl, 0.99),
            "b_max": bl[-1],
            "acf": [M.autocorrelazione(pl, k) for k in (1, 2, 3, 4, 5)]}


def carica_pl(percorso, magic):
    pos, _ = M.carica_posizioni(percorso, magic)
    return [p for _, _, p in pos]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--riordini", type=int, default=20000)
    ap.add_argument("--blocchi", type=int, default=20000)
    ap.add_argument("--avversari", type=int, default=5000)
    ap.add_argument("--seed", type=int, default=20260918)
    ap.add_argument("--min-posizioni", type=int, default=50)
    a = ap.parse_args()
    cfg = costruisci_cfg(a)

    sys.stderr.write("indicizzo i CSV di ottimizzazione...\n")
    indice = M.indicizza_ottimizzazioni()
    sys.stderr.write("righe indicizzate: %d\n" % len(indice))

    print("=" * 78)
    print("DD PER RIORDINO -- FAMIGLIA Nasdaq_Apertura_US / NASUSD")
    print("metodo importato da distribuzione_dd_riordino.py (non riscritto)")
    print("riordini=%d blocchi=%d avversari=%d seed=%d soglia=%d posizioni"
          % (cfg.riordini, cfg.blocchi, cfg.avversari, cfg.seed,
             cfg.min_posizioni))
    print("=" * 78)

    # --- 0. controllo di non-regressione sulla riga gia' pubblicata
    print("")
    print("--- CONTROLLO DI NON-REGRESSIONE (Dow 770202 via 770206) ---")
    nome, simb, mr, perc_f, mf = REGRESSIONE
    e = M.analizza(nome, simb, mr, perc_f, mf, indice, cfg)
    ok = True
    for chiave, atteso in (("n_pos", ATTESI_DOW["n_pos"]),
                           ("dd_osservato", ATTESI_DOW["dd_osservato"]),
                           ("rapporto_p95", ATTESI_DOW["rapporto_p95"])):
        val = e[chiave]
        if chiave == "n_pos":
            buono = (val == atteso)
        else:
            buono = abs(val - atteso) <= 0.0006
        ok = ok and buono
        print("    %-14s ricalcolato=%s  pubblicato 18/09=%s  -> %s"
              % (chiave, val, atteso, "COINCIDE" if buono else "DIVERGE"))
    for chiave, atteso in (("p95", ATTESI_DOW["p95"]),
                           ("p99", ATTESI_DOW["p99"])):
        val = e["dd"][chiave]
        buono = abs(val - atteso) <= 0.0001
        ok = ok and buono
        print("    %-14s ricalcolato=%.4f  pubblicato 18/09=%.4f  -> %s"
              % (chiave, val, atteso, "COINCIDE" if buono else "DIVERGE"))
    print("    ESITO: %s" % ("PASS -- il wrapper NON ha cambiato il metodo"
                             if ok else "FAIL -- il wrapper ha cambiato qualcosa"))

    # --- 1. il forward vero, che e' il motivo per cui serviva questo lavoro
    forward_770201()

    # --- 2. le celle R84
    for nome, simb, mr, perc_f, mf in SORGENTI_NAS:
        e = M.analizza(nome, simb, mr, perc_f, mf, indice, cfg)
        stampa(e, cfg)

    # --- 3. prova di rottura: meta' campione sulla cella A
    print("")
    print("--- PROVA DI ROTTURA: meta' campione sulla cella R84-A ---")
    pl = carica_pl(SORGENTI_NAS[0][3], SORGENTI_NAS[0][4])
    meta = len(pl) // 2
    pezzi = [("intero", pl), ("prima meta'", pl[:meta]),
             ("seconda meta'", pl[meta:])]
    for et, serie in pezzi:
        r = distribuzione_su_lista(serie, 10000.0, cfg.riordini, cfg.blocchi,
                                   cfg.seed)
        print("    %-14s n=%3d  oss=%7.4f  p95=%7.4f  p99=%7.4f"
              "  p95bl=%7.4f  p99bl=%7.4f  acf1=%+.4f"
              % (et, r["n"], r["oss"], r["p95"], r["p99"], r["b_p95"],
                 r["b_p99"], r["acf"][0]))

    # --- 4. prova di rottura: il p99 si stabilizza a quante operazioni?
    print("")
    print("--- PROVA DI ROTTURA: p99 al crescere del campione (cella A) ---")
    for n in (50, 75, 100, 125, 150, 175, 200, 225, len(pl)):
        if n > len(pl):
            continue
        r = distribuzione_su_lista(pl[:n], 10000.0, cfg.riordini, cfg.blocchi,
                                   cfg.seed)
        print("    prime %3d posizioni: oss=%7.4f  p99 iid=%7.4f"
              "  p99 blocchi=%7.4f" % (n, r["oss"], r["p99"], r["b_p99"]))

    # --- 5. prova di rottura: tre seed
    print("")
    print("--- PROVA DI ROTTURA: tre seed sulla cella R84-A ---")
    for s in (cfg.seed, 101, 202):
        r = distribuzione_su_lista(pl, 10000.0, 10000, 10000, s)
        print("    seed %8d: p95=%7.4f  p99=%7.4f  p99 blocchi=%7.4f"
              % (s, r["p95"], r["p99"], r["b_p99"]))

    # --- 6. CONTRO-ESEMPIO AL MIO CONTRO-ESEMPIO
    # La cella A CRESCE col campione. E' una proprieta' del riordino o e'
    # soltanto la DERIVA NEGATIVA di una cella che perde (PF 0,87)?
    # Si ripete la stessa curva su una cella con PF > 1 gia' pubblicata.
    print("")
    print("--- CONTROLLO DEL MECCANISMO: p99 vs n su una cella POSITIVA"
          " (Dow 770206, PF 1,27) ---")
    pl_dow = carica_pl(REGRESSIONE[3], REGRESSIONE[4])
    for n in (50, 60, 70, 80, 96):
        if n > len(pl_dow):
            continue
        r = distribuzione_su_lista(pl_dow[:n], 100000.0, cfg.riordini,
                                   cfg.blocchi, cfg.seed)
        print("    Dow prime %3d posizioni: oss=%7.4f  p99 iid=%7.4f"
              % (n, r["oss"], r["p99"]))
    print("    (confronto: cella A NASUSD alle stesse n -- vedi sopra)")


if __name__ == "__main__":
    main()
