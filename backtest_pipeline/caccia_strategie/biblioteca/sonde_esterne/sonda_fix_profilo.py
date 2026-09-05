#!/usr/bin/env python3
# SONDA FIX -- PASSO F6: dove sta il fix nei DATI, non nella teoria.
# Dati: FutureSharks/financial-data (GPL-3.0), Oanda EUR_USD M1, timestamp DICHIARATO UTC.
# LIMITI: non e' BCM, OHLC M1 (non tick), ZERO costi, finestra 2010-2020.
# Misura di OCCASIONI, mai un verdetto (F6 di casa).
import csv, os, glob, datetime as dt
from collections import defaultdict

S = os.environ.get("S", ".")
PIP = 0.0001

def ultima_domenica(anno, mese):
    d = dt.date(anno, mese, 31) if mese == 3 else dt.date(anno, mese, 31)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d

def e_ora_legale_eu(t_utc):
    """DST europea: ultima domenica marzo 01:00 UTC -> ultima domenica ottobre 01:00 UTC."""
    a = t_utc.year
    ini = dt.datetime.combine(ultima_domenica(a, 3), dt.time(1, 0))
    fin = dt.datetime.combine(ultima_domenica(a, 10), dt.time(1, 0))
    return ini <= t_utc < fin

def carica(sym, anni):
    for f in sorted(glob.glob(os.path.join(S, "dati", sym, "*.csv"))):
        base = os.path.basename(f)
        anno = int(base.split("-")[0]) if "-" in base else int(base.split("_")[1][:4])
        if anno not in anni:
            continue
        with open(f) as fh:
            for row in csv.DictReader(fh):
                t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
                yield t, float(row["open"]), float(row["high"]), float(row["low"]), float(row["close"]), float(row.get("volume", 0) or 0)

def main():
    anni = set(range(2011, 2020))
    # profilo per MINUTO nell'ora di LONDRA, separato estate/inverno
    prof = {"estate": defaultdict(lambda: [0.0, 0, 0.0]), "inverno": defaultdict(lambda: [0.0, 0, 0.0])}
    n = 0
    for t, o, h, l, c, v in carica("EUR_USD", anni):
        if t.weekday() >= 5:
            continue
        est = e_ora_legale_eu(t)
        tl = t + dt.timedelta(hours=1) if est else t   # ora di LONDRA
        k = tl.hour * 60 + tl.minute
        rng = (h - l) / PIP
        d = prof["estate" if est else "inverno"][k]
        d[0] += rng; d[1] += 1; d[2] += v
        n += 1
    print(f"barre M1 feriali lette: {n:,}")
    for stag in ("estate", "inverno"):
        p = prof[stag]
        righe = sorted(((v[0] / v[1], v[2] / v[1], k, v[1]) for k, v in p.items() if v[1] > 200), reverse=True)
        print(f"\n=== {stag.upper()} — top 12 minuti per RANGE MEDIO M1 (ora LONDRA) ===")
        for rng, vol, k, cnt in righe[:12]:
            print(f"  {k//60:02d}:{k%60:02d}  range {rng:5.2f} pip   vol {vol:7.1f}   n={cnt}")
        # zoom sulle finestre teoriche
        for nome, hh in (("WMR 16:00 Londra", 16), ("ECB fix 14:15 CET=13:15 Londra", 13), ("Tokyo 09:55 JST", 1)):
            print(f"  --- zoom {nome} ---")
            for m in range(-7, 8):
                k = hh * 60 + (15 if hh == 13 else (0 if hh == 16 else 55)) + m
                if k in p and p[k][1] > 200:
                    print(f"      {k//60:02d}:{k%60:02d}  range {p[k][0]/p[k][1]:5.2f}  vol {p[k][2]/p[k][1]:7.1f}")

main()
