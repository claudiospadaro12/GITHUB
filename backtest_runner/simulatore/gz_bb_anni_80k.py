#!/usr/bin/env python3
# Simulazione per anno su conto 80.000: GoldenZoe (3 profili) e Breaking Band/Bulge di Massimo (replica nostra + numeri di Massimo).
# Ogni anno riparte da 80.000 (nessuna capitalizzazione fra anni); GoldenZoe: costi FTMO, oro M1, operazioni chiuse nell'anno.
import sys, io, glob, numpy as np, pandas as pd
src=open('/home/user/GITHUB/backtest_runner/simulatore/goldenzoe_challenge.py').read().split('def nextsig')[0]
_o=sys.stdout; sys.stdout=io.StringIO(); exec(src); sys.stdout=_o
B0=80000.0
tr=[trades[k] for k in sorted(trades)]
def anno(y,risk):
    B=B0; mn=B0; n=0; last_exit=None
    for t in tr:
        if t['texit'].year!=y: continue
        if last_exit is not None and t['tentry']<last_exit: continue   # una posizione alla volta
        oz=B*risk/100.0/t['risk']
        for (u,fmin,fend) in t['rows']: mn=min(mn,B+oz*fmin)
        B+=oz*t['freal']; n+=1; last_exit=t['texit']
    return B-B0,n,(B0-mn)/B0*100
print('GOLDENZOE oro H4 long, conto 80.000, ogni anno riparte da 80.000 (utile in EUR/USD equivalenti, costi FTMO)')
print('anno | ops | PROP 0,5%: utile (DD) | MEDIO 0,9%: utile (DD) | ALTO 1,3%: utile (DD)')
tot={0.5:0,0.9:0,1.3:0}
for y in range(2015,2027):
    r=[anno(y,x) for x in (0.5,0.9,1.3)]
    for x,v in zip((0.5,0.9,1.3),r): tot[x]+=v[0]
    print('%d | %d | %+8.0f (%.1f%%) | %+8.0f (%.1f%%) | %+8.0f (%.1f%%)'%(y,r[0][1],r[0][0],r[0][2],r[1][0],r[1][2],r[2][0],r[2][2]))
print('somma anni (NON capitalizzata): %+.0f | %+.0f | %+.0f'%(tot[0.5],tot[0.9],tot[1.3]))
print()
print('BREAKING BAND / BULGE (replica nostra su dati BCM, rischio base 0,5% su EURUSD, EURCHF, EURCAD H1; rendimento per operazione scalato lineare al rischio)')
S={}
for s in ('EURUSD','EURCHF','EURCAD'):
    d=pd.read_csv('/tmp/claude-0/bbv4/serie/BV_%s_H1_W2013_2024.csv'%s,sep=';')
    d['y']=pd.to_datetime(d['data'],format='%Y.%m.%d').dt.year; S[s]=d
print('anno | ops | utile a 0,5% | a 2,0% | a 2,5% (somma dei 3 mercati, 80.000)')
tt=[0,0,0]; N=0
for y in range(2013,2025):
    r=sum(d.loc[d.y==y,'rendimento'].sum() for d in S.values()); n=sum((d.y==y).sum() for d in S.values())
    v=[r*80000*(k/0.5) for k in (0.5,2.0,2.5)]; tt=[a+b for a,b in zip(tt,v)]; N+=n
    print('%d | %d | %+7.0f | %+7.0f | %+7.0f'%(y,n,*v))
print('somma 2013-2024: ops %d | %+.0f | %+.0f | %+.0f'%(N,*tt))
print()
print('Numeri dichiarati da Massimo (PDF 19/11, MetaQuotes-Demo, 3 robusti, 2020-2026, 7 anni, su 100.000) scalati a 80.000 (x0,8):')
for k,p in ((0.5,2400),(2.0,11984),(2.5,14951)):
    print('rischio %.1f%%: %+.0f in 7 anni = %+.0f all anno'%(k,p*0.8,p*0.8/7))
