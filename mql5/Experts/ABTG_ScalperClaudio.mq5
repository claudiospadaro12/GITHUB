//+------------------------------------------------------------------+
//|                                          ABTG_ScalperClaudio.mq5 |
//|  "Scalper Claudio" - idea di Claudio, 14/11/2026.                |
//|                                                                  |
//|  Descrizione di Claudio (testuale):                              |
//|  - chiude e riapre operazioni solo quando sono positive;         |
//|  - all'inizio ne apre poche, poi in base a come accelera il      |
//|    prezzo ne apre altre in sequenza, anche 7 o 8 insieme;        |
//|  - gli ordini si aprono a 1 o 2 punti di distanza, stesso lotto, |
//|    "simili";                                                     |
//|  - "alla apertura degli ordini, se il prezzo si e' girato long o |
//|    short, gli ordini devono aprire long o short: in 1 o 2        |
//|    secondi l'EA, in base a come si e' mosso il prezzo, apre piu' |
//|    ordini nella direzione dove e' andato il prezzo";             |
//|  - "tutto quando diventano blu poi li chiude".                   |
//|                                                                  |
//|  Criteri e previsioni scritti PRIMA del codice:                  |
//|  report/EA_SOLO_POSITIVE_ACCELERAZIONE_CRITERI_2026-11-14.md     |
//|                                                                  |
//|  SOLO DEMO E TESTER. NON per FTMO (equity, limite di circa 2.000 |
//|  richieste al giorno, condizioni 7.1) e NON per il reale 10105439|
//|  In live parte SOLO sul conto demo hedging 50503635 (controllo   |
//|  in OnInit). Nel tester gira ovunque, ma richiede conto HEDGING. |
//|                                                                  |
//|  Regole:                                                         |
//|  1) DIREZIONE a ogni apertura = segno dello spostamento del bid  |
//|     negli ultimi InpLookbackSec secondi, se >= InpMinMovePoints; |
//|     altrimenti niente. Se c'e' un cesto aperto, si aggiunge SOLO |
//|     nello stesso verso del cesto.                                |
//|  2) NUMERO di ordini = floor(spostamento / InpPointsPerOrder),   |
//|     da 1 a InpMaxOpen, mai oltre InpMaxTotalLots lotti totali.   |
//|  3) SOLO AGGIUNTE AI VINCITORI: nuovi ordini solo se il P/L del  |
//|     cesto (stima netta: profitto + swap + 2 x commissione di     |
//|     ingresso) e' >= 0. Mai media al ribasso.                     |
//|  4) USCITA: InpExitMode 0 = ogni posizione chiude quando il suo  |
//|     netto e' >= InpTargetEuro; 1 = si chiude TUTTO il cesto      |
//|     quando il netto complessivo e' >= InpBasketTargetEuro.       |
//|     NESSUNO STOP sulla singola posizione.                        |
//|  5) FRENO OBBLIGATORIO (stop mascherato): se il netto del cesto  |
//|     scende sotto -InpBasketStopEuro, chiude tutto e aspetta      |
//|     InpCooldownMin minuti.                                       |
//|  6) La "distanza di 1-2 punti" fra le entrate NON e' imposta: i  |
//|     market order a raffica partono a prezzi quasi uguali; la     |
//|     distanza reale e' MISURATA e stampata. InpGapMaxPoints e' una|
//|     guardia: se il prezzo scappa oltre questa distanza dalla     |
//|     prima entrata del passo, il passo si ferma.                  |
//|  7) Tempo: SOLO millisecondi dei tick (time_msc): nessun uso di  |
//|     GetTickCount(), cosi' il tester a tick reali e' valido.      |
//|                                                                  |
//|  Misura S-9 (criteri): per ogni passo registra il prezzo medio e |
//|  dopo InpSignalCheckSec secondi controlla se il prezzo ha        |
//|  proseguito nella direzione scelta di almeno InpMinMovePoints.   |
//|  Il riepilogo finale (journal e CSV) dice quanto spesso la       |
//|  direzione aveva "ragione".                                      |
//|                                                                  |
//|  1.01 (richiesta di Claudio: "i lotti vanno in crescita man mano |
//|  che si vince, tipo a piramide"): InpLotMode 1 = il lotto sale   |
//|  con i guadagni chiusi (ogni InpLotStepEuro +InpLotStep, tetto   |
//|  InpLotMax); 2 = in piu' sale a ogni passo aggiunto al cesto.    |
//|  MAI dopo una perdita; il freno azzera. Tetto totale 0,20 lotti. |
//|                                                                  |
//|  1.02 (richiesta di Claudio: "se si perde gli ordini si chiudono |
//|  a saldo flottante 0"): InpRecoveryToZero. Se il netto del cesto |
//|  scende sotto -InpUnderwaterEuro, nessuna chiusura parziale e    |
//|  nessuna aggiunta finche' il netto non torna a >= InpZeroEuro;   |
//|  allora si chiude TUTTO. Il freno (-InpBasketStopEuro) resta     |
//|  attivo: senza, un cesto in perdita puo' restare aperto per      |
//|  sempre e il rischio non ha limite.                             |
//|                                                                  |
//|  1.03 (15/11/2026): correzioni dopo la prima misura (-96,5% in   |
//|  3 mesi a tick reali): (a) niente spam di ordini a mercato       |
//|  chiuso: pausa dopo un rifiuto e controllo della sessione;       |
//|  (b) passi e segnali contati solo se almeno un ordine si apre;   |
//|  (c) netto per motivo di uscita nel riepilogo; (d) obiettivo e   |
//|  limite di perdita GIORNALIERI (0 = spenti); (e) misura del      |
//|  vantaggio: mossa dopo 5, 30 e 120 s, lorda e al netto dello     |
//|  spread, per ora, velocita e rapporto spread/mossa.              |
//|  Criteri: report/ABTG_SCALPER_CLAUDIO_V103_CRITERI_2026-11-15.md |
//|                                                                  |
//|  Non e' una strategia provata: e' una misura. Nessun giudizio su |
//|  lotti o taglie.                                                 |
//+------------------------------------------------------------------+
// MARCATORE_ABTG_SCALPER_CLAUDIO_v1 (controllato dalla riga che scarica questo file)
#property copyright "ABTG"
#property version   "1.03"
#include <Trade\Trade.mqh>

#define CONTO_AMMESSO 50503635
#define RING          4096
#define SIGQ          256
#define EH            3      // orizzonti della misura del vantaggio (5, 30, 120 s)
#define EDIM          3      // dimensioni: velocita, ora, rapporto spread/mossa
#define EBMAX         6

enum ENUM_EXIT_MODE { EXIT_PER_POSIZIONE = 0, EXIT_A_CESTO = 1 };

void PrintEdge();

input group "=== Ingresso: direzione dal movimento del bid ==="
input int             InpLookbackSec      = 2;      // secondi su cui si misura il movimento (1-2)
input double          InpMinMovePoints    = 3.0;    // movimento minimo in PUNTI MT5 per decidere (sotto: niente)
input double          InpPointsPerOrder   = 3.0;    // 1 ordine ogni X punti di movimento
input int             InpMaxOpen          = 8;      // posizioni aperte insieme (max)
input double          InpLot              = 0.01;   // lotto di ogni posizione (uguale per tutte)
input double          InpMaxTotalLots     = 0.20;   // tetto ai lotti totali aperti
input int             InpLotMode          = 1;      // 0 = lotto fisso; 1 = il lotto SALE con i guadagni chiusi (piramide sul guadagno); 2 = come 1 e in piu' sale a ogni passo aggiunto al cesto
input double          InpLotStepEuro      = 10.0;   // modo 1/2: ogni X euro di guadagno chiuso (dall'ultimo azzeramento) il lotto sale di InpLotStep
input double          InpLotStep          = 0.01;   // aumento del lotto
input double          InpLotMax           = 0.05;   // tetto del lotto per posizione
input double          InpGapMaxPoints     = 10.0;   // guardia: il passo si ferma se il prezzo scappa oltre X punti dalla prima entrata
input int             InpStepPauseMs      = 1000;   // pausa minima fra due passi (ms di tick)
input int             InpMaxSpreadPoints  = 0;      // 0 = nessun filtro; altrimenti non apre se lo spread supera X punti

input group "=== Uscita (solo in profitto) ==="
input ENUM_EXIT_MODE  InpExitMode         = EXIT_PER_POSIZIONE; // 0 = ogni posizione al suo target, 1 = tutto il cesto insieme
input double          InpTargetEuro       = 1.5;    // modo 0: chiude quando il netto della posizione e' >= X (valuta del conto)
input double          InpBasketTargetEuro = 2.0;    // modo 1: chiude tutto quando il netto del cesto e' >= X
input bool            InpRecoveryToZero   = true;   // se il cesto va in perdita, NON si chiude piu' nulla finche' il netto del cesto torna a InpZeroEuro; poi si chiude TUTTO ("a saldo flottante 0")
input double          InpUnderwaterEuro   = 3.0;    // il cesto e' "in perdita" solo se il netto scende sotto -X (altrimenti lo spread subito dopo l'apertura lo farebbe sembrare in perdita)
input double          InpZeroEuro         = 0.0;    // soglia di uscita del recupero: il netto del cesto torna a >= X

input group "=== Freno (obbligatorio) ==="
input double          InpBasketStopEuro   = 20.0;   // se il netto del cesto scende sotto -X chiude tutto
input int             InpCooldownMin      = 30;     // minuti di pausa dopo lo scatto del freno
input int             InpMaxRequestsPerDay= 0;      // 0 = nessun tetto (si MISURA); altrimenti richieste al server al giorno
input int             InpStartHour        = 0;      // ora SERVER da cui puo' operare
input int             InpEndHour          = 24;     // ora SERVER oltre la quale si ferma (24 = mai)

input group "=== Giornata (0 = spento) ==="
input double          InpDailyTargetEuro  = 0.0;    // se il guadagno del giorno (chiuso + cesto aperto) raggiunge X: chiude tutto e NON riapre fino al giorno dopo (ora server)
input double          InpDailyLossEuro    = 0.0;    // se la perdita del giorno raggiunge X: chiude tutto e NON riapre fino al giorno dopo

input group "=== Generali ==="
input long            InpMagic            = 779902; // magic dell'EA
input int             InpDeviationPts     = 50;     // slippage ammesso in punti
input int             InpSignalCheckSec   = 10;     // secondi dopo cui si controlla se la direzione aveva ragione
input bool            InpWriteCsv         = true;   // scrive il CSV per posizione (cartella comune)
input bool            InpVerbose          = false;  // log dettagliato nel giornale

struct SBasket
  {
   int    n;          // posizioni aperte dell'EA
   int    dir;        // +1 long, -1 short, 0 nessuna
   double lots;       // lotti totali aperti
   double net;        // netto stimato complessivo
  };

//--- stato
bool     gUnderwater = false;    // il cesto e' sceso sotto -InpUnderwaterEuro: modo recupero
double   gCumProgress = 0.0;   // guadagno chiuso che fa salire il lotto (si azzera col freno)
int      gBasketSteps = 0;       // passi aggiunti al cesto in corso (modo 2)
double   gMaxLotSeen = 0.0;
CTrade   trade;
double   gTkBid[RING];
long     gTkMsc[RING];
int      gTkHead = 0, gTkCnt = 0;
long     gLastStepMsc = 0;
datetime gCooldownUntil = 0;
string   gCloseReason = "";
//--- commissione di ingresso per posizione (identificativo)
ulong    gCommId[];
double   gCommVal[];
//--- richieste al server
int      gReqToday = 0, gReqMaxDay = 0, gDayKey = 0;
long     gReqTotal = 0;
//--- statistiche
long     gSteps = 0, gOpened = 0, gClosed = 0, gWins = 0;
double   gSumNet = 0.0, gSumLife = 0.0, gGrossWin = 0.0, gGrossLoss = 0.0;
long     gBrake = 0, gLongLived = 0, gRejects = 0;
double   gMaxFloatLoss = 0.0;
int      gMaxOpenSeen = 0;
double   gGapSum = 0.0; long gGapN = 0;
long     gCloseTarget = 0, gCloseBasket = 0, gCloseBrake = 0, gCloseZero = 0, gCloseOther = 0;
long     gRecoveries = 0;
//--- misura S-9: coda di segnali da controllare
long     gSigMsc[SIGQ];
int      gSigDir[SIGQ];
double   gSigMid[SIGQ];
int      gSigHead = 0, gSigCnt = 0;
long     gSigN = 0, gSigWin = 0, gSigRev = 0;
string   gCsv = "";
//--- 1.03: tempo, pause dopo i rifiuti, netto per motivo, giornata, misura del vantaggio
long     gNowMsc = 0, gOpenPauseUntil = 0, gClosePauseUntil = 0;
double   gNetT = 0.0, gNetC = 0.0, gNetF = 0.0, gNetZ = 0.0, gNetO = 0.0;
double   gDayRealized = 0.0;
bool     gDayStop = false;
long     gDayTargetHits = 0, gDayLossHits = 0;
long     gEvMsc[SIGQ];
int      gEvDir[SIGQ], gEvStage[SIGQ], gEvB0[SIGQ], gEvB1[SIGQ], gEvB2[SIGQ];
double   gEvMid[SIGQ], gEvSp[SIGQ];
int      gEvHead = 0, gEvCnt = 0;
long     gEdN[EH * EDIM * EBMAX];
double   gEdG[EH * EDIM * EBMAX], gEdC[EH * EDIM * EBMAX], gEdQ[EH * EDIM * EBMAX];
ulong    gLastStatusMs = 0;

//+------------------------------------------------------------------+
bool IsTester() { return (bool)MQLInfoInteger(MQL_TESTER); }
//+------------------------------------------------------------------+
void LogV(string s) { if(InpVerbose) Print("[SCALPER CLAUDIO] ", s); }
//+------------------------------------------------------------------+
bool ContoOk()
  {
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) return false;   // serve HEDGING (piu' posizioni sullo stesso simbolo)
   if(IsTester()) return true;
   return (AccountInfoInteger(ACCOUNT_LOGIN) == CONTO_AMMESSO
           && AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO);
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
   return NormalizeDouble(lot, 8);
  }
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!ContoOk())
     {
      Alert("ABTG_ScalperClaudio: serve un conto HEDGING; in live SOLO il demo ", CONTO_AMMESSO, " (qui ", AccountInfoInteger(ACCOUNT_LOGIN), "): NON parto");
      return(INIT_FAILED);
     }
   double vmin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(vmin > InpLot + 1e-9) { Alert("ABTG_ScalperClaudio: VOLUME_MIN ", DoubleToString(vmin, 2), " > lotto dichiarato: NON alzo la taglia da solo, NON parto"); return(INIT_FAILED); }
   if(InpLookbackSec < 1 || InpLookbackSec > 5) { Alert("ABTG_ScalperClaudio: InpLookbackSec deve essere fra 1 e 5"); return(INIT_FAILED); }
   if(InpMaxOpen < 1 || InpMaxOpen > 20) { Alert("ABTG_ScalperClaudio: InpMaxOpen deve essere fra 1 e 20"); return(INIT_FAILED); }
   if(InpMinMovePoints <= 0.0 || InpPointsPerOrder <= 0.0 || InpTargetEuro <= 0.0 || InpBasketTargetEuro <= 0.0 || InpBasketStopEuro <= 0.0)
     { Alert("ABTG_ScalperClaudio: soglie e target devono essere > 0 (il freno e' obbligatorio)"); return(INIT_FAILED); }
   if(InpLotMode < 0 || InpLotMode > 2 || InpLotMax < InpLot - 1e-9 || InpLotStep < 0.0 || InpLotStepEuro <= 0.0) { Alert("ABTG_ScalperClaudio: parametri del lotto non validi (modo 0-2, InpLotMax >= InpLot, passo >= 0)"); return(INIT_FAILED); }
   if(InpDailyTargetEuro < 0.0 || InpDailyLossEuro < 0.0) { Alert("ABTG_ScalperClaudio: obiettivo e limite giornalieri non possono essere negativi (0 = spenti)"); return(INIT_FAILED); }
   if(InpMaxTotalLots < NormLot(InpLot) - 1e-9) { Alert("ABTG_ScalperClaudio: InpMaxTotalLots < lotto singolo"); return(INIT_FAILED); }
   trade.SetExpertMagicNumber((ulong)InpMagic);
   trade.SetDeviationInPoints((ulong)InpDeviationPts);
   trade.SetTypeFillingBySymbol(_Symbol);
   ArrayResize(gCommId, 0); ArrayResize(gCommVal, 0);
   gTkHead = 0; gTkCnt = 0; gLastStepMsc = 0; gCooldownUntil = 0; gSigHead = 0; gSigCnt = 0;
   gEvHead = 0; gEvCnt = 0; gDayStop = false; gDayRealized = 0.0; gOpenPauseUntil = 0; gClosePauseUntil = 0;
   ArrayInitialize(gEdN, 0); ArrayInitialize(gEdG, 0.0); ArrayInitialize(gEdC, 0.0); ArrayInitialize(gEdQ, 0.0);
   gCsv = "abtg_scalper_claudio_" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + ".csv";
   if(InpWriteCsv && !FileIsExist(gCsv, FILE_COMMON))
     {
      int h = FileOpen(gCsv, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON | FILE_SHARE_READ, ';');
      if(h != INVALID_HANDLE)
        {
         FileWrite(h, "ora_chiusura", "simbolo", "posizione", "verso", "lotto", "ingresso", "uscita", "secondi", "netto", "motivo");
         FileClose(h);
        }
     }
   Print("[SCALPER CLAUDIO] 1.03 caricato su ", _Symbol, " - ", (IsTester() ? "TESTER" : "DEMO"),
         " - 1 punto = ", DoubleToString(_Point, _Digits), " (prezzo) - tickvalue ", DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE), 4),
         " - vmin ", DoubleToString(vmin, 2), " - spread ", IntegerToString(SymbolInfoInteger(_Symbol, SYMBOL_SPREAD)), " pt - modo uscita ", IntegerToString((int)InpExitMode));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
   double wr = (gClosed > 0 ? 100.0 * (double)gWins / (double)gClosed : 0.0);
   double pf = (gGrossLoss > 0.0 ? gGrossWin / gGrossLoss : 0.0);
   double avgLife = (gClosed > 0 ? gSumLife / (double)gClosed : 0.0);
   double avgGap = (gGapN > 0 ? gGapSum / (double)gGapN : 0.0);
   double sigAcc = (gSigN > 0 ? 100.0 * (double)gSigWin / (double)gSigN : 0.0);
   double sigRev = (gSigN > 0 ? 100.0 * (double)gSigRev / (double)gSigN : 0.0);
   string s1 = "RIEPILOGO passi " + IntegerToString((int)gSteps) + ", aperte " + IntegerToString((int)gOpened) + ", chiuse " + IntegerToString((int)gClosed)
               + ", win rate " + DoubleToString(wr, 1) + "%, netto " + DoubleToString(gSumNet, 2) + ", PF " + DoubleToString(pf, 2)
               + ", vita media " + DoubleToString(avgLife, 1) + " s, vissute oltre 1 ora " + IntegerToString((int)gLongLived);
   string s2 = "RIEPILOGO freno " + IntegerToString((int)gBrake) + " scatti, uscite: target " + IntegerToString((int)gCloseTarget) + ", cesto " + IntegerToString((int)gCloseBasket)
               + ", freno " + IntegerToString((int)gCloseBrake) + ", a zero " + IntegerToString((int)gCloseZero) + " (cesti in recupero " + IntegerToString((int)gRecoveries) + "), altro " + IntegerToString((int)gCloseOther)
               + ", lotto massimo usato " + DoubleToString(gMaxLotSeen, 2) + ", perdita fluttuante massima " + DoubleToString(gMaxFloatLoss, 2) + ", posizioni aperte massime " + IntegerToString(gMaxOpenSeen);
   string s3 = "RIEPILOGO distanza media fra entrate successive di un passo " + DoubleToString(avgGap, 1) + " punti (n " + IntegerToString((int)gGapN) + "), rifiuti " + IntegerToString((int)gRejects)
               + ", richieste totali " + IntegerToString((int)gReqTotal) + ", massimo in un giorno " + IntegerToString(MathMax(gReqMaxDay, gReqToday));
   string s4 = "RIEPILOGO S-9 direzione: " + IntegerToString((int)gSigN) + " segnali controllati a " + IntegerToString(InpSignalCheckSec) + " s: proseguito " + DoubleToString(sigAcc, 1)
               + "%, tornato indietro oltre la soglia " + DoubleToString(sigRev, 1) + "%";
   Print("[SCALPER CLAUDIO] ", s1);
   Print("[SCALPER CLAUDIO] ", s2);
   Print("[SCALPER CLAUDIO] ", s3);
   Print("[SCALPER CLAUDIO] ", s4);
   string s5 = "RIEPILOGO netto per motivo: target " + DoubleToString(gNetT, 2) + ", cesto " + DoubleToString(gNetC, 2) + ", freno " + DoubleToString(gNetF, 2)
               + ", a zero " + DoubleToString(gNetZ, 2) + ", altro/giornata " + DoubleToString(gNetO, 2)
               + "; giornate chiuse a obiettivo " + IntegerToString((int)gDayTargetHits) + ", a limite di perdita " + IntegerToString((int)gDayLossHits);
   Print("[SCALPER CLAUDIO] ", s5);
   PrintEdge();
   if(InpWriteCsv)
     {
      int h = FileOpen("abtg_scalper_claudio_riepilogo.csv", FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON | FILE_SHARE_READ, ';');
      if(h != INVALID_HANDLE)
        {
         FileSeek(h, 0, SEEK_END);
         FileWrite(h, TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS), _Symbol, s1, s2, s3, s4, s5);
         FileClose(h);
        }
     }
  }
//+------------------------------------------------------------------+
//| anello dei tick                                                  |
//+------------------------------------------------------------------+
void RingPush(long msc, double bid)
  {
   gTkMsc[gTkHead] = msc; gTkBid[gTkHead] = bid;
   gTkHead = (gTkHead + 1) % RING;
   if(gTkCnt < RING) gTkCnt++;
  }
// bid dell'ultimo tick con tempo <= targetMsc; ok=false se la storia non basta
double BidAtOrBefore(long targetMsc, bool &ok)
  {
   ok = false;
   for(int k = 0; k < gTkCnt; k++)
     {
      int idx = (gTkHead - 1 - k + RING * 2) % RING;
      if(gTkMsc[idx] <= targetMsc) { ok = true; return gTkBid[idx]; }
     }
   return 0.0;
  }
//+------------------------------------------------------------------+
//| commissione di ingresso per posizione                            |
//+------------------------------------------------------------------+
void CommAdd(ulong id, double comm)
  {
   int n = ArraySize(gCommId);
   ArrayResize(gCommId, n + 1); ArrayResize(gCommVal, n + 1);
   gCommId[n] = id; gCommVal[n] = comm;
  }
double CommGet(ulong id)
  {
   for(int i = 0; i < ArraySize(gCommId); i++) if(gCommId[i] == id) return gCommVal[i];
   return 0.0;
  }
void CommDel(ulong id)
  {
   int n = ArraySize(gCommId);
   for(int i = 0; i < n; i++)
      if(gCommId[i] == id)
        {
         gCommId[i] = gCommId[n - 1]; gCommVal[i] = gCommVal[n - 1];
         ArrayResize(gCommId, n - 1); ArrayResize(gCommVal, n - 1);
         return;
        }
  }
//+------------------------------------------------------------------+
//| il cesto: tutte le posizioni dell'EA su questo simbolo           |
//+------------------------------------------------------------------+
void ReadBasket(SBasket &b)
  {
   b.n = 0; b.dir = 0; b.lots = 0.0; b.net = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      double net = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) + 2.0 * CommGet(id);   // commissione di ingresso x2 = andata e ritorno (stima)
      b.n++;
      b.lots += PositionGetDouble(POSITION_VOLUME);
      b.net += net;
      b.dir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
     }
  }
//+------------------------------------------------------------------+
void ReqCount()
  {
   gReqToday++; gReqTotal++;
  }
//+------------------------------------------------------------------+
void DayRoll(datetime t)
  {
   MqlDateTime d; TimeToStruct(t, d);
   int key = d.year * 10000 + d.mon * 100 + d.day;
   if(key != gDayKey)
     {
      if(gReqToday > gReqMaxDay) gReqMaxDay = gReqToday;
      gReqToday = 0; gDayKey = key;
      gDayRealized = 0.0; gDayStop = false;   // giornata nuova (ora server): si riparte
     }
  }
//+------------------------------------------------------------------+
void CloseAll(string why)
  {
   if(gNowMsc < gClosePauseUntil) return;   // dopo un rifiuto (mercato chiuso ecc.) non si ripete a ogni tick
   gCloseReason = why;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      ReqCount();
      if(!trade.PositionClose(t))
        {
         uint rcc = trade.ResultRetcode();
         gRejects++;
         gClosePauseUntil = gNowMsc + (rcc == TRADE_RETCODE_MARKET_CLOSED ? 60000 : 3000);
         LogV("chiusura rifiutata " + IntegerToString((int)rcc));
         break;
        }
     }
  }
//+------------------------------------------------------------------+
// true se ha chiuso qualcosa (per ripartire dal prossimo tick)
bool ManageExit(const SBasket &b)
  {
   if(b.n > gMaxOpenSeen) gMaxOpenSeen = b.n;
   if(b.net < gMaxFloatLoss) gMaxFloatLoss = b.net;
   if(b.net <= -InpBasketStopEuro)
     {
      gBrake++;
      gUnderwater = false;
      gCooldownUntil = TimeCurrent() + InpCooldownMin * 60;
      LogV("FRENO: netto cesto " + DoubleToString(b.net, 2) + " -> chiudo tutto, pausa " + IntegerToString(InpCooldownMin) + " min");
      CloseAll("freno");
      return true;
     }
   if(InpRecoveryToZero)
     {
      if(b.net < -InpUnderwaterEuro && !gUnderwater) { gUnderwater = true; gRecoveries++; LogV("cesto in perdita " + DoubleToString(b.net, 2) + ": aspetto il ritorno a " + DoubleToString(InpZeroEuro, 2)); }
      if(gUnderwater)
        {
         if(b.net >= InpZeroEuro) { gUnderwater = false; CloseAll("zero"); return true; }
         return false;   // in recupero: nessuna chiusura parziale, nessuna aggiunta (b.net < 0 blocca TryEntry)
        }
     }
   if(InpExitMode == EXIT_A_CESTO)
     {
      if(b.net >= InpBasketTargetEuro) { CloseAll("cesto"); return true; }
      return false;
     }
   bool any = false;
   if(gNowMsc < gClosePauseUntil) return false;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      ulong id = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      double net = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP) + 2.0 * CommGet(id);
      if(net >= InpTargetEuro)
        {
         gCloseReason = "target";
         ReqCount();
         if(trade.PositionClose(t)) any = true;
         else
           {
            uint rct = trade.ResultRetcode();
            gRejects++;
            gClosePauseUntil = gNowMsc + (rct == TRADE_RETCODE_MARKET_CLOSED ? 60000 : 3000);
            break;
           }
        }
     }
   return any;
  }
//+------------------------------------------------------------------+
// apre UNA posizione a mercato; true se aperta
bool OpenOne(int dir, double lot, double &entry)
  {
   ReqCount();
   bool ok = (dir > 0) ? trade.Buy(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER CLAUDIO")
                       : trade.Sell(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER CLAUDIO");
   uint rc = trade.ResultRetcode();
   if(!ok || rc != TRADE_RETCODE_DONE)
     {
      gRejects++;
      gOpenPauseUntil = gNowMsc + (rc == TRADE_RETCODE_MARKET_CLOSED ? 300000 : 10000);   // mercato chiuso: 5 min; altri rifiuti: 10 s
      LogV("apertura rifiutata " + IntegerToString((int)rc));
      return false;
     }
   entry = trade.ResultPrice();
   ulong deal = trade.ResultDeal();
   ulong pid = trade.ResultOrder();
   double comm = 0.0;
   if(deal > 0 && HistoryDealSelect(deal))
     {
      comm = HistoryDealGetDouble(deal, DEAL_COMMISSION);
      pid = (ulong)HistoryDealGetInteger(deal, DEAL_POSITION_ID);
     }
   CommAdd(pid, comm);
   gOpened++;
   return true;
  }
//+------------------------------------------------------------------+
//| misura del vantaggio (1.03): mossa dopo 5, 30 e 120 s, lorda e al netto dello spread
void EvPush(long msc, int dir, double mid, double spPts, double movePts, int hour)
  {
   if(gEvCnt == SIGQ) { gEvHead = (gEvHead + 1) % SIGQ; gEvCnt--; }
   int idx = (gEvHead + gEvCnt) % SIGQ;
   double am = MathAbs(movePts);
   double r0 = (InpMinMovePoints > 0.0 ? am / InpMinMovePoints : 0.0);
   int b0 = (r0 < 2.0 ? 0 : (r0 < 3.0 ? 1 : (r0 < 5.0 ? 2 : 3)));
   int b1 = hour / 4;
   if(b1 > 5) b1 = 5;
   if(b1 < 0) b1 = 0;
   double rr = (am > 0.0 ? spPts / am : 99.0);
   int b2 = (rr < 0.5 ? 0 : (rr < 1.0 ? 1 : (rr < 2.0 ? 2 : 3)));
   gEvMsc[idx] = msc; gEvDir[idx] = dir; gEvMid[idx] = mid; gEvSp[idx] = spPts;
   gEvB0[idx] = b0; gEvB1[idx] = b1; gEvB2[idx] = b2; gEvStage[idx] = 0;
   gEvCnt++;
  }
void EvRecord(int h, int dim, int b, double gross, double net)
  {
   int k = (h * EDIM + dim) * EBMAX + b;
   gEdN[k]++; gEdG[k] += gross; gEdC[k] += net; gEdQ[k] += net * net;
  }
void EvCheck(const MqlTick &tk)
  {
   long hz[3] = {5000, 30000, 120000};
   double mid = (tk.bid + tk.ask) / 2.0;
   for(int k = 0; k < gEvCnt; k++)
     {
      int idx = (gEvHead + k) % SIGQ;
      while(gEvStage[idx] < EH && tk.time_msc - gEvMsc[idx] >= hz[gEvStage[idx]])
        {
         int h = gEvStage[idx];
         gEvStage[idx]++;
         if(tk.time_msc - gEvMsc[idx] > 3 * hz[h]) continue;   // buco di mercato (chiusura/weekend): quella misura non vale
         double gross = (double)gEvDir[idx] * (mid - gEvMid[idx]) / _Point;
         double net = gross - gEvSp[idx];
         EvRecord(h, 0, gEvB0[idx], gross, net);
         EvRecord(h, 1, gEvB1[idx], gross, net);
         EvRecord(h, 2, gEvB2[idx], gross, net);
        }
     }
   while(gEvCnt > 0 && gEvStage[gEvHead] >= EH) { gEvHead = (gEvHead + 1) % SIGQ; gEvCnt--; }
  }
void PrintEdge()
  {
   string hn[3] = {"5s", "30s", "120s"};
   string dn[3] = {"velocita", "ora", "spread/mossa"};
   int nb[3] = {4, 6, 4};
   for(int h = 0; h < EH; h++)
      for(int d = 0; d < EDIM; d++)
         for(int b = 0; b < nb[d]; b++)
           {
            int k = (h * EDIM + d) * EBMAX + b;
            if(gEdN[k] == 0) continue;
            double n = (double)gEdN[k];
            double mg = gEdG[k] / n, mc = gEdC[k] / n;
            double var = gEdQ[k] / n - mc * mc;
            double sd = (var > 0.0 ? MathSqrt(var) : 0.0);
            double tt = (sd > 0.0 ? mc / (sd / MathSqrt(n)) : 0.0);
            Print("[SCALPER CLAUDIO] EDGE ", hn[h], " ", dn[d], " bucket ", b, ": n ", IntegerToString((int)gEdN[k]), ", lordo ", DoubleToString(mg, 2),
                  " pt, netto spread ", DoubleToString(mc, 2), " pt, t ", DoubleToString(tt, 2));
           }
  }
//+------------------------------------------------------------------+
void SigPush(long msc, int dir, double mid)
  {
   if(gSigCnt == SIGQ) { gSigHead = (gSigHead + 1) % SIGQ; gSigCnt--; }   // coda piena: si butta il piu' vecchio
   int idx = (gSigHead + gSigCnt) % SIGQ;
   gSigMsc[idx] = msc; gSigDir[idx] = dir; gSigMid[idx] = mid;
   gSigCnt++;
  }
void SigCheck(const MqlTick &tk)
  {
   long dueMs = (long)InpSignalCheckSec * 1000;
   while(gSigCnt > 0 && tk.time_msc - gSigMsc[gSigHead] >= dueMs)
     {
      double mid = (tk.bid + tk.ask) / 2.0;
      double prog = (double)gSigDir[gSigHead] * (mid - gSigMid[gSigHead]) / _Point;
      gSigN++;
      if(prog >= InpMinMovePoints) gSigWin++;
      else if(prog <= -InpMinMovePoints) gSigRev++;
      gSigHead = (gSigHead + 1) % SIGQ; gSigCnt--;
     }
  }
//+------------------------------------------------------------------+
// lotto del passo: sale SOLO con i guadagni (anti-martingala), mai dopo una perdita; il freno azzera
double CurLot(const SBasket &b)
  {
   double lot = InpLot;
   if(InpLotMode >= 1) lot += MathFloor(MathMax(gCumProgress, 0.0) / InpLotStepEuro) * InpLotStep;
   if(InpLotMode == 2 && b.n > 0) lot += gBasketSteps * InpLotStep;
   if(lot > InpLotMax) lot = InpLotMax;
   return NormLot(lot);
  }
//+------------------------------------------------------------------+
void TryEntry(const MqlTick &tk, const SBasket &b)
  {
   if(gDayStop) return;
   if(TimeCurrent() < gCooldownUntil) return;
   if(tk.time_msc < gOpenPauseUntil) return;
   if(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_MODE) != SYMBOL_TRADE_MODE_FULL) return;
   MqlDateTime dt; TimeToStruct(tk.time, dt);
   if(dt.hour < InpStartHour || dt.hour >= InpEndHour) return;
   if(InpMaxSpreadPoints > 0 && (tk.ask - tk.bid) / _Point > InpMaxSpreadPoints) return;
   if(InpMaxRequestsPerDay > 0 && gReqToday >= InpMaxRequestsPerDay) return;
   if(!IsTester() && (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
   if(tk.time_msc - gLastStepMsc < InpStepPauseMs) return;
   if(b.n > 0 && b.net < 0.0) return;         // solo aggiunte ai vincitori
   if(b.n >= InpMaxOpen) return;
   // direzione dal movimento del bid negli ultimi InpLookbackSec secondi
   bool ok = false;
   double ref = BidAtOrBefore(tk.time_msc - (long)InpLookbackSec * 1000, ok);
   if(!ok) return;
   double move = (tk.bid - ref) / _Point;
   int dir = 0;
   if(move >= InpMinMovePoints) dir = 1; else if(move <= -InpMinMovePoints) dir = -1;
   if(dir == 0) return;
   if(b.n > 0 && dir != b.dir) return;         // il verso cambia solo a cesto chiuso
   int n = (int)MathFloor(MathAbs(move) / InpPointsPerOrder);
   if(n < 1) n = 1;
   if(n > InpMaxOpen - b.n) n = InpMaxOpen - b.n;
   if(b.n == 0) gBasketSteps = 0;
   double lot = CurLot(b);
   if(lot > gMaxLotSeen) gMaxLotSeen = lot;
   while(n > 0 && b.lots + n * lot > InpMaxTotalLots + 1e-9) n--;
   if(n <= 0) return;
   gLastStepMsc = tk.time_msc;
   double first = 0.0, prev = 0.0;
   int opened = 0;
   for(int k = 0; k < n; k++)
     {
      if(k > 0)
        {
         MqlTick t2;
         if(!SymbolInfoTick(_Symbol, t2)) break;
         double px = (dir > 0) ? t2.ask : t2.bid;
         if(MathAbs(px - first) / _Point > InpGapMaxPoints) break;   // guardia: il prezzo e' scappato
        }
      double e = 0.0;
      if(!OpenOne(dir, lot, e)) break;
      if(opened == 0) first = e; else { gGapSum += MathAbs(e - prev) / _Point; gGapN++; }
      prev = e;
      opened++;
     }
   if(opened > 0)
     {
      gSteps++;
      gBasketSteps++;
      SigPush(tk.time_msc, dir, (tk.bid + tk.ask) / 2.0);
      EvPush(tk.time_msc, dir, (tk.bid + tk.ask) / 2.0, (tk.ask - tk.bid) / _Point, move, dt.hour);
     }
   LogV("passo " + IntegerToString((int)gSteps) + ": " + (dir > 0 ? "LONG" : "SHORT") + " movimento " + DoubleToString(move, 1) + " pt, aperte " + IntegerToString(opened) + "/" + IntegerToString(n));
  }
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlTick tk;
   if(!SymbolInfoTick(_Symbol, tk)) return;
   if(tk.bid <= 0.0) return;
   gNowMsc = tk.time_msc;
   RingPush(tk.time_msc, tk.bid);
   DayRoll(tk.time);
   SigCheck(tk);
   EvCheck(tk);
   SBasket b;
   ReadBasket(b);
   if(b.n == 0) gUnderwater = false;
   double dayPnl = gDayRealized + b.net;
   if(!gDayStop)
     {
      if(InpDailyTargetEuro > 0.0 && dayPnl >= InpDailyTargetEuro) { gDayStop = true; gDayTargetHits++; }
      else if(InpDailyLossEuro > 0.0 && dayPnl <= -InpDailyLossEuro) { gDayStop = true; gDayLossHits++; }
     }
   if(gDayStop)
     {
      if(b.n > 0) CloseAll("giornata");
      return;   // giornata chiusa: niente aperture fino al giorno dopo (ora server)
     }
   if(b.n > 0 && ManageExit(b)) return;
   TryEntry(tk, b);
   if(!IsTester() && (ulong)GetTickCount64() - gLastStatusMs > 1000)
     {
      gLastStatusMs = (ulong)GetTickCount64();
      Comment("ABTG_ScalperClaudio 1.03  ", _Symbol, "  DEMO\n",
              "cesto: ", b.n, " posizioni, ", DoubleToString(b.lots, 2), " lotti, netto ", DoubleToString(b.net, 2), "\n",
              "passi ", (int)gSteps, "  chiuse ", (int)gClosed, "  netto chiuso ", DoubleToString(gSumNet, 2), "  freno ", (int)gBrake, "\n",
              "richieste oggi ", gReqToday, "  (totali ", (int)gReqTotal, ")");
     }
  }
//+------------------------------------------------------------------+
//| ogni uscita registrata: netto reale dalla storia, motivo, CSV    |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &request, const MqlTradeResult &result)
  {
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;
   if(!HistoryDealSelect(trans.deal)) return;
   if(HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != InpMagic) return;
   if(HistoryDealGetString(trans.deal, DEAL_SYMBOL) != _Symbol) return;
   long entry = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
   if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) return;
   ulong pid = (ulong)HistoryDealGetInteger(trans.deal, DEAL_POSITION_ID);
   double net = 0.0, pin = 0.0;
   datetime tin = 0;
   string verso = "";
   double lot = 0.0;
   if(HistorySelectByPosition((long)pid))
     {
      int tot = HistoryDealsTotal();
      for(int i = 0; i < tot; i++)
        {
         ulong d = HistoryDealGetTicket(i);
         if(d == 0) continue;
         net += HistoryDealGetDouble(d, DEAL_PROFIT) + HistoryDealGetDouble(d, DEAL_COMMISSION) + HistoryDealGetDouble(d, DEAL_SWAP) + HistoryDealGetDouble(d, DEAL_FEE);
         if(HistoryDealGetInteger(d, DEAL_ENTRY) == DEAL_ENTRY_IN)
           {
            pin = HistoryDealGetDouble(d, DEAL_PRICE);
            tin = (datetime)HistoryDealGetInteger(d, DEAL_TIME);
            lot = HistoryDealGetDouble(d, DEAL_VOLUME);
            verso = (HistoryDealGetInteger(d, DEAL_TYPE) == DEAL_TYPE_BUY) ? "LONG" : "SHORT";
           }
        }
     }
   else net = HistoryDealGetDouble(trans.deal, DEAL_PROFIT) + HistoryDealGetDouble(trans.deal, DEAL_COMMISSION) + HistoryDealGetDouble(trans.deal, DEAL_SWAP);
   datetime tout = (datetime)HistoryDealGetInteger(trans.deal, DEAL_TIME);
   double pout = HistoryDealGetDouble(trans.deal, DEAL_PRICE);
   int secs = (tin > 0 ? (int)(tout - tin) : 0);
   string why = (gCloseReason != "" ? gCloseReason : "altro");
   gClosed++; gSumNet += net; gSumLife += secs;
   if(net > 0.0) { gWins++; gGrossWin += net; } else gGrossLoss += -net;
   if(secs > 3600) gLongLived++;
   gDayRealized += net;
   if(why == "target") { gCloseTarget++; gNetT += net; }
   else if(why == "cesto") { gCloseBasket++; gNetC += net; }
   else if(why == "freno") { gCloseBrake++; gNetF += net; }
   else if(why == "zero") { gCloseZero++; gNetZ += net; }
   else { gCloseOther++; gNetO += net; }
   gCumProgress += net;
   if(why == "freno" || gCumProgress < 0.0) gCumProgress = 0.0;   // dopo il freno o una perdita si riparte dal lotto di base
   CommDel(pid);
   if(InpWriteCsv)
     {
      int h = FileOpen(gCsv, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON | FILE_SHARE_READ, ';');
      if(h != INVALID_HANDLE)
        {
         FileSeek(h, 0, SEEK_END);
         FileWrite(h, TimeToString(tout, TIME_DATE | TIME_SECONDS), _Symbol, IntegerToString((long)pid), verso, DoubleToString(lot, 2),
                   DoubleToString(pin, _Digits), DoubleToString(pout, _Digits), IntegerToString(secs), DoubleToString(net, 2), why);
         FileClose(h);
        }
     }
  }
//+------------------------------------------------------------------+
