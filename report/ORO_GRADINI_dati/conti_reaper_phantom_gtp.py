# Due conti: A = Gold Reaper da solo; B = Gold Phantom + Gold Trade Pro Combo. Livelli x anni 2013/2018/2020/2025 (80k, tester), costi FTMO "centrale" (36 EUR/lotto oro).
# Da lanciare dalla cartella con oro_res.json, gtp_res.json, oro/, gtp_anni/. Uso: python3 -I conti_reaper_phantom_gtp.py <out.json>
import json, glob, re, collections, itertools, datetime, statistics, sys
R = json.load(open('oro_res.json')); G = json.load(open('gtp_res.json'))
Y = ('2013', '2018', '2020', '2025'); DEP = 80000.0; COST = 36.0
def lots_of(h):
    raw = open(h, 'rb').read().decode('utf-16', 'replace'); l = 0
    for rr in re.findall(r'<tr[^>]*>(.*?)</tr>', raw[raw.find('Affari'):], flags=re.S):
        c = [re.sub(r'<[^>]+>', '', x).replace('&nbsp;', ' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', rr, flags=re.S)]
        if len(c) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d', c[0]) and c[3] in ('buy', 'sell') and c[4] == 'in':
            try: l += float(c[5].replace(' ', ''))
            except: pass
    return l
def comp(e, lv, y):
    if e == 'GTP':
        r = G['COMBO_' + y]; h = glob.glob('gtp_anni/%s_M1_GTP_COMBO/*/report/*.htm' % y)[0]
        return dict(daily=r['daily'], net=r['net'], dd=r['rel'], lots=lots_of(h))
    r = R['%s_%s_80000_%s' % (lv, e, y)]; h = glob.glob('oro/z*/*/%s_%s_80000_%s/*/report/*.htm' % (lv, e, y))[0]
    return dict(daily=r['daily'], net=r['net'], dd=max(r['ddEp'] or 0, r.get('rel') or 0), lots=lots_of(h))
def account(members, y):
    day = collections.defaultdict(float); net = 0; dd = 0; lots = 0
    for e, lv in members:
        c = comp(e, lv, y); net += c['net']; dd += c['dd']; lots += c['lots']
        for d, v in c['daily'].items(): day[d] += v
    ds = sorted(day); adj = lots * COST / max(1, len(ds))
    return ds, [day[d] - adj for d in ds], net - lots * COST, dd, lots
DL = 0.05 * DEP; TL = 0.10 * DEP
def run(vals, DS, i0, target, H):
    cum = 0.0; d0 = datetime.date.fromisoformat(DS[i0].replace('.', '-'))
    for k in range(i0, len(vals)):
        if (datetime.date.fromisoformat(DS[k].replace('.', '-')) - d0).days > H: return 'open', k
        v = vals[k]
        if v <= -DL: return 'fail_day', k
        cum += v
        if cum <= -TL: return 'fail_tot', k
        if cum >= target: return 'pass', k
    return 'open', len(vals)
def stats(members):
    out = dict(net={}, worst={}, n43={}, n5={}, bound={}, rdd={}, lots={}); tot = collections.Counter(); both = 0; n = 0; series = {}
    for y in Y:
        ds, vals, net, dd, lots = account(members, y); series[y] = (ds, vals)
        out['net'][y] = net; out['worst'][y] = min(vals) / DEP * 100; out['n43'][y] = sum(1 for v in vals if v <= -0.043 * DEP); out['n5'][y] = sum(1 for v in vals if v <= -0.05 * DEP)
        out['bound'][y] = dd; out['lots'][y] = lots
        cum = peak = 0.0; mdd = 0.0
        for v in vals: cum += v; peak = max(peak, cum); mdd = max(mdd, peak - cum)
        out['rdd'][y] = mdd / DEP * 100
        for i0 in range(len(vals)):
            st1, k1 = run(vals, ds, i0, 0.10 * DEP, 180); n += 1; tot[st1] += 1
            if st1 == 'pass' and k1 + 1 < len(vals) and run(vals, ds, k1 + 1, 0.05 * DEP, 180)[0] == 'pass': both += 1
    out['sfida'] = {k: round(100 * v / n) for k, v in tot.items()}; out['entrambe180'] = round(100 * both / n); out['nwin'] = n
    out['media'] = sum(out['net'].values()) / len(Y)
    return out, series
LV = ('L0', 'L1', 'L3'); res = {}; ser = {}
for x in LV:
    res['A_GR_' + x], ser['A_GR_' + x] = stats([('GR', x)])
for p in LV:
    res['B_PH_' + p + '+GTP'], ser['B_PH_' + p + '+GTP'] = stats([('PH', p), ('GTP', 'COMBO')])
def corr(a, b):
    out = {}
    for y in Y:
        da = dict(zip(*ser[a][y])); db = dict(zip(*ser[b][y])); ks = sorted(set(da) | set(db))
        xa = [da.get(k, 0) for k in ks]; xb = [db.get(k, 0) for k in ks]
        out[y] = statistics.correlation(xa, xb)
    return out
cc = {}
for a in [k for k in res if k.startswith('A_')]:
    for b in [k for k in res if k.startswith('B_')]: cc[a + '|' + b] = corr(a, b)
json.dump(dict(res=res, corr=cc), open(sys.argv[1], 'w'), default=float)
for k, v in res.items():
    print(k, 'media/anno', round(v['media']), {y: round(v['net'][y]) for y in Y}, 'worst%', {y: round(v['worst'][y], 1) for y in Y}, 'gg<=-4.3', sum(v['n43'].values()), 'gg<=-5', sum(v['n5'].values()), 'limite sup DD%', {y: round(v['bound'][y], 1) for y in Y}, 'DD realiz%', {y: round(v['rdd'][y], 1) for y in Y})
    print('    sfida 180gg (fase1)', v['sfida'], 'fasi 1+2', v['entrambe180'], 'finestre', v['nwin'])
for k, v in cc.items(): print(k, {y: round(c, 2) for y, c in v.items()})
