import csv, datetime as dt, sys
B="/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt"
raw=[]
with open(B+"/data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv") as f:
    r=csv.reader(f,delimiter="\t"); next(r)
    for x in r:
        d=dt.datetime.strptime(x[0],"%Y.%m.%d").date()
        raw.append((d,float(x[1]),float(x[2]),float(x[3]),float(x[4]),int(x[5])))
from collections import Counter
print("righe raw",len(raw),"weekday",Counter(d.weekday() for d,*_ in raw))
# filtro
LAST=dt.date(2026,10,19)
raw=[b for b in raw if b[0]!=dt.date(2004,6,11) and b[0]<LAST]
# fusione: ogni barra di domenica attende il primo giorno successivo (deve essere lunedi)
fused=[]; pend=None; sund_nomon=[]
for b in raw:
    d=b[0]
    if d.weekday()==6:
        if pend is not None: sund_nomon.append(("doppia domenica",d))
        pend=b; continue
    if d.weekday()==5: print("sabato!",d)
    if pend is not None:
        if d.weekday()!=0: sund_nomon.append(("domenica non seguita da lunedi",pend[0],d))
        o=pend[1]; h=max(pend[2],b[2]); l=min(pend[3],b[3]); c=b[4]; v=pend[5]+b[5]; n=2
        fused.append((d,o,h,l,c,v,n,1)); pend=None
    else:
        fused.append((d,b[1],b[2],b[3],b[4],b[5],1,0))
print("domeniche anomale:",sund_nomon,"pend finale",pend)
print("barre fuse",len(fused),fused[0][0],fused[-1][0])
with open(sys.argv[1]+"/D1_fuso_A7.csv","w") as f:
    f.write("data;open;high;low;close;tickvol;n_raw;domenica_fusa\n")
    for d,o,h,l,c,v,n,s in fused:
        f.write(f"{d};{o:.2f};{h:.2f};{l:.2f};{c:.2f};{v};{n};{s}\n")
