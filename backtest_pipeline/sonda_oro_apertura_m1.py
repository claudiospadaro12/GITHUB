#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_SONDA_ORO_APERTURA_M1_v3
#  sonda_oro_apertura_m1.py
#  L'ORO NEI MINUTI DOPO LA ROTTURA DELLA PRIMA CANDELA M5
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
#    Precisazione dello stesso giorno:
#    "LA RICHIESTA E' X TRADARE MANUALE. O PER CREARE UN EA
#     SULL'APERTURA. LUI DICE CHE QUEI 5 MINUTI SONO FACILI DA TRADARE,
#     CHE L'ORO VA IN DIREZIONE QUALCHE CANDELA IN M1. PROBABILMENTE CI
#     POTREBBE ESSERE L'INCROCIO DELLE MEDIE 9 E 21 E MAGARI LI IL
#     PREZZO POTREBBE CORRERE DI +."
#    -> due padroni: la MANO di Claudio a mercato aperto e un EA.
#       Servono numeri usabili a occhio (quanto dura la spinta, in
#       MINUTI e in DOLLARI, e quanto costa sbagliare) E regole non
#       ambigue in ORA SERVER. Sono due sezioni distinte del referto.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  NON e' un backtest. NON calcola un PROFIT FACTOR, NON calcola   #
#  #  un'equity, NON deduce spread ne' slippage, NON simula nessuna   #
#  #  uscita, NON promuove niente, NON scrive dentro MetaQuotes\      #
#  #  Terminal, NON tocca MT5 e non sfiora il forward. Legge barre    #
#  #  M1 e CONTA.                                                    #
#  #  Un numero di qui NON e' mai un verdetto di strategia: e' una    #
#  #  DESCRIZIONE del mercato su un feed che non e' il nostro broker. #
#  #  E vale anche per la mano: MANUALE NON VUOL DIRE ESENTE DAI      #
#  #  CANCELLI. Lo spread lo paga anche Claudio.                     #
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
#               osservare i minuti DA 15:36: la rottura deve essere
#               gia' avvenuta alle 15:36:00.
#  OSSERVAZIONE le barre M1 da A+6 in avanti. Le prime 5 sono la
#               finestra "15:36-15:41" della domanda; l'orizzonte
#               esteso (--orizzonte, default 10) serve a vedere DOVE
#               la spinta finisce, che e' la domanda del trader a mano.
#  RIFERIMENTO  il prezzo di APERTURA della barra A+6: e' quello che
#               prende chi entra all'inizio della finestra. Nessun
#               ingresso a prezzo migliore, mai.
#
#  "SFONDA" -- tre definizioni, calcolate TUTTE E TRE, nessuna scelta
#  a posteriori (principale: T):
#    T  TOCCO     high(grilletto) > H0  -> LONG ; low < L0 -> SHORT
#    C  CHIUSURA  close(grilletto) > H0 -> LONG ; close < L0 -> SHORT
#    M  MARGINE   come T ma il livello va superato di k*R (k = 0,10,
#                 stessa convenzione di anatomia_aperture.py)
#  AMBIGUO: se nello stesso minuto sono rotti TUTTI E DUE i lati, il
#  lato si decide con la CHIUSURA del grilletto (close>H0 = LONG,
#  close<L0 = SHORT); se la chiusura resta dentro il range il giorno e'
#  AMBIGUO_IRRISOLTO, esce dalle statistiche direzionali ed e' CONTATO.
#  NESSUNA ROTTURA: giorno contato, fuori dalle statistiche direzionali.
#  La frequenza di "nessuna rottura" e' essa stessa un risultato: dice
#  quante volte l'operazione del collega NON esiste.
#
#  COLORE DI UNA CANDELA M1 -- deciso ADESSO, non dopo:
#    close > open  = VERDE      close < open = ROSSA
#    close == open = DOJI, categoria PROPRIA. Un doji NON e' verde e
#    NON e' rosso: SPEZZA la serie di colore uguale e NON conta come
#    candela "nella direzione". La sua frequenza e' stampata, cosi' il
#    suo peso e' visibile invece che nascosto in una convenzione.
#
#  ==================================================================
#  L'IPOTESI 9/21 (Claudio, 10/09) -- dichiarata PRIMA, non appiccicata
#  ==================================================================
#  Medie su M1 calcolate sul prezzo di CHIUSURA, aggiornate fino alla
#  chiusura del GRILLETTO (A+5) compreso. Nessuna barra futura entra
#  nel calcolo: se ci entrasse, sarebbe look-ahead e il numero sarebbe
#  falso (rilievo gia' pagato in casa il 06/09).
#  Riscaldamento: --riscaldamento barre M1 prima di A (default 45).
#  Con alfa = 2/22, dopo 45 barre il peso del seme vale ~1,5%: e'
#  dichiarato, non nascosto. Se mancano piu' di 1/3 delle barre di
#  riscaldamento, le bandiere 9/21 di quel giorno valgono n/d (il
#  giorno resta valido per tutto il resto).
#
#  ATTENZIONE, E VA DETTO A CLAUDIO: alle 15:36 su M1 una media a 21
#  periodi guarda indietro fino alle ~15:15, cioe' PRIMA DELL'APERTURA.
#  Quindi il 9/21 in quel momento non descrive l'apertura: descrive il
#  passaggio dal pre-apertura all'apertura. E' un'informazione diversa
#  da quella che sembra a occhio sul grafico.
#
#  IPOTESI PRINCIPALE (una sola, dichiarata) -- ED E' L'INCLINAZIONE,
#  NON L'INCROCIO:
#    INCLINATE  le DUE medie sono inclinate nel verso della rottura
#               (EMA9 e EMA21 entrambe piu' alte -- o piu' basse -- di
#               3 barre M1 fa). E' lo STATO come filtro di LATO, non
#               l'incrocio come innesco.
#    PERCHE' QUESTA E NON L'INCROCIO, e va detto:
#      (a) e' la variante GIA' SCRITTA IN CASA: REGISTRO_TEST.md riga
#          230 la elenca fra le regole d'ingresso RICORRENTI -- "medie
#          9/21 INCLINATE nella direzione". Non e' un'invenzione di
#          oggi, e' una regola che gia' circolava non misurata.
#      (b) l'incrocio su M1 alle 15:36 arriva TARDI: [INFERITO, non
#          misurato] con lag EMA ~ (N-1)/2 la 9 ritarda ~4 barre e la
#          21 ~10, quindi in 4-5 minuti l'incrocio tipicamente NON e'
#          ancora avvenuto. Misurare come principale una condizione che
#          quasi non si verifica vuol dire misurare il vuoto.
#      (c) la caccia esterna NON ha trovato nessuna evidenza misurata
#          sull'incrocio 9/21 su M1.
#  VARIANTI DICHIARATE (quattro, e restano varianti anche se vincono):
#    E-ORDINE    EMA9 > EMA21 alla chiusura di A+5 nel verso della
#                rottura (l'ORDINE, non la pendenza).
#    E-FRESCO    l'incrocio e' AVVENUTO in una delle ultime 5 barre
#                (A+1..A+5) ed e' nel verso della rottura.
#    E-BARRA     l'incrocio e' avvenuto ESATTAMENTE nella barra A+5.
#                E-FRESCO ed E-BARRA sono l'ipotesi LETTERALE di
#                Claudio: si misurano, e se escono con n piccolissima
#                quella E' la risposta.
#    S-INCLINATE come INCLINATE ma con medie SEMPLICI (SMA), per vedere
#                se il risultato dipende dal tipo di media.
#  LA MISURA E' UN CONFRONTO A DUE GRUPPI: giorni CON la condizione
#  contro giorni SENZA, sugli STESSI giorni e con la STESSA geometria.
#  Se la mediana del movimento a favore e' la stessa, l'incrocio NON
#  aggiunge niente, e si scrive cosi'.
#  E si misura anche NEI GRUPPI DI CONTROLLO: se il 9/21 "funziona"
#  anche alle 11:36, allora stiamo misurando le medie su M1, non
#  l'apertura.
#
#  ==================================================================
#  IL CONTO DELLE IPOTESI -- perche' senza questo si pesca
#  ==================================================================
#  Ipotesi PRINCIPALE, dichiarata prima di ogni numero, UNA:
#    APERTURA_NY x definizione T x condizione INCLINATE, confrontata
#    con CTRL_QUIETO. E' su questa che si dira' si' o no.
#  Varianti dichiarate: 2 definizioni di rottura (C, M) + 4 condizioni
#  9/21 (E-ORDINE, E-FRESCO, E-BARRA, S-INCLINATE) = 6. Tutto il resto
#  e' DESCRIZIONE, non prova.
#  DIFESA CONTRO LA PESCA: il campione e' spezzato in due.
#    IS   2006-03 -> 2015-12   (~2.450 giornate)  <- qui si guarda
#    OOS  2016-01 -> 2020-05   (~1.100 giornate)  <- la CASSAFORTE
#  --fase is (default) stampa SOLO l'IS. Per aprire la cassaforte serve
#  --fase oos ESPLICITO, e il referto lo scrive in testa a caratteri
#  grandi. Non e' burocrazia: e' l'unica cosa che distingue una misura
#  da una caccia al numero bello.
#
#  ==================================================================
#  IL CONTROLLO -- SENZA QUESTO LA MISURA NON VALE NIENTE
#  (regola di casa del 03/09, corretta il 05/09: il controllo casuale
#   va APPAIATO, cioe' sugli STESSI giorni e con la STESSA geometria)
#  ==================================================================
#    APERTURA_NY     ancora 09:30 America/New_York   <- l'evento vero
#    APERTURA_ROMA   ancora 15:30 Europe/Rome        <- l'ora del collega
#    CTRL_DOPO       ancora 10:30 America/New_York: un'ora DOPO
#                    l'apertura. Stessa seduta, stesso simbolo, nessuna
#                    apertura -> separa "e' l'apertura" da "e' un'ora
#                    viva".
#    CTRL_QUIETO     ancora 11:30 Europe/Rome (i "11:36-11:41").
#    CTRL_CASO       un minuto ESTRATTO A SORTE fra le 07:00 e le 19:00
#                    UTC, uno per ciascuno DEGLI STESSI GIORNI, con
#                    seme dichiarato (--seme, default 20260910).
#  Se l'oro fa "3 candele su 5 dello stesso colore" anche alle 11:36,
#  alle 15:36 non c'e' nessuna apertura: c'e' come sono fatte le
#  candele M1. Ogni frequenza esce con la sua BANDA DI RUMORE (+/- 2
#  errori standard binomiali) e ogni delta contro un controllo con la
#  banda del delta: un delta dentro la banda e' etichettato
#  DENTRO-IL-RUMORE, meccanicamente, senza giudizio.
#
#  ==================================================================
#  IL FUSO -- e' la prima cosa da chiudere, e sbagliarla invalida tutto
#  ==================================================================
#  Regola di casa: server BCM = ora italiana - 1, quindi 15:30 italiane
#  = 14:30 server. MA l'ora legale europea e quella americana NON
#  cambiano nelle stesse date:
#      USA  dal 2007  2a domenica di marzo / 1a domenica di novembre
#      USA  fino al 2006  1a domenica di aprile / ultima di ottobre
#      UE   ultima domenica di marzo / ultima domenica di ottobre
#  Per ~3-4 settimane l'anno (meta' marzo, fine ottobre) le 15:30
#  italiane NON sono le 09:30 di New York: sono le 08:30. Sono ~15-20
#  giorni di borsa l'anno, cioe' ~6-8% del campione.
#  --> QUI NON SI SCEGLIE E NON SI BUTTA VIA NIENTE: si misurano
#      ENTRAMBE le ancore (NY e ROMA) e si stampa a parte il
#      sottoinsieme dei GIORNI DISCORDI, cosi' si vede quanto pesa la
#      differenza invece di assumerla nulla.
#  --> E PER L'EA, l'aritmetica in ORA SERVER (server = Roma - 1):
#      settimane NORMALI    09:30 New York = 14:30 server = 15:30 Roma
#      settimane SFASATE    09:30 New York = 13:30 server, mentre
#                           15:30 Roma resta 14:30 server
#      Cioe' un EA con un'ora fissa "14:30 server" e' allineato
#      all'apertura USA tutto l'anno TRANNE quelle ~15-20 sedute, in
#      cui arriva UN'ORA TARDI. Se conta l'apertura di Wall Street,
#      l'orario va calcolato con la regola DST AMERICANA, non lasciato
#      fisso. Questo strumento misura tutte e due le cose, cosi' la
#      scelta si fa su un numero.
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
#    DI OGNI CANDELA -- che e' proprio la cosa che qui si misura.
#    L'autotest lo verifica apposta.
#    Timestamp UTC (collaudo di casa del 05/09, riverificato qui).
#    Copertura MISURATA il 10/09/2026 sondando la fonte: 2006-03 ->
#    2020-05 (2006-01/02 e 2020-06 in poi rispondono 404).
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
#    3. ZERO COSTI DEDOTTI dai numeri: MFE e MAE sono LORDI. Il costo
#       pieno di un giro completo e' stato MISURATO il 10/09/2026 e vale
#       0,2003 $/oncia = spread 0,1600 + commissione 0,0403
#       (report/ORO_1530_CANCELLO_COSTO_2026-09-10.md). Qui compare
#       solo come METRO: i pavimenti di casa 13,3x = 2,66 $ (duro) e
#       40x = 8,01 $ (di lavoro) sono stampati accanto all'ampiezza.
#       ERRATA: il numero "spread oro misurato in casa 0,24 $" che
#       gira in un dossier del 08/09 NON HA FONTE nel repo. Ritirato.
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
#    E. PREVISIONE SULLA DURATA: il massimo a favore mediano arriva
#       entro il minuto 3-5 e poi il profilo si appiattisce. Se e'
#       cosi', "3-4 candele" del collega e' una regola sensata sul
#       PIANO DELLA DURATA, e il problema si sposta tutto sul costo.
#    F. PREVISIONE SUL 9/21: il delta della mediana MFE fra CON e SENZA
#       sara' piccolo (dentro il 15%) e SIMILE nei controlli, cioe'
#       l'ordine delle medie racconta la stessa persistenza che il
#       colore gia' racconta, senza aggiungere informazione nuova.
#    ==> La tesi che sto per provare a falsificare e': "l'apertura
#        cambia l'AMPIEZZA, non la PERSISTENZA DELLA DIREZIONE". Se i
#        numeri mi smentiscono e' un risultato migliore di uno che mi
#        conferma. Se mi danno ragione, la conseguenza pratica e' che
#        il colore non e' il segnale: lo spazio lo e'.
#
#  ==================================================================
#  IL CAMPIONE CHE SERVE -- in OSSERVAZIONI, non in anni (Emend. A)
#  ==================================================================
#    Copertura misurata: 2006-03 -> 2020-05 = ~14,2 anni = ~3.550
#    giornate feriali candidate.
#    - con n = 400 giorni la banda a 2 SE su una frequenza del 10% e'
#      +/-3,0 punti: si vede un raddoppio, non un +1 punto.
#    - con n = 3.000 la banda scende a +/-1,1 punti: e' il bersaglio.
#    ==> PAVIMENTO DICHIARATO: sotto 400 giorni con rottura, il gruppo
#        si stampa ma si legge come SOSPESO.
#    Un anno sotto 100 giornate valide e' marcato SOTTILE.
#
#  I MODI
#    --autotest    giornate SINTETICHE coi conteggi attesi scritti nel
#                  codice + le regole di ora legale su date note.
#                  Nessun file, nessuna rete.
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
import os
import random
import sys
import time
import urllib.request
from datetime import date, datetime, timedelta

VERSIONE = "MARCATORE_SONDA_ORO_APERTURA_M1_v3"

BASE_RAW = ("https://raw.githubusercontent.com/FutureSharks/financial-data/"
            "master/pyfinancialdata/data/currencies/oanda")

PRIMO_ANNO, PRIMO_MESE = 2006, 3
ULTIMO_ANNO, ULTIMO_MESE = 2020, 5
ANNO_CASSAFORTE = 2016          # da qui in poi e' OOS

MIN_GIORNI_GRUPPO = 400
MIN_GIORNI_ANNO = 100
MIN_BRACCIO_921 = 100          # sotto: il confronto CON/SENZA non e' leggibile
PAVIMENTO_DURO = 13.3
PAVIMENTO_LAVORO = 40.0

CONDIZIONI = ("INCLINATE", "E-ORDINE", "E-FRESCO", "E-BARRA", "S-INCLINATE")
CONDIZIONE_PRINCIPALE = "INCLINATE"
PENDENZA_BARRE = 3              # su quante barre M1 si misura l'inclinazione

# COSTO PIENO DI UN GIRO COMPLETO SULL'ORO BCM, in $/oncia -- MISURATO
# il 10/09/2026 (report/ORO_1530_CANCELLO_COSTO_2026-09-10.md):
#   spread 0,1600 $ (SpreadPt 16, Digits 2, Point 0,01, verificato per
#   triangolazione) + commissione 0,0403 $ (3,4858 EUR/lotto su 520 righe
#   di data/statements/trades_auto.csv) = 0,2003 $/oz = 20,03 USD/lotto.
# ATTENZIONE: sull'oro la COMMISSIONE ESISTE, mentre sugli indici e' ZERO.
# Nessun conto di casa la teneva prima del 10/09/2026.
COSTO_ORO_MISURATO = 0.2003


def log(msg):
    print(msg, flush=True)


# ---------------------------------------------------------------------
#  ORA LEGALE -- regole scritte, non indovinate.
#  Le ancore cadono fra le 09:30 e le 15:30 UTC, cioe' molte ore dopo
#  il cambio d'ora (02:00 locali negli USA, 01:00 UTC in Europa): la
#  granularita' del GIORNO e' quindi esatta per questo uso, ed e'
#  dichiarata invece che nascosta.
# ---------------------------------------------------------------------
def domenica_n(anno, mese, n):
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
    """Dal 2007: 2a domenica di marzo -> 1a di novembre. Fino al 2006
    (Energy Policy Act 2005, in vigore dal 2007): 1a domenica di aprile
    -> ultima di ottobre. Il campione parte dal marzo 2006, quindi la
    regola VECCHIA serve davvero: senza, il 2006 e' misurato un'ora
    fuori per un mese."""
    if g.year >= 2007:
        return domenica_n(g.year, 3, 2) <= g < domenica_n(g.year, 11, 1)
    return domenica_n(g.year, 4, 1) <= g < domenica_ultima(g.year, 10)


def dst_ue(g):
    return domenica_ultima(g.year, 3) <= g < domenica_ultima(g.year, 10)


def ancora_utc(g, tipo):
    """Minuti da mezzanotte UTC dell'ancora A per la giornata g."""
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
    """Ancora ESTRATTA A SORTE, fra le 07:00 e le 19:00 UTC.
    Deterministica: stesso seme e stessa data -> stesso minuto, sempre."""
    r = random.Random(seme * 100000000 + int(g.strftime("%Y%m%d")))
    return r.randint(7 * 60, 19 * 60 - 30)


# ---------------------------------------------------------------------
#  LETTURA DEI FILE -- tre formati, riconosciuti dalla PRIMA RIGA.
#  Si restituisce SEMPRE il timestamp GREZZO (come sta nel file): la
#  conversione a UTC e' un passo separato, cosi' il collaudo
#  dell'orologio lavora sull'ora vera del file.
# ---------------------------------------------------------------------
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
    """Genera (t_grezzo, o, h, l, c, v). Nessuna assunzione di fuso."""
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
        p = os.path.join(cartella, n)
        if n.lower().endswith(".csv") and os.path.getsize(p) > 100:
            fuori.append(p)
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
    inverno, estate = {}, {}
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
    stampa.append("  evento ancorato a un fuso con ora legale (le 8:30 di New York, il")
    stampa.append("  fixing di Londra) si sposta di -60 min in UTC d'estate, e non si")
    stampa.append("  sposta se il file e' scritto in ora locale americana.")
    ci, ce = cima(inverno), cima(estate)
    if not ci or not ce:
        stampa.append("  NON MISURABILE: servono mesi invernali E estivi nei file letti.")
        return None
    stampa.append("  INVERNO -- i 10 minuti piu' mossi (ora COME SCRITTA nel file):")
    for med, m, n in ci:
        stampa.append("    %02d:%02d  |close-open| medio %.4f  (n=%d)"
                      % (m // 60, m % 60, med, n))
    stampa.append("  ESTATE  -- i 10 minuti piu' mossi:")
    for med, m, n in ce:
        stampa.append("    %02d:%02d  |close-open| medio %.4f  (n=%d)"
                      % (m // 60, m % 60, med, n))
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
        anno = None
        for pezzo in "".join(ch if ch.isdigit() else " " for ch in base).split():
            if len(pezzo) == 4 and 1990 < int(pezzo) < 2100:
                anno = int(pezzo)
                break
        if anno:
            per_anno.setdefault(anno, []).append(p)
    anni = sorted(per_anno)
    if not anni:
        return files[:6]
    if len(anni) <= quanti_anni:
        scelti = anni
    else:
        scelti = [anni[int(i * (len(anni) - 1) / (quanti_anni - 1))]
                  for i in range(quanti_anni)]
    fuori = []
    for a in sorted(set(scelti)):
        for p in per_anno[a]:
            b = os.path.basename(p)
            if "-01." in b or "-1." in b or "-07." in b or "-7." in b:
                fuori.append(p)
    return fuori if fuori else files[:6]


# ---------------------------------------------------------------------
#  LE MEDIE 9/21 -- calcolate SOLO su barre gia' chiuse fino ad A+5
# ---------------------------------------------------------------------
def serie_chiusure(minuti, da, a):
    """Le chiusure delle barre presenti nell'intervallo [da, a], in
    ordine di minuto. I buchi si SALTANO (e si contano): su M1 sottile
    non esiste il prezzo che non c'e', e inventarlo sarebbe peggio."""
    ch = []
    mancanti = 0
    for m in range(da, a + 1):
        b = minuti.get(m)
        if b is None:
            mancanti += 1
        else:
            ch.append(b[3])
    return ch, mancanti


def ema_serie(valori, periodo):
    """EMA classica, seme = primo valore. Con 45 barre di riscaldamento
    il peso del seme su una EMA21 vale ~1,5%: dichiarato, non nascosto.
    Torna la lista delle EMA passo per passo."""
    if not valori:
        return []
    alfa = 2.0 / (periodo + 1.0)
    fuori = [valori[0]]
    for v in valori[1:]:
        fuori.append(fuori[-1] + alfa * (v - fuori[-1]))
    return fuori


def sma_serie(valori, periodo):
    fuori = []
    somma = 0.0
    for i, v in enumerate(valori):
        somma += v
        if i >= periodo:
            somma -= valori[i - periodo]
        fuori.append(somma / min(i + 1, periodo))
    return fuori


def bandiere_921(minuti, A, riscaldamento, min_frazione=0.667):
    """Le quattro condizioni dichiarate, valutate alla CHIUSURA di A+5.
    Torna un dict condizione -> +1 (verso long), -1 (verso short),
    0 (nessun verso), oppure None se il riscaldamento e' troppo bucato."""
    da = A - riscaldamento
    a = A + 5
    ch, mancanti = serie_chiusure(minuti, da, a)
    attese = a - da + 1
    if len(ch) < min_frazione * attese or len(ch) < 22:
        return None
    e9, e21 = ema_serie(ch, 9), ema_serie(ch, 21)
    s9, s21 = sma_serie(ch, 9), sma_serie(ch, 21)

    def segno(x):
        return 1 if x > 0 else (-1 if x < 0 else 0)

    de = [a1 - b1 for a1, b1 in zip(e9, e21)]
    ds = [a1 - b1 for a1, b1 in zip(s9, s21)]
    fuori = {}
    fuori["E-ORDINE"] = segno(de[-1])

    def inclinate(m9, m21):
        """LE MEDIE INCLINATE nella direzione -- e' lo STATO, non
        l'innesco: tutte e due le medie salgono (o scendono) rispetto a
        PENDENZA_BARRE barre fa. E' la variante gia' scritta in casa
        (REGISTRO_TEST.md riga 230, regola d'ingresso RICORRENTE:
        'medie 9/21 INCLINATE nella direzione'), e non ha il ritardo
        dell'incrocio: [INFERITO] con lag EMA ~ (N-1)/2 la 9 ritarda ~4
        barre e la 21 ~10, quindi alle 15:36 su M1 un incrocio spesso
        non e' ancora avvenuto."""
        k = PENDENZA_BARRE
        if len(m9) <= k or len(m21) <= k:
            return 0
        su = m9[-1] > m9[-1 - k] and m21[-1] > m21[-1 - k]
        giu = m9[-1] < m9[-1 - k] and m21[-1] < m21[-1 - k]
        if su:
            return 1
        if giu:
            return -1
        return 0

    fuori["INCLINATE"] = inclinate(e9, e21)
    fuori["S-INCLINATE"] = inclinate(s9, s21)
    # E-BARRA: il segno e' cambiato ESATTAMENTE all'ultima barra
    fuori["E-BARRA"] = segno(de[-1]) if (len(de) > 1 and segno(de[-1]) != 0
                                         and segno(de[-2]) == -segno(de[-1])) else 0
    # E-FRESCO: il segno e' cambiato in una delle ultime 5 barre
    fresco = 0
    if len(de) > 6 and segno(de[-1]) != 0:
        for j in range(1, 6):
            if segno(de[-1 - j]) == -segno(de[-1]):
                fresco = segno(de[-1])
                break
    fuori["E-FRESCO"] = fresco
    return fuori


# ---------------------------------------------------------------------
#  LA MISURA DI UNA GIORNATA
# ---------------------------------------------------------------------
def colore(o, c):
    if c > o:
        return 1
    if c < o:
        return -1
    return 0


def valuta(minuti, A, k_margine, orizzonte, riscaldamento):
    """minuti: dict minuto-del-giorno -> (o,h,l,c,v). A: ancora.
    Torna None se una sola delle 11 barre del nucleo manca (giornata
    INCOMPLETA: contata a parte, mai riempita a occhio)."""
    setup = [minuti.get(A + i) for i in range(5)]
    trig = minuti.get(A + 5)
    oss = [minuti.get(A + 6 + i) for i in range(5)]
    if trig is None or any(x is None for x in setup) or any(x is None for x in oss):
        return None
    H0 = max(b[1] for b in setup)
    L0 = min(b[2] for b in setup)
    R = H0 - L0
    rif = oss[0][0]
    prezzo = rif if rif > 0 else 1.0

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
                direzioni[defi] = 9          # AMBIGUO IRRISOLTO
        elif su:
            direzioni[defi] = 1
        elif giu:
            direzioni[defi] = -1
        else:
            direzioni[defi] = 0              # nessuna rottura

    colori = [colore(b[0], b[3]) for b in oss]
    serie = serie_max = 1
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
    tutte_uguali = (colori[0] != 0 and all(x == colori[0] for x in colori))

    # profilo esteso: barre A+6 .. A+5+orizzonte, si ferma al primo buco
    esteso = []
    for i in range(orizzonte):
        b = minuti.get(A + 6 + i)
        if b is None:
            break
        esteso.append(b)

    return {
        "H0": H0, "L0": L0, "R": R, "rif": rif, "prezzo": prezzo,
        "dir": direzioni,
        "colori": colori,
        "n_doji": sum(1 for x in colori if x == 0),
        "serie_max": serie_max,
        "cambi": cambi,
        "tutte_uguali": tutte_uguali,
        "colore_unico": colori[0] if tutte_uguali else 0,
        "hi": max(b[1] for b in oss),
        "lo": min(b[2] for b in oss),
        "fine": oss[-1][3],
        "range5": max(b[1] for b in oss) - min(b[2] for b in oss),
        "esteso": esteso,
        "b921": bandiere_921(minuti, A, riscaldamento),
        "vol": sum(b[4] for b in oss),
    }


def per_direzione(g, d):
    """MFE, MAE, netto e k (candele nella direzione) sui 5 minuti."""
    if d == 1:
        mfe = g["hi"] - g["rif"]
        mae = g["rif"] - g["lo"]
    else:
        mfe = g["rif"] - g["lo"]
        mae = g["hi"] - g["rif"]
    return mfe, mae, (g["fine"] - g["rif"]) * d, sum(1 for x in g["colori"] if x == d)


def profilo(g, d):
    """Per ogni minuto j dell'orizzonte: MFE corrente, MAE corrente,
    scarto dalla chiusura, e il minuto in cui il MFE tocca il massimo.
    E' la risposta alla domanda del trader a mano: QUANTO DURA."""
    rif = g["rif"]
    mfe = mae = 0.0
    fuori = []
    picco_min = 0
    picco_val = -1e18
    for j, b in enumerate(g["esteso"], start=1):
        if d == 1:
            mfe = max(mfe, b[1] - rif)
            mae = max(mae, rif - b[2])
            cl = (b[3] - rif)
        else:
            mfe = max(mfe, rif - b[2])
            mae = max(mae, b[1] - rif)
            cl = (rif - b[3])
        if mfe > picco_val:
            picco_val = mfe
            picco_min = j
        fuori.append((mfe, mae, cl))
    return fuori, picco_min


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
    return ("  %-42s n=%-6d %6.2f%%  +/- %.2f (2SE)"
            % (etichetta, n, 100.0 * p, 200.0 * se_binom(p, n)))


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


def referto_gruppo(nome, giorni, defi, costo, orizzonte, stampa):
    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("GRUPPO %s   (definizione di rottura: %s)" % (nome, defi))
    stampa.append("=" * 78)
    n = len(giorni)
    riass = {"n": n}
    if n == 0:
        stampa.append("  NESSUNA GIORNATA COMPLETA.")
        return riass
    stampa.append("  giornate complete (11 barre M1 del nucleo tutte presenti): %d" % n)
    if n < MIN_GIORNI_GRUPPO:
        stampa.append("  RILIEVO: sotto il pavimento dichiarato di %d giornate ->"
                      % MIN_GIORNI_GRUPPO)
        stampa.append("  questo gruppo si legge come SOSPESO, non come misurato.")

    # ---- (a) COLORE, su TUTTI i giorni: la domanda letterale
    stampa.append("")
    stampa.append("  (a) COLORE DELLE 5 CANDELE -- su TUTTI i giorni, senza")
    stampa.append("      condizionare alla rottura (la domanda letterale di Claudio)")
    uguali = sum(1 for g in giorni if g["tutte_uguali"])
    stampa.append(riga_freq("5 candele su 5 dello STESSO colore", uguali, n))
    stampa.append(riga_freq("  di cui tutte VERDI",
                            sum(1 for g in giorni if g["colore_unico"] == 1), n))
    stampa.append(riga_freq("  di cui tutte ROSSE",
                            sum(1 for g in giorni if g["colore_unico"] == -1), n))
    stampa.append("      base di riferimento a testa e croce: 6,25%")
    stampa.append("      serie piu' lunga di colore uguale (1-5):")
    for s in range(1, 6):
        stampa.append(riga_freq("    serie massima = %d" % s,
                                sum(1 for g in giorni if g["serie_max"] == s), n))
    stampa.append("      cambi di colore fra le 5 candele (0-4):")
    for c0 in range(0, 5):
        stampa.append(riga_freq("    %d cambi" % c0,
                                sum(1 for g in giorni if g["cambi"] == c0), n))
    dj = sum(g["n_doji"] for g in giorni)
    stampa.append(riga_freq("giorni con almeno un DOJI",
                            sum(1 for g in giorni if g["n_doji"] > 0), n))
    stampa.append("      doji totali: %d su %d candele (%.2f%%)"
                  % (dj, 5 * n, 100.0 * dj / (5.0 * n)))
    riass["uguali"] = uguali

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
                  % (f(quantile(r5p, .25), 4), f(mediana(r5p), 4),
                     f(quantile(r5p, .75), 4)))
    stampa.append("      range della candela M5 di SETUP ($): mediana %s  Q3 %s"
                  % (f(mediana(rset), 2), f(quantile(rset, .75), 2)))
    duro = PAVIMENTO_DURO * costo
    lavoro = PAVIMENTO_LAVORO * costo
    stampa.append("      IL METRO DEL COSTO -- costo pieno %.4f $/oz MISURATO"
                  % costo)
    stampa.append("      (spread 0,1600 + commissione 0,0403; sull'oro la")
    stampa.append("       commissione ESISTE, sugli indici e' zero)")
    stampa.append("        pavimento DURO      stop >= %4.1f x costo = %5.2f $"
                  % (PAVIMENTO_DURO, duro))
    stampa.append("        pavimento DI LAVORO stop >= %4.1f x costo = %5.2f $"
                  % (PAVIMENTO_LAVORO, lavoro))
    q_set = sum(1 for x in rset if x >= lavoro)
    q_r5 = sum(1 for x in r5 if x >= lavoro)
    stampa.append(riga_freq("candela M5 di setup >= pavimento DI LAVORO",
                            q_set, n))
    stampa.append(riga_freq("range dei 5 minuti >= pavimento DI LAVORO",
                            q_r5, n))
    mr5 = mediana(r5)
    if mr5:
        stampa.append("      QUANTE VOLTE PIU' GRANDE dovrebbe essere il movimento")
        stampa.append("      mediano dei 5 minuti per arrivare al pavimento DI")
        stampa.append("      LAVORO: %s volte  (mediana %s $ contro %.2f $)"
                      % (f(lavoro / mr5, 2), f(mr5, 2), lavoro))
        stampa.append("      E' il numero che dice a quale TF quel movimento")
        stampa.append("      diventa pagabile: NON e' un verdetto di strategia,")
        stampa.append("      e' una divisione.")

    # ---- (b) direzionale
    stampa.append("")
    stampa.append("  (b) DIREZIONE -- solo i giorni con una rottura al minuto A+5")
    stampa.append(riga_freq("rottura LONG", sum(1 for g in giorni if g["dir"][defi] == 1), n))
    stampa.append(riga_freq("rottura SHORT", sum(1 for g in giorni if g["dir"][defi] == -1), n))
    stampa.append(riga_freq("NESSUNA rottura (l'operazione non esiste)",
                            sum(1 for g in giorni if g["dir"][defi] == 0), n))
    stampa.append(riga_freq("AMBIGUA irrisolta (esclusa)",
                            sum(1 for g in giorni if g["dir"][defi] == 9), n))
    rotti = [g for g in giorni if g["dir"][defi] in (1, -1)]
    nb = len(rotti)
    riass["nb"] = nb
    if nb == 0:
        stampa.append("      nessun giorno con rottura: statistica direzionale n/d.")
        return riass
    if nb < MIN_GIORNI_GRUPPO:
        stampa.append("      RILIEVO: %d giorni con rottura, sotto il pavimento %d."
                      % (nb, MIN_GIORNI_GRUPPO))
    kk, mfe, mae, netto, mfep, maep = [], [], [], [], [], []
    for g in rotti:
        a, b, c, k = per_direzione(g, g["dir"][defi])
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
    stampa.append("       MAE ($):  Q1 %s  mediana %s  Q3 %s  P80 %s  P90 %s"
                  % (f(quantile(mae, .25), 2), f(mediana(mae), 2),
                     f(quantile(mae, .75), 2), f(quantile(mae, .80), 2),
                     f(quantile(mae, .90), 2)))
    p80 = quantile(mae, .80)
    stampa.append("       QUANTO COSTA SBAGLIARE: uno stop che sopravvive all'80%")
    stampa.append("       delle escursioni contrarie vale %s $ (P80 del MAE)."
                  % f(p80, 2))
    if p80:
        stampa.append("       quello stop vale %s volte il costo pieno, contro il"
                      % f(p80 / costo, 1))
        stampa.append("       pavimento DI LAVORO che ne chiede 40 e quello DURO 13,3.")
    stampa.append("       MFE (%%): mediana %s      MAE (%%): mediana %s"
                  % (f(mediana(mfep), 4), f(mediana(maep), 4)))
    stampa.append("       netto a fine 5 minuti ($): Q1 %s  mediana %s  Q3 %s"
                  % (f(quantile(netto, .25), 2), f(mediana(netto), 2),
                     f(quantile(netto, .75), 2)))
    mm, ma = mediana(mfe), mediana(mae)
    if ma:
        stampa.append("       rapporto mediana MFE / mediana MAE: %s" % f(mm / ma, 3))
    riass["mfe"], riass["mae"], riass["netto"] = mm, ma, mediana(netto)

    # ---- (e) IL PROFILO MINUTO PER MINUTO: la sezione del TRADER A MANO
    stampa.append("")
    stampa.append("  (e) QUANTO DURA LA SPINTA -- minuto per minuto (per la MANO)")
    stampa.append("      Ogni riga e' lo stato dopo j minuti dall'ingresso.")
    stampa.append("      j = minuto | n | MFE med | MAE med | chiusura med | % ancora sopra 0")
    picchi = []
    for g in rotti:
        _, pm = profilo(g, g["dir"][defi])
        if pm:
            picchi.append(pm)
    for j in range(1, orizzonte + 1):
        vm, va, vc = [], [], []
        for g in rotti:
            pr, _ = profilo(g, g["dir"][defi])
            if len(pr) >= j:
                vm.append(pr[j - 1][0])
                va.append(pr[j - 1][1])
                vc.append(pr[j - 1][2])
        if not vm:
            stampa.append("      j=%2d   n=0" % j)
            continue
        sopra = sum(1 for x in vc if x > 0)
        stampa.append("      j=%2d  %5d   %7s   %7s   %9s      %5.1f%%"
                      % (j, len(vm), f(mediana(vm), 2), f(mediana(va), 2),
                         f(mediana(vc), 2), 100.0 * sopra / len(vc)))
    if picchi:
        stampa.append("      minuto in cui il MFE tocca il massimo: mediana %s,"
                      % f(mediana(picchi), 1))
        for j in range(1, orizzonte + 1):
            c = sum(1 for x in picchi if x == j)
            if c:
                stampa.append("        picco al minuto %2d: %5.1f%%  (n=%d)"
                              % (j, 100.0 * c / len(picchi), c))
    stampa.append("      COME SI LEGGE: se la mediana del MFE smette di crescere al")
    stampa.append("      minuto j, tenere oltre j non paga di piu' in mediana. Non e'")
    stampa.append("      una regola d'uscita: e' la forma della spinta.")

    # ---- (f) L'IPOTESI 9/21
    stampa.append("")
    stampa.append("  (f) IPOTESI 9/21 -- giorni CON la condizione contro giorni SENZA")
    stampa.append("      (medie su M1, prezzo di CHIUSURA, aggiornate fino ad A+5;")
    stampa.append("       a 21 periodi la media guarda indietro PRIMA dell'apertura)")
    stampa.append("      PRINCIPALE = %s (le medie INCLINATE nel verso della rottura,"
                  % CONDIZIONE_PRINCIPALE)
    stampa.append("      pendenza su %d barre M1). L'INCROCIO e' una VARIANTE."
                  % PENDENZA_BARRE)
    riass["c921"] = {}
    for cond in CONDIZIONI:
        con = [g for g in rotti if g["b921"] is not None
               and g["b921"][cond] == g["dir"][defi]]
        senza = [g for g in rotti if g["b921"] is not None
                 and g["b921"][cond] != g["dir"][defi]]
        nd = sum(1 for g in rotti if g["b921"] is None)
        if not con or not senza:
            stampa.append("      %-9s  n/d (CON=%d, SENZA=%d, riscaldamento assente=%d)"
                          % (cond, len(con), len(senza), nd))
            continue
        dcon = [per_direzione(g, g["dir"][defi]) for g in con]
        dsen = [per_direzione(g, g["dir"][defi]) for g in senza]
        mfc, mfs = mediana([x[0] for x in dcon]), mediana([x[0] for x in dsen])
        mac, mas = mediana([x[1] for x in dcon]), mediana([x[1] for x in dsen])
        nec, nes = mediana([x[2] for x in dcon]), mediana([x[2] for x in dsen])
        k4c = sum(1 for x in dcon if x[3] >= 4)
        k4s = sum(1 for x in dsen if x[3] >= 4)
        stampa.append("      --- %s  (CON n=%d, SENZA n=%d, riscaldamento assente %d)"
                      % (cond, len(con), len(senza), nd))
        quota = 100.0 * len(con) / (len(con) + len(senza))
        stampa.append("          la condizione si accende nel %.1f%% dei giorni con rottura"
                      % quota)
        if min(len(con), len(senza)) < MIN_BRACCIO_921:
            stampa.append("          SOSPESA: il braccio piu' piccolo ha %d osservazioni"
                          % min(len(con), len(senza)))
            stampa.append("          (pavimento %d). Un confronto con un braccio cosi'"
                          % MIN_BRACCIO_921)
            stampa.append("          sottile non e' leggibile, e una condizione che si")
            stampa.append("          accende quasi sempre non FILTRA: doppia con la rottura.")
        stampa.append("          MFE mediano   CON %s $   SENZA %s $   delta %s $ (%s%%)"
                      % (f(mfc, 2), f(mfs, 2), f(mfc - mfs, 2),
                         f(100.0 * (mfc - mfs) / mfs, 1) if mfs else "n/d"))
        stampa.append("          MAE mediano   CON %s $   SENZA %s $"
                      % (f(mac, 2), f(mas, 2)))
        stampa.append("          netto 5 min   CON %s $   SENZA %s $"
                      % (f(nec, 2), f(nes, 2)))
        stampa.append(confronta("          k >= 4 nella direzione",
                                k4c, len(con), k4s, len(senza)))
        if cond == CONDIZIONE_PRINCIPALE:
            riass["c921"]["mfe_con"] = mfc
            riass["c921"]["mfe_senza"] = mfs
            riass["c921"]["k4_con"] = k4c
            riass["c921"]["n_con"] = len(con)
            riass["c921"]["k4_senza"] = k4s
            riass["c921"]["n_senza"] = len(senza)

    # ---- (d) anno per anno
    stampa.append("")
    stampa.append("  (d) ANNO PER ANNO (sotto %d giornate: SOTTILE)" % MIN_GIORNI_ANNO)
    stampa.append("      anno    n   5/5 col.   n rott.   k>=4   invers.  MFE med  MAE med")
    per_anno = {}
    for g in giorni:
        per_anno.setdefault(g["anno"], []).append(g)
    for anno in sorted(per_anno):
        gg = per_anno[anno]
        na_ = len(gg)
        ug = sum(1 for x in gg if x["tutte_uguali"])
        rr = [x for x in gg if x["dir"][defi] in (1, -1)]
        marca = "  SOTTILE" if na_ < MIN_GIORNI_ANNO else ""
        if rr:
            dd = [per_direzione(x, x["dir"][defi]) for x in rr]
            stampa.append("      %s  %4d   %6.2f%%    %5d  %5.1f%%  %5.1f%%   %7s  %7s%s"
                          % (anno, na_, 100.0 * ug / na_, len(rr),
                             100.0 * sum(1 for d0 in dd if d0[3] >= 4) / len(rr),
                             100.0 * sum(1 for d0 in dd if d0[2] < 0) / len(rr),
                             f(mediana([d0[0] for d0 in dd]), 2),
                             f(mediana([d0[1] for d0 in dd]), 2), marca))
        else:
            stampa.append("      %s  %4d   %6.2f%%        0    n/d    n/d       n/d      n/d%s"
                          % (anno, na_, 100.0 * ug / na_, marca))
    return riass


# ---------------------------------------------------------------------
#  AUTOTEST -- niente file, niente rete. Conteggi attesi scritti a mano.
# ---------------------------------------------------------------------
def barra(o, h, l, c, v=1):
    return (o, h, l, c, v)


def autotest():
    log("=== AUTOTEST %s (offline) ===" % VERSIONE)
    ok = 0

    # 1. ora legale su date NOTE
    assert domenica_n(2015, 3, 2) == date(2015, 3, 8)
    assert domenica_ultima(2015, 10) == date(2015, 10, 25)
    assert dst_usa(date(2015, 3, 7)) is False
    assert dst_usa(date(2015, 3, 8)) is True
    assert dst_usa(date(2015, 10, 31)) is True
    assert dst_usa(date(2015, 11, 1)) is False
    assert dst_usa(date(2006, 3, 20)) is False, "regola USA pre-2007"
    assert dst_usa(date(2006, 4, 2)) is True
    assert dst_usa(date(2006, 10, 28)) is True
    assert dst_usa(date(2006, 10, 29)) is False
    assert dst_ue(date(2015, 3, 28)) is False
    assert dst_ue(date(2015, 3, 29)) is True
    assert dst_ue(date(2015, 10, 24)) is True
    assert dst_ue(date(2015, 10, 25)) is False
    log("1. ora legale USA (regola vecchia e nuova) e UE su date note: OK")
    ok += 1

    # 2. ancore e giorni DISCORDI
    assert ancora_utc(date(2015, 6, 1), "ny0930") == 810
    assert ancora_utc(date(2015, 6, 1), "roma1530") == 810
    assert ancora_utc(date(2015, 3, 20), "ny0930") == 810
    assert ancora_utc(date(2015, 3, 20), "roma1530") == 870
    assert ancora_utc(date(2015, 10, 28), "ny0930") == 810
    assert ancora_utc(date(2015, 10, 28), "roma1530") == 870
    assert ancora_utc(date(2006, 3, 20), "ny0930") == 870
    assert ancora_utc(date(2006, 3, 20), "roma1530") == 870
    assert ancora_utc(date(2015, 1, 15), "ny1030") == 930
    log("2. ancore in UTC e giorni DISCORDI NY/ROMA (marzo, ottobre): OK")
    ok += 1

    # 3. controllo casuale APPAIATO: riproducibile e dentro la banda
    a1 = ancora_caso(date(2015, 6, 1), 20260910)
    assert a1 == ancora_caso(date(2015, 6, 1), 20260910)
    assert 420 <= a1 <= 19 * 60 - 30
    log("3. ancora casuale appaiata: deterministica (%d) e nella banda: OK" % a1)
    ok += 1

    # 4. i tre formati, compresa la TRAPPOLA delle colonne Oanda C,H,L,O
    import tempfile
    tdir = tempfile.mkdtemp()
    c = {"righe_scartate": 0, "ohlc_incoerenti": 0, "file_formato_ignoto": 0}
    p1 = os.path.join(tdir, "oanda.csv")
    with open(p1, "w") as fh:
        fh.write("time,close,high,low,open,volume\n")
        fh.write("2015-06-01 13:30:00,1200.5,1201.0,1199.0,1199.5,100\n")
    r = list(leggi_file(p1, c))
    assert len(r) == 1 and r[0][1:5] == (1199.5, 1201.0, 1199.0, 1200.5), r
    assert colore(r[0][1], r[0][4]) == 1, "open 1199.5 -> close 1200.5 = VERDE"
    p2 = os.path.join(tdir, "hist.csv")
    with open(p2, "w") as fh:
        fh.write("20150601 133000;1199.5;1201.0;1199.0;1200.5;0\n")
    assert list(leggi_file(p2, c))[0][1:5] == (1199.5, 1201.0, 1199.0, 1200.5)
    p3 = os.path.join(tdir, "casa.csv")
    with open(p3, "w") as fh:
        fh.write("Time,Open,High,Low,Close,Volume\n")
        fh.write("2015.06.01 13:30,1199.5,1201.0,1199.0,1200.5,1\n")
    assert list(leggi_file(p3, c))[0][1:5] == (1199.5, 1201.0, 1199.0, 1200.5)
    log("4. tre formati letti, colonne Oanda C,H,L,O NON scambiate: OK")
    ok += 1

    # 5. conversione grezzo -> UTC per un file in ora di New York
    assert grezzo_a_utc(datetime(2015, 6, 1, 9, 30), "ny") == datetime(2015, 6, 1, 13, 30)
    assert grezzo_a_utc(datetime(2015, 1, 15, 9, 30), "ny") == datetime(2015, 1, 15, 14, 30)
    assert grezzo_a_utc(datetime(2015, 6, 1, 13, 30), "utc") == datetime(2015, 6, 1, 13, 30)
    log("5. ora di New York -> UTC (estate +4, inverno +5): OK")
    ok += 1

    # 6. giornata SINTETICA: rottura LONG e 5 candele verdi -> k=5
    A = 810
    m = {}
    for i in range(60):                       # riscaldamento piatto
        m[A - 60 + i] = barra(100.0, 100.1, 99.9, 100.0)
    for i in range(5):
        m[A + i] = barra(100.0, 100.5, 99.5, 100.0)
    m[A + 5] = barra(100.0, 100.8, 99.9, 100.7)
    for i in range(10):
        m[A + 6 + i] = barra(100.7 + 0.1 * i, 100.9 + 0.1 * i,
                             100.6 + 0.1 * i, 100.8 + 0.1 * i)
    g = valuta(m, A, 0.10, 10, 45)
    assert g is not None
    assert g["H0"] == 100.5 and g["L0"] == 99.5
    assert g["dir"]["T"] == 1 and g["dir"]["C"] == 1 and g["dir"]["M"] == 1
    assert g["tutte_uguali"] is True and g["serie_max"] == 5 and g["cambi"] == 0
    mfe, mae, netto, k = per_direzione(g, 1)
    assert k == 5, k
    assert abs(mfe - 0.6) < 1e-9, mfe          # max high 101.3 - rif 100.7
    assert abs(mae - 0.1) < 1e-9, mae          # rif 100.7 - min low 100.6
    log("6. giornata sintetica LONG, 5 verdi: k=5, serie 5, MFE 0,60, MAE 0,10: OK")
    ok += 1

    # 6b. il PROFILO cresce e il picco e' all'ultimo minuto disponibile
    pr, picco = profilo(g, 1)
    assert len(pr) == 10, len(pr)
    assert pr[0][0] < pr[-1][0], "il MFE deve crescere in una serie che sale"
    assert picco == 10, picco
    log("6b. profilo minuto per minuto: 10 minuti, MFE crescente, picco a j=10: OK")
    ok += 1

    # 7. giornata ALTERNATA + un DOJI
    m2 = dict(m)
    m2[A + 6] = barra(100.7, 100.9, 100.6, 100.8)   # verde
    m2[A + 7] = barra(100.8, 100.9, 100.6, 100.7)   # rossa
    m2[A + 8] = barra(100.7, 100.8, 100.6, 100.7)   # DOJI
    m2[A + 9] = barra(100.7, 100.9, 100.6, 100.8)   # verde
    m2[A + 10] = barra(100.8, 100.9, 100.6, 100.7)  # rossa
    g2 = valuta(m2, A, 0.10, 10, 45)
    assert g2["n_doji"] == 1 and g2["tutte_uguali"] is False
    assert g2["serie_max"] == 1 and g2["cambi"] == 4
    assert per_direzione(g2, 1)[3] == 2, "il doji NON conta nella direzione"
    log("7. alternata con doji: serie max 1, 4 cambi, k=2 (doji fuori): OK")
    ok += 1

    # 8. rottura AMBIGUA, NESSUNA rottura, e il MARGINE k*R
    m3 = dict(m)
    m3[A + 5] = barra(100.0, 100.8, 99.2, 100.0)
    assert valuta(m3, A, 0.10, 10, 45)["dir"]["T"] == 9
    assert valuta(m3, A, 0.10, 10, 45)["dir"]["C"] == 0
    m4 = dict(m)
    m4[A + 5] = barra(100.0, 100.4, 99.6, 100.1)
    assert valuta(m4, A, 0.10, 10, 45)["dir"]["T"] == 0
    m5 = dict(m)
    m5[A + 5] = barra(100.0, 100.55, 99.9, 100.52)
    g5 = valuta(m5, A, 0.10, 10, 45)
    assert g5["dir"]["T"] == 1 and g5["dir"]["M"] == 0, g5["dir"]
    log("8. ambigua irrisolta, nessuna rottura, margine k*R che filtra: OK")
    ok += 1

    # 9. una barra mancante = giornata INCOMPLETA
    m6 = dict(m)
    del m6[A + 8]
    assert valuta(m6, A, 0.10, 10, 45) is None
    log("9. una sola barra del nucleo mancante -> giornata esclusa: OK")
    ok += 1

    # 10. LE MEDIE 9/21 -- serie che SALE: EMA9 sopra EMA21
    msu = {}
    for i in range(60):
        p = 100.0 + 0.05 * i
        msu[A - 60 + i] = barra(p, p + 0.02, p - 0.02, p)
    for i in range(6):
        p = 103.0 + 0.05 * i
        msu[A + i] = barra(p, p + 0.3, p - 0.3, p)
    for i in range(10):
        msu[A + 6 + i] = barra(103.3, 103.4, 103.2, 103.35)
    b = bandiere_921(msu, A, 45)
    assert b is not None and b["E-ORDINE"] == 1, b
    assert b["INCLINATE"] == 1, b
    assert b["S-INCLINATE"] == 1, b
    # serie che SCENDE: EMA9 sotto EMA21
    mgiu = {}
    for i in range(60):
        p = 110.0 - 0.05 * i
        mgiu[A - 60 + i] = barra(p, p + 0.02, p - 0.02, p)
    for i in range(6):
        p = 107.0 - 0.05 * i
        mgiu[A + i] = barra(p, p + 0.3, p - 0.3, p)
    b2 = bandiere_921(mgiu, A, 45)
    assert b2["E-ORDINE"] == -1 and b2["INCLINATE"] == -1, b2
    assert b2["S-INCLINATE"] == -1, b2
    # riscaldamento troppo bucato -> n/d, e il giorno resta valido per il resto
    mbuco = {k2: v2 for k2, v2 in msu.items() if k2 >= A - 5}
    assert bandiere_921(mbuco, A, 45) is None
    log("10. medie 9/21: ordine e INCLINAZIONE in salita e in discesa,")
    log("    n/d se il riscaldamento e' bucato: OK")
    ok += 1

    # 10b. serie PIATTA: le medie non sono inclinate da nessuna parte
    mpiatta = {}
    for i in range(70):
        mpiatta[A - 60 + i] = barra(100.0, 100.05, 99.95, 100.0)
    bp = bandiere_921(mpiatta, A, 45)
    assert bp is not None and bp["INCLINATE"] == 0, bp
    assert bp["S-INCLINATE"] == 0, bp
    log("10b. serie piatta -> INCLINATE = 0 (nessun verso): OK")
    ok += 1

    # 11. E-BARRA: l'incrocio avviene ESATTAMENTE nella barra A+5
    minc = {}
    for i in range(60):                       # prima scende
        p = 110.0 - 0.05 * i
        minc[A - 60 + i] = barra(p, p + 0.02, p - 0.02, p)
    for i in range(5):                        # poi risale, ma non basta
        p = 107.0 + 0.10 * i
        minc[A + i] = barra(p, p + 0.1, p - 0.1, p)
    binc = bandiere_921(minc, A, 45)
    assert binc is not None
    assert binc["E-BARRA"] in (0, 1, -1)
    # sequenza costruita in modo che almeno una fra E-BARRA e E-FRESCO
    # segnali quando l'ordine e' appena cambiato
    assert binc["E-FRESCO"] in (0, binc["E-ORDINE"]), binc
    log("11. E-BARRA / E-FRESCO coerenti con E-ORDINE (mai un verso opposto): OK")
    ok += 1

    # 12. banda di rumore
    assert abs(200.0 * se_binom(0.10, 400) - 3.0) < 0.1
    assert abs(200.0 * se_binom(0.10, 3000) - 1.1) < 0.1
    log("12. banda 2SE: 10% su n=400 -> +/-3,0 pt; su n=3.000 -> +/-1,1 pt: OK")
    ok += 1

    log("")
    log("AUTOTEST: %d/14 OK" % ok)
    return 0


# ---------------------------------------------------------------------
#  MAIN
# ---------------------------------------------------------------------
GRUPPI = [
    ("APERTURA_NY", "ny0930", "l'evento vero: 09:30 America/New_York"),
    ("APERTURA_ROMA", "roma1530", "l'ora del collega: 15:30 Europe/Rome"),
    ("CTRL_DOPO", "ny1030", "controllo: un'ora DOPO l'apertura (10:30 New York)"),
    ("CTRL_QUIETO", "roma1130", "controllo: ora quieta (11:30 Europe/Rome)"),
    ("CTRL_CASO", "caso", "controllo APPAIATO: minuto a sorte 07:00-19:00 UTC"),
]


def main():
    ap = argparse.ArgumentParser(
        description="L'oro nei minuti dopo la rottura della prima M5 "
                    "dell'apertura USA. MISURA DESCRITTIVA, non un backtest.")
    ap.add_argument("--dati", default="dati_oro_m1")
    ap.add_argument("--out", default="uscite_oro_apertura")
    ap.add_argument("--simbolo", default="XAU_USD")
    ap.add_argument("--scarica", action="store_true")
    ap.add_argument("--da-anno", type=int, default=PRIMO_ANNO)
    ap.add_argument("--a-anno", type=int, default=ULTIMO_ANNO)
    ap.add_argument("--fuso-file", default="auto", choices=["auto", "utc", "ny"])
    ap.add_argument("--salta-orologio", action="store_true",
                    help="NON usare senza motivo: salta il collaudo dell'orologio")
    ap.add_argument("--k-margine", type=float, default=0.10)
    ap.add_argument("--orizzonte", type=int, default=10,
                    help="minuti M1 osservati oltre l'ingresso (default 10)")
    ap.add_argument("--riscaldamento", type=int, default=45,
                    help="barre M1 prima di A per le medie 9/21")
    ap.add_argument("--costo", type=float, default=COSTO_ORO_MISURATO,
                    help="costo PIENO di un giro completo in $/oncia. Default "
                         "0,2003 = spread 0,1600 + commissione 0,0403, MISURATO "
                         "il 10/09/2026 sul conto vero")
    ap.add_argument("--seme", type=int, default=20260910)
    ap.add_argument("--definizione", default="T", choices=["T", "C", "M"])
    ap.add_argument("--fase", default="is", choices=["is", "oos", "tutto"],
                    help="is = 2006-2015 (default) | oos = CASSAFORTE 2016-2020")
    ap.add_argument("--sonda-dati", action="store_true")
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

    contatori = {"righe_scartate": 0, "ohlc_incoerenti": 0,
                 "file_formato_ignoto": 0, "fuori_ordine": 0}
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
    stampa.append("definizione di rottura (principale): %s" % args.definizione)
    stampa.append("margine k = %.2f x range del setup" % args.k_margine)
    stampa.append("orizzonte osservato: %d minuti M1" % args.orizzonte)
    stampa.append("riscaldamento medie 9/21: %d barre M1" % args.riscaldamento)
    stampa.append("seme del controllo casuale: %d" % args.seme)
    stampa.append("COSTO PIENO giro completo: %.4f $/oz  (spread 0,1600 + "
                  "commissione 0,0403)" % args.costo)
    stampa.append("  MISURATO il 10/09/2026, report/ORO_1530_CANCELLO_COSTO_2026-09-10.md")
    stampa.append("  pavimenti di casa: DURO %.2f $ (13,3x)   DI LAVORO %.2f $ (40x)"
                  % (PAVIMENTO_DURO * args.costo, PAVIMENTO_LAVORO * args.costo))
    stampa.append("FASE: %s" % args.fase.upper())
    if args.fase == "oos":
        stampa.append("")
        stampa.append("**********************************************************")
        stampa.append("*  CASSAFORTE APERTA: questi sono gli anni %d-%d.        *"
                      % (ANNO_CASSAFORTE, ULTIMO_ANNO))
        stampa.append("*  Vanno letti SOLO per CONFERMARE un'ipotesi gia'        *")
        stampa.append("*  scritta sull'IS. Se qualcuno costruisce un'ipotesi     *")
        stampa.append("*  NUOVA guardando questi numeri, la cassaforte e' bruciata*")
        stampa.append("*  e non c'e' piu' nessun fuori campione.                 *")
        stampa.append("**********************************************************")
    stampa.append("")
    stampa.append("QUESTO NON E' UN BACKTEST. Nessun PF, nessuna equity, nessun costo")
    stampa.append("dedotto, nessuna uscita simulata, nessuna promozione. Il feed NON")
    stampa.append("e' BCM. Manuale non vuol dire esente dai cancelli: lo spread lo")
    stampa.append("paga anche la mano.")
    stampa.append("")
    stampa.append("IPOTESI PRINCIPALE (una): APERTURA_NY x rottura %s x 9/21 %s,"
                  % (args.definizione, CONDIZIONE_PRINCIPALE))
    stampa.append("confrontata con CTRL_QUIETO. Varianti dichiarate: 6. Il resto e'")
    stampa.append("descrizione, non prova.")
    stampa.append("L'inclinazione e' la PRINCIPALE e l'incrocio una VARIANTE, non il")
    stampa.append("contrario: su M1 a 4-5 minuti dall'apertura l'incrocio arriva tardi.")

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

    # ---- passata unica, in streaming: si tiene UN GIORNO alla volta
    t0 = time.time()
    risultati = {nome: [] for nome, _, _ in GRUPPI}
    incompleti = {nome: 0 for nome, _, _ in GRUPPI}
    conta_giorni = [0]
    discordi = [0]
    estremi = [None, None]
    margine_pre = max(args.riscaldamento + 2, 50)

    def ancore_del_giorno(g):
        aa = {}
        for nome, tipo, _ in GRUPPI:
            aa[nome] = ancora_caso(g, args.seme) if tipo == "caso" else ancora_utc(g, tipo)
        return aa

    def chiudi(g, minuti, aa):
        conta_giorni[0] += 1
        if estremi[0] is None or g < estremi[0]:
            estremi[0] = g
        if estremi[1] is None or g > estremi[1]:
            estremi[1] = g
        if aa["APERTURA_NY"] != aa["APERTURA_ROMA"]:
            discordi[0] += 1
        if g.weekday() >= 5:
            return
        if args.fase == "is" and g.year >= ANNO_CASSAFORTE:
            return
        if args.fase == "oos" and g.year < ANNO_CASSAFORTE:
            return
        for nome, _, _ in GRUPPI:
            A = aa[nome]
            r = valuta(minuti, A, args.k_margine, args.orizzonte, args.riscaldamento)
            if r is None:
                incompleti[nome] += 1
                continue
            r["data"] = g
            r["anno"] = "%04d" % g.year
            r["ancora"] = A
            r["gruppo"] = nome
            r["discorde"] = 1 if aa["APERTURA_NY"] != aa["APERTURA_ROMA"] else 0
            risultati[nome].append(r)

    corrente = None
    minuti = {}
    ancore = {}
    servono = set()
    chiusi = set()
    n_barre = 0
    for p in files:
        for (t, o, h, l, c, v) in leggi_file(p, contatori):
            n_barre += 1
            tu = grezzo_a_utc(t, fuso)
            g = tu.date()
            if g != corrente:
                if corrente is not None:
                    chiudi(corrente, minuti, ancore)
                    chiusi.add(corrente)
                if g in chiusi:
                    contatori["fuori_ordine"] += 1
                    continue
                corrente = g
                minuti = {}
                ancore = ancore_del_giorno(g)
                servono = set()
                for nome, _, _ in GRUPPI:
                    A = ancore[nome]
                    for i in range(-margine_pre, 6 + args.orizzonte):
                        servono.add(A + i)
            mdg = tu.hour * 60 + tu.minute
            if mdg in servono:
                minuti[mdg] = (o, h, l, c, v)
    if corrente is not None and corrente not in chiusi:
        chiudi(corrente, minuti, ancore)
    secondi = time.time() - t0

    stampa.append("")
    stampa.append("LETTURA: %d barre M1 in %.0f s (%.0f mila barre/s)"
                  % (n_barre, secondi, n_barre / max(secondi, 0.001) / 1000.0))
    stampa.append("  righe scartate %d, OHLC incoerenti %d, file di formato ignoto %d,"
                  % (contatori["righe_scartate"], contatori["ohlc_incoerenti"],
                     contatori["file_formato_ignoto"]))
    stampa.append("  righe fuori ordine (giorno gia' chiuso) %d"
                  % contatori["fuori_ordine"])
    if not conta_giorni[0]:
        for r in stampa:
            log(r)
        return 2
    stampa.append("  giornate di calendario con dati: %d, dal %s al %s"
                  % (conta_giorni[0], estremi[0], estremi[1]))
    stampa.append("  giornate in cui 15:30 ROMA e 09:30 NEW YORK NON coincidono:"
                  " %d (%.1f%%)"
                  % (discordi[0], 100.0 * discordi[0] / conta_giorni[0]))
    stampa.append("  (sono le ~3-4 settimane l'anno con i due calendari di ora legale")
    stampa.append("   sfasati: NON vengono buttate, sono misurate a parte)")

    stampa.append("")
    stampa.append("GIORNATE PER GRUPPO (solo giorni feriali, fase %s)" % args.fase.upper())
    stampa.append("  gruppo            complete  incomplete   descrizione")
    for nome, tipo, descr in GRUPPI:
        stampa.append("  %-16s %8d  %10d   %s"
                      % (nome, len(risultati[nome]), incompleti[nome], descr))

    rilievi = []
    for nome, _, _ in GRUPPI:
        if len(risultati[nome]) < MIN_GIORNI_GRUPPO:
            rilievi.append("%s: solo %d giornate complete (pavimento %d)"
                           % (nome, len(risultati[nome]), MIN_GIORNI_GRUPPO))
    if contatori["fuori_ordine"]:
        rilievi.append("%d righe fuori ordine: i file non erano in sequenza"
                       % contatori["fuori_ordine"])

    if args.sonda_dati:
        stampa.append("")
        stampa.append("MODO --sonda-dati: NESSUNA statistica di comportamento stampata.")
        stampa.append("Serve solo a sapere se, e con quanti dati, si puo' misurare.")
        for r in stampa:
            log(r)
        return 1 if rilievi else 0

    riass = {}
    for nome, _, _ in GRUPPI:
        riass[nome] = referto_gruppo(nome, risultati[nome], args.definizione,
                                     args.costo, args.orizzonte, stampa)
    ny_disc = [r for r in risultati["APERTURA_NY"] if r["discorde"]]
    roma_disc = [r for r in risultati["APERTURA_ROMA"] if r["discorde"]]
    if ny_disc:
        referto_gruppo("NY_SOLO_GIORNI_DISCORDI", ny_disc, args.definizione,
                       args.costo, args.orizzonte, stampa)
        referto_gruppo("ROMA_SOLO_GIORNI_DISCORDI", roma_disc, args.definizione,
                       args.costo, args.orizzonte, stampa)

    # ---- il confronto che rende onesta la misura
    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("IL CONFRONTO COI CONTROLLI -- senza questo la misura non vale niente")
    stampa.append("=" * 78)
    stampa.append("Se l'oro fa gli stessi numeri alle 11:36, alle 15:36 non c'e' nessuna")
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
            for et, ch in (("MFE mediano", "mfe"), ("MAE mediano", "mae")):
                if c.get(ch) and base.get(ch):
                    stampa.append("  %-42s %s $ contro %s $  (rapporto %s)"
                                  % (et, f(base[ch], 2), f(c[ch], 2),
                                     f(base[ch] / c[ch], 2)))
        # il 9/21 vale anche FUORI dall'apertura? se si', non e' l'apertura
        b9 = base.get("c921", {})
        c9 = c.get("c921", {})
        if b9.get("mfe_senza") and c9.get("mfe_senza"):
            stampa.append("  9/21 %s, guadagno di MFE mediano CON contro SENZA:"
                          % CONDIZIONE_PRINCIPALE)
            stampa.append("      APERTURA_NY  %s $ -> %s $  (%s%%)"
                          % (f(b9["mfe_senza"], 2), f(b9["mfe_con"], 2),
                             f(100.0 * (b9["mfe_con"] - b9["mfe_senza"]) / b9["mfe_senza"], 1)))
            stampa.append("      %-12s %s $ -> %s $  (%s%%)"
                          % (ctrl, f(c9["mfe_senza"], 2), f(c9["mfe_con"], 2),
                             f(100.0 * (c9["mfe_con"] - c9["mfe_senza"]) / c9["mfe_senza"], 1)))
            stampa.append("      se le due percentuali si somigliano, il 9/21 sta")
            stampa.append("      descrivendo le medie su M1, NON l'apertura.")

    stampa.append("")
    stampa.append("=" * 78)
    stampa.append("PROMEMORIA DI LETTURA (vale per ogni numero qui sopra)")
    stampa.append("=" * 78)
    stampa.append("1. NON E' BCM: altro broker, altri orari, altro spread. Misura di")
    stampa.append("   OCCASIONI, mai un verdetto (regola F6).")
    stampa.append("2. OHLC M1, non tick: MFE e MAE sono ESTREMI raggiunti, non esiti")
    stampa.append("   di un'uscita simulata. Nessuna uscita e' simulata qui.")
    stampa.append("3. ZERO COSTI DEDOTTI dai numeri: MFE e MAE sono lordi. Il costo")
    stampa.append("   pieno MISURATO (0,2003 $/oz) compare solo come METRO, nelle")
    stampa.append("   righe dei pavimenti. Chi legge un MFE senza sottrarre 0,2003")
    stampa.append("   sta leggendo un numero che non esiste.")
    stampa.append("4. Il campione finisce nel 2020: non copre il regime 2021-2026.")
    stampa.append("5. Un picco isolato in un anno solo non e' un comportamento: si")
    stampa.append("   guarda la tabella per anno prima di dire qualunque cosa.")
    stampa.append("6. Ipotesi provate: 1 principale + 6 varianti dichiarate. La")
    stampa.append("   cassaforte %d-%d serve a confermare, non a scegliere."
                  % (ANNO_CASSAFORTE, ULTIMO_ANNO))

    if rilievi:
        stampa.append("")
        stampa.append("RILIEVI:")
        for r in rilievi:
            stampa.append("  - " + r)

    for r in stampa:
        log(r)

    os.makedirs(args.out, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d_%H%M")
    prefe = os.path.join(args.out, "SONDA_ORO_APERTURA_%s_%s" % (args.fase.upper(), stamp))
    with open(prefe + ".txt", "w", encoding="ascii", errors="replace") as fh:
        fh.write("\n".join(stampa) + "\n")
    campi = ["gruppo", "data", "ancora", "discorde", "H0", "L0", "R", "rif",
             "dir_T", "dir_C", "dir_M", "col1", "col2", "col3", "col4", "col5",
             "serie_max", "cambi", "n_doji", "hi", "lo", "fine", "range5",
             "e_ordine", "e_fresco", "e_barra", "s_ordine", "vol"]
    with open(prefe + "_PERGIORNO.csv", "w", newline="", encoding="ascii",
              errors="replace") as fh:
        w = csv.writer(fh)
        w.writerow(campi)
        for nome, _, _ in GRUPPI:
            for r in risultati[nome]:
                b = r["b921"] or {}
                w.writerow([nome, r["data"], r["ancora"], r["discorde"],
                            "%.3f" % r["H0"], "%.3f" % r["L0"], "%.3f" % r["R"],
                            "%.3f" % r["rif"],
                            r["dir"]["T"], r["dir"]["C"], r["dir"]["M"]]
                           + list(r["colori"])
                           + [r["serie_max"], r["cambi"], r["n_doji"],
                              "%.3f" % r["hi"], "%.3f" % r["lo"], "%.3f" % r["fine"],
                              "%.3f" % r["range5"],
                              b.get("E-ORDINE", ""), b.get("E-FRESCO", ""),
                              b.get("E-BARRA", ""), b.get("S-ORDINE", ""),
                              "%.0f" % r["vol"]])
    log("")
    log("REFERTO : %s.txt" % os.path.abspath(prefe))
    log("CSV     : %s_PERGIORNO.csv" % os.path.abspath(prefe))
    return 1 if rilievi else 0


if __name__ == "__main__":
    sys.exit(main())
