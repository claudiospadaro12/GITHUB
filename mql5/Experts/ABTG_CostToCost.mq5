//+------------------------------------------------------------------+
//|                                          ABTG_CostToCost.mq5     |
//|                                                                  |
//|  EA di LABORATORIO "COST-TO-COST SULLE PUNTE DI LARRY" - MT5     |
//|  TUTTO-IN-UNO (metti in MQL5\Experts e compila con F7: niente    |
//|  cartelle, niente include oltre a Trade.mqh).                    |
//|                                                                  |
//|  FONTE NORMATIVA                                                 |
//|   1. backtest_pipeline/prove/COSTTOCOST_TESI.md (VINCOLANTE:     |
//|      tesi scritta PRIMA di qualunque numero, 13/08/2026).        |
//|   2. docs/larry/pine_market_structure_smollet.pine (Pine open    |
//|      source "Larry Williams: Market Structure", MPL 2.0) e la    |
//|      fonte 11 di backtest_pipeline/prove/SMASH_DAY_TESI.md:      |
//|      da qui viene la MECCANICA DELLA STRUTTURA (regola della     |
//|      violazione + trend intermedio), non le regole di trading.   |
//|   3. Larry Williams (libro): ringed highs/lows, struttura del    |
//|      mercato, "tradare da costa a costa" dentro il range.        |
//|                                                                  |
//|  ATTENZIONE - LE FONTI SONO PARZIALI. Il Pine e' un DETECTOR:    |
//|  da' la definizione di punta e di trend intermedio e basta. Il   |
//|  corso parla di "costa a costa" ma non ha MAI scritto le regole  |
//|  operative. Quindi: la STRUTTURA e' GUIDA (fedele alla fonte),   |
//|  tutto il resto (ingresso, stop, target, filtri, time-stop,      |
//|  money management) e' SCELTA NOSTRA dichiarata negli input:      |
//|  PARAMETRI DA MISURARE, non verita' del corso.                   |
//|                                                                  |
//|  IL MECCANISMO (ipotesi della tesi)                              |
//|   Le punte confermate sono i livelli dove il mercato ha GIA'     |
//|   respinto il prezzo: fra due punte opposte c'e' un range vivo.  |
//|   Si entra alla CONFERMA di una punta (l'istante in cui la       |
//|   struttura dichiara "il minimo/massimo e' fatto") ma SOLO dal   |
//|   lato del trend intermedio, con target la punta opposta. E'     |
//|   mean-reversion DI STRUTTURA, non di oscillatore.               |
//|                                                                  |
//|  COSA FA (mappa REGOLA -> CODICE)                                |
//|   ProcessBar  (REGOLA DELLA VIOLAZIONE, fonte 2 - auto-adattiva, |
//|                NESSUN parametro N-barre)                         |
//|     - in salita si tiene il massimo piu' recente e il LOW della  |
//|       barra che l'ha fatto; quando una barra CHIUSA scende sotto |
//|       quel low, il massimo diventa PUNTA TOP confermata, la      |
//|       direzione passa a giu' e il tracking riparte da questa     |
//|       barra. Specchio esatto per la PUNTA BOTTOM in discesa.     |
//|   RegistraTop / RegistraBottom  (TREND INTERMEDIO im_dir)        |
//|     - TOP piu' bassa della precedente -> im_dir = -1 (regola     |
//|       della fonte: massimi decrescenti = giu');                  |
//|     - BOTTOM piu' alta della precedente -> im_dir = +1 (minimi   |
//|       crescenti = su');                                          |
//|     - i due casi speculari (TOP piu' alta, BOTTOM piu' bassa)    |
//|       aggiornano im_dir nel verso opposto: servono a impedire    |
//|       che un massimo CRESCENTE faccia scattare uno short o che   |
//|       un minimo DECRESCENTE faccia scattare un long (nota        |
//|       esplicita della tesi sugli ingressi);                      |
//|     - im_dir parte da 0 = INDEFINITO: finche' non esiste almeno  |
//|       una COPPIA di punte sul lato che serve NON si opera (le    |
//|       barre in quello stato sono contate nel funnel).            |
//|   ValutaSegnale  (INGRESSO, a barra chiusa, a mercato)           |
//|     - LONG: BOTTOM appena confermata + im_dir == +1;             |
//|     - SHORT: TOP appena confermata + im_dir == -1;               |
//|     - UN trade per conferma: niente rientri finche' non si       |
//|       conferma una punta NUOVA, una posizione alla volta.        |
//|   TryEnter  (spread, stops level, lotto)                         |
//|     - filtro spread con riprova entro InpEntryWindowBars barre   |
//|       (poi il segnale e' perso: la punta invecchia);             |
//|     - SL oltre la punta appena confermata + InpSLBufferATR x ATR;|
//|     - SL e TP sono ordini VERI sul server: niente stealth.       |
//|   Uscite (InpExitMode)                                           |
//|     - MODO 0 COST-TO-COST puro: TP fisso sull'ultima punta       |
//|       OPPOSTA confermata al momento dell'ingresso;               |
//|     - MODO 1 R-based: TP a InpTP_R x rischio iniziale;           |
//|     - MODO 2 FLIP DI STRUTTURA: nessun TP, si esce a mercato     |
//|       quando im_dir cambia segno (trailing strutturale);         |
//|     - sempre: time-stop InpMaxBarsHold barre di InpTF (trappola  |
//|       3 della tesi: in trend forte il target scappa in avanti).  |
//|                                                                  |
//|  RELOAD-SAFE: all'avvio la struttura viene RICOSTRUITA scorrendo |
//|  le ultime InpWarmupBars barre CHIUSE, ma le conferme trovate    |
//|  nel warmup NON generano ordini (non le abbiamo osservate dal    |
//|  vivo): si opera solo sulle conferme fresche. In piu' si         |
//|  controlla lo storico dei deal del magic prima di ogni ingresso. |
//|                                                                  |
//|  DIAGNOSTICA: funnel [COST-FUNNEL] stampato da OnTester. La      |
//|  conferma della punta arriva PER DEFINIZIONE in ritardo: se      |
//|  l'EA resta muto il funnel dice SUBITO dove muore (poche punte?  |
//|  trend intermedio mai definito? target dalla parte sbagliata?    |
//|  range troppo stretto?) senza autopsie.                          |
//|                                                                  |
//|  AVVERTENZE DELLA TESI (da leggere PRIMA dei numeri)             |
//|   - SOVRAPPOSIZIONE CON PTE: comprare il pullback confermato in  |
//|     trend su' e' parente stretto della Pullback-Trend-Entry. Le  |
//|     correlazioni si misurano PRIMA di qualunque vivaio.          |
//|   - La conferma e' in ritardo per costruzione: su TF bassi il    |
//|     ritardo si mangia il range (attesa: H1 stretto, H4/D1 piu'   |
//|     respiro). Lo dira' lo scan multi-TF.                         |
//|   - L'OHLC non vede lo spread: OHLC SOLO per frequenza e         |
//|     screening, i VERDETTI SOLO a tick reali.                     |
//|                                                                  |
//|  DEMO. Nessuna garanzia. Non compilato ne' testato dall'autore   |
//|  del codice: compilare in MetaEditor e validare nel tester.      |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.00 - Prima stesura, dalla tesi COSTTOCOST_TESI.md.             |
//|    Nessun numero misurato ancora: TUTTI i default sono valori di  |
//|    partenza ragionevoli, non tarature. In particolare:            |
//|      - InpMinRangeATR 0.0 = FILTRO LARGHEZZA SPENTO allo          |
//|        screening. E' voluto: alla prima passata serve la          |
//|        FREQUENZA (quante volte il cost-to-cost esiste), i filtri  |
//|        vengono dopo, uno alla volta.                              |
//|      - InpSLBufferATR 0.2 = un quinto di ATR oltre la punta: lo   |
//|        stop sta appena FUORI dalla punta, non sul suo prezzo      |
//|        esatto (dove lo prende il rumore che ha appena creato la   |
//|        punta stessa).                                             |
//|      - InpMaxBarsHold 100 barre = guinzaglio largo: serve a       |
//|        tagliare i trade dimenticati, non a fare da uscita.        |
//|      - InpTP_R 1.5 vale SOLO con InpExitMode 1: e' l'alternativa  |
//|        misurabile al cost-to-cost puro, non una regola del corso. |
//|      - InpWarmupBars 500 = quante barre chiuse si rileggono       |
//|        all'avvio per ricostruire la struttura (piu' che           |
//|        sufficienti per avere due punte per lato su qualsiasi TF). |
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
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF della STRUTTURA e dell'esecuzione (le punte si leggono qui). SCELTA NOSTRA: H1, da spazzolare H4/D1

input group "=== Uscite (SCELTA NOSTRA: il corso non scrive le regole) ==="
input int    InpExitMode       = 0;     // 0 = COST-TO-COST puro (TP sull'ultima punta opposta); 1 = R-based (TP a N x rischio); 2 = FLIP DI STRUTTURA (esci quando gira il trend intermedio)
input double InpTP_R           = 1.5;   // SCELTA NOSTRA (solo ExitMode 1): TP = N x rischio iniziale

input group "=== Stop loss (GUIDA per il livello, SCELTA NOSTRA per il buffer) ==="
input double InpSLBufferATR    = 0.2;   // SCELTA NOSTRA: buffer oltre la punta appena confermata, in frazioni di ATR(InpTF)

input group "=== Misura del range (SCELTA NOSTRA: le fonti non quantificano) ==="
input int    InpAtrPeriod      = 14;    // SCELTA NOSTRA: periodo ATR su InpTF (metro del buffer e della larghezza)
input double InpMinRangeATR    = 0.0;   // SCELTA NOSTRA: distanza minima ingresso->target in ATR. 0 = filtro SPENTO (default di screening: prima la frequenza)

input group "=== Time-stop (SCELTA NOSTRA: guinzaglio, non uscita) ==="
input int    InpMaxBarsHold    = 100;   // barre di InpTF massime in posizione, poi flat a mercato. 0 = spento

input group "=== Ricostruzione della struttura all'avvio ==="
input int    InpWarmupBars     = 500;   // barre CHIUSE rilette all'avvio per ricostruire punte e trend intermedio (le conferme del warmup NON generano ordini)

input group "=== Lati (LATI SEPARATI OBBLIGATORI, tesi) ==="
input bool   InpAllowLong      = true;  // abilita gli ingressi LONG
input bool   InpAllowShort     = true;  // abilita gli ingressi SHORT

input group "=== Finestra d'ingresso e spread ==="
input int    InpMaxSpreadPts   = 0;     // spread massimo in POINTS all'ingresso. 0 = filtro spento (obbligatorio ACCENDERLO nei run a tick reali)
input int    InpEntryWindowBars= 3;     // SCELTA NOSTRA: barre di InpTF entro cui riprovare se lo spread e' sopra soglia (poi il segnale e' perso)

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;   // Rischio % per operazione (sulla distanza di stop)

input group "=== Generali ==="
input long   InpMagic          = 772311;  // magic number
input string InpComment        = "COST";  // commento ordini
input bool   InpVerbose        = true;    // log estesi

//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE;

datetime gLastBar=0;          // ora della barra InpTF in formazione, per il rilevamento della nuova barra
datetime gLastProcessed=0;    // ora dell'ultima barra CHIUSA gia' passata dentro ProcessBar

//--- STRUTTURA DELLE PUNTE (regola della violazione, fonte 2)
//    gSwDir: +1 = sto seguendo un MASSIMO in formazione (gamba su),
//            -1 = sto seguendo un MINIMO in formazione (gamba giu'),
//             0 = non ancora inizializzata.
int      gSwDir=0;
double   gCurHigh=0.0;        // massimo piu' recente della gamba su
double   gCurHighLow=0.0;     // LOW della barra che ha fatto quel massimo (il livello da violare)
double   gCurLow=0.0;         // minimo piu' recente della gamba giu'
double   gCurLowHigh=0.0;     // HIGH della barra che ha fatto quel minimo (il livello da violare)

bool     gHasTop=false, gHasBot=false;
double   gLastTop=0.0, gPrevTop=0.0;   // ultime due PUNTE TOP confermate
double   gLastBot=0.0, gPrevBot=0.0;   // ultime due PUNTE BOTTOM confermate
int      gImDir=0;                     // TREND INTERMEDIO: +1 su, -1 giu', 0 indefinito

bool     gWarmup=false;                // true durante la ricostruzione all'avvio: nessun ordine

//--- SEGNALE ARMATO (una conferma di punta in attesa di uno spread accettabile)
bool     gSigArmed=false;
int      gSigDir=0;           // +1 = LONG, -1 = SHORT
double   gSigEntryRef=0.0;    // close della barra della conferma (prezzo di riferimento del filtro larghezza)
double   gSigTarget=0.0;      // punta OPPOSTA confermata = target cost-to-cost
double   gSigPunta=0.0;       // prezzo della punta appena confermata (base dello stop)
double   gSigAtr=0.0;         // ATR congelato alla conferma
datetime gSigBarTime=0;       // ora della barra della conferma
int      gSigBars=0;          // barre trascorse dentro la finestra d'ingresso (la conferma vale 1)

//--- CONTATORI DEL FUNNEL [COST-FUNNEL] (solo diagnostica, stampati da
//    OnTester: nessun impatto sul CSV, che nasce da FrameAdd/OnTesterDeinit)
long cW_bars=0;
long cB_bars=0, cB_noim=0;
long cP_top=0,  cP_bot=0;
long cS_long=0, cS_short=0;
long cR_noim=0, cR_contro=0, cR_late=0;
long cF_side=0, cF_target=0, cF_range=0, cF_atr=0, cF_busy=0;
long cO_spread=0, cO_failLevel=0, cO_failLot=0, cO_failSend=0;
long cI_long=0, cI_short=0;
long cE_tpCost=0, cE_tpR=0, cE_sl=0, cE_other=0;
long cX_flip=0, cX_time=0;

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[COST] ", m); }

string ExitModeName(int m)
  {
   if(m==0) return("cost-to-cost puro");
   if(m==1) return("R-based");
   return("flip di struttura");
  }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   //--- validazione degli input: meglio un INIT_FAILED che un EA che
   //    opera di nascosto con parametri fuori dominio.
   if(PeriodSeconds(InpTF)<=0)
     { Print("ERRORE: InpTF non valido."); return(INIT_FAILED); }
   if(InpExitMode<0 || InpExitMode>2)
     { Print("ERRORE: InpExitMode deve essere 0 (cost-to-cost), 1 (R-based) o 2 (flip di struttura)."); return(INIT_FAILED); }
   if(InpExitMode==1 && InpTP_R<=0.0)
     { Print("ERRORE: InpTP_R deve essere > 0 quando InpExitMode = 1."); return(INIT_FAILED); }
   if(InpSLBufferATR<0.0)
     { Print("ERRORE: InpSLBufferATR non puo' essere negativo."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpMinRangeATR<0.0)
     { Print("ERRORE: InpMinRangeATR non puo' essere negativo (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpMaxBarsHold<0)
     { Print("ERRORE: InpMaxBarsHold deve essere >= 0 (0 = time-stop spento)."); return(INIT_FAILED); }
   if(InpWarmupBars<0)
     { Print("ERRORE: InpWarmupBars deve essere >= 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati disabilitati: l'EA non avrebbe nulla da fare."); return(INIT_FAILED); }
   if(InpMaxSpreadPts<0)
     { Print("ERRORE: InpMaxSpreadPts deve essere >= 0 (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpEntryWindowBars<1)
     { Print("ERRORE: InpEntryWindowBars deve essere >= 1 (1 = solo la barra della conferma)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0.0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- ATR sul TF DELLA STRUTTURA: il metro del buffer e della larghezza
   //    del range deve avere lo stesso respiro delle punte che misura.
   hAtr = iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: creazione handle ATR su InpTF."); return(INIT_FAILED); }

   //--- RELOAD-SAFE: la struttura si RICOSTRUISCE dalle barre chiuse.
   //    Senza questo, dopo un riavvio l'EA resterebbe cieco per decine di
   //    barre (servono due punte per lato prima di avere un trend
   //    intermedio). Le conferme trovate qui NON generano ordini: non le
   //    abbiamo osservate dal vivo e sarebbero ingressi in ritardo.
   RicostruisciStruttura();

   gSigArmed=false; gSigDir=0; gSigBars=0;
   gLastBar=iTime(_Symbol,InpTF,0);

   Log(StringFormat("avviato su %s %s. Uscita %d (%s%s). SL oltre la punta + %.2f x ATR(%d). "
                    "Range minimo %s x ATR. Time-stop %s. Warmup %d barre. Lati: %s%s. "
                    "Spread max %s points, finestra %d barre. Rischio %.2f%%.",
       _Symbol,EnumToString(InpTF),InpExitMode,ExitModeName(InpExitMode),
       (InpExitMode==1?StringFormat(" %.2f R",InpTP_R):""),
       InpSLBufferATR,InpAtrPeriod,
       (InpMinRangeATR>0.0?DoubleToString(InpMinRangeATR,2):"spento"),
       (InpMaxBarsHold>0?StringFormat("%d barre",InpMaxBarsHold):"spento"),
       InpWarmupBars,
       (InpAllowLong?"LONG ":""),(InpAllowShort?"SHORT":""),
       (InpMaxSpreadPts>0?IntegerToString(InpMaxSpreadPts):"spento"),InpEntryWindowBars,
       InpRiskPercent));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE){ IndicatorRelease(hAtr); hAtr=INVALID_HANDLE; }
  }

//==================================================================
//  RICOSTRUZIONE DELLA STRUTTURA ALL'AVVIO
//  Scorre le ultime InpWarmupBars barre CHIUSE (shift 1 = ultima
//  chiusa) senza mai leggere barre inesistenti. La barra in
//  formazione (shift 0) NON entra: la regola della violazione si
//  applica solo a barre chiuse.
//==================================================================
void RicostruisciStruttura()
  {
   gSwDir=0; gHasTop=false; gHasBot=false; gImDir=0;
   gLastTop=0.0; gPrevTop=0.0; gLastBot=0.0; gPrevBot=0.0;
   gLastProcessed=0;

   int disponibili=Bars(_Symbol,InpTF);
   if(disponibili<3)
     { Log("meno di 3 barre disponibili sul TF: struttura da costruire dal vivo."); return; }

   //--- si parte dalla piu' vecchia utile e si scende fino a shift 1
   //    (niente MathMin su interi: qui si resta su aritmetica intera pura)
   int da=InpWarmupBars;
   if(da>disponibili-1) da=disponibili-1;
   if(da<1) da=1;

   gWarmup=true;
   for(int s=da;s>=1;s--)
     {
      cW_bars++;
      ProcessBar(s);           // il valore di ritorno si ignora: nel warmup non si opera
     }
   gWarmup=false;

   gLastProcessed=iTime(_Symbol,InpTF,1);

   Log(StringFormat("struttura ricostruita su %d barre chiuse: TOP confermate=%d BOTTOM confermate=%d, "
                    "ultima TOP %s, ultima BOTTOM %s, trend intermedio %s.",
       da,(int)cP_top,(int)cP_bot,
       (gHasTop?DoubleToString(gLastTop,_Digits):"-"),
       (gHasBot?DoubleToString(gLastBot,_Digits):"-"),
       (gImDir>0?"SU":(gImDir<0?"GIU'":"indefinito"))));
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del
   //    giorno. Sta QUI e non dopo il filtro della nuova barra: su H1/H4 la
   //    caduta peggiore di giornata succede in mezzo alla candela.
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

   //--- TUTTA la logica lavora su barre CHIUSE del TF della struttura: la
   //    regola della violazione e' definita sulle chiusure, non sui tick.
   datetime t=iTime(_Symbol,InpTF,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   OnNewBar();
  }

void OnNewBar()
  {
   //--- si annota QUALE segnale era gia' armato prima di toccare la
   //    struttura: solo per quello vale la riprova sullo spread (una
   //    conferma nuova riparte con la sua finestra, non con quella vecchia).
   datetime sigPrima = (gSigArmed ? gSigBarTime : 0);

   //--- 1) la struttura si aggiorna PER PRIMA, senza ancora operare: e'
   //       lei che fa girare il trend intermedio.
   int confDir=0, confShift=0;
   ProcessNuoveBarre(confDir,confShift);

   //--- 2) uscite dell'EA (flip di struttura, time-stop) con la struttura
   //       GIA' AGGIORNATA e PRIMA degli ingressi: una posizione chiusa
   //       adesso libera il posto per l'eventuale nuovo segnale
   //       (stop-and-reverse strutturale, dichiarato e voluto).
   ManagePosition();

   //--- 3) conferma di punta appena avvenuta: si valuta l'ingresso.
   if(confDir!=0) ValutaSegnale(confDir,confShift);

   //--- 4) segnale VECCHIO ancora armato (aspettava uno spread
   //       accettabile): si consuma una barra della finestra e si riprova.
   if(gSigArmed && sigPrima>0 && gSigBarTime==sigPrima)
     {
      gSigBars++;
      TryEnter();
     }
  }

//==================================================================
//  AVANZAMENTO DELLA STRUTTURA SULLE BARRE CHIUSE NUOVE
//  Normalmente e' una barra sola (shift 1). Il recupero di piu' barre
//  serve se l'EA e' rimasto senza tick per un pezzo: la struttura non
//  deve MAI saltare barre, altrimenti le punte cambiano.
//  Riporta l'ULTIMA conferma incontrata (direzione e shift): le
//  eventuali conferme piu' vecchie del recupero sono stantie per
//  definizione e non si inseguono.
//==================================================================
void ProcessNuoveBarre(int &confDir,int &confShift)
  {
   confDir=0; confShift=0;

   datetime tUltima=iTime(_Symbol,InpTF,1);
   if(tUltima<=0) return;

   int da=1;
   if(gLastProcessed>0)
     {
      int sh=iBarShift(_Symbol,InpTF,gLastProcessed,false);
      if(sh==0)  return;          // gia' allineati (o storico incoerente): niente da fare
      if(sh>0)   da=sh-1;
      if(da<1)   return;          // nessuna barra chiusa nuova
     }

   //--- tetto di sicurezza: dopo una lunga assenza non si rilegge la storia
   //    intera a ogni barra (e comunque il warmup ha gia' fatto il grosso).
   int tetto=InpWarmupBars; if(tetto<50) tetto=50;
   if(da>tetto) da=tetto;

   for(int s=da;s>=1;s--)
     {
      cB_bars++;
      if(gImDir==0) cB_noim++;              // barre senza trend intermedio: qui non si opera per definizione
      int conf=ProcessBar(s);
      if(conf!=0){ confDir=conf; confShift=s; }
     }

   gLastProcessed=tUltima;
  }

//==================================================================
//  REGOLA DELLA VIOLAZIONE (GUIDA: Pine di Smollet, fonte 2)
//  Ritorna: +1 = PUNTA BOTTOM confermata su questa barra,
//           -1 = PUNTA TOP confermata,  0 = niente.
//  NOTA sull'ordine delle due verifiche (fedele al Pine): prima si
//  aggiorna l'estremo, poi si controlla la violazione. Cosi' una barra
//  che fa un nuovo massimo NON puo' confermare la punta con il proprio
//  low (le outside bar proseguono nella direzione corrente): la punta
//  la conferma sempre una barra SUCCESSIVA.
//==================================================================
int ProcessBar(int shift)
  {
   double h=iHigh(_Symbol,InpTF,shift);
   double l=iLow (_Symbol,InpTF,shift);
   if(h<=0.0 || l<=0.0 || h<l) return(0);    // storico bucato: la barra si ignora

   //--- inizializzazione: la prima barra letta apre una gamba SU per
   //    convenzione. E' un'arbitrarieta' dichiarata e innocua: la prima
   //    punta cosi' generata e' un artefatto, ma prima di poter operare
   //    servono comunque DUE punte per lato (im_dir indefinito fino ad
   //    allora), quindi l'artefatto e' gia' fuori dal campo operativo.
   if(gSwDir==0)
     {
      gSwDir=+1;
      gCurHigh=h; gCurHighLow=l;
      gCurLow =l; gCurLowHigh=h;
      return(0);
     }

   if(gSwDir>0)
     {
      //--- gamba SU: nuovo massimo -> la barra di riferimento e' QUESTA
      if(h>gCurHigh){ gCurHigh=h; gCurHighLow=l; }
      //--- violazione: il LOW scende sotto il low della barra del massimo
      if(l<gCurHighLow)
        {
         double top=gCurHigh;
         gSwDir=-1; gCurLow=l; gCurLowHigh=h;   // il tracking riparte da questa barra
         RegistraTop(top);
         return(-1);
        }
      return(0);
     }

   //--- gamba GIU': specchio esatto
   if(l<gCurLow){ gCurLow=l; gCurLowHigh=h; }
   if(h>gCurLowHigh)
     {
      double bot=gCurLow;
      gSwDir=+1; gCurHigh=h; gCurHighLow=l;
      RegistraBottom(bot);
      return(+1);
     }
   return(0);
  }

//==================================================================
//  TREND INTERMEDIO (GUIDA: massimi decrescenti = giu', minimi
//  crescenti = su'). I casi speculari (massimo crescente, minimo
//  decrescente) aggiornano im_dir nel verso opposto: senza di loro un
//  massimo CRESCENTE potrebbe far scattare uno short con un im_dir
//  vecchio ancora a -1, che e' esattamente il trade che la tesi
//  esclude ("solo dal lato del trend intermedio").
//  Punte IDENTICHE (stesso prezzo): im_dir non si tocca.
//==================================================================
void RegistraTop(double p)
  {
   if(gHasTop)
     {
      gPrevTop=gLastTop;
      if(p<gPrevTop)      gImDir=-1;   // massimo decrescente -> struttura giu'
      else if(p>gPrevTop) gImDir=+1;   // massimo crescente  -> il "giu'" e' smentito
     }
   gLastTop=p; gHasTop=true; cP_top++;
   if(!gWarmup && InpVerbose)
      Log(StringFormat("PUNTA TOP confermata a %s (precedente %s) -> trend intermedio %s.",
          DoubleToString(p,_Digits),(gPrevTop>0.0?DoubleToString(gPrevTop,_Digits):"-"),
          (gImDir>0?"SU":(gImDir<0?"GIU'":"indefinito"))));
  }

void RegistraBottom(double p)
  {
   if(gHasBot)
     {
      gPrevBot=gLastBot;
      if(p>gPrevBot)      gImDir=+1;   // minimo crescente   -> struttura su'
      else if(p<gPrevBot) gImDir=-1;   // minimo decrescente -> il "su'" e' smentito
     }
   gLastBot=p; gHasBot=true; cP_bot++;
   if(!gWarmup && InpVerbose)
      Log(StringFormat("PUNTA BOTTOM confermata a %s (precedente %s) -> trend intermedio %s.",
          DoubleToString(p,_Digits),(gPrevBot>0.0?DoubleToString(gPrevBot,_Digits):"-"),
          (gImDir>0?"SU":(gImDir<0?"GIU'":"indefinito"))));
  }

//==================================================================
//  SEGNALE: si valuta SOLO sull'evento di conferma di una punta.
//  conf: +1 = BOTTOM appena confermata (candidato LONG),
//        -1 = TOP appena confermata (candidato SHORT).
//  I filtri sono contati uno per uno: il funnel deve dire DOVE muore
//  il segnale, non solo che e' morto.
//==================================================================
void ValutaSegnale(int conf,int shift)
  {
   bool isLong=(conf>0);

   //--- trend intermedio: senza almeno una coppia di punte sul lato che
   //    serve, im_dir e' 0 e NON si opera (regola della tesi).
   if(gImDir==0){ cR_noim++; return; }
   if(( isLong && gImDir!=+1) || (!isLong && gImDir!=-1))
     { cR_contro++; return; }

   //--- SEGNALE GREZZO: contato QUI, prima di ogni filtro nostro, cosi'
   //    il funnel separa la frequenza del pattern dalle nostre bocciature.
   if(isLong) cS_long++; else cS_short++;

   //--- conferma non fresca: puo' capitare solo nel recupero di piu' barre
   //    (EA rimasto senza tick). Una punta confermata due o piu' barre fa
   //    non si insegue: il cost-to-cost e' gia' partito senza di noi.
   if(shift!=1){ cR_late++; Log("conferma vecchia (recupero barre): nessun ingresso."); return; }

   //--- LATI SEPARATI (tesi): l'asimmetria long/short e' un'attesa
   //    dichiarata, non una sorpresa.
   if((isLong && !InpAllowLong) || (!isLong && !InpAllowShort))
     { cF_side++; return; }

   //--- UNA POSIZIONE ALLA VOLTA per simbolo: niente piramidi.
   if(CountPositions()>0)
     { cF_busy++; Log("conferma valida ma posizione gia' aperta: nessun ingresso."); return; }

   //--- TARGET COST-TO-COST: l'ultima punta OPPOSTA confermata. Se non
   //    esiste ancora, o se sta dalla parte sbagliata del prezzo (in trend
   //    forte capita: la punta opposta e' gia' stata superata), il trade
   //    "da costa a costa" non esiste. Vale anche in ExitMode 1 e 2: senza
   //    la costa opposta non c'e' il range che la tesi vuole tradare.
   double entryRef=iClose(_Symbol,InpTF,shift);
   if(entryRef<=0.0){ cF_target++; return; }

   double target = isLong ? (gHasTop?gLastTop:0.0) : (gHasBot?gLastBot:0.0);
   if(target<=0.0)
     { cF_target++; Log("punta opposta non ancora disponibile: nessun target cost-to-cost."); return; }

   double ampiezza = isLong ? (target-entryRef) : (entryRef-target);
   if(ampiezza<=0.0)
     { cF_target++; Log("target cost-to-cost dalla parte sbagliata del prezzo: nessun ingresso."); return; }

   //--- ATR congelato alla conferma: e' il metro sia del buffer di stop sia
   //    del filtro di larghezza. Se manca non si tira a indovinare.
   double atr=AtrAt(shift);
   if(atr<=0.0){ cF_atr++; Log("ATR non disponibile: nessun ingresso."); return; }

   //--- FILTRO LARGHEZZA (SCELTA NOSTRA): un cost-to-cost piu' stretto
   //    dello spread e' un regalo al broker (tesi). Metro in ATR, non in
   //    punti: la soglia vale su indici, forex e metalli senza ritararla.
   if(InpMinRangeATR>0.0 && ampiezza < InpMinRangeATR*atr)
     {
      cF_range++;
      Log(StringFormat("range ingresso->target %.2f x ATR sotto il minimo %.2f: nessun ingresso.",
          ampiezza/atr,InpMinRangeATR));
      return;
     }

   //--- SEGNALE ARMATO: i livelli STRUTTURALI (punta e target) si congelano
   //    qui; il prezzo d'ingresso vero e' quello di mercato al momento
   //    dell'invio (una conferma a barra chiusa si esegue a mercato).
   gSigArmed=true;
   gSigDir=conf;
   gSigEntryRef=entryRef;
   gSigTarget=target;
   gSigPunta = isLong ? gLastBot : gLastTop;
   gSigAtr=atr;
   gSigBarTime=iTime(_Symbol,InpTF,shift);
   gSigBars=1;

   Log(StringFormat("SEGNALE %s alla conferma della punta %s a %s: riferimento %s, target %s (%.2f x ATR).",
       (isLong?"LONG":"SHORT"),(isLong?"BOTTOM":"TOP"),DoubleToString(gSigPunta,_Digits),
       DoubleToString(entryRef,_Digits),DoubleToString(target,_Digits),ampiezza/atr));

   TryEnter();
  }

//==================================================================
//  INGRESSO A MERCATO (con finestra di riprova sullo spread)
//  SL e TP sono ordini VERI sul server: se la connessione cade, la
//  posizione resta protetta.
//==================================================================
void TryEnter()
  {
   if(!gSigArmed) return;

   //--- il posto puo' essersi occupato fra la conferma e la riprova
   if(CountPositions()>0)
     { cF_busy++; DisarmaSegnale(); return; }

   //--- guardia reload-safe: se lo storico dei deal dice che su questa
   //    stessa conferma abbiamo gia' aperto (riavvio a cavallo della
   //    barra), non si raddoppia.
   if(GiaOperatoDallaBarra(gSigBarTime))
     { Log("risultano gia' deal del magic da questa conferma: nessun ingresso."); DisarmaSegnale(); return; }

   //--- filtro spread: non si entra dentro un allargamento. Si riprova
   //    sulle barre successive finche' la finestra regge; poi il segnale
   //    e' perso (la punta invecchia, non si insegue).
   if(!SpreadOK())
     {
      if(gSigBars>=InpEntryWindowBars)
        {
         cO_spread++;
         Log(StringFormat("spread %d points sopra il limite %d per tutta la finestra (%d barre): segnale perso.",
             SpreadPoints(),InpMaxSpreadPts,InpEntryWindowBars));
         DisarmaSegnale();
        }
      else
         Log(StringFormat("spread %d points sopra il limite %d: rinvio alla barra successiva (barra %d di %d).",
             SpreadPoints(),InpMaxSpreadPts,gSigBars,InpEntryWindowBars));
      return;
     }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0)
     { cO_failSend++; Log("prezzi non disponibili: nessun ordine."); DisarmaSegnale(); return; }

   bool   isLong=(gSigDir>0);
   double entry = isLong ? ask : bid;
   double minDist=StopsMinDist();

   //--- STOP LOSS: oltre la punta appena confermata + buffer in ATR. Lo
   //    stop sta appena FUORI dalla punta, non sul suo prezzo esatto.
   double sl = isLong ? (gSigPunta - InpSLBufferATR*gSigAtr)
                      : (gSigPunta + InpSLBufferATR*gSigAtr);
   sl=NormalizePrice(sl);

   bool slOk = isLong ? (sl < entry-minDist) : (sl > entry+minDist);
   if(!slOk)
     {
      cO_failLevel++;
      Log(StringFormat("SL non valido (%s contro ingresso %s, distanza minima %s): nessun ordine.",
          DoubleToString(sl,_Digits),DoubleToString(entry,_Digits),DoubleToString(minDist,_Digits)));
      DisarmaSegnale(); return;
     }

   double riskDist = isLong ? (entry-sl) : (sl-entry);
   if(riskDist<=0.0)
     { cO_failLevel++; Log("distanza di stop nulla: nessun ordine."); DisarmaSegnale(); return; }

   //--- TAKE PROFIT
   //    MODO 0: la punta opposta (cost-to-cost puro), congelata alla conferma;
   //    MODO 1: N x rischio;
   //    MODO 2: nessun TP, l'uscita e' il flip del trend intermedio.
   double tp=0.0;
   if(InpExitMode==0) tp=gSigTarget;
   else if(InpExitMode==1) tp = isLong ? (entry+InpTP_R*riskDist) : (entry-InpTP_R*riskDist);

   if(tp>0.0)
     {
      tp=NormalizePrice(tp);
      bool tpOk = isLong ? (tp > entry+minDist) : (tp < entry-minDist);
      if(!tpOk)
        {
         //--- nel MODO 0 questo e' il caso "il prezzo si e' gia' mangiato il
         //    range durante la finestra di riprova": il cost-to-cost non
         //    esiste piu' e non lo si sostituisce con un target inventato.
         cO_failLevel++;
         Log(StringFormat("TP troppo vicino o superato (%s contro ingresso %s): nessun ordine.",
             DoubleToString(tp,_Digits),DoubleToString(entry,_Digits)));
         DisarmaSegnale(); return;
        }
     }

   double lot=LotByRisk(riskDist);
   if(lot<=0.0)
     { cO_failLot++; Log("lotto nullo: nessun ordine."); DisarmaSegnale(); return; }

   string cm=InpComment+(isLong?" L":" S");
   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_CostToCost")) return;
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(!ok)
     { cO_failSend++; Log("apertura FALLITA: "+gTrade.ResultRetcodeDescription()); DisarmaSegnale(); return; }

   if(isLong) cI_long++; else cI_short++;

   //--- nel log finisce anche lo SCARTO fra il close della conferma e il
   //    prezzo davvero eseguito: e' il costo del ritardo della conferma,
   //    la trappola 4 della tesi, e va misurato, non intuito.
   Log(StringFormat("%s a mercato @ %s  SL %s  TP %s  lot %.2f  (punta %s, target %s, uscita %s, rischio %s, "
                    "riferimento conferma %s, scarto %s)",
       (isLong?"LONG":"SHORT"),DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),
       (tp>0.0?DoubleToString(tp,_Digits):"-"),lot,
       DoubleToString(gSigPunta,_Digits),DoubleToString(gSigTarget,_Digits),
       ExitModeName(InpExitMode),DoubleToString(riskDist,_Digits),
       DoubleToString(gSigEntryRef,_Digits),
       DoubleToString(isLong?(entry-gSigEntryRef):(gSigEntryRef-entry),_Digits)));

   DisarmaSegnale();
  }

void DisarmaSegnale()
  {
   gSigArmed=false; gSigDir=0; gSigBars=0;
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE APERTA
//   - MODO 2: uscita al FLIP del trend intermedio (trailing
//     strutturale: si resta finche' la struttura dice la stessa cosa);
//   - sempre: time-stop in barre di InpTF (trappola 3 della tesi: in
//     trend forte il target cost-to-cost puo' restare irraggiungibile).
//==================================================================
void ManagePosition()
  {
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);

      //--- FLIP DI STRUTTURA
      if(InpExitMode==2 && gImDir!=0)
        {
         bool controStruttura = (isLong && gImDir<0) || (!isLong && gImDir>0);
         if(controStruttura)
           {
            if(gTrade.PositionClose(tk))
              { cX_flip++; Log("FLIP DI STRUTTURA: trend intermedio girato, posizione chiusa a mercato."); }
            else
               Log("chiusura per flip di struttura FALLITA: "+gTrade.ResultRetcodeDescription());
            continue;
           }
        }

      //--- TIME-STOP in barre del TF operativo
      if(InpMaxBarsHold>0)
        {
         datetime opened=(datetime)PositionGetInteger(POSITION_TIME);
         if(opened<=0) continue;
         int shift=iBarShift(_Symbol,InpTF,opened,false);
         if(shift<InpMaxBarsHold) continue;

         if(gTrade.PositionClose(tk))
           { cX_time++; Log(StringFormat("TIME-STOP: posizione aperta da %d barre chiusa a mercato.",shift)); }
         else
            Log("chiusura per time-stop FALLITA: "+gTrade.ResultRetcodeDescription());
        }
     }
  }

//==================================================================
//  ESITI (per il funnel): TP e SL li dichiara il server; flip e
//  time-stop li contiamo noi dove li ordiniamo.
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
   if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) return;

   long reason=HistoryDealGetInteger(d,DEAL_REASON);
   if(reason==(long)DEAL_REASON_TP)
     {
      if(InpExitMode==0) cE_tpCost++;   // TP = punta opposta (cost-to-cost)
      else               cE_tpR++;      // TP = N x rischio
     }
   else if(reason==(long)DEAL_REASON_SL) cE_sl++;
   else                                  cE_other++;   // include flip e time-stop, contati a parte
  }

//==================================================================
//  UTILITY
//==================================================================
//--- ATR alla barra CHIUSA indicata: si legge allo stesso shift della
//    barra che ha confermato la punta, cosi' il metro e' quello del
//    momento del segnale e non quello di adesso.
double AtrAt(int shift)
  {
   if(shift<0) return(0.0);
   double a[];
   ArraySetAsSeries(a,false);
   if(CopyBuffer(hAtr,0,shift,1,a)!=1) return(0.0);
   if(a[0]<=0.0) return(0.0);
   return(a[0]);
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

//--- guardia reload-safe: esiste gia' un ingresso del mio magic FATTO SU
//    QUESTA conferma? Si guarda dalla CHIUSURA della barra della conferma
//    in avanti: prima di quell'istante il segnale non esisteva ancora,
//    quindi un deal precedente appartiene a un'altra conferma e non deve
//    bloccare questo ingresso.
bool GiaOperatoDallaBarra(datetime barTime)
  {
   if(barTime<=0) return(false);
   datetime tDa=(datetime)((long)barTime+(long)PeriodSeconds(InpTF));
   datetime tTo=(datetime)((long)TimeCurrent()+60);
   if(tDa>tTo) return(false);
   if(!HistorySelect(tDa,tTo)) return(false);
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
//  FUNNEL DI MORTALITA' [COST-FUNNEL] (solo Print a fine test).
//  La conferma della punta arriva in ritardo PER COSTRUZIONE e il
//  trend intermedio richiede due punte per lato: se l'EA resta muto
//  bisogna sapere SUBITO se e' perche' le punte sono poche, perche'
//  il trend intermedio non e' mai definito, perche' il target sta
//  dalla parte sbagliata o perche' lo bocciamo noi coi filtri.
//  Nessun impatto sul CSV (che nasce da FrameAdd/OnTesterDeinit).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[COST-FUNNEL] %s %s  exit=%d (%s)  tpR=%.2f  slBuf=%.2f xATR(%d)  minRange=%s xATR  maxBars=%d  warmup=%d  lati: L=%s S=%s  maxSpread=%d  finestra=%d barre",
               _Symbol,EnumToString(InpTF),InpExitMode,ExitModeName(InpExitMode),
               InpTP_R,InpSLBufferATR,InpAtrPeriod,
               (InpMinRangeATR>0.0?DoubleToString(InpMinRangeATR,2):"off"),
               InpMaxBarsHold,InpWarmupBars,
               (InpAllowLong?"ON":"OFF"),(InpAllowShort?"ON":"OFF"),
               InpMaxSpreadPts,InpEntryWindowBars);
   PrintFormat("[COST-FUNNEL] STRUTTURA  barre elaborate=%d (warmup=%d) | punte confermate (warmup incluso): TOP=%d BOTTOM=%d | barre senza trend intermedio=%d",
               (int)cB_bars,(int)cW_bars,(int)cP_top,(int)cP_bot,(int)cB_noim);
   PrintFormat("[COST-FUNNEL] SEGNALI   grezzi=%d (long=%d short=%d) | conferme scartate: trend indefinito=%d contro trend=%d non fresche=%d",
               (int)(cS_long+cS_short),(int)cS_long,(int)cS_short,
               (int)cR_noim,(int)cR_contro,(int)cR_late);
   PrintFormat("[COST-FUNNEL] FILTRI    lato spento=%d | target assente/dalla parte sbagliata=%d | range sotto il minimo=%d | ATR mancante=%d | posizione gia' aperta=%d",
               (int)cF_side,(int)cF_target,(int)cF_range,(int)cF_atr,(int)cF_busy);
   PrintFormat("[COST-FUNNEL] ORDINI    scartati: spread=%d livello/stopsLevel=%d lotto=%d invioFallito=%d  ==> ENTRATI=%d (long=%d short=%d)",
               (int)cO_spread,(int)cO_failLevel,(int)cO_failLot,(int)cO_failSend,
               (int)(cI_long+cI_short),(int)cI_long,(int)cI_short);
   PrintFormat("[COST-FUNNEL] ESITI     TP cost-to-cost=%d  TP R=%d  flip di struttura=%d  SL=%d  time-stop=%d  altre chiusure=%d | trade eseguiti=%d",
               (int)cE_tpCost,(int)cE_tpR,(int)cX_flip,(int)cE_sl,(int)cX_time,(int)cE_other,
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
