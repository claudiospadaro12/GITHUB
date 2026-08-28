//+------------------------------------------------------------------+
//|                                         ABTG_AllineaLondra.mq5    |
//|                                                                  |
//|  ALLINEAMENTO DI CINQUE MEDIE DENTRO LA FINESTRA DI LONDRA        |
//|  (metti in MQL5\Experts e compila con F7)                        |
//|                                                                  |
//|  Candidato P2 della caccia intraday forex/oro del 28/08/2026.     |
//|    dossier: backtest_pipeline/caccia_strategie/                   |
//|             CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md (righe 407-523)|
//|                                                                  |
//|  ================================================================ |
//|  ATTRIBUZIONE -- OBBLIGATORIA, E' UNA CONDIZIONE DI LICENZA       |
//|  ================================================================ |
//|  1) IL MOTORE E IL CONTENITORE (allineamento a 5 medie, finestra  |
//|     di sessione, flat obbligatorio, tetto di 2 ingressi/giorno,   |
//|     rischio in % sulla distanza dello stop) sono la riscrittura   |
//|     in MQL5 di:                                                   |
//|        "Money maker EURUSD 15min daytrader"                       |
//|        (c) SoftKill21, 2020-10-19                                 |
//|        https://www.tradingview.com/script/jU2JCWZr-Money-maker-EURUSD-15min-daytrader/
//|        Mozilla Public License 2.0 (dichiarata alla riga 1 del     |
//|        sorgente Pine, 119 righe, LETTE)                           |
//|                                                                   |
//|  2) IL FLAT ANTICIPATO DI N MINUTI (InpFlatAnticipoMin) e' preso  |
//|     da:                                                            |
//|        "SP500 Session Gap Fade Strategy"                          |
//|        (c) exlux, TradingView J1U1NNgx                            |
//|        https://www.tradingview.com/script/J1U1NNgx-SP500-Session-Gap-Fade-Strategy/
//|        Mozilla Public License 2.0                                 |
//|     Motivo: l'ultima mezz'ora di sessione ha lo spread peggiore e |
//|     i riempimenti peggiori. Uscire DENTRO la liquidita' invece    |
//|     che sull'ultima candela e' gratis.                            |
//|                                                                   |
//|  Questo file NON e' codice dell'autore originale: e' una          |
//|  riscrittura. Le uscite sono NOSTRE (vedi sotto).                 |
//|  ================================================================ |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  IL MOTORE (righe 65-66 del Pine) -- COPIATO, NON MIGLIORATO      |
//|  ---------------------------------------------------------------- |
//|  Quattro SMMA (3, 6, 9, 50) piu' una EMA200. Serve                |
//|  CONTEMPORANEAMENTE che il prezzo stia sopra tutte e cinque E che |
//|  siano impilate nell'ordine:                                       |
//|      close > smma(3) > smma(6) > smma(9) > smma(50) > ema(200)    |
//|  Lo short e' lo specchio esatto, dallo stesso codice.             |
//|  La decisione si prende sulla BARRA CHIUSA (shift 1), mai sul     |
//|  tick: e' l'equivalente del process_orders_on_close del Pine.     |
//|                                                                   |
//|  >>> LE CINQUE LUNGHEZZE SONO CONGELATE AI DEFAULT DELL'AUTORE.   |
//|      Sono input (servono per l'eventuale cella di ablazione       |
//|      futura) ma NON vanno messe come assi di ottimizzazione nel   |
//|      primo round: sono cinque manopole puntate sul passato.       |
//|      NEL PRIMO ROUND SI SPAZZOLA LA SESSIONE, NON LE MEDIE.       |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  COSA E' STATO TENUTO (il contenitore: e' la parte rara)          |
//|  ---------------------------------------------------------------- |
//|   - la finestra d'ingresso di sessione (Pine: "0300-0845");       |
//|   - il flat incondizionato a fine sessione (Pine riga 111:        |
//|     strategy.close_all(when = not london), sessione "0300-1045"); |
//|   - il tetto di 2 ingressi al giorno (Pine righe 116-117:         |
//|     strategy.risk.max_intraday_filled_orders(2));                 |
//|   - il rischio in % sulla distanza dello stop (Pine righe 83-94); |
//|   - la simmetria long/short dallo stesso codice;                  |
//|   - la decisione su barra chiusa.                                 |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  COSA E' STATO RIFATTO (e qui il sospetto e' sulle USCITE)        |
//|  ---------------------------------------------------------------- |
//|   - SL fisso 300 punti -> SL = InpAtrSLmult x ATR(InpAtrPeriod).  |
//|     30 pip nel 2020 e nel 2026 sono due rischi diversi;           |
//|   - TP fisso 300 punti (R:R 1:1 secco, nessuna gestione) ->       |
//|     parziale a 1R + stop in pari + runner con TP a 2R, cioe' lo   |
//|     schema gia' in casa (ABTG_MaxMinNotte). I nomi degli input    |
//|     sono gli STESSI di li' apposta: InpTP1_R, InpTP1Pct,          |
//|     InpBreakeven, InpTPfinal_R, InpUseTrailing, InpTrailAtrMult;  |
//|   - nessun filtro di spread -> aggiunto quello di casa, in punti  |
//|     E in % dello stop (lezione R55). Parte SPENTO: il primo round |
//|     misura il motore nudo. NESSUNA CELLA SI PROMUOVE SENZA        |
//|     RIACCENDERLO -- e la colonna "Ingressi Saltati Spread" dice   |
//|     quanto morde;                                                  |
//|   - il baco della riga 103 del Pine (strategy.entry("long", 1,    |
//|     size, ...): in Pine v4 il 2o argomento e' un bool, quindi     |
//|     "1" = true = long funziona per caso) in MQL5 non esiste.      |
//|                                                                   |
//|  >>> COME SI RIPRODUCE L'ORIGINALE, se serve un termine di        |
//|      paragone: InpTP1_R=0 (niente parziale), InpBreakeven=false,  |
//|      InpTPfinal_R=1.0 (R:R 1:1), InpUseTrailing=false.            |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  GLI ORARI SONO IN ORA SERVER, E L'EQUIVALENZA NON E' MISURATA    |
//|  ---------------------------------------------------------------- |
//|  Il Pine dice "0300-0845" e "0300-1045" nel fuso DELLO SCAMBIO    |
//|  del grafico TradingView (tipicamente UTC su un cross FX).        |
//|  I default di questo file sono I NUMERI LETTERALI DELL'AUTORE     |
//|  (03:00 / 08:45 / 10:45) letti come ORA SERVER.                   |
//|                                                                   |
//|  >>> QUESTO NON E' UNA CONVERSIONE: E' UN PUNTO DI PARTENZA.      |
//|      La conversione a tavolino e' la trappola gia' pagata in casa |
//|      (CLAUDE.md: i log di MT5 sono in ora LOCALE, il grafico e'   |
//|      in ora SERVER; il 06/08 un EA e' stato dichiarato in ritardo |
//|      di un'ora mentre aveva armato al secondo giusto).            |
//|      L'ora giusta SI MISURA sull'orologio del server, e in ogni   |
//|      caso LA SESSIONE E' L'ASSE DEL PRIMO ROUND: si spazzola.     |
//|      I tre minuti-del-giorno davvero usati escono in COLONNA      |
//|      ("Minuto Inizio Sessione", "Minuto Fine Ingressi",           |
//|      "Minuto Fine Sessione"), cosi' nessuno deve fidarsi          |
//|      dell'.ini per sapere che finestra ha girato.                 |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  LA CHIUSURA FORZATA DI FINE SESSIONE -- NON DISATTIVABILE        |
//|  ---------------------------------------------------------------- |
//|  Nasce dal mandato FTMO del 28/08/2026: MAI OVERNIGHT. Quattro    |
//|  difese a strati, le stesse di ABTG_SondaOrologio.mq5:            |
//|    1. NON ESISTE NESSUN BOOL che la accenda o la spenga.          |
//|       Nemmeno InpUsaFinestraSessione: quello spegne la finestra   |
//|       d'INGRESSO (cella di ablazione), non il flat -- con la      |
//|       finestra spenta il flat cade a fine GIORNATA server;        |
//|    2. l'unico input vicino, InpFlatAnticipoMin, sposta il flat    |
//|       PIU' PRESTO (mai piu' tardi) ed e' ammesso solo fra 0 e     |
//|       720 minuti: OnInit RIFIUTA di partire con il resto, e       |
//|       rifiuta anche un anticipo che si mangerebbe la sessione;    |
//|    3. anche con un valore fuori range le funzioni di calcolo lo   |
//|       TOSANO comunque (Clamp_Calc): il flat esiste per            |
//|       ARITMETICA, non per disciplina di chi configura;            |
//|    4. il flat non e' solo "dopo l'ora X": e' VERO ANCHE PRIMA     |
//|       DELL'INIZIO SESSIONE (minuto < inizio). E' la traduzione    |
//|       letterale del Pine "close_all(when = not london)", ed e'    |
//|       la difesa che chiude una posizione sopravvissuta al cambio  |
//|       di giornata: alle 00:00 si e' fuori sessione, quindi flat.  |
//|                                                                   |
//|  >>> IL LIMITE VERO DEL FLAT, DICHIARATO: vive dentro OnTick. Se  |
//|      il simbolo smette di mandare tick prima dell'ora di flat, la |
//|      chiusura slitta al primo tick utile. Per questo esiste la    |
//|      colonna "Notti Attraversate": conta le posizioni ancora vive |
//|      al cambio di giornata del server. DEVE essere ZERO. Se non   |
//|      lo e', il flat non e' ermetico su quel simbolo, e va detto,  |
//|      non interpretato.                                             |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  LA CELLA DI ABLAZIONE -- InpUsaFinestraSessione                  |
//|  ---------------------------------------------------------------- |
//|  Il dossier dichiara l'adiacenza concettuale con ABTG_SuperWave,  |
//|  ABTG_CrossEma e ABTG_GoldenCross: sono tutti motori di           |
//|  allineamento/incrocio di medie. La differenza rivendicata e' IL  |
//|  CONTENITORE (sessione + flat + tetto), non il segnale.           |
//|                                                                   |
//|  Percio' l'interruttore esiste da subito:                          |
//|    InpUsaFinestraSessione = true  -> ingressi SOLO nella finestra;|
//|    InpUsaFinestraSessione = false -> stesso identico allineamento,|
//|                                     operativo TUTTO IL GIORNO.    |
//|                                                                   |
//|  Se il "nudo" va uguale, la sessione non serve e il candidato e'  |
//|  un doppione. Se il nudo crolla, il contenitore E' il motore.     |
//|                                                                   |
//|  >>> COSA ISOLA DAVVERO L'ABLAZIONE, detto per non barare: isola  |
//|      LA FINESTRA D'INGRESSO. NON isola il flat (che non si spegne |
//|      mai: mandato FTMO) e non isola il tetto giornaliero (che e'  |
//|      un input a parte, InpMaxTradesDay: chi vuole togliere anche  |
//|      quello lo alza, e la cosa esce in colonna). Il confronto     |
//|      onesto e' quindi "con finestra" contro "senza finestra", a   |
//|      parita' di tutto il resto. Il valore usato esce nella        |
//|      colonna "Finestra Sessione" (1/0).                            |
//|                                                                   |
//|  ---------------------------------------------------------------- |
//|  PERCHE' LA DIAGNOSTICA E' IN COLONNE E NON IN Print              |
//|  ---------------------------------------------------------------- |
//|  In OTTIMIZZAZIONE le Print girano sugli agent e non le legge     |
//|  nessuno. Qui tutto quello che serve a giudicare -- compreso      |
//|  l'esito dell'autotest -- esce nell'OPTFRAME, cioe' in colonne    |
//|  del CSV.                                                          |
//|                                                                   |
//|  DEMO. Nessun EA garantisce profitti. ASCII puro: niente accenti  |
//|  dentro le stringhe, niente emoji.                                |
//|  NON compilato ne' testato da chi ha scritto il file: in          |
//|  quell'ambiente non esistono MetaEditor ne' Strategy Tester.      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - riscrittura da (c) SoftKill21, MPL 2.0"
#property link      "https://www.tradingview.com/script/jU2JCWZr-Money-maker-EURUSD-15min-daytrader/"
#property version   "1.00"
#property description "Allineamento di 5 medie (SMMA 3/6/9/50 + EMA200) dentro la finestra di Londra, con flat obbligatorio di fine sessione e tetto di 2 ingressi al giorno."
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove
//    le sue GlobalVariable non esistono -- la guardia lascia passare
//    tutto (fail-open totale). I backtest restano confrontabili.
//    Non tocca MAI le posizioni gia' aperte, i parziali, il breakeven,
//    il trailing e le uscite: blocca soltanto l'APERTURA di rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//--- i due motivi di chiusura che l'EA distingue in colonna.
#define AL_USCITA_FLAT    0        // l'abbiamo chiusa noi: fine sessione
#define AL_USCITA_MERCATO 1        // se n'e' andata da sola: stop o take

//==================================================================
//  INPUT
//==================================================================
input group "=== MOTORE: allineamento a 5 medie (CONGELATO ai default dell'autore) ==="
//--- NON sono assi di ottimizzazione del primo round. Vedi il blocco
//    in testa al file: cinque manopole puntate sul passato.
input int    InpSmma1        = 3;      // SMMA veloce   (Pine: smma  3)
input int    InpSmma2        = 6;      // SMMA          (Pine: smma2 6)
input int    InpSmma3        = 9;      // SMMA          (Pine: smma3 9)
input int    InpSmma4        = 50;     // SMMA lenta    (Pine: smma4 50)
input int    InpEmaLenta     = 200;    // EMA di fondo  (Pine: ema200)
input bool   InpAllowLong    = true;   // Lato LONG
input bool   InpAllowShort   = true;   // Lato SHORT (specchio esatto, stesso codice)

input group "=== CONTENITORE: la finestra di sessione (ORA SERVER!) ==="
//--- CELLA DI ABLAZIONE. false = stesso allineamento, tutto il giorno.
//    NON spegne il flat: con la finestra spenta il flat cade a fine
//    giornata server (23:59 meno l'anticipo).
input bool   InpUsaFinestraSessione = true;  // ABLAZIONE: false = niente finestra, operativo tutto il giorno
//--- i default sono i NUMERI LETTERALI DEL PINE letti come ora server:
//    NON sono una conversione di fuso. La sessione e' l'asse del round.
input int    InpSessStartHour  = 3;    // Inizio sessione, ORA SERVER (Pine: 0300, fuso dello scambio)
input int    InpSessStartMin   = 0;    // Inizio sessione, minuti
input int    InpEntryEndHour   = 8;    // Ultimo ingresso ammesso, ORA SERVER (Pine: 0845)
input int    InpEntryEndMin    = 45;   // Ultimo ingresso ammesso, minuti
input int    InpSessEndHour    = 10;   // Fine sessione = FLAT, ORA SERVER (Pine: 1045)
input int    InpSessEndMin     = 45;   // Fine sessione, minuti

input group "=== CHIUSURA FORZATA DI FINE SESSIONE (non disattivabile) ==="
//--- NON esiste un interruttore. Questo input sposta il flat solo PIU'
//    PRESTO, e OnInit rifiuta qualunque valore fuori da 0..720 (e
//    qualunque anticipo che si mangi l'intera sessione).
//    Idea presa da (c) exlux, TradingView J1U1NNgx, MPL 2.0.
input int    InpFlatAnticipoMin = 15;  // Minuti PRIMA della fine sessione in cui si chiude comunque (0..720)

input group "=== Perimetro operativo ==="
input int    InpMaxTradesDay   = 2;    // Tetto ingressi/giorno (Pine: max_intraday_filled_orders(2))
input int    InpMaxPositions   = 1;    // Posizioni contemporanee di questo magic (Pine: pyramiding 1)

input group "=== Stop loss (rifatto: ATR, non 300 punti fissi) ==="
input int    InpAtrPeriod      = 14;   // Periodo ATR (TF del grafico)
input double InpAtrSLmult      = 1.5;  // SL = X * ATR

input group "=== Target e gestione (rifatto: parziale 1R + pari + runner 2R) ==="
input double InpTP1_R          = 1.0;  // 1o target in R -> parziale + stop in pari (0 = niente parziale)
input double InpTP1Pct         = 50;   // % chiusa al 1o target
input bool   InpBreakeven      = true; // Stop in pari al 1o target
input double InpTPfinal_R      = 2.0;  // TP sull'ordine, in R (il "runner"). 0 = nessun TP: si esce a stop o al flat
input bool   InpUseTrailing    = false;// Trailing ATR sul residuo (default SPENTO: e' un comportamento in piu')
input double InpTrailAtrMult   = 2.0;  // Trailing = X * ATR

input group "=== Rischio ==="
input double InpRiskPercent    = 0.65; // Rischio per operazione, % del saldo, sulla distanza dello stop

input group "=== Filtro spread (assente nell'originale; lezione R55) ==="
input int    InpMaxSpread      = 0;    // Spread massimo in punti MT5 (0 = spento)
input double InpMaxSpreadPctSL = 0;    // Spread massimo in % dello stop (0 = spento; standard di casa)

input group "=== Generali ==="
input string InpComment        = "ALLINEALONDRA";  // Commento sugli ordini
input long   InpMagic          = 777600;           // Numero magico (blocco 7776xx: VERGINE, verificato nel repo il 28/08/2026)
input bool   InpVerbose        = true;             // Messaggi nel log (in ottimizzazione NON li legge nessuno)
input bool   InpAutoTest       = true;             // Autotest del nucleo puro in OnInit (l'esito esce in COLONNA)

//==================================================================
//  STATO
//==================================================================
int      hSmma1 = INVALID_HANDLE, hSmma2 = INVALID_HANDLE;
int      hSmma3 = INVALID_HANDLE, hSmma4 = INVALID_HANDLE;
int      hEma   = INVALID_HANDLE, hAtr   = INVALID_HANDLE;

datetime gLastBar     = 0;
int      gDayOper     = -1;      // giorno di calendario per il tetto giornaliero
int      gTradesToday = 0;
bool     gTettoContatoOggi = false;

//--- LA POSIZIONE VIVA. Lo stato di parziale/pari e' legato AL TICKET:
//    e' la lezione dell'IchiCross (g_partialDone) e serve a non
//    riportare in pari una posizione nuova con lo stato della vecchia.
ulong    gTicket        = 0;
bool     gPart1Fatta    = false;
bool     gBeFatto       = false;
//--- 1R CONGELATO ALL'APERTURA: la distanza dello stop iniziale, in
//    prezzo. Non si ricalcola mai dallo stop corrente, che dopo il
//    breakeven vale zero (vedi il commento in GestisciPosizione).
double   gRiskIniziale  = 0.0;

//--- ticket gia' contato come "notte attraversata": una posizione
//    conta UNA volta sola, non a ogni tick.
ulong    gTicketNotteContata = 0;

//--- ACCUMULATORI DELLA DIAGNOSTICA. Finiscono tutti in COLONNA.
int      gIngressiTot   = 0;
int      gIngressiLong  = 0;
int      gIngressiShort = 0;
int      gUsciteFlat    = 0;
int      gUsciteMercato = 0;     // stop o take: se n'e' andata senza di noi
int      gNottiAttrav   = 0;     // DEVE essere 0
int      gLottiAlMinimo = 0;     // rischio REALE piu' alto del dichiarato, quante volte
int      gSaltiSpread   = 0;     // quanto morde il filtro di spread
int      gGiorniTetto   = 0;     // giornate in cui il tetto ha BLOCCATO almeno un segnale
int      gParziali      = 0;
int      gBreakeven     = 0;
int      gBarreAllineate= 0;     // barre chiuse col motore acceso, PRIMA dei cancelli

//--- COLLAUDO. -1 = autotest non eseguito (che NON e' "passato").
int      gAutotestFalliti = -1;

//--- peggior giornata in % di equity (numero NEGATIVO). E' IL numero
//    che il dossier chiede di guardare per il muro giornaliero FTMO.
double   gDayStartEquity = 0.0;
double   gDayMinEquity   = 0.0;
double   gWorstDayPct    = 0.0;
int      gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[AllineaLondra] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| Tosatura di un intero dentro un intervallo. E' il mattone della   |
//| TERZA difesa del flat: qualunque numero entri, esce ammissibile.  |
//+------------------------------------------------------------------+
int Clamp_Calc(const int v, const int lo, const int hi)
  {
   if(v < lo) return(lo);
   if(v > hi) return(hi);
   return(v);
  }

//+------------------------------------------------------------------+
//| MINUTO DEL GIORNO da ora e minuti, tosato a 0..1439.              |
//+------------------------------------------------------------------+
int MinutoDelGiorno_Calc(const int ora, const int minuto)
  {
   return(Clamp_Calc(Clamp_Calc(ora,0,23)*60 + Clamp_Calc(minuto,0,59), 0, 1439));
  }

//+------------------------------------------------------------------+
//| IL MOTORE, PER INTERO -- lato LONG.                               |
//| Pine righe 65-66: prezzo sopra tutte e cinque E medie impilate.    |
//| Le due condizioni sono ridondanti per transitivita' (se           |
//| close>m1 e m1>m2>...>e allora close e' sopra tutte), ma si        |
//| scrivono TUTTE lo stesso: cosi' la regola si legge nel codice     |
//| com'e' scritta nell'originale, e un valore sporco (0, media non   |
//| ancora pronta) non passa per caso.                                 |
//+------------------------------------------------------------------+
bool AllineaLong_Calc(const double close, const double m1, const double m2,
                      const double m3, const double m4, const double ema)
  {
   if(close <= 0 || m1 <= 0 || m2 <= 0 || m3 <= 0 || m4 <= 0 || ema <= 0) return(false);
   if(!(close > m1 && close > m2 && close > m3 && close > m4 && close > ema)) return(false);
   return(m1 > m2 && m2 > m3 && m3 > m4 && m4 > ema);
  }

//+------------------------------------------------------------------+
//| IL MOTORE -- lato SHORT: lo specchio esatto, stesso codice.        |
//+------------------------------------------------------------------+
bool AllineaShort_Calc(const double close, const double m1, const double m2,
                       const double m3, const double m4, const double ema)
  {
   if(close <= 0 || m1 <= 0 || m2 <= 0 || m3 <= 0 || m4 <= 0 || ema <= 0) return(false);
   if(!(close < m1 && close < m2 && close < m3 && close < m4 && close < ema)) return(false);
   return(m1 < m2 && m2 < m3 && m3 < m4 && m4 < ema);
  }

//+------------------------------------------------------------------+
//| MINUTO DEL FLAT quando la finestra e' SPENTA (ablazione):          |
//| 1439 = 23:59, cioe' l'ultimo minuto della giornata server, meno    |
//| l'anticipo. Anche senza finestra NON si dorme mai in posizione.    |
//+------------------------------------------------------------------+
int FlatGiornataMinuto_Calc(const int anticipoMin)
  {
   return(1439 - Clamp_Calc(anticipoMin, 0, 720));
  }

//+------------------------------------------------------------------+
//| MINUTO DEL FLAT quando la finestra e' ACCESA: fine sessione meno   |
//| l'anticipo, e mai prima dell'inizio sessione.                      |
//| Tutti gli ingredienti vengono TOSATI qui dentro: e' la terza       |
//| difesa. Anche chiamata con numeri assurdi il flat esiste, cade     |
//| dentro la giornata e non e' mai piu' tardi della fine sessione.    |
//+------------------------------------------------------------------+
int FlatSessioneMinuto_Calc(const int minInizio, const int minFine, const int anticipoMin)
  {
   int s = Clamp_Calc(minInizio, 0, 1439);
   int e = Clamp_Calc(minFine,   0, 1439);
   if(e < s) e = s;                                  // configurazione assurda: sessione nulla
   int f = e - Clamp_Calc(anticipoMin, 0, 720);
   if(f < s) f = s;                                  // l'anticipo non puo' precedere l'inizio
   return(Clamp_Calc(f, 0, 1439));
  }

//+------------------------------------------------------------------+
//| DEVO ESSERE PIATTO? E' la traduzione letterale del Pine riga 111  |
//| (close_all when NOT london), con l'anticipo di (c) exlux.          |
//| Con la finestra ACCESA e' vero in DUE casi:                        |
//|   - oltre il minuto di flat (fine sessione meno anticipo);         |
//|   - PRIMA dell'inizio sessione: e' la quarta difesa, quella che    |
//|     chiude una posizione sopravvissuta al cambio di giornata.      |
//| Con la finestra SPENTA vale il flat di fine giornata server.       |
//| Non esiste nessun ramo che restituisca "mai flat".                 |
//+------------------------------------------------------------------+
bool DevoFlat_Calc(const int minutoOra, const bool usaFinestra,
                   const int minInizio, const int minFine, const int anticipoMin)
  {
   int m = Clamp_Calc(minutoOra, 0, 1439);
   if(!usaFinestra) return(m >= FlatGiornataMinuto_Calc(anticipoMin));
   if(m >= FlatSessioneMinuto_Calc(minInizio, minFine, anticipoMin)) return(true);
   if(m <  Clamp_Calc(minInizio, 0, 1439)) return(true);
   return(false);
  }

//+------------------------------------------------------------------+
//| SONO NELLA FINESTRA IN CUI E' AMMESSO ENTRARE?                     |
//| Pine: londonEntry "0300-0845", piu' stretta della sessione.        |
//| Con la finestra SPENTA (ablazione) risponde sempre vero: il        |
//| filtro d'orario sull'INGRESSO sparisce, il flat no.                |
//+------------------------------------------------------------------+
bool DentroFinestraIngresso_Calc(const int minutoOra, const bool usaFinestra,
                                 const int minInizio, const int minFineIngressi)
  {
   if(!usaFinestra) return(true);
   int m = Clamp_Calc(minutoOra, 0, 1439);
   return(m >= Clamp_Calc(minInizio,0,1439) && m <= Clamp_Calc(minFineIngressi,0,1439));
  }

//+------------------------------------------------------------------+
//| LOTTO GREZZO dal rischio (Pine righe 83-94: balance*risk% / sl).   |
//| Qualunque ingrediente non valido -> 0 (nessun ordine), mai un      |
//| numero inventato.                                                  |
//+------------------------------------------------------------------+
double LottoGrezzo_Calc(const double saldo, const double riskPct,
                        const double perditaPerLotto)
  {
   if(saldo <= 0 || riskPct <= 0 || perditaPerLotto <= 0) return(0.0);
   return((saldo*riskPct/100.0)/perditaPerLotto);
  }

//+------------------------------------------------------------------+
//| NORMALIZZAZIONE AI VINCOLI DI VOLUME DEL SIMBOLO -- CON FLOOR      |
//| ESPLICITO: sotto il minimo del broker si sale al minimo, MAI si    |
//| restituisce 0 per arrotondamento. In quel caso pero' il rischio    |
//| REALE e' piu' alto di quello dichiarato, e alMinimo lo dice: il    |
//| fatto finisce in colonna, non sotto il tappeto.                     |
//+------------------------------------------------------------------+
double NormalizzaLotto_Calc(const double lotto, const double volMin,
                            const double volMax, const double volStep,
                            bool &alMinimo)
  {
   alMinimo = false;
   if(volStep <= 0 || volMin <= 0) return(0.0);
   if(lotto <= 0) return(0.0);
   double n = MathFloor(lotto/volStep)*volStep;
   if(n < volMin){ n = volMin; alMinimo = true; }
   if(volMax > 0 && n > volMax) n = volMax;
   return(n);
  }

//+------------------------------------------------------------------+
//| LO SPREAD E' TROPPO LARGO RISPETTO ALLO STOP? (lezione R55)        |
//| pctMax <= 0 = filtro spento. Il confronto e' in PREZZO, non in     |
//| punti: cosi' non dipende dai decimali del simbolo.                 |
//+------------------------------------------------------------------+
bool SpreadTroppoLargo_Calc(const double spreadPrezzo, const double distSL, const double pctMax)
  {
   if(pctMax <= 0) return(false);
   if(distSL <= 0) return(true);            // senza stop non c'e' niente con cui confrontarlo
   return(spreadPrezzo > distSL*pctMax/100.0);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- I CANCELLI DI CONFIGURAZIONE. Rifiutano, non correggono in
   //    silenzio: un default nascosto e' un backtest che misura una
   //    cosa diversa da quella scritta nell'.ini.
   if(InpSmma1 < 1 || InpSmma2 < 1 || InpSmma3 < 1 || InpSmma4 < 1 || InpEmaLenta < 1)
     { Print("ERRORE: i periodi delle medie devono essere >= 1."); return(INIT_FAILED); }
   if(!(InpSmma1 < InpSmma2 && InpSmma2 < InpSmma3 && InpSmma3 < InpSmma4 && InpSmma4 < InpEmaLenta))
     { Print("ERRORE: i periodi devono essere STRETTAMENTE CRESCENTI (default autore 3 < 6 < 9 < 50 < 200): un allineamento fra medie non ordinate non vuol dire niente."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: almeno un lato dev'essere acceso."); return(INIT_FAILED); }

   if(InpSessStartHour < 0 || InpSessStartHour > 23 || InpSessStartMin < 0 || InpSessStartMin > 59)
     { Print("ERRORE: inizio sessione fuori range (ORA SERVER 0-23, minuti 0-59)."); return(INIT_FAILED); }
   if(InpEntryEndHour < 0 || InpEntryEndHour > 23 || InpEntryEndMin < 0 || InpEntryEndMin > 59)
     { Print("ERRORE: fine ingressi fuori range (ORA SERVER 0-23, minuti 0-59)."); return(INIT_FAILED); }
   if(InpSessEndHour < 0 || InpSessEndHour > 23 || InpSessEndMin < 0 || InpSessEndMin > 59)
     { Print("ERRORE: fine sessione fuori range (ORA SERVER 0-23, minuti 0-59)."); return(INIT_FAILED); }

   int minStart = MinutoDelGiorno_Calc(InpSessStartHour, InpSessStartMin);
   int minEntry = MinutoDelGiorno_Calc(InpEntryEndHour,  InpEntryEndMin);
   int minEnd   = MinutoDelGiorno_Calc(InpSessEndHour,   InpSessEndMin);

   //--- LIMITE DICHIARATO: la sessione NON puo' scavalcare la mezzanotte.
   //    Londra non scavalca; una sessione a cavallo del giorno renderebbe
   //    ambigui sia il tetto giornaliero sia il flat, e un flat ambiguo
   //    e' esattamente quello che il mandato FTMO non ammette.
   if(!(minStart < minEntry && minEntry <= minEnd))
     { Print("ERRORE: serve inizio sessione < fine ingressi <= fine sessione, tutto DENTRO la stessa giornata server (niente scavalco della mezzanotte)."); return(INIT_FAILED); }

   //--- SECONDA DIFESA DEL FLAT: il range e' un cancello, non un consiglio.
   if(InpFlatAnticipoMin < 0 || InpFlatAnticipoMin > 720)
     { Print("ERRORE: InpFlatAnticipoMin deve stare fra 0 e 720 minuti. La chiusura forzata NON e' disattivabile: questo input la sposta solo piu' presto."); return(INIT_FAILED); }
   if(InpUsaFinestraSessione && InpFlatAnticipoMin >= (minEnd - minStart))
     { Print("ERRORE: l'anticipo del flat si mangia l'intera sessione (non resterebbe nemmeno un minuto operativo). Riducilo."); return(INIT_FAILED); }

   if(InpMaxTradesDay < 1)
     { Print("ERRORE: InpMaxTradesDay deve essere >= 1 (Pine: 2)."); return(INIT_FAILED); }
   if(InpMaxPositions < 1)
     { Print("ERRORE: InpMaxPositions deve essere >= 1."); return(INIT_FAILED); }
   if(InpAtrPeriod < 1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpAtrSLmult <= 0)
     { Print("ERRORE: InpAtrSLmult deve essere > 0: una posizione senza stop e' una posizione nuda, e questo EA non parte senza stop."); return(INIT_FAILED); }
   if(InpTP1_R < 0)
     { Print("ERRORE: InpTP1_R non puo' essere negativo (0 = niente parziale)."); return(INIT_FAILED); }
   if(InpTP1Pct < 0 || InpTP1Pct >= 100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 e 99,99 (100 vorrebbe dire chiudere tutto: non e' un parziale)."); return(INIT_FAILED); }
   if(InpTPfinal_R < 0)
     { Print("ERRORE: InpTPfinal_R non puo' essere negativo (0 = nessun TP sull'ordine)."); return(INIT_FAILED); }
   if(InpUseTrailing && InpTrailAtrMult <= 0)
     { Print("ERRORE: con il trailing acceso InpTrailAtrMult deve essere > 0."); return(INIT_FAILED); }
   if(InpRiskPercent <= 0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxSpread < 0)
     { Print("ERRORE: InpMaxSpread non puo' essere negativo (0 = spento)."); return(INIT_FAILED); }
   if(InpMaxSpreadPctSL < 0)
     { Print("ERRORE: InpMaxSpreadPctSL non puo' essere negativo (0 = spento)."); return(INIT_FAILED); }

   //--- indicatori: tutti sul TF del grafico (il motore nasce a M15).
   hSmma1 = iMA (_Symbol, PERIOD_CURRENT, InpSmma1,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma2 = iMA (_Symbol, PERIOD_CURRENT, InpSmma2,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma3 = iMA (_Symbol, PERIOD_CURRENT, InpSmma3,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma4 = iMA (_Symbol, PERIOD_CURRENT, InpSmma4,    0, MODE_SMMA, PRICE_CLOSE);
   hEma   = iMA (_Symbol, PERIOD_CURRENT, InpEmaLenta, 0, MODE_EMA,  PRICE_CLOSE);
   hAtr   = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriod);
   if(hSmma1 == INVALID_HANDLE || hSmma2 == INVALID_HANDLE || hSmma3 == INVALID_HANDLE ||
      hSmma4 == INVALID_HANDLE || hEma   == INVALID_HANDLE || hAtr   == INVALID_HANDLE)
     { Print("ERRORE: handle indicatori non creati."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestAllineaLondra();

   //--- DICHIARAZIONI a voce alta, non correzioni.
   if(InpMaxSpread <= 0 && InpMaxSpreadPctSL <= 0)
      Log("ATTENZIONE: FILTRO DI SPREAD SPENTO. Va bene per misurare il motore nudo nel primo round, NON per promuovere una cella (lezione R55). La colonna 'Ingressi Saltati Spread' restera' a 0 e lo dichiara.");
   if(!InpUsaFinestraSessione)
      Log("ATTENZIONE: CELLA DI ABLAZIONE ATTIVA. La finestra d'ingresso e' SPENTA: si opera tutto il giorno. Il flat NON e' spento: cade a fine giornata server. Questa corsa serve a rispondere a UNA domanda: senza il contenitore, l'allineamento a 5 medie vale ancora qualcosa?");

   int mflat = InpUsaFinestraSessione ? FlatSessioneMinuto_Calc(minStart, minEnd, InpFlatAnticipoMin)
                                      : FlatGiornataMinuto_Calc(InpFlatAnticipoMin);
   Log(StringFormat("CHIUSURA FORZATA alle %02d:%02d ORA SERVER, incondizionata e NON disattivabile da nessun input (mandato FTMO del 28/08: mai overnight).", mflat/60, mflat%60));

   Log(StringFormat("avviato su %s %s. Finestra %s: ingressi %02d:%02d-%02d:%02d, sessione fino a %02d:%02d (ORA SERVER, NON convertita: si misura). Medie %d/%d/%d/%d SMMA + EMA%d. SL %.2f x ATR(%d), TP1 %.2fR al %.0f%%, TP finale %.2fR, rischio %.2f%%, tetto %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       (InpUsaFinestraSessione ? "ACCESA" : "SPENTA (ablazione)"),
       InpSessStartHour, InpSessStartMin, InpEntryEndHour, InpEntryEndMin,
       InpSessEndHour, InpSessEndMin,
       InpSmma1, InpSmma2, InpSmma3, InpSmma4, InpEmaLenta,
       InpAtrSLmult, InpAtrPeriod, InpTP1_R, InpTP1Pct, InpTPfinal_R,
       InpRiskPercent, InpMaxTradesDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hSmma1 != INVALID_HANDLE) IndicatorRelease(hSmma1);
   if(hSmma2 != INVALID_HANDLE) IndicatorRelease(hSmma2);
   if(hSmma3 != INVALID_HANDLE) IndicatorRelease(hSmma3);
   if(hSmma4 != INVALID_HANDLE) IndicatorRelease(hSmma4);
   if(hEma   != INVALID_HANDLE) IndicatorRelease(hEma);
   if(hAtr   != INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
//| L'ORDINE DEI GESTI IN OnTick E' PARTE DELLA SPECIFICA:            |
//|   1. la peggior giornata si aggiorna PRIMA di qualunque chiusura, |
//|      altrimenti una caduta chiusa d'ufficio non verrebbe contata; |
//|   2. il cambio giornata azzera il tetto (a tick, non a barra:     |
//|      se la prima barra del giorno arriva tardi il tetto sarebbe   |
//|      ancora quello di ieri);                                      |
//|   3. IL CANARINO DELLA NOTTE si legge PRIMA del flat. Difetto     |
//|      trovato rileggendo la prima stesura: stava dentro la         |
//|      gestione, che pero' viene SALTATA proprio quando il flat e'  |
//|      vero -- cioe' esattamente a mezzanotte, l'unico momento in   |
//|      cui una notte attraversata si puo' vedere. Cosi' la colonna  |
//|      sarebbe stata 0 per costruzione, e una colonna che non puo'  |
//|      accendersi non e' un canarino: e' un ornamento;              |
//|   4. IL FLAT VIENE PRIMA DI TUTTO IL RESTO ed e' incondizionato;  |
//|   5. poi la gestione (parziale, pari, trailing), a ogni tick;     |
//|   6. l'ingresso si valuta SOLO all'apertura di una barra nuova.   |
//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();

   MqlDateTime tn; TimeToStruct(TimeCurrent(), tn);
   if(tn.day_of_year != gDayOper)
     { gDayOper = tn.day_of_year; gTradesToday = 0; gTettoContatoOggi = false; }

   int minutoOra = tn.hour*60 + tn.min;

   //--- 3. il canarino, PRIMA del flat (vedi il blocco qui sopra).
   ControllaNotteAttraversata(tn.day_of_year);

   //--- 4. IL FLAT. Sempre, prima di tutto il resto, senza condizioni.
   if(DevoFlat_Calc(minutoOra, InpUsaFinestraSessione, MinInizio(), MinFine(), InpFlatAnticipoMin))
     { ChiudiTutto(); return; }

   //--- 5. la posizione viva.
   GestisciPosizione();

   //--- 6. l'ingresso, solo su barra nuova.
   if(!NuovaBarra()) return;
   ValutaBarraChiusa(minutoOra);
  }

//+------------------------------------------------------------------+
//| IL CANARINO DEL FLAT. Una posizione di questo magic ancora viva   |
//| in una giornata server diversa da quella in cui e' stata aperta   |
//| vuol dire che il flat NON e' stato ermetico: il simbolo non ha    |
//| mandato tick in tempo, e abbiamo dormito in posizione.            |
//| La colonna "Notti Attraversate" DEVE essere ZERO. Se non lo e',   |
//| si dichiara e non si interpreta.                                  |
//| Ogni posizione conta UNA volta sola (chiave: il ticket).          |
//+------------------------------------------------------------------+
void ControllaNotteAttraversata(const int giornoOggi)
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      if(tk == gTicketNotteContata) continue;
      MqlDateTime tApe; TimeToStruct((datetime)PositionGetInteger(POSITION_TIME), tApe);
      if(tApe.day_of_year != giornoOggi)
        {
         gNottiAttrav++;
         gTicketNotteContata = tk;
         Log("ATTENZIONE: posizione ancora viva al cambio di giornata del server. Il flat non ha trovato tick in tempo.");
        }
     }
  }

//+------------------------------------------------------------------+
bool NuovaBarra()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t != gLastBar){ gLastBar = t; return(true); }
   return(false);
  }

//--- i tre minuti-del-giorno della finestra, in un posto solo.
int MinInizio(){ return(MinutoDelGiorno_Calc(InpSessStartHour, InpSessStartMin)); }
int MinIngressi(){ return(MinutoDelGiorno_Calc(InpEntryEndHour, InpEntryEndMin)); }
int MinFine(){ return(MinutoDelGiorno_Calc(InpSessEndHour, InpSessEndMin)); }

//+------------------------------------------------------------------+
//| La peggior giornata in % di equity. E' IL numero che il dossier   |
//| chiede di guardare per il muro giornaliero FTMO (-5.000 su 100k), |
//| e si aggiorna a ogni tick: la caduta peggiore succede in mezzo    |
//| alla sessione, non alla sua chiusura.                              |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(), t);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(t.day_of_year != gDayEqStamp)
     {
      gDayEqStamp     = t.day_of_year;
      gDayStartEquity = eq;
      gDayMinEquity   = eq;
     }
   if(eq < gDayMinEquity) gDayMinEquity = eq;
   if(gDayStartEquity > 0)
     {
      double pct = (gDayMinEquity - gDayStartEquity)/gDayStartEquity*100.0;
      if(pct < gWorstDayPct) gWorstDayPct = pct;
     }
  }

//==================================================================
//  IL FLAT -- chiude TUTTE le posizioni di questo magic su questo
//  simbolo, anche quelle di cui non abbiamo il ticket in memoria
//  (riavvio del terminale, chiusura fallita, ticket perso). E' la
//  forma piu' dura che si possa scrivere: non chiede permesso a
//  nessuno stato interno. Se una chiusura fallisce non si registra
//  niente e si ritenta al tick dopo; se dovesse fallire fino al
//  cambio giorno, la colonna "Notti Attraversate" lo dice.
//==================================================================
void ChiudiTutto()
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      if(gTrade.PositionClose(tk))
        {
         gUsciteFlat++;
         if(tk == gTicket) AzzeraStatoPosizione();
        }
      else
         Log(StringFormat("FLAT: chiusura NON riuscita sul ticket %I64u (retcode %d): ritento al tick successivo.", tk, gTrade.ResultRetcode()));
     }
   //--- se il ticket in memoria non esiste piu' (chiuso qui o altrove)
   //    lo stato di parziale/pari va comunque azzerato: non deve
   //    sopravvivere alla posizione a cui apparteneva.
   if(gTicket != 0 && !PositionSelectByTicket(gTicket)) AzzeraStatoPosizione();
  }

void AzzeraStatoPosizione()
  {
   gTicket        = 0;
   gPart1Fatta    = false;
   gBeFatto       = false;
   gRiskIniziale  = 0.0;
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE -- parziale a 1R, stop in pari, runner.
//  Lo stato e' legato AL TICKET: cambia il ticket, cambia lo stato.
//==================================================================
void GestisciPosizione()
  {
   if(gTicket == 0)
     {
      //--- adozione di una posizione ORFANA (riavvio): la prendiamo in
      //    carico invece di lasciarla senza gestione. Il parziale e il
      //    pari ripartono da zero: e' l'ipotesi prudente.
      ulong orfana = TrovaPosizione();
      if(orfana == 0) return;
      gTicket       = orfana;
      gPart1Fatta   = false;
      gBeFatto      = false;
      gRiskIniziale = 0.0;   // sconosciuto: sotto si ricostruisce dallo stop, e' un ripiego dichiarato
      Log("posizione orfana adottata (riavvio?): gestione ripresa da zero.");
     }

   if(!PositionSelectByTicket(gTicket))
     {
      //--- se n'e' andata senza di noi: stop o take. Rilevato al primo
      //    tick successivo.
      gUsciteMercato++;
      AzzeraStatoPosizione();
      return;
     }

   bool   isLong = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl     = PositionGetDouble(POSITION_SL);
   double tp     = PositionGetDouble(POSITION_TP);
   double vol    = PositionGetDouble(POSITION_VOLUME);
   double bid    = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   //--- QUANTO VALE 1R -- e qui c'era un difetto della prima stesura,
   //    trovato rileggendo: 1R veniva ricalcolato ogni volta come
   //    (apertura - stop attuale). Ma DOPO il breakeven lo stop STA
   //    sull'apertura, quindi quella distanza diventa ZERO e il
   //    riferimento scivolava sull'ATR del momento -- cioe' "1R"
   //    cambiava valore a meta' operazione. Adesso 1R e' la distanza
   //    dello stop DELL'APERTURA, congelata in gRiskIniziale; le due
   //    ricostruzioni sotto sono solo ripieghi per una posizione
   //    adottata dopo un riavvio, e sono dichiarati.
   double risk = gRiskIniziale;
   if(risk <= 0) risk = isLong ? (openP - sl) : (sl - openP);
   if(risk <= 0){ double a = AtrVal(); if(a > 0) risk = a*InpAtrSLmult; }

   //--- PARZIALE A 1R + STOP IN PARI.
   //    Lezione del 07/08 (costata 112,78 EUR su due short oro a 0,01
   //    lotti): al lotto minimo NormVol(vol*%) arrotonda a 0, il
   //    parziale non parte, e con lui saltava anche il breakeven.
   //    Da allora IL PARI NON DIPENDE DALLA RIUSCITA DEL PARZIALE:
   //    sono due blocchi separati, con due bandierine separate.
   if(InpTP1_R > 0 && risk > 0 && (!gPart1Fatta || !gBeFatto))
     {
      double tgt = isLong ? openP + risk*InpTP1_R : openP - risk*InpTP1_R;
      bool   hit = isLong ? (bid >= tgt) : (ask <= tgt);
      if(hit)
        {
         //--- 1) il parziale.
         if(!gPart1Fatta && InpTP1Pct > 0)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            if(cv <= 0 || cv >= vol)
              {
               //--- strutturalmente impossibile (lotto minimo): si
               //    smette di provarci, ma il pari resta in piedi.
               gPart1Fatta = true;
               Log("1o target (1R): parziale NON eseguibile al lotto minimo. Si va avanti col solo stop in pari.");
              }
            else if(gTrade.PositionClosePartial(gTicket, cv))
              { gPart1Fatta = true; gParziali++; Log("1o target (1R): parziale eseguito."); }
            else
               Log(StringFormat("1o target (1R): parziale NON riuscito (retcode %d): ritento al tick successivo.", gTrade.ResultRetcode()));
           }
         //--- 2) lo stop in pari, INDIPENDENTE dal parziale. Se il
         //    broker rifiuta (prezzo troppo vicino allo stops level)
         //    la bandierina NON si alza e si ritenta al tick dopo.
         if(InpBreakeven && !gBeFatto)
           {
            double bePari = NormalizzaPrezzo(openP);
            double slOra  = PositionGetDouble(POSITION_SL);
            //--- il pari si fa SOLO se MIGLIORA lo stop: cosi' non si
            //    ripete a ogni tick e non allarga mai il rischio.
            bool migliora = isLong ? (bePari > slOra) : (slOra == 0 || bePari < slOra);
            if(!migliora)
               gBeFatto = true;                       // lo stop e' gia' meglio del pari
            else if(gTrade.PositionModify(gTicket, bePari, tp))
              { gBeFatto = true; gBreakeven++; Log("1o target (1R): stop portato in pari."); }
           }
        }
     }

   //--- TRAILING sul residuo (spento di default: e' un comportamento
   //    in piu' rispetto al mandato, e va confrontato con/senza).
   if(InpUseTrailing)
     {
      double a = AtrVal();
      if(a > 0)
        {
         double slOra = PositionGetDouble(POSITION_SL);
         double tpOra = PositionGetDouble(POSITION_TP);
         if(isLong)
           {
            double n = NormalizzaPrezzo(bid - a*InpTrailAtrMult);
            if(n > slOra && n > openP) gTrade.PositionModify(gTicket, n, tpOra);
           }
         else
           {
            double n = NormalizzaPrezzo(ask + a*InpTrailAtrMult);
            if((slOra == 0 || n < slOra) && n < openP) gTrade.PositionModify(gTicket, n, tpOra);
           }
        }
     }
  }

//==================================================================
//  INGRESSO -- il motore prima, i cancelli del contenitore poi.
//  L'ordine e' voluto: il conteggio "Barre Allineate" deve dire
//  quante OCCASIONI ha avuto il motore, PRIMA che il contenitore le
//  filtrasse. Se le barre allineate sono tante e gli ingressi zero,
//  il collo di bottiglia e' il contenitore -- ed e' esattamente la
//  domanda della cella di ablazione.
//==================================================================
void ValutaBarraChiusa(const int minutoOra)
  {
   int segnale = SegnaleAllineamento();      // +1 long, -1 short, 0 niente
   if(segnale != 0) gBarreAllineate++;
   if(segnale == 0) return;

   //--- CANCELLI DEL CONTENITORE
   if(ContaPosizioni() >= InpMaxPositions) return;
   if(gTradesToday >= InpMaxTradesDay)
     {
      if(!gTettoContatoOggi){ gGiorniTetto++; gTettoContatoOggi = true; }
      return;
     }
   if(!DentroFinestraIngresso_Calc(minutoOra, InpUsaFinestraSessione, MinInizio(), MinIngressi())) return;
   //--- ridondante (il flat ha gia' fatto uscire OnTick), ma esplicito:
   //    non si apre MAI dentro la finestra di flat.
   if(DevoFlat_Calc(minutoOra, InpUsaFinestraSessione, MinInizio(), MinFine(), InpFlatAnticipoMin)) return;

   Apri(segnale > 0);
  }

//+------------------------------------------------------------------+
//| IL MOTORE letto sulla BARRA CHIUSA (shift 1). Restituisce         |
//| +1 long, -1 short, 0 niente. Se manca un solo dato, 0: non si     |
//| tira a indovinare con una media non ancora pronta.                 |
//+------------------------------------------------------------------+
int SegnaleAllineamento()
  {
   double m1 = ValMedia(hSmma1, 1);
   double m2 = ValMedia(hSmma2, 1);
   double m3 = ValMedia(hSmma3, 1);
   double m4 = ValMedia(hSmma4, 1);
   double em = ValMedia(hEma,   1);
   double cl = iClose(_Symbol, PERIOD_CURRENT, 1);
   if(m1 <= 0 || m2 <= 0 || m3 <= 0 || m4 <= 0 || em <= 0 || cl <= 0) return(0);

   if(InpAllowLong  && AllineaLong_Calc (cl, m1, m2, m3, m4, em)) return(+1);
   if(InpAllowShort && AllineaShort_Calc(cl, m1, m2, m3, m4, em)) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| APERTURA -- rischio in % sulla distanza dello stop (Pine 83-94),  |
//| stop in ATR (nostro), TP a multiplo di R (nostro).                |
//+------------------------------------------------------------------+
void Apri(const bool isLong)
  {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0 || ask < bid) return;

   double atr = AtrVal();
   if(atr <= 0) return;                       // senza ATR non c'e' stop: non si apre nuda

   double dist = InpAtrSLmult*atr;
   //--- rispetto esplicito di SYMBOL_TRADE_STOPS_LEVEL: un ordine
   //    rifiutato dal broker non e' un dato, e' un buco nel campione.
   double minStop = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(dist < minStop) dist = minStop;
   if(dist <= 0) return;

   //--- FILTRI DI SPREAD (assenti nell'originale; lezione R55).
   if(InpMaxSpread > 0 && SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) > InpMaxSpread)
     { gSaltiSpread++; return; }
   if(SpreadTroppoLargo_Calc(ask-bid, dist, InpMaxSpreadPctSL))
     { gSaltiSpread++; return; }

   double entry = isLong ? ask : bid;
   double sl    = NormalizzaPrezzo(isLong ? entry - dist : entry + dist);

   double tp = 0.0;
   if(InpTPfinal_R > 0)
     {
      double distTP = dist*InpTPfinal_R;
      if(distTP < minStop) distTP = minStop;   // anche il TP rispetta lo stops level
      tp = NormalizzaPrezzo(isLong ? entry + distTP : entry - distTP);
     }

   bool   alMinimo = false;
   double lotto    = NormalizzaLotto_Calc(
                        LottoGrezzo_Calc(AccountInfoDouble(ACCOUNT_BALANCE), InpRiskPercent, PerditaPerLotto(dist)),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP),
                        alMinimo);
   if(lotto <= 0){ Log("lotto non calcolabile (perdita per lotto nulla?): nessun ordine."); return; }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI
   //    ingressi. La chiamata sta QUI, immediatamente prima dell'invio.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_AllineaLondra")) return;

   bool ok = isLong ? gTrade.Buy (lotto, _Symbol, 0.0, sl, tp, InpComment)
                    : gTrade.Sell(lotto, _Symbol, 0.0, sl, tp, InpComment);
   if(!ok)
     {
      Log(StringFormat("ordine NON eseguito (retcode %d, lotto %.2f).", gTrade.ResultRetcode(), lotto));
      return;
     }

   ulong tk = TrovaPosizione();
   if(tk == 0){ Log("ordine eseguito ma posizione non trovata: la gestione la adottera' al tick successivo."); }

   gTicket       = tk;
   gPart1Fatta   = false;
   gBeFatto      = false;
   gRiskIniziale = dist;      // 1R congelato: e' la distanza dello stop DAVVERO usata

   gTradesToday++;
   gIngressiTot++;
   if(isLong) gIngressiLong++; else gIngressiShort++;
   if(alMinimo) gLottiAlMinimo++;

   Log(StringFormat("%s a %.5f, SL %.5f, TP %.5f, lotto %.2f (%d/%d di oggi).",
                    (isLong ? "LONG" : "SHORT"), entry, sl, tp, lotto, gTradesToday, InpMaxTradesDay));
  }

//==================================================================
//  LETTURE DAL TERMINALE (il pensiero sta nel nucleo puro)
//==================================================================
double ValMedia(const int handle, const int shift)
  {
   double b[1];
   if(CopyBuffer(handle, 0, shift, 1, b) != 1) return(0.0);
   return(b[0]);
  }

double AtrVal()
  {
   double a[1];
   if(CopyBuffer(hAtr, 0, 1, 1, a) != 1) return(0.0);
   return(a[0]);
  }

double NormalizzaPrezzo(const double prezzo)
  {
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   int    dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(ts <= 0) return(NormalizeDouble(prezzo, dg));
   return(NormalizeDouble(MathRound(prezzo/ts)*ts, dg));
  }

//+------------------------------------------------------------------+
//| PERDITA IN VALUTA CONTO DI UN LOTTO SE LO STOP VIENE PRESO.       |
//| 08/08/2026 -- si chiede al broker, non al tick value nudo: su     |
//| 225JPY il tick value arriva non convertito e il lotto usciva ~0,  |
//| finendo SEMPRE al minimo. OrderCalcProfit converte correttamente; |
//| il tick value resta come ripiego. Sui simboli sani i due calcoli  |
//| coincidono: il comportamento cambia SOLO dove il tick value mente.|
//+------------------------------------------------------------------+
double PerditaPerLotto(const double slDist)
  {
   if(slDist <= 0) return(0.0);
   double px   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double prof = 0.0;
   if(px > slDist && OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, px, px-slDist, prof) && prof < 0)
      return(-prof);
   double tv  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tsz = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || tsz <= 0) return(0.0);
   return((slDist/tsz)*tv);
  }

double NormVol(const double v)
  {
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(st <= 0) st = 0.01;
   double n = MathFloor(v/st)*st;
   return(n < mn ? 0.0 : n);
  }

int ContaPosizioni()
  {
   int n = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      n++;
     }
   return(n);
  }

ulong TrovaPosizione()
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      return(tk);
     }
   return(0);
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit e NON stampa un verdetto che nessuno legge: il
//  numero di blocchi falliti finisce nella colonna "Autotest
//  Falliti" del CSV di ottimizzazione.
//  REGOLA DI SCRITTURA: ogni blocco usa nomi di variabile con il
//  PROPRIO PREFISSO (a1_, a2_, ...). In MQL5 due dichiarazioni dello
//  stesso nome nello stesso scope sono un errore secco, e nessuna
//  rilettura distratta lo vede.
//==================================================================
void AutoTestAllineaLondra()
  {
   int falliti = 0;

   //--- BLOCCO 1: il motore LONG. Ordine giusto -> vero; una sola
   //    media fuori posto -> falso; prezzo sotto la veloce -> falso.
   bool a1_si  = AllineaLong_Calc(1.1010, 1.1005, 1.1004, 1.1003, 1.1002, 1.1001);
   bool a1_no1 = AllineaLong_Calc(1.1010, 1.1005, 1.1004, 1.1003, 1.1001, 1.1002); // 50 sotto la 200
   bool a1_no2 = AllineaLong_Calc(1.1000, 1.1005, 1.1004, 1.1003, 1.1002, 1.1001); // prezzo sotto
   bool a1_no3 = AllineaLong_Calc(1.1010, 0.0,    1.1004, 1.1003, 1.1002, 1.1001); // dato mancante
   if(!(a1_si && !a1_no1 && !a1_no2 && !a1_no3))
     { falliti++; Log("[AUTOTEST] 1 AllineaLong_Calc DIVERGE"); }

   //--- BLOCCO 2: il motore SHORT, specchio esatto del blocco 1.
   bool a2_si  = AllineaShort_Calc(1.0990, 1.0995, 1.0996, 1.0997, 1.0998, 1.0999);
   bool a2_no1 = AllineaShort_Calc(1.0990, 1.0995, 1.0996, 1.0997, 1.0999, 1.0998);
   bool a2_no2 = AllineaShort_Calc(1.1000, 1.0995, 1.0996, 1.0997, 1.0998, 1.0999);
   bool a2_deg = AllineaShort_Calc(1.0990, 1.0995, 1.0995, 1.0997, 1.0998, 1.0999); // pareggio: non e' ordine stretto
   if(!(a2_si && !a2_no1 && !a2_no2 && !a2_deg))
     { falliti++; Log("[AUTOTEST] 2 AllineaShort_Calc DIVERGE"); }

   //--- BLOCCO 3: IL FLAT NON E' DISATTIVABILE. E' il collaudo che
   //    conta piu' di tutti. Qualunque anticipo, anche assurdo, e in
   //    TUTTI E DUE i rami dell'ablazione, a fine giornata (23:59) e
   //    fuori sessione il flat DEVE essere vero.
   bool a3_tutte = true;
   int  a3_val[5]; a3_val[0]=-999999; a3_val[1]=0; a3_val[2]=15; a3_val[3]=720; a3_val[4]=999999;
   for(int a3_i = 0; a3_i < 5; a3_i++)
     {
      if(!DevoFlat_Calc(1439, true,  180, 645, a3_val[a3_i])) a3_tutte = false; // finestra accesa
      if(!DevoFlat_Calc(1439, false, 180, 645, a3_val[a3_i])) a3_tutte = false; // ablazione
      if(!DevoFlat_Calc(0,    true,  180, 645, a3_val[a3_i])) a3_tutte = false; // mezzanotte: fuori sessione
     }
   if(!a3_tutte)
     { falliti++; Log("[AUTOTEST] 3 DevoFlat_Calc NON e' ermetico: LA CHIUSURA FORZATA E' DISATTIVABILE"); }

   //--- BLOCCO 4: la geometria del flat con i default (03:00-10:45,
   //    anticipo 15' -> flat alle 10:30 = minuto 630).
   int  a4_f     = FlatSessioneMinuto_Calc(180, 645, 15);
   bool a4_prima = DevoFlat_Calc(629, true, 180, 645, 15);   // 10:29 -> ancora no
   bool a4_esatt = DevoFlat_Calc(630, true, 180, 645, 15);   // 10:30 -> si'
   bool a4_dentro= DevoFlat_Calc(300, true, 180, 645, 15);   // 05:00 -> no
   bool a4_pre   = DevoFlat_Calc(179, true, 180, 645, 15);   // 02:59 -> fuori sessione, si'
   int  a4_g     = FlatGiornataMinuto_Calc(15);              // 1424 = 23:44
   if(!(a4_f == 630 && !a4_prima && a4_esatt && !a4_dentro && a4_pre && a4_g == 1424))
     { falliti++; Log("[AUTOTEST] 4 geometria del flat DIVERGE"); }

   //--- BLOCCO 5: la finestra d'ingresso e LA CELLA DI ABLAZIONE.
   //    Con la finestra accesa si entra solo dentro 03:00-08:45; con
   //    la finestra spenta si entra a qualunque ora.
   bool a5_dentro = DentroFinestraIngresso_Calc(300, true,  180, 525);  // 05:00 -> si'
   bool a5_bordoA = DentroFinestraIngresso_Calc(180, true,  180, 525);  // 03:00 -> si' (estremo incluso)
   bool a5_bordoB = DentroFinestraIngresso_Calc(525, true,  180, 525);  // 08:45 -> si' (estremo incluso)
   bool a5_fuori  = DentroFinestraIngresso_Calc(526, true,  180, 525);  // 08:46 -> no
   bool a5_prima  = DentroFinestraIngresso_Calc(179, true,  180, 525);  // 02:59 -> no
   bool a5_abl1   = DentroFinestraIngresso_Calc(1200, false, 180, 525); // ablazione -> si'
   bool a5_abl2   = DentroFinestraIngresso_Calc(0,    false, 180, 525); // ablazione -> si'
   if(!(a5_dentro && a5_bordoA && a5_bordoB && !a5_fuori && !a5_prima && a5_abl1 && a5_abl2))
     { falliti++; Log("[AUTOTEST] 5 finestra d'ingresso / ablazione DIVERGE"); }

   //--- BLOCCO 6: il lotto dal rischio e il suo FLOOR.
   //    650 di rischio con 100 di perdita per lotto -> 6,5 lotti.
   double a6_g   = LottoGrezzo_Calc(100000.0, 0.65, 100.0);
   bool   a6_m1  = false;
   double a6_n   = NormalizzaLotto_Calc(a6_g, 0.01, 100.0, 0.01, a6_m1);
   bool   a6_m2  = false;
   double a6_p   = NormalizzaLotto_Calc(0.001, 0.01, 100.0, 0.01, a6_m2);   // sotto il minimo -> floor
   bool   a6_m3  = false;
   double a6_z   = NormalizzaLotto_Calc(0.0,   0.01, 100.0, 0.01, a6_m3);   // niente lotto -> 0
   double a6_bad = LottoGrezzo_Calc(100000.0, 0.65, 0.0);                   // stop nullo -> 0
   if(MathAbs(a6_g - 6.5) > 0.0001 || MathAbs(a6_n - 6.5) > 0.0001 || a6_m1 ||
      MathAbs(a6_p - 0.01) > 0.0001 || !a6_m2 || MathAbs(a6_z) > 0.0001 ||
      MathAbs(a6_bad) > 0.0001)
     { falliti++; Log("[AUTOTEST] 6 lotto da rischio / floor DIVERGE"); }

   //--- BLOCCO 7: il filtro di spread in % dello stop.
   bool a7_spento = SpreadTroppoLargo_Calc(0.00050, 0.00100, 0.0);   // spento -> mai troppo largo
   bool a7_ok     = SpreadTroppoLargo_Calc(0.00005, 0.00100, 10.0);  // 5% di 100 punti -> passa
   bool a7_no     = SpreadTroppoLargo_Calc(0.00015, 0.00100, 10.0);  // 15% -> non passa
   bool a7_nostop = SpreadTroppoLargo_Calc(0.00005, 0.0,     10.0);  // senza stop -> non passa
   if(!(!a7_spento && !a7_ok && a7_no && a7_nostop))
     { falliti++; Log("[AUTOTEST] 7 SpreadTroppoLargo_Calc DIVERGE"); }

   //--- BLOCCO 8: la tosatura, mattone della terza difesa.
   int a8_1 = Clamp_Calc(-5, 0, 10);
   int a8_2 = Clamp_Calc(50, 0, 10);
   int a8_3 = Clamp_Calc(7,  0, 10);
   int a8_4 = MinutoDelGiorno_Calc(10, 45);      // 645
   int a8_5 = MinutoDelGiorno_Calc(99, 99);      // tosato a 23:59 = 1439
   if(!(a8_1 == 0 && a8_2 == 10 && a8_3 == 7 && a8_4 == 645 && a8_5 == 1439))
     { falliti++; Log("[AUTOTEST] 8 Clamp_Calc / MinutoDelGiorno_Calc DIVERGE"); }

   gAutotestFalliti = falliti;
   Log(StringFormat("esito motore: %d BLOCCHI SU 8 PASSATI (falliti %d). L'esito vero esce nella colonna 'Autotest Falliti' del CSV: in ottimizzazione questa riga NON la legge nessuno.",
                    8 - falliti, falliti));
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.      //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                 //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione)//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

double OnTester()
  {
   //--- ATTENZIONE: 'stats', l'header e lo StringFormat di
   //    OnTesterDeinit SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta
   //    a uno solo dei tre sfasa tutto il CSV e chi legge trova il
   //    numero sbagliato sotto il nome giusto.
   double stats[27];
   stats[0]  = TesterStatistics(STAT_PROFIT);
   stats[1]  = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2]  = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3]  = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4]  = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5]  = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6]  = TesterStatistics(STAT_TRADES);
   //--- IL NUMERO DELLA RIGA PROP: il muro FTMO e' GIORNALIERO, e il
   //    dossier lo dice esplicitamente ("il numero da guardare non e'
   //    il DD totale: e' la PEGGIOR GIORNATA").
   stats[7]  = gWorstDayPct;
   //--- ANATOMIA DEGLI INGRESSI
   stats[8]  = (double)gIngressiTot;
   stats[9]  = (double)gIngressiLong;
   stats[10] = (double)gIngressiShort;
   //--- ANATOMIA DELLE USCITE: dice CHI ha chiuso le posizioni.
   stats[11] = (double)gUsciteFlat;      // le abbiamo chiuse noi a fine sessione
   stats[12] = (double)gUsciteMercato;   // stop o take
   stats[13] = (double)gNottiAttrav;     // DEVE essere 0: se non lo e', il flat non e' ermetico
   //--- CANARINI
   stats[14] = (double)gLottiAlMinimo;   // rischio REALE piu' alto del dichiarato, quante volte
   stats[15] = (double)gSaltiSpread;     // quanto morde il filtro di spread
   stats[16] = (double)gGiorniTetto;     // giornate in cui il tetto di 2 ha BLOCCATO un segnale
   stats[17] = (double)gParziali;
   stats[18] = (double)gBreakeven;
   //--- ECO DELLA CONFIGURAZIONE: sono i numeri che l'EA ha DAVVERO
   //    usato, non quello che l'.ini credeva di passargli. La finestra
   //    esce in minuti-del-giorno, cosi' non serve ricostruirla.
   stats[19] = (InpUsaFinestraSessione ? 1.0 : 0.0);   // LA CELLA DI ABLAZIONE, in colonna
   stats[20] = (double)MinInizio();
   stats[21] = (double)MinIngressi();
   stats[22] = (double)MinFine();
   stats[23] = (double)InpFlatAnticipoMin;
   stats[24] = (double)(InpUsaFinestraSessione ? FlatSessioneMinuto_Calc(MinInizio(), MinFine(), InpFlatAnticipoMin)
                                               : FlatGiornataMinuto_Calc(InpFlatAnticipoMin));
   //--- COLLAUDO E OCCASIONI
   stats[25] = (double)gAutotestFalliti; // 0 = tutti passati; >0 DIVERGE; -1 non eseguito
   stats[26] = (double)gBarreAllineate;  // occasioni del MOTORE, prima dei cancelli del CONTENITORE

   //--- criterio: Recovery Factor, come il resto della flotta (robusto
   //    al singolo trade fortunato). La cella si sceglie comunque al
   //    CENTRO DELL'ALTOPIANO, mai sul picco: il criterio ordina, non
   //    promuove.
   double criterion = stats[3];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
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
         //--- 29 nomi = Pass + Simbolo + 27 valori di stats[].
         string head = "Pass,Simbolo,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Ingressi Totali,Ingressi Long,Ingressi Short,Uscite Flat,Uscite Stop O Take,Notti Attraversate,Lotti Al Minimo,Ingressi Saltati Spread,Giorni Tetto Bloccante,Parziali Eseguite,Breakeven Eseguiti,Finestra Sessione,Minuto Inizio Sessione,Minuto Fine Ingressi,Minuto Fine Sessione,Flat Anticipo Min,Minuto Flat Calcolato,Autotest Falliti,Barre Allineate";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 29 specificatori = 29 argomenti (pass, _Symbol, data[0..26]).
      string row = StringFormat("%d,%s,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, _Symbol,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25], data[26]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
