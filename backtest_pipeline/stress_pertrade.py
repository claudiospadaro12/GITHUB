#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
stress_pertrade.py - STRESS DEI COSTI (spread / slippage) IN POST-PROCESSING SU UN PER-TRADE ABTG

Nato il 27/09/2026 per il collaudo ORO 770402 solo LONG (criteri congelati in
backtest_pipeline/prove/COLLAUDO_ORO_770402_LONG_CRITERI.md, commit 323605fb, PRIMA dei numeri).
Zero tester: legge il per-trade degli EA ABTG (solo deal d'uscita)
    close_time;symbol;magic;position_id;deal_type;volume;price;net_profit
e ricalcola PF (in POSIZIONI) e DD a saldo chiuso peggiorando ogni posizione.

FORMULA (per posizione, V = volume d'ingresso = somma dei volumi d'uscita):
    netto_base    = somma(net_profit) - k x V                       (classe 844)
    peggioramento = [ds x V + slip x V + slip x somma(vol d'uscita)] x C x q_t
    netto_stress  = netto_base - peggioramento
  ds   = aumento di spread in prezzo (USD/oz sull'oro), una volta per andata-e-ritorno
  slip = slittamento in prezzo su ingresso e su OGNI deal d'uscita (pessimista)
  C    = unita' per lotto (oro: 100 oz)
  q_t  = cambio valuta-quotazione -> valuta-conto, MISURATO dal file (vedi misura_q)

[APPROSSIMAZIONE dichiarata] volumi FISSI come nella base; non modella l'insieme degli ingressi
che cambia con lo spread, requote, rifiuti, slippage favorevole.

USO
  python3 backtest_pipeline/stress_pertrade.py --autotest
  python3 backtest_pipeline/stress_pertrade.py --pertrade <csv> --k 1.8113 \
      [--deposito 100000] [--rischio 0.5] [--C 100] [--punto 0.01] \
      [--base-spread 0.45 --base-spread 0.30] [--taglio 2023.04.01] \
      [--attesa-pf 1.3357 --attesa-dd 4.1549]
Stampa tabelle markdown su stdout. Sola lettura: non scrive file.
"""
import argparse
import bisect
import csv
import collections
import datetime as dt
import math
import statistics
import sys

GRADINI = [0.0, 0.25, 0.50, 1.00, 10.00]      # frazione dello spread di base (10 = +1000%)
SLIP_PUNTI = [0, 1, 2]                        # scala richiesta
SLIP_SENS = [5, 10, 50]                       # sensibilita' (non decide)


# ---------------------------------------------------------------- lettura
def leggi_pertrade(percorso):
    with open(percorso, newline='') as fh:
        righe = list(csv.DictReader(fh, delimiter=';'))
    deal = []
    for r in righe:
        deal.append(dict(t=dt.datetime.strptime(r['close_time'], '%Y.%m.%d %H:%M:%S'),
                         pid=r['position_id'], tipo=int(r['deal_type']),
                         vol=float(r['volume']), prezzo=float(r['price']),
                         net=float(r['net_profit'])))
    return deal


def posizioni(deal):
    """Aggrega per position_id, nell'ordine di prima comparsa (= ordine di chiusura)."""
    pos = collections.OrderedDict()
    for d in deal:
        pos.setdefault(d['pid'], []).append(d)
    return pos


# ---------------------------------------------------------------- cambio q
def misura_q(pos, C, soglia_prezzo=0.5):
    """Ancore (data, q) dalle posizioni con due deal d'uscita di pari volume a prezzi diversi:
       q = (net1 - net2) / ((p1 - p2) x vol x C). La commissione d'uscita (uguale) si elide."""
    ancore = []
    for ds in pos.values():
        if len(ds) < 2:
            continue
        a, b = ds[0], ds[1]
        dp = a['prezzo'] - b['prezzo']
        if abs(dp) > soglia_prezzo and abs(a['vol'] - b['vol']) < 1e-9:
            ancore.append((a['t'], (a['net'] - b['net']) / (dp * a['vol'] * C)))
    ancore.sort()
    return ancore


def q_alla_data(ancore, t):
    if not ancore:
        raise ValueError('nessuna ancora per q: passare --q')
    xs = [a[0] for a in ancore]
    i = bisect.bisect_left(xs, t)
    if i == 0:
        return ancore[0][1]
    if i >= len(ancore):
        return ancore[-1][1]
    (t0, q0), (t1, q1) = ancore[i - 1], ancore[i]
    w = (t - t0).total_seconds() / max((t1 - t0).total_seconds(), 1.0)
    return q0 + w * (q1 - q0)


# ---------------------------------------------------------------- nucleo
def netti_posizione(pos, k, C, ds, slip, qfun):
    """Lista di (data_chiusura, netto_stress) per posizione, e lista dei deal stressati per il DD."""
    out_pos = []
    out_deal = []
    for ds_ in pos.values():
        V = sum(d['vol'] for d in ds_)
        t_ult = ds_[-1]['t']
        q = qfun(ds_[0]['t'])
        tot = 0.0
        for j, d in enumerate(ds_):
            # la quota d'ingresso (k, spread, slip d'ingresso) si attribuisce pro-quota ai deal:
            # per il PF in posizioni e' indifferente, per il DD e' la scelta neutra
            quota = d['vol'] / V
            peg = (ds * V + slip * V) * quota * C * q + slip * d['vol'] * C * q
            n = d['net'] - k * d['vol'] - peg
            out_deal.append((d['t'], n))
            tot += n
        out_pos.append((t_ult, tot))
    return out_pos, out_deal


def pf(valori):
    gp = sum(x for x in valori if x > 0)
    gl = -sum(x for x in valori if x < 0)
    return float('inf') if gl == 0 else gp / gl


def dd_chiuso(seq, deposito):
    b = pk = deposito
    m = 0.0
    for x in seq:
        b += x
        pk = max(pk, b)
        m = max(m, (pk - b) / pk)
    return 100.0 * m


def scenario(pos, k, C, ds, slip, qfun, deposito, taglio):
    op, od = netti_posizione(pos, k, C, ds, slip, qfun)
    od.sort(key=lambda x: x[0])
    v = [x[1] for x in op]
    prima = [x[1] for x in op if x[0] < taglio]
    seconda = [x[1] for x in op if x[0] >= taglio]
    anni = collections.OrderedDict()
    for t, n in op:
        anni.setdefault(t.year, []).append(n)
    return dict(n=len(v), pf=pf(v), netto=sum(v), dd=dd_chiuso([x[1] for x in od], deposito),
                pf1=pf(prima), n1=len(prima), net1=sum(prima),
                pf2=pf(seconda), n2=len(seconda), net2=sum(seconda),
                anni={a: (len(x), sum(x), pf(x)) for a, x in anni.items()})


# ---------------------------------------------------------------- stop (classe 846)
def stop_846(pos, k, C, qfun, deposito, rischio, passo=0.01):
    """stop_$ fra R/((V+passo) C q) e R/(V C q), R = rischio% x saldo prima dell'ingresso.
       Controprova sugli stop pieni: posizione a deal unico, non alle 17:30, perdita in [0,85R;1,05R]:
       stop_oss = (-net - k V) / (V C q)."""
    saldo = deposito
    lo, hi, oss, rapp = [], [], [], []
    for ds_ in pos.values():
        V = sum(d['vol'] for d in ds_)
        q = qfun(ds_[0]['t'])
        R = saldo * rischio / 100.0
        s_hi = R / (V * C * q)
        s_lo = R / ((V + passo) * C * q)
        lo.append(s_lo)
        hi.append(s_hi)
        if len(ds_) == 1:
            d = ds_[0]
            perdita = -(d['net'] - k * V)  # con commissione d'ingresso
            if d['t'].strftime('%H:%M:%S') != '17:30:00' and 0.85 * R <= perdita <= 1.05 * R:
                so = (-d['net'] - k * V) / (V * C * q)
                oss.append(so)
                rapp.append(so / ((s_lo + s_hi) / 2))
        saldo += sum(d['net'] for d in ds_) - k * V
    return lo, hi, oss, rapp


def giornata_e_serie(pos, k, C, ds, slip, qfun, deposito):
    """Peggior giornata a saldo chiuso (% del saldo d'inizio giornata, deal in ordine di chiusura)
       e serie perdente massima in POSIZIONI (netto < 0)."""
    op, od = netti_posizione(pos, k, C, ds, slip, qfun)
    od.sort(key=lambda x: x[0])
    b = deposito
    giorni = collections.OrderedDict()
    for t, n in od:
        giorni.setdefault(t.date(), [b, 0.0])
        giorni[t.date()][1] += n
        b += n
    peggio = min(v[1] / v[0] for v in giorni.values()) * 100.0
    serie = mx = 0
    for _, n in op:
        serie = serie + 1 if n < 0 else 0
        mx = max(mx, serie)
    return peggio, mx


def soglia_slip(pos, k, C, ds, qfun, deposito, taglio, regge, hi=2.0):
    """Bisezione sullo slippage (in prezzo) a ds fisso: il massimo per cui regge(scenario) e' vero.
       Presuppone PF decrescente e DD crescente nello slippage (verificato a passo 1 pt sul caso ORO)."""
    lo = 0.0
    if not regge(scenario(pos, k, C, ds, 0.0, qfun, deposito, taglio)):
        return None
    for _ in range(60):
        m = (lo + hi) / 2
        if regge(scenario(pos, k, C, ds, m, qfun, deposito, taglio)):
            lo = m
        else:
            hi = m
    return lo


# ---------------------------------------------------------------- stampa
def f2(x):
    return 'inf' if x == float('inf') else f'{x:.3f}'


def eur(x):
    s = f'{x:+,.2f}'
    return s.replace(',', '_').replace('.', ',').replace('_', '.')


def esegui(a):
    deal = leggi_pertrade(a.pertrade)
    pos = posizioni(deal)
    taglio = dt.datetime.strptime(a.taglio, '%Y.%m.%d')
    punto = a.punto
    ancore = misura_q(pos, a.C)
    if a.q is not None:
        qfun = lambda t, _q=a.q: _q
    else:
        qfun = lambda t: q_alla_data(ancore, t)

    notte = [pid for pid, ds in pos.items() if ds[-1]['t'].date() != ds[0]['t'].date()]
    print(f'# stress_pertrade.py -- {a.pertrade}')
    print(f'deal {len(deal)} | posizioni {len(pos)} | deal_type {sorted(set(d["tipo"] for d in deal))} | '
          f'posizioni con deal su date diverse (notte): {len(notte)}')
    if ancore:
        qs = [x[1] for x in ancore]
        print(f'q misurato: {len(ancore)} ancore, {ancore[0][0]:%Y-%m-%d} -> {ancore[-1][0]:%Y-%m-%d}, '
              f'min {min(qs):.4f} mediana {statistics.median(qs):.4f} max {max(qs):.4f}')
    print(f'q usato: {"fisso " + str(a.q) if a.q is not None else "interpolato per data"}')

    # --- contro-esempio 1: degrado zero
    z = scenario(pos, a.k, a.C, 0.0, 0.0, qfun, a.deposito, taglio)
    print('\n## Contro-esempio 1 -- degrado zero')
    print(f'PF {z["pf"]:.4f} | netto {eur(z["netto"])} | DD {z["dd"]:.4f}% | meta\' {z["n1"]} pos PF {f2(z["pf1"])}'
          f' / {z["n2"]} pos PF {f2(z["pf2"])}')
    ok1 = True
    if a.attesa_pf is not None:
        ok1 &= abs(z['pf'] - a.attesa_pf) <= 0.0005
    if a.attesa_dd is not None:
        ok1 &= abs(z['dd'] - a.attesa_dd) <= 0.001
    print('ESITO:', 'OK' if ok1 else 'FALLITO')

    # --- stop classe 846
    lo, hi, oss, rapp = stop_846(pos, a.k, a.C, qfun, a.deposito, a.rischio, a.passo)
    mid = [(x + y) / 2 for x, y in zip(lo, hi)]
    print('\n## Stop per posizione (classe 846), $ di prezzo')
    print(f'n {len(mid)} | mediana banda [{statistics.median(lo):.2f} ; {statistics.median(hi):.2f}] | '
          f'mediana centro {statistics.median(mid):.2f} | P10 {sorted(mid)[len(mid)//10]:.2f} | '
          f'min {min(mid):.2f} | max {max(mid):.2f}')
    # per anno di ingresso: stop centro mediano e costo di ds=base in frazione di R (ds / stop)
    anni_stop = collections.OrderedDict()
    for (ds_, m) in zip(pos.values(), mid):
        anni_stop.setdefault(ds_[0]['t'].year, []).append(m)
    print('| anno | n | stop mediano $ | min $ | ' + ' | '.join(f'base {b:.2f} in R (mediana)' for b in a.base_spread) + ' |')
    print('|---|---:|---:|---:|' + '---:|' * len(a.base_spread))
    for y, xs in anni_stop.items():
        print(f'| {y} | {len(xs)} | {statistics.median(xs):.2f} | {min(xs):.2f} | ' +
              ' | '.join(f'{statistics.median([b / x for x in xs])*100:.2f}%' for b in a.base_spread) + ' |')
    # frontiera del costo stop >= 40 x spread, per anno, con la banda di arrotondamento del lotto
    for b in a.base_spread:
        fr = 40 * b
        print(f'frontiera 40 x {b:.2f} = {fr:.2f} $: posizioni con stop sotto -- centro / banda [stop alto ; stop basso]')
        tot_c = tot_h = tot_l = 0
        per_anno = collections.OrderedDict()
        for (ds_, x, y, m) in zip(pos.values(), lo, hi, mid):
            per_anno.setdefault(ds_[0]['t'].year, [0, 0, 0, 0])
            r_ = per_anno[ds_[0]['t'].year]
            r_[0] += 1
            r_[1] += m < fr
            r_[2] += y < fr
            r_[3] += x < fr
        for y, r_ in per_anno.items():
            print(f'  {y}: {r_[1]}/{r_[0]} (banda {r_[2]}-{r_[3]})')
            tot_c += r_[1]; tot_h += r_[2]; tot_l += r_[3]
        print(f'  TOTALE: {tot_c}/{len(mid)} (banda {tot_h}-{tot_l})')
    if oss:
        print('(controprova sotto = SOLO coerenza del filtro: perdita ~ R per costruzione, non indipendente)')
        print(f'controprova stop pieni: n {len(oss)} | stop osservato mediano {statistics.median(oss):.2f} | '
              f'rapporto oss/centro mediano {statistics.median(rapp):.4f} (min {min(rapp):.4f} max {max(rapp):.4f})')

    for b in a.base_spread:
        print(f'\n## Scala -- spread di base {b:.2f} (ds = gradino x base) x slippage in punti ({punto} per punto)')
        print('| gradino | ds $ | slip pt | pos | PF | netto EUR | DD chiuso % | meta\' 1 PF | meta\' 2 PF | '
              '(ds + 2 x slip) / stop mediano |')
        print('|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|')
        risultati = {}
        for g in GRADINI:
            for sp in SLIP_PUNTI + (SLIP_SENS if g in (0.0, 0.25) else []):
                ds = g * b
                r = scenario(pos, a.k, a.C, ds, sp * punto, qfun, a.deposito, taglio)
                risultati[(g, sp)] = r
                print(f'| +{g*100:.0f}% | {ds:.4f} | {sp} | {r["n"]} | {r["pf"]:.4f} | {eur(r["netto"])} | '
                      f'{r["dd"]:.4f} | {f2(r["pf1"])} | {f2(r["pf2"])} | '
                      f'{(ds + 2*sp*punto)/statistics.median(mid)*100:.2f}% |')
        # anno per anno sui gradini del verdetto (slip 2)
        print(f'\n### Anno per anno (base {b:.2f}, slippage 2 pt) -- n / netto / PF')
        anni = list(z['anni'].keys())
        print('| gradino | ' + ' | '.join(str(x) for x in anni) + ' | anni < 0 |')
        print('|---|' + '---:|' * (len(anni) + 1))
        for g in GRADINI:
            r = risultati[(g, 2)]
            neg = sum(1 for x in anni if r['anni'][x][1] < 0)
            print(f'| +{g*100:.0f}% | ' + ' | '.join(
                f'{r["anni"][x][0]} / {eur(r["anni"][x][1])} / {f2(r["anni"][x][2])}' for x in anni) +
                f' | {neg}/{len(anni)} |')
        # contro-esempi 2 e 3
        seq = [risultati[(g, 2)]['pf'] for g in GRADINI]
        mono = all(seq[i + 1] <= seq[i] + 1e-12 for i in range(len(seq) - 1))
        crollo = risultati[(10.0, 2)]['pf'] < 1.0
        print(f'\nContro-esempio 2 (+1000% -> PF < 1): PF {risultati[(10.0, 2)]["pf"]:.4f} -> '
              f'{"OK" if crollo else "FALLITO: formula rotta"}')
        print(f'Contro-esempio 3 (monotonia PF sui gradini, slip 2): {"OK" if mono else "FALLITO"}')

        # verdetto (solo base 0.45 decide: lo dice il file criteri; qui si stampa per ogni base)
        r1, r2, r3 = risultati[(0.25, 2)], risultati[(0.50, 2)], risultati[(1.00, 2)]
        s1 = r1['pf'] >= 1.20 and r1['dd'] <= 5.0
        s2 = r2['pf'] >= 1.10
        s3 = r3['pf'] >= 1.00
        v = 'PASS' if (s1 and s2 and s3) else ('FRAGILE' if (s1 and s2) else 'BOCCIATO')
        if not (ok1 and crollo and mono):
            v = 'NESSUN VERDETTO (contro-esempio fallito)'
        print(f'S1 (+25%: PF>=1,20 e DD<=5,0%): PF {r1["pf"]:.4f} DD {r1["dd"]:.4f} -> {"ok" if s1 else "NO"} | '
              f'S2 (+50%: PF>=1,10): {r2["pf"]:.4f} -> {"ok" if s2 else "NO"} | '
              f'S3 (+100%: PF>=1,00): {r3["pf"]:.4f} -> {"ok" if s3 else "NO"} | VERDETTO base {b:.2f}: {v}')
        # pareggio: ds a cui PF = 1 e PF = 1,20 (slip 2), bisezione
        for obiettivo in (1.20, 1.10, 1.00):
            lo_, hi_ = 0.0, 10 * b
            for _ in range(60):
                m = (lo_ + hi_) / 2
                if scenario(pos, a.k, a.C, m, 2 * punto, qfun, a.deposito, taglio)['pf'] >= obiettivo:
                    lo_ = m
                else:
                    hi_ = m
            print(f'ds a cui PF = {obiettivo:.2f} (slip 2 pt): {lo_:.4f} $ = +{lo_/b*100:.1f}% della base {b:.2f}')
        # slippage massimo che regge ogni soglia (arrotondato PER DIFETTO a 0,1 pt: il valore stampato regge)
        crit = [(0.25, 'S1 (PF>=1,20 e DD<=5,0%)', lambda r: r['pf'] >= 1.20 and r['dd'] <= 5.0),
                (0.50, 'S2 (PF>=1,10)', lambda r: r['pf'] >= 1.10),
                (1.00, 'S3 (PF>=1,00)', lambda r: r['pf'] >= 1.00)]
        for g, nome, regge in crit:
            sl = soglia_slip(pos, a.k, a.C, g * b, qfun, a.deposito, taglio, regge)
            if sl is None:
                print(f'slippage massimo per {nome} a +{g*100:.0f}%: cade gia\' a slippage 0')
                continue
            r = scenario(pos, a.k, a.C, g * b, sl, qfun, a.deposito, taglio)
            pt = math.floor(sl / punto * 10) / 10
            print(f'slippage massimo per {nome} a +{g*100:.0f}%: {sl:.5f} $ = {pt:.1f} pt (per difetto) | '
                  f'al limite PF {r["pf"]:.4f} DD {r["dd"]:.4f}')
        for g in GRADINI[:4]:
            pg, se = giornata_e_serie(pos, a.k, a.C, g * b, 2 * punto, qfun, a.deposito)
            print(f'+{g*100:.0f}% slip 2: peggior giornata {pg:.3f}% | serie perdente max {se} posizioni')
    return 0


# ---------------------------------------------------------------- autotest
def autotest():
    fail = 0

    def chk(nome, cond):
        nonlocal fail
        print(('OK    ' if cond else 'FALLITO ') + nome)
        if not cond:
            fail += 1

    t0 = dt.datetime(2021, 1, 4, 10, 0, 0)
    # posizione A: 0,20 lotti, due uscite da 0,10 a 1010 e 1000, ingresso 990, q = 0,9, k = 2
    # net_i = (p_i - 990) x 0,10 x 100 x 0,9 - 2 x 0,10 (commissione d'uscita)
    q = 0.9
    dA = [dict(t=t0, pid='1', tipo=1, vol=0.10, prezzo=1010.0, net=(20 * 10 * q) - 0.2),
          dict(t=t0 + dt.timedelta(hours=2), pid='1', tipo=1, vol=0.10, prezzo=1000.0, net=(10 * 10 * q) - 0.2)]
    # posizione B: 0,20 lotti, uscita unica a stop, perdita 30 $ -> -30 x 0,2 x 100 x q
    dB = [dict(t=t0 + dt.timedelta(days=1), pid='2', tipo=1, vol=0.20, prezzo=960.0, net=-30 * 20 * q - 0.4)]
    pos = posizioni(dA + dB)
    anc = misura_q(pos, 100)
    chk('q misurato dalla coppia = 0,9', len(anc) == 1 and abs(anc[0][1] - 0.9) < 1e-12)
    qf = lambda t: q_alla_data(anc, t)
    chk('q costante fuori dalle ancore', abs(qf(t0 + dt.timedelta(days=400)) - 0.9) < 1e-12)
    # peggioramento a mano, ds = 0,5, slip = 0,02, k = 2:
    # A: base = 180 - 0,2 + 90 - 0,2 - 2 x 0,2 = 269,2
    #    peg = (0,5 x 0,2 + 0,02 x 0,2 + 0,02 x 0,2) x 100 x 0,9 = (0,1 + 0,004 + 0,004) x 90 = 9,72
    op, od = netti_posizione(pos, 2.0, 100, 0.5, 0.02, qf)
    chk('posizione A a mano: 269,2 - 9,72 = 259,48', abs(op[0][1] - 259.48) < 1e-9)
    # B: base = -540 - 0,4 - 0,4 = -540,8 ; peg = (0,1 + 0,004 + 0,004) x 90 = 9,72 -> -550,52
    chk('posizione B a mano: -540,8 - 9,72 = -550,52', abs(op[1][1] + 550.52) < 1e-9)
    chk('somma dei deal = somma delle posizioni', abs(sum(x[1] for x in od) - sum(x[1] for x in op)) < 1e-9)
    chk('PF = 259,48 / 550,52', abs(pf([x[1] for x in op]) - 259.48 / 550.52) < 1e-12)
    # DD: saldo 1000 -> +259,48 -> -550,52 : picco 1259,48, fondo 708,96
    chk('DD chiuso a mano', abs(dd_chiuso([259.48, -550.52], 1000) - 550.52 / 1259.48 * 100) < 1e-9)
    # contro-esempio: il degrado deve mordere in proporzione al volume, non al numero di deal
    op0, _ = netti_posizione(pos, 2.0, 100, 0.0, 0.0, qf)
    op1, _ = netti_posizione(pos, 2.0, 100, 1.0, 0.0, qf)
    chk('ds=1 costa 1 x V x C x q per posizione (A 18, B 18)',
        abs((op0[0][1] - op1[0][1]) - 18.0) < 1e-9 and abs((op0[1][1] - op1[1][1]) - 18.0) < 1e-9)
    # contro-esempio: l'errore "spread pagato per deal" (2 deal in A) darebbe 36 su A -> qui deve essere 18
    chk('spread NON moltiplicato per il numero di deal', abs((op0[0][1] - op1[0][1]) - 36.0) > 1)
    # stop 846 sulla sola posizione B: rischio scelto per avere R = 5,408% x 1000 = 54,08 x 10 = 540,8
    # = perdita piena con le due commissioni -> la controprova deve restituire lo stop di 30 $
    lo, hi, oss, rapp = stop_846(posizioni(dB), 2.0, 100, qf, 10000, 5.408)
    chk('stop 846: banda della posizione B contiene 30 $ nel caso di perdita piena',
        len(oss) == 1 and abs(oss[0] - 30.0) < 1e-9)
    # serie con edge noto: +100 / -50 alternati, 100 posizioni da 1 lotto, q = 1, C = 1
    serie = []
    for i in range(100):
        serie.append(dict(t=t0 + dt.timedelta(days=i), pid=str(i), tipo=1, vol=1.0, prezzo=1.0,
                          net=100.0 if i % 2 == 0 else -50.0))
    p2 = posizioni(serie)
    one = lambda t: 1.0
    r0 = scenario(p2, 0.0, 1, 0.0, 0.0, one, 10000, t0 + dt.timedelta(days=50))
    chk('serie nota: PF = 2,0', abs(r0['pf'] - 2.0) < 1e-12)
    r = scenario(p2, 0.0, 1, 25.0, 0.0, one, 10000, t0 + dt.timedelta(days=50))
    chk('serie nota con costo 25: PF = 75/75 = 1,0', abs(r['pf'] - 1.0) < 1e-12)
    r = scenario(p2, 0.0, 1, 100.0, 0.0, one, 10000, t0 + dt.timedelta(days=50))
    chk('serie nota con costo 100: PF = 0 (crolla)', r['pf'] == 0.0)
    chk('meta\': 50 + 50 posizioni', r0['n1'] == 50 and r0['n2'] == 50)
    print(f'\nAUTOTEST: {"PASS" if fail == 0 else f"FALLITO ({fail})"}')
    return 0 if fail == 0 else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--autotest', action='store_true')
    ap.add_argument('--pertrade')
    ap.add_argument('--k', type=float, default=0.0, help='commissione d\'ingresso per lotto (classe 844)')
    ap.add_argument('--deposito', type=float, default=100000.0)
    ap.add_argument('--rischio', type=float, default=0.5, help='rischio %% per trade (solo per lo stop 846)')
    ap.add_argument('--C', type=float, default=100.0, help='unita\' per lotto (oro 100 oz)')
    ap.add_argument('--punto', type=float, default=0.01, help='valore di 1 punto in prezzo (Digits=2 -> 0.01)')
    ap.add_argument('--passo', type=float, default=0.01, help='passo di volume')
    ap.add_argument('--q', type=float, default=None, help='cambio fisso (default: misurato dal file)')
    ap.add_argument('--base-spread', type=float, action='append', default=None)
    ap.add_argument('--taglio', default='2023.04.01')
    ap.add_argument('--attesa-pf', type=float, default=None)
    ap.add_argument('--attesa-dd', type=float, default=None)
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    if not a.pertrade:
        ap.error('--pertrade oppure --autotest')
    if not a.base_spread:
        a.base_spread = [0.45]
    return esegui(a)


if __name__ == '__main__':
    sys.exit(main())
