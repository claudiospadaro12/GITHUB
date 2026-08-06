//+------------------------------------------------------------------+
//|                                       ABTG_SupertrendInvert.mq5   |
//|                                                                  |
//|  EA "SUPERTREND INVERT" - MT5 - VERSIONE TUTTO-IN-UNO           |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sul documento "Strategia SUPERTREND INVERT" (H1).       |
//|                                                                  |
//|  CUORE MECCANICO (automatizzato - Scenario A):                  |
//|   - SEGNALE BASE: inversione Supertrend H1 (ATR 10 / Mult 3.5), |
//|     trigger = CHIUSURA della candela di inversione.            |
//|   - STRONG (unica config operabile): prezzo oltre EMA50 E oltre |
//|     EMA200, Supertrend coerente con la direzione.             |
//|   - FORZA: ADX(14) >= soglia e in crescita; Stocastico H1      |
//|     (14,3,3) coerente (incrocio + livello); opz. Stoc. H4.     |
//|   - FILTRO estensione: no ingresso se prezzo troppo lontano dal |
//|     Supertrend (> N*ATR).                                       |
//|   - SL: cuspide Supertrend; TP1: N*ATR H1 -> parziale 50% +    |
//|     stop in pari; runner: uscita/trailing su segnale opposto.  |
//|                                                                  |
//|  NON automatizzato (discrezionale, come da documento):          |
//|   Scenario B (pendenti su livelli), Supply&Demand, S/R H4/D1,   |
//|   scaling size per confluenza. Restano all'occhio umano.       |
//|  Orari eventuali in ORA SERVER. DEMO. Nessun EA garantisce     |
//|  profitti.                                                      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Supertrend (segnale base) ==="
input ENUM_TIMEFRAMES InpTF     = PERIOD_H1;  // Timeframe operativo (documento: H1)
input double InpStMult          = 3.5;        // Moltiplicatore Supertrend (documento: 3.5)
input int    InpStAtrPeriod     = 10;         // ATR del Supertrend (documento: 10)

input group "=== Filtro STRONG (struttura) ==="
input bool   InpRequireStrong   = true;       // Opera solo su config STRONG (consigliato)
input int    InpEma50Period     = 50;         // EMA trend intraday
input int    InpEma200Period    = 200;        // EMA regime di mercato
input bool   InpAllowLong       = true;
input bool   InpAllowShort      = true;

input group "=== Filtro forza: ADX ==="
input bool   InpUseADX          = true;
input int    InpAdxPeriod       = 14;
input double InpAdxMin          = 20.0;        // minimo (documento: >=20; ideale >=25)
input bool   InpAdxRising       = true;        // richiedi ADX in crescita

input group "=== Filtro momentum: Stocastico ==="
input bool   InpUseStoch        = true;
input int    InpStochK          = 14;          // H1: 14/3/3
input int    InpStochD          = 3;
input int    InpStochSlow       = 3;
input double InpStochLongMin     = 40.0;       // long: %K sopra questo livello
input double InpStochShortMax    = 60.0;       // short: %K sotto questo livello
input bool   InpUseStochH4       = false;      // conferma extra su Stocastico H4 (21/3/3)
input int    InpStochH4K         = 21;

input group "=== Filtro estensione (anti-inseguimento) ==="
input bool   InpUseExtensionFilter = true;
input double InpMaxExtAtr        = 2.0;        // salta se |prezzo - Supertrend| > N*ATR

input group "=== Stop / target / gestione ==="
input double InpSLBufferPts     = 0;           // buffer extra sullo stop (punti; 0 = min broker)
input double InpTP1_ATRmult     = 1.0;         // 1o target = N * ATR H1
input double InpTP1Pct          = 50;          // % chiusa al 1o target (documento: 50%)
input bool   InpBreakeven       = true;        // stop in pari dopo la parziale
input bool   InpExitOnOpposite  = true;        // esci sul segnale opposto del Supertrend
input bool   InpTrailOnST        = true;       // trailing dello stop sulla linea Supertrend

input group "=== Rischio ==="
input double InpRiskPercent     = 1.0;         // rischio per trade in %
input int    InpMaxTradesPerDay = 0;           // 0 = illimitato
input int    InpMaxPositions    = 1;           // posizioni contemporanee max (per questo magic)

input group "=== Filtro orari (ORA SERVER; opzionale) ==="
input bool   InpUseTimeWindow   = false;
input int    InpStartHour       = 7;           // no nuovi ingressi prima
input int    InpEndHour         = 20;          // no nuovi ingressi dopo

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter   = false;
input string InpNewsFile        = "abtg_news.csv";
input int    InpNewsMinImpact   = 3;
input int    InpNewsBeforeMin    = 30;
input int    InpNewsAfterMin     = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies   = "";

input group "=== Generali ==="
input string InpComment   = "STINVERT";
input long   InpMagic     = 770801;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hAtr=INVALID_HANDLE, hEma50=INVALID_HANDLE, hEma200=INVALID_HANDLE, hAdx=INVALID_HANDLE;
int  hStoch=INVALID_HANDLE, hStochH4=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;
bool gPart1=false;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[STInvert] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr    = iATR(_Symbol,InpTF,InpStAtrPeriod);
   hEma50  = iMA(_Symbol,InpTF,InpEma50Period,0,MODE_EMA,PRICE_CLOSE);
   hEma200 = iMA(_Symbol,InpTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   hAdx    = iADX(_Symbol,InpTF,InpAdxPeriod);
   hStoch  = iStochastic(_Symbol,InpTF,InpStochK,InpStochD,InpStochSlow,MODE_SMA,STO_LOWHIGH);
   hStochH4= iStochastic(_Symbol,PERIOD_H4,InpStochH4K,InpStochD,InpStochSlow,MODE_SMA,STO_LOWHIGH);
   if(hAtr==INVALID_HANDLE||hEma50==INVALID_HANDLE||hEma200==INVALID_HANDLE||hAdx==INVALID_HANDLE||
      hStoch==INVALID_HANDLE||hStochH4==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. Supertrend(%d,%.1f), STRONG=%s.",
       _Symbol,EnumToString(InpTF),InpStAtrPeriod,InpStMult,(InpRequireStrong?"si":"no")));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[6]={hAtr,hEma50,hEma200,hAdx,hStoch,hStochH4};
   for(int i=0;i<6;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManagePosition();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;        // logica solo a nuova barra del TF operativo
   gLastBar=t;

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar(now);
  }

//+------------------------------------------------------------------+
//| Logica alla chiusura di una nuova candela del TF operativo       |
//+------------------------------------------------------------------+
void OnNewBar(MqlDateTime &now)
  {
   double dir[],line[];
   if(!SupertrendSeries(4,dir,line)) return;

   int dir1=(int)dir[1], dir2=(int)dir[2];   // barra appena chiusa vs precedente
   bool invLong  = (dir1>0 && dir2<0);
   bool invShort = (dir1<0 && dir2>0);

   //--- uscita su segnale opposto (anche se non apro nulla di nuovo)
   if(SelPos())
     {
      long ptype=PositionGetInteger(POSITION_TYPE);
      ulong ptk=PositionGetInteger(POSITION_TICKET);
      if(InpExitOnOpposite && ((ptype==POSITION_TYPE_BUY && invShort)||(ptype==POSITION_TYPE_SELL && invLong)))
        { gTrade.PositionClose(ptk); Log("segnale opposto: uscita runner."); }
     }

   if(!(invLong||invShort)) return;           // niente inversione = niente da fare

   //--- filtri operativi
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseTimeWindow && (now.hour<InpStartHour || now.hour>=InpEndHour)) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   bool isLong=invLong;
   if(isLong && !InpAllowLong) return;
   if(!isLong && !InpAllowShort) return;

   double close1=iClose(_Symbol,InpTF,1);
   double stLine=line[1];

   if(InpRequireStrong && !IsStrong(isLong,close1,stLine)) { Log("inversione non STRONG: skip."); return; }
   if(InpUseADX && !AdxOK())                               { Log("ADX debole/non in crescita: skip."); return; }
   if(InpUseStoch && !StochOK(isLong))                     { Log("stocastico non coerente: skip."); return; }
   if(InpUseStochH4 && !StochH4OK(isLong))                 { Log("stocastico H4 non coerente: skip."); return; }
   if(InpUseExtensionFilter && !ExtensionOK(close1,stLine)){ Log("prezzo troppo esteso dal ST: skip."); return; }

   Enter(isLong,stLine);
  }

//+------------------------------------------------------------------+
//| STRONG = prezzo oltre EMA50 e EMA200, Supertrend coerente        |
//+------------------------------------------------------------------+
bool IsStrong(bool isLong,double close1,double stLine)
  {
   double e50[1],e200[1];
   if(CopyBuffer(hEma50,0,1,1,e50)!=1 || CopyBuffer(hEma200,0,1,1,e200)!=1) return(false);
   if(isLong)  return(close1>e50[0] && close1>e200[0] && stLine<close1);
   return(close1<e50[0] && close1<e200[0] && stLine>close1);
  }

//+------------------------------------------------------------------+
bool AdxOK()
  {
   double a[3];
   if(CopyBuffer(hAdx,0,1,3,a)!=3) return(false);   // buffer 0 = ADX principale
   if(a[0]<InpAdxMin) return(false);
   if(InpAdxRising && !(a[0]>=a[1])) return(false);  // in crescita o stabile
   return(true);
  }

//+------------------------------------------------------------------+
//| Stocastico coerente col trade (conferma momentum, non trigger)   |
//+------------------------------------------------------------------+
bool StochOK(bool isLong)
  {
   double k[1],d[1];
   if(CopyBuffer(hStoch,0,1,1,k)!=1 || CopyBuffer(hStoch,1,1,1,d)!=1) return(false);
   if(isLong)  return(k[0]>d[0] && k[0]>=InpStochLongMin);   // incrocio rialzista + livello
   return(k[0]<d[0] && k[0]<=InpStochShortMax);               // incrocio ribassista + livello
  }

bool StochH4OK(bool isLong)
  {
   double k[1],d[1];
   if(CopyBuffer(hStochH4,0,1,1,k)!=1 || CopyBuffer(hStochH4,1,1,1,d)!=1) return(true);
   if(isLong)  return(k[0]>=45.0 && k[0]>=d[0]);   // H4: sopra 45-55, pendenza coerente
   return(k[0]<=55.0 && k[0]<=d[0]);
  }

//+------------------------------------------------------------------+
bool ExtensionOK(double close1,double stLine)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1 || a[0]<=0) return(true);
   return(MathAbs(close1-stLine) <= InpMaxExtAtr*a[0]);
  }

//+------------------------------------------------------------------+
//| Ingresso a mercato con SL sulla cuspide Supertrend               |
//+------------------------------------------------------------------+
void Enter(bool isLong,double stLine)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double buf=EffBuffer();
   double sl=NormalizePrice(isLong?stLine-buf:stLine+buf);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=MathMax(buf,(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk<minDist){ Log("stop troppo vicino (cuspide): skip."); return; }

   double lot=LotByRisk(risk);
   if(lot<=0){ Log("lotto nullo."); return; }

   gPart1=false;
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,0,InpComment+" L")
                 :gTrade.Sell(lot,_Symbol,bid,sl,0,InpComment+" S");
   if(ok){ gTradesToday++; Log(StringFormat("%s @ %s SL %s lot %.2f",isLong?"LONG":"SHORT",
           DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),lot)); }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Gestione: parziale 50% a N*ATR + breakeven; trailing su ST       |
//+------------------------------------------------------------------+
void ManagePosition()
  {
   if(!SelPos()) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   //--- 1o target a N*ATR -> parziale + stop in pari
   if(!gPart1 && InpTP1_ATRmult>0 && InpTP1Pct>0 && InpTP1Pct<100)
     {
      double a[1];
      if(CopyBuffer(hAtr,0,1,1,a)==1 && a[0]>0)
        {
         double tgt=isLong?openP+a[0]*InpTP1_ATRmult:openP-a[0]*InpTP1_ATRmult;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
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
            if(beFatto) gTrade.PositionModify(ticket,bePari,PositionGetDouble(POSITION_TP));
            if(parzOK || beFatto)
               Log(parzOK ? "1o target (ATR): parziale 50% + stop in pari."
                          : "1o target (ATR): stop in pari (parziale impossibile al lotto minimo).");
           }
        }
     }

   //--- trailing sulla linea Supertrend
   if(InpTrailOnST)
     {
      double dir[],line[];
      if(SupertrendSeries(3,dir,line))
        {
         double newSL=NormalizePrice(line[1]);
         double sl=PositionGetDouble(POSITION_SL);
         if(isLong && newSL>sl && newSL<bid) gTrade.PositionModify(ticket,newSL,PositionGetDouble(POSITION_TP));
         if(!isLong && (newSL<sl||sl==0) && newSL>ask) gTrade.PositionModify(ticket,newSL,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Supertrend (series): dir (+1/-1) e linea, per barra chiusa idx1  |
//+------------------------------------------------------------------+
bool SupertrendSeries(int count,double &dirOut[],double &lineOut[])
  {
   int need=InpStAtrPeriod+count+220;
   MqlRates r[]; ArraySetAsSeries(r,true);
   int copied=CopyRates(_Symbol,InpTF,0,need,r);
   if(copied<InpStAtrPeriod+count+5) return(false);
   double atr[]; ArraySetAsSeries(atr,true);
   if(CopyBuffer(hAtr,0,0,copied,atr)<copied) return(false);

   ArrayResize(dirOut,copied); ArrayResize(lineOut,copied);
   ArraySetAsSeries(dirOut,true); ArraySetAsSeries(lineOut,true);

   double finalUpper=0, finalLower=0; int dir=+1;
   for(int i=copied-2;i>=0;i--)
     {
      double hl2=(r[i].high+r[i].low)/2.0;
      double bUp=hl2+InpStMult*atr[i], bLo=hl2-InpStMult*atr[i];
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
bool SelPos(){ for(int _i=PositionsTotal()-1;_i>=0;_i--){ ulong _tk=PositionGetTicket(_i); if(_tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true); } return(false); }

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
