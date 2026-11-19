#!/usr/bin/env python3
# Screening D1 (criteri: report/GOLDENZOE_ALTRI_MERCATI_CRITERI_2026-11-19.md, sezione D1). Hold-out 2025+ NON stampato.
import sys,glob,os,collections
import numpy as np,pandas as pd
D=sys.argv[1]; COST=0.0005   # 0,05% del prezzo per giro
CLASSE={}
for l in open(os.path.join(D,'D1_ELENCO.csv'),encoding='utf-8-sig').read().split('\n')[1:]:
    p=l.split(';')
    if len(p)>=4: CLASSE[p[1]]=(p[2],p[4])
def entries(C,H,L,N,d):
    n=len(C); e=np.zeros(n,dtype=int)
    hh=pd.Series(H).rolling(N).max().shift(1).values; ll=pd.Series(L).rolling(N).min().shift(1).values
    for i in range(N+1,n):
        if d==1 and C[i]>hh[i]: e[i]=1
        elif d==-1 and C[i]<ll[i]: e[i]=-1
    return e
def trail(O,H,L,C,atr,ks,entries,m=3.0):
    n=len(C); tr=[]; pos=0
    for i in range(120,n-1):
        if pos==0:
            d=entries[i]
            if d==0 or np.isnan(atr[i]): continue
            pos=d; ent=O[i+1]; risk=m*atr[i]; stop=ent-d*risk; ext=ent; t0=ks[i+1]; start=i+1
            if risk<=0: pos=0; continue
        if pos!=0 and i>=start:
            hit=(pos==1 and L[i]<=stop) or (pos==-1 and H[i]>=stop)
            if hit:
                px=min(O[i],stop) if pos==1 else max(O[i],stop)
                tr.append((t0,pos*(px-ent)/risk-COST*ent/risk,ks[i])); pos=0; continue
            ext=max(ext,H[i]) if pos==1 else min(ext,L[i])
            a=atr[i]; stop=max(stop,ext-m*a) if pos==1 else min(stop,ext+m*a)
    return tr
def met(rs):
    r=np.array(rs); n=len(r)
    if n==0: return dict(n=0,pf=0,t=0,sum=0,mean=0)
    g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l if l>0 else 99.0
    t=r.mean()/(r.std(ddof=1)/np.sqrt(n)) if n>1 and r.std(ddof=1)>0 else 0
    return dict(n=n,pf=pf,t=t,sum=r.sum(),mean=r.mean())
RES={}
for f in sorted(glob.glob(os.path.join(D,'D1_*.csv'))):
    nome=os.path.basename(f)[3:-4]
    if nome=='ELENCO': continue
    d=pd.read_csv(f,sep=';'); d['date']=pd.to_datetime(d['date']); d=d.dropna().reset_index(drop=True)
    d=d[(d['high']>0)&(d['low']>0)].reset_index(drop=True)
    O,H,L,C=[d[k].values.astype(float) for k in ('open','high','low','close')]
    pc=pd.Series(C).shift(1); tr=pd.concat([pd.Series(H)-pd.Series(L),(pd.Series(H)-pc).abs(),(pd.Series(L)-pc).abs()],axis=1).max(axis=1)
    atr=tr.ewm(alpha=1/14,adjust=False).mean().values; ks=d['date'].dt.strftime('%Y-%m-%d').values
    primo=ks[0]
    for N in (20,55):
        for dr in (1,-1):
            t=trail(O,H,L,C,atr,ks,entries(C,H,L,N,dr))
            IS=[r for a,r,b in t if a<'2015-01-01']; OOS=[r for a,r,b in t if '2015-01-01'<=a<'2025-01-01']
            RES[(nome,N,dr)]=(met(IS),met(OOS),primo)
def passa_is(m): return m['n']>=30 and m['pf']>=1.3 and m['t']>=2
def passa_oos(m): return m['n']>=15 and m['pf']>1.2 and m['sum']>0
print('mercato (classe, inizio) | N dir | IS n PF t | OOS n PF sumR | esito')
for (nome,N,dr),(a,b,primo) in sorted(RES.items(),key=lambda x:(CLASSE.get(x[0][0],('?',''))[0],x[0])):
    ok_len=primo<='2006-12-31'
    tag=''
    if ok_len and passa_is(a): tag='IS ok' + (' + OOS ok' if passa_oos(b) else '')
    if (not ok_len): tag='storico IS < 8 anni'
    if a['n']>=1 and (tag.startswith('IS') or N==55):
        print('%-22s %-12s %-12s N%-2d %s | IS %3d PF %5.2f t %5.1f | OOS %3d PF %5.2f R %+6.1f | %s'%(nome,CLASSE[nome][0],primo,N,'L' if dr==1 else 'S',a['n'],a['pf'],a['t'],b['n'],b['pf'],b['sum'],tag))
# candidati: passano IS+OOS con N=20 e N=55 nella stessa direzione
cand=collections.defaultdict(list)
for dr in (1,-1):
    for nome in {k[0] for k in RES}:
        ok=True; primo=RES[(nome,20,dr)][2]
        for N in (20,55):
            a,b,_=RES[(nome,N,dr)]
            if not (primo<='2006-12-31' and passa_is(a) and passa_oos(b)): ok=False
        if ok: cand[(CLASSE[nome][0],dr)].append(nome)
print('\n=== passano IS+OOS con ENTRAMBE le N, per classe e direzione ===')
for k,v in sorted(cand.items()): print(k,v)
if not cand: print('(nessuno)')
n_is=sum(1 for (nome,N,dr),(a,b,p) in RES.items() if p<='2006-12-31' and passa_is(a)); n_t=sum(1 for (nome,N,dr),(a,b,p) in RES.items() if p<='2006-12-31')
n_both=sum(1 for (nome,N,dr),(a,b,p) in RES.items() if p<='2006-12-31' and passa_is(a) and passa_oos(b))
print('prove valide %d; passano IS %d; passano IS+OOS %d'%(n_t,n_is,n_both))

if len(sys.argv)>2 and sys.argv[2]=='cand':
    print('\n=== CANDIDATI FISSATI (HangSeng, Nikkei225 long): controllo deriva e hold-out 2025+ ===')
    for nome in ('HangSeng','Nikkei225'):
        d=pd.read_csv(os.path.join(D,'D1_%s.csv'%nome),sep=';'); d['date']=pd.to_datetime(d['date']); d=d.dropna().reset_index(drop=True)
        O,H,L,C=[d[k].values.astype(float) for k in ('open','high','low','close')]
        pc=pd.Series(C).shift(1); tr=pd.concat([pd.Series(H)-pd.Series(L),(pd.Series(H)-pc).abs(),(pd.Series(L)-pc).abs()],axis=1).max(axis=1)
        atr=tr.ewm(alpha=1/14,adjust=False).mean().values; ks=d['date'].dt.strftime('%Y-%m-%d').values
        for N in (20,55):
            for dr in (1,-1):
                t=trail(O,H,L,C,atr,ks,entries(C,H,L,N,dr))
                IS=met([r for a,r,b in t if a<'2015-01-01']); OOS=met([r for a,r,b in t if '2015-01-01'<=a<'2025-01-01']); HO=met([r for a,r,b in t if a>='2025-01-01'])
                print('%-10s N%-2d %s | IS n%3d PF %5.2f | OOS n%3d PF %5.2f R %+5.1f | HOLD-OUT 2025+ n%2d PF %5.2f R %+5.1f'%(nome,N,'L' if dr==1 else 'S',IS['n'],IS['pf'],OOS['n'],OOS['pf'],OOS['sum'],HO['n'],HO['pf'],HO['sum']))
