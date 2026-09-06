#!/usr/bin/env python3
# =====================================================================
#  MISURA_GAPCASH_NASDAQ  --  06/09/2026
#  Strumento di riproducibilita' del dossier
#  caccia_strategie/CACCIA_NASDAQ_MECCANISMI_2026-09-06.md
# ---------------------------------------------------------------------
#  DOMANDA (scritta prima dei numeri):
#    il GAP DELLA SESSIONE CASH del Nasdaq (open 09:30 New York meno
#    l'ultima chiusura cash <= 16:00 del giorno di borsa prima)
#    predice la direzione dei primi minuti della seduta USA?
#
#  FONTE: backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/
#         ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv  (4.877 giornate)
#         prodotto il 26/08/2026 da anatomia_aperture.py sul file
#         C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv (5.233.590
#         barre M1, 2010.11.14 -> 2026.07.31, ORA DI NEW YORK).
#         NON e' il feed tick di BCM: e' storico ESTERNO.
#
#  REGOLA DELLE DUE FASI, rispettata alla lettera (referto della fonte):
#    "le IPOTESI di motore si scrivono SOLO sul referto _IS_ (fino al
#     2020). Il referto _CASSAFORTE_ (2021-2026) NON si guarda per
#     costruirle."
#    -> QUESTO SCRIPT FILTRA fase == 'IS'. La cassaforte NON e' stata
#       aperta, e nessun numero qui dentro la contiene.
#
#  COSTO: 0,0060% del prezzo = 1,7 punti indice su 28.270 (spread
#         MEDIANO MISURATO NASUSD 14-20 server, fonte
#         risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md).
#         Dedotto UNA volta per operazione. E' una STIMA OTTIMISTA:
#         il minuto dell'apertura e' il peggiore della seduta e non
#         e' stato misurato a parte.
# =====================================================================
import csv
import statistics as st

SORGENTE = ("/home/user/GITHUB/backtest_pipeline/risultati_archivio/"
            "ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv")
COSTO_PCT = 0.0060
CAMPI = ['gap_pct', 'cl5_pct', 'cl15_pct', 'cl30_pct', 'cl60_pct',
         'up15_pct', 'dn15_pct', 'up60_pct', 'dn60_pct']


def carica(percorso):
    fuori = []
    for r in csv.DictReader(open(percorso)):
        if r['fase'] != 'IS' or r['stato'] != 'OK':
            continue
        rec = {'anno': r['data'][:4], 'data': r['data']}
        buono = True
        for k in CAMPI:
            try:
                rec[k] = float(r[k])
            except (ValueError, KeyError):
                buono = False
                break
        if buono:
            fuori.append(rec)
    return fuori


def quantile(v, p):
    v = sorted(v)
    i = (len(v) - 1) * p
    lo = int(i)
    hi = min(lo + 1, len(v) - 1)
    return v[lo] + (v[hi] - v[lo]) * (i - lo)


def riga_descrittiva(s, etichetta):
    if len(s) < 10:
        return
    c = [r['cl15_pct'] for r in s]
    up = [r['up15_pct'] for r in s]
    dn = [r['dn15_pct'] for r in s]
    print("%-32s n=%5d  cl15 media %+.4f  mediana %+.4f  win %.1f%%  "
          "MFE15 med %+.4f  MAE15 med %+.4f"
          % (etichetta, len(s), st.mean(c), st.median(c),
             100 * sum(1 for x in c if x > 0) / len(c),
             st.median(up), st.median(dn)))


def simula(s, stop_pct):
    """Stop-only + uscita a TEMPO (+15 min). Se la MAE dei primi 15
    minuti tocca -stop, l'operazione chiude a -stop; altrimenti chiude
    al prezzo del minuto 15. Esatto per una regola SENZA target
    (l'unica ambiguita' di percorso sarebbe stop-contro-target)."""
    res = []
    for r in s:
        pnl = -stop_pct if -r['dn15_pct'] >= stop_pct else r['cl15_pct']
        res.append(pnl - COSTO_PCT)
    stopout = 100.0 * sum(1 for r in s if -r['dn15_pct'] >= stop_pct) / len(s)
    vinte = 100.0 * sum(1 for x in res if x > 0) / len(res)
    guad = sum(x for x in res if x > 0)
    pers = -sum(x for x in res if x < 0)
    return {'n': len(res), 'stopout': stopout, 'E_pct': st.mean(res),
            'E_R': st.mean(res) / stop_pct, 'win': vinte,
            'PF': (guad / pers) if pers else float('inf')}


def main():
    d = carica(SORGENTE)
    print("=" * 70)
    print("FINESTRA IS soltanto (2010-2020). Giornate usabili: %d" % len(d))
    print("=" * 70)

    print("\n--- 1. CORRELAZIONE gap vs reazione (orizzonte per orizzonte) ---")
    g = [r['gap_pct'] for r in d]
    mg = st.mean(g)
    sg = st.pstdev(g)
    for k in ['cl5_pct', 'cl15_pct', 'cl30_pct', 'cl60_pct']:
        c = [r[k] for r in d]
        mc = st.mean(c)
        cov = sum((a - mg) * (b - mc) for a, b in zip(g, c)) / len(g)
        print("    corr(gap, %-9s) = %+.4f" % (k, cov / (sg * st.pstdev(c))))

    print("\n--- 2. LA CELLA (LONG all'apertura sui gap in giu') vs CONTROLLO ---")
    riga_descrittiva(d, "CONTROLLO: tutti i giorni")
    for th in [-0.3, -0.4, -0.5, -0.6, -0.75, -1.0]:
        riga_descrittiva([r for r in d if r['gap_pct'] <= th],
                         "gap <= %.2f%%" % th)

    print("\n--- 3. IL LATO OPPOSTO, misurato (regola dei due lati, 25/08) ---")
    for th in [0.3, 0.4, 0.5, 0.75, 1.0]:
        s = [r for r in d if r['gap_pct'] >= th]
        if len(s) < 10:
            continue
        c = [-r['cl15_pct'] for r in s]
        print("    SHORT su gap >= +%.2f%%  n=%4d  media %+.4f  "
              "mediana %+.4f  win %.1f%%"
              % (th, len(s), st.mean(c), st.median(c),
                 100 * sum(1 for x in c if x > 0) / len(c)))

    print("\n--- 4. GEOMETRIA della cella gap <= -0.5% (fissa lo stop) ---")
    cella = [r for r in d if r['gap_pct'] <= -0.5]
    mae = [-r['dn15_pct'] for r in cella]
    mfe = [r['up15_pct'] for r in cella]
    print("    |MAE15| p25 %.3f  p50 %.3f  p75 %.3f  p90 %.3f"
          % (quantile(mae, .25), quantile(mae, .5),
             quantile(mae, .75), quantile(mae, .90)))
    print("     MFE15  p25 %.3f  p50 %.3f  p75 %.3f  p90 %.3f"
          % (quantile(mfe, .25), quantile(mfe, .5),
             quantile(mfe, .75), quantile(mfe, .90)))

    print("\n--- 5. SIMULAZIONE stop-only + uscita a tempo, costo dedotto ---")
    print("    %-8s %5s %9s %10s %8s %7s %7s"
          % ("stop %", "n", "stopout%", "E netta %", "E in R", "win%", "PF"))
    for s_pct in [0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.60, 0.80]:
        o = simula(cella, s_pct)
        print("    %-8.2f %5d %9.1f %10.4f %8.3f %7.1f %7.3f"
              % (s_pct, o['n'], o['stopout'], o['E_pct'], o['E_R'],
                 o['win'], o['PF']))

    print("\n--- 6. IL CONTROLLO CHE CONTA: la stessa simulazione SENZA il gate ---")
    for s_pct in [0.30, 0.40, 0.50]:
        o = simula(d, s_pct)
        print("    stop %.2f%%  n=%4d  E %+.4f%% = %+.3fR  win %.1f%%  PF %.3f"
              % (s_pct, o['n'], o['E_pct'], o['E_R'], o['win'], o['PF']))

    print("\n--- 7. TENUTA DI REGIME: si tolgono i due anni piu' volatili ---")
    senza = [r for r in cella if r['anno'] not in ('2018', '2020')]
    for s_pct in [0.30, 0.40, 0.50, 0.60]:
        o = simula(senza, s_pct)
        print("    senza 2018/2020  stop %.2f%%  n=%3d  E %+.4f%% = %+.3fR  "
              "win %.1f%%  PF %.3f"
              % (s_pct, o['n'], o['E_pct'], o['E_R'], o['win'], o['PF']))

    print("\n--- 8. FREQUENZA per anno della cella gap <= -0.5% ---")
    anni = {}
    for r in cella:
        anni[r['anno']] = anni.get(r['anno'], 0) + 1
    print("    " + "  ".join("%s:%d" % (a, n) for a, n in sorted(anni.items())))
    print("    totale %d giornate su %d = %.1f%% dei giorni di borsa"
          % (len(cella), len(d), 100.0 * len(cella) / len(d)))
    print("\n!!! NESSUN NUMERO DI QUESTO FILE VIENE DALLA CASSAFORTE 2021-2026.")


if __name__ == '__main__':
    main()
