//+------------------------------------------------------------------+
//|                                          ABTG_AltaVelocita.mq5   |
//|                                                                  |
//|  EA "ALTA VELOCITA'" (metodo Manuela Negro) - MT5 - v2           |
//|  (metti in MQL5\Experts e compila con F7: nessuna dipendenza)    |
//|                                                                  |
//|  COSA FA                                                         |
//|  Trend following su analisi ciclica. Si sceglie un CICLO         |
//|  DIREZIONALE (InpCicloTF, default H4) e si entra 3 gradini sotto |
//|  sulla scala {M1,M5,M15,H1,H4,D1,W1,MN1} -> TF operativo M5.     |
//|  L'idea: stop minuscolo sul TF piccolo, target grande del ciclo  |
//|  grande (2 x ATR del ciclo direzionale, misurati DAL massimo /   |
//|  minimo di ciclo, non dall'ingresso).                            |
//|                                                                  |
//|  SCALA DERIVATA DAL CICLO (tutto calcolato con handle espliciti  |
//|  sui TF giusti: l'EA sta sul grafico operativo ma non "guarda"   |
//|  solo quello):                                                   |
//|    - TF operativo  (ingresso)   = ciclo - 3 gradini   (H4 -> M5) |
//|    - Williams contesto          = operativo + 1        (M15)     |
//|    - RSI contesto               = operativo + 2        (H1)      |
//|    - Supertrend di gestione     = operativo + 1        (M15)     |
//|    - ATR del target             = sul ciclo direzionale (H4)     |
//|                                                                  |
//|  SEQUENZA (esempio SELL; il BUY e' specchiato):                  |
//|    1. ROTTURA  : Supertrend operativo gira ROSSO su barra chiusa |
//|                  con RSI operativo in discesa. Si memorizza la   |
//|                  LINEA VIOLA (il livello Supertrend rotto) e     |
//|                  l'ESTREMO della fase (massimo di ciclo).        |
//|    2. RITEST   : il prezzo risale (chiusure crescenti o RSI su). |
//|    3. CONTROLLO: se nel ritest nasce un Supertrend verde, il suo |
//|                  livello deve essere <= linea viola, altrimenti  |
//|                  la rottura e' annullata e si torna in ATTESA.   |
//|    4. RIPARTENZA (SEGNALE): Supertrend di nuovo rosso con nuova  |
//|                  chiusura sotto, RSI operativo di nuovo giu',    |
//|                  CICLO operativo negativo, + i filtri:           |
//|                  Williams di contesto in zona estrema (o uscito  |
//|                  da poco), Williams operativo ancora nella prima |
//|                  meta' (sopra -50 nel sell), RSI di contesto     |
//|                  gia' in discesa, CICLO direzionale non girato   |
//|                  da troppe barre, filtro direzionale opzionale.  |
//|                                                                  |
//|  GESTIONE (il cuore, tutto meccanico)                            |
//|    - Supertrend operativo gira contro -> chiusura a mercato      |
//|      subito (piccola perdita, non si aspetta lo stop);           |
//|    - stop a zero quando il Williams operativo tocca la zona      |
//|      estrema opposta OPPURE il Supertrend attraversa l'ingresso; |
//|    - dopo lo stop a zero: trailing sul Supertrend del TF         |
//|      SUPERIORE, mai allargando ("scala di gestione");            |
//|    - uscita anticipata: N chiusure oltre la MA9 contro posizione |
//|      con RSI operativo contro;                                   |
//|    - SL e TP restano ORDINI VERI sul server; le uscite sopra     |
//|      sono chiusure anticipate via codice.                        |
//|                                                                  |
//|  ---------------------------------------------------------------|
//|  NOVITA' DELLA v2 (11/08): IL MOTORE DELLE PUNTE RSI PER CICLO   |
//|  ---------------------------------------------------------------|
//|  La v1/v1.1 leggeva l'RSI con un surrogato a lookback            |
//|  ("RSI giu' = RSI[1] < RSI[1+InpRsiLookback]"): il referto        |
//|  ROSSO su GBPUSD indicava proprio li' il cuore mancante, perche' |
//|  il manuale NON guarda l'RSI barra-contro-barra ma le sue PUNTE, |
//|  UNA PER CICLO, "mai saltarne uno".                              |
//|                                                                  |
//|  La v2 costruisce quelle punte:                                  |
//|    - l'oscillatore CICLO (composito di 4 stocastici - SMA9)      |
//|      segmenta il tempo: un ciclo si CHIUDE quando il CICLO cambia|
//|      segno su barra chiusa;                                      |
//|    - per OGNI ciclo si registra UNA punta dell'RSI(4): nel ciclo |
//|      POSITIVO il MASSIMO dell'RSI (col MASSIMO di PREZZO del     |
//|      ciclo), nel ciclo NEGATIVO il MINIMO dell'RSI (col MINIMO   |
//|      di prezzo). Nessun ciclo viene saltato, nemmeno minuscolo;  |
//|    - "RSI ribassista" (SELL) = le ultime DUE punte-MASSIMO sono  |
//|      DECRESCENTI; "RSI rialzista" (BUY) = le ultime due punte-   |
//|      MINIMO sono CRESCENTI;                                      |
//|    - classificazione rispetto al PREZZO (esempio SELL):          |
//|        DIVERGENZA  = massimi di prezzo crescenti + RSI decresc.  |
//|                      -> il caso migliore del manuale;            |
//|        CONVERGENZA = massimi di prezzo decrescenti + RSI decr.   |
//|                      -> valido;                                  |
//|        DOPPIO MASSIMO = due punte quasi uguali (entro            |
//|                      InpRsiFlatTol punti di RSI) -> NON valido,  |
//|                      "si aspetta" (regola esplicita del manuale).|
//|      Specchiato per il BUY sulle punte-minimo.                   |
//|                                                                  |
//|  Dove entra nella macchina a stati:                              |
//|    ROTTURA    -> due punte NELLA direzione (conv. o div.);       |
//|    RITEST     -> due punte CONTRARIE (per un sell: minimi RSI    |
//|                  crescenti);                                     |
//|    RIPARTENZA -> di nuovo nella direzione E classificazione:     |
//|                  InpRequireDivergence=1 accetta SOLO divergenza, |
//|                  =0 accetta divergenza O convergenza; il doppio  |
//|                  massimo/minimo non e' MAI valido.               |
//|    Anche l'RSI di CONTESTO (2 gradini sopra l'ingresso) e' letto |
//|    con le punte del SUO ciclo (CICLO calcolato sul TF di         |
//|    contesto), non piu' col confronto a lookback.                 |
//|                                                                  |
//|  FALLBACK: InpUseRsiPunte=false riproduce ESATTAMENTE la v1.1    |
//|  (torna il lookback InpRsiLookback, il ciclo di contesto non     |
//|  viene nemmeno calcolato). Serve per il confronto A/B nel tester:|
//|  stessa griglia, una sola variabile cambiata.                    |
//|                                                                  |
//|  COSTO: le punte si ricostruiscono in modo INCREMENTALE, una     |
//|  barra alla volta sul TF relativo (una sola ricostruzione piena  |
//|  all'avvio o dopo un buco nella continuita' delle barre).        |
//|                                                                  |
//|  LE APPROSSIMAZIONI ANCORA DICHIARATE                            |
//|    1. Delle trendline sulle punte resta la lettura a DUE punte:  |
//|       ventagli, canali e "pallina" restano fuori. L'uscita       |
//|       anticipata della gestione usa ancora MA9 + RSI a lookback  |
//|       (non toccata dalla v2: si cambia una cosa alla volta).     |
//|    2. Il gradino 100-tick non esiste nel tester MT5: la scala    |
//|       parte da M1 e le combo 100tick restano manuali.            |
//|    3. Niente hedging multiday, niente doppia uscita del Williams |
//|       come pattern esplicito, niente scelta discrezionale del    |
//|       cross: una posizione alla volta, nessuna griglia.          |
//|                                                                  |
//|  IPOTESI SWEEPABILI (il manuale NON dichiara i parametri):       |
//|    Supertrend ATR 10 x mult 3.0 e ATR 14 per il target sono      |
//|    IPOTESI, non valori del corso: sono input apposta perche' la  |
//|    FASE 0 misuri la sensibilita' invece di fidarsi del numero.   |
//|                                                                  |
//|  DEMO. Nessuna garanzia. Non compilato/testato dall'autore del   |
//|  codice: compilare in MetaEditor e validare nel tester.          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "2.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Scala dei timeframe ==="
input ENUM_TIMEFRAMES InpCicloTF = PERIOD_H4;  // Ciclo direzionale (operativo = 3 gradini sotto)

input group "=== Supertrend (IPOTESI: parametri non dichiarati dal manuale) ==="
input int    InpStAtrPeriod   = 10;    // ATR del Supertrend (ipotesi sweepabile)
input double InpStMult        = 3.0;   // Moltiplicatore Supertrend (ipotesi sweepabile)

input group "=== Williams %R (140) ==="
input int    InpWprPeriod     = 140;   // Periodo Williams %R (manuale: 140)
input double InpWprOB         = -20.0; // Ipercomprato
input double InpWprOS         = -80.0; // Ipervenduto
input double InpWprMid        = -50.0; // Limite "prima meta'": oltre non si entra
input int    InpWprGraceBars  = 10;    // Barre di tolleranza dopo l'uscita dalla zona estrema

input group "=== RSI (4) ==="
input int    InpRsiPeriod     = 4;     // Periodo RSI (manuale: 4)
input int    InpRsiLookback   = 6;     // FALLBACK v1.1: barre di confronto per "RSI giu'/su" (usato solo se InpUseRsiPunte=false)

input group "=== RSI: motore delle PUNTE per ciclo (v2 - il cuore del manuale) ==="
input bool   InpUseRsiPunte      = true; // true = punte di ciclo (v2); false = lookback (comportamento v1.1)
input int    InpRequireDivergence= 0;    // RIPARTENZA: 1 = SOLO divergenza; 0 = divergenza O convergenza (sweepabile)
input double InpRsiFlatTol       = 3.0;  // "doppio massimo/minimo": punte entro N punti RSI -> si aspetta (sweepabile)

input group "=== Ciclo / stato ==="
input int    InpMaxCicloAgeBars = 2;   // Max barre del ciclo direzionale dal cambio di segno
input int    InpRitestBars      = 2;   // Barre di risalita che validano il ritest
input int    InpFaseTimeoutBars = 40;  // Timeout di fase in barre operative
input bool   InpUseDirFilter    = true;// Filtro direzionale col Supertrend del TF superiore

input group "=== Stop e target ==="
input int    InpAtrPeriod     = 14;    // ATR del target sul ciclo direzionale (IPOTESI)
input double InpTargetATRmult = 2.0;   // Target = estremo di ciclo -/+ N x ATR (manuale: 2)
input int    InpSLBufferPoints= 10;    // Buffer dello stop in points, oltre l'estremo
input double InpMinRR         = 3.0;   // R/R minimo: sotto, il segnale NON si prende
input double InpMinStopAtrOp  = 0.8;   // v1.1 pavimento stop: >= x ATR operativo (manuale: stop ~ ATR M5; sotto = rumore da spread)
input double InpMaxStopAtrOp  = 4.0;   // v1.1 tetto stop: oltre = "grafico sbagliato" (manuale: 20 pip su ATR 5)

input group "=== Gestione ==="
input int    InpMa9Bars       = 2;     // Chiusure consecutive oltre la MA9 per l'uscita anticipata

input group "=== Rischio ==="
input double InpRiskPercent   = 1.0;   // Rischio % per operazione (manuale: 1% trend following)
input int    InpMaxTradesPerDay = 0;   // 0 = illimitati

input group "=== Filtro notizie (mai tradare l'istante della notizia) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "ALTAV";   // commento ordini
input long   InpMagic     = 771401;
input int    InpMaxSpread = 0;         // 0 = nessun limite (in points)
input bool   InpVerbose   = true;

//==================================================================
//  COSTANTI / STATO
//==================================================================
#define MA9_PERIOD   9
#define ST_BARS    300      // barre di calcolo del Supertrend (warm-up abbondante)
#define ST_MIN     120      // sotto questa soglia il Supertrend non e' affidabile
#define CYC_MAXSEG 120      // ricerca massima all'indietro per UN segmento di ciclo
#define CYC_NEED   (2*CYC_MAXSEG+6)  // barre di CICLO/prezzo servite sul ciclo direzionale

//--- v2: motore delle PUNTE dell'RSI (una per ciclo)
#define PUNTE_MAX       8   // punte tenute in memoria per TF (>=6: ne servono 2 per segno)
#define PUNTE_SEED_BARS 400 // ricostruzione UNA TANTUM all'avvio (poi solo incrementale)

//--- esito della lettura delle punte
#define RSIP_NONE  0        // dati insufficienti oppure punte NON nella direzione chiesta
#define RSIP_FLAT  1        // doppio massimo / doppio minimo: il manuale dice "aspetta"
#define RSIP_CONV  2        // convergenza: valida
#define RSIP_DIV   3        // divergenza: il caso migliore

//--- scala fissa (niente M30/M2: i parametri del metodo sono tarati su questa)
ENUM_TIMEFRAMES gScale[8]={PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};

ENUM_TIMEFRAMES gTfCiclo=PERIOD_H4;  // ciclo direzionale
ENUM_TIMEFRAMES gTfOp   =PERIOD_M5;  // operativo (ingresso)
ENUM_TIMEFRAMES gTfUp   =PERIOD_M15; // un gradino sopra l'operativo (gestione)
ENUM_TIMEFRAMES gTfWpr  =PERIOD_M15; // Williams di contesto
ENUM_TIMEFRAMES gTfRsi  =PERIOD_H1;  // RSI di contesto

int hAtrStOp=INVALID_HANDLE, hAtrStUp=INVALID_HANDLE, hAtrTgt=INVALID_HANDLE;
int hWprOp =INVALID_HANDLE, hWprCtx=INVALID_HANDLE;
int hRsiOp =INVALID_HANDLE, hRsiCtx=INVALID_HANDLE;
int hMa9   =INVALID_HANDLE;

//--- serie calcolate a ogni nuova barra operativa (indice 0 = barra in corso,
//    si legge SOLO da 1 in su: niente ripaint)
double gStOp[],  gStUp[];
double gDirOp[], gDirUp[];      // +1 verde / -1 rosso (double per uniformita' di copia)
double gCycOp[], gCycDir[], gCycCtx[];
double gRsiOpA[],gRsiCtxA[];
double gWprOpA[],gWprCtxA[];
double gMa9A[];
MqlRates gRatesOp[], gRatesDir[], gRatesCtx[];

datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;
int  gIndBars=60;               // quante barre di RSI/WPR/MA servono
//--- i TF superiori si ricalcolano SOLO quando chiude una loro barra: prima
//    di allora i valori a indice 1 non cambiano (e il ciclo costa caro).
datetime gLastBarUp=0, gLastBarRsi=0, gLastBarCiclo=0;

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

//--- macchina a stati (una per direzione)
#define FASE_ATTESA   0
#define FASE_ROTTURA  1
#define FASE_RITEST   2

struct SetupState
  {
   int      fase;        // FASE_*
   double   viola;       // LINEA VIOLA = livello Supertrend rotto
   double   estremo;     // estremo della fase di inversione (max/min di ciclo)
   int      bars;        // barre operative trascorse nella sequenza (timeout)
  };
SetupState gSell, gBuy;

//--- v2: UNA punta di RSI per ciclo.
//    'rsi'   = estremo dell'RSI dentro il ciclo (max se ciclo positivo, min se negativo);
//    'price' = estremo di PREZZO dentro lo STESSO ciclo (il manuale: il max/min di ciclo
//              e' quello del PREZZO, non la punta dell'indicatore) -> i due estremi
//              possono cadere su barre diverse e vengono seguiti separatamente;
//    'chiusa'= true quando il ciclo ha cambiato segno: punta CONSOLIDATA. Finche' e'
//              false la punta e' PROVVISORIA (ciclo in corso) e puo' ancora peggiorare/
//              migliorare: si usa lo stesso, perche' la RIPARTENZA arriva quasi sempre
//              a ciclo non chiuso, ma la differenza viene marcata e loggata.
struct RsiPunta
  {
   datetime bar;      // barra su cui e' stato toccato l'estremo di RSI
   double   rsi;      // valore dell'RSI alla punta
   double   price;    // estremo di prezzo del ciclo (high se ciclo +, low se ciclo -)
   int      segno;    // +1 ciclo positivo (punta di MASSIMO) / -1 negativo (punta di MINIMO)
   bool     chiusa;   // true = ciclo chiuso -> punta consolidata
  };

//--- buffer circolare delle ultime PUNTE_MAX punte di un TF
struct PunteTracker
  {
   RsiPunta p[PUNTE_MAX];
   int      head;      // indice della punta piu' recente
   int      count;     // quante punte valide
   datetime lastBar;   // ultima barra CHIUSA gia' contabilizzata (continuita' incrementale)
   int      segnoCorr; // segno del ciclo in corso
   bool     init;
  };
PunteTracker gPunteOp, gPunteCtx;   // TF operativo (ingresso) e TF dell'RSI di contesto

void Log(string m){ if(InpVerbose) Print("[ALTAV] ", m); }

void ResetSetup(SetupState &s)
  {
   s.fase=FASE_ATTESA; s.viola=0.0; s.estremo=0.0; s.bars=0;
  }

//==================================================================
//  INIT / DEINIT
//==================================================================
int TfIndex(ENUM_TIMEFRAMES tf)
  {
   for(int i=0;i<8;i++) if(gScale[i]==tf) return(i);
   return(-1);
  }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   int idx=TfIndex(InpCicloTF);
   if(idx<0)
     { Print("ERRORE: il ciclo direzionale deve stare sulla scala M1/M5/M15/H1/H4/D1/W1/MN1."); return(INIT_FAILED); }
   if(idx-3<0)
     { Print("ERRORE: ciclo troppo basso: servono 3 gradini sotto (minimo H1 -> M1)."); return(INIT_FAILED); }

   gTfCiclo = InpCicloTF;
   gTfOp    = gScale[idx-3];   // ingresso
   gTfUp    = gScale[idx-2];   // gestione: un gradino sopra l'operativo
   gTfWpr   = gScale[idx-2];   // Williams di contesto: idem
   gTfRsi   = gScale[idx-1];   // RSI di contesto: due gradini sopra l'operativo

   hAtrStOp = iATR(_Symbol,gTfOp,   InpStAtrPeriod);
   hAtrStUp = iATR(_Symbol,gTfUp,   InpStAtrPeriod);
   hAtrTgt  = iATR(_Symbol,gTfCiclo,InpAtrPeriod);
   hWprOp   = iWPR(_Symbol,gTfOp,   InpWprPeriod);
   hWprCtx  = iWPR(_Symbol,gTfWpr,  InpWprPeriod);
   hRsiOp   = iRSI(_Symbol,gTfOp,   InpRsiPeriod,PRICE_CLOSE);
   hRsiCtx  = iRSI(_Symbol,gTfRsi,  InpRsiPeriod,PRICE_CLOSE);
   hMa9     = iMA (_Symbol,gTfOp,   MA9_PERIOD,0,MODE_SMA,PRICE_CLOSE);

   if(hAtrStOp==INVALID_HANDLE||hAtrStUp==INVALID_HANDLE||hAtrTgt==INVALID_HANDLE||
      hWprOp==INVALID_HANDLE||hWprCtx==INVALID_HANDLE||hRsiOp==INVALID_HANDLE||
      hRsiCtx==INVALID_HANDLE||hMa9==INVALID_HANDLE)
     { Print("ERRORE: creazione handle indicatori."); return(INIT_FAILED); }

   gIndBars = (int)MathMax(60, (double)(MathMax(InpRsiLookback, MathMax(InpWprGraceBars,InpMa9Bars))+20));

   ResetSetup(gSell); ResetSetup(gBuy);
   PunteReset(gPunteOp); PunteReset(gPunteCtx);

   if(_Period!=gTfOp)
      Log(StringFormat("ATTENZIONE: il grafico e' %s ma il TF operativo derivato e' %s. "
                       "Funziona lo stesso (handle espliciti), ma il tester conta le barre del grafico.",
                       EnumToString((ENUM_TIMEFRAMES)_Period),EnumToString(gTfOp)));

   if(InpUseNewsFilter) LoadNews();

   Log(StringFormat("avviato su %s. Ciclo %s | operativo %s | Williams ctx %s | RSI ctx %s | gestione %s. "
                    "Supertrend(%d,%.2f) IPOTESI, ATR target %d IPOTESI.",
                    _Symbol,EnumToString(gTfCiclo),EnumToString(gTfOp),EnumToString(gTfWpr),
                    EnumToString(gTfRsi),EnumToString(gTfUp),InpStAtrPeriod,InpStMult,InpAtrPeriod));
   if(InpUseRsiPunte)
      Log(StringFormat("RSI: motore PUNTE per ciclo ATTIVO (v2). Divergenza obbligatoria: %s. "
                       "Tolleranza doppio massimo/minimo: %.2f punti RSI.",
                       (InpRequireDivergence==1?"SI":"no (conv. o div.)"),InpRsiFlatTol));
   else
      Log(StringFormat("RSI: motore PUNTE DISATTIVATO -> fallback v1.1 a lookback %d barre.",InpRsiLookback));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[8]={hAtrStOp,hAtrStUp,hAtrTgt,hWprOp,hWprCtx,hRsiOp,hRsiCtx,hMa9};
   for(int i=0;i<8;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del giorno.
   //    Sta QUI e non dopo il filtro della nuova barra: la caduta peggiore di
   //    giornata succede in mezzo alla candela.
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

   //--- TUTTA la logica gira su barra chiusa del TF operativo (niente ripaint)
   datetime t=iTime(_Symbol,gTfOp,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   //--- se i dati non sono pronti si esce: si riprova alla barra dopo
   if(!RefreshData()) { Log("dati non pronti: riprovo alla prossima barra."); return; }

   ManagePosition();      // 1) flip, 4) MA9, 2) stop a zero, 3) trailing
   UpdateSetups();        // macchina a stati + eventuale ingresso
  }

//==================================================================
//  DATI: tutte le serie usate dalla logica, ricalcolate a ogni barra
//==================================================================
bool RefreshData()
  {
   //--- sempre: tutto quello che vive sul TF OPERATIVO
   if(!SupertrendSeries(gTfOp,hAtrStOp,gStOp,gDirOp)) return(false);
   if(!CycleSeries(gTfOp,3,gCycOp))                   return(false);
   if(!CopyInd(hRsiOp,gIndBars,gRsiOpA))              return(false);
   if(!CopyInd(hWprOp,gIndBars,gWprOpA))              return(false);
   if(!CopyInd(hMa9,  gIndBars,gMa9A))                return(false);
   ArraySetAsSeries(gRatesOp,true);
   if(CopyRates(_Symbol,gTfOp,0,gIndBars,gRatesOp)<gIndBars) return(false);

   //--- v2: la punta dell'RSI del ciclo OPERATIVO, aggiornata con la sola
   //    barra appena chiusa (tutte le serie qui sopra sono gia' verificate).
   if(InpUseRsiPunte)
      PunteUpdateTF(gPunteOp,gTfOp,hRsiOp,gCycOp,gRsiOpA,gRatesOp);

   //--- TF SUPERIORE (gestione) e Williams di CONTESTO: per costruzione sono
   //    lo stesso timeframe (operativo + 1), quindi un solo timbro di barra.
   datetime tUp=iTime(_Symbol,gTfUp,0);
   if(tUp<=0) return(false);
   if(tUp!=gLastBarUp || ArraySize(gStUp)<3 || ArraySize(gWprCtxA)<3)
     {
      if(!SupertrendSeries(gTfUp,hAtrStUp,gStUp,gDirUp)) return(false);
      if(!CopyInd(hWprCtx,gIndBars,gWprCtxA))            return(false);
      gLastBarUp=tUp;
     }

   //--- RSI di CONTESTO (operativo + 2)
   datetime tRs=iTime(_Symbol,gTfRsi,0);
   if(tRs<=0) return(false);
   if(tRs!=gLastBarRsi || ArraySize(gRsiCtxA)<3)
     {
      if(!CopyInd(hRsiCtx,gIndBars,gRsiCtxA)) return(false);
      //--- v2: le punte del contesto vogliono il CICLO del LORO timeframe.
      //    Costa poco: si calcola una sola volta per barra del TF di contesto
      //    e solo se il motore delle punte e' acceso (col fallback v1.1 non
      //    viene nemmeno chiamato, cosi' l'A/B confronta solo la logica).
      if(InpUseRsiPunte)
        {
         if(CycleSeries(gTfRsi,3,gCycCtx))
           {
            ArraySetAsSeries(gRatesCtx,true);
            if(CopyRates(_Symbol,gTfRsi,0,8,gRatesCtx)>=4)
               PunteUpdateTF(gPunteCtx,gTfRsi,hRsiCtx,gCycCtx,gRsiCtxA,gRatesCtx);
           }
        }
      gLastBarRsi=tRs;
     }

   //--- CICLO DIREZIONALE (il calcolo piu' pesante: una volta per sua barra)
   datetime tCi=iTime(_Symbol,gTfCiclo,0);
   if(tCi<=0) return(false);
   if(tCi!=gLastBarCiclo || ArraySize(gCycDir)<3)
     {
      if(!CycleSeries(gTfCiclo,CYC_NEED,gCycDir)) return(false);
      ArraySetAsSeries(gRatesDir,true);
      if(CopyRates(_Symbol,gTfCiclo,0,CYC_NEED,gRatesDir)<CYC_NEED) return(false);
      gLastBarCiclo=tCi;
     }

   return(true);
  }

//--- copia un buffer indicatore in un array SERIE (indice 0 = barra in corso)
bool CopyInd(int handle,int count,double &dst[])
  {
   ArraySetAsSeries(dst,true);
   if(CopyBuffer(handle,0,0,count,dst)<count) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| Supertrend classico: hl2 +/- mult*ATR con bande che si stringono. |
//| Serie in uscita: indice 0 = barra in corso, si legge da 1 in su.  |
//+------------------------------------------------------------------+
bool SupertrendSeries(ENUM_TIMEFRAMES tf,int atrHandle,double &lineOut[],double &dirOut[])
  {
   double atr[]; ArraySetAsSeries(atr,true);
   int gotA=CopyBuffer(atrHandle,0,0,ST_BARS,atr);
   if(gotA<ST_MIN) return(false);

   MqlRates r[]; ArraySetAsSeries(r,true);
   int gotR=CopyRates(_Symbol,tf,0,gotA,r);
   if(gotR<gotA) return(false);          // disallineati: si riprova alla barra dopo

   ArrayResize(lineOut,gotA); ArrayResize(dirOut,gotA);
   ArraySetAsSeries(lineOut,true); ArraySetAsSeries(dirOut,true);

   double finalUpper=0, finalLower=0; int dir=+1;
   for(int i=gotA-2;i>=0;i--)          // dalla piu' vecchia utile alla piu' recente
     {
      double hl2=(r[i].high+r[i].low)/2.0;
      double bUp=hl2+InpStMult*atr[i], bLo=hl2-InpStMult*atr[i];
      double prevFU=(finalUpper==0.0)?bUp:finalUpper;
      double prevFL=(finalLower==0.0)?bLo:finalLower;
      double pc=r[i+1].close;
      double fU=(bUp<prevFU||pc>prevFU)?bUp:prevFU;
      double fL=(bLo>prevFL||pc<prevFL)?bLo:prevFL;
      if(r[i].close > (dir==-1?prevFU:fU))      dir=+1;
      else if(r[i].close < (dir==+1?prevFL:fL)) dir=-1;
      finalUpper=fU; finalLower=fL;
      dirOut[i]=(double)dir;
      lineOut[i]=(dir>0)?fL:fU;
     }
   dirOut[gotA-1]=dirOut[gotA-2];
   lineOut[gotA-1]=lineOut[gotA-2];
   return(true);
  }

//+------------------------------------------------------------------+
//| CICLO: traduzione 1:1 di alta_velocita_ciclo.pine                 |
//|   K1=SMA(St(5),3) K2=SMA(St(14),3) K3=SMA(St(45),14)              |
//|   K4=SMA(St(75),20)                                               |
//|   I=(4.1*K1+2.5*K2+K3+4*K4)/11.6 ; CICLO = I - SMA(I,9)           |
//| St(n) = (close-lowest(low,n))/(highest(high,n)-lowest(low,n))*100 |
//| Divisione per zero protetta: range nullo -> 50 (neutro).          |
//|                                                                   |
//| 'need' = quante barre RECENTI di CICLO servono (indici 0..need).   |
//| Si calcolano SOLO quelle: sul TF operativo serve il solo indice 1, |
//| calcolare 600 barre a ogni candela costerebbe ore di tester.       |
//+------------------------------------------------------------------+
bool CycleSeries(ENUM_TIMEFRAMES tf,int need,double &cycOut[])
  {
   if(need<2) need=2;
   int mRaw  = need+32;      // margine per la SMA(20) piu' la SMA(9) finale
   int nBars = mRaw+80;      // + la finestra stocastica piu' lunga (75)

   MqlRates r[]; ArraySetAsSeries(r,true);
   int n=CopyRates(_Symbol,tf,0,nBars,r);
   if(n<nBars) return(false);           // storia insufficiente: riprova dopo

   int    kLen[4]={5,14,45,75};
   int    kSmo[4]={3,3,14,20};
   double w[4]   ={4.1,2.5,1.0,4.0};

   double comp[]; ArrayResize(comp,mRaw); ArraySetAsSeries(comp,true);
   double raw[];  ArrayResize(raw,mRaw);  ArraySetAsSeries(raw,true);
   double sm[];   ArrayResize(sm,mRaw);   ArraySetAsSeries(sm,true);
   for(int i=0;i<mRaw;i++) comp[i]=0.0;

   for(int k=0;k<4;k++)
     {
      int L=kLen[k], S=kSmo[k];
      //--- stocastico grezzo (indice 0 = barra in corso, j va indietro nel tempo)
      for(int i=0;i<mRaw;i++)
        {
         int len=(int)MathMin(L,n-i);
         double hi=r[i].high, lo=r[i].low;
         for(int j=i;j<i+len;j++)
           { if(r[j].high>hi) hi=r[j].high; if(r[j].low<lo) lo=r[j].low; }
         double rng=hi-lo;
         raw[i]=(rng>0.0)?((r[i].close-lo)/rng*100.0):50.0;   // protezione /0
        }
      //--- lisciatura SMA(S). Gli ultimi S-1 indici escono dalla finestra
      //    calcolata: restano dentro il margine e non vengono mai letti.
      for(int i=0;i<mRaw;i++)
        {
         int len=(int)MathMin(S,mRaw-i);
         double s=0.0;
         for(int j=i;j<i+len;j++) s+=raw[j];
         sm[i]=s/len;
        }
      for(int i=0;i<mRaw;i++) comp[i]+=w[k]*sm[i];
     }
   for(int i=0;i<mRaw;i++) comp[i]/=11.6;

   //--- CICLO = I - SMA(I,9)
   ArrayResize(cycOut,need+1); ArraySetAsSeries(cycOut,true);
   for(int i=0;i<=need;i++)
     {
      int len=(int)MathMin(9,mRaw-i);
      double s=0.0;
      for(int j=i;j<i+len;j++) s+=comp[j];
      cycOut[i]=comp[i]-s/len;
     }
   return(true);
  }

//==================================================================
//  v2 - MOTORE DELLE PUNTE DELL'RSI (una punta per ciclo)
//==================================================================
//  Il manuale non guarda l'RSI barra per barra: guarda le sue PUNTE,
//  UNA PER CICLO ("mai saltarne uno"), e traccia la trendline su quelle.
//  Qui il ciclo e' quello dell'oscillatore CICLO del TF in esame: cambia
//  segno = ciclo chiuso = la punta appena maturata si CONSOLIDA.
//  Costruzione INCREMENTALE: a ogni barra chiusa si aggiorna solo la punta
//  del ciclo in corso; la storia si ricostruisce una volta sola (avvio o
//  buco nella continuita' delle barre), MAI a ogni tick.
//==================================================================
void PunteReset(PunteTracker &t)
  {
   t.head=-1; t.count=0; t.lastBar=0; t.segnoCorr=0; t.init=false;
   for(int i=0;i<PUNTE_MAX;i++) PuntaZero(t.p[i]);
  }

void PuntaZero(RsiPunta &p)
  {
   p.bar=0; p.rsi=0.0; p.price=0.0; p.segno=0; p.chiusa=false;
  }

//--- k=0 -> punta piu' recente (PROVVISORIA se il ciclo e' ancora aperto)
int PuntaIdx(const PunteTracker &t,int k)
  {
   if(k<0 || k>=t.count) return(-1);
   int i=t.head-k;
   while(i<0) i+=PUNTE_MAX;
   return(i%PUNTE_MAX);
  }

//+------------------------------------------------------------------+
//| Una barra CHIUSA in pasto al tracker.                             |
//|  - segno diverso da quello in corso -> il ciclo precedente si e'   |
//|    chiuso: la sua punta diventa consolidata e ne nasce una nuova   |
//|    (provvisoria) sulla barra corrente;                             |
//|  - stesso segno -> si aggiorna la punta provvisoria: l'estremo di   |
//|    RSI e, separatamente, l'estremo di PREZZO del ciclo.            |
//+------------------------------------------------------------------+
void PunteFeed(PunteTracker &t,datetime bt,double cyc,double rsi,double hi,double lo)
  {
   int sgn=(cyc>=0.0)?+1:-1;      // cyc==0 conta come positivo (come CycleSegStart)

   if(!t.init || sgn!=t.segnoCorr)
     {
      if(t.count>0)
        { int ip=PuntaIdx(t,0); if(ip>=0) t.p[ip].chiusa=true; }
      t.head=(t.head+1)%PUNTE_MAX;
      if(t.head<0) t.head=0;
      if(t.count<PUNTE_MAX) t.count++;
      t.p[t.head].bar   = bt;
      t.p[t.head].rsi   = rsi;
      t.p[t.head].price = (sgn>0)?hi:lo;
      t.p[t.head].segno = sgn;
      t.p[t.head].chiusa= false;
      t.segnoCorr=sgn;
      t.init=true;
     }
   else
     {
      int i=PuntaIdx(t,0);
      if(i>=0)
        {
         if(sgn>0)
           {
            if(rsi>t.p[i].rsi){ t.p[i].rsi=rsi; t.p[i].bar=bt; }
            if(hi >t.p[i].price) t.p[i].price=hi;
           }
         else
           {
            if(rsi<t.p[i].rsi){ t.p[i].rsi=rsi; t.p[i].bar=bt; }
            if(lo <t.p[i].price) t.p[i].price=lo;
           }
        }
     }
   t.lastBar=bt;
  }

//+------------------------------------------------------------------+
//| Ricostruzione UNA TANTUM su 'bars' barre di storia del TF.        |
//| Serve solo all'avvio (o dopo un buco): senza, il warm-up sarebbe  |
//| di decine di cicli. Ritorna false se la storia non basta ancora:  |
//| in quel caso si riprova alla barra dopo (niente crash, niente     |
//| segnali finche' le punte non ci sono).                            |
//+------------------------------------------------------------------+
bool PunteSeed(PunteTracker &t,ENUM_TIMEFRAMES tf,int rsiHandle,int bars)
  {
   if(bars<10) bars=10;
   double cyc[];
   if(!CycleSeries(tf,bars,cyc)) return(false);
   int n=ArraySize(cyc);                 // indici 0..bars (0 = barra in corso)
   if(n<10) return(false);

   double rsi[]; ArraySetAsSeries(rsi,true);
   if(CopyBuffer(rsiHandle,0,0,n,rsi)<n) return(false);
   MqlRates r[]; ArraySetAsSeries(r,true);
   if(CopyRates(_Symbol,tf,0,n,r)<n)     return(false);

   PunteReset(t);
   //--- si parte dalla PRIMA barra di un ciclo nuovo dentro la finestra: cosi'
   //    la punta piu' vecchia non e' il troncone di un ciclo cominciato fuori.
   int k=n-1;
   int sgn0=(cyc[k]>=0.0)?+1:-1;
   while(k>1 && (((cyc[k-1]>=0.0)?+1:-1)==sgn0)) k--;
   int start=(k>1)?(k-1):(n-1);
   for(int i=start;i>=1;i--)
      PunteFeed(t,r[i].time,cyc[i],rsi[i],r[i].high,r[i].low);
   return(t.count>0);
  }

//+------------------------------------------------------------------+
//| Aggiornamento a ogni barra chiusa del TF: UNA barra, non la storia|
//| (la storia solo se manca la continuita' con l'ultima contabiliz-  |
//| zata, cioe' all'avvio o dopo una barra saltata per dati mancanti).|
//+------------------------------------------------------------------+
void PunteUpdateTF(PunteTracker &t,ENUM_TIMEFRAMES tf,int rsiHandle,
                   const double &cyc[],const double &rsi[],const MqlRates &r[])
  {
   if(ArraySize(cyc)<3 || ArraySize(rsi)<3 || ArraySize(r)<3) return;
   datetime bt=r[1].time;
   if(bt<=0) return;
   if(t.init && t.lastBar==bt) return;                 // barra gia' contabilizzata

   if(t.init && t.lastBar==r[2].time)
     { PunteFeed(t,bt,cyc[1],rsi[1],r[1].high,r[1].low); return; }

   //--- prima volta o continuita' persa: ricostruzione (rara e non a ogni tick).
   //    Se la finestra lunga non e' disponibile si ripiega su una corta: meglio
   //    poche punte che nessuna. Se fallisce anche quella si riprova alla barra
   //    dopo, senza toccare il tracker (PunteSeed azzera solo a copie riuscite).
   if(!PunteSeed(t,tf,rsiHandle,PUNTE_SEED_BARS) &&
      !PunteSeed(t,tf,rsiHandle,PUNTE_SEED_BARS/4))
     {
      static int warn=0;
      if(warn<5){ warn++; Log("punte RSI: storia insufficiente su "+EnumToString(tf)+", riprovo alla prossima barra."); }
     }
  }

//--- le ultime DUE punte con un dato segno (recente = la piu' nuova)
bool PunteUltimeDue(const PunteTracker &t,int segno,RsiPunta &recente,RsiPunta &prec)
  {
   PuntaZero(recente); PuntaZero(prec);
   int found=0;
   for(int k=0;k<t.count;k++)
     {
      int i=PuntaIdx(t,k);
      if(i<0) break;
      if(t.p[i].segno!=segno) continue;
      if(found==0) recente=t.p[i];
      else { prec=t.p[i]; return(true); }
      found++;
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Lettura del manuale sulle ultime due punte.                       |
//|  ribassista=true  -> punte di MASSIMO (cicli positivi): valide se  |
//|                      DECRESCENTI;                                  |
//|  ribassista=false -> punte di MINIMO (cicli negativi): valide se   |
//|                      CRESCENTI.                                    |
//| Poi la classificazione rispetto al PREZZO:                        |
//|   massimi di prezzo crescenti + massimi RSI decrescenti = DIVERG.; |
//|   massimi di prezzo decrescenti + RSI decrescenti      = CONVERG.; |
//|   punte quasi uguali (entro InpRsiFlatTol)             = DOPPIO    |
//|   MASSIMO -> si aspetta (mai valido).                             |
//| 'provvisoria' esce true se la punta piu' recente appartiene a un   |
//| ciclo ancora APERTO (caso normale alla ripartenza).                |
//+------------------------------------------------------------------+
int RsiPunteStato(const PunteTracker &t,bool ribassista,bool &provvisoria)
  {
   provvisoria=false;
   if(t.count<2) return(RSIP_NONE);                 // warm-up: nessun giudizio
   int segno = ribassista ? +1 : -1;   // sell -> punte di MASSIMO (cicli positivi)
   RsiPunta a,b;
   PuntaZero(a); PuntaZero(b);
   if(!PunteUltimeDue(t,segno,a,b)) return(RSIP_NONE);
   provvisoria=(!a.chiusa);

   double d=a.rsi-b.rsi;
   if(MathAbs(d)<=InpRsiFlatTol) return(RSIP_FLAT); // doppio massimo / doppio minimo

   if(ribassista)
     {
      if(d>0.0) return(RSIP_NONE);                  // punte crescenti: non e' ribassista
      return( (a.price>b.price) ? RSIP_DIV : RSIP_CONV );
     }
   if(d<0.0) return(RSIP_NONE);                     // punte decrescenti: non e' rialzista
   return( (a.price<b.price) ? RSIP_DIV : RSIP_CONV );
  }

string RsiPunteNome(int st)
  {
   if(st==RSIP_DIV)  return("DIVERGENZA");
   if(st==RSIP_CONV) return("convergenza");
   if(st==RSIP_FLAT) return("doppio massimo/minimo");
   return("nessuna");
  }

//+------------------------------------------------------------------+
//| Inizio del segmento di segno costante del ciclo che contiene idx  |
//| (ritorna l'indice piu' VECCHIO del segmento, cioe' quanto e' "vec-|
//| chio" il ciclo in corso in barre).                                |
//+------------------------------------------------------------------+
int CycleSegStart(const double &cyc[],int idx)
  {
   int n=ArraySize(cyc);
   if(idx>=n) return(idx);
   bool pos=(cyc[idx]>=0.0);
   int k=idx;
   while(k+1<n && k<idx+CYC_MAXSEG && ((cyc[k+1]>=0.0)==pos)) k++;
   return(k);
  }

//+------------------------------------------------------------------+
//| Estremo di ciclo sul CICLO DIREZIONALE: massimo (per il sell) o   |
//| minimo (per il buy) di PREZZO del ciclo in corso. Se il ciclo ha  |
//| gia' cambiato segno si include anche il segmento precedente:      |
//| l'estremo che conta e' quello della gamba appena terminata.       |
//+------------------------------------------------------------------+
bool EstremoDiCiclo(bool wantMax,double &estremo)
  {
   int n=ArraySize(gCycDir);
   int nr=ArraySize(gRatesDir);
   if(n<10 || nr<10) return(false);

   bool cicloPos=(gCycDir[1]>=0.0);
   int  fine=CycleSegStart(gCycDir,1);
   //--- per un SELL serve il massimo della gamba RIALZISTA (ciclo positivo):
   //    se il ciclo e' gia' negativo, si risale al segmento positivo prima.
   if(wantMax && !cicloPos) fine=CycleSegStart(gCycDir,(int)MathMin(fine+1,n-1));
   if(!wantMax && cicloPos) fine=CycleSegStart(gCycDir,(int)MathMin(fine+1,n-1));

   int maxIdx=(int)MathMin(fine,nr-1);
   if(maxIdx<1) maxIdx=1;

   double e=wantMax?gRatesDir[1].high:gRatesDir[1].low;
   for(int i=1;i<=maxIdx;i++)
     {
      if(wantMax){ if(gRatesDir[i].high>e) e=gRatesDir[i].high; }
      else       { if(gRatesDir[i].low <e) e=gRatesDir[i].low;  }
     }
   estremo=e;
   return(true);
  }

//--- da quante barre del ciclo direzionale il CICLO ha il segno corrente
int CicloEtaBarre()
  {
   if(ArraySize(gCycDir)<10) return(9999);
   return(CycleSegStart(gCycDir,1));
  }

//==================================================================
//  CONDIZIONI ELEMENTARI
//==================================================================
//--- FALLBACK v1.1: il surrogato a lookback (usato solo con InpUseRsiPunte=false
//    e, per scelta, ancora dall'uscita anticipata della gestione).
bool RsiGiu(const double &r[])
  {
   if(ArraySize(r)<InpRsiLookback+2) return(false);
   return(r[1] < r[1+InpRsiLookback]);
  }
bool RsiSu(const double &r[])
  {
   if(ArraySize(r)<InpRsiLookback+2) return(false);
   return(r[1] > r[1+InpRsiLookback]);
  }

//--- v2: "RSI nella direzione" = ultime due punte di ciclo nella direzione,
//    convergenti o divergenti (il doppio massimo/minimo non conta mai).
//    Usato da ROTTURA, da RITEST (a direzione invertita) e dall'RSI di contesto.
bool RsiDirOk(const PunteTracker &t,const double &fb[],bool ribassista)
  {
   if(!InpUseRsiPunte) return(ribassista ? RsiGiu(fb) : RsiSu(fb));
   bool prov=false;
   int st=RsiPunteStato(t,ribassista,prov);
   return(st>=RSIP_CONV);
  }

//--- v2: alla RIPARTENZA si applica la classificazione del manuale.
//    InpRequireDivergence=1 -> solo DIVERGENZA (il caso migliore);
//    InpRequireDivergence=0 -> divergenza O convergenza;
//    doppio massimo/minimo -> mai valido, si aspetta.
bool RsiRipartenzaOk(const PunteTracker &t,const double &fb[],bool ribassista,string tag)
  {
   if(!InpUseRsiPunte) return(ribassista ? RsiGiu(fb) : RsiSu(fb));
   bool prov=false;
   int st=RsiPunteStato(t,ribassista,prov);
   if(st==RSIP_NONE) return(false);
   if(st==RSIP_FLAT)
     { Log(tag+": RIPARTENZA rimandata, doppio massimo/minimo dell'RSI (si aspetta)."); return(false); }
   if(InpRequireDivergence==1 && st!=RSIP_DIV)
     { Log(tag+": RIPARTENZA scartata, richiesta la DIVERGENZA ma le punte sono in convergenza."); return(false); }
   Log(StringFormat("%s: punte RSI ok (%s, punta piu' recente %s).",
       tag,RsiPunteNome(st),(prov?"PROVVISORIA - ciclo aperto":"consolidata")));
   return(true);
  }

//--- flip del Supertrend sulla barra chiusa 1
bool FlipRosso(const double &dir[]){ return(ArraySize(dir)>2 && dir[1]<0 && dir[2]>0); }
bool FlipVerde(const double &dir[]){ return(ArraySize(dir)>2 && dir[1]>0 && dir[2]<0); }

//--- Williams di contesto in zona estrema, o uscito da meno di N barre
bool WprCtxEstremo(bool isSell)
  {
   int lim=1+InpWprGraceBars;
   if(ArraySize(gWprCtxA)<lim+1) return(false);
   for(int i=1;i<=lim;i++)
     {
      if(isSell){ if(gWprCtxA[i] > InpWprOB) return(true); }
      else      { if(gWprCtxA[i] < InpWprOS) return(true); }
     }
   return(false);
  }

//--- filtro direzionale: il Supertrend del TF SUPERIORE ha gia' attraversato
//    la linea viola nella direzione del trade. Due forme accettate:
//    (a) il TF superiore ha gia' girato (dir concorde) = attraversamento pieno;
//    (b) e' ancora contro ma la sua linea e' scivolata oltre la viola.
//    NB: interpretazione meccanica di una regola grafica del manuale.
bool DirFilterOk(bool isSell,double viola)
  {
   if(!InpUseDirFilter) return(true);
   if(ArraySize(gDirUp)<3 || ArraySize(gStUp)<3 || viola<=0.0) return(true);
   if(isSell) return(gDirUp[1]<0 || gStUp[1]<viola);
   return(gDirUp[1]>0 || gStUp[1]>viola);
  }

//==================================================================
//  MACCHINA A STATI
//==================================================================
//--- le due macchine avanzano SEMPRE (anche a posizione aperta: cosi' al
//    momento in cui il conto e' libero lo stato e' gia' quello giusto);
//    l'ingresso vero e' filtrato dentro TryEnter.
void UpdateSetups()
  {
   UpdateOneSetup(gSell,true);
   UpdateOneSetup(gBuy,false);
  }

void UpdateOneSetup(SetupState &s,bool isSell)
  {
   string tag=(isSell?"SELL":"BUY");

   //--- timeout: se la sequenza non si chiude, si azzera
   if(s.fase!=FASE_ATTESA)
     {
      s.bars++;
      if(s.bars>InpFaseTimeoutBars)
        { Log(tag+": timeout di fase, reset."); ResetSetup(s); }
     }

   //--- 1) ATTESA -> ROTTURA
   if(s.fase==FASE_ATTESA)
     {
      bool flip = isSell ? FlipRosso(gDirOp) : FlipVerde(gDirOp);
      //--- v2: "RSI ribassista" = due punte-massimo di ciclo decrescenti
      //    (per il buy: due punte-minimo crescenti). Nessuna classificazione
      //    qui: la divergenza si pretende, semmai, alla ripartenza.
      bool rsiOk= RsiDirOk(gPunteOp,gRsiOpA,isSell);
      if(flip && rsiOk)
        {
         double est=0.0;
         if(!EstremoDiCiclo(isSell,est)) return;
         s.fase   = FASE_ROTTURA;
         s.viola  = gStOp[2];        // il livello rotto: il Supertrend PRIMA del flip
         s.estremo= est;
         s.bars   = 0;
         Log(StringFormat("%s ROTTURA: linea viola %s, estremo di ciclo %s.",
             tag,DoubleToString(s.viola,_Digits),DoubleToString(s.estremo,_Digits)));
        }
      return;
     }

   //--- l'estremo della fase di inversione si aggiorna: se il ritest fa un
   //    nuovo massimo/minimo, lo stop va li' (e cosi' anche il target).
   if(isSell){ if(gRatesOp[1].high>s.estremo) s.estremo=gRatesOp[1].high; }
   else      { if(gRatesOp[1].low <s.estremo) s.estremo=gRatesOp[1].low;  }

   //--- 3) CONTROLLO: nuovo Supertrend contrario nato durante il ritest.
   //    Il nuovo supporto (sell) deve stare SOTTO/uguale alla linea viola.
   bool flipContro = isSell ? FlipVerde(gDirOp) : FlipRosso(gDirOp);
   if(flipContro)
     {
      double liv=gStOp[1];
      bool ok = isSell ? (liv<=s.viola) : (liv>=s.viola);
      if(!ok)
        {
         Log(StringFormat("%s CONTROLLO fallito: nuovo livello %s oltre la viola %s -> reset.",
             tag,DoubleToString(liv,_Digits),DoubleToString(s.viola,_Digits)));
         ResetSetup(s);
         return;
        }
      if(s.fase==FASE_ROTTURA){ s.fase=FASE_RITEST; Log(tag+": RITEST (Supertrend contrario dentro la viola)."); }
     }

   //--- 2) ROTTURA -> RITEST: il prezzo risale (N chiusure nella direzione
   //    del ritest) oppure l'RSI operativo gira dalla parte del ritest.
   if(s.fase==FASE_ROTTURA)
     {
      int cnt=0;
      for(int i=1;i<=InpRitestBars;i++)
        {
         if(ArraySize(gRatesOp)<i+2) break;
         if(isSell){ if(gRatesOp[i].close>gRatesOp[i+1].close) cnt++; else break; }
         else      { if(gRatesOp[i].close<gRatesOp[i+1].close) cnt++; else break; }
        }
      //--- v2: nel RITEST l'RSI deve girare dalla parte CONTRARIA al trade:
      //    per un sell servono due punte-MINIMO di ciclo CRESCENTI.
      bool rsiRitest = RsiDirOk(gPunteOp,gRsiOpA,!isSell);
      if(cnt>=InpRitestBars || rsiRitest)
        { s.fase=FASE_RITEST; Log(tag+": RITEST in corso."); }
      return;
     }

   //--- 4) RITEST -> RIPARTENZA = SEGNALE
   if(s.fase==FASE_RITEST)
     {
      bool stOk  = isSell ? (gDirOp[1]<0 && gRatesOp[1].close<gStOp[1])
                          : (gDirOp[1]>0 && gRatesOp[1].close>gStOp[1]);
      bool cycOk = isSell ? (gCycOp[1]<0.0) : (gCycOp[1]>0.0);
      //--- l'RSI si valuta per ULTIMO: cosi' il log della classificazione
      //    (divergenza / convergenza / doppio massimo) esce solo quando
      //    Supertrend e ciclo sono gia' d'accordo, non a ogni barra.
      if(!(stOk && cycOk)) return;
      if(!RsiRipartenzaOk(gPunteOp,gRsiOpA,isSell,tag)) return;

      //--- filtri di contesto
      if(!WprCtxEstremo(isSell))
        { return; }
      //--- Williams operativo ancora nella prima meta' (oltre -50 il segnale
      //    e' gia' scaduto: e' la "benzina" che manca)
      if(isSell){ if(gWprOpA[1] <= InpWprMid) return; }
      else      { if(gWprOpA[1] >= InpWprMid) return; }
      //--- RSI di contesto (2 gradini sopra l'ingresso) gia' nella direzione:
      //    v2 lo legge con le punte del CICLO DEL SUO timeframe. Qui basta la
      //    direzione (conv. o div.): la divergenza si pretende, se richiesta,
      //    solo sul grafico d'ingresso.
      if(!RsiDirOk(gPunteCtx,gRsiCtxA,isSell)) return;
      //--- non arrivare in ritardo sul ciclo direzionale
      bool cycDirNeg=(gCycDir[1]<0.0);
      int  eta=CicloEtaBarre();
      if(isSell==cycDirNeg && eta>InpMaxCicloAgeBars)
        {
         Log(StringFormat("%s scartato: ciclo direzionale girato da %d barre (si arriva tardi) -> reset.",tag,eta));
         ResetSetup(s);
         return;
        }
      //--- filtro direzionale (controtendenza = si salta)
      if(!DirFilterOk(isSell,s.viola))
        { Log(tag+": segnale controtendenza (filtro direzionale) -> saltato."); return; }

      //--- SEGNALE valido: si prova a entrare
      if(TryEnter(isSell,s.estremo)) ResetSetup(s);
     }
  }

//==================================================================
//  INGRESSO
//==================================================================
//| Ritorna true se il SEGNALE e' stato consumato (eseguito o scartato  |
//| nel merito): il chiamante azzera la sequenza. Ritorna false solo    |
//| per i blocchi esterni (posizione aperta, spread, news, limite       |
//| giornaliero, dati mancanti): li' il setup resta valido e riprova.   |
bool TryEnter(bool isSell,double estremo)
  {
   string tag=(isSell?"SELL":"BUY");
   if(HasPosition())  return(false);
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return(false);
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) { Log("blackout notizie: nessun ingresso."); return(false); }
   if(!SpreadOK()) { Log("spread fuori limite: nessun ingresso."); return(false); }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isSell?bid:ask;

   double a[1];
   if(CopyBuffer(hAtrTgt,0,1,1,a)!=1 || a[0]<=0.0) { Log("ATR del ciclo non disponibile."); return(false); }
   double atrDir=a[0];

   //--- TARGET: 2 x ATR del ciclo direzionale DALL'estremo di ciclo
   double tp = isSell ? estremo-InpTargetATRmult*atrDir : estremo+InpTargetATRmult*atrDir;
   //--- STOP: 1 point oltre l'estremo della fase + buffer
   double buf=(1.0+(double)InpSLBufferPoints)*_Point;
   double sl = isSell ? estremo+buf : estremo-buf;

   //--- il target deve essere ancora davanti al prezzo
   if((isSell && tp>=entry) || (!isSell && tp<=entry))
     { Log(tag+": target gia' raggiunto/superato, nessun trade."); return(true); }
   if((isSell && sl<=entry) || (!isSell && sl>=entry))
     { Log(tag+": estremo dalla parte sbagliata rispetto al prezzo, nessun trade."); return(true); }

   double rischio = isSell ? (sl-entry) : (entry-sl);
   double guadagno= isSell ? (entry-tp) : (tp-entry);
   double rr = (rischio>0.0) ? guadagno/rischio : 0.0;

   //--- R/R sotto soglia: si STRINGE lo stop alla cuspide del Supertrend
   //    operativo piu' vicina (la linea attuale e' il livello piu' vicino).
   if(rr<InpMinRR)
     {
      double slCusp = isSell ? gStOp[1]+buf : gStOp[1]-buf;
      bool   usabile = isSell ? (slCusp>entry && slCusp<sl) : (slCusp<entry && slCusp>sl);
      if(usabile)
        {
         sl=slCusp;
         rischio = isSell ? (sl-entry) : (entry-sl);
         rr = (rischio>0.0) ? guadagno/rischio : 0.0;
        }
     }
   if(rr<InpMinRR)
     {
      Log(StringFormat("%s scartato: R/R %.2f < %.2f (stop %s, target %s).",
          tag,rr,InpMinRR,DoubleToString(sl,_Digits),DoubleToString(tp,_Digits)));
      return(true);   // il setup e' consumato: si riparte da ATTESA
     }

   //--- REGOLA DEL MANUALE (v1.1 — nella v1 mancava, dichiarato l'11/08):
   //    lo stop si giudica con l'ATR del TF operativo. "Se l'ATR M5 e' 5
   //    pip, uno stop di 5-6 pip e' giusto; 1,5 pip e' rumore (lo tocca
   //    lo spread); 20 pip = grafico sbagliato." Senza questo pavimento
   //    la stretta alla cuspide produce stop-rumore in serie.
   double ao[1];
   if(CopyBuffer(hAtrStOp,0,1,1,ao)!=1 || ao[0]<=0.0) { Log("ATR operativo non disponibile."); return(false); }
   double stopDist=MathAbs(entry-sl);
   if(stopDist < InpMinStopAtrOp*ao[0])
     { Log(StringFormat("%s scartato: stop-rumore %.1f pt < %.2f x ATR operativo.",tag,stopDist/_Point,InpMinStopAtrOp)); return(true); }
   if(stopDist > InpMaxStopAtrOp*ao[0])
     { Log(StringFormat("%s scartato: stop %.1f pt > %.2f x ATR operativo (grafico sbagliato).",tag,stopDist/_Point,InpMaxStopAtrOp)); return(true); }

   sl=NormalizePrice(sl); tp=NormalizePrice(tp);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(MathAbs(entry-sl)<=minDist || MathAbs(entry-tp)<=minDist)
     { Log("SL/TP troppo vicini al prezzo (STOPS_LEVEL): nessun trade."); return(true); }

   double lot=LotByRisk(MathAbs(entry-sl));
   if(lot<=0.0){ Log("lotto nullo: nessun trade."); return(true); }

   string cm=InpComment+(isSell?" S":" L");
   bool ok = isSell ? gTrade.Sell(lot,_Symbol,bid,sl,tp,cm)
                    : gTrade.Buy (lot,_Symbol,ask,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      Log(StringFormat("%s @ %s SL %s TP %s lot %.2f R/R %.2f",
          tag,DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits),lot,rr));
     }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription()+" ("+IntegerToString((int)gTrade.ResultRetcode())+")");
   return(true);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE (barra chiusa del TF operativo)
//==================================================================
void ManagePosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP =PositionGetDouble(POSITION_PRICE_OPEN);
      double sl    =PositionGetDouble(POSITION_SL);
      double tp    =PositionGetDouble(POSITION_TP);

      //--- 1) il Supertrend operativo gira CONTRO: si esce subito a mercato,
      //    in piccola perdita, senza aspettare lo stop (regola del manuale).
      if((isLong && gDirOp[1]<0) || (!isLong && gDirOp[1]>0))
        {
         if(gTrade.PositionClose(tk)) Log("uscita: Supertrend operativo girato contro.");
         continue;
        }

      //--- 4) uscita anticipata: N chiusure oltre la MA9 contro posizione
      //    + RSI operativo contro. (v1: al posto della divergenza vera.)
      //    v2 NON la tocca di proposito: si cambia una cosa alla volta, cosi'
      //    l'A/B su InpUseRsiPunte misura SOLO la lettura d'ingresso. Qui
      //    resta quindi il confronto a lookback.
      if(InpMa9Bars>0 && ArraySize(gMa9A)>InpMa9Bars+1 && ArraySize(gRatesOp)>InpMa9Bars+1)
        {
         int cnt=0;
         for(int k=1;k<=InpMa9Bars;k++)
           {
            if(isLong){ if(gRatesOp[k].close<gMa9A[k]) cnt++; else break; }
            else      { if(gRatesOp[k].close>gMa9A[k]) cnt++; else break; }
           }
         bool rsiContro = isLong ? RsiGiu(gRsiOpA) : RsiSu(gRsiOpA);
         if(cnt>=InpMa9Bars && rsiContro)
           {
            if(gTrade.PositionClose(tk)) Log("uscita anticipata: MA9 + RSI contro.");
            continue;
           }
        }

      //--- 2) STOP A ZERO: Williams operativo nella zona estrema OPPOSTA
      //    oppure il Supertrend operativo ha attraversato il prezzo d'ingresso.
      double spr=(double)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)*_Point;
      bool beDone = isLong ? (sl>0.0 && sl>=openP) : (sl>0.0 && sl<=openP);
      if(!beDone)
        {
         bool wprOpp = isLong ? (gWprOpA[1]<=InpWprOS) : (gWprOpA[1]>=InpWprOB);
         bool stCross= isLong ? (gStOp[1]>openP)       : (gStOp[1]<openP);
         if(wprOpp || stCross)
           {
            double be = NormalizePrice(isLong ? openP+spr : openP-spr);
            double px = isLong ? SymbolInfoDouble(_Symbol,SYMBOL_BID) : SymbolInfoDouble(_Symbol,SYMBOL_ASK);
            double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
            bool valido = isLong ? (be < px-minDist) : (be > px+minDist);
            if(valido && gTrade.PositionModify(tk,be,tp))
              { Log(StringFormat("stop a zero (%s).",wprOpp?"Williams in zona opposta":"Supertrend oltre l'ingresso")); sl=be; beDone=true; }
           }
        }

      //--- 3) SCALA DI GESTIONE: dopo lo stop a zero il trailing sale di un
      //    grafico e segue il Supertrend del TF SUPERIORE. Mai allargare.
      if(beDone && ArraySize(gStUp)>2)
        {
         double bufp=(double)InpSLBufferPoints*_Point;
         double cand=NormalizePrice(isLong ? gStUp[1]-bufp : gStUp[1]+bufp);
         double px  = isLong ? SymbolInfoDouble(_Symbol,SYMBOL_BID) : SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
         //--- si usano le variabili locali (sl/tp gia' aggiornate): dopo una
         //    PositionModify la selezione della posizione puo' non valere piu'.
         bool migliora = isLong ? (cand>sl && cand<px-minDist) : (cand<sl && cand>px+minDist);
         if(migliora && gTrade.PositionModify(tk,cand,tp)) sl=cand;
        }
     }
  }

//==================================================================
//  UTILITY
//==================================================================
bool HasPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (lezione 08/08/2026):
   //  su alcuni simboli il tick value arriva non convertito in valuta conto e il
   //  lotto finisce sempre al minimo. OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) - identico alla famiglia ABTG
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
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

double OnTester()
  {
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
