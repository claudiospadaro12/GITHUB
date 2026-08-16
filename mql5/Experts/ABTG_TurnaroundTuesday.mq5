//+------------------------------------------------------------------+
//|                                  ABTG_TurnaroundTuesday.mq5       |
//|                                                                   |
//|  EA DI LABORATORIO "TURNAROUND TUESDAY" - MT5 - TUTTO-IN-UNO      |
//|  (metti in MQL5\Experts e compila con F7: nessun include nostro)  |
//+------------------------------------------------------------------+
//|                                                                   |
//|  ATTRIBUZIONE (obbligatoria - S.9 del cacciatore)                 |
//|                                                                   |
//|   Meccanica di ingresso derivata da "001 - Turnaround Tuesday"    |
//|   Copyright 2026, Sergei Ermolov (dj_ermoloff) | IT Trader        |
//|     scheda:   https://www.mql5.com/en/code/73674                  |
//|     sorgente: https://www.mql5.com/en/code/download/73674/        |
//|               001-Turnaround-Tuesday.mq5                          |
//|     autore:   https://www.mql5.com/en/users/dj_ermoloff           |
//|   Pubblicato 05/06/2026, versione 1.1, 306 righe, 11.475 byte.    |
//|   Scaricato e letto per intero il 16/08/2026.                     |
//|                                                                   |
//|   LICENZA: NON dichiarata nel file (c'e' solo il copyright); la   |
//|   scheda del Code Base dichiara sorgente aperto e modificabile.   |
//|   [INCERTO] -> uso INTERNO DI RICERCA. Prima di qualunque         |
//|   distribuzione la licenza va verificata.                         |
//|                                                                   |
//|   NON adottiamo i suoi parametri ne' il suo filtro ATR: prendiamo |
//|   la MECCANICA e la TESI. Il verdetto lo da' il nostro imbuto.    |
//|                                                                   |
//|   TESI DI MERCATO: short-term reversal / liquidity provision      |
//|     Quantpedia, "Short Term Reversal Effect in Stocks"            |
//|     https://quantpedia.com/strategies/short-term-reversal-in-stocks
//|     fonte primaria citata: de Groot, Huij, Zhou, SSRN 1605049     |
//|     (NON letto: SSRN risponde 403 dal nostro ambiente)            |
//|   Letteratura CONTRO, dichiarata: Bariviera-Plastino-Judge,       |
//|     arXiv 1801.07941 - l'effetto giorno-della-settimana e' in     |
//|     parte un artefatto della struttura di correlazione, testato   |
//|     su 83 indici. Per questo si misura, non si assume.            |
//|                                                                   |
//|  FONTE NORMATIVA INTERNA (VINCOLANTE, scritta PRIMA del codice)   |
//|   1. backtest_pipeline/prove/ABTG_TurnaroundTuesday.txt           |
//|      (ipotesi + criteri di accettazione congelati il 16/08/2026)  |
//|   2. caccia_strategie/CACCIA_2026-08-16_D_LATERALE.md  (buco n.1) |
//|   3. caccia_strategie/CACCIA_2026-08-16_F_SHORT.md     (buco n.3) |
//|   I NOMI DEGLI INPUT SONO VINCOLANTI: devono combaciare con il    |
//|   file prova, altrimenti MT5 ignora quelle righe IN SILENZIO.     |
//|                                                                   |
//+------------------------------------------------------------------+
//|                                                                   |
//|  LA STRATEGIA, IN UNA RIGA                                        |
//|     lunedi' ROSSO -> si COMPRA martedi'                           |
//|     lunedi' VERDE -> si VENDE  martedi'                           |
//|                                                                   |
//|  E' TUTTO. Non c'e' nessun indicatore che decide la direzione:    |
//|  la decide IL SEGNO DEL CORPO DEL LUNEDI'.                        |
//|                                                                   |
//|  MAPPA REGOLA -> CODICE                                           |
//|   OnTick                                                          |
//|     - metrica prop "peggior giornata %" (a ogni tick);            |
//|     - chiusura forzata a InpCloseHourServer (ORA SERVER);         |
//|     - cancello a NUOVA BARRA di InpTF: e' li' che l'EA si sveglia |
//|       per guardare l'orologio;                                    |
//|     - cancello a UN SOLO tentativo per GIORNO DI CALENDARIO.      |
//|   ValutaIngresso                                                  |
//|     - oggi deve essere MARTEDI' e l'ultimo giorno CHIUSO deve     |
//|       essere LUNEDI' (le settimane corte/festive cadono qui, e    |
//|       il funnel le conta: vedi cPrecNonLunedi);                   |
//|     - ora server >= InpEntryHourServer (0 = come l'autore, cioe'  |
//|       il rollover; 8 = apertura della liquidita' europea);        |
//|     - candela del lunedi' letta con iOpen/iHigh/iLow/iClose su    |
//|       PERIOD_D1 shift 1 -> vedi CORREZIONE 2 nel changelog;       |
//|     - isBullish = closeLun > openLun ;  tradeUp = !isBullish .    |
//|   CalcolaStop / CalcolaLotto / ApriPosizione                      |
//|     - SL = InpSLDailyATRMult x ATR(D1,InpATRPeriodD1) della       |
//|       barra CHIUSA (shift 1), con pavimento allo STOPS_LEVEL;     |
//|       SL VERO mandato al broker nell'ordine, mai virtuale;        |
//|     - TP = InpTP_R x la distanza di stop (multiplo di R), con     |
//|       lo stesso pavimento (vedi DIFETTO NUOVO n.1);               |
//|     - lotto dal rischio % sull'EQUITY CORRENTE, perdita per       |
//|       lotto chiesta al broker con OrderCalcProfit.                |
//|                                                                   |
//|  UNA POSIZIONE ALLA VOLTA, UN TRADE A SETTIMANA. Niente griglia,  |
//|  niente averaging, niente martingala, mai. Niente trailing,       |
//|  niente breakeven, niente parziale: NON fanno parte della tesi e  |
//|  non sono nel file prova. Si innestano DOPO, se il motore vive.   |
//|                                                                   |
//|  [ORARI] TUTTI IN ORA SERVER (TimeCurrent), MAI ora locale.       |
//|     Regola fissa di progetto: ORA SERVER BCM = ora italiana - 1.  |
//|       apertura DAX      09:00 IT = 8  server                      |
//|       apertura Nasdaq   15:30 IT = 14:30 server                   |
//|       chiusura forzata  23:00 IT = 22 server                      |
//|     Controllo rapido sul CSV: la colonna InpEntryHourServer deve  |
//|     dire 8 (o 0). Se dice 9, e' ora italiana -> numeri da         |
//|     cestinare.                                                    |
//|                                                                   |
//|  [SPENTO] IL FILTRO ATR DELL'AUTORE RESTA NEL CODICE MA SPENTO    |
//|     (InpUseATRFilter = false, e il file prova lo pinna a 0).      |
//|     L'autore dichiara che il motore NUDO ha "minimal edge" e che  |
//|     i numeri diventano belli col filtro acceso. Da noi quella     |
//|     forma - "motore mediocre + filtro che lo salva" - ha 0        |
//|     successi su 5 (R20, R12, R26, R45, R54). Quindi: si misura    |
//|     IL MOTORE NUDO. Se il motore nudo e' rosso LA FAMIGLIA SI     |
//|     CHIUDE e NON si ripesca accendendo questa manopola.           |
//|                                                                   |
//|  [MAI] COSA NON SI TOCCA, MAI                                     |
//|     - `bool tradeUp = !isBullish;`  e' l'edge, non un parametro;  |
//|     - GIORNO_CONTROLLO e GIORNO_OPERATIVO sono `const`, NON       |
//|       input. Il fratello "003 - Weekly Day Reversal" dello        |
//|       stesso autore li mette fra gli input, e PER QUESTO e'       |
//|       stato respinto: mette il segno dell'edge fra le manopole.   |
//|     - InpAllowLong / InpAllowShort NON scelgono la direzione:     |
//|       sono una MASCHERA DIAGNOSTICA (vedi il commento sopra di    |
//|       loro). Non vanno MAI spazzolati come asse di griglia.       |
//|                                                                   |
//|  DEMO. Nessuna garanzia. NON compilato ne' testato dall'autore    |
//|  del codice: il primo compile in MetaEditor e il primo backtest   |
//|  sono di Claudio.                                                 |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.00 - 16/08/2026 - Adozione dell'originale. Il MOTORE non e'    |
//|         stato toccato; e' stata rifatta la GESTIONE. Le           |
//|         correzioni, una per una:                                  |
//|                                                                   |
//|   CORREZIONE 1 - OnTester (blocco duro).                          |
//|     L'originale non ce l'ha e walkforward_generico.ps1 (righe     |
//|     143-147) rifiuta di partire. Qui c'e' il blocco OPTFRAME      |
//|     inlined, modello ABTG_BreakingBand.mq5 (righe 1441-1577),     |
//|     con le TRE COLONNE PROP: Peggior Giornata %, Perdite          |
//|     Consecutive Max, Serie Perdente Peggiore. Piu' ExportTrades() |
//|     e PrintFunnel(). NIENTE #include nostri: tutto-in-uno.        |
//|                                                                   |
//|   CORREZIONE 2 - L'OFF-BY-ONE CHE BUTTAVA VIA L'ORA DI APERTURA.  |
//|     E' LA PIU' IMPORTANTE DELLE TRE. L'originale ricostruiva a    |
//|     mano la candela del lunedi' da barre H1 (GetCheckDayData,     |
//|     ~40 righe) e il ciclo di riga 296 era `i < boundaryIdx`:      |
//|     ESCLUDEVA proprio la barra di APERTURA del lunedi'. Su        |
//|     D30EUR (sessione 08:00-22:00 server) boundaryIdx e' la barra  |
//|     delle 08:00, quindi openDay diventava l'apertura delle 09:00. |
//|     Conseguenza: `isBullish` - CIOE' IL SEGNO CHE DECIDE LA       |
//|     DIREZIONE DEL TRADE - veniva calcolato SENZA la prima ora     |
//|     del lunedi'. Su un simbolo 24h l'errore vale 1 ora su 24;     |
//|     SU UN INDICE CON SESSIONE VALE 1 ORA SU 14, ED E' LA          |
//|     CAMPANELLA, cioe' l'ora piu' volatile della giornata. Anche   |
//|     highDay/lowDay (il filtro ATR) perdevano la stessa ora.       |
//|     RIMEDIO: la candela del lunedi' si legge con                  |
//|       iOpen/iHigh/iLow/iClose(_Symbol, PERIOD_D1, 1)              |
//|     che e' la primitiva che MT5 gia' offre. Le ~40 righe di       |
//|     GetCheckDayData sono sparite: erano una reimplementazione     |
//|     fragile. Meno codice E il dato giusto.                        |
//|                                                                   |
//|   CORREZIONE 3 - PositionsTotal() non filtrato (originale r.94).  |
//|     Contava le posizioni di TUTTO IL CONTO: sul nostro conto      |
//|     multi-EA questo EA SI AUTOZITTIVA ogni volta che un altro EA  |
//|     aveva una posizione aperta. In backtest da solo non si vede;  |
//|     in forward sulla flotta si', ed e' un motore che fa gia' un   |
//|     trade a settimana. Ora si conta per SIMBOLO + MAGIC           |
//|     (ContaPosizioni). Nota di equita': CloseAllPositions          |
//|     dell'originale era gia' filtrata correttamente.               |
//|                                                                   |
//|   CORREZIONE 4 - Rischio sull'EQUITY CORRENTE.                    |
//|     L'originale leggeva `balance` UNA VOLTA in OnInit (r.50) e    |
//|     l'enum lo dichiarava: "% Risk from Start Balance". E' rischio |
//|     FISSO IN VALUTA travestito da percentuale: non compone, e il  |
//|     DD% non sarebbe confrontabile con le altre 14 celle.          |
//|                                                                   |
//|   CORREZIONE 5 - Lotto via OrderCalcProfit, non                   |
//|     SYMBOL_TRADE_TICK_VALUE nudo (originale r.213-226).           |
//|     E' IL BUG CHE HA UCCISO IL ROUND 2 SUL NIKKEI: su simboli in  |
//|     yen il tick value arriva non convertito (~160x di errore) e   |
//|     il lotto finisce sempre appoggiato al minimo. Su GBPUSD non   |
//|     morde, su 225JPY si'. Si mette adesso che costa niente.       |
//|     Il ripiego col tick value resta come seconda scelta, se       |
//|     OrderCalcProfit fallisce.                                     |
//|                                                                   |
//|   CORREZIONE 6 - Magic VERGINE 774201 (verificato contro i 69 EA  |
//|     del repo: nessuna collisione) e InpComment riconoscibile.     |
//|     ATTENZIONE: il file prova pinna InpMagic=20260816. Nel        |
//|     tester il magic non conta, ma PRIMA DI QUALUNQUE FORWARD va   |
//|     deciso quale dei due vale, e messo sul grafico.               |
//|                                                                   |
//|   CORREZIONE 7 - Attribuzione completa in testa al file (sopra).  |
//|                                                                   |
//|   --- DIFETTI NUOVI TROVATI NEL SORGENTE (dichiarati, non         |
//|       corretti in silenzio) ---                                   |
//|                                                                   |
//|   DIFETTO NUOVO 1 - TP sotto lo STOPS_LEVEL con rrTP < 1.         |
//|     L'originale mette il pavimento STOPS_LEVEL SOLO sullo stop e  |
//|     poi calcola tp = slDistance * rrTP. Col suo default (2,5) non |
//|     morde mai. La NOSTRA griglia spazzola InpTP_R fino a 0,5:     |
//|     con lo stop appoggiato al pavimento, il TP finirebbe a META'  |
//|     del pavimento e il broker RIFIUTEREBBE l'ordine (invalid      |
//|     stops). Sarebbero celle vuote senza un errore evidente.       |
//|     RIMEDIO: lo stesso pavimento si applica anche alla distanza   |
//|     di TP (CalcolaStop).                                          |
//|                                                                   |
//|   DIFETTO NUOVO 2 - kDailyATR == 0 apriva SENZA SL e SENZA TP.    |
//|     Originale r.147 e 152: if (kDailyATR==0) { sl=0; tp=0; }    |
//|     Un ordine a mercato nudo, in un EA che poi si affida solo     |
//|     alla chiusura oraria. La nostra griglia non usa mai 0, ma un  |
//|     dito storto sul grafico basterebbe. RIMEDIO: OnInit FALLISCE  |
//|     se InpSLDailyATRMult <= 0. Non esiste il caso "senza stop".   |
//|                                                                   |
//|   DIFETTO NUOVO 3 - OnInit falliva per storico corto.             |
//|     Originale righe 52-57: INIT_FAILED se iBars(D1) <             |
//|     DailyATRPeriod+5. Nel tester questo NON e' prudenza: e'       |
//|     un'INTERA PASSATA PERSA, e in ottimizzazione sono celle vuote |
//|     che sembrano un risultato. RIMEDIO: qui e' un avviso a video, |
//|     e la guardia vera sta a runtime sul CopyBuffer dell'ATR (che  |
//|     e' il posto giusto: se l'ATR non c'e', non si opera).         |
//|                                                                   |
//|   DIFETTO NUOVO 4 - nessuna guardia al riavvio.                   |
//|     Lo stato "ho gia' operato oggi" dell'originale sta solo in    |
//|     memoria (lastBarTime). Un riavvio del terminale il martedi'   |
//|     mattina, dopo un trade gia' chiuso in TP, avrebbe riaperto.   |
//|     RIMEDIO: GiaOperatoOggi() rilegge lo storico dei deal del     |
//|     giorno filtrato per simbolo+magic (pattern di ABTG_GapFill).  |
//|                                                                   |
//|   DIFETTO NUOVO 5 - ingresso a qualunque ora dopo un riavvio.     |
//|     Senza finestra, un terminale riavviato alle 15:00 di martedi' |
//|     con InpEntryHourServer=8 sarebbe entrato alle 15:00, cioe'    |
//|     avrebbe misurato un'altra cosa. RIMEDIO: InpEntryWindowMin    |
//|     (default 120 min; 0 = nessun limite).                         |
//|     ATTENZIONE, LA TRAPPOLA CI SIAMO QUASI CASCATI DENTRO: la     |
//|     finestra NON si misura dall'ora nominale, ma dalla PRIMA      |
//|     BARRA UTILE DI OGGI (PrimaBarraUtileOggi). Su D30EUR, che ha  |
//|     sessione 08:00-22:00, con InpEntryHourServer=0 la prima barra |
//|     del martedi' e' quella delle 08:00: misurando dall'ora        |
//|     nominale sarebbero passati 480 minuti e LE 12 CELLE A ORA 0   |
//|     SAREBBERO TORNATE TUTTE VUOTE, IN SILENZIO - lo stesso modo   |
//|     di sbagliare che il file prova temeva per le celle a ora 8.   |
//|     Cosi' com'e', NEL TESTER LA FINESTRA NON MORDE MAI (il primo  |
//|     risveglio utile e' la barra di riferimento stessa): e' neutra |
//|     per la griglia e serve solo in forward.                       |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - adozione da S. Ermolov (mql5.com/en/code/73674)"
#property link      "https://www.mql5.com/en/code/73674"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//  ATTENZIONE: I NOMI SONO VINCOLANTI: combaciano uno a uno con le righe di
//     backtest_pipeline/prove/ABTG_TurnaroundTuesday.txt. Un nome
//     cambiato = una riga del file prova che MT5 ignora IN SILENZIO.
//==================================================================
input group "=== Timeframe operativo ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF su cui l'EA si sveglia a guardare l'orologio (H1 = TF delle celle di regime)

input group "=== Stop e target (LE DUE SOLE MANOPOLE DI STRATEGIA) ==="
input double InpSLDailyATRMult = 0.75;     // SL in frazioni di ATR(D1) della barra CHIUSA. DEVE essere > 0 (vedi DIFETTO NUOVO 2)
input double InpTP_R           = 1.5;      // TP come multiplo di R (della distanza di stop). 0 = nessun TP, si esce solo all'ora di chiusura
input int    InpATRPeriodD1    = 14;       // periodo dell'ATR giornaliero. 14 e' canonico e NON si spazzola: e' una manopola in meno

input group "=== Orari - SEMPRE IN ORA SERVER (ora italiana - 1) ==="
input int    InpEntryHourServer = 8;       // ora SERVER dell'ingresso del martedi'. 0 = come l'autore (rollover, spread massimo) | 8 = apertura liquidita' europea
input int    InpCloseHourServer = 22;      // ora SERVER della chiusura forzata (22 server = 23:00 IT)
input int    InpEntryWindowMin  = 120;     // SCELTA NOSTRA: minuti utili dopo l'ora d'ingresso (0 = nessun limite). Nel tester non morde mai: e' una sicurezza per il forward

input group "=== Filtro ATR DELL'AUTORE - RESTA SPENTO ==="
//  [SPENTO] NON ACCENDERE. L'autore dichiara che il motore nudo ha "minimal
//     edge" e che col filtro arriva a +38%/+40%. Da noi la forma
//     "filtro appiccicato a un motore gia' tarato" ha 0 successi su 5.
//     Il filtro resta nel codice (cosi' e' DICHIARATO, non nascosto) e
//     il file prova lo pinna a 0. Se il motore nudo e' rosso, la
//     famiglia si chiude: NON si ripesca da qui.
input bool   InpUseATRFilter = false;      // filtro ATR dell'autore: salta il trade se la candela del lunedi' e' piccola. TENERE SPENTO
input double InpMinDayATR    = 1.5;        // ampiezza minima della candela del lunedi', in ATR(D1). Attivo solo con InpUseATRFilter=true

input group "=== Maschera diagnostica dei lati - NON E' UN INTERRUTTORE DI TESI ==="
//  [MAI] QUESTI DUE NON SCELGONO LA DIREZIONE. La direzione la decide il
//     segno del lunedi' (tradeUp = !isBullish) e resta li'. Questi due
//     servono SOLO a misurare i due lati separatamente (criterio 2 del
//     file prova: "il lato SHORT si misura da solo"), in DUE PASSATE
//     DIAGNOSTICHE sulla cella scelta. MAI come asse di griglia: cosi'
//     si tornerebbe al fratello 003, che e' stato respinto proprio per
//     questo. Default: entrambi accesi = comportamento neutro.
//     [NOTA] Serve anche per non lasciare due righe del file prova a
//        puntare nel vuoto: il driver si ferma su un nome inesistente.
input bool   InpAllowLong  = true;         // DIAGNOSTICO: false spegne il lato LONG (lunedi' rosso). Default true
input bool   InpAllowShort = true;         // DIAGNOSTICO: false spegne il lato SHORT (lunedi' verde). Default true

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;         // % di rischio per trade sull'EQUITY CORRENTE (1,0% = tutte le celle di confronto)

input group "=== Identita' ==="
input long   InpMagic   = 774201;          // magic VERGINE, verificato contro i 69 EA del repo. Il file prova lo pinna a 20260816
input string InpComment = "ABTG_TT";       // commento dell'ordine, riconoscibile nello storico
input bool   InpVerbose = false;           // log di diagnosi a video (spento in ottimizzazione: i Print rallentano)

//==================================================================
//  COSTANTI DI STRATEGIA - `const`, NON input, E NON DIVENTANO INPUT
//  Il giorno di controllo e la direzione SONO la tesi. Metterli fra
//  le manopole significa lasciare all'ottimizzatore la scelta di SE
//  la tesi e' ribaltamento o continuazione, e su quale giorno: e' la
//  forma pura del curve-fitting (13 misure di Spearman IS->OOS, 12
//  negative). Il fratello "003" dello stesso autore fa esattamente
//  questo ed e' stato respinto per questo.
//==================================================================
const ENUM_DAY_OF_WEEK GIORNO_CONTROLLO = MONDAY;    // la candela che si guarda
const ENUM_DAY_OF_WEEK GIORNO_OPERATIVO = TUESDAY;   // il giorno in cui si opera

//==================================================================
//  STATO
//==================================================================
int      gAtrHandle   = INVALID_HANDLE;
datetime gLastBarTF   = 0;      // ultima barra di InpTF gia' vista
int      gStampGiorno = -1;     // giorno di calendario gia' valutato (anno*1000+giorno)

//--- METRICHE DA PROP (schema di famiglia, come ABTG_BreakingBand):
//    l'Equity DD dice se il conto sopravvive; una prop invece chiude
//    per il LIMITE GIORNALIERO, che e' un'altra cosa. Qui si segue
//    l'equity dentro la giornata e si tiene la caduta peggiore
//    rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

//--- FUNNEL DI MORTALITA' (stampato da OnTester). Con ~52 eventi
//    l'anno il campione e' strutturalmente piccolo: se l'EA resta
//    muto il funnel dice SUBITO dove muore, senza autopsie.
long cGiorniVisti     = 0;   // giorni di calendario valutati
long cNonMartedi      = 0;   // non e' il giorno operativo
long cBarraD1NonPronta= 0;   // la barra D1 di oggi non e' ancora nata
long cPrecNonLunedi   = 0;   // l'ultimo giorno chiuso non e' lunedi' (FESTIVI / settimane corte)
long cOraNonArrivata  = 0;   // tick prima di InpEntryHourServer (conteggio di traffico, non un imbuto)
long cFuoriFinestra   = 0;   // ora d'ingresso superata di oltre InpEntryWindowMin
long cGiaOperato      = 0;   // gia' entrato oggi (memoria o storico)
long cPosizioneAperta = 0;   // una nostra posizione era ancora aperta
long cAtrMancante     = 0;   // CopyBuffer dell'ATR fallito
long cFiltroATR       = 0;   // scartato dal filtro dell'autore (se acceso)
long cLatoSpento      = 0;   // scartato dalla maschera diagnostica
long cLottoZero       = 0;   // lotto calcolato a zero (margine / specifiche)
long cInvioFallito    = 0;   // OrderSend rifiutato
long cLong            = 0;   // ingressi LONG  (lunedi' rosso)
long cShort           = 0;   // ingressi SHORT (lunedi' verde)

void Log(string m) { if(InpVerbose) Print("[TT] ", m); }

//==================================================================
//  INIZIALIZZAZIONE
//==================================================================
int OnInit()
  {
   //--- validazione della configurazione. Qui si fallisce apposta:
   //    sono errori di impostazione, non condizioni di mercato.
   if(InpSLDailyATRMult <= 0.0)
     {
      Print("OnInit: InpSLDailyATRMult deve essere > 0. Un ordine senza stop non esiste in questo EA (DIFETTO NUOVO 2).");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpTP_R < 0.0)
     { Print("OnInit: InpTP_R non puo' essere negativo."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpATRPeriodD1 < 1)
     { Print("OnInit: InpATRPeriodD1 deve essere >= 1."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpRiskPercent <= 0.0)
     { Print("OnInit: InpRiskPercent deve essere > 0."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpEntryHourServer < 0 || InpEntryHourServer > 23)
     { Print("OnInit: InpEntryHourServer fuori scala 0-23."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpCloseHourServer < 0 || InpCloseHourServer > 23)
     { Print("OnInit: InpCloseHourServer fuori scala 0-23."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpEntryWindowMin < 0)
     { Print("OnInit: InpEntryWindowMin non puo' essere negativo."); return(INIT_PARAMETERS_INCORRECT); }

   //--- configurazione degenere: apre e chiude nello stesso istante.
   //    Non e' un errore di sintassi, quindi e' un AVVISO, non un veto.
   if(InpEntryHourServer >= InpCloseHourServer)
      Print("OnInit: ATTENZIONE - ora d'ingresso (", InpEntryHourServer,
            ") >= ora di chiusura forzata (", InpCloseHourServer,
            "): la posizione verrebbe chiusa subito. Sono ORE SERVER.");

   //--- DIFETTO NUOVO 3: qui l'originale faceva INIT_FAILED. Nel tester
   //    sarebbe un'intera passata persa (una cella vuota che sembra un
   //    risultato). Qui e' un avviso; la guardia vera e' sul CopyBuffer.
   if(iBars(_Symbol, PERIOD_D1) < InpATRPeriodD1 + 5)
      Print("OnInit: ATTENZIONE - storico giornaliero corto per ", _Symbol,
            " (servono almeno ", InpATRPeriodD1 + 5,
            " barre D1). L'EA parte lo stesso e non operera' finche' l'ATR non c'e'.");

   gAtrHandle = iATR(_Symbol, PERIOD_D1, InpATRPeriodD1);
   if(gAtrHandle == INVALID_HANDLE)
     { Print("OnInit: creazione handle ATR(D1,", InpATRPeriodD1, ") fallita per ", _Symbol); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber((ulong)InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- RELOAD-SAFE: al riavvio non sappiamo se il giorno in corso e'
   //    gia' stato consumato. Lo stato in memoria e' perso, ma
   //    GiaOperatoOggi() rilegge lo storico: e' li' la verita'.
   gLastBarTF   = 0;
   gStampGiorno = -1;

   Log(StringFormat("avviato su %s  TF=%s  ingresso h%d server  chiusura h%d server  magic=%d",
                    _Symbol, EnumToString(InpTF), InpEntryHourServer, InpCloseHourServer, (int)InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gAtrHandle != INVALID_HANDLE) IndicatorRelease(gAtrHandle);
  }

//==================================================================
//  TICK
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura
   //    del giorno. Sta QUI e non dopo il filtro di nuova barra: la
   //    caduta peggiore della giornata succede in mezzo alla candela.
     {
      MqlDateTime _n; TimeToStruct(TimeCurrent(), _n);
      double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
      if(_n.day_of_year != gDayEqStamp)
        { gDayEqStamp = _n.day_of_year; gDayStartEquity = _eq; gDayMinEquity = _eq; }
      if(gDayStartEquity <= 0.0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
      if(_eq < gDayMinEquity)    gDayMinEquity = _eq;
      double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
      if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
     }

   MqlDateTime ora;
   TimeCurrent(ora);                       // [ORARI] ORA SERVER, mai TimeLocal

   //--- chiusura forzata: a ogni tick, non a ogni barra. Filtrata per
   //    simbolo + magic (l'originale su questo era gia' corretto).
   if(ora.hour >= InpCloseHourServer) ChiudiTutte();

   //--- cancello a nuova barra di InpTF: e' qui che l'EA si sveglia.
   //    Su InpTF=H1 con InpEntryHourServer=8 il risveglio utile e' la
   //    barra che apre alle 08:00 server.
   datetime tBar = iTime(_Symbol, InpTF, 0);
   if(tBar == 0 || tBar == gLastBarTF) return;
   gLastBarTF = tBar;

   //--- un solo tentativo per GIORNO DI CALENDARIO
   int stamp = ora.year * 1000 + ora.day_of_year;
   if(stamp == gStampGiorno) return;

   ValutaIngresso(ora, stamp);
  }

//==================================================================
//  VALUTAZIONE DELL'INGRESSO
//  `stamp` viene consumato (scritto in gStampGiorno) SOLO quando la
//  giornata e' decisa: se stiamo solo aspettando l'ora, si riprova.
//==================================================================
void ValutaIngresso(const MqlDateTime &ora, const int stamp)
  {
   cGiorniVisti++;

   //--- 1) oggi deve essere il giorno operativo (MARTEDI').
   if((ENUM_DAY_OF_WEEK)ora.day_of_week != GIORNO_OPERATIVO)
     { cNonMartedi++; gStampGiorno = stamp; return; }

   //--- 2) l'ora d'ingresso (ORA SERVER). Non si consuma il giorno:
   //       il tick delle 03:00 non deve impedire quello delle 08:00.
   if(ora.hour < InpEntryHourServer) { cOraNonArrivata++; return; }

   //--- 3) finestra utile (DIFETTO NUOVO 5). Il riferimento NON e' l'ora
   //       nominale ma la PRIMA BARRA UTILE DI OGGI: su un indice con
   //       sessione 08:00-22:00 e InpEntryHourServer=0 la prima barra
   //       del martedi' e' quella delle 08:00, non quella delle 00:00
   //       (che non esiste). Misurando dall'ora nominale, quelle celle
   //       sarebbero tornate TUTTE VUOTE, in silenzio.
   //       Nel tester la finestra non morde mai; serve al forward dopo
   //       un riavvio a meta' giornata.
   if(InpEntryWindowMin > 0)
     {
      datetime rif = PrimaBarraUtileOggi(ora);
      if(rif > 0)
        {
         int minutiDaRif = (int)((TimeCurrent() - rif) / 60);
         if(minutiDaRif > InpEntryWindowMin)
           {
            cFuoriFinestra++; gStampGiorno = stamp;
            Log("fuori finestra: " + IntegerToString(minutiDaRif) + " min dalla prima barra utile di oggi");
            return;
           }
        }
     }

   //--- 4) la barra D1 di OGGI deve esistere: solo allora la barra a
   //       shift 1 e' davvero l'ULTIMO GIORNO CHIUSO. Cosi' non si
   //       legge mai una candela in formazione (niente repaint).
   datetime tD1 = iTime(_Symbol, PERIOD_D1, 0);
   if(tD1 == 0) { cBarraD1NonPronta++; return; }
   MqlDateTime dOggi; TimeToStruct(tD1, dOggi);
   if(dOggi.year != ora.year || dOggi.day_of_year != ora.day_of_year)
     { cBarraD1NonPronta++; return; }

   //--- 5) l'ultimo giorno CHIUSO deve essere il giorno di controllo
   //       (LUNEDI'). Qui cadono i FESTIVI e le settimane corte: se il
   //       lunedi' non c'e', il giorno precedente e' il venerdi' e NON
   //       si opera. Il contatore dice quante volte capita: e' la
   //       domanda (d) dei limiti dichiarati nel file prova.
   MqlDateTime dPrec; TimeToStruct(iTime(_Symbol, PERIOD_D1, 1), dPrec);
   if((ENUM_DAY_OF_WEEK)dPrec.day_of_week != GIORNO_CONTROLLO)
     { cPrecNonLunedi++; gStampGiorno = stamp; return; }

   //--- 6) una posizione alla volta, contata per SIMBOLO + MAGIC
   //       (CORREZIONE 3).
   if(ContaPosizioni() > 0)
     { cPosizioneAperta++; gStampGiorno = stamp; Log("c'e' gia' una nostra posizione aperta: salto la giornata"); return; }

   //--- 7) guardia al riavvio (DIFETTO NUOVO 4)
   if(GiaOperatoOggi())
     { cGiaOperato++; gStampGiorno = stamp; Log("storico: ho gia' operato oggi"); return; }

   //--- 8) ATR(D1) della barra CHIUSA (shift 1). Niente shift 0.
   double atrBuf[];
   ArraySetAsSeries(atrBuf, true);
   if(CopyBuffer(gAtrHandle, 0, 1, 1, atrBuf) <= 0 || atrBuf[0] <= 0.0)
     { cAtrMancante++; Log("ATR(D1) non disponibile: non si opera"); return; }
   double atr = atrBuf[0];

   //==============================================================
   //  9) LA CANDELA DEL LUNEDI' - CORREZIONE 2, la piu' importante.
   //     Si legge dalla primitiva D1, NON ricostruita da barre H1.
   //     L'originale (GetCheckDayData, ciclo `i < boundaryIdx` a riga
   //     296) ESCLUDEVA la barra di apertura del giorno: su un indice
   //     con sessione questo significa calcolare il segno del lunedi'
   //     SENZA la campanella, cioe' senza l'ora piu' volatile della
   //     giornata. E il segno del lunedi' E' la direzione del trade.
   //==============================================================
   double openLun  = iOpen (_Symbol, PERIOD_D1, 1);
   double closeLun = iClose(_Symbol, PERIOD_D1, 1);
   double highLun  = iHigh (_Symbol, PERIOD_D1, 1);
   double lowLun   = iLow  (_Symbol, PERIOD_D1, 1);
   if(openLun <= 0.0 || closeLun <= 0.0 || highLun <= 0.0 || lowLun <= 0.0)
     { cBarraD1NonPronta++; Log("candela del lunedi' non leggibile"); return; }

   //--- 10) filtro ATR dell'autore. SPENTO di default e va tenuto
   //        spento: vedi il blocco degli input.
   if(InpUseATRFilter)
     {
      double ampiezza = highLun - lowLun;
      if(ampiezza < InpMinDayATR * atr)
        { cFiltroATR++; gStampGiorno = stamp; Log("filtro ATR: candela del lunedi' troppo piccola"); return; }
     }

   //==============================================================
   //  ***  LA RIGA. E' TUTTA LA STRATEGIA, E NON SI TOCCA.  ***
   //       lunedi' ROSSO -> si COMPRA ; lunedi' VERDE -> si VENDE
   //==============================================================
   bool isBullish = (closeLun > openLun);
   bool tradeUp   = !isBullish;

   //--- maschera DIAGNOSTICA dei lati. Non sceglie la direzione: la
   //    direzione e' gia' decisa sopra dal mercato. Spegne solo la
   //    misura di un lato, per le due passate del criterio 2.
   if(tradeUp && !InpAllowLong)   { cLatoSpento++; gStampGiorno = stamp; return; }
   if(!tradeUp && !InpAllowShort) { cLatoSpento++; gStampGiorno = stamp; return; }

   //--- 11) stop e target, con il pavimento dello STOPS_LEVEL su
   //        ENTRAMBI (DIFETTO NUOVO 1).
   double slDist = 0.0, tpDist = 0.0;
   if(!CalcolaStop(atr, slDist, tpDist))
     { gStampGiorno = stamp; return; }

   //--- 12) lotto dal rischio % sull'EQUITY CORRENTE (CORREZIONE 4),
   //        con la perdita per lotto chiesta al broker (CORREZIONE 5).
   double lotti = CalcolaLotto(slDist);
   if(lotti <= 0.0)
     { cLottoZero++; gStampGiorno = stamp; Log("lotto = 0: margine insufficiente o specifiche del simbolo non valide"); return; }

   //--- 13) fuoco. Il giorno si consuma comunque: che l'ordine passi o
   //        no, non si riprova piu' oggi (niente rincorse).
   gStampGiorno = stamp;
   if(ApriPosizione(tradeUp, lotti, slDist, tpDist))
     {
      if(tradeUp) cLong++; else cShort++;
      Log(StringFormat("INGRESSO %s  lunedi' %s (open %.5f close %.5f)  lotti %.2f  SL %.5f  TP %.5f",
                       tradeUp ? "LONG" : "SHORT", isBullish ? "VERDE" : "ROSSO",
                       openLun, closeLun, lotti, slDist, tpDist));
     }
   else cInvioFallito++;
  }

//==================================================================
//  PRIMA BARRA UTILE DI OGGI
//  La barra di InpTF PIU' VECCHIA che sia (a) di oggi e (b) a un'ora
//  server >= InpEntryHourServer. E' il riferimento onesto della
//  finestra d'ingresso: su un indice con sessione 08:00-22:00 e
//  InpEntryHourServer=0 restituisce la barra delle 08:00 (la prima
//  che esiste), non un'ora nominale che nel calendario del simbolo
//  non c'e'. Si scorre all'indietro e ci si ferma appena si esce dal
//  giorno di oggi. Ritorna 0 se non ce n'e' nessuna.
//==================================================================
datetime PrimaBarraUtileOggi(const MqlDateTime &ora)
  {
   datetime migliore = 0;
   for(int i = 0; i < 300; i++)
     {
      datetime t = iTime(_Symbol, InpTF, i);
      if(t == 0) break;
      MqlDateTime d; TimeToStruct(t, d);
      if(d.year != ora.year || d.day_of_year != ora.day_of_year) break;   // usciti da oggi
      if(d.hour >= InpEntryHourServer) migliore = t;                      // piu' vecchia -> vince
     }
   return(migliore);
  }

//==================================================================
//  STOP E TARGET
//  DIFETTO NUOVO 1: il pavimento dello STOPS_LEVEL va messo su TUTTE
//  E DUE le distanze. Con InpTP_R = 0,5 (che la nostra griglia
//  spazzola) e lo stop appoggiato al pavimento, un TP a meta' del
//  pavimento farebbe RIFIUTARE l'ordine dal broker.
//==================================================================
bool CalcolaStop(const double atr, double &slDist, double &tpDist)
  {
   int    stopsLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double punto      = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   if(punto <= 0.0) { Log("SYMBOL_POINT non valido"); return(false); }

   //--- pavimento: stops level del broker, e comunque mai meno di 2
   //    punti (l'originale usava la stessa soglia minima).
   double minDist = MathMax((double)stopsLevel, 2.0) * punto;

   slDist = atr * InpSLDailyATRMult;
   if(slDist < minDist) slDist = minDist;

   tpDist = (InpTP_R > 0.0) ? slDist * InpTP_R : 0.0;
   if(tpDist > 0.0 && tpDist < minDist) tpDist = minDist;

   return(true);
  }

//==================================================================
//  LOTTO - CORREZIONE 4 (equity corrente) + CORREZIONE 5 (la perdita
//  per lotto la dice il BROKER con OrderCalcProfit, non il tick value
//  nudo: quello e' il bug che ha ucciso il round 2 sul Nikkei, ~160x
//  di errore sui simboli in yen).
//==================================================================
double CalcolaLotto(const double slDist)
  {
   if(slDist <= 0.0) return(0.0);

   //--- EQUITY CORRENTE, non il saldo letto una volta in OnInit.
   double rischio = AccountInfoDouble(ACCOUNT_EQUITY) * InpRiskPercent / 100.0;
   if(rischio <= 0.0) return(0.0);

   double perditaPerLotto = 0.0;
   double px      = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double profitto = 0.0;
   if(px > slDist &&
      OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, px, px - slDist, profitto) &&
      profitto < 0.0)
      perditaPerLotto = -profitto;

   //--- ripiego, se il broker non risponde: il vecchio calcolo col
   //    tick value. Resta come seconda scelta, non come prima.
   if(perditaPerLotto <= 0.0)
     {
      double tv  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      double tsz = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tv <= 0.0 || tsz <= 0.0) return(0.0);
      perditaPerLotto = (slDist / tsz) * tv;
     }
   if(perditaPerLotto <= 0.0) return(0.0);

   double lotto = rischio / perditaPerLotto;

   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP); if(st <= 0.0) st = 0.01;

   //--- MathFloor: si arrotonda in GIU', cioe' VERSO il rischio
   //    dichiarato. L'originale su questo era gia' corretto.
   lotto = MathFloor(lotto / st) * st;

   //--- NOTA (comportamento di famiglia, identico agli altri EA): il
   //    lotto viene comunque riportato al MINIMO del simbolo. Su conti
   //    piccoli o stop molto larghi il rischio effettivo puo' quindi
   //    superare InpRiskPercent: e' un limite del broker, non una
   //    scelta di money management.
   return(MathMax(mn, MathMin(mx, lotto)));
  }

//==================================================================
//  APERTURA
//==================================================================
bool ApriPosizione(const bool tradeUp, const double lotti, const double slDist, const double tpDist)
  {
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double ask    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid    = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0.0 || bid <= 0.0) { Log("prezzi non disponibili"); return(false); }

   ENUM_ORDER_TYPE tipo = tradeUp ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
   double px = tradeUp ? ask : bid;

   //--- margine: si controlla PRIMA di sparare
   double margine = 0.0;
   if(!OrderCalcMargin(tipo, _Symbol, lotti, px, margine))
     { Log("OrderCalcMargin fallita"); return(false); }
   if(margine > AccountInfoDouble(ACCOUNT_MARGIN_FREE))
     { Log(StringFormat("margine insufficiente: servono %.2f, liberi %.2f", margine, AccountInfoDouble(ACCOUNT_MARGIN_FREE))); return(false); }

   double sl, tp;
   if(tradeUp)
     {
      sl = NormalizeDouble(ask - slDist, digits);
      tp = (tpDist > 0.0) ? NormalizeDouble(ask + tpDist, digits) : 0.0;
     }
   else
     {
      sl = NormalizeDouble(bid + slDist, digits);
      tp = (tpDist > 0.0) ? NormalizeDouble(bid - tpDist, digits) : 0.0;
     }

   //--- lo SL e' VERO e va nell'ordine: mai virtuale, mai in pip fissi
   bool ok = tradeUp ? gTrade.Buy (lotti, _Symbol, ask, sl, tp, InpComment)
                     : gTrade.Sell(lotti, _Symbol, bid, sl, tp, InpComment);

   if(!ok)
      Print("ApriPosizione: invio FALLITO - retcode ", gTrade.ResultRetcode(),
            " (", gTrade.ResultRetcodeDescription(), ")  lotti=", DoubleToString(lotti,2),
            " sl=", DoubleToString(sl,digits), " tp=", DoubleToString(tp,digits));

   return(ok);
  }

//==================================================================
//  CHIUSURA FORZATA - filtrata per SIMBOLO + MAGIC
//==================================================================
void ChiudiTutte()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      if(!gTrade.PositionClose(ticket))
         Print("ChiudiTutte: chiusura #", ticket, " FALLITA - ", gTrade.ResultRetcodeDescription());
     }
  }

//==================================================================
//  CONTEGGIO POSIZIONI - CORREZIONE 3
//  L'originale usava PositionsTotal() di CONTO: sul nostro conto
//  multi-EA l'EA si autozittiva ogni volta che un ALTRO EA aveva una
//  posizione aperta.
//==================================================================
int ContaPosizioni()
  {
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  GUARDIA AL RIAVVIO - DIFETTO NUOVO 4
//  Lo stato in memoria si perde a ogni riavvio del terminale. Lo
//  storico dei deal no: e' li' la verita'.
//==================================================================
bool GiaOperatoOggi()
  {
   datetime adesso = TimeCurrent();
   MqlDateTime d; TimeToStruct(adesso, d);
   d.hour = 0; d.min = 0; d.sec = 0;
   datetime mezzanotte = StructToTime(d);

   if(!HistorySelect(mezzanotte, adesso + 60)) return(false);

   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      if(HistoryDealGetInteger(tk, DEAL_ENTRY) != DEAL_ENTRY_IN) continue;
      if(HistoryDealGetInteger(tk, DEAL_MAGIC) != InpMagic) continue;
      if(HistoryDealGetString(tk, DEAL_SYMBOL) != _Symbol) continue;
      return(true);
     }
   return(false);
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei       //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione).//
//  Modello: ABTG_BreakingBand.mq5, righe 1441-1577.                 //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

void ExportTrades()
  {
   if(!HistorySelect(0, TimeCurrent())) return;
   string fn = "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol + "_" + IntegerToString((long)InpMagic) + ".csv";
   int h = FileOpen(fn, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h, "close_time", "symbol", "magic", "position_id", "deal_type", "volume", "price", "net_profit");
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      long entry = HistoryDealGetInteger(tk, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      double net = HistoryDealGetDouble(tk, DEAL_PROFIT) + HistoryDealGetDouble(tk, DEAL_SWAP) + HistoryDealGetDouble(tk, DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk, DEAL_TIME), TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                HistoryDealGetString(tk, DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_VOLUME), 2),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_PRICE), _Digits),
                DoubleToString(net, 2));
     }
   FileClose(h);
  }

//==================================================================
//  FUNNEL DI MORTALITA' (solo Print a fine test).
//  Con ~52 eventi l'anno il campione e' strutturalmente piccolo: se
//  l'EA resta muto, questo dice SUBITO dove muore la cascata senza
//  autopsie. Nessun impatto sul CSV.
//  [NOTA] Le due righe che vanno lette per prime:
//     - "prec NON lunedi'": sono i FESTIVI e le settimane corte, cioe'
//       il limite (d) dichiarato nel file prova. Va guardato quante
//       volte capita, non scoperto dopo.
//     - "LONG / SHORT": e' il criterio 2 (il lato short si misura da
//        solo) gia' meta' risposto, senza passate in piu'.
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[TT-FUNNEL] %s %s  ingresso h%d server - chiusura h%d server - SL %.2fxATR(D1,%d) - TP %.2fR - rischio %.2f%%",
               _Symbol, EnumToString(InpTF), InpEntryHourServer, InpCloseHourServer,
               InpSLDailyATRMult, InpATRPeriodD1, InpTP_R, InpRiskPercent);
   PrintFormat("[TT-FUNNEL] filtro ATR autore=%s (min %.2fxATR) - maschera lati: long=%s short=%s",
               InpUseATRFilter ? "ACCESO ATTENZIONE:" : "spento", InpMinDayATR,
               InpAllowLong ? "on" : "OFF", InpAllowShort ? "on" : "OFF");
   PrintFormat("[TT-FUNNEL] giorni valutati=%d | non martedi'=%d | barra D1 non pronta=%d | prec NON lunedi' (festivi/settimane corte)=%d",
               (int)cGiorniVisti, (int)cNonMartedi, (int)cBarraD1NonPronta, (int)cPrecNonLunedi);
   PrintFormat("[TT-FUNNEL] scartati: fuori finestra=%d | gia' operato oggi=%d | posizione nostra aperta=%d | ATR mancante=%d",
               (int)cFuoriFinestra, (int)cGiaOperato, (int)cPosizioneAperta, (int)cAtrMancante);
   PrintFormat("[TT-FUNNEL] scartati: filtro ATR=%d | lato spento (maschera diagnostica)=%d | lotto zero=%d | invio fallito=%d",
               (int)cFiltroATR, (int)cLatoSpento, (int)cLottoZero, (int)cInvioFallito);
   PrintFormat("[TT-FUNNEL] ==> INGRESSI: LONG (lunedi' rosso)=%d - SHORT (lunedi' verde)=%d - totale=%d | trade chiusi dal tester=%d",
               (int)cLong, (int)cShort, (int)(cLong + cShort), (int)TesterStatistics(STAT_TRADES));
  }

double OnTester()
  {
   PrintFunnel();
   ExportTrades();
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che servono per rispondere "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
