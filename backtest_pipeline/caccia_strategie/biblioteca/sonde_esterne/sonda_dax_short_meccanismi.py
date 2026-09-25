#!/usr/bin/env python3
# =====================================================================
#  SONDA ESTERNA -- MECCANISMI SHORT INTRADAY SUL DAX (seconda caccia R251)
#  Nata il 25/09/2026: backtest_pipeline/caccia_strategie/CACCIA_DAX_SHORT_2026-09-25.md
# ---------------------------------------------------------------------
#  DATI: DAT_ASCII_GRXEUR_M1_<anno>.csv (histdata, GPL-3.0) scaricati da
#    https://raw.githubusercontent.com/FutureSharks/financial-data/master/
#    pyfinancialdata/data/stocks/histdata/GRXEUR/   -> dati/GRXEUR_<anno>.csv
#    2011-2018 (8 anni: crollo 2011, crollo 2015, laterale 2016, orso 2018).
#  OROLOGIO: ora file + 5 = ora server (vecchio orologio BCM = IT-1), collaudato
#    tre volte in casa (05/09, 12/09, sonda_cono_rumore_dax.py par. 2.1).
#    Cash DAX 08:00-16:30 server. Apertura USA 09:30 NY = file 09:30 = 14:30 server.
#    10:00 NY = file 10:00 = 15:00 server (tutto l'anno: il file e' in ora NY).
#  COSTO: 1,70 punti indice per operazione = mediana MISURATA dello spread D30EUR
#    all'ora 08 (la piu' alta). Commissione 0. Nessuno slippage (dichiarato).
#  OHLC M1, ambiguita' intrabarra SEMPRE a sfavore (stop prima del target).
#  NON E' BCM, NON SONO TICK: e' SCREENING, mai un verdetto.
# ---------------------------------------------------------------------
#  CRITERI CONGELATI PRIMA DI QUALUNQUE NUMERO (25/09/2026):
#   G1 MERITO     E netta (in R) > 0 con t >= 2,0 su tutti gli 8 anni.
#   G2 DIREZIONE  informazione direzionale = (E_short - E_long_appaiato)/2
#                 >= +0,05 R. Il controllo appaiato e': stessa barra, stessa
#                 distanza di stop, stesso bersaglio speculare, lato opposto.
#   G3 STABILITA' E netta > 0 in almeno 6 anni su 8.
#   G4 COSTO      stop mediano >= 68 punti (= 40 x 1,70). Sotto: ESCLUSO PER
#                 COSTO, col numero. (Lo stop ha un pavimento a 68 per
#                 costruzione nelle celle in cui lo dichiaro.)
#   G5 CAMPIONE   (informativo) eventi attesi sulla finestra BCM ~440 sedute
#                 = tasso/seduta x 440. Sotto 300 = merito sospeso sul feed BCM.
#   PASSA-SONDA solo se G1 e G2 e G3 e G4.
#   MOLTEPLICITA': 10 celle. Una cella che passa e' un indizio da portare al
#   tester, non una scoperta. Le celle sono elencate per nome qui sotto:
#   P1a ITSM r1 con notte · P1b ITSM r1 solo seduta · P2a gap-up fade >=0,25%
#   P2b gap-up fade >=0,50% · P2c gap-down continuazione >=0,25% ·
#   P2d gap-down continuazione >=0,50% · P3a apertura USA INVERSIONE dopo
#   mattina forte · P3b apertura USA CONTINUAZIONE dopo mattina debole ·
#   P4 le 10:00 di New York, corto incondizionato · P5 cono di rumore SOLO CORTO.
# =====================================================================
import glob, sys, statistics, collections
from datetime import datetime, timedelta

PAT = sys.argv[1] if len(sys.argv) > 1 else 'dati/GRXEUR_*.csv'
COSTO = 1.70
PAV = 68.0          # 40 x spread
OPEN = 8*60; CLOSE = 16*60+29   # server, ultima barra M1 della cash = 16:29

by = collections.defaultdict(dict)
for p in sorted(glob.glob(PAT)):
    for ln in open(p):
        q = ln.strip().split(';')
        if len(q) < 5: continue
        t = datetime.strptime(q[0], '%Y%m%d %H%M%S') + timedelta(hours=5)
        by[t.date()][t.hour*60+t.minute] = (float(q[1]), float(q[2]), float(q[3]), float(q[4]))

giorni = sorted(d for d in by if any(m in by[d] for m in range(OPEN, OPEN+5))
                and sum(1 for m in by[d] if OPEN <= m <= CLOSE) >= 300)
print('giornate cash valide', len(giorni), giorni[0], '->', giorni[-1])

def bar(d, m): return by[d].get(m)
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
    """da m0 incluso (la barra d'ingresso conta: entro all'OPEN di m0).
    stop a distanza dist, target tgt (prezzo) opzionale, uscita a close(mend).
    pessimista: stop prima del target nella stessa barra. ritorna punti lordi."""
    sl = entry - dist if verso > 0 else entry + dist
    ultimo = entry
    for k in range(m0, mend+1):
        b = by[d].get(k)
        if not b: continue
        o, h, l, c = b
        ultimo = c
        if verso > 0:
            if l <= sl: return -dist
            if tgt is not None and h >= tgt: return tgt - entry
        else:
            if h >= sl: return -dist
            if tgt is not None and l <= tgt: return entry - tgt
    cc = close_at(d, mend)
    if cc is None: cc = ultimo   # buco di barre a fine finestra: ultimo close visto
    return (cc - entry) * verso

# ATR20 della giornata cash (high-low 08:00-16:29), sulle 20 sedute PRECEDENTI
rng = {}
for d in giorni:
    h, l = hilo(d, OPEN, CLOSE); rng[d] = h - l
atr20 = {}; prevd = {}
for i, d in enumerate(giorni):
    if i >= 20: atr20[d] = statistics.mean(rng[x] for x in giorni[i-20:i])
    if i >= 1: prevd[d] = giorni[i-1]

# ATR14 su M30 (per P1: lo stop dell'EA e' 2 x ATR(14) M30), barre M30 della cash
def m30_ranges(d):
    out = []
    for s in range(OPEN, CLOSE+1, 30):
        h, l = hilo(d, s, min(s+29, CLOSE))
        if h is not None: out.append(h - l)
    return out

celle = collections.OrderedDict()
def reg(nome, d, dist, lordo_s, lordo_l):
    celle.setdefault(nome, []).append((d.year, dist, (lordo_s-COSTO)/dist, (lordo_l-COSTO)/dist, lordo_s))

m30hist = collections.deque(maxlen=14*17)
for d in giorni:
    if d not in atr20 or d not in prevd:
        m30hist.extend(m30_ranges(d)); continue
    pd = prevd[d]
    PC = close_at(pd, CLOSE); O, _ = open_at(d, OPEN)
    A = atr20[d]
    if PC is None or O is None:
        m30hist.extend(m30_ranges(d)); continue
    # ---------- P1 ITSM (Gao / Li-Sakkas-Urquhart): ultima mezz'ora 16:00-16:29
    c0829 = close_at(d, OPEN+29)
    atr_m30 = statistics.mean(list(m30hist)[-14:]) if len(m30hist) >= 14 else None
    e1, k1 = open_at(d, 16*60)
    if c0829 and atr_m30 and e1:
        dist = max(2.0*atr_m30, 1e-9)
        for nome, r1 in (('P1a ITSM r1 con notte', c0829/PC-1), ('P1b ITSM r1 solo seduta', c0829/O-1)):
            if r1 < 0:
                reg(nome, d, dist, cammina(d, k1, -1, e1, dist), cammina(d, k1, +1, e1, dist))
    # ---------- P2 gap
    gap = O - PC; gp = gap/PC
    e2, k2 = open_at(d, OPEN+5)
    if e2:
        for nome, soglia in (('P2a gap-up fade >=0,25%', 0.0025), ('P2b gap-up fade >=0,50%', 0.0050)):
            if gp >= soglia and e2 - PC > 0:
                dist = max(PAV, gap); rew = e2 - PC
                reg(nome, d, dist, cammina(d, k2, -1, e2, dist, tgt=PC), cammina(d, k2, +1, e2, dist, tgt=e2+rew))
    for nome, soglia in (('P2c gap-down continuazione >=0,25%', -0.0025), ('P2d gap-down continuazione >=0,50%', -0.0050)):
        if gp <= soglia:
            rh, rl = hilo(d, OPEN, OPEN+14)
            # ingresso: prima barra M1 fra 08:15 e 09:30 che rompe sotto il minimo del range 15'
            for k in range(OPEN+15, OPEN+90):
                b = by[d].get(k)
                if not b: continue
                if b[2] < rl:
                    entry = rl if b[0] >= rl else b[0]
                    dist = max(PAV, rh - entry)
                    reg(nome, d, dist, cammina(d, k, -1, entry, dist, tgt=entry-2*dist, mend=CLOSE-5),
                        cammina(d, k, +1, entry, dist, tgt=entry+2*dist, mend=CLOSE-5))
                    break
    # ---------- P3 apertura USA (14:30 server)
    c1429 = close_at(d, 14*60+29); e3, k3 = open_at(d, 14*60+30)
    if c1429 and e3:
        M = c1429 - O; dist = max(PAV, 0.35*A)
        if M >= 0.5*A:
            reg('P3a USA inversione (mattina >= +0,5 ATR)', d, dist, cammina(d, k3, -1, e3, dist), cammina(d, k3, +1, e3, dist))
        if M <= -0.5*A:
            reg('P3b USA continuazione (mattina <= -0,5 ATR)', d, dist, cammina(d, k3, -1, e3, dist), cammina(d, k3, +1, e3, dist))
    # ---------- P4 10:00 NY = 15:00 server, esce 15:29
    e4, k4 = open_at(d, 15*60)
    if e4:
        dist = max(PAV, 0.35*A)
        reg('P4 10:00 NY corto incondizionato', d, dist, cammina(d, k4, -1, e4, dist, mend=15*60+29), cammina(d, k4, +1, e4, dist, mend=15*60+29))
    m30hist.extend(m30_ranges(d))

# ---------- P5 cono di rumore (formula di ABTG_OutOfNoise r.697-700, gap adjustment ON), SOLO CORTO
CD = 14
checks = [m for m in range(OPEN+30, CLOSE+2, 30)]
move = collections.defaultdict(dict)
for d in giorni:
    O, _ = open_at(d, OPEN)
    if not O: continue
    for m in checks:
        c = close_at(d, min(m, CLOSE))
        if c: move[d][m] = abs(c/O-1)
for i, d in enumerate(giorni):
    if i < CD or d not in prevd: continue
    prev = giorni[i-CD:i]; O, _ = open_at(d, OPEN); pc = close_at(prevd[d], CLOSE)
    if not O or not pc: continue
    for m in checks:
        if m > CLOSE: break
        vals = [move[p][m] for p in prev if m in move[p]]
        if len(vals) < CD: continue
        s = statistics.mean(vals)
        hi = max(O, pc)*(1+s); lo = min(O, pc)*(1-s)
        c = close_at(d, m)
        if c is None or c >= lo: continue
        dist = hi - lo
        # ingresso al close della barra di controllo = apertura della barra successiva (approssimato col close)
        reg('P5 cono di rumore SOLO CORTO', d, dist, cammina(d, m+1, -1, c, dist), cammina(d, m+1, +1, c, dist))
        break

sedute = len(giorni)
print('\nCOSTO %.2f pti/op, pavimento stop %.0f pti (40x). Sedute %d. R = distanza di stop.' % (COSTO, PAV, sedute))
print('%-44s %5s %6s %8s %6s %8s %8s %6s %7s %s' % ('cella', 'n', 'op/gg', 'E netta', 't', 'dirINFO', 'stop med', 'x spr', 'lordo', 'anni+ / E per anno'))
for nome, xs in celle.items():
    n = len(xs); E = statistics.mean(x[2] for x in xs); sd = statistics.stdev(x[2] for x in xs) if n > 1 else 0
    t = E/(sd/n**0.5) if sd else 0; El = statistics.mean(x[3] for x in xs)
    info = (E - El)/2; dm = statistics.median(x[1] for x in xs); lordo = statistics.mean(x[4] for x in xs)
    per = collections.defaultdict(list)
    for x in xs: per[x[0]].append(x[2])
    anni = ' '.join('%d:%+.2f(%d)' % (y, statistics.mean(v), len(v)) for y, v in sorted(per.items()))
    pos = sum(1 for v in per.values() if statistics.mean(v) > 0)
    g1 = E > 0 and t >= 2.0; g2 = info >= 0.05; g3 = pos >= 6; g4 = dm >= PAV
    esito = 'PASSA-SONDA' if (g1 and g2 and g3 and g4) else 'no [' + ','.join(k for k, v in (('G1', g1), ('G2', g2), ('G3', g3), ('G4', g4)) if not v) + ']'
    print('%-44s %5d %6.3f %+8.4f %+6.2f %+8.4f %8.1f %6.1f %+7.2f %d/8  %s' % (nome, n, n/sedute, E, t, info, dm, dm/COSTO, lordo, pos, esito))
    print('      ' + anni + '   | G5: attesi su 440 sedute BCM = %.0f' % (n/sedute*440))
