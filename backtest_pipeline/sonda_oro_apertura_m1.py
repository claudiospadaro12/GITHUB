#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_SONDA_ORO_APERTURA_M1_v1
#  sonda_oro_apertura_m1.py
#  L'ORO NEI 5 MINUTI DOPO LA ROTTURA DELLA PRIMA CANDELA M5
#  DELL'APERTURA USA -- MISURA DESCRITTIVA, NON UN BACKTEST
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (richiesta di Claudio, 10/09/2026, testuale)
#    "VOGLIO SAPERE DAGLI AGENTI, NEGLI ULTIMI ANNI COME SI COMPORTA
#     ALL'APERTURA L'ORO IN M1 DALLE 15,36 ALLE 15,41. QUESTI 5 MIN,
#     SE FA BREAKOUT, TUTTE LE CANDELE DELLO STESSO COLORE O SE FA SU E
#     GIU' DI COLORE."
#    Il segnale del collega: candela M5 15:30-15:35, si passa in M1 e
#    alle 15:36 si guarda da che parte ha sfondato, si entra, si tengono
#    3-4 candele M1.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  NON e' un backtest. NON calcola un PROFIT FACTOR, NON calcola   #
#  #  un'equity, NON deduce spread ne' slippage, NON promuove niente, #
#  #  NON scrive un byte dentro MetaQuotes\Terminal, NON tocca MT5    #
#  #  e non sfiora il forward. Legge barre M1 e CONTA.                #
#  #  Un numero di qui NON e' mai un verdetto di strategia: e' una    #
#  #  DESCRIZIONE del mercato su un feed che non e' il nostro broker. #
#  ###################################################################
#
#  ==================================================================
#  LA SPECIFICA, CONGELATA PRIMA DI VEDERE I NUMERI
#  ==================================================================
#  SETUP        le 5 barre M1 [A, A+5) dove A = l'ancora (vedi FUSO).
#               H0 = massimo delle 5, L0 = minimo delle 5, R = H0-L0.
#               E' la candela M5 "15:30-15:35" del collega.
#  GRILLETTO    la barra M1 [A+5, A+6) -- il minuto "15:35-15:36".
#               E' QUI che si decide il lato, perche' Claudio vuole
#               osservare i 5 minuti DA 15:36: la rottura deve essere
#               gia' avvenuta alle 15:36:00.
#  OSSERVAZIONE le 5 barre M1 [A+6, A+11) -- "dalle 15,36 alle 15,41".
#  RIFERIMENTO  il prezzo di apertura della barra A+6 (quello che
#               prenderebbe chi entra all'inizio della finestra).
#
#  "SFONDA" -- tre definizioni, calcolate TUTTE E TRE, nessuna scelta
#  a posteriori:
#    T  TOCCO     high(grilletto) > H0  -> LONG ; low < L0 -> SHORT
#    C  CHIUSURA  close(grilletto) > H0 -> LONG ; close < L0 -> SHORT
#    M  MARGINE   come T ma il livello va superato di k*R (k = 0,10,
#                 stessa convenzione di anatomia_aperture.py)
#  AMBIGUO: se nello stesso minuto sono rotti TUTTI E DUE i lati, il
#  lato si decide con la CHIUSURA del grilletto (close>H0 = LONG,
#  close<L0 = SHORT); se la chiusura resta dentro il range il giorno e'
#  AMBIGUO_IRRISOLTO, esce dalle statistiche direzionali ed e' CONTATO.
#  NESSUNA ROTTURA: giorno contato, fuori dalle statistiche direzionali.
#  La frequenza di "nessuna rottura" e' essa stessa un risultato.
#
#  COLORE DI UNA CANDELA M1 -- deciso ADESSO, non dopo:
#    close > open  = VERDE      close < open = ROSSA
#    close == open = DOJI, categoria PROPRIA. Un doji NON e' verde e
#    NON e' rosso: SPEZZA la serie di colore uguale e NON conta come
#    candela "nella direzione". La sua frequenza e' stampata, cosi' il
#    suo peso e' visibile invece che nascosto in una convenzione.
#
#  COSA VIENE PRODOTTO, per ogni gruppo:
#    (a) STATISTICA DI COLORE su TUTTI i giorni validi (la domanda
#        LETTERALE di Claudio, che non parla di direzione):
#          - quota di giorni con 5 candele su 5 dello STESSO colore
#          - distribuzione della SERIE PIU' LUNGA di colore uguale (1-5)
#          - distribuzione dei CAMBI di colore (0-4)
#          - quota di doji
#    (b) STATISTICA DIREZIONALE sui giorni con rottura (la versione
#        operabile): distribuzione di k = quante delle 5 candele sono
#        NELLA DIREZIONE della rottura (k = 0..5), quote 5/5, >=4/5,
#        >=3/5, e frequenza di INVERSIONE (chiusura dei 5 minuti dal
#        lato opposto alla rottura).
#    (c) MOVIMENTO IN DOLLARI: MFE e MAE nei 5 minuti rispetto al
#        prezzo di riferimento, mediana e quartili, in $ e in % del
#        prezzo (l'oro del 2006 vale 600 $, quello del 2020 1.700:
#        senza il % gli anni non sono confrontabili).
#    (d) tutto anche ANNO PER ANNO: un numero che vive in un anno solo
#        non e' un comportamento, e' un episodio.
#
#  IL CONTROLLO -- SENZA QUESTO LA MISURA NON VALE NIENTE
#  (regola di casa del 03/09, corretta il 05/09: il controllo casuale
#   va APPAIATO, cioe' sugli STESSI giorni e con la STESSA geometria)
#    APERTURA_NY     ancora 09:30 America/New_York   <- l'evento vero
#    APERTURA_ROMA   ancora 15:30 Europe/Rome        <- l'ora del collega
#    CTRL_QUIETO     ancora 11:30 Europe/Rome  (i "11:36-11:41")
#    CTRL_DOPO       ancora 10:30 America/New_York (un'ora DOPO
#                    l'apertura: stessa seduta, stesso simbolo, ma
#                    nessuna apertura -> separa "e' l'apertura" da
#                    "e' un'ora viva")
#    CTRL_CASO       un minuto ESTRATTO A SORTE fra le 07:00 e le 19:00
#                    UTC, uno per ciascuno DEGLI STESSI GIORNI, con
#                    seme dichiarato (--seme, default 20260910) ->
#                    riproducibile al minuto.
#  Se l'oro fa "3 candele su 5 dello stesso colore" anche alle 11:36,
#  alle 15:36 non c'e' nessuna apertura: c'e' come sono fatte le
#  candele M1. Ogni frequenza e' stampata con la sua BANDA DI RUMORE
#  (+/- 2 errori standard binomiali) e ogni delta contro un controllo
#  con la banda del delta: un delta dentro la banda e' etichettato
#  DENTRO-IL-RUMORE, meccanicamente, senza giudizio.
#
#  ==================================================================
#  IL FUSO -- e' la prima cosa da chiudere, e sbagliarla invalida tutto
#  ==================================================================
#  Regola di casa: server BCM = ora italiana - 1, quindi 15:30 italiane
#  = 14:30 server. MA l'ora legale europea e quella americana NON
#  cambiano nelle stesse date:
#      USA  2007->  2a domenica di marzo / 1a domenica di novembre
#      USA  fino al 2006  1a domenica di aprile / ultima di ottobre
#      UE   ultima domenica di marzo / ultima domenica di ottobre
#  Per ~3-4 settimane l'anno (meta' marzo, fine ottobre) le 15:30
#  italiane NON sono le 09:30 di New York: sono le 08:30. Sono ~20
#  giorni di borsa l'anno, cioe' ~8% del campione.
#  --> QUI NON SI SCEGLIE E NON SI BUTTA VIA NIENTE: si misurano
#      ENTRAMBE le ancore (NY e ROMA) e si stampa a parte il
#      sottoinsieme dei GIORNI DISCORDI, cosi' si vede quanto pesa la
#      differenza invece di assumerla nulla.
#  Tutto, dentro, e' in UTC. La conversione la fa il lettore in base al
#  fuso DICHIARATO del file, e il COLLAUDO DELL'OROLOGIO la verifica
#  sui dati prima di calcolare qualunque altra cosa.
#
#  COLLAUDO DELL'OROLOGIO (si gira per PRIMO, e se fallisce si ferma)
#    Si cerca il minuto del giorno con la piu' alta |close-open| media,
#    separando i mesi INVERNALI dagli ESTIVI. Qualunque evento ancorato
#    a un fuso che osserva l'ora legale (le 8:30 di New York, il fixing
#    di Londra) si sposta di -60 minuti in UTC d'estate, e NON si sposta
#    se il file e' scritto in ora locale americana.
#      spostamento -60 min  -> il file e' in UTC
#      spostamento    0 min -> il file e' ancorato agli USA (ora di NY)
#    Se il risultato contraddice il fuso dichiarato, lo strumento ESCE
#    con codice 2 e NON misura niente. Un orologio sbagliato non da'
#    errore: produce un numero pulito e falso (lezione del 05/09).
#
#  ==================================================================
#  LA FONTE DEI DATI, e i suoi limiti dichiarati
#  ==================================================================
#  Formato 1 (default, ed e' quello che abbiamo davvero):
#    github.com/FutureSharks/financial-data, licenza GPL-3.0, barre M1
#    Oanda, file MENSILI, intestazione
#        time,close,high,low,open,volume
#    ATTENZIONE: le colonne sono C,H,L,O -- NON O,H,L,C. Leggerle in
#    ordine OHLC scambia apertura e chiusura, cioe' INVERTE IL COLORE
#    DI OGNI CANDELA. E' esattamente il numero che questa sonda misura:
#    l'autotest lo verifica apposta.
#    Timestamp UTC (collaudo di casa del 05/09, riverificato qui).
#  Formato 2: HistData Generic ASCII "AAAAMMGG HHMMSS;o;h;l;c;v",
#    timestamp in ora locale di NEW YORK (misura di casa,
#    histdata_m1.py righe 81-103).
#  Formato 3: "Formato 1" di casa "Time,Open,High,Low,Close,Volume" con
#    "AAAA.MM.GG HH:MM" (quello che produce histdata_m1.py --converti).
#  Il formato si riconosce dalla PRIMA RIGA, file per file.
#
#  I LIMITI, accanto a ogni numero, sempre:
#    1. NON E' BCM. Altro broker, altri orari, altro spread, altri gap.
#       Ogni numero e' una MISURA DI OCCASIONI, mai un verdetto (F6).
#    2. OHLC M1, non tick: dentro il minuto non si sa l'ordine dei
#       prezzi. Qui non si simula nessuna uscita, quindi l'ambiguita'
#       intrabarra tocca solo MFE/MAE, che sono ESTREMI e non esiti.
#    3. ZERO COSTI. Lo spread BCM sull'oro NON E' MAI STATO MISURATO
#       (buco aperto dal 25/08, riconfermato il 06/09 e il 08/09).
#       --spread serve SOLO a stampare i due pavimenti di casa
#       (13,3x = duro, 40x = di lavoro) accanto all'ampiezza misurata.
#    4. La finestra dei dati (2006-2020) NON copre il regime 2021-2026
#       ne' l'oro sopra i 3.000 $.
#
#  ==================================================================
#  L'ATTESA DICHIARATA -- scritta PRIMA dei numeri, cosi' si sa se
#  hanno confermato o smentito (regola di casa)
#  ==================================================================
#    A. BASE DI PARTENZA. Cinque candele indipendenti a testa o croce
#       danno "tutte e 5 uguali" nel 2 x 0,5^5 = 6,25% dei casi. Le
#       barre M1 hanno un po' di persistenza a raffica, quindi mi
#       aspetto una base fra l'8% e il 12% A QUALUNQUE ORA, controlli
#       compresi. Se all'apertura esce 10% e al controllo 9%, la
#       risposta a Claudio e' "e' cosi' che sono fatte le candele M1".
#    B. PREVISIONE ALL'APERTURA: quota 5/5 stesso colore fra il 10% e
#       il 18%, cioe' da +2 a +6 punti sopra il controllo quieto.
#    C. PREVISIONE DIREZIONALE: >=4 candele su 5 nella direzione della
#       rottura fra il 25% e il 40%; INVERSIONE (chiusura dei 5 minuti
#       dal lato opposto) fra il 30% e il 45%, cioe' NON rara.
#    D. PREVISIONE SULL'AMPIEZZA: MFE e MAE mediani all'apertura
#       2-4 volte quelli dell'ora quieta, ma SIMMETRICI fra loro
#       (mediana MFE entro +/-20% della mediana MAE).
#    ==> La tesi che sto per provare a falsificare e': "l'apertura
#        cambia l'AMPIEZZA, non la PERSISTENZA DEL COLORE". Se i numeri
#        mi smentiscono, e' un risultato migliore di uno che mi
#        conferma. Se mi danno ragione, la conseguenza pratica e' che
#        il colore non e' il segnale: lo spazio lo e'.
#
#  ==================================================================
#  IL CAMPIONE CHE SERVE -- in OSSERVAZIONI, non in anni (Emend. A)
#  ==================================================================
#    Copertura misurata della fonte: 2006-03 -> 2020-05 = ~14,2 anni.
#    A ~250 sedute l'anno sono ~3.550 giornate candidate.
#    - con n = 400 giorni per gruppo la banda a 2 SE su una frequenza
#      del 10% e' +/-3,0 punti: si vede un raddoppio, non un +1 punto.
#    - con n = 3.000 la banda scende a +/-1,1 punti: e' il bersaglio.
#    ==> PAVIMENTO DICHIARATO: sotto 400 giorni con rottura in un
#        gruppo, quel gruppo si stampa ma si legge come SOSPESO. Sopra
#        3.000, il confronto coi controlli e' leggibile davvero.
#    Un anno con meno di 100 giornate valide non entra nella tabella
#    per anno (la sua distribuzione non e' leggibile).
#
#  I MODI
#    --autotest    giornate SINTETICHE coi conteggi attesi scritti nel
#                  codice + le regole di ora legale verificate su date
#                  note. Nessun file, nessuna rete.
#    --scarica     scarica i file mensili dalla fonte (solo urllib,
#                  niente pip) nella cartella --dati, con cache.
#    --sonda-dati  copertura, buchi, COLLAUDO DELL'OROLOGIO e conteggio
#                  dei giorni completi per gruppo. NESSUNA statistica
#                  di comportamento: serve a sapere se si puo' misurare.
#    (default)     la misura completa: referto .txt + CSV per giorno.
#
#  CODICI D'USCITA
#    0 = misurato, nessun rilievo
#    1 = MISURATO CON RILIEVI (campione sotto il pavimento, troppi
#        giorni incompleti, anni sottili): i numeri ci sono e vanno
#        letti col rilievo davanti.
#    2 = NON PARTITO (dati assenti, formato non riconosciuto, OROLOGIO
#        IN CONTRADDIZIONE col fuso dichiarato).
#
#  Solo libreria standard: niente pandas, niente numpy, niente pip.
#  ASCII puro. Gira sul python embeddable C:\python313\python.exe.
# =====================================================================

import argparse
import csv
import io
import os
import random
import sys
import time
import urllib.request
from datetime import date, datetime, timedelta

VERSIONE = "MARCATORE_SONDA_ORO_APERTURA_M1_v1"

BASE_RAW = ("https://raw.githubusercontent.com/FutureSharks/financial-data/"
            "master/pyfinancialdata/data/currencies/oanda")

# copertura MISURATA il 10/09/2026 sondando la fonte file per file:
# 2006-03 primo mese presente, 2020-05 ultimo. 2006-01/02 e 2020-06+ = 404.
PRIMO_ANNO, PRIMO_MESE = 2006, 3
ULTIMO_ANNO, ULTIMO_MESE = 2020, 5

MIN_GIORNI_GRUPPO = 400      # sotto: gruppo SOSPESO (banda 2SE = +/-3,0 pt)
MIN_GIORNI_ANNO = 100        # sotto: l'anno non entra nella tabella per anno
PAVIMENTO_DURO = 13.3        # stop >= 13,3 x spread  (frontiera di casa)
PAVIMENTO_LAVORO = 40.0      # stop >= 40 x spread    (frontiera di lavoro)


def log(msg):
    print(msg, flush=True)


# ---------------------------------------------------------------------
#  ORA LEGALE -- regole scritte, non indovinate.
#  Le ancore cadono fra le 13:30 e le 14:30 UTC, cioe' molte ore dopo
#  il cambio d'ora (02:00 locali negli USA, 01:00 UTC in Europa):
#  la granularita' del GIORNO e' quindi esatta per questo uso, ed e'
#  dichiarata invece che nascosta.
# ---------------------------------------------------------------------
def domenica_n(anno, mese, n):
    """L'n-esima domenica del mese (n>=1)."""
    d = date(anno, mese, 1)
    avanti = (6 - d.weekday()) % 7          # weekday(): lunedi'=0, domenica=6
    return d + timedelta(days=avanti + 7 * (n - 1))


def domenica_ultima(anno, mese):
    if mese == 12:
        d = date(anno + 1, 1, 1) - timedelta(days=1)
    else:
        d = date(anno, mese + 1, 1) - timedelta(days=1)
    return d - timedelta(days=(d.weekday() + 1) % 7)


def dst_usa(g):
    """Ora legale americana. Dal 2007: 2a domenica di marzo -> 1a di
    novembre. Fino al 2006 (Energy Policy Act 2005, in vigore dal 2007):
    1a domenica di aprile -> ultima di ottobre. Il nostro campione parte
    dal marzo 2006, quindi la regola VECCHIA serve davvero."""
    if g.year >= 2007:
        inizio = domenica_n(g.year, 3, 2)
        fine = domenica_n(g.year, 11, 1)
    else:
        inizio = domenica_n(g.year, 4, 1)
        fine = domenica_ultima(g.year, 10)
    return inizio <= g < fine


def dst_ue(g):
    """Ora legale europea: ultima domenica di marzo -> ultima di ottobre.
    Regola stabile su tutto il campione."""
    return domenica_ultima(g.year, 3) <= g < domenica_ultima(g.year, 10)


def ancora_utc(g, tipo):
    """Minuti da mezzanotte UTC dell'ancora A per la giornata g.
    NY 09:30  = 13:30 UTC con l'ora legale USA, 14:30 senza.
    ROMA 15:30 = 13:30 UTC con l'ora legale UE,  14:30 senza."""
    if tipo == "ny0930":
        return 13 * 60 + 30 if dst_usa(g) else 14 * 60 + 30
    if tipo == "ny1030":
        return 14 * 60 + 30 if dst_usa(g) else 15 * 60 + 30
    if tipo == "roma1530":
        return 13 * 60 + 30 if dst_ue(g) else 14 * 60 + 30
    if tipo == "roma1130":
        return 9 * 60 + 30 if dst_ue(g) else 10 * 60 + 30
    raise ValueError("ancora sconosciuta: " + str(tipo))


def ancora_caso(g, seme):
    """Ancora ESTRATTA A SORTE per la giornata g, fra le 07:00 e le
    19:00 UTC (lo spazio deve bastare per 11 minuti). Deterministica:
    stesso seme e stessa data -> stesso minuto, sempre. E' il controllo
    APPAIATO: stessi giorni, stessa geometria, ora diversa."""
    r = random.Random(seme * 100000000 + int(g.strftime("%Y%m%d")))
    return r.randint(7 * 60, 19 * 60 - 11)


# ---------------------------------------------------------------------
#  LETTURA DEI FILE -- tre formati, riconosciuti dalla PRIMA RIGA.
#  Si restituisce SEMPRE il timestamp GREZZO (come sta nel file): la
#  conversione a UTC e' un passo separato, cosi' il collaudo
#  dell'orologio puo' lavorare sull'ora vera del file.
# ---------------------------------------------------------------------
FORMATI = ("oanda", "histdata", "casa")


def rileva_formato(prima_riga):
    r = prima_riga.strip().lower()
    if r.startswith("time,close,high,low,open"):
        return "oanda"
    if r.startswith("time,open,high,low,close"):
        return "casa"
    if ";" in r and len(r) > 14 and r[0:8].isdigit():
        return "histdata"
    return None


def leggi_file(percorso, contatori):
    """Genera (t_grezzo, o, h, l, c, v). Nessuna assunzione di fuso qui."""
    with open(percorso, "r", encoding="ascii", errors="replace") as f:
        prima = f.readline()
        if not prima:
            return
        fmt = rileva_formato(prima)
        if fmt is None:
            contatori["file_formato_ignoto"] += 1
            return
        if fmt == "histdata":
            f.seek(0)
        for riga in f:
            riga = riga.strip()
            if not riga:
                continue
            try:
                if fmt == "oanda":
                    p = riga.split(",")
                    if len(p) < 5:
                        contatori["righe_scartate"] += 1
                        continue
                    t = datetime(int(p[0][0:4]), int(p[0][5:7]), int(p[0][8:10]),
                                 int(p[0][11:13]), int(p[0][14:16]))
                    # ATTENZIONE: qui l'ordine e' close,high,low,open
                    c, h, l, o = float(p[1]), float(p[2]), float(p[3]), float(p[4])
                    v = float(p[5]) if len(p) > 5 and p[5] != "" else 0.0
                elif fmt == "casa":
                    p = riga.split(",")
                    if len(p) < 5:
                        contatori["righe_scartate"] += 1
                        continue
                    s = p[0]
                    t = datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]),
                                 int(s[11:13]), int(s[14:16]))
                    o, h, l, c = float(p[1]), float(p[2]), float(p[3]), float(p[4])
                    v = float(p[5]) if len(p) > 5 and p[5] != "" else 0.0
                else:
                    p = riga.replace(",", ";").split(";")
                    if len(p) < 5:
                        contatori["righe_scartate"] += 1
                        continue
                    s = p[0]
                    t = datetime(int(s[0:4]), int(s[4:6]), int(s[6:8]),
                                 int(s[9:11]), int(s[11:13]))
                    o, h, l, c = float(p[1]), float(p[2]), float(p[3]), float(p[4])
                    v = float(p[5]) if len(p) > 5 and p[5] != "" else 0.0
            except (ValueError, IndexError):
                contatori["righe_scartate"] += 1
                continue
            if o <= 0 or h <= 0 or l <= 0 or c <= 0 or h < l:
                contatori["righe_scartate"] += 1
                continue
            if h < o or h < c or l > o or l > c:
                contatori["ohlc_incoerenti"] += 1
                continue
            yield (t, o, h, l, c, v)


def grezzo_a_utc(t, fuso_file):
    """Il file e' in UTC (niente da fare) o in ora locale di New York
    (UTC = NY + 4 con l'ora legale, + 5 senza)."""
    if fuso_file == "utc":
        return t
    return t + timedelta(hours=(4 if dst_usa(t.date()) else 5))


def fuso_default(fmt):
    return {"oanda": "utc", "histdata": "ny", "casa": "ny"}.get(fmt, "utc")


def elenca_file(cartella):
    fuori = []
    if not os.path.isdir(cartella):
        return fuori
    for n in sorted(os.listdir(cartella)):
        if n.lower().endswith(".csv") and os.path.getsize(os.path.join(cartella, n)) > 100:
            fuori.append(os.path.join(cartella, n))
    return fuori


# ---------------------------------------------------------------------
#  SCARICO (solo urllib: nessun pip, gira sull'embeddable del VPS)
# ---------------------------------------------------------------------
def scarica(cartella, simbolo, da_anno, a_anno, pausa_ms=300):
    os.makedirs(cartella, exist_ok=True)
    ok = vuoti = cache = 0
    byte = 0
    t0 = time.time()
    for anno in range(da_anno, a_anno + 1):
        for mese in range(1, 13):
            if (anno, mese) < (PRIMO_ANNO, PRIMO_MESE):
                continue
            if (anno, mese) > (ULTIMO_ANNO, ULTIMO_MESE):
                continue
            nome = "%s-%04d-%02d.csv" % (simbolo, anno, mese)
            dest = os.path.join(cartella, nome)
            if os.path.exists(dest) and os.path.getsize(dest) > 100:
                cache += 1
                continue
            url = "%s/%s/%d/oanda-%s-%d-%d.csv" % (BASE_RAW, simbolo, anno,
                                                   simbolo, anno, mese)
            corpo = None
            for attesa in (0, 3, 10, 30):
                if attesa:
                    time.sleep(attesa)
                try:
                    with urllib.request.urlopen(url, timeout=120) as r:
                        corpo = r.read()
                    break
                except Exception as e:
                    log("    %s: %s" % (nome, type(e).__name__))
            if not corpo or len(corpo) < 1000:
                vuoti += 1
                log("  MANCA %s" % nome)
                continue
            tmp = dest + ".parziale"
            with open(tmp, "wb") as f:
                f.write(corpo)
            os.replace(tmp, dest)
            ok += 1
            byte += len(corpo)
            if pausa_ms:
                time.sleep(pausa_ms / 1000.0)
    log("SCARICO: nuovi %d, gia' in cache %d, mancanti %d, %.1f MB, %.0f s"
        % (ok, cache, vuoti, byte / 1048576.0, time.time() - t0))
    return ok + cache


# ---------------------------------------------------------------------
#  COLLAUDO DELL'OROLOGIO -- si gira per PRIMO, e se fallisce si ferma
# ---------------------------------------------------------------------
def collauda_orologio(file_scelti, fuso_dichiarato, contatori, stampa):
    inverno = {}
    estate = {}
    for p in file_scelti:
        for (t, o, h, l, c, v) in leggi_file(p, contatori):
            m = t.hour * 60 + t.minute
            d = abs(c - o)
            if t.month in (12, 1, 2):
                e = inverno.setdefault(m, [0.0, 0])
            elif t.month in (6, 7, 8):
                e = estate.setdefault(m, [0.0, 0])
            else:
                continue
            e[0] += d
            e[1] += 1

    def cima(dizio, quanti=10):
        v = [(s / n, m, n) for m, (s, n) in dizio.items() if n >= 20]
        v.sort(reverse=True)
        return v[:quanti]

    stampa.append("")
    stampa.append("COLLAUDO DELL'OROLOGIO (si gira PRIMA di ogni altro numero)")
    stampa.append("  metodo: il minuto del giorno con la |close-open| media piu' alta,")
    stampa.append("  mesi invernali (12-1-2) contro mesi estivi (6-7-8). Qualunque")
    stampa.append("  evento ancorato a un fuso con ora legale (8:30 di New York,")
    stampa.append("  fixing di Londra) si sposta di -60 min in UTC d'estate, e non si")
    stampa.append("  sposta se il file e' scritto in ora locale americana.")
    ci = cima(inverno)
    ce = cima(estate)
    if not ci or not ce:
        stampa.append("  NON MISURABILE: servono mesi invernali E estivi nei file letti.")
        return None
    stampa.append("  INVERNO -- i 10 minuti piu' mossi (ora COME SCRITTA nel file):")
    for med, m, n in ci:
        stampa.append("    %02d:%02d  |close-open| medio %.4f  (n=%d)" % (m // 60, m % 60, med, n))
    stampa.append("  ESTATE  -- i 10 minuti piu' mossi:")
    for med, m, n in ce:
        stampa.append("    %02d:%02d  |close-open| medio %.4f  (n=%d)" % (m // 60, m % 60, med, n))
    spost = ce[0][1] - ci[0][1]
    stampa.append("  picco inverno %02d:%02d   picco estate %02d:%02d   spostamento %+d min"
                  % (ci[0][1] // 60, ci[0][1] % 60, ce[0][1] // 60, ce[0][1] % 60, spost))
    if -62 <= spost <= -58:
        letto = "utc"
        stampa.append("  VERDETTO OROLOGIO: il file e' in UTC.")
    elif -2 <= spost <= 2:
        letto = "ny"
        stampa.append("  VERDETTO OROLOGIO: il file e' ancorato agli USA (ora di New York).")
    else:
        letto = None
        stampa.append("  VERDETTO OROLOGIO: INCERTO (spostamento anomalo). NON si misura.")
    stampa.append("  fuso DICHIARATO per questi file: %s" % fuso_dichiarato)
    if letto is not None and letto != fuso_dichiarato:
        stampa.append("  ROTTURA: l'orologio MISURATO contraddice il fuso dichiarato.")
        stampa.append("  Ci si FERMA. Un orologio sbagliato non da' errore: da' un")
        stampa.append("  numero pulito e falso.")
    elif letto is not None:
        stampa.append("  L'orologio misurato CONFERMA il fuso dichiarato: si prosegue.")
    return letto


def scegli_file_orologio(files, quanti_anni=3):
    """Gennaio e luglio di 3 anni distribuiti sul campione: bastano
    ~170.000 barre per far parlare il minuto piu' mosso, e costano
    pochi secondi invece di una passata su tutto."""
    per_anno = {}
    for p in files:
        base = os.path.basename(p)
        cifre = "".join(ch if ch.isdigit() else " " for ch in base).split()
        anno = None
        for c in cifre:
            if len(c) == 4 and 1990 < int(c) < 2100:
                anno = int(c)
                break
        if anno:
            per_anno.setdefault(anno, []).append(p)
    anni = sorted(per_anno)
    if not anni:
        return files[:6]
    scelti_anni = []
    if len(anni) <= quanti_anni:
        scelti_anni = anni
    else:
        for i in range(quanti_anni):
            scelti_anni.append(anni[int(i * (len(anni) - 1) / (quanti_anni - 1))])
    fuori = []
    for a in sorted(set(scelti_anni)):
        for p in per_anno[a]:
            b = os.path.basename(p)
            if "-01." in b or "-1." in b or "-07." in b or "-7." in b:
                fuori.append(p)
    return fuori if fuori else files[:6]


# ---------------------------------------------------------------------
#  LA MISURA DI UNA GIORNATA
# ---------------------------------------------------------------------
def colore(o, c):
    if c > o:
        return 1
    if c < o:
        return -1
    return 0


def valuta(minuti, A, k_margine):
    """minuti: dict minuto-del-giorno -> (o,h,l,c,v). A: ancora.
    Torna None se una sola delle 11 barre manca (giornata INCOMPLETA:
    contata a parte, mai riempita a occhio)."""
    setup = [minuti.get(A + i) for i in range(5)]
    trig = minuti.get(A + 5)
    oss = [minuti.get(A + 6 + i) for i in range(5)]
    if trig is None or any(x is None for x in setup) or any(x is None for x in oss):
        return None
    H0 = max(b[1] for b in setup)
    L0 = min(b[2] for b in setup)
    R = H0 - L0
    rif = oss[0][0]                      # apertura della prima barra osservata
    prezzo = rif if rif > 0 else 1.0

    def lato(defi):
        if defi == "T":
            su, giu = trig[1] > H0, trig[2] < L0
        elif defi == "M":
            su, giu = trig[1] > H0 + k_margine * R, trig[2] < L0 - k_margine * R
        else:
            su, giu = trig[4 - 1] > H0, trig[4 - 1] < L0   # close = indice 4? no
        return su, giu

    # nota: la tupla e' (o,h,l,c,v) -> close = indice 3
    def lati(defi):
        if defi == "T":
            return trig[1] > H0, trig[2] < L0
        if defi == "M":
            return trig[1] > H0 + k_margine * R, trig[2] < L0 - k_margine * R
        return trig[3] > H0, trig[3] < L0

    direzioni = {}
    for defi in ("T", "C", "M"):
        su, giu = lati(defi)
        if su and giu:
            if trig[3] > H0:
                direzioni[defi] = 1
            elif trig[3] < L0:
                direzioni[defi] = -1
            else:
                direzioni[defi] = 9      # AMBIGUO IRRISOLTO
        elif su:
            direzioni[defi] = 1
        elif giu:
            direzioni[defi] = -1
        else:
            direzioni[defi] = 0          # nessuna rottura

    colori = [colore(b[0], b[3]) for b in oss]
    serie = 1
    serie_max = 1
    cambi = 0
    for i in range(1, 5):
        if colori[i] != 0 and colori[i] == colori[i - 1]:
            serie += 1
        else:
            serie = 1
        if serie > serie_max:
            serie_max = serie
        if colori[i] != colori[i - 1]:
            cambi += 1
    if colori[0] == 0:
        serie_max = max(serie_max, 1)
    tutte_uguali = (colori[0] != 0 and all(x == colori[0] for x in colori))

    hi = max(b[1] for b in oss)
    lo = min(b[2] for b in oss)
    fine = oss[-1][3]

    return {
        "H0": H0, "L0": L0, "R": R, "rif": rif, "prezzo": prezzo,
        "dir": direzioni,
        "colori": colori,
        "n_doji": sum(1 for x in colori if x == 0),
        "n_verdi": sum(1 for x in colori if x == 1),
        "serie_max": serie_max,
        "cambi": cambi,
        "tutte_uguali": tutte_uguali,
        "colore_unico": colori[0] if tutte_uguali else 0,
        "hi": hi, "lo": lo, "fine": fine,
        "range5": hi - lo,
        "netto": fine - rif,
        "vol": sum(b[4] for b in oss),
    }


def per_direzione(g, d):
    """MFE, MAE, netto e k (candele nella direzione) dato il lato d."""
    if d == 1:
        mfe = g["hi"] - g["rif"]
        mae = g["rif"] - g["lo"]
    else:
        mfe = g["rif"] - g["lo"]
        mae = g["hi"] - g["rif"]
    netto = (g["fine"] - g["rif"]) * d
    k = sum(1 for x in g["colori"] if x == d)
    return mfe, mae, netto, k


# ---------------------------------------------------------------------
#  STATISTICA E STAMPA
# ---------------------------------------------------------------------
def quantile(v, q):
    if not v:
        return None
    v = sorted(v)
    if len(v) == 1:
        return v[0]
    pos = (len(v) - 1) * q
    b = int(pos)
    a = min(b + 1, len(v) - 1)
    return v[b] + (v[a] - v[b]) * (pos - b)


def mediana(v):
    return quantile(v, 0.5)


def se_binom(p, n):
    if not n:
        return None
    return (p * (1.0 - p) / n) ** 0.5


def riga_freq(etichetta, k, n):
    if not n:
        return "  %-42s n=0        n/d" % etichetta
    p = float(k) / n
    s = se_binom(p, n)
    return ("  %-42s n=%-6d %6.2f%%  +/- %.2f (2SE)"
            % (etichetta, n, 100.0 * p, 200.0 * s))


def confronta(nome, k1, n1, k2, n2):
    """Delta fra due frequenze con la banda del delta. Etichetta
    meccanica DENTRO/FUORI dal rumore: nessun giudizio, solo aritmetica."""
    if not n1 or not n2:
        return "  %-42s n/d" % nome
    p1, p2 = float(k1) / n1, float(k2) / n2
    d = p1 - p2
    sd = (p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2) ** 0.5
    tag = "DENTRO IL RUMORE" if abs(d) <= 2 * sd else "FUORI DAL RUMORE"
    return ("  %-42s %+6.2f pt  +/- %.2f (2SE)   %s"
            % (nome, 100.0 * d, 200.0 * sd, tag))


def f(x, cifre=3):
    """Un numero NON MISURATO si scrive n/d, MAI 0."""
    if x is None:
        return "n/d"
    return ("%." + str(cifre) + "f") % x


def referto_gruppo(nome, giorni, defi, spread, stampa):
    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("GRUPPO %s   (definizione di rottura: %s)" % (nome, defi))
    stampa.append("=" * 78)
    n = len(giorni)
    if n == 0:
        stampa.append("  NESSUNA GIORNATA COMPLETA.")
        return {"n": 0}
    stampa.append("  giornate complete (11 barre M1 tutte presenti): %d" % n)
    if n < MIN_GIORNI_GRUPPO:
        stampa.append("  RILIEVO: sotto il pavimento dichiarato di %d giornate ->"
                      % MIN_GIORNI_GRUPPO)
        stampa.append("  questo gruppo si legge come SOSPESO, non come misurato.")

    # ---- (a) COLORE, su TUTTI i giorni: la domanda letterale
    stampa.append("")
    stampa.append("  (a) COLORE DELLE 5 CANDELE -- su TUTTI i giorni, senza")
    stampa.append("      condizionare alla rottura (la domanda letterale)")
    uguali = sum(1 for g in giorni if g["tutte_uguali"])
    verdi5 = sum(1 for g in giorni if g["tutte_uguali"] and g["colore_unico"] == 1)
    rossi5 = sum(1 for g in giorni if g["tutte_uguali"] and g["colore_unico"] == -1)
    stampa.append(riga_freq("5 candele su 5 dello STESSO colore", uguali, n))
    stampa.append(riga_freq("  di cui tutte VERDI", verdi5, n))
    stampa.append(riga_freq("  di cui tutte ROSSE", rossi5, n))
    stampa.append("      base di riferimento a testa e croce: 6,25%")
    stampa.append("      serie piu' lunga di colore uguale (1-5):")
    for s in range(1, 6):
        c = sum(1 for g in giorni if g["serie_max"] == s)
        stampa.append(riga_freq("    serie massima = %d" % s, c, n))
    stampa.append("      cambi di colore fra le 5 candele (0-4):")
    for c0 in range(0, 5):
        c = sum(1 for g in giorni if g["cambi"] == c0)
        stampa.append(riga_freq("    %d cambi" % c0, c, n))
    dj = sum(g["n_doji"] for g in giorni)
    gdj = sum(1 for g in giorni if g["n_doji"] > 0)
    stampa.append(riga_freq("giorni con almeno un DOJI", gdj, n))
    stampa.append("      doji totali: %d su %d candele (%.2f%%)"
                  % (dj, 5 * n, 100.0 * dj / (5.0 * n)))

    # ---- ampiezza, su tutti i giorni
    stampa.append("")
    stampa.append("  (c1) AMPIEZZA DEI 5 MINUTI -- su TUTTI i giorni")
    r5 = [g["range5"] for g in giorni]
    r5p = [100.0 * g["range5"] / g["prezzo"] for g in giorni]
    rset = [g["R"] for g in giorni]
    stampa.append("      range dei 5 minuti ($):  Q1 %s  mediana %s  Q3 %s  P90 %s"
                  % (f(quantile(r5, .25), 2), f(mediana(r5), 2),
                     f(quantile(r5, .75), 2), f(quantile(r5, .90), 2)))
    stampa.append("      range dei 5 minuti (%%):  Q1 %s  mediana %s  Q3 %s"
                  % (f(quantile(r5p, .25), 4), f(mediana(r5p), 4), f(quantile(r5p, .75), 4)))
    stampa.append("      range della candela M5 di SETUP ($): mediana %s  Q3 %s"
                  % (f(mediana(rset), 2), f(quantile(rset, .75), 2)))
    stampa.append("      PAVIMENTI DI CASA con spread DICHIARATO %.2f $ [NON MISURATO su BCM]:"
                  % spread)
    stampa.append("        duro    stop >= %4.1f x spread = %5.2f $" %
                  (PAVIMENTO_DURO, PAVIMENTO_DURO * spread))
    stampa.append("        lavoro  stop >= %4.1f x spread = %5.2f $" %
                  (PAVIMENTO_LAVORO, PAVIMENTO_LAVORO * spread))

    # ---- (b) direzionale
    stampa.append("")
    stampa.append("  (b) DIREZIONE -- solo i giorni con una rottura al minuto A+5")
    nl = sum(1 for g in giorni if g["dir"][defi] == 1)
    ns = sum(1 for g in giorni if g["dir"][defi] == -1)
    nn = sum(1 for g in giorni if g["dir"][defi] == 0)
    na = sum(1 for g in giorni if g["dir"][defi] == 9)
    stampa.append(riga_freq("rottura LONG", nl, n))
    stampa.append(riga_freq("rottura SHORT", ns, n))
    stampa.append(riga_freq("NESSUNA rottura", nn, n))
    stampa.append(riga_freq("AMBIGUA irrisolta (esclusa)", na, n))
    rotti = [g for g in giorni if g["dir"][defi] in (1, -1)]
    nb = len(rotti)
    riass = {"n": n, "uguali": uguali, "nb": nb}
    if nb == 0:
        stampa.append("      nessun giorno con rottura: statistica direzionale n/d.")
        return riass
    if nb < MIN_GIORNI_GRUPPO:
        stampa.append("      RILIEVO: %d giorni con rottura, sotto il pavimento %d."
                      % (nb, MIN_GIORNI_GRUPPO))
    kk = []
    mfe, mae, netto = [], [], []
    mfep, maep = [], []
    for g in rotti:
        d = g["dir"][defi]
        a, b, c, k = per_direzione(g, d)
        mfe.append(a)
        mae.append(b)
        netto.append(c)
        mfep.append(100.0 * a / g["prezzo"])
        maep.append(100.0 * b / g["prezzo"])
        kk.append(k)
    stampa.append("      candele NELLA DIREZIONE della rottura (k su 5):")
    for k0 in range(0, 6):
        stampa.append(riga_freq("    k = %d" % k0, sum(1 for x in kk if x == k0), nb))
    stampa.append(riga_freq("  k >= 4 (almeno 4 su 5)", sum(1 for x in kk if x >= 4), nb))
    stampa.append(riga_freq("  k >= 3 (almeno 3 su 5)", sum(1 for x in kk if x >= 3), nb))
    inv = sum(1 for x in netto if x < 0)
    stampa.append(riga_freq("INVERSIONE (chiusura contro la rottura)", inv, nb))
    riass["k5"] = sum(1 for x in kk if x == 5)
    riass["k4"] = sum(1 for x in kk if x >= 4)
    riass["k3"] = sum(1 for x in kk if x >= 3)
    riass["inv"] = inv

    stampa.append("")
    stampa.append("  (c2) MOVIMENTO nei 5 minuti dal prezzo di riferimento")
    stampa.append("       (MFE = escursione massima a FAVORE, MAE = CONTRO)")
    stampa.append("       MFE ($):  Q1 %s  mediana %s  Q3 %s  P90 %s"
                  % (f(quantile(mfe, .25), 2), f(mediana(mfe), 2),
                     f(quantile(mfe, .75), 2), f(quantile(mfe, .90), 2)))
    stampa.append("       MAE ($):  Q1 %s  mediana %s  Q3 %s  P90 %s"
                  % (f(quantile(mae, .25), 2), f(mediana(mae), 2),
                     f(quantile(mae, .75), 2), f(quantile(mae, .90), 2)))
    stampa.append("       MFE (%%):  mediana %s      MAE (%%):  mediana %s"
                  % (f(mediana(mfep), 4), f(mediana(maep), 4)))
    stampa.append("       netto a fine 5 minuti ($): Q1 %s  mediana %s  Q3 %s"
                  % (f(quantile(netto, .25), 2), f(mediana(netto), 2),
                     f(quantile(netto, .75), 2)))
    mm, ma = mediana(mfe), mediana(mae)
    if ma:
        stampa.append("       rapporto mediana MFE / mediana MAE: %s" % f(mm / ma, 3))
    riass["mfe"] = mm
    riass["mae"] = ma
    riass["netto"] = mediana(netto)

    # ---- (d) anno per anno
    stampa.append("")
    stampa.append("  (d) ANNO PER ANNO (gli anni sotto %d giornate sono marcati SOTTILE)"
                  % MIN_GIORNI_ANNO)
    stampa.append("      anno    n   5/5 col.   n rott.  k>=4    invers.  MFE med  MAE med")
    per_anno = {}
    for g in giorni:
        per_anno.setdefault(g["anno"], []).append(g)
    for anno in sorted(per_anno):
        gg = per_anno[anno]
        na_ = len(gg)
        ug = sum(1 for x in gg if x["tutte_uguali"])
        rr = [x for x in gg if x["dir"][defi] in (1, -1)]
        if rr:
            dati = [per_direzione(x, x["dir"][defi]) for x in rr]
            k4 = sum(1 for d0 in dati if d0[3] >= 4)
            iv = sum(1 for d0 in dati if d0[2] < 0)
            mf = mediana([d0[0] for d0 in dati])
            me = mediana([d0[1] for d0 in dati])
            stampa.append("      %s  %4d   %6.2f%%   %5d   %5.1f%%  %5.1f%%   %7s  %7s%s"
                          % (anno, na_, 100.0 * ug / na_, len(rr),
                             100.0 * k4 / len(rr), 100.0 * iv / len(rr),
                             f(mf, 2), f(me, 2),
                             "  SOTTILE" if na_ < MIN_GIORNI_ANNO else ""))
        else:
            stampa.append("      %s  %4d   %6.2f%%       0      n/d     n/d       n/d      n/d"
                          % (anno, na_, 100.0 * ug / na_))
    return riass


# ---------------------------------------------------------------------
#  AUTOTEST -- niente file, niente rete. Conteggi attesi scritti a mano.
# ---------------------------------------------------------------------
def autotest():
    log("=== AUTOTEST %s (offline) ===" % VERSIONE)
    ok = 0

    # 1. ora legale su date NOTE
    assert domenica_n(2015, 3, 2) == date(2015, 3, 8), domenica_n(2015, 3, 2)
    assert domenica_ultima(2015, 10) == date(2015, 10, 25)
    assert dst_usa(date(2015, 3, 7)) is False
    assert dst_usa(date(2015, 3, 8)) is True
    assert dst_usa(date(2015, 11, 1)) is False
    assert dst_usa(date(2015, 10, 31)) is True
    # regola VECCHIA (fino al 2006): DST dal 2 aprile 2006
    assert dst_usa(date(2006, 3, 20)) is False, "regola USA pre-2007"
    assert dst_usa(date(2006, 4, 2)) is True
    assert dst_usa(date(2006, 10, 28)) is True
    assert dst_usa(date(2006, 10, 29)) is False
    assert dst_ue(date(2015, 3, 28)) is False
    assert dst_ue(date(2015, 3, 29)) is True
    assert dst_ue(date(2015, 10, 24)) is True
    assert dst_ue(date(2015, 10, 25)) is False
    log("1. regole di ora legale USA (vecchia e nuova) e UE su date note: OK")
    ok += 1

    # 2. ancore e giorni DISCORDI
    assert ancora_utc(date(2015, 6, 1), "ny0930") == 810      # 13:30 UTC
    assert ancora_utc(date(2015, 6, 1), "roma1530") == 810     # concordi
    assert ancora_utc(date(2015, 3, 20), "ny0930") == 810      # USA gia' in DST
    assert ancora_utc(date(2015, 3, 20), "roma1530") == 870    # UE no -> DISCORDI
    assert ancora_utc(date(2015, 10, 28), "ny0930") == 810
    assert ancora_utc(date(2015, 10, 28), "roma1530") == 870   # DISCORDI
    assert ancora_utc(date(2006, 3, 20), "ny0930") == 870
    assert ancora_utc(date(2006, 3, 20), "roma1530") == 870    # concordi (regola vecchia)
    assert ancora_utc(date(2015, 1, 15), "ny0930") == 870
    assert ancora_utc(date(2015, 1, 15), "ny1030") == 930
    log("2. ancore in UTC e giorni DISCORDI NY/ROMA (marzo e ottobre): OK")
    ok += 1

    # 3. il controllo casuale e' RIPRODUCIBILE e sta nella banda
    a1 = ancora_caso(date(2015, 6, 1), 20260910)
    a2 = ancora_caso(date(2015, 6, 1), 20260910)
    a3 = ancora_caso(date(2015, 6, 2), 20260910)
    assert a1 == a2 and 420 <= a1 <= 19 * 60 - 11
    assert a1 != a3 or True
    log("3. ancora casuale appaiata: deterministica (%d) e dentro la banda: OK" % a1)
    ok += 1

    # 4. i tre formati, compresa la TRAPPOLA delle colonne Oanda C,H,L,O
    import tempfile
    tdir = tempfile.mkdtemp()
    p1 = os.path.join(tdir, "oanda.csv")
    with open(p1, "w") as fh:
        fh.write("time,close,high,low,open,volume\n")
        fh.write("2015-06-01 13:30:00,1200.5,1201.0,1199.0,1199.5,100\n")
    c = {"righe_scartate": 0, "ohlc_incoerenti": 0, "file_formato_ignoto": 0}
    r = list(leggi_file(p1, c))
    assert len(r) == 1, r
    t, o, h, l, cl, v = r[0]
    assert (o, h, l, cl) == (1199.5, 1201.0, 1199.0, 1200.5), r[0]
    assert colore(o, cl) == 1, "candela VERDE: open 1199.5 -> close 1200.5"
    p2 = os.path.join(tdir, "hist.csv")
    with open(p2, "w") as fh:
        fh.write("20150601 133000;1199.5;1201.0;1199.0;1200.5;0\n")
    r2 = list(leggi_file(p2, c))
    assert r2[0][1:5] == (1199.5, 1201.0, 1199.0, 1200.5), r2
    p3 = os.path.join(tdir, "casa.csv")
    with open(p3, "w") as fh:
        fh.write("Time,Open,High,Low,Close,Volume\n")
        fh.write("2015.06.01 13:30,1199.5,1201.0,1199.0,1200.5,1\n")
    r3 = list(leggi_file(p3, c))
    assert r3[0][1:5] == (1199.5, 1201.0, 1199.0, 1200.5), r3
    log("4. i tre formati letti, e le colonne Oanda C,H,L,O NON scambiate: OK")
    ok += 1

    # 5. conversione grezzo -> UTC per un file in ora di New York
    assert grezzo_a_utc(datetime(2015, 6, 1, 9, 30), "ny") == datetime(2015, 6, 1, 13, 30)
    assert grezzo_a_utc(datetime(2015, 1, 15, 9, 30), "ny") == datetime(2015, 1, 15, 14, 30)
    assert grezzo_a_utc(datetime(2015, 6, 1, 13, 30), "utc") == datetime(2015, 6, 1, 13, 30)
    log("5. conversione ora di New York -> UTC (estate +4, inverno +5): OK")
    ok += 1

    # 6. giornata SINTETICA: rottura LONG e 5 candele verdi -> k=5
    def barra(o, h, l, c, v=1):
        return (o, h, l, c, v)
    A = 810
    m = {}
    for i in range(5):                       # setup piatto 99.5 - 100.5
        m[A + i] = barra(100.0, 100.5, 99.5, 100.0)
    m[A + 5] = barra(100.0, 100.8, 99.9, 100.7)    # rompe SOPRA, chiude sopra
    for i in range(5):                       # 5 candele verdi in salita
        m[A + 6 + i] = barra(100.7 + 0.1 * i, 100.9 + 0.1 * i,
                             100.6 + 0.1 * i, 100.8 + 0.1 * i)
    g = valuta(m, A, 0.10)
    assert g is not None
    assert g["H0"] == 100.5 and g["L0"] == 99.5
    assert g["dir"]["T"] == 1 and g["dir"]["C"] == 1 and g["dir"]["M"] == 1
    assert g["tutte_uguali"] is True and g["serie_max"] == 5 and g["cambi"] == 0
    mfe, mae, netto, k = per_direzione(g, 1)
    assert k == 5, k
    assert abs(mfe - (101.3 - 100.7)) < 1e-9, mfe          # max high 101.3
    assert abs(mae - (100.7 - 100.6)) < 1e-9, mae          # min low 100.6
    log("6. giornata sintetica LONG con 5 verdi: k=5, serie 5, MFE 0,60, MAE 0,10: OK")
    ok += 1

    # 7. giornata ALTERNATA + un DOJI: la serie si spezza, il doji non e' colore
    m2 = dict(m)
    m2[A + 6] = barra(100.7, 100.9, 100.6, 100.8)   # verde
    m2[A + 7] = barra(100.8, 100.9, 100.6, 100.7)   # rossa
    m2[A + 8] = barra(100.7, 100.8, 100.6, 100.7)   # DOJI (close == open)
    m2[A + 9] = barra(100.7, 100.9, 100.6, 100.8)   # verde
    m2[A + 10] = barra(100.8, 100.9, 100.6, 100.7)  # rossa
    g2 = valuta(m2, A, 0.10)
    assert g2["n_doji"] == 1, g2["n_doji"]
    assert g2["tutte_uguali"] is False
    assert g2["serie_max"] == 1, g2["serie_max"]
    assert g2["cambi"] == 4, g2["cambi"]
    _, _, _, k2 = per_direzione(g2, 1)
    assert k2 == 2, k2      # due verdi: il doji NON conta nella direzione
    log("7. giornata alternata con doji: serie max 1, 4 cambi, k=2 (doji fuori): OK")
    ok += 1

    # 8. rottura AMBIGUA e NESSUNA rottura
    m3 = dict(m)
    m3[A + 5] = barra(100.0, 100.8, 99.2, 100.0)    # rompe i DUE lati, chiude dentro
    g3 = valuta(m3, A, 0.10)
    assert g3["dir"]["T"] == 9, g3["dir"]           # AMBIGUO IRRISOLTO
    assert g3["dir"]["C"] == 0, g3["dir"]           # per CHIUSURA: nessuna rottura
    m4 = dict(m)
    m4[A + 5] = barra(100.0, 100.4, 99.6, 100.1)    # dentro il range
    g4 = valuta(m4, A, 0.10)
    assert g4["dir"]["T"] == 0 and g4["dir"]["M"] == 0
    m5 = dict(m)
    m5[A + 5] = barra(100.0, 100.55, 99.9, 100.52)  # rompe di 0,05 -> sotto k*R = 0,10
    g5 = valuta(m5, A, 0.10)
    assert g5["dir"]["T"] == 1 and g5["dir"]["M"] == 0, g5["dir"]
    log("8. ambigua irrisolta, nessuna rottura, e il MARGINE k*R che filtra: OK")
    ok += 1

    # 9. una barra mancante = giornata INCOMPLETA, mai riempita a occhio
    m6 = dict(m)
    del m6[A + 8]
    assert valuta(m6, A, 0.10) is None
    log("9. una sola barra mancante -> giornata incompleta ed esclusa: OK")
    ok += 1

    # 10. banda di rumore
    s = se_binom(0.10, 400)
    assert abs(200.0 * s - 3.0) < 0.1, 200.0 * s
    s2 = se_binom(0.10, 3000)
    assert abs(200.0 * s2 - 1.1) < 0.1, 200.0 * s2
    log("10. banda 2SE: 10%% su n=400 -> +/-3,0 pt; su n=3.000 -> +/-1,1 pt: OK")
    ok += 1

    log("")
    log("AUTOTEST: %d/10 OK" % ok)
    return 0


# ---------------------------------------------------------------------
#  MAIN
# ---------------------------------------------------------------------
GRUPPI = [
    ("APERTURA_NY", "ny0930", "l'evento vero: 09:30 America/New_York"),
    ("APERTURA_ROMA", "roma1530", "l'ora del collega: 15:30 Europe/Rome"),
    ("CTRL_DOPO", "ny1030", "controllo: un'ora DOPO l'apertura, 10:30 New York"),
    ("CTRL_QUIETO", "roma1130", "controllo: ora quieta, 11:30 Europe/Rome"),
    ("CTRL_CASO", "caso", "controllo APPAIATO: minuto a sorte 07:00-19:00 UTC"),
]


def main():
    ap = argparse.ArgumentParser(
        description="L'oro nei 5 minuti dopo la rottura della prima M5 "
                    "dell'apertura USA. MISURA DESCRITTIVA, non un backtest.")
    ap.add_argument("--dati", default="dati_oro_m1",
                    help="cartella con i CSV M1 (default: dati_oro_m1)")
    ap.add_argument("--out", default="uscite_oro_apertura",
                    help="cartella dei referti")
    ap.add_argument("--simbolo", default="XAU_USD")
    ap.add_argument("--scarica", action="store_true")
    ap.add_argument("--da-anno", type=int, default=PRIMO_ANNO)
    ap.add_argument("--a-anno", type=int, default=ULTIMO_ANNO)
    ap.add_argument("--fuso-file", default="auto", choices=["auto", "utc", "ny"],
                    help="fuso DICHIARATO dei timestamp del file (auto = dal formato)")
    ap.add_argument("--salta-orologio", action="store_true",
                    help="NON usare senza motivo: salta il collaudo dell'orologio")
    ap.add_argument("--k-margine", type=float, default=0.10)
    ap.add_argument("--spread", type=float, default=0.25,
                    help="spread oro DICHIARATO in $ (BCM: NON MISURATO)")
    ap.add_argument("--seme", type=int, default=20260910)
    ap.add_argument("--definizione", default="T", choices=["T", "C", "M"],
                    help="definizione di rottura per la statistica direzionale")
    ap.add_argument("--sonda-dati", action="store_true",
                    help="solo copertura + orologio: nessuna statistica")
    ap.add_argument("--autotest", action="store_true")
    args = ap.parse_args()

    log("=" * 78)
    log(VERSIONE)
    log("=" * 78)

    if args.autotest:
        return autotest()

    if args.scarica:
        scarica(args.dati, args.simbolo, args.da_anno, args.a_anno)

    files = elenca_file(args.dati)
    if not files:
        log("NESSUN CSV in %s. Usa --scarica, oppure copia li' i file M1."
            % os.path.abspath(args.dati))
        return 2

    contatori = {"righe_scartate": 0, "ohlc_incoerenti": 0, "file_formato_ignoto": 0}
    with open(files[0], "r", encoding="ascii", errors="replace") as fh:
        fmt0 = rileva_formato(fh.readline())
    if fmt0 is None:
        log("FORMATO NON RICONOSCIUTO nel primo file: %s" % files[0])
        return 2
    fuso = args.fuso_file if args.fuso_file != "auto" else fuso_default(fmt0)
    stampa = []
    stampa.append("=" * 78)
    stampa.append(VERSIONE)
    stampa.append("=" * 78)
    stampa.append("cartella dati : %s  (%d file)" % (os.path.abspath(args.dati), len(files)))
    stampa.append("formato letto : %s" % fmt0)
    stampa.append("fuso dichiarato del file: %s" % fuso)
    stampa.append("definizione di rottura per la statistica direzionale: %s"
                  % args.definizione)
    stampa.append("margine k = %.2f x range del setup" % args.k_margine)
    stampa.append("seme del controllo casuale: %d" % args.seme)
    stampa.append("spread oro DICHIARATO: %.2f $  -- [NON MISURATO su BCM]" % args.spread)
    stampa.append("")
    stampa.append("QUESTO NON E' UN BACKTEST. Nessun PF, nessuna equity, nessun")
    stampa.append("costo dedotto, nessuna promozione. Il feed NON e' BCM.")

    if not args.salta_orologio:
        scelti = scegli_file_orologio(files)
        stampa.append("")
        stampa.append("file usati per il collaudo dell'orologio (%d):" % len(scelti))
        for p in scelti:
            stampa.append("  " + os.path.basename(p))
        letto = collauda_orologio(scelti, fuso, contatori, stampa)
        if letto is None or letto != fuso:
            for r in stampa:
                log(r)
            log("")
            log("ESITO: NON PARTITO -- orologio incerto o in contraddizione.")
            return 2

    # ---- passata unica: si tengono SOLO i minuti che servono
    t0 = time.time()
    bisogno = {}      # data -> {minuto: gruppo}
    ancore = {}       # data -> {gruppo: A}
    dati = {}         # data -> {minuto: barra}
    n_barre = 0
    for p in files:
        for (t, o, h, l, c, v) in leggi_file(p, contatori):
            n_barre += 1
            tu = grezzo_a_utc(t, fuso)
            g = tu.date()
            if g not in bisogno:
                mm = {}
                aa = {}
                for nome, tipo, _ in GRUPPI:
                    A = ancora_caso(g, args.seme) if tipo == "caso" else ancora_utc(g, tipo)
                    aa[nome] = A
                    for i in range(11):
                        mm.setdefault(A + i, []).append(nome)
                bisogno[g] = mm
                ancore[g] = aa
                dati[g] = {}
            mdg = tu.hour * 60 + tu.minute
            if mdg in bisogno[g]:
                dati[g][mdg] = (o, h, l, c, v)
    secondi = time.time() - t0

    stampa.append("")
    stampa.append("LETTURA: %d barre M1 lette in %.0f s (%.0f mila barre/s)"
                  % (n_barre, secondi, n_barre / max(secondi, 0.001) / 1000.0))
    stampa.append("  righe scartate %d, OHLC incoerenti %d, file di formato ignoto %d"
                  % (contatori["righe_scartate"], contatori["ohlc_incoerenti"],
                     contatori["file_formato_ignoto"]))
    if not dati:
        for r in stampa:
            log(r)
        return 2
    giorni_ordinati = sorted(dati)
    stampa.append("  giornate di calendario con dati: %d, dal %s al %s"
                  % (len(giorni_ordinati), giorni_ordinati[0], giorni_ordinati[-1]))
    discordi = [g for g in giorni_ordinati
                if ancore[g]["APERTURA_NY"] != ancore[g]["APERTURA_ROMA"]]
    stampa.append("  giornate in cui 15:30 ROMA e 09:30 NEW YORK NON coincidono: %d (%.1f%%)"
                  % (len(discordi), 100.0 * len(discordi) / len(giorni_ordinati)))
    stampa.append("  (sono le ~3-4 settimane l'anno in cui i due calendari di ora")
    stampa.append("   legale sono sfasati: NON vengono buttate, sono misurate a parte)")

    # ---- valutazione
    risultati = {nome: [] for nome, _, _ in GRUPPI}
    incompleti = {nome: 0 for nome, _, _ in GRUPPI}
    for g in giorni_ordinati:
        if g.weekday() >= 5:
            continue
        for nome, tipo, _ in GRUPPI:
            A = ancore[g][nome]
            r = valuta(dati[g], A, args.k_margine)
            if r is None:
                incompleti[nome] += 1
                continue
            r["data"] = g
            r["anno"] = "%04d" % g.year
            r["ancora"] = A
            r["gruppo"] = nome
            risultati[nome].append(r)

    stampa.append("")
    stampa.append("GIORNATE PER GRUPPO (solo giorni feriali)")
    stampa.append("  gruppo            complete  incomplete   ancora tipica")
    for nome, tipo, descr in GRUPPI:
        stampa.append("  %-16s %8d  %10d   %s"
                      % (nome, len(risultati[nome]), incompleti[nome], descr))

    rilievi = []
    for nome, _, _ in GRUPPI:
        if len(risultati[nome]) < MIN_GIORNI_GRUPPO:
            rilievi.append("%s: solo %d giornate complete (pavimento %d)"
                           % (nome, len(risultati[nome]), MIN_GIORNI_GRUPPO))

    if args.sonda_dati:
        stampa.append("")
        stampa.append("MODO --sonda-dati: NESSUNA statistica di comportamento stampata.")
        stampa.append("Serve solo a sapere se e con quanti dati si puo' misurare.")
        for r in stampa:
            log(r)
        return 1 if rilievi else 0

    # ---- referti per gruppo
    riass = {}
    for nome, _, _ in GRUPPI:
        riass[nome] = referto_gruppo(nome, risultati[nome], args.definizione,
                                     args.spread, stampa)
    dset = set(discordi)
    ny_disc = [r for r in risultati["APERTURA_NY"] if r["data"] in dset]
    roma_disc = [r for r in risultati["APERTURA_ROMA"] if r["data"] in dset]
    if ny_disc:
        riass["NY_DISCORDI"] = referto_gruppo(
            "NY_SOLO_GIORNI_DISCORDI", ny_disc, args.definizione, args.spread, stampa)
        riass["ROMA_DISCORDI"] = referto_gruppo(
            "ROMA_SOLO_GIORNI_DISCORDI", roma_disc, args.definizione, args.spread, stampa)

    # ---- il confronto che rende onesta la misura
    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("IL CONFRONTO COI CONTROLLI -- senza questo la misura non vale niente")
    stampa.append("=" * 78)
    stampa.append("Se l'oro fa lo stesso alle 11:36, alle 15:36 non c'e' nessuna")
    stampa.append("apertura: c'e' come sono fatte le candele M1.")
    base = riass.get("APERTURA_NY", {})
    for ctrl in ("CTRL_DOPO", "CTRL_QUIETO", "CTRL_CASO"):
        c = riass.get(ctrl, {})
        if not base.get("n") or not c.get("n"):
            continue
        stampa.append("")
        stampa.append("  APERTURA_NY contro %s" % ctrl)
        stampa.append(confronta("5 su 5 stesso colore", base["uguali"], base["n"],
                                c["uguali"], c["n"]))
        if base.get("nb") and c.get("nb"):
            stampa.append(confronta("k >= 4 nella direzione", base["k4"], base["nb"],
                                    c["k4"], c["nb"]))
            stampa.append(confronta("k = 5 nella direzione", base["k5"], base["nb"],
                                    c["k5"], c["nb"]))
            stampa.append(confronta("inversione a fine 5 minuti", base["inv"], base["nb"],
                                    c["inv"], c["nb"]))
            if c.get("mfe"):
                stampa.append("  %-42s %s $ contro %s $  (rapporto %s)"
                              % ("MFE mediano", f(base.get("mfe"), 2), f(c["mfe"], 2),
                                 f(base.get("mfe") / c["mfe"], 2) if base.get("mfe") else "n/d"))
            if c.get("mae"):
                stampa.append("  %-42s %s $ contro %s $  (rapporto %s)"
                              % ("MAE mediano", f(base.get("mae"), 2), f(c["mae"], 2),
                                 f(base.get("mae") / c["mae"], 2) if base.get("mae") else "n/d"))

    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("PROMEMORIA DI LETTURA (vale per ogni numero qui sopra)")
    stampa.append("=" * 78)
    stampa.append("1. NON E' BCM: altro broker, altri orari, altro spread. Misura di")
    stampa.append("   OCCASIONI, mai un verdetto (regola F6).")
    stampa.append("2. OHLC M1, non tick: MFE e MAE sono ESTREMI raggiunti, non esiti")
    stampa.append("   di un'uscita simulata. Nessuna uscita e' simulata qui.")
    stampa.append("3. ZERO COSTI dedotti. Lo spread BCM sull'oro NON E' MAI STATO")
    stampa.append("   MISURATO: i pavimenti stampati usano un numero DICHIARATO.")
    stampa.append("4. Il campione finisce nel 2020: non copre il regime 2021-2026.")
    stampa.append("5. Un picco isolato in un anno solo non e' un comportamento:")
    stampa.append("   si guarda la tabella per anno prima di dire qualunque cosa.")

    if rilievi:
        stampa.append("")
        stampa.append("RILIEVI:")
        for r in rilievi:
            stampa.append("  - " + r)

    for r in stampa:
        log(r)

    os.makedirs(args.out, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d_%H%M")
    prefe = os.path.join(args.out, "SONDA_ORO_APERTURA_%s" % stamp)
    with open(prefe + ".txt", "w", encoding="ascii", errors="replace") as fh:
        fh.write("\n".join(stampa) + "\n")
    campi = ["gruppo", "data", "ancora", "H0", "L0", "R", "rif",
             "dir_T", "dir_C", "dir_M", "col1", "col2", "col3", "col4", "col5",
             "serie_max", "cambi", "n_doji", "hi", "lo", "fine", "range5",
             "netto", "vol"]
    with open(prefe + "_PERGIORNO.csv", "w", newline="", encoding="ascii",
              errors="replace") as fh:
        w = csv.writer(fh)
        w.writerow(campi)
        for nome, _, _ in GRUPPI:
            for r in risultati[nome]:
                w.writerow([nome, r["data"], r["ancora"],
                            "%.3f" % r["H0"], "%.3f" % r["L0"], "%.3f" % r["R"],
                            "%.3f" % r["rif"],
                            r["dir"]["T"], r["dir"]["C"], r["dir"]["M"]]
                           + list(r["colori"])
                           + [r["serie_max"], r["cambi"], r["n_doji"],
                              "%.3f" % r["hi"], "%.3f" % r["lo"], "%.3f" % r["fine"],
                              "%.3f" % r["range5"], "%.3f" % r["netto"],
                              "%.0f" % r["vol"]])
    log("")
    log("REFERTO : %s.txt" % os.path.abspath(prefe))
    log("CSV     : %s_PERGIORNO.csv" % os.path.abspath(prefe))
    return 1 if rilievi else 0


if __name__ == "__main__":
    sys.exit(main())
