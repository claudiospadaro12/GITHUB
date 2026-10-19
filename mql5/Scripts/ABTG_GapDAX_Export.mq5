//+------------------------------------------------------------------+
//|                                        ABTG_GapDAX_Export.mq5     |
//|  SOLO LETTURA: esporta le barre M1 del DAX (D30EUR su BCM) nella |
//|  finestra 07:55-16:35 ORA SERVER, per il TEST DEL GAP.            |
//|  Non apre ordini, non tocca il conto. Scrive due file in          |
//|  MQL5\Files: ABTG_GapDAX_M1.csv e ABTG_GapDAX_orevol.csv.         |
//|  Regola fissa: il server BCM e' 1 ora indietro rispetto all'ora   |
//|  italiana (DAX apre 09:00 IT = 08:00 server; cash chiude 17:30 IT |
//|  = 16:30 server). Il file orevol serve a CONTROLLARE che sia cosi |
//|  nei dati (il picco dei volumi deve cadere alle 08:00 server).    |
//|  NON COMPILATO in questa sessione: va compilato in MetaEditor.    |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property strict
#property script_show_inputs

input string InpSimbolo   = "";                    // "" = simbolo del grafico (D30EUR)
input int    InpDaysBack  = 900;                   // giorni di calendario indietro
input string InpFileM1    = "ABTG_GapDAX_M1.csv";  // file barre
input string InpFileOre   = "ABTG_GapDAX_orevol.csv"; // file diagnostico per ora

void OnStart()
  {
   string sym=(InpSimbolo=="")? _Symbol : InpSimbolo;
   if(!SymbolSelect(sym,true)){ Print("[GAPDAX] simbolo non selezionabile: ",sym); return; }
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(sym,SYMBOL_POINT);

   MqlRates r[];
   ArraySetAsSeries(r,false);
   datetime to=TimeCurrent();
   datetime from=to-(datetime)InpDaysBack*86400;
   int n=CopyRates(sym,PERIOD_M1,from,to,r);
   if(n<=0){ PrintFormat("[GAPDAX] CopyRates M1 fallita su %s (n=%d, errore %d): storico M1 non scaricato?",sym,n,GetLastError()); return; }

   int h=FileOpen(InpFileM1,FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(h==INVALID_HANDLE){ Print("[GAPDAX] impossibile scrivere ",InpFileM1); return; }
   FileWriteString(h,"time;open;high;low;close;tickvol;spread_pts\r\n");

   double volOra[24]; int cntOra[24];
   ArrayInitialize(volOra,0.0); ArrayInitialize(cntOra,0);
   int scritte=0;
   for(int i=0;i<n;i++)
     {
      MqlDateTime s; TimeToStruct(r[i].time,s);
      int m=s.hour*60+s.min;
      volOra[s.hour]+=(double)r[i].tick_volume; cntOra[s.hour]++;
      if(m>=7*60+55 && m<=16*60+35)
        {
         string riga=TimeToString(r[i].time,TIME_DATE|TIME_MINUTES)+";"
                    +DoubleToString(r[i].open,dg)+";"+DoubleToString(r[i].high,dg)+";"
                    +DoubleToString(r[i].low,dg)+";"+DoubleToString(r[i].close,dg)+";"
                    +IntegerToString((long)r[i].tick_volume)+";"+IntegerToString(r[i].spread)+"\r\n";
         FileWriteString(h,riga);
         scritte++;
        }
     }
   FileClose(h);

   int h2=FileOpen(InpFileOre,FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(h2!=INVALID_HANDLE)
     {
      FileWriteString(h2,"ora_server;barre;tickvol_medio\r\n");
      for(int k=0;k<24;k++)
         FileWriteString(h2,IntegerToString(k)+";"+IntegerToString(cntOra[k])+";"+DoubleToString(cntOra[k]>0? volOra[k]/cntOra[k] : 0.0,1)+"\r\n");
      FileClose(h2);
     }
   PrintFormat("[GAPDAX] %s digits=%d point=%.5f barre M1 lette=%d scritte=%d prima=%s ultima=%s",
               sym,dg,pt,n,scritte,TimeToString(r[0].time),TimeToString(r[n-1].time));
  }
