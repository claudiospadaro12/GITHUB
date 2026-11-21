# Criteri: report/DONCHIAN_D1_FASE1_CRITERI_2026-11-21.md
import numpy as np, pandas as pd
MK={'Oro':('metalli',0.02,5.6),'Argento':('metalli',0.081,5.6),'Bitcoin':('cripto',0.02,10),'Ethereum':('cripto',0.03,10),
 'Petrolio_Brent':('energia',0.074,5),'Petrolio_WTI':('energia',0.089,5),'Nikkei225':('indici',0.02,5.5),'Nasdaq100':('indici',0.02,7.5),
 'SP500':('indici',0.02,7.5),'DAX':('indici',0.02,7.5),'FTSE100':('indici',0.0213,7.5),'EuroStoxx50':('indici',0.0209,7.5),'CAC40':('indici',0.02,7.5),
 'Russell2000':('indici',0.0339,7.5),'HangSeng':('indici',0.0295,7.5),'Dow30':('indici',0.02,7.5),'ASX200':('indici',0.02,7.5)}
HO=pd.Timestamp('2025-06-01')
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
def load(m):
    d=pd.read_csv(f'/tmp/claude-0/d1/D1_{m}.csv',sep=';'); d.columns=['t','o','h','l','c','v']; d['t']=pd.to_datetime(d.t)
    d=d.dropna(subset=['o','h','l','c']).sort_values('t').set_index('t'); d=d[d.c>0]
    ok=(d.h>d.l).astype(float).rolling(60).mean(); f=ok.index[ok>0.95]; return d[d.index>=f[0]] if len(f) else d.iloc[0:0]
def run(d,N,cost,swap,swapmult=1.0):
    o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); idx=d.index
    pc=np.r_[c[0],c[:-1]]; tr=np.maximum(h-l,np.maximum(abs(h-pc),abs(l-pc))); atr=pd.Series(tr).ewm(alpha=1/14,adjust=False,min_periods=14).mean().values
    hh=pd.Series(h).rolling(N).max().shift(1).values; tr_=[]; t=max(N,15)
    while t<n-2:
        if not(c[t]>hh[t] and atr[t]>0): t+=1; continue
        e=o[t+1]; A=atr[t]; stop=e-3*A; ext=h[t+1]; j=t+1; xp=None
        while j<n:
            ext=max(ext,h[j]); stop=max(stop,ext-3*A)
            if l[j]<=stop or (j==t+1 and o[j]<=stop): xp=min(o[j],stop) if o[j]<stop else stop; break
            j+=1
        if xp is None: xp=c[n-1]; j=n-1
        nights=(idx[j]-idx[t+1]).days; ret=xp/e-1-cost/100-swapmult*swap/100/365*nights
        tr_.append((idx[t+1],ret/(3*A/e))); t=j
    return pd.DataFrame(tr_,columns=['t','R'])
def stt(x):
    n=len(x)
    if n==0: return (0,np.nan,np.nan)
    r=x.R.values; g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l if l>0 else np.inf
    t=r.mean()/(r.std(ddof=1)/np.sqrt(n)) if n>2 and r.std(ddof=1)>0 else 0.0
    return (n,pf,t)
def split(T,d):
    pre=d.index[d.index<HO]; cut=pre[int(len(pre)*.7)]
    return T[T.t<cut],T[(T.t>=cut)&(T.t<HO)],T[T.t>=HO],cut
P('mercato classe N | dati | IS n/PF/t | OOS n/PF | HO n/PF | esito')
rows=[]
for m,(cl,cost,sw) in MK.items():
    d=load(m)
    for N in (20,55):
        T=run(d,N,cost,sw); a,b,hld,cut=split(T,d); sa,sb,sh=stt(a),stt(b),stt(hld)
        ps=sa[0]>=30 and sa[1]>=1.3 and sa[2]>=2 and sb[0]>=15 and sb[1]>1.2
        ho='NV' if sh[0]<8 else ('ok' if sh[1]>1.0 else 'KO')
        sw2=None
        if ps:
            T2=run(d,N,cost,sw,2.0); a2,b2,_,_=split(T2,d); s2a,s2b=stt(a2),stt(b2)
            sw2=(s2a[0]>=30 and s2a[1]>=1.3 and s2a[2]>=2 and s2b[0]>=15 and s2b[1]>1.2)
        rows.append((m,cl,N,ps,ho,sw2))
        P(f'{m:15s}{cl:8s}N{N:2d} | {d.index[0].date()} ({len(d)}) | IS {sa[0]:3d} {sa[1]:5.2f} {sa[2]:+4.1f} | OOS {sb[0]:3d} {sb[1]:5.2f} | HO {sh[0]:2d} {sh[1]:5.2f} {ho} | {"PASSA" if ps else "-"}'+(f' swapx2 {"si" if sw2 else "no"}' if ps else ''))
P('\n=== riepilogo')
pas=[r for r in rows if r[3]]; P('celle che passano IS+OOS:',len(pas),'su',len(rows))
for cl in ('metalli','cripto','energia','indici'):
    for N in (20,55):
        ms=[r[0] for r in pas if r[1]==cl and r[2]==N]; 
        if ms: P(f'  classe {cl} N{N}: {len(ms)} {ms}')
open('/home/user/GITHUB/report/DONCHIAN_D1_FASE1_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
