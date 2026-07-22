//+------------------------------------------------------------------+
//|                                      ABTG_HistoryDownloader.mq5   |
//|                                                                  |
//|  Scarica lo STORICO dei prezzi dal broker per tutti i simboli    |
//|  (cross, indici, valute, metalli...) su piu' timeframe, cosi'    |
//|  i backtest/ottimizzazioni hanno dati veri e completi.           |
//|                                                                  |
//|  USO: trascina lo script su UN grafico qualsiasi, premi OK.      |
//|  Con InpListaSoloNomi=true stampa solo l'elenco esatto dei       |
//|  simboli del broker (utile per conoscere i ticker giusti).       |
//|                                                                  |
//|  Scrive anche un riepilogo in MQL5\Files\ABTG_StoricoScaricato.csv|
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimboli       = "";        // vuoto = TUTTI i simboli in Market Watch; oppure "D30EUR,NASUSD,XAUUSD,EURUSD,GBPUSD"
input string InpTimeframes    = "M1,M5,M15,M30,H1,H4,D1"; // TF da scaricare
input string InpDataInizio    = "2015.01.01"; // scarica dalla piu' vecchia possibile (o da questa data)
input bool   InpListaSoloNomi = false;     // true = stampa solo l'elenco dei simboli del broker ed esce
input bool   InpTuttiBroker   = false;     // true = usa TUTTI i simboli del broker (non solo Market Watch)
input int    InpTimeoutSec    = 60;        // secondi max di attesa download per simbolo/TF

//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TFfromString(string s)
  {
   StringToUpper(s);   // modifica s (copia locale) in maiuscolo
   if(s=="M1")  return PERIOD_M1;   if(s=="M2")  return PERIOD_M2;
   if(s=="M3")  return PERIOD_M3;   if(s=="M4")  return PERIOD_M4;
   if(s=="M5")  return PERIOD_M5;   if(s=="M6")  return PERIOD_M6;
   if(s=="M10") return PERIOD_M10;  if(s=="M12") return PERIOD_M12;
   if(s=="M15") return PERIOD_M15;  if(s=="M20") return PERIOD_M20;
   if(s=="M30") return PERIOD_M30;  if(s=="H1")  return PERIOD_H1;
   if(s=="H2")  return PERIOD_H2;   if(s=="H3")  return PERIOD_H3;
   if(s=="H4")  return PERIOD_H4;   if(s=="H6")  return PERIOD_H6;
   if(s=="H8")  return PERIOD_H8;   if(s=="H12") return PERIOD_H12;
   if(s=="D1")  return PERIOD_D1;   if(s=="W1")  return PERIOD_W1;
   if(s=="MN1") return PERIOD_MN1;
   return PERIOD_CURRENT;
  }

// spezza "A,B;C" in array
int Split(string src, string &out[])
  {
   StringReplace(src, ";", ",");
   return StringSplit(src, ',', out);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   // --- MODALITA' 1: elenca solo i nomi dei simboli -----------------
   if(InpListaSoloNomi)
     {
      bool all = InpTuttiBroker;
      int tot = SymbolsTotal(!all); // !all: true=solo Market Watch
      PrintFormat("=== ELENCO SIMBOLI (%s) : %d ===", all?"TUTTO IL BROKER":"MARKET WATCH", tot);
      string dump = "";
      for(int i=0; i<tot; i++)
        {
         string nm = SymbolName(i, !all);
         PrintFormat("  %s", nm);
         dump += nm + "\n";
        }
      int fh = FileOpen("ABTG_SimboliBroker.txt", FILE_WRITE|FILE_TXT|FILE_ANSI);
      if(fh!=INVALID_HANDLE){ FileWriteString(fh, dump); FileClose(fh); }
      Print("Elenco salvato in MQL5\\Files\\ABTG_SimboliBroker.txt");
      return;
     }

   // --- prepara la lista dei simboli --------------------------------
   string symbols[];
   int nsym = 0;
   if(StringLen(InpSimboli) > 0)
     {
      nsym = Split(InpSimboli, symbols);
      for(int i=0;i<nsym;i++){ StringTrimLeft(symbols[i]); StringTrimRight(symbols[i]); }
     }
   else
     {
      bool all = InpTuttiBroker;
      int tot = SymbolsTotal(!all);
      ArrayResize(symbols, tot);
      for(int i=0;i<tot;i++) symbols[i] = SymbolName(i, !all);
      nsym = tot;
     }

   // --- prepara i timeframe -----------------------------------------
   string tfstr[];
   int ntf = Split(InpTimeframes, tfstr);
   ENUM_TIMEFRAMES tfs[];
   ArrayResize(tfs, ntf);
   for(int i=0;i<ntf;i++)
     {
      StringTrimLeft(tfstr[i]); StringTrimRight(tfstr[i]);
      tfs[i] = TFfromString(tfstr[i]);
     }

   datetime from = StringToTime(InpDataInizio);
   if(from<=0) from = D'2015.01.01';

   // --- CSV di riepilogo --------------------------------------------
   int fh = FileOpen("ABTG_StoricoScaricato.csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(fh!=INVALID_HANDLE) FileWrite(fh, "Simbolo","Timeframe","Barre","PrimaData");

   PrintFormat("=== DOWNLOAD STORICO: %d simboli x %d TF, da %s ===", nsym, ntf, TimeToString(from, TIME_DATE));

   for(int s=0; s<nsym && !IsStopped(); s++)
     {
      string sym = symbols[s];
      if(StringLen(sym)==0) continue;
      if(!SymbolSelect(sym, true)) { PrintFormat("[%d/%d] %s : impossibile selezionarlo (salto)", s+1, nsym, sym); continue; }

      for(int t=0; t<ntf && !IsStopped(); t++)
        {
         ENUM_TIMEFRAMES tf = tfs[t];
         if(tf==PERIOD_CURRENT) continue;

         MqlRates r[];
         int got = -1, tries = 0, maxtries = InpTimeoutSec*4; // 250ms per giro
         datetime first = 0;
         while(!IsStopped() && tries < maxtries)
           {
            got = CopyRates(sym, tf, from, TimeCurrent(), r); // se manca, avvia il download
            if(got > 0){ first = r[0].time; break; }
            Sleep(250);
            tries++;
           }
         string tfn = StringSubstr(EnumToString(tf), 7); // "PERIOD_H4" -> "H4"
         if(got > 0)
            PrintFormat("[%d/%d] %-12s %-4s : %6d barre (da %s)", s+1, nsym, sym, tfn, got, TimeToString(first, TIME_DATE));
         else
            PrintFormat("[%d/%d] %-12s %-4s : NESSUN DATO (timeout)", s+1, nsym, sym, tfn);

         if(fh!=INVALID_HANDLE)
            FileWrite(fh, sym, tfn, (string)got, (got>0?TimeToString(first, TIME_DATE):"-"));
        }
     }

   if(fh!=INVALID_HANDLE) FileClose(fh);
   Print("=== FINITO. Riepilogo in MQL5\\Files\\ABTG_StoricoScaricato.csv ===");
   Comment("Download storico COMPLETATO. Puoi chiudere.");
  }
//+------------------------------------------------------------------+
