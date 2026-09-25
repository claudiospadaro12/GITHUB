#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r252_attese.py -- 25/09/2026

LE ATTESE DI R252, SCRITTE PRIMA DEI NUMERI.
Ogni numero dei par. 1, 5, 6 e 8 di prove/R252a_short_DAX_ora8_controllo.txt si
rifa' da qui, a seme fisso. Legge SOLO file gia' in archivio: nessun
backtest, nessun EA, nessun terminale.

DOMANDA DI R252: lo short dell'apertura DAX (geometria 770101 a specchio,
R251 "ancora") con l'ora IN FASE con la cash tutto l'anno -- cioe' quello
che eseguirebbe un server in fase con Xetra, come FTMO -- passa i
cancelli di rischio di R251, e che merito ha?
  BCM indici = UTC+1 fisso (report/OROLOGIO_BCM_2026-09-24.md): la cash
  Xetra (09:00 ora tedesca) e' alle 8 server d'estate e alle 9 d'inverno.
  InpSessionHour=8 tutto l'anno (R251) arma d'inverno UN'ORA PRIMA.
  La curva "in fase" si ricompone dal per-trade: righe d'ESTATE della
  corsa a ora 8, righe d'INVERNO della corsa a ora 9 (18:30 di chiusura).

SEZIONI
  0. calendario UE e feriali per era e stagione (le finestre di R252)
  1. ancore dal per-trade di R251 (792520 short nudo, 792510 D1):
     divisione per stagione, DD a saldo chiuso contro DD_fisso del CSV
     (il fattore k), peggior giornata a saldo chiuso contro il CSV
  2. sentinella S1: quante uscite della corsa a ora 8 cadono dove la
     corsa a ora 9 NON puo' averne (contro-esempio del pin che non arriva)
  3. bootstrap della curva IN FASE dell'OOS sotto due ipotesi:
       H_O (orologio): d'inverno alla cash lo short rende come d'estate
           alla cash (frequenza e P/L dal pool estivo);
       H_S (stagione): d'inverno rende come l'inverno a ora 8 (pool
           invernale, frequenza invernale).
     Le posizioni d'ESTATE sono FISSE (sono le stesse righe in tutte e
     due le corse, par. 5 del file di testa): si ricampiona solo l'inverno.
  4. il long di riferimento: divisione per stagione del per-trade d0 di
     R246 (794613 finestra A + 794611 finestra B, deposito 100000)
  5. banda dell'errore e del metodo A (classe 800): simulazione
     dell'arrotondamento del lotto a saldi diversi (seme 252, 2000
     estrazioni per caso), lotti d'inverno come a ora 8 e x0,55

ONESTA': il bootstrap tratta le posizioni come indipendenti e il DD come
funzione del solo ordine dentro l'inverno; la sequenza vera ha autocorre-
lazione (le perdite a grappolo). Le bande sono ORDINI DI GRANDEZZA per
dire DOPO se il round si e' comportato come previsto, NON cancelli.

USO:  python3 backtest_pipeline/r252_attese.py
"""
import collections
import csv
import datetime as dt
import math
import os
import random

QUI = os.path.dirname(os.path.abspath(__file__))
PT = os.path.join(QUI, 'risultati_archivio')

# calendario UE per DATA DI CHIUSURA: identico a r246_bande_attese.INV['UE']
INV = [(dt.date(2024, 10, 27), dt.date(2025, 3, 30)),
       (dt.date(2025, 10, 26), dt.date(2026, 3, 29))]
ERE = {
    'IS_R252':  (dt.date(2024, 9, 27), dt.date(2025, 6, 30)),   # gamba continua, senza il 26/09
    'IS_R251':  (dt.date(2024, 9, 26), dt.date(2025, 6, 30)),
    'OOS':      (dt.date(2025, 7, 1), dt.date(2026, 6, 30)),
    'TUTTO':    (dt.date(2024, 9, 27), dt.date(2026, 6, 30)),
}
# CSV di R251 (risultati_archivio/R251/ROUND_R251b e ROUND_R251), ricopiati
# qui e ricontrollati da carica_csv() contro i file:
ANCORA_OOS = dict(profit=254.74, rf=0.19989, trades=243, worst=-1.0042)
D1_OOS = dict(profit=792.32, rf=1.00899, trades=126, worst=-1.0039)


def inverno(d):
    return any(a <= d < b for a, b in INV)


def feriali(a, b):
    e = i = 0
    d = a
    while d <= b:
        if d.weekday() < 5:
            if inverno(d):
                i += 1
            else:
                e += 1
        d += dt.timedelta(1)
    return e, i


def carica(nome, tag=''):
    righe = []
    with open(nome, newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            t = dt.datetime.strptime(r['close_time'], '%Y.%m.%d %H:%M:%S')
            righe.append((t, tag + r['position_id'], float(r['net_profit'])))
    righe.sort()
    return righe


def posizioni(righe):
    pos = collections.OrderedDict()
    for t, pid, pl in righe:
        pos.setdefault(pid, []).append((t, pl))
    return pos


def pf(xs):
    gp = sum(v for v in xs if v > 0)
    gl = -sum(v for v in xs if v < 0)
    return gp / gl if gl > 0 else 99.0


def dd_chiuso(pl_in_ordine, base=10000.0):
    b = pk = base
    dd = 0.0
    for v in pl_in_ordine:
        b += v
        pk = max(pk, b)
        dd = max(dd, pk - b)
    return dd


def peggior_giorno_chiuso(righe, base=10000.0):
    g = collections.OrderedDict()
    for t, _pid, pl in righe:
        g[t.date()] = g.get(t.date(), 0.0) + pl
    b, w = base, 0.0
    for d in g:
        w = min(w, 100.0 * g[d] / b)
        b += g[d]
    return w


def carica_csv(nome, riga_pass):
    with open(nome, newline='') as fh:
        rr = list(csv.DictReader(fh))
    for r in rr:
        if r['Pass'] == str(riga_pass):
            return r
    raise SystemExit('pass non trovato in ' + nome)


def q(xs, p):
    s = sorted(xs)
    return s[min(len(s) - 1, int(p * len(s)))]


def main():
    print("=== 0. FERIALI (lun-ven) per era e stagione, calendario UE per data ===")
    fer = {}
    for k, (a, b) in ERE.items():
        fer[k] = feriali(a, b)
        print("  %-8s %s -> %s   estate %3d   inverno %3d" % (k, a, b, fer[k][0], fer[k][1]))

    print()
    print("=== 1. ANCORE DAL PER-TRADE DI R251 (gamba OOS, deposito 10000) ===")
    c = carica_csv(os.path.join(PT, 'R251/ROUND_R251b/ABTG_DAX_Apertura_EU_D30EUR_OOS_R251b.csv'), 1)
    assert abs(float(c['Profit']) - ANCORA_OOS['profit']) < 0.005
    assert abs(float(c['Recovery Factor']) - ANCORA_OOS['rf']) < 0.000005
    c = carica_csv(os.path.join(PT, 'R251/ROUND_R251/ABTG_DAX_Apertura_EU_D30EUR_OOS_R251.csv'), 4)
    assert abs(float(c['Profit']) - D1_OOS['profit']) < 0.005
    assert abs(float(c['Recovery Factor']) - D1_OOS['rf']) < 0.000005
    print("  (CSV ricontrollati: Profit e Recovery Factor ricopiati qui = file)")
    ks = {}
    for mg, anc, nome in (('792520', ANCORA_OOS, 'short nudo (ancora)'),
                          ('792510', D1_OOS, 'Supertrend D1')):
        r = carica(os.path.join(PT, 'R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_' + mg + '.csv'))
        p = posizioni(r)
        tot = sum(x[2] for x in r)
        print("  %s %s: %d deal, %d posizioni, somma %.2f (CSV %.2f)"
              % (mg, nome, len(r), len(p), tot, anc['profit']))
        for s, flt in (('estate', lambda d: not inverno(d)), ('inverno', inverno)):
            pl = [sum(v for _t, v in dl) for dl in p.values() if flt(dl[0][0].date())]
            print("      %-7s %3d posizioni  PF %.3f  P/L %+.2f  EP %+.3f"
                  % (s, len(pl), pf(pl), sum(pl), sum(pl) / max(1, len(pl))))
        ddc = dd_chiuso([x[2] for x in r])
        ddf = anc['profit'] / anc['rf']
        k = ddf / ddc
        ks[mg] = k
        print("      DD a saldo chiuso %.2f (%.3f%% di 10000) | DD_fisso CSV %.2f (%.3f%%) | k = %.4f"
              % (ddc, ddc / 100, ddf, ddf / 100, k))
        print("      peggior giornata a saldo chiuso %.4f%% | CSV %.4f%%"
              % (peggior_giorno_chiuso(r), anc['worst']))

    print()
    print("=== 2. SENTINELLA S1: uscite della corsa a ora 8 (792520) per fascia oraria BCM ===")
    r = carica(os.path.join(PT, 'R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv'))
    prima935 = sum(1 for t, _p, _v in r if (t.hour, t.minute) < (9, 35))
    dopo1731 = sum(1 for t, _p, _v in r if (t.hour, t.minute) > (17, 31))
    prima835 = sum(1 for t, _p, _v in r if (t.hour, t.minute) < (8, 35))
    print("  uscite prima delle 08:35: %d su %d (impossibili a ora 8)" % (prima835, len(r)))
    print("  uscite prima delle 09:35: %d su %d = %.1f%% (impossibili a ora 9)"
          % (prima935, len(r), 100.0 * prima935 / len(r)))
    print("  uscite dopo le 17:31: %d (impossibili a ora 8)" % dopo1731)
    print("  ultima uscita del giorno piu' tarda: %s" % max(t.time() for t, _p, _v in r))

    print()
    print("=== 3. BOOTSTRAP DELLA CURVA IN FASE, OOS (seme 252, 20000 ricampionamenti) ===")
    random.seed(252)
    R = 20000
    p = posizioni(r)
    lista = list(p.values())
    est = [dl for dl in lista if not inverno(dl[0][0].date())]
    inv = [dl for dl in lista if inverno(dl[0][0].date())]
    est1 = [dl for dl in est if dl[0][0].date() < dt.date(2025, 10, 26)]
    est2 = [dl for dl in est if dl[0][0].date() >= dt.date(2026, 3, 29)]
    e_f, i_f = fer['OOS']
    r_e = len(est) / e_f
    r_i = len(inv) / i_f
    ctrl_pl = [sum(v for _t, v in dl) for dl in lista]
    pf_ctrl = pf(ctrl_pl)
    ep_ctrl = sum(ctrl_pl) / len(ctrl_pl)
    k_max = max(ks.values())
    print("  estate fissa: %d posizioni (%d prima dell'inverno, %d dopo); tasso estate %.4f pos/feriale,"
          " tasso inverno a ora 8 %.4f" % (len(est), len(est1), len(est2), r_e, r_i))
    print("  controllo (ora 8 tutto l'anno): %d posizioni, PF per posizione %.4f, EP %.4f"
          % (len(ctrl_pl), pf_ctrl, ep_ctrl))
    print("  k usato per il DD stimato: %.4f (il massimo della sez. 1)" % k_max)
    for nome, pool, rate in (('H_O orologio', est, r_e), ('H_S stagione', inv, r_i)):
        n_l, pf_l, ep_l, dd_l, pr_l = [], [], [], [], []
        m1 = m2 = r2 = r2f = n150 = 0
        for _ in range(R):
            n = sum(1 for _d in range(i_f) if random.random() < rate)
            w = [random.choice(pool) for _j in range(n)]
            seq = est1 + w + est2
            plp = [sum(v for _t, v in dl) for dl in seq]
            deals = [v for dl in seq for _t, v in dl]
            npos = len(seq)
            f = pf(plp)
            ep = sum(plp) / npos
            dd = dd_chiuso(deals) / 100.0
            n_l.append(npos)
            pf_l.append(f)
            ep_l.append(ep)
            dd_l.append(dd)
            pr_l.append(sum(plp))
            n150 += npos >= 150
            m1 += f >= 1.10
            m2 += (f >= pf_ctrl + 0.10) and (ep > ep_ctrl)
            r2 += dd * k_max <= 8.21
            r2f += dd > 8.21
        print("  %s: posizioni OOS p10-p50-p90 %d-%d-%d  P(>=150) %.3f"
              % (nome, q(n_l, .1), q(n_l, .5), q(n_l, .9), n150 / R))
        print("      PF per posizione p10-p50-p90 %.3f-%.3f-%.3f  P(M1 PF>=1,10) %.3f  P(M2) %.3f"
              % (q(pf_l, .1), q(pf_l, .5), q(pf_l, .9), m1 / R, m2 / R))
        print("      Profit p10-p50-p90 %+.0f/%+.0f/%+.0f   EP p50 %+.3f"
              % (q(pr_l, .1), q(pr_l, .5), q(pr_l, .9), q(ep_l, .5)))
        print("      DD a saldo chiuso %% p10-p50-p90 %.2f-%.2f-%.2f  P(DD x k <= 8,21) %.3f"
              "  P(DD chiuso > 8,21) %.3f" % (q(dd_l, .1), q(dd_l, .5), q(dd_l, .9), r2 / R, r2f / R))
        # CONTRO-ESEMPIO DEL BOOTSTRAP: sotto H_S la curva in fase E' il
        # controllo ricampionato. Il DD VERO del controllo (sez. 1, 12,461%)
        # dove cade nella banda? Se cade in coda, il ricampionamento i.i.d.
        # rompe i grappoli di perdite e le bande di DD sono OTTIMISTE.
        ddv = dd_chiuso([x[2] for x in r]) / 100.0
        pfv = pf(ctrl_pl)
        print("      il controllo VERO (DD chiuso %.3f%%, PF %.4f) sta al percentile DD %.3f, PF %.3f"
              " di questa banda" % (ddv, pfv, sum(1 for v in dd_l if v < ddv) / R,
                                    sum(1 for v in pf_l if v < pfv) / R))

    print()
    print("=== 3-bis. DOVE STA IL DD DEL CONTROLLO OOS (792520, a saldo chiuso) ===")
    b = pk = 10000.0
    t_pk = r[0][0]
    peggio = (0.0, None, None)
    for t, _pid, v in r:
        b += v
        if b > pk:
            pk, t_pk = b, t
        if pk - b > peggio[0]:
            peggio = (pk - b, t_pk, t)
    print("  DD massimo %.2f dal picco del %s al minimo del %s (inverno? picco %s, minimo %s)"
          % (peggio[0], peggio[1], peggio[2], inverno(peggio[1].date()), inverno(peggio[2].date())))
    for lo, hi in ((dt.date(2025, 7, 1), dt.date(2025, 10, 26)), (dt.date(2026, 3, 29), dt.date(2026, 7, 1))):
        blocco = [v for t, _pid, v in r if lo <= t.date() < hi]
        print("  blocco d'estate %s -> %s: %d deal, netto %+.2f, DD interno %.2f (%.3f%%)"
              % (lo, hi - dt.timedelta(1), len(blocco), sum(blocco), dd_chiuso(blocco), dd_chiuso(blocco) / 100))
    print("  => le righe d'estate sono le STESSE nella curva in fase: il DD interno del blocco"
          " peggiore e' un PAVIMENTO del DD chiuso della curva in fase OOS")

    print()
    print("=== 4. IL LONG DI RIFERIMENTO: per-trade d0 di R246 (A 794613 + B 794611, deposito 100000) ===")
    ra = carica(os.path.join(PT, 'R246/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_794613.csv'), 'A')
    rb = carica(os.path.join(PT, 'R246/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_794611.csv'), 'B')
    print("  A: %d deal, %s -> %s | B: %d deal, %s -> %s"
          % (len(ra), ra[0][0].date(), ra[-1][0].date(), len(rb), rb[0][0].date(), rb[-1][0].date()))
    pl = posizioni(sorted(ra + rb))
    for s, flt in (('estate', lambda d: not inverno(d)), ('inverno', inverno)):
        x = [dl for dl in pl.values() if flt(dl[0][0].date())]
        dealpl = [v for dl in x for _t, v in dl]
        print("      %-7s %3d posizioni  %3d deal  PF sui deal %.3f  PF per posizione %.3f"
              % (s, len(x), len(dealpl), pf(dealpl), pf([sum(v for _t, v in dl) for dl in x])))
    prima935 = sum(1 for t, _p, _v in ra + rb if (t.hour, t.minute) < (9, 35))
    print("  S1 del long: uscite d0 prima delle 09:35: %d su %d = %.1f%%"
          % (prima935, len(ra + rb), 100.0 * prima935 / len(ra + rb)))
    print("  (A e B sono DUE corse: la chiave di posizione e' file+position_id, non il solo id)")

    print()
    sez5()


def sez5():
    print("=== 5. BANDA DELL'ERRORE e DEL METODO A (classe 800), seme 252 ===")
    pos = collections.OrderedDict()
    with open(os.path.join(PT, 'R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv'), newline='') as fh:
        for x in csv.DictReader(fh, delimiter=';'):
            d = dt.datetime.strptime(x['close_time'], '%Y.%m.%d %H:%M:%S').date()
            pos.setdefault(x['position_id'], []).append((d, float(x['volume']), float(x['net_profit'])))
    P = list(pos.values())
    random.seed(252)
    for wsc in (1.0, 0.55):      # lotti d'inverno come a ora 8 / x0,55 (mediana estate 1,00 / inverno 1,80)
        for g in (0.05, 0.10):   # scarto di saldo corsa/curva
            es = []
            for _ in range(2000):
                St = S = 10000.0
                Br = 10000.0 * (1 - g)
                sT, sA = [], []
                for dl in P:
                    sc = wsc if inverno(dl[0][0]) else 1.0
                    vt = sum(v for _d, v, _p in dl)
                    plu = sum(p for _d, _v, p in dl) / (vt + 0.05)          # P/L per lotto
                    le = (vt + 0.1 * random.random()) * sc                  # lotto esatto a 10000
                    lt = max(0.1, math.floor(le * St / 10000 / 0.1 + 1e-9) * 0.1)  # EA in fase, suo saldo
                    lr = max(0.1, math.floor(le * Br / 10000 / 0.1 + 1e-9) * 0.1)  # corsa, altro saldo
                    sT.append(plu * lt); St += plu * lt
                    a = plu * lr / Br * S; sA.append(a); S += a; Br += plu * lr
                dT = dd_chiuso(sT)
                es.append(abs(dd_chiuso(sA) - dT) / dT)
            print("  lotti inverno x%.2f  scarto %2d%%: e p50 %.4f p90 %.4f p99 %.4f max %.4f"
                  % (wsc, 100 * g, q(es, .5), q(es, .9), q(es, .99), max(es)))


if __name__ == '__main__':
    main()
