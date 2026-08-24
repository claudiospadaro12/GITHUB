//+------------------------------------------------------------------+
//|            ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5         |
//|                                                                  |
//|  >>> COPIA DI SOLA MISURA (R104). NON E' UNA SEDIA, NON GIRA IN  |
//|      FORWARD, NON SOSTITUISCE NIENTE.                            |
//|                                                                  |
//|  E' la copia BYTE PER BYTE del sorgente vivo                     |
//|  ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5 con DUE sole          |
//|  differenze, dichiarate qui e in nessun altro posto:             |
//|    1. il default di InpMagic passa da 770411 (magic VIVO) a       |
//|       750010 (blocco 750xxx, verificato libero in tutto il repo   |
//|       il 24/08/2026: zero occorrenze). Il tester non deve poter   |
//|       incrociare i deal del forward.                             |
//|    2. IL BLOCCO DI MISURA MFE in fondo al file, che OSSERVA e     |
//|       basta: registra a ogni tick il massimo profitto flottante   |
//|       raggiunto da ogni posizione, in multipli di R, e alla       |
//|       chiusura scrive una riga in un CSV separato.               |
//|                                                                  |
//|  NESSUNA decisione di apertura, chiusura, parziale, breakeven o   |
//|  trailing e' stata toccata: il contatore LEGGE, non scrive        |
//|  ordini. Criteri del round:                                       |
//|  backtest_pipeline\risultati_archivio\R104_CRITERI_MFE_MAXMIN_DAX.md |
//|                                                                  |
//|  EA "MAX-MIN DELLA NOTTE" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sul "Piano di trading Strategia MAX-MIN Notte" (ABTG).  |
//|                                                                  |
//|  LOGICA:                                                        |
//|   1) BOX NOTTURNO: max/min della sessione notturna (default     |
//|      00:00-05:59 CET). Gli orari qui sono in ORA SERVER.        |
//|   2) Pre-apertura (~08:59 CET) piazza ordini pendenti:          |
//|      BUY STOP sopra il MAX notte +buffer, SELL STOP sotto il    |
//|      MIN notte -buffer. OCO (parte uno -> cancella l'altro).    |
//|   3) SL: estremo opposto del box, ATR M15, o punti fissi.       |
//|   4) Target: 1o a R/R 1:1 (parziale + stop in pari), runner     |
//|      verso EMA200 (mgmt TF) con trailing; 2o target opzionale.  |
//|   5) Cancella i pendenti non eseguiti / chiude entro le 18:30.  |
//|   6) Filtri opzionali: correlazione (SPX500) e news (CSV).      |
//|                                                                  |
//|  ATTENZIONE Orari in ORA SERVER (controlla sul TUO grafico).    |
//|     Nessun EA garantisce profitti. TESTA SU DEMO.               |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.10"
#property description "R104 COPIA DI MISURA - MaxMinNotte OTT DAX SHORT + contatore MFE (osserva, non decide)"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

enum ENUM_MM_SL { MM_SL_OPPOSITE=0, MM_SL_ATR=1, MM_SL_FIXED=2 };

//==================================================================
//  INPUT
//==================================================================
input group "=== Box notturno (ORA SERVER!) ==="
input int    InpBoxStartHour = 23;   // Ora inizio box (server). BCM: 23 = 00:00 CET
input int    InpBoxStartMin  = 0;    // Minuti inizio box
input int    InpBoxEndHour   = 4;    // Ora fine box (server). BCM: 4:59 = 05:59 CET
input int    InpBoxEndMin    = 59;   // Minuti fine box
input double InpMinBoxPts    = 0;    // Ampiezza MIN del box in punti (0=off; filtro anti-lateralita')
input double InpMaxBoxPts    = 0;    // Ampiezza MAX del box in punti (0=off)

input group "=== Piazzamento e chiusura (ORA SERVER) ==="
input int    InpPlaceHour    = 7;    // Ora piazzamento ordini (server). BCM: 7:59 = 08:59 CET
input int    InpPlaceMin     = 59;
input int    InpEntryCutoffHour = 8; // CUTOFF ingressi (server): dopo, cancella i pendenti non scattati
input int    InpEntryCutoffMin  = 30;// BCM: 8:30 = 09:30 CET (solo la rottura "fresca" dell'apertura)
input int    InpCloseHour    = 17;   // Ora cancellazione/flat (server). BCM: 17:30 = 18:30 CET
input int    InpCloseMin     = 30;
input bool   InpCloseAtEnd   = true; // Chiudi posizioni residue a fine finestra
input bool   InpOneTradePerDay = true;
input int    InpPendingExpiryMin = 90; // Cancella il pendente non eseguito dopo N minuti

input group "=== Ingresso ==="
input double InpBufferPoints = 1000; // OTT DAX short
input bool   InpAllowLong    = false; // OTT: solo SHORT
input bool   InpAllowShort   = true;

input group "=== Stop loss ==="
input ENUM_MM_SL InpSLMode   = MM_SL_ATR;   // Estremo opposto box / ATR M15 / punti fissi
input ENUM_TIMEFRAMES InpMgmtTF = PERIOD_M15; // TF di gestione (ATR, EMA200)
input int    InpAtrPeriod    = 14;
input double InpAtrSLmult    = 2.5;  // OTT DAX short real-tick
input double InpSLFixedPts   = 3000; // (FIXED) stop in punti (DAX BCM: 3000 = 30 punti indice)

input group "=== Target e gestione ==="
input double InpTP1_R        = 1.0;  // 1o target in R (piano: R/R 1:1)
input double InpTP1Pct       = 50;   // % chiusa al 1o target
input bool   InpBreakeven    = true; // Stop in pari dopo la 1a parziale
input double InpTP2_R        = 3.0;  // OTT DAX short
input double InpTP2Pct       = 50;   // % (del residuo) chiusa al 2o target
input bool   InpUseEMA200Target = true; // 3o target = EMA200 sul TF di gestione
input int    InpEMA200Period = 200;
input double InpTPfinal_R    = 4.0;  // Target di sicurezza sull'ordine (in R)
input bool   InpUseTrailing  = true;
input double InpTrailAtrMult = 2.0;  // Trailing = X * ATR (mgmt TF)

input group "=== Filtro correlazione (opzionale) ==="
input bool   InpUseCorrelation = true;   // OTT: filtro correlazione S&P ON (chiave!)
input string InpCorrSymbol     = "SPXUSD";
input ENUM_TIMEFRAMES InpCorrTF = PERIOD_H1;
input int    InpCorrEmaFast     = 14;
input int    InpCorrEmaSlow     = 100;

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;  // OTT: rischio 1%

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies= "";
input bool   InpNewsFlatten   = true;

input group "=== Generali ==="
input string InpComment   = "MAXMIN DAX SHORT";
//  >>> R104: unico input cambiato. 770411 e' il magic VIVO sul conto: qui
//      non deve comparire nemmeno come default. 750010/750011 e' la coppia
//      gemella di misura (blocco 750xxx verificato libero il 24/08/2026).
input long   InpMagic     = 750010;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE, hEma200=INVALID_HANDLE;
enum ENUM_MMPHASE { MMP_WAIT, MMP_PLACED, MMP_DONE };
ENUM_MMPHASE gPhase=MMP_WAIT;
int      gDay=-1;
double   gBoxHigh=0, gBoxLow=0;
bool     gPart1=false, gPart2=false;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[MaxMinNotte] ", m); }

//--- R104: le dichiarazioni del blocco di misura MFE stanno in fondo al
//    file (cerca "BLOCCO DI MISURA MFE"). Qui ci sono solo i prototipi,
//    perche' OnInit/OnTick/OnDeinit/OnTester li chiamano prima.
void MfeAggiorna();
void MfeFlushFinale();
void MfeScriviFile();

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr    = iATR(_Symbol, InpMgmtTF, InpAtrPeriod);
   hEma200 = iMA(_Symbol, InpMgmtTF, InpEMA200Period, 0, MODE_EMA, PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE || hEma200==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   //--- R104: il CSV di misura si crea (vuoto, con la sola intestazione)
   //    SUBITO. Cosi' un file di una corsa PRECEDENTE non puo' essere letto
   //    come il risultato di questa (l'artefatto stantio della checklist 23):
   //    all'avvio viene troncato, e se la corsa non produce niente resta
   //    un file con zero righe -- che e' una risposta, non un vuoto ambiguo.
   MfeScriviFile();
   Log(StringFormat("avviato su %s. Box server %02d:%02d-%02d:%02d, piazzo %02d:%02d, flat %02d:%02d.",
       _Symbol,InpBoxStartHour,InpBoxStartMin,InpBoxEndHour,InpBoxEndMin,InpPlaceHour,InpPlaceMin,InpCloseHour,InpCloseMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- R104: l'ULTIMA posizione del test si chiude e poi non arriva piu'
   //    nessun tick: senza questa chiamata la sua riga non verrebbe mai
   //    scritta. E' idempotente (le righe gia' scritte hanno il flag).
   MfeFlushFinale();
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEma200!=INVALID_HANDLE) IndicatorRelease(hEma200);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- R104: il contatore MFE gira PRIMA di ManagePos, e la ragione e'
   //    precisa: alla PRIMA occhiata su una posizione appena aperta lo
   //    STOP deve essere ancora quello INIZIALE. Il breakeven e il
   //    trailing lo spostano dentro ManagePos: chiamando dopo, la R
   //    (distanza entrata-stop iniziale) sarebbe gia' falsata.
   //    Non tocca nessuna decisione: legge prezzi e posizioni, e basta.
   MfeAggiorna();

   ManagePos();
   HandleOCO();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   bool newsBlk = InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten){ CancelPendings(); if(SelPos()) gTrade.PositionClose(PositionGetInteger(POSITION_TICKET)); }

   int nowMin = now.hour*60+now.min;
   if(nowMin >= InpCloseHour*60+InpCloseMin){ EndOfDay(); return; }

   //--- CUTOFF: se i pendenti non sono scattati entro l'orario, cancellali
   //    (evita di inseguire una rottura "vecchia" a corsa gia' avvenuta -> esaurimento)
   if(gPhase==MMP_PLACED && !SelPos() && nowMin >= InpEntryCutoffHour*60+InpEntryCutoffMin)
     {
      CancelPendings();
      gPhase=MMP_DONE;
      Log("cutoff ingressi superato: pendenti non eseguiti cancellati (niente rincorsa).");
      return;
     }

   //--- GUARDIA ANTI-DUPLICATO (reload-safe): pendente/posizione del mio magic -> non ripiazzo
   if(gPhase==MMP_WAIT)
     {
      bool _has=false;
      for(int _i=OrdersTotal()-1;_i>=0 && !_has;_i--){ ulong _t=OrderGetTicket(_i); if(_t>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) _has=true; }
      for(int _j=PositionsTotal()-1;_j>=0 && !_has;_j--){ ulong _p=PositionGetTicket(_j); if(_p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) _has=true; }
      if(_has) gPhase=MMP_DONE;
     }
   if(gPhase==MMP_WAIT && nowMin >= InpPlaceHour*60+InpPlaceMin)
     {
      if(newsBlk) return;                 // durante blackout news non piazzo
      if(TryPlace()) gPhase=MMP_PLACED;
     }
  }

void ResetDay(){ gPhase=MMP_WAIT; gBoxHigh=0; gBoxLow=0; gPart1=false; gPart2=false; Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Calcola max/min del BOX notturno (gestisce lo scavalco mezzanotte)|
//+------------------------------------------------------------------+
bool ComputeBox(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpBoxEndHour;   t.min=InpBoxEndMin;   datetime tEnd=StructToTime(t);
   t.hour=InpBoxStartHour; t.min=InpBoxStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;             // il box inizia il giorno prima (notte)

   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   return(hi>0 && lo>0 && hi>lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti sul box notturno                      |
//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeBox(gBoxHigh,gBoxLow))
     { Log("box non ancora calcolabile (dati M1): riprovo."); return(false); }

   double widthPts=(gBoxHigh-gBoxLow)/_Point;
   if(InpMinBoxPts>0 && widthPts<InpMinBoxPts){ Log("box stretto (lateralita'): niente trade."); return(true); }
   if(InpMaxBoxPts>0 && widthPts>InpMaxBoxPts){ Log("box troppo ampio: niente trade."); return(true); }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double buf=EffBuffer();
   double buyPx =NormalizePrice(gBoxHigh+buf);
   double sellPx=NormalizePrice(gBoxLow -buf);
   double atr=AtrVal();
   datetime exp=TimeCurrent()+InpPendingExpiryMin*60;

   int bias=CorrBias();                 // 0 entrambi, +1 solo long, -1 solo short, 2 nessuno
   bool longOK =(bias==0||bias==+1);
   bool shortOK=(bias==0||bias==-1);

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_MaxMinNotte_DAX_Short_Ott")) return(false);
   if(InpAllowLong && longOK)
     {
      double sl=SLforLong(buyPx,sellPx,atr);
      double dist=buyPx-sl;
      if(dist>0)
        {
         double tp=NormalizePrice(buyPx+dist*InpTPfinal_R);
         double lot=LotByRisk(dist);
         if(lot>0 && gTrade.BuyStop(lot,buyPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" BUY"))
            Log(StringFormat("BUY STOP @ %.2f SL %.2f TP %.2f lot %.2f",buyPx,sl,tp,lot));
        }
     }
   if(InpAllowShort && shortOK)
     {
      double sl=SLforShort(sellPx,buyPx,atr);
      double dist=sl-sellPx;
      if(dist>0)
        {
         double tp=NormalizePrice(sellPx-dist*InpTPfinal_R);
         double lot=LotByRisk(dist);
         if(lot>0 && gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" SELL"))
            Log(StringFormat("SELL STOP @ %.2f SL %.2f TP %.2f lot %.2f",sellPx,sl,tp,lot));
        }
     }
   return(true);
  }

double SLforLong(double entry,double oppLevel,double atr)
  {
   double sl;
   if(InpSLMode==MM_SL_OPPOSITE) sl=oppLevel;
   else if(InpSLMode==MM_SL_FIXED) sl=entry-InpSLFixedPts*_Point;
   else sl=entry-atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }
double SLforShort(double entry,double oppLevel,double atr)
  {
   double sl;
   if(InpSLMode==MM_SL_OPPOSITE) sl=oppLevel;
   else if(InpSLMode==MM_SL_FIXED) sl=entry+InpSLFixedPts*_Point;
   else sl=entry+atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }

//+------------------------------------------------------------------+
//| Gestione posizione: parziali, breakeven, EMA200, trailing        |
//+------------------------------------------------------------------+
void ManagePos()
  {
   if(!SelPos()) return;
   long   type=PositionGetInteger(POSITION_TYPE);
   bool   isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double tp=PositionGetDouble(POSITION_TP);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong  ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   double risk=isLong?(openP-sl):(sl-openP);
   if(risk<=0){ double a=AtrVal(); if(a>0) risk=a*InpAtrSLmult; }

   //--- 1a PARZIALE a TP1_R -> breakeven
   if(!gPart1 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100 && risk>0)
     {
      double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
      bool hit=isLong?(bid>=tgt):(ask<=tgt);
      if(hit)
        {
         double cv=NormVol(vol*InpTP1Pct/100.0);
         // 07/08: lo stop in pari NON deve dipendere dalla riuscita del parziale.
         // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non parte, e con
         // lui saltava anche il breakeven. Stessa correzione gia' fatta il 04/08 sugli
         // EMA200, dove era costata -112,78 EUR su due short oro a 0,01 lotti.
         bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
         if(parzOK) gPart1=true;
         double bePari  = NormalizePrice(openP);
         double slPrec  = PositionGetDouble(POSITION_SL);
         bool   dirLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
         // il breakeven si fa SOLO se migliora lo stop: cosi' non si ripete a ogni tick
         bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                          (!dirLong && (slPrec==0 || bePari<slPrec))));
         if(beFatto) gTrade.PositionModify(ticket,bePari,tp);
         if(parzOK || beFatto)
            Log(parzOK ? "1o target (1R): parziale + stop in pari."
                       : "1o target (1R): stop in pari (parziale impossibile al lotto minimo).");
        }
     }
   //--- 2a PARZIALE a TP2_R
   if(gPart1 && !gPart2 && InpTP2_R>0 && InpTP2Pct>0 && InpTP2Pct<100 && risk>0)
     {
      double tgt=isLong?openP+risk*InpTP2_R:openP-risk*InpTP2_R;
      bool hit=isLong?(bid>=tgt):(ask<=tgt);
      if(hit)
        {
         double cv=NormVol(vol*InpTP2Pct/100.0);
         if(cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv))
           { gPart2=true; Log("2o target: seconda parziale."); }
        }
     }
   //--- 3o target: EMA200 (chiudo tutto se il prezzo la raggiunge nella direzione del trade)
   if(InpUseEMA200Target)
     {
      double e[1];
      if(CopyBuffer(hEma200,0,0,1,e)==1)
        {
         if(isLong && e[0]>openP && bid>=e[0]) { gTrade.PositionClose(ticket); Log("3o target EMA200: chiuso."); return; }
         if(!isLong && e[0]<openP && ask<=e[0]){ gTrade.PositionClose(ticket); Log("3o target EMA200: chiuso."); return; }
        }
     }
   //--- TRAILING su ATR
   if(InpUseTrailing)
     {
      double a=AtrVal();
      if(a>0)
        {
         if(isLong){ double n=NormalizePrice(bid-a*InpTrailAtrMult); if(n>sl && n>openP) gTrade.PositionModify(ticket,n,PositionGetDouble(POSITION_TP)); }
         else      { double n=NormalizePrice(ask+a*InpTrailAtrMult); if((n<sl||sl==0)&&n<openP) gTrade.PositionModify(ticket,n,PositionGetDouble(POSITION_TP)); }
        }
     }
  }

//+------------------------------------------------------------------+
//| OCO: se una posizione e' aperta, cancella i pendenti             |
//+------------------------------------------------------------------+
void HandleOCO(){ if(SelPos()) CancelPendings(); }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

void EndOfDay()
  {
   CancelPendings();
   if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(PositionGetInteger(POSITION_TICKET)); Log("fine finestra: posizione chiusa."); }
   gPhase=MMP_DONE;
  }

//==================================================================
//  FILTRO CORRELAZIONE
//==================================================================
int CorrBias()
  {
   if(!InpUseCorrelation || StringLen(InpCorrSymbol)==0) return(0);
   int hf=iMA(InpCorrSymbol,InpCorrTF,InpCorrEmaFast,0,MODE_EMA,PRICE_CLOSE);
   int hs=iMA(InpCorrSymbol,InpCorrTF,InpCorrEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   if(hf==INVALID_HANDLE||hs==INVALID_HANDLE) return(0);
   double f[1],s[1]; int dir=0;
   if(CopyBuffer(hf,0,1,1,f)==1 && CopyBuffer(hs,0,1,1,s)==1)
      dir=(f[0]>s[0])?+1:(f[0]<s[0]?-1:0);
   IndicatorRelease(hf); IndicatorRelease(hs);
   return(dir==0?0:dir);
  }

//==================================================================
//  UTILITY
//==================================================================
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)<1) return(0); return(a[0]); }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double EffBuffer()
  {
   double stops=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   return(MathMax(InpBufferPoints,stops)*_Point);
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

bool SelPos(){ for(int _i=PositionsTotal()-1;_i>=0;_i--){ ulong _tk=PositionGetTicket(_i); if(_tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true); } return(false); }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE (09/08/2026) - serve al DD di PORTAFOGLIO.       |
//| A fine test scrive nella cartella COMUNE (Files comuni) un CSV    |
//| con una riga per ogni trade CHIUSO (ora di chiusura e netto):     |
//| con le serie di piu' EA si calcolano DD combinato e Monte Carlo   |
//| (backtest_pipeline/dd_portafoglio.py). Solo tester. In            |
//| ottimizzazione ogni pass sovrascrive il file del proprio magic:   |
//| usarlo su run singoli / magic-sweep, non sulle griglie larghe.    |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }
double OnTester()
  {
   MfeFlushFinale(); // R104: le righe MFE prima di tutto il resto
   ExportTrades();   // per-trade per il DD di portafoglio (ROTTA_PROP punto 4)
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//

//==================================================================//
//                                                                  //
//   BLOCCO DI MISURA MFE  --  R104  --  MARCATORE_MFE_R104_v1      //
//                                                                  //
//   QUESTO BLOCCO OSSERVA. NON DECIDE.                             //
//   Non piazza ordini, non chiude, non modifica stop, non tocca    //
//   gPart1/gPart2/gPhase e non legge nessun input nuovo.           //
//   Se lo si cancella per intero, quello che resta e' il sorgente  //
//   vivo con un altro magic: e' il modo di verificarlo.            //
//                                                                  //
//   COSA MISURA (criteri R104 par. 3):                             //
//     per OGNI posizione aperta con questo magic, a OGNI tick,     //
//     l'estremo di prezzo piu' FAVOREVOLE raggiunto (per uno short //
//     il prezzo piu' BASSO), convertito in multipli di R.          //
//     R = distanza in punti fra prezzo di apertura e STOP INIZIALE //
//     -- la stessa unita' di misura con cui il sorgente calcola    //
//     TP1_R / TP2_R / TPfinal_R (variabile 'risk' in ManagePos e   //
//     'dist' in TryPlace).                                         //
//                                                                  //
//   PERCHE' NIENTE INPUT NUOVI (checklist 25). Un input aggiunto   //
//   a un EA NON torna al suo default quando si carica un preset    //
//   che non lo nomina: resta l'ultimo valore usato a mano, che MT5 //
//   ricorda. Un interruttore "misura si'/no" potrebbe quindi       //
//   trovarsi SPENTO in silenzio e il round produrrebbe un CSV      //
//   vuoto senza che nessuno se ne accorga. Qui la misura e'        //
//   cablata: questa copia esiste solo per misurare.                //
//                                                                  //
//   DOVE SCRIVE: cartella COMUNE (FILE_COMMON), come gia' fa       //
//   ExportTrades() qui sopra --                                    //
//   %APPDATA%\MetaQuotes\Terminal\Common\Files\ABTG_MFE_MaxMinDAX.csv //
//   E' l'unico posto che il tester e il driver vedono allo stesso  //
//   modo: la MQL5\Files di un agente di test sta nella sua sandbox //
//   (Tester\Agent-...\MQL5\Files) e sarebbe da rincorrere.         //
//                                                                  //
//   COME RILEVA LA CHIUSURA, e perche' cosi':                      //
//     confronto TICK SU TICK delle posizioni aperte -- un ticket   //
//     tracciato che non compare piu' fra le posizioni aperte e'    //
//     chiuso -- e POI lettura dello storico di QUELLA posizione    //
//     (HistorySelectByPosition), come fa ExportTrades().           //
//     NON si usa OnTradeTransaction con DEAL_ENTRY_OUT: su questo  //
//     EA il 1o target chiude il 50% con PositionClosePartial, che  //
//     genera un deal OUT a posizione ANCORA APERTA. Una riga per   //
//     ogni OUT vorrebbe dire DUE righe per un trade solo, e il     //
//     conteggio del round (n operazioni) sarebbe sbagliato in su.  //
//                                                                  //
//   ATTENZIONE A COSA QUESTI NUMERI NON SONO:                      //
//     - mfe_R e' calcolato sui TICK che l'EA riceve, cioe' sui     //
//       tick del modello di test. A modello 4 (tick reali) e' la   //
//       misura migliore disponibile, ma resta una misura del       //
//       BANCO, non della realta';                                  //
//     - mfe_R usa BID per i long e ASK per gli short, gli stessi   //
//       prezzi con cui ManagePos decide i target: e' l'unico modo  //
//       perche' "1R raggiunto" qui e "1R raggiunto" li' vogliano   //
//       dire la stessa cosa;                                       //
//     - mfe_R puo' uscire NEGATIVO: vuol dire che il prezzo non e' //
//       MAI andato a favore nemmeno di un tick. Non si azzera, o   //
//       si perderebbe proprio quell'informazione.                  //
//==================================================================//
#define MFE_MARCATORE     "MARCATORE_MFE_R104_v1"
#define MFE_FILE          "ABTG_MFE_MaxMinDAX.csv"
#define MFE_MAX_TENTATIVI 200

//--- lo stato di UNA posizione seguita
struct MfeTrade
  {
   ulong    ticket;        // POSITION_TICKET
   ulong    posId;         // POSITION_IDENTIFIER (quello che lega i deal)
   long     tipo;          // POSITION_TYPE al momento dell'apertura
   bool     aperta;        // e' ancora fra le posizioni aperte?
   bool     scritta;       // la sua riga e' gia' nel CSV?
   int      tentativi;     // quante volte ho provato a leggerne lo storico
   datetime tApertura;
   double   openP;
   double   slIniziale;
   double   riskPts;       // R in PUNTI DI PREZZO
   double   riskValuta;    // R in VALUTA DEL CONTO, sul volume INIZIALE
   double   volIniziale;
   double   estremoFav;    // il prezzo piu' favorevole visto
   double   estremoAvv;    // e il piu' sfavorevole (MAE, diagnostica)
   bool     tp1Flag;       // gPart1 REALE, agganciato mentre la pos. e' viva
   bool     slLetto;       // lo stop iniziale era leggibile? (se no: ripiego ATR)
  };
MfeTrade gMfe[];

//--- una riga gia' pronta per il CSV. Tutti i campi sono STRINGHE gia'
//    formattate: DoubleToString scrive sempre col PUNTO decimale, quindi
//    il file esce identico su una Windows italiana e su una inglese --
//    ed e' la stessa ragione per cui i .ps1 di casa parsano a cultura
//    INVARIANTE. Un CSV con la virgola decimale qui manderebbe in vacca
//    ogni conto del driver.
struct MfeRiga
  {
   string open_time, close_time, mfe_R, realizzato_R, tp1_toccato, esito;
   string tp1_geom_1R, mae_R, ticket, vol_iniziale, risk_punti, risk_valuta, n_uscite;
  };
MfeRiga gMfeRighe[];

//------------------------------------------------------------------
//  Il ticket gia' seguito, oppure -1.
//------------------------------------------------------------------
int MfeIdx(ulong tk)
  {
   for(int i=ArraySize(gMfe)-1;i>=0;i--) if(gMfe[i].ticket==tk) return(i);
   return(-1);
  }

//------------------------------------------------------------------
//  R in VALUTA DEL CONTO. E' la stessa aritmetica di LotByRisk()
//  qui sopra, al contrario: li' si parte dal rischio e si ricava il
//  lotto, qui si parte dal lotto e si ricava il rischio.
//  Stessa scelta e stessa ragione (nota del 08/08/2026): la perdita
//  per lotto la da' OrderCalcProfit, che CONVERTE in valuta conto;
//  il tick value nudo resta un ripiego perche' su certi simboli
//  arriva NON convertito.
//------------------------------------------------------------------
double MfeRischioValuta(double vol,double distPrezzo)
  {
   if(vol<=0 || distPrezzo<=0) return(0);
   double px=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double prof=0;
   if(px>distPrezzo && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,vol,px,px-distPrezzo,prof) && prof<0)
      return(-prof);
   double tv =SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(tv<=0||tsz<=0) return(0);
   return((distPrezzo/tsz)*tv*vol);
  }

//------------------------------------------------------------------
//  Il motivo dell'ultima uscita, in chiaro.
//  ATTENZIONE, e va scritto: "SL" qui vuol dire "e' stato toccato lo
//  stop COM'ERA IN QUEL MOMENTO". Se il trailing o il breakeven lo
//  avevano gia' spostato, il motivo resta 'SL' anche su un'uscita in
//  guadagno. Il segno del netto e' li' accanto proprio per questo.
//------------------------------------------------------------------
string MfeMotivo(long reason)
  {
   if(reason==DEAL_REASON_SL)     return("SL");
   if(reason==DEAL_REASON_TP)     return("TP");
   if(reason==DEAL_REASON_EXPERT) return("EA");
   if(reason==DEAL_REASON_CLIENT) return("MANUALE");
   if(reason==DEAL_REASON_MOBILE) return("MANUALE");
   if(reason==DEAL_REASON_WEB)    return("MANUALE");
   if(reason==DEAL_REASON_SO)     return("STOPOUT");
   return("ALTRO");
  }

//------------------------------------------------------------------
//  Aggiunge la riga di una posizione chiusa.
//  'letto' = lo storico e' stato letto davvero. Se e' false NON si
//  inventa nessun numero: realizzato_R esce "n/d" e l'esito lo dice.
//------------------------------------------------------------------
void MfeAggiungiRiga(int k,bool letto,double netto,int nOut,datetime tChiusura,long motivo)
  {
   bool   lungo = (gMfe[k].tipo==POSITION_TYPE_BUY);
   double mfeR=0, maeR=0;
   bool   rOk = (gMfe[k].riskPts>0);
   if(rOk)
     {
      if(lungo){ mfeR=(gMfe[k].estremoFav-gMfe[k].openP)/gMfe[k].riskPts;
                 maeR=(gMfe[k].openP-gMfe[k].estremoAvv)/gMfe[k].riskPts; }
      else     { mfeR=(gMfe[k].openP-gMfe[k].estremoFav)/gMfe[k].riskPts;
                 maeR=(gMfe[k].estremoAvv-gMfe[k].openP)/gMfe[k].riskPts; }
     }
   int n=ArraySize(gMfeRighe);
   ArrayResize(gMfeRighe,n+1);
   gMfeRighe[n].open_time    = TimeToString(gMfe[k].tApertura,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
   gMfeRighe[n].close_time   = (letto && tChiusura>0) ? TimeToString(tChiusura,TIME_DATE|TIME_MINUTES|TIME_SECONDS) : "n/d";
   gMfeRighe[n].mfe_R        = rOk ? DoubleToString(mfeR,4) : "n/d";
   gMfeRighe[n].mae_R        = rOk ? DoubleToString(maeR,4) : "n/d";
   //  realizzato_R = netto della posizione (profitto+swap+commissioni di
   //  TUTTE le uscite, parziali comprese) diviso R in valuta -- e R in
   //  valuta e' calcolato sul volume INIZIALE, perche' quello e' il
   //  denaro che era davvero a rischio all'ingresso.
   gMfeRighe[n].realizzato_R = (letto && gMfe[k].riskValuta>0) ? DoubleToString(netto/gMfe[k].riskValuta,4) : "n/d";
   //  tp1_toccato = IL FLAG INTERNO VERO (gPart1), non un surrogato.
   //  >>> E IL SUO LIMITE, DICHIARATO: nel sorgente vivo gPart1 diventa
   //      true SOLO SE LA PARZIALE E' STATA ESEGUITA DAVVERO
   //      ("if(parzOK) gPart1=true;"). Al lotto minimo NormVol(vol*50%)
   //      arrotonda a 0, la parziale non parte e gPart1 resta false
   //      ANCHE SE il prezzo aveva toccato il 1o target (in quel caso il
   //      sorgente fa lo stop in pari lo stesso). Percio' accanto c'e'
   //      SEMPRE tp1_geom_1R, che e' la stessa domanda misurata sulla
   //      GEOMETRIA (mfe_R >= InpTP1_R sulla R INIZIALE). I due possono
   //      differire anche per un secondo motivo, ed e' interessante:
   //      ManagePos ricalcola 'risk' dallo stop CORRENTE, quindi dopo
   //      una trailata il suo 1R e' piu' vicino di quello iniziale.
   gMfeRighe[n].tp1_toccato  = gMfe[k].tp1Flag ? "1" : "0";
   gMfeRighe[n].tp1_geom_1R  = (rOk && mfeR>=InpTP1_R) ? "1" : "0";
   string esito;
   if(!letto) esito="STORICO NON LETTO (nessun numero inventato)";
   else
     {
      string segno = (netto>0 ? "POS" : (netto<0 ? "NEG" : "PARI"));
      esito = MfeMotivo(motivo) + "/" + segno + "/uscite:" + IntegerToString(nOut);
     }
   if(!gMfe[k].slLetto) esito = esito + "/R-DA-ATR-NON-DA-SL";
   gMfeRighe[n].esito        = esito;
   gMfeRighe[n].ticket       = IntegerToString((long)gMfe[k].ticket);
   gMfeRighe[n].vol_iniziale = DoubleToString(gMfe[k].volIniziale,2);
   gMfeRighe[n].risk_punti   = DoubleToString(gMfe[k].riskPts,_Digits);
   gMfeRighe[n].risk_valuta  = DoubleToString(gMfe[k].riskValuta,2);
   gMfeRighe[n].n_uscite     = letto ? IntegerToString(nOut) : "n/d";
   gMfe[k].scritta=true;
  }

//------------------------------------------------------------------
//  Prova a chiudere la scheda di una posizione: legge lo storico di
//  QUELLA posizione e ne ricava netto, numero di uscite, ora e motivo.
//  Torna false se lo storico non e' (ancora) leggibile: in quel caso
//  si riprova al tick dopo, non si scrive niente di finto.
//------------------------------------------------------------------
bool MfeProvaChiusura(int k)
  {
   if(!HistorySelectByPosition(gMfe[k].posId)) return(false);
   int    n=HistoryDealsTotal();
   double netto=0; int nOut=0; datetime tCh=0; long motivo=-1; bool visto=false;
   for(int i=0;i<n;i++)
     {
      ulong dk=HistoryDealGetTicket(i);
      if(dk==0) continue;
      long entry=HistoryDealGetInteger(dk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      netto += HistoryDealGetDouble(dk,DEAL_PROFIT)
             + HistoryDealGetDouble(dk,DEAL_SWAP)
             + HistoryDealGetDouble(dk,DEAL_COMMISSION);
      nOut++;
      visto=true;
      datetime td=(datetime)HistoryDealGetInteger(dk,DEAL_TIME);
      if(td>=tCh){ tCh=td; motivo=HistoryDealGetInteger(dk,DEAL_REASON); }
     }
   if(!visto) return(false);
   MfeAggiungiRiga(k,true,netto,nOut,tCh,motivo);
   return(true);
  }

//------------------------------------------------------------------
//  IL CONTATORE. Gira all'inizio di OnTick.
//------------------------------------------------------------------
void MfeAggiorna()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;

   //--- 1) le posizioni APERTE di questo magic: le apro in scheda la
   //       prima volta che le vedo, poi ne aggiorno gli estremi.
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      //  tutti i campi si leggono ADESSO, mentre la posizione e'
      //  selezionata: dopo si fanno solo conti.
      long   pTipo = PositionGetInteger(POSITION_TYPE);
      ulong  pId   = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      datetime pT  = (datetime)PositionGetInteger(POSITION_TIME);
      double pOpen = PositionGetDouble(POSITION_PRICE_OPEN);
      double pVol  = PositionGetDouble(POSITION_VOLUME);
      double pSl   = PositionGetDouble(POSITION_SL);
      int k=MfeIdx(tk);
      if(k<0)
        {
         k=ArraySize(gMfe);
         ArrayResize(gMfe,k+1);
         gMfe[k].ticket=tk;  gMfe[k].posId=pId;  gMfe[k].tipo=pTipo;
         gMfe[k].aperta=true; gMfe[k].scritta=false; gMfe[k].tentativi=0;
         gMfe[k].tApertura=pT; gMfe[k].openP=pOpen;
         gMfe[k].volIniziale=pVol; gMfe[k].slIniziale=pSl;
         bool lungo=(pTipo==POSITION_TYPE_BUY);
         double dist = lungo ? (pOpen-pSl) : (pSl-pOpen);
         gMfe[k].slLetto = (pSl>0 && dist>0);
         if(!gMfe[k].slLetto)
           {
            //  stesso ripiego di ManagePos quando lo stop non e'
            //  leggibile: R = ATR * InpAtrSLmult. E' segnato nell'esito,
            //  perche' una R stimata NON e' una R misurata.
            double a=AtrVal();
            dist = (a>0 ? a*InpAtrSLmult : 0);
           }
         gMfe[k].riskPts=dist;
         gMfe[k].riskValuta=MfeRischioValuta(pVol,dist);
         double px0 = lungo ? bid : ask;
         gMfe[k].estremoFav=px0; gMfe[k].estremoAvv=px0;
         gMfe[k].tp1Flag=false;
        }
      gMfe[k].aperta=true;
      bool lungo2=(gMfe[k].tipo==POSITION_TYPE_BUY);
      double px = lungo2 ? bid : ask;
      if(lungo2)
        {
         if(px>gMfe[k].estremoFav) gMfe[k].estremoFav=px;
         if(px<gMfe[k].estremoAvv) gMfe[k].estremoAvv=px;
        }
      else
        {
         if(px<gMfe[k].estremoFav) gMfe[k].estremoFav=px;
         if(px>gMfe[k].estremoAvv) gMfe[k].estremoAvv=px;
        }
      //  gPart1 si aggancia mentre la posizione e' VIVA e non si molla
      //  piu': ResetDay lo azzera al cambio di giorno, e a quel punto
      //  sarebbe troppo tardi per leggerlo.
      if(gPart1) gMfe[k].tp1Flag=true;
     }

   //--- 2) chi era in scheda e non e' piu' fra le aperte, e' CHIUSO.
   for(int k=0;k<ArraySize(gMfe);k++)
     {
      if(gMfe[k].scritta) continue;
      bool ancora=false;
      for(int i=PositionsTotal()-1;i>=0 && !ancora;i--)
        {
         ulong tk=PositionGetTicket(i);
         if(tk==gMfe[k].ticket) ancora=true;
        }
      if(ancora) continue;
      if(gMfe[k].aperta)
        {
         //  primo tick in cui la vedo chiusa: qui gPart1 vale ANCORA
         //  quello del giorno della posizione, perche' MfeAggiorna gira
         //  PRIMA del controllo di cambio giorno che chiama ResetDay.
         //  Nei tentativi successivi NON si aggancia piu': un trade del
         //  giorno dopo potrebbe alzare gPart1 e sporcare questa riga.
         if(gPart1) gMfe[k].tp1Flag=true;
         gMfe[k].aperta=false;
        }
      gMfe[k].tentativi++;
      if(MfeProvaChiusura(k)) MfeScriviFile();
      else if(gMfe[k].tentativi>=MFE_MAX_TENTATIVI)
        {
         MfeAggiungiRiga(k,false,0.0,0,(datetime)0,-1);
         MfeScriviFile();
        }
     }
  }

//------------------------------------------------------------------
//  L'ULTIMA PAROLA. Chiamata da OnTester e da OnDeinit: la posizione
//  chiusa dall'ultimo tick del test non avrebbe mai un tick dopo in
//  cui farsi vedere assente.
//------------------------------------------------------------------
void MfeFlushFinale()
  {
   for(int k=0;k<ArraySize(gMfe);k++)
     {
      if(gMfe[k].scritta) continue;
      if(!MfeProvaChiusura(k)) MfeAggiungiRiga(k,false,0.0,0,(datetime)0,-1);
     }
   MfeScriviFile();
  }

//------------------------------------------------------------------
//  Il CSV, riscritto INTERO ogni volta. Sono poche decine di righe:
//  costa niente e il file sul disco e' sempre completo e coerente,
//  anche se la corsa venisse interrotta a meta'.
//  Separatore ';' e FILE_COMMON: le stesse convenzioni di
//  ExportTrades(), cosi' gli strumenti di casa lo leggono senza
//  nessun caso particolare.
//------------------------------------------------------------------
void MfeScriviFile()
  {
   int h=FileOpen(MFE_FILE,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE)
     { PrintFormat("[MFE] non riesco a scrivere %s (err %d)",MFE_FILE,GetLastError()); return; }
   FileWrite(h,"open_time","close_time","mfe_R","realizzato_R","tp1_toccato","esito",
               "tp1_geom_1R","mae_R","ticket","vol_iniziale","risk_punti","risk_valuta","n_uscite");
   for(int i=0;i<ArraySize(gMfeRighe);i++)
      FileWrite(h,gMfeRighe[i].open_time,gMfeRighe[i].close_time,gMfeRighe[i].mfe_R,
                  gMfeRighe[i].realizzato_R,gMfeRighe[i].tp1_toccato,gMfeRighe[i].esito,
                  gMfeRighe[i].tp1_geom_1R,gMfeRighe[i].mae_R,gMfeRighe[i].ticket,
                  gMfeRighe[i].vol_iniziale,gMfeRighe[i].risk_punti,gMfeRighe[i].risk_valuta,
                  gMfeRighe[i].n_uscite);
   FileClose(h);
  }
//================== fine BLOCCO DI MISURA MFE ======================//
