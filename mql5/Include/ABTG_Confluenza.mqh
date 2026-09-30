//+------------------------------------------------------------------+
//|                                            ABTG_Confluenza.mqh    |
//|  MOTORE UNICO della "confluenza" EMA + Bollinger + Supertrend.    |
//|                                                                   |
//|  PERCHE' ESISTE: la stessa logica serve a DUE programmi           |
//|    - ABTG_Segnali_EMA_BB_ST.mq5   (indicatore sul grafico)        |
//|    - ABTG_Confluenza_Dashboard.mq5 (pannello multi simbolo x TF)   |
//|  e i due DEVONO dare esattamente lo stesso segnale. Quindi la     |
//|  formula sta in UN SOLO posto (qui) e i due programmi si limitano |
//|  ad alimentarla con le barre. Nessuna formula duplicata.          |
//|                                                                   |
//|  SOLA LETTURA / CALCOLO: nessuna operazione di trading, nessun    |
//|  handle di indicatori, nessuna chiamata al terminale. Solo        |
//|  aritmetica su open/high/low/close/tick_volume.                   |
//|                                                                   |
//|  COME SI USA (stato INCREMENTALE, barra per barra):               |
//|     SConfl e;                                                     |
//|     e.Init(...);                       // parametri               |
//|     for(barre CHIUSE in ordine cronologico, dalla piu' vecchia)   |
//|        e.Feed(open,high,low,close,tick_volume);                   |
//|     // dopo ogni Feed i campi pubblici descrivono LA BARRA APPENA |
//|     // alimentata (ema, bande, atr, supertrend, sigA/sigB, ...).  |
//|  Anteprima della barra IN FORMAZIONE (solo per il disegno):       |
//|     tmp = e;  tmp.Feed(...barra in formazione...);  // e resta    |
//|     // intatto: si legge tmp e lo si butta. Il SEGNALE della barra |
//|     // in formazione NON va mai usato (mai repaint).              |
//|                                                                   |
//|  DEFINIZIONI (tutte sulla barra CHIUSA i; indici in barre):       |
//|   EMA      ricorsiva, alpha=2/(p+1), seme = close della prima     |
//|            barra alimentata (come iMA MODE_EMA). Segnale sulle    |
//|            prime due (veloce 9, lenta 21); 50 e 200 solo disegno. |
//|   Bollinger SMA(close,p) +/- dev*deviazione standard POPOLAZIONE  |
//|            (come iBands). Larghezza w = (alta-bassa)/media.       |
//|   ATR      di WILDER (RMA): seme = media semplice delle prime p   |
//|            true range, poi atr=(atr*(p-1)+tr)/p. Con             |
//|            atrWilder=false usa la SMA del true range (e' quello  |
//|            che fa iATR di MT5, cioe' ABTG_Supertrend.mq5).        |
//|   Supertrend  hl2 +/- mult*ATR con bande che si stringono e      |
//|            flip a chiusura oltre la banda: STESSE REGOLE di       |
//|            ABTG_Supertrend.mq5 (definizione di casa). ATTENZIONE: |
//|            e' IDENTICO a quel file (dopo il riscaldamento) SOLO   |
//|            con atrWilder=false (ATR = SMA del TR, come iATR). Col |
//|            default atrWilder=true (ATR di Wilder, come il         |
//|            Supertrend di TradingView) i flip possono cadere su    |
//|            barre diverse da ABTG_Supertrend.mq5 messo sullo       |
//|            stesso grafico.                                        |
//|                                                                   |
//|   (a) ESPANSIONE  w[i] > w[i-K]*(1+pct/100), K=bbExpandBars.     |
//|   (b) INCROCIO    EMA veloce/lenta: un incrocio (prev<=, ora >)   |
//|         nella direzione, sulla barra o nelle crossLB barre prima, |
//|         E la veloce e' ancora dal lato giusto della lenta.        |
//|         (Un incrocio ESATTAMENTE sulla barra di tutte le altre    |
//|         condizioni e' troppo raro: la finestra lo rende usabile.) |
//|   (c) PENDENZA    veloce E lenta entrambe crescenti (long) o      |
//|         decrescenti (short) per slopeBars barre consecutive.      |
//|   (d) ROTTURA ST  flip del Supertrend nella direzione sulla       |
//|         barra o nelle breakLB barre prima, e direzione ancora     |
//|         quella.                                                   |
//|   (e) VOLUME      tick_volume > SMA(tick_volume,volPeriod)*       |
//|         volFactor (SMA inclusiva della barra stessa). E' il       |
//|         volume TICK, non il volume reale (vedi ABTG_Volume_Filtro).|
//|                                                                   |
//|  DUE VARIANTI DI SEGNALE, calcolate insieme (cosi' il tasto       |
//|  VOLUME dell'indicatore e l'input della dashboard scelgono solo   |
//|  quale leggere, senza ricalcolare nulla):                         |
//|     sigA  = (a)(b)(c)(d)            [filtro volume SPENTO]        |
//|     sigB  = (a)(b)(c)(d)(e)         [filtro volume ACCESO]        |
//|  Ogni variante: trigger A FRONTE (un segnale solo quando          |
//|  l'insieme diventa vero: cond[i] vera e cond[i-1] falsa) piu'     |
//|  raffreddamento (nessun altro segnale nella stessa direzione      |
//|  nelle cooldown barre precedenti). Valore: +1 BUY, -1 SELL, 0.    |
//|                                                                   |
//|  DIAGNOSTICA: maskL/maskS = bit delle condizioni SODDISFATTE      |
//|  sulla barra (ABTGC_F_*). Cio' che manca = ABTGC_F_ALL & ~mask.   |
//|                                                                   |
//|  LIMITI DICHIARATI: parametri clampati in Init (periodi BB/ATR/   |
//|  volume 1..120, EMA 1..5000, lookback 0..100) perche' lo storico  |
//|  e' un anello di 128 barre (le EMA sono ricorsive, non usano      |
//|  l'anello oltre la barra precedente).                             |
//|  Il Supertrend e' path-dipendente: due alimentazioni con partenza |
//|  diversa (es. storico intero vs ultime 600 barre) convergono ma   |
//|  non sono garantite identiche nelle PRIME barre: per questo i     |
//|  segnali partono solo dopo pWarm barre (>=120) dalla partenza.    |
//|                                                                   |
//|  Installazione: copia in MQL5\Include\ (NON in Indicators).       |
//+------------------------------------------------------------------+
#ifndef ABTG_CONFLUENZA_MQH
#define ABTG_CONFLUENZA_MQH

#define ABTGC_RING    128     // profondita' dell'anello di storico (barre)
#define ABTGC_RING2   256     // 2 varianti x anello

//--- bit delle condizioni (diagnostica)
#define ABTGC_F_EXP   1
#define ABTGC_F_CROSS 2
#define ABTGC_F_SLOPE 4
#define ABTGC_F_BREAK 8
#define ABTGC_F_VOL   16
#define ABTGC_F_BASE  15      // le quattro condizioni di base (a)(b)(c)(d)
#define ABTGC_F_ALL   31      // base + volume

//--- default UNICI (indicatore e dashboard li usano come default degli input)
#define ABTGC_D_EMA_FAST     9
#define ABTGC_D_EMA_SLOW     21
#define ABTGC_D_EMA_3        50
#define ABTGC_D_EMA_4        200
#define ABTGC_D_BB_PERIOD    20
#define ABTGC_D_BB_DEV       2.0
#define ABTGC_D_BB_EXP_BARS  3
#define ABTGC_D_BB_EXP_PCT   0.0
#define ABTGC_D_ATR_PERIOD   10
#define ABTGC_D_ST_MULT      3.0
#define ABTGC_D_CROSS_LB     3
#define ABTGC_D_SLOPE_BARS   2
#define ABTGC_D_BREAK_LB     3
#define ABTGC_D_COOLDOWN     5
#define ABTGC_D_VOL_PERIOD   20
#define ABTGC_D_VOL_FACTOR   1.0

//+------------------------------------------------------------------+
//| Clamp di un intero; segnala se ha corretto qualcosa               |
//+------------------------------------------------------------------+
int AbtgcClampInt(const int v, const int lo, const int hi, bool &changed)
  {
   if(v < lo) { changed = true; return lo; }
   if(v > hi) { changed = true; return hi; }
   return v;
  }

//+------------------------------------------------------------------+
//| Testo dei bit di una maschera (solo ASCII), per log/tooltip       |
//+------------------------------------------------------------------+
string AbtgcMaskText(const int m)
  {
   string s = "";
   if((m & ABTGC_F_EXP)   != 0) s += "EXP ";
   if((m & ABTGC_F_CROSS) != 0) s += "CROSS ";
   if((m & ABTGC_F_SLOPE) != 0) s += "SLOPE ";
   if((m & ABTGC_F_BREAK) != 0) s += "BREAK ";
   if((m & ABTGC_F_VOL)   != 0) s += "VOL ";
   if(StringLen(s) == 0) s = "-";
   return s;
  }

//+------------------------------------------------------------------+
//| Struct a STATO INCREMENTALE (POD: niente stringhe, niente array   |
//| dinamici, niente costruttori -> copiabile con l'assegnazione).    |
//+------------------------------------------------------------------+
struct SConfl
  {
   //--- parametri (dopo Init)
   int    pEmaFast, pEmaSlow, pEma3, pEma4;
   int    pBBPeriod;
   double pBBDev;
   int    pBBExpandBars;
   double pBBExpandPct;
   int    pAtrPeriod;
   double pStMult;
   bool   pAtrWilder;
   int    pCrossLB, pSlopeBars, pBreakLB, pCooldown;
   int    pVolPeriod;
   double pVolFactor;
   int    pWarm;              // barre alimentate prima che i segnali siano validi

   //--- stato ricorsivo
   int    n;                  // barre alimentate finora (barra corrente = n-1)
   int    idx;                // indice della barra appena alimentata
   double a1, a2, a3, a4;     // alpha delle EMA
   double e1, e2, e3, e4;     // valori EMA sulla barra corrente
   double atr, atrSum, prevClose;
   double stUp, stDn;
   int    stDir;              // +1 rialzista, -1 ribassista, 0 = non pronto

   //--- anelli di storico (posizione = indice barra % ABTGC_RING)
   double closeR[ABTGC_RING];
   double trR[ABTGC_RING];
   double volR[ABTGC_RING];
   double bbwR[ABTGC_RING];
   double e1R[ABTGC_RING];
   double e2R[ABTGC_RING];
   int    dirR[ABTGC_RING];
   int    condL[ABTGC_RING2]; // [variante*RING + pos]
   int    condS[ABTGC_RING2];
   int    sigR[ABTGC_RING2];

   //--- USCITE sulla barra corrente (valide dopo Feed)
   bool   okE1, okE2, okE3, okE4;   // EMA pronte (n >= periodo)
   bool   okBB, okATR, okST;
   double bbUp, bbMid, bbLo, bbw;
   double stVal;                    // valore del Supertrend (banda attiva)
   double volMa;
   bool   volPass;                  // (e) sulla barra
   int    maskL, maskS;             // condizioni soddisfatte (ABTGC_F_*), 0 se non pronto
   int    sigA, sigB;               // segnale barra corrente: variante senza / con volume
   int    lastNo[2];                // indice dell'ultimo segnale per variante (-1 = nessuno)
   int    lastDir[2];               // direzione dell'ultimo segnale per variante

   //+---------------------------------------------------------------+
   //| Azzera lo STATO (non i parametri): si riparte da zero barre    |
   //+---------------------------------------------------------------+
   void Reset()
     {
      n = 0;  idx = -1;
      e1 = 0.0; e2 = 0.0; e3 = 0.0; e4 = 0.0;
      atr = 0.0; atrSum = 0.0; prevClose = 0.0;
      stUp = 0.0; stDn = 0.0; stDir = 0;
      ArrayInitialize(closeR, 0.0);
      ArrayInitialize(trR, 0.0);
      ArrayInitialize(volR, 0.0);
      ArrayInitialize(bbwR, 0.0);
      ArrayInitialize(e1R, 0.0);
      ArrayInitialize(e2R, 0.0);
      ArrayInitialize(dirR, 0);
      ArrayInitialize(condL, 0);
      ArrayInitialize(condS, 0);
      ArrayInitialize(sigR, 0);
      okE1 = false; okE2 = false; okE3 = false; okE4 = false;
      okBB = false; okATR = false; okST = false;
      bbUp = 0.0; bbMid = 0.0; bbLo = 0.0; bbw = 0.0;
      stVal = 0.0; volMa = 0.0; volPass = false;
      maskL = 0; maskS = 0; sigA = 0; sigB = 0;
      lastNo[0] = -1;  lastNo[1] = -1;
      lastDir[0] = 0;  lastDir[1] = 0;
     }

   //+---------------------------------------------------------------+
   //| Parametri + azzeramento. Ritorna false se ha dovuto CORREGGERE |
   //| qualche parametro (i valori usati sono comunque quelli clampati)|
   //+---------------------------------------------------------------+
   bool Init(const int emaFast, const int emaSlow, const int ema3, const int ema4,
             const int bbPeriod, const double bbDev, const int bbExpandBars, const double bbExpandPct,
             const int atrPeriod, const double stMult, const bool atrWilder,
             const int crossLB, const int slopeBars, const int breakLB, const int cooldown,
             const int volPeriod, const double volFactor)
     {
      bool ch = false;
      pEmaFast      = AbtgcClampInt(emaFast, 1, 5000, ch);
      pEmaSlow      = AbtgcClampInt(emaSlow, 1, 5000, ch);
      pEma3         = AbtgcClampInt(ema3,    1, 5000, ch);
      pEma4         = AbtgcClampInt(ema4,    1, 5000, ch);
      pBBPeriod     = AbtgcClampInt(bbPeriod, 2, 120, ch);
      pBBExpandBars = AbtgcClampInt(bbExpandBars, 1, 100, ch);
      pAtrPeriod    = AbtgcClampInt(atrPeriod, 1, 120, ch);
      pCrossLB      = AbtgcClampInt(crossLB, 0, 100, ch);
      pSlopeBars    = AbtgcClampInt(slopeBars, 1, 100, ch);
      pBreakLB      = AbtgcClampInt(breakLB, 0, 100, ch);
      pCooldown     = AbtgcClampInt(cooldown, 0, 100, ch);
      pVolPeriod    = AbtgcClampInt(volPeriod, 1, 120, ch);
      pBBDev        = bbDev;
      if(pBBDev <= 0.0) { pBBDev = 2.0; ch = true; }
      pBBExpandPct  = bbExpandPct;
      if(pBBExpandPct < 0.0) { pBBExpandPct = 0.0; ch = true; }
      pStMult       = stMult;
      if(pStMult <= 0.0) { pStMult = 3.0; ch = true; }
      pAtrWilder    = atrWilder;
      pVolFactor    = volFactor;
      if(pVolFactor <= 0.0) { pVolFactor = 1.0; ch = true; }

      // warm-up: tutte le finestre + tutti i lookback + margine per la convergenza
      int lb = pBBExpandBars;
      if(pCrossLB + 1 > lb)   lb = pCrossLB + 1;
      if(pSlopeBars + 1 > lb) lb = pSlopeBars + 1;
      if(pBreakLB + 1 > lb)   lb = pBreakLB + 1;
      if(pCooldown > lb)      lb = pCooldown;
      int w = 120;
      if(4 * pEmaSlow > w)      w = 4 * pEmaSlow;
      if(pBBPeriod + lb > w)    w = pBBPeriod + lb;
      if(pAtrPeriod + lb > w)   w = pAtrPeriod + lb;
      if(pVolPeriod + lb > w)   w = pVolPeriod + lb;
      pWarm = w + 3;

      a1 = 2.0 / (pEmaFast + 1.0);
      a2 = 2.0 / (pEmaSlow + 1.0);
      a3 = 2.0 / (pEma3 + 1.0);
      a4 = 2.0 / (pEma4 + 1.0);
      Reset();
      return !ch;
     }

   //--- (a) espansione delle bande sulla barra i
   bool ExpOk(const int i)
     {
      int j = i - pBBExpandBars;
      if(j < 0) return false;
      double wOld = bbwR[j % ABTGC_RING];
      if(wOld <= 0.0) return false;
      return (bbwR[i % ABTGC_RING] > wOld * (1.0 + pBBExpandPct / 100.0));
     }

   //--- (b) incrocio veloce/lenta nella direzione dir entro crossLB barre
   bool CrossOk(const int i, const int dir)
     {
      int ri = i % ABTGC_RING;
      if(dir > 0 && !(e1R[ri] > e2R[ri])) return false;
      if(dir < 0 && !(e1R[ri] < e2R[ri])) return false;
      for(int j = i - pCrossLB; j <= i; j++)
        {
         if(j < 1) continue;
         int rj = j % ABTGC_RING;
         int rp = (j - 1) % ABTGC_RING;
         if(dir > 0 && e1R[rp] <= e2R[rp] && e1R[rj] > e2R[rj]) return true;
         if(dir < 0 && e1R[rp] >= e2R[rp] && e1R[rj] < e2R[rj]) return true;
        }
      return false;
     }

   //--- (c) pendenza: veloce E lenta monotone per slopeBars barre
   bool SlopeOk(const int i, const int dir)
     {
      for(int s = 0; s < pSlopeBars; s++)
        {
         int k = i - s;
         if(k < 1) return false;
         int rk = k % ABTGC_RING;
         int rp = (k - 1) % ABTGC_RING;
         if(dir > 0 && !(e1R[rk] > e1R[rp] && e2R[rk] > e2R[rp])) return false;
         if(dir < 0 && !(e1R[rk] < e1R[rp] && e2R[rk] < e2R[rp])) return false;
        }
      return true;
     }

   //--- (d) flip del Supertrend nella direzione entro breakLB barre
   bool BreakOk(const int i, const int dir)
     {
      if(dirR[i % ABTGC_RING] != dir) return false;
      for(int j = i - pBreakLB; j <= i; j++)
        {
         if(j < 1) continue;
         int rj = j % ABTGC_RING;
         int rp = (j - 1) % ABTGC_RING;
         if(dir > 0 && dirR[rj] > 0 && dirR[rp] < 0) return true;
         if(dir < 0 && dirR[rj] < 0 && dirR[rp] > 0) return true;
        }
      return false;
     }

   //--- raffreddamento: un segnale nella stessa direzione nelle cooldown barre prima?
   bool Recent(const int v, const int dir, const int i)
     {
      for(int k = 1; k <= pCooldown; k++)
        {
         if(i - k < 0) break;
         if(sigR[v * ABTGC_RING + ((i - k) % ABTGC_RING)] == dir) return true;
        }
      return false;
     }

   //+---------------------------------------------------------------+
   //| Alimenta UNA barra CHIUSA (ordine cronologico, senza buchi)    |
   //+---------------------------------------------------------------+
   void Feed(const double o, const double h, const double l, const double c, const double v)
     {
      const int i = n;
      const int r = i % ABTGC_RING;
      n   = i + 1;
      idx = i;

      //--- EMA (seme = close della prima barra)
      if(i == 0)
        {
         e1 = c; e2 = c; e3 = c; e4 = c;
        }
      else
        {
         e1 += a1 * (c - e1);
         e2 += a2 * (c - e2);
         e3 += a3 * (c - e3);
         e4 += a4 * (c - e4);
        }
      okE1 = (i >= pEmaFast - 1);
      okE2 = (i >= pEmaSlow - 1);
      okE3 = (i >= pEma3 - 1);
      okE4 = (i >= pEma4 - 1);
      e1R[r] = e1;
      e2R[r] = e2;

      //--- Bollinger (SMA e deviazione standard di popolazione)
      closeR[r] = c;
      okBB = (i >= pBBPeriod - 1);
      if(okBB)
        {
         double s = 0.0;
         for(int k = 0; k < pBBPeriod; k++)
            s += closeR[(i - k) % ABTGC_RING];
         double m = s / pBBPeriod;
         double q = 0.0;
         for(int k = 0; k < pBBPeriod; k++)
           {
            double d = closeR[(i - k) % ABTGC_RING] - m;
            q += d * d;
           }
         double sd = MathSqrt(q / pBBPeriod);
         bbMid = m;
         bbUp  = m + pBBDev * sd;
         bbLo  = m - pBBDev * sd;
         bbw   = (m > 0.0) ? (bbUp - bbLo) / m : 0.0;
        }
      else
        {
         bbMid = 0.0; bbUp = 0.0; bbLo = 0.0; bbw = 0.0;
        }
      bbwR[r] = bbw;

      //--- true range e ATR
      double tr = h - l;
      if(i > 0)
        {
         tr = MathMax(tr, MathAbs(h - prevClose));
         tr = MathMax(tr, MathAbs(l - prevClose));
        }
      trR[r] = tr;
      okATR = (i >= pAtrPeriod - 1);
      if(pAtrWilder)
        {
         if(i < pAtrPeriod - 1)       { atrSum += tr; atr = 0.0; }
         else if(i == pAtrPeriod - 1) { atrSum += tr; atr = atrSum / pAtrPeriod; }
         else                         { atr = (atr * (pAtrPeriod - 1) + tr) / pAtrPeriod; }
        }
      else
        {
         atrSum += tr;
         if(i >= pAtrPeriod) atrSum -= trR[(i - pAtrPeriod) % ABTGC_RING];
         atr = okATR ? atrSum / pAtrPeriod : 0.0;
        }

      //--- Supertrend (definizione di casa: ABTG_Supertrend.mq5)
      if(okATR)
        {
         double mid = (h + l) / 2.0;
         double up  = mid + pStMult * atr;
         double dn  = mid - pStMult * atr;
         if(stDir == 0)
           {
            stUp  = up;
            stDn  = dn;
            stDir = (c >= mid) ? 1 : -1;
           }
         else
           {
            double pu = stUp;
            double pd = stDn;
            stUp = (up < pu || prevClose > pu) ? up : pu;
            stDn = (dn > pd || prevClose < pd) ? dn : pd;
            if(stDir > 0) stDir = (c < stDn) ? -1 : 1;
            else          stDir = (c > stUp) ?  1 : -1;
           }
         stVal = (stDir > 0) ? stDn : stUp;
         okST  = true;
        }
      else
        {
         stDir = 0;
         stVal = 0.0;
         okST  = false;
        }
      dirR[r] = stDir;

      //--- volume tick vs media (SMA inclusiva)
      volR[r] = v;
      if(i >= pVolPeriod - 1)
        {
         double sv = 0.0;
         for(int k = 0; k < pVolPeriod; k++)
            sv += volR[(i - k) % ABTGC_RING];
         volMa   = sv / pVolPeriod;
         volPass = (v > volMa * pVolFactor);
        }
      else
        {
         volMa   = 0.0;
         volPass = false;
        }

      //--- segnali (sempre scritti nell'anello, anche a zero)
      sigA = 0; sigB = 0; maskL = 0; maskS = 0;
      for(int vv = 0; vv < 2; vv++)
        {
         condL[vv * ABTGC_RING + r] = 0;
         condS[vv * ABTGC_RING + r] = 0;
         sigR[vv * ABTGC_RING + r]  = 0;
        }
      if(i >= pWarm && okBB && okST)
        {
         int mL = 0, mS = 0;
         if(ExpOk(i))      { mL |= ABTGC_F_EXP;   mS |= ABTGC_F_EXP; }
         if(CrossOk(i, 1))  mL |= ABTGC_F_CROSS;
         if(CrossOk(i, -1)) mS |= ABTGC_F_CROSS;
         if(SlopeOk(i, 1))  mL |= ABTGC_F_SLOPE;
         if(SlopeOk(i, -1)) mS |= ABTGC_F_SLOPE;
         if(BreakOk(i, 1))  mL |= ABTGC_F_BREAK;
         if(BreakOk(i, -1)) mS |= ABTGC_F_BREAK;
         if(volPass)      { mL |= ABTGC_F_VOL;   mS |= ABTGC_F_VOL; }
         maskL = mL;
         maskS = mS;
         bool bL = ((mL & ABTGC_F_BASE) == ABTGC_F_BASE);
         bool bS = ((mS & ABTGC_F_BASE) == ABTGC_F_BASE);
         int  rp = (i - 1) % ABTGC_RING;
         for(int vv = 0; vv < 2; vv++)
           {
            bool cl = bL && (vv == 0 || volPass);
            bool cs = bS && (vv == 0 || volPass);
            condL[vv * ABTGC_RING + r] = cl ? 1 : 0;
            condS[vv * ABTGC_RING + r] = cs ? 1 : 0;
            int s = 0;
            if(cl && condL[vv * ABTGC_RING + rp] == 0 && !Recent(vv, 1, i))
               s = 1;
            else
               if(cs && condS[vv * ABTGC_RING + rp] == 0 && !Recent(vv, -1, i))
                  s = -1;
            sigR[vv * ABTGC_RING + r] = s;
            if(s != 0)
              {
               lastNo[vv]  = i;
               lastDir[vv] = s;
              }
            if(vv == 0) sigA = s;
            else        sigB = s;
           }
        }

      prevClose = c;
     }

   //--- segnale della barra corrente per la variante v (0 = senza volume, 1 = con volume)
   int Sig(const int v)
     {
      return (v == 0) ? sigA : sigB;
     }

   //--- condizioni che MANCANO alla barra corrente per la direzione dir (con/senza volume)
   int Missing(const int dir, const bool useVol)
     {
      int full = ABTGC_F_BASE;
      if(useVol) full = ABTGC_F_ALL;
      int m = (dir > 0) ? maskL : maskS;
      return (full & ~m);
     }
  };

#endif // ABTG_CONFLUENZA_MQH
