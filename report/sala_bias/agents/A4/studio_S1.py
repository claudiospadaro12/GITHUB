#!/usr/bin/env python3
"""studio_S1.py (A4, SALA-BIAS-001) - Studio S1 ESEGUITO come da criteri_studio_S1_v2.md (D002).

Domanda: il bias dei timeframe alti (W1+D1, pesi 54,5%/45,5%) della REPLICA prevede il rendimento
dell'oro meglio del caso e della deriva incondizionata?  VERDETTO SULLA REPLICA, non validata contro l'originale.

Uso:  python3 -I studio_S1.py                      # replica A4, specifica letterale
      python3 -I studio_S1.py --score-csv f.csv    # score esterno (colonne data;score_overall) = altra replica
      python3 -I studio_S1.py --ema-valid-mult 1   # variante descrittiva pre-dichiarata (EMA valida da n barre)

Solo libreria standard. Nessun parametro e' ottimizzato: tutte le costanti qui sotto sono quelle dei criteri v2.

REGOLE OPERATIVE DI A4 (dichiarate PRIMA di vedere qualunque rendimento; dove v2 e' silenzioso):
 R1 Criterio 1: spread = media(BULL)-media(BEAR) su TUTTI i giorni (sovrapposti), h=5 e 20, definizioni (a) e (b).
 R2 Welch t su campioni non sovrapposti (una osservazione ogni h giorni, posizione = offset + m*h nella serie dei
    giorni con rendimento valido), offset {0,4,8,12,16} (h=20), {0..4} (h=5), {0,12,24,36,48} (h=60, solo descrittivo).
 R3 Permutazione circolare: statistica = MEDIANA dei t di Welch sugli offset (la stessa del criterio 2); gli stati
    sono traslati circolarmente di s giorni, s in [60, N-60], 3000 shift distinti estratti con random.Random(12345)
    (se disponibili meno di 3000 shift, tutti); p unilaterale = (1 + #{T_perm >= T_oss}) / (1 + n_perm validi).
    p della permutazione anche per lo spread su tutti i giorni (descrittivo).
 R4 "Stato valutabile" (h, definizione, lettura): MIN sugli offset del numero di osservazioni non sovrapposte >= 30
    E numero di episodi (serie consecutive di giorni nello stesso stato, sulla serie dei giorni con rendimento) >= 8.
 R5 Anno valutabile (criterio 4): >= 20 giorni BULL e >= 20 giorni BEAR (definizione (a), h=20, per anno di t).
 R6 Criterio 5: eccesso BULL = media(BULL) - media(tutti i giorni) > 0 su tutti i giorni, con t >= 1,0 (t di Welch
    BULL vs NON-BULL su non sovrapposti, mediana degli offset) E media(BEAR) <= media(tutti i giorni).
 R7 MDE = (1,96+0,84) * SE (SE di Welch dello spread, non sovrapposti, mediana sugli offset): potenza 80% bilaterale 5%.
    POTENZA SUFFICIENTE se MDE(h=20,(a)) <= |deriva incondizionata a 20 giorni| della stessa lettura.
 R8 Esito: A = tutti i 5 criteri OK in ENTRAMBE le letture (lato A4; serve anche A7 e l'accordo A4/A7).
    B = almeno un criterio FAIL in una lettura con potenza sufficiente (R7), oppure regola 14 (t <= -2,0).
    C = altrimenti (criteri FAIL o NON VALUTABILI con potenza insufficiente).
 R9 Benchmark B1 (segno close - EMA200 D1, EMA con la stessa regola di validita' della replica) e B2 (segno del
    rendimento a 250 giorni): stati solo BULL/BEAR, stessa macchina; per essi si usa la sola definizione (a).
 R10 Regimi ex-post: anno LONG >= +10%, SHORT <= -5%, altrimenti LATERALE, anni 2009-2025, ritorno = close
     dell'ultima barra dell'anno / close dell'ultima barra dell'anno precedente. Ex-ante: terzili ESPANSIVI (solo dati
     fino a t, minimo 250 giorni) di ATR14 D1 / close e segno del rendimento a 250 giorni. Solo descrittivi.
"""
import sys, os, json, math, random, argparse, datetime as dt, bisect, csv
QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import prepara_dati as PD
import bias_replica as BR

# ------------------------------------------------------------------ costanti (criteri v2)
SOGLIA_A, SOGLIA_B, SOGLIA_70 = 15.0, 50.0, 70.0
LETTURE = {'primaria': dt.date(2008, 7, 1), 'robustezza': dt.date(2010, 4, 1)}
OFFSETS = {20: [0, 4, 8, 12, 16], 5: [0, 1, 2, 3, 4], 60: [0, 12, 24, 36, 48]}
SEME, N_PERM, SHIFT_MIN = 12345, 3000, 60
MIN_OBS, MIN_EPISODI, MIN_GIORNI_ANNO, MIN_ANNI = 30, 8, 20, 10
T_CRIT, P_CRIT, T_EXC = 2.0, 0.05, 1.0
MDE_Z = 1.96 + 0.84
META = dt.date(2017, 1, 1)           # prima meta: ..2016-12-31 ; seconda: 2017-01-01..
FRASI = ["verdetto sulla replica, non validata contro l'originale",
         "solo oro, W1+D1, orizzonte giornaliero, 5 e 20 giorni",
         "nessun vantaggio dimostrato non significa nessun vantaggio (si riporta l'MDE)",
         "nessuna regola EA tarabile su questi dati"]


# ------------------------------------------------------------------ statistiche (a mano)
def mediana(xs):
    xs = sorted(xs)
    n = len(xs)
    if n == 0:
        return None
    return xs[n // 2] if n % 2 else 0.5 * (xs[n // 2 - 1] + xs[n // 2])


def media(xs):
    return sum(xs) / len(xs) if xs else None


def welch(na, sa, qa, nb, sb, qb):
    """t di Welch (a - b) da n, somma, somma quadrati. Ritorna (t, df, se) o None."""
    if na < 2 or nb < 2:
        return None
    ma, mb = sa / na, sb / nb
    va = max((qa - na * ma * ma) / (na - 1), 0.0)
    vb = max((qb - nb * mb * mb) / (nb - 1), 0.0)
    se2 = va / na + vb / nb
    if se2 <= 0:
        return None
    se = math.sqrt(se2)
    df = se2 * se2 / ((va / na) ** 2 / (na - 1) + (vb / nb) ** 2 / (nb - 1)) if (va > 0 or vb > 0) else float('nan')
    return (ma - mb) / se, df, se


def somme(rs):
    s = q = 0.0
    for r in rs:
        s += r
        q += r * r
    return len(rs), s, q


def gruppi(R, X, h, o, modo):
    """Campione non sovrapposto: posizioni o, o+h, ... Ritorna (nA,sA,qA, nB,sB,qB) dove
    modo 'spread': A=BULL(+1), B=BEAR(-1); modo 'bull_resto': A=BULL, B=tutto il resto."""
    na = sa = qa = nb = sb = qb = 0
    sp = modo == 'spread'
    for x, r in zip(X[o::h], R[o::h]):
        if x == 1:
            na += 1; sa += r; qa += r * r
        elif x == -1 or (not sp):
            nb += 1; sb += r; qb += r * r
    return na, sa, qa, nb, sb, qb


def t_offsets(R, X, h, offsets, modo='spread'):
    out = []
    for o in offsets:
        g = gruppi(R, X, h, o, modo)
        w = welch(*g)
        out.append(dict(offset=o, n_bull=g[0], n_altro=g[3], t=(w[0] if w else None), df=(w[1] if w else None),
                        se=(w[2] if w else None),
                        media_bull=(g[1] / g[0] if g[0] else None), media_altro=(g[4] / g[3] if g[3] else None)))
    return out


def t_stat(rows):
    ts = [r['t'] for r in rows if r['t'] is not None]
    if not ts:
        return None, None, None
    return mediana(ts), min(ts), max(ts)


def episodi(X, val):
    """Numero e lunghezze delle serie consecutive di giorni nello stato val."""
    lens, cur = [], 0
    for x in X:
        if x == val:
            cur += 1
        elif cur:
            lens.append(cur); cur = 0
    if cur:
        lens.append(cur)
    return lens


def perm_p(R, X, h, offsets, seme=SEME, nperm=N_PERM, modo='spread', stat='t'):
    """p unilaterale (positivo) per permutazione circolare degli stati (shift >= 60 giorni)."""
    N = len(R)
    rng = random.Random(seme)
    cand = N - 2 * SHIFT_MIN + 1
    if cand <= 0:
        return None
    shifts = rng.sample(range(SHIFT_MIN, N - SHIFT_MIN + 1), nperm) if cand > nperm else list(range(SHIFT_MIN, N - SHIFT_MIN + 1))

    def T(Xs):
        if stat == 'spread':
            nb_ = ns_ = 0
            ssum_b = ssum_s = 0.0
            for x, r in zip(Xs, R):
                if x == 1:
                    nb_ += 1; ssum_b += r
                elif x == -1:
                    ns_ += 1; ssum_s += r
            if nb_ == 0 or ns_ == 0:
                return None
            return ssum_b / nb_ - ssum_s / ns_
        ts = []
        for o in offsets:
            w = welch(*gruppi(R, Xs, h, o, modo))
            if w:
                ts.append(w[0])
        return mediana(ts) if ts else None
    t_oss = T(X)
    if t_oss is None:
        return dict(p=None, t_oss=None, n_perm=0)
    ge = valid = 0
    for s in shifts:
        v = T(X[s:] + X[:s])
        if v is None:
            continue
        valid += 1
        if v >= t_oss - 1e-12:
            ge += 1
    return dict(p=(1 + ge) / (1 + valid), t_oss=t_oss, n_perm=valid, n_shift_disponibili=cand)


# ------------------------------------------------------------------ dati e stati
def stato(s, soglia):
    if s is None:
        return None
    return 1 if s >= soglia else (-1 if s <= -soglia else 0)


class Dati:
    def __init__(self, d1, score_by_date):
        self.d1 = d1
        self.N = len(d1)
        self.date = [r['date'] for r in d1]
        self.O = [r['o'] for r in d1]
        self.C = [r['c'] for r in d1]
        self.S = [score_by_date.get(r['date']) for r in d1]

    def serie(self, st, h, segnali):
        """Giorni t in [st, N-h) con rendimento valido e segnale disponibile. Ritorna (ids, R, X)."""
        ids, R, X = [], [], []
        for i in range(st, self.N - h):
            x = segnali[i]
            if x is None:
                continue
            r = BR.rendimento_fwd(self.O, self.C, i, h)
            if r is None:
                continue
            ids.append(i); R.append(r); X.append(x)
        return ids, R, X


def analisi(dati, ids, R, X, h, offsets, modo_exc=True):
    """Statistiche per stato (tutti i giorni, sovrapposti) e su campioni non sovrapposti."""
    out = dict(h=h, n_giorni=len(R), ultimo_t=dati.date[ids[-1]].isoformat() if ids else None)
    per = {}
    tutti = media(R)
    out['media_tutti'] = tutti
    for nome, v in (('BULL', 1), ('BEAR', -1), ('NEUTRAL', 0)):
        rs = [r for r, x in zip(R, X) if x == v]
        per[nome] = dict(n=len(rs), media=media(rs), pct_pos=(sum(1 for r in rs if r > 0) / len(rs) if rs else None),
                         mediana=mediana(rs), episodi=len(episodi(X, v)))
    out['stati'] = per
    mb, ms = per['BULL']['media'], per['BEAR']['media']
    out['spread'] = (mb - ms) if (mb is not None and ms is not None) else None
    out['exc_bull'] = (mb - tutti) if mb is not None else None
    out['exc_bear'] = (ms - tutti) if ms is not None else None
    rows = t_offsets(R, X, h, offsets, 'spread')
    out['offset'] = rows
    out['t_med'], out['t_min'], out['t_max'] = t_stat(rows)
    out['n_no_bull_min'] = min(r['n_bull'] for r in rows)
    out['n_no_bear_min'] = min(r['n_altro'] for r in rows)
    ep = {v: episodi(X, v) for v in (1, -1)}
    out['episodi_bull'], out['episodi_bear'] = len(ep[1]), len(ep[-1])
    out['valutabile_bull'] = out['n_no_bull_min'] >= MIN_OBS and out['episodi_bull'] >= MIN_EPISODI
    out['valutabile_bear'] = out['n_no_bear_min'] >= MIN_OBS and out['episodi_bear'] >= MIN_EPISODI
    out['valutabile'] = out['valutabile_bull'] and out['valutabile_bear']
    ses = [r['se'] for r in rows if r['se'] is not None]
    out['se_med'] = mediana(ses)
    out['mde'] = MDE_Z * out['se_med'] if ses else None
    # eccesso: t di Welch BULL vs resto
    rows5 = t_offsets(R, X, h, offsets, 'bull_resto')
    out['t_exc_med'], out['t_exc_min'], out['t_exc_max'] = t_stat(rows5)
    return out


def spread_di(R, X):
    b = [r for r, x in zip(R, X) if x == 1]
    s = [r for r, x in zip(R, X) if x == -1]
    return (media(b) - media(s)) if (b and s) else None, len(b), len(s)


# ------------------------------------------------------------------ benchmark
def segnali_benchmark(dati, ema_mult):
    C = dati.C
    N = dati.N
    e = BR.ema_raw(C, 200)
    b1, b2 = [None] * N, [None] * N
    for i in range(N):
        if e[i] is not None and (i + 1) >= ema_mult * 200:
            d = C[i] - e[i]
            b1[i] = 1 if d > 0 else (-1 if d < 0 else 0)
        if i >= 250:
            r = C[i] / C[i - 250] - 1
            b2[i] = 1 if r > 0 else (-1 if r < 0 else 0)
    return b1, b2


# ------------------------------------------------------------------ valutazione dei criteri per un segnale
def valuta_segnale(dati, sA, sB, lettura, st, con_perm=True, descrittivo=False):
    """sA, sB: liste di stati (+1/-1/0/None) per indice giorno (definizione a, b). sB puo' essere None (benchmark)."""
    res = dict(lettura=lettura, inizio=dati.date[st].isoformat())
    comb = {}
    for h in (5, 20):
        for dn, seg in (('a', sA), ('b', sB)):
            if seg is None:
                continue
            ids, R, X = dati.serie(st, h, seg)
            comb[(h, dn)] = (ids, R, X, analisi(dati, ids, R, X, h, OFFSETS[h]))
    res['analisi'] = {'h%d_%s' % k: v[3] for k, v in comb.items()}
    # --- criterio 1
    stati1, fail, nv = {}, False, False
    for k, v in comb.items():
        a = v[3]
        sp = a['spread']
        stato_k = 'OK'
        if sp is None or sp <= 0:
            stato_k = 'FAIL'
        elif not a['valutabile']:
            stato_k = 'NV'
        stati1['h%d_%s' % k] = stato_k
    c1 = 'FAIL' if 'FAIL' in stati1.values() else ('NV' if 'NV' in stati1.values() else 'OK')
    # --- criterio 2 (h=20, a)
    ids, R, X, a20 = comb[(20, 'a')]
    pp = None
    if con_perm:
        pp = perm_p(R, X, 20, OFFSETS[20])
    res['perm_20a'] = pp
    if con_perm:
        res['perm_20a_spread_tutti'] = perm_p(R, X, 20, OFFSETS[20], stat='spread')
    if not a20['valutabile']:
        c2 = 'NV'
    elif a20['t_med'] is not None and a20['t_med'] >= T_CRIT and pp and pp['p'] is not None and pp['p'] <= P_CRIT:
        c2 = 'OK'
    else:
        c2 = 'FAIL'
    if not con_perm:
        c2 = 'n/d'
    # --- criterio 3: due meta
    meta = {}
    i1 = [k for k, i in enumerate(ids) if dati.date[i] < META]
    i2 = [k for k, i in enumerate(ids) if dati.date[i] >= META]
    for nome, kk in (('prima', i1), ('seconda', i2)):
        sp, nb, ns = spread_di([R[k] for k in kk], [X[k] for k in kk])
        meta[nome] = dict(spread=sp, n_bull=nb, n_bear=ns, da=dati.date[ids[kk[0]]].isoformat() if kk else None,
                          a=dati.date[ids[kk[-1]]].isoformat() if kk else None)
    res['meta'] = meta
    if any(m['spread'] is None for m in meta.values()) or not a20['valutabile']:
        c3 = 'NV'
        if any(m['spread'] is not None and m['spread'] <= 0 for m in meta.values()):
            c3 = 'FAIL'
    else:
        c3 = 'OK' if all(m['spread'] > 0 for m in meta.values()) else 'FAIL'
    # --- criterio 4: anni
    anni = {}
    for k, i in enumerate(ids):
        anni.setdefault(dati.date[i].year, []).append(k)
    righe_anni, val, pos = [], 0, 0
    for y in sorted(anni):
        kk = anni[y]
        sp, nb, ns = spread_di([R[k] for k in kk], [X[k] for k in kk])
        ev = nb >= MIN_GIORNI_ANNO and ns >= MIN_GIORNI_ANNO
        righe_anni.append(dict(anno=y, n_bull=nb, n_bear=ns, spread=sp, valutabile=ev))
        if ev:
            val += 1
            if sp is not None and sp > 0:
                pos += 1
    soglia_anni = math.ceil(0.6 * val - 1e-12) if val else None
    res['anni'] = dict(righe=righe_anni, valutabili=val, positivi=pos, soglia=soglia_anni)
    if val < MIN_ANNI:
        c4 = 'NV'
    else:
        c4 = 'OK' if pos >= soglia_anni else 'FAIL'
    # --- criterio 5
    exc_ok = a20['exc_bull'] is not None and a20['exc_bull'] > 0
    t_ok = a20['t_exc_med'] is not None and a20['t_exc_med'] >= T_EXC
    bear_ok = a20['exc_bear'] is not None and a20['exc_bear'] <= 0
    if not a20['valutabile']:
        c5 = 'NV'
    else:
        c5 = 'OK' if (exc_ok and t_ok and bear_ok) else 'FAIL'
    res['c5_dettaglio'] = dict(exc_bull=a20['exc_bull'], t_exc_med=a20['t_exc_med'], exc_bear=a20['exc_bear'],
                               exc_bull_pos=exc_ok, t_ok=t_ok, bear_sotto_media=bear_ok)
    res['criteri'] = {1: c1, 2: c2, 3: c3, 4: c4, 5: c5}
    res['criterio1_dettaglio'] = stati1
    drift = a20['media_tutti']
    res['potenza'] = dict(mde_20a=a20['mde'], deriva_20=drift, sufficiente=(a20['mde'] is not None and drift is not None and a20['mde'] <= abs(drift)))
    res['regola14'] = a20['t_med'] is not None and a20['t_med'] <= -T_CRIT
    return res


def esito_da(rl):
    """rl: dict lettura -> risultato di valuta_segnale. Applica R8."""
    tutti = [(l, c, s) for l, r in rl.items() for c, s in r['criteri'].items()]
    if any(r['regola14'] for r in rl.values()):
        return 'B', 'regola 14: t <= -2,0 -> segnale inverso, non adottabile senza dati nuovi'
    if all(s == 'OK' for _, _, s in tutti):
        return 'A', 'tutti i criteri 1-5 soddisfatti in entrambe le letture (lato A4; serve A7 e l\'accordo A4/A7)'
    falliti = [(l, c) for l, c, s in tutti if s == 'FAIL' and rl[l]['potenza']['sufficiente']]
    if falliti:
        return 'B', 'criteri FAIL con potenza sufficiente (MDE <= deriva): %s' % falliti
    dettagli = [(l, c, s) for l, c, s in tutti if s != 'OK']
    return 'C', 'criteri non soddisfatti o non valutabili con potenza insufficiente: %s' % dettagli


# ------------------------------------------------------------------ descrittivi
def descrittivi(dati, sA, st, regimi=True):
    out = {}
    ids, R, X = dati.serie(st, 20, sA)
    # h=60
    ids60, R60, X60 = dati.serie(st, 60, sA)
    a60 = analisi(dati, ids60, R60, X60, 60, OFFSETS[60])
    out['h60'] = dict(spread=a60['spread'], media_tutti=a60['media_tutti'], n=a60['n_giorni'], t_med=a60['t_med'],
                      t_min=a60['t_min'], t_max=a60['t_max'], stati={k: dict(n=v['n'], media=v['media']) for k, v in a60['stati'].items()},
                      ultimo_t=a60['ultimo_t'])
    # leave-out
    lo = {}
    for nome, anni in (('senza_2008', {2008}), ('senza_2025_2026', {2025, 2026}), ('senza_2008_2025_2026', {2008, 2025, 2026})):
        kk = [k for k, i in enumerate(ids) if dati.date[i].year not in anni]
        sp, nb, ns = spread_di([R[k] for k in kk], [X[k] for k in kk])
        lo[nome] = dict(spread=sp, n_bull=nb, n_bear=ns, media_tutti=media([R[k] for k in kk]))
    out['leave_out_h20_a'] = lo
    # regimi ex-post (anni 2009-2025)
    ultimo = {}
    for i, d in enumerate(dati.date):
        ultimo[d.year] = i
    reg_anno = {}
    for y in range(2009, 2026):
        r = dati.C[ultimo[y]] / dati.C[ultimo[y - 1]] - 1
        reg_anno[y] = (r, 'LONG' if r >= 0.10 else ('SHORT' if r <= -0.05 else 'LATERALE'))
    out['regimi_anni'] = {y: dict(rendimento=v[0], regime=v[1]) for y, v in reg_anno.items()}
    celle = {}
    for reg in ('LONG', 'SHORT', 'LATERALE'):
        kk = [k for k, i in enumerate(ids) if dati.date[i].year in reg_anno and reg_anno[dati.date[i].year][1] == reg]
        celle[reg] = cella(dati, ids, R, X, kk)
        celle[reg]['anni'] = [y for y in reg_anno if reg_anno[y][1] == reg]
    out['regimi_expost_h20_a'] = celle
    # ex-ante: terzili espansivi ATR14%/close; segno rendimento 250 gg
    atr = BR.atr_wilder([r['h'] for r in dati.d1], [r['l'] for r in dati.d1], dati.C, 14)
    ap = [(atr[i] / dati.C[i]) if atr[i] is not None else None for i in range(dati.N)]
    storia, terz = [], [None] * dati.N
    for i in range(dati.N):
        if ap[i] is None:
            continue
        bisect.insort(storia, ap[i])
        if len(storia) >= 250:
            f = bisect.bisect_left(storia, ap[i]) / len(storia)
            terz[i] = 'ATR_basso' if f < 1 / 3 else ('ATR_medio' if f < 2 / 3 else 'ATR_alto')
    seg250 = [None] * dati.N
    for i in range(250, dati.N):
        seg250[i] = 'rend250_su' if dati.C[i] / dati.C[i - 250] - 1 > 0 else 'rend250_giu'
    ea = {}
    for nome, lab in (('terzili_ATR14', terz), ('segno_rend250', seg250)):
        for cat in sorted(set(x for x in lab if x)):
            kk = [k for k, i in enumerate(ids) if lab[i] == cat]
            ea[cat] = cella(dati, ids, R, X, kk)
    out['exante_h20_a'] = ea
    return out


def cella(dati, ids, R, X, kk):
    """Spread (tutti i giorni) in una cella di giorni (indici k nella serie), con episodi per stato."""
    sp, nb, ns = spread_di([R[k] for k in kk], [X[k] for k in kk])
    mb = media([R[k] for k in kk if X[k] == 1])
    ms = media([R[k] for k in kk if X[k] == -1])
    mt = media([R[k] for k in kk])
    ep = {1: 0, -1: 0}
    prev = None
    for k in kk:
        x = X[k]
        if x in ep and not (prev is not None and prev[0] == k - 1 and prev[1] == x):
            ep[x] += 1
        prev = (k, x)
    anni = sorted(set(dati.date[ids[k]].year for k in kk))
    return dict(n_giorni=len(kk), n_bull=nb, n_bear=ns, media_bull=mb, media_bear=ms, media_tutti=mt, spread=sp,
                episodi_bull=ep[1], episodi_bear=ep[-1], anni_n=len(anni))


def frequenze(dati, st, soglia_stato_fn_list):
    """Frequenze ed episodi per stato sulla serie dei giorni con score, da st all'ultimo giorno incluso."""
    out = {}
    idx = [i for i in range(st, dati.N) if dati.S[i] is not None]
    out['n_giorni_con_score'] = len(idx)
    out['n_giorni_senza_score'] = (dati.N - st) - len(idx)
    for nome, soglia in (('a_soglia15', SOGLIA_A), ('b_deciso50', SOGLIA_B), ('lettura_70', SOGLIA_70)):
        X = [stato(dati.S[i], soglia) for i in idx]
        d = {}
        for lab, v in (('BULL', 1), ('BEAR', -1), ('NEUTRAL', 0)):
            ep = episodi(X, v)
            d[lab] = dict(giorni=sum(1 for x in X if x == v), pct=100.0 * sum(1 for x in X if x == v) / len(X),
                          episodi=len(ep), lung_media=media(ep), lung_mediana=mediana(ep), lung_max=max(ep) if ep else 0)
        out[nome] = d
    return out


# ------------------------------------------------------------------ main
def fmt(x, p=3, pct=False):
    if x is None:
        return 'n/d'
    if isinstance(x, float) and (math.isnan(x)):
        return 'nan'
    return ('%.' + str(p) + 'f%s') % (x * 100 if pct else x, '%' if pct else '')


def autotest_stat():
    """Mini-autotest delle funzioni statistiche (a mano) e del test di permutazione su dati sintetici."""
    righe, ok = [], True

    def chk(nome, cond, det=''):
        nonlocal ok
        ok = ok and cond
        righe.append('%s  %s%s' % ('PASS' if cond else 'FAIL', nome, ('  | ' + det) if det else ''))
        print(righe[-1], flush=True)
    w = welch(*somme([1.0, 2.0, 3.0]), *somme([2.0, 4.0, 6.0]))
    chk('S1 Welch a mano: [1,2,3] vs [2,4,6] -> t=-2/sqrt(5/3)=-1.5492', abs(w[0] + 2 / math.sqrt(5 / 3)) < 1e-12, 'df=%.4f' % w[1])
    chk('S2 mediana pari/dispari', mediana([3, 1, 2]) == 2 and mediana([4, 1, 2, 3]) == 2.5)
    chk('S3 episodi: [1,1,0,1,-1,-1,1] -> BULL 3 episodi (2,1,1), BEAR 1', episodi([1, 1, 0, 1, -1, -1, 1], 1) == [2, 1, 1] and episodi([1, 1, 0, 1, -1, -1, 1], -1) == [2])
    chk('S4 ceil(0,6 x anni): 17 -> 11, 10 -> 6', math.ceil(0.6 * 17 - 1e-12) == 11 and math.ceil(0.6 * 10 - 1e-12) == 6)
    # sintetico: rendimenti gaussiani, stati a blocchi persistenti
    rng = random.Random(777)
    N = 4000

    def stati_blocchi(rng):
        X, v = [], 0
        while len(X) < N:
            v = rng.choice([1, 1, -1, 0])
            X.extend([v] * rng.randint(10, 60))
        return X[:N]
    X = stati_blocchi(rng)
    R0 = [rng.gauss(0.0, 0.02) for _ in range(N)]
    p0 = perm_p(R0, X, 20, OFFSETS[20], nperm=500)
    R1 = [r + (0.01 if x == 1 else (-0.01 if x == -1 else 0.0)) for r, x in zip(R0, X)]
    p1 = perm_p(R1, X, 20, OFFSETS[20], nperm=500)
    chk('S5 permutazione: effetto piantato (+-1%) -> p piccolo (<0,01); nullo -> p non estremo', p1['p'] < 0.01 and p0['p'] > 0.01,
        'p_piantato=%.4f p_nullo=%.4f' % (p1['p'], p0['p']))
    # test di calibrazione: p sotto l'ipotesi nulla ~ uniforme (frazione p<=0,05 non troppo alta)
    cnt, tot = 0, 40
    for k in range(tot):
        rr = random.Random(1000 + k)
        Xk = stati_blocchi(rr)
        Rk = [rr.gauss(0, 0.02) for _ in range(N)]
        pk = perm_p(Rk, Xk, 20, OFFSETS[20], nperm=200)
        cnt += (pk['p'] <= 0.05)
    chk('S6 calibrazione del test di permutazione sotto H0: %d/%d simulazioni con p<=0,05 (atteso ~5%%, accetto <=8)' % (cnt, tot), cnt <= 8)
    return ok, righe


def carica_score_csv(path):
    m = {}
    with open(path, newline='') as f:
        rd = csv.DictReader(f, delimiter=';')
        for r in rd:
            d = r['data'].strip().replace('.', '-').replace('/', '-')
            m[dt.date.fromisoformat(d)] = float(r['score_overall']) if r['score_overall'].strip() not in ('', 'nan', 'NaN', 'None') else None
    return m


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--score-csv', default=None)
    ap.add_argument('--d1', default=os.path.join(QUI, 'D1_fuso.csv'))
    ap.add_argument('--ema-valid-mult', type=int, default=2)
    ap.add_argument('--out-prefix', default=None)
    ap.add_argument('--salta-gate', action='store_true', help='non rieseguire l\'autotest (solo debug)')
    args = ap.parse_args()
    prefix = args.out_prefix or ('studio_S1' if (args.score_csv is None and args.ema_valid_mult == 2) else
                                 ('studio_S1_ext' if args.score_csv else 'studio_S1_varN'))
    L = []

    def P(*a):
        s = ' '.join(str(x) for x in a)
        L.append(s)
        print(s, flush=True)

    P('STUDIO S1 - criteri v2 (D002). Eseguito %s' % dt.datetime.now().strftime('%Y-%m-%d %H:%M'))
    P('Sorgente score: %s | EMA valida da %d*n barre | D1 fuso: %s' % (
        args.score_csv or 'replica A4 interna (bias_replica.py)', args.ema_valid_mult, os.path.basename(args.d1)))
    for f in FRASI:
        P('  * ' + f)
    d1 = PD.leggi_d1(args.d1)
    # ---- GATE: test di causalita' e autotest. Lo studio non parte se falliscono.
    P('\n=== 0. GATE: AUTOTEST (lo studio non parte se uno fallisce) ===')
    ok_st, righe_st = autotest_stat()
    if args.salta_gate:
        ok_gate = ok_st
        L.append('GATE DI CAUSALITA\' SALTATO (--salta-gate, solo debug su dati sintetici): output NON valido come verdetto')
    elif args.score_csv is None:
        es = BR.autotest(d1_path=args.d1)
        ok_gate = es.ok and ok_st
        L.extend(es.righe)
    else:
        es = BR.autotest(d1_path=args.d1, solo_rapidi=True)
        ok_gate = ok_st and es.ok
        L.append('(score esterno: test di causalita\' della replica NON eseguiti qui; eseguiti solo test dati/rendimenti)')
        L.extend(es.righe)
    L.extend(righe_st)
    if not ok_gate:
        P('GATE FALLITO: lo studio e\' INVALIDO e non si riporta nessun verdetto.')
        open(os.path.join(QUI, prefix + '_output.txt'), 'w').write('\n'.join(L) + '\n')
        sys.exit(2)
    P('GATE: TUTTI I TEST PASSATI')

    # ---- score
    if args.score_csv:
        sc = carica_score_csv(args.score_csv)
        extra = None
    else:
        params = {'EMA_VALID_MULT': args.ema_valid_mult}
        ov = BR.calcola_overall(d1, params=params)
        sc = {r['date']: r['S'] for r in ov}
        extra = ov
        with open(os.path.join(QUI, ('score_A4.csv' if args.ema_valid_mult == 2 else 'score_A4_varN.csv')), 'w') as f:
            f.write('data;score_overall;score_w1;score_d1\n')
            for r in ov:
                f.write('%s;%s;%s;%s\n' % (r['date'].isoformat(), '' if r['S'] is None else repr(round(r['S'], 10)),
                                          '' if r['sW'] is None else repr(round(r['sW'], 10)),
                                          '' if r['sD'] is None else repr(round(r['sD'], 10))))
    dati = Dati(d1, sc)
    P('\nD1 fuso: %d barre %s .. %s (ultima settimana 2026-10-19 e barra 2026-10-21 ESCLUSE)' % (dati.N, dati.date[0], dati.date[-1]))
    sA = [stato(s, SOGLIA_A) for s in dati.S]
    sB = [stato(s, SOGLIA_B) for s in dati.S]
    start = {n: next(i for i, d in enumerate(dati.date) if d >= dd) for n, dd in LETTURE.items()}
    ris = dict(meta=dict(sorgente=args.score_csv or 'A4', ema_valid_mult=args.ema_valid_mult, n_barre=dati.N,
                         prima=dati.date[0].isoformat(), ultima=dati.date[-1].isoformat()))

    # ---- 1. frequenze ed episodi (per primo)
    P('\n=== 1. FREQUENZE ED EPISODI PER STATO (prima di qualunque rendimento) ===')
    ris['frequenze'] = {}
    for n, st in start.items():
        fr = frequenze(dati, st, None)
        ris['frequenze'][n] = fr
        P('--- lettura %s dal %s: %d giorni con score (senza score: %d)' % (n, dati.date[st], fr['n_giorni_con_score'], fr['n_giorni_senza_score']))
        for nome, tit in (('a_soglia15', '(a) soglia 15'), ('b_deciso50', '(b) segnale deciso |S|>=50'), ('lettura_70', 'lettura |S|>=70 (solo lettura)')):
            P('  ' + tit)
            for lab in ('BULL', 'BEAR', 'NEUTRAL'):
                v = fr[nome][lab]
                P('    %-8s giorni %5d  %5.1f%%  episodi %4d  lunghezza media %.1f mediana %.1f max %d' % (
                    lab, v['giorni'], v['pct'], v['episodi'], v['lung_media'] or 0, v['lung_mediana'] or 0, v['lung_max']))
    if extra is not None:
        sw = [r['sW'] for r in extra if r['date'] >= LETTURE['primaria']]
        sd = [r['sD'] for r in extra if r['date'] >= LETTURE['primaria']]
        P('  (S_W1 e S_D1 dal 2008-07-01: giorni con S_W1 %d, S_D1 %d su %d)' % (sum(x is not None for x in sw), sum(x is not None for x in sd), len(sw)))

    # ---- 2. criteri
    ris['letture'] = {}
    rl = {}
    for n, st in start.items():
        rl[n] = valuta_segnale(dati, sA, sB, n, st)
        ris['letture'][n] = rl[n]
    P('\n=== 2. RENDIMENTI close[t+h]/open[t+1]-1 (ingresso open t+1, uscita close t+h; nessun costo) ===')
    for n in start:
        r = rl[n]
        P('\n--- LETTURA %s (t da %s) ---' % (n.upper(), r['inizio']))
        for k, a in r['analisi'].items():
            P('  [%s] ultimo t incluso %s | giorni %d | media tutti i giorni %s' % (k, a['ultimo_t'], a['n_giorni'], fmt(a['media_tutti'], 3, True)))
            for lab in ('BULL', 'BEAR', 'NEUTRAL'):
                v = a['stati'][lab]
                P('      %-8s n=%5d media %8s  %%positivi %5s  mediana %8s  episodi %d' % (
                    lab, v['n'], fmt(v['media'], 3, True), fmt(v['pct_pos'], 1, True), fmt(v['mediana'], 3, True), v['episodi']))
            P('      spread BULL-BEAR %s | eccesso BULL %s | eccesso BEAR %s' % (fmt(a['spread'], 3, True), fmt(a['exc_bull'], 3, True), fmt(a['exc_bear'], 3, True)))
            P('      Welch t (non sovrapposti, offset %s): mediana %s min %s max %s | n minimi BULL/BEAR %d/%d | episodi %d/%d | valutabile %s' % (
                OFFSETS[a['h']], fmt(a['t_med'], 2), fmt(a['t_min'], 2), fmt(a['t_max'], 2), a['n_no_bull_min'], a['n_no_bear_min'],
                a['episodi_bull'], a['episodi_bear'], 'SI' if a['valutabile'] else 'NO (stato non valutabile)'))
            P('      MDE (80%% potenza) %s | t eccesso BULL-vs-resto: mediana %s' % (fmt(a['mde'], 3, True), fmt(a['t_exc_med'], 2)))
        pp = r['perm_20a']
        P('  Permutazione circolare h=20 (a): T oss (t mediano) %s, p unilaterale %s (n perm %s, shift disponibili %s)' % (
            fmt(pp['t_oss'], 2), fmt(pp['p'], 4), pp['n_perm'], pp.get('n_shift_disponibili')))
        p2 = r['perm_20a_spread_tutti']
        P('  Permutazione (descrittiva) spread su tutti i giorni h=20 (a): spread oss %s, p %s' % (fmt(p2['t_oss'], 3, True), fmt(p2['p'], 4)))
        P('  Due meta: prima %s..%s spread %s (BULL %d, BEAR %d) | seconda %s..%s spread %s (BULL %d, BEAR %d)' % (
            r['meta']['prima']['da'], r['meta']['prima']['a'], fmt(r['meta']['prima']['spread'], 3, True), r['meta']['prima']['n_bull'], r['meta']['prima']['n_bear'],
            r['meta']['seconda']['da'], r['meta']['seconda']['a'], fmt(r['meta']['seconda']['spread'], 3, True), r['meta']['seconda']['n_bull'], r['meta']['seconda']['n_bear']))
        an = r['anni']
        P('  Anni (h=20, a): valutabili %d, spread>0 in %d, soglia ceil(0,6 x %d) = %s' % (an['valutabili'], an['positivi'], an['valutabili'], an['soglia']))
        for x in an['righe']:
            P('      %d  BULL %4d BEAR %4d  spread %9s  %s' % (x['anno'], x['n_bull'], x['n_bear'], fmt(x['spread'], 2, True), '' if x['valutabile'] else '(non valutabile)'))
        P('  Potenza: MDE h=20(a) %s vs deriva incondizionata 20 gg %s -> potenza %s' % (
            fmt(r['potenza']['mde_20a'], 3, True), fmt(r['potenza']['deriva_20'], 3, True), 'SUFFICIENTE' if r['potenza']['sufficiente'] else 'INSUFFICIENTE'))
        P('  Criterio 1 dettaglio: %s' % r['criterio1_dettaglio'])
        P('  Criterio 5 dettaglio: %s' % {k: (round(v, 5) if isinstance(v, float) else v) for k, v in r['c5_dettaglio'].items()})
        P('  CRITERI (%s): %s' % (n, ' | '.join('%d=%s' % (k, v) for k, v in r['criteri'].items())))

    # ---- 3. benchmark
    P('\n=== 3. BENCHMARK BANALI (stessa macchina) ===')
    b1, b2 = segnali_benchmark(dati, args.ema_valid_mult)
    ris['benchmark'] = {}
    for nome, seg, desc in (('B1', b1, 'segno close D1 - EMA200 D1'), ('B2', b2, 'segno rendimento 250 giorni')):
        ris['benchmark'][nome] = {}
        for n, st in start.items():
            r = valuta_segnale(dati, seg, None, n, st)
            ris['benchmark'][nome][n] = r
            P('--- %s (%s), lettura %s' % (nome, desc, n))
            for h in (5, 20):
                a = r['analisi']['h%d_a' % h]
                P('    h=%2d  media BULL %s (n %d) | media BEAR %s (n %d) | media tutti %s | spread %s | t mediano %s [%s..%s]' % (
                    h, fmt(a['stati']['BULL']['media'], 3, True), a['stati']['BULL']['n'], fmt(a['stati']['BEAR']['media'], 3, True),
                    a['stati']['BEAR']['n'], fmt(a['media_tutti'], 3, True), fmt(a['spread'], 3, True), fmt(a['t_med'], 2), fmt(a['t_min'], 2), fmt(a['t_max'], 2)))
            P('    p permutazione h=20: %s | criteri: %s' % (fmt(r['perm_20a']['p'], 4), ' '.join('%d=%s' % kv for kv in r['criteri'].items())))
    P('  Medie ASSOLUTE a confronto (h=20, lettura primaria): replica BULL %s BEAR %s | B1 BULL %s BEAR %s | B2 BULL %s BEAR %s | tutti i giorni %s' % (
        fmt(rl['primaria']['analisi']['h20_a']['stati']['BULL']['media'], 3, True), fmt(rl['primaria']['analisi']['h20_a']['stati']['BEAR']['media'], 3, True),
        fmt(ris['benchmark']['B1']['primaria']['analisi']['h20_a']['stati']['BULL']['media'], 3, True), fmt(ris['benchmark']['B1']['primaria']['analisi']['h20_a']['stati']['BEAR']['media'], 3, True),
        fmt(ris['benchmark']['B2']['primaria']['analisi']['h20_a']['stati']['BULL']['media'], 3, True), fmt(ris['benchmark']['B2']['primaria']['analisi']['h20_a']['stati']['BEAR']['media'], 3, True),
        fmt(rl['primaria']['analisi']['h20_a']['media_tutti'], 3, True)))

    # ---- 4. descrittivi
    P('\n=== 4. SOLO DESCRITTIVO: h=60, leave-out, regimi EX-POST (non utilizzabili come filtro), taglio EX-ANTE ===')
    ris['descrittivi'] = {}
    for n, st in start.items():
        ds = descrittivi(dati, sA, st)
        ris['descrittivi'][n] = ds
        P('--- lettura %s' % n)
        h6 = ds['h60']
        P('  h=60 (a): spread %s | BULL n %d media %s | BEAR n %d media %s | tutti %s | t mediano %s [%s..%s] (offset %s) ultimo t %s' % (
            fmt(h6['spread'], 3, True), h6['stati']['BULL']['n'], fmt(h6['stati']['BULL']['media'], 3, True), h6['stati']['BEAR']['n'],
            fmt(h6['stati']['BEAR']['media'], 3, True), fmt(h6['media_tutti'], 3, True), fmt(h6['t_med'], 2), fmt(h6['t_min'], 2), fmt(h6['t_max'], 2), OFFSETS[60], h6['ultimo_t']))
        for k, v in ds['leave_out_h20_a'].items():
            P('  leave-out %-22s h=20 (a): spread %s (BULL %d, BEAR %d) media tutti %s' % (k, fmt(v['spread'], 3, True), v['n_bull'], v['n_bear'], fmt(v['media_tutti'], 3, True)))
        if n == 'primaria':
            P('  REGIMI EX-POST (anni 2009-2025; etichetta: EX-POST, non utilizzabile come filtro). Rendimenti annui:')
            P('     ' + ', '.join('%d %+.1f%% %s' % (y, v['rendimento'] * 100, v['regime']) for y, v in ds['regimi_anni'].items()))
            for reg, c in ds['regimi_expost_h20_a'].items():
                P('    %-9s anni %2d (%s) giorni %4d BULL %4d (ep %3d, media %s) BEAR %4d (ep %3d, media %s) spread %s' % (
                    reg, c['anni_n'], ','.join(str(y) for y in c['anni']), c['n_giorni'], c['n_bull'], c['episodi_bull'], fmt(c['media_bull'], 3, True),
                    c['n_bear'], c['episodi_bear'], fmt(c['media_bear'], 3, True), fmt(c['spread'], 3, True)))
        P('  TAGLIO EX-ANTE (terzili espansivi ATR14/close; segno rend. 250 gg), h=20 (a):')
        for cat, c in ds['exante_h20_a'].items():
            P('    %-12s giorni %4d BULL %4d (ep %3d, media %s) BEAR %4d (ep %3d, media %s) spread %s' % (
                cat, c['n_giorni'], c['n_bull'], c['episodi_bull'], fmt(c['media_bull'], 3, True), c['n_bear'], c['episodi_bear'], fmt(c['media_bear'], 3, True), fmt(c['spread'], 3, True)))

    # ---- 5. esito
    esito, motivo = esito_da(rl)
    ris['esito'] = dict(lettera=esito, motivo=motivo)
    ris['gate'] = 'TUTTI PASSATI'
    P('\n=== 5. ESITO SUI 5 CRITERI (lato A4, regole operative R1-R10) ===')
    P('%-10s %s' % ('criterio', ' '.join('%-12s' % n for n in rl)))
    for c in (1, 2, 3, 4, 5):
        P('%-10d %s' % (c, ' '.join('%-12s' % rl[n]['criteri'][c] for n in rl)))
    P('ESITO: %s  | %s' % (esito, motivo))
    P({'A': '(A) Vantaggio misurabile sui soli timeframe alti, nella replica (solo se confermato anche da A7 e dall\'accordo A4/A7)',
       'B': '(B) Nessun vantaggio dimostrato', 'C': '(C) NON CONCLUSIVO (potenza)'}[esito])
    for f in FRASI:
        P('  * ' + f)
    if esito != 'A':
        P('  * nessuna regola EA da proporre sulla base di questo studio')
    txt = '\n'.join(L) + '\n'
    open(os.path.join(QUI, prefix + '_output.txt'), 'w').write(txt)
    json.dump(ris, open(os.path.join(QUI, prefix + '_risultati.json'), 'w'), indent=1, default=str)
    P('\nScritti: %s_output.txt, %s_risultati.json' % (prefix, prefix))


if __name__ == '__main__':
    main()
