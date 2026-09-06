#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- TASSI, quinto passo: IL SEGNALE IN UNITA' DI R.
# Finora l'uscita era a TEMPO FISSO senza stop: non si puo' dire se
# l'edge sta sopra il cancello di casa, perche' senza stop non esiste R.
# Qui si mette la geometria: SL = a x ATR(60'), TP = b x SL, tempo
# massimo H barre M5. Ambiguita' intrabarra risolta SEMPRE A SFAVORE
# (se in una barra M5 il prezzo tocca sia TP sia SL -> conta lo SL).
#
# CANCELLO CONGELATO PRIMA DEI NUMERI (FIRMA 2 di progetto):
#   attesa NETTA >= +0,075 R  ·  n >= 150  ·  >= 7 anni positivi su 9
# Costo A/R dichiarato 0,25 $ (spread BCM oro [NON MISURATO IN REPO]).
# =====================================================================
import pickle, os
import numpy as np
from collections import defaultdict

D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))
ks_o = sorted(M["XAU_USD"]); ks_b = sorted(M["USB10Y_USD"])
TO = np.array([k.timestamp() for k in ks_o]); YO = np.array([k.year for k in ks_o])
OO = np.array([M["XAU_USD"][k][0] for k in ks_o]); HH_ = np.array([M["XAU_USD"][k][1] for k in ks_o])
LL = np.array([M["XAU_USD"][k][2] for k in ks_o]); CO = np.array([M["XAU_USD"][k][3] for k in ks_o])
TB = np.array([k.timestamp() for k in ks_b]); CB = np.array([M["USB10Y_USD"][k][3] for k in ks_b])
pO = {t: i for i, t in enumerate(TO)}
COSTO = 0.25

def roll_std(x, w):
    c1=np.concatenate(([0.0],np.cumsum(x))); c2=np.concatenate(([0.0],np.cumsum(x*x)))
    n=len(x); out=np.full(n,np.nan); i=np.arange(w,n)
    s=c1[i]-c1[i-w]; ss=c2[i]-c2[i-w]; out[i]=np.sqrt(np.maximum(ss/w-(s/w)**2,0)); return out
def z_of(C,T,K,w=500):
    r=np.full(len(C),np.nan); r[K:]=C[K:]/C[:-K]-1.0
    z=r/roll_std(np.nan_to_num(r),w)
    ok=np.full(len(C),False); ok[K:]=(T[K:]-T[:-K])<=K*300*3
    z[~ok]=np.nan; return z

# ATR "vero" M5 su 12 barre (1 ora), calcolato SOLO sul passato
tr = np.maximum(HH_-LL, np.maximum(np.abs(HH_-np.roll(CO,1)), np.abs(LL-np.roll(CO,1))))
tr[0]=HH_[0]-LL[0]
c=np.concatenate(([0.0],np.cumsum(tr)))
ATR=np.full(len(CO),np.nan); ATR[12:]=(c[12:-0 or None][:len(CO)-12]-c[:len(CO)-12])/12 if False else np.nan
# calcolo pulito
csum=np.cumsum(tr)
ATR=np.full(len(CO),np.nan)
ATR[12:]=(csum[12:]-np.concatenate(([0.0],csum[:-13])))/12

K=6
ZB=z_of(CB,TB,K); ZO=z_of(CO,TO,K)

def simula(i0, verso, sl_d, tp_d, H):
    """ingresso all'APERTURA della barra i0+1, prezzi M5, ambiguita' a sfavore."""
    e=i0+1
    if e+H>=len(CO): return None
    if TO[e+H]-TO[e] > H*300*3: return None
    px=OO[e]
    sl = px - verso*sl_d
    tp = px + verso*tp_d
    for j in range(e, e+H+1):
        hi, lo = HH_[j], LL[j]
        colpo_sl = (lo<=sl) if verso>0 else (hi>=sl)
        colpo_tp = (hi>=tp) if verso>0 else (lo<=tp)
        if colpo_sl: return -sl_d            # a sfavore: lo SL vince l'ambiguita'
        if colpo_tp: return  tp_d
    return verso*(CO[e+H]-px)

print("="*132)
print(f"DISEGNO C in unita' di R — SL = a x ATR(60'), TP = b x SL, tempo max H. Costo A/R {COSTO:.2f}$.")
print(f"CANCELLO congelato: attesa NETTA >= +0,075 R · n >= 150 · anni positivi >= 7/9")
print("="*132)
print(f"{'zb':>4} {'a':>5} {'b':>5} {'H':>4} | {'n':>5} {'R medio':>9} {'PF':>6} {'WR%':>6} {'anni+':>6} {'SLmed$':>7}")
righe=[]
for zb_ in (2.5, 3.0, 3.5):
    sel=np.where(np.abs(ZB)>=zb_)[0]
    for a in (0.75, 1.0, 1.5):
        for b in (1.0, 1.5, 2.0):
            for H in (12, 24):
                res=[]; anni=[]; sls=[]
                ultimo=-1e18
                for ib in sel:
                    t=TB[ib]; io_=pO.get(t)
                    if io_ is None: continue
                    if np.isnan(ZO[io_]) or abs(ZO[io_])>=1.0: continue
                    if np.isnan(ATR[io_]) or ATR[io_]<=0: continue
                    if t<ultimo+H*300: continue
                    sl_d=a*ATR[io_]
                    if sl_d<0.30: continue           # stop sotto 3 volte il costo = non si opera
                    r=simula(io_, int(np.sign(ZB[ib])), sl_d, b*sl_d, H)
                    if r is None: continue
                    res.append((r-COSTO)/sl_d); anni.append(int(YO[io_])); sls.append(sl_d); ultimo=t
                if len(res)<60: continue
                v=np.asarray(res,float)
                pa=defaultdict(float)
                for x,y in zip(v,anni): pa[y]+=x
                pos=sum(1 for y in pa if pa[y]>0)
                gw=v[v>0].sum(); gl=-v[v<0].sum()
                wr=100.0*(v>0).mean()
                passa = (v.mean()>=0.075) and (len(v)>=150) and (pos>=7)
                print(f"{zb_:>4.1f} {a:>5.2f} {b:>5.2f} {H*5:>4} | {len(v):>5} {v.mean():>+9.4f} "
                      f"{gw/gl if gl>0 else 9.99:>6.3f} {wr:>6.1f} {pos:>3}/{len(pa):<2} {np.median(sls):>7.2f}"
                      f"{'   <== PASSA' if passa else ''}")
                righe.append((zb_,a,b,H,len(v),v.mean(),pos,len(pa),dict((y,round(pa[y],2)) for y in sorted(pa))))
print("\nMIGLIORI per R medio netto (n>=150):")
for r in sorted([x for x in righe if x[4]>=150], key=lambda x:-x[5])[:6]:
    print(f"  zb={r[0]} a={r[1]} b={r[2]} H={r[3]*5}'  n={r[4]}  R={r[5]:+.4f}  anni+={r[6]}/{r[7]}")
    print(f"     {r[8]}")
