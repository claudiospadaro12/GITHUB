//+------------------------------------------------------------------+
//|                                              ABTG_Relativo.mq5    |
//|                                                                  |
//|  L'EA OPERATIVO DEL CANDIDATO "RELATIVO" -- QUESTO APRE ORDINI.   |
//|                                                                  |
//|  ==============================================================  |
//|  ATTENZIONE, ED E' LA PRIMA COSA DA SAPERE:                       |
//|  il suo fratello ABTG_SondaRelativo.mq5 e' un CONTATORE PURO che  |
//|  NON apre niente. QUESTO FILE INVECE MANDA ORDINI VERI, calcola   |
//|  lotti, ha un magic, mette stop loss sul broker. I due file       |
//|  condividono il NUCLEO STATISTICO riga per riga (e' voluto: vedi  |
//|  R1) ma non sono la stessa cosa e non vanno confusi.              |
//|  ==============================================================  |
//|                                                                  |
//|  DA DOVE VIENE, in una riga: e' il PASSO 1 (merito, a tick reali) |
//|  del candidato promosso al PASSO 0 il 04/09/2026. Il passo 0 ha   |
//|  misurato PORTATA, TAGLIA, GEOMETRIA, CONVERGENZA e TENUTA su 4   |
//|  finestre x 49 celle, poi su 2 finestre x 90 celle (griglia       |
//|  estesa). NON ha mai misurato un euro di P/L -- per costruzione.  |
//|  QUESTO FILE E' LA PRIMA MISURA DI MERITO DEL MECCANISMO.         |
//|                                                                  |
//|  IL MECCANISMO, in quattro righe:                                 |
//|    delta = rapporto fra la GAMBA (si scambia) e il METRO (si      |
//|            legge soltanto) -> scarto dalla media mobile           |
//|    z     = normalizzazione a z-score su finestra N                |
//|    entra quando |z| ATTRAVERSA la soglia (dal lato del segno)     |
//|    esce  quando |z| RIENTRA sotto 0,05  (= convergenza)           |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  I DOCUMENTI CHE FANNO FEDE                                       |
//|  ------------------------------------------------------------    |
//|  proposta : report\PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md     |
//|             (cella, stop, criteri di merito, magic, cosa NON si   |
//|              potra' dire coi dati che avremo)                     |
//|  passo 0  : risultati_archivio\sondarelativo\                     |
//|               REFERTO_D30_M5_ESTESA_2026-09-04_1630_v103_VIVO.txt |
//|               REFERTO_NAS_M5_ESTESA_2026-09-04_1632_v103_VIVO.txt |
//|  sonda    : mql5\Experts\ABTG_SondaRelativo.mq5 (v1.03, INVARIATA)|
//|  firma H8 : report\FIRME_2026-08-31.md, FIRMA 2 (E >= 0,075R)     |
//|  cap C1   : report\FIRME_2026-08-18.md (3,25% = 5 SL da 0,65%)    |
//|  muri prop: report\METRO_PROP.md (DD 10% totale, 5% giornaliero)  |
//|  P5       : report\CONFIG_PROP_2026-08-31.md (tenuta minima)      |
//|  hedging  : report\AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md     |
//|  spread   : risultati_archivio\SPREAD_FLOTTA_MISURA_2026-09-03.md |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  ORIGINE E ATTRIBUZIONE -- IDENTICA ALLA SONDA, E SI RIPETE       |
//|  ------------------------------------------------------------    |
//|  Il MOTORE e' derivato dalla LETTURA di tre script Pine:          |
//|   1) "Pair Trade" (c) vladimirkovalchuk / @wa1one                 |
//|      https://www.tradingview.com/script/ru23VN0C/                 |
//|   2) "Unilateral Pairs Trading" (c) @pietro3334                   |
//|      https://www.tradingview.com/script/MD5vkc0n/                 |
//|   3) "Statistical Arbitrage Pairs Trading - Long-Side Only"       |
//|      (c) @piirsalu                                                |
//|      https://www.tradingview.com/script/Kt6XkQIM/                 |
//|      (da qui SOLO la normalizzazione robusta mediana/MAD)         |
//|  LICENZA: nessuno dei tre dichiara una licenza [VERIFICATO il     |
//|  02/09/2026]. access=1 su TradingView rende il sorgente           |
//|  LEGGIBILE, non automaticamente RIUSABILE.                        |
//|  >>> NON E' STATA COPIATA NEMMENO UNA RIGA DI PINE. E' stata      |
//|      riscritta in MQL5 la FORMULA STATISTICA (media, deviazione,  |
//|      correlazione, z-score, z modificato di Iglewicz-Hoaglin:     |
//|      matematica pubblica, non proteggibile) E SI CITA COMUNQUE    |
//|      autore, URL e data.                                          |
//|                                                                  |
//|  DEMO. ASCII puro: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa qui perche' log e CSV     |
//|  finiscono negli stessi strumenti).                               |
//|  NON COMPILATO NE' ESEGUITO da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor PRIMA di qualunque corsa.                  |
//+------------------------------------------------------------------+
//
//  LE SCELTE DI TRADUZIONE DA CONTATORE A EA, NUMERATE.
//  Ogni scelta ha almeno una COLONNA che la misura sul campo: una
//  scelta senza colonna e' un'opinione travestita da progetto.
//  ==================================================================
//
//  R1. IL NUCLEO NON SI RISCRIVE: SI COPIA.
//      Le funzioni pure (SmaFin_Calc, StdevFin_Calc, MedianaFin_Calc,
//      MadFin_Calc, CorrFin_Calc, Rapporto_Calc, BetaOls_Calc,
//      SpreadOls_Calc, ZClassico_Calc, ZModificato_Calc,
//      ZDueBarre_Calc, Attraversamento_Calc, Convergenza_Calc,
//      InFinestra_Calc, IngressoInFinestra_Calc, AllineaSerie_Calc,
//      GiorniMetroAttivi_Calc, GiornoMetroAttivo_Calc, TrSerie_Calc,
//      AtrSerie_Calc, SpanRichiesto_Calc) sono TRASPORTATE riga per
//      riga dalla sonda v1.03, insieme all'autotest.
//      >>> E IL TRASPORTO E' FALSIFICABILE, non dichiarato: con
//      InpModoSonda = true questo EA NON manda ordini e conta solo gli
//      attraversamenti GREZZI. Quel numero deve venire IDENTICO,
//      ALLA CIFRA, a "Attraversamenti Grezzi Long/Short" del referto
//      del passo 0 sulla stessa cella e sulla stessa finestra: lo
//      z-score si calcola su BARRE CHIUSE e il modello di tick non lo
//      tocca. Se non combacia, il porto e' sbagliato e il round non
//      parte. Colonne: "Segnali Grezzi Long/Short".
//
//  R2. INGRESSO A MERCATO SULLA BARRA DOPO IL SEGNALE, NON PENDENTE.
//      Tre ragioni, in ordine di peso:
//      (a) e' l'unica costruzione che riproduce cio' che e' stato
//          MISURATO: la sonda (T10) apre all'APERTURA della barra 0
//          reale successiva alla barra di segnale;
//      (b) un pendente introdurrebbe una SELEZIONE correlata all'esito
//          (un limit si riempie solo se il prezzo torna indietro:
//          scarterebbe proprio i trade che partono subito a favore,
//          cioe' i migliori per un motore di convergenza). Sarebbe un
//          altro motore, e andrebbe misurato come tale;
//      (c) lo z si calcola a barra CHIUSA: l'istante di decisione e'
//          la chiusura della barra, cioe' l'apertura della successiva.
//      >>> IL LIMITE, DICHIARATO E MISURATO: la sonda entra al prezzo
//      di APERTURA esatto, questo EA entra al PRIMO TICK dopo
//      l'apertura. Non sono la stessa cosa. Colonne "Scarto Ingresso
//      Vs Apertura Mediano/P95 Punti Indice": se la mediana supera
//      ~0,3 punti indice (circa un decimo dello spread del DAX), il
//      confronto sonda-EA va riletto con quel numero in mano.
//
//  R3. USCITA PRIMARIA = LA CONVERGENZA, COME MISURATA.
//      |z| <= InpSogliaUscitaSigma valutato a barra CHIUSA, chiusura a
//      mercato sull'apertura della barra successiva. InpSogliaUscitaSigma
//      NON e' una manopola: e' la DEFINIZIONE del cancello C6, quello
//      che ha tenuto in vita la tesi al passo 0. Resta 0,05, fuori da
//      ogni asse.
//
//  R4. LO STOP DI SICUREZZA E' REALE, STA SUL BROKER, ED E'
//      OBBLIGATORIO. La sonda non ne aveva bisogno perche' non apriva
//      niente. Un EA vero senza SL broker-side e' una posizione nuda
//      davanti a una disconnessione, a un gap e a un evento macro.
//      LIVELLO, e da dove esce il numero (nessun numero pescato):
//        MAE mediana della cella scelta, MISURATA al passo 0:
//          D30EUR N=40 s=1,35 -> L 22,60 / S 22,77 punti indice
//          NASUSD N=40 s=1,35 -> L 40,00 / S 41,88 punti indice
//        ATR mediano di sessione, MISURATO:
//          D30EUR 17,13   NASUSD 26,98 punti indice
//        MAE mediana IN ATR: D30 1,32-1,33   NAS 1,48-1,55
//        x2 (uno stop ALLA mediana ucciderebbe META' delle
//            convergenze prima che convergano: misurerebbe lo stop,
//            non il motore) -> 2,64 ... 3,10 ATR
//        VALORE SCELTO: 2,75 x ATR, UNO SOLO per le due gambe.
//      >>> PERCHE' 2,75 E NON IL CENTRO DELL'INTERVALLO NUOVO (2,87):
//      perche' 2,75 era gia' scritto nella proposta del 04/09 PRIMA
//      che arrivassero i numeri della cella nuova. Spostarlo adesso,
//      dopo aver visto i numeri, sarebbe esattamente il riflesso che
//      questa casa vieta. Resta dentro l'intervallo misurato su tutte
//      e quattro le combinazioni gamba x lato.
//      >>> L'ASIMMETRIA CHE NE RESTA, DICHIARATA: a 2,75 ATR lo stop
//      vale 2,08 volte la MAE mediana su D30EUR ma solo 1,77-1,86
//      volte su NASUSD. Su NASUSD, e soprattutto sul lato SHORT, lo
//      stop e' quindi piu' STRETTO di quanto il progetto ("x2")
//      chiedesse: ci si aspetta piu' uscite per stop di quante ne
//      avrebbe la gamba tedesca. Colonna "Uscite Stop".
//      >>> UNO SOLO PER LE DUE GAMBE, ED E' VOLUTO: adattare la
//      geometria simbolo per simbolo prima di avere una misura e'
//      PESCARE LA GEOMETRIA che fa passare il cancello. Se D30EUR
//      muore con lo stop di NASUSD, QUELLO e' il risultato.
//
//  R5. E LO STOP CAMBIA LA POPOLAZIONE MISURATA DAL PASSO 0.
//      Tronca esattamente i trade che sarebbero convergiuti dopo
//      un'escursione profonda. QUINDI QUESTO ROUND NON VALIDA I
//      NUMERI DELLA SONDA: e' una misura NUOVA. Il tasso di
//      convergenza misurato (80,3% su D30, 82,0% su NAS) SCENDERA', e
//      va letto nelle colonne "Uscite Convergenza / Stop / Flat
//      Sessione / Tetto Barre", non confrontato ingenuamente col
//      referto del passo 0.
//
//  R6. IL TEMPO: IL CONTENITORE VERO E' IL FLAT DI FINE SESSIONE,
//      NON IL TETTO DI TENUTA.
//      RILIEVO MISURATO: la sessione 14:30-22:00 dura 450 minuti = 90
//      barre M5, mentre InpBarreMaxTenuta della sonda valeva 120. Quel
//      tetto e' STRUTTURALMENTE IRRAGGIUNGIBILE dentro una sessione:
//      NON HA MAI MORSO, e chi lo cita come "la tenuta massima
//      misurata" cita un numero inerte. Qui resta a 120 per fedelta'
//      (inerte allo stesso modo) e il contenitore e' il FLAT, che e'
//      quello che la sonda misurava davvero.
//      >>> IL FLAT NON E' UN INPUT: e' sempre acceso. Spegnerlo
//      significherebbe far attraversare la notte a una posizione la
//      cui statistica e' stata misurata dentro una sessione.
//      >>> Un time-stop piu' stretto (48 barre = 4 ore = circa 4 volte
//      la tenuta mediana misurata, 13 barre su D30 e 12 su NAS) e' una
//      ABLAZIONE DI FASE 2, a un asse solo, e NON entra nel primo giro.
//
//  R7. IL TETTO GIORNALIERO E' OBBLIGATORIO DAL PRIMO ROUND, E LO
//      DICE IL PASSO 0. Il #define C7 della sonda: "se il massimo
//      giornaliero misurato supera 5, InpMaxTradesPerDay entra nell'EA
//      DAL PRIMO ROUND". MISURATO sulla cella scelta: 10 al giorno su
//      D30EUR, 8 su NASUSD. L'aritmetica che decide:
//        10 operazioni x 0,65% tutte perdenti = -6,50%
//        -> SFONDA il muro prop giornaliero del 5% (METRO_PROP)
//        tetto 5 x 0,65% = -3,25%
//        -> sotto il muro del 5% E sotto la pausa Guardian del 4,0%
//      Il 5 non e' pescato: e' l'aritmetica del cap C1 firmato il
//      18/08 (3,25% = 5 SL vivi da 0,65%).
//      >>> COSTO DICHIARATO: il tetto TRONCA le giornate affollate e
//      mescola contenitore e motore. Colonne "Segnali Soppressi Tetto
//      Giorno" e "Giorni Col Tetto Colpito Pct": se la seconda supera
//      il 20%, questo round sta misurando IL TETTO e va scritto in
//      quei termini.
//      >>> NOTA che va tenuta distinta: con UNA posizione per volta il
//      rischio APERTO e' sempre <= 0,65% e il cap C1 non morde MAI in
//      questo round. Il tetto serve al muro GIORNALIERO, non al cap
//      aperto.
//
//  R8. UNA POSIZIONE PER VOLTA, come al passo 0 (T6). E il collaudo
//      gratis che c'era li' vale anche qui: mentre un long e' aperto
//      uno short non puo' nascere, perche' per arrivare a z > +soglia
//      lo z deve prima passare da -soglia_uscita, che chiude il long.
//      Colonna "Segnali Soppressi Posizione Aperta": se cresce molto
//      piu' del previsto, la macchina a stati e' rotta.
//
//  R9. HEDGE-SAFE, E NON E' UNA FORMALITA'.
//      Il conto e' HEDGING (CLAUDE.md). L'audit del 03/09 ha censito
//      126 file col difetto "PositionSelect cieco". Qui:
//        - LETTURA: mai PositionSelect(_Symbol). Ciclo su
//          PositionsTotal() -> PositionGetTicket(i) -> filtro magic +
//          simbolo (TrovaPosizioneNostra).
//        - SCRITTURA: TUTTO PER TICKET. Mai PositionClose(_Symbol),
//          mai PositionModify(_Symbol, ...). L'audit lo dice
//          testualmente: il mezzo fix (lettura corretta + scrittura
//          per simbolo) e' PIU' PERICOLOSO del bug originale, perche'
//          chiude la posizione del vicino.
//
//  R10. LO SPREAD SI MISURA, NON SI FILTRA (lezione R55).
//      InpMaxSpreadPts = 0 = filtro SPENTO. Lo spread all'ingresso
//      esce in colonna (mediana e P95, in punti indice). Un filtro
//      acceso al primo giro nasconderebbe proprio il numero che decide
//      il round: lo spread MISURATO di D30EUR (2,80 punti indice, ora
//      peggiore) mangia il 79% del cancello H8; quello di NASUSD
//      (1,80) ne mangia il 32%.
//
//  R11. LO SLIPPAGE QUI E' UNA TOLLERANZA DI RIEMPIMENTO, NON UN
//      COSTO SIMULATO. InpSlippagePts e' la deviazione massima
//      accettata da CTrade. A 0 il tester puo' RIFIUTARE fill e
//      trasformare un problema di riempimento in un finto problema di
//      segnale (e il rifiuto e' silenzioso se nessuno lo conta:
//      colonna "Ordini Rifiutati"). Il COSTO vero dello slippage si
//      MISURA nella colonna "Scarto Ingresso Vs Apertura".
//      >>> E per una volta la notizia e' buona, ed e' aritmetica: R55
//      ha misurato che la fragilita' allo slippage la fa la LARGHEZZA
//      DELLO STOP. Qui 1R vale 47,1 punti indice su D30EUR e 74,2 su
//      NASUSD, cioe' 4.710 e 7.420 punti MT5 (conversione MISURATA:
//      100 punti MT5 = 1 punto indice). Cinque punti MT5 di slippage
//      valgono lo 0,11% e lo 0,07% di 1R. Questo motore sta nella
//      CLASSE OPPOSTA all'ORB, e la colonna lo dimostra invece di
//      farcelo sperare.
//
//  R12. I GIORNI SPAIATI SI MISURANO, NON SI FILTRANO -- ed e' un
//      capovolgimento voluto rispetto al passo 0.
//      Su un CONTATORE un giorno spaiato (calendari sfalsati fra gamba
//      e metro) produce un SEGNALE FINTO e sporca la statistica:
//      giusto filtrarlo. Su un EA VERO quello stesso giorno produce
//      UN'OPERAZIONE VERA CON UNA PERDITA VERA: non e' un artefatto da
//      togliere, e' un RISCHIO da misurare. D30EUR ha C2 = 12,93% al
//      passo 0 (sopra la soglia di casa del 10%) e 1.057 buchi del
//      metro sulla barra di segnale contro 1 di NASUSD: la qualita'
//      dell'allineamento NON e' la stessa sulle due gambe, ed e' un
//      fatto misurato. Colonne dedicate: "Operazioni In Giorni
//      Spaiati", "Profitto In Giorni Spaiati", "Profitto Fuori Giorni
//      Spaiati". Il filtro esiste (InpSaltaGiorniSpaiati) ma nasce
//      SPENTO: e' un'ablazione di fase 2.
//
//  R13. IL LOTTO MINIMO E' UNA BUGIA SE NON SI CONTA.
//      Lezione di casa del 31/08: sei sedie giravano a lotto minimo
//      0,01 e "le riduzioni firmate sotto ~0,5% erano FINZIONE". Qui,
//      se il lotto calcolato dal rischio scende sotto il minimo del
//      simbolo, si usa il minimo E SI CONTA: colonne "Operazioni A
//      Lotto Minimo" e la sua percentuale. Se quella percentuale e'
//      alta, il rischio REALE del round non e' 0,65% e il referto lo
//      deve dire prima di leggere il drawdown.
//      Nella stessa famiglia: "Rischio Medio Realizzato Pct" e'
//      calcolato sul rischio VERO di ogni operazione (perdita per
//      lotto x lotto effettivo / equity), non su quello dichiarato.
//
//  R14. L'ASPETTATIVA IN R SI CALCOLA QUI, NON SI DEDUCE.
//      Il cancello A1 e' "E >= 0,075R al NETTO dei costi". R non e'
//      una costante: e' il rischio VERO di ciascuna operazione (vedi
//      R13). Quindi per ogni operazione chiusa si registra
//      profitto/rischio, e la colonna "Aspettativa In R" e' la media
//      di quei numeri. Dedurla dividendo il profitto totale per un R
//      medio darebbe un altro numero, e sarebbe sbagliato.
//
//  R15. LA PEGGIOR GIORNATA SI MISURA CONTRO L'EQUITY DI INIZIO
//      GIORNATA. E' il cancello A5, e il suo senso e' preciso: a
//      -4,0% il Guardian mette in pausa la giornata (firma del 18/08).
//      Una giornata peggiore di -4,0% nel backtest descrive UNA
//      GIORNATA CHE SUL CAMPO NON SAREBBE ESISTITA: quel backtest non
//      e' riproducibile, prima ancora che rischioso. Nel tester il
//      Guardian NON interviene: la colonna serve proprio a vedere
//      quanto spesso sarebbe intervenuto.
//
//  R16. COSA QUESTO EA NON DICE, e non e' una dimenticanza.
//      - NON dimostra tenuta nei REGIMI: la finestra dei tick reali
//        sugli indici BCM parte dal 2024.09.26 e copre UN SOLO REGIME
//        (toro). Emendamento della Finestra, regola C: NON soddisfatta.
//      - NON misura la CO-INTEGRAZIONE: la tesi assume che il rapporto
//        sia stazionario intraday, e quell'assunzione non e' mai stata
//        verificata in questo progetto.
//      - NON e' una sedia. Da questo round esce al massimo una
//        CANDIDATA, e solo dopo una prova di rischio su un regime
//        ostile e dopo il forward demo.
//      - LA FORMA A DUE GAMBE non e' stata misurata (si pagherebbero
//        DUE spread per UNA convergenza): qui resta UNILATERALE.
//+------------------------------------------------------------------+
#property copyright "ABTG - EA operativo del candidato RELATIVO (PASSO 1, merito a tick reali)"
#property version   "1.00"
#property description "Convergenza dello z-score del rapporto fra DUE simboli. QUESTO EA APRE ORDINI VERI."
#property strict

#include <Trade/Trade.mqh>

//==================================================================
//  I NUMERI CONGELATI PRIMA DI VEDERE QUALUNQUE RISULTATO.
//  Sono #define e non input APPOSTA: un cancello che si puo'
//  spostare dalla riga di lancio non e' un cancello.
//==================================================================

//--- la conversione punti MT5 -> punto indice, MISURATA sui tre indici
#define ABR_PUNTI_PER_INDICE_ATTESO  100.0

//--- lo spread MISURATO (mediana oraria PEGGIORE nelle ore di lavoro
//    14-21 server), da SPREAD_FLOTTA_MISURA_2026-09-03.md. Qui NON e'
//    un cancello: e' l'atteso contro cui si legge la colonna misurata
//    all'ingresso. Se la colonna si discosta molto, il broker o la
//    finestra non sono quelli di allora, e va scritto.
#define ABR_SPREAD_D30EUR            2.80
#define ABR_SPREAD_NASUSD            1.80
#define ABR_SPREAD_U30USD            2.00

//--- capienza dei campioni per le mediane
#define ABR_MAX_CAMPIONI             100000

//--- numero di valori esportati in colonna. E' un #define perche'
//    l'array, l'intestazione e la riga di formato SI TOCCANO SEMPRE
//    INSIEME: piu' sotto c'e' un controllo automatico che conta le
//    virgole dell'intestazione e i '%' del formato e URLA se non
//    tornano (la trappola del CSV sfasato, gia' pagata in casa).
#define ABR_NSTATS                   73

#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI dal file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO).
//==================================================================
input group "=== IL METRO -- il secondo simbolo, che si LEGGE e non si scambia ==="
input string InpSimboloMetro        = "U30USD";  // simbolo METRO: si legge, NON si scambia
input int    InpModoSpread          = 0;         // 0 = rapporto gamba/metro | 1 = beta OLS (ablazione, fase 2)
input int    InpModoZScore          = 0;         // 0 = media/deviazione | 1 = mediana/MAD (ablazione, fase 2)

input group "=== IL MOTORE -- la cella scelta al passo 0, CONGELATA (proposta 04/09) ==="
input int    InpFinestraN           = 40;        // finestra dello z-score. CONGELATA: centro del blocco 2x2 interno
input double InpSogliaIngressoSigma = 1.35;      // attraversamento d'ingresso, in sigma. CONGELATA
input double InpSogliaUscitaSigma   = 0.05;      // rientro = convergenza. PIN: e' la DEFINIZIONE di C6 (R3)

input group "=== LA FINESTRA -- ORA SERVER BCM (= ora italiana - 1), al MINUTO ==="
input int    InpOraInizioServer     = 14;        // 14:30 server = 15:30 italiane
input int    InpMinInizioServer     = 30;
input int    InpOraFineServer       = 22;        // 22:00 server = 23:00 italiane. FINE ESCLUSA
input int    InpMinFineServer       = 0;

input group "=== USCITE E RISCHIO ==="
input double InpAtrSL               = 2.75;      // stop REALE = questo x ATR (R4). 2 x MAE mediana misurata
input int    InpBarreMaxTenuta      = 120;       // tetto di tenuta: INERTE dentro una sessione da 90 barre (R6)
input double InpRiskPercent         = 0.65;      // rischio per operazione, taglia di CAMPO
input int    InpMaxTradesPerDay     = 5;         // tetto giornaliero OBBLIGATORIO (R7). 5 x 0,65% = cap C1 3,25%
input int    InpLato                = 0;         // 0 = entrambi | 1 = solo long | 2 = solo short

input group "=== ATR (qui DECIDE: e' la scala dello stop) ==="
input int    InpAtrPeriod           = 14;        // periodo ATR sulla GAMBA
input bool   InpAtrModoRma          = false;     // false = SMA del TR (convenzione iATR misurata) | true = Wilder

input group "=== ORDINI ==="
input ulong  InpMagic               = 774601;    // 774601 = D30EUR, 774602 = NASUSD. Blocco 7746xx VERIFICATO VERGINE
input int    InpSlippagePts         = 10;        // tolleranza di riempimento in punti MT5 (R11), NON un costo simulato
input int    InpMaxSpreadPts        = 0;         // 0 = filtro SPENTO: lo spread si MISURA, non si filtra (R10)

input group "=== ABLAZIONI DI FASE 2 -- nascono SPENTE ==="
input bool   InpModoSonda           = false;     // true = NON manda ordini, conta e basta: e' il COLLAUDO DEL PORTO (R1)
input bool   InpSaltaGiorniSpaiati  = false;     // false = si MISURA il costo dei giorni spaiati, non si filtra (R12)

input group "=== TECNICI ==="
input int    InpWarmupBarre         = 300;       // coda di barre ricalcolate a ogni barra nuova
input double InpPuntiPerIndice      = 100.0;     // punti MT5 per 1 punto indice. MISURATO = 100 sui tre indici
input bool   InpScriviCsv           = true;      // CSV riga-per-operazione (SOLO fuori ottimizzazione)
input bool   InpVerbose             = true;      // log
input bool   InpAutoTest            = true;      // autotest del nucleo puro. L'esito esce in COLONNA
input string InpTag                 = "RELATIVO"; // etichetta per log e CSV

//==================================================================
//  STATO
//==================================================================
CTrade   gTrade;

datetime gLastBar        = 0;
double   gPuntoIndice    = 0.0;
int      gTfSec          = 0;
double   gSpreadAtteso   = 0.0;

//--- conteggi di barre e di sincronizzazione fra i DUE feed
long gBarreValutate      = 0;
long gBarreFuoriFinestra = 0;
long gBarreSaltateDati   = 0;
long gMetroMancantiUltima= 0;
long gValutazioniPerseBuco = 0;
long gValutazioniSoloMetro = 0;
long gZNonCalcolabile    = 0;

//--- segnali e soppressioni (ogni soppressione ha il SUO contatore:
//    un solo "scartati" non direbbe MAI perche')
long gGrezziL = 0, gGrezziS = 0;
long gSoppPosizione = 0;
long gSoppTetto     = 0;
long gSoppFuoriFinestra = 0;
long gSoppLato      = 0;
long gSoppSpread    = 0;
long gSoppSpaiato   = 0;

//--- operazioni
long gOpL = 0, gOpS = 0;
long gUscConv = 0, gUscStop = 0, gUscFlat = 0, gUscTetto = 0, gUscFineCorsa = 0, gUscIgnota = 0;
long gOrdiniRifiutati = 0;
int  gUltimoRetcode = 0;
long gLottoMinimo = 0;
long gSlAllargato = 0;

//--- giornate
int  gDayStamp   = -1;
bool gDaySpaiato = false;
long gGiorniContati = 0, gGiorniSpaiati = 0, gGiorniTettoColpito = 0;
int  gDayTrades  = 0;
bool gDayTettoColpito = false;
double gEquityInizioGiorno = 0.0;
double gPeggiorGiornataPct = 0.0;

//--- campioni per le mediane
double gCampGuadagnoVinc[]; int gNGuadagnoVinc = 0;   // guadagno realizzato dei VINCENTI, punti indice
double gCampMfe[];          int gNMfe = 0;            // MFE in-trade, punti indice
double gCampMae[];          int gNMae = 0;            // MAE in-trade, punti indice
double gCampSpread[];       int gNSpread = 0;         // spread all'ingresso, punti indice
double gCampScarto[];       int gNScarto = 0;         // fill meno apertura, punti indice
double gCampTenuta[];       int gNTenuta = 0;         // tenuta in barre
double gCampAtr[];          int gNAtr = 0;            // ATR al segnale, punti indice
bool   gTroncato = false;

//--- aggregati economici
double gSommaR       = 0.0;    // somma di profitto/rischio, per l'aspettativa in R (R14)
long   gNR           = 0;
double gSommaRischioPct = 0.0; // rischio REALE per operazione, in % di equity (R13)
long   gNRischio     = 0;
double gProfittoSpaiati = 0.0;
double gProfittoPuliti  = 0.0;
long   gOpSpaiati    = 0;      // operazioni APERTE in un giorno gia' marcato spaiato (R12)

//--- autotest: -1 = NON eseguito, che non e' "passato"
int gAutotestFalliti = -1;
int gAutotestBlocchi = 0;

//--- LA POSIZIONE (una sola, R8). Il ticket e' l'identita': su conto
//    hedging il simbolo NON basta (R9).
ulong    gTicket     = 0;
int      gPosLato    = 0;          // +1 long, -1 short
datetime gPosTIngr   = 0;
double   gPosPrezzo  = 0.0;        // prezzo di FILL vero
double   gPosSl      = 0.0;
double   gPosLotto   = 0.0;
double   gPosRischio = 0.0;        // rischio in valuta, VERO
int      gPosBarre   = 0;
double   gPosMfe     = 0.0;
double   gPosMae     = 0.0;
bool     gPosSpaiato = false;      // aperta in un giorno gia' marcato spaiato

//--- CSV riga-per-operazione
int gCsvOp = INVALID_HANDLE;

void Log(string m){ if(InpVerbose) Print("[", InpTag, "] ", m); }

//==================================================================
//
//   NUCLEO PURO -- TRASPORTATO RIGA PER RIGA DALLA SONDA v1.03 (R1).
//   Non legge NIENTE dal terminale: prende numeri e risponde. E'
//   questa la parte che l'AUTOTEST interroga a tavolino.
//
//   Convenzione degli indici: 0 = barra piu' VECCHIA, n-1 = barra
//   piu' RECENTE (l'ultima CHIUSA). Nessun array e' "as series".
//
//==================================================================

//+------------------------------------------------------------------+
//| MEDIA SEMPLICE su una finestra che FINISCE in 'fine'.             |
//+------------------------------------------------------------------+
bool SmaFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   if(quante < 1 || fine < 0 || fine >= n) return(false);
   int da = fine - quante + 1;
   if(da < 0) return(false);
   double s = 0.0;
   for(int i = da; i <= fine; i++) s += v[i];
   out = s/(double)quante;
   return(true);
  }

//+------------------------------------------------------------------+
//| DEVIAZIONE STANDARD DI POPOLAZIONE (divisore 'quante'): e' la     |
//| convenzione di ta.stdev con biased=true, default di Pine. La      |
//| scelta e' dichiarata qui e non lasciata al caso.                  |
//+------------------------------------------------------------------+
bool StdevFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double media;
   if(!SmaFin_Calc(v, n, fine, quante, media)) return(false);
   int da = fine - quante + 1;
   double s = 0.0;
   for(int i = da; i <= fine; i++)
     {
      double d = v[i] - media;
      s += d*d;
     }
   out = MathSqrt(s/(double)quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| CORRELAZIONE DI PEARSON. Serve SOLO al modo beta OLS.             |
//+------------------------------------------------------------------+
bool CorrFin_Calc(const double &x[], const double &y[], const int n,
                  const int fine, const int quante, double &out)
  {
   out = 0.0;
   double mx, my;
   if(!SmaFin_Calc(x, n, fine, quante, mx)) return(false);
   if(!SmaFin_Calc(y, n, fine, quante, my)) return(false);
   int da = fine - quante + 1;
   double sxy = 0.0, sxx = 0.0, syy = 0.0;
   for(int i = da; i <= fine; i++)
     {
      double dx = x[i] - mx;
      double dy = y[i] - my;
      sxy += dx*dy; sxx += dx*dx; syy += dy*dy;
     }
   if(sxx <= 0.0 || syy <= 0.0) return(false);
   out = sxy/MathSqrt(sxx*syy);
   return(true);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.  |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| MEDIANA sulla finestra che finisce in 'fine'.                     |
//+------------------------------------------------------------------+
bool MedianaFin_Calc(const double &v[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   if(quante < 1 || fine < 0 || fine >= n) return(false);
   int da = fine - quante + 1;
   if(da < 0) return(false);
   double c[];
   if(ArrayResize(c, quante) != quante) return(false);
   for(int i = 0; i < quante; i++) c[i] = v[da + i];
   ArraySort(c);
   out = MedianaOrdinata_Calc(c, quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| MAD -- mediana degli scarti assoluti dalla mediana.               |
//+------------------------------------------------------------------+
bool MadFin_Calc(const double &v[], const int n, const int fine, const int quante,
                 double &mediana, double &mad)
  {
   mediana = 0.0; mad = 0.0;
   if(!MedianaFin_Calc(v, n, fine, quante, mediana)) return(false);
   int da = fine - quante + 1;
   double c[];
   if(ArrayResize(c, quante) != quante) return(false);
   for(int i = 0; i < quante; i++) c[i] = MathAbs(v[da + i] - mediana);
   ArraySort(c);
   mad = MedianaOrdinata_Calc(c, quante);
   return(true);
  }

//+------------------------------------------------------------------+
//| IL RAPPORTO fra la gamba e il metro. Il guardiano su x <= 0 non   |
//| e' teoria: un tick sporco a zero su un CFD di indice esiste, e    |
//| una divisione per zero qui diventerebbe un segnale finto.         |
//+------------------------------------------------------------------+
bool Rapporto_Calc(const double y, const double x, double &out)
  {
   out = 0.0;
   if(x <= 0.0) return(false);
   out = y/x;
   return(true);
  }

//+------------------------------------------------------------------+
//| IL BETA OLS: beta = corr(x,y,n) * stdev(y,n) / stdev(x,n).        |
//+------------------------------------------------------------------+
bool BetaOls_Calc(const double &x[], const double &y[], const int n,
                  const int fine, const int quante, double &out)
  {
   out = 0.0;
   double corr, sx, sy;
   if(!CorrFin_Calc(x, y, n, fine, quante, corr)) return(false);
   if(!StdevFin_Calc(x, n, fine, quante, sx)) return(false);
   if(!StdevFin_Calc(y, n, fine, quante, sy)) return(false);
   if(sx <= 0.0) return(false);
   out = corr*sy/sx;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO SPREAD IN MODO BETA: spread = sma(y,n) - beta * sma(x,n).      |
//+------------------------------------------------------------------+
bool SpreadOls_Calc(const double &x[], const double &y[], const int n,
                    const int fine, const int quante, double &out)
  {
   out = 0.0;
   double beta, mx, my;
   if(!BetaOls_Calc(x, y, n, fine, quante, beta)) return(false);
   if(!SmaFin_Calc(x, n, fine, quante, mx)) return(false);
   if(!SmaFin_Calc(y, n, fine, quante, my)) return(false);
   out = my - beta*mx;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE CLASSICO. Deviazione nulla -> NON CALCOLABILE (false), |
//| e chi chiama lo conta in colonna. Restituire 0 sarebbe peggio: 0  |
//| e' "perfettamente allineati", cioe' la condizione di USCITA. Un   |
//| indefinito letto come uscita chiuderebbe posizioni vere che       |
//| nessuno ha deciso di chiudere.                                    |
//+------------------------------------------------------------------+
bool ZClassico_Calc(const double &d[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double media, dev;
   if(!SmaFin_Calc(d, n, fine, quante, media)) return(false);
   if(!StdevFin_Calc(d, n, fine, quante, dev)) return(false);
   if(dev <= 0.0) return(false);
   out = (d[fine] - media)/dev;
   return(true);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE MODIFICATO (Iglewicz-Hoaglin):                         |
//|   z = 0,6745 * (x - mediana) / MAD                                |
//| Il 0,6745 rende il numero CONFRONTABILE con lo z classico: le     |
//| stesse soglie in sigma significano la stessa cosa nei due modi.   |
//+------------------------------------------------------------------+
bool ZModificato_Calc(const double &d[], const int n, const int fine, const int quante, double &out)
  {
   out = 0.0;
   double med, mad;
   if(!MadFin_Calc(d, n, fine, quante, med, mad)) return(false);
   if(mad <= 0.0) return(false);
   out = 0.6745*(d[fine] - med)/mad;
   return(true);
  }

//+------------------------------------------------------------------+
//| L'ATTRAVERSAMENTO. Non e' uno STATO ("z e' sotto soglia") ma un   |
//| EVENTO ("z ERA sopra e ORA e' sotto"): e' questa la differenza    |
//| fra contare 26 segnali al giorno e contarne 2-3 veri.             |
//|   lato +1 (LONG)  : zPrec >= -soglia  AND  z <  -soglia           |
//|   lato -1 (SHORT) : zPrec <= +soglia  AND  z >  +soglia           |
//| I confronti sono ASIMMETRICI apposta: uno z fermo ESATTAMENTE     |
//| sulla soglia non attraversa niente.                               |
//| >>> IL VERSO, detto in parole: z molto NEGATIVO = la gamba e' a   |
//|     SCONTO sul metro -> si COMPRA la gamba. z molto POSITIVO =    |
//|     la gamba e' CARA -> si VENDE la gamba.                        |
//+------------------------------------------------------------------+
bool Attraversamento_Calc(const double zPrec, const double z, const double soglia, const int lato)
  {
   if(soglia <= 0.0) return(false);
   if(lato > 0) return(zPrec >= -soglia && z < -soglia);
   if(lato < 0) return(zPrec <=  soglia && z >  soglia);
   return(false);
  }

//+------------------------------------------------------------------+
//| LA CONVERGENZA -- la definizione operativa di C6 (R3).            |
//|   long  : rientrato quando z >= -sogliaUscita                     |
//|   short : rientrato quando z <= +sogliaUscita                     |
//+------------------------------------------------------------------+
bool Convergenza_Calc(const double z, const double sogliaUscita, const int lato)
  {
   if(lato > 0) return(z >= -sogliaUscita);
   if(lato < 0) return(z <=  sogliaUscita);
   return(false);
  }

//+------------------------------------------------------------------+
//| LA FINESTRA ORARIA AL MINUTO. Inizio INCLUSO, fine ESCLUSA.       |
//+------------------------------------------------------------------+
bool InFinestra_Calc(const int ora, const int minuto,
                     const int oraIni, const int minIni,
                     const int oraFin, const int minFin)
  {
   if(ora < 0 || ora > 23 || minuto < 0 || minuto > 59) return(false);
   int m = ora*60 + minuto;
   int a = oraIni*60 + minIni;
   int b = oraFin*60 + minFin;
   if(a == b) return(false);
   if(a < b)  return(m >= a && m < b);
   return(m >= a || m < b);
  }

//+------------------------------------------------------------------+
//| IL GATE SULLA BARRA D'INGRESSO **REALE** (fix T12 della sonda).   |
//| Si entra sulla barra 0 vera, non su tSeg + tfSec: se lo storico   |
//| ha un buco le due NON coincidono, e chiedere alla barra teorica   |
//| lascia aprire posizioni su una barra gia' fuori sessione.         |
//+------------------------------------------------------------------+
bool IngressoInFinestra_Calc(const datetime tSeg, const datetime tReale, const int tfSec,
                             const int oraIni, const int minIni,
                             const int oraFin, const int minFin,
                             bool &contigua)
  {
   contigua = (tfSec > 0 && tReale == tSeg + tfSec);
   if(tReale <= tSeg) return(false);
   MqlDateTime t; TimeToStruct(tReale, t);
   return(InFinestra_Calc(t.hour, t.min, oraIni, minIni, oraFin, minFin));
  }

//+------------------------------------------------------------------+
//| TRUE RANGE. Prima barra della coda: high-low.                     |
//+------------------------------------------------------------------+
bool TrSerie_Calc(const double &high[], const double &low[], const double &close[],
                  const int n, double &out[])
  {
   if(n < 1) return(false);
   if(ArrayResize(out, n) != n) return(false);
   out[0] = high[0] - low[0];
   for(int i = 1; i < n; i++)
     {
      double a = high[i] - low[i];
      double b = MathAbs(high[i] - close[i-1]);
      double c = MathAbs(low[i]  - close[i-1]);
      double m = a;
      if(b > m) m = b;
      if(c > m) m = c;
      out[i] = m;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ATR. modoRma = true -> Wilder/RMA. false -> media SEMPLICE del    |
//| TR, che e' la convenzione di iATR misurata in casa.               |
//+------------------------------------------------------------------+
bool AtrSerie_Calc(const double &tr[], const int n, const int periodo,
                   const bool modoRma, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += tr[i];
   out[periodo - 1] = s/(double)periodo;

   if(modoRma)
     {
      double a = 1.0/(double)periodo;
      for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(tr[i] - out[i-1]);
     }
   else
     {
      double somma = s;
      for(int i = periodo; i < n; i++)
        {
         somma += tr[i] - tr[i - periodo];
         out[i] = somma/(double)periodo;
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PUNTI INDICE.                           |
//+------------------------------------------------------------------+
double PuntiIndice_Calc(const double diffPrezzo, const double puntoIndice)
  {
   if(puntoIndice <= 0.0) return(0.0);
   return(diffPrezzo/puntoIndice);
  }

//+------------------------------------------------------------------+
//| LO SPAN che lo z-score guarda all'indietro.                       |
//+------------------------------------------------------------------+
int SpanRichiesto_Calc(const int finestra, const int modoSpread)
  {
   if(finestra < 1) return(0);
   if(modoSpread == 1) return(3*finestra + 1);
   return(2*finestra + 1);
  }

//+------------------------------------------------------------------+
//| LO Z-SCORE DELLE DUE ULTIME BARRE. Catena:                        |
//|   serie[k] = y[k]/x[k]  oppure  sma(y,n)[k] - beta[k]*sma(x,n)[k] |
//|   delta[k] = serie[k] - sma(serie,n)[k]                           |
//|   z[k]     = (delta[k] - sma(delta,n)[k]) / stdev(delta,n)[k]     |
//| Ritorna false se un solo anello non e' calcolabile: mezza catena  |
//| non e' un mezzo segnale, e' NESSUN segnale.                       |
//+------------------------------------------------------------------+
bool ZDueBarre_Calc(const double &y[], const double &x[], const int n, const int fine,
                    const int finestra, const int modoSpread, const int modoZ,
                    double &z, double &zPrec)
  {
   z = 0.0; zPrec = 0.0;
   if(finestra < 1 || fine < 1 || fine >= n) return(false);
   int span = SpanRichiesto_Calc(finestra, modoSpread);
   if(fine - span + 1 < 0) return(false);

   int nS = 2*finestra;
   double s[];
   if(ArrayResize(s, nS) != nS) return(false);
   for(int k = 0; k < nS; k++)
     {
      int idx = fine - nS + 1 + k;
      double v;
      if(modoSpread == 1)
        { if(!SpreadOls_Calc(x, y, n, idx, finestra, v)) return(false); }
      else
        { if(!Rapporto_Calc(y[idx], x[idx], v))          return(false); }
      s[k] = v;
     }

   int nD = finestra + 1;
   double d[];
   if(ArrayResize(d, nD) != nD) return(false);
   for(int k = 0; k < nD; k++)
     {
      int locale = nS - nD + k;
      double media;
      if(!SmaFin_Calc(s, nS, locale, finestra, media)) return(false);
      d[k] = s[locale] - media;
     }

   if(modoZ == 1)
     {
      if(!ZModificato_Calc(d, nD, nD-1, finestra, z))     return(false);
      if(!ZModificato_Calc(d, nD, nD-2, finestra, zPrec)) return(false);
     }
   else
     {
      if(!ZClassico_Calc(d, nD, nD-1, finestra, z))       return(false);
      if(!ZClassico_Calc(d, nD, nD-2, finestra, zPrec))   return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| L'ALLINEAMENTO DELLE DUE SERIE, barra per barra, sui TIMESTAMP.   |
//| Se manca una barra del metro la barra si SALTA: non si riusa la   |
//| precedente, e non esiste nessun input per farlo. Un carry-forward |
//| inventerebbe uno scarto mai esistito, cioe' un SEGNALE FINTO.     |
//+------------------------------------------------------------------+
bool AllineaSerie_Calc(const datetime &ty[], const int n,
                       const datetime &tx[], const double &cx[], const int nx,
                       const int daConta,
                       double &xa[], bool &valido[], int &allineate, int &soloMetro)
  {
   allineate = 0; soloMetro = 0;
   if(n < 1) return(false);
   if(ArrayResize(xa, n) != n) return(false);
   if(ArrayResize(valido, n) != n) return(false);
   for(int i = 0; i < n; i++){ xa[i] = 0.0; valido[i] = false; }
   int      dc  = (daConta < 0 || daConta >= n) ? 0 : daConta;
   datetime tDa = ty[dc];
   if(nx < 1) return(true);

   int j = 0;
   for(int i = 0; i < n; i++)
     {
      while(j < nx && tx[j] < ty[i]){ if(tx[j] >= tDa) soloMetro++; j++; }
      if(j < nx && tx[j] == ty[i])
        {
         xa[i] = cx[j];
         valido[i] = true;
         allineate++;
         j++;
        }
     }
   while(j < nx){ if(tx[j] >= tDa) soloMetro++; j++; }
   return(true);
  }

//+------------------------------------------------------------------+
//| I GIORNI IN CUI IL METRO HA ALMENO UNA BARRA DENTRO LA FINESTRA   |
//| ORARIA. Serve a separare "il mercato del metro era chiuso quel    |
//| giorno" (festivita' propria, FISIOLOGICO) da "il metro era attivo |
//| ma manca proprio quella barra" (buco vero del feed).              |
//+------------------------------------------------------------------+
void GiorniMetroAttivi_Calc(const datetime &tx[], const int nx,
                            const int oraIni, const int minIni,
                            const int oraFin, const int minFin,
                            int &giorni[], int &nGiorni)
  {
   nGiorni = 0;
   int cap = 32;
   if(ArrayResize(giorni, cap) < cap){ ArrayResize(giorni, 0); return; }
   int ultimo = -1;
   for(int i = 0; i < nx; i++)
     {
      MqlDateTime g; TimeToStruct(tx[i], g);
      if(!InFinestra_Calc(g.hour, g.min, oraIni, minIni, oraFin, minFin)) continue;
      int stamp = g.year*1000 + g.day_of_year;
      if(stamp == ultimo) continue;
      ultimo = stamp;
      if(nGiorni >= cap)
        {
         cap *= 2;
         if(ArrayResize(giorni, cap) < cap) break;
        }
      giorni[nGiorni] = stamp;
      nGiorni++;
     }
  }

//+------------------------------------------------------------------+
//| Ricerca binaria del giorno nell'elenco (che e' crescente).        |
//+------------------------------------------------------------------+
bool GiornoMetroAttivo_Calc(const int &giorni[], const int nGiorni, const int stamp)
  {
   int lo = 0, hi = nGiorni - 1;
   while(lo <= hi)
     {
      int mid = (lo + hi) / 2;
      if(giorni[mid] == stamp) return(true);
      if(giorni[mid] <  stamp) lo = mid + 1; else hi = mid - 1;
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| L'ESCURSIONE: aggiorna MFE e MAE dal prezzo d'ingresso, in punti  |
//| indice, sui massimi/minimi della GAMBA (il metro non si scambia). |
//+------------------------------------------------------------------+
void AggiornaEscursione_Calc(const int lato, const double prezzoIngresso,
                             const double high, const double low,
                             const double puntoIndice,
                             double &mfe, double &mae)
  {
   double su  = PuntiIndice_Calc(high - prezzoIngresso, puntoIndice);
   double giu = PuntiIndice_Calc(prezzoIngresso - low,  puntoIndice);
   double favore = (lato > 0) ? su  : giu;
   double contro = (lato > 0) ? giu : su;
   if(favore > mfe) mfe = favore;
   if(contro > mae) mae = contro;
  }

//+------------------------------------------------------------------+
//| IL LOTTO DAL RISCHIO. Nucleo puro: prende numeri, risponde.       |
//| perditaPerLotto = (distanzaSL in prezzo / tickSize) * tickValue   |
//| lotto = rischio in valuta / perditaPerLotto, normalizzato allo    |
//| step e limitato a min/max. 'sottoMinimo' esce TRUE quando il      |
//| lotto teorico e' sotto il minimo del simbolo: quel caso NON si    |
//| nasconde (R13), si conta.                                         |
//+------------------------------------------------------------------+
double LottoDaRischio_Calc(const double rischioValuta, const double distanzaSlPrezzo,
                           const double tickSize, const double tickValue,
                           const double volMin, const double volMax, const double volStep,
                           bool &sottoMinimo, double &perditaPerLotto)
  {
   sottoMinimo = false; perditaPerLotto = 0.0;
   if(rischioValuta <= 0.0 || distanzaSlPrezzo <= 0.0) return(0.0);
   if(tickSize <= 0.0 || tickValue <= 0.0) return(0.0);
   if(volMin <= 0.0 || volStep <= 0.0 || volMax < volMin) return(0.0);

   perditaPerLotto = (distanzaSlPrezzo/tickSize)*tickValue;
   if(perditaPerLotto <= 0.0) return(0.0);

   double teorico = rischioValuta/perditaPerLotto;
   double passi   = MathFloor(teorico/volStep + 1e-9);
   double lotto   = passi*volStep;
   if(lotto < volMin){ lotto = volMin; sottoMinimo = true; }
   if(lotto > volMax)  lotto = volMax;
   return(lotto);
  }

//==================================================================
//  CAMPIONI E MEDIANE
//==================================================================
void AggiungiCampione(double &arr[], int &n, const double v)
  {
   if(n >= ABR_MAX_CAMPIONI){ gTroncato = true; return; }
   if(ArraySize(arr) <= n)
     {
      int nuovo = (ArraySize(arr) < 64) ? 64 : ArraySize(arr)*2;
      if(nuovo > ABR_MAX_CAMPIONI) nuovo = ABR_MAX_CAMPIONI;
      if(ArrayResize(arr, nuovo) < nuovo){ gTroncato = true; return; }
     }
   arr[n] = v;
   n++;
  }

double Mediana(const double &arr[], const int n)
  {
   if(n <= 0) return(0.0);
   double c[];
   if(ArrayResize(c, n) != n) return(0.0);
   for(int i = 0; i < n; i++) c[i] = arr[i];
   ArraySort(c);
   return(MedianaOrdinata_Calc(c, n));
  }

//+------------------------------------------------------------------+
//| PERCENTILE con interpolazione lineare. Serve al P95 dello spread: |
//| la mediana da sola non dice niente sulle code, ed e' nelle code   |
//| che lo spread mangia il round.                                    |
//+------------------------------------------------------------------+
double Percentile(const double &arr[], const int n, const double q)
  {
   if(n <= 0) return(0.0);
   if(n == 1) return(arr[0]);
   double c[];
   if(ArrayResize(c, n) != n) return(0.0);
   for(int i = 0; i < n; i++) c[i] = arr[i];
   ArraySort(c);
   double pos = q*(double)(n - 1);
   int    lo  = (int)MathFloor(pos);
   int    hi  = lo + 1;
   if(hi >= n) return(c[n-1]);
   double f = pos - (double)lo;
   return(c[lo] + f*(c[hi] - c[lo]));
  }

//==================================================================
//  LA PARTE CHE PARLA COL TERMINALE. Da qui in giu' NON e' piu'
//  nucleo puro, e l'autotest non la tocca.
//==================================================================

//+------------------------------------------------------------------+
//| LA POSIZIONE NOSTRA, SU CONTO HEDGING (R9).                       |
//| PositionSelect(_Symbol) selezionerebbe la posizione PIU' VECCHIA  |
//| del simbolo, qualunque sia il magic: su un simbolo affollato l'EA |
//| diventerebbe cieco alla propria posizione (o, peggio, chiuderebbe |
//| quella del vicino). Si cicla e si filtra per magic + simbolo.     |
//+------------------------------------------------------------------+
ulong TrovaPosizioneNostra()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(!PositionSelectByTicket(tk)) continue;
      if((ulong)PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      return(tk);
     }
   return(0);
  }

//+------------------------------------------------------------------+
//| LA CHIUSURA, letta dallo STORICO della posizione: prezzo d'uscita |
//| e profitto NETTO (profit + swap + commissioni di TUTTI i deal).   |
//| Le commissioni stanno spesso sul deal di INGRESSO: sommarle solo  |
//| sul deal d'uscita sarebbe un netto che non e' netto.              |
//+------------------------------------------------------------------+
bool LeggiChiusura(const ulong ticket, double &prezzoUscita, double &profittoNetto)
  {
   prezzoUscita = 0.0; profittoNetto = 0.0;
   if(!HistorySelectByPosition(ticket)) return(false);
   int n = HistoryDealsTotal();
   bool trovato = false;
   for(int i = 0; i < n; i++)
     {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      profittoNetto += HistoryDealGetDouble(d, DEAL_PROFIT)
                     + HistoryDealGetDouble(d, DEAL_SWAP)
                     + HistoryDealGetDouble(d, DEAL_COMMISSION);
      if(HistoryDealGetInteger(d, DEAL_ENTRY) == DEAL_ENTRY_OUT)
        { prezzoUscita = HistoryDealGetDouble(d, DEAL_PRICE); trovato = true; }
     }
   return(trovato);
  }

//+------------------------------------------------------------------+
//| REGISTRA UNA POSIZIONE CHIUSA. Un solo punto in cui si contano    |
//| esiti, campioni e aggregati: due punti diventerebbero due         |
//| contabilita' diverse, ed e' cosi' che nascono i referti che non   //
//| tornano.                                                          |
//|   motivo 1 = convergenza | 2 = stop | 3 = flat sessione           |
//|          4 = tetto barre | 5 = fine corsa | 0 = ignoto            |
//+------------------------------------------------------------------+
void RegistraChiusura(const int motivo)
  {
   if(gTicket == 0) return;

   double prezzoUscita = 0.0, profitto = 0.0;
   bool letta = LeggiChiusura(gTicket, prezzoUscita, profitto);

   if(motivo == 1)      gUscConv++;
   else if(motivo == 2) gUscStop++;
   else if(motivo == 3) gUscFlat++;
   else if(motivo == 4) gUscTetto++;
   else if(motivo == 5) gUscFineCorsa++;
   else                 gUscIgnota++;

   //--- il guadagno in PUNTI INDICE, segnato dal lato. E' il numero
   //    che si confronta con la MFE mediana (colonna 5 dei criteri):
   //    se il realizzato per vincente sta molto sotto la MFE mediana,
   //    la geometria non regge il costo, e questo lo dice prima del PF.
   double guadagnoIdx = 0.0;
   if(letta && prezzoUscita > 0.0 && gPosPrezzo > 0.0)
      guadagnoIdx = PuntiIndice_Calc((prezzoUscita - gPosPrezzo)*(double)gPosLato, gPuntoIndice);

   if(guadagnoIdx > 0.0) AggiungiCampione(gCampGuadagnoVinc, gNGuadagnoVinc, guadagnoIdx);
   AggiungiCampione(gCampMfe, gNMfe, gPosMfe);
   AggiungiCampione(gCampMae, gNMae, gPosMae);
   AggiungiCampione(gCampTenuta, gNTenuta, (double)gPosBarre);

   //--- l'aspettativa in R, sul rischio VERO di QUESTA operazione (R14)
   if(gPosRischio > 0.0)
     {
      gSommaR += profitto/gPosRischio;
      gNR++;
     }

   if(gPosSpaiato){ gProfittoSpaiati += profitto; gOpSpaiati++; }
   else             gProfittoPuliti  += profitto;

   if(gCsvOp != INVALID_HANDLE)
      FileWrite(gCsvOp,
                TimeToString(gPosTIngr, TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                (gPosLato > 0 ? "LONG" : "SHORT"),
                DoubleToString(gPosLotto, 2),
                DoubleToString(gPosPrezzo, _Digits),
                DoubleToString(prezzoUscita, _Digits),
                DoubleToString(gPosSl, _Digits),
                IntegerToString(motivo),
                IntegerToString(gPosBarre),
                DoubleToString(gPosMfe, 3),
                DoubleToString(gPosMae, 3),
                DoubleToString(guadagnoIdx, 3),
                DoubleToString(profitto, 2),
                DoubleToString(gPosRischio, 2),
                (gPosSpaiato ? "SPAIATO" : "-"));

   gTicket = 0; gPosLato = 0; gPosBarre = 0;
   gPosMfe = 0.0; gPosMae = 0.0; gPosRischio = 0.0; gPosSpaiato = false;
  }

//+------------------------------------------------------------------+
//| CHIUDE LA NOSTRA POSIZIONE, PER TICKET (R9). Mai per simbolo.     |
//+------------------------------------------------------------------+
void ChiudiPosizione(const int motivo)
  {
   if(gTicket == 0) return;
   if(InpModoSonda){ gTicket = 0; return; }

   if(!gTrade.PositionClose(gTicket))
     {
      gUltimoRetcode = (int)gTrade.ResultRetcode();
      gOrdiniRifiutati++;
      Log(StringFormat("CHIUSURA RIFIUTATA sul ticket %I64u (retcode %d, %s): la posizione resta APERTA e il prossimo giro riprova.",
                       gTicket, gUltimoRetcode, gTrade.ResultRetcodeDescription()));
      return;
     }
   gUltimoRetcode = (int)gTrade.ResultRetcode();
   RegistraChiusura(motivo);
  }

//+------------------------------------------------------------------+
//| APRE LA POSIZIONE. Qui stanno tutti i vincoli d'ordine: stops     |
//| level, decimali, volume min/max/step, retcode controllato.        |
//+------------------------------------------------------------------+
void ApriPosizione(const int lato, const double atrPrezzo, const double aperturaBarra)
  {
   if(atrPrezzo <= 0.0) return;

   //--- lo SPREAD si MISURA sempre, e si filtra solo se qualcuno lo
   //    chiede esplicitamente (R10).
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0.0 || bid <= 0.0){ gBarreSaltateDati++; return; }
   double spreadPts = (ask - bid)/_Point;
   if(InpMaxSpreadPts > 0 && spreadPts > (double)InpMaxSpreadPts){ gSoppSpread++; return; }

   //--- la distanza dello stop, e il rispetto dello STOPS_LEVEL del
   //    simbolo: se il broker non accetta uno stop cosi' vicino si
   //    ALLARGA al minimo consentito E SI CONTA (allargare in silenzio
   //    vorrebbe dire misurare un rischio diverso da quello dichiarato).
   double dist = InpAtrSL*atrPrezzo;
   double stopsLevel = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(stopsLevel > 0.0 && dist < stopsLevel){ dist = stopsLevel; gSlAllargato++; }
   if(dist <= 0.0) return;

   double prezzoRif = (lato > 0) ? ask : bid;
   double sl = (lato > 0) ? prezzoRif - dist : prezzoRif + dist;
   sl = NormalizeDouble(sl, _Digits);

   //--- il lotto dal rischio VERO (R13)
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double rischioValuta = equity*InpRiskPercent/100.0;
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double volMin    = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double volMax    = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double volStep   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   bool   sottoMinimo = false;
   double perditaPerLotto = 0.0;
   double lotto = LottoDaRischio_Calc(rischioValuta, dist, tickSize, tickValue,
                                      volMin, volMax, volStep, sottoMinimo, perditaPerLotto);
   if(lotto <= 0.0)
     {
      Log("LOTTO NON CALCOLABILE (tick size/value o vincoli di volume assenti): nessun ordine, e il fatto e' loggato.");
      return;
     }

   if(InpModoSonda)
     {
      //--- COLLAUDO DEL PORTO (R1): si conta l'operazione che sarebbe
      //    nata, ma non si manda niente. Nessuno stato di posizione:
      //    in modo sonda l'EA non deve nemmeno simulare l'occupazione,
      //    o i GREZZI non sarebbero piu' confrontabili col passo 0.
      if(lato > 0) gOpL++; else gOpS++;
      gDayTrades++;
      return;
     }

   bool ok = false;
   if(lato > 0) ok = gTrade.Buy (lotto, _Symbol, 0.0, sl, 0.0, InpTag);
   else         ok = gTrade.Sell(lotto, _Symbol, 0.0, sl, 0.0, InpTag);
   gUltimoRetcode = (int)gTrade.ResultRetcode();

   if(!ok)
     {
      gOrdiniRifiutati++;
      Log(StringFormat("ORDINE RIFIUTATO (retcode %d, %s), lotto %.2f, sl %s: NON e' un segnale mancato, e' un fill mancato. Sta in colonna.",
                       gUltimoRetcode, gTrade.ResultRetcodeDescription(), lotto, DoubleToString(sl, _Digits)));
      return;
     }

   ulong tk = TrovaPosizioneNostra();
   if(tk == 0)
     {
      Log("ORDINE ESEGUITO ma la posizione non si trova col nostro magic: stato incoerente, si conta come rifiuto e non si tiene nessuno stato finto.");
      gOrdiniRifiutati++;
      return;
     }

   gTicket    = tk;
   gPosLato   = lato;
   gPosBarre  = 0;
   gPosMfe    = 0.0;
   gPosMae    = 0.0;
   gPosSpaiato= gDaySpaiato;
   PositionSelectByTicket(tk);
   gPosPrezzo = PositionGetDouble(POSITION_PRICE_OPEN);
   gPosSl     = PositionGetDouble(POSITION_SL);
   gPosLotto  = PositionGetDouble(POSITION_VOLUME);
   gPosTIngr  = (datetime)PositionGetInteger(POSITION_TIME);

   //--- il RISCHIO VERO di questa operazione: quello che finisce
   //    nell'aspettativa in R e nella percentuale realizzata (R13/R14).
   double distReale = MathAbs(gPosPrezzo - gPosSl);
   gPosRischio = (tickSize > 0.0) ? (distReale/tickSize)*tickValue*gPosLotto : 0.0;
   if(gPosRischio > 0.0 && equity > 0.0)
     {
      gSommaRischioPct += 100.0*gPosRischio/equity;
      gNRischio++;
     }

   if(sottoMinimo) gLottoMinimo++;
   if(lato > 0) gOpL++; else gOpS++;
   gDayTrades++;

   //--- le due colonne che misurano la fedelta' dell'ingresso (R2/R11)
   AggiungiCampione(gCampSpread, gNSpread, spreadPts/InpPuntiPerIndice);
   if(aperturaBarra > 0.0)
      AggiungiCampione(gCampScarto, gNScarto,
                       MathAbs(PuntiIndice_Calc(gPosPrezzo - aperturaBarra, gPuntoIndice)));
  }

//+------------------------------------------------------------------+
//| LA GIORNATA SI CHIUDE IN UN SOLO POSTO. Qui crescono i contatori  |
//| giornalieri e la peggior giornata (R15).                          |
//+------------------------------------------------------------------+
void ChiudiGiornata()
  {
   if(gDayStamp == -1) return;
   if(gDaySpaiato)       gGiorniSpaiati++;
   if(gDayTettoColpito)  gGiorniTettoColpito++;
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(gEquityInizioGiorno > 0.0)
     {
      double var = 100.0*(eq - gEquityInizioGiorno)/gEquityInizioGiorno;
      if(var < gPeggiorGiornataPct) gPeggiorGiornataPct = var;
     }
  }

//==================================================================
//  LA VALUTAZIONE DELLA BARRA CHIUSA
//  Lo scheletro e' quello della sonda, passo per passo, perche' e'
//  l'unico modo di poter dire che questo EA "fa quello che il passo
//  0 ha misurato". Dove cambia, cambia perche' ci sono ordini veri.
//==================================================================
void ValutaBarraChiusa()
  {
   int n = InpWarmupBarre;

   //--- 1) LA GAMBA. shift 1 = ultima barra CHIUSA: si copiano n barre
   //    che finiscono li'. L'indice n-1 e' la barra di segnale.
   double   high[], low[], close[];
   datetime ty[];
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);
   ArraySetAsSeries(ty,    false);
   if(CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)  != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)   != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close) != n ||
      CopyTime (_Symbol, PERIOD_CURRENT, 1, n, ty)    != n)
     { gBarreSaltateDati++; return; }

   int      iSeg = n - 1;
   datetime tSeg = ty[iSeg];
   if(tSeg <= 0){ gBarreSaltateDati++; return; }

   MqlDateTime ts; TimeToStruct(tSeg, ts);
   bool inSeg = InFinestra_Calc(ts.hour, ts.min, InpOraInizioServer, InpMinInizioServer,
                                InpOraFineServer, InpMinFineServer);

   //--- 1-bis) LO STOP PUO' AVER CHIUSO LA POSIZIONE FRA DUE BARRE.
   //    E' la differenza piu' importante rispetto alla sonda: li' non
   //    esisteva nessuno stop, qui il broker puo' aver chiuso mentre
   //    noi non guardavamo. Si verifica SEMPRE, prima di ogni altra
   //    cosa: uno stato di posizione che non esiste piu' farebbe
   //    contare barre di tenuta a una posizione morta.
   if(gTicket != 0 && !InpModoSonda)
     {
      if(TrovaPosizioneNostra() != gTicket)
         RegistraChiusura(2);          // sparita fra due barre = STOP
     }

   //--- 2) FUORI SESSIONE non si valuta niente, e NESSUNO STATO
   //    ATTRAVERSA LA NOTTE: il flat di fine sessione e' il
   //    contenitore VERO della misura del passo 0 (R6).
   if(!inSeg)
     {
      gBarreFuoriFinestra++;
      if(gTicket != 0) ChiudiPosizione(3);
      return;
     }

   //--- il prezzo e il tempo della barra appena nata: e' li' che si
   //    entra e si esce (R2).
   double   apProssima = iOpen(_Symbol, PERIOD_CURRENT, 0);
   datetime tProssima  = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(apProssima <= 0.0 || tProssima <= 0){ gBarreSaltateDati++; return; }

   bool contiguaIngr = false;
   bool inIngr = IngressoInFinestra_Calc(tSeg, tProssima, gTfSec,
                                         InpOraInizioServer, InpMinInizioServer,
                                         InpOraFineServer,   InpMinFineServer,
                                         contiguaIngr);

   gBarreValutate++;

   //--- 3) LA GIORNATA. Il denominatore e' fatto dai giorni con almeno
   //    una barra valutata DENTRO la finestra: un festivo senza barre
   //    non e' un giorno in cui il motore "non ha trovato occasioni",
   //    e' un giorno chiuso.
   int stamp = ts.year*1000 + ts.day_of_year;
   if(stamp != gDayStamp)
     {
      ChiudiGiornata();
      gDayStamp = stamp;
      gDaySpaiato = false;
      gDayTettoColpito = false;
      gDayTrades = 0;
      gEquityInizioGiorno = AccountInfoDouble(ACCOUNT_EQUITY);
      gGiorniContati++;
     }

   //--- 4) IL METRO E IL SUO ALLINEAMENTO. Si chiedono le barre del
   //    metro NELLO STESSO INTERVALLO DI TEMPO della coda della gamba
   //    -- non "le ultime n del metro", che sarebbero un altro
   //    intervallo se il metro ha buchi.
   datetime tx[];
   double   cx[];
   ArraySetAsSeries(tx, false);
   ArraySetAsSeries(cx, false);
   int nxT = CopyTime (InpSimboloMetro, PERIOD_CURRENT, ty[0], tSeg, tx);
   int nxC = CopyClose(InpSimboloMetro, PERIOD_CURRENT, ty[0], tSeg, cx);
   int nx  = (nxT > 0 && nxT == nxC) ? nxT : 0;

   int giorniMetroAttivi[];
   int nGiorniMetroAttivi = 0;
   GiorniMetroAttivi_Calc(tx, nx,
                          InpOraInizioServer, InpMinInizioServer,
                          InpOraFineServer,   InpMinFineServer,
                          giorniMetroAttivi, nGiorniMetroAttivi);

   int span    = SpanRichiesto_Calc(InpFinestraN, InpModoSpread);
   int iDaSpan = iSeg - span + 1;
   if(iDaSpan < 0) iDaSpan = 0;

   double xa[];
   bool   valido[];
   int    allineate = 0, soloMetro = 0;
   if(!AllineaSerie_Calc(ty, n, tx, cx, nx, iDaSpan, xa, valido, allineate, soloMetro))
     { gBarreSaltateDati++; return; }

   bool ultimaValida = valido[iSeg];
   if(!ultimaValida)
     {
      gMetroMancantiUltima++;
      //--- se il metro non ha MAI quotato quel giorno dentro la nostra
      //    finestra, il suo mercato era chiuso: e' festivita' propria,
      //    non un buco del feed, e non marca il giorno come spaiato.
      if(GiornoMetroAttivo_Calc(giorniMetroAttivi, nGiorniMetroAttivi, stamp))
         gDaySpaiato = true;
     }
   if(soloMetro > 0){ gValutazioniSoloMetro++; gDaySpaiato = true; }

   //--- L'ALLINEAMENTO SI PRETENDE SU TUTTO LO SPAN, non solo sulla
   //    barra di segnale: un buco dentro la finestra farebbe calcolare
   //    media e deviazione su barre di ORE DIVERSE. Il numero
   //    uscirebbe, e sarebbe finto.
   bool spanOk = (span > 0 && iSeg - span + 1 >= 0);
   if(spanOk)
     {
      for(int k = iSeg - span + 1; k <= iSeg; k++)
        {
         if(!valido[k])
           {
            spanOk = false;
            MqlDateTime tk; TimeToStruct(ty[k], tk);
            if(GiornoMetroAttivo_Calc(giorniMetroAttivi, nGiorniMetroAttivi, tk.year*1000 + tk.day_of_year))
               gDaySpaiato = true;
           }
        }
     }
   if(!spanOk && ultimaValida) gValutazioniPerseBuco++;

   //--- 5) L'ATR. Qui NON e' un eco: e' la scala dello stop (R4).
   double tr[], atr[];
   double atrSeg = 0.0;
   if(TrSerie_Calc(high, low, close, n, tr) &&
      AtrSerie_Calc(tr, n, InpAtrPeriod, InpAtrModoRma, atr))
      atrSeg = atr[iSeg];
   if(atrSeg > 0.0) AggiungiCampione(gCampAtr, gNAtr, PuntiIndice_Calc(atrSeg, gPuntoIndice));

   //--- 6) LO Z-SCORE delle due ultime barre allineate.
   double z = 0.0, zPrec = 0.0;
   bool   zOk = false;
   if(spanOk)
     {
      zOk = ZDueBarre_Calc(close, xa, n, iSeg, InpFinestraN, InpModoSpread, InpModoZScore, z, zPrec);
      if(!zOk) gZNonCalcolabile++;
     }

   //--- 7) LA POSIZIONE VIVA: escursione e uscite.
   if(gTicket != 0)
     {
      gPosBarre++;
      AggiornaEscursione_Calc(gPosLato, gPosPrezzo, high[iSeg], low[iSeg], gPuntoIndice, gPosMfe, gPosMae);

      //--- la convergenza ha la precedenza sul tetto: e' successa
      //    DENTRO la barra chiusa, il tetto scatterebbe dopo.
      if(zOk && Convergenza_Calc(z, InpSogliaUscitaSigma, gPosLato)) ChiudiPosizione(1);
      else if(gPosBarre >= InpBarreMaxTenuta)                        ChiudiPosizione(4);
     }

   //--- 8) GLI INGRESSI. Senza z non esiste attraversamento.
   if(!zOk) return;

   bool crossL = Attraversamento_Calc(zPrec, z, InpSogliaIngressoSigma, +1);
   bool crossS = Attraversamento_Calc(zPrec, z, InpSogliaIngressoSigma, -1);
   if(!crossL && !crossS) return;

   //--- I GREZZI SI CONTANO SEMPRE, PRIMA DI OGNI FILTRO: sono il
   //    numero che deve combaciare ALLA CIFRA col passo 0 (R1). Se si
   //    contassero dopo un filtro non sarebbero piu' confrontabili.
   if(crossL) gGrezziL++;
   if(crossS) gGrezziS++;

   int lato = (crossL ? +1 : -1);

   if(InpLato == 1 && lato < 0){ gSoppLato++; return; }
   if(InpLato == 2 && lato > 0){ gSoppLato++; return; }

   //--- UNA POSIZIONE PER VOLTA (R8)
   if(gTicket != 0){ gSoppPosizione++; return; }

   //--- IL TETTO GIORNALIERO (R7)
   if(InpMaxTradesPerDay > 0 && gDayTrades >= InpMaxTradesPerDay)
     { gSoppTetto++; gDayTettoColpito = true; return; }

   //--- il filtro dei giorni spaiati esiste ma nasce SPENTO (R12)
   if(InpSaltaGiorniSpaiati && gDaySpaiato){ gSoppSpaiato++; return; }

   //--- la barra d'INGRESSO deve cadere ancora dentro la finestra: un
   //    ingresso che nasce gia' oltre il flat non e' eseguibile.
   if(!inIngr){ gSoppFuoriFinestra++; return; }

   ApriPosizione(lato, atrSeg, apProssima);
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit, prima di qualunque barra e di qualunque ordine.
//  Il numero di blocchi FALLITI e di blocchi ESEGUITI finisce nelle
//  colonne: -1 vuol dire NON ESEGUITO, che non e' "passato".
//  Ogni valore atteso e' calcolato A MANO nel commento: un test che
//  copia il risultato del codice non prova niente.
//==================================================================
void AutoTestRelativo()
  {
   int falliti = 0;
   int blocchi = 0;

   //--- BLOCCO 1: SmaFin_Calc, valore e DOMINIO.
   //    v = [1,2,3,4,5]: sma(fine 4, 3) = (3+4+5)/3 = 4; sma(fine 2,3) = 2.
   blocchi++;
   double a1_v[]; ArrayResize(a1_v,5);
   a1_v[0]=1.0; a1_v[1]=2.0; a1_v[2]=3.0; a1_v[3]=4.0; a1_v[4]=5.0;
   double a1_o1=0.0, a1_o2=0.0, a1_o3=0.0;
   bool   a1_k1 = SmaFin_Calc(a1_v, 5, 4, 3, a1_o1);
   bool   a1_k2 = SmaFin_Calc(a1_v, 5, 2, 3, a1_o2);
   bool   a1_k3 = SmaFin_Calc(a1_v, 5, 1, 3, a1_o3);   // sborda -> false
   if(!a1_k1 || !a1_k2 || a1_k3 ||
      MathAbs(a1_o1-4.0)>0.0001 || MathAbs(a1_o2-2.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 1 SmaFin_Calc DIVERGE"); }

   //--- BLOCCO 2: StdevFin_Calc di POPOLAZIONE.
   //    [3,4,5]: media 4, scarti -1,0,1 -> sqrt(2/3) = 0,8164966.
   blocchi++;
   double a2_o1=0.0, a2_o2=0.0;
   bool   a2_k1 = StdevFin_Calc(a1_v, 5, 4, 3, a2_o1);
   bool   a2_k2 = StdevFin_Calc(a1_v, 5, 4, 1, a2_o2);   // 0, true
   if(!a2_k1 || !a2_k2 || MathAbs(a2_o1-0.8164966)>0.0001 || MathAbs(a2_o2)>0.0000001)
     { falliti++; Log("[AUTOTEST] 2 StdevFin_Calc DIVERGE"); }

   //--- BLOCCO 3: MedianaOrdinata_Calc, dispari e pari.
   //    [1,2,3] -> 2 ; [1,2,3,4] -> 2,5.
   blocchi++;
   double a3_d[]; ArrayResize(a3_d,3); a3_d[0]=1.0; a3_d[1]=2.0; a3_d[2]=3.0;
   double a3_p[]; ArrayResize(a3_p,4); a3_p[0]=1.0; a3_p[1]=2.0; a3_p[2]=3.0; a3_p[3]=4.0;
   if(MathAbs(MedianaOrdinata_Calc(a3_d,3)-2.0)>0.0001 ||
      MathAbs(MedianaOrdinata_Calc(a3_p,4)-2.5)>0.0001)
     { falliti++; Log("[AUTOTEST] 3 MedianaOrdinata_Calc DIVERGE"); }

   //--- BLOCCO 4: MadFin_Calc.
   //    [1,2,3,4,100] mediana 3; scarti |1-3|,|2-3|,|3-3|,|4-3|,|100-3| =
   //    2,1,0,1,97 -> ordinati 0,1,1,2,97 -> MAD = 1.
   blocchi++;
   double a4_v[]; ArrayResize(a4_v,5);
   a4_v[0]=1.0; a4_v[1]=2.0; a4_v[2]=3.0; a4_v[3]=4.0; a4_v[4]=100.0;
   double a4_med=0.0, a4_mad=0.0;
   bool   a4_k = MadFin_Calc(a4_v, 5, 4, 5, a4_med, a4_mad);
   if(!a4_k || MathAbs(a4_med-3.0)>0.0001 || MathAbs(a4_mad-1.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 4 MadFin_Calc DIVERGE"); }

   //--- BLOCCO 5: Rapporto_Calc e il guardiano su x <= 0.
   blocchi++;
   double a5_o=0.0;
   bool   a5_k1 = Rapporto_Calc(10.0, 4.0, a5_o);
   bool   a5_k2 = Rapporto_Calc(10.0, 0.0, a5_o);
   if(!a5_k1 || a5_k2 || MathAbs(a5_o-2.5)>0.0001)
     { falliti++; Log("[AUTOTEST] 5 Rapporto_Calc DIVERGE"); }

   //--- BLOCCO 6: Attraversamento_Calc, ed e' il cuore del segnale.
   //    long: si attraversa solo se z ERA >= -soglia e ORA e' < -soglia.
   blocchi++;
   bool a6_l1 = Attraversamento_Calc( 0.0, -1.5, 1.0, +1);  // si
   bool a6_l2 = Attraversamento_Calc(-1.2, -1.5, 1.0, +1);  // era gia' sotto -> no
   bool a6_l3 = Attraversamento_Calc(-1.0, -1.5, 1.0, +1);  // bordo zPrec = -soglia -> si
   bool a6_l4 = Attraversamento_Calc( 0.0, -1.0, 1.0, +1);  // z fermo SULLA soglia -> no
   bool a6_s1 = Attraversamento_Calc( 0.0,  1.5, 1.0, -1);  // si
   bool a6_s2 = Attraversamento_Calc( 1.2,  1.5, 1.0, -1);  // no
   bool a6_z  = Attraversamento_Calc( 0.0, -1.5, 0.0, +1);  // soglia nulla -> no
   bool a6_n  = Attraversamento_Calc( 0.0, -1.5, 1.0,  0);  // lato assente -> no
   if(!a6_l1 || a6_l2 || !a6_l3 || a6_l4 || !a6_s1 || a6_s2 || a6_z || a6_n)
     { falliti++; Log("[AUTOTEST] 6 Attraversamento_Calc DIVERGE"); }

   //--- BLOCCO 7: Convergenza_Calc, bordo incluso.
   blocchi++;
   bool a7_l1 = Convergenza_Calc(-0.04, 0.05, +1);  // rientrato
   bool a7_l2 = Convergenza_Calc(-0.06, 0.05, +1);  // ancora fuori
   bool a7_l3 = Convergenza_Calc(-0.05, 0.05, +1);  // bordo incluso
   bool a7_l4 = Convergenza_Calc( 2.00, 0.05, +1);  // ha sfondato dall'altra parte
   bool a7_s1 = Convergenza_Calc( 0.04, 0.05, -1);
   bool a7_s2 = Convergenza_Calc( 0.06, 0.05, -1);
   bool a7_n  = Convergenza_Calc( 0.00, 0.05,  0);
   if(!a7_l1 || a7_l2 || !a7_l3 || !a7_l4 || !a7_s1 || a7_s2 || a7_n)
     { falliti++; Log("[AUTOTEST] 7 Convergenza_Calc DIVERGE"); }

   //--- BLOCCO 8: InFinestra_Calc, inizio INCLUSO e fine ESCLUSA.
   //    14:30 dentro, 14:29 fuori, 21:59 dentro, 22:00 FUORI.
   blocchi++;
   bool a8_a = InFinestra_Calc(14,30,14,30,22,0);
   bool a8_b = InFinestra_Calc(14,29,14,30,22,0);
   bool a8_c = InFinestra_Calc(21,59,14,30,22,0);
   bool a8_d = InFinestra_Calc(22, 0,14,30,22,0);
   bool a8_e = InFinestra_Calc(23, 0,22, 0, 2,0);   // a cavallo della mezzanotte
   bool a8_f = InFinestra_Calc(12, 0,14,30,14,30);  // finestra nulla
   if(!a8_a || a8_b || !a8_c || a8_d || !a8_e || a8_f)
     { falliti++; Log("[AUTOTEST] 8 InFinestra_Calc DIVERGE"); }

   //--- BLOCCO 9: SpanRichiesto_Calc. n=40 -> 81 (modo 0), 121 (modo 1).
   blocchi++;
   if(SpanRichiesto_Calc(40,0) != 81 || SpanRichiesto_Calc(40,1) != 121 ||
      SpanRichiesto_Calc(0,0)  != 0)
     { falliti++; Log("[AUTOTEST] 9 SpanRichiesto_Calc DIVERGE"); }

   //--- BLOCCO 10: TrSerie_Calc + AtrSerie_Calc (SMA del TR).
   //    high 2,3,4 | low 1,2,3 | close 1.5,2.5,3.5
   //    TR[0] = 1 ; TR[1] = max(1, |3-1.5|, |2-1.5|) = 1,5
   //    TR[2] = max(1, |4-2.5|, |3-2.5|) = 1,5 ; ATR(3) = (1+1,5+1,5)/3
   blocchi++;
   double a10_h[]; ArrayResize(a10_h,3); a10_h[0]=2.0; a10_h[1]=3.0; a10_h[2]=4.0;
   double a10_l[]; ArrayResize(a10_l,3); a10_l[0]=1.0; a10_l[1]=2.0; a10_l[2]=3.0;
   double a10_c[]; ArrayResize(a10_c,3); a10_c[0]=1.5; a10_c[1]=2.5; a10_c[2]=3.5;
   double a10_tr[], a10_atr[];
   bool   a10_k1 = TrSerie_Calc(a10_h, a10_l, a10_c, 3, a10_tr);
   bool   a10_k2 = AtrSerie_Calc(a10_tr, 3, 3, false, a10_atr);
   if(!a10_k1 || !a10_k2 ||
      MathAbs(a10_tr[0]-1.0)>0.0001 || MathAbs(a10_tr[1]-1.5)>0.0001 ||
      MathAbs(a10_tr[2]-1.5)>0.0001 || MathAbs(a10_atr[2]-(4.0/3.0))>0.0001)
     { falliti++; Log("[AUTOTEST] 10 TrSerie/AtrSerie DIVERGE"); }

   //--- BLOCCO 11: AggiornaEscursione_Calc, sui due lati.
   //    LONG da 100, barra high 105 low 98, punto indice 1:
   //    MFE 5, MAE 2. SHORT stessa barra: MFE 2, MAE 5.
   blocchi++;
   double a11_mfe=0.0, a11_mae=0.0;
   AggiornaEscursione_Calc(+1, 100.0, 105.0, 98.0, 1.0, a11_mfe, a11_mae);
   double a11_mfe2=0.0, a11_mae2=0.0;
   AggiornaEscursione_Calc(-1, 100.0, 105.0, 98.0, 1.0, a11_mfe2, a11_mae2);
   if(MathAbs(a11_mfe-5.0)>0.0001 || MathAbs(a11_mae-2.0)>0.0001 ||
      MathAbs(a11_mfe2-2.0)>0.0001 || MathAbs(a11_mae2-5.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 11 AggiornaEscursione_Calc DIVERGE"); }

   //--- BLOCCO 12: LottoDaRischio_Calc, ED E' IL BLOCCO CHE PROTEGGE
   //    IL CONTO. rischio 650, distanza 47,1 in prezzo (=4710 punti),
   //    tickSize 0,01 tickValue 0,01 -> perdita per lotto =
   //    (47,1/0,01)*0,01 = 47,1 -> teorico 13,80 -> step 0,01 -> 13,80.
   blocchi++;
   bool   a12_min=false; double a12_ppl=0.0;
   double a12_lot = LottoDaRischio_Calc(650.0, 47.1, 0.01, 0.01, 0.01, 100.0, 0.01, a12_min, a12_ppl);
   //    e il caso che conta davvero: rischio piccolissimo -> sotto il
   //    minimo -> si usa il minimo E LO SI DICHIARA (R13).
   bool   a12_min2=false; double a12_ppl2=0.0;
   double a12_lot2 = LottoDaRischio_Calc(0.10, 47.1, 0.01, 0.01, 0.01, 100.0, 0.01, a12_min2, a12_ppl2);
   //    e i domini: distanza nulla, tick value nullo -> 0, mai un lotto
   bool   a12_min3=false; double a12_ppl3=0.0;
   double a12_lot3 = LottoDaRischio_Calc(650.0, 0.0, 0.01, 0.01, 0.01, 100.0, 0.01, a12_min3, a12_ppl3);
   double a12_lot4 = LottoDaRischio_Calc(650.0, 47.1, 0.01, 0.0, 0.01, 100.0, 0.01, a12_min3, a12_ppl3);
   if(MathAbs(a12_lot-13.80)>0.0001 || a12_min ||
      MathAbs(a12_ppl-47.1)>0.0001 ||
      MathAbs(a12_lot2-0.01)>0.0001 || !a12_min2 ||
      a12_lot3 != 0.0 || a12_lot4 != 0.0)
     { falliti++; Log("[AUTOTEST] 12 LottoDaRischio_Calc DIVERGE"); }

   //--- BLOCCO 13: PuntiIndice_Calc, con la conversione MISURATA.
   //    100 punti MT5 = 1 punto indice: su un simbolo a 2 decimali
   //    _Point vale 0,01 e il punto indice in prezzo vale 1,00.
   blocchi++;
   if(MathAbs(PuntiIndice_Calc(47.1, 1.0)-47.1)>0.0001 ||
      MathAbs(PuntiIndice_Calc(47.1, 0.0))>0.0001)
     { falliti++; Log("[AUTOTEST] 13 PuntiIndice_Calc DIVERGE"); }

   //--- BLOCCO 14: AllineaSerie_Calc -- il buco NON si riempie.
   //    gamba t = 10,20,30 ; metro t = 10,30 (manca il 20).
   //    Attesi: valido = [true,false,true], allineate 2, soloMetro 0.
   blocchi++;
   datetime a14_ty[]; ArrayResize(a14_ty,3); a14_ty[0]=10; a14_ty[1]=20; a14_ty[2]=30;
   datetime a14_tx[]; ArrayResize(a14_tx,2); a14_tx[0]=10; a14_tx[1]=30;
   double   a14_cx[]; ArrayResize(a14_cx,2); a14_cx[0]=1.0; a14_cx[1]=3.0;
   double   a14_xa[]; bool a14_val[];
   int      a14_all=0, a14_solo=0;
   bool     a14_k = AllineaSerie_Calc(a14_ty, 3, a14_tx, a14_cx, 2, 0, a14_xa, a14_val, a14_all, a14_solo);
   if(!a14_k || a14_all != 2 || a14_solo != 0 ||
      !a14_val[0] || a14_val[1] || !a14_val[2] ||
      MathAbs(a14_xa[0]-1.0)>0.0001 || MathAbs(a14_xa[2]-3.0)>0.0001 ||
      MathAbs(a14_xa[1])>0.0001)
     { falliti++; Log("[AUTOTEST] 14 AllineaSerie_Calc DIVERGE"); }

   //--- BLOCCO 15: AllineaSerie_Calc, il caso OPPOSTO (solo metro).
   //    gamba t = 10,30 ; metro t = 10,20,30 -> soloMetro deve valere 1.
   blocchi++;
   datetime a15_ty[]; ArrayResize(a15_ty,2); a15_ty[0]=10; a15_ty[1]=30;
   datetime a15_tx[]; ArrayResize(a15_tx,3); a15_tx[0]=10; a15_tx[1]=20; a15_tx[2]=30;
   double   a15_cx[]; ArrayResize(a15_cx,3); a15_cx[0]=1.0; a15_cx[1]=2.0; a15_cx[2]=3.0;
   double   a15_xa[]; bool a15_val[];
   int      a15_all=0, a15_solo=0;
   bool     a15_k = AllineaSerie_Calc(a15_ty, 2, a15_tx, a15_cx, 3, 0, a15_xa, a15_val, a15_all, a15_solo);
   if(!a15_k || a15_all != 2 || a15_solo != 1)
     { falliti++; Log("[AUTOTEST] 15 AllineaSerie_Calc (solo metro) DIVERGE"); }

   //--- BLOCCO 16: GiorniMetroAttivi_Calc + GiornoMetroAttivo_Calc.
   //    Due barre dentro la finestra (2024-01-02 15:00 e 16:00) e una
   //    fuori (03:00 del 03): il giorno 3 NON deve risultare attivo.
   blocchi++;
   datetime a16_tx[]; ArrayResize(a16_tx,3);
   a16_tx[0] = StringToTime("2024.01.02 15:00");
   a16_tx[1] = StringToTime("2024.01.02 16:00");
   a16_tx[2] = StringToTime("2024.01.03 03:00");
   int a16_g[]; int a16_n=0;
   GiorniMetroAttivi_Calc(a16_tx, 3, 14, 30, 22, 0, a16_g, a16_n);
   MqlDateTime a16_d2; TimeToStruct(a16_tx[0], a16_d2);
   MqlDateTime a16_d3; TimeToStruct(a16_tx[2], a16_d3);
   bool a16_k2 = GiornoMetroAttivo_Calc(a16_g, a16_n, a16_d2.year*1000 + a16_d2.day_of_year);
   bool a16_k3 = GiornoMetroAttivo_Calc(a16_g, a16_n, a16_d3.year*1000 + a16_d3.day_of_year);
   if(a16_n != 1 || !a16_k2 || a16_k3)
     { falliti++; Log("[AUTOTEST] 16 GiorniMetroAttivi/GiornoMetroAttivo DIVERGE"); }

   //--- BLOCCO 17: IngressoInFinestra_Calc -- il gate sulla barra REALE.
   //    tSeg 21:50, tf 300 s: la barra teorica e' 21:55 (DENTRO). Se la
   //    barra REALE e' 22:05 (buco dello storico) il gate deve dire NO,
   //    ed e' esattamente il difetto che il passo 0 ha corretto.
   blocchi++;
   datetime a17_seg = StringToTime("2024.01.02 21:50");
   datetime a17_ok  = StringToTime("2024.01.02 21:55");
   datetime a17_ko  = StringToTime("2024.01.02 22:05");
   bool a17_c1=false, a17_c2=false, a17_c3=false;
   bool a17_r1 = IngressoInFinestra_Calc(a17_seg, a17_ok, 300, 14,30,22,0, a17_c1);
   bool a17_r2 = IngressoInFinestra_Calc(a17_seg, a17_ko, 300, 14,30,22,0, a17_c2);
   bool a17_r3 = IngressoInFinestra_Calc(a17_seg, a17_seg,300, 14,30,22,0, a17_c3);
   if(!a17_r1 || !a17_c1 || a17_r2 || a17_c2 || a17_r3)
     { falliti++; Log("[AUTOTEST] 17 IngressoInFinestra_Calc DIVERGE"); }

   //--- BLOCCO 18: ZDueBarre_Calc su una serie COSTRUITA A MANO.
   //    x costante 1 -> serie = y. y costante tranne un salto finale:
   //    lo z dell'ultima barra deve essere MOLTO diverso da zero e il
   //    precedente circa zero. Non si verifica un valore esatto (che
   //    dipenderebbe da 40 medie annidate): si verifica il SEGNO e
   //    l'ordine di grandezza, che e' cio' che il motore usa.
   blocchi++;
   int a18_n = 200;
   double a18_y[]; ArrayResize(a18_y, a18_n);
   double a18_x[]; ArrayResize(a18_x, a18_n);
   for(int i = 0; i < a18_n; i++)
     {
      a18_x[i] = 1.0;
      a18_y[i] = 100.0 + ((i % 2 == 0) ? 0.10 : -0.10);   // rumore piccolo e simmetrico
     }
   a18_y[a18_n-1] = 108.0;                                 // il salto
   double a18_z=0.0, a18_zp=0.0;
   bool   a18_k = ZDueBarre_Calc(a18_y, a18_x, a18_n, a18_n-1, 10, 0, 0, a18_z, a18_zp);
   if(!a18_k || a18_z <= 2.0 || MathAbs(a18_zp) > 2.0)
     { falliti++; Log("[AUTOTEST] 18 ZDueBarre_Calc DIVERGE"); }

   //--- BLOCCO 19: ZDueBarre_Calc rifiuta la coda troppo corta.
   //    Con finestra 40 servono 81 barre: con 50 deve dire NO, non
   //    inventare un numero su meno dati.
   blocchi++;
   bool a19_k = ZDueBarre_Calc(a18_y, a18_x, 50, 49, 40, 0, 0, a18_z, a18_zp);
   if(a19_k)
     { falliti++; Log("[AUTOTEST] 19 ZDueBarre_Calc non rifiuta la coda corta"); }

   //--- BLOCCO 20: Mediana e Percentile sui campioni.
   //    [1..10]: mediana 5,5 ; P95 con interpolazione = 1 + 0,95*9 = 9,55.
   blocchi++;
   double a20_v[]; ArrayResize(a20_v,10);
   for(int i = 0; i < 10; i++) a20_v[i] = (double)(i+1);
   if(MathAbs(Mediana(a20_v,10)-5.5)>0.0001 ||
      MathAbs(Percentile(a20_v,10,0.95)-9.55)>0.0001 ||
      MathAbs(Mediana(a20_v,0))>0.0001)
     { falliti++; Log("[AUTOTEST] 20 Mediana/Percentile DIVERGE"); }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   Log(StringFormat("AUTOTEST: %d falliti su %d blocchi (0/%d = passato; -1 = NON eseguito).",
                    falliti, blocchi, blocchi));
  }

//==================================================================
//  ONINIT / ONDEINIT / ONTICK
//==================================================================
int OnInit()
  {
   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una corsa che misura un'altra
   //    cosa da quella scritta nel file prova.
   if(InpSimboloMetro == "" || InpSimboloMetro == _Symbol)
     {
      Print("ERRORE: InpSimboloMetro deve essere un simbolo DIVERSO da quello del grafico. Il metro si legge, la gamba si scambia: se coincidono il rapporto vale 1 e non esiste nessun segnale.");
      return(INIT_FAILED);
     }
   if(InpModoSpread != 0 && InpModoSpread != 1)
     { Print("ERRORE: InpModoSpread ammette solo 0 (rapporto) o 1 (beta OLS)."); return(INIT_FAILED); }
   if(InpModoZScore != 0 && InpModoZScore != 1)
     { Print("ERRORE: InpModoZScore ammette solo 0 (media/deviazione) o 1 (mediana/MAD)."); return(INIT_FAILED); }
   if(InpFinestraN < 5 || InpFinestraN > 200)
     { Print("ERRORE: InpFinestraN deve stare fra 5 e 200."); return(INIT_FAILED); }
   if(InpSogliaIngressoSigma <= 0.0 || InpSogliaIngressoSigma > 5.0)
     { Print("ERRORE: InpSogliaIngressoSigma deve stare fra 0 (escluso) e 5,0 sigma."); return(INIT_FAILED); }
   if(InpSogliaUscitaSigma < 0.0 || InpSogliaUscitaSigma >= InpSogliaIngressoSigma)
     { Print("ERRORE: InpSogliaUscitaSigma deve stare fra 0 e la soglia d'ingresso (esclusa): altrimenti l'uscita scatterebbe nello stesso istante dell'ingresso."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23 || InpOraFineServer < 0 || InpOraFineServer > 23 ||
      InpMinInizioServer < 0 || InpMinInizioServer > 59 || InpMinFineServer < 0 || InpMinFineServer > 59)
     { Print("ERRORE: la finestra deve stare in ore 0-23 e minuti 0-59, ed e' ORA SERVER (BCM = ora italiana - 1)."); return(INIT_FAILED); }
   if(InpOraInizioServer*60 + InpMinInizioServer == InpOraFineServer*60 + InpMinFineServer)
     { Print("ERRORE: finestra nulla (inizio uguale a fine)."); return(INIT_FAILED); }
   if(InpAtrSL <= 0.0 || InpAtrSL > 20.0)
     { Print("ERRORE: InpAtrSL deve stare fra 0 (escluso) e 20 ATR. E' lo STOP REALE: senza, la posizione sarebbe nuda."); return(INIT_FAILED); }
   if(InpRiskPercent <= 0.0 || InpRiskPercent > 5.0)
     { Print("ERRORE: InpRiskPercent deve stare fra 0 (escluso) e 5,0%. La taglia di campo di questa casa e' 0,65%."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay < 0 || InpMaxTradesPerDay > 100)
     { Print("ERRORE: InpMaxTradesPerDay deve stare fra 0 (nessun tetto) e 100."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay == 0)
      Print("ATTENZIONE: InpMaxTradesPerDay = 0 = NESSUN TETTO. Il passo 0 ha misurato fino a 10 occasioni al giorno: 10 x 0,65% = -6,50%, che SFONDA il muro prop giornaliero del 5%. Il tetto e' una scelta di rischio, non una preferenza.");
   if(InpBarreMaxTenuta < 1 || InpBarreMaxTenuta > 5000)
     { Print("ERRORE: InpBarreMaxTenuta deve stare fra 1 e 5000."); return(INIT_FAILED); }
   if(InpLato < 0 || InpLato > 2)
     { Print("ERRORE: InpLato ammette 0 (entrambi), 1 (solo long) o 2 (solo short)."); return(INIT_FAILED); }
   if(InpPuntiPerIndice <= 0.0)
     { Print("ERRORE: InpPuntiPerIndice deve essere > 0 (misurato = 100 su U30USD/NASUSD/D30EUR)."); return(INIT_FAILED); }
   if(InpAtrPeriod < 2)
     { Print("ERRORE: InpAtrPeriod deve essere >= 2."); return(INIT_FAILED); }
   if(InpMagic == 0)
     { Print("ERRORE: InpMagic = 0 renderebbe l'EA indistinguibile da un ordine manuale, e su conto HEDGING questo e' il difetto che chiude le posizioni dei vicini."); return(INIT_FAILED); }

   //--- la coda deve bastare allo z-score PIU' un margine vero
   int minimo = SpanRichiesto_Calc(InpFinestraN, InpModoSpread) + InpAtrPeriod + 40;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con finestra %d e modo spread %d servono almeno %d barre.",
                  InpWarmupBarre, InpFinestraN, InpModoSpread, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 3000)
     { Print("ERRORE: InpWarmupBarre sopra 3000 rallenta la corsa senza guadagnare precisione."); return(INIT_FAILED); }

   //--- conversione in punti indice, e la si DICHIARA subito
   gPuntoIndice = InpPuntiPerIndice*_Point;
   if(gPuntoIndice <= 0.0)
     { Print("ERRORE: punto indice non calcolabile (SYMBOL_POINT nullo)."); return(INIT_FAILED); }
   if(MathAbs(gPuntoIndice - 1.0) > 0.001)
      Print(StringFormat("ATTENZIONE: il punto indice vale %.5f in prezzo, NON 1,00. Sui tre indici deve venire 1,00: se non viene, MFE, MAE e la scala dello STOP escono sbagliati di un fattore. Controllare InpPuntiPerIndice PRIMA di leggere qualunque numero.", gPuntoIndice));

   //--- lo spread ATTESO del simbolo, dalla tabella MISURATA. Qui NON
   //    ferma la corsa (non e' un cancello, R10): serve a leggere la
   //    colonna misurata contro un riferimento e a dire subito se il
   //    simbolo scambiato non e' uno di quelli misurati.
   gSpreadAtteso = 0.0;
   if(_Symbol == "D30EUR") gSpreadAtteso = ABR_SPREAD_D30EUR;
   if(_Symbol == "NASUSD") gSpreadAtteso = ABR_SPREAD_NASUSD;
   if(_Symbol == "U30USD") gSpreadAtteso = ABR_SPREAD_U30USD;
   if(gSpreadAtteso <= 0.0)
      Print(StringFormat("ATTENZIONE: lo spread di %s NON e' nella tabella MISURATA (D30EUR / NASUSD / U30USD, SPREAD_FLOTTA del 03/09/2026). La colonna dello spread all'ingresso esce lo stesso, ma non c'e' un atteso contro cui leggerla.", _Symbol));

   gTfSec = PeriodSeconds(PERIOD_CURRENT);
   if(gTfSec <= 0)
     { Print("ERRORE: durata del timeframe non leggibile."); return(INIT_FAILED); }

   //--- IL METRO IN MARKET WATCH. Senza, nel tester il secondo simbolo
   //    semplicemente non esiste e ogni barra risulterebbe "spaiata":
   //    un errore di configurazione travestito da misura.
   if(!SymbolSelect(InpSimboloMetro, true))
     {
      PrintFormat("ERRORE: il simbolo METRO '%s' non e' selezionabile (errore %d). Nel tester va scaricato lo storico del SECONDO simbolo PRIMA della corsa.",
                  InpSimboloMetro, GetLastError());
      return(INIT_FAILED);
     }

   //--- CTrade: magic, tolleranza di riempimento, modo di riempimento
   //    scelto sulle capacita' DICHIARATE dal simbolo (non assunto).
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(InpSlippagePts);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetAsyncMode(false);
   gTrade.LogLevel(LOG_LEVEL_ERRORS);

   //--- lo stato riparte da zero, sempre
   gLastBar = 0; gTicket = 0; gPosLato = 0; gPosBarre = 0;
   gPosMfe = 0.0; gPosMae = 0.0; gPosRischio = 0.0; gPosSpaiato = false;
   gDayStamp = -1; gDayTrades = 0; gDaySpaiato = false; gDayTettoColpito = false;
   gEquityInizioGiorno = AccountInfoDouble(ACCOUNT_EQUITY);
   gPeggiorGiornataPct = 0.0;
   gTroncato = false;

   if(InpAutoTest) AutoTestRelativo();

   //--- il CSV riga-per-operazione esiste SOLO fuori ottimizzazione:
   //    in ottimizzazione le passate si sovrascriverebbero a vicenda.
   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string f = StringFormat("Operazioni_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
      gCsvOp = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
      if(gCsvOp != INVALID_HANDLE)
         FileWrite(gCsvOp, "tempo_ingresso","lato","lotto","prezzo_ingresso","prezzo_uscita","sl",
                   "motivo_uscita_1conv_2stop_3flat_4tetto_5finecorsa","barre","mfe_idx","mae_idx",
                   "guadagno_idx","profitto_valuta","rischio_valuta","giorno");
      else
         Print("ATTENZIONE: CSV riga-per-operazione non apribile: i numeri restano nelle colonne OPTFRAME.");
     }

   if(InpModoSonda)
      Print("MODO SONDA ACCESO: questo EA NON MANDERA' NESSUN ORDINE. E' il COLLAUDO DEL PORTO: i 'Segnali Grezzi Long/Short' devono venire IDENTICI, alla cifra, agli 'Attraversamenti Grezzi' del referto del passo 0 sulla stessa cella e sulla stessa finestra.");

   Log(StringFormat("avviato su %s %s | metro %s | cella N=%d sigma=%.2f | SL %.2f x ATR | rischio %.2f%% | tetto %d/giorno | magic %I64u",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpSimboloMetro,
                    InpFinestraN, InpSogliaIngressoSigma, InpAtrSL, InpRiskPercent,
                    InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gCsvOp != INVALID_HANDLE){ FileClose(gCsvOp); gCsvOp = INVALID_HANDLE; }
  }

void OnTick()
  {
   //--- si lavora SOLO a barra nuova: lo z-score si calcola su barre
   //    chiuse, e valutare a ogni tick vorrebbe dire leggere una barra
   //    IN FORMAZIONE, cioe' un look-ahead mascherato.
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t == gLastBar || t == 0) return;
   gLastBar = t;
   ValutaBarraChiusa();
  }

//==================================================================
//  OPTFRAME -- le colonne obbligatorie del round.
//  In backtest singolo FrameAdd e' inerte; in ottimizzazione e'
//  l'UNICO canale (MT5 non esegue le Print degli agent).
//==================================================================
string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| CONTROLLO AUTOMATICO DELL'INTESTAZIONE: conta le virgole della    |
//| testata e gli specificatori del formato e URLA se non tornano.    |
//| La trappola del CSV sfasato (colonne che non corrispondono ai     |
//| numeri) e' gia' stata pagata in casa una volta: qui e' automatica.|
//+------------------------------------------------------------------+
void ControllaColonne(const string head, const string fmt)
  {
   int virgole = 0;
   for(int i = 0; i < StringLen(head); i++) if(StringGetCharacter(head, i) == ',') virgole++;
   int spec = 0;
   for(int i = 0; i < StringLen(fmt); i++) if(StringGetCharacter(fmt, i) == '%') spec++;
   int atteso = ABR_NSTATS + 3;
   if(virgole + 1 != atteso || spec != atteso)
      PrintFormat("### CSV SFASATO ### intestazione con %d virgole (attese %d) e formato con %d specificatori (attesi %d) per ABR_NSTATS = %d. LE COLONNE NON CORRISPONDONO AI NUMERI: NON LEGGERE QUESTO CSV.",
                  virgole, atteso-1, spec, atteso, ABR_NSTATS);
  }

//+------------------------------------------------------------------+
//| La tenuta in secondi si deriva dalle BARRE valutate, non dalla    |
//| differenza di calendario: su un buco dello storico quella          |
//| differenza misura IL BUCO, non la posizione.                      |
//+------------------------------------------------------------------+
long TenutaBarreInSecondi(const double barre)
  {
   if(barre <= 0.0 || gTfSec <= 0) return(0);
   return((long)(barre*(double)gTfSec));
  }

double OnTester()
  {
   //--- LA CHIUSURA DELLA CORSA: la posizione ancora aperta si chiude
   //    col motivo 5 (FINE CORSA) ed e' un artefatto del bordo, non
   //    una convergenza mancata; l'ultima giornata si chiude a mano.
   if(gTicket != 0) ChiudiPosizione(5);
   ChiudiGiornata();
   gDayStamp = -1;

   double opTot = (double)(gOpL + gOpS);

   double s[];
   ArrayResize(s, ABR_NSTATS);
   for(int i = 0; i < ABR_NSTATS; i++) s[i] = 0.0;

   s[0]  = (double)gGrezziL;
   s[1]  = (double)gGrezziS;
   s[2]  = (double)gSoppPosizione;
   s[3]  = (double)gSoppTetto;
   s[4]  = (double)gSoppFuoriFinestra;
   s[5]  = (double)gSoppLato;
   s[6]  = (double)gSoppSpread;
   s[7]  = (double)gSoppSpaiato;
   s[8]  = (double)gOpL;
   s[9]  = (double)gOpS;
   s[10] = opTot;
   s[11] = (double)gUscConv;
   s[12] = (double)gUscStop;
   s[13] = (double)gUscFlat;
   s[14] = (double)gUscTetto;
   s[15] = (double)gUscFineCorsa;
   s[16] = (double)gUscIgnota;
   s[17] = (double)gOrdiniRifiutati;
   s[18] = (double)gUltimoRetcode;
   s[19] = (double)gGiorniContati;
   s[20] = (double)gGiorniTettoColpito;
   s[21] = (gGiorniContati > 0) ? 100.0*(double)gGiorniTettoColpito/(double)gGiorniContati : 0.0;
   s[22] = (double)gGiorniSpaiati;
   s[23] = (gGiorniContati > 0) ? 100.0*(double)gGiorniSpaiati/(double)gGiorniContati : 0.0;
   //--- LE DUE COLONNE PROMESSE SUI GIORNI SPAIATI (R12): quante
   //    operazioni sono nate in un giorno spaiato e quanto hanno reso,
   //    separate da quelle nate nei giorni puliti. Sono la MISURA del
   //    costo che il passo 0 poteva solo filtrare.
   s[24] = (double)gOpSpaiati;
   s[25] = gProfittoSpaiati;
   s[26] = gProfittoPuliti;

   double mfeMed  = Mediana(gCampMfe, gNMfe);
   double guadMed = Mediana(gCampGuadagnoVinc, gNGuadagnoVinc);
   s[27] = guadMed;
   s[28] = mfeMed;
   s[29] = Mediana(gCampMae, gNMae);
   //--- IL NUMERO DELLA PREVISIONE: guadagno realizzato per vincente
   //    diviso MFE mediana. Sotto ~0,7 la geometria non regge il costo.
   s[30] = (mfeMed > 0.0) ? guadMed/mfeMed : 0.0;
   s[31] = Mediana(gCampSpread, gNSpread);
   s[32] = Percentile(gCampSpread, gNSpread, 0.95);
   s[33] = Mediana(gCampScarto, gNScarto);
   s[34] = Percentile(gCampScarto, gNScarto, 0.95);

   double tenMed = Mediana(gCampTenuta, gNTenuta);
   s[35] = tenMed;
   s[36] = tenMed*(double)gTfSec/60.0;
   //--- vincolo prop P5. A M5 la tenuta minima e' UNA barra = 300 s:
   //    questa quota DEVE venire 0,00. Se non viene, la contabilita'
   //    delle barre e' rotta -- e' un collaudo, non una scoperta.
   long sotto60 = 0;
   for(int i = 0; i < gNTenuta; i++)
      if(TenutaBarreInSecondi(gCampTenuta[i]) < 60) sotto60++;
   s[37] = (gNTenuta > 0) ? 100.0*(double)sotto60/(double)gNTenuta : 0.0;

   s[38] = (double)gLottoMinimo;
   s[39] = (opTot > 0.0) ? 100.0*(double)gLottoMinimo/opTot : 0.0;
   s[40] = (double)gSlAllargato;
   s[41] = (gNRischio > 0) ? gSommaRischioPct/(double)gNRischio : 0.0;
   s[42] = (gNR > 0) ? gSommaR/(double)gNR : 0.0;

   s[43] = TesterStatistics(STAT_PROFIT);
   s[44] = TesterStatistics(STAT_PROFIT_FACTOR);
   s[45] = TesterStatistics(STAT_TRADES);
   double vinte = TesterStatistics(STAT_PROFIT_TRADES);
   s[46] = (s[45] > 0.0) ? 100.0*vinte/s[45] : 0.0;
   s[47] = TesterStatistics(STAT_EQUITYDD_PERCENT);
   s[48] = gPeggiorGiornataPct;

   s[49] = (double)gBarreValutate;
   s[50] = (double)gBarreFuoriFinestra;
   s[51] = (double)gBarreSaltateDati;
   s[52] = (double)gMetroMancantiUltima;
   s[53] = (double)gValutazioniPerseBuco;
   s[54] = (double)gValutazioniSoloMetro;
   s[55] = (double)gZNonCalcolabile;
   s[56] = Mediana(gCampAtr, gNAtr);
   s[57] = gPuntoIndice;
   s[58] = (double)(long)SeriesInfoInteger(InpSimboloMetro, PERIOD_CURRENT, SERIES_FIRSTDATE);
   s[59] = (double)(long)SeriesInfoInteger(_Symbol,         PERIOD_CURRENT, SERIES_FIRSTDATE);
   s[60] = (double)gAutotestFalliti;
   s[61] = (double)gAutotestBlocchi;

   //--- ECO DEI PIN: se un pin non e' passato, MT5 lo ignora IN
   //    SILENZIO e la corsa misura un'altra cella. Queste colonne sono
   //    l'unico modo di accorgersene leggendo il CSV.
   s[62] = (double)InpFinestraN;
   s[63] = InpSogliaIngressoSigma;
   s[64] = InpSogliaUscitaSigma;
   s[65] = InpAtrSL;
   s[66] = (double)InpMaxTradesPerDay;
   s[67] = InpRiskPercent;
   s[68] = (double)InpLato;
   s[69] = (double)(InpModoSonda ? 1 : 0);
   s[70] = (double)(InpSaltaGiorniSpaiati ? 1 : 0);
   s[71] = (double)InpSlippagePts;
   s[72] = (double)(long)InpMagic;

   if(gTroncato)
      Print("ATTENZIONE: CAMPIONI TRONCATI (oltre il tetto interno): le mediane NON si leggono.");

   //--- IL CRITERIO DI OTTIMIZZAZIONE: il PROFITTO NETTO. Qui non c'e'
   //    nessuna griglia da massimizzare (la cella e' congelata), quindi
   //    il criterio non seleziona niente: serve solo a far esistere il
   //    frame. Va detto, perche' un massimo in colonna prima o poi
   //    qualcuno lo legge come una promozione.
   double criterion = s[43];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, s);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   string periodo = EnumToString((ENUM_TIMEFRAMES)Period());

   //--- 76 nomi = Pass + Simbolo + Periodo + 73 valori di s[].
   string head = "Pass,Simbolo,Periodo,"
                 "Segnali Grezzi Long,Segnali Grezzi Short,"
                 "Segnali Soppressi Posizione Aperta,Segnali Soppressi Tetto Giorno,"
                 "Segnali Soppressi Ingresso Fuori Finestra,Segnali Soppressi Lato Disabilitato,"
                 "Segnali Soppressi Filtro Spread,Segnali Soppressi Giorno Spaiato,"
                 "Operazioni Long,Operazioni Short,Operazioni Totali,"
                 "Uscite Convergenza,Uscite Stop,Uscite Flat Sessione,Uscite Tetto Barre,"
                 "Uscite Fine Corsa,Uscite Ignote,"
                 "Ordini Rifiutati,Ultimo Retcode,"
                 "Giorni Contati,Giorni Col Tetto Colpito,Giorni Col Tetto Colpito Pct,"
                 "Giorni Spaiati,Giorni Spaiati Pct,"
                 "Operazioni In Giorni Spaiati,Profitto In Giorni Spaiati,Profitto Fuori Giorni Spaiati,"
                 "Guadagno Mediano Vincente Punti Indice,Mfe Mediana Punti Indice,Mae Mediana Punti Indice,"
                 "Rapporto Realizzato Su Mfe,"
                 "Spread Ingresso Mediano Punti Indice,Spread Ingresso P95 Punti Indice,"
                 "Scarto Ingresso Vs Apertura Mediano,Scarto Ingresso Vs Apertura P95,"
                 "Tenuta Mediana Barre,Tenuta Mediana Minuti,Sotto 60 Secondi Pct,"
                 "Operazioni A Lotto Minimo,Operazioni A Lotto Minimo Pct,Sl Allargato Da Stops Level,"
                 "Rischio Medio Realizzato Pct,Aspettativa In R,"
                 "Profitto Netto,Profit Factor,Operazioni Chiuse Tester,Vinte Pct,"
                 "Equity Dd Pct,Peggior Giornata Pct,"
                 "Barre Valutate,Barre Fuori Finestra,Barre Saltate Dati,"
                 "Valutazioni Metro Mancante Segnale,Valutazioni Perse Buco Finestra,"
                 "Valutazioni Con Solo Metro,Z Non Calcolabile,"
                 "Atr Mediano Punti Indice,Punto Indice Prezzo,"
                 "Metro Prima Barra Epoch,Gamba Prima Barra Epoch,"
                 "Autotest Falliti,Autotest Blocchi,"
                 "Finestra N,Soglia Ingresso Sigma,Soglia Uscita Sigma,Atr Sl Multiplo,"
                 "Max Trades Day,Risk Percent,Lato Attivo,"
                 "Modo Sonda,Salta Giorni Spaiati,Slippage Punti,Magic";

   //--- LA RIGA E' SPEZZATA IN TRE, E NON E' ESTETICA: MQL5 non accetta
   //    piu' di 64 parametri per chiamata, e qui gli argomenti sono 76.
   string fmt1 = "%d,%s,%s,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.0f,%.2f,%.0f,%.2f";
   string fmt2 = "%.2f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.4f,%.2f,%.2f,%.2f,%.0f,%.2f,%.0f,%.4f,%.4f,%.2f,%.3f,%.0f,%.2f,%.2f,%.2f,%.0f,%.0f";
   string fmt3 = "%.0f,%.0f,%.0f,%.0f,%.0f,%.4f,%.5f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.2f,%.2f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f";
   ControllaColonne(head, fmt1 + "," + fmt2 + "," + fmt3);

   while(FrameNext(pass, name, id, value, data))
     {
      if(name != OPTFRAME_NAME || id != OPTFRAME_ID) continue;
      if(ArraySize(data) < ABR_NSTATS) continue;
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string testa = head;
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) testa += "," + kv[0]; }
         FileWrite(h, testa); header_scritto = true;
        }
      string row = StringFormat(fmt1,
                                (int)pass, _Symbol, periodo,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25]);
      row += "," + StringFormat(fmt2,
                                data[26], data[27], data[28], data[29], data[30], data[31],
                                data[32], data[33], data[34], data[35], data[36], data[37],
                                data[38], data[39], data[40], data[41], data[42], data[43],
                                data[44], data[45], data[46], data[47], data[48], data[49],
                                data[50]);
      row += "," + StringFormat(fmt3,
                                data[51], data[52], data[53], data[54], data[55], data[56],
                                data[57], data[58], data[59], data[60], data[61], data[62],
                                data[63], data[64], data[65], data[66], data[67], data[68],
                                data[69], data[70], data[71], data[72]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine ==========================================//
