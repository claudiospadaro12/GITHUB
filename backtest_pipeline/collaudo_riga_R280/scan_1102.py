#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
scan_1102.py -- la dichiarazione della CLASSE 1102 per R280, fatta con una scansione e non a memoria: quali CSV del repo hanno GIA' misurato
(a) le celle H1 di R280a (EA ABTG_Nasdaq_Apertura_US, U30USD, InpFilterTF=16385, InpEmaFast=1, TP1_R 0,5, due lati, rischio 1) e
(b) la cella di R280e (stessa, ma InpFilterTF=16388 e InpEmaSlow=220), e su quali finestre (la finestra si legge dal REFERTO accanto o dalla sigla del file).
Uso: python3 backtest_pipeline/collaudo_riga_R280/scan_1102.py        (stampa e esce 0)
"""
import csv, glob, io, os
REPO = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
cols = ("InpFilterTF", "InpEmaSlow", "InpEmaFast", "InpTP1_R", "InpAllowLong", "InpAllowShort", "InpRiskPercent")
def f(x):
    try:
        return float(str(x).strip().replace("true", "1").replace("false", "0"))
    except ValueError:
        return None
tot_h1 = []; tot_h4 = []; letti = 0
for p in sorted(glob.glob(os.path.join(REPO, "backtest_pipeline", "**", "*.csv"), recursive=True)):
    try:
        b = open(p, "rb").read(6000000).decode("latin-1")
    except OSError:
        continue
    head = b.split("\n", 1)[0]
    if "InpFilterTF" not in head or "InpEmaSlow" not in head:
        continue
    letti += 1
    for r in csv.DictReader(io.StringIO(b)):
        if f(r.get("InpFilterTF")) is None:
            continue
        base = f(r.get("InpEmaFast")) == 1 and f(r.get("InpTP1_R")) == 0.5 and f(r.get("InpAllowLong")) == 1 and f(r.get("InpAllowShort")) == 1 and f(r.get("InpRiskPercent")) == 1
        rel = os.path.relpath(p, REPO)
        if f(r["InpFilterTF"]) == 16385 and base and "U30USD" in rel:
            tot_h1.append((rel, r["InpEmaSlow"], r["Trades"], r["Profit Factor"]))
        if f(r["InpFilterTF"]) == 16388 and f(r["InpEmaSlow"]) == 220 and base and "U30USD" in rel:
            tot_h4.append((rel, r["InpEmaSlow"], r["Trades"], r["Profit Factor"], r["Equity DD %"]))
print("CSV con le colonne InpFilterTF e InpEmaSlow letti: %d" % letti)
print("(a) righe H1 (InpFilterTF=16385) con InpEmaFast=1, TP1_R 0,5, due lati, rischio 1 su U30USD: %d" % len(tot_h1))
for x in tot_h1:
    print("    ", x)
print("(b) righe H4/220 (la cella di R280e) con gli stessi pin su U30USD: %d" % len(tot_h4))
for x in tot_h4:
    print("    ", x)
