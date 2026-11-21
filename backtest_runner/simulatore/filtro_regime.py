# Criteri: report/FILTRO_REGIME_CRITERI_2026-11-21.md
import sys; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np, pandas as pd
import sr_breakout as S
MK={'trend':['Oro','Argento','Bitcoin','Ethereum','Nikkei225'],'controllo':['Nasdaq100','DAX','Petrolio_WTI']}
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
def pfR(r):
    r=np.asarray(r,float); g=r[r>0].sum(); l=-r[r<0].sum(); return g/l if l>0 else np.inf
def mdd(r):
    c=np.cumsum(r); return float((np.maximum.accumulate(np.r_[0,c])[1:]-c).max()) if len(r) else 0.0
def load(m):
    d=pd.read_csv(f'/tmp/claude-0/d1/D1_{m}.csv',sep=';').dropna(); d=d[d.close>0]
    return [d[x].values.astype(float) for x in ('open','high','low','close')]
def states(c):
    n=len(c); mom=np.full(n,np.nan); mom[250:]=c[250:]/c[:-250]-1; st=np.zeros(n,bool); on=False
    for i in range(n):
        if np.isnan(mom[i]): st[i]=False; continue
        if abs(mom[i])>=0.20: on=True
        elif abs(mom[i])<0.15: on=False
        st[i]=on
    r=np.r_[np.nan,np.diff(np.log(c))]; v=pd.Series(r).rolling(20).std(); med=v.rolling(250).median().shift(1)
    calm=~(v>1.5*med).fillna(True).values
    f1=np.r_[False,st[:-1]]; f2=np.r_[False,calm[:-1]]
    return {'base':np.ones(n,bool),'F1':f1,'F2':f2,'F3':f1&f2}
res={}
for grp,ms in MK.items():
    for m in ms:
        o,h,l,c=load(m); n=len(c); cut=int(n*.7); cc=0.0005*np.nanmean(c); stt=states(c)
        row={}
        for v,al in stt.items():
            al=al.copy(); al[:260]=False
            tr=S.sim(o,h,l,c,cc,1.5,'E2',allow=al)
            a=np.array([r for t,d,r,_ in tr if t<cut]); b=np.array([r for t,d,r,_ in tr if t>=cut]); row[v]=(a,b)
        res[m]=row
        P(f'\n{m} ({grp}) barre {n}')
        for v,(a,b) in row.items():
            P(f'  {v:4s} IS n {len(a):3d} PF {pfR(a):5.2f} R {a.sum() if len(a) else 0:+7.1f} DD {mdd(a):5.1f} | OOS n {len(b):3d} PF {pfR(b):5.2f} R {b.sum() if len(b) else 0:+7.1f} DD {mdd(b):5.1f}')
P('\n=== regola di esito: UTILE se in IS e OOS: n>=20, PF>=base, DD<=0.8*DD base, R totale>=0.7*R base')
for v in ('F1','F2','F3'):
    ok=[];okc=[]
    for grp,ms in MK.items():
        for m in ms:
            good=True
            for k in (0,1):
                x=res[m][v][k]; b=res[m]['base'][k]
                if not(len(x)>=20 and pfR(x)>=pfR(b) and mdd(x)<=0.8*mdd(b) and x.sum()>=0.7*b.sum()): good=False
            if good: (ok if grp=='trend' else okc).append(m)
    P(f'{v}: mercati trend UTILI {len(ok)}/5 {ok} | controllo {okc}')
open('/home/user/GITHUB/report/FILTRO_REGIME_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
