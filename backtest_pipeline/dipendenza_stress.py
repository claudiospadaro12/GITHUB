#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
dipendenza_stress.py -- 28/09/2026

LA DIPENDENZA NELLE GIORNATE DI STRESS (punto 2 del parere di Emiliano,
docs/PARERE_EMILIANO_2026-09-28.md). Referto:
report/DIPENDENZA_NELLO_STRESS_2026-09-28.md  (criteri congelati al par.1,
committati PRIMA dei numeri).

SOLA LETTURA. Costo macchina zero. NESSUNA proposta di taglia, soglia del
Guardian o sedia: sono firme di Claudio.

BASE DEI DATI = la stessa del Monte Carlo: importa mc_challenge_ftmo_v2 e ne
usa carica_v2() e calendario() senza modificarli (SORGENTI_V2, finestra A e
finestra B). I deal si rileggono dagli STESSI file solo per due cose che il MC
non tiene: il lordo per deal (G_d) e i volumi (proxy dello stop). Il netto
per giornata ricalcolato dai deal deve coincidere col 'giorni' di carica_v2
(controllato ad ogni corsa, altrimenti si ferma).

USO:
  python3 backtest_pipeline/dipendenza_stress.py            # tabelle del referto
  python3 backtest_pipeline/dipendenza_stress.py --autotest # contro-esempi, poi esce
"""
import argparse, collections, csv, math, os, random, re, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo_v2 as v2          # noqa: E402  (RIUSO dichiarato, non modificato)

SEME = 20260928
NPERM = 10000
N_MIN = 20                   # sotto: NON LEGGIBILE (par. 1.4)
N_P99 = 100                  # sotto: il p99 e' "= massimo osservato"
FATT = 2.0                   # taglia di campo 2,00% (misura 1%)
PAUSA, TAGLIO = 3.5, 4.5     # soglie da CONTARE (non da applicare)

V1 = list(v2.V1)             # 770101 DAX, 770202 Dow, 770411 MaxMin, 771531 EMA200
S105 = '770105 DAXshort'
PROXY = '770521 PROXY-770511'
PROXY_REL = 'risultati_prove/trades_candidati_r23/abtg_trades_ABTG_SuperWave_U30USD_770521.csv'
PROXY_DEP = 100000.0

NEWS_A = os.path.join(QUI, '..', 'mql5', 'Files', 'abtg_news_2021_2025_UTC.csv')
NEWS_26 = os.path.join(QUI, '..', 'mql5', 'Files', 'abtg_news.csv')
FINE_TRATTO_COMPLETO = '2025.07.03'


# ------------------------------------------------------------------ dati
def leggi_deal(rel):
    with open(os.path.join(QUI, rel), newline='') as fh:
        return [r for r in csv.DictReader(fh, delimiter=';')]


def sedia_da_deal(deal, dep):
    """giorni: netto per data; lordo: somma |net| dei deal in perdita per data;
       stop: proxy saldo/volume per data (max) -- vedi par. 1.3 (b)."""
    gior = collections.defaultdict(float)
    lordo = collections.defaultdict(float)
    uscite = collections.defaultdict(list)
    for r in deal:
        d = r['close_time'][:10]; x = float(r['net_profit'])
        gior[d] += x
        if x < 0:
            lordo[d] += -x
            uscite[d].append((r['close_time'][11:16], x))
    # proxy dello stop: per posizione volume totale d'uscita e saldo prima della prima uscita
    ordin = sorted(deal, key=lambda r: r['close_time'])
    prima = {}
    vol = collections.defaultdict(float)
    for r in ordin:
        prima.setdefault(r['position_id'], r['close_time'])
        vol[r['position_id']] += float(r['volume'])
    stop = {}
    for pid, t0 in prima.items():
        saldo = dep + sum(float(r['net_profit']) for r in ordin if r['close_time'] < t0)
        s = 0.01 * saldo / vol[pid] if vol[pid] > 0 else 0.0
        d = t0[:10]
        stop[d] = max(stop.get(d, 0.0), s)
    return dict(gior), dict(lordo), stop, dict(uscite)


def carica_tutto():
    dati = v2.carica_v2([n for n in v2.SORGENTI_V2 if n != '795301 ORO'])
    S = {}
    for n in V1 + [S105]:
        rel, dep = v2.SORGENTI_V2[n][0], v2.SORGENTI_V2[n][1]
        g, l, st, us = sedia_da_deal(leggi_deal(rel), dep)
        # coerenza col MC: il netto per giornata deve essere quello di carica_v2
        mc = dati[n]['giorni']
        if set(mc) != set(g) or any(abs(mc[d] - g[d]) > 1e-6 for d in g):
            raise SystemExit('ERRORE: netto per giornata di %s diverso da carica_v2 del MC' % n)
        S[n] = dict(giorni=g, lordo=l, stop=st, uscite=us, dep=dep)
    g, l, st, us = sedia_da_deal(leggi_deal(PROXY_REL), PROXY_DEP)
    S[PROXY] = dict(giorni=g, lordo=l, stop=st, uscite=us, dep=PROXY_DEP)
    calA = v2.calendario(dati, V1)
    calB = v2.calendario(dati, V1 + [S105], da='2025.07.01')
    return S, calA, calB


# ------------------------------------------------------------------ news
def leggi_news(path):
    out = []
    with open(path, encoding='utf-8', errors='replace') as fh:
        for r in csv.reader(fh, delimiter=';'):
            if len(r) < 4 or r[1] != 'High' or r[2] != 'USD':
                continue
            out.append((r[0][:10], r[0][11:16], r[3]))
    return out


def buchi(date_ev, soglia=6):
    D = sorted(set(date_ev))
    dd = [v2.data(d) for d in D]
    return [(a.strftime('%Y.%m.%d'), b.strftime('%Y.%m.%d'), (b - a).days)
            for a, b in zip(dd, dd[1:]) if (b - a).days > soglia]


def insieme_news(cal):
    ev = leggi_news(NEWS_A)
    ev26 = leggi_news(NEWS_26)
    lo, hi = cal[0], cal[-1]
    a1 = sorted(set(d for d, h, t in ev if lo <= d <= FINE_TRATTO_COMPLETO))
    a2 = sorted(set(d for d, h, t in ev if FINE_TRATTO_COMPLETO < d <= hi and 'Fed Interest Rate Decision' in t))
    a3 = sorted(set(d for d, h, t in ev26 if lo <= d <= hi))
    ore = sorted(h for d, h, t in ev + ev26 if lo <= d <= hi)
    cs = set(cal)
    info = dict(a1=a1, a2=a2, a3=a3, ore=(ore[0], ore[-1]) if ore else None,
                buchi=[b for b in buchi([d for d, h, t in ev]) if b[1] >= '2024.09.01'],
                fuori_cal=sorted(d for d in set(a1 + a2 + a3) if d not in cs))
    return sorted(d for d in set(a1 + a2 + a3) if d in cs), info


# ------------------------------------------------------------------ statistica
def fisher_sup(n, K, M, x):
    """P(X >= x), X ipergeometrica: n giornate, K perdite di A, M perdite di B."""
    den = math.comb(n, M)
    tot = 0
    for k in range(x, min(K, M) + 1):
        tot += math.comb(K, k) * math.comb(n - K, M - k)
    return tot / den


def coppia(ga, gb, giorni):
    n = len(giorni)
    A = [ga.get(d, 0.0) < 0 for d in giorni]
    B = [gb.get(d, 0.0) < 0 for d in giorni]
    K, M = sum(A), sum(B)
    x = sum(1 for a, b in zip(A, B) if a and b)
    r = dict(n=n, K=K, M=M, x=x, lift=None, p=None)
    if n == 0 or K == 0 or M == 0:
        r['stato'] = 'NON DEFINITO' if n >= N_MIN else 'NON LEGGIBILE'
        return r
    r['lift'] = (x / n) / ((K / n) * (M / n))
    r['p'] = fisher_sup(n, K, M, x)
    if n < N_MIN:
        r['stato'] = 'NON LEGGIBILE'
    elif r['lift'] > 1 and r['p'] < 0.05:
        r['stato'] = 'LEGATE'
    else:
        r['stato'] = 'NESSUN LEGAME MISURABILE'
    return r


def coop(ga, gb, giorni):
    return [d for d in giorni if d in ga and d in gb]


def perm_p(ga, gb, universo, taglia, osservato, seme=SEME, nperm=NPERM):
    """Frazione (+1 / +1) di sottoinsiemi casuali di 'universo' di taglia 'taglia'
       con co-perdite >= osservato."""
    if taglia == 0 or taglia > len(universo):
        return None
    rnd = random.Random(seme)
    co = [ga.get(d, 0.0) < 0 and gb.get(d, 0.0) < 0 for d in universo]
    idx = list(range(len(universo)))
    ge = 0
    for _ in range(nperm):
        c = sum(1 for i in rnd.sample(idx, taglia) if co[i])
        if c >= osservato:
            ge += 1
    return (ge + 1) / (nperm + 1)


def valuta_coppia(ga, gb, U, S, tipo):
    """tipo 'a'/'b': versione primaria su S, permutazione su U.
       tipo 'c'   : versione 'operano entrambe', permutazione fra le co-operative di U."""
    tutte = coppia(ga, gb, U)
    s = coppia(ga, gb, S)
    Uc = coop(ga, gb, U); Sc = coop(ga, gb, S)
    tutte_c = coppia(ga, gb, Uc)
    s_c = coppia(ga, gb, Sc)
    for r in (tutte_c, s_c):
        if r['n'] < N_MIN:
            r['stato'] = 'NON LEGGIBILE'
    if tipo == 'c':
        rif, oss, univ = tutte_c, s_c, Uc
    else:
        rif, oss, univ = tutte, s, U
    if len(S) == len(U) and set(S) == set(U):
        return dict(tutte=tutte, s=s, tutte_c=tutte_c, s_c=s_c, perm=None, piu='- (e\' il riferimento)')
    pp = perm_p(ga, gb, univ, oss['n'], oss['x']) if oss['n'] >= N_MIN else None
    if oss['n'] < N_MIN or oss['lift'] is None or rif['lift'] is None:
        piu = 'NON LEGGIBILE' if oss['n'] < N_MIN else 'NON DEFINITO'
    elif oss['lift'] > rif['lift'] and pp is not None and pp < 0.05:
        piu = 'SI'
    else:
        piu = 'NO (non dimostrato)'
    return dict(tutte=tutte, s=s, tutte_c=tutte_c, s_c=s_c, perm=pp, piu=piu)


def perc(vals, q):
    v = sorted(vals)
    if not v:
        return None
    return v[max(0, math.ceil(q * len(v)) - 1)]


def perdite_giorno(S, sedie, giorni):
    """L_d (netto, perdita positiva) e G_d (lordo) in % del saldo alla taglia 2%."""
    L, G = [], []
    for d in giorni:
        net = sum(S[n]['giorni'].get(d, 0.0) / S[n]['dep'] for n in sedie)
        lor = sum(S[n]['lordo'].get(d, 0.0) / S[n]['dep'] for n in sedie)
        L.append(-net * FATT * 100.0)
        G.append(lor * FATT * 100.0)
    return L, G


def riassunto(vals):
    n = len(vals)
    if n < N_MIN:
        return dict(n=n, stato='NON LEGGIBILE')
    return dict(n=n, stato='ok', peggiore=max(vals), p95=perc(vals, 0.95),
                p99=perc(vals, 0.99) if n >= N_P99 else None,
                sopra_p=sum(1 for x in vals if x > PAUSA), sopra_t=sum(1 for x in vals if x > TAGLIO))


def decile_alto(stop):
    """Le ceil(n/10) giornate col proxy piu' alto."""
    k = math.ceil(len(stop) / 10.0)
    return sorted(sorted(stop, key=lambda d: (-stop[d], d))[:k])


def conta_k(S, sedie, giorni):
    c = collections.Counter()
    for d in giorni:
        c[sum(1 for n in sedie if S[n]['giorni'].get(d, 0.0) < 0)] += 1
    return c


# ------------------------------------------------------------------ stampa
def f(x, nd=2):
    return '-' if x is None else ('%.*f' % (nd, x)).replace('.', ',')


def fp(x):
    if x is None:
        return '-'
    return ('%.4f' % x).replace('.', ',') if x >= 0.0001 else '<0,0001'


def stampa_coppia(a, b, nome_S, r):
    s, t, sc, tc = r['s'], r['tutte'], r['s_c'], r['tutte_c']

    def cella(x):
        if x['stato'] in ('NON LEGGIBILE', 'NON DEFINITO'):
            return '%s (n %d)' % (x['stato'], x['n'])
        return 'n %d | A %d B %d AB %d | lift %s | Fisher %s | %s' % (
            x['n'], x['K'], x['M'], x['x'], f(x['lift']), fp(x['p']), x['stato'])
    print('| %s x %s | %s | %s | %s | %s | perm %s | piu_legate: %s |' % (
        a, b, nome_S, cella(s), cella(sc), 'TUTTE: lift %s / coop %s' % (f(t['lift']), f(tc['lift'])),
        fp(r['perm']), r['piu']))


def main():
    S, calA, calB = carica_tutto()
    U = calA
    news, info = insieme_news(U)
    print('== UNIVERSO A: %s -> %s, %d giornate (MC calendario A)' % (U[0], U[-1], len(U)))
    for n in V1 + [S105, PROXY]:
        gi = S[n]['giorni']
        print('   %-22s giornate con operazioni in A: %3d | in perdita: %3d' % (
            n, sum(1 for d in U if d in gi), sum(1 for d in U if gi.get(d, 0.0) < 0)))
    print('\n== (a) NEWS USD High, buchi > 6 gg del file 2021-2025 dal 2024.09:', info['buchi'])
    print('   ore degli eventi in U (min, max):', info['ore'])
    print('   a1 (tratto completo, fino al %s): %d -> %s' % (FINE_TRATTO_COMPLETO, len(info['a1']), info['a1']))
    print('   a2 (solo Fed dopo):  %d -> %s' % (len(info['a2']), info['a2']))
    print('   a3 (abtg_news.csv 2026): %d -> %s' % (len(info['a3']), info['a3']))
    print('   fuori dal calendario U (scartate):', info['fuori_cal'])
    print('   INSIEME (a) dentro U: n = %d' % len(news))
    fer = [d for d in U if v2.data(d).weekday() < 5 and U[0] <= d <= FINE_TRATTO_COMPLETO]
    print('   classe 862 (1): nel tratto completo il flag e\' vero su %d feriali su %d (%.0f%%)' % (
        len(info['a1']), len(fer), 100.0 * len(info['a1']) / len(fer)))
    t1 = sorted(set(d for d, h, t in leggi_news(NEWS_A) + leggi_news(NEWS_26) if U[0] <= d <= U[-1]
                    and re.search(r'Nonfarm Payrolls|Non-Farm Payrolls|^CPI|Fed Interest Rate|FOMC Statement', t)))
    print('   (a-T1, aggiunto dopo la prima corsa, SOLO conteggio) NFP/CPI/Fed dentro U: n = %d -> %s' % (len(t1), t1))

    bUS = [d for d in decile_alto(S['770202 Dow']['stop']) if d in set(U)]
    bDAX = [d for d in decile_alto(S['770101 DAX']['stop']) if d in set(U)]
    print('\n== (b) PROXY stop = 0,01 x saldo / volume. 770202: %d giornate -> decile alto %d: %s' % (
        len(S['770202 Dow']['stop']), len(bUS), bUS))
    print('   770101: %d giornate -> decile alto %d: %s' % (len(S['770101 DAX']['stop']), len(bDAX), bDAX))
    c2 = [d for d in U if d in S['770202 Dow']['giorni'] and d in S['771531 EMA200']['giorni']]
    c3 = [d for d in c2 if d in S[PROXY]['giorni']]
    print('\n== (c) [NON MISURATO] come scritta. c2 (770202 e 771531 operano) n = %d | c3 proxy n = %d' % (len(c2), len(c3)))

    insiemi = [('TUTTE', U, 'a'), ('(a) news', news, 'a'), ('(b-US)', bUS, 'b'), ('(b-DAX)', bDAX, 'b'),
               ('(c2)', c2, 'c'), ('(c3) proxy', c3, 'c')]

    print('\n== DOMANDA 1: co-perdita per coppia (4 sedie misurate, universo A)')
    print('| coppia | insieme | su S (giornate di S) | su S, solo giornate in cui operano entrambe | riferimento TUTTE | perm | verdetto stress |')
    print('|---|---|---|---|---|---|---|')
    coppie = [(V1[i], V1[j]) for i in range(len(V1)) for j in range(i + 1, len(V1))]
    for a, b in coppie:
        for nome, ins, tipo in insiemi:
            r = valuta_coppia(S[a]['giorni'], S[b]['giorni'], U, ins, tipo)
            stampa_coppia(a, b, nome, r)

    print('\n== DOMANDA 1 (sensibilita\' s2): coppie col PROXY 770521 [DERIVATO]')
    for a in ('770202 Dow', '771531 EMA200'):
        for nome, ins, tipo in insiemi:
            r = valuta_coppia(S[a]['giorni'], S[PROXY]['giorni'], U, ins, tipo)
            stampa_coppia(a, PROXY, nome, r)

    print('\n== DOMANDA 1 (sensibilita\' s1): finestra B, coppie con la 770105')
    newsB, _ = insieme_news(calB)
    bUSB = [d for d in bUS if d in set(calB)]; bDAXB = [d for d in bDAX if d in set(calB)]
    insB = [('TUTTE B', calB, 'a'), ('(a) news B', newsB, 'a'), ('(b-US) B', bUSB, 'b'), ('(b-DAX) B', bDAXB, 'b')]
    for a in V1:
        for nome, ins, tipo in insB:
            r = valuta_coppia(S[a]['giorni'], S[S105]['giorni'], calB, ins, tipo)
            stampa_coppia(a, S105, nome, r)

    def tab2(titolo, sedie, lista):
        print('\n== DOMANDA 2: %s' % titolo)
        print('| insieme | misura | n | peggiore % | p95 % | p99 % | > 3,5% | > 4,5% |')
        print('|---|---|---|---|---|---|---|---|')
        for nome, ins, _ in lista:
            L, G = perdite_giorno(S, sedie, ins)
            for etich, vals in (('netto L_d', L), ('lordo G_d', G)):
                r = riassunto(vals)
                if r['stato'] != 'ok':
                    print('| %s | %s | %d | NON LEGGIBILE | | | | |' % (nome, etich, r['n']))
                else:
                    print('| %s | %s | %d | %s | %s | %s | %d | %d |' % (
                        nome, etich, r['n'], f(r['peggiore']), f(r['p95']),
                        f(r['p99']) if r['p99'] is not None else '= max, n<100', r['sopra_p'], r['sopra_t']))
    tab2('4 sedie misurate al 2%, universo A', V1, insiemi)
    tab2('s1-riferimento: le stesse 4 sedie SENZA 770105, universo B', V1, insB[:1])
    tab2('s1: 4 sedie + 770105 al 2%, universo B', V1 + [S105], insB)
    tab2('s2: 4 sedie + PROXY 770521 al 2% [DERIVATO], universo A', V1 + [PROXY], insiemi)

    def oltre(titolo, sedie, cal):
        print('\n== COMPOSIZIONE delle giornate con L_d > %s%% (%s): %% per sedia e ORA BCM dei deal in perdita' % (
            f(PAUSA, 1), titolo))
        L, _ = perdite_giorno(S, sedie, cal)
        for d, x in sorted(zip(cal, L), key=lambda t: -t[1]):
            if x <= PAUSA:
                break
            pezzi = []
            for n in sedie:
                v = S[n]['giorni'].get(d)
                if v is None:
                    continue
                ore = ','.join(h for h, _ in S[n].get('uscite', {}).get(d, []))
                pezzi.append('%s %s%s' % (n.split()[0], f(v / S[n]['dep'] * FATT * 100.0), (' [' + ore + ']') if ore else ''))
            print('   %s  L_d %s  |  %s%s' % (d, f(x), ' ; '.join(pezzi),
                  '  (a)' if d in set(news) else '') + ('  (c2)' if d in set(c2) else ''))
    oltre('4 sedie, universo A', V1, U)
    oltre('4 sedie + 770105, universo B', V1 + [S105], calB)

    print('\n== DOMANDA 3: le sedie Dow')
    dow2 = ['770202 Dow', '771531 EMA200']; dow3 = dow2 + [PROXY]
    print('| insieme | n | coppia misurata: 2 in perdita | tris proxy: >=2 in perdita | tris proxy: 3 in perdita | perm (>=2 del tris) |')
    print('|---|---|---|---|---|---|')
    rndU = U
    tris_ge2 = dict((d, sum(1 for n in dow3 if S[n]['giorni'].get(d, 0.0) < 0) >= 2) for d in U)
    for nome, ins, tipo in insiemi:
        k2, k3 = conta_k(S, dow2, ins), conta_k(S, dow3, ins)
        n = len(ins)
        if n < N_MIN:
            print('| %s | %d | NON LEGGIBILE (%d) | NON LEGGIBILE (%d) | NON LEGGIBILE (%d) | - |' % (nome, n, k2[2], k3[2] + k3[3], k3[3]))
            continue
        oss = k3[2] + k3[3]
        if tipo == 'c' or len(ins) == len(U):
            print('| %s | %d | %d (%s%%) | %d (%s%%) | %d | %s |' % (nome, n, k2[2], f(100.0 * k2[2] / n, 1), oss,
                  f(100.0 * oss / n, 1), k3[3], '- (riferimento)' if len(ins) == len(U) else 'n/a: gonfiato per costruzione'))
            continue
        rnd = random.Random(SEME)
        idx = list(range(len(rndU)))
        ge = sum(1 for _ in range(NPERM) if sum(1 for i in rnd.sample(idx, n) if tris_ge2[rndU[i]]) >= oss)
        pp = (ge + 1) / (NPERM + 1)
        print('| %s | %d | %d (%s%%) | %d (%s%%) | %d | %s |' % (nome, n, k2[2], f(100.0 * k2[2] / n, 1),
                                                                oss, f(100.0 * oss / n, 1), k3[3], fp(pp)))


# ------------------------------------------------------------------ contro-esempi
def autotest():
    ok = [True]

    def chk(nome, cond):
        print('  [%s] %s' % ('ok' if cond else 'FALLITO', nome))
        ok[0] = ok[0] and bool(cond)

    rnd = random.Random(7)
    giorni = ['D%05d' % i for i in range(3000)]
    # (i) due serie IDENTICHE: lift = 1/pA, Fisher ~0, LEGATE
    a = dict((d, rnd.choice([-1.0, 1.0, 2.0])) for d in giorni)
    r = coppia(a, dict(a), giorni)
    pA = r['K'] / r['n']
    chk('(i) identiche: x = K = M = %d, lift %.3f = 1/pA %.3f, Fisher %.2g, stato %s' % (r['x'], r['lift'], 1 / pA, r['p'], r['stato']),
        r['x'] == r['K'] == r['M'] and abs(r['lift'] - 1 / pA) < 1e-9 and r['p'] < 1e-10 and r['stato'] == 'LEGATE')
    # (ii) due serie INDIPENDENTI: lift ~1, Fisher non significativo nella maggioranza dei semi
    sig = 0; lifts = []
    for s in range(200):
        rr = random.Random(1000 + s)
        x = dict((d, rr.choice([-1.0, 1.0])) for d in giorni[:400])
        y = dict((d, rr.choice([-1.0, 1.0, 1.0])) for d in giorni[:400])
        q = coppia(x, y, giorni[:400]); lifts.append(q['lift'])
        sig += q['stato'] == 'LEGATE'
    chk('(ii) indipendenti (200 semi, n 400): lift medio %.3f, LEGATE in %d/200 (atteso ~5%%, tollerato <= 10%%)' % (
        sum(lifts) / len(lifts), sig), abs(sum(lifts) / len(lifts) - 1) < 0.03 and sig <= 20)
    # (iii) dipendenza CONDIZIONATA nota: indipendenti fuori dallo stress, identiche dentro (60 giornate su 600)
    rr = random.Random(99)
    U = giorni[:600]; ST = set(rr.sample(U, 60))
    x = dict((d, rr.choice([-1.0, 1.0])) for d in U)
    y = dict((d, (x[d] if d in ST else rr.choice([-1.0, 1.0]))) for d in U)
    r3 = valuta_coppia(x, y, U, sorted(ST), 'a')
    chk('(iii) legate SOLO nello stress: lift_S %.2f vs lift_TUTTE %.2f, perm %.4f -> "%s"' % (
        r3['s']['lift'], r3['tutte']['lift'], r3['perm'], r3['piu']), r3['piu'] == 'SI' and r3['s']['stato'] == 'LEGATE')
    # (iii-placebo) stesse serie, etichetta di stress A CASO fuori da ST: non deve dire SI
    fuori = [d for d in U if d not in ST]
    PL = sorted(random.Random(5).sample(fuori, 60))
    r4 = valuta_coppia(x, y, U, PL, 'a')
    chk('(iii-placebo) stress a caso: lift_S %.2f, perm %.3f -> "%s"' % (r4['s']['lift'], r4['perm'], r4['piu']),
        r4['piu'] != 'SI')
    # (iv) soglia di lettura: 19 giornate -> NON LEGGIBILE, 20 -> leggibile
    chk('(iv) n 19 -> %s ; n 20 -> %s' % (coppia(x, y, U[:19])['stato'], coppia(x, y, U[:20])['stato']),
        coppia(x, y, U[:19])['stato'] == 'NON LEGGIBILE' and coppia(x, y, U[:20])['stato'] != 'NON LEGGIBILE')
    # (v) Fisher contro un caso fatto a mano: n 4, K 2, M 2, x 2 -> 1/C(4,2) = 1/6
    chk('(v) Fisher a mano: P(X>=2 | n4 K2 M2) = %.6f (atteso 0,166667)' % fisher_sup(4, 2, 2, 2),
        abs(fisher_sup(4, 2, 2, 2) - 1 / 6) < 1e-12 and abs(fisher_sup(10, 3, 4, 0) - 1) < 1e-12)
    # (vi) domanda 2 a mano: due sedie su deposito 100.000, un giorno -1000 e +300, uno -1000 e -1200
    SS = {'A': dict(giorni={'g1': -1000.0, 'g2': -1000.0}, lordo={'g1': 1000.0, 'g2': 1000.0}, dep=100000.0),
          'B': dict(giorni={'g1': 300.0, 'g2': -1200.0}, lordo={'g2': 1200.0}, dep=100000.0)}
    L, G = perdite_giorno(SS, ['A', 'B'], ['g1', 'g2', 'g3'])
    chk('(vi) L = %s (atteso 1,4 / 4,4 / 0), G = %s (atteso 2,0 / 4,4 / 0) al 2%%' % (L, G),
        all(abs(p - q) < 1e-9 for p, q in zip(L, [1.4, 4.4, 0.0])) and all(abs(p - q) < 1e-9 for p, q in zip(G, [2.0, 4.4, 0.0])))
    vals = list(range(1, 101))
    chk('(vii) percentile a rango: p95 di 1..100 = %s (95), p99 = %s (99), sotto 100 il p99 non si stampa' % (
        perc(vals, 0.95), perc(vals, 0.99)), perc(vals, 0.95) == 95 and perc(vals, 0.99) == 99 and riassunto(vals[:99])['p99'] is None)
    # (viii) proxy dello stop: saldo/volume, piu' largo lo stop -> meno lotti -> proxy piu' alto
    deal = [dict(close_time='2025.01.02 15:00:00', position_id='1', volume='10', net_profit='-1000'),
            dict(close_time='2025.01.03 15:00:00', position_id='2', volume='3', net_profit='500'),
            dict(close_time='2025.01.03 15:10:00', position_id='2', volume='2', net_profit='400')]
    g, l, st, _ = sedia_da_deal(deal, 100000.0)
    chk('(viii) proxy: g1 %.1f (0,01x100000/10 = 100), g2 %.1f (0,01x99000/5 = 198); netti %s' % (
        st['2025.01.02'], st['2025.01.03'], g), abs(st['2025.01.02'] - 100) < 1e-9 and abs(st['2025.01.03'] - 198) < 1e-9
        and abs(g['2025.01.03'] - 900) < 1e-9 and decile_alto(st) == ['2025.01.03'])
    # (ix) coerenza col MC sui dati veri (carica_tutto si ferma se il netto non coincide)
    S, calA, calB = carica_tutto()
    chk('(ix) dati veri: netto per giornata == carica_v2 del MC per 5 sedie; calA %s -> %s (%d), calB %d' % (
        calA[0], calA[-1], len(calA), len(calB)), len(calA) == 277 and len(calB) == 262)
    print('AUTOTEST:', 'PASS' if ok[0] else 'FALLITO')
    return 0 if ok[0] else 1


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--autotest', action='store_true')
    a = ap.parse_args()
    sys.exit(autotest() if a.autotest else main())
