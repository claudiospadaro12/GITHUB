//+------------------------------------------------------------------+
//|                                          ABTG_PunteLarry.mq5     |
//|                                                                  |
//|  EA di LABORATORIO "LE PUNTE DI LARRY" - MT5 - TUTTO-IN-UNO      |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  FONTE NORMATIVA                                                 |
//|   1. backtest_pipeline/prove/SMASH_DAY_TESI.md (VINCOLANTE:      |
//|      tesi scritta PRIMA di qualunque numero, 13/08/2026)          |
//|      sezioni "UN EA, TRE PATTERN", "Uscite", "SCELTE NOSTRE",     |
//|      "Le trappole dichiarate subito".                            |
//|   2. Larry Williams, "Long-Term Secrets to Short-Term Trading"    |
//|      (Smash Day, Oops, first profitable open).                   |
//|   3. Trascrizione Unger + Money.it/traders-mag (definizione fine  |
//|      dell'Oops: ingresso all'estremo di ieri, stop OLTRE          |
//|      l'estremo del GIORNO DEL GAP, uscita alla prima apertura in  |
//|      guadagno).                                                  |
//|                                                                  |
//|  ATTENZIONE - LE FONTI SONO PARZIALI. Danno il PATTERN (setup,    |
//|  direzione, livello d'ingresso) e l'idea di uscita. NON danno:    |
//|  quantificazione del filtro dimensione, time-stop, money          |
//|  management, gestione dello spread. Tutto cio' e' marcato         |
//|  "SCELTA NOSTRA" nei commenti degli input: sono PARAMETRI DA      |
//|  MISURARE, non verita' del corso.                                |
//|                                                                  |
//|  IL MECCANISMO (ipotesi della tesi)                               |
//|   Tutte le "punte" sono TRAPPOLE del breakout giornaliero:        |
//|   un'estensione oltre l'estremo di ieri (in apertura per l'Oops,  |
//|   in giornata per lo Smash) che NON tiene. Chi ha inseguito il    |
//|   breakout resta intrappolato e la sua uscita alimenta il         |
//|   movimento contrario. Da qui: si entra SOLO sul rientro          |
//|   (pendente), mai in anticipo.                                   |
//|                                                                  |
//|  COSA FA (mappa REGOLA -> CODICE)                                 |
//|   OnNewBar / StartDay                                            |
//|     - i PATTERN si leggono su barre D1 (iHigh/iLow/iOpen/iClose   |
//|       su PERIOD_D1), l'esecuzione avviene su un grafico di TF     |
//|       qualsiasi (InpTF, default H1) che serve solo a scandire il  |
//|       tempo: al primo tick della nuova giornata D1 si valuta il   |
//|       setup e si piazza il pendente.                             |
//|   DetectSetup (InpPatternMode: il tritacarne dei tre pattern)     |
//|     - MODO 0 SMASH "libro": ieri chiusura OLTRE l'estremo         |
//|       dell'altro ieri (close[1]<low[2] = setup LONG,              |
//|       close[1]>high[2] = setup SHORT). Oggi stop order            |
//|       sull'estremo OPPOSTO della candela smash;                   |
//|     - MODO 1 SMASH "punta": ieri rottura INTRADAY dell'estremo    |
//|       dell'altro ieri ma chiusura rientrata nel TERZO OPPOSTO del |
//|       proprio range. Oggi stop order di conferma nella direzione  |
//|       della chiusura;                                            |
//|     - MODO 2 OOPS: oggi apertura in gap oltre l'estremo di ieri.  |
//|       Ingresso LIMIT esattamente sull'estremo violato (il rientro |
//|       nel range e' l'"oops").                                    |
//|   Filtro dimensione (SCELTA NOSTRA, come nel GapFill)            |
//|     - modi 0/1: escursione dell'ESTREMO oltre il livello violato; |
//|     - modo 2: dimensione del gap d'apertura;                      |
//|     - deve stare fra InpSizeMinATR e InpSizeMaxATR x ATR(D1):     |
//|       sotto il minimo e' rumore/spread, sopra il massimo e'       |
//|       rottura vera (news) e la trappola non e' il caso base.      |
//|   TryPlace (pendente, spread, stops level)                        |
//|     - il pendente vale SOLO per la giornata: expiration a fine    |
//|       giornata D1 del server (con cancellazione nostra di         |
//|       sicurezza se il broker non accetta ORDER_TIME_SPECIFIED);   |
//|     - filtro spread con riprova entro InpEntryWindowBars barre.   |
//|   Uscite (InpExitMode)                                            |
//|     - MODO 0 FIRST PROFITABLE OPEN (Williams): alla prima         |
//|       APERTURA di candela D1 successiva al giorno d'ingresso, se  |
//|       la posizione e' in profitto -> flat a mercato; altrimenti   |
//|       si resta (lo SL e' sempre sul server) e si riprova alle     |
//|       aperture successive;                                       |
//|     - MODO 1 R-based: TP a InpTP_R x rischio iniziale;            |
//|     - sempre: time-stop InpMaxDaysHold giorni D1.                 |
//|                                                                  |
//|  UN SOLO CICLO AL GIORNO PER SIMBOLO, UN SETUP ALLA VOLTA.        |
//|  RELOAD-SAFE: al riavvio la giornata in corso e' marcata COME     |
//|  GIA' CONSUMATA (non ne abbiamo osservata l'apertura) e in piu'   |
//|  si controlla lo storico dei deal della giornata col magic.       |
//|  SL e TP sono ordini VERI sul server: niente stealth.             |
//|                                                                  |
//|  DIAGNOSTICA: funnel [LARRY-FUNNEL] stampato da OnTester. I       |
//|  campioni sono piccoli PER COSTRUZIONE (un'occasione al giorno    |
//|  al massimo, e quasi mai): se l'EA resta muto il funnel dice      |
//|  SUBITO dove muore (nessun setup? filtro dimensione? livello      |
//|  troppo vicino? pendenti mai riempiti?) senza autopsie.           |
//|                                                                  |
//|  AVVERTENZA DELLA TESI: sui CFD quasi-24h il gap d'apertura D1    |
//|  e' raro, quindi il MODO 2 e' atteso rarissimo (e il lunedi' e'   |
//|  quasi un doppione dell'ABTG_GapFill: sovrapposizione DA          |
//|  MISURARE prima di qualunque vivaio). Il baricentro atteso del    |
//|  capitolo sono i MODI 0/1, che non dipendono dai gap di sessione. |
//|  L'OHLC non vede lo spread: OHLC SOLO per frequenza/screening,    |
//|  i VERDETTI SOLO a tick reali.                                   |
//|                                                                  |
//|  DEMO. Nessuna garanzia. Non compilato ne' testato dall'autore    |
//|  del codice: compilare in MetaEditor e validare nel tester.       |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.00 - Prima stesura, dalla tesi SMASH_DAY_TESI.md.              |
//|    Nessun numero misurato ancora: TUTTI i default sono valori di  |
//|    partenza ragionevoli, non tarature. In particolare:            |
//|      - InpSizeMinATR 0.0 e InpSizeMaxATR 0.0 = FILTRO SPENTO allo |
//|        screening. E' voluto: la lezione delle Bollinger dice che  |
//|        alla prima passata serve la FREQUENZA, i filtri dopo.      |
//|      - InpSLBufferATR 0.1 = un decimo di ATR(D1) oltre l'estremo: |
//|        lo stop sta appena FUORI dalla punta, non sul suo prezzo   |
//|        esatto (dove si viene presi dal rumore).                   |
//|      - InpMaxDaysHold 5 = una settimana di borsa: il pattern e'   |
//|        un riassorbimento, se non paga in pochi giorni non e' quel |
//|        trade (stessa filosofia del time-stop del GapFill).        |
//|      - InpTP_R 1.5 vale SOLO con InpExitMode 1: e' l'alternativa  |
//|        misurabile alla first profitable open, non la regola del   |
//|        libro.                                                     |
//|      - InpMaxSpreadPts 0 (spento) per NON falsare lo screening    |
//|        OHLC, dove lo spread modellato non e' quello vero. Va      |
//|        ACCESO nei run a tick reali: e' li' che il filtro serve.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF operativo: scandisce il tempo (i pattern restano su D1). SCELTA NOSTRA: H1

input group "=== Pattern (GUIDA: i tre pattern del libro/corso) ==="
input int    InpPatternMode    = 0;     // 0 = SMASH "libro" (chiusura oltre l'estremo di 2 gg fa); 1 = SMASH "punta" (rottura intraday + rientro nel terzo opposto); 2 = OOPS (gap d'apertura + rientro)

input group "=== Uscite (GUIDA: first profitable open) ==="
input int    InpExitMode       = 0;     // 0 = FIRST PROFITABLE OPEN (Williams); 1 = R-based (TP a N x rischio)
input double InpTP_R           = 1.5;   // SCELTA NOSTRA (solo ExitMode 1): TP = N x rischio iniziale

input group "=== Stop loss (GUIDA per il livello, SCELTA NOSTRA per il buffer) ==="
input int    InpSLMode         = 0;     // 0 = oltre l'estremo della candela SEGNALE (smash: ieri; oops: il giorno del gap); 1 = N x ATR(D1) dal prezzo d'ingresso
input double InpSLBufferATR    = 0.1;   // SCELTA NOSTRA (SLMode 0): buffer oltre l'estremo, in frazioni di ATR(D1)
input double InpAtrSlMult      = 1.5;   // SCELTA NOSTRA (SLMode 1): SL = N x ATR(D1) dal prezzo d'ingresso

input group "=== Misura della punta / del gap (SCELTA NOSTRA: le fonti non quantificano) ==="
input int    InpAtrPeriodD1    = 14;    // SCELTA NOSTRA: periodo ATR su PERIOD_D1 (metro della dimensione della punta)
input double InpSizeMinATR     = 0.0;   // SCELTA NOSTRA: punta/gap MINIMO in frazioni di ATR(D1). 0 = filtro SPENTO (default di screening: prima la frequenza)
input double InpSizeMaxATR     = 0.0;   // SCELTA NOSTRA: punta/gap MASSIMO in frazioni di ATR(D1). 0 = nessun tetto

input group "=== Time-stop (SCELTA NOSTRA: il riassorbimento e' rapido, o non e') ==="
input int    InpMaxDaysHold    = 5;     // giorni D1 massimi in posizione, poi flat a mercato. 0 = spento

input group "=== Lati (LATI SEPARATI OBBLIGATORI, tesi) ==="
input bool   InpAllowLong      = true;  // abilita i setup LONG
input bool   InpAllowShort     = true;  // abilita i setup SHORT

input group "=== Finestra d'ingresso e spread ==="
input int    InpMaxSpreadPts   = 0;     // spread massimo in POINTS al piazzamento. 0 = filtro spento (obbligatorio ACCENDERLO nei run a tick reali)
input int    InpEntryWindowBars= 3;     // SCELTA NOSTRA: barre di InpTF entro cui riprovare se lo spread e' sopra soglia (poi la giornata e' persa)

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;   // Rischio % per operazione (sulla distanza di stop)

input group "=== Generali ==="
input long   InpMagic          = 772301;  // magic number
input string InpComment        = "LARRY"; // commento ordini
input bool   InpVerbose        = true;    // log estesi

//==================================================================
//  COSTANTI / STATO
//==================================================================
#define DAY_IDLE     0   // nessuna giornata tracciata
#define DAY_WAIT     1   // setup valido, in attesa di uno spread accettabile per piazzare
#define DAY_PENDING  2   // pendente sul server, in attesa di riempimento o scadenza
#define DAY_DONE     3   // giornata consumata (piazzata, bocciata o finestra esaurita)

int      hAtrD1=INVALID_HANDLE;

datetime gLastBar=0;

//--- stato della giornata in corso
int      gState=DAY_IDLE;
datetime gDayId=0;           // ora d'inizio della barra D1 tracciata (identificativo della giornata)
datetime gDayEnd=0;          // fine della giornata D1 (scadenza del pendente)
int      gDayBars=0;         // barre di InpTF gia' aperte in questa giornata (la prima vale 1)
double   gAtrRef=0.0;        // ATR(D1) congelato al rilevamento del setup

//--- descrizione del setup rilevato (valido finche' gState != DAY_DONE/IDLE)
int      gSetupDir=0;        // +1 = LONG, -1 = SHORT, 0 = nessuno
bool     gIsStop=true;       // true = ordine STOP (smash), false = ordine LIMIT (oops)
double   gEntryPx=0.0;       // livello del pendente
double   gSigHigh=0.0;       // massimo della candela SEGNALE (per lo SL modo 0 sugli smash)
double   gSigLow=0.0;        // minimo  della candela SEGNALE
double   gSizeMeas=0.0;      // escursione della punta (modi 0/1) o dimensione del gap (modo 2)
ulong    gPendTicket=0;      // ticket del pendente in vita
bool     gJustFilled=false;  // alzato da OnTradeTransaction quando un nostro pendente si riempie

//--- CONTATORI DEL FUNNEL [LARRY-FUNNEL] (solo diagnostica, stampati da
//    OnTester: nessun impatto sul CSV, che nasce da FrameAdd/OnTesterDeinit)
long cD_days=0, cD_busy=0, cD_nodata=0, cD_noatr=0;
long cS_none=0, cS_long=0, cS_short=0;
long cF_min=0, cF_max=0, cF_side=0;
long cO_spread=0, cO_failLevel=0, cO_failLot=0, cO_failSend=0;
long cP_placed=0, cP_long=0, cP_short=0, cP_filled=0, cP_expired=0;
long cE_tp=0, cE_sl=0, cE_other=0;
long cX_fpo=0, cX_time=0, cX_slsync=0;

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[LARRY] ", m); }

string ModeName(int m)
  {
   if(m==0) return("SMASH libro");
   if(m==1) return("SMASH punta");
   return("OOPS");
  }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   //--- validazione degli input: meglio un INIT_FAILED che un EA che
   //    opera di nascosto con parametri fuori dominio.
   int secTF=PeriodSeconds(InpTF);
   if(secTF<=0 || secTF>86400)
     { Print("ERRORE: InpTF deve essere <= D1 (serve a scandire la giornata, i pattern restano su D1)."); return(INIT_FAILED); }
   if(InpPatternMode<0 || InpPatternMode>2)
     { Print("ERRORE: InpPatternMode deve essere 0 (smash libro), 1 (smash punta) o 2 (oops)."); return(INIT_FAILED); }
   if(InpExitMode<0 || InpExitMode>1)
     { Print("ERRORE: InpExitMode deve essere 0 (first profitable open) o 1 (R-based)."); return(INIT_FAILED); }
   if(InpExitMode==1 && InpTP_R<=0.0)
     { Print("ERRORE: InpTP_R deve essere > 0 quando InpExitMode = 1."); return(INIT_FAILED); }
   if(InpSLMode<0 || InpSLMode>1)
     { Print("ERRORE: InpSLMode deve essere 0 (oltre l'estremo) o 1 (ATR D1)."); return(INIT_FAILED); }
   if(InpSLBufferATR<0.0)
     { Print("ERRORE: InpSLBufferATR non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSLMode==1 && InpAtrSlMult<=0.0)
     { Print("ERRORE: InpAtrSlMult deve essere > 0."); return(INIT_FAILED); }
   if(InpAtrPeriodD1<1)
     { Print("ERRORE: InpAtrPeriodD1 deve essere >= 1."); return(INIT_FAILED); }
   if(InpSizeMinATR<0.0 || InpSizeMaxATR<0.0)
     { Print("ERRORE: InpSizeMinATR/InpSizeMaxATR non possono essere negativi."); return(INIT_FAILED); }
   if(InpSizeMaxATR>0.0 && InpSizeMaxATR<=InpSizeMinATR)
     { Print("ERRORE: InpSizeMaxATR deve essere 0 (nessun tetto) oppure maggiore di InpSizeMinATR."); return(INIT_FAILED); }
   if(InpMaxDaysHold<0)
     { Print("ERRORE: InpMaxDaysHold deve essere >= 0 (0 = time-stop spento)."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati disabilitati: l'EA non avrebbe nulla da fare."); return(INIT_FAILED); }
   if(InpMaxSpreadPts<0)
     { Print("ERRORE: InpMaxSpreadPts deve essere >= 0 (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpEntryWindowBars<1)
     { Print("ERRORE: InpEntryWindowBars deve essere >= 1 (1 = solo la prima barra della giornata)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0.0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- ATR su PERIOD_D1: il metro della punta deve essere GIORNALIERO,
   //    perche' il pattern e' giornaliero. Un ATR del TF operativo
   //    misurerebbe il respiro di un'ora, non quello di una giornata.
   hAtrD1 = iATR(_Symbol,PERIOD_D1,InpAtrPeriodD1);
   if(hAtrD1==INVALID_HANDLE)
     { Print("ERRORE: creazione handle ATR su D1."); return(INIT_FAILED); }

   //--- RELOAD-SAFE: la giornata in corso al momento dell'avvio viene
   //    marcata come GIA' CONSUMATA. Motivo dichiarato: la sua apertura
   //    NON l'abbiamo osservata (o l'abbiamo gia' operata prima del
   //    riavvio), quindi armare adesso sarebbe o un ingresso in ritardo
   //    su un pattern gia' vecchio o un DOPPIONE. Si costa al massimo una
   //    giornata saltata all'avvio; si evita di raddoppiare il rischio.
   gState=DAY_IDLE; gDayBars=0; gPendTicket=0; gJustFilled=false;
   datetime d0=iTime(_Symbol,PERIOD_D1,0);
   if(d0>0)
     {
      gDayId=d0;
      gDayEnd=(datetime)((long)d0+(long)PeriodSeconds(PERIOD_D1));
      gState=DAY_DONE;
      Log(StringFormat("avvio a giornata in corso (%s): giornata saltata per sicurezza%s.",
          TimeToString(d0,TIME_DATE),
          (GiaOperatoOggi(d0)?" (risultano gia' deal del magic in questa giornata)":"")));
     }

   Log(StringFormat("avviato su %s %s. Pattern %d (%s). Uscita %s. SL %s. "
                    "Punta ammessa: %.2f - %s x ATR(D1,%d). Time-stop %s. Lati: %s%s. "
                    "Spread max %s points, finestra %d barre. Rischio %.2f%%.",
       _Symbol,EnumToString(InpTF),InpPatternMode,ModeName(InpPatternMode),
       (InpExitMode==0?"first profitable open":StringFormat("R-based TP %.2f R",InpTP_R)),
       (InpSLMode==0?StringFormat("oltre l'estremo + %.2f x ATR",InpSLBufferATR)
                    :StringFormat("%.2f x ATR(D1)",InpAtrSlMult)),
       InpSizeMinATR,(InpSizeMaxATR>0.0?DoubleToString(InpSizeMaxATR,2):"illimitato"),InpAtrPeriodD1,
       (InpMaxDaysHold>0?StringFormat("%d giorni D1",InpMaxDaysHold):"spento"),
       (InpAllowLong?"LONG ":""),(InpAllowShort?"SHORT":""),
       (InpMaxSpreadPts>0?IntegerToString(InpMaxSpreadPts):"spento"),InpEntryWindowBars,
       InpRiskPercent));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtrD1!=INVALID_HANDLE){ IndicatorRelease(hAtrD1); hAtrD1=INVALID_HANDLE; }
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del
   //    giorno. Sta QUI e non dopo il filtro della nuova barra: la caduta
   //    peggiore di giornata succede in mezzo alla candela.
   {
    MqlDateTime _n; TimeToStruct(TimeCurrent(), _n);
    double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
    if(_n.day_of_year != gDayEqStamp)
      { gDayEqStamp = _n.day_of_year; gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(gDayStartEquity <= 0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(_eq < gDayMinEquity)  gDayMinEquity = _eq;
    double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
    if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
   }

   //--- il pendente va sorvegliato a ogni tick: il riempimento puo'
   //    avvenire in mezzo alla candela ed e' li' che va risincronizzato
   //    lo stop dell'Oops (estremo del giorno del gap).
   ManagePending();

   //--- il resto della logica scatta all'APERTURA di una nuova barra di
   //    InpTF. La barra che conta e' la prima della nuova giornata D1:
   //    e' li' che il pattern e' completo (per l'Oops serve l'open del
   //    giorno, che esiste solo a giornata iniziata).
   datetime t=iTime(_Symbol,InpTF,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   OnNewBar();
  }

void OnNewBar()
  {
   datetime d0=iTime(_Symbol,PERIOD_D1,0);
   if(d0<=0) return;

   if(d0!=gDayId)
     {
      //--- 1) USCITA "FIRST PROFITABLE OPEN": si valuta ESATTAMENTE qui,
      //       cioe' all'apertura della nuova giornata D1. Va fatta PRIMA
      //       di armare il nuovo setup, perche' la posizione chiusa
      //       adesso libera il posto (un setup alla volta).
      if(InpExitMode==0) TryFirstProfitableOpen();

      //--- 2) time-stop in giorni D1: cambia valore solo al cambio giorno
      ManageTimeStop();

      //--- 3) pulizia dei pendenti rimasti dalla giornata precedente
      //       (rete di sicurezza se il broker non onora l'expiration)
      CleanupPendings();

      //--- 4) nuovo ciclo giornaliero
      StartDay(d0);
      return;
     }

   //--- giornata gia' aperta: l'unico caso vivo e' il setup valido che
   //    aspetta uno spread accettabile per essere piazzato.
   if(gState!=DAY_WAIT) return;
   gDayBars++;
   TryPlace();
  }

//==================================================================
//  APERTURA DELLA GIORNATA: lettura del pattern su D1 e filtri
//==================================================================
void StartDay(datetime dayTime)
  {
   gDayId=dayTime;
   gDayEnd=(datetime)((long)dayTime+(long)PeriodSeconds(PERIOD_D1));
   gDayBars=1;
   gState=DAY_DONE;              // di default la giornata e' consumata
   gSetupDir=0; gEntryPx=0.0; gSizeMeas=0.0; gAtrRef=0.0;
   gPendTicket=0;
   cD_days++;

   //--- guardia anti-doppione (reload-safe): una posizione aperta del mio
   //    magic, un pendente ancora vivo o un ingresso gia' fatto oggi
   //    bloccano il nuovo ciclo. UN SETUP ALLA VOLTA, UN CICLO AL GIORNO.
   if(CountPositions()>0 || CountPendings()>0 || GiaOperatoOggi(dayTime))
     { cD_busy++; Log("posizione/pendente gia' in vita o giornata gia' operata: nessun nuovo ciclo."); return; }

   //--- servono TRE barre D1: oggi (in formazione), ieri, l'altro ieri
   if(Bars(_Symbol,PERIOD_D1)<3)
     { cD_nodata++; Log("meno di 3 barre D1 disponibili: giornata saltata."); return; }

   double o0=iOpen (_Symbol,PERIOD_D1,0);
   double h1=iHigh (_Symbol,PERIOD_D1,1);
   double l1=iLow  (_Symbol,PERIOD_D1,1);
   double c1=iClose(_Symbol,PERIOD_D1,1);
   double h2=iHigh (_Symbol,PERIOD_D1,2);
   double l2=iLow  (_Symbol,PERIOD_D1,2);
   if(o0<=0.0 || h1<=0.0 || l1<=0.0 || c1<=0.0 || h2<=0.0 || l2<=0.0)
     { cD_nodata++; Log("prezzi D1 non disponibili (storico bucato): giornata saltata."); return; }

   double atr=AtrD1();
   if(atr<=0.0)
     { cD_noatr++; Log("ATR(D1) non disponibile: giornata saltata."); return; }
   gAtrRef=atr;

   //--- la candela SEGNALE e' quella di ieri per gli smash (modi 0/1) e
   //    quella di OGGI per l'oops (il giorno del gap): qui teniamo gli
   //    estremi di ieri, che servono sia come livelli d'ingresso sia
   //    come stop degli smash.
   gSigHigh=h1; gSigLow=l1;

   if(!DetectSetup(o0,h1,l1,c1,h2,l2))
     { cS_none++; return; }

   //--- il setup e' contato QUI, prima di ogni filtro: il funnel deve
   //    dire quante volte il PATTERN si presenta (frequenza grezza),
   //    separatamente da quante volte lo bocciamo noi.
   if(gSetupDir>0) cS_long++; else cS_short++;

   //--- LATI SEPARATI (tesi): l'asimmetria long/short e' un'attesa
   //    dichiarata, non una sorpresa. Qui si spegne il lato non voluto.
   if((gSetupDir>0 && !InpAllowLong) || (gSetupDir<0 && !InpAllowShort))
     {
      cF_side++;
      Log(StringFormat("setup %s rilevato ma lato disabilitato: nessun ordine.",(gSetupDir>0?"LONG":"SHORT")));
      gSetupDir=0;
      return;
     }

   //--- FILTRO DIMENSIONE (SCELTA NOSTRA): sotto il minimo la punta e'
   //    rumore che lo spread si mangia; sopra il massimo non e' una
   //    trappola ma una rottura vera (news) e il fade e' il trade
   //    sbagliato. Il metro e' l'ATR(D1), non i punti: cosi' la soglia
   //    vale su indici, forex e metalli senza ritararla ogni volta.
   if(InpSizeMinATR>0.0 && gSizeMeas < InpSizeMinATR*atr)
     {
      cF_min++;
      Log(StringFormat("punta/gap %.2f x ATR sotto il minimo %.2f: rumore, giornata saltata.",gSizeMeas/atr,InpSizeMinATR));
      gSetupDir=0; return;
     }
   if(InpSizeMaxATR>0.0 && gSizeMeas > InpSizeMaxATR*atr)
     {
      cF_max++;
      Log(StringFormat("punta/gap %.2f x ATR sopra il massimo %.2f: rottura vera, giornata saltata.",gSizeMeas/atr,InpSizeMaxATR));
      gSetupDir=0; return;
     }

   Log(StringFormat("SETUP %s [%s] del %s: ingresso %s @ %s (punta/gap %s = %.2f x ATR D1).",
       (gSetupDir>0?"LONG":"SHORT"),ModeName(InpPatternMode),TimeToString(dayTime,TIME_DATE),
       (gIsStop?"STOP":"LIMIT"),DoubleToString(gEntryPx,_Digits),
       DoubleToString(gSizeMeas,_Digits),gSizeMeas/atr));

   gState=DAY_WAIT;
   TryPlace();
  }

//==================================================================
//  RILEVAMENTO DEL PATTERN (GUIDA: definizioni delle fonti)
//  Ritorna true se c'e' un setup; riempie gSetupDir/gIsStop/gEntryPx/
//  gSizeMeas. NON applica i filtri (che sono SCELTA NOSTRA e vanno
//  contati a parte nel funnel).
//==================================================================
bool DetectSetup(double o0,double h1,double l1,double c1,double h2,double l2)
  {
   gSetupDir=0; gIsStop=true; gEntryPx=0.0; gSizeMeas=0.0;

   //---------------------------------------------------------------
   // MODO 0 - SMASH DAY "LIBRO" (naked close)
   //   Ieri ha CHIUSO oltre l'estremo dell'altro ieri: chi ha inseguito
   //   quella chiusura e' esposto. Oggi si aspetta il rientro completo
   //   fino all'estremo OPPOSTO della candela smash: e' li' che la
   //   trappola scatta, e ci si va con uno STOP order (conferma).
   //---------------------------------------------------------------
   if(InpPatternMode==0)
     {
      if(c1<l2)                       // chiusura sotto il minimo di 2 gg fa -> setup LONG
        {
         gSetupDir=+1; gIsStop=true; gEntryPx=h1;
         gSizeMeas=l2-l1;             // escursione dell'estremo oltre il livello violato
         return(true);
        }
      if(c1>h2)                       // chiusura sopra il massimo di 2 gg fa -> setup SHORT
        {
         gSetupDir=-1; gIsStop=true; gEntryPx=l1;
         gSizeMeas=h1-h2;
         return(true);
        }
      return(false);
     }

   //---------------------------------------------------------------
   // MODO 1 - SMASH "PUNTA" (rottura intraday rientrata)
   //   Ieri ha ROTTO l'estremo dell'altro ieri DURANTE la giornata ma ha
   //   chiuso nel TERZO OPPOSTO del proprio range: la rottura e' gia'
   //   fallita in giornata (e' la "punta"). Oggi si chiede conferma con
   //   uno STOP nella direzione della chiusura.
   //---------------------------------------------------------------
   if(InpPatternMode==1)
     {
      double range=h1-l1;
      if(range<=0.0) return(false);   // niente divisioni per zero su candele piatte
      double terzo=range/3.0;

      // rottura del MASSIMO + chiusura nel terzo INFERIORE -> setup SHORT
      if(h1>h2 && c1<=l1+terzo && c1<h2)
        {
         gSetupDir=-1; gIsStop=true; gEntryPx=l1;
         gSizeMeas=h1-h2;
         return(true);
        }
      // rottura del MINIMO + chiusura nel terzo SUPERIORE -> setup LONG
      if(l1<l2 && c1>=h1-terzo && c1>l2)
        {
         gSetupDir=+1; gIsStop=true; gEntryPx=h1;
         gSizeMeas=l2-l1;
         return(true);
        }
      return(false);
     }

   //---------------------------------------------------------------
   // MODO 2 - OOPS
   //   OGGI il mercato ha APERTO in gap oltre l'estremo di ieri. Se il
   //   prezzo rientra nel range di ieri, chi ha comprato/venduto
   //   l'apertura e' in trappola: si entra con un LIMIT ESATTAMENTE
   //   sull'estremo violato (il rientro e' l'"oops").
   //   NOTA: sui CFD quasi-24h questo gap e' raro (atteso: quasi solo
   //   il lunedi'). E' scritto nella tesi, non e' un bug del funnel.
   //---------------------------------------------------------------
   if(o0>h1)                          // gap UP oltre il massimo di ieri -> setup SHORT
     {
      gSetupDir=-1; gIsStop=false; gEntryPx=h1;
      gSizeMeas=o0-h1;                // dimensione del gap
      return(true);
     }
   if(o0<l1)                          // gap DOWN sotto il minimo di ieri -> setup LONG
     {
      gSetupDir=+1; gIsStop=false; gEntryPx=l1;
      gSizeMeas=l1-o0;
      return(true);
     }
   return(false);
  }

//==================================================================
//  PIAZZAMENTO DEL PENDENTE
//  Il pendente vale SOLO per la giornata: o si riempie oggi o non e'
//  piu' quel pattern (la trappola invecchia).
//==================================================================
void TryPlace()
  {
   //--- filtro spread: non si piazza dentro un allargamento (il pendente
   //    verrebbe eseguito a un prezzo che non e' quello del pattern).
   //    Si riprova sulle barre successive finche' la finestra regge.
   if(!SpreadOK())
     {
      if(gDayBars>=InpEntryWindowBars)
        {
         cO_spread++; gState=DAY_DONE; gSetupDir=0;
         Log(StringFormat("spread %d points sopra il limite %d per tutta la finestra (%d barre): giornata persa.",
             SpreadPoints(),InpMaxSpreadPts,InpEntryWindowBars));
        }
      else
         Log(StringFormat("spread %d points sopra il limite %d: rinvio alla barra successiva (barra %d di %d).",
             SpreadPoints(),InpMaxSpreadPts,gDayBars,InpEntryWindowBars));
      return;
     }

   //--- da qui in poi la giornata e' comunque consumata: una sola
   //    finestra di piazzamento, nessuna rincorsa (regola dichiarata).
   gState=DAY_DONE;

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0)
     { cO_failSend++; Log("prezzi non disponibili: nessun ordine."); return; }

   bool   isLong=(gSetupDir>0);
   double px=NormalizePrice(gEntryPx);
   double minDist=StopsMinDist();

   //--- il livello deve essere ancora dalla parte giusta del mercato E
   //    oltre lo STOPS LEVEL del broker. Se il prezzo ci e' gia' passato
   //    sopra (o il livello e' troppo vicino) il pattern non e' piu'
   //    eseguibile come scritto: si salta e SI CONTA (mai forzare un
   //    ingresso a mercato al posto del pendente).
   bool pxOk=false;
   if(gIsStop) pxOk = isLong ? (px >= ask+minDist) : (px <= bid-minDist);
   else        pxOk = isLong ? (px <= ask-minDist) : (px >= bid+minDist);
   if(!pxOk)
     {
      cO_failLevel++;
      Log(StringFormat("livello %s %s non piazzabile (ask %s bid %s, distanza minima %s): giornata saltata.",
          (gIsStop?"STOP":"LIMIT"),DoubleToString(px,_Digits),
          DoubleToString(ask,_Digits),DoubleToString(bid,_Digits),DoubleToString(minDist,_Digits)));
      gSetupDir=0; return;
     }

   //--- STOP LOSS
   //    modo 0 = oltre l'estremo della candela SEGNALE:
   //      smash (modi 0/1) -> estremo di IERI, la candela della punta;
   //      oops  (modo 2)   -> estremo del GIORNO DEL GAP (Money.it), che
   //      al piazzamento e' l'estremo di OGGI gia' formato (per lo short
   //      il massimo, che al massimo coincide con l'apertura in gap).
   //      Quell'estremo puo' ancora estendersi prima del riempimento:
   //      per questo alla ESECUZIONE lo stop viene RISINCRONIZZATO in
   //      SyncOopsStop(). ATTENZIONE DICHIARATA: il lotto e' dimensionato
   //      sullo stop del PIAZZAMENTO, quindi una risincronizzazione piu'
   //      larga puo' rendere il rischio effettivo un po' superiore a
   //      InpRiskPercent. E' il prezzo da pagare per avere lo stop dove
   //      lo mettono le fonti; l'alternativa (stop fisso al piazzamento)
   //      e' disponibile con InpSLMode = 1.
   //    modo 1 = N x ATR(D1) dal livello d'ingresso.
   double sl=0.0;
   if(InpSLMode==0)
     {
      double buf=InpSLBufferATR*gAtrRef;
      if(InpPatternMode==2)
        {
         double hOggi=iHigh(_Symbol,PERIOD_D1,0);
         double lOggi=iLow (_Symbol,PERIOD_D1,0);
         if(hOggi<=0.0 || lOggi<=0.0)
           { cO_failLevel++; Log("estremi del giorno del gap non disponibili: giornata saltata."); gSetupDir=0; return; }
         sl = isLong ? (lOggi-buf) : (hOggi+buf);
        }
      else
         sl = isLong ? (gSigLow-buf) : (gSigHigh+buf);
     }
   else
      sl = isLong ? (px-InpAtrSlMult*gAtrRef) : (px+InpAtrSlMult*gAtrRef);

   sl=NormalizePrice(sl);
   bool slOk = isLong ? (sl < px-minDist) : (sl > px+minDist);
   if(!slOk)
     {
      cO_failLevel++;
      Log(StringFormat("SL non valido (%s contro ingresso %s, distanza minima %s): giornata saltata.",
          DoubleToString(sl,_Digits),DoubleToString(px,_Digits),DoubleToString(minDist,_Digits)));
      gSetupDir=0; return;
     }

   double riskDist = isLong ? (px-sl) : (sl-px);
   if(riskDist<=0.0)
     { cO_failLevel++; Log("distanza di stop nulla: giornata saltata."); gSetupDir=0; return; }

   //--- TAKE PROFIT: esiste SOLO nel modo R-based. Con la first
   //    profitable open il TP non c'e' per costruzione: l'uscita e' un
   //    evento di TEMPO (l'apertura successiva), non di prezzo.
   double tp=0.0;
   if(InpExitMode==1)
     {
      tp = isLong ? (px+InpTP_R*riskDist) : (px-InpTP_R*riskDist);
      tp = NormalizePrice(tp);
      bool tpOk = isLong ? (tp > px+minDist) : (tp < px-minDist);
      if(!tpOk)
        {
         cO_failLevel++;
         Log(StringFormat("TP troppo vicino (%s contro ingresso %s): giornata saltata.",
             DoubleToString(tp,_Digits),DoubleToString(px,_Digits)));
         gSetupDir=0; return;
        }
     }

   double lot=LotByRisk(riskDist);
   if(lot<=0.0)
     { cO_failLot++; Log("lotto nullo: nessun ordine."); gSetupDir=0; return; }

   //--- SCADENZA A FINE GIORNATA D1 (server). Se il simbolo non accetta
   //    ORDER_TIME_SPECIFIED si ripiega su GTC: in quel caso il pendente
   //    lo cancelliamo noi (ManagePending a fine giornata + CleanupPendings
   //    al cambio giorno). In nessun caso un pendente sopravvive alla
   //    giornata che lo ha generato.
   ENUM_ORDER_TYPE_TIME ttime=ORDER_TIME_GTC;
   datetime exp=0;
   if(ExpirySupported())
     {
      datetime e=(datetime)((long)gDayEnd-1);
      if((long)e > (long)TimeCurrent()+60){ ttime=ORDER_TIME_SPECIFIED; exp=e; }
     }

   string cm=InpComment+(isLong?" L":" S");
   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_PunteLarry")) return;
   bool ok=false;
   if(gIsStop)
      ok = isLong ? gTrade.BuyStop (lot,px,_Symbol,sl,tp,ttime,exp,cm)
                  : gTrade.SellStop(lot,px,_Symbol,sl,tp,ttime,exp,cm);
   else
      ok = isLong ? gTrade.BuyLimit (lot,px,_Symbol,sl,tp,ttime,exp,cm)
                  : gTrade.SellLimit(lot,px,_Symbol,sl,tp,ttime,exp,cm);

   if(!ok)
     { cO_failSend++; Log("piazzamento FALLITO: "+gTrade.ResultRetcodeDescription()); gSetupDir=0; return; }

   gPendTicket=gTrade.ResultOrder();
   gState=DAY_PENDING;
   cP_placed++;
   if(isLong) cP_long++; else cP_short++;

   Log(StringFormat("PENDENTE %s %s @ %s  SL %s  TP %s  lot %.2f  (pattern %s, punta/gap %.2f x ATR, scadenza %s, ordine %s)",
       (isLong?"BUY":"SELL"),(gIsStop?"STOP":"LIMIT"),DoubleToString(px,_Digits),
       DoubleToString(sl,_Digits),(tp>0.0?DoubleToString(tp,_Digits):"-"),lot,
       ModeName(InpPatternMode),(gAtrRef>0.0?gSizeMeas/gAtrRef:0.0),
       (ttime==ORDER_TIME_SPECIFIED?TimeToString(exp,TIME_DATE|TIME_MINUTES):"fine giornata (nostra)"),
       IntegerToString((long)gPendTicket)));
  }

//==================================================================
//  SORVEGLIANZA DEL PENDENTE: riempimento, risincronizzazione dello
//  stop dell'Oops, scadenza di sicurezza.
//==================================================================
void ManagePending()
  {
   //--- riempimento segnalato da OnTradeTransaction (fonte unica: cosi'
   //    non si conta due volte un fill gia' visto)
   if(gJustFilled)
     {
      gJustFilled=false;
      cP_filled++;
      gPendTicket=0;
      gState=DAY_DONE;
      SyncOopsStop();
     }

   if(gState!=DAY_PENDING || gPendTicket==0) return;

   //--- l'ordine non e' piu' fra gli attivi e nessun fill e' stato
   //    segnalato: e' scaduto o e' stato cancellato.
   if(!OrderSelect(gPendTicket))
     {
      gPendTicket=0; gState=DAY_DONE;
      if(CountPositions()>0){ cP_filled++; SyncOopsStop(); }
      else                  { cP_expired++; Log("pendente non piu' attivo (scaduto o cancellato): giornata chiusa."); }
      return;
     }

   //--- scadenza di sicurezza: se il broker non ha accettato
   //    l'expiration, la fine giornata la facciamo rispettare noi.
   if(TimeCurrent()>=gDayEnd)
     {
      if(gTrade.OrderDelete(gPendTicket))
        { cP_expired++; Log("fine giornata D1: pendente cancellato (il pattern non si riporta al giorno dopo)."); }
      else
         Log("cancellazione del pendente a fine giornata FALLITA: "+gTrade.ResultRetcodeDescription());
      gPendTicket=0; gState=DAY_DONE;
     }
  }

//==================================================================
//  OOPS: stop OLTRE L'ESTREMO DEL GIORNO DEL GAP (fonte Money.it).
//  Al piazzamento l'estremo di oggi era quello del momento; se nel
//  frattempo si e' esteso, al riempimento lo stop va portato oltre
//  l'estremo NUOVO. Si muove SOLO in allargamento: e' la definizione
//  del livello, non un trailing al contrario.
//==================================================================
void SyncOopsStop()
  {
   if(InpPatternMode!=2 || InpSLMode!=0) return;
   if(gAtrRef<=0.0) return;

   double hOggi=iHigh(_Symbol,PERIOD_D1,0);
   double lOggi=iLow (_Symbol,PERIOD_D1,0);
   if(hOggi<=0.0 || lOggi<=0.0) return;

   double buf=InpSLBufferATR*gAtrRef;
   double minDist=StopsMinDist();
   double tol=(_Point>0.0?_Point/2.0:0.0);

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double cur=PositionGetDouble(POSITION_SL);
      double tp =PositionGetDouble(POSITION_TP);
      double want=NormalizePrice(isLong ? (lOggi-buf) : (hOggi+buf));
      if(want<=0.0) continue;

      //--- solo ALLARGAMENTO (verso l'esterno): se l'estremo non si e'
      //    mosso non si tocca nulla.
      bool piuLargo = isLong ? (want < cur-tol) : (want > cur+tol);
      if(!piuLargo) continue;

      //--- e comunque dalla parte giusta del mercato e oltre lo stops level
      double ref = isLong ? SymbolInfoDouble(_Symbol,SYMBOL_BID) : SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      if(ref<=0.0) continue;
      bool valido = isLong ? (want < ref-minDist) : (want > ref+minDist);
      if(!valido) continue;

      if(gTrade.PositionModify(tk,want,tp))
        {
         cX_slsync++;
         Log(StringFormat("OOPS: stop risincronizzato oltre l'estremo del giorno del gap (%s -> %s).",
             DoubleToString(cur,_Digits),DoubleToString(want,_Digits)));
        }
      else
         Log("risincronizzazione dello stop OOPS FALLITA: "+gTrade.ResultRetcodeDescription());
     }
  }

//==================================================================
//  USCITA "FIRST PROFITABLE OPEN" (Williams).
//  Chiamata SOLO al cambio di giornata D1, cioe' all'apertura della
//  nuova candela giornaliera: se la posizione e' in profitto si esce a
//  mercato, altrimenti si resta (lo SL e' sul server) e si riprova
//  all'apertura successiva. "Le aperture sono dei polli, le chiusure
//  dei professionisti": qui si vende ai polli.
//==================================================================
void TryFirstProfitableOpen()
  {
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      datetime opened=(datetime)PositionGetInteger(POSITION_TIME);
      if(opened<=0) continue;
      //--- solo dalle aperture SUCCESSIVE al giorno d'ingresso: nel
      //    giorno stesso non esiste "prima apertura in guadagno".
      int shift=iBarShift(_Symbol,PERIOD_D1,opened,false);
      if(shift<1) continue;

      //--- "in profitto" = P/L a mercato + swap. La commissione non e'
      //    leggibile dalla posizione: su strumenti a commissione alta il
      //    trade puo' uscire lordo-positivo e netto-appena-negativo.
      //    Dichiarato, non nascosto.
      double pl=PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
      if(pl<=0.0)
        { Log(StringFormat("apertura D1: posizione ancora in perdita (%.2f): si resta, stop sul server.",pl)); continue; }

      if(gTrade.PositionClose(tk))
        { cX_fpo++; Log(StringFormat("FIRST PROFITABLE OPEN: chiusa a mercato in guadagno (%.2f) dopo %d giorni D1.",pl,shift)); }
      else
         Log("chiusura first-profitable-open FALLITA: "+gTrade.ResultRetcodeDescription());
     }
  }

//==================================================================
//  TIME-STOP IN GIORNI D1: il riassorbimento della punta e' rapido o
//  non e'. Oltre InpMaxDaysHold giorni non stiamo piu' tradando il
//  pattern, stiamo solo sperando.
//==================================================================
void ManageTimeStop()
  {
   if(InpMaxDaysHold<=0) return;

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      datetime opened=(datetime)PositionGetInteger(POSITION_TIME);
      if(opened<=0) continue;
      int shift=iBarShift(_Symbol,PERIOD_D1,opened,false);
      if(shift<InpMaxDaysHold) continue;

      if(gTrade.PositionClose(tk))
        { cX_time++; Log(StringFormat("TIME-STOP: posizione aperta da %d giorni D1 chiusa a mercato.",shift)); }
      else
         Log("chiusura per time-stop FALLITA: "+gTrade.ResultRetcodeDescription());
     }
  }

//==================================================================
//  PULIZIA DEI PENDENTI (cambio giornata): rete di sicurezza contro i
//  broker che non onorano l'expiration e contro i riavvii.
//==================================================================
void CleanupPendings()
  {
   for(int k=OrdersTotal()-1;k>=0;k--)
     {
      ulong tk=OrderGetTicket(k);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;

      if(gTrade.OrderDelete(tk))
        {
         if(tk==gPendTicket && gState==DAY_PENDING) cP_expired++;
         Log("pendente della giornata precedente cancellato (mai riempito).");
        }
      else
         Log("cancellazione del pendente scaduto FALLITA: "+gTrade.ResultRetcodeDescription());

      if(tk==gPendTicket){ gPendTicket=0; gState=DAY_DONE; }
     }
  }

//==================================================================
//  ESITI (per il funnel): TP e SL li dichiara il server; first
//  profitable open e time-stop li contiamo noi dove li ordiniamo.
//  Qui si intercetta anche il RIEMPIMENTO del pendente.
//==================================================================
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
   if(trans.type!=TRADE_TRANSACTION_DEAL_ADD) return;
   ulong d=trans.deal;
   if(d==0) return;
   if(!HistoryDealSelect(d)) return;
   if(HistoryDealGetInteger(d,DEAL_MAGIC)!=InpMagic) return;
   if(HistoryDealGetString(d,DEAL_SYMBOL)!=_Symbol) return;

   long entry=HistoryDealGetInteger(d,DEAL_ENTRY);
   if(entry==DEAL_ENTRY_IN)
     { gJustFilled=true; return; }
   if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) return;

   long reason=HistoryDealGetInteger(d,DEAL_REASON);
   if(reason==(long)DEAL_REASON_TP)      cE_tp++;
   else if(reason==(long)DEAL_REASON_SL) cE_sl++;
   else                                  cE_other++;   // include fpo e time-stop, contati a parte
  }

//==================================================================
//  UTILITY
//==================================================================
//--- ATR(D1) allo shift 1: la barra giornaliera CHIUSA. Lo shift 0 e'
//    la giornata appena aperta (lunga pochi minuti al momento in cui
//    misuriamo): usarla darebbe un metro sbagliato proprio adesso.
double AtrD1()
  {
   double a[];
   ArraySetAsSeries(a,true);
   int got=CopyBuffer(hAtrD1,0,0,3,a);
   if(got<2) return(0.0);
   double v=a[1];
   if(v<=0.0) v=a[0];
   if(v<=0.0) return(0.0);
   return(v);
  }

//--- spread corrente in POINTS, calcolato da ask/bid: e' l'unica misura
//    che vale su tutti i simboli (2, 3 o 5 decimali) e in tutte le
//    modalita' del tester, dove SYMBOL_SPREAD puo' restare fermo.
int SpreadPoints()
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0 || _Point<=0.0)
      return((int)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
   return((int)MathRound((ask-bid)/_Point));
  }

bool SpreadOK()
  {
   if(InpMaxSpreadPts<=0) return(true);
   return(SpreadPoints()<=InpMaxSpreadPts);
  }

double StopsMinDist()
  {
   double d=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double sp=(double)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)*_Point;
   return(MathMax(d,sp));
  }

//--- il simbolo accetta l'expiration a data/ora precisa? Se no si usa
//    GTC e la scadenza la facciamo rispettare noi a fine giornata.
bool ExpirySupported()
  {
   long modes=SymbolInfoInteger(_Symbol,SYMBOL_EXPIRATION_MODE);
   return((modes & SYMBOL_EXPIRATION_SPECIFIED)!=0);
  }

//--- normalizzazione al TICK SIZE prima che ai decimali: su alcuni simboli
//    (indici, metalli) il tick non e' 1 point e un prezzo "giusto" ma non
//    allineato al tick fa rifiutare l'ordine.
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0.0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0.0) return(0.0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  Perdita per lotto dal BROKER, non dal tick value nudo (lezione 08/08/2026:
   //  su alcuni simboli il tick value arriva non convertito e il lotto finisce
   //  sempre al minimo). OrderCalcProfit converte correttamente.
   double lossPerLot=0.0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0.0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0.0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0.0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0.0||tsz<=0.0) return(0.0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0.0) return(0.0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0.0) st=0.01;
   lot=MathFloor(lot/st)*st;
   //  NOTA (comportamento di famiglia, identico agli altri EA): il lotto viene
   //  comunque riportato al MINIMO del simbolo. Su conti piccoli o stop molto
   //  larghi il rischio effettivo puo' quindi superare InpRiskPercent: e' un
   //  limite del broker, non una scelta di money management.
   return(MathMax(mn,MathMin(mx,lot)));
  }

int CountPositions()
  {
   int n=0;
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

int CountPendings()
  {
   int n=0;
   for(int k=OrdersTotal()-1;k>=0;k--)
     {
      ulong tk=OrderGetTicket(k);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//--- guardia reload-safe: esiste gia' un ingresso del mio magic dentro la
//    giornata D1 che inizia a dayStart? Serve dopo un riavvio, quando lo
//    stato in memoria e' perso.
bool GiaOperatoOggi(datetime dayStart)
  {
   datetime tTo=(datetime)((long)dayStart+(long)PeriodSeconds(PERIOD_D1));
   if(!HistorySelect(dayStart,tTo)) return(false);
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetString(tk,DEAL_SYMBOL)!=_Symbol) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }

//==================================================================
//  FUNNEL DI MORTALITA' [LARRY-FUNNEL] (solo Print a fine test).
//  Il campione e' piccolo PER COSTRUZIONE (al massimo un'occasione al
//  giorno, e quasi mai): se l'EA resta muto bisogna sapere SUBITO se
//  e' perche' il pattern non si presenta, perche' il filtro dimensione
//  lo boccia, perche' il livello non era piazzabile o perche' i
//  pendenti non si sono mai riempiti.
//  Nessun impatto sul CSV (che nasce da FrameAdd/OnTesterDeinit).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[LARRY-FUNNEL] %s %s  pattern=%d (%s)  exit=%d  slMode=%d  sizeMin=%.2f sizeMax=%s xATR(D1,%d)  maxDays=%d  lati: L=%s S=%s  maxSpread=%d  finestra=%d barre",
               _Symbol,EnumToString(InpTF),InpPatternMode,ModeName(InpPatternMode),
               InpExitMode,InpSLMode,InpSizeMinATR,
               (InpSizeMaxATR>0.0?DoubleToString(InpSizeMaxATR,2):"off"),InpAtrPeriodD1,
               InpMaxDaysHold,(InpAllowLong?"ON":"OFF"),(InpAllowShort?"ON":"OFF"),
               InpMaxSpreadPts,InpEntryWindowBars);
   PrintFormat("[LARRY-FUNNEL] GIORNI osservati=%d | saltati: giaOperato/occupato=%d datiD1Mancanti=%d atrMancante=%d",
               (int)cD_days,(int)cD_busy,(int)cD_nodata,(int)cD_noatr);
   PrintFormat("[LARRY-FUNNEL] SETUP   nessun pattern=%d | rilevati=%d (long=%d short=%d) | scartati per lato disabilitato=%d",
               (int)cS_none,(int)(cS_long+cS_short),(int)cS_long,(int)cS_short,(int)cF_side);
   PrintFormat("[LARRY-FUNNEL] FILTRO DIMENSIONE  bocciati sottoMin=%d sopraMax=%d (metro ATR(D1,%d))",
               (int)cF_min,(int)cF_max,InpAtrPeriodD1);
   PrintFormat("[LARRY-FUNNEL] ORDINI  scartati: spread=%d livello/stopsLevel=%d lotto=%d invioFallito=%d  ==> PENDENTI PIAZZATI=%d (buy=%d sell=%d)",
               (int)cO_spread,(int)cO_failLevel,(int)cO_failLot,(int)cO_failSend,
               (int)cP_placed,(int)cP_long,(int)cP_short);
   PrintFormat("[LARRY-FUNNEL] PENDENTI  riempiti=%d  scaduti senza fill=%d  (stop OOPS risincronizzati=%d)",
               (int)cP_filled,(int)cP_expired,(int)cX_slsync);
   PrintFormat("[LARRY-FUNNEL] ESITI   TP=%d  SL=%d  altre chiusure=%d (di cui first-profitable-open=%d, time-stop=%d) | trade eseguiti=%d",
               (int)cE_tp,(int)cE_sl,(int)cE_other,(int)cX_fpo,(int)cX_time,
               (int)TesterStatistics(STAT_TRADES));
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
