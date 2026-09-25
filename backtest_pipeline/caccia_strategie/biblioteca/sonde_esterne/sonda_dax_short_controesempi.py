#!/usr/bin/env python3
# =====================================================================
#  CONTRO-ESEMPI sulla sola cella che ha passato la sonda
#  sonda_dax_short_meccanismi.py (P2d: gap-down >= 0,50% -> corto sulla
#  rottura del minimo del range 15', stop max(68, massimo del range),
#  bersaglio 2R, uscita 16:24 server).
#  POST-HOC E DICHIARATO: queste righe NON scelgono una cella migliore.
#  Provano a ROMPERE P2d. Se una di queste spiegazioni alternative produce
#  lo stesso numero, P2d non misura il gap: misura altro.
#   CE1 SCALA: lo stop di 68 pti a DAX 7.000-12.000 (2011-2018) e' in unita'
#       di volatilita' piu' largo che a DAX ~24.000 (BCM 2025-26). Versione
#       invariante: pavimento = 0,27 x ATR20 giornaliero (68/252,5 misurato
#       su D30EUR BCM) e costo = 1,70/252,5 x ATR20.
#   CE2 IL GAP E' IL MOTORE? stessa meccanica su TUTTE le sedute (nessun gap).
#   CE3 SPECCHIO: stessa meccanica corta nei giorni di gap-UP >= 0,50%.
#   CE4 USCITA: niente bersaglio 2R, solo stop e uscita a tempo.
#   CE5 LATO LUNGO DELLA STESSA FAMIGLIA: gap-up >= 0,50% -> lungo sulla
#       rottura del massimo del range 15' (la meccanica del sorgente Nikkei
#       e' SIMMETRICA: se il lungo vale come il corto, la famiglia e'
#       "continuazione del gap", non "corto").
#   CE6 SOGLIA: gap-down >= 0,35% e >= 0,75% (si legge l'altopiano, non si sceglie).
# =====================================================================
import sys, statistics, collections
PAT = sys.argv[1] if len(sys.argv) > 1 else 'dati/GRXEUR_*.csv'
# CE7 GEMELLO: argv[2]='SPX' -> stessa meccanica sulla cash USA (file 09:30-16:00 NY = 14:30-21:00 server),
# SOLO in scala invariante (lo spread SPX di BCM non entra: costo = 1,70/252,5 x ATR20, come il DAX).
GEMELLO = len(sys.argv) > 2 and sys.argv[2] == 'SPX'
# CE8 GEMELLO EUROPEO: argv[2]='ETX' -> EuroStoxx 50 (ETXEUR histdata, stessa sessione del DAX 08:00-16:29
# server), SOLO in scala invariante (i 68 punti del DAX non hanno senso su un indice a ~3.000).
ETX = len(sys.argv) > 2 and sys.argv[2] == 'ETX'
import glob   # stesse funzioni della sonda madre, copiate (niente import: la madre esegue le celle)
from datetime import datetime, timedelta
COSTO = 1.70; PAV = 68.0; OPEN = 8*60; CLOSE = 16*60+29
if GEMELLO: OPEN = 14*60+30; CLOSE = 20*60+59
by = collections.defaultdict(dict)
for p in sorted(glob.glob(PAT)):
    for ln in open(p):
        q = ln.strip().split(';')
        if len(q) < 5: continue
        t = datetime.strptime(q[0], '%Y%m%d %H%M%S') + timedelta(hours=5)
        by[t.date()][t.hour*60+t.minute] = (float(q[1]), float(q[2]), float(q[3]), float(q[4]))
giorni = sorted(d for d in by if any(m in by[d] for m in range(OPEN, OPEN+5))
                and sum(1 for m in by[d] if OPEN <= m <= CLOSE) >= 300)
def open_at(d, m):
    for k in range(m, m+5):
        b = by[d].get(k)
        if b: return b[0], k
    return None, None
def close_at(d, m):
    for k in range(m, m-6, -1):
        b = by[d].get(k)
        if b: return b[3]
    return None
def hilo(d, m0, m1):
    hs = [by[d][k][1] for k in range(m0, m1+1) if k in by[d]]
    ls = [by[d][k][2] for k in range(m0, m1+1) if k in by[d]]
    return (max(hs), min(ls)) if hs else (None, None)
def cammina(d, m0, verso, entry, dist, tgt=None, mend=CLOSE):
    sl = entry - dist if verso > 0 else entry + dist
    ultimo = entry
    for k in range(m0, mend+1):
        b = by[d].get(k)
        if not b: continue
        o, h, l, c = b; ultimo = c
        if verso > 0:
            if l <= sl: return -dist
            if tgt is not None and h >= tgt: return tgt - entry
        else:
            if h >= sl: return -dist
            if tgt is not None and l <= tgt: return entry - tgt
    cc = close_at(d, mend)
    return ((cc if cc is not None else ultimo) - entry) * verso
rng = {}; atr20 = {}; prevd = {}
for d in giorni:
    h, l = hilo(d, OPEN, CLOSE); rng[d] = h - l
for i, d in enumerate(giorni):
    if i >= 20: atr20[d] = statistics.mean(rng[x] for x in giorni[i-20:i])
    if i >= 1: prevd[d] = giorni[i-1]

def run(nome, filtro, verso=-1, scala=False, target=True):
    xs = []
    for d in giorni:
        if d not in atr20 or d not in prevd: continue
        PC = close_at(prevd[d], CLOSE); O, _ = open_at(d, OPEN)
        if PC is None or O is None: continue
        gp = O/PC - 1
        if not filtro(gp): continue
        A = atr20[d]; pav = 0.27*A if scala else PAV; cost = COSTO/252.5*A if scala else COSTO
        rh, rl = hilo(d, OPEN, OPEN+14)
        for k in range(OPEN+15, OPEN+90):
            b = by[d].get(k)
            if not b: continue
            if verso < 0 and b[2] < rl:
                entry = rl if b[0] >= rl else b[0]; dist = max(pav, rh - entry)
            elif verso > 0 and b[1] > rh:
                entry = rh if b[0] <= rh else b[0]; dist = max(pav, entry - rl)
            else:
                continue
            tg = (entry + verso*2*dist) if target else None
            tgc = (entry - verso*2*dist) if target else None
            g = cammina(d, k, verso, entry, dist, tgt=tg, mend=CLOSE-5)
            gc = cammina(d, k, -verso, entry, dist, tgt=tgc, mend=CLOSE-5)
            xs.append((d.year, dist, (g-cost)/dist, (gc-cost)/dist))
            break
    n = len(xs)
    if n < 2: print(nome, 'n', n); return
    E = statistics.mean(x[2] for x in xs); sd = statistics.stdev(x[2] for x in xs); t = E/(sd/n**0.5)
    info = (E - statistics.mean(x[3] for x in xs))/2
    per = collections.defaultdict(list)
    for x in xs: per[x[0]].append(x[2])
    pos = sum(1 for v in per.values() if statistics.mean(v) > 0)
    print('%-58s n %4d  E %+.4f R  t %+.2f  dirINFO %+.4f  stop med %.1f  anni+ %d/8' % (nome, n, E, t, info, statistics.median(x[1] for x in xs), pos))
    print('      ' + ' '.join('%d:%+.2f(%d)' % (y, statistics.mean(v), len(v)) for y, v in sorted(per.items())))
    eq = 0.0; pk = 0.0; dd = 0.0; st = 0; stmax = 0
    for x in xs:
        eq += x[2]; pk = max(pk, eq); dd = max(dd, pk - eq)
        st = st + 1 if x[2] < 0 else 0; stmax = max(stmax, st)
    print('      somma %+.1f R | DD massimo %.1f R | serie perdente piu lunga %d' % (eq, dd, stmax))

if ETX:
    run('CE8  GEMELLO ETX: gap-down>=0,50% corto, scala invariante', lambda g: g <= -0.005, scala=True)
    run('CE8b GEMELLO ETX: gap-down>=0,35% corto, scala invariante', lambda g: g <= -0.0035, scala=True)
    run('CE8c GEMELLO ETX: gap-down>=0,75% corto, scala invariante', lambda g: g <= -0.0075, scala=True)
    run('CE8d GEMELLO ETX: LUNGO su gap-up>=0,50%, scala invariante', lambda g: g >= 0.005, verso=+1, scala=True)
    run('CE8e GEMELLO ETX: stessa meccanica corta, |gap|<0,25%', lambda g: abs(g) < 0.0025, scala=True)
    sys.exit()
if GEMELLO:
    run('CE7  GEMELLO SPX: gap-down>=0,50% corto, scala invariante', lambda g: g <= -0.005, scala=True)
    run('CE7b GEMELLO SPX: gap-down>=0,35% corto, scala invariante', lambda g: g <= -0.0035, scala=True)
    run('CE7c GEMELLO SPX: LUNGO su gap-up>=0,50%, scala invariante', lambda g: g >= 0.005, verso=+1, scala=True)
    run('CE7d GEMELLO SPX: stessa meccanica corta, |gap|<0,25%', lambda g: abs(g) < 0.0025, scala=True)
    sys.exit()
run('RIF  P2d gap-down>=0,50% corto (deve riprodurre la sonda)', lambda g: g <= -0.005)
run('CE1  P2d in scala invariante (pav 0,27 ATR, costo scalato)', lambda g: g <= -0.005, scala=True)
run('CE1b P2c (>=0,25%) in scala invariante', lambda g: g <= -0.0025, scala=True)
run('CE2  stessa meccanica corta, TUTTE le sedute', lambda g: True)
run('CE2b stessa meccanica corta, |gap| < 0,25% (giorni senza gap)', lambda g: abs(g) < 0.0025)
run('CE3  corto nei giorni di gap-UP >= 0,50%', lambda g: g >= 0.005)
run('CE4  P2d senza bersaglio (stop o tempo)', lambda g: g <= -0.005, target=False)
run('CE5  LUNGO su gap-up >= 0,50% (specchio della famiglia)', lambda g: g >= 0.005, verso=+1)
run('CE5b LUNGO su gap-up >= 0,25%', lambda g: g >= 0.0025, verso=+1)
run('CE6a gap-down >= 0,35%', lambda g: g <= -0.0035)
run('CE6b gap-down >= 0,75%', lambda g: g <= -0.0075)
run('CE6c gap-down >= 0,35% in scala invariante', lambda g: g <= -0.0035, scala=True)
