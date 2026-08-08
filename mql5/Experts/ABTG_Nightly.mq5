//+------------------------------------------------------------------+
//|                                             ABTG_Nightly.mq5      |
//|                                                                  |
//|  EA "NIGHTLY" (fade box notturno) - MT5 - TUTTO-IN-UNO        |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sulla Strategia NIGHTLY (ABTG).                        |
//|  Sfrutta il range della sessione asiatica (box notturno) con    |
//|  ordini LIMITE ai bordi (fade / mean-reversion): SELL LIMIT sul |
//|  MAX notte, BUY LIMIT sul MIN notte, attendendo il rientro.    |
//|  Diverso dal MaxMinNotte (breakout con ordini stop).          |
//|                                                                  |
//|  AUTOMATIZZATO (cuore meccanico):                              |
//|   - box max/min notturno (finestra oraria configurabile);     |
//|   - LIMIT ai bordi (bordo stretto = aggressivo, esteso =       |
//|     conservativo) con SL oltre il box e TP verso il centro;   |
//|   - filtro volatilita' notturna QB (media candele H1);        |
//|   - esclusione cross con mercati attivi di notte (JPY/AUD/NZD);|
//|   - cancella i pendenti non eseguiti entro l'orario di cutoff. |
//|                                                                  |
//|  NON automatizzato (proprietario/discrezionale): box "medio 5  |
//|   mesi" e QB dell'indicatore ABTG-Nightly, Multipivot.        |
//|  Orari in ORA SERVER (BCM = ora italiana - 1). DEMO.          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Box notturno (ORA SERVER!) ==="
input int    InpBoxStartHour = 22;  // inizio box (server). Doc: 22:00 broker
input int    InpBoxStartMin  = 0;
input int    InpBoxEndHour   = 4;   // fine box (server). Doc: 04:59 broker
input int    InpBoxEndMin    = 59;
input int    InpPlaceHour    = 5;   // ora piazzamento ordini (server), dopo la chiusura del box
input int    InpPlaceMin     = 0;
input int    InpCutoffHour   = 7;   // cancella pendenti non eseguiti (server). Doc: entro le 07:00
input int    InpCutoffMin    = 0;
input bool   InpCloseAtCutoff = false; // chiudi anche le posizioni al cutoff (fine notte)

input group "=== Ingresso (fade ai bordi del box) ==="
input bool   InpAllowLong  = true;  // BUY LIMIT sul MIN notte
input bool   InpAllowShort = true;  // SELL LIMIT sul MAX notte
input double InpEdgeOffsetPips = 0; // scostamento dall'estremo (0=sul bordo; >0=conservativo, piu' esterno)
input bool   InpOneShotPerNight = true; // un solo set di ordini per notte

input group "=== Stop / target ==="
input double InpSLpips      = 0;    // SL oltre il box, in pip (0 = usa ATR)
input int    InpAtrPeriod   = 14;
input double InpSLatrMult    = 1.0; // se InpSLpips=0: SL = N*ATR oltre il bordo
input double InpTPfrac       = 0.5; // TP = frazione del range verso il centro (0.5 = meta')

input group "=== Filtri QB (volatilita' notturna) ==="
input double InpMaxNightVolPips = 45; // escludi se la media candele H1 notte >= N pip (doc: QB>=45)
input double InpMinRangePips     = 0; // range minimo del box (0=off)
input double InpMaxRangePips     = 0; // range massimo del box (0=off; box gia' "esploso")
input bool   InpBlockNightActive = true; // escludi JPY/AUD/NZD (mercati attivi di notte)

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0; // rischio % per ordine

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 60;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "NIGHTLY";
input long   InpMagic     = 771701;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int      hAtrH1=INVALID_HANDLE;
enum ENUM_NPHASE { NP_WAIT, NP_PLACED, NP_DONE };
ENUM_NPHASE gPhase=NP_WAIT;
int      gDay=-1;
double   gBoxHigh=0, gBoxLow=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[Nightly] ", m); }

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
   hAtrH1=iATR(_Symbol,PERIOD_H1,InpAtrPeriod);
   if(hAtrH1==INVALID_HANDLE){ Print("ERRORE: handle ATR H1."); return(INIT_FAILED); }
   if(InpBlockNightActive && NightActiveSymbol())
      Log("ATTENZIONE: "+_Symbol+" contiene JPY/AUD/NZD (mercato attivo di notte): la strategia lo sconsiglia.");
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s. Box server %02d:%02d-%02d:%02d, piazzo %02d:%02d, cutoff %02d:%02d.",
       _Symbol,InpBoxStartHour,InpBoxStartMin,InpBoxEndHour,InpBoxEndMin,InpPlaceHour,InpPlaceMin,InpCutoffHour,InpCutoffMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){ if(hAtrH1!=INVALID_HANDLE) IndicatorRelease(hAtrH1); }

//+------------------------------------------------------------------+
bool NightActiveSymbol()
  {
   string s=_Symbol; StringToUpper(s);
   return(StringFind(s,"JPY")>=0 || StringFind(s,"AUD")>=0 || StringFind(s,"NZD")>=0);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gPhase=NP_WAIT; gBoxHigh=0; gBoxLow=0; }

   int nowMin=now.hour*60+now.min;

   // cutoff: cancella i pendenti non eseguiti (e opz. chiudi posizioni)
   if(nowMin >= InpCutoffHour*60+InpCutoffMin)
     {
      if(HasPending()){ CancelPendings(); Log("cutoff: pendenti non eseguiti cancellati."); }
      if(InpCloseAtCutoff) CloseAllPositions();
      if(gPhase==NP_PLACED) gPhase=NP_DONE;
      return;
     }

   // piazzamento (una volta a notte)
   //--- GUARDIA ANTI-DUPLICATO (reload-safe): pendente/posizione del mio magic -> non ripiazzo
   if(gPhase==NP_WAIT)
     {
      bool _has=false;
      for(int _i=OrdersTotal()-1;_i>=0 && !_has;_i--){ ulong _t=OrderGetTicket(_i); if(_t>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) _has=true; }
      for(int _j=PositionsTotal()-1;_j>=0 && !_has;_j--){ ulong _p=PositionGetTicket(_j); if(_p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) _has=true; }
      if(_has) gPhase=NP_DONE;
     }
   if(gPhase==NP_WAIT && nowMin >= InpPlaceHour*60+InpPlaceMin)
     {
      if(InpBlockNightActive && NightActiveSymbol()){ gPhase=NP_DONE; return; }
      if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())){ Log("news: niente ordini."); gPhase=NP_DONE; return; }
      if(TryPlace()){ gPhase=(InpOneShotPerNight?NP_PLACED:NP_WAIT); }
     }
  }

//+------------------------------------------------------------------+
//| Calcola max/min del box notturno (gestisce lo scavalco mezzanotte)|
//+------------------------------------------------------------------+
bool ComputeBox(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpBoxEndHour;   t.min=InpBoxEndMin;   datetime tEnd=StructToTime(t);
   t.hour=InpBoxStartHour; t.min=InpBoxStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;              // box iniziato il giorno prima (notte)

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

//--- QB: media dell'estensione delle candele H1 durante la notte (in pip)
double NightH1Vol()
  {
   double a[1]; if(CopyBuffer(hAtrH1,0,1,1,a)!=1||a[0]<=0) return(0);
   return(a[0]/PipSize());
  }

//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeBox(gBoxHigh,gBoxLow)){ Log("box non calcolabile: riprovo."); return(false); }
   double pip=PipSize();
   double rangePips=(gBoxHigh-gBoxLow)/pip;

   // filtri QB
   double qb=NightH1Vol();
   if(InpMaxNightVolPips>0 && qb>=InpMaxNightVolPips){ Log(StringFormat("QB alto (%.1f>=%.0f): escluso.",qb,InpMaxNightVolPips)); return(true); }
   if(InpMinRangePips>0 && rangePips<InpMinRangePips){ Log("range troppo stretto: niente trade."); return(true); }
   if(InpMaxRangePips>0 && rangePips>InpMaxRangePips){ Log("range gia' esploso: niente trade."); return(true); }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double range=gBoxHigh-gBoxLow;
   double off=InpEdgeOffsetPips*pip;
   double slDist = InpSLpips>0 ? InpSLpips*pip : InpSLatrMult*(qb>0?qb*pip:range);
   MqlDateTime et; TimeToStruct(TimeCurrent(),et); et.sec=0; et.hour=InpCutoffHour; et.min=InpCutoffMin;
   datetime exp=StructToTime(et);               // scade al cutoff

   // SELL LIMIT sul MAX notte (fade verso il basso)
   if(InpAllowShort)
     {
      double px=NormalizePrice(gBoxHigh+off);
      double sl=NormalizePrice(px+slDist);
      double tp=NormalizePrice(px-range*InpTPfrac);
      double lot=LotByRisk(px,sl,false);
      if(lot>0 && gTrade.SellLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" S"))
         Log(StringFormat("SELL LIMIT @ %s SL %s TP %s lot %.2f (range %.1f pip, QB %.1f)",
             DoubleToString(px,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot,rangePips,qb));
     }
   // BUY LIMIT sul MIN notte (fade verso l'alto)
   if(InpAllowLong)
     {
      double px=NormalizePrice(gBoxLow-off);
      double sl=NormalizePrice(px-slDist);
      double tp=NormalizePrice(px+range*InpTPfrac);
      double lot=LotByRisk(px,sl,true);
      if(lot>0 && gTrade.BuyLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" L"))
         Log(StringFormat("BUY LIMIT @ %s SL %s TP %s lot %.2f",
             DoubleToString(px,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits),lot));
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

double LotByRisk(double entry,double sl,bool isLong)
  {
   double slDist=isLong?(entry-sl):(sl-entry);
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

void CloseAllPositions()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) gTrade.PositionClose(tk);
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
