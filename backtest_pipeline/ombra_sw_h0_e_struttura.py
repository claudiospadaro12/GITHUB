#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ombra_sw_h0_e_struttura.py -- PONTEGGIO della specifica report/OMBRA_SUPERWAVE_SPEC_2026-10-05.md.
NON e' una misura di merito: serve a scrivere le ATTESE (H0) e la FREQUENZA prima che l'ombra giri.

Due sottocomandi:
  h0         passeggiata aleatoria + il Supertrend ESATTO della SuperWave v4.1 (st_full del collaudo,
             specchio Python collaudato bit per bit col C++): flip per barra, stop in ATR, e l'esito in R
             di un setup col setup della dashboard (ingresso = chiusura della barra di inversione,
             stop = valore del Supertrend, TP1/2/3 = 1/2/3 R, quote 40/30/30), con tre regole d'uscita:
               A  stop fisso, uscita a mercato al flip opposto (primaria, "regola nostra")
               B  come A, ma dopo TP1 lo stop dei residui va al pareggio
               C  come A, ma lo stop SEGUE il Supertrend (valore della barra chiusa precedente)
             Stop e TP controllati con massimi/minimi della barra, a stessa barra vince lo STOP.
             Nessun costo: e' l'esito LORDO sotto H0. Alternative scritte (classe 178): momentum
             AR(1) +0,05, reversione -0,05, deriva +0,03 sigma/barra.
  struttura  dati STORICI veri (Oanda EURUSD 2019, Oanda XAUUSD 2019, HistData DAX 2017, M1 -> TF
             con barre su UTC+1): SOLO grandezze strutturali (flip per barra, stop in ATR(10),
             stop / costo di casa). NESSUN esito in R sui dati veri: il merito lo misura l'ombra.

Uso:
  python3 backtest_pipeline/ombra_sw_h0_e_struttura.py h0 [N_barre]        (default 600000)
  python3 backtest_pipeline/ombra_sw_h0_e_struttura.py struttura           (scarica ~45 MB da GitHub)
Dipende da numpy. ASCII puro. Semi fissi: stesso comando = stessi numeri.
"""
import csv
import importlib.util
import io
import os
import sys
import urllib.request

import numpy as np

AQUI = os.path.dirname(os.path.abspath(__file__))


def carica_collaudo():
    sp = importlib.util.spec_from_file_location("collaudo_sw", os.path.join(AQUI, "collaudo_superwave_v41.py"))
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


COLL = carica_collaudo()
PER, MULT = 10, 3.5          # default della dashboard: InpAtrPeriod, InpMult1
TRUST = 300                  # SW_TRUST_BARS
FIRST = PER + 1              # 'first' di SW_BarsSinceFlip nella dashboard
PESI = (0.4, 0.3, 0.3)       # InpSize1/2/3 = 40/30/30
RR = (1.0, 2.0, 3.0)         # InpTP1_R/2/3


def st(h, l, c):
    a, u, d, r, v = COLL.st_full(list(h), list(l), list(c), PER, MULT)
    return np.array(a), np.array(r), np.array(v)


# ------------------------------------------------------------------ passeggiata aleatoria
SUB = 12                     # sotto-passi per barra = i "tick" della simulazione


def serie(n, rng, drift=0.0, rho=0.0, sub=SUB):
    """Barre OHLC da un percorso fine (ponte browniano da apertura a chiusura). Chiusura = AR(1) a livello
    di barra (rho) piu' deriva; dentro la barra il ponte e' neutro. Torna (o, h, l, c, path[n, sub])."""
    z = rng.normal(0.0, 1.0, n)
    if rho != 0.0:
        r = np.zeros(n)
        for i in range(1, n):
            r[i] = rho * r[i - 1] + z[i]
        z = r * np.sqrt(1.0 - rho * rho)
    c = 1000.0 + np.cumsum(z + drift)
    o = np.concatenate([[1000.0], c[:-1]])
    t = np.linspace(0.0, 1.0, sub + 1)[1:]
    bb = rng.normal(0.0, 1.0, (n, sub)) / np.sqrt(sub)
    w = np.cumsum(bb, axis=1)
    path = o[:, None] + (c - o)[:, None] * t[None, :] + (w - t * w[:, -1:])
    h = np.maximum(path.max(1), np.maximum(o, c))
    l = np.minimum(path.min(1), np.minimum(o, c))
    return o, h, l, c, path


def esito(variante, d, e, s, risk, nxt, fi, h, l, c, val, path):
    """R del setup (lordo, senza costi) con la regola A, B o C, controllando stop e TP SUI SOTTO-PASSI
    (= tick): lo stop esce al prezzo del sotto-passo (mai meglio di cosi'), il TP esce AL TP (mai meglio).
    L'uscita al flip opposto e' alla chiusura della barra di inversione. Torna (R, tocchi TP, stop colpito)."""
    tp = [e + d * k * risk for k in RR]
    stato = [0, 0, 0]
    pnl = [0.0, 0.0, 0.0]
    sl = s
    tocca = [0, 0, 0]
    for i in range(fi + 1, nxt + 1):
        if variante == "C":
            cand = val[i - 1]
            sl = max(sl, cand) if d > 0 else min(sl, cand)
        # scarto veloce: se la barra non arriva ne' allo stop ne' a un TP aperto, niente sotto-passi
        tocca_sl = (l[i] <= sl) if d > 0 else (h[i] >= sl)
        tocca_tp = any(stato[j] == 0 and ((h[i] >= tp[j]) if d > 0 else (l[i] <= tp[j])) for j in range(3))
        if not (tocca_sl or tocca_tp):
            continue
        fermo = False
        for q in path[i]:
            if (q <= sl) if d > 0 else (q >= sl):
                v = d * (q - e) / risk
                for j in range(3):
                    if stato[j] == 0:
                        stato[j] = 2
                        pnl[j] = v
                fermo = True
                break
            for j in range(3):
                if stato[j] == 0 and ((q >= tp[j]) if d > 0 else (q <= tp[j])):
                    stato[j] = 1
                    pnl[j] = RR[j]
                    tocca[j] = 1
                    if variante == "B" and j == 0:
                        sl = e
        if fermo:
            break
    for j in range(3):
        if stato[j] == 0:
            pnl[j] = d * (c[nxt] - e) / risk
    return sum(PESI[j] * pnl[j] for j in range(3)), tocca, (2 in stato)


def prova_h0(n, seme, drift, rho, etichetta):
    rng = np.random.default_rng(seme)
    o, h, l, c, path = serie(n, rng, drift=drift, rho=rho)
    atr, dr, val = st(h, l, c)
    flips = [i for i in range(FIRST + TRUST, n) if dr[i] != dr[i - 1]]
    ris = {"A": [], "B": [], "C": []}
    lato, stopatr, vita, tc, slc = [], [], [], np.zeros(3), 0
    for k in range(len(flips) - 1):
        fi, nxt = flips[k], flips[k + 1]
        d, e, s = dr[fi], c[fi], val[fi]
        risk = abs(e - s)
        if risk <= 0 or not ((d > 0 and s < e) or (d < 0 and s > e)):
            continue
        for v in "ABC":
            r, t, sl_hit = esito(v, d, e, s, risk, nxt, fi, h, l, c, val, path)
            ris[v].append(r)
            if v == "A":
                tc += np.array(t)
                slc += 1 if sl_hit else 0
        lato.append(d)
        stopatr.append(risk / atr[fi])
        vita.append(nxt - fi)
    a, b, cc, lato = np.array(ris["A"]), np.array(ris["B"]), np.array(ris["C"]), np.array(lato)
    m = len(a)
    print("%-26s flip/barra %.4f n %5d | A %+.4f sd %.3f | B %+.4f sd %.3f | C %+.4f sd %.3f | A long %+.3f short %+.3f"
          % (etichetta, len(flips) / float(n), m, a.mean(), a.std(), b.mean(), b.std(), cc.mean(), cc.std(),
             a[lato > 0].mean(), a[lato < 0].mean()))
    return dict(a=a, stopatr=np.array(stopatr), vita=np.array(vita), tc=tc / m, slc=slc / float(m))


def cmd_h0(n):
    print("H0 su passeggiata aleatoria, %d barre per prova, Supertrend ATR %d x %.1f (st_full del collaudo v4.1)" % (n, PER, MULT))
    print("esito LORDO (nessun costo) in R della dashboard; A = regola primaria; semi fissi\n")
    r0 = prova_h0(n, 1, 0.0, 0.0, "random walk (seme 1)")
    prova_h0(n, 2, 0.0, 0.0, "random walk (seme 2)")
    prova_h0(n, 3, 0.0, 0.05, "AR(1) +0,05 momentum")
    prova_h0(n, 4, 0.0, -0.05, "AR(1) -0,05 reversione")
    prova_h0(n, 5, 0.03, 0.0, "deriva +0,03 sigma/barra")
    a = r0["a"]
    print("\nDescrittori del seme 1 (sono i NUMERI-SPIA che il lettore deve ritrovare sui dati veri):")
    print("  stop in ATR(10): mediana %.2f  p10 %.2f  p90 %.2f" % tuple(np.percentile(r0["stopatr"], [50, 10, 90])))
    print("  vita del setup (barre fino al flip opposto): p10 %d  mediana %d  p90 %d  p99 %d"
          % tuple(np.percentile(r0["vita"], [10, 50, 90, 99])))
    print("  prima del flip: stop colpito %.3f | TP1 %.3f  TP2 %.3f  TP3 %.3f (regola A)"
          % (r0["slc"], r0["tc"][0], r0["tc"][1], r0["tc"][2]))
    print("  R per setup (A): p5 %.2f  mediana %.2f  p95 %.2f  quota negativi %.3f  sd %.3f"
          % (np.percentile(a, 5), np.percentile(a, 50), np.percentile(a, 95), float(np.mean(a < 0)), a.std()))
    sd = a.std()
    print("  banda H0 al 97,5%% su n=150: +/-%.3f R | n=325: +/-%.3f R | n=400: +/-%.3f R | n per semi-ampiezza 0,10: %d"
          % (1.96 * sd / np.sqrt(150), 1.96 * sd / np.sqrt(325), 1.96 * sd / np.sqrt(400), int(np.ceil((1.96 * sd / 0.10) ** 2))))


# ------------------------------------------------------------------ dati veri (solo struttura)
BASE = "https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data"


def scarica(url):
    with urllib.request.urlopen(url, timeout=120) as r:
        return r.read()


def carica(kind):
    T, O, H, L, C = [], [], [], [], []
    if kind in ("EUR", "XAU"):
        p = "EUR_USD" if kind == "EUR" else "XAU_USD"
        for m in range(1, 13):
            raw = scarica("%s/currencies/oanda/%s/2019/oanda-%s-2019-%d.csv" % (BASE, p, p, m)).decode("utf-8", "replace")
            rd = csv.reader(io.StringIO(raw))
            next(rd)
            for r in rd:
                T.append(r[0]); C.append(float(r[1])); H.append(float(r[2])); L.append(float(r[3])); O.append(float(r[4]))
        shift = 3600
    else:
        raw = scarica("%s/stocks/histdata/GRXEUR/DAT_ASCII_GRXEUR_M1_2017.csv" % BASE).decode("utf-8", "replace")
        for ln in raw.splitlines():
            p = ln.split(";")
            if len(p) < 5:
                continue
            T.append(p[0][:4] + "-" + p[0][4:6] + "-" + p[0][6:8] + "T" + p[0][9:11] + ":" + p[0][11:13] + ":" + p[0][13:15])
            O.append(float(p[1])); H.append(float(p[2])); L.append(float(p[3])); C.append(float(p[4]))
        shift = 3600 * 6      # ora di New York -> UTC (+5) -> UTC+1 (+1), come la sonda di casa
    sec = np.array(T, dtype="datetime64[s]").astype("int64") + shift
    idx = np.argsort(sec, kind="stable")
    sec, o, h, l, c = sec[idx], np.array(O)[idx], np.array(H)[idx], np.array(L)[idx], np.array(C)[idx]
    keep = np.concatenate([[True], np.diff(sec) > 0])
    return sec[keep], o[keep], h[keep], l[keep], c[keep]


def ricampiona(sec, o, h, l, c, minuti):
    k = sec // (60 * minuti)
    ch = np.concatenate([[0], np.nonzero(np.diff(k))[0] + 1])
    fine = np.concatenate([ch[1:], [len(k)]])
    return k[ch] * 60 * minuti, o[ch], np.maximum.reduceat(h, ch), np.minimum.reduceat(l, ch), c[fine - 1]


def cmd_struttura():
    # costo di casa per giro: forex all-in 0,86 pip su EURUSD (spread 0,3 + commissione ~0,5, report/CANCELLO_COSTO_FLOTTA
    # correzione 11/09), oro 0,2003 $ (spread 0,16 + commissione 0,0403), DAX 1,7 punti (spread BCM, nessuna commissione)
    gruppi = (("EUR", "EURUSD 2019 (Oanda)", 0.86e-4), ("XAU", "XAUUSD 2019 (Oanda)", 0.2003), ("DAX", "DAX 2017 (HistData)", 1.7))
    print("%-22s %-4s %8s %6s %8s %9s %8s %9s %8s %7s"
          % ("dataset", "TF", "barre", "flip", "flip/bar", "flip/gfer", "R/ATR10", "R/costo", "q>=40x", "latoOK"))
    for kind, etich, costo in gruppi:
        sec, o, h, l, c = carica(kind)
        for minuti, tf in ((1, "M1"), (3, "M3"), (5, "M5"), (15, "M15"), (60, "H1"), (240, "H4")):
            s2, o2, h2, l2, c2 = ricampiona(sec, o, h, l, c, minuti)
            n = len(c2)
            if n < 700:
                continue
            atr, dr, val = st(h2, l2, c2)
            flips = [i for i in range(FIRST + TRUST, n) if dr[i] != dr[i - 1]]
            R = np.array([abs(c2[i] - val[i]) for i in flips])
            ok = np.array([(dr[i] > 0 and val[i] < c2[i]) or (dr[i] < 0 and val[i] > c2[i]) for i in flips])
            rap = R / costo
            giorni = (s2[-1] - s2[0]) / 86400.0 * 5.0 / 7.0
            print("%-22s %-4s %8d %6d %8.4f %9.2f %8.2f %9.1f %8.2f %7.3f"
                  % (etich, tf, n, len(flips), len(flips) / float(n - FIRST - TRUST), len(flips) / giorni,
                     float(np.median(R / atr[flips])), float(np.median(rap)), float((rap >= 40).mean()), float(ok.mean())))


if __name__ == "__main__":
    if len(sys.argv) < 2 or sys.argv[1] not in ("h0", "struttura"):
        print(__doc__)
        sys.exit(2)
    if sys.argv[1] == "h0":
        cmd_h0(int(sys.argv[2]) if len(sys.argv) > 2 else 600000)
    else:
        cmd_struttura()
