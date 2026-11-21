# Criteri: report/UBS_NON_ORO_F2F7_CRITERI_2026-11-21.md
import sys,re,zipfile,html,pickle,os,itertools,time
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np, pandas as pd
T0=time.time(); out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
ZIP='/root/.claude/uploads/c2d73886-9ef2-5105-8937-d770bc36d6df/f47b5f40-ANNO_ORO_GRADINI_UBSCF_20261115_1641.zip'; CACHE='/tmp/claude-0/ubscf_deals.pkl'
def num(x): return float(re.sub(r'[\s ]','',x) or 0)
if os.path.exists(CACHE): D=pickle.load(open(CACHE,'rb'))
else:
    D={}; z=zipfile.ZipFile(ZIP)
    for x in z.namelist():
        if not x.lower().endswith('.htm'): continue
        m=re.match(r'UBSCF_(.+)_100000_(2013-2018|2019-2025)\\',x); 
        if not m: continue
        raw=z.read(x); t=raw.decode('utf-16') if raw[:2] in (b'\xff\xfe',b'\xfe\xff') else raw.decode('utf-8','replace')
        rows=[[html.unescape(re.sub(r'<[^>]+>','',c)).strip() for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>',r,flags=re.S|re.I)] for r in re.findall(r'<tr[^>]*>(.*?)</tr>',t,flags=re.S|re.I)]
        hi=[i for i,c in enumerate(rows) if len(c)>=12 and 'Direzione' in c]
        if not hi: continue
        dl=[(pd.to_datetime(c[0][:10],format='%Y.%m.%d'),c[3],c[4],num(c[5]),num(c[8]),num(c[9]),num(c[10])) for c in rows[hi[0]+1:] if len(c)>=12 and c[3] in ('buy','sell')]
        D[(m.group(1),m.group(2))]=pd.DataFrame(dl,columns=['d','tipo','dir','vol','comm','swap','profit'])
    pickle.dump(D,open(CACHE,'wb'))
P(f'[{time.time()-T0:.0f}s] report letti: {len(D)}')
SETS=sorted({k[0] for k in D}); PER={'P1':('2013-2018',pd.Timestamp('2013-01-01'),pd.Timestamp('2018-12-31')),'P2':('2019-2025',pd.Timestamp('2019-01-01'),pd.Timestamp('2025-12-31'))}
SYM={'SCALP_EU_SL17':'EURUSD','SCALP_EU_SL22':'EURUSD','SCALP_GU_H1':'GBPUSD','SCALP_UJ_H1':'USDJPY','SCALP_UJ_H4':'USDJPY','VOL_f':'EURUSD','VOL_o':'EURUSD','VOL_C10':'EURUSD','VOL_C20':'EURUSD','VOL_C37':'EURUSD','VOL_C63':'EURUSD','VOL_e':'EURUSD','VOL_k':'EURUSD','OTH_EU_b':'EURUSD','OTH_GU_a':'GBPUSD','CLI_HJP09':'USDJPY','CLI_HJP10':'USDJPY'}
FAM={s:s.split('_')[0] for s in SYM}
POOLA=['SCALP_EU_SL17','SCALP_EU_SL22','SCALP_GU_H1','SCALP_UJ_H1','SCALP_UJ_H4','VOL_f','VOL_o']; POOLC=POOLA+['VOL_C10','VOL_C20','VOL_C37','VOL_C63','VOL_e','VOL_k','OTH_EU_b','OTH_GU_a','CLI_HJP09','CLI_HJP10']
def trades_of(s,p,cost):
    d=D[(s,PER[p][0])]; o=d[d.dir=='out']; # operazioni = deal in uscita
    # commissioni/swap anche delle entrate attribuite alla data del deal: si sommano tutti i deal per data
    return d
def daily(s,p,cost):
    d=D[(s,PER[p][0])].copy(); d['net']=d.profit+d.comm+d.swap
    d.loc[d.dir=='out','net']-=cost*d.loc[d.dir=='out','vol']/0.1
    return d.groupby('d').net.sum()
def tradesnet(s,p,cost):
    d=D[(s,PER[p][0])]; o=d[d.dir=='out']; return pd.DataFrame({'d':o.d,'net':o.profit+o.comm+o.swap-cost*o.vol/0.1})
cal={p:pd.bdate_range(PER[p][1],PER[p][2]) for p in PER}
def series(s,p,cost): return daily(s,p,cost).reindex(cal[p]).fillna(0.0)
def mdd(x): c=np.cumsum(x); return float((np.maximum.accumulate(np.r_[0,c])[1:]-c).max()) if len(x) else 0.0
# proxy oro (trend D1 long, rendimento % giornaliero) per la correlazione
src=open('/home/user/GITHUB/backtest_runner/simulatore/supertrend_correlazione.py',encoding='utf-8').read(); exec(src[:src.index("out=[]")]); gold=S['C_DON55_D1']
P(f'[{time.time()-T0:.0f}s] proxy oro pronto')
def weekly(x): return x.groupby(x.index.to_period('W')).sum()
def goldw(p): g=gold.reindex(cal[p]).fillna(0.0); return weekly(g)
# ---- F3
P('\n=== F3: correlazione settimanale con il trend D1 dell\'oro (proxy) e fra i set del pool A, per periodo (costo 0,5 EUR/operazione)')
for p in PER:
    W={s:weekly(series(s,p,0.5)) for s in POOLA}; g=goldw(p); 
    P(f'{p}: n settimane {len(g)}; corr con oro: '+' '.join(f'{s}:{W[s].corr(g):+.2f}' for s in POOLA))
    M=pd.DataFrame(W).corr(); pairs=[(a,b,M.loc[a,b]) for a,b in itertools.combinations(POOLA,2)]; hi=[(a,b,round(v,2)) for a,b,v in pairs if v>0.6]
    P(f'   coppie con corr settimanale > 0,60: {len(hi)} su {len(pairs)}: {hi}')
    P('   operazioni (out) per set: '+' '.join(f'{s}:{int((D[(s,PER[p][0])].dir=="out").sum())}' for s in POOLA))
def build(pool,p_build,cost=0.5):
    Wb={s:weekly(series(s,p_build,cost)) for s in pool}; g=goldw(p_build); rf={}; dd={}
    for s in pool:
        x=series(s,p_build,cost).values; dd[s]=mdd(x); rf[s]=x.sum()/dd[s] if dd[s]>0 else -1
    order=sorted(pool,key=lambda s:-rf[s]); ch=[]
    for s in order:
        if rf[s]<=0 or len(ch)>=4: continue
        if any(SYM[s]==SYM[c] and FAM[s]==FAM[c] for c in ch): continue
        if abs(Wb[s].corr(g))>0.30: continue
        if any(Wb[s].corr(Wb[c])>0.60 for c in ch): continue
        ch.append(s)
    if not ch: return None
    w=np.array([1/dd[s] for s in ch]); w=w/w.sum(); base=sum(wi*series(s,p_build,cost) for wi,s in zip(w,ch)); k=3000.0/mdd(base.values)
    return ch,w*k,{s:(round(rf[s],2),round(dd[s])) for s in ch}
def evaluate(ch,m,p_eval,cost):
    ser=sum(mi*series(s,p_eval,cost) for mi,s in zip(m,ch)); tr=pd.concat([tradesnet(s,p_eval,cost).assign(net=lambda x,mi=mi:x.net*mi) for mi,s in zip(m,ch)]).net.values
    pf=tr[tr>0].sum()/-tr[tr<0].sum() if (tr<0).any() else np.inf
    x=ser.values; n=len(x); res={'ph2':0,'ph1':0,'fail':0,'tot':0}; days=[]
    for st in range(0,n-20,3):
        end=min(n,st+756); base=0.0; ph=1; tgt=10000.0; f=False; d1=None; res['tot']+=1; cum=0.0
        for i in range(st,end):
            cum+=x[i]
            if x[i]<=-5000 or cum-base<=-10000: f=True; break
            if cum-base>=tgt:
                if ph==1: ph=2; res['ph1']+=1; d1=i-st; base=cum; tgt=5000.0
                else: res['ph2']+=1; break
        if f: res['fail']+=1
        if d1 is not None: days.append(d1)
    t=res['tot']; return dict(pf=pf,ph2=res['ph2']/t,ph1=res['ph1']/t,fail=res['fail']/t,med=np.median(days) if days else np.nan,dd=mdd(x),net=x.sum(),starts=t,ntr=len(tr))
P('\n=== F4/F5/F7: costruzione e verifica incrociata (costruzione con costo 0,5; valutazione a 0 / 0,5 / 1,0 EUR per operazione a 0,1 lotto)')
results=[]
for pname,pool in (('A',POOLA),('C',POOLC)):
    for pb,pe in (('P1','P2'),('P2','P1')):
        b=build(pool,pb)
        if not b: P(f'Pool {pname} costruzione {pb}: nessuna combinazione ammessa'); results.append((pname,pb,pe,None)); continue
        ch,m,info=b; P(f'\nPool {pname} costruito su {pb} -> valutato su {pe}: componenti {ch}  (rec.factor, DD EUR a 0,1 lotti: {info}); moltiplicatori di lotto sul 0,1: {[round(x,1) for x in m]}')
        for cost in (0.0,0.5,1.0):
            e=evaluate(ch,m,pe,cost); results.append((pname,pb,pe,cost,e))
            P(f'   costo {cost}: PF {e["pf"]:.2f}, netto {e["net"]:.0f}, DD realizzato {e["dd"]:.0f}, operazioni {e["ntr"]}, partenze {e["starts"]}: completano 2 fasi {e["ph2"]*100:.0f}%, fase 1 {e["ph1"]*100:.0f}%, falliscono {e["fail"]*100:.0f}%, giorni mediani fase 1 {e["med"]:.0f}')
P('\n=== ESITO F5 (a costi centrali e prudenti, in entrambi i sensi)')
for pname in ('A','C'):
    ok=True; 
    for pb,pe in (('P1','P2'),('P2','P1')):
        for cost in (0.5,1.0):
            r=[x for x in results if x[0]==pname and x[1]==pb and x[3]==cost]
            if not r: ok=False; continue
            e=r[0][4]; c1=e['pf']>=1.20 and e['fail']<=0.03 and e['ph1']>=0.30 and e['fail']<=0.10
            ok=ok and c1
    P(f'Pool {pname}: combinazione che supera tutte le soglie in entrambi i sensi a costi 0,5 e 1,0: {"SI" if ok else "NO"}')
open('/home/user/GITHUB/report/UBS_NON_ORO_F2F7_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
