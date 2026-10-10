#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_GBA_FRONTIERA_TF_PROXY_v1 (10/10/2026)
# PROXY (NON e' il feed BCM, NON e' il tester): frontiera del costo `stop >= 40 x costo` dell'oro per TF (M1, M3, M5, M15), stop = 2,5 x ATR(14) del TF,
# costo = spread vivo BCM per ora server (logger di settembre, data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv, ora 22 = 0,25 [ASSUNZIONE: non e' nel
# logger]) + commissione 0,04 USD/oz a giro. Barre: HistData M1 (backtest_pipeline/risultati_prove/oro_m1_histdata_zip), New York -> UTC -> +1 h = server BCM.
# Finestra: 2026-01-01 .. 2026-09-18. Segnali = canale di 48 barre del TF (esclusa la barra di segnale) + EMA100 dello stesso TF, SENZA filtri e SENZA la regola
# "una posizione per volta": il conto serve alla FRONTIERA del costo, non a stimare n. STATO: strumento di analisi, NON passato dal cancello.
# USO: python3 -I backtest_pipeline/gba_frontiera_tf_proxy.py
import sys, zipfile, glob, os, statistics as st, collections, datetime as dt
from zoneinfo import ZoneInfo
ZD=os.path.join(os.path.dirname(os.path.abspath(__file__)),'risultati_prove','oro_m1_histdata_zip')
NY=ZoneInfo("America/New_York"); UTC=dt.timezone.utc
rows=[]
for z in sorted(glob.glob(os.path.join(ZD,"*.zip"))):
    zf=zipfile.ZipFile(z); n=[x for x in zf.namelist() if x.endswith(".csv")][0]
    for ln in zf.read(n).decode("ascii").splitlines():
        p=ln.split(";")
        t=dt.datetime.strptime(p[0],"%Y%m%d %H%M%S").replace(tzinfo=NY)
        rows.append((int(t.astimezone(UTC).timestamp())+3600,float(p[1]),float(p[2]),float(p[3]),float(p[4])))
rows.sort()
ded=[]
for r in rows:
    if ded and ded[-1][0]==r[0]: continue
    ded.append(r)
rows=ded
print('barre',len(rows))
SPR={0:.27,1:.27,2:.27,3:.26,4:.26,5:.25,6:.27,7:.21,8:.21,9:.20,10:.20,11:.21,12:.20,13:.21,14:.21,15:.18,16:.18,17:.20,18:.20,19:.21,20:.20,21:.22,22:.25,23:.27}
COMM=0.04
def aggrega(bars,sec):
    out=[]
    for t,o,h,l,c in bars:
        b=t-t%sec
        if out and out[-1][0]==b:
            x=out[-1]; out[-1]=(b,x[1],max(x[2],h),min(x[3],l),c)
        else: out.append((b,o,h,l,c))
    return out
def atr_series(bars,per=14):
    out=[];trs=[]
    for i,(t,o,h,l,c) in enumerate(bars):
        tr=h-l if i==0 else max(h-l,abs(h-bars[i-1][4]),abs(l-bars[i-1][4]))
        trs.append(tr)
        out.append(sum(trs[-per:])/per if len(trs)>=per else None)
    return out
t0=int(dt.datetime(2026,1,1,tzinfo=UTC).timestamp()); t1=int(dt.datetime(2026,9,19,tzinfo=UTC).timestamp())
q=lambda a,p: sorted(a)[int(p*(len(a)-1))]
for name,sec in (('M1',60),('M3',180),('M5',300),('M15',900)):
    bars=aggrega(rows,sec) if sec>60 else rows
    a=atr_series(bars)
    C=[b[4] for b in bars]; k=2.0/101.0; e=None; em=[]
    for c in C:
        e=c if e is None else e+k*(c-e); em.append(e)
    # all bars in window
    sel=[i for i in range(len(bars)) if a[i] is not None and t0<=bars[i][0]<t1]
    v=[a[i] for i in sel]
    ratio=[2.5*a[i]/(SPR.get(((bars[i][0])%86400)//3600,.22)+COMM) for i in sel]
    print(f'\n{name}: ATR(14) mediana {st.median(v):.2f} p10 {q(v,.1):.2f} p90 {q(v,.9):.2f} | stop(2,5ATR)/(spread vivo+0,04) su TUTTE le barre: mediana {st.median(ratio):.1f}x, quota >=40x {100*sum(1 for r in ratio if r>=40)/len(ratio):.0f}%, quota <13,3x {100*sum(1 for r in ratio if r<13.3)/len(ratio):.0f}%')
    # raw breakout signals channel 48 bars of the TF + EMA100 same TF
    N=48; sig=[]
    for i in range(N+1,len(bars)):
        if not (t0<=bars[i][0]<t1) or a[i] is None: continue
        hh=max(b[2] for b in bars[i-N:i]); ll=min(b[3] for b in bars[i-N:i]); c=bars[i][4]
        if (c>hh and c>em[i]) or (c<ll and c<em[i]): sig.append(i)
    days=len({bars[i][0]//86400 for i in sel})
    rr=[2.5*a[i]/(SPR.get(((bars[i][0]+sec)%86400)//3600,.22)+COMM) for i in sig]
    r05=[i for i in sig if SPR.get(((bars[i][0]+sec)%86400)//3600,.22)<=0.05*a[i]]
    print(f'   segnali grezzi (canale 48 barre del TF + EMA100 stesso TF, senza filtri, senza regola una-posizione): {len(sig)} su {days} giorni = {len(sig)/days:.1f}/giorno')
    print(f'   ... con costo mediano stop/(spread+comm) {st.median(rr):.1f}x; >=40x: {100*sum(1 for r in rr if r>=40)/len(rr):.0f}%; <13,3x: {100*sum(1 for r in rr if r<13.3)/len(rr):.0f}%; passano la cella spread 0,05 ATR: {len(r05)} ({100*len(r05)/len(sig):.1f}%) = {len(r05)/days:.2f}/giorno')
