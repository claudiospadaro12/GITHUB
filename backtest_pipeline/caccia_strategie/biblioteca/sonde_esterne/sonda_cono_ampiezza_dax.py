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

# indicizza per giorno
byday=collections.defaultdict(dict)
for d,m,o,h,l,c in bars: byday[d][m]=(o,h,l,c)
giorni=sorted(byday)

OPEN_F=3*60       # 08:00 server = 03:00 file
CLOSE_F=11*60+30  # 16:30 server = 11:30 file
CONEDAYS=14

def openday(d):
    dd=byday[d]
    for m in range(OPEN_F,OPEN_F+11):
        if m in dd: return dd[m][0]
    return None

def closeat(d,m):
    dd=byday[d]
    for k in range(m,m-6,-1):
        if k in dd: return dd[k][3]
    return None

# solo giorni con apertura e abbastanza barre di seduta
validi=[d for d in giorni if openday(d) and sum(1 for m in byday[d] if OPEN_F<=m<=CLOSE_F)>=300]
print("sedute valide:",len(validi),"dal",validi[0],"al",validi[-1])

# griglia dei controlli a orologio (HH:00 e HH:30 SERVER) dentro la seduta
checks=[m for m in range(OPEN_F,CLOSE_F+1) if m%30==0 and m>OPEN_F]
print("controlli a orologio per seduta:",len(checks),"->",["%02d:%02d srv"%((m//60+5)%24,m%60) for m in checks])

# move[m] = |close(m)/open_giorno -1| per seduta
move=collections.defaultdict(dict)
for d in validi:
    od=openday(d)
    for m in checks:
        c=closeat(d,m)
        if c: move[d][m]=abs(c/od-1)

larghezze=collections.defaultdict(list)   # per check: ampiezza cono INTERA in punti indice
segnali=0; sedute_con_segnale=0; tot_sedute=0
stop_pts_all=[]
for i,d in enumerate(validi):
    if i<CONEDAYS: continue
    prev=validi[i-CONEDAYS:i]
    od=openday(d); tot_sedute+=1; fatto=False
    for m in checks:
        vals=[move[p][m] for p in prev if m in move[p]]
        if len(vals)<CONEDAYS: continue
        sigma=statistics.mean(vals)
        larg=2*sigma*od               # ampiezza INTERA del cono = stop in modo SL_CONO
        larghezze[m].append(larg)
        c=closeat(d,m)
        if c is None: continue
        if (c>od*(1+sigma) or c<od*(1-sigma)) and not fatto:
            segnali+=1; fatto=True; stop_pts_all.append(larg)
    if fatto: sedute_con_segnale+=1

print("\n=== AMPIEZZA DEL CONO (= STOP in modo SL_CONO), punti indice DAX ===")
print("check srv | mediana | p10 | p90 | stop/spread(1,70) mediana | n")
for m in checks:
    v=sorted(larghezze[m])
    if not v: continue
    med=statistics.median(v)
    print("  %02d:%02d   | %7.1f | %5.1f | %5.1f | %8.1fx | %d" % ((m//60+5)%24,m%60,med,v[int(.1*len(v))],v[int(.9*len(v))],med/1.70,len(v)))

tutte=sorted(x for v in larghezze.values() for x in v)
print("\nTUTTI i controlli insieme: n=%d mediana %.1f pti -> %.1fx  | p10 %.1f (%.1fx) | p90 %.1f (%.1fx)"%(
    len(tutte),statistics.median(tutte),statistics.median(tutte)/1.70,
    tutte[int(.1*len(tutte))],tutte[int(.1*len(tutte))]/1.70,
    tutte[int(.9*len(tutte))],tutte[int(.9*len(tutte))]/1.70))
sotto=sum(1 for x in tutte if x/1.70<13.3)/len(tutte)
sotto40=sum(1 for x in tutte if x/1.70<40)/len(tutte)
print("quota sotto il pavimento DURO 13,3x: %.1f%%   |  sotto il pavimento di lavoro 40x: %.1f%%"%(100*sotto,100*sotto40))

print("\n=== FREQUENZA (primo sconfinamento del cono per seduta, UN lato) ===")
print("sedute misurate %d | sedute con almeno un segnale %d (%.1f%%) | segnali %d = %.3f op/giorno"%(
    tot_sedute,sedute_con_segnale,100*sedute_con_segnale/tot_sedute,segnali,segnali/tot_sedute))
if stop_pts_all:
    print("stop mediano SULLE OPERAZIONI VERE: %.1f pti -> %.1fx"%(statistics.median(stop_pts_all),statistics.median(stop_pts_all)/1.70))
