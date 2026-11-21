# Criteri: report/SCOPERTA_CANDIDATI_CRITERI_2026-11-21.md  (famiglie A overnight, B calendario, C RSI2, D momentum cross-sectional)
import glob,os,sys
import numpy as np, pandas as pd
RT=0.0003; SW=0.0004
CLS={'indici':['ASX200','CAC40','DAX','Dow30','EuroStoxx50','FTSE100','HangSeng','Nasdaq100','Nikkei225','Russell2000','SP500'],
 'energia':['Benzina','Gas_naturale','Gasolio_riscaldamento','Petrolio_Brent','Petrolio_WTI'],
 'metalli':['Argento','Oro','Palladio','Platino','Rame'],'agricoli':['Cacao','Caffe','Cotone','Grano','Mais','Soia','Zucchero'],
 'cripto':['Bitcoin','Ethereum'],'tassi_usd':['Treasury_10a','Treasury_30a','Indice_dollaro']}
CL={m:c for c,ms in CLS.items() for m in ms}
def load_raw(m):
    d=pd.read_csv(f'/tmp/claude-0/d1/D1_{m}.csv',sep=';'); d.columns=['t','o','h','l','c','v']; d['t']=pd.to_datetime(d.t)
    d=d.dropna(subset=['o','h','l','c']).sort_values('t').set_index('t'); return d[d.c>0]
def quality(d):
    # QUALITA' DATI (regola aggiunta dopo la prima passata su A, vedi criteri): per le famiglie che usano l'APERTURA (A, C) si parte dal
    # primo giorno in cui il 95% delle ultime 60 barre ha h>l (open/high/low veri) e si scartano le barre con apertura = chiusura precedente (apertura finta)
    ok=(d.h>d.l).astype(float).rolling(60).mean(); first=ok.index[ok>0.95]
    return d[d.index>=first[0]] if len(first) else d.iloc[0:0]
def tstat(x):
    x=np.asarray(x,float); n=len(x)
    return (x.mean()/(x.std(ddof=1)/np.sqrt(n))) if n>2 and x.std(ddof=1)>0 else 0.0
def pf(x):
    x=np.asarray(x,float); g=x[x>0].sum(); l=-x[x<0].sum(); return g/l if l>0 else np.inf
MK=sorted(CL); DC={m:load_raw(m) for m in MK}; D={m:quality(DC[m]) for m in MK}
out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
# ---------- A
P('=== A: overnight (chiusura->apertura) contro intraday (apertura->chiusura), long, netti di costi (+ swap 0,04%/notte sull\'overnight)')
P('mercato classe n | overnight lordo medio%, netto%, t IS/OOS | intraday netto%, t IS/OOS')
passA=[]; gross_pos_idx=0; n_idx=0
for m in MK:
    d=D[m]
    if len(d)==0: P(f'{m:22s} escluso da A (open non affidabile: troppe barre piatte)'); continue
    o,c=d.o.values,d.c.values; v=(d.h>d.l).values; n=len(d); cut=int(n*.7)
    gap=np.r_[1,np.diff(d.index.values).astype('timedelta64[D]').astype(int)]
    on=np.r_[np.nan,o[1:]/c[:-1]-1]; on_net=on-RT-SW*gap; idn=c/o-1-RT
    msk=np.r_[False,v[1:]&(np.abs(o[1:]/c[:-1]-1)>1e-6)]
    r={}
    for nm,x in (('on',on_net),('id',idn),('ong',on)):
        a=x[msk&(np.arange(n)<cut)]; b=x[msk&(np.arange(n)>=cut)]; r[nm]=(a,b)
    t_on=(tstat(r['on'][0]),tstat(r['on'][1])); t_id=(tstat(r['id'][0]),tstat(r['id'][1]))
    if CL[m]=='indici':
        n_idx+=1; gross_pos_idx+= (r['ong'][0].mean()>0 and r['ong'][1].mean()>0)
    P(f"{m:22s}{CL[m]:10s}{n:6d} | on lordo {np.mean(np.r_[r['ong'][0],r['ong'][1]])*100:+.3f} netto {np.mean(np.r_[r['on'][0],r['on'][1]])*100:+.3f} t {t_on[0]:+.1f}/{t_on[1]:+.1f} | id netto {np.mean(np.r_[r['id'][0],r['id'][1]])*100:+.3f} t {t_id[0]:+.1f}/{t_id[1]:+.1f}")
    for nm,t in (('overnight',t_on),('intraday',t_id)):
        if t[0]>=2 and t[1]>=2 and len(r['on' if nm=='overnight' else 'id'][0])>=100 and len(r['on' if nm=='overnight' else 'id'][1])>=40: passA.append((CL[m],nm,m))
P('indici con overnight LORDO positivo in IS e OOS:',gross_pos_idx,'su',n_idx)
P('A celle con t>=2 netto in IS e OOS:',len(passA),passA)
# ---------- B
P('\n=== B: giorno della settimana (5) e turn-of-month, lato scelto dal segno IS del lordo; t netto IS/OOS')
cells=[]
for m in MK:
    d=DC[m]; c=d.c.values; n=len(d); cut=int(n*.7); idx=d.index
    gap=np.r_[1,np.diff(idx.values).astype('timedelta64[D]').astype(int)]; r=np.r_[np.nan,c[1:]/c[:-1]-1]; dow=idx.dayofweek.values
    for k in range(5):
        sel=(dow==k)&(np.arange(n)>0)
        a=sel&(np.arange(n)<cut); b=sel&(np.arange(n)>=cut)
        if a.sum()<100 or b.sum()<40: continue
        side=1 if r[a].mean()>0 else -1
        net=(r-RT-SW*gap) if side==1 else (-r-RT)
        cells.append((m,CL[m],f'dow{k}',side,tstat(net[a]),tstat(net[b]),float(net[a].mean()),float(net[b].mean())))
    # turn-of-month
    mo=pd.Series(idx.to_period('M'),index=idx); last=mo.groupby(mo).apply(lambda s:s.index[-1]); rows=[]
    pos={t:i for i,t in enumerate(idx)}
    for p,tl in last.items():
        i=pos[tl]; 
        nxt=[j for j in range(i+1,min(i+8,n)) if idx[j].to_period('M')==p+1]
        if len(nxt)<3: continue
        j=nxt[2]; rr=c[j]/c[i]-1; hd=(idx[j]-idx[i]).days; rows.append((i,rr,hd))
    if len(rows)>=1:
        ii=np.array([x[0] for x in rows]); rr=np.array([x[1] for x in rows]); hd=np.array([x[2] for x in rows])
        a=ii<cut; b=~a
        if a.sum()>=100 and b.sum()>=40:
            side=1 if rr[a].mean()>0 else -1; net=(rr-RT-SW*hd) if side==1 else (-rr-RT)
            cells.append((m,CL[m],'TOM',side,tstat(net[a]),tstat(net[b]),float(net[a].mean()),float(net[b].mean())))
P('celle B valutabili (n IS>=100, OOS>=40):',len(cells),'(su 198 possibili: i mercati con storia corta cadono)')
pas=[x for x in cells if x[4]>=2 and x[5]>=2]
P('celle B con t netto >=2 in IS e OOS:',len(pas))
for x in pas: P('  ',x[0],x[1],x[2],'lato',x[3],f'tIS {x[4]:+.1f} tOOS {x[5]:+.1f} medio IS {x[6]*100:+.3f}% OOS {x[7]*100:+.3f}%')
from collections import Counter
cnt=Counter((x[1],x[2],x[3]) for x in pas); coh=[k for k,v in cnt.items() if v>=3]
P('B coerenza >=3 mercati stessa classe/giorno/lato:',coh)
nsig=sum(1 for x in cells if x[4]>=2); P('  (B: celle con t IS>=2:',nsig,'; attese per caso su',len(cells),'~',round(len(cells)*0.023,1),')')
# ---------- C
P('\n=== C: RSI(2)<10 & close>SMA200 long / RSI(2)>90 & close<SMA200 short; uscita close>SMA5 (long) o <SMA5 (short), max 10 barre')
tab={}
for m in MK:
    d=D[m]
    if len(d)<400: continue
    o,c=d.o.values,d.c.values; v=(d.h>d.l).values; n=len(d); cut=int(n*.7); idx=d.index
    v=v&np.r_[False,np.abs(o[1:]/c[:-1]-1)>1e-6]
    dl=np.diff(c,prepend=c[0]); up=pd.Series(np.maximum(dl,0)).ewm(alpha=.5,adjust=False).mean().values; dn=pd.Series(np.maximum(-dl,0)).ewm(alpha=.5,adjust=False).mean().values
    rsi=np.where(dn==0,100.0,100-100/(1+up/np.where(dn==0,1,dn))); s200=pd.Series(c).rolling(200).mean().values; s5=pd.Series(c).rolling(5).mean().values
    res={1:[],-1:[]}
    for side in (1,-1):
        t=200
        while t<n-2:
            sig=(rsi[t]<10 and c[t]>s200[t]) if side==1 else (rsi[t]>90 and c[t]<s200[t])
            if not sig or not v[t+1]: t+=1; continue
            e=o[t+1]; jx=None
            for j in range(t+1,min(t+11,n)):
                if (side==1 and c[j]>s5[j]) or (side==-1 and c[j]<s5[j]) or j==t+10: jx=j; break
            if jx is None: t+=1; continue
            nights=(idx[jx]-idx[t+1]).days; ret=side*(c[jx]/e-1)-RT-(SW*nights if side==1 else 0)
            res[side].append((t,ret)); t=jx
    for side in (1,-1):
        a=[r for tt,r in res[side] if tt<cut]; b=[r for tt,r in res[side] if tt>=cut]
        tab[(m,side)]=(len(a),pf(a) if a else 0,np.mean(a) if a else 0,len(b),pf(b) if b else 0,np.mean(b) if b else 0)
for side,sn in ((1,'LONG'),(-1,'SHORT')):
    P(f'--- {sn}: mercato n_IS PF_IS ret%_IS | n_OOS PF_OOS ret%_OOS')
    for m in MK:
        if (m,side) not in tab: continue
        a=tab[(m,side)]; P(f'{m:22s}{a[0]:5d} {a[1]:5.2f} {a[2]*100:+.2f} | {a[3]:4d} {a[4]:5.2f} {a[5]*100:+.2f}')
    for cl,ms in CLS.items():
        ok=[m for m in ms if (m,side) in tab and tab[(m,side)][0]>=50 and tab[(m,side)][1]>=1.3 and tab[(m,side)][3]>=20 and tab[(m,side)][4]>1.2]
        P(f'  CLASSE {cl} {sn}: mercati con IS PF>=1,3 (n>=50) e OOS PF>1,2 (n>=20): {len(ok)} {ok}')
# ---------- D
P('\n=== D: momentum cross-sectional (252-21), long top5/short bottom5, ribilanciamento 21 giorni, costi 0,03%/gamba + swap 0,04%/notte sul long')
Pn=pd.concat({m:DC[m].c for m in MK},axis=1); Pn=Pn[Pn.index.dayofweek<5].ffill(limit=3)
v=Pn.values; idx=Pn.index; ser=[]
for t in range(252,len(Pn)-21,21):
    sc=v[t-21]/v[t-252]-1; ok=~np.isnan(sc)&~np.isnan(v[t])&~np.isnan(v[t+21])
    if ok.sum()<12: continue
    e=np.where(ok)[0]; o=e[np.argsort(sc[e])]; sh=o[:5]; lo=o[-5:]
    rr=v[t+21]/v[t]-1; gross=rr[lo].mean()-rr[sh].mean(); nights=(idx[t+21]-idx[t]).days
    ser.append((idx[t],gross-2*RT-SW*nights,gross-2*RT,gross))
S=pd.DataFrame(ser,columns=['t','net','noswap','gross']).set_index('t'); n=len(S); cut=int(n*.7)
P('ribilanciamenti',n,S.index[0].date(),S.index[-1].date())
for nm in ('net','noswap','gross'):
    a=S[nm].values[:cut]; b=S[nm].values[cut:]
    P(f'{nm:7s} IS media {a.mean()*100:+.2f}%/mese t {tstat(a):+.2f} | OOS media {b.mean()*100:+.2f}% t {tstat(b):+.2f} | tutti {S[nm].mean()*100:+.2f}%')
y=S.net.groupby(S.index.year).sum(); tot=S.net.sum()
P('profitto netto per anno (somma mensili %):',{int(k):round(v*100,1) for k,v in y.items()}); P('quota del miglior anno sul totale netto:',round(float(y.max()/tot),2) if tot>0 else 'n/d (totale <= 0)')
open('/home/user/GITHUB/report/SCOPERTA_CANDIDATI_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
