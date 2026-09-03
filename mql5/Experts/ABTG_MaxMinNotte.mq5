//+------------------------------------------------------------------+
//|                                          ABTG_MaxMinNotte.mq5     |
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
//+------------------------------------------------------------------+
//|  CHANGELOG                                                       |
//|  v1.11 (03/09/2026) - IL PANNELLO SMETTE DI MENTIRE.             |
//|        InpOneTradePerDay era DICHIARATO e MAI LETTO: unica        |
//|        occorrenza nel sorgente (riga 65 della v1.10), censito in  |
//|        report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md. Nei     |
//|        .set in campo e' true (per esempio                         |
//|        sedie_piccolo/sedia_MAXMIN_ORO_770402.set:15), quindi il   |
//|        pannello prometteva una cosa che il codice non faceva.     |
//|                                                                   |
//|        COSA FA ADESSO, due righe di decisione:                    |
//|         1. non RIPIAZZA i pendenti se oggi un mio ingresso c'e'   |
//|            gia' allo storico (PuoArmare_Calc);                    |
//|         2. quando il trade del giorno e' FINITO, cancella subito  |
//|            i pendenti superstiti (GiornataSpesa_Calc), invece di  |
//|            aspettare il cutoff. Stessa semantica del gemello che  |
//|            ce l'ha funzionante, ABTG_ORB_Ottimizzato (ramo        |
//|            gHadPos).                                              |
//|                                                                   |
//|        HEDGE-SAFE PER COSTRUZIONE. La conoscenza "oggi ho gia'    |
//|        operato" NON passa da PositionSelect(_Symbol): scorre      |
//|        PositionsTotal() filtrando SIMBOLO+MAGIC e lo storico del  |
//|        giorno filtrando DEAL_SYMBOL+DEAL_MAGIC (pattern di        |
//|        HaGiaOperatoOggi in ABTG_Dow_Apertura_US, dichiarato       |
//|        immune dalla VERIFICA del 03/09). Il difetto C9 non entra  |
//|        da questa porta.                                           |
//|                                                                   |
//|        ATTENZIONE, QUELLO CHE QUESTO FIX NON FA. NON tocca        |
//|        SelPos(), che resta il PositionSelect(_Symbol) cieco di    |
//|        sempre, ne' ManagePos()/EndOfDay() che ci si appoggiano:   |
//|        quello e' il difetto C9, secondo in ordine di gravita'     |
//|        nell'audit del 03/09, e ha una sua voce nella coda dei     |
//|        fix. Qui si chiude solo la riapertura DOPO che il trade    |
//|        del giorno e' finito.                                      |
//|                                                                   |
//|        ATTENZIONE, SEDIA VIVA. Questo EA ha una sedia in forward  |
//|        sull'ORO (magic 770402). La modifica e' SOLO NEL REPO e    |
//|        oggi e' INERTE: la .ex5 che gira sul VPS non cambia finche'|
//|        non viene RICOMPILATA e ricaricata. ALLA PROSSIMA          |
//|        RICOMPILAZIONE IL COMPORTAMENTO CAMBIA DAVVERO, e nella    |
//|        direzione di MENO trade, non di piu'. Prima di sostituire  |
//|        la sedia viva va rifatto il backtest di riferimento:       |
//|        qui, a differenza dell'ORB nativo, il fix NON e' inerte    |
//|        nel tester (vedi sotto).                                   |
//|                                                                   |
//|        PERCHE' NEL TESTER PUO' CAMBIARE I NUMERI: fino alla v1.10 |
//|        un pendente superstite veniva tolto solo dal CUTOFF        |
//|        (InpEntryCutoffHour/Min). Una giornata in cui il trade     |
//|        apre e chiude PRIMA del cutoff lasciava vivo il pendente   |
//|        opposto, che poteva far scattare un SECONDO trade nella    |
//|        stessa giornata: adesso non piu'. Attesi MENO trade e      |
//|        stessa o minore frequenza; profit factor e drawdown si     |
//|        MISURANO, non si promettono. InpOneTradePerDay=false       |
//|        riproduce la v1.10 esatta, per il confronto a parita' di   |
//|        tutto il resto.                                            |
//|        Aggiunto un AUTOTEST a tavolino (4 blocchi, 24 casi) sui   |
//|        predicati puri: gira in OnInit, non tocca il mercato.      |
//|  v1.10 - versione precedente.                                     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.11"
#property strict

//--- v1.11: QUANTI BLOCCHI E QUANTI CASI deve eseguire l'autotest.
//    Due contatori e non uno (pattern di casa, ABTG_LondonFx /
//    ABTG_ORB_Ottimizzato): un blocco cancellato per sbaglio non deve
//    poter passare per "tutto verde", e nemmeno un blocco SVUOTATO
//    delle sue asserzioni, che il conteggio dei soli blocchi non
//    vedrebbe. Se uno dei due conti non torna, l'autotest e' FALLITO.
#define MM_AUTOTEST_BLOCCHI_ATTESI 4
#define MM_AUTOTEST_CASI_ATTESI    24

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
//--- v1.11: DA QUI IN AVANTI QUESTO INPUT E' LETTO DAVVERO (fino alla
//    v1.10 era dichiarato e mai usato). true = un solo ciclo di trade al
//    giorno; false = comportamento IDENTICO alla v1.10.
input bool   InpOneTradePerDay = true; // Un solo trade al giorno (v1.11: ora e' applicato davvero)
input int    InpPendingExpiryMin = 90; // Cancella il pendente non eseguito dopo N minuti

input group "=== Ingresso ==="
input double InpBufferPoints = 1000; // Buffer oltre max/min notte, in punti (DAX BCM: 1000 = 10 punti indice)
input bool   InpAllowLong    = true;
input bool   InpAllowShort   = true;

input group "=== Stop loss ==="
input ENUM_MM_SL InpSLMode   = MM_SL_ATR;   // Estremo opposto box / ATR M15 / punti fissi
input ENUM_TIMEFRAMES InpMgmtTF = PERIOD_M15; // TF di gestione (ATR, EMA200)
input int    InpAtrPeriod    = 14;
input double InpAtrSLmult    = 1.5;
input double InpSLFixedPts   = 3000; // (FIXED) stop in punti (DAX BCM: 3000 = 30 punti indice)

input group "=== Target e gestione ==="
input double InpTP1_R        = 1.0;  // 1o target in R (piano: R/R 1:1)
input double InpTP1Pct       = 50;   // % chiusa al 1o target
input bool   InpBreakeven    = true; // Stop in pari dopo la 1a parziale
input double InpTP2_R        = 2.5;  // 2o target in R (0 = off)
input double InpTP2Pct       = 50;   // % (del residuo) chiusa al 2o target
input bool   InpUseEMA200Target = true; // 3o target = EMA200 sul TF di gestione
input int    InpEMA200Period = 200;
input double InpTPfinal_R    = 4.0;  // Target di sicurezza sull'ordine (in R)
input bool   InpUseTrailing  = true;
input double InpTrailAtrMult = 2.0;  // Trailing = X * ATR (mgmt TF)

input group "=== Filtro correlazione (opzionale) ==="
input bool   InpUseCorrelation = false;   // Opera solo se l'indice guida concorda
input string InpCorrSymbol     = "SPXUSD";
input ENUM_TIMEFRAMES InpCorrTF = PERIOD_H1;
input int    InpCorrEmaFast     = 14;
input int    InpCorrEmaSlow     = 100;

input group "=== Rischio ==="
input double InpRiskPercent  = 2.0;  // Rischio per trade in % (piano: 2%)

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
input string InpComment   = "MAXMIN";
input long   InpMagic     = 770401;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
input bool   InpAutoTest  = true;    // Autotest dei predicati "un trade al giorno" (stampa in OnInit)

//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE, hEma200=INVALID_HANDLE;
enum ENUM_MMPHASE { MMP_WAIT, MMP_PLACED, MMP_DONE };
ENUM_MMPHASE gPhase=MMP_WAIT;
int      gDay=-1;
double   gBoxHigh=0, gBoxLow=0;
bool     gPart1=false, gPart2=false;
//--- v1.11, "un trade al giorno". gOperatoOggi e' un TIMBRO che si accende
//    una volta sola e non si spegne fino al cambio di giornata: acceso da
//    una posizione nostra viva (a costo zero, a ogni tick) oppure dallo
//    storico del giorno (che sopravvive a riavvio e ricompilazione).
//    gUltimoCheckStorico limita la lettura dello storico a una al minuto:
//    serve solo finche' il timbro e' spento, poi non si legge piu'.
bool     gOperatoOggi=false;
datetime gUltimoCheckStorico=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[MaxMinNotte] ", m); }

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
   if(InpAutoTest) Autotest();   // v1.11: verifica a tavolino dei predicati "un trade al giorno"
   Log(StringFormat("avviato su %s. Box server %02d:%02d-%02d:%02d, piazzo %02d:%02d, flat %02d:%02d.",
       _Symbol,InpBoxStartHour,InpBoxStartMin,InpBoxEndHour,InpBoxEndMin,InpPlaceHour,InpPlaceMin,InpCloseHour,InpCloseMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEma200!=INVALID_HANDLE) IndicatorRelease(hEma200);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManagePos();
   HandleOCO();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   //--- v1.11: la guardia "un trade al giorno". Sta DOPO il cambio di
   //    giornata, non prima: al primo tick del giorno nuovo il timbro
   //    dev'essere gia' stato azzerato da ResetDay(), altrimenti la prima
   //    cosa che farebbe sarebbe cancellare i pendenti di ieri.
   UnTradeAlGiorno();

   bool newsBlk = InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten){ CancelPendings(); if(SelPos()) gTrade.PositionClose(_Symbol); }

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
      //--- v1.11: non RIPIAZZARE su una giornata gia' operata. La guardia
      //    anti-duplicato qui sopra vede solo la roba APERTA ADESSO: a
      //    trade gia' chiuso non vedeva niente e, dopo un riavvio, la
      //    macchina a stati ripartiva da MMP_WAIT e ripiazzava (e' esattamente
      //    l'incidente del 05/08 sugli Aperture). Lo storico invece se lo
      //    ricorda. Nel tester e' INERTE: gPhase e' MMP_WAIT solo prima del
      //    primo piazzamento, quando il timbro e' per forza spento.
      if(!PuoArmare_Calc(InpOneTradePerDay,gOperatoOggi))
        {
         gPhase=MMP_DONE;   // MMP_DONE e non MMP_WAIT: cosi' il log non si ripete a ogni tick
         Log("oggi ho gia' operato (storico simbolo+magic): non ripiazzo.");
         return;
        }
      if(TryPlace()) gPhase=MMP_PLACED;
     }
  }

void ResetDay(){ gPhase=MMP_WAIT; gBoxHigh=0; gBoxLow=0; gPart1=false; gPart2=false;
                 gOperatoOggi=false; gUltimoCheckStorico=0;   // v1.11: il timbro del giorno riparte da zero
                 Log("nuovo giorno."); }

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
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_MaxMinNotte")) return(false);
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
         if(beFatto) gTrade.PositionModify(_Symbol,bePari,tp);
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
         if(isLong && e[0]>openP && bid>=e[0]) { gTrade.PositionClose(_Symbol); Log("3o target EMA200: chiuso."); return; }
         if(!isLong && e[0]<openP && ask<=e[0]){ gTrade.PositionClose(_Symbol); Log("3o target EMA200: chiuso."); return; }
        }
     }
   //--- TRAILING su ATR
   if(InpUseTrailing)
     {
      double a=AtrVal();
      if(a>0)
        {
         if(isLong){ double n=NormalizePrice(bid-a*InpTrailAtrMult); if(n>sl && n>openP) gTrade.PositionModify(_Symbol,n,PositionGetDouble(POSITION_TP)); }
         else      { double n=NormalizePrice(ask+a*InpTrailAtrMult); if((n<sl||sl==0)&&n<openP) gTrade.PositionModify(_Symbol,n,PositionGetDouble(POSITION_TP)); }
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
   if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(_Symbol); Log("fine finestra: posizione chiusa."); }
   gPhase=MMP_DONE;
  }

//==================================================================
//  v1.11 -- "UN SOLO TRADE AL GIORNO"
//
//  La regola e' divisa in QUATTRO PREDICATI PURI (nessuna chiamata al
//  terminale dentro) piu' due gusci che leggono il mercato. Non e'
//  pignoleria: senza MetaEditor ne' Strategy Tester in questo ambiente,
//  i predicati puri sono l'unica parte che si puo' PROVARE prima di
//  metterla in campo -- ed e' quello che fa Autotest() qui sotto sul
//  codice che gira davvero, non su una sua copia.
//
//  DUE CONOSCENZE DIVERSE, e vanno tenute separate:
//   - "ho una posizione MIA viva ADESSO"  -> guarda le posizioni;
//   - "oggi un mio ingresso c'e' GIA' STATO" -> guarda lo storico, e
//     resta vero anche a trade chiuso, anche dopo un riavvio.
//  La prima da sola e' la guardia anti-duplicato che questo EA ha gia'
//  in OnTick: utile, ma a trade gia' chiuso non vede niente.
//==================================================================

//--- Predicato puro: questa roba e' NOSTRA? SIMBOLO e MAGIC, tutti e due.
//    Il magic da solo non basta (lo stesso EA gira su piu' simboli), il
//    simbolo da solo e' esattamente il difetto C9 dell'audit del 03/09.
bool PosMia_Calc(const string sym,const long magic,const string mioSym,const long mioMagic)
  { return(sym==mioSym && magic==mioMagic); }

//--- Predicato puro: devo TIMBRARE la giornata come "gia' operata"?
//    La riga che conta e' la seconda: storicoLetto==false vuol dire
//    "NON LO SO" (HistorySelect non ancora sincronizzato all'avvio del
//    terminale), e "non lo so" NON e' "si". Non si timbra e si riprova
//    al giro dopo. Stessa correzione fatta il 14/08 sugli Aperture.
bool TimbraGiornata_Calc(const bool posMiaAperta,const bool storicoLetto,const bool giaOperatoOggi)
  {
   if(posMiaAperta)  return(true);
   if(!storicoLetto) return(false);
   return(giaOperatoOggi);
  }

//--- Predicato puro: il trade del giorno e' FINITO e quindi i pendenti
//    superstiti vanno tolti di mezzo? Serve che il timbro sia acceso E
//    che nessuna posizione nostra sia piu' viva: finche' e' viva non c'e'
//    niente da cancellare (ci pensa gia' l'OCO) e non e' ancora "finito".
bool GiornataSpesa_Calc(const bool unoAlGiorno,const bool operatoOggi,const bool posMiaAperta)
  { return(unoAlGiorno && operatoOggi && !posMiaAperta); }

//--- Predicato puro: posso ancora PIAZZARE per oggi? No, se ho gia'
//    operato. Attenzione: qui NON si guarda se la posizione e' viva --
//    ripiazzare mentre il trade e' ancora aperto sarebbe il caso peggiore
//    di tutti, due posizioni sullo stesso segnale.
bool PuoArmare_Calc(const bool unoAlGiorno,const bool operatoOggi)
  { return(!(unoAlGiorno && operatoOggi)); }

//--- Guscio HEDGE-SAFE: quante posizioni NOSTRE ci sono adesso.
//    Scorre PositionsTotal(); NON usa PositionSelect(_Symbol), che su
//    conto hedging aggancia il ticket piu' basso del simbolo e puo'
//    essere quello di un'altra sedia (difetto C9, audit del 03/09).
int ContaPosizioniMie()
  {
   int q=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PosMia_Calc(PositionGetString(POSITION_SYMBOL),
                     PositionGetInteger(POSITION_MAGIC),_Symbol,InpMagic)) q++;
     }
   return(q);
  }

//--- Guscio: nello STORICO DI OGGI c'e' un MIO ingresso?
//    Filtra DEAL_SYMBOL + DEAL_MAGIC, come HaGiaOperatoOggi() in
//    ABTG_Dow_Apertura_US:740-745, che la VERIFICA del 03/09 dichiara
//    "hedge-safe e immune al difetto di questo audit".
bool HaGiaOperatoOggi(bool &storicoLetto)
  {
   storicoLetto=false;
   MqlDateTime d; TimeToStruct(TimeCurrent(),d);
   d.hour=0; d.min=0; d.sec=0;
   datetime inizioGiorno=StructToTime(d);
   if(!HistorySelect(inizioGiorno,TimeCurrent()+60)) return(false);
   storicoLetto=true;
   int n=HistoryDealsTotal();
   for(int i=n-1;i>=0;i--)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk<=0) continue;
      if(!PosMia_Calc(HistoryDealGetString(tk,DEAL_SYMBOL),
                      HistoryDealGetInteger(tk,DEAL_MAGIC),_Symbol,InpMagic)) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)==DEAL_ENTRY_IN) return(true);
     }
   return(false);
  }

//--- ATTENZIONE, il BOX di questo EA e' NOTTURNO e scavalca la mezzanotte
//    (default 23:00 -> 04:59 server), ma il TIMBRO no: si riferisce al
//    giorno di calendario del server, lo stesso su cui gia' ragiona
//    gDay/ResetDay(). Coerente, perche' i pendenti si piazzano alle 07:59
//    e il ciclo di trade vive tutto dentro la stessa giornata server.
void UnTradeAlGiorno()
  {
   bool posMia=(ContaPosizioniMie()>0);

   //--- (1) CONOSCENZA. Il timbro si accende una volta sola. La posizione
   //    viva si guarda sempre (non costa niente); lo storico si interroga
   //    al massimo UNA VOLTA AL MINUTO e solo finche' il timbro e' spento:
   //    in campo sono poche letture al giorno, nel tester una al minuto
   //    simulato, e appena il timbro si accende non si legge piu'.
   if(!gOperatoOggi)
     {
      bool storicoLetto=false, gia=false;
      if(!posMia && TimeCurrent()-gUltimoCheckStorico>=60)
        {
         gUltimoCheckStorico=TimeCurrent();
         gia=HaGiaOperatoOggi(storicoLetto);
        }
      if(TimbraGiornata_Calc(posMia,storicoLetto,gia)) gOperatoOggi=true;
     }

   //--- (2) AZIONE, identica al gemello ABTG_ORB_Ottimizzato (ramo gHadPos):
   //    finito il trade del giorno, i pendenti superstiti non devono poter
   //    riaprire in giornata. Prima della v1.11 li toglieva solo il CUTOFF,
   //    e una giornata che apriva e chiudeva PRIMA del cutoff restava
   //    scoperta. CancelPendings() filtra gia' simbolo+magic e quando non
   //    c'e' niente da cancellare non fa nessuna chiamata.
   if(GiornataSpesa_Calc(InpOneTradePerDay,gOperatoOggi,posMia)) CancelPendings();
  }

//==================================================================
//  AUTOTEST DEI PREDICATI (v1.11)
//
//  Perche' esiste: qui non c'e' MetaEditor ne' Strategy Tester, quindi
//  senza questa funzione l'unica prova che le tabelle di verita' siano
//  scritte giuste sarebbe "l'ho riletto". Le quattro tabelle sono
//  COMPLETE (tutte le combinazioni), non a campione.
//  Cosa NON prova: che il terminale risponda quello che ci aspettiamo
//  (posizioni, storico, sincronizzazione). Quella resta la prova in
//  campo. Qui si prova che, DATE le risposte, decidiamo giusto.
//  Si legge ESEGUENDO: le righe escono nel Giornale al caricamento.
//==================================================================
void Autotest()
  {
   int blocchi=0, casi=0, falliti=0;

   const string S="MIOSIMBOLO";   // il nostro simbolo (finto: i predicati non toccano il terminale)
   const string A="ALTROSIMB";    // un simbolo qualsiasi che non e' il nostro
   const long   M=770401;         // il NOSTRO magic
   const long   V=770402;         // un vicino: la sedia MAXMIN ORO, stesso EA su un altro simbolo

   //--- BLOCCO 1: simbolo+magic. Il magic da solo non basta, il simbolo nemmeno.
   blocchi++; casi+=4;
   if(!( PosMia_Calc(S,M,S,M) && !PosMia_Calc(A,M,S,M) &&
        !PosMia_Calc(S,V,S,M) && !PosMia_Calc(A,V,S,M) ))
     { falliti++; Print("MAXMIN AUTOTEST: 1 PosMia_Calc DIVERGE"); }

   //--- BLOCCO 2: il timbro. Tabella completa (posMia, storicoLetto, gia).
   //    Le due righe che contano sono (F,F,T) e (F,F,F): storico NON letto
   //    = "non lo so" = NON si timbra, mai.
   blocchi++; casi+=8;
   if(!( TimbraGiornata_Calc(true ,false,false) && TimbraGiornata_Calc(true ,false,true ) &&
         TimbraGiornata_Calc(true ,true ,false) && TimbraGiornata_Calc(true ,true ,true ) &&
        !TimbraGiornata_Calc(false,false,false) && !TimbraGiornata_Calc(false,false,true ) &&
        !TimbraGiornata_Calc(false,true ,false) &&  TimbraGiornata_Calc(false,true ,true ) ))
     { falliti++; Print("MAXMIN AUTOTEST: 2 TimbraGiornata_Calc DIVERGE"); }

   //--- BLOCCO 3: giornata spesa. Tabella completa (uno, operato, posMia).
   //    L'unico VERO e' (T,T,F): input acceso, ho operato, e la posizione
   //    non c'e' piu'. Con la posizione ancora viva deve essere FALSO.
   blocchi++; casi+=8;
   if(!( !GiornataSpesa_Calc(false,false,false) && !GiornataSpesa_Calc(false,false,true ) &&
         !GiornataSpesa_Calc(false,true ,false) && !GiornataSpesa_Calc(false,true ,true ) &&
         !GiornataSpesa_Calc(true ,false,false) && !GiornataSpesa_Calc(true ,false,true ) &&
          GiornataSpesa_Calc(true ,true ,false) && !GiornataSpesa_Calc(true ,true ,true ) ))
     { falliti++; Print("MAXMIN AUTOTEST: 3 GiornataSpesa_Calc DIVERGE"); }

   //--- BLOCCO 4: il ripiazzamento. Tabella completa (uno, operato). Con
   //    l'input SPENTO si piazza sempre = la v1.10 esatta.
   blocchi++; casi+=4;
   if(!( PuoArmare_Calc(false,false) && PuoArmare_Calc(false,true ) &&
         PuoArmare_Calc(true ,false) && !PuoArmare_Calc(true ,true ) ))
     { falliti++; Print("MAXMIN AUTOTEST: 4 PuoArmare_Calc DIVERGE"); }

   //--- IL CONTROLLO SUL CONTROLLO. Un gate che non conta quello che ha
   //    eseguito non e' un gate: un blocco cancellato passerebbe per
   //    "tutto verde", e un blocco svuotato delle asserzioni pure.
   if(blocchi!=MM_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      PrintFormat("MAXMIN AUTOTEST: eseguiti %d blocchi ma ne erano attesi %d: MANCA UN BLOCCO. Autotest FALLITO.",
                  blocchi,MM_AUTOTEST_BLOCCHI_ATTESI);
     }
   if(casi!=MM_AUTOTEST_CASI_ATTESI)
     {
      falliti++;
      PrintFormat("MAXMIN AUTOTEST: dichiarati %d casi ma ne erano attesi %d: un blocco e' stato SVUOTATO. Autotest FALLITO.",
                  casi,MM_AUTOTEST_CASI_ATTESI);
     }

   PrintFormat("MAXMIN AUTOTEST: %d blocchi su %d passati, %d casi dichiarati, %d falliti. %s",
               blocchi-falliti,blocchi,casi,falliti,
               (falliti==0 ? "Predicati 'un trade al giorno' VERIFICATI a tavolino (NON sostituisce la prova in campo)."
                           : "ATTENZIONE: i predicati NON sono quelli attesi. NON mettere in forward."));
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

bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

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
//| Export per-trade in Common\Files (per dd_portafoglio.py).         |
//| Solo tester: in griglia ogni pass con lo stesso magic SOVRASCRIVE |
//| il file -> usare solo con pin + magic-sweep (2 celle).            |
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
   ExportTrades();
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
