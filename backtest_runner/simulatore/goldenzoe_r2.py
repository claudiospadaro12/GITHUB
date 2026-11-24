#!/usr/bin/env python3
# r2 della curva di GoldenZoe (linearita): oro FTMO M1, costi FTMO, conto 80.000, un trade alla volta.
import sys, io, numpy as np, pandas as pd
src=open('/home/user/GITHUB/backtest_runner/simulatore/goldenzoe_challenge.py').read().split('def nextsig')[0]
_o=sys.stdout; sys.stdout=io.StringIO(); exec(src); sys.stdout=_o
B0=80000.0
def sequenza():
    seq=[]; p=0
    while p<len(sig_arr):
        t=trades[sig_arr[p]]; seq.append(t); q=np.searchsorted(sig_arr,t['j']); p=q
    return seq
SEQ=sequenza()
def r2(x,y):
    x=np.asarray(x,float); y=np.asarray(y,float)
    if len(x)<3 or np.std(y)==0: return float('nan')
    return float(np.corrcoef(x,y)[0,1]**2)
def curva(seq,risk):
    B=B0; bal=[B0]; fix=[0.0]; tt=[seq[0]['tentry']]
    for t in seq:
        oz=B*risk/100.0/t['risk']; B+=oz*t['freal']; bal.append(B); tt.append(t['texit'])
        fix.append(fix[-1]+(B0*risk/100.0/t['risk'])*t['freal'])        # non composto: rischio fisso sul capitale iniziale
    return np.array(bal),np.array(fix),tt
print('GOLDENZOE: r2 della curva (1,000 = retta perfetta). Conto 80.000, costi FTMO, un trade alla volta.')
print('finestra | rischio | trade | rend. finale | r2 saldo composto vs n.trade | r2 ln(saldo) vs tempo | r2 P&L non composto vs n.trade')
for lab,w0 in (('dal 2015',pd.Timestamp('2014-12-01')),('ultimi 4 anni',pd.Timestamp('2022-11-22'))):
    seq=[t for t in SEQ if t['tentry']>=w0]
    for risk in (0.5,0.9,1.3):
        bal,fix,tt=curva(seq,risk)
        days=np.array([(x-tt[0]).days for x in tt],float)
        print('%-13s | %.1f%% | %3d | %+7.1f%% | %.3f | %.3f | %.3f'%(lab,risk,len(seq),(bal[-1]/B0-1)*100,r2(range(len(bal)),bal),r2(days,np.log(bal)),r2(range(len(fix)),fix)))
print()
print('Per anno (non composto, ogni anno riparte da 80.000): r2 del P&L cumulato vs n.trade, rischio 0,9%')
for y in range(2015,2027):
    seq=[t for t in SEQ if t['texit'].year==y]
    if len(seq)<5: continue
    _,fix,_=curva(seq,0.9); print(' ',y,len(seq),'trade  r2 %.3f'%r2(range(len(fix)),fix))
