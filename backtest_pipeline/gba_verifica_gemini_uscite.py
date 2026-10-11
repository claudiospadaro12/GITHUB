# gba_verifica_gemini_uscite.py (11/10/2026) -- strumento di analisi, NON passato dal cancello. Bozza.
# Verifica delle risposte Gemini Q2/Q3 sul pacchetto docs/PER_GEMINI_USCITE_BREAKOUT_ORO_M1_2026-10-11.md.
# Uso: estrarre i report/*.htm di GBA_R0_R1A.zip e dei 4 zip GBA_R0_R2U*.zip in una cartella vuota, poi
#   python3 -I backtest_pipeline/gba_verifica_gemini_uscite.py <cartella_htm>     (~1 min)
# Accoppiamento in->out SEQUENZIALE (una posizione per volta: si asserisce l'alternanza in/out).
import re, sys, os, glob, datetime, collections, random, math

D = sys.argv[1]
TAG = re.compile(r'<[^>]+>')
TS = re.compile(r'^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$')


def num(s):
    s = s.replace(' ', '').replace('\xa0', '')
    return float(s) if s else 0.0


def leggi(path):
    t = open(path, 'rb').read().decode('utf-16')
    deal, sl = [], {}
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', t, re.S):
        c = [TAG.sub('', x).replace('\xa0', ' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', r, re.S)]
        if not c or not TS.match(c[0]):
            continue
        if len(c) == 13 and c[3] in ('buy', 'sell'):
            deal.append(c)
        elif len(c) == 11 and c[3] in ('buy', 'sell') and c[1].isdigit():
            sl[int(c[1])] = num(c[6]) if c[6] else None
    pos, aperta = [], None
    comm_tot = sum(num(c[8]) for c in deal)
    for c in deal:
        t0 = datetime.datetime.strptime(c[0], '%Y.%m.%d %H:%M:%S')
        net = num(c[8]) + num(c[9]) + num(c[10])
        if c[4] == 'in':
            assert aperta is None, ('due in di fila', path, c)
            aperta = dict(tin=t0, lato=c[3], pin=num(c[6]), vol=num(c[5]), net=net, ordine=int(c[7]))
        else:
            assert aperta is not None and c[4] in ('out', 'out by'), ('out senza in', path, c)
            assert num(c[5]) == aperta['vol']
            aperta['tout'] = t0
            aperta['net'] += net
            aperta['cmt'] = c[12]
            aperta['sl0'] = sl.get(aperta['ordine'])
            if comm_tot == 0:
                aperta['net'] -= 3.90 * aperta['vol']
            pos.append(aperta)
            aperta = None
    assert aperta is None
    return pos


def pf(v):
    gp = sum(x for x in v if x > 0); gl = -sum(x for x in v if x < 0)
    return gp / gl if gl else float('inf')


celle = collections.OrderedDict()
for f in sorted(glob.glob(os.path.join(D, '*.htm'))):
    b = os.path.basename(f)[:-4].split('_')
    if b[-1] != 'm775800':
        continue  # gemella G1 esclusa
    cella, tr = b[-3], b[-2]
    for p in leggi(f):
        p['tr'] = tr
        celle.setdefault(cella, {})[(tr, p['tin'], p['lato'])] = p
ORD = ['REPL', 'BEOFF', 'BE05', 'BE15', 'ATRFIX', 'TOFF', 'K15', 'K35', 'KOFF']
TR = ['T1', 'T2', 'T3']
print('== controllo n / PF_V per cella (atteso R2U_tabella.csv)')
for c in ORD:
    v = [p['net'] for p in celle[c].values()]
    print('  %-6s n %4d PF_V %.4f  tranche %s' % (c, len(v), pf(v), ' '.join('%s %.3f(%d)' % (t, pf([p['net'] for p in celle[c].values() if p['tr'] == t]), sum(1 for p in celle[c].values() if p['tr'] == t)) for t in TR)))

A, B = celle['K15'], celle['KOFF']
com = set(A) & set(B); sA = set(A) - set(B); sB = set(B) - set(A)
print('\n== B3: K15->KOFF comuni %d solo-K15 %d solo-KOFF %d' % (len(com), len(sA), len(sB)))
for k in sorted(sB):
    print('  solo-KOFF', k[0], k[1], k[2], 'net %.2f' % B[k]['net'], 'out', B[k]['tout'])
big = max(B.values(), key=lambda p: p['net'])
kb = (big['tr'], big['tin'], big['lato'])
print('  operazione KOFF piu grande: %s %s net %.2f -> nei comuni? %s' % (kb[1], kb[2], big['net'], kb in com))
pa = pf([A[k]['net'] for k in com]); pb = pf([B[k]['net'] for k in com])
print('  comuni PF K15 %.4f KOFF %.4f delta %+.4f' % (pa, pb, pb - pa))
# leave-one-out sui comuni
lo = []
for k in com:
    r = [x for x in com if x != k]
    lo.append((pf([B[x]['net'] for x in r]) - pf([A[x]['net'] for x in r]), k))
lo.sort()
print('  leave-one-out delta: min %+.4f (%s) max %+.4f (%s)' % (lo[0][0], lo[0][1][1], lo[-1][0], lo[-1][1][1]))
big_c = sorted(com, key=lambda k: -abs(B[k]['net'] - A[k]['net']))[:5]
for k in big_c:
    print('  comune con |dnet| grande: %s %s K15 %.2f KOFF %.2f' % (k[1], k[2], A[k]['net'], B[k]['net']))
# leave-one-DAY-out
giorni = sorted({k[1].date() for k in com})
ld = []
for g in giorni:
    r = [x for x in com if x[1].date() != g]
    ld.append((pf([B[x]['net'] for x in r]) - pf([A[x]['net'] for x in r]), g))
ld.sort()
print('  leave-one-day-out delta: min %+.4f (%s) max %+.4f (%s)' % (ld[0][0], ld[0][1], ld[-1][0], ld[-1][1]))

print('\n== B5: quasi-coincidenze fra solo-K15 e solo-KOFF (stesso lato, stessa tranche, entro N minuti)')
for N in (1, 2, 5, 15):
    m = 0
    for kb_ in sB:
        for ka in sA:
            if ka[0] == kb_[0] and ka[2] == kb_[2] and abs((ka[1] - kb_[1]).total_seconds()) <= 60 * N:
                m += 1
    print('  entro %2d min: %d coppie' % (N, m))
dp = sum(1 for k in com if abs(A[k]['pin'] - B[k]['pin']) > 1e-9 or A[k]['sl0'] != B[k]['sl0'])
print('  comuni con prezzo o SL0 diverso: %d' % dp)

print('\n== B1: distanza dello stop iniziale |prezzo - SL0| (proxy dell ATR al segnale) per insieme')
def dist(D_, ks):
    v = sorted(abs(D_[k]['pin'] - D_[k]['sl0']) for k in ks if D_[k]['sl0'])
    return len(v), v[len(v) // 2] if v else float('nan'), sum(v) / len(v) if v else float('nan')
for nome, D_, ks in [('comuni(K15)', A, com), ('solo-K15', A, sA), ('solo-KOFF', B, sB), ('cella K15', A, set(A)), ('cella KOFF', B, set(B))]:
    print('  %-12s n %4d mediana %.3f media %.3f' % ((nome,) + dist(D_, ks)))
rs = celle['REPL']; ck = celle['KOFF']
cR = set(rs) & set(ck)
for nome, D_, ks in [('REPL comuni con KOFF', rs, cR), ('REPL solo (tolti da KOFF)', rs, set(rs) - set(ck)), ('KOFF aggiunti', ck, set(ck) - set(rs))]:
    print('  %-26s n %4d mediana %.3f media %.3f' % ((nome,) + dist(D_, ks)))
# mann-whitney approssimato comuni vs solo-K15
x = [abs(A[k]['pin'] - A[k]['sl0']) for k in com if A[k]['sl0']]
y = [abs(A[k]['pin'] - A[k]['sl0']) for k in sA if A[k]['sl0']]
allv = sorted([(v, 0) for v in x] + [(v, 1) for v in y])
rk = {}; i = 0
while i < len(allv):
    j = i
    while j < len(allv) and allv[j][0] == allv[i][0]:
        j += 1
    for q in range(i, j):
        rk.setdefault(q, (i + j + 1) / 2)
    i = j
R1 = sum(rk[q] for q, (v, g) in enumerate(allv) if g == 0)
n1, n2 = len(x), len(y)
U = R1 - n1 * (n1 + 1) / 2
z = (U - n1 * n2 / 2) / math.sqrt(n1 * n2 * (n1 + n2 + 1) / 12)
print('  Mann-Whitney comuni vs solo-K15: U %.0f z %+.2f (z>0: comuni con stop PIU LARGO)' % (U, z))

print('\n== B4: autocorrelazione del netto GIORNALIERO (giorni di borsa con operazioni, ordine di calendario)')
def acf(s, L):
    m = sum(s) / len(s); v = sum((a - m) ** 2 for a in s)
    return [sum((s[i] - m) * (s[i + l] - m) for i in range(len(s) - l)) / v for l in range(1, L + 1)]
def giorn(D_, ks):
    g = collections.OrderedDict()
    for k in sorted(ks, key=lambda k: k[1]):
        g[k[1].date()] = g.get(k[1].date(), 0) + D_[k]['net']
    return g
for nome, D_, ks in [('REPL', rs, set(rs)), ('K15', A, set(A)), ('KOFF', B, set(B))]:
    g = list(giorn(D_, ks).values())
    a = acf(g, 5)
    Q = len(g) * (len(g) + 2) * sum(a[l] ** 2 / (len(g) - l - 1) for l in range(5))
    print('  %-5s giorni %3d acf1-5 %s  Ljung-Box Q5 %.2f (chi2_5 95%% = 11,07) banda +-%.3f' % (nome, len(g), ' '.join('%+.3f' % x for x in a), Q, 1.96 / math.sqrt(len(g))))
gd = collections.OrderedDict()
for k in sorted(com, key=lambda k: k[1]):
    gd[k[1].date()] = gd.get(k[1].date(), 0) + B[k]['net'] - A[k]['net']
g = list(gd.values()); a = acf(g, 5)
Q = len(g) * (len(g) + 2) * sum(a[l] ** 2 / (len(g) - l - 1) for l in range(5))
print('  dnetto comuni KOFF-K15 giorni %d acf1-5 %s Q5 %.2f' % (len(g), ' '.join('%+.3f' % x for x in a), Q))

# bootstrap a blocchi (blocchi mobili di L giorni di borsa) contro quello per giorno, stesso seed
def boot(statfun, units, L, nb=5000, seed=12345):
    rng = random.Random(seed); n = len(units); out = []
    for _ in range(nb):
        idx = []
        while len(idx) < n:
            s = rng.randrange(n - L + 1) if L > 1 else rng.randrange(n)
            idx += list(range(s, s + L))
        out.append(statfun([units[i] for i in idx[:n]]))
    out.sort(); m = sum(out) / nb
    return (sum((x - m) ** 2 for x in out) / (nb - 1)) ** 0.5, out[int(.025 * nb)], out[int(.975 * nb) - 1]
# REPL PF_V: unita' = giorno, lista di netti
gR = collections.OrderedDict()
for k in sorted(rs, key=lambda k: k[1]):
    gR.setdefault(k[1].date(), []).append(rs[k]['net'])
uR = list(gR.values())
print('\n  REPL PF_V %.4f, intervallo 2,5-97,5%%:' % pf([x for u in uR for x in u]))
for L in (1, 3, 5, 10):
    sd, lo_, hi_ = boot(lambda us: pf([x for u in us for x in u]), uR, L)
    print('    blocchi di %2d giorni: sd %.4f IC [%.3f ; %.3f]' % (L, sd, lo_, hi_))
gC = collections.OrderedDict()
for k in sorted(com, key=lambda k: k[1]):
    gC.setdefault(k[1].date(), []).append((A[k]['net'], B[k]['net']))
uC = list(gC.values())
print('  delta comuni K15->KOFF:')
for L in (1, 3, 5, 10):
    sd, lo_, hi_ = boot(lambda us: pf([b for u in us for a, b in u]) - pf([a for u in us for a, b in u]), uC, L)
    print('    blocchi di %2d giorni: sd %.4f IC [%+.3f ; %+.3f]' % (L, sd, lo_, hi_))

print('\n== Q3: 27 tranche sotto 1 se il PF vero fosse 1,0')
# nulla: dentro ogni tranche si ricampionano i GIORNI di borsa (unione dei giorni delle 9 celle);
# evento "PF tranche < 1 sotto PF vero 1" == PF ricampionato < PF campionario della stessa cella-tranche
# (scalare le perdite per PF_campione rende il PF campionario 1; il rapporto e' invariante: PF*/PF_c < 1).
day = {}
for c in ORD:
    for k, p in celle[c].items():
        day.setdefault(p['tr'], {}).setdefault(k[1].date(), {}).setdefault(c, []).append(p['net'])
def gp_gl(v):
    return sum(x for x in v if x > 0), -sum(x for x in v if x < 0)
pre = {}
for t in TR:
    gs = sorted(day[t])
    pre[t] = [{c: gp_gl(day[t][g].get(c, [])) for c in ORD} for g in gs]
pfc = {(c, t): (lambda s: s[0] / s[1])([sum(x) for x in zip(*[pre[t][i][c] for i in range(len(pre[t]))])]) for c in ORD for t in TR}
pfcell = {c: pf([p['net'] for p in celle[c].values()]) for c in ORD}
def sim(nb, condiviso, nulla, seed=777):
    rng = random.Random(seed); cnt = collections.Counter(); sotto = collections.Counter()
    for _ in range(nb):
        k = 0
        for t in TR:
            P = pre[t]; n = len(P)
            if condiviso:
                idx = [rng.randrange(n) for _ in range(n)]
            for c in ORD:
                ix = idx if condiviso else [rng.randrange(n) for _ in range(n)]
                gp = sum(P[i][c][0] for i in ix); gl = sum(P[i][c][1] for i in ix)
                rif = pfc[(c, t)] if nulla == 'tranche' else pfcell[c]
                if gl > 0 and gp / gl < rif:
                    k += 1; sotto[(c, t)] += 1
        cnt[k] += 1
    return cnt, sotto
for nulla in ('tranche', 'cella'):
    for cond in (True, False):
        nb = 20000
        cnt, sotto = sim(nb, cond, nulla)
        p27 = cnt[27] / nb
        ps = [sotto[(c, t)] / nb for c in ORD for t in TR]
        pm = sum(ps) / len(ps)
        ge = sum(v for k_, v in cnt.items() if k_ >= 24) / nb
        neff = math.log(p27) / math.log(pm) if p27 > 0 else float('nan')
        print('  nulla per %-7s giorni %-11s P(una tranche<1) media %.3f [min %.3f max %.3f]  P(27/27) %.4f  P(>=24) %.4f  N_eff ~ %.1f  media #<1 %.1f' % (
            nulla, 'CONDIVISI' if cond else 'indipendenti', pm, min(ps), max(ps), p27, ge, neff, sum(k_ * v for k_, v in cnt.items()) / nb))
# correlazione dei netti giornalieri fra celle (tutti i giorni dell'unione, 0 dove la cella non opera)
allg = sorted({g for t in TR for g in day[t]})
ser = {c: [sum(day[t][g].get(c, [])) for t in TR for g in sorted(day[t])] for c in ORD}
def corr(x, y):
    mx, my = sum(x) / len(x), sum(y) / len(y)
    return sum((a - mx) * (b - my) for a, b in zip(x, y)) / math.sqrt(sum((a - mx) ** 2 for a in x) * sum((b - my) ** 2 for b in y))
cs = [corr(ser[a], ser[b]) for i, a in enumerate(ORD) for b in ORD[i + 1:]]
print('  correlazione netti giornalieri fra le 9 celle: %d coppie, min %.3f mediana %.3f max %.3f; K15-KOFF %.3f; giorni %d' % (
    len(cs), min(cs), sorted(cs)[len(cs) // 2], max(cs), corr(ser['K15'], ser['KOFF']), len(allg)))

print('\n== B3 esteso: leave-one-out sul delta dei comuni per ogni coppia')
for a, b in [('K15', 'KOFF')] + [('REPL', c) for c in ['BEOFF', 'BE05', 'BE15', 'ATRFIX', 'TOFF', 'K15', 'K35', 'KOFF']]:
    A, B = celle[a], celle[b]
    com = set(A) & set(B)
    d0 = pf([B[k]['net'] for k in com]) - pf([A[k]['net'] for k in com])
    lo = sorted((pf([B[x]['net'] for x in com if x != k]) - pf([A[x]['net'] for x in com if x != k]), k) for k in com)
    kk = max(com, key=lambda k: abs(B[k]['net'] - A[k]['net']))
    print('%-4s->%-6s comuni %3d delta %+.4f | leave-one-out min %+.4f (%s) max %+.4f (%s) | |dnet| max %s %.0f' % (
        a, b, len(com), d0, lo[0][0], lo[0][1][1].strftime('%d/%m %H:%M'), lo[-1][0], lo[-1][1][1].strftime('%d/%m %H:%M'), kk[1].strftime('%d/%m %H:%M'), B[kk]['net'] - A[kk]['net']))

print('\n== B2: posizioni a cavallo della pausa (approssimazione oraria) e appartenenza ai comuni')
A, B = celle['K15'], celle['KOFF']
com = set(A) & set(B); sA = set(A) - set(B); sB = set(B) - set(A)
k = [x for x in com if x[1] == datetime.datetime(2026, 1, 29, 15, 48)][0]
print('29/01 15:48:', 'K15', A[k]['tout'], A[k]['cmt'], round(A[k]['net'], 2), '| KOFF', B[k]['tout'], B[k]['cmt'], round(B[k]['net'], 2))
import datetime as _dt
for kb in sB:
    near = [ka for ka in sA if ka[0] == kb[0] and ka[2] == kb[2] and abs((ka[1] - kb[1]).total_seconds()) <= 900]
    for ka in near:
        print('near-miss: solo-KOFF', kb[1], kb[2], '| solo-K15', ka[1], A[ka]['tout'], round(A[ka]['net'], 2))
def attraversa(p):
    a, b = p['tin'], p['tout']
    d = a.date()
    while d <= b.date():
        if d <= datetime.date(2026, 3, 8):
            w0 = datetime.datetime.combine(d, datetime.time(23, 0)); w1 = w0 + datetime.timedelta(minutes=65)
        else:
            w0 = datetime.datetime.combine(d, datetime.time(22, 0)); w1 = w0 + datetime.timedelta(minutes=60)
        if a < w0 + datetime.timedelta(minutes=1) and b > w0:
            return True
        d += datetime.timedelta(days=1)
    return False
for nome, D in (('KOFF', B), ('K15', A)):
    ps = [(kk, p) for kk, p in D.items() if attraversa(p)]
    print(nome, 'posizioni a cavallo della pausa (approssimazione oraria, non i giornali):', len(ps), 'netto %.2f' % sum(p['net'] for _, p in ps))
    for kk, p in sorted(ps, key=lambda x: x[0][1]):
        print('   ', kk[0], p['tin'], p['lato'], '->', p['tout'], round(p['net'], 2), 'comune' if kk in com else 'SOLO', ('K15 out %s net %.2f' % (A[kk]['tout'], A[kk]['net'])) if nome == 'KOFF' and kk in com else '')

