import re,glob,collections,sys,json,os,datetime as dt
SP='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad'
sys.path.insert(0,SP)
from tre_lib import deals
from ftmo_costi_calc import deals_px,pos
NFP={'2013':['2013-01-04','2013-02-01','2013-03-08','2013-04-05','2013-05-03','2013-06-07','2013-07-05','2013-08-02','2013-09-06','2013-10-22','2013-11-08','2013-12-06'],
'2020':['2020-01-10','2020-02-07','2020-03-06','2020-04-03','2020-05-08','2020-06-05','2020-07-02','2020-08-07','2020-09-04','2020-10-02','2020-11-06','2020-12-04'],
'2025':['2025-01-10','2025-02-07','2025-03-07','2025-04-04','2025-05-02','2025-06-06','2025-07-03','2025-08-01','2025-09-05','2025-12-16']}
def inputs(d):
    h=glob.glob(d+'/*/report/*.htm')
    if not h: return None
    b=open(h[0],'rb').read(400000); t=b.decode('utf-16','ignore') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    t=re.sub(r'<[^>]+>','\n',t).replace('&nbsp;',' ')
    return dict(re.findall(r'^\s*([A-Za-z_0-9]+)=([^\n]*)$',t,flags=re.M))
def refer(d):
    f=glob.glob(d+'/*/REFERTO_ANNO80K_TRANCHE.txt')
    if not f: return None
    t=open(f[0],encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)',t)
    st=re.search(r'STATO (\w+)',t); q=re.search(r'qualita (\d+)%',t); ic=re.search(r'input imposti confermati dal report: (\w+)',t)
    if not m: return dict(stato=st and st.group(1),net=None)
    return dict(stato=st.group(1),ops=int(m.group(1)),net=float(m.group(2)),pf=m.group(3),ddp=float(m.group(5)),q=int(q.group(1)),conf=ic and ic.group(1))
def wd(d):
    h=glob.glob(d+'/*/report/*.htm')
    if not h: return None
    day=collections.defaultdict(float)
    for e in deals(h[0]): day[e['t'][:10]]+=e['v']
    return min(day.values())
def thru(d,y):
    h=glob.glob(d+'/*/report/*.htm')
    if not h: return None
    P=pos(deals_px(h[0])); n=0
    for ds in NFP[y]:
        dd=dt.date.fromisoformat(ds); hh=13.5 if 3<=dd.month<=10 else 14.5
        t=dt.datetime(dd.year,dd.month,dd.day,int(hh),int((hh%1)*60))
        for p,c,s in P:
            a=dt.datetime.strptime(p['t'],'%Y.%m.%d %H:%M:%S'); b=dt.datetime.strptime(c['t'],'%Y.%m.%d %H:%M:%S')
            if a<=t<=b: n+=1
    return n
res={}
for d in sorted(glob.glob(SP+'/nfpoff_oro/ANNO_ORO_GRADINI_NFPOFFORO_*/NFPOFF_*')):
    k=os.path.basename(d); m=re.match(r'NFPOFF_N0_R(\d)_(L\d)_(\w\w)_160000_(\d{4})',k); rep,liv,ea,y=m.groups()
    b=SP+'/d160oro/D160_R%s_%s_%s_160000_%s'%(rep,liv,ea,y)
    if not os.path.isdir(b): b=SP+'/d160oro/D160_R1_%s_%s_160000_%s'%(liv,ea,y) if ea=='GB' else None
    r=refer(d); r['wd']=wd(d); r['thru']=thru(d,y); r['inp']=inputs(d)
    bb=refer(b) if b and os.path.isdir(b) else None
    if bb and bb.get('net') is not None: bb['wd']=wd(b); bb['thru']=thru(b,y); bb['inp']=inputs(b)
    res[k]=(r,bb,b)
ok=True
for k,(r,bb,b) in sorted(res.items(), key=lambda x:(x[0].split('_')[-1],x[0])):
    flag=''
    if bb and bb.get('net') is not None and r['inp'] and bb['inp']:
        diff={x:(bb['inp'].get(x),r['inp'].get(x)) for x in set(bb['inp'])|set(r['inp']) if bb['inp'].get(x)!=r['inp'].get(x)}
        extra={x:v for x,v in diff.items() if x!='EnableNFP_Filter'}
        flag='altri input diversi: '+(str(extra) if extra else 'NESSUNO')+' | NFP '+str(r['inp'].get('EnableNFP_Filter'))
        if extra or r['inp'].get('EnableNFP_Filter')!='false': ok=False
    print(k.replace('NFPOFF_N0_',''),r['stato'],'q',r.get('q'),'net',r['net'],'| base',bb and bb.get('net'),'|',flag,'| attraverso NFP',r['thru'],'vs',bb and bb.get('thru'))
print('TUTTE VALIDE' if ok else 'ATTENZIONE')
json.dump({k:{'r':{a:b for a,b in v[0].items() if a!='inp'},'b':({a:b for a,b in v[1].items() if a!='inp'} if v[1] else None)} for k,v in res.items()},open(SP+'/nfpoff_oro_res.json','w'),indent=1)
