#!/usr/bin/env python3
# ---------------------------------------------------------------------------
# SONDA DI CONTEGGIO ESTERNA -- DECOMPOSIZIONE NOTTE / GIORNO su INDICI
#
# Nata il 12/09/2026 nella SECONDA CACCIA sui motori bocciati (regola 19/08).
# Dossier: report/SECONDA_CACCIA_2026-09-12.md
#
# COSA MISURA
#   (a) COLLAUDO DELL'OROLOGIO -- si fa PRIMA di leggere qualunque altro
#       numero (regola di casa, lezione del 10/09). Il minuto file a piu'
#       alta |variazione| media M1 DEVE cadere sull'apertura del cash.
#       ATTENZIONE: si contano solo i minuti con n >= 500 osservazioni.
#       Senza quella soglia la prima stesura di questa sonda indicava
#       "18:00" e "02:00" con n=5 e n=8, cioe' rumore -- il collaudo
#       certificava il falso. Difetto trovato e corretto lo stesso giorno.
#   (b) rendimento CHIUSURA->APERTURA ("notte") e APERTURA->CHIUSURA
#       ("giorno") della sessione cash, in punti indice e in percento,
#       totale e ANNO PER ANNO. Sono le due gambe della stessa giornata:
#       e' un CONTROLLO APPAIATO (regola del 05/09), non due campioni.
#   (c) la CODA AVVERSA delle notti: p01/p05 e quante notti stanno sotto
#       -1/-2/-3 per cento. Serve al rischio prop: un GAP SALTA LO STOP,
#       quindi la coda non e' un dettaglio, e' il verdetto.
#
# COSA NON MISURA
#   Non e' BCM: altri orari, altri spread, altri gap. Zero costi e zero
#   slippage dentro la sonda: il costo si aggiunge DOPO, con gli spread
#   orari MISURATI in risultati_archivio/spread_flotta/. Nessun numero di
#   qui e' un verdetto (LEGGIMI.md, limiti 1-6).
#
# FONTE DATI: github FutureSharks/financial-data (histdata M1, GPL-3.0),
#   pyfinancialdata/data/stocks/histdata/<SYM>/DAT_ASCII_<SYM>_M1_<ANNO>.csv
#   OROLOGIO: ora file + 5 = ora server BCM (ricollaudato qui, vedi (a)).
#   >>> 2019 e 2020 NON ESISTONO in quella cartella: 404 VERIFICATO il
#       12/09/2026 su entrambi i simboli e su entrambi gli anni. E' un 404,
#       non un 503: la finestra COVID si misura con la cartella Oanda, ed e'
#       quello che fa sonda_notte_giorno_2020.py.
#
# CORSA DEL 12/09/2026 (i numeri del dossier vengono da questa):
#   GRXEUR anni 2010-2018 (9 file) -> 1.718.805 barre M1, 2.054 sedute
#   SPXUSD anni 2010-2018 (9 file) -> 2.117.667 barre M1, 2.077 sedute
#   NB: i file 2010 coprono solo da meta' novembre (n=32/33 sedute).
#
# USO: i CSV vanno in ./dati/<SYM>_<ANNO>.csv ; poi  python3 sonda_notte_giorno.py
# ---------------------------------------------------------------------------
import os, sys, glob
from collections import defaultdict
from statistics import mean, median, pstdev

SESSIONE_FILE = {'GRXEUR': (3, 0, 11, 30), 'SPXUSD': (9, 30, 16, 0)}

def load(sym):
    bars=[]
    for p in sorted(glob.glob(f'dati/{sym}_*.csv')):
        for line in open(p):
            line=line.strip()
            if not line: continue
            q=line.split(';')
            if len(q)<5: continue
            ts=q[0]
            bars.append((ts[0:8], int(ts[9:11]), int(ts[11:13]),
                         float(q[1]), float(q[2]), float(q[3]), float(q[4])))
    return bars

def collaudo(bars):
    agg=defaultdict(list)
    prev=None
    for b in bars:
        if prev is not None and prev[0]==b[0]:
            agg[(b[1],b[2])].append(abs(b[6]-prev[6]))
        prev=b
    top=sorted([kv for kv in agg.items() if len(kv[1])>=500], key=lambda kv:-mean(kv[1]))[:4]
    return [(f'{h:02d}:{m:02d}', round(mean(v),3), len(v)) for (h,m),v in top]

def sessioni(bars, sym):
    oh,om,ch,cm = SESSIONE_FILE[sym]
    lo=oh*60+om; hi=ch*60+cm
    byday=defaultdict(list)
    for b in bars:
        t=b[1]*60+b[2]
        if lo<=t<=hi: byday[b[0]].append(b)
    out=[]
    for d in sorted(byday):
        v=byday[d]
        if len(v)<60: continue          # giornata mozza: fuori
        out.append((d, v[0][3], v[-1][6], min(x[5] for x in v), max(x[4] for x in v)))
    return out

for sym in ('GRXEUR','SPXUSD'):
    bars=load(sym)
    if not bars: print(sym,'NESSUN DATO'); continue
    print('='*78)
    print(sym, ' barre M1:', len(bars))
    print(' COLLAUDO OROLOGIO (minuto file a piu alta |var| media M1):', collaudo(bars))
    S=sessioni(bars,sym)
    print(' sedute usate:', len(S), ' dal', S[0][0], 'al', S[-1][0])
    notte=[]; giorno=[]
    for i in range(1,len(S)):
        pc=S[i-1][2]; o=S[i][1]; c=S[i][2]
        notte.append((S[i][0], o-pc, (o-pc)/pc*100.0))
        giorno.append((S[i][0], c-o, (c-o)/o*100.0))
    def riga(nome, xs):
        pt=[x[1] for x in xs]; pc=[x[2] for x in xs]
        m=mean(pt); s=pstdev(pt)
        t=m/(s/len(pt)**0.5) if s else 0.0
        print(f'  {nome:9s} n={len(xs):5d}  media={m:+7.3f} pt  mediana={median(pt):+7.3f}  '
              f'media%={mean(pc):+8.5f}  t={t:+5.2f}  %pos={100*sum(1 for x in pt if x>0)/len(pt):5.1f}  sigma%={pstdev(pc):.4f}')
    riga('NOTTE', notte); riga('GIORNO', giorno)
    print('  --- per ANNO (media % per notte / per giorno, e peggior gap notturno) ---')
    for y in sorted({x[0][:4] for x in notte}):
        nn=[x for x in notte if x[0][:4]==y]; gg=[x for x in giorno if x[0][:4]==y]
        worst=min(nn, key=lambda x:x[2])
        print(f'   {y}  n={len(nn):4d}  notte={mean([x[2] for x in nn]):+8.5f}%  '
              f'giorno={mean([x[2] for x in gg]):+8.5f}%  '
              f'notti>0={100*sum(1 for x in nn if x[1]>0)/len(nn):5.1f}%  '
              f'peggior_gap={worst[2]:+6.2f}% ({worst[0]})')
    print('  --- CODA AVVERSA DELLE NOTTI (rischio prop: il gap SALTA lo stop) ---')
    neg=sorted([x[2] for x in notte])
    for q,lab in ((0.01,'p01'),(0.05,'p05')):
        print(f'   {lab} del rendimento notturno = {neg[int(q*len(neg))]:+6.2f}%')
    for s in (1.0,2.0,3.0):
        k=sum(1 for x in notte if x[2]<=-s)
        print(f'   notti con gap <= -{s:.1f}% : {k:4d} su {len(notte)}  ({100*k/len(notte):.2f}%)  '
              f'= una ogni {len(notte)/k:.0f} notti' if k else
              f'   notti con gap <= -{s:.1f}% : 0')
