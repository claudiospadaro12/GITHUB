//+------------------------------------------------------------------+
//|                                     ABTG_Apertura_Study_EA.mq5    |
//|                                                                  |
//|  STUDIO dell'APERTURA come EA per lo STRATEGY TESTER (1 passaggio)|
//|  -> si lancia da PowerShell con un .ini, come le ottimizzazioni.  |
//|                                                                  |
//|  Domanda: all'apertura ci sono due strade, LONG o SHORT. Quale    |
//|  ha l'edge? E un filtro di trend H4 migliora? E soprattutto:      |
//|  quanto resta una volta pagato lo SLIPPAGE realistico (amico)?    |
//|                                                                  |
//|  NON invia ordini: SIMULA. Per ogni giorno costruisce il range    |
//|  di apertura, mette i livelli +/- buffer, vede chi buca per primo,|
//|  entra (pagando lo slippage) e misura se arriva a TP (= R multipli|
//|  del rischio) prima dello stop (lato opposto del range).          |
//|                                                                  |
//|  A fine test scrive ABTG_Apertura_Study_<simbolo>.csv in          |
//|  MQL5\Files e stampa il riepilogo (LONG vs SHORT, con/senza H4)   |
//|  nel giornale del tester.                                         |
//|                                                                  |
//|  Elabora in modo INCREMENTALE (bar per bar) -> affidabile nel     |
//|  tester, non dipende da CopyRates sul range completo.             |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

input int    InpSessionHour   = 9;      // Ora APERTURA (SERVER/broker): DAX~9, Nasdaq cash~15
input int    InpSessionMin    = 0;      // Minuti apertura (Nasdaq: 30)
input int    InpRangeMinutes  = 15;     // Minuti del range di apertura
input int    InpCutoffHour    = 17;     // Ora entro cui chiudo la giornata (server)
input int    InpCutoffMin     = 30;     // Minuti
input double InpBufferPts     = 200;    // Buffer oltre il range, in PUNTI (_Point)
input double InpSlippagePts   = 100;    // Slippage stimato sull'entry, in PUNTI (0 = tester ottimista)
input double InpTP_R          = 2.0;    // Take profit come multiplo del rischio (R)
input int    InpH4EmaPeriod   = 50;     // EMA su H4 per il filtro di trend

//--- accumulo risultati (un elemento per giorno con trade)
int    gDir[];       // +1 long, -1 short
double gR[];         // risultato in R
int    gH4[];        // +1 up, -1 down, 0 ignoto
//--- METRICHE NUOVE (una per trade, parallele a gDir)
double gWidth[];     // ampiezza range di apertura (in PUNTI)
double gMAEr[];      // massima escursione AVVERSA in R (quanto e' andato contro)
double gMFEr[];      // massima escursione FAVOREVOLE in R (quanto e' corso a favore)
double gMAEp[];      // MAE in PUNTI
double gMFEp[];      // MFE in PUNTI
int    gBarsIn[];    // barre M5 in trade (durata)

//--- stato del giorno corrente
int      gDayKey     = -1;
bool     gHaveRange  = false;
bool     gArmed      = false;   // range chiuso, livelli pronti
bool     gOpened     = false;   // breakout scattato
bool     gFinished   = false;   // giorno gia' concluso (1 trade/giorno)
double   gHi, gLo, gBuy, gSell;
int      gTradeDir;
double   gEntry, gSL, gTP;
int      gH4trend;
//--- stato del trade corrente (per MAE/MFE/ampiezza/durata)
double   gCurWidthPts = 0;  // ampiezza range del giorno, in PUNTI
double   gCurRiskPrc  = 0;  // rischio (entry->SL) in PREZZO, per convertire in R
double   gCurMAEprc   = 0;  // running max escursione avversa (PREZZO)
double   gCurMFEprc   = 0;  // running max escursione favorevole (PREZZO)
int      gCurBars     = 0;  // running barre in trade

int      gEmaH4 = INVALID_HANDLE;
datetime gLastBar = 0;

//+------------------------------------------------------------------+
int TimeMinOfDay(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.hour*60+s.min; }
int DayKey(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.year*1000+s.day_of_year; }

//+------------------------------------------------------------------+
int gBars = 0;   // candele M5 chiuse processate (per diagnostica: 0 = niente dati)

int OnInit()
  {
   gEmaH4 = iMA(_Symbol, PERIOD_H4, InpH4EmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   ArrayResize(gDir,0); ArrayResize(gR,0); ArrayResize(gH4,0);
   // marker: conferma che l'EA e' partito nel tester (in Common\Files)
   int fm=FileOpen("ABTG_Apertura_Study_"+_Symbol+"_START.txt", FILE_WRITE|FILE_TXT|FILE_COMMON);
   if(fm!=INVALID_HANDLE){ FileWrite(fm,"EA di studio avviato su "+_Symbol); FileClose(fm); }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void ResetDay(int dk)
  {
   gDayKey=dk; gHaveRange=false; gArmed=false; gOpened=false; gFinished=false;
   gHi=-1; gLo=-1; gTradeDir=0;
  }

//+------------------------------------------------------------------+
int H4TrendNow()
  {
   double ema[1];
   if(gEmaH4==INVALID_HANDLE) return(0);
   if(CopyBuffer(gEmaH4,0,1,1,ema)!=1) return(0);
   double c = iClose(_Symbol, PERIOD_H4, 1);
   if(c<=0) return(0);
   return (c>ema[0]) ? +1 : -1;
  }

//+------------------------------------------------------------------+
void RecordTrade(int dir, double rmult, int h4)
  {
   int sz=ArraySize(gDir);
   ArrayResize(gDir,sz+1); ArrayResize(gR,sz+1); ArrayResize(gH4,sz+1);
   ArrayResize(gWidth,sz+1); ArrayResize(gMAEr,sz+1); ArrayResize(gMFEr,sz+1);
   ArrayResize(gMAEp,sz+1); ArrayResize(gMFEp,sz+1); ArrayResize(gBarsIn,sz+1);
   gDir[sz]=dir; gR[sz]=rmult; gH4[sz]=h4;
   gWidth[sz]=gCurWidthPts;                       // gia' in PUNTI
   // gCurMAEprc / gCurMFEprc sono in PREZZO: converto a PUNTI e a R
   gMAEp[sz]=gCurMAEprc/_Point; gMFEp[sz]=gCurMFEprc/_Point;
   gMAEr[sz]=(gCurRiskPrc>0)? gCurMAEprc/gCurRiskPrc : 0;
   gMFEr[sz]=(gCurRiskPrc>0)? gCurMFEprc/gCurRiskPrc : 0;
   gBarsIn[sz]=gCurBars;
  }

//+------------------------------------------------------------------+
//| Aggiorna MAE/MFE del trade aperto con l'escursione di 1 candela  |
//| MAE = quanto va CONTRO (verso lo SL); MFE = quanto va A FAVORE.   |
//| Lavora in PREZZO; la conversione a punti/R avviene in RecordTrade.|
//+------------------------------------------------------------------+
void UpdateExcursion(double h, double l)
  {
   double adv, fav;
   if(gTradeDir>0){ adv=gEntry-l;  fav=h-gEntry; }   // LONG: contro=sotto entry, favore=sopra
   else           { adv=h-gEntry;  fav=gEntry-l; }   // SHORT: contro=sopra entry, favore=sotto
   if(adv>gCurMAEprc) gCurMAEprc=adv;
   if(fav>gCurMFEprc) gCurMFEprc=fav;
   gCurBars++;
  }

//+------------------------------------------------------------------+
//| Processa UNA candela M5 chiusa (OHLC)                            |
//+------------------------------------------------------------------+
void ProcessBar(datetime t, double o, double h, double l, double c)
  {
   gBars++;
   int dk = DayKey(t);
   if(dk!=gDayKey)
     {
      // chiudo eventuale trade rimasto aperto dal giorno precedente
      if(gOpened && !gFinished)
        {
         double risk=MathAbs(gEntry-gSL);
         double r = (gTradeDir>0)?(c-gEntry)/risk:(gEntry-c)/risk; // approssimato sul nuovo open
         RecordTrade(gTradeDir, r, gH4trend);
        }
      ResetDay(dk);
     }

   int mm = TimeMinOfDay(t);
   int openMin  = InpSessionHour*60+InpSessionMin;
   int rangeEnd = openMin+InpRangeMinutes;
   int cutoff   = InpCutoffHour*60+InpCutoffMin;
   double buf   = InpBufferPts*_Point;
   double slip  = InpSlippagePts*_Point;

   if(gFinished) return;

   // 1) costruzione range [openMin, rangeEnd)
   if(mm>=openMin && mm<rangeEnd)
     {
      if(!gHaveRange){ gHi=h; gLo=l; gHaveRange=true; }
      else { if(h>gHi) gHi=h; if(l<gLo) gLo=l; }
      return;
     }

   // 2) chiusura range -> armo i livelli (una volta)
   if(mm>=rangeEnd && !gArmed)
     {
      if(!gHaveRange || gHi<=gLo){ gFinished=true; return; } // niente range: salto il giorno
      gBuy=gHi+buf; gSell=gLo-buf; gArmed=true;
      gH4trend=H4TrendNow();
     }
   if(!gArmed) return;

   // oltre l'orario di chiusura: liquido e chiudo il giorno
   if(mm>=cutoff)
     {
      if(gOpened && !gFinished)
        {
         UpdateExcursion(h,l); // conto anche l'ultima candela
         double risk=MathAbs(gEntry-gSL);
         double r=(gTradeDir>0)?(c-gEntry)/risk:(gEntry-c)/risk;
         RecordTrade(gTradeDir, r, gH4trend);
        }
      gFinished=true; return;
     }

   // 3) niente posizione: cerco il breakout
   if(!gOpened)
     {
      bool hitBuy =(h>=gBuy);
      bool hitSell=(l<=gSell);
      int dir=0;
      if(hitBuy && !hitSell) dir=+1;
      else if(hitSell && !hitBuy) dir=-1;
      else if(hitBuy && hitSell) dir=(c>=o)?+1:-1;   // candela ambigua: uso la sua direzione
      else return;
      if(dir>0){ gEntry=gBuy+slip; gSL=gSell; }
      else     { gEntry=gSell-slip; gSL=gBuy; }
      double risk=MathAbs(gEntry-gSL);
      if(risk<=0) return;
      gTP=(dir>0)?gEntry+InpTP_R*risk:gEntry-InpTP_R*risk;
      gTradeDir=dir; gOpened=true;
      // inizializzo le metriche del trade (MAE/MFE/ampiezza/durata)
      gCurWidthPts=(gHi-gLo)/_Point;
      gCurRiskPrc =risk;
      gCurMAEprc  =0; gCurMFEprc=0; gCurBars=0;
      return; // gestisco dalla candela successiva
     }

   // 4) posizione aperta: aggiorno MAE/MFE, poi TP o SL su questa candela?
   UpdateExcursion(h,l);
   if(gTradeDir>0)
     {
      if(l<=gSL){ RecordTrade(gTradeDir,-1.0,gH4trend); gFinished=true; return; }
      if(h>=gTP){ RecordTrade(gTradeDir,InpTP_R,gH4trend); gFinished=true; return; }
     }
   else
     {
      if(h>=gSL){ RecordTrade(gTradeDir,-1.0,gH4trend); gFinished=true; return; }
      if(l<=gTP){ RecordTrade(gTradeDir,InpTP_R,gH4trend); gFinished=true; return; }
     }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   // processo solo alla CHIUSURA di ogni candela M5
   datetime bt = iTime(_Symbol, PERIOD_M5, 0);
   if(bt==gLastBar) return;
   gLastBar=bt;
   // la candela appena chiusa e' shift 1
   datetime t=iTime(_Symbol,PERIOD_M5,1);
   if(t<=0) return;
   double o=iOpen(_Symbol,PERIOD_M5,1), h=iHigh(_Symbol,PERIOD_M5,1),
          l=iLow(_Symbol,PERIOD_M5,1),  c=iClose(_Symbol,PERIOD_M5,1);
   if(h<=0) return;
   ProcessBar(t,o,h,l,c);
  }

//+------------------------------------------------------------------+
void Aggrega(int fsum, string titolo, int dirFilter, bool h4filter)
  {
   int nTot=0,nWin=0; double sumR=0,best=-1e9,worst=1e9;
   double sumW=0, sumMFE=0;                 // su TUTTI i trade
   double sumMAEwin=0, sumMFEwin=0, maeWinMax=0; // solo VINCENTI
   for(int i=0;i<ArraySize(gDir);i++)
     {
      if(dirFilter!=0 && gDir[i]!=dirFilter) continue;
      if(h4filter){ if(gH4[i]==0) continue; if(gDir[i]!=gH4[i]) continue; }
      nTot++; sumR+=gR[i]; sumW+=gWidth[i]; sumMFE+=gMFEr[i];
      if(gR[i]>best) best=gR[i]; if(gR[i]<worst) worst=gR[i];
      if(gR[i]>0)
        {
         nWin++; sumMAEwin+=gMAEr[i]; sumMFEwin+=gMFEr[i];
         if(gMAEr[i]>maeWinMax) maeWinMax=gMAEr[i];
        }
     }
   if(nTot==0)
     {
      PrintFormat("[%s] nessun trade.",titolo);
      if(fsum!=INVALID_HANDLE) FileWrite(fsum,titolo,0,"-","-","-","-","-","-","-","-","-","-");
      return;
     }
   double exp=sumR/nTot, win=100.0*nWin/nTot;
   double avgW=sumW/nTot, avgMFEall=sumMFE/nTot;
   double avgMAEwin=(nWin>0)?sumMAEwin/nWin:0, avgMFEwin=(nWin>0)?sumMFEwin/nWin:0;
   PrintFormat("[%s]  trade=%d  win%%=%.1f  attesa=%.3f R  tot=%.1f R  |  ampiezza=%.0f pt  MAE_vinc=%.2f R (max %.2f)  MFE_vinc=%.2f R",
               titolo, nTot, win, exp, sumR, avgW, avgMAEwin, maeWinMax, avgMFEwin);
   if(fsum!=INVALID_HANDLE)
      FileWrite(fsum, titolo, nTot, DoubleToString(win,1), DoubleToString(exp,3),
                DoubleToString(sumR,1), DoubleToString(best,1), DoubleToString(worst,1),
                DoubleToString(avgW,0), DoubleToString(avgMAEwin,2), DoubleToString(maeWinMax,2),
                DoubleToString(avgMFEwin,2), DoubleToString(avgMFEall,2));
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // FILE_COMMON: nel tester i file vanno nella sandbox dell'agente; con
   // FILE_COMMON finiscono in ...\Terminal\Common\Files (raccoglibili).
   int fh=FileOpen("ABTG_Apertura_Study_"+_Symbol+".csv", FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON, ';');
   if(fh!=INVALID_HANDLE)
     {
      FileWrite(fh,"idx","dir","risultato_R","H4trend","ampiezza_pt",
                "MAE_pt","MFE_pt","MAE_R","MFE_R","barre");
      for(int i=0;i<ArraySize(gDir);i++)
         FileWrite(fh, i, (gDir[i]>0?"LONG":"SHORT"), DoubleToString(gR[i],2),
                   (gH4[i]>0?"UP":(gH4[i]<0?"DOWN":"?")),
                   DoubleToString(gWidth[i],0),
                   DoubleToString(gMAEp[i],0), DoubleToString(gMFEp[i],0),
                   DoubleToString(gMAEr[i],2), DoubleToString(gMFEr[i],2), gBarsIn[i]);
      FileClose(fh);
     }
   // file di RIEPILOGO (comodo da mandare): una riga per scenario
   int fs=FileOpen("ABTG_Apertura_Study_"+_Symbol+"_RIEPILOGO.csv", FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON, ';');
   if(fs!=INVALID_HANDLE)
     {
      FileWrite(fs,"simbolo",_Symbol,"apertura",StringFormat("%02d:%02d",InpSessionHour,InpSessionMin),
                "buffer",(int)InpBufferPts,"slippage",(int)InpSlippagePts,"TP_R",DoubleToString(InpTP_R,1),
                "candeleM5_processate",gBars);
      FileWrite(fs,"scenario","trade","win%","aspettativa_R","totale_R","best_R","worst_R",
                "ampiezza_pt","MAE_R_vinc","MAE_R_max_vinc","MFE_R_vinc","MFE_R_tutti");
     }
   Print("================ STUDIO APERTURA ", _Symbol, " ================");
   PrintFormat("Parametri: apertura %02d:%02d  range %d min  buffer %.0f pt  slippage %.0f pt  TP %.1f R",
               InpSessionHour,InpSessionMin,InpRangeMinutes,InpBufferPts,InpSlippagePts,InpTP_R);
   Aggrega(fs,"TUTTI i breakout (cieco = come fa l'EA ora)", 0, false);
   Aggrega(fs,"Solo LONG",  +1, false);
   Aggrega(fs,"Solo SHORT", -1, false);
   Aggrega(fs,"Con FILTRO H4 (solo a favore del trend H4)", 0, true);
   if(fs!=INVALID_HANDLE) FileClose(fs);
   Print("CSV -> MQL5\\Files\\ABTG_Apertura_Study_",_Symbol,".csv  (+ _RIEPILOGO.csv)");
   Print("=================================================================");
   if(gEmaH4!=INVALID_HANDLE) IndicatorRelease(gEmaH4);
  }
//+------------------------------------------------------------------+
