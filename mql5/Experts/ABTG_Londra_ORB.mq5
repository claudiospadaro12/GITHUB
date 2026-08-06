//+------------------------------------------------------------------+
//|                                          ABTG_Londra_ORB.mq5      |
//|                                                                  |
//|  EA "STRATEGIA MERCATI DI LONDRA" - MT5 - VERSIONE TUTTO-IN-UNO  |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sul documento "Strategia Operativa Mercati di Londra":  |
//|   - Cross GBP/USD, apertura sessione di Londra.                 |
//|   - RANGE: max/min dell'ora PRIMA dell'apertura di Londra       |
//|     (07:00-08:00 CET). Orari qui in ORA SERVER.                 |
//|   - ORDINI (OCO): BUY STOP 3 pip sopra il max, SELL STOP 3 pip  |
//|     sotto il min. Parte uno -> cancella l'altro.               |
//|   - STOP LOSS: centro del canale (punto medio del range).      |
//|   - TAKE PROFIT: ingresso +/- ampiezza del canale (R:R > 1:1).  |
//|   - Variante prudente: SL all'estremo opposto + size dimezzata. |
//|   - Precondizione: giornate SENZA news macro rilevanti.        |
//|                                                                  |
//|  NON automatizzato (occhio umano, come da documento):           |
//|     validazione S/R su H1/H4/D1 nell'area di breakout.          |
//|  Orari in ORA SERVER (BCM = ora italiana - 1). DEMO. Nessun    |
//|  EA garantisce profitti.                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

enum ENUM_LDN_SL { LDN_SL_MIDPOINT=0, LDN_SL_OPPOSITE=1 };

//==================================================================
//  INPUT
//==================================================================
input group "=== Finestra del range (ORA SERVER!) ==="
input int    InpRangeStartHour = 6;   // Inizio range (server). BCM: 6 = 07:00 CET
input int    InpRangeStartMin  = 0;
input int    InpRangeEndHour   = 7;   // Fine range = apertura Londra (server). BCM: 7 = 08:00 CET
input int    InpRangeEndMin    = 0;
input double InpMinRangePips   = 0;   // Ampiezza minima del range in pip (0=off; filtro anti-lateralita')
input double InpMaxRangePips   = 0;   // Ampiezza massima del range in pip (0=off; salta giorni troppo volatili)

input group "=== Piazzamento / chiusura (ORA SERVER) ==="
input int    InpPlaceHour      = 7;   // Ora piazzamento ordini (= fine range). BCM: 7 = 08:00 CET
input int    InpPlaceMin       = 0;
input int    InpEntryCutoffHour = 11; // CUTOFF: dopo, cancella i pendenti non scattati (no rincorsa)
input int    InpEntryCutoffMin  = 0;  // BCM: 11 = 12:00 CET
input int    InpCloseHour      = 17;  // Flat/cancella a fine finestra (server). BCM: 17 = 18:00 CET
input int    InpCloseMin       = 0;
input bool   InpCloseAtEnd     = true;// Chiudi la posizione residua a fine finestra
input bool   InpOneTradePerDay = true;// Un solo ciclo di trade al giorno
input int    InpPendingExpiryMin = 240; // Scadenza del pendente non eseguito (minuti)

input group "=== Ingresso ==="
input double InpBufferPips     = 3.0; // Pip oltre max/min (documento: 3 pip)
input bool   InpAllowLong      = true;
input bool   InpAllowShort     = true;

input group "=== Stop loss / take profit ==="
input ENUM_LDN_SL InpSLMode    = LDN_SL_MIDPOINT; // MIDPOINT=centro canale (fedele) / OPPOSITE=estremo opposto (prudente)
input bool   InpHalveOnOpposite = true; // In modalita' OPPOSITE dimezza la size (come da documento)
input double InpTPRangeMult    = 1.0; // TP = ingresso +/- (ampiezza canale * questo). Documento: 1.0

input group "=== Gestione opzionale (default OFF = fedele al documento) ==="
input bool   InpUsePartial     = false; // Parziale al 1o target
input double InpTP1_R          = 1.0;   // 1o target in R (rischio)
input double InpTP1Pct         = 50;    // % chiusa al 1o target
input bool   InpBreakeven      = false; // Stop in pari dopo la parziale
input bool   InpUseTrailing    = false; // Trailing su ATR
input ENUM_TIMEFRAMES InpTrailTF = PERIOD_M15;
input int    InpAtrPeriod      = 14;
input double InpTrailAtrMult   = 2.0;

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0; // Rischio per trade in %

input group "=== Filtro notizie (CSV in MQL5/Files) - la strategia vuole giorni SENZA news ==="
input bool   InpUseNewsFilter  = false;
input string InpNewsFile       = "abtg_news.csv";
input int    InpNewsMinImpact  = 3;
input int    InpNewsBeforeMin   = 60;
input int    InpNewsAfterMin    = 60;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies  = "GBP,USD";

input group "=== Generali ==="
input string InpComment   = "LONDRA ORB";
input long   InpMagic     = 770701;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE;
enum ENUM_LPHASE { LP_WAIT, LP_PLACED, LP_DONE };
ENUM_LPHASE gPhase=LP_WAIT;
int      gDay=-1;
double   gHigh=0, gLow=0;
bool     gPart1=false;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[Londra_ORB] ", m); }

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
   hAtr=iATR(_Symbol,InpTrailTF,InpAtrPeriod);
   if(hAtr==INVALID_HANDLE){ Print("ERRORE: handle ATR."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. Range server %02d:%02d-%02d:%02d, piazzo %02d:%02d, cutoff %02d:%02d, flat %02d:%02d. 1 pip=%.5f",
       _Symbol,InpRangeStartHour,InpRangeStartMin,InpRangeEndHour,InpRangeEndMin,
       InpPlaceHour,InpPlaceMin,InpEntryCutoffHour,InpEntryCutoffMin,InpCloseHour,InpCloseMin,PipSize()));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManagePos();
   HandleOCO();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   bool newsBlk = InNewsBlackout(TimeCurrent());
   if(newsBlk){ CancelPendings(); if(SelPos()) gTrade.PositionClose(_Symbol); }

   int nowMin=now.hour*60+now.min;
   if(nowMin >= InpCloseHour*60+InpCloseMin){ EndOfDay(); return; }

   //--- CUTOFF ingressi: cancella i pendenti non scattati (no rincorsa tardiva)
   if(gPhase==LP_PLACED && !SelPos() && nowMin >= InpEntryCutoffHour*60+InpEntryCutoffMin)
     {
      CancelPendings(); gPhase=LP_DONE;
      Log("cutoff ingressi superato: pendenti non eseguiti cancellati.");
      return;
     }

   if(gPhase==LP_WAIT && nowMin >= InpPlaceHour*60+InpPlaceMin)
     {
      if(newsBlk){ Log("news in corso: niente ordini oggi."); return; }
      if(TryPlace()) gPhase=LP_PLACED;
     }
  }

void ResetDay(){ gPhase=LP_WAIT; gHigh=0; gLow=0; gPart1=false; Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Max/min della finestra del range (stesso giorno, no mezzanotte)  |
//+------------------------------------------------------------------+
bool ComputeRange(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpRangeStartHour; t.min=InpRangeStartMin; datetime tStart=StructToTime(t);
   t.hour=InpRangeEndHour;   t.min=InpRangeEndMin;   datetime tEnd=StructToTime(t);
   if(tEnd<=tStart) return(false);

   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   return(hi>0 && lo>0 && hi>lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti OCO sul range di Londra               |
//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeRange(gHigh,gLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }

   double pip=PipSize();
   double widthPips=(gHigh-gLow)/pip;
   if(InpMinRangePips>0 && widthPips<InpMinRangePips){ Log(StringFormat("range %.1f pip < min: niente trade.",widthPips)); return(true); }
   if(InpMaxRangePips>0 && widthPips>InpMaxRangePips){ Log(StringFormat("range %.1f pip > max: niente trade.",widthPips)); return(true); }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double buf=InpBufferPips*pip;
   double mid=(gHigh+gLow)/2.0;
   double width=gHigh-gLow;
   double buyPx =NormalizePrice(gHigh+buf);
   double sellPx=NormalizePrice(gLow -buf);
   datetime exp=TimeCurrent()+InpPendingExpiryMin*60;
   bool halve=(InpSLMode==LDN_SL_OPPOSITE && InpHalveOnOpposite);

   double minStop=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;

   if(InpAllowLong)
     {
      double sl=NormalizePrice(InpSLMode==LDN_SL_MIDPOINT ? mid : gLow);
      double tp=NormalizePrice(buyPx + width*InpTPRangeMult);
      double dist=buyPx-sl;
      if(dist>minStop)
        {
         double lot=LotByRisk(dist); if(halve) lot=NormVol(lot*0.5);
         if(lot>0 && gTrade.BuyStop(lot,buyPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" BUY"))
            Log(StringFormat("BUY STOP @ %s SL %s TP %s lot %.2f (range %.1f pip)",
                DoubleToString(buyPx,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot,widthPips));
         else if(lot<=0) Log("lotto nullo (long).");
        }
      else Log("distanza SL long non valida.");
     }
   if(InpAllowShort)
     {
      double sl=NormalizePrice(InpSLMode==LDN_SL_MIDPOINT ? mid : gHigh);
      double tp=NormalizePrice(sellPx - width*InpTPRangeMult);
      double dist=sl-sellPx;
      if(dist>minStop)
        {
         double lot=LotByRisk(dist); if(halve) lot=NormVol(lot*0.5);
         if(lot>0 && gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" SELL"))
            Log(StringFormat("SELL STOP @ %s SL %s TP %s lot %.2f (range %.1f pip)",
                DoubleToString(sellPx,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot,widthPips));
         else if(lot<=0) Log("lotto nullo (short).");
        }
      else Log("distanza SL short non valida.");
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Gestione posizione (opzionale): parziale, breakeven, trailing    |
//+------------------------------------------------------------------+
void ManagePos()
  {
   if(!SelPos()) return;
   if(!InpUsePartial && !InpUseTrailing) return;   // default: TP/SL fissi, niente gestione

   long   type=PositionGetInteger(POSITION_TYPE);
   bool   isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double tp=PositionGetDouble(POSITION_TP);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong  ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   double risk=isLong?(openP-sl):(sl-openP);

   if(InpUsePartial && !gPart1 && risk>0 && InpTP1Pct>0 && InpTP1Pct<100)
     {
      double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
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
         if(beFatto) gTrade.PositionModify(_Symbol,bePari,tp);
         if(parzOK || beFatto)
            Log(parzOK ? "1o target: parziale + stop in pari."
                       : "1o target: stop in pari (parziale impossibile al lotto minimo).");
        }
     }
   if(InpUseTrailing)
     {
      double a[1];
      if(CopyBuffer(hAtr,0,1,1,a)==1 && a[0]>0)
        {
         if(isLong){ double n=NormalizePrice(bid-a[0]*InpTrailAtrMult); if(n>sl && n>openP) gTrade.PositionModify(_Symbol,n,PositionGetDouble(POSITION_TP)); }
         else      { double n=NormalizePrice(ask+a[0]*InpTrailAtrMult); if((n<sl||sl==0)&&n<openP) gTrade.PositionModify(_Symbol,n,PositionGetDouble(POSITION_TP)); }
        }
     }
  }

//+------------------------------------------------------------------+
//| OCO: se una posizione e' aperta, cancella i pendenti             |
//+------------------------------------------------------------------+
void HandleOCO(){ if(SelPos()) CancelPendings(); }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

void EndOfDay()
  {
   CancelPendings();
   if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(_Symbol); Log("fine finestra: posizione chiusa."); }
   gPhase=LP_DONE;
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
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

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
