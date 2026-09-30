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
//|  la alimenta con le ultime InpBars barre CHIUSE (CopyRates) e     |
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
//|  InpTemplate (vuoto di default): nome di un .tpl (cartella        |
//|  MQL5\Profiles\Templates) applicato SOLO al grafico appena        |
//|  aperto, cosi' trovi li' l'indicatore dei segnali. Non tocca       |
//|  template esistenti.                                              |
//|                                                                   |
//|  CARICO: a regime ZERO CopyRates per giro del timer (ogni giro    |
//|  controlla solo iTime della barra chiusa di ogni cella: 1 iTime    |
//|  per simbolo x TF). Quando la barra chiusa di una cella cambia:    |
//|  1 CopyRates di InpBars barre (default 600) + ~600 Feed. Caso      |
//|  peggiore (chiusura oraria con M5+M15+H1 insieme): 3 x simboli    |
//|  CopyRates, una tantum. Con 30 simboli x 4 TF a regime: ~120       |
//|  iTime ogni 2 s. Serve almeno pWarm+3 barre di storico per cella: |
//|  finche' mancano (download) la cella mostra "...".                 |
//|                                                                   |
//|  Avvisi opzionali (spenti): Alert/push solo sul NUOVO segnale di   |
//|  una cella, mai sul primo giro e mai sulla prima misura valida    |
//|  della cella (che si limita a memorizzare).                       |
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
input string          InpSymForex     = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"; // Lista forex (virgola)
input bool            InpIndici       = true;      // Mostra INDICI
input string          InpSymIndici    = "D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY"; // Lista indici (nomi BCM; su altri broker riscrivili)
input bool            InpMetalli      = true;      // Mostra METALLI
input string          InpSymMetalli   = "XAUUSD,XAGUSD"; // Lista metalli
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

#define PFX "ABTGC_"

//--- TF accesi
int             gNT = 0;
ENUM_TIMEFRAMES gTf[];
string          gTfName[];
int             gMain = 0;

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

SConfl gE;              // motore di lavoro (scratch)
bool   gFirstRender = true;
int    gRowH = 0, gColSym = 0, gColW = 0, gColConf = 0;
string gLastKey = "";
ulong  gLastMs = 0;

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
   ObjectSetString(0, name, OBJPROP_TOOLTIP, tip);
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
   gMain = 0;
   for(int t = 0; t < gNT; t++)
      if(gTf[t] == InpTfMain)
         gMain = t;

   if(!gE.Init(InpEmaFast, InpEmaSlow, InpEma3, InpEma4,
               InpBBPeriod, InpBBDev, InpBBExpandBars, InpBBExpandPct,
               InpAtrPeriod, InpStMult, InpAtrWilder,
               InpCrossLookback, InpSlopeBars, InpBreakLookback, InpCooldownBars,
               InpVolMaPeriod, InpVolFactor))
      Print("ABTG_Confluenza_Dashboard: alcuni parametri fuori intervallo sono stati corretti dal motore.");
   if(InpBars < gE.pWarm + 20)
     {
      Print("ABTG_Confluenza_Dashboard: InpBars (", InpBars, ") troppo basso: servono almeno ",
            gE.pWarm + 20, " barre (warm-up del motore + margine).");
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
   for(int k = 0; k < nc; k++)
     {
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

   gRowH    = MathMax(InpFontSize * 2 + 4, InpArrowSize + 12);
   gColSym  = 90 + (InpFontSize - 9) * 8;
   gColW    = 60 + (InpFontSize - 9) * 6 + (InpArrowSize - 16);
   gColConf = 86 + (InpFontSize - 9) * 6;

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
  }

//+------------------------------------------------------------------+
//| Misura una cella: ricostruisce lo stato dalle ultime InpBars      |
//| barre CHIUSE e legge l'ultima. Un CopyRates per chiamata.         |
//+------------------------------------------------------------------+
bool Measure(const int s, const int t, const datetime tLast)
  {
   int k = s * gNT + t;
   MqlRates r[];
   ArraySetAsSeries(r, false);
   int got = CopyRates(gSym[s], gTf[t], 1, InpBars, r);   // start=1: la barra in formazione e' esclusa
   if(got < gE.pWarm + 3)
     {
      gOk[k] = false;             // storico non pronto/insufficiente: "..."
      return false;
     }
   if(r[got - 1].time != tLast)   // i dati si stanno muovendo: si riprova al giro dopo
      return false;

   gE.Reset();
   for(int i = 0; i < got; i++)
      gE.Feed(r[i].open, r[i].high, r[i].low, r[i].close, (double)r[i].tick_volume);

   int v = InpUseVolFilter ? 1 : 0;
   int no = gE.lastNo[v];
   datetime sigTime = (no >= 0) ? r[no].time : 0;
   int age = (no >= 0) ? (got - 1) - no : -1;
   bool active = (no >= 0 && age <= InpMaxAgeBars);

   // avviso: solo su un segnale NUOVO e solo dopo la prima misura valida di QUESTA cella
   if(gSeen[k])
     {
      if(active && sigTime > gNotified[k])
        {
         string msg = StringFormat("%s %s: %s (confluenza EMA/BB/ST, %db fa)", gSym[s], gTfName[t],
                                   gE.lastDir[v] > 0 ? "BUY" : "SELL", age);
         if(InpAlert)
            Alert(msg);
         if(InpPush)
            SendNotification(msg);
        }
     }
   gSeen[k] = true;
   if(sigTime > gNotified[k])
      gNotified[k] = sigTime;

   gDir[k]   = active ? gE.lastDir[v] : 0;
   gAge[k]   = active ? age : -1;
   gMissL[k] = gE.Missing(1, InpUseVolFilter);
   gMissS[k] = gE.Missing(-1, InpUseVolFilter);
   gKey[k]   = tLast;
   gOk[k]    = true;
   return true;
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
void Render()
  {
   ScoreAndSort();

   int nAct = 0;
   for(int s = 0; s < gN; s++)
      if(gDom[s] != 0)
         nAct++;
   string title = StringFormat("CONFLUENZA EMA/BB/ST | attivi (<=%db): %d simboli | volumi %s",
                               InpMaxAgeBars, nAct, InpUseVolFilter ? "ON" : "OFF");

   int W = gColSym + gNT * gColW + gColConf + 20;
   W = (int)MathMax(W, 16 + (int)MathCeil(StringLen(title) * InpFontSize * 0.75));
   int H = (gN + 3) * gRowH + 10;

   Rect(PFX + "BG", InpX, InpY, W, H, C'18,22,30', C'70,78,95', 0);

   int x0 = InpX + 8;
   int y0 = InpY + 6;
   Lbl(PFX + "T", x0, y0, title, C'230,230,230', "Consolas", InpFontSize, 10);

   int yh = y0 + gRowH;
   Lbl(PFX + "H_S", x0, yh, "Simbolo", C'150,170,210', "Consolas", InpFontSize, 10);
   for(int t = 0; t < gNT; t++)
      Lbl(PFX + "H_" + IntegerToString(t), x0 + gColSym + t * gColW, yh,
          gTfName[t], C'150,170,210', "Consolas", InpFontSize, 10);
   Lbl(PFX + "H_C", x0 + gColSym + gNT * gColW, yh, "Concordi", C'150,170,210', "Consolas", InpFontSize, 10);

   int fontPx = (int)MathCeil(InpFontSize * 1.4);
   for(int r = 0; r < gN; r++)
     {
      int s = gIdx[r];
      int y = yh + (r + 1) * gRowH;
      string rs = IntegerToString(r);

      // nome simbolo (colore = direzione dominante)
      color cs = C'190,190,190';
      if(gDom[s] > 0) cs = clrLimeGreen;
      if(gDom[s] < 0) cs = clrTomato;
      Lbl(PFX + "S_" + rs, x0, y + (gRowH - fontPx) / 2, gSym[s], cs, "Consolas", InpFontSize, 10,
          "Click: apre " + gSym[s] + " sul TF del segnale piu' recente");

      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         string ts = IntegerToString(t);
         int cx = x0 + gColSym + t * gColW;
         color bgc = C'26,31,42';
         string arrow = " ";
         string ages = "";
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
                  tip += "nessuna confluenza | LONG manca: " + AbtgcMaskText(gMissL[k]) +
                         "| SHORT manca: " + AbtgcMaskText(gMissS[k]);
           }
         // cella (cliccabile anche se vuota) + freccia + eta'
         Rect(PFX + "K_" + rs + "_" + ts, cx, y, gColW - 3, gRowH - 2, bgc, bgc, 1);
         ObjectSetString(0, PFX + "K_" + rs + "_" + ts, OBJPROP_TOOLTIP, tip);
         Lbl(PFX + "A_" + rs + "_" + ts, cx + 4, y + 1, arrow, ca, "Wingdings 3", InpArrowSize, 10, tip);
         Lbl(PFX + "G_" + rs + "_" + ts, cx + 8 + InpArrowSize, y + (gRowH - fontPx) / 2, ages,
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
      Lbl(PFX + "C_" + rs, x0 + gColSym + gNT * gColW, y + (gRowH - fontPx) / 2, ctxt, cc,
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
   if(best < 0)
      best = gMain;
   return gTf[best];
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

   // (3) un grafico con quel simbolo e quel TF esiste gia'? allora in primo piano
   long cid = ChartFirst();
   int guard = 0;
   while(cid >= 0 && guard < 1000)
     {
      if(ChartSymbol(cid) == sym && ChartPeriod(cid) == tf)
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
      ResetLastError();
      if(!ChartApplyTemplate(nid, InpTemplate))
         Print("ABTG_Confluenza_Dashboard: template '", InpTemplate, "' non applicato (errore ",
               GetLastError(), "). Va salvato in MQL5\\Profiles\\Templates.");
     }
  }

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
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
