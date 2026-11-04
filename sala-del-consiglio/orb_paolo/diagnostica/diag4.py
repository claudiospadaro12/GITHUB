# Diagnostica 4 (NESSUN P&L): ampiezza M1 a 14:30 / 15:30 / ultimo minuto della giornata, giorno per giorno, a cavallo dei cambi d'ora USA.
import sys, csv, datetime as dt, collections
f,lab,d0,d1=sys.argv[1],sys.argv[2],dt.date.fromisoformat(sys.argv[3]),dt.date.fromisoformat(sys.argv[4])
D=collections.defaultdict(dict)
with open(f) as fh:
    r=csv.reader(fh,delimiter=';'); next(r)
    for x in r:
        t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M")
        if d0<=t.date()<=d1: D[t.date()][t.hour*60+t.minute]=float(x[2])-float(x[3])
print(lab)
for d in sorted(D):
    if d.weekday()>=5: continue
    m=D[d]; g=lambda h,mi:m.get(h*60+mi,float('nan'))
    last=max(k for k in m if k<23*60) if m else None
    print(d,d.strftime("%a"),f"14:30={g(14,30):6.1f} 15:30={g(15,30):6.1f} 13:30={g(13,30):6.1f}  ultima barra<23h {last//60:02d}:{last%60:02d}")
