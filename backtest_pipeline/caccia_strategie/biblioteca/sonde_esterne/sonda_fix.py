#!/usr/bin/env python3
# SONDA FIX VALUTARI (M11) -- cancelli F1..F7 congelati il 03/09 in
# CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md, par. 4.1. NON toccati.
# Dati: FutureSharks/financial-data (GPL-3.0), Oanda M1, timestamp UTC.
# LIMITI: non e' BCM, OHLC M1 (non tick), ZERO costi/spread, 2010-2020.
# Misura di OCCASIONI, mai un verdetto (F6 di casa).
import csv, os, glob, random, statistics as st, datetime as dt
from collections import defaultdict

S = os.environ.get("S", ".")
random.seed(20260905)

FIX = {  # nome -> (ora, minuto) in ORA DI LONDRA, per stagione
    "TOKYO_0955JST": {"estate": (1, 55), "inverno": (0, 55)},
    "ECB_1415CET":   {"estate": (13, 15), "inverno": (13, 15)},
    "WMR_1600LDN":   {"estate": (16, 0), "inverno": (16, 0)},
}
RUNUP_MIN = 30   # finestra di run-up prima del fix
FADE_MIN = 30    # orizzonte del fade dopo il fix


def ultima_domenica(anno, mese):
    d = dt.date(anno, mese, 31)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def e_ora_legale_eu(t):
    a = t.year
    return dt.datetime.combine(ultima_domenica(a, 3), dt.time(1, 0)) <= t < \
           dt.datetime.combine(ultima_domenica(a, 10), dt.time(1, 0))


def carica(sym, anni):
    bars = {}
    for f in sorted(glob.glob(os.path.join(S, "dati", sym, "*.csv"))):
        b = os.path.basename(f)
        anno = int(b.split("-")[0])
        if anno not in anni:
            continue
        with open(f) as fh:
            for row in csv.DictReader(fh):
                t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
                est = e_ora_legale_eu(t)
                tl = t + dt.timedelta(hours=1) if est else t
                bars[tl] = (float(row["open"]), float(row["high"]),
                            float(row["low"]), float(row["close"]), est)
    return bars


def escursioni(bars, t0, verso, n_min, prezzo_ing):
    """MFE/MAE in pip su n_min barre M1 dall'ingresso. Ambiguita' intrabarra
    risolta SEMPRE a sfavore (prima il MAE)."""
    mfe = mae = 0.0
    t = t0
    visti = 0
    for _ in range(n_min):
        b = bars.get(t)
        t += dt.timedelta(minutes=1)
        if b is None:
            continue
        visti += 1
        if verso > 0:
            mae = min(mae, b[2] - prezzo_ing)
            mfe = max(mfe, b[1] - prezzo_ing)
        else:
            mae = min(mae, prezzo_ing - b[1])
            mfe = max(mfe, prezzo_ing - b[2])
    return mfe, mae, visti


def chiusura(bars, t):
    for k in range(6):
        b = bars.get(t - dt.timedelta(minutes=k))
        if b:
            return b[3]
    return None


def corri(sym, pip, anni):
    bars = carica(sym, anni)
    if not bars:
        print(f"[{sym}] NESSUN DATO")
        return
    giorni = sorted({t.date() for t in bars})
    giorni_feriali = [g for g in giorni if g.weekday() < 5]
    print(f"\n{'='*78}\n{sym}: {len(bars):,} barre M1, {len(giorni_feriali)} giorni feriali "
          f"({giorni_feriali[0]} -> {giorni_feriali[-1]})\n{'='*78}")

    tutte_mfe, tutte_mae = [], []
    for nome, orari in FIX.items():
        runup, quota, mfes, maes, versi = [], [], [], [], []
        segni_dopo = []
        for g in giorni_feriali:
            # stagione: presa dalla barra piu' vicina a mezzogiorno
            camp = bars.get(dt.datetime.combine(g, dt.time(12, 0)))
            if camp is None:
                camp = bars.get(dt.datetime.combine(g, dt.time(9, 0)))
            if camp is None:
                continue
            hh, mm = orari["estate" if camp[4] else "inverno"]
            t_fix = dt.datetime.combine(g, dt.time(hh, mm))
            c_fix = chiusura(bars, t_fix)
            c_pre = chiusura(bars, t_fix - dt.timedelta(minutes=RUNUP_MIN))
            if c_fix is None or c_pre is None:
                continue
            ru = (c_fix - c_pre) / pip
            if abs(ru) < 1e-9:
                continue
            runup.append(ru)
            c_post = chiusura(bars, t_fix + dt.timedelta(minutes=FADE_MIN))
            if c_post is not None:
                quota.append(-(c_post - c_fix) / pip / ru)   # >0 = RIENTRO
                segni_dopo.append((c_post - c_fix) / pip)
            # FADE: entra a fix+1, contro il run-up
            b_ing = bars.get(t_fix + dt.timedelta(minutes=1))
            if b_ing is None:
                continue
            verso = -1 if ru > 0 else 1
            mfe, mae, visti = escursioni(bars, t_fix + dt.timedelta(minutes=2),
                                         verso, FADE_MIN, b_ing[0])
            if visti < FADE_MIN // 2:
                continue
            mfes.append(mfe / pip); maes.append(-mae / pip); versi.append(verso)
        if not runup:
            continue
        mru = st.median([abs(x) for x in runup])
        mq = st.median(quota) if quota else float("nan")
        f4 = st.median(mfes); f5 = st.median(maes)
        # quota di eventi con run-up "grande" (>= mediana): frequenza condizionata
        print(f"\n--- {nome}   n={len(runup)} giorni")
        print(f"  F2  run-up |mediano| su {RUNUP_MIN}' ........ {mru:6.2f} pip")
        print(f"  F3  QUOTA DI RIENTRO mediana a {FADE_MIN}' .... {mq:6.3f}   "
              f"(quota>0 nel {100*sum(1 for x in quota if x>0)/len(quota):5.1f}% dei giorni)")
        print(f"  F4  MFE mediana del fade (fix+1) .......... {f4:6.2f} pip")
        print(f"  F5  MAE mediana / RR ...................... {f5:6.2f} pip  RR={f4/f5:5.3f}")
        print(f"  F7  lati del fade: long {sum(1 for v in versi if v>0)} / short {sum(1 for v in versi if v<0)}"
              f"   |  mossa mediana DOPO il fix (segno EURUSD) = {st.median(segni_dopo):+6.2f} pip")
        tutte_mfe += mfes; tutte_mae += maes

    # ---- CONTROLLO A INGRESSI CASUALI, stessa geometria, stessi dati ----
    if tutte_mfe:
        ore_valide = [t for t in bars if t.weekday() < 5 and 1 <= t.hour <= 20]
        camp = random.sample(ore_valide, min(6000, len(ore_valide)))
        cmfe, cmae = [], []
        for t in camp:
            verso = random.choice((1, -1))
            b = bars.get(t)
            mfe, mae, visti = escursioni(bars, t + dt.timedelta(minutes=1), verso, FADE_MIN, b[0])
            if visti < FADE_MIN // 2:
                continue
            cmfe.append(mfe / pip); cmae.append(-mae / pip)
        print(f"\n  >>> CONTROLLO CASUALE (n={len(cmfe)}, stessa geometria, stesse barre):")
        print(f"      MFE mediana {st.median(cmfe):6.2f} pip | MAE mediana {st.median(cmae):6.2f} pip"
              f" | RR {st.median(cmfe)/st.median(cmae):5.3f}")
        print(f"      FIX  (tutti e tre): MFE {st.median(tutte_mfe):6.2f} | MAE {st.median(tutte_mae):6.2f}"
              f" | RR {st.median(tutte_mfe)/st.median(tutte_mae):5.3f}")
        print(f"      DELTA RR fix - caso = "
              f"{st.median(tutte_mfe)/st.median(tutte_mae) - st.median(cmfe)/st.median(cmae):+6.3f}")


anni = set(range(2011, 2020))
corri("EUR_USD", 0.0001, anni)
