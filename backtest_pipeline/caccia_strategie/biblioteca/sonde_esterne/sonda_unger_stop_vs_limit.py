#!/usr/bin/env python3
# Nata il 24/09/2026 per i file prova R249 (ipotesi A del Metodo Unger, stop contro limit sui livelli D1 di ieri):
#   backtest_pipeline/prove/R249a_ungerA_D30EUR_BRK_LONG_atr.txt (file di testa).
# DATI: gli stessi di sonda_unger_eventi.py (FutureSharks/financial-data, histdata M1 GRXEUR 2011-2018, GPL-3.0),
#   salvati come dati/GRXEUR_<ANNO>.csv. Uso: python3 sonda_unger_stop_vs_limit.py  (dalla cartella che contiene dati/)
# LIMITI: NON e' BCM; OHLC M1 (barra d'ingresso ambigua trattata come STOP); dati solo 07-21 server (niente notte);
#   vecchio orologio (08:00 server = apertura cash TUTTO l'anno); 2011-2018, non il regime 2024-2026;
#   livelli = sessione 07-21 di ieri (BCM usa la D1 00-24). Misura un PRIOR, mai un verdetto.
# PARTE 1: ATR(14) M5 letto alle 08:00 (quello che usa AtrValue() dell'EA) contro il range del giorno.
import glob, statistics as st
from collections import defaultdict
from datetime import datetime, timedelta
m5=defaultdict(dict)
for p in sorted(glob.glob('dati/GRXEUR_*.csv')):
    for line in open(p):
        q=line.strip().split(';')
        if len(q)<5: continue
        t=datetime.strptime(q[0],'%Y%m%d %H%M%S')+timedelta(hours=5)
        k=t.replace(minute=t.minute-t.minute%5,second=0)
        o,h,l,c=map(float,q[1:5])
        d=m5[t.date()]
        if k not in d: d[k]=[o,h,l,c]
        else: b=d[k]; b[1]=max(b[1],h); b[2]=min(b[2],l); b[3]=c
rat=[];pct=[];rat_sess=[]
days=sorted(m5)
for d in days:
    bars=sorted(m5[d].items())
    if len(bars)<150: continue
    pre=[b for t,b in bars if t.hour==7]          # 07:00-07:55 = 12 barre (le 2 delle 06:50 mancano nei dati)
    if len(pre)<10: continue
    trs=[];pc=None
    for b in pre:
        tr=b[1]-b[2] if pc is None else max(b[1],pc)-min(b[2],pc)
        trs.append(tr); pc=b[3]
    atr=sum(trs)/len(trs)
    hi=max(b[1] for t,b in bars); lo=min(b[2] for t,b in bars)
    sess=[b for t,b in bars if 8*60<=t.hour*60+t.minute<16*60+30]
    trs2=[];pc=None
    for b in sess:
        tr=b[1]-b[2] if pc is None else max(b[1],pc)-min(b[2],pc); trs2.append(tr); pc=b[3]
    rat.append(atr/(hi-lo)); pct.append(atr/pre[-1][3]*100)
    rat_sess.append(atr/(sum(trs2)/len(trs2)))
def q(x,p): x=sorted(x); return x[int(p*(len(x)-1))]
print('giorni',len(rat))
print('ATR08/ADR   p10 %.4f med %.4f p90 %.4f'%(q(rat,.1),st.median(rat),q(rat,.9)))
print('ATR08/ATRcash(08-16:30) p10 %.3f med %.3f p90 %.3f'%(q(rat_sess,.1),st.median(rat_sess),q(rat_sess,.9)))
for adr in (252.2,):
    for m in (1.5,3.0,4.0,5.0,6.0):
        s=[r*adr*m for r in rat]
        print('ADR BCM %.1f mult %.1f -> stop idx p10 %.1f med %.1f p90 %.1f ; x spread1.70 med %.1f ; quota >=68 idx %.2f'%(adr,m,q(s,.1),st.median(s),q(s,.9),st.median(s)/1.70,sum(v>=68 for v in s)/len(s)))

# PARTE 2: stop contro limit
import glob, sys, statistics as st, random
from collections import defaultdict
from datetime import datetime, timedelta
byday=defaultdict(list)
for p in sorted(glob.glob('dati/GRXEUR_*.csv')):
    for line in open(p):
        q=line.strip().split(';')
        if len(q)<5: continue
        t=datetime.strptime(q[0],'%Y%m%d %H%M%S')+timedelta(hours=5)
        o,h,l,c=map(float,q[1:5]); byday[t.date()].append((t,o,h,l,c))
days=sorted(d for d in byday if len(byday[d])>=300)
COST=1.70/24000.0
def mins(t): return t.hour*60+t.minute
def run(stop_mode):
    res=defaultdict(list); amb=defaultdict(int)
    for i in range(1,len(days)):
        prev=byday[days[i-1]]; PDH=max(b[2] for b in prev); PDL=min(b[3] for b in prev)
        today=byday[days[i]]
        pre=[b for b in today if mins(b[0])<480]; arm=[b for b in today if 480<=mins(b[0])<990]
        if not arm or not pre: continue
        if any(b[2]>=PDH or b[3]<=PDL for b in pre) or not (PDL<arm[0][1]<PDH): continue
        if stop_mode=='fix': Sfrac=68.0/24000.0
        else:
            # 1,5 x ATR(14) M5 alla barra 07:55 (qui 12 barre M5 07:00-07:55, dati prima delle 07 assenti)
            m5=defaultdict(list)
            for b in pre: m5[b[0].replace(minute=b[0].minute-b[0].minute%5)].append(b)
            trs=[];pc=None
            for k in sorted(m5):
                bb=m5[k]; h=max(x[2] for x in bb); l=min(x[3] for x in bb); c=bb[-1][4]
                trs.append(h-l if pc is None else max(h,pc)-min(l,pc)); pc=c
            Sfrac=1.5*(sum(trs)/len(trs))/arm[0][1]
        for lvl,name in ((PDH,'H'),(PDL,'L')):
            k=next((j for j,b in enumerate(arm) if (b[2]>=lvl if name=='H' else b[3]<=lvl)),None)
            if k is None: continue
            S=Sfrac*lvl
            for arm_name,d in (('BRK',+1 if name=='H' else -1),('FADE',-1 if name=='H' else +1)):
                stop=lvl-d*S; out=None
                eb=arm[k]
                if (d>0 and eb[3]<=stop) or (d<0 and eb[2]>=stop): amb[arm_name+name]+=1; out=stop
                if out is None:
                    for b in arm[k+1:]:
                        if (d>0 and b[3]<=stop) or (d<0 and b[2]>=stop): out=stop; break
                if out is None: out=arm[-1][4]
                r=d*(out-lvl)/S - COST*lvl/S
                res[arm_name+name].append((days[i].year,r))
    return res,amb
def pf(x):
    g=sum(v for v in x if v>0); l=-sum(v for v in x if v<0); return g/l if l>0 else float('inf')
for mode in ('fix','atr'):
    res,amb=run(mode)
    print('== stop',mode,'(fix = 68 idx a 24000 = 40x spread 1,70; atr = 1,5 x ATR M5 alle 08)')
    for k in ('BRKH','FADEH','BRKL','FADEL'):
        r=[v for y,v in res[k]]
        yrs=sorted(set(y for y,v in res[k])); py=[round(pf([v for y,v in res[k] if y==yy]),2) for yy in yrs]
        random.seed(1); bs=sorted(pf(random.choices(r,k=len(r))) for _ in range(2000))
        print('%-5s n %4d (%.0f/anno) PF %.3f  meanR %+.3f  boot90 [%.2f;%.2f]  ambigue %d  PF per anno %s'%(k,len(r),len(r)/8.02,pf(r),st.mean(r),bs[100],bs[1900],amb[k],py))

# potenza del confronto APPAIATO a n BCM (stop fisso): quante volte, ricampionando n tocchi, PF_BRK > PF_FADE
res,amb=run('fix')
for lv,a,b in (('H','BRKH','FADEH'),('L','BRKL','FADEL')):
    pairs=list(zip([v for y,v in res[a]],[v for y,v in res[b]]))
    for n in (42,63,105,315):
        random.seed(7); win=0; Ds=[]
        for _ in range(2000):
            s=random.choices(pairs,k=n); d=pf([x for x,y in s])-pf([y for x,y in s]); Ds.append(d); win+= d>0
        Ds.sort()
        print('livello %s n=%3d  P(PF_BRK>PF_FADE)=%.2f  D p10 %.2f med %.2f p90 %.2f'%(lv,n,win/2000,Ds[200],Ds[1000],Ds[1800]))

# DD in R su finestre di 2 anni solari consecutivi (2011-12 ... 2017-18) e quota di stop pieni
for mode in ('fix','atr'):
    res,amb=run(mode)
    for k in ('BRKH','FADEH','BRKL','FADEL'):
        r=[v for y,v in res[k]]
        stopfrac=sum(1 for v in r if v<=-0.99)/len(r)
        dds=[]
        for y0 in range(2011,2018):
            seq=[v for y,v in res[k] if y0<=y<y0+2]
            eq=pk=d=0
            for v in seq: eq+=v; pk=max(pk,eq); d=max(d,pk-eq)
            dds.append(d)
        dds.sort()
        print('%s %-5s quota stop pieni %.2f  DD in R (finestre di 2 anni): mediano %.1f  peggiore %.1f'%(mode,k,stopfrac,dds[len(dds)//2],dds[-1]))

# PARTE 4 (strato 2, 24/09): contro-esempio del cancello S1 e tasso PER LIVELLO (un lato per file).
# H1 = candela 07:00-07:59 (default del core ABTG_DEF_LEVEL_TF=PERIOD_H1, r.168): ordine piazzabile alle 08 e toccato entro le 16:30.
# D1sep = conta il giorno se e' consumato solo l'ALTRO livello (il file ne usa uno solo).
nf=len(days)-1; cH1={'H':0,'L':0}; cD1={'H':0,'L':0}
for i in range(1,len(days)):
    prev=byday[days[i-1]]; PDH=max(b[2] for b in prev); PDL=min(b[3] for b in prev)
    today=byday[days[i]]
    pre=[b for b in today if mins(b[0])<480]; arm=[b for b in today if 480<=mins(b[0])<990]
    if not arm or not pre: continue
    o=arm[0][1]; h1=[b for b in today if 420<=mins(b[0])<480]
    if h1:
        H=max(b[2] for b in h1); L=min(b[3] for b in h1)
        cH1['H']+= (o<H and any(b[2]>=H for b in arm)); cH1['L']+= (o>L and any(b[3]<=L for b in arm))
    cD1['H']+= (not any(b[2]>=PDH for b in pre) and o<PDH and any(b[2]>=PDH for b in arm))
    cD1['L']+= (not any(b[3]<=PDL for b in pre) and o>PDL and any(b[3]<=PDL for b in arm))
for k in 'HL':
    print('S1 livello %s: H1 %.3f/feriale (~%.0f su 459)  D1 per livello %.3f (~%.0f)  soglia 0,45 (207)'%(k,cH1[k]/nf,cH1[k]/nf*459,cD1[k]/nf,cD1[k]/nf*459))

# PARTE 5 (strato 2, 24/09): la regola del par. 6 COM'E' SCRITTA (classe 764) e il DD PER GAMBA.
# Finestre contigue IS 183 + OOS 276 feriali, passo 20; 'STOP avanti' = D>0 in tutte e due le gambe.
def run_d(mode):
    src=open(__file__).read(); c=src[src.index('# PARTE 2'):src.index("for mode in ('fix','atr'):")]
    c=c.replace("res[arm_name+name].append((days[i].year,r))","res[arm_name+name].append((days[i],r))")
    h={}; exec(c,h); return h['run'](mode)[0]
def ddp(rs):
    eq=pk=1.0; m=0
    for r in rs: eq*=1+0.01*r; pk=max(pk,eq); m=max(m,1-eq/pk)
    return m*100
for mode in ('fix','atr'):
    R=run_d(mode); W=[j for j in range(1,len(days),20) if j+459<len(days)]
    for k in ('BRKH','FADEH','BRKL','FADEL'):
        A=dict(R[k]); o=[]
        for nm,a,b in (('IS',0,183),('OOS',183,459)):
            v=[ddp([A[d] for d in sorted(A) if d in set(days[j+a:j+b])]) for j in W]
            o.append('%s med %.1f%% P(>10%%) %.2f'%(nm,st.median(v),sum(x>10 for x in v)/len(v)))
        print('DD per gamba',mode,k,' | '.join(o))
    for lv,a,b in (('H','BRKH','FADEH'),('L','BRKL','FADEL')):
        A=dict(R[a]); B=dict(R[b])
        for tipo in ('effetto','nullo'):
            random.seed(3); c=[0,0,0]; reps=1 if tipo=='effetto' else 20
            for j in W:
                for _ in range(reps):
                    Ds=[]
                    for x,y in ((0,183),(183,459)):
                        S=set(days[j+x:j+y]); xa=[];xb=[]
                        for d in sorted(A):
                            if d in S:
                                u,v=A[d],B[d]
                                if tipo=='nullo' and random.random()<.5: u,v=v,u
                                xa.append(u); xb.append(v)
                        Ds.append(pf(xa)-pf(xb))
                    c[0 if Ds[0]>0 and Ds[1]>0 else (1 if Ds[0]<0 and Ds[1]<0 else 2)]+=1
            T=sum(c); print('regola par.6',mode,lv,tipo,'STOP %.2f LIMIT %.2f NONDEC %.2f'%(c[0]/T,c[1]/T,c[2]/T))
