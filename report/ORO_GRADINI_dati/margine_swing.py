import datetime as dt,json
from ftmo_costi_calc import *
COMBO={'P1 (160k)':[('PH','L1'),('GB','L0'),('DTP','on')],'P3 (80k)':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4 (80k)':[('GR','L3'),('GB','L0'),('DTP','on')]}
BASE={'EUR':1.1,'GBP':1.3,'AUD':0.65,'NZD':0.6,'USD':1.0,'CAD':0.75,'CHF':1.1}   # USD per unita di valuta base, approssimato
def P(t): return dt.datetime.strptime(t,'%Y.%m.%d %H:%M:%S')
out={}
for name,mem in COMBO.items():
    out[name]={}
    for y in YY:
        fx=EURUSD[y]; ev=[]
        for e,lv in mem:
            for p,d,side in pos(deals_px(path(e,lv,y))):
                if p['sym'].startswith('XAU'): m_usd=p['vol']*100*p['px']; kind='g'
                else:
                    m_usd=p['vol']*100000*BASE.get(p['sym'][:3],1.0); kind='f'
                ev.append((P(p['t']),+1,m_usd,kind)); ev.append((P(d['t']),-1,m_usd,kind))
        ev.sort(key=lambda x:(x[0],x[1]))
        g=f=0.0; mg=mf=mt=0.0
        for t,s,m,k in ev:
            if k=='g': g+=s*m
            else: f+=s*m
            mg=max(mg,g); mf=max(mf,f)
            mt=max(mt,g/15+f/30)
        out[name][y]=dict(oro_notional_max=mg*fx, forex_notional_max=mf*fx, margin_swing_max_eur=mt*fx, margin_std_max_eur=max(0,0)+0)
        # margine Standard
        g=f=0.0; ms=0.0
        for t,s,m,k in ev:
            if k=='g': g+=s*m
            else: f+=s*m
            ms=max(ms,g/50+f/100)
        out[name][y]['margin_std_max_eur']=ms*fx
        print(name,y,'oro nozionale max %.0f EUR | margine Swing max %.0f EUR (%.0f%% di 80k) | Standard %.0f EUR (%.0f%%)'%(mg*fx,mt*fx,100*mt*fx/80000,ms*fx,100*ms*fx/80000))
json.dump(out,open('margine_swing.json','w'))
