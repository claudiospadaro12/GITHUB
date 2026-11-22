//+------------------------------------------------------------------+
//|                                                  DowRaptor.mq5   |
//|  v1.00 (22/11/2026) - EA NOSTRO sul Dow, scritto da zero.        |
//|  NON COMPILATA da agenti (compilare in MetaEditor con F7).       |
//|  Idea: BREAKOUT DI VOLATILITA su M15.                            |
//|   - SEGNALE alla chiusura della candela M15 (shift 1):           |
//|       LONG  se chiude sopra il massimo delle N candele          |
//|             precedenti (shift 2..N+1); SHORT simmetrico.          |
//|       Filtro opzionale di COMPRESSIONE: ATR veloce / ATR lento    |
//|       <= InpCompressMax (0 = spento).                            |
//|   - INGRESSO a mercato all'apertura della candela successiva.    |
//|   - STOP iniziale = InpStopAtr x ATR veloce della candela del    |
//|     segnale. Opzionali: stop mobile (Chandelier InpTrailAtr),    |
//|     target (InpTpAtr), uscita a tempo (InpMaxBars candele).      |
//|   - UN SOLO ORDINE alla volta. Nessun pendente: tutti i prezzi   |
//|     sono ARROTONDATI AL PASSO DEL PREZZO (tick size) del simbolo,|
//|     cosi non ci sono "Invalid stops" sugli indici BCM (U30USD    |
//|     ha tick size 0,1).                                           |
//|  Rischio: InpRiskPercent dell'equity sulla distanza dello stop,  |
//|  lotto con OrderCalcProfit (corretto per CFD in valuta diversa). |
//|  Commento ordini: "DowRaptor Buy" / "DowRaptor Sell".            |
//|  Solo tester/demo. La scelta del rischio reale e di Claudio.     |
//+------------------------------------------------------------------+
#property copyright "Claudio - DowRaptor (strategia propria)"
#property version   "1.00"
#property strict
#include <Trade/Trade.mqh>

input ENUM_TIMEFRAMES InpTF  = PERIOD_M15;
input int    InpChannelN     = 24;     // candele precedenti per massimo/minimo
input int    InpAtrFast      = 14;
input int    InpAtrSlow      = 96;
input double InpCompressMax  = 0.0;    // 0 = filtro spento; >0: ingresso solo se ATRveloce/ATRlento <= valore
input double InpStopAtr      = 2.0;    // stop iniziale = N x ATR veloce
input double InpTrailAtr     = 0.0;    // 0 = niente stop mobile; >0 = Chandelier N x ATR
input double InpTpAtr        = 0.0;    // 0 = niente target; >0 = N x ATR
input int    InpMaxBars      = 0;      // 0 = nessuna uscita a tempo; >0 = chiude dopo N candele
input bool   InpAllowLong    = true;
input bool   InpAllowShort   = true;
input double InpRiskPercent  = 0.25;   // % equity rischiata sullo stop iniziale
input double InpMaxSpreadPts = 0.0;    // 0 = nessun filtro; >0 = niente ingressi con spread (punti) maggiore
input long   InpMagic        = 790101;
input string InpComment      = "DowRaptor"; // il codice aggiunge " Buy" o " Sell"
input bool   InpVerbose      = false;

CTrade gTrade;
int    hFast = INVALID_HANDLE, hSlow = INVALID_HANDLE;
datetime gLastBar = 0;
datetime gLastHadPos = 0;

void Log(const string s){ if(InpVerbose) Print("[DowRaptor] ",s); }

double TickSz(){ double t=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE); return (t>0 ? t : _Point); }
double Rnd(const double p){ double t=TickSz(); return NormalizeDouble(MathRound(p/t)*t,_Digits); }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(50);
   hFast = iATR(_Symbol,InpTF,InpAtrFast);
   hSlow = iATR(_Symbol,InpTF,InpAtrSlow);
   if(hFast==INVALID_HANDLE || hSlow==INVALID_HANDLE) return INIT_FAILED;
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   if(hFast!=INVALID_HANDLE) IndicatorRelease(hFast);
   if(hSlow!=INVALID_HANDLE) IndicatorRelease(hSlow);
  }

bool SelectMyPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return true;
     }
   return false;
  }

double CalcLot(const double slDist,const bool isLong)
  {
   if(slDist<=0) return 0.0;
   double risk=AccountInfoDouble(ACCOUNT_EQUITY)*InpRiskPercent/100.0;
   double px=isLong?SymbolInfoDouble(_Symbol,SYMBOL_ASK):SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double p2=isLong?px-slDist:px+slDist, prof=0.0;
   if(!OrderCalcProfit(isLong?ORDER_TYPE_BUY:ORDER_TYPE_SELL,_Symbol,1.0,px,p2,prof) || MathAbs(prof)<=0) return 0.0;
   double lot=risk/MathAbs(prof);
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP), mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN), mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(step<=0) step=0.01;
   lot=MathFloor(lot/step)*step;
   if(lot<mn) lot=mn;
   if(lot>mx) lot=mx;
   return NormalizeDouble(lot,2);
  }

void OpenTrade(const bool isLong,const double atr)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(InpMaxSpreadPts>0 && (ask-bid)/_Point>InpMaxSpreadPts){ Log("spread troppo alto: salto"); return; }
   double price = isLong ? ask : bid;
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point + (ask-bid);
   double dist = InpStopAtr*atr;
   if(dist<minDist*1.1) dist=minDist*1.1;
   double sl = Rnd(isLong ? price-dist : price+dist);
   double tp = 0.0;
   if(InpTpAtr>0)
     {
      double td=InpTpAtr*atr; if(td<minDist*1.1) td=minDist*1.1;
      tp = Rnd(isLong ? price+td : price-td);
     }
   double lot = CalcLot(MathAbs(price-sl),isLong);
   if(lot<=0){ Log("lotto non valido"); return; }
   bool ok = isLong ? gTrade.Buy(lot,_Symbol,0,sl,tp,InpComment+" Buy") : gTrade.Sell(lot,_Symbol,0,sl,tp,InpComment+" Sell");
   Log(StringFormat("%s lot=%.2f price=%.2f sl=%.2f tp=%.2f atr=%.2f ok=%d",isLong?"BUY":"SELL",lot,price,sl,tp,atr,ok));
  }

void ManagePosition(const double atr)
  {
   long type = PositionGetInteger(POSITION_TYPE);
   datetime to = (datetime)PositionGetInteger(POSITION_TIME);
   double ent = PositionGetDouble(POSITION_PRICE_OPEN);
   double cur = PositionGetDouble(POSITION_SL);
   double tpv = PositionGetDouble(POSITION_TP);
   int sOpen = iBarShift(_Symbol,InpTF,to,false);
   if(sOpen<0) return;
   if(InpMaxBars>0 && sOpen>=InpMaxBars){ gTrade.PositionClose(_Symbol); Log("uscita a tempo"); return; }
   if(InpTrailAtr<=0 || sOpen<1) return;
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double ts=TickSz();
   if(type==POSITION_TYPE_BUY)
     {
      int ih=iHighest(_Symbol,InpTF,MODE_HIGH,sOpen,1);
      if(ih<0) return;
      double ext=MathMax(ent,iHigh(_Symbol,InpTF,ih));
      double ns=Rnd(ext-InpTrailAtr*atr);
      if(ns>cur+ts*0.5 && ns<=bid-minDist) gTrade.PositionModify(_Symbol,ns,tpv);
     }
   else if(type==POSITION_TYPE_SELL)
     {
      int il=iLowest(_Symbol,InpTF,MODE_LOW,sOpen,1);
      if(il<0) return;
      double ext=MathMin(ent,iLow(_Symbol,InpTF,il));
      double ns=Rnd(ext+InpTrailAtr*atr);
      if((cur<=0.0 || ns<cur-ts*0.5) && ns>=ask+minDist) gTrade.PositionModify(_Symbol,ns,tpv);
     }
  }

void OnTick()
  {
   datetime t0=iTime(_Symbol,InpTF,0);
   if(SelectMyPosition()) gLastHadPos=t0;
   if(t0==gLastBar) return;                                   // lavoro solo alla nuova candela
   gLastBar=t0;
   if(Bars(_Symbol,InpTF)<MathMax(InpChannelN,InpAtrSlow)+10) return;
   double af[],as[]; ArraySetAsSeries(af,true); ArraySetAsSeries(as,true);
   if(CopyBuffer(hFast,0,1,1,af)<1 || CopyBuffer(hSlow,0,1,1,as)<1) return;
   double atr=af[0]; if(atr<=0 || as[0]<=0) return;
   if(SelectMyPosition()){ ManagePosition(atr); return; }
   if(gLastHadPos>=iTime(_Symbol,InpTF,1)) return;            // posizione chiusa nella candela appena finita: aspetto
   if(InpCompressMax>0 && af[0]/as[0]>InpCompressMax) return; // filtro di compressione
   double c1=iClose(_Symbol,InpTF,1);
   int ih=iHighest(_Symbol,InpTF,MODE_HIGH,InpChannelN,2);
   int il=iLowest (_Symbol,InpTF,MODE_LOW ,InpChannelN,2);
   if(ih<0 || il<0) return;
   bool sigL = InpAllowLong  && c1>iHigh(_Symbol,InpTF,ih);
   bool sigS = InpAllowShort && c1<iLow (_Symbol,InpTF,il);
   if(sigL && sigS) return;
   if(sigL) { OpenTrade(true ,atr); return; }
   if(sigS) { OpenTrade(false,atr); return; }
  }
