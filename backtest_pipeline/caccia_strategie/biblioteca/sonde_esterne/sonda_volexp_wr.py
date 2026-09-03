import os,glob,importlib.util,random
S=os.environ['S']
spec=importlib.util.spec_from_file_location("sv",S+"/sonda_volexp.py")
sv=importlib.util.module_from_spec(spec); spec.loader.exec_module(sv)
def esito(b,i,entry,av,side,slM,tpM,maxbars):
    sl=slM*av; tp=tpM*av
    for j in range(i+1,min(i+1+maxbars,len(b))):
        h,l=b[j][4],b[j][5]
        if side=='L': hs=l<=entry-sl; ht=h>=entry+tp
        else: hs=h>=entry+sl; ht=l<=entry-tp
        if hs: return 0
        if ht: return 1
    return -1
REQ=1.075/(2.0+1)
print(f"WR richiesto da H8 con RR 2,0: {REQ*100:.1f}%  (SL 1,5xATR / TP 3,0xATR)\n")
rng=random.Random(11)
for sym in ("GRXEUR","SPXUSD"):
    bars=sv.load_m1(glob.glob(f"{S}/dati/{sym}_*.csv"))
    for tf in (5,15):
        b=sv.aggregate(bars,tf); a=sv.atr(b,20); avg=sv.sma(a,40)
        lvlH=lvlL=None; prev=None; sig={'L':[],'S':[]}
        for i in range(len(b)):
            if a[i] is None or avg[i] is None or avg[i]==0: prev=b[i][6]; continue
            ratio=a[i]/avg[i]; c=b[i][6]
            if ratio<0.95: lvlH=b[i][4]; lvlL=b[i][5]
            if ratio>1.02 and prev is not None:
                if lvlH is not None and prev<=lvlH and c>lvlH: sig['L'].append((i,c,a[i])); lvlH=None
                elif lvlL is not None and prev>=lvlL and c<lvlL: sig['S'].append((i,c,a[i])); lvlL=None
            prev=c
        pool=[i for i in range(50,len(b)-300) if a[i] is not None]
        for side in ('L','S'):
            E=[esito(b,i,c,av,side,1.5,3.0,300) for (i,c,av) in sig[side]]
            w=sum(1 for x in E if x==1); l=sum(1 for x in E if x==0); nd=sum(1 for x in E if x==-1)
            idx=[rng.choice(pool) for _ in range(len(sig[side]))]
            Ec=[esito(b,i,b[i][6],a[i],side,1.5,3.0,300) for i in idx]
            wc=sum(1 for x in Ec if x==1); lc=sum(1 for x in Ec if x==0)
            wr=w/(w+l) if w+l else 0; wrc=wc/(wc+lc) if wc+lc else 0
            print(f"{sym} M{tf} {side}: n={len(E):5d} TP={w:5d} SL={l:5d} aperti={nd:4d} | WR={wr*100:5.1f}% controllo={wrc*100:5.1f}% delta={((wr-wrc)*100):+5.1f} pt")
