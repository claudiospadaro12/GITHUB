//+------------------------------------------------------------------+
//|                                             ABTG_PostNews.mq5     |
//|                                                                  |
//|  EA "POST-NEWS" (ECB / FOMC press conference) - MT5 TUTTO-IN-UNO |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Strategia POST-NEWS totalmente MECCANICA (Christian Bertacchi). |
//|  Su una conferenza stampa (ECB o FOMC), a un orario preciso,     |
//|  prende max/min delle due candele M5 di riferimento e piazza:   |
//|    BUY STOP = max + 3 pip, SELL STOP = min - 2 pip.             |
//|    OCO configurabile (InpUseOCO): al 1o scatto cancella l'altra. |
//|  Ogni ordine: TP 50 pip, SL 25 pip. Scadenza pendenti a orario. |
//|  Size col rischio calcolato su 50 pip (worst case doppio stop). |
//|  Un UNICO motore per ECB ed FOMC: cambiano solo i PRESET         |
//|  (simbolo, orari, magic). Vedi i .set ECB / FOMC.              |
//|                                                                  |
//|  ORARI IN ORA SERVER (BCM = ora italiana - 1). Aggiorna gli     |
//|  orari se cambia l'ora legale. DEMO. Nessuna garanzia.         |
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
input group "=== Orari (ORA SERVER = ora italiana - 1) ==="
input int    InpActionHour = 14;   // Ora d'azione (server): quando calcola il range e piazza
input int    InpActionMin  = 0;    // ECB: 15:00 IT = 14:00 server. FOMC (news+10): imposta di conseguenza
input int    InpExpiryHour = 17;   // Ora scadenza pendenti (server). ECB: 18:15 IT = 17:15 server
input int    InpExpiryMin  = 15;   // FOMC: news+75min (in server)

input group "=== Restrizione ai giorni della notizia ==="
input bool   InpRestrictToNews = true; // opera SOLO se c'e' la notizia nel CSV (backtest e sicurezza live)
input bool   InpUseNewsFilter  = true; // carica il CSV degli eventi (date ECB/FOMC)
input string InpNewsFile       = "abtg_news.csv";
input int    InpNewsMinImpact  = 3;
input string InpNewsCurrencies = "EUR"; // ECB=EUR, FOMC=USD
input string InpNewsTitleMatch = "ECB"; // il titolo dell'evento deve contenerlo (ECB / FOMC)
input int    InpNewsShiftMinutes = 0;

input group "=== Ordini pendenti ==="
input double InpBuyOffsetPips  = 3.0;  // BUY STOP = max + 3 pip
input double InpSellOffsetPips = 3.0;  // SELL STOP = min - 3 pip (strategia: 3 pip)
input double InpTPpips         = 50.0; // take profit (pip)
input double InpSLpips         = 25.0; // stop loss (pip)
input bool   InpUseOCO         = true; // OCO: al 1o ordine che scatta, cancella l'altra gamba
input bool   InpCloseAtExpiry  = true; // chiudi la posizione all'orario di scadenza (21:45 IT), come da strategia

input group "=== Trailing (solo ECB) ==="
input bool   InpUseTrail25     = true; // se +25 pip di profitto, accorcia lo SL
input double InpTrailTriggerPips = 25.0;
input double InpTrailNewSLpips   = 15.0; // nuovo SL (pip dal prezzo d'ingresso)

input group "=== Chiusura di fine settimana ==="
input bool   InpFridayClose    = true; // chiudi ordini ancora aperti venerdi sera
input int    InpFridayCloseHour = 21;  // server (22:50 IT = 21:50 server)
input int    InpFridayCloseMin  = 50;

input group "=== Rischio ==="
input double InpRiskPercent    = 3.0;  // rischio % (documento: 3%)
input double InpRiskRefSLpips  = 50.0; // riferimento SL per la size (50 = worst case doppio stop)

input group "=== Generali ==="
input string InpComment   = "ECB PostNews"; // commento ordini (ECB=... / FOMC=...) per riconoscerli
input long   InpMagic     = 771201;    // ECB=771201, FOMC=771202
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
datetime gLastBar=0;
int      gPlacedDay=-1;
int      gNewsLoadedDay=-1;   // giorno in cui ho letto il file news l'ultima volta

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; string gNewsTitle[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[PostNews] ", m); }

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
   MqlDateTime _di; TimeToStruct(TimeCurrent(),_di); gNewsLoadedDay=_di.day_of_year;
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. Azione %02d:%02d server, scadenza %02d:%02d server. 1 pip=%.5f",
       _Symbol,InpActionHour,InpActionMin,InpExpiryHour,InpExpiryMin,PipSize()));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){}

//+------------------------------------------------------------------+
void OnTick()
  {
   // Ricarica il file news una volta al giorno: l'agente lo aggiorna ogni
   // mattina, cosi' l'EA vede sempre gli eventi nuovi senza riavviarlo.
   MqlDateTime _tc; TimeToStruct(TimeCurrent(),_tc);
   if(InpUseNewsFilter && _tc.day_of_year!=gNewsLoadedDay)
     { LoadNews(); gNewsLoadedDay=_tc.day_of_year; }

   OcoCheck();
   ManageTrailing();
   ExpiryCloseCheck();
   FridayCloseCheck();

   datetime t0=iTime(_Symbol,PERIOD_M5,0);
   if(t0==gLastBar) return;
   gLastBar=t0;

   MqlDateTime now; TimeToStruct(t0,now);
   // barra d'azione = quella che si apre all'orario impostato
   if(now.hour!=InpActionHour || now.min!=InpActionMin) return;
   if(now.day_of_year==gPlacedDay) return;             // gia' operato oggi
   //--- GUARDIA ANTI-DUPLICATO (reload-safe)
   { bool _has=false;
     for(int _i=OrdersTotal()-1;_i>=0 && !_has;_i--){ ulong _t=OrderGetTicket(_i); if(_t>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) _has=true; }
     for(int _j=PositionsTotal()-1;_j>=0 && !_has;_j--){ ulong _p=PositionGetTicket(_j); if(_p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) _has=true; }
     if(_has){ gPlacedDay=now.day_of_year; return; } }

   if(InpRestrictToNews && !NewsToday(t0)){ Log("nessuna notizia nel CSV oggi: niente ordini."); return; }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return; }

   PlaceOrders(t0);
   gPlacedDay=now.day_of_year;
  }

//+------------------------------------------------------------------+
//| Oggi e' giorno di evento? (stessa DATA + valuta + impatto)       |
//| Match sul giorno, non sull'ora: robusto a convenzioni orarie del |
//| CSV. Il QUANDO operare e' dato da InpActionHour/Min.            |
//+------------------------------------------------------------------+
bool NewsToday(datetime nowBar)
  {
   if(!InpUseNewsFilter || gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   MqlDateTime a; TimeToStruct(nowBar,a);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(StringLen(InpNewsTitleMatch)>0 && StringFind(gNewsTitle[i],InpNewsTitleMatch)<0) continue;
      MqlDateTime e; TimeToStruct(gNewsTime[i],e);
      if(e.year==a.year && e.mon==a.mon && e.day==a.day) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Piazza i due ordini pendenti sul range delle candele [1] e [2]   |
//+------------------------------------------------------------------+
void PlaceOrders(datetime nowBar)
  {
   double pip=PipSize();
   double h1=iHigh(_Symbol,PERIOD_M5,1), h2=iHigh(_Symbol,PERIOD_M5,2);
   double l1=iLow(_Symbol,PERIOD_M5,1),  l2=iLow(_Symbol,PERIOD_M5,2);
   double hi=MathMax(h1,h2), lo=MathMin(l1,l2);
   if(hi<=0 || lo<=0 || hi<=lo){ Log("range non valido."); return; }

   double buyPx =NormalizePrice(hi+InpBuyOffsetPips*pip);
   double sellPx=NormalizePrice(lo-InpSellOffsetPips*pip);
   double buySL =NormalizePrice(buyPx-InpSLpips*pip),  buyTP=NormalizePrice(buyPx+InpTPpips*pip);
   double sellSL=NormalizePrice(sellPx+InpSLpips*pip), sellTP=NormalizePrice(sellPx-InpTPpips*pip);

   double lot=LotByRisk(InpRiskRefSLpips*pip);
   if(lot<=0){ Log("lotto nullo."); return; }

   // scadenza: oggi all'orario server impostato
   MqlDateTime e; TimeToStruct(nowBar,e); e.hour=InpExpiryHour; e.min=InpExpiryMin; e.sec=0;
   datetime exp=StructToTime(e);
   if(exp<=TimeCurrent()) exp=TimeCurrent()+3600;      // salvaguardia

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double minStop=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_PostNews")) return;
   string cBuy=InpComment+" BUY", cSell=InpComment+" SELL";
   // BUY STOP valido solo se sopra il prezzo attuale (+ stops level)
   if(buyPx>ask+minStop)
     {
      if(gTrade.BuyStop(lot,buyPx,_Symbol,buySL,buyTP,ORDER_TIME_SPECIFIED,exp,cBuy))
         Log(StringFormat("BUY STOP @ %s SL %s TP %s lot %.2f",DoubleToString(buyPx,_Digits),
             DoubleToString(buySL,_Digits),DoubleToString(buyTP,_Digits),lot));
      else Log("BUY STOP fallito: "+gTrade.ResultRetcodeDescription());
     }
   else Log("prezzo gia' sopra il range: niente BUY STOP.");

   // SELL STOP valido solo se sotto il prezzo attuale (- stops level)
   if(sellPx<bid-minStop)
     {
      if(gTrade.SellStop(lot,sellPx,_Symbol,sellSL,sellTP,ORDER_TIME_SPECIFIED,exp,cSell))
         Log(StringFormat("SELL STOP @ %s SL %s TP %s lot %.2f",DoubleToString(sellPx,_Digits),
             DoubleToString(sellSL,_Digits),DoubleToString(sellTP,_Digits),lot));
      else Log("SELL STOP fallito: "+gTrade.ResultRetcodeDescription());
     }
   else Log("prezzo gia' sotto il range: niente SELL STOP.");
  }

//+------------------------------------------------------------------+
//| OCO: appena una gamba diventa POSIZIONE, cancella il pendente    |
//| dell'altra gamba (stesso magic). Un solo trade per evento.       |
//+------------------------------------------------------------------+
void OcoCheck()
  {
   if(!InpUseOCO) return;
   // ho una posizione aperta del mio magic?
   bool hasPos=false;
   for(int i=PositionsTotal()-1;i>=0 && !hasPos;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         hasPos=true;
     }
   if(!hasPos) return;
   // si': cancello ogni pendente residuo del mio magic (l'altra gamba)
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic)
        { if(gTrade.OrderDelete(tk)) Log("OCO: cancellata la gamba opposta (ticket "+(string)tk+")."); }
     }
  }

//+------------------------------------------------------------------+
//| Trailing ECB: se +Trigger pip di profitto, accorcia lo SL        |
//+------------------------------------------------------------------+
void ManageTrailing()
  {
   if(!InpUseTrail25) return;
   double pip=PipSize();
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double profitPips = isLong ? (bid-openP)/pip : (openP-ask)/pip;
      if(profitPips < InpTrailTriggerPips) continue;
      double newSL = isLong ? NormalizePrice(openP-InpTrailNewSLpips*pip)
                            : NormalizePrice(openP+InpTrailNewSLpips*pip);
      if(isLong && newSL>sl) gTrade.PositionModify(tk,newSL,PositionGetDouble(POSITION_TP));
      if(!isLong && (newSL<sl||sl==0)) gTrade.PositionModify(tk,newSL,PositionGetDouble(POSITION_TP));
     }
  }

//+------------------------------------------------------------------+
//| Chiude TUTTE le mie posizioni e cancella i miei pendenti         |
//+------------------------------------------------------------------+
int CloseAllMine()
  {
   int acted=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic)
        { if(gTrade.OrderDelete(t)) acted++; }
     }
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong t=PositionGetTicket(i);
      if(t==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
        { if(gTrade.PositionClose(t)) acted++; }
     }
   return(acted);
  }

//+------------------------------------------------------------------+
//| Chiusura a SCADENZA (strategia: tenere fino alle 21:45 IT =      |
//| 20:45 server, poi chiudere). Chiude SEMPRE la posizione aperta   |
//| se non e' gia' andata a TP/SL, e cancella i pendenti residui.    |
//+------------------------------------------------------------------+
void ExpiryCloseCheck()
  {
   if(!InpCloseAtExpiry) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   int nowMin = now.hour*60+now.min;
   int expMin = InpExpiryHour*60+InpExpiryMin;
   // finestra: dall'orario di scadenza fino a fine giornata (evita di
   // toccare le posizioni prima della scadenza; l'azione e' alle 19:40).
   if(nowMin < expMin) return;
   if(CloseAllMine()>0)
      Log(StringFormat("scadenza %02d:%02d server: chiuse posizioni/pendenti (fine finestra strategia).",
          InpExpiryHour,InpExpiryMin));
  }

//+------------------------------------------------------------------+
//| Chiusura venerdi sera: niente ordini/posizioni nel weekend       |
//+------------------------------------------------------------------+
void FridayCloseCheck()
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_week!=5) return;                       // 5 = venerdi
   if(now.hour*60+now.min < InpFridayCloseHour*60+InpFridayCloseMin) return;
   CloseAllMine();
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

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0); ArrayResize(gNewsTitle,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: il filtro non fara' partire ordini se InpRestrictToNews=true."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      string sTitle=FileIsLineEnding(h)?"":FileReadString(h);   // 4a colonna = titolo
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1); ArrayResize(gNewsTitle,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsTitle[n]=sTitle; gNewsCount=n+1;
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
