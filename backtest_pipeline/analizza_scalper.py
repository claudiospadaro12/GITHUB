#!/usr/bin/env python3
"""
analizza_scalper.py - legge i CSV di ABTG_ScalperDirezionale (manuale demo 50503635)
e risponde alla domanda di Claudio del 25/09/2026: "perde + che vince. come puoi
analizzare i trade?"

Formati accettati (separatore ';'):
  1.01-1.03  ora_chiusura;simbolo;verso;lotto;ingresso;uscita;secondi;netto;cumulato;motivo
  1.04+      ora_chiusura;simbolo;ondata;verso;lotto;ingresso;uscita;secondi;netto;cumulato;motivo

Uso:
  python3 backtest_pipeline/analizza_scalper.py <csv> [<csv> ...] [--spread 0.22] [--eurusd 1.17]
  python3 backtest_pipeline/analizza_scalper.py --autotest

Stampa: conteggi (vinte/perse/a tempo), per verso, per ondata, movimento medio in
punti contro lo spread, netto ricalcolato A SPREAD ZERO (il contro-esempio: se
anche senza costo perde, il verso non aiuta), e la soglia di pareggio.
Tutti i numeri sono misure sul file; nessuna proposta di taglia.
"""
import sys, csv, math, io, argparse, statistics as st

def leggi(path_or_text, da_testo=False):
    f = io.StringIO(path_or_text) if da_testo else open(path_or_text, encoding="utf-8", errors="replace")
    righe = list(csv.reader(f, delimiter=";"))
    if not da_testo: f.close()
    if not righe: return []
    hdr = [h.strip() for h in righe[0]]
    out = []
    for r in righe[1:]:
        if len(r) < len(hdr): continue
        d = dict(zip(hdr, [x.strip() for x in r]))
        try:
            d["netto"] = float(d["netto"]); d["lotto"] = float(d["lotto"])
            d["ingresso"] = float(d["ingresso"]); d["uscita"] = float(d["uscita"])
            d["secondi"] = int(d["secondi"])
        except (KeyError, ValueError):
            continue
        d.setdefault("ondata", "")
        out.append(d)
    return out

def analizza(trades, spread=None, eurusd=1.17, digits=2):
    if not trades: return "Nessuna riga leggibile."
    pt = 10 ** -digits
    L = []
    n = len(trades)
    vinte = [t for t in trades if t["netto"] > 0]
    perse = [t for t in trades if t["netto"] < 0]
    pari = n - len(vinte) - len(perse)
    tot = sum(t["netto"] for t in trades)
    L.append(f"POSIZIONI: {n}   vinte {len(vinte)} ({100*len(vinte)/n:.0f}%)   perse {len(perse)} ({100*len(perse)/n:.0f}%)   pari {pari}")
    L.append(f"NETTO TOTALE: {tot:+.2f} EUR   medio per posizione {tot/n:+.3f} EUR")
    if vinte: L.append(f"  vincita media {st.mean(t['netto'] for t in vinte):+.3f}   massima {max(t['netto'] for t in vinte):+.2f}")
    if perse: L.append(f"  perdita media {st.mean(t['netto'] for t in perse):+.3f}   peggiore {min(t['netto'] for t in perse):+.2f}")
    # motivi
    mot = {}
    for t in trades:
        m = t["motivo"].split(" (")[0]
        mot.setdefault(m, []).append(t["netto"])
    L.append("PER MOTIVO DI USCITA:")
    for m, v in sorted(mot.items(), key=lambda kv: -len(kv[1])):
        L.append(f"  {m:<22} n={len(v):<4} netto {sum(v):+.2f}   medio {st.mean(v):+.3f}")
    # verso
    L.append("PER VERSO:")
    for vs in ("LONG", "SHORT"):
        v = [t["netto"] for t in trades if t["verso"] == vs]
        if v:
            w = sum(1 for x in v if x > 0)
            L.append(f"  {vs:<6} n={len(v):<4} vinte {w} ({100*w/len(v):.0f}%)   netto {sum(v):+.2f}")
    # movimento in punti nel verso della posizione (uscita - ingresso, segno del verso)
    movs = []
    for t in trades:
        s = 1 if t["verso"] == "LONG" else -1
        movs.append(s * (t["uscita"] - t["ingresso"]) / pt)
    L.append(f"MOVIMENTO A FAVORE (uscita-ingresso, in punti da {pt}): medio {st.mean(movs):+.1f}   mediana {st.median(movs):+.1f}   |medio| {st.mean(abs(m) for m in movs):.1f}")
    secs = [t["secondi"] for t in trades]
    L.append(f"DURATA: media {st.mean(secs):.1f} s   max {max(secs)} s")
    # spread: stimato dal file se non dato: sulle uscite a tempo con movimento ~0 il netto e' circa -spread*lotto*valore
    if spread is None:
        # per una posizione: netto = (mov_pt * pt * contratto/eurusd) * lotto - spread_costo ... senza contratto noto, stimiamo lo spread in PUNTI
        # dal prezzo: per LONG l'ingresso e' ask e l'uscita bid -> il file non ha bid/ask separati; usiamo la mediana del netto delle uscite a tempo con |mov|<=1 pt
        piatte = [t["netto"] / t["lotto"] for t, m in zip(trades, movs) if abs(m) <= 1.0 and t["lotto"] > 0]
        if piatte:
            L.append(f"COSTO STIMATO DAL FILE (posizioni ferme, |mov|<=1 pt): {st.median(piatte):+.2f} EUR per 1 lotto -> {st.median(piatte)/100:+.3f} EUR per 0,01")
    else:
        costo_eur_001 = spread * 100 * 0.01 / eurusd   # spread in $ x 100 oz x lotto / cambio
        L.append(f"SPREAD DICHIARATO {spread:.2f} $ = {costo_eur_001:.3f} EUR per 0,01 lotto (EURUSD {eurusd})")
        costo_tot = sum(costo_eur_001 * t["lotto"] / 0.01 for t in trades)
        L.append(f"  costo totale dello spread sulle {n} posizioni: {costo_tot:.2f} EUR   -> NETTO A SPREAD ZERO: {tot + costo_tot:+.2f} EUR")
        if tot + costo_tot > 0:
            L.append("  => a spread zero VINCE: il verso ha un segno, il problema e' il COSTO (orizzonte troppo corto per lo spread)")
        else:
            L.append("  => anche a spread zero PERDE: il verso NON aiuta su questo campione; allungare il tempo non basta")
        # pareggio: movimento medio a favore necessario = spread in punti
        L.append(f"  pareggio: serve un movimento medio a favore di {spread/pt:.0f} punti; misurato {st.mean(movs):+.1f}")
    # ondate
    ond = {}
    for t in trades:
        if t["ondata"]: ond.setdefault(t["ondata"], []).append(t["netto"])
    if ond:
        vals = [sum(v) for v in ond.values()]
        w = sum(1 for x in vals if x > 0)
        L.append(f"ONDATE: {len(ond)}   in utile {w}   in perdita {len(vals)-w}   netto medio per ondata {st.mean(vals):+.2f}   peggiore {min(vals):+.2f}   migliore {max(vals):+.2f}")
    # equity e drawdown
    eq = 0.0; picco = 0.0; dd = 0.0
    for t in trades:
        eq += t["netto"]; picco = max(picco, eq); dd = min(dd, eq - picco)
    L.append(f"EQUITY FINALE {eq:+.2f}   DRAWDOWN MASSIMO {dd:+.2f} EUR")
    return "\n".join(L)

AUTOTEST = """ora_chiusura;simbolo;ondata;verso;lotto;ingresso;uscita;secondi;netto;cumulato;motivo
2026.09.25 20:30:20;XAUUSD;1;LONG;0.01;4290.00;4290.10;20;-0.10;-0.10;tempo
2026.09.25 20:30:20;XAUUSD;1;LONG;0.01;4290.00;4290.10;20;-0.10;-0.20;tempo
2026.09.25 20:31:00;XAUUSD;2;SHORT;0.01;4290.50;4290.00;15;0.23;0.03;tempo
2026.09.25 20:31:00;XAUUSD;2;SHORT;0.01;4290.50;4293.00;3;-2.05;-2.02;server SL
"""

def autotest():
    tr = leggi(AUTOTEST, da_testo=True)
    assert len(tr) == 4, len(tr)
    out = analizza(tr, spread=0.22, eurusd=1.17)
    assert "POSIZIONI: 4   vinte 1 (25%)   perse 3 (75%)" in out, out
    assert "NETTO TOTALE: -2.02 EUR" in out, out
    assert "ONDATE: 2   in utile 0   in perdita 2" in out, out
    # spread 0.22$ -> 0.188 EUR per 0.01; 4 posizioni -> 0.752; netto a spread zero -1.27 -> "anche a spread zero PERDE"
    assert "anche a spread zero PERDE" in out, out
    # movimento a favore: +10,+10,+50,-250 punti -> medio -45
    assert "medio -45.0" in out, out
    # formato vecchio (senza ondata)
    old = "ora_chiusura;simbolo;verso;lotto;ingresso;uscita;secondi;netto;cumulato;motivo\n2026.09.25 21:20:00;XAUUSD;LONG;0.01;4290.00;4290.40;10;0.15;0.15;tempo\n"
    tr2 = leggi(old, da_testo=True)
    assert len(tr2) == 1 and tr2[0]["ondata"] == ""
    out2 = analizza(tr2)
    assert "ONDATE" not in out2 and "vinte 1 (100%)" in out2, out2
    print("AUTOTEST OK (3 gruppi di asserzioni)")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv", nargs="*")
    ap.add_argument("--spread", type=float, default=None, help="spread in $ (XAUUSD): se dato, calcola il netto a spread zero")
    ap.add_argument("--eurusd", type=float, default=1.17)
    ap.add_argument("--digits", type=int, default=2)
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest: return autotest()
    if not a.csv: ap.error("serve almeno un csv (o --autotest)")
    trades = []
    for p in a.csv:
        t = leggi(p); print(f"{p}: {len(t)} posizioni"); trades += t
    trades.sort(key=lambda t: t["ora_chiusura"])
    print(analizza(trades, spread=a.spread, eurusd=a.eurusd, digits=a.digits))

if __name__ == "__main__":
    main()
