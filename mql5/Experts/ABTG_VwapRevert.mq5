//+------------------------------------------------------------------+
//|                                          ABTG_VwapRevert.mq5     |
//|                                                                  |
//|  EA "VWAP MEAN REVERSION" - MT5 - TUTTO-IN-UNO                   |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  DA DOVE VIENE (attribuzione obbligatoria)                       |
//|    Porting del Pine Script "VWAP Mean Reversion Strategy" di     |
//|    sumbloke077 (TradingView, creato 2026-04-02, v2.0,            |
//|    scriptAccess open_no_auth, NESSUNA licenza dichiarata nel     |
//|    sorgente -> l'attribuzione va ripetuta ovunque).              |
//|    https://www.tradingview.com/script/YBqnzqDK-VWAP-Mean-Reversion-Strategy/
//|    Copia del sorgente in casa:                                   |
//|      backtest_pipeline/caccia_strategie/biblioteca/sorgenti/     |
//|      VwapMeanReversion_sumbloke077_tvYBqnzqDK_2026-08-25.pine    |
//|    ATTENZIONE: in biblioteca ci sono DUE VWAP reversion. Questo   |
//|    e' il YBqnzqDK di sumbloke077 (P1), NON il                     |
//|    VwapSD2Reversion_jswapnil_tvoSV81CXs (scartato: long-only,     |
//|    lotto fisso, TP/SL a 5 pip da forex).                          |
//|    Scheda del candidato (P1, voto 8/10):                          |
//|      backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md
//|    Tesi del porting (scostamenti dichiarati uno per uno):         |
//|      VWAPREVERT_TESI.md                                           |
//|    File prova (bozza del cacciatore):                             |
//|      backtest_pipeline/prove/VWAPREVERT_DAX_M15_BOZZA.txt         |
//|                                                                   |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in        |
//|  forward finche' un round a TICK REALI non lo promuove.           |
//|                                                                   |
//|  LA TESI IN UNA RIGA                                              |
//|    Dentro la sessione la VWAP e' il prezzo che il flusso ha       |
//|    davvero pagato: quando il prezzo si allontana oltre una        |
//|    deviazione standard E li' dentro stampa una candela di         |
//|    rifiuto all'estremo delle ultime N barre, chi ha inseguito e'  |
//|    in perdita e il ritorno verso la VWAP e' il suo costo.         |
//|                                                                   |
//|  IL MOTORE - DUE BARRE E QUATTRO CONDIZIONI                       |
//|    barra di SETUP (MT5 shift 2):                                  |
//|      (a) e' un HAMMER (long) / SHOOTING STAR (short) oppure un    |
//|          DOJI, secondo la geometria dell'autore;                  |
//|      (b) tocca l'ESTREMO delle ultime InpLookback barre;          |
//|      (c) la sua CHIUSURA sta FUORI dalla banda VWAP +/- kSIGMA.   |
//|    barra di CONFERMA (MT5 shift 1):                               |
//|      (d) chiude nel InpClosePct del proprio range dal lato        |
//|          favorevole, ED e' ENGULFING oppure continuazione         |
//|          (minimo piu' alto + chiusura sopra il massimo prec.),    |
//|          ED ha range <= InpAtrMult x ATR (anti-candelone).        |
//|    Poi: ordine STOP oltre l'estremo della barra di conferma,      |
//|    vivo InpOrderLifeBars barre; SL all'estremo opposto della      |
//|    stessa barra; TP a InpTpR volte R.                             |
//|    Simmetrico long/short: stesso codice, estremi specchiati.      |
//|                                                                   |
//|  LA BANDA E IL RIFIUTO SONO COSTITUTIVI, NON FILTRI.              |
//|    Non esiste nessun input che li spenga. Senza la banda VWAP     |
//|    NON C'E' SEGNALE, e senza la candela di rifiuto all'estremo    |
//|    nemmeno. E' esattamente il punto della scheda P1: in casa la   |
//|    VWAP l'abbiamo misurata SOLO come FILTRO DIREZIONALE           |
//|    appiccicato al motore aperture (R101 gradino 07_vwap:          |
//|    INCOERENTE fra Dow e DAX -> bocciato). Qui e' il MOTORE.       |
//|    ROBUSTEZZA.md misura la differenza fra le due forme:           |
//|    filtro aggiunto dopo = 0 successi su 5; filtro che E' la       |
//|    strategia = 30 celle su 30. Un input che spegnesse la banda    |
//|    trasformerebbe l'EA in un altro motore e renderebbe la         |
//|    misura irripetibile.                                            |
//|    Conseguenza operativa: SIGMA <= 0 (sessione appena aperta,     |
//|    nessuna dispersione misurabile) = NIENTE SEGNALE. Un filtro    |
//|    senza dati non deve inventare un veto, ma un MOTORE senza      |
//|    dati non esiste.                                                |
//|                                                                   |
//|  QUALE VOLUME: TICK VOLUME (numero di tick della barra).          |
//|    La VWAP dell'autore e' pesata sul volume del suo feed (su un   |
//|    future = volume vero). Sugli indici CFD di BCM il volume       |
//|    scambiato non esiste nel feed: SYMBOL_VOLUME_REAL non e'       |
//|    garantito. E' uno SCOSTAMENTO DICHIARATO, non un dettaglio:    |
//|    e' il dato su cui poggia la banda, cioe' il motore intero.     |
//|    Stessa convenzione di VwapBias() in ABTG_DAX_Apertura_EU.      |
//|                                                                   |
//|  DOVE DEVE GIRARE: INDICI (D30EUR, U30USD, NASUSD), M15 (M30 e'   |
//|  una via di prova legittima: il tetto delle ~100.000 barre per    |
//|  corsa a M30 copre circa 8 anni, a M15 circa 4, a M5 circa 1,3).  |
//|  Nessun calcolo assume il forex: la distanza dello stop e' in     |
//|  PREZZO, il lotto esce da OrderCalcProfit (che converte in        |
//|  valuta conto) e il ripiego e' tick value / tick size. Le soglie  |
//|  in "punti" sono PUNTI MT5 (_Point), non punti indice: su U30USD  |
//|  e NASUSD 1 punto indice = 100 punti MT5 (misura R97).            |
//|                                                                   |
//|  DECIDE SOLO A BARRA CHIUSA. Setup su [2], conferma su [1],       |
//|  ordine pendente piazzato all'apertura della barra [0]: e'        |
//|  l'equivalente MT5 di uno strategy Pine con                       |
//|  calc_on_every_tick = false. Niente look-ahead, niente repaint.   |
//|                                                                   |
//|  CAP GIORNALIERO OBBLIGATORIO (criterio C6 del dossier):          |
//|  InpMaxTradesPerDay parte a 2. Insieme al FLAT DI FINE SEDUTA     |
//|  qui sotto sono i DUE soli default che si scostano dall'autore    |
//|  per REGOLA DI CASA e non per misura.                             |
//|                                                                   |
//|  FLAT DI FINE SEDUTA -- InpFlatFineSeduta, DEFAULT ACCESO.        |
//|    Aggiunto il 28/08/2026 su richiesta esplicita: il motore deve  |
//|    essere VERAMENTE intraday. All'ora di flat (ORA SERVER) chiude |
//|    tutte le posizioni di questo magic, cancella i pendenti e NON  |
//|    riapre fino al giorno dopo: nessuna posizione a cavallo della  |
//|    notte, nessuna a cavallo del fine settimana.                   |
//|    PERCHE' e' acceso di default, ed e' una scelta di CONTRATTO,   |
//|    non di taratura: FTMO Standard (leva 1:100) impone restrizioni |
//|    overnight / weekend / news SOLO sul conto finanziato. Un EA    |
//|    che apre e chiude dentro la seduta non incontra mai quel       |
//|    vincolo, e permette di restare a 1:100 invece di scendere a    |
//|    1:30 (Swing). E' anche COERENTE CON LA TESI: la VWAP di        |
//|    sessione si azzera ogni giorno, quindi una posizione tenuta    |
//|    oltre la seduta non ha piu' il livello che l'ha generata.      |
//|    >>> E' uno SCOSTAMENTO DAL PINE, dichiarato: l'autore non      |
//|        chiude a fine giornata. Chi vuole la cella AUTORE PURA     |
//|        mette InpFlatFineSeduta=false, e l'EA lo scrive nel log    |
//|        ("tiene posizioni OVERNIGHT"). Il costo della regola si    |
//|        MISURA con quella gamba, non si stima.                     |
//|    >>> LIMITE VERO, dichiarato: il flat vive dentro OnTick. Se il |
//|        simbolo smette di mandare tick prima dell'ora di flat, la  |
//|        chiusura slitta al primo tick utile. Su un CFD indice      |
//|        dentro l'orario di negoziazione i tick ci sono; ai bordi   |
//|        della seduta va verificato sul referto.                    |
//|                                                                   |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO       |
//|  rispetto all'ora italiana (DAX 09:00 IT = 08:00 server).         |
//|                                                                   |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le     |
//|  stringhe, niente emoji (regola di casa dei .ps1, estesa qui      |
//|  perche' i log finiscono negli stessi strumenti).                 |
//|  NON compilato ne' testato da chi ha scritto il file: compilare   |
//|  in MetaEditor e validare nel tester A TICK REALI.                |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - porting da sumbloke077 (TradingView YBqnzqDK)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a un EA non migrato.
//    Il default true NON cambia niente da solo: se il Guardian non gira su
//    questo conto -- e nel Strategy Tester, dove le sue GlobalVariable non
//    esistono -- la guardia lascia passare tutto (fail-open totale). I
//    backtest restano quindi confrontabili con quelli degli altri EA.
//    Non tocca MAI le posizioni gia' aperte, i parziali e le uscite:
//    blocca soltanto il PIAZZAMENTO di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//--- tetto di sicurezza al numero di barre che la VWAP di sessione
//    guarda indietro. Su M5 una seduta indice sta ampiamente sotto.
#define VR_MAX_SESSION_BARS 600

//--- Come si applica il PAVIMENTO dello stop.
//    AUTORE  = come il Pine: il pavimento entra SOLO nel calcolo di R
//              (quindi nel lotto e nel target), lo stop resta all'estremo
//              strutturale. Effetto: rischio REALIZZATO piu' piccolo di
//              quello dichiarato, e RR effettivo migliore di InpTpR.
//    ALLARGA = convenzione di casa: lo stop si SPOSTA fino al pavimento.
//              Rischio realizzato = rischio dichiarato, RR = InpTpR.
//    Default AUTORE, cosi' la cella nuda del round e' il Pine tradotto.
enum ENUM_VR_FLOOR { VR_FLOOR_AUTORE=0, VR_FLOOR_ALLARGA=1 };

//==================================================================
//  INPUT
//==================================================================
input group "=== MOTORE - BANDA VWAP (costitutiva: non si spegne) ==="
input double InpSigmaMult        = 1.0;   // Banda = VWAP +/- X sigma (autore: 1.0)
input int    InpSessionStartHour = -1;    // Ora SERVER di ancoraggio VWAP (-1 = cambio giorno, autore)
input int    InpMinSessionBars   = 0;     // Barre minime di sessione prima di fidarsi della banda (0 = autore)

input group "=== MOTORE - CANDELA DI RIFIUTO (costitutiva) ==="
input int    InpLookback         = 20;    // Estremo delle ultime X barre (autore: 20)
input double InpBodyPctMax       = 0.30;  // Corpo max in frazione del range, hammer/star (autore: 0.3)
input double InpWickMult         = 2.0;   // Ombra lunga >= X volte il corpo (autore: 2.0 su ENTRAMBI i lati)
input double InpDojiBodyPct      = 0.20;  // Corpo max in frazione del range, doji (autore: 0.2)
input double InpClosePct         = 0.30;  // Conferma: chiusura dentro il X del range dal lato buono (autore: 0.30)
input bool   InpEngulfingOnly    = false; // Solo engulfing come conferma (autore: false)
input int    InpAtrPeriod        = 10;    // Periodo ATR sul TF del grafico (autore "base": 10 -- vedi tesi 4.1)
input double InpAtrMult          = 1.5;   // Anti-candelone: range conferma <= X * ATR (autore: 1.5)
input bool   InpAllowLong        = true;  // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort       = true;  // Ammetti gli SHORT

input group "=== Ingresso, stop, target ==="
input double InpAtrBufferPct     = 0.01;  // Buffer ingresso/stop = X * ATR (autore: 0.01)
input double InpSlAtrFloor       = 0.20;  // Pavimento del rischio = X * ATR (autore: 0.2)
input ENUM_VR_FLOOR InpSlFloorMode = VR_FLOOR_AUTORE; // Come si applica il pavimento (vedi tesi 4.4)
input bool   InpSlUseSetupBar    = false; // SL sull'estremo PIU' PROTETTIVO fra setup e conferma (autore: false)
input double InpTpR              = 2.0;   // TP = X volte R (autore: 2.0). 0 = nessun TP
input int    InpOrderLifeBars    = 3;     // Barre di vita dell'ordine pendente (autore: 3 -- vedi tesi 4.5)
input bool   InpCloseOnOpposite  = true;  // Chiudi sul segnale opposto (autore: true)
input double InpSpreadExtraPts   = 0;     // Margine EXTRA sul livello d'ingresso, punti MT5 (0 = nessun doppio conteggio)

input group "=== Gestione della posizione (spenta = autore) ==="
input bool   InpUsePartial       = false; // Parziale al primo target (autore: nessun parziale)
input double InpPartialR         = 1.0;   // Primo target del parziale, in R
input double InpPartialPercent   = 50.0;  // % chiusa al primo target
input bool   InpBreakEven        = true;  // Stop in pari al primo target (inerte senza parziale)
input bool   InpUseTrailAtr      = false; // Trailing dello stop in ATR (opt-in)
input double InpTrailAtrMult     = 2.0;   // Trailing = X * ATR

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay  = 2;     // Max ingressi al giorno (C6: obbligatorio, 0 = illimitato)
input bool   InpUseHourFilter    = false; // Filtro orario sulla barra di conferma (ORA SERVER)
input int    InpHourStart        = 10;    // Ora SERVER di inizio (inclusa). Fascia bersaglio P1: 10-16
input int    InpHourEnd          = 16;    // Ora SERVER di fine (inclusa)
input bool   InpFridayClose      = false; // Venerdi': chiudi tutto oltre l'ora e non riaprire
input int    InpFridayCloseHour  = 20;    // Ora SERVER del venerdi' oltre cui chiudo

input group "=== FLAT DI FINE SEDUTA (motore VERAMENTE intraday) ==="
//--- ACCESO di default: e' la seconda regola di casa dopo il cap giornaliero.
//    Vedi il blocco in testa al file per il perche' (FTMO Standard, leva 1:100)
//    e per lo scostamento dichiarato dal Pine dell'autore.
input bool   InpFlatFineSeduta   = true;  // Chiudi TUTTO a fine seduta e non riaprire fino a domani
input int    InpFlatOra          = 20;    // Ora SERVER del flat (20 server = 21 italiana)
input int    InpFlatMinuto       = 45;    // Minuto SERVER del flat
//--- quanti minuti PRIMA del flat si smette di piazzare nuovi pendenti.
//    0 = SPENTO (default neutro): la gamba si misura, non si assume.
//    A che serve: un ordine riempito a 20:44 e chiuso d'ufficio a 20:45 e'
//    solo spread pagato. Ma "quanto costa" e' un numero, non un'opinione:
//    si accende in una gamba a parte e si confronta.
input int    InpStopNuoviMinPrimaFlat = 0; // Niente nuovi ordini negli ultimi X minuti prima del flat (0 = spento)

input group "=== Rischio ==="
input double InpRiskPercent      = 1.0;   // Rischio per trade, % del saldo (autore: 1.0 -- coincide)

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter    = false;
input string InpNewsFile         = "abtg_news.csv";
input int    InpNewsMinImpact    = 3;
input int    InpNewsBeforeMin    = 30;
input int    InpNewsAfterMin     = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies   = "";

input group "=== Generali ==="
input string InpComment     = "VWAPREV"; // Commento sugli ordini
input long   InpMagic       = 773400;    // Numero magico (blocco 7734xx: VERGINE, verificato nel repo il 25/08/2026)
input int    InpMaxSpread   = 0;         // Spread massimo in punti MT5 (0 = nessun limite)
input double InpMaxSpreadPctSL = 0;      // Spread massimo in % dello stop (0 = spento; standard di casa R55)
input bool   InpVerbose     = true;      // Messaggi nel log
input bool   InpAutoTest    = true;      // Stampa le righe [VWAPREV][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hAtr = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // per contare gli ingressi ESEGUITI, non quelli ordinati
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno, non una a tick

//--- CONTATORI CHE DEVONO USCIRE IN COLONNA, NON IN UN Print.
//    In OTTIMIZZAZIONE le Print girano sugli agent e NON LE LEGGE NESSUNO:
//    un autotest che stampa "DIVERGE" su un agent non ferma niente e non si
//    vede. Questi tre numeri finiscono nell'OPTFRAME (OnTester) e diventano
//    tre colonne del CSV, cosi' il driver puo' farci un GATE.
int      gAutotestFalliti = -1;   // -1 = autotest non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat di fine seduta e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse in totale dal flat di fine seduta

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[VWAPREV] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| Marcatore di SESSIONE di un istante.                              |
//| Due barre stanno nella stessa sessione se hanno lo stesso         |
//| marcatore. Con startHour = 0 e' il CAMBIO GIORNO del server, che  |
//| e' esattamente ta.change(time("D")) dell'autore.                  |
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t, const int startHour)
  {
   long s = (long)t - (long)startHour*3600;
   if(s < 0) s = 0;
   return(s/86400);
  }

//+------------------------------------------------------------------+
//| VWAP DI SESSIONE + SIGMA volume-pesata -- il cuore del motore.     |
//| px[] = tipico (hlc3) delle barre della sessione, vol[] = pesi.     |
//|                                                                    |
//| DUE PASSATE, non la formula E[x^2]-E[x]^2 dell'autore:             |
//|   il risultato e' MATEMATICAMENTE IDENTICO (stessa varianza di     |
//|   popolazione pesata) ma numericamente sano: su un indice a 24.000 |
//|   la formula a un passo sottrae due numeri dell'ordine di 5,8e8    |
//|   per ottenerne uno dell'ordine di 100. Non e' uno scostamento di  |
//|   comportamento, e' la stessa cosa scritta senza cancellazione.    |
//| Ritorna false se non c'e' peso: senza dati la banda non esiste.    |
//+------------------------------------------------------------------+
bool VwapBanda_Calc(const double &px[], const double &vol[], const int n,
                    double &vwap, double &sigma)
  {
   vwap=0; sigma=0;
   if(n < 1) return(false);
   if(ArraySize(px) < n || ArraySize(vol) < n) return(false);

   double pv=0, vv=0;
   for(int i=0;i<n;i++)
     {
      double w = vol[i];
      if(w <= 0) w = 1.0;          // barra senza tick: peso minimo, mai zero
      pv += px[i]*w;
      vv += w;
     }
   if(vv <= 0) return(false);
   vwap = pv/vv;

   double sw=0;
   for(int i=0;i<n;i++)
     {
      double w = vol[i];
      if(w <= 0) w = 1.0;
      double d = px[i]-vwap;
      sw += w*d*d;
     }
   sigma = MathSqrt(MathMax(sw/vv, 0.0));
   return(true);
  }

//+------------------------------------------------------------------+
//| FUORI BANDA -- la condizione COSTITUTIVA.                          |
//| L'autore confronta la CHIUSURA DELLA BARRA DI SETUP con la banda:  |
//|   priceBelowLower = close[1] < lowerBand                           |
//| sigma <= 0 = nessuna dispersione misurabile = NIENTE SEGNALE.      |
//| Confronto STRETTO come l'autore.                                   |
//+------------------------------------------------------------------+
bool FuoriBanda_Calc(const bool isLong, const double closeSetup,
                     const double vwap, const double sigma, const double mult)
  {
   if(sigma <= 0 || mult <= 0 || vwap <= 0) return(false);
   if(isLong) return(closeSetup < vwap - mult*sigma);
   return(closeSetup > vwap + mult*sigma);
  }

//+------------------------------------------------------------------+
//| HAMMER (autore): corpo piccolo, ombra INFERIORE lunga, ombra       |
//| superiore non piu' lunga del corpo.                                |
//+------------------------------------------------------------------+
bool Hammer_Calc(const double o,const double h,const double l,const double c,
                 const double bodyPct,const double wickMult)
  {
   double range = h-l;
   if(range <= 0) return(false);
   double body  = MathAbs(c-o);
   double upper = h - MathMax(o,c);
   double lower = MathMin(o,c) - l;
   if(body  > range*bodyPct)  return(false);
   if(lower < body*wickMult)  return(false);
   if(upper > body)           return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| SHOOTING STAR (autore): specchio esatto dell'hammer.               |
//+------------------------------------------------------------------+
bool ShootingStar_Calc(const double o,const double h,const double l,const double c,
                       const double bodyPct,const double wickMult)
  {
   double range = h-l;
   if(range <= 0) return(false);
   double body  = MathAbs(c-o);
   double upper = h - MathMax(o,c);
   double lower = MathMin(o,c) - l;
   if(body  > range*bodyPct)  return(false);
   if(upper < body*wickMult)  return(false);
   if(lower > body)           return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| DOJI (autore): corpo sotto una frazione del range.                 |
//+------------------------------------------------------------------+
bool Doji_Calc(const double o,const double h,const double l,const double c,
               const double dojiPct)
  {
   double range = h-l;
   if(range <= 0) return(false);
   return(MathAbs(c-o) <= range*dojiPct);
  }

//+------------------------------------------------------------------+
//| Posizione della chiusura dentro il range: 0 = sul minimo,          |
//| 1 = sul massimo. Range nullo -> -1 (invalido).                     |
//+------------------------------------------------------------------+
double ClosePos_Calc(const double h,const double l,const double c)
  {
   double range = h-l;
   if(range <= 0) return(-1.0);
   return((c-l)/range);
  }

//+------------------------------------------------------------------+
//| Chiusura della barra di CONFERMA dal lato favorevole.              |
//|   long : closePos >= 1 - pct   (autore: >= 0,70)                   |
//|   short: closePos <= pct       (autore: <= 0,30)                   |
//+------------------------------------------------------------------+
bool ChiusuraForte_Calc(const bool isLong,const double h,const double l,
                        const double c,const double pct)
  {
   double pos = ClosePos_Calc(h,l,c);
   if(pos < 0) return(false);
   if(isLong) return(pos >= 1.0-pct);
   return(pos <= pct);
  }

//+------------------------------------------------------------------+
//| ENGULFING della barra di CONFERMA sulla barra di SETUP.            |
//|   bull: cC>oC and cS<oS and oC<=cS and cC>=oS                      |
//|   bear: cC<oC and cS>oS and oC>=cS and cC<=oS                      |
//+------------------------------------------------------------------+
bool Engulfing_Calc(const bool isLong,
                    const double oS,const double cS,
                    const double oC,const double cC)
  {
   if(isLong)  return(cC>oC && cS<oS && oC<=cS && cC>=oS);
   return(cC<oC && cS>oS && oC>=cS && cC<=oS);
  }

//+------------------------------------------------------------------+
//| CONTINUAZIONE (l'altra conferma ammessa dall'autore).              |
//|   long : low  > low[1]  and close > high[1]                        |
//|   short: high < high[1] and close < low[1]                         |
//+------------------------------------------------------------------+
bool Continuazione_Calc(const bool isLong,
                        const double hS,const double lS,
                        const double hC,const double lC,const double cC)
  {
   if(isLong)  return(lC > lS && cC > hS);
   return(hC < hS && cC < lS);
  }

//+------------------------------------------------------------------+
//| ANTI-CANDELONE: il range della barra di CONFERMA non deve          |
//| superare mult x ATR. atr <= 0 = dato non utilizzabile -> NON       |
//| passa: e' una condizione del motore, non un filtro di contorno.    |
//+------------------------------------------------------------------+
bool AntiCandelone_Calc(const double h,const double l,
                        const double atr,const double mult)
  {
   if(atr <= 0 || mult <= 0) return(false);
   double range = h-l;
   if(range <= 0) return(false);
   return(range <= atr*mult);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE COMPLETO DI UN LATO.                                    |
//| Ordine voluto: prima la BANDA (la condizione costitutiva e la piu' |
//| selettiva), poi l'estremo, poi la geometria della candela, poi la  |
//| barra di conferma. Tutte necessarie insieme: non c'e' nessun modo  |
//| "3 su 4".                                                          |
//|   estremoLookback = massimo/minimo delle InpLookback barre che      |
//|                     FINISCONO sulla barra di setup (setup inclusa)  |
//+------------------------------------------------------------------+
bool SegnaleLato_Calc(const bool isLong,
                      const double oS,const double hS,const double lS,const double cS,
                      const double oC,const double hC,const double lC,const double cC,
                      const double estremoLookback,
                      const double vwap,const double sigma,const double sigmaMult,
                      const double atr,const double atrMult,
                      const double bodyPct,const double wickMult,const double dojiPct,
                      const double closePct,const bool engulfingOnly)
  {
   //--- (c) FUORI BANDA -- COSTITUTIVA
   if(!FuoriBanda_Calc(isLong,cS,vwap,sigma,sigmaMult)) return(false);

   //--- (b) l'estremo delle ultime N barre -- COSTITUTIVO
   if(isLong)  { if(!(lS <= estremoLookback)) return(false); }
   else        { if(!(hS >= estremoLookback)) return(false); }

   //--- (a) la candela di RIFIUTO sulla barra di setup -- COSTITUTIVA
   bool rifiuto = isLong ? Hammer_Calc(oS,hS,lS,cS,bodyPct,wickMult)
                         : ShootingStar_Calc(oS,hS,lS,cS,bodyPct,wickMult);
   if(!rifiuto) rifiuto = Doji_Calc(oS,hS,lS,cS,dojiPct);
   if(!rifiuto) return(false);

   //--- (d) la barra di CONFERMA
   if(!AntiCandelone_Calc(hC,lC,atr,atrMult))          return(false);
   if(!ChiusuraForte_Calc(isLong,hC,lC,cC,closePct))   return(false);

   bool eng = Engulfing_Calc(isLong,oS,cS,oC,cC);
   if(engulfingOnly) return(eng);
   return(eng || Continuazione_Calc(isLong,hS,lS,hC,lC,cC));
  }

//+------------------------------------------------------------------+
//| R (la distanza di rischio usata per LOTTO e TARGET), col           |
//| pavimento dell'autore: R = max(entry-sl, atr*floorMult).           |
//| NOTA: nel modo AUTORE questo NON sposta lo stop. E' il Pine:       |
//|   longRisk = math.max(longEntry - longStopStored, atr*stopATR)     |
//|   strategy.exit(stop = longStopStored ...)   <- stop invariato     |
//| Conseguenza: se lo stop strutturale e' piu' stretto del pavimento, |
//| il lotto e' piu' piccolo e la perdita realizzata e' MINORE del     |
//| rischio dichiarato. Direzione conservativa, ma va saputa.          |
//+------------------------------------------------------------------+
double RischioConPavimento_Calc(const bool isLong,const double entry,const double sl,
                                const double atr,const double floorMult)
  {
   double raw = isLong ? (entry-sl) : (sl-entry);
   if(raw <= 0) return(0);
   if(atr <= 0 || floorMult <= 0) return(raw);
   return(MathMax(raw, atr*floorMult));
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop, modo ALLARGA (convenzione di casa).          |
//| Se lo stop strutturale e' piu' vicino del pavimento, lo stop si    |
//| ALLARGA al pavimento (semantica di "minimo"), non si salta il      |
//| trade. pavimento <= 0 = spento.                                    |
//| Serve perche' uno stop strutturale puo' nascere a due punti dal    |
//| prezzo: li' il lotto per rischio esplode e lo slippage si mangia   |
//| l'operazione intera (R55).                                         |
//+------------------------------------------------------------------+
double PavimentoSL_Calc(const bool isLong, const double entry,
                        const double slGrezzo, const double pavimento)
  {
   if(pavimento <= 0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R >= pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Filtro orario -- nucleo. Estremi INCLUSI. Gestisce anche la        |
//| fascia a cavallo della mezzanotte (start>end).                     |
//+------------------------------------------------------------------+
bool OraAmmessa_Calc(const int ora, const int start, const int end)
  {
   if(start<=end) return(ora>=start && ora<=end);
   return(ora>=start || ora<=end);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA -- nucleo puro.                                |
//| Vero quando l'ora corrente ha raggiunto o superato l'ora di flat.  |
//| Il confronto si fa in MINUTI DEL GIORNO, non ora per ora: con      |
//| 20:45 un confronto sulla sola ora chiuderebbe alle 20:00 o alle    |
//| 21:00, mai alle 20:45.                                             |
//| La finestra di flat va dall'ora di flat alla MEZZANOTTE: e' voluto |
//| ed e' cio' che rende il motore intraday davvero intraday. Non      |
//| esiste nessun caso "a cavallo della mezzanotte", perche' oltre la  |
//| mezzanotte c'e' un altro giorno e un'altra VWAP di sessione.       |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60 + minuto >= flatOra*60 + flatMinuto);
  }

//+------------------------------------------------------------------+
//| Coda della seduta: siamo negli ultimi 'anticipoMin' minuti prima   |
//| del flat? Con anticipoMin <= 0 la guardia e' SPENTA e la funzione  |
//| e' sempre falsa (default neutro dichiarato).                       |
//+------------------------------------------------------------------+
bool CodaSeduta_Calc(const int ora,const int minuto,
                     const int flatOra,const int flatMinuto,
                     const int anticipoMin)
  {
   if(anticipoMin <= 0) return(false);
   return(ora*60 + minuto >= flatOra*60 + flatMinuto - anticipoMin);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpSigmaMult <= 0)
     { Print("ERRORE: InpSigmaMult deve essere > 0: senza banda non e' questo motore."); return(INIT_FAILED); }
   if(InpLookback < 2)
     { Print("ERRORE: InpLookback deve essere >= 2: senza estremo non e' questo motore."); return(INIT_FAILED); }
   if(InpSessionStartHour < -1 || InpSessionStartHour > 23)
     { Print("ERRORE: InpSessionStartHour deve stare fra -1 (cambio giorno) e 23."); return(INIT_FAILED); }
   if(InpMinSessionBars < 0)
     { Print("ERRORE: InpMinSessionBars non puo' essere negativo."); return(INIT_FAILED); }
   if(InpBodyPctMax <= 0 || InpBodyPctMax >= 1)
     { Print("ERRORE: InpBodyPctMax deve stare fra 0 e 1 (esclusi)."); return(INIT_FAILED); }
   if(InpDojiBodyPct <= 0 || InpDojiBodyPct >= 1)
     { Print("ERRORE: InpDojiBodyPct deve stare fra 0 e 1 (esclusi)."); return(INIT_FAILED); }
   if(InpWickMult <= 0)
     { Print("ERRORE: InpWickMult deve essere > 0."); return(INIT_FAILED); }
   if(InpClosePct <= 0 || InpClosePct >= 0.5)
     { Print("ERRORE: InpClosePct deve stare fra 0 e 0.5 (esclusi): oltre 0,5 long e short si sovrappongono."); return(INIT_FAILED); }
   if(InpAtrPeriod < 1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpAtrMult <= 0)
     { Print("ERRORE: InpAtrMult deve essere > 0."); return(INIT_FAILED); }
   if(InpAtrBufferPct < 0)
     { Print("ERRORE: InpAtrBufferPct non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSlAtrFloor < 0)
     { Print("ERRORE: InpSlAtrFloor non puo' essere negativo."); return(INIT_FAILED); }
   if(InpTpR < 0)
     { Print("ERRORE: InpTpR non puo' essere negativo (0 = nessun TP)."); return(INIT_FAILED); }
   if(InpOrderLifeBars < 1)
     { Print("ERRORE: InpOrderLifeBars deve essere >= 1."); return(INIT_FAILED); }
   if(InpUsePartial && (InpPartialPercent <= 0 || InpPartialPercent >= 100))
     { Print("ERRORE: InpPartialPercent deve stare fra 1 e 99 quando il parziale e' acceso."); return(INIT_FAILED); }
   if(InpUsePartial && InpPartialR <= 0)
     { Print("ERRORE: InpPartialR deve essere > 0 quando il parziale e' acceso."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpRiskPercent <= 0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxSpreadPctSL < 0)
     { Print("ERRORE: InpMaxSpreadPctSL non puo' essere negativo."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }
   if(InpFlatOra<0 || InpFlatOra>23 || InpFlatMinuto<0 || InpFlatMinuto>59)
     { Print("ERRORE: InpFlatOra deve stare fra 0 e 23 e InpFlatMinuto fra 0 e 59 (ORA SERVER)."); return(INIT_FAILED); }
   if(InpStopNuoviMinPrimaFlat < 0)
     { Print("ERRORE: InpStopNuoviMinPrimaFlat non puo' essere negativo (0 = spento)."); return(INIT_FAILED); }
   //--- una coda piu' lunga dell'intera giornata spegnerebbe l'EA in silenzio.
   if(InpFlatFineSeduta && InpStopNuoviMinPrimaFlat >= InpFlatOra*60+InpFlatMinuto)
     { Print("ERRORE: InpStopNuoviMinPrimaFlat copre tutta la giornata: nessun ingresso sarebbe mai possibile."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione: se qualcosa e' acceso, la cella
   //    NON e' la cella "autore". Non lo spegne l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova lo pinna.
   if(InpSlFloorMode!=VR_FLOOR_AUTORE || InpSlUseSetupBar || InpUsePartial ||
      InpUseTrailAtr || InpMinSessionBars>0 || InpSessionStartHour>=0 ||
      InpSpreadExtraPts>0 || InpEngulfingOnly || InpUseHourFilter ||
      InpUseNewsFilter || InpFridayClose || InpMaxSpreadPctSL>0 ||
      InpStopNuoviMinPrimaFlat>0)
      Log("ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' la cella AUTORE del porting.");

   //--- Il FLAT si dichiara nei DUE versi, perche' il default e' ACCESO e
   //    l'acceso e' gia' uno scostamento dall'autore. Chi legge il log
   //    deve sapere sempre in quale delle due macchine si trova.
   if(InpFlatFineSeduta)
      Log(StringFormat("FLAT DI FINE SEDUTA ACCESO alle %02d:%02d ORA SERVER: motore INTRADAY, niente overnight ne' weekend. Scostamento dichiarato dal Pine (l'autore non chiude).",
                       InpFlatOra, InpFlatMinuto));
   else
      Log("ATTENZIONE: flat di fine seduta SPENTO: questa cella TIENE POSIZIONI OVERNIGHT ed e' incompatibile con un conto FTMO Standard finanziato. E' la gamba di confronto, non la cella da mandare in campo.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestVwapRevert();

   Log(StringFormat("avviato su %s %s. banda VWAP +/- %.2f sigma [TICK VOLUME], estremo %d barre, ATR(%d) x %.2f, TP %.2f R, ordine vivo %d barre, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpSigmaMult, InpLookback, InpAtrPeriod, InpAtrMult,
       InpTpR, InpOrderLifeBars, InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- Sta QUI e non dopo il filtro della nuova barra: su M15 la caduta
   //    peggiore di giornata succede in mezzo a una candela.
   //    E sta PRIMA delle chiusure d'ufficio: se il flat porta via la
   //    posizione, la caduta di quella giornata dev'essere gia' contata.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

   if(FridayCloseCheck())   return;    // venerdi' oltre l'ora: chiudo e non riapro
   if(FlatFineSedutaCheck())return;    // fine seduta: chiudo tutto e non riapro

   ManageAll();                        // parziale / pari / trailing: a ogni tick

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova.                                       |
//|                                                                    |
//| Il FRONTE del segnale (longSignalOnce dell'autore) e' ricalcolato  |
//| SENZA STATO: si valuta il segnale sulla barra di conferma [1] e    |
//| lo si rivaluta sulla [2]; e' un fronte solo se ora e' vero e prima |
//| era falso. Cosi' un riavvio dell'EA non cambia la storia.          |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   CancellaOrdiniScaduti();

   double v1=0,s1=0,v2=0,s2=0;
   int    n1=0,n2=0;
   bool   b1 = CalcVwapBanda(1,v1,s1,n1);
   bool   b2 = CalcVwapBanda(2,v2,s2,n2);

   bool okBanda1 = b1 && n1>=InpMinSessionBars;
   bool okBanda2 = b2 && n2>=InpMinSessionBars;

   bool bullOra   = okBanda1 && ValutaSegnale(true , 1, v1, s1);
   bool bullPrima = okBanda2 && ValutaSegnale(true , 2, v2, s2);
   bool bearOra   = okBanda1 && ValutaSegnale(false, 1, v1, s1);
   bool bearPrima = okBanda2 && ValutaSegnale(false, 2, v2, s2);

   bool bullFronte = bullOra && !bullPrima;
   bool bearFronte = bearOra && !bearPrima;

   //--- uscita sul segnale opposto (autore: enableCloseOpposite).
   //    Sta PRIMA dei cancelli operativi: chiudere rischio non e'
   //    aprire rischio, e l'autore la fa comunque.
   //    NOTA: il fronte opposto vale anche se quel lato e' spento in
   //    ingresso (InpAllowLong/Short filtrano l'INGRESSO, non l'uscita).
   if(InpCloseOnOpposite) ChiudiSuOpposto(bullFronte,bearFronte);

   if(CountPositions()>0) return;                       // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!CodaSedutaOK()) return;                          // troppo vicino al flat (0 = spento)
   if(!OraOK())    return;
   if(!SpreadOK()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;

   if(InpAllowLong && bullFronte)
     { PiazzaOrdine(true, s1); return; }                // una sola decisione per barra
   if(InpAllowShort && bearFronte)
      PiazzaOrdine(false, s1);
  }

//==================================================================
//  LETTURA DEI DATI (il pensiero sta nel nucleo puro)
//==================================================================

//--- ora di ancoraggio effettiva: -1 (autore) = cambio giorno = 0
int OraAncoraggio(){ return(InpSessionStartHour < 0 ? 0 : InpSessionStartHour); }

//+------------------------------------------------------------------+
//| VWAP + SIGMA della sessione che CONTIENE la barra shiftFine,       |
//| accumulate dall'inizio di quella sessione FINO a shiftFine         |
//| compresa. La barra 0 (in formazione) non entra mai, perche'        |
//| shiftFine e' sempre >= 1: e' la stessa scelta di VwapBias() in     |
//| ABTG_DAX_Apertura_EU, che parte da i=1.                            |
//| nBarre = quante barre di sessione sono entrate nel conto.          |
//+------------------------------------------------------------------+
bool CalcVwapBanda(const int shiftFine, double &vwap, double &sigma, int &nBarre)
  {
   vwap=0; sigma=0; nBarre=0;
   if(shiftFine < 1) return(false);

   MqlRates r[]; ArraySetAsSeries(r,true);
   int need   = shiftFine + VR_MAX_SESSION_BARS + 1;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied <= shiftFine) return(false);

   int  ora   = OraAncoraggio();
   long stamp = SessionStamp_Calc(r[shiftFine].time, ora);

   double px[], vol[];
   ArrayResize(px, VR_MAX_SESSION_BARS);
   ArrayResize(vol,VR_MAX_SESSION_BARS);

   int n=0;
   for(int i=shiftFine; i<copied && n<VR_MAX_SESSION_BARS; i++)
     {
      if(SessionStamp_Calc(r[i].time, ora) != stamp) break;
      px[n]  = (r[i].high + r[i].low + r[i].close)/3.0;   // hlc3, come l'autore
      vol[n] = (double)r[i].tick_volume;                   // TICK VOLUME: scostamento dichiarato
      n++;
     }
   if(n < 1) return(false);
   nBarre = n;
   return(VwapBanda_Calc(px,vol,n,vwap,sigma));
  }

//+------------------------------------------------------------------+
//| Valuta il segnale con la barra di CONFERMA a shiftConferma e la    |
//| barra di SETUP a shiftConferma+1. Tutti i dati sono di barre       |
//| CHIUSE (shiftConferma >= 1).                                       |
//+------------------------------------------------------------------+
bool ValutaSegnale(const bool isLong, const int shiftConferma,
                   const double vwap, const double sigma)
  {
   int sC = shiftConferma;
   int sS = shiftConferma+1;
   if(sC < 1) return(false);
   if(Bars(_Symbol,gTF) < sS + InpLookback + 2) return(false);

   double oC=iOpen(_Symbol,gTF,sC), hC=iHigh(_Symbol,gTF,sC);
   double lC=iLow (_Symbol,gTF,sC), cC=iClose(_Symbol,gTF,sC);
   double oS=iOpen(_Symbol,gTF,sS), hS=iHigh(_Symbol,gTF,sS);
   double lS=iLow (_Symbol,gTF,sS), cS=iClose(_Symbol,gTF,sS);
   if(oC<=0||hC<=0||lC<=0||cC<=0||oS<=0||hS<=0||lS<=0||cS<=0) return(false);

   //--- estremo delle InpLookback barre che FINISCONO sulla barra di
   //    setup (setup compresa): e' ta.highest/lowest(..., 20) valutato
   //    sulla barra di setup dell'autore.
   double estremo = 0;
   if(isLong)
     {
      int idx = iLowest(_Symbol,gTF,MODE_LOW,InpLookback,sS);
      if(idx < 0) return(false);
      estremo = iLow(_Symbol,gTF,idx);
     }
   else
     {
      int idx = iHighest(_Symbol,gTF,MODE_HIGH,InpLookback,sS);
      if(idx < 0) return(false);
      estremo = iHigh(_Symbol,gTF,idx);
     }
   if(estremo <= 0) return(false);

   double atr = AtrVal(sC);
   if(atr <= 0) return(false);                 // senza ATR non c'e' anti-candelone

   return(SegnaleLato_Calc(isLong,
                           oS,hS,lS,cS,
                           oC,hC,lC,cC,
                           estremo,
                           vwap,sigma,InpSigmaMult,
                           atr,InpAtrMult,
                           InpBodyPctMax,InpWickMult,InpDojiBodyPct,
                           InpClosePct,InpEngulfingOnly));
  }

//--- Orario della BARRA DI CONFERMA, in ORA SERVER (mai l'ora italiana:
//    regola di casa, il server BCM e' un'ora indietro).
bool OraOK()
  {
   if(!InpUseHourFilter) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   return(OraAmmessa_Calc(t.hour, InpHourStart, InpHourEnd));
  }

double AtrVal(const int shift)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,shift,1,a)!=1) return(0);
   return(a[0]);
  }

//==================================================================
//  INGRESSO -- ordine STOP oltre l'estremo della barra di conferma
//==================================================================
//+------------------------------------------------------------------+
//| Piazza l'ordine pendente, come il ramo "Stop" dell'autore.        |
//|                                                                    |
//| PERCHE' SOLO IL RAMO "Stop": il ramo "Close of Confirmation" del   |
//| Pine usa strategy.entry(..., limit=...) su un livello              |
//| PEGGIORATIVO. In Pine un limit oltre il prezzo riempie subito; in  |
//| MT5 un BUY LIMIT sopra il mercato non riempie MAI. E' una trappola |
//| di traduzione, non un difetto dell'autore: si porta il ramo che in |
//| MT5 significa qualcosa.                                            |
//|                                                                    |
//| Ritorna true SOLO se l'ordine e' partito davvero.                  |
//+------------------------------------------------------------------+
bool PiazzaOrdine(const bool isLong, const double sigma)
  {
   double atr = AtrVal(1);
   if(atr <= 0){ Log("ATR non disponibile: salto."); return(false); }

   double hC = iHigh(_Symbol,gTF,1), lC = iLow(_Symbol,gTF,1);
   double hS = iHigh(_Symbol,gTF,2), lS = iLow(_Symbol,gTF,2);
   if(hC<=0||lC<=0||hS<=0||lS<=0) return(false);

   double buffer = atr*InpAtrBufferPct;
   double extra  = InpSpreadExtraPts*_Point;

   //--- INGRESSO e STOP nascono dalla barra di CONFERMA, come l'autore:
   //      longEntry := high + atrBuffer ; longStopStored := low - atrBuffer
   //    (il Pine li assegna nella barra in cui scatta longSignalOnce, che
   //     e' la barra di CONFERMA, non quella di setup).
   double entry = isLong ? (hC + buffer + extra) : (lC - buffer - extra);
   double slRaw = isLong ? (lC - buffer)         : (hC + buffer);

   //--- variante di casa (spenta): stop sull'estremo PIU' PROTETTIVO fra
   //    la barra di setup e quella di conferma.
   if(InpSlUseSetupBar)
      slRaw = isLong ? (MathMin(lC,lS) - buffer) : (MathMax(hC,hS) + buffer);

   //--- il pavimento: due semantiche, vedi ENUM_VR_FLOOR
   double sl = slRaw;
   double R  = 0;
   if(InpSlFloorMode==VR_FLOOR_ALLARGA)
     {
      sl = PavimentoSL_Calc(isLong, entry, slRaw, atr*InpSlAtrFloor);
      R  = isLong ? (entry-sl) : (sl-entry);
     }
   else
     {
      R  = RischioConPavimento_Calc(isLong, entry, slRaw, atr, InpSlAtrFloor);
     }
   if(R <= 0){ Log("geometria non valida (R <= 0): salto."); return(false); }

   sl = NormalizePrice(sl);
   entry = NormalizePrice(entry);

   //--- l'ordine STOP deve stare oltre il mercato di almeno lo stops level
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;

   double distMercato = isLong ? (entry-ask) : (bid-entry);
   if(distMercato <= minDist)
     { Log("livello d'ingresso gia' raggiunto o dentro lo stops level: salto."); return(false); }

   //--- lo stop deve stare dalla parte giusta del LIVELLO D'INGRESSO
   double distSL = isLong ? (entry-sl) : (sl-entry);
   if(distSL <= minDist)
     { Log("SL troppo vicino al livello d'ingresso (stops level): salto."); return(false); }

   //--- filtro spread in % dello stop (standard di casa, R55)
   if(InpMaxSpreadPctSL > 0)
     {
      double spreadPrezzo = ask-bid;
      if(spreadPrezzo > distSL*InpMaxSpreadPctSL/100.0)
        { Log("spread troppo largo rispetto allo stop: salto."); return(false); }
     }

   //--- TARGET a InpTpR volte R, misurato DAL LIVELLO D'INGRESSO
   double tp = 0;
   if(InpTpR > 0)
     {
      tp = NormalizePrice(isLong ? entry+R*InpTpR : entry-R*InpTpR);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp <= minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_VwapRevert")) return(false);

   //--- ordini pendenti vecchi di questo magic: via, uno alla volta.
   //    (In Pine strategy.entry con lo stesso id SOSTITUISCE l'ordine.)
   CancellaOrdini(0);

   bool ok = isLong ? gTrade.BuyStop (lot,entry,_Symbol,sl,tp,ORDER_TIME_GTC,0,cm)
                    : gTrade.SellStop(lot,entry,_Symbol,sl,tp,ORDER_TIME_GTC,0,cm);
   if(ok)
     {
      Log(StringFormat("%s STOP @ %s SL %s TP %s lot %.2f (R %s | sigma %s | ATR %s)",
          isLong?"BUY":"SELL",
          DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits),
          DoubleToString(sigma,_Digits), DoubleToString(atr,_Digits)));
      return(true);
     }
   Log("piazzamento fallito: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//+------------------------------------------------------------------+
//| SCADENZA DELL'ORDINE PENDENTE.                                     |
//| L'autore cancella quando bar_index - signalBar > 2, cioe' l'ordine |
//| resta vivo per TRE barre dopo il segnale (t+1, t+2, t+3). Qui      |
//| l'ordine nasce all'apertura di t+1: si cancella quando sono        |
//| passate InpOrderLifeBars barre dal piazzamento.                    |
//| Il conto si fa sul TIME_SETUP dell'ordine, non su una variabile:   |
//| cosi' sopravvive a un riavvio dell'EA.                             |
//| Uso ORDER_TIME_GTC + cancellazione a mano invece di                |
//| ORDER_TIME_SPECIFIED perche' non tutti i broker accettano la       |
//| scadenza sui pendenti, e un ordine che il broker rifiuta di far    |
//| scadere e' un ordine che resta vivo per sempre.                    |
//+------------------------------------------------------------------+
void CancellaOrdiniScaduti()
  {
   long per = PeriodSeconds(gTF);
   if(per <= 0) return;
   datetime t0 = iTime(_Symbol,gTF,0);
   if(t0 <= 0) return;

   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong tk = OrderGetTicket(i);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      datetime setup = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
      long trascorse = ((long)t0 - (long)setup)/per;
      if(trascorse >= InpOrderLifeBars)
        {
         gTrade.OrderDelete(tk);
         Log(StringFormat("ordine pendente scaduto dopo %d barre: cancellato.", (int)trascorse));
        }
     }
  }

//--- via i pendenti di questo magic su questo simbolo.
//    soloLato: 0 = tutti, +1 = solo i BUY STOP, -1 = solo i SELL STOP.
void CancellaOrdini(const int soloLato=0)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong tk = OrderGetTicket(i);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      if(soloLato!=0)
        {
         long tipo = OrderGetInteger(ORDER_TYPE);
         bool isBuy = (tipo==ORDER_TYPE_BUY_STOP || tipo==ORDER_TYPE_BUY_LIMIT || tipo==ORDER_TYPE_BUY_STOP_LIMIT);
         if(soloLato>0 && !isBuy) continue;
         if(soloLato<0 &&  isBuy) continue;
        }
      gTrade.OrderDelete(tk);
     }
  }

//+------------------------------------------------------------------+
//| Chiusura sul segnale OPPOSTO (autore: enableCloseOpposite).       |
//| Chiude anche l'eventuale pendente della direzione opposta: un     |
//| ordine che punta contro il segnale appena nato non ha piu' senso. |
//+------------------------------------------------------------------+
void ChiudiSuOpposto(const bool bullFronte, const bool bearFronte)
  {
   if(!bullFronte && !bearFronte) return;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      if((isLong && bearFronte) || (!isLong && bullFronte))
        {
         if(gTrade.PositionClose(tk))
            Log("segnale opposto: posizione chiusa.");
        }
     }
   //--- e via il pendente che punta CONTRO il segnale appena nato: un
   //    BUY STOP appeso mentre nasce un fronte ribassista non ha piu'
   //    la ragione per cui era stato messo. Il pendente dello STESSO
   //    lato NON si tocca qui: se ne occupa PiazzaOrdine, che lo
   //    sostituisce (in Pine strategy.entry con lo stesso id fa cosi').
   if(bearFronte) CancellaOrdini(+1);
   if(bullFronte) CancellaOrdini(-1);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE
//==================================================================
//+------------------------------------------------------------------+
//| Parziale al primo target + stop in pari, poi trailing in ATR.     |
//| Gira a OGNI tick: il target si tocca in mezzo alla barra.         |
//|                                                                   |
//| NOTA SUL DEFAULT: con InpUsePartial=false e InpUseTrailAtr=false  |
//| questo blocco NON fa niente. E' voluto: la cella "autore" del     |
//| round dev'essere SL e TP e basta, come il Pine.                   |
//|                                                                   |
//| NOTA SU R: qui R e' la distanza REALE fra apertura e stop, non il |
//| rischio col pavimento usato per il lotto. Nel modo AUTORE i due   |
//| numeri possono differire (vedi RischioConPavimento_Calc): il      |
//| parziale scatta quindi sull'R vero della posizione.               |
//+------------------------------------------------------------------+
void ManageAll()
  {
   if(!InpUsePartial && !InpUseTrailAtr) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;
   double atr = (InpUseTrailAtr ? AtrVal(1) : 0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      double vol    = PositionGetDouble(POSITION_VOLUME);
      if(sl<=0) continue;                       // senza stop non so quanto vale 1 R

      double R = isLong ? (openP-sl) : (sl-openP);
      bool   beFatto = isLong ? (sl>=openP) : (sl<=openP);

      //--- primo target: parziale + stop in pari
      if(!beFatto && InpUsePartial && R>0)
        {
         double tgt = isLong ? openP+R*InpPartialR : openP-R*InpPartialR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpPartialPercent/100.0);
            //  LEZIONE PTE (04/08/2026): lo STOP IN PARI non deve dipendere
            //  dalla riuscita del parziale. Al lotto minimo NormVol() arrotonda
            //  a 0, il parziale non parte, e prima di quella lezione con lui
            //  saltava anche il breakeven: posizioni a +1,28R tornate in perdita
            //  con lo stop ancora all'originale.
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakEven)
              {
               gTrade.PositionModify(tk,NormalizePrice(openP),tp);
               beFatto = true;
              }
            Log(parz ? "primo target: parziale eseguito."
                     : "primo target: parziale impossibile al lotto minimo.");
           }
        }

      //--- trailing in ATR: lo stop si muove SOLO a favore, mai indietro
      if(InpUseTrailAtr && atr>0)
        {
         double slOra = PositionGetDouble(POSITION_SL);
         double tpOra = PositionGetDouble(POSITION_TP);
         if(isLong)
           {
            double n = NormalizePrice(bid-atr*InpTrailAtrMult);
            if(n>slOra && n<bid) gTrade.PositionModify(tk,n,tpOra);
           }
         else
           {
            double n = NormalizePrice(ask+atr*InpTrailAtrMult);
            if((slOra<=0 || n<slOra) && n>ask) gTrade.PositionModify(tk,n,tpOra);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Venerdi' oltre l'ora: chiudo tutto e non riapro.                  |
//| L'ora e' quella del SERVER (TimeCurrent), mai quella del PC.      |
//+------------------------------------------------------------------+
bool FridayCloseCheck()
  {
   if(!InpFridayClose) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(t.day_of_week!=5 || t.hour<InpFridayCloseHour) return(false);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         gTrade.PositionClose(p);
     }
   CancellaOrdini(0);
   return(true);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA -- il motore e' intraday per COSTRUZIONE.      |
//|                                                                    |
//| Raggiunta l'ora di flat (ORA SERVER, mai quella del PC): chiude    |
//| ogni posizione di questo magic su questo simbolo, cancella ogni    |
//| pendente, e torna true -- e il true ferma OnTick, quindi NON si    |
//| riapre fino al giorno dopo. Nessuna posizione a cavallo della      |
//| notte, nessuna a cavallo del fine settimana.                       |
//|                                                                    |
//| Perche' i pendenti si cancellano insieme alle posizioni: un        |
//| BUY STOP lasciato vivo oltre il flat riempirebbe di notte o        |
//| lunedi' in gap, cioe' esattamente cio' che questa regola esiste    |
//| per impedire.                                                      |
//|                                                                    |
//| Il log si scrive UNA VOLTA per giornata (gFlatLogGiorno): senza,   |
//| a ogni tick della coda di seduta uscirebbe una riga.               |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   if(!InpFlatFineSeduta) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpFlatOra,InpFlatMinuto)) return(false);

   int chiuse=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(p)) chiuse++;
      else Log("flat di fine seduta: chiusura FALLITA -- "+gTrade.ResultRetcodeDescription());
     }
   CancellaOrdini(0);
   gFlatChiusure += chiuse;

   if(t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      gFlatGiorni++;
      Log(StringFormat("flat di fine seduta alle %02d:%02d server: %d posizioni chiuse, pendenti cancellati, niente overnight.",
                       InpFlatOra, InpFlatMinuto, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Guardia sui NUOVI ordini nella coda della seduta.                  |
//| true = si puo' ancora aprire. Con InpStopNuoviMinPrimaFlat = 0     |
//| (default) e' sempre true: non cambia niente rispetto a prima.      |
//+------------------------------------------------------------------+
bool CodaSedutaOK()
  {
   if(!InpFlatFineSeduta) return(true);
   if(InpStopNuoviMinPrimaFlat <= 0) return(true);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(CodaSeduta_Calc(t.hour,t.min,InpFlatOra,InpFlatMinuto,InpStopNuoviMinPrimaFlat))
     { Log("coda di seduta: niente nuovi ordini, il flat e' troppo vicino."); return(false); }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il cap giornaliero conta gli ingressi ESEGUITI, non quelli         |
//| ordinati: con un ordine pendente che puo' scadere senza riempire,  |
//| contare i piazzamenti significherebbe bruciare il cap con ordini   |
//| mai diventati rischio.                                             |
//| Un parziale non cambia il ticket, quindi non conta due volte.      |
//+------------------------------------------------------------------+
void AggiornaContatoreTrade()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(tk!=gUltimoTicketContato)
        { gUltimoTicketContato=tk; gTradesToday++; }
      return;
     }
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;              // conto a zero: niente da dividere
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   double giornata = 100.0*(gDayMinEquity-gDayStartEquity)/gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int    dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Lotto dalla distanza dello stop, come negli altri EA ABTG.
//    PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026):
//    su 225JPY il tick value arriva non convertito in valuta conto e il
//    lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit converte
//    correttamente; il tick value resta come ripiego. Sui simboli sani i
//    due calcoli coincidono: cambia SOLO dove il tick value mente.
//    Su un INDICE (D30EUR, U30USD, NASUSD) questa e' la strada giusta:
//    la distanza e' in PREZZO, non in pip, e non c'e' nessuna ipotesi
//    forex nascosta nel calcolo.
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot = -profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);

   double lot = risk/lossPerLot;
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot = MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//==================================================================
void AutoTestVwapRevert()
  {
   int falliti=0;

   PrintFormat("[VWAPREV][AUTOTEST] banda %.2f sigma | lookback %d | ATR(%d)x%.2f | TP %.2fR | vita ordine %d barre | floor=%s | %s | magic %I64d",
               InpSigmaMult, InpLookback, InpAtrPeriod, InpAtrMult, InpTpR, InpOrderLifeBars,
               (InpSlFloorMode==VR_FLOOR_AUTORE?"AUTORE":"ALLARGA"),
               _Symbol, InpMagic);

   //--- 1. LA VWAP E LA SIGMA (numeri scelti per essere verificabili a mano)
   double px2[2]; px2[0]=10.0; px2[1]=20.0;
   double vl2[2]; vl2[0]= 1.0; vl2[1]= 1.0;
   double w1=0,g1=0;
   bool   r1 = VwapBanda_Calc(px2,vl2,2,w1,g1);          // vwap 15, sigma 5
   double px3[2]; px3[0]=10.0; px3[1]=20.0;
   double vl3[2]; vl3[0]= 1.0; vl3[1]= 3.0;
   double w2=0,g2=0;
   bool   r2 = VwapBanda_Calc(px3,vl3,2,w2,g2);          // vwap 17.5, sigma 4.3301
   double px1[1]; px1[0]=42.0;
   double vl1[1]; vl1[0]= 7.0;
   double w3=0,g3=0;
   bool   r3 = VwapBanda_Calc(px1,vl1,1,w3,g3);          // una sola barra: vwap 42, sigma 0
   double w4=0,g4=0;
   bool   r4 = VwapBanda_Calc(px2,vl2,0,w4,g4);          // nessuna barra -> false
   PrintFormat("[VWAPREV][AUTOTEST] vwap: %.4f/%.4f (attesi 15.0000/5.0000) | pesata %.4f/%.4f (attesi 17.5000/4.3301) | una barra %.4f/%.4f (attesi 42.0000/0.0000) | n=0 ok=%d (atteso 0)",
               w1,g1,w2,g2,w3,g3,(int)r4);
   if(!r1 || !r2 || !r3 || r4) falliti++;
   if(MathAbs(w1-15.0)>0.0001 || MathAbs(g1-5.0)>0.0001 ||
      MathAbs(w2-17.5)>0.0001 || MathAbs(g2-4.3301)>0.001 ||
      MathAbs(w3-42.0)>0.0001 || MathAbs(g3-0.0)>0.0001) falliti++;

   //--- 2. FUORI BANDA (vwap 100, sigma 5, mult 1 -> banda 95 / 105)
   bool b1 = FuoriBanda_Calc(true , 94.0,100.0,5.0,1.0);   // sotto la banda -> long
   bool b2 = FuoriBanda_Calc(true , 96.0,100.0,5.0,1.0);   // dentro -> no
   bool b3 = FuoriBanda_Calc(true , 95.0,100.0,5.0,1.0);   // sul bordo -> no (stretto, come l'autore)
   bool b4 = FuoriBanda_Calc(false,106.0,100.0,5.0,1.0);   // sopra la banda -> short
   bool b5 = FuoriBanda_Calc(true , 94.0,100.0,0.0,1.0);   // sigma 0 -> NIENTE: la banda E' il motore
   bool b6 = FuoriBanda_Calc(true , 90.0,100.0,5.0,2.0);   // mult 2 -> banda 90: sul bordo, no
   PrintFormat("[VWAPREV][AUTOTEST] banda: sotto=%d (atteso 1) | dentro=%d (atteso 0) | bordo=%d (atteso 0) | short=%d (atteso 1) | sigma 0=%d (atteso 0, e' COSTITUTIVA) | 2 sigma bordo=%d (atteso 0)",
               (int)b1,(int)b2,(int)b3,(int)b4,(int)b5,(int)b6);
   if(!(b1 && !b2 && !b3 && b4 && !b5 && !b6)) falliti++;

   //--- 3. LE CANDELE DI RIFIUTO
   bool c1 = Hammer_Calc(100.0,101.0, 90.0,100.5, 0.30,2.0);  // corpo 0.5, ombra bassa 10 -> hammer
   bool c2 = Hammer_Calc(100.0,101.0, 90.0, 91.0, 0.30,2.0);  // corpo 9 su range 11 -> no
   bool c3 = Hammer_Calc(100.0,110.0, 99.5,100.5, 0.30,2.0);  // ombra ALTA lunga -> non e' hammer
   bool c4 = ShootingStar_Calc(100.0,110.0,99.5,100.5, 0.30,2.0); // ... e' una shooting star
   bool c5 = ShootingStar_Calc(100.0,101.0,90.0,100.5, 0.30,2.0); // l'hammer non e' una star
   bool c6 = Doji_Calc(100.0,101.0,99.0,100.1, 0.20);         // corpo 0.1 su range 2 -> doji
   bool c7 = Doji_Calc(100.0,101.2,99.8,101.0, 0.20);         // corpo 1.0 su range 1.4 -> no
   bool c8 = Hammer_Calc(100.0,100.0,100.0,100.0, 0.30,2.0);  // barra piatta -> no
   PrintFormat("[VWAPREV][AUTOTEST] candele: hammer=%d (atteso 1) | corpo grosso=%d (atteso 0) | hammer su star=%d (atteso 0) | star=%d (atteso 1) | star su hammer=%d (atteso 0)",
               (int)c1,(int)c2,(int)c3,(int)c4,(int)c5);
   PrintFormat("[VWAPREV][AUTOTEST] candele: doji=%d (atteso 1) | non doji=%d (atteso 0) | piatta=%d (atteso 0)",
               (int)c6,(int)c7,(int)c8);
   if(!(c1 && !c2 && !c3 && c4 && !c5 && c6 && !c7 && !c8)) falliti++;

   //--- 4. LA CHIUSURA DELLA BARRA DI CONFERMA (range 100-110, pct 0,30)
   bool d1 = ChiusuraForte_Calc(true ,110.0,100.0,108.0,0.30);  // 80% -> long ok
   bool d2 = ChiusuraForte_Calc(true ,110.0,100.0,102.0,0.30);  // 20% -> no
   bool d3 = ChiusuraForte_Calc(true ,110.0,100.0,107.0,0.30);  // 70% esatto -> ok (>=)
   bool d4 = ChiusuraForte_Calc(false,110.0,100.0,102.0,0.30);  // short 20% -> ok
   bool d5 = ChiusuraForte_Calc(false,110.0,100.0,108.0,0.30);  // short 80% -> no
   bool d6 = ChiusuraForte_Calc(true ,100.0,100.0,100.0,0.30);  // piatta -> no
   PrintFormat("[VWAPREV][AUTOTEST] chiusura: 80%%=%d (atteso 1) | 20%%=%d (atteso 0) | 70%% esatto=%d (atteso 1) | short 20%%=%d (atteso 1) | short 80%%=%d (atteso 0) | piatta=%d (atteso 0)",
               (int)d1,(int)d2,(int)d3,(int)d4,(int)d5,(int)d6);
   if(!(d1 && !d2 && d3 && d4 && !d5 && !d6)) falliti++;

   //--- 5. ENGULFING E CONTINUAZIONE (setup S, conferma C)
   bool e1 = Engulfing_Calc(true ,100.0, 98.0,  97.5,100.5);   // bull engulfing
   bool e2 = Engulfing_Calc(true ,100.0, 98.0,  98.5, 99.5);   // dentro il corpo -> no
   bool e3 = Engulfing_Calc(false,100.0,102.0, 102.5, 99.5);   // bear engulfing
   bool e4 = Continuazione_Calc(true , 100.0,90.0,  99.0,92.0,101.0); // low piu' alto + close sopra il max
   bool e5 = Continuazione_Calc(true , 100.0,90.0,  99.0,89.0,101.0); // low piu' basso -> no
   bool e6 = Continuazione_Calc(false,100.0,90.0,  99.0,88.0, 89.0);  // high piu' basso + close sotto il min
   PrintFormat("[VWAPREV][AUTOTEST] conferma: bull engulf=%d (atteso 1) | non engulf=%d (atteso 0) | bear engulf=%d (atteso 1) | contin. long=%d (atteso 1) | low basso=%d (atteso 0) | contin. short=%d (atteso 1)",
               (int)e1,(int)e2,(int)e3,(int)e4,(int)e5,(int)e6);
   if(!(e1 && !e2 && e3 && e4 && !e5 && e6)) falliti++;

   //--- 6. ANTI-CANDELONE (ATR 10, mult 1,5 -> range max 15)
   bool f1 = AntiCandelone_Calc(110.0,100.0,10.0,1.5);   // range 10 -> passa
   bool f2 = AntiCandelone_Calc(120.0,100.0,10.0,1.5);   // range 20 -> blocca
   bool f3 = AntiCandelone_Calc(115.0,100.0,10.0,1.5);   // range 15 esatto -> passa (<=)
   bool f4 = AntiCandelone_Calc(110.0,100.0, 0.0,1.5);   // ATR mancante -> blocca
   PrintFormat("[VWAPREV][AUTOTEST] anti-candelone: 10=%d (atteso 1) | 20=%d (atteso 0) | 15 esatto=%d (atteso 1) | ATR 0=%d (atteso 0)",
               (int)f1,(int)f2,(int)f3,(int)f4);
   if(!(f1 && !f2 && f3 && !f4)) falliti++;

   //--- 7. IL SEGNALE COMPLETO
   //    LONG: setup = hammer (o 100, h 101, l 90, c 100.5) che tocca il
   //    minimo di 20 barre (90) e chiude a 100,5 SOTTO la banda bassa
   //    (vwap 200, sigma 50, mult 1 -> banda bassa 150).
   //    conferma = o 100.2, h 103, l 100, c 102.4 (closePos 0.8, low piu'
   //    alto del setup, close sopra il massimo del setup) e range 3 <= 1,5*10.
   bool s1 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,102.4,
                               90.0,
                              200.0,50.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   //    stessa cosa ma la chiusura del setup e' DENTRO la banda -> niente
   bool s2 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,102.4,
                               90.0,
                              100.0,50.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   //    ... il setup NON tocca il minimo delle 20 barre (estremo 85) -> niente
   bool s3 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,102.4,
                               85.0,
                              200.0,50.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   //    ... la conferma chiude in basso (100.3 = 10% del range) -> niente
   bool s4 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,100.3,
                               90.0,
                              200.0,50.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   //    ... candelone: ATR 1 -> range max 1,5 contro un range di 3 -> niente
   bool s5 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,102.4,
                               90.0,
                              200.0,50.0,1.0,
                                1.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   //    ... solo engulfing ammesso: qui la conferma e' continuazione -> niente
   bool s6 = SegnaleLato_Calc(true,
                              100.0,101.0, 90.0,100.5,
                              100.2,103.0,100.0,102.4,
                               90.0,
                              200.0,50.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,true);
   //    SHORT speculare: setup = shooting star (o 100, h 110, l 99.5, c 100.5)
   //    al massimo di 20 barre (110), chiusura 100.5 SOPRA la banda alta
   //    (vwap 50, sigma 25, mult 1 -> banda alta 75); conferma o 100.3,
   //    h 100.4, l 97, c 97.4 (closePos ~0.12, high piu' basso, close sotto
   //    il minimo del setup), range 3.4 <= 1,5*10.
   bool s7 = SegnaleLato_Calc(false,
                              100.0,110.0, 99.5,100.5,
                              100.3,100.4, 97.0, 97.4,
                              110.0,
                               50.0,25.0,1.0,
                               10.0,1.5,
                                0.30,2.0,0.20,0.30,false);
   PrintFormat("[VWAPREV][AUTOTEST] segnale long: completo=%d (atteso 1) | dentro banda=%d (atteso 0) | non all'estremo=%d (atteso 0) | conferma debole=%d (atteso 0)",
               (int)s1,(int)s2,(int)s3,(int)s4);
   PrintFormat("[VWAPREV][AUTOTEST] segnale: candelone=%d (atteso 0) | solo-engulfing=%d (atteso 0) | SHORT speculare=%d (atteso 1)",
               (int)s5,(int)s6,(int)s7);
   if(!(s1 && !s2 && !s3 && !s4 && !s5 && !s6 && s7)) falliti++;

   //--- 8. IL PAVIMENTO, NELLE DUE SEMANTICHE
   //    entry 100, stop strutturale 99,8 (=0,2); ATR 10 x 0,2 = pavimento 2,0
   double g5 = RischioConPavimento_Calc(true ,100.0, 99.8,10.0,0.20);  // R sale a 2.0, stop invariato
   double g6 = RischioConPavimento_Calc(true ,100.0, 97.0,10.0,0.20);  // gia' oltre -> resta 3.0
   double g7 = RischioConPavimento_Calc(false,100.0,100.2,10.0,0.20);  // short -> 2.0
   double g8 = RischioConPavimento_Calc(true ,100.0,100.5,10.0,0.20);  // stop dal lato sbagliato -> 0
   double h1 = PavimentoSL_Calc(true ,100.0, 99.8,2.0);   // ALLARGA: stop a 98.00
   double h2 = PavimentoSL_Calc(true ,100.0, 97.0,2.0);   // gia' oltre -> invariato
   double h3 = PavimentoSL_Calc(true ,100.0, 99.8,0.0);   // pavimento spento -> invariato
   double h4 = PavimentoSL_Calc(false,100.0,100.2,2.0);   // short -> 102.00
   PrintFormat("[VWAPREV][AUTOTEST] pavimento AUTORE (R): %.2f (atteso 2.00) | %.2f (atteso 3.00) | short %.2f (atteso 2.00) | lato sbagliato %.2f (atteso 0.00)",
               g5,g6,g7,g8);
   PrintFormat("[VWAPREV][AUTOTEST] pavimento ALLARGA (SL): %.2f (atteso 98.00) | %.2f (atteso 97.00) | spento %.2f (atteso 99.80) | short %.2f (atteso 102.00)",
               h1,h2,h3,h4);
   if(MathAbs(g5-2.0)>0.0001 || MathAbs(g6-3.0)>0.0001 ||
      MathAbs(g7-2.0)>0.0001 || MathAbs(g8-0.0)>0.0001) falliti++;
   if(MathAbs(h1-98.0)>0.0001 || MathAbs(h2-97.0)>0.0001 ||
      MathAbs(h3-99.8)>0.0001 || MathAbs(h4-102.0)>0.0001) falliti++;

   //--- 9. LA SESSIONE E L'ORARIO
   datetime tA = D'2026.08.25 09:00:00';
   datetime tB = D'2026.08.25 23:00:00';
   datetime tC = D'2026.08.26 09:00:00';
   bool m1 = (SessionStamp_Calc(tA,0)==SessionStamp_Calc(tB,0));   // stesso giorno solare
   bool m2 = (SessionStamp_Calc(tA,0)==SessionStamp_Calc(tC,0));   // giorni diversi
   //  ancoraggio alle 22: le 23:00 del 25 e le 09:00 del 26 stanno nella
   //  STESSA sessione (che va dalle 22:00 del 25 alle 22:00 del 26)...
   bool m3 = (SessionStamp_Calc(tB,22)==SessionStamp_Calc(tC,22));
   //  ... mentre le 09:00 del 25 stanno in quella PRIMA.
   bool m4 = (SessionStamp_Calc(tA,22)==SessionStamp_Calc(tB,22));
   bool o1 = OraAmmessa_Calc(12,10,16);    // dentro
   bool o2 = OraAmmessa_Calc(17,10,16);    // fuori
   bool o3 = OraAmmessa_Calc(10,10,16);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[VWAPREV][AUTOTEST] sessione: stesso giorno=%d (atteso 1) | giorni diversi=%d (atteso 0) | ancoraggio 22 unisce=%d (atteso 1) | ancoraggio 22 separa=%d (atteso 0)",
               (int)m1,(int)m2,(int)m3,(int)m4);
   PrintFormat("[VWAPREV][AUTOTEST] orario: 12 in 10-16=%d (atteso 1) | 17=%d (atteso 0) | estremo 10=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(m1 && !m2 && m3 && !m4 && o1 && !o2 && o3 && o4)) falliti++;

   //--- 10. IL FLAT DI FINE SEDUTA (flat alle 20:45 server)
   //    Il caso che conta e' il TERZO: alle 20:00 il flat NON deve
   //    scattare. Un confronto sulla sola ora ("t.hour >= 20") lo
   //    farebbe scattare, e chiuderebbe 45 minuti prima ogni giorno.
   //  NOMI fl* e non f*: f1..f4 sono gia' dichiarate dal blocco 6
   //  (anti-candelone, sopra) nello STESSO scope di funzione.
   bool fl1 = DopoOrarioFlat_Calc(20,45,20,45);   // esatto -> si'
   bool fl2 = DopoOrarioFlat_Calc(20,46,20,45);   // dopo   -> si'
   bool fl3 = DopoOrarioFlat_Calc(20, 0,20,45);   // stessa ora, prima -> NO
   bool fl4 = DopoOrarioFlat_Calc(23,59,20,45);   // fino a mezzanotte -> si'
   bool fl5 = DopoOrarioFlat_Calc( 9,30,20,45);   // mattina -> no
   bool fl6 = DopoOrarioFlat_Calc( 0, 0,20,45);   // giorno nuovo -> no
   //    la coda: 30 minuti prima delle 20:45 = dalle 20:15
   bool q1 = CodaSeduta_Calc(20,15,20,45,30);    // esatto -> si'
   bool q2 = CodaSeduta_Calc(20,14,20,45,30);    // un minuto prima -> no
   bool q3 = CodaSeduta_Calc(20,50,20,45,30);    // oltre il flat -> si'
   bool q4 = CodaSeduta_Calc(20,15,20,45, 0);    // guardia SPENTA -> sempre no
   PrintFormat("[VWAPREV][AUTOTEST] flat 20:45: esatto=%d (atteso 1) | 20:46=%d (atteso 1) | 20:00=%d (atteso 0) | 23:59=%d (atteso 1) | 09:30=%d (atteso 0) | 00:00=%d (atteso 0)",
               (int)fl1,(int)fl2,(int)fl3,(int)fl4,(int)fl5,(int)fl6);
   PrintFormat("[VWAPREV][AUTOTEST] coda 30min: 20:15=%d (atteso 1) | 20:14=%d (atteso 0) | 20:50=%d (atteso 1) | spenta=%d (atteso 0)",
               (int)q1,(int)q2,(int)q3,(int)q4);
   if(!(fl1 && fl2 && !fl3 && fl4 && !fl5 && !fl6 && q1 && !q2 && q3 && !q4)) falliti++;

   Print("[VWAPREV][AUTOTEST] esito motore: ", (falliti==0
         ? "DIECI BLOCCHI SU DIECI, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e lo stesso esito ESCE IN COLONNA (OnTester -> stats[10]): in
   //    ottimizzazione questa Print non la legge nessuno.
   gAutotestFalliti = falliti;

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- blocco standard ABTG
//  Formato per riga (separatore ';'):
//    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| Export per-trade in Common\Files (per dd_portafoglio.py).         |
//| Solo tester: in griglia ogni pass con lo stesso magic SOVRASCRIVE |
//| il file -> usare solo con pin + magic-sweep (2 celle).            |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[13];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che servono per rispondere "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
   //--- le tre colonne di COLLAUDO. Non sono metriche di merito: sono il
   //    gate che dice se i numeri accanto si possono leggere. In
   //    ottimizzazione le Print degli agent non le legge nessuno.
   stats[10] = (double)gAutotestFalliti;   // 0 = tutti passati; >0 = DIVERGE; -1 = non eseguito
   stats[11] = (double)gFlatGiorni;        // 0 col flat spento: se e' >0 l'interruttore non morde
   stats[12] = (double)gFlatChiusure;      // posizioni davvero chiuse dal flat
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         //--- ATTENZIONE: 'head' e lo StringFormat qui sotto si toccano
         //    SEMPRE INSIEME. Una colonna aggiunta a uno solo dei due
         //    sfasa tutto il CSV e il driver legge il numero sbagliato
         //    sotto il nome giusto.
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
