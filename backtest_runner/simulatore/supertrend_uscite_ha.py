# Criteri: report/SUPERTREND_USCITE_HA_CRITERI_2026-11-21.md
import sys,glob; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_test.py',encoding='utf-8').read()
exec(src[:src.index("CLS={")])
COSTP=0.35; SW=5.6; NSIM=2000; HO=pd.Timestamp('2025-06-01')
dd=[]
for f in sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')):
    d=pd.read_csv(f,sep=';',header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']; d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))]; dd.append(d)
d1=pd.concat(dd); d1['t']=pd.to_datetime(d1.t,format='%Y.%m.%d %H:%M'); d1=d1.drop_duplicates('t').set_index('t').sort_index()
def rsv(rule): return d1.resample(rule).agg({'o':'first','h':'max','l':'min','c':'last','tv':'sum'}).dropna()
def prep(d):
    o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; tv=d.tv.values.astype(float); n=len(c)
    tre,up,dn=supertrend(o,h,l,c); pc=np.r_[np.nan,c[:-1]]; tr=np.maximum(h-l,np.maximum(np.abs(h-pc),np.abs(l-pc))); tr[0]=h[0]-l[0]
    atr=pd.Series(tr).ewm(alpha=1/10,adjust=False).mean().values
    hac=(o+h+l+c)/4; hao=np.empty(n); hao[0]=(o[0]+c[0])/2
    for i in range(1,n): hao[i]=(hao[i-1]+hac[i-1])/2
    red=hac<hao; slope=np.full(n,np.nan); slope[6:]=(up[6:]-up[:-6])/atr[6:]
    vsma=pd.Series(tv).rolling(20).mean().values; vlow=tv<vsma
    return o,c,tre,up,red,slope,vlow
def trades(d,var):
    o,c,tre,up,red,slope,vlow=prep(d); n=len(c); idx=d.index; fl=np.nonzero(tre[1:]!=tre[:-1])[0]+1; rows=[]
    for i in fl:
        if tre[i]!=1 or i+2>=n: continue
        e=o[i+1]; risk=(e-up[i])/e
        if risk<=0: continue
        jx=None; streak=0
        for k in range(i+1,n-1):
            streak=streak+1 if red[k] else 0
            if tre[k]==-1: jx=k; break
            if var=='X0': continue
            steep=(not np.isnan(slope[k])) and slope[k]>=0.5
            if var=='X1': ex=red[k]
            elif not steep: ex=red[k]
            elif var=='X2': ex=streak>=3
            elif var=='X3': ex=red[k] and vlow[k]
            else: ex=(streak>=3) or (red[k] and vlow[k])
            if ex: jx=k; break
        if jx is None: continue
        a,b=i+1,jx+1; x=o[b]; nights=(idx[b].normalize()-idx[a].normalize()).days
        ret=x/e-1-COSTP/e-SW/100/365*nights; rows.append((idx[a],i,a,b,ret,ret/risk))
    return pd.DataFrame(rows,columns=['t','i','a','b','ret','R'])
def sim_p(d,T,lo,hi,rng):
    o=d.o.values.astype(float); idx=d.index.values.astype('datetime64[D]'); dur=(T.b-T.a).values; real=T.ret.sum(); tot=np.zeros(NSIM)
    for dr in dur:
        hi2=max(hi-dr-1,lo+1); s=rng.integers(lo,hi2,size=NSIM); ee=o[s]; xx=o[np.minimum(s+dr,len(o)-1)]; nights=(idx[np.minimum(s+dr,len(o)-1)]-idx[s]).astype(int)
        tot+=xx/ee-1-COSTP/ee-SW/100/365*nights
    return float((tot>=real).mean())
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
rng=np.random.default_rng(12345); allr=[]
for tf,rule in (('H1','1h'),('H4','4h'),('D1','1D')):
    d=rsv(rule); idx=d.index; pre=int(np.searchsorted(idx.values,np.datetime64(HO))); cutb=int(pre*.7); cut=idx[cutb]
    base=trades(d,'X0').set_index('i')
    for var in ('X0','X1','X2','X3','X4'):
        T=trades(d,var); parts={'IS':T[T.t<cut],'OOS':T[(T.t>=cut)&(T.t<HO)],'HO':T[T.t>=HO]}; S={k:stt(x) for k,x in parts.items()}
        ps=S['IS'][0]>=30 and S['IS'][1]>=1.3 and S['IS'][2]>=2 and S['OOS'][0]>=15 and S['OOS'][1]>1.2
        ho='NV' if S['HO'][0]<8 else ('ok' if S['HO'][1]>1.0 else 'KO')
        dur=(T.b-T.a).mean(); p=sim_p(d,T,0,len(d),rng)
        pair={}
        if var!='X0':
            B=T.set_index('i').join(base[['ret']].rename(columns={'ret':'rb'}),how='inner'); B['dif']=B.ret-B.rb
            for k,msk in (('IS',B.t<cut),('OOS',(B.t>=cut)&(B.t<HO))):
                x=B[msk].dif.values; pair[k]=(x.mean()*100 if len(x) else np.nan, x.mean()/(x.std(ddof=1)/np.sqrt(len(x))) if len(x)>2 and x.std(ddof=1)>0 else 0)
        pr=f"coppie vs X0: IS dif {pair['IS'][0]:+.2f}% t{pair['IS'][1]:+.1f} | OOS dif {pair['OOS'][0]:+.2f}% t{pair['OOS'][1]:+.1f}" if pair else 'riferimento'
        better=bool(pair) and pair['IS'][1]>=2 and pair['OOS'][0]>0 and ps and p<=0.05 and ho!='KO'
        allr.append((tf,var,ps,better))
        P(f"{tf} {var} IS n{S['IS'][0]:4d} PF {S['IS'][1]:.2f} t{S['IS'][2]:+.1f} | OOS n{S['OOS'][0]:4d} PF {S['OOS'][1]:.2f} t{S['OOS'][2]:+.1f} | HO n{S['HO'][0]:3d} PF {S['HO'][1]:.2f} {ho} | durata media {dur:.1f} barre ret {T.ret.mean()*100:+.2f}% p{p:.3f} | {pr} | porte {'SI' if ps else 'no'} {'USCITA MIGLIORE' if better else ''}")
P('\nceli che passano le porte:',[(a,b) for a,b,c,_ in allr if c]); P('uscite migliori (porte + coppie + p<=0.05):',[(a,b) for a,b,c,bt in allr if bt])
open('/home/user/GITHUB/report/SUPERTREND_USCITE_HA_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
