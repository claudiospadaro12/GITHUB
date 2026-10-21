import csv,datetime,statistics as st,sys
f=sys.argv[1]
rows=[]
for r in csv.DictReader(open(f),delimiter='\t'):
    d=datetime.datetime.strptime(r['<DATE>'],'%Y.%m.%d').date()
    rows.append((d,float(r['<OPEN>']),float(r['<HIGH>']),float(r['<LOW>']),float(r['<CLOSE>']),int(r['<SPREAD>'])))
rows.sort()
def win(a,b):
    s=[x for x in rows if a<=x[0]<=b]
    if len(s)<250: return None
    prev=[x for x in rows if x[0]<a]; c0=prev[-1][4]
    sp=[x[5] for x in s]
    return dict(R=(s[-1][4]/c0-1)*100,C=(max(x[2] for x in s)-min(x[3] for x in s))/c0*100,n=len(s),spmed=st.median(sp),spmean=st.mean(sp),zeri=sum(1 for v in sp if v==0))
def cl(R,C):
    if R>=15: return 'RIALZO'
    if R<=-15: return 'RIBASSO'
    if abs(R)<=8 and C<=25: return 'LATERALE'
    return '-'
out=[];y,m=2004,7
while True:
    a=datetime.date(y,m,1); e=datetime.date(y+1,m,1)-datetime.timedelta(days=1)
    if e>=datetime.date(2025,1,1): break
    w=win(a,e)
    if w: w.update(a=a,e=e,cl=cl(w['R'],w['C'])); out.append(w)
    m+=1
    if m>12: m=1;y+=1
SOGLIA=float(sys.argv[2])
print('regola controllo: stessa classificazione, in piu spread mediano D1 >= %g punti; la finestra piu recente per classe, non sovrapposte'%SOGLIA)
ok={c:[w for w in out if w['cl']==c and w['spmed']>=SOGLIA] for c in ('RIALZO','LATERALE','RIBASSO')}
sel={}
last=datetime.date(2100,1,1)
for c in ('RIALZO','LATERALE','RIBASSO'):
    cand=[w for w in ok[c] if w['e']<last]
    w=cand[-1]; sel[c]=w; last=w['a']
    print(c,w['a'],'->',w['e'],'R %+.1f%% C %.1f%% barre %d spread mediano %g medio %.1f zeri %d'%(w['R'],w['C'],w['n'],w['spmed'],w['spmean'],w['zeri']))
for c in ('RIALZO','LATERALE','RIBASSO'): print(c,'alternative recenti:',[(str(w['a']),w['spmed']) for w in ok[c][-5:]])
