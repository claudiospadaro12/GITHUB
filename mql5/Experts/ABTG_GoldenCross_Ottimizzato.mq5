//+------------------------------------------------------------------+
//|                                           ABTG_GoldenCross.mq5    |
//|                                                                  |
//|  EA "GOLDEN CROSS HA" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO     |
//|  (non serve nessun file .mqh ne cartella Include: metti questo   |
//|   file in MQL5\Experts e compila con F7)                        |
//|                                                                  |
//|  Basato sul documento "GOLDEN CROSS HA Strategy" (Masterclass    |
//|  ABTG): EMA 9/21/50 + Heiken Ashi + ADX/DI.                     |
//|                                                                  |
//|  SEQUENZA (long; short speculare):                              |
//|   1) CONTESTO   prezzo sopra EMA50 (EMA50 non ribassista)       |
//|   2) TRIGGER    EMA9 ha incrociato EMA21 (di recente)           |
//|   3) ALLINEAM.  EMA9 > EMA21 > EMA50 inclinate su               |
//|   4) MOMENTUM   3 Heiken Ashi rialziste, senza ombra contraria  |
//|   5) FORZA      ADX > 20 (meglio 25), crescente, DI+ > DI-      |
//|   6) TRADEAB.   prezzo non troppo distante, R:R accettabile     |
//|  Uscite: TP, chiusura oltre EMA21 / incrocio inverso, gestione  |
//|  con parziale + stop in pari + trailing (EMA21 o ATR).          |
//|  Money mgmt: rischio %, max 2 trade/giorno, stop dopo 2 perdite.|
//|                                                                  |
//|  ⚠️ Nessun EA garantisce profitti. TESTA SU DEMO.                |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  ENUM
//==================================================================
enum ENUM_GC_ENTRY { GC_MARKET = 0, GC_PULLBACK = 1 };   // a mercato o limit su pullback
enum ENUM_GC_REF   { GC_REF_EMA9 = 0, GC_REF_EMA21 = 1 };// dove metto il limit del pullback
enum ENUM_GC_SL    { GC_SL_SWING = 0, GC_SL_ATR = 1 };   // stop tecnico o su ATR
enum ENUM_GC_TRAIL { GC_TR_EMA21 = 0, GC_TR_ATR = 1, GC_TR_OFF = 2 };

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe e medie ==="
input ENUM_TIMEFRAMES InpTimeframe = PERIOD_H1;   // Timeframe operativo (strategia: H1)
input int    InpEmaFast   = 9;                    // EMA veloce (trigger)
input int    InpEmaMid    = 21;                   // EMA intermedia (conferma)
input int    InpEmaSlow   = 50;                   // EMA lenta (contesto/direzione)
input int    InpEmaSlopeBars = 3;                 // Barre per valutare l'inclinazione delle medie
input bool   InpRequireAlignment = true;          // Pretendi EMA9>EMA21>EMA50 (ordinate)
input int    InpCrossLookback = 8;                // L'incrocio EMA9/21 deve essere nelle ultime N barre

input group "=== Heiken Ashi (momentum) ==="
input int    InpHACount     = 3;                  // Candele HA consecutive richieste
input double InpHAWickRatio = 0.30;               // Max ombra contraria come frazione del corpo
input double InpHABodyFactor= 0.60;               // Il corpo non deve collassare (corpo recente >= X * corpo iniziale)

input group "=== ADX / DI (forza) ==="
input int    InpAdxPeriod = 14;                   // Periodo ADX
input double InpAdxMin     = 15.0;                // ADX minimo (meglio 25)
input bool   InpAdxRising  = true;                // Richiedi ADX crescente o stabile
input bool   InpRequireDI  = true;                // Richiedi DI+ > DI- (long) / DI- > DI+ (short)

input group "=== Filtri di tradeability ==="
input double InpMaxDistATR = 1.5;                 // Prezzo entro X*ATR dalla EMA9 (non troppo esteso)
input double InpMinRR      = 1.0;                 // Rapporto rischio/rendimento minimo

input group "=== Ingresso ==="
input ENUM_GC_ENTRY InpEntryMode = GC_MARKET;     // A mercato sulla conferma, o LIMIT su pullback
input ENUM_GC_REF   InpPullbackRef = GC_REF_EMA9; // (pullback) livello del limit: EMA9 o EMA21
input int    InpPendingExpiryBars = 3;            // (pullback) barre di validita' del limit
input bool   InpAllowLong  = true;                // Consenti long
input bool   InpAllowShort = true;                // Consenti short

input group "=== Stop, target, gestione ==="
input ENUM_GC_SL InpSLMode = GC_SL_SWING;         // Stop tecnico (swing) o su ATR
input int    InpSwingLookback = 10;               // (swing) barre per min/max recente
input int    InpAtrPeriod  = 14;                  // Periodo ATR
input double InpAtrSLmult   = 1.0;                // (ATR) stop = X * ATR
input double InpSLBufferPts = 0;                  // Buffer extra sullo stop, in punti (0 = min broker)
input double InpTP_R        = 3.0;                // Take profit in R (multipli del rischio)
input double InpPartialR    = 1.0;                // 1a parziale a X R (0 = nessuna parziale)
input double InpPartialPct  = 50;                 // % chiusa alla parziale
input bool   InpBreakeven   = true;               // Stop in pari dopo la parziale
input ENUM_GC_TRAIL InpTrailMode = GC_TR_EMA21;   // Trailing: EMA21, ATR o disattivo
input double InpTrailAtrMult= 2.0;                // (ATR) trailing = X * ATR
input bool   InpExitOnCross = true;               // Esci se EMA9 reincrocia EMA21 contro di te
input bool   InpExitOnHAflip= false;              // Esci al cambio colore Heiken Ashi

input group "=== Money management ==="
input double InpRiskPercent = 1.0;                // Rischio per trade in % (PDF: 0.5 demo, 1 ordinario, max 2)
input int    InpMaxTradesPerDay = 2;              // Max trade al giorno (0 = illimitato)
input int    InpStopAfterLosses = 2;              // Stop giornata dopo N perdite consecutive (0 = off)

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;            // Blocca il trading intorno alle news
input string InpNewsFile      = "abtg_news.csv";  // File CSV con le notizie
input int    InpNewsMinImpact = 3;                // Impatto minimo (3=High)
input int    InpNewsBeforeMin = 30;               // Minuti stop prima
input int    InpNewsAfterMin  = 30;               // Minuti stop dopo
input int    InpNewsShiftMinutes = 0;             // Sposta gli orari del file per allinearli al server
input string InpNewsCurrencies= "USD";            // Valute da filtrare (vuoto = tutte)

input group "=== Generali ==="
input long   InpMagic     = 970301;               // Numero magico
input int    InpMaxSpread = 0;                    // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose   = true;                 // Messaggi nel log

//==================================================================
//  STATO
//==================================================================
int      hEmaF=INVALID_HANDLE, hEmaM=INVALID_HANDLE, hEmaS=INVALID_HANDLE;
int      hAdx=INVALID_HANDLE,  hAtr=INVALID_HANDLE;
datetime gLastBar=0;
bool     gPartialDone=false;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[GoldenCross] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   hEmaF = iMA(_Symbol, InpTimeframe, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
   hEmaM = iMA(_Symbol, InpTimeframe, InpEmaMid,  0, MODE_EMA, PRICE_CLOSE);
   hEmaS = iMA(_Symbol, InpTimeframe, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
   hAdx  = iADX(_Symbol, InpTimeframe, InpAdxPeriod);
   hAtr  = iATR(_Symbol, InpTimeframe, InpAtrPeriod);
   if(hEmaF==INVALID_HANDLE||hEmaM==INVALID_HANDLE||hEmaS==INVALID_HANDLE||hAdx==INVALID_HANDLE||hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori non creati."); return(INIT_FAILED); }

   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s TF %s. Rischio %.1f%%, max %d trade/giorno.",
       _Symbol, EnumToString(InpTimeframe), InpRiskPercent, InpMaxTradesPerDay));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaM!=INVALID_HANDLE) IndicatorRelease(hEmaM);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
   if(hAdx !=INVALID_HANDLE) IndicatorRelease(hAdx);
   if(hAtr !=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageOpen();                       // gestione posizione ad ogni tick

   if(!IsNewBar()) return;             // le decisioni d'ingresso solo a barra chiusa

   if(HasOpenPos() || HasPending()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   int trades, losses;
   TodayStats(trades, losses);
   if(InpMaxTradesPerDay>0 && trades>=InpMaxTradesPerDay) return;
   if(InpStopAfterLosses>0 && losses>=InpStopAfterLosses) return;

   int sig = Signal();
   if(sig>0 && InpAllowLong)  Enter(true);
   if(sig<0 && InpAllowShort) Enter(false);
  }

//+------------------------------------------------------------------+
//| Nuova barra sul timeframe operativo                              |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, InpTimeframe, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| Calcola le candele Heiken Ashi (series-indexed)                  |
//+------------------------------------------------------------------+
bool GetHA(int count, double &haO[], double &haC[], double &haH[], double &haL[])
  {
   int need = count + 60;
   MqlRates r[]; ArraySetAsSeries(r,true);
   int copied = CopyRates(_Symbol, InpTimeframe, 0, need, r);
   if(copied < count+2) return(false);

   ArrayResize(haO,copied); ArrayResize(haC,copied); ArrayResize(haH,copied); ArrayResize(haL,copied);
   ArraySetAsSeries(haO,true); ArraySetAsSeries(haC,true); ArraySetAsSeries(haH,true); ArraySetAsSeries(haL,true);

   for(int i=copied-1; i>=0; i--)
     {
      double o=r[i].open, h=r[i].high, l=r[i].low, c=r[i].close;
      double hc=(o+h+l+c)/4.0;
      double ho = (i==copied-1) ? (o+c)/2.0 : (haO[i+1]+haC[i+1])/2.0;
      haO[i]=ho; haC[i]=hc;
      haH[i]=MathMax(h, MathMax(ho,hc));
      haL[i]=MathMin(l, MathMin(ho,hc));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Le ultime InpHACount candele HA confermano il momentum?          |
//+------------------------------------------------------------------+
bool HAConfirms(bool isLong)
  {
   double hO[],hC[],hH[],hL[];
   if(!GetHA(InpHACount+2, hO,hC,hH,hL)) return(false);

   double bodyRecent=0, bodyOldest=0;
   for(int k=1; k<=InpHACount; k++)
     {
      double body = isLong ? (hC[k]-hO[k]) : (hO[k]-hC[k]);
      if(body<=0) return(false);                              // deve essere nella direzione giusta
      double wick = isLong ? (hO[k]-hL[k]) : (hH[k]-hO[k]);   // ombra contraria
      if(wick > InpHAWickRatio*body) return(false);           // ombra contraria troppo grande
      if(k==1) bodyRecent=body;
      if(k==InpHACount) bodyOldest=body;
     }
   // il corpo non deve collassare (recente >= fattore * iniziale)
   if(bodyOldest>0 && bodyRecent < InpHABodyFactor*bodyOldest) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| Il colore HA dell'ultima candela chiusa                          |
//+------------------------------------------------------------------+
int HAColor()
  {
   double hO[],hC[],hH[],hL[];
   if(!GetHA(4,hO,hC,hH,hL)) return(0);
   if(hC[1]>hO[1]) return(+1);
   if(hC[1]<hO[1]) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Segnale d'ingresso: +1 long, -1 short, 0 niente (barra chiusa=1) |
//+------------------------------------------------------------------+
int Signal()
  {
   int nEma = MathMax(InpCrossLookback, InpEmaSlopeBars) + 2;
   double ef[], em[], es[], adx[], dip[], dim[], atr[];
   ArraySetAsSeries(ef,true); ArraySetAsSeries(em,true); ArraySetAsSeries(es,true);
   ArraySetAsSeries(adx,true); ArraySetAsSeries(dip,true); ArraySetAsSeries(dim,true); ArraySetAsSeries(atr,true);
   if(CopyBuffer(hEmaF,0,1,nEma,ef)<nEma) return(0);
   if(CopyBuffer(hEmaM,0,1,nEma,em)<nEma) return(0);
   if(CopyBuffer(hEmaS,0,1,nEma,es)<nEma) return(0);   // indice 0 = barra 1
   if(CopyBuffer(hAdx,0,1,3,adx)<3) return(0);
   if(CopyBuffer(hAdx,1,1,3,dip)<3) return(0);
   if(CopyBuffer(hAdx,2,1,3,dim)<3) return(0);
   if(CopyBuffer(hAtr,0,1,1,atr)<1 || atr[0]<=0) return(0);

   double close1 = iClose(_Symbol, InpTimeframe, 1);
   double ema9=ef[0], ema21=em[0], ema50=es[0];

   // forza ADX comune
   bool adxOK   = (adx[0] >= InpAdxMin);
   bool adxRise = (!InpAdxRising) || (adx[0] >= adx[2]);

   //====================== LONG =======================
   {
      bool context   = close1 > ema50;
      bool slope50   = ema50 >= es[InpEmaSlopeBars];               // EMA50 non ribassista
      bool slopeFast = (ef[0] >= ef[InpEmaSlopeBars]) && (em[0] >= em[InpEmaSlopeBars]);
      bool ordered   = (!InpRequireAlignment) || (ema9>ema21 && ema21>ema50);
      bool crossNow  = (ef[0] > em[0]);
      bool crossPast = (ef[InpCrossLookback] <= em[InpCrossLookback]); // era sotto entro la finestra
      bool diOK      = (!InpRequireDI) || (dip[0] > dim[0]);
      bool dist      = (close1 - ema9) <= InpMaxDistATR*atr[0];
      if(context && slope50 && slopeFast && ordered && crossNow && crossPast &&
         adxOK && adxRise && diOK && dist && HAConfirms(true))
         return(+1);
   }
   //====================== SHORT ======================
   {
      bool context   = close1 < ema50;
      bool slope50   = ema50 <= es[InpEmaSlopeBars];
      bool slopeFast = (ef[0] <= ef[InpEmaSlopeBars]) && (em[0] <= em[InpEmaSlopeBars]);
      bool ordered   = (!InpRequireAlignment) || (ema9<ema21 && ema21<ema50);
      bool crossNow  = (ef[0] < em[0]);
      bool crossPast = (ef[InpCrossLookback] >= em[InpCrossLookback]);
      bool diOK      = (!InpRequireDI) || (dim[0] > dip[0]);
      bool dist      = (ema9 - close1) <= InpMaxDistATR*atr[0];
      if(context && slope50 && slopeFast && ordered && crossNow && crossPast &&
         adxOK && adxRise && diOK && dist && HAConfirms(false))
         return(-1);
   }
   return(0);
  }

//+------------------------------------------------------------------+
//| Apre l'operazione (mercato) o piazza il limit (pullback)         |
//+------------------------------------------------------------------+
void Enter(bool isLong)
  {
   double atr[1];
   if(CopyBuffer(hAtr,0,1,1,atr)<1 || atr[0]<=0) return;
   double em[1];
   if(CopyBuffer((InpPullbackRef==GC_REF_EMA9?hEmaF:hEmaM),0,1,1,em)<1) return;

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double buffer = EffBuffer();

   double entry = isLong ? ask : bid;
   if(InpEntryMode==GC_PULLBACK) entry = NormalizePrice(em[0]);   // limit su EMA

   //--- stop tecnico
   double sl;
   if(InpSLMode==GC_SL_SWING)
     {
      int lookIdx = isLong ? iLowest(_Symbol,InpTimeframe,MODE_LOW,InpSwingLookback,1)
                           : iHighest(_Symbol,InpTimeframe,MODE_HIGH,InpSwingLookback,1);
      if(lookIdx<0) return;
      double swing = isLong ? iLow(_Symbol,InpTimeframe,lookIdx) : iHigh(_Symbol,InpTimeframe,lookIdx);
      sl = isLong ? swing - buffer : swing + buffer;
     }
   else
      sl = isLong ? entry - atr[0]*InpAtrSLmult : entry + atr[0]*InpAtrSLmult;
   sl = NormalizePrice(sl);

   double risk = isLong ? (entry - sl) : (sl - entry);
   double minDist = MathMax(buffer, (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk < minDist) { Log("stop troppo vicino, salto."); return; }

   double tp = isLong ? entry + risk*InpTP_R : entry - risk*InpTP_R;
   tp = NormalizePrice(tp);

   // filtro R:R (con TP a R multipli e' sempre >= InpTP_R, ma teniamo il controllo)
   if(InpTP_R < InpMinRR) { Log("R:R sotto il minimo, salto."); return; }

   double lot = LotByRisk(risk);
   if(lot<=0) { Log("lotto nullo, salto."); return; }

   gPartialDone=false;
   if(InpEntryMode==GC_MARKET)
     {
      bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,"GoldenCross L")
                       : gTrade.Sell(lot,_Symbol,bid,sl,tp,"GoldenCross S");
      Log(StringFormat("%s a mercato @ %.2f SL %.2f TP %.2f lot %.2f -> %s",
          isLong?"LONG":"SHORT", entry, sl, tp, lot, ok?"OK":gTrade.ResultRetcodeDescription()));
     }
   else
     {
      datetime exp = TimeCurrent() + InpPendingExpiryBars*PeriodSeconds(InpTimeframe);
      bool ok;
      if(isLong)  ok = gTrade.BuyLimit(lot,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,"GoldenCross L pb");
      else        ok = gTrade.SellLimit(lot,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,"GoldenCross S pb");
      Log(StringFormat("%s LIMIT (pullback) @ %.2f SL %.2f TP %.2f -> %s",
          isLong?"LONG":"SHORT", entry, sl, tp, ok?"OK":gTrade.ResultRetcodeDescription()));
     }
  }

//+------------------------------------------------------------------+
//| Gestione: parziale + breakeven + trailing + uscite da segnale    |
//+------------------------------------------------------------------+
void ManageOpen()
  {
   if(!PositionSelect(_Symbol)) return;
   if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) return;

   long   type  = PositionGetInteger(POSITION_TYPE);
   bool   isLong= (type==POSITION_TYPE_BUY);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl    = PositionGetDouble(POSITION_SL);
   double tp    = PositionGetDouble(POSITION_TP);
   double vol   = PositionGetDouble(POSITION_VOLUME);
   ulong  ticket= PositionGetInteger(POSITION_TICKET);
   double bid   = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask   = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   //--- distanza di rischio iniziale (per 1R)
   double riskDist = isLong ? (openP-sl) : (sl-openP);
   if(riskDist<=0){ double atr[1]; if(CopyBuffer(hAtr,0,1,1,atr)==1) riskDist=atr[0]*InpAtrSLmult; }

   //--- 1) PARZIALE a InpPartialR
   if(!gPartialDone && InpPartialR>0 && InpPartialPct>0 && InpPartialPct<100 && riskDist>0)
     {
      double tgt = isLong ? openP+riskDist*InpPartialR : openP-riskDist*InpPartialR;
      bool hit = isLong ? (bid>=tgt) : (ask<=tgt);
      if(hit)
        {
         double cv = NormVol(vol*InpPartialPct/100.0);
         if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv))
           {
            gPartialDone=true;
            if(InpBreakeven) gTrade.PositionModify(_Symbol, NormalizePrice(openP), tp);
            Log(StringFormat("parziale %.2f lotti a %.1fR, stop in pari.", cv, InpPartialR));
           }
        }
     }

   //--- 2) USCITE da segnale (a barra chiusa)
   if(IsClosedBarExit(isLong)) { gTrade.PositionClose(_Symbol); Log("uscita da segnale (EMA/HA)."); return; }

   //--- 3) TRAILING
   if(InpTrailMode!=GC_TR_OFF)
     {
      double newSL = TrailLevel(isLong, bid, ask);
      if(newSL>0)
        {
         newSL = NormalizePrice(newSL);
         if(isLong && newSL>sl && newSL>openP) gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
         if(!isLong && (newSL<sl||sl==0) && newSL<openP) gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Livello di trailing secondo la modalita'                         |
//+------------------------------------------------------------------+
double TrailLevel(bool isLong,double bid,double ask)
  {
   if(InpTrailMode==GC_TR_EMA21)
     {
      double em[1]; if(CopyBuffer(hEmaM,0,1,1,em)<1) return(0);
      return(em[0]);   // stop sulla EMA21 (riferimento dinamico)
     }
   double atr[1]; if(CopyBuffer(hAtr,0,1,1,atr)<1) return(0);
   return(isLong ? bid-atr[0]*InpTrailAtrMult : ask+atr[0]*InpTrailAtrMult);
  }

//+------------------------------------------------------------------+
//| Condizione di uscita a barra chiusa (incrocio inverso / HA flip) |
//+------------------------------------------------------------------+
bool IsClosedBarExit(bool isLong)
  {
   double ef[1],em[1];
   if(CopyBuffer(hEmaF,0,1,1,ef)<1 || CopyBuffer(hEmaM,0,1,1,em)<1) return(false);
   if(InpExitOnCross)
     {
      if(isLong  && ef[0] < em[0]) return(true);
      if(!isLong && ef[0] > em[0]) return(true);
     }
   if(InpExitOnHAflip)
     {
      int c=HAColor();
      if(isLong  && c<0) return(true);
      if(!isLong && c>0) return(true);
     }
   return(false);
  }

//==================================================================
//  UTILITY: prezzo, lotto, volume, spread, buffer
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double EffBuffer()
  {
   double stops=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   return(MathMax(InpSLBufferPts,stops)*_Point);
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(tv<=0||tsz<=0) return(0);
   double lossPerLot=(slDist/tsz)*tv;
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

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

bool HasOpenPos()
  {
   if(!PositionSelect(_Symbol)) return(false);
   return(PositionGetInteger(POSITION_MAGIC)==InpMagic);
  }

bool HasPending()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Trade aperti e perdite consecutive di OGGI (per i limiti giornal.)|
//+------------------------------------------------------------------+
void TodayStats(int &trades,int &consecLosses)
  {
   trades=0; consecLosses=0;
   MqlDateTime d; TimeToStruct(TimeCurrent(),d); d.hour=0; d.min=0; d.sec=0;
   datetime dayStart=StructToTime(d);
   if(!HistorySelect(dayStart,TimeCurrent())) return;
   int total=HistoryDealsTotal();
   for(int i=0;i<total;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetString(tk,DEAL_SYMBOL)!=_Symbol) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry==DEAL_ENTRY_IN) trades++;                         // n. ingressi = trade del giorno
      if(entry==DEAL_ENTRY_OUT)
        {
         double p=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
         if(p<0) consecLosses++; else consecLosses=0;
        }
     }
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro news di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h) && StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h) && !FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d eventi.",gNewsCount));
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

double OnTester()
  {
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
