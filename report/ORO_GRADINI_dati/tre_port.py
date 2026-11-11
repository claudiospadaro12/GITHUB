# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
import json,itertools
from tre_calc import *
R=json.load(open('oro_res.json'));G=json.load(open('gtp_res.json'))
W={x['name']:x for x in json.load(open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/wim_full_88_passate.json'))}
def eqdd(e,lv,y):
    if e=='DTP': return W[f'DTP_DaytradeProMax9DDlowrisk_{y}']['eqDDpct']
    if e=='GTP': return G[f'COMBO_{y}']['ddEp']
    return R[f'{lv}_{e}_80000_{y}']['ddEp']
PORT={
 'P1':[('160k',[('GB','L0'),('GR','L3')]),('80k',[('DTP','on'),('GTP','COMBO')]),('80k',[('PH','L1')])],
 'P2':[('160k',[('GB','L0'),('PH','L3')]),('80k',[('GTP','COMBO')]),('80k',[('DTP','on'),('GR','L3')])],
 'P3':[('160k',[('GB','L0'),('PH','L3')]),('80k',[('DTP','on')]),('80k',[('GTP','COMBO'),('GR','L3')])],
 'P4':[('160k',[('GB','L0'),('GR','L3')]),('80k',[('DTP','on')]),('80k',[('PH','L1'),('GTP','COMBO')])],
}
def daily_acc(members,y,cost=True):
    ev=[]
    for e,lv in members: ev+=series(e,lv,y,cost)
    d=collections.defaultdict(float)
    for t,v,dr,vol,ty,sym in ev: d[t[:10]]+=v
    return d
def posint(members,y):
    """intervalli (t0,t1,lato) dell'oro: lato 'L' per buy-in..sell-out, 'S' per sell-in..buy-out (per volume, coda FIFO semplice)"""
    ev=[]
    for e,lv in members:
        if e=='DTP': continue
        ev+=[(x['t'],x['dr'],x['ty'],x['vol']) for x in D[(e,lv,y)] if x['sym'].startswith('XAU')]
    ev.sort()
    return ev
def overlap(mA,mB,y):
    """frazione di tempo dell'anno in cui A ha lordo long e B lordo short (o viceversa)"""
    def line(m):
        evs=posint(m,y); L=S=0.0; out=[]
        for t,dr,ty,v in evs:
            if dr=='in':
                if ty=='buy': L+=v
                else: S+=v
            else:
                if ty=='sell': L-=v
                else: S-=v
            out.append((t,max(L,0),max(S,0)))
        return out
    a=line(mA); b=line(mB)
    import bisect
    ts=sorted(set([x[0] for x in a]+[x[0] for x in b]))
    ia=ib=0; la=sa=lb=sb=0.0; opp=0; tot=0; nopp_events=0; was=False
    def p(t): return dt.datetime.strptime(t,'%Y.%m.%d %H:%M:%S')
    prev=None; secs_opp=0.0
    for t in ts:
        while ia<len(a) and a[ia][0]<=t: la,sa=a[ia][1],a[ia][2]; ia+=1
        while ib<len(b) and b[ib][0]<=t: lb,sb=b[ib][1],b[ib][2]; ib+=1
        if prev is not None and was: secs_opp+=(p(t)-p(prev)).total_seconds()
        now=(la>0 and sb>0) or (sa>0 and lb>0)
        if now and not was: nopp_events+=1
        was=now; prev=t
    return secs_opp/3600.0,nopp_events
def _main():
  for name,P in PORT.items():
      print('=====',name)
      tot=dict(net=[0,0,0]); jd=[collections.defaultdict(float) for _ in YY]
      for size,mem in P:
          k=2 if size=='160k' else 1
          r=metrics(mem); r0=metrics(mem,cost=False)
          bound=[sum(eqdd(e,lv,y) for e,lv in mem) for y in YY]
          pfy=[round(x,2) for x in r['pf']]
          print(size,' + '.join(a+'_'+b for a,b in mem),'| netto/anno (centrale, 80k):',[round(x) for x in r['net']],'media',round(r['avg']),'| tester senza costi media',round(r0['avg']),'| PF',round(r['pftot'],2),'per anno',pfy,'| DD realizzato',round(100*r['rd']/DEP,1),'%| peggior giorno',round(100*r['worst']/DEP,1),'% | DD equity limite sup. per anno',[round(b,1) for b in bound],'| x',k,'->',round(r['avg']*k))
          for i,y in enumerate(YY):
              d=daily_acc(mem,y)
              for dd_,v in d.items(): jd[i][dd_]+=v*k
      CAP=320000.0
      print('  portafoglio (2x160k+80k+80k = 320k di capitale equivalente):')
      totavg=0
      for i,y in enumerate(YY):
          s=sum(jd[i].values()); totavg+=s/3
          c=0;pk=0;dd=0
          for d in sorted(jd[i]): c+=jd[i][d];pk=max(pk,c);dd=max(dd,pk-c)
          print('   ',y,'netto',round(s),f'| DD realizzato congiunto {100*dd/CAP:.1f}%','| peggior giorno',round(min(jd[i].values())),f'({100*min(jd[i].values())/CAP:.1f}% di 320k)')
      print('   media annua totale',round(totavg))
      ms=[m for s,m in P]
      for (i,j) in [(0,1),(0,2),(1,2)]:
          oh=0;oe=0
          for y in YY:
              h,e_=overlap(ms[i],ms[j],y); oh+=h;oe+=e_
          print(f'   posizioni oro opposte conto{i+1}/conto{j+1}: {oh:.0f} ore in 3 anni, {oe} episodi')

if __name__=='__main__': _main()
