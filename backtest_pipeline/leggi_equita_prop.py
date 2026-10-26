#!/usr/bin/env python3
"""Lettore CONGELATO: DD giornaliero FTMO con l'EQUITA ricostruita (flottante da barre M1 + operazioni chiuse del tester).
Criteri: report/EQUITA_GIORNALIERA_PROP_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_equita_prop.py <barre M1: uno o piu CSV (export ABTG_M1_XAUUSD.csv o file repo data/prezzi/XAUUSD_M1_BCM_*.csv)> [--da AAAA.MM.GG --a AAAA.MM.GG]
      python3 -I leggi_equita_prop.py --autotest
Senza --da/--a usa tutto il periodo coperto dalle barre. Con barre PARZIALI (anteprima) conta solo i giorni dentro la copertura e le posizioni aperte dentro."""
import sys, os, re, glob, gzip, bisect, datetime, statistics, collections, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B
import leggi_giorni_dd_prop as G

CONTRATTO = 100.0
FX_OK = (0.78, 1.00)
SOGLIE = (3.0, 4.0, 5.0)
EPOCA = datetime.datetime(2000, 1, 1)

def minuto(s):
    s = s.strip()
    dt = datetime.datetime.strptime(s[:16], '%Y.%m.%d %H:%M')
    return int((dt - EPOCA).total_seconds() // 60)

def carica_m1(paths):
    barre = {}
    for p in paths:
        for l in open(p, encoding='utf-8-sig', errors='replace'):
            if not l or l[0] in '<t': continue
            q = l.rstrip('\r\n').split('\t') if '\t' in l else l.rstrip('\r\n').split(';')
            try:
                if '\t' in l:   # formato repo: DATE TIME OPEN HIGH LOW CLOSE ...
                    t = q[0] + ' ' + q[1][:5]; o, h, lo, c = float(q[2]), float(q[3]), float(q[4]), float(q[5])
                else:           # export: time;open;high;low;close;tickvol;spread
                    t = q[0]; o, h, lo, c = float(q[1]), float(q[2]), float(q[3]), float(q[4])
                barre[minuto(t)] = (o, h, lo, c)
            except Exception:
                continue
    ks = sorted(barre)
    return ks, [barre[k] for k in ks]

def affari_p(path):
    R = B.righe(B.leggi(path)) if not path.endswith('.gz') else None
    if R is None:
        t = tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(path, 'rb').read()); t.close(); R = B.righe(B.leggi(t.name))
    ii = [k for k, r in enumerate(R) if r and r[0] in ('Affari', 'Deals')]
    D = []
    for r in R[ii[0] + 2:]:
        if len(r) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d', r[0]) and r[2] != '' and r[3] != 'balance':
            D.append(dict(t=r[0], m=minuto(r[0]), dir=r[4].lower(), tipo=r[3].lower(), vol=B.num(r[5]), px=B.num(r[6]), net=B.num(r[8]) + B.num(r[9]) + B.num(r[10]), prof=B.num(r[9]) + B.num(r[10])))
    return sorted(D, key=lambda x: x['t'])

def accoppia(D):
    """posizioni = (m_in, m_out, sign, vol, p_in, p_out, prof_out). Ritorna (posizioni, n_non_accoppiate, esatto)"""
    aperte = []; pos = []; nonacc = 0; maxopen = 0
    for x in D:
        if x['dir'].startswith('in'):
            aperte.append(dict(m=x['m'], s=1 if x['tipo'].startswith('buy') else -1, v=x['vol'], p=x['px']))
            maxopen = max(maxopen, len(aperte))
        elif x['dir'].startswith('out'):
            s = 1 if x['tipo'].startswith('sell') else -1   # un sell chiude una long
            cand = [a for a in aperte if a['s'] == s and abs(a['v'] - x['vol']) < 1e-9]
            if not cand: cand = [a for a in aperte if a['s'] == s and a['v'] >= x['vol'] - 1e-9]
            if not cand: nonacc += 1; continue
            if len(cand) > 1:   # il piu vicino per profitto implicito (cambio stimato sotto: ordine per differenza)
                cand.sort(key=lambda a: abs(s * (x['px'] - a['p']) * x['vol'] * CONTRATTO - x['prof'] / 0.9))
            a = cand[0]
            if abs(a['v'] - x['vol']) < 1e-9: aperte.remove(a)
            else: a['v'] -= x['vol']
            pos.append((a['m'], x['m'], s, x['vol'], a['p'], x['px'], x['prof']))
    return pos, nonacc, maxopen <= 1

def fx_serie(pos):
    out = []
    for (mi, mo, s, v, pi, po, prof) in pos:
        usd = s * (po - pi) * v * CONTRATTO
        if abs(usd) >= 5: out.append((mo, prof / usd))
    out.sort()
    return out

def fx_a(serie, m, mediana):
    """cambio locale = MEDIANA dei 21 campioni piu vicini nel tempo (robusta ai campioni sporcati da swap e commissioni)"""
    if not serie: return mediana
    i = bisect.bisect_left([a for a, _ in serie], m)
    lo = max(0, i - 10); hi = min(len(serie), i + 11)
    return statistics.median([serie[j][1] for j in range(lo, hi)])

def equita(D, ks, bars, dep, da=None, a=None):
    """Ritorna dict giorno -> (base_saldo, perdita_centrale_pct, perdita_pess_pct, base_eq, perdita_eq_pct) e metadati."""
    pos, nonacc, esatto = accoppia(D)
    serie = fx_serie(pos); med = statistics.median([f for _, f in serie]) if serie else 0.9
    n = len(ks); idx = {k: i for i, k in enumerate(ks)}
    fc = [0.0] * n; fp = [0.0] * n
    for (mi, mo, s, v, pi, po, prof) in pos:
        i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
        if i0 >= n or i1 <= 0: continue
        if i1 > n: i1 = n
        k_ = v * CONTRATTO * fx_a(serie, mo, med)
        for i in range(i0, i1):
            o, h, lo, c = bars[i]
            fc[i] += s * (c - pi) * k_
            fp[i] += (s * ((lo if s > 0 else h) - pi)) * k_
    # saldo realizzato per barra
    delta = [0.0] * (n + 1)
    for x in D:
        i = bisect.bisect_left(ks, x['m'])
        if i <= n: delta[min(i, n)] += x['net']
    sal = []; c = float(dep)
    for i in range(n):
        c += delta[i]; sal.append(c)
    # giorni FTMO
    giorno = []
    for k in ks:
        dt = EPOCA + datetime.timedelta(minutes=k)
        if G.cest(dt): dt += datetime.timedelta(hours=1)
        giorno.append(dt.date())
    dmin = G.giorno_ftmo(da + ' 00:00:00') if da else None
    dmax = G.giorno_ftmo(a + ' 00:00:00') if a else None
    res = collections.OrderedDict(); i = 0
    while i < n:
        j = i; g = giorno[i]
        while j < n and giorno[j] == g: j += 1
        if (dmin is None or g >= dmin) and (dmax is None or g < dmax):
            base = sal[i - 1] if i > 0 else float(dep)
            eq_prev = (sal[i - 1] + fc[i - 1]) if i > 0 else float(dep)
            mc = min(sal[t] + fc[t] for t in range(i, j)); mp = min(sal[t] + fp[t] for t in range(i, j))
            res[g] = (base, 100.0 * (base - mc) / base, 100.0 * (base - mp) / base, eq_prev, 100.0 * (eq_prev - mc) / eq_prev if eq_prev else 0.0)
        i = j
    return res, dict(pos=len(pos), nonacc=nonacc, esatto=esatto, fx_med=med, fx_ok=(FX_OK[0] <= med <= FX_OK[1]))

def conta(res, k):
    return sum(1 for v in res.values() if v[k] >= 5.0), sum(1 for v in res.values() if v[k] >= 4.0), sum(1 for v in res.values() if v[k] >= 3.0)

def autotest():
    # sintetico: 1 lotto long da 100 USD*... ingresso 2000, barre: 2000 -> minimo 1950 -> chiusura 2010; fx 0.9 ; contratto 100
    ks = [minuto('2026.01.05 10:%02d' % i) for i in range(0, 10)]
    bars = [(2000, 2001, 1999, 2000)] * 3 + [(2000, 2000, 1950, 1960)] * 3 + [(1960, 2010, 1960, 2010)] * 4
    D = [dict(t='2026.01.05 10:02:00', m=ks[2], dir='in', tipo='buy', vol=1.0, px=2000.0, net=-7.0, prof=0.0),
         dict(t='2026.01.05 10:09:00', m=ks[9], dir='out', tipo='sell', vol=1.0, px=2010.0, net=900.0, prof=900.0)]
    res, meta = equita(D, ks, bars, 80000.0)
    g = list(res)[0]; base, pc, pp, bq, pq = res[g]
    assert abs(base - 80000.0) < 1e-6 and meta['esatto'] and meta['pos'] == 1
    # equita minima centrale: saldo 79993 + (1960-2000)*100*0.9 = 79993-3600 = 76393 -> perdita (80000-76393)/80000 = 4,509%
    assert abs(pc - 100 * (80000 - (79993 - 3600)) / 80000) < 0.01, pc
    # pessimistica: low 1950 -> 79993 - 4500 = 75493 -> 5,634%
    assert abs(pp - 100 * (80000 - (79993 - 4500)) / 80000) < 0.01, pp
    assert conta(res, 1) == (0, 1, 1) and conta(res, 2) == (1, 1, 1)
    # accoppiamento con due posizioni uguali: scelta per vicinanza di profitto
    D2 = [dict(t='a', m=1, dir='in', tipo='buy', vol=1.0, px=2000.0, net=0, prof=0), dict(t='b', m=2, dir='in', tipo='buy', vol=1.0, px=2100.0, net=0, prof=0),
          dict(t='c', m=3, dir='out', tipo='sell', vol=1.0, px=2105.0, net=450.0, prof=450.0)]
    pos, nonacc, esatto = accoppia(D2); assert not esatto and pos[0][4] == 2100.0 and nonacc == 0, pos
    # giorni: estate +1 ora
    assert G.giorno_ftmo('2026.07.01 23:30:00') == datetime.date(2026, 7, 2)
    # cambio plausibile sulle corse reali (contratto 100)
    for sub in ('TEST80K_20261019/DEEP80K_PROPFIRMGOLDEA', 'TEST80K_20261019/DEEP80K_SMARTGOLDHUNTER'):
        f = glob.glob(os.path.join(G.ARCH, sub, '*.htm'))
        if f:
            D3 = affari_p(f[0]); pos, nonacc, esatto = accoppia(D3); s = fx_serie(pos)
            m = statistics.median([x for _, x in s]) if s else 0.9; assert FX_OK[0] <= m <= FX_OK[1], (sub, m)
    print('AUTOTEST OK')

def main(argv):
    da = a = None; paths = []
    i = 0
    while i < len(argv):
        if argv[i] == '--da': da = argv[i + 1]; i += 2
        elif argv[i] == '--a': a = argv[i + 1]; i += 2
        else: paths += glob.glob(argv[i]); i += 1
    ks, bars = carica_m1(paths)
    if not ks: print('nessuna barra M1 letta'); return 1
    primo = EPOCA + datetime.timedelta(minutes=ks[0]); ultimo = EPOCA + datetime.timedelta(minutes=ks[-1])
    print('barre M1: %d, da %s a %s' % (len(ks), primo, ultimo))
    da = da or (primo + datetime.timedelta(days=1)).strftime('%Y.%m.%d'); a = a or ultimo.strftime('%Y.%m.%d')
    print('giorni FTMO letti: %s -> %s (esclusi gli estremi parziali)' % (da, a))
    print('%-38s %5s | equita CENTRALE saldo-base | PESSIMISTICA saldo-base | centrale equita-base | solo realizzato | pos(acc.) esatto fx' % ('corsa', 'giorni') )
    for lab, dep, D0 in G.corse():
        pass
    # le corse con prezzi: rilegge i report con i prezzi
    for lab, dep, path in corse_con_percorso():
        D = [x for x in affari_p(path)]   # TUTTE le operazioni: il saldo a inizio finestra le comprende; i prezzi del flottante vengono dalle barre dentro la copertura
        res, meta = equita(D, ks, bars, dep, da, a)
        c1 = conta(res, 1); c2 = conta(res, 2); c4 = conta(res, 4)
        peg = min(res.items(), key=lambda z: -z[1][1]) if res else None
        d_da = datetime.date(*[int(z) for z in da.split('.')]); d_a = datetime.date(*[int(z) for z in a.split('.')])
        rl = G.sintesi(collections.OrderedDict((g, v) for g, v in G.giorni(D, dep).items() if d_da <= g < d_a), dep)   # saldo a inizio giorno dal conto completo
        print('%-38s %5d | >=5%% %2d >=4%% %2d >=3%% %2d | >=5%% %2d >=4%% %2d >=3%% %2d | >=5%% %2d | real >=5%% %2d | %5d(%d) %-6s %.3f%s' % (lab[:38], len(res), c1[0], c1[1], c1[2], c2[0], c2[1], c2[2], c4[0], rl['c'][5.0], meta['pos'], meta['nonacc'], 'ESATTO' if meta['esatto'] else 'STIMA', meta['fx_med'], '' if meta['fx_ok'] else ' CAMBIO FUORI RANGE'))
        if peg: print('     peggior giorno (centrale): %s  perdita %.2f%%  base %.0f' % (peg[0], peg[1][1], peg[1][0]))
    return 0

def corse_con_percorso():
    A = G.ARCH; L = []
    def cart(base, pref, dep, nome=''):
        for c in sorted(glob.glob(os.path.join(base, pref + '*'))):
            if not os.path.isdir(c): continue
            f = glob.glob(os.path.join(c, 'report', '*.htm*')) + glob.glob(os.path.join(c, '*.htm'))
            if f: L.append((nome + os.path.basename(c).replace(pref, ''), dep, f[0]))
    cart(os.path.join(A, 'DEEP80K_MARKET_NUOVI_20261025'), 'DEEP80K_', 80000)
    f = glob.glob(os.path.join(A, 'DEEP80K_SOMAGOLD_20261025', 'report', '*.htm*'))
    if f: L.append(('SOMAGOLD (protezione spenta)', 80000, f[0]))
    for c in sorted(glob.glob(os.path.join(A, 'DEEP80K_GUARDIA_20261025', 'DEEP80K_*'))):
        f = glob.glob(os.path.join(c, 'report', '*.htm*'))
        if f: L.append((os.path.basename(c).replace('DEEP80K_', '') + ' CON GUARDIA', 80000, f[0]))
    cart(os.path.join(A, 'TEST80K_20261019'), 'DEEP80K_', 80000, '19/10 ')
    return L

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1:]))
