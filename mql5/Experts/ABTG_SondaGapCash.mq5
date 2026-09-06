//+------------------------------------------------------------------+
//|                                        ABTG_SondaGapCash.mq5      |
//|                                                                   |
//|  LA SONDA DEL GAP DELLA SESSIONE CASH -- PASSO 0 di GAPCASH_NAS.  |
//|  E' UN CONTATORE, NON UN EA.                                      |
//|                                                                   |
//|  ==============================================================   |
//|  QUESTO FILE NON MANDA NESSUN ORDINE. MAI. NEMMENO NEL TESTER.    |
//|  Non c'e' nessun #include, nessuna libreria di negoziazione,      |
//|  nessun lotto, nessun rischio, nessun magic (un magic serve a     |
//|  riconoscere ordini propri: qui non ce ne sono), nessuna sedia.   |
//|  L'identificatore della corsa e' InpTagCorsa, che e' una          |
//|  ETICHETTA per i nomi dei file, non un magic.                     |
//|  La riga di lancio fa il censimento dei token sul sorgente e      |
//|  pretende ZERO: per questo qui dentro quei nomi non compaiono     |
//|  nemmeno nei commenti (classe 126: il gate diventa rosso per      |
//|  sempre senza che il codice faccia niente di male).               |
//|  ==============================================================   |
//|                                                                   |
//|  IL CONTRATTO, e fa fede LUI (non questo commento):               |
//|    backtest_pipeline\prove\GAPCASH_NAS_PASSO0.txt                 |
//|    criteri P0-1 ... P0-7 CONGELATI il 06/09/2026, PRIMA di        |
//|    qualunque numero di BCM. I NOMI DEGLI INPUT vengono da li' e   |
//|    NON si toccano: un nome diverso MT5 lo ignora IN SILENZIO e    |
//|    la corsa risponde a un'altra domanda (prove\LEGGIMI.md,        |
//|    trappola "nome inesistente"). Non e' stile: e' un round        |
//|    buttato.                                                       |
//|  IL DOSSIER che giustifica il passo 0, con i numeri attesi:       |
//|    backtest_pipeline\caccia_strategie\                            |
//|      CACCIA_NASDAQ_MECCANISMI_2026-09-06.md  (par. 2 e 2.2)       |
//|  LA MISURA ESTERNA che ha prodotto quei numeri:                   |
//|    backtest_pipeline\anatomia_aperture.py su feed HistData        |
//|    (2010-2020, 2.568 giornate, SOLO fase IS: la cassaforte        |
//|     2021-2026 NON e' stata aperta)                                |
//|                                                                   |
//|  CHASSIS DI CASA, riusato come pattern e non reinventato:         |
//|    mql5\Experts\ABTG_SondaRelativo.mq5   (contatore, zero ordini) |
//|    mql5\Experts\ABTG_SondaM0PB.mq5       (OPTFRAME + CSV)         |
//|    mql5\Experts\ABTG_SondaOrologio.mq5   (nucleo puro + autotest) |
//|    mql5\Experts\ABTG_SpreadLogger.mq5    (istogramma dello        |
//|                                           spread, percentili)     |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  LA GRANDEZZA CHE MISURA -- ed e' LA cosa che distingue questo    |
//|  motore da uno che abbiamo gia'                                   |
//|  ---------------------------------------------------------------- |
//|    gap = Open della barra delle 09:30 New York                    |
//|          MENO l'ultima chiusura CASH del giorno di borsa prima    |
//|          (ultima barra M1 con orario <= 16:00 New York)           |
//|    espresso in % di quella chiusura.                              |
//|                                                                   |
//|  NON E' iOpen(D1,0) - iClose(D1,1). Quello e' il gap D1 che usa   |
//|  gia' ABTG_Nasdaq_Apertura_US (righe ~1425-1429) ed e' il salto   |
//|  attraverso la MEZZANOTTE DEL SERVER, su un CFD che quota quasi   |
//|  24 ore: il referto R62 par.5 l'ha gia' scritto, "quel motore     |
//|  trada il gap del weekend". Qui si misura la SESSIONE CASH, che   |
//|  e' un'ALTRA grandezza e che nessun nostro EA ha mai calcolato.   |
//|  Se si sbagliasse questo, il passo 0 non servirebbe a niente.     |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  L'ORA E' SEMPRE ORA SERVER BCM (= ora italiana MENO UNA)         |
//|  ---------------------------------------------------------------- |
//|    09:30 New York = 14:30 SERVER = 15:30 italiane -> la campana.  |
//|    16:00 New York = 21:00 SERVER -> il taglio della chiusura      |
//|                                     cash del giorno prima.        |
//|  NON SI CONVERTE: negli input va 14:30 (InpOraAperturaServer=14,  |
//|  InpMinAperturaServer=30). Il taglio delle 21:00 NON e' un input: |
//|  si RICAVA dall'apertura sommando la durata della sessione cash   |
//|  (6h30 = 390 minuti), cosi' non esiste nessun modo di             |
//|  configurare i due orari in contraddizione fra loro.              |
//|                                                                   |
//|  >>> ERRORE NOTO E DICHIARATO (stessa scelta firmata sulla        |
//|      SondaOrologio, criterio C6): l'ora legale americana e        |
//|      quella europea non cambiano lo stesso giorno. Per ~3         |
//|      settimane l'anno le 09:30 di New York NON sono le 14:30 del  |
//|      server. In quelle giornate questa sonda misura il minuto     |
//|      sbagliato di 60 minuti. L'errore c'e', e' noto, NON e'       |
//|      misurato qui, e il referto lo scrive ogni volta.             |
//|                                                                   |
//|  TUTTE le righe di log cominciano con "[GAPCASH]" e NESSUNA       |
//|  contiene stringhe che fanno fede per altri collaudi: il          |
//|  fallimento dell'autotest si chiama "*** ROSSO SONDAGAPCASH ***"  |
//|  e NON la riga VIETATA del collaudo enforcement Fase 1 (la voce   |
//|  STOP.AUTOTEST di backtest_pipeline\attese_enforcement_fase1.txt: |
//|  qui non la si trascrive nemmeno come esempio, perche' un         |
//|  controllo che cerca quella stringa la troverebbe in questo file  |
//|  e diventerebbe rosso per sempre senza che il codice faccia       |
//|  niente di male -- classe 126). Un rosso di QUESTA sonda non deve |
//|  poter fermare il collaudo di un ALTRO artefatto.                 |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  COSA QUESTA CORSA NON DICE -- scritto prima, non dopo            |
//|  ---------------------------------------------------------------- |
//|   - NON dice se il motore guadagna: non ci sono operazioni,       |
//|     quindi non c'e' nessun profit factor, nessuna equity,         |
//|     nessun drawdown. E non esce NESSUNA colonna di P/L: senza     |
//|     operazioni sarebbero tutti zero, e uno zero in colonna prima  |
//|     o poi qualcuno lo legge come un risultato.                    |
//|   - NON e' un round di merito e non promuove niente.              |
//|   - NON tocca nessuna sedia viva, nessun preset, nessun magic.    |
//|   - Una frequenza alta NON e' un edge: e' una frequenza.          |
//|                                                                   |
//|  DEMO. ASCII puro: niente accenti, niente emoji (regola di casa   |
//|  dei .ps1, estesa qui perche' log e CSV finiscono negli stessi    |
//|  strumenti). Niente commenti a blocco, perche' il censimento dei  |
//|  token toglie solo la parte dopo la doppia barra e un commento a  |
//|  blocco gli nasconderebbe una riga viva.                          |
//|  NON COMPILATO NE' ESEGUITO da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor PRIMA di qualunque corsa.                  |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - sonda di misura, non strategia"
#property version   "1.00"
#property strict
#property description "ABTG_SondaGapCash -- CONTATORE del gap della sessione cash del Nasdaq. Non manda, non modifica e non chiude niente: produce una tabella."

//--- MARCATORE DI VERSIONE: la riga di lancio lo cerca nel sorgente
//    PRIMA di installare, e lo si rilegge nella scheda Esperti per
//    sapere quale build sta girando.
#define ABTG_GAPCASH_MARCATORE "ABTG_SondaGapCash v1.00 - PASSO 0 GAPCASH_NAS, contatore del gap della sessione cash"

//--- NUMERI DELL'AUTOTEST dichiarati come #define perche' un driver li
//    legga dal SORGENTE e li confronti con quelli che si aspetta: se il
//    file al pin non e' quello che credo, non si parte.
#define ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI 8
#define ABTG_GAPCASH_AUTOTEST_CASI_ATTESI    74

//==================================================================
//  COSTANTI DELLA MISURA -- congelate, non configurabili
//==================================================================
//--- durata della sessione cash americana, in minuti (09:30 -> 16:00).
//    Serve a RICAVARE il taglio della chiusura cash dall'apertura.
#define GC_DURATA_CASH_MIN        390
//--- finestra dei candidati alla chiusura cash: le 5 ore prima del
//    taglio. Cinque e non una perche' le mezze sedute (vigilia di
//    Natale, venerdi' dopo il Ringraziamento) chiudono alle 13:00 New
//    York: con una finestra stretta il gap del giorno dopo sarebbe
//    "non misurato" proprio nei giorni piu' particolari. E' la stessa
//    definizione di anatomia_aperture.py (cfg.chi_da = chiusura - 300).
#define GC_FINESTRA_CHIUSURA_MIN  300
//--- quanti giorni indietro si puo' cercare la chiusura cash prima di
//    dichiarare che non c'e'. Tre giri progressivi: 1, 3, 8 giorni.
//    Otto copre il ponte di Natale piu' lungo.
#define GC_INDIETRO_1             1
#define GC_INDIETRO_2             3
#define GC_INDIETRO_3             8
//--- la "prima ora" dell'igiene P0-6: 60 minuti dalla campana.
#define GC_MIN_PRIMA_ORA          60
//--- tolleranza sulla barra d'apertura: se la barra ESATTA della
//    campana manca, si ripiega sulla prima barra dei primi 5 minuti e
//    il fatto si CONTA (colonna offset_apertura_min). E' la stessa
//    tolleranza della misura esterna che ha prodotto i numeri attesi:
//    senza, si misurerebbe un'altra popolazione di giornate.
#define GC_TOLLERANZA_APERTURA_MIN 5
//--- cancelli dei criteri congelati
#define GC_P01_EVENTI_MINIMI      25
#define GC_P02_SEPARAZIONE_MIN    3.0
#define GC_P03_MULTIPLO_PASSA     3.0
#define GC_P03_MULTIPLO_SOSPESO   2.0
#define GC_P06_QUOTA_LUNEDI_KO    40.0
#define GC_P06_MIN_BARRE_DEFAULT  55

//--- esiti, in un solo alfabeto per tutto il file
#define GC_SCARTO      0
#define GC_SOSPESO     1
#define GC_PASSA       2
#define GC_NONMISURATO (-1)

//--- motivi per cui una giornata NON entra nella misura
#define GC_OK                0
#define GC_KO_POCHE_BARRE    1
#define GC_KO_NO_CAMPANA     2
#define GC_KO_NO_CHIUSURA    3
#define GC_KO_NO_FINESTRA    4
#define GC_KO_PREZZI         5

//--- istogramma dello spread del minuto della campana: un secchio per
//    ogni PUNTO MT5, da 0 a MAXBIN-1. 20.001 punti sono 200 punti
//    indice su un simbolo a 2 decimali: oltre si conta in OVERFLOW e
//    il percentile che ci cade dentro si DICHIARA, non si arrotonda a
//    un numero comodo. Quattro istogrammi x 20.001 x 8 byte = ~640 kB,
//    fissi: e' il prezzo per non buttare via nessun campione.
#define GC_MAXBIN                 20001

//--- tetto alle giornate tenute in memoria. 8.000 giornate sono ~31
//    anni di sedute: se si toccasse, il referto lo DICE invece di
//    troncare in silenzio.
#define GC_MAX_GIORNATE           8000

//--- filtri e campi per il raccoglitore dei valori
#define GC_FILTRO_TUTTE       0
#define GC_FILTRO_EVENTO_L    1
#define GC_FILTRO_EVENTO_S    2
#define GC_FILTRO_NON_EVENTO  3
#define GC_LATO_LONG          1
#define GC_LATO_SHORT         2
#define GC_CAMPO_RET_PCT      0
#define GC_CAMPO_RET_PT       1
#define GC_CAMPO_MFE_PCT      2
#define GC_CAMPO_MAE_PCT      3
#define GC_CAMPO_MFE_PT       4
#define GC_CAMPO_MAE_PT       5

//--- numero di colonne dell'OPTFRAME. Non si tocca senza toccare
//    ColonneStats(): l'autotest confronta le due cose (blocco 8).
#define GC_NSTATS                 63

//==================================================================
//  INPUT
//  I NOMI DEI PRIMI NOVE SONO QUELLI PINNATI DAL FILE PROVA
//  CONGELATO (prove\GAPCASH_NAS_PASSO0.txt, par. 6). NON si
//  rinominano e non si tolgono.
//  Quelli del secondo gruppo NON stanno nel file prova: hanno un
//  default che riproduce ESATTAMENTE il comportamento congelato,
//  quindi una corsa che non li nomina misura quello che il contratto
//  dice. Sono dichiarati qui uno per uno, col perche'.
//==================================================================
input group "=== IL CONTRATTO -- nomi pinnati dal file prova, non si toccano ==="
input double InpSogliaGapPct        = -0.50;  // soglia del gap CASH in % (LONG). L'UNICO asse dello sweep
input int    InpOraAperturaServer   = 14;     // ORA SERVER della campana (14 = 09:30 New York = 15:30 IT). NON si converte
input int    InpMinAperturaServer   = 30;     // MINUTO SERVER della campana
input int    InpMinutiUscita        = 15;     // orizzonte della misura, in minuti dalla campana
input int    InpLato                = 0;      // 0 = ENTRAMBI i lati (P0-5) | 1 = solo long | 2 = solo short
input bool   InpGateSpento          = false;  // false = gate ACCESO. true = corsa di CONTROLLO (tutte le giornate sono evento)
input bool   InpMisuraSpreadCampana = true;   // misura lo spread tick per tick dentro il minuto della campana (P0-3)
input bool   InpVerbose             = true;   // righe di log (in ottimizzazione NON le legge nessuno: vedi le colonne)
input bool   InpAutoTest            = true;   // autotest a tavolino in OnInit. L'esito esce anche in COLONNA

input group "=== FUORI DAL FILE PROVA -- default = comportamento congelato ==="
//--- P0-5 fissa il lato short a "gap >= +0,50%", NON a "l'opposto
//    della soglia long". Il default riproduce alla lettera il
//    contratto: nelle 8 celle dello sweep il numero SHORT e' quindi
//    LO STESSO in tutte e otto, non otto misure indipendenti -- e il
//    referto lo scrive, cosi' nessuno lo legge come una scala.
input double InpSogliaGapShortPct   = 0.50;   // soglia del gap CASH in % (SHORT, P0-5). Fissa: NON e' l'opposto della long
//--- P0-6 fissa 55 barre M1 nei primi 60 minuti. E' un input solo per
//    poterlo dichiarare nel referto e nelle colonne, non per spazzolarlo.
input int    InpMinBarreM1PrimaOra  = 55;     // igiene P0-6: barre M1 minime nei primi 60 minuti
input bool   InpScriviCsv           = true;   // CSV riga-per-giornata + referto .txt (SOLO fuori dall'ottimizzazione)
input string InpTagCorsa            = "";     // suffisso nei nomi dei file: due corse non si sovrascrivono mai

//==================================================================
//  LA GIORNATA -- una riga di tabella, e nient'altro
//==================================================================
struct GiornataGapCash
  {
   int      data;              // aaaammgg della giornata (ora server)
   int      giornoSettimana;   // 0 = domenica ... 6 = sabato
   datetime tCampana;          // istante della campana, ora server
   bool     valida;            // entra nella misura?
   int      motivo;            // GC_OK oppure il motivo dell'esclusione
   int      barrePrimaOra;     // barre M1 nei primi GC_MIN_PRIMA_ORA minuti
   int      barreFinestra;     // barre M1 dentro l'orizzonte
   int      offsetApertura;    // minuti fra la campana e la barra usata (0 = esatta)
   double   openCampana;
   double   chiusuraPrec;      // ultima chiusura CASH del giorno di borsa prima
   datetime tChiusuraPrec;
   double   gapPt;
   double   gapPct;
   bool     eventoLong;
   bool     eventoShort;
   double   ret15Pct;          // rendimento a +InpMinutiUscita, LONG, in %
   double   ret15Pt;           // lo stesso in unita' di prezzo (punti indice)
   bool     barra15Esatta;     // la barra di chiusura dell'orizzonte era quella giusta?
   double   upPct;             // escursione massima al RIALZO, >= 0
   double   dnPct;             // escursione massima al RIBASSO, <= 0
   double   upPt;              // le stesse due in unita' di prezzo, entrambe >= 0
   double   dnPt;
   int      tickCampana;       // campioni di spread validi dentro il minuto della campana
   double   spreadMed;         // spread MEDIANO di QUEL minuto, in punti MT5
   double   spreadP95;         // spread P95 di QUEL minuto, in punti MT5
  };

//==================================================================
//  STATO
//==================================================================
GiornataGapCash gG[];
int      gNG              = 0;
bool     gTroncato        = false;

//--- la giornata in lavorazione
int      gDataInCorso     = 0;
datetime gMezzanotte      = 0;
bool     gGiornoChiuso    = true;

//--- istogrammi dello spread del minuto della campana, in punti MT5
long     gIstoGiorno[];
long     gIstoEventoL[];
long     gIstoEventoS[];
long     gIstoTutti[];
long     gNGiorno = 0, gOverGiorno = 0;
long     gNEventoL = 0, gOverEventoL = 0;
long     gNEventoS = 0, gOverEventoS = 0;
long     gNTutti = 0,  gOverTutti = 0;
int      gBinMinGiorno = GC_MAXBIN, gBinMaxGiorno = -1;
long     gTickScartati = 0;

//--- contatori di servizio
long     gLettureM1Fallite = 0;
long     gGiornateConTick  = 0;

//--- anagrafica del simbolo
int      gDigits = 0;
double   gPoint  = 0.0;
double   gPPU    = 1.0;      // punti MT5 per UNITA' PRATICA (100 sugli indici a 2 decimali)
string   gUnita  = "punti indice";

//--- minuti della giornata, calcolati una volta in OnInit
int      gMinCampana  = 0;
int      gMinChiusura = 0;

//--- collaudo. -1 = autotest NON eseguito, che NON e' "passato".
int      gAutotestFalliti = -1;
int      gAutotestBlocchi = 0;
int      gCasiFatti       = 0;
int      gCasiRossi       = 0;

//--- nomi dei file, decisi a fine corsa (quando si conoscono le date)
string   gFileCsv     = "";
string   gFileReferto = "";

void Log(const string m){ if(InpVerbose) Print("[GAPCASH] ", m); }

//==================================================================
//
//  NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//  Prendono i numeri gia' letti e rispondono. E' questa la parte che
//  l'AUTOTEST interroga a tavolino, senza mercato, chiamando le
//  funzioni VERE della produzione e non delle copie (classe 109).
//
//==================================================================

//+------------------------------------------------------------------+
//| Mezzanotte (ora server) dell'istante dato.                       |
//+------------------------------------------------------------------+
datetime MezzanotteDi_Calc(const datetime t)
  {
   long s = (long)t;
   return((datetime)(s - (s % 86400)));
  }

//+------------------------------------------------------------------+
//| Minuto del giorno (0..1439) di un istante, ora server.           |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const datetime t)
  {
   long s = (long)t;
   return((int)((s % 86400) / 60));
  }

//+------------------------------------------------------------------+
//| Il minuto della campana dalle due manopole del contratto.        |
//+------------------------------------------------------------------+
int MinutiCampana_Calc(const int ora, const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| IL TAGLIO DELLA CHIUSURA CASH -- NON e' un input: si RICAVA       |
//| dall'apertura sommando la durata della sessione cash. Cosi' non   |
//| esiste nessun modo di configurare i due orari in contraddizione:  |
//| se qualcuno spostasse la campana, il taglio lo segue.             |
//| 14:30 + 390 minuti = 21:00 server = 16:00 New York.               |
//+------------------------------------------------------------------+
int MinutiChiusuraCash_Calc(const int ora, const int minuto)
  {
   return(MinutiCampana_Calc(ora, minuto) + GC_DURATA_CASH_MIN);
  }

//+------------------------------------------------------------------+
//| Siamo DENTRO il minuto della campana (14:30:00 - 14:31:00)?      |
//| Con la risoluzione al minuto la domanda e' un'uguaglianza secca:  |
//| e' esattamente la finestra che P0-3 vuole misurare da sola.       |
//+------------------------------------------------------------------+
bool DentroMinutoCampana_Calc(const int minutiOra, const int minutiCampana)
  {
   return(minutiOra == minutiCampana);
  }

//+------------------------------------------------------------------+
//| E' passata abbastanza giornata per chiudere la contabilita'?      |
//| Serve la PRIMA ORA intera (igiene P0-6), quindi si aspetta un     |
//| minuto oltre: campana + 60 + 1.                                   |
//+------------------------------------------------------------------+
bool FinestraChiusa_Calc(const int minutiOra, const int minutiCampana)
  {
   return(minutiOra >= minutiCampana + GC_MIN_PRIMA_ORA + 1);
  }

//+------------------------------------------------------------------+
//| IL GAP DELLA SESSIONE CASH, in %. Torna false se la chiusura      |
//| precedente non e' utilizzabile: in quel caso il gap resta ZERO    |
//| e NON va letto come "gap nullo" -- va letto insieme al motivo.    |
//+------------------------------------------------------------------+
bool GapPct_Calc(const double openCampana, const double chiusuraPrec, double &gap)
  {
   gap = 0.0;
   if(chiusuraPrec <= 0.0 || openCampana <= 0.0) return(false);
   gap = 100.0*(openCampana - chiusuraPrec)/chiusuraPrec;
   return(true);
  }

//+------------------------------------------------------------------+
//| Variazione percentuale rispetto a un riferimento.                |
//+------------------------------------------------------------------+
double VariazionePct_Calc(const double riferimento, const double prezzo)
  {
   if(riferimento <= 0.0) return(0.0);
   return(100.0*(prezzo - riferimento)/riferimento);
  }

//+------------------------------------------------------------------+
//| IL GATE, LATO LONG. Con InpGateSpento acceso ogni giornata valida |
//| e' un evento: e' la corsa di CONTROLLO che serve a P0-2, e in     |
//| quella corsa il gate NON separa niente per costruzione.           |
//+------------------------------------------------------------------+
bool EventoLong_Calc(const double gapPct, const double soglia, const bool gateSpento, const bool valida)
  {
   if(!valida) return(false);
   if(gateSpento) return(true);
   return(gapPct <= soglia);
  }

//+------------------------------------------------------------------+
//| IL GATE, LATO SHORT (P0-5). Soglia FISSA e positiva.              |
//+------------------------------------------------------------------+
bool EventoShort_Calc(const double gapPct, const double soglia, const bool gateSpento, const bool valida)
  {
   if(!valida) return(false);
   if(gateSpento) return(true);
   return(gapPct >= soglia);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.  |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| PERCENTILE di un vettore GIA' ORDINATO, metodo del RANGO PIU'     |
//| VICINO: indice = ceil(p*n) - 1. Nessuna interpolazione, cosi' il  |
//| numero che esce e' UN VALORE DAVVERO VISTO e non una media fra    |
//| due -- che su un p75 di MAE, da cui esce lo STOP del round dopo,  |
//| e' la differenza fra una misura e un'invenzione.                  |
//+------------------------------------------------------------------+
double PercentileOrdinato_Calc(const double &v[], const int n, const double p)
  {
   if(n <= 0) return(0.0);
   if(p <= 0.0) return(v[0]);
   if(p >= 1.0) return(v[n-1]);
   int idx = (int)MathCeil(p*n) - 1;
   if(idx < 0)   idx = 0;
   if(idx > n-1) idx = n-1;
   return(v[idx]);
  }

//+------------------------------------------------------------------+
//| MEDIA di un vettore.                                              |
//+------------------------------------------------------------------+
double Media_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   double s = 0.0;
   for(int i=0; i<n; i++) s += v[i];
   return(s/(double)n);
  }

//+------------------------------------------------------------------+
//| PERCENTILE da un ISTOGRAMMA di secchi interi (lo spread in punti  |
//| MT5 E' un intero, quindi qui il percentile e' ESATTO e non serve  |
//| tenere in memoria mezzo milione di campioni).                     |
//| 'totale' DEVE gia' comprendere i campioni finiti oltre il tetto   |
//| (chi conta i campioni ne tiene UN solo contatore, e l'overflow e' |
//| un di cui, non un in piu': sommarli due volte sposterebbe tutti i |
//| percentili verso il basso). Se il percentile cade nella coda      |
//| oltre il tetto esce 'oltreTetto' invece di un numero comodo e     |
//| falso. Torna -1 se non c'e' niente da misurare.                   |
//+------------------------------------------------------------------+
long PercentileIstogramma_Calc(const long &isto[], const long totale, const double frac, bool &oltreTetto)
  {
   oltreTetto = false;
   if(totale <= 0) return(-1);
   double soglia = frac*(double)totale;
   long cum = 0;
   int n = ArraySize(isto);
   for(int b=0; b<n; b++)
     {
      cum += isto[b];
      if((double)cum >= soglia) return((long)b);
     }
   oltreTetto = true;
   return((long)n);
  }

//+------------------------------------------------------------------+
//| Spread da PUNTI MT5 a UNITA' PRATICA (punti indice sugli indici). |
//| Il numero grezzo resta sempre in punti MT5: la conversione e' un  |
//| comodo per leggere, mai il dato.                                  |
//+------------------------------------------------------------------+
double SpreadInUnita_Calc(const double punti, const double puntiPerUnita)
  {
   if(puntiPerUnita <= 0.0) return(0.0);
   return(punti/puntiPerUnita);
  }

//+------------------------------------------------------------------+
//| Punti MT5 per unita' pratica, dai decimali del simbolo. Stessa    |
//| regola di ABTG_SpreadLogger: 2 decimali -> 100 punti = 1 punto    |
//| indice (MISURATA in R97 su NASUSD/U30USD/D30EUR).                 |
//+------------------------------------------------------------------+
double PuntiPerUnita_Calc(const int digits)
  {
   if(digits >= 3) return(10.0);
   if(digits == 2) return(100.0);
   if(digits == 1) return(10.0);
   return(1.0);
  }

//+------------------------------------------------------------------+
//| Quota percentuale, con il denominatore nullo che torna 0 e non    |
//| fa esplodere niente.                                              |
//+------------------------------------------------------------------+
double QuotaPct_Calc(const long parte, const long totale)
  {
   if(totale <= 0) return(0.0);
   return(100.0*(double)parte/(double)totale);
  }

//+------------------------------------------------------------------+
//| IGIENE P0-6: la giornata entra nella misura solo se ha almeno N   |
//| barre M1 nei primi 60 minuti (stessa definizione di GIORNO        |
//| SOSPETTO del referto del 26/08). Serve a togliere festivi e       |
//| mezze sedute SENZA un calendario da mantenere a mano.             |
//+------------------------------------------------------------------+
bool GiornataValida_Calc(const int barrePrimaOra, const int minBarre)
  {
   return(barrePrimaOra >= minBarre);
  }

//+------------------------------------------------------------------+
//| P0-1 FREQUENZA: >= 25 giornate-evento passa, sotto e' SCARTO.     |
//+------------------------------------------------------------------+
int EsitoP01_Calc(const long eventi)
  {
   return(eventi >= GC_P01_EVENTI_MINIMI ? GC_PASSA : GC_SCARTO);
  }

//+------------------------------------------------------------------+
//| P0-2 SEGNO E SEPARAZIONE, alla lettera del contratto:             |
//|   PASSA se media_evento > 0  E  media_evento >= 3 x media_tutti.  |
//| Il SEGNO viene prima del rapporto: una media evento negativa e'   |
//| SCARTO anche se il controllo e' piu' negativo ancora.             |
//| NOTA scritta qui e ripetuta nel referto: se media_tutti e' <= 0   |
//| la seconda condizione e' vera per aritmetica e il "3x" non vuol   |
//| dire piu' niente. Il codice NON cambia il criterio congelato --   |
//| il referto DICHIARA che il confronto e' degenere.                 |
//+------------------------------------------------------------------+
int EsitoP02_Calc(const double mediaEvento, const double mediaTutti)
  {
   if(mediaEvento <= 0.0) return(GC_SCARTO);
   if(mediaEvento < GC_P02_SEPARAZIONE_MIN*mediaTutti) return(GC_SCARTO);
   return(GC_PASSA);
  }

//+------------------------------------------------------------------+
//| Il rapporto di P0-3: take mediano contro spread mediano DI QUEL   |
//| MINUTO. Spread <= 0 (non misurato) -> 0, che si legge insieme     |
//| alla colonna dello spread, che in quel caso dichiara lo zero.     |
//+------------------------------------------------------------------+
double RapportoTakeSpread_Calc(const double takeMediano, const double spreadMediano)
  {
   if(spreadMediano <= 0.0) return(0.0);
   return(takeMediano/spreadMediano);
  }

//+------------------------------------------------------------------+
//| P0-3 COSTO: >= 3x PASSA, fra 2x e 3x SOSPESO, < 2x SCARTO.        |
//| Se lo spread non e' stato misurato l'esito e' NON MISURATO, che   |
//| non e' ne' un pass ne' un fail: e' l'assenza del numero.          |
//+------------------------------------------------------------------+
int EsitoP03_Calc(const double rapporto, const double spreadMediano)
  {
   if(spreadMediano <= 0.0) return(GC_NONMISURATO);
   if(rapporto >= GC_P03_MULTIPLO_PASSA)   return(GC_PASSA);
   if(rapporto >= GC_P03_MULTIPLO_SOSPESO) return(GC_SOSPESO);
   return(GC_SCARTO);
  }

//+------------------------------------------------------------------+
//| P0-6 LUNEDI': oltre il 40% di giornate-evento di lunedi' il       |
//| motore e' il gap del weekend travestito (gia' misurato da         |
//| R61/R62) e il VERDETTO VA SOSPESO. Non e' uno scarto: e' un       |
//| "non stiamo misurando quello che crediamo".                       |
//+------------------------------------------------------------------+
int EsitoP06Lunedi_Calc(const long eventiLunedi, const long eventi)
  {
   if(eventi <= 0) return(GC_NONMISURATO);
   if(QuotaPct_Calc(eventiLunedi, eventi) > GC_P06_QUOTA_LUNEDI_KO) return(GC_SOSPESO);
   return(GC_PASSA);
  }

//+------------------------------------------------------------------+
//| VERDETTO COMPLESSIVO: uno SCARTO domina su tutto, un SOSPESO (o   |
//| un NON MISURATO, che non puo' diventare un verde) domina su un    |
//| PASSA. Non e' una media: e' una catena.                           |
//+------------------------------------------------------------------+
int VerdettoComplessivo_Calc(const int &esiti[], const int n)
  {
   bool sospeso = false;
   for(int i=0; i<n; i++)
     {
      if(esiti[i] == GC_SCARTO) return(GC_SCARTO);
      if(esiti[i] == GC_SOSPESO || esiti[i] == GC_NONMISURATO) sospeso = true;
     }
   return(sospeso ? GC_SOSPESO : GC_PASSA);
  }

//+------------------------------------------------------------------+
//| Il nome dell'esito, in un posto solo.                             |
//+------------------------------------------------------------------+
string NomeEsito(const int e)
  {
   if(e == GC_PASSA)   return("PASSA");
   if(e == GC_SOSPESO) return("SOSPESO");
   if(e == GC_SCARTO)  return("SCARTO");
   return("NON MISURATO");
  }

string NomeMotivo(const int m)
  {
   if(m == GC_OK)              return("ok");
   if(m == GC_KO_POCHE_BARRE)  return("poche barre M1 nella prima ora (festivo o mezza seduta)");
   if(m == GC_KO_NO_CAMPANA)   return("manca la barra della campana");
   if(m == GC_KO_NO_CHIUSURA)  return("chiusura cash precedente non trovata");
   if(m == GC_KO_NO_FINESTRA)  return("nessuna barra dentro l orizzonte");
   if(m == GC_KO_PREZZI)       return("prezzi non utilizzabili");
   return("motivo sconosciuto");
  }

//==================================================================
//  LE COLONNE DELL'OPTFRAME -- nomi e decimali NASCONO INSIEME, in
//  una funzione sola. E' il guardiano che sulla SondaM0PB non c'era:
//  aggiungere un valore senza aggiungere il nome (o viceversa) sfasa
//  tutto il CSV e chi legge trova il numero sbagliato sotto il nome
//  giusto. L'autotest, blocco 8, controlla che siano GC_NSTATS.
//==================================================================
void ColonneStats(string &nomi[], int &dec[])
  {
   ArrayResize(nomi, GC_NSTATS);
   ArrayResize(dec,  GC_NSTATS);
   int i = 0;
   nomi[i]="Giornate Con Tick";                 dec[i]=0; i++;   // 0
   nomi[i]="Giornate Valide";                   dec[i]=0; i++;   // 1
   nomi[i]="Giornate Scartate Igiene";          dec[i]=0; i++;   // 2
   nomi[i]="Giornate Scartate Dati";            dec[i]=0; i++;   // 3
   nomi[i]="P01 Eventi Long";                   dec[i]=0; i++;   // 4
   nomi[i]="P01 Esito";                         dec[i]=0; i++;   // 5
   nomi[i]="P02 Media Evento Pct";              dec[i]=6; i++;   // 6
   nomi[i]="P02 Media Tutti Pct";               dec[i]=6; i++;   // 7
   nomi[i]="P02 Media Non Evento Pct";          dec[i]=6; i++;   // 8
   nomi[i]="P02 Separazione X";                 dec[i]=3; i++;   // 9
   nomi[i]="P02 Esito";                         dec[i]=0; i++;   // 10
   nomi[i]="P02 Controllo Degenere";            dec[i]=0; i++;   // 11
   nomi[i]="Mediana Evento Pct";                dec[i]=6; i++;   // 12
   nomi[i]="Win Evento Pct";                    dec[i]=2; i++;   // 13
   nomi[i]="Win Tutti Pct";                     dec[i]=2; i++;   // 14
   nomi[i]="P03 Take Mediano Unita";            dec[i]=4; i++;   // 15
   nomi[i]="P03 Spread Campana Mediano Unita";  dec[i]=4; i++;   // 16
   nomi[i]="P03 Spread Campana P95 Unita";      dec[i]=4; i++;   // 17
   nomi[i]="P03 Spread Tutti Mediano Unita";    dec[i]=4; i++;   // 18
   nomi[i]="P03 Spread Tutti P95 Unita";        dec[i]=4; i++;   // 19
   nomi[i]="P03 Rapporto Take Su Spread";       dec[i]=3; i++;   // 20
   nomi[i]="P03 Esito";                         dec[i]=0; i++;   // 21
   nomi[i]="P03 Tick Campana Eventi";           dec[i]=0; i++;   // 22
   nomi[i]="P03 Tick Campana Tutti";            dec[i]=0; i++;   // 23
   nomi[i]="P03 Spread Oltre Tetto";            dec[i]=0; i++;   // 24
   nomi[i]="P04 MAE p50 Pct";                   dec[i]=4; i++;   // 25
   nomi[i]="P04 MAE p75 Pct";                   dec[i]=4; i++;   // 26
   nomi[i]="P04 MAE p90 Pct";                   dec[i]=4; i++;   // 27
   nomi[i]="P04 MFE p50 Pct";                   dec[i]=4; i++;   // 28
   nomi[i]="P04 MFE p75 Pct";                   dec[i]=4; i++;   // 29
   nomi[i]="P04 MFE p90 Pct";                   dec[i]=4; i++;   // 30
   nomi[i]="P04 MAE p75 Unita";                 dec[i]=3; i++;   // 31
   nomi[i]="P04 MFE p50 Unita";                 dec[i]=3; i++;   // 32
   nomi[i]="P05 Eventi Short";                  dec[i]=0; i++;   // 33
   nomi[i]="P05 Media Short Pct";               dec[i]=6; i++;   // 34
   nomi[i]="P05 Mediana Short Pct";             dec[i]=6; i++;   // 35
   nomi[i]="P05 Win Short Pct";                 dec[i]=2; i++;   // 36
   nomi[i]="P05 Separazione Short X";           dec[i]=3; i++;   // 37
   nomi[i]="P05 Esito Frequenza";               dec[i]=0; i++;   // 38
   nomi[i]="P05 Esito Separazione";             dec[i]=0; i++;   // 39
   nomi[i]="P05 MAE Short p75 Pct";             dec[i]=4; i++;   // 40
   nomi[i]="P05 MFE Short p50 Pct";             dec[i]=4; i++;   // 41
   nomi[i]="P06 Eventi Lunedi";                 dec[i]=0; i++;   // 42
   nomi[i]="P06 Quota Lunedi Pct";              dec[i]=2; i++;   // 43
   nomi[i]="P06 Esito";                         dec[i]=0; i++;   // 44
   nomi[i]="P06 Barre Prima Ora Mediana";       dec[i]=1; i++;   // 45
   nomi[i]="P06 Aperture Non Esatte";           dec[i]=0; i++;   // 46
   nomi[i]="Verdetto Complessivo";              dec[i]=0; i++;   // 47
   nomi[i]="Eco Soglia Gap Long";               dec[i]=3; i++;   // 48
   nomi[i]="Eco Soglia Gap Short";              dec[i]=3; i++;   // 49
   nomi[i]="Eco Minuti Uscita";                 dec[i]=0; i++;   // 50
   nomi[i]="Eco Minuto Campana Server";         dec[i]=0; i++;   // 51
   nomi[i]="Eco Minuto Chiusura Cash Server";   dec[i]=0; i++;   // 52
   nomi[i]="Eco Gate Spento";                   dec[i]=0; i++;   // 53
   nomi[i]="Eco Lato";                          dec[i]=0; i++;   // 54
   nomi[i]="Eco Spread Campana Misurato";       dec[i]=0; i++;   // 55
   nomi[i]="Eco Punti Per Unita";               dec[i]=0; i++;   // 56
   nomi[i]="Eco Decimali Simbolo";              dec[i]=0; i++;   // 57
   nomi[i]="Letture M1 Fallite";                dec[i]=0; i++;   // 58
   nomi[i]="Giornate Troncate";                 dec[i]=0; i++;   // 59
   nomi[i]="Autotest Falliti";                  dec[i]=0; i++;   // 60
   nomi[i]="Autotest Blocchi";                  dec[i]=0; i++;   // 61
   nomi[i]="P03 Tick Campana Scartati";         dec[i]=0; i++;   // 62
  }

//==================================================================
//  AUTOTEST A TAVOLINO
//  Gira in OnInit, non tocca niente di vivo e chiama le funzioni
//  VERE della produzione. Il fallimento si chiama
//  "*** ROSSO SONDAGAPCASH ***" e NON contiene nessuna stringa che
//  faccia fede per un altro collaudo.
//  L'esito vero esce anche in COLONNA ("Autotest Falliti"): in
//  ottimizzazione le Print girano sugli agent e non le legge nessuno
//  (CHECKLIST punto 34, ribadito al 99).
//==================================================================
void Caso(const string nome, const bool ok)
  {
   gCasiFatti++;
   if(!ok)
     {
      gCasiRossi++;
      Print("[GAPCASH] *** ROSSO SONDAGAPCASH *** caso fallito: ", nome);
     }
  }

bool AutoTestGapCash()
  {
   gCasiFatti = 0;
   gCasiRossi = 0;
   int blocchi = 0;

   //--- BLOCCO 1: l'OROLOGIO. E' il pezzo che in casa e' gia' costato
   //    (ora server contro ora locale), quindi si collauda per primo.
   blocchi++;
     {
      datetime b1_t = D'2026.09.04 14:30:17';
      Caso("mezzanotte di un istante noto",            MezzanotteDi_Calc(b1_t) == D'2026.09.04 00:00:00');
      Caso("mezzanotte di mezzanotte e' se stessa",    MezzanotteDi_Calc(D'2026.09.04 00:00:00') == D'2026.09.04 00:00:00');
      Caso("14:30 sono 870 minuti dalla mezzanotte",   MinutiDelGiorno_Calc(b1_t) == 870);
      Caso("00:00 sono 0 minuti",                      MinutiDelGiorno_Calc(D'2026.09.04 00:00:00') == 0);
      Caso("minuto campana da 14 e 30 = 870",          MinutiCampana_Calc(14,30) == 870);
      Caso("taglio cash da 14:30 = 1260 (21:00 server = 16:00 New York)", MinutiChiusuraCash_Calc(14,30) == 1260);
      Caso("il taglio SEGUE la campana (13:30 -> 20:00)", MinutiChiusuraCash_Calc(13,30) == 1200);
      Caso("dentro il minuto della campana a 870",     DentroMinutoCampana_Calc(870,870));
      Caso("fuori dal minuto della campana a 871",     !DentroMinutoCampana_Calc(871,870));
      Caso("fuori dal minuto della campana a 869",     !DentroMinutoCampana_Calc(869,870));
      Caso("finestra chiusa a campana + 61 minuti",    FinestraChiusa_Calc(931,870));
      Caso("finestra ANCORA APERTA a campana + 60",    !FinestraChiusa_Calc(930,870));
     }

   //--- BLOCCO 2: il GAP e le variazioni.
   blocchi++;
     {
      double b2_g = 0.0;
      bool   b2_ok = GapPct_Calc(99.5, 100.0, b2_g);
      Caso("gap -0,50% da 99,5 su 100",                MathAbs(b2_g + 0.5) < 0.000001);
      Caso("gap calcolabile torna vero",               b2_ok);
      double b2_g2 = 0.0;
      GapPct_Calc(100.5, 100.0, b2_g2);
      Caso("gap +0,50% da 100,5 su 100",               MathAbs(b2_g2 - 0.5) < 0.000001);
      double b2_g3 = 123.0;
      bool   b2_ko = GapPct_Calc(100.0, 0.0, b2_g3);
      Caso("chiusura precedente nulla: gap NON calcolabile", !b2_ko);
      Caso("gap non calcolabile viene AZZERATO, non inventato", MathAbs(b2_g3) < 0.000001);
      Caso("variazione +0,15%",                        MathAbs(VariazionePct_Calc(100.0, 100.15) - 0.15) < 0.000001);
      Caso("variazione -0,20%",                        MathAbs(VariazionePct_Calc(100.0, 99.8) + 0.2) < 0.000001);
      Caso("riferimento nullo -> 0",                   MathAbs(VariazionePct_Calc(0.0, 100.0)) < 0.000001);
     }

   //--- BLOCCO 3: IL GATE, i due lati e la corsa di controllo.
   blocchi++;
     {
      Caso("evento long: gap -0,60 sotto la soglia -0,50",  EventoLong_Calc(-0.60, -0.50, false, true));
      Caso("evento long: la soglia e' INCLUSA (-0,50)",     EventoLong_Calc(-0.50, -0.50, false, true));
      Caso("evento long: -0,49 non basta",                  !EventoLong_Calc(-0.49, -0.50, false, true));
      Caso("giornata NON valida non e' mai un evento",      !EventoLong_Calc(-0.60, -0.50, false, false));
      Caso("gate SPENTO: tutte le giornate valide sono evento", EventoLong_Calc(2.00, -0.50, true, true));
      Caso("evento short: +0,50 e' incluso",                EventoShort_Calc(0.50, 0.50, false, true));
      Caso("evento short: +0,49 non basta",                 !EventoShort_Calc(0.49, 0.50, false, true));
      Caso("gate SPENTO anche sullo short",                 EventoShort_Calc(-3.00, 0.50, true, true));
      Caso("short: giornata non valida non e' evento",      !EventoShort_Calc(0.60, 0.50, false, false));
     }

   //--- BLOCCO 4: mediana e percentili su vettori noti.
   blocchi++;
     {
      double b4_v[]; ArrayResize(b4_v, 5);
      b4_v[0]=1.0; b4_v[1]=2.0; b4_v[2]=3.0; b4_v[3]=10.0; b4_v[4]=100.0;
      Caso("mediana dispari = 3",                MathAbs(MedianaOrdinata_Calc(b4_v,5) - 3.0) < 0.000001);
      Caso("p95 (rango vicino) = 100",           MathAbs(PercentileOrdinato_Calc(b4_v,5,0.95) - 100.0) < 0.000001);
      Caso("p75 (ceil(3,75)-1 = 3) = 10",        MathAbs(PercentileOrdinato_Calc(b4_v,5,0.75) - 10.0) < 0.000001);
      Caso("p90 (ceil(4,5)-1 = 4) = 100",        MathAbs(PercentileOrdinato_Calc(b4_v,5,0.90) - 100.0) < 0.000001);
      double b4_p[]; ArrayResize(b4_p, 4);
      b4_p[0]=1.0; b4_p[1]=2.0; b4_p[2]=4.0; b4_p[3]=8.0;
      Caso("mediana pari = media dei due centrali (3)", MathAbs(MedianaOrdinata_Calc(b4_p,4) - 3.0) < 0.000001);
      Caso("nessun dato -> 0, non un numero comodo",    MathAbs(MedianaOrdinata_Calc(b4_v,0)) < 0.000001);
      Caso("media di 1,2,3,10,100 = 23,2",              MathAbs(Media_Calc(b4_v,5) - 23.2) < 0.000001);
     }

   //--- BLOCCO 5: percentile da istogramma (lo spread della campana).
   blocchi++;
     {
      long b5_h[]; ArrayResize(b5_h, 10); ArrayInitialize(b5_h, 0);
      b5_h[1] = 50; b5_h[2] = 30; b5_h[3] = 20;   // totale 100
      bool b5_ov = false;
      Caso("istogramma: mediana = 1",            PercentileIstogramma_Calc(b5_h,100,0.50,b5_ov) == 1 && !b5_ov);
      Caso("istogramma: p95 = 3",                PercentileIstogramma_Calc(b5_h,100,0.95,b5_ov) == 3 && !b5_ov);
      Caso("istogramma vuoto = -1",              PercentileIstogramma_Calc(b5_h,0,0.50,b5_ov) == -1);
      bool b5_ov2 = false;
      long b5_p99 = PercentileIstogramma_Calc(b5_h,110,0.99,b5_ov2);   // 10 campioni oltre il tetto
      Caso("percentile oltre il tetto si DICHIARA", b5_ov2 && b5_p99 == 10);
      Caso("i campioni oltre il tetto SPOSTANO la mediana (2)", PercentileIstogramma_Calc(b5_h,110,0.50,b5_ov2) == 2);
     }

   //--- BLOCCO 6: i cancelli congelati, calcolati DAL CODICE e non a
   //    mano su un foglio. Sono i numeri del file prova.
   blocchi++;
     {
      Caso("P0-1: 25 eventi passano",            EsitoP01_Calc(25) == GC_PASSA);
      Caso("P0-1: 24 eventi sono SCARTO",        EsitoP01_Calc(24) == GC_SCARTO);
      Caso("P0-2: 0,0988 contro 0,0112 (8,8x) passa", EsitoP02_Calc(0.0988, 0.0112) == GC_PASSA);
      Caso("P0-2: 0,02 contro 0,0112 (1,8x) e' SCARTO", EsitoP02_Calc(0.02, 0.0112) == GC_SCARTO);
      Caso("P0-2: media evento NEGATIVA e' SCARTO anche col controllo peggiore", EsitoP02_Calc(-0.05, -0.10) == GC_SCARTO);
      //  il "3x esatto" si COSTRUISCE (3,0 x 0,01) invece di scriverlo
      //  come 0,03: cosi' il caso sta sul confine per costruzione e non
      //  dipende da come l'ultimo bit del letterale viene arrotondato.
      Caso("P0-2: esattamente 3x passa (confine incluso)", EsitoP02_Calc(3.0*0.01, 0.01) == GC_PASSA);
      Caso("rapporto take/spread 30 su 5 = 6",   MathAbs(RapportoTakeSpread_Calc(30.0,5.0) - 6.0) < 0.000001);
      Caso("spread non misurato -> rapporto 0",  MathAbs(RapportoTakeSpread_Calc(30.0,0.0)) < 0.000001);
      Caso("P0-3: 6x passa",                     EsitoP03_Calc(6.0,5.0) == GC_PASSA);
      Caso("P0-3: 2,5x e' SOSPESO",              EsitoP03_Calc(2.5,5.0) == GC_SOSPESO);
      Caso("P0-3: 1,5x e' SCARTO",               EsitoP03_Calc(1.5,5.0) == GC_SCARTO);
      Caso("P0-3: senza spread e' NON MISURATO, non un pass", EsitoP03_Calc(6.0,0.0) == GC_NONMISURATO);
      Caso("quota 4 su 10 = 40%",                MathAbs(QuotaPct_Calc(4,10) - 40.0) < 0.000001);
      Caso("quota con denominatore nullo = 0",   MathAbs(QuotaPct_Calc(0,0)) < 0.000001);
      Caso("P0-6: 41 lunedi su 100 sospende",    EsitoP06Lunedi_Calc(41,100) == GC_SOSPESO);
      Caso("P0-6: 40 su 100 NON e' oltre il 40%", EsitoP06Lunedi_Calc(40,100) == GC_PASSA);
     }

   //--- BLOCCO 7: igiene della giornata e conversione delle unita'.
   blocchi++;
     {
      Caso("55 barre su 55 richieste: valida",   GiornataValida_Calc(55,55));
      Caso("54 barre su 55: fuori",              !GiornataValida_Calc(54,55));
      Caso("2 decimali -> 100 punti per unita'", MathAbs(PuntiPerUnita_Calc(2) - 100.0) < 0.000001);
      Caso("5 decimali -> 10",                   MathAbs(PuntiPerUnita_Calc(5) - 10.0) < 0.000001);
      Caso("0 decimali -> 1",                    MathAbs(PuntiPerUnita_Calc(0) - 1.0) < 0.000001);
      Caso("170 punti MT5 = 1,70 punti indice",  MathAbs(SpreadInUnita_Calc(170.0,100.0) - 1.7) < 0.000001);
      Caso("conversione senza divisore -> 0",    MathAbs(SpreadInUnita_Calc(170.0,0.0)) < 0.000001);
     }

   //--- BLOCCO 8: il guardiano delle colonne e la catena dei verdetti.
   blocchi++;
     {
      string b8_nomi[]; int b8_dec[];
      ColonneStats(b8_nomi, b8_dec);
      Caso("colonne dichiarate = GC_NSTATS",     ArraySize(b8_nomi) == GC_NSTATS);
      Caso("decimali dichiarati = GC_NSTATS",    ArraySize(b8_dec)  == GC_NSTATS);
      bool b8_vuoti = false;
      for(int b8_i=0; b8_i<ArraySize(b8_nomi); b8_i++) if(b8_nomi[b8_i] == "") b8_vuoti = true;
      Caso("nessuna colonna senza nome",         !b8_vuoti);
      int b8_a[]; ArrayResize(b8_a, 3);
      b8_a[0]=GC_PASSA; b8_a[1]=GC_SCARTO; b8_a[2]=GC_PASSA;
      Caso("un solo SCARTO domina tutto",        VerdettoComplessivo_Calc(b8_a,3) == GC_SCARTO);
      b8_a[1]=GC_SOSPESO;
      Caso("un SOSPESO senza scarti sospende",   VerdettoComplessivo_Calc(b8_a,3) == GC_SOSPESO);
      b8_a[1]=GC_NONMISURATO;
      Caso("un NON MISURATO non diventa mai verde", VerdettoComplessivo_Calc(b8_a,3) == GC_SOSPESO);
      b8_a[1]=GC_PASSA;
      Caso("tutti PASSA -> PASSA",               VerdettoComplessivo_Calc(b8_a,3) == GC_PASSA);
      Caso("nome dell'esito 2",                  NomeEsito(GC_PASSA) == "PASSA");
      Caso("nome dell'esito 0",                  NomeEsito(GC_SCARTO) == "SCARTO");
      Caso("nome dell'esito -1",                 NomeEsito(GC_NONMISURATO) == "NON MISURATO");
     }

   gAutotestBlocchi = blocchi;
   gAutotestFalliti = gCasiRossi;
   PrintFormat("[GAPCASH] AUTOTEST: %d blocchi su %d dichiarati, %d casi su %d dichiarati, %d falliti.",
               blocchi, ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI,
               gCasiFatti, ABTG_GAPCASH_AUTOTEST_CASI_ATTESI, gCasiRossi);
   if(blocchi != ABTG_GAPCASH_AUTOTEST_BLOCCHI_ATTESI || gCasiFatti != ABTG_GAPCASH_AUTOTEST_CASI_ATTESI)
      Print("[GAPCASH] ATTENZIONE: i conteggi dell'autotest non coincidono con i #define dichiarati nel sorgente. Non e' un guasto della misura, ma il sorgente e chi lo controlla non si raccontano la stessa cosa: va sistemato prima del prossimo pin.");
   return(gCasiRossi == 0);
  }

//==================================================================
//  LETTURE DAL TERMINALE
//==================================================================

//+------------------------------------------------------------------+
//| LA CHIUSURA CASH DEL GIORNO DI BORSA PRECEDENTE.                  |
//| Si cerca ALL'INDIETRO l'ultima barra M1 con orario dentro la      |
//| finestra [taglio - 5 ore, taglio] e con data PRECEDENTE a quella  |
//| della campana. E' la stessa definizione della misura esterna che  |
//| ha prodotto i numeri attesi (anatomia_aperture.py): la finestra   |
//| larga cinque ore serve alle MEZZE SEDUTE, che chiudono alle 13:00 |
//| New York -- con una finestra stretta il gap del giorno dopo       |
//| sarebbe "non misurato" proprio nei giorni piu' particolari.       |
//| Il salto del fine settimana si risolve DA SOLO: le barre della    |
//| domenica sera stanno fuori dalla finestra oraria, quindi si       |
//| arriva al venerdi'.                                               |
//| La ricerca si allarga a scalini (1, 3, 8 giorni) per non leggere  |
//| otto giorni di M1 quando ne basta uno.                            |
//+------------------------------------------------------------------+
double ChiusuraCashPrecedente(const datetime mezzanotte, datetime &tTrovata)
  {
   tTrovata = 0;
   int scalini[3];
   scalini[0] = GC_INDIETRO_1;
   scalini[1] = GC_INDIETRO_2;
   scalini[2] = GC_INDIETRO_3;
   int minDa = gMinChiusura - GC_FINESTRA_CHIUSURA_MIN;
   if(minDa < 0) minDa = 0;

   for(int s=0; s<3; s++)
     {
      datetime da = (datetime)((long)mezzanotte - (long)scalini[s]*86400);
      datetime a  = (datetime)((long)mezzanotte - 60);   // 23:59 del giorno prima
      MqlRates r[];
      ArraySetAsSeries(r, false);
      int n = CopyRates(_Symbol, PERIOD_M1, da, a, r);
      //--- n < 0 e' un ERRORE di lettura (storico non caricato); n == 0
      //    e' semplicemente "li' non c'erano barre", che su un fine
      //    settimana e' la risposta giusta e non un guasto. Contare i
      //    due casi insieme renderebbe il canarino inutile: si
      //    accenderebbe ogni sabato.
      if(n < 0){ gLettureM1Fallite++; continue; }
      if(n == 0) continue;
      for(int i=n-1; i>=0; i--)
        {
         int mdg = MinutiDelGiorno_Calc(r[i].time);
         if(mdg < minDa || mdg > gMinChiusura) continue;
         if(r[i].close <= 0.0) continue;
         tTrovata = r[i].time;
         return(r[i].close);
        }
     }
   return(0.0);
  }

//==================================================================
//  LA CONTABILITA' DI UNA GIORNATA
//==================================================================

//+------------------------------------------------------------------+
//| Azzera l'istogramma dello spread della giornata. Si tocca solo    |
//| l'intervallo di secchi davvero usato: azzerare 20.001 celle a     |
//| ogni giornata sarebbe lavoro buttato.                             |
//+------------------------------------------------------------------+
void AzzeraIstogrammaGiorno()
  {
   if(gBinMaxGiorno >= gBinMinGiorno)
      for(int b=gBinMinGiorno; b<=gBinMaxGiorno; b++) gIstoGiorno[b] = 0;
   gBinMinGiorno = GC_MAXBIN;
   gBinMaxGiorno = -1;
   gNGiorno    = 0;
   gOverGiorno = 0;
  }

//+------------------------------------------------------------------+
//| Riversa l'istogramma della giornata in uno degli istogrammi       |
//| cumulati. Si scorrono solo i secchi usati.                        |
//+------------------------------------------------------------------+
void RiversaIstogramma(long &destinazione[], long &nDest, long &overDest)
  {
   if(gBinMaxGiorno >= gBinMinGiorno)
      for(int b=gBinMinGiorno; b<=gBinMaxGiorno; b++) destinazione[b] += gIstoGiorno[b];
   nDest    += gNGiorno;
   overDest += gOverGiorno;
  }

//+------------------------------------------------------------------+
//| APRE una giornata nuova.                                          |
//+------------------------------------------------------------------+
void ApriGiornata(const datetime t)
  {
   gMezzanotte   = MezzanotteDi_Calc(t);
   MqlDateTime dt; TimeToStruct(t, dt);
   gDataInCorso  = dt.year*10000 + dt.mon*100 + dt.day;
   gGiornoChiuso = false;
   AzzeraIstogrammaGiorno();
   gGiornateConTick++;
  }

//+------------------------------------------------------------------+
//| CHIUDE la giornata: e' l'UNICO posto in cui nasce una riga di     |
//| tabella. Un solo punto da leggere per capire da dove viene ogni   |
//| numero del referto.                                               |
//+------------------------------------------------------------------+
void ChiudiGiornata()
  {
   if(gGiornoChiuso) return;
   gGiornoChiuso = true;
   if(gDataInCorso <= 0) return;

   GiornataGapCash g;
   g.data            = gDataInCorso;
   g.tCampana        = (datetime)((long)gMezzanotte + (long)gMinCampana*60);
   g.valida          = false;
   g.motivo          = GC_OK;
   g.barrePrimaOra   = 0;
   g.barreFinestra   = 0;
   g.offsetApertura  = -1;
   g.openCampana     = 0.0;
   g.chiusuraPrec    = 0.0;
   g.tChiusuraPrec   = 0;
   g.gapPt           = 0.0;
   g.gapPct          = 0.0;
   g.eventoLong      = false;
   g.eventoShort     = false;
   g.ret15Pct        = 0.0;
   g.ret15Pt         = 0.0;
   g.barra15Esatta   = false;
   g.upPct           = 0.0;
   g.dnPct           = 0.0;
   g.upPt            = 0.0;
   g.dnPt            = 0.0;
   g.tickCampana     = (int)gNGiorno;
   g.spreadMed       = 0.0;
   g.spreadP95       = 0.0;

   MqlDateTime dtg; TimeToStruct(g.tCampana, dtg);
   g.giornoSettimana = dtg.day_of_week;

   //--- spread MEDIANO e P95 del minuto della campana, per questa
   //    giornata. Il numero grezzo resta in PUNTI MT5.
   if(gNGiorno > 0)
     {
      bool ov1=false, ov2=false;
      long med = PercentileIstogramma_Calc(gIstoGiorno, gNGiorno, 0.50, ov1);
      long p95 = PercentileIstogramma_Calc(gIstoGiorno, gNGiorno, 0.95, ov2);
      g.spreadMed = (med >= 0) ? (double)med : 0.0;
      g.spreadP95 = (p95 >= 0) ? (double)p95 : 0.0;
     }

   //--- le barre M1 della PRIMA ORA (igiene P0-6) e della finestra
   MqlRates r[];
   ArraySetAsSeries(r, false);
   datetime da = g.tCampana;
   datetime a  = (datetime)((long)g.tCampana + (long)(GC_MIN_PRIMA_ORA - 1)*60);
   int n = CopyRates(_Symbol, PERIOD_M1, da, a, r);
   //--- vedi ChiusuraCashPrecedente: n < 0 e' un guasto di lettura,
   //    n == 0 e' un giorno senza sessione (sabato, domenica, festa) e
   //    NON e' un guasto. Sono due cose diverse e si contano diverse.
   if(n < 0) gLettureM1Fallite++;
   if(n <= 0)
     {
      g.motivo = GC_KO_POCHE_BARRE;
      Registra(g);
      return;
     }
   g.barrePrimaOra = n;

   if(!GiornataValida_Calc(g.barrePrimaOra, InpMinBarreM1PrimaOra))
     {
      g.motivo = GC_KO_POCHE_BARRE;
      Registra(g);
      return;
     }

   //--- LA BARRA DELLA CAMPANA. Prima si cerca quella ESATTA; se
   //    manca si ripiega sulla prima dei primi 5 minuti e il fatto
   //    finisce in colonna (offset_apertura_min), come nella misura
   //    esterna. Se non c'e' nemmeno quella, la giornata non ha
   //    apertura e non si misura.
   for(int i=0; i<n; i++)
     {
      int off = (int)(((long)r[i].time - (long)g.tCampana)/60);
      if(off < 0) continue;
      if(off >= GC_TOLLERANZA_APERTURA_MIN) break;
      if(r[i].open <= 0.0) continue;
      g.openCampana    = r[i].open;
      g.offsetApertura = off;
      break;
     }
   if(g.openCampana <= 0.0)
     {
      g.motivo = GC_KO_NO_CAMPANA;
      Registra(g);
      return;
     }

   //--- LA CHIUSURA CASH DEL GIORNO DI BORSA PRECEDENTE
   datetime tPrec = 0;
   double   prec  = ChiusuraCashPrecedente(gMezzanotte, tPrec);
   if(prec <= 0.0)
     {
      g.motivo = GC_KO_NO_CHIUSURA;
      Registra(g);
      return;
     }
   g.chiusuraPrec  = prec;
   g.tChiusuraPrec = tPrec;
   g.gapPt         = g.openCampana - prec;
   if(!GapPct_Calc(g.openCampana, prec, g.gapPct))
     {
      g.motivo = GC_KO_PREZZI;
      Registra(g);
      return;
     }

   //--- L'ORIZZONTE: dalla campana al minuto +InpMinutiUscita. La
   //    barra M1 che CHIUDE l'orizzonte e' quella con orario
   //    campana + (minuti - 1): la sua chiusura cade esattamente al
   //    minuto +N. Se manca, si usa l'ultima disponibile e la
   //    colonna barra15_esatta lo dichiara.
   datetime tFine = (datetime)((long)g.tCampana + (long)(InpMinutiUscita - 1)*60);
   double   maxHigh = 0.0, minLow = 0.0, chiusura = 0.0;
   bool     primo = true;
   int      nFin = 0;
   for(int i=0; i<n; i++)
     {
      if(r[i].time < g.tCampana) continue;
      if(r[i].time > tFine) break;
      if(r[i].high <= 0.0 || r[i].low <= 0.0 || r[i].close <= 0.0) continue;
      if(primo){ maxHigh = r[i].high; minLow = r[i].low; primo = false; }
      else
        {
         if(r[i].high > maxHigh) maxHigh = r[i].high;
         if(r[i].low  < minLow)  minLow  = r[i].low;
        }
      chiusura = r[i].close;
      if(r[i].time == tFine) g.barra15Esatta = true;
      nFin++;
     }
   if(nFin <= 0 || chiusura <= 0.0)
     {
      g.motivo = GC_KO_NO_FINESTRA;
      Registra(g);
      return;
     }
   g.barreFinestra = nFin;

   //--- i numeri della misura, tutti riferiti all'apertura della campana
   g.ret15Pct = VariazionePct_Calc(g.openCampana, chiusura);
   g.ret15Pt  = chiusura - g.openCampana;
   g.upPct    = VariazionePct_Calc(g.openCampana, maxHigh);
   g.dnPct    = VariazionePct_Calc(g.openCampana, minLow);
   g.upPt     = maxHigh - g.openCampana;
   g.dnPt     = g.openCampana - minLow;
   if(g.upPct < 0.0){ g.upPct = 0.0; g.upPt = 0.0; }
   if(g.dnPct > 0.0){ g.dnPct = 0.0; g.dnPt = 0.0; }

   g.valida      = true;
   g.motivo      = GC_OK;
   g.eventoLong  = EventoLong_Calc (g.gapPct, InpSogliaGapPct,      InpGateSpento, true);
   g.eventoShort = EventoShort_Calc(g.gapPct, InpSogliaGapShortPct, InpGateSpento, true);

   //--- lo spread della campana finisce negli istogrammi cumulati
   //    SOLO adesso, quando si sa che giornata era: cosi' P0-3 puo'
   //    dire quanto costa il minuto della campana NELLE GIORNATE IN
   //    CUI si entrerebbe, e non in media su tutto.
   if(gNGiorno > 0)
     {
      RiversaIstogramma(gIstoTutti, gNTutti, gOverTutti);
      if(g.eventoLong)  RiversaIstogramma(gIstoEventoL, gNEventoL, gOverEventoL);
      if(g.eventoShort) RiversaIstogramma(gIstoEventoS, gNEventoS, gOverEventoS);
     }

   Registra(g);
  }

//+------------------------------------------------------------------+
//| Mette la giornata in tabella. Se il tetto e' pieno lo DICE (e il  |
//| referto lo ripete): un troncamento silenzioso e' una misura       |
//| sbagliata che sembra sana.                                        |
//+------------------------------------------------------------------+
void Registra(GiornataGapCash &g)
  {
   if(gNG >= GC_MAX_GIORNATE)
     {
      if(!gTroncato)
        {
         gTroncato = true;
         Print("[GAPCASH] ATTENZIONE: raggiunto il tetto di ", GC_MAX_GIORNATE, " giornate in memoria. Le giornate successive NON entrano nella tabella e i numeri aggregati sono TRONCATI: non vanno letti.");
        }
      return;
     }
   ArrayResize(gG, gNG+1);
   gG[gNG] = g;
   gNG++;
  }

//==================================================================
//  RACCOLTA DEI VALORI PER I PERCENTILI
//==================================================================

//+------------------------------------------------------------------+
//| Riempie 'fuori' coi valori di un CAMPO per le giornate scelte dal |
//| FILTRO, gia' orientati sul LATO chiesto. E' l'unico posto in cui  |
//| si decide come un numero LONG diventa il suo gemello SHORT:       |
//|   rendimento short = meno il rendimento long                      |
//|   MFE short  = l'escursione al RIBASSO (in valore assoluto)       |
//|   MAE short  = l'escursione al RIALZO                             |
//| Se questa simmetria fosse sparsa in dieci posti, prima o poi uno  |
//| dei dieci sbaglierebbe segno e il lato short direbbe il falso.    |
//+------------------------------------------------------------------+
int Raccogli(const int filtro, const int lato, const int campo, double &fuori[])
  {
   ArrayResize(fuori, 0);
   int q = 0;
   for(int i=0; i<gNG; i++)
     {
      if(!gG[i].valida) continue;
      if(filtro == GC_FILTRO_EVENTO_L   && !gG[i].eventoLong)  continue;
      if(filtro == GC_FILTRO_EVENTO_S   && !gG[i].eventoShort) continue;
      if(filtro == GC_FILTRO_NON_EVENTO &&  gG[i].eventoLong)  continue;

      double v = 0.0;
      bool   sh = (lato == GC_LATO_SHORT);
      if(campo == GC_CAMPO_RET_PCT)      v = sh ? -gG[i].ret15Pct : gG[i].ret15Pct;
      else if(campo == GC_CAMPO_RET_PT)  v = sh ? -gG[i].ret15Pt  : gG[i].ret15Pt;
      else if(campo == GC_CAMPO_MFE_PCT) v = sh ? -gG[i].dnPct    : gG[i].upPct;
      else if(campo == GC_CAMPO_MAE_PCT) v = sh ?  gG[i].upPct    : -gG[i].dnPct;
      else if(campo == GC_CAMPO_MFE_PT)  v = sh ?  gG[i].dnPt     : gG[i].upPt;
      else if(campo == GC_CAMPO_MAE_PT)  v = sh ?  gG[i].upPt     : gG[i].dnPt;

      ArrayResize(fuori, q+1);
      fuori[q] = v;
      q++;
     }
   return(q);
  }

//+------------------------------------------------------------------+
//| Percentuale di valori positivi di un vettore (il "win", che qui   |
//| NON e' un win rate di operazioni: non ci sono operazioni. E' la   |
//| quota di giornate in cui la deriva dei 15 minuti e' stata a       |
//| favore del lato, LORDA, senza costi e senza stop).                |
//+------------------------------------------------------------------+
double QuotaPositivi(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   int p = 0;
   for(int i=0; i<n; i++) if(v[i] > 0.0) p++;
   return(100.0*(double)p/(double)n);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   Print("[GAPCASH] ", ABTG_GAPCASH_MARCATORE);
   Print("[GAPCASH] E' un CONTATORE: nessun ordine, nessun lotto, nessun magic, nessuna sedia. Produce una tabella, non un profitto.");

   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che risponde a
   //    un'altra domanda rispetto a quella scritta nel file prova.
   if(InpOraAperturaServer < 0 || InpOraAperturaServer > 23)
     { Print("[GAPCASH] ERRORE: InpOraAperturaServer deve stare fra 0 e 23 (ORA SERVER)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpMinAperturaServer < 0 || InpMinAperturaServer > 59)
     { Print("[GAPCASH] ERRORE: InpMinAperturaServer deve stare fra 0 e 59."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpMinutiUscita < 1 || InpMinutiUscita > 240)
     { Print("[GAPCASH] ERRORE: InpMinutiUscita deve stare fra 1 e 240 minuti."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpLato < 0 || InpLato > 2)
     { Print("[GAPCASH] ERRORE: InpLato ammette 0 (entrambi), 1 (solo long) o 2 (solo short)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpSogliaGapPct >= 0.0)
     { Print("[GAPCASH] ERRORE: InpSogliaGapPct e' la soglia del gap IN GIU' e dev'essere NEGATIVA (il contratto spazzola da -0,30 a -1,00)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpSogliaGapShortPct <= 0.0)
     { Print("[GAPCASH] ERRORE: InpSogliaGapShortPct e' la soglia del gap IN SU e dev'essere POSITIVA (P0-5: +0,50)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpMinBarreM1PrimaOra < 1 || InpMinBarreM1PrimaOra > GC_MIN_PRIMA_ORA)
     { Print("[GAPCASH] ERRORE: InpMinBarreM1PrimaOra deve stare fra 1 e 60."); return(INIT_PARAMETERS_INCORRECT); }

   gMinCampana  = MinutiCampana_Calc(InpOraAperturaServer, InpMinAperturaServer);
   gMinChiusura = MinutiChiusuraCash_Calc(InpOraAperturaServer, InpMinAperturaServer);
   if(gMinChiusura >= 24*60)
     { Print("[GAPCASH] ERRORE: con questa campana il taglio della chiusura cash sforerebbe la mezzanotte del server. Non parto."); return(INIT_PARAMETERS_INCORRECT); }
   if(gMinCampana + InpMinutiUscita >= 24*60)
     { Print("[GAPCASH] ERRORE: l'orizzonte sforerebbe la mezzanotte del server. Non parto."); return(INIT_PARAMETERS_INCORRECT); }

   //--- anagrafica del simbolo
   gDigits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   gPoint  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   if(gPoint <= 0.0) gPoint = MathPow(10, -gDigits);
   gPPU    = PuntiPerUnita_Calc(gDigits);
   gUnita  = (gDigits >= 3) ? "pip" : "punti indice";
   if(gDigits != 2)
      Print("[GAPCASH] ATTENZIONE: il simbolo ha ", gDigits, " decimali. L'etichetta 'punti indice' e le conversioni sono tarate sugli indici BCM a 2 decimali: qui l'unita' pratica e' '", gUnita, "' e va letta come tale.");

   //--- istogrammi dello spread
   ArrayResize(gIstoGiorno,  GC_MAXBIN); ArrayInitialize(gIstoGiorno,  0);
   ArrayResize(gIstoEventoL, GC_MAXBIN); ArrayInitialize(gIstoEventoL, 0);
   ArrayResize(gIstoEventoS, GC_MAXBIN); ArrayInitialize(gIstoEventoS, 0);
   ArrayResize(gIstoTutti,   GC_MAXBIN); ArrayInitialize(gIstoTutti,   0);
   gBinMinGiorno = GC_MAXBIN;
   gBinMaxGiorno = -1;

   ArrayResize(gG, 0);
   gNG = 0;

   if(InpAutoTest)
     {
      if(!AutoTestGapCash())
         Print("[GAPCASH] *** ROSSO SONDAGAPCASH *** l'autotest ha casi falliti: la misura NON e' affidabile. Ferma la corsa e segnala.");
     }
   else
      Print("[GAPCASH] autotest DISATTIVATO da input: nessuna verifica a tavolino in questo avvio (la colonna 'Autotest Falliti' vale -1, che NON e' 'passato').");

   Log(StringFormat("avviata su %s %s. Campana %02d:%02d ORA SERVER (= %02d:%02d italiane = 09:30 New York quando le due ore legali coincidono). Taglio della chiusura cash RICAVATO: %02d:%02d server.",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
                    gMinCampana/60, gMinCampana%60,
                    (gMinCampana/60 + 1)%24, gMinCampana%60,
                    gMinChiusura/60, gMinChiusura%60));
   Log(StringFormat("gate %s | soglia LONG %.2f%% | soglia SHORT %.2f%% (fissa, P0-5) | orizzonte %d minuti | lato %d | igiene >= %d barre M1 nei primi %d minuti",
                    (InpGateSpento ? "SPENTO (corsa di CONTROLLO)" : "acceso"),
                    InpSogliaGapPct, InpSogliaGapShortPct, InpMinutiUscita, InpLato,
                    InpMinBarreM1PrimaOra, GC_MIN_PRIMA_ORA));
   Log(StringFormat("spread del minuto della campana: %s. Cancelli congelati: P0-1 >= %d eventi | P0-2 media > 0 e >= %.0fx il controllo | P0-3 take >= %.0fx spread (sospeso fra %.0fx e %.0fx) | P0-6 lunedi' <= %.0f%%.",
                    (InpMisuraSpreadCampana ? "MISURATO tick per tick" : "NON misurato (input spento): P0-3 restera' NON MISURATO"),
                    GC_P01_EVENTI_MINIMI, GC_P02_SEPARAZIONE_MIN,
                    GC_P03_MULTIPLO_PASSA, GC_P03_MULTIPLO_SOSPESO, GC_P03_MULTIPLO_PASSA,
                    GC_P06_QUOTA_LUNEDI_KO));
   if(MQLInfoInteger(MQL_OPTIMIZATION))
      Log("siamo in OTTIMIZZAZIONE: il CSV riga-per-giornata e il referto NON si scrivono (le passate si sovrascriverebbero). Tutti i numeri escono nelle colonne di OPTFRAME.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+------------------------------------------------------------------+
//| UN SOLO GESTO PER TICK, e l'ordine e' parte della specifica:      |
//|   1. se e' cambiata la giornata, si chiude quella di prima        |
//|      (nessuna giornata resta a meta');                            |
//|   2. dentro il minuto della campana si campiona lo SPREAD, che    |
//|      e' l'unica cosa che l'OHLC non puo' dare;                    |
//|   3. passata la prima ora si chiude la contabilita' del giorno.   |
//| Nessun prezzo di questo tick entra nella misura del gap o del     |
//| rendimento: quelli si leggono dalle barre M1, cosi' il numero e'  |
//| RIFACIBILE da fuori con qualunque storico OHLC.                   |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlTick t;
   if(!SymbolInfoTick(_Symbol, t)) return;
   datetime ora = (t.time > 0) ? t.time : TimeCurrent();
   if(ora <= 0) return;

   MqlDateTime dt; TimeToStruct(ora, dt);
   int oggi = dt.year*10000 + dt.mon*100 + dt.day;
   if(oggi != gDataInCorso)
     {
      ChiudiGiornata();
      ApriGiornata(ora);
     }

   int mdg = MinutiDelGiorno_Calc(ora);

   if(InpMisuraSpreadCampana && DentroMinutoCampana_Calc(mdg, gMinCampana))
      CampionaSpread(t);

   if(!gGiornoChiuso && FinestraChiusa_Calc(mdg, gMinCampana))
      ChiudiGiornata();
  }

//+------------------------------------------------------------------+
//| IL CAMPIONE DI SPREAD, preso DENTRO il minuto della campana e     |
//| tick per tick. E' il numero che non abbiamo mai misurato: la      |
//| tabella di casa (SPREAD_FLOTTA_MISURA_2026-09-03) da' la mediana  |
//| della FASCIA 14-20, e quel minuto e' il peggiore della giornata.  |
//| Un ask sotto il bid e' un tick sporco, non uno spread negativo:   |
//| si scarta e si conta.                                             |
//+------------------------------------------------------------------+
void CampionaSpread(const MqlTick &t)
  {
   if(t.bid <= 0.0 || t.ask <= 0.0 || t.ask < t.bid || gPoint <= 0.0)
     {
      gTickScartati++;
      return;
     }
   long pts = (long)MathRound((t.ask - t.bid)/gPoint);
   if(pts < 0) pts = 0;
   if(pts < GC_MAXBIN)
     {
      int b = (int)pts;
      gIstoGiorno[b]++;
      if(b < gBinMinGiorno) gBinMinGiorno = b;
      if(b > gBinMaxGiorno) gBinMaxGiorno = b;
     }
   else
      gOverGiorno++;
   //--- gNGiorno conta TUTTI i campioni validi, compresi quelli finiti
   //    oltre il tetto: gOverGiorno e' un DI CUI, non un in piu'. E'
   //    la convenzione che PercentileIstogramma_Calc si aspetta.
   gNGiorno++;
  }

//==================================================================
//  I NOMI DEI FILE -- due corse non si sovrascrivono MAI
//  Nel nome entrano: simbolo, periodo, GATE o CONTROLLO, la soglia,
//  l'etichetta libera e le date della PRIMA e dell'ULTIMA giornata
//  vista. Cosi' la corsa dentro campione e quella fuori campione
//  dello stesso sweep -- che hanno gli STESSI input e cambiano solo
//  la finestra di date -- finiscono in due file diversi invece di
//  sovrascriversi. E' una classe di difetto gia' pagata in casa, e
//  lo stesso vale per la corsa col gate acceso contro quella di
//  CONTROLLO, che il contratto vuole in due CSV distinti.
//==================================================================
string EtichettaNumero(const double v, const int dec)
  {
   string s = DoubleToString(v, dec);
   StringReplace(s, "-", "m");
   StringReplace(s, ".", "p");
   return(s);
  }

string NomePeriodo()
  {
   string s = EnumToString((ENUM_TIMEFRAMES)Period());
   if(StringSubstr(s, 0, 7) == "PERIOD_") s = StringSubstr(s, 7);
   return(s);
  }

string BaseNomeFile()
  {
   int primo = (gNG > 0) ? gG[0].data      : 0;
   int ultimo= (gNG > 0) ? gG[gNG-1].data  : 0;
   string tag = (InpTagCorsa == "") ? "" : ("_" + InpTagCorsa);
   return(StringFormat("ABTG_SondaGapCash_%s_%s_%s_s%s%s_%d-%d",
                       _Symbol, NomePeriodo(),
                       (InpGateSpento ? "CONTROLLO" : "GATE"),
                       EtichettaNumero(InpSogliaGapPct, 2), tag,
                       primo, ultimo));
  }

//==================================================================
//  IL CSV RIGA-PER-GIORNATA
//  Una riga per ogni giornata che ha avuto tick, valida o no. Con
//  gap_pct in colonna, TUTTE E OTTO le celle dello sweep si possono
//  RIFARE da fuori partendo da un'unica corsa singola: la soglia
//  tocca solo le due colonne evento_*, non i numeri.
//==================================================================
void ScriviCsvGiornate()
  {
   gFileCsv = BaseNomeFile() + "_giornate.csv";
   int h = FileOpen(gFileCsv, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
   if(h == INVALID_HANDLE)
     {
      Print("[GAPCASH] ATTENZIONE: CSV delle giornate NON scritto (errore ", GetLastError(), "): i numeri restano solo nel referto e nelle colonne, e non si possono ricontare a mano.");
      gFileCsv = "NON SCRITTO";
      return;
     }
   FileWrite(h, "data","giorno_settimana","ora_campana_server","valida","motivo",
                "barre_m1_prima_ora","barre_finestra","offset_apertura_min",
                "open_campana","chiusura_cash_prec","ora_chiusura_cash_prec",
                "gap_pt","gap_pct","evento_long","evento_short",
                "ret15_long_pct","ret15_long_pt","barra_orizzonte_esatta",
                "mfe_long_pct","mae_abs_long_pct","mfe_long_pt","mae_abs_long_pt",
                "mfe_short_pct","mae_abs_short_pct",
                "tick_campana","spread_campana_mediano_pt_mt5","spread_campana_p95_pt_mt5",
                "spread_campana_mediano_unita","spread_campana_p95_unita");
   for(int i=0; i<gNG; i++)
     {
      FileWrite(h,
         IntegerToString(gG[i].data),
         IntegerToString(gG[i].giornoSettimana),
         TimeToString(gG[i].tCampana, TIME_DATE|TIME_MINUTES),
         (gG[i].valida ? "1" : "0"),
         NomeMotivo(gG[i].motivo),
         IntegerToString(gG[i].barrePrimaOra),
         IntegerToString(gG[i].barreFinestra),
         IntegerToString(gG[i].offsetApertura),
         DoubleToString(gG[i].openCampana, gDigits),
         DoubleToString(gG[i].chiusuraPrec, gDigits),
         (gG[i].tChiusuraPrec > 0 ? TimeToString(gG[i].tChiusuraPrec, TIME_DATE|TIME_MINUTES) : ""),
         DoubleToString(gG[i].gapPt, 3),
         DoubleToString(gG[i].gapPct, 5),
         (gG[i].eventoLong ? "1" : "0"),
         (gG[i].eventoShort ? "1" : "0"),
         DoubleToString(gG[i].ret15Pct, 5),
         DoubleToString(gG[i].ret15Pt, 3),
         (gG[i].barra15Esatta ? "1" : "0"),
         DoubleToString(gG[i].upPct, 5),
         DoubleToString(-gG[i].dnPct, 5),
         DoubleToString(gG[i].upPt, 3),
         DoubleToString(gG[i].dnPt, 3),
         DoubleToString(-gG[i].dnPct, 5),
         DoubleToString(gG[i].upPct, 5),
         IntegerToString(gG[i].tickCampana),
         DoubleToString(gG[i].spreadMed, 0),
         DoubleToString(gG[i].spreadP95, 0),
         DoubleToString(SpreadInUnita_Calc(gG[i].spreadMed, gPPU), 4),
         DoubleToString(SpreadInUnita_Calc(gG[i].spreadP95, gPPU), 4));
     }
   FileClose(h);
  }

//==================================================================
//  IL REFERTO -- organizzato ESATTAMENTE sui criteri P0-1 ... P0-7,
//  ognuno col suo verdetto CALCOLATO DAL CODICE. Non si lascia
//  niente da interpretare a mano: un cancello che qualcuno deve
//  ricalcolare in un foglio non e' un cancello.
//==================================================================
void RigaReferto(const int h, const string s)
  {
   if(h != INVALID_HANDLE) FileWriteString(h, s + "\r\n");
   Print("[GAPCASH] ", s);
  }

void ScriviReferto(const double &s[])
  {
   int h = INVALID_HANDLE;
   if(InpScriviCsv)
     {
      gFileReferto = BaseNomeFile() + "_REFERTO.txt";
      h = FileOpen(gFileReferto, FILE_WRITE|FILE_TXT|FILE_ANSI);
      if(h == INVALID_HANDLE)
        {
         Print("[GAPCASH] ATTENZIONE: referto NON scritto su file (errore ", GetLastError(), "). Sotto c'e' comunque tutto nel log.");
         gFileReferto = "NON SCRITTO";
        }
     }

   RigaReferto(h, "=====================================================================");
   RigaReferto(h, "  " + ABTG_GAPCASH_MARCATORE);
   RigaReferto(h, "  PASSO 0 di GAPCASH_NAS -- contratto: prove\\GAPCASH_NAS_PASSO0.txt");
   RigaReferto(h, "  E' un CONTATORE: nessun ordine, nessun lotto, nessun magic.");
   RigaReferto(h, "=====================================================================");
   RigaReferto(h, StringFormat("simbolo/periodo .....: %s %s   decimali %d, 1 %s = %.0f punti MT5",
                               _Symbol, NomePeriodo(), gDigits, gUnita, gPPU));
   RigaReferto(h, StringFormat("corsa ...............: %s | soglia LONG %.2f%% | soglia SHORT %.2f%% | orizzonte %d minuti | lato %d",
                               (InpGateSpento ? "CONTROLLO (gate SPENTO)" : "GATE ACCESO"),
                               InpSogliaGapPct, InpSogliaGapShortPct, InpMinutiUscita, InpLato));
   RigaReferto(h, StringFormat("campana .............: %02d:%02d ORA SERVER   taglio chiusura cash RICAVATO: %02d:%02d ORA SERVER",
                               gMinCampana/60, gMinCampana%60, gMinChiusura/60, gMinChiusura%60));
   if(gNG > 0)
      RigaReferto(h, StringFormat("giornate viste ......: dalla %d alla %d (%d righe di tabella)", gG[0].data, gG[gNG-1].data, gNG));
   if(InpLato != 0)
      RigaReferto(h, StringFormat("*** InpLato = %d: i verdetti del lato spento escono NON MISURATI (e un NON MISURATO non diventa mai verde). Le MISURE dell'altro lato restano stampate: sono numeri, non promozioni. ***", InpLato));
   RigaReferto(h, StringFormat("prima barra M1 nello storico del simbolo: %s",
                               TimeToString((datetime)(long)SeriesInfoInteger(_Symbol, PERIOD_M1, SERIES_FIRSTDATE), TIME_DATE|TIME_MINUTES)));
   RigaReferto(h, StringFormat("autotest ............: %d casi falliti su %d blocchi (-1 = NON eseguito, che non e' 'passato')",
                               gAutotestFalliti, gAutotestBlocchi));
   RigaReferto(h, "");
   RigaReferto(h, "COME SI LEGGONO LE ORE, e non e' un dettaglio:");
   RigaReferto(h, " - tutte le ore di questo referto sono ORA SERVER BCM (= italiana meno 1).");
   RigaReferto(h, " - le schede Esperti/Giornale di MT5 sono in ora LOCALE del PC: non si confrontano.");
   RigaReferto(h, " - ERRORE NOTO E NON MISURATO: l'ora legale americana e quella europea non");
   RigaReferto(h, "   cambiano lo stesso giorno. Per circa tre settimane l'anno le 09:30 di New");
   RigaReferto(h, "   York NON sono le 14:30 del server, e in quelle giornate questa sonda misura");
   RigaReferto(h, "   un minuto sbagliato di 60. E' il prezzo della versione semplice, pagato");
   RigaReferto(h, "   consapevolmente e dichiarato, non nascosto.");
   RigaReferto(h, "");
   RigaReferto(h, "LA GRANDEZZA MISURATA, per non confonderla con una che abbiamo gia':");
   RigaReferto(h, "   gap = Open della barra della CAMPANA meno l'ultima chiusura CASH del giorno");
   RigaReferto(h, "         di borsa precedente (ultima barra M1 con orario dentro le 5 ore che");
   RigaReferto(h, "         finiscono al taglio), in % di quella chiusura.");
   RigaReferto(h, "   NON e' il gap D1 del CFD (apertura D1 meno chiusura D1 precedente), che");
   RigaReferto(h, "   salta la MEZZANOTTE DEL SERVER ed e' quello gia' misurato in R61/R62.");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  IGIENE DEL CAMPIONE (e' P0-6, ma si legge prima di tutto il resto)");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("giornate con tick ...........: %.0f", s[0]));
   RigaReferto(h, StringFormat("giornate VALIDE .............: %.0f   (>= %d barre M1 nei primi %d minuti)",
                               s[1], InpMinBarreM1PrimaOra, GC_MIN_PRIMA_ORA));
   RigaReferto(h, StringFormat("scartate per poche barre ....: %.0f   (festivi e mezze sedute)", s[2]));
   RigaReferto(h, StringFormat("scartate per dati mancanti ..: %.0f   (campana, chiusura precedente o orizzonte)", s[3]));
   RigaReferto(h, StringFormat("barre M1 nella prima ora, mediana: %.1f su %d", s[45], GC_MIN_PRIMA_ORA));
   RigaReferto(h, StringFormat("aperture NON esatte (ripiego entro %d minuti): %.0f", GC_TOLLERANZA_APERTURA_MIN, s[46]));
   RigaReferto(h, StringFormat("letture M1 fallite ..........: %.0f   (dovrebbe essere ~0: se e' alto, lo storico M1 non copre la finestra)", s[58]));
   if(s[59] > 0.0)
      RigaReferto(h, "*** TABELLA TRONCATA: il tetto delle giornate in memoria e' stato toccato. I numeri aggregati NON vanno letti. ***");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("  P0-1 FREQUENZA -- cancello: >= %d giornate-evento", GC_P01_EVENTI_MINIMI));
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("giornate-evento (gap <= %.2f%%): %.0f su %.0f valide (%.2f%%)",
                               InpSogliaGapPct, s[4], s[1], QuotaPct_Calc((long)s[4], (long)s[1])));
   RigaReferto(h, StringFormat("VERDETTO P0-1: %s", NomeEsito((int)s[5])));
   RigaReferto(h, "nota scritta PRIMA, e non e' una scusa: anche passando, questo motore fa");
   RigaReferto(h, "circa 0,14 eventi al giorno, cioe' un OTTAVO del pavimento di frequenza di");
   RigaReferto(h, "casa. NON PUO' essere portata: al massimo entra come CECCHINO, e il verdetto");
   RigaReferto(h, "di MERITO a tick su n=150+150 su questo simbolo non e' raggiungibile prima");
   RigaReferto(h, "di anni.");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("  P0-2 SEGNO E SEPARAZIONE -- il criterio che decide (>= %.0fx)", GC_P02_SEPARAZIONE_MIN));
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("media del rendimento a +%d minuti, giornate-EVENTO ..: %+.4f%%   (mediana %+.4f%%, positive %.2f%%)",
                               InpMinutiUscita, s[6], s[12], s[13]));
   RigaReferto(h, StringFormat("media sulle giornate valide (CONTROLLO, tutte) .....: %+.4f%%   (positive %.2f%%)", s[7], s[14]));
   RigaReferto(h, StringFormat("media sulle giornate NON evento (informativa) ......: %+.4f%%", s[8]));
   RigaReferto(h, StringFormat("separazione ........................................: %.2fx", s[9]));
   RigaReferto(h, StringFormat("VERDETTO P0-2: %s", NomeEsito((int)s[10])));
   if(s[11] > 0.0)
     {
      RigaReferto(h, "*** ATTENZIONE: la media di CONTROLLO e' <= 0. La condizione 'almeno 3x il");
      RigaReferto(h, "    controllo' e' allora vera per ARITMETICA e non vuol dire piu' niente: il");
      RigaReferto(h, "    verdetto qui sopra e' calcolato ALLA LETTERA del criterio congelato, ma");
      RigaReferto(h, "    la separazione va letta come NON DIMOSTRATA. Il numero che conta in quel");
      RigaReferto(h, "    caso e' il segno della media evento, non il rapporto. ***");
     }
   if(InpGateSpento)
     {
      RigaReferto(h, "*** CORSA DI CONTROLLO (gate SPENTO): qui evento e controllo sono la STESSA");
      RigaReferto(h, "    popolazione, la separazione vale 1,00x per costruzione e il verdetto P0-2");
      RigaReferto(h, "    NON si applica. Questa corsa serve a produrre la media di controllo, che");
      RigaReferto(h, "    si confronta con quella della corsa a gate acceso. ***");
     }
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  P0-3 COSTO -- lo spread del minuto della campana, DA SOLO");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("finestra misurata ...: %02d:%02d:00 - %02d:%02d:00 ORA SERVER, tick per tick",
                               gMinCampana/60, gMinCampana%60, (gMinCampana+1)/60, (gMinCampana+1)%60));
   RigaReferto(h, StringFormat("spread nelle giornate-EVENTO: mediana %.4f %s   P95 %.4f %s   (su %.0f tick)",
                               s[16], gUnita, s[17], gUnita, s[22]));
   RigaReferto(h, StringFormat("spread su tutte le giornate VALIDE: mediana %.4f %s   P95 %.4f %s   (su %.0f tick)",
                               s[18], gUnita, s[19], gUnita, s[23]));
   RigaReferto(h, StringFormat("take MEDIANO delle giornate-evento ...: %.4f %s", s[15], gUnita));
   RigaReferto(h, StringFormat("rapporto take / spread mediano .......: %.2fx   (cancello: >= %.0fx passa, %.0f-%.0fx sospeso, sotto %.0fx scarto)",
                               s[20], GC_P03_MULTIPLO_PASSA, GC_P03_MULTIPLO_SOSPESO, GC_P03_MULTIPLO_PASSA, GC_P03_MULTIPLO_SOSPESO));
   RigaReferto(h, StringFormat("VERDETTO P0-3: %s", NomeEsito((int)s[21])));
   RigaReferto(h, "il rapporto usa lo spread delle giornate in cui si entrerebbe, non la media");
   RigaReferto(h, "di tutte: e' il prezzo che si pagherebbe davvero. La riga su TUTTE le");
   RigaReferto(h, "giornate e' li' come controllo, e le due si leggono insieme.");
   RigaReferto(h, StringFormat("tick scartati nel minuto della campana (ask sotto il bid, tick sporchi): %.0f", s[62]));
   if(s[24] > 0.0)
      RigaReferto(h, StringFormat("*** %.0f campioni di spread sono finiti OLTRE IL TETTO dell'istogramma: i percentili in quella coda sono dichiarati, non stimati. ***", s[24]));
   if(!InpMisuraSpreadCampana)
      RigaReferto(h, "*** InpMisuraSpreadCampana e' SPENTO: lo spread non e' stato misurato e P0-3 e' NON MISURATO. Non e' un pass. ***");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  P0-4 GEOMETRIA -- nessun cancello: si LEGGE, e fissa lo stop dopo");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("|MAE| nei %d minuti (giornate-evento, LONG): p50 %.4f%%   p75 %.4f%%   p90 %.4f%%",
                               InpMinutiUscita, s[25], s[26], s[27]));
   RigaReferto(h, StringFormat("MFE   nei %d minuti (giornate-evento, LONG): p50 %.4f%%   p75 %.4f%%   p90 %.4f%%",
                               InpMinutiUscita, s[28], s[29], s[30]));
   RigaReferto(h, StringFormat("in unita' pratiche: |MAE| p75 = %.3f %s   MFE p50 = %.3f %s", s[31], gUnita, s[32], gUnita));
   RigaReferto(h, "REGOLA SCRITTA ADESSO, per non doverla difendere dopo: lo stop del round");
   RigaReferto(h, "successivo e' il p75 di |MAE| qui sopra, ARROTONDATO. Non si spazzola lo");
   RigaReferto(h, "stop cercando il picco: quella cella e' la trappola gia' misurata.");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  P0-5 DUE LATI -- la stessa misura sul lato SHORT (regola del 25/08)");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "PREVISIONE CONGELATA PRIMA DELLA CORSA: NULLA. Sul feed esterno il lato");
   RigaReferto(h, "short fa +0,0076% con 51,0% di positive contro un controllo di 50,8%.");
   RigaReferto(h, StringFormat("giornate-evento SHORT (gap >= %.2f%%): %.0f", InpSogliaGapShortPct, s[33]));
   RigaReferto(h, StringFormat("media a +%d minuti (SHORT) ...: %+.4f%%   mediana %+.4f%%   positive %.2f%%   separazione %.2fx",
                               InpMinutiUscita, s[34], s[35], s[36], s[37]));
   RigaReferto(h, StringFormat("|MAE| p75 %.4f%%   MFE p50 %.4f%%", s[40], s[41]));
   RigaReferto(h, StringFormat("letture: frequenza %s | separazione %s", NomeEsito((int)s[38]), NomeEsito((int)s[39])));
   //--- il controllo dello short e' meno il controllo del long: se il
   //    controllo long e' positivo, quello short e' negativo e il
   //    "3x" diventa vero per aritmetica. Va detto QUI, dove il numero
   //    si legge, non in fondo.
   if(s[7] >= 0.0)
     {
      RigaReferto(h, "*** ATTENZIONE: il controllo del lato SHORT e' meno quello del lato LONG,");
      RigaReferto(h, "    quindi qui e' <= 0 e la separazione short e' vera per ARITMETICA. Sul lato");
      RigaReferto(h, "    short guarda il SEGNO della media e la quota di positive contro il 50%,");
      RigaReferto(h, "    non il rapporto. ***");
     }
   RigaReferto(h, "la soglia short e' FISSA e NON specchia quella long: nelle otto celle dello");
   RigaReferto(h, "sweep il numero short e' LO STESSO in tutte e otto, non otto misure diverse.");
   RigaReferto(h, "SE IL LATO SHORT USCISSE VIVO non e' una cosa da festeggiare: vorrebbe dire");
   RigaReferto(h, "che il feed esterno e quello BCM non raccontano la stessa storia, e allora il");
   RigaReferto(h, "problema e' il DATO, non il motore.");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  P0-6 IGIENE -- il canarino del LUNEDI'");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, StringFormat("giornate-evento di LUNEDI': %.0f su %.0f = %.2f%%   (soglia: oltre %.0f%% si SOSPENDE)",
                               s[42], s[4], s[43], GC_P06_QUOTA_LUNEDI_KO));
   RigaReferto(h, StringFormat("VERDETTO P0-6: %s", NomeEsito((int)s[44])));
   RigaReferto(h, "se i lunedi' fossero oltre il 40%, questo motore sarebbe il gap del weekend");
   RigaReferto(h, "travestito -- ed e' gia' misurato da R61/R62. In quel caso il verdetto e'");
   RigaReferto(h, "SOSPESO e se ne riparla, non si aggiusta.");
   RigaReferto(h, "");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "  P0-7 COLLISIONE -- obbligo di referto, non un cancello");
   RigaReferto(h, "---------------------------------------------------------------------");
   RigaReferto(h, "cosa gira gia' su NASUSD alle 14:30:00 ORA SERVER:");
   RigaReferto(h, "  1. ABTG_ORB (magic 770601, M5): straddio sugli estremi del range");
   RigaReferto(h, "     14:25-14:30. Gia' morto a tick in R97 (0 celle su 4, PF fuori campione");
   RigaReferto(h, "     0,84-0,91 su n=135).");
   RigaReferto(h, "  2. Nasdaq_Apertura_US_Ottimizzato (M5): il motore che calcola il gap D1");
   RigaReferto(h, "     del CFD, cioe' un'ALTRA grandezza rispetto a questa.");
   RigaReferto(h, "  3. GATED SHORT 770250 (M15): SHORT sulla rottura al ribasso");
   RigaReferto(h, "     dell'apertura.");
   RigaReferto(h, ">>> IL PUNTO: su una mattina di gap in giu' il GATED SHORT vende e questo");
   RigaReferto(h, "    motore comprerebbe. OPPOSTI, stesso simbolo, stesso minuto. La regola di");
   RigaReferto(h, "    rotta dice mai due EA sullo stesso segnale/simbolo/lato: va sciolto PRIMA");
   RigaReferto(h, "    di qualunque deploy. Non e' un dettaglio, e' architettura.");
   RigaReferto(h, "");
   RigaReferto(h, "=====================================================================");
   RigaReferto(h, StringFormat("  VERDETTO COMPLESSIVO DEL PASSO 0: %s", NomeEsito((int)s[47])));
   RigaReferto(h, "  (catena: uno SCARTO domina su tutto, un SOSPESO o un NON MISURATO");
   RigaReferto(h, "   dominano su un PASSA. Entrano P0-1, P0-2, P0-3 e P0-6.)");
   RigaReferto(h, "=====================================================================");
   RigaReferto(h, "COSA QUESTA CORSA NON DICE -- scritto prima, non dopo:");
   RigaReferto(h, " - NON dice se il motore guadagna: non ci sono operazioni, quindi non c'e'");
   RigaReferto(h, "   nessun profit factor, nessuna equity, nessun drawdown.");
   RigaReferto(h, " - NON e' un round di merito e NON promuove niente.");
   RigaReferto(h, " - NON tocca nessuna sedia viva, nessun preset, nessun magic.");
   RigaReferto(h, " - i rendimenti sono LORDI: nessun costo dedotto, nessuno stop, nessuno");
   RigaReferto(h, "   slittamento. Il costo sta in P0-3 come CONFRONTO, non come sottrazione.");
   RigaReferto(h, " - una frequenza alta NON e' un edge: e' una frequenza.");
   RigaReferto(h, " - broker singolo (BCM), un solo feed, una sola finestra.");
   RigaReferto(h, "");
   RigaReferto(h, StringFormat("tabella per macchina: %s", (gFileCsv == "" ? "NON SCRITTA (ottimizzazione o CSV spento)" : gFileCsv)));
   RigaReferto(h, "=====================================================================");

   if(h != INVALID_HANDLE) FileClose(h);
  }

//==================================================================
//  IL CALCOLO DI TUTTI I NUMERI -- un posto solo
//==================================================================
void CalcolaStats(double &s[])
  {
   ArrayResize(s, GC_NSTATS);
   ArrayInitialize(s, 0.0);

   long valide = 0, igiene = 0, dati = 0, eventiL = 0, eventiS = 0, lunedi = 0, nonEsatte = 0;
   double barrePrimaOra[];
   ArrayResize(barrePrimaOra, 0);
   int nb = 0;
   for(int i=0; i<gNG; i++)
     {
      if(gG[i].valida)
        {
         valide++;
         ArrayResize(barrePrimaOra, nb+1);
         barrePrimaOra[nb] = (double)gG[i].barrePrimaOra;
         nb++;
         if(gG[i].offsetApertura > 0) nonEsatte++;
         if(gG[i].eventoLong)
           {
            eventiL++;
            if(gG[i].giornoSettimana == 1) lunedi++;
           }
         if(gG[i].eventoShort) eventiS++;
        }
      else if(gG[i].motivo == GC_KO_POCHE_BARRE) igiene++;
      else dati++;
     }
   if(nb > 0) ArraySort(barrePrimaOra);

   //--- P0-2 e i rendimenti
   double retEv[], retTutti[], retNon[];
   int nEv    = Raccogli(GC_FILTRO_EVENTO_L,   GC_LATO_LONG, GC_CAMPO_RET_PCT, retEv);
   int nTutti = Raccogli(GC_FILTRO_TUTTE,      GC_LATO_LONG, GC_CAMPO_RET_PCT, retTutti);
   int nNon   = Raccogli(GC_FILTRO_NON_EVENTO, GC_LATO_LONG, GC_CAMPO_RET_PCT, retNon);
   double mediaEv    = Media_Calc(retEv, nEv);
   double mediaTutti = Media_Calc(retTutti, nTutti);
   double mediaNon   = Media_Calc(retNon, nNon);
   double winEv      = QuotaPositivi(retEv, nEv);
   double winTutti   = QuotaPositivi(retTutti, nTutti);
   double medianaEv  = 0.0;
   if(nEv > 0){ ArraySort(retEv); medianaEv = MedianaOrdinata_Calc(retEv, nEv); }
   double separazione = (MathAbs(mediaTutti) > 0.0) ? (mediaEv/mediaTutti) : 0.0;

   //--- P0-3: il take mediano in unita' di prezzo e lo spread di QUEL minuto
   double takePt[];
   int nTake = Raccogli(GC_FILTRO_EVENTO_L, GC_LATO_LONG, GC_CAMPO_RET_PT, takePt);
   double takeMediano = 0.0;
   if(nTake > 0){ ArraySort(takePt); takeMediano = MedianaOrdinata_Calc(takePt, nTake); }

   bool ovA=false, ovB=false, ovC=false, ovD=false;
   long medEvBin = PercentileIstogramma_Calc(gIstoEventoL, gNEventoL, 0.50, ovA);
   long p95EvBin = PercentileIstogramma_Calc(gIstoEventoL, gNEventoL, 0.95, ovB);
   long medTuBin = PercentileIstogramma_Calc(gIstoTutti,   gNTutti,   0.50, ovC);
   long p95TuBin = PercentileIstogramma_Calc(gIstoTutti,   gNTutti,   0.95, ovD);
   double spreadMedEv = (medEvBin >= 0) ? SpreadInUnita_Calc((double)medEvBin, gPPU) : 0.0;
   double spreadP95Ev = (p95EvBin >= 0) ? SpreadInUnita_Calc((double)p95EvBin, gPPU) : 0.0;
   double spreadMedTu = (medTuBin >= 0) ? SpreadInUnita_Calc((double)medTuBin, gPPU) : 0.0;
   double spreadP95Tu = (p95TuBin >= 0) ? SpreadInUnita_Calc((double)p95TuBin, gPPU) : 0.0;
   double rapporto    = RapportoTakeSpread_Calc(takeMediano, spreadMedEv);

   //--- P0-4: la geometria, lato LONG, sulle giornate-evento
   double maeP[], mfeP[], maeU[], mfeU[];
   int nMae = Raccogli(GC_FILTRO_EVENTO_L, GC_LATO_LONG, GC_CAMPO_MAE_PCT, maeP);
   int nMfe = Raccogli(GC_FILTRO_EVENTO_L, GC_LATO_LONG, GC_CAMPO_MFE_PCT, mfeP);
   int nMaeU= Raccogli(GC_FILTRO_EVENTO_L, GC_LATO_LONG, GC_CAMPO_MAE_PT,  maeU);
   int nMfeU= Raccogli(GC_FILTRO_EVENTO_L, GC_LATO_LONG, GC_CAMPO_MFE_PT,  mfeU);
   if(nMae > 0) ArraySort(maeP);
   if(nMfe > 0) ArraySort(mfeP);
   if(nMaeU> 0) ArraySort(maeU);
   if(nMfeU> 0) ArraySort(mfeU);

   //--- P0-5: il lato short
   double retSh[], maeSh[], mfeSh[];
   int nSh    = Raccogli(GC_FILTRO_EVENTO_S, GC_LATO_SHORT, GC_CAMPO_RET_PCT, retSh);
   int nMaeSh = Raccogli(GC_FILTRO_EVENTO_S, GC_LATO_SHORT, GC_CAMPO_MAE_PCT, maeSh);
   int nMfeSh = Raccogli(GC_FILTRO_EVENTO_S, GC_LATO_SHORT, GC_CAMPO_MFE_PCT, mfeSh);
   double mediaSh = Media_Calc(retSh, nSh);
   double winSh   = QuotaPositivi(retSh, nSh);
   double medianaSh = 0.0;
   if(nSh > 0){ ArraySort(retSh); medianaSh = MedianaOrdinata_Calc(retSh, nSh); }
   if(nMaeSh > 0) ArraySort(maeSh);
   if(nMfeSh > 0) ArraySort(mfeSh);
   //--- il controllo dello short e' il rendimento SHORT su TUTTE le
   //    giornate valide, cioe' meno il controllo long: si ricalcola
   //    esplicitamente invece di girare un segno a mano.
   double retTuSh[];
   int nTuSh = Raccogli(GC_FILTRO_TUTTE, GC_LATO_SHORT, GC_CAMPO_RET_PCT, retTuSh);
   double mediaTuSh = Media_Calc(retTuSh, nTuSh);
   double sepSh = (MathAbs(mediaTuSh) > 0.0) ? (mediaSh/mediaTuSh) : 0.0;

   //--- gli esiti, calcolati dal codice
   int e01 = EsitoP01_Calc(eventiL);
   int e02 = EsitoP02_Calc(mediaEv, mediaTutti);
   int e03 = EsitoP03_Calc(rapporto, spreadMedEv);
   int e06 = EsitoP06Lunedi_Calc(lunedi, eventiL);
   int e05f = EsitoP01_Calc(eventiS);
   int e05s = EsitoP02_Calc(mediaSh, mediaTuSh);
   //--- il lato spento non produce un verde: produce un NON MISURATO.
   if(InpLato == 2){ e01 = GC_NONMISURATO; e02 = GC_NONMISURATO; e03 = GC_NONMISURATO; e06 = GC_NONMISURATO; }
   if(InpLato == 1){ e05f = GC_NONMISURATO; e05s = GC_NONMISURATO; }

   int catena[]; ArrayResize(catena, 4);
   catena[0]=e01; catena[1]=e02; catena[2]=e03; catena[3]=e06;
   int verdetto = VerdettoComplessivo_Calc(catena, 4);

   s[0]  = (double)gGiornateConTick;
   s[1]  = (double)valide;
   s[2]  = (double)igiene;
   s[3]  = (double)dati;
   s[4]  = (double)eventiL;
   s[5]  = (double)e01;
   s[6]  = mediaEv;
   s[7]  = mediaTutti;
   s[8]  = mediaNon;
   s[9]  = separazione;
   s[10] = (double)e02;
   s[11] = (mediaTutti <= 0.0 ? 1.0 : 0.0);
   s[12] = medianaEv;
   s[13] = winEv;
   s[14] = winTutti;
   s[15] = takeMediano;
   s[16] = spreadMedEv;
   s[17] = spreadP95Ev;
   s[18] = spreadMedTu;
   s[19] = spreadP95Tu;
   s[20] = rapporto;
   s[21] = (double)e03;
   s[22] = (double)gNEventoL;
   s[23] = (double)gNTutti;
   s[24] = (double)gOverTutti;
   s[25] = PercentileOrdinato_Calc(maeP, nMae, 0.50);
   s[26] = PercentileOrdinato_Calc(maeP, nMae, 0.75);
   s[27] = PercentileOrdinato_Calc(maeP, nMae, 0.90);
   s[28] = PercentileOrdinato_Calc(mfeP, nMfe, 0.50);
   s[29] = PercentileOrdinato_Calc(mfeP, nMfe, 0.75);
   s[30] = PercentileOrdinato_Calc(mfeP, nMfe, 0.90);
   s[31] = PercentileOrdinato_Calc(maeU, nMaeU, 0.75);
   s[32] = PercentileOrdinato_Calc(mfeU, nMfeU, 0.50);
   s[33] = (double)eventiS;
   s[34] = mediaSh;
   s[35] = medianaSh;
   s[36] = winSh;
   s[37] = sepSh;
   s[38] = (double)e05f;
   s[39] = (double)e05s;
   s[40] = PercentileOrdinato_Calc(maeSh, nMaeSh, 0.75);
   s[41] = PercentileOrdinato_Calc(mfeSh, nMfeSh, 0.50);
   s[42] = (double)lunedi;
   s[43] = QuotaPct_Calc(lunedi, eventiL);
   s[44] = (double)e06;
   s[45] = (nb > 0) ? MedianaOrdinata_Calc(barrePrimaOra, nb) : 0.0;
   s[46] = (double)nonEsatte;
   s[47] = (double)verdetto;
   s[48] = InpSogliaGapPct;
   s[49] = InpSogliaGapShortPct;
   s[50] = (double)InpMinutiUscita;
   s[51] = (double)gMinCampana;
   s[52] = (double)gMinChiusura;
   s[53] = (InpGateSpento ? 1.0 : 0.0);
   s[54] = (double)InpLato;
   s[55] = (InpMisuraSpreadCampana ? 1.0 : 0.0);
   s[56] = gPPU;
   s[57] = (double)gDigits;
   s[58] = (double)gLettureM1Fallite;
   s[59] = (gTroncato ? 1.0 : 0.0);
   s[60] = (double)gAutotestFalliti;
   s[61] = (double)gAutotestBlocchi;
   s[62] = (double)gTickScartati;
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. Non richiede nessun include. //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                  //
//  In corsa singola e' inerte (i frame girano in ottimizzazione).   //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return(StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol));
  }

double OnTester()
  {
   //--- l'ULTIMA giornata resta a meta' se la corsa finisce prima
   //    della fine della sua prima ora: si chiude QUI, prima di
   //    contare qualunque cosa. OnTester arriva prima di OnDeinit.
   ChiudiGiornata();

   double s[];
   CalcolaStats(s);

   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvGiornate();
   if(!MQLInfoInteger(MQL_OPTIMIZATION))                 ScriviReferto(s);

   //--- MT5 vuole un criterio di ottimizzazione. Qui NON si sceglie
   //    niente e NESSUNA CELLA VIENE PROMOSSA (il contratto lo dice
   //    al par. 4): si dichiara il numero di giornate-evento, che e'
   //    cio' che la sonda conta. Leggerlo come "la cella migliore"
   //    vorrebbe dire "quella che ha contato di piu'", e contare di
   //    piu' non e' un merito: la soglia E' la manopola della
   //    frequenza, quindi il massimo di questo criterio e' sempre la
   //    soglia piu' larga.
   double criterion = s[4];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, s);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string nomi[]; int dec[];
   ColonneStats(nomi, dec);

   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     {
      PrintFormat("[GAPCASH] OptFrame: impossibile creare %s (errore %d)", fname, GetLastError());
      return;
     }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header)
        {
         string head = "Pass,Simbolo,Periodo";
         for(int i=0; i<ArraySize(nomi); i++) head += "," + nomi[i];
         for(uint k=0; k<pcount; k++)
           { string kv[]; if(StringSplit(params[k], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head);
         header = true;
        }
      string row = IntegerToString((int)pass) + "," + _Symbol + "," + NomePeriodo();
      int nd = ArraySize(data);
      for(int i=0; i<ArraySize(nomi); i++)
        {
         if(i < nd) row += "," + DoubleToString(data[i], dec[i]);
         else       row += ",";
        }
      for(uint k2=0; k2<pcount; k2++)
        { string kv2[]; if(StringSplit(params[k2], '=', kv2) == 2) row += "," + kv2[1]; }
      FileWrite(h, row);
      righe++;
     }
   FileClose(h);
   PrintFormat("[GAPCASH] OptFrame: scritte %d passate in MQL5\\Files\\%s (%d colonne di misura)", righe, fname, ArraySize(nomi));
  }
//================== fine OPTFRAME inlined ==========================//
