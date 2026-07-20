//+------------------------------------------------------------------+
//|                                              ABTG_DAX_M3.mq5      |
//|                                                                  |
//|  EA "DAX M3 T-TREND" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO      |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Automatizza lo SCHELETRO MECCANICO della Strategia DAX M3:     |
//|   - BIAS (direzione) dal Supertrend(3.5) su H4, filtrato da     |
//|     EMA200 H4 e ADX H4 (>=25 valido). H4 non direzionale = NO.  |
//|   - TRIGGER: rottura confermata del Supertrend(3.5) su M3 nella |
//|     direzione del bias, SOLO dopo le 09:30 CET.                 |
//|   - Ingresso a MERCATO alla chiusura della candela M3 di rottura|
//|   - SL sulla linea Supertrend M3 (o ATR/fisso); TP ~20 punti +  |
//|     trailing sul Supertrend M3; uscita se il Supertrend M3 gira.|
//|   - Intraday: chiude/ferma nuovi ingressi a fine finestra.      |
//|                                                                  |
//|  ⚠️ NON automatizzato (richiede occhio umano, come da guida):    |
//|     Wyckoff, VWAP/POC, Supply&Demand, "qualita' del movimento". |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti. DEMO.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

enum ENUM_M3_SL    { M3SL_SUPERTREND=0, M3SL_ATR=1, M3SL_FIXED=2 };
enum ENUM_M3_ENTRY { M3E_ROTTURA=0, M3E_CONTINUAZIONE=1, M3E_ENTRAMBE=2 };

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe e Supertrend ==="
input ENUM_TIMEFRAMES InpBiasTF    = PERIOD_H4;  // TF del BIAS (guida: H4)
input ENUM_TIMEFRAMES InpTriggerTF = PERIOD_M3;  // TF del TRIGGER (guida: M3)
input double InpStMult    = 3.5;                 // Moltiplicatore Supertrend (guida: 3.5)
input int    InpStAtrPeriod = 10;                // Periodo ATR del Supertrend

input group "=== Filtri del bias (H4) ==="
input bool   InpUseEMA200 = true;                // Filtro EMA200 sul TF del bias
input int    InpEmaPeriod = 200;
input bool   InpUseADX    = true;                // Filtro ADX sul TF del bias
input int    InpAdxPeriod = 14;
input double InpAdxMin     = 25.0;               // ADX minimo (guida: 25 valido, <20 debole)

input group "=== Orari operativi (ORA SERVER!) ==="
input int    InpStartHour = 8;                   // Inizio ingressi (server). BCM: 8:30 = 09:30 CET
input int    InpStartMin  = 30;
input int    InpEndHour   = 17;                  // Stop NUOVI ingressi (server)
input int    InpEndMin    = 0;
input int    InpCloseHour = 17;                  // Flat intraday (server). BCM: 17:30 = 18:30 CET
input int    InpCloseMin  = 30;
input bool   InpCloseAtEnd = true;               // Chiudi posizioni residue a fine finestra
input int    InpMaxTradesPerDay = 0;             // Max trade al giorno (0 = illimitato)

input group "=== Ingresso ==="
input ENUM_M3_ENTRY InpEntryMode = M3E_ENTRAMBE;  // Rottura, Continuazione (ritracciamento) o entrambe
input int    InpContEmaPeriod = 50;               // (continuazione) EMA M3 del ritracciamento
input bool   InpUseEmaCross = false;              // Filtro robustezza: EMA veloce vs lenta allineate al bias
input int    InpEmaFastP   = 14;                  // EMA veloce (filtro cross)
input int    InpEmaSlowP   = 50;                  // EMA lenta (filtro cross)
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Stop, target, gestione ==="
input ENUM_M3_SL InpSLMode = M3SL_SUPERTREND;    // SL su Supertrend M3 / ATR / punti fissi
input double InpSLBufferPts = 0;                 // Buffer extra sullo stop, in punti (0 = min broker)
input double InpAtrSLmult   = 1.5;               // (ATR) stop = X * ATR M3
input double InpSLFixedPts   = 1500;             // (FIXED) stop in punti (DAX BCM: 1500 = 15 punti indice)
input double InpTPPoints     = 2000;             // 1o target in punti (DAX BCM: 2000 = 20 punti indice; 0=off)
input double InpTP1Pct       = 50;               // % chiusa al 1o target
input double InpTP2Points    = 0;                // 2o target in punti (trend: es. 20000 = 200 punti; 0=off)
input double InpTP2Pct       = 50;               // % (del residuo) chiusa al 2o target
input bool   InpBreakeven    = true;             // Stop in pari dopo la parziale
input bool   InpTrailOnST    = true;             // Trailing dello stop sulla linea Supertrend M3
input bool   InpExitOnFlip   = true;             // Esci se il Supertrend M3 gira contro

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;              // Rischio per trade in %

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies= "EUR,USD";

input group "=== Generali ==="
input long   InpMagic     = 770501;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int      hAtrBias=INVALID_HANDLE, hAtrTrig=INVALID_HANDLE, hEmaBias=INVALID_HANDLE, hAdxBias=INVALID_HANDLE;
int      hEmaCont=INVALID_HANDLE, hEmaFast=INVALID_HANDLE, hEmaSlow=INVALID_HANDLE;
datetime gLastM3=0;
int      gDay=-1, gTradesToday=0;
bool     gPart1=false, gPart2=false;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[DAX_M3] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtrBias=iATR(_Symbol,InpBiasTF,InpStAtrPeriod);
   hAtrTrig=iATR(_Symbol,InpTriggerTF,InpStAtrPeriod);
   hEmaBias=iMA(_Symbol,InpBiasTF,InpEmaPeriod,0,MODE_EMA,PRICE_CLOSE);
   hAdxBias=iADX(_Symbol,InpBiasTF,InpAdxPeriod);
   hEmaCont=iMA(_Symbol,InpTriggerTF,InpContEmaPeriod,0,MODE_EMA,PRICE_CLOSE);
   hEmaFast=iMA(_Symbol,InpTriggerTF,InpEmaFastP,0,MODE_EMA,PRICE_CLOSE);
   hEmaSlow=iMA(_Symbol,InpTriggerTF,InpEmaSlowP,0,MODE_EMA,PRICE_CLOSE);
   if(hAtrBias==INVALID_HANDLE||hAtrTrig==INVALID_HANDLE||hEmaBias==INVALID_HANDLE||hAdxBias==INVALID_HANDLE||
      hEmaCont==INVALID_HANDLE||hEmaFast==INVALID_HANDLE||hEmaSlow==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. Bias %s, trigger %s, ST mult %.1f. Ingressi dopo %02d:%02d (server).",
       _Symbol,EnumToString(InpBiasTF),EnumToString(InpTriggerTF),InpStMult,InpStartHour,InpStartMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtrBias!=INVALID_HANDLE) IndicatorRelease(hAtrBias);
   if(hAtrTrig!=INVALID_HANDLE) IndicatorRelease(hAtrTrig);
   if(hEmaBias!=INVALID_HANDLE) IndicatorRelease(hEmaBias);
   if(hAdxBias!=INVALID_HANDLE) IndicatorRelease(hAdxBias);
   if(hEmaCont!=INVALID_HANDLE) IndicatorRelease(hEmaCont);
   if(hEmaFast!=INVALID_HANDLE) IndicatorRelease(hEmaFast);
   if(hEmaSlow!=INVALID_HANDLE) IndicatorRelease(hEmaSlow);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageTP1();                                  // parziale/breakeven ad ogni tick

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   int nowMin=now.hour*60+now.min;
   if(nowMin>=InpCloseHour*60+InpCloseMin){ FlatAll(); return; }

   datetime t=iTime(_Symbol,InpTriggerTF,0);
   if(t==gLastM3) return;                        // il resto solo a nuova barra M3
   gLastM3=t;
   OnNewM3Bar(nowMin);
  }

//+------------------------------------------------------------------+
//| Logica a nuova candela M3: uscita-flip, trailing, ingresso       |
//+------------------------------------------------------------------+
void OnNewM3Bar(int nowMin)
  {
   double d3[],l3[];
   bool okM3=SupertrendSeries(InpTriggerTF,hAtrTrig,InpStMult,4,d3,l3);

   //--- gestione posizione aperta
   if(SelPos())
     {
      long type=PositionGetInteger(POSITION_TYPE);
      bool isLong=(type==POSITION_TYPE_BUY);
      if(okM3)
        {
         int dirNow=(int)d3[1];
         if(InpExitOnFlip && ((isLong && dirNow<0)||(!isLong && dirNow>0)))
           { gTrade.PositionClose(_Symbol); Log("Supertrend M3 girato: uscita."); return; }
         if(InpTrailOnST) TrailToST(isLong,l3[1]);
        }
      return;
     }

   //--- niente posizione: valuto un nuovo ingresso
   if(nowMin < InpStartHour*60+InpStartMin) return;            // solo dopo le 09:30
   if(nowMin >= InpEndHour*60+InpEndMin) return;               // stop nuovi ingressi
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK() || !okM3) return;

   int bias=Bias();
   if(bias==0) return;
   if(InpUseEmaCross && !EmaCrossOK(bias)) return;

   int dir1=(int)d3[1], dir2=(int)d3[2];
   bool doRottura = (InpEntryMode==M3E_ROTTURA || InpEntryMode==M3E_ENTRAMBE);
   bool doContin  = (InpEntryMode==M3E_CONTINUAZIONE || InpEntryMode==M3E_ENTRAMBE);

   //--- ROTTURA: il Supertrend M3 e' appena girato nella direzione del bias
   if(doRottura)
     {
      if(bias>0 && dir1>0 && dir2<0 && InpAllowLong) { Enter(true,  l3[1]); return; }
      if(bias<0 && dir1<0 && dir2>0 && InpAllowShort){ Enter(false, l3[1]); return; }
     }

   //--- CONTINUAZIONE: Supertrend gia' allineato + ritracciamento sull'EMA e ripartenza
   if(doContin && dir1==bias && ContPullback(bias))
     {
      if(bias>0 && InpAllowLong)  Enter(true,  l3[1]);
      if(bias<0 && InpAllowShort) Enter(false, l3[1]);
     }
  }

//+------------------------------------------------------------------+
//| Continuazione: la candela M3 ha ritracciato sull'EMA e riparte   |
//+------------------------------------------------------------------+
bool ContPullback(int bias)
  {
   double e[1];
   if(CopyBuffer(hEmaCont,0,1,1,e)!=1) return(false);
   double o=iOpen(_Symbol,InpTriggerTF,1), c=iClose(_Symbol,InpTriggerTF,1);
   double h=iHigh(_Symbol,InpTriggerTF,1), l=iLow(_Symbol,InpTriggerTF,1);
   if(bias>0) return(l<=e[0] && c>e[0] && c>o);   // ha toccato l'EMA dal basso e richiude sopra
   return(h>=e[0] && c<e[0] && c<o);              // ha toccato l'EMA dall'alto e richiude sotto
  }

//+------------------------------------------------------------------+
//| Filtro robustezza: EMA veloce vs lenta allineate al bias         |
//+------------------------------------------------------------------+
bool EmaCrossOK(int bias)
  {
   double f[1],s[1];
   if(CopyBuffer(hEmaFast,0,1,1,f)!=1 || CopyBuffer(hEmaSlow,0,1,1,s)!=1) return(true);
   if(bias>0) return(f[0]>s[0]);
   return(f[0]<s[0]);
  }

//+------------------------------------------------------------------+
//| BIAS da H4: Supertrend + EMA200 + ADX. 0 = NEUTRO (niente trade) |
//+------------------------------------------------------------------+
int Bias()
  {
   double d[],l[];
   if(!SupertrendSeries(InpBiasTF,hAtrBias,InpStMult,3,d,l)) return(0);
   int stDir=(int)d[1];
   double close1=iClose(_Symbol,InpBiasTF,1);

   if(InpUseADX)
     { double a[1]; if(CopyBuffer(hAdxBias,0,1,1,a)==1 && a[0]<InpAdxMin) return(0); }

   bool longOK=true, shortOK=true;
   if(InpUseEMA200)
     { double e[1]; if(CopyBuffer(hEmaBias,0,1,1,e)==1){ longOK=close1>e[0]; shortOK=close1<e[0]; } }

   if(stDir>0 && longOK)  return(+1);
   if(stDir<0 && shortOK) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Apertura a mercato in direzione del bias                         |
//+------------------------------------------------------------------+
void Enter(bool isLong,double stLine)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double buf=EffBuffer();

   double sl;
   if(InpSLMode==M3SL_SUPERTREND) sl=isLong?stLine-buf:stLine+buf;
   else if(InpSLMode==M3SL_FIXED) sl=isLong?entry-InpSLFixedPts*_Point:entry+InpSLFixedPts*_Point;
   else { double a=AtrTrig(); sl=isLong?entry-a*InpAtrSLmult:entry+a*InpAtrSLmult; }
   sl=NormalizePrice(sl);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=MathMax(buf,(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk<minDist)
     { double a=AtrTrig(); risk=a*InpAtrSLmult; sl=NormalizePrice(isLong?entry-risk:entry+risk); if(risk<minDist){ Log("stop non valido, salto."); return; } }

   double lot=LotByRisk(risk);
   if(lot<=0){ Log("lotto nullo."); return; }

   gPart1=false; gPart2=false;
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,0,"DAX M3 L")
                 :gTrade.Sell(lot,_Symbol,bid,sl,0,"DAX M3 S");
   if(ok){ gTradesToday++; Log(StringFormat("%s @ %.2f SL %.2f lot %.2f (rottura M3)",isLong?"LONG":"SHORT",entry,sl,lot)); }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Parziale al 1o target (in punti) + stop in pari (ad ogni tick)   |
//+------------------------------------------------------------------+
void ManageTP1()
  {
   if(!SelPos()) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   //--- 1o target
   if(!gPart1 && InpTPPoints>0 && InpTP1Pct>0 && InpTP1Pct<100)
     {
      double tgt=isLong?openP+InpTPPoints*_Point:openP-InpTPPoints*_Point;
      bool hit=isLong?(bid>=tgt):(ask<=tgt);
      if(hit)
        {
         double cv=NormVol(vol*InpTP1Pct/100.0);
         if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv))
           { gPart1=true; if(InpBreakeven) gTrade.PositionModify(_Symbol,NormalizePrice(openP),PositionGetDouble(POSITION_TP));
             Log("1o target: parziale + stop in pari."); }
        }
     }
   //--- 2o target (trend, es. ~200 punti)
   else if(gPart1 && !gPart2 && InpTP2Points>0 && InpTP2Pct>0 && InpTP2Pct<100)
     {
      double tgt=isLong?openP+InpTP2Points*_Point:openP-InpTP2Points*_Point;
      bool hit=isLong?(bid>=tgt):(ask<=tgt);
      if(hit)
        {
         double cv=NormVol(vol*InpTP2Pct/100.0);
         if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv)){ gPart2=true; Log("2o target: seconda parziale."); }
        }
     }
  }

//+------------------------------------------------------------------+
//| Trailing dello stop sulla linea Supertrend M3                    |
//+------------------------------------------------------------------+
void TrailToST(bool isLong,double stLine)
  {
   double sl=PositionGetDouble(POSITION_SL);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double newSL=NormalizePrice(stLine);
   if(isLong && newSL>sl && newSL<SymbolInfoDouble(_Symbol,SYMBOL_BID))
      gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
   if(!isLong && (newSL<sl||sl==0) && newSL>SymbolInfoDouble(_Symbol,SYMBOL_ASK))
      gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
  }

//+------------------------------------------------------------------+
//| Supertrend (series): dir (+1/-1) e linea, per barra chiusa idx1  |
//+------------------------------------------------------------------+
bool SupertrendSeries(ENUM_TIMEFRAMES tf,int atrHandle,double mult,int count,double &dirOut[],double &lineOut[])
  {
   int need=InpStAtrPeriod+count+220;
   MqlRates r[]; ArraySetAsSeries(r,true);
   int copied=CopyRates(_Symbol,tf,0,need,r);
   if(copied<InpStAtrPeriod+count+5) return(false);
   double atr[]; ArraySetAsSeries(atr,true);
   if(CopyBuffer(atrHandle,0,0,copied,atr)<copied) return(false);

   ArrayResize(dirOut,copied); ArrayResize(lineOut,copied);
   ArraySetAsSeries(dirOut,true); ArraySetAsSeries(lineOut,true);

   double finalUpper=0, finalLower=0; int dir=+1;
   for(int i=copied-2;i>=0;i--)
     {
      double hl2=(r[i].high+r[i].low)/2.0;
      double bUp=hl2+mult*atr[i], bLo=hl2-mult*atr[i];
      double prevFU=(finalUpper==0)?bUp:finalUpper;
      double prevFL=(finalLower==0)?bLo:finalLower;
      double pc=r[i+1].close;
      double fU=(bUp<prevFU||pc>prevFU)?bUp:prevFU;
      double fL=(bLo>prevFL||pc<prevFL)?bLo:prevFL;
      if(r[i].close > (dir==-1?prevFU:fU))      dir=+1;
      else if(r[i].close < (dir==+1?prevFL:fL)) dir=-1;
      finalUpper=fU; finalLower=fL;
      dirOut[i]=dir;
      lineOut[i]=(dir>0)?fL:fU;
     }
   return(true);
  }

//==================================================================
//  UTILITY
//==================================================================
double AtrTrig(){ double a[1]; if(CopyBuffer(hAtrTrig,0,1,1,a)<1) return(0); return(a[0]); }

void FlatAll()
  {
   if(SelPos()){ if(InpCloseAtEnd) gTrade.PositionClose(_Symbol); }
  }

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

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

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
