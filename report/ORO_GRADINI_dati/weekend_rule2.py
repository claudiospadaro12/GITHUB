exec(open('equity_vero.py').read())
import glob,datetime as dt,collections
# chiusura reale del venerdi' nello storico
for y in ('2013','2025'):
    T,hi,lo,cl=m1(y);last={}
    for i,t in enumerate(T):
        d=t.astype('datetime64[D]')
        if (d.astype(dt.date)).weekday()==4: last[str(d)]=str(t)[11:16]
    c=collections.Counter(last.values());print(y,'ultima barra del venerdi (ora server):',c.most_common(4))
def path(e,lv,y):
    if e=='GTP': return glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')[0]
    return glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')[0]
def P(s): return dt.datetime.strptime(s[:16],'%Y.%m.%d %H:%M')
COMBO={'P1':[('PH','L1'),('GB','L0')],'P2':[('GR','L3'),('PH','L3'),('GB','L0')],'P3':[('GB','L3'),('GTP','COMBO')],'P4':[('GR','L3'),('GB','L0')],'P5':[('PH','L0'),('GB','L0')]}
def simulate(rule,pos,y):
    T,hi,lo,cl=m1(y);cv=CONV[y];delta=0;n=0;nl=0
    Tmin=T
    for p in pos:
        t0=P(p['t0']);t1=P(p['t1'])
        d=t0.date();found=None
        while d<=t1.date():
            if d.weekday()==4:
                # ultima barra del venerdi' = chiusura del mercato
                day0=np.datetime64(d.strftime('%Y-%m-%d')+'T00:00');day1=np.datetime64((d+dt.timedelta(days=1)).strftime('%Y-%m-%d')+'T00:00')
                i0=int(np.searchsorted(T,day0));i1=int(np.searchsorted(T,day1))-1
                if i1>i0:
                    L=T[i1]
                    if t0<P(str(L).replace('T',' ').replace('-','.'))-dt.timedelta(minutes=180) and t1>P(str(L).replace('T',' ').replace('-','.')): found=(i0,i1);break
            d+=dt.timedelta(days=1)
        if not found: continue
        i0,i1=found
        def at(mins_before): return max(i0,i1-mins_before)
        sgn=1 if p['side']=='buy' else -1;k=sgn*p['vol']*100*cv;comm=p['pnl']-p['gross']
        n+=1
        if rule=='tutto_L-60': px=cl[at(60)]
        elif rule=='tutto_L-180': px=cl[at(180)]
        elif rule=='utente':  # da L-180 chiudi in positivo, altrimenti a L-30
            px=None
            for i in range(at(180),at(30)+1):
                if k*(cl[i]-p['entry'])>0: px=cl[i];break
            if px is None: px=cl[at(30)];nl+=1
        newg=k*(px-p['entry']);delta+=(newg+comm)-p['pnl']
    return delta,n,nl
for c,mem in COMBO.items():
    tot=0;res={'tutto_L-60':0,'tutto_L-180':0,'utente':0};nn=0;nlose=0
    for y in ('2013','2025'):
        for e,lv in mem:
            pos,_,_=positions(deals(path(e,lv,y)),y)
            tot+=sum(p['pnl'] for p in pos)
            for r in res:
                d,n,nl=simulate(r,pos,y);res[r]+=d
                if r=='utente': nn+=n;nlose+=nl
    print(c,'netto oro 2013+2025',round(tot),'| tutto a chiusura-60min',round(res['tutto_L-60']),f"({100*res['tutto_L-60']/tot:+.1f}%)",'| tutto a chiusura-3h',round(res['tutto_L-180']),f"({100*res['tutto_L-180']/tot:+.1f}%)",'| regola Claudio',round(res['utente']),f"({100*res['utente']/tot:+.1f}%)",'| posizioni toccate',nn,'di cui chiuse in perdita alle 22:30',nlose)
