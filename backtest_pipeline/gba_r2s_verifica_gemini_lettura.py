#!/usr/bin/env python3
"""BOZZA, NON passata dal cancello -- misure a costo zero per la verifica delle risposte di Gemini
sulla lettura GBA R2S stadio A (12/10/2026). Legge SOLO file del repo, scrive su stdout, non modifica niente.

Fonti: backtest_pipeline/risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip (zip esterno con i
zip interni GBA_R0_R2S*.zip -> log/*.txt, giornali dell'EA in UTF-16) e
backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_<SIM>.csv (spread dai TICK storici BCM,
2024.09.26 -> 2026.06.30, per ora server).

Tre misure:
 (1) SENSIBILITA' del C3G allo spread orario da tick: per ogni riga di segnale, stop/spread_nuovo =
     stop/spread_stampato x spread_stampato / spread_tick(ora). Il set di righe non dipende dallo
     spread (e' il set delle barre di rottura); l'ATR e' lo stesso. NON e' una previsione: e' lo
     spostamento che subirebbe il C3G se lo spread di ogni ora fosse quello mediano (o medio) dei tick
     storici. Verifica: con lo spread stampato la mediana ridà il C3G di D2 (33,90 / 62,00 / ...).
 (2) QUANTO TOGLIE la regola 'una posizione per volta' per fascia: righe >= 50x (passano il filtro
     di spread) contro ingressi, per fascia.
 (3) L'ARGENTO: distribuzione di spread, ATR, rapporto spread/ATR e C3G se lo spread fosse X.
Uso: python3 -I backtest_pipeline/gba_r2s_verifica_gemini_lettura.py
"""
import csv, io, re, statistics, sys, zipfile, collections, os

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZIP = os.path.join(RADICE, "backtest_pipeline/risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip")
SPR = os.path.join(RADICE, "backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_%s.csv")
RX = re.compile(r"\[GBA\] segnale (BUY|SELL)( SALTATO \(([^)]*)\))? \| close ([\d.]+) .*?ATR ([\d.]+) spread ([\d.]+) = ([\d.\-]+)% ATR.*?stop/spread ([\-\d.]+)x \| ora server (\d+)")
FASCE = [("asia", 0, 7), ("europa", 7, 12), ("pausa", 12, 14), ("USA apertura", 14, 17), ("USA pomeriggio", 17, 22), ("rollover", 22, 24)]
CELLE = [("R2SNAS", "NASUSD", "01_M5"), ("R2SNAS", "NASUSD", "02_M15"), ("R2SD30", "D30EUR", "01_M5"), ("R2SD30", "D30EUR", "02_M15"),
         ("R2SU30", "U30USD", "01_M5"), ("R2SU30", "U30USD", "02_M15"), ("R2SXAG", "XAGUSD", "01_REPL")]


def mediana(v):
    v = sorted(v); n = len(v)
    if n == 0: return float("nan")
    return v[n // 2] if n % 2 else (v[n // 2 - 1] + v[n // 2]) / 2


def righe(zesterno, lotto, sigla):
    with zipfile.ZipFile(io.BytesIO(zesterno.read("GBA_%s.zip" % ("R0_" + lotto)))) as zi:
        nome = [n for n in zi.namelist() if n.replace("\\", "/").split("/")[-2:-1] == ["log"] and ("_" + sigla + "_") in n.replace("\\", "/").split("/")[-1].replace("GBA_" + lotto + "_", "_")]
        if not nome: nome = [n for n in zi.namelist() if "log" in n.replace("\\", "/") and sigla in n]
        b = zi.read(nome[0])
    t = b.decode("utf-16") if b[:2] in (b"\xff\xfe", b"\xfe\xff") or "[GBA]" not in b.decode("latin1") else b.decode("utf-8", "replace")
    out = []
    for l in t.splitlines():
        m = RX.search(l)
        if m:
            out.append(dict(lato=m.group(1), motivo=(m.group(3) or "ok"), close=float(m.group(4)), atr=float(m.group(5)),
                            spread=float(m.group(6)), ss=float(m.group(8)), ora=int(m.group(9))))
    return out


def tab(sim, col):
    d = {}
    with open(SPR % sim, newline="") as f:
        for r in csv.DictReader(f):
            if r["ora_server"] != "TUTTO": d[int(r["ora_server"])] = float(r[col])
    return d


def fascia(ora):
    for n, a, b in FASCE:
        if a <= ora < b: return n


def controllo_positivo_oro():
    """(0) CONTROLLO POSITIVO sull'oro: stesse barre a Modello 1 (S0_01) e a tick reali (R1A T1). Il metodo della misura (1)
    (spread orario dei tick al posto dello spread stampato) viene applicato alle righe di S0_01 usando la mediana ORARIA dello spread
    di R1A, e il risultato si confronta con il C3G realmente misurato a tick reali (21,60). Parziale: la mediana oraria e' presa dallo
    stesso R1A (circolare sullo spread orario, NON sulla dispersione dentro l'ora ne' sull'insieme delle righe)."""
    rx = re.compile(r"^(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+\[GBA\] segnale (BUY|SELL)( SALTATO \(([^)]*)\))? \| close ([\d.]+) .*?ATR ([\d.]+) spread ([\d.]+) = ([\d.\-]+)% ATR.*?stop/spread ([\-\d.]+)x \| ora server (\d+)")
    def carica(zp, nome):
        with zipfile.ZipFile(os.path.join(RADICE, "backtest_pipeline/risultati_archivio", zp)) as z:
            b = z.read(nome)
        t = b.decode("utf-16") if "[GBA]" not in b.decode("latin1") else b.decode("utf-8", "replace")
        d = {}
        for l in t.splitlines():
            m = rx.search(l)
            if m: d[m.group(1) + m.group(2)] = dict(sp=float(m.group(7)), ss=float(m.group(9)), h=int(m.group(10)))
        return d
    s0 = carica("GBA_R0_S0_20261010/GBA_R0_S0.zip", "log\\GBA_S0_01_REPL_T1_m775800.txt")
    r1 = carica("GBA_R0_R1A_20261010/GBA_R0_R1A.zip", "log\\GBA_R1A_01_REPL_T1_m775800.txt")
    byh = collections.defaultdict(list)
    for x in r1.values(): byh[x["h"]].append(x["sp"])
    hm = {h: mediana(v) for h, v in byh.items()}
    base0 = mediana([x["ss"] for x in s0.values()]); base1 = mediana([x["ss"] for x in r1.values()])
    pred = mediana([x["ss"] * x["sp"] / hm[x["h"]] for x in s0.values()])
    print("(0) CONTROLLO POSITIVO SULL'ORO (S0_01 Modello 1 contro R1A T1 tick reali; righe %d / %d, in comune %d)" % (len(s0), len(r1), len(set(s0) & set(r1))))
    print("  C3G Modello 1 %.2f, C3G tick reali MISURATO %.2f (%+.1f%%); metodo (spread orario di R1A su righe S0): %.2f (%+.1f%% sul Modello 1; errore sul misurato %+.1f%%)\n" % (
        base0, base1, 100 * (base1 / base0 - 1), pred, 100 * (pred / base0 - 1), 100 * (pred / base1 - 1)))


def main():
    controllo_positivo_oro()
    with zipfile.ZipFile(ZIP) as ze:
        dati = {}
        for lotto, sim, sigla in CELLE:
            dati[(sim, sigla)] = righe(ze, lotto, sigla)
    print("(1) SENSIBILITA' DEL C3G ALLO SPREAD ORARIO DA TICK (non e' una previsione)")
    for (sim, sigla), rr in dati.items():
        if sim == "XAGUSD": continue
        base = mediana([r["ss"] for r in rr])
        for col in ("mediana_idx", "media_idx"):
            t = tab(sim, col)
            nuovo = mediana([r["ss"] * r["spread"] / t[r["ora"]] for r in rr])
            print("  %-7s %-7s righe %4d  C3G stampato %6.2f  C3G con spread tick-%s %6.2f  (%+.1f%%)  righe>=50x: %d -> %d" % (
                sim, sigla, len(rr), base, col.split("_")[0], nuovo, 100 * (nuovo / base - 1),
                sum(r["ss"] >= 50 for r in rr), sum(r["ss"] * r["spread"] / t[r["ora"]] >= 50 for r in rr)))
    print("  spread M1 (mediana per fascia, dalle righe) contro spread tick (mediana oraria media pesata dalle ore della fascia):")
    for (sim, sigla), rr in dati.items():
        if sim == "XAGUSD" or not sigla.endswith("M15"): continue
        t = tab(sim, "mediana_idx")
        for n, a, b in FASCE:
            sp = [r["spread"] for r in rr if a <= r["ora"] < b]
            if sp: print("    %-7s %-14s righe %3d  spread M1 mediana %.2f   tick: ore %d-%d mediane %s" % (sim, n, len(sp), mediana(sp), a, b - 1, " ".join("%.1f" % t[h] for h in range(a, b))))
    print("\n(2) UNA POSIZIONE PER VOLTA: righe che passano il filtro (stop/spread >= 50x) contro ingressi, per fascia")
    for (sim, sigla), rr in dati.items():
        if sim == "XAGUSD": continue
        print("  %s %s" % (sim, sigla))
        tot50 = sum(r["ss"] >= 50 for r in rr); toting = sum(r["motivo"] == "ok" for r in rr)
        for n, a, b in FASCE:
            f = [r for r in rr if a <= r["ora"] < b]
            p50 = sum(r["ss"] >= 50 for r in f)
            # ingressi = righe senza 'SALTATO' (motivo ok); le righe 'posizione' non hanno spread valutato
            ing = sum(r["motivo"] == "ok" for r in f)
            pos = sum(r["motivo"].startswith("posizione") for r in f)
            print("    %-14s righe %4d  >=50x %4d (%4.1f%% dei >=50x)  ingressi %3d (%4.1f%% degli ingressi)  righe 'posizione gia aperta' %3d" % (
                n, len(f), p50, 100 * p50 / max(tot50, 1), ing, 100 * ing / max(toting, 1), pos))
    print("\n(3) ARGENTO M1")
    rr = dati[("XAGUSD", "01_REPL")]
    sp = collections.Counter(r["spread"] for r in rr)
    atr = [r["atr"] for r in rr]
    print("  righe %d, spread valori %s" % (len(rr), sorted(sp.items())))
    print("  ATR M1 mediana %.2f (min %.2f max %.2f); close mediana %.2f" % (mediana(atr), min(atr), max(atr), mediana([r["close"] for r in rr])))
    print("  righe con spread <= 5%% x ATR (stampati): %d; con stop/spread >= 40x: %d" % (sum(r["spread"] <= 0.05 * r["atr"] for r in rr), sum(r["ss"] >= 40 for r in rr)))
    c3g = mediana([r["ss"] for r in rr]); msp = mediana([r["spread"] for r in rr])
    print("  C3G stampato %.2f, spread mediano %.3f" % (c3g, msp))
    for x in (0.04, 0.03, 0.02, 0.015, 0.01):
        nuovo = mediana([r["ss"] * r["spread"] / x for r in rr])
        print("    se lo spread fosse %.3f in ogni riga: C3G %.2f, righe >= 40x %d, >= 13,3x %d" % (x, nuovo, sum(r["ss"] * r["spread"] / x >= 40 for r in rr), sum(r["ss"] * r["spread"] / x >= 13.3 for r in rr)))
    print("  NOTA: ATR e spread stampati a 2 decimali (stop/spread e' calcolato dall'EA in doppia precisione): per le righe dell'argento questa e' la risoluzione del campo di partenza")


if __name__ == "__main__":
    main()
