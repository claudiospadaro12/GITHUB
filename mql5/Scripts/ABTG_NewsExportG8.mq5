//+------------------------------------------------------------------+
//|                                            ABTG_NewsExportG8.mq5   |
//|  v1.00 (19/11/2026) -- SOLA LETTURA, NESSUNA funzione di trading. |
//|  Esporta dal calendario economico di MT5 le notizie storiche      |
//|  (impatto >= medio) delle valute indicate, dal 2013, in           |
//|  Common\Files\abtg_news_hist_G8.csv (formato: Data Ora;Impatto;       |
//|  Valuta;Titolo, orario del SERVER del terminale). Poi scrive       |
//|  abtg_news_hist_G8_FINE.txt (riepilogo per anno) e chiude il terminale.|
//+------------------------------------------------------------------+
#property version "1.00"
#property strict

string Pulisci(string s){ StringReplace(s,";",","); StringReplace(s,"\r"," "); StringReplace(s,"\n"," "); return s; }

void OnStart()
  {
   datetime from=D'2013.01.01 00:00', to=TimeCurrent();
   string ccys[]; int nc=StringSplit("USD,EUR,GBP,JPY,AUD,NZD,CAD,CHF",',',ccys);
   // attesa della sincronizzazione del calendario (fino a ~3 minuti)
   MqlCalendarValue probe[]; bool pronto=false;
   for(int k=0;k<36 && !IsStopped();k++)
     {
      if(CalendarValueHistory(probe,to-30*86400,to,NULL,"USD")>0){ pronto=true; break; }
      Sleep(5000);
     }
   int h=FileOpen("abtg_news_hist_G8.csv",FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   string riep="";
   if(h==INVALID_HANDLE){ riep="ERRORE apertura file: "+IntegerToString(GetLastError()); }
   else
     {
      FileWriteString(h,"Data Ora;Impatto;Valuta;Titolo\r\n");
      int tot=0; int perAnno[40]; ArrayInitialize(perAnno,0);
      for(int c=0;c<nc;c++)
        for(int y=2013;y<=2026;y++)
          {
           datetime a=StringToTime(IntegerToString(y)+".01.01"), b=StringToTime(IntegerToString(y)+".12.31 23:59");
           if(a>to) continue; if(b>to) b=to;
           MqlCalendarValue v[];
           int n=CalendarValueHistory(v,a,b,NULL,ccys[c]);
           for(int i=0;i<n;i++)
             {
              MqlCalendarEvent ev; if(!CalendarEventById(v[i].event_id,ev)) continue;
              if((int)ev.importance<2) continue;
              string imp=((int)ev.importance>=3)?"High":"Moderate";
              FileWriteString(h,TimeToString(v[i].time,TIME_DATE|TIME_MINUTES)+";"+imp+";"+ccys[c]+";"+Pulisci(ev.name)+"\r\n");
              tot++; perAnno[y-2013]++;
             }
          }
      FileClose(h);
      riep="righe="+IntegerToString(tot)+" calendario_pronto="+(pronto?"si":"NO")+" offset_server_GMT_sec="+IntegerToString((int)(TimeTradeServer()-TimeGMT()))+" server="+AccountInfoString(ACCOUNT_SERVER)+"\r\nper anno (8 valute, impatto >= medio): ";
      for(int y=2013;y<=2026;y++) riep+=IntegerToString(y)+":"+IntegerToString(perAnno[y-2013])+" ";
     }
   int f=FileOpen("abtg_news_hist_G8_FINE.txt",FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(f!=INVALID_HANDLE){ FileWriteString(f,"fine "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n"+riep+"\r\n"); FileClose(f); }
   Print("[NewsExport] ",riep);
   TerminalClose(0);
  }
