#!/usr/bin/env python3
# =====================================================================
#  VERIFICA DELL'AUDIT controllo-caccia (25/09/2026) su P2d
#  (sonda_dax_short_meccanismi.py, cella gap-down >= 0,50%).
#  Ricalcola, sugli stessi dati GRXEUR 2011-2018 e con la stessa camminata
#  pessimista: (1) quota di operazioni in cui lo stop e' il PAVIMENTO 68 e
#  stop naturale mediano; (2) fragilita' (senza le 3 / 5 migliori);
#  (3) operazioni nelle settimane di disallineamento ora legale USA/UE
#  (histdata e' in ora di New York: li' le 08:00 della sonda sono un'ora
#  prima della cash); (4) O2 stimato: giornate di P2d in cui la geometria
#  della 770105 (retest corto: range 35', rottura sotto min-5, limit a
#  min+2, scadenza 120', APPROSSIMATA sulle M1) avrebbe un corto;
#  (5) P2d con la geometria dell'EA approssimata (massimo range + 15,
#  nessun pavimento, cancellazione a meta' gap, TWAP al posto della VWAP).
#  Uso: python3 sonda_dax_short_verifica_audit.py  (dati in dati/GRXEUR_*.csv)
# =====================================================================
import glob,collections,statistics
from datetime import datetime,timedelta,date
by=collections.defaultdict(dict)
for p in sorted(glob.glob('dati/GRXEUR_*.csv')):
    for ln in open(p):
        q=ln.strip().split(';')
        if len(q)<5: continue
        t=datetime.strptime(q[0],'%Y%m%d %H%M%S')+timedelta(hours=5)
        by[t.date()][t.hour*60+t.minute]=(float(q[1]),float(q[2]),float(q[3]),float(q[4]))
OPEN=480;CLOSE=989;COSTO=1.7;PAV=68.0
g=sorted(d for d in by if any(m in by[d] for m in range(OPEN,OPEN+5)) and sum(1 for m in by[d] if OPEN<=m<=CLOSE)>=300)
def op(d,m):
    for k in range(m,m+5):
        if k in by[d]: return by[d][k][0],k
    return None,None
def cl(d,m):
    for k in range(m,m-6,-1):
        if k in by[d]: return by[d][k][3]
def hilo(d,a,b):
    hs=[by[d][k][1] for k in range(a,b+1) if k in by[d]]; ls=[by[d][k][2] for k in range(a,b+1) if k in by[d]]
    return (max(hs),min(ls)) if hs else (None,None)
def walk(d,m0,v,e,dist,tgt,mend):
    sl=e-dist if v>0 else e+dist; u=e
    for k in range(m0,mend+1):
        b=by[d].get(k)
        if not b: continue
        o,h,l,c=b;u=c
        if v>0:
            if l<=sl: return -dist
            if h>=tgt: return tgt-e
        else:
            if h>=sl: return -dist
            if l<=tgt: return e-tgt
    cc=cl(d,mend); return ((cc if cc else u)-e)*v
def lastsun(y,m):
    d=date(y,m+1,1)-timedelta(days=1) if m<12 else date(y,12,31)
    while d.weekday()!=6: d-=timedelta(days=1)
    return d
def nthsun(y,m,n):
    d=date(y,m,1)
    while d.weekday()!=6: d+=timedelta(days=1)
    return d+timedelta(days=7*(n-1))
def mismatch(d):
    y=d.year
    us=(nthsun(y,3,2)<=d<nthsun(y,11,1)); eu=(lastsun(y,3)<=d<lastsun(y,10))
    return us!=eu
tr=[]
for i in range(1,len(g)):
    d=g[i]; PC=cl(g[i-1],CLOSE); O,_=op(d,OPEN)
    if not PC or not O or O/PC-1>-0.005: continue
    rh,rl=hilo(d,OPEN,OPEN+14)
    if i<20: continue
    for k in range(OPEN+15,OPEN+90):
        b=by[d].get(k)
        if not b: continue
        if b[2]<rl:
            e=rl if b[0]>=rl else b[0]; nat=rh-e; dist=max(PAV,nat)
            r=(walk(d,k,-1,e,dist,e-2*dist,CLOSE-5)-COSTO)/dist
            # O2: geometria 770105 = retest short: range 08:00-08:34, rottura sotto rl35-5, limit a rl35+2, scadenza 120'
            h35,l35=hilo(d,OPEN,OPEN+34); o2=False; brk=None
            for kk in range(OPEN+35,CLOSE-60):
                bb=by[d].get(kk)
                if not bb: continue
                if brk is None:
                    if bb[2]<l35-5: brk=kk
                else:
                    if kk-brk>120: break
                    if bb[1]>=l35+2: o2=True; break
            tr.append((d,r,nat,dist,mismatch(d),o2)); break
def st(xs):
    n=len(xs);E=statistics.mean(xs);s=statistics.stdev(xs);return n,round(E,4),round(E/(s/n**0.5),2)
R=[t[1] for t in tr]
print('tutti',st(R))
print('floor binding %',100*sum(1 for t in tr if t[2]<PAV)/len(tr),'nat med',statistics.median(t[2] for t in tr))
s=sorted(R)
print('senza 3 migliori',st(s[:-3]),'senza 5',st(s[:-5]))
mm=[t for t in tr if t[4]]; print('mismatch n',len(mm),'senza',st([t[1] for t in tr if not t[4]]))
o=[t for t in tr if t[5]]; print('O2 giorni con retest short 770105-like',len(o),'su',len(tr),'=%.0f%%'%(100*len(o)/len(tr)), 'E P2d in quei giorni',st([t[1] for t in o]) if len(o)>2 else None)
# geometria EA approssimata: stop = massimo range 15' + 15, nessun pavimento, cancellazione a meta' gap,
# TWAP (media di hlc3 dall'apertura) al posto della VWAP (histdata senza volumi), bersaglio 2R, uscita 16:24
ea=[]
for i in range(20,len(g)):
    d=g[i]; PC=cl(g[i-1],CLOSE); O,_=op(d,OPEN)
    if not PC or not O or O/PC-1>-0.005: continue
    rh,rl=hilo(d,OPEN,OPEN+14); mezzo=PC+0.5*(O-PC); mx=rh
    tw=[ (by[d][k][1]+by[d][k][2]+by[d][k][3])/3 for k in range(OPEN,OPEN+15) if k in by[d]]
    if mx>=mezzo: continue
    for k in range(OPEN+15,OPEN+90):
        b=by[d].get(k)
        if not b: continue
        mx=max(mx,b[1])
        if mx>=mezzo: break
        tw.append((b[1]+b[2]+b[3])/3); twap=sum(tw)/len(tw)
        if b[2]<rl and b[2]<twap:
            e=min(rl,twap) if b[0]>=min(rl,twap) else b[0]; dist=rh+15-e
            ea.append((walk(d,k,-1,e,dist,e-2*dist,CLOSE-5)-COSTO)/dist); break
print('geometria EA approssimata',st(ea),'stop EA mediano n/a')
