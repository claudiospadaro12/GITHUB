import re,html,glob,collections,statistics,math,datetime as dt
def read(p):
    b=open(p,'rb').read()
    for e in ('utf-16','utf-8'):
        try: return b.decode(e)
        except Exception: pass
def rows(t):
    return [[html.unescape(re.sub(r'<[^>]+>','',c)).strip().replace('\xa0',' ') for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',tr,flags=re.S|re.I)] for tr in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I)]
def num(x):
    try: return float(x.replace(' ','').replace(',',''))
    except: return 0.0
# D1
D1={}
for l in open('lavoro_wt/data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv').read().split('\n')[1:]:
    c=l.split('\t')
    if len(c)>=5 and c[0]>='2024.12.01': D1[c[0]]=tuple(map(float,c[1:5]))
days=sorted(D1)
def load(p):
    R=rows(read(p)); i=[k for k,r in enumerate(R) if r and r[0] in('Affari','Deals')][0]
    D=[]
    for r in R[i+2:]:
        if len(r)>=12 and re.match(r'\d{4}\.\d\d\.\d\d',r[0]) and r[2]=='XAUUSD':
            D.append(dict(t=r[0],typ=r[3],dir=r[4],vol=num(r[5]),px=num(r[6]),cm=num(r[8]),sw=num(r[9]),pr=num(r[10])))
    D.sort(key=lambda d:d['t'])
    return D
def pair(D):
    """ritorna posizioni [(open_t,close_t,side,vol,open_px,close_px,net)]"""
    op={'buy':[],'sell':[]}; pos=[]; k_by_day=collections.defaultdict(list)
    for d in D:
        if d['dir']=='in':
            op[d['typ']].append([d['vol'],d['px'],d['t'],d['cm']])
        elif d['dir']=='out':
            side='buy' if d['typ']=='sell' else 'sell'
            L=op[side]; rem=d['vol']
            ex=[x for x in L if abs(x[0]-rem)<1e-9]
            seq=ex[:1] if ex else list(L)
            for x in list(seq):
                if rem<=1e-9: break
                q=min(x[0],rem)
                pos.append(dict(o=x[2],c=d['t'],side=side,vol=q,opx=x[1],cpx=d['px'],net=d['pr']*q/d['vol']+d['sw']*q/d['vol']+d['cm']*q/d['vol']+x[3]*q/x[0]*(1 if True else 0),gross=d['pr']*q/d['vol']))
                sgn=1 if side=='buy' else -1
                raw=(d['px']-x[1])*sgn*q*100
                if abs(raw)>2: k_by_day[d['t'][:10]].append(d['pr']*q/d['vol']/raw)
                x[0]-=q; rem-=q
                if x[0]<=1e-9: L.remove(x)
    return pos,k_by_day,op
def ksmooth(kd):
    ds=sorted(kd); med={d:statistics.median(kd[d]) for d in ds if kd[d]}
    out={}; 
    for d in days:
        near=[med[x] for x in med if abs((dt.date(*map(int,x.split('.')))-dt.date(*map(int,d.split('.')))).days)<=20]
        out[d]=statistics.median(near) if near else 0.88
    return out
def series(path):
    D=load(path); pos,kd,op=pair(D); K=ksmooth(kd)
    dep=80000.0
    # realizzato per giorno (netto: commission+swap+profit sui deal)
    real=collections.defaultdict(float)
    for d in D:
        real[d['t'][:10]]+=d['pr']+d['sw']+d['cm']
    bal=0; B={}; 
    for dd in days:
        bal+=real.get(dd,0); B[dd]=bal
    close_eq={};adv_eq={}
    for dd in days:
        o,h,l,c=D1[dd]; k=K[dd]; fc=fa=0.0
        for p in pos:
            if p['o'][:10]<=dd and p['c'][:10]>dd:
                sgn=1 if p['side']=='buy' else -1
                fc+=(c-p['opx'])*sgn*p['vol']*100*k
                adv=l if p['side']=='buy' else h
                fa+=(adv-p['opx'])*sgn*p['vol']*100*k
        close_eq[dd]=B[dd]+fc; adv_eq[dd]=B[dd]+min(fa,fc)
    return dict(real=real,bal=B,ceq=close_eq,aeq=adv_eq,pos=pos,openleft=sum(len(v) for v in op.values()))
def maxdd(s):
    pk=-1e18;m=0
    for v in s: pk=max(pk,v); m=max(m,pk-v)
    return m
def corr(a,b):
    n=len(a);ma=sum(a)/n;mb=sum(b)/n
    return sum((x-ma)*(y-mb) for x,y in zip(a,b))/math.sqrt(sum((x-ma)**2 for x in a)*sum((y-mb)**2 for y in b))
GR=series('lavoro_wt/backtest_pipeline/risultati_archivio/GR80K_20261020/GRSET80K_TRANCHE1_20261020_162333.htm')
GB={n:series(glob.glob('gb4z/GB4_GOLDBOTONEMT5/report/GB4_GOLDBOTONEMT5_TRANCHE%d_*.htm'%n)[0]) for n in (1,5)}
rep={'GR':3854.21,1:7281.90,5:3213.10}
def show(nm,S,rd):
    pc=maxdd([S['ceq'][d] for d in days]); pa=maxdd([S['aeq'][d] for d in days]); br=maxdd([S['bal'][d] for d in days])
    print(f"{nm}: posizioni {len(S['pos'])} aperte-non-chiuse {S['openleft']} | DD saldo ricostruito {br:.0f} | DD equity (chiusure D1) {pc:.0f} | (band avversa H/L) {pa:.0f} | DD equity del REPORT {rd:.0f} | netto {S['bal'][days[-1]]:.0f}")
show('GoldReaper',GR,rep['GR']); show('GB step3000',GB[1],rep[1]); show('GB step6000',GB[5],rep[5])
for n,nm in ((1,'step3000'),(5,'step6000')):
    G=GB[n]
    c=[GR['ceq'][d]+G['ceq'][d] for d in days]; a=[GR['aeq'][d]+G['aeq'][d] for d in days]
    b=[GR['bal'][d]+G['bal'][d] for d in days]
    dc=maxdd(c); da=maxdd(a); db=maxdd(b)
    print(f"INSIEME GB {nm}+GR: netto {b[-1]:.0f} | DD saldo {db:.0f} ({100*db/80000:.2f}% di 80K) | DD equity chiusure {dc:.0f} ({100*dc/80000:.2f}%) | banda avversa {da:.0f} ({100*da/80000:.2f}%)")
    # nota: le due EA su UN conto da 80K: i lotti sono quelli dei due test da 80K ciascuno, qui sommati (nessuna riduzione)
    ra=[GR['real'].get(d,0) for d in days]; rb=[G['real'].get(d,0) for d in days]
    print(f"   corr giornaliera realizzi {corr(ra,rb):.3f}; giorni {len(days)}")
    # correlazione sul equity giornaliero (variazioni)
    ea=[GR['ceq'][days[i]]-GR['ceq'][days[i-1]] for i in range(1,len(days))]; eb=[G['ceq'][days[i]]-G['ceq'][days[i-1]] for i in range(1,len(days))]
    print(f"   corr variazioni giornaliere di equity (con flottante) {corr(ea,eb):.3f}")
    # posizioni contemporanee massime e lotti massimi totali
    ev=[]
    for S in (GR,G):
        for p in S['pos']: ev.append((p['o'],p['vol'])); ev.append((p['c'],-p['vol']))
    ev.sort(key=lambda x:(x[0],x[1]))
    cur=mx=0
    for t,v in ev: cur+=v; mx=max(mx,cur)
    print(f"   lotti aperti insieme: massimo {mx:.2f}")
    peakpos=0;cp=0;e2=[]
    for S in (GR,G):
        for p in S['pos']: e2.append((p['o'],1)); e2.append((p['c'],-1))
    e2.sort(key=lambda x:(x[0],x[1]))
    for t,v in e2: cp+=v; peakpos=max(peakpos,cp)
    print(f"   posizioni aperte insieme: massimo {peakpos}")
    # peggior giorno e mese
    wd=min(zip([c[i]-c[i-1] for i in range(1,len(c))],days[1:]))
    print(f"   peggior giorno di equity: {wd[0]:.0f} il {wd[1]} ({-100*wd[0]/80000:.2f}% di 80K)")
