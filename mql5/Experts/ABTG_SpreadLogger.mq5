//+------------------------------------------------------------------+
//|                                        ABTG_SpreadLogger.mq5      |
//|                                                                   |
//|   IL LOGGER DELLO SPREAD VIVO -- EA DI SOLA LETTURA.              |
//|                                                                   |
//|   SCOPO: costruire la mappa VERA dello spread che paghiamo in     |
//|   campo, SIMBOLO PER SIMBOLO e ORA PER ORA (ora SERVER BCM),      |
//|   osservando il feed DAL VIVO su un terminale demo, e tenendo     |
//|   MEDIANA e P95 -- non la media, che nasconde le fiammate.        |
//|                                                                   |
//|   DA DOVE VIENE (attribuzione, regola di casa):                   |
//|   idea e struttura del campionamento vengono da "RealCost Spread  |
//|   P95 Logger MT5" di Song Bo Zhong (a1066832477), MQL5 Code Base  |
//|   codice 74148, pubblicato il 2026.06.20 -- promosso in casa il   |
//|   23/08/2026 (report/SWEEP_MECCANISMI_2026-08-23.md, voce T1) e   |
//|   rimasto mai usato fino ad oggi. L'originale campiona UN SOLO    |
//|   simbolo (quello del grafico), tiene fino a 20.000 campioni in   |
//|   memoria e stampa media/p50/p90/p95/p99/max in un pannello.      |
//|                                                                   |
//|   COSA CAMBIA QUI, e perche' e' una riscrittura e non una copia:  |
//|    1. MULTI-SIMBOLO in una sola istanza (InpSimboli): la flotta   |
//|       lavora su sette strumenti, e sette EA su sette grafici      |
//|       vorrebbero sette grafici NUOVI su un terminale che ne ha    |
//|       gia' cinquanta. Qui basta UN grafico nuovo.                 |
//|    2. ISTOGRAMMA PER FASCIA ORARIA (24 secchi per simbolo, ora    |
//|       SERVER) invece di un unico numero: la domanda di casa e'    |
//|       "quanto costa entrare ALLE 14:30", non "quanto costa in     |
//|       media". La misura del 03/09 sui tick storici                |
//|       (risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md)     |
//|       ha gia' mostrato che la differenza fra ore e' del DOPPIO    |
//|       (DAX notte 3,5-3,9 contro 1,6-1,7 in sessione).             |
//|    3. ISTOGRAMMA invece di array di campioni: l'originale tiene   |
//|       20.000 campioni e poi comincia a buttare i piu' vecchi.     |
//|       Una raccolta di una settimana a 5 secondi fa ~120.000       |
//|       campioni PER SIMBOLO: con l'array si perderebbero i primi   |
//|       giorni SENZA DIRLO. L'istogramma non dimentica niente e     |
//|       costa memoria fissa.                                        |
//|    4. STATO SU FILE, RIPRESO ALL'AVVIO: il terminale del VPS si   |
//|       riavvia, il fine settimana chiude, un profilo si ricarica.  |
//|       Senza ripresa, ogni riavvio azzererebbe la raccolta e il    |
//|       referto sembrerebbe sano (classe 106: l'artefatto che si    |
//|       svuota letto come registro cumulativo). Qui lo stato si     |
//|       scrive ogni InpSalvaSec e si RILEGGE in OnInit.             |
//|    5. NIENTE ALLARMI, NIENTE NOTIFICHE PUSH, NIENTE PANNELLO A    |
//|       OGGETTI: sul terminale del forward non si aggiunge rumore   |
//|       ne' traffico. Solo un Comment() sul grafico e i file.       |
//|                                                                   |
//|   IL VINCOLO -- NON NEGOZIABILE, ed e' la ragione per cui questo  |
//|   artefatto puo' girare su un terminale che opera:                |
//|    1. MAI UN ORDINE. Nessun include della libreria di trading,    |
//|       nessuna classe di trading, nessuna chiamata di invio /      |
//|       modifica / chiusura. Non e' una promessa: e' che quelle     |
//|       chiamate QUI NON CI SONO, e la riga di lancio lo VERIFICA   |
//|       sul sorgente prima di installarlo (censimento per token     |
//|       sulle righe di codice, commenti tolti).                     |
//|    2. MAI UNA GlobalVariable, ne' letta ne' scritta. Il Guardian  |
//|       e gli EA vivi si parlano con quelle: qui non se ne tocca    |
//|       nessuna, quindi non c'e' modo di interferire.               |
//|    3. SCRIVE SOLO I PROPRI TRE FILE in MQL5\Files, tutti col      |
//|       prefisso InpPrefissoFile. Nessun .set, nessun .chr,         |
//|       nessun file di altri.                                       |
//|    4. LE SUE RIGHE DI LOG COMINCIANO TUTTE CON "[SPREADLOG]" e    |
//|       non contengono nessuna delle stringhe che fanno fede per    |
//|       altri collaudi (classe 107: lo strumento di misura che      |
//|       scrive nello stesso log del misurato). In particolare il    |
//|       fallimento del proprio autotest si chiama                   |
//|       "*** ROSSO SPREADLOG ***" e NON "*** FAIL ***", che e' una  |
//|       riga VIETATA del collaudo enforcement Fase 1                |
//|       (backtest_pipeline/attese_enforcement_fase1.txt, STOP.      |
//|       AUTOTEST): un rosso di QUESTO artefatto non deve poter      |
//|       fermare il collaudo di un ALTRO.                            |
//|    5. NON SERVE IL TRADING ALGORITMICO ATTIVO: il timer gira lo   |
//|       stesso. Se la spunta e' spenta, il logger misura comunque.  |
//|                                                                   |
//|   COME SI USA (e la sola cosa che puo' fare danno e' sbagliare    |
//|   questo passo): si apre un grafico NUOVO (File > Nuovo grafico), |
//|   e si trascina l'EA LI' SOPRA. Trascinarlo su un grafico che ha  |
//|   gia' un EA SOSTITUISCE quell'EA: un grafico ha UN SOLO EA. Su   |
//|   un grafico nuovo non c'e' niente da sostituire.                 |
//|   Il simbolo e il timeframe del grafico NON contano: i simboli    |
//|   misurati sono quelli di InpSimboli, letti con SymbolInfoTick.   |
//|                                                                   |
//|   COSA MISURA, DETTO CON PRECISIONE (e cosa NON misura):          |
//|    - campiona a intervallo FISSO (InpCampionaSec), quindi la      |
//|      distribuzione e' PESATA SUL TEMPO: risponde a "se entro in   |
//|      un istante a caso di quell'ora, che spread trovo?". NON e'   |
//|      pesata sui tick (che darebbe piu' peso ai momenti agitati)   |
//|      e NON e' lo spread al momento dei nostri ingressi.           |
//|    - i campioni consecutivi sono AUTOCORRELATI: 3.600 campioni in |
//|      un'ora non sono 3.600 osservazioni indipendenti. Il numero   |
//|      che conta per la robustezza e' quante GIORNATE distinte      |
//|      sono entrate in quel secchio: il referto lo stampa.          |
//|    - NON misura lo SLIPPAGE. Lo slippage sta nella differenza fra |
//|      prezzo richiesto e prezzo eseguito, e si legge dallo storico |
//|      dei deal: e' l'altro attrezzo del 23/08 (T2, Round Trip Cost |
//|      Reconciler, codice 76117), non questo.                       |
//|    - NON misura la COMMISSIONE ne' lo SWAP.                       |
//|    - broker singolo (BCM) e conto singolo: e' lo spread di QUEL   |
//|      feed su QUEL terminale.                                      |
//|                                                                   |
//|   ORE: tutte le fasce sono in ORA SERVER (TimeCurrent), che nel   |
//|   periodo attuale e' l'ora italiana MENO UNA. Le schede           |
//|   Esperti/Giornale invece sono in ora locale del PC: le due ore   |
//|   non coincidono, ed e' regola di casa dirlo ogni volta.          |
//+------------------------------------------------------------------+
#property version   "1.00"
#property strict
#property description "ABTG_SpreadLogger -- logger di SOLA LETTURA dello spread vivo, per simbolo e per ora server. Non apre, non modifica e non chiude nessuna posizione."

//--- marcatore di versione: lo cerca la riga di lancio prima di installare,
//    e lo si legge nella scheda Esperti per sapere quale build sta girando.
#define ABTG_SPREADLOG_MARCATORE "ABTG_SpreadLogger v1.00 - logger di SOLA LETTURA, spread P95 per ora server"

//--- numeri dell'autotest, dichiarati come #define perche' la riga di
//    lancio li legge dal SORGENTE e li confronta con quelli che si
//    aspetta: se il file al pin non e' quello che credo, non si installa.
#define ABTG_SPREADLOG_AUTOTEST_BLOCCHI_ATTESI 8
#define ABTG_SPREADLOG_AUTOTEST_CASI_ATTESI    36

//--- geometria degli istogrammi -------------------------------------------
//  MAXBIN: un secchio per ogni PUNTO MT5 di spread, da 0 a MAXBIN-1.
//  10.001 punti sono 100 punti indice (indici a 2 decimali) o 1.000 pip
//  (forex a 5 decimali): oltre si conta in OVERFLOW e il massimo VERO si
//  tiene comunque a parte, esatto. Memoria: 7 simboli x 24 ore x 10.001
//  secchi x 8 byte = ~13,4 MB, fissi, che e' il prezzo per NON buttare
//  via nessun campione (l'originale ne teneva 20.000 e poi dimenticava).
#define MAXBIN  10001
#define NORE    24
//  Tetto ai simboli: e' un tetto di MEMORIA dichiarato, non un capriccio.
//  Con 12 simboli si arriva a ~23 MB.
#define MAXSYM  12

//==================== INPUT ================================================
input string InpSimboli            = "D30EUR,U30USD,NASUSD,225JPY,EURUSD,GBPUSD,USDJPY"; // simboli BCM, separati da virgola
input int    InpCampionaSec        = 5;      // ogni quanti secondi si campiona lo spread
input int    InpSalvaSec           = 300;    // ogni quanti secondi si scrivono stato + referto
input int    InpFrescoSec          = 90;     // tick piu' vecchio di cosi' = mercato fermo, campione SCARTATO
input bool   InpAggiungiMarketWatch= true;   // aggiunge i simboli a Market Watch se mancano (unica scrittura fuori dai file)
input bool   InpRiprendiStato      = true;   // all'avvio riprende lo stato accumulato dal file (riavvii, fine settimana)
input string InpPrefissoFile       = "ABTG_SpreadLogger"; // prefisso dei 3 file in MQL5\Files
input bool   InpMostraComment      = true;   // scrive lo stato nel Comment del grafico
input bool   InpLogOgniSalvataggio = false;  // una riga in Esperti a ogni salvataggio (default OFF: niente rumore)
input bool   InpAutoTest           = true;   // autotest a tavolino in OnInit

//==================== STATO ================================================
string   g_sym[];        // simboli richiesti (ripuliti)
int      g_nSym       = 0;
int      g_digits[];     // decimali del simbolo
double   g_point[];      // valore di un punto MT5
double   g_ppu[];        // punti MT5 per UNITA' PRATICA (pip nel forex, punto indice negli indici)
string   g_unita[];      // nome dell'unita' pratica, per il referto
bool     g_vivo[];       // simbolo selezionabile: se false, campioni 0 e il referto lo dice

long     g_bin[];        // istogramma appiattito: [(i*NORE + h)*MAXBIN + b]
long     g_n[];          // campioni VALIDI          [i*NORE + h]
long     g_scart[];      // campioni scartati        [i*NORE + h]
long     g_over[];       // campioni oltre MAXBIN    [i*NORE + h]
long     g_max[];        // massimo VERO in punti    [i*NORE + h]
double   g_somma[];      // somma dei punti (per la media) [i*NORE + h]
long     g_giorni[];     // giornate distinte viste  [i*NORE + h]
int      g_ultimaData[]; // aaaammgg dell'ultimo campione [i*NORE + h]
long     g_daInteger[];  // campioni presi dal ripiego SYMBOL_SPREAD [i*NORE + h]

datetime g_primo      = 0;      // primo campione mai raccolto (anche prima del riavvio)
datetime g_ultimo     = 0;      // ultimo campione raccolto
datetime g_avvioIstanza = 0;    // avvio di QUESTA istanza
long     g_salvataggi = 0;
long     g_totCampioni= 0;
long     g_totScartati= 0;
int      g_riprese    = 0;      // quante volte lo stato e' stato ripreso da file
string   g_statoLetto = "NON LETTO";
datetime g_ultimoCamp = 0;      // orologio interno: ultimo campionamento
datetime g_ultimoSalv = 0;      // orologio interno: ultimo salvataggio
bool     g_pronto     = false;  // false = OnInit non e' arrivato in fondo: il timer non fa niente
int      g_autoFalliti= 0;

//+------------------------------------------------------------------+
//| PUNTI MT5 PER UNITA' PRATICA -- la conversione, in un posto solo. |
//|                                                                   |
//| Il numero GREZZO che misuriamo e' sempre in PUNTI MT5, e nei file |
//| c'e' sempre quello: la conversione e' un COMODO per leggere, mai  |
//| il dato. Regola, dai decimali del simbolo:                        |
//|   5 o 3 decimali (forex) -> 10 punti = 1 pip                      |
//|   2 decimali (indici BCM) -> 100 punti = 1 punto indice           |
//|   1 decimale              -> 10 punti = 1 unita' di prezzo        |
//|   0 decimali              -> 1 punto  = 1 unita' di prezzo        |
//| Con questa regola D30EUR/U30USD/NASUSD/225JPY (2 decimali) danno  |
//| 100, che e' la conversione MISURATA in R97 e riusata da           |
//| ABTG_SpreadOrario.mq5.                                            |
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
//| Indice piatto della coppia (simbolo, ora)                        |
//+------------------------------------------------------------------+
int Idx(const int i, const int h) { return i*NORE + h; }

//+------------------------------------------------------------------+
//| PERCENTILE dall'istogramma di (simbolo i, ora h).                |
//| Il totale usato e' g_n, che comprende ANCHE i campioni finiti in |
//| overflow: cosi' se il percentile cade nella coda oltre il tetto  |
//| esce 'inOverflow=true' invece di un numero comodo e falso.       |
//| Ritorna il secchio (= punti MT5), oppure -1 se non c'e' niente.  |
//+------------------------------------------------------------------+
long PercentileBin(const int i, const int h, const double frac, bool &inOverflow)
  {
   inOverflow = false;
   long totale = g_n[Idx(i,h)];
   if(totale <= 0) return -1;
   double soglia = frac * (double)totale;
   long cum = 0;
   int base = Idx(i,h) * MAXBIN;
   for(int b=0; b<MAXBIN; b++)
     {
      cum += g_bin[base + b];
      if((double)cum >= soglia) return (long)b;
     }
   inOverflow = true;   // la soglia cade fra i campioni oltre il tetto
   return (long)MAXBIN;
  }

//+------------------------------------------------------------------+
//| PERCENTILE su una FASCIA di ore (h1..h2 compresi): gli istogrammi |
//| si SOMMANO e poi si prende il percentile. NON si fa la media dei  |
//| percentili delle singole ore -- sarebbe un numero che non         |
//| corrisponde a nessuna distribuzione.                              |
//+------------------------------------------------------------------+
long PercentileFascia(const int i, const int h1, const int h2, const double frac, bool &inOverflow, long &totaleFuori)
  {
   inOverflow = false;
   long totale = 0;
   for(int h=h1; h<=h2; h++) totale += g_n[Idx(i,h)];
   totaleFuori = totale;
   if(totale <= 0) return -1;
   double soglia = frac * (double)totale;
   long cum = 0;
   for(int b=0; b<MAXBIN; b++)
     {
      for(int h=h1; h<=h2; h++) cum += g_bin[Idx(i,h)*MAXBIN + b];
      if((double)cum >= soglia) return (long)b;
     }
   inOverflow = true;
   return (long)MAXBIN;
  }

//+------------------------------------------------------------------+
//| Formattazioni                                                    |
//+------------------------------------------------------------------+
string Pad(string s, const int larg)
  {
   while(StringLen(s) < larg) s = " " + s;
   return s;
  }
string ValoreBin(const bool over, const long bin, const double ppu, const int dec)
  {
   if(bin < 0) return "n/d";
   if(over)    return ">" + IntegerToString(MAXBIN-1);
   return DoubleToString((double)bin/ppu, dec);
  }

//+------------------------------------------------------------------+
//| LISTA DEI SIMBOLI: spezza, ripulisce, scarta i vuoti.            |
//| Ritorna quanti ne ha messi in 'fuori'.                           |
//+------------------------------------------------------------------+
int SpezzaSimboli(const string lista, string &fuori[])
  {
   string parti[];
   int n = StringSplit(lista, ',', parti);
   ArrayResize(fuori, 0);
   int quanti = 0;
   for(int k=0; k<n; k++)
     {
      string s = parti[k];
      StringTrimLeft(s);
      StringTrimRight(s);
      if(s == "") continue;
      if(quanti >= MAXSYM) break;
      ArrayResize(fuori, quanti+1);
      fuori[quanti] = s;
      quanti++;
     }
   return quanti;
  }

//+------------------------------------------------------------------+
//| aaaammgg di un istante (ora SERVER)                              |
//+------------------------------------------------------------------+
int DataInt(const datetime t)
  {
   MqlDateTime dt;
   TimeToStruct(t, dt);
   return dt.year*10000 + dt.mon*100 + dt.day;
  }

//+------------------------------------------------------------------+
//| Trova l'indice di un simbolo nella lista in memoria, -1 se manca. |
//+------------------------------------------------------------------+
int TrovaSimbolo(const string s)
  {
   for(int i=0; i<g_nSym; i++) if(g_sym[i] == s) return i;
   return -1;
  }

//==========================================================================
//  AUTOTEST A TAVOLINO
//  Gira in OnInit e non tocca niente di vivo: prepara dati finti, chiama
//  le funzioni VERE (quelle che usa la produzione, non delle copie -- e'
//  la classe 109) e confronta col risultato atteso.
//  Il fallimento si chiama "*** ROSSO SPREADLOG ***": vedi il punto 4 del
//  vincolo in testa al file.
//==========================================================================
int g_casiFatti = 0;
int g_casiRossi = 0;

void Caso(const string nome, const bool ok)
  {
   g_casiFatti++;
   if(!ok)
     {
      g_casiRossi++;
      Print("[SPREADLOG] *** ROSSO SPREADLOG *** caso fallito: ", nome);
     }
  }

bool AutoTest()
  {
   g_casiFatti = 0;
   g_casiRossi = 0;
   int blocchi = 0;

   //--- BLOCCO 1: conversione punti -> unita' pratica -----------------
   blocchi++;
   Caso("ppu 5 decimali = 10 (pip)",      PuntiPerUnita(5) == 10.0);
   Caso("ppu 3 decimali = 10 (pip JPY)",  PuntiPerUnita(3) == 10.0);
   Caso("ppu 2 decimali = 100 (indici)",  PuntiPerUnita(2) == 100.0);
   Caso("ppu 1 decimale = 10",            PuntiPerUnita(1) == 10.0);
   Caso("ppu 0 decimali = 1",             PuntiPerUnita(0) == 1.0);
   Caso("nome unita' forex = pip",        NomeUnita(5) == "pip");
   Caso("nome unita' indici = punti indice", NomeUnita(2) == "punti indice");

   //--- BLOCCO 2: lista dei simboli ------------------------------------
   blocchi++;
     {
      string f[];
      int n = SpezzaSimboli(" D30EUR , EURUSD ,, GBPUSD ", f);
      Caso("lista: 3 simboli sui 4 pezzi (uno vuoto scartato)", n == 3);
      Caso("lista: spazi tolti a sinistra e a destra", n == 3 && f[0] == "D30EUR" && f[1] == "EURUSD" && f[2] == "GBPUSD");
      int nz = SpezzaSimboli("   ", f);
      Caso("lista vuota = 0 simboli", nz == 0);
     }

   //--- BLOCCO 3: indice piatto ----------------------------------------
   blocchi++;
   Caso("Idx(0,0) = 0",   Idx(0,0) == 0);
   Caso("Idx(0,23) = 23", Idx(0,23) == 23);
   Caso("Idx(1,0) = 24",  Idx(1,0) == NORE);
   Caso("Idx(2,5) = 53",  Idx(2,5) == 2*NORE+5);

   //--- BLOCCO 4: percentile su un istogramma noto ----------------------
   //  Si prepara lo spazio per 1 simbolo, si riempie l'ora 8 con
   //  50 campioni a 1 punto, 30 a 2 punti, 20 a 3 punti (totale 100).
   //  Mediana attesa = 1 (il 50esimo campione sta ancora nel primo
   //  secchio), P95 attesa = 3, P90 attesa = 3 (cum a 2 = 80 < 90).
   blocchi++;
     {
      int nSalva = g_nSym;
      g_nSym = 1;
      Alloca();
      int base = Idx(0,8)*MAXBIN;
      g_bin[base + 1] = 50;
      g_bin[base + 2] = 30;
      g_bin[base + 3] = 20;
      g_n[Idx(0,8)]   = 100;
      bool ov = false;
      Caso("mediana = 1",  PercentileBin(0,8,0.50,ov) == 1 && !ov);
      Caso("P90 = 3",      PercentileBin(0,8,0.90,ov) == 3 && !ov);
      Caso("P95 = 3",      PercentileBin(0,8,0.95,ov) == 3 && !ov);
      Caso("ora vuota = -1", PercentileBin(0,9,0.50,ov) == -1);

      //--- BLOCCO 5: overflow -- il percentile che cade oltre il tetto
      //    NON deve tornare un numero comodo: deve dichiararsi.
      blocchi++;
      g_over[Idx(0,8)] = 10;
      g_n[Idx(0,8)]    = 110;   // 100 nei secchi + 10 oltre il tetto
      bool ov2 = false;
      long p99 = PercentileBin(0,8,0.99,ov2);
      Caso("P99 con 10/110 in overflow: dichiarato oltre il tetto", ov2 == true && p99 == MAXBIN);
      // con 110 nel totale la soglia della mediana e' 55: il 55esimo campione
      // sta nel secchio 2 (cum 50 -> 80). L'overflow SPOSTA la mediana, ed e'
      // giusto cosi': quei 10 campioni sono spread veri, solo fuori dal tetto.
      Caso("mediana con overflow: 2 (i campioni oltre il tetto contano)", PercentileBin(0,8,0.50,ov2) == 2 && !ov2);
      Caso("stampa dell'overflow non e' un numero", ValoreBin(true, MAXBIN, 100.0, 3) == ">" + IntegerToString(MAXBIN-1));

      //--- BLOCCO 6: fascia oraria -- gli istogrammi si SOMMANO
      blocchi++;
      g_bin[Idx(0,8)*MAXBIN + 1] = 50; g_bin[Idx(0,8)*MAXBIN + 2] = 30; g_bin[Idx(0,8)*MAXBIN + 3] = 20;
      g_over[Idx(0,8)] = 0;  g_n[Idx(0,8)] = 100;
      g_bin[Idx(0,9)*MAXBIN + 9] = 100;
      g_n[Idx(0,9)] = 100;
      bool ov3 = false;
      long tot = 0;
      long medF = PercentileFascia(0,8,9,0.50,ov3,tot);
      Caso("fascia 8-9: totale 200", tot == 200);
      // soglia 100: cum 50 (b=1) -> 80 (b=2) -> 100 (b=3). Mediana = 3.
      Caso("fascia 8-9: mediana = 3 (somma degli istogrammi, non media dei percentili)", medF == 3 && !ov3);
      long p95F = PercentileFascia(0,8,9,0.95,ov3,tot);
      Caso("fascia 8-9: P95 = 9", p95F == 9 && !ov3);
      long vuota = PercentileFascia(0,20,22,0.50,ov3,tot);
      Caso("fascia senza campioni = -1", vuota == -1 && tot == 0);

      //--- BLOCCO 7: giro completo di una riga di stato (scrivi->leggi)
      blocchi++;
      string riga = RigaBin("D30EUR", 8, 170, 354);
      string pezzi[];
      int np = StringSplit(riga, ',', pezzi);
      Caso("riga BIN: 5 campi", np == 5);
      Caso("riga BIN: etichetta", np == 5 && pezzi[0] == "BIN");
      Caso("riga BIN: simbolo",   np == 5 && pezzi[1] == "D30EUR");
      Caso("riga BIN: ora",       np == 5 && (int)StringToInteger(pezzi[2]) == 8);
      Caso("riga BIN: secchio",   np == 5 && (long)StringToInteger(pezzi[3]) == 170);
      Caso("riga BIN: conteggio", np == 5 && (long)StringToInteger(pezzi[4]) == 354);

      //--- BLOCCO 8: spread in punti da bid/ask, e il campione morto
      blocchi++;
      Caso("17 punti da 0.00017 con point 0.00001", PuntiDaPrezzo(0.00017, 0.00001) == 17);
      Caso("170 punti da 1.70 con point 0.01",      PuntiDaPrezzo(1.70, 0.01) == 170);
      Caso("arrotondamento a 2 punti da 0.000015",  PuntiDaPrezzo(0.000015, 0.00001) == 2);
      Caso("spread negativo diventa 0",             PuntiDaPrezzo(-0.00003, 0.00001) == 0);
      Caso("point 0 non fa esplodere niente",       PuntiDaPrezzo(0.0001, 0.0) == -1);

      //--- si rimette lo spazio come lo vuole la produzione
      g_nSym = nSalva;
      Alloca();
     }

   int attesiBlocchi = ABTG_SPREADLOG_AUTOTEST_BLOCCHI_ATTESI;
   int attesiCasi    = ABTG_SPREADLOG_AUTOTEST_CASI_ATTESI;
   g_autoFalliti = g_casiRossi;
   PrintFormat("[SPREADLOG] AUTOTEST: %d blocchi su %d dichiarati, %d casi su %d dichiarati, %d falliti.",
               blocchi, attesiBlocchi, g_casiFatti, attesiCasi, g_casiRossi);
   if(blocchi != attesiBlocchi || g_casiFatti != attesiCasi)
      Print("[SPREADLOG] ATTENZIONE: i conteggi dell'autotest non coincidono con i #define dichiarati nel sorgente. Non e' un guasto della misura, ma il sorgente e la riga di lancio non si raccontano la stessa cosa: va sistemato prima del prossimo pin.");
   return (g_casiRossi == 0);
  }

//+------------------------------------------------------------------+
//| Spread in PUNTI MT5 da una differenza di prezzo.                 |
//| -1 = non calcolabile (point non valido). Negativo -> 0: un ask   |
//| sotto il bid e' un tick sporco, non uno spread negativo.         |
//+------------------------------------------------------------------+
long PuntiDaPrezzo(const double diffPrezzo, const double point)
  {
   if(point <= 0.0) return -1;
   double p = diffPrezzo / point;
   long pts = (long)MathRound(p);
   if(pts < 0) pts = 0;
   return pts;
  }

//+------------------------------------------------------------------+
//| Riga BIN dello stato (una sola forma, usata da scrittura e test) |
//+------------------------------------------------------------------+
string RigaBin(const string sym, const int ora, const long bin, const long conteggio)
  {
   return "BIN," + sym + "," + IntegerToString(ora) + "," + IntegerToString(bin) + "," + IntegerToString(conteggio);
  }

//+------------------------------------------------------------------+
//| ALLOCA / AZZERA tutte le strutture per g_nSym simboli            |
//+------------------------------------------------------------------+
void Alloca()
  {
   int celle = g_nSym * NORE;
   ArrayResize(g_bin, celle * MAXBIN);
   ArrayInitialize(g_bin, 0);
   ArrayResize(g_n, celle);          ArrayInitialize(g_n, 0);
   ArrayResize(g_scart, celle);      ArrayInitialize(g_scart, 0);
   ArrayResize(g_over, celle);       ArrayInitialize(g_over, 0);
   ArrayResize(g_max, celle);        ArrayInitialize(g_max, 0);
   ArrayResize(g_somma, celle);      ArrayInitialize(g_somma, 0.0);
   ArrayResize(g_giorni, celle);     ArrayInitialize(g_giorni, 0);
   ArrayResize(g_ultimaData, celle); ArrayInitialize(g_ultimaData, 0);
   ArrayResize(g_daInteger, celle);  ArrayInitialize(g_daInteger, 0);
  }

//==========================================================================
//  STATO SU FILE
//==========================================================================
string FileStato()   { return InpPrefissoFile + "_stato.csv"; }
string FileStatoTmp(){ return InpPrefissoFile + "_stato.tmp"; }
string FileOrario()  { return InpPrefissoFile + "_orario.csv"; }
string FileReferto() { return InpPrefissoFile + "_REFERTO.txt"; }

//+------------------------------------------------------------------+
//| SCRIVE LO STATO. Prima su .tmp, poi rinomina: se il terminale    |
//| muore a meta' scrittura, il file buono di 5 minuti fa e' ancora  |
//| li'. Un file di stato troncato equivale a una raccolta persa.    |
//+------------------------------------------------------------------+
bool SalvaStato()
  {
   int fh = FileOpen(FileStatoTmp(), FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(fh == INVALID_HANDLE)
     {
      PrintFormat("[SPREADLOG] ATTENZIONE: non riesco a scrivere %s (errore %d). Lo stato di questo giro resta solo in memoria.", FileStatoTmp(), GetLastError());
      return false;
     }
   FileWriteString(fh, "# ABTG_SpreadLogger stato v1 -- accumulatore. Ore in ORA SERVER. Spread in PUNTI MT5.\r\n");
   FileWriteString(fh, "META,versione,1\r\n");
   FileWriteString(fh, "META,marcatore," + ABTG_SPREADLOG_MARCATORE + "\r\n");
   FileWriteString(fh, "META,primo_campione," + TimeToString(g_primo, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "META,ultimo_campione," + TimeToString(g_ultimo, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "META,scritto_il," + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "META,conto," + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + "\r\n");
   FileWriteString(fh, "META,server," + AccountInfoString(ACCOUNT_SERVER) + "\r\n");
   FileWriteString(fh, "META,salvataggi," + IntegerToString(g_salvataggi) + "\r\n");
   FileWriteString(fh, "META,riprese," + IntegerToString(g_riprese) + "\r\n");
   FileWriteString(fh, "META,campiona_sec," + IntegerToString(InpCampionaSec) + "\r\n");
   for(int i=0; i<g_nSym; i++)
     {
      FileWriteString(fh, "SYM," + g_sym[i] + "," + IntegerToString(g_digits[i]) + "," +
                          DoubleToString(g_point[i], 8) + "," + DoubleToString(g_ppu[i], 1) + "," +
                          (g_vivo[i] ? "vivo" : "NON_SELEZIONABILE") + "\r\n");
      for(int h=0; h<NORE; h++)
        {
         int c = Idx(i,h);
         if(g_n[c] == 0 && g_scart[c] == 0) continue;
         FileWriteString(fh, "ORA," + g_sym[i] + "," + IntegerToString(h) + "," +
                             IntegerToString(g_n[c]) + "," + IntegerToString(g_scart[c]) + "," +
                             IntegerToString(g_over[c]) + "," + IntegerToString(g_max[c]) + "," +
                             DoubleToString(g_somma[c], 1) + "," + IntegerToString(g_giorni[c]) + "," +
                             IntegerToString(g_ultimaData[c]) + "," + IntegerToString(g_daInteger[c]) + "\r\n");
         int base = c * MAXBIN;
         for(int b=0; b<MAXBIN; b++)
            if(g_bin[base+b] > 0) FileWriteString(fh, RigaBin(g_sym[i], h, b, g_bin[base+b]) + "\r\n");
        }
     }
   FileWriteString(fh, "FINE\r\n");
   FileClose(fh);

   //--- rinomina atomica per quanto MQL5 lo consente
   if(FileIsExist(FileStato())) FileDelete(FileStato());
   if(!FileMove(FileStatoTmp(), 0, FileStato(), FILE_REWRITE))
     {
      PrintFormat("[SPREADLOG] ATTENZIONE: stato scritto in %s ma non rinominato in %s (errore %d). Il file buono e' il .tmp.",
                  FileStatoTmp(), FileStato(), GetLastError());
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| RILEGGE LO STATO. Le righe di simboli che non sono piu' nella    |
//| lista si SALTANO e si contano: non si buttano in silenzio.       |
//+------------------------------------------------------------------+
void LeggiStato()
  {
   string nome = FileStato();
   if(!FileIsExist(nome))
     {
      //--- il .tmp sopravvissuto e' meglio di niente: lo si dichiara.
      if(FileIsExist(FileStatoTmp()))
        {
         g_statoLetto = "NESSUN " + nome + ", ma c'e' un " + FileStatoTmp() + " di un salvataggio interrotto: NON e' stato usato (va guardato a mano).";
         Print("[SPREADLOG] ", g_statoLetto);
        }
      else
         g_statoLetto = "nessuno stato precedente: raccolta NUOVA da zero";
      return;
     }
   int fh = FileOpen(nome, FILE_READ|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE)
     {
      g_statoLetto = "stato PRESENTE ma NON LEGGIBILE (errore " + IntegerToString(GetLastError()) + "): riparto da zero, e il vecchio file NON viene toccato finche' non lo guardi";
      Print("[SPREADLOG] ATTENZIONE: ", g_statoLetto);
      return;
     }
   long righeBin = 0, righeOra = 0, saltate = 0;
   bool fine = false;
   while(!FileIsEnding(fh))
     {
      string riga = FileReadString(fh);
      StringTrimRight(riga);   // toglie l'eventuale \r di coda: senza, l'ultimo campo della riga se lo porta dentro
      if(StringLen(riga) == 0) continue;
      if(StringGetCharacter(riga, 0) == '#') continue;
      string p[];
      int np = StringSplit(riga, ',', p);
      if(np <= 0) continue;
      if(p[0] == "FINE") { fine = true; continue; }
      if(p[0] == "META" && np >= 3)
        {
         if(p[1] == "primo_campione")  { datetime d = StringToTime(p[2]); if(d > 0) g_primo = d; }
         if(p[1] == "ultimo_campione") { datetime d2 = StringToTime(p[2]); if(d2 > 0) g_ultimo = d2; }
         if(p[1] == "salvataggi")      g_salvataggi = (long)StringToInteger(p[2]);
         if(p[1] == "riprese")         g_riprese    = (int)StringToInteger(p[2]);
         continue;
        }
      if(p[0] == "ORA" && np >= 11)
        {
         int i = TrovaSimbolo(p[1]);
         if(i < 0) { saltate++; continue; }
         int h = (int)StringToInteger(p[2]);
         if(h < 0 || h >= NORE) { saltate++; continue; }
         int c = Idx(i,h);
         g_n[c]          += (long)StringToInteger(p[3]);
         g_scart[c]      += (long)StringToInteger(p[4]);
         g_over[c]       += (long)StringToInteger(p[5]);
         long mx          = (long)StringToInteger(p[6]);
         if(mx > g_max[c]) g_max[c] = mx;
         g_somma[c]      += StringToDouble(p[7]);
         g_giorni[c]     += (long)StringToInteger(p[8]);
         g_ultimaData[c]  = (int)StringToInteger(p[9]);
         g_daInteger[c]  += (long)StringToInteger(p[10]);
         righeOra++;
         continue;
        }
      if(p[0] == "BIN" && np >= 5)
        {
         int i = TrovaSimbolo(p[1]);
         if(i < 0) { saltate++; continue; }
         int h = (int)StringToInteger(p[2]);
         int b = (int)StringToInteger(p[3]);
         if(h < 0 || h >= NORE || b < 0 || b >= MAXBIN) { saltate++; continue; }
         g_bin[Idx(i,h)*MAXBIN + b] += (long)StringToInteger(p[4]);
         righeBin++;
         continue;
        }
      saltate++;
     }
   FileClose(fh);
   g_riprese++;
   //--- totali coerenti col ripreso
   g_totCampioni = 0; g_totScartati = 0;
   for(int c2=0; c2<ArraySize(g_n); c2++) { g_totCampioni += g_n[c2]; g_totScartati += g_scart[c2]; }
   g_statoLetto = "RIPRESO da " + nome + ": " + IntegerToString(righeOra) + " righe ORA, " +
                  IntegerToString(righeBin) + " righe BIN, " + IntegerToString(saltate) + " righe saltate" +
                  (fine ? ", chiuso bene" : ", SENZA la riga FINE (il file precedente era troncato: la parte letta e' comunque valida, quella mancante e' persa)");
   Print("[SPREADLOG] ", g_statoLetto);
  }

//==========================================================================
//  CSV ORARIO + REFERTO LEGGIBILE
//==========================================================================
void ScriviOrario()
  {
   int fh = FileOpen(FileOrario(), FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ',');
   if(fh == INVALID_HANDLE) return;
   FileWrite(fh, "simbolo","ora_server","campioni","giornate","scartati","overflow",
                 "mediana_punti","p95_punti","p99_punti","media_punti","max_punti",
                 "mediana_unita","p95_unita","max_unita","unita","punti_per_unita","da_symbol_spread");
   for(int i=0; i<g_nSym; i++)
      for(int h=0; h<NORE; h++)
        {
         int c = Idx(i,h);
         if(g_n[c] == 0 && g_scart[c] == 0) continue;
         bool o1=false,o2=false,o3=false;
         long med = PercentileBin(i,h,0.50,o1);
         long p95 = PercentileBin(i,h,0.95,o2);
         long p99 = PercentileBin(i,h,0.99,o3);
         string media = "n/d";
         if(g_n[c] > 0) media = DoubleToString(g_somma[c]/(double)g_n[c], 2);
         FileWrite(fh, g_sym[i], IntegerToString(h),
                       IntegerToString(g_n[c]), IntegerToString(g_giorni[c]),
                       IntegerToString(g_scart[c]), IntegerToString(g_over[c]),
                       ValoreBin(o1, med, 1.0, 0), ValoreBin(o2, p95, 1.0, 0), ValoreBin(o3, p99, 1.0, 0),
                       media, IntegerToString(g_max[c]),
                       ValoreBin(o1, med, g_ppu[i], 3), ValoreBin(o2, p95, g_ppu[i], 3),
                       DoubleToString((double)g_max[c]/g_ppu[i], 3),
                       g_unita[i], DoubleToString(g_ppu[i],0), IntegerToString(g_daInteger[c]));
        }
   FileClose(fh);
  }

void ScriviReferto()
  {
   int fh = FileOpen(FileReferto(), FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE) return;
   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "  SPREAD VIVO PER FASCIA ORARIA -- " + ABTG_SPREADLOG_MARCATORE + "\r\n");
   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "conto              : " + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + " @ " + AccountInfoString(ACCOUNT_SERVER) + "\r\n");
   FileWriteString(fh, "scritto il (server): " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "avvio di QUESTA istanza (server): " + TimeToString(g_avvioIstanza, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "primo campione     : " + TimeToString(g_primo, TIME_DATE|TIME_SECONDS) + "   (anche di raccolte precedenti, se lo stato e' stato ripreso)\r\n");
   FileWriteString(fh, "ultimo campione    : " + TimeToString(g_ultimo, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(fh, "campioni validi    : " + IntegerToString(g_totCampioni) + "   scartati (mercato fermo / tick vecchio): " + IntegerToString(g_totScartati) + "\r\n");
   FileWriteString(fh, "passo campione     : " + IntegerToString(InpCampionaSec) + " s   salvataggi: " + IntegerToString(g_salvataggi) + "   riprese dello stato: " + IntegerToString(g_riprese) + "\r\n");
   FileWriteString(fh, "stato all'avvio    : " + g_statoLetto + "\r\n");
   FileWriteString(fh, "autotest           : " + (InpAutoTest ? ("casi falliti " + IntegerToString(g_autoFalliti) + " (0 = le funzioni di percentile e conversione sono verificate a tavolino)")
                                                              : "DISATTIVATO da input in questo avvio") + "\r\n");
   FileWriteString(fh, "\r\n");
   FileWriteString(fh, "COME SI LEGGE -- e cosa NON c'e' dentro:\r\n");
   FileWriteString(fh, " - le ORE sono in ORA SERVER (= ora italiana meno 1 in questo periodo).\r\n");
   FileWriteString(fh, "   Le schede Esperti/Giornale sono in ora LOCALE: non confrontarle.\r\n");
   FileWriteString(fh, " - il numero grezzo e' in PUNTI MT5; la colonna in unita' pratiche\r\n");
   FileWriteString(fh, "   (pip nel forex, punti indice negli indici) e' solo un comodo.\r\n");
   FileWriteString(fh, " - i campioni sono presi a intervallo fisso: la distribuzione e'\r\n");
   FileWriteString(fh, "   PESATA SUL TEMPO ('se entro in un istante a caso di quell'ora').\r\n");
   FileWriteString(fh, " - campioni consecutivi sono AUTOCORRELATI: guarda la colonna GG\r\n");
   FileWriteString(fh, "   (giornate distinte), non il numero di campioni, per capire se\r\n");
   FileWriteString(fh, "   quella riga ha visto abbastanza mercato.\r\n");
   FileWriteString(fh, " - NON c'e' lo SLIPPAGE, NON ci sono commissioni ne' swap.\r\n");
   FileWriteString(fh, " - broker singolo (BCM), un solo conto, un solo terminale.\r\n");
   FileWriteString(fh, "\r\n");

   for(int i=0; i<g_nSym; i++)
     {
      long tot = 0, totScart = 0;
      for(int h=0; h<NORE; h++) { tot += g_n[Idx(i,h)]; totScart += g_scart[Idx(i,h)]; }
      FileWriteString(fh, "---------------------------------------------------------------------\r\n");
      FileWriteString(fh, "  " + g_sym[i] + (g_vivo[i] ? "" : "   *** SIMBOLO NON SELEZIONABILE: nessun campione ***") + "\r\n");
      FileWriteString(fh, "  decimali " + IntegerToString(g_digits[i]) + ", point " + DoubleToString(g_point[i],8) +
                          ", 1 " + g_unita[i] + " = " + DoubleToString(g_ppu[i],0) + " punti MT5\r\n");
      FileWriteString(fh, "  campioni validi " + IntegerToString(tot) + ", scartati " + IntegerToString(totScart) + "\r\n");
      FileWriteString(fh, "---------------------------------------------------------------------\r\n");
      FileWriteString(fh, "   ora |  campioni | GG |  mediana |      P95 |      P99 |      max   (" + g_unita[i] + ")\r\n");
      FileWriteString(fh, "   ----+-----------+----+----------+----------+----------+---------\r\n");
      for(int h=0; h<NORE; h++)
        {
         int c = Idx(i,h);
         string sh = IntegerToString(h);
         if(StringLen(sh) < 2) sh = "0" + sh;
         if(g_n[c] <= 0)
           {
            FileWriteString(fh, "    " + sh + " | " + Pad(IntegerToString(g_scart[c]) + " scart", 9) + " |  - |      n/d |      n/d |      n/d |      n/d\r\n");
            continue;
           }
         bool o1=false,o2=false,o3=false;
         long med = PercentileBin(i,h,0.50,o1);
         long p95 = PercentileBin(i,h,0.95,o2);
         long p99 = PercentileBin(i,h,0.99,o3);
         FileWriteString(fh, "    " + sh + " | " + Pad(IntegerToString(g_n[c]),9) + " | " + Pad(IntegerToString(g_giorni[c]),2) + " | " +
                             Pad(ValoreBin(o1,med,g_ppu[i],3),8) + " | " +
                             Pad(ValoreBin(o2,p95,g_ppu[i],3),8) + " | " +
                             Pad(ValoreBin(o3,p99,g_ppu[i],3),8) + " | " +
                             Pad(DoubleToString((double)g_max[c]/g_ppu[i],3),8) + "\r\n");
        }
      //--- le due fasce che interessano alla flotta, sommando gli istogrammi
      ScriviFascia(fh, i, 8, 15, "cash EUROPA 8-15");
      ScriviFascia(fh, i, 14, 20, "cash USA 14-20");
      ScriviFascia(fh, i, 0, 23, "TUTTA LA GIORNATA");
      FileWriteString(fh, "\r\n");
     }
   FileWriteString(fh, "=====================================================================\r\n");
   FileWriteString(fh, "  Tabella per macchina: " + FileOrario() + "   Stato: " + FileStato() + "\r\n");
   FileWriteString(fh, "=====================================================================\r\n");
   FileClose(fh);
  }

void ScriviFascia(const int fh, const int i, const int h1, const int h2, const string nome)
  {
   bool o1=false,o2=false;
   long tot = 0;
   long med = PercentileFascia(i,h1,h2,0.50,o1,tot);
   long p95 = PercentileFascia(i,h1,h2,0.95,o2,tot);
   if(tot <= 0)
     {
      FileWriteString(fh, "   >> " + nome + ": nessun campione\r\n");
      return;
     }
   FileWriteString(fh, "   >> " + nome + ": n=" + IntegerToString(tot) +
                       "  mediana " + ValoreBin(o1,med,g_ppu[i],3) +
                       "  P95 " + ValoreBin(o2,p95,g_ppu[i],3) + "  (" + g_unita[i] + ")\r\n");
  }

//==========================================================================
//  CAMPIONAMENTO
//==========================================================================
void Campiona()
  {
   datetime ora = TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(ora, dt);
   int h = dt.hour;
   if(h < 0 || h >= NORE) return;
   int oggi = DataInt(ora);

   for(int i=0; i<g_nSym; i++)
     {
      int c = Idx(i,h);
      if(!g_vivo[i]) { g_scart[c]++; g_totScartati++; continue; }

      MqlTick t;
      if(!SymbolInfoTick(g_sym[i], t)) { g_scart[c]++; g_totScartati++; continue; }

      //--- FRESCHEZZA: un tick vecchio vuol dire mercato fermo (notte,
      //    fine settimana, festa). Se lo contassimo, la mediana della
      //    notte sarebbe l'ultimo spread della sera ripetuto mille volte.
      if(t.time <= 0 || (long)(ora - t.time) > (long)InpFrescoSec) { g_scart[c]++; g_totScartati++; continue; }

      long pts = -1;
      bool daInteger = false;
      if(t.ask > 0.0 && t.bid > 0.0 && t.ask >= t.bid)
         pts = PuntiDaPrezzo(t.ask - t.bid, g_point[i]);
      else
        {
         //--- ripiego: lo spread intero del terminale. Si conta a parte,
         //    perche' e' arrotondato e non e' la stessa misura.
         long sp = SymbolInfoInteger(g_sym[i], SYMBOL_SPREAD);
         if(sp > 0) { pts = sp; daInteger = true; }
        }
      if(pts < 0) { g_scart[c]++; g_totScartati++; continue; }

      g_n[c]++;
      g_totCampioni++;
      g_somma[c] += (double)pts;
      if(pts > g_max[c]) g_max[c] = pts;
      if(daInteger) g_daInteger[c]++;
      if(pts < MAXBIN) g_bin[c*MAXBIN + (int)pts]++;
      else             g_over[c]++;
      if(g_ultimaData[c] != oggi) { g_giorni[c]++; g_ultimaData[c] = oggi; }

      if(g_primo == 0) g_primo = ora;
      g_ultimo = ora;
     }
  }

//==========================================================================
//  COMMENT SUL GRAFICO -- leggero, nessun oggetto grafico
//==========================================================================
void AggiornaComment()
  {
   if(!InpMostraComment) return;
   string s = ABTG_SPREADLOG_MARCATORE + "\n";
   s += "SOLA LETTURA: non apre, non modifica, non chiude niente.\n";
   s += "conto " + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + " @ " + AccountInfoString(ACCOUNT_SERVER) + "\n";
   s += "ora server " + TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) + "\n";
   s += "campioni validi " + IntegerToString(g_totCampioni) + "   scartati " + IntegerToString(g_totScartati) + "\n";
   s += "salvataggi " + IntegerToString(g_salvataggi) + "   riprese " + IntegerToString(g_riprese) + "\n";
   s += "----------------------------------------\n";
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   int h = dt.hour;
   for(int i=0; i<g_nSym; i++)
     {
      int c = Idx(i,h);
      bool o1=false,o2=false;
      long med = PercentileBin(i,h,0.50,o1);
      long p95 = PercentileBin(i,h,0.95,o2);
      s += g_sym[i] + (g_vivo[i] ? "" : " [NON SELEZIONABILE]") +
           "  ora " + IntegerToString(h) + ": n=" + IntegerToString(g_n[c]) +
           "  med " + ValoreBin(o1,med,g_ppu[i],2) +
           "  P95 " + ValoreBin(o2,p95,g_ppu[i],2) + " " + g_unita[i] + "\n";
     }
   Comment(s);
  }

//==========================================================================
//  SALVATAGGIO COMPLETO
//==========================================================================
void SalvaTutto(const string motivo)
  {
   g_salvataggi++;
   bool ok = SalvaStato();
   ScriviOrario();
   ScriviReferto();
   if(InpLogOgniSalvataggio || !ok)
      PrintFormat("[SPREADLOG] salvataggio %d (%s): campioni %d, scartati %d, stato %s",
                  (int)g_salvataggi, motivo, (int)g_totCampioni, (int)g_totScartati, (ok ? "OK" : "NON SCRITTO"));
  }

//==========================================================================
//  CICLO DI VITA
//==========================================================================
int OnInit()
  {
   g_pronto = false;
   g_avvioIstanza = TimeCurrent();

   Print("[SPREADLOG] ", ABTG_SPREADLOG_MARCATORE);
   // NOTA per chi tocchera' questa riga: il testo NON nomina le funzioni
   // vietate (invio ordini, variabili globali del terminale). La riga di
   // lancio conta quei token sul sorgente e pretende ZERO: una stringa che
   // li contiene renderebbe il gate rosso per sempre senza che il codice
   // faccia niente di male (checklist classe 126).
   Print("[SPREADLOG] SOLA LETTURA: nessun ordine, nessuna variabile globale del terminale, scrive solo i propri file in MQL5\\Files.");
   PrintFormat("[SPREADLOG] conto %d @ %s   grafico ospite %s %s (il simbolo del grafico NON conta)",
               (int)AccountInfoInteger(ACCOUNT_LOGIN), AccountInfoString(ACCOUNT_SERVER),
               _Symbol, EnumToString((ENUM_TIMEFRAMES)_Period));

   //--- 1. lista dei simboli
   string chiesti[];
   int n = SpezzaSimboli(InpSimboli, chiesti);
   if(n <= 0)
     {
      Print("[SPREADLOG] InpSimboli e' vuoto: non c'e' niente da misurare. Non parto.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpCampionaSec < 1)
     {
      Print("[SPREADLOG] InpCampionaSec deve essere >= 1. Non parto.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpSalvaSec < 10)
     {
      Print("[SPREADLOG] InpSalvaSec deve essere >= 10 (riscrivere lo stato piu' spesso e' solo I/O sprecato). Non parto.");
      return(INIT_PARAMETERS_INCORRECT);
     }

   g_nSym = n;
   ArrayResize(g_sym, n); ArrayResize(g_digits, n); ArrayResize(g_point, n);
   ArrayResize(g_ppu, n); ArrayResize(g_unita, n);  ArrayResize(g_vivo, n);
   for(int i=0; i<n; i++) g_sym[i] = chiesti[i];
   Alloca();

   //--- 2. autotest PRIMA di misurare (usa e poi rimette a posto lo spazio)
   if(InpAutoTest)
     {
      if(!AutoTest())
         Print("[SPREADLOG] *** ROSSO SPREADLOG *** l'autotest ha casi falliti: la misura NON e' affidabile. Stacca l'EA e segnala.");
     }
   else
      Print("[SPREADLOG] autotest DISATTIVATO da input: nessuna verifica a tavolino in questo avvio.");

   //--- 3. anagrafica dei simboli
   int vivi = 0;
   for(int i=0; i<n; i++)
     {
      //  SymbolSelect e' l'UNICA scrittura che questo artefatto fa fuori dai
      //  propri file: aggiunge il simbolo al Market Watch. Con
      //  InpAggiungiMarketWatch=false non si aggiunge niente e si misura solo
      //  cio' che c'e' gia' -- cosi' chi non vuole che il terminale venga
      //  toccato in nessun modo ha la manopola per dirlo.
      bool sel = false;
      if(InpAggiungiMarketWatch)
         sel = SymbolSelect(g_sym[i], true);
      else
        {
         long v = 0;
         sel = (SymbolInfoInteger(g_sym[i], SYMBOL_SELECT, v) && v != 0);
        }
      g_vivo[i]   = sel;
      g_digits[i] = (int)SymbolInfoInteger(g_sym[i], SYMBOL_DIGITS);
      g_point[i]  = SymbolInfoDouble(g_sym[i], SYMBOL_POINT);
      if(g_point[i] <= 0.0) g_point[i] = MathPow(10, -g_digits[i]);
      g_ppu[i]    = PuntiPerUnita(g_digits[i]);
      g_unita[i]  = NomeUnita(g_digits[i]);
      if(sel) vivi++;
      PrintFormat("[SPREADLOG]   %s : %s, decimali %d, point %s, 1 %s = %s punti MT5",
                  g_sym[i], (sel ? "in Market Watch" : "*** NON SELEZIONABILE: 0 campioni ***"),
                  g_digits[i], DoubleToString(g_point[i],8), g_unita[i], DoubleToString(g_ppu[i],0));
     }
   if(vivi == 0)
      Print("[SPREADLOG] ATTENZIONE: NESSUN simbolo selezionabile. Il logger gira ma non misurera' niente: controlla i nomi in InpSimboli contro il Market Watch di QUESTO broker.");

   //--- 4. ripresa dello stato
   if(InpRiprendiStato) LeggiStato();
   else                 g_statoLetto = "ripresa DISATTIVATA da input: raccolta nuova (il file di stato precedente, se c'e', viene SOVRASCRITTO al primo salvataggio)";
   Print("[SPREADLOG] stato: ", g_statoLetto);

   //--- 5. timer al secondo: il passo vero e' InpCampionaSec, contato qui
   //    dentro. Un timer da 1 s costa nulla e permette di salvare in tempo
   //    anche quando il campionamento e' lento.
   if(!EventSetTimer(1))
     {
      Print("[SPREADLOG] non riesco ad armare il timer: non parto.");
      return(INIT_FAILED);
     }
   g_ultimoCamp = 0;
   g_ultimoSalv = TimeCurrent();
   g_pronto = true;

   PrintFormat("[SPREADLOG] avviato: %d simboli (%d selezionabili), campione ogni %d s, salvataggio ogni %d s, file '%s_*'",
               g_nSym, vivi, InpCampionaSec, InpSalvaSec, InpPrefissoFile);
   AggiornaComment();
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   if(g_pronto)
     {
      SalvaTutto("chiusura, motivo " + IntegerToString(reason));
      PrintFormat("[SPREADLOG] fermato (motivo %d): campioni validi %d, scartati %d, salvataggi %d. Lo stato resta in %s: al riavvio riparte da li'.",
                  reason, (int)g_totCampioni, (int)g_totScartati, (int)g_salvataggi, FileStato());
     }
   Comment("");
  }

//+------------------------------------------------------------------+
//| OnTick ESISTE E NON FA NIENTE, apposta: il campionamento e' a    |
//| tempo (timer), non a tick. Lasciarlo vuoto costa zero e tiene    |
//| l'artefatto un Expert a tutti gli effetti.                       |
//+------------------------------------------------------------------+
void OnTick()
  {
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!g_pronto) return;
   datetime ora = TimeCurrent();

   if(g_ultimoCamp == 0 || (long)(ora - g_ultimoCamp) >= (long)InpCampionaSec)
     {
      Campiona();
      g_ultimoCamp = ora;
      AggiornaComment();
     }
   if((long)(ora - g_ultimoSalv) >= (long)InpSalvaSec)
     {
      SalvaTutto("periodico");
      g_ultimoSalv = ora;
     }
  }
//+------------------------------------------------------------------+
