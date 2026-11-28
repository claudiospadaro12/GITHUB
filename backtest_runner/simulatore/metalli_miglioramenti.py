import sys,warnings,itertools;warnings.filterwarnings('ignore')
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np,pandas as pd,glob
import goldenzoe_metalli_d1 as g
def trades2(d,N,mi,mt,cost,fin,ts=False,sma=False):
    O,H,L,C,A=[d[k].values for k in ('open','high','low','close','atr')]; hh=pd.Series(d.high).rolling(N).max().shift(1).values; s200=pd.Series(d.close).rolling(200).mean().values; idx=d.index; n=len(d); out=[]; t=max(N,200)+1
    while t<n-1:
        ok=(C[t]>hh[t]) and not np.isnan(A[t]) and (not sma or C[t]>s200[t])
        if not ok: t+=1; continue
        ent=O[t+1]; risk=mi*A[t]; stop=ent-risk; ext=ent; j=t+1; ex=None
        while j<n:
            if L[j]<=stop: ex=min(O[j],stop); break
            if ts and (j-(t+1))>=30 and C[j]<ent+risk: ex=C[j]; break
            ext=max(ext,H[j]); stop=max(stop,ext-mt*A[j]); j+=1
        if ex is None: ex=C[n-1]; j=n-1
        days=(idx[j]-idx[t+1]).days; out.append((idx[t+1],idx[j],(ex-ent)/risk-(cost*ent+fin*ent*days/365)/risk)); t=j+1
    return pd.DataFrame(out,columns=['t','tc','R'])
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
def per(df): 
    i=df[df.t.dt.year<=2014].R; o=df[df.t.dt.year>=2015].R; return pf(i),pf(o)
if __name__=='__main__':
    VAR={'base':dict(mi=3,mt=3),'I1 trailing 4':dict(mi=3,mt=4),'I2 tempo 30':dict(mi=3,mt=3,ts=True),'I3 SMA200':dict(mi=3,mt=3,sma=True),'I4 stop 2':dict(mi=2,mt=3)}
    res={}
    print('=== A) PF netto IS / OOS (n)  [ritenzione vs base]')
    for name in ('Oro','Argento','Rame','Platino','Palladio'):
        d=g.load(name); base=trades2(d,20,3,3,g.MK[name],0.055)
        for v,kw in VAR.items():
            df=trades2(d,20,kw.get('mi'),kw.get('mt'),g.MK[name],0.055,kw.get('ts',False),kw.get('sma',False)); i,o=per(df); res[(name,v)]=(i,o,len(df),len(df)/len(base))
        print('%-8s '%name+' | '.join('%s %.2f/%.2f (%d,%.0f%%)'%(v,*res[(name,v)][:3],100*res[(name,v)][3]) for v in VAR))
    print('=== verdetto per intervento')
    for v in list(VAR)[1:]:
        imp=0; ok3=True; det=[]
        for name in ('Oro','Argento','Rame'):
            bi,bo=res[(name,'base')][:2]; i,o=res[(name,v)][:2]; di,do=i-bi,o-bo; det.append('%s %+.2f/%+.2f'%(name,di,do))
            if di>=0.05 and do>=0.05: imp+=1
            elif di<-0.05 or do<-0.05: ok3=False if (imp>=2) else ok3
        ret=min(res[(n,v)][3] for n in ('Oro','Argento','Rame'))
        # terzo non peggiora oltre 0,05: ricalcolo esplicito
        worst=min(min(res[(n,v)][0]-res[(n,'base')][0],res[(n,v)][1]-res[(n,'base')][1]) for n in ('Oro','Argento','Rame'))
        comune=imp>=2 and worst>=-0.05 and ret>=0.75
        print('%-14s migliorano %d/3 | peggiore delta %+.2f | ritenzione min %.0f%% | %s | %s'%(v,imp,worst,100*ret,'COMUNE' if comune else 'no',' ; '.join(det)))
    # === B) portafoglio
    gz=pd.read_csv('/tmp/work/gz_trades.csv',parse_dates=['ts_open','ts_close']); gzs=pd.DataFrame({'tc':gz.ts_close,'R':gz.R_gross-gz.cost_R})
    ser={'GoldenZoe':gzs}
    for name in ('Argento','Rame'):
        d=g.load(name); ser[name]=trades2(d,20,3,3,g.MK[name],0.055)[['tc','R']]
    fr=[pd.read_csv(f,sep=';') for f in sorted(glob.glob('/tmp/claude-0/btc/ABTG_M1_BTCUSD_20*.csv'))]; b=pd.concat(fr); b['time']=pd.to_datetime(b['time'],format='%Y.%m.%d %H:%M'); b=b.drop_duplicates('time').set_index('time').sort_index()
    D=b.resample('1D').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna(); pc=D.close.shift(1); tr=pd.concat([D.high-D.low,(D.high-pc).abs(),(D.low-pc).abs()],axis=1).max(axis=1); D['atr']=tr.rolling(14).mean()
    D=D[D.index>='2015-01-01']; ser['Bitcoin']=trades2(D,20,3,3,0.0005,0.10)[['tc','R']]
    start=max(v.tc.min() for v in ser.values()); start=pd.Timestamp('2016-01-01') if start<pd.Timestamp('2016-01-01') else start
    print('=== B) PORTAFOGLIO dal',start.date(),'| operazioni per serie:',{k:int((v.tc>=start).sum()) for k,v in ser.items()})
    for rp in (0.5,0.25):
        m={k:(v[v.tc>=start].set_index('tc').R*rp/100).groupby(pd.Grouper(freq='ME')).sum() for k,v in ser.items()}
        M=pd.DataFrame(m).fillna(0)
        if rp==0.5: print('correlazione mensile:\n',M.corr().round(2).to_string())
        yrs=(M.index[-1]-M.index[0]).days/365.25
        for nome,cols in (('GoldenZoe',['GoldenZoe']),('GZ+Argento',['GoldenZoe','Argento']),('GZ+Ag+Rame',['GoldenZoe','Argento','Rame']),('GZ+Ag+Rame+BTC',['GoldenZoe','Argento','Rame','Bitcoin'])):
            r=M[cols].sum(axis=1); eq=r.cumsum(); dd=(eq.cummax().clip(lower=0)-eq).max()
            dday=pd.concat([v[v.tc>=start].set_index('tc').R*rp/100 for k,v in ser.items() if k in cols]).groupby(level=0).sum().groupby(lambda x:x.date()).sum().min()
            print('rischio %.2f%%/trade %-16s rendimento %.1f%%/anno | DD totale %.1f%% | peggior mese %.1f%% | peggior giorno chiuso %.1f%% | mesi positivi %.0f%%'%(rp,nome,100*r.sum()/yrs,100*dd,100*r.min(),100*dday,100*(r>0).mean()))
