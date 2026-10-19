import sys,glob,os,csv,statistics
sys.path.insert(0,'.')
from an_set import *
out=[]
for d in sorted(glob.glob('set/SCREEN_*')):
    nm=os.path.basename(d)[7:]
    fs=sorted(glob.glob(d+'/report/*.htm'))
    man=list(csv.reader(open(d+'/MANIFEST_SCREEN.csv'),delimiter=';'))[1:]
    dur=[int(m[5]) for m in man]
    S=[stats(f) for f in fs]
    H=head(fs[0])
    s1,s2=S[0],S[1]
    n1,n2=s1['n'],s2['n']
    net1=float(man[0][10]); net2=float(man[1][10])
    dd1=man[0][12]; dd2=man[1][12]
    medlot=statistics.median([x for x in [s1['lmin'],s1['lmax']] if x]) if s1['lmax'] else 0
    lotratio=(s1['lmax']/s1['lmin']) if s1['lmin'] else 0
    avg=net1/n1 if n1 else 0
    cost=0.18*(s1['lmax']/0.01) if s1['lmax'] else 0
    ratio=avg/cost if cost else 0
    dep=(max(n1,n2)/max(1,min(n1,n2)))
    ident=(n1==n2 and abs(net1-net2)<0.01)
    nonxau=[k for k,v in s1['syms'] if k!='XAUUSD']
    print('%-22s n %4d/%4d dep x%.1f %s net %8.0f/%8.0f DD %-14s win%%%2.0f lot %.2f-%.2f (x%.1f) maxpos %2d avg/trade %.2f cost~%.2f ratio %.1f dur %ds sym %s'%(nm[:22],n1,n2,dep,'IDENT' if ident else '     ',net1,net2,dd1[:14],s1['win'],s1['lmin'],s1['lmax'],lotratio,s1['maxpos'],avg,cost,ratio,sum(dur),[k for k,v in s1['syms']]))
