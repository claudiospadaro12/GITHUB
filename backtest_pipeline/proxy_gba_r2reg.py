#!/usr/bin/env python3
# -*- coding: ascii -*-
# MARCATORE_PROXY_GBA_R2REG_v1 (10/10/2026)
# PROXY GROSSO (NON e' il feed BCM, NON e' il tester) per scrivere le ATTESE di n del lotto R2REG PRIMA dei numeri del tester.
# Simula ABTG_GoldBreakoutATR v1.10 (rottura del canale di 48 barre M1 con close stretto + EMA100, ATR(14) SMA del true range, SL 2,5 ATR,
# trailing 2,5 ATR, breakeven a 1,0 ATR con offset 0, uscita a tempo a 48 barre, UNA posizione per volta) sulle barre M1 HistData in repo
# (backtest_pipeline/risultati_prove/oro_m1_histdata_zip), con lo SPREAD VIVO per ora server del logger di settembre 2026
# (data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv: stessa tabella di atr_m1_oro_proxy.py) APPLICATO A TUTTI I PERIODI [ASSUNZIONE: lo spread BCM
# del 2024-2025 NON e' misurato], uscite a livello di BARRA con l'ordine peggiore (lo stop esistente si controlla PRIMA di aggiornare il trailing).
# Tempo: stesso trattamento di atr_m1_oro_proxy.py (HistData New York -> UTC -> +1 h = server BCM UTC+1 fisso). Prima del cambio d'orologio (fra il
# 26/12/2024 e il 02/02/2025, giorno [NON MISURATO] e per l'ORO [NON MISURATO]) il server forex era UTC+0 d'inverno: le ore dei mesi invernali 2024 sono
# spostate di un'ora (conta solo nella scelta dello spread per ora, quindi poco).
# Limiti: ingresso al primo bid della barra nuova (open HistData) piu' lo spread dell'ora; niente tick, niente slippage; la tabella spread ha 23 ore su 24
# (manca la 22: rollover, nessun ingresso); la commissione e' 0,04 USD/oz a giro.
# USO: python3 -I backtest_pipeline/proxy_gba_r2reg.py            (stampa n e PF-proxy per cella x tranche, 2024-2026)
#      python3 -I backtest_pipeline/proxy_gba_r2reg.py --autotest (contro-esempi su barre finte con risposta nota)
import sys, os, glob, zipfile, datetime as dt, statistics as st
from zoneinfo import ZoneInfo

QD = os.path.dirname(os.path.abspath(__file__))
ZD = os.path.join(QD, "risultati_prove", "oro_m1_histdata_zip")
NY = ZoneInfo("America/New_York")
UTC = dt.timezone.utc
SPR = {0: .27, 1: .27, 2: .27, 3: .26, 4: .26, 5: .25, 6: .27, 7: .21, 8: .21, 9: .20, 10: .20, 11: .21, 12: .20, 13: .21,
       14: .21, 15: .18, 16: .18, 17: .20, 18: .20, 19: .21, 20: .20, 21: .22, 23: .27}
COMM = 0.04
N_CANALE, N_EMA, N_ATR, K_SL, K_TRAIL, K_BE, N_TEMPO = 48, 100, 14, 2.5, 2.5, 1.0, 48
CELLE = {"REPL": 0.05, "C035": 0.35}
# tranche del lotto R2REG (ToDate ESCLUSIVO: l'ultimo giorno eseguito e' il giorno prima di 'a') e, per confronto, le tre di R1A (a = ultimo giorno
# del trimestre nel file madre; qui [da, a+1) per coprire lo stesso periodo del tester, che e' fermo al giorno prima di 'a')
TRANCHE = [("T9", "2024.07.10", "2024.10.01"), ("T8", "2024.10.01", "2025.01.01"), ("T7", "2025.01.01", "2025.04.01"),
           ("T6", "2025.04.01", "2025.07.01"), ("T5", "2025.07.01", "2025.10.01"), ("T4", "2025.10.01", "2026.01.01"),
           ("T3", "2026.01.01", "2026.03.31"), ("T2", "2026.04.01", "2026.06.30"), ("T1", "2026.07.01", "2026.09.19")]


def ts(s):
    return int(dt.datetime.strptime(s, "%Y.%m.%d").replace(tzinfo=UTC).timestamp())


def carica():
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
    return ded


def serie(rows):
    """ATR(14) SMA del true range (come iATR di MT5), EMA(100) sul close, canale 48 precedente (massimo/minimo): liste allineate alle barre."""
    n = len(rows)
    tr = [0.0] * n
    for i in range(n):
        h, l = rows[i][2], rows[i][3]
        tr[i] = (h - l) if i == 0 else max(h - l, abs(h - rows[i - 1][4]), abs(l - rows[i - 1][4]))
    atr = [None] * n
    s = 0.0
    for i in range(n):
        s += tr[i]
        if i >= N_ATR:
            s -= tr[i - N_ATR]
        if i >= N_ATR - 1:
            atr[i] = s / N_ATR
    ema = [0.0] * n
    k = 2.0 / (N_EMA + 1)
    e = None
    for i in range(n):
        c = rows[i][4]
        e = c if e is None else e + k * (c - e)
        ema[i] = e
    return atr, ema


def simula(rows, atr, ema, kmax, t0, t1, spread_tab=SPR):
    """Una cella, una finestra [t0, t1) sul tempo della barra d'INGRESSO. Restituisce la lista dei trade: dict(netto USD/oz, ora, lato, atr, spread, vita)."""
    n = len(rows)
    out = []
    i = N_CANALE + N_ATR + 1
    libero_da = 0   # indice della prima barra su cui si puo' decidere un nuovo ingresso
    segnali = passati = 0
    while i < n - 1:
        j = i + 1                       # barra d'ingresso (nuova); la barra di segnale e' i (chiusa)
        tj = rows[j][0]
        if j < libero_da or tj < t0:
            i += 1
            continue
        if tj >= t1:
            break
        if atr[i] is None:
            i += 1
            continue
        c = rows[i][4]
        hh = max(r[2] for r in rows[i - N_CANALE:i])
        ll = min(r[3] for r in rows[i - N_CANALE:i])
        d = 1 if (c > hh and c > ema[i]) else (-1 if (c < ll and c < ema[i]) else 0)
        if d == 0:
            i += 1
            continue
        segnali += 1
        ora = (tj % 86400) // 3600
        if ora not in spread_tab:
            i += 1
            continue
        spr = spread_tab[ora]
        a = atr[i]
        if not (spr <= kmax * a):
            i += 1
            continue
        passati += 1
        entry = rows[j][1] + (spr if d > 0 else 0.0)
        sl = entry - d * K_SL * a
        ext = rows[j][2] if d > 0 else rows[j][3]
        k = j
        exit_px = None
        kk = j
        while True:
            if k - j >= N_TEMPO:        # uscita a tempo al primo tick della barra j+48: prima del range di quella barra
                exit_px = rows[k][1] if d > 0 else rows[k][1] + spr
                kk = k
                break
            if k >= n:
                exit_px = rows[n - 1][4]
                kk = n - 1
                break
            h, l = rows[k][2], rows[k][3]
            # stop esistente PRIMA di aggiornare il trailing (ordine peggiore)
            if d > 0 and l <= sl:
                exit_px = min(sl, rows[k][1]); kk = k + 1; break
            if d < 0 and h + spr >= sl:
                exit_px = max(sl, rows[k][1] + spr); kk = k + 1; break
            ext = max(ext, h) if d > 0 else min(ext, l)
            ak = atr[k] if atr[k] is not None else a
            cand = ext - K_TRAIL * ak if d > 0 else ext + K_TRAIL * ak
            if (d > 0 and (h - entry) >= K_BE * ak) or (d < 0 and (entry - (l + spr)) >= K_BE * ak):
                cand = max(cand, entry) if d > 0 else min(cand, entry)
            if (d > 0 and cand > sl) or (d < 0 and cand < sl):
                sl = cand
            k += 1
        net = (exit_px - entry) * d - COMM
        out.append({"net": net, "ora": ora, "lato": d, "atr": a, "spread": spr, "vita": kk - j, "t": tj})
        libero_da = kk
        i = max(i + 1, libero_da - 1)
    return out, segnali, passati


def pf(v):
    g = sum(x for x in v if x > 0)
    p = -sum(x for x in v if x < 0)
    return (g / p) if p > 0 else float("inf")


def giorni_feriali(t0, t1):
    d0 = dt.datetime.fromtimestamp(t0, UTC).date()
    d1 = dt.datetime.fromtimestamp(t1, UTC).date()
    n = 0
    while d0 < d1:
        if d0.weekday() < 5:
            n += 1
        d0 += dt.timedelta(days=1)
    return n


def autotest():
    """Contro-esempi con risposta nota. Barre finte: rialzo costante (nessuna rottura stretta del canale dopo l'EMA) e un'impennata isolata."""
    fall = 0
    base = 1700000000 - (1700000000 % 86400) + 10 * 3600   # un giorno qualunque, ora 10 server
    # (a) mercato piatto: nessun segnale, nessun trade
    rows = [(base + 60 * i, 100.0, 100.4, 99.6, 100.0) for i in range(400)]
    atr, ema = serie(rows)
    tr, sg, ps = simula(rows, atr, ema, 0.35, 0, 2 ** 40)
    ok = (len(tr) == 0 and sg == 0)
    print("A piatto: trade %d segnali %d -> %s" % (len(tr), sg, "ok" if ok else "FALLITO")); fall += 0 if ok else 1
    # (b) una rottura al rialzo: dopo 200 barre piatte la barra 200 chiude sopra il canale e sopra l'EMA; poi sale 1 per barra finche' il trailing esce
    rows = [(base + 60 * i, 100.0, 100.4, 99.6, 100.0) for i in range(200)]
    px = 100.0
    for i in range(200, 260):
        px += 1.0
        rows.append((base + 60 * i, px - 1.0, px + 0.1, px - 1.05, px))
    for i in range(260, 400):
        rows.append((base + 60 * i, px, px + 0.2, px - 0.2, px))
    atr, ema = serie(rows)
    tr, sg, ps = simula(rows, atr, ema, 10.0, 0, 2 ** 40)   # filtro spread aperto: l'ingresso c'e'
    ok = (len(tr) >= 1 and tr[0]["lato"] == 1)
    print("B rottura rialzo, spread aperto: trade %d lato %s -> %s" % (len(tr), tr[0]["lato"] if tr else "-", "ok" if ok else "FALLITO")); fall += 0 if ok else 1
    # (c) stessa serie con soglia spread strettissima: ZERO ingressi (il filtro morde)
    tr0, sg0, ps0 = simula(rows, atr, ema, 0.0001, 0, 2 ** 40)
    ok = (len(tr0) == 0 and sg0 >= 1)
    print("C stessa serie, soglia 0,0001: trade %d segnali %d -> %s" % (len(tr0), sg0, "ok" if ok else "FALLITO")); fall += 0 if ok else 1
    # (d) il lato SELL e' simmetrico
    rows2 = [(r[0], 400.0 - r[1], 400.0 - r[3], 400.0 - r[2], 400.0 - r[4]) for r in rows]
    atr2, ema2 = serie(rows2)
    trs, sgs, pss = simula(rows2, atr2, ema2, 10.0, 0, 2 ** 40)
    ok = (len(trs) >= 1 and trs[0]["lato"] == -1)
    print("D specchio: trade %d lato %s -> %s" % (len(trs), trs[0]["lato"] if trs else "-", "ok" if ok else "FALLITO")); fall += 0 if ok else 1
    # (e) finestra [t0,t1) esclusiva: t1 = tempo della barra d'ingresso => nessun ingresso
    tj = tr[0]["t"] if tr else 0
    tr1, _, _ = simula(rows, atr, ema, 10.0, 0, tj)
    tr2, _, _ = simula(rows, atr, ema, 10.0, 0, tj + 1)
    ok = (len(tr1) == 0 and len(tr2) >= 1)
    print("E ToDate esclusivo: con t1 = barra d'ingresso trade %d, con t1+1 trade %d -> %s" % (len(tr1), len(tr2), "ok" if ok else "FALLITO")); fall += 0 if ok else 1
    print("AUTOTEST", "PASS" if fall == 0 else "FALLITO (%d)" % fall)
    return fall


def main():
    if "--autotest" in sys.argv:
        sys.exit(1 if autotest() else 0)
    rows = carica()
    print("barre M1 %d: %s -> %s (ora server BCM, UTC+1 fisso)" % (len(rows), dt.datetime.fromtimestamp(rows[0][0], UTC).replace(tzinfo=None), dt.datetime.fromtimestamp(rows[-1][0], UTC).replace(tzinfo=None)))
    atr, ema = serie(rows)
    print("tranche [da, a): ToDate ESCLUSIVO come il tester (MISURATO in R1A: ultimo evento 29/09 23:59:58 con ToDate 30/09). Le righe T1-T3 usano le stesse date del file madre (a = ultimo giorno + 1).")
    regimi = {"2024 (T9+T8)": ("T9", "T8"), "2025 (T7+T6+T5+T4)": ("T7", "T6", "T5", "T4"), "R2REG tutte e 6": ("T9", "T8", "T7", "T6", "T5", "T4"), "2026 (T3+T2+T1, come R1A)": ("T3", "T2", "T1")}
    for nome_c, kmax in CELLE.items():
        print("\n== cella %s (InpSpreadMaxATR %.2f) ==" % (nome_c, kmax))
        per = {}
        for nome, da, a in TRANCHE:
            t0, t1 = ts(da), ts(a)
            tr, sg, ps = simula(rows, atr, ema, kmax, t0, t1)
            per[nome] = tr
            gf = giorni_feriali(t0, t1)
            v = [x["net"] for x in tr]
            atr_m = st.median([x["atr"] for x in tr]) if tr else float("nan")
            c0 = [K_SL * x["atr"] / x["spread"] for x in tr]
            c1 = [K_SL * x["atr"] / (x["spread"] + COMM) for x in tr]
            c2 = [K_SL * x["atr"] / (x["spread"] + 2 * COMM) for x in tr]
            eq = 0.0; pk = 0.0; dd = 0.0
            for x in tr:
                eq += x["net"] * 100.0
                pk = max(pk, eq); dd = max(dd, pk - eq)
            print("  %s %s -> %s  gf %3d  segnali %5d  passati spread %5d (%.1f%%)  ingressi %4d (%.1f/g)  PF-proxy %.2f  ATR mediano %.2f  costo mediano solo-spread/+0,04/+0,08: %.1f/%.1f/%.1f  netto %.0f USD  DD %.0f USD (1 lotto)" % (
                nome, da, a, gf, sg, ps, 100.0 * ps / max(1, sg), len(tr), len(tr) / float(max(1, gf)), pf(v) if v else float("nan"), atr_m,
                st.median(c0) if c0 else float("nan"), st.median(c1) if c1 else float("nan"), st.median(c2) if c2 else float("nan"), eq, dd))
        for rn, ks in regimi.items():
            allt = [x for k in ks for x in per[k]]
            v = [x["net"] for x in allt]
            print("  >> %-28s n %5d   PF-proxy %.2f" % (rn, len(allt), pf(v) if v else float("nan")))


if __name__ == "__main__":
    main()
