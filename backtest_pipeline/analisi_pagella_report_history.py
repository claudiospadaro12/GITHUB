# APPOGGIO (NON passato dal cancello come strumento): pagella descrittiva di un ReportHistory MT5 del demo piccolo 50503392. Uso: cd <radice repo> e adattare i percorsi D/files in testa. Join posizione -> ordine per ticket (417/443 trovati), fallback sui deal 'in'.
import openpyxl,re,collections,datetime as dt,sys,glob,warnings
warnings.filterwarnings('ignore')
def f(x):
    try: return float(str(x).replace(' ',''))
    except: return None
def T(s): return dt.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
def load(path):
    wb=openpyxl.load_workbook(path,data_only=True)
    rows=list(wb.active.iter_rows(values_only=True))
    sect=None; pos=[]; orders={}; deals=[]
    for r in rows:
        if r and r[0] in ('Posizioni','Ordini','Affari','Risultati') and all(c is None for c in r[1:]): sect=r[0]; continue
        if not r or r[0] is None or r[0] in ('Ora','Orario di Apertura'): continue
        if sect=='Posizioni' and isinstance(r[1],int): pos.append(r)
        if sect=='Ordini' and isinstance(r[1],int): orders[r[1]]=r
        if sect=='Affari' and isinstance(r[1],int): deals.append(r)
    return pos,orders,deals
D='lavoro_wt/data/statements/'
files=sorted(glob.glob(D+'ReportHistory_50503392_2026-10-1[2345].xlsx'))
allord={}; alldeals={}
for fp in files:
    p,o,d=load(fp)
    for k,v in o.items(): allord.setdefault(k,v)
    for x in d: alldeals.setdefault(x[1],x)
    print(fp[-15:],len(p),len(o),len(d))
pos,orders,deals=load(D+'ReportHistory_50503392_2026-10-15.xlsx')
inpos=set(r[1] for r in pos)
print('pos id in orders(all files):',sum(1 for r in pos if r[1] in allord),'of',len(pos))
print('pos id in deals ids:',sum(1 for r in pos if r[1] in alldeals))
# deals 'in' con commento per (symbol,vol,price,time)
din={}
for d in alldeals.values():
    if d[4]=='in': din[(d[2],d[3],f(d[5]),f(d[6]),d[0])]=d
hit=0
for r in pos:
    if (r[2],r[3],f(r[4]),f(r[5]),r[0]) in din: hit+=1
print('pos matched to IN deal by exact key:',hit)
def comm_of(r):
    o=allord.get(r[1])
    if o and o[11]: return o[11]
    d=din.get((r[2],r[3],f(r[4]),f(r[5]),r[0]))
    if d and d[13]: return d[13]
    return ''
def fam(c):
    if not c: return '(senza commento)'
    if 'CID=' in c: return 'ARENA (FinlabX/CF/DZR)'
    c0=re.sub(r'\d{5,}','#',c)
    c0=re.sub(r' ?(L|TP)\d$','',c0)
    return c0[:34]
G=[]
for r in pos:
    t0=T(r[0]);t1=T(r[8])
    G.append(dict(t0=t0,t1=t1,sym=r[2],side=r[3],vol=f(r[4]),px=f(r[5]),sl=f(r[6]),tp=f(r[7]),px1=f(r[9]),net=(f(r[10]) or 0)+(f(r[11]) or 0)+(f(r[12]) or 0),com=comm_of(r),tk=r[1]))
print('chiusure',min(g['t1'] for g in G),max(g['t1'] for g in G),'aperture',min(g['t0'] for g in G),max(g['t0'] for g in G))
tot=sum(g['net'] for g in G); print('TOT netto posizioni',round(tot,2),'n',len(G),'lotti',round(sum(g['vol'] for g in G),2))
agg=collections.defaultdict(lambda:[0,0.0,0.0,0.0,0.0,0,0,0])
for g in G:
    a=agg[fam(g['com'])]; a[0]+=1; a[1]+=g['net']; a[2]+=g['vol']; a[3]=max(a[3],g['vol']); a[4]=min(a[4],g['net']); a[5]+=1 if g['sl'] else 0; a[6]+=1 if g['tp'] else 0; a[7]+=1 if g['net']>0 else 0
print('%-36s %4s %10s %7s %6s %9s %5s %5s %5s'%('EA/commento','n','netto','lotti','maxlot','peggiore','conSL','conTP','vinte'))
for k,a in sorted(agg.items(),key=lambda kv:-kv[1][1]): print('%-36s %4d %10.2f %7.2f %6.2f %9.2f %5d %5d %5d'%(k,a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]))
print('--- i 12 lotti piu grandi')
for g in sorted(G,key=lambda g:-g['vol'])[:12]: print(g['t0'],g['sym'],g['side'],g['vol'],'netto',round(g['net'],2),'SL',g['sl'],'|',g['com'][:50])
print('=== CID=842478')
cb=[g for g in G if 'CID=842478' in g['com']]
for g in sorted(cb,key=lambda g:g['t0']): print(g['t0'].strftime('%d %H:%M:%S'),g['side'],g['vol'],'px',g['px'],'->',g['px1'],g['t1'].strftime('%H:%M:%S'),'net',round(g['net'],2),g['com'][:30])
print('n',len(cb),'netto',round(sum(g['net'] for g in cb),2),'lotti',round(sum(g['vol'] for g in cb),2))
# tutti gli ordini col CID 842478 (anche cancellati)
oc=[o for o in allord.values() if o[11] and 'CID=842478' in o[11]]
print('ordini CID',len(oc)); 
for o in sorted(oc,key=lambda o:o[0])[:60]: print(o[0],o[3],o[4],o[5],o[9],o[11][:34])
print('=== GBPCAD 0.14')
for g in G:
    if g['sym']=='GBPCAD' and g['vol']==0.14: print(g)
for o in allord.values():
    if o[2]=='GBPCAD' and o[0].startswith('2026.10.14 20:00'): print(o[:12])
print('=== flottante stimato del cesto CID 842478 agli istanti di ingresso (k=89.36 EUR per 1 USD x 1 lotto; limite inferiore del flottante vero perche usa il prezzo d ingresso dell ultimo livello)')
ev=sorted(cb,key=lambda g:g['t0'])
worst=(0,None)
for g in ev:
    t=g['t0']; p=g['px']
    live=[x for x in cb if x['t0']<=t and x['t1']>t]
    fl=sum(x['vol']*(x['px']-p) for x in live)*89.36
    lots=sum(x['vol'] for x in live)
    if fl<worst[0]: worst=(fl,(t,p,lots,len(live)))
    if g['vol']>=0.11: print(t.strftime('%H:%M:%S'),'p',p,'lotti vivi',round(lots,2),'posizioni',len(live),'flottante stimato',round(fl,1))
print('peggiore',worst)
print('=== senza commento per simbolo')
nc=[g for g in G if not g['com']]
c=collections.defaultdict(lambda:[0,0.0,0.0])
for g in nc: a=c[g['sym']]; a[0]+=1; a[1]+=g['net']; a[2]+=g['vol']
for k,a in c.items(): print(k,a[0],round(a[1],2),round(a[2],2))
print('aperture min/max senza commento',min(g['t0'] for g in nc),max(g['t0'] for g in nc))
# nostre
print('=== nostre')
for g in G:
    if re.search(r'EMA200|LARRY|BULGE|MAXMIN|Bulge|AZZURRA|NatCla|ABTG|CLAU12',g['com']): print(g['t0'].strftime('%d %H:%M'),g['sym'],g['side'],g['vol'],round(g['net'],2),'SL',g['sl'],'TP',g['tp'],g['com'][:40])
# stat conto: saldo inizio/fine da deals
dd=sorted([d for d in deals],key=lambda d:d[0]); print('saldo primo',dd[0][12],dd[0][0],'ultimo',dd[-1][12],dd[-1][0])
bal=[f(d[12]) for d in dd if f(d[12]) is not None]; pk=-1;mdd=0
for b in bal: pk=max(pk,b); mdd=max(mdd,pk-b)
print('DD di saldo max nella finestra',round(mdd,2),round(100*mdd/pk,2),'%')
print('=== max lotto Arena per giorno di apertura ordine (ordini con CID, riempiti)')
mx=collections.defaultdict(float)
for o in allord.values():
    if o[11] and 'CID=' in o[11] and o[9]=='filled':
        v=f(str(o[4]).split('/')[0]); d=o[0][:10]
        mx[d]=max(mx[d],v)
print(dict(mx))
for g in G:
    if g['sym'] in('EURNZD','GBPCAD') and g['vol']==0.14: print(g['sym'],g['side'],g['px'],g['sl'],g['tp'],g['vol'],round(g['net'],2),g['com'])
