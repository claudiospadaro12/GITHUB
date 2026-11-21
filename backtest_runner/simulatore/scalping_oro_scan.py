# Criteri: report/SCALPING_ORO_SCANSIONE_CRITERI_2026-11-21.md
import glob,sys
import numpy as np, pandas as pd
HO=pd.Timestamp('2025-06-01'); COST=0.00011; out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
dd=[]
for f in sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')):
    d=pd.read_csv(f,sep=';',header=0,usecols=[0,1,2,3,4,5,6]); d.columns=['t','o','h','l','c','tv','sp']; d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))]; dd.append(d)
d1=pd.concat(dd); d1['t']=pd.to_datetime(d1.t,format='%Y.%m.%d %H:%M'); d1=d1.drop_duplicates('t').set_index('t').sort_index()
T1=d1.index.values; O=d1.o.values.astype(float); H=d1.h.values.astype(float); L=d1.l.values.astype(float); C=d1.c.values.astype(float); SP=d1.sp.values.astype(float); N=len(O)
M5=d1.resample('5min').agg({'o':'first','h':'max','l':'min','c':'last','tv':'sum','sp':'mean'}).dropna(); t5=M5.index.values
i0=np.searchsorted(T1,t5)   # indice M1 di inizio di ogni barra M5
o5,h5,l5,c5=[M5[x].values.astype(float) for x in 'ohlc']; tv5=M5.tv.values; sp5=M5.sp.values; n5=len(o5)
pc=np.r_[c5[0],c5[:-1]]; tr=np.maximum(h5-l5,np.maximum(abs(h5-pc),abs(l5-pc))); atr=pd.Series(tr).ewm(alpha=1/14,adjust=False).mean().values
sma=pd.Series(c5).rolling(20).mean().values; sd=pd.Series(c5).rolling(20).std(ddof=0).values; z=(c5-sma)/np.where(sd>0,sd,np.nan)
volok=tv5>=pd.Series(tv5).rolling(60).median().values; spok=sp5<=pd.Series(sp5).rolling(60).median().values
hr=pd.DatetimeIndex(t5).hour.values; mn=pd.DatetimeIndex(t5).minute.values; wd=pd.DatetimeIndex(t5).dayofweek.values
inwin=(hr>=10)&((hr<21)|((hr==21)&(mn<=55)))&(wd<5)
def simulate(a,dire,stop,target,maxm1,endidx):
    # a: indice M1 di ingresso (apertura); ritorna (uscita, indice uscita)
    e=O[a]; b=min(a+maxm1,endidx,N-1); hh=H[a:b+1]; ll=L[a:b+1]
    if dire==1: ih=np.nonzero(ll<=stop)[0]; it=np.nonzero(hh>=target)[0] if target is not None else np.array([],int)
    else: ih=np.nonzero(hh>=stop)[0]; it=np.nonzero(ll<=target)[0] if target is not None else np.array([],int)
    s=ih[0] if len(ih) else 10**9; t=it[0] if len(it) else 10**9
    if s<=t and s<10**9: return stop,a+s
    if t<10**9: return target,a+t
    return C[b],b
def ends(j):  # fine sessione: ultimo M1 prima delle 22:00 dello stesso giorno della barra j
    day=t5[j].astype('datetime64[D]'); return int(np.searchsorted(T1,(day+np.timedelta64(22,'h')).astype('datetime64[ns]')))-1
def run(sig,stopf,targf,maxbars,costmult=1.0):
    rows=[]; free=0
    for j,dire in sig:
        if j+1>=n5 or i0[j+1]<free or not inwin[j+1]: continue
        a=i0[j+1]; e=O[a]; A=atr[j]; stop,target=stopf(e,A,dire,j),targf(e,A,dire,j); x,bx=simulate(a,dire,stop,target,maxbars*5,ends(j+1))
        ret=dire*(x/e-1)-COST*costmult; rows.append((pd.Timestamp(t5[j+1]),dire,ret/(abs(e-stop)/e),ret)); free=bx+1
    return pd.DataFrame(rows,columns=['t','side','R','ret'])
ok=~np.isnan(z)&~np.isnan(atr)
s1=[(j,1 if z[j]<=-2.5 else -1) for j in range(20,n5-1) if ok[j] and abs(z[j])>=2.5]
rng=(h5-l5); pa=np.r_[np.nan,atr[:-1]]
s2=[]
for j in range(20,n5-1):
    if np.isnan(pa[j]) or rng[j]<2.5*pa[j]: continue
    pos=(c5[j]-l5[j])/rng[j] if rng[j]>0 else .5
    if pos>=0.75: s2.append((j,1))
    elif pos<=0.25: s2.append((j,-1))
f1s=lambda e,A,d,j:e-d*2*A; f1t=lambda e,A,d,j:sma[j]
f2s=lambda e,A,d,j:e-d*1*pa[j]; f2t=lambda e,A,d,j:e+d*1.5*pa[j]
cells={'F1':run(s1,f1s,f1t,12),'F2':run(s2,f2s,f2t,6),
 'F1+vol':run([x for x in s1 if volok[x[0]]],f1s,f1t,12),'F1+spread':run([x for x in s1 if spok[x[0]]],f1s,f1t,12),
 'F2+vol':run([x for x in s2 if volok[x[0]]],f2s,f2t,6),'F2+spread':run([x for x in s2 if spok[x[0]]],f2s,f2t,6)}
# F3 notizie
nw=pd.read_csv('/tmp/claude-0/news/69284184_abtg_news_hist.csv',sep=';',encoding='utf-8-sig'); nw.columns=['t','imp','cur','tit']
nw=nw[(nw.cur=='USD')&(nw.imp=='High')].copy(); nw['t']=pd.to_datetime(nw.t,format='%Y.%m.%d %H:%M')
utc=nw.t.dt.tz_localize('Etc/GMT-1').dt.tz_convert('UTC'); nw['ft']=utc.dt.tz_convert('Europe/Helsinki').dt.tz_localize(None); ev=np.sort(nw.ft.unique())
# verifica allineamento: ampiezza media M1 per offset attorno all'evento
idxe=np.searchsorted(T1,ev); rg=(H-L)/C; offs=range(-6,11); prof={o:np.nanmean([rg[i+o] for i in idxe if 0<=i+o<N and T1[i+o]==ev[k]+np.timedelta64(o,'m')]) for o in offs for k in [0]} if False else {}
vals={o:[] for o in offs}
for k,i in enumerate(idxe):
    for o in offs:
        if 0<=i+o<N and T1[i+o]==ev[k]+np.timedelta64(o,'m'): vals[o].append(rg[i+o])
P('ALLINEAMENTO calendario/oro: ampiezza media M1 (x10^4) per minuto dall\'evento, eventi USD High, n eventi con dati: %d'%len(vals[0]))
P('  '+' '.join(f'{o:+d}:{np.mean(v)*1e4:.2f}' for o,v in vals.items() if v))
pk=max(vals,key=lambda o:np.mean(vals[o]) if vals[o] else 0); P('  picco al minuto',pk)
def run_news(follow):
    rows=[]; free=0
    for k,e0 in enumerate(ev):
        i=np.searchsorted(T1,e0)
        if i+6>=N or T1[i]!=e0: continue
        j=np.searchsorted(t5,e0)-1
        if j<20 or np.isnan(atr[j]): continue
        a=i+5
        if T1[a]!=e0+np.timedelta64(5,'m') or a<free: continue
        h=pd.Timestamp(T1[a]); 
        if not(10<=h.hour<21 and h.dayofweek<5): continue
        react=C[i+4]-O[i]; A=atr[j]
        if abs(react)<0.5*A: continue
        dire=int(np.sign(react))*(1 if follow else -1); e=O[a]; stop=e-dire*A; target=e+dire*A
        x,bx=simulate(a,dire,stop,target,30,ends(np.searchsorted(t5,T1[a])))
        ret=dire*(x/e-1)-COST*3; rows.append((pd.Timestamp(T1[a]),dire,ret/(A/e),ret)); free=bx+1
    return pd.DataFrame(rows,columns=['t','side','R','ret'])
cells['F3a segue']=run_news(True); cells['F3b fade']=run_news(False)
def stt(x):
    n=len(x)
    if n==0: return (0,np.nan,np.nan)
    r=x.R.values; g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l if l>0 else np.inf
    return (n,pf,r.mean()/(r.std(ddof=1)/np.sqrt(n)) if n>2 and r.std(ddof=1)>0 else 0.0)
pre=t5[t5<np.datetime64(HO)]; cut=pd.Timestamp(pre[int(len(pre)*.7)]); P('\nTaglio IS/OOS:',cut.date())
P('cella            lettura IS n PF t | OOS n PF | HO n PF | anni R>=0 | esito')
passed=[]
for nm,T in cells.items():
    for lab,sel in (('long',T.side==1),('short',T.side==-1),('both',T.side!=0)):
        x=T[sel]; a=x[x.t<cut]; b=x[(x.t>=cut)&(x.t<HO)]; h=x[x.t>=HO]; sa,sb,sh=stt(a),stt(b),stt(h)
        yr=x.groupby(x.t.dt.year).R.sum(); yp=(yr>=0).mean() if len(yr) else 0
        okc=sa[0]>=100 and sa[1]>=1.3 and sa[2]>=2 and sb[0]>=50 and sb[1]>1.2 and yp>=0.6
        if lab=='both': okc=okc and stt(T[T.side==1])[1]>=0.9 and stt(T[T.side==-1])[1]>=0.9
        ho='NV' if sh[0]<20 else ('ok' if sh[1]>1.0 else 'KO')
        if okc: passed.append((nm,lab))
        P(f'{nm:11s} {lab:5s} IS {sa[0]:5d} {sa[1]:5.2f} {sa[2]:+5.1f} | OOS {sb[0]:5d} {sb[1]:5.2f} | HO {sh[0]:4d} {sh[1]:5.2f} {ho} | {yp*100:3.0f}% | {"PASSA" if okc else "-"}')
P('\ncelle-lettura che passano tutte le porte:',passed)
open('/home/user/GITHUB/report/SCALPING_ORO_SCANSIONE_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
