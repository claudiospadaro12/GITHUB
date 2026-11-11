# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
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
ACC = {'A160 Goldbot Prop + Reaper Combo': [('GB','L0'),('GR','L3')], 'A80b Phantom Gradino1': [('PH','L1')], 'A80a GTP Combo': [('GTP','COMBO')],
 'B160 Goldbot Prop + Phantom Combo': [('GB','L0'),('PH','L3')], 'B80 Reaper Combo': [('GR','L3')]}
res = {}
for name, mem in ACC.items():
    res[name] = {}
    for y in ('2013', '2020', '2025'):
        adv = 0; cl = 0; bound = 0; unm = 0
        for e, lv in mem:
            a, cc, T, info = ea_eq(e, lv, y); adv = adv + a; cl = cl + cc; unm += info['unm'] + info['left']
        eq = DEP + adv; eqc = DEP + cl
        pk = np.maximum.accumulate(eq); dd = (pk - eq).max(); ddi = int((pk - eq).argmax())
        minloss = DEP - eq.min()
        days = T.astype('datetime64[D]'); worst = (0, None); n43 = 0; n5 = 0
        for d in np.unique(days):
            m = np.where(days == d)[0]; i0 = m[0]; start = eqc[i0 - 1] if i0 > 0 else DEP
            l = start - eq[m].min()
            if l > worst[0]: worst = (l, str(d))
            if l >= 0.043 * DEP: n43 += 1
            if l >= 0.05 * DEP: n5 += 1
        res[name][y] = dict(dd=dd, dd_pct=100 * dd / DEP, dd_date=str(T[ddi])[:10], minloss_pct=100 * minloss / DEP, worst_day_pct=100 * worst[0] / DEP, worst_day=worst[1], n43=n43, n5=n5, unmatched=unm, final=eq[-1] - DEP)
json.dump(res, open(sys.argv[1], 'w'), default=float)
for name, v in res.items():
    print(name)
    for y, r in v.items():
        print('   ', y, 'DD equity %.1f%% (%s)' % (r['dd_pct'], r['dd_date']), '| perdita max dall iniziale %.1f%%' % r['minloss_pct'], '| peggior giorno equity %.1f%% (%s)' % (r['worst_day_pct'], r['worst_day']), '| gg>=4,3%%: %d, >=5%%: %d' % (r['n43'], r['n5']), '| non abbinati', r['unmatched'], '| finale %.0f' % r['final'])
