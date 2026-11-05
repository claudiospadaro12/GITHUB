import re,glob,json,collections
res=json.load(open('forex4k_res.json'))
out={}
for f in glob.glob('forex4k/z*/*/*/*/report/*.htm'):
    folder=f.split('/')[3]
    if folder in out: continue
    t=open(f,'rb').read().decode('utf-16','replace')
    flat=re.sub(r'<[^>]+>','|',t);flat=re.sub(r'[\s|]+','|',flat)
    def g(p):
        m=re.search(p,flat);return m and m.group(1)
    num=lambda s: float(s.replace('|','').replace(',','')) if s else None
    rel=re.search(r'Equità\|Drawdown\|Relativa:\|([\d.]+)%\|\(([\d|,.]+)\)',flat)
    relb=re.search(r'Bilancio\|Drawdown\|Relativo:\|([\d.]+)%',flat)
    # deals
    rows=re.findall(r'<tr[^>]*>(.*?)</tr>',t[t.find('Affari'):],re.S)
    deals=[]
    for r in rows:
        c=[re.sub(r'<[^>]+>','',x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',r,re.S)]
        if len(c)>=13 and re.match(r'\d{4}\.\d\d\.\d\d',c[0]): deals.append(c)
    # find indices by header: Ora,Affare,Simbolo,Tipo,Direzione,Volume,Prezzo,Ordine,Commissioni,Spese,Swap,Profitto,Bilancio
    day=collections.defaultdict(float);bal0=None;prevbal=None
    nin=0;nmin=0;maxlot=0
    for c in deals:
        try:
            d=c[0][:10];prof=float(c[-3].replace(' ','').replace(',','')) if False else None
        except: pass
    # robust: columns from header
    hdr=None
    for r in rows:
        c=[re.sub(r'<[^>]+>','',x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',r,re.S)]
        if 'Direzione' in c and 'Affare' in c: hdr=c;break
    if hdr:
        ix={n.strip():i for i,n in enumerate(hdr)}
        def fl(s):
            s=s.replace(' ','').replace('\xa0','').replace(',','')
            try:return float(s)
            except:return 0.0
        for c in deals:
            if len(c)<len(hdr):continue
            dire=c[ix['Direzione']]
            if dire=='in':
                v=fl(c[ix['Volume']]);nin+=1;maxlot=max(maxlot,v)
                if v<=0.0101:nmin+=1
            if dire in('out','in/out','out/in') or c[ix['Tipo']]=='balance':
                if c[ix['Tipo']]=='balance':continue
                day[c[0][:10]]+=fl(c[ix['Profitto']])+fl(c[ix['Commissioni']])+fl(c[ix['Swap']])
    worst=min(day.values()) if day else None
    d10=sum(1 for v in day.values() if v<=-400)
    out[folder]=dict(rel=rel and float(rel.group(1)),relAbs=rel and num(rel.group(2)),relBal=relb and float(relb.group(1)),
      worstday=worst,days_le10=d10,nin=nin,nmin=nmin,maxlot=maxlot,symbols=g(r'Simboli:\|(\d+)'),lev=g(r'Leva:\|([\d:]+)'),dep=g(r'Deposito\|Iniziale:\|([\d|,.]+)'),
      margin=g(r'Livello\|di\|Margine:\|([\d.]+%)'),loss_max_cons=g(r'Massimale\|perdite\|consecutive[^|]*\|[^|]*\|[^|]*\|[^|]*:\|([^|]+\|[^|]+)') )
    out[folder]['worstday_pct']=worst/4000*100 if worst is not None else None
json.dump(out,open('forex4k_htm.json','w'),indent=1)
print(len(out))
