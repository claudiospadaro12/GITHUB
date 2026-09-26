#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r255_attese.py -- 26/09/2026

LE ATTESE DI R255, SCRITTE PRIMA DEI NUMERI.
Ogni numero dei par. 1, 4, 5, 6, 8 e 9 di
prove/R255a_short_DOW_ancora_1430.txt (file di testa) si rifa' da qui, a
seme fisso. Legge SOLO file gia' in archivio: nessun backtest, nessun EA,
nessun terminale.

DOMANDA DI R255 (Claudio, 26/09): "il dow ha anche la parte short? mi
sembra di no. facciamo anche quella!!!!!"
Lo short dell'apertura Dow (geometria della sedia 770202 a specchio), con
l'uscita ad asse, col filtro di regime Supertrend, col filtro EMA H4 acceso
e spento, e con l'ora IN FASE con la cash di New York tutto l'anno.
  BCM indici = UTC+1 fisso (report/OROLOGIO_BCM_2026-09-24.md). La cash NY
  (09:30 ora di New York) cade alle 14:30 BCM con l'ora legale USA (EDT,
  UTC-4) e alle 15:30 BCM con l'ora solare USA (EST, UTC-5). Il calendario
  che conta sul BCM e' SOLO quello USA (il DAX segue solo quello UE).

SEZIONI
  0. calendario USA e feriali per era e stagione; sedute di confine;
     settimane di disallineamento UE/USA (nota per FTMO, non per BCM)
  1. il LONG di riferimento (i tetti R1-R3): r6 (deposito 10000, il
     banco) e il per-trade d0 di R246 (794603 finestra A, 794601
     finestra B, deposito 100000): posizioni, serie, DD a saldo chiuso,
     fattore k e scarto additivo D contro il CSV della stessa corsa
  2. l'ANCORA dello short (G0): R54a, solo short, deposito 100000
  3. sentinella S1: uscite del long d0 prima delle 16:05 (contro-esempio
     del pin dell'ora 15:30 che non arriva)
  4. classe 804: probabilita' che un motore SENZA edge (esiti del long
     ricentrati) rispetti R1/R2 (tetti a saldo chiuso 4,694 / 4,272) a n
     posizioni
  5. classe 800: banda dell'errore e del metodo A (ricomposizione),
     arrotondamento del lotto a 10000 (passo 0,1), seme 255

USO:  python3 backtest_pipeline/r255_attese.py          (~20 s)
"""
import collections
import csv
import datetime as dt
import math
import os
import random

QUI = os.path.dirname(os.path.abspath(__file__))
ARC = os.path.join(QUI, 'risultati_archivio')
PRO = os.path.join(QUI, 'risultati_prove')

# calendario USA per DATA: identico a r246_bande_attese.INV['USA'] e a
# ora_legale_usa() di controlla_riga.py. Intervalli [inizio, fine).
INV_USA = [(dt.date(2024, 11, 3), dt.date(2025, 3, 9)),
           (dt.date(2025, 11, 2), dt.date(2026, 3, 8))]
INV_UE = [(dt.date(2024, 10, 27), dt.date(2025, 3, 30)),
          (dt.date(2025, 10, 26), dt.date(2026, 3, 29))]
# ERE di R255 = finestre B di r6 / R54 / R246 (taglio 0,40), per data di chiusura
ERE = collections.OrderedDict([
    ('IS', (dt.date(2024, 9, 27), dt.date(2025, 6, 9))),     # gamba continua, senza il 26/09
    ('OOS', (dt.date(2025, 6, 10), dt.date(2026, 6, 30))),
])


def inverno(d, cal=INV_USA):
    return any(a <= d < b for a, b in cal)


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


def carica_pt(nome):
    righe = []
    with open(nome, newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            t = dt.datetime.strptime(r['close_time'], '%Y.%m.%d %H:%M:%S')
            righe.append((t, r['position_id'], float(r['volume']), float(r['net_profit']), r['deal_type']))
    righe.sort(key=lambda x: x[0])
    return righe


def posizioni(righe):
    pos = collections.OrderedDict()
    for t, pid, v, pl, _ty in righe:
        pos.setdefault(pid, []).append((t, v, pl))
    return pos


def dd_chiuso(pl, base):
    b = pk = base
    dd = 0.0
    for v in pl:
        b += v
        pk = max(pk, b)
        dd = max(dd, pk - b)
    return dd


def peggior_giorno(righe, base):
    g = collections.OrderedDict()
    for t, _p, _v, pl, _ty in righe:
        g[t.date()] = g.get(t.date(), 0.0) + pl
    b, w = base, 0.0
    for d in g:
        w = min(w, 100.0 * g[d] / b)
        b += g[d]
    return w


def serie(pos):
    s = best = 0
    for dl in pos.values():
        if sum(p for _t, _v, p in dl) < 0:
            s += 1
            best = max(best, s)
        else:
            s = 0
    return best


def csv_righe(nome):
    with open(nome, newline='') as fh:
        return list(csv.DictReader(fh))


def q(xs, p):
    s = sorted(xs)
    return s[min(len(s) - 1, int(p * len(s)))]


def main():
    print("=== 0. FERIALI (lun-ven) per era e stagione, calendario USA per data ===")
    for k, (a, b) in ERE.items():
        e, i = feriali(a, b)
        print("  %-4s %s -> %s  estate %3d  inverno %3d  tot %3d" % (k, a, b, e, i, e + i))
    print("  primo feriale d'inverno USA: 2024.11.04, 2025.11.03; primo d'estate: 2025.03.10, 2026.03.09")
    print("  settimane UE solare / USA legale (feriali, per FTMO: BCM non cambia ora):")
    d = dt.date(2024, 9, 27)
    blocchi = []
    while d <= dt.date(2026, 6, 30):
        if d.weekday() < 5 and inverno(d, INV_UE) != inverno(d, INV_USA):
            blocchi.append(d)
        d += dt.timedelta(1)
    gruppi = []
    for x in blocchi:
        if gruppi and (x - gruppi[-1][-1]).days <= 3:
            gruppi[-1].append(x)
        else:
            gruppi.append([x])
    for g in gruppi:
        print("    %s -> %s  (%d feriali)  UE %s / USA %s" % (g[0], g[-1], len(g),
              'inverno' if inverno(g[0], INV_UE) else 'estate',
              'inverno' if inverno(g[0], INV_USA) else 'estate'))

    print("\n=== 1. IL LONG DI RIFERIMENTO (770202, r6 = deposito 10000, tick reali) ===")
    for gamba in ('IS', 'OOS'):
        rr = csv_righe(os.path.join(PRO, 'ABTG_Dow_Apertura_US', 'ABTG_Dow_Apertura_US_U30USD_%s_r6.csv' % gamba))
        r = [x for x in rr if x['InpRangeMinutes'] == '35' and x['InpAllowShort'] == '0'][0]
        p, rf = float(r['Profit']), float(r['Recovery Factor'])
        print("  r6 %-3s Pass %s  Trades %s  Profit %s  PF %s  RF %s  EqDD %s  PeggGiorno %s  -> DD_fisso %.4f%% (%.2f EUR)"
              % (gamba, r['Pass'], r['Trades'], r['Profit'], r['Profit Factor'], r['Recovery Factor'],
                 r['Equity DD %'], r['Peggior Giornata %'], p / rf / 100.0, p / rf))
    for tag, f, csvf in (('IS  (A, 794603)', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv',
                          'ROUND_R246c/ABTG_Dow_Apertura_US_U30USD_OOS_R246c.csv'),
                         ('OOS (B, 794601)', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794601.csv',
                          'ROUND_R246a/ABTG_Dow_Apertura_US_U30USD_OOS_R246a.csv')):
        rr = carica_pt(os.path.join(ARC, 'R246', 'PERTRADE', f))
        pos = posizioni(rr)
        ddc = dd_chiuso([x[3] for x in rr], 100000.0)
        c = [x for x in csv_righe(os.path.join(ARC, 'R246', csvf)) if x['InpMagic'].endswith('01') or x['InpMagic'].endswith('03')][0]
        ddf = float(c['Profit']) / float(c['Recovery Factor'])
        ee = collections.Counter('inv' if inverno(dl[-1][0].date()) else 'est' for dl in pos.values())
        print("  %s deal %d  posizioni %d (estate %d, inverno %d)  serie perdente %d  DD_chiuso %.2f (%.3f%%)"
              "  DD_fisso CSV %.2f (%.3f%%)  k %.4f  D %.3f punti  pegg.giorno chiuso %.4f%%"
              % (tag, len(rr), len(pos), ee['est'], ee['inv'], serie(pos), ddc, ddc / 1000.0,
                 ddf, ddf / 1000.0, ddf / ddc, (ddf - ddc) / 1000.0, peggior_giorno(rr, 100000.0)))

    print("\n=== 2. L'ANCORA DELLO SHORT: R54a (solo short, EMA H4 acceso, 14:30 tutto l'anno, deposito 100000) ===")
    for gamba in ('IS', 'OOS'):
        rr = csv_righe(os.path.join(ARC, 'csv_r54', 'ABTG_Dow_Apertura_US_U30USD_%s_r54a.csv' % gamba))
        for r in rr:
            if r['InpAllowLong'] == '0' and r['InpAllowShort'] == '1':
                p, rf = float(r['Profit']), float(r['Recovery Factor'])
                print("  R54a %-3s magic %s  Trades %s  Profit %s  PF %s  EqDD %s  PeggGiorno %s  DD_fisso %.3f%%"
                      % (gamba, r['InpMagic'], r['Trades'], r['Profit'], r['Profit Factor'], r['Equity DD %'],
                         r['Peggior Giornata %'], p / rf / 1000.0))

    print("\n=== 3. SENTINELLA S1: il pin dell'ora 15:30 che non arriva (= corsa a 14:30, default compilato) ===")
    tot = prima = dopo = 0
    for f in ('abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794601.csv'):
        for t, _p, _v, _pl, _ty in carica_pt(os.path.join(ARC, 'R246', 'PERTRADE', f)):
            tot += 1
            m = t.hour * 60 + t.minute
            prima += m < 16 * 60 + 5
            dopo += m >= 17 * 60 + 31
    print("  long d0 (794603+794601): uscite %d, prima delle 16:05 %d (%.1f%%), dalle 17:31 %d" % (tot, prima, 100.0 * prima / tot, dopo))

    print("\n=== 4. CLASSE 804: P(un motore SENZA edge rispetta il tetto) a n posizioni, seme 255, 20000 cammini ===")
    R = []
    for f in ('abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794601.csv'):
        rr = carica_pt(os.path.join(ARC, 'R246', 'PERTRADE', f))
        b = 100000.0
        for dl in posizioni(rr).values():
            pl = sum(p for _t, _v, p in dl)
            R.append(pl / (b * 0.01))
            b += pl
    m = sum(R) / len(R)
    print("  esiti del long 770202 per posizione: n %d, media %.3f R, perdita piena media %.3f R"
          % (len(R), m, sum(x for x in R if x < -0.5) / max(1, sum(1 for x in R if x < -0.5))))
    random.seed(255)
    for ev in (0.0, -0.10):
        Z = [x - m + ev for x in R]
        for S in (4.694, 4.272):          # i tetti R1/R2 a saldo chiuso (sez. 1: 794603, 794601)
            riga = []
            for n in (20, 30, 40, 60, 80, 100, 150):
                ok = 0
                for _ in range(20000):
                    c = pk = dd = 0.0
                    for _k in range(n):
                        c += random.choice(Z)
                        if c > pk:
                            pk = c
                        if pk - c > dd:
                            dd = pk - c
                    ok += dd <= S
                riga.append("n%d %.2f" % (n, ok / 20000.0))
            print("  EV %+.2f R  tetto %.3f%%: %s" % (ev, S, "  ".join(riga)))

    sez5()


def sez5():
    print("\n=== 5. BANDA DELL'ERRORE e DEL METODO A (classe 800), seme 255, 2000 estrazioni ===")
    pos = []
    for f in ('abtg_trades_ABTG_Dow_Apertura_US_U30USD_794603.csv', 'abtg_trades_ABTG_Dow_Apertura_US_U30USD_794601.csv'):
        for dl in posizioni(carica_pt(os.path.join(ARC, 'R246', 'PERTRADE', f))).values():
            d = dl[-1][0].date()
            v1 = dl[0][1] if len(dl) == 1 else sum(v for _t, v, _p in dl)
            pos.append((d, v1 / 10.0, sum(p for _t, _v, p in dl) / (v1 / 10.0)))   # lotto a 10000, P/L per lotto
    lotti = sorted(x[1] for x in pos)
    print("  lotti equivalenti a 10000 (dal 100000 / 10): min %.2f  mediana %.2f  max %.2f" % (lotti[0], lotti[len(lotti) // 2], lotti[-1]))
    random.seed(255)
    for wsc in (1.0, 0.55):
        for g in (0.05, 0.10):
            es = []
            for _ in range(2000):
                St = S = 10000.0
                Br = 10000.0 * (1 + g)
                sT, sA = [], []
                for d, le0, plu in pos:
                    sc = wsc if inverno(d) else 1.0
                    le = max(0.1, math.floor(le0 / 0.1) * 0.1 + 0.1 * random.random()) * sc
                    lt = max(0.1, math.floor(le * St / 10000 / 0.1 + 1e-9) * 0.1)
                    lr = max(0.1, math.floor(le * Br / 10000 / 0.1 + 1e-9) * 0.1)
                    sT.append(plu * lt)
                    St += plu * lt
                    a = plu * lr / Br * S
                    sA.append(a)
                    S += a
                    Br += plu * lr
                dT = dd_chiuso(sT, 10000.0)
                es.append(abs(dd_chiuso(sA, 10000.0) - dT) / dT)
            print("  lotti d'inverno x%.2f  scarto di saldo %2d%%: e p50 %.4f p90 %.4f p99 %.4f max %.4f"
                  % (wsc, 100 * g, q(es, .5), q(es, .9), q(es, .99), max(es)))


if __name__ == '__main__':
    main()
