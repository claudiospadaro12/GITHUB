//+------------------------------------------------------------------+
//|                                    ABTG_OrologioLaterale.mq5      |
//|                                                                  |
//|  OROLOGIO GRANDE SUL GRAFICO: ora SERVER e ora ITALIA affiancate, |
//|  ben leggibili, in un angolo del grafico (non nel prezzo).       |
//|                                                                  |
//|  NASCE DALLA REGOLA DI CASA (CLAUDE.md, "FUSO ORARIO BCM"):      |
//|  confondere l'ora server con l'ora italiana e' l'errore che ha   |
//|  gia' fatto scambiare l'orario di un ordine per un ritardo (EA   |
//|  che sembrava in ritardo di un'ora ed era in orario). Questo     |
//|  indicatore non elimina l'errore: lo rende visibile a colpo      |
//|  d'occhio, cosi' non serve piu' fare il conto a mente.           |
//|                                                                  |
//|  PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca |
//|  nessun account. Si puo' attaccare a QUALUNQUE grafico, su       |
//|  QUALUNQUE terminale, senza nessun rischio operativo.            |
//|                                                                  |
//|  ATTENZIONE SULL'OFFSET: "ITALIA = SERVER + InpOffsetOre" e' la  |
//|  regola FISSA scritta in CLAUDE.md per QUESTO periodo dell'anno  |
//|  (server = italiana - 1). Se il fuso cambiasse (es. cambio ora   |
//|  legale/solare non allineato fra Italia e broker), si cambia     |
//|  SOLO l'input InpOffsetOre: non serve ricompilare.                |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

enum ENUM_ABTG_CORNER
  {
   ABTG_ALTO_SX  = CORNER_LEFT_UPPER,
   ABTG_ALTO_DX  = CORNER_RIGHT_UPPER,
   ABTG_BASSO_SX = CORNER_LEFT_LOWER,
   ABTG_BASSO_DX = CORNER_RIGHT_LOWER
  };

input ENUM_ABTG_CORNER InpAngolo      = ABTG_ALTO_SX;   // angolo del grafico (ALTO_SX = piu' sicuro, testato)
input int              InpX           = 200;            // distanza orizzontale dal bordo (px)
input int              InpY           = 4;               // distanza verticale dal bordo (px)
input int              InpFontSize    = 20;              // dimensione del testo dell'ora (grande = leggibile da lontano)
input int              InpOffsetOre   = 1;               // ITALIA = SERVER + questo (regola CLAUDE.md: server = italiana - 1 ora, in questo periodo dell'anno)
input bool             InpMostraData  = true;             // mostra anche la data server sotto le ore
input color            InpColoreServer= clrWhite;         // colore ora SERVER
input color            InpColoreItalia= clrAqua;          // colore ora ITALIA
input color            InpColoreEtich = C'150,154,160';   // colore delle etichette piccole
input color            InpColoreSfondo= C'16,18,22';      // sfondo del pannello
input color            InpColoreBordo = C'70,74,82';       // bordo del pannello

string P = "ABTG_Orologio_";
int    gAnchor = ANCHOR_LEFT_UPPER;
int    gPanelW = 200;
int    gPanelH = 0;

//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "ABTG Orologio");
   gAnchor = AnchorFromCorner((int)InpAngolo);
   gPanelH = InpMostraData ? 92 : 70;
   BuildPanel();
   Aggiorna();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, P);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   Aggiorna();
  }
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],
                const double &close[],const long &tick_volume[],const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Traduce l'angolo in un anchor coerente, cosi' il pannello resta  |
//| dentro il bordo scelto qualunque sia InpAngolo.                  |
//+------------------------------------------------------------------+
int AnchorFromCorner(int corner)
  {
   if(corner==CORNER_RIGHT_UPPER) return ANCHOR_RIGHT_UPPER;
   if(corner==CORNER_LEFT_LOWER)  return ANCHOR_LEFT_LOWER;
   if(corner==CORNER_RIGHT_LOWER) return ANCHOR_RIGHT_LOWER;
   return ANCHOR_LEFT_UPPER;
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   Rect(P+"bg", InpX, InpY, gPanelW, gPanelH);

   Lbl(P+"lblServer", InpX+10, InpY+8,  "SERVER", InpColoreEtich, 9);
   Lbl(P+"txtServer", InpX+10, InpY+22, "--:--:--", InpColoreServer, InpFontSize);

   int y2 = InpY+22+InpFontSize+10;
   Lbl(P+"lblItalia", InpX+10, y2,    "ITALIA", InpColoreEtich, 9);
   Lbl(P+"txtItalia", InpX+10, y2+14, "--:--:--", InpColoreItalia, InpFontSize);

   if(InpMostraData)
      Lbl(P+"txtData", InpX+10, InpY+gPanelH-16, "", InpColoreEtich, 9);
  }
//+------------------------------------------------------------------+
void Aggiorna()
  {
   datetime srv = TimeTradeServer();
   datetime ita = srv + InpOffsetOre*3600;

   ObjectSetString(0, P+"txtServer", OBJPROP_TEXT, TimeToString(srv, TIME_SECONDS));
   ObjectSetString(0, P+"txtItalia", OBJPROP_TEXT, TimeToString(ita, TIME_SECONDS));
   if(InpMostraData)
      ObjectSetString(0, P+"txtData", OBJPROP_TEXT,
         "server " + TimeToString(srv, TIME_DATE) + "   -   offset +" + (string)InpOffsetOre + "h");

   ChartRedraw();
  }
//+------------------------------------------------------------------+
void Rect(string name,int x,int y,int w,int h)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,(int)InpAngolo);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,InpColoreSfondo);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_COLOR,InpColoreBordo);
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//+------------------------------------------------------------------+
void Lbl(string name,int x,int y,string text,color col,int size)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,(int)InpAngolo);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,gAnchor);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString (0,name,OBJPROP_TEXT,text);
   ObjectSetString (0,name,OBJPROP_FONT,"Arial Bold");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//+------------------------------------------------------------------+
