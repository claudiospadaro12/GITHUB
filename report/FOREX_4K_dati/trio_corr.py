import sys,glob,json,collections,datetime as dt
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
import numpy as np
def daily(ev,year=None):
    d=collections.defaultdict(float)
    for e in ev:
        if year and not e[0].startswith(str(year)): continue
        d[e[0][:10]]+=e[1]
    return d
def first(p):
    g=glob.glob(p,recursive=True);assert g,p;return g[0]
# trio 3745 (reale), 21 mesi
T3745=collections.defaultdict(float)
for d in ['21M_M4_REAPER_D9','21M_M4_GOLDBOT_PF525','21M_M4_PHANTOM_D4']:
    for k,v in daily(load_deals(first(f'gb3745b/{d}/*/report/*.htm'))).items(): T3745[k]+=v
def trio80(y):
    S=[f'tre_da074c39-ANNO80K_TRE_EA_20261026_1444/{y}_M1/ANNO80K_THEGOLDREAPERMT5/report/*.htm',f'gb_setvend/{y}_M1_GB_PF525/**/*.htm',f'phantom_d4/ph_{y}.htm']
    D=collections.defaultdict(float)
    for p in S:
        for k,v in daily(load_deals(first(p))).items(): D[k]+=v
    return D
CAND=['APEX_ApexConservativeGrid','APEX_ApexUltraConservativeGrid','DTP_DaytradeProMax9DDlowrisk','DTP_DaytradeProMax20DDmediumrisk','DTP_DaytradeProMax50DDhighrisk','LUNA_Luna4DD','STAB_stabilityprolowriskset','STAB_stabilitypromediumlowriskset','APEX_ApexElevatedGrid','LUNA_LunaAIrecommendedlowrisk']
def cand(s,y):
    k=f'{s}_{y}'
    return daily(load_deals(first(f'forex4k/z*/*/{k}/*/report/*.htm')),y)
def align(a,b,y):
    d0=dt.date(int(y),1,1);n=366 if int(y)%4==0 else 365
    days=[(d0+dt.timedelta(i)).strftime('%Y.%m.%d') for i in range(n)]
    return days,np.array([a.get(x,0.0) for x in days]),np.array([b.get(x,0.0) for x in days])
def ddmax(s):
    c=np.cumsum(s);pk=np.maximum.accumulate(np.maximum(c,0));return float((pk-c).max())
out=[]
T80={y:trio80(y) for y in ('2013','2020','2025')}
for s in CAND:
    row={'set':s}
    for y in ('2013','2020','2025'):
        c=cand(s,y);days,cc,tt=align(c,T80[y],y)
        r=float(np.corrcoef(cc,tt)[0,1]) if cc.std()>0 and tt.std()>0 else None
        nz=(cc!=0)&(tt!=0)
        both_loss=int(((cc<0)&(tt<0)).sum());cl=int((cc<0).sum());tl=int((tt<0).sum())
        exp=cl*tl/len(days)
        # trio mean on candidate's 10 worst days, in units of trio daily std
        w=np.argsort(cc)[:10]
        row[y]=dict(corr80=r,co_loss=both_loss,exp_co_loss=exp,cand_loss_days=cl,trio_loss_days=tl,trio_on_cand_worst10=float(tt[w].mean()/tt.std()) if tt.std()>0 else None)
    # 2025 true scale
    c=cand(s,'2025');days,cc,tt=align(c,T3745,'2025')
    r=float(np.corrcoef(cc,tt)[0,1])
    comb=cc+tt
    row['2025_real']=dict(corr=r,trio_net=float(tt.sum()),cand_net=float(cc.sum()),comb_net=float(comb.sum()),
      worst_trio=float(tt.min()),worst_cand=float(cc.min()),worst_comb=float(comb.min()),worst_comb_day=days[int(comb.argmin())],
      dd_trio=ddmax(tt),dd_cand=ddmax(cc),dd_comb=ddmax(comb),
      co_loss=int(((cc<0)&(tt<0)).sum()),exp_co=float((cc<0).sum()*(tt<0).sum()/len(days)),
      cand_on_trio_worst=float(cc[int(tt.argmin())]),trio_on_cand_worst=float(tt[int(cc.argmin())]))
    out.append(row)
json.dump(out,open('trio_corr.json','w'),indent=1,default=float)
print('trio 3745 2025: net',round(sum(v for k,v in T3745.items() if k.startswith('2025')),0),'worst day',round(min(v for k,v in T3745.items() if k.startswith('2025')),0))
for r in out:
    print('\n',r['set'])
    print('  corr80  :',{y:(None if r[y]['corr80'] is None else round(r[y]['corr80'],3)) for y in('2013','2020','2025')})
    print('  co-loss :',{y:(r[y]['co_loss'],round(r[y]['exp_co_loss'],1)) for y in('2013','2020','2025')},' trio su 10 peggiori gg cand (sigma):',{y:round(r[y]['trio_on_cand_worst10'],2) for y in('2013','2020','2025')})
    print('  2025 reale:',{k:(round(v,3) if isinstance(v,float) else v) for k,v in r['2025_real'].items()})
