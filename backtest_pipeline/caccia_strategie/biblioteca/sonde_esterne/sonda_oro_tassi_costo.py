#!/usr/bin/env python3
# =====================================================================
# SONDA ORO <- TASSI, terzo passo: il DISEGNO C contro il COSTO.
# Disegno C (l'unico che ha passato la falsificazione al passo 2):
#   il BOND si muove forte (|z|>=ZB) MENTRE l'oro e' ancora fermo
#   (|z_oro|<ZO). Si entra sull'oro nel verso del bond.
# Qui si chiede una cosa sola: ESISTE una configurazione in cui la
# media per evento e' almeno DUE VOLTE il costo A/R dichiarato (0,25 $)?
# Criteri congelati: n>=150, t>=2 al NETTO del costo, anni positivi >=7/9.
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
TO, CO, YO, HO = arr(M["XAU_USD"])
TB, CB, YB, HB = arr(M["USB10Y_USD"])
HI = np.array([M["XAU_USD"][k][1] for k in sorted(M["XAU_USD"])])
LO = np.array([M["XAU_USD"][k][2] for k in sorted(M["XAU_USD"])])
pos_oro = {t: i for i, t in enumerate(TO)}

def roll_std(x, w):
    c1 = np.concatenate(([0.0], np.cumsum(x))); c2 = np.concatenate(([0.0], np.cumsum(x*x)))
    n = len(x); out = np.full(n, np.nan); i = np.arange(w, n)
    s = c1[i]-c1[i-w]; ss = c2[i]-c2[i-w]
    out[i] = np.sqrt(np.maximum(ss/w-(s/w)**2, 0)); return out

def z_of(C, T, K, w=500):
    r = np.full(len(C), np.nan); r[K:] = C[K:]/C[:-K]-1.0
    z = r/roll_std(np.nan_to_num(r), w)
    ok = np.full(len(C), False); ok[K:] = (T[K:]-T[:-K]) <= K*300*3
    z[~ok] = np.nan; return z

COSTO = 0.25   # $ andata+ritorno DICHIARATO (spread BCM oro NON misurato in repo)

def prova(K, H, ZB_, ZO_soglia):
    zb = Z[K]; zo = ZOG[K]
    sel = np.where(np.abs(zb) >= ZB_)[0]
    val, anni = [], []; ultimo = -1e18
    for ib in sel:
        t = TB[ib]; io_ = pos_oro.get(t)
        if io_ is None or io_+H >= len(CO): continue
        if np.isnan(zo[io_]) or abs(zo[io_]) >= ZO_soglia: continue
        if TO[io_+H]-TO[io_] > H*300*3: continue
        if t < ultimo + H*300: continue
        val.append(np.sign(zb[ib])*(CO[io_+H]-CO[io_])); anni.append(int(YO[io_])); ultimo = t
    if len(val) < 60: return None
    v = np.asarray(val, float)
    vn = v - COSTO
    pa = defaultdict(float)
    for x, a in zip(vn, anni): pa[a] += x
    pos = sum(1 for a in pa if pa[a] > 0)
    gw = vn[vn > 0].sum(); gl = -vn[vn < 0].sum()
    return dict(n=len(v), lordo=v.mean(), netto=vn.mean(),
                t=vn.mean()/(vn.std()/np.sqrt(len(vn))),
                pf=gw/gl if gl > 0 else float('inf'), pos=pos, anni=len(pa),
                tot=vn.sum(), per_anno={a: round(pa[a],1) for a in sorted(pa)})

Z = {K: z_of(CB, TB, K) for K in (3,6,12,24)}
ZOG = {K: z_of(CO, TO, K) for K in (3,6,12,24)}

print("="*128)
print(f"DISEGNO C — bond forte + oro fermo.  Costo A/R DICHIARATO = {COSTO:.2f}$ (spread BCM oro [NON MISURATO])")
print("  K=finestra segnale bond (min) · H=orizzonte oro (min) · zb=soglia bond · zo=tetto 'oro fermo'")
print("="*128)
print(f"{'K':>4} {'H':>5} {'zb':>5} {'zo':>4} | {'n':>5} {'lordo$':>8} {'NETTO$':>8} {'t':>6} {'PF':>6} {'anni+':>6} {'tot$':>9}")
best = []
for K in (3,6,12,24):
    for H in (12,24,36,48):
        for zb in (2.5,3.0,3.5,4.0):
            for zo in (0.75,1.0,1.5):
                r = prova(K,H,zb,zo)
                if not r: continue
                flag = ""
                if r['n']>=150 and r['t']>=2.0 and r['pos']>=7 and r['netto']>=2*0: flag=" <=="
                print(f"{K*5:>4} {H*5:>5} {zb:>5.1f} {zo:>4.2f} | {r['n']:>5} {r['lordo']:>8.4f} {r['netto']:>8.4f} "
                      f"{r['t']:>6.2f} {r['pf']:>6.3f} {r['pos']:>3}/{r['anni']:<2} {r['tot']:>9.0f}{flag}")
                best.append(((K,H,zb,zo), r))
print("\n" + "="*128)
print("I MIGLIORI per t-stat NETTO (n>=150):")
for k,r in sorted([b for b in best if b[1]['n']>=150], key=lambda x:-x[1]['t'])[:8]:
    print(f"  K={k[0]*5}' H={k[1]*5}' zb={k[2]} zo={k[3]} -> n={r['n']} netto={r['netto']:+.4f}$ t={r['t']:+.2f} "
          f"PF={r['pf']:.3f} anni+={r['pos']}/{r['anni']}")
    print(f"      per anno: {r['per_anno']}")
