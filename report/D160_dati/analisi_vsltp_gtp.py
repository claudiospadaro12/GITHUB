import re,glob,collections,sys,json,os
SP='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad'
sys.path.insert(0,SP)
from tre_lib import deals
def inputs(d):
    h=glob.glob(d+'/*/report/*.htm')
    b=open(h[0],'rb').read(400000); t=b.decode('utf-16','ignore') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','ignore')
    t=re.sub(r'<[^>]+>','\n',t).replace('&nbsp;',' ')
    return dict(re.findall(r'^\s*([A-Za-z_0-9]+)=([^\n]*)$',t,flags=re.M))
def refer(d):
    f=glob.glob(d+'/*/REFERTO_ANNO80K_TRANCHE.txt')[0]
    t=open(f,encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)',t)
    st=re.search(r'STATO (\w+)',t); q=re.search(r'qualita (\d+)%',t); r=re.search(r'giornali letti (\d+), +righe (\d+)',t)
    ic=re.search(r'input imposti confermati dal report: (\w+)',t); so=re.search(r'righe stop out nei giornali (\d+), no money (\d+)',t)
    return dict(stato=st.group(1),ops=int(m.group(1)),net=float(m.group(2)),pf=m.group(3),ddp=float(m.group(5)),q=int(q.group(1)),righe=int(r.group(2)),conf=ic and ic.group(1),so=so.groups())
def wd(d):
    h=glob.glob(d+'/*/report/*.htm')[0]; day=collections.defaultdict(float)
    for e in deals(h): day[e['t'][:10]]+=e['v']
    return min(day.values())
Y=('2013','2020','2025'); R={}
for arm in ('V99','V0','C0'):
    for y in Y:
        d='%s/vsltp_gtp2/VSLTP_%s_R1_COMBO_GTP_160000_%s'%(SP,arm,y); r=refer(d); r['wd']=wd(d); r['inp']=inputs(d); R[(arm,y)]=r
for y in Y:
    d='%s/d160gtp/D160_GTP_COMBO_160000_%s'%(SP,y); r=refer(d); r['wd']=wd(d); r['inp']=inputs(d); R[('BASE',y)]=r
# validita: tutti gli input contro il riferimento, tranne i 2 del test
ok=True
for (arm,y),r in R.items():
    if arm=='BASE': continue
    b=R[('BASE',y)]['inp']; i=r['inp']
    diff={k:(b.get(k),i.get(k)) for k in set(b)|set(i) if b.get(k)!=i.get(k) and k not in ('EnableVirtualSLTP','SetVSL_to_hardSL_sec_delay')}
    exp={'V99':('true','99'),'V0':('true','0'),'C0':('false','0')}[arm]
    ex=(i.get('EnableVirtualSLTP'),i.get('SetVSL_to_hardSL_sec_delay'))
    print(arm,y,'stato',r['stato'],'q',r['q'],'conf',r['conf'],'| virtual/ritardo',ex,'atteso',exp,'| altri input diversi:',diff or 'NESSUNO')
    if diff or ex!=exp or r['stato']!='OK' or r['q']<98: ok=False
print('TUTTE VALIDE' if ok else 'ATTENZIONE: non valide')
for k,v in R.items(): print(k,'ops',v['ops'],'net %.0f'%v['net'],'PF',v['pf'],'DD %.2f'%v['ddp'],'righe',v['righe'],'wd %.0f'%v['wd'])
nb=sum(R[('BASE',y)]['net'] for y in Y); lb=sum(R[('BASE',y)]['righe'] for y in Y)
for arm in ('V99','V0','C0'):
    n=sum(R[(arm,y)]['net'] for y in Y); l=sum(R[(arm,y)]['righe'] for y in Y)
    per=[ (R[(arm,y)]['righe']/R[('BASE',y)]['righe']-1)*100 for y in Y]
    dd=max(R[(arm,y)]['ddp']-R[('BASE',y)]['ddp'] for y in Y); w=min(R[(arm,y)]['wd']-R[('BASE',y)]['wd'] for y in Y)
    ops=sum(R[(arm,y)]['ops'] for y in Y)/sum(R[('BASE',y)]['ops'] for y in Y)-1
    print(arm,'netto %.0f vs %.0f (%+.1f%%) | righe %.0f vs %.0f (%+.1f%%; %s) | DD max %+.2f pt | peggior giorno peggiora al massimo %.0f (%.2f pt) | ops %+.1f%%'%(n,nb,100*(n/nb-1),l,lb,100*(l/lb-1),' '.join('%+.0f%%'%p for p in per),dd,w,100*(-w)/160000 if w<0 else 0,100*ops))
json.dump({'|'.join(k):{a:b for a,b in v.items() if a!='inp'} for k,v in R.items()},open(SP+'/vsltp_gtp2_res.json','w'),indent=1)
