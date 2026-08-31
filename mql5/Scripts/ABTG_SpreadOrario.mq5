//+------------------------------------------------------------------+
//|                                          ABTG_SpreadOrario.mq5    |
//|                                                                  |
//|  SPREAD ORARIO MULTI-SIMBOLO v2 -- misura lo SPREAD REALE dai    |
//|  TICK STORICI gia' sul disco, PER FASCIA ORARIA (ora SERVER),    |
//|  su PIU' SIMBOLI in una corsa sola.                              |
//|                                                                  |
//|  PERCHE' ESISTE (direzione di Claudio, 31/08 sera):              |
//|  "dobbiamo usare simboli col minimo attrito". La risposta di     |
//|  casa e' MISURARE, non dichiarare: oggi tutti i prova usano      |
//|  "spread 2.0 [NON MISURATO]". Questo Script produce il numero    |
//|  vero, simbolo per simbolo, ora per ora.                         |
//|                                                                  |
//|  DISCENDE da ABTG_SpreadTick.mq5 (23/08, un solo simbolo, una    |
//|  sola finestra di seduta). Cosa cambia nella v2:                 |
//|   1. MULTI-SIMBOLO: InpSimboli e' una lista separata da virgole  |
//|      (default: NASUSD,U30USD,D30EUR = i tre indici della         |
//|      flotta). Il ciclo usa SymbolSelect + CopyTicksRange:        |
//|      NON servono grafici multipli, un solo Script su un solo     |
//|      grafico lavora tutti i simboli in sequenza. E' la scelta    |
//|      piu' robusta: niente coordinazione fra chart, niente        |
//|      profili da preparare a mano.                                |
//|   2. FASCIA ORARIA: per ogni ORA DEL GIORNO in ORA SERVER BCM    |
//|      (0-23) tiene un istogramma separato e stampa media,         |
//|      MEDIANA e P95 dello spread in PUNTI INDICE, piu' il max.    |
//|   3. RIGA BID/ASK (invariata dalla v1, e' quella che decide):    |
//|      % di tick con ask valido vs % solo-bid, per simbolo.        |
//|                                                                  |
//|  PERIODO DI RACCOLTA (dichiarato): la finestra dei TICK REALI    |
//|  gia' scaricati, default 2024.09.26 -> 2026.06.30 (~21 mesi).    |
//|  NON e' una raccolta live di 3-5 giorni: e' MEGLIO -- centinaia  |
//|  di giorni di mercato, e non tocca ne' VPS ne' mercato aperto.   |
//|                                                                  |
//|  OUTPUT in MQL5\Files:                                           |
//|   - spread_orario_<SIMBOLO>.csv   (uno per simbolo, 24 righe     |
//|     orarie + riga TUTTO)                                         |
//|   - REFERTO_SPREAD_FLOTTA.txt     (unico, scritto e FLUSHATO     |
//|     simbolo per simbolo: leggibile A META' CORSA -- pattern      |
//|     DUKA del referto parziale)                                   |
//|                                                                  |
//|  RIGHE DI CHIUSURA nel log (le legge la riga PowerShell):        |
//|   - "SPREAD SIMBOLO FINITO <sym>"  a fine di ogni simbolo        |
//|   - "SPREAD FLOTTA FINITA"         a fine corsa                  |
//|                                                                  |
//|  USO: pilotato da RIGA_SPREAD_FLOTTA.ps1 (StartUp Script via     |
//|  .ini, SOLO sul PC di backtest). In manuale: trascina su un      |
//|  grafico qualunque, carica il preset, OK.                        |
//|                                                                  |
//|  NON e' un test, NON apre ordini: legge tick e conta. Punto.     |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimboli        = "NASUSD,U30USD,D30EUR"; // simboli BCM, separati da virgola
input string InpDataInizio     = "2024.09.26";    // inizio finestra (tick reali dal 2024.09.26)
input string InpDataFine       = "2026.06.30";    // fine finestra
input double InpPuntiPerIndice = 100.0;           // 1 pto indice = 100 pti MT5 (R97 NASUSD; conversione 100 MISURATA anche su U30USD e D30EUR)
input int    InpGiorniBlocco   = 7;               // lettura tick a blocchi di N giorni (memoria)
input string InpPrefissoCsv    = "spread_orario_";       // CSV per simbolo: <prefisso><SIMBOLO>.csv
input string InpFileTxt        = "REFERTO_SPREAD_FLOTTA.txt";

// istogramma spread in PUNTI MT5 (risoluzione 1 punto MT5), UNO PER ORA.
// Cap a 100000 pti MT5 = 1000 pti indice: oltre si conta in overflow,
// il max VERO si tiene comunque a parte (esatto).
#define MAXBIN 100001
#define NORE   24

long gHisto[];   // NORE * MAXBIN, appiattito: [ora*MAXBIN + bin]

//+------------------------------------------------------------------+
//| Percentile dall'istogramma dell'ora 'h': bin (pti MT5) dove la   |
//| frazione cumulata 'frac' viene raggiunta. inOverflow=true se     |
//| cade oltre il cap (valore vero >= MAXBIN).                       |
//+------------------------------------------------------------------+
long PercentileOra(int h, long totale, double frac, bool &inOverflow)
  {
   inOverflow = false;
   if(totale <= 0) return -1;
   double soglia = frac * (double)totale;
   long cum = 0;
   int base = h * MAXBIN;
   for(int b=0; b<MAXBIN; b++)
     {
      cum += gHisto[base + b];
      if((double)cum >= soglia) return (long)b;
     }
   inOverflow = true;
   return (long)MAXBIN;
  }

//+------------------------------------------------------------------+
//| impagina un valore in punti indice a larghezza fissa             |
//+------------------------------------------------------------------+
string PadIdx(bool overflow, double val)
  {
   if(overflow) return ">1000  ";
   string s = DoubleToString(val, 3);
   while(StringLen(s) < 7) s = " " + s;
   return s;
  }

//+------------------------------------------------------------------+
//| misura UN simbolo: riempie CSV proprio e appende al referto th.  |
//| Ritorna true se il simbolo e' stato misurato (anche con 0 tick   |
//| il CSV esce: un CSV vuoto e' un fatto, non un errore taciuto).   |
//+------------------------------------------------------------------+
bool MisuraSimbolo(const string symIn, const datetime from, const datetime to, const int th)
  {
   string sym = symIn;
   StringTrimLeft(sym); StringTrimRight(sym);
   if(sym == "") return false;

   if(!SymbolSelect(sym, true))
     {
      PrintFormat("ERRORE: impossibile selezionare il simbolo %s", sym);
      if(th != INVALID_HANDLE)
        {
         FileWriteString(th, "\r\n!!! " + sym + ": SIMBOLO NON SELEZIONABILE -- saltato.\r\n");
         FileFlush(th);
        }
      return false;
     }

   double point = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(point <= 0.0) point = 0.01; // fallback prudente

   //--- azzera lo stato per-simbolo ---
   ArrayInitialize(gHisto, 0);
   long   oreTickTot[NORE];   ArrayInitialize(oreTickTot, 0);   // tutti i tick dell'ora
   long   oreAskUsab[NORE];   ArrayInitialize(oreAskUsab, 0);   // tick con ask usabile
   long   oreSoloBid[NORE];   ArrayInitialize(oreSoloBid, 0);   // tick con ask<=0
   long   oreOverflow[NORE];  ArrayInitialize(oreOverflow, 0);
   long   oreMaxPts[NORE];    ArrayInitialize(oreMaxPts, 0);
   double oreSumPts[NORE];    ArrayInitialize(oreSumPts, 0.0);

   long totTick     = 0;
   long nAskFlag    = 0;
   long nAskPos     = 0;
   long nAskUsabile = 0;
   long nSoloBid    = 0;

   PrintFormat("=== SPREAD ORARIO %s : da %s a %s (blocchi di %d gg, point=%.5f) ===",
               sym, TimeToString(from, TIME_DATE), TimeToString(to, TIME_DATE),
               InpGiorniBlocco, point);

   int giorniBlocco = InpGiorniBlocco; if(giorniBlocco < 1) giorniBlocco = 1;
   long passo = (long)giorniBlocco * 24 * 3600;
   int nBlocchi = 0;
   long blocchiPersi = 0;   // blocchi che NON si sono fatti leggere (got<0)

   datetime a = from;
   while(a < to && !IsStopped())
     {
      datetime b = (datetime)((long)a + passo);
      if(b > to) b = to;

      MqlTick tk[];
      //  IL PRIMO accesso alla base tick di un simbolo APPENA messo in
      //  Market Watch da SymbolSelect torna -1 (o 0) mentre il terminale
      //  la apre/sincronizza: senza ritenta il blocco si perde IN
      //  SILENZIO e la tabella esce PLAUSIBILE E FALSA. Qui morde piu'
      //  che nella v1: li' si leggeva il simbolo DEL GRAFICO (gia'
      //  sincronizzato), qui due simboli su tre entrano a corsa avviata.
      //  Stesso pattern gia' PROVATO in ABTG_HistoryDownloader.mq5
      //  (DownloadTicks, righe 38-46).
      int got = -1, tries = 0;
      while(!IsStopped() && tries < 240)          // 240 x 250 ms = 60 s per blocco
        {
         got = CopyTicksRange(sym, tk, COPY_TICKS_ALL, (ulong)a*1000, (ulong)b*1000);
         if(got > 0) break;
         if(got == 0 && tries > 8) break;         // finestra davvero senza tick
         Sleep(250); tries++;
        }
      if(got < 0) blocchiPersi++;
      if(got > 0)
        {
         for(int i=0; i<got; i++)
           {
            totTick++;

            bool askFlag = ((tk[i].flags & TICK_FLAG_ASK) != 0);
            bool askPos  = (tk[i].ask > 0.0);
            bool askUsab = (tk[i].ask > 0.0 && tk[i].ask >= tk[i].bid);

            if(askFlag) nAskFlag++;
            if(askPos)  nAskPos++;  else nSoloBid++;
            if(askUsab) nAskUsabile++;

            MqlDateTime dt;
            TimeToStruct(tk[i].time, dt);
            int h = dt.hour;
            if(h < 0 || h >= NORE) continue;

            oreTickTot[h]++;
            if(!askPos) oreSoloBid[h]++;
            if(!askUsab) continue;

            double sprRaw = (tk[i].ask - tk[i].bid) / point;
            long   sprPts = (long)MathRound(sprRaw);
            if(sprPts < 0) sprPts = 0;

            oreAskUsab[h]++;
            oreSumPts[h] += (double)sprPts;
            if(sprPts > oreMaxPts[h]) oreMaxPts[h] = sprPts;

            if(sprPts < MAXBIN) gHisto[h*MAXBIN + (int)sprPts]++;
            else                oreOverflow[h]++;
           }
        }

      nBlocchi++;
      if(nBlocchi % 8 == 0 || b >= to)
         PrintFormat("  ... %s %s : %I64d tick letti", sym, TimeToString(b, TIME_DATE), totTick);

      a = b;
     }

   //--- aggregato TUTTO IL GIORNO (somma delle ore) ---
   long totAskUsab = 0, totSoloBidSed = 0, totOver = 0, totMaxPts = 0;
   double totSumPts = 0.0;
   for(int h=0; h<NORE; h++)
     {
      totAskUsab   += oreAskUsab[h];
      totSoloBidSed+= oreSoloBid[h];
      totOver      += oreOverflow[h];
      totSumPts    += oreSumPts[h];
      if(oreMaxPts[h] > totMaxPts) totMaxPts = oreMaxPts[h];
     }

   //--- percentuali BID/ASK ---
   double pAskFlag = 0.0, pAskPos = 0.0, pAskUsab = 0.0, pSoloBid = 0.0;
   if(totTick > 0)
     {
      pAskFlag = 100.0*(double)nAskFlag/(double)totTick;
      pAskPos  = 100.0*(double)nAskPos /(double)totTick;
      pAskUsab = 100.0*(double)nAskUsabile/(double)totTick;
      pSoloBid = 100.0*(double)nSoloBid/(double)totTick;
     }
   bool moltiSoloBid = (pSoloBid >= 5.0);
   string verdettoBidAsk;
   if(moltiSoloBid)
      verdettoBidAsk = "ATTENZIONE: MOLTI TICK SOLO-BID -> ogni corsa a Spread=0 su questo simbolo e' OTTIMISTA. Imporre Spread = P95 misurato.";
   else
      verdettoBidAsk = "OK: ask valido su ~tutti i tick -> a Model 4 lo spread VERO viene usato.";

   //=================================================================
   //  CSV per simbolo: 24 righe orarie + riga TUTTO
   //=================================================================
   string csvName = InpPrefissoCsv + sym + ".csv";
   int fh = FileOpen(csvName, FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh != INVALID_HANDLE)
     {
      FileWrite(fh, "ora_server","tick_totali","tick_ask_usabili","tick_solo_bid",
                    "media_idx","mediana_idx","p95_idx","max_idx","overflow_tick");
      for(int h=0; h<NORE; h++)
        {
         bool ovM=false, ovP=false;
         long binM = PercentileOra(h, oreAskUsab[h], 0.50, ovM);
         long binP = PercentileOra(h, oreAskUsab[h], 0.95, ovP);
         string sMed = "n/d", sP95 = "n/d", sAvg = "n/d", sMax = "n/d";
         if(oreAskUsab[h] > 0)
           {
            if(ovM) sMed = ">1000"; else sMed = DoubleToString((double)binM/InpPuntiPerIndice, 4);
            if(ovP) sP95 = ">1000"; else sP95 = DoubleToString((double)binP/InpPuntiPerIndice, 4);
            sAvg = DoubleToString((oreSumPts[h]/(double)oreAskUsab[h])/InpPuntiPerIndice, 4);
            sMax = DoubleToString((double)oreMaxPts[h]/InpPuntiPerIndice, 4);
           }
         FileWrite(fh, IntegerToString(h),
                       (string)oreTickTot[h], (string)oreAskUsab[h], (string)oreSoloBid[h],
                       sAvg, sMed, sP95, sMax, (string)oreOverflow[h]);
        }
      // riga TUTTO: percentili sul giorno intero (istogrammi sommati)
        {
         bool ovM=false, ovP=false;
         long cum = 0; long binM = -1; long binP = -1;
         double sM = 0.50 * (double)totAskUsab;
         double sP = 0.95 * (double)totAskUsab;
         if(totAskUsab > 0)
           {
            for(int b=0; b<MAXBIN; b++)
              {
               long somma = 0;
               for(int h=0; h<NORE; h++) somma += gHisto[h*MAXBIN + b];
               cum += somma;
               if(binM < 0 && (double)cum >= sM) binM = (long)b;
               if(binP < 0 && (double)cum >= sP) { binP = (long)b; break; }
              }
            if(binM < 0) { binM = (long)MAXBIN; ovM = true; }
            if(binP < 0) { binP = (long)MAXBIN; ovP = true; }
           }
         string sMed = "n/d", sP95 = "n/d", sAvg = "n/d", sMax = "n/d";
         if(totAskUsab > 0)
           {
            if(ovM) sMed = ">1000"; else sMed = DoubleToString((double)binM/InpPuntiPerIndice, 4);
            if(ovP) sP95 = ">1000"; else sP95 = DoubleToString((double)binP/InpPuntiPerIndice, 4);
            sAvg = DoubleToString((totSumPts/(double)totAskUsab)/InpPuntiPerIndice, 4);
            sMax = DoubleToString((double)totMaxPts/InpPuntiPerIndice, 4);
           }
         FileWrite(fh, "TUTTO",
                       (string)totTick, (string)totAskUsab, (string)totSoloBidSed,
                       sAvg, sMed, sP95, sMax, (string)totOver);
        }
      FileClose(fh);
     }

   //=================================================================
   //  REFERTO: sezione del simbolo, poi FLUSH (parziale leggibile)
   //=================================================================
   if(th != INVALID_HANDLE)
     {
      FileWriteString(th, "\r\n");
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "  " + sym + " -- spread reale dai tick storici, per ORA SERVER BCM\r\n");
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "tick letti  : " + (string)totTick + "\r\n");
      FileWriteString(th, "blocchi persi: " + (string)blocchiPersi + "  (se > 0 la tabella e' PARZIALE: tick non letti)\r\n");
      FileWriteString(th, "conversione : 1 pto indice = " + DoubleToString(InpPuntiPerIndice,0) + " pti MT5; point=" + DoubleToString(point,5) + "\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "  1) LA RIGA CHE DECIDE -- BID/ASK\r\n");
      FileWriteString(th, "     % ask valido (flag)  : " + DoubleToString(pAskFlag,3) + " %\r\n");
      FileWriteString(th, "     % ask usabile        : " + DoubleToString(pAskUsab,3) + " %  (ask>0 && ask>=bid)\r\n");
      FileWriteString(th, "     % SOLO-BID (ask<=0)  : " + DoubleToString(pSoloBid,3) + " %\r\n");
      FileWriteString(th, "     VERDETTO: " + verdettoBidAsk + "\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "  2) SPREAD PER FASCIA ORARIA (punti indice; solo tick con ask usabile)\r\n");
      FileWriteString(th, "     ora | n tick (ask ok) |   media | mediana |     P95 |     max\r\n");
      FileWriteString(th, "     ----+-----------------+---------+---------+---------+--------\r\n");
      for(int h=0; h<NORE; h++)
        {
         string riga;
         string sh = IntegerToString(h);
         if(StringLen(sh) < 2) sh = "0" + sh;
         if(oreAskUsab[h] <= 0)
           {
            riga = "      " + sh + " |               0 |     n/d |     n/d |     n/d |     n/d\r\n";
           }
         else
           {
            bool ovM=false, ovP=false;
            long binM = PercentileOra(h, oreAskUsab[h], 0.50, ovM);
            long binP = PercentileOra(h, oreAskUsab[h], 0.95, ovP);
            double avg = (oreSumPts[h]/(double)oreAskUsab[h])/InpPuntiPerIndice;
            string sn = (string)oreAskUsab[h];
            while(StringLen(sn) < 15) sn = " " + sn;
            riga = "      " + sh + " | " + sn + " | " +
                   PadIdx(false, avg) + " | " +
                   PadIdx(ovM, (double)binM/InpPuntiPerIndice) + " | " +
                   PadIdx(ovP, (double)binP/InpPuntiPerIndice) + " | " +
                   PadIdx(false, (double)oreMaxPts[h]/InpPuntiPerIndice) + "\r\n";
           }
         FileWriteString(th, riga);
        }
      FileWriteString(th, "\r\n");
      FileWriteString(th, "  CSV tabellare: " + csvName + " (24 righe orarie + riga TUTTO)\r\n");
      FileFlush(th);   // pattern DUKA: il referto e' leggibile anche a meta' corsa
     }

   PrintFormat("SPREAD SIMBOLO FINITO %s : tick=%I64d, blocchi_persi=%I64d, ask_usabile=%.2f%%, solo_bid=%.2f%%",
               sym, totTick, blocchiPersi, pAskUsab, pSoloBid);
   return true;
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   datetime from = StringToTime(InpDataInizio);
   datetime to   = StringToTime(InpDataFine);
   if(from <= 0) from = D'2024.09.26';
   if(to   <= 0) to   = TimeCurrent();
   if(to > TimeCurrent()) to = TimeCurrent();

   ArrayResize(gHisto, NORE * MAXBIN);   // ~19 MB: sta in memoria senza problemi

   //--- spezza la lista dei simboli ---
   string parti[];
   int n = StringSplit(InpSimboli, ',', parti);
   if(n <= 0)
     {
      Print("ERRORE: InpSimboli vuoto.");
      return;
     }

   //--- referto unico, scritto in coda simbolo per simbolo ---
   int th = FileOpen(InpFileTxt, FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(th != INVALID_HANDLE)
     {
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "  SPREAD ORARIO FLOTTA -- tick storici @ BCM (SPREAD ORARIO MULTI-SIMBOLO v2)\r\n");
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "data referto: " + TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES) + " (ora del PC)\r\n");
      FileWriteString(th, "finestra    : " + TimeToString(from,TIME_DATE) + " -> " + TimeToString(to,TIME_DATE) + " (tick storici su disco)\r\n");
      FileWriteString(th, "simboli     : " + InpSimboli + "\r\n");
      FileWriteString(th, "ore         : ORA SERVER BCM (= ora italiana - 1 in questo periodo)\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "COME SI LEGGE (criteri congelati, invariati dal 23/08):\r\n");
      FileWriteString(th, " - la % SOLO-BID decide: >=5% -> le corse a Spread=0 sono OTTIMISTE.\r\n");
      FileWriteString(th, " - cancello C2 di casa: il TAKE LORDO MEDIANO del motore deve stare\r\n");
      FileWriteString(th, "   >= 3x lo spread MEDIANO dell'ORA in cui il motore lavora (non\r\n");
      FileWriteString(th, "   della media di giornata). Fra 2,5x e 3,5x il verdetto NON si da'.\r\n");
      FileWriteString(th, " - le ore da guardare: NASUSD/U30USD -> 14-20 (cash USA), D30EUR -> 8-16.\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "CAVEAT: broker singolo (BCM), spread dai tick del broker (non e' lo\r\n");
      FileWriteString(th, "spread di esecuzione live); niente slippage qui dentro.\r\n");
      FileFlush(th);
     }

   int fatti = 0;
   for(int i=0; i<n && !IsStopped(); i++)
     {
      if(MisuraSimbolo(parti[i], from, to, th)) fatti++;
     }

   if(th != INVALID_HANDLE)
     {
      FileWriteString(th, "\r\n=====================================================================\r\n");
      FileWriteString(th, "  FINE: " + (string)fatti + " simboli misurati su " + (string)n + " richiesti.\r\n");
      FileWriteString(th, "=====================================================================\r\n");
      FileClose(th);
     }

   PrintFormat("SPREAD FLOTTA FINITA : %d simboli misurati su %d richiesti.", fatti, n);
   Comment("SPREAD ORARIO FLOTTA COMPLETATO (" + (string)fatti + "/" + (string)n + "). Referto in MQL5\\Files\\" + InpFileTxt + ". Puoi chiudere.");
  }
//+------------------------------------------------------------------+
