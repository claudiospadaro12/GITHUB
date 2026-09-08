//+------------------------------------------------------------------+
//|                                        ABTG_IBRetest.mq5          |
//|                                                                  |
//|  ROTTURA DELL'INITIAL BALANCE -> RITORNO -> FALLIMENTO DEL        |
//|  RITORNO.  Macchina a TRE STATI, DUE LATI. MT5, TUTTO-IN-UNO.     |
//|  (metti in MQL5\Experts e compila con F7: serve solo              |
//|   Include\ABTG_PausaGuardian.mqh, gia' in casa)                   |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria - e qui la licenza MANCA)            |
//|    Meccanica derivata da "IB Completed" di Genxtraders            |
//|    (TradingView, slug Z1CwMI6V, creato 25/08/2026, Pine v6,       |
//|    1.092 righe, 124 input, scriptAccess "open_no_auth"            |
//|    VERIFICATO l'08/09/2026).                                      |
//|      https://www.tradingview.com/script/Z1CwMI6V-IB-Completed/    |
//|    LICENZA DEL SORGENTE: [INCERTO] -- il sorgente NON ha nessuna   |
//|    intestazione di licenza, ne' MPL ne' altro. "Open_no_auth"     |
//|    vuol dire SORGENTE LEGGIBILE, non "licenza permissiva".        |
//|    >>> CONSEGUENZA OPERATIVA, e va rispettata: NON si copia una    |
//|        riga. Il sorgente e' stato LETTO riga per riga e questo     |
//|        .mq5 e' scritto DA SPECIFICA, in codice nostro. Se un       |
//|        domani l'autore dichiarasse una licenza restrittiva, qui    |
//|        non c'e' niente di suo da rimuovere: c'e' una MECCANICA,    |
//|        che non e' copiabile ne' proteggibile come testo.           |
//|    Copia archiviata in casa (per riproducibilita', non per uso):   |
//|      backtest_pipeline\caccia_strategie\biblioteca\sorgenti\      |
//|      IbCompleted_Genxtraders-NOLICENSE_tvZ1CwMI6V_2026-09-08.pine |
//|    SPEC congelata: backtest_pipeline\prove\IBRETEST_M30_BOZZA.txt  |
//|    DOSSIER:        report\CACCIA_M30_INDICI_2026-09-08.md (P1 9/10)|
//|    REFERTO:        report\EA_IB_RETEST_2026-09-08.md              |
//|                                                                  |
//|  COS'E' - LA ROTTURA NON E' UN INGRESSO, E' IL PASSO 1 DI 3.      |
//|    S1 ROTTURA     il prezzo esce dall'Initial Balance             |
//|    S2 RITORNO     torna a toccare il livello rotto E chiude       |
//|                   dalla parte SBAGLIATA della SMA di innesco      |
//|    S3 FALLIMENTO  richiude oltre il livello E oltre la SMA        |
//|                   -> SI ENTRA, NELLA DIREZIONE DELLA ROTTURA      |
//|    Chi ha comprato la rottura viene riportato sul livello, si      |
//|    convince di essere in trappola, e quando il livello cede di     |
//|    nuovo e' LUI a doverlo vendere: il secondo passaggio ha dietro  |
//|    liquidita' forzata, il primo no.                               |
//|                                                                  |
//|  PERCHE' NON E' L'ORB (che in casa e' morto: ~210 celle a tick,    |
//|  R45 0/48, R12 48/48 negative): l'ORB entra al passo 1. Qui il     |
//|  passo 1 non e' un ingresso e, se il passo 2 non arriva, NON SI    |
//|  ENTRA AFFATTO. Sulla stessa seduta i due prendono operazioni      |
//|  diverse o nessuna. E non e' nemmeno il CRT / Turtle Soup          |
//|  (0/30 celle): quelli entrano CONTRO la rottura, qui NELLA         |
//|  direzione. Segno opposto.                                        |
//|                                                                  |
//|  ##### LA LEZIONE DELLA SERA DELL'08/09, SCRITTA IN TESTA #####    |
//|    Stasera sono stati chiusi due motori sul VPS:                  |
//|      - ABTG_OpeningReversalB: 2 operazioni in 21 mesi. Morto di    |
//|        FREQUENZA (tre cancelli di conferma in serie).             |
//|      - ABTG_LVNArbitro: 1.010 operazioni (frequenza ottima) ma     |
//|        DD 19,35% / 11,76% contro un muro del 10%, a DUE taglie di  |
//|        conto. Sull'OOS faceva +11,31% su 100k -- cioe' superava    |
//|        il target -- ma avrebbe sfondato il muro PRIMA di           |
//|        arrivarci. E la peggior giornata era solo -2,80%.           |
//|    >>> Su M30 sugli indici non si muore di singola giornata: si    |
//|        muore di DRAWDOWN CUMULATO, per erosione lunga. Un motore   |
//|        che macina 600 operazioni con PF 1,05 muore di costi.       |
//|    Da qui le due scelte di questo file:                           |
//|      (a) InpMaxTradesPerDay ESISTE ed e' a 1 (vedi sotto);        |
//|      (b) la diagnostica misura DD-per-giorno, mediana dello stop   |
//|          in punti indice e QUANTE VOLTE IL LOTTO E' FINITO AL      |
//|          MINIMO -- perche' un DD che mescola motore e pavimento    |
//|          del lotto non e' un numero (verdetto LVNArbitro).         |
//|    ### E CIO' CHE NON HO MESSO, DICHIARATO: nessun tetto di        |
//|        perdita giornaliera/settimanale INTERNO. La fonte non ce    |
//|        l'ha, sarebbe un meccanismo NUOVO e NON MISURATO infilato   |
//|        dentro un porting. Sta come PROPOSTA SEPARATA nel referto.  |
//|                                                                  |
//|  PROP-HARDENING (di casa, NON della fonte)                        |
//|    - STOP VERO AL BROKER, dentro l'ordine di mercato. Mai dopo.    |
//|      NOTA sulla fonte, verificata per prima come chiede la regola  |
//|      di casa: qui il baco Pine dei 3 sorgenti su 13 NON C'E'.      |
//|      "IB Completed" calcola stop e size da variabili PROPRIE       |
//|      (L_entryPrice / L_stopPrice) dentro lo stesso blocco          |
//|      dell'ingresso, NON da strategy.position_avg_price. L'unico    |
//|      uso di position_avg_price e' nel breakeven, che gira quando   |
//|      la posizione esiste gia': e' corretto. Lo scrivo perche' il   |
//|      controllo e' stato fatto, non perche' fosse scontato.        |
//|    - PAVIMENTO DI STOP InpMinStopPts (R109) in PUNTI INDICE, mai   |
//|      zero: OnInit rifiuta.                                        |
//|    - GATE DI SPREAD IN % DELLO STOP (R55): un cancello in punti    |
//|      fissi mente cambiando simbolo, questo no.                    |
//|    - FLAT DI FINE SEDUTA in ORA SERVER: zero overnight (la fonte   |
//|      ce l'ha gia', ed e' uno dei motivi per cui e' stata promossa).|
//|    - RISCHIO IN % dell'equity, MAI importo fisso in valuta come    |
//|      la fonte, MAI lotto fisso. UNA POSIZIONE, UNA TRANCHE: il     |
//|      difetto del lotto in tranche corretto l'08/09 in 15 sorgenti  |
//|      (report\FIX_LOTTO_PENDENTE_2026-09-08.md) qui non puo'        |
//|      nemmeno presentarsi, perche' seconda tranche non ce n'e'.     |
//|    - GUARDIAN (firme B1/C1 del 18/08) IMMEDIATAMENTE prima         |
//|      dell'invio, mai in cima all'imbuto.                          |
//|    - NIENTE martingala, griglia, recovery, averaging,             |
//|      piramidazione, stop virtuali. Ingresso SINGOLO.              |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. Il server BCM e' ORA ITALIANA - 1.        |
//|    TUTTI gli orari qui sono in ORA SERVER. Sbagliarli non da'      |
//|    errore: MISURA UN'ALTRA STRATEGIA (CLAUDE.md, regola fissa).    |
//|      U30USD / NASUSD: apertura USA 15:30 IT = 14:30 SERVER,        |
//|                       quindi IB 14:30-15:30 SERVER.               |
//|      D30EUR        : apertura 09:00 IT = 08:00 SERVER,            |
//|                       quindi IB 08:00-09:00 SERVER.               |
//|    Un CSV con InpIbInizioOra = 15 (o 9) e' DA CESTINARE.          |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. La barra si valuta allo shift 1       |
//|    (appena chiusa) e si entra a mercato adesso, cioe' all'apertura |
//|    della barra successiva. Il pivot serve SOLO allo stop, MAI al   |
//|    grilletto: e' il motivo per cui il ritardo del pivot non        |
//|    ridipinge la decisione. Niente look-ahead.                     |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola     |
//|  di casa: Windows PowerShell 5.1 legge ANSI).                     |
//|  ### NON COMPILATO E NON TESTATO da chi ha scritto il file: qui    |
//|      non c'e' MetaEditor ne' Strategy Tester. Questa e' una        |
//|      REVISIONE STATICA. Compilare in MetaEditor (F7) e far girare  |
//|      il PASSO 0 prima di qualunque verdetto.                      |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG - IB Retest (da specifica; meccanica derivata da IB Completed di Genxtraders, licenza non dichiarata)"
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
input bool   InpUsaGuardian        = true;   // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)

input group "=== INITIAL BALANCE (ORA SERVER BCM = ora italiana - 1) ==="
//  Default = indici USA: 14:30-15:30 SERVER (15:30-16:30 italiane).
//  Per D30EUR: 8 / 0 / 9 / 0. Vedi intestazione: un'ora sbagliata non
//  da' errore, misura un'altra strategia.
input int    InpIbInizioOra        = 14;     // ORA SERVER di inizio dell'Initial Balance
input int    InpIbInizioMin        = 30;     // MINUTO SERVER di inizio dell'Initial Balance
input int    InpIbFineOra          = 15;     // ORA SERVER di fine dell'Initial Balance (esclusa)
input int    InpIbFineMin          = 30;     // MINUTO SERVER di fine dell'Initial Balance (esclusa)

input group "=== MOTORE (default = quelli della fonte) ==="
input int    InpSmaLen             = 9;      // SMA di innesco: e' la SMA del passo 2 e del passo 3 (fonte: 9)
input int    InpPivot              = 2;      // Barre di conferma del pivot, a SINISTRA e a DESTRA (fonte: 2 e 2)
input double InpStopBufferPunti    = 2.0;    // Buffer dello stop OLTRE il pivot, in PUNTI INDICE (fonte: 2,0)
input bool   InpInvalidaSuIbOpposto= false;  // true = il setup si annulla se il prezzo perfora il livello IB OPPOSTO (fonte: false)
input double InpMaxIbPunti         = 0;      // Filtro d'ampiezza IB in PUNTI INDICE (0 = SPENTO, come la fonte)

input group "=== FILTRO DI TENDENZA HTF (nella fonte e' ACCESO, qui NO - vedi commento) ==="
//  E' l'UNICO dei ~60 filtri opzionali della fonte che ho portato, ed
//  e' SPENTO di default anche se la fonte lo ha acceso.
//  Motivo dichiarato: il PASSO 0 misura il MOTORE NUDO. In casa un
//  filtro appiccicato a un motore gia' tarato fa 0 successi su 5
//  (ROBUSTEZZA.md, condizione A). Si accende SOLO se il motore nudo
//  passa, e allora e' un asse da misurare, mai una toppa per salvarlo.
input bool   InpUsaFiltroHTF       = false;  // true = long solo se close > MA HTF, short solo se close < MA HTF
input int    InpHtfMinuti          = 240;    // Timeframe del filtro in MINUTI: 30/60/240/1440 (fonte: 240 = H4)
input int    InpHtfMaLen           = 9;      // Lunghezza della SMA sul timeframe HTF (fonte: 9)

input group "=== LATI (regola di casa dei due lati, 25/08) ==="
input bool   InpAllowLong          = true;   // Consenti il lato LONG
input bool   InpAllowShort         = true;   // Consenti il lato SHORT

input group "=== SESSIONE (ORA SERVER BCM = ora italiana - 1) ==="
input int    InpCutoffOra          = 20;     // ORA SERVER dell'ULTIMO ingresso ammesso
input int    InpCutoffMin          = 0;      // MINUTO SERVER dell'ultimo ingresso ammesso
input bool   InpUsaFlatSeduta      = true;   // true = ZERO overnight (regola di casa). false = SOLO per esperimenti dichiarati
input int    InpGoFlatOra          = 21;     // ORA SERVER del flat di fine seduta
input int    InpGoFlatMin          = 0;      // MINUTO SERVER del flat di fine seduta

input group "=== STOP LOSS (strutturale, vero, al broker; pavimento R109) ==="
input int    InpMinStopPts         = 25;     // PAVIMENTO SL in PUNTI INDICE (MAI 0: OnInit rifiuta)
input double InpMT5PerPuntoIndice  = 100;    // Punti MT5 (_Point) per 1 punto indice (D30EUR/NASUSD/U30USD: 100)

input group "=== USCITA ==="
//  La fonte esce a scaglioni 1R/2R/3R/4R/5R piu' breakeven a 2R.
//  QUI NO, ed e' una scelta dichiarata: una posizione, una tranche.
//  Cinque scaglioni sono cinque manopole in piu' da girare verso il
//  passato. Resta un target unico in R, piu' il breakeven opzionale.
input double InpRR                 = 2.0;    // Take profit = InpRR x rischio (R). Centro della scala della fonte
input double InpBEatR              = 0.0;    // Breakeven a questo R (0 = SPENTO). Con TP a 2R un BE a 2R sarebbe inerte

input group "=== Rischio ==="
input double InpRiskPercent        = 0.65;   // Rischio per trade in % del saldo (contratto di casa: 0,65)
input double InpMaxSpreadPctOfStop = 2.5;    // Gate di spread (R55): spread <= X% dello stop, altrimenti si salta
//  DEFAULT 1, ED E' LA SCELTA PIU' IMPORTANTE DI QUESTO BLOCCO.
//  NON e' un meccanismo nuovo: e' la regola `sessionTradeDone` della
//  fonte (una operazione per seduta, che blocca ENTRAMBI i lati) resa
//  ESPLICITA e MISURABILE invece che nascosta nel codice.
//  Perche' 1 e non 0 (illimitato): la fonte fa cosi', e dopo il
//  verdetto LVNArbitro di stasera (DD cumulato 19,35%/11,76% con 1.010
//  operazioni) il tetto strutturale e' l'unica cosa che tiene basso il
//  numero di operazioni per seduta, cioe' l'erosione.
//  Alzarlo sopra 1 NON fa parte di questo round: sarebbe un altro
//  motore, e andrebbe dichiarato come tale.
input int    InpMaxTradesPerDay    = 1;      // Tetto ingressi per giorno server (1 = come la fonte; 0 = illimitato)

input group "=== Generali ==="
input long   InpMagic              = 772900; // Numero magico (blocco 7729xx: VERIFICATO VERGINE nel repo l'08/09/2026)
input string InpComment            = "IBRT"; // Commento sugli ordini
input bool   InpVerbose            = true;   // Messaggi nel log

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF     = PERIOD_CURRENT;
ENUM_TIMEFRAMES gTfHtf  = PERIOD_H4;

int      gSmaH   = INVALID_HANDLE;
int      gHtfH   = INVALID_HANDLE;
datetime gLastBar= 0;

//--- marcatore della barra gia' VALUTATA: si timbra PRIMA di mandare
//    l'ordine, cosi' un rifiuto del broker NON produce un secondo
//    tentativo sulla stessa barra. Niente inseguimenti.
long     gBarraValutata = -1;

//--- contatore MONOTONO di barre valutate: e' il nostro "bar_index".
//    Serve a confrontare "il ritorno e' avvenuto DOPO la rottura" e
//    "il pivot basso e' DOPO il pivot alto" senza dipendere dagli
//    shift, che scorrono a ogni nuova barra.
long     gSeq = 0;

//--- SEDUTA (tutto azzerato al cambio di giorno SERVER)
int      gGiorno       = -1;
double   gIbHigh       = 0.0;
double   gIbLow        = 0.0;
bool     gIbDati       = false;   // almeno una barra dentro la finestra IB
bool     gIbCompleto   = false;   // la finestra IB e' CHIUSA e ha dati
bool     gIbTroppoGr   = false;   // ampiezza IB oltre InpMaxIbPunti
int      gTradeOggi    = 0;

//--- macchina a stati LATO LONG (rottura VERSO L'ALTO di IB high)
bool     gL_rotto      = false;  long gL_rottoSeq   = -1;
bool     gL_ritorno    = false;  long gL_ritornoSeq = -1;
double   gL_ritornoMin = 0.0;    bool gL_ritornoMinOk = false;
double   gL_pivotAlto  = 0.0;    long gL_pivotAltoSeq = -1;  bool gL_pivotAltoOk = false;
double   gL_pivotBasso = 0.0;    long gL_pivotBassoSeq= -1;  bool gL_pivotBassoOk= false;
bool     gL_fatto      = false;

//--- macchina a stati LATO SHORT (rottura VERSO IL BASSO di IB low)
bool     gS_rotto      = false;  long gS_rottoSeq   = -1;
bool     gS_ritorno    = false;  long gS_ritornoSeq = -1;
double   gS_ritornoMax = 0.0;    bool gS_ritornoMaxOk = false;
double   gS_pivotBasso = 0.0;    long gS_pivotBassoSeq= -1;  bool gS_pivotBassoOk= false;
double   gS_pivotAlto  = 0.0;    long gS_pivotAltoSeq = -1;  bool gS_pivotAltoOk = false;
bool     gS_fatto      = false;

//--- breakeven: una volta sola per posizione, legata al ticket
ulong    gTicketCorrente = 0;
double   gRischioPrezzo  = 0.0;   // R in PREZZO della posizione viva
bool     gBEfatto        = false;

int      gFlatLogGiorno  = -1;

//--- peggior giornata in % (colonna prop)
double   gDayStartEquity = 0.0;
double   gDayMinEquity   = 0.0;
double   gWorstDayPct    = 0.0;
int      gDayEqStamp     = -1;

//--- DIAGNOSTICA (solo misura: e' il PASSO 0 letto dal CSV)
long gCntBarre       = 0;   // barre chiuse valutate con IB gia' completo
long gCntSeduteIB    = 0;   // sedute in cui l'IB si e' formato ed e' stato chiuso
long gCntNoDati      = 0;   // SMA/storico non disponibili
long gCntRotturaL    = 0;   // passo 1 raggiunto, lato long
long gCntRotturaS    = 0;   // passo 1 raggiunto, lato short
long gCntRitornoL    = 0;   // passo 2 raggiunto, lato long
long gCntRitornoS    = 0;   // passo 2 raggiunto, lato short
long gCntSegnaleL    = 0;   // passo 3 GREZZO (prima dei cancelli), lato long
long gCntSegnaleS    = 0;   // passo 3 GREZZO (prima dei cancelli), lato short
long gCntInvalidati  = 0;   // setup annullati dal livello IB opposto
long gCntCutoff      = 0;   // segnali scartati perche' oltre il cutoff / flat
long gCntTettoGiorno = 0;   // barre con rilevazione CONGELATA dal tetto giornaliero
long gCntLatoNo      = 0;   // segnali scartati perche' quel LATO e' spento
long gCntIbGrande    = 0;   // segnali scartati dal filtro d'ampiezza IB
long gCntHtfNo       = 0;   // segnali scartati dal filtro HTF
long gCntGiaAperta   = 0;   // c'era gia' una posizione di questo magic
long gCntStopPivot   = 0;   // stop preso dal PIVOT confermato (il caso buono)
long gCntStopRitorno = 0;   // stop preso dall'estremo del RITORNO (ripiego)
long gCntLottoMin    = 0;   // ### il lotto e' finito al MINIMO del broker ###
long gCntLong        = 0;   // ingressi LONG eseguiti
long gCntShort       = 0;   // ingressi SHORT eseguiti
long gCntReject      = 0;   // ingressi scartati (spread/geometria/lotto/broker)
long gCntGuardian    = 0;   // ingressi bloccati dal Guardian
long gCntBE          = 0;   // breakeven applicati
long gFlatChiusure   = 0;   // posizioni chiuse dal flat di fine seduta

//--- distanze di stop in PUNTI INDICE, per la MEDIANA (cancello C3
//    della SPEC: la frontiera del costo si verifica, non si assume)
double gStopPts[];

void Log(string m){ if(InpVerbose) Print("[IBRT] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Stanno separate apposta: sono quelle che si possono verificare
//   a tavolino contro la specifica, senza MT5.
//
//==================================================================

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno.                                    |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| La barra appartiene alla finestra dell'Initial Balance?           |
//| Inizio COMPRESO, fine ESCLUSA (come la fonte): su M30 con         |
//| 14:30-15:30 le barre buone sono quelle che aprono alle 14:30 e    |
//| alle 15:00, e quella delle 15:30 e' gia' fuori.                   |
//+------------------------------------------------------------------+
bool DentroIB_Calc(const int minutiBarra,const int daMin,const int aMin)
  {
   return(minutiBarra >= daMin && minutiBarra < aMin);
  }

//+------------------------------------------------------------------+
//| Siamo a quest'ora (o oltre)? Usata per cutoff e flat.             |
//+------------------------------------------------------------------+
bool DopoOrario_Calc(const int ora,const int minuto,
                     const int oraLimite,const int minLimite)
  {
   return(ora*60+minuto >= oraLimite*60+minLimite);
  }

//+------------------------------------------------------------------+
//| PIVOT ALTO CONFERMATO.                                            |
//|  h[] e' indicizzato per SHIFT (h[1] = ultima barra chiusa).        |
//|  'centro' e' lo shift della barra candidata, 'lato' il numero di   |
//|  barre richieste a sinistra E a destra.                            |
//|  >>> CONFRONTO STRETTO su entrambi i lati, ed e' una scelta        |
//|      DICHIARATA: in caso di pareggio esatto (due barre con lo      |
//|      stesso massimo) il pivot NON si forma. Sugli indici a due     |
//|      decimali il pareggio e' raro; preferisco perdere un pivot     |
//|      piuttosto che accettarne uno ambiguo, perche' da quel pivot   |
//|      dipende lo STOP, cioe' il rischio.                            |
//+------------------------------------------------------------------+
bool PivotAlto_Calc(const double &h[],const int centro,const int lato)
  {
   if(lato<1) return(false);
   int n=ArraySize(h);
   if(centro-lato < 1) return(false);       // servono 'lato' barre CHIUSE a destra
   if(centro+lato >= n) return(false);
   double v=h[centro];
   if(v<=0) return(false);
   for(int i=1;i<=lato;i++)
     {
      if(h[centro+i]<=0 || h[centro-i]<=0) return(false);
      if(!(v > h[centro+i])) return(false);
      if(!(v > h[centro-i])) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| PIVOT BASSO CONFERMATO. Speculare esatto del precedente.          |
//+------------------------------------------------------------------+
bool PivotBasso_Calc(const double &l[],const int centro,const int lato)
  {
   if(lato<1) return(false);
   int n=ArraySize(l);
   if(centro-lato < 1) return(false);
   if(centro+lato >= n) return(false);
   double v=l[centro];
   if(v<=0) return(false);
   for(int i=1;i<=lato;i++)
     {
      if(l[centro+i]<=0 || l[centro-i]<=0) return(false);
      if(!(v < l[centro+i])) return(false);
      if(!(v < l[centro-i])) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO DI STOP (R109). Se lo stop grezzo e' piu' stretto del   |
//| pavimento lo si allarga; non lo si stringe MAI. Copre anche il    |
//| caso limite in cui il riferimento strutturale finisce dalla parte |
//| sbagliata del prezzo (R negativo): esce comunque uno stop valido. |
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
//| Conversione: distanza di PREZZO -> PUNTI INDICE.                  |
//+------------------------------------------------------------------+
double PrezzoInPuntiIndice_Calc(const double distPrezzo,
                                const double mt5PerIdx,const double point)
  {
   double den = mt5PerIdx*point;
   if(den<=0) return(0);
   return(distPrezzo/den);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore (lo ordina: si passa una COPIA).            |
//| Serve al cancello C3: stop mediano >= 40 x spread.                |
//+------------------------------------------------------------------+
double Mediana_Calc(double &v[])
  {
   int n=ArraySize(v);
   if(n<=0) return(0);
   ArraySort(v);
   if(n%2==1) return(v[n/2]);
   return(0.5*(v[n/2-1]+v[n/2]));
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpIbInizioOra<0 || InpIbInizioOra>23 || InpIbInizioMin<0 || InpIbInizioMin>59)
     { Print("ERRORE: ora/minuto di inizio IB fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpIbFineOra<0 || InpIbFineOra>23 || InpIbFineMin<0 || InpIbFineMin>59)
     { Print("ERRORE: ora/minuto di fine IB fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpIbInizioOra,InpIbInizioMin) >= MinutiDelGiorno_Calc(InpIbFineOra,InpIbFineMin))
     { Print("ERRORE: la finestra IB non attraversa la mezzanotte: l'inizio deve precedere la fine."); return(INIT_FAILED); }
   if(InpCutoffOra<0 || InpCutoffOra>23 || InpCutoffMin<0 || InpCutoffMin>59)
     { Print("ERRORE: ora/minuto di cutoff fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpGoFlatOra<0 || InpGoFlatOra>23 || InpGoFlatMin<0 || InpGoFlatMin>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpIbFineOra,InpIbFineMin) >= MinutiDelGiorno_Calc(InpCutoffOra,InpCutoffMin))
     { Print("ERRORE: il cutoff deve venire DOPO la chiusura dell'IB, altrimenti non esiste nessuna barra utile."); return(INIT_FAILED); }
   if(InpUsaFlatSeduta && MinutiDelGiorno_Calc(InpCutoffOra,InpCutoffMin) > MinutiDelGiorno_Calc(InpGoFlatOra,InpGoFlatMin))
     { Print("ERRORE: il flat deve venire DOPO l'ultimo ingresso ammesso, altrimenti si apre e si chiude nello stesso istante."); return(INIT_FAILED); }
   if(InpSmaLen<1)
     { Print("ERRORE: InpSmaLen deve essere >= 1 (e' la SMA di innesco dei passi 2 e 3)."); return(INIT_FAILED); }
   if(InpPivot<1)
     { Print("ERRORE: InpPivot deve essere >= 1: senza barre di conferma il pivot ridipingerebbe."); return(INIT_FAILED); }
   if(InpStopBufferPunti<0)
     { Print("ERRORE: InpStopBufferPunti non puo' essere negativo (metterebbe lo stop DENTRO la struttura)."); return(INIT_FAILED); }
   if(InpMaxIbPunti<0)
     { Print("ERRORE: InpMaxIbPunti non puo' essere negativo (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpUsaFiltroHTF && InpHtfMaLen<1)
     { Print("ERRORE: con InpUsaFiltroHTF=true serve InpHtfMaLen >= 1."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati sono spenti: l'EA non potrebbe mai operare."); return(INIT_FAILED); }
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
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato, 1 = come la fonte)."); return(INIT_FAILED); }

   gTfHtf = TfDaMinuti(InpHtfMinuti);
   if(InpUsaFiltroHTF && gTfHtf==PERIOD_CURRENT)
     { Print("ERRORE: InpHtfMinuti non riconosciuto. Ammessi: 5,15,30,60,240,1440."); return(INIT_FAILED); }

   gSmaH = iMA(_Symbol, gTF, InpSmaLen, 0, MODE_SMA, PRICE_CLOSE);
   if(gSmaH==INVALID_HANDLE)
     { Print("ERRORE: handle della SMA di innesco non creato."); return(INIT_FAILED); }

   if(InpUsaFiltroHTF)
     {
      gHtfH = iMA(_Symbol, gTfHtf, InpHtfMaLen, 0, MODE_SMA, PRICE_CLOSE);
      if(gHtfH==INVALID_HANDLE)
        { Print("ERRORE: handle della MA HTF non creato."); return(INIT_FAILED); }
     }

   ArrayResize(gStopPts,0);
   gBarraValutata = -1;
   gSeq           = 0;
   ResetSeduta(-1);
   gTicketCorrente = 0;
   gRischioPrezzo  = 0.0;
   gBEfatto        = false;

   Log(StringFormat("avviato su %s %s. CONFIG IN USO -> IB %02d:%02d-%02d:%02d SERVER | SMA innesco %d | pivot %d/%d | buffer stop %.2f pti indice | invalida su IB opposto=%s | filtro ampiezza IB=%.1f pti (0=spento) | HTF=%s (%d min, SMA %d) | lati=%s | cutoff %02d:%02d SERVER | flat=%s %02d:%02d SERVER | pavimento SL %d pti indice (x%.0f MT5) | TP=%.2fR | BE=%.2fR | rischio=%.2f%% | spread max %.2f%% dello stop | tetto giorno=%d | magic %I64d",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpIbInizioOra, InpIbInizioMin, InpIbFineOra, InpIbFineMin,
       InpSmaLen, InpPivot, InpPivot, InpStopBufferPunti,
       (InpInvalidaSuIbOpposto ? "ON" : "OFF"), InpMaxIbPunti,
       (InpUsaFiltroHTF ? "ACCESO" : "SPENTO"), InpHtfMinuti, InpHtfMaLen,
       (InpAllowLong && InpAllowShort ? "long+short" : (InpAllowLong ? "SOLO LONG" : "SOLO SHORT")),
       InpCutoffOra, InpCutoffMin,
       (InpUsaFlatSeduta ? "ON" : "OFF"), InpGoFlatOra, InpGoFlatMin,
       InpMinStopPts, InpMT5PerPuntoIndice,
       InpRR, InpBEatR, InpRiskPercent, InpMaxSpreadPctOfStop,
       InpMaxTradesPerDay, InpMagic));
   Log("RICORDA: gli orari sono quelli del SERVER (BCM = ora italiana - 1). Un'ora sbagliata non da' errore: misura un'altra strategia. USA: IB 14:30-15:30 SERVER. DAX: IB 08:00-09:00 SERVER.");
   Log("Macchina a TRE stati: rottura -> ritorno -> FALLIMENTO del ritorno. La rottura da sola NON e' un ingresso. Il pivot serve solo allo STOP, mai al grilletto.");
   Log("Ingresso SINGOLO a mercato, una posizione per magic, stop STRUTTURALE VERO allegato all'ordine. Nessuna aggiunta, media, griglia, recovery o piramidazione.");
   Log("NESSUN tetto di perdita giornaliera interno: la fonte non ce l'ha e non si infila un meccanismo non misurato dentro un porting. Sta come proposta separata nel referto.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(gSmaH!=INVALID_HANDLE){ IndicatorRelease(gSmaH); gSmaH=INVALID_HANDLE; }
   if(gHtfH!=INVALID_HANDLE){ IndicatorRelease(gHtfH); gHtfH=INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| Minuti -> timeframe. PERIOD_CURRENT = non riconosciuto.           |
//| Deliberatamente pochi valori: un input in minuti non si sbaglia   |
//| a scrivere in un .ini, un enum si.                                |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TfDaMinuti(const int m)
  {
   if(m==5)    return(PERIOD_M5);
   if(m==15)   return(PERIOD_M15);
   if(m==30)   return(PERIOD_M30);
   if(m==60)   return(PERIOD_H1);
   if(m==240)  return(PERIOD_H4);
   if(m==1440) return(PERIOD_D1);
   return(PERIOD_CURRENT);
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

//+------------------------------------------------------------------+
//| Azzera TUTTO lo stato di seduta. Chiamata al cambio di giorno     |
//| SERVER: e' l'equivalente del blocco isNewDay della fonte.         |
//+------------------------------------------------------------------+
void ResetSeduta(const int giorno)
  {
   gGiorno     = giorno;
   gIbHigh     = 0.0;
   gIbLow      = 0.0;
   gIbDati     = false;
   gIbCompleto = false;
   gIbTroppoGr = false;
   gTradeOggi  = 0;

   gL_rotto=false;   gL_rottoSeq=-1;
   gL_ritorno=false; gL_ritornoSeq=-1;
   gL_ritornoMin=0.0; gL_ritornoMinOk=false;
   gL_pivotAlto=0.0;  gL_pivotAltoSeq=-1;  gL_pivotAltoOk=false;
   gL_pivotBasso=0.0; gL_pivotBassoSeq=-1; gL_pivotBassoOk=false;
   gL_fatto=false;

   gS_rotto=false;   gS_rottoSeq=-1;
   gS_ritorno=false; gS_ritornoSeq=-1;
   gS_ritornoMax=0.0; gS_ritornoMaxOk=false;
   gS_pivotBasso=0.0; gS_pivotBassoSeq=-1; gS_pivotBassoOk=false;
   gS_pivotAlto=0.0;  gS_pivotAltoSeq=-1;  gS_pivotAltoOk=false;
   gS_fatto=false;
  }

//==================================================================
//  IL MOTORE, lato terminale
//==================================================================

//+------------------------------------------------------------------+
//| Si valuta la barra allo SHIFT 1 (appena chiusa) e, se il terzo    |
//| stato si e' completato, si entra a mercato adesso: cioe'          |
//| all'apertura della barra successiva. Niente look-ahead.           |
//|                                                                   |
//| CHE OROLOGIO USA COSA, e va detto perche' e' una scelta:          |
//|   - giorno, finestra IB e chiusura dell'IB si giudicano sull'ORA  |
//|     DI APERTURA DELLA BARRA DI SEGNALE (come la fonte, che        |
//|     valuta con il time della barra);                             |
//|   - cutoff e flat si giudicano su TimeCurrent(), cioe' sull'ORA   |
//|     IN CUI L'ORDINE PARTE DAVVERO. E' piu' severo e piu' onesto:  |
//|     un ordine non si manda dopo il cutoff nemmeno se la barra che |
//|     lo ha generato era ancora in orario.                          |
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
   gSeq++;

   MqlDateTime dBar; TimeToStruct(t1,dBar);

   //--- cambio di seduta: azzera tutto (equivalente di isNewDay)
   if(dBar.day_of_year != gGiorno)
      ResetSeduta(dBar.day_of_year);

   int minBarra = MinutiDelGiorno_Calc(dBar.hour,dBar.min);
   int minIbDa  = MinutiDelGiorno_Calc(InpIbInizioOra,InpIbInizioMin);
   int minIbA   = MinutiDelGiorno_Calc(InpIbFineOra,InpIbFineMin);

   double h1 = iHigh (_Symbol,gTF,1);
   double l1 = iLow  (_Symbol,gTF,1);
   double c1 = iClose(_Symbol,gTF,1);
   if(h1<=0 || l1<=0 || c1<=0 || h1<l1){ gCntNoDati++; return; }

   //--- 1) COSTRUZIONE DELL'INITIAL BALANCE (solo barre CHIUSE)
   if(DentroIB_Calc(minBarra,minIbDa,minIbA))
     {
      if(!gIbDati){ gIbHigh=h1; gIbLow=l1; gIbDati=true; }
      else
        {
         if(h1>gIbHigh) gIbHigh=h1;
         if(l1<gIbLow)  gIbLow =l1;
        }
      return;                     // dentro l'IB non si opera mai
     }

   //--- prima della finestra IB non c'e' niente da fare
   if(minBarra < minIbDa) return;

   //--- 2) CHIUSURA DELL'IB: la prima barra oltre la finestra
   if(!gIbCompleto)
     {
      if(!gIbDati) return;        // giorno senza dati nella finestra IB
      gIbCompleto = true;
      gCntSeduteIB++;
      double ampiezzaPti = PrezzoInPuntiIndice_Calc(gIbHigh-gIbLow,InpMT5PerPuntoIndice,_Point);
      gIbTroppoGr = (InpMaxIbPunti>0 && ampiezzaPti>InpMaxIbPunti);
      Log(StringFormat("IB della seduta chiuso: high %s low %s, ampiezza %.1f pti indice%s",
          DoubleToString(gIbHigh,_Digits), DoubleToString(gIbLow,_Digits),
          ampiezzaPti, (gIbTroppoGr ? " -> BLOCCATA dal filtro d'ampiezza" : "")));
     }

   gCntBarre++;

   //--- SMA di innesco sulla barra di segnale
   double sma = ValoreBuffer(gSmaH,1);
   if(sma<=0){ gCntNoDati++; return; }

   //--- 3) PIVOT CONFERMATI (servono SOLO allo stop). Il candidato e'
   //    la barra allo shift 1+InpPivot: e' confermata adesso, perche'
   //    solo adesso esistono InpPivot barre chiuse alla sua destra.
   AggiornaPivot();

   //--- 4) TETTO GIORNALIERO = il `sessionTradeDone` della fonte.
   //    CONGELA LA RILEVAZIONE DI ENTRAMBI I LATI, non solo l'invio:
   //    e' esattamente quello che fa il Pine (il blocco di rilevazione
   //    e' dentro `if ... and not sessionTradeDone`). Il contatore
   //    conta le BARRE congelate, non i segnali persi: dice quanta
   //    parte della seduta il motore passa a guardare senza poter
   //    fare niente.
   if(TettoGiornoRaggiunto()){ gCntTettoGiorno++; return; }

   //--- 5) LA MACCHINA A STATI, un lato per volta. Entrambi i lati si
   //    calcolano SEMPRE: i contatori devono dire quante OCCASIONI
   //    c'erano, non quante ne abbiamo prese.
   MacchinaLong(h1,l1,c1,sma);
   MacchinaShort(h1,l1,c1,sma);
  }

//+------------------------------------------------------------------+
//| Legge un buffer di indicatore allo shift richiesto.               |
//+------------------------------------------------------------------+
double ValoreBuffer(const int handle,const int shift)
  {
   if(handle==INVALID_HANDLE) return(0);
   double v[1];
   if(CopyBuffer(handle,0,shift,1,v)<1) return(0);
   return(v[0]);
  }

//+------------------------------------------------------------------+
//| Aggiorna i riferimenti strutturali per lo stop.                   |
//|                                                                   |
//| Portato dalla fonte alla lettera (righe 707-720 e 758-771):       |
//|   LONG : un PIVOT ALTO confermato SOPRA l'IB high diventa il      |
//|          "massimo decrescente" di riferimento e azzera il minimo; |
//|          il primo PIVOT BASSO confermato DOPO di lui e' il        |
//|          "minimo crescente" = riferimento dello STOP.             |
//|   SHORT: speculare esatto.                                        |
//| Se quel pivot non esiste, lo stop ripiega sull'estremo del        |
//| RITORNO (piu' stretto, ed e' il caso peggiore: il contatore       |
//| gCntStopRitorno dice quante volte succede).                       |
//+------------------------------------------------------------------+
void AggiornaPivot()
  {
   if(!gIbCompleto) return;

   int lato   = InpPivot;
   int centro = 1 + lato;
   int serve  = centro + lato + 1;

   //--- vettori indicizzati per SHIFT. La casella 0 (barra ancora
   //    APERTA) viene riempita solo per non sfalsare gli indici:
   //    PivotAlto_Calc / PivotBasso_Calc non la leggono MAI, perche'
   //    l'indice piu' basso che toccano e' centro-lato = 1. E' li'
   //    che si vede, nero su bianco, che non c'e' look-ahead.
   double h[]; double l[];
   ArrayResize(h,serve); ArrayResize(l,serve);
   for(int i=0;i<serve;i++)
     {
      h[i] = iHigh(_Symbol,gTF,i);
      l[i] = iLow (_Symbol,gTF,i);
     }

   long seqCandidato = gSeq - (long)lato;   // il "bar_index - pivotRight" della fonte

   if(PivotAlto_Calc(h,centro,lato))
     {
      double ph = h[centro];
      //--- LONG: un massimo confermato SOPRA l'IB high resetta il minimo
      if(!gL_fatto && ph > gIbHigh)
        {
         gL_pivotAlto    = ph;
         gL_pivotAltoSeq = seqCandidato;
         gL_pivotAltoOk  = true;
         gL_pivotBassoOk = false;
         gL_pivotBassoSeq= -1;
        }
      //--- SHORT: serve un massimo confermato DOPO il minimo sotto l'IB low
      if(!gS_fatto && gS_pivotBassoOk && seqCandidato > gS_pivotBassoSeq)
        {
         gS_pivotAlto    = ph;
         gS_pivotAltoSeq = seqCandidato;
         gS_pivotAltoOk  = true;
        }
     }

   if(PivotBasso_Calc(l,centro,lato))
     {
      double pl = l[centro];
      //--- SHORT: un minimo confermato SOTTO l'IB low resetta il massimo
      if(!gS_fatto && pl < gIbLow)
        {
         gS_pivotBasso    = pl;
         gS_pivotBassoSeq = seqCandidato;
         gS_pivotBassoOk  = true;
         gS_pivotAltoOk   = false;
         gS_pivotAltoSeq  = -1;
        }
      //--- LONG: serve un minimo confermato DOPO il massimo sopra l'IB high
      if(!gL_fatto && gL_pivotAltoOk && seqCandidato > gL_pivotAltoSeq)
        {
         gL_pivotBasso    = pl;
         gL_pivotBassoSeq = seqCandidato;
         gL_pivotBassoOk  = true;
        }
     }
  }

//+------------------------------------------------------------------+
//| LATO LONG: rottura SOPRA l'IB high, ritorno, fallimento.          |
//|   S1 ROTTURA     high > IB high                     (una volta)   |
//|   S2 RITORNO     low <= IB high  E  close < SMA     (una volta)   |
//|   S3 FALLIMENTO  close > SMA  E  close > IB high     -> LONG      |
//| L'ordine dei passi dentro la barra e' quello della fonte:         |
//| rottura, invalidazione, ritorno, aggiornamento del minimo del     |
//| ritorno, ingresso. E ogni passo deve stare su una barra DIVERSA   |
//| dal precedente (la fonte lo impone con bar_index > ...).          |
//+------------------------------------------------------------------+
void MacchinaLong(const double h1,const double l1,const double c1,const double sma)
  {
   if(gL_fatto) return;

   //--- S1 ROTTURA
   if(!gL_rotto && h1 > gIbHigh)
     {
      gL_rotto    = true;
      gL_rottoSeq = gSeq;
      gCntRotturaL++;
     }

   //--- invalidazione opzionale (fonte: spenta)
   if(InpInvalidaSuIbOpposto && gL_rotto && l1 < gIbLow)
     {
      gL_rotto=false;   gL_rottoSeq=-1;
      gL_ritorno=false; gL_ritornoSeq=-1;
      gL_ritornoMinOk=false;
      gCntInvalidati++;
      return;
     }

   //--- S2 RITORNO: il prezzo torna a toccare il livello rotto E
   //    chiude dalla parte sbagliata della SMA. Mai sulla barra
   //    stessa della rottura.
   if(gL_rotto && !gL_ritorno && gL_rottoSeq>=0 && gSeq>gL_rottoSeq
      && l1 <= gIbHigh && c1 < sma)
     {
      gL_ritorno    = true;
      gL_ritornoSeq = gSeq;
      gCntRitornoL++;
     }

   //--- minimo del ritorno: e' il ripiego dello stop se il pivot manca
   if(gL_ritorno)
     {
      if(!gL_ritornoMinOk){ gL_ritornoMin=l1; gL_ritornoMinOk=true; }
      else if(l1<gL_ritornoMin) gL_ritornoMin=l1;
     }

   //--- S3 FALLIMENTO DEL RITORNO = INGRESSO
   if(!(gL_ritorno && gL_ritornoSeq>=0 && gSeq>gL_ritornoSeq && c1>sma && c1>gIbHigh))
      return;

   gCntSegnaleL++;                     // segnale GREZZO, prima dei cancelli

   if(!InpAllowLong)      { gCntLatoNo++;   return; }
   if(gIbTroppoGr)        { gCntIbGrande++; return; }
   if(DopoCutoff())       { gCntCutoff++;   return; }
   if(!FiltroHtfOk(true,c1)) { gCntHtfNo++; return; }
   if(HoPosizione())      { gCntGiaAperta++; return; }

   //--- riferimento dello STOP: pivot confermato, altrimenti il minimo
   //    del ritorno. Il contatore separa i due casi.
   double rif;
   if(gL_pivotBassoOk){ rif=gL_pivotBasso; gCntStopPivot++; }
   else if(gL_ritornoMinOk){ rif=gL_ritornoMin; gCntStopRitorno++; }
   else return;                        // non puo' succedere, ma non si tira a indovinare

   //--- IL SETUP SI CONSUMA QUI, sul primo innesco valido, ANCHE se
   //    l'ordine poi fallisce. Scelta dichiarata: la fonte fa lo
   //    stesso (L_entryDone si alza al segnale, non al riempimento),
   //    e senza questo un rifiuto del broker o del gate di spread
   //    lascerebbe il setup vivo per ore, producendo un ingresso
   //    TARDIVO a un prezzo peggiore con uno stop strutturale ormai
   //    vecchio. Il tetto giornaliero invece conta solo gli ingressi
   //    ESEGUITI: una giornata non si brucia per un ordine mai andato.
   gL_fatto = true;
   if(Entra(true,rif)) gTradeOggi++;
  }

//+------------------------------------------------------------------+
//| LATO SHORT: speculare esatto del long.                            |
//|   S1 ROTTURA     low < IB low                                     |
//|   S2 RITORNO     high >= IB low  E  close > SMA                   |
//|   S3 FALLIMENTO  close < SMA  E  close < IB low      -> SHORT     |
//+------------------------------------------------------------------+
void MacchinaShort(const double h1,const double l1,const double c1,const double sma)
  {
   if(gS_fatto) return;

   //--- S1 ROTTURA
   if(!gS_rotto && l1 < gIbLow)
     {
      gS_rotto    = true;
      gS_rottoSeq = gSeq;
      gCntRotturaS++;
     }

   //--- invalidazione opzionale (fonte: spenta)
   if(InpInvalidaSuIbOpposto && gS_rotto && h1 > gIbHigh)
     {
      gS_rotto=false;   gS_rottoSeq=-1;
      gS_ritorno=false; gS_ritornoSeq=-1;
      gS_ritornoMaxOk=false;
      gCntInvalidati++;
      return;
     }

   //--- S2 RITORNO
   if(gS_rotto && !gS_ritorno && gS_rottoSeq>=0 && gSeq>gS_rottoSeq
      && h1 >= gIbLow && c1 > sma)
     {
      gS_ritorno    = true;
      gS_ritornoSeq = gSeq;
      gCntRitornoS++;
     }

   //--- massimo del ritorno: ripiego dello stop
   if(gS_ritorno)
     {
      if(!gS_ritornoMaxOk){ gS_ritornoMax=h1; gS_ritornoMaxOk=true; }
      else if(h1>gS_ritornoMax) gS_ritornoMax=h1;
     }

   //--- S3 FALLIMENTO DEL RITORNO = INGRESSO
   if(!(gS_ritorno && gS_ritornoSeq>=0 && gSeq>gS_ritornoSeq && c1<sma && c1<gIbLow))
      return;

   gCntSegnaleS++;

   if(!InpAllowShort)     { gCntLatoNo++;   return; }
   if(gIbTroppoGr)        { gCntIbGrande++; return; }
   if(DopoCutoff())       { gCntCutoff++;   return; }
   if(!FiltroHtfOk(false,c1)){ gCntHtfNo++; return; }
   if(HoPosizione())      { gCntGiaAperta++; return; }

   double rif;
   if(gS_pivotAltoOk){ rif=gS_pivotAlto; gCntStopPivot++; }
   else if(gS_ritornoMaxOk){ rif=gS_ritornoMax; gCntStopRitorno++; }
   else return;

   //--- il setup si consuma qui: vedi la nota nel lato long.
   gS_fatto = true;
   if(Entra(false,rif)) gTradeOggi++;
  }

//+------------------------------------------------------------------+
//| Tetto giornaliero. 1 = la regola sessionTradeDone della fonte     |
//| (una operazione per seduta, blocca ENTRAMBI i lati).              |
//| 0 = illimitato: resta comunque il vincolo "un ingresso per lato   |
//| per seduta" (gL_fatto / gS_fatto), quindi il massimo e' 2.        |
//+------------------------------------------------------------------+
bool TettoGiornoRaggiunto()
  {
   if(InpMaxTradesPerDay<=0) return(false);
   return(gTradeOggi >= InpMaxTradesPerDay);
  }

//+------------------------------------------------------------------+
//| Siamo oltre il cutoff (o oltre il flat)? Si giudica sull'ORA IN   |
//| CUI L'ORDINE PARTE, non su quella della barra di segnale.         |
//+------------------------------------------------------------------+
bool DopoCutoff()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(),n);
   if(DopoOrario_Calc(n.hour,n.min,InpCutoffOra,InpCutoffMin)) return(true);
   if(InpUsaFlatSeduta && DopoOrario_Calc(n.hour,n.min,InpGoFlatOra,InpGoFlatMin)) return(true);
   return(false);
  }

//+------------------------------------------------------------------+
//| FILTRO HTF (spento di default). Long solo se la chiusura della    |
//| barra di segnale sta SOPRA la MA del timeframe alto, short solo   |
//| se sta sotto.                                                     |
//| >>> DIFFERENZA DALLA FONTE, dichiarata: il Pine legge la MA con   |
//|     request.security(lookahead_off), che sulla barra HTF ancora   |
//|     APERTA si aggiorna tick per tick. Qui si legge lo SHIFT 1,    |
//|     cioe' l'ultima barra HTF CHIUSA: piu' lento, ma non ridipinge |
//|     mai. Su un filtro di tendenza e' la scelta prudente.          |
//+------------------------------------------------------------------+
bool FiltroHtfOk(const bool isLong,const double c1)
  {
   if(!InpUsaFiltroHTF) return(true);
   double ma = ValoreBuffer(gHtfH,1);
   if(ma<=0) return(false);            // niente dato = niente permesso
   return(isLong ? (c1>ma) : (c1<ma));
  }

//+------------------------------------------------------------------+
//| INGRESSO A MERCATO con STOP STRUTTURALE VERO allegato all'ordine. |
//| 'rif' e' il riferimento strutturale (pivot confermato o estremo   |
//| del ritorno): lo stop ci va OLTRE, di InpStopBufferPunti punti    |
//| indice.                                                           |
//+------------------------------------------------------------------+
bool Entra(const bool isLong,const double rif)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ gCntReject++; Log("prezzi non disponibili: salto."); return(false); }

   double point    = _Point;
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double pav      = MathMax((double)InpMinStopPts*InpMT5PerPuntoIndice*point, stopsLvl);
   if(pav<=0){ gCntReject++; Log("pavimento SL nullo: salto (R109)."); return(false); }

   double entry  = isLong ? ask : bid;
   double buffer = InpStopBufferPunti*InpMT5PerPuntoIndice*point;

   //--- STOP STRUTTURALE: oltre il riferimento, mai dentro.
   double slGrezzo = isLong ? (rif-buffer) : (rif+buffer);
   double slFinal  = SlFloor_Calc(isLong, entry, slGrezzo, pav);
   double slDist   = isLong ? (entry-slFinal) : (slFinal-entry);
   if(slDist<=0){ gCntReject++; Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- GATE DI SPREAD IN % DELLO STOP (R55)
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

   bool alMinimo=false;
   double lot = LotByRisk(slDist,alMinimo);
   if(lot<=0){ gCntReject++; Log("lotto nullo (rischio troppo piccolo o simbolo non calcolabile): salto."); return(false); }

   //--- GUARDIAN: IMMEDIATAMENTE prima dell'invio, mai in cima
   //    all'imbuto (referto di migrazione, par. 1.3).
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_IBRetest"))
     { gCntGuardian++; return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
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
   if(alMinimo) gCntLottoMin++;

   //--- lo stop in PUNTI INDICE va nel vettore della MEDIANA: e' il
   //    cancello C3 (frontiera del costo), e si verifica, non si assume.
   double slPts = PrezzoInPuntiIndice_Calc(slDist,InpMT5PerPuntoIndice,point);
   int n=ArraySize(gStopPts);
   ArrayResize(gStopPts,n+1);
   gStopPts[n]=slPts;

   Log(StringFormat("%s: lot %.2f%s | SL %s | TP %s | stop %.1f pti indice | rif strutturale %s",
       (isLong?"BUY":"SELL"), lot, (alMinimo?" (AL MINIMO DEL BROKER: rischio vero > dichiarato)":""),
       DoubleToString(sP,_Digits), DoubleToString(tP,_Digits), slPts,
       DoubleToString(rif,_Digits)));
   return(true);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE VIVA
//==================================================================

//+------------------------------------------------------------------+
//| BREAKEVEN a InpBEatR volte R, come MODIFICA dell'ordine: non      |
//| chiude niente, non tocca il TP. Una volta sola per posizione.     |
//| DEFAULT SPENTO: con un TP unico a 2R il breakeven a 2R della      |
//| fonte sarebbe inerte (il target arriverebbe prima), quindi        |
//| accenderlo qui vorrebbe dire SCEGLIERE un valore nuovo -- cioe'   |
//| un asse in piu' da girare verso il passato, non un miglioramento  |
//| gia' dimostrato.                                                  |
//|                                                                   |
//| NIENTE PARZIALI, ed e' una scelta dichiarata: una posizione, una  |
//| tranche. La scala 1R/2R/3R/4R/5R della fonte NON e' portata.      |
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
   bool   isLong= (tipo==POSITION_TYPE_BUY);

   if(tk!=gTicketCorrente)
     {
      gTicketCorrente = tk;
      gRischioPrezzo  = isLong ? (apert-sl) : (sl-apert);
      gBEfatto = (gRischioPrezzo<=0);   // stop gia' a pari o oltre
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
//| FLAT DI FINE SEDUTA: zero overnight. Nella fonte c'e' gia'        |
//| (goFlat), ed e' uno dei motivi per cui e' stata promossa: niente  |
//| swap e niente spread notturno (sul DAX 3,5-3,9 punti contro       |
//| 1,6-1,7 in sessione, MISURATO).                                   |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   if(!InpUsaFlatSeduta) return(false);

   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrario_Calc(t.hour,t.min,InpGoFlatOra,InpGoFlatMin)) return(false);

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
                       InpGoFlatOra, InpGoFlatMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//| Colonna prop: il muro giornaliero non si legge dal DD totale.     |
//| Sul verdetto LVNArbitro questa colonna ha detto la cosa piu'      |
//| importante del round: peggior giornata -2,80% con DD totale       |
//| 11,76% = NON una giornata catastrofica, un'EROSIONE LUNGA.        |
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
//|  il calcolo della seconda tranche) qui NON PUO' esistere: non c'e'|
//|  nessuna seconda tranche. E' la forma semplice, scelta apposta.   |
//|                                                                   |
//|  'alMinimo' esce a true quando il lotto teorico stava SOTTO il    |
//|  minimo del broker e il minimo lo ha rialzato: in quel caso il    |
//|  rischio VERO e' piu' alto di InpRiskPercent. Non e' un errore    |
//|  dell'EA, e' un fatto del simbolo -- ma va CONTATO, perche' senza |
//|  quel numero un DD che mescola motore e pavimento del lotto "non  |
//|  e' un numero" (verdetto ABTG_LVNArbitro dell'08/09).             |
//|                                                                   |
//|  Perdita per lotto chiesta al BROKER (OrderCalcProfit converte in |
//|  valuta conto); il tick value resta come ripiego, perche' su certi|
//|  simboli arriva non convertito e il lotto uscirebbe al minimo.    |
//+------------------------------------------------------------------+
double LotByRisk(const double slDist,bool &alMinimo)
  {
   alMinimo=false;
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
   if(lot < mn){ alMinimo=true; lot = mn; }
   if(mx>0 && lot > mx) lot = mx;
   return(lot);
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

   //--- MEDIANA dello stop in punti indice (cancello C3 della SPEC:
   //    la frontiera stop >= 40 x spread si VERIFICA, non si assume)
   double copia[];
   ArrayResize(copia,ArraySize(gStopPts));
   for(int i=0;i<ArraySize(gStopPts);i++) copia[i]=gStopPts[i];
   double stopMediano = Mediana_Calc(copia);

   double stats[25];
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
   //--- DIAGNOSTICA: e' il PASSO 0 letto dal CSV. I TRE STATI sono
   //    contati SEPARATAMENTE apposta: se le rotture sono tante e i
   //    ritorni pochi, il collo di bottiglia e' il passo 2; se i
   //    ritorni sono tanti e i trade pochi, e' il passo 3 (o un
   //    cancello). Un numero aggregato non saprebbe dirlo.
   //    L'ordine QUI e l'intestazione in OnTesterDeinit si toccano
   //    SEMPRE INSIEME.
   stats[10] = (double)gCntBarre;
   stats[11] = (double)gCntSeduteIB;
   stats[12] = (double)gCntRotturaL;
   stats[13] = (double)gCntRotturaS;
   stats[14] = (double)gCntRitornoL;
   stats[15] = (double)gCntRitornoS;
   stats[16] = (double)gCntSegnaleL;
   stats[17] = (double)gCntSegnaleS;
   stats[18] = (double)gCntLong;
   stats[19] = (double)gCntShort;
   stats[20] = stopMediano;
   stats[21] = (double)gCntStopPivot;
   stats[22] = (double)gCntLottoMin;
   stats[23] = (double)gCntReject;
   stats[24] = (double)gFlatChiusure;

   PrintFormat("[IBRT][DIAG] barre=%I64d sedute_IB=%I64d | rottura L/S=%I64d/%I64d | ritorno L/S=%I64d/%I64d | segnale L/S=%I64d/%I64d | trade L/S=%I64d/%I64d | stop mediano=%.1f pti | stop da pivot=%I64d da ritorno=%I64d | lotto al minimo=%I64d | cutoff=%I64d tetto=%I64d latoNo=%I64d ibGrande=%I64d htfNo=%I64d giaAperta=%I64d invalidati=%I64d | reject=%I64d guardian=%I64d BE=%I64d flat=%I64d noDati=%I64d | peggior giornata=%.4f%%",
               gCntBarre, gCntSeduteIB,
               gCntRotturaL, gCntRotturaS, gCntRitornoL, gCntRitornoS,
               gCntSegnaleL, gCntSegnaleS, gCntLong, gCntShort,
               stopMediano, gCntStopPivot, gCntStopRitorno, gCntLottoMin,
               gCntCutoff, gCntTettoGiorno, gCntLatoNo, gCntIbGrande, gCntHtfNo,
               gCntGiaAperta, gCntInvalidati,
               gCntReject, gCntGuardian, gCntBE, gFlatChiusure, gCntNoDati,
               gWorstDayPct);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Barre Valutate,Sedute con IB,Rottura Long,Rottura Short,Ritorno Long,Ritorno Short,Segnale Long,Segnale Short,Long,Short,Stop Mediano Punti,Stop Da Pivot,Lotto Al Minimo,Reject,Flat Chiusure";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12], data[13], data[14],
                                data[15], data[16], data[17], data[18], data[19],
                                data[20], data[21], data[22], data[23], data[24]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
