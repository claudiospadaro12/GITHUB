//+------------------------------------------------------------------+
//|                                                  ABTG_WOL.mq5     |
//|                                                                  |
//|  EA "WEEKLY OPEN LINE" (WOL) - MT5 - TUTTO-IN-UNO              |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia WOL (Weekly Open Line, ABTG).          |
//|  Inversione con DOJI in prossimita' della linea di apertura     |
//|  settimanale (WOL), confermata dalla candela successiva, su D1. |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                              |
//|   - WOL = apertura settimanale (candela W1);                   |
//|   - DOJI (D1) col corpo su un lato della WOL, shadow che la     |
//|     tocca/attraversa (NON il corpo che la taglia = invalido);  |
//|   - conferma: candela successiva chiude oltre la Doji e dal     |
//|     lato giusto della WOL;                                     |
//|   - filtro spike lunghi (Doji troppo ampia) e opz. canali TMA; |
//|   - SL su estremo Doji +/- buffer; TP1 EMA14 parz.50% + pari;  |
//|     TP2 su R multiplo/ATR; trailing su EMA14; blocco news.    |
//|                                                                  |
//|  NON automatizzato (proprietario/discrezionale, come da guida): |
//|   PTE Filter Indicator, Opposing/Larry Williams, S/R multi-TF, |
//|   contesto laterale a giudizio umano.                          |
//|  DEMO. Nessuna garanzia.                                        |
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
input ENUM_TIMEFRAMES InpTF = PERIOD_D1;   // TF operativo (guida: D1)

input group "=== Weekly Open Line ==="
input double InpWolProximityAtr = 0.5; // "in prossimita' della WOL": distanza <= N*ATR
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Doji e conferma ==="
input double InpDojiBodyMaxPct = 12.0; // corpo <= % del range per essere Doji
input bool   InpUseHeikinAshi  = true; // usa Heikin Ashi per corpo/conferma
input double InpMaxDojiAtr      = 2.0; // scarta Doji con range > N*ATR (spike troppo lungo)
input bool   InpRequireConfirmClose = true; // conferma: la successiva chiude oltre la Doji

input group "=== Filtri opzionali ==="
input bool   InpUseChannels   = false; // Doji DENTRO i canali di regressione (TMA)
input int    InpTmaSlow       = 56;
input int    InpAtrSlow       = 100;
input double InpMultSlow        = 2.0;
input bool   InpUseEmaTrend    = false;// la Doji deve essere "alla fine di un trend" (EMA200)
input int    InpEma200Period   = 200;
input int    InpEma14Period    = 14;   // primo target
input bool   InpAvoidLateral   = true; // evita contesto laterale (range Doji troppo piccolo)
input double InpMinDojiAtr      = 0.3; // range Doji >= N*ATR (anti-lateralita')

input group "=== Stop / target ==="
input int    InpAtrExitPeriod = 14;
input double InpSLbufferAtr    = 0.15; // SL = estremo Doji +/- N*ATR (scala-indipendente: forex/oro/indici)
input double InpMinRR          = 1.0;  // salta se RR (verso il TP finale) < questo (guida: >=1:1)
input double InpTP1_ATRmult    = 0.0;  // 0 = TP1 su EMA14; altrimenti N*ATR
input double InpTP1Pct         = 50;
input bool   InpBreakeven      = true;
input double InpTP_RR          = 2.0;  // TP finale in R
input bool   InpUseTrailing    = true; // trailing su EMA14 dopo il 1o target

input group "=== Rischio ==="
input double InpRiskPercent   = 1.0;
input int    InpMaxTradesPerDay = 0;
input int    InpMaxPositions   = 1;

input group "=== Filtro notizie (la WOL vuole: niente news in arrivo) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "WOL";
input long   InpMagic     = 771401;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hAtrExit=INVALID_HANDLE, hAtrSlow=INVALID_HANDLE, hEma200=INVALID_HANDLE, hEma14=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[WOL] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtrExit=iATR(_Symbol,InpTF,InpAtrExitPeriod);
   hAtrSlow=iATR(_Symbol,InpTF,InpAtrSlow);
   hEma200 =iMA(_Symbol,InpTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   hEma14  =iMA(_Symbol,InpTF,InpEma14Period,0,MODE_EMA,PRICE_CLOSE);
   if(hAtrExit==INVALID_HANDLE||hAtrSlow==INVALID_HANDLE||hEma200==INVALID_HANDLE||hEma14==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. WOL = apertura settimanale.",_Symbol,EnumToString(InpTF)));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[4]={hAtrExit,hAtrSlow,hEma200,hEma14};
   for(int i=0;i<4;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
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
double WeeklyOpen(){ return(iOpen(_Symbol,PERIOD_W1,0)); }   // apertura della settimana corrente

void GetCandle(int shift,double &o,double &h,double &l,double &c)
  {
   h=iHigh(_Symbol,InpTF,shift); l=iLow(_Symbol,InpTF,shift);
   if(!InpUseHeikinAshi){ o=iOpen(_Symbol,InpTF,shift); c=iClose(_Symbol,InpTF,shift); return; }
   double haC=(iOpen(_Symbol,InpTF,shift)+iHigh(_Symbol,InpTF,shift)+iLow(_Symbol,InpTF,shift)+iClose(_Symbol,InpTF,shift))/4.0;
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
//| TMA non-repainting (per il filtro "Doji dentro i canali")        |
//+------------------------------------------------------------------+
bool TmaBand(int period,int atrHandle,double mult,int shift,double &up,double &lo)
  {
   int m=(period+1)/2; if(m<1) m=1;
   int need=period+m+shift+5;
   double c[]; ArraySetAsSeries(c,true);
   if(CopyClose(_Symbol,InpTF,0,need,c)<need) return(false);
   double tma=0;
   for(int k=0;k<m;k++){ double s=0; for(int j=0;j<m;j++) s+=c[shift+k+j]; tma+=s/m; }
   tma/=m;
   double a[1]; if(CopyBuffer(atrHandle,0,shift,1,a)!=1||a[0]<=0) return(false);
   up=tma+a[0]*mult; lo=tma-a[0]*mult; return(true);
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double atr=AtrVal(); if(atr<=0) return;
   double wol=WeeklyOpen(); if(wol<=0) return;

   // Doji su barra [2], conferma su barra [1]
   double o2,h2,l2,c2, o1,h1,l1,c1;
   GetCandle(2,o2,h2,l2,c2);
   GetCandle(1,o1,h1,l1,c1);
   if(!IsDoji(o2,h2,l2,c2)) return;

   double range2=h2-l2;
   if(range2 > InpMaxDojiAtr*atr) { Log("Doji troppo lunga (spike): skip."); return; }
   if(InpAvoidLateral && range2 < InpMinDojiAtr*atr){ Log("contesto laterale (Doji piccola): skip."); return; }

   double bodyHi=MathMax(o2,c2), bodyLo=MathMin(o2,c2);
   double prox=InpWolProximityAtr*atr;

   // corpo NON deve tagliare la WOL; deve stare su un lato e la WOL vicina/attraversata dallo shadow
   bool bodyAboveWol = (bodyLo>wol);                 // corpo sopra la WOL -> possibile LONG (supporto)
   bool bodyBelowWol = (bodyHi<wol);                 // corpo sotto la WOL -> possibile SHORT (resistenza)
   bool nearLong  = bodyAboveWol && (l2<=wol+prox) && ((bodyLo-wol)<=prox);
   bool nearShort = bodyBelowWol && (h2>=wol-prox) && ((wol-bodyHi)<=prox);

   bool wantLong=false, wantShort=false;
   if(nearLong && InpAllowLong)
     {
      bool conf = (!InpRequireConfirmClose) || (c1>h2 && c1>wol && c1>o1);   // conferma rialzista oltre la Doji e la WOL
      if(conf) wantLong=true;
     }
   if(nearShort && InpAllowShort)
     {
      bool conf = (!InpRequireConfirmClose) || (c1<l2 && c1<wol && c1<o1);
      if(conf) wantShort=true;
     }
   if(!(wantLong||wantShort)) return;

   // filtri opzionali
   if(InpUseEmaTrend && !EmaTrendOK(wantLong)) return;
   if(InpUseChannels && !InChannels(bodyHi,bodyLo)) return;

   Enter(wantLong,h2,l2,atr);
  }

//+------------------------------------------------------------------+
bool EmaTrendOK(bool isLong)
  {
   // "Doji alla fine di un trend": long dopo una discesa (prezzo sotto EMA200), short dopo una salita
   double e[1]; if(CopyBuffer(hEma200,0,1,1,e)!=1) return(true);
   double c2=iClose(_Symbol,InpTF,2);
   return(isLong ? c2<e[0] : c2>e[0]);
  }

bool InChannels(double bodyHi,double bodyLo)
  {
   double up,lo;
   if(!TmaBand(InpTmaSlow,hAtrSlow,InpMultSlow,2,up,lo)) return(true);
   return(bodyHi<=up && bodyLo>=lo);   // corpo dentro il canale lento
  }

//+------------------------------------------------------------------+
void Enter(bool isLong,double dojiHigh,double dojiLow,double atr)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double buf=InpSLbufferAtr*atr;
   double sl = isLong ? NormalizePrice(dojiLow-buf) : NormalizePrice(dojiHigh+buf);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(risk<=minDist){ Log("SL non valido: skip."); return; }

   double tp = isLong ? entry+risk*InpTP_RR : entry-risk*InpTP_RR;
   tp=NormalizePrice(tp);
   double rr=InpTP_RR;
   if(rr<InpMinRR){ Log("RR sotto il minimo: skip."); return; }

   double lot=LotByRisk(risk);
   if(lot<=0){ Log("lotto nullo."); return; }

   string cm=InpComment+(isLong?" L":" S");
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                 :gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok){ gTradesToday++; Log(StringFormat("%s @ %s SL %s TP %s lot %.2f",isLong?"LONG":"SHORT",
           DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

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

      if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt;
         if(InpTP1_ATRmult>0 && atr>0) tgt=isLong?openP+atr*InpTP1_ATRmult:openP-atr*InpTP1_ATRmult;
         else if(haveE14)              tgt=e14[0];
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
double AtrVal(){ double a[1]; if(CopyBuffer(hAtrExit,0,1,1,a)<1) return(0); return(a[0]); }

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
