exec(open('equity_vero.py').read())
import glob,datetime as dt
def path(e,lv,y):
    if e=='GTP': return glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')[0]
    return glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')[0]
def P(s): return dt.datetime.strptime(s[:16],'%Y.%m.%d %H:%M')
COMBO={'P1':[('PH','L1'),('GB','L0')],'P2':[('GR','L3'),('PH','L3'),('GB','L0')],'P3':[('GB','L3'),('GTP','COMBO')],'P4':[('GR','L3'),('GB','L0')],'P5':[('PH','L0'),('GB','L0')]}
CUT=dt.time(22,0)
res={}
for c,mem in COMBO.items():
    tot=0;cut_n=0;delta=0;gross=0
    for y in ('2013','2025'):
        T,hi,lo,cl=m1(y);cv=CONV[y]
        for e,lv in mem:
            pos,_,_=positions(deals(path(e,lv,y)),y)
            for p in pos:
                t0=P(p['t0']);t1=P(p['t1']);tot+=p['pnl']
                # primo venerdi' 22:00 dentro [t0,t1)
                d=t0.date()
                found=None
                while d<=t1.date():
                    if d.weekday()==4:
                        c_=dt.datetime.combine(d,CUT)
                        if t0<c_<t1: found=c_;break
                    d+=dt.timedelta(days=1)
                if found:
                    k=min(int(np.searchsorted(T,np.datetime64(found.strftime('%Y-%m-%dT%H:%M')))),len(T)-1)
                    px=cl[k];sgn=1 if p['side']=='buy' else -1
                    newgross=sgn*(px-p['entry'])*p['vol']*100*cv
                    comm=p['pnl']-p['gross']
                    delta+=(newgross+comm)-p['pnl'];cut_n+=1
    res[c]=(tot,cut_n,delta)
    print(c,'(solo oro, 2013+2025) netto',round(tot),'posizioni chiuse al taglio del venerdi 22:00',cut_n,'variazione P&L',round(delta),f"({100*delta/tot:+.1f}% del netto)")
