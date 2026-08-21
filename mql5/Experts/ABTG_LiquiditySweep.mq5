//+------------------------------------------------------------------+
//|                                        ABTG_LiquiditySweep.mq5    |
//|                                                                  |
//|  EA "LIQSWEEP" - SWEEP + RECLAIM su livello strutturale.          |
//|                                                                  |
//|  DA DOVE VIENE -- ATTRIBUZIONE, come da regola di casa:           |
//|    il MOTORE e' ripreso da "Liquidity Sweep H4 - M15 (Swing Highs |
//|    and Lows)" di OsmarSandovalEspinosa, MQL5 Code Base, 2026.03.23|
//|    https://www.mql5.com/en/code/68951  (287 righe, 3 input).      |
//|    Sorgente scaricato e letto riga per riga il 19/08/2026.        |
//|    Dossier di caccia che lo ha promosso:                          |
//|    backtest_pipeline/caccia_strategie/                            |
//|                     CACCIA_LONDRA_MECCANISMI_2026-08-19.md        |
//|                                                                  |
//|  QUI: motore FEDELE, gestione RIFATTA a standard ABTG. Il dossier |
//|  lo dice cosi': "motore sano, gestione da rifare".                |
//|                                                                  |
//|  IL MOTORE, in tre righe (e sono le tre dell'originale):          |
//|    1. LIVELLO -- su ogni barra chiusa del TF di struttura (H4) si  |
//|       marca uno swing se la barra candidata ha high (o low) non    |
//|       superato (o non bucato) da nessuna delle InpSwingBars barre  |
//|       a SINISTRA e a DESTRA. Con 21 per lato su H4 il livello e'   |
//|       confermato ~3 giorni e mezzo dopo essersi formato: e' un     |
//|       livello costruito in GIORNI, non in 15 minuti.               |
//|    2. GRILLETTO -- su chiusura di barra del TF operativo (M15):    |
//|         high[1] > livello  E  close[1] < livello  -> SHORT         |
//|         low[1]  < livello  E  close[1] > livello  -> LONG          |
//|       cioe': il prezzo ha BUCATO il livello ed e' RIENTRATO alla   |
//|       chiusura. La conferma e' il RIENTRO, non la rottura.         |
//|    3. IL LIVELLO SI CONSUMA -- dopo l'uso sparisce. E sparisce     |
//|       anche quando viene rotto in modo pulito (close oltre): un    |
//|       livello vale UNA VOLTA SOLA.                                 |
//|                                                                  |
//|  TESI DI MERCATO (dal dossier, e regge scritta):                  |
//|    uno swing strutturale vecchio di giorni e' dove stanno gli stop |
//|    di chi lo ha visto; il prezzo li va a prendere e, se il flusso  |
//|    vero non c'era, la stessa candela lo riporta dentro -- e chi e' |
//|    entrato sulla rottura diventa il carburante del ritorno.        |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in         |
//|  forward finche' un round a TICK REALI non lo promuove. I file     |
//|  prova del round R89 stanno in backtest_pipeline/prove/.           |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti e niente       |
//|  emoji dentro le stringhe.                                        |
//+------------------------------------------------------------------+
//                                                                    |
//  CHANGELOG                                                         |
//                                                                    |
//  v1.00 -- 19/08/2026. Prima stesura ABTG dal sorgente originale.    |
//                                                                    |
//    [FIX 1 -- IL BUG DELL'ARRAY, quello che il dossier chiede di     |
//     correggere PRIMA di qualunque misura]                           |
//     L'originale dichiara `double SwingHighs[100];` e alle righe     |
//     216-217 / 226-227 scrive `SwingHighs[SwingHighCount] = ...;     |
//     SwingHighCount++;` SENZA NESSUN CONTROLLO sul limite. Al 101simo|
//     swing scrive FUORI dall'array: in un backtest lungo -- ed e'    |
//     l'unico tipo di backtest che vale qualcosa in questa casa --    |
//     l'EA misura spazzatura o si pianta. Qui i livelli stanno in     |
//     ARRAY DINAMICI (ArrayResize) con un tetto dichiarato            |
//     (InpMaxLivelli): al tetto si butta il PIU' VECCHIO, non si      |
//     scrive oltre la fine. Nessuna scrittura fuori indice e' piu'    |
//     possibile: ogni accesso passa da ArraySize().                    |
//                                                                    |
//    [FIX 2 -- LA CANCELLAZIONE CHE NON CANCELLAVA]                   |
//     La `ArrayModify()` dell'originale (righe 270-283) fa scorrere   |
//     gli elementi a sinistra ma NON accorcia l'array: l'ultimo       |
//     elemento resta DUPLICATO in coda. Quel duplicato e' un livello  |
//     gia' consumato che puo' sparare un secondo trade. Qui la        |
//     rimozione fa ArrayResize(n-1): la coda si accorcia davvero.     |
//                                                                    |
//    [FIX 3 -- LA BARRA 0 FUORI DALLA FINESTRA DELLO SWING]           |
//     Alla riga 200 dell'originale, con i=Range, `high4(Range-i)`     |
//     diventa `high4(0)`: la barra H4 IN FORMAZIONE. Non e'           |
//     look-ahead (la barra 0 e' presente, non futura), ma rende la    |
//     definizione dello swing INSTABILE: dipende da quanto e' piena   |
//     la candela in corso nel momento in cui viene valutata. Qui la   |
//     barra candidata e' l'indice InpSwingBars+1, cosi' le            |
//     InpSwingBars barre "a destra" sono gli indici InpSwingBars..1,  |
//     TUTTE CHIUSE, e la barra 0 non entra mai nel confronto.         |
//                                                                    |
//    [RIFATTA LA GESTIONE -- era la parte debole dichiarata]          |
//     - lotto: era SYMBOL_VOLUME_MIN fisso -> ora rischio % con       |
//       sizing dalla DISTANZA DELLO STOP (pattern ABTG_PTE, con la    |
//       lezione 225JPY: perdita per lotto da OrderCalcProfit);        |
//     - SL: era 100 punti fissi (scala sbagliata su oro e indici) ->  |
//       ora strutturale oltre l'estremo dello sweep, o ATR puro;      |
//     - TP: era RR=1 secco -> ora InpTP_RR, con parziale opzionale,   |
//       breakeven e trailing opzionale;                               |
//     - aggiunti: filtro spread, filtro notizie, Guardian del conto,  |
//       finestra di sessione OPT-IN, autotest del nucleo puro.        |
//                                                                    |
//    [COSA NON E' STATO TOCCATO, e va detto]                          |
//     Nessun precaricamento dei livelli all'avvio: come l'originale,  |
//     i livelli si accumulano barra per barra da quando l'EA parte.   |
//     Costa un rodaggio di ~InpSwingBars barre H4 (~3,5 giorni) a     |
//     inizio backtest. Su finestre di anni e' irrilevante; su una     |
//     finestra di settimane NO, e allora va dichiarato.               |
//                                                                    |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - motore da OsmarSandovalEspinosa (MQL5 Code Base 68951)"
#property version   "1.10"
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
//    Non tocca MAI le posizioni gia' aperte, i parziali, il trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Motore: swing strutturale + sweep/reclaim ==="
//  Il TF su cui si costruiscono i LIVELLI. L'originale lo aveva scritto
//  fisso a H4; qui e' un input perche' il round deve poterlo spazzolare.
//  Il TF del SEGNALE e' invece quello del GRAFICO (PERIOD_CURRENT), che
//  nei file prova si pinna con @PERIODO (M15 nell'originale).
input ENUM_TIMEFRAMES InpTF_Struttura = PERIOD_H4;  // TF dei livelli (originale: H4)
//  Barre di conferma PER LATO. 21 su H4 = ~3,5 giorni di accumulo per lato.
//  E' il parametro che decide QUANTI livelli esistono, e quindi la
//  FREQUENZA del motore: il dossier avverte che con 21 il campione
//  potrebbe non arrivare ai 150 trade IS dell'Emendamento della Finestra.
input int    InpSwingBars   = 21;      // Barre di conferma per lato (originale: 21)
input bool   InpAllowLong   = true;    // Ammetti i LONG (reclaim dal basso)
input bool   InpAllowShort  = true;    // Ammetti gli SHORT (reclaim dall'alto)
//  Tetto sul numero di livelli vivi per lato. E' il FIX 1: l'originale
//  aveva un array fisso da 100 e ci scriveva dentro senza guardare.
//  Al tetto si butta il PIU' VECCHIO. 200 e' largo: su H4 con 21 barre di
//  conferma i livelli vivi contemporaneamente sono tipicamente decine.
input int    InpMaxLivelli  = 200;     // Tetto livelli vivi per lato (anti-overflow)

input group "=== Finestra di sessione (OPT-IN: il gradino B del round) ==="
//  ATTENZIONE, LEGGERE PRIMA DI USARE QUESTI QUATTRO NUMERI.
//
//  L'ORA DI LONDRA IN ORA SERVER, NEI NOSTRI FILE, HA TRE VALORI DIVERSI:
//     REGISTRO_TEST.md (Londra_ORB)      -> "range 06-07 server"
//     REFERTO_ROUND45_LONDRA.md          -> "range 07:00 -> 07:15/07:30 server"
//     regola di casa (server BCM = ora IT - 1) -> apertura alle 08:00 server
//  Tre posti, tre numeri. NON NE INVENTIAMO UNO.
//  Il default 8:00-12:00 qui sotto e' un SEGNAPOSTO, non una misura: il
//  round R89b DEVE spazzolare l'asse orario (6 / 7 / 8) e il numero vero
//  va letto sull'orologio del server prima di dichiarare qualunque esito.
//
//  L'ora e' SEMPRE quella del SERVER, mai quella del PC: le schede
//  Esperti e Giornale di MT5 stampano in ora LOCALE, il grafico in ora
//  SERVER. Chi confronta le due cose annuncia ritardi che non esistono.
//
//  La finestra si valuta sull'ora di APERTURA della barra di SEGNALE [1]
//  (coerente con gli altri EA di casa), ed e' [inizio, fine): la barra che
//  apre esattamente all'ora di fine e' gia' FUORI.
//  Inizio == fine  -> finestra nulla = nessun vincolo (tutto il giorno).
input bool   InpUseSessionWindow = false; // Accendi la finestra di sessione (default: motore nudo)
input int    InpSessStartHour    = 8;     // Ora SERVER di inizio -- SEGNAPOSTO, da spazzolare (6/7/8)
input int    InpSessStartMin     = 0;     // Minuto di inizio
input int    InpSessEndHour      = 12;    // Ora SERVER di fine (ESCLUSA) -- SEGNAPOSTO
input int    InpSessEndMin       = 0;     // Minuto di fine

input group "=== Stop, target, gestione ==="
input int    InpAtrPeriod    = 14;    // Periodo ATR (sul TF del GRAFICO, non su quello dei livelli)
//  InpSLMode:
//    0 = STRUTTURALE. Lo stop va OLTRE L'ESTREMO DELLO SWEEP -- cioe'
//        oltre il massimo (o il minimo) della barra che ha violato il
//        livello -- piu' InpSLBufferAtr x ATR di respiro. E' il modo
//        coerente con la tesi: se il prezzo torna oltre quell'estremo,
//        lo sweep non era uno sweep, era una rottura vera.
//        NOTA DI MAPPATURA REGOLA<->CODICE: "oltre lo swing violato" e'
//        materializzato dall'ESTREMO DELLA BARRA che lo ha violato, che
//        per costruzione sta sempre oltre il livello stesso. Mettere lo
//        stop sul livello nudo lo metterebbe DENTRO la mecha gia'
//        percorsa dal prezzo in quella stessa candela.
//    1 = ATR PURO. SL = InpSLatr x ATR dal prezzo d'ingresso. Serve come
//        termine di paragone, per sapere quanto della prestazione viene
//        dalla STRUTTURA e quanto dalla semplice volatilita'.
//  AVVISO DI SCALA: l'ATR e' quello del TF del GRAFICO (M15 nella
//  configurazione dell'originale). 1,5 x ATR(M15) e' uno stop PICCOLO
//  rispetto a uno sweep di un livello H4: il modo 1 non e' il gemello
//  del modo 0, e' un'altra misura. Va letto sapendolo.
input int    InpSLMode       = 0;     // 0 = strutturale (oltre lo sweep) | 1 = ATR puro
input double InpSLBufferAtr  = 0.5;   // (modo 0) respiro oltre l'estremo dello sweep, in ATR
input double InpSLatr        = 1.5;   // (modo 1) SL = X * ATR
input double InpTP_RR        = 2.0;   // TP = X volte R (0 = nessun TP)
input double InpTP1_RR       = 1.0;   // Primo target, in R (parziale e/o breakeven)
input double InpTP1Pct       = 0;     // % chiusa al primo target (0 = parziale SPENTO)
//  LEZIONE PTE del 04/08/2026, scritta nel codice perche' e' costata:
//  lo STOP IN PARI non dipende ne' dalla riuscita del parziale ne'
//  dall'essere il parziale acceso. Con InpTP1Pct=0 il livello InpTP1_RR
//  resta comunque il grilletto del breakeven. Se si vuole misurare il
//  motore SENZA breakeven, si spegne QUESTO input, non il parziale.
input bool   InpBreakeven    = true;  // Stop in pari al primo target (indipendente dal parziale)
input bool   InpUseTrailing  = false; // Trailing dello stop a distanza ATR (opt-in)
input double InpTrailATR     = 1.5;   // (se trailing acceso) distanza in ATR dal prezzo

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay = 0;  // Max ingressi al giorno (0 = illimitato)

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;    // Rischio per trade, % del saldo

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 60;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "LIQSWEEP";  // Commento sugli ordini
input long   InpMagic     = 772600;      // Numero magico (verificato libero nel repo il 19/08/2026)
input int    InpMaxSpread = 0;           // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose   = true;        // Messaggi nel log
input bool   InpAutoTest  = true;        // Stampa le righe [LIQSWEEP][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // TF del SEGNALE = quello del grafico (@PERIODO nel file prova)

int      hAtr = INVALID_HANDLE;
datetime gLastBarSegnale   = 0;
datetime gLastBarStruttura = 0;
int      gDay = -1, gTradesToday = 0;

//--- I LIVELLI. Array DINAMICI: e' il FIX 1 del changelog.
struct SLivello
  {
   double   prezzo;   // il livello (high o low dello swing)
   datetime nato;     // ora della barra di struttura da cui viene: identita' del livello
  };
SLivello gAlti[];     // swing high vivi (candidati SHORT sul reclaim)
SLivello gBassi[];    // swing low vivi  (candidati LONG sul reclaim)

//--- METRICHE DA PROP: una prop non ti chiude per l'Equity DD totale, ti
//    chiude per il LIMITE GIORNALIERO. Qui si segue l'equity dentro la
//    giornata e si tiene la caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

//--- diagnostica del round: quanti livelli sono stati creati / consumati /
//    invalidati. Serve a rispondere alla domanda "arriva a 150 trade?"
//    PRIMA di leggere il conto economico.
long gLivCreati = 0, gLivConsumati = 0, gLivInvalidati = 0, gSegnaliScartati = 0;

//--- calendario notizie (caricato da CSV in OnInit se il filtro e' acceso).
//    Sta QUI, in cima, e non accanto alle sue funzioni: cosi' nessuna
//    funzione del file puo' riferirsi a una globale non ancora dichiarata.
datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[LIQSWEEP] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| LO SWING. centro = high (o low) della barra candidata, vicini[] = |
//| tutte le barre da confrontare (a sinistra E a destra).            |
//| massimo=true cerca uno swing high, false uno swing low.           |
//| Confronto NON stretto sui pari (come l'originale): due massimi    |
//| uguali non annullano lo swing.                                    |
//+------------------------------------------------------------------+
bool EstremoConfermato_Calc(const double centro,const double &vicini[],const bool massimo)
  {
   int n=ArraySize(vicini);
   if(n<=0) return(false);                 // senza vicini non si conferma niente
   for(int i=0;i<n;i++)
     {
      if(massimo  && centro<vicini[i]) return(false);
      if(!massimo && centro>vicini[i]) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| IL GRILLETTO. Sweep di uno swing HIGH: la barra ha bucato sopra   |
//| ed e' RIENTRATA sotto alla chiusura -> segnale SHORT.             |
//+------------------------------------------------------------------+
bool SweepAlto_Calc(const double high1,const double close1,const double livello)
  {
   return(high1>livello && close1<livello);
  }

//+------------------------------------------------------------------+
//| Sweep di uno swing LOW: bucato sotto, rientrato sopra -> LONG.    |
//+------------------------------------------------------------------+
bool SweepBasso_Calc(const double low1,const double close1,const double livello)
  {
   return(low1<livello && close1>livello);
  }

//+------------------------------------------------------------------+
//| INVALIDAZIONE. La barra ha CHIUSO oltre il livello: non e' uno    |
//| sweep, e' una rottura vera. Il livello non vale piu'.             |
//| Le due condizioni sono mutuamente esclusive con lo sweep, per     |
//| costruzione (close sotto vs close sopra lo stesso numero).        |
//+------------------------------------------------------------------+
bool RottoAlto_Calc(const double close1,const double livello){ return(close1>livello); }
bool RottoBasso_Calc(const double close1,const double livello){ return(close1<livello); }

//+------------------------------------------------------------------+
//| LO STOP STRUTTURALE. estremoSweep = il massimo (o il minimo) che  |
//| ha violato il livello; il buffer e' in ATR.                       |
//+------------------------------------------------------------------+
double StopStrutturale_Calc(const bool isLong,const double estremoSweep,
                            const double atr,const double bufferAtr)
  {
   double b = atr*bufferAtr;
   return(isLong ? estremoSweep-b : estremoSweep+b);
  }

//+------------------------------------------------------------------+
//| LA FINESTRA DI SESSIONE. Tutto in MINUTI dalla mezzanotte, ORA    |
//| SERVER. Intervallo [inizio, fine): fine ESCLUSA.                  |
//| inizio == fine -> nessun vincolo (finestra nulla = tutto il giorno)|
//| inizio > fine  -> fascia a cavallo della mezzanotte.              |
//+------------------------------------------------------------------+
bool FinestraOK_Calc(const int minutiBarra,const int minutiInizio,const int minutiFine)
  {
   if(minutiInizio==minutiFine) return(true);
   if(minutiInizio<minutiFine)  return(minutiBarra>=minutiInizio && minutiBarra<minutiFine);
   return(minutiBarra>=minutiInizio || minutiBarra<minutiFine);
  }

//==================================================================
//  I LIVELLI -- array dinamici. FIX 1 e FIX 2 del changelog.
//==================================================================

//+------------------------------------------------------------------+
//| RIMOZIONE VERA: fa scorrere a sinistra E ACCORCIA l'array.        |
//| E' il FIX 2: la ArrayModify() dell'originale non accorciava, e    |
//| lasciava l'ultimo elemento DUPLICATO in coda -- cioe' un livello  |
//| gia' consumato che poteva sparare un secondo trade.               |
//+------------------------------------------------------------------+
void LivelloRimuovi(SLivello &arr[],const int idx)
  {
   int n=ArraySize(arr);
   if(idx<0 || idx>=n) return;
   for(int i=idx;i<n-1;i++) arr[i]=arr[i+1];
   ArrayResize(arr,n-1);
  }

//+------------------------------------------------------------------+
//| AGGIUNTA SICURA: nessuna scrittura fuori indice e' possibile,     |
//| l'array cresce con ArrayResize. Al tetto InpMaxLivelli si butta   |
//| il PIU' VECCHIO (indice 0). E' il FIX 1.                          |
//+------------------------------------------------------------------+
void LivelloAggiungi(SLivello &arr[],const double prezzo,const datetime nato)
  {
   int n=ArraySize(arr);
   for(int i=0;i<n;i++)
      if(arr[i].nato==nato && arr[i].prezzo==prezzo) return;   // gia' presente: niente doppioni

   if(n>=InpMaxLivelli)
     {
      LivelloRimuovi(arr,0);
      n=ArraySize(arr);
      Log("tetto livelli raggiunto: buttato il piu' vecchio (nessun overflow).");
     }

   if(ArrayResize(arr,n+1)!=n+1)
     { Log("ArrayResize fallita: livello NON aggiunto."); return; }

   arr[n].prezzo = prezzo;
   arr[n].nato   = nato;
   gLivCreati++;
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   ArrayResize(gAlti,0);
   ArrayResize(gBassi,0);

   //--- validazioni: meglio un init fallito che un round da buttare
   if(InpSwingBars<2)
     { Print("ERRORE: InpSwingBars deve essere >= 2 (barre di conferma per lato)."); return(INIT_FAILED); }
   if(InpMaxLivelli<10)
     { Print("ERRORE: InpMaxLivelli deve essere >= 10."); return(INIT_FAILED); }
   if(InpSLMode!=0 && InpSLMode!=1)
     { Print("ERRORE: InpSLMode ammette solo 0 (strutturale) o 1 (ATR puro)."); return(INIT_FAILED); }
   if(InpSLMode==0 && InpSLBufferAtr<0)
     { Print("ERRORE: InpSLBufferAtr non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSLMode==1 && InpSLatr<=0)
     { Print("ERRORE: InpSLatr deve essere > 0: senza stop non si dimensiona il lotto."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }
   if(InpTP1_RR<=0)
     { Print("ERRORE: InpTP1_RR deve essere > 0."); return(INIT_FAILED); }
   if(InpUseTrailing && InpTrailATR<=0)
     { Print("ERRORE: con il trailing acceso InpTrailATR deve essere > 0."); return(INIT_FAILED); }
   if(InpSessStartHour<0 || InpSessStartHour>23 || InpSessEndHour<0 || InpSessEndHour>23 ||
      InpSessStartMin <0 || InpSessStartMin >59 || InpSessEndMin <0 || InpSessEndMin >59)
     { Print("ERRORE: ore 0-23 e minuti 0-59 nella finestra di sessione."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }

   //--- il TF dei livelli deve stare SOPRA quello del segnale: e' il senso
   //    stesso del motore (livello costruito in giorni, grilletto in minuti).
   int secStr = PeriodSeconds(InpTF_Struttura);
   int secSeg = PeriodSeconds((ENUM_TIMEFRAMES)Period());
   if(secStr<secSeg)
     { Print("ERRORE: il TF dei livelli e' PIU' BASSO di quello del grafico. Il motore non ha senso cosi'."); return(INIT_FAILED); }
   if(secStr==secSeg)
      Log("ATTENZIONE: TF dei livelli UGUALE a quello del grafico. E' un'altra strategia, non quella dell'originale.");

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione: se una gamba opzionale e' accesa la
   //    cella NON e' la cella nuda. Non la spegne l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova la pinna. Se questa riga compare
   //    nel log di una cella "nuda", quella cella e' da buttare.
   if(InpUseSessionWindow || InpUseNewsFilter || InpUseTrailing || InpTP1Pct>0 ||
      InpMaxTradesPerDay>0 || InpSLMode!=0)
      Log("ATTENZIONE: c'e' almeno una GAMBA OPZIONALE accesa. Questa cella NON e' il motore nudo.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestLiqSweep();

   Log(StringFormat("avviato su %s. Livelli su %s con %d barre per lato; segnale su %s. "
                    "SLmode %d (buffer %.2f ATR / %.2f ATR), TP %.2f R, rischio %.2f%%, magic %I64d.",
       _Symbol, EnumToString(InpTF_Struttura), InpSwingBars,
       EnumToString((ENUM_TIMEFRAMES)Period()),
       InpSLMode, InpSLBufferAtr, InpSLatr, InpTP_RR, InpRiskPercent, InpMagic));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
   //--- QUESTA RIGA STAMPA SEMPRE, anche con InpVerbose=0, ed e' voluto:
   //    e' il CANARINO del round. Il dossier avverte che con 21 barre di
   //    conferma i livelli sono pochi e il campione potrebbe non arrivare
   //    ai 150 trade IS dell'Emendamento della Finestra. Questi quattro
   //    numeri lo dicono PRIMA di guardare il conto economico, e sono una
   //    riga per passata: non allagano niente.
   PrintFormat("[LIQSWEEP][CONTEGGIO] livelli creati %I64d | consumati da uno sweep %I64d | "
               "invalidati da una rottura %I64d | segnali scartati dai filtri %I64d",
               gLivCreati, gLivConsumati, gLivInvalidati, gSegnaliScartati);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari / trailing: a ogni tick

   //--- 1. LA STRUTTURA. Un livello nuovo si conferma quando chiude una
   //    barra del TF alto. Sta PRIMA del segnale ed e' corretto: il livello
   //    che si conferma adesso e' nato InpSwingBars barre fa, e tutte le
   //    barre che lo confermano sono CHIUSE. Nessun dato futuro entra qui.
   if(NuovaBarraStruttura()) AggiornaSwing();

   //--- 2. IL SEGNALE. Solo a barra CHIUSA del TF del grafico: mai intrabar.
   if(!NuovaBarraSegnale()) return;

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   ScansionaLivelli();
  }

//+------------------------------------------------------------------+
bool NuovaBarraSegnale()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t>0 && t!=gLastBarSegnale){ gLastBarSegnale=t; return(true); }
   return(false);
  }

bool NuovaBarraStruttura()
  {
   datetime t = iTime(_Symbol, InpTF_Struttura, 0);
   if(t>0 && t!=gLastBarStruttura){ gLastBarStruttura=t; return(true); }
   return(false);
  }

//==================================================================
//  LA STRUTTURA: nascita dei livelli
//==================================================================

//+------------------------------------------------------------------+
//| Valuta UNA barra candidata per volta: l'indice InpSwingBars+1.    |
//| E' la prima barra chiusa che abbia InpSwingBars barre CHIUSE alla |
//| propria destra (indici InpSwingBars..1). La barra 0, in           |
//| formazione, non entra mai nel confronto: FIX 3 del changelog.     |
//+------------------------------------------------------------------+
void AggiornaSwing()
  {
   int c    = InpSwingBars + 1;                 // la barra candidata
   int need = c + InpSwingBars + 2;             // barre che devono esistere

   if(iBars(_Symbol,InpTF_Struttura) < need) return;

   double   hC = iHigh(_Symbol,InpTF_Struttura,c);
   double   lC = iLow (_Symbol,InpTF_Struttura,c);
   datetime tC = iTime(_Symbol,InpTF_Struttura,c);
   if(hC<=0 || lC<=0 || tC<=0) return;

   //--- i 2*InpSwingBars vicini: InpSwingBars a destra (c-1..c-InpSwingBars,
   //    cioe' fino all'indice 1) e InpSwingBars a sinistra (c+1..c+InpSwingBars)
   double vicHigh[], vicLow[];
   int n = 2*InpSwingBars;
   ArrayResize(vicHigh,n);
   ArrayResize(vicLow ,n);

   int k=0;
   for(int i=1;i<=InpSwingBars;i++)
     {
      vicHigh[k] = iHigh(_Symbol,InpTF_Struttura,c-i);   // destra (c-InpSwingBars = 1: mai 0)
      vicLow [k] = iLow (_Symbol,InpTF_Struttura,c-i);
      k++;
      vicHigh[k] = iHigh(_Symbol,InpTF_Struttura,c+i);   // sinistra
      vicLow [k] = iLow (_Symbol,InpTF_Struttura,c+i);
      k++;
     }

   if(EstremoConfermato_Calc(hC,vicHigh,true))
     {
      LivelloAggiungi(gAlti,hC,tC);
      Log(StringFormat("nuovo swing HIGH confermato a %s (barra del %s).",
          DoubleToString(hC,_Digits), TimeToString(tC,TIME_DATE|TIME_MINUTES)));
     }
   if(EstremoConfermato_Calc(lC,vicLow,false))
     {
      LivelloAggiungi(gBassi,lC,tC);
      Log(StringFormat("nuovo swing LOW confermato a %s (barra del %s).",
          DoubleToString(lC,_Digits), TimeToString(tC,TIME_DATE|TIME_MINUTES)));
     }
  }

//==================================================================
//  IL SEGNALE: sweep, reclaim, consumo del livello
//==================================================================

//+------------------------------------------------------------------+
//| Scansiona TUTTI i livelli sulla barra chiusa [1].                 |
//|                                                                   |
//| REGOLA DICHIARATA SUL CONSUMO -- e' una scelta, quindi va scritta:|
//| il livello si consuma quando l'EVENTO accade, NON quando il trade |
//| parte. Se un filtro (finestra, spread, notizie, Guardian, tetto   |
//| giornaliero) blocca l'ingresso, il livello sparisce lo stesso.    |
//| Motivo: altrimenti un segnale bloccato oggi entrerebbe domani su  |
//| un livello vecchio -- che sarebbe un cambio di STRATEGIA          |
//| mascherato da regola di rischio (e' testuale nell'header di       |
//| ABTG_PausaGuardian.mqh).                                          |
//|                                                                   |
//| SEGNALE CONTRADDITTORIO: se sulla stessa barra si sweepano SIA un |
//| alto SIA un basso, non si entra in nessuna delle due direzioni    |
//| (entrambi i livelli vengono comunque consumati). Non e' prudenza  |
//| generica: due reclaim opposti nella stessa candela dicono che la  |
//| candela e' un'escursione, e la tesi del motore non c'e'.          |
//+------------------------------------------------------------------+
void ScansionaLivelli()
  {
   double h1 = iHigh (_Symbol,gTF,1);
   double l1 = iLow  (_Symbol,gTF,1);
   double c1 = iClose(_Symbol,gTF,1);
   if(h1<=0 || l1<=0 || c1<=0) return;

   bool eventoShort=false, eventoLong=false;
   double livShort=0, livLong=0;

   //--- SWING HIGH: sweep sopra + rientro sotto -> SHORT
   for(int i=ArraySize(gAlti)-1;i>=0;i--)
     {
      double L=gAlti[i].prezzo;
      if(SweepAlto_Calc(h1,c1,L))
        {
         if(!eventoShort || L<livShort){ livShort=L; }   // il piu' VICINO al rientro
         eventoShort=true;
         LivelloRimuovi(gAlti,i);
         gLivConsumati++;
         continue;
        }
      if(RottoAlto_Calc(c1,L))
        { LivelloRimuovi(gAlti,i); gLivInvalidati++; }
     }

   //--- SWING LOW: sweep sotto + rientro sopra -> LONG
   for(int i=ArraySize(gBassi)-1;i>=0;i--)
     {
      double L=gBassi[i].prezzo;
      if(SweepBasso_Calc(l1,c1,L))
        {
         if(!eventoLong || L>livLong){ livLong=L; }
         eventoLong=true;
         LivelloRimuovi(gBassi,i);
         gLivConsumati++;
         continue;
        }
      if(RottoBasso_Calc(c1,L))
        { LivelloRimuovi(gBassi,i); gLivInvalidati++; }
     }

   if(!eventoShort && !eventoLong) return;

   if(eventoShort && eventoLong)
     { gSegnaliScartati++; Log("sweep in ENTRAMBE le direzioni sulla stessa barra: nessun ingresso."); return; }

   bool isLong = eventoLong;

   //--- i filtri. Ognuno scarta il SEGNALE, mai il consumo del livello.
   if(isLong  && !InpAllowLong ) { gSegnaliScartati++; return; }
   if(!isLong && !InpAllowShort) { gSegnaliScartati++; return; }
   if(CountPositions()>0)        { gSegnaliScartati++; Log("gia' una posizione aperta: segnale scartato."); return; }
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay)
     { gSegnaliScartati++; Log("tetto giornaliero raggiunto: segnale scartato."); return; }
   if(!FinestraOK())             { gSegnaliScartati++; return; }
   if(!SpreadOK())               { gSegnaliScartati++; Log("spread fuori limite: segnale scartato."); return; }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent()))
     { gSegnaliScartati++; Log("blackout notizie: segnale scartato."); return; }

   //--- l'ESTREMO DELLO SWEEP e' l'estremo della barra [1]: per costruzione
   //    sta oltre OGNI livello sweepato in quella barra, quindi non dipende
   //    da quale livello si sia scelto.
   double estremo = isLong ? l1 : h1;
   double livello = isLong ? livLong : livShort;

   Enter(isLong,estremo,livello);
  }

//+------------------------------------------------------------------+
//| Orario della BARRA DI SEGNALE [1], in ORA SERVER.                 |
//| Mai l'ora italiana e mai l'ora del PC: regola di casa.            |
//+------------------------------------------------------------------+
bool FinestraOK()
  {
   if(!InpUseSessionWindow) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   bool ok = FinestraOK_Calc(t.hour*60+t.min,
                             InpSessStartHour*60+InpSessStartMin,
                             InpSessEndHour*60+InpSessEndMin);
   if(!ok) Log(StringFormat("fuori dalla finestra di sessione (barra delle %02d:%02d server): segnale scartato.",t.hour,t.min));
   return(ok);
  }

//==================================================================
//  INGRESSO
//==================================================================
void Enter(const bool isLong,const double estremoSweep,const double livello)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1 || a[0]<=0){ Log("ATR non disponibile: salto."); return; }
   double atr = a[0];

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry = isLong ? ask : bid;
   if(entry<=0){ Log("prezzo non disponibile: salto."); return; }

   //--- SL: strutturale (oltre l'estremo dello sweep) oppure ATR puro
   double sl;
   if(InpSLMode==0) sl = StopStrutturale_Calc(isLong,estremoSweep,atr,InpSLBufferAtr);
   else             sl = isLong ? entry-atr*InpSLatr : entry+atr*InpSLatr;
   sl = NormalizePrice(sl);

   double R = isLong ? (entry-sl) : (sl-entry);

   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=0 || R<=minDist)
     { Log("SL non valido o dentro lo stops level: salto (nessun ripiego inventato)."); return; }

   //--- TP: 0 = nessun target, si esce con la gestione
   double tp = 0;
   if(InpTP_RR>0)
     {
      tp = NormalizePrice(isLong ? entry+R*InpTP_RR : entry-R*InpTP_RR);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return; }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_LiquiditySweep")) return;

   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      Log(StringFormat("%s reclaim del livello %s @ %s SL %s TP %s lot %.2f (R %s)",
          isLong?"LONG":"SHORT",
          DoubleToString(livello,_Digits), DoubleToString(entry,_Digits),
          DoubleToString(sl,_Digits), DoubleToString(tp,_Digits), lot,
          DoubleToString(R,_Digits)));
     }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//==================================================================
//  GESTIONE DELLE POSIZIONI
//==================================================================

//+------------------------------------------------------------------+
//| Primo target: parziale (se acceso) e stop in pari (se acceso).    |
//| Poi trailing a distanza ATR, se acceso. Gira a OGNI tick: il      |
//| target si tocca in mezzo alla barra, non alla sua chiusura.       |
//|                                                                   |
//| LEZIONE PTE (04/08/2026): lo stop in pari NON dipende dalla        |
//| riuscita del parziale. Al lotto minimo NormVol() arrotonda a 0, il |
//| parziale non parte, e prima di quella lezione con lui saltava      |
//| anche il breakeven: posizioni a +1,28R tornate in perdita con lo   |
//| stop ancora all'originale. Qui il breakeven scatta anche con il    |
//| parziale SPENTO (InpTP1Pct=0), usando InpTP1_RR come grilletto.    |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;

   double a[1];
   double atr = (CopyBuffer(hAtr,0,1,1,a)==1 ? a[0] : 0);

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

      //--- primo target: parziale e/o stop in pari
      if(!beFatto && R>0 && (InpTP1Pct>0 || InpBreakeven))
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            bool parz=false;
            if(InpTP1Pct>0)
              {
               double cv = NormVol(vol*InpTP1Pct/100.0);
               parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
              }
            if(InpBreakeven)
              {
               if(gTrade.PositionModify(tk,NormalizePrice(openP),tp)) beFatto=true;
              }
            Log(StringFormat("primo target (%.2f R): parziale %s, stop in pari %s.",
                InpTP1_RR,
                (InpTP1Pct<=0 ? "spento" : (parz ? "eseguito" : "impossibile al lotto minimo")),
                (InpBreakeven ? (beFatto ? "fatto" : "NON riuscito") : "spento")));
           }
        }

      //--- trailing a distanza ATR dal prezzo corrente. Lo stop si muove
      //    SOLO a favore, mai indietro.
      if(InpUseTrailing && atr>0)
        {
         double slOra = PositionGetDouble(POSITION_SL);
         double nuovo = NormalizePrice(isLong ? bid-atr*InpTrailATR : ask+atr*InpTrailATR);
         if(isLong  && nuovo>slOra && nuovo<bid) gTrade.PositionModify(tk,nuovo,PositionGetDouble(POSITION_TP));
         if(!isLong && nuovo<slOra && nuovo>ask) gTrade.PositionModify(tk,nuovo,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
//| Sta fuori dal filtro della barra nuova apposta: la caduta peggiore |
//| di giornata succede in mezzo a una candela, non alla sua chiusura. |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0){ gDayStartEquity = eq; gDayMinEquity = eq; }
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   if(gDayStartEquity <= 0) return;
   double giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//+------------------------------------------------------------------+
//| Lotto dal RISCHIO e dalla DISTANZA DELLO STOP.                    |
//|                                                                   |
//| 08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE    |
//| NUDO. Su 225JPY il tick value arriva non convertito in valuta     |
//| conto: il lotto usciva ~0 e finiva SEMPRE al minimo. OrderCalcProfit|
//| converte correttamente; il tick value resta come ripiego. Sui     |
//| simboli sani i due calcoli coincidono: il comportamento cambia    |
//| SOLO dove il tick value mente.                                    |
//+------------------------------------------------------------------+
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);

   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
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
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- standard ABTG
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

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//==================================================================
void AutoTestLiqSweep()
  {
   int falliti=0;

   PrintFormat("[LIQSWEEP][AUTOTEST] %s | livelli su %s, %d barre per lato | SLmode %d | finestra %s | magic %I64d",
               _Symbol, EnumToString(InpTF_Struttura), InpSwingBars, InpSLMode,
               (InpUseSessionWindow?"ACCESA":"spenta"), InpMagic);

   //--- LO SWING (numeri finti, leggibili a occhio)
   double vic1[]={9.0,8.0,9.5,8.5};
   bool s1 = EstremoConfermato_Calc(10.0,vic1,true);    // il centro batte tutti  -> swing high
   bool s2 = EstremoConfermato_Calc( 9.0,vic1,true);    // 9.5 lo supera          -> no
   bool s3 = EstremoConfermato_Calc(10.0,vic1,false);   // cerco un minimo: no
   double vic2[]={10.0,10.0,11.0,12.0};
   bool s4 = EstremoConfermato_Calc(10.0,vic2,true);    // pari ammessi (come l'originale) -> si
   bool s5 = EstremoConfermato_Calc( 7.0,vic2,false);   // il centro sotto tutti  -> swing low
   PrintFormat("[LIQSWEEP][AUTOTEST] swing: high=%d (atteso 1) | superato=%d (atteso 0) | low su max=%d (atteso 0) | pari=%d (atteso 1) | low=%d (atteso 1)",
               (int)s1,(int)s2,(int)s3,(int)s4,(int)s5);
   if(!(s1 && !s2 && !s3 && s4 && s5)) falliti++;

   //--- IL GRILLETTO
   bool g1 = SweepAlto_Calc(105.0, 99.0,100.0);   // bucato sopra, chiuso sotto -> SHORT
   bool g2 = SweepAlto_Calc(105.0,101.0,100.0);   // bucato e chiuso SOPRA -> non e' uno sweep
   bool g3 = SweepAlto_Calc( 99.0, 98.0,100.0);   // mai toccato -> niente
   bool g4 = SweepBasso_Calc(95.0,101.0,100.0);   // bucato sotto, chiuso sopra -> LONG
   bool g5 = SweepBasso_Calc(95.0, 99.0,100.0);   // bucato e chiuso SOTTO -> non e' uno sweep
   PrintFormat("[LIQSWEEP][AUTOTEST] grilletto: sweepAlto=%d (atteso 1) | rotturaAlto=%d (atteso 0) | lontano=%d (atteso 0) | sweepBasso=%d (atteso 1) | rotturaBasso=%d (atteso 0)",
               (int)g1,(int)g2,(int)g3,(int)g4,(int)g5);
   if(!(g1 && !g2 && !g3 && g4 && !g5)) falliti++;

   //--- L'INVALIDAZIONE (deve essere esclusiva rispetto allo sweep)
   bool r1 = RottoAlto_Calc(101.0,100.0);         // chiuso oltre -> il livello muore
   bool r2 = RottoAlto_Calc( 99.0,100.0);         // chiuso dentro -> vive
   bool r3 = RottoBasso_Calc(99.0,100.0);
   PrintFormat("[LIQSWEEP][AUTOTEST] invalidazione: alto rotto=%d (atteso 1) | alto vivo=%d (atteso 0) | basso rotto=%d (atteso 1)",
               (int)r1,(int)r2,(int)r3);
   if(!(r1 && !r2 && r3)) falliti++;

   //--- LO STOP STRUTTURALE (ATR 2.0, buffer 0.5 -> 1.0 di respiro)
   double p1 = StopStrutturale_Calc(false,105.0,2.0,0.5);   // short: 105 + 1.0 = 106
   double p2 = StopStrutturale_Calc(true , 95.0,2.0,0.5);   // long : 95  - 1.0 = 94
   double p3 = StopStrutturale_Calc(false,105.0,2.0,0.0);   // buffer nullo: 105
   PrintFormat("[LIQSWEEP][AUTOTEST] stop: short=%.2f (atteso 106.00) | long=%.2f (atteso 94.00) | buffer 0=%.2f (atteso 105.00)",
               p1,p2,p3);
   if(!(MathAbs(p1-106.0)<1e-9 && MathAbs(p2-94.0)<1e-9 && MathAbs(p3-105.0)<1e-9)) falliti++;

   //--- LA FINESTRA (minuti dalla mezzanotte, ORA SERVER)
   bool f1 = FinestraOK_Calc(  8*60,   8*60, 12*60);   // esattamente l'inizio -> DENTRO
   bool f2 = FinestraOK_Calc( 11*60+45,8*60, 12*60);   // ultima barra M15 utile -> DENTRO
   bool f3 = FinestraOK_Calc( 12*60,   8*60, 12*60);   // la fine e' ESCLUSA -> FUORI
   bool f4 = FinestraOK_Calc(  7*60+59,8*60, 12*60);   // un minuto prima -> FUORI
   bool f5 = FinestraOK_Calc(  2*60,  22*60,  6*60);   // a cavallo della mezzanotte -> DENTRO
   bool f6 = FinestraOK_Calc( 15*60,   8*60,  8*60);   // finestra nulla = nessun vincolo
   PrintFormat("[LIQSWEEP][AUTOTEST] finestra: inizio=%d (atteso 1) | 11:45=%d (atteso 1) | fine esclusa=%d (atteso 0) | prima=%d (atteso 0) | mezzanotte=%d (atteso 1) | nulla=%d (atteso 1)",
               (int)f1,(int)f2,(int)f3,(int)f4,(int)f5,(int)f6);
   if(!(f1 && f2 && !f3 && !f4 && f5 && f6)) falliti++;

   //--- GLI ARRAY DEI LIVELLI: e' il FIX del bug dell'originale, quindi
   //    va PROVATO, non promesso. Si lavora su copie locali, non sui
   //    livelli veri (che a questo punto sono comunque vuoti).
   SLivello prova[];
   ArrayResize(prova,0);
   for(int i=0;i<5;i++)
     {
      int n=ArraySize(prova);
      ArrayResize(prova,n+1);
      prova[n].prezzo=100.0+i;
      prova[n].nato=(datetime)(1000+i);
     }
   int primaN = ArraySize(prova);            // 5
   LivelloRimuovi(prova,2);                  // butto 102.0
   int dopoN  = ArraySize(prova);            // 4
   bool a1 = (primaN==5 && dopoN==4);
   bool a2 = (dopoN==4 && prova[2].prezzo==103.0 && prova[3].prezzo==104.0);  // niente doppione in coda
   LivelloRimuovi(prova,99);                 // indice fuori range: non deve fare niente
   LivelloRimuovi(prova,-1);
   bool a3 = (ArraySize(prova)==4);
   PrintFormat("[LIQSWEEP][AUTOTEST] array: accorciato=%d (atteso 1) | nessun doppione in coda=%d (atteso 1) | indice fuori range innocuo=%d (atteso 1)",
               (int)a1,(int)a2,(int)a3);
   if(!(a1 && a2 && a3)) falliti++;

   Print("[LIQSWEEP][AUTOTEST] esito motore: ", (falliti==0
         ? "SEI BLOCCHI SU SEI, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

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
   //--- 21/08/2026 - IL CANARINO ESCE DAI DATI, NON DA UNA Print.
   //    La riga [LIQSWEEP][CONTEGGIO] di OnDeinit resta e va benissimo in
   //    una passata SINGOLA, ma in OTTIMIZZAZIONE MT5 NON esegue le Print
   //    degli agent: il canarino sparisce proprio nel round che serve a
   //    misurarlo. Quindi i quattro conteggi diventano quattro COLONNE del
   //    CSV. Nessuna riga di segnale e' toccata: qui si legge soltanto.
   double stats[14];
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
   //--- IL CANARINO DI FREQUENZA, per passata. Si legge PRIMA del conto
   //    economico. Livelli tanti + consumati pochi = problema di GRILLETTO;
   //    livelli pochi = problema di DEFINIZIONE DELLO SWING. Due diagnosi
   //    diverse, e il CSV le distingue gratis.
   stats[10] = (double)gLivCreati;                      // Livelli Creati
   stats[11] = (double)gLivConsumati;                   // Livelli Consumati
   stats[12] = (double)gLivInvalidati;                  // Livelli Invalidati
   stats[13] = (double)gSegnaliScartati;                // Segnali Scartati
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Livelli Creati,Livelli Consumati,Livelli Invalidati,Segnali Scartati";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- ArraySize(data) e' il numero di elementi che l'EA ha davvero
      //    messo nel frame. Si guarda invece di darlo per scontato: un CSV
      //    vecchio (10 colonne) e uno nuovo (14) devono poter convivere
      //    senza che questa riga vada a leggere fuori array.
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      if(ArraySize(data) >= 14)
         row += StringFormat(",%.0f,%.0f,%.0f,%.0f", data[10], data[11], data[12], data[13]);
      else
         row += ",,,,";
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
//+------------------------------------------------------------------+
