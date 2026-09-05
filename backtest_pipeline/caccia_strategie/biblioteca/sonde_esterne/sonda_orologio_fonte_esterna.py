#!/usr/bin/env python3
# COLLAUDO DELL'OROLOGIO - prima di leggere qualunque altro numero.
# Trova il minuto del giorno con la piu' alta |variazione| media M1, separato
# per mesi INVERNALI e mesi ESTIVI. Se histdata e' EST fisso (UTC-5), l'apertura
# USA (14:30 UTC inverno / 13:30 UTC estate) cade a 09:30 inverno e 08:30 estate.
import glob, os
from collections import defaultdict

S = os.environ['S']

def scan(sym):
    win = defaultdict(lambda: [0.0, 0])   # (hh,mm) -> [somma |ret|, n]
    sum_ = defaultdict(lambda: [0.0, 0])
    prev = None
    for p in sorted(glob.glob(f"{S}/dati/{sym}_*.csv")):
        with open(p) as f:
            for line in f:
                parts = line.strip().split(';')
                if len(parts) < 5: continue
                ts = parts[0]; c = float(parts[4])
                mth = int(ts[4:6]); hh = int(ts[9:11]); mm = int(ts[11:13])
                if prev is not None and prev[0] == ts[0:8]:
                    r = abs(c - prev[1]) / prev[1] * 1e4      # in punti base
                    d = win if mth in (1,2,11,12) else (sum_ if mth in (5,6,7,8) else None)
                    if d is not None:
                        d[(hh,mm)][0] += r; d[(hh,mm)][1] += 1
                prev = (ts[0:8], c)
    return win, sum_

for sym in ("SPXUSD","GRXEUR"):
    win, sum_ = scan(sym)
    for nome, d in (("INVERNO (gen/feb/nov/dic)", win), ("ESTATE (mag-ago)", sum_)):
        top = sorted(((v[0]/v[1], k, v[1]) for k,v in d.items() if v[1] > 200), reverse=True)[:5]
        print(f"{sym} {nome}: " + " | ".join(f"{k[0]:02d}:{k[1]:02d} {m:.2f}bp (n={n})" for m,k,n in top))
    print()
