import re,glob,collections,sys
def load(p):
    b=open(p,'rb').read()
    for enc in('utf-16','utf-8'):
        try:
            t=b.decode(enc)
            if 'Strategy Tester' in t: break
        except: pass
    t=re.sub(r'<[^>]*>','\n',t); return [x.strip() for x in t.split('\n') if x.strip()]
def num(s): return float(s.replace(' ','').replace('\xa0','').replace(',',''))
def deals(L):
    i=max(k for k,x in enumerate(L) if x=='Affari'); h=L.index('Commento',i)
    rows=[];cur=None
    for c in L[h+1:]:
        if re.match(r'^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$',c): cur=[c]; rows.append(cur)
        elif cur is not None: cur.append(c)
    out=[]
    for r in rows:
        if len(r)>=12 and r[3] in('buy','sell') and r[4]=='out':
            try: out.append((r[0],num(r[10])+num(r[8])+num(r[9])))
            except: pass
    return out
def pf(x):
    w=sum(p for p in x if p>0); l=-sum(p for p in x if p<0); return w/l if l else float('inf')
for name,dep in (('PH2026_L1_80000_2026',80000),('PH2026_L1_5000_2026',5000)):
    f=glob.glob(name+'/*/report/*.htm')[0]; L=load(f)
    keys=['TradeFrequency','Risk','MaxAllowedDD','PropFirmMaxDailyDD','Randomization','OnlyUp','ST1_MagicNumber','EnableNFP_Filter','NFP_MinutesBefore','NFP_MinutesAfter','FridayStopHour']
    cfg={}
    for x in L:
        m=re.match(r'^([A-Za-z0-9_]+)=(.*)$',x)
        if m and m.group(1) in keys and m.group(1) not in cfg: cfg[m.group(1)]=m.group(2)
    d=deals(L); pr=[p for _,p in d]
    mon=collections.defaultdict(float); 
    for t,p in d: mon[t[:7]]+=p
    sub=[p for t,p in d if '2026.10.20'<=t[:10]<='2026.11.13']
    wk=(len(L) and 45.4)
    print('==',name,'trades chiusi',len(d),'PF',round(pf(pr),2),'win%',round(100*sum(1 for p in pr if p>0)/len(pr),1),'net',round(sum(pr)),'%',round(100*sum(pr)/dep,1),'op/sett',round(len(d)/45.4,1))
    print('  input:',cfg)
    print('  mensile (EUR | % deposito):',{k:(round(v),round(100*v/dep,1)) for k,v in sorted(mon.items())})
    print('  20/10-13/11: op',len(sub),'PF',round(pf(sub),2) if sub else None,'net',round(sum(sub)),'win%',round(100*sum(1 for p in sub if p>0)/max(1,len(sub)),1))
    # PF per trimestre e per periodo 27/01 in poi
    s2=[p for t,p in d if t[:10]>='2026.01.27']; print('  dal 27/01: op',len(s2),'PF',round(pf(s2),2),'| prima del 27/01: op',len(d)-len(s2))
