//+------------------------------------------------------------------+
//|                                             ABTG_ORB_Fibo.mq5     |
//|                                                                  |
//|  EA "ORB + Fibonacci" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO     |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Versione avanzata del Webinar ORB:                             |
//|   - OPENING RANGE 30 min dopo l'apertura USA (15:30-16:00 CET   |
//|     = 14:30-15:00 server). Max/min del range.                  |
//|   - BREAKOUT: candela M5 che CHIUDE fuori dal range, con        |
//|     volume in aumento e corpo ampio (direzionalita').          |
//|   - INGRESSO sul RITRACCIAMENTO in GOLDEN ZONE (50-61.8% Fib)   |
//|     con candela di forza + filtro EMA9/21 (+ MACD opzionale).   |
//|   - SL al 78.6% Fib; TP1 allo 0% Fib (estensione); parziale +   |
//|     breakeven; runner con trailing/uscita su EMA9.             |
//|   - 1 trade a sessione; rischio %; chiude a fine giornata.      |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti. DEMO.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Opening Range (ORARI SERVER) ==="
input int    InpORStartHour = 14;   // Apertura (server). BCM: 14:30 = 15:30 CET (USA)
input int    InpORStartMin  = 30;
input int    InpORMinutes   = 30;   // Durata dell'Opening Range (webinar: 30 min)
input int    InpBreakCutoffMin = 120; // Smetti di cercare il breakout N min dopo la fine OR
input int    InpEndHour     = 22;   // Fine giornata (server)
input int    InpEndMin      = 59;
input bool   InpCloseAtEnd  = true;
input bool   InpOneTradePerDay = true;

input group "=== Breakout ==="
input ENUM_TIMEFRAMES InpExecTF = PERIOD_M5; // TF di esecuzione (webinar: 5 min)
input bool   InpUseVolume   = true;  // Richiedi picco di volume alla rottura
input double InpVolMult     = 1.5;   // Volume rottura > X * media precedente (webinar: +50-100%)
input int    InpVolAvgBars  = 20;    // Barre per la media volume
input double InpBodyMinRatio = 0.5;  // Corpo/range minimo della candela di rottura

input group "=== Ingresso Fibonacci ==="
input double InpFibGZ1 = 0.5;        // Golden Zone inizio (50%)
input double InpFibGZ2 = 0.618;      // Golden Zone fine (61.8%)
input double InpFibSL  = 0.786;      // Stop oltre il 78.6% (invalidazione)
input bool   InpUseEMAFilter = true; // Filtro EMA9/21 sul TF esecuzione
input int    InpEmaFast = 9;
input int    InpEmaSlow = 21;
input bool   InpUseMACD  = false;    // Filtro MACD (curl in direzione)
input bool   InpAllowLong = true;
input bool   InpAllowShort= true;

input group "=== Rischio e gestione ==="
input double InpRiskPercent = 1.0;   // Rischio per trade in %
input double InpMinRR       = 0.0;   // R:R minimo per entrare (0=off; webinar consiglia 1:2)
input double InpSLBufferPts = 0;     // Buffer extra sullo stop (punti)
input double InpTP1Pct      = 50;    // % chiusa al TP1 (estensione 0% Fib)
input bool   InpBreakeven   = true;  // Stop in pari dopo la parziale
input bool   InpUseTrailEMA = true;  // Trailing su EMA9 per il runner
input bool   InpExitOnEmaClose = true; // Esci se candela chiude oltre EMA9 opposta

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
input long   InpMagic     = 770602;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int      hEmaF=INVALID_HANDLE, hEmaS=INVALID_HANDLE, hMacd=INVALID_HANDLE;
enum ENUM_FPHASE { F_WAIT_OR, F_WAIT_BREAK, F_WAIT_ENTRY, F_INTRADE, F_DONE };
ENUM_FPHASE gPhase=F_WAIT_OR;
int      gDay=-1, gDir=0;
double   gORhigh=0, gORlow=0, gExt=0, gTPlevel=0;
bool     gReached=false, gPart1=false;
datetime gLastExec=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[ORB_Fibo] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hEmaF=iMA(_Symbol,InpExecTF,InpEmaFast,0,MODE_EMA,PRICE_CLOSE);
   hEmaS=iMA(_Symbol,InpExecTF,InpEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   hMacd=iMACD(_Symbol,InpExecTF,12,26,9,PRICE_CLOSE);
   if(hEmaF==INVALID_HANDLE||hEmaS==INVALID_HANDLE||hMacd==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. OR server %02d:%02d +%d min. Golden Zone %.1f-%.1f%%, SL %.1f%%.",
       _Symbol,InpORStartHour,InpORStartMin,InpORMinutes,InpFibGZ1*100,InpFibGZ2*100,InpFibSL*100));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
   if(hMacd!=INVALID_HANDLE) IndicatorRelease(hMacd);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageTP1();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   bool newsBlk=InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten && SelPos()) gTrade.PositionClose(_Symbol);

   int nowMin=now.hour*60+now.min;
   if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }

   int orEnd=InpORStartHour*60+InpORStartMin+InpORMinutes;
   if(gPhase==F_WAIT_OR && nowMin>=orEnd)
     {
      if(ComputeOR()) gPhase=F_WAIT_BREAK;
     }

   //--- il resto (breakout, entry, runner) a nuova barra M5
   datetime t=iTime(_Symbol,InpExecTF,0);
   if(t==gLastExec) return;
   gLastExec=t;

   if(gPhase==F_WAIT_BREAK)
     {
      if(nowMin > orEnd+InpBreakCutoffMin){ gPhase=F_DONE; return; }
      if(!newsBlk) CheckBreakout();
     }
   else if(gPhase==F_WAIT_ENTRY)
      CheckEntry(newsBlk);
   else if(gPhase==F_INTRADE)
      ManageRunner();
  }

void ResetDay(){ gPhase=F_WAIT_OR; gDir=0; gORhigh=0; gORlow=0; gExt=0; gTPlevel=0; gReached=false; gPart1=false; Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Calcola l'Opening Range (finestra server)                        |
//+------------------------------------------------------------------+
bool ComputeOR()
  {
   int fromMin=InpORStartHour*60+InpORStartMin;
   int toMin=fromMin+InpORMinutes;
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=fromMin/60; t.min=fromMin%60; datetime tStart=StructToTime(t);
   t.hour=toMin/60;   t.min=toMin%60;   datetime tEnd=StructToTime(t);
   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE), count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   gORhigh=iHigh(_Symbol,PERIOD_M1,hIdx);
   gORlow =iLow (_Symbol,PERIOD_M1,lIdx);
   if(gORhigh<=gORlow) return(false);
   Log(StringFormat("OR definito: high %.5f low %.5f (amp %.1f pt).",gORhigh,gORlow,(gORhigh-gORlow)/_Point));
   return(true);
  }

//+------------------------------------------------------------------+
//| Rileva il breakout confermato (chiusura fuori + volume + corpo)  |
//+------------------------------------------------------------------+
void CheckBreakout()
  {
   double c=iClose(_Symbol,InpExecTF,1), o=iOpen(_Symbol,InpExecTF,1);
   double h=iHigh(_Symbol,InpExecTF,1),  l=iLow(_Symbol,InpExecTF,1);
   double rng=h-l;
   bool bodyOK=(rng>0 && MathAbs(c-o)/rng>=InpBodyMinRatio);
   bool volOK=(!InpUseVolume || VolBar(1) > InpVolMult*AvgVol(2,InpVolAvgBars));
   if(!bodyOK || !volOK) return;

   if(c>gORhigh && InpAllowLong)  { gDir=+1; gExt=h; gReached=false; gPhase=F_WAIT_ENTRY; Log("breakout LONG confermato."); }
   else if(c<gORlow && InpAllowShort){ gDir=-1; gExt=l; gReached=false; gPhase=F_WAIT_ENTRY; Log("breakout SHORT confermato."); }
  }

//+------------------------------------------------------------------+
//| Livelli Fibonacci correnti (dipendono dall'estensione gExt)      |
//+------------------------------------------------------------------+
void FibLevels(double &gz1,double &gz2,double &slL,double &tp)
  {
   if(gDir>0){ double r=gExt-gORlow;  gz1=gExt-InpFibGZ1*r; gz2=gExt-InpFibGZ2*r; slL=gExt-InpFibSL*r; tp=gExt; }
   else      { double r=gORhigh-gExt; gz1=gExt+InpFibGZ1*r; gz2=gExt+InpFibGZ2*r; slL=gExt+InpFibSL*r; tp=gExt; }
  }

//+------------------------------------------------------------------+
//| Attende il ritracciamento in Golden Zone + candela di conferma   |
//+------------------------------------------------------------------+
void CheckEntry(bool newsBlk)
  {
   //--- aggiorna l'estensione
   if(gDir>0) gExt=MathMax(gExt,iHigh(_Symbol,InpExecTF,1));
   else       gExt=MathMin(gExt,iLow (_Symbol,InpExecTF,1));

   double gz1,gz2,slL,tp; FibLevels(gz1,gz2,slL,tp);
   double c=iClose(_Symbol,InpExecTF,1), o=iOpen(_Symbol,InpExecTF,1);
   double h=iHigh(_Symbol,InpExecTF,1),  l=iLow(_Symbol,InpExecTF,1);

   //--- invalidazione: chiusura oltre il 78.6%
   if(gDir>0 && c<slL){ gPhase=F_DONE; Log("invalidato (chiusura sotto 78.6%)."); return; }
   if(gDir<0 && c>slL){ gPhase=F_DONE; Log("invalidato (chiusura sopra 78.6%)."); return; }

   //--- ha raggiunto la Golden Zone?
   if(gDir>0 && l<=gz1) gReached=true;
   if(gDir<0 && h>=gz1) gReached=true;
   if(!gReached) return;
   if(newsBlk) return;

   //--- candela di conferma nella direzione + filtri
   bool emaOK=EmaOK(gDir), macdOK=(!InpUseMACD || MacdOK(gDir));
   if(gDir>0 && c>o && c>=gz2 && c<=gExt && emaOK && macdOK) EnterFibo(true, slL, tp);
   if(gDir<0 && c<o && c<=gz2 && c>=gExt && emaOK && macdOK) EnterFibo(false, slL, tp);
  }

//+------------------------------------------------------------------+
//| Apertura in Golden Zone                                          |
//+------------------------------------------------------------------+
void EnterFibo(bool isLong,double slLevel,double tp)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double buf=EffBuffer();
   double sl=NormalizePrice(isLong?slLevel-buf:slLevel+buf);
   double risk=isLong?(entry-sl):(sl-entry);
   double reward=isLong?(tp-entry):(entry-tp);
   double minDist=MathMax(buf,(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk<minDist){ Log("stop troppo vicino, salto."); gPhase=F_DONE; return; }
   if(reward<=0){ Log("target gia' raggiunto, salto."); gPhase=F_DONE; return; }
   if(InpMinRR>0 && reward/risk<InpMinRR){ Log(StringFormat("R:R %.2f < %.2f, salto.",reward/risk,InpMinRR)); gPhase=F_DONE; return; }

   double lot=LotByRisk(risk);
   if(lot<=0){ gPhase=F_DONE; return; }

   gPart1=false; gTPlevel=NormalizePrice(tp);
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,0,"ORB Fibo L")
                 :gTrade.Sell(lot,_Symbol,bid,sl,0,"ORB Fibo S");
   if(ok){ gPhase=F_INTRADE; Log(StringFormat("%s @ %.5f SL %.5f TP %.5f (R:R %.2f)",isLong?"LONG":"SHORT",entry,sl,tp,reward/risk)); }
   else { Log("apertura fallita: "+gTrade.ResultRetcodeDescription()); gPhase=F_DONE; }
  }

//+------------------------------------------------------------------+
//| TP1 all'estensione (0% Fib): parziale + breakeven                |
//+------------------------------------------------------------------+
void ManageTP1()
  {
   if(!SelPos() || gPart1 || gTPlevel<=0 || InpTP1Pct<=0 || InpTP1Pct>=100) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   bool hit=isLong?(bid>=gTPlevel):(ask<=gTPlevel);
   if(!hit) return;
   double cv=NormVol(vol*InpTP1Pct/100.0);
   if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv))
     { gPart1=true; if(InpBreakeven) gTrade.PositionModify(_Symbol,NormalizePrice(openP),PositionGetDouble(POSITION_TP));
       Log("TP1 (estensione): parziale + stop in pari."); }
  }

//+------------------------------------------------------------------+
//| Runner: trailing su EMA9 + uscita se chiude oltre EMA9 opposta   |
//+------------------------------------------------------------------+
void ManageRunner()
  {
   if(!SelPos()){ gPhase=F_DONE; return; }
   double ef[1]; if(CopyBuffer(hEmaF,0,1,1,ef)!=1) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double close1=iClose(_Symbol,InpExecTF,1);
   if(InpExitOnEmaClose)
     {
      if(isLong && close1<ef[0]) { gTrade.PositionClose(_Symbol); Log("chiusura M5 sotto EMA9: uscita."); return; }
      if(!isLong && close1>ef[0]){ gTrade.PositionClose(_Symbol); Log("chiusura M5 sopra EMA9: uscita."); return; }
     }
   if(InpUseTrailEMA)
     {
      double sl=PositionGetDouble(POSITION_SL), openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double newSL=NormalizePrice(ef[0]);
      if(isLong && newSL>sl && newSL<SymbolInfoDouble(_Symbol,SYMBOL_BID))
         gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
      if(!isLong && (newSL<sl||sl==0) && newSL>SymbolInfoDouble(_Symbol,SYMBOL_ASK))
         gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
     }
  }

void EndOfDay()
  {
   if(InpCloseAtEnd && SelPos()) gTrade.PositionClose(_Symbol);
   gPhase=F_DONE;
  }

//==================================================================
//  FILTRI EMA / MACD / VOLUME
//==================================================================
bool EmaOK(int dir)
  {
   if(!InpUseEMAFilter) return(true);
   double f[1],s[1]; if(CopyBuffer(hEmaF,0,1,1,f)!=1||CopyBuffer(hEmaS,0,1,1,s)!=1) return(true);
   double c=iClose(_Symbol,InpExecTF,1);
   if(dir>0) return(c>f[0] && f[0]>=s[0]);
   return(c<f[0] && f[0]<=s[0]);
  }

bool MacdOK(int dir)
  {
   double m[1],sig[1];
   if(CopyBuffer(hMacd,0,1,1,m)!=1 || CopyBuffer(hMacd,1,1,1,sig)!=1) return(true);
   if(dir>0) return(m[0]>sig[0]);
   return(m[0]<sig[0]);
  }

double VolBar(int shift){ long v=iVolume(_Symbol,InpExecTF,shift); return((double)v); }

double AvgVol(int fromShift,int bars)
  {
   double sum=0; int n=0;
   for(int i=fromShift;i<fromShift+bars;i++){ sum+=VolBar(i); n++; }
   return(n>0?sum/n:0);
  }

//==================================================================
//  UTILITY
//==================================================================
double EffBuffer()
  {
   double stops=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   return(MathMax(InpSLBufferPts,stops)*_Point);
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

bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

//==================================================================
//  FILTRO NOTIZIE
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
