//+------------------------------------------------------------------+
//|                                              ABTG_ExportH4.mq5   |
//|  v1.00 (19/11/2026) -- SOLA LETTURA, NESSUNA funzione di trading. |
//|  Esporta le barre H4 (time;open;high;low;close, orario SERVER)    |
//|  di tutti i simboli del broker il cui percorso NON inizia con una |
//|  delle voci escluse (default: forex, azioni, ETF, esotici,        |
//|  futures, bond). Scrive in MQL5\Files: ABTG_H4_<simbolo>.csv e    |
//|  ABTG_H4_ELENCO.csv (tutti i simboli, con percorso, swap, prima e |
//|  ultima barra, nota). Poi ABTG_H4_FINE.txt e chiude il terminale. |
//+------------------------------------------------------------------+
#property version "1.00"
#property strict

input datetime InpFrom        = D'2010.01.01 00:00';
input string   InpEscludi     = "Forex,Stocks,Shares,Equities,ETF,Exotic,Futures,Bonds";
input int      InpMaxSimboli  = 150;
input bool     InpChiudiTerminale = true;

string Maiusc(string s){ StringToUpper(s); return s; }

bool Escluso(const string path)
  {
   string p=Maiusc(path), parti[];
   int n=StringSplit(InpEscludi,',',parti);
   for(int i=0;i<n;i++)
     {
      string t=parti[i]; StringTrimLeft(t); StringTrimRight(t); t=Maiusc(t);
      if(StringLen(t)==0) continue;
      if(StringFind(p,t)==0) return true;
     }
   return false;
  }

string Sicuro(const string s)
  {
   string o="";
   for(int i=0;i<StringLen(s);i++)
     {
      ushort c=StringGetCharacter(s,i);
      bool ok=((c>='0'&&c<='9')||(c>='A'&&c<='Z')||(c>='a'&&c<='z')||c=='.'||c=='_'||c=='-');
      o+=ok?ShortToString(c):"_";
     }
   return o;
  }

string Pulisci(string s){ StringReplace(s,";",","); StringReplace(s,"\r"," "); StringReplace(s,"\n"," "); return s; }

void OnStart()
  {
   int tot=SymbolsTotal(false);
   int hl=FileOpen("ABTG_H4_ELENCO.csv",FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(hl==INVALID_HANDLE){ Print("[ExportH4] impossibile creare ELENCO: ",GetLastError()); if(InpChiudiTerminale) TerminalClose(0); return; }
   FileWriteString(hl,"server="+AccountInfoString(ACCOUNT_SERVER)+" offset_server_GMT_sec="+IntegerToString((int)(TimeTradeServer()-TimeGMT()))+" simboli_totali="+IntegerToString(tot)+"\r\n");
   FileWriteString(hl,"simbolo;percorso;descrizione;cifre;tick_size;tick_value;contratto;swap_modo;swap_long;swap_short;barre;prima;ultima;nota\r\n");
   int fatti=0, senzadati=0;
   for(int i=0;i<tot && !IsStopped();i++)
     {
      string s=SymbolName(i,false);
      string path=SymbolInfoString(s,SYMBOL_PATH), desc=Pulisci(SymbolInfoString(s,SYMBOL_DESCRIPTION));
      int dg=(int)SymbolInfoInteger(s,SYMBOL_DIGITS);
      string base=s+";"+Pulisci(path)+";"+desc+";"+IntegerToString(dg)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_TICK_SIZE),8)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_TICK_VALUE),5)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_TRADE_CONTRACT_SIZE),2)+";"+IntegerToString((int)SymbolInfoInteger(s,SYMBOL_SWAP_MODE))+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_SWAP_LONG),4)+";"+DoubleToString(SymbolInfoDouble(s,SYMBOL_SWAP_SHORT),4);
      if(Escluso(path)){ FileWriteString(hl,base+";;;;;escluso (percorso)\r\n"); continue; }
      if(fatti>=InpMaxSimboli){ FileWriteString(hl,base+";;;;;oltre il limite\r\n"); continue; }
      SymbolSelect(s,true);
      MqlRates r[]; int n=-1;
      for(int k=0;k<14 && !IsStopped();k++)
        {
         ResetLastError();
         n=CopyRates(s,PERIOD_H4,InpFrom,TimeCurrent(),r);
         if(n>0 && (bool)SeriesInfoInteger(s,PERIOD_H4,SERIES_SYNCHRONIZED)) break;
         Sleep(700);
        }
      if(n<=0){ senzadati++; FileWriteString(hl,base+";0;;;nessun dato (errore "+IntegerToString(GetLastError())+")\r\n"); continue; }
      int h=FileOpen("ABTG_H4_"+Sicuro(s)+".csv",FILE_WRITE|FILE_TXT|FILE_ANSI);
      if(h==INVALID_HANDLE){ FileWriteString(hl,base+";"+IntegerToString(n)+";;;file non creato\r\n"); continue; }
      FileWriteString(h,"time;open;high;low;close\r\n");
      for(int j=0;j<n;j++)
         FileWriteString(h,TimeToString(r[j].time,TIME_DATE|TIME_MINUTES)+";"+DoubleToString(r[j].open,dg)+";"+DoubleToString(r[j].high,dg)+";"+DoubleToString(r[j].low,dg)+";"+DoubleToString(r[j].close,dg)+"\r\n");
      FileClose(h);
      fatti++;
      FileWriteString(hl,base+";"+IntegerToString(n)+";"+TimeToString(r[0].time,TIME_DATE)+";"+TimeToString(r[n-1].time,TIME_DATE)+";ok\r\n");
     }
   FileClose(hl);
   int f=FileOpen("ABTG_H4_FINE.txt",FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(f!=INVALID_HANDLE){ FileWriteString(f,"fine "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+" esportati="+IntegerToString(fatti)+" senza_dati="+IntegerToString(senzadati)+" totali="+IntegerToString(tot)+"\r\n"); FileClose(f); }
   Print("[ExportH4] esportati ",fatti," senza dati ",senzadati," su ",tot);
   if(InpChiudiTerminale) TerminalClose(0);
  }
