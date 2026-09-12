#!/usr/bin/env python3
# ---------------------------------------------------------------------------
# SONDA SEQUENZA -- IL CONTRO-ESEMPIO: la E per ANNO, lato per lato.
#
# Domanda (scritta PRIMA di guardare l'uscita, 12/09/2026): il lato SHORT della
# sequenza e' positivo perche' esiste un meccanismo, o perche' dentro i quattro
# anni ce n'e' UNO (l'orso 2018, o il crollo agosto 2015) che paga tutto?
#
# CANCELLO dichiarato prima: il segno della E netta deve reggere in almeno
# 3 anni su 4. Se sta in 1 anno su 4, il candidato NON entra nell'imbuto.
#
# Usa le stesse funzioni di sonda_sequenza.py (una sola definizione di
# geometria: se cambia la, cambia qui).
# USO: export S=<cartella con dati/>; python3 sonda_sequenza_anni.py
# ---------------------------------------------------------------------------
import os, glob, importlib.util
from statistics import median

S = os.environ.get('S', '.')
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location("sq", os.path.join(HERE, "sonda_sequenza.py"))
sq = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sq)

RR = float(os.environ.get('RR', '2.0'))
MB = {30: int(os.environ.get('MB30', '96')), 60: int(os.environ.get('MB60', '48'))}

print(f"SONDA SEQUENZA per ANNO -- RR={RR}, ambiguita' intrabarra a sfavore")
print("Cancello dichiarato PRIMA: segno della E netta in >= 3 anni su 4.\n")

for sym in ('GRXEUR', 'SPXUSD'):
    files = sorted(glob.glob(f"{S}/dati/{sym}_*.csv"))
    if not files:
        print(f"{sym}: NESSUN DATO")
        continue
    bars = sq.load_m1(files)
    print(f"=== {sym} (spread usato {sq.SPREAD[sym]} pti indice) ===")
    for tf in (30, 60):
        b = sq.aggregate(bars, tf)
        for N in (2, 3, 4):
            for side in ('L', 'S'):
                per_anno = {}
                for i in range(N + 1, len(b) - 1):
                    if not sq.in_sessione(b[i], sym):
                        continue
                    ok = sq.setup_long(b, i, N) if side == 'L' else sq.setup_short(b, i, N)
                    if not ok:
                        continue
                    entry = b[i][6]
                    m = i - N
                    R = (entry - b[m][5]) if side == 'L' else (b[m][4] - entry)
                    if R <= 0:
                        continue
                    e = sq.esito(b, i, entry, R, side, RR, MB[tf])
                    anno = b[i][0][0:4]
                    per_anno.setdefault(anno, []).append((e, R))
                righe = []
                pos = tot = 0
                for anno in sorted(per_anno):
                    dati = per_anno[anno]
                    dec = [e for (e, R) in dati if e >= 0]
                    if not dec:
                        righe.append(f"{anno}: n=0")
                        continue
                    wr = sum(dec) / len(dec)
                    R1 = median([R for (e, R) in dati])
                    cost = sq.SPREAD[sym] / R1 if R1 > 0 else 0
                    En = wr * RR - (1 - wr) - cost
                    righe.append(f"{anno}: n={len(dati):4d} 1R={R1:6.1f} E={En:+.4f}R")
                    tot += 1
                    if En > 0:
                        pos += 1
                print(f"  M{tf} N={N} {side}: anni positivi {pos}/{tot} | " + " | ".join(righe))
    print()
