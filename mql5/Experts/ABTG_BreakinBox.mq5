//+------------------------------------------------------------------+
//|                                           ABTG_BreakinBox.mq5     |
//|                                                                  |
//|  EA "BRKBOX" - BREAKIN DEL BOX NOTTURNO                          |
//|  (falsa rottura del range notturno -> reversal verso il lato      |
//|   opposto del box). MT5, tutto-in-uno: si mette in MQL5\Experts   |
//|   e si compila con F7, nessuna cartella da creare.                |
//|                                                                  |
//|  DA DOVE VIENE -- ATTRIBUZIONE, come da regola di casa:           |
//|    (a) SPEC DI CASA, scritta il 23/08/2026 e mai provata:         |
//|        backtest_pipeline/caccia_strategie/                        |
//|                        ANALISI_NIGHTLY_PDF_2026-08-23.md   par.7b    |
//|        ("proposta unica" del referto sul PDF di corso NIGHTLY,    |
//|         regole a PAG 26/28/29 del documento).                     |
//|    (b) DOSSIER CHE LA PROMUOVE (9/10), con l'ablazione imposta:   |
//|        backtest_pipeline/caccia_strategie/                        |
//|                        CACCIA_CRT_SECONDA_2026-08-31.md    par.4     |
//|    (c) CONFERMA ESTERNA INDIPENDENTE, letta il 31/08 (README):    |
//|        github.com/martin254/Asian-Turtle-Soup-Trading-Bot         |
//|        (QuantConnect/Python; licenza NON dichiarata nel repo      |
//|         [INCERTO] -- qui NON e' stata portata una riga di quel    |
//|         codice: e' citato come conferma della geometria, non      |
//|         come sorgente). Da li' viene la frase che descrive        |
//|         l'ingresso DIFFERITO: "Enter on confirmation during       |
//|         London/NY overlap".                                       |
//|    (d) Il calcolo del BOX NOTTURNO riusa il pattern gia' in casa  |
//|        di ABTG_MaxMinNotte / ABTG_MaxMinNotte_DAX_Short_Ott       |
//|        (ComputeBox su barre M1, scavalco della mezzanotte).       |
//|                                                                  |
//|  PERCHE' UN EA NUOVO E NON UNA MODIFICA A ABTG_LiquiditySweep     |
//|    Il dossier immaginava "una funzione dentro il motore ospite".  |
//|    Scritto il codice, la scelta e' un EA dedicato, per tre        |
//|    motivi che vanno agli atti:                                    |
//|    1. IL LIVELLO E' DI ALTRA NATURA. In LiquiditySweep i livelli  |
//|       sono una POPOLAZIONE viva (array dinamici, tetto            |
//|       InpMaxLivelli, consumo, InpSwingBars, InpTF_Struttura).     |
//|       Qui i livelli sono DUE al giorno, deterministici, calcolati |
//|       da un orologio: innestarli li' lascerebbe in ogni passata   |
//|       un ramo morto (tutta la macchina degli swing) e due input   |
//|       che non vogliono dire piu' niente.                          |
//|    2. LA GEOMETRIA NUOVA NON E' UN'OPZIONE, E' IL MOTORE:         |
//|       ingresso DIFFERITO su conferma in una finestra di sessione, |
//|       TP al LATO OPPOSTO DEL BOX, flat di fine seduta a due       |
//|       tempi. Sono comportamenti costitutivi, non filtri.          |
//|    3. NON SI SPORCA UN SORGENTE GIA' MISURATO. LiquiditySweep     |
//|       (magic 772600) porta i risultati archiviati di R89 e R95:   |
//|       cambiargli input, contatori e cardinalita' dell'OPTFRAME    |
//|       renderebbe non confrontabili quei referti.                  |
//|    ABTG_LiquiditySweep NON e' stato toccato da questo file.       |
//|                                                                  |
//|  LA TESI DI MERCATO, in una riga (dal dossier par.4):               |
//|    un range di sessione e' dove il mercato ha lasciato gli stop   |
//|    di chi dormiva. Quando il prezzo lo rompe, CHIUDE FUORI e poi  |
//|    RIENTRA, la rottura non aveva ordini dietro: chi e' entrato    |
//|    sul breakout e' dalla parte sbagliata di un livello che tiene, |
//|    e il prezzo ha TUTTO IL BOX da percorrere prima del prossimo   |
//|    ostacolo.                                                      |
//|                                                                  |
//|  IL MOTORE, in quattro righe                                      |
//|    1. IL LIVELLO -- MAX e MIN del BOX NOTTURNO, finestra          |
//|       23:00-04:59 ORA SERVER (input, = box della sedia 770411). NON uno swing, NON una      |
//|       candela: un range di ~7 ore. Si ricalcola a ogni barra dai  |
//|       dati M1 (nessuno stato persistente: sopravvive a un         |
//|       riavvio dell'EA a meta' giornata).                          |
//|    2. L'ARMAMENTO (falsa rottura) -- nella finestra operativa una |
//|       barra CHIUDE FUORI dal box (close>boxHigh oppure            |
//|       close<boxLow). Il lato si arma e si memorizza l'estremo     |
//|       dello sweep (il massimo/minimo toccato mentre si sta        |
//|       fuori). NOTA: e' esattamente il punto in cui la sedia viva  |
//|       ABTG_MaxMinNotte_DAX_Short_Ott (magic 770411) ENTRA sul     |
//|       BREAKOUT. Qui non si entra: si aspetta che quel breakout    |
//|       FALLISCA. I due motori sono mutuamente esclusivi per        |
//|       costruzione (la correlazione fra le serie per-trade va      |
//|       comunque MISURATA prima di qualunque accensione insieme --  |
//|       ROTTA_PROP regola 1).                                       |
//|    3. IL GRILLETTO DIFFERITO -- una barra SUCCESSIVA (almeno      |
//|       InpMinBarreRientro barre dopo l'armamento, default 1)       |
//|       CHIUDE DI NUOVO DENTRO il box -> ingresso a mercato nel     |
//|       verso del rientro. Se il rientro non arriva entro           |
//|       InpConfirmMaxBars barre, l'armamento SCADE e il lato si     |
//|       ri-arma solo su una nuova chiusura fuori.                   |
//|       >>> E' QUI la differenza dai tre motori gia' falsificati:   |
//|       R95 e il CRT entrano sulla STESSA barra che buca e          |
//|       richiude; il par.4.3 di Mesfin (arXiv 2605.04004, n=6.442)     |
//|       entra a barra+1 su un estremo di sessione. Nessuno dei tre  |
//|       pretende una CHIUSURA fuori seguita da una CHIUSURA dentro  |
//|       su barre diverse, dentro una finestra di sessione.          |
//|    4. L'USCITA -- SL oltre l'ESTREMO DELLO SWEEP + buffer, con    |
//|       PAVIMENTO obbligatorio (R109). TP: vedi ABLAZIONE.          |
//|                                                                  |
//|  ABLAZIONE OBBLIGATORIA (dossier par.4, "la prova che decide")       |
//|    InpTP_RR = 0   -> TP al LATO OPPOSTO DEL BOX  (LA TESI)        |
//|    InpTP_RR > 0   -> TP a RR fisso su distanza SL (IL CONTROLLO,  |
//|                      cioe' la geometria di R95, 0/30 passate)     |
//|    SE VINCE L'RR FISSO, questo EA e' R95 con un livello nuovo e   |
//|    IL CAPITOLO SI CHIUDE. Senza questa ablazione il round NON e'  |
//|    giudicabile. E' scritto qui, nel sorgente, prima dei numeri.   |
//|                                                                  |
//|  FILTRO AMPIEZZA DEL BOX -- InpMinBoxATR, in ATR RELATIVO e MAI   |
//|    in punti assoluti. Il costo di ignorarlo e' gia' stato pagato: |
//|    la soglia in punti del filtro QB ha spento 3 mercati in        |
//|    silenzio (ANALISI_NIGHTLY_PDF par.6.3). Default 0.0 = NEUTRO:     |
//|    la soglia si sceglie DOPO aver misurato la scala reale del     |
//|    rapporto larghezza_box/ATR, non prima.                         |
//|                                                                  |
//|  PROP-HARDENING (obbligatorio)                                    |
//|    - STOP LOSS VERO AL BROKER, strutturale oltre l'estremo dello  |
//|      sweep. PAVIMENTO SL OBBLIGATORIO (R109): InpMinStopPts, MAI  |
//|      zero -> OnInit RIFIUTA se il pavimento e' <= 0.              |
//|    - SIZING A RISCHIO % dalla distanza dello stop. MAI lotto      |
//|      fisso.                                                       |
//|    - NIENTE martingala/griglia/recovery/DCA/mediazione/hedge/     |
//|      stop virtuale: ingresso SINGOLO, una posizione per magic,    |
//|      nessuna aggiunta su posizione aperta.                        |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay) + consumo del lato: un  |
//|      lato che ha gia' prodotto un trade e' chiuso per la          |
//|      giornata.                                                    |
//|    - FLAT DI FINE SEDUTA A DUE TEMPI: orario + flat di RECUPERO   |
//|      per posizioni aperte in un GIORNO PRECEDENTE (misurato il    |
//|      31/08 su un altro motore: 28 posizioni su 460 erano          |
//|      sopravvissute al flat serale perche' il mercato non aveva    |
//|      tick fra il flat e la mezzanotte). Mai overnight.            |
//|    - Guardian del conto (fail-open nel tester), filtro spread,    |
//|      export per-trade CSV, OPTFRAME, AUTOTEST del nucleo.         |
//|                                                                  |
//|  FUSO ORARIO -- CRITICO, E DICHIARATO QUI.                        |
//|    TUTTE le ore di questo EA sono in ORA SERVER BCM, che e' ORA   |
//|    ITALIANA MENO UN'ORA (CLAUDE.md, regola fissa). Non sono ore   |
//|    italiane e non sono ore ET. Sono tutte INPUT.                  |
//|      box notturno   23:00 -> 04:59 SERVER  (00:00 -> 05:59 IT, = 770411)    |
//|      finestra oper. 08:00 -> 17:30 SERVER  (09:00 -> 18:30 IT)    |
//|    L'08:00 server e' l'apertura del DAX (CLAUDE.md); il 17:30     |
//|    server e' l'ora del flat gia' usata dalla sedia viva 770411    |
//|    sullo stesso simbolo, cosi' i due motori sono confrontabili.   |
//|    ATTENZIONE: La finestra del box e' quella del PDF di corso [PAG 26/28],  |
//|    dedotta dagli screenshot .bcm: la domanda D1 del referto       |
//|    ANALISI_NIGHTLY_PDF resta APERTA a Claudio. Se D1 dice che il  |
//|    corso parlava in ora italiana, la finestra va spostata di      |
//|    un'ora -- ed e' un input, non una riga di codice.              |
//|                                                                  |
//|  CONVERSIONE PUNTI: su indici US 1 punto indice = 100 punti MT5   |
//|    (_Point) (R97). Le distanze operative (buffer SL, pavimento)   |
//|    sono in PUNTI MT5; il take esportato nel per-trade CSV e' in   |
//|    PUNTI INDICE, convertito con InpMT5PerPuntoIndice, perche' il  |
//|    cancello C2 del round e' "mediana del take LORDO >= 3x lo      |
//|    spread" e si legge in punti indice.                            |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Armamento e grilletto si valutano    |
//|    sulla barra appena chiusa (shift 1); l'ordine parte            |
//|    all'apertura della barra 0. Niente look-ahead, niente repaint. |
//|                                                                  |
//|  TIMEFRAME DI LAVORO: M15. Il box si legge dalle barre M1, quindi |
//|    il tester deve avere la storia M1 (modello a tick reali la     |
//|    fornisce). DEMO. Nessuna garanzia.                             |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in        |
//|    forward finche' un round a TICK REALI non lo promuove, e la    |
//|    promozione richiede l'ablazione qui sopra. File prova:        |
//|    backtest_pipeline/prove/ABTG_BreakinBox.txt (gamba A) e        |
//|    ABTG_BreakinBox_RRFISSO.txt (gamba B); riga di lancio:         |
//|    backtest_pipeline/righe/RIGA_BREAKIN.ps1.                      |
//|                                                                  |
//|  ASCII puro (regola di casa): niente accenti e niente emoji       |
//|    dentro le stringhe. NON compilato ne' testato da chi ha        |
//|    scritto il file: compilare in MetaEditor (F7) e validare nel   |
//|    tester.                                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - BREAKIN del box notturno (spec di casa ANALISI_NIGHTLY_PDF 23/08, dossier CACCIA_CRT_SECONDA 31/08)"
#property version   "1.00"
#property strict
#property description "BREAKIN del box notturno: falsa rottura del range 23:00-04:59 SERVER (il box della sedia 770411), ingresso DIFFERITO su conferma nella sessione europea."
#property description "ABLAZIONE OBBLIGATORIA: InpTP_RR=0 (TP al lato opposto del box, la tesi) contro InpTP_RR>0 (RR fisso, il controllo R95)."
#property description "Tutte le ore sono in ORA SERVER BCM (ora italiana meno un'ora). DEMO, nessuna garanzia."

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Il default true NON cambia niente da solo: se il Guardian non gira
//    su questo conto -- e nel Strategy Tester, dove le sue GlobalVariable
//    non esistono -- la guardia lascia passare tutto (fail-open). I
//    backtest restano confrontabili con quelli degli altri EA di casa.
//    Blocca soltanto l'APERTURA di nuovo rischio: mai le uscite.
input bool InpUsaGuardian = true;   // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)

input group "=== BOX NOTTURNO -- il livello (ORA SERVER BCM = ora IT - 1) ==="
input int    InpBoxStartHour   = 23;   // Ora inizio box (SERVER). 23 server = 00:00 IT -- IDENTICO alla sedia 770411 (R103): mutua esclusivita LETTERALE
input int    InpBoxStartMin    = 0;    // Minuto inizio box
input int    InpBoxEndHour     = 4;    // Ora fine box (SERVER). 4:59 server = 05:59 IT
input int    InpBoxEndMin      = 59;   // Minuto fine box
input int    InpMinBarreBox    = 120;  // Barre M1 MINIME dentro la finestra (anti-box-fantasma di festivi/gap)

input group "=== FILTRO AMPIEZZA DEL BOX -- in ATR RELATIVO, MAI in punti ==="
input double InpMinBoxATR      = 0.0;  // Larghezza box MINIMA in multipli di ATR (0 = NEUTRO/off, default dichiarato)
input ENUM_TIMEFRAMES InpAtrTF = PERIOD_D1; // TF dell'ATR di riferimento (D1: il box vale una frazione del range giornaliero)
input int    InpAtrPeriod      = 14;   // Periodo dell'ATR di riferimento

input group "=== FINESTRA OPERATIVA -- sessione europea (ORA SERVER BCM) ==="
input int    InpOpStartHour    = 8;    // Ora inizio operativita' (SERVER). 8 server = 09:00 IT = apertura DAX
input int    InpOpStartMin     = 0;    // Minuto inizio operativita'
input int    InpCloseHour      = 17;   // Ora del FLAT di fine seduta (SERVER). 17:30 server = 18:30 IT
input int    InpCloseMin       = 30;   // Minuto del FLAT di fine seduta
input bool   InpCloseAtEnd     = true; // FLAT obbligatorio a fine seduta: MAI overnight (il box di stanotte non vale domani)

input group "=== GRILLETTO -- falsa rottura con ingresso DIFFERITO ==="
input int    InpMinBarreRientro = 1;   // Barre MINIME fra la chiusura FUORI e la chiusura DENTRO (>=1: l'ingresso e' DIFFERITO)
input int    InpConfirmMaxBars  = 8;   // Barre entro cui il rientro deve arrivare, poi l'armamento SCADE (0 = mai)
input bool   InpAllowLong        = true;  // Ammetti i LONG (falsa rottura del MIN notte). I lati si misurano SEPARATI (regola 25/08)
input bool   InpAllowShort       = true;  // Ammetti gli SHORT (falsa rottura del MAX notte)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlBufferPts    = 300;  // SL oltre l'estremo dello SWEEP, in PUNTI MT5 (3 punti indice su US)
input int    InpMinStopPts     = 500;  // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 punti indice). MAI 0.

input group "=== TAKE PROFIT -- QUI STA L'ABLAZIONE OBBLIGATORIA ==="
input double InpTP_RR          = 0.0;  // 0 = TP al LATO OPPOSTO DEL BOX (la tesi); >0 = RR fisso sulla distanza SL (il CONTROLLO = R95)

input group "=== Rischio e cap ==="
input double InpRiskPercent    = 0.65; // Rischio per trade, % del saldo (default di casa)
input int    InpMaxTradesPerDay = 2;   // Max ingressi ESEGUITI al giorno (0 = illimitato). Il box ha 2 lati: 2 e' il tetto naturale

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice = 100; // Punti MT5 (_Point) per 1 punto indice (indici US: 100)

input group "=== Generali ==="
input string InpComment        = "BRKBOX";  // Commento sugli ordini
input long   InpMagic          = 769700;    // Numero magico (VERIFICATO VERGINE repo-wide il 31/08/2026)
input int    InpMaxSpread      = 0;         // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose        = true;      // Messaggi nel log
input bool   InpAutoTest       = true;      // Stampa le righe [BRKBOX][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico (M15)
int      gAtrHandle = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- STATO DEL BOX E DELL'ARMAMENTO. Si azzera al cambio di giornata di
//    box: i livelli della notte scorsa non valgono per la notte dopo.
long     gGiornoBox   = 0;              // chiave di calendario della giornata di box in corso
bool     gArmatoAlto  = false;          // una barra ha CHIUSO sopra il MAX notte
bool     gArmatoBasso = false;          // una barra ha CHIUSO sotto il MIN notte
int      gEtaAlto     = 0;              // barre trascorse dall'armamento (0 = barra dell'armamento)
int      gEtaBasso    = 0;
double   gSweepHigh   = 0;              // estremo massimo toccato mentre si stava sopra il box
double   gSweepLow    = 0;              // estremo minimo toccato mentre si stava sotto il box
bool     gUsatoAlto   = false;          // il lato ha gia' prodotto un trade oggi: consumato
bool     gUsatoBasso  = false;

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE cancello
//    ferma le barre. L'ordine QUI, in OnTester e nell'header di
//    OnTesterDeinit si toccano SEMPRE INSIEME: una colonna aggiunta a uno
//    solo sfasa tutto il CSV (classe pagata due volte il 31/08).
long gCntOnNewBar    = 0;
long gCntGestione    = 0;   // c'era posizione aperta (una per magic)
long gCntFuoriFin    = 0;   // barra fuori dalla finestra operativa
long gCntNoBox       = 0;   // box non calcolabile (dati M1 assenti o barre sotto il minimo)
long gCntBoxStretto  = 0;   // il filtro InpMinBoxATR ha spento la giornata
long gCntMaxTrades   = 0;   // c'era un segnale ma il cap giornaliero era pieno
long gCntSpread      = 0;   // c'era un segnale ma lo spread era fuori soglia
long gCntBreachAlto  = 0;   // armamenti lato ALTO (chiusure sopra il MAX notte)
long gCntBreachBasso = 0;   // armamenti lato BASSO (chiusure sotto il MIN notte)
long gCntScaduti     = 0;   // armamenti SCADUTI senza rientro (falsa rottura mai fallita)
long gCntAmbiguo     = 0;   // tutti e due i lati pronti sulla stessa barra: nessun trade (difensivo)
long gCntTpDegenere  = 0;   // TP dalla parte sbagliata o troppo vicino: trade saltato
long gCntShortCand   = 0;   // candidati SHORT
long gCntLongCand    = 0;   // candidati LONG
long gCntApri        = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[BRKBOX] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono: e' questa la parte
//   che l'AUTOTEST interroga a tavolino, senza mercato.
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
//| Un istante (in minuti del giorno) e' DENTRO la finestra? [start,end)|
//| La barra che APRE all'ora di fine NON e' dentro (li' scatta il     |
//| flat). Il ramo con lo scavalco della mezzanotte c'e' per difesa:   |
//| la finestra OPERATIVA di casa non lo usa (il BOX invece scavalca,  |
//| ma il box si calcola per TIMESTAMP, non con questa funzione).      |
//+------------------------------------------------------------------+
bool InFinestra_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);
  }

//+------------------------------------------------------------------+
//| Chiave di calendario (anno*10000+mese*100+giorno): confrontabile   |
//| con <, robusta a cavallo di mese e di anno (dove il day_of_year    |
//| fallirebbe). Serve al flat di RECUPERO e al reset del box.         |
//+------------------------------------------------------------------+
long GiornoChiave_Calc(const int anno,const int mese,const int giorno)
  {
   return((long)anno*10000 + (long)mese*100 + (long)giorno);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - nucleo puro. Vero quando l'ora corrente ha   |
//| raggiunto o superato l'ora di fine seduta (confronto in minuti).   |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| IL BOX E' OPERABILE? Larghezza valida E, se la soglia e' accesa,   |
//| larghezza >= soglia x ATR. La soglia e' in ATR RELATIVO: con 0     |
//| il filtro e' NEUTRO (ablazione con/senza, regola di casa). Se      |
//| l'ATR non e' disponibile (<=0) e la soglia e' accesa si RIFIUTA:   |
//| meglio non operare che operare con un filtro cieco (lezione del    |
//| filtro QB che ha spento 3 mercati in silenzio).                    |
//+------------------------------------------------------------------+
bool BoxOk_Calc(const double boxHigh,const double boxLow,
                const double atr,const double minBoxAtr)
  {
   if(boxHigh<=boxLow) return(false);
   if(minBoxAtr<=0)    return(true);          // filtro neutro: passa sempre
   if(atr<=0)          return(false);         // filtro acceso ma cieco: non si opera
   return((boxHigh-boxLow) >= minBoxAtr*atr);
  }

//+------------------------------------------------------------------+
//| ARMAMENTO: la barra chiusa ha CHIUSO FUORI dal box?                |
//|   +1 = chiusura SOPRA il MAX notte (si arma il lato ALTO)          |
//|   -1 = chiusura SOTTO il MIN notte (si arma il lato BASSO)         |
//|    0 = chiusura dentro il box                                      |
//| Si pretende la CHIUSURA fuori, non il semplice tocco: e' il        |
//| momento in cui il BREAKOUT e' "accettato" dal mercato -- ed e'     |
//| esattamente dove entra la sedia viva 770411. Noi aspettiamo che    |
//| fallisca.                                                          |
//+------------------------------------------------------------------+
int Armamento_Calc(const double barClose,const double boxHigh,const double boxLow)
  {
   if(barClose > boxHigh) return(+1);
   if(barClose < boxLow)  return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| IL GRILLETTO DIFFERITO - il cuore del motore.                      |
//|   SHORT: lato ALTO armato da almeno minBarre barre E la barra      |
//|          appena chiusa RICHIUDE DENTRO (close < boxHigh)           |
//|   LONG : lato BASSO armato da almeno minBarre barre E la barra     |
//|          appena chiusa RICHIUDE DENTRO (close > boxLow)            |
//| Se sono pronti tutti e due (giornata che ha rotto e fallito da     |
//| entrambe le parti) si risponde 0: DIFENSIVO e dichiarato, il caso  |
//| ha il suo contatore (gCntAmbiguo) e si legge nell'OPTFRAME.        |
//| I lati spenti (allowLong/allowShort) escono qui, non a valle:      |
//| cosi' misurare un lato solo non cambia il comportamento dell'altro.|
//+------------------------------------------------------------------+
int SegnaleBreakin_Calc(const bool armatoAlto,const int etaAlto,
                        const bool armatoBasso,const int etaBasso,
                        const double barClose,
                        const double boxHigh,const double boxLow,
                        const int minBarre,
                        const bool allowLong,const bool allowShort)
  {
   bool shortPronto = (armatoAlto  && etaAlto  >= minBarre && barClose < boxHigh);
   bool longPronto  = (armatoBasso && etaBasso >= minBarre && barClose > boxLow);
   if(shortPronto && longPronto) return(0);   // ambiguo: nessun trade
   if(shortPronto) return(allowShort ? -1 : 0);
   if(longPronto)  return(allowLong  ? +1 : 0);
   return(0);
  }

//+------------------------------------------------------------------+
//| SL oltre l'ESTREMO DELLO SWEEP (il punto piu' lontano raggiunto    |
//| mentre il prezzo stava fuori dal box), di buffer.                  |
//|   long  -> sweepLow  - buffer                                      |
//|   short -> sweepHigh + buffer                                      |
//+------------------------------------------------------------------+
double SlSweep_Calc(const bool isLong,const double sweepLow,
                    const double sweepHigh,const double buffer)
  {
   return(isLong ? sweepLow-buffer : sweepHigh+buffer);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109). Se lo stop e' piu' vicino del         |
//| pavimento, si ALLARGA al pavimento; non si salta il trade e non    |
//| si lascia lo stop a zero. pavimento<=0 -> invariato (ma il         |
//| chiamante garantisce > 0).                                         |
//+------------------------------------------------------------------+
double PavimentoSL_Calc(const bool isLong,const double entry,
                        const double slGrezzo,const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R>=pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| IL TAKE PROFIT - E' QUI L'ABLAZIONE OBBLIGATORIA DEL ROUND.        |
//|   rr <= 0  -> TP al LATO OPPOSTO DEL BOX (LA TESI: il take e'      |
//|               grande quanto il box, la durata e' una sessione)     |
//|   rr >  0  -> TP a RR fisso sulla distanza dello stop (IL          |
//|               CONTROLLO: e' la geometria di R95, 30 passate su 30  |
//|               in perdita). Se vince questo, il capitolo si chiude. |
//+------------------------------------------------------------------+
double TpBreakin_Calc(const bool isLong,const double entry,const double distSL,
                      const double boxHigh,const double boxLow,const double rr)
  {
   if(rr>0) return(isLong ? entry+rr*distSL : entry-rr*distSL);
   return(isLong ? boxHigh : boxLow);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE.                   |
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
   gTF = (ENUM_TIMEFRAMES)Period();

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- ORARI: tutti in ORA SERVER BCM (ora italiana meno un'ora).
   if(InpBoxStartHour<0 || InpBoxStartHour>23 || InpBoxStartMin<0 || InpBoxStartMin>59)
     { Print("ERRORE: ora/minuto di inizio box fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpBoxEndHour<0 || InpBoxEndHour>23 || InpBoxEndMin<0 || InpBoxEndMin>59)
     { Print("ERRORE: ora/minuto di fine box fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpBoxStartHour,InpBoxStartMin) == MinutiDelGiorno_Calc(InpBoxEndHour,InpBoxEndMin))
     { Print("ERRORE: il box notturno ha ampiezza zero (inizio uguale alla fine)."); return(INIT_FAILED); }
   if(InpMinBarreBox<1)
     { Print("ERRORE: InpMinBarreBox deve essere >= 1 (un box va costruito su barre vere, non su un gap)."); return(INIT_FAILED); }

   if(InpOpStartHour<0 || InpOpStartHour>23 || InpOpStartMin<0 || InpOpStartMin>59)
     { Print("ERRORE: ora/minuto di inizio finestra operativa fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpOpStartHour,InpOpStartMin) >= MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin))
     { Print("ERRORE: la finestra operativa NON attraversa la mezzanotte: l'inizio deve precedere il flat."); return(INIT_FAILED); }
   //--- il livello deve essere CHIUSO prima di operarci: e' l'asse
   //    "ingresso DIFFERITO" che distingue questo motore da R95.
   if(MinutiDelGiorno_Calc(InpOpStartHour,InpOpStartMin) <= MinutiDelGiorno_Calc(InpBoxEndHour,InpBoxEndMin))
     { Print("ERRORE: la finestra operativa deve iniziare DOPO la fine del box: il livello si opera quando e' chiuso."); return(INIT_FAILED); }

   if(InpMinBoxATR<0)
     { Print("ERRORE: InpMinBoxATR non puo' essere negativo (0 = filtro neutro)."); return(INIT_FAILED); }
   if(InpAtrPeriod<2)
     { Print("ERRORE: InpAtrPeriod deve essere >= 2."); return(INIT_FAILED); }
   gAtrHandle = iATR(_Symbol, InpAtrTF, InpAtrPeriod);
   if(gAtrHandle==INVALID_HANDLE)
     { Print("ERRORE: impossibile creare l'handle ATR di riferimento."); return(INIT_FAILED); }

   //--- >=1 e' load-bearing: e' l'INGRESSO DIFFERITO. Con 0 il motore
   //    diventerebbe "buca e richiude nella stessa barra", cioe' R95.
   if(InpMinBarreRientro<1)
     { Print("ERRORE: InpMinBarreRientro deve essere >= 1: l'ingresso di questo motore e' DIFFERITO per costruzione (con 0 sarebbe R95, gia' misurato 0/30)."); return(INIT_FAILED); }
   if(InpConfirmMaxBars<0)
     { Print("ERRORE: InpConfirmMaxBars non puo' essere negativo (0 = l'armamento non scade mai)."); return(INIT_FAILED); }
   if(InpConfirmMaxBars>0 && InpConfirmMaxBars<InpMinBarreRientro)
     { Print("ERRORE: InpConfirmMaxBars < InpMinBarreRientro: l'armamento scadrebbe prima di poter confermare."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }

   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. Load-bearing.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpTP_RR<0)
     { Print("ERRORE: InpTP_RR non puo' essere negativo (0 = TP al lato opposto del box)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0 (mai lotto fisso)."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(!InpCloseAtEnd)
      Print("[BRKBOX] ATTENZIONE: InpCloseAtEnd=false -> nessun flat forzato. Il box di stanotte non vale domani: usare solo per misura, non in reale.");

   if(InpAutoTest) AutoTestBreakin();

   Log(StringFormat("avviato su %s %s. Box SERVER %02d:%02d-%02d:%02d (min %d barre M1), finestra operativa SERVER %02d:%02d-%02d:%02d, rientro differito >=%d barre entro %d, SL sweep+%d pti MT5 con pavimento %d, TP %s, rischio %.2f%%, cap %d/gg, magic %I64d.",
       _Symbol, EnumToString(gTF),
       InpBoxStartHour, InpBoxStartMin, InpBoxEndHour, InpBoxEndMin, InpMinBarreBox,
       InpOpStartHour, InpOpStartMin, InpCloseHour, InpCloseMin,
       InpMinBarreRientro, InpConfirmMaxBars,
       InpSlBufferPts, InpMinStopPts,
       (InpTP_RR>0 ? StringFormat("RR fisso %.2f (CONTROLLO = geometria R95)", InpTP_RR) : "LATO OPPOSTO DEL BOX (LA TESI)"),
       InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   Log("ORE IN ORA SERVER BCM (ora italiana meno un'ora): non sono ore italiane e non sono ore ET.");
   Log("ABLAZIONE OBBLIGATORIA del round: InpTP_RR=0 (lato opposto del box) CONTRO InpTP_RR>0 (RR fisso). Se vince l'RR fisso e' R95 con un livello nuovo e il capitolo si chiude.");
   Log(StringFormat("FILTRO AMPIEZZA BOX: %s (ATR %s x %d).",
       (InpMinBoxATR>0 ? StringFormat("ACCESO, box >= %.2f x ATR", InpMinBoxATR) : "NEUTRO (0): si misura la scala prima di scegliere la soglia"),
       EnumToString(InpAtrTF), InpAtrPeriod));
   Log("Ingresso SINGOLO: niente mediazione/martingala/griglia/recovery, nessuna aggiunta su posizione aperta.");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(gAtrHandle!=INVALID_HANDLE){ IndicatorRelease(gAtrHandle); gAtrHandle=INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

   if(FlatFineSedutaCheck()) return;   // fine seduta: chiudo tutto e non riapro

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

//==================================================================
//  IL LIVELLO - il BOX NOTTURNO, ricalcolato dai dati e senza stato
//  persistente (sopravvive a un riavvio a meta' giornata).
//==================================================================
//+------------------------------------------------------------------+
//| MAX/MIN del box notturno che si e' CHIUSO piu' di recente rispetto |
//| a "adesso". Pattern riusato da ABTG_MaxMinNotte (ComputeBox):      |
//| si costruiscono i due timestamp sul giorno corrente e, se l'inizio |
//| non precede la fine, l'inizio scende al giorno prima (la notte     |
//| scavalca la mezzanotte). Le barre si contano su M1.                |
//| Restituisce anche QUANTE barre M1 esistono nella finestra: un box  |
//| costruito su tre barre di un festivo non e' un box.                |
//+------------------------------------------------------------------+
bool CalcolaBoxNotturno(double &hi,double &lo,int &barre)
  {
   hi=0; lo=0; barre=0;
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpBoxEndHour;   t.min=InpBoxEndMin;   datetime tEnd  =StructToTime(t);
   t.hour=InpBoxStartHour; t.min=InpBoxStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;             // il box inizia la sera prima

   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,  false);
   if(iS<0 || iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);

   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW ,count,start);
   if(hIdx<0 || lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   barre=count;
   return(hi>0 && lo>0 && hi>lo && barre>=InpMinBarreBox);
  }

//+------------------------------------------------------------------+
//| ATR di riferimento (TF e periodo da input), allo shift 1 = ultima  |
//| barra CHIUSA di quel TF. Serve solo al filtro ampiezza del box.    |
//+------------------------------------------------------------------+
double AtrRiferimento()
  {
   double b[];
   if(CopyBuffer(gAtrHandle, 0, 1, 1, b) < 1) return(0);
   return(b[0]>0 ? b[0] : 0);
  }

//==================================================================
//  IL GIRO DI UNA BARRA NUOVA
//  Si valuta la barra APPENA CHIUSA (shift 1); l'ordine parte al
//  mercato all'apertura della barra 0. Niente look-ahead.
//==================================================================
void OnNewBar()
  {
   gCntOnNewBar++;

   //--- UNA POSIZIONE PER MAGIC. Nota dichiarata: mentre una posizione e'
   //    aperta gli armamenti dell'ALTRO lato NON invecchiano (questa
   //    funzione esce subito). L'effetto e' CONSERVATIVO -- l'eta' resta
   //    indietro, quindi semmai l'ingresso e' piu' tardi e la scadenza piu'
   //    lontana, mai il contrario -- e comunque il cap giornaliero e il
   //    consumo del lato limitano il caso a un solo trade residuo.
   if(CountPositions()>0){ gCntGestione++; return; }

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);

   //--- reset dello stato al cambio di giornata di box: i livelli della
   //    notte scorsa non valgono per la notte dopo.
   long chiaveOggi = GiornoChiave_Calc(now.year, now.mon, now.day);
   if(chiaveOggi != gGiornoBox) ResetGiornataBox(chiaveOggi);

   //--- FINESTRA OPERATIVA: fuori non si valuta NIENTE (nemmeno gli
   //    armamenti). Il box si opera nella sessione europea, quando il
   //    livello e' chiuso: e' l'asse "ingresso differito" del motore.
   if(!InFinestraOperativa(TimeCurrent())){ gCntFuoriFin++; return; }

   double boxHigh=0, boxLow=0; int barreBox=0;
   if(!CalcolaBoxNotturno(boxHigh, boxLow, barreBox)){ gCntNoBox++; return; }
   if(!BoxOk_Calc(boxHigh, boxLow, AtrRiferimento(), InpMinBoxATR)){ gCntBoxStretto++; return; }

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0){ gCntNoBox++; return; }

   //--- 1) PRIMA si aggiorna lo stato di armamento con la barra appena
   //    chiusa, POI si valuta il grilletto. L'ordine e' load-bearing e va
   //    letto insieme al conto delle barre:
   //      barra N   -> chiude FUORI: si ARMA, eta' = 0. Il grilletto vede
   //                   eta' 0 < InpMinBarreRientro (>=1) -> nessun trade,
   //                   e comunque quella barra ha chiuso fuori.
   //      barra N+1 -> eta' diventa 1: se questa barra RICHIUDE DENTRO il
   //                   grilletto scatta. E' la PRIMA barra che puo'
   //                   entrare, ed e' una barra DIVERSA da quella che ha
   //                   armato: l'ingresso e' DIFFERITO per costruzione.
   //    Con l'ordine invertito InpMinBarreRientro=1 avrebbe voluto dire
   //    "due barre dopo": un fuori-di-uno silenzioso sull'unico asse che
   //    distingue questo motore da R95.
   //    NOTA dichiarata: nella stessa barra un lato non puo' SCADERE e
   //    RI-ARMARSI (e' una catena if/else-if). Il ri-armamento e'
   //    possibile dalla barra dopo.
   AggiornaArmamento(barHigh, barLow, barClose, boxHigh, boxLow);

   //--- 2) IL GRILLETTO, sullo stato appena aggiornato.
   int sig = SegnaleBreakin_Calc(gArmatoAlto, gEtaAlto, gArmatoBasso, gEtaBasso,
                                 barClose, boxHigh, boxLow,
                                 InpMinBarreRientro, InpAllowLong, InpAllowShort);

   //--- diagnostica del caso ambiguo (tutti e due i lati pronti sulla
   //    stessa barra): SegnaleBreakin_Calc risponde 0, qui si CONTA.
   bool shortPronto = (gArmatoAlto  && gEtaAlto  >= InpMinBarreRientro && barClose < boxHigh);
   bool longPronto  = (gArmatoBasso && gEtaBasso >= InpMinBarreRientro && barClose > boxLow);
   if(shortPronto && longPronto) gCntAmbiguo++;

   if(sig==0) return;

   //--- 3) i cancelli operativi si contano SOLO quando c'era un segnale
   //    vero: cosi' l'imbuto nell'OPTFRAME si legge senza ambiguita'.
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }

   bool isLong = (sig>0);
   if(isLong) gCntLongCand++; else gCntShortCand++;

   gCntApri++;
   if(ApriPosizione(isLong, boxHigh, boxLow))
     {
      //--- IL LATO SI CONSUMA: una falsa rottura per lato al giorno.
      if(isLong){ gArmatoBasso=false; gUsatoBasso=true; }
      else      { gArmatoAlto =false; gUsatoAlto =true; }
     }
  }

//+------------------------------------------------------------------+
//| Azzera lo stato legato alla giornata di box.                      |
//+------------------------------------------------------------------+
void ResetGiornataBox(const long chiave)
  {
   gGiornoBox   = chiave;
   gArmatoAlto  = false; gArmatoBasso = false;
   gEtaAlto     = 0;     gEtaBasso    = 0;
   gSweepHigh   = 0;     gSweepLow    = 0;
   gUsatoAlto   = false; gUsatoBasso  = false;
  }

//+------------------------------------------------------------------+
//| Aggiorna gli armamenti con la barra appena chiusa:                |
//|   - se il lato e' gia' armato: invecchia, allarga l'estremo dello  |
//|     sweep e fa SCADERE l'armamento oltre InpConfirmMaxBars;        |
//|   - se non e' armato e la barra CHIUDE FUORI: arma, salvando       |
//|     l'estremo di QUELLA barra come primo estremo dello sweep.      |
//| Un lato gia' CONSUMATO (ha prodotto il trade di oggi) non si       |
//| ri-arma: e' la regola "il livello vale una volta sola".            |
//+------------------------------------------------------------------+
void AggiornaArmamento(const double barHigh,const double barLow,const double barClose,
                       const double boxHigh,const double boxLow)
  {
   int fuori = Armamento_Calc(barClose, boxHigh, boxLow);

   //--- LATO ALTO
   if(gArmatoAlto)
     {
      gEtaAlto++;
      if(barHigh>gSweepHigh) gSweepHigh=barHigh;
      if(InpConfirmMaxBars>0 && gEtaAlto>InpConfirmMaxBars)
        { gArmatoAlto=false; gCntScaduti++; }
     }
   else if(fuori>0 && !gUsatoAlto)
     {
      gArmatoAlto=true; gEtaAlto=0; gSweepHigh=barHigh;
      gCntBreachAlto++;
     }

   //--- LATO BASSO
   if(gArmatoBasso)
     {
      gEtaBasso++;
      if(gSweepLow<=0 || barLow<gSweepLow) gSweepLow=barLow;
      if(InpConfirmMaxBars>0 && gEtaBasso>InpConfirmMaxBars)
        { gArmatoBasso=false; gCntScaduti++; }
     }
   else if(fuori<0 && !gUsatoBasso)
     {
      gArmatoBasso=true; gEtaBasso=0; gSweepLow=barLow;
      gCntBreachBasso++;
     }
  }

//==================================================================
//  ORARI (tutti in ORA SERVER BCM = ora italiana meno un'ora)
//==================================================================
int MinutiStartOperativa(){ return(MinutiDelGiorno_Calc(InpOpStartHour,InpOpStartMin)); }
int MinutiFlat()          { return(MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin)); }

bool InFinestraOperativa(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return(InFinestra_Calc(MinutiDelGiorno_Calc(d.hour,d.min), MinutiStartOperativa(), MinutiFlat()));
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TAKE PROFIT veri
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL oltre l'ESTREMO DELLO SWEEP +      |
//| buffer, poi SEMPRE dal PAVIMENTO (mai a zero, mai dentro lo         |
//| stops-level del broker). TP dall'ablazione (lato opposto del box    |
//| oppure RR fisso). Il lotto esce da LotByRisk sulla distanza FINALE  |
//| dello stop. Nessuna aggiunta su posizione aperta, mai.              |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong,const double boxHigh,const double boxLow)
  {
   //--- Guardian del conto: blocca solo l'apertura di nuovo rischio.
   //    Fail-open dove il guardiano non gira (tester compreso).
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_BreakinBox")) return(false);

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double sweepLow  = (gSweepLow >0 ? gSweepLow  : boxLow);
   double sweepHigh = (gSweepHigh>0 ? gSweepHigh : boxHigh);

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlSweep_Calc(isLong, sweepLow, sweepHigh, bufferPrezzo);

   //--- PAVIMENTO OBBLIGATORIO (R109): la distanza non e' mai piu' stretta
   //    del pavimento in punti MT5, e mai dentro lo stops-level del broker.
   double pavimento = InpMinStopPts*_Point;
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo: salto per non lasciare lo stop scoperto (R109)."); return(false); }

   double sl = NormalizePrice(PavimentoSL_Calc(isLong, ref, slRaw, pavFinale));
   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- TAKE PROFIT: l'ABLAZIONE. Se il take e' dalla parte sbagliata o
   //    piu' vicino dello stops-level (rientro troppo profondo dentro il
   //    box), il trade si SALTA e si CONTA: non si inventa un TP diverso.
   double tp = NormalizePrice(TpBreakin_Calc(isLong, ref, distSL, boxHigh, boxLow, InpTP_RR));
   double distTP = isLong ? (tp-ref) : (ref-tp);
   if(distTP<=0 || distTP<minBroker)
     {
      gCntTpDegenere++;
      Log(StringFormat("TP degenere (distanza %s, minimo broker %s): salto il trade invece di storcere la geometria.",
          DoubleToString(distTP,_Digits), DoubleToString(minBroker,_Digits)));
      return(false);
     }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp,cm);
   if(ok)
     {
      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      double idxTake = PrezzoInPuntiIndice_Calc(distTP, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP %s lot %.2f (rischio %.1f / take %.1f pti idx | box %s-%s, sweep %s)",
          isLong?"BUY(falsa rottura del MIN notte)":"SELL(falsa rottura del MAX notte)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits), DoubleToString(tp,_Digits),
          lot, idxRisk, idxTake,
          DoubleToString(boxLow,_Digits), DoubleToString(boxHigh,_Digits),
          DoubleToString(isLong?sweepLow:sweepHigh,_Digits)));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   //--- FLAT DI RECUPERO (classe misurata il 31/08 su ABTG_NySessionRetest:
   //    28 posizioni su 460 erano sopravvissute al flat perche' il mercato
   //    NON aveva tick fra l'ora del flat e la mezzanotte -- festivi,
   //    settimane DST, venerdi' corti -- e a mezzanotte la condizione a
   //    ora-del-giorno si RESETTA: chiusure viste alle 23:05, 00:18, 01:34
   //    e perfino 07:15). Il vincolo e' ZERO OVERNIGHT, non "zero overnight
   //    se il calendario collabora": una posizione aperta in un GIORNO
   //    PRECEDENTE si chiude al PRIMO tick disponibile, a qualunque ora.
   bool recupero=false;
   if(InpCloseAtEnd)
     {
      long chiaveOggi=GiornoChiave_Calc(t.year,t.mon,t.day);
      for(int i=PositionsTotal()-1;i>=0;i--)
        {
         ulong p=PositionGetTicket(i);
         if(p==0) continue;
         if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
         if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
         MqlDateTime ta; TimeToStruct((datetime)PositionGetInteger(POSITION_TIME),ta);
         if(GiornoChiave_Calc(ta.year,ta.mon,ta.day) < chiaveOggi){ recupero=true; break; }
        }
      if(recupero)
         Log("flat di RECUPERO: posizione di un giorno precedente ancora aperta (il flat serale non ha avuto tick), chiudo al primo tick disponibile.");
     }
   if(!recupero && !DopoOrarioFlat_Calc(t.hour,t.min,InpCloseHour,InpCloseMin)) return(false);

   //--- oltre l'orario di fine: niente nuovi ingressi. Se InpCloseAtEnd,
   //    chiudo tutto (mai overnight). In ogni caso ritorno true per fermare
   //    la logica di nuova barra.
   if(!InpCloseAtEnd) return(true);

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

   if(t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      gFlatGiorni++;
      if(chiuse>0)
         Log(StringFormat("flat di fine seduta alle %02d:%02d (SERVER): %d posizioni chiuse, niente overnight.",
                          InpCloseHour, InpCloseMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il cap giornaliero conta gli ingressi ESEGUITI, non gli ordini.   |
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
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
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

//--- Lotto dalla distanza dello stop. PERDITA PER LOTTO DAL BROKER
//    (OrderCalcProfit converte in valuta conto); il tick value resta
//    come ripiego. Su un indice la distanza e' in PREZZO.
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
//  AUTOTEST - stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester). F7 compila e basta.
//==================================================================
void AutoTestBreakin()
  {
   int falliti=0;

   PrintFormat("[BRKBOX][AUTOTEST] box %02d:%02d-%02d:%02d SERVER | finestra %02d:%02d-%02d:%02d SERVER | rientro >=%d entro %d | TP %s | %s | magic %I64d",
               InpBoxStartHour,InpBoxStartMin,InpBoxEndHour,InpBoxEndMin,
               InpOpStartHour,InpOpStartMin,InpCloseHour,InpCloseMin,
               InpMinBarreRientro,InpConfirmMaxBars,
               (InpTP_RR>0?"RR FISSO (controllo R95)":"LATO OPPOSTO DEL BOX (tesi)"),
               _Symbol, InpMagic);

   //--- 1. ORARI: minuti del giorno + finestra [start,end)
   int mS=MinutiDelGiorno_Calc(8,0), mE=MinutiDelGiorno_Calc(17,30);
   bool f1=InFinestra_Calc(MinutiDelGiorno_Calc( 8, 0),mS,mE);  // inizio incluso
   bool f2=InFinestra_Calc(MinutiDelGiorno_Calc(12,15),mS,mE);  // dentro
   bool f3=InFinestra_Calc(MinutiDelGiorno_Calc(17,30),mS,mE);  // fine esclusa (li' scatta il flat)
   bool f4=InFinestra_Calc(MinutiDelGiorno_Calc( 7,59),mS,mE);  // prima dell'inizio
   //--- il ramo con scavalco della mezzanotte (difensivo): 22:00 -> 04:59
   int nS=MinutiDelGiorno_Calc(22,0), nE=MinutiDelGiorno_Calc(4,59);
   bool f5=InFinestra_Calc(MinutiDelGiorno_Calc(23,30),nS,nE);  // sera: dentro
   bool f6=InFinestra_Calc(MinutiDelGiorno_Calc( 2, 0),nS,nE);  // notte: dentro
   bool f7=InFinestra_Calc(MinutiDelGiorno_Calc(12, 0),nS,nE);  // mezzogiorno: fuori
   PrintFormat("[BRKBOX][AUTOTEST] orari: inizio=%d(1) dentro=%d(1) fine=%d(0) pre=%d(0) | scavalco sera=%d(1) notte=%d(1) giorno=%d(0)",
               (int)f1,(int)f2,(int)f3,(int)f4,(int)f5,(int)f6,(int)f7);
   if(!(f1 && f2 && !f3 && !f4 && f5 && f6 && !f7)) falliti++;

   //--- 2. CHIAVE DI CALENDARIO + FLAT (flat di recupero a due tempi)
   bool gk1=(GiornoChiave_Calc(2026,1,2)  > GiornoChiave_Calc(2026,1,1));   // giorno dopo
   bool gk2=(GiornoChiave_Calc(2026,2,1)  > GiornoChiave_Calc(2026,1,31));  // cavallo di mese
   bool gk3=(GiornoChiave_Calc(2027,1,1)  > GiornoChiave_Calc(2026,12,31)); // cavallo di anno
   bool gk4=(GiornoChiave_Calc(2026,8,31)== GiornoChiave_Calc(2026,8,31));  // stesso giorno
   bool fl1=DopoOrarioFlat_Calc(17,30,17,30);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(17,29,17,30);   // prima -> no
   bool fl3=DopoOrarioFlat_Calc(21, 0,17,30);   // dopo -> flat
   PrintFormat("[BRKBOX][AUTOTEST] calendario/flat: chiave gg=%d%d%d%d(1111) | flat esatto=%d(1) prima=%d(0) dopo=%d(1)",
               (int)gk1,(int)gk2,(int)gk3,(int)gk4,(int)fl1,(int)fl2,(int)fl3);
   if(!(gk1 && gk2 && gk3 && gk4 && fl1 && !fl2 && fl3)) falliti++;

   //--- 3. FILTRO AMPIEZZA DEL BOX (in ATR RELATIVO, mai in punti)
   bool b1=BoxOk_Calc(110.0,100.0, 20.0, 0.0);   // soglia neutra -> passa
   bool b2=BoxOk_Calc(110.0,100.0, 20.0, 0.5);   // 10 >= 0.5*20 -> passa
   bool b3=BoxOk_Calc(110.0,100.0, 20.0, 1.0);   // 10 <  1.0*20 -> spegne
   bool b4=BoxOk_Calc(110.0,100.0,  0.0, 0.5);   // filtro acceso ma ATR cieco -> NON si opera
   bool b5=BoxOk_Calc(100.0,110.0, 20.0, 0.0);   // box invertito -> falso comunque
   PrintFormat("[BRKBOX][AUTOTEST] box: neutro=%d(1) largo=%d(1) stretto=%d(0) atrCieco=%d(0) invertito=%d(0)",
               (int)b1,(int)b2,(int)b3,(int)b4,(int)b5);
   if(!(b1 && b2 && !b3 && !b4 && !b5)) falliti++;

   //--- 4. ARMAMENTO: serve la CHIUSURA fuori, non il tocco
   int a1=Armamento_Calc(111.0,110.0,100.0);   // chiude sopra -> +1
   int a2=Armamento_Calc( 99.0,110.0,100.0);   // chiude sotto -> -1
   int a3=Armamento_Calc(105.0,110.0,100.0);   // chiude dentro -> 0
   int a4=Armamento_Calc(110.0,110.0,100.0);   // chiude ESATTO sul bordo -> 0 (non e' fuori)
   PrintFormat("[BRKBOX][AUTOTEST] armamento: sopra=%d(1) sotto=%d(-1) dentro=%d(0) bordo=%d(0)", a1,a2,a3,a4);
   if(!(a1==1 && a2==-1 && a3==0 && a4==0)) falliti++;

   //--- 5. IL GRILLETTO DIFFERITO (cuore). Box 100-110, minBarre 1.
   //    short: lato alto armato da 1 barra e la barra richiude dentro
   int g1=SegnaleBreakin_Calc(true ,1,false,0, 105.0, 110.0,100.0, 1, true,true);
   //    long: lato basso armato da 2 barre e la barra richiude dentro
   int g2=SegnaleBreakin_Calc(false,0,true ,2, 105.0, 110.0,100.0, 1, true,true);
   //    armato ma eta' 0 = STESSA BARRA dell'armamento -> 0 (ingresso DIFFERITO)
   int g3=SegnaleBreakin_Calc(true ,0,false,0, 105.0, 110.0,100.0, 1, true,true);
   //    armato, eta' ok, ma la barra NON e' rientrata (chiude ancora sopra) -> 0
   int g4=SegnaleBreakin_Calc(true ,3,false,0, 112.0, 110.0,100.0, 1, true,true);
   //    non armato: rientro senza falsa rottura -> 0
   int g5=SegnaleBreakin_Calc(false,0,false,0, 105.0, 110.0,100.0, 1, true,true);
   //    tutti e due pronti -> 0 (difensivo, dichiarato)
   int g6=SegnaleBreakin_Calc(true ,2,true ,2, 105.0, 110.0,100.0, 1, true,true);
   //    short valido ma AllowShort off -> 0
   int g7=SegnaleBreakin_Calc(true ,1,false,0, 105.0, 110.0,100.0, 1, true,false);
   //    long valido ma AllowLong off -> 0
   int g8=SegnaleBreakin_Calc(false,0,true ,2, 105.0, 110.0,100.0, 1, false,true);
   //    differimento a 3: eta' 2 non basta -> 0
   int g9=SegnaleBreakin_Calc(true ,2,false,0, 105.0, 110.0,100.0, 3, true,true);
   PrintFormat("[BRKBOX][AUTOTEST] grilletto: short=%d(-1) long=%d(1) stessaBarra=%d(0) nonRientra=%d(0) nonArmato=%d(0) ambiguo=%d(0) shortOff=%d(0) longOff=%d(0) differim3=%d(0)",
               g1,g2,g3,g4,g5,g6,g7,g8,g9);
   if(!(g1==-1 && g2==1 && g3==0 && g4==0 && g5==0 && g6==0 && g7==0 && g8==0 && g9==0)) falliti++;

   //--- 6. SL SULLO SWEEP + PAVIMENTO (mai a zero: R109)
   double sl_l=SlSweep_Calc(true ,  99.0,111.0,0.5);   // long  -> 98.50
   double sl_s=SlSweep_Calc(false,  99.0,111.0,0.5);   // short -> 111.50
   double p1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double p2=PavimentoSL_Calc(true ,100.0, 97.0,2.0);  // gia' oltre  -> 97.00
   double p3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short       -> 102.00
   double p4=PavimentoSL_Calc(false,100.0,104.0,2.0);  // gia' oltre  -> 104.00
   PrintFormat("[BRKBOX][AUTOTEST] SL: long=%.2f(98.50) short=%.2f(111.50) | pav %.2f(98.00) %.2f(97.00) %.2f(102.00) %.2f(104.00)",
               sl_l,sl_s,p1,p2,p3,p4);
   if(!(MathAbs(sl_l-98.5)<1e-6 && MathAbs(sl_s-111.5)<1e-6 &&
        MathAbs(p1-98.0)<1e-6 && MathAbs(p2-97.0)<1e-6 &&
        MathAbs(p3-102.0)<1e-6 && MathAbs(p4-104.0)<1e-6)) falliti++;

   //--- 7. IL TP: L'ABLAZIONE. Box 100-110, entry 104, distSL 2.
   double t1=TpBreakin_Calc(false,104.0,2.0,110.0,100.0,0.0);  // short, lato opposto -> 100.00
   double t2=TpBreakin_Calc(true ,104.0,2.0,110.0,100.0,0.0);  // long,  lato opposto -> 110.00
   double t3=TpBreakin_Calc(false,104.0,2.0,110.0,100.0,2.0);  // short, RR 2 -> 100.00
   double t4=TpBreakin_Calc(true ,104.0,2.0,110.0,100.0,2.0);  // long,  RR 2 -> 108.00
   double t5=TpBreakin_Calc(true ,104.0,2.0,110.0,100.0,4.0);  // long,  RR 4 -> 112.00 (oltre il box: e' il CONTROLLO, non la tesi)
   //--- conversione in punti indice (il cancello C2 si legge in punti indice)
   double c1=PrezzoInPuntiIndice_Calc(6.0,100.0,0.01);   // 6.0
   double c2=PrezzoInPuntiIndice_Calc(6.0,  0.0,0.01);   // denominatore nullo -> 0
   PrintFormat("[BRKBOX][AUTOTEST] TP: boxShort=%.2f(100.00) boxLong=%.2f(110.00) | rrShort=%.2f(100.00) rrLong=%.2f(108.00) rr4=%.2f(112.00) | conv=%.2f(6.00) convKo=%.2f(0.00)",
               t1,t2,t3,t4,t5,c1,c2);
   if(!(MathAbs(t1-100.0)<1e-6 && MathAbs(t2-110.0)<1e-6 &&
        MathAbs(t3-100.0)<1e-6 && MathAbs(t4-108.0)<1e-6 && MathAbs(t5-112.0)<1e-6 &&
        MathAbs(c1-6.0)<1e-6 && MathAbs(c2-0.0)<1e-6)) falliti++;

   Print("[BRKBOX][AUTOTEST] esito motore: ", (falliti==0
         ? "SETTE BLOCCHI SU SETTE, il motore ragiona come la spec."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. In backtest singolo e'       //
//  inerte (gira solo in ottimizzazione).                           //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE per il PASSO 0 in Common\Files. Ogni riga = una  |
//| posizione CHIUSA, con PREZZO D'INGRESSO E DI USCITA, per calcolare |
//| la mediana del take in PUNTI INDICE prima di leggere qualunque PF. |
//| La colonna open_time serve a distinguere una chiusura TARDIVA MA   |
//| IN GIORNATA (regolare: il flat e' scattato al primo tick utile) da |
//| un OVERNIGHT VERO (close_date > open_date), che va contato e       |
//| dichiarato col suo gap-risk.                                       |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   int nd=HistoryDealsTotal();

   long   idIn[];   double pxIn[];   long dirIn[];   string cmIn[];   long tmIn[];
   int    cIn=0;
   ArrayResize(idIn,nd); ArrayResize(pxIn,nd); ArrayResize(dirIn,nd); ArrayResize(cmIn,nd);
   ArrayResize(tmIn,nd);
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      idIn[cIn]  = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      pxIn[cIn]  = HistoryDealGetDouble (tk,DEAL_PRICE);
      dirIn[cIn] = HistoryDealGetInteger(tk,DEAL_TYPE);   // BUY entry = long
      cmIn[cIn]  = HistoryDealGetString (tk,DEAL_COMMENT);
      tmIn[cIn]  = HistoryDealGetInteger(tk,DEAL_TIME);   // open_time
      cIn++;
     }

   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   //--- R82 / checklist 41: il nome contiene il MAGIC, non la FINESTRA. Una
   //    passata SENZA uscite (gamba OOS degenere di FrazioneIS 1.0, cella muta,
   //    finestra vuota) NON deve TRONCARE il per-trade gia' scritto da una
   //    passata buona con lo stesso magic. Se il file non c'e', si scrive
   //    l'intestazione da sola: "girata e zero trade" resta distinguibile.
   int nOut=0;
   for(int j=0;j<nd;j++)
     {
      ulong tj=HistoryDealGetTicket(j);
      if(tj==0) continue;
      if(HistoryDealGetInteger(tj,DEAL_MAGIC)!=InpMagic) continue;
      long ej=HistoryDealGetInteger(tj,DEAL_ENTRY);
      if(ej==DEAL_ENTRY_OUT || ej==DEAL_ENTRY_OUT_BY) nOut++;
     }
   if(nOut<=0 && FileIsExist(fn,FILE_COMMON))
     {
      PrintFormat("[BRKBOX] per-trade: 0 uscite in questa passata, %s NON toccato (mai troncare il per-trade di un'altra finestra).",fn);
      return;
     }
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","open_time","symbol","magic","position_id","dir","volume",
             "entry_price","exit_price","take_idx_pts","net_profit","comment");

   double den = InpMT5PerPuntoIndice*_Point;
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;

      long   posId = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      double pxOut = HistoryDealGetDouble (tk,DEAL_PRICE);
      double net   = HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);

      double pxEntry=0; long dir=-1; string cm=""; long tmEntry=0; bool trovato=false;
      for(int k=0;k<cIn;k++)
         if(idIn[k]==posId){ pxEntry=pxIn[k]; dir=dirIn[k]; cm=cmIn[k]; tmEntry=tmIn[k]; trovato=true; break; }

      bool isLong = (dir==DEAL_TYPE_BUY);
      double takeIdx = 0;
      if(trovato && den>0)
        {
         double mossaPrezzo = isLong ? (pxOut-pxEntry) : (pxEntry-pxOut);
         takeIdx = mossaPrezzo/den;
        }

      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                (trovato ? TimeToString((datetime)tmEntry,TIME_DATE|TIME_MINUTES|TIME_SECONDS) : "?"),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(InpMagic),
                IntegerToString(posId),
                (trovato ? (isLong?"LONG":"SHORT") : "?"),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(pxEntry,_Digits),
                DoubleToString(pxOut,_Digits),
                DoubleToString(takeIdx,1),
                DoubleToString(net,2),
                cm);
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[28];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che rispondono "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
   //--- le tre colonne di COLLAUDO (gate, non merito)
   stats[10] = (double)gAutotestFalliti;   // 0 = passati; >0 = DIVERGE; -1 = non eseguito
   stats[11] = (double)gFlatGiorni;        // giornate col flat scattato
   stats[12] = (double)gFlatChiusure;      // posizioni chiuse dal flat
   //--- DIAGNOSTICA: i contatori per-cancello di OnNewBar, in coda.
   //    L'ordine QUI e nell'header/row di OnTesterDeinit si toccano SEMPRE
   //    INSIEME (una colonna aggiunta a uno solo sfasa tutto il CSV: la
   //    classe 27!=26 e' gia' stata pagata due volte il 31/08).
   stats[13] = (double)gCntOnNewBar;       // OnNewBar Chiamate
   stats[14] = (double)gCntGestione;       // Ret Gestione
   stats[15] = (double)gCntFuoriFin;       // Ret Fuori Finestra
   stats[16] = (double)gCntNoBox;          // Ret No Box
   stats[17] = (double)gCntBoxStretto;     // Ret Box Stretto
   stats[18] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[19] = (double)gCntSpread;         // Ret Spread
   stats[20] = (double)gCntBreachAlto;     // Breach Alto
   stats[21] = (double)gCntBreachBasso;    // Breach Basso
   stats[22] = (double)gCntScaduti;        // Armamenti Scaduti
   stats[23] = (double)gCntAmbiguo;        // Ambiguo Due Lati
   stats[24] = (double)gCntTpDegenere;     // Tp Degenere
   stats[25] = (double)gCntShortCand;      // Short Cand
   stats[26] = (double)gCntLongCand;       // Long Cand
   stats[27] = (double)gCntApri;           // Apri Chiamate

   PrintFormat("[BRKBOX][DIAG] OnNewBar=%I64d | ret: gestione=%I64d fuoriFin=%I64d noBox=%I64d boxStretto=%I64d maxTrades=%I64d spread=%I64d | breach alto=%I64d basso=%I64d scaduti=%I64d ambiguo=%I64d tpDegenere=%I64d | shortCand=%I64d longCand=%I64d apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntFuoriFin, gCntNoBox, gCntBoxStretto,
               gCntMaxTrades, gCntSpread, gCntBreachAlto, gCntBreachBasso,
               gCntScaduti, gCntAmbiguo, gCntTpDegenere,
               gCntShortCand, gCntLongCand, gCntApri);

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
         //--- 'head' e lo StringFormat qui sotto si toccano SEMPRE INSIEME:
         //    una colonna aggiunta a uno solo sfasa tutto il CSV.
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret Fuori Finestra,Ret No Box,Ret Box Stretto,Ret Max Trades,Ret Spread,Breach Alto,Breach Basso,Armamenti Scaduti,Ambiguo Due Lati,Tp Degenere,Short Cand,Long Cand,Apri Chiamate";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 29 campi fissi: %d (Pass) + 28 %f (data[0..27]). CONTATI.
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22],
                                data[23], data[24], data[25], data[26], data[27]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
