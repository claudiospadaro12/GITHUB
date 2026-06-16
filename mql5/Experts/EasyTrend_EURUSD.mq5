//+------------------------------------------------------------------+
//|                                          EasyTrend_EURUSD.mq5     |
//|   Strategia "EASY TREND" - EUR/USD H1                            |
//|   Replica in MQL5 di:                                            |
//|     1) Linear Regression Candle (UGUR-VU)                        |
//|     2) CCI Divergences (TISTA)                                   |
//|   v1.0                                                           |
//+------------------------------------------------------------------+
//  STRATEGIA (distillata dalle trascrizioni del corso, video 12/14/15/16):
//  - Strumento EUR/USD, timeframe H1, una sola posizione per volta.
//  - Rischio 2% per operazione, rapporto rischio/rendimento 1:1 (TP = SL in pip).
//
//  DUE INDICATORI (calcolati INTERNAMENTE, nessun .ex5 esterno):
//   1) Linear Regression Candle: per ogni candela calcola la regressione
//      lineare (minimi quadrati) su Open/High/Low/Close separatamente sul
//      periodo "LinRegLength". La candela "lisciata" e' VERDE se
//      linreg-close >= linreg-open, ROSSA altrimenti. Il "plot" e' la SMA
//      della linreg-close su periodo "SignalLength".
//   2) CCI Divergences: CCI(CCIPeriod) + rilevatore di divergenze REGOLARI
//      via pivot (left/right bars). Divergenza confermata solo dopo
//      "PivotRight" barre (si lavora SOLO su barre chiuse, nessun look-ahead).
//
//  SEGNALE LONG (lo SHORT e' speculare):
//   1) Divergenza RIALZISTA regolare appena confermata sul CCI
//      (prezzo: pivot-low piu' BASSO del precedente; CCI: pivot-low piu' ALTO).
//   2) Dopo la divergenza, la PRIMA candela H1 che "taglia il plot" verso
//      l'alto (linreg-close passa da sotto a sopra il plot, oppure apre gia'
//      sopra) = CANDELA DI SEGNALE.
//   3) L'orario della candela di segnale deve stare tra SessionStart e
//      SessionEnd (estremi inclusi). Fuori fascia => divergenza INVALIDATA.
//   4) La Line Reg della candela di segnale deve essere VERDE.
//   5) Le 3 candele precedenti la candela di segnale devono avere
//      linreg-close SOTTO il plot.
//   - Ingresso  = CHIUSURA REALE della candela di segnale.
//   - Stop loss = minimo (low REALE) piu' basso tra inizio divergenza e
//                 candela di segnale, MENO 3 pip.
//   - Take profit = ingresso + (ingresso - stop)  -> RR 1:1.
//
//  ESECUZIONE ORDINE (video 15):
//   - LONG:  prezzo corrente <= ingresso  -> entra a MERCATO
//            prezzo corrente >  ingresso  -> BUY LIMIT al prezzo di ingresso
//   - SHORT: prezzo corrente >= ingresso  -> entra a MERCATO
//            prezzo corrente <  ingresso  -> SELL LIMIT al prezzo di ingresso
//   - Gli ordini pendenti hanno SCADENZA configurabile (PendingExpiryHours).
//     Se non riempiti entro la scadenza vengono cancellati.
//
//  GESTIONE: nessun break-even, nessun trailing (1:1 secco fino a SL o TP).
//
//  NOTE DI FEDELTA' (da validare contro TradingView - vedi report):
//   - Parametri default degli indicatori (LinRegLength=11, SignalLength=11,
//     CCIPeriod=20, Pivot 5/5) sono valori PLAUSIBILI ma da confrontare con
//     i settaggi reali degli script su TradingView.
//   - Fuso orario: la fascia 08:00-18:00 e' valutata sull'ORA DEL SERVER MT5.
//     TradingView puo' usare un fuso diverso: usare SessionTZShiftHours per
//     allineare (vedi report).
//+------------------------------------------------------------------+
#property copyright "EASY TREND EA - Claudio v1.0"
#property link      ""
#property version   "1.00"
#property description "EASY TREND: Linear Regression Candle (UGUR-VU) + CCI Divergences (TISTA) | EUR/USD | H1"

#include <Trade/Trade.mqh>

//=== INPUT INDICATORE: Linear Regression Candle ===================
input int    LinRegLength      = 11;     // Lunghezza regressione lineare (candele) [DA VALIDARE su TV]
input int    SignalLength      = 11;     // Lunghezza segnale/plot = SMA della linreg-close [DA VALIDARE su TV]

//=== INPUT INDICATORE: CCI Divergences ============================
input int    CCIPeriod         = 20;     // Periodo CCI [DA VALIDARE su TV]
input int    PivotLeft         = 5;      // Barre a sinistra per il pivot [DA VALIDARE su TV]
input int    PivotRight        = 5;      // Barre a destra per il pivot (conferma) [DA VALIDARE su TV]
input int    DivMinBars        = 5;      // Distanza minima tra due pivot per la divergenza
input int    DivMaxBars        = 60;     // Distanza massima tra due pivot per la divergenza

//=== INPUT STRATEGIA / FASCIA ORARIA ==============================
input int    SessionStart      = 8;      // Ora inizio sessione (inclusa) - ora SERVER
input int    SessionEnd        = 18;     // Ora fine sessione (inclusa)   - ora SERVER
input int    SessionTZShiftHours = 0;    // Offset ore da applicare per allineare a TradingView [DA VALIDARE]
input double StopBufferPips     = 3.0;   // Buffer di stop oltre l'estremo (pip)
input int    SignalSearchBars   = 30;    // Quante barre dopo la divergenza cercare la candela di segnale

//=== INPUT RISK MANAGEMENT ========================================
input double RiskPercent        = 2.0;   // Rischio % per operazione
input double RewardRatio        = 1.0;   // Rapporto rischio/rendimento (1.0 = 1:1)

//=== INPUT ESECUZIONE ORDINI ======================================
input double PendingExpiryHours = 6.0;   // Scadenza ordini pendenti (ore). <=0 = GTC
input double MaxSpreadPips       = 2.0;   // Spread massimo (pip) per entrare. <=0 = nessun filtro

//=== INPUT EA =====================================================
input long   MagicNumber        = 770011; // Magic Number
input string EAComment          = "EASY_TREND"; // Commento ordine
input bool   DrawSignals        = true;  // Disegna livelli del segnale sul grafico

//=== VARIABILI GLOBALI ============================================
CTrade    trade;
int       cciHandle   = INVALID_HANDLE;
datetime  lastBarTime = 0;

// Stato della divergenza attualmente "in monitoraggio" (in attesa della candela di segnale).
// Una sola alla volta: appena se ne conferma una nuova, sostituisce la precedente.
bool      divActive       = false;   // c'e' una divergenza attiva da monitorare?
bool      divIsBull       = false;   // true = rialzista (LONG), false = ribassista (SHORT)
datetime  divStartTime    = 0;       // open-time del pivot di prezzo "vecchio" (inizio divergenza)
int       divCrossWaited  = 0;       // barre trascorse da quando monitoriamo (limite SignalSearchBars)

// Stato dell'ordine pendente piazzato dall'EA (per gestire la scadenza).
ulong     pendingTicket   = 0;
datetime  pendingExpiry   = 0;

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   if(Period() != PERIOD_H1)
      Print("[EASYTREND] ATTENZIONE: strategia progettata per H1. TF attuale: ", EnumToString(Period()));

   if(StringFind(Symbol(), "EURUSD") < 0)
      Print("[EASYTREND] ATTENZIONE: strategia pensata per EUR/USD. Simbolo attuale: ", Symbol());

   if(LinRegLength < 2 || SignalLength < 1 || CCIPeriod < 2 ||
      PivotLeft < 1 || PivotRight < 1 || DivMinBars < 1 || DivMaxBars <= DivMinBars)
   {
      Print("[EASYTREND] ERRORE: parametri indicatori non validi.");
      return INIT_FAILED;
   }

   cciHandle = iCCI(Symbol(), PERIOD_H1, CCIPeriod, PRICE_TYPICAL);
   if(cciHandle == INVALID_HANDLE)
   {
      Print("[EASYTREND] ERRORE handle CCI: ", GetLastError());
      return INIT_FAILED;
   }

   trade.SetExpertMagicNumber((int)MagicNumber);
   trade.SetDeviationInPoints(20);
   trade.SetTypeFilling(GetBrokerFilling());

   lastBarTime    = 0;
   divActive      = false;
   pendingTicket  = 0;
   pendingExpiry  = 0;

   Print("[EASYTREND] v1.0 inizializzato | ", Symbol(), " | Risk:", RiskPercent,
         "% | RR 1:", RewardRatio, " | Magic:", MagicNumber);
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(cciHandle != INVALID_HANDLE)
   {
      IndicatorRelease(cciHandle);
      cciHandle = INVALID_HANDLE;
   }
   DeleteAllObjects();
   Print("[EASYTREND] EA rimosso. Motivo:", reason);
}

//+------------------------------------------------------------------+
//| OnTick - logica solo su nuova candela (barre chiuse)            |
//+------------------------------------------------------------------+
void OnTick()
{
   // Gestione scadenza pendenti: utile farla anche fuori da nuova candela.
   ManagePendingExpiry();

   // Tutta la logica del segnale lavora su barre CHIUSE -> solo a nuova candela.
   datetime barTime = iTime(Symbol(), PERIOD_H1, 0);
   if(barTime == lastBarTime) return;
   lastBarTime = barTime;

   // Servono abbastanza barre per CCI, regressione, pivot e finestra divergenza.
   int needed = CCIPeriod + LinRegLength + SignalLength + DivMaxBars + PivotLeft + PivotRight + 10;
   if(iBars(Symbol(), PERIOD_H1) < needed) return;

   // Se ho una posizione aperta dell'EA, non cerco nuovi segnali (1 posizione per volta).
   bool inPos = HasOpenPosition();

   // 1) Rilevamento di una nuova divergenza confermata sull'ultima barra chiusa.
   DetectNewDivergence();

   // 2) Se c'e' una divergenza attiva, cerco la candela di segnale (taglio del plot).
   if(divActive && !inPos && pendingTicket == 0)
      CheckSignalCandle();
}

//+------------------------------------------------------------------+
//| Regressione lineare (minimi quadrati) sul valore endpoint.       |
//| series[] in serie temporale (index 0 = barra piu' recente).      |
//| Restituisce il valore della retta calcolato sull'ULTIMO punto    |
//| della finestra (l'endpoint piu' recente), come fa la             |
//| Linear Regression Candle: ogni candela e' il valore di fine retta.|
//| barShift = shift della candela su cui calcolare la linreg.       |
//+------------------------------------------------------------------+
double LinRegEndpoint(const double &series[], int barShift, int length)
{
   // Asse x: 0 (punto piu' vecchio della finestra) ... length-1 (punto piu' recente = barShift).
   // y[k] corrisponde alla barra (barShift + (length-1) - k), cioe' k=length-1 -> barShift.
   double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
   for(int k = 0; k < length; k++)
   {
      int idx = barShift + (length - 1) - k;   // shift reale nella serie
      double x = (double)k;
      double y = series[idx];
      sumX  += x;
      sumY  += y;
      sumXY += x * y;
      sumX2 += x * x;
   }
   double n = (double)length;
   double denom = (n * sumX2 - sumX * sumX);
   if(MathAbs(denom) < 1e-12) return series[barShift];
   double slope     = (n * sumXY - sumX * sumY) / denom;
   double intercept = (sumY - slope * sumX) / n;
   // Endpoint piu' recente: x = length-1
   return intercept + slope * (double)(length - 1);
}

//+------------------------------------------------------------------+
//| linreg-close della candela a barShift.                           |
//+------------------------------------------------------------------+
double LinRegClose(int barShift)
{
   double cl[];
   ArraySetAsSeries(cl, true);
   int need = barShift + LinRegLength + 1;
   if(CopyClose(Symbol(), PERIOD_H1, 0, need, cl) < need) return EMPTY_VALUE;
   return LinRegEndpoint(cl, barShift, LinRegLength);
}

//+------------------------------------------------------------------+
//| linreg-open della candela a barShift.                            |
//+------------------------------------------------------------------+
double LinRegOpen(int barShift)
{
   double op[];
   ArraySetAsSeries(op, true);
   int need = barShift + LinRegLength + 1;
   if(CopyOpen(Symbol(), PERIOD_H1, 0, need, op) < need) return EMPTY_VALUE;
   return LinRegEndpoint(op, barShift, LinRegLength);
}

//+------------------------------------------------------------------+
//| Colore Line Reg della candela a barShift.                        |
//| true = VERDE (linreg-close >= linreg-open), false = ROSSO.       |
//+------------------------------------------------------------------+
bool LinRegIsGreen(int barShift)
{
   double lc = LinRegClose(barShift);
   double lo = LinRegOpen(barShift);
   if(lc == EMPTY_VALUE || lo == EMPTY_VALUE) return false;
   return (lc >= lo);
}

//+------------------------------------------------------------------+
//| Plot = SMA della linreg-close su SignalLength, alla candela      |
//| a barShift.                                                      |
//+------------------------------------------------------------------+
double PlotValue(int barShift)
{
   double sum = 0;
   for(int k = 0; k < SignalLength; k++)
   {
      double lc = LinRegClose(barShift + k);
      if(lc == EMPTY_VALUE) return EMPTY_VALUE;
      sum += lc;
   }
   return sum / (double)SignalLength;
}

//+------------------------------------------------------------------+
//| CCI a barShift.                                                  |
//+------------------------------------------------------------------+
double GetCCI(int barShift)
{
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(cciHandle, 0, barShift, 1, buf) < 1) return EMPTY_VALUE;
   return buf[0];
}

//+------------------------------------------------------------------+
//| PIVOT LOW sul CCI a barShift (con PivotLeft/PivotRight).         |
//| Un pivot e' confermato SOLO dopo PivotRight barre. Quindi viene  |
//| testato il punto centrale a shift = barShift, controllando le    |
//| PivotLeft barre piu' vecchie e PivotRight barre piu' recenti.    |
//| Per evitare look-ahead, il chiamante valuta pivot con            |
//| barShift >= PivotRight+1 (cosi' tutte le barre coinvolte sono    |
//| gia' chiuse: la piu' recente, center-PivotRight, e' shift 1).    |
//+------------------------------------------------------------------+
bool IsCCIPivotLow(int barShift)
{
   double center = GetCCI(barShift);
   if(center == EMPTY_VALUE) return false;
   for(int i = 1; i <= PivotLeft; i++)
   {
      double v = GetCCI(barShift + i);
      if(v == EMPTY_VALUE || v <= center) return false;   // deve essere strettamente piu' alto
   }
   for(int i = 1; i <= PivotRight; i++)
   {
      double v = GetCCI(barShift - i);
      if(v == EMPTY_VALUE || v <= center) return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| PIVOT HIGH sul CCI a barShift.                                   |
//+------------------------------------------------------------------+
bool IsCCIPivotHigh(int barShift)
{
   double center = GetCCI(barShift);
   if(center == EMPTY_VALUE) return false;
   for(int i = 1; i <= PivotLeft; i++)
   {
      double v = GetCCI(barShift + i);
      if(v == EMPTY_VALUE || v >= center) return false;
   }
   for(int i = 1; i <= PivotRight; i++)
   {
      double v = GetCCI(barShift - i);
      if(v == EMPTY_VALUE || v >= center) return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Rilevamento di una NUOVA divergenza regolare appena confermata.  |
//| Lavora con un pivot "appena confermato": il suo centro sta a     |
//| shift = PivotRight (cosi' le PivotRight barre a destra sono      |
//| chiuse). Cerca un pivot precedente dello stesso tipo entro la    |
//| finestra [DivMinBars, DivMaxBars] e confronta prezzo vs CCI.     |
//+------------------------------------------------------------------+
void DetectNewDivergence()
{
   // Centro del pivot appena confermato a shift = PivotRight+1: cosi' la barra
   // piu' recente coinvolta (center - PivotRight) e' la shift 1 (ultima CHIUSA),
   // mai la shift 0 (barra in formazione) -> nessun look-ahead.
   int newPivShift = PivotRight + 1;

   //--- DIVERGENZA RIALZISTA: pivot LOW su CCI ---
   if(IsCCIPivotLow(newPivShift))
   {
      // cerco il precedente pivot low entro la finestra
      for(int back = DivMinBars; back <= DivMaxBars; back++)
      {
         int oldShift = newPivShift + back;
         if(!IsCCIPivotLow(oldShift)) continue;

         double cciNew = GetCCI(newPivShift);
         double cciOld = GetCCI(oldShift);
         double lowNew = iLow(Symbol(), PERIOD_H1, newPivShift);
         double lowOld = iLow(Symbol(), PERIOD_H1, oldShift);
         if(cciNew == EMPTY_VALUE || cciOld == EMPTY_VALUE) break;

         // Regolare rialzista: prezzo fa minimo PIU' BASSO, CCI minimo PIU' ALTO.
         if(lowNew < lowOld && cciNew > cciOld)
         {
            ActivateDivergence(true, iTime(Symbol(), PERIOD_H1, oldShift));
            return;
         }
         break; // trovato il primo pivot precedente: valuto solo quello (poi mi fermo)
      }
   }

   //--- DIVERGENZA RIBASSISTA: pivot HIGH su CCI ---
   if(IsCCIPivotHigh(newPivShift))
   {
      for(int back = DivMinBars; back <= DivMaxBars; back++)
      {
         int oldShift = newPivShift + back;
         if(!IsCCIPivotHigh(oldShift)) continue;

         double cciNew  = GetCCI(newPivShift);
         double cciOld  = GetCCI(oldShift);
         double highNew = iHigh(Symbol(), PERIOD_H1, newPivShift);
         double highOld = iHigh(Symbol(), PERIOD_H1, oldShift);
         if(cciNew == EMPTY_VALUE || cciOld == EMPTY_VALUE) break;

         // Regolare ribassista: prezzo fa massimo PIU' ALTO, CCI massimo PIU' BASSO.
         if(highNew > highOld && cciNew < cciOld)
         {
            ActivateDivergence(false, iTime(Symbol(), PERIOD_H1, oldShift));
            return;
         }
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| Attiva una divergenza da monitorare (sostituisce la precedente). |
//+------------------------------------------------------------------+
void ActivateDivergence(bool isBull, datetime startTime)
{
   divActive      = true;
   divIsBull      = isBull;
   divStartTime   = startTime;
   divCrossWaited = 0;
   Print("[EASYTREND] Divergenza ", (isBull ? "RIALZISTA" : "RIBASSISTA"),
         " confermata. Inizio (open-time pivot vecchio): ", TimeToString(startTime));
   if(DrawSignals) DrawVLine("ET_DIV", startTime, isBull ? clrAqua : clrOrange);
}

//+------------------------------------------------------------------+
//| Verifica se la barra appena chiusa (shift 1) e' la candela di    |
//| segnale (taglio del plot) e, in tal caso, valida la checklist e  |
//| invia l'ordine.                                                  |
//+------------------------------------------------------------------+
void CheckSignalCandle()
{
   // Limite di ricerca: oltre SignalSearchBars la divergenza decade.
   divCrossWaited++;
   if(divCrossWaited > SignalSearchBars)
   {
      Print("[EASYTREND] Divergenza scaduta (nessun taglio del plot entro ",
            SignalSearchBars, " barre).");
      ClearDivergence();
      return;
   }

   int sig = 1;   // candela di segnale candidata = ultima chiusa

   double lcSig  = LinRegClose(sig);
   double lcPrev = LinRegClose(sig + 1);
   double plotSig  = PlotValue(sig);
   double plotPrev = PlotValue(sig + 1);
   if(lcSig == EMPTY_VALUE || lcPrev == EMPTY_VALUE ||
      plotSig == EMPTY_VALUE || plotPrev == EMPTY_VALUE) return;

   //--- Condizione 2: "taglio del plot" ---
   bool cross = false;
   if(divIsBull)
   {
      // verso l'alto: da sotto a sopra il plot, oppure apre gia' sopra
      bool crossUp   = (lcPrev <= plotPrev && lcSig > plotSig);
      bool openAbove = (lcPrev > plotPrev && lcSig > plotSig);
      cross = (crossUp || openAbove);
   }
   else
   {
      bool crossDn   = (lcPrev >= plotPrev && lcSig < plotSig);
      bool openBelow = (lcPrev < plotPrev && lcSig < plotSig);
      cross = (crossDn || openBelow);
   }
   if(!cross) return;   // non e' ancora la candela di segnale: continuo a monitorare

   // Da qui in poi questa E' la candela di segnale: la divergenza si "consuma".
   // Qualunque esito (valida/invalidata) chiude il monitoraggio di questa divergenza.

   //--- Condizione 3: fascia oraria della candela di segnale ---
   datetime sigTime = iTime(Symbol(), PERIOD_H1, sig);
   if(!IsInSession(sigTime))
   {
      Print("[EASYTREND] Candela di segnale FUORI fascia oraria (",
            TimeToString(sigTime), "). Divergenza INVALIDATA.");
      ClearDivergence();
      return;
   }

   //--- Condizione 4: colore Line Reg in tinta con la divergenza ---
   bool green = LinRegIsGreen(sig);
   if(divIsBull && !green)
   {
      Print("[EASYTREND] Candela di segnale non VERDE (LONG): divergenza scartata.");
      ClearDivergence();
      return;
   }
   if(!divIsBull && green)
   {
      Print("[EASYTREND] Candela di segnale non ROSSA (SHORT): divergenza scartata.");
      ClearDivergence();
      return;
   }

   //--- Condizione 5: le 3 candele precedenti dal lato giusto del plot ---
   for(int k = 1; k <= 3; k++)
   {
      double lc = LinRegClose(sig + k);
      double pv = PlotValue(sig + k);
      if(lc == EMPTY_VALUE || pv == EMPTY_VALUE) { ClearDivergence(); return; }
      if(divIsBull && !(lc < pv)) { Print("[EASYTREND] Pre-candele non SOTTO il plot (LONG): scarto."); ClearDivergence(); return; }
      if(!divIsBull && !(lc > pv)) { Print("[EASYTREND] Pre-candele non SOPRA il plot (SHORT): scarto."); ClearDivergence(); return; }
   }

   //--- Tutte le condizioni soddisfatte: calcolo ingresso/SL/TP ---
   ExecuteTrade(sig);
   ClearDivergence();
}

//+------------------------------------------------------------------+
//| Calcola ingresso/SL/TP dalla candela di segnale e invia l'ordine |
//| (mercato o pendente) secondo il prezzo corrente.                 |
//+------------------------------------------------------------------+
void ExecuteTrade(int sig)
{
   double pip   = GetPipSize();
   double entry = iClose(Symbol(), PERIOD_H1, sig);   // ingresso = CHIUSURA REALE del segnale

   // Estremo (low/high REALE) tra inizio divergenza e candela di segnale.
   int startShift = iBarShift(Symbol(), PERIOD_H1, divStartTime, false);
   if(startShift < sig) startShift = sig;             // sicurezza: deve essere piu' vecchio del segnale
   int count = startShift - sig + 1;                  // numero di barre incluse [sig .. startShift]
   if(count < 1) count = 1;

   double sl, tp;
   if(divIsBull)
   {
      double lows[];
      ArraySetAsSeries(lows, true);
      if(CopyLow(Symbol(), PERIOD_H1, sig, count, lows) < count) { Print("[EASYTREND] Errore CopyLow."); return; }
      double minLow = lows[ArrayMinimum(lows, 0, count)];
      sl = NormalizeDouble(minLow - StopBufferPips * pip, _Digits);
      double stopDist = entry - sl;
      if(stopDist <= 0) { Print("[EASYTREND] StopDist non valido (LONG). Skip."); return; }
      tp = NormalizeDouble(entry + stopDist * RewardRatio, _Digits);
   }
   else
   {
      double highs[];
      ArraySetAsSeries(highs, true);
      if(CopyHigh(Symbol(), PERIOD_H1, sig, count, highs) < count) { Print("[EASYTREND] Errore CopyHigh."); return; }
      double maxHigh = highs[ArrayMaximum(highs, 0, count)];
      sl = NormalizeDouble(maxHigh + StopBufferPips * pip, _Digits);
      double stopDist = sl - entry;
      if(stopDist <= 0) { Print("[EASYTREND] StopDist non valido (SHORT). Skip."); return; }
      tp = NormalizeDouble(entry - stopDist * RewardRatio, _Digits);
   }

   double stopPips = MathAbs(entry - sl) / pip;
   if(stopPips <= 0) { Print("[EASYTREND] StopPips non valido. Skip."); return; }

   // Filtro spread.
   if(MaxSpreadPips > 0)
   {
      double sp = CurrentSpreadPips();
      if(sp > MaxSpreadPips)
      {
         Print("[EASYTREND] Spread troppo alto (", DoubleToString(sp,1), " > ", MaxSpreadPips, "). Skip.");
         return;
      }
   }

   double lots = CalculateLots(stopPips);
   if(lots <= 0) { Print("[EASYTREND] Lotto non valido. Skip."); return; }

   entry = NormalizeDouble(entry, _Digits);
   double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

   Print("[EASYTREND] SEGNALE ", (divIsBull ? "LONG" : "SHORT"),
         " | Entry:", entry, " SL:", sl, " TP:", tp,
         " StopPips:", DoubleToString(stopPips,1), " Lots:", lots);

   if(DrawSignals)
   {
      DrawHLine("ET_ENTRY", entry, clrYellow, "Entry:" + DoubleToString(entry,_Digits));
      DrawHLine("ET_SL",    sl,    clrRed,    "SL:"    + DoubleToString(sl,_Digits));
      DrawHLine("ET_TP",    tp,    clrLime,   "TP:"    + DoubleToString(tp,_Digits));
   }

   //--- Decisione mercato vs pendente (video 15) ---
   bool sent = false;
   if(divIsBull)
   {
      // LONG: confronto col prezzo a cui realmente compreremmo (ask).
      if(ask <= entry)
      {
         // prezzo uguale/migliore (verso lo stop) -> a MERCATO
         sent = trade.Buy(lots, Symbol(), 0.0, sl, tp, EAComment);
         LogOrderResult(sent, "BUY MERCATO");
      }
      else
      {
         // prezzo gia' andato verso il TP -> BUY LIMIT al prezzo di ingresso
         datetime exp = PendingExpiryTime();
         sent = trade.BuyLimit(lots, entry, Symbol(), sl, tp,
                               (exp > 0 ? ORDER_TIME_SPECIFIED : ORDER_TIME_GTC), exp, EAComment);
         if(LogOrderResult(sent, "BUY LIMIT"))
         {
            pendingTicket = trade.ResultOrder();
            pendingExpiry = exp;
         }
      }
   }
   else
   {
      // SHORT: confronto col prezzo a cui realmente venderemmo (bid).
      if(bid >= entry)
      {
         sent = trade.Sell(lots, Symbol(), 0.0, sl, tp, EAComment);
         LogOrderResult(sent, "SELL MERCATO");
      }
      else
      {
         datetime exp = PendingExpiryTime();
         sent = trade.SellLimit(lots, entry, Symbol(), sl, tp,
                                (exp > 0 ? ORDER_TIME_SPECIFIED : ORDER_TIME_GTC), exp, EAComment);
         if(LogOrderResult(sent, "SELL LIMIT"))
         {
            pendingTicket = trade.ResultOrder();
            pendingExpiry = exp;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Log + controllo retcode dell'ordine. Ritorna true se ok.         |
//+------------------------------------------------------------------+
bool LogOrderResult(bool sent, string what)
{
   uint rc = trade.ResultRetcode();
   if(sent && (rc == TRADE_RETCODE_DONE || rc == TRADE_RETCODE_PLACED))
   {
      Print("[EASYTREND] ", what, " OK | retcode:", rc, " | order:", trade.ResultOrder());
      return true;
   }
   Print("[EASYTREND] ", what, " ERRORE | retcode:", rc, " ", trade.ResultRetcodeDescription());
   return false;
}

//+------------------------------------------------------------------+
//| Scadenza ordini pendenti: cancella i nostri pendenti scaduti.    |
//+------------------------------------------------------------------+
void ManagePendingExpiry()
{
   if(pendingTicket == 0) return;

   // Se l'ordine non esiste piu' (riempito o gia' cancellato), azzero lo stato.
   if(!OrderSelect(pendingTicket))
   {
      pendingTicket = 0;
      pendingExpiry = 0;
      return;
   }

   // ORDER_TIME_SPECIFIED viene gestito dal server; come ridondanza lato EA
   // cancelliamo noi se la scadenza e' passata (es. broker che non onora l'expiry).
   if(pendingExpiry > 0 && TimeCurrent() >= pendingExpiry)
   {
      if(trade.OrderDelete(pendingTicket))
      {
         uint rc = trade.ResultRetcode();
         if(rc == TRADE_RETCODE_DONE || rc == TRADE_RETCODE_PLACED)
            Print("[EASYTREND] Pendente scaduto cancellato. Ticket:", pendingTicket);
         else
            Print("[EASYTREND] Errore cancellazione pendente: ", rc, " ", trade.ResultRetcodeDescription());
      }
      pendingTicket = 0;
      pendingExpiry = 0;
   }
}

//+------------------------------------------------------------------+
//| Pulisce lo stato della divergenza in monitoraggio.               |
//+------------------------------------------------------------------+
void ClearDivergence()
{
   divActive      = false;
   divCrossWaited = 0;
   divStartTime   = 0;
}

//+------------------------------------------------------------------+
//| Fascia oraria della candela di segnale (ora SERVER + shift).     |
//| Estremi inclusi. SessionTZShiftHours permette di allineare a TV. |
//+------------------------------------------------------------------+
bool IsInSession(datetime barOpenTime)
{
   datetime shifted = barOpenTime + (datetime)(SessionTZShiftHours * 3600);
   MqlDateTime dt;
   TimeToStruct(shifted, dt);
   int h = dt.hour;
   return (h >= SessionStart && h <= SessionEnd);
}

//+------------------------------------------------------------------+
//| Timestamp di scadenza per i pendenti. 0 = GTC.                   |
//+------------------------------------------------------------------+
datetime PendingExpiryTime()
{
   if(PendingExpiryHours <= 0) return 0;
   return TimeCurrent() + (datetime)(PendingExpiryHours * 3600.0);
}

//+------------------------------------------------------------------+
//| Posizione aperta dell'EA su questo simbolo?                      |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tkt = PositionGetTicket(i);
      if(tkt == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) == (int)MagicNumber &&
         PositionGetString(POSITION_SYMBOL) == Symbol())
         return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Calcolo lotto: rischio RiskPercent% sullo stop in pips.          |
//+------------------------------------------------------------------+
double CalculateLots(double stopPips)
{
   if(stopPips <= 0) return 0;
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   double risk = bal * RiskPercent / 100.0;
   double tv   = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double ts   = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   double ps   = GetPipSize();
   if(tv <= 0 || ts <= 0 || ps <= 0) return 0;

   double pv   = (ps / ts) * tv;   // valore di 1 pip per 1 lotto
   if(pv <= 0) return 0;

   double lots = risk / (stopPips * pv);
   double mn   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double mx   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   double st   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   if(st <= 0) st = 0.01;

   lots = MathFloor(lots / st) * st;
   lots = MathMax(mn, MathMin(mx, lots));
   lots = NormalizeDouble(lots, VolumeDigits(st));

   Print("[EASYTREND] Lots:", lots, " (Risk:", DoubleToString(risk,2),
         " StopPip:", DoubleToString(stopPips,1), " PipVal:", DoubleToString(pv,4), ")");
   return lots;
}

//+------------------------------------------------------------------+
//| Numero di decimali del VOLUME_STEP.                             |
//+------------------------------------------------------------------+
int VolumeDigits(double step)
{
   if(step <= 0) return 2;
   int d = 0;
   double s = step;
   while(d < 8 && MathAbs(s - MathRound(s)) > 1e-9) { s *= 10.0; d++; }
   return d;
}

//+------------------------------------------------------------------+
//| Pip size (gestisce simboli a 3/5 decimali).                     |
//+------------------------------------------------------------------+
double GetPipSize()
{
   int d = (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
   double p = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
   return (d == 5 || d == 3) ? p * 10.0 : p;
}

//+------------------------------------------------------------------+
//| Spread corrente in pips.                                        |
//+------------------------------------------------------------------+
double CurrentSpreadPips()
{
   double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double pip = GetPipSize();
   if(pip <= 0) return 0;
   return (ask - bid) / pip;
}

//+------------------------------------------------------------------+
//| Filling mode adattivo in base a SYMBOL_FILLING_MODE.            |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING GetBrokerFilling()
{
   long modes = SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
   if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
   if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

//+------------------------------------------------------------------+
//| Linea verticale helper.                                         |
//+------------------------------------------------------------------+
void DrawVLine(string n, datetime t, color c)
{
   if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_VLINE, 0, t, 0);
   ObjectSetInteger(0, n, OBJPROP_TIME, 0, t);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_STYLE, STYLE_DOT);
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Linea orizzontale helper.                                       |
//+------------------------------------------------------------------+
void DrawHLine(string n, double price, color c, string lbl)
{
   if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_HLINE, 0, 0, price);
   ObjectSetDouble (0, n, OBJPROP_PRICE, price);
   ObjectSetInteger(0, n, OBJPROP_COLOR, c);
   ObjectSetInteger(0, n, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, n, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetString (0, n, OBJPROP_TEXT, lbl);
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Cancellazione di tutti gli oggetti grafici dell'EA.             |
//+------------------------------------------------------------------+
void DeleteAllObjects()
{
   string ns[] = {"ET_DIV", "ET_ENTRY", "ET_SL", "ET_TP"};
   for(int i = 0; i < ArraySize(ns); i++)
      if(ObjectFind(0, ns[i]) >= 0) ObjectDelete(0, ns[i]);
   ChartRedraw();
}
//+------------------------------------------------------------------+
