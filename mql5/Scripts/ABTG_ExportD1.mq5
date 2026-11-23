//+------------------------------------------------------------------+
//|                                                ABTG_ExportD1.mq5 |
//|  v1.00 (23/11/2026) -- SOLA LETTURA: nessuna funzione di          |
//|  compravendita. Esporta le barre giornaliere (D1) dei simboli     |
//|  elencati in Common\Files\ABTG_D1_<simbolo>.csv con colonne         |
//|  date;open;high;low;close;tickvol;spread (ora del SERVER).        |
//|  Poi scrive ABTG_D1_ELENCO.txt e ABTG_D1_FINE.txt e, solo con     |
//|  InpChiudiTerminale=true (lancio automatico), chiude il terminale.|
//+------------------------------------------------------------------+
#property version "1.00"
#property strict
#property script_show_inputs

input string   InpSimboli = "EURUSD,GBPUSD,USDJPY,AUDUSD,USDCAD,USDCHF,NZDUSD,EURJPY,GBPJPY,EURGBP,AUDJPY,EURCHF,EURAUD,EURCAD,GBPCHF,GBPAUD,GBPCAD,AUDCAD,AUDNZD,CADJPY,CHFJPY,NZDJPY,AUDCHF,CADCHF,EURNZD,GBPNZD,NZDCAD,NZDCHF";
input datetime InpFrom    = D'2005.01.01 00:00';
input bool     InpChiudiTerminale = false;

void Riga(const string f, const string t)
  {
   int h=FileOpen(f,FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_COMMON);
   if(h==INVALID_HANDLE) return;
   FileSeek(h,0,SEEK_END);
   FileWriteString(h,t+"\r\n");
   FileClose(h);
  }

void OnStart()
  {
   string el="ABTG_D1_ELENCO.txt", fine="ABTG_D1_FINE.txt", prog="ABTG_D1_PROGRESSO.txt";
   FileDelete(el,FILE_COMMON); FileDelete(fine,FILE_COMMON); FileDelete(prog,FILE_COMMON);
   string v[];
   int n=StringSplit(InpSimboli,',',v);
   int ok=0, problemi=0;
   Riga(el,"simbolo;righe;prima;ultima;nota");
   for(int i=0;i<n;i++)
     {
      string s=v[i]; StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      if(!SymbolSelect(s,true))
        { Riga(el,s+";0;;;NON TROVATO"); problemi++; continue; }
      MqlRates r[]; int got=-1;
      for(int k=0;k<15;k++)
        {
         if(SeriesInfoInteger(s,PERIOD_D1,SERIES_SYNCHRONIZED)||k>=10)
           { got=CopyRates(s,PERIOD_D1,InpFrom,TimeCurrent(),r); if(got>0) break; }
         Sleep(1000);
        }
      if(got<=0)
        { Riga(el,s+";0;;;NESSUN DATO"); problemi++; continue; }
      string f="ABTG_D1_"+s+".csv";
      FileDelete(f,FILE_COMMON);
      int h=FileOpen(f,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
      if(h==INVALID_HANDLE){ Riga(el,s+";0;;;ERRORE FILE"); problemi++; continue; }
      FileWriteString(h,"date;open;high;low;close;tickvol;spread\r\n");
      for(int j=0;j<got;j++)
         FileWriteString(h,TimeToString(r[j].time,TIME_DATE)+";"+DoubleToString(r[j].open,6)+";"+DoubleToString(r[j].high,6)+";"+DoubleToString(r[j].low,6)+";"+DoubleToString(r[j].close,6)+";"+IntegerToString((long)r[j].tick_volume)+";"+IntegerToString(r[j].spread)+"\r\n");
      FileClose(h);
      Riga(el,s+";"+IntegerToString(got)+";"+TimeToString(r[0].time,TIME_DATE)+";"+TimeToString(r[got-1].time,TIME_DATE)+";ok");
      Riga(prog,"fatto "+s+" righe="+IntegerToString(got));
      ok++;
     }
   Riga(fine,"ABTG_ExportD1 v1.00 simboli_ok="+IntegerToString(ok)+" problemi="+IntegerToString(problemi)+" ora="+TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS));
   if(problemi>0) Riga(fine,"ATTENZIONE: "+IntegerToString(problemi)+" simboli con problemi (vedi ABTG_D1_ELENCO.txt)");
   Print("ABTG_ExportD1: finito, ok=",ok," problemi=",problemi);
   if(InpChiudiTerminale) TerminalClose(0);
  }
