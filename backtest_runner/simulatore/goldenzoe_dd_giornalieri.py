import sys,os,datetime as dt
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
D0=sys.argv[1] if len(sys.argv)>1 else '2022-11-22'
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index
e55=np.where(entries_breakout(C,H,L,55)==1,1,0)
def P(x): return dt.datetime.strptime(x,'%Y.%m.%d %H:%M')
# trade GoldenZoe base (55,3,3), solo long: record completi
rec=[]; pos=0
for i in range(120,len(C)-1):
    if pos==0:
        if e55[i]!=1 or np.isnan(atr[i]): continue
        ent=O[i+1]; risk=3*atr[i]
        if risk<=0: continue
        pos=1; stop=ent-risk; ext=ent; start=i+1; stop0=stop
    if pos==1 and i>=start:
        if L[i]<=stop:
            px=min(O[i],stop); rec.append((start,i,ent,risk,px)); pos=0; continue
        ext=max(ext,H[i]); stop=max(stop,ext-3*atr[i])
t0=pd.Timestamp(D0); m=d.loc[d.index>=t0]
mi=m.index.values; lo=m['low'].values; cl=m['close'].values; op=m['open'].values
res={}
for RISK in (0.45,0.9,1.0,1.5):
    B0=80000.0; B=B0; eq=np.full(len(m),np.nan); last=0
    for (s,i,ent,risk,px) in rec:
        ts=idx4[s]; te=idx4[i]
        if te<t0: continue
        # equity a saldo fino all'ingresso
        a=np.searchsorted(mi,np.datetime64(ts)); 
        bexit=np.searchsorted(mi,np.datetime64(te)) # inizio barra di uscita
        if a>=len(m): break
        eq[last:a]=B
        oz=B*RISK/100.0/risk
        # uscita: primo minuto della barra di uscita con low<=stop; px da gap -> apertura
        end=min(bexit+240,len(m)); k=bexit
        stp=px
        while k<end and lo[k]>stp+1e-9 and not (op[k]<=stp): k+=1
        k=min(k,len(m)-1)
        days=(mi[a:k+1]-mi[a]).astype('timedelta64[s]').astype(float)/86400.0
        fl=oz*(lo[a:k+1]-ent)-oz*0.35-oz*ent*0.055/360.0*days
        # all'ultimo minuto il P&L e quello realizzato a px
        fl[-1]=oz*(px-ent)-oz*0.35-oz*ent*0.055/360.0*days[-1]
        eq[a:k+1]=B+fl
        B=B+fl[-1]; last=k+1
    eq[last:]=B
    # forward fill eventuali nan
    s_=pd.Series(eq,index=m.index).ffill().bfill()
    day=s_.index.normalize()
    first=s_.groupby(day).transform('first'); 
    bal_day=s_.groupby(day).transform('first')  # equity a inizio giornata
    ref=np.maximum(bal_day.values,bal_day.values)
    dd_day=(ref-s_.groupby(day).transform('min').values)/B0*100
    dd=pd.Series(dd_day,index=s_.index).groupby(day).max()
    stat=(B0-s_)/B0*100; peak=s_.cummax(); pt=(peak-s_)/B0*100
    def episodi(x,th):
        a=(x>=th).values; n=0; inside=False
        for v in a:
            if v and not inside: n+=1; inside=True
            elif not v and x.iloc[0]==x.iloc[0] and inside and False: pass
        return n
    # episodi distinti: soglia superata e poi rientro sotto meta soglia
    def ep(x,th):
        n=0; arm=True
        for v in x.values:
            if arm and v>=th: n+=1; arm=False
            if v<th/2: arm=True
        return n
    res[RISK]=dict(ndays=int(dd.shape[0]),maxdaily=dd.max(),days1=int((dd>=1).sum()),days2=int((dd>=2).sum()),days3=int((dd>=3).sum()),days4=int((dd>=4).sum()),days5=int((dd>=5).sum()),days10=int((dd>=10).sum()),
        maxstat=stat.max(),maxpt=pt.max(),ep5s=ep(stat,5),ep10s=ep(stat,10),ep5p=ep(pt,5),ep10p=ep(pt,10),fin=(s_.iloc[-1]/B0-1)*100,ntr=sum(1 for x in rec if idx4[x[1]]>=t0),worstday=dd.idxmax())
    if RISK==1.0: dd.to_csv('/home/user/GITHUB/report/GOLDENZOE_DD_GIORNALIERI_dati_1pct.csv',sep=';',header=['dd_giornaliero_pct'])
print('finestra dal',D0,'a',m.index[-1])
for k,v in res.items(): print(k,{a:(round(b,2) if isinstance(b,float) else b) for a,b in v.items()})
