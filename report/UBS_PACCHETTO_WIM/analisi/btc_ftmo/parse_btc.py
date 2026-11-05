import glob,re,json,sys,collections,datetime as dt
def num(s):
    s=s.replace('\xa0',' ').replace(' ','').replace(',','')
    try: return float(s)
    except: return None
out=[]
for d in sorted(glob.glob('*/')):
    name=d.strip('/')
    m=re.match(r'([A-Z]+)_(.+)_(\d{4})(_21m)?$',name); ea,set_,yr=m.group(1),m.group(2),m.group(3)+(m.group(4) or '')
    hs=glob.glob(name+'/*/report/*.htm')
    if not hs: out.append(dict(name=name,ea=ea,set=set_,yr=yr,err='no report')); continue
    t=open(hs[0],'rb').read().decode('utf-16')
    head=t[:t.find('Ordini')]
    cells=[re.sub(r'\s+',' ',re.sub(r'<[^>]+>','',c)).strip() for c in re.findall(r'<td[^>]*>(.*?)</td>',head,flags=re.S)]
    kv={}
    for i in range(len(cells)-1):
        if cells[i].endswith(':') and cells[i] not in kv: kv[cells[i]]=cells[i+1]
    g=lambda k: num(kv.get(k,'').split('(')[0]) if k in kv else None
    pct=lambda k: (float(re.search(r'\(([\d.]+)%\)',kv[k]).group(1)) if k in kv and re.search(r'\(([\d.]+)%\)',kv[k]) else None)
    r=dict(name=name,ea=ea,set=set_,yr=yr,net=g('Profitto Totale Netto:'),absEqDD=g('Equità Drawdown Assoluta:'),absBalDD=g('Bilancio Drawdown Assoluto:'),
           eqDDmax=g('Equità Drawdown Massima:'),eqDDpct=pct('Equità Drawdown Massima:'),balDDpct=pct('Bilancio Drawdown Massimo:'),
           pf=g('Fattore di Profitto:'),trades=g('Numero di Operazioni di Trading Totali:'),maxlossrun=kv.get('Massima perdite consecutive ($):'),worstTrade=g('La più ampia operazione di trading in perdita:'),
           qual=kv.get('Qualità dello Storico:'),sharpe=g('Indice di Sharpe:'),margin=kv.get('Livello di Margine:'),hold=kv.get('Tempo massimo di tenuta della posizione:'))
    # deals
    i=t.find('Affari',t.find('Ordini')+10)
    seg=t[i:]
    bal=[]
    for row in re.findall(r'<tr[^>]*>(.*?)</tr>',seg,flags=re.S):
        c=[re.sub(r'\s+',' ',re.sub(r'<[^>]+>','',x)).strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',row,flags=re.S)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d',c[0]):
            b=num(c[11]) if len(c)>11 else None
            if b is not None: bal.append((c[0],b,c[3],c[4],c[2],num(c[10]) or 0.0,c[5] if len(c)>5 else ''))
    r['ndeals']=len(bal)
    days=collections.OrderedDict()
    for ts,b,*_ in bal: days[ts[:10]]=b
    keys=list(days); prev=80000.0; worst=0;worstabs=0;n43=0;n5=0;daysloss=[]
    first_target=None;first_breach=None
    for k in keys:
        b=days[k]; dlt=b-prev; p=dlt/prev*100
        if p<worst: worst=p; worstabs=dlt
        if p<=-4.3: n43+=1
        if p<=-5.0: n5+=1
        if first_target is None and b>=88000: first_target=k
        if first_breach is None and b<=72000: first_breach=k
        prev=b
    r.update(worstDayPct=worst,worstDayAbs=worstabs,days43=n43,days5=n5,firstTarget10=first_target,firstBreachBal=first_breach,ndays=len(keys),minBal=min(days.values()) if days else None,endBal=keys and days[keys[-1]])
    out.append(r)
json.dump(out,open('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/btc_ftmo_full.json','w'),ensure_ascii=False)
print(len(out),'parsati; senza report:',[o['name'] for o in out if 'err' in o])
print(json.dumps(out[0],ensure_ascii=False)[:900])
