//+------------------------------------------------------------------+
//|                                                  ABTG_PTE.mq5     |
//|                                                                  |
//|  EA "PTE" (Pro Trading Experience) - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia PTE (Emiliano Monza / ABTG).            |
//|  Mean-reversion sugli estremi dei canali di regressione (TMA),  |
//|  confermata da una DOJI col corpo FUORI dal canale veloce e dal |
//|  cambio colore della candela (Heikin Ashi) successiva.         |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                               |
//|   - Canali TMA slow (struttura) e fast (operativo), NON-REPAINT;|
//|   - DOJI col corpo oltre il canale veloce -> estremo;          |
//|   - conferma col cambio colore Heikin Ashi;                    |
//|   - SL = ATR + buffer (o estremo Doji); TP1 EMA14 parz.50% +   |
//|     pari, TP2 = 2*ATR, trailing; blocco news.                 |
//|                                                                  |
//|  NON automatizzato (proprietario/discrezionale, come da guida): |
//|   PTE Filter Indicator (algoritmo proprietario), Opposing/Larry |
//|   Williams, S/R multi-timeframe, W%R come conferma manuale.    |
//|  NB: i canali della DASHBOARD PTE probabilmente REPAINTANO; qui |
//|  si usa una TMA non-repainting, quindi i valori differiscono.  |
//|  Parametri TMA per coppia: vedi tabella "Setting_canali_PTE".   |
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
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;   // TF operativo (guida: H4 o H1)

input group "=== Canale TMA LENTO (struttura) ==="
input int    InpTmaSlow    = 56;    // Periodo TMA lento (setting_canali: per coppia)
input int    InpAtrSlow    = 100;   // Periodo ATR canale lento
input double InpMultSlow    = 2.0;  // Moltiplicatore ampiezza

input group "=== Canale TMA VELOCE (operativo) ==="
input int    InpTmaFast    = 14;    // Periodo TMA veloce
input int    InpAtrFast    = 30;    // Periodo ATR canale veloce
input double InpMultFast    = 2.0;  // Moltiplicatore ampiezza

input group "=== Doji e conferma ==="
input double InpDojiBodyMaxPct = 10.0; // corpo <= % del range per essere Doji
input bool   InpUseHeikinAshi  = true; // usa Heikin Ashi per corpo/conferma
input bool   InpRequireOutSlow  = false;// Doji fuori anche dal canale LENTO (piu' selettivo)
input bool   InpRequireColorFlip = true;// conferma = cambio colore della candela successiva
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Filtro trend/momentum (opzionale) ==="
input bool   InpUseEma200Bias = false; // opera solo verso la EMA200 (mean-reversion di rientro)
input int    InpEma200Period  = 200;
input int    InpEma14Period   = 14;    // primo target
input bool   InpUseWPR         = false;// filtro Williams %R (uscita da ipercomp/ipervend)
input int    InpWprPeriod      = 14;
input double InpWprOB          = -20.0;
input double InpWprOS          = -80.0;

input group "=== Stop / target (ATR) ==="
input int    InpAtrExitPeriod = 14;    // ATR per SL/target
input double InpSLbufferPips   = 5.0;  // SL = ATR + questo (pip). Guida: 5/10 pip
input bool   InpSLfromDoji     = false;// alternativa: SL sull'estremo della Doji +/- buffer
input double InpTP1_ATRmult    = 0.0;  // 0 = TP1 sulla EMA14; altrimenti N*ATR
input double InpTP1Pct         = 50;   // % chiusa al 1o target
input bool   InpBreakeven      = true;
input double InpTP2_ATRmult    = 2.0;  // 2o target = N*ATR (guida: 2 ATR)
input bool   InpUseTrailing    = true; // trailing sull'EMA14 dopo il 1o target

input group "=== Rischio ==="
input double InpRiskPercent   = 1.0;
input int    InpMaxTradesPerDay = 0;
input int    InpMaxPositions   = 1;

input group "=== Filtro notizie (la PTE vuole: niente news in arrivo) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "PTE";     // commento ordini
input long   InpMagic     = 771301;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hAtrSlow=INVALID_HANDLE, hAtrFast=INVALID_HANDLE, hAtrExit=INVALID_HANDLE;
int  hEma200=INVALID_HANDLE, hEma14=INVALID_HANDLE, hWpr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

//--- METRICHE DA PROP (07/08/2026). L'Equity DD dice se il conto sopravvive;
//    una prop invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa
//    e su PTE non era misurata da nessuna parte. Qui si segue l'equity dentro
//    la giornata e si tiene la caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;   // equity all'inizio della giornata
double gDayMinEquity   = 0.0;   // minimo di equity toccato nella giornata
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;    // giorno dell'anno usato per il reset qui sopra

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[PTE] ", m); }

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
   hAtrSlow=iATR(_Symbol,InpTF,InpAtrSlow);
   hAtrFast=iATR(_Symbol,InpTF,InpAtrFast);
   hAtrExit=iATR(_Symbol,InpTF,InpAtrExitPeriod);
   hEma200 =iMA(_Symbol,InpTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   hEma14  =iMA(_Symbol,InpTF,InpEma14Period,0,MODE_EMA,PRICE_CLOSE);
   hWpr    =iWPR(_Symbol,InpTF,InpWprPeriod);
   if(hAtrSlow==INVALID_HANDLE||hAtrFast==INVALID_HANDLE||hAtrExit==INVALID_HANDLE||
      hEma200==INVALID_HANDLE||hEma14==INVALID_HANDLE||hWpr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. TMA lento %d / veloce %d.",
       _Symbol,EnumToString(InpTF),InpTmaSlow,InpTmaFast));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[6]={hAtrSlow,hAtrFast,hAtrExit,hEma200,hEma14,hWpr};
   for(int i=0;i<6;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageAll();

   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del giorno.
   //    Sta QUI e non dopo il filtro della nuova barra: su H4 una candela dura
   //    quattro ore, e la caduta peggiore di giornata succede in mezzo.
   {
    MqlDateTime _n; TimeToStruct(TimeCurrent(), _n);
    double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
    if(_n.day_of_year != gDayEqStamp)
      { gDayEqStamp = _n.day_of_year; gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(gDayStartEquity <= 0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(_eq < gDayMinEquity)  gDayMinEquity = _eq;
    double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
    if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
   }

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
//| TMA non-repainting: media triangolare (SMA di SMA) su close.     |
//| Ritorna mid/upper/lower alla barra chiusa 'shift'.               |
//+------------------------------------------------------------------+
bool TmaBand(int period,int atrHandle,double mult,int shift,double &mid,double &up,double &lo)
  {
   int m=(period+1)/2; if(m<1) m=1;
   int need=period+m+shift+5;
   double c[]; ArraySetAsSeries(c,true);
   if(CopyClose(_Symbol,InpTF,0,need,c)<need) return(false);
   // sma1[i] = SMA(close,m) centrata a i (usando barre piu' vecchie: non-repaint)
   // tma[shift] = SMA(sma1, m) a partire da shift
   double tma=0;
   for(int k=0;k<m;k++)
     {
      double s=0;
      for(int j=0;j<m;j++) s+=c[shift+k+j];
      tma+=s/m;
     }
   tma/=m;
   double a[1];
   if(CopyBuffer(atrHandle,0,shift,1,a)!=1||a[0]<=0) return(false);
   mid=tma; up=tma+a[0]*mult; lo=tma-a[0]*mult;
   return(true);
  }

//+------------------------------------------------------------------+
//| Heikin Ashi per la barra 'shift' (o candele normali se off)      |
//+------------------------------------------------------------------+
void GetCandle(int shift,double &o,double &h,double &l,double &c)
  {
   h=iHigh(_Symbol,InpTF,shift); l=iLow(_Symbol,InpTF,shift);
   if(!InpUseHeikinAshi){ o=iOpen(_Symbol,InpTF,shift); c=iClose(_Symbol,InpTF,shift); return; }
   // Heikin Ashi non-repaint su barre chiuse
   double haC=(iOpen(_Symbol,InpTF,shift)+iHigh(_Symbol,InpTF,shift)+iLow(_Symbol,InpTF,shift)+iClose(_Symbol,InpTF,shift))/4.0;
   // haOpen ricorsivo: approssimo con 2 barre di seed
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
void OnNewBar()
  {
   if(CountPositions()>=InpMaxPositions) return;
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   // Doji sulla barra [2], conferma sulla barra [1]
   double o2,h2,l2,c2, o1,h1,l1,c1;
   GetCandle(2,o2,h2,l2,c2);
   GetCandle(1,o1,h1,l1,c1);
   if(!IsDoji(o2,h2,l2,c2)) return;

   double midF,upF,loF, midS,upS,loS;
   if(!TmaBand(InpTmaFast,hAtrFast,InpMultFast,2,midF,upF,loF)) return;
   if(!TmaBand(InpTmaSlow,hAtrSlow,InpMultSlow,2,midS,upS,loS)) return;

   double body_hi=MathMax(o2,c2), body_lo=MathMin(o2,c2);

   //--- Doji col corpo FUORI dal canale veloce (sine qua non): sopra=short, sotto=long
   bool dojiAbove = (body_lo>upF) && (!InpRequireOutSlow || body_lo>upS);
   bool dojiBelow = (body_hi<loF) && (!InpRequireOutSlow || body_hi<loS);
   if(!(dojiAbove||dojiBelow)) return;

   bool wantShort = dojiAbove;
   bool wantLong  = dojiBelow;

   // conferma: cambio colore della candela [1] nella direzione dell'inversione
   bool bear1=(c1<o1), bull1=(c1>o1);
   if(InpRequireColorFlip)
     {
      if(wantShort && !bear1) return;
      if(wantLong  && !bull1) return;
     }

   // filtri opzionali
   if(wantLong && !InpAllowLong) return;
   if(wantShort && !InpAllowShort) return;
   if(InpUseEma200Bias && !Ema200BiasOK(wantLong)) return;
   if(InpUseWPR && !WprOK(wantLong)) return;

   Enter(wantLong,h2,l2);
  }

//+------------------------------------------------------------------+
bool Ema200BiasOK(bool isLong)
  {
   double e[1]; if(CopyBuffer(hEma200,0,1,1,e)!=1) return(true);
   double c1=iClose(_Symbol,InpTF,1);
   // rientro verso la media: long se sotto la EMA200, short se sopra
   return(isLong ? c1<e[0] : c1>e[0]);
  }

bool WprOK(bool isLong)
  {
   double w[2]; ArraySetAsSeries(w,true);
   if(CopyBuffer(hWpr,0,1,2,w)!=2) return(true);
   // long: W%R esce dall'ipervenduto (risale sopra OS); short: esce dall'ipercomprato
   if(isLong)  return(w[1]<=InpWprOS && w[0]>InpWprOS);
   return(w[1]>=InpWprOB && w[0]<InpWprOB);
  }

//+------------------------------------------------------------------+
void Enter(bool isLong,double dojiHigh,double dojiLow)
  {
   double pip=PipSize();
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;
   double a[1]; if(CopyBuffer(hAtrExit,0,1,1,a)!=1||a[0]<=0){ Log("ATR non disp."); return; }
   double atr=a[0];

   double sl;
   if(InpSLfromDoji) sl = isLong ? dojiLow-InpSLbufferPips*pip : dojiHigh+InpSLbufferPips*pip;
   else              sl = isLong ? entry-(atr+InpSLbufferPips*pip) : entry+(atr+InpSLbufferPips*pip);
   sl=NormalizePrice(sl);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(risk<=minDist){ Log("SL non valido: skip."); return; }

   // TP finale = 2 ATR (o tecnico). TP intermedio gestito a runtime (EMA14 / TP1_ATR).
   double tp = isLong ? entry+atr*InpTP2_ATRmult : entry-atr*InpTP2_ATRmult;
   tp=NormalizePrice(tp);

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
//| Gestione: 1o target (EMA14 o N*ATR) parziale + pari; trailing    |
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

      // 1o target
      if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt;
         if(InpTP1_ATRmult>0 && atr>0) tgt=isLong?openP+atr*InpTP1_ATRmult:openP-atr*InpTP1_ATRmult;
         else if(haveE14)              tgt=e14[0];       // primo target naturale = EMA14
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

      // trailing sull'EMA14 dopo il breakeven
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
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
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
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che servono per rispondere "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
