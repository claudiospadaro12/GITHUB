import sys,glob,re
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index
e55=np.where(entries_breakout(C,H,L,55)==1,1,0); rec=[]; pos=0
for i in range(120,len(C)-1):
    if pos==0:
        if e55[i]!=1 or np.isnan(atr[i]): continue
        ent=O[i+1]; risk=3*atr[i]
        if risk<=0: continue
        pos=1; stop=ent-risk; ext=ent; start=i+1
    if pos==1 and i>=start:
        if L[i]<=stop:
            px=min(O[i],stop); rec.append((idx4[i],(px-ent)/risk)); pos=0; continue
        ext=max(ext,H[i]); stop=max(stop,ext-3*atr[i])
gz=pd.Series(dict(rec)); gz.index=pd.to_datetime(gz.index)
print('GoldenZoe ricostruito (R per operazione)',len(gz),gz.index.min().date(),gz.index.max().date())
rx=re.compile(r'<td>(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)</td><td>\d+</td><td>[A-Z]+</td><td>(?:buy|sell)</td><td>out</td><td>[\d.]+</td><td>[\d.]+</td><td>\d+</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td>')
num=lambda x: float(x.replace(' ','').replace('\xa0',''))
def deals(h):
    t=open(h,'rb').read().decode('utf-16'); out={}
    for m in rx.finditer(t):
        ts=pd.Timestamp(m.group(1).replace('.','-',2)); out[ts]=out.get(ts,0)+sum(num(x) for x in m.groups()[1:])
    return pd.Series(out).sort_index()
B='/tmp/r4/'
S={}
for k in (4,):
    for tag in 'AB': S[(k,tag)]=deals(glob.glob(B+'UBSR4_RO%02d%s_*/*/report/*.htm'%(k,tag))[0])

def eqdd(h):
    t=open(h,'rb').read().decode('utf-16'); z=re.sub(r'<[^>]+>','|',t); z=re.sub(r'[\s|]*\|[\s|]*','|',z)
    m=re.search(r'Equità Drawdown Massima:\|([\d ]+\.?\d*) \(([\d.]+)%\)',z); return num(m.group(1)),float(m.group(2))
W={'A':(pd.Timestamp('2004-09-01'),pd.Timestamp('2012-12-31')),'B':(pd.Timestamp('2025-01-01'),pd.Timestamp('2026-10-31'))}
ACC=80000.0
def daily(s,t0,t1):
    s=s[(s.index>=t0)&(s.index<=t1)]; idx=pd.date_range(t0,t1,freq='D'); return s.groupby(s.index.normalize()).sum().reindex(idx).fillna(0)
def stats(d):
    c=d.cumsum(); dd=(c.cummax().clip(lower=0)-c); w=d.rolling(7).sum()
    return dict(netto=c.iloc[-1],ddmax=dd.max(),giorno=d.min(),sett=w.min())
print('=== n.4 a 0,1 lotti, deposito 100.000 (profitti in EUR)')
base={}
for tag in 'AB':
    h=glob.glob(B+'UBSR4_RO04%s_*/*/report/*.htm'%tag)[0]; e,p=eqdd(h); t0,t1=W[tag]; d=daily(S[(4,tag)],t0,t1); st=stats(d); base[tag]=(d,e,st)
    print(tag,'equity DD max report %.0f EUR (%.2f%%) | chiuso: netto %.0f, DD max %.0f, giorno peggiore %.0f, 7 giorni peggiori %.0f'%(e,p,st['netto'],st['ddmax'],st['giorno'],st['sett']))
ddlot={t:base[t][1]/0.1 for t in 'AB'}   # EUR di equity DD per lotto
print('equity DD per lotto: A %.0f EUR/lotto, B %.0f EUR/lotto'%(ddlot['A'],ddlot['B']))
print('\n=== lotti per un DD equity di 2/4/6% di 80.000 (per periodo)')
for pct in (2,4,6): print(pct,'%%: A %.1f lotti, B %.1f lotti'%(ACC*pct/100/ddlot['A'],ACC*pct/100/ddlot['B']))
print('\n=== portafoglio con GoldenZoe (R per operazione x rischio% x 80.000, chiusure; senza costi), n.4 scalato a x lotti')
for tag in 'AB':
    t0,t1=W[tag]; g=daily(gz*1.0,t0,t1)
    print('\nperiodo',tag,t0.date(),t1.date(),'| GoldenZoe: %d operazioni'%int(((gz.index>=t0)&(gz.index<=t1)).sum()))
    d4,e,_=base[tag]
    for r in (0.5,0.9):
        gp=g*r/100*ACC
        for pct in (2,4):
            lots=ACC*pct/100/ddlot[tag]; n4=d4*(lots/0.1)
            sg,s4,sb=stats(gp),stats(n4),stats(gp+n4)
            print('GZ %.1f%% + n.4 a %.1f lotti (DD eq. %d%%): DD chiuso GZ %.1f%% n4 %.1f%% insieme %.1f%% (somma %.1f%%) | giorno peggiore insieme %.2f%% | 7gg %.2f%%'%(r,lots,pct,100*sg['ddmax']/ACC,100*s4['ddmax']/ACC,100*sb['ddmax']/ACC,100*(sg['ddmax']+s4['ddmax'])/ACC,100*sb['giorno']/ACC,100*sb['sett']/ACC))
