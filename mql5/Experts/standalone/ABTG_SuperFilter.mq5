//+------------------------------------------------------------------+
//|                                          ABTG_SuperFilter.mq5     |
//|                                                                  |
//|  EA "SUPERFILTER" (parte meccanica) - MT5 - TUTTO-IN-UNO       |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia SUPERFILTER (ABTG). Reversal su         |
//|  iper-estensione con confluenza di segnali.                    |
//|                                                                  |
//|  ATTENZIONE - LIMITE IMPORTANTE:                               |
//|   due delle tre condizioni "sine qua non" sono INDICATORI       |
//|   PROPRIETARI non replicabili: FILTER INDICATOR e SUPPLY&DEMAND.|
//|   Questo EA automatizza SOLO la parte meccanica:              |
//|    - IPER-ESTENSIONE = prezzo fuori dalle Bollinger (37, dev 3);|
//|    - conferma W%R (140) in uscita da ipercomp/ipervenduto;    |
//|    - opz. prezzo fuori dal box asiatico;                      |
//|    - SL = ATR x moltiplicatore (per TF); ordini scale-in a    |
//|      0,5 ATR; TP = ATR, parziale 50% + pari, trailing.        |
//|   Usalo INSIEME alla dashboard SUPERFILTER (che mostra Filter  |
//|   Indicator e S&D), non come sostituto.                        |
//|  DEMO. Nessuna garanzia di profitto.                          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF operativo

input group "=== Iper-estensione (Bollinger) ==="
input int    InpBBPeriod = 37;   // Bollinger periodo (strategia: 37)
input double InpBBDev    = 3.0;  // deviazione (strategia: 3)
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Conferma W%R (140) ==="
input bool   InpUseWPR    = true;
input int    InpWPRperiod = 140;
input double InpWPR_OB    = -20.0; // ipercomprato
input double InpWPR_OS    = -80.0; // ipervenduto

input group "=== Filtro box asiatico (opzionale) ==="
input bool   InpUseAsiaBox = false; // opera solo se il prezzo e' FUORI dal box asiatico
input int    InpAsiaStartHour = 1;  // 00:00 UTC ~ 01:00 server (BCM). Regola se serve
input int    InpAsiaEndHour   = 9;  // 08:00 UTC ~ 09:00 server

input group "=== Stop / target (ATR) ==="
input int    InpAtrPeriod   = 14;
input double InpSLmult      = 2.0; // SL = ATR x n (tabella: M15 2-2.5, H1 2, H4 1.5-2, D1 1-1.5)
input double InpTPmult      = 1.0; // TP = ATR x questo -> parziale
input double InpTP1Pct      = 50;
input bool   InpBreakeven   = true;
input bool   InpUseTrailing = true;
input double InpTrailAtrMult = 2.0;

input group "=== Scale-in (ordini pendenti a 0,5 ATR) ==="
input int    InpScaleInOrders = 1;   // ordini limite aggiuntivi oltre il market (0 = solo market)
input double InpScaleStepAtr   = 0.5;// passo tra gli ordini in ATR (strategia: 50% ATR)

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;  // rischio % TOTALE (diviso tra market + scale-in)
input int    InpMaxTradesPerDay = 0;
input int    InpMaxPositions = 3;

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 30;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "SUPERFILTER";
input long   InpMagic     = 771801;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hBB=INVALID_HANDLE, hWpr=INVALID_HANDLE, hAtr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[SuperFilter] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hBB =iBands(_Symbol,InpTF,InpBBPeriod,0,InpBBDev,PRICE_CLOSE);
   hWpr=iWPR(_Symbol,InpTF,InpWPRperiod);
   hAtr=iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hBB==INVALID_HANDLE||hWpr==INVALID_HANDLE||hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. Bollinger(%d,%.1f), W%%R(%d). NB: Filter Indicator e S&D NON inclusi (proprietari).",
       _Symbol,EnumToString(InpTF),InpBBPeriod,InpBBDev,InpWPRperiod));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[3]={hBB,hWpr,hAtr};
   for(int i=0;i<3;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageAll();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0); return(a[0]); }

bool WprOK(bool isLong)
  {
   if(!InpUseWPR) return(true);
   double w[2]; ArraySetAsSeries(w,true);
   if(CopyBuffer(hWpr,0,1,2,w)!=2) return(true);
   // long: W%R esce dall'ipervenduto (da <=-80 a >-80); short: esce dall'ipercomprato
   if(isLong)  return(w[1]<=InpWPR_OS && w[0]>InpWPR_OS);
   return(w[1]>=InpWPR_OB && w[0]<InpWPR_OB);
  }

bool OutsideAsiaBox(double close1)
  {
   if(!InpUseAsiaBox) return(true);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpAsiaEndHour;   t.min=0; datetime tEnd=StructToTime(t);
   t.hour=InpAsiaStartHour; t.min=0; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;
   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(true);
   int start=MathMin(iS,iE), count=MathAbs(iS-iE)+1;
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(true);
   double bh=iHigh(_Symbol,PERIOD_M1,hIdx), bl=iLow(_Symbol,PERIOD_M1,lIdx);
   return(close1>bh || close1<bl);
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double up[1],lo[1];
   if(CopyBuffer(hBB,1,1,1,up)!=1) return;   // banda superiore
   if(CopyBuffer(hBB,2,1,1,lo)!=1) return;   // banda inferiore
   double close1=iClose(_Symbol,InpTF,1);
   double atr=AtrVal(); if(atr<=0) return;

   bool overShort = (close1>up[0]);   // sopra la banda -> reversal SHORT
   bool overLong  = (close1<lo[0]);   // sotto la banda -> reversal LONG

   if(overLong && InpAllowLong && WprOK(true)  && OutsideAsiaBox(close1)) { Enter(true,atr);  return; }
   if(overShort && InpAllowShort && WprOK(false) && OutsideAsiaBox(close1)){ Enter(false,atr); return; }
  }

//+------------------------------------------------------------------+
void Enter(bool isLong,double atr)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double slDist=atr*InpSLmult;
   double sl=NormalizePrice(isLong?entry-slDist:entry+slDist);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(slDist<=minDist){ Log("SL troppo vicino: skip."); return; }
   double tp=NormalizePrice(isLong?entry+atr*InpTPmult:entry-atr*InpTPmult);

   int nOrders=1+MathMax(0,InpScaleInOrders);
   double riskEach=InpRiskPercent/nOrders;

   // ordine a mercato
   double lot=LotByRisk(slDist,riskEach);
   if(lot>0)
     {
      string cm=InpComment+(isLong?" L":" S");
      bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,tp,cm):gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
      if(ok){ gTradesToday++; Log(StringFormat("%s market @ %s SL %s TP %s lot %.2f",isLong?"LONG":"SHORT",
              DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
      else Log("market fallito: "+gTrade.ResultRetcodeDescription());
     }

   // ordini scale-in a 0,5 ATR piu' profondi (ultimo non oltre lo SL)
   for(int k=1;k<=InpScaleInOrders;k++)
     {
      double step=k*InpScaleStepAtr*atr;
      if(step>=slDist) break;                       // non oltre lo SL
      double px=NormalizePrice(isLong?entry-step:entry+step);
      double slk=sl, tpk=NormalizePrice(isLong?px+atr*InpTPmult:px-atr*InpTPmult);
      double riskk=isLong?(px-slk):(slk-px);
      double lotk=LotByRisk(riskk,riskEach);
      if(lotk<=0) continue;
      datetime exp=TimeCurrent()+PeriodSeconds(InpTF)*8;
      string cmk=InpComment+(isLong?" L":" S")+IntegerToString(k);
      bool okk=isLong?gTrade.BuyLimit(lotk,px,_Symbol,slk,tpk,ORDER_TIME_SPECIFIED,exp,cmk)
                     :gTrade.SellLimit(lotk,px,_Symbol,slk,tpk,ORDER_TIME_SPECIFIED,exp,cmk);
      if(okk) Log(StringFormat("scale-in %d %s LIMIT @ %s lot %.2f",k,isLong?"BUY":"SELL",DoubleToString(px,_Digits),lotk));
     }
  }

//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double a[1]; double atr=(CopyBuffer(hAtr,0,1,1,a)==1?a[0]:0);

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
      double risk = isLong ? (openP-sl) : (sl-openP);

      if(!beDone && risk>0)
        {
         // 1o target: TP gia' impostato sull'ordine; qui parzializzo a TP e porto in pari
         double tgt=isLong?openP+atr*InpTPmult:openP-atr*InpTPmult;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit && InpTP1Pct>0 && InpTP1Pct<100)
           {
            double cv=NormVol(vol*InpTP1Pct/100.0);
            if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
              { if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
                Log("target ATR: parziale + stop in pari."); }
           }
        }

      if(InpUseTrailing && beDone && atr>0)
        {
         double n=isLong?NormalizePrice(bid-atr*InpTrailAtrMult):NormalizePrice(ask+atr*InpTrailAtrMult);
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

double LotByRisk(double slDist,double riskPct)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*riskPct/100.0;
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
