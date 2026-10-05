#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regime_dax_misure_2026-10-05.py  --  MISURE SUL FEED DAX HistData (GRXEUR 2010-2018)
per la specifica report/REGIME_DAX_SPEC_2026-10-05.md.

SOLA LETTURA, ZERO TESTER, NESSUN TRADING: legge 9 CSV M1 e stampa quattro cose.
  (1) ORACOLO DELL'OROLOGIO: la prima barra di ogni giorno cade dove la regola
      "ora di New York con DST, ancorata alle 08:00 CET" la prevede? Confronto contro
      due ipotesi alternative (NY fissa UTC-5; "sempre 02:00", cioe' nessun DST).
  (2) FINESTRE di regime: rendimento e max drawdown sulle chiusure H1 del feed.
  (3) GEOMETRIA d'apertura: range dei primi 15 e 35 minuti di cash (09:00 CET) per finestra,
      in punti e in % del prezzo.
  (4) IGIENE per finestra: feriali senza barre, giorni corti, buchi > 60 minuti nel giorno,
      feriali d'inverno UE, feriali "sfasati" USA/UE.

Dati: un mirror pubblico di HistData raggiungibile dal cloud
  https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/stocks/histdata/GRXEUR/DAT_ASCII_GRXEUR_M1_<anno>.csv
Il mirror ha lo stesso numero di righe per anno del CSV D30EUR_M1.csv gia' convertito
(1.718.805 barre in tutto, verificato il 05/10/2026): le stesse prime e ultime righe.
Un hash del CSV vero NON esiste in repo: l'identita' e' di CONTEGGI ed ESTREMI, non di byte.

Uso:
  python3 regime_dax_misure_2026-10-05.py --scarica DIR     # scarica i 9 anni con curl (se non ci sono)
  python3 regime_dax_misure_2026-10-05.py DIR               # calcola e stampa
  python3 regime_dax_misure_2026-10-05.py --autotest        # controlli sintetici, senza rete

Le finestre di regime sono quelle dichiarate nella specifica (W1..W6): qui stanno SOLO per
calcolare l'indice; nessun risultato di strategia entra mai in questo file.
"""
import sys, os, subprocess, datetime as dt, collections, statistics as st, math

URL = ("https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/"
       "data/stocks/histdata/GRXEUR/DAT_ASCII_GRXEUR_M1_%d.csv")
ANNI = list(range(2010, 2019))
# righe attese per anno (colonna "barre" del referto DIAGNOSI_DAX_20260910_SOGLIA41)
ATTESE = {2010: 26866, 2011: 213706, 2012: 211671, 2013: 210927, 2014: 209954,
          2015: 211996, 2016: 213764, 2017: 206648, 2018: 213273}

# (sigla, da, a, etichetta attesa)
FINESTRE = [
    ("W1", "2011.05.01", "2012.04.30", "ORSO"),
    ("W2", "2015.04.01", "2016.03.31", "ORSO"),
    ("W3", "2018.01.01", "2018.12.14", "ORSO"),
    ("W4", "2013.01.01", "2013.12.31", "TORO"),
    ("W5", "2016.07.01", "2017.06.30", "TORO"),
    ("W6", "2014.01.01", "2014.12.31", "LATERALE"),
]


def _d(s):
    return dt.date(*map(int, s.split(".")))


def nth_sunday(y, m, n):
    d = dt.date(y, m, 1)
    d += dt.timedelta(days=(6 - d.weekday()) % 7)
    return d + dt.timedelta(weeks=n - 1)


def last_sunday(y, m):
    d = dt.date(y, m, 31) if m in (1, 3, 5, 7, 8, 10, 12) else dt.date(y, m, 30)
    return d - dt.timedelta(days=(d.weekday() + 1) % 7)


def us_dst(d):
    return nth_sunday(d.year, 3, 2) <= d < nth_sunday(d.year, 11, 1)


def eu_dst(d):
    return last_sunday(d.year, 3) <= d < last_sunday(d.year, 10)


def prima_barra_attesa_min(d):
    """minuto del giorno (ora NY del file) in cui la regola prevede la PRIMA barra:
    08:00 CET = 02:00 NY se USA e UE hanno lo stesso regime; 03:00 NY se gli USA sono
    gia' in ora legale e la UE no (circa 3 settimane in marzo e 1 in ottobre-novembre)."""
    return (3 if (us_dst(d) and not eu_dst(d)) else 2) * 60


def carica(dirpath):
    righe = []
    for y in ANNI:
        p = os.path.join(dirpath, "GRXEUR_%d.csv" % y)
        n = 0
        with open(p, "r") as f:
            for line in f:
                q = line.strip().split(";")
                if len(q) < 5:
                    continue
                t = dt.datetime.strptime(q[0], "%Y%m%d %H%M%S")
                righe.append((t, float(q[1]), float(q[2]), float(q[3]), float(q[4])))
                n += 1
        if n != ATTESE[y]:
            print("ATTENZIONE: %d ha %d righe, il referto ne dichiara %d" % (y, n, ATTESE[y]))
    nonmon = sum(1 for i in range(1, len(righe)) if righe[i][0] <= righe[i - 1][0])
    return righe, nonmon


def oracolo(righe):
    byday = collections.defaultdict(list)
    for r in righe:
        byday[r[0].date()].append(r[0])
    tot = okA = okEST = okFLAT = 0
    sf_tot = sf_A = sf_FLAT = 0
    fuori = []
    for d, ts in sorted(byday.items()):
        if len(ts) < 300:
            continue
        tot += 1
        f = min(ts)
        m = f.hour * 60 + f.minute
        exp = prima_barra_attesa_min(d)
        a = exp <= m <= exp + 4
        okA += a
        if not a:
            fuori.append((d, f.strftime("%H:%M")))
        expE = (1 if eu_dst(d) else 2) * 60
        okEST += (expE <= m <= expE + 4)
        okFLAT += (120 <= m <= 124)
        if us_dst(d) and not eu_dst(d):
            sf_tot += 1
            sf_A += a
            sf_FLAT += (120 <= m <= 124)
    return dict(tot=tot, A=okA, EST=okEST, FLAT=okFLAT, sf_tot=sf_tot, sf_A=sf_A, sf_FLAT=sf_FLAT, fuori=fuori)


def h1_chiusure(righe):
    h1 = collections.OrderedDict()
    for t, o, h, l, c in righe:
        h1[t.replace(minute=0, second=0)] = c
    return list(h1.keys()), list(h1.values())


def etichetta(ret, dd, mesi):
    """regola proposta: finestre lunghe (>= 9 mesi): TORO / ORSO / LATERALE / MISTO;
    finestre corte (<= 4 mesi): CROLLO se dd >= 25, altrimenti MISTO."""
    if mesi >= 9:
        if ret >= 10 and dd < 15:
            return "TORO"
        if ret <= -5 and dd >= 15:
            return "ORSO"
        if abs(ret) <= 5:
            return "LATERALE"
        return "MISTO"
    if mesi <= 4:
        return "CROLLO" if dd >= 25 else "MISTO"
    return "MISTO"


def stat_finestra(ts, cl, a, b):
    A = dt.datetime.combine(_d(a), dt.time(0, 0))
    B = dt.datetime.combine(_d(b), dt.time(0, 0)) + dt.timedelta(days=1)
    idx = [i for i, t in enumerate(ts) if A <= t < B]
    s = [cl[i] for i in idx]
    ret = (s[-1] / s[0] - 1) * 100
    picco = s[0]
    pk = 0
    mdd = 0.0
    pki = tri = 0
    for i, x in enumerate(s):
        if x > picco:
            picco = x
            pk = i
        dd = (picco - x) / picco * 100
        if dd > mdd:
            mdd, pki, tri = dd, pk, i
    giorni = len({ts[i].date() for i in idx})
    return dict(ret=ret, dd=mdd, giorni=giorni, p0=s[0], p1=s[-1],
                picco=(ts[idx[pki]].date(), s[pki]), fondo=(ts[idx[tri]].date(), s[tri]))


def geometria(righe, a, b):
    byday = collections.defaultdict(dict)
    for t, o, h, l, c in righe:
        byday[t.date()][t] = (o, h, l, c)
    A, B = _d(a), _d(b)
    r15, r35, px = [], [], []
    for d, bars in sorted(byday.items()):
        if not (A <= d <= B) or d.weekday() >= 5 or len(bars) < 300:
            continue
        hh = 4 if (us_dst(d) and not eu_dst(d)) else 3      # 09:00 CET nell'ora NY del file
        t0 = dt.datetime(d.year, d.month, d.day, hh, 0)
        if t0 not in bars:
            continue

        def rng(m):
            hs, ls = [], []
            for k in range(m):
                b_ = bars.get(t0 + dt.timedelta(minutes=k))
                if b_:
                    hs.append(b_[1])
                    ls.append(b_[2])
            return (max(hs) - min(ls)) if len(hs) >= 0.8 * m else None
        x15, x35 = rng(15), rng(35)
        if x35 is None:
            continue
        px.append(bars[t0][0])
        r35.append(x35)
        if x15 is not None:
            r15.append(x15)
    p = st.median(px)
    return dict(n=len(r35), prezzo=p, r15=st.median(r15), r35=st.median(r35),
                p10=sorted(r35)[int(0.1 * (len(r35) - 1))], p90=sorted(r35)[int(0.9 * (len(r35) - 1))])


def igiene(righe, a, b):
    byday = collections.defaultdict(list)
    for r in righe:
        byday[r[0].date()].append(r[0])
    A, B = _d(a), _d(b)
    wd = [A + dt.timedelta(days=i) for i in range((B - A).days + 1)]
    wd = [d for d in wd if d.weekday() < 5]
    vuoti = [d for d in wd if d not in byday]
    corti = [d for d in wd if d in byday and len(byday[d]) < 300]
    gap = 0
    for d in wd:
        t = sorted(byday.get(d, []))
        for i in range(1, len(t)):
            if (t[i] - t[i - 1]).total_seconds() > 3600:
                gap += 1
    inv = sum(1 for d in wd if not eu_dst(d))
    sf = sum(1 for d in wd if us_dst(d) and not eu_dst(d))
    return dict(fer=len(wd), vuoti=len(vuoti), corti=len(corti), gap=gap, inv=inv, sfasati=sf)


def autotest():
    ok = True
    # le tre classi di calendario nel 2013 (US DST 10/03, UE DST 31/03; UE fine 27/10, US fine 03/11)
    assert not us_dst(dt.date(2013, 3, 9)) and us_dst(dt.date(2013, 3, 11))
    assert not eu_dst(dt.date(2013, 3, 30)) and eu_dst(dt.date(2013, 3, 31))
    assert eu_dst(dt.date(2013, 10, 26)) and not eu_dst(dt.date(2013, 10, 27))
    assert us_dst(dt.date(2013, 10, 29)) and not us_dst(dt.date(2013, 11, 4))
    # prima barra attesa: 02:00 in estate e inverno allineati, 03:00 nelle settimane sfasate
    assert prima_barra_attesa_min(dt.date(2013, 7, 10)) == 120
    assert prima_barra_attesa_min(dt.date(2013, 1, 10)) == 120
    assert prima_barra_attesa_min(dt.date(2013, 3, 20)) == 180
    assert prima_barra_attesa_min(dt.date(2013, 10, 30)) == 180
    # CONTRO-ESEMPIO: un feed sintetico "sempre 02:00" (nessun DST) NON deve superare l'oracolo
    # sui giorni sfasati; un feed sintetico con DST corretto li deve superare tutti.
    righe_flat, righe_ok = [], []
    d = dt.date(2013, 3, 1)
    while d <= dt.date(2013, 4, 15):
        if d.weekday() < 5:
            for k in range(400):
                t = dt.datetime(d.year, d.month, d.day, 2, 0) + dt.timedelta(minutes=k)
                righe_flat.append((t, 1, 1, 1, 1))
                h0 = prima_barra_attesa_min(d)
                t2 = dt.datetime(d.year, d.month, d.day, h0 // 60, 0) + dt.timedelta(minutes=k)
                righe_ok.append((t2, 1, 1, 1, 1))
        d += dt.timedelta(days=1)
    o_flat, o_ok = oracolo(righe_flat), oracolo(righe_ok)
    assert o_ok["sf_tot"] > 0 and o_ok["sf_A"] == o_ok["sf_tot"], o_ok
    assert o_flat["sf_tot"] > 0 and o_flat["sf_A"] == 0, o_flat
    # etichette: i casi limite della regola
    assert etichetta(+23.6, 9.8, 12) == "TORO"
    assert etichetta(-10.6, 34.3, 12) == "ORSO"
    assert etichetta(+1.8, 16.3, 12) == "LATERALE"
    assert etichetta(-1.9, 34.3, 12) == "LATERALE"        # |ret| <= 5: la regola dice LATERALE anche con DD 34
    assert etichetta(+12.0, 20.0, 12) == "MISTO"           # ne' TORO (DD >= 15) ne' ORSO ne' LATERALE
    assert etichetta(-26.6, 33.6, 3) == "CROLLO"
    assert etichetta(-4.2, 19.6, 3) == "MISTO"
    print("AUTOTEST OK (oracolo: feed 'senza DST' bocciato sui giorni sfasati %d/%d, feed con DST passa %d/%d)"
          % (o_flat["sf_A"], o_flat["sf_tot"], o_ok["sf_A"], o_ok["sf_tot"]))
    return ok


def main():
    if "--autotest" in sys.argv:
        autotest()
        return
    if len(sys.argv) >= 3 and sys.argv[1] == "--scarica":
        os.makedirs(sys.argv[2], exist_ok=True)
        for y in ANNI:
            p = os.path.join(sys.argv[2], "GRXEUR_%d.csv" % y)
            if not os.path.exists(p):
                subprocess.check_call(["curl", "-sS", "-m", "300", "-o", p, URL % y])
        print("scaricati")
        return
    dirp = sys.argv[1]
    righe, nonmon = carica(dirp)
    print("righe: %d  (%s -> %s)  non monotone: %d" % (len(righe), righe[0][0], righe[-1][0], nonmon))
    o = oracolo(righe)
    print("\n=== (1) ORACOLO DELL'OROLOGIO sulle giornate con >= 300 barre: %d ===" % o["tot"])
    print("H_A    (ora NY con DST, 08:00 CET)        : %d  (%.2f%%)" % (o["A"], 100.0 * o["A"] / o["tot"]))
    print("H_EST  (ora NY fissa UTC-5, nessun DST)   : %d  (%.2f%%)" % (o["EST"], 100.0 * o["EST"] / o["tot"]))
    print("H_FLAT (sempre 02:00, nessun DST)         : %d  (%.2f%%)" % (o["FLAT"], 100.0 * o["FLAT"] / o["tot"]))
    print("giorni SFASATI (USA in ora legale, UE no) : %d | H_A %d | H_FLAT %d" % (o["sf_tot"], o["sf_A"], o["sf_FLAT"]))
    print("giorni fuori da H_A (%d): %s" % (len(o["fuori"]), ", ".join("%s %s" % (d, h) for d, h in o["fuori"])))
    ts, cl = h1_chiusure(righe)
    print("\n=== (2) FINESTRE sulle chiusure H1 del feed ===")
    for sig, a, b, att in FINESTRE:
        s = stat_finestra(ts, cl, a, b)
        mesi = round(((_d(b) - _d(a)).days + 1) / 30.4)
        print("%s %s..%s giorni %3d  %9.2f -> %9.2f  rend %+6.1f%%  maxDD %5.1f%% (picco %s %.0f -> fondo %s %.0f)  mesi %d  etichetta %s (attesa %s)"
              % (sig, a, b, s["giorni"], s["p0"], s["p1"], s["ret"], s["dd"], s["picco"][0], s["picco"][1],
                 s["fondo"][0], s["fondo"][1], mesi, etichetta(s["ret"], s["dd"], mesi), att))
    s = stat_finestra(ts, cl, "2011.07.01", "2011.09.30")
    print("sotto-finestra 2011.07.01..2011.09.30 (DENTRO W1, classe 1102): rend %+.1f%% maxDD %.1f%% (picco %s -> fondo %s) etichetta %s"
          % (s["ret"], s["dd"], s["picco"][0], s["fondo"][0], etichetta(s["ret"], s["dd"], 3)))
    print("\n=== (3) GEOMETRIA d'apertura (09:00 CET) ===")
    for sig, a, b, att in FINESTRE:
        g = geometria(righe, a, b)
        print("%s n=%3d prezzo_med %6.0f | R15 med %5.1f (%.3f%%) | R35 med %5.1f (%.3f%%) p10 %5.1f p90 %6.1f | stop~R35+3 %5.1f | 40x -> spread max %.2f idx (%.2f bp)"
              % (sig, g["n"], g["prezzo"], g["r15"], g["r15"] / g["prezzo"] * 100, g["r35"], g["r35"] / g["prezzo"] * 100,
                 g["p10"], g["p90"], g["r35"] + 3, (g["r35"] + 3) / 40, (g["r35"] + 3) / 40 / g["prezzo"] * 1e4))
    print("riferimento BCM: R15 mediano 54,65 idx (n=440) su ~24.500 = %.3f%%; spread mediano ora 8 1,70 idx = %.2f bp"
          % (54.65 / 24500 * 100, 1.70 / 24500 * 1e4))
    print("\n=== (4) IGIENE per finestra ===")
    for sig, a, b, att in FINESTRE:
        g = igiene(righe, a, b)
        print("%s feriali %d, senza barre %d, <300 barre %d, buchi>60min %d, feriali d'inverno UE %d (%.0f%%), feriali sfasati %d"
              % (sig, g["fer"], g["vuoti"], g["corti"], g["gap"], g["inv"], 100.0 * g["inv"] / g["fer"], g["sfasati"]))


if __name__ == "__main__":
    main()
