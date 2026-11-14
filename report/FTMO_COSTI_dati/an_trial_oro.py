import openpyxl, statistics as st, collections
wb=openpyxl.load_workbook('t.xlsx',read_only=True,data_only=True)
rows=list(wb.worksheets[0].iter_rows(values_only=True))
idx={r[0]:i for i,r in enumerate(rows) if isinstance(r[0],str) and r[0] in('Posizioni','Ordini','Affari','Ordini attivi','Risultati')}
print(idx)
P=[r for r in rows[idx['Posizioni']+2:idx['Ordini']] if isinstance(r[0],str) and r[0][:4]=='2026']
O=[r for r in rows[idx['Ordini']+2:idx.get('Affari',len(rows))] if isinstance(r[0],str) and r[0][:4]=='2026']
print('posizioni',len(P),'ordini',len(O))
sym=collections.defaultdict(lambda:[0,0.0,0.0,0.0,0.0])
for p in P:
    s=sym[p[2]]; s[0]+=1; s[1]+=float(p[4]); s[2]+=p[10]; s[3]+=p[11]; s[4]+=p[12]
for k,v in sym.items(): print(k,'n',v[0],'lotti',round(v[1],2),'comm',round(v[2],2),'comm/lotto',round(v[2]/v[1],2) if v[1] else None,'swap',round(v[3],2),'profitto',round(v[4],2))
# oro
G=[p for p in P if p[2]=='XAUUSD']
byid={}
for o in O: byid.setdefault(o[1],o)
# entrate con ordine pendente
ent=[];ext=[]
tot_lots=0
for p in G:
    o=byid.get(p[1]); typ=p[3]; lots=float(p[4])
    if o and isinstance(o[5],(int,float)) and 'limit' in str(o[3]) or (o and 'stop' in str(o[3]) and isinstance(o[5],(int,float))):
        req=o[5]; d=(p[5]-req) if typ=='buy' else (req-p[5]); ent.append((str(o[3]),d,lots))
    sl=p[6]; tp=p[7]; cp=p[9]
    # classifica uscita dal commento dell'ordine di chiusura: cerchiamo ordine di chiusura
print('entrate oro con ordine pendente:',len(ent))
import math
def stats(v): 
    v=sorted(v); n=len(v)
    return n, round(sum(v)/n,3), round(st.median(v),3), v[0], v[-1], round(v[int(0.9*(n-1))],3)
if ent:
    byt=collections.defaultdict(list)
    for t,d,l in ent: byt[t].append(d)
    for t,v in byt.items(): print('entrata',t,stats(v))
    wl=sum(d*l for t,d,l in ent)/sum(l for t,d,l in ent)
    print('slip medio ponderato lotti (USD/oncia):',round(wl,3),' = USD/lotto',round(wl*100,1))
# uscite: ordini di chiusura con commento [sl X] / [tp X]
close=[o for o in O if isinstance(o[11],str) and ('[sl' in o[11] or '[tp' in o[11]) and o[2]=='XAUUSD']
print('ordini di chiusura sl/tp oro:',len(close))
pidx={}
for p in G: pidx.setdefault((p[8],),[]).append(p)
res=collections.defaultdict(list)
for o in close:
    kind='sl' if '[sl' in o[11] else 'tp'
    # trova posizione chiusa a quell'ora con volume uguale (lato opposto)
    cands=[p for p in G if p[8]==o[8] and abs(float(p[4])-float(str(o[4]).split('/')[0]))<1e-9]
    trig=o[5]
    if not cands: continue
    p=cands[0]; typ=p[3]; cp=p[9]
    # per buy chiuso con sell sl: contro = trig-cp (>0) ; tp: a favore = cp-trig
    if typ=='buy': d=(trig-cp)
    else: d=(cp-trig)
    res[kind].append((d,float(p[4])))
for k,v in res.items():
    ds=[d for d,l in v]; print('uscita',k,stats(ds),'ponderato USD/lotto',round(100*sum(d*l for d,l in v)/sum(l for d,l in v),1))

print('\n--- dettaglio')
import datetime as dt
def d(s): return dt.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
rowsE=[]
for p in G:
    o=byid.get(p[1]); typ=p[3]; lots=float(p[4]); req=o[5]
    s=(p[5]-req) if typ=='buy' else (req-p[5])
    rowsE.append((d(p[0]),lots,s,str(o[3])))
by_day=collections.defaultdict(lambda:[0,0.0,0.0])
for t,l,s,k in rowsE:
    x=by_day[t.date()]; x[0]+=1; x[1]+=l; x[2]+=s*l
for k,v in sorted(by_day.items()): print(k,'n',v[0],'lotti',round(v[1],2),'slip ponderato USD/oncia',round(v[2]/v[1],3))
# per fascia oraria server
by_h=collections.defaultdict(list)
for t,l,s,k in rowsE: by_h[t.hour].append(s)
for h,v in sorted(by_h.items()): print('ora',h,'n',len(v),'media',round(sum(v)/len(v),3))
print('mediana tutte entrate',round(st.median([s for _,_,s,_ in rowsE]),3),'media',round(sum(s for _,_,s,_ in rowsE)/len(rowsE),3))
# swap per lotto-notte (rollover = cambio data server; mercoledi x3)
tn=0;tl=0
for p in G:
    a=d(p[0]);b=d(p[8]); n=0; x=a.date()
    while x<b.date():
        x+=dt.timedelta(days=1); n+=3 if x.weekday()==3 else (0 if x.weekday() in(5,6) else 1) # notte mer->gio =3 (rollover del mercoledi)
    tn+=n*float(p[4])
sw=sum(p[11] for p in G)
print('swap totale',round(sw,2),'lotti-notte (ipotesi triplo mercoledi)',round(tn,2),'swap per lotto-notte',round(sw/tn,2) if tn else None)
print('posizioni con swap!=0',sum(1 for p in G if p[11]!=0),'di',len(G))
