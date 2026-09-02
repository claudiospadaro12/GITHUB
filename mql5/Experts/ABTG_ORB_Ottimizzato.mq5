//+------------------------------------------------------------------+
//|                                      ABTG_ORB_Ottimizzato.mq5    |
//|                                                                  |
//|  LABORATORIO parallelo dell'ORB del corso (che resta INTATTO).  |
//|  Qui vivono fix e varianti misurabili; magic diverso, mai in     |
//|  sostituzione dell'originale (regola della flotta, 08/08/2026): |
//|   - fix InpOneTradePerDay (pendente opposto cancellato)          |
//|   - filtro EMA lunga opzionale (utenti ABTG: 200; scheda DAX: 50)|
//|   - SL 50%% del range (ORB_SL_HALFRANGE, utenti ABTG)             |
//|   - ampiezza minima range in %% del prezzo (scheda ORB DAX)       |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Replica la logica dell'ORB_Indicator_V15:                      |
//|   - RANGE = candela 14:25-14:30 (server) = 15:25-15:30 IT       |
//|     (i 5 minuti prima dell'apertura USA)                        |
//|   - Ingresso a EntryPoints x K oltre max/min del range:         |
//|     BUY STOP sopra, SELL STOP sotto (OCO)                       |
//|   - K = coefficiente per strumento (indici/oro=1.0, 225JPY=10,  |
//|     cross JPY=0.01, altri forex=0.0001, oil=0.01)               |
//|   - SL sull'estremo opposto (o ATR/fisso); TP a R multiplo      |
//|     (webinar: min 1:2) + parziale + breakeven                  |
//|   - Runner: trailing / uscita su EMA9 (M5), come da webinar     |
//|   - Cancella/chiude a 22:59 server; 1 trade a sessione          |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti. DEMO.   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                       |
//|  v1.03 (02/09/2026, caccia ai GEMELLI CHE DIVERGONO) - SOLO      |
//|        STRUMENTAZIONE DIAGNOSTICA: nessun input nuovo, nessun    |
//|        cambio di logica di trading, nessuna riga di decisione    |
//|        toccata. Serve a rispondere alla domanda del dossier      |
//|        report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md: perche' la   |
//|        stessa .ex5 traila lo stop sul 100k e NON lo muove mai,   |
//|        in silenzio totale, sul conto piccolo. Finora             |
//|        ManageRunner() non stampava NULLA: ne' quando muoveva lo  |
//|        stop, ne' quando usciva prima di muoverlo. Ora ogni ramo  |
//|        di uscita anticipata lascia una traccia con prefisso      |
//|        "ORB RUNNER:" / "ORB TP1:" / "ORB INIT:", stampata con    |
//|        Print() (NON con Log(), che dipende da InpVerbose: una    |
//|        diagnostica che si puo' spegnere per sbaglio non serve).  |
//|  v1.02 (19/08/2026, preparazione R88) - UN SOLO input nuovo:     |
//|        InpSLBufferPts (default 0 = comportamento IDENTICO a      |
//|        v1.01). Allontana lo stop di N punti oltre il livello     |
//|        calcolato nei modi OPPRANGE e HALFRANGE. Nasce da R55     |
//|        ("l'ORB non muore di PF, muore di drawdown - e la causa   |
//|        e' lo stop stretto") e dalla regola 5-10 punti del        |
//|        ToolKit ABTG. Vedi il blocco commentato sull'input.       |
//|  v1.01 - InpSlippagePts (R55), export per-trade, fix             |
//|        InpOneTradePerDay.                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.03"
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

enum ENUM_ORB_SL { ORB_SL_OPPRANGE=0, ORB_SL_ATR=1, ORB_SL_FIXED=2, ORB_SL_HALFRANGE=3 };
enum ENUM_ORB_TP { ORB_TP_R=0, ORB_TP_RANGE=1 };  // target in R sullo stop, oppure in multipli dell'ampiezza del range

//==================================================================
//  INPUT
//==================================================================
input group "=== Range ORB (ORARI SERVER, come l'indicatore) ==="
input int    InpRangeStartHour = 14;  // Inizio range (server). BCM: 14:25 = 15:25 IT
input int    InpRangeStartMin  = 25;
input int    InpRangeEndHour   = 14;  // Fine range (server). BCM: 14:30 = 15:30 IT
input int    InpRangeEndMin    = 30;
input int    InpEndHour        = 22;  // Fine giornata: cancella/chiude (server). Indicatore: 22:59
input int    InpEndMin         = 59;
input bool   InpCloseAtEnd     = true;
input bool   InpOneTradePerDay = true;
input int    InpPendingExpiryMin = 600;

input group "=== Ingresso (EntryPoints x K, come l'indicatore) ==="
input double InpEntryPoints = 10.0;   // Distanza ingresso oltre max/min (in unita' K)
input double InpK           = 1.0;    // Coefficiente: indici/oro=1.0; 225JPY=10; JPY=0.01; forex=0.0001; oil=0.01
input bool   InpAllowLong   = true;
input bool   InpAllowShort  = true;

input group "=== Stop, target, gestione ==="
input ENUM_ORB_SL InpSLMode = ORB_SL_OPPRANGE; // Estremo opposto range / ATR / punti fissi
input ENUM_TIMEFRAMES InpExecTF = PERIOD_M5;   // TF di esecuzione (ATR, EMA, trailing)
input int    InpAtrPeriod  = 14;
input double InpAtrSLmult   = 1.5;
input double InpSLFixedPts   = 1000;   // (FIXED) stop in punti
input double InpTP_R         = 2.0;    // Take profit in R (webinar: min 1:2)
input ENUM_ORB_TP InpTPMode  = ORB_TP_R;   // (articolo ORB filtrato) TP in R oppure in multipli del range
input double InpTPRangeMult  = 1.5;    // (TP_RANGE) target = breakout +/- ampiezza range x questo
input double InpTP1Pct       = 50;     // % chiusa al target
input bool   InpBreakeven    = true;   // Stop in pari dopo la parziale
input bool   InpUseTrailEMA  = true;   // Trailing dello stop sull'EMA veloce
input int    InpEmaFast      = 9;
input int    InpEmaSlow      = 21;
input bool   InpExitOnEmaClose = true; // Esci se una candela chiude oltre l'EMA9 opposta

//--- BUFFER SULLO STOP (19/08/2026, v1.02 - opt-in, default 0)
//  PERCHE'. R55 ha misurato che questa sedia "non muore di PF, muore di
//  DRAWDOWN": sfonda il cancello del 10% con 1,5 punti indice di
//  slippage, con una sensibilita' 11 volte quella del PTE. Il referto
//  nomina anche la causa: lo stop e' STRETTISSIMO (50% del range) e il
//  lotto si calcola come rischio/distanza_stop -> stop stretto = piu'
//  lotti = ogni punto costa di piu'. La via indicata da
//  report/ORB_100K_CRITERI.md punto D e' ALLARGARE LO STOP, non
//  abbassare ancora il peso. Il ToolKit ABTG, dal canto suo, mette lo
//  stop "5-10 punti oltre l'estremo opposto del range": lo stesso
//  buffer, scritto dal corso.
//
//  COSA FA. Nei modi OPPRANGE (estremo opposto) e HALFRANGE (50% del
//  range) allontana lo stop di N punti oltre il livello calcolato:
//  long  -> sl = livello - N*_Point
//  short -> sl = livello + N*_Point
//  Non tocca i modi ATR e FIXED, che hanno gia' la loro distanza.
//
//  UNITA'. PUNTI MT5, come InpSlippagePts e InpSLFixedPts. Su U30USD a
//  BCM 100 punti = 1 punto indice (misurato in R55): i "5-10 punti" del
//  ToolKit sono quindi 500-1000 qui dentro.
//
//  DIFFERENZA VOLUTA RISPETTO A ABTG_ORB_Fibo.mq5. La' il buffer e'
//  MathMax(InpSLBufferPts, SYMBOL_TRADE_STOPS_LEVEL): comodo, ma con
//  default 0 il comportamento NON sarebbe identico a prima su un broker
//  con stops level > 0. Qui il default 0 deve essere un no-op esatto,
//  perche' il round R88 confronta con/senza a parita' di tutto il
//  resto. Il rispetto dello stops level resta dov'era (EntryDistance).
//
//  EFFETTO ATTESO (da verificare col tester, non dichiarato come fatto):
//  meno lotti a parita' di rischio %, quindi DD piu' basso e meno
//  fragilita' allo slippage; in cambio piu' stop presi per intero.
input double InpSLBufferPts  = 0;      // Buffer extra sullo stop in PUNTI (0 = come v1.01). Solo modi OPPRANGE/HALFRANGE

input group "=== Ricetta ToolKit ABTG / live (tutto OPT-IN, default = comportamento attuale) ==="
input bool   InpUseCloseConfirm  = false;  // Entra alla CHIUSURA di una candela oltre il livello, invece che con pendenti STOP
input double InpMinBodyPct       = 50;     // (CLOSE_CONFIRM) corpo minimo della candela di rottura, in % del suo range (0=off)
input bool   InpUseEmaFilter     = false;  // Filtro direzionale: EMA veloce/lenta allineate E prezzo dalla parte giusta di ENTRAMBE
input bool   InpUseEma200Filter  = false;  // (utenti ABTG) long solo sopra la EMA lunga, short solo sotto
input int    InpEma200Period     = 200;    // periodo della EMA lunga (sul TF di esecuzione)
input double InpMinRangePct      = 0;      // (ORB DAX) ampiezza minima del range in % del prezzo (0.2 = 0,2%); 0 = off
input double InpMaxRangePct      = 0;      // (edgeful) ampiezza MASSIMA del range in % del prezzo (0.8 = 0,8%); 0 = off
input bool   InpUseVolumeFilter  = false;  // Volume della candela di rottura >= X * media
input double InpVolMult          = 1.5;    // (volumi) moltiplicatore: 1.5 = +50%, come da live
input int    InpVolAvgBars       = 20;     // (volumi) barre per la media

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;    // Rischio per trade in %

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies= "USD";
input bool   InpNewsFlatten   = true;

input group "=== Generali ==="
input string InpComment   = "ORB OTT";
input long   InpMagic     = 770611;   // magic DIVERSO dal corso (770601)
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

input group "=== Slippage stimato (R55: quanto scala questa cella) ==="
//  PERCHE' (15/08/2026, R55). Tutti i backtest del progetto girano con
//  riempimento PERFETTO. Qui l'ingresso e' un pendente STOP, cioe' il
//  caso in cui lo slippage morde di piu': la rottura e' il momento in
//  cui il book e' piu' sottile.
//
//  COME E' MODELLATO: nel tester non si puo' cambiare il prezzo a cui
//  il broker riempie, ma uno slippage di X punti equivale a chiudere X
//  punti piu' in la' nel verso sfavorevole. Quindi SL e TP si spostano
//  di X nel verso contrario al trade, DOPO il calcolo del lotto (che
//  resta sul rischio ORIGINALE, quello visto al momento di decidere).
//  Netto: -X punti su ogni trade, vincente o perdente.
//
//  LIMITE DICHIARATO: modello del primo ordine. Non simula riempimento
//  parziale ne' profondita' del book - MT5 non li modella affatto.
//
//  DEFAULT 0 = comportamento identico a prima, forward invariato.
input double InpSlippagePts = 0;   // R55: slippage stimato in PUNTI (0 = off, come sempre)


//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE, hEmaF=INVALID_HANDLE, hEmaS=INVALID_HANDLE, hEma200=INVALID_HANDLE;
enum ENUM_ORBPHASE { ORB_WAIT, ORB_ARMED, ORB_PLACED, ORB_DONE };
ENUM_ORBPHASE gPhase=ORB_WAIT;
int      gDay=-1;
double   gRangeHigh=0, gRangeLow=0;
bool     gPart1=false;
bool     gHadPos=false;
datetime gLastExec=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[ORB_OTT] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr =iATR(_Symbol,InpExecTF,InpAtrPeriod);
   //--- v1.03: la EMA veloce e' l'indicatore da cui dipende TUTTO il runner
   //    (trailing + uscita su chiusura oltre l'EMA). L'ipotesi n.2 del dossier
   //    22/08 e' proprio che su un terminale l'handle non si carichi e la
   //    funzione esca in silenzio: qui si dichiara l'esito alla nascita, cosi'
   //    la prima riga del log del terminale gia' assolve o accusa l'handle.
   ResetLastError();
   hEmaF=iMA(_Symbol,InpExecTF,InpEmaFast,0,MODE_EMA,PRICE_CLOSE);
   if(hEmaF==INVALID_HANDLE)
      PrintFormat("ORB INIT: handle EMA veloce INVALID_HANDLE (%s, TF %d, periodo %d, EMA, PRICE_CLOSE) err=%d",
                  _Symbol,(int)InpExecTF,InpEmaFast,GetLastError());
   else
      PrintFormat("ORB INIT: handle EMA veloce OK = %d (%s, TF %d, periodo %d, EMA, PRICE_CLOSE). Trailing EMA=%s, uscita su chiusura oltre EMA=%s",
                  hEmaF,_Symbol,(int)InpExecTF,InpEmaFast,
                  (InpUseTrailEMA?"ON":"OFF"),(InpExitOnEmaClose?"ON":"OFF"));
   hEmaS=iMA(_Symbol,InpExecTF,InpEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   hEma200=iMA(_Symbol,InpExecTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE||hEmaF==INVALID_HANDLE||hEmaS==INVALID_HANDLE||hEma200==INVALID_HANDLE)
     {
      //--- v1.03: dire QUALE handle e' saltato, non solo che qualcosa e' saltato
      PrintFormat("ORB INIT: ERRORE handle indicatori (ATR=%d EMAveloce=%d EMAlenta=%d EMAlunga=%d), err=%d",
                  hAtr,hEmaF,hEmaS,hEma200,GetLastError());
      return(INIT_FAILED);
     }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. Range server %02d:%02d-%02d:%02d, ingresso %.1f x K(%.4f), fine %02d:%02d.",
       _Symbol,InpRangeStartHour,InpRangeStartMin,InpRangeEndHour,InpRangeEndMin,InpEntryPoints,InpK,InpEndHour,InpEndMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr !=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
   if(hEma200!=INVALID_HANDLE) IndicatorRelease(hEma200);
  }

//+------------------------------------------------------------------+
//| Filtro EMA lunga (utenti ABTG): long solo sopra, short solo sotto|
//| Confronto sulla CHIUSURA dell'ultima candela chiusa del TF exec. |
//+------------------------------------------------------------------+
bool Ema200SideOK(int dir)
  {
   if(!InpUseEma200Filter) return(true);
   double e[1];
   if(CopyBuffer(hEma200,0,1,1,e)<1) return(true); // dati insuff.: non blocco
   double px=iClose(_Symbol,InpExecTF,1);
   if(px<=0) return(true);
   return(dir>0 ? px>e[0] : px<e[0]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageTP1();
   HandleOCO();

   // 08/08/2026 -- InpOneTradePerDay era dichiarato e MAI letto: dopo lo stop
   // il pendente opposto restava vivo (scadenza 600') e riapriva in giornata
   // ("si gira e ristoppato", visto live il 06/08). Con il flag acceso, chiuso
   // il trade del giorno si cancellano i pendenti superstiti.
   if(SelPos()) gHadPos=true;
   else if(gHadPos && InpOneTradePerDay) CancelPendings();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   bool newsBlk=InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten){ CancelPendings(); if(SelPos()) gTrade.PositionClose(_Symbol); }

   int nowMin=now.hour*60+now.min;
   if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }

   //--- gestione runner (EMA) a nuova barra M5
   datetime t=iTime(_Symbol,InpExecTF,0);
   bool newBar=(t!=gLastExec);
   if(newBar){ gLastExec=t; ManageRunner(); }

   //--- fine del range: piazzo i pendenti (classico) oppure ARMO la sorveglianza (ToolKit)
   if(gPhase==ORB_WAIT && nowMin>=InpRangeEndHour*60+InpRangeEndMin)
     {
      if(newsBlk) return;
      if(InpUseCloseConfirm)
        {
         if(ArmCloseConfirm()) gPhase=ORB_ARMED;
        }
      else
        {
         if(TryPlace()) gPhase=ORB_PLACED;
        }
     }

   //--- ToolKit: aspetto che una candela CHIUDA oltre il livello. Valuto a nuova barra.
   if(gPhase==ORB_ARMED && newBar)
     {
      if(newsBlk) return;
      if(TryCloseConfirmEntry()) gPhase=ORB_PLACED;
     }
  }

void ResetDay(){ gPhase=ORB_WAIT; gRangeHigh=0; gRangeLow=0; gPart1=false; gHadPos=false; Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Calcola max/min del range (finestra server, anche a cavallo mezzanotte)|
//+------------------------------------------------------------------+
bool ComputeRange(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpRangeEndHour;   t.min=InpRangeEndMin;   datetime tEnd=StructToTime(t);
   t.hour=InpRangeStartHour; t.min=InpRangeStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;
   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   return(hi>0 && lo>0 && hi>lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti oltre il range (EntryPoints x K)      |
//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   if(!RangeWideEnough()){ return(true); }   // giornata senza setup: range sotto la soglia %
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double entryDist=EntryDistance();
   double buyPx =NormalizePrice(gRangeHigh+entryDist);
   double sellPx=NormalizePrice(gRangeLow -entryDist);
   double atr=AtrVal();
   datetime exp=TimeCurrent()+InpPendingExpiryMin*60;

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB_Ottimizzato")) return(false);
   if(InpAllowLong && Ema200SideOK(+1))
     {
      double sl=SLforLong(buyPx,sellPx,atr);
      double dist=buyPx-sl;
      if(dist>0)
        {
         double tp=NormalizePrice(InpTPMode==ORB_TP_RANGE ? buyPx+(gRangeHigh-gRangeLow)*InpTPRangeMult
                                                          : buyPx+dist*InpTP_R);
         double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
         if(InpSlippagePts>0)          // R55: SL e TP scendono di X -> -X punti sul trade
           { double sp=InpSlippagePts*_Point; sl=NormalizePrice(sl-sp); tp=NormalizePrice(tp-sp); }
         if(lot>0 && gTrade.BuyStop(lot,buyPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" BUY"))
            Log(StringFormat("BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f",buyPx,sl,tp,lot));
        }
     }
   if(InpAllowShort && Ema200SideOK(-1))
     {
      double sl=SLforShort(sellPx,buyPx,atr);
      double dist=sl-sellPx;
      if(dist>0)
        {
         double tp=NormalizePrice(InpTPMode==ORB_TP_RANGE ? sellPx-(gRangeHigh-gRangeLow)*InpTPRangeMult
                                                          : sellPx-dist*InpTP_R);
         double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
         if(InpSlippagePts>0)          // R55: SL e TP salgono di X -> -X punti sul trade
           { double sp=InpSlippagePts*_Point; sl=NormalizePrice(sl+sp); tp=NormalizePrice(tp+sp); }
         if(lot>0 && gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" SELL"))
            Log(StringFormat("SELL STOP @ %.5f SL %.5f TP %.5f lot %.2f",sellPx,sl,tp,lot));
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ToolKit ABTG (Vol. V) + ricetta dalle live: invece di piazzare    |
//| pendenti STOP si ASPETTA che una candela CHIUDA oltre il livello. |
//|  «Non basta che il prezzo tocchi il livello: la candela deve      |
//|   chiudersi al di sopra. Questo conferma che la rottura e' reale.»|
//| Qui si calcola solo il range e si arma la sorveglianza.           |
//+------------------------------------------------------------------+
bool ArmCloseConfirm()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   if(!RangeWideEnough()){ gPhase=ORB_DONE; return(false); }   // giornata senza setup: chiusa qui
   Log(StringFormat("ARMATO (attesa chiusura confermata): range %.5f - %.5f", gRangeHigh, gRangeLow));
   return(true);
  }

//+------------------------------------------------------------------+
//| (ORB DAX) range valido solo se ampio almeno InpMinRangePct% del   |
//| prezzo: un range sotto soglia = giornata compressa, niente setup. |
//+------------------------------------------------------------------+
bool RangeWideEnough()
  {
   double px=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(px<=0) return(true);
   double rng=gRangeHigh-gRangeLow;
   if(InpMinRangePct>0 && rng < px*InpMinRangePct/100.0)
     { Log(StringFormat("range %.1f sotto la soglia %.2f%%: niente setup oggi.",rng,InpMinRangePct)); return(false); }
   if(InpMaxRangePct>0 && rng > px*InpMaxRangePct/100.0)
     { Log(StringFormat("range %.1f sopra il tetto %.2f%% (movimento gia' fatto): niente setup oggi.",rng,InpMaxRangePct)); return(false); }
   return(true);
  }

//+------------------------------------------------------------------+
//| Filtro direzionale del ToolKit: EMA veloce/lenta allineate E      |
//| prezzo dalla parte giusta di ENTRAMBE. Medie intrecciate o        |
//| prezzo in mezzo = NESSUNA operazione.                             |
//+------------------------------------------------------------------+
bool EmaSideOK(int dir)
  {
   if(!InpUseEmaFilter) return(true);
   double f[1], s[1];
   if(CopyBuffer(hEmaF,0,1,1,f)<1 || CopyBuffer(hEmaS,0,1,1,s)<1) return(true); // dati insuff.: non blocco
   double px=iClose(_Symbol,InpExecTF,1);
   if(px<=0) return(true);
   if(dir>0) return(f[0]>s[0] && px>f[0] && px>s[0]);
   if(dir<0) return(f[0]<s[0] && px<f[0] && px<s[0]);
   return(false);
  }

//+------------------------------------------------------------------+
//| Volume DELLA CANDELA DI ROTTURA >= X * media delle N precedenti   |
//|  (live: "volumi >= +50%, cioe' 1,5x la media a 20")               |
//+------------------------------------------------------------------+
bool VolumeOK()
  {
   if(!InpUseVolumeFilter) return(true);
   int n=InpVolAvgBars;
   if(n<2) return(true);
   long v[];
   ArraySetAsSeries(v,true);
   if(CopyTickVolume(_Symbol,InpExecTF,1,n+1,v)<n+1) return(true);  // dati insuff.: non blocco
   double sum=0;
   for(int i=1;i<=n;i++) sum+=(double)v[i];
   double avg=sum/n;
   if(avg<=0) return(true);
   return((double)v[0] >= InpVolMult*avg);   // v[0] = la candela appena chiusa = quella che rompe
  }

//+------------------------------------------------------------------+
//| Valuta l'ultima candela CHIUSA: ha rotto il range con un corpo    |
//| ampio, con le medie allineate e i volumi in crescita? Allora      |
//| entra A MERCATO. Altrimenti aspetta la prossima.                  |
//+------------------------------------------------------------------+
bool TryCloseConfirmEntry()
  {
   double o=iOpen (_Symbol,InpExecTF,1), c=iClose(_Symbol,InpExecTF,1);
   double h=iHigh (_Symbol,InpExecTF,1), l=iLow  (_Symbol,InpExecTF,1);
   if(o<=0 || c<=0 || h<=l) return(false);

   int dir=0;
   if(c>gRangeHigh)      dir=+1;
   else if(c<gRangeLow)  dir=-1;
   else                  return(false);          // chiusura DENTRO il range: non e' un breakout valido

   if(dir>0 && !InpAllowLong)  return(false);
   if(dir<0 && !InpAllowShort) return(false);

   //--- corpo ampio: una candela con corpo piccolo e ombra lunga che attraversa
   //    il livello e' spesso un falso breakout (ToolKit, errori comuni)
   double rng=h-l, body=MathAbs(c-o);
   if(InpMinBodyPct>0 && (rng<=0 || body < rng*InpMinBodyPct/100.0))
     { Log("rottura con corpo piccolo: ignoro (probabile falso break)."); return(false); }

   if(!EmaSideOK(dir)) { Log("medie non allineate col breakout: niente trade."); return(false); }
   if(!Ema200SideOK(dir)) { Log("prezzo dal lato sbagliato della EMA lunga: niente trade."); return(false); }
   if(!VolumeOK())     { Log("volume della rottura sotto la media: niente trade."); return(false); }
   if(!SpreadOK())     { Log("spread alto: niente trade."); return(false); }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);

   double entry=(dir>0)?ask:bid;
   double atr=AtrVal();
   double sl=(dir>0)?SLforLong(entry,gRangeLow,atr):SLforShort(entry,gRangeHigh,atr);
   double dist=(dir>0)?(entry-sl):(sl-entry);
   if(dist<=0){ Log("stop dalla parte sbagliata: niente trade."); return(false); }

   double rngH=gRangeHigh-gRangeLow;
   double tp;
   if(InpTPMode==ORB_TP_RANGE) tp=NormalizePrice((dir>0)?entry+rngH*InpTPRangeMult:entry-rngH*InpTPRangeMult);
   else                        tp=NormalizePrice((dir>0)?entry+dist*InpTP_R:entry-dist*InpTP_R);
   double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
   if(lot<=0){ Log("lotto 0: niente trade."); return(false); }

   // R55: anche il ramo a mercato (chiusura confermata) paga lo slippage.
   // Coperto qui apposta: la cella viva gira con InpUseCloseConfirm=0, ma se
   // qualcuno lo accendesse lo slippage sparirebbe in silenzio, ed e' il
   // genere di buco che poi non si trova piu'.
   if(InpSlippagePts>0)
     { double sp=InpSlippagePts*_Point;
       sl=NormalizePrice((dir>0)?sl-sp:sl+sp);
       tp=NormalizePrice((dir>0)?tp-sp:tp+sp); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB_Ottimizzato")) return(false);
   bool ok=(dir>0) ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,InpComment+" BUY CC")
                   : gTrade.Sell(lot,_Symbol,0.0,sl,tp,InpComment+" SELL CC");
   if(ok) Log(StringFormat("%s a mercato su chiusura confermata @ %.5f SL %.5f TP %.5f lot %.2f",
                           (dir>0?"BUY":"SELL"), entry, sl, tp, lot));
   else   Log("ingresso su chiusura confermata FALLITO: "+gTrade.ResultRetcodeDescription());
   return(ok);
  }

double EntryDistance()
  {
   double d=InpEntryPoints*InpK;                      // distanza in PREZZO
   double minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   return(MathMax(d,minD));
  }

//--- v1.02: buffer sullo stop in punti. Con InpSLBufferPts=0 vale 0 e
//    tutto resta identico a v1.01 (no-op esatto, voluto: vedi il blocco
//    commentato sull'input).
double SLBuffer(){ return(InpSLBufferPts>0 ? InpSLBufferPts*_Point : 0.0); }

double SLforLong(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeLow-SLBuffer();
   else if(InpSLMode==ORB_SL_FIXED) sl=entry-InpSLFixedPts*_Point;
   else if(InpSLMode==ORB_SL_HALFRANGE) sl=entry-0.5*(gRangeHigh-gRangeLow)-SLBuffer();
   else sl=entry-atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }
double SLforShort(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeHigh+SLBuffer();
   else if(InpSLMode==ORB_SL_FIXED) sl=entry+InpSLFixedPts*_Point;
   else if(InpSLMode==ORB_SL_HALFRANGE) sl=entry+0.5*(gRangeHigh-gRangeLow)+SLBuffer();
   else sl=entry+atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }

//+------------------------------------------------------------------+
//| Parziale al target + stop in pari (ad ogni tick)                 |
//+------------------------------------------------------------------+
void ManageTP1()
  {
   if(!SelPos()) return;
   //--- v1.03: DIFETTO N.2 del dossier 22/08, dichiarato UNA VOLTA SOLA.
   //    Il breakeven (InpBreakeven) vive DENTRO questa funzione, dopo il
   //    parziale: se InpTP1Pct<=0 si esce qui e lo stop in pari non puo'
   //    scattare MAI, anche con InpBreakeven=true nel pannello. Sul conto
   //    piccolo lo screenshot del 22/08 mostra proprio InpTP1Pct=0. Flag
   //    statico: e' una condizione di configurazione, non un evento -- va
   //    detta all'inizio, non a ogni tick.
   if(InpTP1Pct<=0)
     {
      static bool avvisatoTP1Zero=false;
      if(!avvisatoTP1Zero)
        {
         avvisatoTP1Zero=true;
         PrintFormat("ORB TP1: TP1/breakeven disattivati da InpTP1Pct=%.1f (<=0). Nessun parziale e NESSUNO stop in pari, anche se InpBreakeven=%s.",
                     InpTP1Pct,(InpBreakeven?"true":"false"));
        }
      return;
     }
   if(gPart1 || InpTP1Pct>=100) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double risk=isLong?(openP-sl):(sl-openP);
   if(risk<=0) return;
   double tgt=isLong?openP+risk*InpTP_R:openP-risk*InpTP_R;
   bool hit=isLong?(bid>=tgt):(ask<=tgt);
   if(!hit) return;
   double cv=NormVol(vol*InpTP1Pct/100.0);
   // 07/08: lo stop in pari NON deve dipendere dalla riuscita del parziale.
   // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non parte, e con
   // lui saltava anche il breakeven. Stessa correzione gia' fatta il 04/08 sugli
   // EMA200, dove era costata -112,78 EUR su due short oro a 0,01 lotti.
   bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
   if(parzOK) gPart1=true;
   double bePari  = NormalizePrice(openP);
   double slPrec  = PositionGetDouble(POSITION_SL);
   bool   dirLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
   // il breakeven si fa SOLO se migliora lo stop: cosi' non si ripete a ogni tick
   bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                    (!dirLong && (slPrec==0 || bePari<slPrec))));
   if(beFatto) gTrade.PositionModify(_Symbol,bePari,PositionGetDouble(POSITION_TP));
   if(parzOK || beFatto)
      Log(parzOK ? "target: parziale + stop in pari."
                 : "target: stop in pari (parziale impossibile al lotto minimo).");
  }

//+------------------------------------------------------------------+
//| Runner: trailing su EMA9 + uscita se chiude oltre EMA9 opposta   |
//+------------------------------------------------------------------+
void ManageRunner()
  {
   //--- v1.03 -- STRUMENTAZIONE. Fino alla v1.02 questa funzione era MUTA:
   //    usciva in silenzio su cinque rami diversi e non diceva niente nemmeno
   //    quando il trailing FUNZIONAVA. Ecco perche' il 19/08, il 21/08 e il
   //    02/09 la divergenza fra i due conti si e' potuta ricostruire solo
   //    confrontando a mano i prezzi di chiusura. Da qui in poi ogni uscita
   //    anticipata lascia il suo motivo nel Giornale del terminale.
   //    THROTTLE: ManageRunner e' gia' chiamata una sola volta per barra M5
   //    (OnTick, ramo newBar), ma i rami "normali" -- posizione assente,
   //    condizione EMA non soddisfatta -- si stampano comunque al massimo una
   //    volta per barra, cosi' la protezione regge anche se un domani qualcuno
   //    spostasse la chiamata a ogni tick.
   static datetime gDiagBar=0;
   datetime barOra=iTime(_Symbol,InpExecTF,0);
   bool unaPerBarra=(barOra!=gDiagBar);
   if(unaPerBarra) gDiagBar=barOra;

   if(!SelPos())
     {
      //--- Ramo 1. Nessuna posizione NOSTRA selezionabile. Nel caso normale
      //    (nessuna posizione aperta) si tace, altrimenti il log si riempie di
      //    righe inutili a ogni barra. Ma se una posizione col NOSTRO magic
      //    esiste davvero e SelPos() dice comunque di no, siamo davanti
      //    all'anomalia da conto HEDGING: SelPos() usa PositionSelect(_Symbol),
      //    che seleziona la PRIMA posizione del simbolo QUALUNQUE sia il magic
      //    -- e su U30USD sul conto piccolo girano anche 770202, 771531, 770511,
      //    770531... Se ne e' aperta una di un'altra sedia, il nostro controllo
      //    sul magic fallisce e il runner esce QUI, in silenzio: niente
      //    trailing, niente uscita su EMA, niente breakeven. E' esattamente il
      //    sintomo osservato il 02/09. Questa riga lo dimostra o lo scagiona.
      int nostre=ContaPosizioniMagic();
      if(nostre>0 && unaPerBarra)
         PrintFormat("ORB RUNNER: SelPos() FALSO ma risultano %d posizioni con magic %s su %s -> PositionSelect ha selezionato la posizione di un'ALTRA sedia (conto hedging). Gestione del runner SALTATA.",
                     nostre,IntegerToString(InpMagic),_Symbol);
      return;
     }

   if(!InpUseTrailEMA && !InpExitOnEmaClose)
     {
      //--- Ramo 2. Configurazione: entrambe le gestioni EMA sono spente.
      if(unaPerBarra)
         Print("ORB RUNNER: InpUseTrailEMA=false E InpExitOnEmaClose=false -> nessuna gestione del runner, lo stop resta dov'e'.");
      return;
     }

   if(hEmaF==INVALID_HANDLE)
     {
      //--- Ramo 3. Handle mai nato (ipotesi n.2 del dossier). OnInit fallisce
      //    gia' in questo caso, ma se l'EA fosse stato ricaricato a caldo la
      //    riga qui sotto e' l'unica prova che resta.
      Print("ORB RUNNER: handle EMA veloce INVALID_HANDLE -> impossibile trailare. Ricaricare l'EA sul grafico.");
      return;
     }

   //--- Ramo 4. L'handle c'e' ma i dati no: CopyBuffer fallisce (dati non
   //    ancora sincronizzati, storico in caricamento, indicatore non calcolato).
   //    Nella v1.02 questo era il silenzio perfetto: return e nessuna traccia.
   double ef[1];
   ResetLastError();
   int copiati=CopyBuffer(hEmaF,0,1,1,ef);
   if(copiati!=1)
     {
      PrintFormat("ORB RUNNER: CopyBuffer(EMA%d handle %d, shift 1) ha restituito %d invece di 1, err=%d -> gestione saltata su questa barra.",
                  InpEmaFast,hEmaF,copiati,GetLastError());
      return;
     }

   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double close1=iClose(_Symbol,InpExecTF,1);
   if(close1<=0)
      PrintFormat("ORB RUNNER: iClose(%s,TF %d,shift 1) = %.5f (dato assente): il confronto con l'EMA usa un prezzo non valido.",
                  _Symbol,(int)InpExecTF,close1);

   if(InpExitOnEmaClose)
     {
      if(isLong && close1<ef[0])
        {
         bool okC=gTrade.PositionClose(_Symbol);
         if(okC) Log("chiusura M5 sotto EMA9: uscita.");
         else    PrintFormat("ORB RUNNER: uscita per chiusura sotto EMA%d FALLITA, retcode %u (%s), err=%d",
                             InpEmaFast,gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
         return;
        }
      if(!isLong && close1>ef[0])
        {
         bool okC=gTrade.PositionClose(_Symbol);
         if(okC) Log("chiusura M5 sopra EMA9: uscita.");
         else    PrintFormat("ORB RUNNER: uscita per chiusura sopra EMA%d FALLITA, retcode %u (%s), err=%d",
                             InpEmaFast,gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
         return;
        }
     }
   if(InpUseTrailEMA)
     {
      double sl=PositionGetDouble(POSITION_SL);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double newSL=NormalizePrice(ef[0]);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      if(isLong && newSL>sl && newSL<bid)
        {
         ResetLastError();
         if(gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP)))
            PrintFormat("ORB RUNNER: stop LONG trascinato su EMA%d: %s -> %s (apertura %s, BID %s).",
                        InpEmaFast,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        DoubleToString(openP,_Digits),DoubleToString(bid,_Digits));
         else
            PrintFormat("ORB RUNNER: PositionModify LONG FALLITA (%s -> %s), retcode %u (%s), err=%d",
                        DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
        }
      else if(isLong && unaPerBarra)
         //--- Ramo 5. Condizione non soddisfatta: si dicono i tre numeri che la
         //    decidono, cosi' dal log si capisce SUBITO se l'EMA e' sotto lo
         //    stop attuale (nulla da trascinare) o se e' il vincolo sul BID a
         //    mordere. Una riga per barra, non a ogni tick.
         PrintFormat("ORB RUNNER: nessun trascinamento LONG. EMA%d=%s, SL attuale=%s, BID=%s (servono EMA>SL e EMA<BID).",
                     InpEmaFast,DoubleToString(newSL,_Digits),DoubleToString(sl,_Digits),DoubleToString(bid,_Digits));

      if(!isLong && (newSL<sl||sl==0) && newSL>ask)
        {
         ResetLastError();
         if(gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP)))
            PrintFormat("ORB RUNNER: stop SHORT trascinato su EMA%d: %s -> %s (apertura %s, ASK %s).",
                        InpEmaFast,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        DoubleToString(openP,_Digits),DoubleToString(ask,_Digits));
         else
            PrintFormat("ORB RUNNER: PositionModify SHORT FALLITA (%s -> %s), retcode %u (%s), err=%d",
                        DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
        }
      else if(!isLong && unaPerBarra)
         PrintFormat("ORB RUNNER: nessun trascinamento SHORT. EMA%d=%s, SL attuale=%s, ASK=%s (servono EMA<SL o SL=0, e EMA>ASK).",
                     InpEmaFast,DoubleToString(newSL,_Digits),DoubleToString(sl,_Digits),DoubleToString(ask,_Digits));
     }
  }

//+------------------------------------------------------------------+
//| v1.03 (solo DIAGNOSTICA, non decide niente): quante posizioni con |
//| il NOSTRO magic ci sono davvero su questo simbolo. Serve a        |
//| smascherare il caso hedging in cui PositionSelect(_Symbol) --     |
//| usata da SelPos() -- seleziona la posizione di un'altra sedia e   |
//| il controllo sul magic fa uscire il runner in silenzio.           |
//| Costo: chiamata solo nel ramo diagnostico, al massimo una volta   |
//| per barra M5.                                                     |
//+------------------------------------------------------------------+
int ContaPosizioniMagic()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      n++;
     }
   return(n);
  }

//+------------------------------------------------------------------+
void HandleOCO(){ if(SelPos()) CancelPendings(); }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

void EndOfDay()
  {
   CancelPendings();
   if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(_Symbol); Log("fine giornata: posizione chiusa."); }
   gPhase=ORB_DONE;
  }

//==================================================================
//  UTILITY
//==================================================================
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)<1) return(0); return(a[0]); }

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
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
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

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro spento."); return; }
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

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE (09/08/2026) - serve al DD di PORTAFOGLIO.       |
//| A fine test scrive nella cartella COMUNE (Files comuni) un CSV    |
//| con una riga per ogni trade CHIUSO (ora di chiusura e netto):     |
//| con le serie di piu' EA si calcolano DD combinato e Monte Carlo   |
//| (backtest_pipeline/dd_portafoglio.py). Solo tester. In            |
//| ottimizzazione ogni pass sovrascrive il file del proprio magic:   |
//| usarlo su run singoli / magic-sweep, non sulle griglie larghe.    |
//+------------------------------------------------------------------+
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
   ExportTrades();   // per-trade per il DD di portafoglio (ROTTA_PROP punto 4)
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
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
//================== fine OPTFRAME inlined ==========================//
