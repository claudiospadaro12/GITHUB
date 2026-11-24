#!/usr/bin/env python3
# Criteri: report/FOREX_TREND_D1_CRITERI_2026-11-23.md (+ aggiunta dati 24/11). Hold-out 2024+ NON stampato salvo --holdout.
import sys,os,numpy as np,pandas as pd
D=sys.argv[1] if len(sys.argv)>1 and not sys.argv[1].startswith('--') else '/tmp/claude-0/fxd'
HOLD='--holdout' in sys.argv
PAIRS=['EURUSD','GBPUSD','USDJPY','AUDUSD','USDCAD','USDCHF','NZDUSD','EURJPY','GBPJPY','EURGBP']
CF=0.0002; SWAP=0.015
START=pd.Timestamp('2000-01-01')
def load(s):
    d=pd.read_csv(os.path.join(D,'ABTG_D1_%s.csv'%s),sep=';',parse_dates=['date'],date_format='%Y.%m.%d').set_index('date')
    d=d[d.index>=START]; d=d[d.index<pd.Timestamp('2026-11-24')]       # ultimo giorno incompleto escluso
    d=d[(d.high>d.low)]                                               # barre piatte scartate
    return d
def atr(H,L,C,n=14):
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum(H-L,np.maximum(abs(H-pc),abs(L-pc)))
    return pd.Series(tr).rolling(n).mean().values
def run_donch(d,N):
    O,H,L,C=d.open.values,d.high.values,d.low.values,d.close.values; n=len(C); a=atr(H,L,C)
    hh=pd.Series(H).rolling(N).max().shift(1).values; ll=pd.Series(L).rolling(N).min().shift(1).values
    pos=np.zeros(n); pnl=np.zeros(n); trades=[]; p=0; ext=0; cur=0.0; ent_i=-1
    idx=d.index
    for t in range(max(N,20),n-2):
        # decisione a close t, esecuzione open t+1; rendimento da open t+1 a open t+2
        newp=p
        if p==0:
            if C[t]>hh[t]: newp=1; ext=C[t]
            elif C[t]<ll[t]: newp=-1; ext=C[t]
        else:
            if p==1:
                ext=max(ext,C[t]); 
                if C[t]<ext-3*a[t]: newp=0
            else:
                ext=min(ext,C[t]);
                if C[t]>ext+3*a[t]: newp=0
        cost=0.0
        if newp!=p: cost=CF*(1 if (p==0 or newp==0) else 2)
        if newp!=0:
            r=newp*(O[t+2]/O[t+1]-1); days=(idx[t+2]-idx[t+1]).days; g=r-SWAP*days/365-cost
        else: g=-cost
        pnl[t+1]=g
        if p==0 and newp!=0: cur=g
        elif p!=0 and newp!=0: cur+=g
        elif p!=0 and newp==0: trades.append((idx[t],cur+g)); cur=0.0
        p=newp
    return pnl,trades
def run_tsmom(d,L):
    O,C=d.open.values,d.close.values; n=len(C); idx=d.index
    pnl=np.zeros(n); trades=[]; p=0; cur=0.0
    for t in range(L,n-2):
        newp=p
        if (t%5)==0: newp=int(np.sign(C[t]/C[t-L]-1))
        cost=0.0
        if newp!=p: cost=CF*(1 if (p==0 or newp==0) else 2)
        if newp!=0:
            r=newp*(O[t+2]/O[t+1]-1); days=(idx[t+2]-idx[t+1]).days; g=r-SWAP*days/365-cost
        else: g=-cost
        pnl[t+1]=g
        if newp!=p:
            if p!=0: trades.append((idx[t],cur+(-cost if False else 0))); 
            cur=g
        else:
            cur+=g
        p=newp
    return pnl,trades
def stats(tr,lo,hi):
    r=np.array([x for d,x in tr if lo<=d.year<=hi])
    if len(r)==0: return 0,float('nan')
    gp=r[r>0].sum(); gl=-r[r<0].sum(); return len(r),(gp/gl if gl>0 else float('inf'))
oro=pd.read_csv('/tmp/claude-0/d1/D1_Oro.csv',sep=';',parse_dates=['date']).set_index('date').close.pct_change()
dow=pd.read_csv('/tmp/claude-0/d1/D1_Dow30.csv',sep=';',parse_dates=['date']).set_index('date').close.pct_change()
data={s:load(s) for s in PAIRS}
for s in PAIRS: print(s,'barre',len(data[s]),'da',data[s].index[0].date(),'a',data[s].index[-1].date(),file=sys.stderr)
cells=[('M1 Donchian',20),('M1 Donchian',55),('M2 TSMOM',60),('M2 TSMOM',120),('M2 TSMOM',250)]
res={}
for m,k in cells:
    allt=[]; ser=[]
    for s in PAIRS:
        d=data[s]; pnl,tr=(run_donch(d,k) if m.startswith('M1') else run_tsmom(d,k)); allt+=tr; ser.append(pd.Series(pnl,index=d.index))
    port=pd.concat(ser,axis=1).fillna(0).mean(axis=1)
    res[(m,k)]=(allt,port)
print('cella            | IS n  PF  anni+ ann%  | OOS n  PF | note')
fin=[]
for (m,k),(tr,port) in res.items():
    n1,p1=stats(tr,2000,2015); n2,p2=stats(tr,2016,2023)
    yr=port[(port.index.year>=2000)&(port.index.year<=2015)].groupby(lambda x:x.year).sum(); ypos=(yr>0).mean()
    ann=port[(port.index.year>=2000)&(port.index.year<=2015)].mean()*252*100
    g1=n1>=150 and p1>=1.25 and ypos>=0.6; g2=n2>=60 and p2>=1.15
    same=[v for kk,v in res.items() if kk[0]==m and kk[1]!=k]
    g3=all(stats(v[0],2000,2015)[1]>1.0 for v in same)
    print('%-14s %3d | %4d %.2f %.2f %+.2f | %4d %.2f | G1 %s G2 %s G3 %s'%(m,k,n1,p1,ypos,ann,n2,p2,'ok' if g1 else '-','ok' if g2 else '-','ok' if g3 else '-'))
    if g1 and g2 and g3:
        c1=port.reindex(oro.index).corr(oro) if False else port.corr(oro.reindex(port.index)); c2=port.corr(dow.reindex(port.index))
        print('   corr oro %.2f dow %.2f'%(c1,c2)); fin.append((m,k,c1,c2,tr))
print('finalisti G1-G3:',len(fin))
if HOLD:
    for m,k,c1,c2,tr in fin[:3]: print('HOLD-OUT',m,k,stats(tr,2024,2026))
