//+------------------------------------------------------------------+
//|                                     ABTG_ScalperDirezionale.mq5  |
//|  Scalper a cicli brevi che segue il VERSO deciso da Claudio.     |
//|                                                                  |
//|  Richiesta di Claudio (25/09/2026), testuale:                    |
//|  "CHE ENTRA SEMPRE CON LO STESSO MIO SEGNO DI INGRESSO, LONG O   |
//|   SHORT. E CHE CHIUDA OPERAZIONI APPENA VA SOPRA DI QUALCHE      |
//|   EURO ED APPENA GENERA UN GUADAGNO X, AUMENTA I LOTTI           |
//|   PROGRESSIVAMENTE. DEVE FARE OPERAZIONI BREVI. 10 SECONDI       |
//|   MASSIMO."  -  "LO USO SUL MANUALE DEMO."                       |
//|                                                                  |
//|  SOLO DEMO (conto manuale 50503635, C:\MT5_MANUALE): il conto e' |
//|  CONTROLLATO in OnInit (login + demo + hedging), non solo scritto|
//|  qui. NON per FTMO (tetto 2.000 richieste/giorno, Forbidden      |
//|  Practices) e NON per il conto reale 10105439.                   |
//|                                                                  |
//|  Cosa fa: apre un'ONDATA di InpPositions posizioni (stesso lotto,|
//|  stesso verso); ogni posizione chiude a +InpTargetEuro netti, o  |
//|  a -InpStopEuro netti (stop anche sul server), o dopo            |
//|  InpMaxSeconds; quando l'ondata e' tutta chiusa, dopo la pausa,  |
//|  ne parte un'altra. Il lotto SALE solo quando il guadagno chiuso |
//|  cresce (anti-martingala), MAI dopo una perdita. Freni fissi,    |
//|  misurati sul NETTO DELL'ONDATA: perdita di sessione, ondate in  |
//|  perdita di fila, ondate al minuto, richieste dall'avvio. Ogni   |
//|  posizione va in un CSV, ANCHE se a chiudere e' stato lo SL/TP   |
//|  del server.                                                     |
//|  Modo CANDELA (aggiunto su richiesta, 25/09 sera): verso dal     |
//|  PRIMO MOVIMENTO della candela nuova o dalla candela precedente; |
//|  dai TICK (movimento degli ultimi N tick); oppure dal CICLO.     |
//|  Non e' una strategia: e' un test misurato dal CSV.             |
//|  I numeri onesti sono nel referto di casa.                       |
//|                                                                  |
//|  1.01 (25/09 sera, dopo il cancello - FAIL con 6 bloccanti):     |
//|   B1 conto controllato in OnInit e in TryOpen                    |
//|   B2 VOLUME_MIN > lotto dichiarato -> NON parte (niente taglie   |
//|      alzate in silenzio)                                         |
//|   B3 contabilita' per identificativo di posizione: le chiusure   |
//|      del server (SL/TP) passano dai freni e dal CSV              |
//|   B4 le posizioni aperte si gestiscono SEMPRE, anche da FERMO    |
//|   B5 orologio = TimeTradeServer(), il tempo scatta senza tick    |
//|   B6 pausa vera in ms; un rifiuto aspetta 5 s; 5 rifiuti = STOP  |
//|  1.02: "chiusura mandata" scade dopo 3 s (PLACED = mandata);     |
//|   OnDeinit chiude solo sul conto ammesso; id posizione dal deal; |
//|   motivo di chiusura dal DEAL_REASON; pulsante in basso.         |
//|  1.03 (richiesta di Claudio: "non capisco come scelga buy o     |
//|   sell... abbinarlo al cycle"): regola CICLO. Verso              |
//|   dall'oscillatore CICLO "Alta Velocita'" (formula ORIGINALE di  |
//|   Claudio, copiata riga per riga da ABTG_Cycle.mq5 /             |
//|   ABTG_Ciclo.mq5, fedelta' verificata al bit dal cancello):      |
//|   SEGNO = si opera nel colore dell'istogramma sull'ultima barra  |
//|   CHIUSA (verde = long, rosso = short); INCROCIO = fino a        |
//|   InpMaxWavesPerCandle ondate nella candela dell'incrocio (1.06).|
//|   Sul ciclo NON esiste un PF                                     |
//|   leggibile in casa: R148a/bL/bS (NASUSD M30, 15/09) sono GIRATI |
//|   ma i numeri non sono mai arrivati nel repo; XAUUSD M1 mai      |
//|   provato. E' una RAGIONE per il verso, non un edge provato.     |
//|  1.04 (richiesta di Claudio: "apra 8 ordini con lo stesso lotto, |
//|   con lotti ad incrementare, 20 secondi"): ONDATE di             |
//|   InpPositions posizioni; contabilita' per posizione con         |
//|   elenco; freni e anti-martingala sul netto dell'ondata; cache   |
//|   del ciclo azzerata in OnInit (cancello 1.03, classe 816);      |
//|   START richiesto di nuovo dopo un cambio di input.              |
//|  1.05 (cancello 1.04: PASS con tre ritocchi): chiusura rifiutata |
//|   ritentata con attesa che raddoppia fino a 60 s (classe 810);   |
//|   motivo sul pannello dopo un cambio di input o grafico.         |
//|  1.06 (richiesta di Claudio, 25/09 sera: "se la candela apre     |
//|   long, i trade devono essere tutti long... 3 ordini all'interno |
//|   del minuto della stessa direzione"): VERSO BLOCCATO PER        |
//|   CANDELA. A candela nuova si decide UNA volta (primo movimento, |
//|   candela precedente o Ciclo, secondo InpCandleRule) e tutte le  |
//|   ondate di quella candela (max InpMaxWavesPerCandle) hanno quel |
//|   verso. Col primo movimento non si "salta" piu' la candela: si  |
//|   ASPETTA che il prezzo si muova. Modo TICK escluso (non ha      |
//|   candele).                                                       |
//|  1.07 (richiesta di Claudio, 25/09 sera, dopo la prova 1.06 in   |
//|   perdita: "apre il trade solo se la candela del minuto          |
//|   successivo apre oltre la meta' del corpo della candela          |
//|   precedente... se il prezzo e' laterale, non apre ordini"):     |
//|   regola MEZZO CORPO. A candela nuova, dopo InpFirstMoveSeconds, |
//|   precedente VERDE e prezzo SOPRA la meta' del suo corpo -> LONG;|
//|   precedente ROSSA e prezzo SOTTO la meta' -> SHORT; altrimenti  |
//|   (prezzo dalla parte sbagliata, doji, corpo < InpCorpoMinimoPts)|
//|   NESSUNA ondata in quella candela. Verso bloccato per candela   |
//|   come in 1.06. Nota onesta: in M1 la candela nuova apre dove ha |
//|   chiuso la precedente, quindi "oltre la meta'" al secondo zero   |
//|   e' quasi sempre vero: il filtro morde grazie all'attesa di     |
//|   InpFirstMoveSeconds e al corpo minimo.                         |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.07"
#include <Trade\Trade.mqh>

#define CONTO_AMMESSO 50503635   // il SOLO conto su cui questo EA accetta di girare
#define MAX_POSIZIONI 10         // tetto duro delle posizioni per ondata (codice, non input)

enum ENUM_DIR_MODE   { DIR_FROM_MANUAL=0, DIR_LONG=1, DIR_SHORT=2 };
enum ENUM_ENTRY_MODE { ENTRY_MANUALE=0, ENTRY_CANDELA=1 };
enum ENUM_CANDLE_RULE { CR_PREV_CANDLE=0, CR_FIRST_MOVE=1, CR_TICK=2, CR_CICLO=3, CR_MEZZO_CORPO=4 };
enum ENUM_CICLO_REGOLA { CICLO_SEGNO=0, CICLO_INCROCIO=1 };

input group "=== Modo d'ingresso ==="
input ENUM_ENTRY_MODE InpEntryMode       = ENTRY_MANUALE;   // MANUALE: verso dalla tua posizione (o fisso), rientra subito. CANDELA: verso da candela/tick/ciclo
input ENUM_TIMEFRAMES InpCandleTF        = PERIOD_M1;       // CANDELA/CICLO: timeframe (M1 consigliato)
input ENUM_CANDLE_RULE InpCandleRule     = CR_TICK;         // CANDELA: verso dal PRIMO MOVIMENTO, dalla candela PRECEDENTE, dai TICK (senza candele), dal CICLO, oppure MEZZO CORPO (precedente verde e prezzo sopra la meta' del suo corpo = long; rossa e sotto = short; altrimenti niente)
input int           InpTickWindow        = 5;               // TICK: numero di tick su cui si misura il movimento
input int           InpFirstMoveSeconds  = 3;               // CANDELA/primo movimento: secondi dopo l'apertura in cui si legge il verso
input double        InpFirstMovePoints   = 1.0;             // CANDELA/primo movimento e TICK: movimento minimo in PUNTI MT5 (_Point) per decidere
input int           InpMaxWavesPerCandle = 3;               // CANDELA: ondate massime dentro la stessa candela, tutte nello stesso verso (0 = senza limite)
input double        InpCorpoMinimoPts    = 0.0;             // MEZZO CORPO: corpo minimo della candela precedente in PUNTI MT5 (0 = qualunque; sotto = laterale, niente ondate)

input group "=== CICLO (oscillatore Alta Velocita' di Claudio, sul TF InpCandleTF) ==="
input ENUM_CICLO_REGOLA InpCicloRegola   = CICLO_SEGNO;     // SEGNO: opera nel colore dell'ultima barra chiusa (verde=long, rosso=short). INCROCIO: fino a InpMaxWavesPerCandle ondate nella candela dell'incrocio, stesso verso
input double        InpCicloMinimo       = 0.0;             // SEGNO: |ciclo| minimo per operare (0 = qualunque valore). Unita' dell'oscillatore
input int           InpK1Len             = 5;               // Stoch 1 - lunghezza K (fonte: 5)
input int           InpK1Smo             = 3;               // Stoch 1 - lisciatura  (fonte: 3)
input int           InpK2Len             = 14;              // Stoch 2 - lunghezza K (fonte: 14)
input int           InpK2Smo             = 3;               // Stoch 2 - lisciatura  (fonte: 3)
input int           InpK3Len             = 45;              // Stoch 3 - lunghezza K (fonte: 45)
input int           InpK3Smo             = 14;              // Stoch 3 - lisciatura  (fonte: 14)
input int           InpK4Len             = 75;              // Stoch 4 - lunghezza K (fonte: 75)
input int           InpK4Smo             = 20;              // Stoch 4 - lisciatura  (fonte: 20)
input int           InpMmLen             = 9;               // MM: la media mobile che viene sottratta (fonte: 9)

input group "=== Verso e avvio (modo MANUALE) ==="
input ENUM_DIR_MODE InpDirection          = DIR_FROM_MANUAL; // Verso: dalla TUA prima posizione a mano, oppure fisso
input bool          InpAutoStart          = false;           // true = parte da solo appena conosce il verso (altrimenti pulsante START)
input bool          InpStopWhenManualClosed = true;          // si ferma se chiudi la posizione manuale che ha dato il verso

input group "=== Ondata ==="
input int           InpPositions          = 1;               // posizioni per ondata (stesso lotto, stesso verso), max 10
input double        InpTargetEuro         = 3.0;             // ogni posizione chiude in utile a +X euro NETTI
input double        InpStopEuro           = 2.0;             // ogni posizione chiude in perdita a -Y euro NETTI (stop anche sul server)
input int           InpMaxSeconds         = 10;              // durata massima di una posizione (secondi)
input int           InpPauseMs            = 500;             // pausa fra la fine di un'ondata e la prossima (ms)

input group "=== Lotti (salgono SOLO col guadagno) ==="
input double        InpLotStart           = 0.01;            // lotto di partenza (per posizione)
input double        InpLotStep            = 0.01;            // aumento del lotto
input double        InpStepEveryEuro      = 10.0;            // ... ogni X euro di guadagno chiuso dall'avvio
input double        InpLotMax             = 0.10;            // tetto del lotto (per posizione)
input bool          InpResetOnLoss        = true;            // dopo un'ondata in perdita si riparte dal lotto di partenza

input group "=== Freni (fissi, sul netto dell'ONDATA) ==="
input double        InpMaxLossSessionEuro = 20.0;            // perdita massima chiusa dall'avvio: poi STOP
input int           InpMaxConsecutiveLosses = 3;             // ondate in perdita di fila (anche per uscite a tempo): poi STOP
input int           InpMaxTradesPerMinute = 6;               // ondate al minuto: oltre, aspetta
input int           InpMaxRequestsPerDay  = 500;             // richieste al server dall'avvio (START le azzera): poi STOP
input int           InpStartHour          = 0;               // ora SERVER da cui puo' operare
input int           InpEndHour            = 24;              // ora SERVER oltre la quale si ferma (24 = mai)

input group "=== Generali ==="
input long          InpMagic              = 779901;          // magic dell'EA (le posizioni a mano hanno magic 0)
input int           InpDeviationPts       = 50;              // slippage ammesso in punti
input bool          InpVerbose            = true;            // log nel giornale Esperti

//--- una posizione dell'ondata, per identificativo (B3): cosi' le chiusure del server vengono contate
struct SPos
  {
   ulong    id;          // POSITION_IDENTIFIER
   string   verso;
   double   lot;
   double   pin;
   datetime t;
   string   closeWhy;    // "" = nessuna chiusura mandata
   double   pout;
   uint     sentMs;      // quando e' stata mandata la chiusura
   uint     retryMs;     // chiusura rifiutata: quando
   uint     retryLen;    // ... e quanto si aspetta (1 s, poi raddoppia fino a 60 s: niente raffiche a mercato fermo)
   uint     goneMs;      // da quando non si vede piu' fra le posizioni
   double   lastProfit;  // ultimo profitto visto (stima se lo storico non arriva)
  };

//--- stato
CTrade   trade;
bool     gActive       = false;
int      gDir          = 0;      // 0 nessuno, +1 long, -1 short
bool     gDirFromManual= false;
double   gLot          = 0.0;
double   gCumProgress  = 0.0;    // guadagno chiuso che fa salire il lotto (si azzera con InpResetOnLoss)
double   gCumTotal     = 0.0;    // netto chiuso dall'avvio
double   gLossSession  = 0.0;
int      gConsecLoss   = 0;      // ondate in perdita di fila
int      gWaves        = 0;      // ondate chiuse
int      gPosClosed    = 0;      // posizioni chiuse
int      gRequests     = 0;
int      gRejects      = 0;      // aperture rifiutate di fila
datetime gWaveTimes[];           // ondate recenti (per il tetto al minuto)
string   gStopReason   = "";
string   gLastAction   = "-";
string   gCsv          = "";
datetime gCandleDone   = 0;      // barra gia' usata (modo CANDELA / CICLO incrocio)
datetime gLockBar      = 0;      // candela su cui il verso e' stato deciso e BLOCCATO
int      gLockDir      = 0;      // il verso bloccato per quella candela (0 = nessuna ondata in questa candela)
int      gLockWaves    = 0;      // ondate gia' aperte in questa candela
double   gTicks[];               // ultimi bid (modo TICK)
datetime gCycBar       = 0;      // barra su cui e' stato calcolato il ciclo (si ricalcola solo a barra nuova)
double   gCyc1         = 0.0;    // ciclo sull'ultima barra CHIUSA [1]
double   gCyc2         = 0.0;    // ciclo sulla barra [2]
bool     gCycOk        = false;
//--- pause in millisecondi (GetTickCount, differenza unsigned: regge il giro del contatore)
uint     gPauseFromMs  = 0;
uint     gPauseLenMs   = 0;
//--- l'ondata in corso
SPos     gPos[];
bool     gWaveOpen     = false;  // c'e' un'ondata i cui conti non sono ancora chiusi
double   gWaveNet      = 0.0;    // netto accumulato dell'ondata in corso
int      gWaveN        = 0;      // posizioni aperte nell'ondata in corso
int      gWaveId       = 0;      // numero progressivo dell'ondata (finisce nel CSV)
const string BTN = "ABTG_SCALPER_BTN";

//+------------------------------------------------------------------+
void Log(string s)
  {
   if(InpVerbose) Print("[SCALPER] ", s);
  }
//+------------------------------------------------------------------+
bool ContoAmmesso()
  {
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   return (login == CONTO_AMMESSO
           && AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO
           && AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);
  }
//+------------------------------------------------------------------+
double NormLot(double lot)
  {
   double vmin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(step <= 0) step = vmin;
   lot = MathFloor(lot / step + 1e-9) * step;
   if(lot < vmin) lot = vmin;
   if(lot > vmax) lot = vmax;
   if(lot > InpLotMax) lot = MathFloor(InpLotMax / step + 1e-9) * step;
   if(lot < vmin) lot = vmin;
   return NormalizeDouble(lot, 8);
  }
//+------------------------------------------------------------------+
// distanza di prezzo che vale 'euro' per 'lot' lotti, gia' >= al minimo del broker (+ spread)
double EuroToPriceDist(double euro, double lot)
  {
   double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || ts <= 0 || lot <= 0) return 0.0;
   double dist = (euro / (lot * tv)) * ts;
   double spread = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double minDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point + MathMax(spread, 0.0);
   if(dist < minDist) dist = minDist;
   return dist;
  }
//+------------------------------------------------------------------+
void DrawButton()
  {
   if(ObjectFind(0, BTN) < 0)
     {
      ObjectCreate(0, BTN, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, BTN, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, BTN, OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, BTN, OBJPROP_YDISTANCE, 40);    // angolo in BASSO: visibile su ogni grafico alto >= 40 px; il trading rapido di MT5 sta in alto (classe 814)
      ObjectSetInteger(0, BTN, OBJPROP_XSIZE, 160);
      ObjectSetInteger(0, BTN, OBJPROP_YSIZE, 28);
      ObjectSetInteger(0, BTN, OBJPROP_FONTSIZE, 10);
     }
   ObjectSetString(0, BTN, OBJPROP_TEXT, gActive ? "STOP  (scalper attivo)" : "START scalper");
   ObjectSetInteger(0, BTN, OBJPROP_BGCOLOR, gActive ? clrTomato : clrLimeGreen);
   ObjectSetInteger(0, BTN, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, BTN, OBJPROP_STATE, false);
  }
//+------------------------------------------------------------------+
int Positions() { return (int)MathMin(MathMax(InpPositions, 1), MAX_POSIZIONI); }
//+------------------------------------------------------------------+
void Status()
  {
   string dir = (gDir > 0 ? "LONG" : (gDir < 0 ? "SHORT" : "nessuno"));
   string modo;
   if(InpEntryMode == ENTRY_MANUALE) modo = "MANUALE";
   else if(InpCandleRule == CR_TICK) modo = "TICK (" + IntegerToString(InpTickWindow) + " tick, min " + DoubleToString(InpFirstMovePoints, 1) + " pt)";
   else if(InpCandleRule == CR_CICLO)
     {
      modo = "CICLO " + (InpCicloRegola == CICLO_SEGNO ? "segno" : "incrocio") + " " + EnumToString(InpCandleTF);
      modo += (gCycOk ? " = " + DoubleToString(gCyc1, 2) + " (prima " + DoubleToString(gCyc2, 2) + ")" : " (calcolo...)");
     }
   else modo = "CANDELA " + (InpCandleRule == CR_FIRST_MOVE ? "primo movimento " : (InpCandleRule == CR_MEZZO_CORPO ? "mezzo corpo " : "precedente ")) + EnumToString(InpCandleTF);
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule != CR_TICK)
      modo += "   [verso bloccato per candela: " + (gLockBar == 0 ? "in attesa" : (gLockDir > 0 ? "LONG" : (gLockDir < 0 ? "SHORT" : "nessuno"))) + ", ondate " + IntegerToString(gLockWaves) + (InpMaxWavesPerCandle > 0 ? "/" + IntegerToString(InpMaxWavesPerCandle) : "") + "]";
   string s = "ABTG_ScalperDirezionale 1.07  " + _Symbol + "   modo: " + modo + "\n";
   s += "stato: " + (gActive ? "ATTIVO" : "FERMO (premi START)") + (gStopReason != "" ? "  [" + gStopReason + "]" : "") + "\n";
   s += "verso: " + dir + (gDirFromManual ? " (dalla tua posizione a mano)" : "") + "   ondata: " + IntegerToString(Positions()) + " posizioni x " + IntegerToString(InpMaxSeconds) + " s\n";
   s += "lotto attuale: " + DoubleToString(gLot, 2) + "   ondate: " + IntegerToString(gWaves) + "   posizioni chiuse: " + IntegerToString(gPosClosed) + "   aperte ora: " + IntegerToString(ArraySize(gPos)) + "\n";
   s += "netto chiuso: " + DoubleToString(gCumTotal, 2) + " EUR   perdita sessione: " + DoubleToString(gLossSession, 2) + " / " + DoubleToString(InpMaxLossSessionEuro, 2) + "\n";
   s += "ondate in perdita di fila: " + IntegerToString(gConsecLoss) + " / " + IntegerToString(InpMaxConsecutiveLosses) + "   richieste: " + IntegerToString(gRequests) + " / " + IntegerToString(InpMaxRequestsPerDay) + "\n";
   s += "ultima azione: " + gLastAction;
   Comment(s);
  }
//+------------------------------------------------------------------+
void StopAll(string why)
  {
   gActive = false;
   gStopReason = why;
   gLastAction = "STOP: " + why;
   Log("STOP - " + why);
   DrawButton();
   Status();
  }
//+------------------------------------------------------------------+
void StartAll()
  {
   gActive = true;
   gStopReason = "";
   gCumProgress = 0.0;
   gCumTotal = 0.0;
   gLossSession = 0.0;
   gConsecLoss = 0;
   gWaves = 0;
   gPosClosed = 0;
   gRequests = 0;
   gRejects = 0;
   gPauseLenMs = 0;
   gLot = NormLot(InpLotStart);
   ArrayResize(gWaveTimes, 0);
   ArrayResize(gTicks, 0);
   gLastAction = "START";
   Log("START - lotto " + DoubleToString(gLot, 2) + " x " + IntegerToString(Positions()) + " posizioni per ondata, " + IntegerToString(InpMaxSeconds) + " s");
   DrawButton();
   Status();
  }
//+------------------------------------------------------------------+
int OnInit()
  {
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(!ContoAmmesso())
     {
      Alert("ABTG_ScalperDirezionale: SOLO demo hedging ", CONTO_AMMESSO, " - qui ", login, ": NON parto");
      return(INIT_FAILED);
     }
   double vmin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(vmin > InpLotStart + 1e-9 || vmin > InpLotMax + 1e-9)
     {
      Alert("ABTG_ScalperDirezionale: VOLUME_MIN ", DoubleToString(vmin, 2), " su ", _Symbol, " > lotto dichiarato: NON alzo la taglia da solo, NON parto");
      return(INIT_FAILED);
     }
   if(InpCorpoMinimoPts < 0.0) { Alert("ABTG_ScalperDirezionale: InpCorpoMinimoPts < 0: NON parto"); return(INIT_FAILED); }
   if(InpMaxWavesPerCandle < 0) { Alert("ABTG_ScalperDirezionale: InpMaxWavesPerCandle < 0: NON parto"); return(INIT_FAILED); }
   if(InpPositions < 1 || InpPositions > MAX_POSIZIONI)
     {
      Alert("ABTG_ScalperDirezionale: InpPositions deve essere fra 1 e ", MAX_POSIZIONI, ": NON parto");
      return(INIT_FAILED);
     }
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_CICLO)
     {
      if(InpK1Len < 1 || InpK2Len < 1 || InpK3Len < 1 || InpK4Len < 1 || InpK1Smo < 1 || InpK2Smo < 1 || InpK3Smo < 1 || InpK4Smo < 1 || InpMmLen < 1)
        { Alert("ABTG_ScalperDirezionale: parametri del CICLO devono essere >= 1: NON parto"); return(INIT_FAILED); }
      if(InpCicloMinimo < 0.0) { Alert("ABTG_ScalperDirezionale: InpCicloMinimo < 0: NON parto"); return(INIT_FAILED); }
     }
   trade.SetExpertMagicNumber((ulong)InpMagic);
   trade.SetDeviationInPoints((ulong)InpDeviationPts);
   trade.SetTypeFillingBySymbol(_Symbol);
   gDir = 0; gDirFromManual = false;
   if(InpDirection == DIR_LONG)  { gDir = 1;  gDirFromManual = false; }
   if(InpDirection == DIR_SHORT) { gDir = -1; gDirFromManual = false; }
   gLot = NormLot(InpLotStart);
   gCycBar = 0; gCycOk = false; gCyc1 = 0.0; gCyc2 = 0.0;   // un cambio di input NON ricarica l'EA: le globali restano (classe 816)
   gCandleDone = 0; gLockBar = 0; gLockDir = 0; gLockWaves = 0;
   gStopReason = (gActive ? "input o grafico cambiato: premi START" : gStopReason);
   gActive = false;                                           // dopo un cambio di input si preme START di nuovo
   gCsv = "abtg_scalper_ondate_" + IntegerToString(login) + ".csv";
   if(!FileIsExist(gCsv))
     {
      int h = FileOpen(gCsv, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_READ, ';');
      if(h != INVALID_HANDLE)
        {
         FileWrite(h, "ora_chiusura", "simbolo", "ondata", "verso", "lotto", "ingresso", "uscita", "secondi", "netto", "cumulato", "motivo");
         FileClose(h);
        }
      else Log("CSV non creato (" + IntegerToString(GetLastError()) + "): " + gCsv);
     }
   DrawButton();
   Status();
   Log("1.07 caricato su " + _Symbol + " - conto " + IntegerToString(login) + " - SOLO DEMO - vmin " + DoubleToString(vmin, 2)
       + " tickvalue " + DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE), 4)
       + " stopslevel " + IntegerToString(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL))
       + " spread " + IntegerToString(SymbolInfoInteger(_Symbol, SYMBOL_SPREAD)) + " pt");
   if(InpAutoStart && (gDir != 0 || InpEntryMode == ENTRY_CANDELA)) StartAll();
   EventSetMillisecondTimer(250);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   // le posizioni dello scalper SENZA stop sul server non si lasciano nude quando l'EA viene staccato
   if(reason != REASON_CHARTCHANGE && reason != REASON_PARAMETERS && ContoAmmesso())
     {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
         ulong t = PositionGetTicket(i);
         if(t == 0 || !PositionSelectByTicket(t)) continue;
         if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
         if(PositionGetDouble(POSITION_SL) != 0.0) continue;
         Log("stacco con posizione senza stop sul server: la chiudo (" + IntegerToString((long)t) + ")");
         trade.PositionClose(t);
        }
     }
   ObjectDelete(0, BTN);
   Comment("");
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == BTN)
     {
      if(gActive) StopAll("pulsante");
      else
        {
         if(InpEntryMode == ENTRY_MANUALE && gDir == 0) { gLastAction = "START rifiutato: verso sconosciuto (apri prima una posizione a mano)"; Log(gLastAction); DrawButton(); Status(); }
         else StartAll();
        }
     }
  }
//+------------------------------------------------------------------+
// posizione manuale (magic 0) sul simbolo: ritorna ticket e verso
bool FindManual(ulong &ticket, int &dir)
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != 0) continue;
      ticket = t;
      dir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
// tutte le posizioni dello scalper (magic InpMagic, questo simbolo)
int FindMine(ulong &tickets[])
  {
   ArrayResize(tickets, 0);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      int n = ArraySize(tickets);
      ArrayResize(tickets, n + 1);
      tickets[n] = t;
     }
   return ArraySize(tickets);
  }
//+------------------------------------------------------------------+
int PosIndex(ulong id)
  {
   for(int i = 0; i < ArraySize(gPos); i++) if(gPos[i].id == id) return i;
   return -1;
  }
//+------------------------------------------------------------------+
void PosRemove(int i)
  {
   int n = ArraySize(gPos);
   for(int k = i; k < n - 1; k++) gPos[k] = gPos[k + 1];
   ArrayResize(gPos, n - 1);
  }
//+------------------------------------------------------------------+
int WavesLastMinute()
  {
   datetime now = TimeTradeServer();
   int k = 0;
   for(int i = 0; i < ArraySize(gWaveTimes); i++)
      if(now - gWaveTimes[i] < 60) gWaveTimes[k++] = gWaveTimes[i];
   ArrayResize(gWaveTimes, k);
   return k;
  }
//+------------------------------------------------------------------+
// netto della posizione dallo storico; true solo se c'e' il deal di USCITA
bool NetOfPosition(ulong posId, double &net, double &pout, string &reason)
  {
   net = 0.0; pout = 0.0; reason = "";
   bool out = false;
   if(!HistorySelectByPosition((long)posId)) return false;
   int tot = HistoryDealsTotal();
   for(int i = 0; i < tot; i++)
     {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      net += HistoryDealGetDouble(d, DEAL_PROFIT) + HistoryDealGetDouble(d, DEAL_COMMISSION) + HistoryDealGetDouble(d, DEAL_SWAP) + HistoryDealGetDouble(d, DEAL_FEE);
      long e = HistoryDealGetInteger(d, DEAL_ENTRY);
      if(e == DEAL_ENTRY_OUT || e == DEAL_ENTRY_OUT_BY)
        {
         out = true; pout = HistoryDealGetDouble(d, DEAL_PRICE);
         long r = HistoryDealGetInteger(d, DEAL_REASON);
         reason = (r == DEAL_REASON_SL ? "server SL" : (r == DEAL_REASON_TP ? "server TP" : (r == DEAL_REASON_EXPERT ? "EA (motivo perso)" : "chiusa a mano/altro")));
        }
     }
   return out;
  }
//+------------------------------------------------------------------+
void WriteCsv(string verso, double lot, double pin, double pout, int secs, double net, string why)
  {
   int h = FileOpen(gCsv, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_READ, ';');
   if(h == INVALID_HANDLE) { Log("CSV non scrivibile (" + IntegerToString(GetLastError()) + "): riga persa"); return; }
   FileSeek(h, 0, SEEK_END);
   FileWrite(h, TimeToString(TimeTradeServer(), TIME_DATE | TIME_SECONDS), _Symbol, IntegerToString(gWaveId), verso, DoubleToString(lot, 2),
             DoubleToString(pin, _Digits), DoubleToString(pout, _Digits), IntegerToString(secs),
             DoubleToString(net, 2), DoubleToString(gCumTotal, 2), why);
   FileClose(h);
  }
//+------------------------------------------------------------------+
// una posizione dell'ondata e' chiusa e contata: va nel CSV e nel netto dell'ondata
void AfterPositionClose(double net, string verso, double lot, double pin, double pout, int secs, string why)
  {
   gPosClosed++;
   gCumTotal += net;
   gWaveNet += net;
   WriteCsv(verso, lot, pin, pout, secs, net, why);
   gLastAction = "chiusa " + verso + " " + why + " netto " + DoubleToString(net, 2);
   Log(gLastAction + " (ondata " + IntegerToString(gWaveId) + ")");
  }
//+------------------------------------------------------------------+
// l'ondata e' tutta chiusa: anti-martingala e freni sul NETTO DELL'ONDATA
void AfterWave()
  {
   gWaves++;
   double net = gWaveNet;
   if(net > 0)
     {
      gConsecLoss = 0;
      gCumProgress += net;
      double steps = MathFloor(gCumProgress / MathMax(InpStepEveryEuro, 0.01));
      gLot = NormLot(InpLotStart + steps * InpLotStep);
     }
   else if(net < 0)
     {
      gConsecLoss++;
      gLossSession += -net;
      if(InpResetOnLoss) { gCumProgress = 0.0; gLot = NormLot(InpLotStart); }
     }
   gLastAction = "ondata " + IntegerToString(gWaveId) + " chiusa: netto " + DoubleToString(net, 2) + " -> lotto " + DoubleToString(gLot, 2);
   Log(gLastAction);
   gWaveOpen = false; gWaveNet = 0.0; gWaveN = 0;
   gPauseFromMs = GetTickCount();
   gPauseLenMs = (uint)MathMax(InpPauseMs, 0);
   if(gLossSession >= InpMaxLossSessionEuro) StopAll("perdita di sessione " + DoubleToString(gLossSession, 2) + " >= " + DoubleToString(InpMaxLossSessionEuro, 2));
   else if(gConsecLoss >= InpMaxConsecutiveLosses) StopAll(IntegerToString(gConsecLoss) + " ondate in perdita di fila");
  }
//+------------------------------------------------------------------+
// B3: chiude i conti delle posizioni che non ci sono piu' (chiuse da noi O dal server).
// true = niente in sospeso, si puo' aprire un'ondata nuova.
bool Settle()
  {
   bool pending = false;
   for(int i = ArraySize(gPos) - 1; i >= 0; i--)
     {
      if(PositionSelectByTicket(gPos[i].id)) { gPos[i].goneMs = 0; continue; }
      if(gPos[i].goneMs == 0) gPos[i].goneMs = GetTickCount();
      double net = 0, pout = 0; string reason = "";
      string why = gPos[i].closeWhy;
      if(!NetOfPosition(gPos[i].id, net, pout, reason))
        {
         if((uint)(GetTickCount() - gPos[i].goneMs) < 3000) { pending = true; continue; }   // storico in arrivo: aspetta
         if(why == "") { StopAll("posizione " + IntegerToString((long)gPos[i].id) + " sparita senza deal di uscita"); PosRemove(i); continue; }
         net = gPos[i].lastProfit; pout = gPos[i].pout; why += " (netto stimato)";
        }
      if(why == "") why = (reason != "" ? reason : "server SL/TP");   // closeWhy pieno vince sempre
      int secs = (int)(TimeTradeServer() - gPos[i].t);
      AfterPositionClose(net, gPos[i].verso, gPos[i].lot, gPos[i].pin, pout, secs, why);
      PosRemove(i);
     }
   if(pending) return false;
   if(ArraySize(gPos) > 0) return false;
   if(gWaveOpen) AfterWave();
   return !gWaveOpen;
  }
//+------------------------------------------------------------------+
void Adopt(ulong ticket)   // dopo un riavvio: una posizione dello scalper gia' aperta entra nei conti
  {
   if(!PositionSelectByTicket(ticket)) return;
   ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
   if(PosIndex(id) >= 0) return;
   int n = ArraySize(gPos);
   ArrayResize(gPos, n + 1);
   gPos[n].id       = id;
   gPos[n].verso    = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? "LONG" : "SHORT";
   gPos[n].lot      = PositionGetDouble(POSITION_VOLUME);
   gPos[n].pin      = PositionGetDouble(POSITION_PRICE_OPEN);
   gPos[n].t        = (datetime)PositionGetInteger(POSITION_TIME);
   gPos[n].closeWhy = ""; gPos[n].pout = 0; gPos[n].sentMs = 0; gPos[n].retryMs = 0; gPos[n].retryLen = 0; gPos[n].goneMs = 0; gPos[n].lastProfit = 0;
   if(!gWaveOpen) { gWaveOpen = true; gWaveNet = 0.0; gWaveN = 0; gWaveId++; }
   gWaveN++;
   Log("posizione adottata: " + IntegerToString((long)id));
  }
//+------------------------------------------------------------------+
void ManageOne(ulong ticket)
  {
   if(!PositionSelectByTicket(ticket)) return;
   ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
   int i = PosIndex(id);
   if(i < 0) { Adopt(ticket); i = PosIndex(id); if(i < 0) return; }
   if(gPos[i].closeWhy != "")            // chiusura gia' mandata: evita il doppio close...
     {
      if((uint)(GetTickCount() - gPos[i].sentMs) < 3000) return;
      Log("chiusura (" + gPos[i].closeWhy + ") mandata 3 s fa, posizione ancora aperta: riprovo");   // ...ma non per sempre (N1)
      gPos[i].closeWhy = "";
     }
   double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   gPos[i].lastProfit = profit;
   int age = (int)(TimeTradeServer() - gPos[i].t);
   string verso = gPos[i].verso;
   string why = "";
   if(profit >= InpTargetEuro) why = "target";
   else if(profit <= -InpStopEuro) why = "stop";
   else if(age >= InpMaxSeconds) why = "tempo";
   if(why == "") return;
   if(gPos[i].retryMs != 0 && (uint)(GetTickCount() - gPos[i].retryMs) < gPos[i].retryLen) return;   // chiusura rifiutata: si riprova dopo l'attesa
   double pout = (verso == "LONG") ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   gRequests++;
   bool okc = trade.PositionClose(ticket); uint rcc = trade.ResultRetcode();
   if(okc && (rcc == TRADE_RETCODE_DONE || rcc == TRADE_RETCODE_PLACED))   // PLACED = accettata, in volo (classe 815)
     {
      gPos[i].closeWhy = why; gPos[i].pout = pout; gPos[i].retryMs = 0; gPos[i].retryLen = 0; gPos[i].sentMs = GetTickCount();
      gLastAction = "chiusura mandata (" + why + ") " + IntegerToString((long)id);
     }
   else
     {
      gPos[i].retryMs = GetTickCount();
      gPos[i].retryLen = (gPos[i].retryLen == 0 ? 1000 : (uint)MathMin(gPos[i].retryLen * 2, 60000));   // 1, 2, 4 ... 60 s (classe 810)
      gLastAction = "chiusura RIFIUTATA (" + IntegerToString((int)rcc) + ") - riprovo fra " + IntegerToString(gPos[i].retryLen / 1000) + " s";
      Log(gLastAction);
     }
  }
//+------------------------------------------------------------------+
//| CICLO "Alta Velocita'" - formula ORIGINALE di Claudio, copiata    |
//| riga per riga da ABTG_Cycle.mq5 (CycleSeries, r.560-621), che a  |
//| sua volta la copia da ABTG_AltaVelocita.mq5 e ABTG_Ciclo.mq5.     |
//| Fedelta' al bit verificata dal cancello (25/09).                  |
//|   K1=SMA(St(5),3) K2=SMA(St(14),3) K3=SMA(St(45),14)              |
//|   K4=SMA(St(75),20)                                               |
//|   I=(4.1*K1+2.5*K2+K3+4*K4)/11.6 ; CICLO = I - SMA(I,9)           |
//| St(n) = (close-lowest(low,n))/(highest(high,n)-lowest(low,n))*100 |
//| Range nullo -> 50 (neutro), come nella fonte.                     |
//| Indice 0 = barra in corso, 1 = ultima chiusa, 2 = quella prima.   |
//| Sul grafico: il valore del pannello e' la PENULTIMA colonna       |
//| dell'indicatore (l'ultima e' la barra in corso, che si muove).    |
//+------------------------------------------------------------------+
double StocRaw_Calc(const double close, const double lo, const double hi)
  {
   double rng = hi - lo;
   if(rng <= 0.0) return(50.0);
   return((close - lo) / rng * 100.0);
  }
bool CycleSeries(ENUM_TIMEFRAMES tf, int need, double &cycOut[])
  {
   if(need < 2) need = 2;
   int maxSmo = (int)MathMax(MathMax(InpK1Smo, InpK2Smo), MathMax(InpK3Smo, InpK4Smo));
   int maxLen = (int)MathMax(MathMax(InpK1Len, InpK2Len), MathMax(InpK3Len, InpK4Len));
   int mRaw  = need + maxSmo + InpMmLen + 3;
   int nBars = mRaw + maxLen + 5;
   MqlRates r[]; ArraySetAsSeries(r, true);
   int n = CopyRates(_Symbol, tf, 0, nBars, r);
   if(n < nBars) return(false);
   int kLen[4]; int kSmo[4];
   kLen[0] = InpK1Len; kLen[1] = InpK2Len; kLen[2] = InpK3Len; kLen[3] = InpK4Len;
   kSmo[0] = InpK1Smo; kSmo[1] = InpK2Smo; kSmo[2] = InpK3Smo; kSmo[3] = InpK4Smo;
   double kSm[][4]; ArrayResize(kSm, mRaw);
   double raw[];  ArrayResize(raw, mRaw);
   for(int k = 0; k < 4; k++)
     {
      int L = kLen[k], S = kSmo[k];
      for(int i = 0; i < mRaw; i++)
        {
         int len = (int)MathMin(L, n - i);
         double hi = r[i].high, lo = r[i].low;
         for(int j = i; j < i + len; j++)
           { if(r[j].high > hi) hi = r[j].high; if(r[j].low < lo) lo = r[j].low; }
         raw[i] = StocRaw_Calc(r[i].close, lo, hi);
        }
      for(int i = 0; i < mRaw; i++)
        {
         int len = (int)MathMin(S, mRaw - i);
         double sm = 0.0;
         for(int j = i; j < i + len; j++) sm += raw[j];
         kSm[i][k] = sm / len;
        }
     }
   double comp[]; ArrayResize(comp, mRaw);
   for(int i = 0; i < mRaw; i++)
      comp[i] = (4.1 * kSm[i][0] + 2.5 * kSm[i][1] + 1.0 * kSm[i][2] + 4.0 * kSm[i][3]) / 11.6;
   ArrayResize(cycOut, need + 1);
   for(int i = 0; i <= need; i++)
     {
      int len = (int)MathMin(InpMmLen, mRaw - i);
      double sm = 0.0;
      for(int j = i; j < i + len; j++) sm += comp[j];
      cycOut[i] = comp[i] - sm / len;
     }
   return(true);
  }
//+------------------------------------------------------------------+
// ricalcola il ciclo SOLO a barra nuova (le barre chiuse non cambiano)
void CycleUpdate()
  {
   datetime bt = iTime(_Symbol, InpCandleTF, 0);
   if(bt == 0) { gCycOk = false; return; }
   if(bt == gCycBar && gCycOk) return;
   double c[];
   if(!CycleSeries(InpCandleTF, 2, c)) { gCycOk = false; return; }
   gCycBar = bt; gCyc1 = c[1]; gCyc2 = c[2]; gCycOk = true;
  }
//+------------------------------------------------------------------+
void Registra(double lot)   // apertura riuscita: la posizione entra nei conti dell'ondata
  {
   ulong id = trade.ResultOrder();
   if(trade.ResultDeal() > 0 && HistoryDealSelect(trade.ResultDeal()))
      id = (ulong)HistoryDealGetInteger(trade.ResultDeal(), DEAL_POSITION_ID);   // l'identificativo vero, dal deal d'ingresso
   int n = ArraySize(gPos);
   ArrayResize(gPos, n + 1);
   gPos[n].id       = id;
   gPos[n].verso    = (gDir > 0 ? "LONG" : "SHORT");
   gPos[n].lot      = lot;
   gPos[n].pin      = trade.ResultPrice();
   gPos[n].t        = TimeTradeServer();
   gPos[n].closeWhy = ""; gPos[n].pout = 0; gPos[n].sentMs = 0; gPos[n].retryMs = 0; gPos[n].retryLen = 0; gPos[n].goneMs = 0; gPos[n].lastProfit = 0;
   gWaveN++;
   gRejects = 0;
  }
//+------------------------------------------------------------------+
// decide il verso secondo il modo scelto; false = niente da fare adesso
bool DecideDir()
  {
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_TICK)
     {
      int n = ArraySize(gTicks);
      if(n < MathMax(InpTickWindow, 2)) { gLastAction = "TICK: raccolgo " + IntegerToString(n) + "/" + IntegerToString(InpTickWindow) + " tick"; return false; }
      double mv = MathRound((gTicks[n - 1] - gTicks[0]) / _Point);   // arrotondato: 0,99999 non e' "meno di 1 punto" (classe 820)
      int dir = 0;
      if(mv >= InpFirstMovePoints) dir = 1; else if(mv <= -InpFirstMovePoints) dir = -1;
      if(dir == 0) { gLastAction = "TICK: movimento " + DoubleToString(mv, 1) + " pt, sotto il minimo: aspetto"; return false; }
      ArrayResize(gTicks, 0);   // dopo la decisione si ricomincia a contare
      gDir = dir; gDirFromManual = false;
      return true;
     }
   if(InpEntryMode == ENTRY_CANDELA)
     {
      // VERSO BLOCCATO PER CANDELA (1.06): si decide una volta a candela nuova, poi si riusa
      datetime bt = iTime(_Symbol, InpCandleTF, 0);
      if(bt == 0) return false;
      if(bt == gLockBar)
        {
         if(gLockDir == 0) { gLastAction = "candela senza verso: aspetto la prossima"; return false; }
         if(InpMaxWavesPerCandle > 0 && gLockWaves >= InpMaxWavesPerCandle) { gLastAction = "candela: " + IntegerToString(gLockWaves) + " ondate fatte, aspetto la prossima"; return false; }
         gDir = gLockDir; gDirFromManual = false;
         return true;
        }
      // candela nuova: si decide
      int dir = 0;
      if(InpCandleRule == CR_CICLO)
        {
         CycleUpdate();
         if(!gCycOk) { gLastAction = "CICLO: storia insufficiente su " + EnumToString(InpCandleTF) + ", aspetto"; return false; }
         if(gCycBar != bt) { gLastAction = "CICLO: barra non ancora aggiornata, aspetto"; return false; }
         if(InpCicloRegola == CICLO_SEGNO)
           {
            if(MathAbs(gCyc1) < InpCicloMinimo) { dir = 0; }   // sotto il minimo: candela senza ondate
            else dir = (gCyc1 >= 0.0) ? 1 : -1;               // verde = long, rosso = short (zero esatto al lato positivo, come in ABTG_Cycle)
           }
         else
           {
            if(gCyc2 <  0.0 && gCyc1 >= 0.0) dir = 1;         // incrocio verso l'alto = minimo di ciclo formato
            else if(gCyc2 >= 0.0 && gCyc1 <  0.0) dir = -1;   // verso il basso = massimo di ciclo formato
           }
        }
      else if(InpCandleRule == CR_PREV_CANDLE)
        {
         double po = iOpen(_Symbol, InpCandleTF, 1), pc = iClose(_Symbol, InpCandleTF, 1);
         if(pc > po) dir = 1; else if(pc < po) dir = -1;
        }
      else if(InpCandleRule == CR_MEZZO_CORPO)   // "apre oltre la meta' del corpo della candela precedente"
        {
         if(TimeTradeServer() - bt < InpFirstMoveSeconds) { gLastAction = "candela nuova: leggo il prezzo contro la meta' del corpo fra " + IntegerToString(InpFirstMoveSeconds) + " s"; return false; }
         double po = iOpen(_Symbol, InpCandleTF, 1), pc = iClose(_Symbol, InpCandleTF, 1);
         double corpo = MathRound(MathAbs(pc - po) / _Point);
         double mid = (po + pc) / 2.0;
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         string perche;
         if(corpo < MathMax(InpCorpoMinimoPts, 1.0)) { dir = 0; perche = "precedente senza corpo (" + DoubleToString(corpo, 0) + " pt): laterale"; }
         else if(pc > po && bid > mid) { dir = 1;  perche = "precedente VERDE e prezzo sopra la meta' (" + DoubleToString(bid, _Digits) + " > " + DoubleToString(mid, _Digits) + ")"; }
         else if(pc < po && bid < mid) { dir = -1; perche = "precedente ROSSA e prezzo sotto la meta' (" + DoubleToString(bid, _Digits) + " < " + DoubleToString(mid, _Digits) + ")"; }
         else { dir = 0; perche = "prezzo dalla parte sbagliata della meta' (" + DoubleToString(bid, _Digits) + " vs " + DoubleToString(mid, _Digits) + ", precedente " + (pc > po ? "verde" : "rossa") + "): niente"; }
         gLastAction = "MEZZO CORPO: " + perche;
         Log(gLastAction);
        }
      else   // CR_FIRST_MOVE: "se la candela apre long..." - si ASPETTA il primo movimento, non si salta la candela
        {
         if(TimeTradeServer() - bt < InpFirstMoveSeconds) { gLastAction = "candela nuova: leggo il verso fra " + IntegerToString(InpFirstMoveSeconds) + " s"; return false; }
         double op = iOpen(_Symbol, InpCandleTF, 0);
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double mv = MathRound((bid - op) / _Point);   // arrotondato (classe 820)
         if(mv >= InpFirstMovePoints) dir = 1; else if(mv <= -InpFirstMovePoints) dir = -1;
         if(dir == 0) { gLastAction = "candela nuova: aspetto il primo movimento (" + DoubleToString(mv, 1) + " pt)"; return false; }
        }
      gLockBar = bt; gLockDir = dir; gLockWaves = 0; gCandleDone = bt;
      if(dir == 0) { gLastAction = "candela senza verso: nessuna ondata fino alla prossima"; return false; }
      gDir = dir; gDirFromManual = false;
      Log("candela " + TimeToString(bt, TIME_MINUTES) + ": verso bloccato " + (dir > 0 ? "LONG" : "SHORT"));
      return true;
     }
   return (gDir != 0);   // modo MANUALE: verso gia' noto (dalla posizione a mano o fisso)
  }
//+------------------------------------------------------------------+
// apre UNA posizione nel verso gDir; ritorna il retcode (DONE = aperta)
uint OpenOne(double lot, bool &noStops)
  {
   double slDist = EuroToPriceDist(InpStopEuro, lot);
   double tpDist = EuroToPriceDist(InpTargetEuro, lot);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = 0, tp = 0;
   bool ok = false;
   if(!noStops)
     {
      gRequests++;
      if(gDir > 0) { sl = NormalizeDouble(ask - slDist, _Digits); tp = NormalizeDouble(ask + tpDist, _Digits); ok = trade.Buy(lot, _Symbol, 0.0, sl, tp, "SCALPER LONG"); }
      else         { sl = NormalizeDouble(bid + slDist, _Digits); tp = NormalizeDouble(bid - tpDist, _Digits); ok = trade.Sell(lot, _Symbol, 0.0, sl, tp, "SCALPER SHORT"); }
      if(ok && trade.ResultRetcode() == TRADE_RETCODE_DONE) { Registra(lot); return TRADE_RETCODE_DONE; }
      if(trade.ResultRetcode() != TRADE_RETCODE_INVALID_STOPS) return trade.ResultRetcode();
      noStops = true;   // stop troppo vicino al minimo del broker: da qui in poi l'ondata va senza stop sul server (stop morbido)
     }
   gRequests++;
   ok = (gDir > 0) ? trade.Buy(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER LONG (stop morbido)")
                   : trade.Sell(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER SHORT (stop morbido)");
   if(ok && trade.ResultRetcode() == TRADE_RETCODE_DONE) { Registra(lot); return TRADE_RETCODE_DONE; }
   return trade.ResultRetcode();
  }
//+------------------------------------------------------------------+
void TryOpenWave()
  {
   if(!ContoAmmesso()) { StopAll("conto non ammesso"); return; }
   // cancelli PRIMA della decisione del verso (che consuma tick o candela)
   MqlDateTime dt; TimeToStruct(TimeTradeServer(), dt);
   if(dt.hour < InpStartHour || dt.hour >= InpEndHour) { gLastAction = "fuori orario"; return; }
   int np = Positions();
   if(gRequests + 2 * np > InpMaxRequestsPerDay) { StopAll("tetto richieste " + IntegerToString(InpMaxRequestsPerDay) + " (un'ondata intera non ci sta)"); return; }
   if(WavesLastMinute() >= InpMaxTradesPerMinute) { gLastAction = "attesa: tetto ondate al minuto"; return; }
   if(gPauseLenMs > 0 && (uint)(GetTickCount() - gPauseFromMs) < gPauseLenMs) return;
   if(!DecideDir()) return;
   if(gDir == 0) return;
   double lot = NormLot(gLot);
   gWaveOpen = true; gWaveNet = 0.0; gWaveN = 0; gWaveId++;
   int n = ArraySize(gWaveTimes);
   ArrayResize(gWaveTimes, n + 1);
   gWaveTimes[n] = TimeTradeServer();
   bool noStops = false;
   uint rc = TRADE_RETCODE_DONE;
   int aperte = 0;
   for(int k = 0; k < np; k++)
     {
      rc = OpenOne(lot, noStops);
      if(rc != TRADE_RETCODE_DONE) break;   // un rifiuto ferma l'ondata: si va avanti con quelle aperte
      aperte++;
     }
   if(aperte > 0)
     {
      if(InpEntryMode == ENTRY_CANDELA && InpCandleRule != CR_TICK) gLockWaves++;
      gLastAction = "ondata " + IntegerToString(gWaveId) + ": aperte " + IntegerToString(aperte) + "/" + IntegerToString(np) + " " + (gDir > 0 ? "LONG" : "SHORT") + " x " + DoubleToString(lot, 2)
                    + (noStops ? " SENZA stop sul server (stop morbido)" : "") + (rc != TRADE_RETCODE_DONE ? " - poi rifiuto " + IntegerToString((int)rc) : "");
      Log(gLastAction);
      return;
     }
   // nessuna aperta: l'ondata non e' mai esistita
   gWaveOpen = false; gWaveId--;
   ArrayResize(gWaveTimes, n);
   gPauseFromMs = GetTickCount();
   gPauseLenMs = 5000;
   gRejects++;
   gLastAction = "apertura RIFIUTATA (" + IntegerToString((int)rc) + ") - " + IntegerToString(gRejects) + "/5, riprovo fra 5 s";
   Log(gLastAction);
   if(gRejects >= 5) StopAll("5 aperture rifiutate di fila, ultimo codice " + IntegerToString((int)rc));
  }
//+------------------------------------------------------------------+
void Work()
  {
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_TICK)
     {
      double b = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      int n = ArraySize(gTicks);
      if(n == 0 || gTicks[n - 1] != b) { ArrayResize(gTicks, n + 1); gTicks[n] = b; if(n + 1 > MathMax(InpTickWindow, 2)) ArrayRemove(gTicks, 0, 1); }
     }
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_CICLO) CycleUpdate();   // per il pannello: il valore si vede anche da FERMO
   // verso dalla posizione a mano
   ulong mt = 0; int md = 0;
   bool manual = FindManual(mt, md);
   if(InpEntryMode == ENTRY_MANUALE && InpDirection == DIR_FROM_MANUAL)
     {
      if(gDir == 0 && manual) { gDir = md; gDirFromManual = true; gLastAction = "verso preso dalla tua posizione: " + (md > 0 ? "LONG" : "SHORT"); Log(gLastAction); if(InpAutoStart && !gActive) StartAll(); }
      else if(gDirFromManual && manual && md != gDir) { gDir = md; gLastAction = "verso aggiornato dalla tua posizione: " + (md > 0 ? "LONG" : "SHORT"); Log(gLastAction); }
      if(gActive && gDirFromManual && InpStopWhenManualClosed && !manual) { StopAll("posizione manuale chiusa"); gDir = 0; gDirFromManual = false; }
     }
   // B3/B4: prima si chiudono i conti delle posizioni sparite, poi si gestiscono quelle aperte, SEMPRE (anche da FERMO)
   bool settled = Settle();
   ulong mine[];
   int nm = FindMine(mine);
   if(nm > 0) { for(int i = 0; i < nm; i++) ManageOne(mine[i]); Status(); return; }
   if(!settled) { Status(); return; }
   if(!gActive) { Status(); return; }
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) { gLastAction = "Algo Trading spento"; Status(); return; }
   TryOpenWave();
   Status();
  }
//+------------------------------------------------------------------+
void OnTick()  { Work(); }
void OnTimer() { Work(); }   // il tempo massimo scatta anche senza tick (orologio TimeTradeServer)
//+------------------------------------------------------------------+
