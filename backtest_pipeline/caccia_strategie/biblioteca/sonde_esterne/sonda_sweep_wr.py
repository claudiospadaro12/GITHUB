#!/usr/bin/env python3
# INDICAZIONE (NON verdetto): tasso TP-prima-di-SL del sweep di micro-pivot,
# contro un CONTROLLO A INGRESSI CASUALI negli stessi minuti.
# Dati esterni histdata M1 (non BCM), OHLC, ZERO costi, ambiguita' intrabarra
# risolta SEMPRE a sfavore (se TP e SL stanno nella stessa barra -> perdita).
import os,glob,importlib.util,random
S=os.environ['S']
spec=importlib.util.spec_from_file_location("sv",S+"/sonda_volexp.py")
sv=importlib.util.module_from_spec(spec); spec.loader.exec_module(sv)
spec2=importlib.util.spec_from_file_location("sw",S+"/sonda_sweep.py")

def rsi(cl,n=14):
    out=[None]*len(cl); g=l=0.0
    for i in range(1,len(cl)):
        d=cl[i]-cl[i-1]; up=max(d,0.0); dn=max(-d,0.0)
        if i<=n: g+=up; l+=dn
        if i==n: g/=n; l/=n
        if i>n: g=(g*(n-1)+up)/n; l=(l*(n-1)+dn)/n
        if i>=n: out[i]=100.0 if l==0 else 100-100/(1+g/l)
    return out

def esito(b,i,entry,av,side,slM,tpM,maxbars):
    sl=slM*av; tp=tpM*av
    for j in range(i+1,min(i+1+maxbars,len(b))):
        h,l=b[j][4],b[j][5]
        if side=='L':
            hit_sl = l <= entry-sl; hit_tp = h >= entry+tp
        else:
            hit_sl = h >= entry+sl; hit_tp = l <= entry-tp
        if hit_sl: return 0            # conservativo: SL prima
        if hit_tp: return 1
    return -1                          # ne' l'uno ne' l'altro entro il tetto

def analizza(sym,tf,slM=1.2,tpM=1.4,maxbars=200,seed=7):
    bars=sv.load_m1(glob.glob(f"{S}/dati/{sym}_*.csv"))
    b=sv.aggregate(bars,tf); a=sv.atr(b,14); cl=[x[6] for x in b]; r=rsi(cl,14)
    lastPH=lastPL=None; sig={'L':[],'S':[]}
    for i in range(7,len(b)):
        p=i-3
        if p-3>=0:
            hs=[b[j][4] for j in range(p-3,p+4)]; ls=[b[j][5] for j in range(p-3,p+4)]
            if b[p][4]==max(hs): lastPH=b[p][4]
            if b[p][5]==min(ls): lastPL=b[p][5]
        if a[i] is None or r[i] is None: continue
        c=b[i][6]
        if lastPL is not None and b[i][5]<lastPL and c>lastPL and r[i]<=45: sig['L'].append((i,c,a[i]))
        elif lastPH is not None and b[i][4]>lastPH and c<lastPH and r[i]>=55: sig['S'].append((i,c,a[i]))
    rng=random.Random(seed); out={}
    for side in ('L','S'):
        E=[esito(b,i,c,av,side,slM,tpM,maxbars) for (i,c,av) in sig[side]]
        w=sum(1 for x in E if x==1); ls_=sum(1 for x in E if x==0); nd=sum(1 for x in E if x==-1)
        # controllo casuale: stesse dimensioni, indici a caso fra i validi
        pool=[i for i in range(20,len(b)-maxbars-1) if a[i] is not None]
        idx=[rng.choice(pool) for _ in range(len(sig[side]))]
        Ec=[esito(b,i,b[i][6],a[i],side,slM,tpM,maxbars) for i in idx]
        wc=sum(1 for x in Ec if x==1); lc=sum(1 for x in Ec if x==0)
        out[side]=(len(E),w,ls_,nd, w/(w+ls_) if w+ls_ else 0, wc/(wc+lc) if wc+lc else 0)
    return out

REQ=1.075/(1.4/1.2+1)
print(f"Win rate RICHIESTO da H8 con RR 1,167: {REQ*100:.1f}%\n")
for sym in ("GRXEUR","SPXUSD"):
    for tf in (5,15):
        o=analizza(sym,tf)
        for side in ('L','S'):
            n,w,l,nd,wr,wrc=o[side]
            print(f"{sym} M{tf} {side}: n={n:5d} TP={w:5d} SL={l:5d} aperti={nd:4d} | WR meccanismo={wr*100:5.1f}%  WR controllo casuale={wrc*100:5.1f}%  delta={((wr-wrc)*100):+5.1f} pt")
