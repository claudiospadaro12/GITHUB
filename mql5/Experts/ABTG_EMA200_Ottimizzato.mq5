//+------------------------------------------------------------------+
//|                                               ABTG_EMA200.mq5     |
//|                                                                  |
//|  EA "EMA 200 REVERSAL" (bounce) - MT5 - TUTTO-IN-UNO           |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia EMA 200 (ABTG).                        |
//|  Rimbalzo del prezzo sulla EMA200 nella direzione del trend:    |
//|  quando il prezzo ritraccia verso la media, si piazzano ordini  |
//|  pendenti LIMITE vicino alla EMA200 per catturare il rimbalzo.  |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                              |
//|   - direzione dal lato del prezzo vs EMA200 (+ opz. EMA14);    |
//|   - due ordini LIMITE: 1o appena oltre la EMA200 verso il      |
//|     prezzo, 2o oltre la EMA200 (overshoot); distanze in ATR;  |
//|   - SL 1*ATR oltre il 2o ordine; TP in R; parziale su EMA14 + |
//|     stop in pari; trailing su EMA14; blocco news;             |
//|   - cancella i pendenti non eseguiti (scadenza / cutoff H4).  |
//|                                                                  |
//|  NON automatizzato (discrezionale, come da guida): livelli      |
//|   Larry Williams, PTE Filter, conferma multi-timeframe, timing |
//|   intra-candela. Restano all'occhio umano.                     |
//|  DEMO. Nessuna garanzia.                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;   // TF operativo (guida: H4/D1, anche H1)

input group "=== EMA e distanza operativa ==="
input int    InpEmaPeriod  = 200;
input int    InpEma14Period = 14;          // primo target
input int    InpAtrPeriod  = 14;
input double InpMinDistAtr  = 0.3;         // prezzo non gia' sulla media (dist. minima)
input double InpMaxDistAtr  = 1.5;         // prezzo abbastanza vicino (dist. massima; guida ~50/70 pip)
input bool   InpUseEma14Bias = true;       // richiedi EMA14 dallo stesso lato (trend confermato)
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Filtro ADR-distanza (live Paolo, opt-in) ==="
input bool   InpUseAdrFilter = false; // opera solo se la dist. prezzo-EMA200 e' 'raggiungibile' vs ADR giornaliero
input int    InpAdrDays      = 50;    // giorni per l'ADR (average daily range)
input double InpAdrDistMin   = 0.0;   // dist. minima in frazioni di ADR (0 = nessun minimo)
input double InpAdrDistMax   = 0.8;   // dist. massima in frazioni di ADR (guida Paolo ~0,8x ADR)

input group "=== Ordini pendenti (limite) ==="
input double InpOrder1Atr   = 0.05; // 1o ordine: verso il prezzo, oltre la EMA200 di N*ATR (guida ~5 pip)
input double InpOrder2Atr   = 0.60; // 2o ordine: oltre la EMA200 (overshoot) di N*ATR (guida ~15 pip)
input bool   InpUseOrder2    = true;
input int    InpPendingExpiryBars = 6; // scadenza pendenti non eseguiti (barre del TF)

input group "=== Stop / target ==="
input double InpSLatr       = 1.0;  // SL = 1*ATR oltre il 2o ordine (guida)
input double InpMinRR       = 1.0;  // salta se RR < questo
input double InpTP_RR       = 2.0;  // TP finale in R
input double InpTP1_ATRmult = 0.0;  // 0 = TP1 su EMA14; altrimenti N*ATR
input double InpTP1Pct      = 50;
input bool   InpBreakeven   = true;
input bool   InpUseTrailing = true; // trailing su EMA14 dopo il 1o target

input group "=== Cutoff (H4 intraday: cancella se non entra) ==="
input bool   InpUseCutoff   = false; // guida H4: cancella pendenti alle 20:00 se non eseguiti
input int    InpCutoffHour  = 19;    // server (20:00 IT = 19:00 server)
input int    InpCutoffMin   = 0;

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;   // rischio % TOTALE (diviso tra gli ordini)
input int    InpMaxTradesPerDay = 0;

input group "=== Filtro notizie ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "EMA200 OTT";
input bool   InpFridayClose     = false;  // Chiudi tutto venerdi' prima della chiusura mercato (opt-in)
input int    InpFridayCloseHour  = 20;     // Ora SERVER del venerdi' oltre cui chiudo (20 server = 21 IT)
input long   InpMagic     = 971501;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int  hEma=INVALID_HANDLE, hEma14=INVALID_HANDLE, hAtr=INVALID_HANDLE;
datetime gLastBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[EMA200] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hEma  =iMA(_Symbol,InpTF,InpEmaPeriod,0,MODE_EMA,PRICE_CLOSE);
   hEma14=iMA(_Symbol,InpTF,InpEma14Period,0,MODE_EMA,PRICE_CLOSE);
   hAtr  =iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hEma==INVALID_HANDLE||hEma14==INVALID_HANDLE||hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. EMA%d bounce.",_Symbol,EnumToString(InpTF),InpEmaPeriod));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[3]={hEma,hEma14,hAtr};
   for(int i=0;i<3;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
//--- Chiusura del venerdi' (opt-in): chiude posizioni e pendenti MIEI per ticket (Hedge-safe)
bool FridayCloseCheck()
  {
   if(!InpFridayClose) return(false);
   MqlDateTime _t; TimeToStruct(TimeCurrent(),_t);
   if(_t.day_of_week!=5 || _t.hour<InpFridayCloseHour) return(false);
   for(int _i=OrdersTotal()-1;_i>=0;_i--){ ulong _o=OrderGetTicket(_i); if(_o>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) gTrade.OrderDelete(_o); }
   for(int _i=PositionsTotal()-1;_i>=0;_i--){ ulong _p=PositionGetTicket(_i); if(_p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) gTrade.PositionClose(_p); }
   return(true);
  }

void OnTick()
  {
   if(FridayCloseCheck()) return;   // venerdi' oltre l'ora: chiudo e non riapro
   ManageAll();
   CutoffCheck();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
double EmaVal(int handle){ double e[1]; if(CopyBuffer(handle,0,1,1,e)!=1) return(0); return(e[0]); }
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0); return(a[0]); }

//--- ADR: media del range giornaliero (high-low) sugli ultimi N giorni (live Paolo)
double AdrValue()
  {
   int n=InpAdrDays; if(n<1) n=1;
   double h[],l[];
   if(CopyHigh(_Symbol,PERIOD_D1,1,n,h)<n) return(0);
   if(CopyLow(_Symbol,PERIOD_D1,1,n,l)<n) return(0);
   double s=0; for(int i=0;i<n;i++) s+=(h[i]-l[i]);
   return(s/n);
  }

void OnNewBar()
  {
   if(HasPosition() || HasPending()) return;         // gia' impegnati
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double ema=EmaVal(hEma), atr=AtrVal();
   if(ema<=0 || atr<=0) return;
   double close1=iClose(_Symbol,InpTF,1);
   double dist=MathAbs(close1-ema);
   if(dist < InpMinDistAtr*atr || dist > InpMaxDistAtr*atr) return; // prezzo nella fascia utile
   if(InpUseAdrFilter)                                              // filtro ADR-distanza (live Paolo)
     {
      double adr=AdrValue();
      if(adr>0 && (dist < InpAdrDistMin*adr || dist > InpAdrDistMax*adr)) return;
     }

   bool up=(close1>ema);      // prezzo sopra EMA200 -> rimbalzo LONG; sotto -> SHORT
   if(up && !InpAllowLong) return;
   if(!up && !InpAllowShort) return;
   if(InpUseEma14Bias)
     {
      double e14=EmaVal(hEma14);
      if(e14>0 && ((up && e14<ema)||(!up && e14>ema))) return; // EMA14 deve confermare il lato
     }

   PlaceOrders(up,ema,atr);
  }

//+------------------------------------------------------------------+
//| Due ordini LIMITE vicino alla EMA200 per il rimbalzo             |
//+------------------------------------------------------------------+
void PlaceOrders(bool isLong,double ema,double atr)
  {
   double o1 = isLong ? NormalizePrice(ema+InpOrder1Atr*atr) : NormalizePrice(ema-InpOrder1Atr*atr);
   double o2 = isLong ? NormalizePrice(ema-InpOrder2Atr*atr) : NormalizePrice(ema+InpOrder2Atr*atr);
   double sl = isLong ? NormalizePrice(o2-InpSLatr*atr)      : NormalizePrice(o2+InpSLatr*atr);

   int nOrders = InpUseOrder2 ? 2 : 1;
   double riskPct = InpRiskPercent/nOrders;

   // 1o ordine
   PlaceLimit(isLong,o1,sl,riskPct,"1");
   // 2o ordine (overshoot)
   if(InpUseOrder2) PlaceLimit(isLong,o2,sl,riskPct,"2");
  }

void PlaceLimit(bool isLong,double px,double sl,double riskPct,string tag)
  {
   double risk=isLong?(px-sl):(sl-px);
   if(risk<=0){ Log("distanza SL non valida ("+tag+")."); return; }
   double rr=InpTP_RR; if(rr<InpMinRR) return;
   double tp = isLong ? NormalizePrice(px+risk*InpTP_RR) : NormalizePrice(px-risk*InpTP_RR);
   double lot=LotByRisk(risk,riskPct);
   if(lot<=0){ Log("lotto nullo ("+tag+")."); return; }
   datetime exp=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(InpTF);
   string cm=InpComment+(isLong?" L":" S")+tag;
   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_EMA200_Ottimizzato")) return;
   bool ok=isLong?gTrade.BuyLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,cm)
                 :gTrade.SellLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,cm);
   if(ok){ gTradesToday++; Log(StringFormat("%s LIMIT %s @ %s SL %s TP %s lot %.2f",
           isLong?"BUY":"SELL",tag,DoubleToString(px,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot)); }
   else Log("ordine "+tag+" fallito: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Gestione posizioni: parziale EMA14 + pari; trailing su EMA14     |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double e14=EmaVal(hEma14); double atr=AtrVal();

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
         else if(e14>0)                tgt=e14;
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

      if(InpUseTrailing && beDone && e14>0)
        {
         double n=NormalizePrice(e14);
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
   if(HasPosition()) return;                 // se e' entrato, si gestisce
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.hour*60+now.min < InpCutoffHour*60+InpCutoffMin) return;
   if(HasPending()){ CancelPendings(); Log("cutoff: pendenti non eseguiti cancellati."); }
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
