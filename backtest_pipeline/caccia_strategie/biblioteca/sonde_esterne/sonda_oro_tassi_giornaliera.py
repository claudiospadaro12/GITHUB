#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- TASSI, quarto passo: LA SCALA GIORNALIERA.
# Motivo: a 60' l'effetto lordo e' reale (t=+4,12 sul disegno C) ma il
# costo se lo mangia. Su scala giornaliera il movimento e' 10-40 volte
# lo spread: il costo diventa trascurabile. La domanda e' se l'effetto
# c'e' ancora quando si allarga la finestra.
#
# Disegno: ogni giorno a un'ORA FISSA (ora del "taglio"), si guarda il
# rendimento del future Treasury 10y nelle ultime N ore; se e' oltre
# +/- Z deviazioni standard mobili, si entra sull'oro NEL VERSO DEL
# BOND e si esce dopo M ore. Un solo evento al giorno, nessuna
# sovrapposizione. Simmetrico (long E short).
#
# CRITERI CONGELATI PRIMA DEI NUMERI: n>=150 · t>=2,0 al netto di 0,25$
# di costo A/R · >=7 anni positivi su 9 · nessun anno che valga da solo
# piu' del 50% del totale.
# =====================================================================
import pickle, os
import numpy as np
from collections import defaultdict

D = os.path.dirname(os.path.abspath(__file__))
M = pickle.load(open(os.path.join(D, "cache", "m5.pkl"), "rb"))
def arr(d):
    ks = sorted(d)
    return (np.array([k.timestamp() for k in ks]), np.array([d[k][3] for k in ks]),
            np.array([k.year for k in ks]), np.array([k.hour for k in ks]),
            np.array([k.minute for k in ks]), np.array([k.weekday() for k in ks]))
TO, CO, YO, HO, MO, WO = arr(M["XAU_USD"])
TB, CB, YB, HB, MB, WB = arr(M["USB10Y_USD"])
pos_oro = {t: i for i, t in enumerate(TO)}
COSTO = 0.25

def roll_std(x, w):
    c1 = np.concatenate(([0.0], np.cumsum(x))); c2 = np.concatenate(([0.0], np.cumsum(x*x)))
    n=len(x); out=np.full(n,np.nan); i=np.arange(w,n)
    s=c1[i]-c1[i-w]; ss=c2[i]-c2[i-w]
    out[i]=np.sqrt(np.maximum(ss/w-(s/w)**2,0)); return out

def valuta(nome, val, anni):
    if len(val) < 40:
        print(f"{nome:58s} n={len(val):4d} (campione insufficiente)"); return None
    v = np.asarray(val,float)-COSTO
    pa = defaultdict(float)
    for x,a in zip(v,anni): pa[a]+=x
    pos = sum(1 for a in pa if pa[a]>0)
    gw=v[v>0].sum(); gl=-v[v<0].sum()
    tot=v.sum()
    domin = max(pa.values())/tot if tot>0 else 9.9
    t = v.mean()/(v.std()/np.sqrt(len(v)))
    ok = (len(v)>=150) and (t>=2.0) and (pos>=7) and (domin<=0.5)
    print(f"{nome:58s} n={len(v):4d} netto={v.mean():+7.4f}$ t={t:+5.2f} PF={gw/gl if gl>0 else 9.99:5.3f} "
          f"anni+={pos}/{len(pa)} tot={tot:+8.0f}$ annomax={domin*100:5.1f}% {'  <== PASSA' if ok else ''}")
    return dict(n=len(v), m=float(v.mean()), t=float(t), pos=pos, anni=len(pa), tot=float(tot),
                domin=float(domin), per_anno={a: round(pa[a],1) for a in sorted(pa)}, ok=ok)

# barre orarie sull'ora esatta
idxB = {(int(TB[i])): i for i in range(len(TB))}
oraB = np.where(MB==0)[0]

RIS={}
print("="*136)
print(f"SCALA GIORNALIERA — un evento al giorno, ora di taglio fissa (UTC). Costo A/R dichiarato {COSTO:.2f}$.")
print("  ora server BCM = UTC+1 (inverno) / UTC+2 (estate) -> l'ora qui e' UTC PURO e va convertita PRIMA di scriverla in un .set")
print("="*136)
for N in (6, 12, 24):            # ore di finestra segnale sul bond
    KB_ = N*12                   # barre M5
    r = np.full(len(CB), np.nan); r[KB_:] = CB[KB_:]/CB[:-KB_]-1.0
    z = r/roll_std(np.nan_to_num(r), 500)
    okc = np.full(len(CB), False); okc[KB_:] = (TB[KB_:]-TB[:-KB_]) <= KB_*300*2.5
    z[~okc]=np.nan
    for ora in (7, 12, 13, 14, 20):     # ora UTC del taglio
        for Mh in (12, 24):             # ore di permanenza sull'oro
            HH = Mh*12
            for zmin in (1.5, 2.0, 2.5):
                val, anni = [], []
                for i in oraB:
                    if HB[i]!=ora or np.isnan(z[i]) or abs(z[i])<zmin: continue
                    if WB[i]>=5: continue
                    io_ = pos_oro.get(TB[i])
                    if io_ is None or io_+HH>=len(CO): continue
                    if TO[io_+HH]-TO[io_] > HH*300*2.5: continue
                    val.append(np.sign(z[i])*(CO[io_+HH]-CO[io_])); anni.append(int(YO[io_]))
                r2 = valuta(f"  bond {N:2d}h  taglio {ora:02d}:00 UTC  oro {Mh:2d}h  |z|>={zmin}", val, anni)
                if r2: RIS[(N,ora,Mh,zmin)]=r2

print("\n"+"="*136)
print("I MIGLIORI per t-stat netto (n>=150):")
for k,v in sorted([x for x in RIS.items() if x[1]['n']>=150], key=lambda x:-x[1]['t'])[:10]:
    print(f"  bond {k[0]}h · taglio {k[1]:02d}:00 UTC · oro {k[2]}h · z>={k[3]}  ->  "
          f"n={v['n']} netto={v['m']:+.4f}$ t={v['t']:+.2f} anni+={v['pos']}/{v['anni']} annomax={v['domin']*100:.0f}%")
    print(f"      {v['per_anno']}")
