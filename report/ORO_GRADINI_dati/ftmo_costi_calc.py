# Da lanciare dalla cartella con oro/, gtp_anni/, wim_risultati/ (vedi tre_lib.py). Uso: python3 -I
import re,glob,collections,datetime as dt,pickle,os,json
from tre_lib import path,num
YY=('2013','2020','2025'); EURUSD={'2013':0.752,'2020':0.877,'2025':0.888}   # EUR per USD (media annua, come equity_vero)
def deals_px(p):
    b=open(p,'rb').read(); t=b.decode('utf-16') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    t=t[t.find('Affari'):]; ev=[]
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',r,flags=re.S|re.I)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in('buy','sell'):
            ev.append(dict(t=c[0],sym=c[2],ty=c[3],dr=c[4],vol=num(c[5]),px=num(c[6]),com=num(c[8]),swap=num(c[9]),prof=num(c[10])))
    ev.sort(key=lambda e:e['t']); return ev
def pos(ev):
    op={'long':[],'short':[]};out=[]
    for d in ev:
        if d['dr']=='in': op['long' if d['ty']=='buy' else 'short'].append(d)
        else:
            side='long' if d['ty']=='sell' else 'short'
            c=[p for p in op[side] if p['sym']==d['sym'] and abs(p['vol']-d['vol'])<1e-6] or [p for p in op[side] if p['sym']==d['sym']]
            if not c: continue
            p=c[0]; op[side].remove(p); out.append((p,d,side))
    return out
# swap FTMO in "points" (long, short) dalla scheda Simboli; valore del punto in USD per lotto (approssimato)
SW={'XAUUSD':(-92.26,-4.2),'EURUSD':(-10.27,0.13),'GBPUSD':(-4.85,-6.64),'USDJPY':(0.78,-19.29),'USDCHF':(0.57,-14.59),'AUDUSD':(-3.08,-8.27),'NZDUSD':(-4.85,0),'USDCAD':(0.56,-10.28),'EURGBP':(-9.81,0.07),'EURJPY':(0.38,-13.25),'GBPJPY':(1.08,-33.15),'AUDJPY':(0.84,-15.19),'EURCHF':(0.4,-14.08),
 'AUDCAD':(0.68,-9.8),'AUDCHF':(0.7,-11.3),'AUDNZD':(0.78,-11.51),'GBPAUD':(-12.12,-2.2),'GBPCAD':(0.51,-20.84),'GBPCHF':(0.77,-28.57),'GBPNZD':(0.37,-23.73),'CADJPY':(0.22,-7.72),'CADCHF':(0.28,-7.9),'EURAUD':(-17.59,0.84),'EURCAD':(-3.61,-4.59),'EURNZD':(-6.22,-3.99),'NZDCAD':(-1.86,-3.18),'NZDCHF':(0.23,-7.36),'NZDJPY':(0.2,-7.55),'CHFJPY':(-15.82,0.47)}
QF={'USD':1.0,'JPY':0.75,'CHF':1.1,'CAD':0.75,'GBP':1.3,'AUD':0.65,'NZD':0.6,'EUR':1.1}
def pointusd(sym):
    if sym.startswith('XAU'): return 1.0
    return QF.get(sym[3:6],1.0)
def nights(t0,t1):
    d0=dt.datetime.strptime(t0,'%Y.%m.%d %H:%M:%S').date(); d1=dt.datetime.strptime(t1,'%Y.%m.%d %H:%M:%S').date()
    n=0;wed=0;d=d0
    while d<d1:
        if d.weekday()<5:
            w=3 if d.weekday()==2 else 1; n+=w
        d+=dt.timedelta(days=1)
    return n
def cost_ea(e,lv,y,comm_mult=1.0):
    ev=deals_px(path(e,lv,y)); P=pos(ev)
    prof=sum(x['prof'] for x in ev); bcm_com=sum(x['com'] for x in ev); bcm_sw=sum(x['swap'] for x in ev)
    fx=EURUSD[y]; com=0.0; sw=0.0
    for p,d,side in P:
        lots=p['vol']; sym=p['sym']
        if sym.startswith('XAU'): com+=0.0014/100*(p['px']*100*lots)*comm_mult          # USD, andata+ritorno (assunzione)
        else: com+=5.0*lots*comm_mult                                                    # USD, andata+ritorno (assunzione)
        k=nights(p['t'],d['t'])
        if sym in SW:
            pts=SW[sym][0 if side=='long' else 1]
            sw+=pts*pointusd(sym)*lots*k
    return dict(prof_eur=prof,bcm_com_eur=bcm_com,bcm_swap_eur=bcm_sw,ftmo_com_eur=-com*fx,ftmo_swap_eur=sw*fx,lots=sum(p['vol'] for p,d,s in P),npos=len(P))
if __name__=='__main__':
    COMBO={'P1':[('PH','L1'),('GB','L0'),('DTP','on')],'P3':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4':[('GR','L3'),('GB','L0'),('DTP','on')]}
    res={}
    for c,mem in COMBO.items():
        res[c]={}
        for y in YY:
            agg=collections.Counter()
            for e,lv in mem:
                r=cost_ea(e,lv,y)
                for k,v in r.items(): agg[k]+=v
            res[c][y]=dict(agg)
            a=agg;print(c,y,'profitto lordo %.0f | BCM comm %.0f swap %.0f | FTMO comm %.0f swap %.0f | lotti %.0f pos %d'%(a['prof_eur'],a['bcm_com_eur'],a['bcm_swap_eur'],a['ftmo_com_eur'],a['ftmo_swap_eur'],a['lots'],a['npos']))
    json.dump(res,open('ftmo_costi_calc.json','w'))
