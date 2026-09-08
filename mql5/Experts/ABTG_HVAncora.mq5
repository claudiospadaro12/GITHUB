//+------------------------------------------------------------------+
//|                                       ABTG_HVAncora.mq5           |
//|                                                                  |
//|  L'ANCORA DI VOLATILITA' - MT5 - TUTTO-IN-UNO                    |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle,        |
//|   serve solo Include\ABTG_PausaGuardian.mqh, gia' in casa)        |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria - e qui la licenza NON C'E')          |
//|    Meccanica derivata da "HV Spike Strategy (HVP + OR Breakout +  |
//|    Reversal + TP/SL Modes)" di kostastrovas (TradingView, slug    |
//|    1oZNa7Oq, creato 26/10/2025, Pine v6, 134 righe).              |
//|      https://www.tradingview.com/script/1oZNa7Oq-HV-Spike-Strategy-HVP-OR-Breakout-Reversal-TP-SL-Modes/
//|    LICENZA DEL SORGENTE: [INCERTO] -- NESSUNA intestazione di     |
//|    licenza nel sorgente. Cio' che e' VERIFICATO (08/09/2026, via  |
//|    pine-facade) e' solo che scriptAccess = "open_no_auth", cioe'  |
//|    che il sorgente e' PUBBLICAMENTE LEGGIBILE. Leggibile NON      |
//|    vuol dire riutilizzabile: per questo qui non c'e' UNA RIGA     |
//|    del suo codice.                                                |
//|    Copia archiviata in casa (come letta, per tracciabilita'):     |
//|      backtest_pipeline\caccia_strategie\biblioteca\sorgenti\      |
//|      HvSpikeOrBreakoutReversal_kostastrovas-NOLICENSE_tv1oZNa7Oq_2026-09-08.pine
//|    NESSUNA RIGA E' STATA COPIATA: il sorgente e' stato LETTO      |
//|    riga per riga e questo .mq5 e' scritto DA SPECIFICA (referto   |
//|    report\CACCIA_M30_INDICI_2026-09-08.md, candidato P3 8/10, e   |
//|    bozza backtest_pipeline\prove\HVANCHOR_M30_BOZZA.txt).         |
//|    Gestione, prop-hardening, orari, flat di seduta, sizing a      |
//|    rischio, tetto di vita dell'ancora e diagnostica sono DI CASA  |
//|    e NON vengono dalla fonte.                                     |
//|                                                                  |
//|  COS'E' - IL LIVELLO NON LO SCEGLIAMO NOI: LO SCEGLIE L'EVENTO.  |
//|    La barra in cui la volatilita' storica SALTA DI PERCENTILE e'  |
//|    la barra in cui e' arrivata l'informazione. Il suo massimo e   |
//|    il suo minimo diventano l'ANCORA, e il suo range il metro:     |
//|      CONTINUAZIONE il prezzo ESTENDE del 100% il range            |
//|                    dell'ancora -> l'informazione aveva seguito    |
//|      ESAURIMENTO   il prezzo aveva esteso del 100% ma RIENTRA     |
//|                    dentro il range dell'ancora -> era una scossa  |
//|    Non c'e' nessun orario, nessuna campanella, nessun box         |
//|    d'apertura: il MOTORE NON SA CHE ORA E'. E' la differenza da   |
//|    M2 (ORB condizionato alla volatilita', dove la volatilita'     |
//|    AUTORIZZA un box orario) e da M1/ORB nudo (chiuso in casa con  |
//|    ~210 celle rosse).                                             |
//|                                                                  |
//|  IL LATO NON E' UN INPUT: LO DECIDE L'ANCORA.                     |
//|    Estensione 100% VERSO L'ALTO         -> LONG  (continuazione)  |
//|    Estensione 100% VERSO IL BASSO       -> SHORT (continuazione)  |
//|    Estensione GIU' fallita e rientrata  -> LONG  (esaurimento)    |
//|    Estensione SU fallita e rientrata    -> SHORT (esaurimento)    |
//|    InpAllowLong/InpAllowShort e InpUsaRamo* servono a MISURARE i  |
//|    rami e i lati SEPARATAMENTE (regola dei due lati del 25/08 e   |
//|    cancelli C4/C5 della bozza), non a scegliere a tavolino.       |
//|                                                                  |
//|  #### TRE COSE CHE HO TROVATO LEGGENDO IL PINE, E CHE CAMBIANO    |
//|  #### COSA SIGNIFICA QUESTO MOTORE. Vanno lette prima del codice. |
//|                                                                  |
//|  (1) NEL SORGENTE LO STOP E IL TAKE NON ESISTONO AFFATTO.         |
//|      Riga 113: `entryPrice = strategy.position_avg_price` e'      |
//|      calcolato PRIMA dell'ingresso (righe 122-130), quindi sulla  |
//|      barra d'ingresso vale `na`; quindi `strategy.exit(stop=na,   |
//|      limit=na)` NON PIAZZA NIENTE, e `strategy.exit` non viene    |
//|      richiamato nelle barre successive.                           |
//|      >>> Qualunque numero di performance mostrato dall'autore e'  |
//|          il risultato di una strategia SENZA USCITE. Non pesa     |
//|          comunque (regola di casa: i numeri degli autori non      |
//|          sono un criterio), ma e' la ragione per cui questo       |
//|          motore vale SOLO con una gestione NOSTRA.                |
//|      >>> Qui il problema non puo' esistere: lo stop viaggia       |
//|          DENTRO l'OrderSend, dal primo tick.                      |
//|      >>> E' lo stesso baco trovato in 3 sorgenti su 13 nella      |
//|          caccia dell'08/09: e' un cancello di lettura, non un     |
//|          aneddoto.                                                |
//|                                                                  |
//|  (2) NEL SORGENTE IL RAMO "REVERSAL" E' CODICE MORTO.             |
//|      Riga 106: `breakoutLong = not tradeTaken and close >         |
//|      longTrigger`; riga 96: la MEDESIMA barra accende anche       |
//|      `longBreakout100`. Quindi la prima barra che chiude oltre    |
//|      il 100% prende SUBITO il trade di continuazione e mette      |
//|      `tradeTaken := true` -- e il ramo reversal, che pretende     |
//|      `not tradeTaken`, non puo' piu' scattare per quell'ancora.   |
//|      Non esiste nessun input per spegnere il breakout.            |
//|      >>> Nel sorgente il "Reversal" del titolo NON GIRA MAI.      |
//|      >>> Qui e' lo stesso PER FEDELTA' quando entrambi i rami     |
//|          sono accesi (una sola operazione per ancora, e la        |
//|          continuazione arriva prima), MA:                         |
//|          - i CONTATORI dei due rami sono separati e contano le    |
//|            OCCASIONI per tutta la vita dell'ancora, anche dopo    |
//|            che l'operazione e' stata presa;                       |
//|          - InpUsaRamoContinuazione=false RENDE RAGGIUNGIBILE il   |
//|            ramo esaurimento, che e' l'unico modo di misurarlo.    |
//|      >>> CONSEGUENZA DA SCRIVERE NEI REFERTI: nella cella con     |
//|          entrambi i rami accesi gli INGRESSI di esaurimento       |
//|          saranno ~0 PER COSTRUZIONE. Non e' un bug e non e' un    |
//|          verdetto sul ramo: e' la gerarchia della fonte.          |
//|                                                                  |
//|  (3) IL "PERCENTILE A 252 BARRE" SU M30 NON E' UN ANNO: E' UNA    |
//|      SETTIMANA. 252 e' il numero di sedute di un anno su un       |
//|      grafico GIORNALIERO. Su M30, con ~46 barre al giorno sugli   |
//|      indici, 252 barre valgono ~5-6 sedute.                       |
//|      >>> Quindi il motore NON misura "la volatilita' rara         |
//|          dell'anno": misura la volatilita' rispetto ALL'ULTIMA    |
//|          SETTIMANA. L'attivazione e' molto meno rara di quanto    |
//|          il nome "HV Spike" faccia pensare.                       |
//|      >>> Lo dichiaro perche' ribalta l'attesa del dossier ("la    |
//|          frequenza crolla"): la finestra del percentile e'        |
//|          l'input che decide la frequenza, ed e' InpHvLookback.    |
//|          Il numero vero lo dice il PASSO 0, non questa nota.      |
//|                                                                  |
//|  #### QUESTO MOTORE NON USA IL VOLUME. ####                       |
//|    Detto apposta: il LIMITE NOTO N.1 di ABTG_LVNArbitro (su CFD   |
//|    MT5 espone TICK VOLUME, non volume scambiato) QUI NON SI       |
//|    APPLICA. La volatilita' storica si calcola sui PREZZI DI       |
//|    CHIUSURA, che sul nostro feed sono la stessa variabile della   |
//|    fonte. E' l'unico dei tre candidati M30 che non ha questo      |
//|    rischio di porting.                                            |
//|                                                                  |
//|  #### LA MODALITA' "MARKET SESSIONS" DELLA FONTE NON ESISTE QUI.  |
//|    Il Pine ha due modalita' di attivazione: (a) salto di          |
//|    percentile, (b) apertura di Tokyo/Londra/New York. La (b) e'   |
//|    UN ORB CON UN ALTRO NOME, e l'ORB in casa e' chiuso con ~210   |
//|    celle a tick (R45 0/48, R12 48/48 negative): implementarla     |
//|    violerebbe alla lettera la Regola della Seconda Caccia         |
//|    (19/08, "mai parametri diversi dello stesso motore morto").    |
//|    >>> InpModoAttivazione esiste SOLO per compatibilita' col      |
//|        file prova e ACCETTA SOLO 0. Con qualunque altro valore    |
//|        OnInit RIFIUTA di partire. Il divieto B0 della bozza qui   |
//|        non e' una promessa: e' impossibile da violare.            |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. Il server BCM e' ORA ITALIANA - 1.        |
//|    InpOraInizio/InpOraFine/InpOraFlat sono SEMPRE in ORA SERVER.  |
//|    Un'ora sbagliata qui non da' errore: MISURA UN'ALTRA           |
//|    STRATEGIA (CLAUDE.md, regola fissa).                           |
//|                                                                  |
//|  PROP-HARDENING (di casa, NON del sorgente esterno)               |
//|    - STOP LOSS VERO AL BROKER, allegato all'ordine di mercato.    |
//|      MAI un ingresso senza stop (vedi il punto (1) qui sopra).    |
//|    - PAVIMENTO DI STOP InpMinStopPts (lezione R109) in PUNTI      |
//|      INDICE, MAI zero: OnInit RIFIUTA se e' 0.                    |
//|    - GATE DI SPREAD IN % DELLO STOP (R55): un cancello in punti   |
//|      fissi mente cambiando simbolo, questo no.                    |
//|    - FLAT DI FINE SEDUTA (ora server): ZERO overnight. Il         |
//|      sorgente tiene la posizione per giorni.                      |
//|    - TETTO DI VITA DELL'ANCORA (InpAncoraBarre) + scadenza a fine |
//|      giornata (InpAncoraSoloOggi): la fonte non ha nessuno dei    |
//|      due, e un'ancora vecchia di tre settimane puo' ancora        |
//|      sparare. Un'ancora di ieri che scatta sul gap di stamattina  |
//|      non e' questo motore: e' un altro.                           |
//|    - RISCHIO IN % (InpRiskPercent), MAI lotto fisso e MAI         |
//|      percent_of_equity (il Pine usa il 10% dell'equity a trade).  |
//|      UNA SOLA posizione, UNA SOLA TRANCHE: il difetto del lotto   |
//|      in tranche (report/FIX_LOTTO_PENDENTE_2026-09-08.md) qui     |
//|      NON PUO' esistere, perche' non c'e' nessuna seconda tranche. |
//|    - GUARDIAN (firme B1/C1 del 18/08) chiamato IMMEDIATAMENTE     |
//|      prima dell'invio, come negli altri EA di casa.               |
//|    - NIENTE martingala, griglia, recovery, averaging,             |
//|      piramidazione, stop virtuali. Ingresso SINGOLO.              |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. La barra si valuta allo shift 1      |
//|    (appena chiusa) e si entra a mercato all'apertura della barra  |
//|    successiva. Niente look-ahead, niente repaint.                 |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola    |
//|  di casa). NON COMPILATO NE' TESTATO da chi ha scritto il file:   |
//|  qui non c'e' MetaEditor e non c'e' lo Strategy Tester. Quanto    |
//|  segue e' REVISIONE STATICA. Compilare in MetaEditor (F7) e       |
//|  validare nel tester prima di qualunque verdetto.                 |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG - Ancora di volatilita' (da specifica; meccanica derivata da HV Spike Strategy di kostastrovas, licenza INCERTA, nessuna riga copiata)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Guardian del conto (firme B1/C1 del 18/08) ==="
//  true = prima di APRIRE chiede il via libera al guardiano del conto.
//  Nel tester le sue GlobalVariable non esistono: la guardia lascia
//  passare tutto (fail-open), quindi i backtest restano confrontabili.
input bool   InpUsaGuardian         = true;   // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)

input group "=== ATTIVAZIONE: l'ancora (default = quelli della fonte) ==="
//  0 = SOLO HV Spike. QUALUNQUE ALTRO VALORE -> OnInit RIFIUTA.
//  La modalita' "Market Sessions" della fonte NON e' implementata:
//  e' un ORB, e l'ORB e' chiuso in casa con ~210 celle (divieto B0).
input int    InpModoAttivazione     = 0;      // 0 = SOLO salto di percentile HV (unico valore ammesso)
input int    InpHvLen               = 30;     // Barre della deviazione standard dei log-rendimenti (fonte: 30)
input int    InpHvLookback          = 252;    // Barre su cui si calcola il PERCENTILE della HV (fonte: 252 -- su M30 e' ~una settimana, non un anno)
input double InpHvSoglia            = 50.0;   // Percentile da ATTRAVERSARE verso l'alto per creare l'ancora (fonte: 50)
input int    InpAncoraBarre         = 20;     // DI CASA: vita massima dell'ancora in barre valutate (la fonte non ha tetto)
input bool   InpAncoraSoloOggi      = true;   // DI CASA: l'ancora muore col cambio di giorno server (niente ancore che sparano sul gap)

input group "=== I DUE RAMI (si misurano SEPARATAMENTE, cancello C5) ==="
//  ATTENZIONE (punto (2) dell'intestazione): con ENTRAMBI accesi il
//  ramo ESAURIMENTO e' irraggiungibile per costruzione, esattamente
//  come nella fonte. Per misurarlo serve InpUsaRamoContinuazione=false.
input bool   InpUsaRamoContinuazione = true;  // Ramo CONTINUAZIONE: chiusura oltre il 100% del range dell'ancora
input bool   InpUsaRamoEsaurimento   = true;  // Ramo ESAURIMENTO: estensione 100% fatta e poi RIENTRO dentro l'ancora

input group "=== LATI (regola di casa dei due lati, 25/08) ==="
input bool   InpAllowLong           = true;   // Consenti gli ingressi LONG
input bool   InpAllowShort          = true;   // Consenti gli ingressi SHORT

input group "=== SESSIONE (ORA SERVER BCM = ora italiana - 1) ==="
//  DECISIONE DICHIARATA, NON E' DELLA FONTE: il Pine opera 24 ore.
//  La finestra esiste per il COSTO, non per il motore: fuori sessione
//  lo spread misurato sugli indici BCM raddoppia (DAX 3,5-3,9 punti
//  contro 1,6-1,7 in sessione) e la frontiera stop >= 40 x spread
//  salterebbe.
//  >>> EFFETTO COLLATERALE DA DICHIARARE: fuori finestra NON si
//      valuta niente, quindi NON si creano ancore. Un attraversamento
//      di percentile che capita di notte non viene visto, e se al
//      mattino la HV e' gia' sopra soglia l'attraversamento e' ormai
//      passato. La finestra COSTA FREQUENZA: e' un prezzo scelto, e
//      allargarla e' un input, non una riscrittura.
input int    InpOraInizio           = 8;      // ORA SERVER di apertura della finestra (8 = 09:00 IT)
input int    InpMinInizio           = 0;      // MINUTO SERVER di apertura della finestra
input int    InpOraFine             = 20;     // ORA SERVER dell'ULTIMO ingresso ammesso (20:30 = 21:30 IT)
input int    InpMinFine             = 30;     // MINUTO SERVER dell'ultimo ingresso ammesso
input bool   InpUsaFlatSeduta       = true;   // true = ZERO overnight (regola di casa). false = SOLO per esperimenti dichiarati
input int    InpOraFlat             = 21;     // ORA SERVER del flat di fine seduta
input int    InpMinFlat             = 0;      // MINUTO SERVER del flat di fine seduta

input group "=== STOP LOSS (vero, al broker; pavimento R109) ==="
input double InpStopAtr             = 1.0;    // Stop = X x ATR(InpAtrLen) della barra di segnale (fonte: 1,0)
input int    InpAtrLen              = 14;     // Periodo dell'ATR dello stop (fonte: 14)
input int    InpMinStopPts          = 25;     // PAVIMENTO SL in PUNTI INDICE (MAI 0: OnInit rifiuta)
input double InpMT5PerPuntoIndice   = 100;    // Punti MT5 (_Point) per 1 punto indice (D30EUR/NASUSD/U30USD: 100)

input group "=== USCITA ==="
input double InpRR                  = 2.0;    // Take profit = InpRR x rischio (R). Fonte: TP 2,0 x ATR con SL 1,0 x ATR = 2R
input double InpBEatR               = 0.0;    // Breakeven a questo R (0 = SPENTO = come la fonte). E' una MODIFICA dell'ordine

input group "=== Rischio ==="
input double InpRiskPercent         = 0.65;   // Rischio per trade in % (contratto di casa: 0,65)
input double InpMaxSpreadPctOfStop  = 2.5;    // Gate di spread (R55): spread <= X% dello stop, altrimenti si salta
//  0 = ILLIMITATO, cioe' come la fonte. Su QUESTO candidato il rischio
//  dichiarato e' la RAFFICA (gli attraversamenti di percentile si
//  raggruppano, perche' la volatilita' e' persistente): per questo il
//  CSV riporta "Max Trade Giorno" e "Max Trade Settimana". Si misura
//  prima, si tappa dopo -- mai il contrario.
input int    InpMaxTradesPerDay     = 0;      // Tetto ingressi per giorno server (0 = illimitato, come la fonte)

input group "=== Generali ==="
input long   InpMagic               = 776900; // Numero magico (blocco 7769xx: VERIFICATO LIBERO nel repo l'08/09/2026)
input string InpComment             = "HVA";  // Commento sugli ordini
input bool   InpVerbose             = true;   // Messaggi nel log

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;

int      gAtrH     = INVALID_HANDLE;
datetime gLastBar  = 0;

//--- marcatore della barra gia' VALUTATA: si timbra PRIMA di mandare
//    l'ordine, cosi' un rifiuto del broker NON produce un secondo
//    tentativo sulla stessa barra. Niente inseguimenti.
long     gBarraValutata = -1;

//--- L'ANCORA. E' tutto lo stato del motore: se questa non c'e', il
//    motore non ha nemmeno un prezzo di riferimento.
bool     gAncViva      = false;
double   gAncHigh      = 0.0;   // massimo della barra-evento
double   gAncLow       = 0.0;   // minimo della barra-evento
double   gLiv100Up     = 0.0;   // ancHigh + range        (estensione 100% in su)
double   gLiv100Dn     = 0.0;   // ancLow  - range        (estensione 100% in giu')
double   gLiv50Up      = 0.0;   // ancHigh + range/2      (solo diagnostica, vedi nota di fedelta')
double   gLiv50Dn      = 0.0;   // ancLow  - range/2      (solo diagnostica, vedi nota di fedelta')
int      gAncEta       = 0;     // barre VALUTATE trascorse dall'attivazione
int      gAncGiorno    = -1;    // giorno server di nascita dell'ancora
bool     gExtUp        = false; // estensione 100% in su gia' avvenuta
bool     gExtDn        = false; // estensione 100% in giu' gia' avvenuta
bool     gAncUsata     = false; // una sola operazione per ancora (fonte: tradeTaken)
//--- occasioni gia' CONTATE per questa ancora (i contatori dicono
//    quante occasioni c'erano, non quante volte la stessa e' rimasta
//    vera barra dopo barra)
bool     gVistoContUp  = false;
bool     gVistoContDn  = false;
bool     gVistoEsaurUp = false;   // rientro dopo estensione in SU (-> short)
bool     gVistoEsaurDn = false;   // rientro dopo estensione in GIU' (-> long)

//--- tetto giornaliero (solo se InpMaxTradesPerDay > 0)
int      gGiornoStamp   = -1;
int      gTradeOggi     = 0;

//--- raffica: massimo ingressi in un giorno e in 7 giorni (cancello C6)
int      gGiornoRaffica    = -1;
int      gTradeGiorno      = 0;
int      gMaxTradeGiorno   = 0;
int      gSettStamp        = -1;
int      gTradeSettimana   = 0;
int      gMaxTradeSettimana= 0;

//--- breakeven: una volta sola per posizione, legata al ticket
ulong    gTicketCorrente  = 0;
double   gRischioPrezzo   = 0.0;   // R in PREZZO della posizione viva
bool     gBEfatto         = false;

int      gFlatLogGiorno   = -1;

//--- peggior giornata in % (colonna prop)
double   gDayStartEquity  = 0.0;
double   gDayMinEquity    = 0.0;
double   gWorstDayPct     = 0.0;
int      gDayEqStamp      = -1;

//--- DIAGNOSTICA (solo misura: e' il PASSO 0 letto dal CSV)
long gCntBarre        = 0;   // barre chiuse valutate dentro la finestra
long gCntNoDati       = 0;   // storico/ATR insufficienti (campione incompleto)
long gCntAncore       = 0;   // ANCORE create (attraversamenti di percentile visti)
long gCntAncScadute   = 0;   // ancore morte SENZA aver operato (eta', cambio giorno o rimpiazzo da una nuova attivazione)
long gCntContLong     = 0;   // occasioni GREZZE ramo continuazione rialzista
long gCntContShort    = 0;   // occasioni GREZZE ramo continuazione ribassista
long gCntEsaurLong    = 0;   // occasioni GREZZE ramo esaurimento -> long (estensione GIU' fallita)
long gCntEsaurShort   = 0;   // occasioni GREZZE ramo esaurimento -> short (estensione SU fallita)
long gCntAmbiguo      = 0;   // rientro con ENTRAMBE le estensioni fatte: si sta fuori
long gCntRamoNo       = 0;   // segnale valido ma quel RAMO e' spento
long gCntLatoNo       = 0;   // segnale valido ma quel LATO e' spento
long gCntAncUsata     = 0;   // segnale valido ma l'ancora aveva gia' operato
long gCntGiaAperta    = 0;   // c'era gia' una posizione di questo magic
long gCntFuoriOrario  = 0;   // barre chiuse FUORI dalla finestra di ingresso
long gCntTettoGiorno  = 0;   // ingressi bloccati dal tetto giornaliero
long gCntLong         = 0;   // ingressi LONG eseguiti
long gCntShort        = 0;   // ingressi SHORT eseguiti
long gCntReject       = 0;   // ingressi scartati (spread/geometria/lotto/broker)
long gCntGuardian     = 0;   // ingressi bloccati dal Guardian
long gCntBE           = 0;   // breakeven applicati
long gFlatChiusure    = 0;   // posizioni chiuse dal flat di fine seduta

void Log(string m){ if(InpVerbose) Print("[HVA] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Stanno separate apposta: sono quelle che si possono verificare
//   a tavolino contro la specifica, senza MT5 (e qui MT5 non c'e').
//
//==================================================================

//--- esito del motore su una barra
struct SegnaleHV
  {
   bool  contLong;    // occasione grezza: continuazione rialzista
   bool  contShort;   // occasione grezza: continuazione ribassista
   bool  esaurLong;   // occasione grezza: estensione GIU' fallita -> long
   bool  esaurShort;  // occasione grezza: estensione SU fallita -> short
   int   dir;         // +1 long, -1 short, 0 niente
   int   ramo;        // 0 nessuno, 1 CONTINUAZIONE, 2 ESAURIMENTO
   bool  ambiguo;     // rientro con estensioni su ENTRAMBI i lati: fuori
  };

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno.                                    |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| Siamo dentro la finestra di INGRESSO? Estremi compresi. La        |
//| finestra NON attraversa la mezzanotte (garantito da OnInit).      |
//+------------------------------------------------------------------+
bool DentroFinestra_Calc(const int ora,const int minuto,
                         const int daOra,const int daMin,
                         const int aOra,const int aMin)
  {
   int m = ora*60+minuto;
   return(m >= daOra*60+daMin && m <= aOra*60+aMin);
  }

//+------------------------------------------------------------------+
//| Siamo all'ora del flat (o oltre)?                                 |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| DEVIAZIONE STANDARD DI POPOLAZIONE (divisore N), come ta.stdev    |
//| di Pine. Sui valori contigui di un array.                         |
//+------------------------------------------------------------------+
double StdevPop_Calc(const double &v[],const int da,const int quanti)
  {
   if(quanti<2) return(0);
   double somma=0;
   for(int i=0;i<quanti;i++) somma += v[da+i];
   double media = somma/quanti;
   double acc=0;
   for(int i=0;i<quanti;i++)
     {
      double d = v[da+i]-media;
      acc += d*d;
     }
   return(MathSqrt(acc/quanti));
  }

//+------------------------------------------------------------------+
//| LA SERIE DELLA VOLATILITA' STORICA.                               |
//|                                                                   |
//| cl[] arriva da CopyClose: ORDINE CRONOLOGICO, cl[n-1] e' la barra |
//| allo SHIFT 1 (l'ultima CHIUSA). hv[k] = HV della barra allo shift |
//| (k+1), calcolata sui 'len' log-rendimenti che finiscono li'.      |
//|                                                                   |
//| >>> NOTA CHE VALE UNA RIGA DI CODICE IN MENO E UNA SPIEGAZIONE IN |
//|     PIU': la fonte moltiplica per 100*sqrt(365) (annualizzazione). |
//|     E' una COSTANTE POSITIVA uguale per tutte le barre, e il       |
//|     motore usa solo il PERCENTILE, che e' un RANGO: moltiplicare   |
//|     tutta la serie per una costante NON cambia nemmeno un rango.   |
//|     Quindi qui non si annualizza, e il segnale e' IDENTICO.        |
//|     Non e' una semplificazione: e' la stessa funzione.             |
//+------------------------------------------------------------------+
bool HvSerie_Calc(const double &cl[],const int n,const int len,
                  const int quante,double &hv[])
  {
   if(len<2 || quante<1) return(false);
   if(n < quante + len) return(false);          // servono quante+len chiusure

   //--- log-rendimenti: r[j] e' il rendimento CHE FINISCE sulla
   //    chiusura cl[j] (quindi j parte da 1)
   double r[];
   if(ArrayResize(r,n)<n) return(false);
   r[0]=0.0;
   for(int j=1;j<n;j++)
     {
      if(cl[j]<=0 || cl[j-1]<=0) return(false);
      r[j] = MathLog(cl[j]/cl[j-1]);
     }

   if(ArrayResize(hv,quante)<quante) return(false);
   for(int k=0;k<quante;k++)
     {
      int s      = k+1;          // shift della barra
      int fine   = n-s;          // indice in cl[]/r[] della barra allo shift s
      int inizio = fine-len+1;   // primo rendimento della finestra
      if(inizio<1) return(false);
      hv[k] = StdevPop_Calc(r,inizio,len);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| PERCENTILE DELLA BARRA hv[idx] DENTRO LE 'lookback' BARRE CHE     |
//| PARTONO DA LEI (se stessa compresa) -- e' esattamente il conto    |
//| della fonte (righe 44-53): quante delle ultime 'lookback' letture |
//| sono <= a quella corrente, in percentuale.                        |
//+------------------------------------------------------------------+
double Percentile_Calc(const double &hv[],const int idx,const int lookback)
  {
   if(lookback<1) return(-1);
   if(idx<0 || idx+lookback > ArraySize(hv)) return(-1);
   int sotto=0;
   for(int i=0;i<lookback;i++)
      if(hv[idx] >= hv[idx+i]) sotto++;
   return(100.0*sotto/lookback);
  }

//+------------------------------------------------------------------+
//| L'ATTIVAZIONE: si ATTRAVERSA la soglia verso l'alto, non si "sta  |
//| sopra". E' la differenza fra un evento e uno stato, ed e' la      |
//| ragione per cui il motore ha un'ANCORA e non un regime.           |
//+------------------------------------------------------------------+
bool Attivazione_Calc(const double pctOra,const double pctPrima,const double soglia)
  {
   if(pctOra<0 || pctPrima<0) return(false);
   return(pctOra > soglia && pctPrima <= soglia);
  }

//+------------------------------------------------------------------+
//| I LIVELLI DELL'ANCORA, dal range della barra-evento.              |
//+------------------------------------------------------------------+
bool LivelliAncora_Calc(const double h,const double l,
                        double &liv100Up,double &liv100Dn,
                        double &liv50Up,double &liv50Dn)
  {
   double range = h-l;
   if(range<=0) return(false);          // barra piatta: ancora senza metro
   liv100Up = h + range;
   liv100Dn = l - range;
   liv50Up  = h + range*0.5;
   liv50Dn  = l - range*0.5;
   return(true);
  }

//+------------------------------------------------------------------+
//| IL MOTORE, in una funzione sola e senza terminale.                |
//|                                                                   |
//| Portato DALLA FONTE (righe 95-110):                               |
//|   longBreakout100  : close > longTrigger                          |
//|   shortBreakout100 : close < shortTrigger                         |
//|   backInsideORB    : (uno dei due) e close < spikeHigh e          |
//|                      close > spikeLow                             |
//|   reverseLong      : shortBreakout100 e backInsideORB e           |
//|                      close > short50                              |
//|   reverseShort     : longBreakout100  e backInsideORB e           |
//|                      close < long50                               |
//|                                                                   |
//| >>> NOTA DI FEDELTA' N.1, e va detta perche' cambia cosa e' il    |
//|     motore: nella fonte il test sul 50% E' LOGICAMENTE IMPLICATO. |
//|     `short50` sta SOTTO il minimo dell'ancora, e `backInsideORB`  |
//|     pretende gia' close > spikeLow > short50. Quindi              |
//|     `close > short50` non aggiunge NIENTE: il ramo esaurimento    |
//|     scatta sulla PRIMA chiusura che RIENTRA dentro il range       |
//|     dell'ancora dopo un'estensione del 100%. Idem, specularmente, |
//|     per `close < long50`.                                         |
//|     >>> I livelli 50% restano calcolati e loggati perche' sono    |
//|         nel disegno della fonte, ma NON sono una condizione. Non  |
//|         invento una terza condizione che nel sorgente non c'e'.   |
//|                                                                   |
//| >>> DECISIONE MIA, non della fonte: se l'ancora ha visto          |
//|     l'estensione 100% DA TUTTE E DUE LE PARTI e poi il prezzo     |
//|     rientra, il rientro accende insieme esaurimento long E short. |
//|     NON SI OPERA (ambiguo). Nella fonte quel caso non si presenta |
//|     solo perche' il ramo reversal e' irraggiungibile (punto (2)   |
//|     dell'intestazione): appena si spegne la continuazione,        |
//|     diventa un caso reale.                                        |
//+------------------------------------------------------------------+
void Motore_Calc(const double c1,
                 const double ancHigh,const double ancLow,
                 const double liv100Up,const double liv100Dn,
                 const bool extUpPrima,const bool extDnPrima,
                 const bool usaContinuazione,const bool usaEsaurimento,
                 SegnaleHV &s,
                 bool &extUpDopo,bool &extDnDopo)
  {
   s.contLong=false; s.contShort=false; s.esaurLong=false; s.esaurShort=false;
   s.dir=0; s.ramo=0; s.ambiguo=false;
   extUpDopo = extUpPrima;
   extDnDopo = extDnPrima;

   if(ancHigh<=ancLow) return;                 // ancora degenere: niente

   //--- ESTENSIONE 100%: la si registra SEMPRE, anche se l'ancora ha
   //    gia' operato. I contatori devono dire quante OCCASIONI
   //    c'erano, non quante ne abbiamo prese.
   bool nuovaExtUp = (!extUpPrima && c1 > liv100Up);
   bool nuovaExtDn = (!extDnPrima && c1 < liv100Dn);
   if(nuovaExtUp) extUpDopo = true;
   if(nuovaExtDn) extDnDopo = true;

   //--- RAMO CONTINUAZIONE: si opera la PRIMA chiusura oltre il 100%
   s.contLong  = nuovaExtUp;
   s.contShort = nuovaExtDn;

   //--- RAMO ESAURIMENTO: c'era gia' l'estensione (PRIMA di questa
   //    barra) e adesso la chiusura e' RIENTRATA dentro l'ancora.
   bool dentro = (c1 < ancHigh && c1 > ancLow);
   s.esaurLong  = (extDnPrima && dentro);      // giu' fallita -> long
   s.esaurShort = (extUpPrima && dentro);      // su fallita   -> short

   //--- decisione, tenendo conto degli interruttori dei rami
   bool cL = s.contLong   && usaContinuazione;
   bool cS = s.contShort  && usaContinuazione;
   bool eL = s.esaurLong  && usaEsaurimento;
   bool eS = s.esaurShort && usaEsaurimento;

   //--- continuazione e esaurimento non possono accendersi insieme
   //    (una chiusura non puo' essere oltre il 100% E dentro
   //    l'ancora), quindi l'unica ambiguita' possibile e' fra i due
   //    lati dell'esaurimento.
   if(eL && eS){ s.ambiguo=true; return; }

   if(cL){ s.dir=+1; s.ramo=1; return; }
   if(cS){ s.dir=-1; s.ramo=1; return; }
   if(eL){ s.dir=+1; s.ramo=2; return; }
   if(eS){ s.dir=-1; s.ramo=2; return; }
  }

//+------------------------------------------------------------------+
//| PAVIMENTO DI STOP (R109). Se lo stop grezzo e' piu' stretto del   |
//| pavimento, lo si allarga; non lo si stringe mai.                  |
//+------------------------------------------------------------------+
double SlFloor_Calc(const bool isLong,const double entry,
                    const double slGrezzo,const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R>=pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE (per i log).      |
//+------------------------------------------------------------------+
double PrezzoInPuntiIndice_Calc(const double distPrezzo,
                                const double mt5PerIdx,const double point)
  {
   double den = mt5PerIdx*point;
   if(den<=0) return(0);
   return(distPrezzo/den);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- DIVIETO B0, e qui non e' una promessa: e' un rifiuto.
   if(InpModoAttivazione!=0)
     {
      Print("ERRORE: InpModoAttivazione deve essere 0 (SOLO HV Spike). La modalita' 'Market Sessions' della fonte NON e' implementata: e' un ORB, e l'ORB e' chiuso in casa con ~210 celle a tick (R45 0/48, R12 48/48 negative). Divieto B0 della bozza HVANCHOR_M30_BOZZA.txt.");
      return(INIT_FAILED);
     }
   if(InpHvLen<2)
     { Print("ERRORE: InpHvLen deve essere >= 2 (e' la finestra della deviazione standard)."); return(INIT_FAILED); }
   if(InpHvLookback<10)
     { Print("ERRORE: InpHvLookback deve essere >= 10: sotto, il 'percentile' non e' un percentile."); return(INIT_FAILED); }
   if(InpHvSoglia<=0 || InpHvSoglia>=100)
     { Print("ERRORE: InpHvSoglia deve stare fra 0 e 100 (esclusi): e' un percentile. A 0 o 100 non si attraverserebbe mai."); return(INIT_FAILED); }
   if(InpAncoraBarre<1)
     { Print("ERRORE: InpAncoraBarre deve essere >= 1. Un'ancora senza scadenza e' il difetto della fonte, non una scelta."); return(INIT_FAILED); }
   if(!InpUsaRamoContinuazione && !InpUsaRamoEsaurimento)
     { Print("ERRORE: entrambi i rami sono spenti: il motore non potrebbe mai decidere niente."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati sono spenti: l'EA non potrebbe mai operare."); return(INIT_FAILED); }
   if(InpStopAtr<=0)
     { Print("ERRORE: InpStopAtr deve essere > 0. Un ingresso senza stop non si testa."); return(INIT_FAILED); }
   if(InpAtrLen<2)
     { Print("ERRORE: InpAtrLen deve essere >= 2."); return(INIT_FAILED); }
   //--- R109: il pavimento dello stop NON puo' essere zero.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0 (indici BCM: 100)."); return(INIT_FAILED); }
   if(InpRR<=0)
     { Print("ERRORE: InpRR deve essere > 0."); return(INIT_FAILED); }
   if(InpBEatR<0)
     { Print("ERRORE: InpBEatR non puo' essere negativo (0 = breakeven spento)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0. Il lotto fisso qui non esiste."); return(INIT_FAILED); }
   if(InpMaxSpreadPctOfStop<=0)
     { Print("ERRORE: InpMaxSpreadPctOfStop deve essere > 0 (R55: il cancello di spread e' in % dello stop)."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpOraInizio<0 || InpOraInizio>23 || InpMinInizio<0 || InpMinInizio>59)
     { Print("ERRORE: ora/minuto di inizio finestra fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpOraFine<0 || InpOraFine>23 || InpMinFine<0 || InpMinFine>59)
     { Print("ERRORE: ora/minuto di fine finestra fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpOraFlat<0 || InpOraFlat>23 || InpMinFlat<0 || InpMinFlat>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpOraInizio,InpMinInizio) >= MinutiDelGiorno_Calc(InpOraFine,InpMinFine))
     { Print("ERRORE: la finestra NON attraversa la mezzanotte: l'inizio deve precedere la fine."); return(INIT_FAILED); }
   if(InpUsaFlatSeduta && MinutiDelGiorno_Calc(InpOraFine,InpMinFine) >= MinutiDelGiorno_Calc(InpOraFlat,InpMinFlat))
     { Print("ERRORE: il flat deve venire DOPO l'ultimo ingresso ammesso, altrimenti si apre e si chiude nello stesso istante."); return(INIT_FAILED); }

   gAtrH = iATR(_Symbol, gTF, InpAtrLen);
   if(gAtrH==INVALID_HANDLE)
     { Print("ERRORE: handle ATR non creato."); return(INIT_FAILED); }

   gBarraValutata  = -1;
   SpegniAncora(false);
   gTicketCorrente = 0;
   gRischioPrezzo  = 0.0;
   gBEfatto        = false;
   gGiornoStamp    = -1;
   gTradeOggi      = 0;

   Log(StringFormat("avviato su %s %s. CONFIG IN USO -> attivazione: SOLO HV (percentile di stdev(log-rend,%d) su %d barre, soglia %.1f, ATTRAVERSAMENTO) | ancora: %d barre valutate%s | rami: continuazione=%s esaurimento=%s | lati=%s | finestra ingressi %02d:%02d-%02d:%02d SERVER | flat=%s %02d:%02d SERVER | SL=%.2f x ATR(%d) | pavimento SL %d pti indice (x%.0f MT5) | TP=%.2fR | BE=%.2fR | rischio=%.2f%% | spread max %.2f%% dello stop | tetto giorno=%d | magic %I64d",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpHvLen, InpHvLookback, InpHvSoglia,
       InpAncoraBarre, (InpAncoraSoloOggi ? " + muore col giorno" : " (sopravvive al cambio giorno)"),
       (InpUsaRamoContinuazione ? "ON" : "OFF"), (InpUsaRamoEsaurimento ? "ON" : "OFF"),
       (InpAllowLong && InpAllowShort ? "long+short" : (InpAllowLong ? "SOLO LONG" : "SOLO SHORT")),
       InpOraInizio, InpMinInizio, InpOraFine, InpMinFine,
       (InpUsaFlatSeduta ? "ON" : "OFF"), InpOraFlat, InpMinFlat,
       InpStopAtr, InpAtrLen, InpMinStopPts, InpMT5PerPuntoIndice,
       InpRR, InpBEatR, InpRiskPercent, InpMaxSpreadPctOfStop,
       InpMaxTradesPerDay, InpMagic));
   Log("RICORDA: gli orari sono quelli del SERVER (BCM = ora italiana - 1). Un'ora sbagliata non da' errore: misura un'altra strategia.");
   Log("NOTA DI LETTURA: su M30 un lookback di 252 barre vale ~5-6 sedute, NON un anno (252 e' un numero da grafico giornaliero). Il percentile misura la volatilita' rispetto all'ULTIMA SETTIMANA.");
   Log("NOTA SUI RAMI: con continuazione E esaurimento accesi, gli INGRESSI di esaurimento sono ~0 PER COSTRUZIONE (la continuazione arriva prima e consuma l'ancora), esattamente come nella fonte. Per misurare l'esaurimento serve InpUsaRamoContinuazione=false.");
   Log("Questo motore NON usa il volume: il limite noto n.1 di ABTG_LVNArbitro (tick volume sui CFD) qui NON si applica.");
   Log("Ingresso SINGOLO a mercato, una posizione per magic, stop VERO allegato all'ordine. Nessuna aggiunta, media, griglia, recovery o piramidazione.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(gAtrH!=INVALID_HANDLE)
     {
      IndicatorRelease(gAtrH);
      gAtrH = INVALID_HANDLE;
     }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   GestisciBreakeven();                 // la gestione della posizione viva NON passa dal Guardian

   if(FlatFineSedutaCheck()) return;    // fine seduta: chiudo, niente overnight

   if(!IsNewBar()) return;              // le DECISIONI solo a barra chiusa

   ValutaBarra();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t<=0) return(false);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//==================================================================
//  IL MOTORE, lato terminale
//==================================================================

//+------------------------------------------------------------------+
//| Spegne l'ancora. 'contaScaduta' distingue una morte per scadenza  |
//| (che va nel CSV: dice quante ancore non hanno mai prodotto        |
//| niente) da un semplice azzeramento di stato.                      |
//+------------------------------------------------------------------+
void SpegniAncora(const bool contaScaduta)
  {
   if(contaScaduta && gAncViva && !gAncUsata) gCntAncScadute++;
   gAncViva      = false;
   gAncHigh      = 0.0;  gAncLow   = 0.0;
   gLiv100Up     = 0.0;  gLiv100Dn = 0.0;
   gLiv50Up      = 0.0;  gLiv50Dn  = 0.0;
   gAncEta       = 0;
   gAncGiorno    = -1;
   gExtUp        = false; gExtDn = false;
   gAncUsata     = false;
   gVistoContUp  = false; gVistoContDn  = false;
   gVistoEsaurUp = false; gVistoEsaurDn = false;
  }

//+------------------------------------------------------------------+
//| Si valuta la barra allo SHIFT 1 (appena chiusa) e, se il motore   |
//| ha deciso, si entra a mercato adesso: cioe' all'apertura della    |
//| barra successiva. Niente look-ahead, niente repaint.              |
//+------------------------------------------------------------------+
void ValutaBarra()
  {
   datetime t1 = iTime(_Symbol, gTF, 1);
   if(t1<=0) return;

   //--- UNA SOLA VALUTAZIONE PER BARRA: si timbra PRIMA di qualunque
   //    invio, cosi' un rifiuto del broker non fa un secondo tentativo.
   long stamp = (long)t1;
   if(gBarraValutata==stamp) return;
   gBarraValutata = stamp;

   //--- la finestra si giudica sull'ORA DI INGRESSO (adesso), non
   //    sull'ora della barra di segnale.
   //    >>> Fuori finestra NON si valuta NIENTE: quindi non nascono
   //        ancore, e le ancore vive non invecchiano. E' dichiarato
   //        in testa al file: la finestra costa frequenza.
   MqlDateTime dNow; TimeToStruct(TimeCurrent(),dNow);
   if(!DentroFinestra_Calc(dNow.hour,dNow.min,InpOraInizio,InpMinInizio,InpOraFine,InpMinFine))
     { gCntFuoriOrario++; return; }

   gCntBarre++;

   //--- l'ancora muore col cambio di giorno server (scelta di casa:
   //    un'ancora di ieri che spara sul gap di stamattina non e'
   //    questo motore, e' un altro).
   if(InpAncoraSoloOggi && gAncViva && gAncGiorno>=0 && dNow.day_of_year!=gAncGiorno)
      SpegniAncora(true);

   //--- storico: servono InpHvLookback + InpHvLen + 2 chiusure per il
   //    percentile di QUESTA barra e di quella PRECEDENTE.
   int need = InpHvLookback + InpHvLen + 2;
   int totali = Bars(_Symbol,gTF);
   if(totali < need + InpAtrLen + 5){ gCntNoDati++; return; }

   double cl[];
   if(CopyClose(_Symbol,gTF,1,need,cl) < need){ gCntNoDati++; return; }

   //--- hv per gli shift 1..lookback+1 (servono i due percentili)
   double hv[];
   if(!HvSerie_Calc(cl,need,InpHvLen,InpHvLookback+1,hv)){ gCntNoDati++; return; }

   double pctOra   = Percentile_Calc(hv,0,InpHvLookback);   // barra allo shift 1
   double pctPrima = Percentile_Calc(hv,1,InpHvLookback);   // barra allo shift 2
   if(pctOra<0 || pctPrima<0){ gCntNoDati++; return; }

   double h1 = iHigh (_Symbol,gTF,1);
   double l1 = iLow  (_Symbol,gTF,1);
   double c1 = iClose(_Symbol,gTF,1);
   if(h1<=0 || l1<=0 || c1<=0 || h1<l1){ gCntNoDati++; return; }

   //--- ATTIVAZIONE: l'evento CREA l'ancora e sostituisce la vecchia
   //    (fedelta': nella fonte l'attivazione riscrive sempre tutto).
   //    Sulla barra-evento NON si entra mai: il 100% e' per
   //    costruzione oltre la sua chiusura.
   //    >>> Se la barra-evento fosse PIATTA (h==l) non avrebbe un
   //        metro: nessuna ancora, e si prosegue con quella vecchia
   //        invece di perdere la barra.
   double u100=0,d100=0,u50=0,d50=0;
   if(Attivazione_Calc(pctOra,pctPrima,InpHvSoglia) &&
      LivelliAncora_Calc(h1,l1,u100,d100,u50,d50))
     {
      SpegniAncora(true);                 // la vecchia muore qui, e si conta
      gAncViva   = true;
      gAncHigh   = h1;  gAncLow = l1;
      gLiv100Up  = u100; gLiv100Dn = d100;
      gLiv50Up   = u50;  gLiv50Dn  = d50;
      gAncEta    = 0;
      gAncGiorno = dNow.day_of_year;
      gCntAncore++;
      Log(StringFormat("ANCORA creata: percentile HV %.1f (prima %.1f, soglia %.1f) | range %.1f pti indice | ancora %s-%s | 100%%: su %s giu' %s | 50%% (solo disegno, non e' una condizione): su %s giu' %s",
          pctOra, pctPrima, InpHvSoglia,
          PrezzoInPuntiIndice_Calc(h1-l1,InpMT5PerPuntoIndice,_Point),
          DoubleToString(l1,_Digits), DoubleToString(h1,_Digits),
          DoubleToString(gLiv100Up,_Digits), DoubleToString(gLiv100Dn,_Digits),
          DoubleToString(gLiv50Up,_Digits),  DoubleToString(gLiv50Dn,_Digits)));
      return;
     }

   if(!gAncViva) return;

   //--- l'ancora invecchia solo sulle barre VALUTATE
   gAncEta++;
   if(gAncEta > InpAncoraBarre)
     {
      SpegniAncora(true);
      return;
     }

   //--- il motore
   SegnaleHV s;
   bool extUpDopo, extDnDopo;
   Motore_Calc(c1,gAncHigh,gAncLow,gLiv100Up,gLiv100Dn,
               gExtUp,gExtDn,
               InpUsaRamoContinuazione,InpUsaRamoEsaurimento,
               s,extUpDopo,extDnDopo);
   gExtUp = extUpDopo;
   gExtDn = extDnDopo;

   //--- contatori delle OCCASIONI: una volta per ancora e per tipo,
   //    a prescindere dagli interruttori e dal fatto che l'ancora
   //    abbia gia' operato. E' il PASSO 0.
   if(s.contLong   && !gVistoContUp ){ gVistoContUp =true; gCntContLong++;  }
   if(s.contShort  && !gVistoContDn ){ gVistoContDn =true; gCntContShort++; }
   if(s.esaurLong  && !gVistoEsaurDn){ gVistoEsaurDn=true; gCntEsaurLong++; }
   if(s.esaurShort && !gVistoEsaurUp){ gVistoEsaurUp=true; gCntEsaurShort++;}

   //--- UNA SOLA OPERAZIONE PER ANCORA (fonte: tradeTaken). Il
   //    segnale e' gia' stato contato: qui si rinuncia solo a operarlo.
   if(gAncUsata)
     {
      if(s.dir!=0 || s.ambiguo) gCntAncUsata++;
      return;
     }

   //--- UNA POSIZIONE PER MAGIC.
   if(HoPosizione())
     {
      if(s.dir!=0 || s.ambiguo) gCntGiaAperta++;
      return;
     }

   if(s.ambiguo){ gCntAmbiguo++; return; }
   if(s.dir==0)
     {
      //--- c'era un'occasione grezza ma il suo RAMO e' spento?
      bool cEraQualcosa = (s.contLong || s.contShort || s.esaurLong || s.esaurShort);
      if(cEraQualcosa) gCntRamoNo++;
      return;
     }

   if(s.dir>0 && !InpAllowLong ){ gCntLatoNo++; return; }
   if(s.dir<0 && !InpAllowShort){ gCntLatoNo++; return; }

   //--- tetto giornaliero (0 = illimitato, come la fonte)
   if(InpMaxTradesPerDay>0)
     {
      if(dNow.day_of_year != gGiornoStamp){ gGiornoStamp = dNow.day_of_year; gTradeOggi = 0; }
      if(gTradeOggi >= InpMaxTradesPerDay){ gCntTettoGiorno++; return; }
     }

   double atr = AtrShift(1);
   if(atr<=0){ gCntNoDati++; return; }

   if(Entra(s.dir>0, atr, s.ramo))
      gAncUsata = true;                  // l'ancora si consuma SOLO se l'ordine e' passato
  }

//+------------------------------------------------------------------+
//| ATR allo shift richiesto (barra CHIUSA).                          |
//+------------------------------------------------------------------+
double AtrShift(const int shift)
  {
   if(gAtrH==INVALID_HANDLE) return(0);
   double a[1];
   if(CopyBuffer(gAtrH,0,shift,1,a)<1) return(0);
   return(a[0]);
  }

//+------------------------------------------------------------------+
//| INGRESSO A MERCATO con STOP VERO allegato all'ordine.             |
//| Nessun ingresso senza stop, mai. E' il difetto della fonte -- li' |
//| lo stop non esiste proprio (punto (1) dell'intestazione) -- che   |
//| qui non puo' esistere.                                            |
//+------------------------------------------------------------------+
bool Entra(const bool isLong,const double atr,const int ramo)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ gCntReject++; Log("prezzi non disponibili: salto."); return(false); }

   double point    = _Point;
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double pav      = MathMax((double)InpMinStopPts*InpMT5PerPuntoIndice*point, stopsLvl);
   if(pav<=0){ gCntReject++; Log("pavimento SL nullo: salto (R109)."); return(false); }

   double entry = isLong ? ask : bid;

   //--- STOP dalla fonte: InpStopAtr x ATR della barra di segnale.
   double slGrezzo = isLong ? (entry - InpStopAtr*atr) : (entry + InpStopAtr*atr);
   double slFinal  = SlFloor_Calc(isLong, entry, slGrezzo, pav);
   double slDist   = isLong ? (entry-slFinal) : (slFinal-entry);
   if(slDist<=0){ gCntReject++; Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- GATE DI SPREAD IN % DELLO STOP (R55): un cancello in punti
   //    fissi mente cambiando simbolo, questo no.
   double spreadPrezzo = ask-bid;
   if(spreadPrezzo > (InpMaxSpreadPctOfStop/100.0)*slDist)
     {
      gCntReject++;
      Log(StringFormat("spread %.1f pti indice = oltre il %.2f%% dello stop (%.1f pti indice): salto.",
          PrezzoInPuntiIndice_Calc(spreadPrezzo,InpMT5PerPuntoIndice,point),
          InpMaxSpreadPctOfStop,
          PrezzoInPuntiIndice_Calc(slDist,InpMT5PerPuntoIndice,point)));
      return(false);
     }

   double tp = isLong ? (entry + InpRR*slDist) : (entry - InpRR*slDist);

   double sP = NormalizePrice(slFinal);
   double tP = NormalizePrice(tp);

   //--- lo stops-level e' gia' dentro il pavimento; il TP lo si
   //    controlla comunque, perche' InpRR potrebbe essere piccolo.
   if(MathAbs(tP-entry) < stopsLvl)
     {
      tP = isLong ? (entry+stopsLvl) : (entry-stopsLvl);
      tP = NormalizePrice(tP);
     }

   double lot = LotByRisk(slDist);
   if(lot<=0){ gCntReject++; Log("lotto nullo (rischio troppo piccolo o simbolo non calcolabile): salto."); return(false); }

   //--- GUARDIAN: IMMEDIATAMENTE prima dell'invio, mai in cima
   //    all'imbuto (regola del referto di migrazione, par. 1.3).
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_HVAncora"))
     { gCntGuardian++; return(false); }

   string tag = (ramo==1 ? " CON" : " ESA");
   string cm  = InpComment + tag + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sP,tP,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sP,tP,cm);
   if(!ok)
     {
      gCntReject++;
      Log(StringFormat("ingresso %s FALLITO: %s (retcode %d)",
          (isLong?"BUY":"SELL"), gTrade.ResultRetcodeDescription(), (int)gTrade.ResultRetcode()));
      return(false);
     }

   if(isLong) gCntLong++; else gCntShort++;
   if(InpMaxTradesPerDay>0) gTradeOggi++;
   ContaRaffica();

   Log(StringFormat("%s ramo %s: lot %.2f | SL %s | TP %s | rischio %.1f pti indice | ATR %.1f pti indice | ancora %s-%s (eta' %d barre)",
       (isLong?"BUY":"SELL"),
       (ramo==1 ? "CONTINUAZIONE (estensione 100%)" : "ESAURIMENTO (estensione fallita, rientro)"),
       lot, DoubleToString(sP,_Digits), DoubleToString(tP,_Digits),
       PrezzoInPuntiIndice_Calc(slDist,InpMT5PerPuntoIndice,point),
       PrezzoInPuntiIndice_Calc(atr,InpMT5PerPuntoIndice,point),
       DoubleToString(gAncLow,_Digits), DoubleToString(gAncHigh,_Digits), gAncEta));
   return(true);
  }

//+------------------------------------------------------------------+
//| RAFFICA: massimo ingressi in un giorno e in 7 giorni.             |
//| Cancello C6 della bozza: gli attraversamenti di percentile si     |
//| RAGGRUPPANO (la volatilita' e' persistente), quindi la media non  |
//| descrive questo motore. La settimana e' una finestra fissa di 7   |
//| giorni allineata all'epoca, non la settimana di calendario: serve |
//| a misurare la raffica, non a fare un calendario.                  |
//+------------------------------------------------------------------+
void ContaRaffica()
  {
   //--- contatore INDIPENDENTE da quello del tetto giornaliero, che
   //    esiste solo quando il tetto e' acceso. Qui si misura sempre.
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   if(n.day_of_year != gGiornoRaffica){ gGiornoRaffica = n.day_of_year; gTradeGiorno = 0; }
   gTradeGiorno++;
   if(gTradeGiorno > gMaxTradeGiorno) gMaxTradeGiorno = gTradeGiorno;

   int sett = (int)(TimeCurrent()/(7*86400));
   if(sett != gSettStamp){ gSettStamp = sett; gTradeSettimana = 0; }
   gTradeSettimana++;
   if(gTradeSettimana > gMaxTradeSettimana) gMaxTradeSettimana = gTradeSettimana;
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE VIVA
//==================================================================

//+------------------------------------------------------------------+
//| BREAKEVEN a InpBEatR volte R, come MODIFICA dell'ordine: non      |
//| chiude niente, non tocca il TP. Una volta sola per posizione.     |
//| DEFAULT SPENTO (0): la fonte non ce l'ha, e il primo round misura |
//| il motore nudo. Acceso e' un asse in piu' da girare, non un       |
//| miglioramento gia' dimostrato.                                    |
//|                                                                   |
//| NIENTE PARZIALI, ed e' una scelta dichiarata: una posizione, una  |
//| tranche. Il difetto del lotto in tranche corretto in 15 sorgenti  |
//| (report/FIX_LOTTO_PENDENTE_2026-09-08.md) qui non puo' nemmeno    |
//| presentarsi.                                                      |
//+------------------------------------------------------------------+
void GestisciBreakeven()
  {
   if(InpBEatR<=0) return;

   ulong tk = TicketMio();
   if(tk==0){ gTicketCorrente=0; gRischioPrezzo=0.0; gBEfatto=false; return; }

   double apert = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl    = PositionGetDouble(POSITION_SL);
   double tp    = PositionGetDouble(POSITION_TP);
   long   tipo  = PositionGetInteger(POSITION_TYPE);
   bool   isLong = (tipo==POSITION_TYPE_BUY);

   if(tk!=gTicketCorrente)
     {
      gTicketCorrente = tk;
      gRischioPrezzo  = isLong ? (apert-sl) : (sl-apert);
      //--- se lo stop e' gia' a pari (o oltre) il BE e' gia' stato fatto
      gBEfatto = (gRischioPrezzo<=0);
     }
   if(gBEfatto || gRischioPrezzo<=0) return;

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return;

   double avanzamento = isLong ? (bid-apert) : (apert-ask);
   if(avanzamento < InpBEatR*gRischioPrezzo) return;

   //--- lo stop nuovo deve rispettare lo stops-level, altrimenti il
   //    broker rifiuta: se non ci sta ancora, si riprova al tick dopo.
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(isLong  && apert > bid-stopsLvl) return;
   if(!isLong && apert < ask+stopsLvl) return;

   double nuovoSL = NormalizePrice(apert);
   if(gTrade.PositionModify(tk,nuovoSL,tp))
     {
      gBEfatto = true;
      gCntBE++;
      Log(StringFormat("BREAKEVEN a %.2fR: stop portato a pari (%s). Nessuna chiusura, il TP resta.",
          InpBEatR, DoubleToString(nuovoSL,_Digits)));
     }
   else
      Log("breakeven FALLITO: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA: zero overnight. E' la parte che il sorgente  |
//| esterno non aveva (il Pine tiene la posizione finche' non prende  |
//| stop o target -- che li' NON ESISTONO -- quindi per sempre).      |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   if(!InpUsaFlatSeduta) return(false);

   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpOraFlat,InpMinFlat)) return(false);

   int chiuse=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(p)) chiuse++;
      else Log("flat di fine seduta: chiusura FALLITA - "+gTrade.ResultRetcodeDescription());
     }
   gFlatChiusure += chiuse;

   if(chiuse>0 && t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
                       InpOraFlat, InpMinFlat, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//| Colonna prop: il muro giornaliero non si legge dal DD totale.     |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;
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

//+------------------------------------------------------------------+
//| LOTTO DAL RISCHIO, in UNA SOLA TRANCHE.                           |
//|  Il difetto del 08/09 (pavimento del lotto minimo applicato DOPO  |
//|  il calcolo della seconda tranche, che raddoppiava il volume) qui |
//|  NON PUO' esistere: non c'e' nessuna seconda tranche.             |
//|  Perdita per lotto chiesta al BROKER (OrderCalcProfit converte in |
//|  valuta conto); il tick value resta come ripiego, perche' su certi|
//|  simboli arriva non convertito e il lotto uscirebbe al minimo.    |
//+------------------------------------------------------------------+
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   if(risk<=0) return(0);

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

//+------------------------------------------------------------------+
//| Il ticket della MIA posizione sul simbolo (hedge-safe: simbolo +  |
//| magic, mai PositionSelect(_Symbol) che prende la prima qualunque).|
//| Se ritorna != 0 la posizione e' anche SELEZIONATA.                |
//+------------------------------------------------------------------+
ulong TicketMio()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return(tk);
     }
   return(0);
  }

bool HoPosizione(){ return(TicketMio()!=0); }

//==================================================================
//  OPTFRAME (incorporato) - raccolta risultati -> CSV
//  L'EA deve avere OnTester: senza, il driver rifiuta di partire.
//==================================================================
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE nella cartella COMUNE: una riga per posizione    |
//| chiusa. Serve al DD di PORTAFOGLIO e alla misura della            |
//| sovrapposizione con le sedie vive.                                |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","comment");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
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
                DoubleToString(net,2),
                HistoryDealGetString(tk,DEAL_COMMENT));
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[24];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne "va bene per una prop?"
   stats[7] = gWorstDayPct;
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);
   //--- DIAGNOSTICA: e' il PASSO 0 letto dal CSV. I DUE RAMI E I DUE
   //    LATI SONO SEPARATI apposta (cancelli C4/C5 della bozza).
   //    L'ordine QUI e l'intestazione in OnTesterDeinit si toccano
   //    SEMPRE INSIEME.
   stats[10] = (double)gCntBarre;
   stats[11] = (double)gCntAncore;
   stats[12] = (double)gCntContLong;
   stats[13] = (double)gCntContShort;
   stats[14] = (double)gCntEsaurLong;
   stats[15] = (double)gCntEsaurShort;
   stats[16] = (double)gCntLong;
   stats[17] = (double)gCntShort;
   stats[18] = (double)gCntReject;
   stats[19] = (double)gCntGuardian;
   stats[20] = (double)gFlatChiusure;
   //--- la RAFFICA: su questo candidato la media non descrive niente
   stats[21] = (double)gMaxTradeGiorno;
   stats[22] = (double)gMaxTradeSettimana;
   stats[23] = (double)gCntAncScadute;

   PrintFormat("[HVA][DIAG] barre=%I64d | ancore=%I64d scadute=%I64d | contL=%I64d contS=%I64d esaurL=%I64d esaurS=%I64d | ambiguo=%I64d ramoNo=%I64d latoNo=%I64d ancUsata=%I64d | long=%I64d short=%I64d | reject=%I64d guardian=%I64d BE=%I64d flat=%I64d noDati=%I64d giaAperta=%I64d fuoriOrario=%I64d tettoGiorno=%I64d | maxTradeGiorno=%d maxTradeSettimana=%d",
               gCntBarre, gCntAncore, gCntAncScadute,
               gCntContLong, gCntContShort, gCntEsaurLong, gCntEsaurShort,
               gCntAmbiguo, gCntRamoNo, gCntLatoNo, gCntAncUsata,
               gCntLong, gCntShort, gCntReject, gCntGuardian, gCntBE,
               gFlatChiusure, gCntNoDati, gCntGiaAperta, gCntFuoriOrario, gCntTettoGiorno,
               gMaxTradeGiorno, gMaxTradeSettimana);

   double criterion = stats[3];     // Recovery Factor (robusto), come gli altri EA di casa
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Barre Valutate,Ancore,Cont Long,Cont Short,Esaur Long,Esaur Short,Long,Short,Reject,Guardian,Flat Chiusure,Max Trade Giorno,Max Trade Settimana,Ancore Scadute";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12], data[13], data[14],
                                data[15], data[16], data[17], data[18], data[19],
                                data[20], data[21], data[22], data[23]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
