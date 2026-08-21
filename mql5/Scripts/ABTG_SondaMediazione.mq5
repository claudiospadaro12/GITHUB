//+------------------------------------------------------------------+
//|                                        ABTG_SondaMediazione.mq5  |
//|                                                                  |
//|  IL CONTATORE DI PACCHETTI DELLA STRATEGIA DI MEDIAZIONE          |
//|  (corso di Claudio, Manuela Negro, lezioni 26-33)                 |
//|                                                                  |
//|  RISPONDE A UNA DOMANDA SOLA, e la risponde coi dati:            |
//|     LA MEDIAZIONE DEL CORSO PRODUCE ALMENO 150 PACCHETTI          |
//|     IN-SAMPLE?                                                    |
//|                                                                  |
//|  PERCHE' ESISTE (firma di Claudio del 21/08/2026, OPZIONE C       |
//|  "FREQUENZA" - report/NODO_MEDIAZIONE_2026-08-21.md):             |
//|  sotto 150 pacchetti in IS il giudizio di MERITO e' SOSPESO per   |
//|  regola di casa (Emendamento della finestra, punto A). Se il      |
//|  numero non c'e', il nodo si chiude da solo e NON serve scrivere  |
//|  nessun EA operativo. Per questo la misura si fa PRIMA, e da      |
//|  sola: e' il cancello piu' economico che abbiamo.                 |
//|                                                                  |
//|  L'UNITA' DI MISURA E' IL PACCHETTO, MAI IL TICKET                |
//|  (METRO_PROP.md par.13.2, regola G2, CONGELATA il 21/08):         |
//|  contare i ticket gonfia il campione fino a x3,9 e farebbe        |
//|  passare il muro dei 150 a un motore che non lo merita.           |
//|  Questo script stampa PACCHETTI. I ticket non li stampa           |
//|  nemmeno: stampa quanti LIVELLI ogni pacchetto avrebbe            |
//|  riempito, che e' un'altra cosa e serve alla scheda della coda    |
//|  (G3.1).                                                          |
//|                                                                  |
//|  COSA QUESTO SCRIPT NON FA, e non e' una dimenticanza:            |
//|    - NON apre ordini, NON invia niente al broker, NON tocca       |
//|      nessuna posizione: non esiste una sola chiamata di trading   |
//|      in tutto il file: la riga di grep che lo dimostra sta nel     |
//|      referto, e sul sorgente deve uscire VUOTA;                   |
//|    - NON calcola lotti, NON calcola rischio, NON calcola P&L:     |
//|      il sizing NON e' stato firmato e il fattore 2,29 e' ancora   |
//|      aperto (condizione n.1 del 18/08);                           |
//|    - NON dice se la strategia guadagna. Un conteggio dice solo    |
//|      se il motore e' MISURABILE, non se e' buono.                 |
//|                                                                  |
//|  USO: trascina su UN grafico qualsiasi (il TF del grafico non     |
//|  conta: i dati li legge lui, simbolo per simbolo), premi OK.      |
//|  Guardare la scheda ESPERTI (non il Giornale).                    |
//|  Scrive MQL5\Files\ABTG_SondaMediazione.csv (i totali) e          |
//|  MQL5\Files\ABTG_SondaMediazione_pacchetti.csv (uno per riga:     |
//|  il numero si puo' ricontare a mano, non e' solo una stampa).     |
//|                                                                  |
//|  PREREQUISITO: lo storico H1 dei tre cross va gia' scaricato.     |
//|  Se un simbolo stampa poche barre non e' un difetto dello         |
//|  script: mancano i dati (usare ABTG_HistoryDownloader).           |
//|                                                                  |
//|  Non compilato ne' eseguito da chi lo ha scritto: questo          |
//|  ambiente non ha MetaEditor. Si compila in MetaEditor prima di    |
//|  qualunque corsa.                                                 |
//+------------------------------------------------------------------+
//
//  MAPPA REGOLA <-> CODICE (verificabile riga per riga)
//  ------------------------------------------------------------------
//  SPEC MEDIAZIONE_CORSO_SPEC.md | regola del corso        | dove sta
//  ------------------------------|-------------------------|---------
//  par.1    | timeframe H1                                 | InpTF
//  par.2.1  | universo EURUSD/GBPUSD/EURGBP e SOLO quelli  | InpSimboli
//  par.2.3  | nessun filtro orario (BUCO del corso)        | non esiste
//  par.3    | Williams %R periodo 140                      | InpWilliamsPeriodo
//  par.3.3  | zone -80 / -20, mediana -50                  | InpZonaOS/OB/Mediana
//  par.4.1  | C1 Williams in zona, POI C2 flip SuperTrend  | StatoZona + flip
//  par.4.1  | C3 banda [-80,-50] sulla candela del flip    | ValutaSegnale()
//  par.4.2  | R-ATTESA: se ancora oltre -80, si aspetta    | gAttesa*
//  par.4.3  | invalidatore: oltre la mediana e' morto      | ValutaSegnale()
//  par.4.4  | ancora = CHIUSURA della candela di segnale   | C = close[i]
//  par.5.2  | L_k = C - d*k*(P/2)                          | Geometria()
//  par.5.2  | SL = C - d*3P (unico) - TP = C + d*P (unico) | Geometria()
//  par.5.1  | P = 40 EURUSD / 70 GBPUSD / 20 EURGBP        | InpSimboli
//  par.6.2  | 6 ingressi, progressione volumi x1,5         | NON SERVE QUI:
//           |                                              | i volumi non
//           |                                              | entrano in un
//           |                                              | conteggio di
//           |                                              | pacchetti
//  par.10.3 | test-case di regressione (3 cross, 21 valori)| AutoTest()
//
//  LE ASSUNZIONI, NUMERATE (non sono "il corso", sono NOSTRE)
//  ------------------------------------------------------------------
//  A1. SuperTrend ATR 10 / moltiplicatore 3,0. IL CORSO NON LI DETTA
//      MAI (SPEC par.3.2: il rimando fra i moduli e' CIRCOLARE, il
//      modulo base applica l'indicatore "senza fare nessuna
//      variazione"). Il file "super trend.ex4" della lezione 10, che
//      conterrebbe i default veri, NON CE L'ABBIAMO: e' la richiesta
//      M15b, ancora aperta a Claudio. Valore usato: lo stesso gia'
//      dichiarato per il Breakout del corso in R82 (decisione di
//      Claudio del 18/08), cosi' i due motori restano confrontabili.
//      >>> QUESTO VALORE E' INVENTATO DA NOI. <<<
//      Routine di calcolo ripresa da ABTG_BreakoutCorso.mq5 (a sua
//      volta da ABTG_AltaVelocita.mq5): NON reinventata, cosi' un
//      SuperTrend diverso non spiega una differenza fra i due round.
//  A2. R-ATTESA senza scadenza (InpAttesaMaxBarre = 0). Il corso dice
//      "altrimenti attendo la candela successiva" e non mette mai un
//      limite. Il limite e' un input per poterlo misurare, non un
//      default. >>> INVENTATO DA NOI il fatto che un limite esista. <<<
//  A3. L'attesa MUORE se il SuperTrend torna indietro prima che il
//      Williams entri in banda (InpAttesaMuoreSuFlip = true). Il corso
//      non lo dice mai. Senza questa regola un'attesa potrebbe
//      sopravvivere a un intero controtrend. >>> INVENTATA DA NOI. <<<
//  A4. UN SOLO PACCHETTO PER CROSS alla volta (InpUnPacchettoPerCross).
//      Il corso non pone nessun cap (BUCO n.7 della spec) e nel suo
//      esempio ne mostra DUE aperti insieme, ma su cross diversi.
//      E' la proposta della spec par.10.2 n.5. I segnali che cadono
//      mentre un pacchetto e' aperto vengono contati a parte, come
//      "scartati per occupazione": il numero c'e', non e' nascosto.
//      >>> SCELTA NOSTRA. <<<
//  A5. Livello 0 = riempito SEMPRE, alla chiusura della candela di
//      segnale. Il corso entra a C (il primo ordine e' a mercato /
//      al prezzo del segnale): quindi ogni pacchetto vale almeno 1
//      livello, e PACCHETTO = SEGNALE VALIDO CHE HA MESSO ORDINI.
//      >>> E' LA DEFINIZIONE CHE DECIDE IL NUMERO. <<<
//  A6. Riempimento dei livelli 1..5: livello k riempito quando il
//      MINIMO (BUY) / MASSIMO (SELL) di una barra H1 successiva tocca
//      L_k. E' esatto sui tocchi (il prezzo li' e' passato davvero),
//      NON e' esatto sull'ORDINE dentro la barra.
//  A7. Se nella STESSA barra H1 il prezzo tocca sia lo SL sia il TP,
//      si assume SL (InpPrioritaSLinBarra = true): e' l'ipotesi
//      prudente. Senza dati a tick l'ordine dentro la barra non e'
//      conoscibile, e questo script NON usa i tick per costruzione
//      (legge solo OHLC H1).
//  A8. Uscita anticipata SPENTA di default (InpUscitaAnticipata = 0).
//      E' l'ambiguita' n.8 del corso (lez.31 contro lez.33), mai
//      sciolta. Spenta e' la scelta PRUDENTE sul conteggio: i
//      pacchetti restano aperti piu' a lungo, quindi occupano il
//      cross piu' a lungo, quindi i pacchetti contati sono di MENO.
//      Se il numero passa i 150 con l'uscita spenta, passa a maggior
//      ragione con l'uscita accesa.
//  A9. Riapertura dopo il TP SPENTA di default (il corso la ammette
//      una volta sola). Stessa logica di A8: spenta conta di MENO.
//  A10. Nessun filtro orario, nessun filtro news, nessuno spread,
//      nessuno slippage: un contatore di segnali non ne ha bisogno e
//      metterceli significherebbe inventare regole che il corso non
//      ha (BUCHI n.5 e n.6 della spec).
//+------------------------------------------------------------------+
#property copyright "ABTG - Sonda frequenza Mediazione (firma 21/08/2026)"
#property version   "1.00"
#property description "Conta i PACCHETTI (non i ticket) della Mediazione del corso. NON TRADA."
#property script_show_inputs
#property strict

//--- universo e finestra
input string InpSimboli        = "EURUSD=40,GBPUSD=70,EURGBP=20"; // simbolo=P(pip), separati da virgola
input string InpSuffisso       = "";              // suffisso del broker (es. .r), vuoto su BCM
input ENUM_TIMEFRAMES InpTF    = PERIOD_H1;       // timeframe (il corso: H1, e lo ripete)
input datetime InpDa           = D'2010.01.01';   // inizio finestra (0 = tutto lo storico)
input datetime InpA            = 0;               // fine finestra (0 = adesso)
//--- indicatori
input int    InpWilliamsPeriodo= 140;             // Williams %R (corso: 140, 5 occorrenze)
input double InpZonaOS         = -80.0;           // ipervenduto (corso)
input double InpZonaOB         = -20.0;           // ipercomprato (corso)
input double InpMediana        = -50.0;           // mediana invalidante (corso)
input int    InpSuperTrendATR  = 10;              // ASSUNZIONE A1: il corso TACE
input double InpSuperTrendMult = 3.0;             // ASSUNZIONE A1: il corso TACE
//--- geometria del pacchetto (tutta dal corso)
input int    InpLivelli        = 6;               // cap ingressi (corso: 6, in tre lezioni)
input double InpFrazionePasso  = 0.5;             // passo fra i livelli = P/2 (corso)
input double InpMultSL         = 3.0;             // SL = 3P dal segnale (corso)
input double InpMultTP         = 1.0;             // TP = 1P dal segnale (corso)
//--- assunzioni misurabili (A2-A9)
input int    InpAttesaMaxBarre = 0;               // A2: 0 = attesa senza scadenza
input bool   InpAttesaMuoreSuFlip = true;         // A3: l'attesa muore se il ST torna indietro
input bool   InpUnPacchettoPerCross = true;       // A4: 1 pacchetto per volta per cross
input bool   InpPrioritaSLinBarra = true;         // A7: SL prima del TP nella stessa barra
input int    InpUscitaAnticipata = 0;             // A8: 0=nessuna 1=Williams opposto 2=segnale opposto
input bool   InpRiaperturaDopoTP = false;         // A9: riapertura una volta dopo il TP
input bool   InpArmoMuoreOltreMediana = false;    // variante: l'armo muore se W supera la mediana
//--- tecnici
input int    InpMaxBarre       = 300000;          // barre massime da leggere per simbolo
input int    InpWarmupBarre    = 500;             // barre di riscaldamento prima di valutare
input bool   InpAutoTest       = true;            // esegue i 3 test-case del corso e si ferma se falliscono
input bool   InpScriviCSV      = true;            // scrive i due CSV in MQL5\Files
input bool   InpVerbose        = false;           // stampa OGNI pacchetto nel log (lungo)

//--- soglie di casa, per il verdetto stampato (non decidono niente da sole)
#define SOGLIA_PACCHETTI  150     // Emendamento della finestra, punto A
#define SOGLIA_PIENI_PCT  5.0     // METRO_PROP par.13.3 G3.1: sotto = coda sotto-campionata
#define MAX_LIV           12      // capienza degli istogrammi
#define ANNO_BASE         2000
#define ANNI              41

//--- accumulatori globali (totale su tutti i simboli)
long   gTotSegnali      = 0;   // segnali validi grezzi (prima del filtro di occupazione)
long   gTotScartatiOcc  = 0;   // segnali caduti mentre un pacchetto era gia' aperto
long   gTotPacchetti    = 0;   // PACCHETTI APERTI = il numero della firma
long   gTotChiusi       = 0;   // pacchetti chiusi dentro la finestra
long   gTotLivelli[MAX_LIV];   // istogramma dei livelli riempiti
long   gTotEsito[5];           // 1=TP 2=SL 3=uscita anticipata 4=aperto a fine finestra
long   gTotPieniPoiTP   = 0;   // G3.6: pacchetto pieno che POI fa TP
long   gTotAnni[ANNI];         // pacchetti per anno (serve a dimensionare l'IS)
double gTotDurata       = 0.0; // somma delle durate in barre
int    gCsvPack         = INVALID_HANDLE;
string gRighe[];               // righe del referto a schermo, ricopiate nel CSV totali

//+------------------------------------------------------------------+
//| Il pip come lo intende il corso: 4 decimali sul forex, cioe' 10  |
//| punti sui broker a 5 cifre. Stessa funzione di casa.             |
//+------------------------------------------------------------------+
double PipSize(string sym)
  {
   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double punto  = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(punto <= 0.0) return(0.0);
   if(digits == 3 || digits == 5) return(punto * 10.0);
   return(punto);
  }

//+------------------------------------------------------------------+
//| LA GEOMETRIA DEL CORSO - le tre formule, e basta.                |
//|   L_k = C - d*k*(P/2)   k = 0..cap-1                             |
//|   SL  = C - d*3P        (unico per tutto il pacchetto)           |
//|   TP  = C + d*1P        (unico per tutto il pacchetto)           |
//| d = +1 BUY, -1 SELL. Verificata su 21 valori del corso: AutoTest |
//+------------------------------------------------------------------+
void Geometria(double C, int d, double P, double pip, int cap,
               double &L[], double &sl, double &tp)
  {
   ArrayResize(L, cap);
   for(int k = 0; k < cap; k++)
      L[k] = C - d * k * (InpFrazionePasso * P) * pip;
   sl = C - d * InpMultSL * P * pip;
   tp = C + d * InpMultTP * P * pip;
  }

//+------------------------------------------------------------------+
//| SuperTrend classico su TUTTA la serie, in avanti nel tempo.      |
//| Indice 0 = barra piu' VECCHIA (array non series).                |
//| Restituisce dir[]: +1 verde/rialzista, -1 rosso/ribassista.      |
//| Routine ripresa da ABTG_BreakoutCorso.mq5, solo riscritta con    |
//| l'indice crescente: la barra precedente e' i-1 invece di i+1.    |
//+------------------------------------------------------------------+
bool CalcolaSuperTrend(const MqlRates &r[], int n, const double &atr[], int &dir[])
  {
   if(n < InpSuperTrendATR + 5) return(false);
   ArrayResize(dir, n);
   ArrayInitialize(dir, 0);

   double finalUpper = 0.0, finalLower = 0.0;
   int    d = +1;
   int    start = InpSuperTrendATR + 2;      // prima barra con ATR sensato

   for(int i = start; i < n; i++)
     {
      if(atr[i] <= 0.0) { dir[i] = d; continue; }
      double hl2 = (r[i].high + r[i].low) / 2.0;
      double bUp = hl2 + InpSuperTrendMult * atr[i];
      double bLo = hl2 - InpSuperTrendMult * atr[i];
      double prevFU = (finalUpper == 0.0) ? bUp : finalUpper;
      double prevFL = (finalLower == 0.0) ? bLo : finalLower;
      double pc = r[i - 1].close;
      double fU = (bUp < prevFU || pc > prevFU) ? bUp : prevFU;
      double fL = (bLo > prevFL || pc < prevFL) ? bLo : prevFL;
      if(r[i].close > (d == -1 ? prevFU : fU))      d = +1;
      else if(r[i].close < (d == +1 ? prevFL : fL)) d = -1;
      finalUpper = fU;
      finalLower = fL;
      dir[i] = d;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Carica le barre con qualche tentativo: se il simbolo non e' sul  |
//| grafico MT5 scarica lo storico in asincrono e la prima CopyRates |
//| torna corta. Non e' un errore: e' il download in corso.          |
//+------------------------------------------------------------------+
int CaricaRates(string sym, ENUM_TIMEFRAMES tf, int quante, MqlRates &r[])
  {
   ArraySetAsSeries(r, false);
   int got = 0;
   for(int tent = 0; tent < 40; tent++)
     {
      got = CopyRates(sym, tf, 0, quante, r);
      if(got > InpWarmupBarre) break;
      Sleep(250);
     }
   return(got);
  }

//+------------------------------------------------------------------+
//| Aspetta che l'indicatore abbia finito di calcolare, poi copia.   |
//+------------------------------------------------------------------+
int CaricaBuffer(int handle, int quante, double &buf[])
  {
   ArraySetAsSeries(buf, false);
   int got = 0;
   for(int tent = 0; tent < 40; tent++)
     {
      int calc = BarsCalculated(handle);
      if(calc >= quante)
        {
         got = CopyBuffer(handle, 0, 0, quante, buf);
         if(got >= quante) break;
        }
      Sleep(250);
     }
   if(got <= 0) got = CopyBuffer(handle, 0, 0, quante, buf);
   return(got);
  }

//+------------------------------------------------------------------+
//| I TRE TEST-CASE DEL CORSO (spec par.10.3): 21 valori, zero        |
//| scarto. Se questi non passano, la geometria e' sbagliata e il    |
//| conteggio non vale niente: lo script si ferma.                   |
//+------------------------------------------------------------------+
bool AutoTest()
  {
   double pip = 0.0001;      // i test del corso sono su cross a 4 decimali
   double tol = 0.000011;    // mezzo decimo di pip
   double L[], sl, tp;
   int    errori = 0;

   //--- A) GBPUSD P=70 BUY C=1,2502
   double attA[6] = {1.2502, 1.2467, 1.2432, 1.2397, 1.2362, 1.2327};
   Geometria(1.2502, +1, 70.0, pip, 6, L, sl, tp);
   for(int k = 0; k < 6; k++)
      if(MathAbs(L[k] - attA[k]) > tol)
        { Print("[MEDIAZIONE][AUTOTEST] FALLITO A liv.", k, " atteso ", attA[k], " ottenuto ", L[k]); errori++; }
   if(MathAbs(sl - 1.2292) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO A SL ", sl); errori++; }
   if(MathAbs(tp - 1.2572) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO A TP ", tp); errori++; }

   //--- B) EURGBP P=20 SELL C=0,8598
   double attB[6] = {0.8598, 0.8608, 0.8618, 0.8628, 0.8638, 0.8648};
   Geometria(0.8598, -1, 20.0, pip, 6, L, sl, tp);
   for(int k = 0; k < 6; k++)
      if(MathAbs(L[k] - attB[k]) > tol)
        { Print("[MEDIAZIONE][AUTOTEST] FALLITO B liv.", k, " atteso ", attB[k], " ottenuto ", L[k]); errori++; }
   if(MathAbs(sl - 0.8658) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO B SL ", sl); errori++; }
   if(MathAbs(tp - 0.8578) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO B TP ", tp); errori++; }

   //--- C) EURUSD P=40 SELL C=1,0823 (lez.31, il caso del 22 febbraio)
   double attC[3] = {1.0823, 1.0843, 1.0863};
   Geometria(1.0823, -1, 40.0, pip, 6, L, sl, tp);
   for(int k = 0; k < 3; k++)
      if(MathAbs(L[k] - attC[k]) > tol)
        { Print("[MEDIAZIONE][AUTOTEST] FALLITO C liv.", k, " atteso ", attC[k], " ottenuto ", L[k]); errori++; }
   if(MathAbs(sl - 1.0943) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO C SL ", sl); errori++; }
   if(MathAbs(tp - 1.0783) > tol) { Print("[MEDIAZIONE][AUTOTEST] FALLITO C TP ", tp); errori++; }

   if(errori == 0)
      Print("[MEDIAZIONE][AUTOTEST] geometria: 21 valori su 21 = PASS (GBPUSD/EURGBP/EURUSD)");
   else
      Print("[MEDIAZIONE][AUTOTEST] geometria: ", errori, " ERRORI -> il conteggio NON vale, si ferma qui");
   return(errori == 0);
  }

//+------------------------------------------------------------------+
//| Simula UN pacchetto in avanti sulle barre H1 e dice:             |
//|   - quanti LIVELLI avrebbe riempito (1..cap, il livello 0 e'     |
//|     sempre riempito per assunzione A5)                           |
//|   - come e' finito (1=TP 2=SL 3=uscita anticipata 4=aperto)      |
//|   - su quale barra si e' chiuso (per liberare il cross)          |
//| NON calcola profitti: non e' il suo mestiere e il sizing non e'  |
//| firmato.                                                         |
//+------------------------------------------------------------------+
void SimulaPacchetto(const MqlRates &r[], const double &w[], const int &dir[], int n,
                     int iSeg, int d, double P, double pip,
                     int &livelliOut, int &esitoOut, int &iFineOut)
  {
   double L[], sl, tp;
   Geometria(r[iSeg].close, d, P, pip, InpLivelli, L, sl, tp);

   int livelli = 1;                 // A5: il livello 0 e' riempito al segnale
   int esito   = 4;                 // finche' non succede niente: aperto
   int iFine   = n - 1;

   for(int j = iSeg + 1; j < n; j++)
     {
      //--- livelli riempiti (A6): il prezzo e' passato di li' davvero
      for(int k = livelli; k < InpLivelli; k++)
        {
         bool tocca = (d > 0) ? (r[j].low <= L[k]) : (r[j].high >= L[k]);
         if(tocca) livelli = k + 1;
         else break;               // i livelli sono ordinati: il primo che non tocca ferma
        }

      bool toccaSL = (d > 0) ? (r[j].low  <= sl) : (r[j].high >= sl);
      bool toccaTP = (d > 0) ? (r[j].high >= tp) : (r[j].low  <= tp);

      if(toccaSL && toccaTP)        // A7: dentro la barra non si sa l'ordine
        { esito = (InpPrioritaSLinBarra ? 2 : 1); iFine = j; break; }
      if(toccaSL) { esito = 2; iFine = j; break; }
      if(toccaTP) { esito = 1; iFine = j; break; }

      //--- A8: uscita anticipata, spenta di default
      if(InpUscitaAnticipata == 1)
        {
         bool opposto = (d > 0) ? (w[j] >= InpZonaOB) : (w[j] <= InpZonaOS);
         if(opposto) { esito = 3; iFine = j; break; }
        }
      else if(InpUscitaAnticipata == 2)
        {
         bool flipOpp = (d > 0) ? (dir[j] < 0 && dir[j - 1] > 0) : (dir[j] > 0 && dir[j - 1] < 0);
         bool inBanda = (d > 0) ? (w[j] > InpMediana && w[j] < InpZonaOB)
                                : (w[j] < InpMediana && w[j] > InpZonaOS);
         if(flipOpp && inBanda) { esito = 3; iFine = j; break; }
        }
     }

   livelliOut = livelli;
   esitoOut   = esito;
   iFineOut   = iFine;
  }

//+------------------------------------------------------------------+
//| Analizza UN simbolo. Qui vive la macchina a stati del segnale.   |
//+------------------------------------------------------------------+
bool AnalizzaSimbolo(string sym, double P)
  {
   if(!SymbolSelect(sym, true))
     { Print("[MEDIAZIONE] ", sym, ": simbolo NON disponibile sul broker -> saltato"); return(false); }

   double pip  = PipSize(sym);
   int    dgt  = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   if(pip <= 0.0)
     { Print("[MEDIAZIONE] ", sym, ": point non valido -> saltato"); return(false); }

   //--- dati
   MqlRates r[];
   int n = CaricaRates(sym, InpTF, InpMaxBarre, r);
   if(n <= InpWarmupBarre)
     { Print("[MEDIAZIONE] ", sym, ": solo ", n, " barre ", EnumToString(InpTF),
             " -> STORICO INSUFFICIENTE (scaricarlo con ABTG_HistoryDownloader)"); return(false); }

   int hW = iWPR(sym, InpTF, InpWilliamsPeriodo);
   int hA = iATR(sym, InpTF, InpSuperTrendATR);
   if(hW == INVALID_HANDLE || hA == INVALID_HANDLE)
     { Print("[MEDIAZIONE] ", sym, ": handle indicatori non creati -> saltato"); return(false); }

   double w[], atr[];
   int gw = CaricaBuffer(hW, n, w);
   int ga = CaricaBuffer(hA, n, atr);
   IndicatorRelease(hW);
   IndicatorRelease(hA);
   if(gw < n || ga < n)
     { Print("[MEDIAZIONE] ", sym, ": buffer corti (W=", gw, " ATR=", ga, " su ", n,
             ") -> riprovare a terminale scaldato"); return(false); }

   int dir[];
   if(!CalcolaSuperTrend(r, n, atr, dir))
     { Print("[MEDIAZIONE] ", sym, ": SuperTrend non calcolabile -> saltato"); return(false); }

   //--- finestra effettiva: quello che c'e' davvero, non quello che si e' chiesto
   int iStart = MathMax(InpWarmupBarre, MathMax(InpWilliamsPeriodo + 5, InpSuperTrendATR + 5));
   while(iStart < n && InpDa > 0 && r[iStart].time < InpDa) iStart++;
   int iEnd = n - 1;                                  // l'ultima barra chiusa la lasciamo fuori
   if(InpA > 0) { while(iEnd > iStart && r[iEnd].time > InpA) iEnd--; }
   iEnd = MathMin(iEnd, n - 2);
   if(iEnd - iStart < 100)
     { Print("[MEDIAZIONE] ", sym, ": finestra effettiva troppo corta (",
             (iEnd - iStart), " barre) -> saltato"); return(false); }

   //--- contatori di simbolo
   long segnali = 0, scartatiOcc = 0, pacchetti = 0, chiusi = 0, pieniPoiTP = 0;
   long liv[MAX_LIV]; ArrayInitialize(liv, 0);
   long esiti[5];     ArrayInitialize(esiti, 0);
   double sommaDurata = 0.0;

   //--- macchina a stati (spec par.4)
   int  armo       = 0;      // +1 armato per BUY (Williams entrato sotto -80), -1 per SELL
   int  attesa     = 0;      // +1/-1 se il flip e' avvenuto ma il Williams non e' ancora in banda
   int  barraAttesa= -1;
   int  liberoDa   = -1;     // A4: prima barra in cui il cross e' di nuovo libero

   for(int i = iStart; i <= iEnd; i++)
     {
      double W = w[i];

      //--- C1: ingresso in zona. Entrare in una zona disarma l'altra.
      if(W <= InpZonaOS) { armo = +1; if(attesa < 0) attesa = 0; }
      if(W >= InpZonaOB) { armo = -1; if(attesa > 0) attesa = 0; }
      if(InpArmoMuoreOltreMediana && attesa == 0)
        {
         if(armo > 0 && W >= InpMediana) armo = 0;
         if(armo < 0 && W <= InpMediana) armo = 0;
        }

      //--- R-ATTESA (par.4.2): il flip c'e' gia' stato, aspetto il Williams
      if(attesa != 0)
        {
         bool morta = false;
         if(InpAttesaMuoreSuFlip)                       // A3
           {
            if(attesa > 0 && dir[i] < 0) morta = true;
            if(attesa < 0 && dir[i] > 0) morta = true;
           }
         if(InpAttesaMaxBarre > 0 && (i - barraAttesa) > InpAttesaMaxBarre) morta = true; // A2
         if(morta) { attesa = 0; armo = 0; }
        }

      //--- C2: cambio colore del SuperTrend sulla candela i
      bool flipSu  = (dir[i] > 0 && dir[i - 1] < 0);
      bool flipGiu = (dir[i] < 0 && dir[i - 1] > 0);
      if(attesa == 0)
        {
         if(armo > 0 && flipSu)  { attesa = +1; barraAttesa = i; }
         if(armo < 0 && flipGiu) { attesa = -1; barraAttesa = i; }
        }

      //--- C3: la banda decide. Qui il segnale nasce, muore o aspetta ancora.
      if(attesa != 0)
        {
         int d = attesa;
         bool inBanda, tardi;
         if(d > 0) { inBanda = (W > InpZonaOS && W < InpMediana); tardi = (W >= InpMediana); }
         else      { inBanda = (W < InpZonaOB && W > InpMediana); tardi = (W <= InpMediana); }

         if(tardi)                       // par.4.3: oltre la mediana e' troppo tardi
           { attesa = 0; armo = 0; }
         else if(inBanda)
           {
            segnali++;
            attesa = 0; armo = 0;
            if(InpUnPacchettoPerCross && i < liberoDa)
              {
               scartatiOcc++;            // A4: il cross e' occupato, il segnale non diventa pacchetto
              }
            else
              {
               int nliv, esito, iFine;
               SimulaPacchetto(r, w, dir, iEnd + 1, i, d, P, pip, nliv, esito, iFine);
               pacchetti++;
               if(nliv >= 0 && nliv < MAX_LIV) liv[nliv]++;
               esiti[esito]++;
               if(esito != 4) { chiusi++; sommaDurata += (double)(iFine - i); }
               if(nliv >= InpLivelli && esito == 1) pieniPoiTP++;   // G3.6
               MqlDateTime dt; TimeToStruct(r[i].time, dt);
               int idxAnno = dt.year - ANNO_BASE;
               if(idxAnno >= 0 && idxAnno < ANNI) gTotAnni[idxAnno]++;
               liberoDa = iFine + 1;
               if(InpRiaperturaDopoTP && esito == 1) liberoDa = iFine;  // A9
               if(gCsvPack != INVALID_HANDLE)
                  FileWrite(gCsvPack, sym, TimeToString(r[i].time, TIME_DATE | TIME_MINUTES),
                            (d > 0 ? "BUY" : "SELL"), DoubleToString(r[i].close, dgt),
                            IntegerToString(nliv),
                            (esito == 1 ? "TP" : (esito == 2 ? "SL" : (esito == 3 ? "USCITA" : "APERTO"))),
                            IntegerToString(iFine - i),
                            TimeToString(r[iFine].time, TIME_DATE | TIME_MINUTES));
               if(InpVerbose)
                  Print("[MEDIAZIONE] ", sym, " ", TimeToString(r[i].time), " ",
                        (d > 0 ? "BUY" : "SELL"), " C=", DoubleToString(r[i].close, dgt),
                        " livelli=", nliv, " esito=", esito);
              }
           }
         // se ancoraEstremo: non si fa niente, si aspetta la candela dopo (par.4.2)
        }
     }

   //--- referto di simbolo
   double pctPieni = (pacchetti > 0) ? (100.0 * (double)liv[InpLivelli] / (double)pacchetti) : 0.0;
   double durata   = (chiusi > 0) ? (sommaDurata / (double)chiusi) : 0.0;
   double anni     = (double)(r[iEnd].time - r[iStart].time) / (365.25 * 24.0 * 3600.0);

   Print("--------------------------------------------------------------");
   Print("[MEDIAZIONE] ", sym, "  P=", DoubleToString(P, 0), " pip   pip=", DoubleToString(pip, 5));
   Print("   barre lette          : ", n, "   valutate: ", (iEnd - iStart + 1));
   Print("   finestra EFFETTIVA   : ", TimeToString(r[iStart].time, TIME_DATE | TIME_MINUTES),
         "  ->  ", TimeToString(r[iEnd].time, TIME_DATE | TIME_MINUTES),
         "   (", DoubleToString(anni, 2), " anni)");
   Print("   segnali validi       : ", segnali,
         "   di cui scartati perche' il cross era occupato: ", scartatiOcc);
   Print("   >>> PACCHETTI        : ", pacchetti, "   (chiusi nella finestra: ", chiusi, ")");
   Print("   pacchetti/anno       : ", DoubleToString((anni > 0.0 ? (double)pacchetti / anni : 0.0), 1));
   Print("   istogramma LIVELLI   : 1=", liv[1], " 2=", liv[2], " 3=", liv[3],
         " 4=", liv[4], " 5=", liv[5], " 6=", liv[6]);
   Print("   pacchetti PIENI      : ", liv[InpLivelli], " = ", DoubleToString(pctPieni, 1), "%",
         (pctPieni < SOGLIA_PIENI_PCT ? "   <<< CODA SOTTO-CAMPIONATA (G3.1)" : ""));
   Print("   esiti                : TP=", esiti[1], " SL=", esiti[2],
         " uscita=", esiti[3], " aperto a fine finestra=", esiti[4]);
   Print("   pieno E POI TP (G3.6): ", pieniPoiTP);
   Print("   durata media         : ", DoubleToString(durata, 1), " barre ", EnumToString(InpTF));

   //--- accumulo nei totali
   gTotSegnali     += segnali;
   gTotScartatiOcc += scartatiOcc;
   gTotPacchetti   += pacchetti;
   gTotChiusi      += chiusi;
   gTotPieniPoiTP  += pieniPoiTP;
   gTotDurata      += sommaDurata;
   for(int k = 0; k < MAX_LIV; k++) gTotLivelli[k] += liv[k];
   for(int e = 0; e < 5; e++)       gTotEsito[e]   += esiti[e];

   int idx = ArraySize(gRighe);
   ArrayResize(gRighe, idx + 1);
   gRighe[idx] = StringFormat("%s;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%.1f;%s;%s",
                              sym, n, (iEnd - iStart + 1), (int)segnali, (int)scartatiOcc,
                              (int)pacchetti, (int)chiusi,
                              (int)liv[1], (int)liv[2], (int)liv[3], (int)liv[4], (int)liv[5], (int)liv[6],
                              pctPieni,
                              TimeToString(r[iStart].time, TIME_DATE),
                              TimeToString(r[iEnd].time, TIME_DATE));
   return(true);
  }

//+------------------------------------------------------------------+
//| Divide "EURUSD=40,GBPUSD=70" in nomi e parametri P.              |
//+------------------------------------------------------------------+
int ParsaSimboli(string s, string &nomi[], double &pars[])
  {
   string pezzi[];
   int q = StringSplit(s, ',', pezzi);
   if(q <= 0) return(0);
   ArrayResize(nomi, 0);
   ArrayResize(pars, 0);
   for(int i = 0; i < q; i++)
     {
      string p = pezzi[i];
      StringTrimLeft(p); StringTrimRight(p);
      if(StringLen(p) == 0) continue;
      string kv[];
      int qq = StringSplit(p, '=', kv);
      if(qq != 2) { Print("[MEDIAZIONE] voce ignorata (serve SIMBOLO=P): ", p); continue; }
      StringTrimLeft(kv[0]); StringTrimRight(kv[0]);
      StringTrimLeft(kv[1]); StringTrimRight(kv[1]);
      double P = StringToDouble(kv[1]);
      if(P <= 0.0) { Print("[MEDIAZIONE] P non valido per ", kv[0]); continue; }
      int idx = ArraySize(nomi);
      ArrayResize(nomi, idx + 1);
      ArrayResize(pars, idx + 1);
      nomi[idx] = kv[0] + InpSuffisso;
      pars[idx] = P;
     }
   return(ArraySize(nomi));
  }

//+------------------------------------------------------------------+
//| MAIN                                                             |
//+------------------------------------------------------------------+
void OnStart()
  {
   ArrayInitialize(gTotLivelli, 0);
   ArrayInitialize(gTotEsito, 0);
   ArrayInitialize(gTotAnni, 0);
   ArrayResize(gRighe, 0);

   Print("==============================================================");
   Print("[MEDIAZIONE] SONDA DI FREQUENZA - conta PACCHETTI, non ticket");
   Print("[MEDIAZIONE] firma di Claudio 21/08/2026, opzione C FREQUENZA");
   Print("[MEDIAZIONE] domanda unica: >= ", SOGLIA_PACCHETTI, " pacchetti in-sample?");
   Print("[MEDIAZIONE] questo script NON apre ordini e NON calcola lotti");
   Print("[MEDIAZIONE] ASSUNZIONE A1 (nostra, il corso tace): SuperTrend ATR ",
         InpSuperTrendATR, " mult ", DoubleToString(InpSuperTrendMult, 2));
   Print("==============================================================");

   if(InpLivelli < 1 || InpLivelli >= MAX_LIV)
     { Print("[MEDIAZIONE] InpLivelli fuori scala (1..", MAX_LIV - 1, "): il corso dice 6."); return; }
   if(InpWilliamsPeriodo < 2 || InpSuperTrendATR < 2 || InpSuperTrendMult <= 0.0)
     { Print("[MEDIAZIONE] parametri indicatori non validi."); return; }
   if(InpWarmupBarre < InpWilliamsPeriodo + 5)
     { Print("[MEDIAZIONE] InpWarmupBarre deve essere almeno Williams+5."); return; }

   if(InpAutoTest && !AutoTest())
     { Print("[MEDIAZIONE] AUTOTEST FALLITO: non conto niente."); return; }

   string nomi[]; double pars[];
   int q = ParsaSimboli(InpSimboli, nomi, pars);
   if(q <= 0) { Print("[MEDIAZIONE] nessun simbolo valido in InpSimboli."); return; }

   if(InpScriviCSV)
     {
      gCsvPack = FileOpen("ABTG_SondaMediazione_pacchetti.csv",
                          FILE_WRITE | FILE_CSV | FILE_ANSI, ";");
      if(gCsvPack != INVALID_HANDLE)
         FileWrite(gCsvPack, "simbolo", "ora_segnale", "direzione", "close_segnale",
                   "livelli_riempiti", "esito", "durata_barre", "ora_chiusura");
     }

   int ok = 0;
   for(int i = 0; i < q; i++)
      if(AnalizzaSimbolo(nomi[i], pars[i])) ok++;

   if(gCsvPack != INVALID_HANDLE) { FileClose(gCsvPack); gCsvPack = INVALID_HANDLE; }

   if(ok == 0) { Print("[MEDIAZIONE] nessun simbolo analizzato: niente totale."); return; }

   //--- IL NUMERO
   double pctPieni = (gTotPacchetti > 0) ? (100.0 * (double)gTotLivelli[InpLivelli] / (double)gTotPacchetti) : 0.0;
   Print("==============================================================");
   Print("[MEDIAZIONE] ===== TOTALE SUI ", ok, " CROSS =====");
   Print("   segnali validi grezzi       : ", gTotSegnali);
   Print("   scartati (cross occupato)   : ", gTotScartatiOcc, "   [assunzione A4]");
   Print("   >>> PACCHETTI TOTALI        : ", gTotPacchetti, "   <<< IL NUMERO DELLA FIRMA");
   Print("   di cui chiusi nella finestra: ", gTotChiusi);
   Print("   istogramma LIVELLI (G3.1)   : 1=", gTotLivelli[1], " 2=", gTotLivelli[2],
         " 3=", gTotLivelli[3], " 4=", gTotLivelli[4], " 5=", gTotLivelli[5], " 6=", gTotLivelli[6]);
   Print("   pacchetti PIENI (", InpLivelli, " livelli): ", gTotLivelli[InpLivelli],
         " = ", DoubleToString(pctPieni, 1), "%");
   if(pctPieni < SOGLIA_PIENI_PCT)
      Print("   >>> CODA SOTTO-CAMPIONATA (G3.1): sotto il ", DoubleToString(SOGLIA_PIENI_PCT, 0),
            "% la perdita piena NON e' stimata, e' solo aritmetica. Va detto.");
   Print("   esiti                       : TP=", gTotEsito[1], " SL=", gTotEsito[2],
         " uscita=", gTotEsito[3], " aperti a fine finestra=", gTotEsito[4]);
   Print("   pieno E POI TP (G3.6)       : ", gTotPieniPoiTP);
   Print("   durata media pacchetto      : ",
         DoubleToString((gTotChiusi > 0 ? gTotDurata / (double)gTotChiusi : 0.0), 1), " barre");

   //--- pacchetti per anno: serve a DIMENSIONARE la finestra IS (Emendamento A)
   Print("--------------------------------------------------------------");
   Print("[MEDIAZIONE] PACCHETTI PER ANNO (per dimensionare l'IS a >= ", SOGLIA_PACCHETTI, "):");
   for(int a = 0; a < ANNI; a++)
      if(gTotAnni[a] > 0) Print("   ", (ANNO_BASE + a), " : ", gTotAnni[a]);

   long cum = 0; int anniServiti = 0;
   for(int a = ANNI - 1; a >= 0; a--)
     {
      if(gTotAnni[a] <= 0 && cum == 0) continue;
      cum += gTotAnni[a];
      anniServiti++;
      if(cum >= SOGLIA_PACCHETTI)
        { Print("   -> per arrivare a ", SOGLIA_PACCHETTI, " pacchetti servono gli ULTIMI ",
                anniServiti, " anni (cumulato ", cum, ")"); break; }
     }
   if(cum < SOGLIA_PACCHETTI)
      Print("   -> TUTTO lo storico disponibile da' ", cum, " pacchetti: NON si arriva a ",
            SOGLIA_PACCHETTI, " nemmeno usando tutto.");

   //--- IL VERDETTO, che e' solo aritmetico
   Print("==============================================================");
   if(gTotPacchetti >= SOGLIA_PACCHETTI)
      Print("[MEDIAZIONE] >= ", SOGLIA_PACCHETTI, " PACCHETTI sull'INTERA finestra letta. ",
            "Il cancello della FREQUENZA non chiude il nodo. ",
            "ATTENZIONE: questo NON dice che la strategia guadagna, e NON scioglie ",
            "il fattore 2,29 (condizione n.1) ne' il cancello di taglia.");
   else
      Print("[MEDIAZIONE] MENO di ", SOGLIA_PACCHETTI, " PACCHETTI: per l'Emendamento della ",
            "finestra (punto A) il giudizio di MERITO e' SOSPESO. Il nodo si chiude ",
            "con un numero, senza scrivere nessun EA.");
   Print("==============================================================");

   //--- CSV dei totali: il numero deve poter uscire DAI DATI, non solo dal log
   if(InpScriviCSV)
     {
      int h = FileOpen("ABTG_SondaMediazione.csv", FILE_WRITE | FILE_CSV | FILE_ANSI, ";");
      if(h != INVALID_HANDLE)
        {
         FileWrite(h, "simbolo", "barre_lette", "barre_valutate", "segnali", "scartati_occupato",
                   "PACCHETTI", "pacchetti_chiusi", "liv1", "liv2", "liv3", "liv4", "liv5", "liv6",
                   "pct_pieni", "da", "a");
         for(int i = 0; i < ArraySize(gRighe); i++)
           {
            string c[];
            int nc = StringSplit(gRighe[i], ';', c);
            if(nc == 16)
               FileWrite(h, c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8], c[9],
                         c[10], c[11], c[12], c[13], c[14], c[15]);
           }
         FileWrite(h, "TOTALE", "", "", IntegerToString((int)gTotSegnali),
                   IntegerToString((int)gTotScartatiOcc), IntegerToString((int)gTotPacchetti),
                   IntegerToString((int)gTotChiusi),
                   IntegerToString((int)gTotLivelli[1]), IntegerToString((int)gTotLivelli[2]),
                   IntegerToString((int)gTotLivelli[3]), IntegerToString((int)gTotLivelli[4]),
                   IntegerToString((int)gTotLivelli[5]), IntegerToString((int)gTotLivelli[6]),
                   DoubleToString(pctPieni, 1), "", "");
         FileWrite(h, "ASSUNZIONE_A1_SuperTrend", "ATR", IntegerToString(InpSuperTrendATR),
                   "mult", DoubleToString(InpSuperTrendMult, 2), "INVENTATO_DA_NOI",
                   "il corso non lo detta mai", "", "", "", "", "", "", "", "", "");
         FileClose(h);
         Print("[MEDIAZIONE] scritti MQL5\\Files\\ABTG_SondaMediazione.csv e ",
               "ABTG_SondaMediazione_pacchetti.csv");
        }
     }
  }
//+------------------------------------------------------------------+
