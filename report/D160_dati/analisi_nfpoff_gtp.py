import re,glob,collections,datetime as dt,sys,os
SP='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad'
sys.path.insert(0,SP)
from tre_lib import deals
from ftmo_costi_calc import deals_px,pos
def refer(d):
    f=glob.glob(d+'/*/REFERTO_ANNO80K_TRANCHE.txt')[0]
    t=open(f,encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)',t)
    st=re.search(r'STATO (\w+)',t); q=re.search(r'qualita (\d+)%',t); ic=re.search(r'input imposti confermati dal report: (\w+)',t); imp=re.search(r'input imposti dal \.ini \((\d+)\): ([^\n]*?)\s{2,}\(',t); so=re.search(r'righe stop out nei giornali (\d+), no money (\d+)',t)
    return dict(stato=st.group(1),ops=int(m.group(1)),net=float(m.group(2)),pf=m.group(3),ddp=float(m.group(5)),q=int(q.group(1)),conf=ic and ic.group(1),imp=imp and imp.group(2),so=so.groups())
def wd(d):
    h=glob.glob(d+'/*/report/*.htm')[0]; day=collections.defaultdict(float)
    for e in deals(h): day[e['t'][:10]]+=e['v']
    return min(day.values())
NFP={'2013':['2013-01-04','2013-02-01','2013-03-08','2013-04-05','2013-05-03','2013-06-07','2013-07-05','2013-08-02','2013-09-06','2013-10-22','2013-11-08','2013-12-06'],
'2020':['2020-01-10','2020-02-07','2020-03-06','2020-04-03','2020-05-08','2020-06-05','2020-07-02','2020-08-07','2020-09-04','2020-10-02','2020-11-06','2020-12-04'],
'2025':['2025-01-10','2025-02-07','2025-03-07','2025-04-04','2025-05-02','2025-06-06','2025-07-03','2025-08-01','2025-09-05','2025-12-16']}
def thru(d,y):
    P=pos(deals_px(glob.glob(d+'/*/report/*.htm')[0])); n=0; near=0
    for ds in NFP[y]:
        dd=dt.date.fromisoformat(ds); h=13.5 if 3<=dd.month<=10 else 14.5
        t=dt.datetime(dd.year,dd.month,dd.day,int(h),int((h%1)*60))
        for p,c,s in P:
            a=dt.datetime.strptime(p['t'],'%Y.%m.%d %H:%M:%S'); b=dt.datetime.strptime(c['t'],'%Y.%m.%d %H:%M:%S')
            if a<=t<=b: n+=1
            if abs((a-t).total_seconds())<=7200 or abs((b-t).total_seconds())<=7200: near+=1
    return n,near
tn=tb=0
for y in ('2013','2020','2025'):
    a=SP+'/nfpoff_gtp/NFPOFF_N0_R1_COMBO_GTP_160000_'+y; b=SP+'/d160gtp/D160_GTP_COMBO_160000_'+y
    ra,rb=refer(a),refer(b)
    wa,wb=wd(a),wd(b); ta,na=thru(a,y); tb_,nb=thru(b,y)
    print(y,'NFP OFF: stato %s q%d conf %s imp [%s] ops %d net %.0f PF %s DD %.2f%% so %s wd %.0f | attraverso NFP %d, entro 2h %d'%(ra['stato'],ra['q'],ra['conf'],ra['imp'],ra['ops'],ra['net'],ra['pf'],ra['ddp'],ra['so'],wa,ta,na))
    print(y,'RIFER. : stato %s q%d ops %d net %.0f PF %s DD %.2f%% wd %.0f | attraverso NFP %d, entro 2h %d'%(rb['stato'],rb['q'],rb['ops'],rb['net'],rb['pf'],rb['ddp'],wb,tb_,nb))
    tn+=ra['net'];tb+=rb['net']
print('netto 3 anni NFP-off %.0f vs rif %.0f (%+.1f%%)'%(tn,tb,100*(tn/tb-1)))
