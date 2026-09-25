#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
merito_inverno.py -- 25/09/2026 -- SOLA LETTURA

DOMANDA: quanto del PF di contratto del candidato R245 (cella centrale,
ABTG_Nasdaq_Apertura_US su U30USD M5, InpEmaSlow=200, TP 0,50, due lati)
e della sedia viva 770202 (ABTG_Dow_Apertura_US, contratto R47c) viene dai
mesi d'INVERNO USA, cioe' dai mesi in cui su BCM (UTC+1 fisso) le 14:30
server sono le 8:30 di New York, un'ora PRIMA della cash?

FONTI (niente numeri a mano, tutto dai per-trade del repo):
  R245  IS  2024.09.26-2025.06.30  R247/PERTRADE/..._765271.csv  dep 10000
  R245  OOS 2025.07.01-2026.06.29  R247/PERTRADE/..._765273.csv  dep 10000
  770202 A  2024.09.27-2025.06.09  R246/PERTRADE/..._794603.csv  dep 100000
            (= IS di R47c, 74 deal, 2811,84; R246c e' NULLO per G1 per un
             centesimo sul primo deal: qui e' irrilevante, si stampa)
  770202 B  2025.06.10-2026.06.29  aperture_r47/..._772505.csv   dep 100000
  CONTRO-ESEMPI (motori SENZA orario sullo stesso simbolo U30USD):
  EMA200 H1  771521 (R31, sedia 771531)          2025.06.12-2026.06.26
  AtrExhaustVol M15 long 774432 / short 774442 (R109) 2024.09.30-2026.08.20
  SuperWave H2 770521 (R23d)                      2025.06.19-2026.06.17

CONVENZIONI (dichiarate):
  - stagione per DATA DI CHIUSURA, calendario USA (2a dom. marzo -> 1a dom.
    novembre = estate). E' lo stesso di r246_bande_attese.INV['USA'] e di
    r248_bande_vergine.estate_usa (l'autotest controlla che coincidano).
  - n = POSIZIONI (position_id distinti). PF "in soldi" = somma netti delle
    posizioni vincenti / |somma netti delle perdenti|. Si stampano accanto
    il PF sui DEAL (come MT5 / OROLOGIO_BCM) e sui RENDIMENTI % (come
    r248_bande_vergine).
  - DD per stagione = DD del saldo chiuso della SOLA sotto-serie di
    posizioni di quella stagione, rendimenti % composti [DERIVATO].
    DD per segmento contiguo (un inverno, un'estate) = stesso calcolo sul
    segmento: dentro una tranche coincide col saldo vero [MISURATO], se
    attraversa la giuntura di due tranche e' [DERIVATO] e si marca.
  - Bootstrap: posizioni ricampionate DENTRO ogni stagione (stratificato),
    seme 2509, 10000 repliche; statistica = PF_inverno - PF_estate.
    Nullo per permutazione: etichette di stagione rimescolate fra le
    posizioni (stessi n), seme 2509, 10000 permutazioni.
  - Jackknife per mese: si toglie un mese di calendario (di chiusura) alla
    volta e si ricalcolano PF_E, PF_I e la differenza.

USO:  python3 backtest_pipeline/merito_inverno.py            (~20 s)
      python3 backtest_pipeline/merito_inverno.py --autotest
Esce 0 se i controlli d'ingresso (ancore) sono VERDI, 1 altrimenti.
"""
import collections
import csv
import datetime as dt
import math
import os
import random
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r246_bande_attese as rb          # noqa: E402  calendario INV
import r248_bande_vergine as rv         # noqa: E402  estate_usa
import r247_sovrapposizione as rs       # noqa: E402  giorni, misura_a

SEME = 2509
REP = 10000

P = lambda *a: os.path.join(QUI, *a)  # noqa: E731
R247 = P('risultati_archivio', 'R247', 'PERTRADE')
R246 = P('risultati_archivio', 'R246', 'PERTRADE')

# (etichetta, percorso, deposito, ancora (deal, posizioni, somma) o None)
SEDIE = {
    'R245': [
        ('IS', os.path.join(R247, 'abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765271.csv'), 10000.0, (154, 154, 1180.94)),
        ('OOS', os.path.join(R247, 'abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765273.csv'), 10000.0, (197, 197, 2961.61)),
    ],
    '770202': [
        ('A', os.path.join(R246, 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv'), 100000.0, (74, None, 2811.84)),
        ('B', P('risultati_prove', 'aperture_r47', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv'), 100000.0, (130, 96, 6721.93)),
    ],
}
CONTRO = {
    'EMA200_771521': [('B', P('risultati_prove', 'trades_candidati_r23', 'abtg_trades_ABTG_EMA200_U30USD_771521.csv'), 100000.0, None)],
    'AtrExh_LONG_774432': [('AB', P('risultati_archivio', 'R109_deal_anomali', 'U30USD_00_long_pertrade_singola.csv'), 100000.0, None)],
    'AtrExh_SHORT_774442': [('AB', P('risultati_archivio', 'R109_deal_anomali', 'U30USD_01_short_pertrade_singola.csv'), 100000.0, None)],
    'SuperWave_770521': [('B', P('risultati_prove', 'trades_candidati_r23', 'abtg_trades_ABTG_SuperWave_U30USD_770521.csv'), 100000.0, None)],
}
# numeri scritti da ALTRI, da riprodurre prima di dire qualunque cosa
ANCORE_ALTRUI = [
    # OROLOGIO_BCM 5.1.1 e R246 5: 772505 sui DEAL, allineate 73 PF 0,78(2) / sfasate 57 PF 1,66(2)
    ('770202-B deal', 'deal', 'B', 73, 0.782, 57, 1.662),
    # OROLOGIO_BCM 5.1.1: EMA200 771521 sui deal: allineate 347 PF 2,05 / sfasate 170 PF 0,87
    ('EMA200 deal', 'deal_ema', 'B', 347, 2.05, 170, 0.87),
]


# ======================================================================
#  calendario e lettura
# ======================================================================
def inverno_usa(d):
    return not rv.estate_usa(d)


def leggi(percorso):
    with open(percorso, newline='', encoding='utf-8-sig') as fh:
        rr = list(csv.DictReader(fh, delimiter=';'))
    out = []
    for i, r in enumerate(rr):
        out.append({'t': dt.datetime.strptime(r['close_time'].strip(), '%Y.%m.%d %H:%M:%S'),
                    'pid': r['position_id'].strip(), 'tipo': r['deal_type'].strip(),
                    'net': float(r['net_profit']), 'ord': i})
    out.sort(key=lambda x: (x['t'], x['ord']))
    return out


def posizioni(deal, deposito, tranche):
    """-> lista di posizioni in ordine di PRIMA chiusura. Data = ultima
    chiusura (per le posizioni a piu' deal, parziale + resto). ret = netto
    sul saldo prima del primo deal della posizione."""
    per, ordine, saldo = {}, [], deposito
    for d in deal:
        if d['pid'] not in per:
            per[d['pid']] = {'saldo0': saldo, 'net': 0.0, 'deal': 0, 'nets': [],
                             'tipo': d['tipo'], 'tranche': tranche}
            ordine.append(d['pid'])
        p = per[d['pid']]
        p['net'] += d['net']
        p['deal'] += 1
        p['nets'].append(d['net'])
        p['t'] = d['t']
        saldo += d['net']
    out = []
    for pid in ordine:
        p = per[pid]
        p['pid'] = pid
        p['giorno'] = p['t'].date()
        p['ret'] = p['net'] / p['saldo0']
        p['inv'] = inverno_usa(p['giorno'])
        p['mese'] = p['giorno'].strftime('%Y-%m')
        out.append(p)
    return out


def carica(spec):
    pos, deal_tutti = [], []
    for lab, perc, dep, _anc in spec:
        dd = leggi(perc)
        deal_tutti += [dict(x, tranche=lab) for x in dd]
        pos += posizioni(dd, dep, lab)
    return pos, deal_tutti


# ======================================================================
#  metriche
# ======================================================================
def pf(valori):
    gp = sum(v for v in valori if v > 0)
    gl = -sum(v for v in valori if v < 0)
    return gp / gl if gl > 0 else float('inf')


def dd_composto(rets):
    s = picco = 1.0
    m = 0.0
    for r in rets:
        s *= (1.0 + r)
        picco = max(picco, s)
        m = max(m, (picco - s) / picco)
    return 100.0 * m


def riga(pp):
    return {'n': len(pp), 'deal': sum(p['deal'] for p in pp),
            'pf': pf([p['net'] for p in pp]), 'pf_ret': pf([p['ret'] for p in pp]),
            'net': sum(p['net'] for p in pp), 'dd': dd_composto([p['ret'] for p in pp])}


def segmenti(pos):
    """segmenti contigui di stagione (per data di chiusura)."""
    seg = []
    for p in pos:
        if not seg or seg[-1]['inv'] != p['inv']:
            seg.append({'inv': p['inv'], 'pos': []})
        seg[-1]['pos'].append(p)
    return seg


def boot_diff(pos, rep=REP, seme=SEME):
    E = [p['net'] for p in pos if not p['inv']]
    I = [p['net'] for p in pos if p['inv']]
    rnd = random.Random(seme)
    out = []
    for _ in range(rep):
        e = [E[rnd.randrange(len(E))] for _ in E]
        i = [I[rnd.randrange(len(I))] for _ in I]
        a, b = pf(i), pf(e)
        if math.isfinite(a) and math.isfinite(b):
            out.append(a - b)
    out.sort()
    q = lambda x: rv.quantile(out, x)  # noqa: E731
    return {'q025': q(0.025), 'q05': q(0.05), 'q50': q(0.5), 'q95': q(0.95), 'q975': q(0.975),
            'p_le0': sum(1 for x in out if x <= 0) / float(len(out)), 'valide': len(out)}


def perm_p(pos, rep=REP, seme=SEME):
    nets = [p['net'] for p in pos]
    lab = [p['inv'] for p in pos]
    oss = pf([v for v, l in zip(nets, lab) if l]) - pf([v for v, l in zip(nets, lab) if not l])
    rnd = random.Random(seme)
    ge = 0
    for _ in range(rep):
        rnd.shuffle(lab)
        d = pf([v for v, l in zip(nets, lab) if l]) - pf([v for v, l in zip(nets, lab) if not l])
        if d >= oss:
            ge += 1
    return oss, (ge + 1) / float(rep + 1)


def jackknife_mesi(pos):
    mesi = sorted(set(p['mese'] for p in pos))
    out = []
    for m in mesi:
        resto = [p for p in pos if p['mese'] != m]
        e = pf([p['net'] for p in resto if not p['inv']])
        i = pf([p['net'] for p in resto if p['inv']])
        out.append((m, e, i, i - e))
    return out


def togli_migliori(pos, k):
    """toglie i k mesi d'INVERNO col netto piu' alto -> PF inverno residuo."""
    per = collections.defaultdict(float)
    for p in pos:
        if p['inv']:
            per[p['mese']] += p['net']
    top = [m for m, _ in sorted(per.items(), key=lambda kv: -kv[1])[:k]]
    resto = [p for p in pos if p['inv'] and p['mese'] not in top]
    return top, pf([p['net'] for p in resto]), len(resto)


# ======================================================================
#  ora di New York (domanda 3)
# ======================================================================
def ora_ny(hh, mm, offset_server, giorno):
    """ora server hh:mm con server = UTC+offset -> ora di New York (EDT/EST
    col calendario USA). -> (hh, mm) come minuti dall'inizio del giorno."""
    utc = hh * 60 + mm - 60 * offset_server
    ny = utc + (-4 if rv.estate_usa(giorno) else -5) * 60
    ny %= 1440
    return ny // 60, ny % 60


# ======================================================================
#  controlli d'ingresso
# ======================================================================
def controlli():
    verde = True
    print('=== CONTROLLI D\'INGRESSO (ancore) ===')
    for nome, spec in SEDIE.items():
        for lab, perc, dep, anc in spec:
            dd = leggi(perc)
            n_pos = len(set(x['pid'] for x in dd))
            s = round(sum(x['net'] for x in dd), 2)
            ok = len(dd) == anc[0] and (anc[1] is None or n_pos == anc[1]) and abs(s - anc[2]) < 0.005
            verde &= ok
            print('  %-7s %-3s deal %d pos %d somma %.2f  ancora %s -> %s'
                  % (nome, lab, len(dd), n_pos, s, anc, 'OK' if ok else 'ROSSO'))
    # numeri scritti da altri (OROLOGIO_BCM 5.1.1)
    for nome, chiave, lab, ne, pfe, ni, pfi in ANCORE_ALTRUI:
        if chiave == 'deal':
            dd = leggi(SEDIE['770202'][1][1])
        else:
            dd = leggi(CONTRO['EMA200_771521'][0][1])
        E = [x['net'] for x in dd if not inverno_usa(x['t'].date())]
        I = [x['net'] for x in dd if inverno_usa(x['t'].date())]
        ok = len(E) == ne and len(I) == ni and abs(pf(E) - pfe) <= 0.005 and abs(pf(I) - pfi) <= 0.005
        verde &= ok
        print('  %-14s estate %d deal PF %.3f (scritto %d / %.3f) | inverno %d PF %.3f (scritto %d / %.3f) -> %s'
              % (nome, len(E), pf(E), ne, pfe, len(I), pf(I), ni, pfi, 'OK' if ok else 'ROSSO'))
    # calendario: tre implementazioni del repo devono coincidere
    d = dt.date(2024, 9, 1)
    diff = 0
    while d <= dt.date(2026, 6, 30):
        if rb.inverno(d, 'USA') != inverno_usa(d):
            diff += 1
        d += dt.timedelta(1)
    verde &= diff == 0
    print('  calendario USA: r246_bande_attese.INV contro r248.estate_usa, giorni diversi %d -> %s'
          % (diff, 'OK' if diff == 0 else 'ROSSO'))
    # R247 (a) sulla finestra B: rho_U 0,160 rho_C 0,247 quota 0,958
    m = sovrapp(None, comune=('2025.06.10', '2026.06.29'), n_perm=0)
    ok = abs(m['rho_u'] - 0.160) < 0.0005 and abs(m['rho_c'] - 0.247) < 0.0005 and m['C'] == 92
    verde &= ok
    print('  R247 (a) rifatta: rho_U %.3f rho_C %.3f C %d (scritti 0,160 / 0,247 / 92) -> %s'
          % (m['rho_u'], m['rho_c'], m['C'], 'OK' if ok else 'ROSSO'))
    return verde


# ======================================================================
#  sovrapposizione per stagione (domanda 2)
# ======================================================================
def _giorni(spec):
    tt = []
    for lab, perc, dep, _a in spec:
        t = rs.tranche(rs.leggi_pertrade(perc), dep)
        tt.append(t)
    return rs.unisci(tt)


def sovrapp(stagione, comune=('2024.09.27', '2026.06.29'), n_perm=rs.N_PERM):
    gv = _giorni(SEDIE['770202'])
    gn = _giorni(SEDIE['R245'])
    if stagione is not None:
        filt = lambda g: {k: v for k, v in g.items()  # noqa: E731
                          if inverno_usa(dt.datetime.strptime(k, '%Y.%m.%d').date()) == stagione}
        gv, gn = filt(gv), filt(gn)
    if n_perm == 0:
        return rs._misura_base(gv, gn, comune, 1.0, 1.0)
    return rs.misura_a(gv, gn, comune, 1.0, 1.0, n_perm=n_perm)


# ======================================================================
#  stampa
# ======================================================================
def fmt(x):
    return '%.3f' % x if math.isfinite(x) else 'inf'


def tabella(nome, pos, tranche_lab=True):
    print('\n=== %s ===' % nome)
    gruppi = []
    if tranche_lab:
        for lab in sorted(set(p['tranche'] for p in pos), key=lambda s: s):
            gruppi.append((lab, [p for p in pos if p['tranche'] == lab]))
    gruppi.append(('TUTTO', pos))
    print('  %-6s %-7s %4s %4s %8s %8s %8s %11s %7s' % ('tranche', 'stag.', 'n', 'deal', 'PF soldi',
                                                         'PF deal', 'PF ret%', 'netto', 'DD%[D]'))
    for lab, pp in gruppi:
        for st, flag in (('estate', False), ('inverno', True)):
            sub = [p for p in pp if p['inv'] == flag]
            if not sub:
                continue
            r = riga(sub)
            pfd = pf([v for p in sub for v in p['nets']])
            print('  %-6s %-7s %4d %4d %8s %8s %8s %11.2f %7.2f'
                  % (lab, st, r['n'], r['deal'], fmt(r['pf']), fmt(pfd), fmt(r['pf_ret']), r['net'], r['dd']))
        rt = riga(pp)
        quota = sum(p['net'] for p in pp if p['inv']) / rt['net'] if rt['net'] else float('nan')
        print('  %-6s %-7s %4d %4d %8s %8s %8s %11.2f %7.2f   quota del netto dall\'inverno: %.0f%%'
              % (lab, 'anno', rt['n'], rt['deal'], fmt(rt['pf']), '', fmt(rt['pf_ret']), rt['net'], rt['dd'],
                 100 * quota))
    print('  -- segmenti contigui (DD sul segmento; [D] se attraversa due tranche) --')
    for s in segmenti(pos):
        pp = s['pos']
        r = riga(pp)
        giun = len(set(p['tranche'] for p in pp)) > 1
        print('  %s %s -> %s  n %3d  PF %s  netto %10.2f  DD %.2f%%%s'
              % ('INV' if s['inv'] else 'EST', pp[0]['giorno'], pp[-1]['giorno'], r['n'], fmt(r['pf']),
                 r['net'], r['dd'], ' [D giuntura]' if giun else ''))


def sezione_stat(nome, pos):
    b = boot_diff(pos)
    oss, p = perm_p(pos)
    print('  %s: PF_I - PF_E osservato %.3f | bootstrap (seme %d, %d rep, %d valide) '
          'p2,5 %.3f p5 %.3f p50 %.3f p95 %.3f p97,5 %.3f | P(diff<=0) %.4f | permutazione p %.4f'
          % (nome, oss, SEME, REP, b['valide'], b['q025'], b['q05'], b['q50'], b['q95'], b['q975'],
             b['p_le0'], p))
    return b, oss, p


def sezione_jk(nome, pos):
    jk = jackknife_mesi(pos)
    dmin = min(jk, key=lambda x: x[3])
    dmax = max(jk, key=lambda x: x[3])
    imin = min(jk, key=lambda x: x[2])
    emax = max(jk, key=lambda x: x[1])
    neg = sum(1 for x in jk if x[3] <= 0)
    print('  %s jackknife su %d mesi: diff min %.3f (senza %s) max %.3f (senza %s) | PF_I min %.3f (senza %s) '
          '| PF_E max %.3f (senza %s) | diff <= 0 in %d su %d'
          % (nome, len(jk), dmin[3], dmin[0], dmax[3], dmax[0], imin[2], imin[0], emax[1], emax[0], neg, len(jk)))
    for k in (1, 2, 3):
        top, pfi, n = togli_migliori(pos, k)
        print('     senza i %d mesi d\'inverno migliori %s: PF inverno %.3f su %d posizioni' % (k, top, pfi, n))


def sezione_ora(nome, pos, deal):
    """d'inverno: posizioni chiuse PRIMA delle 15:30 BCM (= prima della cash)
    contro dopo. Solo descrittivo (per-trade: solo ora di CHIUSURA)."""
    ult = {}
    for d in deal:
        ult[(d['tranche'], d['pid'])] = d['t']
    for st, flag in (('inverno', True), ('estate', False)):
        prima = [p for p in pos if p['inv'] == flag and ult[(p['tranche'], p['pid'])].time() < dt.time(15, 30)]
        dopo = [p for p in pos if p['inv'] == flag and ult[(p['tranche'], p['pid'])].time() >= dt.time(15, 30)]
        print('  %s %-7s chiuse < 15:30 BCM: n %3d PF %s netto %10.2f | >= 15:30: n %3d PF %s netto %10.2f'
              % (nome, st, len(prima), fmt(pf([p['net'] for p in prima])), sum(p['net'] for p in prima),
                 len(dopo), fmt(pf([p['net'] for p in dopo])), sum(p['net'] for p in dopo)))


def sezione_lati(nome, pos):
    for st, flag in (('estate', False), ('inverno', True)):
        for lato, t in (('LONG', '1'), ('SHORT', '0')):
            sub = [p for p in pos if p['inv'] == flag and p['tipo'] == t]
            if sub:
                print('  %s %-7s %-5s n %3d PF %s netto %10.2f'
                      % (nome, st, lato, len(sub), fmt(pf([p['net'] for p in sub])), sum(p['net'] for p in sub)))


def stampa_sovrapp():
    print('\n=== SOVRAPPOSIZIONE R245 x 770202 PER STAGIONE (finestra 2024.09.27 -> 2026.06.29, '
          'giorni per data di chiusura, nullo %d permutazioni seme %d) ===' % (rs.N_PERM, rs.SEME_PERM))
    for nome, st in (('ANNO', None), ('ESTATE', False), ('INVERNO', True)):
        m = sovrapp(st)
        print('  %-7s giorni viva %3d nuova %3d C %3d | quota viva %.3f | stesso verso %d opposto %d | '
              'rho_U %.3f rho_C %.3f | P(perde|viva perde) %.3f (q95 %.3f) | DD somma/(DDv+DDn) %.3f '
              '(q95 %.3f) | peggior giornata somma %.3f%% rapp %.3f (q95 %.3f) | %s | allarme di coda: %s'
              % (nome, m['nv'], m['nn'], m['C'], m['quota_viva'], m['stesso'], m['opposto'], m['rho_u'],
                 m['rho_c'], m['p_coperd'], m['q_p_coperd'], m['rapp_dd'], m['q_rapp_dd'], m['peg_s'],
                 m['rapp_pg'], m['q_rapp_pg'], m['verdetto'], 'SCATTA' if m['coda'] else 'no'))
    print('  (DESCRITTIVO: le soglie di R247a par. 6 sono congelate per la finestra B dell\'anno; '
          'qui si applicano a finestre diverse e NON fanno verdetto)')


def stampa_ftmo():
    print('\n=== ORA DI NEW YORK DELL\'ARMO (InpSessionHour:Min) ===')
    casi = [('BCM 14:30, UTC+1 fisso', 14, 30, 1), ('FTMO 16:30 se server UTC+3', 16, 30, 3),
            ('FTMO 16:30 se server UTC+2', 16, 30, 2)]
    print('  (FTMO UTC+3 e\' MISURATO il 20/09; quale offset valga dal 25/10 e\' [NON MISURATO]:')
    print('   UTC+2 = calendario UE (2 fonti su 3), UTC+3 fisso = REGOLAMENTI_PROP r.106)')
    giorni = [('estate 15/07/2026', dt.date(2026, 7, 15)), ('27/10/2026 (UE solare, USA legale)', dt.date(2026, 10, 27)),
              ('inverno 15/01/2027', dt.date(2027, 1, 15))]
    for nome, h, m, off in casi:
        cel = []
        for gn, g in giorni:
            hh, mm = ora_ny(h, m, off, g)
            cel.append('%s -> %02d:%02d NY' % (gn, hh, mm))
        print('  %-40s %s' % (nome, ' | '.join(cel)))


def main():
    verde = controlli()
    if not verde:
        print('\n>>> CONTROLLI D\'INGRESSO ROSSI: nessun numero si legge.')
        return 1
    tutte = {}
    for nome, spec in list(SEDIE.items()) + list(CONTRO.items()):
        pos, deal = carica(spec)
        tutte[nome] = (pos, deal)
        tabella(nome, pos, tranche_lab=len(spec) > 1)
    print('\n=== DIFFERENZA PF_INVERNO - PF_ESTATE (PF in soldi, posizioni) ===')
    for nome, (pos, _d) in tutte.items():
        sezione_stat(nome, pos)
        if nome in SEDIE:
            for lab in sorted(set(p['tranche'] for p in pos)):
                sezione_stat('   %s solo %s' % (nome, lab), [p for p in pos if p['tranche'] == lab])
    print('\n=== JACKKNIFE PER MESE (e concentrazione) ===')
    for nome in list(SEDIE) + list(CONTRO):
        sezione_jk(nome, tutte[nome][0])
    print('\n=== ORA DI CHIUSURA: prima o dopo le 15:30 BCM (d\'inverno = la cash) ===')
    for nome in SEDIE:
        sezione_ora(nome, *tutte[nome])
    print('\n=== LATI (verso dal deal di uscita) ===')
    for nome in SEDIE:
        sezione_lati(nome, tutte[nome][0])
    stampa_sovrapp()
    stampa_ftmo()
    return 0


# ======================================================================
#  autotest: contro-esempi che devono ROMPERE lo strumento se e' sbagliato
# ======================================================================
def autotest():
    ok_tot = True

    def chk(nome, cond):
        nonlocal ok_tot
        ok_tot &= bool(cond)
        print('  %-72s %s' % (nome, 'OK' if cond else 'FALLITO'))

    print('=== AUTOTEST ===')
    # T1 calendario: confini noti
    chk('T1 03/11/2024 inverno, 02/11/2024 estate, 09/03/2025 estate, 08/03/2025 inverno',
        inverno_usa(dt.date(2024, 11, 3)) and not inverno_usa(dt.date(2024, 11, 2))
        and not inverno_usa(dt.date(2025, 3, 9)) and inverno_usa(dt.date(2025, 3, 8)))

    # T2 PF: formula su numeri noti
    chk('T2 pf([3,-1,-2]) = 1,0 ; pf([2,-1]) = 2,0', abs(pf([3, -1, -2]) - 1) < 1e-12 and abs(pf([2, -1]) - 2) < 1e-12)

    def sint(pf_e, pf_i, n_e, n_i, seme):
        rnd = random.Random(seme)
        out = []
        for flag, pfx, n in ((False, pf_e, n_e), (True, pf_i, n_i)):
            # vincite +pfx, perdite -1, 50/50: PF atteso = pfx
            for k in range(n):
                v = pfx if k % 2 == 0 else -1.0
                out.append({'net': v * (1 + 0.1 * rnd.random()), 'inv': flag, 'mese': '2025-%02d' % (1 + k % 12),
                            'ret': v / 1000.0})
        return out
    # T3 nullo: stesso PF nelle due stagioni -> la banda deve contenere 0
    b = boot_diff(sint(1.2, 1.2, 120, 77, 1), rep=3000)
    chk('T3 stagioni uguali (PF 1,2 / 1,2, n 120/77): banda 95%% contiene 0 [%.2f ; %.2f]' % (b['q025'], b['q975']),
        b['q025'] < 0 < b['q975'])
    # T4 contro-esempio forte: differenza grossa -> la banda NON contiene 0
    b = boot_diff(sint(0.95, 2.1, 120, 77, 2), rep=3000)
    chk('T4 differenza piantata (0,95 / 2,1): banda 95%% esclude 0 [%.2f ; %.2f]' % (b['q025'], b['q975']),
        b['q025'] > 0)
    # T5 permutazione: sotto il nullo p non piccolo, sotto l'alternativa p piccolo
    _o, p0 = perm_p(sint(1.2, 1.2, 120, 77, 3), rep=2000)
    _o, p1 = perm_p(sint(0.95, 2.1, 120, 77, 4), rep=2000)
    chk('T5 permutazione: p nullo %.3f > 0,05 ; p alternativa %.4f < 0,01' % (p0, p1), p0 > 0.05 and p1 < 0.01)
    # T6 jackknife: un solo mese d'inverno enorme -> toglierlo deve far crollare la differenza
    pos = sint(1.0, 1.0, 120, 77, 5)
    pos.append({'net': 500.0, 'inv': True, 'mese': '2026-01', 'ret': 0.5})
    jk = jackknife_mesi(pos)
    senza = [x for x in jk if x[0] == '2026-01'][0]
    chk('T6 jackknife: il mese-outlier pesa (diff senza %.3f << diff con)' % senza[3],
        senza[3] < min(x[3] for x in jk if x[0] != '2026-01') - 1)
    # T7 ora di New York
    chk('T7 BCM 14:30 UTC+1: luglio 9:30 NY, gennaio 8:30 NY',
        ora_ny(14, 30, 1, dt.date(2026, 7, 15)) == (9, 30) and ora_ny(14, 30, 1, dt.date(2027, 1, 15)) == (8, 30))
    chk('T8 FTMO 16:30: UTC+3 luglio 9:30, UTC+2 gennaio 9:30, UTC+3 gennaio 8:30, UTC+2 27/10 10:30',
        ora_ny(16, 30, 3, dt.date(2026, 7, 15)) == (9, 30) and ora_ny(16, 30, 2, dt.date(2027, 1, 15)) == (9, 30)
        and ora_ny(16, 30, 3, dt.date(2027, 1, 15)) == (8, 30) and ora_ny(16, 30, 2, dt.date(2026, 10, 27)) == (10, 30))
    # T9 DD composto su serie nota: +10%, -20% -> 20%
    chk('T9 dd_composto([0,1 ; -0,2]) = 20%', abs(dd_composto([0.1, -0.2]) - 20.0) < 1e-9)
    # T10 i controlli d'ingresso devono essere VERDI sui file veri e ROSSI su un'ancora falsa
    salv = SEDIE['R245'][0]
    SEDIE['R245'][0] = (salv[0], salv[1], salv[2], (154, 154, 1180.95))
    import io
    import contextlib
    with contextlib.redirect_stdout(io.StringIO()):
        rosso = not controlli()
    SEDIE['R245'][0] = salv
    with contextlib.redirect_stdout(io.StringIO()):
        verde = controlli()
    chk('T10 ancora spostata di 1 centesimo -> ROSSO; ancora vera -> VERDE', rosso and verde)
    print('AUTOTEST: %s' % ('TUTTO OK' if ok_tot else 'FALLITO'))
    return 0 if ok_tot else 1


if __name__ == '__main__':
    sys.exit(autotest() if '--autotest' in sys.argv else main())
