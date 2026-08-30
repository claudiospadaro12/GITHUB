//+------------------------------------------------------------------+
//|                                            ABTG_SpreadTick.mq5    |
//|                                                                  |
//|  MISURA LO SPREAD REALE dai TICK STORICI gia' sul disco.         |
//|                                                                  |
//|  PERCHE' ESISTE (la domanda che decide):                        |
//|  la cassaforte FASE 2 (long PF 1.083) e' un edge SOTTILE: se i   |
//|  costi se lo mangiano, non e' un edge. La corsa cassaforte       |
//|  girava con Spread=0 nell'ini a Model 4 (Ogni tick su tick       |
//|  reali). Ma Model 4 usa lo spread VERO solo se i tick portano    |
//|  BID **E** ASK. Se i tick NASUSD sono SOLO-BID, allora Spread=0  |
//|  = spread ZERO = il PF 1.083 e' OTTIMISTA.                       |
//|                                                                  |
//|  COSA MISURA (e stampa in referto + CSV):                       |
//|   1. LA RIGA CHE DECIDE: per ogni tick, ha un ASK valido?        |
//|      (flag TICK_FLAG_ASK oppure ask>0 && ask>=bid). Conta e      |
//|      stampa la % di tick con ask valido vs % solo-bid.           |
//|   2. Distribuzione dello SPREAD (solo sui tick con ask valido)   |
//|      DURANTE LA SEDUTA del motore (finestra oraria in ora        |
//|      SERVER BCM): mediana, P90, P95, max -- in PUNTI INDICE      |
//|      (spread_MT5 / InpPuntiPerIndice; R97: 1 pto indice = 100    |
//|      pti MT5 su NASUSD).                                         |
//|                                                                  |
//|  USO: si lancia da RIGA_SPREAD_NASUSD.ps1 (StartUp Script via    |
//|  .ini). In manuale: trascina lo script su un grafico NASUSD,     |
//|  carica il preset, OK. Scrive in MQL5\Files:                     |
//|     spread_tick_NASUSD.csv  +  REFERTO_SPREAD_NASUSD.txt         |
//|                                                                  |
//|  NON e' un test, NON apre ordini: legge tick e conta. Punto.     |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimbolo        = "NASUSD";        // simbolo BCM da misurare
input string InpDataInizio     = "2024.09.26";    // inizio finestra (tick reali dal 2024.09.26)
input string InpDataFine       = "2026.06.30";    // fine finestra
input int    InpSessInizioMin  = 870;             // seduta: inizio in MINUTI da mezzanotte, ORA SERVER (14:30 = 870)
input int    InpSessFineMin    = 1260;            // seduta: fine in MINUTI da mezzanotte, ORA SERVER (21:00 = 1260)
input double InpPuntiPerIndice = 100.0;           // R97: 1 pto indice = 100 pti MT5 su NASUSD
input int    InpGiorniBlocco   = 7;               // lettura tick a blocchi di N giorni (memoria: ~1-2 M tick/blocco)
input string InpFileCsv        = "spread_tick_NASUSD.csv";
input string InpFileTxt        = "REFERTO_SPREAD_NASUSD.txt";

// istogramma dello spread in PUNTI MT5 (risoluzione 1 punto MT5).
// Cap a 100000 pti MT5 = 1000 pti indice: oltre si conta in overflow,
// il max VERO si tiene comunque a parte (esatto).
#define MAXBIN 100001

//+------------------------------------------------------------------+
//| Percentile da istogramma: ritorna il bin (in pti MT5) dove la    |
//| frazione cumulata 'frac' viene raggiunta. Se cade in overflow,   |
//| 'inOverflow' = true (il valore vero e' >= MAXBIN).               |
//+------------------------------------------------------------------+
long PercentileBin(const long &h[], long overflow, long total, double frac, bool &inOverflow)
  {
   inOverflow = false;
   if(total <= 0) return -1;
   double soglia = frac * (double)total;
   long cum = 0;
   for(int b=0; b<MAXBIN; b++)
     {
      cum += h[b];
      if((double)cum >= soglia) return (long)b;
     }
   // la soglia cade oltre il cap: sta nell'overflow
   inOverflow = true;
   return (long)MAXBIN;
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   string sym = InpSimbolo;
   StringTrimLeft(sym); StringTrimRight(sym);
   if(!SymbolSelect(sym, true))
     {
      PrintFormat("ERRORE: impossibile selezionare il simbolo %s", sym);
      return;
     }

   double point = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(point <= 0.0) point = 0.01; // fallback prudente

   datetime from = StringToTime(InpDataInizio);
   datetime to   = StringToTime(InpDataFine);
   if(from <= 0) from = D'2024.09.26';
   if(to   <= 0) to   = TimeCurrent();
   if(to > TimeCurrent()) to = TimeCurrent();

   //--- contatori BID/ASK sull'INTERA finestra (la riga che decide) ---
   long totTick     = 0;   // tick totali letti
   long nAskFlag    = 0;   // tick col flag TICK_FLAG_ASK
   long nAskPos     = 0;   // tick con ask > 0
   long nAskUsabile = 0;   // tick con ask > 0 && ask >= bid  (usabili per lo spread)
   long nSoloBid    = 0;   // tick con ask <= 0  (SOLO-BID: il caso che smaschera Spread=0)

   //--- distribuzione spread: solo tick con ask usabile, DENTRO la seduta ---
   long   histo[MAXBIN];
   ArrayInitialize(histo, 0);
   long   sessTick      = 0;   // tick nella seduta (con ask usabile)
   long   overflow      = 0;   // spread oltre il cap MAXBIN
   long   maxSpreadPts  = 0;   // max VERO in pti MT5 (esatto, anche oltre il cap)
   double sumSpreadPts  = 0.0; // per la media
   long   sessTickTot   = 0;   // tick totali nella seduta (ask usabile o no)
   long   sessSoloBid   = 0;   // solo-bid dentro la seduta

   PrintFormat("=== SPREAD TICK %s : da %s a %s (blocchi di %d gg, point=%.5f) ===",
               sym, TimeToString(from, TIME_DATE), TimeToString(to, TIME_DATE),
               InpGiorniBlocco, point);

   int giorniBlocco = InpGiorniBlocco; if(giorniBlocco < 1) giorniBlocco = 1;
   long passo = (long)giorniBlocco * 24 * 3600;
   int nBlocchi = 0;

   datetime a = from;
   while(a < to && !IsStopped())
     {
      datetime b = (datetime)((long)a + passo);
      if(b > to) b = to;

      MqlTick tk[];
      int got = CopyTicksRange(sym, tk, COPY_TICKS_ALL, (ulong)a*1000, (ulong)b*1000);
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

            //--- filtro seduta (ora SERVER BCM) ---
            MqlDateTime dt;
            TimeToStruct(tk[i].time, dt);
            int mod = dt.hour*60 + dt.min;
            bool inSeduta = (mod >= InpSessInizioMin && mod < InpSessFineMin);
            if(!inSeduta) continue;

            sessTickTot++;
            if(!askPos) sessSoloBid++;
            if(!askUsab) continue;

            //--- spread in punti MT5 ---
            double sprRaw = (tk[i].ask - tk[i].bid) / point;
            long   sprPts = (long)MathRound(sprRaw);
            if(sprPts < 0) sprPts = 0;

            sessTick++;
            sumSpreadPts += (double)sprPts;
            if(sprPts > maxSpreadPts) maxSpreadPts = sprPts;

            if(sprPts < MAXBIN) histo[(int)sprPts]++;
            else                overflow++;
           }
        }

      nBlocchi++;
      if(nBlocchi % 4 == 0 || b >= to)
         PrintFormat("  ... %s : %I64d tick letti, %I64d nella seduta (ask usabile)",
                     TimeToString(b, TIME_DATE), totTick, sessTick);

      a = b;
     }

   //--- percentili dall'istogramma ---
   bool ovMed=false, ovP90=false, ovP95=false;
   long binMed = PercentileBin(histo, overflow, sessTick, 0.50, ovMed);
   long binP90 = PercentileBin(histo, overflow, sessTick, 0.90, ovP90);
   long binP95 = PercentileBin(histo, overflow, sessTick, 0.95, ovP95);

   double medIdx = (binMed<0)? -1 : (double)binMed / InpPuntiPerIndice;
   double p90Idx = (binP90<0)? -1 : (double)binP90 / InpPuntiPerIndice;
   double p95Idx = (binP95<0)? -1 : (double)binP95 / InpPuntiPerIndice;
   double maxIdx = (double)maxSpreadPts / InpPuntiPerIndice;
   double meanPts = (sessTick>0)? sumSpreadPts/(double)sessTick : 0.0;
   double meanIdx = meanPts / InpPuntiPerIndice;

   //--- percentuali BID/ASK ---
   double pAskFlag = (totTick>0)? 100.0*(double)nAskFlag/(double)totTick : 0.0;
   double pAskPos  = (totTick>0)? 100.0*(double)nAskPos /(double)totTick : 0.0;
   double pAskUsab = (totTick>0)? 100.0*(double)nAskUsabile/(double)totTick : 0.0;
   double pSoloBid = (totTick>0)? 100.0*(double)nSoloBid/(double)totTick : 0.0;

   //--- LA LETTURA (criteri congelati nel referto) ---
   //  Solo-bid "molti" = soglia prudente 5% dei tick senza ask valido.
   bool moltiSoloBid = (pSoloBid >= 5.0);
   string verdettoBidAsk;
   if(moltiSoloBid)
      verdettoBidAsk = "ATTENZIONE: MOLTI TICK SOLO-BID -> la cassaforte a Spread=0 e' OTTIMISTA. Rifare la corsa con Spread = P95 misurato.";
   else
      verdettoBidAsk = "OK: ask valido su ~tutti i tick -> a Model 4 lo spread VERO e' stato usato; Spread=0 e' onesto SE la mediana spread e' bassa.";

   //====================================================================
   //  CSV (tabellare, la riga BID/ASK in cima perche' e' quella che decide)
   //====================================================================
   int fh = FileOpen(InpFileCsv, FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh != INVALID_HANDLE)
     {
      FileWrite(fh, "Sezione","Metrica","Valore","Nota");
      FileWrite(fh, "BIDASK","tick_totali",          (string)totTick, "intera finestra");
      FileWrite(fh, "BIDASK","pct_ask_flag",         DoubleToString(pAskFlag,3), "TICK_FLAG_ASK");
      FileWrite(fh, "BIDASK","pct_ask_positivo",     DoubleToString(pAskPos,3),  "ask>0");
      FileWrite(fh, "BIDASK","pct_ask_usabile",      DoubleToString(pAskUsab,3), "ask>0 && ask>=bid");
      FileWrite(fh, "BIDASK","pct_solo_bid",         DoubleToString(pSoloBid,3), "ask<=0 (SMASCHERA Spread=0)");
      FileWrite(fh, "BIDASK","verdetto",             (moltiSoloBid?"SOLO_BID_MOLTI":"ASK_OK"), verdettoBidAsk);
      FileWrite(fh, "SEDUTA","finestra_min_server",  (string)InpSessInizioMin+"-"+(string)InpSessFineMin, "minuti da mezzanotte, ora SERVER BCM");
      FileWrite(fh, "SEDUTA","tick_seduta_totali",   (string)sessTickTot, "tutti i tick nella seduta");
      FileWrite(fh, "SEDUTA","tick_seduta_ask_usab", (string)sessTick, "usati per lo spread");
      FileWrite(fh, "SEDUTA","tick_seduta_solo_bid", (string)sessSoloBid, "solo-bid nella seduta");
      FileWrite(fh, "SPREAD","mediana_idx",  (ovMed?">1000":DoubleToString(medIdx,4)), "punti indice");
      FileWrite(fh, "SPREAD","p90_idx",      (ovP90?">1000":DoubleToString(p90Idx,4)), "punti indice");
      FileWrite(fh, "SPREAD","p95_idx",      (ovP95?">1000":DoubleToString(p95Idx,4)), "punti indice");
      FileWrite(fh, "SPREAD","max_idx",      DoubleToString(maxIdx,4), "punti indice (esatto)");
      FileWrite(fh, "SPREAD","media_idx",    DoubleToString(meanIdx,4), "punti indice");
      FileWrite(fh, "SPREAD","mediana_ptsMT5", (ovMed?">100000":(string)binMed), "punti MT5");
      FileWrite(fh, "SPREAD","p95_ptsMT5",     (ovP95?">100000":(string)binP95), "punti MT5");
      FileWrite(fh, "SPREAD","max_ptsMT5",     (string)maxSpreadPts, "punti MT5 (esatto)");
      FileWrite(fh, "SPREAD","overflow_tick",  (string)overflow, "tick oltre il cap istogramma");
      FileClose(fh);
     }

   //====================================================================
   //  REFERTO testo (formato pulito, la riga BID/ASK in cima)
   //====================================================================
   int th = FileOpen(InpFileTxt, FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(th != INVALID_HANDLE)
     {
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "  SPREAD REALE DAI TICK STORICI -- "+sym+" @ BCM\r\n");
      FileWriteString(th, "=====================================================================\r\n");
      FileWriteString(th, "finestra    : "+TimeToString(from,TIME_DATE)+" -> "+TimeToString(to,TIME_DATE)+"\r\n");
      FileWriteString(th, "seduta      : minuti "+(string)InpSessInizioMin+"-"+(string)InpSessFineMin+" ora SERVER BCM (14:30-21:00)\r\n");
      FileWriteString(th, "conversione : 1 pto indice = "+DoubleToString(InpPuntiPerIndice,0)+" pti MT5 (R97); point="+DoubleToString(point,5)+"\r\n");
      FileWriteString(th, "tick letti  : "+(string)totTick+"\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  1) LA RIGA CHE DECIDE -- BID/ASK\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  % tick con TICK_FLAG_ASK      : "+DoubleToString(pAskFlag,3)+" %\r\n");
      FileWriteString(th, "  % tick con ask > 0            : "+DoubleToString(pAskPos,3)+" %\r\n");
      FileWriteString(th, "  % tick con ask usabile        : "+DoubleToString(pAskUsab,3)+" %  (ask>0 && ask>=bid)\r\n");
      FileWriteString(th, "  % tick SOLO-BID (ask<=0)      : "+DoubleToString(pSoloBid,3)+" %\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "  VERDETTO: "+verdettoBidAsk+"\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  2) DISTRIBUZIONE SPREAD (seduta, solo tick con ask usabile)\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  tick seduta (totali)          : "+(string)sessTickTot+"\r\n");
      FileWriteString(th, "  tick seduta (ask usabile)     : "+(string)sessTick+"\r\n");
      FileWriteString(th, "  tick seduta SOLO-BID          : "+(string)sessSoloBid+"\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "                     PUNTI INDICE      PUNTI MT5\r\n");
      FileWriteString(th, "  mediana spread   :  "+PadIdx(ovMed,medIdx)+"     "+(ovMed?">100000":(string)binMed)+"\r\n");
      FileWriteString(th, "  P90 spread       :  "+PadIdx(ovP90,p90Idx)+"     "+(ovP90?">100000":(string)binP90)+"\r\n");
      FileWriteString(th, "  P95 spread       :  "+PadIdx(ovP95,p95Idx)+"     "+(ovP95?">100000":(string)binP95)+"\r\n");
      FileWriteString(th, "  max spread       :  "+DoubleToString(maxIdx,4)+"     "+(string)maxSpreadPts+"\r\n");
      FileWriteString(th, "  media spread     :  "+DoubleToString(meanIdx,4)+"     "+DoubleToString(meanPts,1)+"\r\n");
      FileWriteString(th, "  overflow (oltre cap): "+(string)overflow+" tick\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  COME SI LEGGE (criteri congelati)\r\n");
      FileWriteString(th, "---------------------------------------------------------------------\r\n");
      FileWriteString(th, "  - Se ASK valido su ~tutti i tick E mediana bassa (1-2 pti indice):\r\n");
      FileWriteString(th, "    la cassaforte a Spread=0 ha usato spread reale, PF 1.083 e' ONESTO,\r\n");
      FileWriteString(th, "    e lo spread NON e' il collo di bottiglia.\r\n");
      FileWriteString(th, "  - Se MOLTI tick sono SOLO-BID: PF 1.083 e' OTTIMISTA -> la corsa\r\n");
      FileWriteString(th, "    cassaforte va RIFATTA imponendo Spread = P95 misurato.\r\n");
      FileWriteString(th, "  - CANCELLO S0: la mediana TAKE LORDO del motore (dal per-trade\r\n");
      FileWriteString(th, "    cassaforte) deve essere >= ~3-4x lo spread mediano. Soglia\r\n");
      FileWriteString(th, "    dichiarata; il take si confronta DOPO, con quel numero alla mano.\r\n");
      FileWriteString(th, "\r\n");
      FileWriteString(th, "  CAVEAT: broker singolo (BCM), una sola finestra storica, spread\r\n");
      FileWriteString(th, "  misurato sui tick del broker (non e' lo spread di esecuzione live).\r\n");
      FileClose(th);
     }

   PrintFormat("=== SPREAD FINITO === %s : ask_usabile=%.2f%%, solo_bid=%.2f%%, mediana=%s idx, P95=%s idx (n seduta=%I64d)",
               sym, pAskUsab, pSoloBid,
               (ovMed?">1000":DoubleToString(medIdx,3)),
               (ovP95?">1000":DoubleToString(p95Idx,3)), sessTick);
   Comment("SPREAD TICK "+sym+" COMPLETATO. Referto in MQL5\\Files\\"+InpFileTxt+". Puoi chiudere.");
  }

//+------------------------------------------------------------------+
//| impagina il valore in punti indice, o ">1000" se in overflow     |
//+------------------------------------------------------------------+
string PadIdx(bool overflow, double val)
  {
   if(overflow) return ">1000  ";
   string s = DoubleToString(val, 4);
   while(StringLen(s) < 7) s = s + " ";
   return s;
  }
//+------------------------------------------------------------------+
