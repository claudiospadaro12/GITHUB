#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ombra_forzafx_freq_sintetica.py -- sonda SINTETICA (random walk, H0 per costruzione) sulla FREQUENZA degli
eventi del punteggio ForzaFX. Serve a report/OMBRA_FORZAFX_SPEC_2026-10-05.md sez. 4.

NON E' UNA MISURA SUL MERCATO. Le 8 valute fanno random walk indipendenti (nessun trend, nessun clustering di
volatilita', nessuna correlazione fra valute) e le 28 coppie sono le differenze. Quindi:
  - la FREQUENZA degli eventi e' un ordine di grandezza (sul mercato vero sara' diversa: code grasse, USD che guida);
  - il rendimento a valle di un evento DEVE uscire ~0 (e' il contro-esempio dello script: se uscisse positivo ci
    sarebbe uno sguardo nel futuro nel codice).
Differenze dichiarate rispetto alla dashboard: M1 non simulato (peso 1/62), Sanity = 0 su tutte le coppie
(quindi punteggio max +-90), mese = 4 settimane da 5 giorni, tick = un punto ogni 5 minuti.
Stato e formule: copia fedele di FFX_Stato / FFX_Forza / FFX_Componenti / FFX_Confluenza (collaudo_forza_fx.py py_*).

Uso: python3 backtest_pipeline/ombra_forzafx_freq_sintetica.py [--semi 5] [--settimane 104]
"""
import argparse
import itertools
import math

import numpy as np

VAL = ["EUR", "GBP", "AUD", "NZD", "USD", "CAD", "CHF", "JPY"]
# le 28 coppie (base, quotata) nell'ordine della lista della dashboard (solo per l'indicizzazione)
COPPIE = ("EURGBP,EURAUD,EURNZD,EURUSD,EURCAD,EURCHF,EURJPY,GBPAUD,GBPNZD,GBPUSD,GBPCAD,GBPCHF,GBPJPY,AUDNZD,AUDUSD,"
          "AUDCAD,AUDCHF,AUDJPY,NZDUSD,NZDCAD,NZDCHF,NZDJPY,USDCAD,USDCHF,USDJPY,CADCHF,CADJPY,CHFJPY").split(",")
BASE = np.array([VAL.index(c[:3]) for c in COPPIE])
QUOT = np.array([VAL.index(c[3:]) for c in COPPIE])
# TF in punti da 5 minuti: M5 M15 M30 H1 H4 D1 W1 MN  (settimana = 5 giorni x 288 punti)
TFN = ["M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN"]
LEN = np.array([1, 3, 6, 12, 48, 288, 1440, 5760])
PESO = np.array([1, 2, 3, 4, 6, 10, 15, 20], dtype=float)
STRAT = np.array([0, 0, 0, 0, 1, 1, 1, 1])
UPBRK, UP, FAILDN, NEUTRO, FAIL2, FAILUP, DN, DNBRK = 2, 1, 5, 0, 7, 6, 3, 4
SIGMA_GIORNO = 0.0042            # vol giornaliera di una valuta (coppia ~0,6%/giorno)
PTS_GIORNO = 288


def stati(c, o0, h0, l0, h1, l1):
    """FFX_Stato vettoriale: rottura > doppio fail > fail > sopra/sotto apertura."""
    s = np.full(c.shape, NEUTRO, dtype=np.int8)
    s = np.where(c > o0, UP, s)
    s = np.where(c < o0, DN, s)
    fu = h0 > h1
    fd = l0 < l1
    s = np.where(fd, FAILDN, s)
    s = np.where(fu, FAILUP, s)
    s = np.where(fu & fd, FAIL2, s)
    s = np.where(c < l1, DNBRK, s)
    s = np.where(c > h1, UPBRK, s)
    return s


VALORE = np.zeros(8)
VALORE[UPBRK], VALORE[UP], VALORE[FAILDN], VALORE[FAILUP], VALORE[DN], VALORE[DNBRK] = 2.0, 1.0, 0.5, -0.5, -1.0, -2.0
DIR = np.zeros(8)
DIR[UP] = DIR[UPBRK] = DIR[FAILDN] = 1.0
DIR[DN] = DIR[DNBRK] = DIR[FAILUP] = -1.0
ROTT = np.zeros(8)
ROTT[UPBRK], ROTT[DNBRK], ROTT[FAILUP], ROTT[FAILDN] = 1.0, -1.0, -0.5, 0.5


def mround(x):
    """MathRound di MQL5 = lontano da zero sulla meta' (come in C)."""
    return np.sign(x) * np.floor(np.abs(x) + 0.5)


def simula(rng, settimane):
    T = settimane * 5 * PTS_GIORNO
    sd = SIGMA_GIORNO / math.sqrt(PTS_GIORNO)
    x = np.cumsum(rng.normal(0.0, sd, size=(8, T)), axis=1)          # log-forza delle valute
    p = x[BASE, :] - x[QUOT, :]                                       # log-prezzo delle coppie (28, T)
    return p


def letture(p, passo=12):
    """punteggi (28, S) e forze (8, S) ai confini orari (S letture), con candela che contiene l'istante t-1."""
    T = p.shape[1]
    k = np.arange(passo - 1, T, passo)                                 # t = passo*m, ultimo punto = t-1
    k = k[k >= 5760 * 2]                                               # salta i primi 2 mesi (serve il MN precedente)
    S = k.size
    vsum = np.zeros((28, S))
    dsum = np.zeros((28, S))
    rsum = np.zeros((28, S))
    for t, L in enumerate(LEN):
        n = T // L
        blk = p[:, : n * L].reshape(28, n, L)
        cmax = np.maximum.accumulate(blk, axis=2)
        cmin = np.minimum.accumulate(blk, axis=2)
        q = k // L
        pos = k % L
        c = p[:, k]
        o0 = p[:, q * L]
        h0 = cmax[:, q, pos]
        l0 = cmin[:, q, pos]
        h1 = cmax[:, q - 1, L - 1]
        l1 = cmin[:, q - 1, L - 1]
        st = stati(c, o0, h0, l0, h1, l1)
        vsum += VALORE[st] * PESO[t]
        rsum += ROTT[st]
        if STRAT[t]:
            dsum += DIR[st]
    A = np.zeros((8, 28))
    A[BASE, np.arange(28)] = 1.0
    A[QUOT, np.arange(28)] = -1.0
    num = A @ vsum
    den = 2.0 * PESO.sum() * 7.0
    forza = num / den
    allin = dsum / STRAT.sum()
    rott = rsum / len(LEN)
    diff = (forza[BASE, :] - forza[QUOT, :]) / 2.0
    score = allin * 40.0 + diff * 30.0 + rott * 20.0                  # Sanity = 0 (vedi intestazione)
    return k, score, forza


def eventi_A(score, rearm, persist=1):
    """ev[(pair, s)] = +1 BUY / -1 SELL al passaggio di |round(score)| >= 70, con riarmo sotto 'rearm'."""
    r = mround(score)
    ev = []
    for pr in range(28):
        armato = True
        for s in range(r.shape[1]):
            v = r[pr, s]
            if armato:
                if s >= persist - 1 and np.all(r[pr, s - persist + 1: s + 1] >= 70):
                    ev.append((pr, s, 1)); armato = False
                elif s >= persist - 1 and np.all(r[pr, s - persist + 1: s + 1] <= -70):
                    ev.append((pr, s, -1)); armato = False
            elif abs(v) < rearm:
                armato = True
    return ev


def eventi_B(score, forza):
    """top contro bottom della classifica, solo se il punteggio di quella coppia e' >= 70 nel verso giusto;
    evento = la tripla (coppia, verso) diventa vera e prima non lo era."""
    r = mround(score)
    S = r.shape[1]
    idx = {(b, q): i for i, (b, q) in enumerate(zip(BASE, QUOT))}
    ev = []
    prec = None
    for s in range(S):
        top = int(np.argmax(forza[:, s]))
        bot = int(np.argmin(forza[:, s]))
        cur = None
        if (top, bot) in idx:
            pr, verso = idx[(top, bot)], 1            # top e' la base: BUY
        elif (bot, top) in idx:
            pr, verso = idx[(bot, top)], -1           # top e' la quotata: SELL
        else:
            pr = None
        if pr is not None and r[pr, s] * verso >= 70:
            cur = (pr, verso)
        if cur is not None and cur != prec:
            ev.append((cur[0], s, cur[1]))
        prec = cur
    return ev


def cluster_giorno_valuta(ev, k, finestra=0):
    """componenti connesse: due eventi sono collegati se i loro giorni server distano <= 'finestra' giorni
    (0 = stesso giorno, la regola di casa di EMA200_H4_D1_FOREX28 sez. 6) E le coppie condividono una valuta.
    Per ogni valuta basta collegare gli eventi CONSECUTIVI di quella valuta (stessa connettivita', costo lineare)."""
    n = len(ev)
    padre = list(range(n))

    def trova(a):
        while padre[a] != a:
            padre[a] = padre[padre[a]]
            a = padre[a]
        return a
    ordine = sorted(range(n), key=lambda i: int(k[ev[i][1]]))
    ultimo = {}
    for i in ordine:
        g = int(k[ev[i][1]]) // PTS_GIORNO
        for v in (int(BASE[ev[i][0]]), int(QUOT[ev[i][0]])):
            if v in ultimo and g - ultimo[v][1] <= finestra:
                padre[trova(i)] = trova(ultimo[v][0])
            ultimo[v] = (i, g)
    return len({trova(i) for i in range(n)})


def rendimento_h0(ev, p, k, ore=24):
    """rendimento del verso dell'evento ore dopo, in unita' di sigma giornaliera della coppia: H0 => ~0."""
    pt = ore * 12
    out = []
    for (pr, s, v) in ev:
        j = int(k[s]) + pt
        if j < p.shape[1]:
            out.append(v * (p[pr, j] - p[pr, int(k[s])]) / (SIGMA_GIORNO * math.sqrt(2.0)))
    out = np.array(out)
    return out.mean(), out.std(ddof=1) / math.sqrt(out.size), out.size


def deff_giorno(ev, p, k, ore=24):
    """effetto di disegno sotto H0: DEFF = somma_giorni(S_g^2) / somma_eventi(r^2), con S_g = somma dei rendimenti
    firmati (+ore) degli eventi del giorno g. n_eff = n / DEFF. Se gli eventi fossero indipendenti DEFF ~ 1."""
    pt = ore * 12
    per_giorno = {}
    r2 = 0.0
    n = 0
    for (pr, s, v) in ev:
        j = int(k[s]) + pt
        if j >= p.shape[1]:
            continue
        r = v * (p[pr, j] - p[pr, int(k[s])]) / (SIGMA_GIORNO * math.sqrt(2.0))
        per_giorno[int(k[s]) // PTS_GIORNO] = per_giorno.get(int(k[s]) // PTS_GIORNO, 0.0) + r
        r2 += r * r
        n += 1
    return n, sum(x * x for x in per_giorno.values()) / r2, len(per_giorno)


def per_slot(ev, k, passo):
    """quota degli eventi per fascia del giorno (lettura 1 = chiusura 00:00-04:00 ... 6 = chiusura 20:00-24:00)."""
    per = 24 * 12 // passo
    c = np.zeros(per)
    for (pr, s, v) in ev:
        c[(int(k[s]) // passo) % per] += 1
    return c / c.sum()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--semi", type=int, default=5)
    ap.add_argument("--settimane", type=int, default=104)
    ap.add_argument("--passo", type=int, default=12, help="punti da 5 minuti fra due letture: 12 = ogni H1, 48 = ogni H4")
    ap.add_argument("--persist", type=int, default=1, help="letture consecutive con |punteggio|>=70 per l'evento A")
    a = ap.parse_args()
    tot = {"anni": 0.0, "lett": 0, "ge70": 0, "ge40": 0, "A40": 0, "A70": 0, "B": 0, "clA": 0, "clB": 0, "clA2": 0, "clB2": 0}
    rend = []
    dfA = []
    slotA = []
    dfB = []
    somma_max = 0.0
    maxabs = 0.0
    for sem in range(a.semi):
        rng = np.random.default_rng(20261005 + sem)
        p = simula(rng, a.settimane)
        k, score, forza = letture(p, a.passo)
        somma_max = max(somma_max, float(np.abs(forza.sum(axis=0)).max()))
        maxabs = max(maxabs, float(np.abs(score).max()))
        anni = k.size * a.passo / 12.0 / 24.0 / 260.0                  # letture -> ore -> giorni -> anni (260 gg)
        r = mround(score)
        tot["anni"] += anni
        tot["lett"] += r.size
        tot["ge70"] += int((np.abs(r) >= 70).sum())
        tot["ge40"] += int((np.abs(r) >= 40).sum())
        eA40 = eventi_A(score, 40, a.persist)
        eA70 = eventi_A(score, 70, a.persist)
        eB = eventi_B(score, forza)
        tot["A40"] += len(eA40)
        tot["A70"] += len(eA70)
        tot["B"] += len(eB)
        tot["clA"] += cluster_giorno_valuta(eA40, k)
        tot["clB"] += cluster_giorno_valuta(eB, k)
        tot["clA2"] += cluster_giorno_valuta(eA40, k, 2)
        tot["clB2"] += cluster_giorno_valuta(eB, k, 2)
        slotA.append(per_slot(eA40, k, a.passo))
        rend.append((rendimento_h0(eA40, p, k), rendimento_h0(eB, p, k)))
        dfA.append(deff_giorno(eA40, p, k))
        dfB.append(deff_giorno(eB, p, k))
    y = tot["anni"]
    print("anni simulati (settimane da 5 giorni, 260 gg/anno): %.1f" % y)
    print("controllo identita': max |somma delle 8 forze| = %.2e (atteso ~0)" % somma_max)
    print("massimo |punteggio| visto = %.1f (atteso <= 90: Sanity = 0)" % maxabs)
    print("quota di letture con |round(score)| >= 70: %.3f%%   >= 40: %.3f%%"
          % (100.0 * tot["ge70"] / tot["lett"], 100.0 * tot["ge40"] / tot["lett"]))
    print("A (cross 70, riarmo sotto 40): %.1f eventi/anno su 28 coppie, %.1f cluster giorno-valuta/anno"
          % (tot["A40"] / y, tot["clA"] / y))
    print("A: cluster con finestra di 2 giorni (vita 48h): %.1f /anno" % (tot["clA2"] / y))
    print("A (cross 70, riarmo sotto 70): %.1f eventi/anno" % (tot["A70"] / y))
    print("B (top contro bottom, >=70):   %.1f eventi/anno, %.1f cluster giorno-valuta/anno"
          % (tot["B"] / y, tot["clB"] / y))
    print("A: quota eventi per fascia del giorno (1a = lettura che chiude alle 04:00 server ... ultima = 00:00): "
          + " ".join("%.1f%%" % (100 * x) for x in np.mean(slotA, axis=0)))
    for nome, d in (("A", dfA), ("B", dfB)):
        n = sum(x[0] for x in d)
        ng = sum(x[2] for x in d)
        de = sum(x[1] * x[0] for x in d) / n
        print("%s: effetto di disegno (rendimenti a +24h, H0): DEFF = %.1f -> n_eff = n/DEFF = %.1f%% di n; giorni con eventi %d (n %d)"
              % (nome, de, 100.0 / de, ng, n))
    print("B: cluster con finestra di 2 giorni: %.1f /anno" % (tot["clB2"] / y))
    for i, ((mA, seA, nA), (mB, seB, nB)) in enumerate(rend):
        print("  seme %d: rendimento +24h in sigma-giorno (H0 = 0): A %+0.3f +- %0.3f (n %d) | B %+0.3f +- %0.3f (n %d)"
              % (i, mA, seA, nA, mB, seB, nB))


if __name__ == "__main__":
    main()
