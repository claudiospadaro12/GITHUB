#!/usr/bin/env python3
# =====================================================================
#  SONDA ESTERNA -- CONO DI RUMORE (M18) sul DAX cash
#  Caccia TF basso del 12/09/2026 -> report/CACCIA_TF_BASSO_2026-09-12.md
# ---------------------------------------------------------------------
#  DATI: gx_<anno>.csv = DAT_ASCII_GRXEUR_M1_<anno>.csv scaricati da
#    https://raw.githubusercontent.com/FutureSharks/financial-data/master/
#    pyfinancialdata/data/stocks/histdata/GRXEUR/
#    (2013-2018, 1.266.562 barre M1, HTTP 200 su 6 file)
#  OROLOGIO: ora file + 5 = ora server BCM. COLLAUDATO qui dentro contro
#    l'ipotesi alternativa "i file sono in UTC" (che predice il minuto
#    07:00 di file, NON presente nei primi cinque per |variazione|).
#  COSTO: 1,70 punti indice = mediana MISURATA dello spread D30EUR
#    all'ora 08 su 30.974.789 tick (risultati_archivio/spread_flotta/
#    spread_orario_D30EUR.csv). Commissione sugli indici 0,0000 MISURATA.
#  ATTENZIONE: OHLC M1, non tick reali -> SCREENING, mai un verdetto.
#    E la VWAP NON e' calcolabile: la colonna volume di questi file e' 0.
# =====================================================================
import glob, collections, statistics

bars=[]
for fn in sorted(glob.glob('gx_*.csv')):
    for ln in open(fn):
        p=ln.split(';')
        if len(p)<5: continue
        dt=p[0]; d=dt[:8]; m=int(dt[9:11])*60+int(dt[11:13])
        bars.append((d,m,float(p[1]),float(p[2]),float(p[3]),float(p[4])))
byday=collections.defaultdict(dict)
for d,m,o,h,l,c in bars: byday[d][m]=(o,h,l,c)
giorni=sorted(byday)
OPEN_F=3*60; CLOSE_F=11*60+30; CD=14; COSTO=1.70

def openday(d):
    for m in range(OPEN_F,OPEN_F+11):
        if m in byday[d]: return byday[d][m][0]
def closeat(d,m):
    for k in range(m,m-6,-1):
        if k in byday[d]: return byday[d][k][3]

validi=[d for d in giorni if openday(d) and sum(1 for m in byday[d] if OPEN_F<=m<=CLOSE_F)>=300]
checks=[m for m in range(OPEN_F,CLOSE_F+1) if m%30==0 and m>OPEN_F]
move=collections.defaultdict(dict)
for d in validi:
    od=openday(d)
    for m in checks:
        c=closeat(d,m)
        if c: move[d][m]=abs(c/od-1)

def cammina(d,m0,verso,entry,dist):
    """stop a distanza SIMMETRICA dist. convenzione PESSIMISTA: stop prima di tutto."""
    slv = entry-dist if verso>0 else entry+dist
    for k in range(m0+1,CLOSE_F+1):
        if k not in byday[d]: continue
        o,h,l,c=byday[d][k]
        if verso>0 and l<=slv: return -dist
        if verso<0 and h>=slv: return -dist
    cc=closeat(d,CLOSE_F)
    return (cc-entry)*verso

for GAPADJ in (False,True):
    res=[]; ctr=[]
    for i,d in enumerate(validi):
        if i<CD: continue
        prev=validi[i-CD:i]; od=openday(d); fatto=False
        pc=closeat(prev[-1],CLOSE_F)
        for m in checks:
            if fatto: continue
            vals=[move[p][m] for p in prev if m in move[p]]
            if len(vals)<CD: continue
            s=statistics.mean(vals); hi=od*(1+s); lo=od*(1-s)
            if GAPADJ and pc:
                hi = max(od,pc)*(1+s)   # formula ESATTA di ABTG_OutOfNoise r.697-700
                lo = min(od,pc)*(1-s)
            larg=hi-lo
            c=closeat(d,m)
            if c is None: continue
            verso = 1 if c>hi else (-1 if c<lo else 0)
            if verso==0: continue
            fatto=True
            res.append(((cammina(d,m,verso,c,larg)-COSTO)/larg, cammina(d,m,verso,c,larg), larg))
            ctr.append((cammina(d,m,-verso,c,larg)-COSTO)/larg)
    n=len(res); E=statistics.mean(x[0] for x in res); sd=statistics.stdev(x[0] for x in res)
    Ec=statistics.mean(ctr)
    print("\n##### GAP ADJUSTMENT: %s | uscita: campanella o stop al cono | n=%d (%.3f op/gg su %d sedute)"%(
        "SI (come il paper)" if GAPADJ else "NO",n,n/(len(validi)-CD),len(validi)-CD))
    print("  E netta MOMENTUM   = %+.4f R   (t=%+.2f)   lorda %+.2f pti/op"%(E,E/(sd/n**0.5),statistics.mean(x[1] for x in res)))
    print("  E netta CONTROLLO APPAIATO (lato opposto, stessa barra, stessa distanza) = %+.4f R"%Ec)
    print("  DELTA direzionale (momentum - opposto)/2 = %+.4f R  <- l'informazione vera"%((E-Ec)/2))
    print("  stop mediano %.1f pti = %.1fx spread | win %.1f%%"%(statistics.median(x[2] for x in res),statistics.median(x[2] for x in res)/1.70,100*sum(1 for x in res if x[0]>0)/n))
    ord_=sorted(res,key=lambda x:x[2]); q=n//3
    for nome,sub in (("stop STRETTO",ord_[:q]),("stop LARGO",ord_[-q:])):
        print("   TEST DI SCALA %s: stop med %.1f pti | E LORDA %+.2f pti | E netta %+.4f R"%(
            nome,statistics.median(x[2] for x in sub),statistics.mean(x[1] for x in sub),statistics.mean(x[0] for x in sub)))
