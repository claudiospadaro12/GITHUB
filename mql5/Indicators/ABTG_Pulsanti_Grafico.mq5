//+------------------------------------------------------------------+
//|                                       ABTG_Pulsanti_Grafico.mq5  |
//|  CRONOLOGIA                                                       |
//|  1.01 (06/10/2026) tasto SUPERTREND a TRE livelli + EMA 200 di    |
//|   altri TF come riga orizzontale. Richiesta di Claudio: "mettimi  |
//|   il super trend a tre livelli ... e aggiungi insieme ai livelli  |
//|   la ema 200 ... linea tratteggiata rossa con la scritta di fianco|
//|   ema200 h1 x esempio se mi trovo in h4. in h4 lasci l'ema cosi'  |
//|   com'e'. negli altri tf la metti orizzontale rossa tratteggiata".|
//|   - TRE Supertrend 2,5 / 3,0 / 3,5 (i "tre livelli" dei vocali    |
//|     della collega, report/NATCLA_ANALISI_AUDIO_2026-10-06.md R2). |
//|     Periodo ATR: NON detto nei vocali -> lo STESSO di prima       |
//|     (InpStPeriodo = 10) per tutti e tre. Stessa SW_STCore chiamata|
//|     con moltiplicatori diversi (funzione NON toccata). Il 3,0 e'  |
//|     IDENTICO alla v1.00 (stessi buffer, colori, spessore); 2,5    |
//|     sottile e chiaro, 3,5 spesso e scuro. Scritta "ST 2.5" ecc. al|
//|     bordo destro, all'altezza della linea, come quelle dei LIVELLI.|
//|   - EMA 200 di un ALTRO TF: riga ORIZZONTALE ROSSA TRATTEGGIATA al |
//|     suo valore attuale, scritta "EMA200 H1" (+ prezzo). Sul TF     |
//|     uguale a quello dell'EMA la riga NON c'e': resta la EMA 200    |
//|     nativa del tasto EMA 200, invariata. Default H1 e H4 accesi    |
//|     (scelta NOSTRA: i vocali dicono "dall'H1 o H4 in su").         |
//|   - INTERPRETAZIONE INCERTA, quindi a input: la riga EMA compare   |
//|     col tasto SUPERTREND (default) o col tasto LIVELLI o con uno  |
//|     dei due (InpEmaHtfTasto): "insieme ai livelli" puo' voler dire|
//|     i livelli del Supertrend o il tasto LIVELLI. Da chiedere.     |
//|   - Input nuovi: InpSTMult1/InpSTMult3 (il 3,0 resta InpStMolt,   |
//|     nome invariato per non perdere i parametri salvati),          |
//|     InpStMostra1/3, InpColSt1Su/Giu, InpColSt3Su/Giu, InpStSpess1/ |
//|     2/3, InpStScritte, InpStScrittePrezzo, InpEmaHtfTasto,        |
//|     InpEmaHtfM15/M30/H1/H4/D1/W1, InpEmaHtfBarra, InpColEmaHtf,    |
//|     InpEmaHtfPrezzo. Buffer 34 -> 46, plot 10 -> 14.              |
//|  1.00 prima versione.                                            |
//|                                                                   |
//|  INDICATORE DI SOLA VISIONE (NON e' un EA): non apre, non         |
//|  modifica e non chiude ordini; nessuna rete; nessun file. Un solo |
//|  grafico, tutti i TF, tutti i simboli. Legge il SALDO del conto   |
//|  (sola lettura) SOLO per i lotti indicativi di ORDINE CONSIGLIATO.|
//|                                                                   |
//|  OBIETTIVO: GRAFICO PULITO. In alto a sinistra UNA barra sottile  |
//|  di rettangolini colorati; un clic accende/spegne SUBITO quello   |
//|  che c'e' scritto (nessuna ricarica dell'indicatore, nessun       |
//|  cambio di simbolo/TF). All'avvio e' TUTTO SPENTO e l'indicatore  |
//|  non disegna niente (input InpDefaultAcceso*).                    |
//|                                                                   |
//|   EMA 200 .......... EMA 200 ROSSA spessa (3)                     |
//|   EMA 50 ........... EMA 50 BIANCA (2)                            |
//|   EMA 9 | EMA 21 ... UN tasto diviso in due: 9 ROSA, 21 GIALLA (1)|
//|   BOLLINGER ........ bande 20 / 2 (media tratteggiata + alta/bassa)|
//|   SUPERTREND ....... TRE livelli ATR 10 x 2,5 / 3,0 / 3,5: VERDE   |
//|                      sotto (su), ROSSO sopra; scritta ST 2.5 ecc.  |
//|                      + riga EMA200 H1/H4 (rossa tratteggiata)      |
//|   LIVELLI .......... livelli NOMINATI per origine, scritta in      |
//|                      italiano + prezzo (es. MAX GIORNO PRECEDENTE  |
//|                      24.998,25); elenco e regole negli input       |
//|   HEIKIN ASHI ...... candele HA, le native nascoste (clrNONE) e    |
//|                      RIPRISTINATE allo spegnimento e a ogni uscita |
//|   ORDINE CONSIGLIATO setup FISSO dal Supertrend 3,5 (regola della  |
//|                      SuperWave v4.1): INGRESSO, STOP LOSS, TP1-3   |
//|                      tratteggiati + pannello OPERAZIONE in alto a  |
//|                      destra. E' un CALCOLATORE di stop e target,   |
//|                      NON un segnale validato. NESSUN ordine inviato.|
//|                                                                   |
//|  SUPERTREND: UNA sola implementazione in tutto il file, la        |
//|  SW_STCore della SuperWave v4.1 (ricopiata IDENTICA, il collaudo  |
//|  lo verifica): ATR = media SEMPLICE del true range come iATR di   |
//|  MT5; bande che si stringono; inversione quando la chiusura supera|
//|  la banda della barra PRIMA. Scelta su ABTG_Confluenza.mqh perche'|
//|  quella ha come default l'ATR di Wilder (non quello chiesto) e su |
//|  ABTG_Supertrend.mq5 perche' quella legge un handle iATR (dati da |
//|  aspettare) e confronta la chiusura con la banda della barra       |
//|  STESSA: in rari casi gira una barra prima o dopo. Tasto          |
//|  SUPERTREND e setup ORDINE usano la stessa funzione e lo stesso   |
//|  periodo ATR; cambiano solo i moltiplicatori (2,5 / 3,0 / 3,5     |
//|  linee, 3,5 setup, come nella SuperWave: con i default la linea   |
//|  3,5 e lo stop del setup sono lo STESSO calcolo). Il setup si     |
//|  calcola anche a tasto SUPERTREND spento e NON dipende dalle linee.|
//|                                                                   |
//|  ORE: tutte in ORA SERVER del broker (quella delle candele). Il   |
//|  "giorno" e' la barra D1 del server, la settimana la W1, il mese  |
//|  la MN1. Il giorno PRECEDENTE e' l'ultima barra D1 prima di oggi  |
//|  che cade da lunedi' a venerdi' (lunedi' -> venerdi', anche se il |
//|  broker ha una candela di un'ora la domenica sera); per i simboli |
//|  che quotano il sabato (cripto: c'e' una D1 di sabato fra le      |
//|  ultime 10) conta ogni barra D1.                                  |
//|                                                                   |
//|  STATO DEI TASTI: GlobalVariable con la ChartID nel nome; resta   |
//|  al cambio di simbolo/TF e di parametri, si cancella quando togli |
//|  l'indicatore o chiudi il grafico. Riavvio del terminale: resta   |
//|  SOLO se il grafico riprende la stessa ChartID [NON VERIFICATO];  |
//|  altrimenti si riparte dagli input (tutto spento).                |
//|  SE LE CANDELE SPARISCONO (terminale chiuso in crash con HEIKIN   |
//|  ASHI acceso): rimettere l'indicatore le fa tornare da solo; a    |
//|  mano: F8 > Colori > Candela/Barra su e giu'.                     |
//|                                                                   |
//|  Un solo esemplare per grafico (oggetti con prefisso fisso), e    |
//|  non insieme ad altri indicatori che nascondono le candele        |
//|  (ABTG_Segnali_EMA_BB_ST, SuperWave in HA).                       |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.01"
#property strict
#property indicator_chart_window
#property indicator_buffers 46
#property indicator_plots   14

//--- plot 1: candele Heikin Ashi (buffer 0-3 OHLC, 4 colore)
#property indicator_label1  "HA Apertura;HA Massimo;HA Minimo;HA Chiusura"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrSeaGreen,clrFireBrick
#property indicator_width1  1
//--- plot 2-4: Bollinger
#property indicator_label2  "BB alta"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLightSlateGray
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
#property indicator_label3  "BB media"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLightSlateGray
#property indicator_style3  STYLE_DASH
#property indicator_width3  1
#property indicator_label4  "BB bassa"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrLightSlateGray
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot 5-6: Supertrend (due linee: niente diagonale di raccordo all'inversione)
#property indicator_label5  "Supertrend su"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrLimeGreen
#property indicator_width5  2
#property indicator_label6  "Supertrend giu"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrOrangeRed
#property indicator_width6  2
//--- plot 7-10 (v1.01): Supertrend 2,5 e 3,5, due linee ciascuno come il 3,0 (colori/spessori dagli input in OnInit)
#property indicator_label7  "Supertrend 2.5 su"
#property indicator_type7   DRAW_LINE
#property indicator_color7  C'150,225,150'
#property indicator_width7  1
#property indicator_label8  "Supertrend 2.5 giu"
#property indicator_type8   DRAW_LINE
#property indicator_color8  C'255,175,130'
#property indicator_width8  1
#property indicator_label9  "Supertrend 3.5 su"
#property indicator_type9   DRAW_LINE
#property indicator_color9  C'0,150,80'
#property indicator_width9  3
#property indicator_label10 "Supertrend 3.5 giu"
#property indicator_type10  DRAW_LINE
#property indicator_color10 C'205,90,0'
#property indicator_width10 3
//--- plot 11-14: EMA (9 e 21 sottili, 50 media, 200 spessa); disegnate per ultime = sopra a tutto
#property indicator_label11 "EMA 9"
#property indicator_type11  DRAW_LINE
#property indicator_color11 clrHotPink
#property indicator_width11 1
#property indicator_label12 "EMA 21"
#property indicator_type12  DRAW_LINE
#property indicator_color12 clrGold
#property indicator_width12 1
#property indicator_label13 "EMA 50"
#property indicator_type13  DRAW_LINE
#property indicator_color13 clrWhite
#property indicator_width13 2
#property indicator_label14 "EMA 200"
#property indicator_type14  DRAW_LINE
#property indicator_color14 clrRed
#property indicator_width14 3

//+------------------------------------------------------------------+
//| INPUT                                                            |
//+------------------------------------------------------------------+
input group "=== Barra dei pulsanti (in alto a sinistra) ==="
input int    InpBarraX      = 4;     // distanza dal bordo SINISTRO (px)
input int    InpBarraY      = 20;    // distanza dal bordo ALTO (px): sotto la riga del simbolo
input int    InpTastoH      = 19;    // altezza dei rettangolini (px)
input int    InpTastoFont   = 7;     // dimensione del testo nei rettangolini
input int    InpTastoPxCar  = 6;     // larghezza per carattere (px): allarga o stringe i rettangolini
input int    InpTastoSpazio = 2;     // spazio fra un rettangolino e l'altro (px)
input group "=== Stato all'AVVIO (false = spento: grafico pulito) ==="
input bool   InpDefaultAccesoEma200  = false;  // EMA 200
input bool   InpDefaultAccesoEma50   = false;  // EMA 50
input bool   InpDefaultAccesoEma921  = false;  // EMA 9 / 21
input bool   InpDefaultAccesoBB      = false;  // BOLLINGER
input bool   InpDefaultAccesoST      = false;  // SUPERTREND
input bool   InpDefaultAccesoLivelli = false;  // LIVELLI
input bool   InpDefaultAccesoHA      = false;  // HEIKIN ASHI
input bool   InpDefaultAccesoOrdine  = false;  // ORDINE CONSIGLIATO
input group "=== Medie mobili esponenziali ==="
input int    InpEma200    = 200;          // periodo della EMA lenta
input int    InpEma50     = 50;           // periodo della EMA media
input int    InpEma9      = 9;            // periodo della EMA veloce
input int    InpEma21     = 21;           // periodo della EMA 21
input color  InpColEma200 = clrRed;       // colore EMA 200 (spessa 3)
input color  InpColEma50  = clrWhite;     // colore EMA 50 (spessa 2; su sfondo bianco cambiala)
input color  InpColEma9   = clrHotPink;   // colore EMA 9 (rosa)
input color  InpColEma21  = clrGold;      // colore EMA 21 (gialla)
input group "=== Bande di Bollinger ==="
input int    InpBBPeriodo = 20;                // periodo
input double InpBBDev     = 2.0;               // deviazioni standard
input color  InpColBB     = clrLightSlateGray; // colore delle bande (leggibile su scuro e su chiaro)
input group "=== Supertrend (stessa funzione anche per ORDINE CONSIGLIATO) ==="
input int    InpStPeriodo = 10;            // periodo ATR, UGUALE per i tre livelli (media semplice del true range, come iATR; i vocali non lo dicono)
input double InpStMolt    = 3.0;           // LIVELLO 2: moltiplicatore della linea centrale (3,0; nome della v1.00, invariato)
input color  InpColStSu   = clrLimeGreen;  // LIVELLO 2: colore trend SU (linea sotto il prezzo)
input color  InpColStGiu  = clrOrangeRed;  // LIVELLO 2: colore trend GIU' (linea sopra il prezzo)
input int    InpStSpess2  = 2;             // LIVELLO 2: spessore (2 come la v1.00)
input double InpSTMult1   = 2.5;           // LIVELLO 1: moltiplicatore (2,5 dei vocali)
input bool   InpStMostra1 = true;          // LIVELLO 1: disegnato col tasto SUPERTREND
input color  InpColSt1Su  = C'150,225,150';// LIVELLO 1: colore trend SU (verde chiaro)
input color  InpColSt1Giu = C'255,175,130';// LIVELLO 1: colore trend GIU' (salmone chiaro)
input int    InpStSpess1  = 1;             // LIVELLO 1: spessore (sottile)
input double InpSTMult3   = 3.5;           // LIVELLO 3: moltiplicatore (3,5 dei vocali; con 3,5 coincide col SETUP)
input bool   InpStMostra3 = true;          // LIVELLO 3: disegnato col tasto SUPERTREND
input color  InpColSt3Su  = C'0,150,80';   // LIVELLO 3: colore trend SU (verde scuro)
input color  InpColSt3Giu = C'205,90,0';   // LIVELLO 3: colore trend GIU' (arancio scuro: non si confonde con la EMA 200 rossa)
input int    InpStSpess3  = 3;             // LIVELLO 3: spessore (spesso)
input bool   InpStScritte       = true;    // scritta "ST 2.5 / ST 3.0 / ST 3.5" al bordo destro, all'altezza della linea
input bool   InpStScrittePrezzo = true;    // ...con il valore della linea (barra in corso)
input group "=== EMA 200 di ALTRI timeframe: riga orizzontale rossa tratteggiata ==="
input int    InpEmaHtfTasto  = 0;          // compare con: 0 = tasto SUPERTREND, 1 = tasto LIVELLI, 2 = uno dei due
input bool   InpEmaHtfM15    = false;      // EMA 200 M15
input bool   InpEmaHtfM30    = false;      // EMA 200 M30
input bool   InpEmaHtfH1     = true;       // EMA 200 H1 (default NOSTRO: i vocali dicono "dall'H1 o H4 in su")
input bool   InpEmaHtfH4     = true;       // EMA 200 H4 (default NOSTRO, idem)
input bool   InpEmaHtfD1     = false;      // EMA 200 D1
input bool   InpEmaHtfW1     = false;      // EMA 200 W1
input int    InpEmaHtfBarra  = 0;          // valore della barra: 0 = in corso (si muove col prezzo), 1 = ultima chiusa
input color  InpColEmaHtf    = clrRed;     // colore della riga (tratteggiata: spessore 1, MT5 tratteggia solo a 1)
input bool   InpEmaHtfPrezzo = true;       // scritta "EMA200 H1" con il prezzo accanto
input group "=== Heikin Ashi ==="
input color  InpColHaSu   = C'38,166,91';  // candela HA rialzista
input color  InpColHaGiu  = C'200,55,50';  // candela HA ribassista
input group "=== LIVELLI: quali mostrare (ore = ORA SERVER del broker) ==="
input bool   InpLiv_GiornoPrecMax      = true;   // MAX GIORNO PRECEDENTE
input bool   InpLiv_GiornoPrecMin      = true;   // MIN GIORNO PRECEDENTE
input bool   InpLiv_GiornoPrecChiusura = true;   // CHIUSURA GIORNO PRECEDENTE
input bool   InpLiv_OggiApertura       = true;   // APERTURA DI OGGI
input bool   InpLiv_OggiMax            = true;   // MAX DI OGGI (si aggiorna)
input bool   InpLiv_OggiMin            = true;   // MIN DI OGGI (si aggiorna)
input bool   InpLiv_SettPrecMax        = true;   // MAX SETTIMANA PRECEDENTE
input bool   InpLiv_SettPrecMin        = true;   // MIN SETTIMANA PRECEDENTE
input bool   InpLiv_MesePrecMax        = false;  // MAX MESE PRECEDENTE
input bool   InpLiv_MesePrecMin        = false;  // MIN MESE PRECEDENTE
input bool   InpLiv_NotteMax           = true;   // MAX NOTTE
input bool   InpLiv_NotteMin           = true;   // MIN NOTTE
input bool   InpLiv_TondoSopra         = false;  // NUMERO TONDO SOPRA
input bool   InpLiv_TondoSotto         = false;  // NUMERO TONDO SOTTO
input bool   InpLiv_H4Max              = false;  // ULTIMO MASSIMO H4 (non ancora superato)
input bool   InpLiv_H4Min              = false;  // ULTIMO MINIMO H4 (non ancora superato)
input int    InpNotteDaOra   = 23;   // NOTTE: ora di inizio (server). Come le sedie DAX MaxMinNotte: 23 BCM = 00:00 italiane d'estate
input int    InpNotteDaMin   = 0;    // NOTTE: minuti di inizio
input int    InpNotteAOra    = 4;    // NOTTE: ora di fine (server), barra M1 compresa
input int    InpNotteAMin    = 59;   // NOTTE: minuti di fine (4:59 = fino alle 5:00)
input double InpTondoPasso   = 0.0;  // NUMERI TONDI: passo (0 = automatico: oro 10, forex 0.0100 / JPY 1.00, indici 100 o 1000 sopra 30.000)
input int    InpH4Ampiezza   = 2;    // H4: barre per lato dello swing (frattale)
input int    InpH4Barre      = 300;  // H4: barre lette
input int    InpLivFont      = 8;    // dimensione delle scritte dei livelli
input group "=== LIVELLI: colori (resistenza = sopra il prezzo, supporto = sotto) ==="
input color  InpColResGiorno = C'235,90,90';    // giorno: resistenza
input color  InpColSupGiorno = C'70,150,240';   // giorno: supporto
input color  InpColResSett   = C'240,150,50';   // settimana: resistenza
input color  InpColSupSett   = C'40,185,185';   // settimana: supporto
input color  InpColResMese   = C'215,100,200';  // mese: resistenza
input color  InpColSupMese   = C'150,120,235';  // mese: supporto
input color  InpColResNotte  = C'225,190,50';   // notte: resistenza
input color  InpColSupNotte  = C'100,190,90';   // notte: supporto
input color  InpColResTondo  = C'175,175,175';  // numero tondo: resistenza
input color  InpColSupTondo  = C'130,130,130';  // numero tondo: supporto
input color  InpColResH4     = C'255,130,160';  // H4: resistenza
input color  InpColSupH4     = C'90,200,255';   // H4: supporto
input group "=== ORDINE CONSIGLIATO (regole della SuperWave v4.1; NON invia ordini) ==="
input double InpSetupMolt = 3.5;    // moltiplicatore del Supertrend del SETUP (SuperWave: 3,5)
input double InpRiskPct   = 1.0;    // Rischio per operazione, in % del saldo (lotti indicativi)
input double InpTP1_R     = 1.0;    // TARGET 1 in R
input double InpTP2_R     = 2.0;    // TARGET 2 in R
input double InpTP3_R     = 3.0;    // TARGET 3 in R
input double InpSize1     = 40;     // % della size sul TP1
input double InpSize2     = 30;     // % della size sul TP2
input double InpSize3     = 30;     // % della size sul TP3
input color  InpColIngresso = C'0,170,255';  // linea INGRESSO (azzurra, tratteggiata)
input color  InpStopCol     = clrRed;        // linea STOP LOSS (rossa, tratteggiata)
input color  InpColTP       = C'57,255,20';  // linee TP1/TP2/TP3 (verde fosforescente, tratteggiate)
input int    InpFont      = 8;               // pannello: dimensione testo (come la SuperWave)
input color  InpBuyCol    = C'38,166,91';    // pannello: verde BUY
input color  InpSellCol   = C'200,55,50';    // pannello: rosso SELL
input color  InpPanelCol  = C'16,18,22';     // pannello: sfondo
input color  InpGridCol   = C'55,58,66';     // pannello: bordo
input color  InpTextCol   = C'205,208,214';  // pannello: testo
input color  InpHeadCol   = clrWhite;        // pannello: titoli

//+------------------------------------------------------------------+
//| COSTANTI e GLOBALI                                               |
//+------------------------------------------------------------------+
#define PFX            "ABTGPG_"
#define PG_VUOTO       EMPTY_VALUE
#define PG_NT          8        // tasti (interruttori)
#define PG_NO          9        // rettangolini (EMA 9/21 e' diviso in due)
#define PG_T_EMA200    0
#define PG_T_EMA50     1
#define PG_T_EMA921    2
#define PG_T_BB        3
#define PG_T_ST        4
#define PG_T_LIV       5
#define PG_T_HA        6
#define PG_T_ORD       7
#define PG_NLIV        16       // livelli nominati
#define PG_MAXIT       40       // righe/scritte al massimo (16 livelli + 5 dell'ordine + 3 ST + 6 EMA di altri TF = 30)
#define PG_NPLOT       14       // = indicator_plots
#define PG_NEH         6        // EMA 200 di altri TF: M15, M30, H1, H4, D1, W1
#define SW_TRUST_BARS  300      // come la v4.1: inversione ad almeno 300 barre dall'inizio dello storico

//--- buffer disegnati (v1.01: ST 2,5 e 3,5 inseriti DOPO il 3,0 e PRIMA delle EMA, che restano sopra a tutto)
double bHo[], bHh[], bHl[], bHc[], bHcol[];           // 0-4   plot 0
double bBBu[], bBBm[], bBBl[];                        // 5-7   plot 1-3
double bStSu[], bStGiu[];                             // 8-9   plot 4-5   Supertrend livello 2 (3,0)
double bSt1Su[], bSt1Giu[];                           // 10-11 plot 6-7   Supertrend livello 1 (2,5)
double bSt3Su[], bSt3Giu[];                           // 12-13 plot 8-9   Supertrend livello 3 (3,5)
double bE9[], bE21[], bE50[], bE200[];                // 14-17 plot 10-13
//--- buffer di calcolo (sempre pieni: i tasti scelgono solo cosa MOSTRARE)
double kE9[], kE21[], kE50[], kE200[];                // 18-21
double kBBu[], kBBm[], kBBl[];                        // 22-24
double kAtr[], kUp[], kDn[], kDir[], kVal[];          // 25-29 Supertrend del tasto, livello 2 (kAtr comune a tutti: non dipende dal moltiplicatore)
double kUp2[], kDn2[], kDir2[], kVal2[];              // 30-33 Supertrend del setup
double kHo[], kHh[], kHl[], kHc[];                    // 34-37 Heikin Ashi
double kUp1[], kDn1[], kDir1[], kVal1[];              // 38-41 Supertrend del tasto, livello 1
double kUp3[], kDn3[], kDir3[], kVal3[];              // 42-45 Supertrend del tasto, livello 3

//--- tasti
bool     gOn[PG_NT];
string   gObjTxt[PG_NO] = {"EMA 200","EMA 50","EMA 9","EMA 21","BOLLINGER","SUPERTREND","LIVELLI","HEIKIN ASHI","ORDINE CONSIGLIATO"};
int      gObjTog[PG_NO] = {PG_T_EMA200,PG_T_EMA50,PG_T_EMA921,PG_T_EMA921,PG_T_BB,PG_T_ST,PG_T_LIV,PG_T_HA,PG_T_ORD};
color    gObjCol[PG_NO];
int      gObjX[PG_NO], gObjW[PG_NO];
int      gBarH = 19;
int      gBarY = 20;
int      gTastoFs = 7;
int      gLivFs = 8;
bool     gInitOk = false;

//--- parametri effettivi (input corretti se fuori intervallo)
int      gP200 = 200, gP50 = 50, gP9 = 9, gP21 = 21, gBBP = 20, gStP = 10;
double   gBBD = 2.0, gStM = 3.0, gSuM = 3.5;
double   gSt1M = 2.5, gSt3M = 3.5;
int      gH4K = 2, gH4N = 300;

//--- EMA 200 di altri timeframe (handle iMA creati in OnInit, rilasciati in OnDeinit)
ENUM_TIMEFRAMES gEhTf[PG_NEH] = {PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1};
int      gEhH[PG_NEH];            // INVALID_HANDLE = TF spento, uguale al grafico o creazione fallita
double   gEhV[PG_NEH];
bool     gEhOk[PG_NEH];
bool     gEhPending = false;      // qualche handle non ancora calcolato: si riprova dal timer
int      gEhShift = 0;
int      gEhMode = 0;             // 0 tasto SUPERTREND, 1 tasto LIVELLI, 2 uno dei due

//--- stato del calcolo sul grafico
int      gRT = 0;
int      gAnchorIdx = -1;
datetime gAnchorT = 0;
datetime gLastBarT = 0;
datetime gCurT = 0;
double   gPrice = 0.0;

//--- livelli
double   gLv[PG_NLIV];
bool     gLvOk[PG_NLIV];
string   gLvName[PG_NLIV] = {"MAX GIORNO PRECEDENTE","MIN GIORNO PRECEDENTE","CHIUSURA GIORNO PRECEDENTE",
                             "APERTURA DI OGGI","MAX DI OGGI","MIN DI OGGI",
                             "MAX SETTIMANA PRECEDENTE","MIN SETTIMANA PRECEDENTE",
                             "MAX MESE PRECEDENTE","MIN MESE PRECEDENTE",
                             "MAX NOTTE","MIN NOTTE",
                             "NUMERO TONDO SOPRA","NUMERO TONDO SOTTO",
                             "ULTIMO MASSIMO H4","ULTIMO MINIMO H4"};
int      gLvFam[PG_NLIV]  = {0,0,0, 0,0,0, 1,1, 2,2, 3,3, 4,4, 5,5};   // 0 giorno 1 settimana 2 mese 3 notte 4 tondo 5 H4
int      gLvSty[PG_NLIV]  = {STYLE_DASH,STYLE_DASH,STYLE_DASH, STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,
                             STYLE_DASH,STYLE_DASH, STYLE_DASH,STYLE_DASH, STYLE_SOLID,STYLE_SOLID,
                             STYLE_DOT,STYLE_DOT, STYLE_DASH,STYLE_DASH};
bool     gLvOn[PG_NLIV];
datetime gDayT = 0;               // ora della barra D1 "di oggi" letta
datetime gD1Seen = 0;             // ultima ora D1 vista in OnCalculate (giorno nuovo = rilettura)
datetime gNightTS = 0, gNightTE = 0;
bool     gLivPending = false;     // qualche dato non pronto: si riprova dal timer
uint     gLivTryMs = 0;
uint     gLivFullMs = 0;
int      gLivTries = 0;
bool     gH4Stale = false;
double   gTondoPasso = 0.0;

//--- setup ORDINE CONSIGLIATO (sempre calcolato, mostrato col tasto)
int      gSuCode = -1;            // -1 non ancora calcolato, 0 ok, 1 nessuna inversione, 2 troppo vicina all'inizio, 3 stop sbagliato
int      gSuFi = -1, gSuD = 0;
datetime gSuFiT = 0;
double   gSuE = 0.0, gSuS = 0.0, gSuT1 = 0.0, gSuT2 = 0.0, gSuT3 = 0.0;
int      gCS = -1, gC1 = -1, gC2 = -1, gC3 = -1;     // tocchi sulle barre CHIUSE dopo l'inversione
int      gHitState = 0, gHitBest = 0;
datetime gHitStopT = 0, gHitTpT = 0;
double   gHitPrice = 0.0;
int      gSuNoFlipBars = 0;

//--- linee con etichetta (livelli + ordine): ricostruite e confrontate con la firma
int      gItN = 0;
double   gItP[];
string   gItTxt[];
color    gItCol[];
int      gItSty[];
bool     gItLine[];               // true = riga orizzontale + scritta; false = solo scritta (Supertrend: la linea e' il plot)
string   gItSig = "";
int      gItDrawn = 0;
int      gLabY[];
int      gLabX[];
int      gLabGap = 14;

//--- pannello
string   gPanSig = "";
int      gPanBottom = 0, gPanW = 0;

//--- colori nativi del grafico (Heikin Ashi)
color    gColBull = clrLime, gColBear = clrRed, gColUp = clrLime, gColDown = clrRed, gColLine = clrLime;
bool     gColsHidden = false;
int      gHealCount = 0;

//==================================================================//
//  FUNZIONI PURE: nessuna chiamata al terminale. Il collaudo        //
//  (backtest_pipeline/collaudo_pulsanti_grafico.py) le ESTRAE da    //
//  qui, le compila come C++ e le confronta con lo specchio Python.  //
//  Le SW_* sono copiate IDENTICHE dalla SuperWave v4.1 (il collaudo //
//  lo controlla riga per riga). Se le cambi, rilancia il collaudo.  //
//==================================================================//
//@@PG_PURE_BEGIN
//--- Supertrend: UNICA implementazione per griglia, grafico e setup.
//    Indici 0 = barra piu' vecchia. Calcola le barre [from, n).
//    ATR = media SEMPLICE degli ultimi 'per' True Range (come iATR di MT5),
//    sommata ogni volta nello stesso ordine: lo stesso numero a qualunque
//    punto parta la serie (niente deriva di una somma che scorre).
//    dir: +1 su, -1 giu', 0 = non ancora calcolabile (i < per).
int SW_STCore(const double &h[],const double &l[],const double &c[],const int n,const int from,
              const int per,const double mult,double &atr[],double &upF[],double &dnF[],
              double &dir[],double &val[])
  {
   if(per<1) return 0;
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      if(i<per)
        {
         atr[i]=0.0; upF[i]=0.0; dnF[i]=0.0; dir[i]=0.0; val[i]=0.0;
         continue;
        }
      double s=0.0;
      for(int k=i-per+1;k<=i;k++)
         s+=MathMax(h[k],c[k-1])-MathMin(l[k],c[k-1]);
      double a=s/per;
      atr[i]=a;
      double mid=(h[i]+l[i])/2.0;
      double ub=mid+mult*a;
      double lb=mid-mult*a;
      if(i==per)
        {
         upF[i]=ub;
         dnF[i]=lb;
         dir[i]=(c[i]>=mid) ? 1.0 : -1.0;
        }
      else
        {
         upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1]) ? ub : upF[i-1];
         dnF[i]=(lb>dnF[i-1] || c[i-1]<dnF[i-1]) ? lb : dnF[i-1];
         if(c[i]>upF[i-1])
            dir[i]=1.0;
         else
            if(c[i]<dnF[i-1])
               dir[i]=-1.0;
            else
               dir[i]=dir[i-1];
        }
      val[i]=(dir[i]>0.0) ? dnF[i] : upF[i];
     }
   return n;
  }
//--- barre dall'ultima inversione fino a 'last' (0 = inversione proprio su 'last').
//    Si confrontano solo le barre i > first (la barra 'first' e' il seme del calcolo).
//    -1 = nessuna inversione nel tratto.
int SW_BarsSinceFlip(const double &dir[],const int last,const int first)
  {
   if(last<=first) return -1;
   for(int i=last;i>first;i--)
      if(dir[i]!=dir[i-1])
         return last-i;
   return -1;
  }
//--- indice della barra dell'ultima inversione, -1 se non c'e'
int SW_LastFlip(const double &dir[],const int last,const int first)
  {
   int bs=SW_BarsSinceFlip(dir,last,first);
   if(bs<0) return -1;
   return last-bs;
  }
//--- colore 'c' sfumato verso 'toward' (f=0 pieno, f=1 = toward)
color SW_Dim(const color c,const color toward,const double f)
  {
   int r=(int)(c&0xFF), g=(int)((c>>8)&0xFF), b=(int)((c>>16)&0xFF);
   int r2=(int)(toward&0xFF), g2=(int)((toward>>8)&0xFF), b2=(int)((toward>>16)&0xFF);
   int R=(int)(r+(r2-r)*f), G=(int)(g+(g2-g)*f), B=(int)(b+(b2-b)*f);
   return (color)((B<<16)|(G<<8)|R);
  }
//--- lotto al passo del simbolo, per DIFETTO, con tolleranza di 1e-7 passi
//    (0.29/0.01 = 28.999999999999996 deve dare 29 passi, non 28; idem 0.57 e 0.58.
//    NB: il commento della v4.1 cita 0.3/0.01, che in double fa 30.0 esatto: classe 1066).
//    flag: 0 ok, 1 sotto il minimo (-> 0), 2 tagliato al massimo
double SW_NormLots(const double v,const double step,const double vmin,const double vmax,int &flag)
  {
   flag=0;
   double st=(step>0.0) ? step : 0.01;
   if(v<=0.0)
     {
      flag=1;
      return 0.0;
     }
   int dg=0;
   double t=st;
   while(dg<8 && MathAbs(t-MathRound(t))>1e-9)
     {
      t*=10.0;
      dg++;
     }
   double k=MathFloor(v/st+1e-7);
   double lot=NormalizeDouble(k*st,dg);
   if(vmax>0.0 && lot>vmax)
     {
      k=MathFloor(vmax/st+1e-7);
      lot=NormalizeDouble(k*st,dg);
      flag=2;
     }
   if(lot<=0.0 || lot<vmin)
     {
      flag=1;
      return 0.0;
     }
   return lot;
  }
//--- setup valido: stop dal lato giusto dell'ingresso
bool SW_SetupOk(const int d,const double entry,const double stop)
  {
   if(d>0) return (stop>0.0 && stop<entry);
   if(d<0) return (stop>entry);
   return false;
  }
//--- primo indice (>= from) in cui il prezzo TOCCA stop / TP1 / TP2 / TP3 (-1 = mai)
void SW_Hits(const double &h[],const double &l[],const int from,const int n,const int d,
             const double stop,const double tp1,const double tp2,const double tp3,
             int &iStop,int &i1,int &i2,int &i3)
  {
   iStop=-1; i1=-1; i2=-1; i3=-1;
   for(int i=from;i<n;i++)
     {
      if(d>0)
        {
         if(iStop<0 && l[i]<=stop) iStop=i;
         if(i1<0 && h[i]>=tp1) i1=i;
         if(i2<0 && h[i]>=tp2) i2=i;
         if(i3<0 && h[i]>=tp3) i3=i;
        }
      else
        {
         if(iStop<0 && h[i]>=stop) iStop=i;
         if(i1<0 && l[i]<=tp1) i1=i;
         if(i2<0 && l[i]<=tp2) i2=i;
         if(i3<0 && l[i]<=tp3) i3=i;
        }
     }
  }
//--- stato del setup dagli indici dei tocchi.
//    best = TP piu' alto toccato in una barra PRIMA di quella dello stop.
//    0 aperto, 1..3 TPk raggiunto (stop mai toccato), 4 INVALIDATO (stop prima di ogni TP),
//    5 TP 'best' poi stop, 6 stop e TP nella STESSA barra senza TP prima (ordine ignoto)
int SW_SetupState(const int iStop,const int i1,const int i2,const int i3,int &best)
  {
   best=0;
   if(i1>=0 && (iStop<0 || i1<iStop)) best=1;
   if(i2>=0 && (iStop<0 || i2<iStop)) best=2;
   if(i3>=0 && (iStop<0 || i3<iStop)) best=3;
   if(iStop<0) return best;
   if(best>0) return 5;
   if(i1==iStop || i2==iStop || i3==iStop) return 6;
   return 4;
  }
//--- EMA come iMA(MODE_EMA) di MT5: seme = prima chiusura, poi e = c*a + e_prec*(1-a), a = 2/(per+1).
//    Calcola le barre [from, n).
int PG_EMA(const double &c[],const int n,const int from,const int per,double &e[])
  {
   if(per<1 || n<1) return 0;
   double a=2.0/(per+1.0);
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      if(i==0) e[i]=c[0];
      else     e[i]=c[i]*a+e[i-1]*(1.0-a);
     }
   return n;
  }
//--- Bollinger come iBands di MT5: media = SMA(per); deviazione = radice della media dei quadrati
//    degli scarti (divisa per 'per', non per-1). Barre i < per-1: PG_VUOTO. Somme rifatte a ogni
//    barra nello stesso ordine: lo stesso numero da qualunque barra parta il calcolo.
int PG_BB(const double &c[],const int n,const int from,const int per,const double dev,
          double &up[],double &mid[],double &lo[])
  {
   if(per<1) return 0;
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      if(i<per-1)
        {
         up[i]=PG_VUOTO; mid[i]=PG_VUOTO; lo[i]=PG_VUOTO;
         continue;
        }
      double s=0.0;
      for(int j=i-per+1;j<=i;j++) s+=c[j];
      double m=s/per;
      double q=0.0;
      for(int k=i-per+1;k<=i;k++)
        {
         double dd=c[k]-m;
         q+=dd*dd;
        }
      double sd=MathSqrt(q/per);
      mid[i]=m;
      up[i]=m+dev*sd;
      lo[i]=m-dev*sd;
     }
   return n;
  }
//--- Heikin Ashi (stessa formula di ABTG_Segnali_EMA_BB_ST.mq5): chiusura = media OHLC;
//    apertura = media di apertura e chiusura HA della barra prima ((o+c)/2 sulla prima barra);
//    massimo/minimo = estremi fra la barra vera e apertura/chiusura HA.
int PG_HA(const double &o[],const double &h[],const double &l[],const double &c[],const int n,const int from,
          double &ho[],double &hh[],double &hl[],double &hc[])
  {
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      double xc=(o[i]+h[i]+l[i]+c[i])/4.0;
      double xo=(i==0) ? (o[i]+c[i])/2.0 : (ho[i-1]+hc[i-1])/2.0;
      ho[i]=xo;
      hc[i]=xc;
      hh[i]=MathMax(h[i],MathMax(xo,xc));
      hl[i]=MathMin(l[i],MathMin(xo,xc));
     }
   return n;
  }
//--- cosa si MOSTRA di un valore calcolato (tasto spento = vuoto)
double PG_Mostra(const bool on,const double v)
  {
   return on ? v : PG_VUOTO;
  }
//--- come sopra, con le prime barre di riscaldamento vuote (EMA: barre < periodo-1)
double PG_MostraDa(const bool on,const int i,const int first,const double v)
  {
   return (on && i>=first) ? v : PG_VUOTO;
  }
//--- linea del Supertrend di un verso (+1 su, -1 giu'): vuota se il tasto e' spento o il verso e' l'altro
double PG_StLinea(const bool on,const double dir,const double val,const double verso)
  {
   return (on && dir==verso) ? val : PG_VUOTO;
  }
//--- stato iniziale di un tasto: vale quello salvato SOLO se l'input di partenza non e' cambiato
bool PG_StatoIniziale(const bool haGv,const bool gvOn,const bool gvInp,const bool inpOra)
  {
   if(haGv && gvInp==inpOra) return gvOn;
   return inpOra;
  }
//--- testo nero su colori chiari, bianco su colori scuri
color PG_Contrasto(const color c)
  {
   int r=(int)(c&0xFF), g=(int)((c>>8)&0xFF), b=(int)((c>>16)&0xFF);
   return (r*299+g*587+b*114>=150000) ? clrBlack : clrWhite;
  }
//--- giorno della settimana dell'ora 't' (0 = domenica ... 6 = sabato; 01/01/1970 era giovedi')
int PG_Dow(const datetime t)
  {
   long d=(long)t/86400;
   return (int)((d+4)%7);
  }
//--- indice della barra D1 del GIORNO PRECEDENTE a quella di oggi (n-1): la piu' recente prima di
//    oggi che cade da lunedi' a venerdi'. Le barre di sabato e domenica (per esempio la candela di
//    un'ora della domenica sera di chi riapre il forex alle 23) NON sono un giorno precedente,
//    TRANNE per i simboli che quotano anche il sabato (cripto: tuttiGiorni = true, conta ogni barra).
//    -1 = nessuna.
int PG_GiornoPrec(const datetime &t[],const int n,const bool tuttiGiorni)
  {
   for(int i=n-2;i>=0;i--)
     {
      int w=PG_Dow(t[i]);
      if(tuttiGiorni || (w>=1 && w<=5)) return i;
     }
   return -1;
  }
//--- finestra della NOTTE come ComputeBox di ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5 (r.200-206):
//    giorno = data SERVER di 'now' meno 'back' giorni; fine = quel giorno alle aH:aM; inizio = quel
//    giorno alle daH:daM, e se inizio >= fine l'inizio e' il giorno PRIMA (la notte scavalca la
//    mezzanotte). Barre M1 della notte = apertura in [tS, tE], estremi compresi.
void PG_NotteFinestra(const datetime now,const int back,const int daH,const int daM,const int aH,const int aM,
                      datetime &tS,datetime &tE)
  {
   datetime day=(datetime)(((long)now/86400)*86400-(long)back*86400);
   tE=day+aH*3600+aM*60;
   tS=day+daH*3600+daM*60;
   if(tS>=tE) tS-=86400;
  }
//--- numeri tondi: multiplo del passo SUBITO SOPRA e SUBITO SOTTO il prezzo (se il prezzo e' proprio
//    su un multiplo: quello sopra e quello sotto, mai il prezzo stesso)
void PG_Tondi(const double price,const double step,const int dg,double &sopra,double &sotto)
  {
   sopra=0.0;
   sotto=0.0;
   if(step<=0.0) return;
   double q=price/step;
   double r=MathRound(q);
   if(MathAbs(q-r)<1e-9)
     {
      sotto=(r-1.0)*step;
      sopra=(r+1.0)*step;
     }
   else
     {
      double fl=MathFloor(q);
      sotto=fl*step;
      sopra=(fl+1.0)*step;
     }
   sopra=NormalizeDouble(sopra,dg);
   sotto=NormalizeDouble(sotto,dg);
  }
//--- passo automatico dei numeri tondi: oro 10; forex 0.0100 (JPY, 2-3 decimali: 1.00); altri
//    (indici) 100, o 1000 da 30.000 in su
double PG_PassoAuto(const bool forex,const bool oro,const int dg,const double price)
  {
   if(oro) return 10.0;
   if(forex) return (dg<=3) ? 1.0 : 0.01;
   return (price>=30000.0) ? 1000.0 : 100.0;
  }
//--- ultimo swing H4 NON superato. Swing alto: massimo >= dei 'k' vicini per lato (pari compreso,
//    come i livelli della SuperWave), con 'k' barre CHIUSE a destra (i <= n-2-k; n-1 = barra in
//    formazione). Superato = un massimo successivo (barra in formazione compresa) PIU' ALTO.
//    Swing basso simmetrico. -1 = nessuno.
int PG_UltimoSwing(const double &h[],const double &l[],const int n,const int k,const bool alto)
  {
   int kk=(k<1) ? 1 : k;
   double ext=0.0;
   bool have=false;
   for(int i=n-1;i>=0;i--)
     {
      if(i<=n-2-kk && i>=kk)
        {
         bool sw=true;
         for(int j=1;j<=kk;j++)
           {
            if(alto)
              {
               if(h[i]<h[i-j] || h[i]<h[i+j]) sw=false;
              }
            else
              {
               if(l[i]>l[i-j] || l[i]>l[i+j]) sw=false;
              }
           }
         if(sw)
           {
            bool viol=have && (alto ? (ext>h[i]) : (ext<l[i]));
            if(!viol) return i;
           }
        }
      double v=alto ? h[i] : l[i];
      if(!have || (alto ? (v>ext) : (v<ext)))
        {
         ext=v;
         have=true;
        }
     }
   return -1;
  }
//--- etichette impilate: y gia' in ordine crescente (dall'alto); ognuna almeno 'gap' px sotto la
//    precedente (nessuna scritta sopra un'altra)
void PG_Impila(const int &y[],const int n,const int gap,int &out[])
  {
   for(int i=0;i<n;i++)
     {
      int v=y[i];
      if(i>0 && v<out[i-1]+gap) v=out[i-1]+gap;
      out[i]=v;
     }
  }
//--- numero in formato italiano: "24998.25" -> "24.998,25" (migliaia col punto, decimali con la virgola)
string PG_Migliaia(const string s)
  {
   int dot=StringFind(s,".");
   string ip=(dot<0) ? s : StringSubstr(s,0,dot);
   string dp=(dot<0) ? "" : StringSubstr(s,dot+1);
   string sg="";
   if(StringLen(ip)>0 && StringSubstr(ip,0,1)=="-")
     {
      sg="-";
      ip=StringSubstr(ip,1);
     }
   string out="";
   int m=StringLen(ip);
   for(int i=0;i<m;i++)
     {
      if(i>0 && (m-i)%3==0) out+=".";
      out+=StringSubstr(ip,i,1);
     }
   if(dot>=0) out+=","+dp;
   return sg+out;
  }
//--- prezzo di un TP: k R dall'ingresso, nel verso del setup
double PG_Tp(const int d,const double e,const double risk,const double rr)
  {
   return (d>0) ? e+rr*risk : e-rr*risk;
  }
//--- lotti totali dal rischio in valuta: perdita per lotto = (R / tick size) x tick value
double PG_LottiTotali(const double riskMoney,const double risk,const double tickSz,const double tickVal)
  {
   if(riskMoney<=0.0 || risk<=0.0 || tickSz<=0.0 || tickVal<=0.0) return 0.0;
   double lossPerLot=(risk/tickSz)*tickVal;
   return riskMoney/lossPerLot;
  }
//--- cifre decimali del passo del lotto (0.01 -> 2, 0.1 -> 1, 1 -> 0)
int PG_CifreLotto(const double step)
  {
   double t=(step>0.0) ? step : 0.01;
   int sd=0;
   while(sd<8 && MathAbs(t-MathRound(t))>1e-9)
     {
      t*=10.0;
      sd++;
     }
   return sd;
  }
//--- SETUP FISSO (regola della SuperWave v4.1): ultima inversione del Supertrend fra le barre CHIUSE
//    (lc = ultima chiusa), ad almeno 'trust' barre dal seme; ingresso = CHIUSURA della barra di
//    inversione, stop = Supertrend su quella barra. 0 ok, 1 nessuna inversione, 2 inversione troppo
//    vicina all'inizio dello storico, 3 stop dal lato sbagliato.
int PG_Setup(const double &c[],const double &dir[],const double &val[],const int lc,const int first,const int trust,
             int &fi,int &d,double &entry,double &stop)
  {
   fi=-1;
   d=0;
   entry=0.0;
   stop=0.0;
   int f=SW_LastFlip(dir,lc,first);
   if(f<0) return 1;
   if(f<first+trust) return 2;
   fi=f;
   d=(int)dir[f];
   entry=c[f];
   stop=val[f];
   if(!SW_SetupOk(d,entry,stop)) return 3;
   return 0;
  }
//@@PG_PURE_END

//+------------------------------------------------------------------+
//| Correzione degli input fuori intervallo (dichiarata nella scheda  |
//| Esperti)                                                         |
//+------------------------------------------------------------------+
int ClampI(const int v,const int lo,const int hi,const string nome)
  {
   if(v>=lo && v<=hi) return v;
   int w=(v<lo) ? lo : hi;
   Print("ABTG_Pulsanti: ",nome,"=",v," fuori intervallo [",lo,"..",hi,"]: uso ",w,".");
   return w;
  }
double ClampD(const double v,const double lo,const double hi,const double def,const string nome)
  {
   if(v>=lo && v<=hi) return v;
   Print("ABTG_Pulsanti: ",nome,"=",DoubleToString(v,4)," fuori intervallo: uso ",DoubleToString(def,2),".");
   return def;
  }

//+------------------------------------------------------------------+
//| GlobalVariable (stato dei tasti attraverso il cambio di TF)       |
//+------------------------------------------------------------------+
string GvKey(const string what)
  {
   return "ABTGPG_" + IntegerToString(ChartID()) + "_" + what;
  }

void GvSave(const string what,const double val)
  {
   if(GlobalVariableSet(GvKey(what),val)==0)
      Print("ABTG_Pulsanti: GlobalVariableSet fallita (",what,"), errore ",GetLastError(),
            ": lo stato del tasto non sopravvivera' al cambio TF.");
  }

void GvClear()
  {
   for(int i=0;i<PG_NT;i++)
     {
      GlobalVariableDel(GvKey("S"+IntegerToString(i)));
      GlobalVariableDel(GvKey("I"+IntegerToString(i)));
     }
  }

bool InputAvvio(const int t)
  {
   switch(t)
     {
      case PG_T_EMA200: return InpDefaultAccesoEma200;
      case PG_T_EMA50:  return InpDefaultAccesoEma50;
      case PG_T_EMA921: return InpDefaultAccesoEma921;
      case PG_T_BB:     return InpDefaultAccesoBB;
      case PG_T_ST:     return InpDefaultAccesoST;
      case PG_T_LIV:    return InpDefaultAccesoLivelli;
      case PG_T_HA:     return InpDefaultAccesoHA;
      case PG_T_ORD:    return InpDefaultAccesoOrdine;
     }
   return false;
  }

void LoadStates()
  {
   for(int t=0;t<PG_NT;t++)
     {
      string ks=GvKey("S"+IntegerToString(t));
      string ki=GvKey("I"+IntegerToString(t));
      bool has=(GlobalVariableCheck(ks) && GlobalVariableCheck(ki));
      bool gvOn=(has && GlobalVariableGet(ks)>0.5);
      bool gvIn=(has && GlobalVariableGet(ki)>0.5);
      bool inp=InputAvvio(t);
      gOn[t]=PG_StatoIniziale(has,gvOn,gvIn,inp);
      GvSave("S"+IntegerToString(t),gOn[t] ? 1.0 : 0.0);
      GvSave("I"+IntegerToString(t),inp ? 1.0 : 0.0);
     }
  }

//+------------------------------------------------------------------+
//| Colori del grafico: nascondi (HA) / ripristina                    |
//| (tecnica di ABTG_Segnali_EMA_BB_ST.mq5, classi 963/971)           |
//+------------------------------------------------------------------+
color ColOrDefault(const long v,const color def)
  {
   color c=(color)v;
   // clrNONE salvato = un'istanza precedente e' morta senza ripristinare: non si "ripristina" l'invisibile
   if(c==clrNONE)
      return def;
   return c;
  }

void ColsHide()
  {
   if(gColsHidden)
      return;
   // i colori si catturano ADESSO (prima di nasconderli): sono quelli veri e attuali
   gColBull=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BULL),clrLime);
   gColBear=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR),clrRed);
   gColUp  =ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_UP),   clrLime);
   gColDown=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_DOWN), clrRed);
   gColLine=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_LINE), clrLime);
   gColsHidden=true;   // da qui in poi OGNI uscita ripristina
   bool ok=true;
   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_UP,   clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_DOWN, clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_LINE, clrNONE) && ok;
   if(!ok)
      Print("ABTG_Pulsanti: impossibile nascondere le candele native (errore ",GetLastError(),").");
  }

void ColsRestore()
  {
   if(!gColsHidden)
      return;
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,gColBull);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,gColBear);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,   gColUp);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN, gColDown);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE, gColLine);
   gColsHidden=false;
  }

bool IsNone(const ENUM_CHART_PROPERTY_INTEGER prop)
  {
   return ((color)ChartGetInteger(0,prop)==clrNONE);
  }

// NORMALI ma candele native INVISIBILI su TUTTE e cinque le proprieta' che ColsHide mette a clrNONE:
// e' la firma di un HEIKIN ASHI finito senza OnDeinit (crash, grafico salvato coi colori nascosti).
// Chi nasconde apposta solo candele/barre (linea visibile) non viene toccato (classe 971).
void RepairInvisibleNative()
  {
   if(!(IsNone(CHART_COLOR_CANDLE_BULL) && IsNone(CHART_COLOR_CANDLE_BEAR) &&
        IsNone(CHART_COLOR_CHART_UP) && IsNone(CHART_COLOR_CHART_DOWN) &&
        IsNone(CHART_COLOR_CHART_LINE)))
      return;
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,   clrLime);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN, clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE, clrLime);
   Print("ABTG_Pulsanti: candele native trovate INVISIBILI (residuo di HEIKIN ASHI chiuso male): ",
         "rimesse visibili con colori di ripiego verde/rosso (F8 > Colori per i tuoi).");
  }

//+------------------------------------------------------------------+
//| BARRA DEI PULSANTI (in alto a sinistra, una riga)                 |
//+------------------------------------------------------------------+
string ObjName(const int o)
  {
   return PFX+"B"+IntegerToString(o);
  }

void SetupBar()
  {
   double dpi=(double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   double sc=(dpi>0.0) ? dpi/96.0 : 1.0;
   if(sc<0.75) sc=0.75;
   if(sc>3.0)  sc=3.0;
   int pxc=ClampI(InpTastoPxCar,3,20,"InpTastoPxCar");
   int gap=ClampI(InpTastoSpazio,0,20,"InpTastoSpazio");
   gBarH=(int)MathRound(ClampI(InpTastoH,12,60,"InpTastoH")*sc);
   gBarY=ClampI(InpBarraY,0,5000,"InpBarraY");
   gTastoFs=ClampI(InpTastoFont,5,20,"InpTastoFont");
   int x=ClampI(InpBarraX,0,5000,"InpBarraX");
   for(int o=0;o<PG_NO;o++)
     {
      int w=StringLen(gObjTxt[o])*pxc+12;
      if(w<40) w=40;
      gObjW[o]=(int)MathRound(w*sc);
      gObjX[o]=x;
      // le due meta' di EMA 9/21 stanno attaccate: un solo rettangolino diviso in due colori
      int sp=(o==2) ? 0 : (int)MathRound(gap*sc);
      x+=gObjW[o]+sp;
     }
   gObjCol[0]=InpColEma200;
   gObjCol[1]=InpColEma50;
   gObjCol[2]=InpColEma9;
   gObjCol[3]=InpColEma21;
   gObjCol[4]=InpColBB;
   gObjCol[5]=C'38,166,91';
   gObjCol[6]=C'235,140,40';
   gObjCol[7]=C'150,100,220';
   gObjCol[8]=InpColIngresso;
  }

void MakeButton(const int o)
  {
   string nm=ObjName(o);
   if(ObjectFind(0,nm)<0)
     {
      if(!ObjectCreate(0,nm,OBJ_BUTTON,0,0,0))
        {
         Print("ABTG_Pulsanti: creazione tasto fallita (",gObjTxt[o],"), errore ",GetLastError());
         return;
        }
      ObjectSetInteger(0,nm,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,nm,OBJPROP_ZORDER,10);
      ObjectSetString(0,nm,OBJPROP_FONT,"Arial");
     }
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,gObjX[o]);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,gBarY);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,gObjW[o]);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,gBarH);
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,gTastoFs);
   ObjectSetString(0,nm,OBJPROP_TEXT,gObjTxt[o]);
  }

// ACCESO = colore pieno + bordo del colore del testo (nero o bianco: si vede); SPENTO = fondo scuro
// col colore molto attenuato, contorno del suo colore, testo grigio chiaro (leggibile)
void PaintButton(const int o)
  {
   string nm=ObjName(o);
   if(ObjectFind(0,nm)<0)
      return;
   bool on=gOn[gObjTog[o]];
   color c=gObjCol[o];
   color fg=PG_Contrasto(c);
   ObjectSetInteger(0,nm,OBJPROP_STATE,false);          // il clic lo preme: lo stato si legge dal colore
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,on ? c : SW_Dim(c,C'20,22,26',0.78));
   ObjectSetInteger(0,nm,OBJPROP_COLOR,on ? fg : C'175,178,186');
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,on ? fg : c);
   ObjectSetString(0,nm,OBJPROP_TOOLTIP,gObjTxt[o]+(on ? ": ACCESO (clic = spegni)" : ": spento (clic = accendi)"));
  }

void UpdateButtons()
  {
   for(int o=0;o<PG_NO;o++)
     {
      MakeButton(o);
      PaintButton(o);
     }
  }

bool ButtonsMissing()
  {
   for(int o=0;o<PG_NO;o++)
      if(ObjectFind(0,ObjName(o))<0)
         return true;
   return false;
  }

//+------------------------------------------------------------------+
//| Buffer mostrati dai buffer di calcolo, secondo i tasti             |
//| (niente ricalcolo: un clic riscrive solo cio' che si vede)        |
//+------------------------------------------------------------------+
void FillDisplay(const int from,const int to)
  {
   int n=to;
   if(n>ArraySize(bE200)) n=ArraySize(bE200);
   if(n>ArraySize(kE200)) n=ArraySize(kE200);
   int i0=(from<0) ? 0 : from;
   bool onHa=gOn[PG_T_HA];
   bool on1=(gOn[PG_T_ST] && InpStMostra1);
   bool on3=(gOn[PG_T_ST] && InpStMostra3);
   for(int i=i0;i<n;i++)
     {
      bE200[i]=PG_MostraDa(gOn[PG_T_EMA200],i,gP200-1,kE200[i]);
      bE50[i] =PG_MostraDa(gOn[PG_T_EMA50],i,gP50-1,kE50[i]);
      bE9[i]  =PG_MostraDa(gOn[PG_T_EMA921],i,gP9-1,kE9[i]);
      bE21[i] =PG_MostraDa(gOn[PG_T_EMA921],i,gP21-1,kE21[i]);
      bBBu[i] =PG_Mostra(gOn[PG_T_BB],kBBu[i]);
      bBBm[i] =PG_Mostra(gOn[PG_T_BB],kBBm[i]);
      bBBl[i] =PG_Mostra(gOn[PG_T_BB],kBBl[i]);
      bStSu[i] =PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],1.0);
      bStGiu[i]=PG_StLinea(gOn[PG_T_ST],kDir[i],kVal[i],-1.0);
      bSt1Su[i] =PG_StLinea(on1,kDir1[i],kVal1[i],1.0);
      bSt1Giu[i]=PG_StLinea(on1,kDir1[i],kVal1[i],-1.0);
      bSt3Su[i] =PG_StLinea(on3,kDir3[i],kVal3[i],1.0);
      bSt3Giu[i]=PG_StLinea(on3,kDir3[i],kVal3[i],-1.0);
      if(onHa)
        {
         bHo[i]=kHo[i];
         bHh[i]=kHh[i];
         bHl[i]=kHl[i];
         bHc[i]=kHc[i];
         bHcol[i]=(kHc[i]>=kHo[i]) ? 0.0 : 1.0;
        }
      else
        {
         bHo[i]=PG_VUOTO;
         bHh[i]=PG_VUOTO;
         bHl[i]=PG_VUOTO;
         bHc[i]=PG_VUOTO;
         bHcol[i]=0.0;
        }
     }
  }

//+------------------------------------------------------------------+
//| Testi in italiano                                                |
//+------------------------------------------------------------------+
string PrezzoIt(const double p)
  {
   return PG_Migliaia(DoubleToString(p,_Digits));
  }

string NumIt(const double v,const int dg)
  {
   return PG_Migliaia(DoubleToString(v,dg));
  }

string HM(const datetime t)
  {
   if(t<=0) return "-";
   return TimeToString(t,TIME_DATE|TIME_MINUTES);
  }

string TfName()
  {
   string s=EnumToString((ENUM_TIMEFRAMES)_Period);
   StringReplace(s,"PERIOD_","");
   return s;
  }

// nome breve di un TF qualsiasi (PERIOD_H1 -> "H1"), per la scritta "EMA200 H1"
string TfNameOf(const ENUM_TIMEFRAMES tf)
  {
   string s=EnumToString(tf);
   StringReplace(s,"PERIOD_","");
   return s;
  }

//+------------------------------------------------------------------+
//| LIVELLI NOMINATI: lettura dei dati (una volta per barra nuova, o  |
//| dal timer se i dati non erano pronti)                            |
//+------------------------------------------------------------------+
bool RefreshDay()
  {
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(_Symbol,PERIOD_D1,0,10,r);
   if(got<2)
      return false;
   datetime tt[];
   ArrayResize(tt,got);
   for(int i=0;i<got;i++)
      tt[i]=r[i].time;
   int o=got-1;
   gDayT=r[o].time;
   gLv[3]=r[o].open;
   gLv[4]=r[o].high;
   gLv[5]=r[o].low;
   gLvOk[3]=true;
   gLvOk[4]=true;
   gLvOk[5]=true;
   int p=PG_GiornoPrec(tt,got,QuotaSabato(tt,got));
   if(p<0)
     {
      gLvOk[0]=false;
      gLvOk[1]=false;
      gLvOk[2]=false;
      return true;
     }
   gLv[0]=r[p].high;
   gLv[1]=r[p].low;
   gLv[2]=r[p].close;
   gLvOk[0]=true;
   gLvOk[1]=true;
   gLvOk[2]=true;
   return true;
  }

// il simbolo quota il SABATO (cripto)? Allora ogni barra D1 e' un giorno. Si guarda nei DATI, non nella
// sessione dichiarata dal broker (non verificabile qui, classe 1069): fra le ultime D1 lette (10 = almeno
// un sabato per chi quota 7 giorni su 7) ce n'e' una di sabato? Il forex, che al massimo ha la candela
// della DOMENICA sera, non ne ha mai.
bool QuotaSabato(const datetime &t[],const int n)
  {
   for(int i=0;i<n;i++)
      if(PG_Dow(t[i])==6)
         return true;
   return false;
  }

bool RefreshPrev(const ENUM_TIMEFRAMES tf,const int iMax,const int iMin)
  {
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(_Symbol,tf,0,3,r);
   if(got<2)
      return false;
   gLv[iMax]=r[got-2].high;
   gLv[iMin]=r[got-2].low;
   gLvOk[iMax]=true;
   gLvOk[iMin]=true;
   return true;
  }

bool RefreshNight()
  {
   datetime now=TimeCurrent();
   if(now<=0)
      return false;
   int daH=ClampI(InpNotteDaOra,0,23,"InpNotteDaOra");
   int daM=ClampI(InpNotteDaMin,0,59,"InpNotteDaMin");
   int aH=ClampI(InpNotteAOra,0,23,"InpNotteAOra");
   int aM=ClampI(InpNotteAMin,0,59,"InpNotteAMin");
   int fails=0;
   for(int back=0;back<7;back++)
     {
      datetime ts=0, te=0;
      PG_NotteFinestra(now,back,daH,daM,aH,aM,ts,te);
      if(ts>now)
         continue;                          // la notte di questa data non e' ancora cominciata
      MqlRates r[];
      ArraySetAsSeries(r,false);
      int got=CopyRates(_Symbol,PERIOD_M1,ts,te,r);
      if(got<=0)
        {
         if(got<0) fails++;
         continue;                          // notte senza quotazioni (weekend, festivo) o non pronta: quella prima
        }
      double hi=r[0].high, lo=r[0].low;
      for(int i=1;i<got;i++)
        {
         if(r[i].high>hi) hi=r[i].high;
         if(r[i].low<lo)  lo=r[i].low;
        }
      gLv[10]=hi;
      gLv[11]=lo;
      gLvOk[10]=true;
      gLvOk[11]=true;
      gNightTS=ts;
      gNightTE=te;
      return true;
     }
   gLvOk[10]=false;
   gLvOk[11]=false;
   return (fails==0);       // tutte vuote = niente notte da mostrare; qualche errore = si riprova
  }

bool RefreshH4()
  {
   gH4Stale=false;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(_Symbol,PERIOD_H4,0,gH4N,r);
   if(got<2*gH4K+3)
      return false;
   double hh[], ll[];
   ArrayResize(hh,got);
   ArrayResize(ll,got);
   for(int i=0;i<got;i++)
     {
      hh[i]=r[i].high;
      ll[i]=r[i].low;
     }
   int ih=PG_UltimoSwing(hh,ll,got,gH4K,true);
   int il=PG_UltimoSwing(hh,ll,got,gH4K,false);
   gLvOk[14]=(ih>=0);
   gLvOk[15]=(il>=0);
   if(ih>=0) gLv[14]=hh[ih];
   if(il>=0) gLv[15]=ll[il];
   return true;
  }

double TondoPasso()
  {
   if(InpTondoPasso>0.0)
      return InpTondoPasso;
   long cm=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_CALC_MODE);
   bool fx=(cm==SYMBOL_CALC_MODE_FOREX || cm==SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE);
   bool oro=(StringFind(_Symbol,"XAU")>=0 || StringFind(_Symbol,"GOLD")>=0);
   double px=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(px<=0.0) px=gPrice;
   return PG_PassoAuto(fx,oro,_Digits,px);
  }

// legge tutte le famiglie accese; gLivPending = qualcosa non pronto (il timer riprova)
void RefreshLevels()
  {
   bool ok=true;
   if(gLvOn[0] || gLvOn[1] || gLvOn[2] || gLvOn[3] || gLvOn[4] || gLvOn[5])
      ok=RefreshDay() && ok;
   if(gLvOn[6] || gLvOn[7])
      ok=RefreshPrev(PERIOD_W1,6,7) && ok;
   if(gLvOn[8] || gLvOn[9])
      ok=RefreshPrev(PERIOD_MN1,8,9) && ok;
   if(gLvOn[10] || gLvOn[11])
      ok=RefreshNight() && ok;
   if(gLvOn[14] || gLvOn[15])
      ok=RefreshH4() && ok;
   if(gLvOn[12] || gLvOn[13])
      gTondoPasso=TondoPasso();
   gLivPending=!ok;
   gLivTryMs=GetTickCount();
   gLivFullMs=gLivTryMs;
   if(ok)
      gLivTries=0;
   else
      gLivTries++;
   LiveLevels();
  }

// a ogni tick, senza leggere dati: oggi e notte in corso si allargano col prezzo; numeri tondi; H4 superato
void LiveLevels()
  {
   double p=gPrice;
   if(p<=0.0)
      return;
   if(gLvOk[4] && p>gLv[4]) gLv[4]=p;
   if(gLvOk[5] && p<gLv[5]) gLv[5]=p;
   datetime now=TimeCurrent();
   if(gLvOk[10] && now>=gNightTS && now<gNightTE+60)
     {
      if(p>gLv[10]) gLv[10]=p;
      if(p<gLv[11]) gLv[11]=p;
     }
   if(gLvOn[12] || gLvOn[13])
     {
      double so=0.0, st=0.0;
      PG_Tondi(p,gTondoPasso,_Digits,so,st);
      gLv[12]=so;
      gLv[13]=st;
      gLvOk[12]=(gTondoPasso>0.0);
      gLvOk[13]=(gTondoPasso>0.0);
     }
   if(gLvOk[14] && p>gLv[14]) gH4Stale=true;      // superato: al prossimo giro del timer si cerca il precedente
   if(gLvOk[15] && p<gLv[15]) gH4Stale=true;
  }

color LevelColor(const int i,const double p)
  {
   bool res=(p>gPrice);
   switch(gLvFam[i])
     {
      case 0: return res ? InpColResGiorno : InpColSupGiorno;
      case 1: return res ? InpColResSett   : InpColSupSett;
      case 2: return res ? InpColResMese   : InpColSupMese;
      case 3: return res ? InpColResNotte  : InpColSupNotte;
      case 4: return res ? InpColResTondo  : InpColSupTondo;
     }
   return res ? InpColResH4 : InpColSupH4;
  }

//+------------------------------------------------------------------+
//| LINEE CON ETICHETTA (livelli + ordine)                            |
//+------------------------------------------------------------------+
void AddItem(const double p,const string txt,const color col,const int sty)
  {
   if(gItN>=PG_MAXIT)
      return;
   gItP[gItN]=p;
   gItTxt[gItN]=txt;
   gItCol[gItN]=col;
   gItSty[gItN]=sty;
   gItN++;
  }

// livelli accesi e pronti, dal piu' alto; prezzi UGUALI (entro mezzo punto) fusi in una riga sola:
// "MAX GIORNO PRECEDENTE / MAX SETTIMANA PRECEDENTE 24.998,25"
void AddLevelItems()
  {
   int idx[PG_NLIV];
   int m=0;
   for(int i=0;i<PG_NLIV;i++)
      if(gLvOn[i] && gLvOk[i] && gLv[i]>0.0)
        {
         idx[m]=i;
         m++;
        }
   for(int a=1;a<m;a++)                    // ordinamento per prezzo decrescente (m <= 16)
     {
      int v=idx[a];
      int b=a-1;
      while(b>=0 && gLv[idx[b]]<gLv[v])
        {
         idx[b+1]=idx[b];
         b--;
        }
      idx[b+1]=v;
     }
   double eps=_Point*0.5;
   int k=0;
   while(k<m)
     {
      int first=idx[k];
      string name=gLvName[first];
      int sty=gLvSty[first];
      int j=k+1;
      while(j<m && MathAbs(gLv[idx[j]]-gLv[first])<eps)
        {
         name=name+" / "+gLvName[idx[j]];
         if(gLvSty[idx[j]]==STYLE_SOLID) sty=STYLE_SOLID;
         j++;
        }
      double p=gLv[first];
      AddItem(p,name+" "+PrezzoIt(p),LevelColor(first,p),sty);
      k=j;
     }
  }

void AddOrderItems()
  {
   if(gSuCode!=0)
      return;
   AddItem(gSuE, "INGRESSO "+PrezzoIt(gSuE), InpColIngresso,STYLE_DASH);
   AddItem(gSuS, "STOP LOSS "+PrezzoIt(gSuS),InpStopCol,    STYLE_DASH);
   AddItem(gSuT1,"TP1 "+PrezzoIt(gSuT1),     InpColTP,      STYLE_DASH);
   AddItem(gSuT2,"TP2 "+PrezzoIt(gSuT2),     InpColTP,      STYLE_DASH);
   AddItem(gSuT3,"TP3 "+PrezzoIt(gSuT3),     InpColTP,      STYLE_DASH);
  }

// ricrea/aggiorna le linee SOLO se la firma e' cambiata. true = qualcosa e' cambiato sul grafico
bool DrawItems()
  {
   string sig="";
   for(int k=0;k<gItN;k++)
      sig+=gItTxt[k]+"|"+IntegerToString((long)gItCol[k])+"|"+IntegerToString(gItSty[k])+";";
   bool present=(gItN==0 || ObjectFind(0,PFX+"H0")>=0);
   if(sig==gItSig && gItDrawn==gItN && present)
      return false;
   int fs=gLivFs;
   for(int k=0;k<gItN;k++)
     {
      string nl=PFX+"H"+IntegerToString(k);
      if(ObjectFind(0,nl)<0)
        {
         ObjectCreate(0,nl,OBJ_HLINE,0,0,gItP[k]);
         ObjectSetInteger(0,nl,OBJPROP_WIDTH,1);
         ObjectSetInteger(0,nl,OBJPROP_BACK,true);
         ObjectSetInteger(0,nl,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,nl,OBJPROP_HIDDEN,true);
        }
      ObjectSetDouble(0,nl,OBJPROP_PRICE,gItP[k]);
      ObjectSetInteger(0,nl,OBJPROP_COLOR,gItCol[k]);
      ObjectSetInteger(0,nl,OBJPROP_STYLE,gItSty[k]);
      ObjectSetString(0,nl,OBJPROP_TOOLTIP,gItTxt[k]);
      string nt=PFX+"T"+IntegerToString(k);
      if(ObjectFind(0,nt)<0)
        {
         ObjectCreate(0,nt,OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,nt,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,nt,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
         ObjectSetString(0,nt,OBJPROP_FONT,"Arial");
         ObjectSetInteger(0,nt,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(0,nt,OBJPROP_HIDDEN,true);
        }
      ObjectSetInteger(0,nt,OBJPROP_FONTSIZE,fs);
      ObjectSetInteger(0,nt,OBJPROP_COLOR,gItCol[k]);
      ObjectSetString(0,nt,OBJPROP_TEXT,gItTxt[k]);
      gLabY[k]=-1000000;                    // posizione da riscrivere
      gLabX[k]=-1000000;
     }
   for(int k=gItN;k<gItDrawn;k++)
     {
      ObjectDelete(0,PFX+"H"+IntegerToString(k));
      ObjectDelete(0,PFX+"T"+IntegerToString(k));
     }
   gItDrawn=gItN;
   gItSig=sig;
   return true;
  }

// etichette al bordo DESTRO, appena sopra la loro linea, impilate senza accavallarsi; a sinistra del
// pannello OPERAZIONE se cadrebbero sotto di esso; nascoste se la linea e' fuori dallo schermo
bool Reposition()
  {
   if(gItN<=0 || gCurT<=0)
      return false;
   int hgt=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   int ys[PG_MAXIT];
   int ord[PG_MAXIT];
   int nv=0;
   for(int k=0;k<gItN;k++)
     {
      int x=0, y=0;
      bool ok=ChartTimePriceToXY(0,0,gCurT,gItP[k],x,y);
      if(!ok || y<0 || (hgt>0 && y>hgt))
        {
         ys[k]=-1;
         continue;
        }
      ys[k]=y;
      int b=nv-1;                            // inserimento ordinato per y crescente
      while(b>=0 && ys[ord[b]]>y)
        {
         ord[b+1]=ord[b];
         b--;
        }
      ord[b+1]=k;
      nv++;
     }
   int yin[PG_MAXIT];
   int yout[PG_MAXIT];
   for(int i=0;i<nv;i++)
      yin[i]=ys[ord[i]];
   PG_Impila(yin,nv,gLabGap,yout);
   bool chg=false;
   for(int k=0;k<gItN;k++)
     {
      if(ys[k]<0 && gLabY[k]!=-1)
        {
         ObjectSetInteger(0,PFX+"T"+IntegerToString(k),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         gLabY[k]=-1;
         chg=true;
        }
     }
   for(int i=0;i<nv;i++)
     {
      int k=ord[i];
      int y=yout[i];
      int x=(gOn[PG_T_ORD] && gPanW>0 && y<=gPanBottom+gLabGap) ? gPanW+16 : 6;
      if(y==gLabY[k] && x==gLabX[k])
         continue;
      string nt=PFX+"T"+IntegerToString(k);
      if(gLabY[k]<0)
         ObjectSetInteger(0,nt,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetInteger(0,nt,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,nt,OBJPROP_YDISTANCE,y);
      gLabY[k]=y;
      gLabX[k]=x;
      chg=true;
     }
   return chg;
  }

//+------------------------------------------------------------------+
//| PANNELLO OPERAZIONE in alto a DESTRA (forma della SuperWave v4.1) |
//+------------------------------------------------------------------+
void LblR(const string name,const int x,const int y,const string text,const color col,const int fs)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString (0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fs);
   ObjectSetString (0,name,OBJPROP_FONT,"Consolas");
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }

void RectR(const string name,const int x,const int y,const int w,const int h,const color bg,const color border)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_COLOR,border);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }

string StateTxt()
  {
   string tp=(gHitBest>0) ? ("TP"+IntegerToString(gHitBest)) : "";
   if(gHitState==0) return "stato: APERTO, nessun TP ne' stop toccato";
   if(gHitState>=1 && gHitState<=3) return "stato: "+tp+" raggiunto "+HM(gHitTpT)+", stop mai toccato";
   if(gHitState==4) return "stato: INVALIDATO, stop toccato "+HM(gHitStopT);
   if(gHitState==5) return "stato: "+tp+" "+HM(gHitTpT)+", poi stop "+HM(gHitStopT);
   return "stato: stop e TP nella stessa barra "+HM(gHitStopT)+" (ordine non noto)";
  }

string WhyTxt()
  {
   if(gSuCode<0) return "in attesa del primo calcolo";
   if(gSuCode==1) return "nessuna inversione del Supertrend "+NumIt(gSuM,1)+" nelle ultime "+IntegerToString(gSuNoFlipBars)+" barre "+TfName();
   if(gSuCode==2) return "inversione troppo vicina all'inizio dello storico del grafico (servono "+IntegerToString(SW_TRUST_BARS)+" barre prima)";
   return "stop dal lato sbagliato dell'ingresso alla barra di inversione";
  }

bool DeletePanel()
  {
   if(gPanSig=="")
      return false;
   ObjectsDeleteAll(0,PFX+"q_");
   gPanSig="";
   gPanW=0;
   gPanBottom=0;
   return true;
  }

bool DrawWaitPanel()
  {
   string q=PFX+"q_";
   string why=WhyTxt();
   string sig="WAIT|"+_Symbol+"|"+why;
   if(sig==gPanSig && ObjectFind(0,q+"bg")>=0)
      return false;
   ObjectsDeleteAll(0,q);
   int RM=8, BW=178, LH=15, y=20;
   int wl=StringLen(why)*6+14;
   if(wl>BW && wl<420) BW=wl;
   string warn="SETUP INDICATIVO - NON VALIDATO: i lotti sono indicativi";
   if(StringLen(warn)*6+14>BW) BW=StringLen(warn)*6+14;
   RectR(q+"bg", RM, y-4, BW, LH*5+8, InpPanelCol, InpGridCol);
   LblR(q+"t",   RM+6, y,      "OPERAZIONE  "+_Symbol, InpHeadCol, InpFont+1);
   LblR(q+"dir", RM+6, y+LH,   "in attesa di inversione", C'140,144,150', InpFont);
   LblR(q+"why", RM+6, y+2*LH, (StringLen(why)<=66 ? why : StringSubstr(why,0,63)+"..."), C'140,144,150', InpFont-1);
   LblR(q+"note",RM+6, y+3*LH, "TF del grafico "+TfName(), C'140,144,150', InpFont-1);
   LblR(q+"warn",RM+6, y+4*LH, warn, C'230,180,60', InpFont-1);
   ObjectSetString(0,q+"bg",OBJPROP_TOOLTIP,why);
   gPanSig=sig;
   gPanW=BW+RM;
   gPanBottom=y-4+LH*5+8;
   return true;
  }

bool DrawTradePanel()
  {
   string q=PFX+"q_";
   int RM=8, BW=178, LH=15, y=20;
   int dir=gSuD;
   double entry=gSuE, stop=gSuS;
   double risk=MathAbs(entry-stop);
   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   string cur=AccountInfoString(ACCOUNT_CURRENCY);
   double riskMoney=bal*InpRiskPct/100.0;
   double tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tickVal<=0.0) tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double tickSz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double totLots=PG_LottiTotali(riskMoney,risk,tickSz,tickVal);
   double vst=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double vmn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double vmx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   int f1=0, f2=0, f3=0, ft=0;
   double L1=SW_NormLots(totLots*InpSize1/100.0,vst,vmn,vmx,f1);
   double L2=SW_NormLots(totLots*InpSize2/100.0,vst,vmn,vmx,f2);
   double L3=SW_NormLots(totLots*InpSize3/100.0,vst,vmn,vmx,f3);
   double LT=SW_NormLots(totLots,vst,vmn,vmx,ft);
   int ldg=PG_CifreLotto(vst);
   if(ldg<2) ldg=2;
   double slPts=(_Point>0.0) ? risk/_Point : 0.0;
   color ecol=(dir>0) ? InpBuyCol : InpSellCol;
   datetime fixT=gSuFiT+PeriodSeconds(_Period);        // chiusura della barra di inversione
   string sDir="Setup "+TfName()+" "+(dir>0 ? "BUY" : "SELL")+", fissato alle "+TimeToString(fixT,TIME_MINUTES);
   string sIn ="Ingresso  "+PrezzoIt(entry)+" (barra di inversione)";
   string sSl ="Stop  "+PrezzoIt(stop)+"  ("+NumIt(slPts,0)+" pt)";
   string s1="TP1 ("+NumIt(InpTP1_R,1)+"R)  "+PrezzoIt(gSuT1)+"   "+NumIt(L1,ldg);
   string s2="TP2 ("+NumIt(InpTP2_R,1)+"R)  "+PrezzoIt(gSuT2)+"   "+NumIt(L2,ldg);
   string s3="TP3 ("+NumIt(InpTP3_R,1)+"R)  "+PrezzoIt(gSuT3)+"   "+NumIt(L3,ldg);
   string sR="Rischio "+NumIt(InpRiskPct,1)+"% = "+NumIt(riskMoney,2)+" "+cur+"  (tot "+NumIt(LT,ldg)+" lot)";
   string sN="size divisa "+NumIt(InpSize1,0)+"/"+NumIt(InpSize2,0)+"/"+NumIt(InpSize3,0)+"%  lotti indicativi";
   string sFix="ingresso fisso a "+HM(fixT)+" | TF del grafico";
   string sSt;
   if(risk>0.0)
     {
      double dist=(gHitPrice-entry)*dir;
      double pts=(_Point>0.0) ? dist/_Point : 0.0;
      sSt="prezzo "+(pts>=0.0 ? "+" : "")+NumIt(pts,0)+" pt ("+(dist>=0.0 ? "+" : "")+NumIt(dist/risk,2)+"R)";
     }
   else
      sSt="prezzo: n/d";
   string sSt2=StateTxt();
   string warn="SETUP INDICATIVO - NON VALIDATO: i lotti sono indicativi";
   string lotNote="";
   if(f1==1 || f2==1 || f3==1) lotNote+=" | una quota e' SOTTO il lotto minimo: 0";
   if(f1==2 || f2==2 || f3==2 || ft==2) lotNote+=" | lotto tagliato al MASSIMO del simbolo";
   string sig=sDir+sIn+sSl+s1+s2+s3+sR+sN+sFix+sSt+sSt2+lotNote;
   if(sig==gPanSig && ObjectFind(0,q+"bg")>=0)
      return false;
   if(StringFind(gPanSig,"WAIT|")==0 || ObjectFind(0,q+"why")>=0) ObjectsDeleteAll(0,q);   // niente righe orfane del pannello d'attesa
   //--- larghezza dal testo piu' lungo (Consolas: ~6 px per carattere a 8 pt, ~7 px a 9 pt)
   int wmax=StringLen(sDir)*7;
   string rows[12];
   rows[0]=sIn; rows[1]=sSl; rows[2]=s1; rows[3]=s2; rows[4]=s3; rows[5]=sR; rows[6]=sN;
   rows[7]=sFix; rows[8]=sSt; rows[9]=sSt2; rows[10]="OPERAZIONE  "+_Symbol; rows[11]=warn;
   for(int i=0;i<12;i++) if(StringLen(rows[i])*6>wmax) wmax=StringLen(rows[i])*6;
   if(wmax+14>BW) BW=wmax+14;
   int BH=LH*14+8;
   RectR(q+"bg", RM, y-4, BW, BH, InpPanelCol, InpGridCol);
   LblR(q+"t",   RM+6, y,        "OPERAZIONE  "+_Symbol, InpHeadCol, InpFont+1);
   LblR(q+"dir", RM+6, y+LH,     sDir, ecol, InpFont+1);
   LblR(q+"in",  RM+6, y+2*LH,   sIn,  InpTextCol, InpFont);
   LblR(q+"sl",  RM+6, y+3*LH,   sSl,  InpStopCol, InpFont);
   LblR(q+"h",   RM+6, y+4*LH,   "TARGET           prezzo      lotti", InpHeadCol, InpFont-1);
   LblR(q+"tp1", RM+6, y+5*LH,   s1,   InpColTP, InpFont);
   LblR(q+"tp2", RM+6, y+6*LH,   s2,   InpColTP, InpFont);
   LblR(q+"tp3", RM+6, y+7*LH,   s3,   InpColTP, InpFont);
   LblR(q+"risk",RM+6, y+8*LH,   sR,   InpTextCol, InpFont);
   LblR(q+"note",RM+6, y+9*LH,   sN,   C'140,144,150', InpFont-1);
   LblR(q+"fix", RM+6, y+10*LH,  sFix, C'140,144,150', InpFont-1);
   LblR(q+"st",  RM+6, y+11*LH,  sSt,  InpTextCol, InpFont-1);
   LblR(q+"st2", RM+6, y+12*LH,  sSt2, (gHitState==4 ? InpStopCol : InpTextCol), InpFont-1);
   LblR(q+"warn",RM+6, y+13*LH,  warn, C'230,180,60', InpFont-1);
   string tip="Setup "+TfName()+" "+(dir>0 ? "BUY" : "SELL")+" su "+_Symbol+
              "\ningresso FISSO = chiusura della barra di inversione del Supertrend "+NumIt(gSuM,1)+
              " (barra "+HM(gSuFiT)+", fissato alle "+HM(fixT)+")"+
              "\nstop = Supertrend su quella barra; R = "+NumIt(slPts,0)+" pt; resta fisso fino alla prossima inversione"+
              "\nlotti indicativi (rischio % del saldo, quote 40/30/30): NON e' un ordine, NON e' un segnale validato"+lotNote;
   ObjectSetString(0,q+"bg",OBJPROP_TOOLTIP,tip);
   ObjectSetString(0,q+"dir",OBJPROP_TOOLTIP,tip);
   gPanSig=sig;
   gPanW=BW+RM;
   gPanBottom=y-4+BH;
   return true;
  }

//+------------------------------------------------------------------+
//| Tutto cio' che e' oggetto (livelli, ordine, pannello): ricostruito |
//| dallo stato, ridisegnato SOLO se cambia                          |
//+------------------------------------------------------------------+
bool UpdateOverlay()
  {
   if(!gOn[PG_T_LIV] && !gOn[PG_T_ORD] && gItDrawn==0 && gPanSig=="")
      return false;                         // grafico pulito: zero lavoro
   bool chg=false;
   if(gOn[PG_T_ORD])
     {
      if(gSuCode==0) chg=DrawTradePanel() || chg;
      else           chg=DrawWaitPanel() || chg;
     }
   else
      chg=DeletePanel() || chg;
   gItN=0;
   if(gOn[PG_T_LIV])
      AddLevelItems();
   if(gOn[PG_T_ORD])
      AddOrderItems();
   chg=DrawItems() || chg;
   chg=Reposition() || chg;
   return chg;
  }

//+------------------------------------------------------------------+
//| SETUP ORDINE CONSIGLIATO: si fissa a ogni barra nuova; a ogni tick |
//| si guardano solo i tocchi della barra in formazione               |
//+------------------------------------------------------------------+
void EvalSetup(const datetime &time[],const double &high[],const double &low[],const double &close[],
               const int rt,const bool nb)
  {
   if(rt<3)
      return;
   if(nb || gSuCode<0)
     {
      int fi=-1, d=0;
      double e=0.0, s=0.0;
      gSuCode=PG_Setup(close,kDir2,kVal2,rt-2,gStP+1,SW_TRUST_BARS,fi,d,e,s);
      gSuFi=fi;
      gSuD=d;
      gSuE=e;
      gSuS=s;
      gSuFiT=(fi>=0) ? time[fi] : 0;
      gSuNoFlipBars=rt-2-(gStP+1);
      gCS=-1; gC1=-1; gC2=-1; gC3=-1;
      if(gSuCode==0)
        {
         double rk=MathAbs(e-s);
         gSuT1=PG_Tp(d,e,rk,InpTP1_R);
         gSuT2=PG_Tp(d,e,rk,InpTP2_R);
         gSuT3=PG_Tp(d,e,rk,InpTP3_R);
         // tocchi sulle barre CHIUSE dopo quella di inversione (l'ingresso e' la SUA chiusura)
         SW_Hits(high,low,fi+1,rt-1,d,s,gSuT1,gSuT2,gSuT3,gCS,gC1,gC2,gC3);
        }
     }
   if(gSuCode!=0)
      return;
   int fs=-1, f1=-1, f2=-1, f3=-1;
   SW_Hits(high,low,rt-1,rt,gSuD,gSuS,gSuT1,gSuT2,gSuT3,fs,f1,f2,f3);   // barra in formazione
   int iS=(gCS>=0) ? gCS : fs;
   int i1=(gC1>=0) ? gC1 : f1;
   int i2=(gC2>=0) ? gC2 : f2;
   int i3=(gC3>=0) ? gC3 : f3;
   gHitState=SW_SetupState(iS,i1,i2,i3,gHitBest);
   gHitStopT=(iS>=0) ? time[iS] : 0;
   gHitTpT=0;
   if(gHitBest==1) gHitTpT=time[i1];
   if(gHitBest==2) gHitTpT=time[i2];
   if(gHitBest==3) gHitTpT=time[i3];
   gHitPrice=close[rt-1];
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   gInitOk=false;
   gColsHidden=false;
   gHealCount=0;
   gRT=0;
   gAnchorIdx=-1;
   gAnchorT=0;
   gLastBarT=0;
   gCurT=0;
   gPrice=0.0;
   gSuCode=-1;
   gItN=0;
   gItSig="";
   gItDrawn=0;
   gPanSig="";
   gPanW=0;
   gPanBottom=0;
   gLivPending=false;
   gLivTries=0;
   gH4Stale=false;
   gDayT=0;
   gD1Seen=0;
   for(int i=0;i<PG_NLIV;i++)
     {
      gLv[i]=0.0;
      gLvOk[i]=false;
     }

   //--- parametri effettivi
   gP200=ClampI(InpEma200,1,5000,"InpEma200");
   gP50 =ClampI(InpEma50,1,5000,"InpEma50");
   gP9  =ClampI(InpEma9,1,5000,"InpEma9");
   gP21 =ClampI(InpEma21,1,5000,"InpEma21");
   gBBP =ClampI(InpBBPeriodo,1,200,"InpBBPeriodo");
   gStP =ClampI(InpStPeriodo,1,200,"InpStPeriodo");
   gBBD =ClampD(InpBBDev,0.01,10.0,2.0,"InpBBDev");
   gStM =ClampD(InpStMolt,0.01,20.0,3.0,"InpStMolt");
   gSuM =ClampD(InpSetupMolt,0.01,20.0,3.5,"InpSetupMolt");
   gH4K =ClampI(InpH4Ampiezza,1,20,"InpH4Ampiezza");
   gH4N =ClampI(InpH4Barre,20,5000,"InpH4Barre");
   gLvOn[0]=InpLiv_GiornoPrecMax;  gLvOn[1]=InpLiv_GiornoPrecMin;  gLvOn[2]=InpLiv_GiornoPrecChiusura;
   gLvOn[3]=InpLiv_OggiApertura;   gLvOn[4]=InpLiv_OggiMax;        gLvOn[5]=InpLiv_OggiMin;
   gLvOn[6]=InpLiv_SettPrecMax;    gLvOn[7]=InpLiv_SettPrecMin;
   gLvOn[8]=InpLiv_MesePrecMax;    gLvOn[9]=InpLiv_MesePrecMin;
   gLvOn[10]=InpLiv_NotteMax;      gLvOn[11]=InpLiv_NotteMin;
   gLvOn[12]=InpLiv_TondoSopra;    gLvOn[13]=InpLiv_TondoSotto;
   gLvOn[14]=InpLiv_H4Max;         gLvOn[15]=InpLiv_H4Min;
   double dpi=(double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   if(dpi<=0.0) dpi=96.0;
   gLivFs=ClampI(InpLivFont,5,20,"InpLivFont");
   gLabGap=(int)MathRound(gLivFs*dpi/72.0)+3;
   ArrayResize(gItP,PG_MAXIT);
   ArrayResize(gItTxt,PG_MAXIT);
   ArrayResize(gItCol,PG_MAXIT);
   ArrayResize(gItSty,PG_MAXIT);
   ArrayResize(gLabY,PG_MAXIT);
   ArrayResize(gLabX,PG_MAXIT);

   bool ok=true;
   ok=SetIndexBuffer(0, bHo,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(1, bHh,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(2, bHl,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(3, bHc,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(4, bHcol, INDICATOR_COLOR_INDEX)  && ok;
   ok=SetIndexBuffer(5, bBBu,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(6, bBBm,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(7, bBBl,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(8, bStSu, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(9, bStGiu,INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(10,bE9,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(11,bE21,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(12,bE50,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(13,bE200, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(14,kE9,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(15,kE21,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(16,kE50,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(17,kE200, INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(18,kBBu,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(19,kBBm,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(20,kBBl,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(21,kAtr,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(22,kUp,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(23,kDn,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(24,kDir,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(25,kVal,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(26,kUp2,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(27,kDn2,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(28,kDir2, INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(29,kVal2, INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(30,kHo,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(31,kHh,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(32,kHl,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(33,kHc,   INDICATOR_CALCULATIONS) && ok;
   if(!ok)
     {
      Print("ABTG_Pulsanti: SetIndexBuffer fallito, errore ",GetLastError());
      return INIT_FAILED;
     }
   for(int p=0;p<10;p++)
      PlotIndexSetDouble(p,PLOT_EMPTY_VALUE,PG_VUOTO);
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,InpColHaSu);
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,InpColHaGiu);
   PlotIndexSetInteger(1,PLOT_LINE_COLOR,InpColBB);
   PlotIndexSetInteger(2,PLOT_LINE_COLOR,InpColBB);
   PlotIndexSetInteger(3,PLOT_LINE_COLOR,InpColBB);
   PlotIndexSetInteger(4,PLOT_LINE_COLOR,InpColStSu);
   PlotIndexSetInteger(5,PLOT_LINE_COLOR,InpColStGiu);
   PlotIndexSetInteger(6,PLOT_LINE_COLOR,InpColEma9);
   PlotIndexSetInteger(7,PLOT_LINE_COLOR,InpColEma21);
   PlotIndexSetInteger(8,PLOT_LINE_COLOR,InpColEma50);
   PlotIndexSetInteger(9,PLOT_LINE_COLOR,InpColEma200);
   PlotIndexSetString(6,PLOT_LABEL,"EMA "+IntegerToString(gP9));
   PlotIndexSetString(7,PLOT_LABEL,"EMA "+IntegerToString(gP21));
   PlotIndexSetString(8,PLOT_LABEL,"EMA "+IntegerToString(gP50));
   PlotIndexSetString(9,PLOT_LABEL,"EMA "+IntegerToString(gP200));
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   IndicatorSetString(INDICATOR_SHORTNAME,"ABTG Pulsanti Grafico");

   // oggetti orfani di un'istanza morta male: via, poi si ricreano quelli giusti
   ObjectsDeleteAll(0,PFX);
   LoadStates();
   SetupBar();
   UpdateButtons();
   gInitOk=true;
   if(gOn[PG_T_HA])
      ColsHide();     // ultimo passo: da qui OnDeinit ripristina sempre
   else
      RepairInvisibleNative();
   // timer SEMPRE acceso: autoriparazione (tasti, colori), livelli non pronti, etichette al bordo
   if(!EventSetTimer(1))
      Print("ABTG_Pulsanti: EventSetTimer fallito (errore ",GetLastError(),"): niente autoriparazione.");
   ChartRedraw(0);
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ColsRestore();                         // OGNI motivo di uscita: le candele native tornano
   ObjectsDeleteAll(0,PFX);
   if(reason==REASON_REMOVE || reason==REASON_CHARTCLOSE)
      GvClear();
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!gInitOk)
      return;
   bool redraw=false;
   //--- tasti spariti (per esempio l'OnDeinit dell'istanza vecchia arrivato DOPO questo OnInit)
   if(ButtonsMissing())
     {
      UpdateButtons();
      gItSig="";                    // anche linee e pannello: lo stesso ObjectsDeleteAll li ha tolti
      gPanSig="";
      redraw=true;
     }
   //--- HEIKIN ASHI acceso ma candele native di nuovo visibili: qualcuno le ha ripristinate dopo di noi
   if(gOn[PG_T_HA] && gHealCount<3 &&
      !(IsNone(CHART_COLOR_CANDLE_BULL) && IsNone(CHART_COLOR_CANDLE_BEAR) &&
        IsNone(CHART_COLOR_CHART_UP) && IsNone(CHART_COLOR_CHART_DOWN)))
     {
      gHealCount++;
      gColsHidden=false;            // si ricatturano i colori ATTUALI (quelli veri) e si rinascondono
      ColsHide();
      if(gHealCount>=3)
         Print("ABTG_Pulsanti: le candele native continuano a riapparire in HEIKIN ASHI: smetto di nasconderle.");
      redraw=true;
     }
   //--- livelli: dati non pronti (riprova ogni 5 s, poi ogni 30 s), H4 superato, rinfresco ogni 5 minuti
   if(gOn[PG_T_LIV])
     {
      uint now=GetTickCount();
      uint wait=(gLivTries<12) ? 5000 : 30000;
      if((gLivPending && now-gLivTryMs>=wait) || now-gLivFullMs>=300000)
         RefreshLevels();
      else
         if(gH4Stale)
           {
            RefreshH4();
            LiveLevels();
           }
     }
   if(UpdateOverlay())
      redraw=true;
   if(redraw)
      ChartRedraw(0);
  }

//+------------------------------------------------------------------+
void Toggle(const int t)
  {
   gOn[t]=!gOn[t];
   GvSave("S"+IntegerToString(t),gOn[t] ? 1.0 : 0.0);
   if(t==PG_T_HA)
     {
      if(gOn[t])
        {
         gHealCount=0;
         ColsHide();
        }
      else
         ColsRestore();
     }
   if(t==PG_T_LIV && gOn[t])
      RefreshLevels();              // un clic = livelli subito, anche a mercato chiuso
   if(t!=PG_T_LIV && t!=PG_T_ORD)
      FillDisplay(0,gRT);           // nessun ricalcolo: si riscrive solo cio' che si vede
   UpdateOverlay();
   for(int o=0;o<PG_NO;o++)
      if(gObjTog[o]==t)
         PaintButton(o);
   ChartRedraw(0);
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!gInitOk)
      return;
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      if(Reposition())              // scorrimento/zoom: le etichette seguono le linee
         ChartRedraw(0);
      return;
     }
   if(id!=CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam,PFX)!=0)    // guardia: solo i NOSTRI oggetti
      return;
   for(int o=0;o<PG_NO;o++)
      if(sparam==ObjName(o))
        {
         Toggle(gObjTog[o]);
         return;
        }
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],const double &high[],
                const double &low[],const double &close[],const long &tick_volume[],
                const long &volume[],const int &spread[])
  {
   // dati non pronti: lo stato dei tasti NON si tocca, si riprova al prossimo tick
   if(!gInitOk || rates_total<3)
      return 0;
   ArraySetAsSeries(time,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);

   //--- ricalcolo completo se il terminale lo chiede o se lo storico si e' spostato (ancora sull'ora, classe 965)
   bool full=(prev_calculated<=0 || prev_calculated>rates_total || gAnchorIdx<0);
   if(!full && (gAnchorIdx>=rates_total || time[gAnchorIdx]!=gAnchorT))
      full=true;
   int start=full ? 0 : prev_calculated-1;
   if(start<0)
      start=0;

   PG_EMA(close,rates_total,start,gP200,kE200);
   PG_EMA(close,rates_total,start,gP50,kE50);
   PG_EMA(close,rates_total,start,gP9,kE9);
   PG_EMA(close,rates_total,start,gP21,kE21);
   PG_BB(close,rates_total,start,gBBP,gBBD,kBBu,kBBm,kBBl);
   SW_STCore(high,low,close,rates_total,start,gStP,gStM,kAtr,kUp,kDn,kDir,kVal);
   SW_STCore(high,low,close,rates_total,start,gStP,gSuM,kAtr,kUp2,kDn2,kDir2,kVal2);
   PG_HA(open,high,low,close,rates_total,start,kHo,kHh,kHl,kHc);
   gRT=rates_total;
   FillDisplay(start,rates_total);

   gAnchorIdx=rates_total-1;
   gAnchorT=time[rates_total-1];
   bool nb=(full || time[rates_total-1]!=gLastBarT);
   gLastBarT=time[rates_total-1];
   gCurT=time[rates_total-1];
   gPrice=close[rates_total-1];

   EvalSetup(time,high,low,close,rates_total,nb);

   if(gOn[PG_T_LIV])
     {
      datetime d1=iTime(_Symbol,PERIOD_D1,0);
      bool newDay=(d1>0 && d1!=gD1Seen);
      if(d1>0)
         gD1Seen=d1;
      if(nb || newDay)
         RefreshLevels();           // dati D1/W1/MN1/M1/H4: una volta per barra nuova (o giorno nuovo)
      else
         LiveLevels();              // a ogni tick: solo confronti col prezzo
     }
   if(UpdateOverlay())
      ChartRedraw(0);
   return rates_total;
  }
//+------------------------------------------------------------------+
