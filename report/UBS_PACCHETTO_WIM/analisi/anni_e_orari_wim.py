# python3 -I anni_e_orari_wim.py <cartella ANNO80K_WIM_PACCHETTO>
import sys,collections
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import *
W=sys.argv[1]
# 1. etichette degli anni dai prezzi delle operazioni (primo e ultimo prezzo dell'anno per simbolo, minimo e massimo)
print("== ANNI: variazione % tra il primo e l'ultimo prezzo di operazione dell'anno (e escursione min-max), per simbolo")
px=collections.defaultdict(dict)
for ea,s in (('DTP','DaytradeProMax50DDhighrisk'),('APEX','ApexConservativeGrid'),('STAB','stabilityprolowriskset'),('LUNA','LunaAIrecommended')):
    for y in ('2013','2017','2020','2022','2025'):
        p=report_path(W,ea,s,y)
        if not p: continue
        ev=load_deals(p); by=collections.defaultdict(list)
        for t,v,sym,io,pr,ty in ev:
            if sym and pr>0: by[sym].append((t,pr))
        for sym,L in by.items():
            if len(L)<6: continue
            L.sort(); a,b=L[0][1],L[-1][1]; lo=min(x for _,x in L); hi=max(x for _,x in L)
            k=(sym,y)
            if k not in px or len(L)>px[k][4]: px[k]=(100*(b/a-1),100*(hi/lo-1),a,b,len(L))
syms=sorted({k[0] for k in px})
print(f"{'simbolo':8s}"+"".join(f"{y:>16s}" for y in ('2013','2017','2020','2022','2025')))
for s in syms:
    row=f"{s:8s}"
    for y in ('2013','2017','2020','2022','2025'):
        v=px.get((s,y))
        if not v: row+=f"{'-':>16s}"; continue
        ch,rg=v[0],v[1]
        lab='LONG' if ch>=5 else ('SHORT' if ch<=-5 else 'LATER')
        row+=f"{ch:>+7.1f}% {lab:5s}/{rg:3.0f}"
    print(row)
json_out={f'{k[0]}|{k[1]}':v[:2] for k,v in px.items()}
import json; json.dump(json_out,open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/anni_rendimenti_da_prezzi.json','w'))
# 2. orari delle entrate di Indicement e ORB Master (2025-01 -> 2026-09): cluster orari in server per mese
print("\n== ORARI DEGLI INGRESSI di Indicement / ORB Master (orario del server nel tester), per simbolo e regime USA")
import datetime
def us_dst(d):
    def nth_sun(y,m,n):
        x=datetime.date(y,m,1);c=0
        while True:
            if x.weekday()==6:
                c+=1
                if c==n: return x
            x+=datetime.timedelta(1)
    return nth_sun(d.year,3,2)<=d<nth_sun(d.year,11,1)
for ea,s in (('ORBM','OrbMasterveryhighrisk'),('INDI','Indicementextreme')):
    p=report_path(W,ea,s,'2025',fine=True)
    ev=load_deals(p); h=collections.defaultdict(collections.Counter)
    for t,v,sym,io,pr,ty in ev:
        if io!='in': continue
        d=datetime.date(int(t[:4]),int(t[5:7]),int(t[8:10]))
        reg='USA legale' if us_dst(d) else 'USA solare'
        hh=t[11:13]+':'+('00' if int(t[14:16])<30 else '30')
        h[(sym,reg)][hh]+=1
    print(f"-- {ea} {s}: {len(ev)} deal")
    for k in sorted(h):
        top=h[k].most_common(6); n=sum(h[k].values())
        print(f"   {k[0]:7s} {k[1]:10s} n={n:4d}  fasce piu frequenti (server): "+", ".join(f"{a} ({100*b/n:.0f}%)" for a,b in top))
