#!/usr/bin/env python3
# SONDA FIX -- versione CONDIZIONATA al run-up (il meccanismo dichiarato dagli
# autori: rischio d'inventario dei dealer -> piu' grande la domanda di dollari
# nel run-up, piu' grande il rientro dopo).
# CANCELLO DICHIARATO PRIMA DEI NUMERI: mossa mediana post-fix nel quintile
# estremo >= 3,0 pip (= 3x lo spread di convenzione 1,0 pip, criterio C2 di casa).
# Sotto: meccanismo MORTO PER ARITMETICA, nessuna altra taratura.
import csv, os, glob, statistics as st, datetime as dt

S = os.environ.get("S", ".")
FIX = {"TOKYO_0955JST": {True: (1, 55), False: (0, 55)},
       "ECB_1415CET": {True: (13, 15), False: (13, 15)},
       "WMR_1600LDN": {True: (16, 0), False: (16, 0)}}
RUNUP_MIN, FADE_MIN, PIP = 30, 30, 0.0001


def ultima_domenica(a, m):
    d = dt.date(a, m, 31)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def dst(t):
    return dt.datetime.combine(ultima_domenica(t.year, 3), dt.time(1)) <= t < \
           dt.datetime.combine(ultima_domenica(t.year, 10), dt.time(1))


def carica(sym, anni):
    bars = {}
    for f in sorted(glob.glob(os.path.join(S, "dati", sym, "*.csv"))):
        if int(os.path.basename(f).split("-")[0]) not in anni:
            continue
        with open(f) as fh:
            for r in csv.DictReader(fh):
                t = dt.datetime.strptime(r["time"], "%Y-%m-%d %H:%M:%S")
                e = dst(t)
                bars[t + dt.timedelta(hours=1) if e else t] = (float(r["close"]), e)
    return bars


def cl(bars, t):
    for k in range(6):
        if t - dt.timedelta(minutes=k) in bars:
            return bars[t - dt.timedelta(minutes=k)][0]
    return None


def corri(sym, pip, anni):
    bars = carica(sym, anni)
    if not bars:
        print(f"[{sym}] NESSUN DATO"); return
    gg = sorted({t.date() for t in bars if t.weekday() < 5})
    print(f"\n{'='*74}\n{sym} — {len(bars):,} barre M1, {len(gg)} giorni ({gg[0]} -> {gg[-1]})\n{'='*74}")
    for nome, orari in FIX.items():
        dati = []
        for g in gg:
            c = bars.get(dt.datetime.combine(g, dt.time(12))) or bars.get(dt.datetime.combine(g, dt.time(9)))
            if not c:
                continue
            hh, mm = orari[c[1]]
            tf = dt.datetime.combine(g, dt.time(hh, mm))
            a, b, d = cl(bars, tf - dt.timedelta(minutes=RUNUP_MIN)), cl(bars, tf), cl(bars, tf + dt.timedelta(minutes=FADE_MIN))
            if None in (a, b, d):
                continue
            dati.append(((b - a) / pip, (d - b) / pip))
        if len(dati) < 100:
            continue
        dati.sort(key=lambda x: x[0])
        q = len(dati) // 5
        print(f"\n--- {nome}  n={len(dati)}   (run-up NEGATIVO su EURUSD = DOLLARO SU, la previsione del paper)")
        print(f"    {'quintile run-up':<22} {'run-up med':>11} {'POST-FIX med':>13} {'% post>0':>9}")
        for i, et in enumerate(("Q1 dollaro su forte", "Q2", "Q3", "Q4", "Q5 dollaro giu forte")):
            f = dati[i * q:(i + 1) * q] if i < 4 else dati[4 * q:]
            post = [x[1] for x in f]
            print(f"    {et:<22} {st.median([x[0] for x in f]):>+10.2f}  {st.median(post):>+12.2f}"
                  f"  {100*sum(1 for p in post if p>0)/len(post):>8.1f}%")


anni = set(range(2011, 2020))
corri("EUR_USD", 0.0001, anni)
