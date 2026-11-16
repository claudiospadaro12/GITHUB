#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Correlazione.py - correlazione tra EA e contributo di un candidato alla squadra (tappa 3 del "nostro UBS").

Input: cartella con file <nome>.csv, ognuno con righe "data;profitto_netto" (YYYY.MM.DD;numero), una riga per giorno con operazioni
       (le scrive Esporta_Operazioni.ps1 / Run_MT5_Engine.ps1 in Risultati\\serie, oppure qualunque altra fonte con lo stesso formato).
Misura: correlazione di Pearson dei profitti REALIZZATI, giorni senza operazioni = 0, sull'intervallo comune.
  - giornaliera: viziata verso lo zero quando gli EA operano di rado (molti zeri insieme)  -> puo far sembrare "scorrelati" due EA che non lo sono
  - settimanale: piu robusta, ma con meno punti
  La soglia si giudica sul valore PIU ALTO delle due letture (prudente).  <=0,30 diverso | 0,30-0,60 parente | >0,60 stessa cosa.
NON misura il flottante (equity) ne la sovrapposizione delle posizioni aperte: sono limiti dichiarati.
Uso:
  python3 -I Correlazione.py cartella_serie                          # matrice di tutti contro tutti
  python3 -I Correlazione.py cartella_serie --candidato X --squadra A,B,C   # contributo di X alla squadra
"""
import argparse, csv, glob, os, sys
from datetime import date, timedelta
import math

def leggi(p):
    d = {}
    with open(p, encoding="utf-8-sig") as f:
        for r in csv.reader(f, delimiter=";"):
            if len(r) < 2: continue
            try:
                y, m, g = r[0].strip().split(".")
                d[date(int(y), int(m), int(g))] = d.get(date(int(y), int(m), int(g)), 0.0) + float(r[1].replace(",", "."))
            except ValueError:
                continue  # intestazione o riga non valida
    return d

def carica(cartella):
    s = {}
    for p in sorted(glob.glob(os.path.join(cartella, "*.csv"))):
        d = leggi(p)
        if d: s[os.path.splitext(os.path.basename(p))[0]] = d
    return s

def matrice(serie, nomi):
    a = min(min(serie[n]) for n in nomi); b = max(max(serie[n]) for n in nomi)
    giorni = [a + timedelta(days=i) for i in range((b - a).days + 1)]
    return giorni, [[serie[n].get(g, 0.0) for g in giorni] for n in nomi]

def settimanale(giorni, m):
    chiavi = [g.isocalendar()[:2] for g in giorni]
    uniche = sorted(set(chiavi)); idx = {k: i for i, k in enumerate(uniche)}
    w = [[0.0] * len(uniche) for _ in m]
    for r, riga in enumerate(m):
        for j, k in enumerate(chiavi): w[r][idx[k]] += riga[j]
    return w

def pearson(x, y):
    n = len(x)
    if n < 3: return 0.0
    mx = sum(x) / n; my = sum(y) / n
    sxx = sum((a - mx) ** 2 for a in x); syy = sum((b - my) ** 2 for b in y)
    if sxx <= 0 or syy <= 0: return 0.0
    return sum((a - mx) * (b - my) for a, b in zip(x, y)) / math.sqrt(sxx * syy)

def corr(m):
    k = len(m)
    return [[1.0 if i == j else pearson(m[i], m[j]) for j in range(k)] for i in range(k)]

def etichetta(x):
    return "diverso" if x <= 0.30 else ("parente" if x <= 0.60 else "STESSA COSA")

def somma(m):
    return [sum(c) for c in zip(*m)]

def max_dd(pnl):
    eq = 0.0; picco = 0.0; dd = 0.0
    for v in pnl:
        eq += v; picco = max(picco, eq); dd = max(dd, picco - eq)
    return dd

def pf(pnl):
    g = sum(v for v in pnl if v > 0); p = -sum(v for v in pnl if v < 0)
    return g / p if p > 0 else float("inf")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cartella"); ap.add_argument("--candidato"); ap.add_argument("--squadra", default="")
    a = ap.parse_args()
    serie = carica(a.cartella)
    if len(serie) < 2: sys.exit("Servono almeno 2 file .csv in " + a.cartella)
    nomi = list(serie)
    if a.candidato:
        sq = [x for x in a.squadra.split(",") if x]
        for n in [a.candidato] + sq:
            if n not in serie: sys.exit("Serie non trovata: " + n)
        nomi = sq + [a.candidato]
    giorni, m = matrice(serie, nomi); w = settimanale(giorni, m)
    cg, cw = corr(m), corr(w)
    print("Intervallo: %s -> %s (%d giorni, %d settimane). Profitti REALIZZATI, giorni senza operazioni = 0." % (giorni[0], giorni[-1], len(giorni), len(w[0])))
    if not a.candidato:
        print("\nCorrelazione (valore piu alto tra giornaliera e settimanale):")
        for i in range(len(nomi)):
            for j in range(i + 1, len(nomi)):
                v = max(cg[i][j], cw[i][j])
                print("  %-28s %-28s giorn %+.2f  sett %+.2f  -> %s" % (nomi[i], nomi[j], cg[i][j], cw[i][j], etichetta(v)))
        return
    k = len(nomi) - 1
    print("\nCandidato %s contro la squadra:" % a.candidato)
    peggiore = -1.0
    for i in range(k):
        v = max(cg[i][k], cw[i][k]); peggiore = max(peggiore, v)
        print("  contro %-24s giorn %+.2f  sett %+.2f  -> %s" % (nomi[i], cg[i][k], cw[i][k], etichetta(v)))
    sq_pnl = somma(m[:k]); tot = somma(m)
    print("\nSquadra da sola : profitto %.0f  PF %.2f  DD massimo (realizzato) %.0f" % (sum(sq_pnl), pf(sq_pnl), max_dd(sq_pnl)))
    print("Con il candidato: profitto %.0f  PF %.2f  DD massimo (realizzato) %.0f" % (sum(tot), pf(tot), max_dd(tot)))
    print("Somma dei DD singoli: %.0f (il DD insieme e sotto se gli EA sono scorrelati)" % sum(max_dd(r) for r in m))
    print("\nVERDETTO TAPPA 3: correlazione peggiore %.2f -> %s. Si somma ai profitti SOLO se i periodi coincidono e il deposito/lotti sono confrontabili." % (peggiore, etichetta(peggiore)))

if __name__ == "__main__":
    main()
