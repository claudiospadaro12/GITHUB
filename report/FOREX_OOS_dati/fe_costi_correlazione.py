#!/usr/bin/env python3
"""F-E: costi FTMO e correlazione sui set forex. Uso: python3 fe_costi_correlazione.py <scratchpad> -> fe_res.json
Anni vecchi: <scratchpad>/forex4k/z*/*/*/*/report/*.htm ; anni nuovi: <scratchpad>/oos/w*/*/*/*/report/*.htm ; oro: <scratchpad>/oro_res.json"""
import sys,re,glob,json,collections,datetime,math
SP=sys.argv[1]
def fl(s):
    s=(s or '').replace(' ','').replace('\xa0','').replace(',','')
    try:return float(s)
    except:return 0.0
def leggi(f):
    t=open(f,'rb').read().decode('utf-16','replace')
    rows=re.findall(r'<tr[^>]*>(.*?)</tr>',t[t.find('Affari'):],re.S);hdr=None;deals=[]
    for rr in rows:
        c=[re.sub(r'<[^>]+>','',x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',rr,re.S)]
        if hdr is None and 'Direzione' in c and 'Affare' in c: hdr=c;continue
        if hdr and len(c)>=len(hdr) and re.match(r'\d{4}\.\d\d\.\d\d',c[0]): deals.append(c)
    ix={n:i for i,n in enumerate(hdr)};day=collections.defaultdict(float);lots=0.0;nin=0;comm=0.0;net=0.0
    for c in deals:
        if c[ix['Tipo']]=='balance': continue
        comm+=fl(c[ix['Commissioni']])
        if c[ix['Direzione']]=='in': lots+=fl(c[ix['Volume']]);nin+=1
        if c[ix['Direzione']] in('out','in/out','out/in'):
            v=fl(c[ix['Profitto']])+fl(c[ix['Commissioni']])+fl(c[ix['Swap']]);day[c[0][:10]]+=v;net+=v
    return dict(lots=lots,nin=nin,comm_tester=comm,net_deals=net,daily=dict(day))
res={}
for f in glob.glob(SP+'/forex4k/z*/*/*/*/report/*.htm'):
    folder=f.split('/')[-4]
    if folder in res: continue
    res[folder]=leggi(f)
for f in glob.glob(SP+'/oos/w*/*/*/*/report/*.htm'):
    folder=f.split('/')[-4]
    if folder in res: continue
    res[folder]=leggi(f)
json.dump(res,open('fe_res_raw.json','w'))
print(len(res),'report letti')
