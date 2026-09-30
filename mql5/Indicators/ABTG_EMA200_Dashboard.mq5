//+------------------------------------------------------------------+
//|                                     ABTG_EMA200_Dashboard.mq5    |
//|  Dashboard di SOLA LETTURA: per ogni cross elencato mostra quanto|
//|  il prezzo e' lontano dalla EMA (default 200) sui TF scelti.     |
//|  v3: nelle celle i PIPS (forex) o PUNTI (indici, metalli) che    |
//|  mancano perche' il prezzo tocchi la EMA, e il LIVELLO della EMA |
//|  (utile per piazzare ordini pendenti). Modo cella a scelta.      |
//|  v2: liste Forex / Indici / Metalli accendibili e modificabili;  |
//|  TF a scelta con interruttori (M5, M15, M30, H1, H4, D1).        |
//|                                                                  |
//|  - Distanza in ATR (segno + = prezzo SOPRA la EMA, - = SOTTO)    |
//|    e in % del prezzo. In ATR i cross sono confrontabili tra loro.|
//|  - Righe ORDINATE per vicinanza sul TF principale (il piu'       |
//|    vicino alla EMA sta in cima).                                 |
//|  - Colori: arancione = vicinissimo, giallo = vicino, grigio = no.|
//|  - Click sul nome del simbolo = il grafico passa a quel simbolo. |
//|  - Avviso opzionale (Alert / notifica push) quando un cross      |
//|    entra nella fascia "vicinissimo" sul TF principale.           |
//|                                                                  |
//|  Segno: + = prezzo SOPRA la EMA (deve scendere per toccarla),    |
//|  - = prezzo SOTTO la EMA (deve salire).                          |
//|                                                                  |
//|  NON apre, NON modifica, NON chiude ordini. Non e' un EA.        |
//|  Unico effetto sul terminale: SymbolSelect() aggiunge al Market  |
//|  Watch i simboli della lista (serve per avere i prezzi).         |
//|  Click: se sul grafico gira un EA il grafico NON cambia simbolo, |
//|  si apre un grafico nuovo (ChartOpen) del simbolo cliccato.      |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "3.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

enum ENUM_CELLA
  {
   CELLA_PIPS_ATR = 0,   // Pips/punti + ATR
   CELLA_PIPS     = 1,   // Solo pips/punti
   CELLA_ATR      = 2,   // Solo ATR
   CELLA_PCT      = 3,   // ATR + % del prezzo
   CELLA_LIVELLO  = 4    // Prezzo della EMA (livello dove piazzare il pendente)
  };

input ENUM_CELLA      InpCellMode     = CELLA_PIPS_ATR; // Cosa mostrare nelle celle
input bool            InpForex        = true;      // Mostra FOREX
input string          InpSymForex     = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"; // Lista forex (virgola)
input bool            InpIndici       = true;      // Mostra INDICI
input string          InpSymIndici    = "D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY"; // Lista indici (nomi BCM; su altri broker riscrivili)
input bool            InpMetalli      = true;      // Mostra METALLI
input string          InpSymMetalli   = "XAUUSD,XAGUSD"; // Lista metalli
input string          InpSuffix       = "";        // Suffisso broker (se serve)
input int             InpEmaPeriod    = 200;       // Periodo EMA
input int             InpAtrPeriod    = 14;        // Periodo ATR (unita' di distanza)
input bool            InpTfM5         = false;     // Colonna M5
input bool            InpTfM15        = true;      // Colonna M15
input bool            InpTfM30        = false;     // Colonna M30
input bool            InpTfH1         = true;      // Colonna H1
input bool            InpTfH4         = true;      // Colonna H4
input bool            InpTfD1         = true;      // Colonna D1
input ENUM_TIMEFRAMES InpTfMain       = PERIOD_H4; // TF di ordinamento (deve essere uno dei TF accesi)
input double          InpNearAtr      = 1.00;      // "Vicino": distanza <= questi ATR (giallo)
input double          InpHotAtr       = 0.30;      // "Vicinissimo": distanza <= questi ATR (arancione)
input int             InpRefreshSec   = 2;         // Aggiornamento (secondi)
input bool            InpClickSymbol  = true;      // Click sul simbolo = cambia grafico
input bool            InpAlert        = false;     // Avviso Alert quando entra in "vicinissimo"
input bool            InpPush         = false;     // Avviso push al telefono (serve MetaQuotes ID)
input int             InpX            = 10;        // Posizione X
input int             InpY            = 20;        // Posizione Y
input int             InpFontSize     = 9;         // Dimensione carattere

#define PFX "ABTGD_"

int             gNT = 0;         // numero di TF accesi
ENUM_TIMEFRAMES gTf[];           // TF accesi
string          gTfName[];

string gSym[];
int    gN     = 0;
int    gMain  = 2;              // indice di gTf usato per ordinare
int    gHMa[];                  // handle EMA  [s*gNT+t]
int    gHAtr[];                 // handle ATR  [s*gNT+t]
double gDist[];                 // distanza in ATR, EMPTY_VALUE se non pronta
double gPct[];                  // distanza in % del prezzo
double gPips[];                 // distanza in pips (forex) o punti di prezzo (indici, metalli), col segno
double gEma[];                  // valore della EMA (livello)
bool   gHotPrev[];              // era gia' "vicinissimo" al giro prima?
int    gIdx[];                  // ordine di visualizzazione
bool   gSeen[];                 // il TF principale del simbolo e' gia' stato misurato? (prima misura = muta)

int    gRowH = 0, gColSym = 0, gColW = 0;

//+------------------------------------------------------------------+
void Lbl(const string name, const int x, const int y, const string txt, const color c)
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);   // sopra lo sfondo: il click arriva all'etichetta
      ObjectSetString(0, name, OBJPROP_FONT, "Consolas");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, InpFontSize);
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, txt);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   // TF accesi, dal piu' basso al piu' alto
   ENUM_TIMEFRAMES allTf[6]  = {PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   string          allNm[6]  = {"M5", "M15", "M30", "H1", "H4", "D1"};
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
      Print("ABTG_EMA200_Dashboard: nessun TF acceso, accendine almeno uno.");
      return INIT_FAILED;
     }
   gMain = -1;
   for(int t = 0; t < gNT; t++)
      if(gTf[t] == InpTfMain)
         gMain = t;
   if(gMain < 0)
     {
      gMain = 0;
      Print("ABTG_EMA200_Dashboard: TF di ordinamento non tra quelli accesi, uso ", gTfName[0]);
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
         Print("ABTG_EMA200_Dashboard: simbolo non trovato sul broker, saltato: ", s);
         continue;
        }
      ArrayResize(gSym, gN + 1);
      gSym[gN] = s;
      gN++;
     }
   if(gN == 0)
     {
      Print("ABTG_EMA200_Dashboard: nessun simbolo valido.");
      return INIT_FAILED;
     }

   ArrayResize(gHMa, gN * gNT);
   ArrayResize(gHAtr, gN * gNT);
   ArrayResize(gDist, gN * gNT);
   ArrayResize(gPct, gN * gNT);
   ArrayResize(gPips, gN * gNT);
   ArrayResize(gEma, gN * gNT);
   ArrayResize(gHotPrev, gN);
   ArrayResize(gSeen, gN);
   ArrayResize(gIdx, gN);
   for(int s = 0; s < gN; s++)
     {
      gHotPrev[s] = false;
      gSeen[s]    = false;
      gIdx[s] = s;
      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         gHMa[k]  = iMA(gSym[s], gTf[t], InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
         gHAtr[k] = iATR(gSym[s], gTf[t], InpAtrPeriod);
         gDist[k] = EMPTY_VALUE;
         gPct[k]  = EMPTY_VALUE;
         gPips[k] = EMPTY_VALUE;
         gEma[k]  = EMPTY_VALUE;
        }
     }

   gRowH   = InpFontSize * 2 + 4;
   gColSym = 90 + (InpFontSize - 9) * 8;
   gColW   = 130 + (InpFontSize - 9) * 10;

   ObjectsDeleteAll(0, PFX);
   Refresh();
   EventSetTimer(MathMax(1, InpRefreshSec));
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   for(int k = 0; k < ArraySize(gHMa); k++)
     {
      if(gHMa[k] != INVALID_HANDLE)
         IndicatorRelease(gHMa[k]);
      if(gHAtr[k] != INVALID_HANDLE)
         IndicatorRelease(gHAtr[k]);
     }
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
   Refresh();
  }

//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(!InpClickSymbol || id != CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam, PFX + "S_") != 0)
      return;
   string sym = ObjectGetString(0, sparam, OBJPROP_TEXT);
   if(StringLen(sym) == 0 || !SymbolInfoInteger(sym, SYMBOL_EXIST))
      return;
   // Se su QUESTO grafico gira un EA, cambiargli simbolo lo reinizializzerebbe su un
   // altro strumento (una sedia che passa a operare su un altro cross). In quel caso
   // il grafico NON si tocca: si apre un grafico nuovo del simbolo cliccato.
   if(StringLen(ChartGetString(0, CHART_EXPERT_NAME)) > 0)
     {
      if(ChartOpen(sym, _Period) == 0)
         Print("ABTG_EMA200_Dashboard: EA sul grafico, non cambio simbolo; ChartOpen fallito per ", sym);
      return;
     }
   ChartSetSymbolPeriod(0, sym, _Period);
  }

//+------------------------------------------------------------------+
//| Forex = BASE e PROFITTO sono due VALUTE vere e diverse.          |
//| NON si usa SYMBOL_TRADE_CALC_MODE: su BCM XAUUSD e' in modo       |
//| FOREX (misurato, R114: GSPEC;XAUUSD;TRADE_CALC_MODE;0, 2 cifre)   |
//| e l'oro finiva in "pips" da 0,01 (x100). XAU/XAG non sono nella   |
//| lista -> punti di prezzo; un forex servito come CFD resta forex.  |
//+------------------------------------------------------------------+
bool IsForex(const string sym)
  {
   string valute = ",AUD,CAD,CHF,CNH,CNY,CZK,DKK,EUR,GBP,HKD,HUF,ILS,INR,JPY,MXN,NOK,NZD,PLN,RUB,SEK,SGD,THB,TRY,USD,ZAR,";
   string b = SymbolInfoString(sym, SYMBOL_CURRENCY_BASE);
   string p = SymbolInfoString(sym, SYMBOL_CURRENCY_PROFIT);
   StringToUpper(b);
   StringToUpper(p);
   if(StringLen(b) != 3 || StringLen(p) != 3 || b == p)
      return false;
   return (StringFind(valute, "," + b + ",") >= 0 && StringFind(valute, "," + p + ",") >= 0);
  }

//+------------------------------------------------------------------+
//| Dimensione di 1 "pip": forex = 10 point sui simboli a 3/5 cifre; |
//| indici e metalli = 1,0 di prezzo (1 "punto" dell'indice, 1 dollaro|
//| sull'oro). Serve solo a mostrare la distanza in unita' comode.   |
//+------------------------------------------------------------------+
double PipSize(const string sym)
  {
   double pt = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(pt <= 0.0)
      return 0.0;
   if(IsForex(sym))
     {
      int dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      return (dg == 3 || dg == 5) ? pt * 10.0 : pt;
     }
   return 1.0;
  }

//+------------------------------------------------------------------+
//| Distanza in pips/punti come testo. Punti con 2 decimali se il     |
//| simbolo ha 3+ cifre (argento: 0,1 di prezzo sarebbe troppo        |
//| grossolano per un pendente), altrimenti 1. Non pronta = "n/d".    |
//+------------------------------------------------------------------+
string PipsText(const int s, const int k)
  {
   if(gPips[k] == EMPTY_VALUE)
      return "n/d";
   if(IsForex(gSym[s]))
      return StringFormat("%+.1fp", gPips[k]);
   int dg = (int)SymbolInfoInteger(gSym[s], SYMBOL_DIGITS);
   if(dg >= 3)
      return StringFormat("%+.2fpt", gPips[k]);
   return StringFormat("%+.1fpt", gPips[k]);
  }

//+------------------------------------------------------------------+
//| Testo di una cella secondo il modo scelto                         |
//+------------------------------------------------------------------+
string CellText(const int s, const int k)
  {
   if(gDist[k] == EMPTY_VALUE)
      return "...";
   switch(InpCellMode)
     {
      case CELLA_PIPS:
         return PipsText(s, k);
      case CELLA_ATR:
         return StringFormat("%+.2f ATR", gDist[k]);
      case CELLA_PCT:
         return StringFormat("%+6.2f  %+6.2f%%", gDist[k], gPct[k]);   // identica alla v2
      case CELLA_LIVELLO:
        {
         int dg = (int)SymbolInfoInteger(gSym[s], SYMBOL_DIGITS);
         return DoubleToString(gEma[k], dg);
        }
      default:
         return PipsText(s, k) + StringFormat(" %+.2fA", gDist[k]);
     }
  }

string HeaderSuffix()
  {
   switch(InpCellMode)
     {
      case CELLA_PIPS:    return "  pips/pt";
      case CELLA_ATR:     return "  ATR";
      case CELLA_PCT:     return "  ATR   %";
      case CELLA_LIVELLO: return "  livello EMA";
      default:            return "  pips ATR";
     }
  }

//+------------------------------------------------------------------+
//| Legge EMA/ATR/prezzo e calcola le distanze                       |
//+------------------------------------------------------------------+
void Measure()
  {
   for(int s = 0; s < gN; s++)
     {
      double px = SymbolInfoDouble(gSym[s], SYMBOL_BID);
      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         gDist[k] = EMPTY_VALUE;
         gPct[k]  = EMPTY_VALUE;
         gPips[k] = EMPTY_VALUE;
         gEma[k]  = EMPTY_VALUE;
         if(gHMa[k] == INVALID_HANDLE || gHAtr[k] == INVALID_HANDLE || px <= 0.0)
            continue;
         // con meno barre del periodo la "EMA200" e' solo un riscaldamento: non si mostra
         if(BarsCalculated(gHMa[k]) < InpEmaPeriod || BarsCalculated(gHAtr[k]) < InpAtrPeriod + 1)
            continue;
         double ema[1], atr[1];
         if(CopyBuffer(gHMa[k], 0, 0, 1, ema) != 1)
            continue;
         // ATR della barra CHIUSA (shift 1): l'unita' di misura non oscilla a inizio barra
         if(CopyBuffer(gHAtr[k], 0, 1, 1, atr) != 1)
            continue;
         if(atr[0] <= 0.0 || ema[0] <= 0.0 || ema[0] == EMPTY_VALUE || atr[0] == EMPTY_VALUE)
            continue;
         gDist[k] = (px - ema[0]) / atr[0];
         gPct[k]  = (px - ema[0]) / ema[0] * 100.0;
         gEma[k]  = ema[0];
         double ps = PipSize(gSym[s]);
         if(ps > 0.0)
            gPips[k] = (px - ema[0]) / ps;
        }
     }
  }

//+------------------------------------------------------------------+
//| Ordina gIdx per |distanza| crescente sul TF principale          |
//+------------------------------------------------------------------+
double KeyOf(const int s)
  {
   double d = gDist[s * gNT + gMain];
   if(d == EMPTY_VALUE)
      return DBL_MAX;
   return MathAbs(d);
  }

void SortRows()
  {
   for(int i = 0; i < gN; i++)
      gIdx[i] = i;
   for(int i = 1; i < gN; i++)
     {
      int cur = gIdx[i];
      double kc = KeyOf(cur);
      int j = i - 1;
      while(j >= 0 && KeyOf(gIdx[j]) > kc)
        {
         gIdx[j + 1] = gIdx[j];
         j--;
        }
      gIdx[j + 1] = cur;
     }
  }

//+------------------------------------------------------------------+
color ColorFor(const double d)
  {
   if(d == EMPTY_VALUE)
      return C'110,110,110';
   double a = MathAbs(d);
   if(a <= InpHotAtr)
      return C'255,140,0';
   if(a <= InpNearAtr)
      return C'255,220,60';
   return C'190,190,190';
  }

//+------------------------------------------------------------------+
void Refresh()
  {
   Measure();
   SortRows();

   // conta i vicini sul TF principale (serve PRIMA dello sfondo: il titolo ne fissa la larghezza minima)
   int nHot = 0, nNear = 0;
   for(int s = 0; s < gN; s++)
     {
      double d = gDist[s * gNT + gMain];
      if(d == EMPTY_VALUE)
         continue;
      if(MathAbs(d) <= InpHotAtr)
         nHot++;
      else
         if(MathAbs(d) <= InpNearAtr)
            nNear++;
     }
   string title = StringFormat("EMA%d | ordine %s | vicinissimi %d, vicini %d",
                               InpEmaPeriod, gTfName[gMain], nHot, nNear);

   int W = gColSym + gNT * gColW + 20;
   // con UN solo TF acceso il pannello (240 px a font 9) e' piu' stretto del titolo (~47 car.
   // x ~6,6 px Consolas 9pt = ~310 px): la larghezza minima la da' il titolo (stima 0,75 px/pt/car.)
   W = (int)MathMax(W, 16 + (int)MathCeil(StringLen(title) * InpFontSize * 0.75));
   int H = (gN + 3) * gRowH + 10;

   string bg = PFX + "BG";
   if(ObjectFind(0, bg) < 0)
     {
      ObjectCreate(0, bg, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, bg, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, bg, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, bg, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, bg, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, bg, OBJPROP_BGCOLOR, C'18,22,30');
      ObjectSetInteger(0, bg, OBJPROP_COLOR, C'70,78,95');
      ObjectSetInteger(0, bg, OBJPROP_BACK, false);
      ObjectSetInteger(0, bg, OBJPROP_ZORDER, 0);
     }
   ObjectSetInteger(0, bg, OBJPROP_XDISTANCE, InpX);
   ObjectSetInteger(0, bg, OBJPROP_YDISTANCE, InpY);
   ObjectSetInteger(0, bg, OBJPROP_XSIZE, W);
   ObjectSetInteger(0, bg, OBJPROP_YSIZE, H);

   int x0 = InpX + 8;
   int y0 = InpY + 6;

   Lbl(PFX + "T", x0, y0, title, C'230,230,230');

   int yh = y0 + gRowH;
   Lbl(PFX + "H_S", x0, yh, "Simbolo", C'150,170,210');
   for(int t = 0; t < gNT; t++)
      Lbl(PFX + "H_" + IntegerToString(t), x0 + gColSym + t * gColW, yh,
          gTfName[t] + (t == gMain ? " *" : "") + HeaderSuffix(), C'150,170,210');

   for(int r = 0; r < gN; r++)
     {
      int s = gIdx[r];
      int y = yh + (r + 1) * gRowH;
      color cm = ColorFor(gDist[s * gNT + gMain]);
      Lbl(PFX + "S_" + IntegerToString(r), x0, y, gSym[s], cm);
      for(int t = 0; t < gNT; t++)
        {
         int k = s * gNT + t;
         string txt = CellText(s, k);
         Lbl(PFX + "C_" + IntegerToString(r) + "_" + IntegerToString(t),
             x0 + gColSym + t * gColW, y, txt, ColorFor(gDist[k]));
        }
     }

   // avvisi: solo all'ingresso nella fascia "vicinissimo" sul TF principale
   for(int s = 0; s < gN; s++)
     {
      double d = gDist[s * gNT + gMain];
      // misura non pronta (handle appena creati, dati in download, CopyBuffer fallito):
      // lo stato e' IGNOTO, non "lontano" -> la memoria non si tocca e non si avvisa
      if(d == EMPTY_VALUE)
         continue;
      bool hot = (MathAbs(d) <= InpHotAtr);
      // si avvisa solo di un INGRESSO visto: la prima misura valida del simbolo memorizza
      // e basta (il primo Refresh gira in OnInit, quando nessun handle e' ancora calcolato)
      if(hot && !gHotPrev[s] && gSeen[s])
        {
         string msg = StringFormat("%s vicino alla EMA%d su %s (%+.2f ATR)",
                                   gSym[s], InpEmaPeriod, gTfName[gMain], d);
         if(InpAlert)
            Alert(msg);
         if(InpPush)
            SendNotification(msg);
        }
      gHotPrev[s] = hot;
      gSeen[s]    = true;
     }

   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
