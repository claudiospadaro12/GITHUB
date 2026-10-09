#!/usr/bin/env python3
# MARCATORE_ATR_M1_ORO_PROXY_v1 (09/10/2026, secondo lettore del cancello GBA)
# ATR(14) M1 dell'oro (iATR = media SEMPLICE del true range, come MT5) dal feed HistData in repo, riportato
# sull'orologio server BCM (UTC+1 fisso; prima del 2025 il forex BCM era UTC d'inverno: l'etichetta oraria dei mesi
# invernali 2024 puo' essere spostata di un'ora). PROXY: NON e' il feed BCM. Calibrazione contro BCM: ATR H1 dei setup
# NatCla lotto C (tester BCM) sulle stesse barre. Sola lettura, nessun backtest, nessun MT5.
# Uso: python3 -I backtest_pipeline/atr_m1_oro_proxy.py backtest_pipeline/risultati_prove/oro_m1_histdata_zip \
#        backtest_pipeline/risultati_archivio/NATCLA_F0_C_20261008/csv/natcla_setup_XAUUSD_778601.csv [altri CSV NatCla]
# Spread vivo per ora: data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv (mediana_unita, USD), 04-11/09/2026.
# Proxy: NON e' il feed BCM. Calibrazione contro BCM: ATR H1 della NatCla lotto C (tester BCM) sulle stesse barre.
import sys, zipfile, glob, os, statistics as st, collections, datetime as dt
from zoneinfo import ZoneInfo

ZD = sys.argv[1]
NATCLA = sys.argv[2:]
NY = ZoneInfo("America/New_York")
UTC = dt.timezone.utc

rows = []
for z in sorted(glob.glob(os.path.join(ZD, "*.zip"))):
    zf = zipfile.ZipFile(z)
    n = [x for x in zf.namelist() if x.endswith(".csv")][0]
    for ln in zf.read(n).decode("ascii").splitlines():
        p = ln.split(";")
        t = dt.datetime.strptime(p[0], "%Y%m%d %H%M%S").replace(tzinfo=NY)
        rows.append((int(t.astimezone(UTC).timestamp()) + 3600, float(p[1]), float(p[2]), float(p[3]), float(p[4])))
rows.sort()
ded = []
for r in rows:
    if ded and ded[-1][0] == r[0]:
        continue
    ded.append(r)
rows = ded
print("barre M1", len(rows), dt.datetime.fromtimestamp(rows[0][0], UTC).replace(tzinfo=None), "->", dt.datetime.fromtimestamp(rows[-1][0], UTC).replace(tzinfo=None), "(ora server BCM)")


def atr_series(bars, per=14):
    out = []
    trs = []
    for i, (t, o, h, l, c) in enumerate(bars):
        tr = h - l if i == 0 else max(h - l, abs(h - bars[i - 1][4]), abs(l - bars[i - 1][4]))
        trs.append(tr)
        out.append(sum(trs[-per:]) / per if len(trs) >= per else None)
    return out


def aggrega(bars, sec):
    out = []
    for t, o, h, l, c in bars:
        b = t - t % sec
        if out and out[-1][0] == b:
            x = out[-1]
            out[-1] = (b, x[1], max(x[2], h), min(x[3], l), c)
        else:
            out.append((b, o, h, l, c))
    return out


a1 = atr_series(rows)
# spread vivo BCM per ora server (logger 04-11/09/2026)
SPR = {0: .27, 1: .27, 2: .27, 3: .26, 4: .26, 5: .25, 6: .27, 7: .21, 8: .21, 9: .20, 10: .20, 11: .21, 12: .20, 13: .21,
       14: .21, 15: .18, 16: .18, 17: .20, 18: .20, 19: .21, 20: .20, 21: .22, 23: .27}


def finestra(nome, t0, t1):
    sel = [(rows[i][0], a1[i]) for i in range(len(rows)) if a1[i] is not None and t0 <= rows[i][0] < t1]
    if not sel:
        return
    v = [x for _, x in sel]
    byh = collections.defaultdict(list)
    for t, x in sel:
        byh[(t % 86400) // 3600].append(x)
    giorno = [x for t, x in sel if 7 <= (t % 86400) // 3600 <= 20]
    notte = [x for t, x in sel if (t % 86400) // 3600 in (23, 0, 1, 2, 3, 4, 5, 6)]
    q = lambda a, p: sorted(a)[int(p * (len(a) - 1))]
    print("\n== %s  (%d barre M1)" % (nome, len(v)))
    print("  ATR(14) M1 mediana %.2f  p25 %.2f  p75 %.2f  p90 %.2f" % (st.median(v), q(v, .25), q(v, .75), q(v, .9)))
    print("  giorno h07-20 mediana %.2f (n %d) | notte h23-06 mediana %.2f (n %d)" % (st.median(giorno), len(giorno), st.median(notte), len(notte)))
    pas05 = sum(1 for t, x in sel if ((t % 86400) // 3600) in SPR and SPR[(t % 86400) // 3600] <= 0.05 * x)
    fr40 = sum(1 for t, x in sel if ((t % 86400) // 3600) in SPR and 2.5 * x >= 40 * SPR[(t % 86400) // 3600])
    tot = sum(1 for t, x in sel if ((t % 86400) // 3600) in SPR)
    print("  barre in cui lo spread VIVO dell'ora passa la cella 0,05 (ATR >= 20 S): %.1f%%; stop 2,5 ATR >= 40 S (ATR >= 16 S): %.1f%%" % (100. * pas05 / tot, 100. * fr40 / tot))
    print("  per ora server: " + " ".join("%02d:%.2f" % (h, st.median(byh[h])) for h in sorted(byh)))


ts = lambda s: int(dt.datetime.strptime(s, "%Y-%m-%d").replace(tzinfo=UTC).timestamp())
finestra("ultime ~252 sedute (2025-09-18 -> 2026-09-18)", ts("2025-09-18"), ts("2026-09-19"))
finestra("2026 gen-set", ts("2026-01-01"), ts("2026-09-19"))
finestra("2025", ts("2025-01-01"), ts("2026-01-01"))
finestra("2024", ts("2024-01-01"), ts("2025-01-01"))
finestra("lug-2024 -> giu-2026 (finestra NatCla)", ts("2024-07-10"), ts("2026-07-01"))

# calibrazione H1: HistData contro BCM (NatCla lotto C, tester BCM, atr14 iATR H1 all'ultima barra chiusa)
h1 = aggrega(rows, 3600)
ah = atr_series(h1)
idx = {b[0]: i for i, b in enumerate(h1)}
for f in NATCLA:
    righe = [l.rstrip("\n").split(";") for l in open(f) if not l.startswith("#")]
    hd = righe[0]
    rat = {0: [], -1: []}
    for r in righe[1:]:
        d = dict(zip(hd, r))
        t = int(dt.datetime.strptime(d["barra"], "%Y.%m.%d %H:%M").replace(tzinfo=UTC).timestamp())
        bcm = float(d["atr14"])
        for sh in (0, -1):
            i = idx.get(t + sh * 3600)
            if i is not None and ah[i]:
                rat[sh].append(ah[i] / bcm)
    for sh in (0, -1):
        if rat[sh]:
            v = rat[sh]
            print("calibrazione H1 %s, barra%+d: n %d, ATR HistData / ATR BCM mediana %.3f  p10 %.3f  p90 %.3f  entro +/-10%%: %.0f%%"
                  % (os.path.basename(f), sh, len(v), st.median(v), sorted(v)[len(v) // 10], sorted(v)[9 * len(v) // 10],
                     100. * sum(1 for x in v if 0.9 <= x <= 1.1) / len(v)))

# ---- segnali GBA (canale 48 esclusa la barra di segnale, EMA100 su M1, close stretto) SENZA filtro spread:
# ATR M1 alla barra di segnale, quota che passa 0,05 con lo spread vivo dell'ora, quota sopra i 40x, perdita a SL a 1 lotto
def segnali(t0, t1, nome):
    C = [r[4] for r in rows]
    k = 2.0 / 101.0
    e = None
    em = []
    for c in C:
        e = c if e is None else e + k * (c - e)
        em.append(e)
    from collections import deque
    out = []
    N = 48
    for i in range(N + 1, len(rows)):
        t = rows[i][0]
        if not (t0 <= t < t1) or a1[i] is None:
            continue
        # barra di segnale = i (chiusa), canale = barre i-N..i-1
        hh = max(r[2] for r in rows[i - N:i]); ll = min(r[3] for r in rows[i - N:i])
        c = rows[i][4]
        d = 1 if (c > hh and c > em[i]) else (-1 if (c < ll and c < em[i]) else 0)
        if d:
            out.append((t, a1[i]))
    v = [x for _, x in out]
    hs = lambda t: ((t + 60) % 86400) // 3600   # ora della barra NUOVA in cui si decide
    tot = [(t, x) for t, x in out if hs(t) in SPR]
    p05 = sum(1 for t, x in tot if SPR[hs(t)] <= 0.05 * x)
    p40 = sum(1 for t, x in tot if 2.5 * x >= 40 * SPR[hs(t)])
    giorni = len(set(t // 86400 for t, _ in out))
    q = lambda a, p: sorted(a)[int(p * (len(a) - 1))]
    print("\nSEGNALI GBA (proxy) %s: %d barre di rottura in %d giorni; ATR M1 al segnale mediana %.2f p75 %.2f p90 %.2f"
          % (nome, len(v), giorni, st.median(v), q(v, .75), q(v, .9)))
    print("  passano la cella 0,05 con lo spread vivo: %d (%.1f%%) | stop >= 40x spread: %d (%.1f%%) | perdita a SL a 1,00 lotto: mediana %.0f USD, p90 %.0f USD"
          % (p05, 100. * p05 / len(tot), p40, 100. * p40 / len(tot), 250 * st.median(v), 250 * q(v, .9)))


segnali(ts("2025-09-18"), ts("2026-09-19"), "ultime ~252 sedute")
segnali(ts("2024-07-10"), ts("2026-07-01"), "finestra NatCla lug-2024/giu-2026")
seln = sorted(a1[i] for i in range(len(rows)) if a1[i] is not None and ts("2025-09-18") <= rows[i][0] < ts("2026-09-19"))
import bisect
print("ATR M1 = 4,00 USD sta al percentile %.1f delle barre M1 dell'ultimo anno" % (100. * bisect.bisect_left(seln, 4.0) / len(seln)))
