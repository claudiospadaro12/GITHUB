# -*- coding: ascii -*-
"""BOZZA NON PASSATA DAL CANCELLO (14/10/2026): verifica a costo zero delle risposte di Gemini sull'ATR H1 DAX.
Solo lettura, esegue dalla radice del repo: python3 -I backtest_pipeline/verifica_gemini_atr_h1_dax_2026-10-14.py
(1) ATR di Wilder contro media semplice, stessa serie e stessa finestra del lettore; (2) per ogni giorno feriale la
barra (6-10 server) col massimo salto del tick_volume e dell'escursione sulla barra prima (sonda GREZZA: NON e' il
metodo del collaudo, serve a vedere se il 2024/25 e' un blocco con una data o un'alternanza giorno per giorno).
Non e' uno strumento di misura per verdetti: se un numero entra in un verdetto va rifatto con strumento passato dal cancello."""
import sys, datetime as dt, statistics, collections
sys.path.insert(0,'backtest_pipeline')
import collaudo_export_barre_dax_h1 as C
import leggi_atr_h1_dax as L
txt=open('backtest_pipeline/risultati_archivio/EXPORT_BARRE_DAX_H1_20261014/D30EUR_H1_a6e3e67227b8.csv',encoding='utf-8').read()
meta,barre,err=C.leggi(txt); print(len(barre),err[:2])
tr=L.true_range(barre)
sma,_=L.atr_mt5(barre)
# Wilder: ATR[14]=mean TR[1..14]; ATR[i]=(ATR[i-1]*13+TR[i])/14
w=[None]*len(barre); w[14]=sum(tr[1:15])/14
for i in range(15,len(barre)): w[i]=(w[i-1]*13+tr[i])/14
def sel(a):
    v=[a[i] for i,b in enumerate(barre) if a[i] is not None and dt.datetime(2024,9,26)<=b[0]<dt.datetime(2026,10,1) and b[0].weekday()<5]
    return v
for nome,a in (('SMA',sma),('Wilder',w)):
    v=sel(a); q=L.quantile
    print(nome,len(v),'mediana %.2f media %.2f p25 %.2f p75 %.2f'%(statistics.median(v),statistics.mean(v),q(v,0.25),q(v,0.75)))
# Wilder per barre chiuse 07-08 IT? orologio sospeso: stampa per ora server 6,7,8
for nome,a in (('SMA',sma),('Wilder',w)):
    for h in (6,7,8):
        v=[a[i] for i,b in enumerate(barre) if a[i] is not None and b[0].hour==h and dt.datetime(2024,9,26)<=b[0]<dt.datetime(2026,10,1) and b[0].weekday()<5]
        print(nome,'barra',h,'n',len(v),'mediana %.2f'%statistics.median(v))
# Q3: salto giornaliero tick_volume e escursione, per stagione/mese
def stag(d):
    return 'EST' if C.ora_legale_eu(d) else 'INV'
giorni=collections.defaultdict(dict)
for b in barre: giorni[b[0].date()][b[0].hour]=b
res=collections.defaultdict(lambda: collections.Counter())
rese=collections.defaultdict(lambda: collections.Counter())
for d,hh in sorted(giorni.items()):
    if d.weekday()>=5: continue
    best=None;beste=None
    for h in range(6,11):
        if h in hh and h-1 in hh and hh[h-1][5]>0:
            r=hh[h][5]/hh[h-1][5]
            if best is None or r>best[1]: best=(h,r)
        if h in hh and h-1 in hh:
            e=(hh[h][2]-hh[h][3]); e0=(hh[h-1][2]-hh[h-1][3])
            if e0>0 and (beste is None or e/e0>beste[1]): beste=(h,e/e0)
    if best: res[d.strftime('%Y-%m')][best[0]]+=1
    if beste: rese[d.strftime('%Y-%m')][beste[0]]+=1
for m in sorted(res):
    d=dt.datetime.strptime(m,'%Y-%m').date()
    print(m,stag(d.replace(day=15)),'tick_volume max-salto per ora:',dict(sorted(res[m].items())),'| escursione:',dict(sorted(rese[m].items())))
print('--- sequenza giornaliera argmax tick_volume (6-10), inverno 24/25')
seq=[]
for d,hh in sorted(giorni.items()):
    if d.weekday()>=5 or not (dt.date(2024,10,28)<=d<=dt.date(2025,3,28)): continue
    best=None
    for h in range(6,11):
        if h in hh and h-1 in hh and hh[h-1][5]>0:
            r=hh[h][5]/hh[h-1][5]
            if best is None or r>best[1]: best=(h,r)
    seq.append((d.strftime('%m%d'),best[0]))
print(' '.join('%s:%d'%x for x in seq))
# rapporto tick_volume barra 08 / barra 07 e barra 09/ barra 08, mediane per stagione
for nome,a,b in (('INV24/25',dt.date(2024,10,28),dt.date(2025,3,28)),('INV25/26',dt.date(2025,10,27),dt.date(2026,3,27))):
    r8=[];r9=[]
    for d,hh in giorni.items():
        if d.weekday()<5 and a<=d<=b and all(h in hh and hh[h][5]>0 for h in (7,8,9)):
            r8.append(hh[8][5]/hh[7][5]); r9.append(hh[9][5]/hh[8][5])
    print(nome,len(r8),'mediana tv08/tv07 %.2f  tv09/tv08 %.2f'%(statistics.median(r8),statistics.median(r9)))
