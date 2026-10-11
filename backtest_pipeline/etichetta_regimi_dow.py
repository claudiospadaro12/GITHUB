#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# =====================================================================
#  etichetta_regimi_dow.py -- ETICHETTATURA DEI REGIMI sul CSV H1 del
#                             Dow BCM (U30USD), regola DK, finestre
#                             dichiarate. SOLA LETTURA.
# ---------------------------------------------------------------------
#  Stato: BOZZA, NON passata dal cancello (11/10/2026).
#  Perimetro: legge UN solo CSV (SHA256 fissato qui sotto), non scrive
#  niente salvo, a richiesta, un testo su stdout. NON giudica il merito
#  di EMA200 (nessun PF, nessun trade letto): etichetta il MERCATO.
#  Non tocca forward, sedie, terminali, preset, conti.
#
#  Scritto PRIMA dei numeri: le sezioni (1)-(4) qui sotto sono nel file
#  prima che il file abbia mai stampato un'etichetta sul CSV vero.
#  (Del CSV avevo visto prima di scrivere SOLO la struttura: intestazione,
#  prima barra 2024.09.26 16:00, distribuzione oraria, buchi fra barre.
#  Nessun rendimento, nessun drawdown, nessuna etichetta di finestra.)
#
# =====================================================================
#  (1) LA REGOLA ESATTA, COPIATA DALLA FONTE
# ---------------------------------------------------------------------
#  FONTE PRIMARIA ("regola DK", D-I):
#    report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md  riga 58
#    (sezione 1.3, "Regola di etichettatura, scritta ora"). Testo:
#      "...si calcolano sulle chiusure H1 del feed DK il rendimento
#       buy&hold della finestra e il suo massimo drawdown. Etichetta:
#       TORO se rendimento >= +10 % e DD < 15 %;
#       ORSO se rendimento <= -5 % e DD >= 15 %;
#       CROLLO se DD >= 25 % in <= 3 mesi;
#       LATERALE se |rendimento| <= 5 %.
#       Se non scatta nessuna regola, o ne scattano due (le quattro non
#       sono ne' esclusive ne' esaustive: es. +7 % con DD 10 % non e'
#       niente), l'etichetta e' MISTO e la finestra non entra nella
#       classe AVVERSE senza una nuova firma."
#  (la scheda report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md la cita come
#   "regola DK" in sez. 1.8 e H3; la riga 58 del piano e' la fonte).
#
#  DEFINIZIONI CHE LA RIGA 58 NON DA' e che prendo da
#    report/FIRME_DA_FARE_2026-10-05.md, sez. 1.2 (testo "FIRMO REGOLA
#    REGIMI", righe 34-41) e sez. 1.3 riga 57:
#      R    = rendimento dalla PRIMA all'ULTIMA chiusura H1 della finestra
#      DD   = massimo drawdown picco-fondo sulle chiusure H1 della finestra
#      "3 mesi" = 92 giorni di calendario (picco e fondo a <= 92 giorni)
#      lettura (i)  del crollo: esiste dentro la finestra un calo >= 25 %
#                   con picco e fondo a <= 92 giorni  (DD3m >= 25)
#      lettura (ii) del crollo: il calo MASSIMO dura <= 92 giorni
#  La lettura (i) e' quella che le tabelle di controllo di casa usano
#  (FIRME_DA_FARE r.57): e' l'ETICHETTA PRIMARIA qui. La (ii) si stampa
#  accanto; se differiscono la riga e' marcata.
#
#  STATO DELLA FIRMA: le soglie della riga 58 sono "mie: vanno firmate"
#  (stessa riga 58); F1 "FIRMO DK DOW REGIME" non risulta firmata nel
#  repo; la REGOLA UNICA (R-0, precedenza CROLLO > ORSO > LATERALE >
#  TORO, FIRME_DA_FARE r.36-41) e' PROPOSTA e non risulta firmata
#  (MIGLIORA_EMA200_DOW_771531_2026-10-08.md r.151: "R-0 e F1 non
#  firmate"; MIGLIORA_EMA200_DOW_H1_2026-10-11.md r.268 le chiede
#  ancora). Quindi: ogni etichetta stampata qui e' PROVVISORIA come
#  regola. Accanto all'etichetta primaria stampo, SOLO come nota,
#  quella che darebbe la regola unica proposta; non la usa nessun
#  verdetto.
#
#  SCELTE MIE, dichiarate (non sono nella fonte):
#    - finestra = tutte le barre H1 con data server >= inizio 00:00 e
#      <= fine 23:59; "prima chiusura" = chiusura della prima barra
#      della finestra (non l'apertura; la variante dall'apertura si
#      stampa come R_open, solo informativa);
#    - le soglie si confrontano dopo arrotondamento a 9 decimali
#      (contro-esempio float, sez. 3.6);
#    - il DD si legge sulle sole CHIUSURE H1 (come dice la regola): il
#      DD intrabarra (high/low) e' piu' grande e NON e' misurato qui.
#
# =====================================================================
#  (2) LE ATTESE, scritte prima dei numeri (banda + ipotesi alternativa)
# ---------------------------------------------------------------------
#  Fonte delle attese: SOLO la proxy della scheda MIGLIORA_EMA200_DOW_H1
#  sez. 1.8 (r.118): mediane mensili dei PREZZI DI USCITA dei deal OOS
#  (non e' una serie di chiusura: grossolana, il DD che ne esce e'
#  sottostimato). Mediane: giu-25 42.393 lug 44.634 ago 44.235 set 45.772
#  ott 46.319 nov 47.290 dic 48.040 gen 49.028 feb 49.484 (max 49.703)
#  mar 46.467 (min 46.119) apr 46.474 (min 45.912,5) mag 49.582
#  giu 50.896 (max 51.884).
#
#  A) OOS (b) 2025.06.12-2026.06.26 -- ATTESA: TORO.
#     Banda R: +15 ... +25 % (proxy +20 %, +/- 5 punti per la
#     grossolanita' dell'inizio/fine). Banda DD: 6 ... 13 % (proxy 7,6 %
#     feb-apr 2026, sottostimato: l'H1 vero sta sopra). Etichetta TORO
#     richiede DD < 15.
#     IPOTESI ALTERNATIVA e il numero che la produce: "MISTO per DD":
#     DD sulle chiusure H1 >= 15,0 % (cioe' >= 7,4 punti oltre la proxy)
#     con R >= +10 -> nessuna regola scatta -> MISTO. Se il DD cade in
#     13-15 % l'etichetta TORO e' al bordo (fragile) e lo scrivo.
#     La stessa attesa vale per la variante di contratto
#     2025.06.10-2026.06.30 (stessa proxy).
#
#  B) IS (a) 2024.10.22-2025.06.06 -- NESSUNA ATTESA: MISURA NUOVA.
#     (La scheda dice IS "NON MISURATO": sez. 1.8 r.118. Il solo fatto
#     noto e' che il campione contiene una discesa feb-apr 2025, visibile
#     nel DD della cella 5,73 %, non nel prezzo. Non e' un'attesa di
#     etichetta e non la uso come tale.)
#     Le ipotesi, con cosa ciascuna produrrebbe sul CSV:
#       H_toro      : R >= +10 % e DD < 15 %      -> TORO
#       H_laterale  : |R| <= 5 % (qualunque DD)   -> LATERALE (+ eventuale
#                     CROLLO se DD3m >= 25: allora due regole -> MISTO)
#       H_misto     : tutto il resto (es. R in (5,10), oppure R >= 10 con
#                     DD >= 15, oppure R <= -5 con DD < 15)  -> MISTO
#     Nessuna e' favorita per iscritto. Vale anche per la variante di
#     contratto 2024.09.26-2025.06.09.
#
#  C) Semestri (mezze finestre di 2-7 mesi; la scheda H3 dice che con
#     mezze finestre "piu' meta' finiscono MISTO o LATERALE", perche'
#     la soglia TORO +10 % su pochi mesi e' piu' severa):
#     - Inverno 2025/26 (2025.11.01-2026.03.31) -- ATTESA: LATERALE.
#       Proxy: nov 47.290 -> mar 46.467 = -1,7 %. Banda R: -7 ... +5 %
#       (la proxy e' mediana di mese, non ultima chiusura di marzo; il
#       fondo di marzo 46.119 sta vicino alla fine). Alternativa: MISTO,
#       prodotta da R < -5 con DD < 15 (a R <= -5 e DD >= 15 sarebbe ORSO,
#       che la proxy non suggerisce: DD proxy ~7,6 %).
#       Questo inverno e' l'ORIGINE dell'osservazione H3 e non conta
#       come prova (scheda H3 r.187).
#     - tutti gli altri semestri (inverno 2024/25, apr-ott 2025, apr-ott
#       2026 e le loro varianti): NESSUNA ATTESA: MISURA NUOVA. Per
#       apr-ott 2026 la proxy finisce a giugno (apr 46.474 -> giu 50.896
#       = +9,5 % in mediane) e luglio-ottobre 2026 non ha proxy: scrivo
#       solo le ipotesi TORO (R >= +10 e DD < 15) contro MISTO (R fra 5 e
#       10, o DD >= 15). Per apr-ott 2025 la proxy copre solo giu-ott.
#     - finestra intera del feed (2024.09.26-2026.10.09): nessuna attesa.
#
#  D) LETTURA 'VALUTABILE' PER H3 (scheda MIGLIORA_EMA200_DOW_H1 r.195,
#     "Valutabile = ..."): un inverno e' valutabile se l'etichetta di
#     regime del suo nov-mar e' la STESSA di quella del suo apr-ott e NON
#     e' MISTO (+ almeno 5 gambe per lato in ciascuna meta': condizione
#     sui TRADE, NON misurata qui: il per-trade IS non e' in repo). Questo
#     script verifica SOLO la parte "etichetta". L'inverno 2025/26 e'
#     l'origine e non conta (r.187). Attesa scritta: al piu' UN inverno
#     BCM (2024/25) puo' contare; la scheda stessa prevede N = 2 in
#     totale (2015/16 e 2024/25) = NON MISURABILE (r.195 fine).
#
# =====================================================================
#  (3) IL CONTRO-ESEMPIO: cosa farebbe sbagliare la lettura
# ---------------------------------------------------------------------
#  3.1 Il gap overnight. Le chiusure H1 includono i salti fra sessioni
#      (il feed e' quasi 24 ore: pausa ~22:00-23:00 server e fine
#      settimana). Misurato sulla struttura: 548 buchi con salto
#      medio chiusura->apertura -0,01 %, massimo -3,64 %. Il rischio e'
#      che il DD sulle H1 sia diverso da quello sulle chiusure
#      giornaliere. CONTROLLO: stampo l'etichetta ANCHE sulla serie
#      giornaliera (ultima chiusura di ogni "giornata" server che va da
#      22:00 a 21:59: la pausa del feed e' a 22:00 server). Se differisce
#      dall'etichetta H1 la riga e' marcata SENS-SERIE.
#  3.2 Finestra che parte a meta' giornata: la prima barra del feed e'
#      2024.09.26 16:00 (le finestre 'contratto' e 'feed intero' partono
#      li'). R usa la chiusura di quella barra; R_open (dall'apertura)
#      si stampa accanto.
#  3.3 Regola sulle chiusure H1 oppure giornaliere: la fonte dice H1; la
#      giornaliera e' solo il controllo 3.1.
#  3.4 Orologio. Il feed e' UTC+1 fisso (collaudo del 11/10). L'etichetta
#      NON misura l'orologio: un feed spostato di un'ora darebbe la
#      stessa etichetta (R e DD non dipendono dall'ora). Quindi questo
#      script NON e' un test d'orologio e non lo dichiara. L'orologio
#      entra solo nei confini delle finestre (00:00 server): lo coprono
#      le 25 varianti di taglio di 3.5.
#  3.5 Il taglio. Una finestra tagliata altrove puo' cambiare nome
#      (FIRME_DA_FARE r.58: "con D-K il nome dipende da dove si taglia").
#      CONTROLLO: ogni finestra e' rifatta con inizio e fine spostati di
#      -30,-15,0,+15,+30 giorni (fino a 25 varianti, tagliate ai limiti
#      del feed, doppioni eliminati); stampo la quota che da' la stessa
#      etichetta primaria. NON e' un criterio: e' un'informazione sulla
#      fragilita'.
#  3.6 Float alle soglie: 105/100-1 vale 5,000000000000004 %. Senza
#      arrotondamento |R| <= 5 fallirebbe a 5 % esatto. Arrotondo a 9
#      decimali; l'autotest ha il caso.
#  3.7 La finestra 'IS (a)' della scheda (2024.10.22-2025.06.06) sono
#      la prima e l'ultima CHIUSURA di posizione del per-trade
#      (backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_
#      20260913_033003.log r.75 e r.77: 132 posizioni, close_time dal
#      2024.10.22 10:22:06 al 2025.06.06 01:02:36), NON una finestra del
#      tester (IS di contratto 2024.09.26-2025.06.09). Le etichetto
#      entrambe.
#  3.8 Il semestre apr-ott 2026 e' INCOMPLETO: il feed finisce
#      2026.10.09 20:00. Lo scrivo nella riga.
#  3.9 'Un numero che torna' non e' una prova: l'implementazione del
#      DD a 3 mesi (finestra mobile con coda) e' confrontata nell'autotest
#      con una versione a forza bruta O(n^2) su cammini casuali.
#
# =====================================================================
#  (4) L'AUTOTEST (--autotest, parte da solo prima di ogni etichetta)
# ---------------------------------------------------------------------
#  Serie sintetiche H1 con etichetta attesa scritta qui:
#    toro puro            -> TORO
#    orso puro (-20 %)    -> ORSO
#    orso lento (-30 % in 300 g) -> ORSO (il calo non e' in 92 giorni)
#    laterale             -> LATERALE
#    crash con R +7 %     -> CROLLO (scatta solo il crollo)
#    crash con R ~ 0      -> MISTO (scattano CROLLO e LATERALE) con la
#                            regola DK letterale; CROLLO con la unica
#    crash dentro orso lungo -> (i) CROLLO+ORSO=MISTO, (ii) ORSO
#    soglie: +10,00 e DD piccolo -> TORO; +9,99 -> MISTO; |R|=5,00 ->
#            LATERALE; 5,01 -> MISTO; DD 15,00 con R+12 -> MISTO;
#            DD 25,00 in 40 g con R+7 -> CROLLO; R -5,00 con DD 16 ->
#            MISTO (LATERALE e ORSO insieme)
#    finestra a date: barre fuori finestra non contano
#    DD3m: finestra mobile == forza bruta (30 cammini casuali)
#    MUTANTE: con la soglia TORO portata a 25 % la serie 'toro puro +20 %'
#             cambia etichetta; con la finestra del crollo a 15 g il crash
#             di 40 g (-35 %, -15,75 % in 15 g) non scatta piu': l'autotest
#             deve accorgersene (prima stesura con 30 g: FALLIVA, perche'
#             in 30 g quel crash fa -26 %: mutante debole, non codice).
#  Se UN solo caso fallisce lo script esce con codice 2 e NON stampa
#  etichette sul CSV.
#
#  USO:
#    python3 backtest_pipeline/etichetta_regimi_dow.py --autotest
#    python3 backtest_pipeline/etichetta_regimi_dow.py            # CSV vero
#    python3 backtest_pipeline/etichetta_regimi_dow.py --md       # tabelle md
#  Solo libreria standard. ASCII.
# =====================================================================
from __future__ import annotations

import argparse
import collections
import datetime as dt
import hashlib
import math
import os
import random
import sys

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CSV_DEFAULT = os.path.join(
    RADICE, "backtest_pipeline", "risultati_archivio",
    "EXPORT_BARRE_DOW_H1_20261011", "U30USD_H1_91fbb7cf1900.csv")
# SHA256 del CSV (RIEPILOGO.txt dell'archivio e report/EXPORT_BARRE_DOW_H1_
# LETTURA_2026-10-11.md: "SHA256 FAE044F5...DC57"). Altro file = rifiuto.
CSV_SHA256 = "fae044f51ee46cdc6b418d33cce5facc94217f441bf20cf95919bc9002b6dc57"
CSV_N_ATTESO = 11755

# ---- soglie della riga 58 del piano DK (copiate, NON ritoccate) ------
SOGLIE = {
    "toro_r": 10.0, "toro_dd": 15.0,      # TORO: R >= +10 e DD < 15
    "orso_r": -5.0, "orso_dd": 15.0,      # ORSO: R <= -5 e DD >= 15
    "crollo_dd": 25.0, "crollo_giorni": 92,  # CROLLO: DD >= 25 in <= 3 mesi
    "lat_r": 5.0,                         # LATERALE: |R| <= 5
}
DEC = 9  # arrotondamento prima del confronto con le soglie


# =====================================================================
#  Lettura del CSV
# =====================================================================
def carica_csv(percorso, controlla_sha=True):
    """Ritorna lista di (datetime, open, high, low, close). Rifiuta file
    con SHA256 diverso da quello dichiarato (NON eseguire su altri dati)."""
    grezzo = open(percorso, "rb").read()
    sha = hashlib.sha256(grezzo).hexdigest()
    if controlla_sha and sha != CSV_SHA256:
        raise SystemExit("RIFIUTO: SHA256 %s != atteso %s (questo script gira "
                         "solo sul CSV dichiarato)" % (sha, CSV_SHA256))
    righe = []
    fine = None
    for l in grezzo.decode("utf-8", "replace").splitlines():
        if not l:
            continue
        if l.startswith("#FINE"):
            fine = l
            continue
        if l.startswith("#") or l.startswith("time_server"):
            continue
        p = l.split(";")
        t = dt.datetime.strptime(p[0], "%Y.%m.%d %H:%M")
        righe.append((t, float(p[1]), float(p[2]), float(p[3]), float(p[4])))
    if controlla_sha:
        if len(righe) != CSV_N_ATTESO:
            raise SystemExit("RIFIUTO: %d barre lette, attese %d"
                             % (len(righe), CSV_N_ATTESO))
        if fine is None or ("n=%d;" % CSV_N_ATTESO) not in fine:
            raise SystemExit("RIFIUTO: riga #FINE assente o con n diverso")
    for a, b in zip(righe, righe[1:]):
        if not a[0] < b[0]:
            raise SystemExit("RIFIUTO: barre non strettamente crescenti a %s" % b[0])
    return righe, sha


# =====================================================================
#  Il cuore: R, DD, DD3m, etichette (funzioni pure su liste di chiusure)
# =====================================================================
def r2(x):
    return round(x, DEC)


def metriche(tempi, chiusure, giorni3m=SOGLIE["crollo_giorni"], apertura0=None):
    """tempi: lista datetime (un valore per chiusura), chiusure: lista float.
    Ritorna dict con R, DD (+ picco/fondo/durata), DD3m (+ picco/fondo),
    R_open se apertura0 dato. Percentuali."""
    n = len(chiusure)
    if n < 2:
        raise ValueError("serve almeno 2 chiusure")
    R = (chiusure[-1] / chiusure[0] - 1.0) * 100.0
    # DD massimo: picco corrente
    picco_i = 0
    best = 0.0
    b_pi = b_fi = 0
    for j in range(n):
        if chiusure[j] > chiusure[picco_i]:
            picco_i = j
        dd = (1.0 - chiusure[j] / chiusure[picco_i]) * 100.0
        if dd > best:
            best, b_pi, b_fi = dd, picco_i, j
    dur = (tempi[b_fi] - tempi[b_pi]).total_seconds() / 86400.0
    # DD a 3 mesi: picco entro 'giorni3m' giorni prima del fondo (coda monotona)
    lim = dt.timedelta(days=giorni3m)
    coda = collections.deque()
    best3 = 0.0
    c_pi = c_fi = 0
    for j in range(n):
        while coda and chiusure[coda[-1]] <= chiusure[j]:
            coda.pop()
        coda.append(j)
        while tempi[j] - tempi[coda[0]] > lim:
            coda.popleft()
        dd3 = (1.0 - chiusure[j] / chiusure[coda[0]]) * 100.0
        if dd3 > best3:
            best3, c_pi, c_fi = dd3, coda[0], j
    m = {
        "n": n, "R": R, "DD": best, "DD_picco": tempi[b_pi], "DD_fondo": tempi[b_fi],
        "DD_giorni": dur, "DD3m": best3, "DD3m_picco": tempi[c_pi],
        "DD3m_fondo": tempi[c_fi],
    }
    if apertura0 is not None:
        m["R_open"] = (chiusure[-1] / apertura0 - 1.0) * 100.0
    return m


def regole_scattate(m, lettura="i", s=SOGLIE):
    """Le regole DK che scattano, SENZA decidere (elenco). lettura i|ii."""
    R, DD = r2(m["R"]), r2(m["DD"])
    out = []
    if R >= s["toro_r"] and DD < s["toro_dd"]:
        out.append("TORO")
    if R <= s["orso_r"] and DD >= s["orso_dd"]:
        out.append("ORSO")
    if lettura == "i":
        crollo = r2(m["DD3m"]) >= s["crollo_dd"]
    else:  # (ii): il calo MASSIMO e' >= soglia e dura <= 92 giorni
        crollo = DD >= s["crollo_dd"] and r2(m["DD_giorni"]) <= s["crollo_giorni"]
    if crollo:
        out.append("CROLLO")
    if abs(R) <= s["lat_r"]:
        out.append("LATERALE")
    return out


def etichetta_dk(m, lettura="i", s=SOGLIE):
    """Regola DK letterale (riga 58): una sola regola -> quella; zero o
    due o piu' -> MISTO."""
    sc = regole_scattate(m, lettura, s)
    return sc[0] if len(sc) == 1 else "MISTO"


def etichetta_unica(m, s=SOGLIE):
    """SOLO NOTA: la regola unica proposta (R-0, non firmata): prima che
    scatta in ordine CROLLO > ORSO > LATERALE > TORO, DD3m per il crollo."""
    sc = regole_scattate(m, "i", s)
    for nome in ("CROLLO", "ORSO", "LATERALE", "TORO"):
        if nome in sc:
            extra = [x for x in sc if x != nome]
            return nome + (" (+" + "+".join(extra) + ")" if extra else "")
    return "MISTO"


# =====================================================================
#  Finestre e serie
# =====================================================================
def fetta(barre, d0, d1):
    """Barre con d0 00:00 <= t <= d1 23:59 (d0, d1 = date)."""
    a = dt.datetime(d0.year, d0.month, d0.day)
    b = dt.datetime(d1.year, d1.month, d1.day, 23, 59)
    return [x for x in barre if a <= x[0] <= b]


def serie_giornaliera(sub):
    """Ultima chiusura di ogni 'giornata' server 22:00-21:59."""
    d = collections.OrderedDict()
    for x in sub:
        d[(x[0] - dt.timedelta(hours=22)).date()] = x
    tempi = [v[0] for v in d.values()]
    chius = [v[4] for v in d.values()]
    return tempi, chius


def misura_finestra(barre, d0, d1):
    sub = fetta(barre, d0, d1)
    if len(sub) < 2:
        return None
    tempi = [x[0] for x in sub]
    ch = [x[4] for x in sub]
    m = metriche(tempi, ch, apertura0=sub[0][1])
    m["t0"], m["t1"] = tempi[0], tempi[-1]
    m["lab"] = etichetta_dk(m, "i")
    m["lab2"] = etichetta_dk(m, "ii")
    m["scattate"] = regole_scattate(m, "i")
    m["unica"] = etichetta_unica(m)
    tg, cg = serie_giornaliera(sub)
    if len(cg) >= 2:
        mg = metriche(tg, cg)
        m["lab_g"] = etichetta_dk(mg, "i")
        m["R_g"], m["DD_g"], m["DD3m_g"] = mg["R"], mg["DD"], mg["DD3m"]
    else:
        m["lab_g"] = "n/d"
        m["R_g"] = m["DD_g"] = m["DD3m_g"] = float("nan")
    return m


def sensibilita_taglio(barre, d0, d1, lab_ref, passi=(-30, -15, 0, 15, 30)):
    """25 varianti (inizio e fine spostati), tagliate ai limiti del feed,
    doppioni (stessa prima e ultima barra) eliminati, finestre < 30 giorni
    scartate. Ritorna (n_varianti, n_stessa_etichetta, elenco etichette)."""
    primo, ultimo = barre[0][0].date(), barre[-1][0].date()
    visti = set()
    conta = collections.Counter()
    for a in passi:
        for b in passi:
            s0 = max(d0 + dt.timedelta(days=a), primo)
            s1 = min(d1 + dt.timedelta(days=b), ultimo)
            if (s1 - s0).days < 30:
                continue
            sub = fetta(barre, s0, s1)
            if len(sub) < 2:
                continue
            chiave = (sub[0][0], sub[-1][0])
            if chiave in visti:
                continue
            visti.add(chiave)
            m = metriche([x[0] for x in sub], [x[4] for x in sub])
            conta[etichetta_dk(m, "i")] += 1
    tot = sum(conta.values())
    return tot, conta.get(lab_ref, 0), dict(conta)


D = dt.date
# (sigla, descrizione, inizio, fine, ruolo)
FINESTRE = [
    ("IS_a", "IS della scheda (prima/ultima chiusura posizioni, CODA_12 r.75-77)",
     D(2024, 10, 22), D(2025, 6, 6), "a"),
    ("IS_c", "IS di contratto (tester)", D(2024, 9, 26), D(2025, 6, 9), "a"),
    ("OOS_b", "OOS dichiarato nel compito", D(2025, 6, 12), D(2026, 6, 26), "b"),
    ("OOS_c", "OOS di contratto (tester)", D(2025, 6, 10), D(2026, 6, 30), "b"),
    ("INV24", "inverno 2024/25 (nov-mar)", D(2024, 11, 1), D(2025, 3, 31), "c"),
    ("EST25", "apr-ott 2025", D(2025, 4, 1), D(2025, 10, 31), "c"),
    ("EST25r", "apr - 9 giu 2025 (solo parte IS, variante scheda H3 r.188)",
     D(2025, 4, 1), D(2025, 6, 9), "c"),
    ("INV25", "inverno 2025/26 (nov-mar) = ORIGINE, non conta", D(2025, 11, 1),
     D(2026, 3, 31), "c"),
    ("EST26", "apr-ott 2026 INCOMPLETO (feed fino al 2026.10.09)", D(2026, 4, 1),
     D(2026, 10, 31), "c"),
    ("FEED", "feed intero (contesto)", D(2024, 9, 26), D(2026, 10, 9), "x"),
]
# coppie H3: (inverno, estate successiva, nota)
COPPIE_H3 = [
    ("INV24", "EST25", "completa"),
    ("INV24", "EST25r", "ridotta (scheda: giu-ott 2025 e' OOS = origine)"),
    ("INV25", "EST26", "origine: non conta"),
]
# attese scritte in testa: sigla -> (etichetta attesa | None, banda R, banda DD)
ATTESE = {
    "OOS_b": ("TORO", (15.0, 25.0), (6.0, 13.0)),
    "OOS_c": ("TORO", (15.0, 25.0), (6.0, 13.0)),
    "INV25": ("LATERALE", (-7.0, 5.0), None),
}


# =====================================================================
#  AUTOTEST
# =====================================================================
def _serie(valori, passo_ore=1, t0=dt.datetime(2000, 1, 3, 0, 0)):
    """valori = chiusure; tempi H1 contigui (sintetici, senza buchi)."""
    t = [t0 + dt.timedelta(hours=passo_ore * i) for i in range(len(valori))]
    return t, list(valori)


def _lin(a, b, n):
    return [a + (b - a) * i / (n - 1) for i in range(n)]


def _ore(giorni):
    return int(giorni * 24)


def _brute_dd3m(tempi, ch, giorni):
    lim = dt.timedelta(days=giorni)
    best = 0.0
    for j in range(len(ch)):
        picco = max(ch[i] for i in range(j + 1) if tempi[j] - tempi[i] <= lim)
        best = max(best, (1.0 - ch[j] / picco) * 100.0)
    return best


def autotest(verbose=True):
    ko = []
    ok = 0

    def prova(nome, atteso, ottenuto):
        nonlocal ok
        if atteso == ottenuto:
            ok += 1
            if verbose:
                print("  ok   %-52s -> %s" % (nome, ottenuto))
        else:
            ko.append(nome)
            print("  FAIL %-52s atteso %s ottenuto %s" % (nome, atteso, ottenuto))

    def lab(vals, lettura="i", unica=False, passo=1):
        t, c = _serie(vals, passo_ore=passo)
        m = metriche(t, c)
        return etichetta_unica(m) if unica else etichetta_dk(m, lettura)

    N = _ore(300)
    # ---- serie 'pure' ----
    prova("toro puro (+20 %, nessun calo)", "TORO", lab(_lin(100, 120, N)))
    prova("orso puro (-20 % in 300 g)", "ORSO", lab(_lin(100, 80, N)))
    prova("orso lento (-30 % in 300 g: nessun calo a 92 g)", "ORSO",
          lab(_lin(100, 70, N)))
    lat = [100.0 + 2.0 * math.sin(2 * math.pi * i / (24 * 60)) for i in range(N)]
    lat[-1] = 100.0
    prova("laterale (oscilla +-2 %, R=0)", "LATERALE", lab(lat))
    # crash con R ~ +7: 100 -> 120 (100 g), 120 -> 78 (40 g = -35 %), 78 -> 107 (100 g)
    cr7 = (_lin(100, 120, _ore(100)) + _lin(120, 78, _ore(40))[1:]
           + _lin(78, 107, _ore(100))[1:])
    prova("crash con R +7 % (scatta solo CROLLO)", "CROLLO", lab(cr7))
    # crash con R ~ 0
    cr0 = (_lin(100, 120, _ore(100)) + _lin(120, 78, _ore(40))[1:]
           + _lin(78, 100, _ore(100))[1:])
    prova("crash con R 0 % (DK letterale: CROLLO+LATERALE)", "MISTO", lab(cr0))
    prova("crash con R 0 % (regola unica proposta, nota)", "CROLLO (+LATERALE)",
          lab(cr0, unica=True))
    # crash dentro orso lungo: 100 -> 60 in 300 g con un tratto -30% in 40 g
    orso_crash = (_lin(100, 90, _ore(130)) + _lin(90, 60, _ore(40))[1:]
                  + _lin(60, 55, _ore(130))[1:])
    t, c = _serie(orso_crash)
    m = metriche(t, c)
    prova("crash dentro orso: lettura (i)  [ORSO+CROLLO]", "MISTO",
          etichetta_dk(m, "i"))
    prova("crash dentro orso: lettura (ii) [DD max dura > 92 g]", "ORSO",
          etichetta_dk(m, "ii"))
    prova("crash dentro orso: regola unica (nota)", "CROLLO (+ORSO)",
          etichetta_unica(m))
    # ---- soglie esatte ----
    # TORO: +10,00 con DD piccolo (salita a gradini: nessun calo)
    prova("soglia R=+10,00 DD~0", "TORO", lab(_lin(100, 110, N)))
    prova("soglia R=+9,99 DD~0", "MISTO", lab(_lin(100, 109.99, N)))
    prova("soglia |R|=5,00 (105/100)", "LATERALE", lab(_lin(100, 105, N)))
    prova("soglia |R|=5,00 negativo con DD piccolo (95/100)", "LATERALE",
          lab(_lin(100, 95, N)))
    prova("soglia R=+5,01 DD~0", "MISTO", lab(_lin(100, 105.01, N)))
    # DD 15,00 esatto con R +12: sale a 130, scende a 110.5 (-15,00 %), poi a 112
    dd15 = _lin(100, 130, _ore(100)) + _lin(130, 110.5, _ore(100))[1:] \
        + _lin(110.5, 112, _ore(100))[1:]
    t, c = _serie(dd15)
    m = metriche(t, c)
    prova("DD=15,00 esatto con R+12 (TORO non scatta)", "MISTO",
          etichetta_dk(m, "i"))
    # DD 14,99 con R +12 -> TORO
    dd1499 = _lin(100, 130, _ore(100)) + _lin(130, 110.513, _ore(100))[1:] \
        + _lin(110.513, 112, _ore(100))[1:]
    t, c = _serie(dd1499)
    m = metriche(t, c)
    prova("DD=14,99 con R+12 (TORO)", "TORO", etichetta_dk(m, "i"))
    # CROLLO esatto 25,00 in 40 g con R +7: 100->120->90 (-25,00) -> 107
    cr25 = _lin(100, 120, _ore(100)) + _lin(120, 90, _ore(40))[1:] \
        + _lin(90, 107, _ore(100))[1:]
    prova("crollo DD3m=25,00 esatto, R+7", "CROLLO", lab(cr25))
    cr2499 = _lin(100, 120, _ore(100)) + _lin(120, 90.02, _ore(40))[1:] \
        + _lin(90.02, 107, _ore(100))[1:]
    prova("crollo DD3m=24,98, R+7 (nessuna regola)", "MISTO", lab(cr2499))
    # R=-5,00 con DD 16: LATERALE e ORSO insieme -> MISTO
    o16 = _lin(100, 84, _ore(150)) + _lin(84, 95, _ore(150))[1:]
    prova("R=-5,00 con DD 16 (LATERALE+ORSO)", "MISTO", lab(o16))
    # ---- crash 92 giorni: 93 g non e' crollo, 92 g si' ----
    c92 = _lin(100, 100, _ore(50)) + _lin(100, 70, _ore(92))[1:] + _lin(70, 107, _ore(100))[1:]
    c93 = _lin(100, 100, _ore(50)) + _lin(100, 70, _ore(93))[1:] + _lin(70, 107, _ore(100))[1:]
    t, c = _serie(c92)
    prova("calo -30 % in 92 g esatti: DD3m>=25", True,
          r2(metriche(t, c)["DD3m"]) >= 25.0)
    t, c = _serie(c93)
    prova("calo -30 % in 93 g: DD3m < 30 (picco fuori finestra)", True,
          r2(metriche(t, c)["DD3m"]) < 30.0)
    # ---- finestra a date ----
    t0 = dt.datetime(2020, 1, 1, 0, 0)
    barre = []
    for i in range(24 * 120):
        tt = t0 + dt.timedelta(hours=i)
        if tt.date() < D(2020, 2, 1):
            v = 100.0 - 0.01 * i            # prima: scende
        elif tt.date() <= D(2020, 3, 31):
            v = 90.0 + 0.0215 * (i - 24 * 31)  # dentro: sale (circa +20 %)
        else:
            v = 120.0 - 0.05 * (i - 24 * 91)    # dopo: crolla
        barre.append((tt, v, v, v, v))
    m = misura_finestra(barre, D(2020, 2, 1), D(2020, 3, 31))
    prova("finestra a date: fuori finestra non conta (solo salita)", "TORO", m["lab"])
    prova("finestra a date: prima barra = 2020.02.01 00:00", dt.datetime(2020, 2, 1, 0, 0),
          m["t0"])
    prova("finestra a date: ultima barra = 2020.03.31 23:00", dt.datetime(2020, 3, 31, 23, 0),
          m["t1"])
    # ---- serie giornaliera: giornata = 22:00 -> 21:59 ----
    sub = [(dt.datetime(2020, 1, 6, h, 0), 1, 1, 1, 100.0 + h) for h in range(24)]
    sub += [(dt.datetime(2020, 1, 7, h, 0), 1, 1, 1, 200.0 + h) for h in range(24)]
    tg, cg = serie_giornaliera(sub)
    # raggruppi: [6/1 00..21] ultima= h21 -> 121; [6/1 22..7/1 21] ultima = 7/1 h21 -> 221;
    # [7/1 22..23] ultima = h23 -> 223
    prova("serie giornaliera: chiusure per giornata 22:00-21:59", [121.0, 221.0, 223.0], cg)
    # ---- DD3m: coda mobile contro forza bruta ----
    rnd = random.Random(20261011)
    allineati = 0
    for k in range(30):
        n = rnd.randint(30, 400)
        x = 100.0
        v = []
        for _ in range(n):
            x *= 1.0 + rnd.gauss(0, 0.01)
            v.append(x)
        passo = rnd.choice([1, 6, 24, 96])  # ore fra le barre
        t, c = _serie(v, passo_ore=passo)
        for giorni in (92, 30):
            a = metriche(t, c, giorni3m=giorni)["DD3m"]
            b = _brute_dd3m(t, c, giorni)
            if abs(a - b) < 1e-9:
                allineati += 1
    prova("DD3m: finestra mobile == forza bruta (30 cammini x 2 finestre)", 60, allineati)
    # DD massimo contro forza bruta
    ok_dd = 0
    for k in range(30):
        n = rnd.randint(30, 300)
        x = 100.0
        v = []
        for _ in range(n):
            x *= 1.0 + rnd.gauss(0, 0.01)
            v.append(x)
        t, c = _serie(v)
        a = metriche(t, c)["DD"]
        b = max((1.0 - c[j] / max(c[:j + 1])) * 100.0 for j in range(n))
        if abs(a - b) < 1e-9:
            ok_dd += 1
    prova("DD massimo: picco corrente == forza bruta (30 cammini)", 30, ok_dd)
    # ---- MUTANTE: se le soglie cambiano, l'autotest se ne accorge ----
    s_mut = dict(SOGLIE)
    s_mut["toro_r"] = 25.0
    t, c = _serie(_lin(100, 120, N))
    m = metriche(t, c)
    prova("MUTANTE TORO>=25: la serie 'toro puro +20 %' cambia", "MISTO",
          etichetta_dk(m, "i", s_mut))
    s_mut = dict(SOGLIE)
    s_mut["crollo_giorni"] = 15
    t, c = _serie(cr7)
    m = metriche(t, c, giorni3m=15)
    prova("MUTANTE crollo a 15 g: il crash dei 40 g (-35 %) non scatta piu'", "MISTO",
          etichetta_dk(m, "i", s_mut))
    print("AUTOTEST: %d ok, %d FAIL" % (ok, len(ko)))
    return not ko


# =====================================================================
#  Stampa
# =====================================================================
def fmt_t(t):
    return t.strftime("%Y.%m.%d %H:%M")


def esegui(barre, sha, md=False):
    risultati = collections.OrderedDict()
    for sig, desc, d0, d1, ruolo in FINESTRE:
        m = misura_finestra(barre, d0, d1)
        m["sig"], m["desc"], m["d0"], m["d1"] = sig, desc, d0, d1
        tot, stessa, dist = sensibilita_taglio(barre, d0, d1, m["lab"])
        m["sens"] = (tot, stessa, dist)
        risultati[sig] = m
    print("CSV SHA256 %s  barre %d  %s -> %s" % (sha, len(barre), fmt_t(barre[0][0]),
                                                  fmt_t(barre[-1][0])))
    print("Regola: DK riga 58 (letterale, lettura (i) del crollo, 92 g); "
          "NON firmata: PROVVISORIA.")
    print()
    for sig, m in risultati.items():
        print("[%s] %s  %s..%s" % (sig, m["desc"], m["d0"], m["d1"]))
        print("   barre %d  %s -> %s" % (m["n"], fmt_t(m["t0"]), fmt_t(m["t1"])))
        print("   R %+.2f %%  (da apertura %+.2f %%)   DD %.2f %% (picco %s fondo %s, %.0f g)"
              "   DD3m %.2f %% (picco %s fondo %s)"
              % (m["R"], m["R_open"], m["DD"], fmt_t(m["DD_picco"]), fmt_t(m["DD_fondo"]),
                 m["DD_giorni"], m["DD3m"], fmt_t(m["DD3m_picco"]), fmt_t(m["DD3m_fondo"])))
        print("   regole scattate (i): %s -> ETICHETTA %s   | lettura (ii): %s | unica(nota): %s"
              % (m["scattate"] or "nessuna", m["lab"], m["lab2"], m["unica"]))
        print("   serie giornaliera: R %+.2f DD %.2f DD3m %.2f -> %s%s"
              % (m["R_g"], m["DD_g"], m["DD3m_g"], m["lab_g"],
                 "   *** SENS-SERIE" if m["lab_g"] != m["lab"] else ""))
        tot, stessa, dist = m["sens"]
        print("   taglio +-15/30 g: %d varianti, stessa etichetta %d  %s"
              % (tot, stessa, dist))
        a = ATTESE.get(sig)
        if a:
            etic, bR, bDD = a
            inR = bR[0] <= m["R"] <= bR[1]
            inD = bDD is None or (bDD[0] <= m["DD"] <= bDD[1])
            print("   ATTESA %s, R in %s: %s%s -> etichetta %s"
                  % (etic, bR, "DENTRO" if inR else "FUORI",
                     (", DD in %s: %s" % (bDD, "DENTRO" if inD else "FUORI")) if bDD else "",
                     "COME ATTESO" if m["lab"] == etic else "DIVERSA DALL'ATTESA"))
        else:
            print("   nessuna attesa: misura nuova")
        print()
    print("== LETTURA VALUTABILE PER H3 (solo la parte 'etichetta') ==")
    for inv, est, nota in COPPIE_H3:
        a, b = risultati[inv], risultati[est]
        stessa = a["lab"] == b["lab"]
        non_misto = a["lab"] != "MISTO" and b["lab"] != "MISTO"
        val = stessa and non_misto
        print("  %-6s (%s) vs %-6s (%s): stessa etichetta %s, nessuna MISTO %s -> %s  [%s]"
              % (inv, a["lab"], est, b["lab"], "SI" if stessa else "NO",
                 "SI" if non_misto else "NO",
                 "VALUTABILE (sull'etichetta)" if val else "NON VALUTABILE", nota))
    print("  gambe >= 5 per lato in ciascuna meta': NON MISURATO (per-trade IS non in repo).")
    if md:
        print()
        stampa_md(risultati)
    return risultati


def stampa_md(ris):
    print("| sigla | finestra | barre | R % | DD % | DD3m % | regole scattate | ETICHETTA | (ii) | unica (nota) | giornaliera | taglio |")
    print("|---|---|---:|---:|---:|---:|---|---|---|---|---|---|")
    for sig, m in ris.items():
        tot, stessa, _ = m["sens"]
        print("| %s | %s..%s | %d | %+.2f | %.2f | %.2f | %s | **%s** | %s | %s | %s%s | %d/%d |"
              % (sig, m["d0"], m["d1"], m["n"], m["R"], m["DD"], m["DD3m"],
                 "+".join(m["scattate"]) or "nessuna", m["lab"], m["lab2"], m["unica"],
                 m["lab_g"], " (!)" if m["lab_g"] != m["lab"] else "", stessa, tot))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1] if __doc__ else "")
    ap.add_argument("--autotest", action="store_true", help="solo autotest sintetico")
    ap.add_argument("--csv", default=CSV_DEFAULT)
    ap.add_argument("--md", action="store_true", help="stampa anche le tabelle markdown")
    a = ap.parse_args()
    print("== AUTOTEST ==")
    if not autotest(verbose=True):
        print("AUTOTEST FALLITO: nessuna etichetta stampata sul CSV.")
        sys.exit(2)
    if a.autotest:
        return
    barre, sha = carica_csv(a.csv)
    print()
    esegui(barre, sha, md=a.md)


if __name__ == "__main__":
    main()
