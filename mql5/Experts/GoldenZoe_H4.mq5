//+------------------------------------------------------------------+
//|                                              GoldenZoe_H4.mq5    |
//|  v1.00 (19/11/2026) - TREND FOLLOWING sull'ORO, candele H4.       |
//|  Strategia (backtest_runner/simulatore/tre_leve.py, leva 3a):     |
//|   - INGRESSO: la candela H4 chiusa (shift 1) CHIUDE sopra il      |
//|     massimo delle 55 candele precedenti (shift 2..56) -> BUY a    |
//|     mercato all'apertura della candela successiva. Opzionale la   |
//|     VENDITA simmetrica (default: spenta; il test non le da' edge).|
//|   - STOP INIZIALE: 3 x ATR(14) della candela del segnale.         |
//|   - STOP MOBILE (Chandelier): a ogni nuova candela lo stop sale   |
//|     a (massimo dall'ingresso - 3 x ATR); non scende mai.          |
//|   - USCITA: solo lo stop. Nessun target. Una posizione alla volta.|
//|   - Dopo una uscita sulla barra, si aspetta il segnale successivo |
//|     (come nel simulatore).                                         |
//|  Rischio: InpRiskPercent dell'equity sulla distanza dello stop    |
//|  (la scelta del rischio reale e' di Claudio).                      |
//|  Solo tester/demo. Nessun filtro orario/notizie/spread.            |
//|  NOTA: iATR di MT5 e' la media semplice del True Range (il        |
//|  simulatore Python usava la media di Wilder): differenza piccola.  |
//+------------------------------------------------------------------+
#property copyright "Claudio - GoldenZoe (strategia propria)"
#property version   "1.00"
#property strict
#include <Trade/Trade.mqh>

input ENUM_TIMEFRAMES InpTF          = PERIOD_H4;
input int    InpDonchianN            = 55;     // candele precedenti per il massimo/minimo
input int    InpAtrPeriod            = 14;
input double InpStopAtr              = 3.0;    // stop iniziale = N x ATR
input double InpTrailAtr             = 3.0;    // stop mobile = estremo dall'ingresso -/+ N x ATR
input bool   InpAllowLong            = true;
input bool   InpAllowShort           = false;  // il test non trova edge sulle vendite
input double InpRiskPercent          = 1.0;    // % equity rischiata sullo stop iniziale
input long   InpMagic                = 972301;
input string InpComment              = "GOLDENZOE H4";
input bool   InpVerbose              = false;

CTrade gTrade;
int    hAtr = INVALID_HANDLE;
datetime gLastBar = 0;
datetime gLastHadPos = 0;

void Log(const string s){ if(InpVerbose) Print("[GoldenZoe] ",s); }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(50);
   hAtr = iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hAtr==INVALID_HANDLE) return INIT_FAILED;
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason){ if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr); }

bool SelectMyPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return true;   // posizione selezionata
     }
   return false;
  }

double CalcLot(const double slDist)
  {
   double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE), ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(tv<=0 || ts<=0 || slDist<=0) return 0.0;
   double risk=AccountInfoDouble(ACCOUNT_EQUITY)*InpRiskPercent/100.0;
   double lot=risk/((slDist/ts)*tv);
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP), mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN), mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(step<=0) step=0.01;
   lot=MathFloor(lot/step)*step;
   if(lot<mn) lot=mn;
   if(lot>mx) lot=mx;
   return NormalizeDouble(lot,2);
  }

void OpenTrade(const bool isLong,const double atr)
  {
   double price = isLong ? SymbolInfoDouble(_Symbol,SYMBOL_ASK) : SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double sl    = isLong ? price-InpStopAtr*atr : price+InpStopAtr*atr;
   sl = NormalizeDouble(sl,_Digits);
   double lot = CalcLot(MathAbs(price-sl));
   if(lot<=0){ Log("lotto non valido"); return; }
   bool ok = isLong ? gTrade.Buy(lot,_Symbol,0,sl,0,InpComment) : gTrade.Sell(lot,_Symbol,0,sl,0,InpComment);
   Log(StringFormat("%s lot=%.2f price=%.2f sl=%.2f atr=%.2f ok=%d",isLong?"BUY":"SELL",lot,price,sl,atr,ok));
  }

void ManageTrail(const double atr)
  {
   long type = PositionGetInteger(POSITION_TYPE);
   datetime to = (datetime)PositionGetInteger(POSITION_TIME);
   double ent = PositionGetDouble(POSITION_PRICE_OPEN);
   double cur = PositionGetDouble(POSITION_SL);
   int sOpen = iBarShift(_Symbol,InpTF,to,false);       // shift della candela dell'ingresso
   if(sOpen<1) return;
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(type==POSITION_TYPE_BUY)
     {
      int ih=iHighest(_Symbol,InpTF,MODE_HIGH,sOpen,1);   // candele da shift 1 a sOpen
      if(ih<0) return;
      double ext=MathMax(ent,iHigh(_Symbol,InpTF,ih));
      double ns=NormalizeDouble(ext-InpTrailAtr*atr,_Digits);
      if(ns>cur+_Point && ns<=bid-minDist)
        { if(gTrade.PositionModify(_Symbol,ns,0)) Log(StringFormat("trail BUY sl %.2f -> %.2f",cur,ns)); }
     }
   else if(type==POSITION_TYPE_SELL)
     {
      int il=iLowest(_Symbol,InpTF,MODE_LOW,sOpen,1);
      if(il<0) return;
      double ext=MathMin(ent,iLow(_Symbol,InpTF,il));
      double ns=NormalizeDouble(ext+InpTrailAtr*atr,_Digits);
      if((cur<=0.0 || ns<cur-_Point) && ns>=ask+minDist)
        { if(gTrade.PositionModify(_Symbol,ns,0)) Log(StringFormat("trail SELL sl %.2f -> %.2f",cur,ns)); }
     }
  }

void OnTick()
  {
   datetime t0=iTime(_Symbol,InpTF,0);
   if(SelectMyPosition()) gLastHadPos=t0;            // c'e' una posizione in questa candela
   if(t0==gLastBar) return;                           // lavoro solo alla nuova candela
   gLastBar=t0;
   if(Bars(_Symbol,InpTF)<InpDonchianN+InpAtrPeriod+10) return;
   double a[]; ArraySetAsSeries(a,true);
   if(CopyBuffer(hAtr,0,1,1,a)<1) return;
   double atr=a[0]; if(atr<=0) return;
   if(SelectMyPosition()){ ManageTrail(atr); return; }
   if(gLastHadPos>=iTime(_Symbol,InpTF,1)) return;    // posizione chiusa durante la candela appena finita: aspetto
   double c1=iClose(_Symbol,InpTF,1);
   int ih=iHighest(_Symbol,InpTF,MODE_HIGH,InpDonchianN,2);
   int il=iLowest (_Symbol,InpTF,MODE_LOW ,InpDonchianN,2);
   if(ih<0 || il<0) return;
   if(InpAllowLong  && c1>iHigh(_Symbol,InpTF,ih)) { OpenTrade(true ,atr); return; }
   if(InpAllowShort && c1<iLow (_Symbol,InpTF,il)) { OpenTrade(false,atr); return; }
  }
