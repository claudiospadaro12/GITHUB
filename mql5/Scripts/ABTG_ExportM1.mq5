//+------------------------------------------------------------------+
//|                                          ABTG_ExportM1.mq5       |
//|  v1.00 (26/10/2026) -- SOLA LETTURA. NON COMPILATA.              |
//|  NESSUNA funzione di trading: esporta le barre M1 di un simbolo  |
//|  fra due date (ora del SERVER) in Common\Files\ABTG_M1_<sim>.csv |
//|  Serve a ricostruire l'EQUITA intraday dalle operazioni chiuse   |
//|  del tester (analisi del DD giornaliero prop).                   |
//|  Criteri: report/EQUITA_GIORNALIERA_PROP_CRITERI_2026-10-26.md   |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpSimbolo = "XAUUSD";        // simbolo
input string InpDa      = "2025.01.01";    // dalla data (ora del server)
input string InpA       = "2026.10.01";    // alla data esclusa
input bool   InpChiudiTerminale = false;   // true SOLO nel lancio automatico

void OnStart()
  {
   Print("ABTG_ExportM1 v1.00: SOLA LETTURA, nessun ordine.");
   datetime d0=StringToTime(InpDa+" 00:00");
   datetime d1=StringToTime(InpA+" 00:00");
   string nome="ABTG_M1_"+InpSimbolo+".csv";
   SymbolSelect(InpSimbolo,true);
   int dig=(int)SymbolInfoInteger(InpSimbolo,SYMBOL_DIGITS);
   int h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   long totale=0; datetime primo=0, ultimo=0; int settimane_vuote=0, errori=0;
   if(h==INVALID_HANDLE)
     {
      PrintFormat("EXPORT: impossibile aprire %s, err=%d",nome,GetLastError());
      errori++;
     }
   else
     {
      FileWriteString(h,"time;open;high;low;close;tickvol;spread\r\n");
      datetime cur=d0;
      while(cur<d1)
        {
         datetime nxt=cur+7*86400;
         if(nxt>d1) nxt=d1;
         MqlRates r[];
         int got=-1;
         for(int k=0;k<40;k++)
           {
            ResetLastError();
            got=CopyRates(InpSimbolo,PERIOD_M1,cur,nxt-1,r);
            if(got>0) break;
            if(got==0 && k>=3) break;     // settimana senza barre (weekend, festivi)
            Sleep(500);
           }
         if(got>0)
           {
            for(int i=0;i<got;i++)
              {
               string riga=TimeToString(r[i].time,TIME_DATE|TIME_MINUTES)+";"+DoubleToString(r[i].open,dig)+";"+DoubleToString(r[i].high,dig)+";"+DoubleToString(r[i].low,dig)+";"+DoubleToString(r[i].close,dig)+";"+IntegerToString((long)r[i].tick_volume)+";"+IntegerToString(r[i].spread)+"\r\n";
               FileWriteString(h,riga);
              }
            totale+=got;
            if(primo==0) primo=r[0].time;
            ultimo=r[got-1].time;
           }
         else if(got==0) settimane_vuote++;
         else { errori++; PrintFormat("EXPORT: CopyRates fallita dal %s, err=%d",TimeToString(cur),GetLastError()); }
         cur=nxt;
        }
      FileClose(h);
     }
   PrintFormat("EXPORT %s: barre=%I64d primo=%s ultimo=%s settimane_vuote=%d errori=%d",InpSimbolo,totale,TimeToString(primo),TimeToString(ultimo),settimane_vuote,errori);
   int hf=FileOpen("ABTG_M1_FINE.txt",FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hf!=INVALID_HANDLE)
     {
      FileWriteString(hf,StringFormat("FINE %s barre=%I64d primo=%s ultimo=%s settimane_vuote=%d errori=%d\r\n",TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS),totale,TimeToString(primo),TimeToString(ultimo),settimane_vuote,errori));
      FileClose(hf);
     }
   if(InpChiudiTerminale){ Sleep(2000); TerminalClose(0); }
  }
