//+------------------------------------------------------------------+
//|                                              ABTG_SwapInfo.mq5   |
//|  v1.00 (19/11/2026) -- SOLA LETTURA, NESSUNA funzione di trading. |
//|  Scrive in MQL5\Files\ABTG_SWAPINFO.csv le specifiche di swap di  |
//|  XAUUSD e di tutti i simboli selezionati nel Market Watch:        |
//|  modo di calcolo, swap long/short, giorno del triplo swap e una   |
//|  STIMA dello swap per 1 lotto per notte nella valuta del conto    |
//|  (solo per i modi in punti, valuta del conto e interesse %).      |
//|  Poi scrive ABTG_SWAPINFO_FINE.txt e chiude il terminale.         |
//+------------------------------------------------------------------+
#property version "1.00"
#property strict

void Scrivi(const string nome, const string testo)
  {
   int h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(h!=INVALID_HANDLE){ FileWriteString(h,testo); FileClose(h); }
  }

string ModoTxt(const long m)
  {
   switch((int)m)
     {
      case SYMBOL_SWAP_MODE_DISABLED:         return "nessuno";
      case SYMBOL_SWAP_MODE_POINTS:           return "punti";
      case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL:  return "valuta_del_simbolo";
      case SYMBOL_SWAP_MODE_CURRENCY_MARGIN:  return "valuta_di_margine";
      case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT: return "valuta_del_conto";
      case SYMBOL_SWAP_MODE_INTEREST_CURRENT: return "interesse_%_annuo_prezzo_corrente";
      case SYMBOL_SWAP_MODE_INTEREST_OPEN:    return "interesse_%_annuo_prezzo_apertura";
      case SYMBOL_SWAP_MODE_REOPEN_CURRENT:   return "riapertura_prezzo_corrente";
      case SYMBOL_SWAP_MODE_REOPEN_BID:       return "riapertura_bid";
     }
   return "altro";
  }

// stima per 1 lotto per notte nella valuta del conto; "n.d." se il modo non e' convertibile qui
string Stima(const string sym,const long modo,const double swap)
  {
   double point=SymbolInfoDouble(sym,SYMBOL_POINT);
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE), tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   double bid=SymbolInfoDouble(sym,SYMBOL_BID);
   if(modo==SYMBOL_SWAP_MODE_DISABLED) return "0.00";
   if(modo==SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT) return DoubleToString(swap,2);
   if(ts<=0.0 || tv<=0.0) return "n.d.";
   if(modo==SYMBOL_SWAP_MODE_POINTS) return DoubleToString(swap*(point/ts)*tv,2);
   if((modo==SYMBOL_SWAP_MODE_INTEREST_CURRENT || modo==SYMBOL_SWAP_MODE_INTEREST_OPEN) && bid>0.0)
      return DoubleToString(bid*(tv/ts)*swap/100.0/360.0,2);
   return "n.d.";
  }

void OnStart()
  {
   string forzati[]={"XAUUSD","XAGUSD","EURUSD","NASUSD","SPXUSD","U30USD","D30EUR"};
   for(int k=0;k<ArraySize(forzati);k++) SymbolSelect(forzati[k],true);
   string cur=AccountInfoString(ACCOUNT_CURRENCY), srv=AccountInfoString(ACCOUNT_SERVER), azi=AccountInfoString(ACCOUNT_COMPANY);
   string out="simbolo;modo_swap;modo_testo;swap_long;swap_short;giorno_triplo_swap_0dom;digits;point;contratto;tick_size;tick_value;bid;stima_long_per_lotto_notte;stima_short_per_lotto_notte;valuta_conto;server;azienda\r\n";
   int tot=SymbolsTotal(true);
   for(int i=0;i<tot;i++)
     {
      string s=SymbolName(i,true);
      long modo=SymbolInfoInteger(s,SYMBOL_SWAP_MODE);
      double sl=SymbolInfoDouble(s,SYMBOL_SWAP_LONG), ss=SymbolInfoDouble(s,SYMBOL_SWAP_SHORT);
      long d3=SymbolInfoInteger(s,SYMBOL_SWAP_ROLLOVER3DAYS);
      out+=s+";"+IntegerToString(modo)+";"+ModoTxt(modo)+";"+DoubleToString(sl,4)+";"+DoubleToString(ss,4)+";"+IntegerToString(d3)+";"
           +IntegerToString((int)SymbolInfoInteger(s,SYMBOL_DIGITS))+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_POINT),8)+";"
           +DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_CONTRACT_SIZE),2)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_TICK_SIZE),8)+";"
           +DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_TICK_VALUE),5)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_BID),5)+";"
           +Stima(s,modo,sl)+";"+Stima(s,modo,ss)+";"+cur+";"+srv+";"+azi+"\r\n";
     }
   Scrivi("ABTG_SWAPINFO.csv",out);
   Scrivi("ABTG_SWAPINFO_FINE.txt","fine "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+" simboli="+IntegerToString(tot)+"\r\n");
   TerminalClose(0);
  }
