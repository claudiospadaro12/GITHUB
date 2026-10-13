# Analisi descrittiva (sola lettura) dei cesti con commento "[CID=n]" in un ReportHistory MT5 (xlsx): python3 -I backtest_pipeline/analisi_cesti_commento_cid.py <file.xlsx>
# NON passata dal cancello come strumento: e un appoggio della scheda MARKET_MOTORE_FINLABX; i numeri vanno riverificati con natura_motore_da_storico.py
import openpyxl,re,collections,statistics as st,datetime as dt
wb=openpyxl.load_workbook(__import__('sys').argv[1],data_only=True)
rows=list(wb.active.iter_rows(values_only=True))
sect=None; pos=[]; orders={}
for r in rows:
    if r and r[0] in ('Posizioni','Ordini','Affari','Risultati') and all(c is None for c in r[1:]): sect=r[0]; continue
    if not r or r[0] is None or r[0] in ('Ora','Orario di Apertura'): continue
    if sect=='Posizioni' and isinstance(r[1],int): pos.append(r)
    if sect=='Ordini' and isinstance(r[1],int): orders[r[1]]=r
def f(x):
    try: return float(str(x).replace(' ',''))
    except: return None
def T(s): return dt.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
G=[]
for p in pos:
    o=orders.get(p[1]); c=o[11] if o else None
    if not c or 'CID=' not in c: continue
    m=re.search(r'^(\w+) (\w+) .*?\[CID=(\d+)\]|^(\w+) (\w) \[(\w)\] \[CID=(\d+)\]',c)
    cid=int(re.search(r'CID=(\d+)',c).group(1))
    mod='R' if '[R]' in c else 'F'
    name=c.split(' ')[0]
    side='buy' if p[3]=='buy' else 'sell'
    G.append(dict(cid=cid,mod=mod,name=name,side=side,vol=f(p[4]),px=f(p[5]),sl=f(p[6]),tp=f(p[7]),t0=T(p[0]),t1=T(p[8]),px1=f(p[9]),net=(f(p[12]) or 0)+(f(p[10]) or 0)+(f(p[11]) or 0),otype=(o[3] if o else None),oplace=T(o[0]) if o else None,oprice=f(o[5]) if o else None,comment=c))
print(len(G))
# ordini tipi per modulo
print(collections.Counter((g['name'],g['mod'],g['otype']) for g in G))
# attesa ordine pendente (placement -> fill)
for key in [('CF','F'),('FinlabX','F'),('FinlabX','R'),('DZR','F')]:
    w=[(g['t0']-g['oplace']).total_seconds() for g in G if (g['name'],g['mod'])==key]
    print(key,'attesa pendente (s) mediana',st.median(w),'p90',sorted(w)[int(len(w)*.9)])
# R: per CID e lato, sequenza dei livelli
bycid=collections.defaultdict(list)
for g in G: bycid[(g['cid'],g['side'])].append(g)
steps=[];lots=collections.defaultdict(list);gaps=[]
for k,L in bycid.items():
    R=sorted([g for g in L if g['mod']=='R'],key=lambda g:g['t0'])
    for i,g in enumerate(R):
        lots[i+1].append(g['vol'])
        if i>0:
            d=(R[i-1]['px']-g['px']) if g['side']=='buy' else (g['px']-R[i-1]['px'])
            steps.append(d); gaps.append((g['t0']-R[i-1]['t0']).total_seconds()/60)
print('R passo (USD, + = a prezzo peggiore) mediana',round(st.median(steps),2),'p10',round(sorted(steps)[int(len(steps)*.1)],2),'p90',round(sorted(steps)[int(len(steps)*.9)],2),'n',len(steps))
print('R minuti fra livelli mediana',round(st.median(gaps),1))
for i in range(1,12):
    if lots[i]: print('livello',i,'lotto mediano',st.median(lots[i]),'min-max',min(lots[i]),max(lots[i]),'n',len(lots[i]))
# F: passo fra F consecutivi a favore e attesa
for key in ['CF','FinlabX','DZR']:
    fl=[]
    for k,L in bycid.items():
        Fs=sorted([g for g in L if g['mod']=='F' and g['name']==key],key=lambda g:g['t0'])
        for i in range(1,len(Fs)):
            d=(Fs[i]['px']-Fs[i-1]['px']) if Fs[i]['side']=='buy' else (Fs[i-1]['px']-Fs[i]['px'])
            fl.append(d)
    if fl: print('F',key,'delta prezzo fra ingressi consecutivi (+ = a favore)',round(st.median(fl),2),'p10',round(sorted(fl)[int(len(fl)*.1)],2),'p90',round(sorted(fl)[int(len(fl)*.9)],2),'n',len(fl))
# TP F distanza
print('F TP distanza',collections.Counter(round(abs(g['tp']-g['px']),2) for g in G if g['mod']=='F' and g['tp']).most_common(4))
# chiusura cesto R: gruppi per (cid,side,t1 arrotondato al secondo)
gr=collections.defaultdict(list)
for g in G:
    if g['mod']=='R': gr[(g['cid'],g['side'],g['t1'])].append(g)
big=[(k,L) for k,L in gr.items() if len(L)>=3]
print('chiusure di cesto [R] con >=3 posizioni insieme',len(big),'su gruppi',len(gr))
res=[]
for k,L in big:
    net=sum(g['net'] for g in L); lots_=sum(g['vol'] for g in L)
    # motivo: px1 vs sl
    slhit=sum(1 for g in L if g['sl'] and abs(g['px1']-g['sl'])<0.011)
    res.append((net,lots_,len(L),slhit))
print('netto cesto mediana',round(st.median([r[0] for r in res]),2),'min',round(min(r[0] for r in res),2),'max',round(max(r[0] for r in res),2))
print('cesti chiusi a SL (tutte)',sum(1 for r in res if r[3]==r[2]),'su',len(res),' | chiusi con profitto>0',sum(1 for r in res if r[0]>0))
# profitto in USD per lotto: prezzo medio ponderato
usd=[]
for k,L in big:
    v=sum(g['vol'] for g in L)
    wavg=sum(g['px']*g['vol'] for g in L)/v
    exitp=st.mean(g['px1'] for g in L)
    usd.append((exitp-wavg) if L[0]['side']=='buy' else (wavg-exitp))
print('uscita vs prezzo medio ponderato (USD, + = profitto sul prezzo medio): mediana',round(st.median(usd),2),'p10',round(sorted(usd)[int(len(usd)*.1)],2),'p90',round(sorted(usd)[int(len(usd)*.9)],2))
# rapporto SL comune
cnt=0
for k,L in big:
    sl=set(g['sl'] for g in L if g['sl'])
    cnt+= (len(sl)==1)
print('cesti con UN solo valore di SL',cnt,'su',len(big))
# livelli massimi
mx=collections.Counter(max(1,len([g for g in L if g['mod']=='R'])) for L in bycid.values() if any(g['mod']=='R' for g in L))
print('profondita (n. R per cid/lato):',sorted(mx.items()))

print("=== per profondita del recupero (R per cid/lato)")
b=collections.defaultdict(lambda:[0,0.0,0.0,0,0.0])
for k,L in bycid.items():
    R=[g for g in L if g['mod']=='R']
    if not R: continue
    d=len(R); key='1' if d==1 else '2' if d==2 else '3-4' if d<=4 else '5-9' if d<=9 else '>=10'
    net=sum(g['net'] for g in R)
    lots_=sum(g['vol'] for g in R)
    t=max(g['t1'] for g in R)-min(g['t0'] for g in R)
    b[key][0]+=1; b[key][1]+=net; b[key][2]=max(b[key][2],lots_); b[key][3]+= (net<0); b[key][4]=max(b[key][4],t.total_seconds()/3600)
for k in ['1','2','3-4','5-9','>=10']:
    if k in b: n,net,ml,neg,hh=b[k]; print(k,'cesti',n,'netto R',round(net,2),'lotti max',round(ml,2),'in perdita',neg,'durata max h',round(hh,1))
