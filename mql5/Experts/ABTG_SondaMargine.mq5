//+------------------------------------------------------------------+
//| ABTG_SondaMargine.mq5                                            |
//| R114 - G-SPEC: la sonda delle specifiche margine (criteri par.4).|
//| NON PIAZZA ORDINI, NON TRADA: al primo tick stampa nel journal   |
//| del tester le specifiche margine del simbolo e del conto viste   |
//| DENTRO il tester, poi si rimuove. Ogni riga inizia con 'GSPEC;'  |
//| cosi' il driver la ritrova nel log con un grep semplice.         |
//| Chiude il limite del par.1 punto 3 dei criteri R114: senza       |
//| questa stampa il referto non puo' dire PERCHE' un margine        |
//| osservato differisce dall'atteso.                                |
//| ASCII PURO (regola di casa del 17/08: niente emoji nei sorgenti).|
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property strict

bool g_fatto = false;

int OnInit()
  {
   // niente qui: in OnInit i prezzi possono non essere ancora vivi.
   return(INIT_SUCCEEDED);
  }

void StampaD(string chiave, double v)   { Print("GSPEC;", _Symbol, ";", chiave, ";", DoubleToString(v, 8)); }
void StampaI(string chiave, long v)     { Print("GSPEC;", _Symbol, ";", chiave, ";", IntegerToString(v)); }
void StampaS(string chiave, string v)   { Print("GSPEC;", _Symbol, ";", chiave, ";", v); }

void OnTick()
  {
   if(g_fatto) return;
   g_fatto = true;

   long calcMode = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_CALC_MODE);
   StampaI("TRADE_CALC_MODE", calcMode);
   StampaD("MARGIN_INITIAL",     SymbolInfoDouble(_Symbol, SYMBOL_MARGIN_INITIAL));
   StampaD("MARGIN_MAINTENANCE", SymbolInfoDouble(_Symbol, SYMBOL_MARGIN_MAINTENANCE));

   double rIni = 0.0, rMnt = 0.0;
   if(SymbolInfoMarginRate(_Symbol, ORDER_TYPE_BUY, rIni, rMnt))
     { StampaD("MARGIN_RATE_BUY_INITIAL", rIni); StampaD("MARGIN_RATE_BUY_MAINT", rMnt); }
   else StampaS("MARGIN_RATE_BUY", "NON LEGGIBILE");
   if(SymbolInfoMarginRate(_Symbol, ORDER_TYPE_SELL, rIni, rMnt))
     { StampaD("MARGIN_RATE_SELL_INITIAL", rIni); StampaD("MARGIN_RATE_SELL_MAINT", rMnt); }
   else StampaS("MARGIN_RATE_SELL", "NON LEGGIBILE");

   StampaS("CURRENCY_MARGIN", SymbolInfoString(_Symbol, SYMBOL_CURRENCY_MARGIN));
   StampaS("CURRENCY_PROFIT", SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT));
   StampaD("CONTRACT_SIZE",   SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE));
   StampaD("VOLUME_MIN",      SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN));
   StampaD("VOLUME_MAX",      SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX));
   StampaD("VOLUME_STEP",     SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP));
   StampaD("VOLUME_LIMIT",    SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_LIMIT));

   StampaI("ACCOUNT_LEVERAGE",       AccountInfoInteger(ACCOUNT_LEVERAGE));
   StampaS("ACCOUNT_CURRENCY",       AccountInfoString(ACCOUNT_CURRENCY));
   StampaD("ACCOUNT_MARGIN_SO_CALL", AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
   StampaD("ACCOUNT_MARGIN_SO_SO",   AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
   StampaI("ACCOUNT_MARGIN_SO_MODE", AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE));

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   StampaD("PREZZO_ASK", ask);
   StampaD("PREZZO_BID", bid);

   // MARGINE OSSERVATO dal motore del tester per 1 lotto (e' la misura
   // che i criteri chiedono di confrontare con l'atteso FASE 1).
   double mBuy = 0.0, mSell = 0.0;
   if(OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, 1.0, ask, mBuy))
        StampaD("MARGINE_OSSERVATO_1LOTTO_BUY", mBuy);
   else StampaS("MARGINE_OSSERVATO_1LOTTO_BUY", "NON CALCOLABILE (err " + IntegerToString(GetLastError()) + ")");
   if(OrderCalcMargin(ORDER_TYPE_SELL, _Symbol, 1.0, bid, mSell))
        StampaD("MARGINE_OSSERVATO_1LOTTO_SELL", mSell);
   else StampaS("MARGINE_OSSERVATO_1LOTTO_SELL", "NON CALCOLABILE (err " + IntegerToString(GetLastError()) + ")");

   // ATTESO con la formula semplice della FASE 1: prezzo * contratto /
   // leva del conto. In VALUTA MARGINE del simbolo, NON convertito:
   // il confronto con l'osservato (che il tester da' in valuta conto)
   // porta questa etichetta, dichiarata.
   long leva = AccountInfoInteger(ACCOUNT_LEVERAGE);
   double contratto = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   if(leva > 0)
        StampaD("MARGINE_ATTESO_FORMULA_FASE1_1LOTTO", ask * contratto / (double)leva);
   else StampaS("MARGINE_ATTESO_FORMULA_FASE1_1LOTTO", "NON CALCOLABILE (leva 0)");

   StampaS("FINE", "sonda completata, l'EA si rimuove");
   ExpertRemove();
  }
//+------------------------------------------------------------------+
