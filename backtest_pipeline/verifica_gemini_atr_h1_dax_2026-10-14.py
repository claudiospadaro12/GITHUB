# -*- coding: ascii -*-
"""BOZZA NON PASSATA DAL CANCELLO (14/10/2026): verifica a costo zero delle risposte di Gemini sull'ATR H1 DAX.
Solo lettura, esegue dalla radice del repo: python3 -I backtest_pipeline/verifica_gemini_atr_h1_dax_2026-10-14.py
(1) ATR di Wilder contro media semplice, stessa serie e stessa finestra del lettore; (2) per ogni giorno feriale la
barra (6-10 server) col massimo salto del tick_volume e dell'escursione sulla barra prima (sonda GREZZA: NON e' il
metodo del collaudo, serve a vedere se il 2024/25 e' un blocco con una data o un'alternanza giorno per giorno).
Non e' uno strumento di misura per verdetti: se un numero entra in un verdetto va rifatto con strumento passato dal cancello.
Sezioni (C1)-(C3) aggiunte dal controllo-preventivo il 14/10/2026: contro-esempi (lettura SINGOLA in 37-40 con SMA e Wilder;
salto ASSOLUTO del tick_volume, metrica scelta DOPO i numeri; ancora USA dal Dow H1 gia' in archivio). I numeri principali sono
stati ricalcolati dal cancello con codice indipendente (parser e ATR propri, senza importare lettore e collaudo): coincidono."""
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
# ---- AGGIUNTE DEL CANCELLO (controllo-preventivo, 14/10/2026): contro-esempi alle conclusioni della verifica.
# Anche queste sono sonde GREZZE; la metrica del salto ASSOLUTO e' scelta DOPO aver visto i numeri: descrive, non giudica,
# e non puo' ribaltare il verdetto del collaudo (orologio 2024/25 NON CONFERMATO resta com'e').
print('--- (C1) lettura SINGOLA nella banda 37-40: quota delle barre E2 (chiuse 07:00 e 08:00 IT) con ATR in [37;40]')
def e2_chiuse(t):
    return (6, 7) if C.ora_legale_eu(t.date()) else (7, 8)
for nome_f, a0, a1 in (('24 mesi', dt.datetime(2024,9,26), dt.datetime(2026,10,1)), ('set-ott 2026 (estate, orologio CONFERMATO)', dt.datetime(2026,9,1), dt.datetime(2026,10,14))):
    ii=[i for i,b in enumerate(barre) if sma[i] is not None and w[i] is not None and a0<=b[0]<a1 and b[0].weekday()<5 and b[0].hour in e2_chiuse(b[0])]
    for nome,a in (('SMA',sma),('Wilder',w)):
        v=[a[i] for i in ii]
        print(nome_f,nome,'n',len(v),'mediana %.2f'%statistics.median(v),'in [37;40]: %d (%.1f%%)'%(sum(37<=x<=40 for x in v),100.0*sum(37<=x<=40 for x in v)/len(v)),'<=40: %.1f%%'%(100.0*sum(x<=40 for x in v)/len(v)))
    print(nome_f,'Wilder < SMA sulle barre E2: %.1f%%'%(100.0*sum(w[i]<sma[i] for i in ii)/len(ii)))
print('--- (C1b) ultime mattine nel file (barre 06 e 07 server, estate)')
for i,b in enumerate(barre):
    if b[0]>=dt.datetime(2026,10,5) and b[0].hour in (6,7):
        print(b[0].strftime('%Y.%m.%d %H:%M'),'SMA %.2f Wilder %.2f'%(sma[i],w[i]))
print('--- (C2) Q3: argmax giornaliero del salto ASSOLUTO del tick_volume (6-10) e mediane del tick_volume per ora')
for nome,a,b in (('INV24/25',dt.date(2024,10,28),dt.date(2025,3,28)),('INV25/26',dt.date(2025,10,27),dt.date(2026,3,27))):
    gg=[d for d in giorni if a<=d<=b and d.weekday()<5]
    cnt=collections.Counter()
    for d in gg:
        hh=giorni[d]; best=None
        for h in range(6,11):
            if h in hh and h-1 in hh:
                r=hh[h][5]-hh[h-1][5]
                if best is None or r>best[1]: best=(h,r)
        if best: cnt[best[0]]+=1
    med={h:statistics.median([giorni[d][h][5] for d in gg if h in giorni[d]]) for h in range(6,11)}
    print(nome,'giorni',len(gg),'argmax salto assoluto:',dict(sorted(cnt.items())),'| mediane tick_volume:',dict((h,int(med[h])) for h in sorted(med)))
    # test delle successioni sulla sequenza del salto RELATIVO (solo giorni 08/09): alternanza o caso?
    s=[]
    for d in sorted(gg):
        hh=giorni[d]; best=None
        for h in range(6,11):
            if h in hh and h-1 in hh and hh[h-1][5]>0:
                r=hh[h][5]/hh[h-1][5]
                if best is None or r>best[1]: best=(h,r)
        if best and best[0] in (8,9): s.append(best[0])
    n1=s.count(8); n2=s.count(9); n=n1+n2; runs=1+sum(1 for k in range(1,n) if s[k]!=s[k-1])
    er=1+2.0*n1*n2/n; vr=2.0*n1*n2*(2*n1*n2-n)/(n*n*(n-1))
    z=(runs-er)/vr**0.5
    print(nome,'successioni (relativo, 08/09):',runs,'attese %.1f, z %.2f ->'%(er,z),'compatibile col caso (nessuna alternanza regolare)' if abs(z)<2 else ('PIU\' successioni del caso (alternanza)' if z>0 else 'MENO successioni del caso (giorni raggruppati)'))
print('--- (C3) ancora USA gia\' in archivio: Dow H1 (U30USD), argmax giornaliero del salto 12-17 server, settimane US senza ora legale')
dow=open('backtest_pipeline/risultati_archivio/EXPORT_BARRE_DOW_H1_20261011/U30USD_H1_91fbb7cf1900.csv',encoding='utf-8').read()
gd=collections.defaultdict(dict)
for ln in dow.splitlines():
    if not ln or ln[0] in '#t': continue
    f=ln.split(';')
    t=dt.datetime.strptime(f[0],'%Y.%m.%d %H:%M'); gd[t.date()][t.hour]=int(f[5])
for nome,a,b in (('INV_USA24/25',dt.date(2024,11,4),dt.date(2025,3,7)),('INV_USA25/26',dt.date(2025,11,3),dt.date(2026,3,6))):
    cr=collections.Counter(); ca=collections.Counter()
    for d in gd:
        if not (a<=d<=b) or d.weekday()>=5: continue
        hh=gd[d]; br=None; ba=None
        for h in range(12,18):
            if h in hh and h-1 in hh and hh[h-1]>0:
                if br is None or hh[h]/hh[h-1]>br[1]: br=(h,hh[h]/hh[h-1])
                if ba is None or hh[h]-hh[h-1]>ba[1]: ba=(h,hh[h]-hh[h-1])
        if br: cr[br[0]]+=1; ca[ba[0]]+=1
    print(nome,'(attesa UTC+1 fisso: barra 15) relativo:',dict(sorted(cr.items())),'| assoluto:',dict(sorted(ca.items())))
