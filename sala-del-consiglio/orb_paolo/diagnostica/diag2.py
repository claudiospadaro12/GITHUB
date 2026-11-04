# Diagnostica 2 (NESSUN P&L): tickvol e inutile (=1) -> C1 con l'ampiezza media (high-low) per minuto; orari di inizio/fine sessione per mese.
import sys, csv, datetime as dt, collections
f,lab=sys.argv[1],sys.argv[2]
days=collections.defaultdict(dict); tv=collections.Counter()
with open(f) as fh:
    r=csv.reader(fh,delimiter=';'); next(r)
    for x in r:
        t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M")
        days[t.date()][t.hour*60+t.minute]=float(x[2])-float(x[3]); tv[int(x[5])]+=1
print(lab,"tickvol valori:",tv.most_common(4))
bymonth=collections.defaultdict(list)
for d,m in days.items():
    if d.weekday()<5 and len(m)>300: bymonth[(d.year,d.month)].append((min(m),max(m)))
for k in sorted(bymonth):
    L=bymonth[k]
    fm=collections.Counter(a for a,b in L).most_common(1)[0][0]; lm=collections.Counter(b for a,b in L).most_common(1)[0][0]
    print(f"{k[0]}-{k[1]:02d} giorni {len(L):2d} prima barra {fm//60:02d}:{fm%60:02d} ultima {lm//60:02d}:{lm%60:02d}")
# picco ampiezza media per minuto (13:00-17:00 server) per mese
for k in sorted(bymonth):
    tot=collections.Counter(); n=0
    for d,m in days.items():
        if (d.year,d.month)==k and d.weekday()<5 and len(m)>300:
            n+=1
            for mi in range(13*60,17*60):
                if mi in m: tot[mi]+=m[mi]
    top=sorted(tot.items(),key=lambda kv:-kv[1])[:3]
    print(f"{k[0]}-{k[1]:02d} top3 ampiezza media: "+", ".join(f"{a//60:02d}:{a%60:02d}({v/n:.1f})" for a,v in top))
