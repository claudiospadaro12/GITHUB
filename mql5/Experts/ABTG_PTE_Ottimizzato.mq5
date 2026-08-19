//+------------------------------------------------------------------+
//|                                       ABTG_PTE_Ottimizzato.mq5    |
//|                                                                  |
//|  EA "PTE" (Pro Trading Experience) - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia PTE (Emiliano Monza / ABTG).            |
//|  Mean-reversion sugli estremi dei canali di regressione (TMA),  |
//|  confermata da una DOJI col corpo FUORI dal canale veloce e dal |
//|  cambio colore della candela (Heikin Ashi) successiva.         |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                               |
//|   - Canali TMA slow (struttura) e fast (operativo), NON-REPAINT;|
//|   - DOJI col corpo oltre il canale veloce -> estremo;          |
//|   - conferma col cambio colore Heikin Ashi;                    |
//|   - SL = ATR + buffer (o estremo Doji); TP1 EMA14 parz.50% +   |
//|     pari, TP2 = 2*ATR, trailing; blocco news.                 |
//|                                                                  |
//|  NON automatizzato (proprietario/discrezionale, come da guida): |
//|   PTE Filter Indicator (algoritmo proprietario), Opposing/Larry |
//|   Williams, S/R multi-timeframe, W%R come conferma manuale.    |
//|  NB: i canali della DASHBOARD PTE probabilmente REPAINTANO; qui |
//|  si usa una TMA non-repainting, quindi i valori differiscono.  |
//|  Parametri TMA per coppia: vedi tabella "Setting_canali_PTE".   |
//|                                                                  |
//|  ============================================================    |
//|  COPIA _Ottimizzato DI ABTG_PTE -- UNA SOLA MODIFICA VERA        |
//|  ============================================================    |
//|  Nasce dalla serie R67-R73. Fatto misurato, dieci volte su       |
//|  dieci (due modelli, tre finestre, due simboli, due             |
//|  impostazioni di TP1): **il drawdown della PTE scende col        |
//|  buffer dello stop, sempre e monotonamente.**                    |
//|                                                                  |
//|  Ma R69 ha trovato il difetto: `InpSLbufferPips` e' in PIP,      |
//|  mentre l'ATR a cui viene sommato e' in UNITA' DELLO STRUMENTO.  |
//|  Sui cambi a 5 cifre PipSize() vale 10*Point e le due grandezze  |
//|  hanno la stessa scala (30 pip ~ 1,5 ATR: la manopola gira).     |
//|  Sul Dow PipSize() vale Point, e 30 "pip" valgono ~0,03 ATR:     |
//|  **la manopola non gira** -- in R69 tutte e 28 le celle hanno    |
//|  fatto gli stessi identici 46 trade e lo stesso DD allo 0,007.   |
//|                                                                  |
//|  Quindi il parametro NON e' portabile fra classi di strumenti,   |
//|  e un valore unico per la famiglia PTE non puo' essere giusto.   |
//|  La cosa da sistemare e' l'UNITA', non il valore.                |
//|                                                                  |
//|  QUI: `InpSLbufferMode`                                          |
//|     0 = PIP    -> identico bit per bit all'originale (default)   |
//|     1 = ATR    -> buffer = InpSLbufferATR * ATR, portabile       |
//|                                                                  |
//|  🔴 IL DEFAULT E' 0 APPOSTA: con mode 0 questo EA deve           |
//|     RIPRODURRE R73 AL CENTESIMO. Se non lo fa, la copia e'       |
//|     sbagliata e il round nuovo non vale niente. E' il primo      |
//|     controllo da fare, prima di guardare qualunque numero.       |
//|                                                                  |
//|  Regola di casa: gli _Ottimizzato girano IN PARALLELO agli       |
//|  originali, con magic diversi. Non sostituiscono mai niente.     |
//|  DEMO. Nessuna garanzia.                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.02"
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
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;   // TF operativo (guida: H4 o H1)

input group "=== Canale TMA LENTO (struttura) ==="
input int    InpTmaSlow    = 56;    // Periodo TMA lento (setting_canali: per coppia)
input int    InpAtrSlow    = 100;   // Periodo ATR canale lento
input double InpMultSlow    = 2.0;  // Moltiplicatore ampiezza

input group "=== Canale TMA VELOCE (operativo) ==="
input int    InpTmaFast    = 14;    // Periodo TMA veloce
input int    InpAtrFast    = 30;    // Periodo ATR canale veloce
input double InpMultFast    = 2.0;  // Moltiplicatore ampiezza

input group "=== Doji e conferma ==="
input double InpDojiBodyMaxPct = 10.0; // corpo <= % del range per essere Doji
input bool   InpUseHeikinAshi  = true; // usa Heikin Ashi per corpo/conferma
input bool   InpRequireOutSlow  = false;// Doji fuori anche dal canale LENTO (piu' selettivo)
input bool   InpRequireColorFlip = true;// conferma = cambio colore della candela successiva
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Filtro trend/momentum (opzionale) ==="
input bool   InpUseEma200Bias = false; // opera solo verso la EMA200 (mean-reversion di rientro)
input int    InpEma200Period  = 200;
input int    InpEma14Period   = 14;    // primo target
input bool   InpUseWPR         = false;// filtro Williams %R (uscita da ipercomp/ipervend)
input int    InpWprPeriod      = 14;
input double InpWprOB          = -20.0;
input double InpWprOS          = -80.0;

input group "=== Stop / target (ATR) ==="
input int    InpAtrExitPeriod = 14;    // ATR per SL/target
input double InpSLbufferPips   = 5.0;  // MODE 0: SL = ATR + questo (pip). Guida: 5/10 pip
input int    InpSLbufferMode   = 0;    // 0 = buffer in PIP (identico all'originale) | 1 = buffer in ATR
input double InpSLbufferATR    = 0.25; // MODE 1: SL = ATR * (1 + questo). Portabile su ogni strumento
input bool   InpSLfromDoji     = false;// alternativa: SL sull'estremo della Doji +/- buffer
input double InpTP1_ATRmult    = 0.0;  // 0 = TP1 sulla EMA14; altrimenti N*ATR
input double InpTP1Pct         = 50;   // % chiusa al 1o target
input bool   InpBreakeven      = true;
input double InpTP2_ATRmult    = 2.0;  // 2o target = N*ATR (guida: 2 ATR)
input bool   InpUseTrailing    = true; // trailing sull'EMA14 dopo il 1o target

input group "=== Rischio ==="
input double InpRiskPercent   = 1.0;
input int    InpMaxTradesPerDay = 0;
input int    InpMaxPositions   = 1;

input group "=== Filtro notizie (la PTE vuole: niente news in arrivo) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "PTE_OTT";     // commento ordini
input long   InpMagic     = 771331;   // 7713xx = famiglia PTE. 771331 = _Ottimizzato, mai usato
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

input group "=== Slippage stimato (R55: quanto scala questa cella) ==="
//  PERCHE' (15/08/2026, R55). Tutti i backtest del progetto girano con
//  riempimento PERFETTO: entry esatta, sempre. E' un'approssimazione
//  ragionevole alle taglie di oggi, non lo e' piu' a taglia prop grande
//  (su 1,5M il DAX vorrebbe ~177 lotti per trade). Questo input serve a
//  misurare QUANTO edge resta con un'esecuzione peggiore.
//
//  COME E' MODELLATO, e perche' cosi':
//  nel tester non si puo' cambiare il prezzo a cui il broker riempie.
//  Ma uno slippage di X punti equivale, sul conto economico, a chiudere
//  X punti piu' in la' nel verso sfavorevole: quindi si spostano SL e TP
//  di X nel verso contrario al trade, DOPO aver calcolato il lotto.
//  Effetto netto: -X punti su OGNI trade, vincente o perdente. Che e'
//  esattamente cosa fa lo slippage.
//  Il lotto resta calcolato sul rischio ORIGINALE, quello che l'EA vede
//  al momento di decidere: cosi' lo slippage si manifesta come un R
//  leggermente piu' grande del previsto, come nella realta'.
//
//  LIMITE DICHIARATO: e' un modello del PRIMO ORDINE. Non simula il
//  riempimento parziale ne' la profondita' del book, che MT5 non
//  modella affatto. E la gestione a runtime (trailing, BE, parziali)
//  ricalcola i suoi livelli per conto suo.
//
//  DEFAULT 0 = comportamento identico a prima, forward invariato.
input double InpSlippagePts = 0;   // R55: slippage stimato in PUNTI (0 = off, come sempre)


//==================================================================
//  STATO
//==================================================================
int  hAtrSlow=INVALID_HANDLE, hAtrFast=INVALID_HANDLE, hAtrExit=INVALID_HANDLE;
int  hEma200=INVALID_HANDLE, hEma14=INVALID_HANDLE, hWpr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

//--- METRICHE DA PROP (07/08/2026). L'Equity DD dice se il conto sopravvive;
//    una prop invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa
//    e su PTE non era misurata da nessuna parte. Qui si segue l'equity dentro
//    la giornata e si tiene la caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;   // equity all'inizio della giornata
double gDayMinEquity   = 0.0;   // minimo di equity toccato nella giornata
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;    // giorno dell'anno usato per il reset qui sopra

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[PTE] ", m); }

//+------------------------------------------------------------------+
double PipSize()
  {
   int d=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   return (d==3 || d==5) ? _Point*10.0 : _Point;
  }

int OnInit()
  {
   //--- R74: il modo del buffer si dichiara, non si indovina
   if(InpSLbufferMode<0 || InpSLbufferMode>1)
     { Print("ERRORE: InpSLbufferMode deve essere 0 (pip) o 1 (ATR)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpSLbufferMode==1 && InpSLbufferATR<0.0)
     { Print("ERRORE: InpSLbufferATR non puo' essere negativo."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpSLbufferMode==0 && InpSLbufferPips<0.0)
     { Print("ERRORE: InpSLbufferPips non puo' essere negativo."); return(INIT_PARAMETERS_INCORRECT); }
   PrintFormat("PTE_Ottimizzato: buffer in %s (%s = %.4f), magic %I64d",
               (InpSLbufferMode==1?"ATR":"PIP"),
               (InpSLbufferMode==1?"InpSLbufferATR":"InpSLbufferPips"),
               (InpSLbufferMode==1?InpSLbufferATR:InpSLbufferPips), InpMagic);

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtrSlow=iATR(_Symbol,InpTF,InpAtrSlow);
   hAtrFast=iATR(_Symbol,InpTF,InpAtrFast);
   hAtrExit=iATR(_Symbol,InpTF,InpAtrExitPeriod);
   hEma200 =iMA(_Symbol,InpTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   hEma14  =iMA(_Symbol,InpTF,InpEma14Period,0,MODE_EMA,PRICE_CLOSE);
   hWpr    =iWPR(_Symbol,InpTF,InpWprPeriod);
   if(hAtrSlow==INVALID_HANDLE||hAtrFast==INVALID_HANDLE||hAtrExit==INVALID_HANDLE||
      hEma200==INVALID_HANDLE||hEma14==INVALID_HANDLE||hWpr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. TMA lento %d / veloce %d.",
       _Symbol,EnumToString(InpTF),InpTmaSlow,InpTmaFast));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[6]={hAtrSlow,hAtrFast,hAtrExit,hEma200,hEma14,hWpr};
   for(int i=0;i<6;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageAll();

   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del giorno.
   //    Sta QUI e non dopo il filtro della nuova barra: su H4 una candela dura
   //    quattro ore, e la caduta peggiore di giornata succede in mezzo.
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

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
//| TMA non-repainting: media triangolare (SMA di SMA) su close.     |
//| Ritorna mid/upper/lower alla barra chiusa 'shift'.               |
//+------------------------------------------------------------------+
bool TmaBand(int period,int atrHandle,double mult,int shift,double &mid,double &up,double &lo)
  {
   int m=(period+1)/2; if(m<1) m=1;
   int need=period+m+shift+5;
   double c[]; ArraySetAsSeries(c,true);
   if(CopyClose(_Symbol,InpTF,0,need,c)<need) return(false);
   // sma1[i] = SMA(close,m) centrata a i (usando barre piu' vecchie: non-repaint)
   // tma[shift] = SMA(sma1, m) a partire da shift
   double tma=0;
   for(int k=0;k<m;k++)
     {
      double s=0;
      for(int j=0;j<m;j++) s+=c[shift+k+j];
      tma+=s/m;
     }
   tma/=m;
   double a[1];
   if(CopyBuffer(atrHandle,0,shift,1,a)!=1||a[0]<=0) return(false);
   mid=tma; up=tma+a[0]*mult; lo=tma-a[0]*mult;
   return(true);
  }

//+------------------------------------------------------------------+
//| Heikin Ashi per la barra 'shift' (o candele normali se off)      |
//+------------------------------------------------------------------+
void GetCandle(int shift,double &o,double &h,double &l,double &c)
  {
   h=iHigh(_Symbol,InpTF,shift); l=iLow(_Symbol,InpTF,shift);
   if(!InpUseHeikinAshi){ o=iOpen(_Symbol,InpTF,shift); c=iClose(_Symbol,InpTF,shift); return; }
   // Heikin Ashi non-repaint su barre chiuse
   double haC=(iOpen(_Symbol,InpTF,shift)+iHigh(_Symbol,InpTF,shift)+iLow(_Symbol,InpTF,shift)+iClose(_Symbol,InpTF,shift))/4.0;
   // haOpen ricorsivo: approssimo con 2 barre di seed
   double haO_prev=(iOpen(_Symbol,InpTF,shift+2)+iClose(_Symbol,InpTF,shift+2))/2.0;
   double haC_prev=(iOpen(_Symbol,InpTF,shift+1)+iHigh(_Symbol,InpTF,shift+1)+iLow(_Symbol,InpTF,shift+1)+iClose(_Symbol,InpTF,shift+1))/4.0;
   double haO=(haO_prev+haC_prev)/2.0;
   o=haO; c=haC;
   h=MathMax(h,MathMax(o,c)); l=MathMin(l,MathMin(o,c));
  }

bool IsDoji(double o,double h,double l,double c)
  {
   double range=h-l; if(range<=0) return(false);
   return(MathAbs(c-o) <= InpDojiBodyMaxPct/100.0*range);
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   // Doji sulla barra [2], conferma sulla barra [1]
   double o2,h2,l2,c2, o1,h1,l1,c1;
   GetCandle(2,o2,h2,l2,c2);
   GetCandle(1,o1,h1,l1,c1);
   if(!IsDoji(o2,h2,l2,c2)) return;

   double midF,upF,loF, midS,upS,loS;
   if(!TmaBand(InpTmaFast,hAtrFast,InpMultFast,2,midF,upF,loF)) return;
   if(!TmaBand(InpTmaSlow,hAtrSlow,InpMultSlow,2,midS,upS,loS)) return;

   double body_hi=MathMax(o2,c2), body_lo=MathMin(o2,c2);

   //--- Doji col corpo FUORI dal canale veloce (sine qua non): sopra=short, sotto=long
   bool dojiAbove = (body_lo>upF) && (!InpRequireOutSlow || body_lo>upS);
   bool dojiBelow = (body_hi<loF) && (!InpRequireOutSlow || body_hi<loS);
   if(!(dojiAbove||dojiBelow)) return;

   bool wantShort = dojiAbove;
   bool wantLong  = dojiBelow;

   // conferma: cambio colore della candela [1] nella direzione dell'inversione
   bool bear1=(c1<o1), bull1=(c1>o1);
   if(InpRequireColorFlip)
     {
      if(wantShort && !bear1) return;
      if(wantLong  && !bull1) return;
     }

   // filtri opzionali
   if(wantLong && !InpAllowLong) return;
   if(wantShort && !InpAllowShort) return;
   if(InpUseEma200Bias && !Ema200BiasOK(wantLong)) return;
   if(InpUseWPR && !WprOK(wantLong)) return;

   Enter(wantLong,h2,l2);
  }

//+------------------------------------------------------------------+
bool Ema200BiasOK(bool isLong)
  {
   double e[1]; if(CopyBuffer(hEma200,0,1,1,e)!=1) return(true);
   double c1=iClose(_Symbol,InpTF,1);
   // rientro verso la media: long se sotto la EMA200, short se sopra
   return(isLong ? c1<e[0] : c1>e[0]);
  }

bool WprOK(bool isLong)
  {
   double w[2]; ArraySetAsSeries(w,true);
   if(CopyBuffer(hWpr,0,1,2,w)!=2) return(true);
   // long: W%R esce dall'ipervenduto (risale sopra OS); short: esce dall'ipercomprato
   if(isLong)  return(w[1]<=InpWprOS && w[0]>InpWprOS);
   return(w[1]>=InpWprOB && w[0]<InpWprOB);
  }

//+------------------------------------------------------------------+
void Enter(bool isLong,double dojiHigh,double dojiLow)
  {
   double pip=PipSize();
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double a[1]; if(CopyBuffer(hAtrExit,0,1,1,a)!=1||a[0]<=0){ Log("ATR non disp."); return; }
   double atr=a[0];

   // --- BUFFER DELLO STOP -----------------------------------------
   //  MODE 0 (default): buffer in PIP -> ramo IDENTICO all'originale.
   //  MODE 1: buffer in multipli di ATR. Sui cambi a 5 cifre l'ATR H1
   //  vale ~20 pip, quindi InpSLbufferATR 0,25 ~ 5 pip e 1,50 ~ 30 pip:
   //  l'intervallo spazzato in R68-R73 in unita' portabili. Sul Dow la
   //  stessa manopola muove finalmente lo stop, invece dello 0,03 ATR.
   double buf;                                   // in UNITA' DI PREZZO
   if(InpSLbufferMode==1) buf = atr*InpSLbufferATR;
   else                   buf = InpSLbufferPips*pip;

   double sl;
   if(InpSLfromDoji) sl = isLong ? dojiLow-buf : dojiHigh+buf;
   else              sl = isLong ? entry-(atr+buf) : entry+(atr+buf);
   sl=NormalizePrice(sl);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(risk<=minDist){ Log("SL non valido: skip."); return; }

   // TP finale = 2 ATR (o tecnico). TP intermedio gestito a runtime (EMA14 / TP1_ATR).
   double tp = isLong ? entry+atr*InpTP2_ATRmult : entry-atr*InpTP2_ATRmult;
   tp=NormalizePrice(tp);

   double lot=LotByRisk(risk);   // il lotto viene dal rischio ORIGINALE, prima dello slippage
   if(lot<=0){ Log("lotto nullo."); return; }

   // R55: slippage. SL e TP si spostano di X punti nel verso contrario al
   //      trade: lo stop scatta X piu' in la' (si perde di piu') e il TP
   //      X prima (si guadagna di meno). Netto: -X punti su ogni trade.
   if(InpSlippagePts>0)
     {
      double sp=InpSlippagePts*_Point;
      sl = NormalizePrice(isLong ? sl-sp : sl+sp);
      tp = NormalizePrice(isLong ? tp-sp : tp+sp);
      Log(StringFormat("slippage stimato %.0f pt applicato a SL/TP (R55).",InpSlippagePts));
     }

   string cm=InpComment+(isLong?" L":" S");
   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_PTE_Ottimizzato")) return;
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                 :gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok){ gTradesToday++; Log(StringFormat("%s @ %s SL %s TP %s lot %.2f",isLong?"LONG":"SHORT",
           DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Gestione: 1o target (EMA14 o N*ATR) parziale + pari; trailing    |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double e14[1]; bool haveE14=(CopyBuffer(hEma14,0,1,1,e14)==1);
   double a[1]; double atr=(CopyBuffer(hAtrExit,0,1,1,a)==1?a[0]:0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      double vol=PositionGetDouble(POSITION_VOLUME);

      bool beDone = isLong ? (sl>=openP) : (sl<=openP && sl>0);

      // 1o target
      if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt;
         if(InpTP1_ATRmult>0 && atr>0) tgt=isLong?openP+atr*InpTP1_ATRmult:openP-atr*InpTP1_ATRmult;
         else if(haveE14)              tgt=e14[0];       // primo target naturale = EMA14
         else                          tgt=0;
         if(tgt>0)
           {
            bool hit=isLong?(bid>=tgt):(ask<=tgt);
            if(hit)
              {
               double cv=NormVol(vol*InpTP1Pct/100.0);
               // Lo STOP IN PARI non deve dipendere dalla riuscita del parziale.
               // Al LOTTO MINIMO NormVol(vol*50%) arrotonda a 0: il parziale non
               // parte mai e, prima del 04/08/2026, con lui saltava anche il
               // breakeven. Misurato: due short oro a 0,01 lotti hanno toccato
               // 1,28R di profitto con lo stop ancora all'originale, e sono
               // tornati in perdita (-112,78 EUR di oscillazione).
               bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
               if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
               Log(parz ? "1o target: parziale + stop in pari."
                        : "1o target (1R): stop in pari (parziale impossibile al lotto minimo).");
              }
           }
        }

      // trailing sull'EMA14 dopo il breakeven
      if(InpUseTrailing && beDone && haveE14)
        {
         double n=NormalizePrice(e14[0]);
         double slNow=PositionGetDouble(POSITION_SL);
         if(isLong && n>slNow && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
         if(!isLong && (n<slNow||slNow==0) && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
        }
     }
  }

//==================================================================
//  UTILITY
//==================================================================
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

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
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
