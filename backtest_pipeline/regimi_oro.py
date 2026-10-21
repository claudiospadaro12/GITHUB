import csv,datetime,collections,sys
f=sys.argv[1]
rows=[]
for r in csv.DictReader(open(f),delimiter='\t'):
    d=datetime.datetime.strptime(r['<DATE>'],'%Y.%m.%d').date()
    rows.append((d,float(r['<OPEN>']),float(r['<HIGH>']),float(r['<LOW>']),float(r['<CLOSE>'])))
rows.sort()
print('barre',len(rows),rows[0][0],rows[-1][0])
# controlli qualita'
bad=[x for x in rows if not (x[3]<=min(x[1],x[4]) and x[2]>=max(x[1],x[4]) and x[3]>0)]
print('barre incoerenti OHLC',len(bad))
gaps=[(a[0],b[0]) for a,b in zip(rows,rows[1:]) if (b[0]-a[0]).days>5]
print('buchi > 5 giorni',gaps[:10],len(gaps))
cnt=collections.Counter(x[0].year for x in rows); print({y:cnt[y] for y in sorted(cnt)})
def win(a,b):
    s=[x for x in rows if a<=x[0]<=b]
    if len(s)<200: return None
    prev=[x for x in rows if x[0]<a]; c0=prev[-1][4] if prev else s[0][1]
    c1=s[-1][4]; hi=max(x[2] for x in s); lo=min(x[3] for x in s)
    return (c1/c0-1)*100,(hi-lo)/c0*100,len(s),c0,c1,hi,lo
# finestre di 12 mesi con inizio il 1 di ogni mese
out=[]
y,m=2004,7
while True:
    a=datetime.date(y,m,1)
    ye,me=(y+1,m) if m>1 else (y,12)
    # fine = ultimo giorno del mese m-1 dell'anno successivo
    e=datetime.date(y+1,m,1)-datetime.timedelta(days=1)
    if e>rows[-1][0]: break
    w=win(a,e)
    if w: out.append((a,e)+w)
    m+=1
    if m>12: m=1;y+=1
def cl(R,C):
    if R>=15: return 'RIALZO'
    if R<=-15: return 'RIBASSO'
    if abs(R)<=8 and C<=25: return 'LATERALE'
    return '-'
print('finestre',len(out))
for cls in ('RIALZO','RIBASSO','LATERALE'):
    ok=[o for o in out if cl(o[2],o[3])==cls]
    print(cls,'finestre che soddisfano',len(ok))
    # piu' recenti NON sovrapposte alla finestra gia' usata (>= 2025-01-01)
    rec=[o for o in ok if o[1]<datetime.date(2025,1,1)]
    for o in rec[-6:]: print('   ',o[0],'->',o[1],'R %+.1f%% C %.1f%% barre %d c0 %.0f c1 %.0f hi %.0f lo %.0f'%(o[2],o[3],o[4],o[5],o[6],o[7],o[8]))
w=win(datetime.date(2025,1,1),datetime.date(2026,10,1)); print('FINESTRA GIA USATA 2025.01-2026.10: R %+.1f%% C %.1f%% (c0 %.0f c1 %.0f)'%(w[0],w[1],w[3],w[4]))
print('--- anni solari')
for yy in range(2005,2026):
    w=win(datetime.date(yy,1,1),datetime.date(yy,12,31))
    if w: print(yy,'R %+.1f%% C %.1f%% %s'%(w[0],w[1],cl(w[0],w[1])))
print('=== SELEZIONE con la regola: la finestra piu recente per classe, non sovrapposta alle altre e al 2025-26')
cand={c:[o for o in out if cl(o[2],o[3])==c and o[1]<datetime.date(2025,1,1)] for c in ('RIALZO','RIBASSO','LATERALE')}
ria=cand['RIALZO'][-1]
lat=[o for o in cand['LATERALE'] if o[1]<ria[0]][-1]
rib=[o for o in cand['RIBASSO'] if o[1]<lat[0]][-1]
for nm,o in (('RIALZO',ria),('LATERALE',lat),('RIBASSO',rib)):
    print(nm,o[0],'->',o[1],'R %+.1f%% C %.1f%% barre %d c0 %.0f c1 %.0f'%(o[2],o[3],o[4],o[5],o[6]))
# finestre alternative per sensibilita': tutte le laterali che finiscono prima di 2024-01-01
print('laterali finestre che finiscono prima del 2024-01-01 (ultime 8):')
for o in [o for o in cand['LATERALE'] if o[1]<ria[0]][-8:]: print('  ',o[0],'->',o[1],'R %+.1f%% C %.1f%%'%(o[2],o[3]))
# quando e' stata l'ultima volta che l'oro e' sceso: massimo ribasso su 12 mesi dopo 2014
mm=[o for o in out if o[0]>=datetime.date(2014,4,1)]
print('peggior R a 12 mesi dopo 2014-04:',min(mm,key=lambda o:o[2])[0],'%+.1f%%'%min(o[2] for o in mm))
