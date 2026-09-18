#!/usr/bin/env python3
# -*- coding: ascii -*-
# =====================================================================
#  MARCATORE_CANCELLO_DUE_UNITA_v1
#  cancello_due_unita.py -- IL CANCELLO DI COSTO LETTO NELLE DUE UNITA':
#  stop/SPREAD e stop/COSTO PIENO (spread + commissione), sedia per sedia.
#
#  ASCII PURO (regola dei .ps1 del 17/08, estesa per prudenza ai .py).
#
#  PERCHE' ESISTE
#  --------------
#  `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` usa DUE denominatori
#  diversi sotto la stessa soglia da 40x, senza etichetta:
#    r.394 (indici)  intestazione di colonna: `spread`
#    r.460 (oro)     intestazione di colonna: `spread+comm`   <-- costo pieno
#    r.485 (nikkei)  intestazione di colonna: `spread`
#    r.518 (forex)   intestazioni: `spr A` / `spr B`          <-- spread nudo
#  Segnalato dall'esterno il 13/09 (Marco Garbuglia, punto 1:
#  `docs/garbuglia/RISPOSTA_DOSSIER_ABTG_2026-09-13_Garbuglia_testo.txt`).
#
#  Questo file NON decide quale unita' sia quella giusta: CALCOLA TUTTE E
#  DUE le letture per ogni sedia e dice, per nome, QUALI CAMBIANO VERDETTO.
#
#  CHE COSA CALCOLA (nessun numero incollato a mano fra i risultati)
#  ----------------------------------------------------------------
#   1. la COMMISSIONE per lotto, per simbolo, MISURATA sui deal veri
#      (`data/statements/trades_auto.csv`, colonne commission/volume);
#   2. la stessa commissione convertita nell'UNITA' DI PREZZO del simbolo
#      (pip sul forex, punto indice sugli indici, $ sull'oro) usando
#      TickValue/TickSize della sonda del 17/08 -- una sola formula per
#      tutti i simboli, nessun caso speciale;
#   3. il controllo incrociato con la LEGGE della commissione
#      (`calcola_pedaggio_forex.commissione_pip`, 0,004% del nozionale in
#      valuta base): due strade con ingressi diversi, stesso numero;
#   4. lo STOP misurato sui deal veri (mediana delle gambe chiuse in `sl`
#      e in perdita), ricalcolato qui e messo ACCANTO allo stop dichiarato
#      dal referto -- non al suo posto (vedi sotto);
#   5. i due rapporti `stop/spread` e `stop/costo pieno` e i quattro
#      verdetti (40x e 13,3x in ciascuna unita');
#   6. l'elenco, PER NOME, delle sedie il cui verdetto cambia passando da
#      un'unita' all'altra.
#
#  CHE COSA **NON** FA -- da dire ogni volta che si cita un suo numero
#  -------------------------------------------------------------------
#   - NON misura lo spread. Lo spread arriva dai file di casa (tre indici
#     a tick) o dalla sonda istantanea del 17/08 (tutto il resto): qui si
#     CONSUMA un numero misurato altrove, con la sua etichetta.
#   - NON cambia nessun criterio. 40x e 13,3x sono di Claudio.
#   - NON modella slippage, requote, rifiuti, swap.
#   - NON decide quale unita' vada firmata.
#
#  >>> PERCHE' IL NUMERATORE RESTA QUELLO DEL REFERTO
#  La domanda di questo file e' "che cosa cambia se cambio il
#  DENOMINATORE". Se cambiassi anche il numeratore (lo stop, che dal 10/09
#  e' cresciuto di campione su parecchie sedie) i verdetti che si
#  muovono avrebbero DUE cause e l'elenco non vorrebbe dire niente.
#  Quindi: verdetti calcolati sullo stop DICHIARATO dal referto, e lo stop
#  RICALCOLATO oggi stampato in una colonna a parte, con la divergenza.
#
#  AUTOTEST (--autotest): cinque blocchi che provano a ROMPERE, non a
#  confermare. Se uno e' rosso il file lo dice ed esce 1.
# =====================================================================

import argparse
import csv
import os
import statistics
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
RADICE = os.path.dirname(QUI)
sys.path.insert(0, QUI)

try:
    from calcola_pedaggio_forex import commissione_pip, COPPIE
except ImportError:
    commissione_pip = None
    COPPIE = {}

# --- i pavimenti: sono di Claudio, qui si leggono e basta -------------
PAVIMENTO_DURO = 13.3
PAVIMENTO_LAVORO = 40.0

TRADES = os.path.join(RADICE, "data", "statements", "trades_auto.csv")
SONDA = os.path.join(RADICE, "backtest_pipeline", "risultati_archivio",
                     "sonda_storico_17-08", "215D85D7_ABTG_InfoBroker.csv")
SPREAD_DIR = os.path.join(RADICE, "backtest_pipeline", "risultati_archivio",
                          "spread_flotta")

# =====================================================================
#  INGRESSI DICHIARATI -- ognuno con la sua fonte, aperta e citata.
#  Sono INGRESSI, non risultati: nessun rapporto e nessun verdetto di
#  questo file e' copiato da qualche parte, tutti si calcolano sotto.
# =====================================================================

# Spread dichiarati che NON stanno nei CSV orari dei tre indici.
#   valore, unita' di prezzo del simbolo, fonte
SPREAD_DICHIARATI = {
    "XAUUSD_S1": (0.16, "report/ORO_1530_CANCELLO_COSTO_2026-09-10.md S2.1 -- 17/08 17:34 srv, ora liquida"),
    "XAUUSD_S2": (0.22, "report/ORO_1530_CANCELLO_COSTO_2026-09-10.md S2.1 -- 27/08 ~08:5x srv, la piu' prudente"),
    "225JPY": (35.0, "sonda InfoBroker 17/08 17:34 srv, SpreadPt=35 (Point=1) -- LETTURA UNICA, fuori sessione Tokyo"),
}

# Ore modali misurate dai trade veri -- CANCELLO_COSTO_FLOTTA S4.1 r.324.
# Qui servono solo a scegliere la riga giusta del CSV orario.
ORA_MODALE = {
    "770101": ("D30EUR", 8), "770411": ("D30EUR", 8), "970912": ("D30EUR", 8),
    "770202": ("U30USD", 15), "770611": ("U30USD", 14), "771531": ("U30USD", 17),
    "770531": ("U30USD", 14), "772341": ("U30USD", 7), "772234": ("U30USD", 1),
    "970913": ("NASUSD", 15), "770250": ("NASUSD", 14),
}
# 770511 e 771321: nessuna moda misurata. Il referto usa la "riga TUTTO"
# = 2,00 (r.403 e r.409). Quel numero NON si ricostruisce dal CSV orario
# (che ha solo mediane per ora: la mediana di 24 mediane non e' la
# mediana di niente), quindi si DICHIARA come ingresso con la sua fonte.
# >>> CORRETTO PRIMA DELLA CONSEGNA: la v1 ci metteva la PEGGIORE delle
# ore (2,80). Peggiorava il numero di 770511 da 38,5x a 27,5x -- cioe'
# cambiava il DENOMINATORE per un motivo che non c'entra niente con la
# domanda di questo file. Su U30USD la commissione e' 0,0000, quindi
# quella scelta non toccava nemmeno il confronto fra le due unita':
# aggiungeva solo un secondo effetto sopra quello da misurare.
SPREAD_RIGA_TUTTO = {
    "770511": (2.00, 2.80, "referto r.403: riga TUTTO, ora sparsa 03-20"),
    "771321": (2.00, 3.00, "referto r.409: riga TUTTO"),
}

# --- LE SEDIE ---------------------------------------------------------
#  (magic, EA, simbolo, TF, stop_lo, stop_hi, tag, fonte_dello_stop)
#  stop_lo == stop_hi  -> numero secco;  diversi -> banda;  None -> [NM]
SEDIE = [
    # ---- INDICI (referto S5.1, tabella r.394, denominatore: SPREAD) ----
    ("770101", "DAX_Apertura_EU", "D30EUR", "M5", 71.9, 71.9, "MIS",
     "trades_auto.csv, 7 gambe sl in perdita (referto r.396)"),
    ("770202", "Dow_Apertura_US", "U30USD", "M5", 123.8, 123.8, "MIS",
     "referto r.399, correzione 18/09 sera: n=446"),
    ("770611", "ORB_Ottimizzato", "U30USD", "M5", 59.0, 59.0, "MIS",
     "trades_auto.csv, 7 gambe (referto r.400)"),
    ("770511", "SuperWave_DOW_H1_Ott", "U30USD", "H1", 77.1, 77.1, "MIS",
     "trades_auto.csv, 4 gambe (referto r.403)"),
    ("770531", "SuperWave", "U30USD", "H4", 295.5, 295.5, "MIS",
     "trades_auto.csv, 8 gambe (referto r.404)"),
    ("771531", "EMA200", "U30USD", "H1", 104.3, 104.3, "MIS",
     "trades_auto.csv, 8 gambe (referto r.405)"),
    ("772341", "PunteLarry", "U30USD", "H1", 274.2, 274.2, "MIS",
     "trades_auto.csv, 2 gambe (referto r.406)"),
    ("772234", "GapFill", "U30USD", "H1", 98.0, 98.0, "MIS",
     "trades_auto.csv, 1 gamba (referto r.408)"),
    ("771321", "PTE", "U30USD", "H1", 78.05, 88.25, "MIS",
     "referto r.409, correzione 18/09 sera: banda ATR(14) H1 misurata"),
    ("970912", "SupRev_DAX_H4_Ott", "D30EUR", "H4", 47.0, 313.0, "NM",
     "referto r.410 corretto 18/09 sera: banda 47-313, nessun trade mai"),
    ("970913", "SupRev_NAS_H1_Ott", "NASUSD", "H1", 27.10, 27.10, "MIS",
     "referto r.411 corretto 18/09 sera: n=5, gamba nuova 11/09"),
    ("770411", "MaxMinNotte_DAX_Short_Ott", "D30EUR", "M15", 64.2, 87.5, "NM",
     "referto r.412 corretto 18/09 sera: banda, non una misura"),
    ("770250", "Nasdaq_Apertura_US_GatedShort", "NASUSD", "M15", 83.2, 83.2, "INF",
     "referto r.413 corretto 18/09 sera: 1 trade il 15/09, ora 14"),

    # ---- ORO (referto S5.2, tabella r.460, denominatore: SPREAD+COMM) ---
    ("770402", "MaxMinNotte", "XAUUSD", "H2", 32.94, 32.94, "MIS",
     "trades_auto.csv, 2 gambe (referto r.462)"),
    ("971501", "EMA200_Ottimizzato", "XAUUSD", "H4", 42.28, 42.28, "MIS",
     "trades_auto.csv, 4 gambe (referto r.463)"),
    ("970901", "SupertrendReversal_Ott", "XAUUSD", "H4", 35.31, 35.31, "INF",
     "gemello 770901 XAUUSD n=3 (referto r.464)"),
    ("772343", "PunteLarry", "XAUUSD", "H1", 61.48, 61.48, "MIS",
     "trades_auto.csv, 1 gamba (referto r.465)"),
    ("250604", "Gold_Ichimoku_TK_ATR", "XAUUSD", "M5", 7.22, 7.22, "MIS",
     "trades_auto.csv, 2 gambe (referto r.466) -- gira su TICKMILL, non BCM"),

    # ---- NIKKEI (referto S5.3, tabella r.485, denominatore: SPREAD) -----
    ("770924", "SupertrendReversal", "225JPY", "H2", 477.0, 477.0, "MIS",
     "trades_auto.csv, 1 gamba (referto r.487)"),
    ("770901n", "SupertrendReversal (100k)", "225JPY", "H2", 477.0, 477.0, "INF",
     "stessa geometria della gemella 770924 (referto r.488)"),
    ("774101", "GapContinuation", "225JPY", "M1", 479.0, 479.0, "MIS",
     "trades_auto.csv, 1 gamba (referto r.489)"),
    ("772235", "GapFill", "225JPY", "H1", None, None, "NM",
     "0 gambe in stop (referto r.490)"),

    # ---- FOREX (referto S5.4, tabella r.518, denominatore: SPREAD nudo) --
    ("772422", "EasyTrend", "GBPUSD", "H1", 35.0, 35.0, "MIS",
     "trades_auto.csv, 1 gamba (referto r.520)"),
    ("772421", "EasyTrend", "CHFJPY", "H1", 47.0, 47.0, "MIS",
     "trades_auto.csv, 2 gambe (referto r.521)"),
    ("772361", "CostToCost", "EURJPY", "H4", 29.2, 29.2, "MIS",
     "trades_auto.csv, 3 gambe (referto r.522)"),
    ("772362", "CostToCost", "GBPCAD", "H4", 38.9, 38.9, "MIS",
     "trades_auto.csv, 2 gambe (referto r.523)"),
    ("772162", "BreakingBand", "EURUSD", "H1", 22.1, 22.1, "MIS",
     "trades_auto.csv, 1 gamba (referto r.524)"),
    ("772342", "PunteLarry", "EURAUD", "H1", 35.6, 35.6, "MIS",
     "trades_auto.csv, 2 gambe (referto r.530)"),
    ("772344", "PunteLarry", "GBPJPY", "H1", 58.6, 58.6, "MIS",
     "trades_auto.csv, 1 gamba (referto r.531)"),
    ("771201", "PostNews (ECB)", "EURJPY", "M5", 25.0, 25.0, "DIC",
     "InpSLpips=25.0 dichiarato, ABTG_PostNews.mq5 r.98 (referto r.536)"),
    ("771201t", "PostNews (ECB) dopo il trail", "EURJPY", "M5", 15.0, 15.0, "DIC",
     "InpUseTrail25 porta lo SL a 15 pip, ABTG_PostNews.mq5 r.105 (referto r.537)"),
    ("771202", "PostNews (FOMC)", "EURUSD", "M5", 25.0, 25.0, "DIC",
     "InpSLpips=25.0 dichiarato (referto r.538)"),
    ("771203", "PostNews", "USDJPY", "M5", 25.0, 25.0, "DIC",
     "InpSLpips=25.0 dichiarato (referto r.539)"),
]

# Le sedie forex senza stop misurato restano fuori dalla tabella dei
# rapporti: non hanno numeratore, e un rapporto senza numeratore non e'
# un verdetto piu' prudente, e' un numero inventato.
FOREX_SENZA_STOP = ["772161 BreakingBand GBPUSD H1", "772163 BreakingBand AUDUSD H1",
                    "772231 GapFill GBPUSD H1", "772232 GapFill EURUSD H1",
                    "772233 GapFill AUDUSD H1", "772345 PunteLarry GBPUSD H1",
                    "772346 PunteLarry EURCAD H1", "771322 PTE GBPUSD H1",
                    "771332 PTE GBPUSD H1", "772235 GapFill 225JPY H1",
                    "BREAKOUT_EA_JPY_v3 USDJPY M15"]

INDICI = ("D30EUR", "U30USD", "NASUSD", "225JPY", "SPXUSD", "F40EUR", "USOIL")


# =====================================================================
#  LETTORI
# =====================================================================

def leggi_sonda(percorso=SONDA):
    """Blocco [SIMBOLI] della sonda: Point, ContractSize, TickValue,
    TickSize, SpreadPt. E' l'unico posto in cui si legge la geometria di
    un simbolo: niente costanti scritte a mano nel codice."""
    out = {}
    if not os.path.isfile(percorso):
        return out
    with open(percorso, "r") as fh:
        righe = list(csv.reader(fh))
    dentro = False
    hdr = None
    for r in righe:
        if not r:
            continue
        if r[0].startswith("["):
            dentro = (r[0].strip() == "[SIMBOLI]")
            hdr = None
            continue
        if not dentro:
            continue
        if hdr is None:
            hdr = r
            continue
        if len(r) != len(hdr):
            continue
        d = dict(zip(hdr, r))
        try:
            out[d["Simbolo"]] = {
                "digits": int(d["Digits"]),
                "point": float(d["Point"]),
                "contract": float(d["ContractSize"]),
                "tickvalue": float(d["TickValue"]),
                "ticksize": float(d["TickSize"]),
                "spreadpt": float(d["SpreadPt"]),
            }
        except (ValueError, KeyError):
            continue
    return out


def unita_di_prezzo(sim, geo):
    """Quanto vale, in prezzo, UNA unita' di misura del simbolo.

    Forex: il PIP = 10 x Point (Digits 5 o 3).  Indici e metalli: la
    misura di casa e' il PUNTO INDICE / il DOLLARO di prezzo, cioe' 1,0.
    Non e' una convenzione inventata qui: e' quella con cui il referto
    scrive 71,9 sul DAX (prezzi 25.018,00) e 32,94 sull'oro.
    """
    if sim in COPPIE:
        return COPPIE[sim][2]          # pip_size dichiarato dal modulo forex
    if geo["digits"] in (3, 5) and geo["contract"] >= 100000.0:
        return geo["point"] * 10.0     # forex non in tabella: pip = 10 point
    return 1.0                          # indici, oro, argento: 1 punto/1 $


def commissioni_misurate(percorso=TRADES):
    """Commissione per LOTTO, giro completo, per simbolo -- dai deal veri.

    Ritorna {simbolo: (mediana, n, n_valori_distinti, minimo, massimo)}.
    Mediana e non media: una media si sposta con un solo deal grosso.
    """
    d = {}
    if not os.path.isfile(percorso):
        return d
    with open(percorso, "r") as fh:
        for rec in csv.DictReader(fh, delimiter=";"):
            try:
                vol = float(rec["volume"])
                com = float(rec["commission"])
            except (ValueError, KeyError, TypeError):
                continue
            if vol <= 0:
                continue
            d.setdefault(rec["symbol"], []).append(abs(com) / vol)
    out = {}
    for sim, v in d.items():
        out[sim] = (statistics.median(v), len(v),
                    len(set(round(x, 4) for x in v)), min(v), max(v))
    return out


def stop_misurati(geo, percorso=TRADES):
    """Mediana della distanza |close-open| delle gambe chiuse in `sl` e
    in perdita, per (magic, simbolo). E' la stessa ricetta del referto
    del 10/09 (S2.1), rifatta qui sui dati di OGGI.

    >>> CORRETTO PRIMA DELLA CONSEGNA: la v1 lasciava la distanza in
    PREZZO e la confrontava con uno stop in PIP. Su GBPUSD dava 0,003
    contro 35,0 e stampava "-100%" su ogni riga forex: uno scarto del
    100% su OGNI riga di una classe non e' un ritrovamento, e' un bug di
    unita'. Qui la distanza si divide per l'unita' del simbolo.
    """
    d = {}
    if not os.path.isfile(percorso):
        return d
    with open(percorso, "r") as fh:
        for rec in csv.DictReader(fh, delimiter=";"):
            try:
                if rec["close_reason"] != "sl" or float(rec["profit"]) >= 0:
                    continue
                dist = abs(float(rec["close_price"]) - float(rec["open_price"]))
            except (ValueError, KeyError, TypeError):
                continue
            sim = rec["symbol"]
            g = geo.get(sim)
            if g is None:
                continue
            d.setdefault((rec["magic"], sim), []).append(
                dist / unita_di_prezzo(sim, g))
    return dict((k, (statistics.median(v), len(v))) for k, v in d.items())


def spread_orario(simbolo, ora=None, cartella=SPREAD_DIR):
    """Mediana e P95 dello spread di un'ora, dai CSV a tick dei tre
    indici. Con ora=None ritorna la MEDIANA DELLE ORE pesata sui tick
    (riga 'TUTTO' ricostruita: la media di 24 mediane non sarebbe la
    mediana di niente, quindi si prende la peggiore delle ore)."""
    p = os.path.join(cartella, "spread_orario_%s.csv" % simbolo)
    if not os.path.isfile(p):
        return None, None
    righe = []
    with open(p, "r") as fh:
        for rec in csv.DictReader(fh):
            try:
                righe.append((int(rec["ora_server"]),
                              float(rec["mediana_idx"]),
                              float(rec["p95_idx"]),
                              int(rec["tick_ask_usabili"])))
            except (ValueError, KeyError, TypeError):
                continue
    if not righe:
        return None, None
    if ora is None:
        # nessuna moda: si usa il valore PIU' SFAVOREVOLE fra le ore di
        # cassa, non una media. Dichiarato, non nascosto.
        med = max(r[1] for r in righe if 1 <= r[0] <= 21)
        p95 = max(r[2] for r in righe if 1 <= r[0] <= 21)
        return med, p95
    for r in righe:
        if r[0] == ora:
            return r[1], r[2]
    return None, None


# =====================================================================
#  IL CONTO
# =====================================================================

def comm_in_unita(sim, geo, comm_eur_lotto):
    """Commissione per lotto (EUR) -> unita' di prezzo del simbolo.

    UNA formula per tutti i simboli, e sta tutta qui:
        valore di 1 unita' di prezzo, per lotto, in EUR
            = TickValue / TickSize * unita
        commissione in unita' = comm_EUR / quel valore
    Non c'e' nessun caso speciale per l'oro o per gli indici: la
    differenza la fa il TickValue del simbolo, che e' un dato letto.
    """
    if geo is None or comm_eur_lotto is None:
        return None
    u = unita_di_prezzo(sim, geo)
    eur_per_unita = (geo["tickvalue"] / geo["ticksize"]) * u
    if eur_per_unita <= 0:
        return None
    return comm_eur_lotto / eur_per_unita


def verdetto(rapporto):
    if rapporto is None:
        return "NM"
    if rapporto < PAVIMENTO_DURO:
        return "SFONDA"
    if rapporto < PAVIMENTO_LAVORO:
        return "NO"
    return "PASS"


def margine(rapporto):
    if rapporto is None:
        return ""
    if rapporto >= PAVIMENTO_LAVORO:
        return "+%.0f%%" % (100.0 * (rapporto / PAVIMENTO_LAVORO - 1.0))
    return "%.0f%%" % (100.0 * rapporto / PAVIMENTO_LAVORO)


# =====================================================================
#  AUTOTEST -- si prova a ROMPERE
# =====================================================================

def autotest():
    print("AUTOTEST -- si prova a ROMPERE il conto, non a confermarlo")
    print("")
    rossi = 0
    geo = leggi_sonda()
    comm = commissioni_misurate()

    # -- 1. la commissione degli indici deve essere ZERO ESATTO --------
    #  Se non lo fosse, la tesi centrale di questo file ("sugli indici le
    #  due unita' coincidono") cadrebbe. Si controlla che sia UN SOLO
    #  valore distinto, non che la media sia piccola.
    print("  1) INDICI: la commissione deve essere 0,0000 ESATTI, valore UNICO")
    tot = 0
    ok1 = True
    for sim in INDICI:
        if sim not in comm:
            continue
        med, n, dist, mn, mx = comm[sim]
        tot += n
        buono = (dist == 1 and mn == 0.0 and mx == 0.0)
        ok1 = ok1 and buono
        print("     %s %-7s n=%3d  distinti=%d  min=%.4f max=%.4f"
              % ("VERDE " if buono else "ROSSO ", sim, n, dist, mn, mx))
    print("     -> %d deal in totale" % tot)
    if not ok1:
        rossi += 1

    # -- 2. la commissione forex NON deve essere zero ------------------
    #  Il contro-esempio del blocco 1: se il lettore dicesse zero a
    #  TUTTI, il blocco 1 passerebbe senza misurare niente.
    print("")
    print("  2) CONTRO-ESEMPIO del blocco 1: sul FOREX deve NON essere zero")
    ok2 = True
    for sim in ("EURUSD", "GBPUSD", "USDJPY", "EURJPY"):
        if sim not in comm:
            print("     ROSSO  %s assente dai deal" % sim)
            ok2 = False
            continue
        med, n, dist, mn, mx = comm[sim]
        buono = med > 0.0
        ok2 = ok2 and buono
        print("     %s %-7s mediana %.4f EUR/lotto  n=%3d"
              % ("VERDE " if buono else "ROSSO ", sim, med, n))
    if not ok2:
        rossi += 1

    # -- 3. due strade indipendenti per la commissione in pip ----------
    #  A) misurata: EUR/lotto dai deal / TickValue della sonda
    #  B) legge   : 4,0 unita' di valuta BASE / cambi incrociati
    #  Gli ingressi NON sono gli stessi (A non usa nessun cambio
    #  incrociato, B non usa nessun deal). Se divergessero, una delle due
    #  sarebbe sbagliata.
    print("")
    print("  3) DUE STRADE per la commissione in pip -- devono tornare (<=3%)")
    if commissione_pip is None:
        print("     ROSSO  calcola_pedaggio_forex non importabile")
        rossi += 1
    else:
        ok3 = True
        for sim in ("EURUSD", "GBPUSD", "USDJPY", "EURJPY", "GBPCAD", "CHFJPY"):
            if sim not in comm or sim not in geo:
                continue
            a = comm_in_unita(sim, geo[sim], comm[sim][0])
            b, _ = commissione_pip(sim)
            if a is None or b is None:
                continue
            scarto = 100.0 * abs(a - b) / b
            buono = scarto <= 3.0
            ok3 = ok3 and buono
            print("     %s %-7s misurata %.4f pip  legge %.4f pip  scarto %.2f%%"
                  % ("VERDE " if buono else "ROSSO ", sim, a, b, scarto))
        if not ok3:
            rossi += 1

    # -- 4. l'ancora dell'oro scritta da un'ALTRA sessione --------------
    #  Atteso DICHIARATO PRIMA: 0,0403 $ (ORO_1530_CANCELLO_COSTO S2.4).
    #  Il conto qui non passa da quel numero: parte dai deal e dal
    #  TickValue.
    print("")
    print("  4) ANCORA ESTERNA: la commissione dell'oro deve dare 0,0403 $")
    if "XAUUSD" in comm and "XAUUSD" in geo:
        got = comm_in_unita("XAUUSD", geo["XAUUSD"], comm["XAUUSD"][0])
        buono = abs(got - 0.0403) <= 0.0005
        print("     %s XAUUSD  %.5f $ di prezzo  (atteso 0,0403 +-0,0005)"
              % ("VERDE " if buono else "ROSSO ", got))
        print("            atteso scritto da ORO_1530_CANCELLO_COSTO S2.4,")
        print("            sessione diversa, ingressi diversi.")
        if not buono:
            rossi += 1
    else:
        print("     ROSSO  XAUUSD assente")
        rossi += 1

    # -- 5. lo spread orario deve riprodurre i numeri di R125 ----------
    #  Atteso DICHIARATO PRIMA: R125_ORB_COSTO_CRITERI S2 --
    #  U30USD h14 = 2,00 | NASUSD h14 = 1,80 | D30EUR h8 = 1,70.
    print("")
    print("  5) SPREAD ORARIO: deve riprodurre la tabella di R125 S2")
    attesi = (("U30USD", 14, 2.00), ("NASUSD", 14, 1.80), ("D30EUR", 8, 1.70))
    ok5 = True
    for sim, ora, att in attesi:
        med, p95 = spread_orario(sim, ora)
        buono = med is not None and abs(med - att) <= 0.005
        ok5 = ok5 and buono
        print("     %s %-7s ora %2d  mediana %s  (atteso %.2f)"
              % ("VERDE " if buono else "ROSSO ", sim, ora,
                 ("%.2f" % med) if med is not None else "n/d", att))
    if not ok5:
        rossi += 1

    print("")
    if rossi:
        print("  ROSSI: %d" % rossi)
    else:
        print("  TUTTO VERDE.")
    print("")
    return rossi


# =====================================================================
#  TABELLA
# =====================================================================

def spread_della_sedia(magic, sim, geo, variante):
    """(valore, etichetta) dello spread da usare per questa sedia.

    variante: 'mediana' | 'coda' | 'prudente'
      - tre indici: dai CSV a tick, all'ora modale misurata;
      - oro: S1/S2 dichiarati;
      - tutto il resto: sonda istantanea del 17/08, e con 'prudente'
        la colonna B da 1,0 pip del referto.
    """
    if sim in ("D30EUR", "U30USD", "NASUSD"):
        if magic in ORA_MODALE:
            ora = ORA_MODALE[magic][1]
            med, p95 = spread_orario(sim, ora)
            et = "tick, ora %02d" % ora
        elif magic in SPREAD_RIGA_TUTTO:
            med, p95, et = SPREAD_RIGA_TUTTO[magic]
        else:
            med, p95 = spread_orario(sim, None)
            et = "tick, peggiore delle ore (nessuna moda)"
        return ((p95 if variante == "coda" else med), et)
    if sim == "XAUUSD":
        v, f = SPREAD_DICHIARATI["XAUUSD_S1" if variante == "coda" else "XAUUSD_S2"]
        return (v, "S1 favorevole" if variante == "coda" else "S2 prudente")
    if sim == "225JPY":
        return (SPREAD_DICHIARATI["225JPY"][0], "sonda 17/08, lettura unica")
    # forex
    if variante == "prudente":
        return (1.0, "colonna B: 1,0 pip prudente (referto S5.4)")
    if sim in geo:
        pt = geo[sim]["spreadpt"]
        if pt <= 0:
            return (None, "sonda 17/08: SpreadPt=0 = ILLEGGIBILE")
        return (pt * geo[sim]["point"] / unita_di_prezzo(sim, geo[sim]),
                "sonda 17/08, lettura unica")
    return (None, "nessuno spread in archivio")


def costruisci(variante="mediana"):
    geo = leggi_sonda()
    comm = commissioni_misurate()
    stop_ric = stop_misurati(geo)
    righe = []
    for (magic, ea, sim, tf, lo, hi, tag, fonte) in SEDIE:
        g = geo.get(sim)
        cm = comm.get(sim)
        c_unita = comm_in_unita(sim, g, cm[0]) if (g and cm) else None
        spr, spr_et = spread_della_sedia(magic, sim, geo, variante)
        pieno = (spr + c_unita) if (spr is not None and c_unita is not None) else None

        def rap(x, den):
            if x is None or den is None or den <= 0:
                return None
            return x / den

        r_lo_s, r_hi_s = rap(lo, spr), rap(hi, spr)
        r_lo_p, r_hi_p = rap(lo, pieno), rap(hi, pieno)
        # verdetto della banda: se i due estremi non concordano -> FRAGILE
        def v_banda(a, b):
            if a is None:
                return "NM"
            va, vb = verdetto(a), verdetto(b)
            return va if va == vb else "FRAGILE"

        # le righe-variante (suffisso 't' = dopo il trailing) non hanno
        # un magic proprio nei deal: il confronto col ricalcolo non si fa,
        # invece di farlo contro la riga sbagliata.
        ric = None if magic[-1] in "tn" else stop_ric.get((magic, sim))
        righe.append({
            "magic": magic, "ea": ea, "sim": sim, "tf": tf,
            "lo": lo, "hi": hi, "tag": tag, "fonte": fonte,
            "spread": spr, "spread_et": spr_et,
            "comm": c_unita,
            "comm_eur": cm[0] if cm else None,
            "comm_n": cm[1] if cm else None,
            "comm_dist": cm[2] if cm else None,
            "pieno": pieno,
            "r_s_lo": r_lo_s, "r_s_hi": r_hi_s,
            "r_p_lo": r_lo_p, "r_p_hi": r_hi_p,
            "v_s": v_banda(r_lo_s, r_hi_s),
            "v_p": v_banda(r_lo_p, r_hi_p),
            "ric": ric,
        })
    return righe


def fmt_rap(lo, hi):
    if lo is None:
        return "[NM]"
    if abs(lo - hi) < 1e-9:
        return "%.1fx" % lo
    return "%.1f-%.1fx" % (lo, hi)


def stampa_tabella(righe, variante):
    print("")
    print("=" * 118)
    print("IL CANCELLO DI COSTO NELLE DUE UNITA'  --  variante spread: %s" % variante.upper())
    print("pavimenti (di Claudio, non toccati): LAVORO 40x  --  DURO 13,3x")
    print("=" * 118)
    print("%-9s %-26s %-7s %-4s %9s %8s %8s %9s %11s %-8s %11s %-8s"
          % ("magic", "EA", "simb", "TF", "stop", "spread", "comm",
             "costo p.", "stop/spr", "40x?", "stop/costo", "40x?"))
    print("-" * 118)
    for r in righe:
        stop = "[NM]" if r["lo"] is None else (
            "%.2f" % r["lo"] if abs(r["lo"] - r["hi"]) < 1e-9
            else "%.0f-%.0f" % (r["lo"], r["hi"]))
        print("%-9s %-26s %-7s %-4s %9s %8s %8s %9s %11s %-8s %11s %-8s"
              % (r["magic"], r["ea"][:26], r["sim"], r["tf"],
                 stop + " [" + r["tag"] + "]" if r["lo"] is not None else stop,
                 "%.3f" % r["spread"] if r["spread"] is not None else "n/d",
                 "%.4f" % r["comm"] if r["comm"] is not None else "n/d",
                 "%.3f" % r["pieno"] if r["pieno"] is not None else "n/d",
                 fmt_rap(r["r_s_lo"], r["r_s_hi"]), r["v_s"],
                 fmt_rap(r["r_p_lo"], r["r_p_hi"]), r["v_p"]))
    print("-" * 118)


def stampa_cambi(righe, variante):
    cambia = [r for r in righe if r["v_s"] != r["v_p"] and r["v_s"] != "NM"]
    print("")
    print("### LE SEDIE CHE CAMBIANO VERDETTO -- variante %s" % variante.upper())
    if not cambia:
        print("    NESSUNA.")
    for r in cambia:
        print("  %-9s %-24s %-7s %-4s   %s %s  ->  %s %s"
              % (r["magic"], r["ea"][:24], r["sim"], r["tf"],
                 fmt_rap(r["r_s_lo"], r["r_s_hi"]), r["v_s"],
                 fmt_rap(r["r_p_lo"], r["r_p_hi"]), r["v_p"]))
    uguali = [r for r in righe if r["v_s"] == r["v_p"] and r["comm"] == 0.0]
    print("")
    print("  E le %d sedie con commissione MISURATA 0,0000: le due letture"
          % len(uguali))
    print("  sono LO STESSO NUMERO, non due numeri vicini. Elenco per nome:")
    print("    " + ", ".join(r["magic"] for r in uguali))
    print("")


def stampa_divergenze_stop(righe):
    print("")
    print("### CONTROLLO: lo STOP ricalcolato OGGI contro quello del referto")
    print("    (i verdetti sopra NON lo usano -- vedi la nota in testa al file)")
    print("  %-9s %-7s %10s %14s %8s" % ("magic", "simb", "referto", "ricalcolato", "scarto"))
    for r in righe:
        if r["ric"] is None or r["lo"] is None:
            continue
        med, n = r["ric"]
        centro = (r["lo"] + r["hi"]) / 2.0
        sc = 100.0 * (med - centro) / centro if centro else 0.0
        segna = "  <== DIVERGE" if abs(sc) > 5.0 else ""
        print("  %-9s %-7s %10.3f %10.3f n=%2d %7.1f%%%s"
              % (r["magic"], r["sim"], centro, med, n, sc, segna))
    print("")


# =====================================================================
#  LE ESCLUSIONI PER COSTO GIA' PRONUNCIATE, RILETTE NELLE DUE UNITA'
# =====================================================================
#  (etichetta, simbolo, stop, tag, fonte, spread, etichetta dello spread)
CASI = [
    ("EURUSD H1 -- ATR(14) H1 ~18,0 pip", "EURUSD", 18.0, "DER",
     "REGISTRO_TEST.md r.2394-2397: ATR(14) M15 = 9,00 pip (ancora Oanda) x sqrt(60/15)",
     None, "sonda 17/08 (SpreadPt=4)"),
    ("EURUSD H4 -- ancora A, Oanda M15 x4", "EURUSD", 36.0, "DER",
     "REGISTRO_TEST.md r.2397, stessa ancora Oanda",
     None, "sonda 17/08 (SpreadPt=4)"),
    ("EURUSD H4 -- ancora B, 772162 su BCM x2", "EURUSD", 14.7, "DER",
     "AUDJPY_E_GBPUSD... r.517: ATR H1 = 22,1/3,0 = 7,37 -> H4 ~14,7",
     None, "sonda 17/08 (SpreadPt=4)"),
    ("770611 ORB U30USD M5 -- mediana ora 14", "U30USD", 59.0, "MIS",
     "trades_auto.csv, 7 gambe", 2.00, "tick, ora 14 (referto)"),
    ("770611 ORB U30USD M5 -- coda P95 ora 14", "U30USD", 59.0, "MIS",
     "trades_auto.csv, 7 gambe", 3.00, "tick P95, ora 14"),
    ("770901 SupRev 225JPY H2", "225JPY", 477.0, "INF",
     "geometria della gemella 770924", 35.0, "sonda 17/08, lettura unica"),
]


def stampa_casi():
    geo = leggi_sonda()
    comm = commissioni_misurate()
    print("")
    print("### LE ESCLUSIONI PER COSTO GIA' PRONUNCIATE, RILETTE IN DUE UNITA'")
    print("")
    print("  %-42s %8s %8s %8s %10s %-7s %10s %-7s"
          % ("caso", "stop", "spread", "comm", "stop/spr", "40x?",
             "stop/costo", "40x?"))
    print("  " + "-" * 104)
    for (et, sim, stop, tag, fonte, spr, spr_et) in CASI:
        g = geo.get(sim)
        cm = comm.get(sim)
        c = comm_in_unita(sim, g, cm[0]) if (g and cm) else None
        if spr is None and g is not None:
            spr = g["spreadpt"] * g["point"] / unita_di_prezzo(sim, g)
        pieno = spr + c if (spr is not None and c is not None) else None
        rs = stop / spr if spr else None
        rp = stop / pieno if pieno else None
        print("  %-42s %8.2f %8.3f %8.4f %9.1fx %-7s %9.1fx %-7s"
              % (et[:42], stop, spr, c, rs, verdetto(rs), rp, verdetto(rp)))
    print("")
    print("  ### IL FATTORE DI AMPLIFICAZIONE -- quante volte il costo pieno")
    print("      vale lo spread, simbolo per simbolo (e' il numero del punto 1")
    print("      di Garbuglia, ricalcolato sui NOSTRI spread misurati)")
    print("")
    print("  %-8s %8s %8s %9s %10s %14s"
          % ("simb", "spread", "comm", "costo p.", "pieno/spr", "40x spr vale"))
    print("  " + "-" * 62)
    for sim in ("EURUSD", "GBPUSD", "USDJPY", "EURJPY", "GBPCAD", "XAUUSD",
                "D30EUR", "U30USD", "NASUSD", "225JPY"):
        g = geo.get(sim)
        cm = comm.get(sim)
        if g is None or cm is None:
            continue
        c = comm_in_unita(sim, g, cm[0])
        if sim == "XAUUSD":
            spr = SPREAD_DICHIARATI["XAUUSD_S2"][0]
        elif sim in ("D30EUR", "U30USD", "NASUSD"):
            spr, _ = spread_orario(sim, 8 if sim == "D30EUR" else 14)
        else:
            spr = g["spreadpt"] * g["point"] / unita_di_prezzo(sim, g)
        if not spr:
            continue
        amp = (spr + c) / spr
        print("  %-8s %8.3f %8.4f %9.3f %9.2fx %11.1fx"
              % (sim, spr, c, spr + c, amp, PAVIMENTO_LAVORO / amp))
    print("")
    print("  L'ultima colonna e' la traduzione del pavimento: un 40x letto in")
    print("  SPREAD vale quel numero se lo si rilegge in COSTO PIENO.")
    print("  Sotto 13,3 vorrebbe dire che il 40x in spread e' piu' permissivo")
    print("  del pavimento DURO in costo pieno.")
    print("")


def main():
    ap = argparse.ArgumentParser(
        description="Il cancello di costo letto in SPREAD e in COSTO PIENO.")
    ap.add_argument("--autotest", action="store_true",
                    help="prova a rompere il conto ed esce")
    ap.add_argument("--variante", choices=("mediana", "coda", "prudente"),
                    default="mediana",
                    help="quale spread: mediana dell'ora (default), coda "
                         "(P95/S1), prudente (forex a 1,0 pip)")
    ap.add_argument("--tutte", action="store_true",
                    help="stampa tutte e tre le varianti")
    ap.add_argument("--casi", action="store_true",
                    help="rilegge le esclusioni per costo gia' pronunciate")
    ap.add_argument("--md", action="store_true",
                    help="stampa la tabella in markdown, pronta per il referto")
    args = ap.parse_args()

    rossi = autotest()
    if args.autotest:
        return 1 if rossi else 0
    if rossi:
        print("FERMO: l'autotest e' ROSSO, non stampo verdetti.")
        return 1

    if args.casi:
        stampa_casi()
        return 0

    varianti = ("mediana", "coda", "prudente") if args.tutte else (args.variante,)
    for v in varianti:
        righe = costruisci(v)
        if args.md:
            stampa_md(righe, v)
        else:
            stampa_tabella(righe, v)
            stampa_cambi(righe, v)
    if not args.md:
        stampa_divergenze_stop(costruisci("mediana"))
        print("SEDIE SENZA STOP MISURATO -- nessun rapporto, in nessuna unita':")
        for s in FOREX_SENZA_STOP:
            print("  - %s" % s)
        print("")
        print("COSA QUESTO CONTO NON COPRE: slippage, requote, rifiuti, swap,")
        print("e l'esecuzione della prop vera. Copre spread + commissione.")
    return 0


def stampa_md(righe, variante):
    print("")
    print("**Variante spread: %s**" % variante.upper())
    print("")
    print("| magic | EA | simb | TF | stop | spread | comm | costo pieno | "
          "`stop/spread` | 40x? | `stop/costo pieno` | 40x? | 13,3x (costo)? |")
    print("|---|---|---|---|---:|---:|---:|---:|---:|:---:|---:|:---:|:---:|")
    for r in righe:
        stop = "[NM]" if r["lo"] is None else (
            "%.2f" % r["lo"] if abs(r["lo"] - r["hi"]) < 1e-9
            else "%.1f-%.1f" % (r["lo"], r["hi"]))
        duro = "-"
        if r["r_p_lo"] is not None:
            duro = ("SI" if min(r["r_p_lo"], r["r_p_hi"]) >= PAVIMENTO_DURO
                    else ("NO" if max(r["r_p_lo"], r["r_p_hi"]) < PAVIMENTO_DURO
                          else "BANDA"))
        print("| `%s` | %s | %s | %s | %s `[%s]` | %s | %s | %s | **%s** | %s | **%s** | %s | %s |"
              % (r["magic"], r["ea"], r["sim"], r["tf"], stop, r["tag"],
                 "%.3f" % r["spread"] if r["spread"] is not None else "n/d",
                 "%.4f" % r["comm"] if r["comm"] is not None else "n/d",
                 "%.3f" % r["pieno"] if r["pieno"] is not None else "n/d",
                 fmt_rap(r["r_s_lo"], r["r_s_hi"]), r["v_s"],
                 fmt_rap(r["r_p_lo"], r["r_p_hi"]), r["v_p"], duro))
    print("")


if __name__ == "__main__":
    sys.exit(main())
