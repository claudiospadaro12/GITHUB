//+------------------------------------------------------------------+
//|                                        ABTG_DaxValueArea.mq5      |
//|                                                                  |
//|  MOTORE MARKET-PROFILE / VALUE-AREA sull'APERTURA DAX - MT5      |
//|  TUTTO-IN-UNO (metti in MQL5\Experts e compila con F7).          |
//|                                                                  |
//|  COS'E' - Cuore automatizzabile del metodo volumetrico DAX V5 di |
//|  Claudio (docs/metodi). Volume Profile su TICK-VOLUME (proxy: il |
//|  CFD non ha volume reale). Legge il VALORE ACCETTATO nella       |
//|  sessione PRECEDENTE (Value Area = fascia che contiene ~70% del  |
//|  volume attorno al POC) e lo usa per governare l'apertura di     |
//|  oggi (FASE 5 del metodo).                                       |
//|                                                                  |
//|  SPEC/GRIGLIA congelata:                                         |
//|    backtest_pipeline\prove\ABTG_DaxValueArea.txt                 |
//|  Analisi automatizzabile vs discrezionale:                       |
//|    docs\metodi\ANALISI_METODO_VOLUMETRICO_DAX_V5.md              |
//|                                                                  |
//|  I DUE MOTORI (selezionati dalla posizione dell'apertura vs VA)  |
//|    FASE 5 - classificazione dell'apertura di OGGI:               |
//|      open > VAH  -> candidato DIREZIONALE rialzista               |
//|      open < VAL  -> candidato DIREZIONALE ribassista              |
//|      open in [VAL,VAH] -> BALANCE (rotazione)                    |
//|                                                                  |
//|    BALANCE (open dentro VA): FADE dei bordi. LONG quando il      |
//|      prezzo tocca/rientra da VAL (target POC poi VAH); SHORT     |
//|      quando tocca/rientra da VAH (target POC poi VAL). SL oltre  |
//|      il bordo fadato + pavimento.                                |
//|                                                                  |
//|    DIREZIONALE (open fuori VA): entra nel verso della rottura    |
//|      SOLO dopo InpAcceptBars barre che ACCETTANO fuori dalla VA  |
//|      (chiudono oltre il bordo). E' la CONFERMA, non la rottura   |
//|      nuda: InpAcceptBars=0 = rottura nuda (da battere). Target = |
//|      estensione oltre il bordo; SL dentro la VA (oltre il bordo  |
//|      rotto) + pavimento.                                         |
//|                                                                  |
//|  PROP-HARDENING (identico allo scaffold ABTG_InvEsaurimento)     |
//|    - STOP LOSS VERO AL BROKER. PAVIMENTO SL OBBLIGATORIO (R109): |
//|      InpMinStopPts, MAI zero -> OnInit RIFIUTA se <= 0.          |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa.        |
//|    - INGRESSO SINGOLO, una posizione per magic. NIENTE           |
//|      martingala/griglia/recovery/DCA/averaging/virtual-stop:     |
//|      nessuna aggiunta su posizione aperta.                       |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                       |
//|    - FLAT OBBLIGATORIO a fine seduta cash DAX (ora SERVER): mai  |
//|      overnight.                                                  |
//|    - EXPORT PER-TRADE CSV + OnTester (metriche prop) +           |
//|      OnTesterInit/OnTesterDeinit (OPTFRAME). AUTOTEST in avvio.  |
//|                                                                  |
//|  ORARI: SEMPRE ORA DEL FEED (server). Il DAX cash apre 08:00     |
//|  server (09:00 IT, CLAUDE.md: server BCM = IT - 1h) e chiude     |
//|  16:30 server (17:30 IT). L'ancoraggio della sessione            |
//|  PRECEDENTE e di quella odierna usa InpSessionHour/Min e         |
//|  InpCloseHour/Min.                                               |
//|                                                                  |
//|  CONVERSIONE PUNTI: reso INPUT (InpMT5PerPuntoIndice), NON       |
//|  hardcoded. US = 100; DAX (D30EUR) DA VERIFICARE nel PASSO-0.    |
//|  Le distanze operative (buffer SL, tolleranza, pavimento) sono   |
//|  in PUNTI MT5; la bin del profilo (InpVaBinPts) e' in PUNTI      |
//|  INDICE e viene convertita con InpMT5PerPuntoIndice.             |
//|                                                                  |
//|  IL MURO DEL VOLUME (dichiarato, load-bearing): il volume su CFD |
//|  indici BCM e' TICK-VOLUME, NON volume scambiato reale. Il       |
//|  Volume Profile e i livelli POC/VAH/VAL sono un PROXY della      |
//|  FORMA di un edge di valore-accettato, MAI il libro ordini. E'   |
//|  l'avvertenza n.1 del metodo.                                    |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il segnale si valuta sulla barra    |
//|  appena chiusa (shift 1) e l'ordine parte all'apertura della     |
//|  barra 0. Niente look-ahead, niente repaint. Gli ordini SL/TP    |
//|  al broker possono scattare intrabar (sono ordini veri).         |
//|                                                                  |
//|  La Value Area della sessione precedente e' RICOSTRUITA da       |
//|  CopyRates ad ogni nuova seduta: nessuno stato persistente       |
//|  cross-day, sopravvive a un riavvio.                             |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola   |
//|  di casa). NON compilato ne' testato da chi ha scritto il file:  |
//|  compilare in MetaEditor (F7) e validare nel tester a tick.      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - cuore automatizzabile del metodo volumetrico DAX V5 di Claudio"
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
input group "=== VALUE AREA (profilo sessione PRECEDENTE, su tick-volume) ==="
input double InpVaPercent   = 70.0;   // % del volume nella Value Area (standard 70)
input double InpVaBinPts    = 5.0;    // Ampiezza del bin del profilo, in PUNTI INDICE (5 = ~40 bin su un range tipico DAX)

input group "=== MOTORI (selezionati dall'apertura vs Value Area, FASE 5) ==="
input bool   InpUseBalance  = true;   // Motore BALANCE (open dentro VA): fade dei bordi verso il POC
input bool   InpUseDirezion = true;   // Motore DIREZIONALE (open fuori VA): continuazione confermata
input int    InpAcceptBars  = 2;      // Barre di ACCETTAZIONE fuori dalla VA (la CONFERMA; 0 = rottura nuda, da battere)
input int    InpVaTouchTolPts = 200;  // Tolleranza tocco bordo per il fade BALANCE, in PUNTI MT5 (2 pti indice)

input group "=== SESSIONE (ORA DEL FEED/SERVER; DAX cash 08:00-16:30) ==="
input int    InpSessionHour = 8;      // Ora apertura seduta cash DAX (08:00 server = 09:00 IT)
input int    InpSessionMin  = 0;      // Minuto apertura seduta
input int    InpCloseHour   = 16;     // Ora del FLAT/chiusura cash DAX (16:30 server = 17:30 IT)
input int    InpCloseMin    = 30;     // Minuto del FLAT/chiusura

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlBufferPts = 300;    // SL oltre il bordo di riferimento, in PUNTI MT5 (3 pti indice)
input int    InpMinStopPts  = 500;    // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== GESTIONE (parziale + breakeven + runner) ==="
input double InpTP1_ClosePct     = 50.0;  // % chiusa al 1o target (POC per balance, meta' estensione per direz.). 0 = niente parziale
input bool   InpBreakevenAfterTP1= true;  // Dopo il parziale porta lo SL a pareggio (protegge il runner)
input double InpExtVaMult         = 1.0;  // Estensione DIREZIONALE oltre il bordo, in multipli della larghezza VA (finalTP = bordo +/- mult*VAwidth)

input group "=== USCITA ==="
input bool   InpCloseAtEnd  = true;   // FLAT a fine seduta cash DAX (ora server): zero overnight

input group "=== Rischio e cap ==="
input double InpRiskPercent     = 0.65;  // Rischio per trade, % del balance (default di casa)
input int    InpSide            = 2;     // Lato: 0=solo long, 1=solo short, 2=entrambi (censimento due lati)
input int    InpMaxTradesPerDay = 2;     // Max ingressi ESEGUITI al giorno (0 = illimitato)

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice = 100; // Punti MT5 (_Point) per 1 punto indice (US=100, DAX DA VERIFICARE - PASSO-0)

input group "=== Generali ==="
input string InpComment  = "DAXVA";   // Commento sugli ordini
input long   InpMagic    = 769600;    // Numero magico (verificato VERGINE nel repo)
input int    InpMaxSpread= 0;         // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose  = true;      // Messaggi nel log
input bool   InpAutoTest = true;      // Stampa le righe [DAXVA][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- Value Area CACHE della sessione PRECEDENTE. Ricalcolata ad ogni
//    nuova seduta (stamp diverso). NIENTE stato cross-day: al riavvio
//    gVaStamp=-1 forza la ricostruzione da CopyRates.
long   gVaStamp = -1;      // stamp della seduta ODIERNA per cui la VA e' valida
bool   gVaReady = false;
double gPOC = 0.0, gVAH = 0.0, gVAL = 0.0;
int    gVaBarrePrec = 0;   // barre usate per il profilo (diagnostica log)

//--- stato della posizione aperta (per il parziale/breakeven a barra chiusa)
ulong  gPosTicket   = 0;
bool   gPosIsLong   = false;
double gTP1Price    = 0.0;
bool   gPartialDone = false;
bool   gBEDone      = false;

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE cancello
//    ferma le barre. L'ordine QUI, in OnTester e nell'header di
//    OnTesterDeinit si toccano SEMPRE INSIEME.
long gCntOnNewBar     = 0;   // chiamate totali a OnNewBar
long gCntGestione     = 0;   // return: c'era posizione aperta (gestione uscita)
long gCntNoContesto   = 0;   // return: contesto (VA/seduta) non disponibile
long gCntPrimaBarra   = 0;   // return: pos<=0 (prima barra della seduta)
long gCntMaxTrades    = 0;   // return: cap trade/giorno raggiunto
long gCntFuoriSeduta  = 0;   // return: fuori seduta
long gCntSpread       = 0;   // return: spread non ok
long gCntBalanceReg   = 0;   // barre valutate in regime BALANCE
long gCntDirReg       = 0;   // barre valutate in regime DIREZIONALE
long gCntBalanceCand  = 0;   // candidati BALANCE (segnale != 0)
long gCntDirCand      = 0;   // candidati DIREZIONALE (accettazione ok)
long gCntApri         = 0;   // chiamate effettive ad ApriPosizione

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[DAXVA] ", m); }

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
//| raggiunto o superato l'ora di chiusura (confronto in minuti).     |
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

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109). Se lo stop e' piu' vicino del        |
//| pavimento, si ALLARGA al pavimento; non si salta il trade e non   |
//| si lascia lo stop a zero. pavimento<=0 -> invariato (ma il        |
//| chiamante garantisce > 0).                                        |
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
//| Indice del bin per un prezzo. bin0 parte da priceMin (bordo        |
//| basso). Prezzi fuori range vengono CLAMPATI ai bin estremi.       |
//| binW<=0 o nBins<=0 -> -1 (invalido).                              |
//+------------------------------------------------------------------+
int BinIndex_Calc(const double price,const double priceMin,
                  const double binW,const int nBins)
  {
   if(binW<=0 || nBins<=0) return(-1);
   int b = (int)MathFloor((price-priceMin)/binW);
   if(b<0)        b=0;
   if(b>nBins-1)  b=nBins-1;
   return(b);
  }

//+------------------------------------------------------------------+
//| COSTRUISCE IL VOLUME PROFILE. Ogni barra distribuisce il suo      |
//| TICK-VOLUME (proxy: il CFD non ha volume reale) in modo UNIFORME  |
//| su tutti i bin che il suo range [low,high] attraversa. Barra      |
//| senza tick -> peso minimo 1 (mai zero, come la VWAP dello         |
//| scaffold). binVols[] viene dimensionato a nBins e azzerato.       |
//+------------------------------------------------------------------+
bool CostruisciProfilo_Calc(const double &highs[],const double &lows[],const double &vols[],
                            const int n,const double priceMin,const double binW,
                            double &binVols[],const int nBins)
  {
   if(n<1 || nBins<1 || binW<=0) return(false);
   if(ArraySize(highs)<n || ArraySize(lows)<n || ArraySize(vols)<n) return(false);
   ArrayResize(binVols,nBins);
   ArrayInitialize(binVols,0.0);
   for(int i=0;i<n;i++)
     {
      double v = vols[i]; if(v<=0) v=1.0;      // peso minimo, mai zero
      int lo=BinIndex_Calc(lows[i], priceMin,binW,nBins);
      int hi=BinIndex_Calc(highs[i],priceMin,binW,nBins);
      if(lo<0 || hi<0) continue;
      if(hi<lo){ int t=lo; lo=hi; hi=t; }
      int span = hi-lo+1;
      double q = v/span;
      for(int b=lo;b<=hi;b++) binVols[b]+=q;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| VALUE AREA col metodo standard: si parte dal POC (bin col volume  |
//| massimo) e si ESPANDE aggiungendo di volta in volta il VICINO piu'|
//| pesante (sopra o sotto) finche' il volume accumulato raggiunge    |
//| vaFrac (0.70 = 70%) del totale. valBin = bin piu' basso della VA, |
//| vahBin = bin piu' alto. vaFrac fuori (0,1] o totale 0 -> false.   |
//+------------------------------------------------------------------+
bool ValueArea_Calc(const double &binVols[],const int nBins,const double vaFrac,
                    int &pocBin,int &valBin,int &vahBin)
  {
   pocBin=-1; valBin=-1; vahBin=-1;
   if(nBins<1 || vaFrac<=0 || vaFrac>1.0) return(false);
   if(ArraySize(binVols)<nBins) return(false);

   double total=0; int poc=0; double best=-1;
   for(int i=0;i<nBins;i++)
     {
      total += binVols[i];
      if(binVols[i]>best){ best=binVols[i]; poc=i; }
     }
   if(total<=0) return(false);

   double target = vaFrac*total;
   int    lo=poc, hi=poc;
   double acc=binVols[poc];
   while(acc<target && (lo>0 || hi<nBins-1))
     {
      double vAbove = (hi<nBins-1) ? binVols[hi+1] : -1.0;
      double vBelow = (lo>0)       ? binVols[lo-1] : -1.0;
      if(vAbove<0 && vBelow<0) break;               // niente piu' vicini
      if(vAbove>=vBelow){ hi++; acc+=binVols[hi]; } // il vicino sopra e' piu' pesante (o pari)
      else             { lo--; acc+=binVols[lo]; }  // il vicino sotto e' piu' pesante
     }
   pocBin=poc; valBin=lo; vahBin=hi;
   return(true);
  }

//+------------------------------------------------------------------+
//| FASE 5 - classifica l'apertura di OGGI rispetto alla Value Area.  |
//|   open > VAH -> +1 (direzionale rialzista)                        |
//|   open < VAL -> -1 (direzionale ribassista)                       |
//|   open in [VAL,VAH] -> 0 (BALANCE, rotazione)                     |
//+------------------------------------------------------------------+
int ClassificaApertura_Calc(const double open,const double val,const double vah)
  {
   if(vah<=val) return(0);          // VA degenere: nessuna direzione affidabile
   if(open>vah) return(+1);
   if(open<val) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| MOTORE BALANCE - fade dei bordi verso il POC. Sulla barra chiusa: |
//|   LONG  se ha toccato VAL (low<=VAL+tol) ed e' RIENTRATA dentro   |
//|         la VA (close tra VAL e VAH) -> rotazione dal basso.       |
//|   SHORT se ha toccato VAH (high>=VAH-tol) ed e' rientrata dentro  |
//|         la VA (close tra VAL e VAH) -> rotazione dall'alto.       |
//| Il close DEVE restare dentro la VA: e' un fade/rientro, non una   |
//| rottura. +1 long, -1 short, 0 niente/ambiguo.                     |
//+------------------------------------------------------------------+
int SegnaleBalance_Calc(const double barHigh,const double barLow,const double barClose,
                        const double val,const double vah,const double tol)
  {
   if(vah<=val) return(0);
   bool dentro    = (barClose>val && barClose<vah);
   bool longFade  = (barLow  <= val+tol) && dentro;
   bool shortFade = (barHigh >= vah-tol) && dentro;
   if(longFade==shortFade) return(0);     // nessuno o (difensivo) ambiguo
   return(longFade ? +1 : -1);
  }

//+------------------------------------------------------------------+
//| MOTORE DIREZIONALE - la CONFERMA (accettazione). Le ultime        |
//| acceptBars barre chiuse devono ACCETTARE fuori dalla VA: tutte    |
//| chiuse oltre il bordo rotto (sopra VAH se dirUp, sotto VAL se     |
//| dirDown). closes[0] = barra piu' recente. acceptBars<=0 = rottura |
//| NUDA (nessuna accettazione richiesta -> true, il baseline da      |
//| battere). Se non ci sono abbastanza barre -> false.               |
//+------------------------------------------------------------------+
bool AccettazioneOk_Calc(const double &closes[],const int nCloses,
                         const int acceptBars,const bool dirUp,const double edge)
  {
   if(acceptBars<=0) return(true);            // rottura nuda (0 = da battere)
   if(nCloses<acceptBars) return(false);
   if(ArraySize(closes)<acceptBars) return(false);
   for(int i=0;i<acceptBars;i++)
     {
      if(dirUp  && !(closes[i]>edge)) return(false);
      if(!dirUp && !(closes[i]<edge)) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| SL dei due motori (prezzo grezzo, prima del pavimento).           |
//|   BALANCE  long: sotto VAL (bordo fadato) ; short: sopra VAH.     |
//|   DIREZION long: dentro la VA sotto VAH (bordo rotto) ; short:    |
//|            dentro la VA sopra VAL.                                |
//+------------------------------------------------------------------+
double SlValueArea_Calc(const bool balance,const bool isLong,
                        const double vah,const double val,const double buffer)
  {
   if(balance)
      return(isLong ? val-buffer : vah+buffer);   // oltre il bordo fadato
   return(isLong ? vah-buffer : val+buffer);        // direzionale: dentro la VA, oltre il bordo rotto
  }

//+------------------------------------------------------------------+
//| TARGET dei due motori.                                            |
//|   BALANCE  -> tp1 = POC ; finalTP = bordo opposto (VAH long,      |
//|               VAL short).                                         |
//|   DIREZION -> estensione oltre il bordo rotto in multipli della   |
//|               larghezza VA: finalTP = bordo +/- mult*width ;      |
//|               tp1 = bordo +/- 0.5*mult*width (meta' strada).      |
//+------------------------------------------------------------------+
void Targets_Calc(const bool balance,const bool isLong,
                  const double poc,const double vah,const double val,
                  const double extMult,double &tp1,double &finalTP)
  {
   double width = vah-val; if(width<0) width=0;
   if(balance)
     {
      tp1     = poc;
      finalTP = isLong ? vah : val;
     }
   else
     {
      if(isLong){ double edge=vah; tp1=edge+0.5*extMult*width; finalTP=edge+extMult*width; }
      else      { double edge=val; tp1=edge-0.5*extMult*width; finalTP=edge-extMult*width; }
     }
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(!InpUseBalance && !InpUseDirezion)
     { Print("ERRORE: entrambi i motori (BALANCE e DIREZIONALE) spenti: l'EA non ha niente da fare."); return(INIT_FAILED); }
   if(InpVaPercent<=0.0 || InpVaPercent>=100.0)
     { Print("ERRORE: InpVaPercent deve stare in (0,100). Standard 70."); return(INIT_FAILED); }
   if(InpVaBinPts<=0.0)
     { Print("ERRORE: InpVaBinPts (ampiezza bin in punti indice) deve essere > 0."); return(INIT_FAILED); }
   if(InpAcceptBars<0)
     { Print("ERRORE: InpAcceptBars non puo' essere negativo (0 = rottura nuda)."); return(INIT_FAILED); }
   if(InpVaTouchTolPts<0)
     { Print("ERRORE: InpVaTouchTolPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpSide<0 || InpSide>2)
     { Print("ERRORE: InpSide deve essere 0 (long), 1 (short) o 2 (entrambi)."); return(INIT_FAILED); }
   if(InpSessionHour<0 || InpSessionHour>23 || InpSessionMin<0 || InpSessionMin>59)
     { Print("ERRORE: ora/minuto di apertura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
     { Print("ERRORE: ora/minuto di chiusura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin) >= MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin))
     { Print("ERRORE: la seduta cash DAX NON attraversa la mezzanotte: apertura deve precedere la chiusura."); return(INIT_FAILED); }
   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. Un breakout/fade sui
   //    bordi di Value Area entra dove il prezzo si muove: senza pavimento
   //    lo stop puo' finire dentro il rumore -> OnInit RIFIUTA se e' 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpTP1_ClosePct<0.0 || InpTP1_ClosePct>=100.0)
     { Print("ERRORE: InpTP1_ClosePct deve stare in [0,100). 0 = niente parziale."); return(INIT_FAILED); }
   if(InpExtVaMult<=0.0)
     { Print("ERRORE: InpExtVaMult (estensione direzionale) deve essere > 0."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }

   if(InpAutoTest) AutoTestValueArea();

   Log(StringFormat("avviato su %s %s. VA %.1f%% bin %.1f pti idx | motori[balance=%s,direz=%s] accept %d barre, tol fade %d pti MT5 | seduta %02d:%02d-%02d:%02d server | SL buffer %d + pavimento %d pti MT5 | rischio %.2f%%, side %d, cap %d/gg, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpVaPercent, InpVaBinPts,
       (InpUseBalance?"ON":"off"), (InpUseDirezion?"ON":"off"),
       InpAcceptBars, InpVaTouchTolPts,
       InpSessionHour, InpSessionMin, InpCloseHour, InpCloseMin,
       InpSlBufferPts, InpMinStopPts, InpRiskPercent, InpSide, InpMaxTradesPerDay, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione (motore INTRADAY, niente overnight). Ingresso SINGOLO: nessuna aggiunta/mediazione/griglia su posizione aperta.");
   Log("MURO DEL VOLUME: il profilo e' costruito su TICK-VOLUME (proxy), NON su volume scambiato reale. POC/VAH/VAL sono una FORMA di valore-accettato, mai il libro ordini.");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- nessun handle indicatore da rilasciare: la Value Area e la seduta
   //    sono ricostruite da CopyRates/CopyTickVolume, senza stato persistente.
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
//  LETTURA DEI DATI (aiutanti di sessione)
//==================================================================
int MinutiStartSeduta(){ return(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin)); }
int MinutiEndSeduta()  { return(MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin)); }

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
//  IL CONTESTO ODIERNO - apertura di seduta e barre chiuse recenti.
//  SENZA stato persistente (sopravvive a un riavvio).
//==================================================================
#define REC_MAX 64
struct Contesto
  {
   double sessOpen;             // apertura della seduta ODIERNA (open della prima barra di seduta)
   int    pos;                  // posizione della barra valutata nella seduta (0 = prima)
   double recClose[REC_MAX];    // close delle barre chiuse recenti, [0] = piu' recente (shift 1)
   int    recN;                 // quante ne ha riempite (tutte della stessa seduta)
  };

//+------------------------------------------------------------------+
//| Ricostruisce la seduta ODIERNA per la barra a shiftEval:          |
//| apertura, posizione nella seduta, e le close delle ultime barre   |
//| chiuse (per la CONFERMA di accettazione del direzionale).         |
//+------------------------------------------------------------------+
bool LeggiSeduta(const int shiftEval, Contesto &c)
  {
   c.sessOpen=0; c.pos=-1; c.recN=0;
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
   c.pos     = firstShift - shiftEval;      // 0 = prima barra della seduta
   c.sessOpen= r[firstShift].open;

   //--- close delle barre chiuse recenti, dalla piu' recente (shiftEval)
   //    verso il passato, tutte della stessa seduta. recClose[0]=shift1.
   c.recN=0;
   for(int i=shiftEval;i<=firstShift && c.recN<REC_MAX;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=stamp) break;
      c.recClose[c.recN]=r[i].close;
      c.recN++;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| VALUE AREA della sessione PRECEDENTE. Ricostruisce POC/VAH/VAL    |
//| dal profilo (tick-volume) della cash session del giorno prima.    |
//| CACHE per stamp odierno: si ricalcola SOLO quando cambia seduta.  |
//| Al riavvio gVaStamp=-1 -> ricostruzione. shiftEval = barra oggi.  |
//+------------------------------------------------------------------+
bool LeggiValueAreaPrecedente(const int shiftEval)
  {
   int  startMin = MinutiStartSeduta();

   //--- CACHE: se la barra valutata e' in seduta e la VA e' gia' calcolata
   //    per questa seduta, riuso senza ricopiare 8 giorni di barre ad ogni
   //    barra. iTime evita la CopyRates pesante nel caso comune. Al riavvio
   //    gVaStamp=-1 forza il ricalcolo (nessuno stato cross-day persistente).
   datetime tEval = iTime(_Symbol, gTF, shiftEval);
   if(tEval>0 && BarraInSeduta(tEval))
     {
      long todayStampFast = SessionStamp_Calc(tEval, startMin);
      if(gVaReady && gVaStamp==todayStampFast) return(true);
     }

   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 8*BarrePerGiornoPieno() + shiftEval + 5;   // ~8 giorni: copre weekend/feste
   if(need>20000) need=20000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<=shiftEval+1) return(false);
   if(!BarraInSeduta(r[shiftEval].time)) return(false);

   long todayStamp= SessionStamp_Calc(r[shiftEval].time, startMin);

   //--- CACHE (ricontrollo dopo la copia, difensivo).
   if(gVaReady && gVaStamp==todayStamp) return(true);

   //--- stamp della seduta PRECEDENTE: il piu' grande stamp < todayStamp
   //    tra le barre in FINESTRA di seduta (esclude notte/weekend).
   long prevStamp = -1;
   for(int i=shiftEval;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) continue;
      long s = SessionStamp_Calc(r[i].time,startMin);
      if(s<todayStamp && s>prevStamp) prevStamp=s;
     }
   if(prevStamp<0) return(false);            // nessuna seduta precedente disponibile

   //--- raccoglie le barre della seduta precedente (in finestra + stamp).
   double highs[]; double lows[]; double vols[];
   ArrayResize(highs,copied); ArrayResize(lows,copied); ArrayResize(vols,copied);
   int n=0;
   double pMin= DBL_MAX, pMax=-DBL_MAX;
   for(int i=shiftEval;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) continue;
      if(SessionStamp_Calc(r[i].time,startMin)!=prevStamp) continue;
      highs[n]=r[i].high; lows[n]=r[i].low; vols[n]=(double)r[i].tick_volume;
      if(r[i].high>pMax) pMax=r[i].high;
      if(r[i].low <pMin) pMin=r[i].low;
      n++;
     }
   if(n<5) return(false);                    // seduta precedente troppo corta per un profilo
   if(pMax<=pMin) return(false);

   //--- ampiezza bin in PREZZO: InpVaBinPts e' in PUNTI INDICE; la
   //    conversione a prezzo passa da InpMT5PerPuntoIndice * _Point.
   double binW = InpVaBinPts * InpMT5PerPuntoIndice * _Point;
   if(binW<=0) return(false);

   int nBins = (int)MathFloor((pMax-pMin)/binW) + 1;
   if(nBins<1) nBins=1;
   if(nBins>5000) nBins=5000;                // difensivo: bin troppo fine -> tetto

   double binVols[];
   if(!CostruisciProfilo_Calc(highs,lows,vols,n,pMin,binW,binVols,nBins)) return(false);

   int pocBin,valBin,vahBin;
   if(!ValueArea_Calc(binVols,nBins,InpVaPercent/100.0,pocBin,valBin,vahBin)) return(false);

   //--- prezzi dei livelli: POC = centro del bin di picco; VAL = bordo BASSO
   //    del bin piu' basso della VA; VAH = bordo ALTO del bin piu' alto.
   gPOC = pMin + (pocBin+0.5)*binW;
   gVAL = pMin +  valBin*binW;
   gVAH = pMin + (vahBin+1)*binW;
   gVaBarrePrec = n;
   gVaStamp = todayStamp;
   gVaReady = true;

   if(InpVerbose)
      Log(StringFormat("Value Area sessione prec. (stamp %I64d, %d barre): POC %s VAL %s VAH %s (larghezza %.1f pti idx).",
          prevStamp, n, DoubleToString(gPOC,_Digits), DoubleToString(gVAL,_Digits), DoubleToString(gVAH,_Digits),
          PrezzoInPuntiIndice_Calc(gVAH-gVAL,InpMT5PerPuntoIndice,_Point)));
   return(true);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valuta la barra APPENA CHIUSA      |
//| (shift 1); l'ordine parte al mercato all'apertura della barra 0.  |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   bool okVa  = LeggiValueAreaPrecedente(1);
   Contesto c;
   bool okSes = LeggiSeduta(1, c);

   //--- USCITE/GESTIONE della posizione aperta PRIMA di ogni cancello.
   if(CountPositions()>0)
     {
      gCntGestione++;
      GestisciPosizione();
      return;                                 // una posizione per magic
     }

   if(!okVa || !okSes || !gVaReady){ gCntNoContesto++; return; }  // contesto non pronto
   if(c.pos <= 0){ gCntPrimaBarra++; return; }                     // prima barra di seduta: mai ingresso
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!InSedutaOra(TimeCurrent())){ gCntFuoriSeduta++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }

   double barHigh = iHigh (_Symbol, gTF, 1);
   double barLow  = iLow  (_Symbol, gTF, 1);
   double barClose= iClose(_Symbol, gTF, 1);
   if(barHigh<=0 || barLow<=0 || barClose<=0){ gCntNoContesto++; return; }

   double tolPrezzo = InpVaTouchTolPts*_Point;

   //--- FASE 5: dove ha aperto OGGI rispetto alla Value Area di ieri?
   int regime = ClassificaApertura_Calc(c.sessOpen, gVAL, gVAH);

   //================= REGIME BALANCE (open dentro VA) =================
   if(regime==0)
     {
      gCntBalanceReg++;
      if(!InpUseBalance) return;
      int sig = SegnaleBalance_Calc(barHigh, barLow, barClose, gVAL, gVAH, tolPrezzo);
      if(sig==0) return;
      gCntBalanceCand++;
      bool isLong = (sig>0);
      if(!LatoAmmesso(isLong)) return;
      gCntApri++;
      ApriPosizione(isLong, true /*balance*/);
      return;
     }

   //================ REGIME DIREZIONALE (open fuori VA) ===============
   gCntDirReg++;
   if(!InpUseDirezion) return;
   bool dirUp = (regime>0);                 // open>VAH -> long ; open<VAL -> short
   double edge = dirUp ? gVAH : gVAL;        // il bordo rotto e' quello di accettazione
   if(!AccettazioneOk_Calc(c.recClose, c.recN, InpAcceptBars, dirUp, edge)) return;
   gCntDirCand++;
   if(!LatoAmmesso(dirUp)) return;
   gCntApri++;
   ApriPosizione(dirUp, false /*direzionale*/);
  }

//+------------------------------------------------------------------+
//| Filtro dei lati (censimento due lati). InpSide 0=long,1=short,    |
//| 2=entrambi.                                                       |
//+------------------------------------------------------------------+
bool LatoAmmesso(const bool isLong)
  {
   if(InpSide==0) return(isLong);
   if(InpSide==1) return(!isLong);
   return(true);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL secondo il motore (balance =     |
//| oltre il bordo fadato; direzionale = dentro la VA), poi SEMPRE    |
//| dal PAVIMENTO (R109, mai a zero, mai dentro lo stops-level). TP   |
//| finale = target del motore. Il lotto esce da LotByRisk sulla      |
//| distanza FINALE dello stop. tp1 (parziale) messo da parte per la  |
//| gestione a barra chiusa.                                          |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong, const bool balance)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlValueArea_Calc(balance, isLong, gVAH, gVAL, bufferPrezzo);

   //--- PAVIMENTO OBBLIGATORIO (R109): distanza mai piu' stretta del
   //    pavimento in punti MT5, e mai dentro lo stops-level del broker.
   double pavimento = InpMinStopPts*_Point;
   double minBroker = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double pavFinale = MathMax(pavimento, minBroker);
   if(pavFinale<=0)
     { Log("pavimento SL nullo: salto per non lasciare lo stop scoperto (R109)."); return(false); }

   double sl = PavimentoSL_Calc(isLong, ref, slRaw, pavFinale);
   sl = NormalizePrice(sl);
   double distSL = isLong ? (ref-sl) : (sl-ref);
   if(distSL<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- target del motore (tp1 parziale + finalTP runner)
   double tp1=0, finalTP=0;
   Targets_Calc(balance, isLong, gPOC, gVAH, gVAL, InpExtVaMult, tp1, finalTP);

   //--- TP al broker = finalTP (runner). Rispetta lo stops-level; se dal
   //    lato sbagliato o troppo vicino, si corregge/annulla (flat EOD
   //    protegge comunque il resto).
   double tp = finalTP;
   if(tp>0)
     {
      double distTP = isLong ? (tp-ref) : (ref-tp);
      if(distTP>0 && distTP<minBroker) tp = isLong ? ref+minBroker : ref-minBroker;
      if(distTP<=0) tp = 0;                    // target dal lato sbagliato: niente TP al broker
      if(tp>0) tp = NormalizePrice(tp);
     }

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_DaxValueArea")) return(false);

   string cm = InpComment + (balance?" B":" D") + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp,cm);
   if(ok)
     {
      //--- memorizza lo stato per la gestione a barra chiusa (parziale/BE)
      gPosTicket   = SelezionaMioTicket();
      gPosIsLong   = isLong;
      gTP1Price    = (tp1>0 ? NormalizePrice(tp1) : 0.0);
      gPartialDone = false;
      gBEDone      = false;

      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s %s MKT @ ~%s SL %s TP %s lot %.2f (rischio %.1f pti idx | POC %s VAL %s VAH %s | tp1 %s)",
          balance?"BALANCE":"DIREZIONALE", isLong?"BUY":"SELL",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          (tp>0?DoubleToString(tp,_Digits):"-"), lot, idxRisk,
          DoubleToString(gPOC,_Digits), DoubleToString(gVAL,_Digits), DoubleToString(gVAH,_Digits),
          (gTP1Price>0?DoubleToString(gTP1Price,_Digits):"-")));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  GESTIONE POSIZIONE (a BARRA CHIUSA): parziale al 1o target +
//  breakeven. Il runner corre al TP finale (ordine vero al broker) o
//  al flat di fine seduta. SL/TP al broker scattano intrabar da soli.
//==================================================================
void GestisciPosizione()
  {
   if(!SelezionaMiaPosizione()) return;

   ulong  ticket = (ulong)PositionGetInteger(POSITION_TICKET);
   long   type   = PositionGetInteger(POSITION_TYPE);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl     = PositionGetDouble(POSITION_SL);
   double tp     = PositionGetDouble(POSITION_TP);
   double vol    = PositionGetDouble(POSITION_VOLUME);
   bool   isLong = (type==POSITION_TYPE_BUY);

   //--- adozione dopo un riavvio: se lo stato RAM e' perso, il parziale si
   //    salta (gTP1Price=0) ma SL/TP al broker restano attivi.
   if(ticket!=gPosTicket)
     { gPosTicket=ticket; gPosIsLong=isLong; gTP1Price=0.0; gPartialDone=true; gBEDone=true; }

   //--- decide sulla barra APPENA CHIUSA (niente look-ahead).
   double barClose = iClose(_Symbol, gTF, 1);
   if(barClose<=0) return;

   //--- 1) PARZIALE al primo target (POC per balance, meta' estensione per
   //    direzionale). La percentuale 0 disattiva il parziale.
   if(!gPartialDone && InpTP1_ClosePct>0.0 && InpTP1_ClosePct<100.0 && gTP1Price>0.0)
     {
      bool reached = isLong ? (barClose>=gTP1Price) : (barClose<=gTP1Price);
      if(reached)
        {
         double closeVol = NormalizeVolume(vol*InpTP1_ClosePct/100.0);
         if(closeVol>0 && closeVol<vol)
           {
            if(gTrade.PositionClosePartial(ticket, closeVol))
               Log(StringFormat("1o target @ %s: chiusa parziale %.2f lotti.", DoubleToString(gTP1Price,_Digits), closeVol));
           }
         gPartialDone = true;

         //--- 2) BREAKEVEN dopo il parziale (FUORI dal ramo della chiusura:
         //    se al lotto minimo il parziale non parte, il BE va provato lo
         //    stesso -- lezione 07/08 dello scaffold DAX_Live5m).
         if(InpBreakevenAfterTP1 && !gBEDone)
           {
            double be = NormalizePrice(openP);
            if((isLong  && (be>sl || sl==0)) ||        // mai arretrare lo stop
               (!isLong && (be<sl || sl==0)))
               gTrade.PositionModify(_Symbol, be, tp);
            gBEDone = true;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Seleziona la posizione dell'EA (per simbolo+magic). true se c'e'. |
//+------------------------------------------------------------------+
bool SelezionaMiaPosizione()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return(true);   // PositionGetTicket ha gia' reso corrente la posizione
     }
   return(false);
  }

ulong SelezionaMioTicket()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      return(tk);
     }
   return(0);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   if(!InpCloseAtEnd) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpCloseHour,InpCloseMin)) return(false);

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
                          InpCloseHour, InpCloseMin, chiuse));
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

double NormalizeVolume(double vol)
  {
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   if(vol<=0) return(0);
   vol = MathFloor(vol/st)*st;
   if(vol<mn) return(0);          // sotto il minimo: il chiamante decide (parziale saltato)
   if(vol>mx) vol=mx;
   return(vol);
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
void AutoTestValueArea()
  {
   int falliti=0;

   PrintFormat("[DAXVA][AUTOTEST] VA %.1f%% bin %.1f | motori[balance=%s,direz=%s] accept %d | side %d | %s | magic %I64d",
               InpVaPercent, InpVaBinPts,
               (InpUseBalance?"ON":"off"), (InpUseDirezion?"ON":"off"),
               InpAcceptBars, InpSide, _Symbol, InpMagic);

   //--- 1. BIN INDEX (clamp fuori range)
   int b1=BinIndex_Calc(102.0,100.0,1.0,10);   // (102-100)/1 = 2
   int b2=BinIndex_Calc( 90.0,100.0,1.0,10);   // sotto -> 0
   int b3=BinIndex_Calc(999.0,100.0,1.0,10);   // sopra -> 9
   int b4=BinIndex_Calc(100.0,100.0,0.0,10);   // binW 0 -> -1
   PrintFormat("[DAXVA][AUTOTEST] bin: mid=%d(2) sotto=%d(0) sopra=%d(9) binW0=%d(-1)", b1,b2,b3,b4);
   if(!(b1==2 && b2==0 && b3==9 && b4==-1)) falliti++;

   //--- 2. PROFILO + VALUE AREA. Costruisco un profilo a campana su bin
   //    di 1.0 da priceMin 100. Tre barre "strette" concentrano il volume
   //    attorno a 105; due barre larghe spargono poco volume ai lati.
   double H[5], L[5], V[5];
   H[0]=105.5; L[0]=105.0; V[0]=100;   // bin ~5 (105) pesante
   H[1]=105.5; L[1]=105.0; V[1]=100;   // bin ~5 pesante
   H[2]=106.5; L[2]=106.0; V[2]= 40;   // bin ~6
   H[3]=104.5; L[3]=104.0; V[3]= 40;   // bin ~4
   H[4]=110.0; L[4]=100.0; V[4]= 20;   // barra larga: 1 su ogni bin 0..10
   double bins[];
   bool okP=CostruisciProfilo_Calc(H,L,V,5,100.0,1.0,bins,11);
   int poc,val,vah;
   bool okV=ValueArea_Calc(bins,11,0.70,poc,val,vah);
   //    il POC deve stare sul bin 5 (105), e la VA racchiuderlo (val<=5<=vah)
   PrintFormat("[DAXVA][AUTOTEST] profilo ok=%d va ok=%d | POC bin=%d(5) VAL bin=%d VAH bin=%d (val<=5<=vah)",
               (int)okP,(int)okV,poc,val,vah);
   if(!(okP && okV && poc==5 && val<=5 && vah>=5 && val<=vah)) falliti++;

   //--- 2b. VA degenere (totale 0 -> false ; frazione fuori range -> false)
   double z[3]; z[0]=0; z[1]=0; z[2]=0;
   int pz,vz,hz;
   bool okZ=ValueArea_Calc(z,3,0.70,pz,vz,hz);      // totale 0 -> false
   bool okF=ValueArea_Calc(bins,11,1.5,pz,vz,hz);   // frazione >1 -> false
   PrintFormat("[DAXVA][AUTOTEST] VA degenere: tot0=%d(0) frac1.5=%d(0)", (int)okZ,(int)okF);
   if(!(!okZ && !okF)) falliti++;

   //--- 3. FASE 5 - classificazione apertura vs VA (VAL 100, VAH 110)
   int f1=ClassificaApertura_Calc(112.0,100.0,110.0);  // sopra VAH -> +1
   int f2=ClassificaApertura_Calc( 95.0,100.0,110.0);  // sotto VAL -> -1
   int f3=ClassificaApertura_Calc(105.0,100.0,110.0);  // dentro   ->  0
   int f4=ClassificaApertura_Calc(105.0,110.0,100.0);  // VA degenere -> 0
   PrintFormat("[DAXVA][AUTOTEST] fase5: sopra=%d(1) sotto=%d(-1) dentro=%d(0) degenere=%d(0)", f1,f2,f3,f4);
   if(!(f1==1 && f2==-1 && f3==0 && f4==0)) falliti++;

   //--- 4. BALANCE - fade dei bordi (VAL 100, VAH 110, tol 0.5)
   //    long: tocca VAL (low 99.8) e rientra (close 101) dentro la VA
   int g1=SegnaleBalance_Calc(102.0, 99.8,101.0, 100.0,110.0,0.5);   // +1
   //    short: tocca VAH (high 110.3) e rientra (close 109)
   int g2=SegnaleBalance_Calc(110.3,108.0,109.0, 100.0,110.0,0.5);   // -1
   //    tocca VAL ma close FUORI (98) -> non e' rientro -> 0
   int g3=SegnaleBalance_Calc( 99.0, 98.0, 98.0, 100.0,110.0,0.5);   // 0
   //    barra centrale, nessun bordo toccato -> 0
   int g4=SegnaleBalance_Calc(106.0,104.0,105.0, 100.0,110.0,0.5);   // 0
   PrintFormat("[DAXVA][AUTOTEST] balance: longVAL=%d(1) shortVAH=%d(-1) closeFuori=%d(0) centro=%d(0)", g1,g2,g3,g4);
   if(!(g1==1 && g2==-1 && g3==0 && g4==0)) falliti++;

   //--- 5. DIREZIONALE - la CONFERMA (accettazione oltre il bordo)
   double cU[3]; cU[0]=111; cU[1]=110.5; cU[2]=110.2;   // tutte > 110 (edge VAH)
   double cM[3]; cM[0]=109; cM[1]=110.5; cM[2]=110.2;   // la piu' recente NON accetta
   bool a0=AccettazioneOk_Calc(cU,3,0,true,110.0);      // acceptBars 0 -> rottura nuda true
   bool a1=AccettazioneOk_Calc(cU,3,2,true,110.0);      // 2 barre accettano -> true
   bool a2=AccettazioneOk_Calc(cM,3,2,true,110.0);      // la recente sotto -> false
   bool a3=AccettazioneOk_Calc(cU,1,2,true,110.0);      // barre insufficienti -> false
   double cD[2]; cD[0]=99; cD[1]=98;                    // tutte < 100 (edge VAL)
   bool a4=AccettazioneOk_Calc(cD,2,2,false,100.0);     // dirDown accetta -> true
   PrintFormat("[DAXVA][AUTOTEST] accettazione: nuda=%d(1) due=%d(1) recFuori=%d(0) poche=%d(0) down=%d(1)",
               (int)a0,(int)a1,(int)a2,(int)a3,(int)a4);
   if(!(a0 && a1 && !a2 && !a3 && a4)) falliti++;

   //--- 6. SL dei due motori + PAVIMENTO (R109)
   double slBl=SlValueArea_Calc(true ,true ,110.0,100.0,0.5);  // balance long -> VAL-0.5 = 99.5
   double slBs=SlValueArea_Calc(true ,false,110.0,100.0,0.5);  // balance short -> VAH+0.5 = 110.5
   double slDl=SlValueArea_Calc(false,true ,110.0,100.0,0.5);  // direz long -> VAH-0.5 = 109.5 (dentro VA)
   double slDs=SlValueArea_Calc(false,false,110.0,100.0,0.5);  // direz short -> VAL+0.5 = 100.5 (dentro VA)
   double pv1=PavimentoSL_Calc(true ,100.0, 99.8,2.0);         // dist 0.2 < 2 -> 98.00
   double pv2=PavimentoSL_Calc(false,100.0,100.2,2.0);         // short -> 102.00
   PrintFormat("[DAXVA][AUTOTEST] SL: Bl=%.2f(99.50) Bs=%.2f(110.50) Dl=%.2f(109.50) Ds=%.2f(100.50) | pav %.2f(98.00) %.2f(102.00)",
               slBl,slBs,slDl,slDs,pv1,pv2);
   if(!(MathAbs(slBl-99.5)<1e-6 && MathAbs(slBs-110.5)<1e-6 &&
        MathAbs(slDl-109.5)<1e-6 && MathAbs(slDs-100.5)<1e-6 &&
        MathAbs(pv1-98.0)<1e-6 && MathAbs(pv2-102.0)<1e-6)) falliti++;

   //--- 7. TARGET dei due motori (POC 105, VAH 110, VAL 100, mult 1.0)
   double t1a,t1b,t2a,t2b,t3a,t3b,t4a,t4b;
   Targets_Calc(true ,true ,105.0,110.0,100.0,1.0,t1a,t1b);   // balance long: tp1 POC 105, final VAH 110
   Targets_Calc(true ,false,105.0,110.0,100.0,1.0,t2a,t2b);   // balance short: tp1 105, final VAL 100
   Targets_Calc(false,true ,105.0,110.0,100.0,1.0,t3a,t3b);   // direz long: width 10, edge VAH 110 -> tp1 115, final 120
   Targets_Calc(false,false,105.0,110.0,100.0,1.0,t4a,t4b);   // direz short: edge VAL 100 -> tp1 95, final 90
   PrintFormat("[DAXVA][AUTOTEST] target: Blong tp1=%.1f(105) fin=%.1f(110) | Bshort tp1=%.1f(105) fin=%.1f(100) | Dlong tp1=%.1f(115) fin=%.1f(120) | Dshort tp1=%.1f(95) fin=%.1f(90)",
               t1a,t1b,t2a,t2b,t3a,t3b,t4a,t4b);
   if(!(MathAbs(t1a-105)<1e-6 && MathAbs(t1b-110)<1e-6 &&
        MathAbs(t2a-105)<1e-6 && MathAbs(t2b-100)<1e-6 &&
        MathAbs(t3a-115)<1e-6 && MathAbs(t3b-120)<1e-6 &&
        MathAbs(t4a-95)<1e-6  && MathAbs(t4b-90)<1e-6)) falliti++;

   //--- 8. SEDUTA / STAMP / FLAT / conversione punti (DAX 08:00-16:30 server)
   int mS=MinutiDelGiorno_Calc(8,0), mE=MinutiDelGiorno_Calc(16,30);
   bool se1=InSeduta_Calc(MinutiDelGiorno_Calc( 8, 0),mS,mE);  // apertura inclusa
   bool se2=InSeduta_Calc(MinutiDelGiorno_Calc(12, 0),mS,mE);  // dentro
   bool se3=InSeduta_Calc(MinutiDelGiorno_Calc(16,30),mS,mE);  // chiusura esclusa
   bool se4=InSeduta_Calc(MinutiDelGiorno_Calc( 7,55),mS,mE);  // prima dell'apertura
   bool fl1=DopoOrarioFlat_Calc(16,30,16,30);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(16,29,16,30);   // prima -> no
   datetime tA=D'2026.08.25 10:00:00';
   datetime tB=D'2026.08.25 14:00:00';
   datetime tC=D'2026.08.26 10:00:00';
   bool sm1=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tB,mS));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tC,mS));  // diverse
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.0
   PrintFormat("[DAXVA][AUTOTEST] seduta: apert=%d(1) dentro=%d(1) fine=%d(0) pre=%d(0) | flat esatto=%d(1) prima=%d(0) | stamp same=%d(1) diff=%d(0) | conv=%.2f(5.00)",
               (int)se1,(int)se2,(int)se3,(int)se4,(int)fl1,(int)fl2,(int)sm1,(int)sm2,ip1);
   if(!(se1 && se2 && !se3 && !se4 && fl1 && !fl2 && sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[DAXVA][AUTOTEST] esito motore: ", (falliti==0
         ? "OTTO BLOCCHI SU OTTO, il motore ragiona come la spec."
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
   double stats[25];
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
   stats[14] = (double)gCntGestione;       // Ret Gestione
   stats[15] = (double)gCntNoContesto;     // Ret No Contesto
   stats[16] = (double)gCntPrimaBarra;     // Ret Prima Barra
   stats[17] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[18] = (double)gCntFuoriSeduta;    // Ret Fuori Seduta
   stats[19] = (double)gCntBalanceReg;     // Regime Balance
   stats[20] = (double)gCntDirReg;         // Regime Direzionale
   stats[21] = (double)gCntBalanceCand;    // Balance Cand
   stats[22] = (double)gCntDirCand;        // Direz Cand
   stats[23] = (double)gCntApri;           // Apri Chiamate
   stats[24] = (double)gCntSpread;         // Ret Spread

   PrintFormat("[DAXVA][DIAG] OnNewBar=%I64d | ret: gestione=%I64d noContesto=%I64d primaBarra=%I64d maxTrades=%I64d fuoriSeduta=%I64d spread=%I64d | regimi: balance=%I64d direz=%I64d | cand: balance=%I64d direz=%I64d | apri=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoContesto, gCntPrimaBarra,
               gCntMaxTrades, gCntFuoriSeduta, gCntSpread,
               gCntBalanceReg, gCntDirReg, gCntBalanceCand, gCntDirCand, gCntApri);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret No Contesto,Ret Prima Barra,Ret Max Trades,Ret Fuori Seduta,Regime Balance,Regime Direzionale,Balance Cand,Direz Cand,Apri Chiamate,Ret Spread";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23], data[24]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
