#!/usr/bin/env python3
# Nata il 24/09/2026 nella caccia Unger (pilastri 1-3):
#   backtest_pipeline/caccia_strategie/CACCIA_UNGER_INGRESSI_USCITE_FILTRI_2026-09-24.md
# DATI: github FutureSharks/financial-data (histdata M1, GPL-3.0), GRXEUR 2011-2018,
#   raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/stocks/histdata/GRXEUR/DAT_ASCII_GRXEUR_M1_<ANNO>.csv
#   da salvare come dati/GRXEUR_<ANNO>.csv. Copertura: SOLO server 07:00-21:00 (sessione FDAX), la NOTTE non c'e'.
# LIMITI: non e' BCM; OHLC M1; zero costi; misura OCCASIONI (esistenza dell'evento), MAI edge.
# SONDA DI ESISTENZA DEGLI EVENTI "UNGER" sul DAX (GRXEUR histdata M1, GPL-3.0)
# Misura OCCASIONI, mai edge. Orologio: ora file + 5 = ora server (vecchio orologio BCM IT-1).
# Copertura dati: server 07:00-21:00 (sessione FDAX 08-22 CET). La NOTTE 21-07 NON c'e'.
import glob, sys
from collections import defaultdict
from datetime import datetime, timedelta

def load(pattern):
    bars = []
    for p in sorted(glob.glob(pattern)):
        for line in open(p):
            q = line.strip().split(';')
            if len(q) < 5: continue
            t = datetime.strptime(q[0], '%Y%m%d %H%M%S') + timedelta(hours=5)
            bars.append((t, float(q[1]), float(q[2]), float(q[3]), float(q[4])))
    return bars

bars = load(sys.argv[1] if len(sys.argv) > 1 else 'dati/GRXEUR_*.csv')
byday = defaultdict(list)
for b in bars: byday[b[0].date()].append(b)
days = sorted(d for d in byday if len(byday[d]) >= 300)   # giornate intere
print('barre', len(bars), 'giornate', len(days), days[0], '->', days[-1])

def hm(t): return t.hour*60 + t.minute
S_ARM, S_CASHEND, S_END = 8*60, 16*60+30, 21*60
agg = defaultdict(lambda: defaultdict(int))
for i in range(5, len(days)):
    d, y = days[i], days[i].year
    prev = byday[days[i-1]]
    PDH = max(b[2] for b in prev); PDL = min(b[3] for b in prev)
    PDO, PDC = prev[0][1], prev[-1][4]
    wk = [x for k in range(i-5, i) for x in byday[days[k]]]
    WH = max(b[2] for b in wk); WL = min(b[3] for b in wk)
    WO = byday[days[i-5]][0][1]; WC = PDC
    WF = abs(WO-WC) < 0.5*(WH-WL)                 # Weekly Factor (TASC 2023.09, default 0.5)
    DF25 = abs(PDO-PDC) < 0.25*(PDH-PDL)          # Daily Factor / indecisione (Unger IT: 25%)
    DF50 = abs(PDO-PDC) < 0.50*(PDH-PDL)
    today = byday[d]
    pre = [b for b in today if hm(b[0]) < S_ARM]
    arm = [b for b in today if hm(b[0]) >= S_ARM]
    if not arm: continue
    A = agg[y]; A['giorni'] += 1
    p0 = arm[0][1]
    # gia' fuori PRIMA delle 08:00 (dati 07-08 soli). Su BCM NON e' un limite in nessun verso: la notte di OGGI
    # consuma di piu', ma i livelli di IERI su BCM includono la notte di ieri e sono piu' larghi.
    pre_out = any(b[2] >= PDH or b[3] <= PDL for b in pre) or not (PDL < p0 < PDH)
    if pre_out: A['consumato_prima_08'] += 1; continue
    A['dentro_alle_08'] += 1
    up = dn = None
    for b in arm:
        t = hm(b[0])
        if up is None and b[2] >= PDH: up = t
        if dn is None and b[3] <= PDL: dn = t
    def within(x, lim): return x is not None and x <= lim
    for lim, lab in ((S_CASHEND, 'cash'), (S_END, 'sera')):
        u, w = within(up, lim), within(dn, lim)
        if u or w: A['rotto_'+lab] += 1
        if u and w: A['entrambi_'+lab] += 1
    if within(up, S_CASHEND) or within(dn, S_CASHEND):
        if WF: A['rotto_cash_WF'] += 1
        if DF25: A['rotto_cash_DF25'] += 1
        if DF50: A['rotto_cash_DF50'] += 1
    if WF: A['WF_vero'] += 1
    if DF25: A['DF25_vero'] += 1
    if DF50: A['DF50_vero'] += 1

cols = ['giorni','consumato_prima_08','dentro_alle_08','rotto_cash','entrambi_cash','rotto_sera','entrambi_sera','WF_vero','rotto_cash_WF','DF25_vero','rotto_cash_DF25','DF50_vero','rotto_cash_DF50']
print('anno ' + ' '.join(f'{c:>16s}' for c in cols))
tot = defaultdict(int)
for y in sorted(agg):
    print(f'{y} ' + ' '.join(f'{agg[y][c]:16d}' for c in cols))
    for c in cols: tot[c] += agg[y][c]
print('TOT  ' + ' '.join(f'{tot[c]:16d}' for c in cols))
ny = len(agg)
print(f"per anno medio: rotture in cash={tot['rotto_cash']/ny:.1f}  con WF={tot['rotto_cash_WF']/ny:.1f}  con DF25={tot['rotto_cash_DF25']/ny:.1f}  con DF50={tot['rotto_cash_DF50']/ny:.1f}")
print(f"quota consumata prima delle 08 (solo ora 07-08; su BCM NON e' un limite: due effetti di segno opposto): {100*tot['consumato_prima_08']/tot['giorni']:.1f}%")
print(f"quota giorni con ENTRAMBI i lati rotti in cash (su 'dentro'): {100*tot['entrambi_cash']/max(1,tot['dentro_alle_08']):.1f}%")
