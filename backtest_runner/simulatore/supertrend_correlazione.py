# Criteri: report/SUPERTREND_CORRELAZIONE_CRITERI_2026-11-21.md
import sys,glob; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_test.py',encoding='utf-8').read()
exec(src[:src.index("CLS={")])
dd=[]
for f in sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')):
    d=pd.read_csv(f,sep=';',header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']; d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))].drop(columns='tv'); dd.append(d)
d1=pd.concat(dd); d1['t']=pd.to_datetime(d1.t,format='%Y.%m.%d %H:%M'); d1=d1.drop_duplicates('t').set_index('t').sort_index()
H1=rs(d1,'1h'); th=H1.index.values; ch=H1.c.values.astype(float); r=np.r_[0,ch[1:]/ch[:-1]-1]
def st_expo(rule):
    d=rs(d1,rule); o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); tre,up,dn=supertrend(o,h,l,c); fl=np.nonzero(tre[1:]!=tre[:-1])[0]+1
    ex=np.zeros(len(H1)); idx=d.index.values
    for k,i in enumerate(fl):
        if tre[i]!=1 or k+1>=len(fl): continue
        j=fl[k+1]
        if j+1>=n: continue
        a=np.searchsorted(th,idx[i+1]); b=np.searchsorted(th,idx[j+1]); ex[a:b]=1
    return ex
def donch_expo(N=55):
    d=rs(d1,'1D'); o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); idx=d.index
    pc=np.r_[c[0],c[:-1]]; tr=np.maximum(h-l,np.maximum(abs(h-pc),abs(l-pc))); atr=pd.Series(tr).ewm(alpha=1/14,adjust=False,min_periods=14).mean().values
    hh=pd.Series(h).rolling(N).max().shift(1).values; ex=np.zeros(len(H1)); t=max(N,15)
    while t<n-2:
        if not(c[t]>hh[t] and atr[t]>0): t+=1; continue
        e=o[t+1]; A=atr[t]; stop=e-3*A; ext=h[t+1]; j=t+1
        while j<n:
            ext=max(ext,h[j]); stop=max(stop,ext-3*A)
            if l[j]<=stop or o[j]<=stop: break
            j+=1
        j=min(j,n-1); a=np.searchsorted(th,idx[t+1].to_datetime64()); b=np.searchsorted(th,(idx[j]+pd.Timedelta(days=1)).to_datetime64()); ex[a:b]=1; t=j
    return ex
E={'A_ST_H1':st_expo('1h'),'B_ST_H4':st_expo('4h'),'C_DON55_D1':donch_expo(),'D_ORO_FERMO':np.ones(len(H1))}
day=pd.Series(pd.DatetimeIndex(th).normalize())
S=pd.DataFrame({k:pd.Series(v*r).groupby(day.values).sum() for k,v in E.items()}); X=pd.DataFrame({k:pd.Series(v).groupby(day.values).mean() for k,v in E.items()})
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
P('giorni',len(S),S.index[0].date(),S.index[-1].date()); P('esposizione media (quota di ore in posizione):',{k:round(float(v),2) for k,v in X.mean().items()})
for lab,sub in (('periodo intero',S),('dal 2015',S[S.index>='2015-01-01']),('dal 2020',S[S.index>='2020-01-01'])):
    m=sub.groupby(sub.index.to_period('M')).sum()
    P(f'\n--- {lab}: correlazione giornaliera (sopra) e mensile (sotto)'); P(sub.corr().round(2).to_string()); P(m.corr().round(2).to_string())
P('\nrendimento totale % (somma, senza costi):',S.sum().round(0).to_dict())
b=(X.B_ST_H4>0)&(X.C_DON55_D1>0); P('giorni con C in posizione: B in posizione nel %.0f%% dei casi (esposizione media di B in quei giorni %.2f)'%(100*(X.B_ST_H4[X.C_DON55_D1>0]>0).mean(),X.B_ST_H4[X.C_DON55_D1>0].mean()))
P('giorni con B in posizione: C in posizione nel %.0f%% dei casi'%(100*(X.C_DON55_D1[X.B_ST_H4>0]>0).mean()))
open('/home/user/GITHUB/report/SUPERTREND_CORRELAZIONE_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
