//+------------------------------------------------------------------+
//|                                                ABTG_HARSI.mq5     |
//|                                                                  |
//|  EA "HARSI" (scalping contro-trend) - MT5 - TUTTO-IN-UNO        |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla strategia HARSI di Giuseppe Ippolito.            |
//|  HARSI = Heikin-Ashi applicato all'RSI (indicatore TradingView).|
//|  Scalping CONTRO-TREND su TF piccoli (M1-M5).                  |
//|                                                                  |
//|  LE 4 CONDIZIONI (tutte necessarie), sulla candela CHIUSA:      |
//|   1) candela HA-RSI chiude dentro una fascia (rossa=short,      |
//|      verde=long);                                              |
//|   2) RSI >= OB (default 80) per short / <= OS (20) per long;   |
//|   3) cambio di COLORE della candela HA-RSI;                    |
//|   4) l'RSI cambia direzione (momentum).                        |
//|  Entrata a mercato alla chiusura candela. SL oltre l'ultimo    |
//|  max/min + buffer; TP piccolo (scalping). Re-entry naturale.   |
//|                                                                  |
//|  ⚠️ LIMITE IMPORTANTE: il video NON rivela SL/TP esatti, TF e   |
//|   asset migliori, ne' le 2 condizioni extra a pagamento. Qui    |
//|   SL/TP/soglie sono INPUT DA OTTIMIZZARE. La profittabilita'   |
//|   NON e' garantita: e' scalping contro-trend, fragilissimo su  |
//|   spread/slippage. VALIDA A TICK REALI con spread realistico   |
//|   prima di ogni giudizio. DEMO.                                |
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
input ENUM_TIMEFRAMES InpTF = PERIOD_M5;   // TF operativo (scalping: M1-M5)

input group "=== HARSI (Heikin-Ashi sull'RSI) ==="
input int    InpRSIperiod   = 14;    // periodo RSI
input int    InpHAdepth     = 300;   // barre per ricostruire le candele HA-RSI
input double InpBandUpper    = 70.0; // fascia ROSSA: HA-RSI close >= questo -> setup short
input double InpBandLower    = 30.0; // fascia VERDE: HA-RSI close <= questo -> setup long

input group "=== Condizione 2: livello RSI ==="
input double InpRSI_OB      = 80.0;  // RSI >= per SHORT
input double InpRSI_OS      = 20.0;  // RSI <= per LONG

input group "=== Direzione ==="
input bool   InpAllowLong   = true;
input bool   InpAllowShort  = true;

input group "=== Stop / Take profit (OTTIMIZZABILI: il video non li da') ==="
input int    InpSLlookback  = 3;     // barre per il max/min di riferimento dello SL
input double InpSLbufferPips = 2.0;  // buffer oltre il max/min, in pip
input double InpTPpips       = 6.0;  // take profit in pip (scalping: pochi pip)
input bool   InpTPasR        = false;// se true, TP = InpTP_R * distanza SL (ignora InpTPpips)
input double InpTP_R         = 1.0;  // rapporto rischio/rendimento se InpTPasR=true

input group "=== Gestione operativita' ==="
input int    InpMaxTradesPerDay = 0; // 0 = illimitato
input int    InpCooldownBars    = 1; // barre di attesa dopo una chiusura prima di riaprire
input int    InpMaxPositions    = 1; // posizioni contemporanee (per simbolo+magic)

input group "=== Rischio ==="
input double InpRiskPercent = 0.5;   // rischio % per trade (scalping: basso!)

input group "=== Filtro spread (CRITICO nello scalping) ==="
input int    InpMaxSpread   = 20;    // spread massimo in POINT (0 = disattivato). Tienilo basso!

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 15;
input int    InpNewsAfterMin   = 15;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "HARSI";
input long   InpMagic     = 772001;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hRsiC=INVALID_HANDLE, hRsiO=INVALID_HANDLE, hRsiH=INVALID_HANDLE, hRsiL=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;
datetime gLastCloseBar=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[HARSI] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(20);
   hRsiC=iRSI(_Symbol,InpTF,InpRSIperiod,PRICE_CLOSE);
   hRsiO=iRSI(_Symbol,InpTF,InpRSIperiod,PRICE_OPEN);
   hRsiH=iRSI(_Symbol,InpTF,InpRSIperiod,PRICE_HIGH);
   hRsiL=iRSI(_Symbol,InpTF,InpRSIperiod,PRICE_LOW);
   if(hRsiC==INVALID_HANDLE||hRsiO==INVALID_HANDLE||hRsiH==INVALID_HANDLE||hRsiL==INVALID_HANDLE)
     { Print("ERRORE: handle RSI."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. RSI(%d), fasce %.0f/%.0f, OB/OS %.0f/%.0f. "
       "NB: SL/TP e le 2 condizioni extra del corso NON sono nel video: ottimizza e valida a tick reali.",
       _Symbol,EnumToString(InpTF),InpRSIperiod,InpBandUpper,InpBandLower,InpRSI_OB,InpRSI_OS));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[4]={hRsiC,hRsiO,hRsiH,hRsiL};
   for(int i=0;i<4;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;       // opera solo alla CHIUSURA candela (nuova barra)
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
//| Ricostruisce le candele HA-RSI e legge le condizioni            |
//| Riempie (in serie: [1]=ultima chiusa, [2]=precedente):          |
//|   haC/haO = close/open HA-RSI; rsi = linea RSI (close)          |
//+------------------------------------------------------------------+
bool ComputeHARSI(double &haC1,double &haO1,double &haC2,double &haO2,
                  double &rsi1,double &rsi2)
  {
   int K=MathMax(20,InpHAdepth);
   double ro[],rh[],rl[],rc[];
   ArraySetAsSeries(ro,true); ArraySetAsSeries(rh,true);
   ArraySetAsSeries(rl,true); ArraySetAsSeries(rc,true);
   // partiamo dallo shift 1 (ultima candela CHIUSA)
   if(CopyBuffer(hRsiO,0,1,K,ro)!=K) return(false);
   if(CopyBuffer(hRsiH,0,1,K,rh)!=K) return(false);
   if(CopyBuffer(hRsiL,0,1,K,rl)!=K) return(false);
   if(CopyBuffer(hRsiC,0,1,K,rc)!=K) return(false);

   double haO[],haC[];
   ArrayResize(haO,K); ArrayResize(haC,K);
   ArraySetAsSeries(haO,true); ArraySetAsSeries(haC,true);
   // ricostruzione HA dalla piu' vecchia (K-1) alla piu' recente (0)
   for(int i=K-1;i>=0;i--)
     {
      double hiR=MathMax(rh[i],rl[i]);
      double loR=MathMin(rh[i],rl[i]);
      double clR=(ro[i]+hiR+loR+rc[i])/4.0;
      double opR;
      if(i==K-1) opR=(ro[i]+rc[i])/2.0;
      else       opR=(haO[i+1]+haC[i+1])/2.0;
      haO[i]=opR; haC[i]=clR;
     }
   haC1=haC[1]; haO1=haO[1]; haC2=haC[2]; haO2=haO[2];
   rsi1=rc[1];  rsi2=rc[2];
   return(true);
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpCooldownBars>0 && gLastCloseBar>0)
     {
      int barsSince=iBarShift(_Symbol,InpTF,gLastCloseBar,false);
      if(barsSince>=0 && barsSince<InpCooldownBars) return;
     }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()){ Log("spread alto: salto (scalping)."); return; }

   double haC1,haO1,haC2,haO2,rsi1,rsi2;
   if(!ComputeHARSI(haC1,haO1,haC2,haO2,rsi1,rsi2)) return;

   bool colPrevGreen=(haC2>=haO2), colPrevRed=(haC2<haO2);
   bool colNowGreen =(haC1>=haO1), colNowRed =(haC1<haO1);

   // --- SHORT: fascia rossa + RSI>=OB + cambio colore (verde->rosso) + RSI in calo
   bool shortSetup = (haC1>=InpBandUpper) && (rsi1>=InpRSI_OB)
                   && (colPrevGreen && colNowRed) && (rsi1<rsi2);
   // --- LONG: fascia verde + RSI<=OS + cambio colore (rosso->verde) + RSI in salita
   bool longSetup  = (haC1<=InpBandLower) && (rsi1<=InpRSI_OS)
                   && (colPrevRed && colNowGreen) && (rsi1>rsi2);

   if(longSetup && InpAllowLong)   { Enter(true);  return; }
   if(shortSetup && InpAllowShort) { Enter(false); return; }
  }

//+------------------------------------------------------------------+
void Enter(bool isLong)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double pip=PipSize();
   double buf=InpSLbufferPips*pip;

   // SL oltre l'ultimo max/min delle ultime InpSLlookback candele chiuse
   int look=MathMax(1,InpSLlookback);
   double sl;
   if(isLong)
     {
      int idx=iLowest(_Symbol,InpTF,MODE_LOW,look,1);
      double lo=(idx>=0)?iLow(_Symbol,InpTF,idx):bid;
      sl=NormalizePrice(lo-buf);
     }
   else
     {
      int idx=iHighest(_Symbol,InpTF,MODE_HIGH,look,1);
      double hi=(idx>=0)?iHigh(_Symbol,InpTF,idx):ask;
      sl=NormalizePrice(hi+buf);
     }

   double slDist=isLong?(entry-sl):(sl-entry);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(slDist<=minDist || slDist<=0){ Log("SL troppo vicino/invalid: salto."); return; }

   double tp;
   if(InpTPasR) tp=NormalizePrice(isLong?entry+slDist*InpTP_R:entry-slDist*InpTP_R);
   else         tp=NormalizePrice(isLong?entry+InpTPpips*pip:entry-InpTPpips*pip);

   double lot=LotByRisk(slDist);
   if(lot<=0){ Log("lotto 0: salto."); return; }

   string cm=InpComment+(isLong?" L":" S");
   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,tp,cm):gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok){ gTradesToday++;
           Log(StringFormat("%s @ %s SL %s TP %s lot %.2f",isLong?"LONG":"SHORT",
               DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
   else Log("ordine fallito: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Registra la barra di chiusura (per il cooldown del re-entry)     |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &req,const MqlTradeResult &res)
  {
   if(trans.type==TRADE_TRANSACTION_DEAL_ADD)
     {
      if(HistoryDealSelect(trans.deal))
        {
         if(HistoryDealGetInteger(trans.deal,DEAL_MAGIC)==InpMagic &&
            HistoryDealGetInteger(trans.deal,DEAL_ENTRY)==DEAL_ENTRY_OUT)
            gLastCloseBar=iTime(_Symbol,InpTF,0);
        }
     }
  }

//==================================================================
//  UTILITY
//==================================================================
double PipSize()
  {
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(dg==3||dg==5) return(_Point*10.0);
   return(_Point);
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
