exec(open('equity_vero.py').read().split("M1={}")[0])
import glob,datetime as dt
def path(e,lv,y):
    if e=='DTP': return glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_{y}/*/report/*.htm')[0]
    if e=='GTP': return glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')[0]
    return glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')[0]
def P(s): return dt.datetime.strptime(s[:16],'%Y.%m.%d %H:%M')
def spans(t0,t1):
    d=t0.date()
    while d<=t1.date():
        if d.weekday()==5 and t0< dt.datetime.combine(d,dt.time(0,0)) < t1: return True
        d+=dt.timedelta(days=1)
    return False
COMBO={'P1':[('PH','L1'),('GB','L0'),('DTP','on')],'P2':[('GR','L3'),('PH','L3'),('GB','L0'),('DTP','on')],'P3':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4':[('GR','L3'),('GB','L0'),('DTP','on')],'P5':[('PH','L0'),('GB','L0'),('DTP','on')]}
for c,mem in COMBO.items():
    tot=0;n=0;nw=0;pw=0;lw=0
    for y in ('2013','2020','2025'):
        for e,lv in mem:
            pos,_,_=positions(deals(path(e,lv,y)),y)
            for p in pos:
                n+=1;tot+=p['pnl']
                if spans(P(p['t0']),P(p['t1'])):
                    nw+=1;pw+=p['pnl']
    print(c,'posizioni',n,'che attraversano un weekend',nw,f"({100*nw/n:.1f}%)",'| P&L di quelle',round(pw),'su totale',round(tot),f"({100*pw/tot:.0f}%)")
