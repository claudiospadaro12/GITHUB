# python3 -I guardian_finestre_wim.py <cartella ANNO80K_WIM_PACCHETTO> <cartella radice dei report oro (scratchpad)>
import sys,json,collections
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import *
W,ROOT=sys.argv[1],sys.argv[2]
os.chdir(ROOT)
def trio(y):
    S={'Reaper':glob.glob(f'tre_da074c39-ANNO80K_TRE_EA_20261026_1444/{y}_M1/ANNO80K_THEGOLDREAPERMT5/report/*.htm'),
       'Goldbot':glob.glob(f'gb_setvend/{y}_M1_GB_PF525/**/*.htm',recursive=True),'Phantom':glob.glob(f'phantom_d4/ph_{y}.htm')}
    ev=[]
    for n,g in S.items():
        if not g: return None
        ev+=load_deals(g[0])
    ev.sort(key=lambda x:x[0]); return ev
CAND=[('DTP','DaytradeProMax9DDlowrisk'),('DTP','DaytradeProMax20DDmediumrisk'),('LUNA','Luna4DD'),('STAB','stabilityprolowriskset'),('APEX','ApexUltraConservativeGrid'),('APEX','ApexConservativeGrid')]
YEARS=['2013','2017','2020','2022','2025']
TW={'2013','2020','2025'}
out={}
def stats(evs,y,label):
    r={}
    for model in ('none','A','B'):
        s,nt=daily_series(evs,int(y),model)
        w14=windows(s,14); w60=windows(s,60)
        a14=outcome(w14,model,0.05*BAL); a60=outcome(w60,model,0.10*BAL)
        cum=np.cumsum(s); pk=np.maximum.accumulate(np.maximum(cum,0)); 
        r[model]=dict(net=float(s.sum()),worst=float(s.min()),dd=float((pk-cum).max()),trig=nt,
                      p14=100*a14[0]/a14[2],f14=100*a14[1]/a14[2],p60=100*a60[0]/a60[2],f60=100*a60[1]/a60[2])
    return r
for ea,s in CAND:
    for y in YEARS:
        p=report_path(W,ea,s,y)
        if not p: continue
        evs=load_deals(p)
        out[f'{ea}|{s}|{y}|solo']=stats(evs,y,'solo')
        if y in TW:
            T=trio(y); out[f'trio|{y}']=out.get(f'trio|{y}') or stats(T,y,'trio')
            C=sorted(T+evs,key=lambda x:x[0]); out[f'{ea}|{s}|{y}|trio+']=stats(C,y,'comb')
json.dump(out,open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/guardian_finestre_wim.json','w'))
print(len(out),"serie")
def fm(r,m): x=r[m]; return f"net{x['net']:>8.0f} pgg{x['worst']:>7.0f} DD{x['dd']:>7.0f} trig{x['trig']:>3d} | 14gg: pass{x['p14']:4.1f}% fail{x['f14']:4.1f}% | 60gg +10%: pass{x['p60']:4.1f}% fail{x['f60']:4.1f}%"
print("\n=== TRIO oro da solo")
for y in sorted(TW): 
    r=out[f'trio|{y}']; print(y,"nessuno:",fm(r,'none')); print(y,"B       :",fm(r,'B'))
for ea,s in CAND:
    print(f"\n=== {ea} {s}")
    for y in YEARS:
        k=f'{ea}|{s}|{y}|solo'
        if k not in out: continue
        print(y,"solo  none:",fm(out[k],'none')); print(y,"solo  B   :",fm(out[k],'B'))
        k2=f'{ea}|{s}|{y}|trio+'
        if k2 in out: print(y,"+trio none:",fm(out[k2],'none')); print(y,"+trio B   :",fm(out[k2],'B'))
