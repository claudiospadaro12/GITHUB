//+------------------------------------------------------------------+
//|                                ABTG_PTE_Dashboard_Leggera.mq5    |
//|                                                                  |
//|  Dashboard PTE "versione nostra, leggera".                       |
//|  SOLO VISIONE: nessun ordine, nessuna rete, nessun file,         |
//|  nessun handle di indicatore. Mette in MQL5\Indicators e         |
//|  compila con F7.                                                 |
//|                                                                  |
//|  CRONOLOGIA                                                      |
//|  1.10 (07/10/2026) richieste di Claudio dopo la 1.00: "NELLA     |
//|   DASHBOARD PTE MANCANO LO SWITCH PER LE CANDELE HEIKENASHI, SE  |
//|   CLICCO SIA SUL SIMBOLO CHE SULL'ORARIO, IL GRAFICO NON MI      |
//|   PORTA LI. POI MI SEGNALAVA LE CANDELE DOJI" + tasti REFRESH,   |
//|   HIDE, DOJI ON/OFF, "DI DEFAULT C'ERANO LE CANDELE HEIKENASHI", |
//|   + EMA 9/21 con incrocio e SUPERTREND 3 LIVELLI (P. Lavorenti). |
//|   NESSUNA di queste e' la formula dell'originale (sorgente non   |
//|   disponibile): e' la NOSTRA ricostruzione da quello che Claudio |
//|   descrive. Tasti (due righe sopra la tabella):                  |
//|     HIDE/SHOW .. nasconde la tabella (resta solo questo tasto);  |
//|                  nascosta = NESSUNA copia di dati, nessun calcolo|
//|                  della tabella; allo SHOW si ricalcola subito.   |
//|     REFRESH .... azzera la cache di tutte le celle: si ricalcolano|
//|                  al ritmo normale (InpCellePerCiclo al secondo). |
//|     HA ON/OFF .. candele Heikin Ashi sul grafico (default ACCESE |
//|                  come l'originale), native nascoste a clrNONE e  |
//|                  RIPRISTINATE a ogni uscita (tecnica di          |
//|                  ABTG_Pulsanti_Grafico.mq5).                     |
//|     DOJI ON/OFF  frecce sulle doji FUORI CANALE del grafico      |
//|                  corrente (stessa regola delle celle), tooltip   |
//|                  con la distanza in ATR. OFF = niente frecce e   |
//|                  niente calcolo. Le CELLE non cambiano.          |
//|     EMA 9/21 ... le due EMA e l'INCROCIO (frecce) sulle barre    |
//|                  CHIUSE: barra x vs x-1, mai la barra in corso.  |
//|     ST 3 LIV ... Supertrend 2,5/3,0/3,5 ATR 10 (SW_STCore, la    |
//|                  stessa funzione di ABTG_Pulsanti_Grafico 1.01 e |
//|                  NC_STCore di EA_NatCla, testo identico).        |
//|     CLICK ...... sul SIMBOLO: il grafico va su quel simbolo (TF  |
//|                  invariato); sulla CELLA: simbolo E TF della     |
//|                  cella; sul TF dell'intestazione: TF su questo   |
//|                  simbolo. InpClickNuovoGrafico=true apre invece  |
//|                  un grafico nuovo.                               |
//|                  SE SU QUESTO GRAFICO GIRA UN EA il click NON    |
//|                  cambia niente (Alert): l'EA si riavvierebbe su  |
//|                  un altro simbolo (classe 930). Grafico nuovo:   |
//|                  10 s di guardia su un EA arrivato dal modello   |
//|                  default.tpl (classe 951, Alert).                |
//|                  Storico che scorre: ricalcolo completo (965).   |
//|   STATO DEI TASTI: GlobalVariable del terminale "PDLV_<ChartID>_" |
//|   (come ABTG_Pulsanti): resta al cambio di simbolo/TF (il click  |
//|   RICARICA l'indicatore) e al cambio parametri se l'input di     |
//|   partenza non e' cambiato; si cancella togliendo l'indicatore o |
//|   chiudendo il grafico.                                          |
//|   AL RICARICO (click): la CACHE della tabella NON sopravvive      |
//|   (istanza nuova): si riempie di nuovo in ~6 s (max 20 celle/s). |
//|   SE LE CANDELE SPARISCONO (terminale in crash con HA acceso):   |
//|   rimettere l'indicatore le fa tornare (colori di ripiego);      |
//|   a mano: F8 > Colori > Candela su/giu, Barra su/giu, Linea.     |
//|  1.00 (07/10/2026) prima versione: solo la tabella.              |
//|                                                                  |
//|  PERCHE' ESISTE                                                  |
//|  La dashboard PTE_V3_18 3.18 (Emiliano Monza / ABTG, compilata,  |
//|  sorgente NON disponibile e NON decompilato) sul terminale       |
//|  manuale di Claudio va a scatti. Questa e' una tabella con la    |
//|  STESSA forma (PAIR / H1 / H4 / D1, simboli su 5 liste) ma       |
//|  con carico minimo. NON e' una copia dell'originale: la sua      |
//|  logica interna non la conosciamo.                               |
//|                                                                  |
//|  COSA SEGNA UNA CELLA (IPOTESI DI LAVORO, da confermare con un   |
//|  confronto visivo affiancato all'originale):                     |
//|   - accesa = sul simbolo/TF c'e' stata una DOJI col corpo FUORI  |
//|     dal canale TMA (lento / veloce / uno dei due / entrambi,     |
//|     input InpCanale) in una delle ultime InpBarreIndietro barre  |
//|     CHIUSE; si mostra la PIU' RECENTE;                           |
//|   - testo = ORA della candela (TF < D1), GIORNO della settimana  |
//|     (D1), gg/mm (W1), mese (MN). ORA SERVER del broker, come il  |
//|     grafico (BCM: UTC+1 fisso -> d'estate ora italiana -1,       |
//|     d'inverno = ora italiana; CLAUDE.md 24/09/2026);             |
//|   - VERDE = doji SOTTO il canale (rialzista, ritorno alla media),|
//|     ROSSO = doji SOPRA il canale (ribassista).                   |
//|                                                                  |
//|  LOGICA DI SEGNALE: COPIATA da mql5/Experts/ABTG_PTE.mq5         |
//|  (TmaBand -> PD_TmaEA, GetCandle -> PD_Candela modo 1,           |
//|  IsDoji -> PD_IsDoji), resa "pura" (lavora su array, non chiama  |
//|  il terminale) per poterla collaudare fuori da MetaTrader.       |
//|  DIFFERENZA ATTESA CON L'ORIGINALE: la TMA dell'EA e' NON-REPAINT |
//|  (media triangolare all'indietro, quindi IN RITARDO di circa     |
//|  mezzo periodo); i canali della dashboard originale PROBABILMENTE|
//|  ripitturano (TMA centrata). I valori dei canali quindi          |
//|  differiscono e alcune celle non coincideranno. Per il confronto |
//|  c'e' InpTmaModo = PD_TMA_CENTRATA: e' una NOSTRA IPOTESI di come |
//|  e' fatta l'originale (TMA centrata classica, mezza-lunghezza =  |
//|  periodo, solo barre chiuse), NON la sua formula.                |
//|  ATR: calcolato qui dalle barre (media semplice del true range,  |
//|  come iATR di MT5) invece che con un handle iATR: stesso numero, |
//|  zero handle.                                                    |
//|  DOJI SUL GRAFICO e CANDELE DISEGNATE: le frecce usano la regola |
//|  delle celle (default InpCandela = HA a 2 barre di seme come     |
//|  l'EA); le candele HA DISEGNATE sono la HA classica ricorsiva    |
//|  (seme (o+c)/2 sulla barra piu' vecchia, PG_HA). Le due HA non   |
//|  sono identiche: una freccia puo' stare su una candela disegnata |
//|  che a occhio non sembra una doji. Dichiarato, misurato nel      |
//|  collaudo (informativo).                                         |
//|                                                                  |
//|  CARICO (perche' e' leggera) -- [STIMA], non misura:             |
//|   - handle di indicatori: 0;                                     |
//|   - oggetti della tabella: 9 + 2*nTF + nSimboli*(1+2*nTF);       |
//|     default 35 x 3 TF = 260 oggetti, creati UNA volta, aggiornati|
//|     solo se testo o colore cambiano; ChartRedraw solo se qualcosa|
//|     e' cambiato; + al massimo InpBarreIndietro frecce doji;      |
//|   - calcolo tabella: SOLO a barra nuova di ciascun simbolo/TF    |
//|     (OnTimer 1 s), mai a ogni tick. Fra una barra e la successiva|
//|     una cella non chiama il terminale per niente (orario della   |
//|     prossima barra in memoria); quando la barra e' "dovuta" fa   |
//|     1 SeriesInfoInteger ogni InpRicontrolloSec secondi finche'   |
//|     la barra arriva (serie ancora vuota: 1 CopyRates, che la fa  |
//|     costruire, con attesa crescente);                            |
//|   - copia: 1 CopyRates per cella per barra nuova, col numero     |
//|     MINIMO di barre (default 131: ATR lento 100 + 30 barre di    |
//|     ricerca + 1); a regime H1+H4+D1 su 35 simboli fanno circa    |
//|     35+8,75+1,5 = ~45 copie all'ora (una ogni ~80 s);            |
//|   - all'avvio: al massimo InpCellePerCiclo copie al secondo      |
//|     (default 20 -> 105 celle in ~6 s), per non bloccare il       |
//|     grafico;                                                     |
//|   - simboli senza dati: saltati, riprovati con attesa crescente  |
//|     2, 4, 8 ... 300 s;                                           |
//|   - grafico corrente (OnCalculate, NESSUNA copia: gli array del  |
//|     terminale): HA, EMA e Supertrend incrementali, a ogni tick   |
//|     SOLO la barra in formazione (O(1); il Supertrend O(periodo)),|
//|     tutto lo storico una volta al caricamento; frecce doji,      |
//|     incroci EMA e canali SOLO a barra nuova. Con un tasto spento |
//|     HA/EMA/ST non si disegnano ma il calcolo incrementale O(1)   |
//|     continua (ricalcolare tutto lo storico all'accensione        |
//|     richiederebbe una copia dati dentro il click); le DOJI invece|
//|     spente non si calcolano affatto.                             |
//|  Confronto con l'originale: se (come sembra dagli scatti)        |
//|  ricalcolasse ~105-111 celle a OGNI tick, con 2-5 tick/s sarebbero|
//|  ~200-550 copie+ricalcoli al secondo contro ~0,013 qui. E' una   |
//|  IPOTESI sull'originale, non una misura.                         |
//|  NB: le 5 liste di default fanno 35 simboli (28 forex + XAUUSD + |
//|  USOIL + 5 indici); l'originale ne mostrerebbe 37: due mancano,  |
//|  vanno chiesti a Claudio, NON inventati.                         |
//|                                                                  |
//|  NON implementato (dichiarato): email/push, gli altri CHART      |
//|  BUTTONS dell'originale che Claudio non ha descritto. Alert:     |
//|  solo popup/suono, spenti. Un solo esemplare per grafico         |
//|  (prefisso oggetti fisso "PDL_"), e NON insieme ad altri         |
//|  indicatori che nascondono le candele (ABTG_Pulsanti_Grafico con |
//|  HEIKIN ASHI acceso, ABTG_Segnali_EMA_BB_ST, SuperWave in HA).   |
//|  MAI COMPILATA (qui non c'e' MetaEditor). DEMO. Nessuna garanzia.|
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.10"
#property strict
#property indicator_chart_window
#property indicator_buffers 32
#property indicator_plots   15
//--- plot 1: candele Heikin Ashi (buffer 0-3 OHLC, 4 colore)
#property indicator_label1  "HA Apertura;HA Massimo;HA Minimo;HA Chiusura"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrSeaGreen,clrFireBrick
#property indicator_width1  1
//--- plot 2-5: canali TMA (input InpDisegnaCanali)
#property indicator_label2  "TMA veloce sup"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrSilver
#property indicator_style2  STYLE_DOT
#property indicator_label3  "TMA veloce inf"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrSilver
#property indicator_style3  STYLE_DOT
#property indicator_label4  "TMA lenta sup"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSlateGray
#property indicator_style4  STYLE_SOLID
#property indicator_label5  "TMA lenta inf"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrSlateGray
#property indicator_style5  STYLE_SOLID
//--- plot 6-9: EMA veloce/lenta e frecce dell'incrocio (tasto EMA 9/21)
#property indicator_label6  "EMA veloce"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrHotPink
#property indicator_width6  1
#property indicator_label7  "EMA lenta"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGold
#property indicator_width7  1
#property indicator_label8  "Incrocio EMA su"
#property indicator_type8   DRAW_ARROW
#property indicator_color8  clrDodgerBlue
#property indicator_width8  2
#property indicator_label9  "Incrocio EMA giu"
#property indicator_type9   DRAW_ARROW
#property indicator_color9  clrMagenta
#property indicator_width9  2
//--- plot 10-15: Supertrend 3 livelli, due linee per livello (niente diagonale all'inversione)
#property indicator_label10 "ST 2.5 su"
#property indicator_type10  DRAW_LINE
#property indicator_label11 "ST 2.5 giu"
#property indicator_type11  DRAW_LINE
#property indicator_label12 "ST 3.0 su"
#property indicator_type12  DRAW_LINE
#property indicator_label13 "ST 3.0 giu"
#property indicator_type13  DRAW_LINE
#property indicator_label14 "ST 3.5 su"
#property indicator_type14  DRAW_LINE
#property indicator_label15 "ST 3.5 giu"
#property indicator_type15  DRAW_LINE

//==================================================================
//  ENUM (fuori dal blocco puro: servono agli input)
//==================================================================
enum ENUM_PD_CANALE
  {
   PD_CH_LENTO   = 0,   // Lento (TMA 56)
   PD_CH_VELOCE  = 1,   // Veloce (TMA 14)
   PD_CH_UNO     = 2,   // Uno dei due (CHSEL_EITHER dell'originale)
   PD_CH_ENTRAMBI= 3    // Entrambi (come l'EA con InpRequireOutSlow)
  };
enum ENUM_PD_CANDELA
  {
   PD_CAND_GIAPPONESE = 0, // Candele giapponesi
   PD_CAND_HA_EA      = 1, // Heikin Ashi come ABTG_PTE (2 barre di seme)
   PD_CAND_HA_PIENA   = 2  // Heikin Ashi ricorsiva su tutta la finestra
  };
enum ENUM_PD_TMA
  {
   PD_TMA_EA       = 0, // TMA dell'EA ABTG_PTE (non-repaint, in ritardo)
   PD_TMA_CENTRATA = 1  // TMA centrata (NOSTRA ipotesi dell'originale, ripittura)
  };

//==================================================================
//  INPUT (stessi gruppi dell'originale, dove ha senso)
//==================================================================
input group "=== DASHBOARD ==="
input ENUM_BASE_CORNER InpAngolo    = CORNER_LEFT_UPPER; // DashCorner (angoli diversi da Left upper: NON provati)
input int    InpOffsetX             = 80;     // Offset X (pixel)
input int    InpOffsetY             = 75;     // Offset Y (pixel)
input int    InpLarghezzaCella      = 72;     // Larghezza cella
input int    InpAltezzaCella        = 18;     // Altezza cella
input int    InpFontSize            = 8;      // Dimensione font
input string InpFont                = "Arial";// Font

input group "=== SIMBOLI (5 liste come l'originale) ==="
input string InpLista1 = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY"; // Lista 1
input string InpLista2 = "EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD";        // Lista 2
input string InpLista3 = "GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD";        // Lista 3
input string InpLista4 = "NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY,XAUUSD,USOIL";  // Lista 4
input string InpLista5 = "225JPY,D30EUR,SPXUSD,U30USD,NASUSD";                      // Lista 5
input string InpSuffisso        = "";     // Suffisso del broker (es. ".r"), vuoto = nessuno
input bool   InpSoloMarketWatch = true;   // Solo i simboli del Market Watch (salta gli altri)

input group "=== TIMEFRAME (colonne) ==="
input bool InpM15 = false; // M15
input bool InpM30 = false; // M30
input bool InpH1  = true;  // H1
input bool InpH4  = true;  // H4
input bool InpH8  = false; // H8
input bool InpH12 = false; // H12
input bool InpD1  = true;  // D1
input bool InpW1  = false; // W1
input bool InpMN  = false; // MN

input group "=== DOJI CHANNEL FILTER ==="
input bool           InpSoloFuoriCanale = true;       // Segnala DOJI solo se corpo fuori da almeno un canale
input ENUM_PD_CANALE InpCanale          = PD_CH_UNO;  // Canale (CHSEL)

input group "=== TMA CHANNELS ==="
input ENUM_PD_TMA InpTmaModo    = PD_TMA_EA; // Calcolo TMA (default = quello dell'EA ABTG_PTE)
input int    InpTmaLento        = 56;     // Canale lento: periodo
input int    InpAtrLento        = 100;    // Canale lento: ATR
input double InpMultLento       = 2.0;    // Canale lento: moltiplicatore
input int    InpTmaVeloce       = 14;     // Canale veloce: periodo
input int    InpAtrVeloce       = 30;     // Canale veloce: ATR
input double InpMultVeloce      = 2.0;    // Canale veloce: moltiplicatore

input group "=== DOJI DETECTION ==="
input double          InpCorpoMaxPct  = 10.0;           // Body max % del range
input ENUM_PD_CANDELA InpCandela      = PD_CAND_HA_EA;  // Candele su cui cercare la doji (EA: Heikin Ashi)
input bool            InpUsaCode      = false;          // Richiedi coda (Dragonfly per verde, Gravestone per rosso)
input double          InpRapCodaInf   = 2.0;            // Rapporto coda inferiore (Dragonfly)
input double          InpRapCodaSup   = 2.0;            // Rapporto coda superiore (Gravestone)
input bool            InpConfermaFlip = false;          // Richiedi cambio colore della candela dopo (come l'EA)
input int             InpBarreIndietro= 30;             // Barre chiuse in cui cercare l'ultima doji
input int             InpSemeHA       = 50;             // Barre di seme per la Heikin Ashi ricorsiva

input group "=== COLORI ==="
input color InpColRialzo   = C'39,174,96';   // Cella rialzista (JP rialzista dell'originale)
input color InpColRibasso  = C'192,57,43';   // Cella ribassista (JP ribassista dell'originale)
input color InpColVuota    = C'28,28,28';    // Cella vuota
input color InpColPannello = C'18,18,18';    // Sfondo pannello
input color InpColIntest   = C'48,48,48';    // Intestazione
input color InpColBordo    = C'60,60,60';    // Bordo celle
input color InpColTesto    = clrWhite;       // Testo
input color InpColSpento   = C'110,110,110'; // Simbolo non disponibile
input color InpColTastoOn  = C'0,95,150';    // Tasto acceso

input group "=== ALERTS ==="
input bool InpAlertPopup  = false;  // Popup (solo segnali NUOVI sull'ultima barra chiusa)
input bool InpAlertSuono  = false;  // Suono
input int  InpAlertMinuti = 5;      // Tempo minimo fra due alert della stessa cella (minuti)

input group "=== CONFRONTO E CARICO ==="
input bool InpModoConfronto  = false; // Modalita confronto: distanza corpo-canale in ATR nel tooltip
input int  InpCellePerCiclo  = 20;    // Celle ricalcolate al massimo per ciclo di timer (1 s)
input int  InpRicontrolloSec = 5;     // Barra dovuta ma non ancora arrivata: ricontrolla ogni N s

input group "=== TASTI: stato all'avvio (poi decide il tasto; resta al cambio simbolo/TF) ==="
input bool InpHaDefault         = true;   // HA: candele Heikin Ashi accese (l'originale: accese di default)
input bool InpDojiDefault       = true;   // DOJI: frecce sulle doji fuori canale del grafico
input bool InpNascostaDefault   = false;  // HIDE: tabella nascosta
input bool InpEmaDefault        = false;  // EMA 9/21 con incrocio
input bool InpStDefault         = false;  // SUPERTREND 3 LIVELLI
input bool InpClickNuovoGrafico = false;  // Click su simbolo/cella/TF: apre un grafico NUOVO (false = cambia questo)
input color InpColHASu          = clrSeaGreen;  // Candela HA rialzista
input color InpColHAGiu         = clrFireBrick; // Candela HA ribassista

input group "=== CANALI TMA DISEGNATI (default spenti) ==="
input bool  InpDisegnaCanali = false;        // Disegna i canali TMA (veloce e lento) del grafico corrente
input int   InpBarreCanali   = 300;          // ...sulle ultime N barre chiuse (ricalcolo a barra nuova)
input color InpColCanaleV    = clrSilver;    // Canale veloce
input color InpColCanaleL    = clrSlateGray; // Canale lento

input group "=== EMA 9/21 (tasto EMA) ==="
input int   InpEmaVeloce    = 9;            // EMA veloce, periodo (sulla chiusura)
input int   InpEmaLenta     = 21;           // EMA lenta, periodo (sulla chiusura)
input color InpColEmaVeloce = clrHotPink;   // EMA veloce (rosa, come ABTG_Pulsanti)
input color InpColEmaLenta  = clrGold;      // EMA lenta (gialla, come ABTG_Pulsanti)
input color InpColIncSu     = clrDodgerBlue;// Freccia incrocio al rialzo (veloce sopra la lenta)
input color InpColIncGiu    = clrMagenta;   // Freccia incrocio al ribasso

input group "=== SUPERTREND 3 LIVELLI (tasto ST) ==="
input int    InpStPeriodo = 10;             // [NOSTRA] periodo ATR dei tre livelli (audio: non detto; 10 = indizio PL-SUPERTREND V09, non fonte)
input double InpStMult1   = 2.5;            // [FONTE: audio WA0090 "2.5, 3, 3.5"] livello 1, moltiplicatore
input double InpStMult2   = 3.0;            // [FONTE: audio WA0090 "2.5, 3, 3.5"] livello 2, moltiplicatore
input double InpStMult3   = 3.5;            // [FONTE: audio WA0090 "2.5, 3, 3.5"] livello 3, moltiplicatore
input color  InpColSt1Su  = C'150,225,150'; // livello 1 trend SU (verde chiaro)
input color  InpColSt1Giu = C'255,175,130'; // livello 1 trend GIU (salmone chiaro)
input color  InpColSt2Su  = clrLimeGreen;   // livello 2 trend SU
input color  InpColSt2Giu = clrOrangeRed;   // livello 2 trend GIU
input color  InpColSt3Su  = C'0,150,80';    // livello 3 trend SU (verde scuro)
input color  InpColSt3Giu = C'205,90,0';    // livello 3 trend GIU (arancio scuro)

//==================================================================
//  BLOCCO PURO: niente chiamate al terminale, solo array e numeri.
//  Lo estrae e lo compila in C++ backtest_pipeline/
//  collaudo_pte_dashboard_leggera.py. Array in ordine "serie":
//  indice 0 = barra in formazione, 1 = ultima chiusa, ecc.
//==================================================================
//@@PD_PURE_BEGIN
#define PD_NODATI (-9)
#define PD_PREF   "PDL_"         // prefisso degli oggetti della tabella (anche il click lo legge)
#define PG_VUOTO  EMPTY_VALUE

struct PD_Par
  {
   int    candela;      // 0 giapponese, 1 HA come l'EA, 2 HA ricorsiva
   int    tmaModo;      // 0 TMA dell'EA (non-repaint), 1 TMA centrata (ipotesi)
   int    tmaS;
   int    atrS;
   double multS;
   int    tmaF;
   int    atrF;
   double multF;
   double corpoMaxPct;
   bool   soloFuori;
   int    canale;       // 0 lento, 1 veloce, 2 uno dei due, 3 entrambi
   bool   usaCode;
   double rapInf;
   double rapSup;
   bool   flip;
   int    semeHA;
  };

int PD_MaxI(int a,int b){ return(a>b ? a : b); }

//--- COPIATA da ABTG_PTE.mq5 TmaBand (parte di calcolo, stessa formula
//    e stesso controllo di storico need=period+m+shift+5): media
//    triangolare = SMA di SMA di lunghezza m, all'indietro dalla barra
//    'shift' -> non-repaint, ma in ritardo di circa mezzo periodo.
bool PD_TmaEA(const double &c[],int n,int period,int shift,double &mid)
  {
   int m=(period+1)/2; if(m<1) m=1;
   int need=period+m+shift+5;
   if(shift<0 || n<need) return(false);
   double tma=0;
   for(int k=0;k<m;k++)
     {
      double s=0;
      for(int j=0;j<m;j++) s+=c[shift+k+j];
      tma+=s/m;
     }
   tma/=m;
   mid=tma;
   return(true);
  }

//--- NOSTRA IPOTESI della TMA dell'originale (NON la sua formula): media
//    triangolare CENTRATA classica, mezza-lunghezza = period, pesi
//    period+1 al centro che scendono di 1 per lato. A destra usa solo le
//    barre CHIUSE disponibili (shift-j>=1): sulle barre recenti la media
//    e' monca e cambia quando arrivano barre nuove -> ripittura.
bool PD_TmaCentrata(const double &c[],int n,int period,int shift,double &mid)
  {
   if(period<1 || shift<1 || n<shift+period+1) return(false);
   double sum=(period+1)*c[shift];
   double sw=(period+1);
   for(int j=1;j<=period;j++)
     {
      double k=period+1-j;
      sum+=k*c[shift+j]; sw+=k;
      if(shift-j>=1){ sum+=k*c[shift-j]; sw+=k; }
     }
   mid=sum/sw;
   return(true);
  }

//--- ATR come iATR di MT5: media SEMPLICE del true range su 'period'
//    barre, TR = max(H, C prec.) - min(L, C prec.). Serve la barra
//    precedente all'ultima: n >= shift+period+1.
bool PD_Atr(const double &h[],const double &l[],const double &c[],int n,int period,int shift,double &atr)
  {
   if(period<1 || shift<0 || n<shift+period+1) return(false);
   double s=0;
   for(int i=shift;i<shift+period;i++)
      s+=MathMax(h[i],c[i+1])-MathMin(l[i],c[i+1]);
   atr=s/period;
   return(atr>0);
  }

//--- COPIATA da ABTG_PTE.mq5 GetCandle (modo 1: Heikin Ashi approssimata
//    con 2 barre di seme, formula identica). Modo 2: Heikin Ashi classica
//    ricorsiva, seme sulla barra piu' vecchia della finestra (l'errore del
//    seme si dimezza a ogni barra: con 50 barre e' sotto 1e-15).
bool PD_Candela(const double &o[],const double &h[],const double &l[],const double &c[],int n,int shift,int modo,
                double &O,double &H,double &L,double &C)
  {
   if(shift<0 || n<shift+1) return(false);
   H=h[shift]; L=l[shift];
   if(modo==0){ O=o[shift]; C=c[shift]; return(true); }
   if(modo==1)
     {
      if(n<shift+3) return(false);
      double haC=(o[shift]+h[shift]+l[shift]+c[shift])/4.0;
      double haO_prev=(o[shift+2]+c[shift+2])/2.0;
      double haC_prev=(o[shift+1]+h[shift+1]+l[shift+1]+c[shift+1])/4.0;
      double haO=(haO_prev+haC_prev)/2.0;
      O=haO; C=haC;
     }
   else
     {
      double ro=(o[n-1]+c[n-1])/2.0;
      double rc=(o[n-1]+h[n-1]+l[n-1]+c[n-1])/4.0;
      for(int i=n-2;i>=shift;i--)
        {
         ro=(ro+rc)/2.0;
         rc=(o[i]+h[i]+l[i]+c[i])/4.0;
        }
      O=ro; C=rc;
     }
   H=MathMax(H,MathMax(O,C)); L=MathMin(L,MathMin(O,C));
   return(true);
  }

//--- COPIATA da ABTG_PTE.mq5 IsDoji (soglia passata come argomento)
bool PD_IsDoji(double o,double h,double l,double c,double bodyMaxPct)
  {
   double range=h-l; if(range<=0) return(false);
   return(MathAbs(c-o) <= bodyMaxPct/100.0*range);
  }

bool PD_Banda(const double &h[],const double &l[],const double &c[],int n,int shift,int modo,int period,int atrPer,double mult,
              double &mid,double &up,double &lo,double &atr)
  {
   double tma=0;
   if(modo==1){ if(!PD_TmaCentrata(c,n,period,shift,tma)) return(false); }
   else       { if(!PD_TmaEA(c,n,period,shift,tma)) return(false); }
   if(!PD_Atr(h,l,c,n,atrPer,shift,atr)) return(false);
   mid=tma; up=tma+atr*mult; lo=tma-atr*mult;
   return(true);
  }

//--- distanza del CORPO dal canale in ATR: > 0 = fuori (sopra o sotto),
//    < 0 = dentro. Serve alla modalita' confronto.
double PD_Dist(double blo,double bhi,double up,double lo,double atr)
  {
   return(MathMax(blo-up,lo-bhi)/atr);
  }

int PD_BisognoTma(int modo,int period,int s)
  {
   if(modo==1) return(s+period+1);
   int m=(period+1)/2; if(m<1) m=1;
   return(period+m+s+5);
  }

//--- barre MINIME da copiare per valutare le barre 1..barre
int PD_Bisogno(const PD_Par &p,int barre)
  {
   int s=barre;
   int b=s+3;
   if(p.candela==2) b=PD_MaxI(b,s+1+p.semeHA);
   b=PD_MaxI(b,PD_BisognoTma(p.tmaModo,p.tmaS,s));
   b=PD_MaxI(b,PD_BisognoTma(p.tmaModo,p.tmaF,s));
   b=PD_MaxI(b,s+p.atrS+1);
   b=PD_MaxI(b,s+p.atrF+1);
   return(b);
  }

//--- una barra: +1 doji rialzista (corpo SOTTO il canale), -1 ribassista
//    (corpo SOPRA), 0 niente, PD_NODATI storico corto. dF/dS: distanza
//    del corpo dal canale veloce/lento in ATR (calcolata anche senza doji).
int PD_Valuta(const double &o[],const double &h[],const double &l[],const double &c[],int n,int shift,const PD_Par &p,
              double &dF,double &dS)
  {
   dF=0.0; dS=0.0;
   double O=0,H=0,L=0,C=0;
   if(!PD_Candela(o,h,l,c,n,shift,p.candela,O,H,L,C)) return(PD_NODATI);
   double midF=0,upF=0,loF=0,aF=0,midS=0,upS=0,loS=0,aS=0;
   if(!PD_Banda(h,l,c,n,shift,p.tmaModo,p.tmaF,p.atrF,p.multF,midF,upF,loF,aF)) return(PD_NODATI);
   if(!PD_Banda(h,l,c,n,shift,p.tmaModo,p.tmaS,p.atrS,p.multS,midS,upS,loS,aS)) return(PD_NODATI);
   double bhi=MathMax(O,C), blo=MathMin(O,C);
   dF=PD_Dist(blo,bhi,upF,loF,aF);
   dS=PD_Dist(blo,bhi,upS,loS,aS);
   if(!PD_IsDoji(O,H,L,C,p.corpoMaxPct)) return(0);
   bool sopra=false, sotto=false;
   if(!p.soloFuori)
     {
      double mc=(blo+bhi)/2.0;               // senza filtro canale: lato rispetto alla TMA veloce
      sopra=(mc>midF); sotto=(mc<midF);
     }
   else
     {
      bool sF=(blo>upF), gF=(bhi<loF), sS=(blo>upS), gS=(bhi<loS);
      if(p.canale==0)      { sopra=sS; sotto=gS; }
      else if(p.canale==1) { sopra=sF; sotto=gF; }
      else if(p.canale==2) { sopra=(sF || sS); sotto=(gF || gS); }
      else                 { sopra=(sF && sS); sotto=(gF && gS); }
     }
   if(sopra==sotto) return(0);               // ne' sopra ne' sotto, o conflitto fra i due canali
   int dir=(sotto ? 1 : -1);                 // sotto = rialzista (ritorno alla media), sopra = ribassista
   if(p.usaCode)
     {
      double cs=H-bhi, ci=blo-L;
      if(dir>0 && !(ci>=p.rapInf*cs)) return(0);
      if(dir<0 && !(cs>=p.rapSup*ci)) return(0);
     }
   if(p.flip)
     {
      if(shift<2) return(0);                 // la candela di conferma non e' ancora chiusa
      double O1=0,H1=0,L1=0,C1=0;
      if(!PD_Candela(o,h,l,c,n,shift-1,p.candela,O1,H1,L1,C1)) return(PD_NODATI);
      if(dir>0 && !(C1>O1)) return(0);
      if(dir<0 && !(C1<O1)) return(0);
     }
   return(dir);
  }

//--- la doji PIU' RECENTE fra le barre chiuse 1..barre
int PD_Ultimo(const double &o[],const double &h[],const double &l[],const double &c[],int n,int barre,const PD_Par &p,
              int &shiftSeg,double &dF,double &dS,double &dF1,double &dS1)
  {
   shiftSeg=0; dF=0.0; dS=0.0; dF1=0.0; dS1=0.0;
   for(int s=1;s<=barre;s++)
     {
      double a=0.0, b=0.0;
      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);
      if(r==PD_NODATI) return(PD_NODATI);
      if(s==1){ dF1=a; dS1=b; }
      if(r!=0){ shiftSeg=s; dF=a; dS=b; return(r); }
     }
   return(0);
  }

string PD_Due(int v){ return((v<10 ? "0" : "")+IntegerToString(v)); }

//--- data civile da giorni dal 01/01/1970 (algoritmo "days from civil" inverso)
void PD_Data(long z,int &y,int &mo,int &d)
  {
   z+=719468;
   long era=(z>=0 ? z : z-146096)/146097;
   long doe=z-era*146097;
   long yoe=(doe-doe/1460+doe/36524-doe/146096)/365;
   long yy=yoe+era*400;
   long doy=doe-(365*yoe+yoe/4-yoe/100);
   long mp=(5*doy+2)/153;
   d=(int)(doy-(153*mp+2)/5+1);
   mo=(int)(mp<10 ? mp+3 : mp-9);
   y=(int)(yy+(mo<=2 ? 1 : 0));
  }

//--- testo della cella: ORA (TF < D1), GIORNO (D1), gg/mm (W1), mese (MN).
//    Il datetime della candela e' gia' in ORA SERVER: niente conversioni.
string PD_Testo(datetime t,int tfSec)
  {
   long g=(long)t/86400;
   int sec=(int)((long)t-g*86400);
   if(tfSec<86400) return(PD_Due(sec/3600)+":"+PD_Due((sec%3600)/60));
   if(tfSec<604800) return(StringSubstr("SunMonTueWedThuFriSat",(int)((g+4)%7)*3,3));
   int y=0, mo=0, d=0;
   PD_Data(g,y,mo,d);
   if(tfSec<2419200) return(PD_Due(d)+"/"+PD_Due(mo));
   return(StringSubstr("JanFebMarAprMayJunJulAugSepOctNovDec",(mo-1)*3,3));
  }

//--- v1.10 DOJI SUL GRAFICO: TUTTE le doji fra le barre chiuse 1..barre (la stessa PD_Valuta delle celle).
//    Riempie sh/dir/dF/dS (capienza >= barre) e ritorna quante. La prima e' la piu' recente = PD_Ultimo.
int PD_Marca(const double &o[],const double &h[],const double &l[],const double &c[],int n,int barre,const PD_Par &p,
             int &sh[],int &dir[],double &dF[],double &dS[])
  {
   int q=0;
   for(int s=1;s<=barre;s++)
     {
      double a=0.0, b=0.0;
      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);
      if(r==PD_NODATI) break;
      if(r!=0){ sh[q]=s; dir[q]=r; dF[q]=a; dS[q]=b; q++; }
     }
   return(q);
  }

//--- v1.10 CLICK: numero di indice da un pezzo di nome (solo cifre, 1-4), -1 se non lo e'
int PD_Numero(string s)
  {
   int n=StringLen(s);
   if(n<1 || n>4) return(-1);
   int v=0;
   for(int x=0;x<n;x++)
     {
      int ch=StringGetCharacter(s,x);
      if(ch<'0' || ch>'9') return(-1);
      v=v*10+(ch-'0');
     }
   return(v);
  }

//--- v1.10 CLICK: cosa e' stato cliccato. Nomi (Struttura): PDL_r_<i>_<j> rettangolo e PDL_t_<i>_<j> testo
//    della cella (riga i = simbolo, colonna j = TF), PDL_s_<i> simbolo, PDL_hr_<j>/PDL_ht_<j> TF
//    dell'intestazione. Ritorna 1 cella (i,j), 2 simbolo (i, j=-1), 3 TF (i=-1, j), 0 altro. Indici fuori
//    dalla tabella (nS simboli, nT TF) = 0: un oggetto rimasto da una tabella piu' grande non porta altrove.
int PD_Bersaglio(string nome,int nS,int nT,int &i,int &j)
  {
   i=-1; j=-1;
   string p=PD_PREF;
   int lp=StringLen(p);
   if(StringLen(nome)<=lp || StringSubstr(nome,0,lp)!=p) return(0);
   string r=StringSubstr(nome,lp);
   int us=StringFind(r,"_");
   if(us<1) return(0);
   string tipo=StringSubstr(r,0,us);
   string resto=StringSubstr(r,us+1);
   if(tipo=="r" || tipo=="t")
     {
      int u2=StringFind(resto,"_");
      if(u2<1) return(0);
      int a=PD_Numero(StringSubstr(resto,0,u2));
      int b=PD_Numero(StringSubstr(resto,u2+1));
      if(a<0 || a>=nS || b<0 || b>=nT) return(0);
      i=a; j=b;
      return(1);
     }
   if(tipo=="s")
     {
      int a=PD_Numero(resto);
      if(a<0 || a>=nS) return(0);
      i=a;
      return(2);
     }
   if(tipo=="hr" || tipo=="ht")
     {
      int b=PD_Numero(resto);
      if(b<0 || b>=nT) return(0);
      j=b;
      return(3);
     }
   return(0);
  }

//--- v1.10 EMA: incrocio sulla barra CHIUSA x (indici 0 = barra piu' vecchia) rispetto alla x-1.
//    +1 = la veloce passa SOPRA la lenta, -1 = SOTTO, 0 niente. Prima di 'primo' (riscaldamento della
//    EMA, seme = prima chiusura) niente. Il chiamante non passa MAI la barra in formazione.
int PD_Incrocio(const double &f[],const double &sl[],const int x,const int primo)
  {
   if(x<1 || x<primo) return(0);
   if(f[x]>sl[x] && f[x-1]<=sl[x-1]) return(1);
   if(f[x]<sl[x] && f[x-1]>=sl[x-1]) return(-1);
   return(0);
  }

//--- Le funzioni qui sotto sono COPIATE IDENTICHE da mql5/Indicators/ABTG_Pulsanti_Grafico.mq5 v1.01
//    (SW_STCore = anche NC_STCore di EA_NatCla.mq5): il collaudo confronta il testo. Indici 0 = barra
//    piu' vecchia, come gli array di OnCalculate.
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
//@@PD_PURE_END

//==================================================================
//  STATO
//==================================================================
#define PD_NOME   "ABTG PTE Dashboard Leggera"
#define PD_TITOLO "PTE DASHBOARD (leggera)"
#define PD_DOJI   "PDLG_d_"     // frecce doji del grafico: prefisso FUORI da PD_PREF (HIDE/Struttura non le toccano)
#define PD_GV     "PDLV_"       // GlobalVariable dello stato dei tasti

string          gSym[];      // simboli (con suffisso)
int             gNS=0;
ENUM_TIMEFRAMES gTF[];
string          gTFn[];
int             gNT=0;
int             gStatoSim[]; // 0 ok, 1 fuori Market Watch, 2 inesistente, -1 da valutare
color           gColSim[];   // colore attuale dell'etichetta del simbolo (cache)

//--- per cella k = i*gNT + j
datetime gUltBarra[];   // apertura della barra 0 con cui si e' calcolato
datetime gProssimo[];   // prima di questo istante (ora server) la cella non chiama il terminale
int      gAttesa[];     // attesa crescente dopo un fallimento (s)
int      gDir[];        // +1 / -1 / 0
datetime gTSeg[];       // apertura della candela del segnale
bool     gPronta[];     // almeno un calcolo riuscito
datetime gUltAllerta[];
double   gDF[], gDS[], gDF1[], gDS1[];
string   gTxt[];        // cache del disegno: si tocca l'oggetto solo se cambia
color    gBg[];
string   gTip[];

PD_Par   gPar;
int      gBisogno=0;
int      gCursore=0;
bool     gRidisegna=false;
bool     gProprietario=false;
bool     gDoppio=false;
int      gGiri=0;
datetime gUltStato=0;
MqlRates gR[];
double   gO[], gH[], gL[], gC[];

//--- v1.10 tasti (stato in GlobalVariable PD_GV<ChartID>_)
bool     gNascosta=false, gHA=false, gDoji=false, gEma=false, gSt=false;

//--- v1.10 grafico corrente: buffer (plot 0 HA, 1-4 canali, 5-6 EMA, 7-8 incroci, 9-14 Supertrend)
double bHAo[], bHAh[], bHAl[], bHAc[], bHAcol[];        // 0-4   plot 0
double bCVs[], bCVi[], bCLs[], bCLi[];                  // 5-8   plot 1-4
double bEmaV[], bEmaL[];                                // 9-10  plot 5-6
double bIncSu[], bIncGiu[];                             // 11-12 plot 7-8
double bSt1Su[], bSt1Giu[], bSt2Su[], bSt2Giu[], bSt3Su[], bSt3Giu[];   // 13-18 plot 9-14
double kAtr[];                                          // 19    calcolo (ATR comune: non dipende dal moltiplicatore)
double kUp1[], kDn1[], kDir1[], kVal1[];                // 20-23 calcolo livello 1
double kUp2[], kDn2[], kDir2[], kVal2[];                // 24-27 calcolo livello 2
double kUp3[], kDn3[], kDir3[], kVal3[];                // 28-31 calcolo livello 3

//--- istantanea in ordine SERIE (0 = barra in formazione) delle ultime gBisognoGraf barre del grafico,
//    presa a barra nuova da OnCalculate (nessuna copia dal terminale): serve a doji e canali, anche dal click
double   gXo[], gXh[], gXl[], gXc[], gXhh[], gXhl[];
datetime gXt[];
int      gXn=0, gXrt=0;
int      gBisognoGraf=0;
datetime gUltBarraGraf=0;
int      gCanDa=-1;
int      gMs[], gMd[];
double   gMf[], gMl[];
string   gMarcNome="";

//--- colori delle candele native (tecnica di ABTG_Pulsanti_Grafico.mq5, classi 963/971)
bool     gColsHidden=false;
color    gColBull=clrNONE, gColBear=clrNONE, gColUp=clrNONE, gColDown=clrNONE, gColLine=clrNONE;
int      gCure=0;

//==================================================================
//  POSIZIONI (angolo dell'originale). Rettangoli e tasti: punto di
//  ancoraggio in alto a sinistra; etichette: centro. Angoli diversi da
//  Left upper NON provati (nessun terminale qui).
//  Righe: 0-1 tasti, 2 titolo, 3 intestazione, 4.. simboli.
//==================================================================
int TotW(){ return(InpLarghezzaCella*(1+gNT)); }
int LB(){ int b=TotW()/3; return(b<64 ? 64 : b); }          // larghezza di un tasto (3 per riga)
int PW(){ int w=TotW(); return(w<3*LB() ? 3*LB() : w); }     // larghezza del pannello
int TotH(){ return(InpAltezzaCella*(4+gNS)); }
bool AngoloDestro(){ return(InpAngolo==CORNER_RIGHT_UPPER || InpAngolo==CORNER_RIGHT_LOWER); }
bool AngoloBasso(){ return(InpAngolo==CORNER_LEFT_LOWER || InpAngolo==CORNER_RIGHT_LOWER); }
int RX(int x){ return(AngoloDestro() ? InpOffsetX+PW()-x : InpOffsetX+x); }
int RY(int y){ return(AngoloBasso()  ? InpOffsetY+TotH()-y : InpOffsetY+y); }
int CX(int x){ return(AngoloDestro() ? InpOffsetX+PW()-x-InpLarghezzaCella/2 : InpOffsetX+x+InpLarghezzaCella/2); }
int CY(int y){ return(AngoloBasso()  ? InpOffsetY+TotH()-y-InpAltezzaCella/2 : InpOffsetY+y+InpAltezzaCella/2); }

//--- HIDE: tutti gli oggetti della tabella spariscono (OBJ_NO_PERIODS), TRANNE il tasto che la riapre
long Periodi(string nome)
  {
   if(gNascosta && nome!=PD_PREF+"b_hide") return(OBJ_NO_PERIODS);
   return(OBJ_ALL_PERIODS);
  }

void Rett(string nome,int x,int y,int w,int hh,color bg)
  {
   if(ObjectFind(0,nome)<0) ObjectCreate(0,nome,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,nome,OBJPROP_CORNER,InpAngolo);
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nome,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nome,OBJPROP_YSIZE,hh);
   ObjectSetInteger(0,nome,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nome,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,InpColBordo);
   ObjectSetInteger(0,nome,OBJPROP_BACK,false);
   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));
  }

void Etic(string nome,int x,int y,string testo,color col)
  {
   if(ObjectFind(0,nome)<0) ObjectCreate(0,nome,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,nome,OBJPROP_CORNER,InpAngolo);
   ObjectSetInteger(0,nome,OBJPROP_ANCHOR,ANCHOR_CENTER);
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,nome,OBJPROP_TEXT,testo);
   ObjectSetString(0,nome,OBJPROP_FONT,InpFont);
   ObjectSetInteger(0,nome,OBJPROP_FONTSIZE,InpFontSize);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,col);
   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));
  }

void Bottone(string nome,int x,int y,int w,int hh)
  {
   if(ObjectFind(0,nome)<0) ObjectCreate(0,nome,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,nome,OBJPROP_CORNER,InpAngolo);
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nome,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nome,OBJPROP_YSIZE,hh);
   ObjectSetString(0,nome,OBJPROP_FONT,InpFont);
   ObjectSetInteger(0,nome,OBJPROP_FONTSIZE,InpFontSize);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,InpColTesto);
   ObjectSetInteger(0,nome,OBJPROP_BORDER_COLOR,InpColBordo);
   ObjectSetInteger(0,nome,OBJPROP_STATE,false);
   ObjectSetInteger(0,nome,OBJPROP_BACK,false);
   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,nome,OBJPROP_TIMEFRAMES,Periodi(nome));
  }

//--- testo e colore di un tasto; lo stato "premuto" torna SEMPRE su (OBJPROP_STATE=false)
void Tasto(string suff,string testo,bool on)
  {
   string nome=PD_PREF+suff;
   ObjectSetString(0,nome,OBJPROP_TEXT,testo);
   ObjectSetInteger(0,nome,OBJPROP_BGCOLOR,on ? InpColTastoOn : InpColIntest);
   ObjectSetInteger(0,nome,OBJPROP_STATE,false);
  }

void DipingiTasti()
  {
   Tasto("b_hide",gNascosta ? "SHOW" : "HIDE",gNascosta);
   Tasto("b_refresh","REFRESH",false);
   Tasto("b_ha",gHA ? "HA ON" : "HA OFF",gHA);
   Tasto("b_doji",gDoji ? "DOJI ON" : "DOJI OFF",gDoji);
   Tasto("b_ema","EMA "+IntegerToString(InpEmaVeloce)+"/"+IntegerToString(InpEmaLenta)+(gEma ? " ON" : " OFF"),gEma);
   Tasto("b_st",gSt ? "ST 3 LIV ON" : "ST 3 LIV OFF",gSt);
   gRidisegna=true;
  }

string NomeR(int i,int j){ return(PD_PREF+"r_"+IntegerToString(i)+"_"+IntegerToString(j)); }
string NomeT(int i,int j){ return(PD_PREF+"t_"+IntegerToString(i)+"_"+IntegerToString(j)); }
string NomeS(int i){ return(PD_PREF+"s_"+IntegerToString(i)); }

//--- costruisce TUTTI gli oggetti una volta (e azzera la cache del disegno). Rispetta HIDE.
void Struttura()
  {
   int W=InpLarghezzaCella, Hc=InpAltezzaCella, B=LB();
   Rett(PD_PREF+"pannello",RX(0),RY(0),PW(),TotH(),InpColPannello);
   Bottone(PD_PREF+"b_hide",   RX(0),  RY(0), B,Hc);
   Bottone(PD_PREF+"b_refresh",RX(B),  RY(0), B,Hc);
   Bottone(PD_PREF+"b_ha",     RX(2*B),RY(0), B,Hc);
   Bottone(PD_PREF+"b_doji",   RX(0),  RY(Hc),B,Hc);
   Bottone(PD_PREF+"b_ema",    RX(B),  RY(Hc),B,Hc);
   Bottone(PD_PREF+"b_st",     RX(2*B),RY(Hc),B,Hc);
   DipingiTasti();
   Etic(PD_PREF+"titolo",RX(0)+(AngoloDestro() ? -PW()/2 : PW()/2),CY(2*Hc),gDoppio ? "PTE DASHBOARD: 2 COPIE! rimuovine una" : PD_TITOLO,InpColTesto);
   Etic(PD_PREF+"h_pair",CX(0),CY(3*Hc),"PAIR",InpColTesto);
   for(int j=0;j<gNT;j++)
     {
      Rett(PD_PREF+"hr_"+IntegerToString(j),RX(W*(1+j)),RY(3*Hc),W,Hc,InpColIntest);
      Etic(PD_PREF+"ht_"+IntegerToString(j),CX(W*(1+j)),CY(3*Hc),gTFn[j],InpColTesto);
     }
   for(int i=0;i<gNS;i++)
     {
      int y=Hc*(4+i);
      color cs=(gStatoSim[i]==0 ? InpColTesto : InpColSpento);   // anche quando si ricostruisce
      Etic(NomeS(i),CX(0),CY(y),gSym[i],cs);
      gColSim[i]=cs;
      for(int j=0;j<gNT;j++)
        {
         int k=i*gNT+j;
         Rett(NomeR(i,j),RX(W*(1+j)),RY(y),W,Hc,InpColVuota);
         Etic(NomeT(i,j),CX(W*(1+j)),CY(y)," ",InpColTesto);   // " ": un'etichetta vuota mostrerebbe "Label"
         gTxt[k]=" "; gBg[k]=InpColVuota; gTip[k]="";
         AggiornaCella(k);
        }
     }
   gRidisegna=true;
  }

//==================================================================
//  CELLA: compone testo/colore/tooltip e tocca l'oggetto SOLO se cambia
//==================================================================
void AggiornaCella(int k)
  {
   int i=k/gNT, j=k%gNT;
   string txt=" ";
   color  bg=InpColVuota;
   string base=gSym[i]+" "+gTFn[j]+": ";
   string tip;
   if(gStatoSim[i]==1)      tip=base+"fuori dal Market Watch (saltato)";
   else if(gStatoSim[i]==2) tip=base+"simbolo inesistente sul broker";
   else if(!gPronta[k])     tip=base+"dati non ancora pronti (riprova da solo)";
   else if(gDir[k]==0)      tip=base+"nessuna doji fuori canale nelle ultime "+IntegerToString(InpBarreIndietro)+" barre chiuse";
   else
     {
      txt=PD_Testo(gTSeg[k],PeriodSeconds(gTF[j]));
      bg=(gDir[k]>0 ? InpColRialzo : InpColRibasso);
      tip=base+(gDir[k]>0 ? "doji RIALZISTA (sotto)" : "doji RIBASSISTA (sopra)")+" "+
          TimeToString(gTSeg[k],TIME_DATE|TIME_MINUTES)+" ora server";
     }
   if(InpModoConfronto && gPronta[k] && gStatoSim[i]==0)
     {
      if(gDir[k]!=0) tip+=StringFormat(" | segnale V %+.2f L %+.2f ATR",gDF[k],gDS[k]);
      tip+=StringFormat(" | ultima chiusa V %+.2f L %+.2f ATR (>0 = corpo fuori)",gDF1[k],gDS1[k]);
     }
   if(gStatoSim[i]==0) tip+=" | click: apri "+gSym[i]+" "+gTFn[j];
   if(txt!=gTxt[k]){ ObjectSetString(0,NomeT(i,j),OBJPROP_TEXT,txt); gTxt[k]=txt; gRidisegna=true; }
   if(bg!=gBg[k]){ ObjectSetInteger(0,NomeR(i,j),OBJPROP_BGCOLOR,bg); gBg[k]=bg; gRidisegna=true; }
   if(tip!=gTip[k])
     {
      ObjectSetString(0,NomeR(i,j),OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,NomeT(i,j),OBJPROP_TOOLTIP,tip);
      gTip[k]=tip;
     }
  }

//==================================================================
//  SIMBOLI E TIMEFRAME
//==================================================================
void AggiungiLista(string lista)
  {
   string parti[];
   int n=StringSplit(lista,',',parti);
   for(int x=0;x<n;x++)
     {
      string s=parti[x];
      StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      ArrayResize(gSym,gNS+1);
      gSym[gNS]=s+InpSuffisso;
      gNS++;
     }
  }

void AggiungiTF(bool acceso,ENUM_TIMEFRAMES tf,string nome)
  {
   if(!acceso) return;
   ArrayResize(gTF,gNT+1); ArrayResize(gTFn,gNT+1);
   gTF[gNT]=tf; gTFn[gNT]=nome; gNT++;
  }

//--- stato dei simboli: all'avvio e poi ogni 60 s (37 letture, niente dati)
void AggiornaStatoSimboli()
  {
   for(int i=0;i<gNS;i++)
     {
      bool custom=false;
      int st=0;
      if(!SymbolExist(gSym[i],custom)) st=2;
      else if(InpSoloMarketWatch && SymbolInfoInteger(gSym[i],SYMBOL_SELECT)==0) st=1;
      if(st==gStatoSim[i]) continue;
      gStatoSim[i]=st;
      color col=(st==0 ? InpColTesto : InpColSpento);
      if(col!=gColSim[i]){ ObjectSetInteger(0,NomeS(i),OBJPROP_COLOR,col); gColSim[i]=col; gRidisegna=true; }
      for(int j=0;j<gNT;j++)
        {
         int k=i*gNT+j;
         if(st==0){ gProssimo[k]=0; gAttesa[k]=0; gUltBarra[k]=0; }
         AggiornaCella(k);
        }
     }
  }

int DurataBarra(ENUM_TIMEFRAMES tf)
  {
   if(tf==PERIOD_MN1) return(28*86400);      // il mese piu' corto: mai in ritardo sulla barra nuova
   return(PeriodSeconds(tf));
  }

void Rinvia(int k,datetime ora)
  {
   gAttesa[k]=(gAttesa[k]<=0 ? 2 : (gAttesa[k]>=150 ? 300 : gAttesa[k]*2));
   gProssimo[k]=ora+gAttesa[k];
  }

//==================================================================
//  UNA CELLA: ricalcolo SOLO se il simbolo/TF ha una barra nuova.
//  Ritorna true se ha fatto una copia di dati (costo vero).
//==================================================================
bool Elabora(int k,datetime ora)
  {
   int i=k/gNT, j=k%gNT;
   if(gStatoSim[i]!=0) return(false);
   if(ora<gProssimo[k]) return(false);
   string s=gSym[i];
   ENUM_TIMEFRAMES tf=gTF[j];
   datetime lb=(datetime)SeriesInfoInteger(s,tf,SERIES_LASTBAR_DATE);
   if(lb!=0 && lb==gUltBarra[k]){ gProssimo[k]=ora+InpRicontrolloSec; return(false); }   // nessuna barra nuova: niente copia
   //--- lb==0 (serie non ancora costruita): NON si rinvia senza copiare. E' la CopyRates
   //    che chiede al terminale di costruire la serie (in un indicatore non blocca: torna
   //    corta o -1 e la carica in sottofondo); se torna corta, rinvio con attesa crescente.
   //    Senza questo, una serie che resta a 0 finche' nessuno la chiede non si riempie MAI.
   int got=CopyRates(s,tf,0,gBisogno,gR);
   if(got<gBisogno){ Rinvia(k,ora); return(true); }
   ArrayResize(gO,got); ArrayResize(gH,got); ArrayResize(gL,got); ArrayResize(gC,got);
   for(int x=0;x<got;x++){ gO[x]=gR[x].open; gH[x]=gR[x].high; gL[x]=gR[x].low; gC[x]=gR[x].close; }
   int sh=0;
   double a=0, b=0, a1=0, b1=0;
   int r=PD_Ultimo(gO,gH,gL,gC,got,InpBarreIndietro,gPar,sh,a,b,a1,b1);
   if(r==PD_NODATI){ Rinvia(k,ora); return(true); }
   datetime tseg=(r!=0 ? gR[sh].time : (datetime)0);
   //--- alert: solo un segnale NUOVO sull'ultima barra chiusa, mai al primo calcolo
   if((InpAlertPopup || InpAlertSuono) && r!=0 && sh==1 && gPronta[k] && tseg!=gTSeg[k] &&
      ora-gUltAllerta[k]>=(long)InpAlertMinuti*60)
     {
      gUltAllerta[k]=ora;
      string m="PTE leggera: "+s+" "+gTFn[j]+(r>0 ? " doji RIALZISTA " : " doji RIBASSISTA ")+TimeToString(tseg,TIME_DATE|TIME_MINUTES);
      if(InpAlertPopup) Alert(m);
      if(InpAlertSuono) PlaySound("alert.wav");
     }
   gDir[k]=r; gTSeg[k]=tseg; gDF[k]=a; gDS[k]=b; gDF1[k]=a1; gDS1[k]=b1;
   gPronta[k]=true;
   gUltBarra[k]=gR[0].time;
   gAttesa[k]=0;
   gProssimo[k]=gR[0].time+DurataBarra(tf);   // prima della prossima barra non c'e' niente da fare
   AggiornaCella(k);
   return(true);
  }

//--- avviso se sul grafico ci sono due copie (si pestano gli oggetti PDL_). Ripetuto ogni 10 s e
//    reversibile: subito dopo un click (ricarico) la copia vecchia puo' esserci ancora per un attimo.
void ControllaDoppio()
  {
   int n=0, tot=ChartIndicatorsTotal(0,0);
   for(int x=0;x<tot;x++) if(ChartIndicatorName(0,0,x)==PD_NOME) n++;
   bool d=false;
   if(n>=2)
     {
      d=true;
      if(!gDoppio) Print("[PTE leggera] ATTENZIONE: ",n," copie su questo grafico. Ne serve UNA: rimuovi le altre.");
     }
   if(d!=gDoppio)
     {
      gDoppio=d;
      ObjectSetString(0,PD_PREF+"titolo",OBJPROP_TEXT,d ? "PTE DASHBOARD: 2 COPIE! rimuovine una" : PD_TITOLO);
      gRidisegna=true;
     }
  }

//==================================================================
//  v1.10 STATO DEI TASTI: GlobalVariable PD_GV<ChartID>_S<tasto> (stato) e _I<tasto> (input con cui
//  e' stato salvato). Sopravvive al RICARICO dell'indicatore (click = ChartSetSymbolPeriod).
//==================================================================
string GvChiave(string cosa){ return(PD_GV+IntegerToString(ChartID())+"_"+cosa); }

void GvSalva(string cosa,double v)
  {
   if(GlobalVariableSet(GvChiave(cosa),v)==0)
      Print("[PTE leggera] GlobalVariableSet fallita (",cosa,"), errore ",GetLastError(),": lo stato del tasto non sopravvivera' al cambio simbolo/TF.");
  }

bool StatoAvvio(string cosa,bool inp)
  {
   string ks=GvChiave("S"+cosa), ki=GvChiave("I"+cosa);
   bool has=(GlobalVariableCheck(ks) && GlobalVariableCheck(ki));
   bool gvOn=(has && GlobalVariableGet(ks)>0.5);
   bool gvIn=(has && GlobalVariableGet(ki)>0.5);
   bool on=PG_StatoIniziale(has,gvOn,gvIn,inp);
   GvSalva("S"+cosa,on ? 1.0 : 0.0);
   GvSalva("I"+cosa,inp ? 1.0 : 0.0);
   return(on);
  }

void GvPulisci()
  {
   string t[5]={"HIDE","HA","DOJI","EMA","ST"};
   for(int x=0;x<5;x++)
     {
      GlobalVariableDel(GvChiave("S"+t[x]));
      GlobalVariableDel(GvChiave("I"+t[x]));
     }
  }

//==================================================================
//  v1.10 COLORI DEL GRAFICO: nascondi (HA) / ripristina. COPIA della tecnica di
//  ABTG_Pulsanti_Grafico.mq5 (classi 963/971): i colori si catturano PRIMA di metterli a clrNONE; un
//  clrNONE trovato al momento della cattura (istanza morta senza ripristino) diventa un colore di ripiego.
//==================================================================
color ColOrDefault(const long v,const color def)
  {
   color c=(color)v;
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
      Print("[PTE leggera] impossibile nascondere le candele native (errore ",GetLastError(),").");
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

//--- candele native INVISIBILI su TUTTE e cinque le proprieta': firma di un HA finito senza OnDeinit
//    (crash, grafico salvato coi colori nascosti). Chi nasconde apposta solo candele/barre non e' toccato.
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
   Print("[PTE leggera] candele native trovate INVISIBILI (residuo di HEIKIN ASHI chiuso male): ",
         "rimesse visibili con colori di ripiego verde/rosso (F8 > Colori per i tuoi).");
  }

//--- HA acceso ma candele native di nuovo visibili (es. l'OnDeinit dell'istanza VECCHIA, dopo un click,
//    arriva DOPO questo OnInit e ripristina): si ricatturano i colori ATTUALI (quelli veri) e si
//    rinascondono. Al massimo 3 volte (poi qualcun altro le vuole visibili: si smette).
void CuraColori()
  {
   if(!gHA || gCure>=3) return;
   if(IsNone(CHART_COLOR_CANDLE_BULL) && IsNone(CHART_COLOR_CANDLE_BEAR) &&
      IsNone(CHART_COLOR_CHART_UP) && IsNone(CHART_COLOR_CHART_DOWN)) return;
   gCure++;
   gColsHidden=false;
   ColsHide();
   if(gCure>=3) Print("[PTE leggera] le candele native continuano a riapparire con HA acceso: smetto di nasconderle.");
   gRidisegna=true;
  }

//==================================================================
//  v1.10 PLOT: cosa si DISEGNA (il calcolo incrementale di HA/EMA/ST continua comunque, O(1) per tick)
//==================================================================
void ApplicaPlot()
  {
   PlotIndexSetInteger(0,PLOT_DRAW_TYPE,gHA ? DRAW_COLOR_CANDLES : DRAW_NONE);
   PlotIndexSetInteger(0,PLOT_SHOW_DATA,gHA);
   for(int p=1;p<=4;p++)
     {
      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,InpDisegnaCanali ? DRAW_LINE : DRAW_NONE);
      PlotIndexSetInteger(p,PLOT_SHOW_DATA,InpDisegnaCanali);
     }
   for(int p=5;p<=6;p++)
     {
      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gEma ? DRAW_LINE : DRAW_NONE);
      PlotIndexSetInteger(p,PLOT_SHOW_DATA,gEma);
     }
   for(int p=7;p<=8;p++)
     {
      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gEma ? DRAW_ARROW : DRAW_NONE);
      PlotIndexSetInteger(p,PLOT_SHOW_DATA,gEma);
     }
   PlotIndexSetInteger(7,PLOT_ARROW,233);
   PlotIndexSetInteger(8,PLOT_ARROW,234);
   for(int p=9;p<=14;p++)
     {
      PlotIndexSetInteger(p,PLOT_DRAW_TYPE,gSt ? DRAW_LINE : DRAW_NONE);
      PlotIndexSetInteger(p,PLOT_SHOW_DATA,gSt);
     }
  }

//==================================================================
//  v1.10 GRAFICO CORRENTE: istantanea, doji, canali (SOLO a barra nuova)
//==================================================================
void Istantanea(const int rt,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[])
  {
   int n=(rt<gBisognoGraf ? rt : gBisognoGraf);
   ArrayResize(gXo,n); ArrayResize(gXh,n); ArrayResize(gXl,n); ArrayResize(gXc,n);
   ArrayResize(gXhh,n); ArrayResize(gXhl,n); ArrayResize(gXt,n);
   for(int x=0;x<n;x++)
     {
      int y=rt-1-x;
      gXo[x]=open[y]; gXh[x]=high[y]; gXl[x]=low[y]; gXc[x]=close[y];
      gXt[x]=time[y]; gXhh[x]=bHAh[y]; gXhl[x]=bHAl[y];
     }
   gXn=n; gXrt=rt;
  }

//--- frecce sulle doji fuori canale delle ultime InpBarreIndietro barre chiuse (regola delle celle)
void MarcaDoji()
  {
   ObjectsDeleteAll(0,PD_DOJI);
   gMarcNome="";
   gRidisegna=true;
   if(gXn<=0) return;
   int nm=PD_Marca(gXo,gXh,gXl,gXc,gXn,InpBarreIndietro,gPar,gMs,gMd,gMf,gMl);
   for(int q=0;q<nm;q++)
     {
      int s=gMs[q];
      bool su=(gMd[q]>0);                       // sotto il canale = rialzista: freccia SU sotto la candela
      string nome=PD_DOJI+IntegerToString((long)gXt[s]);
      double pr=(su ? gXhl[s] : gXhh[s]);
      if(!ObjectCreate(0,nome,OBJ_ARROW,0,gXt[s],pr)) continue;
      ObjectSetInteger(0,nome,OBJPROP_ARROWCODE,su ? 233 : 234);
      ObjectSetInteger(0,nome,OBJPROP_ANCHOR,su ? ANCHOR_TOP : ANCHOR_BOTTOM);
      ObjectSetInteger(0,nome,OBJPROP_COLOR,su ? InpColRialzo : InpColRibasso);
      ObjectSetInteger(0,nome,OBJPROP_WIDTH,2);
      ObjectSetInteger(0,nome,OBJPROP_BACK,false);
      ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
      ObjectSetString(0,nome,OBJPROP_TOOLTIP,(su ? "Doji RIALZISTA (corpo SOTTO il canale) " : "Doji RIBASSISTA (corpo SOPRA il canale) ")+
                      TimeToString(gXt[s],TIME_DATE|TIME_MINUTES)+" ora server"+
                      StringFormat(" | corpo-canale V %+.2f L %+.2f ATR (>0 = fuori)",gMf[q],gMl[q]));
      if(gMarcNome=="") gMarcNome=nome;
     }
  }

//--- canali TMA sulle ultime InpBarreCanali barre chiuse (stessa PD_Banda delle celle)
void Canali()
  {
   int rt=gXrt;
   int vecchio=rt-1-InpBarreCanali;
   if(vecchio<0) vecchio=0;
   if(gCanDa>=0)
      for(int x=gCanDa;x<vecchio && x<rt;x++){ bCVs[x]=EMPTY_VALUE; bCVi[x]=EMPTY_VALUE; bCLs[x]=EMPTY_VALUE; bCLi[x]=EMPTY_VALUE; }
   gCanDa=vecchio;
   for(int s=1;s<=InpBarreCanali;s++)
     {
      int x=rt-1-s;
      if(x<0) break;
      double mid=0, up=0, lo=0, a=0;
      if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaF,gPar.atrF,gPar.multF,mid,up,lo,a)){ bCVs[x]=up; bCVi[x]=lo; }
      else { bCVs[x]=EMPTY_VALUE; bCVi[x]=EMPTY_VALUE; }
      if(PD_Banda(gXh,gXl,gXc,gXn,s,gPar.tmaModo,gPar.tmaS,gPar.atrS,gPar.multS,mid,up,lo,a)){ bCLs[x]=up; bCLi[x]=lo; }
      else { bCLs[x]=EMPTY_VALUE; bCLi[x]=EMPTY_VALUE; }
     }
  }

//==================================================================
//  v1.10 TASTI
//==================================================================
//--- REFRESH: azzera la cache di TUTTE le celle; il ricalcolo lo fa il timer al ritmo normale
//    (InpCellePerCiclo al secondo): qui NESSUNA copia di dati.
void Refresh()
  {
   int nc=gNS*gNT;
   for(int k=0;k<nc;k++)
     {
      gProssimo[k]=0;
      gAttesa[k]=0;
      gUltBarra[k]=0;
      gPronta[k]=false;                 // niente alert al primo ricalcolo; la cella si mostra vuota finche' non torna
      AggiornaCella(k);
     }
   gUltStato=0;                         // stato dei simboli riletto al prossimo giro
   gCursore=0;
   if(gDoji) MarcaDoji();               // dall'istantanea: nessuna copia
   gRidisegna=true;
  }

void Nascondi(bool on)
  {
   gNascosta=on;
   GvSalva("SHIDE",on ? 1.0 : 0.0);
   Struttura();                          // riapplica la visibilita' a TUTTI gli oggetti (Periodi)
   if(!on) Refresh();                    // allo SHOW si ricalcola subito
  }

void ImpostaHA(bool on)
  {
   gHA=on;
   GvSalva("SHA",on ? 1.0 : 0.0);
   if(on){ gCure=0; ColsHide(); }
   else ColsRestore();
   ApplicaPlot();
  }

void ImpostaDoji(bool on)
  {
   gDoji=on;
   GvSalva("SDOJI",on ? 1.0 : 0.0);
   if(on) MarcaDoji();
   else { ObjectsDeleteAll(0,PD_DOJI); gMarcNome=""; gRidisegna=true; }
  }

void ImpostaEma(bool on)
  {
   gEma=on;
   GvSalva("SEMA",on ? 1.0 : 0.0);
   ApplicaPlot();
  }

void ImpostaSt(bool on)
  {
   gSt=on;
   GvSalva("SST",on ? 1.0 : 0.0);
   ApplicaPlot();
  }

//--- CLICK su simbolo/cella/TF: il grafico va li' (o un grafico nuovo con InpClickNuovoGrafico).
//    ChartSetSymbolPeriod RICARICA questo indicatore: lo stato dei tasti resta (GlobalVariable), la
//    cache della tabella no (si riempie in ~6 s).
//    Classe 930 (cancello 07/10): se su QUESTO grafico gira un EA, cambiargli simbolo o TF lo
//    reinizializza su un altro strumento (opererebbe li', col suo magic e il suo rischio): il grafico
//    NON si tocca e non se ne apre un altro (classe 951: un grafico nuovo nasce da default.tpl).
void VaiA(string sym,ENUM_TIMEFRAMES tf)
  {
   if(!InpClickNuovoGrafico)
     {
      if(sym==_Symbol && tf==_Period) return;               // gia' qui: niente ricarico
      string ea=ChartGetString(0,CHART_EXPERT_NAME);
      if(StringLen(ea)>0)
        {
         Alert("[PTE leggera] su QUESTO grafico gira l'EA '",ea,"': simbolo/TF NON cambiati (l'EA si riavvierebbe su ",sym,"). Metti la dashboard su un grafico SENZA EA.");
         return;
        }
     }
   if(SymbolInfoInteger(sym,SYMBOL_SELECT)==0 && !SymbolSelect(sym,true))
     {
      Print("[PTE leggera] ",sym,": non si puo' aggiungere al Market Watch (inesistente sul broker? suffisso giusto in InpSuffisso?), errore ",GetLastError());
      return;
     }
   if(InpClickNuovoGrafico)
     {
      long id=ChartOpen(sym,tf);
      if(id==0) Print("[PTE leggera] ChartOpen ",sym," fallita, errore ",GetLastError());
      else SorvegliaNuovo(id);                              // classe 951: EA arrivato col modello?
      return;
     }
   if(!ChartSetSymbolPeriod(0,sym,tf)) Print("[PTE leggera] ChartSetSymbolPeriod ",sym," fallita, errore ",GetLastError());
  }

//--- classe 951: un grafico aperto dal click nasce da default.tpl; se quel modello contiene un EA, il
//    grafico nuovo ha un EA ACCESO. Si guarda CHART_EXPERT_NAME per ~10 s e si avvisa a voce alta.
long gNuovoId[8];
int  gNuovoFino[8];
int  gNuovoN=0;

void SorvegliaNuovo(long id)
  {
   if(gNuovoN>=8)
     {
      for(int x=1;x<8;x++){ gNuovoId[x-1]=gNuovoId[x]; gNuovoFino[x-1]=gNuovoFino[x]; }
      gNuovoN=7;
     }
   gNuovoId[gNuovoN]=id;
   gNuovoFino[gNuovoN]=gGiri+10;
   gNuovoN++;
  }

void ControllaNuovi()
  {
   int tieni=0;
   for(int x=0;x<gNuovoN;x++)
     {
      long id=gNuovoId[x];
      bool via=false;
      string sy=ChartSymbol(id);
      if(StringLen(sy)==0) via=true;                        // grafico gia' chiuso
      else
        {
         string ea=ChartGetString(id,CHART_EXPERT_NAME);
         if(StringLen(ea)>0)
           {
            Alert("[PTE leggera] ATTENZIONE: il grafico ",sy," appena aperto dal click ha un EA ACCESO: '",ea,"' (arriva dal modello default.tpl). Se non lo volevi, toglilo SUBITO.");
            via=true;
           }
         else if(gGiri>gNuovoFino[x]) via=true;             // ~10 s senza EA: a posto
        }
      if(!via){ gNuovoId[tieni]=gNuovoId[x]; gNuovoFino[tieni]=gNuovoFino[x]; tieni++; }
     }
   gNuovoN=tieni;
  }

//==================================================================
//  EVENTI
//==================================================================
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,PD_NOME);
   if(InpLarghezzaCella<10 || InpAltezzaCella<8 || InpFontSize<4 || InpBarreIndietro<1 || InpBarreIndietro>500 ||
      InpTmaLento<1 || InpTmaVeloce<1 || InpAtrLento<1 || InpAtrVeloce<1 || InpMultLento<=0 || InpMultVeloce<=0 ||
      InpCorpoMaxPct<=0 || InpCellePerCiclo<1 || InpRicontrolloSec<1 || InpSemeHA<0 || InpAlertMinuti<0)
     {
      Print("[PTE leggera] parametri non validi: controlla dimensioni, periodi, moltiplicatori e barre (1-500).");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpBarreCanali<1 || InpBarreCanali>5000 || InpEmaVeloce<1 || InpEmaLenta<1 || InpStPeriodo<1 ||
      InpStMult1<=0 || InpStMult2<=0 || InpStMult3<=0)
     {
      Print("[PTE leggera] parametri del grafico non validi: barre canali 1-5000, periodi EMA/ATR >= 1, moltiplicatori > 0.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   gNS=0; ArrayResize(gSym,0);
   AggiungiLista(InpLista1); AggiungiLista(InpLista2); AggiungiLista(InpLista3);
   AggiungiLista(InpLista4); AggiungiLista(InpLista5);
   gNT=0; ArrayResize(gTF,0); ArrayResize(gTFn,0);
   AggiungiTF(InpM15,PERIOD_M15,"M15"); AggiungiTF(InpM30,PERIOD_M30,"M30");
   AggiungiTF(InpH1,PERIOD_H1,"H1");    AggiungiTF(InpH4,PERIOD_H4,"H4");
   AggiungiTF(InpH8,PERIOD_H8,"H8");    AggiungiTF(InpH12,PERIOD_H12,"H12");
   AggiungiTF(InpD1,PERIOD_D1,"D1");    AggiungiTF(InpW1,PERIOD_W1,"W1");
   AggiungiTF(InpMN,PERIOD_MN1,"MN");
   if(gNS==0 || gNT==0)
     {
      Print("[PTE leggera] nessun simbolo o nessun timeframe acceso: niente da mostrare.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   gPar.candela=(int)InpCandela;  gPar.tmaModo=(int)InpTmaModo;
   gPar.tmaS=InpTmaLento;         gPar.atrS=InpAtrLento;   gPar.multS=InpMultLento;
   gPar.tmaF=InpTmaVeloce;        gPar.atrF=InpAtrVeloce;  gPar.multF=InpMultVeloce;
   gPar.corpoMaxPct=InpCorpoMaxPct;
   gPar.soloFuori=InpSoloFuoriCanale; gPar.canale=(int)InpCanale;
   gPar.usaCode=InpUsaCode; gPar.rapInf=InpRapCodaInf; gPar.rapSup=InpRapCodaSup;
   gPar.flip=InpConfermaFlip; gPar.semeHA=InpSemeHA;
   gBisogno=PD_Bisogno(gPar,InpBarreIndietro);
   gBisognoGraf=PD_Bisogno(gPar,(InpDisegnaCanali && InpBarreCanali>InpBarreIndietro) ? InpBarreCanali : InpBarreIndietro);

   int nc=gNS*gNT;
   ArrayResize(gStatoSim,gNS); ArrayInitialize(gStatoSim,-1);
   ArrayResize(gColSim,gNS);
   ArrayResize(gUltBarra,nc);  ArrayInitialize(gUltBarra,0);
   ArrayResize(gProssimo,nc);  ArrayInitialize(gProssimo,0);
   ArrayResize(gAttesa,nc);    ArrayInitialize(gAttesa,0);
   ArrayResize(gDir,nc);       ArrayInitialize(gDir,0);
   ArrayResize(gTSeg,nc);      ArrayInitialize(gTSeg,0);
   ArrayResize(gPronta,nc);    for(int x=0;x<nc;x++) gPronta[x]=false;
   ArrayResize(gUltAllerta,nc);ArrayInitialize(gUltAllerta,0);
   ArrayResize(gDF,nc);  ArrayResize(gDS,nc);  ArrayResize(gDF1,nc);  ArrayResize(gDS1,nc);
   ArrayInitialize(gDF,0); ArrayInitialize(gDS,0); ArrayInitialize(gDF1,0); ArrayInitialize(gDS1,0);
   ArrayResize(gTxt,nc); ArrayResize(gBg,nc); ArrayResize(gTip,nc);
   ArraySetAsSeries(gR,true);                 // gR[0] = barra in formazione, come gli array del blocco puro
   ArrayResize(gMs,InpBarreIndietro); ArrayResize(gMd,InpBarreIndietro);
   ArrayResize(gMf,InpBarreIndietro); ArrayResize(gMl,InpBarreIndietro);

   //--- buffer: 0-18 disegnati, 19-31 di calcolo
   bool ok=true;
   ok=SetIndexBuffer(0, bHAo,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(1, bHAh,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(2, bHAl,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(3, bHAc,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(4, bHAcol, INDICATOR_COLOR_INDEX)  && ok;
   ok=SetIndexBuffer(5, bCVs,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(6, bCVi,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(7, bCLs,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(8, bCLi,   INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(9, bEmaV,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(10,bEmaL,  INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(11,bIncSu, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(12,bIncGiu,INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(13,bSt1Su, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(14,bSt1Giu,INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(15,bSt2Su, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(16,bSt2Giu,INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(17,bSt3Su, INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(18,bSt3Giu,INDICATOR_DATA)         && ok;
   ok=SetIndexBuffer(19,kAtr,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(20,kUp1,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(21,kDn1,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(22,kDir1,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(23,kVal1,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(24,kUp2,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(25,kDn2,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(26,kDir2,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(27,kVal2,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(28,kUp3,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(29,kDn3,   INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(30,kDir3,  INDICATOR_CALCULATIONS) && ok;
   ok=SetIndexBuffer(31,kVal3,  INDICATOR_CALCULATIONS) && ok;
   if(!ok)
     {
      Print("[PTE leggera] SetIndexBuffer fallita, errore ",GetLastError());
      return(INIT_FAILED);
     }
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,InpColHASu);
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,InpColHAGiu);
   PlotIndexSetInteger(1,PLOT_LINE_COLOR,InpColCanaleV);
   PlotIndexSetInteger(2,PLOT_LINE_COLOR,InpColCanaleV);
   PlotIndexSetInteger(3,PLOT_LINE_COLOR,InpColCanaleL);
   PlotIndexSetInteger(4,PLOT_LINE_COLOR,InpColCanaleL);
   PlotIndexSetInteger(5,PLOT_LINE_COLOR,InpColEmaVeloce);
   PlotIndexSetInteger(6,PLOT_LINE_COLOR,InpColEmaLenta);
   PlotIndexSetInteger(7,PLOT_LINE_COLOR,InpColIncSu);
   PlotIndexSetInteger(8,PLOT_LINE_COLOR,InpColIncGiu);
   PlotIndexSetInteger(7,PLOT_ARROW_SHIFT,12);           // freccia SU sotto la candela
   PlotIndexSetInteger(8,PLOT_ARROW_SHIFT,-12);          // freccia GIU sopra la candela
   PlotIndexSetInteger(9, PLOT_LINE_COLOR,InpColSt1Su);
   PlotIndexSetInteger(10,PLOT_LINE_COLOR,InpColSt1Giu);
   PlotIndexSetInteger(11,PLOT_LINE_COLOR,InpColSt2Su);
   PlotIndexSetInteger(12,PLOT_LINE_COLOR,InpColSt2Giu);
   PlotIndexSetInteger(13,PLOT_LINE_COLOR,InpColSt3Su);
   PlotIndexSetInteger(14,PLOT_LINE_COLOR,InpColSt3Giu);
   PlotIndexSetInteger(9, PLOT_LINE_WIDTH,1);
   PlotIndexSetInteger(10,PLOT_LINE_WIDTH,1);
   PlotIndexSetInteger(11,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(12,PLOT_LINE_WIDTH,2);
   PlotIndexSetInteger(13,PLOT_LINE_WIDTH,3);
   PlotIndexSetInteger(14,PLOT_LINE_WIDTH,3);
   PlotIndexSetInteger(5,PLOT_DRAW_BEGIN,InpEmaVeloce-1);
   PlotIndexSetInteger(6,PLOT_DRAW_BEGIN,InpEmaLenta-1);
   for(int p=9;p<=14;p++) PlotIndexSetInteger(p,PLOT_DRAW_BEGIN,InpStPeriodo);
   PlotIndexSetString(5,PLOT_LABEL,"EMA "+IntegerToString(InpEmaVeloce));
   PlotIndexSetString(6,PLOT_LABEL,"EMA "+IntegerToString(InpEmaLenta));
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);

   //--- stato dei tasti: dalla GlobalVariable se l'input di partenza non e' cambiato, se no dall'input
   gNascosta=StatoAvvio("HIDE",InpNascostaDefault);
   gHA=StatoAvvio("HA",InpHaDefault);
   gDoji=StatoAvvio("DOJI",InpDojiDefault);
   gEma=StatoAvvio("EMA",InpEmaDefault);
   gSt=StatoAvvio("ST",InpStDefault);

   ObjectsDeleteAll(0,PD_PREF);               // oggetti rimasti da una chiusura anomala
   ObjectsDeleteAll(0,PD_DOJI);
   gProprietario=true;
   gCursore=0; gDoppio=false; gGiri=0;
   gXn=0; gXrt=0; gUltBarraGraf=0; gCanDa=-1; gMarcNome=""; gCure=0;
   Struttura();
   AggiornaStatoSimboli();
   gUltStato=TimeCurrent();
   ApplicaPlot();
   if(gHA)
      ColsHide();     // ultimo passo: da qui OnDeinit ripristina sempre
   else
      RepairInvisibleNative();
   EventSetTimer(1);
   PrintFormat("[PTE leggera] %d simboli x %d TF = %d celle, %d oggetti, %d barre per copia, 0 handle. TMA %s, candele %s, canale %d.",
               gNS,gNT,nc,9+2*gNT+gNS*(1+2*gNT),gBisogno,EnumToString(InpTmaModo),EnumToString(InpCandela),(int)InpCanale);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   ColsRestore();                             // OGNI motivo di uscita: le candele native tornano
   if(gProprietario)
     {
      ObjectsDeleteAll(0,PD_PREF);
      ObjectsDeleteAll(0,PD_DOJI);
     }
   if(reason==REASON_REMOVE || reason==REASON_CHARTCLOSE)
      GvPulisci();                             // tolto l'indicatore / chiuso il grafico: lo stato dei tasti si dimentica
   ChartRedraw(0);
  }

//--- il giro delle celle: SOLO con la tabella visibile
void GiroCelle(datetime ora)
  {
   if(ora-gUltStato>=60)
     {
      gUltStato=ora;
      AggiornaStatoSimboli();
     }
   int tot=gNS*gNT, fatte=0, viste=0;
   while(viste<tot && fatte<InpCellePerCiclo)
     {
      int k=gCursore;
      gCursore=(gCursore+1)%tot;
      viste++;
      if(Elabora(k,ora)) fatte++;
     }
  }

void OnTimer()
  {
   datetime ora=TimeCurrent();
   gGiri++;
   if(gGiri%10==3) ControllaDoppio();
   //--- oggetti spariti (a mano, o l'OnDeinit dell'istanza vecchia arrivato DOPO questo OnInit dopo un click)
   if(ObjectFind(0,PD_PREF+"pannello")<0 || ObjectFind(0,PD_PREF+"b_hide")<0) Struttura();
   if(gDoji && gMarcNome!="" && ObjectFind(0,gMarcNome)<0) MarcaDoji();
   CuraColori();
   if(gNuovoN>0) ControllaNuovi();
   if(!gNascosta) GiroCelle(ora);             // NASCOSTA: carico zero, nessuna copia e nessun ricalcolo
   if(gRidisegna)
     {
      gRidisegna=false;
      ChartRedraw(0);
     }
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id!=CHARTEVENT_OBJECT_CLICK) return;
   if(StringFind(sparam,PD_PREF)!=0) return;  // guardia: solo i NOSTRI oggetti
   bool tasto=true;
   if(sparam==PD_PREF+"b_hide")         Nascondi(!gNascosta);
   else if(sparam==PD_PREF+"b_refresh") Refresh();
   else if(sparam==PD_PREF+"b_ha")      ImpostaHA(!gHA);
   else if(sparam==PD_PREF+"b_doji")    ImpostaDoji(!gDoji);
   else if(sparam==PD_PREF+"b_ema")     ImpostaEma(!gEma);
   else if(sparam==PD_PREF+"b_st")      ImpostaSt(!gSt);
   else tasto=false;
   if(tasto)
     {
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);   // il tasto torna su
      DipingiTasti();
      gRidisegna=false;
      ChartRedraw(0);
      return;
     }
   int i=-1, j=-1;
   int tipo=PD_Bersaglio(sparam,gNS,gNT,i,j);
   if(tipo==0) return;
   string sym=(i>=0 ? gSym[i] : _Symbol);
   ENUM_TIMEFRAMES tf=(j>=0 ? gTF[j] : (ENUM_TIMEFRAMES)_Period);
   VaiA(sym,tf);
  }

//--- GRAFICO CORRENTE. Nessuna copia dati: gli array del terminale. Per tick SOLO la barra in formazione
//    (incrementale); frecce doji, incroci EMA e canali SOLO a barra nuova (sulle barre CHIUSE).
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],const long &tick_volume[],
                const long &volume[],const int &spread[])
  {
   if(rates_total<3) return(0);
   ArraySetAsSeries(time,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   bool pieno=(prev_calculated<=0 || prev_calculated>rates_total);
   //--- classe 965: l'indice incrementale si ANCORA all'ora. Se lo storico e' scorso (barre vecchie tolte
   //    con rates_total costante) la barra prev_calculated-1 non e' piu' quella vista: si riparte da zero.
   if(!pieno && time[prev_calculated-1]!=gUltBarraGraf) pieno=true;
   int da=(pieno ? 0 : prev_calculated-1);
   if(pieno)
     {
      ArrayInitialize(bCVs,EMPTY_VALUE); ArrayInitialize(bCVi,EMPTY_VALUE);
      ArrayInitialize(bCLs,EMPTY_VALUE); ArrayInitialize(bCLi,EMPTY_VALUE);
      ArrayInitialize(bIncSu,EMPTY_VALUE); ArrayInitialize(bIncGiu,EMPTY_VALUE);
      gUltBarraGraf=0; gCanDa=-1;
     }
   else
      for(int x=prev_calculated;x<rates_total;x++)
        { bCVs[x]=EMPTY_VALUE; bCVi[x]=EMPTY_VALUE; bCLs[x]=EMPTY_VALUE; bCLi[x]=EMPTY_VALUE; bIncSu[x]=EMPTY_VALUE; bIncGiu[x]=EMPTY_VALUE; }
   //--- HA classica ricorsiva (seme (o+c)/2 sulla barra piu' vecchia), EMA, Supertrend: dalla barra 'da'
   PG_HA(open,high,low,close,rates_total,da,bHAo,bHAh,bHAl,bHAc);
   for(int x=da;x<rates_total;x++) bHAcol[x]=(bHAc[x]>=bHAo[x]) ? 0.0 : 1.0;
   PG_EMA(close,rates_total,da,InpEmaVeloce,bEmaV);
   PG_EMA(close,rates_total,da,InpEmaLenta,bEmaL);
   SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult1,kAtr,kUp1,kDn1,kDir1,kVal1);
   SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult2,kAtr,kUp2,kDn2,kDir2,kVal2);
   SW_STCore(high,low,close,rates_total,da,InpStPeriodo,InpStMult3,kAtr,kUp3,kDn3,kDir3,kVal3);
   for(int x=da;x<rates_total;x++)
     {
      bSt1Su[x]=PG_StLinea(true,kDir1[x],kVal1[x],1.0); bSt1Giu[x]=PG_StLinea(true,kDir1[x],kVal1[x],-1.0);
      bSt2Su[x]=PG_StLinea(true,kDir2[x],kVal2[x],1.0); bSt2Giu[x]=PG_StLinea(true,kDir2[x],kVal2[x],-1.0);
      bSt3Su[x]=PG_StLinea(true,kDir3[x],kVal3[x],1.0); bSt3Giu[x]=PG_StLinea(true,kDir3[x],kVal3[x],-1.0);
     }
   //--- incroci EMA: SOLO barre chiuse (x <= rates_total-2), la barra in formazione mai
   int primo=(InpEmaVeloce>InpEmaLenta ? InpEmaVeloce : InpEmaLenta);
   for(int x=(da<1 ? 1 : da);x<rates_total-1;x++)
     {
      int r=PD_Incrocio(bEmaV,bEmaL,x,primo);
      bIncSu[x]=(r>0 ? bHAl[x] : EMPTY_VALUE);
      bIncGiu[x]=(r<0 ? bHAh[x] : EMPTY_VALUE);
     }
   bIncSu[rates_total-1]=EMPTY_VALUE; bIncGiu[rates_total-1]=EMPTY_VALUE;
   //--- barra nuova: istantanea, frecce doji (solo con DOJI acceso), canali (solo con l'input)
   if(time[rates_total-1]!=gUltBarraGraf)
     {
      gUltBarraGraf=time[rates_total-1];
      Istantanea(rates_total,time,open,high,low,close);
      if(gDoji) MarcaDoji();
      if(InpDisegnaCanali) Canali();
      gRidisegna=true;
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
