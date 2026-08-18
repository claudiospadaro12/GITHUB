//+------------------------------------------------------------------+
//|                              ABTG_ImportaStoricoEsterno_v2.mq5    |
//|                                                                   |
//|  IMPORTA storico ESTERNO (CSV M1) dentro MT5 come CUSTOM SYMBOL,  |
//|  clonando le proprieta' dal simbolo BCM corrispondente, cosi'     |
//|  walkforward_generico.ps1 puo' testarci sopra gli EA ESISTENTI    |
//|  senza toccare una riga di codice.                                |
//|                                                                   |
//|  ### REGOLA D'USO, CONGELATA - NON NEGOZIABILE ###                |
//|  I simboli *_EXT servono SOLO come PROVA DI REGIME, a celle e     |
//|  parametri CONGELATI. NON si ottimizza MAI su dati di un altro    |
//|  feed: la taratura resta sui simboli BCM nativi, dove si opera.   |
//|  Un parametro pescato qui e' peggio di nessun test, perche'       |
//|  sembra validato e non lo e'.                                     |
//|                                                                   |
//|  ================= COSA CAMBIA NELLA v2 ==========================|
//|  MISURA CHE L'HA FATTA NASCERE (18/08/2026 sera, tre import sul   |
//|  PC, par. 14 di REFERTO_HISTDATA_FATTIBILITA.md):                 |
//|      NASUSD_EXT  diff media H1 0,0756%                            |
//|      225JPY_EXT  diff media H1 0,1010%                            |
//|      SPXUSD_EXT  diff media H1 0,0608%                            |
//|  contro il cancello congelato <= 0,05%. Shift +5 confermato tre   |
//|  volte su tre (minimo netto), copertura 97%: la CONVENZIONE e'    |
//|  giusta, il CALENDARIO no.                                        |
//|                                                                   |
//|  IL DIFETTO, IN UNA RIGA: i timestamp HistData sono ORA LOCALE DI |
//|  NEW YORK (calendario DST USA), il server BCM segue il calendario |
//|  DST EUROPEO. I due calendari NON coincidono per 503-671 ore      |
//|  l'anno (5,7%-7,7%: la finestra di marzo dura 14 o 21 giorni a    |
//|  seconda di dove cade la seconda domenica; quella di fine ottobre |
//|  dura sempre 7 giorni) e in quelle settimane uno shift COSTANTE   |
//|  sbaglia di un'ora.                                               |
//|                                                                   |
//|  IL CONTO (verificabile a mano):                                  |
//|    USA: seconda domenica di marzo 02:00 -> prima domenica di      |
//|         novembre 02:00 (locale). Offset NY = UTC-5 / UTC-4.       |
//|    EU : ultima domenica di marzo 01:00 UTC -> ultima domenica di  |
//|         ottobre 01:00 UTC. Offset server = base / base+1.         |
//|    shift(t) = shiftBase + (EU in DST ? 1 : 0) - (NY in DST ? 1:0) |
//|  Le quattro combinazioni:                                         |
//|    NY std  + EU std  -> shiftBase        (inverno pieno)          |
//|    NY dst  + EU dst  -> shiftBase        (estate piena)           |
//|    NY dst  + EU std  -> shiftBase - 1    (le finestre sfasate)    |
//|    NY std  + EU dst  -> shiftBase + 1    (NON ACCADE MAI con i    |
//|                         calendari attuali: gli USA entrano PRIMA  |
//|                         ed escono DOPO. Il codice lo gestisce lo  |
//|                         stesso, cosi' regge anche se un giorno le |
//|                         regole cambiano.)                         |
//|  Quindi nelle finestre lo shift diventa +4, mai +6. Non e' una    |
//|  scelta: e' quello che dicono le due regole di calendario.        |
//|                                                                   |
//|  Finestre nel periodo di confronto (calcolate dal codice, qui     |
//|  scritte solo per il lettore): 27/10-03/11/2024, 09/03-30/03/2025,|
//|  26/10-02/11/2025, 08/03-29/03/2026.                              |
//|                                                                   |
//|  COSA FA LA v2:                                                   |
//|   1. InpShiftDstAware (default true): ogni barra riceve lo shift  |
//|      del SUO istante, non uno shift medio. Le domeniche di        |
//|      cambio ora sono CALCOLATE (nessuna tabella scritta a mano):  |
//|      vale dal 2000 al 2040, ben oltre i dati che abbiamo.         |
//|   2. Il referto stampa DUE misure: diff con shift FISSO (la       |
//|      vecchia, come controprova) e diff DST-aware (la nuova, su    |
//|      cui si giudica il cancello). Un numero solo non si giudica.  |
//|   3. Spacca la diff DENTRO e FUORI le finestre sfasate: se il     |
//|      difetto e' il calendario, il "dentro" e' molto peggio del    |
//|      "fuori" e dopo la cura si allineano.                         |
//|   4. Diagnosi del RESIDUO: mediana della differenza FIRMATA       |
//|      (bias di livello, tipico di cash-vs-future) e diff media al  |
//|      netto di quel bias. Serve a distinguere "ora sbagliata" da   |
//|      "strumento diverso": sono due malattie, la seconda NON si    |
//|      cura con il fuso.                                            |
//|   5. InpAutoTest: modo collaudo. Verifica le conversioni ai       |
//|      quattro confini DST con l'atteso SCRITTO NEL CODICE, poi     |
//|      esce SENZA importare nulla.                                  |
//|                                                                   |
//|  ONESTA' PREVENTIVA: la cura DST toglie l'errore di calendario,   |
//|  NON garantisce il cancello. Se il residuo e' un bias di livello  |
//|  (indice cash contro CFD su future) resta li' anche a fuso        |
//|  perfetto. Il punto 4 serve esattamente a dirlo con un numero.    |
//|                                                                   |
//|  LA TRAPPOLA CHE NON PUO' DISINNESCARE:                           |
//|   SPREAD E COMMISSIONI restano quelli che imposti nel tester,     |
//|   non quelli storici del feed. Su strategie a stop stretto        |
//|   questo puo' spostare il verdetto: dichiararlo sempre.           |
//|                                                                   |
//|  USO: trascina lo script su un grafico qualsiasi. Il CSV va in    |
//|  MQL5\Files. REFERTO: MQL5\Files\ABTG_ImportEsterno_referto_v2.csv|
//|  (file NUOVO: la v2 ha colonne in piu', mescolarle al referto v1  |
//|  darebbe un CSV storto).                                          |
//|                                                                   |
//|  La v1 (ABTG_ImportaStoricoEsterno.mq5) NON si tocca e resta      |
//|  disponibile: e' la catena con cui sono stati promossi gli 8      |
//|  forex del 15/08 e va conservata riproducibile.                   |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

#define VERSIONE "IMP-EXT-v2"

input string InpSimboloSorgente   = "EURUSD";        // simbolo BCM da CLONARE (proprieta' e confronto)
input string InpSimboloNuovo      = "";              // nome custom symbol (vuoto = sorgente + "_EXT")
input string InpFileCsv           = "EURUSD_M1.csv"; // file dentro MQL5\Files
input int    InpFormato           = 0;               // 0 = HistData M1 ASCII  |  1 = CSV generico con intestazione
input int    InpShiftOre          = 0;               // shift BASE in ore (usato solo se InpAutoShift=false)
input bool   InpAutoShift         = true;            // true = calibra lo shift base da solo
input int    InpShiftMax          = 6;               // ampiezza della scansione automatica (+/- ore)
input bool   InpShiftDstAware     = true;            // v2: converte dal calendario DST USA a quello EU
input bool   InpAutoTest          = false;           // v2: modo collaudo (verifica i confini DST ed ESCE)
input bool   InpCancellaEsistente = true;            // true = azzera il custom symbol prima di riempirlo

#define REFERTO "ABTG_ImportEsterno_referto_v2.csv"
#define BLOCCO  50000     // barre per chiamata a CustomRatesUpdate

//--- copertura della tabella DST: molto piu' larga dei dati che abbiamo
//    (HistData parte dal 2000-2010 a seconda dello strumento). Fuori da
//    questo intervallo i confini si calcolano lo stesso, solo piu' lenti.
#define DST_ANNO_MIN 2000
#define DST_ANNO_MAX 2040

//+------------------------------------------------------------------+
//| risultato di UNA misura di differenza contro il nativo BCM       |
//| (una struttura sola, usata sia per lo shift fisso sia per il     |
//|  DST-aware: cosi' le due misure non possono divergere per un     |
//|  errore di copia-incolla)                                        |
//+------------------------------------------------------------------+
struct EsitoConfronto
  {
   int      shift;           // shift BASE usato
   bool     dstAware;        // modalita' della misura
   double   diffMediaPti;    // differenza media assoluta chiusure H1, in points
   double   diffMaxPti;      // differenza massima, in points
   double   diffMediaPct;    // la stessa media, in % del prezzo
   datetime quandoMax;       // data della differenza massima
   int      barre;           // barre H1 confrontate
   int      barreNative;     // barre H1 dell'importato dentro il range nativo
   double   coperturaPct;    // 100 * barre / barreNative
   //--- spaccatura calendario (v2)
   double   pctDentro;       // diff media % nelle finestre sfasate
   double   pctFuori;        // diff media % fuori dalle finestre
   int      barreDentro;
   int      barreFuori;
   //--- diagnosi del residuo (v2)
   double   biasMedianoPct;  // mediana della differenza FIRMATA, in % del prezzo
   double   nettaPct;        // diff media % dopo aver tolto il bias mediano
   bool     valido;          // false = campione troppo sottile
  };

//--- azzeramento esplicito: una struct locale non azzerata che finisce
//    nel referto e' un numero inventato con l'aria di essere misurato
void AzzeraEsito(EsitoConfronto &e, int shiftBase, bool dstAware)
  {
   e.shift = shiftBase; e.dstAware = dstAware;
   e.diffMediaPti = 0; e.diffMaxPti = 0; e.diffMediaPct = 0; e.quandoMax = 0;
   e.barre = 0; e.barreNative = 0; e.coperturaPct = 0;
   e.pctDentro = 0; e.pctFuori = 0; e.barreDentro = 0; e.barreFuori = 0;
   e.biasMedianoPct = 0; e.nettaPct = 0; e.valido = false;
  }

//+------------------------------------------------------------------+
//| utilita' di base                                                 |
//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringTrimLeft(s); StringTrimRight(s);
   return s;
  }

//--- ora piena (troncamento al bucket H1)
datetime OraPiena(datetime t) { return (datetime)((long)t - ((long)t % 3600)); }

//+==================================================================+
//|             CALENDARIO DST - IL CUORE DELLA v2                   |
//|                                                                  |
//| Le domeniche di cambio ora si CALCOLANO. Niente tabelle scritte  |
//| a mano: una tabella copre gli anni che uno ha voglia di scrivere |
//| e sbaglia in silenzio il primo anno che manca. Qui la regola e'  |
//| quella di legge, quindi vale per qualunque anno.                 |
//+==================================================================+
datetime CostruisciData(int anno, int mese, int giorno, int ora)
  {
   return StringToTime(StringFormat("%04d.%02d.%02d %02d:00:00", anno, mese, giorno, ora));
  }

int GiorniMese(int anno, int mese)
  {
   static int g[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
   if(mese == 2 && ((anno % 4 == 0 && anno % 100 != 0) || anno % 400 == 0)) return 29;
   if(mese < 1 || mese > 12) return 30;
   return g[mese - 1];
  }

//--- giorno del mese della N-esima domenica (N=1 -> la prima)
int DomenicaEnnesima(int anno, int mese, int n)
  {
   MqlDateTime st;
   TimeToStruct(CostruisciData(anno, mese, 1, 0), st);
   int prima = 1 + ((7 - st.day_of_week) % 7);   // day_of_week: 0 = domenica
   return prima + 7 * (n - 1);
  }

//--- giorno del mese dell'ULTIMA domenica
int UltimaDomenica(int anno, int mese)
  {
   int ultimo = GiorniMese(anno, mese);
   MqlDateTime st;
   TimeToStruct(CostruisciData(anno, mese, ultimo, 0), st);
   return ultimo - st.day_of_week;
  }

//--- tabella precalcolata: 2,5 milioni di barre x 2 TimeToStruct sarebbero
//    comunque veloci, ma il precalcolo rende la cosa gratis e ispezionabile
datetime g_usaIni[];     // locale NY, 02:00 della 2a domenica di marzo
datetime g_usaFin[];     // locale NY, 02:00 della 1a domenica di novembre
datetime g_euIniUtc[];   // UTC, 01:00 dell'ultima domenica di marzo
datetime g_euFinUtc[];   // UTC, 01:00 dell'ultima domenica di ottobre
bool     g_dstPronta = false;

void PreparaTabellaDst()
  {
   int n = DST_ANNO_MAX - DST_ANNO_MIN + 1;
   ArrayResize(g_usaIni, n);  ArrayResize(g_usaFin, n);
   ArrayResize(g_euIniUtc, n); ArrayResize(g_euFinUtc, n);
   for(int y = DST_ANNO_MIN; y <= DST_ANNO_MAX; y++)
     {
      int i = y - DST_ANNO_MIN;
      g_usaIni[i]   = CostruisciData(y,  3, DomenicaEnnesima(y, 3, 2), 2);
      g_usaFin[i]   = CostruisciData(y, 11, DomenicaEnnesima(y, 11, 1), 2);
      g_euIniUtc[i] = CostruisciData(y,  3, UltimaDomenica(y, 3), 1);
      g_euFinUtc[i] = CostruisciData(y, 10, UltimaDomenica(y, 10), 1);
     }
   g_dstPronta = true;
  }

void ConfiniUsa(int anno, datetime &ini, datetime &fin)
  {
   if(g_dstPronta && anno >= DST_ANNO_MIN && anno <= DST_ANNO_MAX)
     { int i = anno - DST_ANNO_MIN; ini = g_usaIni[i]; fin = g_usaFin[i]; return; }
   ini = CostruisciData(anno,  3, DomenicaEnnesima(anno, 3, 2), 2);
   fin = CostruisciData(anno, 11, DomenicaEnnesima(anno, 11, 1), 2);
  }

void ConfiniEu(int anno, datetime &ini, datetime &fin)
  {
   if(g_dstPronta && anno >= DST_ANNO_MIN && anno <= DST_ANNO_MAX)
     { int i = anno - DST_ANNO_MIN; ini = g_euIniUtc[i]; fin = g_euFinUtc[i]; return; }
   ini = CostruisciData(anno,  3, UltimaDomenica(anno, 3), 1);
   fin = CostruisciData(anno, 10, UltimaDomenica(anno, 10), 1);
  }

//--- l'ora LOCALE di New York cade dentro l'ora legale USA?
//    Nota sull'ora doppia: la prima domenica di novembre le lancette
//    tornano indietro e le 01:00-01:59 locali esistono DUE volte. Qui la
//    convenzione e': sotto le 02:00 vale ancora l'ora legale (la prima
//    passata). Riguarda al massimo 60 barre l'anno, di DOMENICA MATTINA
//    presto, quando i mercati sono chiusi e il nativo BCM non ha barre:
//    non tocca nessuna misura. Va detto, non nascosto.
bool UsaInDst(datetime tNy)
  {
   MqlDateTime st;
   TimeToStruct(tNy, st);
   datetime ini, fin;
   ConfiniUsa(st.year, ini, fin);
   return (tNy >= ini && tNy < fin);
  }

//--- l'istante UTC cade dentro l'ora legale europea?
//    (si valuta in UTC, dove il confine e' un istante unico e non
//     esistono ore doppie o mancanti: nessuna ambiguita')
bool EuInDst(datetime tUtc)
  {
   MqlDateTime st;
   TimeToStruct(tUtc, st);
   datetime ini, fin;
   ConfiniEu(st.year, ini, fin);
   return (tUtc >= ini && tUtc < fin);
  }

//+------------------------------------------------------------------+
//| AGGIUSTAMENTO DST: quante ore vanno AGGIUNTE allo shift base per |
//| un timestamp scritto in ora locale di New York.                  |
//|   0  = i due calendari sono d'accordo (93% dell'anno e passa)    |
//|  -1  = USA gia'/ancora in ora legale, Europa no (le finestre)    |
//|  +1  = il contrario: coi calendari attuali non accade            |
//+------------------------------------------------------------------+
int AggiustamentoDst(datetime tNy)
  {
   bool ny = UsaInDst(tNy);
   //  NY -> UTC e' un fatto, non dipende dal broker: EST = UTC-5, EDT = UTC-4
   datetime tUtc = (datetime)((long)tNy + (long)(ny ? 4 : 5) * 3600);
   bool eu = EuInDst(tUtc);
   return (eu ? 1 : 0) - (ny ? 1 : 0);
  }

//+==================================================================+
//|                          AUTOTEST                                |
//| Casi con l'atteso SCRITTO A MANO nel codice ai quattro confini,  |
//| piu' una batteria generata dalla regola su 21 anni (2010-2030).  |
//| Se questa parte non passa, l'import non si fa: importare con un  |
//| calendario rotto e' peggio che non importare.                    |
//+==================================================================+
int g_testFatti = 0, g_testRotti = 0;

void Verifica(string nome, datetime quando, int attesoTotale, int shiftBase)
  {
   int ottenuto = shiftBase + AggiustamentoDst(quando);
   g_testFatti++;
   bool ok = (ottenuto == attesoTotale);
   if(!ok) g_testRotti++;
   PrintFormat("   %-52s %s -> shift %+d (atteso %+d) %s",
               nome, TimeToString(quando, TIME_DATE|TIME_MINUTES),
               ottenuto, attesoTotale, (ok ? "OK" : "<<< ROTTO"));
  }

void VerificaInt(string nome, int ottenuto, int atteso)
  {
   g_testFatti++;
   bool ok = (ottenuto == atteso);
   if(!ok) g_testRotti++;
   PrintFormat("   %-52s = %d (atteso %d) %s", nome, ottenuto, atteso, (ok ? "OK" : "<<< ROTTO"));
  }

bool EseguiAutotest()
  {
   g_testFatti = 0; g_testRotti = 0;
   Print("=== AUTOTEST v2: CONVERSIONE DST NEW YORK -> SERVER EUROPEO ===");
   Print("shift base convenzionale del collaudo: +5 (quello misurato 3 volte su 3)");

   Print("--- A. le domeniche di cambio ora, calcolate ---");
   VerificaInt("2025 2a domenica di marzo",        DomenicaEnnesima(2025, 3, 2),  9);
   VerificaInt("2025 ultima domenica di marzo",    UltimaDomenica(2025, 3),      30);
   VerificaInt("2025 ultima domenica di ottobre",  UltimaDomenica(2025, 10),     26);
   VerificaInt("2025 1a domenica di novembre",     DomenicaEnnesima(2025, 11, 1), 2);
   VerificaInt("2024 2a domenica di marzo",        DomenicaEnnesima(2024, 3, 2), 10);
   VerificaInt("2024 ultima domenica di ottobre",  UltimaDomenica(2024, 10),     27);
   VerificaInt("2024 1a domenica di novembre",     DomenicaEnnesima(2024, 11, 1), 3);
   VerificaInt("2026 2a domenica di marzo",        DomenicaEnnesima(2026, 3, 2),  8);
   VerificaInt("2026 ultima domenica di marzo",    UltimaDomenica(2026, 3),      29);
   VerificaInt("2010 2a domenica di marzo",        DomenicaEnnesima(2010, 3, 2), 14);
   VerificaInt("2010 ultima domenica di ottobre",  UltimaDomenica(2010, 10),     31);
   VerificaInt("2010 1a domenica di novembre",     DomenicaEnnesima(2010, 11, 1), 7);
   VerificaInt("2030 2a domenica di marzo",        DomenicaEnnesima(2030, 3, 2), 10);
   VerificaInt("2030 ultima domenica di ottobre",  UltimaDomenica(2030, 10),     27);

   Print("--- B. CONFINE 1: entrata in ora legale USA (2a dom. marzo 02:00) ---");
   Verifica("sabato prima, inverno pieno",        D'2025.03.08 12:00', 5, 5);
   Verifica("domenica 01:00, ancora ora solare",  D'2025.03.09 01:00', 5, 5);
   Verifica("domenica 03:00, USA gia' legale",    D'2025.03.09 03:00', 4, 5);
   Verifica("lunedi dopo: finestra sfasata",      D'2025.03.10 12:00', 4, 5);

   Print("--- C. CONFINE 2: entrata in ora legale EU (ult. dom. marzo 01:00 UTC) ---");
   Verifica("sabato 20:00 NY, EU ancora solare",  D'2025.03.29 20:00', 4, 5);
   Verifica("sabato 21:00 NY = 01:00 UTC dom.",   D'2025.03.29 21:00', 5, 5);
   Verifica("lunedi dopo: calendari riallineati", D'2025.03.31 12:00', 5, 5);
   Verifica("luglio, estate piena",               D'2025.07.15 12:00', 5, 5);

   Print("--- D. CONFINE 3: uscita EU (ult. dom. ottobre 01:00 UTC) ---");
   Verifica("venerdi prima, ancora allineati",    D'2025.10.24 12:00', 5, 5);
   Verifica("sabato 20:00 NY, EU ancora legale",  D'2025.10.25 20:00', 5, 5);
   Verifica("sabato 21:00 NY = 01:00 UTC dom.",   D'2025.10.25 21:00', 4, 5);
   Verifica("lunedi dopo: finestra sfasata",      D'2025.10.27 12:00', 4, 5);

   Print("--- E. CONFINE 4: uscita USA (1a dom. novembre 02:00) ---");
   Verifica("domenica 01:00, USA ancora legale",  D'2025.11.02 01:00', 4, 5);
   Verifica("domenica 02:00, USA torna solare",   D'2025.11.02 02:00', 5, 5);
   Verifica("lunedi dopo: inverno allineato",     D'2025.11.03 12:00', 5, 5);
   Verifica("gennaio, inverno pieno",             D'2025.01.15 12:00', 5, 5);

   Print("--- F. le altre tre finestre del periodo di confronto ---");
   Verifica("2024: dentro finestra 27/10-03/11",  D'2024.10.28 12:00', 4, 5);
   Verifica("2024: fuori, dopo il 03/11",         D'2024.11.04 12:00', 5, 5);
   Verifica("2026: dentro finestra 08/03-29/03",  D'2026.03.09 12:00', 4, 5);
   Verifica("2026: fuori, dopo il 29/03",         D'2026.03.30 12:00', 5, 5);
   Verifica("2010: dentro finestra 31/10-07/11",  D'2010.11.01 12:00', 4, 5);
   Verifica("2010: fuori, dopo il 07/11",         D'2010.11.08 12:00', 5, 5);
   Verifica("2030: dentro finestra di marzo",     D'2030.03.11 12:00', 4, 5);
   Verifica("2030: dentro finestra di ottobre",   D'2030.10.28 12:00', 4, 5);

   Print("--- G. ANDATA E RITORNO: shift base +5, si torna al file ---");
   //  se converto e riconverto devo ritrovare lo stesso istante: e' la
   //  prova che la conversione non "perde" ore per strada
   datetime prova[8];
   prova[0] = D'2025.03.09 03:00'; prova[1] = D'2025.03.10 12:00';
   prova[2] = D'2025.06.15 20:00'; prova[3] = D'2025.10.27 12:00';
   prova[4] = D'2025.11.03 12:00'; prova[5] = D'2024.10.28 12:00';
   prova[6] = D'2026.03.09 12:00'; prova[7] = D'2019.01.02 09:00';
   int rotti = 0;
   for(int i = 0; i < 8; i++)
     {
      int      d    = AggiustamentoDst(prova[i]);
      datetime srv  = (datetime)((long)prova[i] + (long)(5 + d) * 3600);
      datetime back = (datetime)((long)srv - (long)(5 + d) * 3600);
      if(back != prova[i]) rotti++;
     }
   VerificaInt("andata e ritorno su 8 istanti (rotti)", rotti, 0);

   Print("--- H. REGOLA GENERALE su 21 anni (2010-2030), generata dal codice ---");
   Print("     per ogni anno: 4 confini + 2 controlli di mezza stagione");
   int annoRotti = 0;
   for(int y = 2010; y <= 2030; y++)
     {
      datetime uIni, uFin, eIni, eFin;
      ConfiniUsa(y, uIni, uFin);
      ConfiniEu(y, eIni, eFin);
      //  un'ora PRIMA dell'entrata USA: allineati. Un'ora DOPO: sfasati.
      if(AggiustamentoDst((datetime)((long)uIni - 3600)) != 0)  annoRotti++;
      if(AggiustamentoDst((datetime)((long)uIni + 3600)) != -1) annoRotti++;
      //  un'ora PRIMA dell'uscita USA: sfasati. All'istante: allineati.
      if(AggiustamentoDst((datetime)((long)uFin - 3600)) != -1) annoRotti++;
      if(AggiustamentoDst(uFin) != 0)                           annoRotti++;
      //  gennaio e luglio: sempre allineati
      if(AggiustamentoDst(CostruisciData(y, 1, 15, 12)) != 0)   annoRotti++;
      if(AggiustamentoDst(CostruisciData(y, 7, 15, 12)) != 0)   annoRotti++;
     }
   VerificaInt("controlli 2010-2030 falliti (su 126)", annoRotti, 0);

   Print("--- I. NESSUN +1: campionamento giornaliero 2010-2030 ---");
   //  coi calendari attuali l'aggiustamento puo' valere solo 0 o -1.
   //  Se un giorno spuntasse un +1 vorrebbe dire che una delle due regole
   //  e' cambiata: meglio saperlo da un test che da un backtest storto.
   int piuUno = 0, giorniSfasati = 0, giorniVisti = 0;
   for(int y = 2010; y <= 2030; y++)
      for(int m = 1; m <= 12; m++)
         for(int g = 1; g <= GiorniMese(y, m); g++)
           {
            int d = AggiustamentoDst(CostruisciData(y, m, g, 12));
            giorniVisti++;
            if(d > 0) piuUno++;
            if(d < 0) giorniSfasati++;
           }
   VerificaInt("giorni con aggiustamento +1 (atteso 0)", piuUno, 0);
   PrintFormat("   giorni sfasati (mezzogiorno NY): %d su %d = %.2f%% del calendario",
               giorniSfasati, giorniVisti, 100.0 * giorniSfasati / MathMax(giorniVisti, 1));
   Print("   atteso 6-7% sulla media 2010-2030 (5,7%-7,7% a seconda dell'anno):");
   Print("   2 o 3 settimane a marzo + 1 settimana fra fine ottobre e inizio novembre.");

   PrintFormat("=== AUTOTEST: %d controlli, %d ROTTI ===", g_testFatti, g_testRotti);
   if(g_testRotti == 0) Print("=== ESITO: OK - la conversione DST fa quello che dice. ===");
   else                 Print("=== ESITO: FALLITO - NON importare finche' non e' risolto. ===");
   return (g_testRotti == 0);
  }

//+------------------------------------------------------------------+
//| PARSING DELLE DATE                                               |
//| formato 0: "YYYYMMDD HHMMSS"  (HistData M1 ASCII)                |
//| formato 1: "YYYY.MM.DD HH:MM" (CSV generico; si tollerano anche  |
//|            i separatori "-" e la "T" ISO)                        |
//+------------------------------------------------------------------+
datetime LeggiData(string campo, int formato)
  {
   campo = Pulisci(campo);
   if(StringLen(campo) < 8) return 0;

   if(formato == 0)
     {
      // "20220103 170000" -> "2022.01.03 17:00:00"
      if(StringLen(campo) < 15) return 0;
      string d = StringSubstr(campo, 0, 4) + "." + StringSubstr(campo, 4, 2) + "." + StringSubstr(campo, 6, 2);
      string h = StringSubstr(campo, 9, 2) + ":" + StringSubstr(campo, 11, 2) + ":" + StringSubstr(campo, 13, 2);
      return StringToTime(d + " " + h);
     }

   StringReplace(campo, "-", ".");
   StringReplace(campo, "T", " ");
   StringReplace(campo, "/", ".");
   return StringToTime(campo);
  }

//+------------------------------------------------------------------+
//| CLONAZIONE DELLE PROPRIETA'                                      |
//| CustomSymbolCreate con simbolo di riferimento eredita tutto,     |
//| ma NON ci si fida: si ricopiano a mano le proprieta' che         |
//| decidono il P&L e poi si RILEGGONO per confronto.                |
//+------------------------------------------------------------------+
void CopiaIntero(string dst, string src, ENUM_SYMBOL_INFO_INTEGER p)
  {
   CustomSymbolSetInteger(dst, p, SymbolInfoInteger(src, p));
  }
void CopiaDouble(string dst, string src, ENUM_SYMBOL_INFO_DOUBLE p)
  {
   CustomSymbolSetDouble(dst, p, SymbolInfoDouble(src, p));
  }
void CopiaStringa(string dst, string src, ENUM_SYMBOL_INFO_STRING p)
  {
   CustomSymbolSetString(dst, p, SymbolInfoString(src, p));
  }

//  la tolleranza e' un parametro dal 14/08 (falso allarme sul tick_value:
//  MT5 lo ricalcola dal cambio corrente, quindi due letture a microsecondi
//  di distanza gia' differiscono di 9 parti per milione). Digits, point,
//  tick_size e contract_size sono fissi davvero e restano a 1e-9.
bool VerificaDouble(string etichetta, string src, string dst, ENUM_SYMBOL_INFO_DOUBLE p, double tolleranza = 1e-9)
  {
   double a = SymbolInfoDouble(src, p);
   double b = SymbolInfoDouble(dst, p);
   double rif = MathMax(MathAbs(a), 1e-12);
   bool   ok  = (MathAbs(a - b) / rif) < tolleranza;
   PrintFormat("   %-22s sorgente=%.10g   nuovo=%.10g   %s",
               etichetta, a, b, (ok ? "OK" : "<<< DIVERSO"));
   return ok;
  }
bool VerificaIntero(string etichetta, string src, string dst, ENUM_SYMBOL_INFO_INTEGER p)
  {
   long a = SymbolInfoInteger(src, p);
   long b = SymbolInfoInteger(dst, p);
   bool ok = (a == b);
   PrintFormat("   %-22s sorgente=%s   nuovo=%s   %s",
               etichetta, (string)a, (string)b, (ok ? "OK" : "<<< DIVERSO"));
   return ok;
  }

//+------------------------------------------------------------------+
//| Crea (o riusa) il custom symbol e ne allinea le proprieta'.      |
//| Ritorna il numero di proprieta' CRITICHE non allineate.          |
//+------------------------------------------------------------------+
int PreparaSimbolo(string src, string dst)
  {
   bool esiste = false;
   if(!CustomSymbolCreate(dst, "ABTG_EXT", src))
     {
      int err = GetLastError();
      if(err == 5304)   // ERR_CUSTOM_SYMBOL_EXIST: gia' creato in un giro precedente
        {
         esiste = true;
         ResetLastError();
         PrintFormat("Il custom symbol %s esiste gia': lo riuso.", dst);
        }
      else
        {
         PrintFormat("ERRORE: CustomSymbolCreate(%s) fallito, errore %d.", dst, err);
         return -1;
        }
     }
   if(!esiste) PrintFormat("Creato custom symbol %s (gruppo ABTG_EXT) clonando %s.", dst, src);

   CopiaIntero(dst, src, SYMBOL_DIGITS);
   CopiaIntero(dst, src, SYMBOL_TRADE_CALC_MODE);
   CopiaIntero(dst, src, SYMBOL_TRADE_MODE);
   CopiaIntero(dst, src, SYMBOL_TRADE_EXEMODE);
   CopiaIntero(dst, src, SYMBOL_SWAP_MODE);
   CopiaIntero(dst, src, SYMBOL_SWAP_ROLLOVER3DAYS);
   CopiaIntero(dst, src, SYMBOL_TRADE_STOPS_LEVEL);
   CopiaIntero(dst, src, SYMBOL_TRADE_FREEZE_LEVEL);
   CopiaIntero(dst, src, SYMBOL_FILLING_MODE);
   CopiaIntero(dst, src, SYMBOL_EXPIRATION_MODE);
   CopiaIntero(dst, src, SYMBOL_ORDER_MODE);
   CopiaIntero(dst, src, SYMBOL_CHART_MODE);
   CopiaIntero(dst, src, SYMBOL_SPREAD_FLOAT);

   CopiaDouble(dst, src, SYMBOL_POINT);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_SIZE);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE_LOSS);
   CopiaDouble(dst, src, SYMBOL_TRADE_CONTRACT_SIZE);
   CopiaDouble(dst, src, SYMBOL_VOLUME_MIN);
   CopiaDouble(dst, src, SYMBOL_VOLUME_MAX);
   CopiaDouble(dst, src, SYMBOL_VOLUME_STEP);
   CopiaDouble(dst, src, SYMBOL_VOLUME_LIMIT);
   CopiaDouble(dst, src, SYMBOL_MARGIN_INITIAL);
   CopiaDouble(dst, src, SYMBOL_MARGIN_MAINTENANCE);
   CopiaDouble(dst, src, SYMBOL_SWAP_LONG);
   CopiaDouble(dst, src, SYMBOL_SWAP_SHORT);

   CopiaStringa(dst, src, SYMBOL_CURRENCY_BASE);
   CopiaStringa(dst, src, SYMBOL_CURRENCY_PROFIT);
   CopiaStringa(dst, src, SYMBOL_CURRENCY_MARGIN);
   CustomSymbolSetString(dst, SYMBOL_DESCRIPTION,
                         "ABTG storico esterno clonato da " + src + " - SOLO prova di regime");

   SymbolSelect(dst, true);   // deve stare in Market Watch o il tester non lo vede

   Print("--- CONFRONTO PROPRIETA' (trappola 'unita' e valore punto') ---");
   int guasti = 0;
   if(!VerificaIntero("digits",          src, dst, SYMBOL_DIGITS))               guasti++;
   if(!VerificaDouble("point",           src, dst, SYMBOL_POINT))                guasti++;
   if(!VerificaDouble("tick_size",       src, dst, SYMBOL_TRADE_TICK_SIZE))      guasti++;
   if(!VerificaDouble("tick_value",      src, dst, SYMBOL_TRADE_TICK_VALUE, 1e-3)) guasti++;
   if(!VerificaDouble("contract_size",   src, dst, SYMBOL_TRADE_CONTRACT_SIZE))  guasti++;
   VerificaDouble("volume_min",     src, dst, SYMBOL_VOLUME_MIN);
   VerificaDouble("volume_step",    src, dst, SYMBOL_VOLUME_STEP);
   VerificaIntero("calc_mode",      src, dst, SYMBOL_TRADE_CALC_MODE);
   PrintFormat("   valuta profitto        sorgente=%s   nuovo=%s",
               SymbolInfoString(src, SYMBOL_CURRENCY_PROFIT),
               SymbolInfoString(dst, SYMBOL_CURRENCY_PROFIT));

   if(guasti > 0)
      PrintFormat("*** ERRORE: %d proprieta' CRITICHE non coincidono. NON usare questo "
                  "simbolo per misurare P&L finche' non e' risolto. ***", guasti);
   else
      Print("   -> le proprieta' critiche coincidono: i P&L sono confrontabili con BCM.");

   return guasti;
  }

//+------------------------------------------------------------------+
//| LETTURA DEL CSV                                                  |
//| Accetta sia ';' sia ',' come separatore. Le righe malformate si  |
//| CONTANO, non si ignorano in silenzio.                            |
//+------------------------------------------------------------------+
int LeggiCsv(string nomeFile, int formato, MqlRates &out[], int &scartate)
  {
   scartate = 0;
   int fh = FileOpen(nomeFile, FILE_READ|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE)
     {
      PrintFormat("ERRORE: non trovo MQL5\\Files\\%s (errore %d).", nomeFile, GetLastError());
      return -1;
     }

   int n = 0;
   int capienza = 600000;
   ArrayResize(out, capienza, 600000);
   int riga = 0;

   while(!FileIsEnding(fh) && !IsStopped())
     {
      string linea = FileReadString(fh);
      riga++;
      linea = Pulisci(linea);
      if(StringLen(linea) == 0) continue;

      StringReplace(linea, ";", ",");
      string campi[];
      int nc = StringSplit(linea, ',', campi);
      if(nc < 5) { scartate++; continue; }

      datetime t = LeggiData(campi[0], formato);
      if(t <= 0)
        {
         if(riga == 1 || StringFind(Pulisci(campi[0]), "time") >= 0
                      || StringFind(Pulisci(campi[0]), "Time") >= 0
                      || StringFind(Pulisci(campi[0]), "Date") >= 0) continue;
         scartate++;
         continue;
        }

      double o = StringToDouble(campi[1]);
      double h = StringToDouble(campi[2]);
      double l = StringToDouble(campi[3]);
      double c = StringToDouble(campi[4]);
      long   v = (nc >= 6 ? (long)StringToInteger(campi[5]) : 0);

      if(o <= 0.0 || h <= 0.0 || l <= 0.0 || c <= 0.0 || h < l ||
         h < o - 1e-12 || h < c - 1e-12 || l > o + 1e-12 || l > c + 1e-12)
        { scartate++; continue; }

      if(n >= capienza)
        {
         capienza += 600000;
         if(ArrayResize(out, capienza, 600000) < 0)
           { Print("ERRORE: memoria insufficiente per l'array delle barre."); FileClose(fh); return -1; }
        }

      out[n].time         = t;      // ora del FILE (locale New York): lo shift si applica DOPO
      out[n].open         = o;
      out[n].high         = h;
      out[n].low          = l;
      out[n].close        = c;
      out[n].tick_volume  = (v > 0 ? v : 1);
      out[n].real_volume  = 0;
      out[n].spread       = 0;
      n++;
     }
   FileClose(fh);
   ArrayResize(out, n);
   PrintFormat("CSV letto: %d righe totali, %d barre valide, %d righe scartate.", riga, n, scartate);
   return n;
  }

//+------------------------------------------------------------------+
//| ordinamento e doppioni                                           |
//+------------------------------------------------------------------+
void OrdinaPerTempo(MqlRates &r[], int lo, int hi)
  {
   while(lo < hi)
     {
      datetime pivot = r[(lo + hi) / 2].time;
      int i = lo, j = hi;
      while(i <= j)
        {
         while(r[i].time < pivot) i++;
         while(r[j].time > pivot) j--;
         if(i <= j)
           {
            if(i != j) { MqlRates tmp = r[i]; r[i] = r[j]; r[j] = tmp; }
            i++; j--;
           }
        }
      if(j - lo < hi - i) { OrdinaPerTempo(r, lo, j); lo = i; }
      else                { OrdinaPerTempo(r, i, hi); hi = j; }
     }
  }

int TogliDoppioni(MqlRates &r[], int n)
  {
   if(n <= 1) return n;
   int w = 0;
   for(int i = 1; i < n; i++)
     {
      if(r[i].time == r[w].time) r[w] = r[i];   // il piu' recente vince
      else { w++; if(w != i) r[w] = r[i]; }
     }
   int nuovo = w + 1;
   if(nuovo != n) PrintFormat("Rimossi %d timestamp doppi.", n - nuovo);
   return nuovo;
  }

//+==================================================================+
//|                MISURA DELLA DIFFERENZA CONTRO IL NATIVO          |
//|                                                                  |
//| Idea (dalla v1): nel periodo in cui il file importato e lo       |
//| storico NATIVO BCM si sovrappongono, la chiusura H1 e' la STESSA |
//| cosa vista da due feed. Se il fuso e' giusto le due serie quasi  |
//| coincidono; se e' sbagliato di un'ora, la differenza esplode.    |
//|                                                                  |
//| v2: la stessa misura si fa in DUE modalita' (shift fisso e       |
//| DST-aware) chiamando LA STESSA funzione. Un solo pezzo di        |
//| aritmetica = le due misure non possono raccontare due storie     |
//| diverse per colpa di un copia-incolla.                           |
//|                                                                  |
//| Perche' si puo' lavorare sui bucket H1 anche col DST: i due      |
//| cambi d'ora cadono ESATTAMENTE su un'ora piena (02:00 locale     |
//| USA, 01:00 UTC per l'EU), quindi tutte le M1 di una stessa ora   |
//| ricevono sempre lo stesso aggiustamento. Nessuna ora "mista".    |
//+==================================================================+
void MisuraDiff(const double &impClose[], const int &impDelta[], datetime impBase, int impSpan,
                const double &natClose[], datetime natBase, int natSpan,
                double point, int shiftBase, bool dstAware, bool completo,
                EsitoConfronto &out)
  {
   AzzeraEsito(out, shiftBase, dstAware);

   double somma = 0, sommaPrezzo = 0, maxd = 0;
   double sommaDentro = 0, prezzoDentro = 0, sommaFuori = 0, prezzoFuori = 0;
   int    cnt = 0, natInSovr = 0, cDentro = 0, cFuori = 0;
   datetime qmax = 0;

   double firmate[];
   if(completo) ArrayResize(firmate, impSpan);
   int nf = 0;

   for(int k = 0; k < impSpan; k++)
     {
      if(impClose[k] <= 0) continue;
      int  d     = (dstAware ? impDelta[k] : 0);
      long tnat  = (long)impBase + (long)k * 3600 + (long)(shiftBase + d) * 3600;
      int  kn    = (int)((tnat - (long)natBase) / 3600);
      if(kn < 0 || kn >= natSpan) continue;
      natInSovr++;                       // ora dell'importato dentro il range nativo
      if(natClose[kn] <= 0) continue;    // ora senza barra nativa (weekend/festivo/gap)
      double diff = impClose[k] - natClose[kn];
      double ad   = MathAbs(diff);
      somma += ad; sommaPrezzo += natClose[kn]; cnt++;
      if(ad > maxd) { maxd = ad; qmax = (datetime)tnat; }
      //  la spaccatura si fa SEMPRE sulle finestre vere del calendario,
      //  anche quando si misura lo shift fisso: e' l'unico modo di
      //  confrontare mela con mela fra le due modalita'
      if(impDelta[k] != 0) { sommaDentro += ad; prezzoDentro += natClose[kn]; cDentro++; }
      else                 { sommaFuori  += ad; prezzoFuori  += natClose[kn]; cFuori++;  }
      if(completo) { firmate[nf] = 100.0 * diff / natClose[kn]; nf++; }
     }

   if(point <= 0) point = 1.0;
   out.barre        = cnt;
   out.barreNative  = natInSovr;
   out.diffMediaPti = (cnt > 0 ? (somma / cnt) / point : 0);
   out.diffMaxPti   = maxd / point;
   out.diffMediaPct = (sommaPrezzo > 0 ? 100.0 * somma / sommaPrezzo : 0);
   out.coperturaPct = (natInSovr > 0 ? 100.0 * cnt / natInSovr : 0);
   out.quandoMax    = qmax;
   out.barreDentro  = cDentro;
   out.barreFuori   = cFuori;
   out.pctDentro    = (prezzoDentro > 0 ? 100.0 * sommaDentro / prezzoDentro : 0);
   out.pctFuori     = (prezzoFuori  > 0 ? 100.0 * sommaFuori  / prezzoFuori  : 0);
   out.valido       = (cnt >= 50);

   //--- diagnosi del residuo: mediana della differenza FIRMATA.
   //    Un errore di ORA da differenze che cambiano segno di continuo
   //    -> mediana vicina a zero. Uno STRUMENTO DIVERSO (indice cash
   //    contro CFD su future, valuta diversa, dividendi) da' uno
   //    scalino sempre dallo stesso lato -> mediana lontana da zero.
   //    Distinguere le due cose evita di curare la malattia sbagliata.
   if(completo && nf > 0)
     {
      ArrayResize(firmate, nf);
      ArraySort(firmate);
      out.biasMedianoPct = firmate[nf / 2];
      double sn = 0;
      for(int i = 0; i < nf; i++) sn += MathAbs(firmate[i] - out.biasMedianoPct);
      out.nettaPct = sn / nf;
     }
  }

//+------------------------------------------------------------------+
//| SCANSIONE DEGLI SHIFT (una modalita' per chiamata)               |
//| La tabella si stampa TUTTA: la scelta dev'essere ispezionabile,  |
//| non magica. Se il minimo non e' netto, il file e' sospetto.      |
//+------------------------------------------------------------------+
int ScansionaShift(const double &impClose[], const int &impDelta[], datetime impBase, int impSpan,
                   const double &natClose[], datetime natBase, int natSpan,
                   double point, int shiftMin, int shiftMax, bool dstAware, int &barreMigliori)
  {
   PrintFormat("   --- scansione %s ---", (dstAware ? "DST-AWARE (shift che segue i due calendari)"
                                                    : "SHIFT FISSO (metodo v1, controprova)"));
   Print("   base  |  diff media (points) |  diff media (%)  |  barre H1");
   int    migliore = 0;
   double miglioreDiff = -1;
   barreMigliori = 0;
   for(int s = shiftMin; s <= shiftMax; s++)
     {
      EsitoConfronto e;
      MisuraDiff(impClose, impDelta, impBase, impSpan, natClose, natBase, natSpan,
                 point, s, dstAware, false, e);
      if(e.barre <= 0)
        { PrintFormat("   %+5d |          (nessuna sovrapposizione)", s); continue; }
      PrintFormat("   %+5d | %20.1f | %15.4f%% | %8d", s, e.diffMediaPti, e.diffMediaPct, e.barre);
      // 50 barre H1 non fanno statistica: un minimo trovato su 3 barre e' rumore
      if(e.barre >= 50 && (miglioreDiff < 0 || e.diffMediaPti < miglioreDiff))
        { miglioreDiff = e.diffMediaPti; migliore = s; barreMigliori = e.barre; }
     }
   if(miglioreDiff < 0) { barreMigliori = 0; return 0; }
   PrintFormat("   -> minimo su base %+d ore (%d barre H1).", migliore, barreMigliori);
   return migliore;
  }

//+------------------------------------------------------------------+
//| scrittura delle barre sul custom symbol, a blocchi               |
//+------------------------------------------------------------------+
bool ScriviBarre(string dst, const MqlRates &r[], int n)
  {
   if(InpCancellaEsistente)
     {
      int tolte = CustomRatesDelete(dst, (datetime)0, D'2100.01.01');
      PrintFormat("Azzerato %s: %d barre rimosse.", dst, tolte);
     }
   int scritte = 0;
   MqlRates blocco[];
   for(int i = 0; i < n && !IsStopped(); i += BLOCCO)
     {
      int q = ((n - i) < BLOCCO ? (n - i) : BLOCCO);
      ArrayResize(blocco, q);
      for(int j = 0; j < q; j++) blocco[j] = r[i + j];
      int esito = CustomRatesUpdate(dst, blocco, (uint)q);
      if(esito < 0)
        {
         PrintFormat("ERRORE: CustomRatesUpdate fallito al blocco %d (errore %d).", i / BLOCCO, GetLastError());
         return false;
        }
      scritte += esito;
      if((i / BLOCCO) % 10 == 0) PrintFormat("   ... %d / %d barre scritte", i + q, n);
     }
   PrintFormat("Scritte %d barre M1 su %s (i TF superiori li ricostruisce MT5 da solo).", scritte, dst);
   return true;
  }

//+------------------------------------------------------------------+
//| REFERTO: si scrive IN CODA, una riga per simbolo importato       |
//+------------------------------------------------------------------+
void ScriviReferto(string dst, string src, int nBarre, int scartate,
                   datetime prima, datetime ultima,
                   const EsitoConfronto &usata, const EsitoConfronto &fisso,
                   int barreBase, int barreMeno1, int barrePiu1,
                   int scanFisso, int scanDst,
                   int guasti, string verdetto)
  {
   int fh = FileOpen(REFERTO, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh == INVALID_HANDLE)
     { PrintFormat("ATTENZIONE: non riesco a scrivere %s (errore %d).", REFERTO, GetLastError()); return; }
   if(FileSize(fh) == 0)
      FileWrite(fh, "Versione","SimboloEXT","SimboloSorgente","FileCsv","Formato","Barre","RigheScartate",
                    "PrimaData","UltimaData","ShiftBase","DstAware",
                    "BarreShiftBase","BarreShiftMeno1","BarreShiftPiu1",
                    "DiffMediaPct_USATA","DiffMediaPunti_USATA","DiffMaxPunti_USATA","QuandoDiffMax_USATA",
                    "BarreH1_USATA","CoperturaPct_USATA",
                    "DiffMediaPct_DENTRO_finestre","DiffMediaPct_FUORI_finestre",
                    "BiasMedianoPct","DiffMediaPct_NETTA_dal_bias",
                    "ScanMigliore_FISSO","ScanMigliore_DST",
                    "DiffMediaPct_FISSO","DiffMediaPunti_FISSO",
                    "ProprietaGuaste","Verdetto");
   FileSeek(fh, 0, SEEK_END);
   FileWrite(fh, VERSIONE, dst, src, InpFileCsv, (string)InpFormato, (string)nBarre, (string)scartate,
             TimeToString(prima, TIME_DATE|TIME_MINUTES),
             TimeToString(ultima, TIME_DATE|TIME_MINUTES),
             StringFormat("%+d", usata.shift), (InpShiftDstAware ? "SI" : "NO"),
             (string)barreBase, (string)barreMeno1, (string)barrePiu1,
             StringFormat("%.4f", usata.diffMediaPct),
             StringFormat("%.1f", usata.diffMediaPti),
             StringFormat("%.1f", usata.diffMaxPti),
             (usata.quandoMax > 0 ? TimeToString(usata.quandoMax, TIME_DATE|TIME_MINUTES) : "-"),
             (string)usata.barre,
             StringFormat("%.1f", usata.coperturaPct),
             StringFormat("%.4f", usata.pctDentro),
             StringFormat("%.4f", usata.pctFuori),
             StringFormat("%+.4f", usata.biasMedianoPct),
             StringFormat("%.4f", usata.nettaPct),
             StringFormat("%+d", scanFisso), StringFormat("%+d", scanDst),
             StringFormat("%.4f", fisso.diffMediaPct),
             StringFormat("%.1f", fisso.diffMediaPti),
             (string)guasti, verdetto);
   FileClose(fh);
   PrintFormat("Referto aggiornato: MQL5\\Files\\%s", REFERTO);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   PreparaTabellaDst();

   //=== MODO COLLAUDO: verifica il calendario ed esce ===================
   if(InpAutoTest)
     {
      Print("==============================================================");
      PrintFormat("=== %s - MODO AUTOTEST: NON viene importato nulla. ===", VERSIONE);
      Print("==============================================================");
      bool ok = EseguiAutotest();
      Comment("AUTOTEST " + VERSIONE + ": " + (ok ? "OK" : "FALLITO"));
      return;
     }

   string src = Pulisci(InpSimboloSorgente);
   string dst = Pulisci(InpSimboloNuovo);
   if(StringLen(dst) == 0) dst = src + "_EXT";

   Print("==============================================================");
   PrintFormat("=== IMPORT STORICO ESTERNO %s: %s -> %s ===", VERSIONE, InpFileCsv, dst);
   Print("=== REGOLA D'USO: prova di regime a parametri CONGELATI.  ===");
   Print("=== Su questi dati NON si ottimizza NULLA.                ===");
   PrintFormat("=== Conversione DST New York -> Europa: %s ===", (InpShiftDstAware ? "ATTIVA" : "DISATTIVATA"));
   Print("==============================================================");

   if(!SymbolSelect(src, true))
     { PrintFormat("ERRORE: il simbolo sorgente %s non esiste su questo broker.", src); return; }

   //--- 1. custom symbol + proprieta' ------------------------------------
   int guasti = PreparaSimbolo(src, dst);
   if(guasti < 0) return;

   //--- 2. lettura CSV (ora del file, nessuno shift applicato) -----------
   MqlRates rates[];
   int scartate = 0;
   int n = LeggiCsv(InpFileCsv, InpFormato, rates, scartate);
   if(n <= 0) { Print("ERRORE: nessuna barra utile nel file. Import annullato."); return; }

   bool disordinato = false;
   for(int i = 1; i < n; i++) if(rates[i].time < rates[i-1].time) { disordinato = true; break; }
   if(disordinato)
     {
      Print("ATTENZIONE: il file NON e' in ordine cronologico: riordino.");
      OrdinaPerTempo(rates, 0, n - 1);
     }
   n = TogliDoppioni(rates, n);
   ArrayResize(rates, n);

   PrintFormat("Barre importate: %d, dal %s al %s (ora del FILE = locale New York).",
               n, TimeToString(rates[0].time, TIME_DATE|TIME_MINUTES),
               TimeToString(rates[n-1].time, TIME_DATE|TIME_MINUTES));

   //--- 3. aggregazione H1 e confronto col nativo ------------------------
   double point = SymbolInfoDouble(src, SYMBOL_POINT);
   if(point <= 0) point = 1.0;

   //  storico NATIVO H1 (la prima risposta di CopyRates e' solo la cache:
   //  il resto arriva dopo, quindi si insiste)
   MqlRates nat[];
   int got = -1;
   for(int tent = 0; tent < 240 && !IsStopped(); tent++)
     {
      got = CopyRates(src, PERIOD_H1, rates[0].time, TimeCurrent(), nat);
      if(got > 0) break;
      Sleep(250);
     }

   EsitoConfronto eDst, eFisso;
   AzzeraEsito(eDst,   InpShiftOre, true);
   AzzeraEsito(eFisso, InpShiftOre, false);

   int shiftBase = InpShiftOre;
   //  il minimo trovato da ciascuna delle due scansioni: vanno nel referto,
   //  perche' "la base resta +5 in ENTRAMBE" e' uno dei controlli del gate
   //  (se il DST-aware sceglie una base diversa, il file non e' ora di NY)
   int migliorFisso = 0, migliorDst = 0;

   if(got <= 0)
      Print("ATTENZIONE: nessuno storico H1 nativo su " + src + ": impossibile calibrare "
            "e impossibile misurare. Si usa InpShiftOre e lo si DICHIARA nel referto.");
   else
     {
      PrintFormat("Storico nativo H1 di %s: %d barre, dal %s al %s.",
                  src, got, TimeToString(nat[0].time, TIME_DATE),
                  TimeToString(nat[got-1].time, TIME_DATE|TIME_MINUTES));

      //--- mappa delle chiusure native per ora piena
      datetime natBase = OraPiena(nat[0].time);
      int      natSpan = (int)(((long)OraPiena(nat[got-1].time) - (long)natBase) / 3600) + 1;
      double natClose[];
      if(natSpan > 0)
        {
         ArrayResize(natClose, natSpan); ArrayInitialize(natClose, 0.0);
         for(int i = 0; i < got; i++)
           {
            int k = (int)(((long)OraPiena(nat[i].time) - (long)natBase) / 3600);
            if(k >= 0 && k < natSpan) natClose[k] = nat[i].close;
           }

         //--- chiusure H1 IMPORTATE (close dell'ultima M1 di ogni ora)
         //    + aggiustamento DST del bucket, calcolato UNA VOLTA
         datetime impBase = OraPiena(rates[0].time);
         int      impSpan = (int)(((long)OraPiena(rates[n-1].time) - (long)impBase) / 3600) + 1;
         if(impSpan > 0)
           {
            double impClose[];  ArrayResize(impClose,  impSpan); ArrayInitialize(impClose,  0.0);
            long   impUltimo[]; ArrayResize(impUltimo, impSpan); ArrayInitialize(impUltimo, 0);
            int    impDelta[];  ArrayResize(impDelta,  impSpan); ArrayInitialize(impDelta,  0);
            for(int k = 0; k < impSpan; k++)
               impDelta[k] = AggiustamentoDst((datetime)((long)impBase + (long)k * 3600));
            for(int i = 0; i < n; i++)
              {
               int k = (int)(((long)OraPiena(rates[i].time) - (long)impBase) / 3600);
               if(k < 0 || k >= impSpan) continue;
               if((long)rates[i].time >= impUltimo[k]) { impUltimo[k] = (long)rates[i].time; impClose[k] = rates[i].close; }
              }

            Print("--- CALIBRAZIONE FUSO ORARIO (trappola 'fuso e DST') ---");
            int barreFisso = 0, barreDst = 0;
            migliorFisso = ScansionaShift(impClose, impDelta, impBase, impSpan, natClose, natBase, natSpan,
                                          point, -InpShiftMax, InpShiftMax, false, barreFisso);
            migliorDst   = migliorFisso;
            if(InpShiftDstAware)
               migliorDst = ScansionaShift(impClose, impDelta, impBase, impSpan, natClose, natBase, natSpan,
                                           point, -InpShiftMax, InpShiftMax, true, barreDst);

            if(InpAutoShift)
              {
               shiftBase = (InpShiftDstAware ? migliorDst : migliorFisso);
               if((InpShiftDstAware ? barreDst : barreFisso) <= 0)
                 {
                  shiftBase = InpShiftOre;
                  Print("   -> NESSUNA SOVRAPPOSIZIONE UTILE: si usa InpShiftOre e lo si dichiara.");
                 }
              }
            else
               PrintFormat("   [InpAutoShift=false] si usa comunque InpShiftOre = %+d.", InpShiftOre);

            if(InpShiftDstAware && migliorDst != migliorFisso)
               PrintFormat("   NOTA: la base migliore cambia fra le due modalita' (%+d fisso, %+d DST-aware). "
                           "E' possibile ma va guardato: se il file fosse EST FISSO il DST-aware peggiorerebbe.",
                           migliorFisso, migliorDst);

            //--- misure finali sullo shift base che si usa DAVVERO, in
            //    entrambe le modalita': il cancello si giudica sul numero
            //    nuovo, ma il vecchio resta stampato accanto come controprova
            MisuraDiff(impClose, impDelta, impBase, impSpan, natClose, natBase, natSpan,
                       point, shiftBase, false, true, eFisso);
            MisuraDiff(impClose, impDelta, impBase, impSpan, natClose, natBase, natSpan,
                       point, shiftBase, true, true, eDst);
           }
        }
     }

   //--- 4. applica lo shift barra per barra ------------------------------
   //  UNA SOLA passata: si legge l'aggiustamento sull'ora del file (locale
   //  New York), si stampano le finestre sfasate trovate NEI DATI (non da
   //  una tabella: sono i dati a dirlo) e si sposta il timestamp.
   int barreBase = 0, barreMeno1 = 0, barrePiu1 = 0;
   int runStampati = 0;
   Print("--- FINESTRE SFASATE TROVATE NEI DATI (shift diverso dalla base) ---");
   if(!InpShiftDstAware)
      Print("   [InpShiftDstAware=false] nessuna correzione applicata: shift COSTANTE.");
   else
     {
      PrintFormat("   base %+d ore; dentro le finestre lo shift diventa %+d.", shiftBase, shiftBase - 1);
      Print("      dal                ->  al                  shift   barre M1");
     }

   int    dPrec = 0;
   datetime runIni = 0, runFin = 0;
   int      runBarre = 0;
   for(int i = 0; i < n; i++)
     {
      int d = (InpShiftDstAware ? AggiustamentoDst(rates[i].time) : 0);
      if(d == 0)       barreBase++;
      else if(d == -1) barreMeno1++;
      else             barrePiu1++;

      if(d != dPrec)
        {
         if(dPrec != 0 && runBarre > 0 && runStampati < 60)
           {
            PrintFormat("      %s -> %s   %+d   %d",
                        TimeToString(runIni, TIME_DATE|TIME_MINUTES),
                        TimeToString(runFin, TIME_DATE|TIME_MINUTES),
                        shiftBase + dPrec, runBarre);
            runStampati++;
           }
         dPrec = d; runIni = rates[i].time; runBarre = 0;
        }
      if(d != 0) { if(runBarre == 0) runIni = rates[i].time; runFin = rates[i].time; runBarre++; }

      rates[i].time = (datetime)((long)rates[i].time + (long)(shiftBase + d) * 3600);
     }
   if(dPrec != 0 && runBarre > 0 && runStampati < 60)
     {
      PrintFormat("      %s -> %s   %+d   %d",
                  TimeToString(runIni, TIME_DATE|TIME_MINUTES),
                  TimeToString(runFin, TIME_DATE|TIME_MINUTES),
                  shiftBase + dPrec, runBarre);
      runStampati++;
     }
   if(runStampati >= 60) Print("      (elenco troncato a 60 finestre)");
   PrintFormat("   barre a shift base %+d: %d   |   a %+d: %d   |   a %+d: %d",
               shiftBase, barreBase, shiftBase - 1, barreMeno1, shiftBase + 1, barrePiu1);
   PrintFormat("   quota di barre corrette dal calendario: %.2f%% del totale.",
               100.0 * (barreMeno1 + barrePiu1) / MathMax(n, 1));

   //--- il calendario non deve poter rompere l'ordine cronologico:
   //    i cambi d'ora cadono di sabato notte/domenica mattina, quando i
   //    mercati sono chiusi, quindi in pratica non succede. Ma "in pratica"
   //    non e' una verifica: si controlla.
   bool rotto = false;
   for(int i = 1; i < n; i++) if(rates[i].time < rates[i-1].time) { rotto = true; break; }
   if(rotto)
     {
      Print("ATTENZIONE: lo shift variabile ha alterato l'ordine cronologico: riordino e ripulisco.");
      OrdinaPerTempo(rates, 0, n - 1);
      n = TogliDoppioni(rates, n);
      ArrayResize(rates, n);
     }
   else Print("   ordine cronologico integro dopo lo shift variabile: OK.");

   datetime prima = rates[0].time, ultima = rates[n-1].time;
   if(!ScriviBarre(dst, rates, n)) { Print("Import INTERROTTO in scrittura."); return; }

   //--- 5. verdetto e referto --------------------------------------------
   //  La soglia e' in PERCENTUALE di prezzo, cosi' vale sia su EURUSD sia
   //  sull'oro sia su un indice: due feed onesti sullo stesso strumento
   //  stanno sotto lo 0,05% sulle chiusure H1.
   //  (assegnazione esplicita, niente operatore ternario su struct)
   EsitoConfronto usata;
   AzzeraEsito(usata, shiftBase, InpShiftDstAware);
   if(InpShiftDstAware) usata = eDst;
   else                 usata = eFisso;

   string verdetto;
   if(guasti > 0)                      verdetto = "ERRORE UNITA: NON USARE";
   else if(!usata.valido)              verdetto = "SHIFT NON VERIFICATO (nessuna sovrapposizione)";
   else if(usata.diffMediaPct <= 0.05) verdetto = "OK CONFRONTABILE";
   else if(usata.diffMediaPct <= 0.20) verdetto = "DIFFERENZE FEED APPREZZABILI";
   else                                verdetto = "SOSPETTO: shift o simbolo sbagliato";

   Print("--- REFERTO ---");
   PrintFormat("   versione ............ %s", VERSIONE);
   PrintFormat("   simbolo EXT ......... %s (da %s)", dst, src);
   PrintFormat("   barre M1 ............ %d", n);
   PrintFormat("   righe scartate ...... %d", scartate);
   PrintFormat("   periodo ............. %s -> %s",
               TimeToString(prima, TIME_DATE|TIME_MINUTES), TimeToString(ultima, TIME_DATE|TIME_MINUTES));
   PrintFormat("   shift base .......... %+d ore (%s), DST-aware %s",
               shiftBase, (InpAutoShift ? "automatico" : "manuale"), (InpShiftDstAware ? "SI" : "NO"));
   PrintFormat("   minimo delle scansioni: FISSO %+d | DST-aware %+d  (devono coincidere:",
               migliorFisso, migliorDst);
   Print("                         se no, il file non e' ora locale di New York)");
   PrintFormat("   barre per shift ..... %+d: %d | %+d: %d | %+d: %d",
               shiftBase, barreBase, shiftBase - 1, barreMeno1, shiftBase + 1, barrePiu1);
   if(usata.valido)
     {
      Print("   --- LE DUE MISURE, UNA ACCANTO ALL'ALTRA ---");
      PrintFormat("   diff media H1 DST-AWARE ... %.4f%%   (%.1f points)", eDst.diffMediaPct, eDst.diffMediaPti);
      PrintFormat("   diff media H1 SHIFT FISSO . %.4f%%   (%.1f points)  <- controprova, metodo v1",
                  eFisso.diffMediaPct, eFisso.diffMediaPti);
      double guadagno = eFisso.diffMediaPct - eDst.diffMediaPct;
      PrintFormat("   guadagno della cura ....... %+.4f punti percentuali (%.1f%% della diff vecchia)",
                  guadagno, (eFisso.diffMediaPct > 0 ? 100.0 * guadagno / eFisso.diffMediaPct : 0.0));
      Print("   --- DOVE STAVA L'ERRORE (spaccatura sul calendario) ---");
      PrintFormat("   DST-aware:   dentro finestre %.4f%% (%d barre) | fuori %.4f%% (%d barre)",
                  eDst.pctDentro, eDst.barreDentro, eDst.pctFuori, eDst.barreFuori);
      PrintFormat("   shift fisso: dentro finestre %.4f%% (%d barre) | fuori %.4f%% (%d barre)",
                  eFisso.pctDentro, eFisso.barreDentro, eFisso.pctFuori, eFisso.barreFuori);
      Print("   Lettura: se col fisso il 'dentro' e' molto peggio del 'fuori' e col");
      Print("   DST-aware i due si assomigliano, la malattia era il calendario ed e'");
      Print("   curata. Se restano diversi, c'e' dell'altro e va cercato.");
      Print("   --- DIAGNOSI DEL RESIDUO ---");
      PrintFormat("   bias mediano (differenza FIRMATA) ... %+.4f%% del prezzo", eDst.biasMedianoPct);
      PrintFormat("   diff media al netto del bias ........ %.4f%%", eDst.nettaPct);
      Print("   Lettura: bias vicino a zero = due feed sullo stesso strumento, il");
      Print("   residuo e' rumore/orari. Bias grande e sempre dello stesso segno =");
      Print("   strumenti DIVERSI (indice cash contro CFD su future, dividendi,");
      Print("   valuta): quello NON si cura col fuso e va dichiarato, non limato.");
      PrintFormat("   diff massima H1 ..... %.1f points il %s",
                  eDst.diffMaxPti, TimeToString(eDst.quandoMax, TIME_DATE|TIME_MINUTES));
      PrintFormat("   copertura ........... %.1f%% (%d ore H1 in ENTRAMBI i feed, su %d ore",
                  eDst.coperturaPct, eDst.barre, eDst.barreNative);
      Print("                         importate che cadono dentro il periodo nativo BCM)");
     }
   else
      Print("   confronto con il nativo: NON DISPONIBILE (nessuna sovrapposizione)");
   PrintFormat("   VERDETTO ............ %s", verdetto);
   Print("   (il verdetto si giudica sulla misura USATA: DST-aware se attivo)");

   ScriviReferto(dst, src, n, scartate, prima, ultima, usata, eFisso,
                 barreBase, barreMeno1, barrePiu1,
                 migliorFisso, migliorDst, guasti, verdetto);

   Print("Per testare: nel tester scegli il simbolo " + dst + " e usa il modello");
   Print("'OHLC su M1' (walkforward_generico -Modello 1) oppure 'ogni tick' generato");
   Print("dalle M1 (-Modello 0). MAI il modello 4 (tick reali): i tick reali NON");
   Print("esistono per un simbolo costruito da barre, e il tester li inventerebbe.");
   Comment("Import " + dst + " " + VERSIONE + " COMPLETATO: " + verdetto);
  }
//+------------------------------------------------------------------+
