//+------------------------------------------------------------------+
//|                                              GoldenZoe_H4.mq5    |
//|  v1.12 (22/11/2026): SOLO ETICHETTE: commento ordine = InpComment + " Buy"/" Sell" (es. "GoldenZoe Buy"); logica, lotti e stop IDENTICI a v1.11. |
//|  v1.11 (19/11/2026): InpLotMode 1 = lotto con OrderCalcProfit (CFD in|
//|   valuta diversa dal conto, es. 225JPY); default 0 = v1.00/v1.10.   |
//|  v1.10 (19/11/2026): FILTRO NEWS opzionale (default SPENTO = v1.00)|
//|  v1.00 (19/11/2026) - TREND FOLLOWING sull'ORO, candele H4.       |
//|  Strategia (backtest_runner/simulatore/tre_leve.py, leva 3a):     |
//|   - INGRESSO: la candela H4 chiusa (shift 1) CHIUDE sopra il      |
//|     massimo delle 55 candele precedenti (shift 2..56) -> BUY a    |
//|     mercato all'apertura della candela successiva. Opzionale la   |
//|     VENDITA simmetrica (default: spenta; il test non le da' edge).|
//|   - STOP INIZIALE: 3 x ATR(14) della candela del segnale.         |
//|   - STOP MOBILE (Chandelier): a ogni nuova candela lo stop sale   |
//|     a (massimo dall'ingresso - 3 x ATR); non scende mai.          |
//|   - USCITA: solo lo stop. Nessun target. Una posizione alla volta.|
//|   - Dopo una uscita sulla barra, si aspetta il segnale successivo |
//|     (come nel simulatore).                                         |
//|  Rischio: InpRiskPercent dell'equity sulla distanza dello stop    |
//|  (la scelta del rischio reale e' di Claudio).                      |
//|  Solo tester/demo. Nessun filtro orario/notizie/spread.            |
//|  NOTA: iATR di MT5 e' la media semplice del True Range (il        |
//|  simulatore Python usava la media di Wilder): differenza piccola.  |
//+------------------------------------------------------------------+
#property copyright "Claudio - GoldenZoe (strategia propria)"
#property version   "1.12"
#property strict
#include <Trade/Trade.mqh>

input ENUM_TIMEFRAMES InpTF          = PERIOD_H4;
input int    InpDonchianN            = 55;     // candele precedenti per il massimo/minimo
input int    InpAtrPeriod            = 14;
input double InpStopAtr              = 3.0;    // stop iniziale = N x ATR
input double InpTrailAtr             = 3.0;    // stop mobile = estremo dall'ingresso -/+ N x ATR
input bool   InpAllowLong            = true;
input bool   InpAllowShort           = false;  // il test non trova edge sulle vendite
input double InpRiskPercent          = 1.0;    // % equity rischiata sullo stop iniziale
input int    InpLotMode              = 0;      // 0 = valore del tick (come v1.00), 1 = OrderCalcProfit (consigliato per CFD in valuta diversa dal conto, es. 225JPY)
input long   InpMagic                = 972301;
input string InpComment              = "GoldenZoe"; // il comando aggiunge " Buy" o " Sell"
input bool   InpVerbose              = false;
// --- FILTRO NEWS (v1.10, default spento): niente NUOVI ingressi da N minuti prima a N minuti dopo una notizia ---
input bool   InpNewsFilter           = false;
input int    InpNewsBeforeMin        = 120;    // minuti PRIMA della notizia in cui non si entra
input int    InpNewsAfterMin         = 120;    // minuti DOPO la notizia in cui non si entra
input int    InpNewsSource           = 0;      // 0 = file CSV (tester e demo), 1 = calendario MT5 (solo demo/live, non nel tester)
input string InpNewsFile             = "abtg_news_hist.csv"; // cartella Common\Files (FILE_COMMON); formato: Data Ora;Impatto;Valuta;Titolo
input string InpNewsCurrencies       = "USD";  // valute considerate (elenco, es. USD,EUR)
input string InpNewsTitleMatch      = "";     // se non vuoto: solo notizie il cui titolo contiene una di queste parti (separate da ~)
input int    InpNewsMinImpact        = 3;      // 3 = alta, 2 = media, 1 = bassa
input bool   InpNewsBlockTrail       = false;  // se true salta anche lo spostamento dello stop vicino alle notizie (si recupera alla candela dopo)

CTrade gTrade;
int    hAtr = INVALID_HANDLE;
datetime gLastBar = 0;
datetime gLastHadPos = 0;
datetime gNewsT[]; int gNewsN = 0; int gNewsBlocked = 0;

bool LoadNews()
  {
   gNewsN=0; ArrayResize(gNewsT,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE){ Print("[GoldenZoe] FILE NEWS NON TROVATO (Common Files ",InpNewsFile,"): errore ",GetLastError()); return false; }
   while(!FileIsEnding(h))
     {
      string sT=FileReadString(h);
      if(FileIsLineEnding(h) && StringLen(sT)==0) continue;
      string sI=FileIsLineEnding(h)?"":FileReadString(h);
      string sC=FileIsLineEnding(h)?"":FileReadString(h);
      string sN=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h) && !FileIsEnding(h)) FileReadString(h);
      datetime tt=StringToTime(sT);
      if(tt<=0) continue;
      string u=sI; StringToUpper(u); int imp=0;
      if(StringFind(u,"HIGH")>=0||u=="3") imp=3; else if(StringFind(u,"MED")>=0||u=="2") imp=2; else if(StringFind(u,"LOW")>=0||u=="1") imp=1;
      if(imp<InpNewsMinImpact) continue;
      if(StringLen(InpNewsCurrencies)>0 && StringFind(InpNewsCurrencies,sC)<0) continue;
      if(StringLen(InpNewsTitleMatch)>0)
        {
         string parts[]; int np=StringSplit(InpNewsTitleMatch,'~',parts); bool ok=false;
         for(int q=0;q<np;q++) if(StringLen(parts[q])>0 && StringFind(sN,parts[q])>=0){ ok=true; break; }
         if(!ok) continue;
        }
      ArrayResize(gNewsT,gNewsN+1); gNewsT[gNewsN]=tt; gNewsN++;
     }
   FileClose(h);
   ArraySort(gNewsT);
   Print("[GoldenZoe] news caricate dal file: ",gNewsN);
   return gNewsN>0;
  }

// true se t cade tra (notizia - Before) e (notizia + After)
bool NewsBlocked(const datetime t)
  {
   if(!InpNewsFilter) return false;
   if(InpNewsSource==1)
     {
      MqlCalendarValue v[];
      if(CalendarValueHistory(v,t-InpNewsAfterMin*60,t+InpNewsBeforeMin*60)<=0) return false;
      for(int i=0;i<ArraySize(v);i++)
        {
         MqlCalendarEvent ev; if(!CalendarEventById(v[i].event_id,ev)) continue;
         if((int)ev.importance<InpNewsMinImpact) continue;
         MqlCalendarCountry c; if(!CalendarCountryById(ev.country_id,c)) continue;
         if(StringLen(InpNewsCurrencies)>0 && StringFind(InpNewsCurrencies,c.currency)<0) continue;
         return true;
        }
      return false;
     }
   // file: ricerca binaria della prima notizia con E >= t - After
   datetime lo=t-InpNewsAfterMin*60, hi=t+InpNewsBeforeMin*60;
   int a=0,b=gNewsN;
   while(a<b){ int m=(a+b)/2; if(gNewsT[m]<lo) a=m+1; else b=m; }
   return (a<gNewsN && gNewsT[a]<=hi);
  }

void Log(const string s){ if(InpVerbose) Print("[GoldenZoe] ",s); }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(50);
   hAtr = iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hAtr==INVALID_HANDLE) return INIT_FAILED;
   if(InpNewsFilter && InpNewsSource==0 && !LoadNews()) return INIT_FAILED;   // filtro acceso ma senza notizie: non parto in silenzio senza filtro
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason){ if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr); if(InpNewsFilter) Print("[GoldenZoe] ingressi bloccati dal filtro news: ",gNewsBlocked); }

bool SelectMyPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return true;   // posizione selezionata
     }
   return false;
  }

double CalcLot(const double slDist,const bool isLong=true)
  {
   double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE), ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(slDist<=0) return 0.0;
   double risk=AccountInfoDouble(ACCOUNT_EQUITY)*InpRiskPercent/100.0;
   double lot=0.0;
   if(InpLotMode==1)
     {
      double px=isLong?SymbolInfoDouble(_Symbol,SYMBOL_ASK):SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double p2=isLong?px-slDist:px+slDist, prof=0.0;
      if(!OrderCalcProfit(isLong?ORDER_TYPE_BUY:ORDER_TYPE_SELL,_Symbol,1.0,px,p2,prof) || MathAbs(prof)<=0) return 0.0;
      lot=risk/MathAbs(prof);
     }
   else
     {
      if(tv<=0 || ts<=0) return 0.0;
      lot=risk/((slDist/ts)*tv);
     }
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP), mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN), mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(step<=0) step=0.01;
   lot=MathFloor(lot/step)*step;
   if(lot<mn) lot=mn;
   if(lot>mx) lot=mx;
   return NormalizeDouble(lot,2);
  }

void OpenTrade(const bool isLong,const double atr)
  {
   double price = isLong ? SymbolInfoDouble(_Symbol,SYMBOL_ASK) : SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double sl    = isLong ? price-InpStopAtr*atr : price+InpStopAtr*atr;
   sl = NormalizeDouble(sl,_Digits);
   double lot = CalcLot(MathAbs(price-sl),isLong);
   if(lot<=0){ Log("lotto non valido"); return; }
   bool ok = isLong ? gTrade.Buy(lot,_Symbol,0,sl,0,InpComment+" Buy") : gTrade.Sell(lot,_Symbol,0,sl,0,InpComment+" Sell");
   Log(StringFormat("%s lot=%.2f price=%.2f sl=%.2f atr=%.2f ok=%d",isLong?"BUY":"SELL",lot,price,sl,atr,ok));
  }

void ManageTrail(const double atr)
  {
   long type = PositionGetInteger(POSITION_TYPE);
   datetime to = (datetime)PositionGetInteger(POSITION_TIME);
   double ent = PositionGetDouble(POSITION_PRICE_OPEN);
   double cur = PositionGetDouble(POSITION_SL);
   int sOpen = iBarShift(_Symbol,InpTF,to,false);       // shift della candela dell'ingresso
   if(sOpen<1) return;
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(type==POSITION_TYPE_BUY)
     {
      int ih=iHighest(_Symbol,InpTF,MODE_HIGH,sOpen,1);   // candele da shift 1 a sOpen
      if(ih<0) return;
      double ext=MathMax(ent,iHigh(_Symbol,InpTF,ih));
      double ns=NormalizeDouble(ext-InpTrailAtr*atr,_Digits);
      if(ns>cur+_Point && ns<=bid-minDist)
        { if(gTrade.PositionModify(_Symbol,ns,0)) Log(StringFormat("trail BUY sl %.2f -> %.2f",cur,ns)); }
     }
   else if(type==POSITION_TYPE_SELL)
     {
      int il=iLowest(_Symbol,InpTF,MODE_LOW,sOpen,1);
      if(il<0) return;
      double ext=MathMin(ent,iLow(_Symbol,InpTF,il));
      double ns=NormalizeDouble(ext+InpTrailAtr*atr,_Digits);
      if((cur<=0.0 || ns<cur-_Point) && ns>=ask+minDist)
        { if(gTrade.PositionModify(_Symbol,ns,0)) Log(StringFormat("trail SELL sl %.2f -> %.2f",cur,ns)); }
     }
  }

void OnTick()
  {
   datetime t0=iTime(_Symbol,InpTF,0);
   if(SelectMyPosition()) gLastHadPos=t0;            // c'e' una posizione in questa candela
   if(t0==gLastBar) return;                           // lavoro solo alla nuova candela
   gLastBar=t0;
   if(Bars(_Symbol,InpTF)<InpDonchianN+InpAtrPeriod+10) return;
   double a[]; ArraySetAsSeries(a,true);
   if(CopyBuffer(hAtr,0,1,1,a)<1) return;
   double atr=a[0]; if(atr<=0) return;
   if(SelectMyPosition()){ if(!(InpNewsBlockTrail && NewsBlocked(t0))) ManageTrail(atr); return; }
   if(gLastHadPos>=iTime(_Symbol,InpTF,1)) return;    // posizione chiusa durante la candela appena finita: aspetto
   double c1=iClose(_Symbol,InpTF,1);
   int ih=iHighest(_Symbol,InpTF,MODE_HIGH,InpDonchianN,2);
   int il=iLowest (_Symbol,InpTF,MODE_LOW ,InpDonchianN,2);
   if(ih<0 || il<0) return;
   bool sigL = InpAllowLong  && c1>iHigh(_Symbol,InpTF,ih);
   bool sigS = InpAllowShort && c1<iLow (_Symbol,InpTF,il);
   if(!(sigL || sigS)) return;
   if(NewsBlocked(t0)){ gNewsBlocked++; Log("ingresso saltato: finestra notizie"); return; }
   if(sigL) { OpenTrade(true ,atr); return; }
   if(sigS) { OpenTrade(false,atr); return; }
  }
