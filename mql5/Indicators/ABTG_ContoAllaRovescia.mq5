//+------------------------------------------------------------------+
//|                                 ABTG_ContoAllaRovescia.mq5        |
//|                                                                  |
//|  CONTO ALLA ROVESCIA MULTI-TIMEFRAME: quanto manca alla chiusura |
//|  della candela in corso, su piu' timeframe insieme, in un        |
//|  pannello sul grafico.                                           |
//|                                                                  |
//|  SI PUO' SPOSTARE: seleziona il pannello e trascinalo dove vuoi.  |
//|  La posizione si ricorda (GlobalVariable del terminale) anche se  |
//|  stacchi e riattacchi l'indicatore o riavvii MT5. Metti           |
//|  InpBloccato=true per fissarla e non spostarla per sbaglio.       |
//|  NOTA PRATICA: in MT5 un oggetto si trascina solo DOPO averlo     |
//|  selezionato. Se il primo clic non basta, o fai doppio clic sul   |
//|  pannello, oppure accendi Strumenti > Opzioni > Grafici >         |
//|  "Seleziona oggetto con un solo clic". Finche' e' trascinabile il |
//|  solo sfondo compare anche nella lista oggetti (Ctrl+B): e' la    |
//|  via di recupero se il pannello finisce in un angolo scomodo.     |
//|                                                                  |
//|  SI PERSONALIZZA: i timeframe da mostrare (InpTimeframes), i      |
//|  colori, la dimensione del testo, la soglia di avviso (quando     |
//|  manca poco la riga cambia colore), l'angolo di riferimento.      |
//|                                                                  |
//|  PURO DISPLAY: non legge posizioni, non piazza ordini, non tocca |
//|  nessun account, non scrive file, non apre rete. Gli unici        |
//|  effetti sono i SUOI oggetti grafici e due GlobalVariable per     |
//|  ricordare la posizione dopo un trascinamento.                    |
//|                                                                  |
//|  v1.01 - correzioni dal controllo preventivo (14/09/2026):        |
//|  (1) le due COLONNE erano calcolate come se X crescesse sempre    |
//|      verso destra: con InpAngolo su un angolo DESTRO la colonna   |
//|      dei tempi finiva FUORI dal pannello (X, sugli angoli destri, |
//|      si misura dal bordo destro e cresce verso sinistra). Ora la  |
//|      X passa da Xgrafico(), gemella di Ygrafico(), e gli anchor   |
//|      sono espliciti (nomi TF a sinistra, tempi a destra).         |
//|  (2) la geometria era scritta DUE volte (BuildPanel e             |
//|      riposizionamento dopo il trascinamento): due copie della     |
//|      stessa aritmetica sono una divergenza che aspetta. Ora c'e'  |
//|      una sola funzione Disponi(crea), usata da tutte e due.       |
//|  (3) FormattaResiduo passava dei long a "%02d": in casa il long   |
//|      si stampa con %I64d (vedi ABTG_Guardian/ABTG_Canarino), e    |
//|      un formato sbagliato stampa numeri sbagliati. Ora i tre      |
//|      campi sono int, che e' cio' che "%02d" si aspetta.           |
//|  (4) su MN1 il residuo usava PeriodSeconds(PERIOD_MN1), che vale  |
//|      30 giorni FISSI: a gennaio avrebbe mentito di un giorno.     |
//|      Ora la fine del mese si calcola col calendario.              |
//|  (5) posizione ripresa dalle GlobalVariable: ora e' tenuta DENTRO |
//|      il grafico (una posizione salvata su un monitor grande e     |
//|      riaperta su una finestra piccola dava un pannello invisibile |
//|      e non piu' afferrabile: rompersi senza errori e' il modo     |
//|      peggiore di rompersi), e la memoria e' per ANGOLO, cosi'     |
//|      cambiare InpAngolo non fa saltare il pannello altrove.       |
//|  (6) TFDaCodice non usa piu' un parametro enum per riferimento    |
//|      (nessun precedente gia' compilato nel repo): torna un int,   |
//|      -1 se il codice non e' riconosciuto.                         |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG"
#property version   "1.01"
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
bool   gBasso   = false;
bool   gDestra  = false;
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
   //--- la posizione si ricorda PER ANGOLO: una X salvata partendo da
   //    sinistra non vuol dire niente se poi l'angolo scelto e' a destra.
   gVarX = "ABTG_Rovescia_X_" + (string)InpIdIstanza + "_" + (string)((int)InpAngolo);
   gVarY = "ABTG_Rovescia_Y_" + (string)InpIdIstanza + "_" + (string)((int)InpAngolo);

   gFont = InpFontSize;
   if(gFont < 6)  gFont = 6;
   if(gFont > 48) gFont = 48;

   gBasso  = CornerInBasso((int)InpAngolo);
   gDestra = CornerADestra((int)InpAngolo);

   ParseTimeframes();
   if(gNRighe == 0)
     {
      Print("[ABTG_ContoAllaRovescia] InpTimeframes non contiene nessun timeframe riconosciuto: '", InpTimeframes, "' -- niente da mostrare.");
      return(INIT_SUCCEEDED);
     }

   CalcolaLayout();

   //--- posizione: riparte da dove l'avevi lasciata (GlobalVariable), se
   //    esiste; altrimenti dagli input. La guardia subito dopo la tiene
   //    dentro il grafico.
   gPosX = InpX;
   gPosY = InpY;
   if(GlobalVariableCheck(gVarX) && GlobalVariableCheck(gVarY))
     {
      gPosX = (int)GlobalVariableGet(gVarX);
      gPosY = (int)GlobalVariableGet(gVarY);
     }
   TieniDentroIlGrafico();

   BuildPanel();
   Aggiorna();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Una posizione salvata puo' arrivare da una finestra piu' grande   |
//| (altro monitor, grafico a tutto schermo): senza questa guardia il |
//| pannello nascerebbe fuori dallo schermo, invisibile e non piu'    |
//| afferrabile col mouse. Si lascia sempre un lembo di 40 px dentro. |
//+------------------------------------------------------------------+
void TieniDentroIlGrafico()
  {
   int larg = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
   int alt  = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);

   if(gPosX < 0) gPosX = 0;
   if(gPosY < 0) gPosY = 0;
   if(larg > 40 && gPosX > larg - 40) gPosX = larg - 40;
   if(alt  > 40 && gPosY > alt  - 40) gPosY = alt  - 40;
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
   if(InpBloccato) return;
   if(gNRighe == 0) return;
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
      int codice = TFDaCodice(sUp);
      if(codice < 0)
        {
         Print("[ABTG_ContoAllaRovescia] timeframe non riconosciuto, saltato: '", s, "'");
         continue;
        }
      if(gNRighe >= 20) { Print("[ABTG_ContoAllaRovescia] limite di 20 righe raggiunto, il resto e' ignorato."); break; }
      ArrayResize(gTF, gNRighe+1);
      ArrayResize(gEtichetta, gNRighe+1);
      gTF[gNRighe]        = (ENUM_TIMEFRAMES)codice;
      gEtichetta[gNRighe] = sUp;
      gNRighe++;
     }
  }
//+------------------------------------------------------------------+
//| Torna il codice del timeframe, oppure -1 se non e' riconosciuto.  |
//+------------------------------------------------------------------+
int TFDaCodice(string s)
  {
   if(s=="M1")  return((int)PERIOD_M1);
   if(s=="M2")  return((int)PERIOD_M2);
   if(s=="M3")  return((int)PERIOD_M3);
   if(s=="M4")  return((int)PERIOD_M4);
   if(s=="M5")  return((int)PERIOD_M5);
   if(s=="M6")  return((int)PERIOD_M6);
   if(s=="M10") return((int)PERIOD_M10);
   if(s=="M12") return((int)PERIOD_M12);
   if(s=="M15") return((int)PERIOD_M15);
   if(s=="M20") return((int)PERIOD_M20);
   if(s=="M30") return((int)PERIOD_M30);
   if(s=="H1")  return((int)PERIOD_H1);
   if(s=="H2")  return((int)PERIOD_H2);
   if(s=="H3")  return((int)PERIOD_H3);
   if(s=="H4")  return((int)PERIOD_H4);
   if(s=="H6")  return((int)PERIOD_H6);
   if(s=="H8")  return((int)PERIOD_H8);
   if(s=="H12") return((int)PERIOD_H12);
   if(s=="D1")  return((int)PERIOD_D1);
   if(s=="W1")  return((int)PERIOD_W1);
   if(s=="MN1" || s=="MN") return((int)PERIOD_MN1);
   return(-1);
  }
//+------------------------------------------------------------------+
bool CornerInBasso(int corner)
  {
   return(corner==CORNER_LEFT_LOWER || corner==CORNER_RIGHT_LOWER);
  }
//+------------------------------------------------------------------+
bool CornerADestra(int corner)
  {
   return(corner==CORNER_RIGHT_UPPER || corner==CORNER_RIGHT_LOWER);
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
   //    colonna tempo. Il caso piu' lungo NON e' il settimanale ma il
   //    mensile: 31 giorni = 744 ore -> "744:00:00", 9 caratteri (il
   //    settimanale si ferma a "168:00:00", sempre 9). ~0,9 px per punto
   //    e' il margine gia' verificato sull'orologio laterale.
   int wTF     = 3*gFont*9/10 + 14;
   int wTempo  = 9*gFont*9/10;
   gPanelW = gPad + wTF + wTempo + gPad;
   int wTitolo = gPad + (int)StringLen(InpTitolo)*9*9/10 + gPad;
   if(wTitolo > gPanelW) gPanelW = wTitolo;
   if(gPanelW < 150) gPanelW = 150;
  }
//+------------------------------------------------------------------+
//| Converte una y misurata dal bordo SUPERIORE del pannello nella    |
//| YDISTANCE da dare a MT5 (sugli angoli in basso si misura dal      |
//| bordo inferiore, quindi le righe vanno ribaltate).                |
//+------------------------------------------------------------------+
int Ygrafico(int yDalTop,int hRiga)
  {
   if(gBasso) return(gPosY + gPanelH - yDalTop - hRiga);
   return(gPosY + yDalTop);
  }
//+------------------------------------------------------------------+
//| Gemella di Ygrafico per la X: converte una x misurata dal bordo   |
//| SINISTRO del pannello nella XDISTANCE da dare a MT5. Sugli angoli |
//| DESTRI la X si misura dal bordo destro del grafico e cresce verso |
//| sinistra: senza questo ribaltamento le due colonne si invertono e |
//| quella dei tempi finisce FUORI dal pannello (difetto della v1.00).|
//+------------------------------------------------------------------+
int Xgrafico(int xDaSinistra)
  {
   if(gDestra) return(gPosX + gPanelW - xDaSinistra);
   return(gPosX + xDaSinistra);
  }
//+------------------------------------------------------------------+
//| Gli anchor del TESTO non dipendono dall'angolo ma dalla colonna:  |
//| i nomi dei timeframe sono allineati a sinistra, i tempi a destra. |
//| Dell'angolo resta solo il sopra/sotto.                            |
//+------------------------------------------------------------------+
int SinistraDaAngolo()
  {
   return(gBasso ? ANCHOR_LEFT_LOWER : ANCHOR_LEFT_UPPER);
  }
//+------------------------------------------------------------------+
int DestraDaAngolo()
  {
   return(gBasso ? ANCHOR_RIGHT_LOWER : ANCHOR_RIGHT_UPPER);
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   ObjectsDeleteAll(0, P);
   Disponi(true);
  }
//+------------------------------------------------------------------+
//| Dopo un trascinamento: stessa geometria, senza ri-creare gli      |
//| oggetti (solo XDISTANCE/YDISTANCE) -- piu' leggero e senza        |
//| lampeggio. E' LA STESSA funzione di BuildPanel apposta: due copie |
//| della stessa aritmetica sono una divergenza che aspetta soltanto. |
//+------------------------------------------------------------------+
void RiposizionaEtichette()
  {
   Disponi(false);
  }
//+------------------------------------------------------------------+
//| UNICO punto in cui si decide DOVE sta ogni cosa.                  |
//| crea=true  -> crea gli oggetti e ci scrive dentro il segnaposto;  |
//| crea=false -> li sposta soltanto (il testo del conto alla rovescia|
//|               NON va toccato, altrimenti si azzererebbe ad ogni   |
//|               trascinamento).                                     |
//+------------------------------------------------------------------+
void Disponi(bool crea)
  {
   if(crea)
      Rect(P+"bg", gPosX, gPosY, gPanelW, gPanelH, !InpBloccato);
   else
     {
      ObjectSetInteger(0, P+"bg", OBJPROP_XSIZE, gPanelW);
      ObjectSetInteger(0, P+"bg", OBJPROP_YSIZE, gPanelH);
     }

   int y = gPad;
   if(gTitH > 0)
     {
      Posa(P+"tit", crea, Xgrafico(gPad), Ygrafico(y,gLblH), InpTitolo, InpColoreEtich, 9, SinistraDaAngolo());
      y += gTitH;
     }
   for(int i=0; i<gNRighe; i++)
     {
      Posa(P+"tf_"+(string)i, crea, Xgrafico(gPad),          Ygrafico(y,gRigaH), gEtichetta[i], InpColoreEtich,   gFont, SinistraDaAngolo());
      Posa(P+"tm_"+(string)i, crea, Xgrafico(gPanelW-gPad),  Ygrafico(y,gRigaH), "--:--",       InpColoreNormale, gFont, DestraDaAngolo());
      y += gRigaH;
     }
  }
//+------------------------------------------------------------------+
void Posa(string name,bool crea,int x,int y,string text,color col,int size,int anchor)
  {
   if(crea)
     {
      Lbl(name, x, y, text, col, size, anchor);
      return;
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
  }
//+------------------------------------------------------------------+
//| TimeTradeServer(), non TimeCurrent(): TimeCurrent() e' l'ora      |
//| dell'ultimo tick, quindi si congelerebbe di notte/nel weekend/su  |
//| un simbolo fermo. TimeTradeServer() avanza sempre (stessa lezione |
//| di ABTG_OrologioLaterale). Tutti i tempi qui sono ORA SERVER: la  |
//| candela chiude in ora server, non in ora italiana.                |
//+------------------------------------------------------------------+
void Aggiorna()
  {
   datetime ora = TimeTradeServer();
   for(int i=0; i<gNRighe; i++)
     {
      datetime apertura = iTime(_Symbol, gTF[i], 0);
      string   nome     = P+"tm_"+(string)i;
      //--- iTime()==0 = storico di QUEL timeframe non ancora pronto (il
      //    terminale lo sta scaricando): si dichiara, non si inventa.
      //    Al prossimo secondo si riprova da solo.
      if(apertura == 0)
        {
         ObjectSetString(0, nome, OBJPROP_TEXT, "--:--");
         ObjectSetInteger(0, nome, OBJPROP_COLOR, InpColoreEtich);
         continue;
        }
      datetime fine    = FineCandela(gTF[i], apertura);
      long     durata  = (long)fine - (long)apertura;
      long     residuo = (long)fine - (long)ora;
      if(residuo < 0)      residuo = 0;        // candela gia' chiusa, tick non ancora arrivato
      if(residuo > durata) residuo = durata;   // guardia: mai piu' del periodo intero
      double pctResiduo = (durata > 0) ? (100.0*residuo/durata) : 100.0;

      ObjectSetString(0, nome, OBJPROP_TEXT, FormattaResiduo(residuo));
      //--- avviso quando manca POCO: meno tempo resta, piu' bassa e' la
      //    percentuale, quindi il confronto e' <=.
      ObjectSetInteger(0, nome, OBJPROP_COLOR,
         (pctResiduo <= InpSogliaAvvisoPct) ? InpColoreAvviso : InpColoreNormale);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Fine della candela in corso. Per tutti i timeframe e' apertura +  |
//| durata del periodo; per il MENSILE no: PeriodSeconds(PERIOD_MN1)  |
//| vale 30 giorni FISSI, quindi a gennaio (31) direbbe una bugia di  |
//| un giorno intero. Per MN1 si usa il calendario: inizio del mese   |
//| successivo, ora server.                                           |
//+------------------------------------------------------------------+
datetime FineCandela(ENUM_TIMEFRAMES tf,datetime apertura)
  {
   if(tf != PERIOD_MN1)
      return((datetime)((long)apertura + (long)PeriodSeconds(tf)));

   MqlDateTime t;
   TimeToStruct(apertura, t);
   t.mon++;
   if(t.mon > 12) { t.mon = 1; t.year++; }
   t.day  = 1;
   t.hour = 0;
   t.min  = 0;
   t.sec  = 0;
   return(StructToTime(t));
  }
//+------------------------------------------------------------------+
//| Formato H:MM:SS quando manca piu' di un'ora, MM:SS sotto l'ora.   |
//| I tre campi sono INT apposta: "%02d" vuole un int, e in casa il   |
//| long si stampa con "%I64d" (ABTG_Guardian, ABTG_CanarinoGuardian).|
//| Il massimo possibile e' il mensile, 744 ore -> 9 caratteri, che e'|
//| esattamente la larghezza prevista in CalcolaLayout.               |
//+------------------------------------------------------------------+
string FormattaResiduo(long secondi)
  {
   int h = (int)(secondi/3600);
   int m = (int)((secondi%3600)/60);
   int s = (int)(secondi%60);
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
   //--- se e' trascinabile lo si lascia NELLA lista oggetti (Ctrl+B):
   //    e' la via di recupero se col mouse non si riesce ad afferrarlo.
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,!selezionabile);
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
  }
//+------------------------------------------------------------------+
void Lbl(string name,int x,int y,string text,color col,int size,int anchor)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,(int)InpAngolo);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor);
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
