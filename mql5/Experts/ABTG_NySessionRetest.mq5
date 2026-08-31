//+------------------------------------------------------------------+
//|                                      ABTG_NySessionRetest.mq5     |
//|                                                                  |
//|  MOTORE NY SESSION TREND RETEST - MT5 - TUTTO-IN-UNO             |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria):                                    |
//|    Motore NY Session Trend Retest da itzkarmakyo (TradingView),  |
//|    licenza MPL 2.0 (https://mozilla.org/MPL/2.0/). Portato in     |
//|    MQL5, gestione e prop-hardening propri.                       |
//|                                                                  |
//|  COS'E' - un motore di CONTINUAZIONE di trend, non d'inversione. |
//|    Nella seduta USA, in trend concorde con la EMA200 su H1, il    |
//|    prezzo si allontana dalla VWAP di seduta ANCORATA e poi vi     |
//|    RITORNA: si entra sul RETEST della VWAP, dal lato del trend.   |
//|    Ingresso SINGOLO. NIENTE mediazione/martingala/griglia/        |
//|    raddoppio/aggiunta su posizione aperta.                       |
//|                                                                  |
//|  LA MECCANICA (dal sorgente Pine, valori portati come input)     |
//|    1. GATE DIREZIONE: EMA200 su H1 (InpEmaTrend). Long solo se il |
//|       prezzo e' sopra la EMA200, short solo se sotto.             |
//|    2. VWAP DI SESSIONE ANCORATA: si azzera all'apertura della     |
//|       seduta USA e si ricostruisce barra dopo barra fino alla     |
//|       barra valutata (sorgente hlc3, pesi = tick volume). E' il   |
//|       PERNO del motore, non un filtro dormiente.                  |
//|    3. INGRESSO VWAP-RETEST: la barra appena chiusa TOCCA la VWAP  |
//|       (low<=vwap+buf per il long / high>=vwap-buf per lo short) e |
//|       RICHIUDE dal lato giusto (close>vwap per il long / close<   |
//|       vwap per lo short), con il trend EMA200 concorde.           |
//|    4. FILTRO REGIME COSTITUTIVO (il filtro-che-E'-il-motore): si  |
//|       opera SOLO quando la VWAP ha PENDENZA (slope in valore      |
//|       assoluto >= InpVwapSlopeMin) E il mercato si ESPANDE (range |
//|       recente >= InpExpansionMin). In VWAP piatta o mercato       |
//|       compresso: NIENTE trade. Il gate e' SEMPRE ATTIVO: senza,   |
//|       sarebbe un retest nudo. Le due soglie sono la taratura.     |
//|                                                                  |
//|  PROP-HARDENING (obbligatorio)                                   |
//|    - STOP LOSS VERO AL BROKER, strutturale: lowest/highest degli  |
//|      ultimi InpSlLookback barre +/- buffer. PAVIMENTO SL          |
//|      OBBLIGATORIO (R109): InpMinStopPts, MAI zero -> OnInit        |
//|      RIFIUTA se il pavimento e' <= 0.                             |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa. MAI     |
//|      lotto fisso.                                                 |
//|    - NIENTE martingala/griglia/recovery/DCA/virtual-stop:         |
//|      ingresso SINGOLO, una posizione per magic.                   |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                        |
//|    - FLAT OBBLIGATORIO a fine seduta (ora server): mai overnight. |
//|    - EXPORT PER-TRADE CSV + OnTester (metriche prop) + OPTFRAME.  |
//|      AUTOTEST del nucleo in avvio.                                |
//|                                                                  |
//|  GESTIONE: parziale (InpTP1_ClosePct) sul primo livello           |
//|    favorevole (PM high/low o max/min del giorno prima) + BREAKEVEN|
//|    dopo il parziale; il resto CORRE (runner) fino allo stop o al  |
//|    flat di fine seduta.                                           |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. RTH NY cash 09:30-16:00 ET. Su BCM il     |
//|    server e' IT-1h e NASUSD apre 15:30 IT = 14:30 SERVER          |
//|    (CLAUDE.md). Quindi RTH NY su ORA SERVER = 14:30 -> 21:00.     |
//|    Gli orari sono INPUT con default in ORA SERVER. Il flat di     |
//|    fine seduta e' messo a 20:55 (poco PRIMA delle 21:00 server /  |
//|    16:00 ET) per essere flat prima dell'asta di chiusura:         |
//|    dichiarato, modificabile via input.                            |
//|                                                                  |
//|  CONVERSIONE PUNTI: su NASUSD 1 punto indice = 100 punti MT5      |
//|    (_Point) (R97). Le distanze operative (buffer SL, pavimento)   |
//|    sono in PUNTI MT5; le soglie slope/espansione sono in PUNTI    |
//|    INDICE, convertite con InpMT5PerPuntoIndice.                   |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il segnale si valuta sulla barra     |
//|    appena chiusa (shift 1); l'ordine parte all'apertura della     |
//|    barra 0. Niente look-ahead, niente repaint.                    |
//|                                                                  |
//|  TIMEFRAME DI LAVORO: H1. DEMO. Nessuna garanzia. ASCII puro      |
//|    dentro le stringhe (regola di casa). NON compilato ne' testato |
//|    da chi ha scritto il file: compilare in MetaEditor (F7) e      |
//|    validare nel tester.                                           |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - NY Session Trend Retest (motore itzkarmakyo, MPL 2.0). Gestione e prop-hardening propri."
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== TREND (gate direzione: EMA200 su H1) ==="
input int    InpEmaTrend        = 200;   // Lunghezza EMA di trend su H1 (long sopra, short sotto)

input group "=== VWAP DI SESSIONE ANCORATA (il perno del motore) ==="
input int    InpRetestBufferPts = 0;     // Sensibilita' del retest: buffer al tocco VWAP, in PUNTI MT5 (0 = tocco esatto)

input group "=== FILTRO REGIME COSTITUTIVO (SEMPRE attivo) ==="
input double InpVwapSlopeMin    = 2.0;   // Pendenza minima |VWAP| sul periodo, in PUNTI INDICE (0 = gate slope neutro)
input int    InpVwapSlopePeriod = 5;     // Barre su cui si misura la pendenza della VWAP
input double InpExpansionMin    = 10.0;  // Espansione minima del range recente, in PUNTI INDICE (0 = gate espansione neutro)
input int    InpExpansionLookback = 10;  // Barre su cui si misura l'espansione (highest-lowest)

input group "=== SESSIONE USA (ORA SERVER; NY ET -> server, apertura 14:30) ==="
input int    InpSessionHour     = 14;    // Ora apertura seduta = ancoraggio VWAP (NY ET 09:30 -> server 14:30)
input int    InpSessionMin      = 30;    // Minuto apertura seduta (NY ET 09:30 -> server 14:30)
input int    InpCloseHour       = 20;    // Ora del FLAT di fine seduta (NY ET 16:00 -> server 21:00; qui poco prima)
input int    InpCloseMin        = 55;    // Minuto del FLAT (20:55 server = poco prima del close RTH 21:00, dichiarato)
input bool   InpCloseAtEnd      = true;  // FLAT obbligatorio a fine seduta USA (mai overnight - vincolo del mandato)

input group "=== PREMARKET (per i livelli di parziale; ORA SERVER) ==="
input int    InpPmStartHour     = 9;     // Ora inizio premarket (NY ET 04:00 -> server 09:00)
input int    InpPmStartMin      = 0;     // Minuto inizio premarket (NY ET 04:00 -> server 09:00)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlLookback      = 5;     // Barre per lo SL strutturale (lowest/highest)
input int    InpSlBufferPts     = 300;   // SL oltre l'estremo strutturale, in PUNTI MT5 (3 pti indice)
input int    InpMinStopPts      = 500;   // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== GESTIONE (parziale su livello + breakeven; runner) ==="
input bool   InpUsePmLevel      = true;  // Parziale al PM high/low (premarket)
input bool   InpUseDayLevel     = true;  // Parziale al max/min del GIORNO PRIMA (D1 shift 1)
input double InpTP1_ClosePct    = 50.0;  // Frazione chiusa al primo livello, % del volume
input bool   InpMoveBE          = true;  // Sposta lo SL a pareggio DOPO il parziale

input group "=== Rischio e cap ==="
input double InpRiskPercent     = 0.65;  // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay = 2;     // Max ingressi ESEGUITI al giorno (0 = illimitato)
input bool   InpAllowLong       = true;  // Ammetti i LONG (i lati si misurano SEPARATI - regola 25/08)
input bool   InpAllowShort      = true;  // Ammetti gli SHORT

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice = 100; // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment         = "NYRT";   // Commento sugli ordini
input long   InpMagic           = 769500;   // Numero magico (verificato VERGINE nel repo)
input int    InpMaxSpread       = 0;        // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose         = true;     // Messaggi nel log
input bool   InpAutoTest        = true;     // Stampa le righe [NYRT][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico (H1)
int      gEmaHandle = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- livelli persistiti all'apertura, per la gestione a tick della posizione
ulong    gPartialTicket = 0;            // ticket gia' parzializzato (una volta sola)
double   gLevPmHigh = 0, gLevPmLow = 0; // premarket high/low al momento dell'ingresso
double   gLevPdh    = 0, gLevPdl    = 0;// max/min del giorno prima al momento dell'ingresso

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE cancello
//    ferma le barre. L'ordine QUI, in OnTester e nell'header di
//    OnTesterDeinit si toccano SEMPRE INSIEME.
long gCntOnNewBar   = 0;
long gCntGestione   = 0;   // c'era posizione aperta (gestita a tick)
long gCntNoContesto = 0;   // contesto (D1/seduta/EMA) non disponibile
long gCntPrimaBarra = 0;   // prima barra / slope non calcolabile
long gCntMaxTrades  = 0;   // cap trade/giorno raggiunto
long gCntFuoriSeduta= 0;   // fuori seduta
long gCntSpread     = 0;   // spread non ok
long gCntNoVwap     = 0;   // VWAP non calcolabile
long gCntRegimeKo   = 0;   // c'era un tocco ma il gate regime ha spento
long gCntTrendKo    = 0;   // c'era un tocco ma il trend EMA200 era opposto
long gCntShortCand  = 0;   // candidati SHORT
long gCntLongCand   = 0;   // candidati LONG
long gCntApri       = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[NYRT] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono: e' questa la parte
//   che l'AUTOTEST interroga a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno.                                    |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| Un istante (in minuti del giorno) e' DENTRO la seduta? [start,end)|
//| La barra che APRE all'ora di fine NON e' in seduta (li' scatta il |
//| flat). Le sedute di casa non attraversano la mezzanotte.          |
//+------------------------------------------------------------------+
bool InSeduta_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);   // difensivo: mai usato di casa
  }

//+------------------------------------------------------------------+
//| Direzione del trend dalla EMA200: +1 sopra, -1 sotto/uguale.      |
//| ema<=0 (dato mancante) -> 0 (nessuna direzione, fail-safe).       |
//+------------------------------------------------------------------+
int TrendDir_Calc(const double px,const double ema)
  {
   if(ema<=0) return(0);
   return(px>ema ? +1 : -1);
  }

//+------------------------------------------------------------------+
//| VWAP di sessione ancorata: sorgente src[] (hlc3), pesi vol[].     |
//| false se non c'e' peso. E' la stessa media pesata che si          |
//| ricostruisce cumulativa dall'apertura di seduta.                  |
//+------------------------------------------------------------------+
bool Vwap_Calc(const double &src[],const double &vol[],const int n,double &vwap)
  {
   vwap=0;
   if(n<1) return(false);
   if(ArraySize(src)<n || ArraySize(vol)<n) return(false);
   double pv=0,vv=0;
   for(int i=0;i<n;i++)
     {
      double w=vol[i]; if(w<=0) w=1.0;   // barra senza tick: peso minimo, mai zero
      pv += src[i]*w; vv += w;
     }
   if(vv<=0) return(false);
   vwap = pv/vv;
   return(true);
  }

//+------------------------------------------------------------------+
//| FILTRO REGIME (costitutivo): passa SOLO se la pendenza VWAP (in    |
//| valore assoluto, gia' convertita in punti indice) e' >= slopeMin  |
//| E l'espansione del range (punti indice) e' >= expMin. Con soglie   |
//| a 0 il gate e' neutro (per l'ablazione con/senza, regola di casa).|
//+------------------------------------------------------------------+
bool RegimeOk_Calc(const double slopeIdxAbs,const double expIdx,
                   const double slopeMin,const double expMin)
  {
   return(slopeIdxAbs>=slopeMin && expIdx>=expMin);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE VWAP-RETEST - il cuore del motore. Valuta la barra      |
//| appena chiusa contro la VWAP ancorata, il trend e il gate regime. |
//| Ritorna +1 = LONG (retest della VWAP dal basso in trend su),      |
//| -1 = SHORT (retest dall'alto in trend giu'), 0 = niente.          |
//|   LONG : low<=vwap+buf && close>vwap && trend>0                   |
//|   SHORT: high>=vwap-buf && close<vwap && trend<0                  |
//| Il gate regime e' COSTITUTIVO: regimeOk false -> 0 comunque.       |
//+------------------------------------------------------------------+
int SegnaleRetest_Calc(
   const double barHigh,const double barLow,const double barClose,
   const double vwap,const bool vwapOk,const double buf,
   const int trendDir,const bool regimeOk,
   const bool allowLong,const bool allowShort)
  {
   if(!vwapOk)   return(0);
   if(!regimeOk) return(0);            // gate costitutivo: niente regime, niente trade
   bool longRt  = (barLow  <= vwap+buf) && (barClose > vwap) && (trendDir>0);
   bool shortRt = (barHigh >= vwap-buf) && (barClose < vwap) && (trendDir<0);
   if(longRt == shortRt) return(0);    // nessuno o (difensivo) ambiguo
   if(longRt  && !allowLong)  return(0);
   if(shortRt && !allowShort) return(0);
   return(longRt ? +1 : -1);
  }

//+------------------------------------------------------------------+
//| SL STRUTTURALE: oltre l'estremo delle ultime N barre, di buffer.  |
//|   long  -> lowestLow  - buffer                                    |
//|   short -> highestHigh + buffer                                   |
//+------------------------------------------------------------------+
double SlStructural_Calc(const bool isLong,const double lowestLow,
                        const double highestHigh,const double buffer)
  {
   return(isLong ? lowestLow-buffer : highestHigh+buffer);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109). Se lo stop e' piu' vicino del        |
//| pavimento, si ALLARGA al pavimento; non si salta il trade e non   |
//| si lascia lo stop a zero. pavimento<=0 -> invariato (ma il         |
//| chiamante garantisce > 0).                                        |
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
//| Marcatore di SESSIONE (le sedute di casa non attraversano la      |
//| mezzanotte). Due barre stanno nella stessa seduta se hanno lo     |
//| stesso marcatore.                                                 |
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t,const int startMinuti)
  {
   long s = (long)t - (long)startMinuti*60;
   if(s<0) s=0;
   return(s/86400);
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
   gTF = (ENUM_TIMEFRAMES)Period();

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- gate direzione: EMA200 su H1 (il trend si legge SEMPRE su H1,
   //    indipendente dal TF del grafico, come request.security nel Pine).
   if(InpEmaTrend<2)
     { Print("ERRORE: InpEmaTrend deve essere >= 2."); return(INIT_FAILED); }
   gEmaHandle = iMA(_Symbol, PERIOD_H1, InpEmaTrend, 0, MODE_EMA, PRICE_CLOSE);
   if(gEmaHandle==INVALID_HANDLE)
     { Print("ERRORE: impossibile creare l'handle EMA di trend su H1."); return(INIT_FAILED); }

   if(InpRetestBufferPts<0)
     { Print("ERRORE: InpRetestBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpVwapSlopeMin<0 || InpExpansionMin<0)
     { Print("ERRORE: le soglie del gate regime non possono essere negative."); return(INIT_FAILED); }
   if(InpVwapSlopePeriod<1)
     { Print("ERRORE: InpVwapSlopePeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpExpansionLookback<1)
     { Print("ERRORE: InpExpansionLookback deve essere >= 1."); return(INIT_FAILED); }
   if(InpSessionHour<0 || InpSessionHour>23 || InpSessionMin<0 || InpSessionMin>59)
     { Print("ERRORE: ora/minuto di apertura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin) >= MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin))
     { Print("ERRORE: la seduta di casa NON attraversa la mezzanotte: apertura deve precedere il flat."); return(INIT_FAILED); }
   if(InpPmStartHour<0 || InpPmStartHour>23 || InpPmStartMin<0 || InpPmStartMin>59)
     { Print("ERRORE: ora/minuto premarket fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpPmStartHour,InpPmStartMin) >= MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin))
     { Print("ERRORE: il premarket deve precedere l'apertura di seduta."); return(INIT_FAILED); }
   if(InpSlLookback<1)
     { Print("ERRORE: InpSlLookback deve essere >= 1."); return(INIT_FAILED); }
   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. Load-bearing.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpTP1_ClosePct<0 || InpTP1_ClosePct>100)
     { Print("ERRORE: InpTP1_ClosePct deve essere tra 0 e 100."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }
   if(!InpCloseAtEnd)
      Print("[NYRT] ATTENZIONE: InpCloseAtEnd=false -> nessun flat forzato di fine seduta. Il mandato vieta l'overnight: usare solo per misura, non in reale.");

   if(InpAutoTest) AutoTestRetest();

   Log(StringFormat("avviato su %s %s. EMA trend %d (H1), retest buf %d pti MT5, regime[slope>=%.2f/%dbarre, exp>=%.2f/%dbarre pti idx], seduta %02d:%02d-%02d:%02d server, PM da %02d:%02d, SL %d barre+%d buf + pavimento %d pti MT5, rischio %.2f%%, cap %d/gg, magic %I64d.",
       _Symbol, EnumToString(gTF), InpEmaTrend, InpRetestBufferPts,
       InpVwapSlopeMin, InpVwapSlopePeriod, InpExpansionMin, InpExpansionLookback,
       InpSessionHour, InpSessionMin, InpCloseHour, InpCloseMin,
       InpPmStartHour, InpPmStartMin,
       InpSlLookback, InpSlBufferPts, InpMinStopPts, InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO: motore INTRADAY di continuazione, niente overnight. Ingresso SINGOLO: nessuna aggiunta/mediazione/griglia su posizione aperta.");
   Log("GATE REGIME COSTITUTIVO: senza pendenza VWAP + espansione, NIENTE trade (mettere le soglie a 0 solo per l'ablazione con/senza).");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gEmaHandle!=INVALID_HANDLE){ IndicatorRelease(gEmaHandle); gEmaHandle=INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

   //--- gestione della posizione aperta (parziale + breakeven) a tick;
   //    quando non c'e' nulla di aperto azzero lo stato del parziale.
   if(CountPositions()>0) ManageOpenPosition();
   else                   { gPartialTicket=0; }

   if(FlatFineSedutaCheck()) return;   // fine seduta: chiudo tutto e non riapro

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//==================================================================
//  IL CONTESTO - tutto cio' che serve alla decisione, letto dai dati
//  e SENZA stato persistente (sopravvive a un riavvio).
//==================================================================
struct Contesto
  {
   double  pdh, pdl;          // max/min del giorno PRIMA (D1 shift 1)
   double  sessOpen;          // apertura della seduta corrente
   double  vwap;              // VWAP ancorata fino alla barra valutata
   bool    vwapOk;
   double  vwapSlopeRef;      // VWAP ancorata InpVwapSlopePeriod barre prima
   bool    vwapSlopeOk;       // riferimento di pendenza disponibile (in seduta)
   double  expRange;          // espansione: highest-lowest su InpExpansionLookback barre
   double  slLow, slHigh;     // lowest/highest su InpSlLookback barre (SL strutturale)
   double  pmHigh, pmLow;     // premarket high/low della giornata (0 = assente)
   int     pos;               // posizione della barra nella seduta (0 = prima)
  };

//+------------------------------------------------------------------+
//| Legge i livelli del giorno prima dal timeframe D1.                |
//+------------------------------------------------------------------+
bool LeggiD1(Contesto &c)
  {
   MqlRates d[]; ArraySetAsSeries(d,true);
   int copied = CopyRates(_Symbol, PERIOD_D1, 0, 3, d);
   if(copied < 2) return(false);          // serve almeno il giorno prima
   c.pdh = d[1].high;                      // max del giorno prima
   c.pdl = d[1].low;                       // min del giorno prima
   return(true);
  }

//+------------------------------------------------------------------+
//| EMA200 di trend su H1 allo shift indicato (shift in barre H1).    |
//+------------------------------------------------------------------+
bool EmaTrendAt(const int shift, double &val)
  {
   double b[];
   if(CopyBuffer(gEmaHandle, 0, shift, 1, b) < 1) return(false);
   val = b[0];
   return(val>0);
  }

//+------------------------------------------------------------------+
//| Ricostruisce la seduta corrente per la barra a shiftEval:         |
//| apertura, VWAP ancorata (e il suo riferimento di pendenza),       |
//| espansione, SL strutturale, livelli premarket, posizione.         |
//+------------------------------------------------------------------+
bool LeggiSeduta(const int shiftEval, Contesto &c)
  {
   if(shiftEval<1) return(false);
   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 3*BarrePerGiornoPieno() + shiftEval
              + InpExpansionLookback + InpVwapSlopePeriod + InpSlLookback + 10;
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<=shiftEval+1) return(false);
   if(!BarraInSeduta(r[shiftEval].time)) return(false);

   int  startMin = MinutiStartSeduta();
   long stamp    = SessionStamp_Calc(r[shiftEval].time, startMin);

   //--- prima barra della seduta: il piu' VECCHIO shift con lo stesso
   //    stamp, contiguo verso shiftEval.
   int firstShift = shiftEval;
   for(int i=shiftEval+1;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=stamp) break;
      firstShift = i;
     }
   c.pos = firstShift - shiftEval;          // 0 = prima barra della seduta
   c.sessOpen = r[firstShift].open;

   //--- VWAP ANCORATA all'apertura di seduta: cumulativa dalla prima barra
   //    (firstShift, la piu' vecchia) fino a shiftEval (la valutata),
   //    sorgente hlc3, pesi tick volume. Registro il valore alla barra
   //    valutata e a InpVwapSlopePeriod barre prima (per la pendenza),
   //    entrambe ANCORATE allo stesso inizio seduta.
   int shiftSlopeRef = shiftEval + InpVwapSlopePeriod;
   double pv=0, vv=0;
   c.vwap=0; c.vwapOk=false; c.vwapSlopeRef=0; c.vwapSlopeOk=false;
   for(int i=firstShift; i>=shiftEval; i--)
     {
      double hlc3=(r[i].high + r[i].low + r[i].close)/3.0;
      double w=(double)r[i].tick_volume; if(w<=0) w=1.0;
      pv += hlc3*w; vv += w;
      double vw = (vv>0 ? pv/vv : 0);
      if(i==shiftSlopeRef){ c.vwapSlopeRef=vw; c.vwapSlopeOk=true; }
      if(i==shiftEval)    { c.vwap=vw;         c.vwapOk=(vv>0);   }
     }

   //--- ESPANSIONE: highest high - lowest low su InpExpansionLookback barre
   //    a partire dalla barra valutata (finestra mobile, come il sorgente).
   double hi=-DBL_MAX, lo=DBL_MAX;
   for(int i=shiftEval; i<shiftEval+InpExpansionLookback && i<copied; i++)
     { if(r[i].high>hi) hi=r[i].high; if(r[i].low<lo) lo=r[i].low; }
   c.expRange = (hi>-DBL_MAX && lo<DBL_MAX) ? (hi-lo) : 0.0;

   //--- SL STRUTTURALE: lowest/highest su InpSlLookback barre dalla valutata.
   double slLo=DBL_MAX, slHi=-DBL_MAX;
   for(int i=shiftEval; i<shiftEval+InpSlLookback && i<copied; i++)
     { if(r[i].low<slLo) slLo=r[i].low; if(r[i].high>slHi) slHi=r[i].high; }
   c.slLow  = (slLo<DBL_MAX ? slLo : r[shiftEval].low);
   c.slHigh = (slHi>-DBL_MAX ? slHi : r[shiftEval].high);

   //--- PREMARKET high/low della giornata: barre PIU' VECCHIE della prima
   //    di seduta, stesso giorno di calendario, minuti in [pmStart, sessStart).
   c.pmHigh=0; c.pmLow=0;
   double ph=-DBL_MAX, pl=DBL_MAX;
   MqlDateTime sd; TimeToStruct(r[firstShift].time, sd);
   int pmStartMin  = MinutiDelGiorno_Calc(InpPmStartHour,InpPmStartMin);
   int sessStartMin= startMin;
   for(int i=firstShift+1;i<copied;i++)
     {
      MqlDateTime bd; TimeToStruct(r[i].time,bd);
      if(bd.day!=sd.day || bd.mon!=sd.mon || bd.year!=sd.year) break;  // giorno precedente: stop
      int m=MinutiDelGiorno_Calc(bd.hour,bd.min);
      if(m>=pmStartMin && m<sessStartMin)
        { if(r[i].high>ph) ph=r[i].high; if(r[i].low<pl) pl=r[i].low; }
     }
   if(ph>-DBL_MAX && pl<DBL_MAX){ c.pmHigh=ph; c.pmLow=pl; }

   return(true);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valuta la barra APPENA CHIUSA      |
//| (shift 1); l'ordine parte al mercato all'apertura della barra 0.  |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   if(CountPositions()>0){ gCntGestione++; return; }   // una posizione per magic

   Contesto c;
   bool okD1  = LeggiD1(c);
   bool okSes = LeggiSeduta(1, c);
   double ema = 0;
   bool okEma = EmaTrendAt(1, ema);

   if(!okD1 || !okSes || !okEma){ gCntNoContesto++; return; }
   if(c.pos <= 0){ gCntPrimaBarra++; return; }           // prima barra di seduta: mai ingresso
   if(!c.vwapSlopeOk){ gCntPrimaBarra++; return; }        // seduta troppo giovane per la pendenza
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!InSedutaOra(TimeCurrent())){ gCntFuoriSeduta++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }
   if(!c.vwapOk){ gCntNoVwap++; return; }

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0){ gCntNoContesto++; return; }

   double buf = InpRetestBufferPts*_Point;
   int trendDir = TrendDir_Calc(barClose, ema);

   //--- gate regime (costitutivo): pendenza VWAP e espansione, in punti idx.
   double slopeIdx = PrezzoInPuntiIndice_Calc(MathAbs(c.vwap - c.vwapSlopeRef), InpMT5PerPuntoIndice, _Point);
   double expIdx   = PrezzoInPuntiIndice_Calc(c.expRange, InpMT5PerPuntoIndice, _Point);
   bool regimeOk   = RegimeOk_Calc(slopeIdx, expIdx, InpVwapSlopeMin, InpExpansionMin);

   //--- DIAGNOSTICA: c'era un tocco della VWAP? (indipende dal trend/regime)
   bool longTouch  = (barLow  <= c.vwap+buf) && (barClose > c.vwap);
   bool shortTouch = (barHigh >= c.vwap-buf) && (barClose < c.vwap);
   if(longTouch || shortTouch)
     {
      if(!regimeOk) gCntRegimeKo++;
      else if((longTouch && trendDir<=0) || (shortTouch && trendDir>=0)) gCntTrendKo++;
     }

   int sig = SegnaleRetest_Calc(
      barHigh, barLow, barClose,
      c.vwap, c.vwapOk, buf,
      trendDir, regimeOk,
      InpAllowLong, InpAllowShort);
   if(sig==0) return;

   bool isLong = (sig>0);
   if(isLong) gCntLongCand++; else gCntShortCand++;

   gCntApri++;
   ApriPosizione(isLong, c);
  }

//==================================================================
//  LETTURA DEI DATI (aiutanti di sessione)
//==================================================================
int MinutiStartSeduta(){ return(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin)); }
int MinutiEndSeduta()  { return(MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin)); }

bool BarraInSeduta(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return(InSeduta_Calc(MinutiDelGiorno_Calc(d.hour,d.min), MinutiStartSeduta(), MinutiEndSeduta()));
  }
bool InSedutaOra(const datetime t){ return(BarraInSeduta(t)); }

//--- barre di un GIORNO PIENO di calendario (~24h / TF): dimensiona la
//    copia storica (CopyRates conta barre CONSECUTIVE sul CALENDARIO).
int BarrePerGiornoPieno()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=3600;
   int b = (int)(86400/per);
   return(b<10?10:b);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS vero al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL STRUTTURALE (lowest/highest N     |
//| barre +/- buffer), poi SEMPRE dal PAVIMENTO (mai a zero, mai       |
//| dentro lo stops-level). Nessun TP fisso: la gestione fa il         |
//| parziale sul livello e il resto CORRE fino allo stop o al flat.    |
//| Il lotto esce da LotByRisk sulla distanza FINALE dello stop.       |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong, const Contesto &c)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlStructural_Calc(isLong, c.slLow, c.slHigh, bufferPrezzo);

   //--- PAVIMENTO OBBLIGATORIO (R109): la distanza non e' mai piu' stretta
   //    del pavimento in punti MT5, e mai dentro lo stops-level del broker.
   double pavimento = InpMinStopPts*_Point;
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo: salto per non lasciare lo stop scoperto (R109)."); return(false); }

   double sl = PavimentoSL_Calc(isLong, ref, slRaw, pavFinale);
   sl = NormalizePrice(sl);
   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,0.0,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,0.0,cm);
   if(ok)
     {
      //--- persisto i livelli per la gestione a tick del parziale.
      gPartialTicket = 0;
      gLevPmHigh = c.pmHigh; gLevPmLow = c.pmLow;
      gLevPdh    = c.pdh;    gLevPdl   = c.pdl;

      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s lot %.2f (rischio %.1f pti idx | VWAP %s, PMh %s PMl %s, PDh %s PDl %s)",
          isLong?"BUY(retest VWAP dal basso)":"SELL(retest VWAP dall'alto)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits), lot, idxRisk,
          DoubleToString(c.vwap,_Digits),
          DoubleToString(c.pmHigh,_Digits), DoubleToString(c.pmLow,_Digits),
          DoubleToString(c.pdh,_Digits), DoubleToString(c.pdl,_Digits)));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE - parziale sul primo livello + breakeven
//==================================================================
//+------------------------------------------------------------------+
//| Chiamata a OGNI tick quando c'e' una posizione aperta. Al primo    |
//| livello favorevole raggiunto (PM high/low o max/min del giorno     |
//| prima) chiude InpTP1_ClosePct% del volume e, se InpMoveBE, porta   |
//| lo SL a pareggio. UNA VOLTA SOLA per posizione (gPartialTicket).   |
//| Il resto CORRE: lo SL vero al broker protegge, il flat chiude a    |
//| fine seduta. Nessuna aggiunta su posizione aperta.                |
//+------------------------------------------------------------------+
void ManageOpenPosition()
  {
   ulong  tk=0; double vol=0; bool isLong=false;
   double entry=0, sl=0, tp=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong t=PositionGetTicket(i);
      if(t==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      tk=t;
      vol   = PositionGetDouble(POSITION_VOLUME);
      isLong= (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      entry = PositionGetDouble(POSITION_PRICE_OPEN);
      sl    = PositionGetDouble(POSITION_SL);
      tp    = PositionGetDouble(POSITION_TP);
      break;
     }
   if(tk==0) return;
   if(tk==gPartialTicket) return;                 // parziale gia' fatto su questo ticket
   if(InpTP1_ClosePct<=0) return;                 // parziale disabilitato

   //--- primo livello FAVOREVOLE: il piu' vicino tra PM e giorno prima.
   double target=0; bool haveTarget=false;
   if(isLong)
     {
      if(InpUsePmLevel  && gLevPmHigh>entry)                              { target=gLevPmHigh; haveTarget=true; }
      if(InpUseDayLevel && gLevPdh>entry && (!haveTarget || gLevPdh<target)){ target=gLevPdh;   haveTarget=true; }
     }
   else
     {
      if(InpUsePmLevel  && gLevPmLow>0 && gLevPmLow<entry)                              { target=gLevPmLow; haveTarget=true; }
      if(InpUseDayLevel && gLevPdl>0 && gLevPdl<entry && (!haveTarget || gLevPdl>target)){ target=gLevPdl;  haveTarget=true; }
     }
   if(!haveTarget) return;

   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double px = isLong ? bid : ask;
   bool reached = isLong ? (px>=target) : (px<=target);
   if(!reached) return;

   //--- chiudo la frazione, se resta un runner valido sopra il minimo lotto.
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double closeVol = FloorVolume(vol*InpTP1_ClosePct/100.0);
   if(closeVol>=mn && (vol-closeVol)>=mn)
     {
      if(gTrade.PositionClosePartial(tk, closeVol))
         Log(StringFormat("parziale %.0f%% (%.2f lotti) al livello %s.",
                          InpTP1_ClosePct, closeVol, DoubleToString(target,_Digits)));
      else
         Log("parziale FALLITO: "+gTrade.ResultRetcodeDescription());
     }

   //--- breakeven dopo il parziale (rispettando lo stops-level del broker).
   if(InpMoveBE)
     {
      double minBroker=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
      double newSL = entry;
      double dist  = isLong ? (px-newSL) : (newSL-px);
      if(dist < minBroker) newSL = isLong ? px-minBroker : px+minBroker;
      newSL = NormalizePrice(newSL);
      //--- muovo lo SL solo se e' un miglioramento (a favore) o al pareggio.
      bool migliora = isLong ? (newSL>sl) : (newSL<sl || sl==0.0);
      if(migliora)
        {
         if(gTrade.PositionModify(tk, newSL, tp)) Log("SL portato a pareggio dopo il parziale.");
         else Log("breakeven FALLITO: "+gTrade.ResultRetcodeDescription());
        }
     }

   gPartialTicket = tk;                           // una volta sola per posizione
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpCloseHour,InpCloseMin)) return(false);

   //--- oltre l'orario di fine: niente nuovi ingressi. Se InpCloseAtEnd,
   //    chiudo tutto (mai overnight). In ogni caso ritorno true per fermare
   //    la logica di nuova barra.
   if(!InpCloseAtEnd) return(true);

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
                          InpCloseHour, InpCloseMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il cap giornaliero conta gli ingressi ESEGUITI, non gli ordini.   |
//+------------------------------------------------------------------+
void AggiornaContatoreTrade()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(tk!=gUltimoTicketContato)
        { gUltimoTicketContato=tk; gTradesToday++; }
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

//--- volume floored allo step (senza forzarlo al minimo: il chiamante
//    verifica il minimo e che resti un runner valido).
double FloorVolume(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   if(v<0) v=0;
   return(MathFloor(v/st)*st);
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
void AutoTestRetest()
  {
   int falliti=0;

   PrintFormat("[NYRT][AUTOTEST] EMA %d | regime slope>=%.2f exp>=%.2f | %s | magic %I64d",
               InpEmaTrend, InpVwapSlopeMin, InpExpansionMin, _Symbol, InpMagic);

   //--- 1. TREND DIR (px vs ema; ema<=0 -> 0)
   int td1=TrendDir_Calc(105.0,100.0);   // sopra -> +1
   int td2=TrendDir_Calc( 95.0,100.0);   // sotto -> -1
   int td3=TrendDir_Calc(100.0,100.0);   // uguale -> -1 (fedele al sorgente)
   int td4=TrendDir_Calc(105.0,  0.0);   // niente ema -> 0
   PrintFormat("[NYRT][AUTOTEST] trend: sopra=%d(1) sotto=%d(-1) uguale=%d(-1) noEma=%d(0)", td1,td2,td3,td4);
   if(!(td1==1 && td2==-1 && td3==-1 && td4==0)) falliti++;

   //--- 2. REGIME (slope e espansione >= soglie ; 0/0 -> sempre vero)
   bool rg1=RegimeOk_Calc(3.0,20.0,2.0,10.0);   // entrambi sopra -> vero
   bool rg2=RegimeOk_Calc(1.0,20.0,2.0,10.0);   // slope sotto -> falso
   bool rg3=RegimeOk_Calc(3.0, 5.0,2.0,10.0);   // exp sotto -> falso
   bool rg4=RegimeOk_Calc(0.0, 0.0,0.0, 0.0);   // soglie neutre -> vero
   PrintFormat("[NYRT][AUTOTEST] regime: ok=%d(1) slopeKo=%d(0) expKo=%d(0) neutro=%d(1)",
               (int)rg1,(int)rg2,(int)rg3,(int)rg4);
   if(!(rg1 && !rg2 && !rg3 && rg4)) falliti++;

   //--- 3. IL SEGNALE VWAP-RETEST (cuore). vwap 100, buf 0.
   double VW=100.0, BUF=0.0;
   //    long: low 99.5<=100, close 100.5>100, trend +1 -> +1
   int s1=SegnaleRetest_Calc(101, 99.5,100.5, VW,true,BUF, +1,true, true,true);
   //    short: high 100.5>=100, close 99.5<100, trend -1 -> -1
   int s2=SegnaleRetest_Calc(100.5,99,99.5,   VW,true,BUF, -1,true, true,true);
   //    tocco long ma trend -1 -> 0
   int s3=SegnaleRetest_Calc(101, 99.5,100.5, VW,true,BUF, -1,true, true,true);
   //    tocco long ma regime off -> 0 (gate costitutivo)
   int s4=SegnaleRetest_Calc(101, 99.5,100.5, VW,true,BUF, +1,false, true,true);
   //    close NON richiude sopra (close 99.8<100) -> 0
   int s5=SegnaleRetest_Calc(101, 99.5, 99.8, VW,true,BUF, +1,true, true,true);
   //    vwap non valido -> 0
   int s6=SegnaleRetest_Calc(101, 99.5,100.5, VW,false,BUF,+1,true, true,true);
   //    long valido ma AllowLong off -> 0
   int s7=SegnaleRetest_Calc(101, 99.5,100.5, VW,true,BUF, +1,true, false,true);
   //    short valido con AllowShort off -> 0
   int s8=SegnaleRetest_Calc(100.5,99,99.5,   VW,true,BUF, -1,true, true,false);
   PrintFormat("[NYRT][AUTOTEST] segnale: long=%d(1) short=%d(-1) trendKo=%d(0) regKo=%d(0) noRichiude=%d(0) noVwap=%d(0) longOff=%d(0) shortOff=%d(0)",
               s1,s2,s3,s4,s5,s6,s7,s8);
   if(!(s1==1 && s2==-1 && s3==0 && s4==0 && s5==0 && s6==0 && s7==0 && s8==0)) falliti++;

   //--- 4. SL STRUTTURALE + PAVIMENTO (mai a zero: R109)
   double sl_l=SlStructural_Calc(true , 99.0,105.0,0.5);   // long -> 98.5
   double sl_s=SlStructural_Calc(false, 99.0,105.0,0.5);   // short -> 105.5
   double p1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double p2=PavimentoSL_Calc(true ,100.0, 97.0,2.0);  // gia' oltre -> 97.00
   double p3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short -> 102.00
   PrintFormat("[NYRT][AUTOTEST] SL: long=%.2f(98.50) short=%.2f(105.50) | pav %.2f(98.00) %.2f(97.00) short %.2f(102.00)",
               sl_l,sl_s,p1,p2,p3);
   if(!(MathAbs(sl_l-98.5)<1e-6 && MathAbs(sl_s-105.5)<1e-6 &&
        MathAbs(p1-98.0)<1e-6 && MathAbs(p2-97.0)<1e-6 && MathAbs(p3-102.0)<1e-6)) falliti++;

   //--- 5. VWAP (pesata sul volume, sorgente hlc3 passata in src[])
   double sv[2]; sv[0]=10.0; sv[1]=20.0;
   double wv[2]; wv[0]= 1.0; wv[1]= 1.0;
   double vw1=0; bool rv1=Vwap_Calc(sv,wv,2,vw1);         // 15
   double wp[2]; wp[0]= 1.0; wp[1]= 3.0;
   double vw2=0; bool rv2=Vwap_Calc(sv,wp,2,vw2);         // 17.5
   double vw3=0; bool rv3=Vwap_Calc(sv,wv,0,vw3);         // n=0 -> false
   PrintFormat("[NYRT][AUTOTEST] vwap: %.4f(15.0000) pesata %.4f(17.5000) n0 ok=%d(0)",
               vw1,vw2,(int)rv3);
   if(!(rv1 && rv2 && !rv3 && MathAbs(vw1-15.0)<1e-6 && MathAbs(vw2-17.5)<1e-6)) falliti++;

   //--- 6. SEDUTA / STAMP / FLAT / conversione punti (server 14:30-20:55)
   int mS=MinutiDelGiorno_Calc(14,30), mE=MinutiDelGiorno_Calc(20,55);
   bool se1=InSeduta_Calc(MinutiDelGiorno_Calc(14,30),mS,mE);  // apertura inclusa
   bool se2=InSeduta_Calc(MinutiDelGiorno_Calc(17, 0),mS,mE);  // dentro
   bool se3=InSeduta_Calc(MinutiDelGiorno_Calc(20,55),mS,mE);  // chiusura esclusa
   bool se4=InSeduta_Calc(MinutiDelGiorno_Calc(14,15),mS,mE);  // prima dell'apertura
   bool fl1=DopoOrarioFlat_Calc(20,55,20,55);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(20,54,20,55);   // prima -> no
   datetime tA=D'2026.08.25 15:00:00';
   datetime tB=D'2026.08.25 20:00:00';
   datetime tC=D'2026.08.26 15:00:00';
   bool sm1=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tB,mS));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tC,mS));  // diverse
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   PrintFormat("[NYRT][AUTOTEST] seduta: apert=%d(1) dentro=%d(1) fine=%d(0) pre=%d(0) | flat esatto=%d(1) prima=%d(0) | stamp same=%d(1) diff=%d(0) | conv=%.2f(5.00)",
               (int)se1,(int)se2,(int)se3,(int)se4,(int)fl1,(int)fl2,(int)sm1,(int)sm2,ip1);
   if(!(se1 && se2 && !se3 && !se4 && fl1 && !fl2 && sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[NYRT][AUTOTEST] esito motore: ", (falliti==0
         ? "SEI BLOCCHI SU SEI, il motore ragiona come il sorgente."
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
//| EXPORT PER-TRADE per il PASSO 0 in Common\Files. Ogni riga = una  |
//| posizione CHIUSA, con PREZZO D'INGRESSO E DI USCITA, per calcolare |
//| la mediana del take in PUNTI INDICE prima di leggere qualunque PF. |
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
   double stats[26];
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
   stats[15] = (double)gCntNoContesto;     // Ret No Contesto
   stats[16] = (double)gCntPrimaBarra;     // Ret Prima Barra
   stats[17] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[18] = (double)gCntFuoriSeduta;    // Ret Fuori Seduta
   stats[19] = (double)gCntSpread;         // Ret Spread
   stats[20] = (double)gCntNoVwap;         // No Vwap
   stats[21] = (double)gCntRegimeKo;       // Regime Ko
   stats[22] = (double)gCntTrendKo;        // Trend Ko
   stats[23] = (double)gCntShortCand;      // Short Cand
   stats[24] = (double)gCntLongCand;       // Long Cand
   stats[25] = (double)gCntApri;           // Apri Chiamate

   PrintFormat("[NYRT][DIAG] OnNewBar=%I64d | ret: gestione=%I64d noContesto=%I64d primaBarra=%I64d maxTrades=%I64d fuoriSeduta=%I64d spread=%I64d | noVwap=%I64d regimeKo=%I64d trendKo=%I64d | shortCand=%I64d longCand=%I64d apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoContesto, gCntPrimaBarra,
               gCntMaxTrades, gCntFuoriSeduta, gCntSpread, gCntNoVwap,
               gCntRegimeKo, gCntTrendKo, gCntShortCand, gCntLongCand, gCntApri);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret No Contesto,Ret Prima Barra,Ret Max Trades,Ret Fuori Seduta,Ret Spread,No Vwap,Regime Ko,Trend Ko,Short Cand,Long Cand,Apri Chiamate";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 27 campi fissi: %d (Pass) + 26 %f (data[0..25]). Contati il 31/08:
      //    prima c'erano 25 %f e data[25] (Apri Chiamate) cadeva in silenzio,
      //    sfasando di uno TUTTE le colonne dei parametri appese in coda.
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22],
                                data[23], data[24], data[25]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
