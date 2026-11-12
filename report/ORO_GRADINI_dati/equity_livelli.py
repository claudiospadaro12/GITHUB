# Equity vera (con il flottante dell'oro ricostruito dalle barre M1) di conti solo oro a 80k, anni 2013/2018/2020/2025.
# Da lanciare dalla cartella con oro_res.json, oro/, gtp_anni/, exp_all/ (barre M1 XAUUSD esportate il 27/10/2026). Uso: python3 -I equity_conti_oro.py <out.json>
import sys, json, glob
src = open('/home/user/GITHUB/report/ORO_GRADINI_dati/equity_vero.py').read()
exec(src[:src.index('M1={}')])
M1 = {}
CONV = {'2013': 0.752, '2018': 0.847, '2020': 0.877, '2025': 0.888}   # EUR per USD, media dell'anno (2018 = ipotesi mia)
FILES = {'2013': 'exp_all/ABTG_M1_XAUUSD_2013.csv', '2018': 'exp_all/ABTG_M1_XAUUSD_2018.csv', '2020': 'exp_all/ABTG_M1_XAUUSD_2020.csv', '2025': 'exp_all/ABTG_M1_XAUUSD.csv'}
def m1(y):
    if y in M1: return M1[y]
    T = []; H = []; L = []; C = []
    for i, l in enumerate(open(FILES[y])):
        if i == 0: continue
        p = l.strip().split(';')
        if not p[0].startswith(y): continue
        T.append(p[0].replace('.', '-', 2).replace(' ', 'T')); H.append(float(p[2])); L.append(float(p[3])); C.append(float(p[4]))
    M1[y] = (np.array(T, dtype='datetime64[m]'), np.array(H), np.array(L), np.array(C)); return M1[y]
exec(src[src.index('def equity_ea'):src.index('def equity_ea') + src[src.index('def equity_ea'):].index('\n\n') if '\n\n' in src[src.index('def equity_ea'):] else len(src)])
DEP = 80000.0
def path(e, lv, y):
    if e == 'GTP': return glob.glob('gtp_anni/%s_M1_GTP_COMBO/*/report/*.htm' % y)[0]
    return glob.glob('oro/z*/*/%s_%s_80000_%s/*/report/*.htm' % (lv, e, y))[0]
cache = {}
def ea_eq(e, lv, y):
    k = (e, lv, y)
    if k not in cache:
        a, c, info = equity_ea(path(e, lv, y), y, DEP); cache[k] = (a - DEP, c - DEP, info['T'], info)
    return cache[k]

LV=['L0','L1','L2','L3']
NAMES={'GB':'Goldbot One','PH':'Gold Phantom','GR':'Gold Reaper'}
ACC={}
for e in ('GB','PH','GR'):
    for lv in LV: ACC['%s %s'%(NAMES[e],lv)]=[(e,lv)]
for lv in LV: ACC['TRIO oro (Goldbot+Phantom+Reaper) tutti %s'%lv]=[('GB',lv),('PH',lv),('GR',lv)]
ACC['GTP Combo (unico livello testato)']=[('GTP','COMBO')]
res={}
for name,mem in ACC.items():
    res[name]={}
    for y in ('2013','2018','2020','2025'):
        cl=0;adv=0;unm=0
        for e,lv in mem:
            a,cc,T,info=ea_eq(e,lv,y); adv=adv+a; cl=cl+cc; unm+=info['unm']+info['left']
        eq=DEP+adv; eqc=DEP+cl
        pk=np.maximum.accumulate(eq); dd=(pk-eq).max()
        days=T.astype('datetime64[D]')
        n45=0;n95d=0;worst=(0,None);first95=None;first45=None
        for d in np.unique(days):
            m=np.where(days==d)[0]; i0=m[0]; start=eqc[i0-1] if i0>0 else DEP
            l=start-eq[m].min()
            if l>worst[0]: worst=(l,str(d))
            if l>=0.045*DEP:
                n45+=1
                if first45 is None: first45=str(d)
            if (DEP-eq[m].min())>=0.095*DEP:
                n95d+=1
                if first95 is None: first95=str(d)
        res[name][y]=dict(n45=n45,first45=first45,worst_day_pct=100*worst[0]/DEP,worst_day=worst[1],loss_ini_pct=100*(DEP-eq.min())/DEP,n95_days=n95d,first95=first95,dd_pct=100*dd/DEP,final=eq[-1]-DEP,unm=unm)
json.dump(res,open('equity_livelli.json','w'),default=float)
for name,v in res.items():
    print(name)
    for y,r in v.items():
        print('  ',y,'gg>=4,5%%: %2d (1o %s) | peggior giorno %.1f%% (%s) | perdita max da iniziale %.1f%% | gg con perdita da iniziale >=9,5%%: %d (1o %s) | DD picco-valle %.1f%% | finale %+.0f | non abb. %s'%(r['n45'],r['first45'],r['worst_day_pct'],r['worst_day'],r['loss_ini_pct'],r['n95_days'],r['first95'],r['dd_pct'],r['final'],r['unm']))
