#!/usr/bin/env python3
"""
analizza_trades.py — la pagella giornaliera dal CSV del TradeExporter.

Legge  data/statements/trades_auto.csv  (che l'EA ABTG_TradeExporter scrive
in Common\\Files e pubblica_trades.ps1 carica nel repo) e produce il report
di giornata in  report/giornata_AAAA-MM-GG.md.

Nasce dal 03/08/2026: quel giorno cinque operazioni hanno insegnato più di
una settimana di backtest, ma le ho ricostruite a mano da cinque screenshot.
Questo script fa lo stesso lavoro da solo, tutti i giorni.

Uso:
    python3 backtest_pipeline/analizza_trades.py            # ultimo giorno con trade
    python3 backtest_pipeline/analizza_trades.py 2026-08-03 # un giorno preciso
"""
import csv, sys, os
from collections import defaultdict
from datetime import datetime

CSV_IN  = "data/statements/trades_auto.csv"
OUT_DIR = "report"

# soglie di lettura, dalle regole del progetto
FRAZIONE_BASSA = 0.30   # sotto il 30% del movimento catturato = la gestione taglia troppo presto
DURATA_SOSPETTA = 120   # secondi: sotto = quasi certamente trailing/BE troppo stretti


def leggi(path):
    if not os.path.exists(path):
        sys.exit("Manca %s — lancia pubblica_trades.ps1 sul VPS (o carica il CSV a mano)." % path)
    with open(path, encoding="utf-8-sig", newline="") as f:
        # il TradeExporter usa ';' come separatore
        righe = list(csv.DictReader(f, delimiter=";"))
    if not righe:
        sys.exit("Il CSV è vuoto.")
    return righe


def num(r, k, default=0.0):
    try:
        return float(str(r.get(k, "")).replace(",", "."))
    except (TypeError, ValueError):
        return default


def tempo(s):
    for fmt in ("%Y.%m.%d %H:%M:%S", "%Y.%m.%d %H:%M", "%Y-%m-%d %H:%M:%S"):
        try:
            return datetime.strptime(s.strip(), fmt)
        except (ValueError, AttributeError):
            continue
    return None


def frazione_catturata(r):
    """Quanta parte del movimento disponibile ha preso il trade.

    ATTENZIONE al denominatore: session_high/low li misura l'EA da
    ingresso fino alle 23:59, cioe' su TUTTA la giornata. Per gli EA di
    apertura, che chiudono entro mezz'ora, e' una finestra molto piu'
    lunga della loro vita: le percentuali escono basse per costruzione e
    vanno lette come "quanto ha preso di cio' che la giornata offriva",
    non come "quanto ha preso del suo movimento".

    Si calcola SOLO sui trade in profitto. Su un perdente il
    denominatore e' l'escursione a favore, che puo' essere quasi zero:
    il 04/08 un trade dava -1679%, un numero senza significato.
    """
    if num(r, "profit") <= 0:
        return None
    hi, lo = num(r, "session_high"), num(r, "session_low")
    op, cp = num(r, "open_price"), num(r, "close_price")
    if hi <= 0 or lo <= 0 or op <= 0:
        return None
    if r.get("side", "").lower().startswith("b"):
        disponibile, preso = hi - op, cp - op
    else:
        disponibile, preso = op - lo, op - cp
    if disponibile <= 0:
        return None
    f = preso / disponibile
    return f if -0.5 <= f <= 3.0 else None   # fuori range = dato inaffidabile


def main():
    righe = leggi(CSV_IN)
    giorno = sys.argv[1] if len(sys.argv) > 1 else None

    for r in righe:
        r["_ot"] = tempo(r.get("open_time", ""))
        r["_ct"] = tempo(r.get("close_time", ""))
    righe = [r for r in righe if r["_ot"] and r["_ct"]]

    # La giornata si sceglie sulla CHIUSURA, non sull'apertura.
    # Il 05/08 questo filtro girava su open_time e ha buttato fuori due
    # posizioni aperte il 31/07 e chiuse quel giorno: -61,59 euro spariti
    # dal netto (-227,17 riportato contro -288,76 reale). Il P&L realizzato
    # appartiene al giorno in cui si realizza, non a quello in cui si apre.
    if not giorno:
        giorno = max(r["_ct"] for r in righe).strftime("%Y-%m-%d")
    oggi = [r for r in righe if r["_ct"].strftime("%Y-%m-%d") == giorno]
    if not oggi:
        sys.exit("Nessun trade chiuso il %s." % giorno)

    # Le posizioni aperte nei giorni precedenti si segnalano: la durata media
    # e la "frazione del giorno" per loro non vogliono dire niente.
    ereditate = [r for r in oggi if r["_ot"].strftime("%Y-%m-%d") != giorno]

    out = ["# 📅 Giornata %s — pagella automatica" % giorno, "",
           "_Generato da `analizza_trades.py` sul CSV del TradeExporter. "
           "Posizioni **chiuse** in giornata._", ""]
    if ereditate:
        out += ["> ⚠️ %d posizion%s aperta in giorni precedenti e chiusa oggi "
                "(%s). Per quelle la durata media e la frazione catturata non "
                "sono indicative." %
                (len(ereditate), "e" if len(ereditate) > 1 else "e",
                 ", ".join(sorted({r.get("strategy", "?") for r in ereditate}))), ""]

    # ---------- riepilogo per EA ----------
    perEA = defaultdict(list)
    for r in oggi:
        perEA[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)

    out += ["## Chi ha operato", "",
            "| EA | Trade | P&L | Durata media | Come sono usciti | Frazione del giorno (solo vincenti) |",
            "|---|---|---|---|---|---|"]
    for ea, tr in sorted(perEA.items(), key=lambda x: -sum(num(r, "profit") for r in x[1])):
        pnl = sum(num(r, "profit") + num(r, "swap") + num(r, "commission") for r in tr)
        dur = [(r["_ct"] - r["_ot"]).total_seconds() for r in tr if r["_ct"]]
        dmed = sum(dur) / len(dur) if dur else 0
        motivi = defaultdict(int)
        for r in tr:
            motivi[r.get("close_reason") or "?"] += 1
        fr = [f for f in (frazione_catturata(r) for r in tr) if f is not None]
        frm = ("%.0f%%" % (100 * sum(fr) / len(fr))) if fr else "—"
        out.append("| %s | %d | **%+.2f** | %s | %s | %s |" % (
            ea, len(tr), pnl,
            ("%.0f s" % dmed) if dmed < 120 else ("%.1f min" % (dmed / 60)),
            " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items())), frm))

    # ---------- netto per simbolo ----------
    perSym = defaultdict(float)
    for r in oggi:
        perSym[r.get("symbol", "?")] += num(r, "profit") + num(r, "swap") + num(r, "commission")
    out += ["", "## Netto per simbolo", "",
            "| Simbolo | Netto |", "|---|---|"]
    for sym, v in sorted(perSym.items(), key=lambda x: -x[1]):
        out.append("| %s | **%+.2f** |" % (sym, v))
    out.append("")
    out.append("**Totale giornata: %+.2f**" % sum(perSym.values()))

    # ---------- segnalazioni ----------
    avvisi = []

    # 1) sovrapposizioni: stesso simbolo, ingressi entro 10 minuti
    #
    # ⚠️ 06/08: "DIREZIONI OPPOSTE" va detto SOLO se le due posizioni erano
    #    aperte NELLO STESSO ISTANTE. Prima bastava che gli ingressi fossero
    #    vicini, e oggi ha prodotto due falsi allarmi su NASUSD: l'`ORB` che
    #    si gira DOPO essere stato stoppato non e' una copertura, e' un
    #    whipsaw. E' lo stesso errore che avevo gia' fatto due volte a mano
    #    leggendo lo Storico invece delle posizioni aperte: qui lo chiude
    #    il codice, non la memoria.
    persym = defaultdict(list)
    for r in oggi:
        persym[r.get("symbol", "?")].append(r)
    for sym, tr in persym.items():
        tr = sorted(tr, key=lambda r: r["_ot"])
        for i in range(len(tr)):
            for j in range(i + 1, len(tr)):
                dt = (tr[j]["_ot"] - tr[i]["_ot"]).total_seconds()
                if dt > 600:
                    break
                a, b = tr[i], tr[j]
                # sovrapposizione vera: l'ultimo ad aprire lo fa prima che il primo chiuda
                sovrapposte = True
                if a["_ct"] and b["_ct"]:
                    sovrapposte = max(a["_ot"], b["_ot"]) < min(a["_ct"], b["_ct"])
                if a.get("side") != b.get("side"):
                    coda = (" — ⚠️ **DIREZIONI OPPOSTE, contemporanee**" if sovrapposte
                            else " — direzioni opposte ma **in sequenza**: la seconda apre "
                                 "dopo la chiusura della prima (inversione, non copertura)")
                else:
                    coda = ("" if sovrapposte
                            else " — **in sequenza**, non contemporanee")
                avvisi.append(
                    "🔶 **%s**: `%s` (%s) e `%s` (%s) a **%.0f s** di distanza%s" % (
                        sym, a.get("strategy"), a.get("side"), b.get("strategy"),
                        b.get("side"), dt, coda))

    # 2) uscite troppo rapide o frazione bassa
    for r in oggi:
        if not r["_ct"]:
            continue
        d = (r["_ct"] - r["_ot"]).total_seconds()
        f = frazione_catturata(r)
        if num(r, "profit") > 0 and d < DURATA_SOSPETTA:
            avvisi.append("⏱️ **%s** su %s: chiuso in **%.0f s** in profitto (%s) — "
                          "gestione probabilmente troppo stretta" % (
                              r.get("strategy"), r.get("symbol"), d,
                              r.get("close_reason") or "?"))
        elif f is not None and f < FRAZIONE_BASSA:
            avvisi.append("📉 **%s** su %s: preso il **%.0f%%** di quanto la giornata offriva "
                          "dopo il suo ingresso (uscito con `%s`)" % (
                              r.get("strategy"), r.get("symbol"), 100 * f,
                              r.get("close_reason") or "?"))

    if avvisi:
        out += ["", "## ⚠️ Da guardare", ""] + ["- " + a for a in dict.fromkeys(avvisi)]
    else:
        out += ["", "_Nessuna anomalia rilevata: nessuna sovrapposizione, "
                "nessuna uscita anomala._"]

    os.makedirs(OUT_DIR, exist_ok=True)
    dest = os.path.join(OUT_DIR, "giornata_%s.md" % giorno)
    with open(dest, "w", encoding="utf-8") as f:
        f.write("\n".join(out) + "\n")
    print("\n".join(out))
    print("\n-> scritto %s" % dest)


if __name__ == "__main__":
    main()
