//+------------------------------------------------------------------+
//|                                              ABTG_FiboH4.mq5      |
//|                                                                  |
//|  EA "FIBO H4" - MT5 - TUTTO-IN-UNO                             |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia FIBO H4 (Emiliano Monza / ABTG).       |
//|  Alla fine di un trend, un pattern ENGULFING (candela coperta   |
//|  totalmente dalla successiva o dalle due successive). Si traccia|
//|  Fibonacci sullo swing e si piazzano ordini LIMITE nelle Entry  |
//|  Zone (livelli proprietari 1.78-1.88 e 2.78-2.88). Target = 100 |
//|  (estremo dello swing). Stop oltre il 4.236.                   |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                              |
//|   - Engulfing (1 o 2 candele) entro N candele;                |
//|   - Entry Zone come estensioni Fibo (ratio configurabili);    |
//|   - 2 ordini limite 1/3 e 2/3; SL al 4.236; TP=100 (estremo   |
//|     swing), parziale + pari, trailing; distanza min 50-60 pip;|
//|   - cancella pendenti a fine giornata; niente over-weekend;   |
//|   - blocco news.                                              |
//|                                                                  |
//|  NON automatizzato (discrezionale): "fine di un trend" e "no    |
//|   candele troppo ampie/laterali" a giudizio umano (qui filtri  |
//|   approssimati), livelli tecnici/Multipivot per SR.           |
//|  Coppie migliori: GBP/USD, USD/JPY. Orari in ORA SERVER        |
//|  (BCM = ora italiana - 1). DEMO. Nessuna garanzia.            |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.10"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;   // TF operativo (strategia: solo H4)

input group "=== Engulfing ==="
input int    InpEngulfLookback = 12;  // engulfing entro N candele (video: 8-12)
input bool   InpAllowTwoCandle = true;// accetta copertura dalle DUE candele successive
input double InpMinEngulfBodyPct = 25.0; // corpo engulfing >= % del range (evita candele deboli)
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Entry Zone (Fibonacci FIBO H4 - valori proprietari Emiliano Monza) ==="
input double InpEZ1ratio = 1.88;  // 1a Entry Zone: ratio Fibo (banda 1.78-1.88)
input double InpEZ2ratio = 2.88;  // 2a Entry Zone: ratio Fibo (banda 2.78-2.88, piu' profonda)
input double InpSLratio  = 4.236; // SL oltre il 4.236 ("ultimo baluardo")
input bool   InpUseEZ2   = true;

input group "=== Distanza e validita' ==="
input double InpMinDistPips = 50.0;  // il prezzo deve distare >= N pip dalla 1a zona (video: 50-60)
input int    InpAtrPeriod   = 14;
input double InpMaxEngulfAtr = 3.0;  // scarta engulfing con range > N*ATR (candele troppo ampie)
input int    InpPendingExpiryBars = 6; // scadenza pendenti (barre)

input group "=== Stop / target ==="
input double InpSLbufferPips = 3.0;  // buffer extra sullo SL (pip)
input double InpTP1_R        = 1.0;  // 1o target (in R) -> parziale + stop in pari
input double InpTP1Pct       = 50;
input bool   InpBreakeven    = true;
input bool   InpUseTrailing  = true; // trailing su ATR dopo il 1o target
input double InpTrailAtrMult = 2.0;

input group "=== Rischio e size (1/3 + 2/3) ==="
input double InpRiskPercent  = 1.0;  // rischio % TOTALE (diviso tra i due ordini)
input double InpFirstFraction = 0.3333; // quota 1a zona (video: 1/3)

input group "=== Chiusura giornaliera / weekend (ORA SERVER) ==="
input bool   InpUseCutoff   = true;  // cancella pendenti non eseguiti a fine giornata
input int    InpCutoffHour  = 17;    // 18:30-19:00 IT = 17:30-18:00 server
input int    InpCutoffMin   = 45;
input bool   InpFridayClose = true;  // niente posizioni nel weekend
input int    InpFridayCloseHour = 21;// 22:50 IT = 21:50 server
input int    InpFridayCloseMin  = 50;

input group "=== Filtro notizie (guida: rimuovere ordini prima di dati 3 stelle) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "FIBOH4";
input long   InpMagic     = 771601;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hAtr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[FiboH4] ", m); }

//+------------------------------------------------------------------+
double PipSize()
  {
   int d=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   return (d==3 || d==5) ? _Point*10.0 : _Point;
  }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr=iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hAtr==INVALID_HANDLE){ Print("ERRORE: handle ATR."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. Engulfing entro %d candele, EZ ratio %.2f/%.2f, SL %.3f.",
       _Symbol,EnumToString(InpTF),InpEngulfLookback,InpEZ1ratio,InpEZ2ratio,InpSLratio));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){ if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr); }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageAll();
   CutoffCheck();
   FridayCloseCheck();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0); return(a[0]); }

//--- Engulfing: la candela 'i' (o le candele i e i-1) copre la candela precedente
//    bullish: alla fine di un trend short, la candela viene coperta al rialzo
bool BullEngulf(int i,double &swingHigh,double &swingLow)
  {
   // caso 1 candela: i copre i+1
   double oi=iOpen(_Symbol,InpTF,i), ci=iClose(_Symbol,InpTF,i);
   double hi=iHigh(_Symbol,InpTF,i), li=iLow(_Symbol,InpTF,i);
   double op=iOpen(_Symbol,InpTF,i+1), cp=iClose(_Symbol,InpTF,i+1);
   double hp=iHigh(_Symbol,InpTF,i+1), lp=iLow(_Symbol,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBear=(cp<op);
   // copertura totale (compresi gli spike): la engulfing copre l'intera candela precedente
   bool coverFull=(hi>=hp && li<=lp && ci>oi);
   if(prevBear && coverFull && strong){ swingHigh=hp; swingLow=li; return(true); }

   // caso 2 candele: la somma di i e i-1 copre i+1 (la candela di fine trend)
   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(_Symbol,InpTF,i-1));
      double l2=MathMin(li,iLow(_Symbol,InpTF,i-1));
      double c2=iClose(_Symbol,InpTF,i-1);
      if(prevBear && h2>=hp && l2<=lp && c2>op){ swingHigh=hp; swingLow=l2; return(true); }
     }
   return(false);
  }

bool BearEngulf(int i,double &swingHigh,double &swingLow)
  {
   double oi=iOpen(_Symbol,InpTF,i), ci=iClose(_Symbol,InpTF,i);
   double hi=iHigh(_Symbol,InpTF,i), li=iLow(_Symbol,InpTF,i);
   double op=iOpen(_Symbol,InpTF,i+1), cp=iClose(_Symbol,InpTF,i+1);
   double hp=iHigh(_Symbol,InpTF,i+1), lp=iLow(_Symbol,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBull=(cp>op);
   bool coverFull=(hi>=hp && li<=lp && ci<oi);
   if(prevBull && coverFull && strong){ swingHigh=hi; swingLow=lp; return(true); }

   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(_Symbol,InpTF,i-1));
      double l2=MathMin(li,iLow(_Symbol,InpTF,i-1));
      double c2=iClose(_Symbol,InpTF,i-1);
      if(prevBull && h2>=hp && l2<=lp && c2<op){ swingHigh=h2; swingLow=lp; return(true); }
     }
   return(false);
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(HasPosition() || HasPending()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double atr=AtrVal(); if(atr<=0) return;

   for(int i=1;i<=InpEngulfLookback;i++)
     {
      double sh,sl;
      if(InpAllowLong && BullEngulf(i,sh,sl))
        {
         if((sh-sl) <= InpMaxEngulfAtr*atr){ TryPlace(true,sh,sl); return; }
        }
      if(InpAllowShort && BearEngulf(i,sh,sl))
        {
         if((sh-sl) <= InpMaxEngulfAtr*atr){ TryPlace(false,sh,sl); return; }
        }
     }
  }

//+------------------------------------------------------------------+
//| Entry Zone come estensioni Fibonacci dello swing; TP = estremo   |
//+------------------------------------------------------------------+
void TryPlace(bool isLong,double swingHigh,double swingLow)
  {
   double range=swingHigh-swingLow; if(range<=0) return;
   double pip=PipSize();
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double px=isLong?ask:bid;

   // LONG: entry sotto lo swing (pullback), target = max swing. SHORT: speculare.
   double ez1 = isLong ? swingHigh-InpEZ1ratio*range : swingLow+InpEZ1ratio*range;
   double ez2 = isLong ? swingHigh-InpEZ2ratio*range : swingLow+InpEZ2ratio*range;
   double target = isLong ? swingHigh : swingLow;
   double sl = isLong ? NormalizePrice(swingHigh-InpSLratio*range-InpSLbufferPips*pip)
                      : NormalizePrice(swingLow +InpSLratio*range+InpSLbufferPips*pip);

   if(MathAbs(px-ez1) < InpMinDistPips*pip){ Log("prezzo troppo vicino alla 1a zona (<50-60 pip): skip."); return; }

   int nOrders = InpUseEZ2 ? 2 : 1;
   double f1 = nOrders==2 ? InpFirstFraction : 1.0;
   PlaceLimit(isLong,NormalizePrice(ez1),sl,NormalizePrice(target),InpRiskPercent*f1,"EZ1");
   if(InpUseEZ2) PlaceLimit(isLong,NormalizePrice(ez2),sl,NormalizePrice(target),InpRiskPercent*(1.0-f1),"EZ2");
  }

void PlaceLimit(bool isLong,double px,double sl,double tp,double riskPct,string tag)
  {
   double risk=isLong?(px-sl):(sl-px);
   if(risk<=0){ Log("SL non valido ("+tag+")."); return; }
   double lot=LotByRisk(risk,riskPct);
   if(lot<=0){ Log("lotto nullo ("+tag+")."); return; }
   datetime exp=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(InpTF);
   string cm=InpComment+(isLong?" L ":" S ")+tag;
   bool ok=isLong?gTrade.BuyLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,cm)
                 :gTrade.SellLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,cm);
   if(ok){ gTradesToday++; Log(StringFormat("%s LIMIT %s @ %s SL %s TP %s lot %.2f",isLong?"BUY":"SELL",tag,
           DoubleToString(px,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
   else Log("ordine "+tag+" fallito: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Gestione: parziale a 1R + pari; trailing ATR                     |
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

      if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
            double cv=NormVol(vol*InpTP1Pct/100.0);
            if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
              { if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
                Log("1o target (1R): parziale + stop in pari."); }
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

//+------------------------------------------------------------------+
void CutoffCheck()
  {
   if(!InpUseCutoff) return;
   if(HasPosition()) return;                 // se e' entrato, lo si gestisce
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.hour*60+now.min < InpCutoffHour*60+InpCutoffMin) return;
   if(HasPending()){ CancelPendings(); Log("fine giornata: pendenti non eseguiti cancellati."); }
  }

void FridayCloseCheck()
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_week!=5) return;
   if(now.hour*60+now.min < InpFridayCloseHour*60+InpFridayCloseMin) return;
   CancelPendings();
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) gTrade.PositionClose(tk);
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

bool HasPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

bool HasPending()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
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
