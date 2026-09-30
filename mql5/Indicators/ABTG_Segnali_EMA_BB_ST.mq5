//+------------------------------------------------------------------+
//|                                       ABTG_Segnali_EMA_BB_ST.mq5  |
//|  Indicatore SOLA LETTURA/DISEGNO (NON e' un EA: nessun ordine).   |
//|                                                                   |
//|  SUL GRAFICO: EMA 9, 21, 50 (sottili, colori distinti) e EMA 200  |
//|  in ROSSO SPESSO; bande di Bollinger; Supertrend bicolore (verde  |
//|  sotto il prezzo = trend su, rosso sopra = trend giu'); segnali   |
//|  con un GROSSO TRIANGOLO + etichetta BUY (verde) / SELL (rosso).  |
//|                                                                   |
//|  IL SEGNALE compare SOLO quando, sulla barra CHIUSA, ci sono       |
//|  TUTTE queste condizioni (definizioni esatte in ABTG_Confluenza.mqh|
//|  che e' il motore UNICO, condiviso con la dashboard):             |
//|   (a) ESPANSIONE BB: larghezza (alta-bassa)/media maggiore di      |
//|       quella di InpBBExpandBars barre prima (default 3);          |
//|   (b) INCROCIO EMA9/EMA21 sulla barra o entro InpCrossLookback     |
//|       barre (default 3) nella direzione, e EMA9 ancora dal lato   |
//|       giusto. Scelta: un incrocio ESATTAMENTE sulla stessa barra   |
//|       di tutte le altre condizioni e' troppo raro, quindi si      |
//|       accetta un incrocio recente;                                |
//|   (c) PENDENZA: EMA9 e EMA21 entrambe crescenti (long) o          |
//|       decrescenti (short) per InpSlopeBars barre (default 2);     |
//|   (d) ROTTURA SUPERTREND: flip di direzione sulla barra o entro   |
//|       InpBreakLookback barre (default 3) nella direzione;         |
//|   (e) FILTRO VOLUMI (OPZIONALE): volume tick > media(20) x fattore.|
//|  Trigger A FRONTE (un solo segnale quando l'insieme diventa vero)  |
//|  + InpCooldownBars (default 5) per non ripetere nella stessa       |
//|  direzione. MAI repaint: nessun segnale sulla barra in formazione; |
//|  il segnale appare quando la barra si CHIUDE (all'apertura della   |
//|  successiva) e resta li'.                                          |
//|                                                                   |
//|  TRE TASTI (in alto a sinistra):                                  |
//|     [NORMALI]  [HEIKIN ASHI]  [VOLUME: ON/OFF]                    |
//|   I primi due scelgono il TIPO DI CANDELE mostrate. Il terzo      |
//|   accende/spegne il FILTRO VOLUMI (e) dentro il segnale (default  |
//|   SPENTO, cosi' il segnale e' esattamente l'elenco (a)-(d)).      |
//|   Lo stato dei tasti sopravvive al cambio di TF (GlobalVariable   |
//|   del terminale) ma NON al riavvio del terminale.                 |
//|   Il tasto VOLUME non ricalcola nulla: il motore calcola le due   |
//|   varianti (con/senza volume) insieme e il tasto sceglie quale     |
//|   mostrare, quindi funziona anche a mercato chiuso.               |
//|                                                                   |
//|  HEIKIN ASHI: SOLO DISPLAY. EMA, Bollinger, Supertrend, volume e   |
//|   segnali si calcolano SEMPRE sui prezzi REALI. In modalita' HA    |
//|   le candele native vengono nascoste mettendo a clrNONE i colori   |
//|   del grafico (candele/barre/linea) e ripristinati su NORMALI, in |
//|   OnDeinit (ogni motivo) e a ogni uscita. In modalita' NORMALE i  |
//|   buffer HA restano EMPTY_VALUE.                                  |
//|                                                                   |
//|  PANNELLO VOLUMI SOTTO: se InpAutoPannelloVolumi=true (default)   |
//|   dopo ~1 s dal caricamento aggiunge ABTG_Volume_Filtro in una    |
//|   sottofinestra (iCustom + ChartIndicatorAdd) SOLO se non c'e'    |
//|   gia' (scansione per nome). Non lo cancella al cambio TF: solo   |
//|   se rimuovi QUESTO indicatore dal grafico (REASON_REMOVE).       |
//|   Se l'aggiunta fallisce: Print nel Journal, l'indicatore         |
//|   principale funziona lo stesso (trascina il file a mano).        |
//|   VOLUME TICK MT5 != VOLUME REALE: il volume tick e' il NUMERO DI |
//|   TICK ricevuti dal broker nella barra (attivita' del prezzo), non |
//|   i lotti/contratti scambiati; cambia da broker a broker.         |
//|                                                                   |
//|  Funziona su TUTTI i TF e su tutti i simboli: nessun valore in    |
//|  pip; la distanza dei triangoli e' in ATR.                        |
//|  Buffer per iCustom: 14 = ATR, 15 = segnale SENZA volume,         |
//|  16 = segnale CON volume (+1 BUY, -1 SELL, 0 nulla).              |
//|                                                                   |
//|  Un solo esemplare per grafico (oggetti con prefisso fisso).      |
//|  Installazione: ABTG_Confluenza.mqh in MQL5\Include\, questo file  |
//|  e ABTG_Volume_Filtro.mq5 in MQL5\Indicators\, poi F7.            |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 21
#property indicator_plots   9

//--- plot 1: candele Heikin Ashi (buffer 0-3 OHLC, 4 colore)
#property indicator_label1  "HA Open;HA High;HA Low;HA Close"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  1
//--- plot 2-4: Bollinger
#property indicator_label2  "BB alta"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrSilver
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
#property indicator_label3  "BB media"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGray
#property indicator_style3  STYLE_DOT
#property indicator_width3  1
#property indicator_label4  "BB bassa"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSilver
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot 5-8: EMA (9, 21, 50 sottili; 200 rosso spesso)
#property indicator_label5  "EMA veloce"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrDeepSkyBlue
#property indicator_width5  1
#property indicator_label6  "EMA lenta"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrGold
#property indicator_width6  1
#property indicator_label7  "EMA 3"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrMediumOrchid
#property indicator_width7  1
#property indicator_label8  "EMA 4"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrRed
#property indicator_width8  4
//--- plot 9: Supertrend bicolore (buffer 12 valore, 13 colore)
#property indicator_label9  "Supertrend"
#property indicator_type9   DRAW_COLOR_LINE
#property indicator_color9  clrLimeGreen,clrOrangeRed
#property indicator_width9  2

#include <ABTG_Confluenza.mqh>

//+------------------------------------------------------------------+
//| INPUT                                                            |
//+------------------------------------------------------------------+
input group "=== Medie mobili (colore 200 = ROSSO spesso) ==="
input int    InpEmaFast   = ABTGC_D_EMA_FAST;   // EMA veloce (segnale)
input int    InpEmaSlow   = ABTGC_D_EMA_SLOW;   // EMA lenta (segnale)
input int    InpEma3      = ABTGC_D_EMA_3;      // EMA 3 (solo disegno)
input int    InpEma4      = ABTGC_D_EMA_4;      // EMA 4 (solo disegno, rossa spessa)
input group "=== Bollinger ==="
input int    InpBBPeriod     = ABTGC_D_BB_PERIOD;    // periodo
input double InpBBDev        = ABTGC_D_BB_DEV;       // deviazioni
input int    InpBBExpandBars = ABTGC_D_BB_EXP_BARS;  // (a) espansione: confronto con N barre prima
input double InpBBExpandPct  = ABTGC_D_BB_EXP_PCT;   // (a) crescita minima % (0 = basta che cresca)
input group "=== Supertrend (definizione di casa: ABTG_Supertrend) ==="
input int    InpAtrPeriod = ABTGC_D_ATR_PERIOD;  // periodo ATR
input double InpStMult    = ABTGC_D_ST_MULT;     // moltiplicatore
input bool   InpAtrWilder = true;                // ATR di Wilder (false = SMA del TR come iATR)
input group "=== Condizioni del segnale ==="
input int    InpCrossLookback = ABTGC_D_CROSS_LB;   // (b) incrocio 9/21 sulla barra o entro N barre
input int    InpSlopeBars     = ABTGC_D_SLOPE_BARS; // (c) barre di pendenza concorde
input int    InpBreakLookback = ABTGC_D_BREAK_LB;   // (d) flip Supertrend sulla barra o entro N barre
input int    InpCooldownBars  = ABTGC_D_COOLDOWN;   // barre di pausa nella stessa direzione
input group "=== Filtro volumi (e) ==="
input bool   InpUseVolFilter  = false;              // stato iniziale del tasto VOLUME
input int    InpVolMaPeriod   = ABTGC_D_VOL_PERIOD; // periodo media volumi
input double InpVolFactor     = ABTGC_D_VOL_FACTOR; // passa se volume > media x fattore
input bool   InpAutoPannelloVolumi = true;          // aggiungi da solo il pannello volumi sotto
input group "=== Grafica dei segnali ==="
input int    InpMaxSignals    = 300;     // oggetti solo per gli ultimi N segnali
input double InpSigDistAtr    = 0.6;     // distanza triangolo da minimo/massimo, in ATR
input int    InpTriSize       = 22;      // dimensione triangolo
input int    InpLabelSize     = 11;      // dimensione etichetta BUY/SELL
input int    InpBtnX          = 10;      // tasti: X
input int    InpBtnY          = 24;      // tasti: Y
input group "=== Avvisi (spenti di default) ==="
input bool   InpAlert         = false;   // Alert sul nuovo segnale (barra chiusa)
input bool   InpPush          = false;   // notifica push (serve MetaQuotes ID)

//+------------------------------------------------------------------+
//| COSTANTI e GLOBALI                                               |
//+------------------------------------------------------------------+
#define PFX       "ABTGS_"
#define BTN_N     "ABTGS_BTN_N"
#define BTN_H     "ABTGS_BTN_H"
#define BTN_V     "ABTGS_BTN_V"
#define LBL_PAD   "    "
#define VOL_NAME  "ABTG Volume Filtro"
#define VOL_FILE  "ABTG_Volume_Filtro"

//--- buffer disegnati
double bHAo[], bHAh[], bHAl[], bHAc[], bHAcol[];      // 0-4
double bBBu[], bBBm[], bBBl[];                        // 5-7
double bE1[], bE2[], bE3[], bE4[];                    // 8-11
double bST[], bSTc[];                                 // 12-13
//--- buffer di calcolo
double cAtr[], cSigA[], cSigB[];                      // 14-16
double cHAo[], cHAh[], cHAl[], cHAc[];                // 17-20 (Heikin Ashi interno)

SConfl   gEng;                 // motore (solo barre chiuse)
SConfl   gTmp;                 // copia usata per l'anteprima della barra in formazione
bool     gInitOk = false;
bool     gHA = false;          // candele Heikin Ashi mostrate?
bool     gVolOn = false;       // filtro volumi nel segnale?
bool     gDirty = true;        // i segnali vanno ridisegnati?
int      gRatesTotal = 0;
datetime gLastAlertTime = 0;
datetime gLastBarTime = 0;

//--- colori nativi del grafico (per ripristino)
color    gColBull = clrLime, gColBear = clrRed, gColUp = clrLime, gColDown = clrRed, gColLine = clrLime;
bool     gColsHidden = false;

//--- pannello volumi
bool     gPanelDone = false;
int      gPanelTries = 0;
int      gHVol = INVALID_HANDLE;

//+------------------------------------------------------------------+
//| GlobalVariable (stato dei tasti attraverso il cambio di TF)       |
//+------------------------------------------------------------------+
string GvKey(const string what)
  {
   return "ABTGS_" + IntegerToString(ChartID()) + "_" + what;
  }

void GvSave(const string what, const double val)
  {
   if(GlobalVariableSet(GvKey(what), val) == 0)
      Print("ABTG_Segnali: GlobalVariableSet fallita (", what, "), errore ", GetLastError(),
            ": lo stato del tasto non sopravvivera' al cambio TF.");
  }

void GvClear()
  {
   GlobalVariableDel(GvKey("HA"));
   GlobalVariableDel(GvKey("VOL"));
   GlobalVariableDel(GvKey("VOLIN"));
  }

//+------------------------------------------------------------------+
//| Colori del grafico: nascondi (HA) / ripristina                    |
//+------------------------------------------------------------------+
color ColOrDefault(const long v, const color def)
  {
   color c = (color)v;
   // clrNONE salvato = un'istanza precedente e' morta senza ripristinare: non si "ripristina" l'invisibile
   if(c == clrNONE)
      return def;
   return c;
  }

void ColsHide()
  {
   if(gColsHidden)
      return;
   // i colori si catturano ADESSO (prima di nasconderli): sono quelli veri e attuali
   gColBull = ColOrDefault(ChartGetInteger(0, CHART_COLOR_CANDLE_BULL), clrLime);
   gColBear = ColOrDefault(ChartGetInteger(0, CHART_COLOR_CANDLE_BEAR), clrRed);
   gColUp   = ColOrDefault(ChartGetInteger(0, CHART_COLOR_CHART_UP),    clrLime);
   gColDown = ColOrDefault(ChartGetInteger(0, CHART_COLOR_CHART_DOWN),  clrRed);
   gColLine = ColOrDefault(ChartGetInteger(0, CHART_COLOR_CHART_LINE),  clrLime);
   gColsHidden = true;   // da qui in poi OGNI uscita ripristina
   bool ok = true;
   ok = ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrNONE) && ok;
   ok = ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrNONE) && ok;
   ok = ChartSetInteger(0, CHART_COLOR_CHART_UP,    clrNONE) && ok;
   ok = ChartSetInteger(0, CHART_COLOR_CHART_DOWN,  clrNONE) && ok;
   ok = ChartSetInteger(0, CHART_COLOR_CHART_LINE,  clrNONE) && ok;
   if(!ok)
      Print("ABTG_Segnali: impossibile nascondere le candele native (errore ", GetLastError(), ").");
  }

void ColsRestore()
  {
   if(!gColsHidden)
      return;
   ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, gColBull);
   ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, gColBear);
   ChartSetInteger(0, CHART_COLOR_CHART_UP,    gColUp);
   ChartSetInteger(0, CHART_COLOR_CHART_DOWN,  gColDown);
   ChartSetInteger(0, CHART_COLOR_CHART_LINE,  gColLine);
   gColsHidden = false;
  }

//+------------------------------------------------------------------+
//| Tasti                                                            |
//+------------------------------------------------------------------+
void MakeButton(const string name, const int x, const int w, const string txt)
  {
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
        {
         Print("ABTG_Segnali: creazione tasto fallita (", name, "), errore ", GetLastError());
         return;
        }
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
      ObjectSetString(0, name, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, 22);
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, InpBtnY);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetString(0, name, OBJPROP_TEXT, txt);
  }

void PaintButton(const string name, const bool active, const color onBg, const color offBg)
  {
   if(ObjectFind(0, name) < 0)
      return;
   ObjectSetInteger(0, name, OBJPROP_STATE, active);   // riscrive lo stato togglato dal click
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, active ? onBg : offBg);
   ObjectSetInteger(0, name, OBJPROP_COLOR, active ? clrWhite : clrSilver);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, active ? clrWhite : C'90,95,110');
  }

void UpdateButtons()
  {
   MakeButton(BTN_N, InpBtnX,       80,  "NORMALI");
   MakeButton(BTN_H, InpBtnX + 86,  110, "HEIKIN ASHI");
   MakeButton(BTN_V, InpBtnX + 202, 110, gVolOn ? "VOLUME: ON" : "VOLUME: OFF");
   PaintButton(BTN_N, !gHA, clrDodgerBlue, C'50,55,65');
   PaintButton(BTN_H, gHA,  clrDodgerBlue, C'50,55,65');
   PaintButton(BTN_V, gVolOn, clrForestGreen, C'70,45,45');
  }

//+------------------------------------------------------------------+
//| Heikin Ashi (SOLO display): copia dei buffer interni sul plot     |
//+------------------------------------------------------------------+
void ShowHA(const int i)
  {
   if(gHA)
     {
      bHAo[i] = cHAo[i];
      bHAh[i] = cHAh[i];
      bHAl[i] = cHAl[i];
      bHAc[i] = cHAc[i];
      bHAcol[i] = (cHAc[i] >= cHAo[i]) ? 0.0 : 1.0;
     }
   else
     {
      bHAo[i] = EMPTY_VALUE;
      bHAh[i] = EMPTY_VALUE;
      bHAl[i] = EMPTY_VALUE;
      bHAc[i] = EMPTY_VALUE;
      bHAcol[i] = 0.0;
     }
  }

void FillHA(const int total)
  {
   int n = MathMin(total, ArraySize(cHAo));
   for(int i = 0; i < n; i++)
      ShowHA(i);
  }

//+------------------------------------------------------------------+
//| Segnale mostrato = variante scelta dal tasto VOLUME               |
//+------------------------------------------------------------------+
double SelSig(const int i)
  {
   return gVolOn ? cSigB[i] : cSigA[i];
  }

string TfName()
  {
   string s = EnumToString((ENUM_TIMEFRAMES)_Period);
   StringReplace(s, "PERIOD_", "");
   return s;
  }

//+------------------------------------------------------------------+
//| Disegno dei segnali: solo gli ultimi InpMaxSignals, il resto      |
//| viene cancellato (si ricostruisce da zero, nessun orfano)         |
//+------------------------------------------------------------------+
void DrawSignals(const int total)
  {
   ObjectsDeleteAll(0, PFX + "T_");
   ObjectsDeleteAll(0, PFX + "L_");
   int nBuf = ArraySize(cAtr);
   if(total < 2 || nBuf < total)
      return;
   int maxN = MathMax(1, InpMaxSignals);
   int drawn = 0, failed = 0;
   int err = 0;
   for(int i = total - 2; i >= 0 && drawn < maxN; i--)
     {
      double sg = SelSig(i);
      if(sg == 0.0)
         continue;
      int shift = total - 1 - i;
      datetime t = iTime(_Symbol, _Period, shift);
      if(t <= 0)
         continue;
      double atr = cAtr[i];
      bool buy = (sg > 0.0);
      double px = buy ? iLow(_Symbol, _Period, shift) : iHigh(_Symbol, _Period, shift);
      if(px <= 0.0 || atr <= 0.0)
         continue;
      double y = buy ? px - InpSigDistAtr * atr : px + InpSigDistAtr * atr;
      y = NormalizeDouble(y, _Digits);
      string key = IntegerToString((long)t);
      color  col = buy ? clrLime : clrRed;

      // triangolo: Wingdings 3 'p' (su) / 'q' (giu'); ancorato col lato piatto verso la candela
      string nt = PFX + "T_" + key;
      if(ObjectCreate(0, nt, OBJ_TEXT, 0, t, y))
        {
         ObjectSetString(0, nt, OBJPROP_TEXT, buy ? "p" : "q");
         ObjectSetString(0, nt, OBJPROP_FONT, "Wingdings 3");
         ObjectSetInteger(0, nt, OBJPROP_FONTSIZE, InpTriSize);
         ObjectSetInteger(0, nt, OBJPROP_COLOR, col);
         ObjectSetInteger(0, nt, OBJPROP_ANCHOR, buy ? ANCHOR_UPPER : ANCHOR_LOWER);
         ObjectSetInteger(0, nt, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, nt, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, nt, OBJPROP_BACK, false);
        }
      else
        {
         failed++;
         err = GetLastError();
        }

      // etichetta ACCANTO al triangolo (a destra: gli spazi iniziali la scostano dal centro)
      string nl = PFX + "L_" + key;
      if(ObjectCreate(0, nl, OBJ_TEXT, 0, t, y))
        {
         ObjectSetString(0, nl, OBJPROP_TEXT, LBL_PAD + (buy ? "BUY" : "SELL"));
         ObjectSetString(0, nl, OBJPROP_FONT, "Arial Black");
         ObjectSetInteger(0, nl, OBJPROP_FONTSIZE, InpLabelSize);
         ObjectSetInteger(0, nl, OBJPROP_COLOR, col);
         ObjectSetInteger(0, nl, OBJPROP_ANCHOR, buy ? ANCHOR_LEFT_UPPER : ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0, nl, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, nl, OBJPROP_HIDDEN, true);
         ObjectSetInteger(0, nl, OBJPROP_BACK, false);
        }
      else
        {
         failed++;
         err = GetLastError();
        }
      drawn++;
     }
   if(failed > 0)
      Print("ABTG_Segnali: ", failed, " oggetti non creati (ultimo errore ", err, ").");
  }

//+------------------------------------------------------------------+
//| Avvisi                                                           |
//+------------------------------------------------------------------+
void SendSignalAlert(const bool buy, const datetime t)
  {
   string msg = StringFormat("ABTG %s %s %s (barra chiusa %s)", buy ? "BUY" : "SELL",
                             _Symbol, TfName(), TimeToString(t, TIME_DATE | TIME_MINUTES));
   if(InpAlert)
      Alert(msg);
   if(InpPush)
      SendNotification(msg);
  }

//+------------------------------------------------------------------+
//| Pannello volumi sotto                                            |
//+------------------------------------------------------------------+
// Ritorna la sottofinestra dove esiste gia' un indicatore "ABTG Volume Filtro*" (-1 = nessuno)
int FindVolPane(string &foundName)
  {
   foundName = "";
   int wt = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   for(int w = 0; w < wt; w++)
     {
      int nInd = ChartIndicatorsTotal(0, w);
      for(int k = 0; k < nInd; k++)
        {
         string nm = ChartIndicatorName(0, w, k);
         if(StringFind(nm, VOL_NAME) == 0)
           {
            foundName = nm;
            return w;
           }
        }
     }
   return -1;
  }

// Percorso di iCustom relativo a MQL5\Indicators (rispetta un'eventuale sottocartella)
string VolFilePath()
  {
   string p = MQLInfoString(MQL_PROGRAM_PATH);
   int a = StringFind(p, "\\Indicators\\");
   int last = -1;
   for(int k = StringLen(p) - 1; k >= 0; k--)
      if(StringGetCharacter(p, k) == '\\')
        {
         last = k;
         break;
        }
   string sub = "";
   if(a >= 0 && last > a + 11)
      sub = StringSubstr(p, a + 12, last - a - 11);
   return sub + VOL_FILE;
  }

void TryAddVolumePanel()
  {
   if(!InpAutoPannelloVolumi || MQLInfoInteger(MQL_TESTER))
     {
      gPanelDone = true;
      return;
     }
   string nm;
   if(FindVolPane(nm) >= 0)
     {
      gPanelDone = true;   // gia' presente: non si duplica
      return;
     }
   int wt = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
   if(wt < 1)
      return;              // grafico non ancora pronto: si riprova
   ResetLastError();
   int h = iCustom(_Symbol, _Period, VolFilePath(), InpVolMaPeriod, InpVolFactor);
   if(h == INVALID_HANDLE)
     {
      Print("ABTG_Segnali: pannello volumi NON aggiunto: iCustom(", VolFilePath(),
            ") fallito, errore ", GetLastError(),
            ". Compila ABTG_Volume_Filtro.mq5 e trascinalo a mano nel grafico.");
      gPanelDone = true;
      return;
     }
   if(!ChartIndicatorAdd(0, wt, h))
     {
      Print("ABTG_Segnali: pannello volumi NON aggiunto: ChartIndicatorAdd errore ", GetLastError(),
            ". Trascina ABTG_Volume_Filtro a mano nel grafico.");
      IndicatorRelease(h);
      gPanelDone = true;
      return;
     }
   gHVol = h;
   gPanelDone = true;
   Print("ABTG_Segnali: pannello volumi aggiunto nella sottofinestra ", wt, ".");
  }

void RemoveVolumePanel()
  {
   string nm;
   int w = FindVolPane(nm);
   if(w > 0)
     {
      if(!ChartIndicatorDelete(0, w, nm))
         Print("ABTG_Segnali: pannello volumi non rimosso (errore ", GetLastError(), ").");
     }
  }

//+------------------------------------------------------------------+
//| Scrive nei buffer la barra i dallo stato del motore               |
//+------------------------------------------------------------------+
void WriteBar(const int i, const SConfl &s, const bool closed)
  {
   bE1[i] = s.okE1 ? s.e1 : EMPTY_VALUE;
   bE2[i] = s.okE2 ? s.e2 : EMPTY_VALUE;
   bE3[i] = s.okE3 ? s.e3 : EMPTY_VALUE;
   bE4[i] = s.okE4 ? s.e4 : EMPTY_VALUE;
   if(s.okBB)
     {
      bBBu[i] = s.bbUp;
      bBBm[i] = s.bbMid;
      bBBl[i] = s.bbLo;
     }
   else
     {
      bBBu[i] = EMPTY_VALUE;
      bBBm[i] = EMPTY_VALUE;
      bBBl[i] = EMPTY_VALUE;
     }
   cAtr[i] = s.okATR ? s.atr : 0.0;
   if(s.okST)
     {
      bST[i]  = s.stVal;
      bSTc[i] = (s.stDir > 0) ? 0.0 : 1.0;
     }
   else
     {
      bST[i]  = EMPTY_VALUE;
      bSTc[i] = 0.0;
     }
   // il segnale esiste SOLO per le barre chiuse (mai repaint)
   cSigA[i] = closed ? (double)s.sigA : 0.0;
   cSigB[i] = closed ? (double)s.sigB : 0.0;
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   gInitOk = false;
   gColsHidden = false;
   gPanelDone = false;
   gPanelTries = 0;
   gHVol = INVALID_HANDLE;
   gLastAlertTime = 0;
   gLastBarTime = 0;
   gRatesTotal = 0;
   gDirty = true;

   if(!gEng.Init(InpEmaFast, InpEmaSlow, InpEma3, InpEma4,
                 InpBBPeriod, InpBBDev, InpBBExpandBars, InpBBExpandPct,
                 InpAtrPeriod, InpStMult, InpAtrWilder,
                 InpCrossLookback, InpSlopeBars, InpBreakLookback, InpCooldownBars,
                 InpVolMaPeriod, InpVolFactor))
      Print("ABTG_Segnali: alcuni parametri fuori intervallo sono stati corretti (periodi 1-120, lookback 0-100, dev/moltiplicatore > 0).");

   bool ok = true;
   ok = SetIndexBuffer(0,  bHAo,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(1,  bHAh,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(2,  bHAl,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(3,  bHAc,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(4,  bHAcol, INDICATOR_COLOR_INDEX)  && ok;
   ok = SetIndexBuffer(5,  bBBu,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(6,  bBBm,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(7,  bBBl,   INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(8,  bE1,    INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(9,  bE2,    INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(10, bE3,    INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(11, bE4,    INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(12, bST,    INDICATOR_DATA)         && ok;
   ok = SetIndexBuffer(13, bSTc,   INDICATOR_COLOR_INDEX)  && ok;
   ok = SetIndexBuffer(14, cAtr,   INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(15, cSigA,  INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(16, cSigB,  INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(17, cHAo,   INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(18, cHAh,   INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(19, cHAl,   INDICATOR_CALCULATIONS) && ok;
   ok = SetIndexBuffer(20, cHAc,   INDICATOR_CALCULATIONS) && ok;
   if(!ok)
     {
      Print("ABTG_Segnali: SetIndexBuffer fallito, errore ", GetLastError());
      return INIT_FAILED;
     }
   for(int p = 0; p < 9; p++)
      PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetString(4, PLOT_LABEL, "EMA " + IntegerToString(gEng.pEmaFast));
   PlotIndexSetString(5, PLOT_LABEL, "EMA " + IntegerToString(gEng.pEmaSlow));
   PlotIndexSetString(6, PLOT_LABEL, "EMA " + IntegerToString(gEng.pEma3));
   PlotIndexSetString(7, PLOT_LABEL, "EMA " + IntegerToString(gEng.pEma4));
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   IndicatorSetString(INDICATOR_SHORTNAME, "ABTG Segnali EMA BB ST");

   // oggetti orfani di un'istanza morta male: via, poi si ricreano quelli giusti
   ObjectsDeleteAll(0, PFX);

   // stato dei tasti: sopravvive al cambio TF; se l'input VOLUME e' cambiato dal dialogo, vince l'input
   gHA = false;
   string kHA = GvKey("HA");
   if(GlobalVariableCheck(kHA))
      gHA = (GlobalVariableGet(kHA) > 0.5);
   gVolOn = InpUseVolFilter;
   string kV = GvKey("VOL"), kVi = GvKey("VOLIN");
   if(GlobalVariableCheck(kV) && GlobalVariableCheck(kVi) &&
      ((GlobalVariableGet(kVi) > 0.5) == InpUseVolFilter))
      gVolOn = (GlobalVariableGet(kV) > 0.5);
   else
     {
      GvSave("VOL", gVolOn ? 1.0 : 0.0);
      GvSave("VOLIN", InpUseVolFilter ? 1.0 : 0.0);
     }

   UpdateButtons();
   gInitOk = true;
   if(gHA)
      ColsHide();     // ultimo passo: da qui OnDeinit ripristina sempre
   if(InpAutoPannelloVolumi)
      EventSetTimer(1);   // aggiunta del pannello DIFFERITA: mai chiamare ChartIndicatorAdd dentro OnInit
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ColsRestore();                         // OGNI motivo di uscita: le candele native tornano
   if(reason == REASON_REMOVE && InpAutoPannelloVolumi)
      RemoveVolumePanel();                // solo se tolgo QUESTO indicatore, non al cambio TF
   if(gHVol != INVALID_HANDLE)
     {
      IndicatorRelease(gHVol);
      gHVol = INVALID_HANDLE;
     }
   ObjectsDeleteAll(0, PFX);
   if(reason == REASON_REMOVE || reason == REASON_CHARTCLOSE)
      GvClear();
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   if(gPanelDone)
     {
      EventKillTimer();
      return;
     }
   gPanelTries++;
   TryAddVolumePanel();
   if(!gPanelDone && gPanelTries >= 5)
     {
      Print("ABTG_Segnali: pannello volumi non aggiunto dopo 5 tentativi (grafico non pronto?).");
      gPanelDone = true;
     }
   if(gPanelDone)
      EventKillTimer();
  }

//+------------------------------------------------------------------+
void SetHA(const bool on)
  {
   if(on != gHA)
     {
      gHA = on;
      GvSave("HA", on ? 1.0 : 0.0);
      if(on)
         ColsHide();
      else
         ColsRestore();
      FillHA(gRatesTotal);
     }
   UpdateButtons();
   ChartRedraw(0);
  }

void SetVol(const bool on)
  {
   if(on != gVolOn)
     {
      gVolOn = on;
      GvSave("VOL", on ? 1.0 : 0.0);
      DrawSignals(gRatesTotal);    // nessun ricalcolo: le due varianti sono gia' nei buffer
     }
   UpdateButtons();
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(!gInitOk || id != CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam, PFX) != 0)        // guardia: solo i NOSTRI oggetti
      return;
   if(sparam == BTN_N)
      SetHA(false);
   else
      if(sparam == BTN_H)
         SetHA(true);
      else
         if(sparam == BTN_V)
            SetVol(!gVolOn);
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
  {
   if(!gInitOk || rates_total < 2)
      return 0;
   ArraySetAsSeries(time, false);
   ArraySetAsSeries(open, false);
   ArraySetAsSeries(high, false);
   ArraySetAsSeries(low, false);
   ArraySetAsSeries(close, false);
   ArraySetAsSeries(tick_volume, false);

   const int closedTotal = rates_total - 1;   // barre chiuse: 0..rates_total-2
   bool reset = false;
   if(prev_calculated <= 0 || prev_calculated > rates_total || gEng.n > closedTotal)
     {
      gEng.Reset();          // ricalcolo completo: storico ricaricato o cambiato
      reset = true;
     }

   //--- barre CHIUSE: si alimentano una volta sola, in ordine
   bool newSig = false;
   for(int i = gEng.n; i < closedTotal; i++)
     {
      gEng.Feed(open[i], high[i], low[i], close[i], (double)tick_volume[i]);
      WriteBar(i, gEng, true);
      if(gEng.sigA != 0 || gEng.sigB != 0)
         newSig = true;
     }

   //--- barra IN FORMAZIONE: anteprima su una copia, il motore resta intatto e senza segnale
   const int f = rates_total - 1;
   gTmp = gEng;
   gTmp.Feed(open[f], high[f], low[f], close[f], (double)tick_volume[f]);
   WriteBar(f, gTmp, false);

   //--- Heikin Ashi interno (solo display): sempre calcolato, mostrato solo in modalita' HA
   int haStart = reset ? 0 : MathMax(0, prev_calculated - 1);
   for(int i = haStart; i < rates_total; i++)
     {
      double hc = (open[i] + high[i] + low[i] + close[i]) / 4.0;
      double ho = (i == 0) ? (open[i] + close[i]) / 2.0 : (cHAo[i - 1] + cHAc[i - 1]) / 2.0;
      cHAo[i] = ho;
      cHAc[i] = hc;
      cHAh[i] = MathMax(high[i], MathMax(ho, hc));
      cHAl[i] = MathMin(low[i],  MathMin(ho, hc));
      ShowHA(i);
     }

   gRatesTotal = rates_total;

   //--- oggetti dei segnali: si ricostruiscono solo se cambiati
   if(reset || newSig)
      gDirty = true;
   if(gDirty)
     {
      DrawSignals(rates_total);
      gDirty = false;
     }

   //--- avvisi: solo sulla barra chiusa appena finita, mai sul primo giro/ricarico
   const int lc = rates_total - 2;
   if(reset)
      gLastAlertTime = time[lc];
   else
     {
      double sg = SelSig(lc);
      if(sg != 0.0 && time[lc] > gLastAlertTime)
        {
         gLastAlertTime = time[lc];
         if(InpAlert || InpPush)
            SendSignalAlert(sg > 0.0, time[lc]);
        }
     }

   //--- se qualcuno ha cancellato i tasti, si rifanno a ogni nuova barra
   if(time[f] != gLastBarTime)
     {
      gLastBarTime = time[f];
      if(ObjectFind(0, BTN_N) < 0 || ObjectFind(0, BTN_H) < 0 || ObjectFind(0, BTN_V) < 0)
         UpdateButtons();
     }
   return rates_total;
  }
//+------------------------------------------------------------------+
