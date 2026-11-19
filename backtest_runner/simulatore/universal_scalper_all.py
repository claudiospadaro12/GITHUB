"""Universal Scalper Pro: 4 mercati x 5 TF x 5 uscite. Criteri: report/UNIVERSAL_SCALPER_CRITERI_2026-11-19.md (estensione)"""
import glob,sys,json
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_backtest import metrics,fmt,split
SRC={'XAUUSD':(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';',0.35),'EURUSD':(['/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv'],';',0.0001),
     'NASUSD':(['/tmp/claude-0/nas/NASUSD_M1_*.csv'],',',2.0),'SPXUSD':(['/tmp/claude-0/spx/SPXUSD_M1_*.csv'],',',0.7)}
def load_m1(pats,sep):
    fr=[]
    for pat in pats:
        for f in sorted(glob.glob(pat)):
            d=pd.read_csv(f,sep=sep)
            d.columns=[c.lower() for c in d.columns]
            if sep==';':
                d=d[~(d['time'].str.endswith('00:00') & (d['tickvol']>2000))]
            fr.append(d[['time','open','high','low','close']])
    d=pd.concat(fr); d['time']=pd.to_datetime(d['time'],format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('time').set_index('time').sort_index(); return d
def resample(d,rule):
    r=d.resample(rule).agg({'open':'first','high':'max','low':'min','close':'last'}).dropna(); return r
def prep(r):
    O,H,L,C=[r[k].values for k in ('open','high','low','close')]
    c=r['close']; ef=c.ewm(span=9,adjust=False).mean().values; es=c.ewm(span=21,adjust=False).mean().values
    pc=c.shift(1); tr=pd.concat([r['high']-r['low'],(r['high']-pc).abs(),(r['low']-pc).abs()],axis=1).max(axis=1)
    atr=tr.ewm(alpha=1/14,adjust=False).mean().values
    up=r['high'].diff(); dn=-r['low'].diff()
    pdm=np.where((up>dn)&(up>0),up,0.0); mdm=np.where((dn>up)&(dn>0),dn,0.0)
    a14=tr.ewm(alpha=1/14,adjust=False).mean().values
    pdi=100*pd.Series(pdm,index=r.index).ewm(alpha=1/14,adjust=False).mean().values/a14; mdi=100*pd.Series(mdm,index=r.index).ewm(alpha=1/14,adjust=False).mean().values/a14
    dx=100*np.abs(pdi-mdi)/np.maximum(pdi+mdi,1e-12); adx=pd.Series(dx,index=r.index).ewm(alpha=1/14,adjust=False).mean().values
    n=len(C); sig=np.zeros(n,dtype=int)
    for i in range(60,n):
        if adx[i]>12:
            if ef[i]>es[i] and ef[i-1]<=es[i-1]: sig[i]=1
            elif ef[i]<es[i] and ef[i-1]>=es[i-1]: sig[i]=-1
    hac=(O+H+L+C)/4; hao=np.empty(n); hao[0]=(O[0]+C[0])/2
    for i in range(1,n): hao[i]=(hao[i-1]+hac[i-1])/2
    ha=np.where(hac>hao,1,-1)
    return O,H,L,C,atr,sig,ha,r.index.strftime('%Y.%m.%d %H:%M').values
def sim(P,cost,mode):
    O,H,L,C,atr,sig,ha,ks=P; n=len(C); tr=[]
    if mode=='A':
        busy=-1
        for i in range(60,n-2):
            d=sig[i]
            if d==0 or i<=busy: continue
            a=atr[i]; sl=C[i]-d*1.5*a; tp=C[i]+d*2.0*a; j=i+1; px=O[j]; risk=abs(px-sl)
            if risk<0.2*a: continue
            res=None
            for m in range(j,min(n,j+300)):
                if d==1:
                    if L[m]<=sl: res=sl; ex=m; break
                    if H[m]>=tp: res=tp; ex=m; break
                else:
                    if H[m]>=sl: res=sl; ex=m; break
                    if L[m]<=tp: res=tp; ex=m; break
            if res is None: ex=min(n-1,j+299); res=C[ex]
            tr.append((ks[j],d*(res-px)/risk-cost/risk)); busy=ex
        return tr
    use_sl=mode in ('B2','C2'); exit_sig=mode in ('B','B2')
    pos=0; ent=0.0; sl=0.0; risk=1.0; t0=''; pend=None
    for i in range(60,n-1):
        if pend is not None:
            kind,d,a=pend; pend=None
            if pos!=0:
                tr.append((t0,(pos*(O[i]-ent))/risk-cost/risk)); pos=0
            if kind!='close':
                pos=d; ent=O[i]; risk=1.5*a; sl=ent-d*risk if use_sl else 0.0; t0=ks[i]
        if pos!=0 and use_sl:
            if (pos==1 and L[i]<=sl) or (pos==-1 and H[i]>=sl):
                px=min(O[i],sl) if pos==1 else max(O[i],sl)
                tr.append((t0,pos*(px-ent)/risk-cost/risk)); pos=0
        if pos!=0:
            if exit_sig:
                if sig[i]==-pos: pend=('rev',sig[i],atr[i])
            else:
                if ha[i]==-pos: pend=('close',0,0)
        else:
            if sig[i]!=0: pend=('open',sig[i],atr[i])
    return tr
if __name__=='__main__':
    TFS=[('M5','5min'),('M15','15min'),('M30','30min'),('H1','1h'),('H4','4h')]; MODES=['A','B','B2','C','C2']; out={}; rows=[]
    for name,(pats,sep,cost) in SRC.items():
        d=load_m1(pats,sep); print(name,'M1',len(d),d.index[0],d.index[-1],flush=True)
        for tfn,rule in TFS:
            P=prep(resample(d,rule)); ks=P[7]; cut=ks[int(0.7*len(ks))]
            for m in MODES:
                tr=sim(P,cost,m); a,b=split(tr,cut); ma=metrics(a); mb=metrics(b)
                rows.append((name,tfn,m,ma,mb)); 
        print(name,'fatto',flush=True)
    json.dump([(r[0],r[1],r[2],r[3],r[4]) for r in rows],open('/tmp/claude-0/scalper_all.json','w'),default=float)
    print('--- PF IS / PF OOS (n IS) per mercato, TF, uscita ---')
    for name in SRC:
        for tfn,_ in TFS:
            print('%-7s %-3s '%(name,tfn)+' | '.join('%s %.2f/%.2f (%d)'%(r[2],r[3]['pf'],r[4]['pf'],r[3]['n']) for r in rows if r[0]==name and r[1]==tfn))
    best=[r for r in rows if r[3]['n']>=100 and r[3]['pf']>=1.2]
    print('combinazioni con PF IS>=1.2 e n>=100:',len(best),'su',len(rows))
    for r in sorted(best,key=lambda r:-r[3]['pf'])[:10]: print('  ',r[0],r[1],r[2],'IS PF %.2f n=%d DD %.0f%% R %.3f | OOS PF %.2f n=%d R %.3f'%(r[3]['pf'],r[3]['n'],r[3]['dd'],r[3]['R'],r[4]['pf'],r[4]['n'],r[4]['R']))
    val=[r for r in rows if r[3]['pf']>=1.5 and r[3]['dd']<=15 and r[3]['n']>=100 and r[4]['pf']>1.2 and r[4]['R']>0 and r[4]['n']>=30]
    print('VALIDATE (porte di Claudio):',[(r[0],r[1],r[2]) for r in val])
    allr=[r[3]['R'] for r in rows if r[3]['n']>=100]; print('R medio IS mediano sulle combinazioni con n>=100: %.3f ; R<0 in %d su %d'%(np.median(allr),sum(1 for x in allr if x<0),len(allr)))
