//+------------------------------------------------------------------+
//|                                      ABTG_SlippageLogger.mq5      |
//|                                                                   |
//|   IL LOGGER DELLO SLIPPAGE VERO -- EA DI SOLA LETTURA.            |
//|                                                                   |
//|   SCOPO: misurare la differenza fra il prezzo RICHIESTO e il      |
//|   prezzo ESEGUITO su ogni operazione del conto, leggendola dallo  |
//|   STORICO DEI DEAL, e tenendola divisa per simbolo, per magic e   |
//|   per MOTIVO dell'uscita (stop loss, take profit, chiusura        |
//|   dell'EA, chiusura a mano, stop out). La colonna che interessa   |
//|   davvero e' lo STOP: e' li' che una scivolata raddoppia una      |
//|   perdita, ed e' il numero che manca a tutti i round.             |
//|                                                                   |
//|   PERCHE' NASCE ADESSO, e perche' su un conto REALE:              |
//|   BCM ha confermato che il conto DEMO NON simula lo slippage: sul |
//|   demo la differenza fra richiesto ed eseguito e' zero PER        |
//|   COSTRUZIONE, quindi una raccolta fatta li' misurerebbe solo la  |
//|   propria illusione. L'unico posto dove il numero esiste e' un    |
//|   conto reale. Questo artefatto e' l'attrezzo T2 promosso il      |
//|   23/08 (report/SWEEP_MECCANISMI_2026-08-23.md, "Round Trip Cost  |
//|   Reconciler", Code Base 76117) e mai costruito: la sua misura e' |
//|   quella che ABTG_SpreadLogger dichiara esplicitamente di NON     |
//|   fare. I due attrezzi sono complementari: lo spread e' quanto    |
//|   costa il libro, lo slippage e' quanto costa l'esecuzione.       |
//|                                                                   |
//|   IL VINCOLO -- NON NEGOZIABILE, ed e' PIU' STRETTO di quello di  |
//|   ABTG_SpreadLogger, perche' qui sotto c'e' capitale VERO:        |
//|    1. MAI UN ORDINE, e non per promessa ma per COSTRUZIONE: in    |
//|       questo file non esistono le strutture con cui in MQL5 si    |
//|       manda un ordine. Non c'e' nessuna funzione di invio, non    |
//|       c'e' nessuna classe di trading, e non c'e' nemmeno          |
//|       OnTradeTransaction -- che pure sarebbe stato comodo -- per  |
//|       una ragione precisa: la sua firma PRETENDE le due strutture |
//|       della richiesta e del risultato di trading, e volevamo che  |
//|       in questo sorgente quelle strutture non comparissero        |
//|       affatto. Il prezzo pagato e' qualche secondo di ritardo     |
//|       nell'accorgersi di un deal nuovo, che per una misura        |
//|       storica non vale niente. La riga di lancio VERIFICA questa  |
//|       assenza sul sorgente, con un censimento per token sulle     |
//|       righe di codice.                                            |
//|    2. MAI UNA GlobalVariable, ne' letta ne' scritta: il Guardian  |
//|       e le sedie vive si parlano con quelle.                      |
//|    3. NON CANCELLA E NON SPOSTA NESSUN FILE. Nemmeno i propri.    |
//|       Le funzioni di cancellazione/spostamento/copia di file qui  |
//|       non ci sono, e la riga di lancio lo verifica.               |
//|    4. NON TOCCA IL MARKET WATCH. A differenza di                  |
//|       ABTG_SpreadLogger, che aggiungeva i simboli, qui i simboli  |
//|       arrivano dai deal: esistono gia' per definizione.           |
//|    5. NESSUN OGGETTO GRAFICO, nessuna notifica, nessun traffico   |
//|       verso l'esterno. Solo un Comment() e i propri file.         |
//|    6. SCRIVE SOLO I PROPRI TRE FILE in MQL5\Files, tutti col      |
//|       prefisso InpPrefissoFile SEGUITO DAL NUMERO DI CONTO. Il    |
//|       numero di conto nel nome non e' un vezzo: senza, una        |
//|       raccolta fatta sul demo e una fatta sul reale finirebbero   |
//|       nello STESSO registro, e siccome sul demo lo slippage e'    |
//|       zero per costruzione, la mediana del file misto sarebbe un  |
//|       numero che non descrive nessuno dei due conti.              |
//|    7. LE SUE RIGHE DI LOG COMINCIANO TUTTE CON "[SLIPLOG]" e il   |
//|       fallimento del proprio autotest si chiama                   |
//|       "*** ROSSO SLIPLOG ***" e NON "*** FAIL ***", che e' una    |
//|       riga VIETATA del collaudo enforcement Fase 1: un rosso di   |
//|       QUESTO artefatto non deve poter fermare il collaudo di un   |
//|       ALTRO (classe 107).                                         |
//|                                                                   |
//|   COME SI MISURA IL "RICHIESTO" -- TRE FONTI, tutte registrate:   |
//|    A) SNAPSHOT: ogni InpSnapshotSec l'EA fotografa SL e TP di     |
//|       ogni posizione aperta e li tiene in memoria per numero di   |
//|       posizione. Quando arriva il deal di chiusura, il livello    |
//|       che c'era e' li'. E' la fonte NOSTRA, e la sua debolezza    |
//|       e' dichiarata: puo' essere vecchia fino a InpSnapshotSec    |
//|       secondi, quindi se un trailing ha spostato lo stop un       |
//|       istante prima del riempimento, la foto e' quella di prima.  |
//|       L'eta' della foto finisce in una colonna del registro.      |
//|    B) ORDINE: il prezzo di apertura dell'ordine che ha generato   |
//|       il deal. Per un ordine di mercato e' il prezzo CHIESTO; per |
//|       un ordine nato dallo scatto di uno stop, sui server che si  |
//|       comportano bene, e' il LIVELLO dello stop.                  |
//|    C) COMMENTO: il commento che il server scrive sul deal di      |
//|       chiusura, nella forma "sl 24178.20" oppure "tp 24305.10".   |
//|       E' la fonte piu' esplicita, perche' dice insieme il MOTIVO  |
//|       e il LIVELLO, e la scrive il server, non noi.               |
//|                                                                   |
//|   La priorita' usata per la colonna che fa fede e' C, poi B, poi  |
//|   A, ed e' DICHIARATA: il referto stampa quante righe vengono da  |
//|   ogni fonte e quanto le fonti sono d'accordo fra loro. In        |
//|   particolare c'e' un controllo che vale da solo il referto: se   |
//|   la fonte B coincide con il prezzo ESEGUITO su tutte le righe,   |
//|   vuol dire che questo server NON riporta il livello richiesto    |
//|   nell'ordine, e una misura basata su B direbbe "slippage zero"   |
//|   su qualunque conto. Il referto lo scrive a lettere chiare       |
//|   invece di regalare uno zero (classe 106: l'artefatto che si     |
//|   svuota letto come registro).                                    |
//|                                                                   |
//|   SEGNO DELLO SCARTO -- una convenzione sola, in un posto solo:   |
//|   positivo = AVVERSO, cioe' abbiamo pagato peggio di quanto       |
//|   chiesto. Se il deal e' un acquisto, avverso = eseguito meno     |
//|   richiesto (comprare piu' caro e' peggio); se e' una vendita,    |
//|   avverso = richiesto meno eseguito (vendere piu' basso e'        |
//|   peggio). Vale identica per gli ingressi e per le uscite.        |
//|   Uno scarto NEGATIVO non e' un errore: e' un riempimento         |
//|   MIGLIORE del richiesto, e capita.                               |
//|                                                                   |
//|   IL TRABOCCHETTO DELLO STORICO (e la ragione dei tre passaggi):  |
//|   in MQL5 la selezione di un ORDINE storico per ticket SVUOTA la  |
//|   lista che HistorySelect aveva riempito e ci mette dentro quel   |
//|   solo ordine. Chiedere il prezzo dell'ordine mentre si sta       |
//|   scorrendo la lista dei deal fa quindi sparire i deal sotto i    |
//|   piedi al ciclo. Qui la scansione e' in TRE passaggi separati:   |
//|   prima si leggono TUTTI i deal nuovi, poi si chiedono gli        |
//|   ordini, poi si conclude. Non e' pignoleria: e' esattamente il   |
//|   genere di difetto che produce numeri plausibili e sbagliati.    |
//|                                                                   |
//|   COSA MISURA, DETTO CON PRECISIONE (e cosa NON misura):          |
//|    - misura lo scarto sulle operazioni REALMENTE ACCADUTE su      |
//|      QUESTO conto: e' quindi pesato sui NOSTRI ingressi e sulle   |
//|      NOSTRE uscite, non su istanti a caso. E' l'opposto di come   |
//|      campiona ABTG_SpreadLogger, ed e' la sua utilita'.           |
//|    - NON misura lo spread (quello e' l'altro attrezzo).           |
//|    - il costo in valuta e' calcolato col valore del tick di       |
//|      ADESSO, non con quello del momento del deal: su un simbolo   |
//|      la cui valuta non e' quella del conto e' un'approssimazione, |
//|      e va detto. Le colonne in PUNTI sono il dato; la colonna in  |
//|      valuta e' un comodo.                                         |
//|    - commissione, swap e profitto del deal sono copiati dallo     |
//|      storico cosi' come sono: servono a chiudere il conto del     |
//|      costo totale di andata e ritorno, non sono una nostra stima. |
//|    - broker singolo (BCM), un conto solo, un terminale solo.      |
//|    - su un conto DEMO questa misura vale ZERO: BCM ha confermato  |
//|      che li' lo slippage non e' simulato. L'EA parte lo stesso    |
//|      (serve per collaudare la macchina), ma lo scrive in testa al |
//|      referto e in ogni riga del registro.                         |
//|                                                                   |
//|   ORE: tutte in ORA SERVER (TimeCurrent / DEAL_TIME). Le schede   |
//|   Esperti e Giornale di MT5 sono in ora LOCALE del PC, che sul    |
//|   VPS e' un'ora AVANTI: non si confrontano, ed e' regola di casa  |
//|   ripeterlo ogni volta.                                           |
//+------------------------------------------------------------------+
#property version   "1.00"
#property strict
#property description "ABTG_SlippageLogger -- logger di SOLA LETTURA dello slippage vero (prezzo richiesto contro prezzo eseguito) letto dallo storico dei deal. Non apre, non modifica e non chiude nessuna posizione."

//--- marcatore di versione: lo cerca la riga di lancio prima di installare,
//    e lo si legge nella scheda Esperti per sapere quale build sta girando.
#define ABTG_SLIPLOG_MARCATORE "ABTG_SlippageLogger v1.00 - logger di SOLA LETTURA, slippage vero dai deal"

//--- numeri dell'autotest, dichiarati come #define perche' la riga di
//    lancio li legge dal SORGENTE e li confronta con quelli che si
//    aspetta: se il file al pin non e' quello che credo, non si installa.
#define ABTG_SLIPLOG_AUTOTEST_BLOCCHI_ATTESI 9
#define ABTG_SLIPLOG_AUTOTEST_CASI_ATTESI    101

//--- geometria e tetti, tutti DICHIARATI (un tetto silenzioso e' un dato
//    perso in silenzio: qui ogni tetto ha il suo contatore nel referto).
#define NCOL      30       // colonne del registro: la riga si conta, non si spera
#define MAXVISTI  200000   // deal gia' registrati che teniamo per non ripeterli
#define MAXCAMP   50000    // campioni tenuti in memoria per le statistiche
#define MAXPOS    512      // posizioni di cui teniamo la foto di SL/TP

//--- codici del MOTIVO. Sono gli stessi numeri di ENUM_DEAL_REASON di
//    MT5, e l'autotest lo VERIFICA contro la piattaforma invece di
//    fidarsi: se una build futura li cambiasse, il rosso si vede subito.
#define MOT_IGNOTO   -1
#define MOT_CLIENT    0
#define MOT_MOBILE    1
#define MOT_WEB       2
#define MOT_EXPERT    3
#define MOT_SL        4
#define MOT_TP        5
#define MOT_SO        6
#define MOT_ROLLOVER  7
#define MOT_VMARGIN   8
#define MOT_SPLIT     9

//--- codici dell'ENTRATA (stessi numeri di ENUM_DEAL_ENTRY)
#define ENT_IGNOTA   -1
#define ENT_IN        0
#define ENT_OUT       1
#define ENT_INOUT     2
#define ENT_OUTBY     3

//--- fonte del prezzo richiesto
#define FONTE_NESSUNA  0
#define FONTE_COMMENTO 1
#define FONTE_ORDINE   2
#define FONTE_SNAPSHOT 3

//==================== INPUT ================================================
input long   InpLoginAtteso     = 0;      // login del conto su cui DEVE girare (0 = qualunque, ma allora e' il file a dirlo)
input bool   InpSoloContoReale  = false;  // true = non parte se il conto non e' REALE (sul demo lo slippage e' zero per costruzione)
input int    InpScanSec         = 10;     // ogni quanti secondi si guarda lo storico dei deal
input int    InpFinestraScanSec = 7200;   // quanto indietro guarda ogni scansione periodica (secondi)
input int    InpGiorniStorico   = 30;     // all'avvio: quanti giorni di storico si recuperano
input int    InpSnapshotSec     = 1;      // ogni quanti secondi si fotografano SL/TP delle posizioni aperte
input bool   InpLoggaIngressi   = true;   // registra anche i deal di INGRESSO (slippage d'entrata)
input int    InpSalvaSec        = 300;    // ogni quanti secondi si riscrivono referto e sintesi
input string InpPrefissoFile    = "ABTG_SlippageLogger"; // prefisso dei file in MQL5\Files (deve cominciare per ABTG_Slippage)
input bool   InpMostraComment   = true;   // scrive lo stato nel Comment del grafico
input bool   InpLogOgniDeal     = true;   // una riga in Esperti per ogni deal nuovo registrato
input bool   InpAutoTest        = true;   // autotest a tavolino in OnInit

//==================== IL CAMPIONE (una riga del registro) ==================
struct Campione
  {
   long     deal;         // ticket del deal
   long     ordine;       // ticket dell'ordine che l'ha generato
   long     posizione;    // identificatore della posizione
   datetime t;            // ora SERVER del deal
   long     msc;          // ora del deal in millisecondi
   long     login;        // conto su cui e' avvenuto
   int      modo;         // ENUM_ACCOUNT_TRADE_MODE: 0 demo, 1 concorso, 2 reale
   string   sym;
   long     magic;
   int      entrata;      // ENT_*
   int      tipoDeal;     // 0 = acquisto, 1 = vendita
   int      motivo;       // MOT_* gia' risolto
   double   volume;
   double   eseguito;     // prezzo del deal
   double   richiesto;    // prezzo richiesto scelto per priorita'
   int      fonte;        // FONTE_*
   double   pc;           // richiesto dal COMMENTO
   double   po;           // richiesto dall'ORDINE
   double   ps;           // richiesto dallo SNAPSHOT
   bool     hc;
   bool     ho;
   bool     hs;
   double   etaSnap;      // eta' della foto al momento del deal, in secondi (-1 = nessuna)
   double   punti;        // scarto AVVERSO in punti MT5
   bool     okPunti;      // false = non calcolabile
   double   valuta;       // scarto avverso in valuta del conto
   bool     okValuta;
   double   commissione;
   double   swap;
   double   profitto;
   int      digits;
   double   point;
   string   commento;
  };

//==================== STATO ================================================
Campione g_c[];            // campioni in memoria (per le statistiche)
int      g_nCamp      = 0;
long     g_campPersi  = 0; // campioni non tenuti in memoria per il tetto

long     g_visti[];        // ticket dei deal gia' registrati, ORDINATO
int      g_nVisti     = 0;
long     g_vistiPersi = 0;

//--- foto delle posizioni aperte
long     g_pPos[];         // identificatore della posizione
string   g_pSym[];
long     g_pMagic[];
int      g_pTipo[];
double   g_pVol[];
double   g_pOpen[];
double   g_pSL[];
double   g_pTP[];
datetime g_pQuando[];
long     g_pAgg[];
int      g_nPos       = 0;
long     g_posPersi   = 0;

datetime g_avvioIstanza = 0;
datetime g_ultimoScan   = 0;
datetime g_ultimoSnap   = 0;
datetime g_ultimoSalv   = 0;
long     g_salvataggi   = 0;
long     g_dealLetti    = 0;   // deal esaminati (comprese le ripetizioni)
long     g_dealNuovi    = 0;   // deal registrati per la prima volta
long     g_nonTrading   = 0;   // movimenti di conto (saldo, credito): saltati
long     g_scansioni    = 0;
long     g_erroriStorico= 0;
long     g_erroriScrittura = 0;
string   g_letturaLedger= "NON LETTO";
bool     g_pronto       = false;
int      g_autoFalliti  = 0;
long     g_contoMio     = 0;
int      g_modoMio      = -1;
string   g_serverMio    = "";
string   g_avvisoConto  = "";

//+------------------------------------------------------------------+
//| PUNTI MT5 PER UNITA' PRATICA -- la conversione, in un posto solo. |
//| Stessa regola di ABTG_SpreadLogger, apposta: due attrezzi che     |
//| convertono diversamente producono due numeri che non si possono   |
//| confrontare, ed e' proprio il confronto che ci serve.             |
//|   5 o 3 decimali (forex) -> 10 punti = 1 pip                      |
//|   2 decimali (indici BCM) -> 100 punti = 1 punto indice           |
//|   1 decimale             -> 10 punti = 1 unita' di prezzo         |
//|   0 decimali             -> 1 punto  = 1 unita' di prezzo         |
//+------------------------------------------------------------------+
double PuntiPerUnita(const int digits)
  {
   if(digits >= 3) return 10.0;
   if(digits == 2) return 100.0;
   if(digits == 1) return 10.0;
   return 1.0;
  }
string NomeUnita(const int digits)
  {
   if(digits >= 3) return "pip";
   return "punti indice";
  }

//+------------------------------------------------------------------+
//| SCARTO AVVERSO in PREZZO. La convenzione di segno di tutto        |
//| l'artefatto sta qui dentro e da nessun'altra parte:               |
//|   positivo = abbiamo pagato PEGGIO del richiesto.                 |
//| comprato = true quando il deal e' un acquisto.                    |
//+------------------------------------------------------------------+
double ScartoAvverso(const double richiesto, const double eseguito, const bool comprato)
  {
   if(comprato) return eseguito - richiesto;
   return richiesto - eseguito;
  }

//+------------------------------------------------------------------+
//| Da differenza di prezzo a PUNTI MT5. Ritorna false se il point    |
//| non e' utilizzabile: meglio "non calcolabile" che uno zero comodo.|
//+------------------------------------------------------------------+
bool PuntiDaPrezzo(const double diffPrezzo, const double point, double &punti)
  {
   punti = 0.0;
   if(point <= 0.0) return false;
   punti = diffPrezzo / point;
   return true;
  }

//+------------------------------------------------------------------+
//| E' un numero di prezzo? (solo cifre e al massimo un punto)        |
//+------------------------------------------------------------------+
bool EPrezzo(const string s)
  {
   int n = StringLen(s);
   if(n <= 0) return false;
   int cifre = 0;
   int punti = 0;
   for(int i=0; i<n; i++)
     {
      ushort ch = StringGetCharacter(s, i);
      if(ch >= '0' && ch <= '9') { cifre++; continue; }
      if(ch == '.') { punti++; continue; }
      return false;
     }
   return (cifre > 0 && punti <= 1);
  }

//+------------------------------------------------------------------+
//| PARSER DEL COMMENTO DEL DEAL.                                     |
//| Il server BCM scrive sui deal di chiusura commenti della forma    |
//| "sl 24178.20" oppure "tp 24305.10" (misurato nei report del       |
//| tester, R109 par.3). Alcuni server li mettono fra parentesi       |
//| quadre o con i due punti: si normalizza e si spezza.              |
//| Ritorna true e riempie tipo (MOT_SL / MOT_TP) e prezzo.           |
//| Un "sl" senza un numero SUBITO DOPO non conta: un commento di un  |
//| EA che contenesse la parola non deve poter fabbricare un livello. |
//+------------------------------------------------------------------+
bool LeggiPrezzoDaCommento(const string commento, int &tipo, double &prezzo)
  {
   tipo   = MOT_IGNOTO;
   prezzo = 0.0;
   if(StringLen(commento) <= 0) return false;
   string s = commento;
   StringReplace(s, "[", " ");
   StringReplace(s, "]", " ");
   StringReplace(s, ":", " ");
   StringReplace(s, ",", " ");
   StringToLower(s);
   string p[];
   int n = StringSplit(s, ' ', p);
   for(int i=0; i<n; i++)
     {
      int t = MOT_IGNOTO;
      if(p[i] == "sl") t = MOT_SL;
      if(p[i] == "tp") t = MOT_TP;
      if(t == MOT_IGNOTO) continue;
      for(int j=i+1; j<n; j++)
        {
         if(StringLen(p[j]) == 0) continue;
         if(!EPrezzo(p[j])) break;
         double v = StringToDouble(p[j]);
         if(v > 0.0) { tipo = t; prezzo = v; return true; }
         break;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
//| RISOLUZIONE DEL MOTIVO -- e la regola e' dichiarata:              |
//| il COMMENTO del server, quando dice "sl"/"tp", VINCE sul campo    |
//| numerico del motivo. Ragione: quel campo vale 0 ("dal cliente")   |
//| anche quando il server non lo compila, e uno zero muto non si     |
//| distingue da una chiusura a mano. Un commento "sl 24178.20"       |
//| invece e' il server che dichiara cosa e' successo.                |
//+------------------------------------------------------------------+
int RisolviMotivo(const int daCampo, const int daCommento)
  {
   if(daCommento == MOT_SL || daCommento == MOT_TP) return daCommento;
   if(daCampo >= 0) return daCampo;
   return MOT_IGNOTO;
  }

//+------------------------------------------------------------------+
//| Nomi e codici -- vanno in coppia, e l'autotest verifica che       |
//| l'andata e il ritorno coincidano: un registro che si scrive e non |
//| si rilegge e' un registro perso.                                  |
//+------------------------------------------------------------------+
string NomeMotivo(const int m)
  {
   if(m == MOT_CLIENT)   return "CLIENTE";
   if(m == MOT_MOBILE)   return "MOBILE";
   if(m == MOT_WEB)      return "WEB";
   if(m == MOT_EXPERT)   return "EA";
   if(m == MOT_SL)       return "SL";
   if(m == MOT_TP)       return "TP";
   if(m == MOT_SO)       return "STOPOUT";
   if(m == MOT_ROLLOVER) return "ROLLOVER";
   if(m == MOT_VMARGIN)  return "VMARGIN";
   if(m == MOT_SPLIT)    return "SPLIT";
   return "IGNOTO";
  }
int CodiceMotivo(const string s)
  {
   if(s == "CLIENTE")  return MOT_CLIENT;
   if(s == "MOBILE")   return MOT_MOBILE;
   if(s == "WEB")      return MOT_WEB;
   if(s == "EA")       return MOT_EXPERT;
   if(s == "SL")       return MOT_SL;
   if(s == "TP")       return MOT_TP;
   if(s == "STOPOUT")  return MOT_SO;
   if(s == "ROLLOVER") return MOT_ROLLOVER;
   if(s == "VMARGIN")  return MOT_VMARGIN;
   if(s == "SPLIT")    return MOT_SPLIT;
   return MOT_IGNOTO;
  }
string NomeEntrata(const int e)
  {
   if(e == ENT_IN)    return "IN";
   if(e == ENT_OUT)   return "OUT";
   if(e == ENT_INOUT) return "INOUT";
   if(e == ENT_OUTBY) return "OUTBY";
   return "IGNOTA";
  }
int CodiceEntrata(const string s)
  {
   if(s == "IN")    return ENT_IN;
   if(s == "OUT")   return ENT_OUT;
   if(s == "INOUT") return ENT_INOUT;
   if(s == "OUTBY") return ENT_OUTBY;
   return ENT_IGNOTA;
  }
string NomeTipoDeal(const int t)
  {
   if(t == 0) return "ACQUISTO";
   if(t == 1) return "VENDITA";
   return "ALTRO";
  }
int CodiceTipoDeal(const string s)
  {
   if(s == "ACQUISTO") return 0;
   if(s == "VENDITA")  return 1;
   return -1;
  }
string NomeFonte(const int f)
  {
   if(f == FONTE_COMMENTO) return "COMMENTO";
   if(f == FONTE_ORDINE)   return "ORDINE";
   if(f == FONTE_SNAPSHOT) return "SNAPSHOT";
   return "NESSUNA";
  }
int CodiceFonte(const string s)
  {
   if(s == "COMMENTO") return FONTE_COMMENTO;
   if(s == "ORDINE")   return FONTE_ORDINE;
   if(s == "SNAPSHOT") return FONTE_SNAPSHOT;
   return FONTE_NESSUNA;
  }
string NomeTipoConto(const int m)
  {
   if(m == 0) return "DEMO";
   if(m == 1) return "CONCORSO";
   if(m == 2) return "REALE";
   return "IGNOTO";
  }
int CodiceTipoConto(const string s)
  {
   if(s == "DEMO")     return 0;
   if(s == "CONCORSO") return 1;
   if(s == "REALE")    return 2;
   return -1;
  }

//+------------------------------------------------------------------+
//| SANIFICA un campo di testo prima di metterlo nel registro: il     |
//| separatore e i fine riga dentro un campo spezzerebbero la riga e  |
//| il file diventerebbe illeggibile a meta' raccolta.                |
//+------------------------------------------------------------------+
string Sanifica(const string s)
  {
   string x = s;
   StringReplace(x, ";", " ");
   StringReplace(x, "\r", " ");
   StringReplace(x, "\n", " ");
   StringTrimLeft(x);
   StringTrimRight(x);
   if(StringLen(x) == 0) return "-";
   return x;
  }

//+------------------------------------------------------------------+
//| Numero facoltativo: "n/d" quando non c'e'. Uno zero al posto di   |
//| un dato mancante e' una bugia che poi entra nelle medie.          |
//+------------------------------------------------------------------+
string NumOpz(const double v, const bool ok, const int dec)
  {
   if(!ok) return "n/d";
   return DoubleToString(v, dec);
  }
bool LeggiNumOpz(const string s, double &v)
  {
   v = 0.0;
   if(s == "n/d" || StringLen(s) == 0) return false;
   v = StringToDouble(s);
   return true;
  }

//+------------------------------------------------------------------+
//| RICERCA BINARIA su un array ORDINATO di ticket.                   |
//| Ritorna l'indice se c'e', altrimenti -(punto di inserimento + 1). |
//+------------------------------------------------------------------+
int CercaOrdinato(long &arr[], const int n, const long v)
  {
   int lo = 0;
   int hi = n - 1;
   while(lo <= hi)
     {
      int mid = (lo + hi) / 2;
      if(arr[mid] == v) return mid;
      if(arr[mid] < v)  lo = mid + 1;
      else              hi = mid - 1;
     }
   return -(lo + 1);
  }

//+------------------------------------------------------------------+
//| INSERISCE mantenendo l'ordine. Tre esiti, e sono TRE apposta:     |
//|    1 = inserito adesso (deal mai visto)                           |
//|    0 = c'era gia' (e' cosi' che NON si registra due volte lo      |
//|        stesso deal, nemmeno dopo un riavvio del terminale)        |
//|   -1 = TETTO RAGGIUNTO, non inserito                              |
//| Il -1 esiste perche' un tetto dichiarato e non fatto rispettare   |
//| e' peggio di nessun tetto: l'array crescerebbe in silenzio e la   |
//| costante in testa al file racconterebbe una bugia. E deve essere  |
//| DISTINTO dallo 0: "non l'ho inserito perche' non ci sta" e "non   |
//| l'ho inserito perche' c'era" portano a due comportamenti opposti. |
//+------------------------------------------------------------------+
int InserisciOrdinato(long &arr[], int &n, const long v, const int tetto)
  {
   int pos = CercaOrdinato(arr, n, v);
   if(pos >= 0) return 0;
   if(n >= tetto) return -1;
   int ins = -(pos + 1);
   if(ArraySize(arr) < n + 1) ArrayResize(arr, n + 1024);
   for(int i=n; i>ins; i--) arr[i] = arr[i-1];
   arr[ins] = v;
   n++;
   return 1;
  }

//+------------------------------------------------------------------+
//| PERCENTILE su un array GIA' ORDINATO, metodo del rango piu'       |
//| vicino: nessuna interpolazione, il valore uscito e' un valore     |
//| davvero osservato.                                                |
//+------------------------------------------------------------------+
double Percentile(double &v[], const int n, const double frac)
  {
   if(n <= 0) return 0.0;
   int idx = (int)MathCeil(frac * (double)n) - 1;
   if(idx < 0)    idx = 0;
   if(idx > n-1)  idx = n-1;
   return v[idx];
  }

//+------------------------------------------------------------------+
//| Il prefisso dei file: deve cominciare per ABTG_Slippage.          |
//| Non e' pignoleria -- e' l'unica cosa che impedisce, sbagliando a  |
//| digitare un input, di riscrivere il file di un ALTRO artefatto in |
//| MQL5\Files. Questo EA non cancella niente, ma un FILE_WRITE su un |
//| nome altrui lo troncherebbe lo stesso.                            |
//+------------------------------------------------------------------+
bool PrefissoValido(const string p)
  {
   if(StringLen(p) < 13) return false;
   if(StringSubstr(p, 0, 13) != "ABTG_Slippage") return false;
   if(StringFind(p, "\\") >= 0) return false;
   if(StringFind(p, "/") >= 0)  return false;
   if(StringFind(p, "..") >= 0) return false;
   return true;
  }

//+------------------------------------------------------------------+
//| Formattazione                                                     |
//+------------------------------------------------------------------+
string Pad(string s, const int larg)
  {
   while(StringLen(s) < larg) s = " " + s;
   return s;
  }
string PadDx(string s, const int larg)
  {
   while(StringLen(s) < larg) s = s + " ";
   return s;
  }

//==========================================================================
//  IL REGISTRO: intestazione, riga, rilettura
//  Una riga sola, una forma sola: la scrive la produzione e la rilegge
//  la produzione, e l'autotest fa il giro completo scrivi->leggi.
//==========================================================================
string Intestazione()
  {
   return "deal;ordine;posizione;ora_server;ora_msc;login;tipo_conto;simbolo;magic;entrata;tipo_deal;motivo;" +
          "volume;prezzo_eseguito;prezzo_richiesto;fonte_richiesto;rich_commento;rich_ordine;rich_snapshot;" +
          "eta_snapshot_sec;slip_punti;slip_unita;unita;slip_valuta;commissione;swap;profitto;digits;point;commento";
  }

string RigaCsv(const Campione &c)
  {
   double ppu = PuntiPerUnita(c.digits);
   string s = "";
   s += IntegerToString(c.deal) + ";";
   s += IntegerToString(c.ordine) + ";";
   s += IntegerToString(c.posizione) + ";";
   s += TimeToString(c.t, TIME_DATE|TIME_SECONDS) + ";";
   s += IntegerToString(c.msc) + ";";
   s += IntegerToString(c.login) + ";";
   s += NomeTipoConto(c.modo) + ";";
   s += Sanifica(c.sym) + ";";
   s += IntegerToString(c.magic) + ";";
   s += NomeEntrata(c.entrata) + ";";
   s += NomeTipoDeal(c.tipoDeal) + ";";
   s += NomeMotivo(c.motivo) + ";";
   s += DoubleToString(c.volume, 2) + ";";
   s += DoubleToString(c.eseguito, 8) + ";";
   s += NumOpz(c.richiesto, (c.fonte != FONTE_NESSUNA), 8) + ";";
   s += NomeFonte(c.fonte) + ";";
   s += NumOpz(c.pc, c.hc, 8) + ";";
   s += NumOpz(c.po, c.ho, 8) + ";";
   s += NumOpz(c.ps, c.hs, 8) + ";";
   s += NumOpz(c.etaSnap, (c.etaSnap >= 0.0), 1) + ";";
   s += NumOpz(c.punti, c.okPunti, 2) + ";";
   s += NumOpz(c.punti/ppu, c.okPunti, 4) + ";";
   s += NomeUnita(c.digits) + ";";
   s += NumOpz(c.valuta, c.okValuta, 2) + ";";
   s += DoubleToString(c.commissione, 2) + ";";
   s += DoubleToString(c.swap, 2) + ";";
   s += DoubleToString(c.profitto, 2) + ";";
   s += IntegerToString(c.digits) + ";";
   s += DoubleToString(c.point, 8) + ";";
   s += Sanifica(c.commento);
   return s;
  }

bool LeggiRigaCsv(const string riga, Campione &c)
  {
   string p[];
   int n = StringSplit(riga, ';', p);
   if(n != NCOL) return false;
   if(p[0] == "deal") return false;   // e' l'intestazione
   c.deal      = (long)StringToInteger(p[0]);
   if(c.deal <= 0) return false;
   c.ordine    = (long)StringToInteger(p[1]);
   c.posizione = (long)StringToInteger(p[2]);
   c.t         = StringToTime(p[3]);
   c.msc       = (long)StringToInteger(p[4]);
   c.login     = (long)StringToInteger(p[5]);
   c.modo      = CodiceTipoConto(p[6]);
   c.sym       = p[7];
   c.magic     = (long)StringToInteger(p[8]);
   c.entrata   = CodiceEntrata(p[9]);
   c.tipoDeal  = CodiceTipoDeal(p[10]);
   c.motivo    = CodiceMotivo(p[11]);
   c.volume    = StringToDouble(p[12]);
   c.eseguito  = StringToDouble(p[13]);
   double v = 0.0;
   LeggiNumOpz(p[14], v); c.richiesto = v;
   c.fonte     = CodiceFonte(p[15]);
   c.hc        = LeggiNumOpz(p[16], v); c.pc = v;
   c.ho        = LeggiNumOpz(p[17], v); c.po = v;
   c.hs        = LeggiNumOpz(p[18], v); c.ps = v;
   c.etaSnap   = (LeggiNumOpz(p[19], v) ? v : -1.0);
   c.okPunti   = LeggiNumOpz(p[20], v); c.punti = v;
   c.okValuta  = LeggiNumOpz(p[23], v); c.valuta = v;
   c.commissione = StringToDouble(p[24]);
   c.swap        = StringToDouble(p[25]);
   c.profitto    = StringToDouble(p[26]);
   c.digits      = (int)StringToInteger(p[27]);
   c.point       = StringToDouble(p[28]);
   c.commento    = p[29];
   return true;
  }

//==========================================================================
//  AUTOTEST A TAVOLINO
//  Gira in OnInit, non tocca niente di vivo, non guarda lo storico e non
//  scrive nessun file: prepara dati finti, chiama le funzioni VERE (quelle
//  che usa la produzione, non delle copie -- classe 109) e confronta col
//  risultato atteso. Il fallimento si chiama "*** ROSSO SLIPLOG ***".
//==========================================================================
int g_casiFatti = 0;
int g_casiRossi = 0;

void Caso(const string nome, const bool ok)
  {
   g_casiFatti++;
   if(!ok)
     {
      g_casiRossi++;
      Print("[SLIPLOG] *** ROSSO SLIPLOG *** caso fallito: ", nome);
     }
  }

bool Vicini(const double a, const double b, const double tol)
  {
   return (MathAbs(a-b) <= tol);
  }

bool AutoTest()
  {
   g_casiFatti = 0;
   g_casiRossi = 0;
   int blocchi = 0;

   //--- BLOCCO 1: conversione punti -> unita' pratica ------------------
   blocchi++;
   Caso("ppu 5 decimali = 10 (pip)",         PuntiPerUnita(5) == 10.0);
   Caso("ppu 3 decimali = 10 (pip JPY)",     PuntiPerUnita(3) == 10.0);
   Caso("ppu 2 decimali = 100 (indici)",     PuntiPerUnita(2) == 100.0);
   Caso("ppu 1 decimale = 10",               PuntiPerUnita(1) == 10.0);
   Caso("ppu 0 decimali = 1",                PuntiPerUnita(0) == 1.0);
   Caso("nome unita' forex = pip",           NomeUnita(5) == "pip");
   Caso("nome unita' indici = punti indice", NomeUnita(2) == "punti indice");

   //--- BLOCCO 2: il SEGNO dello scarto avverso ------------------------
   //  E' la convenzione su cui poggia tutto il referto: se sbaglia il
   //  segno, il logger dice che il broker ci REGALA i riempimenti.
   blocchi++;
     {
      //  vendita a 21660.10 chiesta, riempita a 21681.60: e' il caso VERO
      //  di R109 (NASUSD short, stop saltato di 21,5 punti indice).
      //  Chiudere uno short e' un ACQUISTO: comprare piu' caro e' peggio.
      Caso("acquisto riempito piu' caro = AVVERSO positivo",
           Vicini(ScartoAvverso(21660.10, 21681.60, true), 21.50, 0.0001));
      Caso("acquisto riempito piu' basso = FAVOREVOLE negativo",
           Vicini(ScartoAvverso(21660.10, 21655.10, true), -5.00, 0.0001));
      Caso("vendita riempita piu' bassa = AVVERSO positivo",
           Vicini(ScartoAvverso(19858.60, 19850.00, false), 8.60, 0.0001));
      Caso("vendita riempita piu' alta = FAVOREVOLE negativo",
           Vicini(ScartoAvverso(19858.60, 19860.00, false), -1.40, 0.0001));
      Caso("riempimento esatto = 0 (acquisto)",  Vicini(ScartoAvverso(1.10000, 1.10000, true), 0.0, 1e-12));
      Caso("riempimento esatto = 0 (vendita)",   Vicini(ScartoAvverso(1.10000, 1.10000, false), 0.0, 1e-12));
      double pt = 0.0;
      Caso("21.50 di prezzo con point 0.01 = 2150 punti", PuntiDaPrezzo(21.50, 0.01, pt) && Vicini(pt, 2150.0, 0.001));
      Caso("0.00017 con point 0.00001 = 17 punti",        PuntiDaPrezzo(0.00017, 0.00001, pt) && Vicini(pt, 17.0, 0.001));
      Caso("punti NEGATIVI restano negativi",             PuntiDaPrezzo(-0.00017, 0.00001, pt) && Vicini(pt, -17.0, 0.001));
      Caso("point 0 = non calcolabile, non zero",         PuntiDaPrezzo(0.0001, 0.0, pt) == false);
     }

   //--- BLOCCO 3: il parser del commento del server --------------------
   blocchi++;
     {
      int t = MOT_IGNOTO;
      double v = 0.0;
      Caso("commento 'sl 24178.20' letto",       LeggiPrezzoDaCommento("sl 24178.20", t, v) && t == MOT_SL && Vicini(v, 24178.20, 1e-6));
      Caso("commento 'tp 24305.10' letto",       LeggiPrezzoDaCommento("tp 24305.10", t, v) && t == MOT_TP && Vicini(v, 24305.10, 1e-6));
      Caso("commento '[sl 1.23456]' letto",      LeggiPrezzoDaCommento("[sl 1.23456]", t, v) && t == MOT_SL && Vicini(v, 1.23456, 1e-9));
      Caso("commento 'SL: 2100.5' maiuscolo",    LeggiPrezzoDaCommento("SL: 2100.5", t, v) && t == MOT_SL && Vicini(v, 2100.5, 1e-6));
      Caso("commento di un EA senza livelli",    LeggiPrezzoDaCommento("R109 ATREXH D30EUR L L", t, v) == false);
      Caso("commento vuoto",                     LeggiPrezzoDaCommento("", t, v) == false);
      Caso("'sl' senza numero non fabbrica un livello", LeggiPrezzoDaCommento("chiusura sl manuale", t, v) == false);
      Caso("'so' (stop out) non e' ne' sl ne' tp",      LeggiPrezzoDaCommento("so: 12.34", t, v) == false);
      Caso("prezzo a zero rifiutato",            LeggiPrezzoDaCommento("sl 0", t, v) == false);
      Caso("'sl' dentro una parola non conta",   LeggiPrezzoDaCommento("closl 1.2345", t, v) == false);
      Caso("EPrezzo su '1.2345'",  EPrezzo("1.2345") == true);
      Caso("EPrezzo su '24178'",   EPrezzo("24178") == true);
      Caso("EPrezzo su 'abc'",     EPrezzo("abc") == false);
      Caso("EPrezzo su '1.2.3'",   EPrezzo("1.2.3") == false);
      Caso("EPrezzo su vuoto",     EPrezzo("") == false);
     }

   //--- BLOCCO 4: risoluzione del motivo -------------------------------
   blocchi++;
   Caso("commento SL batte campo 0 (cliente)",  RisolviMotivo(MOT_CLIENT, MOT_SL) == MOT_SL);
   Caso("commento TP batte campo 3 (EA)",       RisolviMotivo(MOT_EXPERT, MOT_TP) == MOT_TP);
   Caso("senza commento vale il campo",         RisolviMotivo(MOT_EXPERT, MOT_IGNOTO) == MOT_EXPERT);
   Caso("niente e niente = IGNOTO",             RisolviMotivo(MOT_IGNOTO, MOT_IGNOTO) == MOT_IGNOTO);

   //--- BLOCCO 5: i codici sono quelli DELLA PIATTAFORMA ---------------
   //  Non ci si fida di un #define che ricopia a mano un enum: si
   //  confronta col valore vero di MT5. Se una build futura lo cambia,
   //  il rosso si vede qui e non dentro una statistica.
   blocchi++;
   Caso("MOT_SL == DEAL_REASON_SL",         MOT_SL == (int)DEAL_REASON_SL);
   Caso("MOT_TP == DEAL_REASON_TP",         MOT_TP == (int)DEAL_REASON_TP);
   Caso("MOT_SO == DEAL_REASON_SO",         MOT_SO == (int)DEAL_REASON_SO);
   Caso("MOT_EXPERT == DEAL_REASON_EXPERT", MOT_EXPERT == (int)DEAL_REASON_EXPERT);
   Caso("MOT_CLIENT == DEAL_REASON_CLIENT", MOT_CLIENT == (int)DEAL_REASON_CLIENT);
   Caso("ENT_IN == DEAL_ENTRY_IN",          ENT_IN == (int)DEAL_ENTRY_IN);
   Caso("ENT_OUT == DEAL_ENTRY_OUT",        ENT_OUT == (int)DEAL_ENTRY_OUT);
   Caso("ENT_INOUT == DEAL_ENTRY_INOUT",    ENT_INOUT == (int)DEAL_ENTRY_INOUT);
   Caso("ENT_OUTBY == DEAL_ENTRY_OUT_BY",   ENT_OUTBY == (int)DEAL_ENTRY_OUT_BY);
   Caso("REALE == ACCOUNT_TRADE_MODE_REAL", CodiceTipoConto("REALE") == (int)ACCOUNT_TRADE_MODE_REAL);
   Caso("DEMO == ACCOUNT_TRADE_MODE_DEMO",  CodiceTipoConto("DEMO") == (int)ACCOUNT_TRADE_MODE_DEMO);

   //--- BLOCCO 6: nomi e codici, andata e ritorno ----------------------
   blocchi++;
   Caso("motivo SL andata e ritorno",    CodiceMotivo(NomeMotivo(MOT_SL)) == MOT_SL);
   Caso("motivo STOPOUT andata/ritorno", CodiceMotivo(NomeMotivo(MOT_SO)) == MOT_SO);
   Caso("motivo IGNOTO andata/ritorno",  CodiceMotivo(NomeMotivo(MOT_IGNOTO)) == MOT_IGNOTO);
   Caso("entrata OUT andata e ritorno",  CodiceEntrata(NomeEntrata(ENT_OUT)) == ENT_OUT);
   Caso("entrata INOUT andata/ritorno",  CodiceEntrata(NomeEntrata(ENT_INOUT)) == ENT_INOUT);
   Caso("tipo VENDITA andata e ritorno", CodiceTipoDeal(NomeTipoDeal(1)) == 1);
   Caso("fonte COMMENTO andata/ritorno", CodiceFonte(NomeFonte(FONTE_COMMENTO)) == FONTE_COMMENTO);
   Caso("fonte NESSUNA andata/ritorno",  CodiceFonte(NomeFonte(FONTE_NESSUNA)) == FONTE_NESSUNA);

   //--- BLOCCO 7: percentile, ricerca binaria, prefisso ----------------
   blocchi++;
     {
      double v[];
      ArrayResize(v, 100);
      for(int i=0; i<100; i++) v[i] = (double)(i+1);
      Caso("mediana di 1..100 = 50",  Vicini(Percentile(v, 100, 0.50), 50.0, 1e-9));
      Caso("P95 di 1..100 = 95",      Vicini(Percentile(v, 100, 0.95), 95.0, 1e-9));
      Caso("P99 di 1..100 = 99",      Vicini(Percentile(v, 100, 0.99), 99.0, 1e-9));
      Caso("massimo di 1..100 = 100", Vicini(Percentile(v, 100, 1.00), 100.0, 1e-9));
      Caso("percentile su n=0 = 0",   Vicini(Percentile(v, 0, 0.50), 0.0, 1e-9));

      long a[];
      int na = 0;
      Caso("primo ticket inserito",        InserisciOrdinato(a, na, 500, 10) == 1 && na == 1);
      Caso("ticket piu' piccolo in testa", InserisciOrdinato(a, na, 100, 10) == 1 && na == 2 && a[0] == 100 && a[1] == 500);
      Caso("ticket in mezzo",              InserisciOrdinato(a, na, 300, 10) == 1 && na == 3 && a[1] == 300);
      Caso("RIPETUTO: esito 0, non -1",    InserisciOrdinato(a, na, 300, 10) == 0 && na == 3);
      Caso("ricerca trova",                CercaOrdinato(a, na, 500) == 2);
      Caso("ricerca non trova",            CercaOrdinato(a, na, 400) < 0);
      //  il tetto: un ticket NUOVO con l'elenco pieno deve dare -1 e NON
      //  entrare. Se desse 0 verrebbe scambiato per un doppione e il deal
      //  sparirebbe dal registro senza che nessuno lo dica.
      Caso("tetto pieno: esito -1",        InserisciOrdinato(a, na, 700, 3) == -1 && na == 3);
      Caso("tetto pieno: il RIPETUTO da' comunque 0", InserisciOrdinato(a, na, 300, 3) == 0 && na == 3);

      Caso("prefisso buono accettato",   PrefissoValido("ABTG_SlippageLogger") == true);
      Caso("prefisso altrui rifiutato",  PrefissoValido("ABTG_SpreadLogger") == false);
      Caso("prefisso con percorso rifiutato", PrefissoValido("ABTG_Slippage\\altro") == false);
      Caso("prefisso corto rifiutato",   PrefissoValido("ABTG") == false);
     }

   //--- BLOCCO 8: sanificazione dei campi di testo ---------------------
   blocchi++;
   Caso("il separatore dentro un campo viene tolto", Sanifica("sl 1.2345; tp 9") == "sl 1.2345  tp 9");
   Caso("il fine riga dentro un campo viene tolto",  StringFind(Sanifica("aaa\r\nbbb"), "\n") < 0);
   Caso("campo vuoto diventa un trattino",           Sanifica("") == "-");
   Caso("spazi di bordo tolti",                      Sanifica("  ciao  ") == "ciao");
   Caso("numero mancante scritto n/d",               NumOpz(0.0, false, 2) == "n/d");
   Caso("numero presente scritto per esteso",        NumOpz(1.5, true, 2) == "1.50");

   //--- BLOCCO 9: il giro completo di una riga del registro -----------
   //  Si costruisce un campione che imita il caso VERO di R109
   //  (NASUSD short chiuso in stop 21,5 punti indice oltre il livello),
   //  lo si scrive, lo si rilegge e si confronta campo per campo.
   blocchi++;
     {
      Campione c;
      c.deal = 987654; c.ordine = 987650; c.posizione = 4321;
      c.t = StringToTime("2026.06.06 13:30:00"); c.msc = 1780000000123;
      c.login = 12345678; c.modo = 2;
      c.sym = "NASUSD"; c.magic = 770611;
      c.entrata = ENT_OUT; c.tipoDeal = 0; c.motivo = MOT_SL;
      c.volume = 0.65; c.eseguito = 21681.60; c.richiesto = 21660.10;
      c.fonte = FONTE_COMMENTO;
      c.pc = 21660.10; c.hc = true;
      c.po = 21681.60; c.ho = true;
      c.ps = 21660.10; c.hs = true;
      c.etaSnap = 0.8;
      c.punti = 2150.0; c.okPunti = true;
      c.valuta = -13.97; c.okValuta = true;
      c.commissione = -0.50; c.swap = 0.0; c.profitto = -2159.93;
      c.digits = 2; c.point = 0.01;
      c.commento = "sl 21660.10";

      string riga = RigaCsv(c);
      string p[];
      int np = StringSplit(riga, ';', p);
      Caso("riga del registro: NCOL campi", np == NCOL);
      Caso("intestazione: NCOL campi",      StringSplit(Intestazione(), ';', p) == NCOL);

      Campione d;
      bool ok = LeggiRigaCsv(riga, d);
      Caso("la riga si rilegge",            ok == true);
      Caso("ritorno: ticket del deal",      ok && d.deal == c.deal);
      Caso("ritorno: posizione",            ok && d.posizione == c.posizione);
      Caso("ritorno: login",                ok && d.login == c.login);
      Caso("ritorno: tipo di conto REALE",  ok && d.modo == 2);
      Caso("ritorno: simbolo",              ok && d.sym == "NASUSD");
      Caso("ritorno: magic",                ok && d.magic == 770611);
      Caso("ritorno: entrata OUT",          ok && d.entrata == ENT_OUT);
      Caso("ritorno: tipo ACQUISTO",        ok && d.tipoDeal == 0);
      Caso("ritorno: motivo SL",            ok && d.motivo == MOT_SL);
      Caso("ritorno: volume",               ok && Vicini(d.volume, 0.65, 1e-9));
      Caso("ritorno: prezzo eseguito",      ok && Vicini(d.eseguito, 21681.60, 1e-6));
      Caso("ritorno: prezzo richiesto",     ok && Vicini(d.richiesto, 21660.10, 1e-6));
      Caso("ritorno: fonte COMMENTO",       ok && d.fonte == FONTE_COMMENTO);
      Caso("ritorno: scarto in punti",      ok && d.okPunti && Vicini(d.punti, 2150.0, 1e-6));
      Caso("ritorno: costo in valuta",      ok && d.okValuta && Vicini(d.valuta, -13.97, 1e-6));
      Caso("ritorno: digits",               ok && d.digits == 2);
      Caso("ritorno: commento",             ok && d.commento == "sl 21660.10");
      Caso("l'intestazione NON e' una riga di dati", LeggiRigaCsv(Intestazione(), d) == false);
      Caso("una riga troncata viene rifiutata",      LeggiRigaCsv("123;456;789", d) == false);
      //  il conto che il referto stampera': 2150 punti MT5 su un simbolo
      //  a 2 decimali sono 21,5 punti indice. E' il numero di R109.
      Caso("2150 punti MT5 = 21,5 punti indice", Vicini(2150.0/PuntiPerUnita(2), 21.5, 1e-9));
     }

   int attesiBlocchi = ABTG_SLIPLOG_AUTOTEST_BLOCCHI_ATTESI;
   int attesiCasi    = ABTG_SLIPLOG_AUTOTEST_CASI_ATTESI;
   g_autoFalliti = g_casiRossi;
   PrintFormat("[SLIPLOG] AUTOTEST: %d blocchi su %d dichiarati, %d casi su %d dichiarati, %d falliti.",
               blocchi, attesiBlocchi, g_casiFatti, attesiCasi, g_casiRossi);
   if(blocchi != attesiBlocchi || g_casiFatti != attesiCasi)
      Print("[SLIPLOG] ATTENZIONE: i conteggi dell'autotest non coincidono con i #define dichiarati nel sorgente. Non e' un guasto della misura, ma il sorgente e la riga di lancio non si raccontano la stessa cosa: va sistemato prima del prossimo pin.");
   return (g_casiRossi == 0);
  }

//==========================================================================
//  FILE
//==========================================================================
//+------------------------------------------------------------------+
//| REGISTRA un deal nell'elenco di quelli gia' visti.                |
//| 1 = nuovo, 0 = c'era gia', -1 = tetto raggiunto.                  |
//| Quando il tetto arriva NON si registra e NON si scrive niente:    |
//| senza l'elenco non si distingue piu' un deal nuovo da uno gia'    |
//| scritto, e un registro pieno di doppioni e' peggio di un registro |
//| che si ferma dicendolo.                                           |
//+------------------------------------------------------------------+
int Registra(const long deal)
  {
   int e = InserisciOrdinato(g_visti, g_nVisti, deal, MAXVISTI);
   if(e < 0)
     {
      g_vistiPersi++;
      if(g_vistiPersi == 1)
         Print("[SLIPLOG] *** TETTO RAGGIUNTO *** l'elenco dei deal gia' registrati ha toccato il suo tetto: da qui in avanti NON registro piu' niente. Il registro scritto finora e' buono: portalo via, e riparti con un file nuovo.");
     }
   return e;
  }

string Base()
  {
   return InpPrefissoFile + "_" + IntegerToString(g_contoMio);
  }
string FileLedger()  { return Base() + "_deal.csv"; }
string FileSintesi() { return Base() + "_sintesi.csv"; }
string FileReferto() { return Base() + "_REFERTO.txt"; }

//+------------------------------------------------------------------+
//| RILEGGE IL REGISTRO all'avvio: ricostruisce sia l'elenco dei deal |
//| gia' registrati (per non ripeterli) sia i campioni per le         |
//| statistiche. Senza questo, ogni riavvio del terminale             |
//| riscriverebbe da capo tutto lo storico recuperabile e il referto  |
//| conterebbe due volte le stesse scivolate.                         |
//+------------------------------------------------------------------+
void LeggiLedger()
  {
   string nome = FileLedger();
   if(!FileIsExist(nome))
     {
      g_letturaLedger = "nessun registro precedente: raccolta NUOVA da zero (" + nome + ")";
      return;
     }
   int fh = FileOpen(nome, FILE_READ|FILE_TXT|FILE_ANSI|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(fh == INVALID_HANDLE)
     {
      g_letturaLedger = "registro PRESENTE ma NON LEGGIBILE (errore " + IntegerToString(GetLastError()) +
                        "): questo avvio NON lo rilegge e NON lo tocca. Le righe vecchie restano dove sono, ma i deal che contengono potrebbero essere riscritti in coda: guardalo a mano prima di usare il file.";
      Print("[SLIPLOG] ATTENZIONE: ", g_letturaLedger);
      return;
     }
   long buone = 0, brutte = 0, altroConto = 0;
   while(!FileIsEnding(fh))
     {
      string riga = FileReadString(fh);
      StringTrimRight(riga);
      if(StringLen(riga) == 0) continue;
      if(StringGetCharacter(riga, 0) == '#') continue;
      Campione c;
      if(!LeggiRigaCsv(riga, c))
        {
         if(StringSubstr(riga, 0, 4) != "deal") brutte++;
         continue;
        }
      if(Registra(c.deal) != 1) continue;
      if(c.login != g_contoMio) altroConto++;
      AggiungiCampione(c);
      buone++;
     }
   FileClose(fh);
   g_letturaLedger = "RIPRESO da " + nome + ": " + IntegerToString(buone) + " righe rilette, " +
                     IntegerToString(brutte) + " righe illeggibili saltate";
   if(altroConto > 0)
      g_letturaLedger = g_letturaLedger + "   *** " + IntegerToString(altroConto) +
                        " RIGHE DI UN ALTRO CONTO nello stesso file: non dovrebbe poter succedere, perche' il numero di conto sta nel NOME del file. Non si citano numeri da questo registro finche' non e' chiaro come ci sono finite. ***";
   Print("[SLIPLOG] ", g_letturaLedger);
  }

//+------------------------------------------------------------------+
//| Aggiunge un campione alla memoria delle statistiche.              |
//| Il registro su file resta COMPLETO anche quando questa memoria e' |
//| piena: il tetto tocca le statistiche a schermo, non il dato.      |
//+------------------------------------------------------------------+
void AggiungiCampione(const Campione &c)
  {
   if(g_nCamp >= MAXCAMP) { g_campPersi++; return; }
   if(ArraySize(g_c) < g_nCamp + 1) ArrayResize(g_c, g_nCamp + 512);
   g_c[g_nCamp] = c;
   g_nCamp++;
  }

//+------------------------------------------------------------------+
//| Scrive in coda al registro. In coda, MAI sopra: il registro e' il |
//| dato, e un dato che si riscrive non e' un registro.               |
//| Ritorna false e lo dichiara se non ci riesce.                     |
//+------------------------------------------------------------------+
bool ScriviRighe(string &righe[], const int n)
  {
   if(n <= 0) return true;
   int fh = FileOpen(FileLedger(), FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE)
     {
      g_erroriScrittura++;
      PrintFormat("[SLIPLOG] ATTENZIONE: non riesco ad aprire %s (errore %d). %d righe NON sono state scritte: restano solo in memoria e si perdono allo stacco.",
                  FileLedger(), GetLastError(), n);
      return false;
     }
   ulong dim = FileSize(fh);
   FileSeek(fh, 0, SEEK_END);
   if(dim == 0) FileWriteString(fh, Intestazione() + "\r\n");
   for(int i=0; i<n; i++) FileWriteString(fh, righe[i] + "\r\n");
   FileFlush(fh);
   FileClose(fh);
   return true;
  }

//==========================================================================
//  FOTO DELLE POSIZIONI APERTE
//  E' l'unica cosa che questo EA guarda in tempo reale, e serve a una
//  cosa sola: sapere DOVE STAVA lo stop un istante prima che venisse
//  eseguito. Dopo, quel livello dallo storico non si legge piu'.
//==========================================================================
int TrovaPos(const long pid)
  {
   for(int i=0; i<g_nPos; i++) if(g_pPos[i] == pid) return i;
   return -1;
  }

void RegistraSnapshot(const long pid, const string sym, const long magic, const int tipo,
                      const double vol, const double apertura, const double sl, const double tp)
  {
   int i = TrovaPos(pid);
   if(i < 0)
     {
      if(g_nPos >= MAXPOS)
        {
         //--- si scarta la foto piu' VECCHIA, e si conta: un tetto che
         //    butta in silenzio e' un dato perso in silenzio.
         int vecchio = 0;
         for(int k=1; k<g_nPos; k++) if(g_pQuando[k] < g_pQuando[vecchio]) vecchio = k;
         i = vecchio;
         g_pAgg[i] = 0;      // e' un'altra posizione: il contatore riparte
         g_posPersi++;
        }
      else
        {
         i = g_nPos;
         g_nPos++;
         ArrayResize(g_pPos, g_nPos);   ArrayResize(g_pSym, g_nPos);
         ArrayResize(g_pMagic, g_nPos); ArrayResize(g_pTipo, g_nPos);
         ArrayResize(g_pVol, g_nPos);   ArrayResize(g_pOpen, g_nPos);
         ArrayResize(g_pSL, g_nPos);    ArrayResize(g_pTP, g_nPos);
         ArrayResize(g_pQuando, g_nPos);ArrayResize(g_pAgg, g_nPos);
         g_pAgg[i] = 0;
        }
      g_pPos[i] = pid;
     }
   g_pSym[i]    = sym;
   g_pMagic[i]  = magic;
   g_pTipo[i]   = tipo;
   g_pVol[i]    = vol;
   g_pOpen[i]   = apertura;
   g_pSL[i]     = sl;
   g_pTP[i]     = tp;
   g_pQuando[i] = TimeCurrent();
   g_pAgg[i]    = g_pAgg[i] + 1;
  }

void FotografaPosizioni()
  {
   int tot = PositionsTotal();
   for(int i=0; i<tot; i++)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      long pid = PositionGetInteger(POSITION_IDENTIFIER);
      if(pid <= 0) pid = (long)tk;
      RegistraSnapshot(pid,
                       PositionGetString(POSITION_SYMBOL),
                       PositionGetInteger(POSITION_MAGIC),
                       (int)PositionGetInteger(POSITION_TYPE),
                       PositionGetDouble(POSITION_VOLUME),
                       PositionGetDouble(POSITION_PRICE_OPEN),
                       PositionGetDouble(POSITION_SL),
                       PositionGetDouble(POSITION_TP));
     }
  }

//==========================================================================
//  SCANSIONE DELLO STORICO -- IN TRE PASSAGGI, e il motivo sta in testa
//  al file: selezionare un ORDINE storico per ticket SVUOTA la lista dei
//  deal che HistorySelect aveva riempito. Chiedere il prezzo dell'ordine
//  dentro il ciclo sui deal farebbe sparire i deal sotto i piedi al ciclo.
//==========================================================================
void Scansiona(const datetime da, const string perche)
  {
   g_scansioni++;
   datetime a = (datetime)((long)TimeCurrent() + 3600);
   if(!HistorySelect(da, a))
     {
      g_erroriStorico++;
      PrintFormat("[SLIPLOG] ATTENZIONE: lo storico da %s non si e' fatto leggere (errore %d). Questa scansione (%s) non ha misurato niente: si riprova al giro dopo.",
                  TimeToString(da, TIME_DATE|TIME_SECONDS), GetLastError(), perche);
      return;
     }
   int tot = HistoryDealsTotal();

   //--- PASSAGGIO 1: si legge TUTTO dei deal nuovi, mentre la lista dei
   //    deal e' ancora quella buona. Niente ordini, qui dentro.
   Campione lotto[];
   long ordini[];
   int nl = 0;
   for(int i=0; i<tot; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      g_dealLetti++;
      long dt = (long)tk;
      int pos = CercaOrdinato(g_visti, g_nVisti, dt);
      if(pos >= 0) continue;               // gia' registrato

      long tipo = HistoryDealGetInteger(tk, DEAL_TYPE);
      if(tipo != DEAL_TYPE_BUY && tipo != DEAL_TYPE_SELL)
        {
         //--- versamenti, prelievi, correzioni: non sono esecuzioni, e
         //    contarli come tali sporcherebbe ogni statistica.
         if(Registra(dt) == 1) g_nonTrading++;
         continue;
        }
      long entrata = HistoryDealGetInteger(tk, DEAL_ENTRY);
      if(entrata == DEAL_ENTRY_IN && !InpLoggaIngressi)
        {
         Registra(dt);
         continue;
        }

      ArrayResize(lotto, nl+1);
      ArrayResize(ordini, nl+1);
      Campione c;
      c.deal      = dt;
      c.ordine    = HistoryDealGetInteger(tk, DEAL_ORDER);
      c.posizione = HistoryDealGetInteger(tk, DEAL_POSITION_ID);
      c.t         = (datetime)HistoryDealGetInteger(tk, DEAL_TIME);
      c.msc       = HistoryDealGetInteger(tk, DEAL_TIME_MSC);
      c.login     = g_contoMio;
      c.modo      = g_modoMio;
      c.sym       = HistoryDealGetString(tk, DEAL_SYMBOL);
      c.magic     = HistoryDealGetInteger(tk, DEAL_MAGIC);
      c.entrata   = (int)entrata;
      c.tipoDeal  = (tipo == DEAL_TYPE_BUY ? 0 : 1);
      c.motivo    = (int)HistoryDealGetInteger(tk, DEAL_REASON);
      c.volume    = HistoryDealGetDouble(tk, DEAL_VOLUME);
      c.eseguito  = HistoryDealGetDouble(tk, DEAL_PRICE);
      c.commissione = HistoryDealGetDouble(tk, DEAL_COMMISSION);
      c.swap        = HistoryDealGetDouble(tk, DEAL_SWAP);
      c.profitto    = HistoryDealGetDouble(tk, DEAL_PROFIT);
      c.commento    = HistoryDealGetString(tk, DEAL_COMMENT);
      c.richiesto = 0.0; c.fonte = FONTE_NESSUNA;
      c.pc = 0.0; c.po = 0.0; c.ps = 0.0;
      c.hc = false; c.ho = false; c.hs = false;
      c.etaSnap = -1.0;
      c.punti = 0.0; c.okPunti = false;
      c.valuta = 0.0; c.okValuta = false;
      c.digits = 0; c.point = 0.0;
      lotto[nl]  = c;
      ordini[nl] = c.ordine;
      nl++;
     }
   if(nl <= 0) return;

   //--- PASSAGGIO 2: ora, e SOLO ora, si chiedono gli ordini. Da qui in
   //    poi la lista dei deal non e' piu' valida e non la si usa piu'.
   double prezzoOrd[];
   bool   haOrd[];
   ArrayResize(prezzoOrd, nl);
   ArrayResize(haOrd, nl);
   for(int i=0; i<nl; i++)
     {
      prezzoOrd[i] = 0.0;
      haOrd[i]     = false;
      if(ordini[i] <= 0) continue;
      if(!HistoryOrderSelect((ulong)ordini[i])) continue;
      double v = HistoryOrderGetDouble((ulong)ordini[i], ORDER_PRICE_OPEN);
      if(v > 0.0) { prezzoOrd[i] = v; haOrd[i] = true; }
     }

   //--- PASSAGGIO 3: si conclude, si registra, si scrive.
   string righe[];
   int nr = 0;
   ArrayResize(righe, nl);
   for(int i=0; i<nl; i++)
     {
      Campione c = lotto[i];
      c.po = prezzoOrd[i];
      c.ho = haOrd[i];

      //--- fonte C: il commento del server
      int mc = MOT_IGNOTO;
      double vc = 0.0;
      if(c.entrata != ENT_IN && LeggiPrezzoDaCommento(c.commento, mc, vc)) { c.pc = vc; c.hc = true; }
      c.motivo = RisolviMotivo(c.motivo, mc);

      //--- fonte A: la nostra foto della posizione
      if(c.entrata != ENT_IN)
        {
         int ip = TrovaPos(c.posizione);
         if(ip >= 0)
           {
            double liv = 0.0;
            if(c.motivo == MOT_SL) liv = g_pSL[ip];
            if(c.motivo == MOT_TP) liv = g_pTP[ip];
            if(liv > 0.0) { c.ps = liv; c.hs = true; }
            c.etaSnap = (double)((long)c.t - (long)g_pQuando[ip]);
            if(c.etaSnap < 0.0) c.etaSnap = 0.0;
           }
        }

      //--- la priorita', dichiarata: commento, poi ordine, poi foto.
      if(c.hc)      { c.richiesto = c.pc; c.fonte = FONTE_COMMENTO; }
      else if(c.ho) { c.richiesto = c.po; c.fonte = FONTE_ORDINE;   }
      else if(c.hs) { c.richiesto = c.ps; c.fonte = FONTE_SNAPSHOT; }
      else          { c.richiesto = 0.0;  c.fonte = FONTE_NESSUNA;  }

      //--- anagrafica del simbolo (nessuna scrittura: si legge e basta)
      c.digits = (int)SymbolInfoInteger(c.sym, SYMBOL_DIGITS);
      c.point  = SymbolInfoDouble(c.sym, SYMBOL_POINT);
      if(c.point <= 0.0 && c.digits > 0) c.point = MathPow(10, -c.digits);

      //--- lo scarto
      if(c.fonte != FONTE_NESSUNA && c.eseguito > 0.0)
        {
         double diff = ScartoAvverso(c.richiesto, c.eseguito, (c.tipoDeal == 0));
         double pt = 0.0;
         if(PuntiDaPrezzo(diff, c.point, pt)) { c.punti = pt; c.okPunti = true; }
         double ts = SymbolInfoDouble(c.sym, SYMBOL_TRADE_TICK_SIZE);
         double tv = SymbolInfoDouble(c.sym, SYMBOL_TRADE_TICK_VALUE);
         if(ts > 0.0 && tv > 0.0 && c.volume > 0.0)
           {
            c.valuta   = (diff / ts) * tv * c.volume;
            c.okValuta = true;
           }
        }

      //--- si registra PRIMA di scrivere: se il tetto e' arrivato, questa
      //    riga non si scrive, altrimenti al giro dopo tornerebbe "nuova".
      if(Registra(c.deal) != 1) continue;
      AggiungiCampione(c);
      righe[nr] = RigaCsv(c);
      nr++;
      g_dealNuovi++;
      if(InpLogOgniDeal)
         PrintFormat("[SLIPLOG] deal %s %s %s %s vol %s  eseguito %s  richiesto %s (%s)  scarto %s punti MT5%s",
                     IntegerToString(c.deal), c.sym, NomeEntrata(c.entrata), NomeMotivo(c.motivo),
                     DoubleToString(c.volume,2), DoubleToString(c.eseguito, (int)MathMax(c.digits,2)),
                     NumOpz(c.richiesto, c.fonte != FONTE_NESSUNA, (int)MathMax(c.digits,2)), NomeFonte(c.fonte),
                     NumOpz(c.punti, c.okPunti, 1),
                     (c.okPunti && c.punti > 0.0 ? "  (AVVERSO)" : ""));
     }
   ScriviRighe(righe, nr);
  }

//==========================================================================
//  STATISTICHE E REFERTO
//==========================================================================
//  Filtro: sym "*" = qualunque, magic -1 = qualunque, motivo/entrata
//  -999 = qualunque. Conta SOLO i campioni con lo scarto calcolabile,
//  e restituisce a parte quanti ne ha scartati: una mediana su n=3 e una
//  su n=300 non sono la stessa cosa, e il referto lo deve poter dire.
bool Passa(const Campione &c, const string sym, const long magic, const int motivo, const int entrata)
  {
   if(sym != "*" && c.sym != sym) return false;
   if(magic >= 0 && c.magic != magic) return false;
   if(motivo != -999 && c.motivo != motivo) return false;
   if(entrata != -999 && c.entrata != entrata) return false;
   return true;
  }

void Statistica(const string sym, const long magic, const int motivo, const int entrata,
                int &n, int &nSenza, double &med, double &p95, double &massimo,
                double &media, double &costo, double &ppu, string &unita)
  {
   n = 0; nSenza = 0; med = 0.0; p95 = 0.0; massimo = 0.0; media = 0.0; costo = 0.0;
   ppu = 1.0; unita = "punti MT5";
   double v[];
   ArrayResize(v, (int)MathMax(g_nCamp, 1));
   double somma = 0.0;
   int digits = -1;
   for(int i=0; i<g_nCamp; i++)
     {
      if(!Passa(g_c[i], sym, magic, motivo, entrata)) continue;
      if(!g_c[i].okPunti) { nSenza++; continue; }
      if(digits < 0) digits = g_c[i].digits;
      v[n] = g_c[i].punti;
      somma += g_c[i].punti;
      if(g_c[i].okValuta) costo += g_c[i].valuta;
      n++;
     }
   if(n <= 0) return;
   if(digits >= 0) { ppu = PuntiPerUnita(digits); unita = NomeUnita(digits); }
   ArrayResize(v, n);
   ArraySort(v);
   med     = Percentile(v, n, 0.50);
   p95     = Percentile(v, n, 0.95);
   massimo = v[n-1];
   media   = somma / (double)n;
  }

//--- elenco dei valori distinti presenti nei campioni
int SimboliDistinti(string &fuori[])
  {
   ArrayResize(fuori, 0);
   int q = 0;
   for(int i=0; i<g_nCamp; i++)
     {
      bool c1 = false;
      for(int k=0; k<q; k++) if(fuori[k] == g_c[i].sym) c1 = true;
      if(c1) continue;
      ArrayResize(fuori, q+1);
      fuori[q] = g_c[i].sym;
      q++;
     }
   return q;
  }
int MagicDistinti(long &fuori[])
  {
   ArrayResize(fuori, 0);
   int q = 0;
   for(int i=0; i<g_nCamp; i++)
     {
      bool c1 = false;
      for(int k=0; k<q; k++) if(fuori[k] == g_c[i].magic) c1 = true;
      if(c1) continue;
      ArrayResize(fuori, q+1);
      fuori[q] = g_c[i].magic;
      q++;
     }
   return q;
  }

string RigaTabella(const string etichetta, const string sym, const long magic, const int motivo, const int entrata)
  {
   int n=0, nSenza=0;
   double med=0, p95=0, mx=0, media=0, costo=0, ppu=1;
   string unita = "";
   Statistica(sym, magic, motivo, entrata, n, nSenza, med, p95, mx, media, costo, ppu, unita);
   if(n <= 0 && nSenza <= 0) return "";
   if(n <= 0)
      return "  " + PadDx(etichetta, 34) + " | " + Pad("0",5) + " |    nessuno scarto calcolabile (" + IntegerToString(nSenza) + " deal senza prezzo richiesto)";
   return "  " + PadDx(etichetta, 34) + " | " + Pad(IntegerToString(n),5) + " | " +
          Pad(DoubleToString(med/ppu,3),9) + " | " + Pad(DoubleToString(p95/ppu,3),9) + " | " +
          Pad(DoubleToString(mx/ppu,3),9) + " | " + Pad(DoubleToString(media/ppu,3),9) + " | " +
          Pad(DoubleToString(costo,2),11) + " | " + PadDx(unita,12) + " | senza richiesto " + IntegerToString(nSenza);
  }

void ScriviReferto()
  {
   int fh = FileOpen(FileReferto(), FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE) { g_erroriScrittura++; return; }

   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "  SLIPPAGE VERO -- " + ABTG_SLIPLOG_MARCATORE + "\r\n");
   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "conto              : " + IntegerToString(g_contoMio) + " @ " + g_serverMio +
                       "   tipo: " + NomeTipoConto(g_modoMio) + "\r\n");
   if(g_avvisoConto != "")
      FileWriteString(fh, "*** " + g_avvisoConto + " ***\r\n");
   FileWriteString(fh, "scritto il (server): " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "avvio di QUESTA istanza (server): " + TimeToString(g_avvioIstanza, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "registro           : " + FileLedger() + "\r\n");
   FileWriteString(fh, "ripresa all'avvio  : " + g_letturaLedger + "\r\n");
   FileWriteString(fh, "deal esaminati     : " + IntegerToString(g_dealLetti) + "   registrati NUOVI: " + IntegerToString(g_dealNuovi) +
                       "   movimenti di conto saltati: " + IntegerToString(g_nonTrading) + "\r\n");
   FileWriteString(fh, "campioni in memoria: " + IntegerToString(g_nCamp) + "   scansioni: " + IntegerToString(g_scansioni) +
                       "   salvataggi: " + IntegerToString(g_salvataggi) + "\r\n");
   FileWriteString(fh, "posizioni sotto foto: " + IntegerToString(g_nPos) + " (tetto " + IntegerToString(MAXPOS) +
                       ", foto buttate per il tetto: " + IntegerToString(g_posPersi) + ")\r\n");
   if(g_campPersi > 0 || g_vistiPersi > 0 || g_erroriStorico > 0 || g_erroriScrittura > 0)
      FileWriteString(fh, "TETTI E GUASTI     : campioni non tenuti in memoria " + IntegerToString(g_campPersi) +
                          ", elenco deal oltre il tetto " + IntegerToString(g_vistiPersi) +
                          ", letture dello storico fallite " + IntegerToString(g_erroriStorico) +
                          ", scritture fallite " + IntegerToString(g_erroriScrittura) + "\r\n");
   FileWriteString(fh, "autotest           : " + (InpAutoTest ? ("casi falliti " + IntegerToString(g_autoFalliti) + " (0 = le funzioni di segno, parsing e percentile sono verificate a tavolino)")
                                                              : "DISATTIVATO da input in questo avvio") + "\r\n");
   FileWriteString(fh, "\r\n");

   //--- il cartello che decide se questi numeri valgono qualcosa
   if(g_modoMio != 2)
     {
      FileWriteString(fh, "#####################################################################\r\n");
      FileWriteString(fh, "  QUESTO NON E' UN CONTO REALE (" + NomeTipoConto(g_modoMio) + ").\r\n");
      FileWriteString(fh, "  BCM ha confermato che sul DEMO lo slippage NON e' simulato: qui la\r\n");
      FileWriteString(fh, "  differenza fra richiesto ed eseguito e' zero PER COSTRUZIONE, e uno\r\n");
      FileWriteString(fh, "  zero di questo referto NON e' una misura -- e' l'assenza della cosa\r\n");
      FileWriteString(fh, "  da misurare. Serve a collaudare la macchina, NON a dare un numero.\r\n");
      FileWriteString(fh, "#####################################################################\r\n\r\n");
     }

   FileWriteString(fh, "COME SI LEGGE -- e cosa NON c'e' dentro:\r\n");
   FileWriteString(fh, " - SEGNO: positivo = AVVERSO, cioe' abbiamo pagato PEGGIO del richiesto.\r\n");
   FileWriteString(fh, "   Negativo = riempimento MIGLIORE del richiesto (capita, non e' un errore).\r\n");
   FileWriteString(fh, " - le colonne sono nell'unita' pratica del simbolo (pip nel forex, punti\r\n");
   FileWriteString(fh, "   indice negli indici); nel registro c'e' anche il grezzo in PUNTI MT5.\r\n");
   FileWriteString(fh, " - la riga che conta e' quella del motivo SL: e' li' che una scivolata\r\n");
   FileWriteString(fh, "   allarga una perdita gia' presa.\r\n");
   FileWriteString(fh, " - il costo in valuta usa il valore del tick di ADESSO, non quello del\r\n");
   FileWriteString(fh, "   momento del deal: su simboli in valuta diversa e' un'approssimazione.\r\n");
   FileWriteString(fh, " - le ORE sono in ORA SERVER. Le schede Esperti/Giornale di MT5 sono in\r\n");
   FileWriteString(fh, "   ora LOCALE (un'ora avanti sul VPS): non si confrontano.\r\n");
   FileWriteString(fh, " - NON c'e' lo SPREAD (quello e' ABTG_SpreadLogger, e misura un'altra cosa).\r\n");
   FileWriteString(fh, " - broker singolo (BCM), un conto solo, un terminale solo.\r\n");
   FileWriteString(fh, "\r\n");

   //--- COERENZA DELLE TRE FONTI -----------------------------------------
   //  E' la sezione che dice se ci si puo' fidare del numero principale.
   int nOut=0, nC=0, nO=0, nS=0, nAcc=0, nConfr=0, nOrdUgualeEseg=0, nComUgualeEseg=0, nNiente=0;
   for(int i=0; i<g_nCamp; i++)
     {
      if(g_c[i].entrata == ENT_IN) continue;
      nOut++;
      if(g_c[i].hc) nC++;
      if(g_c[i].ho) nO++;
      if(g_c[i].hs) nS++;
      if(g_c[i].fonte == FONTE_NESSUNA) nNiente++;
      if(g_c[i].hc && g_c[i].ho)
        {
         nConfr++;
         double tol = (g_c[i].point > 0.0 ? g_c[i].point*0.5 : 1e-8);
         if(MathAbs(g_c[i].pc - g_c[i].po) <= tol) nAcc++;
        }
      if(g_c[i].ho && g_c[i].eseguito > 0.0)
        {
         double tol2 = (g_c[i].point > 0.0 ? g_c[i].point*0.5 : 1e-8);
         if(MathAbs(g_c[i].po - g_c[i].eseguito) <= tol2) nOrdUgualeEseg++;
        }
      if(g_c[i].hc && g_c[i].eseguito > 0.0)
        {
         double tol3 = (g_c[i].point > 0.0 ? g_c[i].point*0.5 : 1e-8);
         if(MathAbs(g_c[i].pc - g_c[i].eseguito) <= tol3) nComUgualeEseg++;
        }
     }
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, "  COERENZA DELLE TRE FONTI DEL PREZZO RICHIESTO (sulle sole USCITE)\r\n");
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, "  uscite in memoria .................: " + IntegerToString(nOut) + "\r\n");
   FileWriteString(fh, "  con COMMENTO del server (fonte C) .: " + IntegerToString(nC) + "\r\n");
   FileWriteString(fh, "  con prezzo dell'ORDINE (fonte B) ..: " + IntegerToString(nO) + "\r\n");
   FileWriteString(fh, "  con la nostra FOTO SL/TP (fonte A) : " + IntegerToString(nS) + "\r\n");
   FileWriteString(fh, "  SENZA nessuna fonte (scarto n/d) ..: " + IntegerToString(nNiente) + "\r\n");
   if(nConfr > 0)
      FileWriteString(fh, "  C e B confrontabili " + IntegerToString(nConfr) + ", d'accordo " + IntegerToString(nAcc) +
                          " (" + DoubleToString(100.0*(double)nAcc/(double)nConfr,1) + "%)\r\n");
   else
      FileWriteString(fh, "  C e B non sono mai confrontabili in questo campione.\r\n");
   FileWriteString(fh, "  fonte B che COINCIDE con l'eseguito: " + IntegerToString(nOrdUgualeEseg) + " su " + IntegerToString(nO) + "\r\n");
   FileWriteString(fh, "  fonte C che COINCIDE con l'eseguito: " + IntegerToString(nComUgualeEseg) + " su " + IntegerToString(nC) + "\r\n");
   if(nO > 0 && nOrdUgualeEseg == nO)
      FileWriteString(fh, "  >> ATTENZIONE: la fonte B coincide con l'eseguito in TUTTE le righe.\r\n" +
                          "     Vuol dire che questo server NON riporta il livello richiesto nel\r\n" +
                          "     prezzo dell'ordine: una misura basata su B direbbe 'slippage zero'\r\n" +
                          "     su QUALUNQUE conto. Sulle righe dove esiste, fa fede la fonte C.\r\n");
   if(nOut > 0 && nNiente == nOut)
      FileWriteString(fh, "  >> ATTENZIONE: NESSUNA riga ha un prezzo richiesto. Non c'e' nessuna\r\n" +
                          "     misura di slippage in questo referto: ci sono solo le esecuzioni.\r\n");
   FileWriteString(fh, "\r\n");

   //--- TABELLE ---------------------------------------------------------
   string testa = "  " + PadDx("gruppo",34) + " | " + Pad("n",5) + " | " + Pad("mediana",9) + " | " +
                  Pad("P95",9) + " | " + Pad("max",9) + " | " + Pad("media",9) + " | " +
                  Pad("costo tot",11) + " | " + PadDx("unita",12) + " |";
   string riga2 = "  " + PadDx("",34) + "-+-" + Pad("",5) + "-+-" + Pad("",9) + "-+-" + Pad("",9) + "-+-" +
                  Pad("",9) + "-+-" + Pad("",9) + "-+-" + Pad("",11) + "-+-" + PadDx("",12) + "-+";
   StringReplace(riga2, " ", "-");

   string sy[];
   int ns = SimboliDistinti(sy);
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, "  SCARTO PER SIMBOLO E PER MOTIVO DELL'USCITA (positivo = AVVERSO)\r\n");
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, testa + "\r\n" + riga2 + "\r\n");
   int motivi[6];
   motivi[0] = MOT_SL; motivi[1] = MOT_TP; motivi[2] = MOT_EXPERT;
   motivi[3] = MOT_CLIENT; motivi[4] = MOT_SO; motivi[5] = MOT_IGNOTO;
   for(int s=0; s<ns; s++)
     {
      for(int m=0; m<6; m++)
        {
         string r = RigaTabella(sy[s] + " uscita " + NomeMotivo(motivi[m]), sy[s], -1, motivi[m], ENT_OUT);
         if(r != "") FileWriteString(fh, r + "\r\n");
        }
      string ri = RigaTabella(sy[s] + " INGRESSI", sy[s], -1, -999, ENT_IN);
      if(ri != "") FileWriteString(fh, ri + "\r\n");
      FileWriteString(fh, riga2 + "\r\n");
     }
   FileWriteString(fh, "\r\n");

   long mg[];
   int nm = MagicDistinti(mg);
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, "  SCARTO PER SEDIA (magic) -- solo le uscite in STOP\r\n");
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, testa + "\r\n" + riga2 + "\r\n");
   for(int k=0; k<nm; k++)
     {
      string r = RigaTabella("magic " + IntegerToString(mg[k]) + " uscite SL", "*", mg[k], MOT_SL, ENT_OUT);
      if(r != "") FileWriteString(fh, r + "\r\n");
      string r2 = RigaTabella("magic " + IntegerToString(mg[k]) + " TUTTE le uscite", "*", mg[k], -999, ENT_OUT);
      if(r2 != "") FileWriteString(fh, r2 + "\r\n");
     }
   FileWriteString(fh, "\r\n");

   //--- LE PEGGIORI ------------------------------------------------------
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   FileWriteString(fh, "  LE 10 SCIVOLATE PEGGIORI (le medie non le fanno vedere)\r\n");
   FileWriteString(fh, "---------------------------------------------------------------------\r\n");
   bool usato[];
   ArrayResize(usato, (int)MathMax(g_nCamp,1));
   ArrayInitialize(usato, false);
   int quante = 0;
   for(int giro=0; giro<10; giro++)
     {
      int best = -1;
      for(int i=0; i<g_nCamp; i++)
        {
         if(usato[i]) continue;
         if(!g_c[i].okPunti) continue;
         if(best < 0 || g_c[i].punti > g_c[best].punti) best = i;
        }
      if(best < 0) break;
      usato[best] = true;
      quante++;
      double ppu = PuntiPerUnita(g_c[best].digits);
      FileWriteString(fh, "  " + TimeToString(g_c[best].t, TIME_DATE|TIME_SECONDS) + " | " +
                          PadDx(g_c[best].sym, 8) + " | magic " + Pad(IntegerToString(g_c[best].magic),7) + " | " +
                          PadDx(NomeEntrata(g_c[best].entrata) + " " + NomeMotivo(g_c[best].motivo), 12) + " | vol " +
                          Pad(DoubleToString(g_c[best].volume,2),7) + " | chiesto " +
                          Pad(NumOpz(g_c[best].richiesto, g_c[best].fonte != FONTE_NESSUNA, (int)MathMax(g_c[best].digits,2)),12) + " | eseguito " +
                          Pad(DoubleToString(g_c[best].eseguito, (int)MathMax(g_c[best].digits,2)),12) + " | scarto " +
                          Pad(DoubleToString(g_c[best].punti/ppu,3),9) + " " + NomeUnita(g_c[best].digits) +
                          " | costo " + NumOpz(g_c[best].valuta, g_c[best].okValuta, 2) +
                          " | fonte " + NomeFonte(g_c[best].fonte) +
                          " | eta' foto " + NumOpz(g_c[best].etaSnap, g_c[best].etaSnap >= 0.0, 1) + " s\r\n");
     }
   if(quante == 0) FileWriteString(fh, "  (nessuno scarto calcolabile finora)\r\n");
   FileWriteString(fh, "\r\n");
   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "  Registro grezzo (il dato): " + FileLedger() + "\r\n");
   FileWriteString(fh, "  Tabella per macchina .....: " + FileSintesi() + "\r\n");
   FileWriteString(fh, "=====================================================================\r\n");
   FileClose(fh);
  }

void ScriviSintesi()
  {
   int fh = FileOpen(FileSintesi(), FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE) { g_erroriScrittura++; return; }
   FileWriteString(fh, "simbolo;magic;entrata;motivo;n;senza_richiesto;mediana_punti;p95_punti;max_punti;media_punti;" +
                       "mediana_unita;p95_unita;max_unita;unita;costo_totale_valuta;tipo_conto;login\r\n");
   string sy[];
   int ns = SimboliDistinti(sy);
   long mg[];
   int nm = MagicDistinti(mg);
   int motivi[6];
   motivi[0] = MOT_SL; motivi[1] = MOT_TP; motivi[2] = MOT_EXPERT;
   motivi[3] = MOT_CLIENT; motivi[4] = MOT_SO; motivi[5] = MOT_IGNOTO;
   for(int s=0; s<ns; s++)
      for(int k=0; k<nm; k++)
         for(int m=0; m<7; m++)
           {
            int mot = -999;
            int ent = ENT_IN;
            if(m < 6) { mot = motivi[m]; ent = ENT_OUT; }
            int n=0, nSenza=0;
            double med=0,p95=0,mx=0,media=0,costo=0,ppu=1;
            string unita="";
            Statistica(sy[s], mg[k], mot, ent, n, nSenza, med, p95, mx, media, costo, ppu, unita);
            if(n <= 0 && nSenza <= 0) continue;
            FileWriteString(fh, sy[s] + ";" + IntegerToString(mg[k]) + ";" + (m < 6 ? "OUT" : "IN") + ";" +
                                (m < 6 ? NomeMotivo(mot) : "QUALUNQUE") + ";" +
                                IntegerToString(n) + ";" + IntegerToString(nSenza) + ";" +
                                DoubleToString(med,2) + ";" + DoubleToString(p95,2) + ";" +
                                DoubleToString(mx,2) + ";" + DoubleToString(media,2) + ";" +
                                DoubleToString(med/ppu,4) + ";" + DoubleToString(p95/ppu,4) + ";" +
                                DoubleToString(mx/ppu,4) + ";" + unita + ";" +
                                DoubleToString(costo,2) + ";" + NomeTipoConto(g_modoMio) + ";" +
                                IntegerToString(g_contoMio) + "\r\n");
           }
   FileClose(fh);
  }

void SalvaTutto(const string motivo)
  {
   g_salvataggi++;
   ScriviReferto();
   ScriviSintesi();
  }

//==========================================================================
//  COMMENT SUL GRAFICO -- leggero, nessun oggetto grafico
//==========================================================================
void AggiornaComment()
  {
   if(!InpMostraComment) return;
   string s = ABTG_SLIPLOG_MARCATORE + "\n";
   s += "SOLA LETTURA: non apre, non modifica, non chiude niente.\n";
   s += "conto " + IntegerToString(g_contoMio) + " @ " + g_serverMio + "  [" + NomeTipoConto(g_modoMio) + "]\n";
   if(g_avvisoConto != "") s += "!! " + g_avvisoConto + "\n";
   s += "ora server " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\n";
   s += "deal registrati " + IntegerToString(g_dealNuovi) + "   campioni " + IntegerToString(g_nCamp) +
        "   posizioni sotto foto " + IntegerToString(g_nPos) + "\n";
   s += "----------------------------------------\n";
   int n=0, nSenza=0;
   double med=0,p95=0,mx=0,media=0,costo=0,ppu=1;
   string unita="";
   Statistica("*", -1, MOT_SL, ENT_OUT, n, nSenza, med, p95, mx, media, costo, ppu, unita);
   if(n > 0)
      s += "uscite in STOP: n=" + IntegerToString(n) + "  mediana " + DoubleToString(med/ppu,3) +
           "  P95 " + DoubleToString(p95/ppu,3) + "  max " + DoubleToString(mx/ppu,3) + " (" + unita + ")\n";
   else
      s += "uscite in STOP: nessuna ancora (n=0). Il logger sta aspettando.\n";
   s += "registro: " + FileLedger() + "\n";
   Comment(s);
  }

//==========================================================================
//  CICLO DI VITA
//==========================================================================
int OnInit()
  {
   g_pronto = false;
   g_avvioIstanza = TimeCurrent();
   g_contoMio  = AccountInfoInteger(ACCOUNT_LOGIN);
   g_modoMio   = (int)AccountInfoInteger(ACCOUNT_TRADE_MODE);
   g_serverMio = AccountInfoString(ACCOUNT_SERVER);

   Print("[SLIPLOG] ", ABTG_SLIPLOG_MARCATORE);
   // NOTA per chi tocchera' queste righe: il testo NON nomina le funzioni
   // vietate (invio ordini, strutture di richiesta, variabili globali del
   // terminale). La riga di lancio conta quei token sul sorgente e pretende
   // ZERO: una stringa che li contenesse renderebbe il gate rosso per
   // sempre senza che il codice faccia niente di male (classe 126).
   Print("[SLIPLOG] SOLA LETTURA: nessun ordine, nessuna variabile globale del terminale, nessun file cancellato o spostato, nessun tocco al Market Watch. Scrive solo i propri file in MQL5\\Files.");
   PrintFormat("[SLIPLOG] conto %d @ %s   tipo %s   grafico ospite %s %s (il simbolo del grafico NON conta)",
               (int)g_contoMio, g_serverMio, NomeTipoConto(g_modoMio), _Symbol, EnumToString((ENUM_TIMEFRAMES)_Period));

   //--- 1. LA GUARDIA SUL CONTO. Qui sotto c'e' capitale vero e il
   //    numero che cerchiamo esiste SOLO su un conto reale: sbagliare
   //    terminale non fa danno ai soldi, ma produce un file di zeri che
   //    somiglia a una misura. Meglio non partire.
   if(InpLoginAtteso != 0 && g_contoMio != InpLoginAtteso)
     {
      PrintFormat("[SLIPLOG] NON PARTO: mi hai detto di girare sul conto %d e questo terminale e' il conto %d. Controlla su quale terminale hai trascinato l'EA.",
                  (int)InpLoginAtteso, (int)g_contoMio);
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpSoloContoReale && g_modoMio != (int)ACCOUNT_TRADE_MODE_REAL)
     {
      PrintFormat("[SLIPLOG] NON PARTO: hai chiesto SOLO conto REALE e questo e' un conto %s. Sul demo lo slippage non e' simulato: misurerebbe zero per costruzione.",
                  NomeTipoConto(g_modoMio));
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(g_modoMio != (int)ACCOUNT_TRADE_MODE_REAL)
     {
      g_avvisoConto = "CONTO " + NomeTipoConto(g_modoMio) + ": lo slippage NON e' simulato qui, questa raccolta serve solo a collaudare la macchina";
      Print("[SLIPLOG] ", g_avvisoConto);
     }
   if(InpLoginAtteso == 0)
      Print("[SLIPLOG] InpLoginAtteso e' 0: non ho nessun conto da confrontare, quindi girero' su qualunque terminale. Il numero di conto finisce comunque nel NOME dei file e in OGNI riga del registro.");

   //--- 2. i parametri
   if(!PrefissoValido(InpPrefissoFile))
     {
      Print("[SLIPLOG] NON PARTO: InpPrefissoFile deve cominciare per 'ABTG_Slippage' e non puo' contenere percorsi. Serve a non poter riscrivere il file di un altro artefatto.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpScanSec < 1 || InpSnapshotSec < 1)
     {
      Print("[SLIPLOG] NON PARTO: InpScanSec e InpSnapshotSec devono essere >= 1.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpSalvaSec < 10)
     {
      Print("[SLIPLOG] NON PARTO: InpSalvaSec deve essere >= 10 (riscrivere il referto piu' spesso e' solo I/O sprecato).");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpFinestraScanSec < 60)
     {
      Print("[SLIPLOG] NON PARTO: InpFinestraScanSec deve essere >= 60. Una finestra troppo corta lascerebbe scappare i deal quando il terminale rallenta.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpGiorniStorico < 0)
     {
      Print("[SLIPLOG] NON PARTO: InpGiorniStorico non puo' essere negativo.");
      return(INIT_PARAMETERS_INCORRECT);
     }

   //--- 3. autotest PRIMA di misurare
   if(InpAutoTest)
     {
      if(!AutoTest())
         Print("[SLIPLOG] *** ROSSO SLIPLOG *** l'autotest ha casi falliti: la misura NON e' affidabile. Stacca l'EA e segnala.");
     }
   else
      Print("[SLIPLOG] autotest DISATTIVATO da input: nessuna verifica a tavolino in questo avvio.");

   //--- 4. ripresa del registro
   LeggiLedger();

   //--- 5. prima foto delle posizioni gia' aperte, PRIMA di guardare lo
   //    storico: se una sedia ha gia' una posizione viva, il suo stop lo
   //    vogliamo in memoria da subito.
   FotografaPosizioni();

   //--- 6. recupero dello storico
   if(InpGiorniStorico > 0)
     {
      datetime da = (datetime)((long)TimeCurrent() - (long)InpGiorniStorico * 86400);
      Scansiona(da, "recupero all'avvio");
      PrintFormat("[SLIPLOG] recupero dello storico degli ultimi %d giorni: %d deal registrati in tutto finora.",
                  InpGiorniStorico, (int)g_dealNuovi);
     }

   //--- 7. timer al secondo: i passi veri sono contati qui dentro
   if(!EventSetTimer(1))
     {
      Print("[SLIPLOG] non riesco ad armare il timer: non parto.");
      return(INIT_FAILED);
     }
   g_ultimoScan = TimeCurrent();
   g_ultimoSnap = 0;
   g_ultimoSalv = TimeCurrent();
   g_pronto = true;
   SalvaTutto("avvio");

   PrintFormat("[SLIPLOG] avviato: scansione ogni %d s (finestra %d s), foto delle posizioni ogni %d s, referto ogni %d s, file '%s_*'",
               InpScanSec, InpFinestraScanSec, InpSnapshotSec, InpSalvaSec, Base());
   AggiornaComment();
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   if(g_pronto)
     {
      Scansiona((datetime)((long)TimeCurrent() - (long)InpFinestraScanSec), "chiusura");
      SalvaTutto("chiusura, motivo " + IntegerToString(reason));
      PrintFormat("[SLIPLOG] fermato (motivo %d): deal registrati %d, campioni %d, salvataggi %d. Il registro resta in %s: al riavvio riparte da li' e non riscrive niente due volte.",
                  reason, (int)g_dealNuovi, g_nCamp, (int)g_salvataggi, FileLedger());
     }
   Comment("");
  }

//+------------------------------------------------------------------+
//| OnTick ESISTE E NON FA NIENTE, apposta: tutto qui dentro e' a     |
//| tempo (timer), non a tick. Lasciarlo vuoto costa zero e tiene     |
//| l'artefatto un Expert a tutti gli effetti.                        |
//+------------------------------------------------------------------+
void OnTick()
  {
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!g_pronto) return;
   datetime ora = TimeCurrent();

   if(g_ultimoSnap == 0 || (long)(ora - g_ultimoSnap) >= (long)InpSnapshotSec)
     {
      FotografaPosizioni();
      g_ultimoSnap = ora;
     }
   if((long)(ora - g_ultimoScan) >= (long)InpScanSec)
     {
      Scansiona((datetime)((long)ora - (long)InpFinestraScanSec), "periodica");
      g_ultimoScan = ora;
      AggiornaComment();
     }
   if((long)(ora - g_ultimoSalv) >= (long)InpSalvaSec)
     {
      SalvaTutto("periodico");
      g_ultimoSalv = ora;
     }
  }
//+------------------------------------------------------------------+
