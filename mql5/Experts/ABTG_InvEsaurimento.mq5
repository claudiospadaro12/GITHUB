//+------------------------------------------------------------------+
//|                                      ABTG_InvEsaurimento.mq5      |
//|                                                                  |
//|  MOTORE D'INVERSIONE DA ESAURIMENTO - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  CONTRATTO FIRMATO (30/08/2026, "FIRMO"):                        |
//|    backtest_pipeline\risultati_archivio\                         |
//|      STUDIO_INVERSIONE_ESAURIMENTO_CRITERI_BOZZA.md              |
//|  VALORI BLOCCATI in testa alla firma: E1 = giornata che ha speso |
//|  >= 1.0x l'ADR a 14 giorni; E2 = livello = max/min del giorno    |
//|  prima + estremo di seduta; E3 = 2-3 barre a range calante al    |
//|  livello (spento nel baseline, acceso in ablazione).             |
//|                                                                  |
//|  COS'E' (dalla firma) - un motore A SE', NON una riparazione.    |
//|    Entra CONTRO una mossa direzionale che ha esaurito la benzina,|
//|    a un livello, a rischio normale, con stop vero. Ingresso       |
//|    SINGOLO. NIENTE mediazione/martingala/griglia/raddoppio/       |
//|    aggiunta su posizione aperta (e' il punto di tutta la          |
//|    discussione: il DD non si abbassa aggiungendo rischio dove si  |
//|    perde). L'inversione punta al RIENTRO, non al trend nuovo.     |
//|                                                                  |
//|  LA MECCANICA (valori bloccati dalla firma)                      |
//|    E2 (il livello) = SEMPRE ATTIVO, e' il baseline. L'inversione  |
//|       si arma SOLO a un livello: massimo/minimo del GIORNO PRIMA  |
//|       (D1 shift 1) oppure estremo di SEDUTA (nuovo max/min della  |
//|       seduta corrente). Entra quando il prezzo RAGGIUNGE tale     |
//|       livello DOPO una mossa direzionale (close di barra dal lato |
//|       del movimento rispetto all'apertura di seduta).             |
//|    E1 (esaurimento) = interruttore CORE. La giornata ha gia'      |
//|       speso >= InpE1_AdrMult x l'ADR (Average Daily Range su      |
//|       InpE1_AdrDays giorni = media di (high-low) dei giorni       |
//|       precedenti). Range del giorno FINORA = D1 shift 0.          |
//|       Salita esausta a resistenza -> arma SHORT; discesa esausta  |
//|       a supporto -> arma LONG.                                    |
//|    E3 (perdita di spinta) = interruttore opt-in. Le ultime        |
//|       InpE3_Bars barre al livello hanno range STRETTAMENTE        |
//|       DECRESCENTE (il momentum cala). Spento nel baseline.        |
//|                                                                  |
//|  PROP-HARDENING (obbligatorio, contratto)                        |
//|    - STOP LOSS VERO AL BROKER, mai una regola a sola chiusura     |
//|      barra: ordine di stop sul server, oltre l'estremo che si     |
//|      fada. PAVIMENTO SL OBBLIGATORIO (R109): InpMinStopPts, MAI   |
//|      zero -> OnInit RIFIUTA se il pavimento e' 0. Un'inversione   |
//|      entra CONTRO una mossa forte: il "coltello che cade" e' il   |
//|      pericolo n.1, il pavimento e' load-bearing.                  |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa.         |
//|    - NIENTE martingala/griglia/recovery/DCA/hedging-di-motore/    |
//|      virtual-stop: ingresso SINGOLO, una posizione per magic,     |
//|      nessuna aggiunta su posizione aperta.                        |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                        |
//|    - FLAT OBBLIGATORIO a fine seduta (ora server): mai overnight. |
//|    - EXPORT PER-TRADE CSV (close_time, net_profit, lato, ...) +   |
//|      OnTester con le metriche prop. AUTOTEST del nucleo in avvio. |
//|                                                                  |
//|  USCITA: TP verso la media/VWAP di seduta (il RIENTRO) + flat a   |
//|  fine seduta. Se la VWAP e' dal lato sbagliato, TP di ripiego a   |
//|  InpTP_R. NON si insegue la coda del trend nuovo.                 |
//|                                                                  |
//|  ORARI: SEMPRE ORA DEL FEED. Su NASUSD_EXT l'anatomia ha misurato |
//|  che le 09:30 del file sono l'apertura cash NY tutto l'anno       |
//|  (feed a ora di New York) -> InpSessionHour=9, InpSessionMin=30.  |
//|  Il 14:30 SERVER vale SOLO sul feed TICK BCM (NASUSD), non su     |
//|  questo screening _EXT.                                           |
//|                                                                  |
//|  CONVERSIONE PUNTI: su NASUSD/U30USD 1 punto indice = 100 punti   |
//|  MT5 (_Point) (R97). Le distanze operative (buffer SL, tolleranza |
//|  livello, pavimento) sono in PUNTI MT5; InpMT5PerPuntoIndice      |
//|  serve solo all'export in punti indice e al log.                  |
//|                                                                  |
//|  QUALE VOLUME PER LA VWAP: TICK VOLUME (il volume scambiato non   |
//|  esiste nel feed CFD). Scostamento dichiarato, come OutOfNoise.   |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il segnale si valuta sulla barra     |
//|  appena chiusa (shift 1) e l'ordine parte all'apertura della      |
//|  barra 0. Niente look-ahead, niente repaint.                     |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola    |
//|  di casa). NON compilato ne' testato da chi ha scritto il file:   |
//|  compilare in MetaEditor (F7) e validare nel tester.             |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - motore d'inversione da esaurimento (contratto 30/08/2026)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO - firme B1 (pausa morbida) e C1 (cap rischio
//    aperto) del 18/08/2026. Il default true NON cambia niente da solo:
//    nel tester le sue GlobalVariable non esistono e la guardia lascia
//    passare tutto (fail-open). I backtest restano confrontabili.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== E2 - IL LIVELLO (baseline: SEMPRE attivo) ==="
input bool   InpUsePrevDayLevels = true;  // E2a: fada al max/min del GIORNO PRIMA (D1 shift 1)
input bool   InpUseSessionExtreme= true;  // E2b: fada all'ESTREMO DI SEDUTA (nuovo max/min di seduta)
input int    InpLevelTolPts      = 200;   // Tolleranza al livello prev-day, in PUNTI MT5 (2 pti indice)

input group "=== E1 - ESAURIMENTO (interruttore CORE; SPENTO nel baseline) ==="
input bool   InpUseE1            = false; // E1: arma SOLO se il giorno ha speso >= mult x ADR
input int    InpE1_AdrDays       = 14;    // Giorni per l'ADR (media di high-low)
input double InpE1_AdrMult       = 1.0;   // Soglia: range del giorno FINORA >= mult x ADR (firma: 1.0)

input group "=== E3 - PERDITA DI SPINTA (opt-in; SPENTO nel baseline) ==="
input bool   InpUseE3            = false; // E3: richiede N barre a range STRETTAMENTE calante al livello
input int    InpE3_Bars          = 3;     // Numero di barre calanti (firma: 2-3)

input group "=== SESSIONE (ORA DEL FEED; _EXT = NY 09:30) ==="
input int    InpSessionHour      = 9;     // Ora di apertura seduta (feed _EXT NY = 9)
input int    InpSessionMin       = 30;    // Minuto di apertura seduta (_EXT NY = 30)
input int    InpSessionEndHour   = 15;    // Ora del FLAT di fine seduta (NY 15)
input int    InpSessionEndMin    = 55;    // Minuto del FLAT (NY 55 = 15:55, prima del close 16:00)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlBufferPts      = 300;   // SL oltre l'estremo fadato, in PUNTI MT5 (3 pti indice)
input int    InpMinStopPts       = 500;   // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== USCITA (rientro verso VWAP + flat fine seduta) ==="
input bool   InpUseVwapTP        = true;  // TP = VWAP di seduta (il rientro). Se dal lato sbagliato -> ripiego R
input double InpTP_R             = 1.5;   // TP di ripiego in multipli di R (usato se la VWAP non e' un target valido)
input bool   InpCloseOnOpposite  = false; // Chiudi anche sul segnale d'inversione OPPOSTO (opt-in)

input group "=== Rischio e cap ==="
input double InpRiskPercent      = 0.65;  // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay  = 2;     // Max ingressi ESEGUITI al giorno (0 = illimitato)
input bool   InpAllowLong        = true;  // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort       = true;  // Ammetti gli SHORT

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice= 100;   // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment          = "INVES"; // Commento sugli ordini
input long   InpMagic            = 769000;  // Numero magico (blocco 7690xx: verificato LIBERO nel repo)
input int    InpMaxSpread        = 0;       // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose          = true;    // Messaggi nel log
input bool   InpAutoTest         = true;    // Stampa le righe [INVES][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA, nessun cambio di logica): un contatore
//    per ogni punto di uscita/blocco di OnNewBar. Escono IN COLONNA
//    nell'OPTFRAME per capire QUALE cancello ferma le barre.
long gCntOnNewBar     = 0;   // chiamate totali a OnNewBar
long gCntGestione     = 0;   // return: c'era posizione aperta (gestione uscita)
long gCntNoContesto   = 0;   // return: contesto (D1/seduta) non disponibile
long gCntPrimaBarra   = 0;   // return: pos<=0 (prima barra della seduta)
long gCntMaxTrades    = 0;   // return: cap trade/giorno raggiunto
long gCntFuoriSeduta  = 0;   // return: fuori seduta
long gCntSpread       = 0;   // return: spread non ok
long gCntE1Ko         = 0;   // E1 acceso e non soddisfatto
long gCntE3Ko         = 0;   // E3 acceso e non soddisfatto
long gCntShortCand    = 0;   // candidati SHORT (dopo E1/E3, prima del gate AllowShort)
long gCntLongCand     = 0;   // candidati LONG
long gCntApri         = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[INVES] ", m); }

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
//| Un istante (in minuti del giorno) e' DENTRO la seduta? [start,end)|
//| La barra che APRE all'ora di fine NON e' in seduta (li' scatta il |
//| flat). Le sedute di casa non attraversano la mezzanotte.          |
//+------------------------------------------------------------------+
bool InSeduta_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);   // difensivo: mai usato di casa
  }

//+------------------------------------------------------------------+
//| ADR - Average Daily Range: media di (high-low) su n giorni.       |
//| Salta i giorni con high/low <= 0 o high<low (dato mancante).      |
//| Ritorna i giorni USATI e scrive la media in 'adr'. 0 giorni utili |
//| -> adr 0 e ritorna 0 (senza dati l'ADR non esiste).               |
//+------------------------------------------------------------------+
int AdrMedia_Calc(const double &highs[],const double &lows[],const int n,double &adr)
  {
   adr=0;
   if(n<1) return(0);
   if(ArraySize(highs)<n || ArraySize(lows)<n) return(0);
   double somma=0; int usati=0;
   for(int i=0;i<n;i++)
     {
      if(highs[i]<=0 || lows[i]<=0) continue;
      if(highs[i]<lows[i]) continue;
      somma += (highs[i]-lows[i]);
      usati++;
     }
   if(usati<1) return(0);
   adr = somma/usati;
   return(usati);
  }

//+------------------------------------------------------------------+
//| E1 - esaurimento: il range del giorno FINORA ha gia' speso >=     |
//| mult x ADR. Senza ADR (adr<=0) ritorna false: non si dichiara     |
//| esaurimento senza il metro (fail-safe).                           |
//+------------------------------------------------------------------+
bool EsaurimentoOk_Calc(const double dayRange,const double adr,const double mult)
  {
   if(adr<=0) return(false);
   return(dayRange >= mult*adr);
  }

//+------------------------------------------------------------------+
//| E2 - tocco del livello. La barra RAGGIUNGE la resistenza se il    |
//| suo high arriva al livello (entro tolleranza); il supporto se il  |
//| suo low ci arriva.                                                |
//+------------------------------------------------------------------+
bool ToccaResistenza_Calc(const double barHigh,const double level,const double tol)
  {
   if(level<=0) return(false);
   return(barHigh >= level - tol);
  }
bool ToccaSupporto_Calc(const double barLow,const double level,const double tol)
  {
   if(level<=0) return(false);
   return(barLow <= level + tol);
  }

//+------------------------------------------------------------------+
//| E3 - perdita di spinta: le ultime n barre hanno range             |
//| STRETTAMENTE decrescente. ranges[0] = barra piu' recente (quella  |
//| appena chiusa). Momentum in calo = ranges[0]<ranges[1]<...        |
//| n<2 -> false (serve almeno un confronto).                         |
//+------------------------------------------------------------------+
bool RangeCalante_Calc(const double &ranges[],const int n)
  {
   if(n<2) return(false);
   if(ArraySize(ranges)<n) return(false);
   for(int i=0;i<n;i++) if(ranges[i]<0) return(false);
   for(int i=0;i<n-1;i++)
      if(!(ranges[i] < ranges[i+1])) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE D'INVERSIONE - il cuore del motore.                    |
//| Valuta la barra appena chiusa (high/low/close) contro i livelli e |
//| gli interruttori. Ritorna +1 = LONG (fada un supporto dopo una    |
//| discesa), -1 = SHORT (fada una resistenza dopo una salita), 0 =   |
//| niente. La direzione della mossa e' data da close vs apertura di   |
//| seduta: si entra CONTRO una mossa direzionale, non nel chop.       |
//| E1/E3, se accesi, sono cancelli AGGIUNTIVI: spengono il segnale.  |
//+------------------------------------------------------------------+
int SegnaleInversione_Calc(
   const double barHigh,const double barLow,const double barClose,
   const double sessOpen,const double sessHighPrec,const double sessLowPrec,
   const double pdh,const double pdl,const double tol,
   const bool usePrevDay,const bool useSessExtreme,
   const bool useE1,const bool e1Ok,
   const bool useE3,const bool e3Calante)
  {
   //--- E2: quali livelli sono stati RAGGIUNTI dalla barra
   bool resPrev = usePrevDay     && ToccaResistenza_Calc(barHigh, pdh, tol);
   bool resSess = useSessExtreme && (barHigh > sessHighPrec);   // nuovo max di seduta (estremo)
   bool supPrev = usePrevDay     && ToccaSupporto_Calc(barLow, pdl, tol);
   bool supSess = useSessExtreme && (barLow  < sessLowPrec);    // nuovo min di seduta (estremo)
   bool resTouch = resPrev || resSess;
   bool supTouch = supPrev || supSess;

   //--- la mossa direzionale (close vs apertura di seduta)
   bool upMove   = (barClose > sessOpen);
   bool downMove = (barClose < sessOpen);

   //--- si entra CONTRO la mossa esausta al livello
   bool shortCand = resTouch && upMove;    // salita esausta a resistenza -> SHORT
   bool longCand  = supTouch && downMove;  // discesa esausta a supporto  -> LONG

   if(shortCand == longCand) return(0);    // nessuno o (difensivo) ambiguo

   //--- cancelli AGGIUNTIVI, un interruttore per volta (ablazione a stella)
   if(useE1 && !e1Ok)      return(0);
   if(useE3 && !e3Calante) return(0);

   return(shortCand ? -1 : +1);
  }

//+------------------------------------------------------------------+
//| SL d'inversione: oltre l'estremo che si fada, di un buffer.       |
//|   short -> refExtreme + buffer ; long -> refExtreme - buffer      |
//+------------------------------------------------------------------+
double SlInversione_Calc(const bool isShort,const double refExtreme,const double buffer)
  {
   return(isShort ? refExtreme+buffer : refExtreme-buffer);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109, convenzione di casa). Se lo stop e'   |
//| piu' vicino del pavimento, si ALLARGA al pavimento; non si salta  |
//| il trade e non si lascia lo stop a zero. pavimento<=0 -> invariato|
//| (ma il chiamante garantisce > 0).                                 |
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
//| TP del RIENTRO: verso la VWAP di seduta (la media). Se la VWAP e' |
//| dal lato sbagliato (non e' un target valido), ripiego a R.        |
//|   short: target valido se vwap < entry ; long: se vwap > entry.   |
//|   ripiego: short entry-tpR*slDist ; long entry+tpR*slDist.        |
//+------------------------------------------------------------------+
double TpRientro_Calc(const bool isShort,const double entry,const double vwap,
                      const bool useVwap,const double slDist,const double tpR)
  {
   if(useVwap && vwap>0)
     {
      if(isShort && vwap<entry) return(vwap);
      if(!isShort && vwap>entry) return(vwap);
     }
   if(slDist<=0 || tpR<=0) return(0);
   return(isShort ? entry-tpR*slDist : entry+tpR*slDist);
  }

//+------------------------------------------------------------------+
//| VWAP di sessione pesata sul volume (sorgente = close). src[] =    |
//| close, vol[] = pesi. false se non c'e' peso.                      |
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
//| Marcatore di SESSIONE (le sedute di casa non attraversano la      |
//| mezzanotte). Due barre stanno nella stessa seduta se hanno lo     |
//| stesso marcatore.                                                 |
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t,const int startMinuti)
  {
   long s = (long)t - (long)startMinuti*60;
   if(s<0) s=0;
   return(s/86400);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - nucleo puro. Vero quando l'ora corrente ha  |
//| raggiunto o superato l'ora di fine seduta (confronto in minuti).  |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE.                  |
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

   if(!InpUsePrevDayLevels && !InpUseSessionExtreme)
     { Print("ERRORE: E2 spento su entrambi i livelli: senza livello l'inversione non ha dove armarsi."); return(INIT_FAILED); }
   if(InpLevelTolPts<0)
     { Print("ERRORE: InpLevelTolPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpUseE1 && (InpE1_AdrDays<2))
     { Print("ERRORE: InpE1_AdrDays deve essere >= 2 quando E1 e' acceso."); return(INIT_FAILED); }
   if(InpUseE1 && (InpE1_AdrMult<=0))
     { Print("ERRORE: InpE1_AdrMult deve essere > 0 quando E1 e' acceso."); return(INIT_FAILED); }
   if(InpUseE3 && (InpE3_Bars<2))
     { Print("ERRORE: InpE3_Bars deve essere >= 2 quando E3 e' acceso."); return(INIT_FAILED); }
   if(InpSessionHour<0 || InpSessionHour>23 || InpSessionMin<0 || InpSessionMin>59)
     { Print("ERRORE: ora/minuto di apertura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpSessionEndHour<0 || InpSessionEndHour>23 || InpSessionEndMin<0 || InpSessionEndMin>59)
     { Print("ERRORE: ora/minuto di chiusura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin) >= MinutiDelGiorno_Calc(InpSessionEndHour,InpSessionEndMin))
     { Print("ERRORE: la seduta di casa NON attraversa la mezzanotte: apertura deve precedere la chiusura."); return(INIT_FAILED); }
   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing per
   //    un'inversione (coltello che cade): OnInit rifiuta se e' 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un'inversione senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpUseVwapTP==false && InpTP_R<=0)
     { Print("ERRORE: senza VWAP-TP serve un InpTP_R > 0 per avere un obiettivo di rientro."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestInversione();

   Log(StringFormat("avviato su %s %s. E2[prevDay=%d,sessExtr=%d] E1[%s x%.2f/%dgg] E3[%s x%d barre], seduta %02d:%02d-%02d:%02d, SL buffer %d + pavimento %d pti MT5, rischio %.2f%%, cap %d/gg, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       (int)InpUsePrevDayLevels, (int)InpUseSessionExtreme,
       (InpUseE1?"ON":"off"), InpE1_AdrMult, InpE1_AdrDays,
       (InpUseE3?"ON":"off"), InpE3_Bars,
       InpSessionHour, InpSessionMin, InpSessionEndHour, InpSessionEndMin,
       InpSlBufferPts, InpMinStopPts, InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione: motore INTRADAY d'inversione, niente overnight. Ingresso SINGOLO: nessuna aggiunta/mediazione/griglia su posizione aperta (contratto).");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- nessun handle indicatore da rilasciare: il contesto (ADR, livelli,
   //    VWAP, range) e' ricostruito da CopyRates, senza stato persistente.
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
//  IL CONTESTO - tutto cio' che serve alla decisione, letto dai dati
//  e SENZA stato persistente (sopravvive a un riavvio).
//==================================================================
struct Contesto
  {
   double  pdh, pdl;          // max/min del giorno PRIMA (D1 shift 1)
   double  adr;               // ADR su InpE1_AdrDays giorni
   int     adrGiorni;         // giorni realmente usati per l'ADR
   double  dayRange;          // range del giorno FINORA (D1 shift 0)
   double  sessOpen;          // apertura della seduta corrente
   double  sessHighPrec;      // max di seduta PRIMA della barra valutata
   double  sessLowPrec;       // min di seduta PRIMA della barra valutata
   double  sessHighIncl;      // max di seduta INCLUSA la barra valutata
   double  sessLowIncl;       // min di seduta INCLUSA la barra valutata
   double  vwap;              // VWAP di seduta fino alla barra valutata
   bool    vwapOk;
   int     pos;               // posizione della barra nella seduta (0 = prima)
   bool    e3Calante;         // E3: le ultime InpE3_Bars barre a range calante
  };

//+------------------------------------------------------------------+
//| Legge i livelli/ADR/range dal timeframe D1.                       |
//+------------------------------------------------------------------+
bool LeggiD1(Contesto &c)
  {
   MqlRates d[]; ArraySetAsSeries(d,true);
   int need = InpE1_AdrDays + 3;
   int copied = CopyRates(_Symbol, PERIOD_D1, 0, need, d);
   if(copied < 2) return(false);          // serve almeno il giorno prima

   c.pdh = d[1].high;                      // max del giorno prima
   c.pdl = d[1].low;                       // min del giorno prima
   c.dayRange = d[0].high - d[0].low;      // range del giorno FINORA (shift 0)

   //--- ADR sui giorni CHIUSI precedenti (da shift 1 in poi)
   int nAdr = InpE1_AdrDays;
   double hs[]; double ls[];
   ArrayResize(hs,nAdr); ArrayResize(ls,nAdr);
   int got=0;
   for(int i=1; i<=nAdr && i<copied; i++)
     { hs[got]=d[i].high; ls[got]=d[i].low; got++; }
   c.adrGiorni = AdrMedia_Calc(hs, ls, got, c.adr);
   return(true);
  }

//+------------------------------------------------------------------+
//| Ricostruisce la seduta corrente per la barra a shiftEval:         |
//| apertura, estremi (prima e inclusa la barra), VWAP, posizione, E3.|
//+------------------------------------------------------------------+
bool LeggiSeduta(const int shiftEval, Contesto &c)
  {
   if(shiftEval<1) return(false);
   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 2*BarrePerGiornoPieno() + shiftEval + 5;
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<=shiftEval+1) return(false);
   if(!BarraInSeduta(r[shiftEval].time)) return(false);

   int  startMin = MinutiStartSeduta();
   long stamp    = SessionStamp_Calc(r[shiftEval].time, startMin);

   //--- prima barra della seduta: il piu' VECCHIO shift con lo stesso
   //    stamp, contiguo verso shiftEval.
   int firstShift = shiftEval;
   for(int i=shiftEval+1;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=stamp) break;
      firstShift = i;
     }
   c.pos = firstShift - shiftEval;          // 0 = prima barra della seduta
   c.sessOpen = r[firstShift].open;

   //--- estremi di seduta PRIMA della barra valutata (shift > shiftEval,
   //    stesso stamp) e VWAP dalla prima barra a shiftEval inclusa.
   c.sessHighPrec = -DBL_MAX;
   c.sessLowPrec  =  DBL_MAX;
   for(int i=shiftEval+1;i<=firstShift;i++)
     {
      if(r[i].high > c.sessHighPrec) c.sessHighPrec = r[i].high;
      if(r[i].low  < c.sessLowPrec ) c.sessLowPrec  = r[i].low;
     }
   c.sessHighIncl = MathMax((c.sessHighPrec==-DBL_MAX? r[shiftEval].high : c.sessHighPrec), r[shiftEval].high);
   c.sessLowIncl  = MathMin((c.sessLowPrec == DBL_MAX? r[shiftEval].low  : c.sessLowPrec ), r[shiftEval].low );

   //--- VWAP di seduta (sorgente close, pesi tick volume): dalla prima
   //    barra fino a shiftEval inclusa.
   int cap = (firstShift - shiftEval) + 2;
   double src[]; double vol[];
   ArrayResize(src,cap); ArrayResize(vol,cap);
   int n=0;
   for(int i=shiftEval;i<=firstShift && n<cap;i++)
     {
      src[n]=r[i].close;
      vol[n]=(double)r[i].tick_volume;   // TICK VOLUME: scostamento dichiarato
      n++;
     }
   c.vwapOk = Vwap_Calc(src,vol,n,c.vwap);

   //--- E3: le ultime InpE3_Bars barre (shiftEval, shiftEval+1, ...) a
   //    range strettamente calante. Devono essere tutte nella seduta.
   c.e3Calante = false;
   if(InpUseE3 && InpE3_Bars>=2)
     {
      int nb = InpE3_Bars;
      double ranges[]; ArrayResize(ranges,nb);
      bool ok=true;
      for(int k=0;k<nb;k++)
        {
         int sh = shiftEval+k;
         if(sh>=copied || !BarraInSeduta(r[sh].time) ||
            SessionStamp_Calc(r[sh].time,startMin)!=stamp) { ok=false; break; }
         ranges[k] = r[sh].high - r[sh].low;   // ranges[0] = barra piu' recente
        }
      if(ok) c.e3Calante = RangeCalante_Calc(ranges, nb);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valuta la barra APPENA CHIUSA      |
//| (shift 1); l'ordine parte al mercato all'apertura della barra 0.  |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   Contesto c;
   bool okD1  = LeggiD1(c);
   bool okSes = LeggiSeduta(1, c);

   //--- USCITE della posizione aperta PRIMA di ogni cancello d'ingresso.
   if(CountPositions()>0)
     {
      gCntGestione++;
      if(okD1 && okSes) GestisciUscita(c);
      return;                                 // una posizione per magic
     }

   if(!okD1 || !okSes){ gCntNoContesto++; return; }   // contesto non pronto
   if(c.pos <= 0){ gCntPrimaBarra++; return; }         // prima barra di seduta: mai ingresso
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!InSedutaOra(TimeCurrent())){ gCntFuoriSeduta++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0){ gCntNoContesto++; return; }

   double tolPrezzo = InpLevelTolPts*_Point;
   bool   e1Ok = EsaurimentoOk_Calc(c.dayRange, c.adr, InpE1_AdrMult);

   int sig = SegnaleInversione_Calc(
      barHigh, barLow, barClose,
      c.sessOpen, c.sessHighPrec, c.sessLowPrec,
      c.pdh, c.pdl, tolPrezzo,
      InpUsePrevDayLevels, InpUseSessionExtreme,
      InpUseE1, e1Ok,
      InpUseE3, c.e3Calante);

   //--- DIAG: perche' e' 0? (solo se un cancello opzionale ha spento)
   if(sig==0)
     {
      if(InpUseE1 && !e1Ok)      gCntE1Ko++;
      if(InpUseE3 && !c.e3Calante) gCntE3Ko++;
      return;
     }

   bool isShort = (sig<0);
   if(isShort) gCntShortCand++; else gCntLongCand++;

   if(isShort && InpAllowShort){ gCntApri++; ApriPosizione(false, c); return; }
   if(!isShort && InpAllowLong){ gCntApri++; ApriPosizione(true , c); }
  }

//+------------------------------------------------------------------+
//| Gestione dell'uscita a barra chiusa: segnale d'inversione OPPOSTO |
//| (opt-in). Il TP di RIENTRO e lo STOP restano ordini veri sul      |
//| server e possono scattare intrabar, indipendenti da qui. Il flat  |
//| di fine seduta e' gestito a parte in OnTick.                      |
//+------------------------------------------------------------------+
void GestisciUscita(const Contesto &c)
  {
   if(!InpCloseOnOpposite) return;

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0) return;

   double tolPrezzo = InpLevelTolPts*_Point;
   bool   e1Ok = EsaurimentoOk_Calc(c.dayRange, c.adr, InpE1_AdrMult);
   //--- per l'USCITA il segnale opposto si legge NUDO (E1/E3 non filtrano
   //    l'uscita: qui filtriamo l'INGRESSO, non la protezione).
   int sig = SegnaleInversione_Calc(
      barHigh, barLow, barClose,
      c.sessOpen, c.sessHighPrec, c.sessLowPrec,
      c.pdh, c.pdl, tolPrezzo,
      InpUsePrevDayLevels, InpUseSessionExtreme,
      false, e1Ok, false, c.e3Calante);
   if(sig==0) return;

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      if((isLong && sig<0) || (!isLong && sig>0))
        {
         if(gTrade.PositionClose(tk)) Log("segnale d'inversione opposto: posizione chiusa.");
        }
     }
  }

//==================================================================
//  LETTURA DEI DATI (aiutanti di sessione)
//==================================================================
int MinutiStartSeduta(){ return(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin)); }
int MinutiEndSeduta()  { return(MinutiDelGiorno_Calc(InpSessionEndHour,InpSessionEndMin)); }

bool BarraInSeduta(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return(InSeduta_Calc(MinutiDelGiorno_Calc(d.hour,d.min), MinutiStartSeduta(), MinutiEndSeduta()));
  }
bool InSedutaOra(const datetime t){ return(BarraInSeduta(t)); }

//--- barre di un GIORNO PIENO di calendario (~24h / TF): dimensiona la
//    copia storica (CopyRates conta barre CONSECUTIVE sul CALENDARIO).
int BarrePerGiornoPieno()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=300;
   int b = (int)(86400/per);
   return(b<10?10:b);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL oltre l'estremo fadato (buffer), |
//| poi SEMPRE dal PAVIMENTO (mai a zero, mai dentro lo stops-level).  |
//| TP verso la VWAP di seduta (rientro) o ripiego a R. Il lotto esce |
//| da LotByRisk sulla distanza FINALE dello stop.                    |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong, const Contesto &c)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   //--- estremo fadato: per uno SHORT il max di seduta (incl. la barra);
   //    per un LONG il min. Se il livello prev-day fadato e' oltre, si
   //    prende il piu' esterno (lo stop deve stare oltre l'estremo VERO).
   double refExtreme;
   if(!isLong)
      refExtreme = MathMax(c.sessHighIncl, (InpUsePrevDayLevels? c.pdh : c.sessHighIncl));
   else
      refExtreme = MathMin(c.sessLowIncl,  (InpUsePrevDayLevels? c.pdl : c.sessLowIncl));

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlInversione_Calc(!isLong, refExtreme, bufferPrezzo);

   //--- PAVIMENTO OBBLIGATORIO (R109): la distanza non e' mai piu' stretta
   //    del pavimento in punti MT5, e mai dentro lo stops-level del broker.
   double pavimento = InpMinStopPts*_Point;
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo: salto per non lasciare lo stop scoperto (R109)."); return(false); }

   double sl = PavimentoSL_Calc(isLong, ref, slRaw, pavFinale);
   sl = NormalizePrice(sl);
   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- TP del rientro (VWAP o ripiego R). Rispetta lo stops-level: se
   //    troppo vicino, lo si spinge al minimo consentito; se non c'e'
   //    target valido, si resta senza TP (flat/uscita opposta proteggono).
   double vwap = (c.vwapOk ? c.vwap : 0);
   double tp = TpRientro_Calc(isLong? false: true, ref, vwap, InpUseVwapTP, distSL, InpTP_R);
   if(tp>0)
     {
      double distTP = isLong ? (tp-ref) : (ref-tp);
      if(distTP < minBroker) tp = isLong ? ref+minBroker : ref-minBroker;
      if(distTP<=0) tp = 0;                    // target dal lato sbagliato: niente TP
      if(tp>0) tp = NormalizePrice(tp);
     }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_InvEsaurimento")) return(false);

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp,cm);
   if(ok)
     {
      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP %s lot %.2f (rischio %.1f pti idx | ADR %s / %dgg, dayRange %s)",
          isLong?"BUY(inv.supporto)":"SELL(inv.resistenza)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          (tp>0?DoubleToString(tp,_Digits):"-"), lot, idxRisk,
          DoubleToString(c.adr,_Digits), c.adrGiorni, DoubleToString(c.dayRange,_Digits)));
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
         Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
                          InpSessionEndHour, InpSessionEndMin, chiuse));
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
void AutoTestInversione()
  {
   int falliti=0;

   PrintFormat("[INVES][AUTOTEST] E2[prevDay=%d,sessExtr=%d] E1[%s x%.2f/%dgg] E3[%s x%d] | %s | magic %I64d",
               (int)InpUsePrevDayLevels,(int)InpUseSessionExtreme,
               (InpUseE1?"ON":"off"),InpE1_AdrMult,InpE1_AdrDays,
               (InpUseE3?"ON":"off"),InpE3_Bars,_Symbol,InpMagic);

   //--- 1. ADR (media di high-low), con salto dei giorni invalidi
   double h2[2]; h2[0]=110; h2[1]=120;
   double l2[2]; l2[0]=100; l2[1]=100;          // range 10, 20 -> adr 15
   double a1=0; int u1=AdrMedia_Calc(h2,l2,2,a1);
   double h3[3]; h3[0]=110; h3[1]=120; h3[2]=0; // terzo invalido -> saltato
   double l3[3]; l3[0]=100; l3[1]=100; l3[2]=0;
   double a2=0; int u2=AdrMedia_Calc(h3,l3,3,a2);
   double a3=0; int u3=AdrMedia_Calc(h2,l2,0,a3);   // n=0 -> 0
   PrintFormat("[INVES][AUTOTEST] adr: %.4f/%d (attesi 15.0000/2) | invalidi %.4f/%d (attesi 15.0000/2) | n0 %d (atteso 0)",
               a1,u1,a2,u2,u3);
   if(!(u1==2 && MathAbs(a1-15.0)<1e-6 && u2==2 && MathAbs(a2-15.0)<1e-6 && u3==0)) falliti++;

   //--- 2. E1 esaurimento (dayRange >= mult*adr ; adr<=0 -> false)
   bool e1a=EsaurimentoOk_Calc(16.0,15.0,1.0);   // 16>=15 -> vero
   bool e1b=EsaurimentoOk_Calc(14.0,15.0,1.0);   // 14<15  -> falso
   bool e1c=EsaurimentoOk_Calc(30.0,15.0,1.5);   // 30>=22.5 -> vero
   bool e1d=EsaurimentoOk_Calc(16.0, 0.0,1.0);   // senza adr -> falso
   PrintFormat("[INVES][AUTOTEST] E1: sopra=%d (1) | sotto=%d (0) | mult1.5=%d (1) | noAdr=%d (0)",
               (int)e1a,(int)e1b,(int)e1c,(int)e1d);
   if(!(e1a && !e1b && e1c && !e1d)) falliti++;

   //--- 3. tocco livelli (resistenza/supporto con tolleranza)
   bool t1=ToccaResistenza_Calc(110.5,110.0,1.0);  // arriva -> vero
   bool t2=ToccaResistenza_Calc(108.0,110.0,1.0);  // sotto -> falso
   bool t3=ToccaSupporto_Calc  ( 89.5, 90.0,1.0);  // arriva -> vero
   bool t4=ToccaSupporto_Calc  ( 92.0, 90.0,1.0);  // sopra -> falso
   PrintFormat("[INVES][AUTOTEST] livelli: res tocca=%d (1) | res no=%d (0) | sup tocca=%d (1) | sup no=%d (0)",
               (int)t1,(int)t2,(int)t3,(int)t4);
   if(!(t1 && !t2 && t3 && !t4)) falliti++;

   //--- 4. E3 range calante (ranges[0] = barra piu' recente)
   double rc1[3]; rc1[0]=1; rc1[1]=2; rc1[2]=3;   // calante -> vero
   double rc2[3]; rc2[0]=2; rc2[1]=2; rc2[2]=3;   // piatto in testa -> falso
   double rc3[3]; rc3[0]=3; rc3[1]=2; rc3[2]=1;   // crescente -> falso
   bool c1=RangeCalante_Calc(rc1,3);
   bool c2=RangeCalante_Calc(rc2,3);
   bool c3=RangeCalante_Calc(rc3,3);
   PrintFormat("[INVES][AUTOTEST] E3: calante=%d (1) | piatto=%d (0) | crescente=%d (0)",
               (int)c1,(int)c2,(int)c3);
   if(!(c1 && !c2 && !c3)) falliti++;

   //--- 5. IL SEGNALE D'INVERSIONE (il cuore). pdh 110, pdl 90, tol 1,
   //    sessOpen 100, sessHighPrec 105, sessLowPrec 95.
   double PDH=110,PDL=90,TOL=1,SO=100,SHP=105,SLP=95;
   //    short via prev-day resistenza (high 110.5, close 110 up)
   int s1=SegnaleInversione_Calc(110.5,108,110, SO,SHP,SLP, PDH,PDL,TOL, true,false, false,false, false,false);
   //    long via prev-day supporto (low 89.5, close 90 down)
   int s2=SegnaleInversione_Calc(92,89.5,90,    SO,SHP,SLP, PDH,PDL,TOL, true,false, false,false, false,false);
   //    short via ESTREMO di seduta (high 106 > 105, close 106 up), prevDay off
   int s3=SegnaleInversione_Calc(106,104,106,   SO,SHP,SLP, PDH,PDL,TOL, false,true, false,false, false,false);
   //    resistenza toccata ma NIENTE mossa su (close 99 down) -> 0
   int s4=SegnaleInversione_Calc(110.5,108,99,  SO,SHP,SLP, PDH,PDL,TOL, true,false, false,false, false,false);
   //    E1 acceso ma non soddisfatto -> spegne lo short
   int s5=SegnaleInversione_Calc(110.5,108,110, SO,SHP,SLP, PDH,PDL,TOL, true,false, true,false, false,false);
   //    E1 acceso e soddisfatto -> lo short passa
   int s6=SegnaleInversione_Calc(110.5,108,110, SO,SHP,SLP, PDH,PDL,TOL, true,false, true,true , false,false);
   //    E3 acceso ma non calante -> spegne ; poi calante -> passa
   int s7=SegnaleInversione_Calc(110.5,108,110, SO,SHP,SLP, PDH,PDL,TOL, true,false, false,false, true,false);
   int s8=SegnaleInversione_Calc(110.5,108,110, SO,SHP,SLP, PDH,PDL,TOL, true,false, false,false, true,true );
   PrintFormat("[INVES][AUTOTEST] segnale: shortPrev=%d(-1) longPrev=%d(1) shortSess=%d(-1) noMossa=%d(0) E1off=%d(0) E1on=%d(-1) E3off=%d(0) E3on=%d(-1)",
               s1,s2,s3,s4,s5,s6,s7,s8);
   if(!(s1==-1 && s2==1 && s3==-1 && s4==0 && s5==0 && s6==-1 && s7==0 && s8==-1)) falliti++;

   //--- 6. SL d'inversione + PAVIMENTO (mai a zero: R109)
   double sl_s=SlInversione_Calc(true ,110.0,0.5);   // short -> 110.5
   double sl_l=SlInversione_Calc(false, 90.0,0.5);   // long  -> 89.5
   double p1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double p2=PavimentoSL_Calc(true ,100.0, 97.0,2.0);  // gia' oltre -> 97.00
   double p3=PavimentoSL_Calc(false,100.0,100.2,2.0);  // short -> 102.00
   PrintFormat("[INVES][AUTOTEST] SL: short=%.2f (110.50) long=%.2f (89.50) | pav %.2f (98.00) %.2f (97.00) short %.2f (102.00)",
               sl_s,sl_l,p1,p2,p3);
   if(!(MathAbs(sl_s-110.5)<1e-6 && MathAbs(sl_l-89.5)<1e-6 &&
        MathAbs(p1-98.0)<1e-6 && MathAbs(p2-97.0)<1e-6 && MathAbs(p3-102.0)<1e-6)) falliti++;

   //--- 7. TP del RIENTRO (VWAP se valida, ripiego R)
   double tp1=TpRientro_Calc(true ,100.0, 95.0,true ,2.0,1.5);  // short vwap 95 valida -> 95
   double tp2=TpRientro_Calc(true ,100.0,102.0,true ,2.0,1.5);  // short vwap dal lato sbagliato -> 100-3=97
   double tp3=TpRientro_Calc(false,100.0,105.0,true ,2.0,1.5);  // long vwap 105 valida -> 105
   double tp4=TpRientro_Calc(true ,100.0, 95.0,false,2.0,1.5);  // VWAP off -> ripiego 97
   PrintFormat("[INVES][AUTOTEST] TP: shortVwap=%.2f (95.00) shortRipiego=%.2f (97.00) longVwap=%.2f (105.00) vwapOff=%.2f (97.00)",
               tp1,tp2,tp3,tp4);
   if(!(MathAbs(tp1-95.0)<1e-6 && MathAbs(tp2-97.0)<1e-6 &&
        MathAbs(tp3-105.0)<1e-6 && MathAbs(tp4-97.0)<1e-6)) falliti++;

   //--- 8. VWAP (pesata sul volume, sorgente close)
   double sv[2]; sv[0]=10.0; sv[1]=20.0;
   double wv[2]; wv[0]= 1.0; wv[1]= 1.0;
   double vw1=0; bool rv1=Vwap_Calc(sv,wv,2,vw1);         // 15
   double wp[2]; wp[0]= 1.0; wp[1]= 3.0;
   double vw2=0; bool rv2=Vwap_Calc(sv,wp,2,vw2);         // 17.5
   double vw3=0; bool rv3=Vwap_Calc(sv,wv,0,vw3);         // n=0 -> false
   PrintFormat("[INVES][AUTOTEST] vwap: %.4f (15.0000) pesata %.4f (17.5000) n0 ok=%d (0)",
               vw1,vw2,(int)rv3);
   if(!(rv1 && rv2 && !rv3 && MathAbs(vw1-15.0)<1e-6 && MathAbs(vw2-17.5)<1e-6)) falliti++;

   //--- 9. SEDUTA / STAMP / FLAT / conversione punti (NY 09:30-15:55)
   int mS=MinutiDelGiorno_Calc(9,30), mE=MinutiDelGiorno_Calc(15,55);
   bool se1=InSeduta_Calc(MinutiDelGiorno_Calc( 9,30),mS,mE);  // apertura inclusa
   bool se2=InSeduta_Calc(MinutiDelGiorno_Calc(12, 0),mS,mE);  // dentro
   bool se3=InSeduta_Calc(MinutiDelGiorno_Calc(15,55),mS,mE);  // chiusura esclusa
   bool se4=InSeduta_Calc(MinutiDelGiorno_Calc( 9,15),mS,mE);  // prima dell'apertura
   bool fl1=DopoOrarioFlat_Calc(15,55,15,55);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(15,54,15,55);   // prima -> no
   datetime tA=D'2026.08.25 10:00:00';
   datetime tB=D'2026.08.25 14:00:00';
   datetime tC=D'2026.08.26 10:00:00';
   bool sm1=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tB,mS));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tC,mS));  // diverse
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   PrintFormat("[INVES][AUTOTEST] seduta: apert=%d(1) dentro=%d(1) fine=%d(0) pre=%d(0) | flat esatto=%d(1) prima=%d(0) | stamp same=%d(1) diff=%d(0) | conv=%.2f(5.00)",
               (int)se1,(int)se2,(int)se3,(int)se4,(int)fl1,(int)fl2,(int)sm1,(int)sm2,ip1);
   if(!(se1 && se2 && !se3 && !se4 && fl1 && !fl2 && sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[INVES][AUTOTEST] esito motore: ", (falliti==0
         ? "NOVE BLOCCHI SU NOVE, il motore ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
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
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   int nd=HistoryDealsTotal();

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
   double stats[24];
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
   //    INSIEME (una colonna aggiunta a uno solo sfasa tutto il CSV).
   stats[13] = (double)gCntOnNewBar;       // OnNewBar Chiamate
   stats[14] = (double)gCntGestione;       // Ret Gestione Uscita
   stats[15] = (double)gCntNoContesto;     // Ret No Contesto
   stats[16] = (double)gCntPrimaBarra;     // Ret Prima Barra
   stats[17] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[18] = (double)gCntFuoriSeduta;    // Ret Fuori Seduta
   stats[19] = (double)gCntE1Ko;           // E1 Ko
   stats[20] = (double)gCntE3Ko;           // E3 Ko
   stats[21] = (double)gCntShortCand;      // Short Cand
   stats[22] = (double)gCntLongCand;       // Long Cand
   stats[23] = (double)gCntApri;           // Apri Chiamate

   PrintFormat("[INVES][DIAG] OnNewBar=%I64d | ret: gestione=%I64d noContesto=%I64d primaBarra=%I64d maxTrades=%I64d fuoriSeduta=%I64d | E1ko=%I64d E3ko=%I64d | shortCand=%I64d longCand=%I64d apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoContesto, gCntPrimaBarra,
               gCntMaxTrades, gCntFuoriSeduta, gCntE1Ko, gCntE3Ko,
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione Uscita,Ret No Contesto,Ret Prima Barra,Ret Max Trades,Ret Fuori Seduta,E1 Ko,E3 Ko,Short Cand,Long Cand,Apri Chiamate";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
