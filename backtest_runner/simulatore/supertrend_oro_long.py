# Criteri: report/SUPERTREND_ORO_LONG_CRITERI_2026-11-21.md
import sys,glob; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_test.py',encoding='utf-8').read()
exec(src[:src.index("CLS={")])
COSTP=0.35; SW=5.6; NSIM=2000
dd=[]
for f in sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')):
    d=pd.read_csv(f,sep=';',header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']; d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))].drop(columns='tv'); dd.append(d)
d1=pd.concat(dd); d1['t']=pd.to_datetime(d1.t,format='%Y.%m.%d %H:%M'); d1=d1.drop_duplicates('t').set_index('t').sort_index()
dday=rs(d1,'1D'); sma=dday.c.rolling(200).mean(); cond=(dday.c>sma).shift(1)   # condizione nota a inizio giorno (chiusura di ieri)
condmap=cond.to_dict()
def longtrades(d,mode,filt):
    o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); idx=d.index
    tre,up,dn=supertrend(o,h,l,c); fl=np.nonzero(tre[1:]!=tre[:-1])[0]+1
    rows=[]
    for k,i in enumerate(fl):
        if tre[i]!=1 or k+1>=len(fl): continue
        j=fl[k+1]
        if j+1>=n: continue
        if filt and not condmap.get(idx[i].normalize(),False): continue
        if mode=='open': a,b=i+1,j+1; e,x=o[a],o[b]
        else: a,b=i,j; e,x=c[a],c[b]
        risk=(e-up[i])/e
        if risk<=0: continue
        nights=(idx[b].normalize()-idx[a].normalize()).days
        ret=x/e-1-COSTP/e-SW/100/365*nights
        rows.append((idx[a],a,b,ret,ret/risk))
    return pd.DataFrame(rows,columns=['t','a','b','ret','R'])
def sim_p(d,T,mode,lo,hi,rng):
    # lo,hi: indici barra del periodo; ingressi casuali con le stesse durate (b-a) nel periodo
    o=d.o.values.astype(float); c=d.c.values.astype(float); idx=d.index.values.astype('datetime64[D]')
    arr=o if mode=='open' else c
    dur=(T.b-T.a).values; n=len(dur)
    if n==0: return np.nan
    real=T.ret.sum(); tot=np.zeros(NSIM)
    for dr in dur:
        hi2=hi-dr-1
        if hi2<=lo: hi2=lo+1
        s=rng.integers(lo,hi2,size=NSIM); ee=arr[s]; xx=arr[s+dr]; nights=(idx[s+dr]-idx[s]).astype(int)
        tot+=xx/ee-1-COSTP/ee-SW/100/365*nights
    return float((tot>=real).mean())
res=[]; out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
HO=pd.Timestamp('2025-06-01'); rng=np.random.default_rng(12345)
for tf,rule in (('H1','1h'),('H4','4h'),('D1','1D')):
    d=rs(d1,rule); idx=d.index; pre=int(np.searchsorted(idx.values,np.datetime64(HO))); cutb=int(pre*.7); cut=idx[cutb]; nb=len(idx)
    for var,mode,filt in (('BASE','open',False),('CHIUSURA','close',False),('SMA200','open',True)):
        T=longtrades(d,mode,filt)
        parts={'IS':(T[T.t<cut],0,cutb),'OOS':(T[(T.t>=cut)&(T.t<HO)],cutb,pre),'HO':(T[T.t>=HO],pre,nb),'TUTTO':(T,0,nb)}
        row={}
        for k,(x,lo,hi) in parts.items():
            s=stt(x); p=sim_p(d,x,mode,lo,hi,rng) if k in('TUTTO','OOS','IS','HO') and len(x)>0 else np.nan
            row[k]=(s,p,x.ret.mean()*100 if len(x) else np.nan)
        ps=row['IS'][0][0]>=30 and row['IS'][0][1]>=1.3 and row['IS'][0][2]>=2 and row['OOS'][0][0]>=15 and row['OOS'][0][1]>1.2
        hos=row['HO'][0]; ho='NV' if hos[0]<8 else ('ok' if hos[1]>1.0 else 'KO')
        conf= ps and row['TUTTO'][1]<=0.05 and ho!='KO'
        res.append((tf,var,ps,row['TUTTO'][1],conf))
        P(f'{tf} {var:8s} IS n{row["IS"][0][0]:4d} PF {row["IS"][0][1]:.2f} t{row["IS"][0][2]:+.1f} p{row["IS"][1]:.3f} | OOS n{row["OOS"][0][0]:4d} PF {row["OOS"][0][1]:.2f} t{row["OOS"][0][2]:+.1f} p{row["OOS"][1]:.3f} | HO n{row["HO"][0][0]:3d} PF {row["HO"][0][1]:.2f} p{row["HO"][1]:.3f} {ho} | TUTTO n{row["TUTTO"][0][0]:4d} PF {row["TUTTO"][0][1]:.2f} t{row["TUTTO"][0][2]:+.1f} ret/trade {row["TUTTO"][2]:+.2f}% p{row["TUTTO"][1]:.3f} | porte {"SI" if ps else "no"} {"SPUNTO" if conf else ""}')
P('\ncelle che passano le porte:',[(a,b) for a,b,c,_,_ in res if c]); P('spunti confermati (porte + p<=0.05):',[(a,b) for a,b,c,p,cf in res if cf])
open('/home/user/GITHUB/report/SUPERTREND_ORO_LONG_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
