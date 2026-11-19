"""Donchian 20 (TV n.23) + filtro EMA + stop ATR. Criteri: report/DONCHIAN_MIGLIORAMENTO_CRITERI_2026-11-19.md"""
import sys,json,itertools
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_backtest import *
def donch(E,length=20,ema_n=None,k=None):
    O,H,L,C,atr,cost=E.O,E.H,E.L,E.C,E.atr,E.cost; n=len(C)
    U=np.full(n,np.nan); Lo=np.full(n,np.nan)
    for i in range(length-1,n): U[i]=H[i-length+1:i+1].max(); Lo[i]=L[i-length+1:i+1].min()
    em=ema(C,ema_n) if ema_n else None
    il=ish=False; pos=0; ent=None; tr=[]; pend=0
    st=max(length+2,ema_n or 0,15)
    for i in range(st,n-1):
        # fill all'apertura di i
        if pend!=0:
            d=pend; pend=0
            if pos!=0: tr.append((ent[2],E.R(pos,ent[0],O[i],ent[1])))
            a=atr[i-1]; risk=(k*a if k else 2*a)
            pos=d; ent=[O[i],risk,E.ks[i],O[i]-d*k*a if k else None]
        # stop intrabar
        if pos!=0 and ent[3] is not None:
            sl=ent[3]
            if pos==1 and L[i]<=sl: tr.append((ent[2],E.R(1,ent[0],min(O[i],sl),ent[1]))); pos=0; il=ish=False
            elif pos==-1 and H[i]>=sl: tr.append((ent[2],E.R(-1,ent[0],max(O[i],sl),ent[1]))); pos=0; il=ish=False
        # segnali alla chiusura di i
        if (not il) and U[i]>U[i-1]:
            if U[i-1]>U[i-2] and (em is None or C[i]>em[i]): pend=1; il=True; ish=False
        else:
            if (not ish) and Lo[i]<Lo[i-1] and Lo[i-1]<Lo[i-2] and (em is None or C[i]<em[i]): pend=-1; ish=True; il=False
    return tr
if __name__=='__main__':
    D={}
    for name,(pat,cost) in MK.items():
        ks,A=smc.load(pat); O,H,L,C=A.T; cut=ks[int(0.7*len(C))]; E=Env(ks,O,H,L,C,cost); D[name]=(E,cut)
    cells=list(itertools.product((20,40),(None,100,200,400),(None,2,3,4))); res={}
    for c in cells:
        for name,(E,cut) in D.items():
            a,b=split(donch(E,*c),cut); res[(c,name)]=(metrics(a),metrics(b))
    def lab(c): return 'len%d ema%s stop%s'%(c[0],c[1] or '-',c[2] or '-')
    print('base (len20, -, -): ',' | '.join('%s IS %s'%(nm,fmt(res[((20,None,None),nm)][0])) for nm in D))
    print('--- tutte le celle (IS PF EURUSD / oro, n, DD%) ---')
    for c in cells:
        e=res[(c,'EURUSD')][0]; x=res[(c,'XAUUSD')][0]
        print('%-22s EUR %.2f n%-4d DD%3.0f | XAU %.2f n%-4d DD%3.0f'%(lab(c),e['pf'],e['n'],e['dd'],x['pf'],x['n'],x['dd']))
    ok=[c for c in cells if all(res[(c,nm)][0]['n']>=100 for nm in D)]
    def mp(c): return min(res[(c,nm)][0]['pf'] for nm in D)
    def nb(c):
        l,e,k=c; out=[]
        for l2 in (20,40):
            if l2!=l: out.append((l2,e,k))
        es=(None,100,200,400); i=es.index(e)
        for j in (i-1,i+1):
            if 0<=j<4: out.append((l,es[j],k))
        ks_=(None,2,3,4); i=ks_.index(k)
        for j in (i-1,i+1):
            if 0<=j<4: out.append((l,e,ks_[j]))
        return out
    ranked=sorted(ok,key=mp,reverse=True)
    print('--- prime 6 per min-PF IS (con plateau: vicini con min-PF>=1.2) ---')
    for c in ranked[:6]:
        v=nb(c); good=sum(1 for x in v if mp(x)>=1.2)
        print('%-22s minPF IS %.2f | vicini buoni %d/%d | OOS EUR PF %.2f n%d, XAU PF %.2f n%d'%(lab(c),mp(c),good,len(v),res[(c,'EURUSD')][1]['pf'],res[(c,'EURUSD')][1]['n'],res[(c,'XAUUSD')][1]['pf'],res[(c,'XAUUSD')][1]['n']))
    n15=[c for c in ok if all(res[(c,nm)][0]['pf']>=1.5 and res[(c,nm)][0]['dd']<=15 for nm in D)]
    print('celle che passano il filtro IS (PF>=1.5, DD<=15%, n>=100) su entrambi:',n15)
    print('celle con PF IS>=1.3 su entrambi:',[lab(c) for c in ok if mp(c)>=1.3])
