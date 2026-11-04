# Diagnostica 3 (NESSUN P&L): rapporto ampiezza media a 14:30 vs 15:30 server, per mese, e intorno ai cambi d'ora USA/UE.
import sys, csv, datetime as dt, collections
sys.path.insert(0,"/home/user/GITHUB/sala-del-consiglio/orb_paolo/diagnostica")
from diag import us_dst, eu_dst
f,lab=sys.argv[1],sys.argv[2]
a=collections.defaultdict(lambda:[0.0,0.0,0]); reg=collections.defaultdict(lambda:[0.0,0.0,0])
with open(f) as fh:
    r=csv.reader(fh,delimiter=';'); next(r)
    for x in r:
        t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M")
        if t.weekday()>=5: continue
        mi=t.hour*60+t.minute
        if mi in (14*60+30,15*60+30):
            rg=float(x[2])-float(x[3]); i=0 if mi==14*60+30 else 1
            a[(t.year,t.month)][i]+=rg; 
            if i==0: a[(t.year,t.month)][2]+=1
            d=t.date(); key=("USdst" if us_dst(d) else "USstd")+"/"+("EUdst" if eu_dst(d) else "EUstd")
            reg[key][i]+=rg
            if i==0: reg[key][2]+=1
print(lab)
for k in sorted(a):
    v=a[k]; print(f"{k[0]}-{k[1]:02d} amp14:30 {v[0]/v[2]:7.2f}  amp15:30 {v[1]/v[2]:7.2f}  rapporto {v[0]/max(v[1],1e-9):5.2f}")
for k,v in reg.items(): print("REGIME",k,"giorni",v[2],"rapporto 14:30/15:30",round(v[0]/v[1],2))
