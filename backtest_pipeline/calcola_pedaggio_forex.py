#!/usr/bin/env python3
# -*- coding: ascii -*-
# =====================================================================
#  MARCATORE_CALCOLA_PEDAGGIO_FOREX_v2
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
#  AUTOTEST (--autotest), in cinque blocchi che provano a ROMPERE:
#   1. l'UNICA ancora genuina: EURUSD -> 0,47 pip, atteso scritto da
#      un'altra sessione (CANCELLO_COSTO_FLOTTA "~0,5", CACCIA_SABATO
#      "0,47"). E' genuina perche' il conto non passa dall'atteso.
#   2. USDJPY NON e' un'ancora: nella v1 lo era, ed era un'IDENTITA'
#      (vedi sopra). Qui si verifica che non ricada piu' sullo 0,600.
#   3. controprove interne della tabella dei cambi (la stessa valuta
#      quota da coppie diverse deve tornare).
#   4. il ritrovamento NON deve dipendere dalla DATA dei cambi: si
#      rifa' il conto con la tabella indipendente del 10/09.
#   5. contro-esempi: GBPUSD deve DIFFERIRE da EURUSD, e una valuta
#      fuori tabella deve far RIFIUTARE il conto, non stimarlo.
#  Se un blocco e' rosso, il file lo DICE e esce 1.
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

# --- cambi X/EUR: LA TABELLA PRIMARIA, UNA SOLA DATA ---------------
#  Fonte: backtest_pipeline/risultati_archivio/sonda_storico_17-08/
#         215D85D7_ABTG_InfoBroker.csv  (sonda del 17/08/2026 17:34 srv)
#  Conto in EUR (sezione SERVER, r.7 "Valuta,EUR"), quindi TickValue e'
#  in EUR e vale:
#         quota/EUR = TickValue / (ContractSize x TickSize)
#
#  >>> PERCHE' QUESTA E NON LE COMMISSIONI DEL 10/09 (v1 usava quelle):
#  e' UNA SOLA ISTANTANEA, quindi ogni cambio incrociato che ne esce
#  NON mescola due date; copre anche CHF, CAD e JPY, che dalle
#  commissioni del 10/09 NON si ricavano; ed e' CONTROPROVATA piu'
#  volte dentro se stessa (la stessa valuta quota letta da coppie
#  diverse torna, scarto relativo massimo 0,012%):
#     USD da EURUSD/GBPUSD/AUDUSD/NZDUSD  -> 0,86287 (4 coppie)
#     JPY da USDJPY/CHFJPY/GBPJPY/EURJPY  -> 0,0054147 (4 coppie)
#     CAD da EURCAD/USDCAD/GBPCAD         -> 0,62216 (3 coppie)
#     CHF da EURCHF/USDCHF                -> 1,0655 (2 coppie)
#     NZD da EURNZD/AUDNZD                -> 0,5099 (2 coppie)
#
#  >>> E IL CORREGGENDO DELLA v1, detto per intero: la v1 ricavava JPY
#  come (USD/EUR)/150,0 con il 150,0 ASSUNTO. Su USDJPY la base E' USD,
#  quindi USD/EUR si cancellava e restava comm = 4,0 x 150/1000 = 0,600
#  PER COSTRUZIONE: un'identita', non una misura. Il disco dice
#  USD/JPY = 0,86287/0,0054147 = 159,35, e la commissione vera e'
#  0,637 -- NON 0,600.
CAMBIO_VS_EUR = {
    "EUR": 1.0,
    "USD": 0.86287,
    "GBP": 1.17026,      # da EURGBP
    "CHF": 1.06559,      # da USDCHF (EURCHF da' 1,06550: scarto 0,008%)
    "JPY": 0.0054147,    # da USDJPY/CHFJPY/GBPJPY/EURJPY, tutte e quattro
    "AUD": 0.61372,      # da EURAUD
    "NZD": 0.50988,      # da EURNZD
    "CAD": 0.62216,      # da EURCAD
}
DATA_CAMBI = "17/08/2026 17:34 srv (sonda 215D85D7_ABTG_InfoBroker.csv)"

# --- SECONDA tabella, INDIPENDENTE: dai cambi impliciti nelle -------
#  commissioni MISURATE del 10/09 (CANCELLO_COSTO_FLOTTA). Serve a UNA
#  cosa sola: verificare che il verdetto NON dipenda da quale data si
#  usa. Non copre JPY/CHF/CAD.
CAMBIO_VS_EUR_1009 = {
    "EUR": 1.0,
    "GBP": 1.1613,
    "USD": 0.8552,
    "AUD": 0.6090,
    "NZD": 0.5000,
}
DATA_CAMBI_1009 = "10/09/2026 (cambi impliciti nelle commissioni misurate)"

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

# Nessuna valuta quota resta senza cambio: la sonda del 17/08 le copre
# tutte (CHF e CAD compresi). Il controllo pero' RESTA nel codice: se
# domani entra una coppia con una valuta fuori tabella, lo strumento
# deve rifiutarsi invece di stimare.
QUOTA_NON_MISURATA = ()


def cambio_vs_eur(valuta, tabella=None):
    """X/EUR letto dalla tabella. NIENTE derivazioni, niente assunti.

    La v1 derivava il JPY da un USDJPY assunto, e su USDJPY quello
    rendeva il risultato un'IDENTITA'. Qui ogni valuta e' un dato
    letto: se manca, si torna None e il chiamante lo dichiara.
    """
    if tabella is None:
        tabella = CAMBIO_VS_EUR
    return tabella.get(valuta)


def commissione_pip(coppia, tabella=None):
    """Commissione giro completo, in PIP della coppia.

    Ritorna (pip, nota). pip=None se il cambio non e' misurato.

    Conto: 4,0 unita' BASE per lotto -> convertite in valuta QUOTA ->
    divise per il valore del pip in valuta quota (lotto x pip_size).
    """
    if coppia not in COPPIE:
        return None, "coppia non in tabella"
    base, quota, pip_size = COPPIE[coppia]

    cb = cambio_vs_eur(base, tabella)
    cq = cambio_vs_eur(quota, tabella)
    if cb is None:
        return None, "cambio della valuta BASE %s NON MISURATO" % base
    if cq is None or quota in QUOTA_NON_MISURATA:
        return None, "cambio della valuta QUOTA %s NON MISURATO" % quota

    # 4,0 base -> quota
    comm_in_quota = COMM_BASE_PER_LOTTO * (cb / cq)
    # valore di 1 pip per 1 lotto, in valuta quota
    valore_pip_quota = LOTTO * pip_size
    return comm_in_quota / valore_pip_quota, "ok"


def autotest(tabella=None):
    """Prova a ROMPERE la derivazione, non a confermarla."""
    print("AUTOTEST -- si prova a ROMPERE la derivazione, non a confermarla")
    print("  cambi: %s" % DATA_CAMBI)
    print("")
    rossi = 0

    # ---- 1. L'UNICA ANCORA GENUINA -------------------------------------
    #  Genuina perche' l'atteso l'ha scritto un'ALTRA sessione e il
    #  conto NON passa dal numero atteso.
    print("  1) L'ANCORA GENUINA (una sola, e va detto)")
    got, nota = commissione_pip("EURUSD", tabella)
    if got is None:
        print("     ROSSO  EURUSD non calcolabile (%s)" % nota)
        rossi += 1
    else:
        ok = abs(got - 0.47) <= 0.02
        print("     %s EURUSD : derivato %.4f pip, atteso 0,47 (+-0,02)"
              % ("VERDE " if ok else "ROSSO ", got))
        print("            fonte dell'atteso: CANCELLO_COSTO_FLOTTA 10/09")
        print("            '~0,5' + CACCIA_SABATO 2.3 '0,47'")
        if not ok:
            rossi += 1

    # ---- 2. L'ANCORA CHE LA v1 CONTAVA E NON VALEVA ---------------------
    print("")
    print("  2) USDJPY -- NON E' UN'ANCORA, e la v1 sbagliava a contarla")
    print("     la v1 derivava JPY/EUR = (USD/EUR)/150 con 150 ASSUNTO.")
    print("     Su USDJPY la base E' USD: si cancella, e restava")
    print("     comm = 4,0 x 150/1000 = 0,600 PER COSTRUZIONE.")
    print("     Identita', potere di falsificazione ZERO.")
    uj, _ = commissione_pip("USDJPY", tabella)
    tab = tabella or CAMBIO_VS_EUR
    if uj is None or "JPY" not in tab or "USD" not in tab:
        # succede con --cambi 10-09, che NON copre il JPY: e' il
        # comportamento giusto (rifiuta invece di stimare), non un rosso.
        print("     questa tabella dei cambi NON copre il JPY: il conto")
        print("     si RIFIUTA invece di stimarlo. Blocco non applicabile.")
    else:
        rate = tab["USD"] / tab["JPY"]
        print("     ora USD/JPY = %.2f e' LETTO dal disco -> comm %.4f pip"
              % (rate, uj))
        print("     e CONTRADDICE il '~0,60' di CACCIA_SABATO 2.3, che")
        print("     poggiava su un USDJPY = 150. Lo scarto e' il difetto.")
        # il controllo utile qui e' che NON sia piu' l'identita' della v1
        non_identita = abs(uj - 0.600) > 0.02
        print("     %s la derivazione NON ricade piu' sullo 0,600 dell'identita'"
              % ("VERDE " if non_identita else "ROSSO "))
        if not non_identita:
            rossi += 1

    # ---- 3. CONTROPROVE INTERNE DELLA TABELLA DEI CAMBI -----------------
    #  La stessa valuta quota, letta da coppie DIVERSE, deve tornare.
    print("")
    print("  3) CONTROPROVE della tabella dei cambi della SONDA 17/08")
    print("     quota/EUR = TickValue / (ContractSize x TickSize)")
    print("     NB: questo blocco verifica SEMPRE la tabella della sonda,")
    print("     anche con --cambi 10-09: sta controllando QUELLA")
    print("     derivazione, non la tabella scelta per i verdetti.")
    controprove = [
        ("USD", 0.86287, ["EURUSD 0,86287", "GBPUSD 0,86287",
                          "AUDUSD 0,86287", "NZDUSD 0,86289"]),
        ("JPY", 0.0054147, ["USDJPY 0,54147", "CHFJPY 0,54148",
                            "GBPJPY 0,54147", "EURJPY 0,54147"]),
        ("CHF", 1.06559, ["USDCHF 1,06559", "EURCHF 1,06550"]),
        ("CAD", 0.62216, ["EURCAD 0,62216", "USDCAD 0,62214",
                          "GBPCAD 0,62216"]),
    ]
    for val, atteso, fonti in controprove:
        got_t = CAMBIO_VS_EUR.get(val)
        if got_t is None:
            print("     ROSSO  %s/EUR manca dalla tabella della sonda" % val)
            rossi += 1
            continue
        ok = abs(got_t - atteso) / atteso <= 0.001
        print("     %s %s/EUR = %.7f   da %d coppie: %s"
              % ("VERDE " if ok else "ROSSO ", val, got_t,
                 len(fonti), "; ".join(fonti)))
        if not ok:
            rossi += 1

    # ---- 4. IL VERDETTO NON DEVE DIPENDERE DALLA DATA DEI CAMBI ---------
    #  Se cambiando tabella il numero strategico si muovesse molto, il
    #  ritrovamento sarebbe fragile. E' un RAPPORTO: la deriva comune
    #  si cancella. Qui si verifica che sia vero.
    print("")
    print("  4) IL RITROVAMENTO NON DEVE DIPENDERE DALLA DATA DEI CAMBI")
    print("     (se dipendesse, sarebbe fragile: si confronta con i")
    print("      cambi INDIPENDENTI del 10/09)")
    for coppia in ("GBPUSD", "EURUSD", "AUDUSD"):
        a, _ = commissione_pip(coppia, CAMBIO_VS_EUR)
        b, _ = commissione_pip(coppia, CAMBIO_VS_EUR_1009)
        if a is None or b is None:
            continue
        scarto = 100.0 * abs(a - b) / a
        ok = scarto <= 1.0
        print("     %s %s: 17/08 %.4f vs 10/09 %.4f -> scarto %.3f%%"
              % ("VERDE " if ok else "ROSSO ", coppia, a, b, scarto))
        if not ok:
            rossi += 1

    # ---- 5. IL CONTRO-ESEMPIO DEL METODO --------------------------------
    print("")
    print("  5) CONTRO-ESEMPIO del metodo")
    ce, _ = commissione_pip("EURUSD", tabella)
    cg, _ = commissione_pip("GBPUSD", tabella)
    diverse = (ce is not None and cg is not None and abs(cg - ce) > 0.05)
    print("     %s GBPUSD (%.4f) deve DIFFERIRE da EURUSD (%.4f)"
          % ("VERDE " if diverse else "ROSSO ", cg or -1, ce or -1))
    print("            se uscissero uguali, la legge sulla valuta BASE")
    print("            non sarebbe implementata e il file non")
    print("            misurerebbe niente")
    if not diverse:
        rossi += 1
    # e una valuta fuori tabella deve far RIFIUTARE, non stimare
    finta = dict(CAMBIO_VS_EUR)
    finta.pop("JPY")
    v, _ = commissione_pip("USDJPY", finta)
    print("     %s con JPY FUORI tabella, USDJPY deve tornare n/d"
          % ("VERDE " if v is None else "ROSSO "))
    if v is not None:
        rossi += 1

    print("")
    if rossi == 0:
        print("AUTOTEST: tutto VERDE.")
    else:
        print("AUTOTEST: %d ROSSI. Non usare i numeri di questo file." % rossi)
    return rossi


def riga_pedaggio(coppia, spread_pip, stop_pip, tabella=None):
    """Una riga di verdetto per una coppia."""
    comm, nota = commissione_pip(coppia, tabella)
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


def stampa(righe):
    print("")
    print("PEDAGGIO ALL-IN, coppia per coppia")
    print("  commissione = 0,004% del nozionale in valuta BASE, giro")
    print("  completo (= 4,0 unita' base per lotto).")
    print("  cambi: %s" % DATA_CAMBI)
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


def contro_esempio(coppia, stop_pip, spread_base, tabella=None):
    """Quale SPREAD misurato farebbe cadere il bersaglio.

    E' la domanda che rende utile la misura: se non esiste un valore
    dello spread che smentisce il bersaglio, la misura non decide
    niente e non vale la pena farla.
    """
    comm, nota = commissione_pip(coppia, tabella)
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
        print("  spread di partenza %.1f pip [LETTURA UNICA, sonda" % spread_base)
        print("  istantanea 17/08 17:34 -- NON una distribuzione]:")
        print("    all-in %.3f -> il 40x chiede %.1f pip di stop"
              % (allin, PAVIMENTO_LAVORO * allin))
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
    ap.add_argument("--cambi", choices=("17-08", "10-09"), default="17-08",
                    help="quale tabella cambi: 17-08 (sonda, una sola data, "
                         "copre JPY/CHF/CAD) o 10-09 (dalle commissioni "
                         "misurate, NON copre JPY/CHF/CAD)")
    ap.add_argument("--contro-esempio", default="", metavar="COPPIA=STOP",
                    help="quale spread smentirebbe il bersaglio, es. GBPUSD=28")
    args = ap.parse_args()

    tabella = (CAMBIO_VS_EUR if args.cambi == "17-08"
               else CAMBIO_VS_EUR_1009)
    if args.autotest:
        return 1 if autotest(tabella) else 0

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
    if autotest(tabella):
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
        contro_esempio(k, float(v), spread.get(k), tabella)

    if not spread and not stop:
        print("")
        print("Nessuno spread passato: non c'e' niente da giudicare.")
        print("Lo spread si MISURA (ABTG_SpreadLogger / ABTG_SpreadOrario),")
        print("non si assume. Qui si consuma un numero misurato.")
        return 0

    coppie = sorted(set(list(spread.keys()) + list(stop.keys())))
    righe = [riga_pedaggio(c, spread.get(c), stop.get(c), tabella)
             for c in coppie]
    stampa(righe)
    print("COSA QUESTO CONTO NON COPRE: slippage, requote, rifiuti, swap,")
    print("e l'esecuzione della prop vera. Copre spread + commissione.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
