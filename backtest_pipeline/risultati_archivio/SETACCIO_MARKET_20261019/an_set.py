import sys,re,glob,os,collections,statistics,datetime
sys.path.insert(0,'.')
from parse_rep import read,rows,deals
KEYS=re.compile(r'martin|grid|multipl|recover|hedge|averag|basket|layer|pyramid|dca|lotexp|lot_exp|risk|lot|sl|stop|tp|take|magic|symbol|period|timeframe|tf\b',re.I)
RED=re.compile(r'martin|grid|multipl|recover|hedge|averag|basket|layer|pyramid|dca',re.I)
def inputs(f):
    t=read(f); flat=re.sub(r'<[^>]+>','|',t); flat=re.sub(r'\s*\|[\s|]*','|',flat)
    d={}
    for k,v in re.findall(r'\|([A-Za-z_][A-Za-z0-9_ ]*)=([^|]*)(?=\|)',flat):
        if k not in d: d[k.strip()]=v.strip()
    return d
def head(f):
    R=rows(read(f)); flat=[c for r in R for c in r]; o={}
    for i,c in enumerate(flat):
        if c.endswith(':') and i+1<len(flat):
            k=c.rstrip(':')
            if k not in o: o[k]=flat[i+1]
    return o
def parse_t(s): return datetime.datetime.strptime(s[:19],'%Y.%m.%d %H:%M:%S')
def stats(f):
    D=deals(f)
    ins=[x for x in D if x['dir'].lower().startswith('in')]
    outs=[x for x in D if x['dir'].lower().startswith('out')]
    vols=[x['vol'] for x in ins]
    # concurrency by sweep
    ev=[]
    for x in ins: ev.append((parse_t(x['t']),1))
    for x in outs: ev.append((parse_t(x['t']),-1))
    ev.sort(key=lambda e:(e[0],-e[1]))
    c=0;mx=0
    for t,dv in ev:
        c+=dv; mx=max(mx,c)
    res=[x['profit']+x['comm']+x['swap'] for x in outs]
    wins=[r for r in res if r>0]; loss=[r for r in res if r<=0]
    # lot after loss
    seq=[(parse_t(x['t']),x['vol']) for x in ins]
    return dict(n=len(outs),win=100*len(wins)/max(1,len(res)),avgw=statistics.mean(wins) if wins else 0,avgl=statistics.mean(loss) if loss else 0,
        lmin=min(vols) if vols else 0,lmax=max(vols) if vols else 0,maxpos=mx,syms=collections.Counter(x['sym'] for x in D if x['sym']).most_common(3),
        long=sum(1 for x in ins if x['type']=='buy'),short=sum(1 for x in ins if x['type']=='sell'),
        first=D[0]['t'][:10] if D else '',last=D[-1]['t'][:10] if D else '',res=res)
if __name__=='__main__':
    for d in sorted(glob.glob('set/SCREEN_*')):
        nm=os.path.basename(d)[7:]
        fs=sorted(glob.glob(d+'/report/*.htm'))
        print('=====',nm)
        for f in fs:
            h=head(f); inp=inputs(f); s=stats(f)
            tr='H1' if 'TRANCHE1' in f else 'M15'
            print(tr,'| Expert',h.get('Expert'),'| Sym',h.get('Simbolo'),'| periodo',h.get('Periodo'),'| trades',s['n'],'win%%%.0f'%s['win'],'avgW %.1f avgL %.1f'%(s['avgw'],s['avgl']),'lot',s['lmin'],'-',s['lmax'],'maxpos',s['maxpos'],'L/S',s['long'],s['short'],'sym',s['syms'],'ult',s['last'])
            if tr=='H1':
                red=[k+'='+v for k,v in inp.items() if RED.search(k)]
                print('   input rossi:',red[:8])
                print('   n input',len(inp),'|',' ; '.join(k+'='+v for k,v in list(inp.items())[:14])[:420])
