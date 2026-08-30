//+------------------------------------------------------------------+
//|                                        ABTG_DaxReEntry.mq5        |
//|                                                                  |
//|  MOTORE DAX RE-ENTRY (sweep + reclaim del range mattutino) -     |
//|  MT5 - TUTTO-IN-UNO (metti in MQL5\Experts e compila con F7).    |
//|                                                                  |
//|  ATTRIBUZIONE OBBLIGATORIA:                                      |
//|    Meccanica da DAX ReEntry Signals (KepiroG, TradingView),      |
//|    reimplementata. Licenza fonte non dichiarata: attribuzione    |
//|    obbligatoria.                                                 |
//|    L'originale e' un INDICATORE (solo segnali): la GESTIONE       |
//|    (SL vero, sizing a rischio, cap, flat, export) la mettiamo    |
//|    noi con l'infrastruttura prop-hardening di casa.              |
//|                                                                  |
//|  COS'E' - un motore INTRADAY d'inversione sul range europeo di   |
//|    apertura. Costruisce il range del mattino (max/min tra        |
//|    InpRangeStart e InpRangeEnd), poi nella fascia di trading      |
//|    entra sulla FALSA ROTTURA rientrata (sweep + reclaim):        |
//|      LONG  = il prezzo rompe SOTTO il minimo del range di almeno |
//|              InpBreakPts, poi una barra CHIUDE sopra il minimo    |
//|              (reclaim confermato). TP = massimo del range.        |
//|      SHORT = specchiato sul massimo del range. TP = minimo.       |
//|    UN SOLO segnale per LATO per giorno. Simmetrico (regola di    |
//|    casa 25/08: si misurano SEMPRE tutti e due i lati).           |
//|                                                                  |
//|  PROP-HARDENING (identico allo scaffold ABTG_InvEsaurimento):    |
//|    - STOP LOSS VERO AL BROKER + PAVIMENTO SL OBBLIGATORIO (R109): |
//|      InpMinStopPts, MAI zero -> OnInit RIFIUTA se e' 0.          |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa.        |
//|    - INGRESSO SINGOLO, una posizione per magic. NIENTE           |
//|      martingala/griglia/recovery/DCA/averaging/virtual-stop:     |
//|      nessuna aggiunta su posizione aperta.                       |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                       |
//|    - FLAT OBBLIGATORIO a fine seduta (ora SERVER): mai overnight.|
//|    - EXPORT PER-TRADE CSV + OnTester (recovery) + OPTFRAME.      |
//|      AUTOTEST del nucleo in avvio.                               |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. L'originale KepiroG lavora in ora        |
//|    FRANCOFORTE/CET. Su BCM il server e' 1 ORA INDIETRO rispetto  |
//|    all'ora italiana/CET (regola fissa CLAUDE.md: DAX apre        |
//|    09:00 IT = 08:00 SERVER). Tutti gli orari sono INPUT con      |
//|    default GIA' CONVERTITI IN ORA SERVER (CET -> server -1h).    |
//|    Tutti i confronti temporali usano l'ora del feed (server).   |
//|                                                                  |
//|  CONVERSIONE PUNTI: su DAX (D30EUR) 1 punto indice = 100 punti   |
//|    MT5 (_Point). Le distanze in PUNTI INDICE (InpBreakPts) si    |
//|    convertono in prezzo con InpMT5PerPuntoIndice; InpMinStopPts  |
//|    resta in PUNTI MT5 (default 500 = 5 punti indice).           |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il segnale si valuta sulla barra    |
//|    appena chiusa (shift 1) e l'ordine parte all'apertura della   |
//|    barra 0. Niente look-ahead, niente repaint.                  |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola   |
//|    di casa). NON compilato ne' testato da chi ha scritto il      |
//|    file: compilare in MetaEditor (F7) e validare nel tester.    |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - DAX ReEntry (meccanica da KepiroG, TradingView, reimplementata)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== SEGNALE (sweep + reclaim del range mattutino) ==="
input double InpBreakPts     = 20.0;  // Sweep minimo oltre il range, in PUNTI INDICE (DAX)
input double InpSlFracRange   = 0.454; // SL = estremo del range +/- (range * questa frazione)
input int    InpSide          = 2;     // Lato: 0=solo LONG, 1=solo SHORT, 2=entrambi (default: entrambi)

input group "=== RANGE MATTUTINO (ora SERVER; CET -> server -1h) ==="
input int    InpRangeStartHour= 8;     // Inizio costruzione range (09:35 CET -> 08:35 server)
input int    InpRangeStartMin = 35;    // (min)
input int    InpRangeEndHour  = 11;    // Fine costruzione range (12:05 CET -> 11:05 server)
input int    InpRangeEndMin   = 5;     // (min)

input group "=== FASCIA DI TRADING (ora SERVER; CET -> server -1h) ==="
input int    InpTradeStartHour= 11;    // Inizio fascia di trading (12:05 CET -> 11:05 server)
input int    InpTradeStartMin = 5;     // (min)
input int    InpTradeEndHour  = 14;    // Fine fascia di trading (15:15 CET -> 14:15 server)
input int    InpTradeEndMin   = 15;    // (min)

input group "=== FLAT DI FINE SEDUTA (ora SERVER; CET -> server -1h) ==="
input int    InpCloseHour     = 16;    // Ora del FLAT: chiusura cash EU ~17:30 CET -> 16:30 server
input int    InpCloseMin      = 30;    // Minuto del FLAT (mai overnight)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpMinStopPts    = 500;   // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== Rischio e cap ==="
input double InpRiskPercent   = 0.65;  // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay= 2;    // Max ingressi ESEGUITI al giorno (0=illimitato; logica 1/lato/gg)

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice= 100; // Punti MT5 (_Point) per 1 punto indice (DAX D30EUR: 100)

input group "=== Generali ==="
input string InpComment       = "REENT"; // Commento sugli ordini
input long   InpMagic         = 769300;  // Numero magico (blocco 7693xx: verificato LIBERO nel repo)
input int    InpMaxSpread     = 0;       // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose       = true;    // Messaggi nel log
input bool   InpAutoTest      = true;    // Stampa le righe [REENT][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- stato del GIORNO (range + sweep + un segnale per lato). Ricostruito
//    dai dati a ogni cambio giorno: nessuno stato che sopravvive male a
//    un riavvio (il range si ricalcola da CostruisciRange).
int      gStateDay   = -1;
bool     gRangeReady = false;
double   gLastHigh   = 0.0;
double   gLastLow    = 0.0;
double   gRange      = 0.0;
bool     gSweptBelow = false;   // il prezzo ha rotto SOTTO il minimo di InpBreakPts
bool     gSweptAbove = false;   // il prezzo ha rotto SOPRA il massimo di InpBreakPts
bool     gLongDone   = false;   // segnale LONG gia' emesso oggi
bool     gShortDone  = false;   // segnale SHORT gia' emesso oggi

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA, nessun cambio di logica): un contatore
//    per ogni punto di uscita/blocco di OnNewBar. Escono IN COLONNA
//    nell'OPTFRAME per capire QUALE cancello ferma le barre.
long gCntOnNewBar    = 0;   // chiamate totali a OnNewBar
long gCntGestione    = 0;   // return: c'era posizione aperta (una per magic)
long gCntFuoriFascia = 0;   // return: fuori dalla fascia di trading
long gCntNoRange     = 0;   // return: range non pronto / non valido
long gCntMaxTrades   = 0;   // return: cap trade/giorno raggiunto
long gCntSpread      = 0;   // return: spread non ok
long gCntSweepBelow  = 0;   // sweep sotto il minimo armato (nuovo)
long gCntSweepAbove  = 0;   // sweep sopra il massimo armato (nuovo)
long gCntLongCand    = 0;   // candidati LONG (reclaim confermato)
long gCntShortCand   = 0;   // candidati SHORT (reclaim confermato)
long gCntApri        = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[REENT] ", m); }

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
//| Un istante (in minuti del giorno) e' DENTRO una fascia [start,end)|
//| L'istante che coincide con 'end' NON e' dentro. Le fasce di casa |
//| non attraversano la mezzanotte.                                   |
//+------------------------------------------------------------------+
bool InFascia_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);   // difensivo: mai usato di casa
  }

//+------------------------------------------------------------------+
//| Il range e' valido se ha un'ampiezza positiva.                    |
//+------------------------------------------------------------------+
bool RangeValido_Calc(const double lastHigh,const double lastLow)
  {
   return(lastHigh>lastLow);
  }

//+------------------------------------------------------------------+
//| AGGIORNA I FLAG DI SWEEP (falsa rottura del range).               |
//| sweptBelow diventa vero quando il minimo della barra scende sotto |
//| lastLow di almeno breakDist; sweptAbove specularmente sul massimo.|
//| I flag ACCUMULANO (non si resettano da soli): una volta armato lo |
//| sweep, si aspetta il reclaim. breakDist<0 -> nessun aggiornamento.|
//+------------------------------------------------------------------+
void AggiornaSweep_Calc(const double barLow,const double barHigh,
                        const double lastLow,const double lastHigh,
                        const double breakDist,
                        bool &sweptBelow,bool &sweptAbove)
  {
   if(breakDist<0) return;
   if(barLow  <= lastLow  - breakDist) sweptBelow = true;
   if(barHigh >= lastHigh + breakDist) sweptAbove = true;
  }

//+------------------------------------------------------------------+
//| RECLAIM LONG: dopo uno sweep SOTTO, una barra CHIUDE sopra il     |
//| minimo del range -> falsa rottura ribassista rientrata -> LONG.   |
//+------------------------------------------------------------------+
bool ReclaimLong_Calc(const double barClose,const double lastLow,const bool sweptBelow)
  {
   return(sweptBelow && barClose > lastLow);
  }

//+------------------------------------------------------------------+
//| RECLAIM SHORT: dopo uno sweep SOPRA, una barra CHIUDE sotto il    |
//| massimo del range -> falsa rottura rialzista rientrata -> SHORT.  |
//+------------------------------------------------------------------+
bool ReclaimShort_Calc(const double barClose,const double lastHigh,const bool sweptAbove)
  {
   return(sweptAbove && barClose < lastHigh);
  }

//+------------------------------------------------------------------+
//| SL dello sweep+reclaim: oltre l'estremo del range di una frazione |
//| dell'ampiezza. long -> lastLow - range*frac ; short -> lastHigh + |
//| range*frac. Il pavimento R109 e' applicato a valle dal chiamante. |
//+------------------------------------------------------------------+
double SlLong_Calc(const double lastLow,const double range,const double frac)
  {
   return(lastLow - range*frac);
  }
double SlShort_Calc(const double lastHigh,const double range,const double frac)
  {
   return(lastHigh + range*frac);
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
//| Marcatore di GIORNO (le fasce di casa non attraversano la         |
//| mezzanotte). Due barre stanno nello stesso giorno-seduta se hanno |
//| lo stesso marcatore.                                              |
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t,const int startMinuti)
  {
   long s = (long)t - (long)startMinuti*60;
   if(s<0) s=0;
   return(s/86400);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - nucleo puro. Vero quando l'ora corrente ha  |
//| raggiunto o superato l'ora del flat (confronto in minuti).        |
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

   //--- lati
   if(InpSide<0 || InpSide>2)
     { Print("ERRORE: InpSide deve essere 0 (long), 1 (short) o 2 (entrambi)."); return(INIT_FAILED); }
   if(InpBreakPts<0)
     { Print("ERRORE: InpBreakPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSlFracRange<=0)
     { Print("ERRORE: InpSlFracRange deve essere > 0 (lo SL sta OLTRE l'estremo del range)."); return(INIT_FAILED); }

   //--- orari in range 0-23 / 0-59
   if(InpRangeStartHour<0 || InpRangeStartHour>23 || InpRangeStartMin<0 || InpRangeStartMin>59)
     { Print("ERRORE: ora/minuto inizio range fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpRangeEndHour<0 || InpRangeEndHour>23 || InpRangeEndMin<0 || InpRangeEndMin>59)
     { Print("ERRORE: ora/minuto fine range fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpTradeStartHour<0 || InpTradeStartHour>23 || InpTradeStartMin<0 || InpTradeStartMin>59)
     { Print("ERRORE: ora/minuto inizio trading fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpTradeEndHour<0 || InpTradeEndHour>23 || InpTradeEndMin<0 || InpTradeEndMin>59)
     { Print("ERRORE: ora/minuto fine trading fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
     { Print("ERRORE: ora/minuto flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }

   //--- ordine temporale coerente (nessuna fascia attraversa la mezzanotte)
   int mRs=MinutiDelGiorno_Calc(InpRangeStartHour,InpRangeStartMin);
   int mRe=MinutiDelGiorno_Calc(InpRangeEndHour,InpRangeEndMin);
   int mTs=MinutiDelGiorno_Calc(InpTradeStartHour,InpTradeStartMin);
   int mTe=MinutiDelGiorno_Calc(InpTradeEndHour,InpTradeEndMin);
   int mCl=MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin);
   if(mRs>=mRe)
     { Print("ERRORE: l'inizio del range deve precedere la sua fine."); return(INIT_FAILED); }
   if(mTs<mRe)
     { Print("ERRORE: la fascia di trading deve iniziare a range GIA' costruito (TradeStart >= RangeEnd)."); return(INIT_FAILED); }
   if(mTs>=mTe)
     { Print("ERRORE: l'inizio della fascia di trading deve precedere la sua fine."); return(INIT_FAILED); }
   if(mCl<mTe)
     { Print("ERRORE: il flat deve arrivare a fascia di trading conclusa (Close >= TradeEnd)."); return(INIT_FAILED); }

   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing per
   //    un'inversione sullo sweep (falsa rottura che puo' proseguire):
   //    OnInit rifiuta se e' 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un'inversione senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestReEntry();

   Log(StringFormat("avviato su %s %s. lato=%s, sweep %.1f pti idx, SL frac %.3f del range + pavimento %d pti MT5, range %02d:%02d-%02d:%02d, trading %02d:%02d-%02d:%02d, flat %02d:%02d (ora SERVER), rischio %.2f%%, cap %d/gg, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       (InpSide==0?"LONG":(InpSide==1?"SHORT":"ENTRAMBI")),
       InpBreakPts, InpSlFracRange, InpMinStopPts,
       InpRangeStartHour, InpRangeStartMin, InpRangeEndHour, InpRangeEndMin,
       InpTradeStartHour, InpTradeStartMin, InpTradeEndHour, InpTradeEndMin,
       InpCloseHour, InpCloseMin, InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione: motore INTRADAY, niente overnight. Ingresso SINGOLO: nessuna aggiunta/mediazione/griglia su posizione aperta.");
   Log("FUSO: orari in ORA SERVER BCM (CET -> server -1h). Verifica: RangeStart 08:35, RangeEnd/TradeStart 11:05, TradeEnd 14:15, Flat 16:30.");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- nessun handle indicatore da rilasciare: range/sweep sono
   //    ricostruiti da CopyRates, senza stato persistente.
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

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

//+------------------------------------------------------------------+
//| Reset dello stato del GIORNO: range, sweep, un-segnale-per-lato.   |
//+------------------------------------------------------------------+
void ResetStatoGiorno(const int giorno)
  {
   gStateDay   = giorno;
   gRangeReady = false;
   gLastHigh   = 0.0;
   gLastLow    = 0.0;
   gRange      = 0.0;
   gSweptBelow = false;
   gSweptAbove = false;
   gLongDone   = false;
   gShortDone  = false;
  }

//==================================================================
//  IL GIRO DELLA BARRA NUOVA
//==================================================================
//+------------------------------------------------------------------+
//| Si valuta la barra APPENA CHIUSA (shift 1); l'ordine parte al     |
//| mercato all'apertura della barra 0. Niente look-ahead.            |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   //--- reset dello stato al cambio giorno (feed/server)
   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year!=gStateDay) ResetStatoGiorno(now.day_of_year);

   //--- una posizione per magic: se c'e' gia', si lascia gestire da TP/SL
   //    veri al broker e dal flat di fine seduta. Nessuna aggiunta.
   if(CountPositions()>0){ gCntGestione++; return; }

   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }

   //--- la barra valutata (shift 1) deve stare nella FASCIA DI TRADING
   datetime tEval = iTime(_Symbol, gTF, 1);
   if(tEval<=0){ gCntNoRange++; return; }
   MqlDateTime de; TimeToStruct(tEval, de);
   int mEval = MinutiDelGiorno_Calc(de.hour, de.min);
   if(!InFascia_Calc(mEval, MinutiTradeStart(), MinutiTradeEnd())){ gCntFuoriFascia++; return; }

   //--- range mattutino: costruito una volta al giorno e messo in cache
   if(!gRangeReady)
     {
      double lh=0, ll=0;
      if(!CostruisciRange(lh, ll)){ gCntNoRange++; return; }
      if(!RangeValido_Calc(lh, ll)){ gCntNoRange++; return; }
      gLastHigh = lh; gLastLow = ll; gRange = lh-ll; gRangeReady = true;
     }

   if(!SpreadOK()){ gCntSpread++; return; }

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0){ gCntNoRange++; return; }

   //--- SWEEP: aggiorno i flag (prima del reclaim, cosi' anche la barra
   //    che rompe e rientra nello stesso movimento conta).
   double breakDist = InpBreakPts*InpMT5PerPuntoIndice*_Point;
   bool prevB=gSweptBelow, prevA=gSweptAbove;
   AggiornaSweep_Calc(barLow, barHigh, gLastLow, gLastHigh, breakDist, gSweptBelow, gSweptAbove);
   if(gSweptBelow && !prevB) gCntSweepBelow++;
   if(gSweptAbove && !prevA) gCntSweepAbove++;

   bool allowLong  = (InpSide==0 || InpSide==2);
   bool allowShort = (InpSide==1 || InpSide==2);

   //--- RECLAIM: un solo segnale per lato per giorno (gLongDone/gShortDone).
   if(allowLong && !gLongDone && ReclaimLong_Calc(barClose, gLastLow, gSweptBelow))
     {
      gCntLongCand++; gLongDone=true;          // segnale emesso: 1/lato/gg
      gCntApri++; ApriPosizione(true);
      return;
     }
   if(allowShort && !gShortDone && ReclaimShort_Calc(barClose, gLastHigh, gSweptAbove))
     {
      gCntShortCand++; gShortDone=true;
      gCntApri++; ApriPosizione(false);
     }
  }

//==================================================================
//  COSTRUZIONE DEL RANGE MATTUTINO
//==================================================================
//+------------------------------------------------------------------+
//| Massimo/minimo delle barre del GIORNO CORRENTE (feed) comprese fra |
//| RangeStart (incluso) e RangeEnd (escluso). Ritorna false se non    |
//| c'e' nemmeno una barra utile del range.                            |
//+------------------------------------------------------------------+
bool CostruisciRange(double &lh,double &ll)
  {
   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 2*BarrePerGiornoPieno() + 10;
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<2) return(false);

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   int rs = MinutiRangeStart();
   int re = MinutiRangeEnd();

   lh=-DBL_MAX; ll=DBL_MAX; int usati=0;
   for(int i=0;i<copied;i++)
     {
      MqlDateTime d; TimeToStruct(r[i].time, d);
      if(d.year!=now.year || d.day_of_year!=now.day_of_year) continue; // solo OGGI
      int m = MinutiDelGiorno_Calc(d.hour, d.min);
      if(m<rs || m>=re) continue;                                       // [RangeStart, RangeEnd)
      if(r[i].high>lh) lh=r[i].high;
      if(r[i].low <ll) ll=r[i].low;
      usati++;
     }
   if(usati<1) return(false);
   return(true);
  }

//==================================================================
//  AIUTANTI DI ORARIO
//==================================================================
int MinutiRangeStart(){ return(MinutiDelGiorno_Calc(InpRangeStartHour,InpRangeStartMin)); }
int MinutiRangeEnd()  { return(MinutiDelGiorno_Calc(InpRangeEndHour,InpRangeEndMin)); }
int MinutiTradeStart(){ return(MinutiDelGiorno_Calc(InpTradeStartHour,InpTradeStartMin)); }
int MinutiTradeEnd()  { return(MinutiDelGiorno_Calc(InpTradeEndHour,InpTradeEndMin)); }

//--- barre di un GIORNO PIENO di calendario (~24h / TF): dimensiona la
//    copia storica (CopyRates conta barre CONSECUTIVE sul CALENDARIO).
int BarrePerGiornoPieno()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=300;
   int b = (int)(86400/per);
   return(b<10?10:b);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL oltre l'estremo del range di una  |
//| frazione dell'ampiezza, poi SEMPRE dal PAVIMENTO (mai a zero, mai  |
//| dentro lo stops-level). TP verso l'estremo OPPOSTO del range. Il   |
//| lotto esce da LotByRisk sulla distanza FINALE dello stop.          |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double slRaw = isLong ? SlLong_Calc (gLastLow , gRange, InpSlFracRange)
                         : SlShort_Calc(gLastHigh, gRange, InpSlFracRange);

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

   //--- TP verso l'estremo OPPOSTO del range. Rispetta lo stops-level:
   //    se troppo vicino lo si spinge al minimo; se dal lato sbagliato,
   //    si resta senza TP (flat e SL proteggono comunque).
   double tp = isLong ? gLastHigh : gLastLow;
   double distTP = isLong ? (tp-ref) : (ref-tp);
   if(distTP<=0) tp = 0;
   else
     {
      if(distTP < minBroker) tp = isLong ? ref+minBroker : ref-minBroker;
      tp = NormalizePrice(tp);
     }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp,cm);
   if(ok)
     {
      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP %s lot %.2f (rischio %.1f pti idx | range %s-%s ampiezza %s)",
          isLong?"BUY(reclaim minimo)":"SELL(reclaim massimo)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          (tp>0?DoubleToString(tp,_Digits):"-"), lot, idxRisk,
          DoubleToString(gLastLow,_Digits), DoubleToString(gLastHigh,_Digits),
          DoubleToString(gRange,_Digits)));
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
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpCloseHour,InpCloseMin)) return(false);

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
void AutoTestReEntry()
  {
   int falliti=0;

   PrintFormat("[REENT][AUTOTEST] lato=%s sweep=%.1f slFrac=%.3f | %s | magic %I64d",
               (InpSide==0?"LONG":(InpSide==1?"SHORT":"ENTRAMBI")),
               InpBreakPts, InpSlFracRange, _Symbol, InpMagic);

   //--- 1. RANGE valido (ampiezza positiva)
   bool rv1=RangeValido_Calc(110.0,100.0);   // 10 -> vero
   bool rv2=RangeValido_Calc(100.0,100.0);   // 0  -> falso
   bool rv3=RangeValido_Calc( 90.0,100.0);   // negativo -> falso
   PrintFormat("[REENT][AUTOTEST] range: valido=%d(1) piatto=%d(0) invertito=%d(0)",
               (int)rv1,(int)rv2,(int)rv3);
   if(!(rv1 && !rv2 && !rv3)) falliti++;

   //--- 2. SWEEP (falsa rottura del range). lastLow 100, lastHigh 110,
   //    breakDist 2. sweptBelow se low<=98; sweptAbove se high>=112.
   bool sb=false, sa=false;
   AggiornaSweep_Calc( 97.0,105.0, 100.0,110.0, 2.0, sb, sa);   // low 97<=98 -> below
   PrintFormat("[REENT][AUTOTEST] sweep A: below=%d(1) above=%d(0)", (int)sb,(int)sa);
   if(!(sb && !sa)) falliti++;
   sb=false; sa=false;
   AggiornaSweep_Calc(102.0,113.0, 100.0,110.0, 2.0, sb, sa);   // high 113>=112 -> above
   PrintFormat("[REENT][AUTOTEST] sweep B: below=%d(0) above=%d(1)", (int)sb,(int)sa);
   if(!(!sb && sa)) falliti++;
   sb=false; sa=false;
   AggiornaSweep_Calc( 99.0,111.0, 100.0,110.0, 2.0, sb, sa);   // rottura insufficiente
   PrintFormat("[REENT][AUTOTEST] sweep C(insuff): below=%d(0) above=%d(0)", (int)sb,(int)sa);
   if(!(!sb && !sa)) falliti++;

   //--- 3. RECLAIM (chiude oltre l'estremo dopo lo sweep)
   bool rl1=ReclaimLong_Calc(101.0,100.0,true);    // swept + close>100 -> vero
   bool rl2=ReclaimLong_Calc(101.0,100.0,false);   // niente sweep -> falso
   bool rl3=ReclaimLong_Calc( 99.5,100.0,true);    // close sotto -> falso
   bool rs1=ReclaimShort_Calc(109.0,110.0,true);   // swept + close<110 -> vero
   bool rs2=ReclaimShort_Calc(109.0,110.0,false);  // niente sweep -> falso
   bool rs3=ReclaimShort_Calc(110.5,110.0,true);   // close sopra -> falso
   PrintFormat("[REENT][AUTOTEST] reclaim: long ok=%d(1) noSweep=%d(0) sotto=%d(0) | short ok=%d(1) noSweep=%d(0) sopra=%d(0)",
               (int)rl1,(int)rl2,(int)rl3,(int)rs1,(int)rs2,(int)rs3);
   if(!(rl1 && !rl2 && !rl3 && rs1 && !rs2 && !rs3)) falliti++;

   //--- 4. SEQUENZA completa (sweep poi reclaim, anche stessa barra)
   //    range 100-110, breakDist 2. Barra: low 97 (sweep sotto), close 101.
   bool sb2=false, sa2=false;
   AggiornaSweep_Calc(97.0,102.0, 100.0,110.0, 2.0, sb2, sa2);
   bool seqLong = ReclaimLong_Calc(101.0,100.0,sb2);   // stessa barra: sweep + reclaim -> LONG
   PrintFormat("[REENT][AUTOTEST] sequenza stessa barra: below=%d(1) reclaimLong=%d(1)", (int)sb2,(int)seqLong);
   if(!(sb2 && seqLong)) falliti++;

   //--- 5. SL sweep+reclaim + PAVIMENTO (mai a zero: R109)
   double sl_l=SlLong_Calc (100.0,10.0,0.454);   // 100 - 4.54 = 95.46
   double sl_s=SlShort_Calc(110.0,10.0,0.454);   // 110 + 4.54 = 114.54
   double p1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double p2=PavimentoSL_Calc(true ,100.0, 95.0,2.0);  // gia' oltre -> 95.00
   double p3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short -> 102.00
   PrintFormat("[REENT][AUTOTEST] SL: long=%.2f (95.46) short=%.2f (114.54) | pav %.2f (98.00) %.2f (95.00) short %.2f (102.00)",
               sl_l,sl_s,p1,p2,p3);
   if(!(MathAbs(sl_l-95.46)<1e-6 && MathAbs(sl_s-114.54)<1e-6 &&
        MathAbs(p1-98.0)<1e-6 && MathAbs(p2-95.0)<1e-6 && MathAbs(p3-102.0)<1e-6)) falliti++;

   //--- 6. FASCE / STAMP / FLAT / conversione punti (ora SERVER)
   int mRs=MinutiDelGiorno_Calc(8,35), mRe=MinutiDelGiorno_Calc(11,5);
   int mTs=MinutiDelGiorno_Calc(11,5), mTe=MinutiDelGiorno_Calc(14,15);
   bool fr1=InFascia_Calc(MinutiDelGiorno_Calc( 8,35),mRs,mRe);  // apertura range inclusa
   bool fr2=InFascia_Calc(MinutiDelGiorno_Calc(11, 5),mRs,mRe);  // fine range esclusa
   bool ft1=InFascia_Calc(MinutiDelGiorno_Calc(11, 5),mTs,mTe);  // apertura trading inclusa
   bool ft2=InFascia_Calc(MinutiDelGiorno_Calc(14,15),mTs,mTe);  // fine trading esclusa
   bool ft3=InFascia_Calc(MinutiDelGiorno_Calc(12, 0),mTs,mTe);  // dentro
   bool fl1=DopoOrarioFlat_Calc(16,30,16,30);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(16,29,16,30);   // prima -> no
   datetime tA=D'2026.08.25 09:00:00';
   datetime tB=D'2026.08.25 13:00:00';
   datetime tC=D'2026.08.26 09:00:00';
   bool sm1=(SessionStamp_Calc(tA,mRs)==SessionStamp_Calc(tB,mRs));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mRs)==SessionStamp_Calc(tC,mRs));  // diverse
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   PrintFormat("[REENT][AUTOTEST] fasce: rangeApre=%d(1) rangeFine=%d(0) tradeApre=%d(1) tradeFine=%d(0) dentro=%d(1) | flat esatto=%d(1) prima=%d(0) | stamp same=%d(1) diff=%d(0) | conv=%.2f(5.00)",
               (int)fr1,(int)fr2,(int)ft1,(int)ft2,(int)ft3,(int)fl1,(int)fl2,(int)sm1,(int)sm2,ip1);
   if(!(fr1 && !fr2 && ft1 && !ft2 && ft3 && fl1 && !fl2 && sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[REENT][AUTOTEST] esito motore: ", (falliti==0
         ? "SEI BLOCCHI SU SEI, il motore ragiona come la meccanica."
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
   stats[14] = (double)gCntGestione;       // Ret Gestione (posizione aperta)
   stats[15] = (double)gCntNoRange;        // Ret No Range
   stats[16] = (double)gCntFuoriFascia;    // Ret Fuori Fascia
   stats[17] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[18] = (double)gCntSpread;         // Ret Spread
   stats[19] = (double)gCntSweepBelow;     // Sweep Below
   stats[20] = (double)gCntSweepAbove;     // Sweep Above
   stats[21] = (double)gCntLongCand;       // Long Cand
   stats[22] = (double)gCntShortCand;      // Short Cand
   stats[23] = (double)gCntApri;           // Apri Chiamate

   PrintFormat("[REENT][DIAG] OnNewBar=%I64d | ret: gestione=%I64d noRange=%I64d fuoriFascia=%I64d maxTrades=%I64d spread=%I64d | sweep below=%I64d above=%I64d | longCand=%I64d shortCand=%I64d apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoRange, gCntFuoriFascia,
               gCntMaxTrades, gCntSpread, gCntSweepBelow, gCntSweepAbove,
               gCntLongCand, gCntShortCand, gCntApri);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret No Range,Ret Fuori Fascia,Ret Max Trades,Ret Spread,Sweep Below,Sweep Above,Long Cand,Short Cand,Apri Chiamate";
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
