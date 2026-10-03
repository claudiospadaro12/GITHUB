//+------------------------------------------------------------------+
//|                                     ABTG_EMA200_Dashboard.mq5    |
//|  Dashboard di SOLA LETTURA: per ogni cross elencato mostra quanto|
//|  il prezzo e' lontano dalla EMA (default 200) sui TF scelti.     |
//|  v4: CLIC sulla casella di un TF = PIANO dei 2 ordini LIMIT       |
//|  (come ABTG_EMA200): prezzi di ingresso, SL, TP e LOTTI al rischio|
//|  scelto da Claudio (default 1% del saldo di QUESTO terminale, in |
//|  2 ordini da meta'). Solo CALCOLO: gli ordini li piazza Claudio. |
//|  Cella misurata: SOLO U30USD H1 con O1 0,20 / O2 0,30 (771531;   |
//|  OOS PF 1,52 su 257 POSIZIONI = 517 righe-deal, un solo regime), |
//|  NON i default qui sotto (0,10/0,35 = default dell'EA).          |
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
//|  Click sul simbolo: se sul grafico gira un EA NON succede niente  |
//|  (il grafico non cambia simbolo e NON se ne apre un altro: un     |
//|  grafico nuovo nasce da default.tpl e potrebbe accendere un EA);  |
//|  il Journal dice di aprire il simbolo A MANO (v4.03).             |
//|  Il piano scrive nel Journal, una volta per casella, da dove      |
//|  viene la perdita per lotto.                                      |
//|  v4.02: se la perdita per lotto viene dal tick value di un indice |
//|  (non forex) in valuta diversa dal conto, il PIANO lo dice a      |
//|  schermo: su BCM quel tick value NON e' convertito (classe 1078)  |
//|  e il lotto esce piu' piccolo di quello dell'EA (U30USD ~-14%,    |
//|  225JPY ~1/180).                                                  |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "4.03"
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
input bool            InpPiano        = true;      // Clic sulla casella del TF = piano dei 2 limit
input double          InpRiskPct      = 1.0;       // Piano: rischio % TOTALE del saldo (scelta di Claudio), diviso in 2 ordini
input double          InpOrder1Atr    = 0.10;      // Piano, limit 1: dalla EMA verso il prezzo di N ATR (default EA; la sedia 771531 usa 0.20)
input double          InpOrder2Atr    = 0.35;      // Piano, limit 2: oltre la EMA (overshoot) di N ATR (la sedia 771531 usa 0.30)
input double          InpSLatr        = 1.0;       // Piano: SL a N ATR oltre il limit 2
input double          InpTpRR         = 2.0;       // Piano: TP finale in multipli di R (dal rispettivo limit)
input int             InpExpiryBars   = 6;         // Piano: scadenza consigliata dei pendenti (barre del TF)
input double          InpMinDistAtr   = 0.3;       // Filtro EA: distanza minima prezzo-EMA (ATR)
input double          InpMaxDistAtr   = 1.5;       // Filtro EA: distanza massima prezzo-EMA (ATR)
input bool            InpUseEma14Bias = true;      // Filtro EA: EMA14 dallo stesso lato del prezzo

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

int    gSelS = -1;              // simbolo scelto per il piano (indice in gSym), -1 = nessuno
int    gSelT = -1;              // TF scelto per il piano (indice in gTf)
int    gHE14 = INVALID_HANDLE;  // EMA14 del solo TF scelto (filtro dell'EA)
bool   gPlanDrawn = false;
bool   gLotSrcLogged = false;   // fonte della perdita per lotto gia' scritta nel Journal per questa casella?
bool   gLotTvRaw = false;       // il piano usa il tick value di un CFD in valuta diversa dal conto (classe 1078)?
double gLotPtVal = 0.0;         // valore di 1,0 di prezzo x 1 lotto usato dal piano, in valuta conto

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

   // stato del piano azzerato a ogni init: gli indici gSelS/gSelT valgono solo per QUESTA
   // lista di simboli/TF (con input cambiati puntarebbero fuori dagli array)
   if(gHE14 != INVALID_HANDLE)
      IndicatorRelease(gHE14);
   gHE14      = INVALID_HANDLE;
   gSelS      = -1;
   gSelT      = -1;
   gPlanDrawn = false;
   gLotSrcLogged = false;

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
   if(gHE14 != INVALID_HANDLE)
      IndicatorRelease(gHE14);
   gHE14      = INVALID_HANDLE;
   gSelS      = -1;
   gSelT      = -1;
   gPlanDrawn = false;
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
   if(id != CHARTEVENT_OBJECT_CLICK)
      return;
   // clic su una CASELLA di TF: piano dei 2 limit (il simbolo e il TF si leggono dal tooltip,
   // scritto a ogni Refresh insieme al testo: e' quello che Claudio VEDE, anche dopo un riordino)
   if(InpPiano && StringFind(sparam, PFX + "C_") == 0)
     {
      SelectCell(ObjectGetString(0, sparam, OBJPROP_TOOLTIP));
      return;
     }
   if(!InpClickSymbol)
      return;
   if(StringFind(sparam, PFX + "S_") != 0)
      return;
   string sym = ObjectGetString(0, sparam, OBJPROP_TEXT);
   if(StringLen(sym) == 0 || !SymbolInfoInteger(sym, SYMBOL_EXIST))
      return;
   // Se su QUESTO grafico gira un EA, cambiargli simbolo lo reinizializzerebbe su un
   // altro strumento (una sedia che passa a operare su un altro cross). In quel caso
   // NON si fa niente: ne' si cambia il grafico, ne' se ne apre uno nuovo (un grafico
   // nuovo nasce da default.tpl e se il template contiene un EA lo accende: classe 951).
   if(StringLen(ChartGetString(0, CHART_EXPERT_NAME)) > 0)
     {
      Print("ABTG_EMA200_Dashboard: su questo grafico gira un EA: non cambio simbolo e non apro altri grafici. Apri ", sym, " a mano su un grafico vuoto.");
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

// Simbolo NON in modo di calcolo forex (gli indici BCM sono in modo 1 = FUTURES, sonda GSPEC
// "TRADE_CALC_MODE;1": NON in modo CFD, quindi il filtro e' "non forex", non "CFD") con valuta di
// profitto diversa da quella del conto. XAUUSD su BCM e' in modo FOREX (0) e il suo tick value E'
// convertito (0,86289 per 0,01 = 86,29 EUR per dollaro; statement 85,0): escluso, giustamente.
// Su BCM il tick value di questi simboli arriva NON convertito (InfoBroker 17/08: U30USD/NASUSD/
// SPXUSD/200AUD 0,10 per tick 0,10, 225JPY 10 per tick 1; statement: U30USD 0,865 EUR per punto
// per lotto, 225JPY 0,055). Classe 1078.
bool CfdOtherCcy(const string sym)
  {
   ENUM_SYMBOL_CALC_MODE cm = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(sym, SYMBOL_TRADE_CALC_MODE);
   if(cm == SYMBOL_CALC_MODE_FOREX || cm == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)
      return false;
   string p = SymbolInfoString(sym, SYMBOL_CURRENCY_PROFIT);
   string a = AccountInfoString(ACCOUNT_CURRENCY);
   StringToUpper(p);
   StringToUpper(a);
   return (StringLen(p) > 0 && p != a);
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Lotti per rischiare 'riskMoney' tra ingresso e SL. Prima scelta  |
//| OrderCalcProfit (come ABTG_EMA200), MA la documentazione MQL5 la  |
//| mette fra le funzioni VIETATE negli indicatori: se il terminale la|
//| rifiuta, la perdita per lotto viene dal tick value IN PERDITA     |
//| (ripiego su quello generico). Quale ramo gira lo scrive il Journal|
//| una volta per casella. Arrotonda PER DIFETTO al passo; 0 = no.    |
//+------------------------------------------------------------------+
double LotForRisk(const string sym, const bool isLong, const double entry, const double sl,
                  const double riskMoney, double &lossPerLot)
  {
   lossPerLot = 0.0;
   if(riskMoney <= 0.0)
      return 0.0;
   double profit = 0.0;
   bool   fromBroker = false;
   if(OrderCalcProfit(isLong ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, sym, 1.0, entry, sl, profit) && profit < 0.0)
     {
      lossPerLot = -profit;
      fromBroker = true;
     }
   if(lossPerLot <= 0.0)
     {
      double tv  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE_LOSS);
      if(tv <= 0.0)
         tv = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
      double tsz = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
      if(tv <= 0.0 || tsz <= 0.0)
         return 0.0;
      lossPerLot = MathAbs(entry - sl) / tsz * tv;
      if(CfdOtherCcy(sym))
        {
         gLotTvRaw = true;              // il piano lo dice a schermo (DrawPlan)
         gLotPtVal = tv / tsz;
        }
     }
   if(!gLotSrcLogged)
     {
      Print("ABTG_EMA200_Dashboard: piano ", sym, ": perdita per lotto ", DoubleToString(lossPerLot, 2), " ",
            AccountInfoString(ACCOUNT_CURRENCY), (fromBroker ? " da OrderCalcProfit" : " dal tick value (OrderCalcProfit non disponibile)"));
      gLotSrcLogged = true;
     }
   if(lossPerLot <= 0.0)
      return 0.0;
   double lot  = riskMoney / lossPerLot;
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double mn   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double mx   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   if(step > 0.0)
      lot = MathFloor(lot / step + 1e-9) * step;
   if(mx > 0.0 && lot > mx)
      lot = mx;
   if(lot < mn || lot <= 0.0)
      return 0.0;
   return lot;
  }

// Lotto come testo. Sotto il minimo NON si propone il minimo (sarebbe piu' rischio di quello
// scelto): si dice quanto rischierebbe. NB: ABTG_EMA200 (LotByRisk) in quel caso mette il MINIMO.
string LotText(const string sym, const double lot, const double lossPerLot)
  {
   double step = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   int dec = 2;
   if(step > 0.0)
      dec = (int)MathMin(8.0, MathMax(0.0, MathCeil(-MathLog10(step) - 1e-9)));
   if(lot > 0.0)
      return DoubleToString(lot, dec);
   double mn = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   if(lossPerLot > 0.0 && mn > 0.0)
      return StringFormat("n/d: il minimo %s rischia %.2f", DoubleToString(mn, dec), mn * lossPerLot);
   return "n/d (perdita per lotto non calcolabile)";
  }

// Prezzo arrotondato al TICK del simbolo, come NormalizePrice() di ABTG_EMA200: sugli indici il
// tick puo' essere piu' grosso del point, e un prezzo solo "a cifre" non sarebbe piazzabile.
double NormPx(const string sym, const double price)
  {
   int    dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double ts = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   if(ts <= 0.0)
      return NormalizeDouble(price, dg);
   return NormalizeDouble(MathRound(price / ts) * ts, dg);
  }

bool Eq(const double a, const double b)
  {
   return (MathAbs(a - b) < 1e-9);
  }

//+------------------------------------------------------------------+
//| Clic su una casella: sceglie (o toglie) il piano                  |
//+------------------------------------------------------------------+
void SelectCell(const string tip)
  {
   string p[];
   if(StringSplit(tip, '|', p) != 2)
      return;
   int t = (int)StringToInteger(p[1]);
   int s = -1;
   for(int i = 0; i < gN; i++)
      if(gSym[i] == p[0])
         s = i;
   if(s < 0 || t < 0 || t >= gNT)
      return;
   if(gHE14 != INVALID_HANDLE)
     {
      IndicatorRelease(gHE14);
      gHE14 = INVALID_HANDLE;
     }
   if(s == gSelS && t == gSelT)      // secondo clic sulla stessa casella: chiude il piano
     {
      gSelS = -1;
      gSelT = -1;
     }
   else
     {
      gSelS = s;
      gSelT = t;
      gHE14 = iMA(gSym[s], gTf[t], 14, 0, MODE_EMA, PRICE_CLOSE);
     }
   gLotSrcLogged = false;            // casella nuova: la fonte della perdita per lotto si riscrive una volta
   Refresh();
  }

//+------------------------------------------------------------------+
//| Disegna il piano dei 2 limit sotto la tabella                     |
//+------------------------------------------------------------------+
void DrawPlan(int xBox, int yTop, const int wMin)   // xBox/yTop NON const: si spostano se il piano non ci sta sotto
  {
   if(!InpPiano || gSelS < 0 || gSelT < 0)
     {
      if(gPlanDrawn)
        {
         ObjectsDeleteAll(0, PFX + "P_");
         gPlanDrawn = false;
        }
      return;
     }
   string sym = gSym[gSelS];
   int    k   = gSelS * gNT + gSelT;
   int    dg  = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   string lines[12];                     // caso peggiore 11 righe (ramo dati pronti + avviso 1078); 1 riga se non pronti
   color  cols[12];
   int    n = 0;

   double e[1], a[1], e14[1];
   bool ok = (gHMa[k] != INVALID_HANDLE && gHAtr[k] != INVALID_HANDLE &&
              BarsCalculated(gHMa[k]) >= InpEmaPeriod && BarsCalculated(gHAtr[k]) >= InpAtrPeriod + 1 &&
              CopyBuffer(gHMa[k], 0, 1, 1, e) == 1 && CopyBuffer(gHAtr[k], 0, 1, 1, a) == 1 &&
              e[0] > 0.0 && a[0] > 0.0);
   double cl1 = iClose(sym, gTf[gSelT], 1);
   if(!ok || cl1 <= 0.0)
     {
      lines[0] = "PIANO " + sym + " " + gTfName[gSelT] + ": dati non pronti, riprova tra qualche secondo.";
      cols[0]  = C'255,140,0';
      n = 1;
     }
   else
     {
      double ema = e[0], atr = a[0];
      bool   up  = (cl1 > ema);              // come l'EA: chiusura della barra precedente sopra la EMA = LONG
      double dist = MathAbs(cl1 - ema);
      bool   fasciaOk = (dist >= InpMinDistAtr * atr && dist <= InpMaxDistAtr * atr);
      bool   e14Known = false, e14Ok = true;
      if(InpUseEma14Bias && gHE14 != INVALID_HANDLE && BarsCalculated(gHE14) >= 15 &&
         CopyBuffer(gHE14, 0, 1, 1, e14) == 1 && e14[0] > 0.0)
        {
         e14Known = true;
         e14Ok = !((up && e14[0] < ema) || (!up && e14[0] > ema));
        }
      // prezzi arrotondati al TICK come NormalizePrice() dell'EA (r.459-465), non solo alle cifre
      double o1 = NormPx(sym, up ? ema + InpOrder1Atr * atr : ema - InpOrder1Atr * atr);
      double o2 = NormPx(sym, up ? ema - InpOrder2Atr * atr : ema + InpOrder2Atr * atr);
      double sl = NormPx(sym, up ? o2 - InpSLatr * atr : o2 + InpSLatr * atr);
      double bal = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskEach = bal * (InpRiskPct / 2.0) / 100.0;
      string side = up ? "BUY" : "SELL";
      color  cs   = up ? C'60,220,110' : C'255,90,90';
      double ask  = SymbolInfoDouble(sym, SYMBOL_ASK);
      double bid  = SymbolInfoDouble(sym, SYMBOL_BID);

      lines[n] = StringFormat("PIANO %s %s: %s LIMIT  (ultima chiusura %s la EMA%d = %s, ATR %s)",
                              sym, gTfName[gSelT], side, up ? "SOPRA" : "SOTTO", InpEmaPeriod,
                              DoubleToString(ema, dg), DoubleToString(atr, dg));
      cols[n++] = C'235,235,235';
      lines[n] = StringFormat("Rischio %.2f%% del saldo %.2f %s = %.2f, in 2 ordini da %.2f%% (%.2f ciascuno)",
                              InpRiskPct, bal, AccountInfoString(ACCOUNT_CURRENCY), bal * InpRiskPct / 100.0,
                              InpRiskPct / 2.0, riskEach);
      cols[n++] = C'190,190,190';
      gLotTvRaw = false;                 // lo rimette LotForRisk se il tick value e' quello di un CFD in altra valuta
      gLotPtVal = 0.0;
      double os[2];
      os[0] = o1;
      os[1] = o2;
      for(int i = 0; i < 2; i++)
        {
         double risk = up ? (os[i] - sl) : (sl - os[i]);
         if(risk <= 0.0)
           {
            lines[n] = StringFormat("%s LIMIT %d: %s  SL non valido (rischio <= 0): salta", side, i + 1,
                                    DoubleToString(os[i], dg));
            cols[n++] = C'255,140,0';
            continue;
           }
         double tp  = NormPx(sym, up ? os[i] + risk * InpTpRR : os[i] - risk * InpTpRR);
         double lpl = 0.0;
         double lot = LotForRisk(sym, up, os[i], sl, riskEach, lpl);
         // il piano e' calcolato sulla barra CHIUSA, ma il prezzo si muove dentro la barra: un
         // BUY LIMIT sopra l'Ask (o un SELL LIMIT sotto il Bid) il server lo RIFIUTA
         bool oltre = up ? (ask > 0.0 && os[i] >= ask) : (bid > 0.0 && os[i] <= bid);
         lines[n] = StringFormat("%s LIMIT %d:  %s    SL %s    TP %s (%.1fR)    lotti %s%s", side, i + 1,
                                 DoubleToString(os[i], dg), DoubleToString(sl, dg),
                                 DoubleToString(tp, dg), InpTpRR, LotText(sym, lot, lpl),
                                 oltre ? "  [gia' oltre: NON piazzabile ora]" : "");
         cols[n++] = oltre ? C'255,140,0' : cs;
        }
      if(gLotTvRaw)
        {
         lines[n] = StringFormat("ATTENZIONE LOTTI: 1,0 di prezzo x 1 lotto = %s %s, dal TICK VALUE (un indicatore non puo' usare OrderCalcProfit).",
                                 DoubleToString(gLotPtVal, 4), AccountInfoString(ACCOUNT_CURRENCY));
         cols[n++] = C'255,140,0';
         lines[n] = StringFormat("Misurato su BCM: per gli indici in %s NON e' convertito (U30USD 1.00 contro 0.865 EUR veri) -> lotti PIU' PICCOLI dell'EA.",
                                 SymbolInfoString(sym, SYMBOL_CURRENCY_PROFIT));
         cols[n++] = C'255,140,0';
        }
      bool   ema14No = (InpUseEma14Bias && e14Known && !e14Ok);
      string verd    = (!fasciaOk || ema14No) ? "l'EA NON li piazzerebbe"
                       : ((InpUseEma14Bias && !e14Known) ? "EMA14 non pronta" : "l'EA li piazzerebbe");
      lines[n] = StringFormat("Filtri dell'EA: distanza %.2f ATR (fascia %.2f-%.2f) %s | EMA14 dal lato giusto: %s -> %s",
                              dist / atr, InpMinDistAtr, InpMaxDistAtr, fasciaOk ? "OK" : "FUORI",
                              !InpUseEma14Bias ? "non richiesto" : (e14Known ? (e14Ok ? "OK" : "NO") : "n/d"), verd);
      cols[n++] = (fasciaOk && (!InpUseEma14Bias || (e14Known && e14Ok))) ? C'60,220,110' : C'255,140,0';
      lines[n] = StringFormat("Scadenza consigliata: %d barre %s; poi cancella i pendenti non eseguiti.",
                              InpExpiryBars, gTfName[gSelT]);
      cols[n++] = C'190,190,190';
      // la cella MISURATA di 771531 (preset ABTG_EMA200_U30USD_H1_771531_VIVA.set, CSV R112 OOS):
      // O1 0,20 / O2 0,30 / SL 1,0 / TP 2R / fascia 0,3-1,5 / EMA14 / EMA200 / ATR14 / scadenza 6 barre,
      // NON i default dell'EA. n = 257 POSIZIONI (517 sono le righe-deal: con parziale+trailing ogni
      // posizione ne fa ~2; REFERTO_R112 r.83). Finestra OOS 2025.06.10-2026.06.30: un solo regime.
      bool cella = (StringFind(sym, "U30USD") == 0 && gTf[gSelT] == PERIOD_H1 &&
                    Eq(InpOrder1Atr, 0.20) && Eq(InpOrder2Atr, 0.30) && Eq(InpSLatr, 1.0) && Eq(InpTpRR, 2.0) &&
                    Eq(InpMinDistAtr, 0.3) && Eq(InpMaxDistAtr, 1.5) && InpUseEma14Bias &&
                    InpEmaPeriod == 200 && InpAtrPeriod == 14 && InpExpiryBars == 6);
      lines[n] = cella
                 ? "E' la cella di 771531 (U30USD H1, parametri del preset tranne il rischio): OOS PF 1.52 su 257 posizioni, un solo regime."
                 : "NON e' la cella di 771531 (U30USD H1, O1 0.20 O2 0.30 SL 1.0 TP 2R, fascia 0.3-1.5, EMA14, scad. 6): NON validato.";
      cols[n++] = C'255,140,0';
      lines[n] = "L'EA gestisce anche parziale 50% su EMA14 + pareggio + trailing: solo SL/TP a mano NON e' la stessa cosa.";
      cols[n++] = C'255,140,0';
      lines[n] = StringFormat("Solo calcolo (conto %I64d di QUESTO terminale): gli ordini li metti tu. Il rischio %% e' scelta tua.",
                              AccountInfoInteger(ACCOUNT_LOGIN));
      cols[n++] = C'150,150,150';
     }

   int maxLen = 0;
   for(int i = 0; i < n; i++)
      maxLen = (int)MathMax(maxLen, StringLen(lines[i]));
   int wPlan = 16 + (int)MathCeil(maxLen * InpFontSize * 0.75);
   int w     = (int)MathMax(wMin, wPlan);
   // con la lista di default (30 simboli, font 9) la tabella e' alta ~760 px: "sotto" il piano
   // finirebbe fuori dal grafico. Se non ci sta in altezza, va a DESTRA della tabella.
   int chH = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
   if(chH > 0 && yTop + n * gRowH + 12 > chH)
     {
      xBox = InpX + wMin + 8;
      yTop = InpY;
      w    = wPlan;
     }
   string bg = PFX + "P_BG";
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
   ObjectSetInteger(0, bg, OBJPROP_XDISTANCE, xBox);
   ObjectSetInteger(0, bg, OBJPROP_YDISTANCE, yTop);
   ObjectSetInteger(0, bg, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, bg, OBJPROP_YSIZE, n * gRowH + 12);
   for(int i = 0; i < 12; i++)
     {
      string nm = PFX + "P_" + IntegerToString(i);
      if(i < n)
         Lbl(nm, xBox + 8, yTop + 6 + i * gRowH, lines[i], cols[i]);
      else
         if(ObjectFind(0, nm) >= 0)
            ObjectDelete(0, nm);
     }
   gPlanDrawn = true;
  }

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
         string cn = PFX + "C_" + IntegerToString(r) + "_" + IntegerToString(t);
         Lbl(cn, x0 + gColSym + t * gColW, y, txt, ColorFor(gDist[k]));
         ObjectSetString(0, cn, OBJPROP_TOOLTIP, gSym[s] + "|" + IntegerToString(t));
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

   DrawPlan(InpX, InpY + H + 8, W);

   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
