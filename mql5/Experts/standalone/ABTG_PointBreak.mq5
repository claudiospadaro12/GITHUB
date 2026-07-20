//+------------------------------------------------------------------+
//|                                            ABTG_PointBreak.mq5    |
//|                                                                  |
//|  EA "POINT BREAK" (mean-reversion) - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla strategia POINT BREAK (Christian Bertacchi/ABTG). |
//|  La strategia e' DICHIARATAMENTE DISCREZIONALE e basata su       |
//|  PATTERN GRAFICI VISIVI (Montagna, W, M, Chiesa, Orecchie di    |
//|  Lupo, Testa e Spalle) che NON sono automatizzabili in modo     |
//|  fedele. Questo EA automatizza il solo CUORE MECCANICO della    |
//|  checklist d'ingresso, comune a tutti quei pattern (inversione  |
//|  su un estremo):                                                |
//|   - prezzo FUORI dalle Bollinger (37, 1.4);                     |
//|   - Stocastico (5,3,3) in ipercomprato/ipervenduto + incrocio; |
//|   - EMA200 distante dal prezzo (>= soglia);                     |
//|   - TP = media delle Bollinger, solo se RR >= 1:1;             |
//|   - SL su spike recente / floor di volatilita' (ATR);          |
//|   - parziale + stop in pari, trailing giornaliero sul "sedere". |
//|                                                                  |
//|  I PATTERN e i supporti/resistenze (Larry Williams) restano     |
//|  all'occhio umano. TF principale D1. DEMO. Nessuna garanzia.    |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe e indicatori ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_D1;   // TF operativo (documento: D1 principale)
input int    InpBBPeriod   = 37;           // Bollinger periodo (documento: 37)
input double InpBBDev      = 1.4;          // Bollinger deviazione (documento: 1.4)
input int    InpEmaPeriod  = 200;          // EMA di regime
input int    InpStochK     = 5;            // Stocastico %K (documento: 5)
input int    InpStochD     = 3;            // Stocastico %D (documento: 3)
input int    InpStochSlow  = 3;            // Stocastico rallentamento (documento: 3)
input int    InpAtrPeriod  = 14;           // ATR (proxy volatilita' media)

input group "=== Condizioni d'ingresso ==="
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;
input double InpStochOB     = 80.0;        // soglia ipercomprato
input double InpStochOS     = 20.0;        // soglia ipervenduto
input bool   InpRequireCross = true;       // richiedi incrocio linee stocastico
input double InpEma200DistAtr = 1.5;       // EMA200 distante >= N*ATR dal prezzo (doc: ~100 pip)
input double InpMinBandExcessAtr = 0.0;    // "quanto fuori" dalla banda, in ATR (0 = basta esserne fuori)

input group "=== Stop / target ==="
input int    InpSLLookback = 3;            // barre per lo spike (max/min recente) dello SL
input double InpSLBufferAtr  = 0.2;        // buffer sullo SL, in ATR (doc: 10/15 pip)
input double InpVolFloorAtr   = 1.0;       // SL minimo = N*ATR (floor di volatilita')
input double InpMinRR         = 1.0;       // salta se RR (verso la media Bollinger) < questo

input group "=== Gestione ==="
input double InpPartialAtr   = 1.0;        // parziale dopo N*ATR di profitto (doc: 40/60 pip)
input double InpPartialPct    = 60;        // % chiusa alla parziale (doc: 50/70%)
input bool   InpBreakeven     = true;      // stop in pari dopo la parziale
input bool   InpDailyTrail     = true;     // trailing giornaliero sul "sedere" della candela precedente

input group "=== Rischio ==="
input double InpRiskPercent   = 2.0;       // rischio per trade in % (doc: 2/3%)
input int    InpMaxTradesPerDay = 0;       // 0 = illimitato
input int    InpMaxPositions   = 1;

input group "=== Filtro orari (ORA SERVER; opzionale) ==="
input bool   InpUseTimeWindow = false;
input int    InpStartHour     = 0;
input int    InpEndHour       = 24;

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 30;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input long   InpMagic     = 771101;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hBB=INVALID_HANDLE, hEma=INVALID_HANDLE, hStoch=INVALID_HANDLE, hAtr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[PointBreak] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hBB    = iBands(_Symbol,InpTF,InpBBPeriod,0,InpBBDev,PRICE_CLOSE);
   hEma   = iMA(_Symbol,InpTF,InpEmaPeriod,0,MODE_EMA,PRICE_CLOSE);
   hStoch = iStochastic(_Symbol,InpTF,InpStochK,InpStochD,InpStochSlow,MODE_SMA,STO_LOWHIGH);
   hAtr   = iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hBB==INVALID_HANDLE||hEma==INVALID_HANDLE||hStoch==INVALID_HANDLE||hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. BB(%d,%.1f), Stoch(%d,%d,%d), EMA%d.",
       _Symbol,EnumToString(InpTF),InpBBPeriod,InpBBDev,InpStochK,InpStochD,InpStochSlow,InpEmaPeriod));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[4]={hBB,hEma,hStoch,hAtr};
   for(int i=0;i<4;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageAll();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   DailyTrail();          // ad ogni nuova candela sposta lo stop sul "sedere"
   OnNewBar(now);
  }

//+------------------------------------------------------------------+
void OnNewBar(MqlDateTime &now)
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseTimeWindow && (now.hour<InpStartHour || now.hour>=InpEndHour)) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double up[2],mid[2],lo[2],k[2],d[2],ema[1],atrb[1];
   // Array come serie: [0] = barra appena chiusa (shift 1), [1] = precedente (shift 2)
   ArraySetAsSeries(up,true); ArraySetAsSeries(mid,true); ArraySetAsSeries(lo,true);
   ArraySetAsSeries(k,true);  ArraySetAsSeries(d,true);
   if(CopyBuffer(hBB,1,1,2,up)!=2)  return;   // 1 = banda superiore
   if(CopyBuffer(hBB,0,1,2,mid)!=2) return;   // 0 = base (media)
   if(CopyBuffer(hBB,2,1,2,lo)!=2)  return;   // 2 = banda inferiore
   if(CopyBuffer(hStoch,0,1,2,k)!=2) return;  // %K
   if(CopyBuffer(hStoch,1,1,2,d)!=2) return;  // %D
   if(CopyBuffer(hEma,0,1,1,ema)!=1) return;
   if(CopyBuffer(hAtr,0,1,1,atrb)!=1||atrb[0]<=0) return;
   double atr=atrb[0];

   double close1=iClose(_Symbol,InpTF,1);
   // k[0]/d[0] = barra [1] (appena chiusa); k[1]/d[1] = barra [2]
   double K1=k[0],D1=d[0],K2=k[1],D2=d[1];
   double midNow=mid[0];

   // EMA200 deve essere distante dal prezzo
   if(MathAbs(close1-ema[0]) < InpEma200DistAtr*atr) return;

   //--- SHORT: prezzo sopra banda alta + stoc ipercomprato + incrocio ribassista
   if(InpAllowShort)
     {
      bool outside = (close1 > up[0]) && ((close1-up[0]) >= InpMinBandExcessAtr*atr);
      bool ob      = (K1>=InpStochOB);
      bool cross   = (!InpRequireCross) || (K2>=D2 && K1<D1);
      if(outside && ob && cross && midNow<close1)
        { TryEnter(false,midNow,atr); return; }
     }
   //--- LONG: prezzo sotto banda bassa + stoc ipervenduto + incrocio rialzista
   if(InpAllowLong)
     {
      bool outside = (close1 < lo[0]) && ((lo[0]-close1) >= InpMinBandExcessAtr*atr);
      bool os      = (K1<=InpStochOS);
      bool cross   = (!InpRequireCross) || (K2<=D2 && K1>D1);
      if(outside && os && cross && midNow>close1)
        { TryEnter(true,midNow,atr); return; }
     }
  }

//+------------------------------------------------------------------+
//| Ingresso a mercato: TP = media Bollinger, SL su spike/volatilita'|
//+------------------------------------------------------------------+
void TryEnter(bool isLong,double midBand,double atr)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;

   double ext = isLong ? iLow(_Symbol,InpTF,iLowest(_Symbol,InpTF,MODE_LOW,InpSLLookback,1))
                       : iHigh(_Symbol,InpTF,iHighest(_Symbol,InpTF,MODE_HIGH,InpSLLookback,1));
   double buf=InpSLBufferAtr*atr;
   double slRaw = isLong ? ext-buf : ext+buf;
   // floor di volatilita': se lo stop e' troppo stretto, allargalo
   double slDistMin=InpVolFloorAtr*atr;
   if(isLong  && (entry-slRaw)<slDistMin) slRaw=entry-slDistMin;
   if(!isLong && (slRaw-entry)<slDistMin) slRaw=entry+slDistMin;
   double sl=NormalizePrice(slRaw);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=MathMax(buf,(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk<minDist){ Log("SL non valido: skip."); return; }

   double tp=NormalizePrice(midBand);
   double reward=isLong?(tp-entry):(entry-tp);
   if(reward<=0){ Log("media Bollinger dalla parte sbagliata: skip."); return; }
   double rr=reward/risk;
   if(rr<InpMinRR){ Log(StringFormat("RR %.2f < %.2f verso la media Bollinger: skip.",rr,InpMinRR)); return; }

   double lot=LotByRisk(risk);
   if(lot<=0){ Log("lotto nullo."); return; }

   bool ok=isLong?gTrade.Buy(lot,_Symbol,ask,sl,tp,"PointBreak L")
                 :gTrade.Sell(lot,_Symbol,bid,sl,tp,"PointBreak S");
   if(ok){ gTradesToday++; Log(StringFormat("%s @ %s SL %s TP %s (RR %.2f) lot %.2f",isLong?"LONG":"SHORT",
           DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),rr,lot)); }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Parziale a N*ATR + stop in pari (tutte le posizioni del magic)   |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double atrb[1]; double atr=(CopyBuffer(hAtr,0,1,1,atrb)==1?atrb[0]:0);
   if(atr<=0) return;

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
      if(!beDone && InpPartialAtr>0 && InpPartialPct>0 && InpPartialPct<100)
        {
         double tgt=isLong?openP+InpPartialAtr*atr:openP-InpPartialAtr*atr;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
            double cv=NormVol(vol*InpPartialPct/100.0);
            if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
              { if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
                Log("parziale + stop in pari."); }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Trailing giornaliero: SL sul "sedere" della candela precedente   |
//+------------------------------------------------------------------+
void DailyTrail()
  {
   if(!InpDailyTrail) return;
   double prevLow=iLow(_Symbol,InpTF,1), prevHigh=iHigh(_Symbol,InpTF,1);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double sl=PositionGetDouble(POSITION_SL);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      if(isLong)
        {
         double n=NormalizePrice(prevLow);
         if(n>sl && n>=openP && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
        }
      else
        {
         double n=NormalizePrice(prevHigh);
         if((n<sl||sl==0) && n<=openP && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
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
