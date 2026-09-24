#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r246_bande_attese.py -- 24/09/2026

LE BANDE DELLE DUE IPOTESI DI R246, SCRITTE PRIMA DEI NUMERI.
Ogni numero dei paragrafi 6-8 di prove/R246a_orologio_DOW_U30USD_d0_B.txt
(e dei file di testa R246e, R246i) si rifa' da qui, a seme fisso.

DOMANDA: il PF migliore delle sedie d'apertura nei mesi "sfasati" (armo
un'ora prima della cash, BCM UTC+1 fisso) e' OROLOGIO o STAGIONE?
R246 gira d'estate la stessa cella con tutto l'orario a -1h.
  H_STAGIONE: la cella -1h d'estate rende come d0 d'estate.
  H_OROLOGIO: la cella -1h d'estate rende come d0 d'inverno (sfasato).

METODO
  - per-trade del Monte Carlo (mc_challenge_ftmo.py r.40-43), finestra B
    2025.06.10 -> 2026.06.29;
  - giorni classificati per DATA DI CHIUSURA col calendario del mercato:
    UE (DAX, MaxMin) ultima dom. ottobre -> ultima dom. marzo;
    USA (Dow) prima dom. novembre -> seconda dom. marzo;
  - n PROIETTATO sulla finestra A+B (2024.09.27 -> 2026.06.29):
    posizioni per feriale della stagione x feriali estivi A+B;
  - PF: bootstrap sulle POSIZIONI (tutti i deal di una posizione
    insieme), PF sui deal come MT5 e come il MC;
  - frequenza: binomiale (InpOneTradePerDay=1 -> al massimo 1 al giorno).
  - zone del verdetto: Q = (X - rif_E)/(rif_I - rif_E),
    Q<=0.30 STAGIONE, Q>=0.70 OROLOGIO, in mezzo MISTO.

ONESTA': il bootstrap tratta le celle come INDIPENDENTI; d0 e -1h girano
sugli stessi giorni, quindi sotto H_STAGIONE l'errore vero e' PIU'
PICCOLO di quello stampato (numero prudente).

USO:  python3 backtest_pipeline/r246_bande_attese.py     (~9 secondi)

SEZIONE 5 (24/09, casella d+1, prove/R246m-r): la cella con TUTTO l'orario
+1h letta sui giorni d'INVERNO (d'inverno arma ALLA CASH, come le sedie
FTMO). Q2 = (rif_I0 - X)/(rif_I0 - rif_E0), stesse zone e stessa
precondizione di R246a par. 7, regola simulata com'e' scritta (classe
764). Le sezioni 1-4 danno gli stessi numeri di prima: la sez. 5 ha semi
propri (17, 19, 23) e gira DOPO.
"""
import collections
import csv
import datetime as dt
import math
import os
import random

QUI = os.path.dirname(os.path.abspath(__file__))

F = {
    'DOW': ('risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv', 'USA'),
    'DAX': ('risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv', 'UE'),
    'MM':  ('risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv', 'UE'),
}
INV = {
    'UE':  [(dt.date(2024, 10, 27), dt.date(2025, 3, 30)), (dt.date(2025, 10, 26), dt.date(2026, 3, 29))],
    'USA': [(dt.date(2024, 11, 3), dt.date(2025, 3, 9)), (dt.date(2025, 11, 2), dt.date(2026, 3, 8))],
}
B = (dt.date(2025, 6, 10), dt.date(2026, 6, 29))
A = (dt.date(2024, 9, 27), dt.date(2025, 6, 9))


def inverno(d, cal):
    return any(a <= d < b for a, b in INV[cal])


def feriali(a, b, cal):
    e = i = 0
    d = a
    while d <= b:
        if d.weekday() < 5:
            if inverno(d, cal):
                i += 1
            else:
                e += 1
        d += dt.timedelta(1)
    return e, i


def pf(x):
    gp = sum(v for v in x if v > 0)
    gl = -sum(v for v in x if v < 0)
    return gp / gl if gl > 0 else 99.0


def carica(f, cal):
    pos = {'E': collections.defaultdict(list), 'I': collections.defaultdict(list)}
    with open(os.path.join(QUI, f), newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            d = dt.datetime.strptime(r['close_time'][:10], '%Y.%m.%d').date()
            s = 'I' if inverno(d, cal) else 'E'
            pos[s][r['position_id']].append(float(r['net_profit']))
    return pos


def boot(pos, s, n, rip):
    lista = list(pos[s].values())
    out = []
    for _ in range(rip):
        x = []
        for _ in range(n):
            x += random.choice(lista)
        out.append(pf(x))
    return out


def phi(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))


def main():
    dati = {}
    print("=== 1. ANCORE (finestra B) E BANDE p10-p90, seme 11, 5000 ricampionamenti ===")
    random.seed(11)
    R = 5000
    for k, (f, cal) in F.items():
        pos = carica(f, cal)
        fb = feriali(*B, cal)
        fa = feriali(*A, cal)
        fE, fI = fb[0] + fa[0], fb[1] + fa[1]
        rE, rI = len(pos['E']) / fb[0], len(pos['I']) / fb[1]
        pE = pf([v for L in pos['E'].values() for v in L])
        pI = pf([v for L in pos['I'].values() for v in L])
        M = (pE + pI) / 2
        dati[k] = (pos, fE, fI, rE, rI, pE, pI)
        print(f"== {k}: feriali B(E,I)={fb} A(E,I)={fa} A+B E={fE} I={fI}; "
              f"pos E={len(pos['E'])} I={len(pos['I'])}; pos/feriale E={rE:.3f} I={rI:.3f}; "
              f"PF E={pE:.3f} I={pI:.3f} divario={pI - pE:.3f}")
        q = lambda b, p: sorted(b)[min(len(b) - 1, int(p * len(b)))]
        for nome, nS, nO, sS, sO in (("X1 estate -1h", round(rE * fE), round(rI * fE), 'E', 'I'),
                                     ("X2 inverno +1h (casella d+1, R246m-r)", round(rI * fI), round(rE * fI), 'I', 'E')):
            bS = boot(pos, sS, nS, R)
            bO = boot(pos, sO, nO, R)
            print(f"   {nome}: H_STAGIONE n={nS} [{q(bS, .1):.2f} ; {q(bS, .9):.2f}]  "
                  f"H_OROLOGIO n={nO} [{q(bO, .1):.2f} ; {q(bO, .9):.2f}]")
        # 24/09 (casella d+1): fino a oggi Y2 stampava H_STAGIONE col tasso
        # ESTIVO e H_OROLOGIO con l'INVERNALE, come Y1. Per Y2 e' il
        # contrario (d+1 d'inverno: H_STAGIONE -> tasso invernale, H_OROLOGIO
        # -> tasso estivo). Numeri invariati, ETICHETTE scambiate: Y2 non era
        # citato in nessun file R246a-l (latente). Corretto qui, senza toccare
        # il flusso casuale (Y non usa random).
        for nome, dd, rS, rO in (("Y1 posizioni estate -1h", fE, rE, rI),
                                 ("Y2 posizioni inverno +1h (casella d+1, R246m-r)", fI, rI, rE)):
            sS = math.sqrt(rS * (1 - rS) / dd)
            sO = math.sqrt(rO * (1 - rO) / dd)
            print(f"   {nome}: giorni={dd}  H_STAGIONE [{(rS - 1.2816 * sS) * dd:.1f} ; {(rS + 1.2816 * sS) * dd:.1f}]"
                  f"  H_OROLOGIO [{(rO - 1.2816 * sO) * dd:.1f} ; {(rO + 1.2816 * sO) * dd:.1f}]")

    print()
    print("=== 2. ZONE DEL VERDETTO (Q 0,30 / 0,70), seme 5, 6000 ricampionamenti ===")
    print("    triple = probabilita' (STAGIONE, MISTO, OROLOGIO) se e' vera l'ipotesi indicata")
    random.seed(5)
    R = 6000
    for k in F:
        pos, fE, fI, rE, rI, pE, pI = dati[k]
        D = pI - pE
        lo, hi = pE + 0.30 * D, pE + 0.70 * D
        bS = boot(pos, 'E', round(rE * fE), R)
        bO = boot(pos, 'I', round(rI * fE), R)

        def zona(b):
            return (sum(v <= lo for v in b) / R, sum(lo < v < hi for v in b) / R, sum(v >= hi for v in b) / R)
        zs, zo = zona(bS), zona(bO)
        print(f"{k} PF: soglie PF {lo:.3f} / {hi:.3f} | se H_STAGIONE ({zs[0]:.3f} ; {zs[1]:.3f} ; {zs[2]:.3f})"
              f" | se H_OROLOGIO ({zo[0]:.3f} ; {zo[1]:.3f} ; {zo[2]:.3f})")
        flo = (rE + 0.3 * (rI - rE)) * fE
        fhi = (rE + 0.7 * (rI - rE)) * fE
        for nome, rr in (("H_STAGIONE", rE), ("H_OROLOGIO", rI)):
            sd = math.sqrt(rr * (1 - rr) * fE)
            mu = rr * fE
            a = phi((flo - mu) / sd)
            c = 1 - phi((fhi - mu) / sd)
            print(f"   FREQ se {nome}: soglie posizioni {flo:.1f} / {fhi:.1f}  ({a:.3f} ; {1 - a - c:.3f} ; {c:.3f})")

    print()
    print("=== 3. IL CONTRO-ESEMPIO DELLA FINESTRA: Dow con la SOLA B (n=58), seme 7, 4000 ===")
    random.seed(7)
    pos = dati['DOW'][0]
    n = len(pos['E'])
    bS = sorted(boot(pos, 'E', n, 4000))
    bO = sorted(boot(pos, 'I', n, 4000))
    print(f"   X1 con n={n}: H_STAGIONE [{bS[400]:.2f} ; {bS[3600]:.2f}]  H_OROLOGIO [{bO[400]:.2f} ; {bO[3600]:.2f}]"
          f"  -> {'SOVRAPPOSTE' if bO[400] <= bS[3600] else 'disgiunte'}")


def sezione4():
    print()
    print("=== 4. LA REGOLA COM'E' SCRITTA (par. 7): riferimenti d0 A+B MISURATI NEL ROUND, seme 13, 6000 ===")
    print("    parte B = serie del MC (fissa se G0 VERDE), parte A = ricampionata; celle indipendenti.")
    print("    P(pre) = probabilita' che la precondizione passi; triple CONDIZIONATE a pre.")
    random.seed(13)
    R = 6000
    for k, (f, cal) in F.items():
        pos = carica(f, cal)
        E = list(pos['E'].values())
        I = list(pos['I'].values())
        fb, fa = feriali(*B, cal), feriali(*A, cal)
        rE, rI = len(E) / fb[0], len(I) / fb[1]
        fE, fI = fb[0] + fa[0], fb[1] + fa[1]
        nAE, nAI = round(rE * fa[0]), round(rI * fa[1])
        pE = pf([v for L in E for v in L])
        pI = pf([v for L in I for v in L])
        for H in ('STAGIONE', 'OROLOGIO'):
            zp, zf, okp, okf = [0, 0, 0], [0, 0, 0], 0, 0
            for _ in range(R):
                e0 = pf([v for L in E + [random.choice(E) for _ in range(nAE)] for v in L])
                i0 = pf([v for L in I + [random.choice(I) for _ in range(nAI)] for v in L])
                src, r = (E, rE) if H == 'STAGIONE' else (I, rI)
                x = pf([v for _ in range(round(r * fE)) for v in random.choice(src)])
                D = i0 - e0
                if D >= (pI - pE) / 2:
                    okp += 1
                    q = (x - e0) / D
                    zp[0 if q <= 0.30 else (2 if q >= 0.70 else 1)] += 1
                fe0 = (len(E) + sum(random.random() < rE for _ in range(fa[0]))) / fE
                fi0 = (len(I) + sum(random.random() < rI for _ in range(fa[1]))) / fI
                fx = sum(random.random() < r for _ in range(fE)) / fE
                Df = fi0 - fe0
                if Df >= (rI - rE) / 2:
                    okf += 1
                    q = (fx - fe0) / Df
                    zf[0 if q <= 0.30 else (2 if q >= 0.70 else 1)] += 1
            t = lambda z, n: f"({z[0] / n:.3f} ; {z[1] / n:.3f} ; {z[2] / n:.3f})"
            print(f"{k} se H_{H}: PF P(pre)={okp / R:.3f} {t(zp, okp)} | FREQ P(pre)={okf / R:.3f} {t(zf, okf)}")


def sezione5():
    """CASELLA d+1 (R246m-r, 24/09/2026): tutto l'orario +1h, letta sui
    giorni d'INVERNO. d'inverno la cella d+1 arma ALLA CASH (cio' che le sedie
    FTMO faranno da fine ottobre). Confronto con la d0 d'ESTATE (alla cash).
      H_OROLOGIO: d+1 inverno ~ d0 ESTATE  (conta la tempistica)
      H_STAGIONE: d+1 inverno ~ d0 INVERNO (conta la stagione)
    Q2 = (PF_I0 - PF_I+1) / (PF_I0 - PF_E0): H_OROLOGIO -> ~1, H_STAGIONE -> ~0.
    Stesse zone (0,30 / 0,70), stessa precondizione (D >= meta' del divario
    d'ancora) e stessi riferimenti d0 A+B misurati nel round di R246a par. 7.
    Stesso metodo di sezione4 (classe 764): riferimenti rumorosi, P(pre)."""
    print()
    print("=== 5. CASELLA d+1 (R246m-r): PF e frequenza della d+1 sui giorni d'INVERNO A+B ===")
    print("    Q2 = (rif_I0 - X)/(rif_I0 - rif_E0): Q2>=0,70 OROLOGIO, Q2<=0,30 STAGIONE.")
    print("    5a bande p10-p90 seme 17 (5000); 5b regola com'e' scritta seme 19 (6000);"
          " 5c contro-esempio sola B seme 23 (4000).")
    q = lambda b, p: sorted(b)[min(len(b) - 1, int(p * len(b)))]
    random.seed(17)
    R = 5000
    for k, (f, cal) in F.items():
        pos = carica(f, cal)
        fb, fa = feriali(*B, cal), feriali(*A, cal)
        fI = fb[1] + fa[1]
        rE, rI = len(pos['E']) / fb[0], len(pos['I']) / fb[1]
        pE = pf([v for L in pos['E'].values() for v in L])
        pI = pf([v for L in pos['I'].values() for v in L])
        D = pI - pE
        nS, nO = round(rI * fI), round(rE * fI)
        bS = boot(pos, 'I', nS, R)
        bO = boot(pos, 'E', nO, R)
        sS = math.sqrt(rI * (1 - rI) / fI)
        sO = math.sqrt(rE * (1 - rE) / fI)
        print(f"5a {k}: giorni inverno A+B={fI}; X2 PF d+1 inverno: H_STAGIONE n={nS} [{q(bS, .1):.2f} ; {q(bS, .9):.2f}]"
              f"  H_OROLOGIO n={nO} [{q(bO, .1):.2f} ; {q(bO, .9):.2f}]"
              f"  -> {'SOVRAPPOSTE' if q(bS, .1) <= q(bO, .9) else 'disgiunte'}")
        print(f"      Y2 posizioni d+1 inverno: H_STAGIONE [{(rI - 1.2816 * sS) * fI:.1f} ; {(rI + 1.2816 * sS) * fI:.1f}]"
              f"  H_OROLOGIO [{(rE - 1.2816 * sO) * fI:.1f} ; {(rE + 1.2816 * sO) * fI:.1f}]")
        print(f"      soglie all'ancora: PF OROLOGIO se X <= {pI - 0.70 * D:.3f}, STAGIONE se X >= {pI - 0.30 * D:.3f};"
              f" posizioni OROLOGIO se <= {(rI - 0.70 * (rI - rE)) * fI:.1f}, STAGIONE se >= {(rI - 0.30 * (rI - rE)) * fI:.1f}")

    random.seed(19)
    R = 6000
    for k, (f, cal) in F.items():
        pos = carica(f, cal)
        E = list(pos['E'].values())
        I = list(pos['I'].values())
        fb, fa = feriali(*B, cal), feriali(*A, cal)
        rE, rI = len(E) / fb[0], len(I) / fb[1]
        fE, fI = fb[0] + fa[0], fb[1] + fa[1]
        nAE, nAI = round(rE * fa[0]), round(rI * fa[1])
        pE = pf([v for L in E for v in L])
        pI = pf([v for L in I for v in L])
        for H in ('STAGIONE', 'OROLOGIO'):
            zp, zf, okp, okf = [0, 0, 0], [0, 0, 0], 0, 0
            for _ in range(R):
                e0 = pf([v for L in E + [random.choice(E) for _ in range(nAE)] for v in L])
                i0 = pf([v for L in I + [random.choice(I) for _ in range(nAI)] for v in L])
                src, r = (I, rI) if H == 'STAGIONE' else (E, rE)
                x = pf([v for _ in range(round(r * fI)) for v in random.choice(src)])
                D = i0 - e0
                if D >= (pI - pE) / 2:
                    okp += 1
                    q2 = (i0 - x) / D
                    zp[0 if q2 <= 0.30 else (2 if q2 >= 0.70 else 1)] += 1
                fe0 = (len(E) + sum(random.random() < rE for _ in range(fa[0]))) / fE
                fi0 = (len(I) + sum(random.random() < rI for _ in range(fa[1]))) / fI
                fx = sum(random.random() < r for _ in range(fI)) / fI
                Df = fi0 - fe0
                if Df >= (rI - rE) / 2:
                    okf += 1
                    q2 = (fi0 - fx) / Df
                    zf[0 if q2 <= 0.30 else (2 if q2 >= 0.70 else 1)] += 1
            t = lambda z, n: f"({z[0] / n:.3f} ; {z[1] / n:.3f} ; {z[2] / n:.3f})" if n else "(n/d)"
            print(f"5b {k} se H_{H}: PF P(pre)={okp / R:.3f} {t(zp, okp)} | FREQ P(pre)={okf / R:.3f} {t(zf, okf)}")

    random.seed(23)
    pos = carica(*F['DOW'])
    n = len(pos['I'])
    bS = sorted(boot(pos, 'I', n, 4000))
    bO = sorted(boot(pos, 'E', n, 4000))
    print(f"5c DOW X2 con la SOLA B (n={n} pos. d'inverno): H_STAGIONE [{bS[400]:.2f} ; {bS[3600]:.2f}]"
          f"  H_OROLOGIO [{bO[400]:.2f} ; {bO[3600]:.2f}]"
          f"  -> {'SOVRAPPOSTE' if bS[400] <= bO[3600] else 'disgiunte'}")

    # giorni in cui il calendario UE e quello USA non concordano (Dow): FTMO
    # (ora italiana + 1, calendario UE) arma a 15:30 BCM = 10:30 NY in ora
    # legale USA -- un'ora TARDI -- e la cella d+1 fa lo stesso. Il Dow li
    # classifica ESTATE (calendario USA): fuori dal verdetto d'inverno.
    fer = 0
    d = A[0]
    while d <= B[1]:
        if d.weekday() < 5 and inverno(d, 'UE') and not inverno(d, 'USA'):
            fer += 1
        d += dt.timedelta(1)
    print(f"5d DOW feriali A+B con UE in ora solare e USA in ora legale (d+1 = FTMO = 10:30 NY): {fer}")


if __name__ == "__main__":
    main()
    sezione4()
    sezione5()
