import re,glob,json,os,collections,sys
sys.path.insert(0,'/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad')
from tre_lib import deals
SP='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad'
def refer(d):
    f=glob.glob(d+'/*/REFERTO_ANNO80K_TRANCHE.txt')
    if not f: return None
    t=open(f[0],encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)',t)
    st=re.search(r'STATO (\w+)',t); q=re.search(r'qualita (\d+)%',t); r=re.search(r'giornali letti (\d+), +righe (\d+)',t)
    so=re.search(r'righe stop out nei giornali (\d+), no money (\d+)',t); ic=re.search(r'input imposti confermati dal report: (\w+)',t)
    imp=re.search(r'input imposti dal \.ini \((\d+)\): ([^\n]*?)\s{2,}\(',t)
    return dict(stato=st and st.group(1),ops=m and int(m.group(1)),net=m and float(m.group(2)),pf=m and m.group(3),ddp=m and float(m.group(5)),q=q and int(q.group(1)),righe=r and int(r.group(2)),so=so and int(so.group(1)),nm=so and int(so.group(2)),conf=ic and ic.group(1),imp=imp and imp.group(2).strip())
def worst(d):
    h=glob.glob(d+'/*/report/*.htm')
    if not h: return None
    day=collections.defaultdict(float)
    for e in deals(h[0]): day[e['t'][:10]]+=e['v']
    return min(day.values()) if day else None
out={}
for d in sorted(glob.glob(SP+'/vsltp_oro/VSLTP_*')):
    k=os.path.basename(d); r=refer(d); 
    if r: r['wd']=worst(d)
    out[k]=r
for d in sorted(glob.glob(SP+'/d160oro/D160_*')):
    k=os.path.basename(d); r=refer(d)
    if r: r['wd']=worst(d)
    out[k]=r
json.dump(out,open(SP+'/vsltp_oro_res.json','w'),indent=1)
print(len(out))
