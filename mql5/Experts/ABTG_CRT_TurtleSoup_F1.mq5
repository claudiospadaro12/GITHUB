//+------------------------------------------------------------------+
//|                                          ABTG_CRT_TurtleSoup.mq5  |
//|                                                                  |
//|  Motore CRT Turtle Soup da Neo Malesa (n30dyn4m1c), licenza MIT. |
//|  Fonte: https://github.com/n30dyn4m1c/crt-turtlesoup-ea          |
//|                                                                  |
//|  MOTORE CRT TURTLE SOUP - MT5 - TUTTO-IN-UNO                     |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  COS'E' - un motore di REVERSAL su falsa rottura (turtle soup).  |
//|    Quando una candela spazza il minimo (o massimo) della candela |
//|    precedente e poi RICHIUDE dentro il range con un lungo wick di |
//|    rifiuto (>= Kx il corpo), la rottura era falsa: liquidita'     |
//|    presa, non continuazione. Si entra nel verso OPPOSTO (fade     |
//|    strutturato), con SL all'estremo del wick e target al centro / |
//|    estremo del range spazzato. Il wick di rifiuto e il gate del   |
//|    50% SONO la strategia, non un cerotto.                         |
//|                                                                  |
//|  IL PATTERN A 3 CANDELE (barre CHIUSE, niente repaint):          |
//|    C2 = candela range (riferimento)  = shift 2                   |
//|    C1 = falsa rottura (TS candle)    = shift 1                   |
//|    C0 = entry all'open               = shift 0 (barra che apre)  |
//|    LONG : low(C1) < low(C2) && close(C1) > close(C2), con        |
//|           lowerWick(C1) >= InpWickFactor * body(C1). C2 ribassista|
//|           e C1 rialzista (da CRTTS_M15.mq5 righe 90-108).         |
//|    SHORT: specchiato (high(C1) > high(C2) && close(C1)<close(C2), |
//|           upperWick(C1) >= InpWickFactor * body(C1)).            |
//|    Entry = open(C0) a MERCATO.                                   |
//|    SL   = estremo del wick di C1 (low(C1) long / high(C1) short) |
//|           + PAVIMENTO InpMinStopPts (R109).                      |
//|    TP1  = punto medio di C2 = (low2+high2)/2 (parziale).         |
//|    TP2  = estremo opposto di C2 (high2 long / low2 short, runner)|
//|                                                                  |
//|  GATE DEL 50% (InpUseMidGate): porta ESATTAMENTE la logica       |
//|    MidNotReached di crt-ts.mq5. In quel sorgente r[0] e' la barra |
//|    di segnale (qui C1) e r[1] la barra precedente (qui C2):       |
//|      Bull: mid=(C2.high+C2.low)/2 ; passa se C1.high < mid.       |
//|      Bear: mid=(C2.high+C2.low)/2 ; passa se C1.low  > mid.       |
//|    Il gate chiede che la barra di falsa rottura sia rimasta oltre |
//|    meta' del range spazzato (sweep profondo, non semplice tocco). |
//|                                                                  |
//|  GESTIONE NOSTRA sopra il segnale:                               |
//|    - parziale a TP1 (InpTP1_ClosePct %),                         |
//|    - breakeven DOPO il parziale (SL a pareggio, una volta sola), |
//|    - runner verso TP2 (TP vero al broker).                       |
//|                                                                  |
//|  PROP-HARDENING (obbligatorio, contratto di casa)               |
//|    - STOP LOSS VERO AL BROKER, mai una regola a sola chiusura     |
//|      barra: ordine di stop sul server. PAVIMENTO SL OBBLIGATORIO  |
//|      (R109): InpMinStopPts, MAI zero -> OnInit RIFIUTA se <= 0.   |
//|    - SIZING A RISCHIO (LotByRisk), rischio 0.65% di casa.         |
//|    - NIENTE martingala/griglia/recovery/DCA/averaging/hedging-di- |
//|      motore/virtual-stop: ingresso SINGOLO, una posizione per     |
//|      magic, nessuna aggiunta su posizione aperta.                |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay).                       |
//|    - FLAT OBBLIGATORIO a fine seduta (ora del FEED): mai overnight|
//|    - EXPORT PER-TRADE CSV + OnTester (recovery factor). AUTOTEST  |
//|      del nucleo in avvio.                                        |
//|                                                                  |
//|  ORARI: SEMPRE ORA DEL FEED. Su D30EUR/U30USD/NASUSD il feed E'   |
//|  l'ora server BCM. InpCloseHour/InpCloseMin vanno messi in ora    |
//|  server del simbolo.                                            |
//|                                                                  |
//|  CONVERSIONE PUNTI: su indici US 1 punto indice = 100 punti MT5   |
//|  (_Point) (R97). Le distanze operative (buffer SL, pavimento)     |
//|  sono in PUNTI MT5; InpMT5PerPuntoIndice serve all'export/log.    |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA (C1/C2 a shift 1/2). L'ordine parte   |
//|  all'apertura di C0. Niente look-ahead, niente repaint.          |
//|                                                                  |
//|  Un solo simbolo per grafico (NON il loop multi-symbol           |
//|  dell'originale). DEMO. Nessuna garanzia. ASCII puro dentro le    |
//|  stringhe (regola di casa). NON compilato ne' testato da chi ha   |
//|  scritto il file: compilare in MetaEditor (F7) e validare nel     |
//|  tester.                                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - motore CRT Turtle Soup (Neo Malesa, MIT)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== SEGNALE CRT TURTLE SOUP (griglia congelata) ==="
input double InpWickFactor       = 3.0;   // Wick di rifiuto di C1 >= Kx il corpo (griglia)
input int    InpUseMidGate       = 1;     // Gate del 50% MidNotReached (1=ON, 0=OFF) (griglia)
input int    InpSide             = 2;     // Lato: 0=solo long, 1=solo short, 2=entrambi (griglia)

input group "=== GATE DI REGIME (costitutivo, opzionale; default OFF = originale) ==="
input bool           InpUseRegimeGate   = false;       // Gate ON/OFF. false = EA IDENTICO a oggi (nessun controllo)
input ENUM_TIMEFRAMES InpRegimeTF       = PERIOD_D1;   // TF su cui si misura il regime (barra CHIUSA, shift 1)
input int            InpRegimeAdxPeriod = 14;          // Periodo ADX del gate
input double         InpAdxMax          = 30.0;        // Opera SOLO se ADX(InpRegimeTF) <= questo (NON trend/crollo forte)
input int            InpRegimeAtrPeriod = 14;          // Periodo ATR del gate
input double         InpAtrMinPts       = 0.0;         // Opera SOLO se ATR(InpRegimeTF) in PUNTI INDICE >= questo (0 = neutro)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpSlBufferPts      = 0;     // Buffer oltre l'estremo del wick di C1, in PUNTI MT5 (0 = estremo esatto)
input int    InpMinStopPts       = 500;   // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice US). MAI 0.

input group "=== GESTIONE (parziale TP1 + breakeven + runner TP2) ==="
input double InpTP1_ClosePct     = 50.0;  // Percentuale chiusa a TP1 (mid range di C2). Resto verso TP2.
input bool   InpBreakevenAfterTP1= true;  // Dopo il parziale porta lo SL a pareggio (una volta sola)

input group "=== FLAT DI FINE SEDUTA (ora del FEED; mai overnight) ==="
input bool   InpCloseAtEnd       = true;  // Chiudi tutto a fine seduta (niente overnight)
input int    InpCloseHour        = 22;    // Ora del FLAT (ora del FEED/server del simbolo)
input int    InpCloseMin         = 0;     // Minuto del FLAT

input group "=== Rischio e cap ==="
input double InpRiskPercent      = 0.65;  // Rischio per trade, % dell'equity (default di casa)
input int    InpMaxTradesPerDay  = 3;     // Max ingressi ESEGUITI al giorno (0 = illimitato)

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice= 100;   // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment          = "CRTTS"; // Commento sugli ordini
input long   InpMagic            = 769100;  // Numero magico (verificato VERGINE nel repo)
input int    InpMaxSpread        = 0;       // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose          = true;    // Messaggi nel log
input bool   InpAutoTest         = true;    // Stampa le righe [CRTTS][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico

//--- NIENTE handle iADX/iATR sul TF di regime: nel tester TICK su simbolo
//    NATIVO gli handle MTF non popolano (BarsCalculated<2 / CopyBuffer fallisce
//    sempre) e il gate bloccava TUTTO per dato-mancante. Il regime si calcola
//    a mano dalle barre lette con CopyRates. MISURATO POI: nel tester tick su
//    NASUSD nativo NEMMENO CopyRates(D1) consegna barre (0 trade, 2573 pattern
//    soppressi, anche con soglie sempre-vere). Percio' ora c'e' una SECONDA
//    VIA, autosufficiente: se il TF di regime non consegna, le giornate si
//    COSTRUISCONO aggregando le barre del TF del GRAFICO (che nel tester ci
//    sono sempre, e' il TF di test). Vedi LeggiBarreRegime()/
//    LeggiGiorniDaGrafico()/RegimeGateOk().

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;
ulong    gUltimoTicketContato = 0;      // conta gli ingressi ESEGUITI, non gli ordini
int      gFlatLogGiorno = -1;           // il flat scrive UNA riga al giorno

//--- stato della posizione aperta per la GESTIONE (parziale + breakeven).
//    Si perde a un riavvio a meta' trade: la posizione resta comunque
//    protetta da SL e TP2 VERI al broker (fail-safe, come lo scaffold).
ulong    gPosTicket   = 0;
bool     gIsLong      = false;
double   gEntryPrice  = 0.0;
double   gTP1Price    = 0.0;
double   gTP2Price    = 0.0;
bool     gPartialDone = false;

//--- contatori che escono IN COLONNA nell'OPTFRAME (OnTester).
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;    // giornate in cui il flat e' scattato
int      gFlatChiusure    = 0;    // posizioni chiuse dal flat

//--- DIAGNOSTICA (SOLO MISURA): un contatore per ogni cancello di
//    OnNewBar. Escono IN COLONNA nell'OPTFRAME per capire QUALE cancello
//    ferma le barre.
long gCntOnNewBar     = 0;   // chiamate totali a OnNewBar
long gCntGestione     = 0;   // return: c'era posizione aperta (gestione)
long gCntNoDati       = 0;   // return: storico insufficiente
long gCntMaxTrades    = 0;   // return: cap trade/giorno raggiunto
long gCntFuoriOrario  = 0;   // return: oltre l'orario di flat
long gCntSpread       = 0;   // return: spread non ok
long gCntNoPattern    = 0;   // return: nessun pattern CRT
long gCntGateBloccati = 0;   // return: pattern valido SOPPRESSO dal gate di regime
long gCntLongCand     = 0;   // candidati LONG
long gCntShortCand    = 0;   // candidati SHORT
long gCntApri         = 0;   // chiamate effettive ad ApriPosizione

//--- GATE DI REGIME: da QUALE via e' arrivato il dato. Escono IN COLONNA
//    nell'OPTFRAME. Se "Via D1" e' 0 e "Via M15" e' > 0, il tester NON
//    serviva il TF di regime e il fallback ha salvato la corsa; se sono
//    ZERO ENTRAMBI e "Ret Gate Regime" e' alto, il dato non arriva da
//    nessuna delle due vie (allora si guardano le righe [GATE-DIAG]).
long gGateViaD1  = 0;        // valutazioni RIUSCITE col TF di regime diretto
long gGateViaM15 = 0;        // valutazioni RIUSCITE col fallback aggregato dal grafico

//--- fotografia dell'ULTIMA lettura del regime, per le righe [GATE-DIAG].
//    Riempita da LeggiBarreRegime()/LeggiGiorniDaGrafico(): sono SOLO
//    misura, non entrano in nessuna decisione.
int gDiagGotTF   = 0;        // ritorno di CopyRates sul TF di regime
int gDiagErrTF   = 0;        // GetLastError() SUBITO dopo quel CopyRates
int gDiagGotBar  = 0;        // barre del TF del GRAFICO copiate dal fallback
int gDiagErrBar  = 0;        // GetLastError() subito dopo quel CopyRates
int gDiagGiorni  = 0;        // giorni COMPLETI aggregati dal fallback
int gDiagVia     = 0;        // 0 = nessuna via, 1 = TF diretto, 2 = fallback aggregato

//--- metriche da prop: la peggior giornata in % (numero negativo).
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[CRTTS] ", m); }

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
//| IL SEGNALE CRT TURTLE SOUP - il cuore del motore.                 |
//| Valuta le due barre chiuse C1 (falsa rottura, shift 1) e C2       |
//| (range, shift 2). Ritorna +1 = LONG (fade di uno sweep del minimo |
//| di C2), -1 = SHORT (sweep del massimo di C2), 0 = niente.         |
//|                                                                  |
//| Pattern base da CRTTS_M15.mq5 righe 90-108 (close-vs-close di C2  |
//| + colore delle candele + wick di rifiuto). Il gate del 50' e' la  |
//| logica MidNotReached di crt-ts.mq5 (C1.high < mid(C2) per il long,|
//| C1.low > mid(C2) per lo short): il wick di rifiuto NON deve aver  |
//| ripreso oltre meta' del range spazzato.                          |
//|                                                                  |
//| side: 0=solo long, 1=solo short, 2=entrambi.                     |
//+------------------------------------------------------------------+
int SegnaleCRT_Calc(
   const double o1,const double c1,const double h1,const double l1,   // C1 = falsa rottura
   const double o2,const double c2,const double h2,const double l2,   // C2 = range
   const double wickFactor,const bool useMidGate,const int side)
  {
   double body1 = MathAbs(c1-o1);
   if(body1<=0) return(0);                       // senza corpo il rapporto wick/corpo non esiste

   double lowerWick1 = MathMin(o1,c1) - l1;
   double upperWick1 = h1 - MathMax(o1,c1);
   double mid2       = (h2 + l2)*0.5;

   //--- LONG: C2 ribassista, C1 rialzista che buca il minimo di C2 e
   //    richiude sopra la chiusura di C2, con lungo wick INFERIORE.
   bool c2Bear  = (c2 < o2);
   bool c1Bull  = (c1 > o1);
   bool longPat = c2Bear && c1Bull && (l1 < l2) && (c1 > c2) &&
                  (lowerWick1 >= wickFactor*body1);
   if(useMidGate) longPat = longPat && (h1 < mid2);   // MidNotReachedBull (crt-ts.mq5)

   //--- SHORT: specchiato.
   bool c2Bull   = (c2 > o2);
   bool c1Bear   = (c1 < o1);
   bool shortPat = c2Bull && c1Bear && (h1 > h2) && (c1 < c2) &&
                   (upperWick1 >= wickFactor*body1);
   if(useMidGate) shortPat = shortPat && (l1 > mid2);  // MidNotReachedBear (crt-ts.mq5)

   if(longPat && shortPat) return(0);            // difensivo: mai entrambi, ma non si tira a indovinare

   if(longPat  && (side==0 || side==2)) return(+1);
   if(shortPat && (side==1 || side==2)) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| SL grezzo all'estremo del wick di C1, di un buffer.               |
//|   long -> low(C1) - buffer ; short -> high(C1) + buffer           |
//+------------------------------------------------------------------+
double SlWick_Calc(const bool isLong,const double l1,const double h1,const double buffer)
  {
   return(isLong ? l1-buffer : h1+buffer);
  }

//+------------------------------------------------------------------+
//| TP1 = punto medio del range di C2.                                |
//+------------------------------------------------------------------+
double Tp1Mid_Calc(const double h2,const double l2)
  {
   return((h2 + l2)*0.5);
  }

//+------------------------------------------------------------------+
//| TP2 = estremo OPPOSTO di C2 (il runner).                          |
//|   long -> high(C2) ; short -> low(C2)                             |
//+------------------------------------------------------------------+
double Tp2Ext_Calc(const bool isLong,const double h2,const double l2)
  {
   return(isLong ? h2 : l2);
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

//+------------------------------------------------------------------+
//| GATE DI REGIME - nucleo puro. Passa (true = si puo' operare) SOLO |
//| se ENTRAMBE: ADX <= adxMax (regime NON fortemente direzionale,    |
//| esclude crollo e trend liscio forte) E ATR in PUNTI INDICE >=     |
//| atrMinPts (abbastanza range da fadare, esclude il toro calmo).    |
//| E' la traduzione della lettura per regime: il CRT e' una          |
//| mean-reversion da chop/range bilaterale.                          |
//+------------------------------------------------------------------+
bool RegimeGate_Calc(const double adx,const double atrPts,
                     const double adxMax,const double atrMinPts)
  {
   return(adx <= adxMax && atrPts >= atrMinPts);
  }

//+------------------------------------------------------------------+
//| ATR - nucleo puro. MEDIA dei True Range su 'period' barre.        |
//| Serie CRONOLOGICA (indice 0 = piu' vecchia, n-1 = piu' recente).  |
//| TR(i) = max(high-low, |high-close_prev|, |low-close_prev|).       |
//| Servono period+1 barre (ogni TR usa la chiusura precedente). Usa  |
//| gli ULTIMI 'period' TR (indici n-period..n-1). Ritorna -1 se i    |
//| dati non bastano (SOLO a inizio storia). Valore in PREZZO.        |
//+------------------------------------------------------------------+
double AtrMedia_Calc(const double &high[],const double &low[],const double &close[],
                     const int n,const int period)
  {
   if(period<=0) return(-1.0);
   if(n < period+1) return(-1.0);
   double somma=0.0;
   for(int i=n-period; i<n; i++)
     {
      double tr = MathMax(high[i]-low[i],
                          MathMax(MathAbs(high[i]-close[i-1]),
                                  MathAbs(low[i]-close[i-1])));
      somma += tr;
     }
   return(somma/period);
  }

//+------------------------------------------------------------------+
//| ADX di WILDER - nucleo puro. Calcolato dalle barre del TF di      |
//| regime (stessa scala 0-100 dell'iADX main line, buffer 0).        |
//| Serie CRONOLOGICA (indice 0 = piu' vecchia, n-1 = piu' recente).  |
//|   +DM/-DM da high/low, TR di Wilder, smoothing di Wilder su TR e   |
//|   DM, +DI/-DI, DX = 100*|+DI - -DI|/(+DI + -DI), ADX = media di    |
//|   Wilder del DX. Ritorna l'ADX sull'ultima barra (n-1).           |
//| Servono almeno 2*period+1 barre (period per il primo DI + period  |
//| DX per la prima media). Ritorna -1 se i dati non bastano.         |
//+------------------------------------------------------------------+
double AdxWilder_Calc(const double &high[],const double &low[],const double &close[],
                      const int n,const int period)
  {
   if(period<=0) return(-1.0);
   if(n < 2*period+1) return(-1.0);

   int m = n-1;                       // valori TR/+DM/-DM: uno per ogni barra i=1..n-1
   double tr[],plusDM[],minusDM[];
   ArrayResize(tr,m); ArrayResize(plusDM,m); ArrayResize(minusDM,m);
   for(int i=1;i<n;i++)
     {
      int j=i-1;
      double up = high[i]-high[i-1];
      double dn = low[i-1]-low[i];
      plusDM[j]  = (up>dn && up>0.0) ? up : 0.0;
      minusDM[j] = (dn>up && dn>0.0) ? dn : 0.0;
      tr[j]      = MathMax(high[i]-low[i],
                           MathMax(MathAbs(high[i]-close[i-1]),
                                   MathAbs(low[i]-close[i-1])));
     }

   //--- primo smoothing di Wilder = somma dei primi 'period' valori.
   double smTR=0.0, smP=0.0, smM=0.0;
   for(int j=0;j<period;j++){ smTR+=tr[j]; smP+=plusDM[j]; smM+=minusDM[j]; }

   double dx[]; ArrayResize(dx,m); int dxCount=0;
   //--- primo DX (DI calcolati dalla prima somma smussata).
   {
    double pDI = (smTR>0.0) ? 100.0*smP/smTR : 0.0;
    double mDI = (smTR>0.0) ? 100.0*smM/smTR : 0.0;
    double s   = pDI+mDI;
    dx[dxCount++] = (s>0.0) ? 100.0*MathAbs(pDI-mDI)/s : 0.0;
   }
   //--- smoothing di Wilder passo-passo sui valori successivi.
   for(int j=period;j<m;j++)
     {
      smTR = smTR - smTR/period + tr[j];
      smP  = smP  - smP /period + plusDM[j];
      smM  = smM  - smM /period + minusDM[j];
      double pDI = (smTR>0.0) ? 100.0*smP/smTR : 0.0;
      double mDI = (smTR>0.0) ? 100.0*smM/smTR : 0.0;
      double s   = pDI+mDI;
      dx[dxCount++] = (s>0.0) ? 100.0*MathAbs(pDI-mDI)/s : 0.0;
     }

   if(dxCount < period) return(-1.0);

   //--- ADX = media di Wilder del DX: media semplice dei primi 'period',
   //    poi smussamento di Wilder sui rimanenti.
   double adx=0.0;
   for(int j=0;j<period;j++) adx+=dx[j];
   adx/=period;
   for(int j=period;j<dxCount;j++)
      adx = (adx*(period-1)+dx[j])/period;

   return(adx);
  }

//+------------------------------------------------------------------+
//| CHIAVE DI GIORNO DI CALENDARIO - nucleo puro. anno*10000 +        |
//| mese*100 + giorno (es. 2024.01.03 -> 20240103). Serve a           |
//| raggruppare le barre intraday in giornate. Chiave 0 = "nessun     |
//| giorno" (le chiavi vere sono >= 19700101), usata come "non        |
//| escludere niente".                                                |
//+------------------------------------------------------------------+
long ChiaveGiorno_Calc(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return((long)d.year*10000 + (long)d.mon*100 + (long)d.day);
  }

//+------------------------------------------------------------------+
//| AGGREGAZIONE INTRADAY -> GIORNI - nucleo puro (l'AUTOTEST la      |
//| interroga su una serie sintetica, senza mercato).                 |
//|                                                                   |
//| Prende le barre del TF del GRAFICO in ordine CRONOLOGICO (indice  |
//| 0 = la piu' vecchia) e le raggruppa per GIORNO DI CALENDARIO      |
//| della loro 'time':                                                |
//|   open  = open della PRIMA barra del giorno                       |
//|   high  = MAX degli high del giorno                               |
//|   low   = MIN dei low del giorno                                  |
//|   close = close dell'ULTIMA barra del giorno                      |
//|                                                                   |
//| chiaveGiornoCorrente: le barre di QUEL giorno vengono SCARTATE.   |
//|   E' il giorno in cui sta vivendo la barra corrente del grafico:  |
//|   quel giorno NON e' finito, la sua "barra giornaliera" non e'    |
//|   chiusa e usarla sarebbe LOOK-AHEAD. Passare 0 per non escludere |
//|   niente (serve solo all'autotest).                               |
//| scartaPrimoGiorno: il PRIMO giorno del gruppo viene buttato via   |
//|   perche' la finestra di barre copiate quasi sempre comincia a    |
//|   meta' giornata -> quel giorno sarebbe TRONCATO (high/low/open   |
//|   falsi). Si tengono solo giorni COMPLETI.                        |
//|                                                                   |
//| Ritorna il numero di giorni prodotti (0 se non ne resta nessuno). |
//+------------------------------------------------------------------+
int AggregaGiorni_Calc(const datetime &tm[],const double &op[],const double &hi[],
                       const double &lo[],const double &cl[],const int n,
                       const long chiaveGiornoCorrente,const bool scartaPrimoGiorno,
                       double &dOpen[],double &dHigh[],double &dLow[],double &dClose[])
  {
   ArrayResize(dOpen,0); ArrayResize(dHigh,0); ArrayResize(dLow,0); ArrayResize(dClose,0);
   if(n<=0) return(0);

   double tOpen[],tHigh[],tLow[],tClose[]; long tKey[];
   ArrayResize(tOpen,n); ArrayResize(tHigh,n); ArrayResize(tLow,n);
   ArrayResize(tClose,n); ArrayResize(tKey,n);

   int ng=0;
   for(int i=0;i<n;i++)
     {
      long k = ChiaveGiorno_Calc(tm[i]);
      if(chiaveGiornoCorrente!=0 && k==chiaveGiornoCorrente) continue;  // giorno IN CORSO: mai
      if(ng==0 || k!=tKey[ng-1])
        {
         tKey[ng]=k; tOpen[ng]=op[i]; tHigh[ng]=hi[i]; tLow[ng]=lo[i]; tClose[ng]=cl[i];
         ng++;
        }
      else
        {
         if(hi[i]>tHigh[ng-1]) tHigh[ng-1]=hi[i];
         if(lo[i]<tLow[ng-1])  tLow[ng-1] =lo[i];
         tClose[ng-1]=cl[i];                     // l'ultima barra del giorno detta la chiusura
        }
     }

   int start = (scartaPrimoGiorno ? 1 : 0);
   int out   = ng-start;
   if(out<=0) return(0);

   ArrayResize(dOpen,out); ArrayResize(dHigh,out); ArrayResize(dLow,out); ArrayResize(dClose,out);
   for(int j=0;j<out;j++)
     {
      dOpen[j] =tOpen [start+j];
      dHigh[j] =tHigh [start+j];
      dLow[j]  =tLow  [start+j];
      dClose[j]=tClose[start+j];
     }
   return(out);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpWickFactor<0)
     { Print("ERRORE: InpWickFactor non puo' essere negativo."); return(INIT_FAILED); }
   if(InpUseMidGate!=0 && InpUseMidGate!=1)
     { Print("ERRORE: InpUseMidGate deve essere 0 (OFF) o 1 (ON)."); return(INIT_FAILED); }
   if(InpSide<0 || InpSide>2)
     { Print("ERRORE: InpSide deve essere 0 (long), 1 (short) o 2 (entrambi)."); return(INIT_FAILED); }
   if(InpSlBufferPts<0)
     { Print("ERRORE: InpSlBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing per un
   //    fade su falsa rottura (coltello che cade): OnInit rifiuta se e' <= 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un fade senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpTP1_ClosePct<=0 || InpTP1_ClosePct>=100)
     { Print("ERRORE: InpTP1_ClosePct deve stare in (0,100): parziale a TP1 lasciando un runner a TP2."); return(INIT_FAILED); }
   if(InpCloseAtEnd)
     {
      if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
        { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
     }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }

   //--- GATE DI REGIME: NIENTE handle iADX/iATR (nel tester TICK su simbolo
   //    NATIVO gli handle MTF non popolano e il gate bloccava TUTTO per dato
   //    mancante). ADX e ATR si calcolano a mano dalle barre del TF di regime
   //    via CopyRates (affidabili nel tester). Con gate ON si validano solo i
   //    periodi e la soglia ATR; con gate OFF non si tocca nulla (EA identico).
   if(InpUseRegimeGate)
     {
      if(InpRegimeAdxPeriod<=0)
        { Print("ERRORE: InpRegimeAdxPeriod deve essere > 0 (gate di regime)."); return(INIT_FAILED); }
      if(InpRegimeAtrPeriod<=0)
        { Print("ERRORE: InpRegimeAtrPeriod deve essere > 0 (gate di regime)."); return(INIT_FAILED); }
      if(InpAtrMinPts<0)
        { Print("ERRORE: InpAtrMinPts non puo' essere negativo (gate di regime)."); return(INIT_FAILED); }
     }

   if(InpAutoTest) AutoTestCRT();

   Log(StringFormat("avviato su %s %s. Wick x%.2f, midGate %s, side %s, SL buffer %d + pavimento %d pti MT5, TP1 close %.0f%% (BE %s), rischio %.2f%%, cap %d/gg, flat %s %02d:%02d, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpWickFactor, (InpUseMidGate==1?"ON":"off"),
       (InpSide==0?"LONG":(InpSide==1?"SHORT":"BOTH")),
       InpSlBufferPts, InpMinStopPts, InpTP1_ClosePct,
       (InpBreakevenAfterTP1?"ON":"off"),
       InpRiskPercent, InpMaxTradesPerDay,
       (InpCloseAtEnd?"ON":"off"), InpCloseHour, InpCloseMin, InpMagic));
   Log("Ingresso SINGOLO: una posizione per magic, nessuna aggiunta/mediazione/griglia su posizione aperta (contratto). SL e TP2 sono ordini VERI al broker.");
   if(InpUseRegimeGate)
     {
      Log(StringFormat("GATE DI REGIME ON su %s: opero solo se ADX(%d) <= %.1f E ATR(%d) >= %.1f pti idx (barra CHIUSA, shift 1). Fuori regime: FLAT.",
          EnumToString(InpRegimeTF), InpRegimeAdxPeriod, InpAdxMax, InpRegimeAtrPeriod, InpAtrMinPts));
      Log(StringFormat("GATE: due vie. 1) CopyRates(%s) diretto. 2) FALLBACK autosufficiente: se la prima non consegna abbastanza barre, le GIORNATE si aggregano dalle barre di %s (giorno di calendario; il giorno IN CORSO e il primo giorno troncato si scartano). Le colonne 'Gate Via D1' / 'Gate Via M15' dell'OPTFRAME dicono quale via ha lavorato; le prime 5 volte che il gate chiude per DATO MANCANTE esce una riga [CRTTS][GATE-DIAG].",
          EnumToString(InpRegimeTF), EnumToString((ENUM_TIMEFRAMES)Period())));
      if(InpRegimeTF!=PERIOD_D1)
         Log(StringFormat("ATTENZIONE (onesta', non errore): InpRegimeTF = %s ma il FALLBACK sa costruire SOLO GIORNATE. Se la via diretta non consegna, il gate misurera' ADX/ATR su barre GIORNALIERE, non su %s: i numeri non sono confrontabili con una cella ottimizzata su quel TF.",
             EnumToString(InpRegimeTF), EnumToString(InpRegimeTF)));
     }
   else
      Log("GATE DI REGIME OFF: comportamento identico all'originale (nessun controllo di regime).");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- NESSUN handle da rilasciare: il pattern (le tre barre) e' letto da
   //    iOHLC e il gate di regime calcola ADX/ATR da CopyRates, senza handle
   //    indicatore. Niente stato persistente sul terminale.
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la peggior giornata si aggiorna a OGNI tick e PRIMA del flat.
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();           // il cap conta gli ingressi ESEGUITI

   //--- la GESTIONE (parziale TP1 + breakeven) gira a ogni tick: TP1 puo'
   //    essere colpito intrabar, non solo a barra chiusa.
   GestisciPosizione();

   if(FlatFineSedutaCheck()) return;   // fine seduta: chiudo tutto e non riapro

   if(!IsNewBar()) return;             // le DECISIONI d'ingresso solo a barra chiusa

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
//| FALLBACK AUTOSUFFICIENTE - giorni COSTRUITI dalle barre del TF     |
//| del GRAFICO. Perche' esiste: nel tester TICK su simbolo NATIVO ne  |
//| gli handle MTF (iADX/iATR) ne' CopyRates(D1) hanno mai consegnato  |
//| dati -> il gate bloccava TUTTI i pattern per dato-mancante. Le     |
//| barre del TF di TEST invece ci sono SEMPRE: e' il TF su cui gira   |
//| la corsa. Quindi la giornata la costruiamo noi.                    |
//|                                                                    |
//| COME: CopyRates(_Symbol, _Period, 1, M) - shift 1, barre CHIUSE -  |
//| con M = barre-per-giorno * (giorni voluti + 10), tetto 20000; se   |
//| il tester ne da' meno si usa quel che c'e'. Poi AggregaGiorni_Calc |
//| raggruppa per GIORNO DI CALENDARIO (high=max, low=min, close=      |
//| ultima, open=prima).                                               |
//|                                                                    |
//| DUE GIORNI SI BUTTANO SEMPRE, per onesta':                         |
//|   - il giorno IN CORSO (quello della barra corrente del grafico):  |
//|     e' una giornata NON chiusa, usarla sarebbe look-ahead;         |
//|   - il PRIMO giorno della finestra: quasi sempre TRONCATO (la      |
//|     finestra comincia a meta' giornata) -> high/low falsi.         |
//|                                                                    |
//| DIFFERENZA ONESTA rispetto al D1 del broker: il "giorno di         |
//| calendario" del feed puo' NON coincidere con la barra D1 del       |
//| broker (i confini di sessione e il rollover possono spostare       |
//| qualche barra di qua o di la'). Quindi high/low/close di un        |
//| singolo giorno possono differire un po'. Ma la SCALA dei due       |
//| indicatori e' la stessa: ADX resta 0-100 (e' un rapporto, non      |
//| dipende dall'unita') e ATR resta un range giornaliero in prezzo.   |
//| La soglia ADX <= 30 conserva quindi il suo significato; e' la      |
//| CELLA di ottimizzazione che va riletta su questa via, non la       |
//| semantica del gate.                                                |
//|                                                                    |
//| Ritorna quanti giorni ha messo in high/low/close (CRONOLOGICI,     |
//| indice 0 = il piu' vecchio), 0 se non ce l'ha fatta.               |
//+------------------------------------------------------------------+
int LeggiGiorniDaGrafico(const int giorniVoluti,double &high[],double &low[],double &close[])
  {
   gDiagGotBar=0; gDiagErrBar=0; gDiagGiorni=0;
   if(giorniVoluti<=0) return(0);

   //--- quante barre del grafico servono per coprire i giorni voluti.
   int secBar = PeriodSeconds(_Period);
   if(secBar<=0) secBar=900;                       // difensivo: M15
   int perGiorno = (int)(86400/secBar);
   if(perGiorno<1) perGiorno=1;
   long voglio = (long)perGiorno*(long)(giorniVoluti+10);   // +10 giorni di margine
   if(voglio>20000) voglio=20000;                  // tetto ragionevole
   if(voglio<2)     voglio=2;

   MqlRates r[];
   ArraySetAsSeries(r,false);                      // r[0] = la PIU' VECCHIA
   ResetLastError();
   int got = CopyRates(_Symbol, _Period, 1, (int)voglio, r);   // shift 1 = barre CHIUSE
   gDiagErrBar = (int)GetLastError();
   gDiagGotBar = got;
   if(got<=0) return(0);

   //--- il giorno della barra CORRENTE (shift 0) e' il giorno IN CORSO: escluso.
   datetime tCur = iTime(_Symbol,_Period,0);
   if(tCur<=0) tCur = TimeCurrent();
   long keyOggi = ChiaveGiorno_Calc(tCur);

   //--- L'ORDINE NON SI DA' PER BUONO: si CHIEDE ai timestamp. Se r[0] e' piu'
   //    recente di r[got-1] l'array e' rovesciato e va riletto al contrario.
   //    (Un array letto al contrario aggregherebbe i giorni a rovescio e la
   //    "chiusura" sarebbe l'apertura: errore silenzioso, meglio prevenirlo.)
   bool inverso = (got>1 && r[0].time > r[got-1].time);

   datetime tm[]; double op[],hi[],lo[],cl[];
   ArrayResize(tm,got); ArrayResize(op,got); ArrayResize(hi,got);
   ArrayResize(lo,got); ArrayResize(cl,got);
   for(int i=0;i<got;i++)
     {
      int s = (inverso ? got-1-i : i);          // s scorre dal PIU' VECCHIO
      tm[i]=r[s].time; op[i]=r[s].open; hi[i]=r[s].high;
      lo[i]=r[s].low;  cl[i]=r[s].close;
     }

   double dO[],dH[],dL[],dC[];
   int nd = AggregaGiorni_Calc(tm,op,hi,lo,cl,got, keyOggi, true, dO,dH,dL,dC);
   gDiagGiorni = nd;
   if(nd<=0) return(0);

   //--- tengo gli ULTIMI 'giorniVoluti' giorni (i piu' recenti).
   int use = (nd>giorniVoluti ? giorniVoluti : nd);
   int off = nd-use;
   ArrayResize(high,use); ArrayResize(low,use); ArrayResize(close,use);
   for(int j=0;j<use;j++)
     {
      high[j] =dH[off+j];
      low[j]  =dL[off+j];
      close[j]=dC[off+j];
     }
   return(use);
  }

//+------------------------------------------------------------------+
//| Estrae le barre del regime in serie CRONOLOGICA (indice 0 = piu'   |
//| vecchia) dentro high/low/close, a SHIFT 1 (barre CHIUSE, niente    |
//| look-ahead). DUE VIE, in ordine di preferenza:                     |
//|                                                                    |
//|   VIA 1 - CopyRates(InpRegimeTF): il TF di regime vero e proprio.  |
//|           Si usa se consegna almeno 'minimo' barre.                |
//|   VIA 2 - FALLBACK: giorni AGGREGATI dalle barre del TF del        |
//|           grafico (LeggiGiorniDaGrafico). Scatta SOLO se la via 1  |
//|           fallisce o torna meno di 'minimo' barre.                 |
//|                                                                    |
//| 'quante' = quante barre si vorrebbero (con margine), 'minimo' =    |
//| quante ne servono davvero per far tornare i conti a ATR/ADX.       |
//| Ritorna il numero di barre consegnate; gDiagVia dice da che via.   |
//+------------------------------------------------------------------+
int LeggiBarreRegime(const int quante,const int minimo,double &high[],double &low[],double &close[])
  {
   gDiagGotTF=0; gDiagErrTF=0; gDiagGotBar=0; gDiagErrBar=0; gDiagGiorni=0; gDiagVia=0;
   if(quante<=0) return(0);

   //--- VIA 1: il TF di regime, diretto.
   MqlRates r[];
   ArraySetAsSeries(r,true);                  // r[0] = shift 1 (la piu' recente chiusa)
   ResetLastError();
   int got = CopyRates(_Symbol, InpRegimeTF, 1, quante, r);
   gDiagErrTF = (int)GetLastError();
   gDiagGotTF = got;
   if(got>0 && got>=minimo)
     {
      //--- l'ordine si CHIEDE ai timestamp, non al flag as-series.
      bool inverso = (got>1 && r[0].time > r[got-1].time);
      ArrayResize(high,got); ArrayResize(low,got); ArrayResize(close,got);
      //--- uscita sempre CRONOLOGICA (indice 0 = la piu' vecchia).
      for(int i=0;i<got;i++)
        {
         int s = (inverso ? got-1-i : i);
         high[i]  = r[s].high;
         low[i]   = r[s].low;
         close[i] = r[s].close;
        }
      gDiagVia = 1;
      return(got);
     }

   //--- VIA 2: fallback autosufficiente sulle barre del grafico.
   int nd = LeggiGiorniDaGrafico(quante, high, low, close);
   if(nd>0 && nd>=minimo){ gDiagVia = 2; return(nd); }

   gDiagVia = 0;                              // nessuna via ce l'ha fatta
   return(nd);
  }

//+------------------------------------------------------------------+
//| DIAGNOSTICA del gate quando fallisce per DATO MANCANTE (non per   |
//| soglia): stampa SOLO le prime 5 volte (su decine di migliaia di   |
//| barre il log esploderebbe e il Giornale diventa illeggibile).     |
//| Si legge nel Giornale di un TEST SINGOLO: dice esattamente quante |
//| barre ha dato ogni via, con che errore, e cosa serviva.           |
//+------------------------------------------------------------------+
void DiagGateDatoMancante(const string motivo,const int n,
                          const int needAtr,const int needAdx)
  {
   static int stampe=0;
   if(stampe>=5) return;
   stampe++;
   string via = (gDiagVia==1 ? "TF diretto" : (gDiagVia==2 ? "FALLBACK aggregato dal grafico" : "NESSUNA"));
   PrintFormat("[CRTTS][GATE-DIAG] %d/5 %s | %s | via=%s | %s diretto: got=%d err=%d | fallback %s: barre=%d err=%d giorni=%d | ottenute n=%d, servono ATR>=%d ADX>=%d | ESITO: gate CHIUSO per DATO MANCANTE (non per soglia)",
               stampe,
               TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES),
               motivo, via,
               EnumToString(InpRegimeTF), gDiagGotTF, gDiagErrTF,
               EnumToString((ENUM_TIMEFRAMES)_Period), gDiagGotBar, gDiagErrBar, gDiagGiorni,
               n, needAtr, needAdx);
  }

//+------------------------------------------------------------------+
//| GATE DI REGIME live: calcola ADX e ATR del regime sulla barra      |
//| CHIUSA (shift 1) DALLE BARRE lette da LeggiBarreRegime (via TF     |
//| diretto o via fallback aggregato), NON da handle iADX/iATR (che    |
//| nel tester tick su simbolo nativo non popolano). Poi chiede al     |
//| nucleo puro RegimeGate_Calc se il regime e' operabile.             |
//|                                                                    |
//| UNA SOLA LETTURA per entrambi gli indicatori: si prende la         |
//| finestra piu' lunga fra quella che serve all'ATR (period+1) e      |
//| quella che serve all'ADX (2*period+2), con 100 barre di margine    |
//| perche' la media di Wilder si assesti. AtrMedia_Calc usa comunque  |
//| solo gli ULTIMI 'period' TR, quindi con i default (ATR 14 / ADX    |
//| 14 -> finestra 130, identica a prima) i valori NON cambiano.       |
//|                                                                    |
//| Niente look-ahead: shift 1, e il giorno in corso e' escluso anche  |
//| nel fallback. Se i dati non bastano -> gate NON soddisfatto (non   |
//| e' un errore) + riga [GATE-DIAG] per le prime 5 volte.             |
//| ATR e' in PREZZO: convertito in PUNTI INDICE con la stessa         |
//| conversione del resto del motore (coerenza della soglia).          |
//+------------------------------------------------------------------+
bool RegimeGateOk()
  {
   double h[],l[],c[];

   int needAtr = InpRegimeAtrPeriod+1;        // ogni TR usa la chiusura precedente
   int needAdx = 2*InpRegimeAdxPeriod+2;      // 2*period per la prima media di Wilder
   int need    = (needAtr>needAdx ? needAtr : needAdx);
   int want    = need+100;                    // margine: l'ADX si stabilizza

   int n = LeggiBarreRegime(want, need, h, l, c);
   if(n < need)
     { DiagGateDatoMancante("barre insufficienti", n, needAtr, needAdx); return(false); }

   double atrPrezzo = AtrMedia_Calc(h, l, c, n, InpRegimeAtrPeriod);
   if(atrPrezzo<=0)
     { DiagGateDatoMancante("ATR non calcolabile", n, needAtr, needAdx); return(false); }

   double adx = AdxWilder_Calc(h, l, c, n, InpRegimeAdxPeriod);
   if(adx<0)
     { DiagGateDatoMancante("ADX non calcolabile", n, needAtr, needAdx); return(false); }

   //--- da qui il DATO C'E': la valutazione e' riuscita, conto da che via.
   if(gDiagVia==1)      gGateViaD1++;
   else if(gDiagVia==2) gGateViaM15++;

   double atrPts = PrezzoInPuntiIndice_Calc(atrPrezzo, InpMT5PerPuntoIndice, _Point);
   return(RegimeGate_Calc(adx, atrPts, InpAdxMax, InpAtrMinPts));
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. Si valutano C1 (shift 1) e C2 (shift  |
//| 2), gia' CHIUSE; l'ordine parte al mercato all'apertura di C0.    |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   //--- una posizione per magic: se e' aperta, la gestione (parziale +
   //    breakeven) e' gia' fatta in OnTick; qui non si apre nient'altro.
   if(CountPositions()>0){ gCntGestione++; return; }

   if(Bars(_Symbol,gTF) < 3){ gCntNoDati++; return; }

   //--- oltre l'orario di flat non si aprono nuove posizioni (il flat le
   //    chiuderebbe subito): niente overnight per costruzione.
   if(InpCloseAtEnd)
     {
      MqlDateTime tnow; TimeToStruct(TimeCurrent(),tnow);
      if(DopoOrarioFlat_Calc(tnow.hour,tnow.min,InpCloseHour,InpCloseMin)){ gCntFuoriOrario++; return; }
     }

   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ gCntMaxTrades++; return; }
   if(!SpreadOK()){ gCntSpread++; return; }

   //--- C1 = shift 1 (falsa rottura), C2 = shift 2 (range). Barre chiuse.
   double o1=iOpen(_Symbol,gTF,1), c1=iClose(_Symbol,gTF,1), h1=iHigh(_Symbol,gTF,1), l1=iLow(_Symbol,gTF,1);
   double o2=iOpen(_Symbol,gTF,2), c2=iClose(_Symbol,gTF,2), h2=iHigh(_Symbol,gTF,2), l2=iLow(_Symbol,gTF,2);
   if(o1<=0||c1<=0||h1<=0||l1<=0||o2<=0||c2<=0||h2<=0||l2<=0){ gCntNoDati++; return; }

   int sig = SegnaleCRT_Calc(o1,c1,h1,l1, o2,c2,h2,l2,
                             InpWickFactor, (InpUseMidGate==1), InpSide);
   if(sig==0){ gCntNoPattern++; return; }

   //--- GATE DI REGIME (costitutivo, opzionale): un pattern valido viene
   //    comunque SOPPRESSO se il regime non e' da chop/range bilaterale
   //    (ADX troppo alto = trend/crollo forte, oppure ATR troppo basso =
   //    toro calmo). Con gate OFF questo blocco e' inerte.
   if(InpUseRegimeGate && !RegimeGateOk()){ gCntGateBloccati++; return; }

   bool isLong = (sig>0);
   if(isLong) gCntLongCand++; else gCntShortCand++;

   gCntApri++;
   ApriPosizione(isLong, l1, h1, l2, h2);
  }

//==================================================================
//  INGRESSO - ordine a MERCATO con STOP LOSS e TP2 veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Apre la posizione al mercato. SL all'estremo del wick di C1 (+     |
//| buffer), poi SEMPRE dal PAVIMENTO (mai a zero, mai dentro lo       |
//| stops-level). TP2 = estremo opposto di C2 (runner). TP1 (mid di    |
//| C2) e' memorizzato per la gestione del parziale. Il lotto esce da  |
//| LotByRisk sulla distanza FINALE dello stop.                       |
//+------------------------------------------------------------------+
bool ApriPosizione(const bool isLong,const double l1,const double h1,
                   const double l2,const double h2)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double ref = isLong ? ask : bid;           // prezzo di riferimento del mercato

   double bufferPrezzo = InpSlBufferPts*_Point;
   double slRaw = SlWick_Calc(isLong, l1, h1, bufferPrezzo);

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

   //--- TP2 = estremo opposto di C2 (runner). Dev'essere dal lato giusto;
   //    se troppo vicino, lo si spinge al minimo consentito dal broker.
   double tp2 = Tp2Ext_Calc(isLong, h2, l2);
   double distTP = isLong ? (tp2-ref) : (ref-tp2);
   if(distTP<=0){ Log("TP2 dal lato sbagliato (setup degenere): salto."); return(false); }
   if(distTP < minBroker) tp2 = isLong ? ref+minBroker : ref-minBroker;
   tp2 = NormalizePrice(tp2);

   double lot = LotByRisk(distSL);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,tp2,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sl,tp2,cm);
   if(ok)
     {
      //--- registro lo stato per la GESTIONE (parziale a TP1 + breakeven).
      double tp1 = Tp1Mid_Calc(h2,l2);
      RegistraPosizioneAperta(isLong, ref, tp1, tp2);

      double idxRisk = PrezzoInPuntiIndice_Calc(distSL, InpMT5PerPuntoIndice, _Point);
      Log(StringFormat("%s MKT @ ~%s SL %s TP1 %s TP2 %s lot %.2f (rischio %.1f pti idx)",
          isLong?"BUY(fade sweep min)":"SELL(fade sweep max)",
          DoubleToString(ref,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp1,_Digits), DoubleToString(tp2,_Digits), lot, idxRisk));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//+------------------------------------------------------------------+
//| Registra lo stato della posizione appena aperta (per la gestione).|
//| Aggancia il ticket VERO della posizione a magic.                  |
//+------------------------------------------------------------------+
void RegistraPosizioneAperta(const bool isLong,const double entry,
                             const double tp1,const double tp2)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      gPosTicket   = tk;
      gIsLong      = isLong;
      gEntryPrice  = PositionGetDouble(POSITION_PRICE_OPEN);   // prezzo di riempimento VERO
      if(gEntryPrice<=0) gEntryPrice = entry;
      gTP1Price    = tp1;
      gTP2Price    = tp2;
      gPartialDone = false;
      return;
     }
  }

//==================================================================
//  GESTIONE della posizione: parziale a TP1 + breakeven (una volta)
//==================================================================
//+------------------------------------------------------------------+
//| A TP1 (mid range di C2) chiude InpTP1_ClosePct% e, se richiesto,   |
//| porta lo SL a pareggio. Una sola volta per posizione (gPartialDone |
//| legato al ticket). Il runner resta con TP2 vero al broker.        |
//| Nota: dopo un riavvio a meta' trade lo stato e' perso e il         |
//| parziale non scatta, ma SL/TP2 VERI proteggono comunque.          |
//+------------------------------------------------------------------+
void GestisciPosizione()
  {
   //--- trova la posizione a magic sul simbolo
   ulong tk = 0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong t=PositionGetTicket(i);
      if(t==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      tk=t; break;
     }
   if(tk==0)
     {
      //--- nessuna posizione: azzero lo stato di gestione.
      gPosTicket=0; gPartialDone=false; gTP1Price=0; gTP2Price=0;
      return;
     }

   //--- ticket cambiato senza passare da ApriPosizione (es. riavvio): non
   //    conosco TP1 -> niente parziale, la posizione resta su SL/TP2 veri.
   if(tk!=gPosTicket) return;
   if(gPartialDone) return;
   if(gTP1Price<=0) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;

   //--- TP1 raggiunto? long si valuta sul bid (uscita), short sull'ask.
   bool hitTP1 = gIsLong ? (bid >= gTP1Price) : (ask <= gTP1Price);
   if(!hitTP1) return;

   //--- 1) PARZIALE: chiudo InpTP1_ClosePct% del volume, se la spezzatura
   //       rispetta min/step (altrimenti niente parziale, solo breakeven).
   double vol   = PositionGetDouble(POSITION_VOLUME);
   double minV  = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double closeVol = NormalizeVolume(vol*InpTP1_ClosePct/100.0);
   double remain   = vol - closeVol;
   if(closeVol>=minV && remain>=minV)
     {
      if(gTrade.PositionClosePartial(tk, closeVol))
         Log(StringFormat("TP1 colpito: chiuso parziale %.2f su %.2f (resto verso TP2).", closeVol, vol));
      else
         Log("parziale a TP1 fallito: "+gTrade.ResultRetcodeDescription());
     }
   else
      Log("parziale a TP1 non spezzabile (min/step volume): tengo intero e vado in breakeven.");

   //--- 2) BREAKEVEN: SL a pareggio (una volta sola), preservando TP2.
   if(InpBreakevenAfterTP1)
     {
      double be = NormalizePrice(gEntryPrice);
      double stops = minBrokerPrezzo();
      //--- clamp: lo SL deve stare oltre lo stops-level dal prezzo corrente.
      if(gIsLong){ double maxSL=bid-stops; if(be>maxSL) be=NormalizePrice(maxSL); }
      else       { double minSL=ask+stops; if(be<minSL) be=NormalizePrice(minSL); }

      //--- preservo il TP2 gia' impostato all'apertura (memorizzato), senza
      //    dipendere dalla selezione della posizione dopo il parziale.
      double tpCur = gTP2Price;
      if(gTrade.PositionModify(tk, be, tpCur))
         Log(StringFormat("breakeven: SL portato a %s.", DoubleToString(be,_Digits)));
      else
         Log("breakeven fallito: "+gTrade.ResultRetcodeDescription());
     }

   gPartialDone = true;
  }

double minBrokerPrezzo()
  {
   return((double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
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
         Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
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

//--- Volume normalizzato allo step; sotto il minimo -> 0 (non spezzabile).
double NormalizeVolume(double v)
  {
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   v = MathFloor(v/st)*st;
   if(v<mn) return(0);
   if(v>mx) v=mx;
   return(v);
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
void AutoTestCRT()
  {
   int falliti=0;

   PrintFormat("[CRTTS][AUTOTEST] Wick x%.2f midGate=%d side=%d | %s | magic %I64d",
               InpWickFactor,(int)(InpUseMidGate==1),InpSide,_Symbol,InpMagic);

   //--- 1. PATTERN BULLISH (long). C2 ribassista o2=110 c2=100 h2=111 l2=99
   //    (mid2 = 105). C1 rialzista o1=101 c1=101.5 (corpo 0.5) l1=98 (< 99)
   //    lowerWick=101-98=3 (>= 3*0.5=1.5) h1=102 (< mid2 105, gate ok).
   int b1 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,2);
   //--- 2. PATTERN BEARISH (short). C2 rialzista o2=100 c2=110 h2=111 l2=99
   //    (mid2 105). C1 ribassista o1=109 c1=108.5 (corpo 0.5) h1=113 (>111)
   //    upperWick=113-109=4 (>=1.5) l1=106 (> mid2 105, gate ok).
   int b2 = SegnaleCRT_Calc(109.0,108.5,113.0,106.0, 100.0,110.0,111.0,99.0, 3.0,true,2);
   PrintFormat("[CRTTS][AUTOTEST] pattern: bull=%d(1) bear=%d(-1)", b1,b2);
   if(!(b1==1 && b2==-1)) falliti++;

   //--- 3. WICK troppo corto -> niente segnale. Corpo grosso (c1=104,
   //    corpo 3), lowerWick=101-98=3 < 3*3=9 -> 0.
   int w1 = SegnaleCRT_Calc(101.0,104.0,104.5,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   //    stesso pattern ma con wick lungo (corpo 0.5) -> passa (midGate off).
   int w2 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   PrintFormat("[CRTTS][AUTOTEST] wick: corto=%d(0) lungo=%d(1)", w1,w2);
   if(!(w1==0 && w2==1)) falliti++;

   //--- 4. GATE 50%: bull con h1=106 (>= mid2 105) -> il gate SPEGNE;
   //    con gate off invece passa.
   int g1 = SegnaleCRT_Calc(101.0,101.5,106.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true ,2);
   int g2 = SegnaleCRT_Calc(101.0,101.5,106.0,98.0, 110.0,100.0,111.0,99.0, 3.0,false,2);
   PrintFormat("[CRTTS][AUTOTEST] midGate: on=%d(0) off=%d(1)", g1,g2);
   if(!(g1==0 && g2==1)) falliti++;

   //--- 5. LATO: pattern bull con side=1 (solo short) -> 0; side=0 -> 1.
   int s1 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,1);
   int s2 = SegnaleCRT_Calc(101.0,101.5,102.0,98.0, 110.0,100.0,111.0,99.0, 3.0,true,0);
   PrintFormat("[CRTTS][AUTOTEST] side: bullSoloShort=%d(0) bullSoloLong=%d(1)", s1,s2);
   if(!(s1==0 && s2==1)) falliti++;

   //--- 6. SL wick + PAVIMENTO (mai a zero: R109).
   double sl_l=SlWick_Calc(true , 98.0,102.0, 0.0);   // long -> 98.00
   double sl_s=SlWick_Calc(false, 98.0,113.0, 0.0);   // short -> 113.00
   double p1=PavimentoSL_Calc(true ,101.5, 98.0, 5.0);  // dist 3.5 < 5 -> 96.50
   double p2=PavimentoSL_Calc(true ,101.5, 98.0, 2.0);  // dist 3.5 >= 2 -> 98.00
   double p3=PavimentoSL_Calc(false,108.5,113.0, 2.0);  // dist 4.5 >= 2 -> 113.00
   PrintFormat("[CRTTS][AUTOTEST] SL: long=%.2f(98.00) short=%.2f(113.00) | pav %.2f(96.50) %.2f(98.00) %.2f(113.00)",
               sl_l,sl_s,p1,p2,p3);
   if(!(MathAbs(sl_l-98.0)<1e-6 && MathAbs(sl_s-113.0)<1e-6 &&
        MathAbs(p1-96.5)<1e-6 && MathAbs(p2-98.0)<1e-6 && MathAbs(p3-113.0)<1e-6)) falliti++;

   //--- 7. TP1 (mid di C2) e TP2 (estremo opposto di C2).
   double tp1=Tp1Mid_Calc(111.0,99.0);          // 105.00
   double tp2L=Tp2Ext_Calc(true ,111.0,99.0);   // long -> 111.00
   double tp2S=Tp2Ext_Calc(false,111.0,99.0);   // short -> 99.00
   PrintFormat("[CRTTS][AUTOTEST] TP: mid=%.2f(105.00) tp2Long=%.2f(111.00) tp2Short=%.2f(99.00)",
               tp1,tp2L,tp2S);
   if(!(MathAbs(tp1-105.0)<1e-6 && MathAbs(tp2L-111.0)<1e-6 && MathAbs(tp2S-99.0)<1e-6)) falliti++;

   //--- 8. FLAT + conversione punti indice.
   bool fl1=DopoOrarioFlat_Calc(22, 0,22,0);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(21,59,22,0);   // prima -> no
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);   // 5.00
   PrintFormat("[CRTTS][AUTOTEST] flat esatto=%d(1) prima=%d(0) | conv=%.2f(5.00)",
               (int)fl1,(int)fl2,ip1);
   if(!(fl1 && !fl2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   //--- 9. GATE DI REGIME: passa SOLO con ADX<=max AND ATR>=min. Le quattro
   //    combinazioni (adxMax=30, atrMin=40): solo (adx ok, atr ok) -> true.
   bool rg1=RegimeGate_Calc(25.0, 50.0, 30.0, 40.0);   // adx<=max, atr>=min -> true
   bool rg2=RegimeGate_Calc(35.0, 50.0, 30.0, 40.0);   // adx>max            -> false
   bool rg3=RegimeGate_Calc(25.0, 30.0, 30.0, 40.0);   // atr<min            -> false
   bool rg4=RegimeGate_Calc(35.0, 30.0, 30.0, 40.0);   // entrambi ko        -> false
   PrintFormat("[CRTTS][AUTOTEST] gateRegime: okok=%d(1) adxAlto=%d(0) atrBasso=%d(0) entrambiKo=%d(0)",
               (int)rg1,(int)rg2,(int)rg3,(int)rg4);
   if(!(rg1 && !rg2 && !rg3 && !rg4)) falliti++;

   //--- 10. ATR MANUALE (media dei TR) su una serie D1 nota a mano. Serie
   //    CRONOLOGICA. Trend regolare: high=10..19, low=high-2, close=high-1.
   //    Ogni TR=2 -> ATR(period 3) = 2.00 esatto. Serie piatta: high/low/close
   //    costanti -> TR=2 (high-low) -> ATR = 2.00.
   double thi[10]={10,11,12,13,14,15,16,17,18,19};
   double tlo[10]={ 8, 9,10,11,12,13,14,15,16,17};
   double tcl[10]={ 9,10,11,12,13,14,15,16,17,18};
   double fhi[10]={10,10,10,10,10,10,10,10,10,10};
   double flo[10]={ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8};
   double fcl[10]={ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9};
   double atrT = AtrMedia_Calc(thi,tlo,tcl,10,3);   // 2.00
   double atrF = AtrMedia_Calc(fhi,flo,fcl,10,3);   // 2.00
   PrintFormat("[CRTTS][AUTOTEST] ATR manuale: trend=%.4f(2.0000) piatto=%.4f(2.0000)", atrT, atrF);
   if(!(MathAbs(atrT-2.0)<1e-6 && MathAbs(atrF-2.0)<1e-6)) falliti++;

   //--- 11. ADX MANUALE (Wilder) sulle stesse serie. Trend perfetto e
   //    monotono: ogni +DM=1, -DM=0, TR=2 -> +DI=50, -DI=0, DX=100 su tutte le
   //    barre -> ADX(period 3) = 100.00 esatto. Serie piatta: +DM=-DM=0 ->
   //    +DI=-DI=0 -> DX=0 -> ADX = 0.00.
   double adxT = AdxWilder_Calc(thi,tlo,tcl,10,3);  // 100.00
   double adxF = AdxWilder_Calc(fhi,flo,fcl,10,3);  //   0.00
   PrintFormat("[CRTTS][AUTOTEST] ADX manuale: trend=%.4f(100.0000) piatto=%.4f(0.0000)", adxT, adxF);
   if(!(MathAbs(adxT-100.0)<1e-6 && MathAbs(adxF-0.0)<1e-6)) falliti++;

   //--- 12. AGGREGAZIONE intraday -> GIORNI (il FALLBACK del gate), su una
   //    serie sintetica calcolabile a mano: 2 giorni x 4 barre + 1 barra del
   //    "giorno in corso" che DEVE sparire.
   //      giorno A (2024.01.02): open 10 | high max(15,16,14,13.5)=16
   //                             low min(9,8,11,12)=8 | close ultima = 13.2
   //      giorno B (2024.01.03): open 20 | high max(25,24,26,23.5)=26
   //                             low min(19,18,21,22)=18 | close ultima = 23.3
   //      giorno C (2024.01.04): UNA barra, e' il giorno IN CORSO -> ESCLUSO.
   //    Due letture: senza scarto del primo giorno -> 2 giorni (A,B);
   //    con lo scarto (come fa il gate) -> 1 giorno, il solo B.
   datetime agT[9]={D'2024.01.02 00:00',D'2024.01.02 06:00',D'2024.01.02 12:00',D'2024.01.02 18:00',
                    D'2024.01.03 00:00',D'2024.01.03 06:00',D'2024.01.03 12:00',D'2024.01.03 18:00',
                    D'2024.01.04 00:00'};
   double agO[9]={10.0,11.0,12.0,13.0, 20.0,21.0,22.0,23.0, 30.0};
   double agH[9]={15.0,16.0,14.0,13.5, 25.0,24.0,26.0,23.5, 31.0};
   double agL[9]={ 9.0, 8.0,11.0,12.0, 19.0,18.0,21.0,22.0, 29.0};
   double agC[9]={11.0,12.0,13.0,13.2, 21.0,22.0,23.0,23.3, 30.5};

   double dO[],dH[],dL[],dC[];
   int nTutti = AggregaGiorni_Calc(agT,agO,agH,agL,agC,9, 20240104, false, dO,dH,dL,dC);
   bool aggA = (nTutti==2) &&
               MathAbs(dO[0]-10.0)<1e-9 && MathAbs(dH[0]-16.0)<1e-9 &&
               MathAbs(dL[0]- 8.0)<1e-9 && MathAbs(dC[0]-13.2)<1e-9 &&
               MathAbs(dO[1]-20.0)<1e-9 && MathAbs(dH[1]-26.0)<1e-9 &&
               MathAbs(dL[1]-18.0)<1e-9 && MathAbs(dC[1]-23.3)<1e-9;
   PrintFormat("[CRTTS][AUTOTEST] aggregazione giorni: n=%d(2) A[o=%.2f(10.00) h=%.2f(16.00) l=%.2f(8.00) c=%.2f(13.20)] B[o=%.2f(20.00) h=%.2f(26.00) l=%.2f(18.00) c=%.2f(23.30)] | giorno in corso escluso=%s",
               nTutti,
               (nTutti>0?dO[0]:0.0),(nTutti>0?dH[0]:0.0),(nTutti>0?dL[0]:0.0),(nTutti>0?dC[0]:0.0),
               (nTutti>1?dO[1]:0.0),(nTutti>1?dH[1]:0.0),(nTutti>1?dL[1]:0.0),(nTutti>1?dC[1]:0.0),
               (nTutti==2?"SI":"NO"));
   if(!aggA) falliti++;

   double eO[],eH[],eL[],eC[];
   int nScarto = AggregaGiorni_Calc(agT,agO,agH,agL,agC,9, 20240104, true, eO,eH,eL,eC);
   bool aggB = (nScarto==1) &&
               MathAbs(eO[0]-20.0)<1e-9 && MathAbs(eH[0]-26.0)<1e-9 &&
               MathAbs(eL[0]-18.0)<1e-9 && MathAbs(eC[0]-23.3)<1e-9;
   long chiave = ChiaveGiorno_Calc(D'2024.01.03 12:00');
   PrintFormat("[CRTTS][AUTOTEST] aggregazione col primo giorno SCARTATO (come il gate): n=%d(1) resta B[o=%.2f(20.00) h=%.2f(26.00) l=%.2f(18.00) c=%.2f(23.30)] | chiaveGiorno=%I64d(20240103)",
               nScarto,
               (nScarto>0?eO[0]:0.0),(nScarto>0?eH[0]:0.0),(nScarto>0?eL[0]:0.0),(nScarto>0?eC[0]:0.0),
               chiave);
   if(!(aggB && chiave==20240103)) falliti++;

   Print("[CRTTS][AUTOTEST] esito motore: ", (falliti==0
         ? "DODICI BLOCCHI SU DODICI, il motore ragiona come i sorgenti (ATR/ADX manuali e aggregazione giorni inclusi)."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;
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
//| EXPORT PER-TRADE in Common\Files. Ogni riga = una posizione       |
//| CHIUSA, con PREZZO D'INGRESSO E DI USCITA, per calcolare la        |
//| mediana del take in PUNTI INDICE prima di leggere qualunque PF.    |
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
   stats[14] = (double)gCntGestione;       // Ret Posizione Aperta
   stats[15] = (double)gCntNoDati;         // Ret No Dati
   stats[16] = (double)gCntMaxTrades;      // Ret Max Trades
   stats[17] = (double)gCntFuoriOrario;    // Ret Fuori Orario
   stats[18] = (double)gCntNoPattern;      // Ret No Pattern
   stats[19] = (double)gCntLongCand;       // Long Cand
   stats[20] = (double)gCntShortCand;      // Short Cand
   stats[21] = (double)gCntApri;           // Apri Chiamate
   stats[22] = (double)gCntGateBloccati;   // Ret Gate Regime (pattern soppressi dal gate)
   //--- da QUALE via e' arrivato il dato del gate (0 e 0 = non e' mai arrivato).
   stats[23] = (double)gGateViaD1;         // Gate Via D1
   stats[24] = (double)gGateViaM15;        // Gate Via M15

   PrintFormat("[CRTTS][DIAG] OnNewBar=%I64d | ret: posAperta=%I64d noDati=%I64d maxTrades=%I64d fuoriOrario=%I64d noPattern=%I64d gateRegime=%I64d | longCand=%I64d shortCand=%I64d apri=%I64d | gate: viaD1=%I64d viaM15=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoDati, gCntMaxTrades,
               gCntFuoriOrario, gCntNoPattern, gCntGateBloccati, gCntLongCand, gCntShortCand, gCntApri,
               gGateViaD1, gGateViaM15);

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
         //    26 colonne fisse: Pass + data[0..24].
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Posizione Aperta,Ret No Dati,Ret Max Trades,Ret Fuori Orario,Ret No Pattern,Long Cand,Short Cand,Apri Chiamate,Ret Gate Regime,Gate Via D1,Gate Via M15";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22],
                                data[23], data[24]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
