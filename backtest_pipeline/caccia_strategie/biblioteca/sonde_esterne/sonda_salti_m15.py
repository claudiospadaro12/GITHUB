#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - SALTO STATISTICO (Lee-Mykland 2008) su M15
# Fonte dati: github FutureSharks/financial-data (GPL-3.0), OHLC M1, NON BCM,
# ZERO costi, ZERO slippage. Conta OCCASIONI e misura la GEOMETRIA.
# Il MERITO non si giudica qui (F6: verdetti solo a tick reali sul nostro banco).
#
# Statistica: r(i) = log(C_i/C_{i-1}) sulle barre M15 DENTRO la stessa giornata
#             (il salto overnight NON e' un salto: e' un gap, ed e' gia' in flotta)
#             sigma^(i)^2 = 1/(K-2) * somma_{j=i-K+2..i-1} |r_j||r_{j-1}|  (bipower)
#             z(i) = |r(i)| * sqrt(2/pi) / sigma^(i)     -> z in unita' di sigma
# K = 156 barre M15 (il valore raccomandato da Lee-Mykland per dati a 15 minuti)
import os, glob, math, random, statistics as st
from collections import defaultdict

S = os.environ['S']
C = math.sqrt(2.0/math.pi)
K = 156
H = 12          # orizzonte di lettura dopo il salto: 12 barre M15 = 3 ore

# ---------- caricamento ----------
def load_histdata(paths):
    out = []
    for p in sorted(paths):
        with open(p) as f:
            for line in f:
                q = line.strip().split(';')
                if len(q) < 5: continue
                ts = q[0]
                out.append((ts[0:8], int(ts[9:11]), int(ts[11:13]),
                            float(q[1]), float(q[2]), float(q[3]), float(q[4])))
    return out

def load_oanda(paths):
    out = []
    for p in sorted(paths):
        with open(p) as f:
            first = True
            for line in f:
                if first: first = False; continue
                q = line.strip().split(',')
                if len(q) < 5: continue
                t = q[0]                       # 2016-06-01 00:01:00
                d = t[0:4]+t[5:7]+t[8:10]
                out.append((d, int(t[11:13]), int(t[14:16]),
                            float(q[4]), float(q[2]), float(q[3]), float(q[1])))
    return out

def aggregate(bars, minutes):
    out = []; cur = None
    for (d,hh,mm,o,h,l,c) in bars:
        slot = (d, hh, (mm//minutes)*minutes)
        if cur is None or cur[0] != slot:
            if cur is not None: out.append(cur[1])
            cur = (slot, [slot[0], slot[1], slot[2], o,h,l,c])
        else:
            b = cur[1]
            if h > b[4]: b[4] = h
            if l < b[5]: b[5] = l
            b[6] = c
    if cur is not None: out.append(cur[1])
    return out

def atr(bars, n=14):
    out=[None]*len(bars); trs=[]; pc=None; s=0.0
    for i,b in enumerate(bars):
        h,l,c = b[4],b[5],b[6]
        tr = h-l if pc is None else max(h-l, abs(h-pc), abs(l-pc))
        trs.append(tr); pc=c
        if i>=n: s-=trs[i-n]
        s+=tr
        if i>=n-1: out[i]=s/n
    return out

# ---------- calendario news (UTC) ----------
def load_cal(path):
    ev=set()                            # (giorno, minuto del giorno) in UTC
    with open(path) as f:
        first=True
        for line in f:
            if first: first=False; continue
            q=line.strip().split(';')
            if len(q)<4: continue
            dt=q[0]                     # 2010.01.03 15:00
            ev.add((dt[0:4]+dt[5:7]+dt[8:10], int(dt[11:13])*60+int(dt[14:16])))
    return ev

def minutes_of(d,hh,mm): return hh*60+mm

# regola DST: seconda domenica di marzo -> prima domenica di novembre (USA);
# ultima domenica di marzo -> ultima domenica di ottobre (UE). Per convertire
# l'ora di NEW YORK in UTC serve la regola USA.
import datetime
def us_dst(dstr):
    y=int(dstr[0:4]); m=int(dstr[4:6]); dd=int(dstr[6:8])
    day=datetime.date(y,m,dd)
    mar=datetime.date(y,3,1)
    start=mar+datetime.timedelta(days=(6-mar.weekday())%7+7)   # 2a domenica di marzo
    nov=datetime.date(y,11,1)
    end=nov+datetime.timedelta(days=(6-nov.weekday())%7)       # 1a domenica di novembre
    return start<=day<end

# ---------- motore ----------
def studia(nome, bars15, sess, tz, cal=None, soglie=(3.0,4.0,4.5), seed=11):
    a = atr(bars15, 14)
    n = len(bars15)
    # rendimenti intragiornalieri
    r = [None]*n
    for i in range(1,n):
        if bars15[i][0]==bars15[i-1][0] and bars15[i-1][6]>0:
            r[i]=math.log(bars15[i][6]/bars15[i-1][6])
    # sigma bipower su finestra scorrevole di K rendimenti validi
    z=[None]*n; buf=[]
    for i in range(n):
        if r[i] is None:
            continue
        if len(buf)>=K:
            prods=[abs(buf[j])*abs(buf[j-1]) for j in range(1,len(buf))]
            s2=sum(prods)/(len(prods))
            sg=math.sqrt(s2) if s2>0 else None
            if sg: z[i]=r[i]*C/sg
        buf.append(r[i])
        if len(buf)>K: buf.pop(0)

    h0,h1 = sess
    def in_sess(b):
        t=b[1]*60+b[2]
        return h0<=t<h1
    giorni = len({b[0] for b in bars15 if in_sess(b)})

    def cammino(i, sign):
        """MFE/MAE nelle H barre dopo i, nel verso `sign` (1=verso del salto)."""
        e = bars15[i][6]; mfe=0.0; mae=0.0
        for j in range(i+1, min(i+1+H, n)):
            if bars15[j][0]!=bars15[i][0]: break     # non si tiene overnight
            hi,lo = bars15[j][4], bars15[j][5]
            up = (hi-e); dn = (e-lo)
            f = up if sign>0 else dn
            c = dn if sign>0 else up
            if f>mfe: mfe=f
            if c>mae: mae=c
        j=min(i+H, n-1)
        while j>i and bars15[j][0]!=bars15[i][0]: j-=1
        fwd = (bars15[j][6]-e)*sign
        return mfe, mae, fwd

    rng=random.Random(seed)
    pool=[i for i in range(K+20, n-H-1) if a[i] and in_sess(bars15[i]) and z[i] is not None]
    print(f"\n=== {nome}  [orologio file: {tz}]  barre M15={n}  giorni di sessione={giorni}  finestra {h0//60:02d}:{h0%60:02d}-{h1//60:02d}:{h1%60:02d} ===")
    print(f"{'soglia':>6} {'lato':>4} {'n':>6} {'/gg':>6} {'fwd12 (ATR)':>12} {'MFE':>7} {'MAE':>7} {'RR':>6} {'WR':>7} {'WRcaso':>7} {'delta':>7} {'news%':>7}")
    for thr in soglie:
        for lato,segno in (('CONT',+1), ('FADE',-1)):
            J=[i for i in pool if abs(z[i])>=thr]
            if not J: continue
            MF=[];MA=[];FW=[];WIN=0;LOS=0;NEWS=0
            for i in J:
                s = (1 if r[i]>0 else -1)*segno
                mfe,mae,fwd = cammino(i,s)
                MF.append(mfe/a[i]); MA.append(mae/a[i]); FW.append(fwd/a[i])
                # TP-prima-di-SL, geometria 1.0 ATR / 1.0 ATR, ambiguita' a sfavore
                e=bars15[i][6]; lvl=a[i]; res=None
                for j in range(i+1, min(i+1+H,n)):
                    if bars15[j][0]!=bars15[i][0]: break
                    hi,lo=bars15[j][4],bars15[j][5]
                    hs = (lo<=e-lvl) if s>0 else (hi>=e+lvl)
                    ht = (hi>=e+lvl) if s>0 else (lo<=e-lvl)
                    if hs: res=0; break
                    if ht: res=1; break
                if res==1: WIN+=1
                elif res==0: LOS+=1
                if cal is not None:
                    d=bars15[i][0]; t=bars15[i][1]*60+bars15[i][2]
                    if tz=="ET": off = 4*60 if us_dst(d) else 5*60
                    else: off = 0
                    tu=t+off
                    # una barra M15 copre [t, t+15): un evento la "spiega" se cade
                    # da 20 minuti PRIMA della chiusura a 5 dopo -> finestra larga
                    if any((d,m) in cal for m in range(tu-20, tu+16)): NEWS+=1
            # controllo a ingressi casuali: stessa geometria, stesse dimensioni
            idx=[rng.choice(pool) for _ in range(len(J))]
            wc=lc=0
            for i in idx:
                s=segno*(1 if rng.random()<0.5 else -1)
                e=bars15[i][6]; lvl=a[i]; res=None
                for j in range(i+1, min(i+1+H,n)):
                    if bars15[j][0]!=bars15[i][0]: break
                    hi,lo=bars15[j][4],bars15[j][5]
                    hs=(lo<=e-lvl) if s>0 else (hi>=e+lvl)
                    ht=(hi>=e+lvl) if s>0 else (lo<=e-lvl)
                    if hs: res=0; break
                    if ht: res=1; break
                if res==1: wc+=1
                elif res==0: lc+=1
            wr = WIN/(WIN+LOS) if WIN+LOS else 0
            wrc = wc/(wc+lc) if wc+lc else 0
            mMF=st.median(MF); mMA=st.median(MA)
            print(f"{thr:6.1f} {lato:>4} {len(J):6d} {len(J)/max(giorni,1):6.2f} "
                  f"{st.median(FW):+12.4f} {mMF:7.3f} {mMA:7.3f} {mMF/mMA if mMA else 0:6.2f} "
                  f"{wr*100:6.1f}% {wrc*100:6.1f}% {(wr-wrc)*100:+6.1f} "
                  f"{(NEWS/len(J)*100 if cal is not None else float('nan')):6.1f}%")

cal = load_cal(S+"/CALENDARIO_FF_High_2010-2023_UTC.csv")
print(f"calendario news high caricato: {len(cal)} eventi (UTC)")
print(f"cancello H8 su RR 1,00: win rate richiesto = {1.075/2*100:.2f}%")

for sym, sess, tz, loader in (
    ("GRXEUR", (3*60, 11*60+30), "ET", load_histdata),      # DAX cash 08:00-16:30 server BCM
    ("SPXUSD", (9*60+30, 16*60), "ET", load_histdata),      # RTH USA 14:30-21:00 server BCM
):
    b = aggregate(loader(glob.glob(f"{S}/dati/{sym}_*.csv")), 15)
    studia(sym, b, sess, tz, cal)

b = aggregate(load_oanda(glob.glob(f"{S}/dati/EURUSDo_*.csv")), 15)
studia("EURUSD", b, (7*60, 20*60), "UTC", cal)
