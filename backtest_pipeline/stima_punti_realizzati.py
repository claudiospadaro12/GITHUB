#!/usr/bin/env python3
"""
Stima ATTESA per R270 -- quanti DEAL vincenti (parziali+finali) chiudono
entro pochi punti indice, usando net_profit/volume come punti REALIZZATI
(D30EUR = 1,00 EUR/punto indice/lotto, commissione 0,00 -- COSTO_C3_DAX_2026-09-09.md
r.27; CANCELLO_COSTO_FLOTTA_2026-09-10.md r.186). NON e' MFE (nessuna traccia
intra-trade nell'export): e' il punto di CHIUSURA di ogni deal, un limite
INFERIORE della MFE vera se il trailing ha ridato terreno prima di chiudere.
Uso: python3 stima_punti_realizzati.py <csv1> [<csv2> ...]
"""
import sys, csv

soglie = [1, 2, 3, 5, 10, 20]
tutti = []
for path in sys.argv[1:]:
    with open(path, encoding='utf-8') as f:
        r = csv.DictReader(f, delimiter=';')
        for row in r:
            vol = float(row['volume'])
            np_ = float(row['net_profit'])
            pts = np_ / vol if vol else 0.0
            tutti.append((path, row['position_id'], pts, np_))

vinc = [t for t in tutti if t[3] > 0]
perd = [t for t in tutti if t[3] <= 0]
print(f"deal totali: {len(tutti)}  vincenti: {len(vinc)}  perdenti/pari: {len(perd)}")
for s in soglie:
    n = sum(1 for t in vinc if t[2] <= s)
    print(f"  vincenti con punti realizzati <= {s:2d}: {n:3d} / {len(vinc)} ({100*n/len(vinc):.1f}%)")

pts_sorted = sorted(t[2] for t in vinc)
def pct(p):
    if not pts_sorted: return float('nan')
    k = (len(pts_sorted)-1)*p
    f = int(k); c = min(f+1, len(pts_sorted)-1)
    return pts_sorted[f] + (pts_sorted[c]-pts_sorted[f])*(k-f)
print(f"punti realizzati (vincenti): mediana {pct(0.5):.2f}  P25 {pct(0.25):.2f}  P75 {pct(0.75):.2f}  min {pts_sorted[0]:.2f}  max {pts_sorted[-1]:.2f}")
print()
print("--- perdenti/pari ---")
p_sorted = sorted(t[2] for t in perd)
if p_sorted:
    def pctp(p, arr):
        k=(len(arr)-1)*p; f=int(k); c=min(f+1,len(arr)-1)
        return arr[f]+(arr[c]-arr[f])*(k-f)
    print(f"punti (perdenti): mediana {pctp(0.5,p_sorted):.2f}  P25 {pctp(0.25,p_sorted):.2f}  P75 {pctp(0.75,p_sorted):.2f}  min {p_sorted[0]:.2f}  max {p_sorted[-1]:.2f}")
