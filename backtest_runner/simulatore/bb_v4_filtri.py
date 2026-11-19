# Analisi filtri Leonardo su BreakingBand v4 (criteri: report/BB_V4_FILTRI_LEONARDO_CRITERI_2026-11-19.md)
import sys,re,glob,csv,gzip,bisect,math,datetime as dt,os
D=sys.argv[1]; NEWS=sys.argv[2]
def eu_dst(d):
    def last_sun(y,m):
        x=dt.date(y,m,31 if m in(3,10) else 30)
        while x.weekday()!=6:x-=dt.timedelta(1)
        return x
    y=d.year; a=dt.datetime.combine(last_sun(y,3),dt.time(1)); b=dt.datetime.combine(last_sun(y,10),dt.time(1))
    return a<=d<b   # approssimazione in UTC~server
def parse_report(f):
    t=open(f,encoding='utf-16').read()
    i=t.find('Orario di Apertura'); t=t[i:]
    rows=re.findall(r'<tr[^>]*>(.*?)</tr>',t,re.S)
    out=[]
    for r in rows:
        c=[re.sub(r'<[^>]+>','',x).strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,re.S)]
        if len(c)>=9 and re.match(r'\d{4}\.\d\d\.\d\d',c[0]): out.append(c)
    ent=[];i=0
    # coppie: apertura (commento BB) seguita da chiusura (commento tp/sl)
    pend=None
    for c in out:
        com=c[-1]
        if com=='BB': pend=c
        elif pend is not None and (com.startswith('tp') or com.startswith('sl') or com.startswith('[')):
            ent.append((pend[0],c[0],pend[3])); pend=None
    seen=set();u=[]
    for x in ent:
        if (x[0],x[1]) not in seen: seen.add((x[0],x[1])); u.append(x)
    return u
def pt(s): return dt.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
news={}
for l in gzip.open(NEWS,'rt',encoding='cp1252',errors='replace').read().splitlines()[1:]:
    p=l.split(';')
    if len(p)>=3 and p[1]=='High': news.setdefault(p[2],[]).append(dt.datetime.strptime(p[0],'%Y.%m.%d %H:%M'))
for k in news: news[k].sort()
def exposed(cur,a,b):
    for v in cur:
        L=news.get(v,[]); i=bisect.bisect_left(L,a)
        if i<len(L) and L[i]<=b: return True
    return False
T=[]
for f in sorted(glob.glob(D+'/report/BV_*.htm')):
    m=re.match(r'BV_([A-Z]{6})_(H1|M30)_',os.path.basename(f)); sym,tf=m.groups()
    ent=parse_report(f)
    ser=list(csv.DictReader(open(D+'/serie/'+os.path.basename(f)[:-4]+'.csv'),delimiter=';'))
    sd={}
    for s in ser: sd.setdefault(s['data'],[]).append(float(s['rendimento']))
    cnt={}
    for e in ent: d=e[1][:10]; cnt[d]=cnt.get(d,0)+1
    if sum(cnt.values())!=len(ent) or any(d not in sd for d in cnt): print('MISMATCH',sym,tf,len(ent),len(ser),file=sys.stderr)
    for e in ent:
        a,b=pt(e[0]),pt(e[1]); d=e[1][:10]
        if d not in sd: continue
        rr=sum(sd[d])/cnt[d]/0.005
        it=a+dt.timedelta(hours=1 if eu_dst(a) else 0)
        mat=7<=it.hour<10
        cur=[sym[:3],sym[3:]]
        ex=exposed(cur,a,b); ex2=exposed(cur,a-dt.timedelta(hours=2),b)
        T.append(dict(sym=sym,tf=tf,a=a,y=a.year,R=rr,mat=mat,nn=not ex,nn2=not ex2))
import pickle; pickle.dump(T,open(D+'/T.pkl','wb'))
def st(x):
    n=len(x)
    if n==0:return (0,float('nan'),float('nan'),float('nan'),float('nan'))
    m=sum(t['R'] for t in x)/n; w=sum(t['R']>0 for t in x)/n
    sd=(sum((t['R']-m)**2 for t in x)/(n-1))**.5 if n>1 else 0
    se=sd/n**.5
    return (n,w,m,m-1.645*se,m+1.645*se)
def fmt(x):
    n,w,m,lo,hi=st(x); return f"n={n:4d} win={w*100:5.1f}% R={m:+.3f} IC90[{lo:+.3f},{hi:+.3f}]"
F={'MATTINA':lambda t:t['mat'],'NOTIZIE':lambda t:t['nn'],'NOTIZIE_2H':lambda t:t['nn2'],'MATT+NOT':lambda t:t['mat'] and t['nn']}
for tf in('H1','M30'):
    for per,lo,hi in(('IS 2013-20',2013,2020),('OOS 2021-24',2021,2024),('TUTTO',2013,2024)):
        S=[t for t in T if t['tf']==tf and lo<=t['y']<=hi]
        print(f"\n== {tf} {per} ==\n  base         {fmt(S)}")
        for k,fn in F.items():
            print(f"  {k:12s} tenute {fmt([t for t in S if fn(t)])}\n  {'':12s} escluse {fmt([t for t in S if not fn(t)])}")
