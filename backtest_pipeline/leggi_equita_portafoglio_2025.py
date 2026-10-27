import sys, glob, bisect, datetime, itertools, statistics, collections
sys.path.insert(0, 'lavoro_wt/backtest_pipeline')
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
A = 'lavoro_wt/backtest_pipeline/risultati_archivio/'
ks, bars = E.carica_m1(glob.glob('exp/in/ABTG_M1_XAUUSD.csv'))
n = len(ks)
giorno = []
for k in ks:
    dt = E.EPOCA + datetime.timedelta(minutes=k)
    if G.cest(dt): dt += datetime.timedelta(hours=1)
    giorno.append(dt.date())
D0 = datetime.date(2025, 1, 3); D1 = datetime.date(2025, 12, 31)
def serie(path, dep=80000.0):
    D = E.affari_p(path)
    pos, nonacc, esatto = E.accoppia(D)
    sr = E.fx_serie(pos); med = statistics.median([f for _, f in sr]) if sr else 0.9
    fc = [0.0] * n; fp = [0.0] * n
    for (mi, mo, s, v, pi, po, prof) in pos:
        i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
        if i0 >= n or i1 <= 0: continue
        if i1 > n: i1 = n
        k_ = v * E.CONTRATTO * E.fx_a(sr, mo, med)
        for i in range(i0, i1):
            o, h, lo, c = bars[i]
            fc[i] += s * (c - pi) * k_
            fp[i] += (s * ((lo if s > 0 else h) - pi)) * k_
    delta = [0.0] * (n + 1)
    for x in D:
        i = bisect.bisect_left(ks, x['m'])
        if i <= n: delta[min(i, n)] += x['net']
    sal = []; c = 0.0
    for i in range(n):
        c += delta[i]; sal.append(c)
    return sal, fc, fp
runs = {
 'Reaper': A + 'GR80K_20261020/GRSET80K_TRANCHE1_20261020_162333.htm',
 'Goldbot': glob.glob(A + 'ANNO80K_GOLDBOT_ZIP_1608/2025_M4/*/report/*.htm.gz')[0],
 'PropFirmGold': glob.glob(A + 'TEST80K_20261019/DEEP80K_PROPFIRMGOLDEA/*.htm')[0],
}
S = {k: serie(v) for k, v in runs.items()}
idx0 = next(i for i in range(n) if giorno[i] >= D0)
idx1 = max(i for i in range(n) if giorno[i] < D1) + 1
def valuta(pesi, pess=False):
    dep = 80000.0
    sal = [0.0] * n; fl = [0.0] * n
    for k, w in pesi.items():
        s, fc, fp = S[k]; f = fp if pess else fc
        for i in range(idx0, idx1):
            sal[i] += w * s[i]; fl[i] += w * f[i]
    eq = [dep + sal[i] + fl[i] for i in range(n)]
    # max drawdown sul periodo (equita)
    pk = eq[idx0]; mdd = 0.0
    for i in range(idx0, idx1):
        if eq[i] > pk: pk = eq[i]
        d = (pk - eq[i]) / pk * 100
        if d > mdd: mdd = d
    net = sal[idx1 - 1] + 0
    # giorni
    worst = 0.0; wd = None; g3 = g4 = g5 = 0; daily = {}
    i = idx0
    while i < idx1:
        j = i; g = giorno[i]
        while j < idx1 and giorno[j] == g: j += 1
        base = dep + sal[i - 1]
        mn = min(eq[t] for t in range(i, j)); loss = (base - mn) / base * 100
        if loss > worst: worst, wd = loss, g
        g3 += loss >= 3; g4 += loss >= 4; g5 += loss >= 5
        daily[g] = sal[j - 1] - (sal[i - 1])
        i = j
    return net, mdd, worst, wd, g3, g4, g5, daily
def riga(lab, pesi):
    r = valuta(pesi); p = valuta(pesi, True)
    print('%-44s netto %+8.0f  DD equity max %5.2f%% (pess %5.2f%%)  peggior giorno %4.2f%% (pess %4.2f%%, %s)  gg>=3/4/5%%: %d/%d/%d  netto/DD %.1f' % (lab, r[0], r[1], p[1], r[2], p[2], r[3], r[4], r[5], r[6], r[0] / 80000 * 100 / max(r[1], 0.01)))
    return r
print('periodo 2025 (3/1-30/12), 80.000 EUR, ognuno come testato (peso 1) o scalato (pesi):')
res = {}
for k in S: res[k] = riga(k + ' da solo (peso 1)', {k: 1.0})
for k in S: riga(k + ' da solo meta lotto (peso 0,5)', {k: 0.5})
for a, b in itertools.combinations(S, 2):
    res[a + '+' + b] = riga('%s + %s (0,5 ciascuno)' % (a, b), {a: 0.5, b: 0.5})
riga('Reaper + Goldbot + PropFirmGold (1/3 ciascuno)', {k: 1/3 for k in S})
riga('Reaper + Goldbot + PropFirmGold (peso 1 ciascuno)', {k: 1.0 for k in S})
riga('Reaper + PropFirmGold (peso 1 ciascuno)', {'Reaper': 1.0, 'PropFirmGold': 1.0})
# correlazione giornaliera dei realizzi+flottante (variazione di pnl giornaliera)
ds = {k: valuta({k: 1.0})[7] for k in S}
gg = sorted(set.intersection(*[set(d) for d in ds.values()]))
for a, b in itertools.combinations(S, 2):
    x = [ds[a][g] for g in gg]; y = [ds[b][g] for g in gg]
    print('correlazione giornaliera dei realizzi %s/%s: %.2f (n=%d giorni)' % (a, b, statistics.correlation(x, y), len(gg)))
