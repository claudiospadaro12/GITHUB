# Diagnostica 6 (come la 5 ma per regime) (NESSUN P&L): quale convenzione oraria spiega il picco di ampiezza all'apertura? Confronto di 3 ipotesi, giorno per giorno.
#  H_GMT1  : server GMT+1 fisso (regola CLAUDE.md)  -> apertura 14:30 se USA legale, 15:30 se solare
#  H_LON   : ora di Londra (UTC in inverno UE, UTC+1 in estate UE) -> apertura = 9:30 NY convertita
#  H_ET5   : New York + 5h tutto l'anno -> 14:30 sempre
import sys, csv, datetime as dt, collections
sys.path.insert(0,"/home/user/GITHUB/sala-del-consiglio/orb_paolo/diagnostica")
from diag import us_dst, eu_dst
def open_min(d,H):
    utc_open=(13,30) if us_dst(d) else (14,30)           # 09:30 NY in UTC
    base=utc_open[0]*60+utc_open[1]
    if H=="H_GMT1": return base+60
    if H=="H_LON":  return base+(60 if eu_dst(d) else 0)
    if H=="H_ET5":  return 14*60+30
    if H=="H_UTC":  return base
f,lab=sys.argv[1],sys.argv[2]
D=collections.defaultdict(dict)
with open(f) as fh:
    r=csv.reader(fh,delimiter=';'); next(r)
    for x in r:
        t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M")
        if t.weekday()<5: D[t.date()][t.hour*60+t.minute]=float(x[2])-float(x[3])
res={}
for H in ("H_GMT1","H_LON","H_ET5","H_UTC"):
  for seg in ("inverno(USA solare)","scarto(USA legale,UE solare)","estate(entrambi legali)"):
    ratios=[];hit=0;n=0
    for d,m in D.items():
        sg="inverno(USA solare)" if not us_dst(d) else ("scarto(USA legale,UE solare)" if not eu_dst(d) else "estate(entrambi legali)")
        if sg!=seg: continue
        win=[k for k in range(12*60+30,17*60) if k in m]
        if len(win)<200: continue
        base=sum(m[k] for k in win)/len(win); e=open_min(d,H)
        if e not in m or base<=0: continue
        ratios.append(m[e]/base); n+=1
        am=max(win,key=lambda k:m[k]); hit+= abs(am-e)<=1
    if n==0: continue
    ratios.sort()
    res[(H,seg)]=(n,sum(ratios)/n,ratios[n//2],hit/n)
print(lab)
for (H,seg),(n,mean,med,hit) in res.items(): print(f"  {seg:30s} {H:7s} giorni {n:3d}  ampiezza all'apertura/ampiezza media finestra: media {mean:5.2f} mediana {med:5.2f}  argmax entro +-1 min: {100*hit:4.1f}%")
