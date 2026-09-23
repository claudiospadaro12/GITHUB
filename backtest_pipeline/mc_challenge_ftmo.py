#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_challenge_ftmo.py -- 23/09/2026

QUANTO VALE LA CHALLENGE FTMO CON LE SEDIE CHE ABBIAMO.

Monte Carlo sull'ORDINE DEI GIORNI, sulle serie per-trade in repo.
Prodotto per report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md: ogni numero
di quel documento si rifa' da qui.

REGOLE MODELLATE (docs/REGOLAMENTO_FTMO_2026-08.md par.1-2):
  - Profit Target      : +10% del capitale iniziale
  - Minimum Trading Days: 4
  - Max Loss           : STATICO, equity sotto il 90% del capitale INIZIALE
  - Max Daily Loss     : perdita di giornata oltre il 5% del capitale INIZIALE
  - Nessun limite di tempo (la sequenza si rimescola e si allunga)
  - Taglia fissa-frazionale: il P/L del giorno scala col saldo del giorno
  - Guardian (opzionale): taglia la perdita della giornata a InpDailyLossPct

LIMITI DICHIARATI (stanno anche nel referto, par. 3.3):
  1. QUATTRO sedie su sei. Mancano 770260 e 770511, ed sono correlate a
     quelle presenti => il numero e' un PAVIMENTO, non un tetto.
  2. P/L REALIZZATO, non equity: il muro giornaliero FTMO include il
     floating. Scarto misurato sul DAX: -15,7%.
  3. Il rimescolamento distrugge l'ordine: se le giornate brutte si
     ammucchiano, lo statico morde di piu'.
  4. UN SOLO REGIME (2024.09 -> 2026.06, toro). Nessun rimescolamento
     fabbrica un 2020.
  5. Scala x2 dal rischio 1,00%: MISURATA x1,9557 / x1,9901 => sovrastima
     il DD, cioe' sbaglia nel verso giusto.

USO:  python3 backtest_pipeline/mc_challenge_ftmo.py
"""
import csv, collections, random, statistics, os, sys

QUI = os.path.dirname(os.path.abspath(__file__))

SORGENTI = {
 '770101 DAX'   : 'risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv',
 '770202 Dow'   : 'risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv',
 '770411 MaxMin': 'risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv',
 '771531 EMA200': 'risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv',
}
DEPOSITO_MISURA = 100000.0   # i quattro per-trade sono tutti a deposito 100.000, rischio 1,00%
SALDO_VERO_2209 = 78242.32   # dopo il primo stop della challenge (report/PRIMO_STOP_FTMO_2026-09-22.md)
BANCO_FTMO      = 80000.0


def carica():
    per = {}
    for nome, rel in SORGENTI.items():
        p = os.path.join(QUI, rel)
        d = collections.defaultdict(float)
        with open(p, newline='') as fh:
            for r in csv.DictReader(fh, delimiter=';'):
                d[r['close_time'][:10]] += float(r['net_profit'])
        per[nome] = d
    return per


def serie(per, copia=None, peggiora=1.0):
    """Rendimento frazionale per giornata, alla taglia della misura (1,00%).
       copia    : nome di una sedia da CONTARE DUE VOLTE (fantoccio per una
                  sedia mancante e correlata).
       peggiora : moltiplicatore sulle sole GIORNATE IN PERDITA."""
    giorni = sorted(set().union(*[set(d) for d in per.values()]))
    out = []
    for g in giorni:
        v = sum(per[n].get(g, 0.0) for n in per)
        if copia:
            v += per[copia].get(g, 0.0)
        v /= DEPOSITO_MISURA
        if v < 0:
            v *= peggiora
        out.append(v)
    return giorni, out


def simula(frac1, fattore, saldo_iniziale=1.0, guardian=None, slip=1.0,
           n_sim=20000, seme=11, target=0.10, muro_stat=0.10, muro_gior=0.05,
           min_giorni=4, max_giorni=800):
    rnd = random.Random(seme)
    f = [x * fattore for x in frac1]
    esiti = collections.Counter(); durate = []
    for _ in range(n_sim):
        s = f[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; esito = None; i = 0
        while esito is None:
            if i >= len(s):
                s2 = f[:]; rnd.shuffle(s2); s = s + s2
            r = s[i]; i += 1
            if r < 0:
                r *= slip
            b0 = bal
            perdita = -r * b0
            if guardian is not None and perdita > guardian:
                perdita = guardian          # il Guardian chiude tutto e blocca la giornata
                r = -perdita / b0
            bal = b0 + r * b0
            g += 1
            if (b0 - bal) > muro_gior:   esito = 'MORTE_GIORNALIERA'; break
            if bal < 1.0 - muro_stat:    esito = 'MORTE_STATICA';     break
            if bal >= 1.0 + target and g >= min_giorni: esito = 'PASS'; break
            if g >= max_giorni:          esito = 'TIMEOUT';           break
        esiti[esito] += 1
        if esito == 'PASS':
            durate.append(g)
    tot = sum(esiti.values())
    return ({k: 100.0 * v / tot for k, v in esiti.items()},
            statistics.median(durate) if durate else None)


def riga(nome, o, med):
    print("  %-40s PASS %5.1f%% | giorn %5.1f%% | statico %5.1f%% | timeout %4.1f%% | gg mediani %s" % (
        nome, o.get('PASS', 0), o.get('MORTE_GIORNALIERA', 0),
        o.get('MORTE_STATICA', 0), o.get('TIMEOUT', 0), med))


def main():
    per = carica()
    giorni, base = serie(per)
    print("=" * 96)
    print("MONTE CARLO CHALLENGE FTMO -- 4 sedie su 6, %d giornate, tick reali, rischio della misura 1,00%%" % len(giorni))
    print("finestra: %s -> %s   somma dei rendimenti @1,00%%: %+.4f" % (giorni[0], giorni[-1], sum(base)))
    print("=" * 96)

    # --- le giornate, come le chiedeva il mandato
    pd = collections.defaultdict(dict)
    for n, d in per.items():
        for k, v in d.items():
            pd[k][n] = v
    c = collections.Counter(sum(1 for v in pd[g].values() if v < 0) for g in giorni)
    print("\n[GIORNATE] sedie in PERDITA nello stesso giorno: " +
          "  ".join("%d sedie: %d gg" % (k, c[k]) for k in sorted(c)))
    peggiori = sorted((sum(pd[g].values()), g) for g in giorni)[:3]
    for v, g in peggiori:
        print("   peggiore: %s  %+10.2f = %+.3f%% @1,00%%  ->  %+.3f%% @2,00%%   %s" % (
            g, v, 100 * v / DEPOSITO_MISURA, 200 * v / DEPOSITO_MISURA,
            {n: round(x, 2) for n, x in sorted(pd[g].items())}))
    for soglia in (4.0, 4.9, 5.0):
        k = sum(1 for g in giorni if -200 * sum(pd[g].values()) / DEPOSITO_MISURA > soglia)
        print("   giornate con perdita aggregata oltre %.1f%% @2,00%%: %d" % (soglia, k))

    S = SALDO_VERO_2209 / BANCO_FTMO
    print("\n[SCENARIO OTTIMISTA] solo realizzato, 4 sedie, saldo di partenza %.5f (stato vero del 22/09)" % S)
    for nome, fatt, gd, sl in [("2,00% -- Guardian NON attivo", 2.0, None,  1.0),
                               ("2,00% -- Guardian attivo 4,5%/gg", 2.0, 0.045, 1.0),
                               ("2,00% -- Guardian attivo + slippaggio +10,5%", 2.0, 0.045, 1.105),
                               ("1,00% -- Guardian attivo", 1.0, 0.045, 1.0)]:
        o, m = simula(base, fatt, S, guardian=gd, slip=sl)
        riga(nome, o, m)

    _, cattiva = serie(per, copia='770202 Dow', peggiora=1.157)
    print("\n[SCENARIO PESSIMISTA] A: 5a sedia correlata (copia di 770202)  +  B: perdite x1,157 (floating)  +  C: slippaggio x1,105")
    for nome, fatt in [("2,00% -- Guardian NON attivo", 2.0), ("2,00% -- Guardian attivo", 2.0),
                       ("1,30% -- Guardian attivo", 1.3), ("1,00% -- Guardian attivo", 1.0),
                       ("0,65% -- Guardian attivo", 0.65)]:
        gd = None if 'NON attivo' in nome else 0.045
        o, m = simula(cattiva, fatt, S, guardian=gd, slip=1.105)
        riga(nome, o, m)

    print("\n" + "=" * 96)
    print("LIMITI: 4 sedie su 6 (le due mancanti sono CORRELATE => pavimento) · P/L realizzato, non equity ·")
    print("        un solo regime (toro) · scala x2 MISURATA a x1,956-1,990, cioe' conservativa.")
    print("=" * 96)


if __name__ == '__main__':
    main()
