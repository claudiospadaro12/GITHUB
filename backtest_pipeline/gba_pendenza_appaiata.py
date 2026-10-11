# gba_pendenza_appaiata.py (11/10/2026) -- STRUMENTO DI ANALISI, NON passato dal cancello (controllo-preventivo).
# Pendenza PF_V(KOFF) - PF_V(K15) del lotto R2UKTRAIL appaiata per GIORNO (giorno server del deal d ingresso), bootstrap per giorno 5.000, seed 12345.
# Uso: python3 -I backtest_pipeline/gba_pendenza_appaiata.py backtest_pipeline/risultati_archivio/GBA_R2_USCITA_20261011/GBA_R0_R2UKTRAIL.zip
# Controllo incrociato: deve ridare n e PF_V del lettore passato (K15 1.131 / 0,848; KOFF 859 / 0,900; per tranche 0,89/0,91/0,83 e 0,98/0,67/0,97).
import re, sys, zipfile, random, statistics as st
from collections import defaultdict
Z = sys.argv[1]
def num(x):
    x = x.replace('\xa0', '').replace(' ', '')
    return float(x) if x not in ('', '-') else 0.0
def deals(t):
    seg = t[t.find('<b>Affari</b>'):]
    out = []
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', seg, re.S):
        c = [re.sub(r'<[^>]+>', '', x).strip() for x in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', r, re.S)]
        if len(c) == 13 and c[3] in ('buy', 'sell'):
            out.append(c)
    return out
def pos(t):
    res, cur = [], None
    for d in deals(t):
        if d[4] == 'in': cur = d
        elif d[4] == 'out':
            res.append((cur[0][:10], num(d[10]) + num(cur[8]) + num(d[8]) + num(d[9])))
            cur = None
    return res
z = zipfile.ZipFile(Z)
cells = defaultdict(list)  # cella -> [(tranche, giorno, netto)]
for n in z.namelist():
    m = re.search(r'report[\\/].*_(K15|K35|KOFF)_(T\d)_', n)
    if m and n.endswith('.htm'):
        for d, v in pos(z.read(n).decode('utf-16', errors='replace')):
            cells[m.group(1)].append((m.group(2), d, v))
def pf(v):
    p = sum(x for x in v if x > 0); q = -sum(x for x in v if x < 0)
    return p / q if q else float('inf')
for c in ('K15', 'K35', 'KOFF'):
    L = cells[c]
    print(c, 'n', len(L), 'PF_V %.4f' % pf([x[2] for x in L]), {t: (sum(1 for x in L if x[0] == t), round(pf([x[2] for x in L if x[0] == t]), 3)) for t in ('T1', 'T2', 'T3')})
def daily(c):
    g = defaultdict(lambda: [0.0, 0.0])
    for t, d, v in cells[c]:
        if v > 0: g[d][0] += v
        else: g[d][1] -= v
    return g
A, B = daily('K15'), daily('KOFF')
days = sorted(set(A) | set(B))
def pfd(g, ds):
    p = sum(g[d][0] for d in ds if d in g); q = sum(g[d][1] for d in ds if d in g)
    return p / q
obs = pfd(B, days) - pfd(A, days)
na = [A[d][0] - A[d][1] if d in A else 0.0 for d in days]; nb = [B[d][0] - B[d][1] if d in B else 0.0 for d in days]
print('giorni (unione)', len(days), 'solo K15', len(set(A) - set(B)), 'solo KOFF', len(set(B) - set(A)))
print('correlazione dei netti giornalieri K15/KOFF %.3f' % st.correlation(na, nb))
print('pendenza osservata %.4f' % obs)
R = 5000; random.seed(12345)
pa, ind = [], []
for _ in range(R):
    s = [random.choice(days) for _ in days]
    pa.append(pfd(B, s) - pfd(A, s))
    s2 = [random.choice(days) for _ in days]
    ind.append(pfd(B, s2) - pfd(A, s))
for nome, v in (('APPAIATA per giorno', pa), ('INDIPENDENTE (giorni ricampionati separatamente)', ind)):
    v.sort()
    print('%s: sd %.4f  p2,5 %.4f  p50 %.4f  p97,5 %.4f  P(<=0) %.3f' % (nome, st.pstdev(v), v[int(.025 * R)], v[R // 2], v[int(.975 * R)], sum(1 for x in v if x <= 0) / R))
