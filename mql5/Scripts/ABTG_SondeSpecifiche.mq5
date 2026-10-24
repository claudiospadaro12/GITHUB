//+------------------------------------------------------------------+
//|                                    ABTG_SondeSpecifiche.mq5      |
//|  v1.00 (24/10/2026) -- SONDA DI SOLA LETTURA. NON COMPILATA.     |
//|  NESSUNA funzione di trading: legge le SPECIFICHE dei simboli    |
//|  (StopsLevel, FreezeLevel, volume minimo/passo, valore del punto,|
//|  swap, filling) e le scrive in Common\Files\ABTG_SONDA_SPEC.csv. |
//|  Criteri congelati PRIMA dei numeri:                              |
//|  report/SONDA_SPECIFICHE_CRITERI_2026-10-24.md                   |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpSimboli = "U30USD,NASUSD,D30EUR,225JPY,XAUUSD,AUDCHF,CHFJPY,GBPUSD,EURJPY"; // simboli da leggere
input bool   InpChiudiTerminale = false; // true SOLO nel lancio automatico

void OnStart()
  {
   Print("ABTG_SondeSpecifiche v1.00: SOLA LETTURA, nessun ordine.");
   int h=FileOpen("ABTG_SONDA_SPEC.csv",FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE){ PrintFormat("SONDA: impossibile aprire il CSV, err=%d",GetLastError()); }
   else
     {
      FileWriteString(h,"simbolo;trovato;digits;point;stops_level;freeze_level;vol_min;vol_max;vol_step;tick_value;tick_size;tick_value_profit;tick_value_loss;contract_size;swap_long;swap_short;swap_mode;spread;filling_mode;order_mode;expiration_mode;trade_mode;valuta_profitto;bid;ask\r\n");
      string v[];
      int n=StringSplit(InpSimboli,',',v);
      for(int i=0;i<n;i++)
        {
         string s=v[i]; StringTrimLeft(s); StringTrimRight(s);
         if(StringLen(s)==0) continue;
         bool ok=SymbolSelect(s,true);
         if(ok){ for(int k=0;k<20;k++){ if(SymbolInfoDouble(s,SYMBOL_BID)>0) break; Sleep(250); } }
         string riga=StringFormat("%s;%d;%d;%.10g;%d;%d;%.10g;%.10g;%.10g;%.10g;%.10g;%.10g;%.10g;%.10g;%.10g;%.10g;%d;%d;%d;%d;%d;%d;%s;%.10g;%.10g",
            s,(int)ok,
            (int)SymbolInfoInteger(s,SYMBOL_DIGITS),SymbolInfoDouble(s,SYMBOL_POINT),
            (int)SymbolInfoInteger(s,SYMBOL_TRADE_STOPS_LEVEL),(int)SymbolInfoInteger(s,SYMBOL_TRADE_FREEZE_LEVEL),
            SymbolInfoDouble(s,SYMBOL_VOLUME_MIN),SymbolInfoDouble(s,SYMBOL_VOLUME_MAX),SymbolInfoDouble(s,SYMBOL_VOLUME_STEP),
            SymbolInfoDouble(s,SYMBOL_TRADE_TICK_VALUE),SymbolInfoDouble(s,SYMBOL_TRADE_TICK_SIZE),
            SymbolInfoDouble(s,SYMBOL_TRADE_TICK_VALUE_PROFIT),SymbolInfoDouble(s,SYMBOL_TRADE_TICK_VALUE_LOSS),
            SymbolInfoDouble(s,SYMBOL_TRADE_CONTRACT_SIZE),
            SymbolInfoDouble(s,SYMBOL_SWAP_LONG),SymbolInfoDouble(s,SYMBOL_SWAP_SHORT),
            (int)SymbolInfoInteger(s,SYMBOL_SWAP_MODE),(int)SymbolInfoInteger(s,SYMBOL_SPREAD),
            (int)SymbolInfoInteger(s,SYMBOL_FILLING_MODE),(int)SymbolInfoInteger(s,SYMBOL_ORDER_MODE),
            (int)SymbolInfoInteger(s,SYMBOL_EXPIRATION_MODE),(int)SymbolInfoInteger(s,SYMBOL_TRADE_MODE),
            SymbolInfoString(s,SYMBOL_CURRENCY_PROFIT),
            SymbolInfoDouble(s,SYMBOL_BID),SymbolInfoDouble(s,SYMBOL_ASK));
         FileWriteString(h,riga+"\r\n");
         PrintFormat("SPEC %s",riga);
        }
      FileClose(h);
     }
   int hf=FileOpen("ABTG_SONDA_FINE.txt",FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hf!=INVALID_HANDLE){ FileWriteString(hf,"FINE "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n"); FileClose(hf); }
   if(InpChiudiTerminale){ Sleep(2000); TerminalClose(0); }
  }
