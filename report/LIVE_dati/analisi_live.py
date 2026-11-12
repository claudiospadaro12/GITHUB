import sys,statistics as st; sys.path.insert(0,'.')
from leggi import *
import datetime as dt
def P(s): return dt.datetime.strptime(s,'%Y.%m.%d %H:%M:%S')
def nome_ea(c):
    c=c or ''
    c=re.sub(r'_\d+$','',c)
    for k,v in (('FinlabX','Finlab X'),('GoldBot_One','Goldbot One'),('Phantom','Gold Phantom'),('Reaper','Gold Reaper'),('CF ','CF'),('ORB OTT','ORB OTT'),('DAX Apertura','DAX Apertura EU RETEST'),('DZR','DZR')):
        if c.startswith(k) or k in c: return v
    return 'non attribuito (ordine senza commento)'
def analizza(f,iniz,shift_h=0):
    pos,deals,orders=carica(f)
    oc={o[1]:o[11] for o in orders if o[9]=='filled'}
    out={}
    trades=[d for d in deals if d['ty'] in ('buy','sell')]
    for d in trades: d['net']=d['prof']+d['comm']+d['swap']+d['fee']
    # per EA (posizioni)
    ea=collections.defaultdict(list)
    for p in pos:
        p['net']=p['prof']+p['comm']+p['swap']; p['ea']=nome_ea(oc.get(p['id'])); ea[p['ea']].append(p)
    tab=[]
    for k,l in sorted(ea.items(),key=lambda kv:sum(p['net'] for p in kv[1])):
        w=[p['net'] for p in l if p['net']>0]; ls=[p['net'] for p in l if p['net']<=0]
        tab.append(dict(ea=k,n=len(l),win=100*len(w)/len(l),net=sum(p['net'] for p in l),pf=(sum(w)/-sum(ls) if ls and sum(ls)!=0 else None),worst=min(p['net'] for p in l),best=max(p['net'] for p in l),lots=sum(p['vol'] for p in l),comm=sum(p['comm'] for p in l),swap=sum(p['swap'] for p in l)))
    out['ea']=tab
    # per simbolo
    sy=collections.defaultdict(list)
    for p in pos: sy[p['sym']].append(p)
    out['sym']=[dict(sym=k,n=len(l),net=sum(p['net'] for p in l),lots=sum(p['vol'] for p in l),comm=sum(p['comm'] for p in l),swap=sum(p['swap'] for p in l)) for k,l in sy.items()]
    # giornaliero (deal), con shift
    day=collections.defaultdict(float); bal_start={}
    prev=None
    for d in deals:
        t=P(d['t'])-dt.timedelta(hours=shift_h); k=t.strftime('%Y-%m-%d')
        if d['ty'] in ('buy','sell'): day[k]+=d['net']
    out['day']=dict(sorted(day.items()))
    # bilancio path
    bal=[(d['t'],d['bal']) for d in deals]
    out['bal']=bal
    # soglie
    base=iniz
    dl=sorted(day.items(),key=lambda kv:kv[1])
    out['peggiori']=[(k,v,100*v/base) for k,v in dl[:5]]
    out['n45']=sum(1 for v in day.values() if v<=-0.045*base); out['n30']=sum(1 for v in day.values() if v<=-0.03*base)
    out['migl']=sorted(day.items(),key=lambda kv:-kv[1])[:3]
    # DD saldo (realizzato)
    pk=iniz;dd=0;minb=iniz;ddd=None
    for t,b in bal:
        if b>pk: pk=b
        if pk-b>dd: dd=pk-b;ddd=t
        minb=min(minb,b)
    out['dd']=(dd,100*dd/iniz,ddd,minb)
    out['tot']=dict(n=len(pos),net=sum(p['net'] for p in pos),giorni_trade=len(day),giorni_neg=sum(1 for v in day.values() if v<0),
       comm=sum(p['comm'] for p in pos),swap=sum(p['swap'] for p in pos),lots=sum(p['vol'] for p in pos),
       gross_w=sum(p['net'] for p in pos if p['net']>0),gross_l=sum(p['net'] for p in pos if p['net']<=0),
       t0=pos[0]['t0'],t1=pos[-1]['t1'],ordini=len(orders),
       canc=sum(1 for o in orders if o[9]=='canceled'),fill=sum(1 for o in orders if o[9]=='filled'))
    # slippage su posizioni con SL/TP
    sl=[];tp=[];ts=[]
    for p in pos:
        if p['t1'][-8:]=='00:00' or p['t1'][-5:]=='00:00': pass
        x=p['p1']
        for lab,lvl,lst in (('sl',p['sl'],sl),('tp',p['tp'],tp)):
            if lvl is None: continue
            diff=(x-lvl) if p['ty']=='buy' else (lvl-x)   # >0 = a favore del cliente, <0 = slippage contro
            if abs(x-lvl)<=3.0*(p['p0'] if p['sym']!='XAUUSD' else 1.0)*(1 if p['sym']=='XAUUSD' else 0.0001):  # ≤3 USD oro, ≤0,03% altri
                lst.append((diff,p['sym'],p['id']))
    out['slip_sl']=sl; out['slip_tp']=tp
    return out
if __name__=='__main__':
    R=analizza('reale.xlsx',7500.0)
    T=analizza('trial.xlsx',80000.0)
    import pprint
    for nm,o,ini in (('REALE',R,7500.),('TRIAL',T,80000.)):
        print('=====',nm); print(o['tot']); 
        for r in o['ea']: print('  EA',r['ea'],r['n'],'win%%=%.0f net=%.2f pf=%s worst=%.2f best=%.2f lots=%.2f comm=%.2f swap=%.2f'%(r['win'],r['net'],('%.2f'%r['pf'] if r['pf'] else '-'),r['worst'],r['best'],r['lots'],r['comm'],r['swap']))
        for r in o['sym']: print('  SYM',r)
        print('  peggiori giorni',o['peggiori']); print('  migliori',o['migl']); print('  gg>=4,5%%: %d, gg>=3%%: %d'%(o['n45'],o['n30']))
        print('  DD saldo realizzato',o['dd']); print('  giorni con trade',o['tot']['giorni_trade'],'negativi',o['tot']['giorni_neg'])
        for lab in ('slip_sl','slip_tp'):
            l=[x[0] for x in o[lab]]
            if l: print('  ',lab,len(l),'media %.3f mediana %.3f min %.3f max %.3f'%(st.mean(l),st.median(l),min(l),max(l)))
