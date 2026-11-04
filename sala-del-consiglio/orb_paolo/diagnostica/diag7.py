# Diagnostica 7 (NESSUN P&L): C2 ricalcolato con la convenzione oraria osservata per file.
#  2015: apertura 14:30 tutto l'anno (stile NY+5h). 2020 e 2025-26: ora di Londra (14:30, ma 13:30 nei giorni di scarto USA legale / UE solare).
import sys, csv, datetime as dt, collections
sys.path.insert(0,"/home/user/GITHUB/sala-del-consiglio/orb_paolo/diagnostica")
from diag import us_dst, eu_dst
f,lab,conv=sys.argv[1],sys.argv[2],sys.argv[3]
def open_min(d):
    if conv=="ET5": return 14*60+30
    return 13*60+30 if (us_dst(d) and not eu_dst(d)) else 14*60+30
D=collections.defaultdict(set)
with open(f) as fh:
    r=csv.reader(fh,delimiter=';'); next(r)
    for x in r:
        t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M")
        if t.weekday()<5: D[t.date()].add(t.hour*60+t.minute)
ok=[];bad=[]
for d,m in sorted(D.items()):
    a=open_min(d); n=sum(1 for k in range(a,a+385) if k in m)
    (ok if n>=0.95*385 else bad).append((d,n))
print(lab,"conv",conv,"giorni feriali",len(D),"conformi",len(ok),"esclusi",len(bad))
print("  esclusi:",", ".join(f"{d}({n})" for d,n in bad))
