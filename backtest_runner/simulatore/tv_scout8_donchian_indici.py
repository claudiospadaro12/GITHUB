"""Donchian (TV n.23) + EMA + stop su NASUSD/SPXUSD H1 2015-2024. Criteri: report/DONCHIAN_INDICI_CRITERI_2026-11-19.md"""
import sys,csv,glob,itertools,collections
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_backtest import *
from tv_scout8_donchian_ext import donch
def load_ind(pat):
    rows={}
    for f in sorted(glob.glob(pat)):
        with open(f) as fh:
            r=csv.reader(fh); next(r)
            for t,o,h,l,c,*_ in r:
                k=t[:13]; o,h,l,c=float(o),float(h),float(l),float(c)
                if k not in rows: rows[k]=[o,h,l,c]
                else:
                    x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
IND={'NASUSD':('/tmp/claude-0/nas/NASUSD_M1_*.csv',2.0),'SPXUSD':('/tmp/claude-0/spx/SPXUSD_M1_*.csv',0.7)}
if __name__=='__main__':
    D={}
    for name,(pat,cost) in IND.items():
        ks,A=load_ind(pat); O,H,L,C=A.T; cut=ks[int(0.7*len(C))]; E=Env(ks,O,H,L,C,cost); D[name]=(E,cut)
        print(name,'barre',len(C),ks[0],ks[-1],'taglio',cut,'buy&hold',round(C[-1]/C[0],2),'x',flush=True)
    cells=list(itertools.product((20,40),(None,100,200,400),(None,2,3,4))); res={}
    for c in cells:
        for nm,(E,cut) in D.items():
            a,b=split(donch(E,*c),cut); res[(c,nm)]=(metrics(a),metrics(b))
    def lab(c): return 'len%d ema%s stop%s'%(c[0],c[1] or '-',c[2] or '-')
    print('--- tutte le celle (IS PF NAS / SPX, n, DD%) ---')
    for c in cells:
        e=res[(c,'NASUSD')][0]; x=res[(c,'SPXUSD')][0]
        print('%-22s NAS %.2f n%-4d DD%3.0f | SPX %.2f n%-4d DD%3.0f'%(lab(c),e['pf'],e['n'],e['dd'],x['pf'],x['n'],x['dd']))
    ok=[c for c in cells if all(res[(c,nm)][0]['n']>=100 for nm in D)]
    mp=lambda c:min(res[(c,nm)][0]['pf'] for nm in D)
    def nb(c):
        l,e,k=c; out=[(l2,e,k) for l2 in (20,40) if l2!=l]
        es=(None,100,200,400); i=es.index(e); out+=[(l,es[j],k) for j in (i-1,i+1) if 0<=j<4]
        ks_=(None,2,3,4); i=ks_.index(k); out+=[(l,e,ks_[j]) for j in (i-1,i+1) if 0<=j<4]
        return out
    print('--- prime 6 per min-PF IS ---')
    for c in sorted(ok,key=mp,reverse=True)[:6]:
        v=nb(c); print('%-22s minPF IS %.2f | vicini buoni %d/%d | OOS NAS PF %.2f n%d R%.2f, SPX PF %.2f n%d R%.2f'%(lab(c),mp(c),sum(1 for x in v if mp(x)>=1.2),len(v),*[res[(c,nm)][1][q] for nm in D for q in ('pf','n','R')]))
    print('celle che passano il filtro IS su entrambi:',[lab(c) for c in ok if all(res[(c,nm)][0]['pf']>=1.5 and res[(c,nm)][0]['dd']<=15 for nm in D)])
    print('celle con PF IS>=1.3 su entrambi:',[lab(c) for c in ok if mp(c)>=1.3])
    # per anno della cella base e di quella scelta
    best=sorted(ok,key=mp,reverse=True)[0]
    for c in ((20,None,None),best):
        for nm,(E,cut) in D.items():
            by=collections.defaultdict(list)
            for t,r in donch(E,*c): by[t[:4]].append((t,r))
            print(lab(c),nm,'PF per anno:',' '.join('%s:%.2f/%d'%(y,metrics(v)['pf'],len(v)) for y,v in sorted(by.items())))
