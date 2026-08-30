//+------------------------------------------------------------------+
//|                                          ABTG_CRT_TurtleSoup.mq5  |
//|                                                                  |
//|  Motore CRT Turtle Soup da Neo Malesa (n30dyn4m1c), licenza MIT. |
//|  Fonte: https://github.com/n30dyn4m1c/crt-turtlesoup-ea          |
//|                                                                  |
//|  MOTORE CRT TURTLE SOUP - MT5 - TUTTO-IN-UNO                     |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  COS'E' - un motore di REVERSAL su falsa rottura (turtle soup).  |
//|    Quando una candela spazza il minimo (o massimo) della candela |
//|    precedente e poi RICHIUDE dentro il range con un lungo wick di |
//|    rifiuto (>= Kx il corpo), la rottura era falsa: liquidita'     |
//|    presa, non continuazione. Si entra nel verso OPPOSTO (fade     |
//|    strutturato), con SL all'estremo del wick e target al centro / |
//|    estremo del range spazzato. Il wick di rifiuto e il gate del   |
//|    50% SONO la strategia, non un cerotto.                         |
//|                                                                  |
//|  IL PATTERN A 3 CANDELE (barre CHIUSE, niente repaint):          |
//|    C2 = candela range (riferimento)  = shift 2                   |
//|    C1 = falsa rottura (TS candle)    = shift 1                   |
//|    C0 = entry all'open               = shift 0 (barra che apre)  |
//|    LONG : low(C1) < low(C2) && close(C1) > close(C2), con        |
//|           lowerWick(C1) >= InpWickFactor * body(C1). C2 ribassista|
//|           e C1 rialzista (da CRTTS_M15.mq5 righe 90-108).         |
//|    SHORT: specchiato (high(C1) > high(C2) && close(C1)<close(C2), |
//|           upperWick(C1) >= InpWickFactor * body(C1)).            |
//|    Entry = open(C0) a MERCATO.                                   |
//|    SL   = estremo del wick di C1 (low(C1) long / high(C1) short) |
//|           + PAVIMENTO InpMinStopPts (R109).                      |
//|    TP1  = punto medio di C2 = (low2+high2)/2 (parziale).         |
//|    TP2  = estremo opposto di C2 (high2 long / low2 short, runner)|
//|                                                                  |
//|  GATE DEL 50% (InpUseMidGate): porta ESATTAMENTE la logica       |
//|    MidNotReached di crt-ts.mq5. In quel sorgente r[0] e' la barra |
//|    di segnale (qui C1) e r[1] la barra precedente (qui C2):       |
//|      Bull: mid=(C2.high+C2.low)/2 ; passa se C1.high < mid.       |
//|      Bear: mid=(C2.high+C2.low)/2 ; passa se C1.low  > mid.       |
//|    Il gate chiede che la barra di falsa rottura sia rimasta oltre |
//|    meta' del range spazzato (sweep profondo, non semplice tocco). |
//|                                                                  |
//|  GESTIONE NOSTRA sopra il segnale:                               |
//|    - parziale a TP1 (InpTP1_ClosePct %),                         |
//|    - breakeven DOPO il parziale (SL a pareggio, una volta sola), |
//|    - runner verso TP2 (TP vero al broker).                       |
//|                                                                  |
//|  PROP-HARDENING (obbligatorio, contratto di casa)               |
//|    - STOP LOSS VERO AL BROKER, mai una regola a sola chiusura     |
//|      barra: ordine di stop sul server. PAVIMENTO SL OBBLIGATORIO  |
//|      (R109): InpMinStopPts, MAI zero -> OnInit RIFIUTA se <= 0.   |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa.         |
//|    - NIENTE martingala/griglia/recovery/DCA/averaging/hedging-di- |
//|      motore/virtual-stop: ingresso SINGOLO, una posizione per     |
//|      magic, nessuna aggiunta su posizione aperta.                |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                       |
//|    - FLAT OBBLIGATORIO a fine seduta (ora del FEED): mai overnight|
//|    - EXPORT PER-TRADE CSV + OnTester (recovery factor). AUTOTEST  |
//|      del nucleo in avvio.                                        |
//|                                                                  |
//|  ORARI: SEMPRE ORA DEL FEED. Su D30EUR/U30USD/NASUSD il feed E'   |
//|  l'ora server BCM. InpCloseHour/InpCloseMin vanno messi in ora    |
//|  server del simbolo.                                            |
//|                                                                  |
//|  CONVERSIONE PUNTI: su indici US 1 punto indice = 100 punti MT5   |
//|  (_Point) (R97). Le distanze operative (buffer SL, pavimento)     |
//|  sono in PUNTI MT5; InpMT5PerPuntoIndice serve all'export/log.    |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA (C1/C2 a shift 1/2). L'ordine parte   |
//|  all'apertura di C0. Niente look-ahead, niente repaint.          |
//|                                                                  |
//|  Un solo simbolo per grafico (NON il loop multi-symbol           |
//|  dell'originale). DEMO. Nessuna garanzia. ASCII puro dentro le    |
//|  stringhe (regola di casa). NON compilato ne' testato da chi ha   |
//|  scritto il file: compilare in MetaEditor (F7) e validare nel     |
//|  tester.                                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - motore CRT Turtle Soup (Neo Malesa, MIT)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== SEGNALE CRT TURTLE SOUP (griglia congelata) ==="
input double InpWickFactor       = 3.0;   // Wick di rifiuto di C1 >= Kx il corpo (griglia)
input int    InpUseMidGate       = 1;     // Gate del 50% MidNotReached (1=ON, 0=OFF) (griglia)
input int    InpSide             = 2;     // Lato: 0=solo long, 1=solo short, 2=entrambi (griglia)

input group "=== GATE DI REGIME (costitutivo, opzionale; default OFF = originale) ==="
input bool           InpUseRegimeGate   = false;       // Gate ON/OFF. false = EA IDENTICO a oggi (nessun controllo)
input ENUM_TIMEFRAMES InpRegimeTF       = PERIOD_D1;   // TF su cui si misura il regime (barra CHIUSA, shift 1)
input int            InpRegimeAdxPeriod = 14;          // Periodo ADX del gate
input double         InpAdxMax          = 30.0;        // Opera SOLO se ADX(InpRegimeTF) <= questo (NON trend/crollo forte)
input int            InpRegimeAtrPeriod = 14;          // Periodo ATR del gate
input double         InpAtrMinPts       = 0.0;         // Opera SOLO se ATR(InpRegimeTF) in PUNTI INDICE >= questo (0 = neutro)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlBufferPts      = 0;     // Buffer oltre l'estremo del wick di C1, in PUNTI MT5 (0 = estremo esatto)
input int    InpMinStopPts       = 500;   // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice US). MAI 0.

input group "=== GESTIONE (parziale TP1 + breakeven + runner TP2) ==="
input double InpTP1_ClosePct     = 50.0;  // Percentuale chiusa a TP1 (mid range di C2). Resto verso TP2.
input bool   InpBreakevenAfterTP1= true;  // Dopo il parziale porta lo SL a pareggio (una volta sola)

input group "=== FLAT DI FINE SEDUTA (ora del FEED; mai overnight) ==="
input bool   InpCloseAtEnd       = true;  // Chiudi tutto a fine seduta (niente overnight)
input int    InpCloseHour        = 22;    // Ora del FLAT (ora del FEED/server del simbolo)
input int    InpCloseMin         = 0;     // Minuto del FLAT

input group "=== Rischio e cap ==="
input double InpRiskPercent      = 0.65;  // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay  = 3;     // Max ingressi ESEGUITI al giorno (0 = illimitato)

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice= 100;   // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment          = "CRTTS"; // Commento sugli ordini
input long   InpMagic            = 769100;  // Numero magico (verificato VERGINE nel repo)
input int    InpMaxSpread        = 0;       // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose          = true;    // Messaggi nel log
input bool   InpAutoTest         = true;    // Stampa le righe [CRTTS][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

//--- handle degli indicatori NATIVI del gate di regime. Creati in OnInit
//    SOLO quando InpUseRegimeGate==true (con gate OFF restano INVALID_HANDLE
//    e l'EA e' identico a oggi). Rilasciati in OnDeinit.
int      gAdxHandle = INVALID_HANDLE;
int      gAtrHandle = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- stato della posizione aperta per la GESTIONE (parziale + breakeven).
//    Si perde a un riavvio a meta' trade: la posizione resta comunque
//    protetta da SL e TP2 VERI al broker (fail-safe, come lo scaffold).
ulong    gPosTicket   = 0;
bool     gIsLong      = false;
double   gEntryPrice  = 0.0;
double   gTP1Price    = 0.0;
double   gTP2Price    = 0.0;
bool     gPartialDone = false;

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE cancello
//    ferma le barre.
long gCntOnNewBar     = 0;   // chiamate totali a OnNewBar
long gCntGestione     = 0;   // return: c'era posizione aperta (gestione)
long gCntNoDati       = 0;   // return: storico insufficiente
long gCntMaxTrades    = 0;   // return: cap trade/giorno raggiunto
long gCntFuoriOrario  = 0;   // return: oltre l'orario di flat
long gCntSpread       = 0;   // return: spread non ok
long gCntNoPattern    = 0;   // return: nessun pattern CRT
long gCntGateBloccati = 0;   // return: pattern valido SOPPRESSO dal gate di regime
long gCntLongCand     = 0;   // candidati LONG
long gCntShortCand    = 0;   // candidati SHORT
long gCntApri         = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[CRTTS] ", m); }

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
//| IL SEGNALE CRT TURTLE SOUP - il cuore del motore.                 |
//| Valuta le due barre chiuse C1 (falsa rottura, shift 1) e C2       |
//| (range, shift 2). Ritorna +1 = LONG (fade di uno sweep del minimo |
//| di C2), -1 = SHORT (sweep del massimo di C2), 0 = niente.         |
//|                                                                  |
//| Pattern base da CRTTS_M15.mq5 righe 90-108 (close-vs-close di C2  |
//| + colore delle candele + wick di rifiuto). Il gate del 50' e' la  |
//| logica MidNotReached di crt-ts.mq5 (C1.high < mid(C2) per il long,|
//| C1.low > mid(C2) per lo short): il wick di rifiuto NON deve aver  |
//| ripreso oltre meta' del range spazzato.                          |
//|                                                                  |
//| side: 0=solo long, 1=solo short, 2=entrambi.                     |
//+------------------------------------------------------------------+
int SegnaleCRT_Calc(
   const double o1,const double c1,const double h1,const double l1,   // C1 = falsa rottura
   const double o2,const double c2,const double h2,const double l2,   // C2 = range
   const double wickFactor,const bool useMidGate,const int side)
  {
   double body1 = MathAbs(c1-o1);
   if(body1<=0) return(0);                       // senza corpo il rapporto wick/corpo non esiste

   double lowerWick1 = MathMin(o1,c1) - l1;
   double upperWick1 = h1 - MathMax(o1,c1);
   double mid2       = (h2 + l2)*0.5;

   //--- LONG: C2 ribassista, C1 rialzista che buca il minimo di C2 e
   //    richiude sopra la chiusura di C2, con lungo wick INFERIORE.
   bool c2Bear  = (c2 < o2);
   bool c1Bull  = (c1 > o1);
   bool longPat = c2Bear && c1Bull && (l1 < l2) && (c1 > c2) &&
                  (lowerWick1 >= wickFactor*body1);
   if(useMidGate) longPat = longPat && (h1 < mid2);   // MidNotReachedBull (crt-ts.mq5)

   //--- SHORT: specchiato.
   bool c2Bull   = (c2 > o2);
   bool c1Bear   = (c1 < o1);
   bool shortPat = c2Bull && c1Bear && (h1 > h2) && (c1 < c2) &&
                   (upperWick1 >= wickFactor*body1);
   if(useMidGate) shortPat = shortPat && (l1 > mid2);  // MidNotReachedBear (crt-ts.mq5)

   if(longPat && shortPat) return(0);            // difensivo: mai entrambi, ma non si tira a indovinare

   if(longPat  && (side==0 || side==2)) return(+1);
   if(shortPat && (side==1 || side==2)) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| SL grezzo all'estremo del wick di C1, di un buffer.               |
//|   long -> low(C1) - buffer ; short -> high(C1) + buffer           |
//+------------------------------------------------------------------+
double SlWick_Calc(const bool isLong,const double l1,const double h1,const double buffer)
  {
   return(isLong ? l1-buffer : h1+buffer);
  }

//+------------------------------------------------------------------+
//| TP1 = punto medio del range di C2.                                |
//+------------------------------------------------------------------+
double Tp1Mid_Calc(const double h2,const double l2)
  {
   return((h2 + l2)*0.5);
  }

//+------------------------------------------------------------------+
//| TP2 = estremo OPPOSTO di C2 (il runner).                          |
//|   long -> high(C2) ; short -> low(C2)                             |
//+------------------------------------------------------------------+
double Tp2Ext_Calc(const bool isLong,const double h2,const double l2)
  {
   return(isLong ? h2 : l2);
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

//+------------------------------------------------------------------+
//| GATE DI REGIME - nucleo puro. Passa (true = si puo' operare) SOLO |
//| se ENTRAMBE: ADX <= adxMax (regime NON fortemente direzionale,    |
//| esclude crollo e trend liscio forte) E ATR in PUNTI INDICE >=     |
//| atrMinPts (abbastanza range da fadare, esclude il toro calmo).    |
//| E' la traduzione della lettura per regime: il CRT e' una          |
//| mean-reversion da chop/range bilaterale.                          |
//+------------------------------------------------------------------+
bool RegimeGate_Calc(const double adx,const double atrPts,
                     const double adxMax,const double atrMinPts)
  {
   return(adx <= adxMax && atrPts >= atrMinPts);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpWickFactor<0)
     { Print("ERRORE: InpWickFactor non puo' essere negativo."); return(INIT_FAILED); }
   if(InpUseMidGate!=0 && InpUseMidGate!=1)
     { Print("ERRORE: InpUseMidGate deve essere 0 (OFF) o 1 (ON)."); return(INIT_FAILED); }
   if(InpSide<0 || InpSide>2)
     { Print("ERRORE: InpSide deve essere 0 (long), 1 (short) o 2 (entrambi)."); return(INIT_FAILED); }
   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing per un
   //    fade su falsa rottura (coltello che cade): OnInit rifiuta se e' <= 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un fade senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpTP1_ClosePct<=0 || InpTP1_ClosePct>=100)
     { Print("ERRORE: InpTP1_ClosePct deve stare in (0,100): parziale a TP1 lasciando un runner a TP2."); return(INIT_FAILED); }
   if(InpCloseAtEnd)
     {
      if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
        { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
     }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }

   //--- GATE DI REGIME: gli handle NATIVI si creano SOLO se il gate e' attivo.
   //    Con gate OFF non si tocca nulla (l'EA e' identico a oggi). Con gate ON
   //    un handle INVALID e' un errore duro (OnInit RIFIUTA), perche' il gate
   //    deciderebbe alla cieca.
   if(InpUseRegimeGate)
     {
      if(InpRegimeAdxPeriod<=0)
        { Print("ERRORE: InpRegimeAdxPeriod deve essere > 0 (gate di regime)."); return(INIT_FAILED); }
      if(InpRegimeAtrPeriod<=0)
        { Print("ERRORE: InpRegimeAtrPeriod deve essere > 0 (gate di regime)."); return(INIT_FAILED); }
      if(InpAtrMinPts<0)
        { Print("ERRORE: InpAtrMinPts non puo' essere negativo (gate di regime)."); return(INIT_FAILED); }
      gAdxHandle = iADX(_Symbol, InpRegimeTF, InpRegimeAdxPeriod);
      gAtrHandle = iATR(_Symbol, InpRegimeTF, InpRegimeAtrPeriod);
      if(gAdxHandle==INVALID_HANDLE || gAtrHandle==INVALID_HANDLE)
        { Print("ERRORE: handle iADX/iATR del gate di regime non creato (INVALID_HANDLE)."); return(INIT_FAILED); }
     }

   if(InpAutoTest) AutoTestCRT();

   Log(StringFormat("avviato su %s %s. Wick x%.2f, midGate %s, side %s, SL buffer %d + pavimento %d pti MT5, TP1 close %.0f%% (BE %s), rischio %.2f%%, cap %d/gg, flat %s %02d:%02d, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpWickFactor, (InpUseMidGate==1?"ON":"off"),
       (InpSide==0?"LONG":(InpSide==1?"SHORT":"BOTH")),
       InpSlBufferPts, InpMinStopPts, InpTP1_ClosePct,
       (InpBreakevenAfterTP1?"ON":"off"),
       InpRiskPercent, InpMaxTradesPerDay,
       (InpCloseAtEnd?"ON":"off"), InpCloseHour, InpCloseMin, InpMagic));
   Log("Ingresso SINGOLO: una posizione per magic, nessuna aggiunta/mediazione/griglia su posizione aperta (contratto). SL e TP2 sono ordini VERI al broker.");
   if(InpUseRegimeGate)
      Log(StringFormat("GATE DI REGIME ON su %s: opero solo se ADX(%d) <= %.1f E ATR(%d) >= %.1f pti idx (barra CHIUSA, shift 1). Fuori regime: FLAT.",
          EnumToString(InpRegimeTF), InpRegimeAdxPeriod, InpAdxMax, InpRegimeAtrPeriod, InpAtrMinPts));
   else
      Log("GATE DI REGIME OFF: comportamento identico all'originale (nessun controllo di regime).");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- il pattern (le tre barre) e' letto da iOHLC senza stato persistente;
   //    gli UNICI handle sono quelli del gate di regime, creati solo se ON.
   if(gAdxHandle!=INVALID_HANDLE){ IndicatorRelease(gAdxHandle); gAdxHandle=INVALID_HANDLE; }
   if(gAtrHandle!=INVALID_HANDLE){ IndicatorRelease(gAtrHandle); gAtrHandle=INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

   //--- la GESTIONE (parziale TP1 + breakeven) gira a ogni tick: TP1 puo'
   //    essere colpito intrabar, non solo a barra chiusa.
   GestisciPosizione();

   if(FlatFineSedutaCheck()) return;   // fine seduta: chiudo tutto e non riapro

   if(!IsNewBar()) return;             // le DECISIONI d'ingresso solo a barra chiusa

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
//| GATE DI REGIME live: legge ADX e ATR di InpRegimeTF sulla barra   |
//| CHIUSA (shift 1) e chiede al nucleo puro RegimeGate_Calc se il    |
//| regime e' operabile. Niente look-ahead: shift 1, non la barra in  |
//| formazione. Se i dati non ci sono ancora (inizio storico) o gli   |
//| handle mancano -> gate NON soddisfatto (niente trade), NON errore.|
//| ATR e' in PREZZO: lo converto in PUNTI INDICE con la stessa       |
//| conversione del resto del motore (coerenza della soglia).         |
//+------------------------------------------------------------------+
bool RegimeGateOk()
  {
   if(gAdxHandle==INVALID_HANDLE || gAtrHandle==INVALID_HANDLE) return(false);

   //--- servono almeno 2 barre del regime-TF per leggere lo shift 1.
   if(BarsCalculated(gAdxHandle)<2 || BarsCalculated(gAtrHandle)<2) return(false);

   double adxBuf[]; double atrBuf[];
   //--- start_pos = 1 (ultima barra CHIUSA), count = 1. Buffer 0:
   //    iADX main line (ADX), iATR valore ATR in PREZZO.
   if(CopyBuffer(gAdxHandle,0,1,1,adxBuf)<1) return(false);
   if(CopyBuffer(gAtrHandle,0,1,1,atrBuf)<1) return(false);

   double adx      = adxBuf[0];
   double atrPrezzo= atrBuf[0];
   if(adx<0 || atrPrezzo<=0) return(false);   // valore non pronto

   double atrPts = PrezzoInPuntiIndice_Calc(atrPrezzo, InpMT5PerPuntoIndice, _Point);
   return(RegimeGate_Calc(adx, atrPts, InpAdxMax, InpAtrMinPts));
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valutano C1 (shift 1) e C2 (shift  |
//| 2), gia' CHIUSE; l'ordine parte al mercato all'apertura di C0.    |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   //--- una posizione per magic: se e' aperta, la gestione (parziale +
   //    breakeven) e' gia' fatta in OnTick; qui non si apre nient'altro.
   if(CountPositions()>0){ gCntGestione++; return; }

   if(Bars(_Symbol,gTF) < 3){ gCntNoDati++; return; }

   //--- oltre l'orario di flat non si aprono nuove posizioni (il flat le
   //    chiuderebbe subito): niente overnight per costruzione.
   if(InpCloseAtEnd)
     {
      MqlDateTime tnow; TimeToStruct(TimeCurrent(),tnow);
      if(DopoOrarioFlat_Calc(tnow.hour,tnow.min,InpCloseHour,InpCloseMin)){ gCntFuoriOrario++; return; }
     }

   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }

   //--- C1 = shift 1 (falsa rottura), C2 = shift 2 (range). Barre chiuse.
   double o1=iOpen(_Symbol,gTF,1), c1=iClose(_Symbol,gTF,1), h1=iHigh(_Symbol,gTF,1), l1=iLow(_Symbol,gTF,1);
   double o2=iOpen(_Symbol,gTF,2), c2=iClose(_Symbol,gTF,2), h2=iHigh(_Symbol,gTF,2), l2=iLow(_Symbol,gTF,2);
   if(o1<=0||c1<=0||h1<=0||l1<=0||o2<=0||c2<=0||h2<=0||l2<=0){ gCntNoDati++; return; }

   int sig = SegnaleCRT_Calc(o1,c1,h1,l1, o2,c2,h2,l2,
                             InpWickFactor, (InpUseMidGate==1), InpSide);
   if(sig==0){ gCntNoPattern++; return; }

   //--- GATE DI REGIME (costitutivo, opzionale): un pattern valido viene
   //    comunque SOPPRESSO se il regime non e' da chop/range bilaterale
   //    (ADX troppo alto = trend/crollo forte, oppure ATR troppo basso =
   //    toro calmo). Con gate OFF questo blocco e' inerte.
   if(InpUseRegimeGate && !RegimeGateOk()){ gCntGateBloccati++; return; }

   bool isLong = (sig>0);
   if(isLong) gCntLongCand++; else gCntShortCand++;

   gCntApri++;
   ApriPosizione(isLong, l1, h1, l2, h2);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP2 veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL all'estremo del wick di C1 (+     |
//| buffer), poi SEMPRE dal PAVIMENTO (mai a zero, mai dentro lo       |
//| stops-level). TP2 = estremo opposto di C2 (runner). TP1 (mid di    |
//| C2) e' memorizzato per la gestione del parziale. Il lotto esce da  |
//| LotByRisk sulla distanza FINALE dello stop.                       |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong,const double l1,const double h1,
                   const double l2,const double h2)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlWick_Calc(isLong, l1, h1, bufferPrezzo);

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

   //--- TP2 = estremo opposto di C2 (runner). Dev'essere dal lato giusto;
   //    se troppo vicino, lo si spinge al minimo consentito dal broker.
   double tp2 = Tp2Ext_Calc(isLong, h2, l2);
   double distTP = isLong ? (tp2-ref) : (ref-tp2);
   if(distTP<=0){ Log("TP2 dal lato sbagliato (setup degenere): salto."); return(false); }
   if(distTP < minBroker) tp2 = isLong ? ref+minBroker : ref-minBroker;
   tp2 = NormalizePrice(tp2);

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp2,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp2,cm);
   if(ok)
     {
      //--- registro lo stato per la GESTIONE (parziale a TP1 + breakeven).
      double tp1 = Tp1Mid_Calc(h2,l2);
      RegistraPosizioneAperta(isLong, ref, tp1, tp2);

      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP1 %s TP2 %s lot %.2f (rischio %.1f pti idx)",
          isLong?"BUY(fade sweep min)":"SELL(fade sweep max)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp1,_Digits), DoubleToString(tp2,_Digits), lot, idxRisk));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//+------------------------------------------------------------------+
//| Registra lo stato della posizione appena aperta (per la gestione).|
//| Aggancia il ticket VERO della posizione a magic.                  |
//+------------------------------------------------------------------+
void RegistraPosizioneAperta(const bool isLong,const double entry,
                             const double tp1,const double tp2)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      gPosTicket   = tk;
      gIsLong      = isLong;
      gEntryPrice  = PositionGetDouble(POSITION_PRICE_OPEN);   // prezzo di riempimento VERO
      if(gEntryPrice<=0) gEntryPrice = entry;
      gTP1Price    = tp1;
      gTP2Price    = tp2;
      gPartialDone = false;
      return;
     }
  }

//==================================================================
//  GESTIONE della posizione: parziale a TP1 + breakeven (una volta)
//==================================================================
//+------------------------------------------------------------------+
//| A TP1 (mid range di C2) chiude InpTP1_ClosePct% e, se richiesto,   |
//| porta lo SL a pareggio. Una sola volta per posizione (gPartialDone |
//| legato al ticket). Il runner resta con TP2 vero al broker.        |
//| Nota: dopo un riavvio a meta' trade lo stato e' perso e il         |
//| parziale non scatta, ma SL/TP2 VERI proteggono comunque.          |
//+------------------------------------------------------------------+
void GestisciPosizione()
  {
   //--- trova la posizione a magic sul simbolo
   ulong tk = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong t=PositionGetTicket(i);
      if(t==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      tk=t; break;
     }
   if(tk==0)
     {
      //--- nessuna posizione: azzero lo stato di gestione.
      gPosTicket=0; gPartialDone=false; gTP1Price=0; gTP2Price=0;
      return;
     }

   //--- ticket cambiato senza passare da ApriPosizione (es. riavvio): non
   //    conosco TP1 -> niente parziale, la posizione resta su SL/TP2 veri.
   if(tk!=gPosTicket) return;
   if(gPartialDone) return;
   if(gTP1Price<=0) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;

   //--- TP1 raggiunto? long si valuta sul bid (uscita), short sull'ask.
   bool hitTP1 = gIsLong ? (bid >= gTP1Price) : (ask <= gTP1Price);
   if(!hitTP1) return;

   //--- 1) PARZIALE: chiudo InpTP1_ClosePct% del volume, se la spezzatura
   //       rispetta min/step (altrimenti niente parziale, solo breakeven).
   double vol   = PositionGetDouble(POSITION_VOLUME);
   double minV  = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double closeVol = NormalizeVolume(vol*InpTP1_ClosePct/100.0);
   double remain   = vol - closeVol;
   if(closeVol>=minV && remain>=minV)
     {
      if(gTrade.PositionClosePartial(tk, closeVol))
         Log(StringFormat("TP1 colpito: chiuso parziale %.2f su %.2f (resto verso TP2).", closeVol, vol));
      else
         Log("parziale a TP1 fallito: "+gTrade.ResultRetcodeDescription());
     }
   else
      Log("parziale a TP1 non spezzabile (min/step volume): tengo intero e vado in breakeven.");

   //--- 2) BREAKEVEN: SL a pareggio (una volta sola), preservando TP2.
   if(InpBreakevenAfterTP1)
     {
      double be = NormalizePrice(gEntryPrice);
      double stops = minBrokerPrezzo();
      //--- clamp: lo SL deve stare oltre lo stops-level dal prezzo corrente.
      if(gIsLong){ double maxSL=bid-stops; if(be>maxSL) be=NormalizePrice(maxSL); }
      else       { double minSL=ask+stops; if(be<minSL) be=NormalizePrice(minSL); }

      //--- preservo il TP2 gia' impostato all'apertura (memorizzato), senza
      //    dipendere dalla selezione della posizione dopo il parziale.
      double tpCur = gTP2Price;
      if(gTrade.PositionModify(tk, be, tpCur))
         Log(StringFormat("breakeven: SL portato a %s.", DoubleToString(be,_Digits)));
      else
         Log("breakeven fallito: "+gTrade.ResultRetcodeDescription());
     }

   gPartialDone = true;
  }

double minBrokerPrezzo()
  {
   return((double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   if(!InpCloseAtEnd) return(false);
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

//--- Volume normalizzato allo step; sotto il minimo -> 0 (non spezzabile).
double NormalizeVolume(double v)
  {
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   v = MathFloor(v/st)*st;
   if(v<mn) return(0);
   if(v>mx) v=mx;
   return(v);
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
void AutoTestCRT()
  {
   int falliti=0;

   PrintFormat("[CRTTS][AUTOTEST] Wick x%.2f midGate=%d side=%d | %s | magic %I64d",
               InpWickFactor,(int)(InpUseMidGate==1),InpSide,_Symbol,InpMagic);

   //--- 1. PATTERN BULLISH (long). C2 ribassista o2=110 c2=100 h2=111 l2=99
   //    (mid2 = 105). C1 rialzista o1=101 c1=101.5 (corpo 0.5) l1=98 (< 99)
   //    lowerWick=101-98=3 (>= 3*0.5=1.5) h1=102 (< mid2 105, gate ok).
   int b1 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,2);
   //--- 2. PATTERN BEARISH (short). C2 rialzista o2=100 c2=110 h2=111 l2=99
   //    (mid2 105). C1 ribassista o1=109 c1=108.5 (corpo 0.5) h1=113 (>111)
   //    upperWick=113-109=4 (>=1.5) l1=106 (> mid2 105, gate ok).
   int b2 = SegnaleCRT_Calc(109.0,108.5,113.0,106.0, 100.0,110.0,111.0,99.0, 3.0,true,2);
   PrintFormat("[CRTTS][AUTOTEST] pattern: bull=%d(1) bear=%d(-1)", b1,b2);
   if(!(b1==1 && b2==-1)) falliti++;

   //--- 3. WICK troppo corto -> niente segnale. Corpo grosso (c1=104,
   //    corpo 3), lowerWick=101-98=3 < 3*3=9 -> 0.
   int w1 = SegnaleCRT_Calc(101.0,104.0,104.5,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   //    stesso pattern ma con wick lungo (corpo 0.5) -> passa (midGate off).
   int w2 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   PrintFormat("[CRTTS][AUTOTEST] wick: corto=%d(0) lungo=%d(1)", w1,w2);
   if(!(w1==0 && w2==1)) falliti++;

   //--- 4. GATE 50%: bull con h1=106 (>= mid2 105) -> il gate SPEGNE;
   //    con gate off invece passa.
   int g1 = SegnaleCRT_Calc(101.0,101.5,106.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true ,2);
   int g2 = SegnaleCRT_Calc(101.0,101.5,106.0,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   PrintFormat("[CRTTS][AUTOTEST] midGate: on=%d(0) off=%d(1)", g1,g2);
   if(!(g1==0 && g2==1)) falliti++;

   //--- 5. LATO: pattern bull con side=1 (solo short) -> 0; side=0 -> 1.
   int s1 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,1);
   int s2 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,0);
   PrintFormat("[CRTTS][AUTOTEST] side: bullSoloShort=%d(0) bullSoloLong=%d(1)", s1,s2);
   if(!(s1==0 && s2==1)) falliti++;

   //--- 6. SL wick + PAVIMENTO (mai a zero: R109).
   double sl_l=SlWick_Calc(true , 98.0,102.0, 0.0);   // long -> 98.00
   double sl_s=SlWick_Calc(false, 98.0,113.0, 0.0);   // short -> 113.00
   double p1=PavimentoSL_Calc(true ,101.5, 98.0, 5.0);  // dist 3.5 < 5 -> 96.50
   double p2=PavimentoSL_Calc(true ,101.5, 98.0, 2.0);  // dist 3.5 >= 2 -> 98.00
   double p3=PavimentoSL_Calc(false,108.5,113.0, 2.0);  // dist 4.5 >= 2 -> 113.00
   PrintFormat("[CRTTS][AUTOTEST] SL: long=%.2f(98.00) short=%.2f(113.00) | pav %.2f(96.50) %.2f(98.00) %.2f(113.00)",
               sl_l,sl_s,p1,p2,p3);
   if(!(MathAbs(sl_l-98.0)<1e-6 && MathAbs(sl_s-113.0)<1e-6 &&
        MathAbs(p1-96.5)<1e-6 && MathAbs(p2-98.0)<1e-6 && MathAbs(p3-113.0)<1e-6)) falliti++;

   //--- 7. TP1 (mid di C2) e TP2 (estremo opposto di C2).
   double tp1=Tp1Mid_Calc(111.0,99.0);          // 105.00
   double tp2L=Tp2Ext_Calc(true ,111.0,99.0);   // long -> 111.00
   double tp2S=Tp2Ext_Calc(false,111.0,99.0);   // short -> 99.00
   PrintFormat("[CRTTS][AUTOTEST] TP: mid=%.2f(105.00) tp2Long=%.2f(111.00) tp2Short=%.2f(99.00)",
               tp1,tp2L,tp2S);
   if(!(MathAbs(tp1-105.0)<1e-6 && MathAbs(tp2L-111.0)<1e-6 && MathAbs(tp2S-99.0)<1e-6)) falliti++;

   //--- 8. FLAT + conversione punti indice.
   bool fl1=DopoOrarioFlat_Calc(22, 0,22,0);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(21,59,22,0);   // prima -> no
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.00
   PrintFormat("[CRTTS][AUTOTEST] flat esatto=%d(1) prima=%d(0) | conv=%.2f(5.00)",
               (int)fl1,(int)fl2,ip1);
   if(!(fl1 && !fl2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   //--- 9. GATE DI REGIME: passa SOLO con ADX<=max AND ATR>=min. Le quattro
   //    combinazioni (adxMax=30, atrMin=40): solo (adx ok, atr ok) -> true.
   bool rg1=RegimeGate_Calc(25.0, 50.0, 30.0, 40.0);   // adx<=max, atr>=min -> true
   bool rg2=RegimeGate_Calc(35.0, 50.0, 30.0, 40.0);   // adx>max            -> false
   bool rg3=RegimeGate_Calc(25.0, 30.0, 30.0, 40.0);   // atr<min            -> false
   bool rg4=RegimeGate_Calc(35.0, 30.0, 30.0, 40.0);   // entrambi ko        -> false
   PrintFormat("[CRTTS][AUTOTEST] gateRegime: okok=%d(1) adxAlto=%d(0) atrBasso=%d(0) entrambiKo=%d(0)",
               (int)rg1,(int)rg2,(int)rg3,(int)rg4);
   if(!(rg1 && !rg2 && !rg3 && !rg4)) falliti++;

   Print("[CRTTS][AUTOTEST] esito motore: ", (falliti==0
         ? "OTTO BLOCCHI SU OTTO, il motore ragiona come i sorgenti."
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
//| CHIUSA, con PREZZO D'INGRESSO E DI USCITA, per calcolare la        |
//| mediana del take in PUNTI INDICE prima di leggere qualunque PF.    |
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
   double stats[23];
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
   stats[14] = (double)gCntGestione;       // Ret Posizione Aperta
   stats[15] = (double)gCntNoDati;         // Ret No Dati
   stats[16] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[17] = (double)gCntFuoriOrario;    // Ret Fuori Orario
   stats[18] = (double)gCntNoPattern;      // Ret No Pattern
   stats[19] = (double)gCntLongCand;       // Long Cand
   stats[20] = (double)gCntShortCand;      // Short Cand
   stats[21] = (double)gCntApri;           // Apri Chiamate
   stats[22] = (double)gCntGateBloccati;   // Ret Gate Regime (pattern soppressi dal gate)

   PrintFormat("[CRTTS][DIAG] OnNewBar=%I64d | ret: posAperta=%I64d noDati=%I64d maxTrades=%I64d fuoriOrario=%I64d noPattern=%I64d gateRegime=%I64d | longCand=%I64d shortCand=%I64d apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoDati, gCntMaxTrades,
               gCntFuoriOrario, gCntNoPattern, gCntGateBloccati, gCntLongCand, gCntShortCand, gCntApri);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Posizione Aperta,Ret No Dati,Ret Max Trades,Ret Fuori Orario,Ret No Pattern,Long Cand,Short Cand,Apri Chiamate,Ret Gate Regime";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
