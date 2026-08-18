#!/usr/bin/env python3
# =====================================================================
#  sovrapposizione_sedie.py -- MISSIONE M2 (riga C1 del PIANO_PROP)
# ---------------------------------------------------------------------
#  Misura la sovrapposizione REALE delle sedie: quante posizioni sono
#  aperte NELLO STESSO momento e quanto rischio aperto fa la somma,
#  giorno per giorno. Criteri congelati PRIMA dei numeri in
#  backtest_pipeline/prove/M2_SOVRAPPOSIZIONE_CRITERI.md.
#
#  Dati: data/statements/trades_auto.csv (forward conto piccolo,
#  open_time+close_time per posizione). magic=0 (manuale) ESCLUSO.
#  Rischio aperto a taglia prop: 0,65% per unita' (A1 congelato), in
#  due letture: per-POSIZIONE (primaria, conservativa) e per-SEDIA.
#  Limite dichiarato: rischio all'ingresso tenuto vivo per tutta la
#  durata = limite SUPERIORE (parziali/BE non osservabili dal CSV).
#
#  Uso:
#    python3 sovrapposizione_sedie.py ../data/statements/trades_auto.csv
#    (opzioni: --rischio 0.65 --da 2026.08.01 --a 2026.08.31)
#
#  Sweep-line sugli eventi di apertura/chiusura; il massimo giornaliero
#  cade per costruzione su un istante-evento. Sola lettura.
# =====================================================================
import sys, csv, argparse
from collections import defaultdict
from datetime import datetime

FMT = "%Y.%m.%d %H:%M:%S"


def leggi_posizioni(path):
    """-> (lista di dict (pid, magic, strategy, symbol, open, close),
    n. righe a durata nulla scartate).
    Con la definizione congelata open<=t<close una posizione con
    close==open non e' aperta in NESSUN istante: si scarta (e si
    dichiara), altrimenti nello sweep l'apertura verrebbe processata
    dopo la sua stessa chiusura e resterebbe 'aperta' per sempre."""
    pos, durata_nulla = [], 0
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        rd = csv.DictReader(f, delimiter=";")
        for r in rd:
            if r.get("magic", "0").strip() in ("", "0"):
                continue  # manuale: fuori dalla misura sedie (dichiarato)
            try:
                o = datetime.strptime(r["open_time"].strip(), FMT)
                c = datetime.strptime(r["close_time"].strip(), FMT)
            except (ValueError, KeyError):
                continue
            if c <= o:
                durata_nulla += 1
                continue
            pos.append({
                "pid": r["pid"], "magic": r["magic"].strip(),
                "strategy": (r.get("strategy") or "").strip(),
                "symbol": r.get("symbol", ""), "open": o, "close": c,
            })
    return pos, durata_nulla


def percentile(valori, q):
    """percentile per interpolazione lineare su lista ordinata."""
    if not valori:
        return float("nan")
    v = sorted(valori)
    k = (len(v) - 1) * q / 100.0
    i = int(k)
    if i + 1 >= len(v):
        return v[-1]
    return v[i] + (v[i + 1] - v[i]) * (k - i)


def sweep(pos, w0=None, w1=None):
    """Sweep-line: per ogni giorno il massimo di posizioni/sedie aperte
    e l'istante in cui accade; piu' i minuti di sovrapposizione per
    coppia di sedie e il picco assoluto con la sua composizione.
    w0/w1 (datetime opzionali) = finestra: si registrano solo giorni e
    minuti dentro la finestra (le posizioni a cavallo contano comunque).
    Oltre agli eventi veri si CAMPIONA ogni mezzanotte: cosi' un giorno
    in cui nessuna posizione apre ma qualcuna resta aperta ha comunque
    il suo massimo giornaliero."""
    from datetime import timedelta
    eventi = []  # (tempo, tipo, indice)  tipo: 0=chiusura, 1=apertura
    for i, p in enumerate(pos):
        eventi.append((p["open"], 1, i))
        eventi.append((p["close"], 0, i))
    # campioni di mezzanotte (tipo 0.5: dopo le chiusure, prima delle
    # aperture dello stesso istante)
    t0 = min(p["open"] for p in pos).replace(hour=0, minute=0, second=0)
    t1 = max(p["close"] for p in pos)
    t = t0 + timedelta(days=1)
    while t <= t1:
        eventi.append((t, 0.5, -1))
        t += timedelta(days=1)
    # a parita' di istante prima le CHIUSURE (open<=t<close: a t della
    # chiusura la posizione non e' piu' aperta)
    eventi.sort(key=lambda e: (e[0], e[1]))

    def in_finestra(t):
        return (w0 is None or t >= w0) and (w1 is None or t < w1)

    aperte = set()           # indici posizioni aperte
    max_giorno = {}          # giorno -> dict(npos, nsedie, quando, sedie)
    picco = {"npos": 0}      # picco assoluto per-posizione
    minuti_coppia = defaultdict(float)   # (magicA, magicB) -> minuti
    ultimo_t = None

    def registra(t):
        if not aperte or not in_finestra(t):
            return
        npos = len(aperte)
        sedie = sorted({pos[i]["magic"] for i in aperte})
        g = t.strftime("%Y.%m.%d")
        cur = max_giorno.get(g)
        if cur is None or npos > cur["npos"] or (
                npos == cur["npos"] and len(sedie) > cur["nsedie"]):
            max_giorno[g] = {"npos": npos, "nsedie": len(sedie),
                             "quando": t, "sedie": sedie}
        if npos > picco["npos"]:
            picco.update(npos=npos, quando=t, sedie=sedie,
                         pids=[pos[i]["pid"] for i in aperte])

    for t, tipo, i in eventi:
        # accumula i minuti di sovrapposizione del tratto [ultimo_t, t)
        # (clippato alla finestra)
        if ultimo_t is not None and t > ultimo_t and len(aperte) > 1:
            a0 = max(ultimo_t, w0) if w0 else ultimo_t
            a1 = min(t, w1) if w1 else t
            if a1 > a0:
                durata = (a1 - a0).total_seconds() / 60.0
                sedie = sorted({pos[j]["magic"] for j in aperte})
                for a in range(len(sedie)):
                    for b in range(a + 1, len(sedie)):
                        minuti_coppia[(sedie[a], sedie[b])] += durata
        ultimo_t = t
        if tipo == 0:
            aperte.discard(i)
        elif tipo == 1:
            aperte.add(i)
            registra(t)   # su un'apertura il massimo puo' solo salire
        else:
            registra(t)   # campione di mezzanotte: giorno senza aperture
    return max_giorno, picco, minuti_coppia


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv", help="trades CSV (formato TradeExporter forward)")
    ap.add_argument("--rischio", type=float, default=0.65,
                    help="rischio %% per unita' a taglia prop (default 0.65)")
    ap.add_argument("--da", default=None,
                    help="finestra: da YYYY.MM.DD incluso (contano anche le "
                         "posizioni aperte prima ma ancora vive)")
    ap.add_argument("--a", default=None, help="finestra: fino a YYYY.MM.DD incluso")
    args = ap.parse_args()

    from datetime import timedelta
    w0 = datetime.strptime(args.da, "%Y.%m.%d") if args.da else None
    w1 = (datetime.strptime(args.a, "%Y.%m.%d") + timedelta(days=1)
          ) if args.a else None

    pos, durata_nulla = leggi_posizioni(args.csv)
    # tiene le posizioni il cui INTERVALLO interseca la finestra
    if w0:
        pos = [p for p in pos if p["close"] > w0]
    if w1:
        pos = [p for p in pos if p["open"] < w1]
    if not pos:
        print("Nessuna posizione EA nel filtro."); return

    r = args.rischio
    nomi = {}
    for p in pos:
        if p["strategy"] and p["magic"] not in nomi:
            nomi[p["magic"]] = p["strategy"].split(" BUY")[0].split(" SELL")[0]

    max_giorno, picco, minuti_coppia = sweep(pos, w0, w1)

    print("=" * 68)
    print("M2 - SOVRAPPOSIZIONE SEDIE  (rischio %.2f%% per unita')" % r)
    print("file: %s" % args.csv)
    if durata_nulla:
        print("(scartate %d righe a durata nulla: open==close, mai aperte "
              "per la definizione congelata)" % durata_nulla)
    print("posizioni EA: %d  sedie (magic): %d  finestra: %s -> %s" % (
        len(pos), len({p['magic'] for p in pos}),
        min(p["open"] for p in pos).strftime("%Y.%m.%d"),
        max(p["close"] for p in pos).strftime("%Y.%m.%d")))
    print("=" * 68)

    giorni = sorted(max_giorno)
    npos_g = [max_giorno[g]["npos"] for g in giorni]
    nsed_g = [max_giorno[g]["nsedie"] for g in giorni]

    print("\n-- PICCO ASSOLUTO --")
    print("max posizioni aperte insieme: %d  (%s)" % (
        picco["npos"], picco["quando"].strftime(FMT)))
    print("  sedie coinvolte: %s" % ", ".join(
        "%s[%s]" % (m, nomi.get(m, "?")) for m in picco["sedie"]))
    print("max sedie distinte aperte insieme: %d" % max(nsed_g))
    print("rischio aperto al picco: per-POSIZIONE %.2f%%  per-SEDIA %.2f%%" % (
        picco["npos"] * r, len(picco["sedie"]) * r))

    print("\n-- DISTRIBUZIONE DEL MASSIMO GIORNALIERO (%d giorni con "
          "posizioni aperte) --" % len(giorni))
    for etichetta, serie in (("posizioni", npos_g), ("sedie", nsed_g)):
        print("  %s: p50 %.1f  p95 %.1f  p99 %.1f  max %d" % (
            etichetta, percentile(serie, 50), percentile(serie, 95),
            percentile(serie, 99), max(serie)))
    print("  rischio per-POSIZIONE: p50 %.2f%%  p95 %.2f%%  p99 %.2f%%  max %.2f%%" % (
        percentile(npos_g, 50) * r, percentile(npos_g, 95) * r,
        percentile(npos_g, 99) * r, max(npos_g) * r))
    print("  rischio per-SEDIA:     p50 %.2f%%  p95 %.2f%%  p99 %.2f%%  max %.2f%%" % (
        percentile(nsed_g, 50) * r, percentile(nsed_g, 95) * r,
        percentile(nsed_g, 99) * r, max(nsed_g) * r))

    for soglia in (4.0, 5.0):
        gp = sum(1 for n in npos_g if n * r > soglia)
        gs = sum(1 for n in nsed_g if n * r > soglia)
        print("  giornate con rischio aperto > %.0f%%: per-POSIZIONE %d  "
              "per-SEDIA %d  (su %d)" % (soglia, gp, gs, len(giorni)))

    print("\n-- ISTOGRAMMA max posizioni/giorno --")
    conteggio = defaultdict(int)
    for n in npos_g:
        conteggio[n] += 1
    for n in sorted(conteggio):
        print("  %2d posizioni: %3d giorni (%.0f%%)" % (
            n, conteggio[n], 100.0 * conteggio[n] / len(giorni)))

    print("\n-- TOP 15 COPPIE DI SEDIE PER MINUTI DI SOVRAPPOSIZIONE --")
    top = sorted(minuti_coppia.items(), key=lambda kv: -kv[1])[:15]
    if not top:
        print("  (nessuna sovrapposizione fra sedie diverse)")
    for (a, b), m in top:
        print("  %s[%s] + %s[%s]: %.0f min" % (
            a, nomi.get(a, "?"), b, nomi.get(b, "?"), m))

    print("\n-- I 10 GIORNI PIU' AFFOLLATI --")
    for g in sorted(giorni, key=lambda g: -max_giorno[g]["npos"])[:10]:
        d = max_giorno[g]
        print("  %s  %2d pos / %2d sedie alle %s  -> %.2f%% / %.2f%%  [%s]" % (
            g, d["npos"], d["nsedie"], d["quando"].strftime("%H:%M:%S"),
            d["npos"] * r, d["nsedie"] * r,
            ", ".join(nomi.get(m, m) for m in d["sedie"])))


if __name__ == "__main__":
    main()
