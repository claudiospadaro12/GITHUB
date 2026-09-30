#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mondi_secondo_giudice.py -- i mondi sintetici NUOVI del secondo passaggio del cancello (verificatore stringhe,
30/09/2026) su confronto_tocco_chiusura_m5.py: costruiti da un giudice diverso da chi ha scritto la regola, NON
sono quelli di mondi_controesempio.py. Solo il VERDETTO (giudica_politica, via combina, e lettura_range): il nullo
non decide, quindi non si calcola. 12 semi (8 per l'esplosione), 2600 giorni per cella (~ l'n vero), range 15.
Mondi:
  regime  : stato NASCOSTO per giorno (50% TREND a direzione a sorte con deriva par*s e stoppini corti, 50% CHOP
            richiamato al centro del range con stoppini lunghi). La chiusura fuori ha informazione sul regime:
            B deve risultare MEGLIO quando l'effetto supera la soglia.
  impulso : al primo tocco il prezzo salta di par*ampiezza oltre il livello NELLA barra del tocco e ci chiude,
            poi 3 barre di deriva decrescente, poi random walk. L'informazione e' nel TOCCO e il ritardo costa:
            B NON deve risultare meglio.
  deriva  : random walk con deriva di fondo costante (par*s per barra, sempre al rialzo): LONG e SHORT
            concordi NON devono dare un falso "B MEGLIO" sul range.
  ambiguo : range quieto, poi barre grandi (sigma par) con stoppini lunghi, random walk puro: la convenzione
            "ambigua = stop" potrebbe favorire l'R' piu' largo (B)? Non deve dare "B MEGLIO".
  esplo   : range quieto, poi barre medie, poi ESPLOSIONE di volatilita': idem, caso costruito per rompere.
Uso: python3 backtest_pipeline/collaudo_riga_confronto_tocco/mondi_secondo_giudice.py [mondo ...]   (~1 minuto)
"""
import os
import random
import sys

QD = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.abspath(os.path.join(QD, "..")))
import confronto_tocco_chiusura_m5 as C  # noqa: E402

cfg = C._cfg_test(["--ranges", "15"])
K = cfg.K


def gen(rng, mondo, par):
    s = 3.0
    bars = []
    p = 1000.0

    def barra(o, drift, sig=s, wick=0.5):
        c = o + rng.gauss(drift, sig)
        h = max(o, c) + abs(rng.gauss(0, sig * wick))
        l = min(o, c) - abs(rng.gauss(0, sig * wick))
        return (o, h, l, c, 5)

    if mondo == "ambiguo":
        for _ in range(3):
            b = barra(p, 0.0, 1.0)
            bars.append(b)
            p = b[3]
        while len(bars) < K:
            b = barra(p, 0.0, par, 1.0)
            bars.append(b)
            p = b[3]
        return bars
    if mondo == "esplo":
        lenti, sig_m, sig_b = par
        for _ in range(3):
            b = barra(p, 0.0, 1.0)
            bars.append(b)
            p = b[3]
        for _ in range(lenti):
            b = barra(p, 0.0, sig_m, 0.2)
            bars.append(b)
            p = b[3]
        while len(bars) < K:
            b = barra(p, 0.0, sig_b, 1.5)
            bars.append(b)
            p = b[3]
        return bars
    for _ in range(3):
        b = barra(p, 0.0)
        bars.append(b)
        p = b[3]
    RH = max(b[1] for b in bars)
    RL = min(b[2] for b in bars)
    A = RH - RL
    mid = 0.5 * (RH + RL)
    if mondo == "deriva":
        while len(bars) < K:
            b = barra(p, par * s)
            bars.append(b)
            p = b[3]
        return bars
    if mondo == "regime":
        trend = rng.random() < 0.5
        d = 1 if rng.random() < 0.5 else -1
        while len(bars) < K:
            if trend:
                b = barra(p, d * par * s, s, 0.3)
            else:
                b = barra(p, -0.6 * (p - mid), s * 0.6, 1.6)
            bars.append(b)
            p = b[3]
        return bars
    if mondo == "impulso":
        deciso = False
        drift_left = 0
        dd = 0
        while len(bars) < K:
            if drift_left > 0:
                b = barra(p, dd * 0.3 * s * drift_left / 3.0)
                drift_left -= 1
            else:
                b = barra(p, 0.0)
            if not deciso:
                su, giu = b[1] >= RH, b[2] <= RL
                if su != giu:
                    deciso = True
                    dd = 1 if su else -1
                    lv = RH if su else RL
                    c = lv + dd * par * A + rng.gauss(0, 0.3 * s)
                    o = b[0]
                    h = max(o, c, b[1]) if su else max(o, c)
                    l = min(o, c) if su else min(o, c, b[2])
                    b = (o, h + (abs(rng.gauss(0, 0.5)) if su else 0),
                         l - (0 if su else abs(rng.gauss(0, 0.5))), c, 5)
                    drift_left = 3
            bars.append(b)
            p = b[3]
        return bars
    raise ValueError(mondo)


def cella(mondo, par, giorni, seme):
    rng = random.Random(seme)
    oe = {1: C.CellaE(), -1: C.CellaE()}
    gi = {1: [], -1: []}
    amb = {1: [0, 0, 0, 0], -1: [0, 0, 0, 0]}
    for _ in range(giorni):
        r = C.misura_range(cfg, gen(rng, mondo, par), 15)
        if r["stato"] != "OK":
            continue
        for lato in (1, -1):
            a, b = C._lato_da_rec(r, lato)
            gi[lato].append((a, b))
            if a is not None:
                oe[lato].add_a(a)
                amb[lato][0] += 1
                amb[lato][1] += a["seq"] == "A"
            if b is not None:
                oe[lato].add_b(b)
                amb[lato][2] += 1
                amb[lato][3] += b["seq"] == "A"
    out = {}
    vuoto = {"meccanismo": "-", "pagamento": "-"}
    for lato in (1, -1):
        obsE = C.stat_cella_e(oe[lato], gi[lato])
        out[lato] = (C.combina(vuoto, vuoto, obsE), obsE, amb[lato])
    return out


def corri(mondo, par, semi=12, giorni=2600):
    cont, rng_lett, dRl, dRs, ambs = {}, {}, [], [], []
    for seme in range(1, semi + 1):
        o = cella(mondo, par, giorni, 5000 + seme)
        for lato in (1, -1):
            p = o[lato][0]["pagamento"]
            cont[(lato, p)] = cont.get((lato, p), 0) + 1
            (dRl if lato == 1 else dRs).append((o[lato][1]["dR"], o[lato][1]["dRm"], o[lato][1]["n"]))
            am = o[lato][2]
            ambs.append((100.0 * am[1] / max(am[0], 1), 100.0 * am[3] / max(am[2], 1)))
        lr = C.lettura_range(o[1][0], o[-1][0])
        k = ("PAGA" if lr.startswith("B MEGLIO") else "NON_PAGA" if lr.startswith("B NON")
             else "INCONCL" if lr.startswith("INCONCL") else "NON_GIUD")
        rng_lett[k] = rng_lett.get(k, 0) + 1

    def f(v, i):
        return "%+.3f..%+.3f" % (min(x[i] for x in v), max(x[i] for x in v))
    print("%-8s par=%-14s LONG dR %s dRm %s n~%d | SHORT dR %s dRm %s n~%d" % (
        mondo, par, f(dRl, 0), f(dRl, 1), dRl[0][2], f(dRs, 0), f(dRs, 1), dRs[0][2]))
    print("          celle: %s" % sorted((("L" if l == 1 else "S") + ":" + p, n) for (l, p), n in cont.items()))
    print("          RANGE (LONG e SHORT concordi): %s   ambigue%% A %.1f..%.1f  B %.1f..%.1f" % (
        sorted(rng_lett.items()), min(x[0] for x in ambs), max(x[0] for x in ambs),
        min(x[1] for x in ambs), max(x[1] for x in ambs)))
    sys.stdout.flush()


def main():
    which = sys.argv[1:] or ["regime", "impulso", "deriva", "ambiguo", "esplo"]
    if "regime" in which:
        for par in (0.25, 0.4, 0.6):
            corri("regime", par)
    if "impulso" in which:
        for par in (0.5, 0.2):
            corri("impulso", par)
    if "deriva" in which:
        for par in (0.02, 0.05, 0.1, 0.2, 0.4):
            corri("deriva", par)
    if "ambiguo" in which:
        for par in (4.0, 8.0, 12.0):
            corri("ambiguo", par)
    if "esplo" in which:
        for par in ((3, 2.0, 6.0), (6, 2.0, 8.0), (4, 3.0, 10.0), (8, 1.5, 6.0)):
            corri("esplo", par, semi=8)
    return 0


if __name__ == "__main__":
    sys.exit(main())
