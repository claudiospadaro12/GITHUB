#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- TASSI  (caccia oro/argento, 06/09/2026)
# MISURA DI OCCASIONI, MAI UN VERDETTO.
#
# IPOTESI (congelata PRIMA dei numeri):
#   L'oro e' l'inverso del tasso reale. Il mercato obbligazionario e' piu'
#   liquido e prezza per primo. Quindi un movimento AMPIO del future sul
#   Treasury 10 anni in K minuti dovrebbe essere seguito da una deriva
#   dell'oro NELLA STESSA DIREZIONE (bond su = rendimenti giu = oro su)
#   nei successivi H minuti.
#
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   C1  n >= 150 eventi per finestra
#   C2  t-stat della media per evento > 2,0
#   C3  positivo in almeno 7 anni su 9
#   C4  media per evento > 2x il controllo casuale (stessi istanti, segno
#       casuale) in valore assoluto
#   C5  il verso deve essere quello della TESI (bond su -> oro su)
#
# LIMITI DICHIARATI: Oanda M1->M5 (FutureSharks, GPL-3.0), NON BCM, OHLC
#   non tick, ZERO costi/spread, 2012-01 -> 2020-05 (non copre 2021-2026).
#   Fuso UTC su entrambe le serie.
# =====================================================================
import pickle, os, random, datetime as dt
import numpy as np
from collections import defaultdict

random.seed(20260906); np.random.seed(20260906)
D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))

def arr(d):
    ks = sorted(d)
    return (np.array([k.timestamp() for k in ks]),
            np.array([d[k][3] for k in ks]),
            np.array([k.year for k in ks]),
            np.array([k.hour for k in ks]),
            ks)

TO, CO, YO, HO, KO = arr(M["XAU_USD"])
TB, CB, YB, HB, KB = arr(M["USB10Y_USD"])
print("=" * 116)
print("SONDA ORO <- TASSI | XAU_USD vs USB10Y_USD (future Treasury 10y), M5, UTC")
print(f"oro {len(CO):,} barre {KO[0]:%Y-%m-%d}->{KO[-1]:%Y-%m-%d} | bond {len(CB):,} barre {KB[0]:%Y-%m-%d}->{KB[-1]:%Y-%m-%d}")
print("=" * 116)

def roll_std(x, w):
    """std mobile su w osservazioni PRECEDENTI (nessun look-ahead)."""
    c1 = np.concatenate(([0.0], np.cumsum(x)))
    c2 = np.concatenate(([0.0], np.cumsum(x * x)))
    n = len(x); out = np.full(n, np.nan)
    i = np.arange(w, n)
    s = c1[i] - c1[i - w]; ss = c2[i] - c2[i - w]
    var = ss / w - (s / w) ** 2
    out[i] = np.sqrt(np.maximum(var, 0))
    return out

def rapporto(nome, val, anni):
    if len(val) < 20:
        print(f"{nome:56s} n={len(val):5d}  (campione insufficiente)"); return None
    val = np.asarray(val, float); m = val.mean(); sd = val.std() or 1e-12
    t = m / (sd / np.sqrt(len(val)))
    pa = defaultdict(float)
    for v, a in zip(val, anni): pa[a] += v
    pos = sum(1 for a in pa if pa[a] > 0)
    gw = val[val > 0].sum(); gl = -val[val < 0].sum()
    pf = gw / gl if gl > 0 else float("inf")
    print(f"{nome:56s} n={len(val):5d} media={m:+7.4f}$ t={t:+5.2f} PF={pf:5.3f} anni+={pos}/{len(pa)}")
    return dict(n=int(len(val)), m=float(m), t=float(t), pf=float(pf), pos=pos,
                anni=len(pa), per_anno={a: round(pa[a], 1) for a in sorted(pa)})

# indice: per ogni istante bond, la barra oro con lo stesso timestamp
pos_oro = {t: i for i, t in enumerate(TO)}

RIS = {}
for K in (3, 6, 12):                      # 15 / 30 / 60 min di finestra segnale
    r = np.full(len(CB), np.nan)
    r[K:] = CB[K:] / CB[:-K] - 1.0
    sd = roll_std(np.nan_to_num(r), 500)
    z = r / sd
    sel = np.where(np.abs(z) >= 2.0)[0]
    # continuita' temporale del segnale (niente buchi di sessione)
    sel = sel[(TB[sel] - TB[sel - K]) <= K * 300 * 3]
    segno = np.sign(r[sel]).astype(int)
    print(f"\n--- finestra segnale bond = {K*5:2d} min, |z|>=2.0  ->  eventi grezzi {len(sel):,}")
    for H in (6, 12, 24):                 # 30 / 60 / 120 min in avanti sull'oro
        val, anni, ctl = [], [], []
        for j, ib in enumerate(sel):
            io_ = pos_oro.get(TB[ib])
            if io_ is None or io_ + H >= len(CO): continue
            if TO[io_ + H] - TO[io_] > H * 300 * 3: continue
            f = CO[io_ + H] - CO[io_]
            val.append(segno[j] * f); anni.append(int(YO[io_]))
            ctl.append(random.choice((1, -1)) * f)
        rr = rapporto(f"  ORO {H*5:3d}' dopo, VERSO DELLA TESI (bond su->oro su)", val, anni)
        rapporto(f"  ORO {H*5:3d}' dopo, controllo a segno casuale", ctl, anni)
        if rr: RIS[(K, H)] = rr

# ---------- falsificazione: l'oro guida il bond? ----------
print("\n" + "=" * 116)
print("FALSIFICAZIONE — stesso disegno al contrario: l'ORO guida il BOND?")
print("=" * 116)
K = 6
r = np.full(len(CO), np.nan); r[K:] = CO[K:] / CO[:-K] - 1.0
sd = roll_std(np.nan_to_num(r), 500); z = r / sd
sel = np.where(np.abs(z) >= 2.0)[0]
sel = sel[(TO[sel] - TO[sel - K]) <= K * 300 * 3]
segno = np.sign(r[sel]).astype(int)
pos_bond = {t: i for i, t in enumerate(TB)}
val, anni = [], []
for j, io_ in enumerate(sel):
    ib = pos_bond.get(TO[io_])
    if ib is None or ib + 12 >= len(CB): continue
    if TB[ib + 12] - TB[ib] > 12 * 300 * 3: continue
    val.append(segno[j] * (CB[ib + 12] - CB[ib])); anni.append(int(YO[io_]))
rapporto("  BOND 60' dopo un movimento ampio dell'ORO (in punti bond)", val, anni)

# ---------- pannello di contesto: deriva oraria dell'oro ----------
print("\n" + "=" * 116)
print("PANNELLO — deriva media dell'ORO nell'ora successiva, per ORA UTC (2012-2020)")
print("  ora server BCM = UTC+1 (inverno) / UTC+2 (estate). Qui e' UTC PURO.")
print("=" * 116)
start = np.where(HO != np.roll(HO, 1))[0]
per = defaultdict(list); pan = defaultdict(lambda: defaultdict(float))
for i in start:
    if i + 12 >= len(CO): continue
    if TO[i + 12] - TO[i] > 12 * 300 * 3: continue
    f = CO[i + 12] - CO[i]
    per[int(HO[i])].append(f); pan[int(HO[i])][int(YO[i])] += f
for h in range(24):
    v = np.asarray(per.get(h, []), float)
    if len(v) < 100: continue
    m = v.mean(); t = m / (v.std() / np.sqrt(len(v)))
    pos = sum(1 for a in pan[h] if pan[h][a] > 0)
    print(f"  {h:02d}:00 UTC n={len(v):5d} media/ora={m:+7.4f}$ t={t:+5.2f} anni+={pos}/{len(pan[h])} tot={v.sum():+8.1f}$")
