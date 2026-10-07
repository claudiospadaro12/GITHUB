//+------------------------------------------------------------------+
//|                                                  EA_NatCla.mq5   |
//|                                                                  |
//|  "Ea Nat&Cla" -- UN SOLO EA, tre motori scelti da InpModalita:  |
//|    AUDIO  = come opera la collega a voce (audio WA0090/91/92)    |
//|    PDF    = documento "Supertrend Reversal" (data/natcla/)       |
//|    EMA200 = motore M2 "solo EMA 200" (A-R20), scala AUDIO sulla  |
//|             EMA200 (specifica par. 3.3)                          |
//|                                                                  |
//|  REGOLE DI TRADING: SOLO da report/NATCLA_SPECIFICA_2026-10-07.md|
//|  (passata dal cancello con riserve, commit a5babcbc) e, dove la  |
//|  specifica rimanda, dalle due analisi report/NATCLA_ANALISI_*.   |
//|  Ogni punto che le fonti NON quantificano e' un INPUT con il     |
//|  default della specifica e un commento [NOSTRA]/[FONTE]/[CASA].  |
//|  Codice di struttura copiato da mql5/Experts/ABTG_Supertrend     |
//|  Reversal.mq5 (Guardian, imbuto, export per-trade, OptFrame,     |
//|  perdita per lotto con OrderCalcProfit, normalizzazione al tick):|
//|  ogni copia e' marcata [CASA] dove avviene. NESSUNA sua regola   |
//|  di trading e nessun suo valore di parametro e' entrato qui.     |
//|                                                                  |
//|  STATO: strato 1 (collaudo statico + logica pura su dati reali)  |
//|  fatto; strato 2 (controllo-preventivo 07/10): PASS CON RISERVE, |
//|  vedi report/NATCLA_CODICE_NOTE_2026-10-07.md par. 5.            |
//|  NON compilato qui (nessun MetaEditor in questo ambiente): la     |
//|  prima compilazione e il primo giro nel tester sono il collaudo  |
//|  che manca. Solo DEMO/TESTER finche' Claudio non firma.          |
//|                                                                  |
//|  MAPPA REGOLA -> CODICE (sigle della specifica, par. 1)          |
//|   I1-I3 Supertrend HL2 +/- k x ATR10 ......... NC_STCore (puro)  |
//|   I4 linee attive .......................... gUsaLinea[], Risolvi|
//|   I5 EMA200 su close ....................... hEma200             |
//|   I6 EMA14/EMA89 (target PDF) .............. NC_TpEma (puro)     |
//|   I7 EMA9/21 + Bollinger: SOLO LOG ......... ScriviRiga (CSV)    |
//|   I8 ATR14 di normalizzazione .............. hAtrN               |
//|   D1 direzione ............................. LatoAmmesso         |
//|   D2 verso del rimbalzo .................... NC_Tocco (puro)     |
//|   T1 TF (rifiuto sotto H1) ................. Risolvi             |
//|   M2 motore EMA200 ......................... NC_EmaDir (puro)    |
//|   C1-C3 tocco .............................. NC_Tocco (puro)     |
//|   C4-C6 conteggio, episodi, azzeramento .... NC_Episodi (puro)   |
//|   C7 chiusura vicina ....................... ValutaPdf           |
//|   C8 conferma all'apertura ................. ValutaPdf           |
//|   C9 timing del tocco ...................... TimingTocco         |
//|   F1-F6 filtri di contesto ................. NC_Contesto (puro)  |
//|   F7 spread massimo ........................ Contesto            |
//|   U1 unita' ................................ CalcolaUnita        |
//|   E1-E5 ingresso ........................... ArmaScala/EntraPdf  |
//|   E6 scadenza pendenti PDF ................. EntraPdf/Sincronizza|
//|   E7 setup contemporanei (semaforo) ........ Aperti/Sincronizza  |
//|   S1-S4 rischio e pesi ..................... NC_LottiSetup (puro)|
//|   X1-X4 stop comune ........................ NC_Stop (puro)      |
//|   X5-X7 take profit, R/R ................... NC_TpFisso/NC_TpEma/|
//|                                              NC_OrdineValido     |
//|   X8 parziale/pareggio al TP1 .............. GestisciTP1         |
//|   X9 durata massima ........................ Sincronizza         |
//|   X10 residui cancellati ................... Sincronizza         |
//|                                                                  |
//|  OROLOGIO: nessuna regola d'orario. Tutte le ore sono ORA SERVER |
//|  (BCM oggi UTC+1 fisso; sul forex il vecchio orologio vale fino  |
//|  al cambio fra il 26/12/2024 e il 02/02/2025: cambia solo la     |
//|  composizione delle candele H4/H12/D1, specifica par. 5.5).      |
//|  Nessun accesso alla rete, nessuna DLL, nessun #import.          |
//|  DEMO/TESTER. Nessun EA garantisce profitti.                     |
//+------------------------------------------------------------------+
#property copyright "Ea Nat&Cla - progetto Claudio (ABTG)"
#property description "Ea Nat&Cla: modo AUDIO (collega) / PDF (Supertrend Reversal) / motore solo EMA200. Specifica report/NATCLA_SPECIFICA_2026-10-07.md. Rischio 0,25% = SEGNAPOSTO da firmare da Claudio."
#property version   "1.00"
#property strict

#define NC_VER "1.00"

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//==================================================================
//  ENUM DEGLI INPUT (i valori "DA_MODALITA" si risolvono in OnInit
//  con la colonna AUDIO / PDF / EMA200 della specifica, par. 1)
//==================================================================
enum ENUM_NC_MODALITA
  {
   NC_AUDIO=0,     // AUDIO: come opera la collega (3 audio)
   NC_PDF=1,       // PDF: documento Supertrend Reversal
   NC_EMA200=2     // EMA200: motore M2 solo EMA200 (scala AUDIO)
  };
enum ENUM_NC_TRI
  {
   NC_TRI_DA_MODALITA=-1, // DA_MODALITA (default della specifica)
   NC_TRI_NO=0,           // NO
   NC_TRI_SI=1            // SI
  };
enum ENUM_NC_DIREZIONE
  {
   NC_DIR_ENTRAMBI=0, // ENTRAMBI
   NC_DIR_LONG=1,     // solo LONG
   NC_DIR_SHORT=2     // solo SHORT
  };
enum ENUM_NC_TOCCO
  {
   NC_TOCCO_RAGGIUNGE=0, // RAGGIUNGE: l'estremo raggiunge o supera la linea
   NC_TOCCO_SFIORA=1     // SFIORA: entro InpSfioraAtr x ATR dalla linea
  };
enum ENUM_NC_RESET
  {
   NC_RESET_AL_FLIP=0,            // AL_FLIP: il conteggio vive fra due flip
   NC_RESET_AL_FLIP_O_DISTACCO=1  // AL_FLIP_O_DISTACCO: azzera anche dopo un distacco
  };
enum ENUM_NC_TIMING
  {
   NC_TIMING_IGNORA=0,       // IGNORA
   NC_TIMING_PRIMA_META=1,   // PRIMA_META della candela (P-p14)
   NC_TIMING_SECONDA_META=2  // SECONDA_META della candela (P-p25)
  };
enum ENUM_NC_ADXAMB
  {
   NC_ADX_SOLO_ST35=0, // SOLO_ST35 (A-R12 detto nel paragrafo del 3.5)
   NC_ADX_TUTTE=1      // TUTTE le tre linee Supertrend
  };
enum ENUM_NC_ADXTIPO
  {
   NC_ADX_MT5=0,    // iADX di MT5 (specifica par. 2.1)
   NC_ADX_WILDER=1  // iADXWilder (asse: conteggio della specifica par. 5.4)
  };
enum ENUM_NC_INCLVERSO
  {
   NC_INCL_QUALSIASI=0, // QUALSIASI verso ("inclinata", letterale)
   NC_INCL_CONCORDE=1   // CONCORDE (su per il long, giu' per lo short)
  };
enum ENUM_NC_CONFL
  {
   NC_CONFL_DA_MODALITA=-1,  // DA_MODALITA
   NC_CONFL_SPENTA=0,        // SPENTA
   NC_CONFL_SOLO_ETICHETTA=1,// SOLO_ETICHETTA (scritta nel CSV, non filtra)
   NC_CONFL_OBBLIGATORIA=2   // OBBLIGATORIA (filtro)
  };
enum ENUM_NC_UNITA
  {
   NC_UNITA_AUTO_CLASSE=0,  // AUTO_CLASSE: forex pip, indici 1,0, oro/argento 1,0 USD
   NC_UNITA_PIP=1,          // PIP (cifre 3/5 -> 10 x Point, altrimenti Point)
   NC_UNITA_PUNTO_PREZZO=2, // PUNTO_PREZZO = 1,0 in prezzo
   NC_UNITA_PUNTO_MT5=3,    // PUNTO_MT5 = _Point (escluso per aritmetica, par. 5.3)
   NC_UNITA_MANUALE=4       // MANUALE = InpUnitaManuale (es. oro 0,1 USD)
  };
enum ENUM_NC_INGRESSO
  {
   NC_ING_DA_MODALITA=-1,        // DA_MODALITA
   NC_ING_SCALA3_PENDENTI=0,     // SCALA3_PENDENTI (audio WA0092)
   NC_ING_MERCATO_PIU_PENDENTE=1 // MERCATO_PIU_PENDENTE (PDF p17/p26)
  };
enum ENUM_NC_LONTANA
  {
   NC_LONTANA_SALTA=0,        // SALTA il setup
   NC_LONTANA_DUE_PENDENTI=1  // DUE_PENDENTI (sulla linea e oltre)
  };
enum ENUM_NC_PESI3
  {
   NC_PESI_1_1_1=0, // 1:1:1 (stessa size per tutti) - DEFAULT
   NC_PESI_1_2_1=1  // 1:2:1 BANDIERA ROSSA B1 (size piu' pesante sulla linea)
  };
enum ENUM_NC_PESI2
  {
   NC_PESI_1_1=0, // 1:1 (stessa size) - DEFAULT
   NC_PESI_1_2=1  // 1:2 BANDIERA ROSSA (2/3 contro il movimento, PDF)
  };
enum ENUM_NC_SL
  {
   NC_SL_DA_MODALITA=-1,            // DA_MODALITA
   NC_SL_ORDINE_PROFONDO_PIU_BUFFER=0, // ORDINE_PROFONDO + buffer
   NC_SL_ESTREMO_RECENTE=1,         // ESTREMO_RECENTE + buffer
   NC_SL_LINEA_PIU_BUFFER=2         // LINEA + buffer
  };
enum ENUM_NC_TP
  {
   NC_TP_DA_MODALITA=-1,         // DA_MODALITA
   NC_TP_FISSO_DALLA_LINEA=0,    // FISSO_DALLA_LINEA (WA0092)
   NC_TP_FISSO_DAL_RIEMPIMENTO=1,// FISSO_DAL_RIEMPIMENTO
   NC_TP_EMA14_POI_EMA89=2       // EMA14_POI_EMA89 (PDF p17)
  };

//==================================================================
//  INPUT
//==================================================================
input group "=== Modalita' e timeframe ==="
input ENUM_NC_MODALITA  InpModalita = NC_AUDIO;        // Modalita': AUDIO / PDF / EMA200 (motore M2)
input ENUM_TIMEFRAMES   InpTF       = PERIOD_CURRENT;  // TF del segnale. CURRENT = DA_MODALITA (AUDIO H1, PDF H4, EMA200 H1). Sotto H1 = rifiutato (A-R8/R9)
input ENUM_NC_DIREZIONE InpDirezione= NC_DIR_ENTRAMBI; // Direzione (A-R26 mai dichiarata): nei test i lati si girano SEPARATI

input group "=== Indicatori (specifica par. 1.1) ==="
input int    InpStAtrPeriodo    = 10;   // Supertrend: periodo ATR [FONTE P-p07]
input double InpStMult1         = 2.5;  // Supertrend linea 1 (2.5) [FONTE A-R2, P-p04]
input double InpStMult2         = 3.0;  // Supertrend linea 2 (3.0) [FONTE]
input double InpStMult3         = 3.5;  // Supertrend linea 3 (3.5) [FONTE]
input ENUM_NC_TRI InpUsaST25    = NC_TRI_DA_MODALITA; // Linea 2.5 genera setup (AUDIO si, PDF no, EMA200 no)
input ENUM_NC_TRI InpUsaST30    = NC_TRI_DA_MODALITA; // Linea 3.0 genera setup (AUDIO si, PDF no, EMA200 no)
input ENUM_NC_TRI InpUsaST35    = NC_TRI_DA_MODALITA; // Linea 3.5 genera setup (AUDIO si, PDF si, EMA200 no)
input int    InpEmaLentaPeriodo = 200;  // EMA lenta (EMA su close: il close e' [NOSTRA])
input int    InpEmaTp1          = 14;   // EMA del primo obiettivo PDF [FONTE P-p17]
input int    InpEmaTp2          = 89;   // EMA dell'obiettivo finale PDF [FONTE P-p17]
input bool   InpLogContesto     = true; // EMA9/EMA21/Bollinger(20,2) SOLO nel CSV: non entrano in nessuna condizione (I7)
input int    InpAtrNormPeriodo  = 14;   // ATR di normalizzazione delle tolleranze [NOSTRA, Wilder]

input group "=== Motore EMA200 (M2) ==="
input ENUM_NC_TRI InpMotoreEma200 = NC_TRI_DA_MODALITA; // Linea EMA200 genera setup (AUDIO no, PDF no, EMA200 si) [A-R20]
input int    InpTocchiMaxEma    = 0;    // Massimo tocchi sulla EMA200 (0 = illimitato)

input group "=== Tocco, conteggio, conferma (par. 1.3) ==="
input ENUM_NC_TOCCO InpToccoDef = NC_TOCCO_RAGGIUNGE; // Definizione di tocco (C1)
input double InpSfioraAtr       = 0.10; // Tolleranza di SFIORA in ATR14 [NOSTRA]
input int    InpTocchiMax25     = -1;   // Max tocchi linea 2.5 (-1 = DA_MODALITA: AUDIO 1, PDF 0; 0 = illimitato) [A-R13]
input int    InpTocchiMax30     = -1;   // Max tocchi linea 3.0 (-1 = DA_MODALITA: AUDIO 1, PDF 0) [A-R14]
input int    InpTocchiMax35     = -1;   // Max tocchi linea 3.5 (-1 = DA_MODALITA: AUDIO 2, PDF 0) [A-R11]
input ENUM_NC_RESET InpResetConteggio = NC_RESET_AL_FLIP; // Da quando si contano i tocchi (C6) [NOSTRA]
input double InpDistaccoAtr     = 1.0;  // Distacco che azzera il conteggio, in ATR14 [NOSTRA]
input double InpChiudeVicinoAtr = -1;   // Chiusura vicina alla linea, x ATR14 (-1 = DA_MODALITA: AUDIO 0 spento, PDF 0,5) [C7]
input ENUM_NC_TRI InpConfermaApertura = NC_TRI_DA_MODALITA; // Conferma: la candela dopo apre dal lato del trend (AUDIO no, PDF si) [C8]
input ENUM_NC_TIMING InpTimingTocco = NC_TIMING_IGNORA; // Timing del tocco nella candela (C9, contraddizione interna al PDF). Solo ingresso PDF

input group "=== Filtri di contesto (par. 1.4) ==="
input ENUM_NC_TRI InpAdxUsa     = NC_TRI_DA_MODALITA; // Filtro ADX massimo (AUDIO si, PDF no, EMA200 no) [A-R12]
input double InpAdxMax          = 20;   // ADX massimo [FONTE A-R12: "a 20 non di piu'"]
input int    InpAdxPeriodo      = 14;   // Periodo ADX [NOSTRA, Wilder]
input ENUM_NC_ADXAMB InpAdxAmbito = NC_ADX_SOLO_ST35; // Linee su cui vale l'ADX (F3). Mai sulla EMA200
//--- InpAdxTipo [cancello 07/10]: default iADX = l'indicatore che MT5 chiama "ADX" (le immagini del
//    PDF sono MT5 su BCM): e' la lettura che NON sposta in silenzio il "20" della collega. Wilder e'
//    piu' basso (sull'oro H1 mediana 25 contro 29): passa circa il DOPPIO dei setup. Resta un asse.
input ENUM_NC_ADXTIPO InpAdxTipo  = NC_ADX_MT5; // Formula ADX: iADX (specifica 2.1) o iADXWilder [NOSTRA, asse]
input ENUM_NC_TRI InpInclUsa    = NC_TRI_DA_MODALITA; // EMA200 inclinata (AUDIO si, PDF no, EMA200 si) [A-R19]
input int    InpInclBarre       = 20;   // Inclinazione: |EMA200[1]-EMA200[1+N]|/ATR14[1], N barre [NOSTRA]
input double InpInclMinAtr      = 0;    // Soglia inclinazione in ATR. 0 = NO-OP DICHIARATO: la soglia arriva dal preset (P25/P50/P75 del passo 0)
input ENUM_NC_INCLVERSO InpInclVerso = NC_INCL_QUALSIASI; // Verso dell'inclinazione
input ENUM_NC_CONFL InpConfluenza = NC_CONFL_DA_MODALITA; // Confluenza linea-EMA200 (AUDIO etichetta, PDF obbligatoria) [F6]
input double InpConflTolAtr     = 0.5;  // Tolleranza confluenza |linea-EMA200| in ATR14 [NOSTRA]
input int    InpMaxSpreadPunti  = 0;    // Spread massimo in punti MT5 (0 = spento) [CASA]

input group "=== Ingresso e unita' (par. 1.5) ==="
input ENUM_NC_UNITA InpUnita    = NC_UNITA_AUTO_CLASSE; // Unita' "u" di tutte le distanze (U1) [NOSTRA]
input double InpUnitaManuale    = 0.1;  // Valore di 1 u in prezzo se InpUnita=MANUALE (es. oro 0,1 USD)
input ENUM_NC_INGRESSO InpTipoIngresso = NC_ING_DA_MODALITA; // Tipo di ingresso (AUDIO/EMA200 scala, PDF mercato+pendente) [E1]
input double InpScalaAnticipo   = 5;    // Scala: ordine d'anticipo, u PRIMA della linea (assi 5/10) [E2, NOSTRA la normalizzazione]
input double InpScalaOltre      = 5;    // Scala: ordine oltre, u DOPO la linea (assi 5/10) [E2]
input double InpPdfDistanzaSecondo = 20; // PDF: pendente a N u oltre il primo ingresso (20 testo, 10 immagine p11) [E4]
input ENUM_NC_LONTANA InpPdfAperturaLontana = NC_LONTANA_SALTA; // PDF: apertura "lontana" dalla linea [E5, NOSTRA]
input double InpPdfLontanoAtr   = 0.5;  // PDF: "lontano" = |open - linea| > N x ATR14 [NOSTRA]
input int    InpScadenzaBarre   = 1;    // PDF: scadenza dei pendenti in barre del TF [NOSTRA, E6]
input int    InpMaxSetupAperti  = 1;    // Setup contemporanei per istanza (E7) [NOSTRA, prudente]

input group "=== Rischio e taglie (par. 1.6) - DA FIRMARE DA CLAUDIO ==="
input double InpRischioSetupPct    = 0.25; // Rischio TOTALE del setup in % del saldo: SEGNAPOSTO DA FIRMARE DA CLAUDIO (nessuna fonte)
input double InpRischioMaxSetupPct = 0;    // Tetto del rischio del setup in % (0 = uguale a InpRischioSetupPct)
input ENUM_NC_PESI3 InpPesiScala   = NC_PESI_1_1_1; // Pesi della scala. 1:2:1 = BANDIERA ROSSA B1 (spenta di default)
input ENUM_NC_PESI2 InpPesiPdf     = NC_PESI_1_1;   // Pesi PDF. 1:2 = BANDIERA ROSSA (2/3 contro il movimento, spenta)
input double InpMoltConfluenza     = 1.0;  // Moltiplicatore del rischio con confluenza. 1,0 = BANDIERA B3 SPENTA

input group "=== Stop e uscite (par. 1.7) ==="
input ENUM_NC_SL InpSLCriterio  = NC_SL_DA_MODALITA; // Criterio di stop (AUDIO ordine profondo, PDF estremo recente) [X1]
input double InpSLBuffer        = 5;    // Buffer dello stop in u (PDF fig.4 p21; AUDIO [NOSTRA]) [X2]
input int    InpSLEstremoBarre  = 3;    // "Minimo recente": barre (tocco + 2 precedenti) [NOSTRA, X3]
input ENUM_NC_TP InpTPCriterio  = NC_TP_DA_MODALITA; // Criterio di take profit (AUDIO dalla linea, PDF EMA14/EMA89) [X5]
input double InpTPDistanza      = 10;   // TP fisso in u [FONTE A-R22: "10 pip / 10 punti"]
input double InpRRMin           = -1;   // R/R minimo (-1 = DA_MODALITA: AUDIO 0 spento, PDF 1,0) [X7]
input double InpParzialeTP1Pct  = 0;    // % chiusa al TP1 (EMA14) (0 = spento, asse 50) [X8]
input ENUM_NC_TRI InpBEalTP1    = NC_TRI_DA_MODALITA; // Pareggio al TP1 al prezzo medio (AUDIO no, PDF si) [X8]
input int    InpDurataMaxMin    = 0;    // Durata massima in minuti (0 = spenta, asse 60) [X9, osservazione A-R24]

input group "=== Costo (diagnostica, NON blocca) ==="
input double InpCommissionePrezzo = 0;  // Commissione andata+ritorno espressa in PREZZO (0 = non contata). Solo diagnostica
input double InpCancelloCostoX    = 40; // Cancello di casa stop >= X x pedaggio: SOLO avviso in log e colonna nel CSV

input group "=== Convenzioni di casa ==="
//--- GUARDIAN DEL CONTO [CASA] -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md. Testo copiato da
//    ABTG_SupertrendReversal.mq5 r.33-44.
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = nessuna richiesta.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (FAIL-OPEN totale, ABTG_PausaGuardian.mqh). I backtest misurano l'EA
//    SENZA pausa B1 e SENZA cap C1: il DD del tester NON e' ridotto dal
//    Guardian. Va scritto in ogni referto di backtest.
//    BUCO B6 (specifica par. 2.5): C1 somma solo POSIZIONI con SL; i
//    pendenti non si contano e un pendente piazzato a cap libero scatta
//    lo stesso dopo. Con la scala AUDIO il rischio vive quasi tutto in
//    pendenti: la guardia vede il setup solo mentre si riempie.
//    Non tocca MAI le posizioni aperte: blocca soltanto l'APERTURA.
input bool   InpUsaGuardian = true;     // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
input long   InpMagic       = 0;        // Magic (0 = automatico: 7786 + motore 0/1/2 + TF 1/4/2/8). Ammesso solo 778600-778699
input string InpComment     = "NATCLA"; // Prefisso del commento degli ordini (es. NATCLA_A_ST35_O2)
//--- IMBUTO DI MORTALITA' [CASA, 11/09/2026]: governa SOLO il log.
input bool   InpLogImbuto   = true;     // Imbuto: riepilogo giornaliero dei rifiuti nel Giornale
input bool   InpVerbose     = true;     // Log dettagliato (setup, ordini, scarti, uscite)
input bool   InpSoloConta   = false;    // SONDA passo 0: valuta tutto, scrive i setup nel CSV, NON manda ordini [NOSTRA]
input double InpPlaceboAtr  = 0;        // PLACEBO (strumento di misura E7): sposta la linea di k x ATR verso il prezzo. Fuori dal tester l'EA rifiuta di partire se != 0

//==================================================================
//  COSTANTI
//==================================================================
#define NC_NL        4      // linee: 0 ST2.5, 1 ST3.0, 2 ST3.5, 3 EMA200
#define NC_L25       0
#define NC_L30       1
#define NC_L35       2
#define NC_LEMA      3
#define NC_BARRE     1500   // finestra di calcolo (barre chiuse). Il collaudo prova che il risultato non dipende dall'inizio
#define NC_BARRE_MIN 300
#define NC_GRAZIA_SEC 300   // PDF: ingresso a mercato solo entro 5 min dall'apertura della barra [CASA: InpGraceSec di ABTG_EMA200_Ombra r.152]
#define NC_TIPO_SCALA 0
#define NC_TIPO_PDF   1

//--- imbuto: ESITI per (linea x barra nuova). 1..21 sommano a VALUTATE (quadratura)
#define IMB_VAL         0
#define IMB_ND          1
#define IMB_FLIP        2
#define IMB_OCCUPATA    3
#define IMB_LATO        4
#define IMB_NOTOCCO     5
#define IMB_EPISODIO    6
#define IMB_CONTEGGIO   7
#define IMB_VICINO      8
#define IMB_ADX         9
#define IMB_INCL        10
#define IMB_CONFL       11
#define IMB_SPREAD      12
#define IMB_TIMING      13
#define IMB_CONFERMA    14
#define IMB_RITARDO     15
#define IMB_LONTANA     16
#define IMB_SEMAFORO    17
#define IMB_NESSUNORD   18
#define IMB_SOLOCONTA   19
#define IMB_ARMATO      20
#define IMB_ENTRATO     21
#define IMB_ULTIMO_ESITO 21
//--- diagnostica per ORDINE (fuori dalla quadratura)
#define IMB_O_PREZZO    22
#define IMB_O_TPCORTO   23
#define IMB_O_RR        24
#define IMB_O_STOPS     25
#define IMB_O_LOTTO     26
#define IMB_O_GUARDIAN  27
#define IMB_O_INVIO     28
#define IMB_O_PIAZZATI  29
#define IMB_O_SLND      30
#define IMB_O_COSTO     31
#define IMB_SEM_SFORATO 32
#define IMB_RIEMPITI    33
#define IMB_CHIUSI      34
#define IMB_N           35

//==================================================================
//  FUNZIONI PURE: nessuna chiamata al terminale. Il collaudo
//  backtest_pipeline/collaudo_natcla.py le ESTRAE da qui, le compila
//  come C++ e le confronta con uno specchio Python indipendente su
//  barre reali dell'oro. Se le cambi, rilancia il collaudo.
//==================================================================
//@@NC_PURE_BEGIN
//--- Supertrend: COPIA IDENTICA (nome a parte) di SW_STCore
//    (mql5/Indicators/ABTG_Pulsanti_Grafico.mq5, SuperWave v4.1) [CASA].
//    Indici 0 = barra piu' vecchia. Calcola le barre [from, n).
//    ATR = media SEMPLICE degli ultimi 'per' True Range (come iATR di MT5).
//    dir: +1 su, -1 giu', 0 = non ancora calcolabile (i < per).
int NC_STCore(const double &h[],const double &l[],const double &c[],const int n,const int from,
              const int per,const double mult,double &atr[],double &upF[],double &dnF[],
              double &dir[],double &val[])
  {
   if(per<1) return 0;
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      if(i<per)
        {
         atr[i]=0.0; upF[i]=0.0; dnF[i]=0.0; dir[i]=0.0; val[i]=0.0;
         continue;
        }
      double s=0.0;
      for(int k=i-per+1;k<=i;k++)
         s+=MathMax(h[k],c[k-1])-MathMin(l[k],c[k-1]);
      double a=s/per;
      atr[i]=a;
      double mid=(h[i]+l[i])/2.0;
      double ub=mid+mult*a;
      double lb=mid-mult*a;
      if(i==per)
        {
         upF[i]=ub;
         dnF[i]=lb;
         dir[i]=(c[i]>=mid) ? 1.0 : -1.0;
        }
      else
        {
         upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1]) ? ub : upF[i-1];
         dnF[i]=(lb>dnF[i-1] || c[i-1]<dnF[i-1]) ? lb : dnF[i-1];
         if(c[i]>upF[i-1])
            dir[i]=1.0;
         else
            if(c[i]<dnF[i-1])
               dir[i]=-1.0;
            else
               dir[i]=dir[i-1];
        }
      val[i]=(dir[i]>0.0) ? dnF[i] : upF[i];
     }
   return n;
  }

//--- Motore M2: "direzione" della EMA200 [NOSTRA]. +1 = chiusura sopra la
//    EMA (la EMA fa da supporto: long), -1 = sotto (resistenza: short).
//    Chiusura esattamente sulla EMA = direzione precedente. 0 = n/d.
void NC_EmaDir(const double &c[],const double &e[],const int n,double &dir[])
  {
   for(int i=0;i<n;i++)
     {
      if(e[i]<=0.0) { dir[i]=0.0; continue; }
      if(c[i]>e[i]) dir[i]=1.0;
      else
         if(c[i]<e[i]) dir[i]=-1.0;
         else dir[i]=(i>0) ? dir[i-1] : 0.0;
     }
  }

//--- C2 [NOSTRA]: la linea IN VIGORE durante la barra i e' il valore
//    calcolato alla chiusura della barra i-1. Il placebo (E7) la sposta
//    di k x ATR14 VERSO il prezzo (su per il floor, giu' per il ceiling).
double NC_LineaInVigore(const double &val[],const double &dir[],const double &atrN[],const int i,
                        const double placeboAtr)
  {
   if(i<1) return 0.0;
   return val[i-1]+dir[i-1]*placeboAtr*atrN[i-1];
  }

//--- C1-C3, D2: tocco VALIDO della barra i.
//    +1 = tocco del floor (long), -1 = tocco del ceiling (short), 0 = no.
//    Valido = l'estremo raggiunge la linea in vigore (RAGGIUNGE) o le
//    arriva entro sfioraAtr x ATR (SFIORA) E la chiusura resta dal lato
//    del trend: niente flip sulla barra i e chiusura non oltre la linea.
//    Una chiusura oltre la linea e' un FLIP, non un setup (D2, C3).
int NC_Tocco(const double &h[],const double &l[],const double &c[],const double &val[],const double &dir[],
             const double &atrN[],const int i,const int defTocco,const double sfioraAtr,const double placeboAtr)
  {
   if(i<1) return 0;
   double d=dir[i-1];
   if(d==0.0 || dir[i]!=d) return 0;
   double lv=NC_LineaInVigore(val,dir,atrN,i,placeboAtr);
   double tol=(defTocco==1) ? sfioraAtr*atrN[i-1] : 0.0;
   if(d>0.0)
     {
      if(c[i]<lv) return 0;
      return (l[i]<=lv+tol) ? 1 : 0;
     }
   if(c[i]>lv) return 0;
   return (h[i]>=lv-tol) ? -1 : 0;
  }

//--- C4-C6: scorre il SEGMENTO della linea (dall'ultimo flip) fino alla
//    barra 'last' e conta gli EPISODI di tocco.
//    C5 [NOSTRA]: barre consecutive che toccano = UN episodio.
//    C6 [NOSTRA]: resetModo 0 = il conteggio vive fra due flip;
//                 resetModo 1 = si azzera anche quando, fuori da un episodio,
//                 il prezzo si allontana dalla linea di >= distaccoAtr x ATR.
//    Uscite: segInizio = barra del flip che apre il segmento (== first se il
//    segmento e' piu' lungo della finestra: TRONCATO); nEp = episodi contati
//    a 'last' compresa; toccoLast = NC_Tocco su 'last'; nuovoEp = 'last'
//    apre un episodio; epInizio = prima barra dell'ultimo episodio (-1).
bool NC_Episodi(const double &h[],const double &l[],const double &c[],const double &val[],const double &dir[],
                const double &atrN[],const int first,const int last,const int defTocco,const double sfioraAtr,
                const double placeboAtr,const int resetModo,const double distaccoAtr,
                int &segInizio,int &nEp,int &toccoLast,bool &nuovoEp,int &epInizio)
  {
   segInizio=-1; nEp=0; toccoLast=0; nuovoEp=false; epInizio=-1;
   if(last<first+1) return false;
   double d=dir[last];
   if(d==0.0) return false;
   int s0=last;
   while(s0>first && dir[s0-1]==d) s0--;
   segInizio=s0;
   bool prev=false;
   for(int i=s0+1;i<=last;i++)
     {
      int t=NC_Tocco(h,l,c,val,dir,atrN,i,defTocco,sfioraAtr,placeboAtr);
      bool tc=(t!=0);
      if(resetModo==1 && !tc && nEp>0)
        {
         double lv=NC_LineaInVigore(val,dir,atrN,i,placeboAtr);
         double dist=(d>0.0) ? (h[i]-lv) : (lv-l[i]);
         if(dist>=distaccoAtr*atrN[i-1]) nEp=0;
        }
      if(tc && !prev)
        {
         nEp++;
         epInizio=i;
         if(i==last) nuovoEp=true;
        }
      prev=tc;
      if(i==last) toccoLast=t;
     }
   return true;
  }

//--- F5 [NOSTRA]: inclinazione FIRMATA (EMA200[i]-EMA200[i-N]) / ATR14[i].
//    0 se non calcolabile (allora non passa nessuna soglia > 0).
double NC_Inclinazione(const double &e[],const double &atrN[],const int i,const int nBarre)
  {
   if(nBarre<1 || i-nBarre<0 || atrN[i]<=0.0) return 0.0;
   return (e[i]-e[i-nBarre])/atrN[i];
  }

//--- F1-F6: contesto. 0 = ok; 1 = ADX; 2 = inclinazione; 3 = confluenza.
//    confl: 0 spenta, 1 solo etichetta, 2 obbligatoria.
//    inclVerso: 0 qualsiasi, 1 concorde (su per il long).
int NC_Contesto(const int s,const bool adxApplica,const double adx,const double adxMax,
                const bool inclUsa,const double inclFirmata,const double inclMin,const int inclVerso,
                const int confl,const double distConflAtr,const double conflTol)
  {
   if(adxApplica && !(adx<=adxMax)) return 1;
   if(inclUsa)
     {
      if(MathAbs(inclFirmata)<inclMin) return 2;
      if(inclVerso==1 && s*inclFirmata<=0.0) return 2;
     }
   if(confl==2 && !(distConflAtr<=conflTol)) return 3;
   return 0;
  }

//--- E2 [NOSTRA la normalizzazione]: tre livelli della scala.
//    p[0] = anticipo (u PRIMA della linea, lato da cui arriva il prezzo),
//    p[1] = sulla linea, p[2] = oltre (u DOPO la linea) = ordine piu' profondo.
//    s = +1 long (ordini sopra/su/sotto il floor), -1 short (specchio).
void NC_PrezziScala(const double linea,const int s,const double anticipo,const double oltre,const double u,
                    double &p[])
  {
   p[0]=linea+s*anticipo*u;
   p[1]=linea;
   p[2]=linea-s*oltre*u;
  }

//--- X1-X4: UNO stop per tutto il setup. criterio 0 = ordine profondo +
//    buffer, 1 = estremo recente + buffer, 2 = linea + buffer. X4: MAI piu'
//    vicino dell'ordine piu' profondo + buffer (si prende il piu' lontano).
double NC_Stop(const int criterio,const int s,const double linea,const double profondo,
               const double estremo,const double buf)
  {
   double base=profondo-s*buf;
   double crit=base;
   if(criterio==1) crit=estremo-s*buf;
   else
      if(criterio==2) crit=linea-s*buf;
   if(s>0) return MathMin(crit,base);
   return MathMax(crit,base);
  }

//--- X5: TP fisso. criterio 0 = dalla linea (WA0092), 1 = dal riempimento.
double NC_TpFisso(const int criterio,const int s,const double linea,const double ingresso,const double dist)
  {
   if(criterio==1) return ingresso+s*dist;
   return linea+s*dist;
  }

//--- X6 [NOSTRA il congelamento e il ripiego]: target PDF.
//    tp1 = EMA14 se sta dal lato del profitto rispetto all'ingresso (0 = no).
//    Ritorna il TP finale: EMA89 se dal lato del profitto e oltre tp1 (o oltre
//    l'ingresso se tp1 = 0), altrimenti ingresso + rrMin x rischio; 0 = nessun
//    TP valido (il chiamante scarta l'ordine).
double NC_TpEma(const int s,const double ingresso,const double sl,const double e14,const double e89,
                const double rrMin,double &tp1)
  {
   tp1=(s*(e14-ingresso)>0.0) ? e14 : 0.0;
   double rif=(tp1!=0.0) ? tp1 : ingresso;
   if(s*(e89-rif)>0.0) return e89;
   double r=s*(ingresso-sl);
   if(rrMin>0.0 && r>0.0) return ingresso+s*rrMin*r;
   return 0.0;
  }

//--- X5/X7: validita' geometrica di un ordine.
//    0 = ok; 1 = TP non oltre l'ingresso di almeno minU (X5);
//    2 = R/R sotto il minimo (X7); 3 = stop dal lato sbagliato o nullo.
int NC_OrdineValido(const int s,const double ingresso,const double sl,const double tp,
                    const double minU,const double rrMin)
  {
   double r=s*(ingresso-sl);
   if(!(r>0.0)) return 3;
   double g=s*(tp-ingresso);
   if(tp==0.0 || g<minU*(1.0-1e-9)) return 1;
   if(rrMin>0.0 && g<rrMin*r*(1.0-1e-9)) return 2;
   return 0;
  }

//--- cifre decimali dello step di volume (0,01 -> 2)
int NC_CifreLotto(const double step)
  {
   for(int d=0;d<=8;d++)
     {
      double x=step*MathPow(10.0,d);
      if(MathAbs(x-MathRound(x))<1e-7) return d;
     }
   return 8;
  }

//--- 2.4: lotto arrotondato SEMPRE per DIFETTO allo step; sotto il minimo
//    = 0 (l'ordine si SCARTA, mai alzato al minimo). Sopra il massimo =
//    massimo (sempre verso il basso). La tolleranza 1e-9 step evita che
//    29,999999999999996 step (0,30/0,01 in virgola mobile) diventino 29;
//    0,299999999 lotti restano 0,29 (collaudato).
double NC_LottoGiu(const double v,const double step,const double vmin,const double vmax)
  {
   if(!(v>0.0) || !(step>0.0)) return 0.0;
   double lot=MathFloor(v/step+1e-9)*step;
   if(vmax>0.0 && lot>vmax) lot=MathFloor(vmax/step+1e-9)*step;
   if(lot<vmin-1e-12) return 0.0;
   return NormalizeDouble(lot,NC_CifreLotto(step));
  }

//--- 2.4: lotto base b tale che, se TUTTI gli ordini rimasti si riempiono,
//    la perdita allo stop comune sia R: b = R / sum(w_i x perdita_per_lotto_i).
//    Ordine i = giu'(w_i x b). Con pesi uguali tutti hanno lo stesso lotto.
//    Garanzia (collaudata): sum(lotto_i x perdita_i) <= R.
void NC_LottiSetup(const double rischio,const double &w[],const double &perditaLotto[],const int n,
                   const double step,const double vmin,const double vmax,double &lotti[])
  {
   double den=0.0;
   for(int i=0;i<n;i++)
     {
      lotti[i]=0.0;
      if(w[i]>0.0 && perditaLotto[i]>0.0) den+=w[i]*perditaLotto[i];
     }
   if(!(rischio>0.0) || !(den>0.0)) return;
   double b=rischio/den;
   for(int i=0;i<n;i++)
      if(w[i]>0.0 && perditaLotto[i]>0.0)
         lotti[i]=NC_LottoGiu(w[i]*b,step,vmin,vmax);
  }

//--- S2/S3: peso dell'ordine i. nOrd 3 = scala (pesi3: 0 -> 1:1:1, 1 -> 1:2:1),
//    nOrd 2 = PDF (pesi2: 0 -> 1:1, 1 -> 1:2: il SECONDO, contro il movimento).
double NC_Peso(const int nOrd,const int pesi,const int i)
  {
   if(nOrd==3 && pesi==1 && i==1) return 2.0;
   if(nOrd==2 && pesi==1 && i==1) return 2.0;
   return 1.0;
  }

//--- C9: meta' della candela in cui cade il tocco. 1 = prima, 2 = seconda.
int NC_MetaTocco(const long secDaApertura,const long periodoSec)
  {
   return (2*secDaApertura<periodoSec) ? 1 : 2;
  }

//--- U1 [CASA]: 1 pip = 10 punti sulle quotazioni a 3/5 cifre, altrimenti 1 punto.
//    (Spostata qui dal cancello 07/10 perche' il collaudo la provi per comportamento.)
double NC_Pip(const int cifre,const double punto)
  {
   return (cifre==3 || cifre==5) ? punto*10.0 : punto;
  }

//--- D1: il lato s (+1 long, -1 short) e' ammesso? direzione 0 entrambi, 1 solo long, 2 solo short.
bool NC_LatoAmmesso(const int direzione,const int s)
  {
   if(direzione==1 && s<0) return false;
   if(direzione==2 && s>0) return false;
   return true;
  }

//--- S1/S4: rischio del setup in SOLDI = saldo x pct / 100. Bandiera B3: con confluenza
//    (dc <= tol) e moltiplicatore diverso da 1 il pct sale, ma TRONCATO al tetto pctMax.
double NC_RischioSoldi(const double saldo,const double pct,const double molt,const double dc,const double tol,
                       const double pctMax)
  {
   double p=pct;
   if(molt!=1.0 && dc<=tol) p=MathMin(pct*molt,pctMax);
   return saldo*p/100.0;
  }

//--- ordine pendente LIMIT valido verso il mercato? 0 ok, 1 prezzo gia' superato o troppo vicino
//    (BuyLimit sotto l'ask, SellLimit sopra il bid, di almeno md), 2 SL dal lato sbagliato o SL/TP
//    dentro md (stops/freeze level). Spostata qui dal cancello 07/10 (provata per comportamento).
int NC_ControllaPendente(const int s,const double price,const double sl,const double tp,const double ask,
                         const double bid,const double md)
  {
   if(s>0)
     {
      if(price>=ask-md) return 1;
      if(sl>=price || price-sl<md) return 2;
      if(tp-price<md) return 2;
     }
   else
     {
      if(price<=bid+md) return 1;
      if(sl<=price || sl-price<md) return 2;
      if(price-tp<md) return 2;
     }
   return 0;
  }
//@@NC_PURE_END

//==================================================================
//  STATO
//==================================================================
CTrade gTrade;

//--- configurazione EFFETTIVA (risolta in OnInit)
ENUM_TIMEFRAMES gTF=PERIOD_H1;
bool   gUsaLinea[NC_NL];
int    gTocchiMax[NC_NL];
double gMultLinea[3];
string gTag[NC_NL]={"ST25","ST30","ST35","E200"};
double gChiudeVicino=0;
bool   gConferma=false, gAdxUsa=false, gInclUsa=false, gBE=false;
int    gConfl=1, gIngresso=0, gSLCrit=0, gTPCrit=0;
double gRRMin=0;
double gU=0;                // valore di 1 u in prezzo
string gUDescr="";
long   gMagic=0;
string gLettera="A";
double gRischioMax=0;
bool   gScadServer=false;   // il simbolo accetta ORDER_TIME_SPECIFIED

//--- handle (tutti INVALID_HANDLE finche' non creati; rilasciati in OnDeinit)
int hEma200=INVALID_HANDLE, hEma14=INVALID_HANDLE, hEma89=INVALID_HANDLE;
int hEma9=INVALID_HANDLE, hEma21=INVALID_HANDLE, hAtrN=INVALID_HANDLE, hAdx=INVALID_HANDLE, hBands=INVALID_HANDLE;

//--- dati della finestra (cronologici: 0 = piu' vecchia, n-1 = barra chiusa shift 1)
double gO[], gH[], gL[], gC[], gEma[], gAtrN[], gAdx[];
datetime gT[];
double gLV[], gLD[], gWa[], gWu[], gWd[];   // linea in esame: valore, direzione, lavoro
int    gN=0;
datetime gTbar0=0, gUltimaBarra=0;

//--- un setup per linea (struttura SEMPLICE: niente stringhe ne' array dinamici)
struct NCSetup
  {
   bool     attivo;
   bool     riempito;
   bool     tp1Fatto;
   bool     residuiCancellati;
   bool     adottato;
   int      tipo;
   int      lato;
   int      toccoN;
   int      nOrdini;
   int      motivoEA;       // 0 nessuno, 1 durata massima
   datetime tEpisodio;
   datetime tSetup;
   datetime tRiempimento;
   datetime tScadenza;
   double   linea;
   double   sl;
   double   tp1;
   double   prezzo[3];
   double   tp[3];
   double   lotto[3];
   double   stopPed[3];
   double   rischioSoldi;
   double   adx;
   double   incl;
   double   conflDist;
   int      conflEtichetta;
   double   ema9;
   double   ema21;
   double   bbLarg;
   double   atr;
   double   spread;
   double   distApertura;
   ulong    posId[8];
   int      nPosId;
  };
NCSetup  gSet[NC_NL];
datetime gUltimoEp[NC_NL];   // chiave dell'ultimo episodio usato (nessun riarmo sullo stesso: X10)
bool     gArmatoPrima[NC_NL];
int      gOrfani=0;          // posizioni/ordini del magic senza etichetta di linea (dopo un riavvio)

//--- CSV per-setup
int gFh=INVALID_HANDLE;

//--- imbuto [CASA, 11/09/2026: stessa logica di ABTG_SupertrendReversal r.130-244]
long     gImb[IMB_N];
long     gImbSnap[IMB_N];
int      gImbGiorno=-1;
datetime gImbData=0;
string   gImbNome[IMB_N]=
  {
   "valutate","linea n/d","flip","occupata","lato spento","nessun tocco","episodio gia' usato",
   "conteggio esaurito","non vicino","ADX","inclinazione","confluenza","spread","timing","conferma",
   "ritardo","apertura lontana","semaforo","nessun ordine valido","solo conta","ARMATO","ENTRATO",
   "ord prezzo superato","ord TP corto","ord R/R","ord stops level","ord lotto<min","ord guardian",
   "ord invio fallito","ORDINI PIAZZATI","ord SL n/d","ord costo<cancello","semaforo sforato",
   "riempimenti","setup chiusi"
  };

//==================================================================
//  LOG
//==================================================================
void Log(const string m){ if(InpVerbose) Print("[NatCla] ",m); }
string D(const double v,const int dg){ return DoubleToString(v,dg); }
string P(const double v){ return DoubleToString(v,_Digits); }
string Lato(const int s){ return (s>0) ? "LONG" : "SHORT"; }

void ImbutoStampa(const string quando)
  {
   if(!InpLogImbuto) return;
   long d[IMB_N];
   for(int i=0;i<IMB_N;i++) d[i]=gImb[i]-gImbSnap[i];
   long somma=0;
   for(int i=1;i<=IMB_ULTIMO_ESITO;i++) somma+=d[i];
   long altro=0;
   for(int i=IMB_ULTIMO_ESITO+1;i<IMB_N;i++) altro+=d[i];
   if(d[IMB_VAL]<=0 && somma<=0 && altro<=0) return;
   string s="[NATCLA-IMBUTO] "+_Symbol+" "+EnumToString(gTF)+" "+quando;
   for(int i=0;i<=IMB_ULTIMO_ESITO;i++) s+=" | "+gImbNome[i]+" "+IntegerToString(d[i]);
   s+=" | quadratura "+((somma==d[IMB_VAL]) ? "OK" :
       ("ROTTA: somma "+IntegerToString(somma)+" contro valutate "+IntegerToString(d[IMB_VAL])));
   s+=" || ordini:";
   for(int i=IMB_ULTIMO_ESITO+1;i<IMB_N;i++) s+=" | "+gImbNome[i]+" "+IntegerToString(d[i]);
   Print(s);
  }

void ImbutoGiro()
  {
   if(!InpLogImbuto) return;
   datetime ora=TimeCurrent();
   MqlDateTime t; TimeToStruct(ora,t);
   if(gImbGiorno<0)
     {
      gImbGiorno=t.day_of_year; gImbData=ora;
      for(int i=0;i<IMB_N;i++) gImbSnap[i]=gImb[i];
      return;
     }
   if(t.day_of_year==gImbGiorno) return;
   ImbutoStampa("giorno "+TimeToString(gImbData,TIME_DATE));
   for(int i=0;i<IMB_N;i++) gImbSnap[i]=gImb[i];
   gImbGiorno=t.day_of_year; gImbData=ora;
  }

//--- un esito per (linea x barra): cosi' la quadratura torna per costruzione
void Esito(const int k){ gImb[k]++; }

//==================================================================
//  UTILITA' DI SIMBOLO
//==================================================================
double NormPrezzo(const double price)    // [CASA] r.535-541 del riferimento
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double PipMT()
  {
   return NC_Pip((int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS),_Point);
  }

//--- U1: valore di 1 u in prezzo
double CalcolaUnita(string &descr)
  {
   if(InpUnita==NC_UNITA_PIP){ descr="PIP (a mano)"; return PipMT(); }
   if(InpUnita==NC_UNITA_PUNTO_PREZZO){ descr="PUNTO_PREZZO 1,0 (a mano)"; return 1.0; }
   if(InpUnita==NC_UNITA_PUNTO_MT5){ descr="PUNTO_MT5 _Point (a mano; escluso per aritmetica, par. 5.3)"; return _Point; }
   if(InpUnita==NC_UNITA_MANUALE){ descr="MANUALE (a mano)"; return InpUnitaManuale; }
   string sy=_Symbol; StringToUpper(sy);
   if(StringFind(sy,"XAU")==0 || StringFind(sy,"XAG")==0){ descr="AUTO_CLASSE metallo: 1,0 USD"; return 1.0; }
   long cm=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_CALC_MODE);
   if(cm==SYMBOL_CALC_MODE_FOREX || cm==SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)
     { descr="AUTO_CLASSE forex: pip"; return PipMT(); }
   //--- [CASA, cancello 07/10] un forex servito in modo CFD resta forex: base e profitto sono due
   //    VALUTE vere e diverse (stessa regola di IsForex in ABTG_EMA200_Dashboard.mq5). Senza, un
   //    USDJPY in modo CFD avrebbe 1 u = 1,0 yen = 100 pip (geometria sbagliata, rischio sempre R).
   string valute=",AUD,CAD,CHF,CNH,CZK,DKK,EUR,GBP,HKD,HUF,JPY,MXN,NOK,NZD,PLN,SEK,SGD,TRY,USD,ZAR,";
   string vb=SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE), vp=SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT);
   StringToUpper(vb); StringToUpper(vp);
   if(StringLen(vb)==3 && StringLen(vp)==3 && vb!=vp && StringFind(valute,","+vb+",")>=0 && StringFind(valute,","+vp+",")>=0)
     { descr="AUTO_CLASSE forex (valute base/profitto): pip"; return PipMT(); }
   descr="AUTO_CLASSE indice/CFD: 1,0 punto";
   return 1.0;
  }

//--- [CASA] r.543-565 del riferimento: perdita per lotto dal broker
//    (OrderCalcProfit), ripiego sul tick value. NIENTE MathMax(min, ...):
//    l'arrotondamento e lo scarto sotto il minimo stanno in NC_LottoGiu.
double PerditaPerLotto(const double dist)
  {
   if(dist<=0) return(0);
   double loss=0;
   double px=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double prof=0;
   if(px>dist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,px,px-dist,prof) && prof<0) loss=-prof;
   if(loss<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0 || tsz<=0) return(0);
      loss=(dist/tsz)*tv;
     }
   return(loss);
  }

double Pedaggio()
  {
   double sp=SymbolInfoDouble(_Symbol,SYMBOL_ASK)-SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(sp<0) sp=0;
   return sp+InpCommissionePrezzo;
  }

double MinDist()
  {
   double a=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double b=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL)*_Point;
   return MathMax(a,b);
  }

//--- ordine pendente LIMIT valido verso il mercato? 0 ok, 1 prezzo gia'
//    superato/troppo vicino, 2 SL o TP dentro lo stops level
int ControllaPendente(const int s,const double price,const double sl,const double tp)
  {
   return NC_ControllaPendente(s,price,sl,tp,SymbolInfoDouble(_Symbol,SYMBOL_ASK),SymbolInfoDouble(_Symbol,SYMBOL_BID),MinDist());
  }

bool EsitoOk()
  {
   uint rc=gTrade.ResultRetcode();
   return(rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_PLACED || rc==TRADE_RETCODE_DONE_PARTIAL);
  }

//==================================================================
//  CONFIGURAZIONE (par. 2.1)
//==================================================================
bool   DaModB(const ENUM_NC_TRI v,const bool a,const bool p,const bool e)
  {
   if(v==NC_TRI_SI) return true;
   if(v==NC_TRI_NO) return false;
   if(InpModalita==NC_AUDIO) return a;
   if(InpModalita==NC_PDF) return p;
   return e;
  }
int    DaModI(const int v,const int a,const int p,const int e)
  {
   if(v>=0) return v;
   if(InpModalita==NC_AUDIO) return a;
   if(InpModalita==NC_PDF) return p;
   return e;
  }
double DaModD(const double v,const double a,const double p,const double e)
  {
   if(v>=0) return v;
   if(InpModalita==NC_AUDIO) return a;
   if(InpModalita==NC_PDF) return p;
   return e;
  }
string Orig(const bool aMano){ return aMano ? "A MANO" : "DA_MODALITA"; }
string NomeModalita(){ return (InpModalita==NC_AUDIO) ? "AUDIO" : ((InpModalita==NC_PDF) ? "PDF" : "EMA200"); }

bool Risolvi(string &err)
  {
   //--- T1: TF del segnale
   gTF=InpTF;
   if(InpTF==PERIOD_CURRENT) gTF=(InpModalita==NC_PDF) ? PERIOD_H4 : PERIOD_H1;
   if(PeriodSeconds(gTF)<PeriodSeconds(PERIOD_H1)){ err="TF sotto H1: vietato dalla fonte (A-R8/R9)"; return false; }
   //--- I4/M2: linee
   gUsaLinea[NC_L25]=DaModB(InpUsaST25,true,false,false);
   gUsaLinea[NC_L30]=DaModB(InpUsaST30,true,false,false);
   gUsaLinea[NC_L35]=DaModB(InpUsaST35,true,true,false);
   gUsaLinea[NC_LEMA]=DaModB(InpMotoreEma200,false,false,true);
   if(!gUsaLinea[0] && !gUsaLinea[1] && !gUsaLinea[2] && !gUsaLinea[3]){ err="nessuna linea attiva"; return false; }
   gMultLinea[0]=InpStMult1; gMultLinea[1]=InpStMult2; gMultLinea[2]=InpStMult3;
   //--- C4
   gTocchiMax[NC_L25]=DaModI(InpTocchiMax25,1,0,1);
   gTocchiMax[NC_L30]=DaModI(InpTocchiMax30,1,0,1);
   gTocchiMax[NC_L35]=DaModI(InpTocchiMax35,2,0,2);
   gTocchiMax[NC_LEMA]=(InpTocchiMaxEma>0) ? InpTocchiMaxEma : 0;
   //--- C7, C8
   gChiudeVicino=DaModD(InpChiudeVicinoAtr,0.0,0.5,0.0);
   gConferma=DaModB(InpConfermaApertura,false,true,false);
   //--- F1, F5, F6 (M2 base: senza ADX, inclinazione si, par. 3.3)
   gAdxUsa=DaModB(InpAdxUsa,true,false,false);
   gInclUsa=DaModB(InpInclUsa,true,false,true);
   gConfl=(InpConfluenza==NC_CONFL_DA_MODALITA) ? ((InpModalita==NC_PDF) ? 2 : 1) : (int)InpConfluenza;
   //--- E1, X1, X5, X7, X8
   gIngresso=(InpTipoIngresso==NC_ING_DA_MODALITA) ? ((InpModalita==NC_PDF) ? 1 : 0) : (int)InpTipoIngresso;
   gSLCrit=(InpSLCriterio==NC_SL_DA_MODALITA) ? ((InpModalita==NC_PDF) ? 1 : 0) : (int)InpSLCriterio;
   gTPCrit=(InpTPCriterio==NC_TP_DA_MODALITA) ? ((InpModalita==NC_PDF) ? 2 : 0) : (int)InpTPCriterio;
   gRRMin=DaModD(InpRRMin,0.0,1.0,0.0);
   gBE=DaModB(InpBEalTP1,false,true,false);
   //--- U1
   gU=CalcolaUnita(gUDescr);
   if(!(gU>0)){ err="unita' u non valida (InpUnitaManuale <= 0?)"; return false; }
   //--- S1, S4
   if(!(InpRischioSetupPct>0)){ err="InpRischioSetupPct <= 0"; return false; }
   gRischioMax=(InpRischioMaxSetupPct>0) ? InpRischioMaxSetupPct : InpRischioSetupPct;
   if(gRischioMax<InpRischioSetupPct){ err="InpRischioMaxSetupPct sotto InpRischioSetupPct"; return false; }
   if(!(InpMoltConfluenza>0)){ err="InpMoltConfluenza <= 0"; return false; }
   if(InpMoltConfluenza*InpRischioSetupPct>gRischioMax+1e-12)
     { err="InpMoltConfluenza x rischio supera InpRischioMaxSetupPct: senza una FIRMA il rischio non sale (S4)"; return false; }
   //--- placebo: solo nel tester
   if(InpPlaceboAtr!=0 && !MQLInfoInteger(MQL_TESTER)){ err="InpPlaceboAtr != 0 fuori dal tester"; return false; }
   if(InpMaxSetupAperti<1){ err="InpMaxSetupAperti < 1"; return false; }
   if(InpStAtrPeriodo<1 || InpAtrNormPeriodo<1 || InpAdxPeriodo<1 || InpEmaLentaPeriodo<1){ err="periodo indicatore < 1"; return false; }
   //--- magic [CASA] blocco 778600-778699: 7786 + motore + TF
   gLettera=(InpModalita==NC_AUDIO) ? "A" : ((InpModalita==NC_PDF) ? "P" : "E");
   if(InpMagic==0)
     {
      int cifraTF=-1;
      if(gTF==PERIOD_H1) cifraTF=1;
      if(gTF==PERIOD_H4) cifraTF=4;
      if(gTF==PERIOD_H12) cifraTF=2;
      if(gTF==PERIOD_D1) cifraTF=8;
      if(cifraTF<0){ err="magic automatico definito solo per H1/H4/H12/D1: imposta InpMagic nel blocco 778600-778699"; return false; }
      gMagic=778600+10*(long)InpModalita+cifraTF;
     }
   else gMagic=InpMagic;
   if(gMagic<778600 || gMagic>778699){ err="InpMagic fuori dal blocco 778600-778699"; return false; }
   return true;
  }

//--- 2.1 punto 2: configurazione EFFETTIVA nel Giornale e in testa al CSV
void Cfg(const string nome,const string valore,const string etichetta)
  {
   Print("[NatCla] CFG ",nome," = ",valore,"   ",etichetta);
   if(gFh!=INVALID_HANDLE) FileWrite(gFh,"#cfg;"+nome+";"+valore+";"+etichetta);
  }

void StampaConfigurazione()
  {
   string avvio=StringFormat("AVVIO v%s | modalita' %s | %s %s | 1 u = %s (%s) | 1 pip = %s | magic %s | linee %s%s%s%s | ingresso %s | rischio setup %.2f%% (SEGNAPOSTO DA FIRMARE DA CLAUDIO) | guardian %s | solo conta %s | placebo %.2f ATR",
                             NC_VER,NomeModalita(),_Symbol,EnumToString(gTF),DoubleToString(gU,_Digits),gUDescr,
                             DoubleToString(PipMT(),_Digits),IntegerToString(gMagic),
                             gUsaLinea[0] ? "ST25 " : "",gUsaLinea[1] ? "ST30 " : "",gUsaLinea[2] ? "ST35 " : "",gUsaLinea[3] ? "E200" : "",
                             (gIngresso==0) ? "SCALA3_PENDENTI" : "MERCATO_PIU_PENDENTE",InpRischioSetupPct,
                             InpUsaGuardian ? "ON (nel tester FAIL-OPEN)" : "OFF",InpSoloConta ? "SI" : "no",InpPlaceboAtr);
   Print("[NatCla] ",avvio);
   if(gFh!=INVALID_HANDLE) FileWrite(gFh,"#"+avvio);
   Cfg("InpTF",EnumToString(gTF),Orig(InpTF!=PERIOD_CURRENT)+" [FONTE A-R8 / P-p05]");
   Cfg("InpDirezione",EnumToString(InpDirezione),"[FONTE: direzione mai dichiarata, A-R26]");
   Cfg("Supertrend",StringFormat("ATR %d, mult %.2f / %.2f / %.2f, HL2",InpStAtrPeriodo,InpStMult1,InpStMult2,InpStMult3),"[FONTE] calcolo SW_STCore [CASA]");
   Cfg("Linee",StringFormat("ST25 %s, ST30 %s, ST35 %s, EMA200 %s",gUsaLinea[0] ? "si" : "no",gUsaLinea[1] ? "si" : "no",gUsaLinea[2] ? "si" : "no",gUsaLinea[3] ? "si" : "no"),
       Orig(InpUsaST25!=NC_TRI_DA_MODALITA || InpUsaST30!=NC_TRI_DA_MODALITA || InpUsaST35!=NC_TRI_DA_MODALITA || InpMotoreEma200!=NC_TRI_DA_MODALITA)+" [FONTE A-R11/13/14/20, P-p11]");
   Cfg("TocchiMax",StringFormat("%d / %d / %d / EMA %d (0 = illimitato)",gTocchiMax[0],gTocchiMax[1],gTocchiMax[2],gTocchiMax[3]),
       Orig(InpTocchiMax25>=0 || InpTocchiMax30>=0 || InpTocchiMax35>=0)+" [FONTE A-R11/R13/R14]");
   Cfg("EmaLenta",IntegerToString(InpEmaLentaPeriodo)+" EMA su close","[FONTE] periodo; close [NOSTRA]");
   Cfg("ToccoDef",EnumToString(InpToccoDef)+StringFormat(" (sfiora %.2f ATR)",InpSfioraAtr),"[FONTE] RAGGIUNGE, [NOSTRA] SFIORA");
   Cfg("ResetConteggio",EnumToString(InpResetConteggio)+StringFormat(" (distacco %.2f ATR)",InpDistaccoAtr),"[NOSTRA] C6");
   Cfg("ChiudeVicinoAtr",DoubleToString(gChiudeVicino,2)+" (0 = spento)",Orig(InpChiudeVicinoAtr>=0)+" [FONTE P-p14] tolleranza [NOSTRA]");
   Cfg("ConfermaApertura",gConferma ? "si" : "no",Orig(InpConfermaApertura!=NC_TRI_DA_MODALITA)+" [FONTE P-p06]");
   Cfg("TimingTocco",EnumToString(InpTimingTocco),"[FONTE P-p14 vs p25: contraddizione]");
   Cfg("ADX",StringFormat("%s, max %.1f, periodo %d, ambito %s, tipo %s",gAdxUsa ? "ACCESO" : "spento",InpAdxMax,InpAdxPeriodo,EnumToString(InpAdxAmbito),EnumToString(InpAdxTipo)),
       Orig(InpAdxUsa!=NC_TRI_DA_MODALITA)+" [FONTE A-R12] periodo/tipo [NOSTRA]");
   Cfg("Inclinazione",StringFormat("%s, N %d, soglia %.3f ATR, verso %s",gInclUsa ? "ACCESA" : "spenta",InpInclBarre,InpInclMinAtr,EnumToString(InpInclVerso)),
       Orig(InpInclUsa!=NC_TRI_DA_MODALITA)+" [FONTE A-R19] misura [NOSTRA]");
   if(gInclUsa && InpInclMinAtr<=0)
      Print("[NatCla] AVVISO: filtro inclinazione ACCESO con soglia 0 = NO-OP DICHIARATO (lascia passare tutto) finche' il preset non porta il P50 del passo 0 (specifica F5)");
   Cfg("Confluenza",StringFormat("%d (0 spenta, 1 solo etichetta, 2 obbligatoria), tolleranza %.2f ATR",gConfl,InpConflTolAtr),
       Orig(InpConfluenza!=NC_CONFL_DA_MODALITA)+" [FONTE A-R16 / P-p21] tolleranza [NOSTRA]");
   Cfg("MaxSpreadPunti",IntegerToString(InpMaxSpreadPunti)+" (0 = spento)","[CASA]");
   Cfg("Unita",DoubleToString(gU,_Digits)+" "+gUDescr,"[NOSTRA] U1");
   Cfg("Ingresso",(gIngresso==0) ? "SCALA3_PENDENTI" : "MERCATO_PIU_PENDENTE",Orig(InpTipoIngresso!=NC_ING_DA_MODALITA)+" [FONTE A-R21 / P-p17]");
   Cfg("Scala",StringFormat("anticipo %.2f u, oltre %.2f u",InpScalaAnticipo,InpScalaOltre),"[FONTE] numeri, [NOSTRA] normalizzazione");
   Cfg("PDF secondo ordine",StringFormat("%.2f u, lontana %s (%.2f ATR), scadenza %d barre",InpPdfDistanzaSecondo,EnumToString(InpPdfAperturaLontana),InpPdfLontanoAtr,InpScadenzaBarre),"[FONTE P-p17] / [NOSTRA]");
   Cfg("MaxSetupAperti",IntegerToString(InpMaxSetupAperti),"[NOSTRA] E7");
   Cfg("RischioSetupPct",DoubleToString(InpRischioSetupPct,3)+" (tetto "+DoubleToString(gRischioMax,3)+")","SEGNAPOSTO DA FIRMARE DA CLAUDIO (nessuna fonte)");
   Cfg("PesiScala",EnumToString(InpPesiScala),"BANDIERA B1 (default spenta)");
   Cfg("PesiPdf",EnumToString(InpPesiPdf),"BANDIERA 2/3 PDF (default spenta)");
   Cfg("MoltConfluenza",DoubleToString(InpMoltConfluenza,2),"BANDIERA B3 (1,0 = spenta)");
   Cfg("SL",StringFormat("criterio %d (0 ordine profondo, 1 estremo recente, 2 linea), buffer %.2f u, estremo su %d barre",gSLCrit,InpSLBuffer,InpSLEstremoBarre),
       Orig(InpSLCriterio!=NC_SL_DA_MODALITA)+" [FONTE P-p17/p21] / [NOSTRA] audio");
   Cfg("TP",StringFormat("criterio %d (0 dalla linea, 1 dal riempimento, 2 EMA14/EMA89), distanza %.2f u, R/R min %.2f",gTPCrit,InpTPDistanza,gRRMin),
       Orig(InpTPCriterio!=NC_TP_DA_MODALITA || InpRRMin>=0)+" [FONTE A-R22 / P-p17]");
   Cfg("TP1",StringFormat("parziale %.1f%%, pareggio %s",InpParzialeTP1Pct,gBE ? "si" : "no"),Orig(InpBEalTP1!=NC_TRI_DA_MODALITA)+" [FONTE P-p17 'posso']");
   Cfg("DurataMaxMin",IntegerToString(InpDurataMaxMin)+" (0 = spenta)","[FONTE A-R24: osservazione, non regola]");
   Cfg("Costo",StringFormat("commissione %s in prezzo, cancello %.1fx (SOLO diagnostica)",DoubleToString(InpCommissionePrezzo,_Digits),InpCancelloCostoX),"[CASA] cancello del costo");
   Cfg("Scadenza server pendenti",gScadServer ? "si" : "no (gestita dall'EA)","[CASA]");
   //--- BANDIERE ROSSE: avviso esplicito se accese (par. 4)
   if(InpPesiScala!=NC_PESI_1_1_1)
      Print("[NatCla] AVVISO BANDIERA ROSSA B1 ACCESA: scala con size CRESCENTI (1:2:1). Il rischio TOTALE del setup resta R, ma va acceso solo con una FIRMA di Claudio");
   if(InpPesiPdf!=NC_PESI_1_1)
      Print("[NatCla] AVVISO BANDIERA ROSSA ACCESA: PDF 2/3 CONTRO il movimento (1:2). Il rischio TOTALE resta R, ma va acceso solo con una FIRMA di Claudio");
   if(InpMoltConfluenza!=1.0)
      Print("[NatCla] AVVISO BANDIERA ROSSA B3 ACCESA: size diversa con confluenza (x",DoubleToString(InpMoltConfluenza,2),"), troncata a ",DoubleToString(gRischioMax,3),"%");
   if(InpPlaceboAtr!=0)
      Print("[NatCla] AVVISO: PLACEBO ACCESO (",DoubleToString(InpPlaceboAtr,2)," ATR): e' uno strumento di misura, non una strategia");
   if(InpSoloConta)
      Print("[NatCla] AVVISO: SOLO CONTA: nessun ordine verra' inviato");
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   ArrayInitialize(gImb,0); ArrayInitialize(gImbSnap,0);
   for(int L=0;L<NC_NL;L++){ ResetSetup(L); gUltimoEp[L]=0; gArmatoPrima[L]=false; }
   string err="";
   if(!Risolvi(err)){ Print("[NatCla] AVVIO RIFIUTATO: ",err); return(INIT_PARAMETERS_INCORRECT); }
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE)!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
     { Print("[NatCla] AVVIO RIFIUTATO: serve un conto HEDGING (ogni ordine della scala e' una posizione con la sua etichetta)"); return(INIT_FAILED); }
   long em=SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_MODE);
   gScadServer=((em & SYMBOL_EXPIRATION_SPECIFIED)!=0);

   gTrade.SetExpertMagicNumber((ulong)gMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   hEma200=iMA(_Symbol,gTF,InpEmaLentaPeriodo,0,MODE_EMA,PRICE_CLOSE);
   hEma14 =iMA(_Symbol,gTF,InpEmaTp1,0,MODE_EMA,PRICE_CLOSE);
   hEma89 =iMA(_Symbol,gTF,InpEmaTp2,0,MODE_EMA,PRICE_CLOSE);
   hAtrN  =iATR(_Symbol,gTF,InpAtrNormPeriodo);
   if(InpAdxTipo==NC_ADX_WILDER) hAdx=iADXWilder(_Symbol,gTF,InpAdxPeriodo);
   else hAdx=iADX(_Symbol,gTF,InpAdxPeriodo);
   if(InpLogContesto)
     {
      hEma9 =iMA(_Symbol,gTF,9,0,MODE_EMA,PRICE_CLOSE);
      hEma21=iMA(_Symbol,gTF,21,0,MODE_EMA,PRICE_CLOSE);
      hBands=iBands(_Symbol,gTF,20,0,2.0,PRICE_CLOSE);
     }
   if(hEma200==INVALID_HANDLE || hEma14==INVALID_HANDLE || hEma89==INVALID_HANDLE || hAtrN==INVALID_HANDLE || hAdx==INVALID_HANDLE ||
      (InpLogContesto && (hEma9==INVALID_HANDLE || hEma21==INVALID_HANDLE || hBands==INVALID_HANDLE)))
     { Print("[NatCla] ERRORE: creazione handle indicatori fallita (",GetLastError(),")"); return(INIT_FAILED); }

   //--- CSV per-setup: non in ottimizzazione (ogni passata sovrascriverebbe lo stesso file)
   if(!MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string fn="natcla_setup_"+_Symbol+"_"+IntegerToString(gMagic)+".csv";
      gFh=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
      if(gFh==INVALID_HANDLE) Print("[NatCla] AVVISO: CSV per-setup non creato (",GetLastError(),")");
     }
   StampaConfigurazione();
   if(gFh!=INVALID_HANDLE)
     {
      FileWrite(gFh,"tipo;barra;linea;lato;tocco_n;nuovo_ep;troncato;ctx_arm;ctx_tocco;vicino_ok;conferma_ok;dist_apertura_atr;adx;incl_atr;confl_dist_atr;confl_etichetta;ema9;ema21;bb_larg;atr14;linea_prezzo;ingresso;n_ordini;p1;p2;p3;sl;tp1;tp2;tp3;lotto1;lotto2;lotto3;spread;commissione;stop_ped1;stop_ped2;stop_ped3;rischio_soldi;n_riempiti;esito_soldi;esito_R;durata_min;motivo");
      FileFlush(gFh);
     }
   AdottaEsistenti();
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   ImbutoStampa("parziale del "+TimeToString(gImbData,TIME_DATE));
   int hs[8]={hEma200,hEma14,hEma89,hEma9,hEma21,hAtrN,hAdx,hBands};
   for(int i=0;i<8;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
   hEma200=INVALID_HANDLE; hEma14=INVALID_HANDLE; hEma89=INVALID_HANDLE; hEma9=INVALID_HANDLE;
   hEma21=INVALID_HANDLE; hAtrN=INVALID_HANDLE; hAdx=INVALID_HANDLE; hBands=INVALID_HANDLE;
   if(gFh!=INVALID_HANDLE){ FileClose(gFh); gFh=INVALID_HANDLE; }
   //--- NESSUN ordine viene cancellato qui (reload-safe): al riavvio AdottaEsistenti li riprende.
  }

void OnTick()
  {
   ImbutoGiro();             // IMBUTO: solo log
   Sincronizza();            // gestione: riempimenti, residui, TP1, durata, chiusure
   datetime t0=iTime(_Symbol,gTF,0);
   if(t0==0 || t0==gUltimaBarra) return;
   gUltimaBarra=t0;
   gTbar0=t0;
   OnNewBar();
  }

void OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   if(trans.type==TRADE_TRANSACTION_DEAL_ADD) Sincronizza();
  }

//==================================================================
//  DATI DELLA FINESTRA
//==================================================================
bool CaricaDati()
  {
   int barre=Bars(_Symbol,gTF);
   int n=(barre-2<NC_BARRE) ? barre-2 : NC_BARRE;
   if(n<NC_BARRE_MIN) return false;
   if(BarsCalculated(hEma200)<n+1 || BarsCalculated(hAtrN)<n+1 || BarsCalculated(hAdx)<n+1) return false;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   if(CopyRates(_Symbol,gTF,1,n,r)!=n) return false;
   ArrayResize(gO,n); ArrayResize(gH,n); ArrayResize(gL,n); ArrayResize(gC,n); ArrayResize(gT,n);
   for(int i=0;i<n;i++){ gO[i]=r[i].open; gH[i]=r[i].high; gL[i]=r[i].low; gC[i]=r[i].close; gT[i]=r[i].time; }
   ArraySetAsSeries(gEma,false); ArraySetAsSeries(gAtrN,false); ArraySetAsSeries(gAdx,false);
   if(CopyBuffer(hEma200,0,1,n,gEma)!=n) return false;
   if(CopyBuffer(hAtrN,0,1,n,gAtrN)!=n) return false;
   if(CopyBuffer(hAdx,0,1,n,gAdx)!=n) return false;
   ArrayResize(gLV,n); ArrayResize(gLD,n); ArrayResize(gWa,n); ArrayResize(gWu,n); ArrayResize(gWd,n);
   gN=n;
   return true;
  }

//--- calcola la linea L sulla finestra in gLV (valore) e gLD (direzione)
void CalcolaLinea(const int L)
  {
   if(L==NC_LEMA)
     {
      for(int i=0;i<gN;i++) gLV[i]=gEma[i];
      NC_EmaDir(gC,gEma,gN,gLD);
      return;
     }
   NC_STCore(gH,gL,gC,gN,0,InpStAtrPeriodo,gMultLinea[L],gWa,gWu,gWd,gLD,gLV);
  }

//--- valore di un buffer alla barra chiusa shift 1 (0 se n/d)
double Buf1(const int h,const int buf)
  {
   if(h==INVALID_HANDLE) return 0;
   if(BarsCalculated(h)<2) return 0;
   double a[1];
   if(CopyBuffer(h,buf,1,1,a)!=1) return 0;
   return a[0];
  }

//==================================================================
//  NUOVA BARRA: una valutazione per linea attiva (par. 2.3)
//==================================================================
void OnNewBar()
  {
   bool ok=CaricaDati();
   for(int L=0;L<NC_NL;L++)
     {
      if(!gUsaLinea[L]) continue;
      if(!ok){ Esito(IMB_VAL); Esito(IMB_ND); continue; }
      CalcolaLinea(L);
      if(gIngresso==0) ValutaScala(L);
      else ValutaPdf(L);
     }
   if(gFh!=INVALID_HANDLE) FileFlush(gFh);
  }

bool LatoAmmesso(const int s)
  {
   return NC_LatoAmmesso((int)InpDirezione,s);
  }

double LineaPrezzo(const int k,const int s)   // linea in vigore DOPO la barra k (per la barra k+1)
  {
   return gLV[k]+s*InpPlaceboAtr*gAtrN[k];
  }

//--- contesto alla barra k per il lato s: 0 ok, altrimenti l'esito d'imbuto
int Contesto(const int L,const int s,const int k,double &adx,double &incl,double &dc)
  {
   adx=gAdx[k];
   incl=NC_Inclinazione(gEma,gAtrN,k,InpInclBarre);
   dc=(gAtrN[k]>0) ? MathAbs(LineaPrezzo(k,s)-gEma[k])/gAtrN[k] : 1e9;
   bool adxApplica=gAdxUsa && L!=NC_LEMA && (InpAdxAmbito==NC_ADX_TUTTE || L==NC_L35);
   int r=NC_Contesto(s,adxApplica,adx,InpAdxMax,gInclUsa,incl,InpInclMinAtr,(int)InpInclVerso,gConfl,dc,InpConflTolAtr);
   if(r==1) return IMB_ADX;
   if(r==2) return IMB_INCL;
   if(r==3) return IMB_CONFL;
   if(InpMaxSpreadPunti>0 && SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)>InpMaxSpreadPunti) return IMB_SPREAD;
   return 0;
  }

double Estremo(const int s,const int last)   // X3: minimo (long) / massimo (short) delle ultime InpSLEstremoBarre barre fino a last
  {
   int nb=(InpSLEstremoBarre>1) ? InpSLEstremoBarre : 1;
   int a=(last-nb+1>0) ? last-nb+1 : 0;
   double e=(s>0) ? gL[last] : gH[last];
   for(int i=a;i<=last;i++) e=(s>0) ? MathMin(e,gL[i]) : MathMax(e,gH[i]);
   return e;
  }

//==================================================================
//  MODO SCALA (AUDIO, EMA200): tre LIMIT armati a ogni barra chiusa
//  e riprezzati sulla nuova linea (E2, E3). Il tocco E' il riempimento.
//==================================================================
void ValutaScala(const int L)
  {
   Esito(IMB_VAL);
   int last=gN-1;
   int segI=0,nEp=0,tLast=0,epI=-1; bool nuovo=false;
   if(gLD[last]==0.0 || !NC_Episodi(gH,gL,gC,gLV,gLD,gAtrN,0,last,(int)InpToccoDef,InpSfioraAtr,InpPlaceboAtr,
                                    (int)InpResetConteggio,InpDistaccoAtr,segI,nEp,tLast,nuovo,epI))
     {
      if(gSet[L].attivo && !gSet[L].riempito) CancellaSetupNonRiempito(L,"linea n/d");
      Esito(IMB_ND); return;
     }
   int s=(int)gLD[last];
   bool flip=(gLD[last]!=gLD[last-1]);
   if(InpSoloConta){ if(tLast!=0) ScriviConta(L,last,nEp,nuovo,segI==0); Esito(IMB_SOLOCONTA); return; }
   //--- flip: cancella i pendenti NON riempiti (anche i residui di un setup in corso)
   if(flip && gSet[L].attivo)
     {
      if(gSet[L].riempito) CancellaOrdiniLinea(L,"flip della linea: residui");
      else CancellaSetupNonRiempito(L,"flip della linea");
     }
   if(gSet[L].attivo && gSet[L].riempito){ Esito(IMB_OCCUPATA); return; }
   //--- la linea non ha posizioni: gli ordini armati si cancellano e (se tutto passa) si riarmano
   if(gSet[L].attivo) CancellaSetupNonRiempito(L,"");
   if(flip){ gArmatoPrima[L]=false; Esito(IMB_FLIP); return; }
   if(!LatoAmmesso(s)){ gArmatoPrima[L]=false; Esito(IMB_LATO); return; }
   int prossimo=(tLast!=0) ? nEp : nEp+1;
   datetime chiave=(tLast!=0 && epI>=0) ? gT[epI] : gTbar0;
   if(chiave==gUltimoEp[L]){ gArmatoPrima[L]=false; Esito(IMB_EPISODIO); return; }
   if(gTocchiMax[L]>0 && prossimo>gTocchiMax[L]){ gArmatoPrima[L]=false; Esito(IMB_CONTEGGIO); return; }
   double adx,incl,dc;
   int ctx=Contesto(L,s,last,adx,incl,dc);
   if(ctx!=0){ gArmatoPrima[L]=false; Esito(ctx); return; }
   if(Aperti()>=InpMaxSetupAperti){ gArmatoPrima[L]=false; Esito(IMB_SEMAFORO); return; }
   //--- GUARDIA ANTI-DUPLICATO [CASA, reload-safe]: se sul conto c'e' ancora qualcosa di questa
   //    linea (cancellazione non riuscita, riempimento in volo) non si piazza niente di nuovo
   int np0,no0; ContaLinea(L,np0,no0);
   if(np0>0 || no0>0){ gArmatoPrima[L]=false; Esito(IMB_OCCUPATA); Log(StringFormat("%s: guardia anti-duplicato (%d posizioni, %d pendenti ancora sul conto)",gTag[L],np0,no0)); return; }
   ArmaScala(L,s,last,prossimo,chiave,adx,incl,dc);
  }

void ArmaScala(const int L,const int s,const int last,const int toccoN,const datetime chiave,
               const double adx,const double incl,const double dc)
  {
   double lv=NormPrezzo(LineaPrezzo(last,s));
   double p[3];
   NC_PrezziScala(lv,s,InpScalaAnticipo,InpScalaOltre,gU,p);
   for(int i=0;i<3;i++) p[i]=NormPrezzo(p[i]);
   double sl=NormPrezzo(NC_Stop(gSLCrit,s,lv,p[2],Estremo(s,last),InpSLBuffer*gU));
   double e14=gEma[last], e89=gEma[last];
   if(gTPCrit==2){ e14=Buf1(hEma14,0); e89=Buf1(hEma89,0); }
   double tp[3], tp1=0;
   bool ok[3];
   int nOk=0;
   for(int i=0;i<3;i++)
     {
      double t1=0;
      if(gTPCrit==2) tp[i]=NC_TpEma(s,p[i],sl,e14,e89,gRRMin,t1);
      else tp[i]=NC_TpFisso(gTPCrit,s,lv,p[i],InpTPDistanza*gU);
      if(i==1) tp1=t1;
      tp[i]=(tp[i]!=0) ? NormPrezzo(tp[i]) : 0;
      ok[i]=ValidaOrdine(L,i,s,p[i],sl,tp[i],true);
      if(ok[i]) nOk++;
     }
   if(sl<=0){ Esito(IMB_NESSUNORD); gImb[IMB_O_SLND]++; return; }
   double lot[3];
   if(nOk>0) CalcolaLotti(L,3,(int)InpPesiScala,p,sl,ok,dc,lot);
   else { lot[0]=0; lot[1]=0; lot[2]=0; }
   //--- registra il setup PRIMA dell'invio (cosi' Sincronizza riconosce i riempimenti)
   ResetSetup(L);
   gSet[L].attivo=true; gSet[L].tipo=NC_TIPO_SCALA; gSet[L].lato=s; gSet[L].toccoN=toccoN;
   gSet[L].tEpisodio=chiave; gSet[L].tSetup=gTbar0; gSet[L].linea=lv; gSet[L].sl=sl; gSet[L].tp1=tp1;
   gSet[L].rischioSoldi=RischioSoldi(dc); gSet[L].adx=adx; gSet[L].incl=incl; gSet[L].conflDist=dc;
   gSet[L].conflEtichetta=(dc<=InpConflTolAtr) ? 1 : 0;
   ContestoLog(L,last);
   double ped=Pedaggio();
   int piazzati=0;
   for(int i=0;i<3;i++)
     {
      gSet[L].prezzo[i]=p[i]; gSet[L].tp[i]=tp[i];
      gSet[L].stopPed[i]=(ped>0) ? MathAbs(p[i]-sl)/ped : 0;
      if(!ok[i]) continue;
      if(lot[i]<=0){ gImb[IMB_O_LOTTO]++; if(!gArmatoPrima[L]) Log(StringFormat("SCARTATO %s O%d: lotto sotto il minimo (mai alzato al minimo)",gTag[L],i+1)); continue; }
      AvvisoCosto(L,i,gSet[L].stopPed[i]);
      string cm=Commento(L,i);
      if(InviaLimit(s,p[i],lot[i],sl,tp[i],0,cm,!gArmatoPrima[L])){ gSet[L].lotto[i]=lot[i]; piazzati++; }
     }
   gSet[L].nOrdini=piazzati;
   if(piazzati==0){ ResetSetup(L); gArmatoPrima[L]=false; Esito(IMB_NESSUNORD); return; }
   if(!gArmatoPrima[L])
     {
      Log(StringFormat("SETUP %s %s armato: tocco n.%d, linea %s, SL %s, ordini %d, ADX %.1f, incl %.2f ATR, confl %.2f ATR",
                       gTag[L],Lato(s),toccoN,P(lv),P(sl),piazzati,adx,incl,dc));
      if(InpPesiScala!=NC_PESI_1_1_1) Log("AVVISO BANDIERA B1 attiva su questo setup (pesi 1:2:1)");
     }
   gArmatoPrima[L]=true;
   Esito(IMB_ARMATO);
  }

//==================================================================
//  MODO PDF: tocco sulla barra chiusa, conferma all'apertura della
//  successiva, 1 ordine a mercato + 1 limit oltre (E1, E4, E5).
//==================================================================
void ValutaPdf(const int L)
  {
   Esito(IMB_VAL);
   int last=gN-1;
   int segI=0,nEp=0,tLast=0,epI=-1; bool nuovo=false;
   if(gLD[last]==0.0 || !NC_Episodi(gH,gL,gC,gLV,gLD,gAtrN,0,last,(int)InpToccoDef,InpSfioraAtr,InpPlaceboAtr,
                                    (int)InpResetConteggio,InpDistaccoAtr,segI,nEp,tLast,nuovo,epI))
     { Esito(IMB_ND); return; }
   int s=(int)gLD[last];
   bool flip=(gLD[last]!=gLD[last-1]);
   if(InpSoloConta){ if(tLast!=0) ScriviConta(L,last,nEp,nuovo,segI==0); Esito(IMB_SOLOCONTA); return; }
   if(flip && gSet[L].attivo) CancellaOrdiniLinea(L,"flip della linea: pendenti non riempiti");
   if(gSet[L].attivo){ Esito(IMB_OCCUPATA); return; }
   if(flip){ Esito(IMB_FLIP); return; }
   if(!LatoAmmesso(s)){ Esito(IMB_LATO); return; }
   if(tLast==0 || tLast!=s){ Esito(IMB_NOTOCCO); return; }
   datetime chiave=(epI>=0) ? gT[epI] : gT[last];
   if(chiave==gUltimoEp[L]){ Esito(IMB_EPISODIO); return; }
   if(gTocchiMax[L]>0 && nEp>gTocchiMax[L]){ Esito(IMB_CONTEGGIO); Log(StringFormat("tocco %s %s n.%d: oltre il massimo %d",gTag[L],Lato(s),nEp,gTocchiMax[L])); return; }
   double atr=gAtrN[last];
   double lvT=gLV[last-1]+s*InpPlaceboAtr*gAtrN[last-1];   // linea in vigore durante la barra del tocco
   if(gChiudeVicino>0 && !(atr>0 && MathAbs(gC[last]-lvT)<=gChiudeVicino*atr))
     { Esito(IMB_VICINO); Log(StringFormat("tocco %s %s n.%d SCARTATO: chiusura non vicina alla linea (%.2f ATR > %.2f)",gTag[L],Lato(s),nEp,(atr>0) ? MathAbs(gC[last]-lvT)/atr : -1.0,gChiudeVicino)); return; }
   double adx,incl,dc;
   int ctx=Contesto(L,s,last,adx,incl,dc);
   if(ctx!=0){ Esito(ctx); Log(StringFormat("tocco %s %s n.%d SCARTATO: %s (ADX %.1f, incl %.2f, confl %.2f ATR)",gTag[L],Lato(s),nEp,gImbNome[ctx],adx,incl,dc)); return; }
   if(InpTimingTocco!=NC_TIMING_IGNORA)
     {
      int m=TimingTocco(s,lvT,gT[last]);
      if(m!=(int)InpTimingTocco){ Esito(IMB_TIMING); Log(StringFormat("tocco %s %s SCARTATO: timing %d contro richiesto %d (0 = n/d)",gTag[L],Lato(s),m,(int)InpTimingTocco)); return; }
     }
   double op0=iOpen(_Symbol,gTF,0);
   double lv0=LineaPrezzo(last,s);
   if(gConferma && !(s*(op0-lv0)>0)){ Esito(IMB_CONFERMA); Log(StringFormat("tocco %s %s SCARTATO: la candela dopo apre fuori (open %s, linea %s): setup invalidato (P-p14)",gTag[L],Lato(s),P(op0),P(lv0))); return; }
   if(TimeCurrent()-gTbar0>NC_GRAZIA_SEC){ Esito(IMB_RITARDO); Log("tocco "+gTag[L]+" SCARTATO: barra vista in ritardo (riavvio?), niente ingresso a mercato tardivo"); return; }
   double dist=(atr>0) ? MathAbs(op0-lv0)/atr : 0;
   bool lontana=(dist>InpPdfLontanoAtr);
   if(lontana && InpPdfAperturaLontana==NC_LONTANA_SALTA){ Esito(IMB_LONTANA); Log(StringFormat("tocco %s %s SCARTATO: apertura lontana dalla linea (%.2f ATR > %.2f)",gTag[L],Lato(s),dist,InpPdfLontanoAtr)); return; }
   if(Aperti()>=InpMaxSetupAperti){ Esito(IMB_SEMAFORO); return; }
   int np0,no0; ContaLinea(L,np0,no0);   // GUARDIA ANTI-DUPLICATO [CASA]
   if(np0>0 || no0>0){ Esito(IMB_OCCUPATA); Log(StringFormat("%s: guardia anti-duplicato (%d posizioni, %d pendenti ancora sul conto)",gTag[L],np0,no0)); return; }
   EntraPdf(L,s,last,nEp,chiave,lontana,lv0,dist,adx,incl,dc);
  }

void EntraPdf(const int L,const int s,const int last,const int toccoN,const datetime chiave,const bool lontana,
              const double lv0,const double dist,const double adx,const double incl,const double dc)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double p[3]; p[2]=0;
   bool mercato=!lontana;
   if(mercato)
     {
      p[0]=(s>0) ? ask : bid;
      p[1]=NormPrezzo(p[0]-s*InpPdfDistanzaSecondo*gU);
     }
   else
     {
      p[0]=NormPrezzo(lv0);
      p[1]=NormPrezzo(lv0-s*InpPdfDistanzaSecondo*gU);
     }
   double sl=NormPrezzo(NC_Stop(gSLCrit,s,NormPrezzo(lv0),p[1],Estremo(s,last),InpSLBuffer*gU));
   double e14=Buf1(hEma14,0), e89=Buf1(hEma89,0);
   double tp[3]; tp[2]=0;
   double tp1=0;
   bool ok[3]; ok[2]=false;
   int nOk=0;
   for(int i=0;i<2;i++)
     {
      double t1=0;
      if(gTPCrit==2) tp[i]=NC_TpEma(s,p[i],sl,e14,e89,gRRMin,t1);
      else tp[i]=NC_TpFisso(gTPCrit,s,lv0,p[i],InpTPDistanza*gU);
      if(i==0) tp1=t1;
      tp[i]=(tp[i]!=0) ? NormPrezzo(tp[i]) : 0;
      ok[i]=ValidaOrdine(L,i,s,p[i],sl,tp[i],!(mercato && i==0));
      if(ok[i]) nOk++;
     }
   if(sl<=0){ Esito(IMB_NESSUNORD); gImb[IMB_O_SLND]++; return; }
   if(mercato && !ok[0]){ Esito(IMB_NESSUNORD); Log("setup "+gTag[L]+" SCARTATO: l'ordine a mercato non e' valido (TP/RR/stop)"); return; }
   if(nOk==0){ Esito(IMB_NESSUNORD); return; }
   double lot[3];
   CalcolaLotti(L,2,(int)InpPesiPdf,p,sl,ok,dc,lot);
   ResetSetup(L);
   gSet[L].attivo=true; gSet[L].tipo=NC_TIPO_PDF; gSet[L].lato=s; gSet[L].toccoN=toccoN;
   gSet[L].tEpisodio=chiave; gSet[L].tSetup=gTbar0; gSet[L].linea=lv0; gSet[L].sl=sl; gSet[L].tp1=tp1;
   gSet[L].rischioSoldi=RischioSoldi(dc); gSet[L].adx=adx; gSet[L].incl=incl; gSet[L].conflDist=dc;
   gSet[L].conflEtichetta=(dc<=InpConflTolAtr) ? 1 : 0; gSet[L].distApertura=dist;
   gSet[L].tScadenza=gTbar0+(datetime)(((InpScadenzaBarre>1) ? InpScadenzaBarre : 1)*PeriodSeconds(gTF));
   ContestoLog(L,last);
   double ped=Pedaggio();
   int piazzati=0;
   for(int i=0;i<2;i++)
     {
      gSet[L].prezzo[i]=p[i]; gSet[L].tp[i]=tp[i];
      gSet[L].stopPed[i]=(ped>0) ? MathAbs(p[i]-sl)/ped : 0;
      if(!ok[i]) continue;
      if(lot[i]<=0){ gImb[IMB_O_LOTTO]++; Log(StringFormat("SCARTATO %s O%d: lotto sotto il minimo (mai alzato al minimo)",gTag[L],i+1)); if(mercato && i==0) break; continue; }
      AvvisoCosto(L,i,gSet[L].stopPed[i]);
      string cm=Commento(L,i);
      bool inviato=false;
      if(mercato && i==0) inviato=InviaMercato(s,lot[i],sl,tp[i],cm);
      else inviato=InviaLimit(s,p[i],lot[i],sl,tp[i],gSet[L].tScadenza,cm,true);
      if(inviato){ gSet[L].lotto[i]=lot[i]; piazzati++; }
      else if(mercato && i==0) break;   // [NOSTRA] senza la tranche a mercato il pendente da solo non parte
     }
   gSet[L].nOrdini=piazzati;
   if(piazzati==0){ ResetSetup(L); Esito(IMB_NESSUNORD); return; }
   gUltimoEp[L]=chiave;     // nessun secondo setup sullo stesso episodio (X10), anche se i pendenti scadono
   Log(StringFormat("SETUP %s %s %s: tocco n.%d, linea %s, SL %s, TP1 %s, ordini %d, ADX %.1f, incl %.2f, confl %.2f ATR, apertura a %.2f ATR",
                    gTag[L],Lato(s),mercato ? "mercato+pendente" : "due pendenti",toccoN,P(lv0),P(sl),P(tp1),piazzati,adx,incl,dc,dist));
   if(InpPesiPdf!=NC_PESI_1_1) Log("AVVISO BANDIERA 2/3 PDF attiva su questo setup (pesi 1:2)");
   Esito(IMB_ENTRATO);
   Sincronizza();
  }

//==================================================================
//  ORDINI
//==================================================================
string Commento(const int L,const int i){ return InpComment+"_"+gLettera+"_"+gTag[L]+"_O"+IntegerToString(i+1); }

//--- validita' geometrica + vincoli del broker. pendente=false per la tranche a mercato.
bool ValidaOrdine(const int L,const int i,const int s,const double price,const double sl,const double tp,const bool pendente)
  {
   int v=NC_OrdineValido(s,price,sl,tp,1.0*gU,gRRMin);
   bool primo=!gArmatoPrima[L];
   if(v==1){ gImb[IMB_O_TPCORTO]++; if(primo) Log(StringFormat("SCARTATO %s O%d: TP non oltre l'ingresso di almeno 1 u (X5)",gTag[L],i+1)); return false; }
   if(v==2){ gImb[IMB_O_RR]++; if(primo) Log(StringFormat("SCARTATO %s O%d: R/R sotto %.2f (X7)",gTag[L],i+1,gRRMin)); return false; }
   if(v==3){ gImb[IMB_O_SLND]++; if(primo) Log(StringFormat("SCARTATO %s O%d: stop non calcolabile o dal lato sbagliato",gTag[L],i+1)); return false; }
   if(pendente)
     {
      int c=ControllaPendente(s,price,sl,tp);
      if(c==1){ gImb[IMB_O_PREZZO]++; if(primo) Log(StringFormat("SCARTATO %s O%d: prezzo %s gia' superato dal mercato o troppo vicino",gTag[L],i+1,P(price))); return false; }
      if(c==2){ gImb[IMB_O_STOPS]++; if(primo) Log(StringFormat("SCARTATO %s O%d: SL/TP dentro lo stops level",gTag[L],i+1)); return false; }
     }
   else
     {
      double md=MinDist();
      if(MathAbs(price-sl)<md || MathAbs(tp-price)<md){ gImb[IMB_O_STOPS]++; Log(StringFormat("SCARTATO %s O%d: SL/TP dentro lo stops level",gTag[L],i+1)); return false; }
     }
   return true;
  }

double RischioSoldi(const double dc)
  {
   return NC_RischioSoldi(AccountInfoDouble(ACCOUNT_BALANCE),InpRischioSetupPct,InpMoltConfluenza,dc,InpConflTolAtr,gRischioMax);   // B3 troncata
  }

void CalcolaLotti(const int L,const int nOrd,const int pesi,const double &p[],const double sl,const bool &ok[],const double dc,double &lot[])
  {
   double w[3], pl[3];
   for(int i=0;i<3;i++)
     {
      lot[i]=0;
      w[i]=(i<nOrd && ok[i]) ? NC_Peso(nOrd,pesi,i) : 0.0;
      pl[i]=(w[i]>0) ? PerditaPerLotto(MathAbs(p[i]-sl)) : 0.0;
     }
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double vmin=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double vmax=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(step<=0) step=0.01;
   NC_LottiSetup(RischioSoldi(dc),w,pl,3,step,vmin,vmax,lot);
  }

void AvvisoCosto(const int L,const int i,const double sp)
  {
   if(InpCancelloCostoX>0 && sp>0 && sp<InpCancelloCostoX)
     {
      gImb[IMB_O_COSTO]++;
      if(!gArmatoPrima[L]) Log(StringFormat("AVVISO COSTO %s O%d: stop/pedaggio %.1fx sotto il cancello %.0fx (SOLO diagnostica, l'ordine parte)",gTag[L],i+1,sp,InpCancelloCostoX));
     }
  }

bool InviaLimit(const int s,const double price,const double lot,const double sl,const double tp,const datetime scad,
                const string cm,const bool logga)
  {
   if(sl<=0){ gImb[IMB_O_SLND]++; return false; }     // MAI un ordine senza stop
   //--- firme B1/C1: immediatamente prima dell'invio di APERTURA (libreria r.57-66)
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"EA_NatCla")){ gImb[IMB_O_GUARDIAN]++; if(logga) Log("ORDINE "+cm+" FERMATO dal Guardian"); return false; }
   ENUM_ORDER_TYPE_TIME tt=ORDER_TIME_GTC;
   datetime ex=0;
   if(scad>0 && gScadServer){ tt=ORDER_TIME_SPECIFIED; ex=scad; }
   bool ok=(s>0) ? gTrade.BuyLimit(lot,price,_Symbol,sl,tp,tt,ex,cm)
                 : gTrade.SellLimit(lot,price,_Symbol,sl,tp,tt,ex,cm);
   if(!ok || !EsitoOk())
     {
      gImb[IMB_O_INVIO]++;
      Log(StringFormat("INVIO FALLITO %s: retcode %d %s",cm,(int)gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription()));
      return false;
     }
   gImb[IMB_O_PIAZZATI]++;
   if(logga) Log(StringFormat("ORDINE %s %s LIMIT %s lot @ %s SL %s TP %s",cm,(s>0) ? "BUY" : "SELL",D(lot,2),P(price),P(sl),P(tp)));
   return true;
  }

bool InviaMercato(const int s,const double lot,const double sl,const double tp,const string cm)
  {
   if(sl<=0){ gImb[IMB_O_SLND]++; return false; }     // MAI un ordine senza stop
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"EA_NatCla")){ gImb[IMB_O_GUARDIAN]++; Log("ORDINE "+cm+" FERMATO dal Guardian"); return false; }
   double px=(s>0) ? SymbolInfoDouble(_Symbol,SYMBOL_ASK) : SymbolInfoDouble(_Symbol,SYMBOL_BID);
   bool ok=(s>0) ? gTrade.Buy(lot,_Symbol,px,sl,tp,cm) : gTrade.Sell(lot,_Symbol,px,sl,tp,cm);
   if(!ok || !EsitoOk())
     {
      gImb[IMB_O_INVIO]++;
      Log(StringFormat("INVIO FALLITO %s: retcode %d %s",cm,(int)gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription()));
      return false;
     }
   gImb[IMB_O_PIAZZATI]++;
   Log(StringFormat("ORDINE %s %s MERCATO %s lot @ %s SL %s TP %s",cm,(s>0) ? "BUY" : "SELL",D(lot,2),P(px),P(sl),P(tp)));
   return true;
  }

//==================================================================
//  SCANSIONE DEL CONTO (stateless: il conto e' la verita')
//==================================================================
int LineaDaCommento(const string c)
  {
   if(StringFind(c,InpComment+"_")!=0) return -1;
   for(int L=0;L<NC_NL;L++) if(StringFind(c,"_"+gTag[L]+"_O")>0) return L;
   return -1;
  }

void ContaLinea(const int L,int &nPos,int &nOrd)
  {
   nPos=0; nOrd=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(PositionGetString(POSITION_COMMENT))==L) nPos++;
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))==L) nOrd++;
     }
  }

int ContaOrfani()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==gMagic &&
         LineaDaCommento(PositionGetString(POSITION_COMMENT))<0) n++;
     }
   return n;
  }

//--- E7: setup "aperti" (riempiti, oppure PDF con pendenti vivi) + orfani
int Aperti()
  {
   int n=0;
   for(int L=0;L<NC_NL;L++) if(gSet[L].attivo && (gSet[L].riempito || gSet[L].tipo==NC_TIPO_PDF)) n++;
   if(gOrfani>0) n++;
   return n;
  }

void CancellaOrdiniLinea(const int L,const string motivo)
  {
   int n=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(OrderGetString(ORDER_COMMENT))!=L) continue;
      if(gTrade.OrderDelete(t)) n++;
     }
   if(n>0 && motivo!="") Log(StringFormat("%s: cancellati %d pendenti (%s)",gTag[L],n,motivo));
  }

void CancellaSetupNonRiempito(const int L,const string motivo)
  {
   CancellaOrdiniLinea(L,motivo);
   ResetSetup(L);
  }

void ChiudiPosizioniLinea(const int L)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(PositionGetString(POSITION_COMMENT))!=L) continue;
      gTrade.PositionClose(tk);
     }
  }

void ResetSetup(const int L)
  {
   gSet[L].attivo=false; gSet[L].riempito=false; gSet[L].tp1Fatto=false; gSet[L].residuiCancellati=false;
   gSet[L].adottato=false; gSet[L].tipo=0; gSet[L].lato=0; gSet[L].toccoN=0; gSet[L].nOrdini=0; gSet[L].motivoEA=0;
   gSet[L].tEpisodio=0; gSet[L].tSetup=0; gSet[L].tRiempimento=0; gSet[L].tScadenza=0;
   gSet[L].linea=0; gSet[L].sl=0; gSet[L].tp1=0; gSet[L].rischioSoldi=0; gSet[L].adx=0; gSet[L].incl=0;
   gSet[L].conflDist=0; gSet[L].conflEtichetta=0; gSet[L].ema9=0; gSet[L].ema21=0; gSet[L].bbLarg=0; gSet[L].atr=0;
   gSet[L].spread=0; gSet[L].distApertura=0; gSet[L].nPosId=0;
   for(int i=0;i<3;i++){ gSet[L].prezzo[i]=0; gSet[L].tp[i]=0; gSet[L].lotto[i]=0; gSet[L].stopPed[i]=0; }
   for(int i=0;i<8;i++) gSet[L].posId[i]=0;
  }

void ContestoLog(const int L,const int last)
  {
   gSet[L].atr=gAtrN[last];
   gSet[L].spread=SymbolInfoDouble(_Symbol,SYMBOL_ASK)-SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(InpLogContesto)
     {
      gSet[L].ema9=Buf1(hEma9,0); gSet[L].ema21=Buf1(hEma21,0);
      gSet[L].bbLarg=Buf1(hBands,1)-Buf1(hBands,2);
     }
  }

//--- reload-safe [CASA: GUARDIA ANTI-DUPLICATO, es. ABTG_Nightly r.157-163]:
//    posizioni/pendenti del mio magic presenti all'avvio = setup gia' in
//    corso. Le posizioni si ADOTTANO (SL/TP vivono sul server, nessun
//    nuovo ordine sulla stessa linea finche' non chiudono). I pendenti di
//    una linea SENZA posizioni si cancellano: la barra successiva li
//    riarma dai dati (scala) o non li rimette (PDF, episodio gia' usato
//    non ricostruibile: lato prudente).
void AdottaEsistenti()
  {
   gOrfani=ContaOrfani();
   if(gOrfani>0) Log(StringFormat("AVVIO: %d posizioni del magic %s senza etichetta di linea: occupano il semaforo finche' non chiudono",gOrfani,IntegerToString(gMagic)));
   for(int L=0;L<NC_NL;L++)
     {
      int np,no;
      ContaLinea(L,np,no);
      if(np>0)
        {
         AdottaLinea(L);
         Log(StringFormat("AVVIO: ADOTTATO setup %s con %d posizioni e %d pendenti (TP1/pareggio non ricostruibili dopo un riavvio)",gTag[L],np,no));
        }
      else
         if(no>0) CancellaOrdiniLinea(L,"avvio: pendenti senza posizione, si riarmano dai dati");
     }
  }

//--- adotta le posizioni di una linea senza setup in memoria (riavvio, oppure
//    un limit riempito mentre veniva cancellato per il riprezzamento)
void AdottaLinea(const int L)
  {
   ResetSetup(L);
   gSet[L].attivo=true; gSet[L].riempito=true; gSet[L].adottato=true;
   gSet[L].tipo=(gIngresso==0) ? NC_TIPO_SCALA : NC_TIPO_PDF; gSet[L].tRiempimento=TimeCurrent();
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(PositionGetString(POSITION_COMMENT))!=L) continue;
      gSet[L].lato=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) ? 1 : -1;
      gSet[L].sl=PositionGetDouble(POSITION_SL);
      datetime pt=(datetime)PositionGetInteger(POSITION_TIME);
      if(pt<gSet[L].tRiempimento) gSet[L].tRiempimento=pt;
      AggiungiPosId(L,(ulong)PositionGetInteger(POSITION_IDENTIFIER));
     }
   gSet[L].tSetup=gSet[L].tRiempimento;
  }

void AggiungiPosId(const int L,const ulong id)
  {
   for(int i=0;i<gSet[L].nPosId;i++) if(gSet[L].posId[i]==id) return;
   if(gSet[L].nPosId<8){ gSet[L].posId[gSet[L].nPosId]=id; gSet[L].nPosId++; }
  }

//==================================================================
//  GESTIONE SUI TICK (il segnale NON si rivaluta qui: solo gestione)
//==================================================================
void Sincronizza()
  {
   gOrfani=ContaOrfani();
   for(int L=0;L<NC_NL;L++)
     {
      int np,no;
      ContaLinea(L,np,no);
      if(!gSet[L].attivo)
        {
         if(np>0)
           {
            AdottaLinea(L);
            Log(StringFormat("ADOTTATO %s: %d posizioni senza setup in memoria (riempimento durante una cancellazione?)",gTag[L],np));
            if(Aperti()>InpMaxSetupAperti)
              {
               gImb[IMB_SEM_SFORATO]++;
               Log(StringFormat("AVVISO SEMAFORO SFORATO: %d setup riempiti contro un massimo di %d",Aperti(),InpMaxSetupAperti));
              }
           }
         continue;
        }
      //--- registra gli ID delle posizioni della linea
      if(np>0)
         for(int i=PositionsTotal()-1;i>=0;i--)
           {
            ulong tk=PositionGetTicket(i);
            if(tk==0) continue;
            if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
            if(LineaDaCommento(PositionGetString(POSITION_COMMENT))!=L) continue;
            AggiungiPosId(L,(ulong)PositionGetInteger(POSITION_IDENTIFIER));
           }
      //--- primo riempimento
      if(np>0 && !gSet[L].riempito)
        {
         gSet[L].riempito=true;
         gSet[L].tRiempimento=TimeCurrent();
         gUltimoEp[L]=gSet[L].tEpisodio;
         gImb[IMB_RIEMPITI]++;
         Log(StringFormat("RIEMPITO %s %s (tocco n.%d)",gTag[L],Lato(gSet[L].lato),gSet[L].toccoN));
         //--- E7 semaforo: cancella gli ordini ARMATI delle altre linee
         if(Aperti()>=InpMaxSetupAperti)
            for(int K=0;K<NC_NL;K++)
               if(K!=L && gSet[K].attivo && !gSet[K].riempito && gSet[K].tipo==NC_TIPO_SCALA)
                 { CancellaSetupNonRiempito(K,"semaforo: riempito "+gTag[L]); gArmatoPrima[K]=false; }
         if(Aperti()>InpMaxSetupAperti)
           {
            gImb[IMB_SEM_SFORATO]++;
            Log(StringFormat("AVVISO SEMAFORO SFORATO: %d setup riempiti contro un massimo di %d (riempimenti nello stesso intervallo di prezzo)",Aperti(),InpMaxSetupAperti));
           }
        }
      if(gSet[L].riempito)
        {
         //--- X10: una posizione del setup e' gia' uscita (TP o SL): via i pendenti residui
         if(no>0 && np<gSet[L].nPosId && !gSet[L].residuiCancellati)
           { CancellaOrdiniLinea(L,"X10: prima uscita del setup"); gSet[L].residuiCancellati=true; }
         if(np>0) GestisciTP1(L);
         //--- X9: durata massima dal primo riempimento
         if(np>0 && InpDurataMaxMin>0 && TimeCurrent()-gSet[L].tRiempimento>=(long)InpDurataMaxMin*60)
           {
            gSet[L].motivoEA=1;
            CancellaOrdiniLinea(L,"X9 durata massima");
            ChiudiPosizioniLinea(L);
            Log(StringFormat("USCITA %s per durata massima (%d min)",gTag[L],InpDurataMaxMin));
            ContaLinea(L,np,no);
           }
         if(np==0){ ChiudiSetup(L); continue; }
        }
      else
        {
         //--- E6: scadenza logica dei pendenti PDF (anche se il server non la gestisce)
         if(gSet[L].tipo==NC_TIPO_PDF && gSet[L].tScadenza>0 && TimeCurrent()>=gSet[L].tScadenza && no>0)
           { CancellaOrdiniLinea(L,"E6 scadenza pendenti"); ContaLinea(L,np,no); }
         if(no==0 && np==0)
           {
            if(gSet[L].tipo==NC_TIPO_PDF)
              {
               ScriviRiga("SETUP",L,0,0.0,0,"SCADUTO_SENZA_RIEMPIMENTO");
               Log(StringFormat("SETUP %s chiuso senza riempimenti (pendenti scaduti o rifiutati)",gTag[L]));
              }
            ResetSetup(L);
           }
        }
     }
  }

//--- X8 [FONTE P-p17 "posso"]: parziale e pareggio al primo obiettivo (EMA14 congelata)
void GestisciTP1(const int L)
  {
   if(gSet[L].tp1Fatto || gSet[L].tp1<=0) return;
   if(InpParzialeTP1Pct<=0 && !gBE) return;
   int s=gSet[L].lato;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   bool hit=(s>0) ? (bid>=gSet[L].tp1) : (ask<=gSet[L].tp1);
   if(!hit) return;
   gSet[L].tp1Fatto=true;
   double sv=0, spv=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(PositionGetString(POSITION_COMMENT))!=L) continue;
      double v=PositionGetDouble(POSITION_VOLUME);
      sv+=v; spv+=v*PositionGetDouble(POSITION_PRICE_OPEN);
     }
   if(sv<=0) return;
   double medio=NormPrezzo(spv/sv);   // [NOSTRA] pareggio al prezzo medio ponderato (P par. F-21)
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP), vmin=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double md=MinDist();
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=gMagic) continue;
      if(LineaDaCommento(PositionGetString(POSITION_COMMENT))!=L) continue;
      double v=PositionGetDouble(POSITION_VOLUME);
      double slNow=PositionGetDouble(POSITION_SL), tpNow=PositionGetDouble(POSITION_TP);
      if(InpParzialeTP1Pct>0)
        {
         double cv=NC_LottoGiu(v*InpParzialeTP1Pct/100.0,step,vmin,0);
         if(cv>0 && cv<v) gTrade.PositionClosePartial(tk,cv);
        }
      if(gBE)
        {
         bool migliora=(s>0) ? (medio>slNow) : (medio<slNow || slNow==0);
         bool lecito=(s>0) ? (medio<bid-md) : (medio>ask+md);
         if(migliora && lecito && PositionSelectByTicket(tk)) gTrade.PositionModify(tk,medio,tpNow);
        }
     }
   CancellaOrdiniLinea(L,"TP1 raggiunto [NOSTRA]: nessun nuovo riempimento dopo il pareggio");
   Log(StringFormat("TP1 %s raggiunto (%s): parziale %.0f%%, pareggio %s a %s",gTag[L],P(gSet[L].tp1),InpParzialeTP1Pct,gBE ? "si" : "no",P(medio)));
  }

//--- fine setup: esito dalla cronologia, riga nel CSV, log d'uscita
void ChiudiSetup(const int L)
  {
   CancellaOrdiniLinea(L,"fine setup: residui");
   double soldi=0; int nRiemp=0; datetime tUltima=0; int reason=-1;
   if(HistorySelect(gSet[L].tSetup-PeriodSeconds(gTF),TimeCurrent()+60))
     {
      int nd=HistoryDealsTotal();
      for(int i=0;i<nd;i++)
        {
         ulong tk=HistoryDealGetTicket(i);
         if(tk==0) continue;
         ulong pid=(ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
         bool mio=false;
         for(int k=0;k<gSet[L].nPosId;k++) if(gSet[L].posId[k]==pid) mio=true;
         if(!mio) continue;
         soldi+=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
         long en=HistoryDealGetInteger(tk,DEAL_ENTRY);
         if(en==DEAL_ENTRY_IN) nRiemp++;
         if(en==DEAL_ENTRY_OUT || en==DEAL_ENTRY_OUT_BY)
           {
            datetime td=(datetime)HistoryDealGetInteger(tk,DEAL_TIME);
            if(td>=tUltima){ tUltima=td; reason=(int)HistoryDealGetInteger(tk,DEAL_REASON); }
           }
        }
     }
   string motivo="ALTRO";
   if(gSet[L].motivoEA==1) motivo="DURATA";
   else
      if(reason==DEAL_REASON_SL) motivo="SL";
      else
         if(reason==DEAL_REASON_TP) motivo="TP";
         else
            if(reason==DEAL_REASON_EXPERT) motivo="EA";
   double dur=(tUltima>gSet[L].tRiempimento) ? (double)(tUltima-gSet[L].tRiempimento)/60.0 : 0;
   double R=(gSet[L].rischioSoldi>0) ? soldi/gSet[L].rischioSoldi : 0;
   gImb[IMB_CHIUSI]++;
   ScriviRiga("SETUP",L,nRiemp,soldi,dur,motivo);
   Log(StringFormat("USCITA %s %s: esito %s = %.2f R, riempiti %d, durata %.0f min, motivo %s%s",gTag[L],Lato(gSet[L].lato),
                    D(soldi,2),R,nRiemp,dur,motivo,gSet[L].adottato ? " (setup adottato dopo un riavvio)" : ""));
   ResetSetup(L);
  }

//--- C9: meta' della candela del tocco, dai minuti M1 (0 = n/d)
int TimingTocco(const int s,const double lv,const datetime tBar)
  {
   int per=PeriodSeconds(gTF);
   double tol=(InpToccoDef==NC_TOCCO_SFIORA) ? InpSfioraAtr*gAtrN[gN-2] : 0;
   MqlRates m[];
   ArraySetAsSeries(m,false);
   int got=CopyRates(_Symbol,PERIOD_M1,tBar,tBar+per-1,m);
   if(got<=0) return 0;
   for(int i=0;i<got;i++)
     {
      bool t=(s>0) ? (m[i].low<=lv+tol) : (m[i].high>=lv-tol);
      if(t) return NC_MetaTocco((long)(m[i].time-tBar),(long)per);
     }
   return 0;
  }

//==================================================================
//  CSV PER-SETUP (par. 2.6)
//==================================================================
void ScriviRiga(const string tipo,const int L,const int nRiemp,const double soldi,const double dur,const string motivo)
  {
   if(gFh==INVALID_HANDLE) return;
   double R=(gSet[L].rischioSoldi>0) ? soldi/gSet[L].rischioSoldi : 0;
   string r=tipo+";"+TimeToString(gSet[L].tSetup,TIME_DATE|TIME_MINUTES)+";"+gTag[L]+";"+IntegerToString(gSet[L].lato)+";"+
            IntegerToString(gSet[L].toccoN)+";;;;;;;"+D(gSet[L].distApertura,3)+";"+D(gSet[L].adx,2)+";"+D(gSet[L].incl,3)+";"+
            D(gSet[L].conflDist,3)+";"+IntegerToString(gSet[L].conflEtichetta)+";"+P(gSet[L].ema9)+";"+P(gSet[L].ema21)+";"+
            P(gSet[L].bbLarg)+";"+P(gSet[L].atr)+";"+P(gSet[L].linea)+";"+((gSet[L].tipo==NC_TIPO_SCALA) ? "SCALA3" : "PDF")+";"+
            IntegerToString(gSet[L].nOrdini)+";"+P(gSet[L].prezzo[0])+";"+P(gSet[L].prezzo[1])+";"+P(gSet[L].prezzo[2])+";"+P(gSet[L].sl)+";"+
            P(gSet[L].tp[0])+";"+P(gSet[L].tp[1])+";"+P(gSet[L].tp[2])+";"+D(gSet[L].lotto[0],2)+";"+D(gSet[L].lotto[1],2)+";"+D(gSet[L].lotto[2],2)+";"+
            P(gSet[L].spread)+";"+P(InpCommissionePrezzo)+";"+D(gSet[L].stopPed[0],1)+";"+D(gSet[L].stopPed[1],1)+";"+D(gSet[L].stopPed[2],1)+";"+
            D(gSet[L].rischioSoldi,2)+";"+IntegerToString(nRiemp)+";"+D(soldi,2)+";"+D(R,3)+";"+D(dur,1)+";"+motivo;
   FileWrite(gFh,r);
   FileFlush(gFh);
  }

//--- InpSoloConta: una riga per OGNI barra che tocca la linea, con tutti i
//    flag, cosi' il passo 0 filtra a posteriori senza girare passate in piu'
void ScriviConta(const int L,const int last,const int nEp,const bool nuovo,const bool troncato)
  {
   if(gFh==INVALID_HANDLE) return;
   int s=(int)gLD[last];
   double a1,i1,d1,a0,i0,d0;
   int ctxArm=(last>=1) ? Contesto(L,s,last-1,a1,i1,d1) : -1;
   int ctxTocco=Contesto(L,s,last,a0,i0,d0);
   double atr=gAtrN[last];
   double lvT=gLV[last-1]+s*InpPlaceboAtr*gAtrN[last-1];
   bool vicino=(gChiudeVicino<=0) || (atr>0 && MathAbs(gC[last]-lvT)<=gChiudeVicino*atr);
   double op0=iOpen(_Symbol,gTF,0);
   double lv0=LineaPrezzo(last,s);
   bool conf=(s*(op0-lv0)>0);
   double dist=(atr>0) ? MathAbs(op0-lv0)/atr : 0;
   //--- geometria della scala sulla linea della barra dopo (per stop/pedaggio)
   double p[3];
   NC_PrezziScala(lv0,s,InpScalaAnticipo,InpScalaOltre,gU,p);
   double sl=NC_Stop(gSLCrit,s,lv0,p[2],Estremo(s,last),InpSLBuffer*gU);
   double tp[3];
   for(int i=0;i<3;i++) tp[i]=NC_TpFisso((gTPCrit==1) ? 1 : 0,s,lv0,p[i],InpTPDistanza*gU);
   double ped=Pedaggio();
   double e9=0,e21=0,bb=0;
   if(InpLogContesto){ e9=Buf1(hEma9,0); e21=Buf1(hEma21,0); bb=Buf1(hBands,1)-Buf1(hBands,2); }
   string r="CONTA;"+TimeToString(gT[last],TIME_DATE|TIME_MINUTES)+";"+gTag[L]+";"+IntegerToString(s)+";"+IntegerToString(nEp)+";"+
            (nuovo ? "1" : "0")+";"+(troncato ? "1" : "0")+";"+IntegerToString(ctxArm)+";"+IntegerToString(ctxTocco)+";"+(vicino ? "1" : "0")+";"+
            (conf ? "1" : "0")+";"+D(dist,3)+";"+D(a0,2)+";"+D(i0,3)+";"+D(d0,3)+";"+((d0<=InpConflTolAtr) ? "1" : "0")+";"+
            P(e9)+";"+P(e21)+";"+P(bb)+";"+P(atr)+";"+P(lv0)+";"+((gIngresso==0) ? "SCALA3" : "PDF")+";0;"+
            P(p[0])+";"+P(p[1])+";"+P(p[2])+";"+P(sl)+";"+P(tp[0])+";"+P(tp[1])+";"+P(tp[2])+";0;0;0;"+
            P(ped-InpCommissionePrezzo)+";"+P(InpCommissionePrezzo)+";"+
            D((ped>0) ? MathAbs(p[0]-sl)/ped : 0,1)+";"+D((ped>0) ? MathAbs(p[1]-sl)/ped : 0,1)+";"+D((ped>0) ? MathAbs(p[2]-sl)/ped : 0,1)+";"+
            "0;0;0;0;0;SOLO_CONTA";
   FileWrite(gFh,r);
  }

//==================================================================
//  EXPORT PER-TRADE [CASA] (ABTG_SupertrendReversal r.711-746), esteso
//  con la colonna entry_comment IN CODA (le prime 8 colonne restano
//  identiche: dd_portafoglio.py le legge come prima). La colonna dice
//  linea e ordine (es. NATCLA_A_ST35_O2): il P/L per SETUP si somma da qui.
//==================================================================
string CommentoIngresso(const ulong pid)
  {
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if((ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID)!=pid) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)==DEAL_ENTRY_IN) return HistoryDealGetString(tk,DEAL_COMMENT);
     }
   return "";
  }

void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString(gMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","entry_comment");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      ulong pid=(ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString((long)pid),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2),
                CommentoIngresso(pid));
     }
   FileClose(h);
  }

//==================================================================//
//  OPTFRAME [CASA] (copiato da ABTG_SupertrendReversal r.696-794)  //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

double OnTester()
  {
   ExportTrades();
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME ==================================//
