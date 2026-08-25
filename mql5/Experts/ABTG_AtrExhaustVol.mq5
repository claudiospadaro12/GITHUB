//+------------------------------------------------------------------+
//|                                       ABTG_AtrExhaustVol.mq5     |
//|                                                                  |
//|  EA "ATR EXHAUSTION & VOLUME SPIKE" - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  DA DOVE VIENE (attribuzione obbligatoria)                       |
//|    Porting del Pine Script "ATR Exhaustion & Volume Spike        |
//|    Strategy" di MyStrategyHub (TradingView, creato 2026-04-07,   |
//|    v1.0, scriptAccess open_no_auth, nessuna licenza dichiarata   |
//|    nel sorgente).                                                |
//|    https://www.tradingview.com/script/8ltrS3Yg-ATR-Exhaustion-Volume-Spike-Strategy/
//|    Copia del sorgente in casa:                                   |
//|      backtest_pipeline/caccia_strategie/biblioteca/sorgenti/     |
//|      AtrExhaustionVolumeSpike_MyStrategyHub_tv8ltrS3Yg_2026-08-25.pine
//|    Scheda del candidato (P2, voto 9/10):                         |
//|      backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md
//|    Tesi del porting (scostamenti dichiarati uno per uno):        |
//|      ATREXHAUST_TESI.md                                          |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in       |
//|  forward finche' un round a TICK REALI non lo promuove.          |
//|                                                                  |
//|  LA TESI IN UNA RIGA                                             |
//|    Un movimento che arriva a un livello strutturale dopo essersi |
//|    allungato piu' di 2 ATR ha gia' speso il carburante: se li'   |
//|    sopra arriva un picco di volume, quel volume non e'           |
//|    continuazione, e' chi chiude.                                 |
//|                                                                  |
//|  IL MOTORE - TRE CONDIZIONI, TUTTE NECESSARIE INSIEME            |
//|    (a) PROSSIMITA'  il minimo (long) / massimo (short) della     |
//|        barra di segnale sta dentro la tolleranza dal PIVOT       |
//|        confermato a (5,5) barre dal lato dell'ingresso;          |
//|    (b) ESAURIMENTO  la strada percorsa DAL PIVOT OPPOSTO supera  |
//|        InpAtrExhaustMult x ATR(InpAtrPeriod);                    |
//|    (c) VOLUME       il volume della barra di segnale supera      |
//|        InpVolSpikeMult x la media a InpVolSmaBars barre.         |
//|    piu' un grilletto di price action (modo AUTORE di default).   |
//|    Simmetrico long/short: stesso codice, estremi specchiati.     |
//|                                                                  |
//|  IL VOLUME E' COSTITUTIVO, NON UN FILTRO.                        |
//|    Non esiste nessun input che lo spenga: senza picco di volume  |
//|    NON C'E' STRATEGIA, e un EA che potesse girare senza sarebbe  |
//|    un altro motore, non questo. E' esattamente il punto della    |
//|    scheda P2: in casa il volume l'abbiamo misurato due volte     |
//|    solo come FILTRO APPICCICATO (R12: 48/48 negative OOS;        |
//|    R101 gradino 02_volumi: unico sopravvissuto). Qui e' il       |
//|    motore. Se il dato di volume non e' disponibile il segnale    |
//|    NON passa (a differenza dei filtri opzionali di casa, che a   |
//|    dati mancanti lasciano passare: un filtro senza dati non deve |
//|    inventare un veto, ma un MOTORE senza dati non esiste).       |
//|                                                                  |
//|  QUALE VOLUME: TICK VOLUME (numero di tick della barra).         |
//|    Su MT5 e sugli indici CFD di BCM il volume scambiato non      |
//|    esiste nel feed: SYMBOL_VOLUME_REAL non e' garantito. Il Pine |
//|    dell'autore usa il volume del suo feed, che su un future e'   |
//|    volume vero. E' uno scostamento DICHIARATO, non un dettaglio: |
//|    il tick volume e' un buon sostituto (correla con l'attivita') |
//|    ma NON e' la stessa misura. Vale la stessa convenzione degli  |
//|    altri EA ABTG (VolumeOK di ABTG_CrossEma).                    |
//|                                                                  |
//|  DOVE DEVE GIRARE: INDICI (D30EUR, U30USD, NASUSD), M15 (e M5    |
//|  come seconda cella). Nessun calcolo assume il forex: la         |
//|  distanza dello stop e' in PREZZO, il lotto esce da              |
//|  OrderCalcProfit (che converte in valuta conto) e il ripiego e'  |
//|  tick value / tick size. Le soglie in "punti" sono PUNTI MT5     |
//|  (_Point), non punti indice: su U30USD e NASUSD 1 punto indice   |
//|  = 100 punti MT5 (misura R97).                                   |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Le tre condizioni si leggono sulla  |
//|  barra [1] (l'ultima chiusa) e l'ingresso parte all'apertura     |
//|  della barra nuova: e' l'equivalente MT5 del comportamento di    |
//|  default di uno strategy Pine (calc_on_every_tick = false).      |
//|  I pivot sono confermati InpPivotRight barre dopo: NON           |
//|  ridipingono, per costruzione.                                   |
//|                                                                  |
//|  CAP GIORNALIERO OBBLIGATORIO (criterio C6 del dossier): con     |
//|  tre indici accesi tre esaurimenti sullo stesso pomeriggio sono  |
//|  tre stop correlati in una seduta. InpMaxTradesPerDay parte a 3, |
//|  ed e' l'unico default che si scosta dall'autore per regola di   |
//|  casa e non per misura.                                          |
//|                                                                  |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO      |
//|  rispetto all'ora italiana (DAX 09:00 IT = 08:00 server).        |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le    |
//|  stringhe, niente emoji (regola di casa dei .ps1, estesa qui     |
//|  perche' i log finiscono negli stessi strumenti).                |
//|  NON compilato ne' testato da chi ha scritto il file: compilare  |
//|  in MetaEditor e validare nel tester A TICK REALI.               |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - porting da MyStrategyHub (TradingView 8ltrS3Yg)"
#property version   "1.00"
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

//--- Come si misura la PROSSIMITA' al livello.
//    PERC = come l'autore: tolleranza in % del PREZZO del pivot.
//    ATR  = tolleranza in frazioni di ATR (proposta della scheda P2).
//    Il default e' l'AUTORE, cosi' la cella nuda del round e' il Pine
//    tradotto e non una nostra variante gia' cucinata.
enum ENUM_EX_PROX { EX_PROX_PERC=0, EX_PROX_ATR=1 };

//--- Il grilletto di price action.
//    AUTORE = close>open oppure close>high[1] (specchiato per lo short).
//    CLOSE  = la barra chiude nel InpTrigClosePct% del proprio range dal
//             lato favorevole (grilletto preso dal candidato P1).
enum ENUM_EX_TRIG { EX_TRIG_AUTORE=0, EX_TRIG_CLOSE=1 };

//==================================================================
//  INPUT
//==================================================================
input group "=== MOTORE (costitutivo: non si spegne) ==="
input int    InpPivotLeft      = 5;      // Spalla SINISTRA del pivot (autore: 5)
input int    InpPivotRight     = 5;      // Spalla DESTRA del pivot, = barre di conferma (autore: 5)
input ENUM_EX_PROX InpProxMode = EX_PROX_PERC; // Tolleranza al livello: % del prezzo (autore) o ATR
input double InpProxPercent    = 0.5;    // (modo PERC) tolleranza in % del prezzo del pivot (autore: 0.5)
input double InpProxAtrMult    = 0.5;    // (modo ATR) tolleranza = X * ATR
input int    InpAtrPeriod      = 14;     // Periodo ATR (autore: 14)
input double InpAtrExhaustMult = 2.0;    // Esaurimento: strada dal pivot opposto > X * ATR (autore: 2.0)
input int    InpVolSmaBars     = 20;     // Barre della media volume (autore: 20 = default di casa)
input double InpVolSpikeMult   = 1.5;    // Picco: volume > X * media (autore: 1.5 = soglia di casa)
input ENUM_EX_TRIG InpTrigMode = EX_TRIG_AUTORE; // Grilletto price action
input double InpTrigClosePct   = 70.0;   // (modo CLOSE) chiusura oltre il X% del range dal lato favorevole
input bool   InpAllowLong      = true;   // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort     = true;   // Ammetti gli SHORT

input group "=== Stop, target, gestione ==="
input double InpSLBufferPts    = 0;      // Buffer OLTRE il pivot, in punti MT5 (0 = autore: stop sul livello)
input double InpMinSLPts       = 0;      // Pavimento minimo dello stop, in punti MT5 (0 = spento)
input double InpTP_RR          = 2.0;    // TP = X volte R (autore: 2.0). 0 = nessun TP
input double InpTP1_RR         = 1.0;    // Primo target del parziale, in R
input double InpTP1Pct         = 0;      // % chiusa al primo target (0 = parziale SPENTO = autore)
input bool   InpBreakeven      = true;   // Stop in pari al primo target (inerte se InpTP1Pct = 0)
input bool   InpUseTrailAtr    = false;  // Trailing dello stop in ATR (opt-in)
input double InpTrailAtrMult   = 2.0;    // Trailing = X * ATR

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay   = 3;   // Max ingressi al giorno (C6: obbligatorio, 0 = illimitato)
input bool   InpOneTradePerLevel  = false; // Un LIVELLO = un trade (l'autore non ce l'ha)
input bool   InpUseHourFilter     = false; // Filtro orario sulla barra di segnale (ORA SERVER)
input int    InpHourStart         = 8;   // Ora SERVER di inizio (inclusa). BCM: 8 = 09:00 IT
input int    InpHourEnd           = 20;  // Ora SERVER di fine (inclusa)
input bool   InpFridayClose       = false; // Venerdi': chiudi tutto oltre l'ora e non riaprire
input int    InpFridayCloseHour   = 20;  // Ora SERVER del venerdi' oltre cui chiudo

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;       // Rischio per trade, % del saldo (autore: 0.5; in campo si gira a 0.65)

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter    = false;
input string InpNewsFile         = "abtg_news.csv";
input int    InpNewsMinImpact    = 3;
input int    InpNewsBeforeMin    = 30;
input int    InpNewsAfterMin     = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies   = "";

input group "=== Generali ==="
input string InpComment   = "ATREXH";   // Commento sugli ordini
input long   InpMagic     = 774401;     // Numero magico (blocco 7744xx: VERGINE, verificato nel repo il 25/08/2026)
input int    InpMaxSpread = 0;          // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose   = true;       // Messaggi nel log
input bool   InpAutoTest  = true;       // Stampa le righe [ATREXH][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hAtr = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;

//--- ultimi pivot CONFERMATI (0 = mai visto). Il tempo serve alla regola
//    "un livello = un trade": due pivot allo stesso prezzo ma su barre
//    diverse sono due livelli diversi.
double   gLastPH = 0.0, gLastPL = 0.0;
datetime gLastPHTime = 0, gLastPLTime = 0;
datetime gUsedPHTime = 0, gUsedPLTime = 0;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[ATREXH] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| PIVOT HIGH confermato.                                            |
//| L'array e' indicizzato "a serie": indice piccolo = barra recente.  |
//| c = indice della barra CANDIDATA (il centro); a DESTRA (piu'       |
//| recenti) stanno c-1..c-right, a SINISTRA (piu' vecchie) c+1..c+left|
//| Confronto STRETTO su entrambi i lati: un plateau (due massimi      |
//| identici) NON e' un pivot. [SCELTA DICHIARATA: la semantica esatta |
//| dei pareggi in ta.pivothigh non e' documentata; lo stretto perde   |
//| qualche pivot ma non ne inventa nessuno.]                          |
//+------------------------------------------------------------------+
bool PivotHigh_Calc(const double &h[], const int c, const int left, const int right)
  {
   if(left<1 || right<1) return(false);
   if(c-right < 0) return(false);
   if(ArraySize(h) < c+left+1) return(false);
   for(int j=c-right; j<=c+left; j++)
     {
      if(j==c) continue;
      if(h[j] >= h[c]) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| PIVOT LOW confermato. Specchio esatto del precedente.              |
//+------------------------------------------------------------------+
bool PivotLow_Calc(const double &l[], const int c, const int left, const int right)
  {
   if(left<1 || right<1) return(false);
   if(c-right < 0) return(false);
   if(ArraySize(l) < c+left+1) return(false);
   for(int j=c-right; j<=c+left; j++)
     {
      if(j==c) continue;
      if(l[j] <= l[c]) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| PROSSIMITA' al livello. La tolleranza arriva gia' calcolata da     |
//| fuori (in % del prezzo oppure in ATR): qui e' una distanza in      |
//| prezzo, e la regola e' una sola per tutti i modi.                  |
//| Equivalente esatto del doppio confronto dell'autore:               |
//|   low <= pl*(1+p) and low >= pl*(1-p)   <=>   |low-pl| <= pl*p     |
//+------------------------------------------------------------------+
bool Prossimita_Calc(const double estremoBarra, const double livello, const double tolleranza)
  {
   if(livello<=0 || tolleranza<=0) return(false);
   return(MathAbs(estremoBarra-livello) <= tolleranza);
  }

//+------------------------------------------------------------------+
//| ESAURIMENTO. distanza = strada percorsa dal pivot OPPOSTO fino     |
//| all'estremo della barra di segnale. Confronto STRETTO come         |
//| l'autore (dist > atr*mult).                                        |
//| atr<=0 = dato non utilizzabile: NON passa. E' una condizione       |
//| costitutiva, non un filtro: senza ATR non c'e' misura di           |
//| esaurimento e quindi non c'e' segnale.                             |
//+------------------------------------------------------------------+
bool Esaurimento_Calc(const double distanza, const double atr, const double mult)
  {
   if(atr<=0 || mult<=0) return(false);
   return(distanza > atr*mult);
  }

//+------------------------------------------------------------------+
//| PICCO DI VOLUME -- il cuore del motore.                            |
//| media<=0 = dato mancante -> NON passa (vedi la nota in testa: un   |
//| motore senza il suo dato non esiste). Confronto STRETTO come       |
//| l'autore (volume > sma*mult).                                      |
//+------------------------------------------------------------------+
bool VolumeSpike_Calc(const double volSegnale, const double media, const double mult)
  {
   if(media<=0 || mult<=0) return(false);
   return(volSegnale > media*mult);
  }

//+------------------------------------------------------------------+
//| GRILLETTO modo AUTORE.                                             |
//|   long : close > open  oppure  close > high della barra precedente |
//|   short: close < open  oppure  close < low  della barra precedente |
//+------------------------------------------------------------------+
bool TriggerAutore_Calc(const bool isLong, const double o, const double c,
                        const double hPrev, const double lPrev)
  {
   if(isLong) return(c>o || c>hPrev);
   return(c<o || c<lPrev);
  }

//+------------------------------------------------------------------+
//| GRILLETTO modo CLOSE: la barra chiude oltre il pct% del proprio    |
//| range dal lato favorevole (long = in alto, short = in basso).      |
//| range nullo (barra piatta) = niente segnale.                       |
//+------------------------------------------------------------------+
bool TriggerChiusura_Calc(const bool isLong, const double h, const double l,
                          const double c, const double pct)
  {
   double range = h-l;
   if(range<=0) return(false);
   double pos = (c-l)/range;                  // 0 = chiude sul minimo, 1 = sul massimo
   if(isLong) return(pos >= pct/100.0);
   return(pos <= 1.0-pct/100.0);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE COMPLETO DI UN LATO -- le TRE condizioni piu' il        |
//| grilletto, tutte necessarie insieme. Ordine voluto: prossimita',   |
//| esaurimento, volume, grilletto (dalla piu' selettiva alla meno).   |
//+------------------------------------------------------------------+
bool SegnaleLato_Calc(const bool isLong,
                      const double livelloProx, const double livelloOpp,
                      const double estremoBarra, const double tolleranza,
                      const double atr, const double atrMult,
                      const double vol, const double volMedia, const double volMult,
                      const bool trigger)
  {
   if(livelloProx<=0 || livelloOpp<=0) return(false);      // pivot mai visto
   if(!Prossimita_Calc(estremoBarra,livelloProx,tolleranza)) return(false);
   double dist = isLong ? (livelloOpp-estremoBarra) : (estremoBarra-livelloOpp);
   if(!Esaurimento_Calc(dist,atr,atrMult)) return(false);
   if(!VolumeSpike_Calc(vol,volMedia,volMult)) return(false);   // COSTITUTIVO
   return(trigger);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop. Se lo stop strutturale e' piu' vicino del    |
//| pavimento, lo stop si ALLARGA al pavimento (semantica di           |
//| "minimo"), non si salta il trade. pavimento<=0 = spento.           |
//| Serve perche' uno stop strutturale puo' nascere a due punti dal    |
//| prezzo: li' il lotto per rischio esplode e lo slippage si mangia   |
//| l'operazione intera.                                               |
//+------------------------------------------------------------------+
double PavimentoSL_Calc(const bool isLong, const double entry,
                        const double slGrezzo, const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R >= pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Filtro orario -- nucleo. Estremi INCLUSI. Gestisce anche la        |
//| fascia a cavallo della mezzanotte (start>end).                     |
//+------------------------------------------------------------------+
bool OraAmmessa_Calc(const int ora, const int start, const int end)
  {
   if(start<=end) return(ora>=start && ora<=end);
   return(ora>=start || ora<=end);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpPivotLeft<1 || InpPivotRight<1)
     { Print("ERRORE: le spalle del pivot devono essere >= 1."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpAtrExhaustMult<=0)
     { Print("ERRORE: InpAtrExhaustMult deve essere > 0: senza esaurimento non e' questo motore."); return(INIT_FAILED); }
   if(InpVolSmaBars<2)
     { Print("ERRORE: InpVolSmaBars deve essere >= 2."); return(INIT_FAILED); }
   if(InpVolSpikeMult<=0)
     { Print("ERRORE: InpVolSpikeMult deve essere > 0: il picco di volume E' il motore."); return(INIT_FAILED); }
   if(InpProxMode==EX_PROX_PERC && InpProxPercent<=0)
     { Print("ERRORE: InpProxPercent deve essere > 0 nel modo PERC."); return(INIT_FAILED); }
   if(InpProxMode==EX_PROX_ATR && InpProxAtrMult<=0)
     { Print("ERRORE: InpProxAtrMult deve essere > 0 nel modo ATR."); return(INIT_FAILED); }
   if(InpTrigMode==EX_TRIG_CLOSE && (InpTrigClosePct<=50.0 || InpTrigClosePct>100.0))
     { Print("ERRORE: InpTrigClosePct deve stare fra 51 e 100 nel modo CLOSE."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione: se qualcosa e' acceso, la cella
   //    NON e' la cella "autore". Non lo spegne l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova lo pinna.
   if(InpProxMode!=EX_PROX_PERC || InpTrigMode!=EX_TRIG_AUTORE || InpTP1Pct>0 ||
      InpUseTrailAtr || InpOneTradePerLevel || InpSLBufferPts>0 || InpMinSLPts>0 ||
      InpUseHourFilter || InpUseNewsFilter || InpFridayClose)
      Log("ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' la cella AUTORE del porting.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestAtrExhaust();

   Log(StringFormat("avviato su %s %s. pivot %d/%d, ATR(%d) x %.2f, volume > %.2f x media(%d) [TICK VOLUME], TP %.2f R, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpPivotLeft, InpPivotRight, InpAtrPeriod, InpAtrExhaustMult,
       InpVolSpikeMult, InpVolSmaBars, InpTP_RR, InpRiskPercent,
       InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(FridayCloseCheck()) return;      // venerdi' oltre l'ora: chiudo e non riapro

   //--- Sta QUI e non dopo il filtro della nuova barra: su M15 la caduta
   //    peggiore di giornata succede in mezzo a una candela.
   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari / trailing: a ogni tick

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
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

//+------------------------------------------------------------------+
//| Il giro di una barra nuova.                                       |
//| I pivot si aggiornano SEMPRE e per primi, anche con una posizione |
//| aperta: la memoria dei livelli non deve avere buchi, altrimenti   |
//| dopo ogni trade il motore riparte cieco.                          |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   AggiornaPivot();

   if(CountPositions()>0) return;                       // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!OraOK())    return;
   if(!SpreadOK()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;

   //--- i dati della barra di SEGNALE [1] e della barra prima [2]
   double o1 = iOpen (_Symbol,gTF,1);
   double h1 = iHigh (_Symbol,gTF,1);
   double l1 = iLow  (_Symbol,gTF,1);
   double c1 = iClose(_Symbol,gTF,1);
   double h2 = iHigh (_Symbol,gTF,2);
   double l2 = iLow  (_Symbol,gTF,2);
   if(o1<=0 || h1<=0 || l1<=0 || c1<=0) return;

   double atr = AtrVal();
   if(atr<=0) return;                                   // senza ATR non c'e' esaurimento

   double volSeg=0, volMedia=0;
   if(!LeggiVolume(volSeg,volMedia)) return;            // senza volume NON c'e' strategia

   //--- LONG: prossimita' al pivot BASSO, esaurimento misurato dal pivot ALTO
   if(InpAllowLong && !(InpOneTradePerLevel && gLastPLTime==gUsedPLTime && gUsedPLTime>0))
     {
      double tol = Tolleranza(gLastPL, atr);
      bool trig = Trigger(true,o1,h1,l1,c1,h2,l2);
      if(SegnaleLato_Calc(true, gLastPL, gLastPH, l1, tol, atr, InpAtrExhaustMult,
                          volSeg, volMedia, InpVolSpikeMult, trig))
        {
         //--- SL strutturale: il piu' PROTETTIVO fra pivot e minimo della
         //    barra di segnale (regola dell'autore), meno il buffer.
         double slStrut = MathMin(gLastPL,l1) - InpSLBufferPts*_Point;
         if(Enter(true,slStrut)) gUsedPLTime = gLastPLTime;
         return;                                        // una sola decisione per barra
        }
     }

   //--- SHORT: prossimita' al pivot ALTO, esaurimento misurato dal pivot BASSO
   if(InpAllowShort && !(InpOneTradePerLevel && gLastPHTime==gUsedPHTime && gUsedPHTime>0))
     {
      double tol = Tolleranza(gLastPH, atr);
      bool trig = Trigger(false,o1,h1,l1,c1,h2,l2);
      if(SegnaleLato_Calc(false, gLastPH, gLastPL, h1, tol, atr, InpAtrExhaustMult,
                          volSeg, volMedia, InpVolSpikeMult, trig))
        {
         double slStrut = MathMax(gLastPH,h1) + InpSLBufferPts*_Point;
         if(Enter(false,slStrut)) gUsedPHTime = gLastPHTime;
        }
     }
  }

//==================================================================
//  LETTURA DEI DATI (il pensiero sta nel nucleo puro)
//==================================================================

//+------------------------------------------------------------------+
//| Aggiorna gli ultimi pivot CONFERMATI.                             |
//| La barra candidata e' la [1+InpPivotRight]: ha gia' tutte le sue  |
//| barre di conferma a destra CHIUSE. Nessuna barra in formazione    |
//| entra nel calcolo -> niente ridipintura, niente look-ahead.       |
//+------------------------------------------------------------------+
void AggiornaPivot()
  {
   int c    = 1 + InpPivotRight;                  // indice della barra centrale
   int need = c + InpPivotLeft + 1;               // quante barre servono in tutto
   if(Bars(_Symbol,gTF) < need+2) return;

   double hi[], lo[];
   ArraySetAsSeries(hi,true);
   ArraySetAsSeries(lo,true);
   if(CopyHigh(_Symbol,gTF,0,need,hi) < need) return;
   if(CopyLow (_Symbol,gTF,0,need,lo) < need) return;

   if(PivotHigh_Calc(hi,c,InpPivotLeft,InpPivotRight))
     {
      gLastPH     = hi[c];
      gLastPHTime = iTime(_Symbol,gTF,c);
     }
   if(PivotLow_Calc(lo,c,InpPivotLeft,InpPivotRight))
     {
      gLastPL     = lo[c];
      gLastPLTime = iTime(_Symbol,gTF,c);
     }
  }

//+------------------------------------------------------------------+
//| Tolleranza di prossimita' in PREZZO, secondo il modo scelto.      |
//+------------------------------------------------------------------+
double Tolleranza(const double livello, const double atr)
  {
   if(InpProxMode==EX_PROX_ATR) return(atr*InpProxAtrMult);
   return(livello*InpProxPercent/100.0);
  }

//+------------------------------------------------------------------+
//| Grilletto di price action, secondo il modo scelto.                |
//+------------------------------------------------------------------+
bool Trigger(const bool isLong, const double o1, const double h1, const double l1,
             const double c1, const double h2, const double l2)
  {
   if(InpTrigMode==EX_TRIG_CLOSE) return(TriggerChiusura_Calc(isLong,h1,l1,c1,InpTrigClosePct));
   return(TriggerAutore_Calc(isLong,o1,c1,h2,l2));
  }

//+------------------------------------------------------------------+
//| TICK VOLUME della barra di segnale [1] e media delle              |
//| InpVolSmaBars barre PRECEDENTI ([2] in poi).                      |
//| La barra di segnale NON entra nella sua media: altrimenti si      |
//| confronterebbe con se stessa e alzerebbe da sola la soglia.       |
//| [SCOSTAMENTO DICHIARATO: ta.sma(volume,20) dell'autore INCLUDE la |
//|  barra corrente. La differenza e' minima -- con inclusione la     |
//|  soglia effettiva sale da 1,50x a ~1,54x -- ma la convenzione di  |
//|  casa (VolumeOK di ABTG_CrossEma) e' l'esclusione, e due EA che   |
//|  misurano "il volume" in due modi diversi non sono confrontabili.]|
//| Ritorna false se il dato non basta: il motore non parte.          |
//+------------------------------------------------------------------+
bool LeggiVolume(double &volSegnale, double &media)
  {
   volSegnale=0; media=0;
   int n = InpVolSmaBars;
   if(n<2) return(false);
   long v[];
   ArraySetAsSeries(v,true);
   if(CopyTickVolume(_Symbol,gTF,1,n+1,v) < n+1) return(false);
   double somma=0;
   for(int i=1;i<=n;i++) somma += (double)v[i];
   volSegnale = (double)v[0];
   media      = somma/n;
   return(media>0 && volSegnale>0);
  }

//--- Orario della BARRA DI SEGNALE, in ORA SERVER (mai l'ora italiana:
//    regola di casa, il server BCM e' un'ora indietro).
bool OraOK()
  {
   if(!InpUseHourFilter) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   return(OraAmmessa_Calc(t.hour, InpHourStart, InpHourEnd));
  }

double AtrVal()
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0);
   return(a[0]);
  }

//==================================================================
//  INGRESSO
//==================================================================
//+------------------------------------------------------------------+
//| Apre a mercato. slStrutturale e' gia' il livello (pivot/estremo   |
//| della barra + buffer): qui si applica solo il pavimento, si       |
//| normalizza e si controlla lo STOPS_LEVEL del broker.              |
//| Ritorna true SOLO se l'ordine e' partito davvero.                 |
//+------------------------------------------------------------------+
bool Enter(const bool isLong, const double slStrutturale)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double entry = isLong ? ask : bid;

   //--- lo stop dev'essere dalla parte giusta del prezzo: se il mercato
   //    e' gia' andato oltre il livello mentre la barra si chiudeva, il
   //    trade non ha piu' senso strutturale.
   if(isLong && slStrutturale>=entry){ Log("stop gia' sopra il prezzo: salto."); return(false); }
   if(!isLong && slStrutturale<=entry){ Log("stop gia' sotto il prezzo: salto."); return(false); }

   double sl = PavimentoSL_Calc(isLong, entry, slStrutturale, InpMinSLPts*_Point);
   sl = NormalizePrice(sl);
   double R = isLong ? (entry-sl) : (sl-entry);

   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=0 || R<=minDist)
     { Log("SL troppo vicino al prezzo (stops level): salto."); return(false); }

   double tp = 0;
   if(InpTP_RR>0)
     {
      tp = NormalizePrice(isLong ? entry+R*InpTP_RR : entry-R*InpTP_RR);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_AtrExhaustVol")) return(false);

   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      Log(StringFormat("%s @ %s SL %s TP %s lot %.2f (R %s | pivot L %s H %s)",
          isLong?"LONG":"SHORT",
          DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits),
          DoubleToString(gLastPL,_Digits), DoubleToString(gLastPH,_Digits)));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE
//==================================================================
//+------------------------------------------------------------------+
//| Parziale al primo target + stop in pari, poi trailing in ATR.     |
//| Gira a OGNI tick: il target si tocca in mezzo alla barra.         |
//|                                                                   |
//| NOTA SUL DEFAULT: con InpTP1Pct=0 e InpUseTrailAtr=false questo   |
//| blocco NON fa niente. E' voluto: la cella "autore" del round      |
//| dev'essere SL e TP a 2R e basta, come il Pine.                    |
//+------------------------------------------------------------------+
void ManageAll()
  {
   if(InpTP1Pct<=0 && !InpUseTrailAtr) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;
   double atr = (InpUseTrailAtr ? AtrVal() : 0);

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

      //--- primo target: parziale + stop in pari
      if(!beFatto && InpTP1Pct>0 && R>0)
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            //  LEZIONE PTE (04/08/2026): lo STOP IN PARI non deve dipendere
            //  dalla riuscita del parziale. Al lotto minimo NormVol() arrotonda
            //  a 0, il parziale non parte, e prima di quella lezione con lui
            //  saltava anche il breakeven: posizioni a +1,28R tornate in perdita
            //  con lo stop ancora all'originale.
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakeven)
              {
               gTrade.PositionModify(tk,NormalizePrice(openP),tp);
               beFatto = true;
              }
            Log(parz ? "primo target: parziale eseguito."
                     : "primo target: parziale impossibile al lotto minimo.");
           }
        }

      //--- trailing in ATR: lo stop si muove SOLO a favore, mai indietro
      if(InpUseTrailAtr && atr>0)
        {
         double slOra = PositionGetDouble(POSITION_SL);
         double tpOra = PositionGetDouble(POSITION_TP);
         if(isLong)
           {
            double n = NormalizePrice(bid-atr*InpTrailAtrMult);
            if(n>slOra && n<bid) gTrade.PositionModify(tk,n,tpOra);
           }
         else
           {
            double n = NormalizePrice(ask+atr*InpTrailAtrMult);
            if((slOra<=0 || n<slOra) && n>ask) gTrade.PositionModify(tk,n,tpOra);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Venerdi' oltre l'ora: chiudo tutto e non riapro.                  |
//| L'ora e' quella del SERVER (TimeCurrent), mai quella del PC.      |
//+------------------------------------------------------------------+
bool FridayCloseCheck()
  {
   if(!InpFridayClose) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(t.day_of_week!=5 || t.hour<InpFridayCloseHour) return(false);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         gTrade.PositionClose(p);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;              // conto a zero: niente da dividere
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

//--- Lotto dalla distanza dello stop, come negli altri EA ABTG.
//    PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026):
//    su 225JPY il tick value arriva non convertito in valuta conto e il
//    lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit converte
//    correttamente; il tick value resta come ripiego. Sui simboli sani i
//    due calcoli coincidono: cambia SOLO dove il tick value mente.
//    Su un INDICE (D30EUR, U30USD, NASUSD) questa e' la strada giusta:
//    la distanza e' in PREZZO, non in pip, e non c'e' nessuna ipotesi
//    forex nascosta nel calcolo.
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
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//==================================================================
void AutoTestAtrExhaust()
  {
   int falliti=0;

   PrintFormat("[ATREXH][AUTOTEST] pivot %d/%d | ATRx%.2f | vol>%.2fx(%d) | prox=%s | trig=%s | %s | magic %I64d",
               InpPivotLeft, InpPivotRight, InpAtrExhaustMult, InpVolSpikeMult, InpVolSmaBars,
               (InpProxMode==EX_PROX_PERC?"PERC":"ATR"),
               (InpTrigMode==EX_TRIG_AUTORE?"AUTORE":"CLOSE"),
               _Symbol, InpMagic);

   //--- IL PIVOT (indice 0 = barra piu' recente, come l'array a serie).
   //    Finestra 1+1 per leggerla a occhio: centro in posizione 1.
   double hOk[3]; hOk[0]=10.0; hOk[1]=12.0; hOk[2]=10.0;   // centro piu' alto dei due lati
   double hNo[3]; hNo[0]=13.0; hNo[1]=12.0; hNo[2]=10.0;   // il lato destro e' piu' alto
   double hEq[3]; hEq[0]=12.0; hEq[1]=12.0; hEq[2]=10.0;   // plateau: NON e' pivot (confronto stretto)
   bool p1 = PivotHigh_Calc(hOk,1,1,1);
   bool p2 = PivotHigh_Calc(hNo,1,1,1);
   bool p3 = PivotHigh_Calc(hEq,1,1,1);
   double lOk[3]; lOk[0]=10.0; lOk[1]= 8.0; lOk[2]=10.0;   // centro piu' basso dei due lati
   double lNo[3]; lNo[0]= 7.0; lNo[1]= 8.0; lNo[2]=10.0;   // il lato destro e' piu' basso
   bool p4 = PivotLow_Calc(lOk,1,1,1);
   bool p5 = PivotLow_Calc(lNo,1,1,1);
   PrintFormat("[ATREXH][AUTOTEST] pivot: high ok=%d (atteso 1) | high no=%d (atteso 0) | plateau=%d (atteso 0) | low ok=%d (atteso 1) | low no=%d (atteso 0)",
               (int)p1,(int)p2,(int)p3,(int)p4,(int)p5);
   if(!(p1 && !p2 && !p3 && p4 && !p5)) falliti++;

   //--- LA PROSSIMITA' (livello 100, tolleranza 0,5 = lo 0,5% di 100)
   bool x1 = Prossimita_Calc(100.3,100.0,0.5);   // dentro
   bool x2 = Prossimita_Calc( 99.7,100.0,0.5);   // dentro, dall'altro lato
   bool x3 = Prossimita_Calc(101.0,100.0,0.5);   // fuori
   bool x4 = Prossimita_Calc(100.5,100.0,0.5);   // sul bordo: incluso
   bool x5 = Prossimita_Calc(100.0,  0.0,0.5);   // livello mai visto -> niente segnale
   PrintFormat("[ATREXH][AUTOTEST] prossimita': dentro=%d (atteso 1) | sotto=%d (atteso 1) | fuori=%d (atteso 0) | bordo=%d (atteso 1) | livello 0=%d (atteso 0)",
               (int)x1,(int)x2,(int)x3,(int)x4,(int)x5);
   if(!(x1 && x2 && !x3 && x4 && !x5)) falliti++;

   //--- L'ESAURIMENTO (ATR 10, moltiplicatore 2 -> serve piu' di 20)
   bool e1 = Esaurimento_Calc(25.0,10.0,2.0);    // 2,5 ATR -> passa
   bool e2 = Esaurimento_Calc(15.0,10.0,2.0);    // 1,5 ATR -> blocca
   bool e3 = Esaurimento_Calc(20.0,10.0,2.0);    // esattamente 2 ATR -> blocca (confronto stretto)
   bool e4 = Esaurimento_Calc(25.0, 0.0,2.0);    // ATR mancante -> blocca (costitutivo)
   bool e5 = Esaurimento_Calc(-5.0,10.0,2.0);    // distanza negativa (prezzo oltre il pivot) -> blocca
   PrintFormat("[ATREXH][AUTOTEST] esaurimento: 2.5ATR=%d (atteso 1) | 1.5ATR=%d (atteso 0) | 2.0ATR=%d (atteso 0) | ATR 0=%d (atteso 0) | negativa=%d (atteso 0)",
               (int)e1,(int)e2,(int)e3,(int)e4,(int)e5);
   if(!(e1 && !e2 && !e3 && !e4 && !e5)) falliti++;

   //--- IL VOLUME (media 100, moltiplicatore 1,5 -> serve piu' di 150)
   bool v1 = VolumeSpike_Calc(200.0,100.0,1.5);  // 2,0x -> passa
   bool v2 = VolumeSpike_Calc(140.0,100.0,1.5);  // 1,4x -> blocca
   bool v3 = VolumeSpike_Calc(150.0,100.0,1.5);  // esattamente 1,5x -> blocca (stretto, come l'autore)
   bool v4 = VolumeSpike_Calc(200.0,  0.0,1.5);  // media mancante -> BLOCCA: e' il motore, non un filtro
   PrintFormat("[ATREXH][AUTOTEST] volume: 2.0x=%d (atteso 1) | 1.4x=%d (atteso 0) | 1.5x=%d (atteso 0) | media 0=%d (atteso 0, e' COSTITUTIVO)",
               (int)v1,(int)v2,(int)v3,(int)v4);
   if(!(v1 && !v2 && !v3 && !v4)) falliti++;

   //--- I GRILLETTI
   bool t1 = TriggerAutore_Calc(true, 100.0,101.0, 102.0,  98.0);  // close>open -> passa
   bool t2 = TriggerAutore_Calc(true, 100.0, 99.5, 99.0 ,  98.0);  // close<open ma > high prec -> passa
   bool t3 = TriggerAutore_Calc(true, 100.0, 98.0, 102.0,  98.0);  // ne' l'uno ne' l'altro -> blocca
   bool t4 = TriggerAutore_Calc(false,100.0, 99.0, 102.0,  98.0);  // close<open -> passa
   bool t5 = TriggerChiusura_Calc(true, 110.0,100.0,108.0,70.0);   // chiude all'80% -> passa
   bool t6 = TriggerChiusura_Calc(true, 110.0,100.0,102.0,70.0);   // chiude al 20% -> blocca
   bool t7 = TriggerChiusura_Calc(false,110.0,100.0,102.0,70.0);   // short: chiude al 20% -> passa
   bool t8 = TriggerChiusura_Calc(true, 100.0,100.0,100.0,70.0);   // barra piatta -> blocca
   PrintFormat("[ATREXH][AUTOTEST] grilletto autore: c>o=%d (atteso 1) | c>hPrev=%d (atteso 1) | nessuno=%d (atteso 0) | short=%d (atteso 1)",
               (int)t1,(int)t2,(int)t3,(int)t4);
   PrintFormat("[ATREXH][AUTOTEST] grilletto close: 80%%=%d (atteso 1) | 20%%=%d (atteso 0) | short 20%%=%d (atteso 1) | piatta=%d (atteso 0)",
               (int)t5,(int)t6,(int)t7,(int)t8);
   if(!(t1 && t2 && !t3 && t4 && t5 && !t6 && t7 && !t8)) falliti++;

   //--- LE TRE CONDIZIONI INSIEME (long: pivot basso 100, pivot alto 130,
   //    minimo barra 100,2, tolleranza 0,5, ATR 10 x 2 = servono 20 punti
   //    di caduta: 130 - 100,2 = 29,8 -> passa)
   bool s1 = SegnaleLato_Calc(true, 100.0,130.0, 100.2, 0.5, 10.0,2.0, 200.0,100.0,1.5, true);
   bool s2 = SegnaleLato_Calc(true, 100.0,130.0, 100.2, 0.5, 10.0,2.0, 140.0,100.0,1.5, true);  // volume basso
   bool s3 = SegnaleLato_Calc(true, 100.0,115.0, 100.2, 0.5, 10.0,2.0, 200.0,100.0,1.5, true);  // solo 14,8 = niente esaurimento
   bool s4 = SegnaleLato_Calc(true, 100.0,130.0, 102.0, 0.5, 10.0,2.0, 200.0,100.0,1.5, true);  // lontano dal livello
   bool s5 = SegnaleLato_Calc(true, 100.0,130.0, 100.2, 0.5, 10.0,2.0, 200.0,100.0,1.5, false); // grilletto assente
   bool s6 = SegnaleLato_Calc(true,   0.0,130.0, 100.2, 0.5, 10.0,2.0, 200.0,100.0,1.5, true);  // pivot mai visto
   //    short speculare: pivot alto 100, pivot basso 70, massimo barra 99,8
   bool s7 = SegnaleLato_Calc(false,100.0, 70.0,  99.8, 0.5, 10.0,2.0, 200.0,100.0,1.5, true);
   PrintFormat("[ATREXH][AUTOTEST] segnale long: completo=%d (atteso 1) | senza volume=%d (atteso 0) | senza esaurimento=%d (atteso 0)",
               (int)s1,(int)s2,(int)s3);
   PrintFormat("[ATREXH][AUTOTEST] segnale long: lontano=%d (atteso 0) | senza grilletto=%d (atteso 0) | pivot assente=%d (atteso 0) | SHORT speculare=%d (atteso 1)",
               (int)s4,(int)s5,(int)s6,(int)s7);
   if(!(s1 && !s2 && !s3 && !s4 && !s5 && !s6 && s7)) falliti++;

   //--- IL PAVIMENTO DELLO STOP (entry 100, stop strutturale a 99,8 = 0,2)
   double f1 = PavimentoSL_Calc(true, 100.0, 99.8, 1.0);   // pavimento 1,0 -> stop allargato a 99,0
   double f2 = PavimentoSL_Calc(true, 100.0, 97.0, 1.0);   // gia' oltre il pavimento -> invariato
   double f3 = PavimentoSL_Calc(true, 100.0, 99.8, 0.0);   // pavimento spento -> invariato
   double f4 = PavimentoSL_Calc(false,100.0,100.2, 1.0);   // short -> stop allargato a 101,0
   PrintFormat("[ATREXH][AUTOTEST] pavimento SL: %.2f (atteso 99.00) | %.2f (atteso 97.00) | %.2f (atteso 99.80) | short %.2f (atteso 101.00)",
               f1,f2,f3,f4);
   if(MathAbs(f1-99.0)>0.0001 || MathAbs(f2-97.0)>0.0001 ||
      MathAbs(f3-99.8)>0.0001 || MathAbs(f4-101.0)>0.0001) falliti++;

   //--- L'ORARIO (ORA SERVER)
   bool o1 = OraAmmessa_Calc(10, 8,20);    // dentro
   bool o2 = OraAmmessa_Calc(21, 8,20);    // fuori
   bool o3 = OraAmmessa_Calc( 8, 8,20);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[ATREXH][AUTOTEST] orario: 10 in 8-20=%d (atteso 1) | 21=%d (atteso 0) | estremo 8=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(o1 && !o2 && o3 && o4)) falliti++;

   Print("[ATREXH][AUTOTEST] esito motore: ", (falliti==0
         ? "SETTE BLOCCHI SU SETTE, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- blocco standard ABTG
//  Formato per riga (separatore ';'):
//    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
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

//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//| Export per-trade in Common\Files (per dd_portafoglio.py).         |
//| Solo tester: in griglia ogni pass con lo stesso magic SOVRASCRIVE |
//| il file -> usare solo con pin + magic-sweep (2 celle).            |
//+------------------------------------------------------------------+
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
   double stats[10];
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
