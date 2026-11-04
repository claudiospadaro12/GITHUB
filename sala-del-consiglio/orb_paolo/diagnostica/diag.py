# Fase diagnostica (piano v1 sez. 2/8): C1 picco di volume all'apertura, C2 buchi, C3 spread, tabella mappatura.
# NESSUN P&L. Uso: python3 -I diag.py <csv> <etichetta> > out
import sys, csv, datetime as dt, collections, statistics as st
def nth_sunday(y,m,n):
    d=dt.date(y,m,1); c=0
    while True:
        if d.weekday()==6:
            c+=1
            if c==n: return d
        d+=dt.timedelta(1)
def last_sunday(y,m):
    d=dt.date(y,m+1,1)-dt.timedelta(1) if m<12 else dt.date(y,12,31)
    while d.weekday()!=6: d-=dt.timedelta(1)
    return d
def us_dst(d): return nth_sunday(d.year,3,2)<=d<nth_sunday(d.year,11,1)
def eu_dst(d): return last_sunday(d.year,3)<=d<last_sunday(d.year,10)
def expected_open(d): return (14,30) if us_dst(d) else (15,30)
if __name__=="__main__":
    # tabella di collaudo mappatura (4 casi)
    tests=[(dt.date(2026,1,15),(15,30),"a: USA e EU solari"),(dt.date(2026,3,16),(14,30),"b: USA legale, EU solare"),
           (dt.date(2026,7,15),(14,30),"c: entrambi legali"),(dt.date(2026,10,26),(14,30),"d: EU solare, USA ancora legale"),
           (dt.date(2026,11,2),(15,30),"USA tornati solari")]
    for d,exp,lab in tests:
        print("MAPPATURA", d, lab, expected_open(d), "OK" if expected_open(d)==exp else "ERRORE")
    f,lab=sys.argv[1],sys.argv[2]
    rows=0; days=collections.defaultdict(dict); spreads=collections.Counter(); badorder=0
    with open(f) as fh:
        r=csv.reader(fh,delimiter=';'); next(r)
        for x in r:
            t=dt.datetime.strptime(x[0],"%Y.%m.%d %H:%M"); rows+=1
            days[t.date()][t.hour*60+t.minute]=(float(x[2]),float(x[3]),int(x[5]))
            spreads[int(x[6])]+=1
    print(lab,"righe",rows,"giorni",len(days),"primo",min(days),"ultimo",max(days))
    print("C3 spread: valori distinti",len(spreads),"top",spreads.most_common(5))
    # C2: giorni lavorativi con meno del 95% dei minuti attesi tra apertura e 15:55 NY (= apertura + 6h25 server)
    bad=[];ok=[];reg=collections.defaultdict(list)
    for d,m in sorted(days.items()):
        if d.weekday()>=5: continue
        h,mi=expected_open(d); a=h*60+mi; b=a+385  # 09:30->15:55 NY = 385 minuti
        n=sum(1 for k in range(a,b) if k in m)
        if n<0.95*385: bad.append((d,n))
        else: ok.append(d)
    print("C2 giorni feriali con dati",len(ok)+len(bad),"conformi",len(ok),"esclusi(<95%)",len(bad))
    print("C2 esempi esclusi",[(str(d),n) for d,n in bad[:12]])
    # C1: picco di volume per regime USA (legale/solare) nella finestra 13:30-16:30 server
    for regime in ("USA_legale","USA_solare"):
        ds=[d for d in ok if (us_dst(d))==(regime=="USA_legale")]
        if not ds: print("C1",regime,"nessun giorno"); continue
        tot=collections.Counter(); perday=collections.Counter()
        for d in ds:
            m=days[d]; cand=[(m[k][2],k) for k in range(13*60+30,16*60+30) if k in m]
            for k in range(13*60+30,16*60+30):
                if k in m: tot[k]+=m[k][2]
            if cand: perday[max(cand)[1]]+=1
        pk=max(tot,key=tot.get); h,mi=expected_open(ds[0])
        exp=h*60+mi
        near=sum(v for k,v in perday.items() if abs(k-exp)<=1)
        print(f"C1 {regime}: giorni {len(ds)} picco_aggregato {pk//60:02d}:{pk%60:02d} atteso {h:02d}:{mi:02d} -> {'PASS' if abs(pk-exp)<=1 else 'FAIL'}; giorni con argmax entro +-1 min: {near}/{len(ds)} ({100*near/len(ds):.0f}%); top argmax {[(f'{k//60:02d}:{k%60:02d}',v) for k,v in perday.most_common(4)]}")
        top=sorted(tot.items(),key=lambda kv:-kv[1])[:4]
        print("   top minuti aggregati",[(f'{k//60:02d}:{k%60:02d}',v) for k,v in top])
