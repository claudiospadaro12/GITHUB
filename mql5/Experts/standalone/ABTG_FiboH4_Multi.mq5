//+------------------------------------------------------------------+
//|                                        ABTG_FiboH4_Multi.mq5      |
//|                                                                  |
//|  EA "FIBO H4 - MULTI-SIMBOLO" - MT5 - TUTTO-IN-UNO             |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Come ABTG_FiboH4 ma SCANSIONA PIU' CROSS da un solo grafico.   |
//|  Metti la lista in InpSymbols (separati da ; o ,). Su ogni      |
//|  simbolo cerca il setup engulfing + entry zone Fibo e piazza    |
//|  gli ordini se ci sono le condizioni. Gestione per-simbolo.     |
//|                                                                  |
//|  Un solo grafico -> molti cross. Magic 771602 (diverso dalla    |
//|  versione singola 771601). Tetto InpMaxTotalPositions come      |
//|  sicurezza sull'esposizione totale.                            |
//|                                                                  |
//|  NB: i simboli devono esistere sul broker (Market Watch) con    |
//|  storico H4 disponibile. Valori Fibo proprietari 1.88/2.88,     |
//|  SL 4.236, come nella versione singola. DEMO. Nessuna garanzia. |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Simboli da scansionare ==="
input string InpSymbols = "GBPUSD;USDJPY;EURUSD"; // lista cross (separati da ; o ,). Vuoto = simbolo del grafico
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;          // TF operativo (strategia: H4)
input int    InpMaxTotalPositions = 6;            // tetto posizioni aperte totali (sicurezza)

input group "=== Engulfing ==="
input int    InpEngulfLookback = 12;
input bool   InpAllowTwoCandle = true;
input double InpMinEngulfBodyPct = 25.0;
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Entry Zone (Fibo FIBO H4 - valori proprietari) ==="
input double InpEZ1ratio = 1.88;
input double InpEZ2ratio = 2.88;
input double InpSLratio  = 4.236;
input bool   InpUseEZ2   = true;

input group "=== Distanza e validita' ==="
input double InpMinDistPips = 50.0;
input int    InpAtrPeriod   = 14;
input double InpMaxEngulfAtr = 3.0;
input int    InpPendingExpiryBars = 6;

input group "=== Stop / target ==="
input double InpSLbufferPips = 3.0;
input double InpTP1_R        = 1.0;
input double InpTP1Pct       = 50;
input bool   InpBreakeven    = true;
input bool   InpUseTrailing  = true;
input double InpTrailAtrMult = 2.0;

input group "=== Rischio e size (1/3 + 2/3) ==="
input double InpRiskPercent  = 1.0;    // rischio % per simbolo (diviso tra i due ordini)
input double InpFirstFraction = 0.3333;

input group "=== Chiusura giornaliera / weekend (ORA SERVER) ==="
input bool   InpUseCutoff   = true;
input int    InpCutoffHour  = 17;
input int    InpCutoffMin   = 45;
input bool   InpFridayClose = true;
input int    InpFridayCloseHour = 21;
input int    InpFridayCloseMin  = 50;

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;

input group "=== Generali ==="
input string InpComment   = "FIBOH4";
input long   InpMagic     = 771602;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO (per-simbolo)
//==================================================================
string   gSym[];
int      gAtr[];
datetime gLastBar[];
int      gN=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[FiboH4Multi] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(30);

   string list=InpSymbols; StringReplace(list,","," "); StringReplace(list,";"," ");
   string parts[]; int k=StringSplit(list,' ',parts);
   ArrayResize(gSym,0);
   for(int i=0;i<k;i++)
     {
      string s=parts[i]; StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      int n=ArraySize(gSym); ArrayResize(gSym,n+1); gSym[n]=s;
     }
   if(ArraySize(gSym)==0){ ArrayResize(gSym,1); gSym[0]=_Symbol; }
   gN=ArraySize(gSym);

   ArrayResize(gAtr,gN); ArrayResize(gLastBar,gN);
   for(int i=0;i<gN;i++)
     {
      if(!SymbolSelect(gSym[i],true)) Log("attenzione: simbolo non selezionabile: "+gSym[i]);
      gAtr[i]=iATR(gSym[i],InpTF,InpAtrPeriod);
      gLastBar[i]=0;
      if(gAtr[i]==INVALID_HANDLE) Log("ATR non disponibile per "+gSym[i]);
     }
   gTrade.SetTypeFillingBySymbol(gSym[0]);
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %d simboli, %s. EZ %.2f/%.2f, SL %.3f.",gN,EnumToString(InpTF),InpEZ1ratio,InpEZ2ratio,InpSLratio));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   for(int i=0;i<gN;i++) if(gAtr[i]!=INVALID_HANDLE) IndicatorRelease(gAtr[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   for(int i=0;i<gN;i++)
     {
      string sym=gSym[i];
      ManageAll(sym);
      CutoffCheck(sym);
      FridayCloseCheck(sym);

      datetime t=iTime(sym,InpTF,0);
      if(t<=0 || t==gLastBar[i]) continue;
      gLastBar[i]=t;
      OnNewBar(sym,gAtr[i]);
     }
  }

//==================================================================
//  UTILITY PER-SIMBOLO
//==================================================================
double PipSize(string sym)
  {
   int d=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(sym,SYMBOL_POINT);
   return (d==3 || d==5) ? pt*10.0 : pt;
  }

double AtrVal(int atrHandle)
  {
   double a[1]; if(CopyBuffer(atrHandle,0,1,1,a)!=1) return(0); return(a[0]);
  }

double NormalizePrice(string sym,double price)
  {
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Engulfing per-simbolo
bool BullEngulf(string sym,int i,double &swingHigh,double &swingLow)
  {
   double oi=iOpen(sym,InpTF,i), ci=iClose(sym,InpTF,i);
   double hi=iHigh(sym,InpTF,i), li=iLow(sym,InpTF,i);
   double op=iOpen(sym,InpTF,i+1), cp=iClose(sym,InpTF,i+1);
   double hp=iHigh(sym,InpTF,i+1), lp=iLow(sym,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBear=(cp<op);
   bool coverFull=(hi>=hp && li<=lp && ci>oi);
   if(prevBear && coverFull && strong){ swingHigh=hp; swingLow=li; return(true); }
   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(sym,InpTF,i-1));
      double l2=MathMin(li,iLow(sym,InpTF,i-1));
      double c2=iClose(sym,InpTF,i-1);
      if(prevBear && h2>=hp && l2<=lp && c2>op){ swingHigh=hp; swingLow=l2; return(true); }
     }
   return(false);
  }

bool BearEngulf(string sym,int i,double &swingHigh,double &swingLow)
  {
   double oi=iOpen(sym,InpTF,i), ci=iClose(sym,InpTF,i);
   double hi=iHigh(sym,InpTF,i), li=iLow(sym,InpTF,i);
   double op=iOpen(sym,InpTF,i+1), cp=iClose(sym,InpTF,i+1);
   double hp=iHigh(sym,InpTF,i+1), lp=iLow(sym,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBull=(cp>op);
   bool coverFull=(hi>=hp && li<=lp && ci<oi);
   if(prevBull && coverFull && strong){ swingHigh=hi; swingLow=lp; return(true); }
   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(sym,InpTF,i-1));
      double l2=MathMin(li,iLow(sym,InpTF,i-1));
      double c2=iClose(sym,InpTF,i-1);
      if(prevBull && h2>=hp && l2<=lp && c2<op){ swingHigh=h2; swingLow=lp; return(true); }
     }
   return(false);
  }

//+------------------------------------------------------------------+
void OnNewBar(string sym,int atrHandle)
  {
   if(HasPosition(sym) || HasPending(sym)) return;
   if(CountTotalPositions() >= InpMaxTotalPositions) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK(sym)) return;

   double atr=AtrVal(atrHandle); if(atr<=0) return;

   for(int i=1;i<=InpEngulfLookback;i++)
     {
      double sh,sl;
      if(InpAllowLong && BullEngulf(sym,i,sh,sl))
        { if((sh-sl)<=InpMaxEngulfAtr*atr){ TryPlace(sym,true,sh,sl); return; } }
      if(InpAllowShort && BearEngulf(sym,i,sh,sl))
        { if((sh-sl)<=InpMaxEngulfAtr*atr){ TryPlace(sym,false,sh,sl); return; } }
     }
  }

//+------------------------------------------------------------------+
void TryPlace(string sym,bool isLong,double swingHigh,double swingLow)
  {
   double range=swingHigh-swingLow; if(range<=0) return;
   double pip=PipSize(sym);
   double bid=SymbolInfoDouble(sym,SYMBOL_BID), ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   double px=isLong?ask:bid;

   double ez1 = isLong ? swingHigh-InpEZ1ratio*range : swingLow+InpEZ1ratio*range;
   double ez2 = isLong ? swingHigh-InpEZ2ratio*range : swingLow+InpEZ2ratio*range;
   double target = isLong ? swingHigh : swingLow;
   double sl = isLong ? NormalizePrice(sym,swingHigh-InpSLratio*range-InpSLbufferPips*pip)
                      : NormalizePrice(sym,swingLow +InpSLratio*range+InpSLbufferPips*pip);

   if(MathAbs(px-ez1) < InpMinDistPips*pip) return;   // troppo vicino alla 1a zona

   int nOrders = InpUseEZ2 ? 2 : 1;
   double f1 = nOrders==2 ? InpFirstFraction : 1.0;
   PlaceLimit(sym,isLong,NormalizePrice(sym,ez1),sl,NormalizePrice(sym,target),InpRiskPercent*f1,"EZ1");
   if(InpUseEZ2) PlaceLimit(sym,isLong,NormalizePrice(sym,ez2),sl,NormalizePrice(sym,target),InpRiskPercent*(1.0-f1),"EZ2");
  }

void PlaceLimit(string sym,bool isLong,double px,double sl,double tp,double riskPct,string tag)
  {
   double risk=isLong?(px-sl):(sl-px);
   if(risk<=0) return;
   double lot=LotByRisk(sym,risk,riskPct);
   if(lot<=0){ Log("lotto nullo "+sym+" "+tag); return; }
   datetime exp=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(InpTF);
   string cm=InpComment+(isLong?" L ":" S ")+tag;
   gTrade.SetTypeFillingBySymbol(sym);
   bool ok=isLong?gTrade.BuyLimit(lot,px,sym,sl,tp,ORDER_TIME_SPECIFIED,exp,cm)
                 :gTrade.SellLimit(lot,px,sym,sl,tp,ORDER_TIME_SPECIFIED,exp,cm);
   if(ok) Log(StringFormat("%s %s LIMIT %s @ %s SL %s TP %s lot %.2f",sym,isLong?"BUY":"SELL",tag,
           DoubleToString(px,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),
           DoubleToString(sl,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),
           DoubleToString(tp,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),lot));
   else Log(sym+" ordine "+tag+" fallito: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
void ManageAll(string sym)
  {
   double bid=SymbolInfoDouble(sym,SYMBOL_BID), ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   int idx=SymIndex(sym); double atr=(idx>=0?AtrVal(gAtr[idx]):0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=sym || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      double vol=PositionGetDouble(POSITION_VOLUME);
      bool beDone = isLong ? (sl>=openP) : (sl<=openP && sl>0);
      double risk = isLong ? (openP-sl) : (sl-openP);

      if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
            double cv=NormVol(sym,vol*InpTP1Pct/100.0);
            if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
              { if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(sym,openP),tp); }
           }
        }
      if(InpUseTrailing && beDone && atr>0)
        {
         double n=isLong?NormalizePrice(sym,bid-atr*InpTrailAtrMult):NormalizePrice(sym,ask+atr*InpTrailAtrMult);
         double slNow=PositionGetDouble(POSITION_SL);
         if(isLong && n>slNow && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
         if(!isLong && (n<slNow||slNow==0) && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
void CutoffCheck(string sym)
  {
   if(!InpUseCutoff) return;
   if(HasPosition(sym)) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.hour*60+now.min < InpCutoffHour*60+InpCutoffMin) return;
   if(HasPending(sym)) CancelPendings(sym);
  }

void FridayCloseCheck(string sym)
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_week!=5) return;
   if(now.hour*60+now.min < InpFridayCloseHour*60+InpFridayCloseMin) return;
   CancelPendings(sym);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==sym && PositionGetInteger(POSITION_MAGIC)==InpMagic) gTrade.PositionClose(tk);
     }
  }

//==================================================================
//  UTILITY
//==================================================================
int SymIndex(string sym){ for(int i=0;i<gN;i++) if(gSym[i]==sym) return(i); return(-1); }

double LotByRisk(string sym,double slDist,double riskPct)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*riskPct/100.0;
   double tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   double tsz=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   if(tv<=0||tsz<=0) return(0);
   double lossPerLot=(slDist/tsz)*tv;
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(sym,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(string sym,double v)
  {
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK(string sym){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(sym,SYMBOL_SPREAD)<=InpMaxSpread); }

bool HasPosition(string sym)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==sym && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

int CountTotalPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

bool HasPending(string sym)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==sym && OrderGetInteger(ORDER_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

void CancelPendings(string sym)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=sym || OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
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
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
