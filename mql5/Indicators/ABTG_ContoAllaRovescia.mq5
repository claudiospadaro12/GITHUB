//+------------------------------------------------------------------+
//|                                 ABTG_ContoAllaRovescia.mq5        |
//|                                                                  |
//|  CONTO ALLA ROVESCIA MULTI-TIMEFRAME: quanto manca alla chiusura |
//|  della candela in corso, su piu' timeframe insieme, in un        |
//|  pannello sul grafico.                                           |
//|                                                                  |
//|  SI PUO' SPOSTARE: tieni il tasto sinistro sul pannello e         |
//|  trascinalo dove vuoi. La posizione si ricorda (GlobalVariable    |
//|  del terminale) anche se stacchi e riattacchi l'indicatore o      |
//|  riavvii MT5. Metti InpBloccato=true per fissarla e non           |
//|  spostarla per sbaglio.                                          |
//|                                                                  |
//|  SI PERSONALIZZA: i timeframe da mostrare (InpTimeframes), i      |
//|  colori, la dimensione del testo, la soglia di avviso (quando     |
//|  manca poco la riga cambia colore), l'angolo di riferimento.      |
//|                                                                  |
//|  PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca |
//|  nessun account, non scrive file, non apre rete. Gli unici        |
//|  effetti sono i SUOI oggetti grafici e due GlobalVariable per     |
//|  ricordare la posizione dopo un trascinamento.                    |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG"
#property version   "1.00"
#property strict
#property description "Conto alla rovescia multi-timeframe: tempo alla chiusura della candela."
#property description "Si sposta col mouse (posizione ricordata), si personalizza dagli input."
#property description "PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca il conto."
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

input string           InpTimeframes   = "M1,M5,M15,M30,H1,H4,D1";  // timeframe da mostrare (separati da virgola)
input ENUM_ABTG_CORNER InpAngolo       = ABTG_ALTO_SX;   // angolo di riferimento del grafico
input int              InpX            = 200;             // distanza orizzontale dal bordo (px) -- solo alla PRIMA apertura, poi si sposta col mouse
input int              InpY            = 4;               // distanza verticale dal bordo (px) -- solo alla PRIMA apertura
input int              InpFontSize     = 16;               // dimensione del testo del conto alla rovescia
input int              InpSogliaAvvisoPct = 10;            // sotto questa % del periodo restante, la riga cambia colore
input bool              InpBloccato    = false;            // true = il pannello NON si sposta piu' col mouse
input int              InpIdIstanza    = 1;                // cambialo se vuoi PIU' pannelli sullo stesso grafico
input string            InpTitolo      = "CONTO ALLA ROVESCIA"; // titolo mostrato in testa al pannello ("" per non mostrarlo)
input color             InpColoreNormale = clrWhite;        // colore del tempo quando non manca poco
input color             InpColoreAvviso  = clrOrange;       // colore del tempo sotto la soglia di avviso
input color             InpColoreEtich   = C'150,154,160';  // colore dei nomi dei timeframe e del titolo
input color             InpColoreSfondo  = C'16,18,22';     // sfondo del pannello
input color             InpColoreBordo   = C'70,74,82';      // bordo del pannello

//--- righe attive, riempite in OnInit da InpTimeframes
ENUM_TIMEFRAMES gTF[];
string          gEtichetta[];
int             gNRighe = 0;

string P        = "ABTG_Rovescia_1_";
int    gAnchor  = ANCHOR_LEFT_UPPER;
bool   gBasso   = false;
int    gFont    = 16;
int    gRigaH   = 24;
int    gLblH    = 14;
int    gPad     = 8;
int    gTitH    = 0;
int    gPanelW  = 160;
int    gPanelH  = 100;
int    gPosX    = 200;
int    gPosY    = 4;
string gVarX, gVarY;

//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "ABTG Conto alla rovescia");

   P     = "ABTG_Rovescia_" + (string)InpIdIstanza + "_";
   gVarX = "ABTG_Rovescia_X_" + (string)InpIdIstanza;
   gVarY = "ABTG_Rovescia_Y_" + (string)InpIdIstanza;

   gFont = InpFontSize;
   if(gFont < 6)  gFont = 6;
   if(gFont > 48) gFont = 48;

   gAnchor = AnchorFromCorner((int)InpAngolo);
   gBasso  = CornerInBasso((int)InpAngolo);

   //--- posizione: riparte da dove l'avevi lasciata (GlobalVariable), se esiste
   gPosX = InpX;
   gPosY = InpY;
   if(GlobalVariableCheck(gVarX) && GlobalVariableCheck(gVarY))
     {
      gPosX = (int)GlobalVariableGet(gVarX);
      gPosY = (int)GlobalVariableGet(gVarY);
     }

   ParseTimeframes();
   if(gNRighe == 0)
     {
      Print("[ABTG_ContoAllaRovescia] InpTimeframes non contiene nessun timeframe riconosciuto: '", InpTimeframes, "' -- niente da mostrare.");
      return(INIT_SUCCEEDED);
     }

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
//| Il pannello si sposta trascinando lo sfondo (unico oggetto        |
//| SELECTABLE). Alla fine del trascinamento MT5 aggiorna da solo     |
//| XDISTANCE/YDISTANCE dello sfondo: qui si legge la nuova posizione |
//| e si riposizionano TUTTE le altre etichette di conseguenza,       |
//| altrimenti si sposterebbe solo il rettangolo e il testo resterebbe|
//| indietro. La posizione nuova si salva per la prossima apertura.   |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id != CHARTEVENT_OBJECT_DRAG) return;
   if(sparam != P+"bg") return;

   gPosX = (int)ObjectGetInteger(0, P+"bg", OBJPROP_XDISTANCE);
   gPosY = (int)ObjectGetInteger(0, P+"bg", OBJPROP_YDISTANCE);

   GlobalVariableSet(gVarX, gPosX);
   GlobalVariableSet(gVarY, gPosY);

   RiposizionaEtichette();
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Spezza "M1,M5,H1" (spazi ammessi) nei timeframe corrispondenti.   |
//| Un pezzo non riconosciuto viene SEGNALATO e saltato, non inventato|
//| come M1 di default -- un errore di battitura deve essere visibile.|
//+------------------------------------------------------------------+
void ParseTimeframes()
  {
   string pezzi[];
   int n = StringSplit(InpTimeframes, ',', pezzi);
   ArrayResize(gTF, 0);
   ArrayResize(gEtichetta, 0);
   gNRighe = 0;
   for(int i=0; i<n; i++)
     {
      string s = pezzi[i];
      StringTrimLeft(s);
      StringTrimRight(s);
      if(StringLen(s) == 0) continue;
      string sUp = s;
      StringToUpper(sUp);
      ENUM_TIMEFRAMES tf;
      if(!TFDaCodice(sUp, tf))
        {
         Print("[ABTG_ContoAllaRovescia] timeframe non riconosciuto, saltato: '", s, "'");
         continue;
        }
      if(gNRighe >= 20) { Print("[ABTG_ContoAllaRovescia] limite di 20 righe raggiunto, il resto e' ignorato."); break; }
      ArrayResize(gTF, gNRighe+1);
      ArrayResize(gEtichetta, gNRighe+1);
      gTF[gNRighe]        = tf;
      gEtichetta[gNRighe] = sUp;
      gNRighe++;
     }
  }
//+------------------------------------------------------------------+
bool TFDaCodice(string s, ENUM_TIMEFRAMES &tf)
  {
   if(s=="M1")  { tf=PERIOD_M1;  return true; }
   if(s=="M2")  { tf=PERIOD_M2;  return true; }
   if(s=="M3")  { tf=PERIOD_M3;  return true; }
   if(s=="M4")  { tf=PERIOD_M4;  return true; }
   if(s=="M5")  { tf=PERIOD_M5;  return true; }
   if(s=="M6")  { tf=PERIOD_M6;  return true; }
   if(s=="M10") { tf=PERIOD_M10; return true; }
   if(s=="M12") { tf=PERIOD_M12; return true; }
   if(s=="M15") { tf=PERIOD_M15; return true; }
   if(s=="M20") { tf=PERIOD_M20; return true; }
   if(s=="M30") { tf=PERIOD_M30; return true; }
   if(s=="H1")  { tf=PERIOD_H1;  return true; }
   if(s=="H2")  { tf=PERIOD_H2;  return true; }
   if(s=="H3")  { tf=PERIOD_H3;  return true; }
   if(s=="H4")  { tf=PERIOD_H4;  return true; }
   if(s=="H6")  { tf=PERIOD_H6;  return true; }
   if(s=="H8")  { tf=PERIOD_H8;  return true; }
   if(s=="H12") { tf=PERIOD_H12; return true; }
   if(s=="D1")  { tf=PERIOD_D1;  return true; }
   if(s=="W1")  { tf=PERIOD_W1;  return true; }
   if(s=="MN1" || s=="MN") { tf=PERIOD_MN1; return true; }
   return false;
  }
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
//| Altezze e larghezza RICAVATE dal font (in PUNTI), non numeri      |
//| fissi -- lezione della classe 326 (OBJPROP_FONTSIZE e' in punti,  |
//| il pannello e' in pixel: un numero fisso si rompe cambiando font).|
//+------------------------------------------------------------------+
void CalcolaLayout()
  {
   gRigaH = (gFont*3)/2 + 4;
   gLblH  = 14;
   gPad   = 8;
   gTitH  = (StringLen(InpTitolo) > 0) ? (gLblH + 6) : 0;

   gPanelH = gPad + gTitH + gNRighe*gRigaH + gPad;

   //--- larghezza: colonna timeframe (max 3 caratteri, "MN1"/"H12") +
   //    colonna tempo ("168:00:00" = 9 caratteri nel caso piu' lungo,
   //    settimanale). ~0,9 px per punto e' il margine gia' verificato
   //    sull'orologio laterale.
   int wTF     = 3*gFont*9/10 + 14;
   int wTempo  = 9*gFont*9/10;
   gPanelW = gPad + wTF + wTempo + gPad;
   int wTitolo = gPad + (int)StringLen(InpTitolo)*9*9/10 + gPad;
   if(wTitolo > gPanelW) gPanelW = wTitolo;
   if(gPanelW < 150) gPanelW = 150;
  }
//+------------------------------------------------------------------+
int Ygrafico(int yDalTop,int hRiga)
  {
   if(gBasso) return(gPosY + gPanelH - yDalTop - hRiga);
   return(gPosY + yDalTop);
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   ObjectsDeleteAll(0, P);

   Rect(P+"bg", gPosX, gPosY, gPanelW, gPanelH, !InpBloccato);

   int y = gPad;
   if(gTitH > 0)
     {
      Lbl(P+"tit", gPosX+gPad, Ygrafico(y,gLblH), InpTitolo, InpColoreEtich, 9);
      y += gTitH;
     }
   for(int i=0; i<gNRighe; i++)
     {
      Lbl(P+"tf_"+(string)i,  gPosX+gPad,          Ygrafico(y,gRigaH), gEtichetta[i], InpColoreEtich, gFont);
      Lbl(P+"tm_"+(string)i,  gPosX+gPanelW-gPad,   Ygrafico(y,gRigaH), "--:--",       InpColoreNormale, gFont);
      ObjectSetInteger(0, P+"tm_"+(string)i, OBJPROP_ANCHOR, DestraDaAngolo());
      y += gRigaH;
     }
  }
//+------------------------------------------------------------------+
//| La colonna del tempo e' allineata a destra del pannello: serve un |
//| anchor "a destra" indipendente dall'angolo (sopra/sotto) scelto.  |
//+------------------------------------------------------------------+
int DestraDaAngolo()
  {
   return(gBasso ? ANCHOR_RIGHT_LOWER : ANCHOR_RIGHT_UPPER);
  }
//+------------------------------------------------------------------+
//| Dopo un trascinamento: stessa geometria di BuildPanel, ma senza   |
//| ri-creare gli oggetti (solo XDISTANCE/YDISTANCE) -- piu' leggero  |
//| e nessun lampeggio mentre si sposta il pannello col mouse.        |
//+------------------------------------------------------------------+
void RiposizionaEtichette()
  {
   ObjectSetInteger(0, P+"bg", OBJPROP_XSIZE, gPanelW);
   ObjectSetInteger(0, P+"bg", OBJPROP_YSIZE, gPanelH);

   int y = gPad;
   if(gTitH > 0)
     {
      ObjectSetInteger(0, P+"tit", OBJPROP_XDISTANCE, gPosX+gPad);
      ObjectSetInteger(0, P+"tit", OBJPROP_YDISTANCE, Ygrafico(y,gLblH));
      y += gTitH;
     }
   for(int i=0; i<gNRighe; i++)
     {
      ObjectSetInteger(0, P+"tf_"+(string)i, OBJPROP_XDISTANCE, gPosX+gPad);
      ObjectSetInteger(0, P+"tf_"+(string)i, OBJPROP_YDISTANCE, Ygrafico(y,gRigaH));
      ObjectSetInteger(0, P+"tm_"+(string)i, OBJPROP_XDISTANCE, gPosX+gPanelW-gPad);
      ObjectSetInteger(0, P+"tm_"+(string)i, OBJPROP_YDISTANCE, Ygrafico(y,gRigaH));
      y += gRigaH;
     }
  }
//+------------------------------------------------------------------+
//| TimeTradeServer(), non TimeCurrent(): TimeCurrent() e' l'ora      |
//| dell'ultimo tick, quindi si congelerebbe di notte/nel weekend/su  |
//| un simbolo fermo. TimeTradeServer() avanza sempre (stessa lezione |
//| di ABTG_OrologioLaterale).                                        |
//+------------------------------------------------------------------+
void Aggiorna()
  {
   datetime ora = TimeTradeServer();
   for(int i=0; i<gNRighe; i++)
     {
      datetime apertura = iTime(_Symbol, gTF[i], 0);
      string   nome      = P+"tm_"+(string)i;
      if(apertura == 0)
        {
         ObjectSetString(0, nome, OBJPROP_TEXT, "--:--");
         ObjectSetInteger(0, nome, OBJPROP_COLOR, InpColoreEtich);
         continue;
        }
      int    durata  = PeriodSeconds(gTF[i]);
      long   residuo = (long)(apertura + durata - ora);
      if(residuo < 0) residuo = 0;
      double pctResiduo = (durata > 0) ? (100.0*residuo/durata) : 100.0;

      ObjectSetString(0, nome, OBJPROP_TEXT, FormattaResiduo(residuo));
      ObjectSetInteger(0, nome, OBJPROP_COLOR,
         (pctResiduo <= InpSogliaAvvisoPct) ? InpColoreAvviso : InpColoreNormale);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
string FormattaResiduo(long secondi)
  {
   long h = secondi/3600;
   long m = (secondi%3600)/60;
   long s = secondi%60;
   if(h > 0) return StringFormat("%02d:%02d:%02d", h, m, s);
   return StringFormat("%02d:%02d", m, s);
  }
//+------------------------------------------------------------------+
void Rect(string name,int x,int y,int w,int h,bool selezionabile)
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
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,selezionabile);
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
