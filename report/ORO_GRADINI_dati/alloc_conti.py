import sys, json, collections, itertools
sys.argv = ['x', '/tmp/_tmp.json']
src = open('/home/user/GITHUB/report/ORO_GRADINI_dati/conti_reaper_phantom_gtp.py').read()
exec(src[:src.index("LV = ('L0'")])
def ser(members):
    return {y: dict(zip(*account(members, y)[:2])) for y in Y}
def alloc(Am, Bm, sa, sb, ka=1.0):
    ya = ser(Am); yb = ser(Bm); out = {}
    for y in Y:
        ks = sorted(set(ya[y]) | set(yb[y]))
        a = {k: ya[y].get(k, 0) * sa / 80000 * ka for k in ks}; b = {k: yb[y].get(k, 0) * sb / 80000 for k in ks}
        tot = {k: a[k] + b[k] for k in ks}; cap = sa + sb
        w = min(tot.values()); wa = min(a.values()) / sa * 100; wb = min(b.values()) / sb * 100
        # DD realizzato congiunto
        cum = peak = mdd = 0.0
        for k in ks: cum += tot[k]; peak = max(peak, cum); mdd = max(mdd, peak - cum)
        out[y] = dict(net=sum(tot.values()), neta=sum(a.values()), netb=sum(b.values()), worst=w, worstpct=w / (cap * 1000) * 100 if False else w / cap * 100, wa=wa, wb=wb, mdd=mdd, mddpct=mdd / cap * 100 if False else mdd / (cap * 1000) * 100)
    return out
def fix(o):  # cap in migliaia
    pass
rows = []
for name, Am, ka, Bm in [('GR L0 pieno + PH L1+GTP', [('GR', 'L0')], 1.0, [('PH', 'L1'), ('GTP', 'COMBO')]),
                         ('GR L0 pieno + PH L0+GTP', [('GR', 'L0')], 1.0, [('PH', 'L0'), ('GTP', 'COMBO')]),
                         ('GR L0 x0,7 (scenario) + PH L1+GTP', [('GR', 'L0')], 0.7, [('PH', 'L1'), ('GTP', 'COMBO')])]:
    for sa, sb in [(80000, 80000), (160000, 80000), (80000, 160000)]:
        o = alloc(Am, Bm, sa, sb, ka)
        cap = sa + sb
        print(name, '| A', sa // 1000, 'k  B', sb // 1000, 'k  capitale', cap // 1000, 'k')
        print('   netto/anno', {y: round(o[y]['net']) for y in Y}, 'media', round(sum(o[y]['net'] for y in Y) / 4), '(A', round(sum(o[y]['neta'] for y in Y) / 4), 'B', round(sum(o[y]['netb'] for y in Y) / 4), ')')
        print('   peggior giorno congiunto EUR', {y: round(o[y]['worst']) for y in Y}, ' % capitale', {y: round(o[y]['worst'] / cap * 100, 2) for y in Y}, '| singoli A', {y: round(o[y]['wa'], 1) for y in Y}, 'B', {y: round(o[y]['wb'], 1) for y in Y})
        print('   DD realizzato congiunto % capitale', {y: round(o[y]['mdd'] / cap * 100, 1) for y in Y})
