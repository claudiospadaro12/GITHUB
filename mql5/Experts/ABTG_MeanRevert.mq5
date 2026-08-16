//+------------------------------------------------------------------+
//|                                            ABTG_MeanRevert.mq5   |
//|  FADE DELL'ESTREMO: si compra il minimo di N barre e si punta al  |
//|  centro del range. Lo short e' lo specchio esatto.                |
//+------------------------------------------------------------------+
//  ORIGINE E ATTRIBUZIONE
//    Meccanica derivata da "MeanReversion.mq5" di Yashar Seyyedin
//    https://www.mql5.com/en/users/yashar.seyyedin  (135 righe, 2 input)
//    Trovato nel setaccio manuale del 16/08/2026:
//    backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md
//
//  COSA ABBIAMO PRESO: la tesi e la meccanica (estremo di N barre ->
//  ritorno al punto medio, stop simmetrico, R:R 1:1).
//  COSA NON ABBIAMO PRESO: i suoi parametri. Il verdetto lo da' il
//  nostro imbuto, non l'autore.
//
//  LE SEI CORREZIONI RISPETTO ALL'ORIGINALE (tutte dichiarate)
//    1. decide su BARRE CHIUSE (shift 1), non sulla barra in formazione:
//       nell'originale l'ingresso dipende dal momento dentro la candela,
//       e R57 ha misurato che cambiando SOLO il modello del tester il
//       segno si ribalta. Questa e' una DIFFERENZA di comportamento,
//       non un abbellimento, ed e' scritta qui apposta.
//    2. posizioni contate per SIMBOLO + MAGIC (l'originale usa
//       PositionsTotal(), che e' di CONTO: sul nostro conto con la
//       flotta accesa non aprirebbe mai).
//    3. MAGIC NUMBER impostato (l'originale lascia 0 = indistinguibile
//       da un'operazione manuale).
//    4. sizing corretto: si prende il lotto piu' grande che sta DENTRO
//       il budget di rischio. L'originale restituisce il primo che lo
//       SUPERA, quindi rischia sempre un po' piu' del dichiarato.
//    5. volume arrotondato allo step e verificato (nell'originale
//       NormalizeVolume() e' codice morto: irraggiungibile).
//    6. OnTester + export OPTFRAME, altrimenti il driver non parte.
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property description "Fade dell'estremo di N barre verso il punto medio del range. Simmetrico."

#include <Trade\Trade.mqh>

//--- LA STRATEGIA: una manopola sola, ed e' questa.
input ENUM_TIMEFRAMES InpTF            = PERIOD_H1;  // Timeframe di lavoro
input int             InpLookback      = 200;        // Barre del range (LA manopola)
//--- rischio
input double          InpRiskPercent   = 1.0;        // Rischio per operazione (%)
//--- i due lati, misurabili separatamente: meta' del motivo per cui esiste
input bool            InpAllowLong     = true;       // Abilita i long
input bool            InpAllowShort    = true;       // Abilita gli short
//--- guardie e convenzioni di casa
input int             InpMaxSpreadPts  = 0;          // Spread massimo in punti (0 = nessun limite)
input string          InpComment       = "MREV";     // Commento degli ordini
input long            InpMagic         = 773101;     // Magic number
input bool            InpVerbose       = false;      // Log dettagliato

CTrade   gTrade;
datetime gLastBar = 0;

//--- METRICHE DA PROP: l'Equity DD dice se il conto sopravvive; una prop
//    chiude per il LIMITE GIORNALIERO, che e' un'altra cosa. Qui si segue
//    l'equity dentro la giornata e si tiene la caduta peggiore.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

//--- funnel di mortalita': se l'EA resta muto si deve sapere SUBITO perche'
long cB_bars=0, cF_data=0, cS_long=0, cS_short=0, cF_side=0, cF_busy=0;
long cO_spread=0, cO_failLevel=0, cO_failLot=0, cO_failMargin=0, cO_failSend=0;
long cI_long=0, cI_short=0;

void Log(string m){ if(InpVerbose) Print("[MREV] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpLookback < 10)
     { Print("InpLookback troppo piccolo (minimo 10)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpRiskPercent <= 0.0 || InpRiskPercent > 10.0)
     { Print("InpRiskPercent fuori scala (0 < r <= 10)."); return(INIT_PARAMETERS_INCORRECT); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("Entrambi i lati spenti: l'EA non opererebbe."); return(INIT_PARAMETERS_INCORRECT); }

   gTrade.SetExpertMagicNumber((ulong)InpMagic);
   gTrade.SetAsyncMode(false);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason) { }

//+------------------------------------------------------------------+
//| Quante posizioni NOSTRE (simbolo + magic) sono aperte             |
//| L'originale usa PositionsTotal(): di CONTO, non di simbolo.       |
//+------------------------------------------------------------------+
int NostrePosizioni()
  {
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      n++;
     }
   return(n);
  }

//+------------------------------------------------------------------+
//| Lotto: il PIU' GRANDE che sta DENTRO il budget di rischio.        |
//| L'originale restituisce il primo che lo SUPERA.                   |
//+------------------------------------------------------------------+
double LottoDaRischio(ENUM_ORDER_TYPE tipo, double entrata, double sl)
  {
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minl = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxl = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(step <= 0.0 || minl <= 0.0) return(0.0);

   double budget = AccountInfoDouble(ACCOUNT_BALANCE) * InpRiskPercent / 100.0;
   if(budget <= 0.0) return(0.0);

   //--- perdita col lotto minimo; il P/L e' lineare nel volume, quindi si scala
   double perdita_min = 0.0;
   if(!OrderCalcProfit(tipo, _Symbol, minl, entrata, sl, perdita_min)) return(0.0);
   perdita_min = MathAbs(perdita_min);
   if(perdita_min <= 0.0) return(0.0);

   double grezzo = minl * budget / perdita_min;

   //--- si arrotonda SEMPRE VERSO IL BASSO allo step: mai sforare per eccesso
   double lotti = MathFloor(grezzo / step + 1e-9) * step;
   int    dstep = (int)MathMax(0, MathRound(-MathLog10(step)));
   lotti = NormalizeDouble(lotti, dstep);

   if(lotti < minl) lotti = minl;            // sotto il minimo non si scende
   if(lotti > maxl) lotti = NormalizeDouble(MathFloor(maxl / step + 1e-9) * step, dstep);

   //--- verifica vera, non stimata: se sfora, si scende di uno step per volta
   for(int g = 0; g < 200 && lotti > minl; g++)
     {
      double perdita = 0.0;
      if(!OrderCalcProfit(tipo, _Symbol, lotti, entrata, sl, perdita)) return(0.0);
      if(MathAbs(perdita) <= budget) break;
      lotti = NormalizeDouble(lotti - step, dstep);
     }

   //--- margine: se il lotto minimo non e' sostenibile, non si opera
   double margine = 0.0;
   if(!OrderCalcMargin(tipo, _Symbol, lotti, entrata, margine)) return(0.0);
   if(margine > AccountInfoDouble(ACCOUNT_MARGIN_FREE)) return(0.0);

   return(lotti);
  }

//+------------------------------------------------------------------+
//| SL e TP rispettano la distanza minima del broker?                 |
//+------------------------------------------------------------------+
bool LivelliValidi(ENUM_ORDER_TYPE tipo, double rif, double sl, double tp)
  {
   long stops = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double d = (double)stops * _Point;
   if(d <= 0.0) return(true);
   if(tipo == ORDER_TYPE_BUY)  return(rif - sl > d && tp - rif > d);
   else                        return(sl - rif > d && rif - tp > d);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- metrica da prop: sta QUI e non dopo il filtro della nuova barra,
   //    perche' la caduta peggiore di giornata succede DENTRO la candela.
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

   //--- CORREZIONE 1: si lavora su barre CHIUSE. Una decisione per barra.
   datetime t = iTime(_Symbol, InpTF, 0);
   if(t <= 0 || t == gLastBar) return;
   gLastBar = t;
   cB_bars++;

   if(Bars(_Symbol, InpTF) < InpLookback + 2) { cF_data++; return; }

   //--- CORREZIONE 2: le posizioni sono le NOSTRE, non quelle del conto
   if(NostrePosizioni() > 0) { cF_busy++; return; }

   //--- l'estremo si cerca sulle ultime InpLookback barre CHIUSE (shift 1..N)
   //    NB: i nomi NON possono essere iLow/iHigh, che sono funzioni di MQL5.
   int posMin = iLowest (_Symbol, InpTF, MODE_LOW,  InpLookback, 1);
   int posMax = iHighest(_Symbol, InpTF, MODE_HIGH, InpLookback, 1);
   if(posMin < 0 || posMax < 0) { cF_data++; return; }

   double massimo = iHigh(_Symbol, InpTF, posMax);
   double minimo  = iLow (_Symbol, InpTF, posMin);
   if(massimo <= minimo) { cF_data++; return; }
   double media = (massimo + minimo) / 2.0;   // il bersaglio: il centro del range

   bool segnale_long  = (posMin == 1);  // la barra appena chiusa E' il minimo
   bool segnale_short = (posMax == 1);  // ... o il massimo
   if(!segnale_long && !segnale_short) return;
   //--- barra esterna che e' insieme il massimo E il minimo del range:
   //    il segnale non dice da che parte stare. Non si tira a indovinare.
   if(segnale_long && segnale_short) { cF_data++; return; }
   if(segnale_long)  cS_long++;
   if(segnale_short) cS_short++;

   if(segnale_long  && !InpAllowLong)  { cF_side++; return; }
   if(segnale_short && !InpAllowShort) { cF_side++; return; }

   //--- spread
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick)) { cF_data++; return; }
   if(InpMaxSpreadPts > 0)
     {
      double spread_pts = (tick.ask - tick.bid) / _Point;
      if(spread_pts > InpMaxSpreadPts) { cO_spread++; return; }
     }

   ENUM_ORDER_TYPE tipo = segnale_long ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
   double entrata = segnale_long ? tick.ask : tick.bid;

   //--- il TP e' il centro del range; lo SL e' il suo specchio -> R:R 1:1
   double tp = media;
   double sl = 2.0 * entrata - tp;

   //--- se il prezzo ha gia' superato il centro, il segnale non ha bersaglio
   if(segnale_long  && tp <= entrata) return;
   if(segnale_short && tp >= entrata) return;

   tp = NormalizeDouble(tp, _Digits);
   sl = NormalizeDouble(sl, _Digits);

   if(!LivelliValidi(tipo, entrata, sl, tp)) { cO_failLevel++; return; }

   double lotti = LottoDaRischio(tipo, entrata, sl);
   if(lotti <= 0.0) { cO_failLot++; return; }

   bool ok = false;
   if(segnale_long) ok = gTrade.Buy (lotti, _Symbol, 0.0, sl, tp, InpComment);
   else             ok = gTrade.Sell(lotti, _Symbol, 0.0, sl, tp, InpComment);

   if(ok)
     {
      if(segnale_long) cI_long++; else cI_short++;
      Log(StringFormat("%s %.2f lotti  entrata=%.5f sl=%.5f tp=%.5f  (range %.5f-%.5f)",
                       (segnale_long ? "LONG" : "SHORT"), lotti, entrata, sl, tp, minimo, massimo));
     }
   else
     {
      cO_failSend++;
      Log(StringFormat("invio fallito: retcode=%d (%s)", gTrade.ResultRetcode(), gTrade.ResultRetcodeDescription()));
     }
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.      //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione)//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

void ExportTrades()
  {
   if(!HistorySelect(0, TimeCurrent())) return;
   string fn = "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol + "_" + IntegerToString((long)InpMagic) + ".csv";
   int h = FileOpen(fn, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h, "close_time", "symbol", "magic", "position_id", "deal_type", "volume", "price", "net_profit");
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      long entry = HistoryDealGetInteger(tk, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      double net = HistoryDealGetDouble(tk, DEAL_PROFIT) + HistoryDealGetDouble(tk, DEAL_SWAP) + HistoryDealGetDouble(tk, DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk, DEAL_TIME), TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                HistoryDealGetString(tk, DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_VOLUME), 2),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_PRICE), _Digits),
                DoubleToString(net, 2));
     }
   FileClose(h);
  }

//==================================================================
//  FUNNEL DI MORTALITA' (solo Print a fine test).
//  Se l'EA resta muto bisogna sapere SUBITO se e' perche' l'estremo
//  non cade mai sulla barra appena chiusa, perche' il lato e' spento,
//  perche' siamo gia' in posizione, o perche' lo bocciamo noi con
//  spread, stopsLevel o lotto. Nessun impatto sul CSV.
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[MREV-FUNNEL] %s %s  lookback=%d  rischio=%.2f%%  lati: L=%s S=%s  maxSpread=%d",
               _Symbol, EnumToString(InpTF), InpLookback, InpRiskPercent,
               (InpAllowLong ? "ON" : "OFF"), (InpAllowShort ? "ON" : "OFF"), InpMaxSpreadPts);
   PrintFormat("[MREV-FUNNEL] BARRE     chiuse elaborate=%d | scartate per dati insufficienti=%d | gia' in posizione=%d",
               (int)cB_bars, (int)cF_data, (int)cF_busy);
   PrintFormat("[MREV-FUNNEL] SEGNALI   estremo sulla barra appena chiusa: long=%d short=%d | scartati per lato spento=%d",
               (int)cS_long, (int)cS_short, (int)cF_side);
   PrintFormat("[MREV-FUNNEL] ORDINI    scartati: spread=%d stopsLevel=%d lotto/margine=%d invioFallito=%d",
               (int)cO_spread, (int)cO_failLevel, (int)(cO_failLot + cO_failMargin), (int)cO_failSend);
   PrintFormat("[MREV-FUNNEL] ESITI     ingressi long=%d short=%d | trade eseguiti=%d",
               (int)cI_long, (int)cI_short, (int)TesterStatistics(STAT_TRADES));
  }

double OnTester()
  {
   PrintFunnel();
   ExportTrades();
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
