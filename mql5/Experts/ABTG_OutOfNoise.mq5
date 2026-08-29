//+------------------------------------------------------------------+
//|                                          ABTG_OutOfNoise.mq5      |
//|                                                                  |
//|  EA "OUT OF THE NOISE INTRADAY con VWAP" - MT5 - TUTTO-IN-UNO    |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  LICENZA / ATTRIBUZIONE (obbligatoria, ripetuta ovunque)         |
//|    Porting del Pine Script                                        |
//|      "Out of the Noise Intraday Strategy with VWAP [YuL]"        |
//|    di Yuri Lopukhov (TradingView, v1.01 2025-07-01).             |
//|    ----------------------------------------------------------    |
//|    MIT License. (c) 2025 Yuri Lopukhov.                          |
//|    Permission is hereby granted, free of charge, to any person   |
//|    obtaining a copy of this software and associated documentation |
//|    files, to deal in the Software without restriction. The above |
//|    copyright notice and this permission notice shall be included |
//|    in all copies. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT      |
//|    WARRANTY OF ANY KIND.                                          |
//|    ----------------------------------------------------------    |
//|    L'autore dichiara di implementare il paper "Beat the Market:   |
//|    An Effective Intraday Momentum Strategy for S&P500 ETF (SPY)"  |
//|    di Zarattini, Aziz, Barbon. Quel paper NON e' stato letto:     |
//|    VERIFICATO solo cio' che sta nel Pine (110 righe).            |
//|    https://www.tradingview.com/script/gJeM3LZ5/                  |
//|    Copia del sorgente in casa:                                   |
//|      backtest_pipeline/caccia_strategie/biblioteca/sorgenti/     |
//|      OutOfTheNoiseIntraday_YuriLopukhov-MIT_tvgJeM3LZ5_2026-08-25.pine
//|    Scheda del candidato (P3, voto 7/10 - IN CODA):              |
//|      backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in       |
//|  forward finche' un round a TICK REALI non lo promuove. Il       |
//|  PASSO 0 (cancello S0) misura il lordo medio per operazione in   |
//|  PUNTI INDICE PRIMA di leggere qualunque PF: l'export per-trade  |
//|  qui sotto scrive entrata E uscita per calcolarlo.               |
//|                                                                  |
//|  LA TESI IN UNA RIGA                                             |
//|    Attorno all'apertura c'e' un CONO DI RUMORE che si allarga    |
//|    con l'ora del giorno: solo un prezzo che esce da QUEL cono -  |
//|    non da un box di 15 minuti - e' squilibrio vero. La VWAP di   |
//|    sessione fa da trailing, il cono da secondo binario.          |
//|                                                                  |
//|  IL MOTORE - fedele al Pine, tre pezzi                           |
//|    1) IL CONO. Per OGNI barra della seduta si calcola la media   |
//|       su InpConeDays (14) giorni di |close/open_del_giorno - 1|  |
//|       ALLA STESSA POSIZIONE ORARIA intraday (indice di barra     |
//|       dall'apertura sessione). La banda e'                       |
//|         upper = max(open_giorno, close_di_ieri) * (1 + avgMove)  |
//|         lower = min(open_giorno, close_di_ieri) * (1 - avgMove)  |
//|       La banda SI ALLARGA man mano che la seduta avanza, e tiene |
//|       conto del gap notturno (usa il close dell'ultima barra     |
//|       PRIMA dell'apertura di seduta).                            |
//|    2) IL GRILLETTO. close > banda_sup -> long ; close <          |
//|       banda_inf -> short. In qualunque barra TRANNE la prima.    |
//|    3) L'USCITA VWAP-TRAILING. long: chiudi quando                |
//|       close < max(vwap, banda_sup) ; short: chiudi quando        |
//|       close > min(vwap, banda_inf). PIU' lo STOP al broker e il  |
//|       FLAT di fine seduta qui sotto.                             |
//|                                                                  |
//|  COSA E' STATO RIFATTO (i difetti del Pine, obbligatori prop)    |
//|    - STOP LOSS VERO AL BROKER, mai una regola a sola chiusura    |
//|      barra: ordine di stop sul server, scelta fra bordo OPPOSTO  |
//|      del cono o ATR x mult. PAVIMENTO SL OBBLIGATORIO (R109:     |
//|      mai stop a zero): lo stop non e' mai piu' stretto del       |
//|      pavimento, mai dentro lo stops-level del broker.            |
//|    - SIZING A RISCHIO, non a leva: LotByRisk = rischio% x equity |
//|      / (distanza SL x valore punto). Tolte la leva 4 e il        |
//|      qty-by-leverage del Pine.                                   |
//|    - CAP GIORNALIERO: InpMaxTradesPerDay (2). Il candidato spara |
//|      0-2/giorno per indice.                                      |
//|    - FLAT OBBLIGATORIO a fine seduta: MAI overnight (regola      |
//|      Emiliano). All'ora di fine seduta chiude tutto e non riapre.|
//|                                                                  |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO      |
//|  rispetto all'ora italiana. Sessioni (in ORA SERVER):           |
//|    DAX  (D30EUR):        08:00 - 16:30 server                    |
//|    Nasdaq (NASUSD) / Dow (U30USD): 14:30 - 21:00 server          |
//|  L'EA funziona sui tre cambiando SOLO gli input di sessione.     |
//|                                                                  |
//|  CONVERSIONE PUNTI: su U30USD/NASUSD 1 punto indice = 100 punti  |
//|  MT5 (_Point) (misura R97). InpMT5PerPuntoIndice espone il       |
//|  fattore: serve all'export (take in punti indice) e al pavimento |
//|  SL espresso in punti indice. Su D30EUR va verificato e messo    |
//|  il fattore giusto.                                              |
//|                                                                  |
//|  QUALE VOLUME PER LA VWAP: TICK VOLUME. Sugli indici CFD di BCM  |
//|  il volume scambiato non esiste nel feed. Scostamento dichiarato,|
//|  stessa convenzione di ABTG_VwapRevert / ABTG_DAX_Apertura_EU.   |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il segnale si valuta sulla barra    |
//|  appena chiusa (shift 1) e l'ordine parte all'apertura della     |
//|  barra 0: e' l'equivalente MT5 di process_orders_on_close = true |
//|  del Pine. Niente look-ahead, niente repaint.                    |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le    |
//|  stringhe, niente emoji (regola di casa). NON compilato ne'      |
//|  testato da chi ha scritto il file: compilare in MetaEditor (F7) |
//|  e validare nel tester A TICK REALI.                            |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - porting da Yuri Lopukhov (MIT, TradingView gJeM3LZ5)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO - firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a un EA non migrato.
//    Il default true NON cambia niente da solo: nel tester le sue
//    GlobalVariable non esistono e la guardia lascia passare tutto
//    (fail-open). I backtest restano confrontabili.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//--- Da dove nasce lo STOP LOSS al broker (sempre un ordine vero sul
//    server, mai una regola a sola chiusura barra).
//    CONO = bordo OPPOSTO del cono (long -> banda inferiore, wide).
//    ATR  = ATR(periodo) x InpSlAtrMult dal prezzo d'ingresso.
enum ENUM_SL_MODE { SL_CONO=0, SL_ATR=1 };

//==================================================================
//  INPUT
//==================================================================
input group "=== MOTORE - CONO DI RUMORE (costitutivo: non si spegne) ==="
input int    InpConeDays        = 14;    // Giorni per la media del movimento (autore: 14)
input int    InpConeMinDays     = 14;    // Sessioni di storia minime prima di fidarsi del cono (autore: 14)

input group "=== SESSIONE (ORA SERVER, mai IT ne' ET) ==="
//--- Default DAX (D30EUR): 08:00-16:30 SERVER. Per Nasdaq/Dow US
//    mettere 14:30-21:00 SERVER. Il flat di fine seduta scatta a
//    InpSessionEndHour:InpSessionEndMin.
input int    InpSessionStartHour = 8;    // Ora SERVER di apertura seduta (DAX 8, US 14)
input int    InpSessionStartMin  = 0;    // Minuto SERVER di apertura (DAX 0, US 30)
input int    InpSessionEndHour   = 16;   // Ora SERVER di chiusura seduta = ora del FLAT (DAX 16, US 21)
input int    InpSessionEndMin    = 30;   // Minuto SERVER di chiusura (DAX 30, US 0)

input group "=== USCITA (VWAP-trailing, fedele all'autore) ==="
input bool   InpCloseOnOpposite  = true; // Chiudi anche sul GRILLETTO opposto (riflette la reversione del Pine)

input group "=== STOP LOSS (rifatto: ordine vero al broker) ==="
input ENUM_SL_MODE InpSlMode      = SL_ATR; // Da dove nasce lo SL: CONO (bordo opposto) o ATR
input int    InpAtrPeriod         = 14;   // Periodo ATR sul TF del grafico
input double InpSlAtrMult         = 1.5;  // SL = ATR x questo (solo modo ATR)
input double InpSlFloorAtrMult    = 0.5;  // PAVIMENTO SL = ATR x questo (obbligatorio, mai zero)
input double InpSlFloorPtsIndice  = 0;    // PAVIMENTO SL aggiuntivo in PUNTI INDICE (0 = solo ATR)

input group "=== Rischio e cap ==="
input double InpRiskPercent       = 0.65; // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay   = 2;    // Max ingressi ESEGUITI al giorno (0 = illimitato)
input bool   InpAllowLong         = true; // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort        = true; // Ammetti gli SHORT

input group "=== Conversione punti indice ==="
//--- 1 punto indice = quanti punti MT5 (_Point). R97: U30USD/NASUSD = 100.
//    Su D30EUR va verificato sul simbolo e messo il valore giusto.
input double InpMT5PerPuntoIndice = 100;  // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment     = "NOISE";   // Commento sugli ordini
input long   InpMagic       = 773500;    // Numero magico (blocco 7735xx: verificato LIBERO nel repo)
input int    InpMaxSpread   = 0;         // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose     = true;      // Messaggi nel log
input bool   InpAutoTest    = true;      // Stampa le righe [NOISE][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

int      hAtr = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester): in
//    ottimizzazione le Print sugli agent non le legge nessuno.
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[NOISE] ", m); }

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
//| Un istante (in minuti del giorno) e' DENTRO la seduta?            |
//| [start, end): la barra che APRE all'ora di fine NON e' in seduta  |
//| (a quell'ora scatta il flat). Le sedute di casa non attraversano  |
//| la mezzanotte (DAX 08-16:30, US 14:30-21), quindi start < end.    |
//+------------------------------------------------------------------+
bool InSeduta_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);   // difensivo: mai usato di casa
  }

//+------------------------------------------------------------------+
//| MEDIA DEL MOVIMENTO - il cuore del cono.                          |
//| Per ogni giorno valido calcola |close_alla_stessa_ora/open_del_   |
//| giorno - 1| e ne fa la media. Salta i giorni con open <= 0        |
//| (dato mancante). Ritorna il numero di giorni USATI; scrive la     |
//| media in 'avg'. n giorni utili = 0 -> avg 0 e ritorna 0 (senza    |
//| dati il cono non esiste: il chiamante NON deve fidarsi).          |
//+------------------------------------------------------------------+
int MediaMovimento_Calc(const double &opens[],const double &closes[],
                        const int n,double &avg)
  {
   avg=0;
   if(n<1) return(0);
   if(ArraySize(opens)<n || ArraySize(closes)<n) return(0);
   double somma=0; int usati=0;
   for(int i=0;i<n;i++)
     {
      if(opens[i]<=0) continue;
      somma += MathAbs(closes[i]/opens[i]-1.0);
      usati++;
     }
   if(usati<1) return(0);
   avg = somma/usati;
   return(usati);
  }

//+------------------------------------------------------------------+
//| Le due bande dal loro 'base' e dalla media del movimento.         |
//|   upper = baseUp * (1 + avgMove)                                  |
//|   lower = baseLo * (1 - avgMove)                                  |
//+------------------------------------------------------------------+
double BandaSuperiore_Calc(const double baseUp,const double avgMove)
  { return(baseUp*(1.0+avgMove)); }
double BandaInferiore_Calc(const double baseLo,const double avgMove)
  { return(baseLo*(1.0-avgMove)); }

//+------------------------------------------------------------------+
//| IL GRILLETTO (autore): close oltre la banda.                      |
//|   long : close > upper ; short: close < lower                     |
//| Confronto STRETTO come il Pine.                                   |
//+------------------------------------------------------------------+
bool Grilletto_Calc(const bool isLong,const double close,
                    const double upper,const double lower)
  {
   if(isLong) return(close>upper);
   return(close<lower);
  }

//+------------------------------------------------------------------+
//| L'USCITA VWAP-TRAILING (autore).                                  |
//|   long : chiudi quando close < max(vwap, upper)                   |
//|   short: chiudi quando close > min(vwap, lower)                   |
//| La VWAP fa da trailing, il cono da secondo binario.               |
//+------------------------------------------------------------------+
bool UscitaTrail_Calc(const bool isLong,const double close,
                      const double vwap,const double upper,const double lower)
  {
   if(isLong) return(close < MathMax(vwap,upper));
   return(close > MathMin(vwap,lower));
  }

//+------------------------------------------------------------------+
//| VWAP di sessione pesata sul volume (autore: ta.vwap(close) usa    |
//| close come sorgente). src[] = close delle barre, vol[] = pesi.    |
//| Ritorna false se non c'e' peso: senza dati la VWAP non esiste.    |
//+------------------------------------------------------------------+
bool Vwap_Calc(const double &src[],const double &vol[],const int n,double &vwap)
  {
   vwap=0;
   if(n<1) return(false);
   if(ArraySize(src)<n || ArraySize(vol)<n) return(false);
   double pv=0,vv=0;
   for(int i=0;i<n;i++)
     {
      double w=vol[i]; if(w<=0) w=1.0;   // barra senza tick: peso minimo, mai zero
      pv += src[i]*w; vv += w;
     }
   if(vv<=0) return(false);
   vwap = pv/vv;
   return(true);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (convenzione di casa, R55/R109).             |
//| Se lo stop e' piu' vicino del pavimento, lo stop si ALLARGA al    |
//| pavimento; non si salta il trade e non si lascia lo stop a zero.  |
//| pavimento <= 0 -> invariato (ma il chiamante garantisce > 0).     |
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
//| Marcatore di SESSIONE di un istante ancorato a startHour:startMin.|
//| Due barre stanno nella stessa sessione se hanno lo stesso         |
//| marcatore. Le sedute di casa non attraversano la mezzanotte,      |
//| quindi il marcatore coincide con la data solare del server.       |
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t,const int startMinuti)
  {
   long s = (long)t - (long)startMinuti*60;
   if(s<0) s=0;
   return(s/86400);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - nucleo puro. Vero quando l'ora corrente ha  |
//| raggiunto o superato l'ora di fine seduta. Confronto in MINUTI    |
//| del giorno, non ora per ora.                                      |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE, dato il fattore  |
//| (punti MT5 per punto indice) e la dimensione del punto MT5.       |
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
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpConeDays<2)
     { Print("ERRORE: InpConeDays deve essere >= 2: senza storia non c'e' cono."); return(INIT_FAILED); }
   if(InpConeMinDays<1 || InpConeMinDays>InpConeDays)
     { Print("ERRORE: InpConeMinDays deve stare fra 1 e InpConeDays."); return(INIT_FAILED); }
   if(InpSessionStartHour<0 || InpSessionStartHour>23 || InpSessionStartMin<0 || InpSessionStartMin>59)
     { Print("ERRORE: ora/minuto di apertura seduta fuori range (0-23 / 0-59, ORA SERVER)."); return(INIT_FAILED); }
   if(InpSessionEndHour<0 || InpSessionEndHour>23 || InpSessionEndMin<0 || InpSessionEndMin>59)
     { Print("ERRORE: ora/minuto di chiusura seduta fuori range (0-23 / 0-59, ORA SERVER)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpSessionStartHour,InpSessionStartMin) >= MinutiDelGiorno_Calc(InpSessionEndHour,InpSessionEndMin))
     { Print("ERRORE: la seduta di casa NON attraversa la mezzanotte: apertura deve precedere la chiusura."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpSlMode==SL_ATR && InpSlAtrMult<=0)
     { Print("ERRORE: InpSlAtrMult deve essere > 0 nel modo ATR."); return(INIT_FAILED); }
   if(InpSlFloorAtrMult<0)
     { Print("ERRORE: InpSlFloorAtrMult non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSlFloorPtsIndice<0)
     { Print("ERRORE: InpSlFloorPtsIndice non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSlFloorAtrMult<=0 && InpSlFloorPtsIndice<=0)
     { Print("ERRORE: pavimento SL a zero (R109): almeno uno fra InpSlFloorAtrMult e InpSlFloorPtsIndice deve essere > 0."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestNoise();

   Log(StringFormat("avviato su %s %s. Cono %d giorni (min %d), seduta %02d:%02d-%02d:%02d SERVER, SL=%s, pavimento %.2f ATR + %.0f pti idx, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpConeDays, InpConeMinDays,
       InpSessionStartHour, InpSessionStartMin, InpSessionEndHour, InpSessionEndMin,
       (InpSlMode==SL_CONO?"CONO(bordo opposto)":"ATR"),
       InpSlFloorAtrMult, InpSlFloorPtsIndice,
       InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione: motore INTRADAY, niente overnight ne' weekend. Scostamento dichiarato dal Pine (l'autore non chiude a fine giornata).");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat:
   //    se il flat porta via la posizione, la caduta va gia' contata.
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

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valuta la barra APPENA CHIUSA      |
//| (shift 1): se il suo close esce dal cono, l'ordine parte al       |
//| mercato all'apertura della barra 0 (= process_orders_on_close).   |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   double upper=0, lower=0, avgMove=0, vwap=0;
   int    nDays=0, nMoves=0, pos=-1;
   bool   coneOk = CalcCono(1, upper, lower, avgMove, nDays, nMoves, pos);
   bool   vwapOk = CalcVwapSessione(1, vwap);

   double closeEval = iClose(_Symbol, gTF, 1);
   if(closeEval<=0) return;

   //--- fronte dei grilletti sulla barra appena chiusa
   bool bull = coneOk && Grilletto_Calc(true , closeEval, upper, lower);
   bool bear = coneOk && Grilletto_Calc(false, closeEval, upper, lower);

   //--- USCITE per la posizione aperta (fedele all'autore, a barra chiusa).
   //    Chiudere rischio viene PRIMA di tutti i cancelli operativi.
   if(CountPositions()>0)
     {
      GestisciUscita(coneOk, vwapOk, closeEval, upper, lower, vwap, bull, bear);
      return;                                 // una posizione alla volta per magic
     }

   //--- INGRESSI
   if(!coneOk) return;                        // cono non affidabile: niente segnale
   if(nDays < InpConeMinDays) return;         // storia insufficiente (warmup)
   if(pos <= 0) return;                        // prima barra della seduta: mai ingresso (autore)
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!InSedutaOra(TimeCurrent())) return;    // si entra solo DENTRO la seduta
   if(!SpreadOK()) return;

   if(InpAllowLong && bull)
     { ApriPosizione(true, upper, lower); return; }   // una sola decisione per barra
   if(InpAllowShort && bear)
      ApriPosizione(false, upper, lower);
  }

//+------------------------------------------------------------------+
//| Gestione dell'uscita a barra chiusa: VWAP-trailing (autore) e     |
//| grilletto opposto (riflette la reversione del Pine). Lo STOP vero |
//| resta sul server e puo' scattare intrabar, indipendente da qui.   |
//+------------------------------------------------------------------+
void GestisciUscita(const bool coneOk,const bool vwapOk,const double closeEval,
                    const double upper,const double lower,const double vwap,
                    const bool bull,const bool bear)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);

      //--- grilletto opposto (opzionale): la posizione contro il nuovo
      //    squilibrio non ha piu' ragione. Il lato spento in ingresso
      //    NON impedisce l'uscita: qui filtriamo l'INGRESSO, non l'uscita.
      if(InpCloseOnOpposite)
        {
         if((isLong && bear) || (!isLong && bull))
           {
            if(gTrade.PositionClose(tk)) Log("grilletto opposto: posizione chiusa.");
            continue;
           }
        }

      //--- USCITA VWAP-TRAILING (autore). Serve la VWAP: senza, si resta
      //    protetti solo dallo stop al broker.
      if(coneOk && vwapOk && UscitaTrail_Calc(isLong, closeEval, vwap, upper, lower))
        {
         if(gTrade.PositionClose(tk)) Log("uscita VWAP-trailing: posizione chiusa.");
        }
     }
  }

//==================================================================
//  LETTURA DEI DATI (il pensiero sta nel nucleo puro)
//==================================================================

int MinutiStartSeduta(){ return(MinutiDelGiorno_Calc(InpSessionStartHour,InpSessionStartMin)); }
int MinutiEndSeduta()  { return(MinutiDelGiorno_Calc(InpSessionEndHour,InpSessionEndMin)); }

//--- una barra (per il suo time) e' DENTRO la seduta?
bool BarraInSeduta(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return(InSeduta_Calc(MinutiDelGiorno_Calc(d.hour,d.min), MinutiStartSeduta(), MinutiEndSeduta()));
  }

//--- l'istante corrente (ora server) e' dentro la seduta?
bool InSedutaOra(const datetime t){ return(BarraInSeduta(t)); }

//--- stima delle barre per seduta, per dimensionare la copia.
int BarrePerSeduta()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=300;
   int minuti = MinutiEndSeduta()-MinutiStartSeduta(); if(minuti<=0) minuti=480;
   int b = (int)((minuti*60)/per) + 2;
   return(b<4?4:b);
  }

//+------------------------------------------------------------------+
//| IL CONO per la barra a shiftEval.                                 |
//| Ricostruisce, SENZA STATO PERSISTENTE (sopravvive a un riavvio):  |
//|   - la posizione della barra dentro la sua seduta (pos, 0-based); |
//|   - il 'base' della seduta corrente:                              |
//|       baseUp = max(open_seduta, close_pre-seduta)                 |
//|       baseLo = min(open_seduta, close_pre-seduta)                 |
//|     dove close_pre-seduta e' l'ULTIMO close prima dell'apertura   |
//|     (cattura il gap notturno, = close[1] sulla prima barra Pine); |
//|   - per le InpConeDays sedute precedenti, il close alla STESSA    |
//|     posizione oraria e l'open di quella seduta -> media |c/o-1|.  |
//| Scostamento DICHIARATO dal Pine (migliorativo): uso il close alla |
//| stessa posizione SOLO se cade nella stessa seduta; il Pine legge  |
//| un offset assoluto e, se una seduta e' piu' corta, sconfina nella |
//| successiva. Qui una seduta corta viene semplicemente saltata.     |
//| Ritorna false se non c'e' abbastanza storia o il cono e' vuoto.   |
//+------------------------------------------------------------------+
bool CalcCono(const int shiftEval,double &upper,double &lower,double &avgMove,
              int &nDays,int &nMoves,int &pos)
  {
   upper=0; lower=0; avgMove=0; nDays=0; nMoves=0; pos=-1;
   if(shiftEval<1) return(false);

   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = (InpConeDays+3)*BarrePerSeduta() + shiftEval + 5;
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<=shiftEval+2) return(false);

   //--- la barra da valutare dev'essere DENTRO la seduta
   if(!BarraInSeduta(r[shiftEval].time)) return(false);
   int startMin = MinutiStartSeduta();
   long stampEval = SessionStamp_Calc(r[shiftEval].time, startMin);

   //--- prima barra della seduta corrente: il piu' VECCHIO shift che
   //    ha lo stesso stamp ed e' in seduta, contiguo verso shiftEval.
   int firstShift = shiftEval;
   for(int i=shiftEval+1;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=stampEval) break;
      firstShift = i;
     }
   pos = firstShift - shiftEval;              // 0 = prima barra della seduta

   double openOggi = r[firstShift].open;
   double closePre = (firstShift+1<copied) ? r[firstShift+1].close : openOggi;
   if(openOggi<=0) return(false);
   double baseUp = MathMax(openOggi, closePre);
   double baseLo = MathMin(openOggi, closePre);

   //--- raccolgo le InpConeDays sedute precedenti
   double opens[]; double closesPos[];
   ArrayResize(opens, InpConeDays);
   ArrayResize(closesPos, InpConeDays);
   int found=0;
   int idx = firstShift+1;                    // parto dalla barra pre-seduta
   while(found<InpConeDays && idx<copied)
     {
      //--- salta le barre fuori seduta fino all'ultima barra della
      //    seduta precedente
      while(idx<copied && !BarraInSeduta(r[idx].time)) idx++;
      if(idx>=copied) break;
      long stampPrev = SessionStamp_Calc(r[idx].time,startMin);
      int prevLast = idx;                      // ultima barra (piu' recente) di quella seduta
      int prevFirst = idx;
      for(int j=idx+1;j<copied;j++)
        {
         if(!BarraInSeduta(r[j].time)) break;
         if(SessionStamp_Calc(r[j].time,startMin)!=stampPrev) break;
         prevFirst = j;
        }
      //--- la barra alla stessa posizione oraria in quella seduta
      int shiftPos = prevFirst - pos;
      if(shiftPos>=prevLast && shiftPos<=prevFirst && shiftPos>=0 && shiftPos<copied)
        {
         if(BarraInSeduta(r[shiftPos].time) &&
            SessionStamp_Calc(r[shiftPos].time,startMin)==stampPrev)
           {
            opens[found]     = r[prevFirst].open;
            closesPos[found] = r[shiftPos].close;
            found++;
           }
        }
      idx = prevFirst+1;                        // vai alla seduta ancora prima
     }
   nDays = found;
   if(found<1) return(false);

   nMoves = MediaMovimento_Calc(opens, closesPos, found, avgMove);
   if(nMoves<1) return(false);

   upper = BandaSuperiore_Calc(baseUp, avgMove);
   lower = BandaInferiore_Calc(baseLo, avgMove);
   return(true);
  }

//+------------------------------------------------------------------+
//| VWAP della seduta che contiene la barra a shiftEval, accumulata   |
//| dall'inizio della seduta fino a shiftEval compresa. Sorgente =    |
//| close (come ta.vwap(close) dell'autore), pesi = tick volume.      |
//+------------------------------------------------------------------+
bool CalcVwapSessione(const int shiftEval,double &vwap)
  {
   vwap=0;
   if(shiftEval<1) return(false);

   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 2*BarrePerSeduta() + shiftEval + 5;
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<=shiftEval) return(false);
   if(!BarraInSeduta(r[shiftEval].time)) return(false);

   int  startMin = MinutiStartSeduta();
   long stamp    = SessionStamp_Calc(r[shiftEval].time,startMin);

   double src[], vol[];
   int cap = BarrePerSeduta()+2;
   ArrayResize(src,cap); ArrayResize(vol,cap);
   int n=0;
   for(int i=shiftEval;i<copied && n<cap;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=stamp) break;
      src[n] = r[i].close;
      vol[n] = (double)r[i].tick_volume;      // TICK VOLUME: scostamento dichiarato
      n++;
     }
   if(n<1) return(false);
   return(Vwap_Calc(src,vol,n,vwap));
  }

double AtrVal(const int shift)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,shift,1,a)!=1) return(0);
   return(a[0]);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS vero al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato, con lo stop mandato al server.      |
//| Lo SL nasce da InpSlMode (CONO = bordo opposto ; ATR = ATR*mult), |
//| poi PASSA SEMPRE dal pavimento (mai a zero, mai dentro lo         |
//| stops-level). Il lotto esce da LotByRisk sulla distanza FINALE.   |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong,const double upper,const double lower)
  {
   double atr = AtrVal(1);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);

   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   //--- SL grezzo secondo il modo scelto
   double slRaw;
   if(InpSlMode==SL_CONO)
      slRaw = isLong ? lower : upper;         // bordo OPPOSTO del cono
   else
     {
      if(atr<=0){ Log("ATR non disponibile: salto (modo ATR)."); return(false); }
      slRaw = isLong ? (ref - atr*InpSlAtrMult) : (ref + atr*InpSlAtrMult);
     }

   //--- PAVIMENTO OBBLIGATORIO (R109): la distanza dello stop non e' mai
   //    piu' stretta del massimo fra il pavimento ATR e quello in punti
   //    indice, e mai dentro lo stops-level del broker.
   double pavAtr = (atr>0 ? atr*InpSlFloorAtrMult : 0);
   double pavIdx = InpSlFloorPtsIndice*InpMT5PerPuntoIndice*_Point;
   double pavimento = MathMax(pavAtr, pavIdx);
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo (ATR e punti indice a zero): salto per non lasciare lo stop scoperto."); return(false); }

   double sl = PavimentoSL_Calc(isLong, ref, slRaw, pavFinale);
   sl = NormalizePrice(sl);

   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta immediatamente prima dell'invio: l'unica cosa che cambia e'
   //    che l'ordine non parte, come un rifiuto del broker.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_OutOfNoise")) return(false);

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,0.0,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,0.0,cm);
   if(ok)
     {
      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s lot %.2f (rischio %s prezzo = %.1f pti idx | ATR %s)",
          isLong?"BUY":"SELL",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits), lot,
          DoubleToString(distSL,_Digits), idxRisk, DoubleToString(atr,_Digits)));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - il motore e' intraday per COSTRUZIONE.      |
//| Raggiunta l'ora di fine seduta (ORA SERVER): chiude ogni          |
//| posizione di questo magic e torna true; il true ferma OnTick,     |
//| quindi non si riapre fino al giorno dopo. Niente overnight,       |
//| niente weekend.                                                   |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpSessionEndHour,InpSessionEndMin)) return(false);

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
         Log(StringFormat("flat di fine seduta alle %02d:%02d server: %d posizioni chiuse, niente overnight.",
                          InpSessionEndHour, InpSessionEndMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il cap giornaliero conta gli ingressi ESEGUITI, non gli ordini.   |
//| Un parziale non cambia il ticket, quindi non conta due volte.     |
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

//--- Lotto dalla distanza dello stop. PERDITA PER LOTTO DAL BROKER,
//    non dal tick value nudo (08/08/2026): OrderCalcProfit converte in
//    valuta conto; il tick value resta come ripiego. Su un indice la
//    distanza e' in PREZZO, nessuna ipotesi forex nascosta.
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
void AutoTestNoise()
  {
   int falliti=0;

   PrintFormat("[NOISE][AUTOTEST] cono %d giorni (min %d) | seduta %02d:%02d-%02d:%02d SERVER | SL=%s | %s | magic %I64d",
               InpConeDays, InpConeMinDays,
               InpSessionStartHour,InpSessionStartMin,InpSessionEndHour,InpSessionEndMin,
               (InpSlMode==SL_CONO?"CONO":"ATR"), _Symbol, InpMagic);

   //--- 1. LA MEDIA DEL MOVIMENTO (il cuore del cono)
   double op2[2]; op2[0]=100.0; op2[1]=100.0;
   double cl2[2]; cl2[0]=102.0; cl2[1]= 98.0;      // moves 0.02, 0.02 -> avg 0.02
   double a1=0; int u1=MediaMovimento_Calc(op2,cl2,2,a1);
   double op3[3]; op3[0]=100.0; op3[1]=200.0; op3[2]=50.0;
   double cl3[3]; cl3[0]=101.0; cl3[1]=206.0; cl3[2]=50.5; // 0.01,0.03,0.01 -> avg 0.016666
   double a2=0; int u2=MediaMovimento_Calc(op3,cl3,3,a2);
   double op4[2]; op4[0]=0.0;   op4[1]=100.0;      // primo open invalido -> saltato
   double cl4[2]; cl4[0]=50.0;  cl4[1]=105.0;      // usa solo 0.05 -> avg 0.05, usati 1
   double a3=0; int u3=MediaMovimento_Calc(op4,cl4,2,a3);
   double a4=0; int u4=MediaMovimento_Calc(op2,cl2,0,a4);   // n=0 -> 0
   PrintFormat("[NOISE][AUTOTEST] media mov: avg %.5f/%d (attesi 0.02000/2) | avg %.5f/%d (attesi 0.01667/3) | open invalido %.5f/%d (attesi 0.05000/1) | n0 usati=%d (atteso 0)",
               a1,u1,a2,u2,a3,u3,u4);
   if(!(u1==2 && MathAbs(a1-0.02)<1e-6 &&
        u2==3 && MathAbs(a2-0.0166667)<1e-5 &&
        u3==1 && MathAbs(a3-0.05)<1e-6 &&
        u4==0)) falliti++;

   //--- 2. LE BANDE (base 100, avg 0.02 -> 102 / 98 ; base 200 -> 204/196)
   double up1=BandaSuperiore_Calc(100.0,0.02);
   double lo1=BandaInferiore_Calc(100.0,0.02);
   double up2=BandaSuperiore_Calc(200.0,0.02);
   double lo2=BandaInferiore_Calc(200.0,0.02);
   PrintFormat("[NOISE][AUTOTEST] bande: up %.2f/lo %.2f (attesi 102.00/98.00) | up %.2f/lo %.2f (attesi 204.00/196.00)",
               up1,lo1,up2,lo2);
   if(!(MathAbs(up1-102.0)<1e-6 && MathAbs(lo1-98.0)<1e-6 &&
        MathAbs(up2-204.0)<1e-6 && MathAbs(lo2-196.0)<1e-6)) falliti++;

   //--- 3. IL GRILLETTO (upper 102, lower 98)
   bool g1=Grilletto_Calc(true ,103.0,102.0,98.0);   // long
   bool g2=Grilletto_Calc(true ,102.0,102.0,98.0);   // sul bordo -> no (stretto)
   bool g3=Grilletto_Calc(true ,100.0,102.0,98.0);   // dentro -> no
   bool g4=Grilletto_Calc(false, 97.0,102.0,98.0);   // short
   bool g5=Grilletto_Calc(false, 98.0,102.0,98.0);   // sul bordo -> no
   PrintFormat("[NOISE][AUTOTEST] grilletto: long=%d (1) | bordo long=%d (0) | dentro=%d (0) | short=%d (1) | bordo short=%d (0)",
               (int)g1,(int)g2,(int)g3,(int)g4,(int)g5);
   if(!(g1 && !g2 && !g3 && g4 && !g5)) falliti++;

   //--- 4. L'USCITA VWAP-TRAILING
   //    long: close < max(vwap,upper). vwap 101, upper 102 -> soglia 102
   bool x1=UscitaTrail_Calc(true ,101.5,101.0,102.0,98.0);  // 101.5<102 -> esci
   bool x2=UscitaTrail_Calc(true ,102.5,101.0,102.0,98.0);  // 102.5>102 -> resta
   //    short: close > min(vwap,lower). vwap 99, lower 98 -> soglia 98
   bool x3=UscitaTrail_Calc(false, 99.0, 99.0,102.0,98.0);  // 99>98 -> esci
   bool x4=UscitaTrail_Calc(false, 97.5, 99.0,102.0,98.0);  // 97.5<98 -> resta
   //    vwap piu' lontano del cono: la max/min sceglie il piu' vicino
   bool x5=UscitaTrail_Calc(true ,103.5,105.0,102.0,98.0);  // soglia max(105,102)=105 -> 103.5<105 esci
   PrintFormat("[NOISE][AUTOTEST] uscita: long esci=%d (1) | long resta=%d (0) | short esci=%d (1) | short resta=%d (0) | vwap lontano=%d (1)",
               (int)x1,(int)x2,(int)x3,(int)x4,(int)x5);
   if(!(x1 && !x2 && x3 && !x4 && x5)) falliti++;

   //--- 5. LA VWAP (pesata sul volume, sorgente close)
   double s2[2]; s2[0]=10.0; s2[1]=20.0;
   double w2[2]; w2[0]= 1.0; w2[1]= 1.0;
   double vw1=0; bool r1=Vwap_Calc(s2,w2,2,vw1);       // 15
   double w3[2]; w3[0]= 1.0; w3[1]= 3.0;
   double vw2=0; bool r2=Vwap_Calc(s2,w3,2,vw2);       // 17.5
   double vw3=0; bool r3=Vwap_Calc(s2,w2,0,vw3);       // n=0 -> false
   PrintFormat("[NOISE][AUTOTEST] vwap: %.4f (atteso 15.0000) | pesata %.4f (atteso 17.5000) | n0 ok=%d (atteso 0)",
               vw1,vw2,(int)r3);
   if(!(r1 && r2 && !r3 && MathAbs(vw1-15.0)<1e-6 && MathAbs(vw2-17.5)<1e-6)) falliti++;

   //--- 6. IL PAVIMENTO DELLO STOP (mai a zero: R109)
   //    entry 100, slGrezzo 99.8 (dist 0.2), pavimento 2.0 -> stop a 98.00
   double p1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);
   double p2=PavimentoSL_Calc(true ,100.0, 97.0,2.0);  // gia' oltre -> invariato 97.00
   double p3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short -> 102.00
   double p4=PavimentoSL_Calc(true ,100.0, 99.8,0.0);  // pavimento 0 -> invariato 99.80
   PrintFormat("[NOISE][AUTOTEST] pavimento: %.2f (atteso 98.00) | %.2f (atteso 97.00) | short %.2f (atteso 102.00) | spento %.2f (atteso 99.80)",
               p1,p2,p3,p4);
   if(!(MathAbs(p1-98.0)<1e-6 && MathAbs(p2-97.0)<1e-6 &&
        MathAbs(p3-102.0)<1e-6 && MathAbs(p4-99.8)<1e-6)) falliti++;

   //--- 7. LA SEDUTA E IL FLAT (DAX 08:00-16:30 server come esempio)
   int mS=MinutiDelGiorno_Calc(8,0), mE=MinutiDelGiorno_Calc(16,30);
   bool se1=InSeduta_Calc(MinutiDelGiorno_Calc( 8, 0),mS,mE);  // apertura inclusa
   bool se2=InSeduta_Calc(MinutiDelGiorno_Calc(12, 0),mS,mE);  // meta' giornata
   bool se3=InSeduta_Calc(MinutiDelGiorno_Calc(16,30),mS,mE);  // chiusura ESCLUSA
   bool se4=InSeduta_Calc(MinutiDelGiorno_Calc( 7,59),mS,mE);  // prima dell'apertura
   bool se5=InSeduta_Calc(MinutiDelGiorno_Calc(22, 0),mS,mE);  // notte
   PrintFormat("[NOISE][AUTOTEST] seduta 08:00-16:30: apertura=%d (1) | 12:00=%d (1) | 16:30=%d (0) | 07:59=%d (0) | 22:00=%d (0)",
               (int)se1,(int)se2,(int)se3,(int)se4,(int)se5);
   if(!(se1 && se2 && !se3 && !se4 && !se5)) falliti++;

   bool fl1=DopoOrarioFlat_Calc(16,30,16,30);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(16,31,16,30);   // dopo   -> flat
   bool fl3=DopoOrarioFlat_Calc(16, 0,16,30);   // stessa ora, prima -> NO
   bool fl4=DopoOrarioFlat_Calc(23,59,16,30);   // sera -> flat
   bool fl5=DopoOrarioFlat_Calc( 9, 0,16,30);   // mattina -> no
   PrintFormat("[NOISE][AUTOTEST] flat 16:30: esatto=%d (1) | 16:31=%d (1) | 16:00=%d (0) | 23:59=%d (1) | 09:00=%d (0)",
               (int)fl1,(int)fl2,(int)fl3,(int)fl4,(int)fl5);
   if(!(fl1 && fl2 && !fl3 && fl4 && !fl5)) falliti++;

   //--- 8. LA SESSIONE (stamp) e la CONVERSIONE in punti indice
   datetime tA=D'2026.08.25 09:00:00';
   datetime tB=D'2026.08.25 15:00:00';
   datetime tC=D'2026.08.26 09:00:00';
   bool sm1=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tB,mS));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tC,mS));  // sedute diverse
   //    1 punto indice = 100 punti MT5, _Point 0.01 -> 100*0.01 = 1.0 di prezzo.
   //    Una distanza di prezzo 5.0 -> 5 punti indice.
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   double ip2=PrezzoInPuntiIndice_Calc(1.0,100.0,0.01);   // 1.0
   double ip3=PrezzoInPuntiIndice_Calc(5.0,  1.0,1.0 );   // fattore 1: 5.0
   PrintFormat("[NOISE][AUTOTEST] stamp: stessa=%d (1) | diverse=%d (0) | conv 5.0=%.2f (5.00) | 1.0=%.2f (1.00) | fatt1 5.0=%.2f (5.00)",
               (int)sm1,(int)sm2,ip1,ip2,ip3);
   if(!(sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6 && MathAbs(ip2-1.0)<1e-6 && MathAbs(ip3-5.0)<1e-6)) falliti++;

   Print("[NOISE][AUTOTEST] esito motore: ", (falliti==0
         ? "OTTO BLOCCHI SU OTTO, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. In live/backtest singolo     //
//  e inerte (gira solo in ottimizzazione).                         //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE per il PASSO 0 (cancello S0) in Common\Files.    |
//| Ogni riga = una posizione CHIUSA, con PREZZO D'INGRESSO E DI      |
//| USCITA, cosi' il PASSO 0 puo' calcolare la mediana del take in    |
//| PUNTI INDICE PRIMA di leggere qualunque PF (il cancello che ha    |
//| bocciato R98 in una riga).                                        |
//|   take_idx_pts = movimento catturato in punti indice, con segno:  |
//|     long  -> (exit-entry)/(mt5PerIdx*point)                       |
//|     short -> (entry-exit)/(mt5PerIdx*point)                       |
//|   positivo = operazione andata a favore.                          |
//| Accoppio IN e OUT per DEAL_POSITION_ID: prima passo -> mappa      |
//| dei prezzi d'ingresso; secondo passo -> scrivo sugli OUT.         |
//| NOTA: in griglia ogni pass con lo stesso magic SOVRASCRIVE il     |
//| file -> usare con pin + magic-sweep (poche celle).                |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   int nd=HistoryDealsTotal();

   //--- primo passo: prezzo, tipo e commento dell'ingresso, per position_id
   long   idIn[];   double pxIn[];   long dirIn[];   string cmIn[];
   int    cIn=0;
   ArrayResize(idIn,nd); ArrayResize(pxIn,nd); ArrayResize(dirIn,nd); ArrayResize(cmIn,nd);
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
      cIn++;
     }

   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","dir","volume",
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

      //--- ritrovo l'ingresso della stessa posizione
      double pxEntry=0; long dir=-1; string cm=""; bool trovato=false;
      for(int k=0;k<cIn;k++)
         if(idIn[k]==posId){ pxEntry=pxIn[k]; dir=dirIn[k]; cm=cmIn[k]; trovato=true; break; }

      bool isLong = (dir==DEAL_TYPE_BUY);
      double takeIdx = 0;
      if(trovato && den>0)
        {
         double mossaPrezzo = isLong ? (pxOut-pxEntry) : (pxEntry-pxOut);
         takeIdx = mossaPrezzo/den;
        }

      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
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
   double stats[13];
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
