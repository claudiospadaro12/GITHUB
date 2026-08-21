//+------------------------------------------------------------------+
//|                                          ABTG_FiboH4_Corso.mq5    |
//|   FIBO H4 -- LA GEOMETRIA DEL CORSO (lezioni 18-20)               |
//|   Implementazione FEDELE alla spec ricostruita dalle 3            |
//|   trascrizioni (28.312 caratteri, lette riga per riga).           |
//|                                                                   |
//|   FONTE VINCOLANTE:                                               |
//|     backtest_pipeline\prove\FIBOH4_CORSO_SPEC.md                  |
//|   REFERTO DI ANALISI:                                             |
//|     backtest_pipeline\caccia_strategie\                           |
//|         ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md               |
//|   CRITERI DEL ROUND (da FIRMARE prima di leggere i numeri):       |
//|     backtest_pipeline\risultati_archivio\R93_CRITERI.md           |
//|                                                                   |
//|   v1.00 - 21/08/2026                                              |
//+------------------------------------------------------------------+
//
//  PERCHE' ESISTE QUESTO FILE, E NON UN RITOCCO DELL'ALTRO
//  ---------------------------------------------------------------------
//  Nel repo esiste gia' ABTG_FiboH4_Multi.mq5. NON E' QUESTA STRATEGIA:
//  e' una strategia diversa che porta lo stesso nome. Le tre divergenze
//  di GEOMETRIA, misurate il 18/08/2026:
//
//                       ABTG_FiboH4_Multi      il CORSO          fattore
//    distanza ordini    1,0 x range            0,10 x range      ~x10
//    target             estremo opposto        livello 100        x2,1
//    stop               4,236 fisso            1 dei 7 metodi    ~x4
//
//  Il "0/8 promossi" della coda fascia B (10-11/08/2026,
//  REFERTO_CODA_FASCIA_B.md riga 30) ha bocciato QUELLA geometria.
//  Non ha mai misurato questa. Claudio ha deciso il 21/08/2026
//  ("1,2,3 si guardano") che questa va misurata.
//
//  >>> ABTG_FiboH4_Multi NON VA TOCCATO: e' l'altra ipotesi del round
//      e serve come termine di paragone. Magic 771602 (quello) contro
//      771640 (questo): due EA, due magic, mai lo stesso.
//
//  E UNA COSA CHE VA DETTA PRIMA DI QUALUNQUE NUMERO: che la geometria
//  del corso sia MIGLIORE non lo sa nessuno. E' un'IPOTESI DIVERSA, non
//  una correzione. Puo' benissimo perdere anche lei.
//
//  ---------------------------------------------------------------------
//  🔴 LE 4 RICHIESTE A CLAUDIO CHE RESTANO APERTE
//  (finche' non arrivano, i numeri accanto restano ASSUNZIONI NOSTRE)
//  ---------------------------------------------------------------------
//  R1. LE SLIDE dei moduli FiboH4 e Media200. Citate 10 volte nelle
//      lezioni, mai lette. Sul Breakout le slide alzarono la
//      meccanizzabilita' dal 71% all'87%.
//      -> resta assunzione: praticamente tutto quello che sta sotto.
//  R2. SCREENSHOT del Fibonacci tracciato CON LA LINEA "100" VISIBILE.
//      -> chiude il fattore x2,1: dice se il livello 100 e' davvero la
//         BASE del pattern (come deduciamo) o l'estremo opposto.
//      -> finche' manca, InpTargetMode e' un'ASSUNZIONE [INFERITO alto].
//  R3. SCREENSHOT del pannello Fibo con le 4 descrizioni (1,88 / 1,78 /
//      2,88 / 2,78).
//      -> chiude il fattore x10: dice se "entry zone" e' una BANDA di
//         0,10 x range (come deduciamo dai 5-10 pip dettati) o due
//         livelli lontani 1,0 x range.
//      -> finche' manca, la banda e' un'ASSUNZIONE [INFERITO].
//  R4. IL FUSO della piattaforma del corso. Il modulo base dice
//      "GMT, due ore indietro dall'Italia d'estate"; il nostro repo usa
//      "server = Italia meno UNA ora". Stesso broker (bcmmarkets.com),
//      un'ora di differenza, conflitto agli atti (PIANO_PROP B3, M15a).
//      -> gli orari 08:00 e 18:30-19:00 valgono a meno di UN'ORA.
//      -> finche' manca, InpCutoffHour e' un'ASSUNZIONE.
//
//  ---------------------------------------------------------------------
//  MAPPA REGOLA <-> CODICE (verificabile riga per riga)
//  ---------------------------------------------------------------------
//  spec    | regola del corso                       | dove sta nel codice
//  --------|----------------------------------------|--------------------
//  par.2   | timeframe H4, "solo H4"                | InpTF (default PERIOD_H4)
//  par.2   | universo: tutti i cross, meglio        | fuori dall'EA: un simbolo
//          | GBPUSD e USDJPY                        | per passata (file prova)
//  par.2   | weekend MAI aperti                     | InpFridayClose (+ ora)
//  par.2.1 | cancellare i pendenti 18:30-19:00      | InpUseCutoff/InpCutoffHour
//  par.3.1 | i 4 livelli 1,88 1,78 2,88 2,78        | InpEZ1far/near InpEZ2far/near
//  par.3.2 | "entry zone" = BANDA, 2 ordini sui     | PiazzaZona(): 2 limit sui
//          | suoi due bordi                         | due bordi della banda
//  par.3.3 | livello 100 = BASE del pattern         | LivelloFibo(): P(k)=B+k(A-B)
//          | = TARGET FINALE                        | target = P(1.0)
//  par.4.1 | precondizione: FINE DI UN TREND        | InpUseTrendFilter +
//          | (mai laterale)                         | TrendDaSwing()
//  par.4.1b| trend = successione di top e bottom;   | TrendDaSwing(): pivot a
//          | laterale = qualunque altro caso        | InpSwingBars per lato
//  par.4.2 | engulfing TOTALE, ombre comprese       | EngulfRialzista/Ribassista
//  par.4.2 | 1 candela, oppure la somma di 2 (max 2)| InpAllowTwoCandle
//  par.4.2 | lookback 8-12 candele                  | InpEngulfLookback (default 10)
//  par.4.3 | niente candele "molto ampie"           | InpMaxEngulfAtr (numero NOSTRO)
//  par.4.4 | ancoraggio del range: 2 letture        | InpAncoraggio (A/B dichiarato)
//  par.5   | 2 ordini pendenti LIMITE               | PiazzaZona(): BuyLimit/SellLimit
//  par.5   | size 1/3 il primo, 2/3 il secondo      | InpFrazionePrimo (0,3333)
//  par.5   | distanza minima prezzo->zona 50-60 pip | InpMinDistPips (default 50)
//  par.5   | zona preferita: la SECONDA             | InpZona (default SOLO_EZ2)
//  par.5   | prezzo addosso a EZ1 -> solo EZ2       | InpZona + InpMinDistPips
//  par.6   | 7 metodi di stop, nessun criterio      | InpSLMode: i 4 misurabili
//          | di scelta -> VA MESSO A SWEEP          | (RR 1:1 / ATR / 4,236 / candela)
//  par.7   | primo target = la PRIMA entry zone,    | GestisciPosizioni():
//          | li' 50% + stop in pari                 | InpParzialePct + BE
//  par.7   | target finale = il 100, chiusura totale| TP dell'ordine = P(1.0)
//  par.7.1 | contraddizione lez.19 vs lez.20        | risolta a favore della 20,
//          |                                        | vedi assunzione A6
//  par.8   | filtro notizie OBBLIGATORIO, per       | InpUseNewsFilter (default
//          | VALUTA, deroga a >= 100 pip            | FALSE: si MISURA, non si
//          |                                        | accende per fede) + il
//          |                                        | blocco news in fondo
//  par.9   | rischio: MAI PRONUNCIATO in 3 lezioni  | InpRiskPercent = 0,65
//          |                                        | (0,65% DI CASA, assunzione A7)
//
//  ---------------------------------------------------------------------
//  LE 8 ASSUNZIONI DICHIARATE (sono NOSTRE, non "il corso")
//  ---------------------------------------------------------------------
//  A1. LA BANDA. "entry zone" come banda 1,78-1,88 e' [INFERITO], non
//      trascritto. Regge su tre fatti (le descrizioni date solo ai due
//      livelli "entry zone"; il "sopra e sotto" che ha senso solo su una
//      banda; e l'aritmetica 0,10 x range = 5-10 pip su range 50-100,
//      che coincide coi "circa 5 pip / posso stabilire 10 pip" dettati).
//      Chiusa da R3.
//  A2. IL LIVELLO 100 = base del pattern. [INFERITO alto] dalla
//      convenzione MT4 del Fibonacci Retracement e dalla coerenza della
//      scala EZ2 -> EZ1 -> 100. Chiusa da R2.
//  A3. QUANTI SWING guardare indietro per dire "trend": il corso
//      definisce il trend sugli swing ma NON dice quanti. Qui 2 coppie
//      (InpSwingCoppie). E' l'unica scelta nostra dentro una regola che
//      per il resto e' del corso.
//  A4. InpMaxEngulfAtr = 3,0 ATR: il corso dice "mai le candele con
//      movimenti importanti" e NON da' una soglia. Il 3,0 e' un numero
//      NOSTRO, ereditato da ABTG_FiboH4_Multi.
//  A5. L'ANCORAGGIO del range (spec par.4.4): "il minimo successivo" ha
//      due letture. Default = quella di ABTG_FiboH4_Multi, cosi' il
//      confronto fra i due EA resta leggibile. L'altra e' un input.
//  A6. QUANDO SI DIMEZZA: lez.19 dice "al 100", lez.20 dice "alla prima
//      entry zone". Risolta a favore della 20: dimezzare sul target
//      finale non lascia niente da far correre. Dichiarata, non nascosta.
//  A7. IL RISCHIO: mai pronunciato in 3 lezioni. Si usa lo 0,65% DI
//      CASA (firma del 18/08), NON l'1% preso in prestito dal modulo
//      Breakout. Con 2 ordini la frazione si SPARTISCE, non si somma.
//  A8. LOOKBACK ENGULFING 10: il corso dice "8-10", "8, 10, 12". Si
//      prende il centro e si mette a sweep se serve.
//
//  QUELLO CHE QUESTO EA NON FA, e non e' una dimenticanza
//  ---------------------------------------------------------------------
//   - i metodi di stop 1, 2 e 6 del corso (livello tecnico, sotto una
//     media, prese di liquidita'): come dettati sono LETTURE VISIVE,
//     non regole. Meccanizzarli sarebbe inventare;
//   - la "conferma tecnica" sui livelli del passato (par.5): idem;
//   - la deroga "se siamo a 35 pip devi stare li' a guardare" (par.5):
//     e' legata alla presenza umana davanti al monitor;
//   - il gate "quando inizi a essere pratico" sul lookback (par.4.2);
//   - la "terza zona" della lez.19 (par.7.2): quattro livelli fanno DUE
//     zone. E' un lapsus, non una regola;
//   - lo squilibrio "solo gli ordini sotto" (par.5): nessuna soglia.
//     Sono inclinazioni umane, non regole. Vanno chieste, non inventate.
//
//  NON COMPILATO NE' BACKTESTATO da chi lo ha scritto: questo ambiente
//  non ha MetaEditor ne' Strategy Tester. Si compila con F7 in
//  MetaEditor (0 errori 0 warning) PRIMA di qualunque corsa, e
//  l'autotest si legge ESEGUENDO un test SINGOLO nel tester.
//+------------------------------------------------------------------+
#property copyright "ABTG - Fibo H4 del corso (spec 18/08/2026)"
#property version   "1.00"
#property description "Fibo H4 fedele al corso | banda 1,78-1,88 e 2,78-2,88 | target livello 100 | stop a sweep"
#property strict

#include <Trade/Trade.mqh>
//--- firme B1/C1 del 18/08: la guardia del conto, lato EA.
//    Fail-open: input spento / canale inesistente / battito vecchio.
//    Nel tester e' INERTE, quindi i numeri restano confrontabili.
#include <ABTG_PausaGuardian.mqh>
CTrade gTrade;

//==================================================================
//  ENUM
//==================================================================
enum ENUM_FIBO_ZONA
  {
   ZONA_SOLO_EZ2 = 0,   // solo la seconda (la preferita dal corso)
   ZONA_SOLO_EZ1 = 1,   // solo la prima
   ZONA_EZ2_POI_EZ1 = 2 // la seconda; se troppo lontana, la prima
  };

enum ENUM_FIBO_SL
  {
   SL_RR_1A1    = 0,   // metodo 4: distanza pari al primo obiettivo (R:R 1:1)
   SL_ATR       = 1,   // metodo 5: N x ATR
   SL_FIBO_4236 = 2,   // metodo 7: oltre il livello 4,236
   SL_CANDELA   = 3    // metodo 3: oltre max/min della candela del pattern
  };

enum ENUM_FIBO_ANCORA
  {
   ANCORA_COPERTA   = 0, // estremo della candela COPERTA (come ABTG_FiboH4_Multi)
   ANCORA_COPERTURA = 1  // estremo della candela CHE COPRE
  };

//==================================================================
//  INPUT
//==================================================================
input group "=== Impianto (spec par.2) ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;      // TF operativo. Il corso: "solo H4"
input int    InpMaxPositions = 1;             // posizioni contemporanee su questo simbolo

input group "=== Precondizione: FINE DI UN TREND (spec par.4.1 e 4.1-bis) ==="
input bool   InpUseTrendFilter = true;        // il corso la rende PRECONDIZIONE ASSOLUTA
input int    InpSwingBars      = 3;           // barre per lato dello swing ("due, meglio tre")
input int    InpSwingCoppie    = 2;           // quante coppie di swing confrontare (ASSUNZIONE A3)
input int    InpTrendLookback  = 150;         // barre in cui cercare gli swing

input group "=== Pattern engulfing (spec par.4.2) ==="
input int    InpEngulfLookback = 10;          // 8-12 nel corso (ASSUNZIONE A8: centro)
input bool   InpAllowTwoCandle = true;        // "dalla prima o dalla somma delle due, massimo due"
input double InpMinEngulfBodyPct = 25.0;      // corpo minimo % del range (numero NOSTRO)
input double InpMaxEngulfAtr   = 3.0;         // scarta i pattern troppo ampi (ASSUNZIONE A4)
input int    InpAtrPeriod      = 14;
input ENUM_FIBO_ANCORA InpAncoraggio = ANCORA_COPERTA; // ASSUNZIONE A5
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== I 4 livelli Fibo dettati (spec par.3.1) ==="
input double InpEZ1near = 1.78;               // bordo VICINO della 1a entry zone
input double InpEZ1far  = 1.88;               // bordo LONTANO della 1a entry zone
input double InpEZ2near = 2.78;               // bordo VICINO della 2a entry zone
input double InpEZ2far  = 2.88;               // bordo LONTANO della 2a entry zone
input double InpFibo4236 = 4.236;             // "l'ultimo baluardo"
input double InpTargetLevel = 1.00;           // TARGET FINALE = livello 100 (ASSUNZIONE A2)

input group "=== Piazzamento (spec par.5) ==="
input ENUM_FIBO_ZONA InpZona = ZONA_SOLO_EZ2; // il corso: "l'entry zone migliore e' la seconda"
input double InpMinDistPips  = 50.0;          // "almeno 50-60 pip", ripetuto 4 volte
input double InpFrazionePrimo = 0.3333;       // "un terzo la prima, due terzi la seconda"
input int    InpPendingExpiryBars = 6;        // vita dei pendenti in barre (numero NOSTRO)

input group "=== Stop loss -- I 7 METODI DEL CORSO, i 4 misurabili (spec par.6) ==="
input ENUM_FIBO_SL InpSLMode = SL_RR_1A1;     // il corso NON sceglie: QUESTO E' L'ASSE DA SWEEP
input double InpSLatr        = 1.0;           // per SL_ATR
input double InpSLbufferPips = 3.0;           // cuscinetto oltre il livello scelto

input group "=== Gestione (spec par.7) ==="
input double InpParzialePct = 50.0;           // "chiudi meta' posizione" al primo obiettivo
input bool   InpBreakeven   = true;           // "prendi lo stop, lo porti in pari"

input group "=== Cancelli prop del corso (spec par.2.1) -- ORA SERVER ==="
input bool   InpUseCutoff   = true;           // "gli ordini non eseguiti entro le 18.30-19 vanno cancellati"
input int    InpCutoffHour  = 17;             // 18:45 IT -> 17:45 server (ASSUNZIONE, vedi R4)
input int    InpCutoffMin   = 45;
input bool   InpFridayClose = true;           // "mai e qua dico mai aperto durante il weekend"
input int    InpFridayCloseHour = 21;
input int    InpFridayCloseMin  = 50;

input group "=== Filtro notizie (spec par.8) -- OBBLIGATORIO nel corso, qui si MISURA ==="
input bool   InpUseNewsFilter = false;        // default FALSE: si accende in una CELLA, non per fede
input string InpNewsFile      = "abtg_news.csv";
input bool   InpNewsCommon    = true;         // Common\Files: l'unica strada che regge nel tester
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 60;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;         // minuti da SOMMARE per portare il CSV in ORA SERVER
input bool   InpNewsPerCurrency = true;       // il corso: esclusione PER VALUTA (num. o denom.)
input bool   InpNewsCancelPendings = true;    // il corso: "gli ordini vanno tolti"
input double InpNewsDerogaPips = 100.0;       // deroga del corso: "100, 150 pip"

input group "=== Rischio (spec par.9: MAI PRONUNCIATO -> 0,65% di casa) ==="
input double InpRiskPercent = 0.65;           // ASSUNZIONE A7. NON l'1% del modulo Breakout

input group "=== Generali ==="
input string InpComment   = "FIBOCORSO";
input long   InpMagic     = 771640;           // blocco libero, verificato nel repo il 21/08
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
input bool   InpUsaGuardian = true;
input bool   InpAutoTest    = true;

//==================================================================
//  STATO
//==================================================================
int      gAtr = INVALID_HANDLE;
datetime gLastBar = 0;

//--- geometria del setup vivo (serve al parziale sul PRIMO obiettivo)
double   gTargetFinale = 0.0;   // livello 100
double   gPrimoTarget  = 0.0;   // bordo lontano della PRIMA entry zone
bool     gSetupLong    = false;

//--- news
datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;
bool     gNewsSorted=true; int gNewsScartate=0; int gNewsSottoSoglia=0;
string   gNewsDove="(mai aperto)";
long     gNewsBlocchi=0, gNewsBarreViste=0, gNewsPendCancellati=0;

//--- conteggi (canarini di R93: si leggono PRIMA dei profitti)
long     gPatternVisti=0, gScartatiLaterale=0, gScartatiAmpiezza=0;
long     gScartatiDistanza=0, gSetupPiazzati=0;

//--- metrica di famiglia
double   gWorstDayPct=0.0, gEqInizioGiorno=0.0; int gGiornoCorrente=-1;

void Log(string m){ if(InpVerbose) Print("[FIBOCORSO] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(30);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gAtr = iATR(_Symbol, InpTF, InpAtrPeriod);
   if(gAtr == INVALID_HANDLE){ Print("[FIBOCORSO] ATR non disponibile: non parto."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   gEqInizioGiorno = AccountInfoDouble(ACCOUNT_EQUITY);
   if(InpAutoTest) AutoTestFiboCorso();
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gAtr != INVALID_HANDLE) IndicatorRelease(gAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   GestisciPosizioni();
   CutoffCheck();
   NewsCancelCheck();
   FridayCloseCheck();

   datetime t = iTime(_Symbol, InpTF, 0);
   if(t <= 0 || t == gLastBar) return;
   gLastBar = t;
   OnNuovaBarra();
  }

//==================================================================
//  UTILITY
//==================================================================
double PipSize()
  {
   int d = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pt = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   return (d == 3 || d == 5) ? pt * 10.0 : pt;
  }

double AtrVal()
  {
   double a[1];
   if(CopyBuffer(gAtr, 0, 1, 1, a) != 1) return(0);
   return(a[0]);
  }

double Norma(double price)
  {
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   int dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(ts <= 0) return(NormalizeDouble(price, dg));
   return(NormalizeDouble(MathRound(price / ts) * ts, dg));
  }

bool SpreadOK()
  {
   if(InpMaxSpread <= 0) return(true);
   return(SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) <= InpMaxSpread);
  }

int ContaPosizioni()
  {
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic) n++;
     }
   return(n);
  }

bool HaPendenti()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong t = OrderGetTicket(i);
      if(t == 0) continue;
      if(OrderGetString(ORDER_SYMBOL) == _Symbol &&
         OrderGetInteger(ORDER_MAGIC) == InpMagic) return(true);
     }
   return(false);
  }

void CancellaPendenti()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong t = OrderGetTicket(i);
      if(t == 0) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol ||
         OrderGetInteger(ORDER_MAGIC) != InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

double LottoDaRischio(double slDist, double riskPct)
  {
   if(slDist <= 0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE) * riskPct / 100.0;
   // perdita per lotto CHIESTA AL BROKER, non dedotta dal tick value nudo:
   // su alcuni simboli il tick value arriva non convertito in valuta conto
   // e il lotto finisce sempre al minimo (lezione pagata l'08/08 su 225JPY).
   double lossPerLot = 0;
   double px = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double prof = 0;
   if(px > slDist && OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, px, px - slDist, prof) && prof < 0)
      lossPerLot = -prof;
   if(lossPerLot <= 0)
     {
      double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      double tsz = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tv <= 0 || tsz <= 0) return(0);
      lossPerLot = (slDist / tsz) * tv;
     }
   if(lossPerLot <= 0) return(0);
   double lot = risk / lossPerLot;
   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP); if(st <= 0) st = 0.01;
   lot = MathFloor(lot / st) * st;
   return(MathMax(mn, MathMin(mx, lot)));
  }

double NormVol(double v)
  {
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(st <= 0) st = 0.01;
   v = MathFloor(v / st) * st;
   return(v < mn ? 0 : v);
  }

//==================================================================
//  spec par.4.1-bis -- IL TREND SECONDO IL CORSO
//  "Un trend e' una successione di top e di bottom. Rialzista quando
//   top e bottom SALGONO, ribassista quando SCENDONO, laterale in
//   QUALUNQUE ALTRO CASO."  (modulo base, lez. 4)
//  Il top/bottom e' uno swing con "due, meglio ancora tre" candele per
//  lato -> InpSwingBars.
//  Ritorna: +1 rialzista, -1 ribassista, 0 laterale/indeterminato.
//==================================================================
int TrendDaSwing(int daBarra)
  {
   int N = InpSwingBars;
   if(N < 1) N = 1;
   int need = InpSwingCoppie + 1;      // servono N+1 massimi e N+1 minimi
   if(need < 2) need = 2;

   double ph[]; double pl[];
   ArrayResize(ph, 0); ArrayResize(pl, 0);

   int fine = daBarra + InpTrendLookback;
   int disponibili = Bars(_Symbol, InpTF);
   if(fine > disponibili - N - 1) fine = disponibili - N - 1;

   for(int j = daBarra + N; j <= fine && (ArraySize(ph) < need || ArraySize(pl) < need); j++)
     {
      double hj = iHigh(_Symbol, InpTF, j);
      double lj = iLow(_Symbol, InpTF, j);
      bool topOk = true, botOk = true;
      for(int k = 1; k <= N; k++)
        {
         if(iHigh(_Symbol, InpTF, j - k) >= hj || iHigh(_Symbol, InpTF, j + k) >= hj) topOk = false;
         if(iLow(_Symbol, InpTF, j - k)  <= lj || iLow(_Symbol, InpTF, j + k)  <= lj) botOk = false;
         if(!topOk && !botOk) break;
        }
      if(topOk && ArraySize(ph) < need){ int n = ArraySize(ph); ArrayResize(ph, n + 1); ph[n] = hj; }
      if(botOk && ArraySize(pl) < need){ int n = ArraySize(pl); ArrayResize(pl, n + 1); pl[n] = lj; }
     }

   if(ArraySize(ph) < 2 || ArraySize(pl) < 2) return(0);   // non misurabile = laterale

   // ph[0] e pl[0] sono i piu' RECENTI (il ciclo va indietro nel tempo).
   bool topSalgono = true, topScendono = true;
   bool botSalgono = true, botScendono = true;
   int coppie = MathMin(ArraySize(ph), ArraySize(pl)) - 1;
   if(coppie > InpSwingCoppie) coppie = InpSwingCoppie;
   for(int c = 0; c < coppie; c++)
     {
      if(!(ph[c] > ph[c + 1])) topSalgono = false;
      if(!(ph[c] < ph[c + 1])) topScendono = false;
      if(!(pl[c] > pl[c + 1])) botSalgono = false;
      if(!(pl[c] < pl[c + 1])) botScendono = false;
     }
   if(topSalgono && botSalgono)  return(+1);
   if(topScendono && botScendono) return(-1);
   return(0);   // "QUALUNQUE ALTRO CASO" = laterale
  }

//==================================================================
//  spec par.4.2 -- ENGULFING TOTALE, OMBRE COMPRESE
//  "questa candela coperta totalmente, compresi gli spike, deve essere
//   completamente coperta, altrimenti passo oltre"
//  1 candela, oppure la SOMMA di 2 (massimo due).
//  Ritorna gli ancoraggi del pattern: estremo alto e estremo basso.
//==================================================================
bool EngulfRialzista(int i, double &alto, double &basso)
  {
   double oi = iOpen(_Symbol, InpTF, i), ci = iClose(_Symbol, InpTF, i);
   double hi = iHigh(_Symbol, InpTF, i), li = iLow(_Symbol, InpTF, i);
   double op = iOpen(_Symbol, InpTF, i + 1), cp = iClose(_Symbol, InpTF, i + 1);
   double hp = iHigh(_Symbol, InpTF, i + 1), lp = iLow(_Symbol, InpTF, i + 1);
   double rng = hi - li; if(rng <= 0) return(false);
   bool corpoOk = (MathAbs(ci - oi) >= InpMinEngulfBodyPct / 100.0 * rng);
   bool precRibassista = (cp < op);
   bool copreTutto = (hi >= hp && li <= lp && ci > oi);   // ombre comprese
   if(precRibassista && copreTutto && corpoOk)
     {
      alto  = hp;
      // ASSUNZIONE A5: quale minimo ancora il range (spec par.4.4)
      basso = (InpAncoraggio == ANCORA_COPERTA) ? li : lp;
      return(true);
     }
   if(InpAllowTwoCandle && i >= 2)
     {
      double h2 = MathMax(hi, iHigh(_Symbol, InpTF, i - 1));
      double l2 = MathMin(li, iLow(_Symbol, InpTF, i - 1));
      double c2 = iClose(_Symbol, InpTF, i - 1);
      if(precRibassista && h2 >= hp && l2 <= lp && c2 > op)
        {
         alto  = hp;
         basso = (InpAncoraggio == ANCORA_COPERTA) ? l2 : lp;
         return(true);
        }
     }
   return(false);
  }

bool EngulfRibassista(int i, double &alto, double &basso)
  {
   double oi = iOpen(_Symbol, InpTF, i), ci = iClose(_Symbol, InpTF, i);
   double hi = iHigh(_Symbol, InpTF, i), li = iLow(_Symbol, InpTF, i);
   double op = iOpen(_Symbol, InpTF, i + 1), cp = iClose(_Symbol, InpTF, i + 1);
   double hp = iHigh(_Symbol, InpTF, i + 1), lp = iLow(_Symbol, InpTF, i + 1);
   double rng = hi - li; if(rng <= 0) return(false);
   bool corpoOk = (MathAbs(ci - oi) >= InpMinEngulfBodyPct / 100.0 * rng);
   bool precRialzista = (cp > op);
   bool copreTutto = (hi >= hp && li <= lp && ci < oi);
   if(precRialzista && copreTutto && corpoOk)
     {
      alto  = (InpAncoraggio == ANCORA_COPERTA) ? hi : hp;
      basso = lp;
      return(true);
     }
   if(InpAllowTwoCandle && i >= 2)
     {
      double h2 = MathMax(hi, iHigh(_Symbol, InpTF, i - 1));
      double l2 = MathMin(li, iLow(_Symbol, InpTF, i - 1));
      double c2 = iClose(_Symbol, InpTF, i - 1);
      if(precRialzista && h2 >= hp && l2 <= lp && c2 < op)
        {
         alto  = (InpAncoraggio == ANCORA_COPERTA) ? h2 : hp;
         basso = lp;
         return(true);
        }
     }
   return(false);
  }

//==================================================================
//  spec par.3.3 -- LA GEOMETRIA DEL FIBONACCI
//  Convenzione MT4: si traccia da A (primo clic) a B (secondo clic),
//  livello 0,0 = B, livello 100 = A, i livelli > 1 si estendono OLTRE A.
//     P(k) = B + k * (A - B)
//  LONG : si traccia MINIMO -> MASSIMO  (A = basso, B = alto)
//         P(k) = alto - k * range          range = alto - basso
//         P(1,00) = basso   <-- il "100" e' la BASE del pattern
//  SHORT: specularmente     (A = alto, B = basso)
//         P(k) = basso + k * range
//==================================================================
double LivelloFibo(bool isLong, double alto, double basso, double k)
  {
   double range = alto - basso;
   return(isLong ? (alto - k * range) : (basso + k * range));
  }

//==================================================================
//  IL MOTORE, una volta per barra chiusa
//==================================================================
void OnNuovaBarra()
  {
   if(ContaPosizioni() > 0 || HaPendenti()) return;
   if(ContaPosizioni() >= InpMaxPositions) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
   if(!SpreadOK()) return;

   double atr = AtrVal(); if(atr <= 0) return;

   for(int i = 1; i <= InpEngulfLookback; i++)
     {
      double alto, basso;
      bool isLong = false, trovato = false;

      if(InpAllowLong && EngulfRialzista(i, alto, basso)) { isLong = true;  trovato = true; }
      else if(InpAllowShort && EngulfRibassista(i, alto, basso)) { isLong = false; trovato = true; }
      if(!trovato) continue;

      gPatternVisti++;

      // spec par.4.3 -- niente candele "molto ampie" (ASSUNZIONE A4: 3 ATR)
      if((alto - basso) > InpMaxEngulfAtr * atr){ gScartatiAmpiezza++; continue; }

      // spec par.4.1 -- PRECONDIZIONE: solo alla FINE DI UN TREND.
      // Un pattern rialzista vale solo se prima c'era un trend RIBASSISTA
      // (e viceversa). Laterale = si scarta a priori.
      if(InpUseTrendFilter)
        {
         int tr = TrendDaSwing(i + 1);
         if(tr == 0) { gScartatiLaterale++; continue; }
         if(isLong  && tr != -1){ gScartatiLaterale++; continue; }
         if(!isLong && tr != +1){ gScartatiLaterale++; continue; }
        }

      if(PiazzaSetup(isLong, alto, basso)) return;
     }
  }

//==================================================================
//  spec par.3.2 + par.5 -- LE DUE ENTRY ZONE E I DUE ORDINI
//  Ogni "entry zone" e' una BANDA (ASSUNZIONE A1): i due ordini vanno
//  sui suoi DUE BORDI, non su due livelli lontani 1,0 x range.
//  Size: 1/3 sul bordo vicino, 2/3 sul bordo lontano.
//==================================================================
bool PiazzaSetup(bool isLong, double alto, double basso)
  {
   double range = alto - basso;
   if(range <= 0) return(false);
   double pip = PipSize();
   double px = isLong ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                      : SymbolInfoDouble(_Symbol, SYMBOL_BID);

   double ez1n = LivelloFibo(isLong, alto, basso, InpEZ1near);
   double ez1f = LivelloFibo(isLong, alto, basso, InpEZ1far);
   double ez2n = LivelloFibo(isLong, alto, basso, InpEZ2near);
   double ez2f = LivelloFibo(isLong, alto, basso, InpEZ2far);
   double target = LivelloFibo(isLong, alto, basso, InpTargetLevel);   // il 100

   // spec par.5: "una distanza minima di almeno 50-60 pip" fra il prezzo
   // e la zona. Si misura sul bordo VICINO (il primo che il prezzo tocca).
   double dist1 = MathAbs(px - ez1n) / pip;
   double dist2 = MathAbs(px - ez2n) / pip;

   bool usaEZ2 = false, usaEZ1 = false;
   if(InpZona == ZONA_SOLO_EZ2) usaEZ2 = (dist2 >= InpMinDistPips);
   else if(InpZona == ZONA_SOLO_EZ1) usaEZ1 = (dist1 >= InpMinDistPips);
   else { if(dist2 >= InpMinDistPips) usaEZ2 = true; else if(dist1 >= InpMinDistPips) usaEZ1 = true; }

   if(!usaEZ2 && !usaEZ1){ gScartatiDistanza++; return(false); }

   double bordoVicino = usaEZ2 ? ez2n : ez1n;
   double bordoLontano = usaEZ2 ? ez2f : ez1f;

   // spec par.7: il PRIMO obiettivo e' la PRIMA entry zone (se si e'
   // entrati sulla seconda). Se si entra gia' sulla prima, il corso non
   // dice quale sia il primo obiettivo -> non c'e' parziale (dichiarato).
   gPrimoTarget  = usaEZ2 ? ez1f : 0.0;
   gTargetFinale = target;
   gSetupLong    = isLong;

   double sl = CalcolaStop(isLong, alto, basso, bordoLontano, usaEZ2 ? ez1f : target);
   if(sl <= 0) return(false);

   double r1 = InpRiskPercent * InpFrazionePrimo;
   double r2 = InpRiskPercent * (1.0 - InpFrazionePrimo);
   bool a = PiazzaLimite(isLong, Norma(bordoVicino),  Norma(sl), Norma(target), r1, "B1");
   bool b = PiazzaLimite(isLong, Norma(bordoLontano), Norma(sl), Norma(target), r2, "B2");
   if(a || b){ gSetupPiazzati++; return(true); }
   return(false);
  }

//==================================================================
//  spec par.6 -- LO STOP. Il corso ne da' SETTE senza dire quale.
//  Qui i 4 MISURABILI, e la scelta e' un INPUT DA SWEEP, non un
//  default nascosto. Gli altri 3 sono letture visive: vedi l'elenco
//  "quello che questo EA non fa".
//==================================================================
double CalcolaStop(bool isLong, double alto, double basso, double ingresso, double primoObiettivo)
  {
   double pip = PipSize();
   double buf = InpSLbufferPips * pip;
   double sl = 0;

   if(InpSLMode == SL_RR_1A1)
     {
      // metodo 4: "17 pip al primo obiettivo -> 17 pip di stop, rapporto 1 a 1"
      double d = MathAbs(primoObiettivo - ingresso);
      if(d <= 0) return(0);
      sl = isLong ? (ingresso - d) : (ingresso + d);
     }
   else if(InpSLMode == SL_ATR)
     {
      double atr = AtrVal(); if(atr <= 0) return(0);
      sl = isLong ? (ingresso - InpSLatr * atr) : (ingresso + InpSLatr * atr);
     }
   else if(InpSLMode == SL_FIBO_4236)
     {
      // metodo 7: "lo stop lo posso inserire sotto il 423"
      sl = LivelloFibo(isLong, alto, basso, InpFibo4236);
      sl = isLong ? (sl - buf) : (sl + buf);
      return(sl);
     }
   else // SL_CANDELA -- metodo 3: massimi/minimi della candela del pattern
     {
      sl = isLong ? (basso - buf) : (alto + buf);
      // se lo stop cade DENTRO la zona d'ingresso non e' uno stop:
      // per un long l'ingresso sta SOTTO il pattern, quindi va oltre.
      if(isLong && sl >= ingresso) sl = ingresso - buf * 2;
      if(!isLong && sl <= ingresso) sl = ingresso + buf * 2;
      return(sl);
     }
   sl = isLong ? (sl - buf) : (sl + buf);
   return(sl);
  }

bool PiazzaLimite(bool isLong, double px, double sl, double tp, double riskPct, string tag)
  {
   double rischio = isLong ? (px - sl) : (sl - px);
   if(rischio <= 0){ Log("stop dal lato sbagliato, ordine " + tag + " saltato."); return(false); }
   double lot = LottoDaRischio(rischio, riskPct);
   if(lot <= 0){ Log("lotto nullo, ordine " + tag + " saltato."); return(false); }

   // STOPS_LEVEL: sotto la distanza minima del broker il pendente viene
   // rifiutato. Si controlla PRIMA, cosi' il rifiuto non arriva come
   // retcode misterioso nel log di una notte di macchina.
   long stopsLv = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double minDist = stopsLv * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double rif = isLong ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(minDist > 0 && MathAbs(rif - px) < minDist)
     { Log(StringFormat("ordine %s troppo vicino al prezzo (STOPS_LEVEL %d punti): saltato.", tag, (int)stopsLv)); return(false); }

   datetime exp = TimeCurrent() + InpPendingExpiryBars * PeriodSeconds(InpTF);
   string cm = InpComment + (isLong ? " L " : " S ") + tag;

   // GUARDIAN sul percorso di APERTURA. Nel tester e' inerte.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_FiboH4_Corso")) return(false);

   gTrade.SetTypeFillingBySymbol(_Symbol);
   bool ok = isLong ? gTrade.BuyLimit(lot, px, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, exp, cm)
                    : gTrade.SellLimit(lot, px, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, exp, cm);
   int dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(ok)
      Log(StringFormat("%s LIMIT %s @ %s SL %s TP %s lot %.2f", isLong ? "BUY" : "SELL", tag,
                       DoubleToString(px, dg), DoubleToString(sl, dg), DoubleToString(tp, dg), lot));
   else
      Print("[FIBOCORSO] ordine ", tag, " RIFIUTATO: ", gTrade.ResultRetcodeDescription(),
            " (retcode ", gTrade.ResultRetcode(), ")");
   return(ok);
  }

//==================================================================
//  spec par.7 -- LA GESTIONE
//  Primo obiettivo = la PRIMA entry zone: li' 50% + stop in pari.
//  Target finale = il 100: ci pensa il TP dell'ordine.
//  ASSUNZIONE A6: la lez.19 dice "dimezzo al 100"; la lez.20 dice
//  "il primo obiettivo e' la prima entry zone". Si segue la 20:
//  dimezzare sul target finale non lascerebbe niente da far correre.
//==================================================================
void GestisciPosizioni()
  {
   if(gPrimoTarget <= 0) return;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol ||
         PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      bool isLong = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      double openP = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl = PositionGetDouble(POSITION_SL);
      double tp = PositionGetDouble(POSITION_TP);
      double vol = PositionGetDouble(POSITION_VOLUME);

      bool bePari = isLong ? (sl >= openP) : (sl <= openP && sl > 0);
      if(bePari) continue;                       // gia' fatto su questa posizione

      bool arrivato = isLong ? (bid >= gPrimoTarget) : (ask <= gPrimoTarget);
      if(!arrivato) continue;

      // Lo STOP IN PARI non deve dipendere dalla riuscita del parziale.
      // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non
      // parte, e con lui saltava anche il pareggio. Difetto gia' pagato
      // il 04/08 sugli EMA200 (-112,78 EUR) e corretto il 07/08.
      double cv = NormVol(vol * InpParzialePct / 100.0);
      bool parzOK = (cv > 0 && cv < vol && gTrade.PositionClosePartial(tk, cv));

      double pari = Norma(openP);
      double slOra = PositionGetDouble(POSITION_SL);
      bool dirLong = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      bool beFatto = (InpBreakeven && ((dirLong && pari > slOra) ||
                                       (!dirLong && (slOra == 0 || pari < slOra))));
      if(beFatto) gTrade.PositionModify(tk, pari, tp);
      if(parzOK || beFatto)
         Log(parzOK ? "primo obiettivo: parziale + stop in pari."
                    : "primo obiettivo: stop in pari (parziale impossibile al lotto minimo).");
     }
  }

//==================================================================
//  spec par.2.1 -- "gli ordini non eseguiti entro le 18.30-19 vanno
//  cancellati". ORA SERVER. Vedi la richiesta R4 sul fuso.
//  NB: cancella i PENDENTI, non chiude le posizioni: il corso parla
//  di ordini non eseguiti.
//==================================================================
void CutoffCheck()
  {
   if(!InpUseCutoff) return;
   if(ContaPosizioni() > 0) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.hour * 60 + now.min < InpCutoffHour * 60 + InpCutoffMin) return;
   if(HaPendenti()) CancellaPendenti();
  }

//==================================================================
//  spec par.2 -- "non stare MAI e qua dico MAI aperto durante il
//  weekend". E' la regola piu' netta del modulo.
//==================================================================
void FridayCloseCheck()
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_week != 5) return;
   if(now.hour * 60 + now.min < InpFridayCloseHour * 60 + InpFridayCloseMin) return;
   CancellaPendenti();
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic) gTrade.PositionClose(tk);
     }
  }

//==================================================================
//  spec par.8 -- FILTRO NOTIZIE
//  FORMATO ATTESO del CSV, separatore ';' :
//      Data Ora ; Impatto ; Valuta ; Titolo
//  ATTENZIONE: i due CALENDARI di biblioteca hanno le colonne 2 e 3
//  SCAMBIATE (data;PAESE;impatto;evento). Dati cosi' come sono, il
//  filtro NON blocca mai niente: non fallisce, diventa NEUTRO IN
//  SILENZIO. Si convertono prima, con
//  backtest_pipeline\converti_calendario_news.py.
//==================================================================
void LoadNews()
  {
   gNewsCount = 0; gNewsScartate = 0; gNewsSottoSoglia = 0; gNewsSorted = true;
   ArrayResize(gNewsTime, 0); ArrayResize(gNewsImpact, 0); ArrayResize(gNewsCcy, 0);

   int h = INVALID_HANDLE;
   if(InpNewsCommon)
     {
      h = FileOpen(InpNewsFile, FILE_READ | FILE_CSV | FILE_ANSI | FILE_COMMON, ';');
      if(h != INVALID_HANDLE) gNewsDove = "Common\\Files";
     }
   if(h == INVALID_HANDLE)
     {
      h = FileOpen(InpNewsFile, FILE_READ | FILE_CSV | FILE_ANSI, ';');
      if(h != INVALID_HANDLE) gNewsDove = "MQL5\\Files (sandbox)";
     }
   if(h == INVALID_HANDLE)
     {
      gNewsDove = "(non trovato)";
      Print("[FIBOCORSO][NEWS] FILTRO ACCESO MA CIECO: '", InpNewsFile,
            "' non trovato ne' in Common\\Files ne' nella sandbox. La passata ",
            "uscira' IDENTICA alla baseline e NON e' una misura del filtro.");
      return;
     }

   datetime ultimo = 0;
   while(!FileIsEnding(h))
     {
      string sTime = FileReadString(h);
      if(FileIsLineEnding(h) && StringLen(sTime) == 0) continue;
      string sImp = FileIsLineEnding(h) ? "" : FileReadString(h);
      string sCcy = FileIsLineEnding(h) ? "" : FileReadString(h);
      while(!FileIsLineEnding(h) && !FileIsEnding(h)) FileReadString(h);
      datetime t = StringToTime(sTime);
      if(t <= 0){ gNewsScartate++; continue; }
      t += InpNewsShiftMinutes * 60;
      int imp = ImpactToInt(sImp);
      if(imp < InpNewsMinImpact){ gNewsSottoSoglia++; continue; }
      if(t < ultimo) gNewsSorted = false;
      ultimo = t;
      int n = gNewsCount;
      ArrayResize(gNewsTime, n + 1, 4096); ArrayResize(gNewsImpact, n + 1, 4096); ArrayResize(gNewsCcy, n + 1, 4096);
      StringTrimLeft(sCcy); StringTrimRight(sCcy); StringToUpper(sCcy);
      gNewsTime[n] = t; gNewsImpact[n] = imp; gNewsCcy[n] = sCcy; gNewsCount = n + 1;
     }
   FileClose(h);

   PrintFormat("[FIBOCORSO][NEWS] letto da %s | eventi utili %d (impatto >= %d) | sotto soglia %d | "
               "scartate %d | ordinato %s | shift %d min | per valuta %s",
               gNewsDove, gNewsCount, InpNewsMinImpact, gNewsSottoSoglia, gNewsScartate,
               (gNewsSorted ? "si" : "NO (ricerca lineare)"), InpNewsShiftMinutes,
               (InpNewsPerCurrency ? "si" : "no (blackout globale)"));
   if(gNewsCount > 0)
      PrintFormat("[FIBOCORSO][NEWS] primo %s | ultimo %s  <-- fuori da questo intervallo il filtro e' CIECO.",
                  TimeToString(gNewsTime[0], TIME_DATE | TIME_MINUTES),
                  TimeToString(gNewsTime[gNewsCount - 1], TIME_DATE | TIME_MINUTES));
   else
      Print("[FIBOCORSO][NEWS] FILTRO ACCESO MA CIECO: ZERO eventi utili. ",
            "Colonne del calendario scambiate, oppure soglia troppo alta.");
  }

int ImpactToInt(string s)
  {
   string u = s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u, "HIGH") >= 0 || u == "3") return(3);
   if(StringFind(u, "MED")  >= 0 || u == "2") return(2);
   if(StringFind(u, "LOW")  >= 0 || u == "1") return(1);
   return(0);
  }

//--- spec par.8: "dato sul dollaro -> escludo i cross col dollaro,
//    come NUMERATORE o DENOMINATORE".
bool NewsToccaSimbolo(string ccy)
  {
   if(StringLen(ccy) == 0) return(true);      // valuta ignota: prudenza, blocca
   string b = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_BASE);
   string p = SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT);
   StringToUpper(b); StringToUpper(p);
   return(ccy == b || ccy == p);
  }

int NewsLowerBound(datetime t)
  {
   int lo = 0, hi = gNewsCount;
   while(lo < hi){ int mid = (lo + hi) / 2; if(gNewsTime[mid] < t) lo = mid + 1; else hi = mid; }
   return(lo);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter || gNewsCount == 0) return(false);
   gNewsBarreViste++;
   datetime lo = now - InpNewsAfterMin * 60;
   datetime hi = now + InpNewsBeforeMin * 60;
   if(gNewsSorted)
     {
      for(int i = NewsLowerBound(lo); i < gNewsCount && gNewsTime[i] <= hi; i++)
        {
         if(InpNewsPerCurrency && !NewsToccaSimbolo(gNewsCcy[i])) continue;
         gNewsBlocchi++; return(true);
        }
      return(false);
     }
   for(int i = 0; i < gNewsCount; i++)
     {
      if(gNewsTime[i] < lo || gNewsTime[i] > hi) continue;
      if(InpNewsPerCurrency && !NewsToccaSimbolo(gNewsCcy[i])) continue;
      gNewsBlocchi++; return(true);
     }
   return(false);
  }

//--- spec par.8: "prima del rilascio di ogni dato gli ordini vanno
//    TOLTI", con la deroga a >= 100 pip di distanza.
void NewsCancelCheck()
  {
   if(!InpUseNewsFilter || !InpNewsCancelPendings) return;
   if(gNewsCount == 0) return;
   if(!HaPendenti()) return;
   if(!InNewsBlackout(TimeCurrent())) return;

   double pip = PipSize();
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong t = OrderGetTicket(i);
      if(t == 0) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol || OrderGetInteger(ORDER_MAGIC) != InpMagic) continue;
      double px = OrderGetDouble(ORDER_PRICE_OPEN);
      long tp = OrderGetInteger(ORDER_TYPE);
      double rif = (tp == ORDER_TYPE_BUY_LIMIT || tp == ORDER_TYPE_BUY_STOP) ? ask : bid;
      if(InpNewsDerogaPips > 0 && MathAbs(rif - px) / pip >= InpNewsDerogaPips) continue;
      if(gTrade.OrderDelete(t)) gNewsPendCancellati++;
     }
  }

//==================================================================
//  METRICA DI FAMIGLIA: la PEGGIOR GIORNATA in %.
//==================================================================
void AggiornaPeggiorGiornata()
  {
   MqlDateTime d; TimeToStruct(TimeCurrent(), d);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(d.day_of_year != gGiornoCorrente){ gGiornoCorrente = d.day_of_year; gEqInizioGiorno = eq; return; }
   if(gEqInizioGiorno <= 0){ gEqInizioGiorno = eq; return; }
   double pct = (eq - gEqInizioGiorno) / gEqInizioGiorno * 100.0;
   if(pct < gWorstDayPct) gWorstDayPct = pct;
  }

//==================================================================
//  AUTOTEST -- puro: nessun ordine, nessun file, nessuna
//  GlobalVariable. Si legge ESEGUENDO un test SINGOLO nel tester:
//  F7 compila e basta, da MetaEditor queste righe non escono.
//  Verifica la GEOMETRIA, che e' il cuore della domanda B.
//==================================================================
void AutoTestFiboCorso()
  {
   int falliti = 0;

   //--- caso di scuola: pattern LONG con basso 100 e alto 110, range 10.
   double alto = 110.0, basso = 100.0;
   double t100 = LivelloFibo(true, alto, basso, 1.00);
   double e1n  = LivelloFibo(true, alto, basso, 1.78);
   double e1f  = LivelloFibo(true, alto, basso, 1.88);
   double e2n  = LivelloFibo(true, alto, basso, 2.78);
   double e2f  = LivelloFibo(true, alto, basso, 2.88);

   // 1. il livello 100 e' la BASE del pattern (ASSUNZIONE A2, richiesta R2)
   if(MathAbs(t100 - 100.0) > 1e-8)
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: il livello 100 non e' la base del pattern."); }
   // 2. la banda e' larga 0,10 x range (ASSUNZIONE A1, richiesta R3)
   if(MathAbs((e1n - e1f) - 0.10 * (alto - basso)) > 1e-8)
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: la banda EZ1 non e' larga 0,10 x range."); }
   if(MathAbs((e2n - e2f) - 0.10 * (alto - basso)) > 1e-8)
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: la banda EZ2 non e' larga 0,10 x range."); }
   // 3. per un LONG le zone stanno SOTTO la base, e la seconda piu' sotto
   if(!(e1n < basso && e2n < e1n))
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: le entry zone long non sono sotto la base."); }
   // 4. lo SHORT e' speculare
   double t100s = LivelloFibo(false, alto, basso, 1.00);
   double e2ns  = LivelloFibo(false, alto, basso, 2.78);
   if(MathAbs(t100s - 110.0) > 1e-8 || !(e2ns > alto))
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: la geometria short non e' speculare."); }
   // 5. il calendario con le colonne scambiate NON deve valere un impatto
   if(ImpactToInt("United States") != 0)
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: un paese non puo' valere un impatto."); }
   if(ImpactToInt("High") != 3)
     { falliti++; Print("[FIBOCORSO][AUTOTEST] FALLITO: ImpactToInt(High) != 3"); }

   PrintFormat("[FIBOCORSO][AUTOTEST] geometria su pattern 100-110 (range 10): "
               "target100=%.2f | EZ1 [%.2f - %.2f] | EZ2 [%.2f - %.2f] | banda=%.2f",
               t100, e1f, e1n, e2f, e2n, e1n - e1f);
   PrintFormat("[FIBOCORSO][AUTOTEST] magic %d | commento \"%s\" | rischio %.2f%% (0,65 di casa: il corso NON lo dice) | "
               "zona=%s | stop=%s | ancoraggio=%s",
               (int)InpMagic, InpComment, InpRiskPercent,
               EnumToString(InpZona), EnumToString(InpSLMode), EnumToString(InpAncoraggio));
   PrintFormat("[FIBOCORSO][AUTOTEST] trend: filtro=%s swing=%d barre per lato, %d coppie, lookback %d",
               (InpUseTrendFilter ? "SI" : "NO"), InpSwingBars, InpSwingCoppie, InpTrendLookback);
   PrintFormat("[FIBOCORSO][AUTOTEST] news: uso=%s perValuta=%s cancellaPendenti=%s deroga=%.0f pip shift=%d min",
               (InpUseNewsFilter ? "SI" : "no"), (InpNewsPerCurrency ? "si" : "no"),
               (InpNewsCancelPendings ? "si" : "no"), InpNewsDerogaPips, InpNewsShiftMinutes);
   PrintFormat("[FIBOCORSO][AUTOTEST] cancelli: cutoff=%s %02d:%02d server | venerdi=%s %02d:%02d server "
               "(ORA SERVER, e il fuso del corso e' la richiesta R4)",
               (InpUseCutoff ? "SI" : "no"), InpCutoffHour, InpCutoffMin,
               (InpFridayClose ? "SI" : "no"), InpFridayCloseHour, InpFridayCloseMin);

   int fg = ABTG_AutotestGuardia();
   if(fg > 0){ falliti += fg; PrintFormat("[FIBOCORSO][AUTOTEST] Guardian: %d casi falliti -- NON mettere in campo.", fg); }

   Print("[FIBOCORSO][AUTOTEST] PROMEMORIA: questo EA opera SOLO sul simbolo del ",
         "grafico. Un simbolo per passata. NON e' multi-simbolo come ABTG_FiboH4_Multi ",
         "(quello ha fatto misurare otto volte lo stesso basket).");
   PrintFormat("[FIBOCORSO][AUTOTEST] %d casi falliti in tutto.", falliti);
  }

//==================================================================//
//  OPTFRAME (inlined) + export per-trade + canarini di conteggio    //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

void ExportTrades()
  {
   if(!HistorySelect(0, TimeCurrent())) return;
   string fn = "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol + "_" + IntegerToString((long)InpMagic) + ".csv";
   int h = FileOpen(fn, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h, "close_time", "symbol", "magic", "position_id", "deal_type", "volume", "price", "net_profit", "comment");
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      long entry = HistoryDealGetInteger(tk, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      double net = HistoryDealGetDouble(tk, DEAL_PROFIT) + HistoryDealGetDouble(tk, DEAL_SWAP) + HistoryDealGetDouble(tk, DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk, DEAL_TIME), TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                HistoryDealGetString(tk, DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_VOLUME), 2),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_PRICE), _Digits),
                DoubleToString(net, 2),
                HistoryDealGetString(tk, DEAL_COMMENT));
     }
   FileClose(h);
  }

//==================================================================
//  I CANARINI DI R93 GAMBA B -- si leggono PRIMA di ogni profitto.
//  Dicono se il round ha misurato QUALCOSA, o se ha misurato il nulla.
//  setup piazzati = 0 -> non e' "la strategia perde": e' "la strategia
//  non ha mai operato". Cause tipiche, in ordine di probabilita':
//    scartatiLaterale alto  -> il filtro di trend e' troppo stretto
//    scartatiDistanza alto  -> i 50 pip minimi non si raggiungono mai
//    patternVisti = 0       -> l'engulfing totale (ombre comprese) e'
//                              raro su H4: e' un fatto, non un difetto
//==================================================================
void PrintConta()
  {
   PrintFormat("[FIBOCORSO-CONTA] %s | pattern visti=%I64d -> scartati: ampiezza=%I64d "
               "laterale=%I64d distanza=%I64d | SETUP PIAZZATI=%I64d",
               _Symbol, gPatternVisti, gScartatiAmpiezza, gScartatiLaterale,
               gScartatiDistanza, gSetupPiazzati);
   if(gSetupPiazzati == 0)
      Print("[FIBOCORSO-CONTA] CANARINO ROSSO: ZERO setup piazzati. Questa passata ",
            "NON dice niente sulla strategia: dice che non ha mai operato. Si guarda ",
            "la riga sopra per capire QUALE cancello ha mangiato tutto.");
   if(InpUseNewsFilter)
     {
      double pct = (gNewsBarreViste > 0) ? 100.0 * (double)gNewsBlocchi / (double)gNewsBarreViste : 0.0;
      PrintFormat("[FIBOCORSO][NEWS-CONTA] eventi=%d | interrogazioni=%I64d | bloccate=%I64d (%.2f%%) | "
                  "pendenti cancellati=%I64d | letto da %s",
                  gNewsCount, gNewsBarreViste, gNewsBlocchi, pct, gNewsPendCancellati, gNewsDove);
      if(gNewsBlocchi == 0)
         Print("[FIBOCORSO][NEWS-CONTA] CANARINO ROSSO: filtro ACCESO e ZERO blocchi. ",
               "Atteso 8-12%. Questa passata NON misura il filtro.");
     }
   else Print("[FIBOCORSO][NEWS-CONTA] filtro notizie SPENTO in questa passata.");
  }

double OnTester()
  {
   PrintConta();
   ExportTrades();
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   stats[7] = gWorstDayPct;                           // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);   // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);      // Serie Perdente Peggiore (denaro)
   double criterion = stats[3];                       // Recovery Factor
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                (ArraySize(data) > 7 ? data[7] : 0.0),
                                (ArraySize(data) > 8 ? data[8] : 0.0),
                                (ArraySize(data) > 9 ? data[9] : 0.0));
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//+------------------------------------------------------------------+
