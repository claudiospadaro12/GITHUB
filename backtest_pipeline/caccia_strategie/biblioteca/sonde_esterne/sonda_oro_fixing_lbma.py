#!/usr/bin/env python3
# =====================================================================
# SONDA ASTA LBMA (il "fixing" dell'oro) — 06/09/2026
# Meccanismo specifico dell'ORO che il progetto non ha mai misurato:
# il prezzo di riferimento mondiale dell'oro si forma in DUE ASTE
# giornaliere (LBMA Gold Price), alle 10:30 e alle 15:00 ORA DI LONDRA.
#
# IPOTESI (congelata PRIMA dei numeri): nella finestra dell'asta il
# prezzo si muove per ragioni di ORDINE (chi deve stampare il
# benchmark), non di informazione; quindi una parte di quel movimento
# si RIASSORBE nei minuti successivi -> FADE del movimento d'asta.
# Controtesi da misurare nello stesso giro: il movimento CONTINUA.
#
# CRITERI CONGELATI: n>=150 · attesa netta >= +0,075 R (SL=1xATR60') ·
# >= 7 anni positivi su 9. Costo A/R dichiarato 0,25 $.
# LIMITI: Oanda M1->M5 (FutureSharks, GPL-3.0), NON BCM, OHLC non tick,
# 2012-01 -> 2020-05. Ora di Londra ricostruita con la regola DST UE.
# =====================================================================
import pickle, os, datetime as dt
import numpy as np
from collections import defaultdict

D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))
ks = sorted(M["XAU_USD"])
TS = np.array([k.timestamp() for k in ks]); YR = np.array([k.year for k in ks])
OO = np.array([M["XAU_USD"][k][0] for k in ks]); HI = np.array([M["XAU_USD"][k][1] for k in ks])
LO = np.array([M["XAU_USD"][k][2] for k in ks]); CL = np.array([M["XAU_USD"][k][3] for k in ks])
IDX = {k: i for i, k in enumerate(ks)}
COSTO = 0.25

def ultima_domenica(anno, mese):
    d = dt.date(anno, mese, 31 if mese == 3 else 31)
    while d.month != mese: d -= dt.timedelta(days=1)
    while d.weekday() != 6: d -= dt.timedelta(days=1)
    return d

def londra_offset(d):
    """UE: ora legale dall'ultima domenica di marzo all'ultima di ottobre (01:00 UTC)."""
    a = d.year
    return 1 if ultima_domenica(a, 3) <= d.date() < ultima_domenica(a, 10) else 0

# ATR M5 su 12 barre (1 ora), solo passato
tr = np.maximum(HI-LO, np.maximum(np.abs(HI-np.roll(CL,1)), np.abs(LO-np.roll(CL,1)))); tr[0]=HI[0]-LO[0]
cs = np.cumsum(tr); ATR = np.full(len(CL), np.nan)
ATR[12:] = (cs[12:]-np.concatenate(([0.0], cs[:-13])))/12

def simula(j_segnale, verso, sl_d, tp_d, H):
    # CORREZIONE 06/09: il segnale usa la CHIUSURA della barra j, quindi
    # l'ingresso puo' avvenire solo all'APERTURA DELLA BARRA DOPO.
    # La prima versione entrava su OO[j] = look-ahead di una barra M5, e
    # produceva PF 2,7 / WR 76% / 9 anni su 9. Numeri finti.
    e = j_segnale + 1
    if e+H >= len(CL): return None
    if TS[e+H]-TS[e] > H*300*3: return None
    px = OO[e]; sl = px - verso*sl_d; tp = px + verso*tp_d
    for j in range(e, e+H+1):
        if (LO[j] <= sl) if verso > 0 else (HI[j] >= sl): return -sl_d
        if (HI[j] >= tp) if verso > 0 else (LO[j] <= tp): return tp_d
    return verso*(CL[e+H]-px)

def valuta(nome, res, anni):
    if len(res) < 40:
        print(f"{nome:64s} n={len(res):4d} (campione insufficiente)"); return
    v = np.asarray(res, float)
    pa = defaultdict(float)
    for x, a in zip(v, anni): pa[a] += x
    pos = sum(1 for a in pa if pa[a] > 0)
    gw = v[v>0].sum(); gl = -v[v<0].sum()
    t = v.mean()/(v.std()/np.sqrt(len(v)))
    ok = (v.mean() >= 0.075) and (len(v) >= 150) and (pos >= 7)
    print(f"{nome:64s} n={len(v):4d} R={v.mean():+7.4f} t={t:+5.2f} PF={gw/gl if gl>0 else 9.99:5.3f} "
          f"WR={100*(v>0).mean():4.1f}% anni+={pos}/{len(pa)}{'   <== PASSA' if ok else ''}")

# gli istanti d'asta: 10:30 e 15:00 ora di Londra
aste = {"MATTINO 10:30 Londra": (10, 30), "POMERIGGIO 15:00 Londra": (15, 0)}
print("="*140)
print(f"ASTA LBMA — fade / continuazione del movimento d'asta sull'oro. SL=1xATR(60'), costo A/R {COSTO:.2f}$.")
print("  cancello: R netto >= +0,075 · n>=150 · anni+ >= 7/9")
print("="*140)
for nome, (ah, am) in aste.items():
    print(f"\n### {nome}")
    for PRE in (3, 6):            # barre M5 di finestra d'asta (15' / 30')
        for H in (6, 12, 24):     # 30' / 60' / 120' di permanenza
            for b in (1.0, 1.5, 2.0):
                for modo in ("FADE", "CONTINUA"):
                    res_f, anni_f = [], []
                    for i, k in enumerate(ks):
                        if k.minute != 0 and k.minute != 30: continue
                        off = londra_offset(k)
                        lh = (k.hour + off) % 24
                        if lh != ah or k.minute != am: continue
                        if k.weekday() >= 5: continue
                        j = i  # istante di fine asta
                        if j-PRE < 0 or np.isnan(ATR[j]) or ATR[j] <= 0: continue
                        mov = CL[j] - CL[j-PRE]
                        if abs(mov) < 0.5*ATR[j]: continue      # serve un movimento d'asta vero
                        v = -1 if modo == "FADE" else 1
                        verso = int(np.sign(mov))*v
                        sl_d = 1.0*ATR[j]
                        if sl_d < 0.30: continue
                        r = simula(j, verso, sl_d, b*sl_d, H)
                        if r is None: continue
                        res_f.append((r-COSTO)/sl_d); anni_f.append(k.year)
                    valuta(f"  finestra {PRE*5:2d}'  {modo:8s}  TP={b}xSL  H={H*5:3d}'", res_f, anni_f)
