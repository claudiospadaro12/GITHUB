//+------------------------------------------------------------------+
//|                                   ABTG_Confluenza_Dashboard.mq5   |
//|  Dashboard di SOLA LETTURA: per ogni simbolo x timeframe mostra   |
//|  una FRECCIA VERDE (BUY) o ROSSA (SELL) quando c'e' una           |
//|  CONFLUENZA attiva, cioe' lo STESSO segnale di                    |
//|  ABTG_Segnali_EMA_BB_ST (espansione Bollinger + incrocio EMA9/21 |
//|  + EMA inclinate + rottura Supertrend, opz. volumi), comparso    |
//|  entro InpMaxAgeBars barre CHIUSE. Accanto alla freccia l'eta' in |
//|  barre ("1b" = il segnale e' di 1 barra chiusa fa; "0b" = ultima).|
//|                                                                   |
//|  IDENTITA' CON L'INDICATORE: la logica sta in UN SOLO posto,       |
//|  MQL5\Include\ABTG_Confluenza.mqh (struct SConfl). La dashboard   |
//|  la alimenta con le ultime gBars barre CHIUSE (CopyRates) e       |
//|  legge lo stato dell'ultima barra chiusa. Nessuna formula          |
//|  duplicata qui dentro. Gli input di default sono le stesse         |
//|  macro ABTGC_D_* dell'indicatore: se cambi un parametro           |
//|  nell'indicatore, cambialo uguale qui.                            |
//|                                                                   |
//|  RIGHE ordinate: prima i simboli con piu' TF CONCORDI, a parita'   |
//|  il segnale piu' recente. Ultima colonna: "n/N BUY|SELL" (n TF    |
//|  concordi su N accesi); "conflitto" se BUY e SELL sono pari.      |
//|                                                                   |
//|  CLICK (sola apertura di grafici, MAI cambio del simbolo di       |
//|  questo grafico, per non toccare un EA che ci girasse - classe    |
//|  930): click sulla FRECCIA / sulla CELLA (anche vuota) apre il    |
//|  simbolo su QUEL TF; click sul NOME del simbolo (o sull'ultima    |
//|  colonna) apre il simbolo sul TF del segnale piu' recente (a       |
//|  parita' il piu' alto), o su InpTfMain se non ce ne sono. Se un   |
//|  grafico con quel simbolo e quel TF esiste gia', lo porta in      |
//|  primo piano invece di aprirne un altro; se ChartOpen fallisce    |
//|  fa SymbolSelect e riprova UNA volta, poi scrive nel Journal.     |
//|  Anti-rimbalzo: lo stesso bersaglio entro 1 s viene ignorato.     |
//|  Il nome di ogni oggetto porta riga/colonna (es. ABTGC_A_3_1); il |
//|  simbolo si legge da gIdx[riga] AL MOMENTO del click, quindi il   |
//|  riordino delle righe non puo' mandare al simbolo sbagliato.      |
//|  InpTemplate (vuoto di default): nome di un .tpl (".tpl" aggiunto |
//|  se manca) applicato SOLO al grafico appena aperto, cosi' trovi   |
//|  li' l'indicatore dei segnali. Non tocca template esistenti.       |
//|  ATTENZIONE: un grafico nuovo prende default.tpl; se quel         |
//|  template (o InpTemplate) contiene un EA, il grafico nasce con un |
//|  EA ACCESO. La dashboard lo controlla per 10 s dopo l'apertura e  |
//|  lancia un Alert se lo trova (classe 951). Il grafico della       |
//|  dashboard non e' mai un bersaglio: se il click chiede lo stesso  |
//|  simbolo/TF se ne apre uno separato.                              |
//|                                                                   |
//|  CARICO: a regime ZERO CopyRates per giro del timer (ogni giro    |
//|  controlla solo iTime della barra chiusa di ogni cella: 1 iTime    |
//|  per simbolo x TF). Quando la barra chiusa di una cella cambia:    |
//|  1 CopyRates di gBars barre (InpBars = 600, alzate se i periodi   |
//|  lo chiedono) + altrettanti Feed. Caso peggiore (chiusura di H4   |
//|  con M5+M15+H1+H4 insieme): 4 x simboli CopyRates, una tantum.    |
//|  Con 42 simboli x 4 TF a regime: ~168 iTime ogni 2 s. Serve almeno |
//|  pWarm+3 barre di storico per cella: finche' mancano (download) la |
//|  cella mostra "...". Se CopyRates rende meno di gBars barre e la   |
//|  serie non e' ancora sincronizzata, la misura e' PROVVISORIA (lo  |
//|  dice il tooltip) e si rifa' a ogni giro finche' lo diventa.       |
//|  IDENTITA' BIT PER BIT (classe 950): EMA e ATR di Wilder sono      |
//|  ricorsivi, lo stato dipende dalla barra di partenza finche' il   |
//|  suo peso non scende sotto la precisione del double. Con i default |
//|  bastano ~400 barre (600 date); se alzi i periodi del segnale le   |
//|  barre per cella si ALZANO da sole (tetto 5000, Print nel Journal).|
//|                                                                   |
//|  PANNELLO: righe in blocchi affiancati che stanno nell'altezza del |
//|  grafico (InpMaxRows = 0) o InpMaxRows righe per blocco; misure   |
//|  scalate coi DPI dello schermo.                                   |
//|                                                                   |
//|  Avvisi opzionali (spenti): Alert/push solo sul NUOVO segnale di   |
//|  una cella, mai sul primo giro e mai sulla prima misura valida    |
//|  della cella (che si limita a memorizzare). Tutti i nuovi segnali |
//|  di un giro vanno in UN solo Alert e UNA sola notifica push.      |
//|                                                                   |
//|  NON apre, NON modifica, NON chiude ordini. Non e' un EA.         |
//|  Unico effetto sul terminale: SymbolSelect() (Market Watch) e     |
//|  ChartOpen()/CHART_BRING_TO_TOP sui click.                        |
//|  Installazione: ABTG_Confluenza.mqh in MQL5\Include\, questo file |
//|  in MQL5\Indicators\, F7.                                         |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

#include <ABTG_Confluenza.mqh>

input group "=== Simboli ==="
input bool            InpForex        = true;      // Mostra FOREX
// Liste di default = i 28 cambi fra le 8 valute principali + i 10 indici + i 4 metalli che il server
// BCM elenca davvero (sonda ABTG_InfoBroker, conto 50503392, BCMMarkets-Server, 17/08/2026, 59 simboli:
// backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv). Esclusi apposta:
// esotici (NOK/SEK/PLN), petrolio, gas, cloni *_EXT. Un simbolo che il broker non ha viene saltato (Journal).
input string          InpSymForex     = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY,EURJPY,EURAUD,EURCAD,EURCHF,GBPCHF,AUDCHF"; // Lista forex (virgola)
input bool            InpIndici       = true;      // Mostra INDICI
input string          InpSymIndici    = "D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY,F40EUR,E50EUR,100GBP,E35EUR"; // Lista indici (nomi BCM; su altri broker riscrivili)
input bool            InpMetalli      = true;      // Mostra METALLI
input string          InpSymMetalli   = "XAUUSD,XAGUSD,XPTUSD,XPDUSD"; // Lista metalli
input string          InpSuffix       = "";        // Suffisso broker (se serve)
input group "=== Timeframe ==="
input bool            InpTfM5         = true;      // Colonna M5
input bool            InpTfM15        = true;      // Colonna M15
input bool            InpTfM30        = false;     // Colonna M30
input bool            InpTfH1         = true;      // Colonna H1
input bool            InpTfH4         = true;      // Colonna H4
input bool            InpTfD1         = false;     // Colonna D1
input ENUM_TIMEFRAMES InpTfMain       = PERIOD_H1; // TF aperto dal click sul nome se non ci sono segnali
input group "=== Segnale (STESSI default dell'indicatore) ==="
input int    InpEmaFast   = ABTGC_D_EMA_FAST;        // EMA veloce
input int    InpEmaSlow   = ABTGC_D_EMA_SLOW;        // EMA lenta
input int    InpEma3      = ABTGC_D_EMA_3;           // EMA 3 (irrilevante per il segnale)
input int    InpEma4      = ABTGC_D_EMA_4;           // EMA 4 (irrilevante per il segnale)
input int    InpBBPeriod     = ABTGC_D_BB_PERIOD;    // Bollinger: periodo
input double InpBBDev        = ABTGC_D_BB_DEV;       // Bollinger: deviazioni
input int    InpBBExpandBars = ABTGC_D_BB_EXP_BARS;  // (a) espansione: confronto con N barre prima
input double InpBBExpandPct  = ABTGC_D_BB_EXP_PCT;   // (a) crescita minima %
input int    InpAtrPeriod = ABTGC_D_ATR_PERIOD;      // Supertrend: periodo ATR
input double InpStMult    = ABTGC_D_ST_MULT;         // Supertrend: moltiplicatore
input bool   InpAtrWilder = true;                    // ATR di Wilder (false = SMA del TR come iATR)
input int    InpCrossLookback = ABTGC_D_CROSS_LB;    // (b) incrocio entro N barre
input int    InpSlopeBars     = ABTGC_D_SLOPE_BARS;  // (c) barre di pendenza
input int    InpBreakLookback = ABTGC_D_BREAK_LB;    // (d) flip Supertrend entro N barre
input int    InpCooldownBars  = ABTGC_D_COOLDOWN;    // pausa nella stessa direzione
input bool   InpUseVolFilter  = false;               // (e) filtro volumi nel segnale
input int    InpVolMaPeriod   = ABTGC_D_VOL_PERIOD;  // periodo media volumi
input double InpVolFactor     = ABTGC_D_VOL_FACTOR;  // fattore volumi
input group "=== Dashboard ==="
input int    InpMaxAgeBars    = 3;         // freccia se il segnale ha al massimo N barre chiuse
input int    InpBars          = 600;       // barre chiuse per CopyRates per cella
input int    InpRefreshSec    = 2;         // giro del timer (secondi)
input bool   InpClickOpen     = true;      // click = apri/porta in primo piano il grafico
input string InpTemplate      = "";        // template .tpl da applicare al grafico appena aperto (vuoto = nessuno)
input bool   InpAlert         = false;     // Alert sul nuovo segnale di una cella
input bool   InpPush          = false;     // push al telefono
input int    InpX             = 10;        // posizione X
input int    InpY             = 20;        // posizione Y
input int    InpFontSize      = 9;         // dimensione carattere
input int    InpArrowSize     = 16;        // dimensione della freccia
input int    InpMaxRows       = 0;         // righe per colonna del pannello (0 = auto: quante ne stanno nel grafico)

#define PFX "ABTGC_"
#define ABTGC_MAXBARS 5000                 // tetto delle barre per cella (carico)

//--- TF accesi
int             gNT = 0;
ENUM_TIMEFRAMES gTf[];
string          gTfName[];

//--- simboli
string gSym[];
int    gN = 0;

//--- per cella k = s*gNT + t
int      gDir[];        // +1 BUY, -1 SELL, 0 nessuna confluenza attiva
int      gAge[];        // barre chiuse dal segnale (-1 = nessuno)
bool     gOk[];         // misura valida?
datetime gKey[];        // tempo della barra chiusa misurata
datetime gNotified[];   // tempo dell'ultimo segnale gia' notificato/memorizzato
bool     gSeen[];       // prima misura valida della cella gia' avvenuta? (prima misura = muta)
int      gMissL[];      // condizioni mancanti long (tooltip)
int      gMissS[];      // condizioni mancanti short (tooltip)

//--- per simbolo
int    gIdx[];          // riga -> indice simbolo
int    gCnt[];          // TF concordi
int    gDom[];          // +1 / -1 / 0 (conflitto o nessuno)
int    gMinAge[];       // eta' minima tra i TF concordi
int    gNBuy[], gNSell[];

int      gLAge[];       // eta' dell'ultimo segnale anche se NON attivo (-1 = nessuno), per il tooltip
int      gLDir[];       // direzione dell'ultimo segnale (tooltip)

SConfl gE;              // motore di lavoro (scratch)
bool   gFirstRender = true;
int    gRowH = 0, gColSym = 0, gColW = 0, gColConf = 0;
string gLastKey = "";
ulong  gLastMs = 0;
int    gBars = 0;       // barre per CopyRates: InpBars, alzate se servono per la CONVERGENZA (vedi OnInit)
double gK = 1.0;        // scala DPI (TERMINAL_SCREEN_DPI / 96)
int    gRows = 1;       // righe per blocco (colonna) del pannello
int    gBlocks = 1;     // blocchi affiancati
int    gBlockW = 0;     // larghezza di un blocco in px
string gAlertBuf = "";  // avvisi del giro, spediti in UN solo Alert/push (niente raffica)
int    gAlertN = 0;
long   gNewId[8];       // grafici appena aperti da controllare (EA arrivato col template?)
ulong  gNewMs[8];
int    gNewN = 0;

//+------------------------------------------------------------------+
//| Oggetti                                                          |
//+------------------------------------------------------------------+
void Lbl(const string name, const int x, const int y, const string txt, const color c,
         const string font, const int size, const int z, const string tip = "")
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, z);      // sopra sfondo e celle: il click arriva all'etichetta
      ObjectSetString(0, name, OBJPROP_FONT, font);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, size);
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, txt);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetString(0, name, OBJPROP_TOOLTIP, StringLen(tip) > 0 ? tip : "\n");   // "\n" = nessun tooltip automatico
  }

void Rect(const string name, const int x, const int y, const int w, const int h,
          const color bg, const color border, const int z)
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, z);
      ObjectSetString(0, name, OBJPROP_TOOLTIP, "\n");   // le celle K lo riscrivono in Render
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, name, OBJPROP_COLOR, border);
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   ENUM_TIMEFRAMES allTf[6] = {PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   string          allNm[6] = {"M5", "M15", "M30", "H1", "H4", "D1"};
   bool            allOn[6];
   allOn[0] = InpTfM5;  allOn[1] = InpTfM15; allOn[2] = InpTfM30;
   allOn[3] = InpTfH1;  allOn[4] = InpTfH4;  allOn[5] = InpTfD1;
   gNT = 0;
   ArrayResize(gTf, 0);
   ArrayResize(gTfName, 0);
   for(int i = 0; i < 6; i++)
     {
      if(!allOn[i])
         continue;
      ArrayResize(gTf, gNT + 1);
      ArrayResize(gTfName, gNT + 1);
      gTf[gNT] = allTf[i];
      gTfName[gNT] = allNm[i];
      gNT++;
     }
   if(gNT == 0)
     {
      Print("ABTG_Confluenza_Dashboard: nessun TF acceso, accendine almeno uno.");
      return INIT_FAILED;
     }
   if(!gE.Init(InpEmaFast, InpEmaSlow, InpEma3, InpEma4,
               InpBBPeriod, InpBBDev, InpBBExpandBars, InpBBExpandPct,
               InpAtrPeriod, InpStMult, InpAtrWilder,
               InpCrossLookback, InpSlopeBars, InpBreakLookback, InpCooldownBars,
               InpVolMaPeriod, InpVolFactor))
      Print("ABTG_Confluenza_Dashboard: alcuni parametri fuori intervallo sono stati corretti dal motore.");
   // CONVERGENZA (classe 950): lo stato ricorsivo del motore (EMA del segnale, ATR di Wilder, bande del
   // Supertrend) dipende dalla barra di PARTENZA. L'indicatore parte dalla prima barra dello storico, la
   // dashboard da gBars barre fa: i due stati coincidono BIT PER BIT solo quando il contributo della
   // partenza, che decade come dec^N, e' sotto la precisione del double (1e-17). Misurato sullo specchio
   // Python: default (EMA 21, ATR 10) identico da ~400 barre, NON a 300; con EMA 50 / ATR 30 NON identico a
   // 600 barre (0/20), identico a 1400. Quindi le barre si ALZANO da sole se i periodi lo chiedono.
   double dec = 1.0 - MathMin(gE.a1, gE.a2);                    // la EMA del segnale piu' lenta
   if(gE.pAtrWilder && gE.pAtrPeriod > 1)
      dec = MathMax(dec, 1.0 - 1.0 / gE.pAtrPeriod);
   int need = gE.pWarm + 20;
   if(dec > 0.0 && dec < 1.0)
      need = (int)MathCeil(MathLog(1e-17) / MathLog(dec)) + gE.pWarm;
   gBars = MathMax(InpBars, MathMin(need, ABTGC_MAXBARS));
   if(gBars > InpBars)
      Print("ABTG_Confluenza_Dashboard: InpBars ", InpBars, " alzato a ", gBars,
            " perche' lo stato del motore coincida con quello dell'indicatore (periodi del segnale).");
   if(need > ABTGC_MAXBARS && InpBars < need)
      Print("ABTG_Confluenza_Dashboard: ATTENZIONE, con questi periodi servirebbero ", need,
            " barre per cella (tetto ", ABTGC_MAXBARS, "): il segnale puo' differire da quello dell'indicatore.");
   // guardia del riscaldamento DOPO l'alzata automatica (classe 980): prima stava sopra e con EMA lenta
   // >= 145 (pWarm = 4 x EMA lenta + 3) rifiutava l'avvio con InpBars 600 mentre qui sotto le barre si
   // sarebbero alzate da sole a need. Ora scatta solo se nemmeno il tetto basta (EMA lenta > ~1244).
   if(gBars < gE.pWarm + 20)
     {
      Print("ABTG_Confluenza_Dashboard: barre per cella (", gBars, ") sotto il riscaldamento del motore: servono almeno ",
            gE.pWarm + 20, ". Alza InpBars.");
      return INIT_PARAMETERS_INCORRECT;
     }

   string lista = "";
   if(InpForex)
      lista += InpSymForex + ",";
   if(InpIndici)
      lista += InpSymIndici + ",";
   if(InpMetalli)
      lista += InpSymMetalli + ",";
   string parts[];
   int np = StringSplit(lista, ',', parts);
   ArrayResize(gSym, 0);
   gN = 0;
   for(int i = 0; i < np; i++)
     {
      string s = parts[i];
      StringTrimLeft(s);
      StringTrimRight(s);
      if(StringLen(s) == 0)
         continue;
      s = s + InpSuffix;
      bool dup = false;
      for(int q = 0; q < gN; q++)
         if(gSym[q] == s)
            dup = true;
      if(dup)
         continue;
      if(!SymbolSelect(s, true))
        {
         Print("ABTG_Confluenza_Dashboard: simbolo non trovato sul broker, saltato: ", s);
         continue;
        }
      ArrayResize(gSym, gN + 1);
      gSym[gN] = s;
      gN++;
     }
   if(gN == 0)
     {
      Print("ABTG_Confluenza_Dashboard: nessun simbolo valido.");
      return INIT_FAILED;
     }

   int nc = gN * gNT;
   ArrayResize(gDir, nc);
   ArrayResize(gAge, nc);
   ArrayResize(gOk, nc);
   ArrayResize(gKey, nc);
   ArrayResize(gNotified, nc);
   ArrayResize(gSeen, nc);
   ArrayResize(gMissL, nc);
   ArrayResize(gMissS, nc);
   ArrayResize(gLAge, nc);
   ArrayResize(gLDir, nc);
   for(int k = 0; k < nc; k++)
     {
      gLAge[k] = -1;
      gLDir[k] = 0;
      gDir[k] = 0;
      gAge[k] = -1;
      gOk[k] = false;
      gKey[k] = 0;
      gNotified[k] = 0;
      gSeen[k] = false;
      gMissL[k] = 0;
      gMissS[k] = 0;
     }
   ArrayResize(gIdx, gN);
   ArrayResize(gCnt, gN);
   ArrayResize(gDom, gN);
   ArrayResize(gMinAge, gN);
   ArrayResize(gNBuy, gN);
   ArrayResize(gNSell, gN);
   for(int s2 = 0; s2 < gN; s2++)
      gIdx[s2] = s2;

   // i caratteri sono in PUNTI e il terminale li scala coi DPI dello schermo, le distanze sono in PIXEL:
   // senza questa scala a 120/144 DPI il testo esce dalle celle e si sovrappone (doc. TERMINAL_SCREEN_DPI)
   gK = TerminalInfoInteger(TERMINAL_SCREEN_DPI) / 96.0;
   if(gK < 1.0)
      gK = 1.0;
   gRowH    = (int)MathRound(MathMax(InpFontSize * 2 + 4, InpArrowSize + 12) * gK);
   gColSym  = (int)MathRound((90 + (InpFontSize - 9) * 8) * gK);
   gColW    = (int)MathRound((60 + (InpFontSize - 9) * 6 + (InpArrowSize - 16)) * gK);
   gColConf = (int)MathRound((86 + (InpFontSize - 9) * 6) * gK);
   gRows    = gN;
   gBlocks  = 1;
   gBlockW  = 0;
   gAlertBuf = "";
   gAlertN   = 0;
   gNewN     = 0;

   gFirstRender = true;
   gLastKey = "";
   gLastMs = 0;
   ObjectsDeleteAll(0, PFX);
   Update();
   EventSetTimer(MathMax(1, InpRefreshSec));
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, PFX);
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const int begin,
                const double &price[])
  {
   return rates_total;
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   Update();
   CheckNewCharts();
  }

//+------------------------------------------------------------------+
//| Misura una cella: ricostruisce lo stato dalle ultime gBars        |
//| barre CHIUSE e legge l'ultima. Un CopyRates per chiamata.         |
//+------------------------------------------------------------------+
bool Measure(const int s, const int t, const datetime tLast)
  {
   int k = s * gNT + t;
   MqlRates r[];
   ArraySetAsSeries(r, false);
   int got = CopyRates(gSym[s], gTf[t], 1, gBars, r);     // start=1: la barra in formazione e' esclusa
   if(got < gE.pWarm + 3)
     {
      gOk[k] = false;             // storico non pronto/insufficiente: "..."
      return false;
     }
   if(r[got - 1].time != tLast)   // i dati si stanno muovendo: si riprova al giro dopo
      return false;
   // meno barre di quelle chieste: o lo storico e' davvero cosi' corto (allora la finestra parte dalla
   // prima barra, come l'indicatore, e lo stato coincide), o si sta ancora scaricando (classe 981): in
   // quel caso la misura e' PROVVISORIA e la cella si rimisura a ogni giro (gKey = 0) finche' la serie
   // non e' sincronizzata, invece di restare congelata fino alla chiusura della barra dopo (H4 = 4 ore).
   bool prov = (got < gBars && SeriesInfoInteger(gSym[s], gTf[t], SERIES_SYNCHRONIZED) == 0);
   bool oOk = gOk[k];
   int  oDir = gDir[k], oAge = gAge[k], oML = gMissL[k], oMS = gMissS[k], oLA = gLAge[k], oLD = gLDir[k];
   bool oProv = (gOk[k] && gKey[k] == 0);

   gE.Reset();
   for(int i = 0; i < got; i++)
      gE.Feed(r[i].open, r[i].high, r[i].low, r[i].close, (double)r[i].tick_volume);

   int v = InpUseVolFilter ? 1 : 0;
   int no = gE.lastNo[v];
   datetime sigTime = (no >= 0) ? r[no].time : (datetime)0;
   int age = (no >= 0) ? (got - 1) - no : -1;
   bool active = (no >= 0 && age <= InpMaxAgeBars);

   // avviso: solo su un segnale NUOVO e solo dopo la prima misura valida di QUESTA cella.
   // Non si spedisce qui: si accoda e Update() manda UN solo Alert/push per giro (alla chiusura
   // di H4 possono scattare molte celle insieme; il push ha un limite di frequenza del terminale).
   if(gSeen[k])
     {
      if(active && sigTime > gNotified[k])
        {
         string line = StringFormat("%s %s %s %db", gSym[s], gTfName[t],
                                    gE.lastDir[v] > 0 ? "BUY" : "SELL", age);
         gAlertBuf += (gAlertN > 0 ? "; " : "") + line;
         gAlertN++;
        }
     }
   gSeen[k] = true;
   if(sigTime > gNotified[k])
      gNotified[k] = sigTime;

   gDir[k]   = active ? gE.lastDir[v] : 0;
   gAge[k]   = active ? age : -1;
   gMissL[k] = gE.Missing(1, InpUseVolFilter);
   gMissS[k] = gE.Missing(-1, InpUseVolFilter);
   gLAge[k]  = age;
   gLDir[k]  = (no >= 0) ? gE.lastDir[v] : 0;
   gKey[k]   = prov ? 0 : tLast;
   gOk[k]    = true;
   // true solo se cambia qualcosa che il pannello MOSTRA (una cella provvisoria rimisurata a ogni giro
   // non deve ridisegnare 160 celle ogni 2 secondi se non e' cambiato niente)
   return (!oOk || oDir != gDir[k] || oAge != gAge[k] || oML != gMissL[k] || oMS != gMissS[k] ||
           oLA != gLAge[k] || oLD != gLDir[k] || oProv != prov);
  }

//+------------------------------------------------------------------+
//| Giro: controlla solo iTime; misura solo le celle cambiate         |
//+------------------------------------------------------------------+
void Update()
  {
   bool changed = gFirstRender;
   for(int s = 0; s < gN; s++)
      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         datetime tl = iTime(gSym[s], gTf[t], 1);   // ultima barra CHIUSA
         if(tl <= 0)
            continue;                               // dati non pronti: la cella resta com'e' ("..." se mai misurata)
         if(gOk[k] && gKey[k] == tl)
            continue;                               // barra chiusa invariata: niente da rifare
         bool was = gOk[k];
         if(Measure(s, t, tl))
            changed = true;
         else
            if(was && !gOk[k])
               changed = true;                      // era misurata e ora e' tornata "..." (storico sparito)
        }
   if(changed)
     {
      Render();
      gFirstRender = false;
     }
   if(gAlertN > 0)
     {
      string msg = "ABTG confluenza EMA/BB/ST: " + gAlertBuf;
      if(gAlertN > 1)
         msg = "ABTG confluenza EMA/BB/ST, " + IntegerToString(gAlertN) + " nuovi: " + gAlertBuf;
      if(InpAlert)
         Alert(msg);
      if(InpPush)
        {
         string p = msg;
         if(StringLen(p) > 250)                       // la notifica push tronca oltre 255 caratteri
            p = StringSubstr(p, 0, 246) + " ...";
         if(!SendNotification(p))
            Print("ABTG_Confluenza_Dashboard: notifica push non inviata (errore ", GetLastError(), ").");
        }
      gAlertBuf = "";
      gAlertN = 0;
     }
  }

//+------------------------------------------------------------------+
//| Ordinamento: piu' TF concordi, poi segnale piu' recente           |
//+------------------------------------------------------------------+
bool RowBefore(const int a, const int b)
  {
   int ka = (gDom[a] == 0) ? 0 : gCnt[a];
   int kb = (gDom[b] == 0) ? 0 : gCnt[b];
   if(ka != kb)
      return (ka > kb);
   if(gMinAge[a] != gMinAge[b])
      return (gMinAge[a] < gMinAge[b]);
   return (a < b);
  }

void ScoreAndSort()
  {
   for(int s = 0; s < gN; s++)
     {
      int nB = 0, nS = 0, mB = 1000000, mS = 1000000;
      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         if(!gOk[k] || gDir[k] == 0)
            continue;
         if(gDir[k] > 0)
           {
            nB++;
            if(gAge[k] < mB) mB = gAge[k];
           }
         else
           {
            nS++;
            if(gAge[k] < mS) mS = gAge[k];
           }
        }
      gNBuy[s] = nB;
      gNSell[s] = nS;
      if(nB > nS)      { gDom[s] = 1;  gCnt[s] = nB; gMinAge[s] = mB; }
      else if(nS > nB) { gDom[s] = -1; gCnt[s] = nS; gMinAge[s] = mS; }
      else             { gDom[s] = 0;  gCnt[s] = nB; gMinAge[s] = 1000000; }
     }
   for(int i = 0; i < gN; i++)
      gIdx[i] = i;
   for(int i = 1; i < gN; i++)
     {
      int cur = gIdx[i];
      int j = i - 1;
      while(j >= 0 && RowBefore(cur, gIdx[j]))
        {
         gIdx[j + 1] = gIdx[j];
         j--;
        }
      gIdx[j + 1] = cur;
     }
  }

//+------------------------------------------------------------------+
//| Impaginazione: con 30 simboli una colonna sola e' alta ~930 px e   |
//| su uno schermo 1080p le ultime righe finiscono FUORI dal grafico.  |
//| Le righe si dividono in blocchi affiancati che stanno nell'altezza |
//| del grafico (InpMaxRows = 0) o in InpMaxRows righe per blocco.     |
//| I NOMI degli oggetti restano per riga r: il click non cambia.      |
//+------------------------------------------------------------------+
bool Layout()
  {
   int rows = gN;
   if(InpMaxRows > 0)
      rows = InpMaxRows;
   else
     {
      long hpx = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
      if(hpx > 0 && gRowH > 0)
         rows = ((int)hpx - InpY - 3 * gRowH - (int)MathMax(16, MathRound(10 * gK))) / gRowH;   // titolo + intestazione + riga di margine + bordo (10 px scalati, come H in Render)
     }
   if(rows < 5)
      rows = 5;
   if(rows > gN)
      rows = gN;
   int blocks = (gN + rows - 1) / rows;
   int bw = gColSym + gNT * gColW + gColConf + (int)MathRound(12 * gK);
   bool ch = (rows != gRows || blocks != gBlocks || bw != gBlockW);
   if(blocks != gBlocks)
      ObjectsDeleteAll(0, PFX + "H_");                          // intestazioni dei blocchi che non ci sono piu'
   gRows = rows;
   gBlocks = blocks;
   gBlockW = bw;
   return ch;
  }

// cosa manca a una direzione, con il caso "niente": condizioni tutte vere ma nessuna freccia
string MissText(const int m)
  {
   if(m == 0)
      return "niente (condizioni gia' vere da prima: il segnale scatta solo al fronte, o e' in pausa) ";
   return AbtgcMaskText(m);
  }

//+------------------------------------------------------------------+
void Render()
  {
   ScoreAndSort();
   Layout();

   int nAct = 0;
   for(int s = 0; s < gN; s++)
      if(gDom[s] != 0)
         nAct++;
   string title = StringFormat("CONFLUENZA EMA/BB/ST | attivi (<=%db): %d simboli | volumi %s",
                               InpMaxAgeBars, nAct, InpUseVolFilter ? "ON" : "OFF");

   int m8 = (int)MathRound(8 * gK);
   int W = m8 + gBlocks * gBlockW;
   W = (int)MathMax(W, 2 * m8 + (int)MathCeil(StringLen(title) * InpFontSize * 0.75 * gK));
   int H = (gRows + 3) * gRowH + (int)MathRound(10 * gK);

   Rect(PFX + "BG", InpX, InpY, W, H, C'18,22,30', C'70,78,95', 0);

   int x0 = InpX + m8;
   int y0 = InpY + (int)MathRound(6 * gK);
   Lbl(PFX + "T", x0, y0, title, C'230,230,230', "Consolas", InpFontSize, 10);

   int yh = y0 + gRowH;
   for(int b = 0; b < gBlocks; b++)
     {
      int bx = x0 + b * gBlockW;
      string bs = IntegerToString(b);
      Lbl(PFX + "H_S_" + bs, bx, yh, "Simbolo", C'150,170,210', "Consolas", InpFontSize, 10);
      for(int t = 0; t < gNT; t++)
         Lbl(PFX + "H_" + IntegerToString(t) + "_" + bs, bx + gColSym + t * gColW, yh,
             gTfName[t], C'150,170,210', "Consolas", InpFontSize, 10);
      Lbl(PFX + "H_C_" + bs, bx + gColSym + gNT * gColW, yh, "Concordi", C'150,170,210', "Consolas", InpFontSize, 10);
     }

   int fontPx = (int)MathCeil(InpFontSize * 1.4 * gK);
   int a4 = (int)MathRound(4 * gK);
   int gx = (int)MathRound((8 + InpArrowSize) * gK);
   int c3 = (int)MathRound(3 * gK);
   for(int r = 0; r < gN; r++)
     {
      int s = gIdx[r];
      int bx = x0 + (r / gRows) * gBlockW;
      int y = yh + (r % gRows + 1) * gRowH;
      string rs = IntegerToString(r);

      // nome simbolo (colore = direzione dominante)
      color cs = C'190,190,190';
      if(gDom[s] > 0) cs = clrLimeGreen;
      if(gDom[s] < 0) cs = clrTomato;
      Lbl(PFX + "S_" + rs, bx, y + (gRowH - fontPx) / 2, gSym[s], cs, "Consolas", InpFontSize, 10,
          "Click: apre " + gSym[s] + " sul TF del segnale piu' recente");

      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         string ts = IntegerToString(t);
         int cx = bx + gColSym + t * gColW;
         color bgc = C'26,31,42';
         string arrow = " ";
         string ages = " ";          // MAI "": un OBJ_LABEL col testo vuoto puo' mostrare la scritta "Label" (classe 982)
         color ca = C'110,110,110';
         string tip = gSym[s] + " " + gTfName[t] + ": ";
         if(!gOk[k])
           {
            ages = "...";
            tip += "dati non pronti";
           }
         else
           {
            if(gDir[k] > 0)
              {
               arrow = "p"; ca = clrLimeGreen; bgc = C'20,58,32';
               ages = IntegerToString(gAge[k]) + "b";
               tip += "BUY, segnale di " + IntegerToString(gAge[k]) + " barre chiuse fa";
              }
            else
               if(gDir[k] < 0)
                 {
                  arrow = "q"; ca = clrTomato; bgc = C'68,26,26';
                  ages = IntegerToString(gAge[k]) + "b";
                  tip += "SELL, segnale di " + IntegerToString(gAge[k]) + " barre chiuse fa";
                 }
               else
                 {
                  tip += "nessuna confluenza | LONG manca: " + MissText(gMissL[k]) +
                         "| SHORT manca: " + MissText(gMissS[k]);
                  if(gLDir[k] != 0)
                     tip += "| ultimo segnale: " + (gLDir[k] > 0 ? "BUY " : "SELL ") +
                            IntegerToString(gLAge[k]) + " barre fa";
                  else
                     tip += "| nessun segnale nelle ultime " + IntegerToString(gBars) + " barre (o nello storico, se piu' corto)";
                 }
            if(gKey[k] == 0)
               tip += " | PROVVISORIO: storico ancora in download, si rimisura";
           }
         tip += " | click: apre il grafico " + gSym[s] + " " + gTfName[t];
         // cella (cliccabile anche se vuota) + freccia + eta'
         Rect(PFX + "K_" + rs + "_" + ts, cx, y, gColW - c3, gRowH - 2, bgc, bgc, 1);
         ObjectSetString(0, PFX + "K_" + rs + "_" + ts, OBJPROP_TOOLTIP, tip);
         Lbl(PFX + "A_" + rs + "_" + ts, cx + a4, y + 1, arrow, ca, "Wingdings 3", InpArrowSize, 10, tip);
         Lbl(PFX + "G_" + rs + "_" + ts, cx + gx, y + (gRowH - fontPx) / 2, ages,
             gOk[k] ? C'230,230,230' : C'110,110,110', "Consolas", InpFontSize, 10, tip);
        }

      // ultima colonna: TF concordi
      string ctxt = "-";
      color  cc = C'110,110,110';
      if(gDom[s] > 0)
        { ctxt = IntegerToString(gCnt[s]) + "/" + IntegerToString(gNT) + " BUY";  cc = clrLimeGreen; }
      else
         if(gDom[s] < 0)
           { ctxt = IntegerToString(gCnt[s]) + "/" + IntegerToString(gNT) + " SELL"; cc = clrTomato; }
         else
            if(gNBuy[s] > 0)
              { ctxt = "conflitto"; cc = C'255,165,0'; }
      Lbl(PFX + "C_" + rs, bx + gColSym + gNT * gColW, y + (gRowH - fontPx) / 2, ctxt, cc,
          "Consolas", InpFontSize, 10, "Click: apre " + gSym[s] + " sul TF del segnale piu' recente");
     }
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
//| Click -> (tipo, riga, colonna) dal NOME dell'oggetto.             |
//| Nomi: S_r (simbolo)  C_r (concordi)  K_r_t / A_r_t / G_r_t (cella)|
//+------------------------------------------------------------------+
bool IsUInt(const string s)
  {
   int n = StringLen(s);
   if(n == 0 || n > 6)
      return false;
   for(int i = 0; i < n; i++)
     {
      ushort ch = StringGetCharacter(s, i);
      if(ch < '0' || ch > '9')
         return false;
     }
   return true;    // StringToInteger("") vale 0: senza questo "ABTGC_S_" sarebbe la riga 0
  }

bool DecodeClick(const string name, string &kind, int &row, int &col)
  {
   if(StringFind(name, PFX) != 0)
      return false;
   string rest = StringSubstr(name, StringLen(PFX));
   string p[];
   int n = StringSplit(rest, '_', p);
   if(n < 2)
      return false;
   kind = p[0];
   if(kind == "S" || kind == "C")
     {
      if(n != 2 || !IsUInt(p[1]))
         return false;
      row = (int)StringToInteger(p[1]);
      col = -1;
      return true;
     }
   if(kind == "K" || kind == "A" || kind == "G")
     {
      if(n != 3 || !IsUInt(p[1]) || !IsUInt(p[2]))
         return false;
      row = (int)StringToInteger(p[1]);
      col = (int)StringToInteger(p[2]);
      return true;
     }
   return false;   // sfondo, titolo, intestazioni: non cliccabili
  }

// TF da aprire cliccando il NOME: segnale piu' recente (a parita' il TF piu' alto), altrimenti InpTfMain
// (InpTfMain anche se NON e' una colonna accesa: prima si ripiegava in silenzio sulla prima colonna)
ENUM_TIMEFRAMES SymbolClickTf(const int s)
  {
   int best = -1;
   int bestAge = 1000000;
   for(int t = 0; t < gNT; t++)
     {
      int k = s * gNT + t;
      if(!gOk[k] || gDir[k] == 0)
         continue;
      if(gAge[k] <= bestAge)     // "<=": a parita' vince il TF piu' alto (t cresce)
        {
         bestAge = gAge[k];
         best = t;
        }
     }
   if(best >= 0)
      return gTf[best];
   if(InpTfMain == PERIOD_CURRENT)
      return (ENUM_TIMEFRAMES)_Period;
   return InpTfMain;
  }

//+------------------------------------------------------------------+
//| Grafici appena aperti: il terminale applica default.tpl (e qui    |
//| eventualmente InpTemplate). Se quel template contiene un EA, il   |
//| grafico nuovo nasce con un EA ACCESO: la dashboard non lo puo'    |
//| sapere prima (i .tpl stanno fuori dalla sandbox) e il template si |
//| applica in modo asincrono, quindi si controlla CHART_EXPERT_NAME  |
//| per 10 s dopo l'apertura e si avvisa a voce alta (classe 951).    |
//+------------------------------------------------------------------+
void WatchNewChart(const long id)
  {
   if(gNewN >= 8)
     {
      for(int i = 1; i < 8; i++)
        {
         gNewId[i - 1] = gNewId[i];
         gNewMs[i - 1] = gNewMs[i];
        }
      gNewN = 7;
     }
   gNewId[gNewN] = id;
   gNewMs[gNewN] = GetTickCount64();
   gNewN++;
  }

void CheckNewCharts()
  {
   if(gNewN <= 0)
      return;
   ulong now = GetTickCount64();
   int keep = 0;
   for(int i = 0; i < gNewN; i++)
     {
      long id = gNewId[i];
      bool drop = false;
      ResetLastError();
      string sym = ChartSymbol(id);
      if(StringLen(sym) == 0)
         drop = true;                                   // grafico gia' chiuso
      else
        {
         string ea = ChartGetString(id, CHART_EXPERT_NAME);
         if(StringLen(ea) > 0)
           {
            Alert("ABTG_Confluenza_Dashboard: ATTENZIONE, il grafico ", sym, " ",
                  EnumToString(ChartPeriod(id)), " appena aperto dal click ha un EA ACCESO: '", ea,
                  "' (arriva da default.tpl o da InpTemplate). Se non lo volevi, toglilo SUBITO.");
            drop = true;
           }
         else
            if(now - gNewMs[i] > 10000)
               drop = true;                             // 10 s senza EA: a posto
        }
      if(!drop)
        {
         gNewId[keep] = id;
         gNewMs[keep] = gNewMs[i];
         keep++;
        }
     }
   gNewN = keep;
  }

//+------------------------------------------------------------------+
//| Apre il simbolo/TF in un grafico SEPARATO (mai questo grafico)    |
//+------------------------------------------------------------------+
void OpenChartFor(const string sym, const ENUM_TIMEFRAMES tf)
  {
   ulong now = GetTickCount64();
   string key = sym + "|" + IntegerToString((int)tf);
   if(key == gLastKey && now - gLastMs < 1000)
      return;                                   // anti-rimbalzo: stesso bersaglio entro 1 s
   gLastKey = key;
   gLastMs = now;

   // (3) un ALTRO grafico con quel simbolo e quel TF esiste gia'? allora in primo piano.
   // Il grafico della dashboard si salta: "portarlo in primo piano" non mostrerebbe niente
   // (e' gia' davanti, coperto dal pannello) e il click sembrerebbe rotto.
   long self = ChartID();
   long cid = ChartFirst();
   int guard = 0;
   while(cid >= 0 && guard < 1000)
     {
      if(cid != self && ChartSymbol(cid) == sym && ChartPeriod(cid) == tf)
        {
         ChartSetInteger(cid, CHART_BRING_TO_TOP, true);
         return;
        }
      cid = ChartNext(cid);
      guard++;
     }

   // altrimenti grafico NUOVO
   ResetLastError();
   long nid = ChartOpen(sym, tf);
   if(nid == 0)
     {
      int e1 = GetLastError();
      SymbolSelect(sym, true);                  // (4) simbolo non in Market Watch? si riprova una volta
      ResetLastError();
      nid = ChartOpen(sym, tf);
      if(nid == 0)
        {
         Print("ABTG_Confluenza_Dashboard: impossibile aprire ", sym, " ", EnumToString(tf),
               " (errori ", e1, " / ", GetLastError(),
               "). Limite di grafici aperti raggiunto o simbolo non disponibile?");
         return;
        }
     }
   ChartSetInteger(nid, CHART_BRING_TO_TOP, true);
   if(StringLen(InpTemplate) > 0)               // (5) template opzionale, solo sul grafico nuovo
     {
      string tpl = InpTemplate;
      string low = tpl;
      StringToLower(low);
      if(StringFind(low, ".tpl") < 0)
         tpl += ".tpl";                          // "segnali" -> "segnali.tpl"
      ResetLastError();
      if(!ChartApplyTemplate(nid, tpl))
         Print("ABTG_Confluenza_Dashboard: template '", tpl, "' non applicato (errore ",
               GetLastError(), "). Va salvato nella cartella dei template del terminale (Grafici > Modelli > Salva).");
     }
   WatchNewChart(nid);
  }

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_CHART_CHANGE)            // grafico ridimensionato: le righe per blocco cambiano?
     {
      if(InpMaxRows <= 0 && !gFirstRender && Layout())
         Render();
      return;
     }
   if(!InpClickOpen || id != CHARTEVENT_OBJECT_CLICK)
      return;
   string kind;
   int row = -1, col = -1;
   if(!DecodeClick(sparam, kind, row, col))
      return;
   if(row < 0 || row >= gN)
      return;
   int s = gIdx[row];                       // riga -> simbolo, LETTO ORA (dopo ogni riordino)
   ENUM_TIMEFRAMES tf;
   if(col < 0)
      tf = SymbolClickTf(s);
   else
     {
      if(col >= gNT)
         return;
      tf = gTf[col];
     }
   OpenChartFor(gSym[s], tf);
  }
//+------------------------------------------------------------------+
