//+------------------------------------------------------------------+
//|                                        ABTG_Apertura_Study.mq5    |
//|                                                                  |
//|  STUDIO dell'APERTURA (DAX / Nasdaq / altro) - "prima i dati".    |
//|                                                                  |
//|  Domanda: all'apertura ci sono due strade, LONG o SHORT.          |
//|  Quale ha davvero l'edge? E un filtro di trend (H4) migliora?     |
//|  E soprattutto: quanto resta dell'edge una volta pagato lo        |
//|  SLIPPAGE realistico del breakout (consiglio dell'amico)?         |
//|                                                                  |
//|  Il tester riempie gli stop al prezzo esatto: e' OTTIMISTA. Qui   |
//|  peggioro l'entry di InpSlippagePts punti, come nella realta'.    |
//|                                                                  |
//|  Per OGNI giorno costruisce il range di apertura dei primi        |
//|  InpRangeMinutes minuti, mette i livelli di breakout +/- buffer,  |
//|  vede quale parte "buca" per prima, entra (con slippage), e       |
//|  misura se arriva a TP (= InpTP_R * rischio) prima dello stop     |
//|  (= lato opposto del range). Aggrega: LONG vs SHORT, con e senza  |
//|  filtro H4. Scrive ABTG_Apertura_Study_<simbolo>.csv in MQL5\Files|
//|                                                                  |
//|  USO: trascina lo script sul grafico del simbolo (D30EUR per il   |
//|  DAX, NASUSD per il Nasdaq). Imposta l'ORA d'apertura del TUO     |
//|  broker (server) e premi OK.                                      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#property script_show_inputs

input int    InpSessionHour   = 9;      // Ora APERTURA (server/broker!): DAX~9-10, Nasdaq cash~15/16
input int    InpSessionMin    = 0;      // Minuti apertura
input int    InpRangeMinutes  = 15;     // Minuti del range di apertura
input int    InpCutoffHour    = 17;     // Ora entro cui chiudo la giornata (server)
input int    InpCutoffMin     = 30;     // Minuti
input double InpBufferPts     = 200;    // Buffer oltre il range, in PUNTI (_Point)
input double InpSlippagePts   = 100;    // Slippage stimato sull'entry, in PUNTI (0 = tester ottimista)
input double InpTP_R          = 2.0;    // Take profit come multiplo del rischio (R)
input int    InpDaysBack      = 600;    // Quanti giorni di calendario indietro
input int    InpH4EmaPeriod   = 50;     // EMA su H4 per il filtro di trend

//--- risultati di un singolo giorno
struct DayTrade { int dir; double rmult; int h4; bool valid; };

//+------------------------------------------------------------------+
int TimeMinOfDay(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.hour*60+s.min; }
int DayKey(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.year*1000+s.day_of_year; }

//+------------------------------------------------------------------+
void OnStart()
  {
   double pt = _Point;
   double buf = InpBufferPts*pt;
   double slip= InpSlippagePts*pt;
   int openMin  = InpSessionHour*60+InpSessionMin;
   int rangeEnd = openMin+InpRangeMinutes;
   int cutoff   = InpCutoffHour*60+InpCutoffMin;

   datetime to   = TimeCurrent();
   datetime from = to - (datetime)InpDaysBack*24*60*60;

   MqlRates m5[];
   int n = CopyRates(_Symbol, PERIOD_M5, from, to, m5);
   if(n<=0){ Print("Nessun dato M5. Scarica lo storico (ABTG_HistoryDownloader) e riprova."); return; }

   // H4 + EMA per il filtro di trend
   MqlRates h4[];
   int nh = CopyRates(_Symbol, PERIOD_H4, from, to, h4);
   double ema[]; int nema=0;
   if(nh>InpH4EmaPeriod)
     {
      ArrayResize(ema,nh);
      double k=2.0/(InpH4EmaPeriod+1.0);
      ema[0]=h4[0].close;
      for(int i=1;i<nh;i++) ema[i]=h4[i].close*k+ema[i-1]*(1.0-k);
      nema=nh;
     }

   // filtro H4 al tempo t: +1 se close>ema (up), -1 se sotto, 0 se ignoto
   // (indice H4 = ultima candela H4 chiusa prima di t)

   DayTrade rows[]; ArrayResize(rows,0);
   int fh=FileOpen("ABTG_Apertura_Study_"+_Symbol+".csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ';');
   if(fh!=INVALID_HANDLE)
      FileWrite(fh,"data","dir(LONG/SHORT)","risultato_R","H4trend","note");

   int i=0;
   while(i<n)
     {
      int dk=DayKey(m5[i].time);
      // raccogli il range di apertura di questa giornata
      double hi=-1,lo=-1; bool haveRange=false;
      int j=i;
      double dayHiSeen=0;
      // trova hi/lo nella finestra [openMin, rangeEnd)
      for(; j<n && DayKey(m5[j].time)==dk; j++)
        {
         int mm=TimeMinOfDay(m5[j].time);
         if(mm>=openMin && mm<rangeEnd)
           {
            if(!haveRange){ hi=m5[j].high; lo=m5[j].low; haveRange=true; }
            else { if(m5[j].high>hi) hi=m5[j].high; if(m5[j].low<lo) lo=m5[j].low; }
           }
         if(mm>=rangeEnd) break;
        }
      if(!haveRange || hi<=lo){ // niente range valido: salta al giorno dopo
         while(i<n && DayKey(m5[i].time)==dk) i++; continue; }

      double buyLvl = hi+buf, sellLvl = lo-buf;
      // filtro H4: trova ultima candela H4 chiusa prima dell'apertura di oggi
      int h4trend=0;
      if(nema>0)
        {
         datetime openT = m5[j<n?j:i].time;
         int idx=-1;
         for(int h=0; h<nema; h++){ if(h4[h].time<=openT) idx=h; else break; }
         if(idx>=0) h4trend = (h4[idx].close>ema[idx]) ? +1 : -1;
        }

      // gestione: dal fine-range fino al cutoff, chi buca per primo
      int dir=0; double entry=0, sl=0, tp=0, res=0; bool done=false, opened=false;
      for(int b=j; b<n && DayKey(m5[b].time)==dk; b++)
        {
         int mm=TimeMinOfDay(m5[b].time);
         if(mm>=cutoff) break;
         if(!opened)
           {
            bool hitBuy  = (m5[b].high>=buyLvl);
            bool hitSell = (m5[b].low <=sellLvl);
            if(hitBuy && !hitSell){ dir=+1; }
            else if(hitSell && !hitBuy){ dir=-1; }
            else if(hitBuy && hitSell){ dir = (m5[b].close>=m5[b].open)?+1:-1; } // ambigua: uso la direzione della candela
            else continue;
            if(dir>0){ entry=buyLvl+slip; sl=sellLvl; }
            else     { entry=sellLvl-slip; sl=buyLvl; }
            double risk = MathAbs(entry-sl);
            if(risk<=0){ dir=0; continue; }
            tp = (dir>0)? entry+InpTP_R*risk : entry-InpTP_R*risk;
            opened=true;
            continue; // gestisco dalla candela successiva
           }
         // posizione aperta: TP o SL?
         double risk = MathAbs(entry-sl);
         if(dir>0)
           {
            if(m5[b].low<=sl){ res=-1.0; done=true; break; }
            if(m5[b].high>=tp){ res=InpTP_R; done=true; break; }
           }
         else
           {
            if(m5[b].high>=sl){ res=-1.0; done=true; break; }
            if(m5[b].low<=tp){ res=InpTP_R; done=true; break; }
           }
        }
      if(opened && !done)
        {
         // chiusura a fine giornata: R parziale sul close dell'ultima candela util
         int last=j; for(int b=j;b<n && DayKey(m5[b].time)==dk;b++){ if(TimeMinOfDay(m5[b].time)>=cutoff) break; last=b; }
         double risk=MathAbs(entry-sl);
         res = (dir>0)?(m5[last].close-entry)/risk : (entry-m5[last].close)/risk;
         done=true;
        }

      if(opened && done)
        {
         DayTrade dt; dt.dir=dir; dt.rmult=res; dt.h4=h4trend; dt.valid=true;
         int sz=ArraySize(rows); ArrayResize(rows,sz+1); rows[sz]=dt;
         if(fh!=INVALID_HANDLE)
            FileWrite(fh, TimeToString(m5[i].time,TIME_DATE), (dir>0?"LONG":"SHORT"),
                      DoubleToString(res,2), (h4trend>0?"UP":(h4trend<0?"DOWN":"?")), "");
        }

      // avanza al giorno successivo
      while(i<n && DayKey(m5[i].time)==dk) i++;
     }
   if(fh!=INVALID_HANDLE) FileClose(fh);

   // ---- aggregati
   Aggrega("TUTTI i breakout (cio' che fa l'EA ora: cieco)", rows, 0, false);
   Aggrega("Solo LONG", rows, +1, false);
   Aggrega("Solo SHORT", rows, -1, false);
   Aggrega("Con FILTRO H4 (opero solo a favore del trend H4)", rows, 0, true);
   Print("== Studio apertura ", _Symbol, " completato. CSV in MQL5\\Files\\ABTG_Apertura_Study_",_Symbol,".csv ==");
   Print("Slippage applicato: ", InpSlippagePts, " pt | buffer ", InpBufferPts, " pt | TP ", InpTP_R, " R | range ", InpRangeMinutes, " min");
  }

//+------------------------------------------------------------------+
//| Aggrega e stampa: dirFilter 0=tutti; +1 solo long; -1 solo short |
//| h4filter: se true, tiene solo i trade allineati al trend H4      |
//+------------------------------------------------------------------+
void Aggrega(string titolo, DayTrade &r[], int dirFilter, bool h4filter)
  {
   int nTot=0, nWin=0; double sumR=0, best=-1e9, worst=1e9;
   for(int i=0;i<ArraySize(r);i++)
     {
      if(!r[i].valid) continue;
      if(dirFilter!=0 && r[i].dir!=dirFilter) continue;
      if(h4filter)
        {
         if(r[i].h4==0) continue;
         if(r[i].dir!=r[i].h4) continue; // opero solo se breakout concorde col trend H4
        }
      nTot++; sumR+=r[i].rmult;
      if(r[i].rmult>0) nWin++;
      if(r[i].rmult>best) best=r[i].rmult;
      if(r[i].rmult<worst) worst=r[i].rmult;
     }
   if(nTot==0){ Print(StringFormat("[%s] nessun trade.",titolo)); return; }
   double exp=sumR/nTot;                       // aspettativa in R per trade
   double win=100.0*nWin/nTot;
   Print(StringFormat("[%s]  trade=%d  win%%=%.1f  aspettativa=%.3f R/trade  totale=%.1f R  (best %.1f / worst %.1f)",
                      titolo, nTot, win, exp, sumR, best, worst));
  }
//+------------------------------------------------------------------+
