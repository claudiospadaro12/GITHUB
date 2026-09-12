#!/usr/bin/env python3
# -*- coding: ascii -*-
# =====================================================================
#  MARCATORE_CALCOLA_PEDAGGIO_FOREX_v1
#  calcola_pedaggio_forex.py -- IL PEDAGGIO ALL-IN DEL FOREX, per coppia,
#  contro i pavimenti di casa 13,3x e 40x.
#
#  ASCII PURO (regola dei .ps1 del 17/08 estesa per prudenza a questo
#  file: niente emoji, niente lettere accentate).
#
#  CHE COSA FA, in una riga: prende lo SPREAD MISURATO (in pip) di una
#  coppia, ci somma la COMMISSIONE derivata dalla legge del broker, e
#  dice quale STOP servirebbe per stare sui pavimenti di casa.
#
#  CHE COSA NON FA -- e va detto ogni volta che si cita un suo numero:
#   - NON misura lo spread: quello arriva da ABTG_SpreadLogger
#     (feed vivo) o da ABTG_SpreadOrario (tick storici). Qui si
#     CONSUMA un numero misurato altrove.
#   - NON conosce gli stop M30 forex: in archivio NON CI SONO
#     (vedi --stop, che e' obbligatorio per avere un rapporto).
#   - NON modella slippage, requote, rifiuti, ne' lo swap.
#
#  LA LEGGE DELLA COMMISSIONE (non e' una stima: e' misurata)
#  `0,004% del nozionale in valuta BASE, giro completo`, cioe' 4,0
#  unita' di valuta base per lotto standard (100.000).
#  Fonte: report/CANCELLO_COSTO_FLOTTA_2026-09-10.md, sezione
#  "si scioglie la contraddizione": sulle operazioni vere la
#  commissione a base EUR vale -4,0000 EUR ESATTI su n=84 con
#  VARIANZA ZERO, e i cambi impliciti tornano su otto basi.
#
#  >>> IL PUNTO CHE QUESTO FILE CORREGGE, ed e' la ragione per cui
#  esiste invece di essere una moltiplicazione a mente:
#  la commissione in PIP *NON E' LA STESSA* per tutte le coppie, perche'
#  si paga sulla valuta BASE ma il pip si incassa nella valuta QUOTA.
#  Piu' e' "cara" la valuta base, piu' pip costa la commissione.
#  Su GBPUSD (base GBP, la piu' cara del gruppo) vale ~0,54 pip,
#  NON ~0,47 come su EURUSD.
#
#  AUTOTEST (--autotest): la derivazione si verifica contro DUE numeri
#  scritti da altre sessioni, non contro se stessa:
#    EURUSD -> 0,47 pip (CANCELLO_COSTO_FLOTTA: "~0,5"; CACCIA_SABATO: "0,47")
#    USDJPY -> 0,60 pip (CACCIA_SABATO 2.3: "~0,60")
#  Se uno dei due non riproduce, il file lo DICE e esce 1.
# =====================================================================

import argparse
import csv
import os
import sys

# --- pavimenti di casa (stop / costo all-in) -------------------------
PAVIMENTO_DURO   = 13.3
PAVIMENTO_LAVORO = 40.0

# --- commissione: unita' di valuta BASE per lotto, giro completo ------
#  0,004% x 100.000 = 4,0
COMM_BASE_PER_LOTTO = 4.0
LOTTO = 100000.0

# --- cambi impliciti X/EUR, MISURATI dal rapporto delle commissioni ---
#  (CANCELLO_COSTO_FLOTTA 10/09). Sono i cambi del giorno della misura:
#  entrano nel conto della COMMISSIONE, non dello spread.
CAMBIO_VS_EUR = {
    "EUR": 1.0000,
    "GBP": 1.1613,
    "USD": 0.8552,
    "AUD": 0.6090,
    "NZD": 0.5000,
}

# --- JPY: il cambio implicito NON e' fra gli otto misurati ------------
#  USDJPY al giorno della misura. E' l'UNICO numero di questo file che
#  non viene da una misura di casa: si dichiara come tale e si puo'
#  sovrascrivere con --usdjpy.
USDJPY_ASSUNTO = 150.0

# --- anatomia delle coppie: (base, quota, pip_size) -------------------
COPPIE = {
    "EURUSD": ("EUR", "USD", 0.0001),
    "GBPUSD": ("GBP", "USD", 0.0001),
    "AUDUSD": ("AUD", "USD", 0.0001),
    "EURAUD": ("EUR", "AUD", 0.0001),
    "GBPCAD": ("GBP", "CAD", 0.0001),
    "EURCAD": ("EUR", "CAD", 0.0001),
    "USDJPY": ("USD", "JPY", 0.01),
    "EURJPY": ("EUR", "JPY", 0.01),
    "GBPJPY": ("GBP", "JPY", 0.01),
    "CHFJPY": ("CHF", "JPY", 0.01),
}

# valute quota per cui NON abbiamo il cambio misurato: il conto della
# commissione in pip NON si puo' chiudere, e si dice.
QUOTA_NON_MISURATA = ("CAD",)


def cambio_vs_eur(valuta, usdjpy):
    """X/EUR. JPY passa dall'USDJPY assunto, e resta dichiarato."""
    if valuta in CAMBIO_VS_EUR:
        return CAMBIO_VS_EUR[valuta]
    if valuta == "JPY":
        # JPY/EUR = (USD/EUR) / (USDJPY)
        return CAMBIO_VS_EUR["USD"] / usdjpy
    return None


def commissione_pip(coppia, usdjpy=USDJPY_ASSUNTO):
    """Commissione giro completo, in PIP della coppia.

    Ritorna (pip, nota). pip=None se il cambio non e' misurato.

    Conto: 4,0 unita' BASE per lotto -> convertite in valuta QUOTA ->
    divise per il valore del pip in valuta quota (lotto x pip_size).
    """
    if coppia not in COPPIE:
        return None, "coppia non in tabella"
    base, quota, pip_size = COPPIE[coppia]

    cb = cambio_vs_eur(base, usdjpy)
    cq = cambio_vs_eur(quota, usdjpy)
    if cb is None:
        return None, "cambio della valuta BASE %s NON MISURATO" % base
    if cq is None or quota in QUOTA_NON_MISURATA:
        return None, "cambio della valuta QUOTA %s NON MISURATO" % quota

    # 4,0 base -> quota
    comm_in_quota = COMM_BASE_PER_LOTTO * (cb / cq)
    # valore di 1 pip per 1 lotto, in valuta quota
    valore_pip_quota = LOTTO * pip_size
    return comm_in_quota / valore_pip_quota, "ok"


def autotest(usdjpy=USDJPY_ASSUNTO):
    """Verifica la derivazione contro numeri scritti da ALTRE sessioni."""
    print("AUTOTEST -- la derivazione contro numeri scritti da altri")
    print("  (un numero che verifica solo se stesso non e' verificato)")
    print("")
    ancore = [
        ("EURUSD", 0.47, 0.02,
         "CANCELLO_COSTO_FLOTTA 10/09 '~0,5' + CACCIA_SABATO 2.3 '0,47'"),
        ("USDJPY", 0.60, 0.02,
         "CACCIA_SABATO 2.3 '~0,60'"),
    ]
    rossi = 0
    for coppia, atteso, tolleranza, fonte in ancore:
        got, nota = commissione_pip(coppia, usdjpy)
        if got is None:
            print("  ROSSO  %s : non calcolabile (%s)" % (coppia, nota))
            rossi += 1
            continue
        ok = abs(got - atteso) <= tolleranza
        print("  %s  %s : derivato %.4f pip, atteso %.2f (+-%.2f)"
              % ("VERDE " if ok else "ROSSO ", coppia, got, atteso, tolleranza))
        print("         fonte dell'atteso: %s" % fonte)
        if not ok:
            rossi += 1

    # controllo di coerenza interna: i cambi impliciti devono tornare
    # dal rapporto delle commissioni misurate in EUR.
    print("")
    print("  coerenza dei cambi impliciti (commissione misurata / 4,00 EUR):")
    misurate_eur = {"EUR": 4.00, "GBP": 4.65, "USD": 3.42, "AUD": 2.44, "NZD": 2.00}
    for val, eur in sorted(misurate_eur.items()):
        implicito = eur / COMM_BASE_PER_LOTTO
        atteso = CAMBIO_VS_EUR[val]
        ok = abs(implicito - atteso) <= 0.005
        print("    %s  %s/EUR: dalle commissioni %.4f, in tabella %.4f"
              % ("VERDE " if ok else "ROSSO ", val, implicito, atteso))
        if not ok:
            rossi += 1

    # il CONTRO-ESEMPIO del metodo: se la commissione fosse la stessa in
    # pip per tutte le coppie (l'errore che questo file corregge), GBPUSD
    # ed EURUSD darebbero lo STESSO numero. Devono differire.
    print("")
    ce, _ = commissione_pip("EURUSD", usdjpy)
    cg, _ = commissione_pip("GBPUSD", usdjpy)
    diverse = (ce is not None and cg is not None and abs(cg - ce) > 0.05)
    print("  %s contro-esempio: GBPUSD (%.4f) deve DIFFERIRE da EURUSD (%.4f)"
          % ("VERDE " if diverse else "ROSSO ", cg or -1, ce or -1))
    print("         se uscissero uguali, la legge sulla valuta BASE non")
    print("         sarebbe implementata e il file non misurerebbe niente")
    if not diverse:
        rossi += 1

    print("")
    if rossi == 0:
        print("AUTOTEST: tutto VERDE.")
    else:
        print("AUTOTEST: %d ROSSI. Non usare i numeri di questo file." % rossi)
    return rossi


def riga_pedaggio(coppia, spread_pip, stop_pip, usdjpy):
    """Una riga di verdetto per una coppia."""
    comm, nota = commissione_pip(coppia, usdjpy)
    out = {"coppia": coppia, "spread": spread_pip, "commissione": comm,
           "nota": nota, "allin": None, "stop": stop_pip,
           "rapporto": None, "stop_13": None, "stop_40": None,
           "verdetto": ""}
    if comm is None:
        out["verdetto"] = "NON CALCOLABILE: " + nota
        return out
    if spread_pip is None:
        out["verdetto"] = "SPREAD NON MISURATO: manca la meta' del costo"
        return out

    allin = spread_pip + comm
    out["allin"] = allin
    out["stop_13"] = PAVIMENTO_DURO * allin
    out["stop_40"] = PAVIMENTO_LAVORO * allin

    if stop_pip is None:
        out["verdetto"] = "STOP NON MISURATO: nessun rapporto, solo le soglie"
        return out

    r = stop_pip / allin
    out["rapporto"] = r
    if r < PAVIMENTO_DURO:
        out["verdetto"] = "SFONDATO -- sotto il pavimento DURO 13,3x"
    elif r < PAVIMENTO_LAVORO:
        out["verdetto"] = ("SOTTO il pavimento di LAVORO 40x (%.0f%%)"
                           % (100.0 * r / PAVIMENTO_LAVORO))
    else:
        out["verdetto"] = "PASSA il pavimento di lavoro 40x"
    return out


def stampa(righe, usdjpy):
    print("")
    print("PEDAGGIO ALL-IN, coppia per coppia")
    print("  commissione = 0,004%% del nozionale in valuta BASE, giro completo")
    print("  (= 4,0 unita' base per lotto). USDJPY usato: %.2f" % usdjpy)
    print("")
    cap = ("coppia", "spread", "comm", "all-in", "stop", "x", "40x chiede")
    print("  %-8s %8s %8s %8s %8s %8s %11s  verdetto" % cap)
    print("  " + "-" * 78)
    for r in righe:
        def f(v, n=3):
            return ("%.*f" % (n, v)) if v is not None else "n/d"
        print("  %-8s %8s %8s %8s %8s %8s %11s  %s"
              % (r["coppia"], f(r["spread"], 3), f(r["commissione"], 3),
                 f(r["allin"], 3), f(r["stop"], 1),
                 f(r["rapporto"], 1), f(r["stop_40"], 1), r["verdetto"]))
    print("")


def contro_esempio(coppia, stop_pip, usdjpy, spread_base):
    """Quale SPREAD misurato farebbe cadere il bersaglio.

    E' la domanda che rende utile la misura: se non esiste un valore
    dello spread che smentisce il bersaglio, la misura non decide
    niente e non vale la pena farla.
    """
    comm, nota = commissione_pip(coppia, usdjpy)
    print("CONTRO-ESEMPIO -- quale numero SMENTISCE il bersaglio")
    print("  coppia: %s   stop del bersaglio: %.1f pip" % (coppia, stop_pip))
    if comm is None:
        print("  non calcolabile: %s" % nota)
        return
    # spread massimo che tiene il 40x: stop/(spread+comm) >= 40
    spread_max_40 = stop_pip / PAVIMENTO_LAVORO - comm
    spread_max_13 = stop_pip / PAVIMENTO_DURO - comm
    print("  commissione derivata: %.4f pip (non si sposta con lo spread)" % comm)
    print("")
    print("  lo spread misurato DEVE risultare <= %.3f pip perche' il"
          % spread_max_40)
    print("  bersaglio tenga il pavimento di LAVORO 40x.")
    if spread_max_40 <= 0:
        print("  ATTENZIONE: soglia NEGATIVA -> la sola commissione sfonda il")
        print("  40x. Nessuno spread, nemmeno ZERO, salva questo bersaglio.")
    print("  (pavimento DURO 13,3x: spread <= %.3f pip)" % spread_max_13)
    print("")
    print("  quindi, misurando:")
    for s in (0.1, 0.2, 0.3, 0.5, 0.8, 1.0):
        allin = s + comm
        r = stop_pip / allin
        esito = "TIENE" if r >= PAVIMENTO_LAVORO else (
            "BERSAGLIO SPARITO" if r >= PAVIMENTO_DURO else "SFONDA anche il DURO")
        print("    spread %.1f -> all-in %.3f -> %5.1fx  %s" % (s, allin, r, esito))
    if spread_base is not None:
        allin = spread_base + comm
        print("")
        print("  lettura unica di partenza (%.1f pip): all-in %.3f -> 40x chiede %.1f pip"
              % (spread_base, allin, PAVIMENTO_LAVORO * allin))
    print("")


def leggi_csv_logger(percorso, ore):
    """Legge ABTG_SpreadLogger_orario.csv e tira fuori la mediana in pip.

    Colonne attese (sorgente mql5/Experts/ABTG_SpreadLogger.mq5):
      simbolo,ora_server,campioni,giornate,scartati,overflow,
      mediana_punti,p95_punti,p99_punti,media_punti,max_punti,
      mediana_unita,p95_unita,max_unita,unita,punti_per_unita,...

    ATTENZIONE: qui si legge la MEDIANA DELL'ORA e, se sono chieste piu'
    ore, si prende la PEGGIORE (massimo). NON si fa la media delle
    mediane: la media di sei mediane non e' la mediana di niente.
    Il conto giusto si fa sommando gli istogrammi, e quello lo fa
    RIGA_SPREADLOGGER_RACCOLTA.ps1 dal file di stato grezzo.
    """
    out = {}
    if not os.path.isfile(percorso):
        print("CSV non trovato: %s" % percorso)
        return out
    with open(percorso, "r") as fh:
        for rec in csv.DictReader(fh):
            sym = (rec.get("simbolo") or "").strip()
            if not sym:
                continue
            try:
                ora = int((rec.get("ora_server") or "-1").strip())
                camp = int((rec.get("campioni") or "0").strip())
                med = float((rec.get("mediana_unita") or "nan").strip())
            except ValueError:
                continue
            if camp <= 0 or ora < 0:
                continue
            if ore and ora not in ore:
                continue
            prec = out.get(sym)
            if prec is None or med > prec:
                out[sym] = med
    return out


def main():
    ap = argparse.ArgumentParser(
        description="Pedaggio all-in del forex contro i pavimenti 13,3x e 40x.")
    ap.add_argument("--autotest", action="store_true",
                    help="verifica la derivazione contro numeri di altre sessioni ed esce")
    ap.add_argument("--spread", action="append", default=[], metavar="COPPIA=PIP",
                    help="spread MISURATO in pip (ripetibile), es. GBPUSD=0.2")
    ap.add_argument("--stop", action="append", default=[], metavar="COPPIA=PIP",
                    help="stop tipico in pip (ripetibile). Senza, niente rapporto")
    ap.add_argument("--csv", default="", metavar="FILE",
                    help="ABTG_SpreadLogger_orario.csv da cui leggere le mediane")
    ap.add_argument("--ore", default="", metavar="LISTA",
                    help="ore SERVER da considerare nel CSV, es. 7,8,9,13,14")
    ap.add_argument("--usdjpy", type=float, default=USDJPY_ASSUNTO,
                    help="cambio USDJPY (default %.1f, DICHIARATO come assunto)" % USDJPY_ASSUNTO)
    ap.add_argument("--contro-esempio", default="", metavar="COPPIA=STOP",
                    help="quale spread smentirebbe il bersaglio, es. GBPUSD=28")
    args = ap.parse_args()

    if args.autotest:
        return 1 if autotest(args.usdjpy) else 0

    def coppia_valore(lista, nome):
        d = {}
        for voce in lista:
            if "=" not in voce:
                print("--%s malformato (serve COPPIA=NUMERO): %s" % (nome, voce))
                return None
            k, v = voce.split("=", 1)
            k = k.strip().upper()
            if k not in COPPIE:
                print("coppia sconosciuta in --%s: %s" % (nome, k))
                return None
            try:
                d[k] = float(v)
            except ValueError:
                print("numero non valido in --%s: %s" % (nome, voce))
                return None
        return d

    spread = coppia_valore(args.spread, "spread")
    stop = coppia_valore(args.stop, "stop")
    if spread is None or stop is None:
        return 2

    ore = set()
    if args.ore:
        for p in args.ore.split(","):
            p = p.strip()
            if p:
                ore.add(int(p))

    if args.csv:
        dal_csv = leggi_csv_logger(args.csv, ore)
        for sym, med in sorted(dal_csv.items()):
            if sym in COPPIE and sym not in spread:
                spread[sym] = med
                print("dal CSV: %s mediana peggiore = %.3f pip" % (sym, med))

    # autotest sempre, prima di stampare qualunque numero
    if autotest(args.usdjpy):
        print("")
        print("FERMO: l'autotest e' ROSSO, non stampo verdetti.")
        return 1

    if args.contro_esempio:
        if "=" not in args.contro_esempio:
            print("--contro-esempio malformato (serve COPPIA=STOP)")
            return 2
        k, v = args.contro_esempio.split("=", 1)
        k = k.strip().upper()
        print("")
        contro_esempio(k, float(v), args.usdjpy, spread.get(k))

    if not spread and not stop:
        print("")
        print("Nessuno spread passato: non c'e' niente da giudicare.")
        print("Lo spread si MISURA (ABTG_SpreadLogger / ABTG_SpreadOrario),")
        print("non si assume. Qui si consuma un numero misurato.")
        return 0

    coppie = sorted(set(list(spread.keys()) + list(stop.keys())))
    righe = [riga_pedaggio(c, spread.get(c), stop.get(c), args.usdjpy)
             for c in coppie]
    stampa(righe, args.usdjpy)
    print("COSA QUESTO CONTO NON COPRE: slippage, requote, rifiuti, swap,")
    print("e l'esecuzione della prop vera. Copre spread + commissione.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
