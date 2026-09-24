#!/usr/bin/env python3
# Nata il 24/09/2026 nella caccia Unger (pilastri 1-3):
#   backtest_pipeline/caccia_strategie/CACCIA_UNGER_INGRESSI_USCITE_FILTRI_2026-09-24.md
# DATI: github FutureSharks/financial-data (histdata M1, GPL-3.0), GRXEUR 2011-2018,
#   raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/stocks/histdata/GRXEUR/DAT_ASCII_GRXEUR_M1_<ANNO>.csv
#   da salvare come dati/GRXEUR_<ANNO>.csv. Copertura: SOLO server 07:00-21:00 (sessione FDAX), la NOTTE non c'e'.
# LIMITI: non e' BCM; OHLC M1; zero costi; misura OCCASIONI (esistenza dell'evento), MAI edge.
# Evento "prima ora" di Unger sul DAX: range 07:00-08:00 server (= 08-09 CET, prima ora del FUTURE),
# ordini nella seconda ora 08:00-09:00 server (= prima ora del CASH). Spostamento k*R oltre gli estremi.
# Misura OCCASIONI, mai edge. Orologio: file+5 = server (collaudato: picco 08:00 server).
import glob
from collections import defaultdict
from datetime import datetime, timedelta
bars=[]
for p in sorted(glob.glob('dati/GRXEUR_*.csv')):
    for line in open(p):
        q=line.strip().split(';')
        if len(q)<5: continue
        t=datetime.strptime(q[0],'%Y%m%d %H%M%S')+timedelta(hours=5)
        bars.append((t,float(q[2]),float(q[3])))
byday=defaultdict(list)
for b in bars: byday[b[0].date()].append(b)
res=defaultdict(lambda: defaultdict(int)); ng=0; nfri=0
for d in sorted(byday):
    v=byday[d]
    rng=[b for b in v if b[0].hour==7]
    if len(rng)<50: continue
    ng+=1; nfri+= (d.weekday()==4)
    H=max(b[1] for b in rng); L=min(b[2] for b in rng); R=H-L
    for k in (0.0,0.25,0.5,0.75,1.0):
        up=H+k*R; dn=L-k*R
        for lab,(a,z) in (('h08-09',(8*60,9*60)),('h08-1630',(8*60,16*60+30))):
            seg=[b for b in v if a<=b[0].hour*60+b[0].minute<z]
            hit=any(b[1]>=up or b[2]<=dn for b in seg)
            res[(k,lab)]['tot']+=hit
            if d.weekday()!=4: res[(k,lab)]['noven']+=hit
print('giornate con la prima ora (07-08 server) completa:',ng,' di cui venerdi:',nfri, ' anni:', 8)
for k in (0.0,0.25,0.5,0.75,1.0):
    print(f"k={k:.2f}  rottura entro 09:00 server: {res[(k,'h08-09')]['tot']:5d} ({100*res[(k,'h08-09')]['tot']/ng:5.1f}%)  "
          f"entro 16:30: {res[(k,'h08-1630')]['tot']:5d} ({100*res[(k,'h08-1630')]['tot']/ng:5.1f}%)  "
          f"senza venerdi, entro 09:00: {res[(k,'h08-09')]['noven']/8:.1f}/anno")
