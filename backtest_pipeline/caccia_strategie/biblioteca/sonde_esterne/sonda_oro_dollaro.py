#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- DOLLARO (e confluenza dollaro+tassi), 06/09/2026
# Stesso disegno C gia' usato per i tassi: il DRIVER si muove forte
# mentre l'oro e' ancora fermo; si entra sull'oro nel verso implicato.
#   EUR_USD su  = dollaro giu  -> oro SU  (tesi)
#   bond su     = rendimenti giu -> oro SU (tesi, gia' misurata)
# Criteri congelati: n>=150 · t>=2,0 al NETTO di 0,25$ A/R · >=7/9 anni
# positivi · nessun anno oltre il 50% del totale.
# LIMITI: Oanda M1->M5, non BCM, OHLC, zero costi nel dato grezzo,
# 2012-01 -> 2020-05.
# =====================================================================
import pickle, os
import numpy as np
from collections import defaultdict

D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))
def arr(d):
    ks = sorted(d)
    return (np.array([k.timestamp() for k in ks]), np.array([d[k][3] for k in ks]),
            np.array([k.year for k in ks]), np.array([k.hour for k in ks]))
TO, CO, YO, HO = arr(M["XAU_USD"]); TB, CB, *_ = arr(M["USB10Y_USD"]); TE, CE, *_ = arr(M["EUR_USD"])
pO = {t:i for i,t in enumerate(TO)}; pB = {t:i for i,t in enumerate(TB)}; pE = {t:i for i,t in enumerate(TE)}
COSTO = 0.25

def roll_std(x,w):
    c1=np.concatenate(([0.0],np.cumsum(x))); c2=np.concatenate(([0.0],np.cumsum(x*x)))
    n=len(x); out=np.full(n,np.nan); i=np.arange(w,n)
    s=c1[i]-c1[i-w]; ss=c2[i]-c2[i-w]; out[i]=np.sqrt(np.maximum(ss/w-(s/w)**2,0)); return out
def z_of(C,T,K,w=500):
    r=np.full(len(C),np.nan); r[K:]=C[K:]/C[:-K]-1.0
    z=r/roll_std(np.nan_to_num(r),w)
    ok=np.full(len(C),False); ok[K:]=(T[K:]-T[:-K])<=K*300*3
    z[~ok]=np.nan; return z

def valuta(nome,val,anni):
    if len(val)<40: print(f"{nome:64s} n={len(val):5d} (campione insufficiente)"); return
    v=np.asarray(val,float)-COSTO
    pa=defaultdict(float)
    for x,a in zip(v,anni): pa[a]+=x
    pos=sum(1 for a in pa if pa[a]>0); gw=v[v>0].sum(); gl=-v[v<0].sum(); tot=v.sum()
    t=v.mean()/(v.std()/np.sqrt(len(v))); dom=max(pa.values())/tot if tot>0 else 9.9
    ok=(len(v)>=150) and (t>=2.0) and (pos>=7) and (dom<=0.5)
    print(f"{nome:64s} n={len(v):5d} netto={v.mean():+7.4f}$ t={t:+5.2f} PF={gw/gl if gl>0 else 9.99:5.3f} "
          f"anni+={pos}/{len(pa)} tot={tot:+7.0f}$ {'  <== PASSA' if ok else ''}")

K, H = 6, 12
ZB=z_of(CB,TB,K); ZE=z_of(CE,TE,K); ZO=z_of(CO,TO,K)
print("="*140)
print(f"DISEGNO C su tre driver. Segnale {K*5}', orizzonte {H*5}', un evento per finestra, costo A/R {COSTO:.2f}$.")
print("="*140)

def gira(nome, sel_idx, T_src, z_src, verso, filtro_oro=1.0, H=H):
    val, anni = [], []; ultimo=-1e18
    for i in sel_idx:
        t=T_src[i]; io_=pO.get(t)
        if io_ is None or io_+H>=len(CO): continue
        if np.isnan(ZO[io_]) or abs(ZO[io_])>=filtro_oro: continue
        if TO[io_+H]-TO[io_]>H*300*3: continue
        if t<ultimo+H*300: continue
        val.append(verso*np.sign(z_src[i])*(CO[io_+H]-CO[io_])); anni.append(int(YO[io_])); ultimo=t
    valuta(nome, val, anni)

for zmin in (2.5, 3.0, 3.5):
    print(f"\n--- soglia driver |z| >= {zmin}")
    gira(f"  ORO <- BOND  (bond su -> oro su)                |z|>={zmin}",
         np.where(np.abs(ZB)>=zmin)[0], TB, ZB, +1)
    gira(f"  ORO <- EURUSD (dollaro giu -> oro su)           |z|>={zmin}",
         np.where(np.abs(ZE)>=zmin)[0], TE, ZE, +1)
    gira(f"  ORO <- EURUSD, verso CONTRARIO (falsificazione) |z|>={zmin}",
         np.where(np.abs(ZE)>=zmin)[0], TE, ZE, -1)

# --- CONFLUENZA: bond e dollaro puntano dalla stessa parte, oro fermo ---
print("\n" + "="*140)
print("CONFLUENZA — bond E dollaro concordi, oro ancora fermo")
print("="*140)
for zb_ in (2.0, 2.5, 3.0):
    for ze_ in (1.0, 1.5, 2.0):
        val, anni = [], []; ultimo=-1e18
        for i in np.where(np.abs(ZB)>=zb_)[0]:
            t=TB[i]; io_=pO.get(t); ie=pE.get(t)
            if io_ is None or ie is None or io_+H>=len(CO): continue
            if np.isnan(ZE[ie]) or abs(ZE[ie])<ze_: continue
            if np.sign(ZE[ie])!=np.sign(ZB[i]): continue    # concordi
            if np.isnan(ZO[io_]) or abs(ZO[io_])>=1.0: continue
            if TO[io_+H]-TO[io_]>H*300*3: continue
            if t<ultimo+H*300: continue
            val.append(np.sign(ZB[i])*(CO[io_+H]-CO[io_])); anni.append(int(YO[io_])); ultimo=t
        valuta(f"  |z_bond|>={zb_}  &  |z_eur|>={ze_}  concordi, oro fermo", val, anni)

# --- e la controprova: bond e dollaro DISCORDI ---
print("\n" + "="*140)
print("CONTROPROVA — bond e dollaro DISCORDI (segno dal bond)")
print("="*140)
for zb_ in (2.5,):
    for ze_ in (1.5,):
        val, anni = [], []; ultimo=-1e18
        for i in np.where(np.abs(ZB)>=zb_)[0]:
            t=TB[i]; io_=pO.get(t); ie=pE.get(t)
            if io_ is None or ie is None or io_+H>=len(CO): continue
            if np.isnan(ZE[ie]) or abs(ZE[ie])<ze_: continue
            if np.sign(ZE[ie])==np.sign(ZB[i]): continue
            if np.isnan(ZO[io_]) or abs(ZO[io_])>=1.0: continue
            if TO[io_+H]-TO[io_]>H*300*3: continue
            if t<ultimo+H*300: continue
            val.append(np.sign(ZB[i])*(CO[io_+H]-CO[io_])); anni.append(int(YO[io_])); ultimo=t
        valuta(f"  |z_bond|>={zb_}  &  |z_eur|>={ze_}  DISCORDI", val, anni)
