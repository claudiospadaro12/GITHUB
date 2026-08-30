//+------------------------------------------------------------------+
//|                                        ABTG_ChaosLyapunov.mq5     |
//|                                                                  |
//|  MOTORE EMA-CROSS GATED da LYAPUNOV (Chaos Theory) - MT5 -       |
//|  TUTTO-IN-UNO (metti in MQL5\Experts e compila con F7).          |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria):                                    |
//|    Gate LLE Chaos/Lyapunov da jojoale (jojoalb), MQL5 Code Base  |
//|    76446. EMA-cross gated, adattato.                             |
//|                                                                  |
//|  COS'E' - un EMA-cross 9/21 (trigger direzionale generico)       |
//|    GATED da un filtro di REGIME COSTITUTIVO: l'esponente di      |
//|    Lyapunov piu' grande (LLE) calcolato in phase-space. Il gate  |
//|    E' il motore, non una decorazione: alla riga-chiave           |
//|    equivalente a `if(lyapunov_exponent > InpLyaThreshold)        |
//|    return;` l'EA NON opera (resta flat) quando la dinamica e'    |
//|    caotica (LLE > soglia). Opera SOLO nel regime leggibile       |
//|    (LLE <= soglia). Senza il gate e' un EMA-cross nudo.          |
//|                                                                  |
//|  IL GATE (portato FEDELMENTE dal sorgente 76446, righe 116-156)  |
//|    - CopyClose di InpLyaLookback+InpLyaKSteps+InpLyaEmbedding    |
//|      chiusure (serie), poi ricerca del "vicino piu' prossimo"    |
//|      nello spazio ricostruito a embedding InpLyaEmbedding;       |
//|    - divergenza dopo InpLyaKSteps passi -> LLE =                 |
//|      log(dist_k/min_dist)/k. La formula e' identica al sorgente. |
//|    Il calcolo vive in Lyapunov_Calc (nucleo puro): l'AUTOTEST lo |
//|    interroga a tavolino su una serie nota (ln5).                 |
//|                                                                  |
//|  PROP-HARDENING (identico allo scaffold ABTG_InvEsaurimento)     |
//|    - STOP LOSS VERO AL BROKER, ATR-based (InpSlAtrMult x ATR),   |
//|      con PAVIMENTO SL OBBLIGATORIO (R109): InpMinStopPts, MAI    |
//|      zero -> OnInit RIFIUTA (INIT_FAILED) se il pavimento e' 0.  |
//|      Indici: 1 punto indice = 100 punti MT5 (_Point).           |
//|    - SIZING A RISCHIO (LotByRisk). Una sola posizione per magic. |
//|    - NIENTE martingala/griglia/recovery/averaging/virtual-stop:  |
//|      ingresso SINGOLO, nessuna aggiunta su posizione aperta.     |
//|    - EXPORT PER-TRADE CSV + OnTester (Recovery Factor) +         |
//|      OnTesterInit/OnTesterDeinit con OPTFRAME, contatori in      |
//|      colonna come lo scaffold. AUTOTEST del nucleo in avvio.     |
//|                                                                  |
//|  FLAT-EOD - questo e' lo STEP 1 (screening del gate sul motore   |
//|    NUDO): la griglia gira su NASUSD_EXT che TIENE overnight.     |
//|    Quindi InpCloseAtEnd ha default FALSE (lo step 2 accendera'   |
//|    il flat intraday). Tutti gli altri presidi restano attivi.   |
//|                                                                  |
//|  ORARI: SEMPRE ORA DEL FEED.                                     |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il cross si valuta fra la barra     |
//|  appena chiusa (shift 1) e la precedente (shift 2); l'ordine     |
//|  parte all'apertura della barra 0. Niente look-ahead/repaint.   |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola   |
//|  di casa). NON compilato ne' testato da chi ha scritto il file:  |
//|  compilare in MetaEditor (F7) e validare nel tester.            |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - EMA-cross gated Lyapunov (adattato da jojoale, CodeBase 76446)"
#property version   "1.00"
#property description "Gate LLE Chaos/Lyapunov da jojoale (jojoalb), MQL5 Code Base 76446. EMA-cross gated, adattato."
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== GATE DI REGIME - Lyapunov (Chaos) ==="
input double InpLyaThreshold   = 0.00;   // Soglia LLE: opera solo se LLE <= soglia (LLE>soglia = flat nel caos)
input int    InpLyaLookback    = 100;    // Phase-space lookback (finestra di ricerca del vicino)
input int    InpLyaEmbedding   = 3;      // Dimensione di embedding m (dal sorgente)
input int    InpLyaKSteps      = 5;      // Passi di proiezione k (dal sorgente)

input group "=== TRIGGER DIREZIONALE - EMA cross ==="
input int    InpEmaFast        = 9;      // EMA veloce (trigger, dal sorgente)
input int    InpEmaSlow        = 21;     // EMA lenta  (trigger, dal sorgente)

input group "=== STOP / TAKE (ATR) - pavimento R109 ==="
input int    InpAtrPeriod      = 14;     // Periodo ATR per SL/TP
input double InpSlAtrMult      = 1.5;    // SL = mult x ATR (dal sorgente)
input double InpTpAtrMult       = 2.5;   // TP = mult x ATR (dal sorgente)
input int    InpMinStopPts     = 500;    // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== FLAT DI FINE SEDUTA (STEP 2; default OFF) ==="
input bool   InpCloseAtEnd     = false;  // Flat intraday di fine seduta (STEP 1 = OFF: motore nudo, tiene overnight)
input int    InpSessionEndHour = 15;     // Ora del FLAT (ora del FEED), usata solo se InpCloseAtEnd
input int    InpSessionEndMin  = 55;     // Minuto del FLAT (ora del FEED)

input group "=== Rischio e conversione punti ==="
input double InpRiskPercent    = 1.0;    // Rischio per trade, % del balance (screening d'archivio = 1.0)
input double InpMT5PerPuntoIndice = 100; // Punti MT5 (_Point) per 1 punto indice (US: 100). Solo export/log.
input bool   InpAllowLong      = true;   // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort     = true;   // Ammetti gli SHORT

input group "=== Generali ==="
input string InpComment        = "LYA";     // Commento sugli ordini
input long   InpMagic          = 769200;    // Numero magico (verificato VERGINE nel repo)
input int    InpMaxSpread      = 0;         // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose        = true;      // Messaggi nel log
input bool   InpAutoTest       = true;      // Stampa le righe [LYA][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

int      gAtr      = INVALID_HANDLE;
int      gEmaFast  = INVALID_HANDLE;
int      gEmaSlow  = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1;
ulong    gUltimoTicketContato = 0;
int      gFlatLogGiorno = -1;

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE
//    cancello ferma le barre. L'ordine QUI, in OnTester e nell'header
//    di OnTesterDeinit si toccano SEMPRE INSIEME.
long gCntOnNewBar   = 0;   // chiamate totali a OnNewBar
long gCntGestione   = 0;   // return: c'era gia' una posizione aperta
long gCntNoData     = 0;   // return: dati non pronti (CopyClose/CopyBuffer)
long gCntGateChaos  = 0;   // GATE: LLE > soglia -> flat nel caos
long gCntGatePass   = 0;   // GATE superato: LLE <= soglia
long gCntNoCross    = 0;   // return: nessun incrocio EMA
long gCntSpread     = 0;   // return: spread non ok
long gCntShortCand  = 0;   // candidati SHORT (cross down, dopo il gate)
long gCntLongCand   = 0;   // candidati LONG  (cross up, dopo il gate)
long gCntApri       = 0;   // chiamate effettive ad ApriPosizione
long gCntFlatSkip   = 0;   // return: dopo l'orario di flat (solo se InpCloseAtEnd)

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[LYA] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono: e' questa la parte
//   che l'AUTOTEST interroga a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| ESPONENTE DI LYAPUNOV PIU' GRANDE (LLE) - portato FEDELMENTE dal  |
//| sorgente jojoale 76446 (righe 116-156). 'prices' e' una serie     |
//| (prices[0] = chiusura piu' recente). Ricostruisce lo spazio a     |
//| embedding 'm', cerca il vicino piu' prossimo entro 'lookback',    |
//| misura la divergenza dopo 'k' passi e ritorna log(dist_k/min)/k.  |
//| Casi degeneri (nessun vicino, distanze nulle, dati corti) -> 0.0  |
//| ESATTAMENTE come il sorgente.                                     |
//+------------------------------------------------------------------+
double Lyapunov_Calc(const double &prices[],const int lookback,
                     const int embedding,const int ksteps)
  {
   int required = lookback + ksteps + embedding;
   if(ArraySize(prices) < required) return(0.0);

   double min_dist = 999999.0;
   int    nearest_idx = -1;

   //--- vicino piu' prossimo del segmento corrente (ancorato a shift k)
   for(int i=ksteps+1; i<lookback; i++)
     {
      double dist=0;
      for(int j=0; j<embedding; j++)
         dist += MathPow(prices[ksteps+j]-prices[i+j],2);
      dist = MathSqrt(dist);

      if(dist>0.000001 && dist<min_dist)
        {
         min_dist = dist;
         nearest_idx = i;
        }
     }

   if(nearest_idx==-1 || min_dist==0) return(0.0);

   //--- divergenza dopo k passi: segmento piu' recente (shift 0) vs il
   //    vicino riportato indietro di k
   double dist_k=0;
   for(int j=0; j<embedding; j++)
      dist_k += MathPow(prices[0+j]-prices[nearest_idx-ksteps+j],2);
   dist_k = MathSqrt(dist_k);

   if(dist_k==0) return(0.0);

   return(MathLog(dist_k/min_dist)/ksteps);
  }

//+------------------------------------------------------------------+
//| IL GATE COSTITUTIVO. Vero = BLOCCA (resta flat). Equivale alla    |
//| riga 217 del sorgente: if(lyapunov_exponent > InpLyaThreshold)    |
//| return;  -> caos (LLE alto): niente trade.                        |
//+------------------------------------------------------------------+
bool GateBloccaChaos_Calc(const double lle,const double soglia)
  {
   return(lle > soglia);
  }

//+------------------------------------------------------------------+
//| Incrocio EMA sull'ultima barra chiusa. 'prev' = shift 2, 'cur' =  |
//| shift 1 (barra appena chiusa), come il sorgente (buffer[1]/[0]).  |
//+------------------------------------------------------------------+
bool CrossUp_Calc(const double fastPrev,const double slowPrev,
                  const double fastCur,const double slowCur)
  {
   return(fastPrev<=slowPrev && fastCur>slowCur);
  }
bool CrossDn_Calc(const double fastPrev,const double slowPrev,
                  const double fastCur,const double slowCur)
  {
   return(fastPrev>=slowPrev && fastCur<slowCur);
  }

//+------------------------------------------------------------------+
//| SL grezzo da ATR: long sotto l'entry, short sopra.                |
//+------------------------------------------------------------------+
double SlAtr_Calc(const bool isLong,const double entry,
                  const double atr,const double mult)
  {
   return(isLong ? entry-mult*atr : entry+mult*atr);
  }

//+------------------------------------------------------------------+
//| TP grezzo da ATR: long sopra l'entry, short sotto.                |
//+------------------------------------------------------------------+
double TpAtr_Calc(const bool isLong,const double entry,
                  const double atr,const double mult)
  {
   return(isLong ? entry+mult*atr : entry-mult*atr);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109, convenzione di casa). Se lo stop e'   |
//| piu' vicino del pavimento, si ALLARGA al pavimento; non si salta  |
//| il trade e non si lascia lo stop a zero. pavimento<=0 -> invariato|
//| (ma il chiamante garantisce > 0).                                 |
//+------------------------------------------------------------------+
double PavimentoSL_Calc(const bool isLong,const double entry,
                        const double slGrezzo,const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R>=pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - nucleo puro. Vero quando l'ora corrente ha  |
//| raggiunto o superato l'ora di fine seduta (confronto in minuti).  |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE.                  |
//+------------------------------------------------------------------+
double PrezzoInPuntiIndice_Calc(const double distPrezzo,
                                const double mt5PerIdx,const double point)
  {
   double den = mt5PerIdx*point;
   if(den<=0) return(0);
   return(distPrezzo/den);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- validazioni del gate Lyapunov (il calcolo deve avere senso)
   if(InpLyaLookback < 10)
     { Print("ERRORE: InpLyaLookback troppo piccolo (>= 10)."); return(INIT_FAILED); }
   if(InpLyaEmbedding < 1)
     { Print("ERRORE: InpLyaEmbedding deve essere >= 1."); return(INIT_FAILED); }
   if(InpLyaKSteps < 1)
     { Print("ERRORE: InpLyaKSteps deve essere >= 1."); return(INIT_FAILED); }
   if(InpLyaKSteps+1 >= InpLyaLookback)
     { Print("ERRORE: InpLyaKSteps+1 deve essere < InpLyaLookback (loop del vicino vuoto)."); return(INIT_FAILED); }
   if(InpEmaFast < 1 || InpEmaSlow < 1)
     { Print("ERRORE: periodi EMA non validi (>= 1)."); return(INIT_FAILED); }
   if(InpEmaFast >= InpEmaSlow)
     { Print("ERRORE: InpEmaFast deve essere < InpEmaSlow (trigger di cross)."); return(INIT_FAILED); }
   if(InpAtrPeriod < 1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpSlAtrMult <= 0)
     { Print("ERRORE: InpSlAtrMult deve essere > 0."); return(INIT_FAILED); }
   if(InpTpAtrMult <= 0)
     { Print("ERRORE: InpTpAtrMult deve essere > 0."); return(INIT_FAILED); }

   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing:
   //    OnInit RIFIUTA se e' 0. Un EA senza stop vero non si testa.
   if(InpMinStopPts <= 0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Senza stop vero non si testa."); return(INIT_FAILED); }

   if(InpRiskPercent <= 0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice <= 0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }
   if(InpCloseAtEnd)
     {
      if(InpSessionEndHour<0 || InpSessionEndHour>23 || InpSessionEndMin<0 || InpSessionEndMin>59)
        { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
     }

   //--- handle indicatori (creati una volta, rilasciati in OnDeinit)
   gAtr     = iATR(_Symbol, gTF, InpAtrPeriod);
   gEmaFast = iMA (_Symbol, gTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
   gEmaSlow = iMA (_Symbol, gTF, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
   if(gAtr==INVALID_HANDLE || gEmaFast==INVALID_HANDLE || gEmaSlow==INVALID_HANDLE)
     { Print("ERRORE: creazione indicatori fallita (ATR/EMA)."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestLyapunov();

   Log(StringFormat("avviato su %s %s. GATE LLE soglia %.4f [look %d / m %d / k %d], EMA %d/%d, SL %.2fxATR%d + pavimento %d pti MT5, TP %.2fxATR, rischio %.2f%%, flatEOD %s, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpLyaThreshold, InpLyaLookback, InpLyaEmbedding, InpLyaKSteps,
       InpEmaFast, InpEmaSlow,
       InpSlAtrMult, InpAtrPeriod, InpMinStopPts, InpTpAtrMult,
       InpRiskPercent, (InpCloseAtEnd?"ON":"off"), InpMagic));
   Log("GATE COSTITUTIVO: opera SOLO con LLE <= soglia (regime leggibile), flat nel caos. Ingresso SINGOLO: nessuna aggiunta/mediazione/griglia su posizione aperta.");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gAtr     != INVALID_HANDLE) IndicatorRelease(gAtr);
   if(gEmaFast != INVALID_HANDLE) IndicatorRelease(gEmaFast);
   if(gEmaSlow != INVALID_HANDLE) IndicatorRelease(gEmaSlow);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();

   if(FlatFineSedutaCheck()) return;   // fine seduta (solo se InpCloseAtEnd): chiudo e non riapro

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| Legge le chiusure e calcola l'LLE col nucleo puro. false se i     |
//| dati non bastano (CopyClose corto).                               |
//+------------------------------------------------------------------+
bool LeggiLyapunov(double &lleOut)
  {
   lleOut = 0.0;
   int required = InpLyaLookback + InpLyaKSteps + InpLyaEmbedding;
   double prices[]; ArraySetAsSeries(prices,true);
   if(CopyClose(_Symbol, gTF, 0, required, prices) < required) return(false);
   lleOut = Lyapunov_Calc(prices, InpLyaLookback, InpLyaEmbedding, InpLyaKSteps);
   return(true);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Ordine dei cancelli COME IL SORGENTE: |
//| posizione aperta -> gate LLE -> incrocio EMA. Si valuta la barra  |
//| appena chiusa (shift 1); l'ordine parte al mercato sulla barra 0. |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   //--- una posizione per magic: niente aggiunte/gestione-extra.
   if(CountPositions()>0){ gCntGestione++; return; }

   //--- flat imminente: se il flat e' acceso e siamo dopo l'orario,
   //    non si apre (lo chiuderebbe subito). STEP 1: flat OFF -> mai qui.
   if(InpCloseAtEnd)
     {
      MqlDateTime t; TimeToStruct(TimeCurrent(),t);
      if(DopoOrarioFlat_Calc(t.hour,t.min,InpSessionEndHour,InpSessionEndMin))
        { gCntFlatSkip++; return; }
     }

   //--- GATE COSTITUTIVO per primo (come il sorgente): LLE dallo spazio
   //    ricostruito. Dati corti -> non si decide.
   double lle=0.0;
   if(!LeggiLyapunov(lle)){ gCntNoData++; return; }
   if(GateBloccaChaos_Calc(lle, InpLyaThreshold)){ gCntGateChaos++; return; }
   gCntGatePass++;

   //--- indicatori del trigger (solo dopo il gate)
   double fast[]; double slow[]; double atrb[];
   ArraySetAsSeries(fast,true); ArraySetAsSeries(slow,true); ArraySetAsSeries(atrb,true);
   if(CopyBuffer(gEmaFast,0,1,2,fast)<2){ gCntNoData++; return; }
   if(CopyBuffer(gEmaSlow,0,1,2,slow)<2){ gCntNoData++; return; }
   if(CopyBuffer(gAtr   ,0,1,1,atrb)<1){ gCntNoData++; return; }

   double atr = atrb[0];
   if(atr<=0){ gCntNoData++; return; }

   if(!SpreadOK()){ gCntSpread++; return; }

   //--- prev = shift 2, cur = shift 1 (buffer[1]/buffer[0] del sorgente)
   double fastCur=fast[0], fastPrev=fast[1];
   double slowCur=slow[0], slowPrev=slow[1];

   bool up = CrossUp_Calc(fastPrev,slowPrev,fastCur,slowCur);
   bool dn = CrossDn_Calc(fastPrev,slowPrev,fastCur,slowCur);
   if(!up && !dn){ gCntNoCross++; return; }

   if(dn) gCntShortCand++; else gCntLongCand++;

   if(up && InpAllowLong ){ gCntApri++; ApriPosizione(true , atr); return; }
   if(dn && InpAllowShort){ gCntApri++; ApriPosizione(false, atr); }
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL = mult x ATR, poi SEMPRE dal     |
//| PAVIMENTO (mai a zero, mai dentro lo stops-level). TP = mult x    |
//| ATR (rispetta lo stops-level). Il lotto esce da LotByRisk sulla   |
//| distanza FINALE dello stop.                                       |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong, const double atr)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;

   double slRaw = SlAtr_Calc(isLong, ref, atr, InpSlAtrMult);

   //--- PAVIMENTO OBBLIGATORIO (R109): mai piu' stretto del pavimento in
   //    punti MT5, e mai dentro lo stops-level del broker.
   double pavimento = InpMinStopPts*_Point;
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo: salto per non lasciare lo stop scoperto (R109)."); return(false); }

   double sl = PavimentoSL_Calc(isLong, ref, slRaw, pavFinale);
   sl = NormalizePrice(sl);
   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- TP da ATR, spinto oltre lo stops-level se troppo vicino.
   double tp = TpAtr_Calc(isLong, ref, atr, InpTpAtrMult);
   double distTP = isLong ? (tp-ref) : (ref-tp);
   if(distTP < minBroker) tp = isLong ? ref+minBroker : ref-minBroker;
   distTP = isLong ? (tp-ref) : (ref-tp);
   if(distTP<=0) tp = 0;
   if(tp>0) tp = NormalizePrice(tp);

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp,cm);
   if(ok)
     {
      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP %s lot %.2f (rischio %.1f pti idx | ATR %s)",
          isLong?"BUY(cross up)":"SELL(cross down)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          (tp>0?DoubleToString(tp,_Digits):"-"), lot, idxRisk,
          DoubleToString(atr,_Digits)));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   if(!InpCloseAtEnd) return(false);

   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpSessionEndHour,InpSessionEndMin)) return(false);

   int chiuse=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(p)) chiuse++;
      else Log("flat di fine seduta: chiusura FALLITA - "+gTrade.ResultRetcodeDescription());
     }
   gFlatChiusure += chiuse;

   if(t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      gFlatGiorni++;
      if(chiuse>0)
         Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
                          InpSessionEndHour, InpSessionEndMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Conta gli ingressi ESEGUITI (aggancio al ticket), per diagnostica.|
//+------------------------------------------------------------------+
void AggiornaContatoreTrade()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(tk!=gUltimoTicketContato) gUltimoTicketContato=tk;
      return;
     }
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   double giornata = 100.0*(gDayMinEquity-gDayStartEquity)/gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int    dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Lotto dalla distanza dello stop. PERDITA PER LOTTO DAL BROKER
//    (OrderCalcProfit converte in valuta conto); il tick value resta
//    come ripiego. Su un indice la distanza e' in PREZZO.
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot = -profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);

   double lot = risk/lossPerLot;
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot = MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  AUTOTEST - stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester). F7 compila e basta.
//==================================================================
void AutoTestLyapunov()
  {
   int falliti=0;

   PrintFormat("[LYA][AUTOTEST] soglia %.4f [look %d / m %d / k %d] EMA %d/%d | %s | magic %I64d",
               InpLyaThreshold, InpLyaLookback, InpLyaEmbedding, InpLyaKSteps,
               InpEmaFast, InpEmaSlow, _Symbol, InpMagic);

   //--- 1. LLE (nucleo puro) su una serie NOTA. Con m=1, k=1, look=4 il
   //    sorgente riduce a: min |p1-p2|,|p1-p3| e log(dist_k/min)/1.
   //    p = {10,8,5,7,0,0} (serie, p[0] recente):
   //      i=2: |8-5|=3 ; i=3: |8-7|=1 -> min=1, nearest=3
   //      dist_k = |p[0]-p[nearest-1]| = |10-5| = 5
   //      LLE = log(5/1)/1 = ln5 ~ 1.60943791
   double p6[6]; p6[0]=10; p6[1]=8; p6[2]=5; p6[3]=7; p6[4]=0; p6[5]=0;
   double lle1 = Lyapunov_Calc(p6, 4, 1, 1);
   //    serie piatta -> tutte le distanze nulle -> nessun vicino -> 0.0
   double pf[6]; for(int i=0;i<6;i++) pf[i]=5.0;
   double lle2 = Lyapunov_Calc(pf, 4, 1, 1);
   //    dati corti (array < required) -> 0.0
   double ps[3]; ps[0]=1; ps[1]=2; ps[2]=3;
   double lle3 = Lyapunov_Calc(ps, 4, 1, 1);
   PrintFormat("[LYA][AUTOTEST] LLE: ln5=%.8f (1.60943791) | piatta=%.8f (0) | corta=%.8f (0)",
               lle1, lle2, lle3);
   if(!(MathAbs(lle1-1.6094379124341003)<1e-6 && lle2==0.0 && lle3==0.0)) falliti++;

   //--- 2. IL GATE (riga 217 del sorgente): LLE > soglia -> blocca
   bool g1=GateBloccaChaos_Calc( 0.5, 0.0);   // caos -> blocca
   bool g2=GateBloccaChaos_Calc(-0.1, 0.0);   // ordinato -> passa
   bool g3=GateBloccaChaos_Calc( 0.0, 0.0);   // uguale -> passa (non >)
   PrintFormat("[LYA][AUTOTEST] gate: caos=%d (1) ordine=%d (0) uguale=%d (0)",
               (int)g1,(int)g2,(int)g3);
   if(!(g1 && !g2 && !g3)) falliti++;

   //--- 3. INCROCIO EMA (prev=shift2, cur=shift1)
   bool cu=CrossUp_Calc(1,2, 3,2);   // veloce sotto poi sopra -> up
   bool cd=CrossDn_Calc(2,1, 2,3);   // veloce sopra poi sotto -> dn
   bool cn=CrossUp_Calc(3,2, 3,2);   // gia' sopra, resta sopra -> no cross
   PrintFormat("[LYA][AUTOTEST] cross: up=%d (1) dn=%d (1) noCross=%d (0)",
               (int)cu,(int)cd,(int)cn);
   if(!(cu && cd && !cn)) falliti++;

   //--- 4. SL/TP da ATR
   double slL=SlAtr_Calc(true ,100.0,2.0,1.5);   // long  -> 97
   double slS=SlAtr_Calc(false,100.0,2.0,1.5);   // short -> 103
   double tpL=TpAtr_Calc(true ,100.0,2.0,2.5);   // long  -> 105
   double tpS=TpAtr_Calc(false,100.0,2.0,2.5);   // short -> 95
   PrintFormat("[LYA][AUTOTEST] atr: slL=%.2f(97) slS=%.2f(103) tpL=%.2f(105) tpS=%.2f(95)",
               slL,slS,tpL,tpS);
   if(!(MathAbs(slL-97.0)<1e-6 && MathAbs(slS-103.0)<1e-6 &&
        MathAbs(tpL-105.0)<1e-6 && MathAbs(tpS-95.0)<1e-6)) falliti++;

   //--- 5. PAVIMENTO SL (mai a zero: R109)
   double q1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double q2=PavimentoSL_Calc(true ,100.0, 97.0,2.0);  // gia' oltre -> 97.00
   double q3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short -> 102.00
   PrintFormat("[LYA][AUTOTEST] pav: %.2f(98.00) %.2f(97.00) short %.2f(102.00)", q1,q2,q3);
   if(!(MathAbs(q1-98.0)<1e-6 && MathAbs(q2-97.0)<1e-6 && MathAbs(q3-102.0)<1e-6)) falliti++;

   //--- 6. FLAT / conversione punti indice
   bool fl1=DopoOrarioFlat_Calc(15,55,15,55);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(15,54,15,55);   // prima -> no
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   PrintFormat("[LYA][AUTOTEST] flat esatto=%d(1) prima=%d(0) | conv=%.2f(5.00)",
               (int)fl1,(int)fl2,ip1);
   if(!(fl1 && !fl2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[LYA][AUTOTEST] esito motore: ", (falliti==0
         ? "SEI BLOCCHI SU SEI, il gate e il trigger ragionano come il sorgente."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. In backtest singolo e'       //
//  inerte (gira solo in ottimizzazione).                           //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE in Common\Files. Ogni riga = una posizione       |
//| CHIUSA, con PREZZO D'INGRESSO E DI USCITA, per calcolare la take  |
//| in PUNTI INDICE. Identico allo scaffold.                          |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   int nd=HistoryDealsTotal();

   long   idIn[];   double pxIn[];   long dirIn[];   string cmIn[];
   int    cIn=0;
   ArrayResize(idIn,nd); ArrayResize(pxIn,nd); ArrayResize(dirIn,nd); ArrayResize(cmIn,nd);
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      idIn[cIn]  = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      pxIn[cIn]  = HistoryDealGetDouble (tk,DEAL_PRICE);
      dirIn[cIn] = HistoryDealGetInteger(tk,DEAL_TYPE);   // BUY entry = long
      cmIn[cIn]  = HistoryDealGetString (tk,DEAL_COMMENT);
      cIn++;
     }

   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","dir","volume",
             "entry_price","exit_price","take_idx_pts","net_profit","comment");

   double den = InpMT5PerPuntoIndice*_Point;
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;

      long   posId = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      double pxOut = HistoryDealGetDouble (tk,DEAL_PRICE);
      double net   = HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);

      double pxEntry=0; long dir=-1; string cm=""; bool trovato=false;
      for(int k=0;k<cIn;k++)
         if(idIn[k]==posId){ pxEntry=pxIn[k]; dir=dirIn[k]; cm=cmIn[k]; trovato=true; break; }

      bool isLong = (dir==DEAL_TYPE_BUY);
      double takeIdx = 0;
      if(trovato && den>0)
        {
         double mossaPrezzo = isLong ? (pxOut-pxEntry) : (pxEntry-pxOut);
         takeIdx = mossaPrezzo/den;
        }

      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(InpMagic),
                IntegerToString(posId),
                (trovato ? (isLong?"LONG":"SHORT") : "?"),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(pxEntry,_Digits),
                DoubleToString(pxOut,_Digits),
                DoubleToString(takeIdx,1),
                DoubleToString(net,2),
                cm);
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[24];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che rispondono "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
   //--- le tre colonne di COLLAUDO (gate, non merito)
   stats[10] = (double)gAutotestFalliti;   // 0 = passati; >0 = DIVERGE; -1 = non eseguito
   stats[11] = (double)gFlatGiorni;        // giornate col flat scattato
   stats[12] = (double)gFlatChiusure;      // posizioni chiuse dal flat
   //--- DIAGNOSTICA: i contatori per-cancello di OnNewBar, in coda.
   //    L'ordine QUI e nell'header/row di OnTesterDeinit si toccano SEMPRE
   //    INSIEME (una colonna aggiunta a uno solo sfasa tutto il CSV).
   stats[13] = (double)gCntOnNewBar;       // OnNewBar Chiamate
   stats[14] = (double)gCntGestione;       // Ret Gestione
   stats[15] = (double)gCntNoData;         // Ret No Dati
   stats[16] = (double)gCntGateChaos;      // Gate Chaos Ko
   stats[17] = (double)gCntGatePass;       // Gate Pass
   stats[18] = (double)gCntNoCross;        // Ret No Cross
   stats[19] = (double)gCntSpread;         // Ret Spread
   stats[20] = (double)gCntShortCand;      // Short Cand
   stats[21] = (double)gCntLongCand;       // Long Cand
   stats[22] = (double)gCntApri;           // Apri Chiamate
   stats[23] = (double)gCntFlatSkip;       // Ret Flat Skip

   PrintFormat("[LYA][DIAG] OnNewBar=%I64d | ret: gestione=%I64d noData=%I64d | gate: chaosKo=%I64d pass=%I64d | noCross=%I64d spread=%I64d | shortCand=%I64d longCand=%I64d apri=%I64d flatSkip=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoData, gCntGateChaos,
               gCntGatePass, gCntNoCross, gCntSpread,
               gCntShortCand, gCntLongCand, gCntApri, gCntFlatSkip);

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
         //--- 'head' e lo StringFormat qui sotto si toccano SEMPRE INSIEME:
         //    una colonna aggiunta a uno solo sfasa tutto il CSV.
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret No Dati,Gate Chaos Ko,Gate Pass,Ret No Cross,Ret Spread,Short Cand,Long Cand,Apri Chiamate,Ret Flat Skip";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
