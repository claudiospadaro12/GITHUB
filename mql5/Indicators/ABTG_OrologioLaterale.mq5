//+------------------------------------------------------------------+
//|                                    ABTG_OrologioLaterale.mq5      |
//|                                                                  |
//|  OROLOGIO GRANDE SUL GRAFICO: ora SERVER e ora ITALIA affiancate, |
//|  ben leggibili, in un angolo del grafico (non nel prezzo).       |
//|                                                                  |
//|  NASCE DALLA REGOLA DI CASA (CLAUDE.md, "FUSO ORARIO BCM"):      |
//|  confondere l'ora server con l'ora italiana e' l'errore che ha   |
//|  gia' fatto scambiare l'orario di un ordine per un ritardo (EA   |
//|  che sembrava in ritardo di un'ora ed era in orario, 06/08).     |
//|  Questo indicatore non elimina l'errore: lo rende visibile a     |
//|  colpo d'occhio, cosi' non serve piu' fare il conto a mente.     |
//|                                                                  |
//|  PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca |
//|  nessun account, non scrive file, non apre rete. Gli unici       |
//|  effetti sono i SUOI oggetti grafici, tutti sotto il prefisso    |
//|  ABTG_Orologio_<id>_ . Si puo' attaccare a QUALUNQUE grafico, su |
//|  QUALUNQUE terminale (compreso il REALE 10105439), senza nessun  |
//|  rischio operativo.                                              |
//|                                                                  |
//|  ATTENZIONE SULL'OFFSET: "ITALIA = SERVER + InpOffsetOre" e' la  |
//|  regola FISSA scritta in CLAUDE.md per QUESTO periodo dell'anno  |
//|  (server = italiana - 1). Se il fuso cambiasse (es. cambio ora   |
//|  legale/solare non allineato fra Italia e broker), si cambia     |
//|  SOLO l'input InpOffsetOre: non serve ricompilare. L'offset in   |
//|  uso e' scritto in chiaro nella riga della data, proprio perche' |
//|  un orologio che mente e' peggio di nessun orologio.             |
//|                                                                  |
//|  v1.01 - corretta la geometria del pannello: in v1.00 l'altezza  |
//|  era un numero fisso (92/70 px) mentre le righe erano piazzate   |
//|  usando InpFontSize come se fossero pixel. OBJPROP_FONTSIZE e'   |
//|  in PUNTI (~1,33 px a 96 DPI): coi valori di default la riga     |
//|  ITALIA usciva dal riquadro e la riga della data ci finiva       |
//|  SOPRA. Corretti anche i due angoli BASSI, dove l'ordine delle   |
//|  righe risultava capovolto.                                      |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG"
#property version   "1.01"
#property strict
#property description "Orologio da grafico: ora SERVER e ora ITALIA affiancate."
#property description "PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca il conto."
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//--- I quattro angoli, coi nomi in italiano. I valori sono le costanti
//    standard ENUM_BASE_CORNER, cosi' InpAngolo si passa direttamente a
//    OBJPROP_CORNER senza tabelle di conversione.
enum ENUM_ABTG_CORNER
  {
   ABTG_ALTO_SX  = CORNER_LEFT_UPPER,
   ABTG_ALTO_DX  = CORNER_RIGHT_UPPER,
   ABTG_BASSO_SX = CORNER_LEFT_LOWER,
   ABTG_BASSO_DX = CORNER_RIGHT_LOWER
  };

input ENUM_ABTG_CORNER InpAngolo      = ABTG_ALTO_SX;    // angolo del grafico
input int              InpX           = 200;             // distanza orizzontale dal bordo (px; 200 scavalca la scritta simbolo/periodo in alto a sinistra)
input int              InpY           = 4;               // distanza verticale dal bordo (px)
input int              InpFontSize    = 20;              // dimensione del testo dell'ora (grande = leggibile da lontano)
input int              InpOffsetOre   = 1;               // ITALIA = SERVER + questo (regola CLAUDE.md: server = italiana - 1 ora, in questo periodo dell'anno)
input bool             InpMostraData  = true;            // mostra anche la data server e l'offset in uso
input int              InpIdIstanza   = 1;               // cambialo se vuoi DUE orologi sullo stesso grafico (altrimenti si cancellano a vicenda)
input color            InpColoreServer= clrWhite;        // colore ora SERVER
input color            InpColoreItalia= clrAqua;         // colore ora ITALIA
input color            InpColoreEtich = C'150,154,160';  // colore delle etichette piccole
input color            InpColoreSfondo= C'16,18,22';     // sfondo del pannello
input color            InpColoreBordo = C'70,74,82';     // bordo del pannello

string P       = "ABTG_Orologio_1_";
int    gAnchor = ANCHOR_LEFT_UPPER;
bool   gBasso  = false;   // true se l'angolo scelto e' uno dei due in basso
int    gFont   = 20;      // InpFontSize, dopo la guardia sui valori assurdi
int    gFh     = 30;      // altezza in PIXEL di una riga "ora grande"
int    gLh     = 14;      // altezza in PIXEL di una riga etichetta (font 9)
int    gPad    = 8;       // margine interno del pannello
int    gPanelW = 180;
int    gPanelH = 130;
//--- posizioni delle righe, misurate dal BORDO SUPERIORE del pannello
int    gYlblS  = 0;
int    gYtxtS  = 0;
int    gYlblI  = 0;
int    gYtxtI  = 0;
int    gYdata  = -1;

//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "ABTG Orologio");

   P = "ABTG_Orologio_" + (string)InpIdIstanza + "_";

   //--- guardia: un font 0 o negativo renderebbe il pannello invisibile
   //    senza nessun errore, cioe' il modo peggiore di rompersi.
   gFont = InpFontSize;
   if(gFont < 6)  gFont = 6;
   if(gFont > 72) gFont = 72;

   gAnchor = AnchorFromCorner((int)InpAngolo);
   gBasso  = CornerInBasso((int)InpAngolo);

   CalcolaLayout();
   BuildPanel();
   Aggiorna();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, P);   // pulizia CHIRURGICA: solo il nostro prefisso
   ChartRedraw();
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   Aggiorna();
  }
//+------------------------------------------------------------------+
//| Nessun calcolo sulle barre: l'indicatore non ha buffer ne' plot,  |
//| ma OnCalculate deve comunque esistere.                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],
                const double &close[],const long &tick_volume[],const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Traduce l'angolo in un anchor coerente, cosi' il pannello resta   |
//| dentro il bordo scelto qualunque sia InpAngolo.                   |
//+------------------------------------------------------------------+
int AnchorFromCorner(int corner)
  {
   if(corner==CORNER_RIGHT_UPPER) return(ANCHOR_RIGHT_UPPER);
   if(corner==CORNER_LEFT_LOWER)  return(ANCHOR_LEFT_LOWER);
   if(corner==CORNER_RIGHT_LOWER) return(ANCHOR_RIGHT_LOWER);
   return(ANCHOR_LEFT_UPPER);
  }
//+------------------------------------------------------------------+
bool CornerInBasso(int corner)
  {
   return(corner==CORNER_LEFT_LOWER || corner==CORNER_RIGHT_LOWER);
  }
//+------------------------------------------------------------------+
//| Altezze e larghezza si RICAVANO dal font, non sono numeri fissi.  |
//| OBJPROP_FONTSIZE e' in PUNTI: a 96 DPI un punto vale ~1,33 px, e  |
//| qui si usa 1,5 (3/2) per comprendere l'interlinea.                |
//+------------------------------------------------------------------+
void CalcolaLayout()
  {
   gFh  = (gFont*3)/2;
   gLh  = 14;
   gPad = 8;

   int y = gPad;
   gYlblS = y;  y += gLh;
   gYtxtS = y;  y += gFh + 6;
   gYlblI = y;  y += gLh;
   gYtxtI = y;  y += gFh;
   if(InpMostraData)
     {
      y += 6;
      gYdata = y;
      y += gLh;
     }
   else
      gYdata = -1;
   gPanelH = y + gPad;

   //--- larghezza: "--:--:--" sono 8 caratteri; in Arial Bold un carattere
   //    occupa circa 0,9 px per punto di dimensione. Piu' i due margini.
   int wOre  = 2*gPad + (8*gFont*9)/10;
   //--- "2026.09.14 srv   +1h" = 20 caratteri a font 9 -> 20*9*0,9 + margini
   int wData = InpMostraData ? 180 : 0;
   gPanelW = (wOre > wData ? wOre : wData);
   if(gPanelW < 140) gPanelW = 140;
  }
//+------------------------------------------------------------------+
//| Converte una y misurata dal bordo SUPERIORE del pannello nella    |
//| YDISTANCE da dare a MT5. Con un angolo in basso l'anchor e'       |
//| *_LOWER e YDISTANCE si misura dal bordo INFERIORE del grafico:    |
//| senza questo ribaltamento le righe si impilerebbero al contrario  |
//| (la data in cima e SERVER in fondo).                              |
//+------------------------------------------------------------------+
int Ygrafico(int yDalTop,int hRiga)
  {
   if(gBasso) return(InpY + gPanelH - yDalTop - hRiga);
   return(InpY + yDalTop);
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   //--- si riparte puliti: se una configurazione precedente aveva la riga
   //    della data e questa no, quella riga resterebbe a schermo congelata.
   ObjectsDeleteAll(0, P);

   Rect(P+"bg", InpX, InpY, gPanelW, gPanelH);

   Lbl(P+"lblServer", InpX+gPad, Ygrafico(gYlblS,gLh), "SERVER",   InpColoreEtich,  9);
   Lbl(P+"txtServer", InpX+gPad, Ygrafico(gYtxtS,gFh), "--:--:--", InpColoreServer, gFont);
   Lbl(P+"lblItalia", InpX+gPad, Ygrafico(gYlblI,gLh), "ITALIA",   InpColoreEtich,  9);
   Lbl(P+"txtItalia", InpX+gPad, Ygrafico(gYtxtI,gFh), "--:--:--", InpColoreItalia, gFont);

   if(InpMostraData)
      Lbl(P+"txtData", InpX+gPad, Ygrafico(gYdata,gLh), "", InpColoreEtich, 9);
  }
//+------------------------------------------------------------------+
//| TimeTradeServer() e NON TimeCurrent(): TimeCurrent() restituisce  |
//| l'ora dell'ULTIMO TICK conosciuto del simbolo, quindi di notte,   |
//| nel weekend o su un simbolo fermo l'orologio si congelerebbe.     |
//| TimeTradeServer() e' l'ora server CALCOLATA e avanza comunque.    |
//+------------------------------------------------------------------+
void Aggiorna()
  {
   datetime srv = TimeTradeServer();
   datetime ita = srv + InpOffsetOre*3600;

   ObjectSetString(0, P+"txtServer", OBJPROP_TEXT, TimeToString(srv, TIME_SECONDS));
   ObjectSetString(0, P+"txtItalia", OBJPROP_TEXT, TimeToString(ita, TIME_SECONDS));

   if(InpMostraData)
     {
      //--- il segno si calcola: "+" + (-1) stamperebbe "+-1h"
      string segno = (InpOffsetOre >= 0 ? "+" : "");
      ObjectSetString(0, P+"txtData", OBJPROP_TEXT,
                      TimeToString(srv, TIME_DATE) + " srv   " + segno + (string)InpOffsetOre + "h");
     }

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
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
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
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,1);
  }
//+------------------------------------------------------------------+
