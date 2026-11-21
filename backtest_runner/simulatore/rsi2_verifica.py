# Criteri: report/RSI2_VERIFICA_CRITERI_2026-11-21.md
import glob,numpy as np,pandas as pd
RT=0.0003; SW=0.0004
def pf(x):
    x=np.asarray(x,float); g=x[x>0].sum(); l=-x[x<0].sum(); return g/l if l>0 else np.inf
def tst(x):
    x=np.asarray(x,float); return x.mean()/(x.std(ddof=1)/np.sqrt(len(x))) if len(x)>2 and x.std(ddof=1)>0 else 0.0
def trades(d):
    o,c=d.o.values,d.c.values; n=len(d); idx=d.index
    dl=np.diff(c,prepend=c[0]); up=pd.Series(np.maximum(dl,0)).ewm(alpha=.5,adjust=False).mean().values; dn=pd.Series(np.maximum(-dl,0)).ewm(alpha=.5,adjust=False).mean().values
    rsi=np.where(dn==0,100.0,100-100/(1+up/np.where(dn==0,1,dn))); s200=pd.Series(c).rolling(200).mean().values; s5=pd.Series(c).rolling(5).mean().values
    out=[]; t=200
    while t<n-2:
        if not(rsi[t]<10 and c[t]>s200[t]): t+=1; continue
        e=o[t+1]
        for j in range(t+1,min(t+11,n)):
            if c[j]>s5[j] or j==t+10: break
        nights=(idx[j]-idx[t+1]).days; out.append((idx[t+1],c[j]/e-1-RT-SW*nights)); t=j
    return pd.DataFrame(out,columns=['t','r'])
def m1_rth(pats):
    dd=[]
    for p in pats:
        for f in sorted(glob.glob(p)):
            d=pd.read_csv(f,usecols=[0,1,2,3,4]); d.columns=['t','o','h','l','c']; dd.append(d)
    d=pd.concat(dd); d['t']=pd.to_datetime(d.t,format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('t').set_index('t').sort_index()
    m=d.index.hour*60+d.index.minute; d=d[(m>=570)&(m<960)]
    g=d.groupby(d.index.normalize()); r=pd.DataFrame({'o':g.o.first(),'h':g.h.max(),'l':g.l.min(),'c':g.c.last(),'n':g.o.size()})
    return r[r.n>=300].drop(columns='n')
def yahoo(m):
    d=pd.read_csv(f'/tmp/claude-0/d1/D1_{m}.csv',sep=';'); d.columns=['t','o','h','l','c','v']; d['t']=pd.to_datetime(d.t); d=d.dropna().set_index('t').sort_index(); d=d[d.c>0]
    ok=(d.h>d.l).astype(float).rolling(60).mean(); f=ok.index[ok>0.95]; d=d[d.index>=f[0]]
    # barre con apertura = chiusura precedente: l'apertura e' finta -> ingresso non valido (rimosse dalla serie come per la scoperta)
    fake=np.r_[False,np.abs(d.o.values[1:]/d.c.values[:-1]-1)<1e-6]
    return d,fake
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
P('=== P1: M1 reali RTH 09:30-16:00 NY, 2016-01..2026-07-31')
for nm,pats in (('NASUSD',['/tmp/claude-0/nas/NASUSD_M1_*.csv','/tmp/claude-0/ext2526/NASUSD_M1_*.csv']),('SPXUSD',['/tmp/claude-0/spx/SPXUSD_M1_*.csv','/tmp/claude-0/ext2526/SPXUSD_M1_*.csv'])):
    d=m1_rth(pats); T=trades(d); T=T[T.t>='2016-01-01']
    P(f'{nm}: giorni RTH {len(d)} {d.index[0].date()}..{d.index[-1].date()} | operazioni {len(T)} PF {pf(T.r):.2f} media {T.r.mean()*100:+.2f}% t {tst(T.r):+.1f} win {(T.r>0).mean()*100:.0f}%')
    for lab,a,b in (('2016-2019','2016-01-01','2020-01-01'),('2020-2024','2020-01-01','2025-01-01'),('2025-01..2026-07','2025-01-01','2027-01-01')):
        x=T[(T.t>=a)&(T.t<b)]; P(f'   {lab}: n {len(x)} PF {pf(x.r):.2f} media {x.r.mean()*100:+.2f}%' if len(x) else f'   {lab}: n 0')
    y=T.groupby(T.t.dt.year).r.agg(['count','mean']); P('   per anno (n, media%):',{int(k):(int(v['count']),round(v['mean']*100,2)) for k,v in y.iterrows()})
P('\n=== diagnostica: stessi indici su D1 Yahoo, stessa regola, 2016-01..2026-07 (barre con apertura finta escluse dalle entrate)')
for m,lab in (('Nasdaq100','Nasdaq100'),('SP500','SP500')):
    d,fake=yahoo(m); T=trades(d[~fake]); T=T[T.t>='2016-01-01']
    P(f'{lab}: operazioni {len(T)} PF {pf(T.r):.2f} media {T.r.mean()*100:+.2f}% t {tst(T.r):+.1f}')
P('\n=== P2: quattro indici USA (Yahoo), tutto lo storico utile')
allt=[]
for m in ('Dow30','Nasdaq100','SP500','Russell2000'):
    d,fake=yahoo(m); d2=d[~fake]; T=trades(d2); T['m']=m; allt.append(T); P(f'{m:12s} n {len(T)} PF {pf(T.r):.2f} media {T.r.mean()*100:+.2f}% t {tst(T.r):+.1f}')
A=pd.concat(allt).sort_values('t').reset_index(drop=True)
P('insieme: n',len(A),'PF %.2f'%pf(A.r),'media %+.2f%%'%(A.r.mean()*100),'t %+.1f'%tst(A.r))
ep=[]; cur=None
for t,r in zip(A.t,A.r):
    if cur is None or (t-cur[0]).days>5: cur=[t,[r]]; ep.append(cur)
    else: cur[1].append(r)
E=pd.DataFrame([(a,np.mean(b)) for a,b in ep],columns=['t','r']); P('episodi',len(E),'media %+.2f%%'%(E.r.mean()*100),'t episodi %+.1f'%tst(E.r),'PF %.2f'%pf(E.r))
y=A.groupby(A.t.dt.year).r.agg(['count','mean']); yy=y[y['count']>=3]; P('anni con >=3 operazioni:',len(yy),'| anni con media >= 0:',int((yy['mean']>=0).sum()),'(%.0f%%)'%(100*(yy['mean']>=0).mean()))
P('ultimi anni:',{int(k):(int(v['count']),round(v['mean']*100,2)) for k,v in y.tail(4).iterrows()})
open('/home/user/GITHUB/report/RSI2_VERIFICA_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
