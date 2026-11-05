exec(open('trio_corr.py').read().split("CAND=[")[0])
import numpy as np
def al(a,b,y):
    d0=dt.date(int(y),1,1);n=366 if int(y)%4==0 else 365
    days=[(d0+dt.timedelta(i)).strftime('%Y.%m.%d') for i in range(n)]
    return np.array([a.get(x,0.0) for x in days]),np.array([b.get(x,0.0) for x in days])
T80={y:trio80(y) for y in ('2013','2020','2025')}
for s in ['DTP_DaytradeProMax9DDlowrisk','DTP_DaytradeProMax20DDmediumrisk','DTP_DaytradeProMax50DDhighrisk']:
    for y in ('2013','2020','2025'):
        ev=load_deals(first(f'forex4k/z*/*/{s}_{y}/*/report/*.htm'))
        evx=[e for e in ev if not e[2].startswith('XAU')];evg=[e for e in ev if e[2].startswith('XAU')]
        a,t=al(daily(evx,y),T80[y],y);g,_=al(daily(evg,y),T80[y],y)
        tot=sum(e[1] for e in ev)
        print(s[4:],y,'corr senza oro %.3f'%np.corrcoef(a,t)[0,1],'| oro: %d op, netto %.0f su %.0f'%(sum(1 for e in evg if e[3]=='in'),g.sum(),tot),'corr solo oro %.3f'%(np.corrcoef(g,t)[0,1] if g.std()>0 else float('nan')))
