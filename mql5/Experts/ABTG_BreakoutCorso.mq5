//+------------------------------------------------------------------+
//|                                          ABTG_BreakoutCorso.mq5   |
//|   STRATEGIA DI BREAKOUT DEL CORSO (Manuela Negro, lezioni 34-40)  |
//|   Implementazione FEDELE alla spec ricostruita dalle 7            |
//|   trascrizioni + le 10 slide del PDF della lezione 40.            |
//|                                                                   |
//|   FONTE VINCOLANTE:                                               |
//|     backtest_pipeline/prove/BREAKOUT_CORSO_SPEC.md                |
//|   REFERTO DI ANALISI:                                             |
//|     backtest_pipeline/caccia_strategie/                           |
//|         ANALISI_CORSO_BREAKOUT_2026-08-18.md                      |
//|                                                                   |
//|   v1.00 - 18/08/2026                                              |
//+------------------------------------------------------------------+
//
//  MAPPA REGOLA <-> CODICE (verificabile riga per riga)
//  ---------------------------------------------------------------------
//  spec | regola del corso                       | dove sta nel codice
//  -----|----------------------------------------|---------------------
//  par.1   | timeframe M15                          | InpTF (default PERIOD_M15)
//  par.2.1 | universo 7 cross JPY                   | fuori dall'EA: file prova
//  par.2.3 | NESSUN filtro orario (esplicito)       | non esiste, per scelta del corso
//  par.3   | Williams %R periodo 140                | InpWilliamsPeriod
//  par.3   | SuperTrend                             | InpSuperTrendATR / InpSuperTrendMult
//       |   [BUCO del corso: parametri MAI detti]|   DECISIONE DI CLAUDIO 18/08:
//       |                                        |   standard ATR 10 / mult 3.0
//  par.3.1 | zone: OB >= -20, OS <= -80             | InpZonaOB / InpZonaOS
//  par.4 R1| rettangolo solo con Williams in zona   | AggiornaZona()
//  par.4 R2| rettangolo di 20 candele               | InpCandeleRettangolo
//  par.4 R4| finestra mobile, ultime N candele      | CalcolaRettangolo()
//  par.4 R5| estremi ASSOLUTI (wick, non corpi)     | iHighest/iLowest su HIGH/LOW
//  par.4 S4| ricalcolo a ogni chiusura di candela   | tutto il motore gira su nuova barra
//  par.4.4 | candela di segnale ESCLUSA             | InpIncludiCandelaRottura (vedi nota)
//  par.4.5 | R7: 20 candele dall'ingresso in zona   | InpAttesaCandeleZona + BarreDaIngresso()
//  par.5.1 | 3 condizioni simultanee sulla candela  | CalcolaSegnale()
//  par.5.2 | OB => SOLO sell, OS => SOLO buy        | CalcolaSegnale()
//  par.6.1 | tutti i livelli dalla CHIUSURA segnale | LivelliDaSegnale()
//  par.6.2 | SL a 1 pip oltre il rettangolo         | InpStopBufferPip
//  par.6.2 | TP = 3R dalla chiusura del segnale     | InpTargetR
//  par.6.3 | pip su JPY = 0,01                      | PipSize() (3/5 digit -> point*10)
//  par.6.4 | R:R minimo 1:2 per ingressi ritardati  | InpMinRR
//  par.6.5 | solo ordini a mercato                  | trade.Buy / trade.Sell
//  par.7.1 | BE a +1R, SL sulla CHIUSURA DEL SEGNALE| GestisciBreakEven()
//  par.7.2 | NESSUN trailing (slide S9)             | non esiste in questo EA
//  par.7.3 | chiusura su segnale contrario  [S8]    | InpChiudiSuSegnaleContrario
//  par.7.4 | "Williams all'estremo opposto"         | InpChiudiSuWilliamsOpposto
//       |   NON e' nel PDF -> default OFF        |   (default false: piu' fedele al PDF)
//  par.8   | rischio 1%                             | InpRiskPercent + InpRischioMode
//  par.8.1 | "1% per operazione" (parlato) vs       | InpRischioMode:
//       | "1% COMPLESSIVO" (slide S10)           |   PER_OPERAZIONE / COMPLESSIVO_FAMIGLIA
//
//  ASSUNZIONI DICHIARATE (non sono "il corso", sono NOSTRE)
//  ---------------------------------------------------------------------
//  A1. SuperTrend ATR 10 / mult 3.0: il corso NON li detta (verificato da
//      Claudio sul video il 18/08). Decisione di Claudio: si tengono gli
//      standard. Routine di calcolo ripresa da ABTG_AltaVelocita.mq5
//      (pattern gia' in casa), non reinventata.
//  A2. InpIncludiCandelaRottura: il corso dice "20 candele COMPRESA, se
//      vogliamo, la candela di rottura" (lez.36) e altrove "le 20 candele
//      che PRECEDONO la candela di rottura". Se la candela di rottura
//      entrasse nel calcolo dei LIVELLI, il suo minimo diventerebbe il
//      minimo del rettangolo e non potrebbe rompere se stessa: la regola
//      si auto-annullerebbe. Percio' qui l'input agisce sul CONTEGGIO,
//      non sugli estremi: con true la candela di segnale conta come
//      ventesima e i livelli si misurano sulle 19 che la precedono.
//      E' l'unica lettura non degenere delle due frasi.
//  A3. InpAnnullaSottoMediana: il corso non dice mai cosa succede se il
//      Williams torna verso il centro senza rottura (BUCO n.9 della spec).
//      Default true = il setup muore quando il Williams supera la mediana.
//  A4. InpUnaOperazionePerZona: il corso non dice se dopo un trade chiuso
//      lo stesso ingresso in zona possa generarne un altro (BUCO n.8).
//      Default false = si puo' rientrare (comportamento del vecchio EA,
//      cosi' il confronto col backtest -20.853 EUR resta leggibile).
//
//  QUELLO CHE QUESTO EA NON FA, e non e' una dimenticanza:
//    - niente trailing stop (la parola "trailing" non compare in nessuna
//      slide: e' un espediente del video, non la strategia);
//    - niente filtro orario / sessioni (il corso lo ESCLUDE esplicitamente);
//    - niente filtro news (il corso non ne ha, e nel suo esempio migliore
//      entra proprio su un rilascio macro);
//    - niente ordini pendenti (il corso li vieta);
//    - una sola posizione per volta su questo simbolo.
//
//  NON COMPILATO NE' BACKTESTATO da chi lo ha scritto: questo ambiente non
//  ha MetaEditor. Si compila con F7 in MetaEditor prima di qualunque corsa.
//+------------------------------------------------------------------+
#property copyright "ABTG - Breakout del corso (spec 18/08/2026)"
#property version   "1.00"
#property description "Breakout Williams %R 140 + SuperTrend | M15 | cross JPY | fedele alla spec del corso"

#include <Trade/Trade.mqh>

//=== ENUM ===========================================================
enum ENUM_ABTG_RISCHIO
  {
   RISCHIO_PER_OPERAZIONE   = 0,   // 1% su OGNI operazione (parlato, lez. 35/37)
   RISCHIO_COMPLESSIVO      = 1    // 1% COMPLESSIVO diviso per i cross (slide S10)
  };

enum ENUM_ABTG_ZONA { ZONA_NESSUNA = 0, ZONA_OB = 1, ZONA_OS = 2 };

//=== INPUT ==========================================================
input group "=== Timeframe e indicatori (spec par.1 e par.3) ==="
input ENUM_TIMEFRAMES InpTF               = PERIOD_M15; // TF operativo (il corso: M15)
input int             InpWilliamsPeriod   = 140;        // Williams %R - periodo (lez.35: 140, confermato da Claudio)
input int             InpSuperTrendATR    = 10;         // SuperTrend - ATR (ASSUNZIONE A1: il corso tace)
input double          InpSuperTrendMult   = 3.0;        // SuperTrend - moltiplicatore (ASSUNZIONE A1)

input group "=== Zone e bande del Williams (spec par.3.1 e par.5.1) ==="
input double          InpZonaOB           = -20.0;      // soglia ipercomprato (W >= soglia)
input double          InpZonaOS           = -80.0;      // soglia ipervenduto (W <= soglia)
input double          InpMediana          = -50.0;      // linea mediana del Williams

input group "=== Rettangolo di congestione (spec par.4) ==="
input int             InpCandeleRettangolo    = 20;     // candele del rettangolo (asse di disambiguazione: 15 o 20)
input bool            InpIncludiCandelaRottura= false;  // la candela di rottura conta fra le 20 (ASSUNZIONE A2)
input bool            InpAttesaCandeleZona    = true;   // R7: attendi N candele dall'ingresso in zona (spec par.4.5)
input int             InpCandeleAttesa        = 0;      // candele di attesa (0 = usa InpCandeleRettangolo)
input bool            InpAnnullaSottoMediana  = true;   // il setup muore se il Williams supera la mediana (ASSUNZIONE A3)

input group "=== Livelli: ingresso, stop, target (spec par.6) ==="
input double          InpStopBufferPip    = 1.0;        // pip oltre il rettangolo per lo stop (lez.37/40: 1 pip)
input double          InpTargetR          = 3.0;        // target in R dalla chiusura del segnale (lez.40: 3)
input double          InpMinRR            = 2.0;        // R:R minimo per entrare (lez.37/40: 1:2)

input group "=== Gestione dell'operazione (spec par.7) ==="
input bool            InpBreakEven1R          = true;   // stop sulla CHIUSURA DEL SEGNALE dopo +1R
input bool            InpChiudiSuSegnaleContrario = true; // slide S8: e' un obbligo, non una facolta'
input bool            InpApriSuSegnaleContrario   = true; // il segnale che chiude e' anche un segnale che apre
input bool            InpChiudiSuWilliamsOpposto  = false;// spec par.7.4: NON e' nel PDF -> default OFF
input bool            InpUnaOperazionePerZona     = false;// una sola operazione per ingresso in zona (ASSUNZIONE A4)

input group "=== Rischio (spec par.8) ==="
input ENUM_ABTG_RISCHIO InpRischioMode    = RISCHIO_PER_OPERAZIONE; // le due letture della stessa regola
input double          InpRiskPercent      = 1.0;        // rischio % (per operazione o complessivo)
input int             InpCrossFamiglia    = 7;          // divisore in modalita' COMPLESSIVO (i 7 cross JPY)

input group "=== Igiene di esecuzione ==="
input double          InpMaxSpreadPip     = 3.0;        // spread massimo in pip per entrare (0 = nessun filtro)
input int             InpSlippagePoint    = 20;         // deviazione massima in punti
input bool            InpAutoTest         = true;       // stampa il test-case numerico del corso in OnInit

input group "=== EA ==="
input long            InpMagic            = 779100;     // magic number
input string          InpComment          = "BRKCORSO"; // commento degli ordini
input bool            InpLog              = false;      // log verboso (spegnere nelle griglie)

//=== COSTANTI =======================================================
#define ST_BARRE   300      // barre di calcolo del SuperTrend (warm-up abbondante)
#define ST_MINIME  120      // sotto questa soglia il SuperTrend non e' affidabile

//=== STATO GLOBALE ==================================================
CTrade          gTrade;
int             gWprHandle  = INVALID_HANDLE;
int             gAtrHandle  = INVALID_HANDLE;
datetime        gUltimaBarra = 0;

ENUM_ABTG_ZONA  gZona            = ZONA_NESSUNA;
datetime        gTimeIngressoZona = 0;      // candela del PRIMO ingresso del Williams in zona
bool            gSetupConsumato   = false;  // usato solo se InpUnaOperazionePerZona

// livelli dell'operazione in corso: TUTTI ancorati alla candela di segnale
double          gSigClose   = 0.0;   // chiusura della candela di segnale (= livello di BE)
double          gSigSL      = 0.0;   // stop teorico (1 pip oltre il rettangolo)
double          gSigTP      = 0.0;   // target 3R dalla chiusura del segnale
double          gSigR       = 0.0;   // 1R in prezzo
bool            gBeFatto    = false;
ulong           gTicket     = 0;

//+------------------------------------------------------------------+
//| OnInit                                                            |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpCandeleRettangolo < 3)
     { Print("[BRK] InpCandeleRettangolo troppo piccolo: ", InpCandeleRettangolo); return(INIT_PARAMETERS_INCORRECT); }
   if(InpWilliamsPeriod < 2 || InpSuperTrendATR < 2)
     { Print("[BRK] periodi indicatori non validi."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpZonaOB <= InpMediana || InpZonaOS >= InpMediana)
     { Print("[BRK] zone/mediana incoerenti (attese OB > mediana > OS)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpRiskPercent <= 0.0)
     { Print("[BRK] rischio non valido."); return(INIT_PARAMETERS_INCORRECT); }

   gWprHandle = iWPR(_Symbol, InpTF, InpWilliamsPeriod);
   gAtrHandle = iATR(_Symbol, InpTF, InpSuperTrendATR);
   if(gWprHandle == INVALID_HANDLE || gAtrHandle == INVALID_HANDLE)
     { Print("[BRK] errore handle indicatori: ", GetLastError()); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber((ulong)InpMagic);
   gTrade.SetDeviationInPoints(InpSlippagePoint);
   gTrade.SetTypeFilling(FillingBroker());

   gUltimaBarra      = 0;
   gZona             = ZONA_NESSUNA;
   gTimeIngressoZona = 0;
   gSetupConsumato   = false;
   AzzeraLivelli();

   if(InpAutoTest) TestCasoDelCorso();

   PrintFormat("[BRK] v1.00 %s %s | W%d | ST %d/%.2f | rett %d (rottura dentro:%s) | attesa:%s | rischio %.3f%% (%s) | magic %I64d",
               _Symbol, EnumToString(InpTF), InpWilliamsPeriod, InpSuperTrendATR, InpSuperTrendMult,
               InpCandeleRettangolo, (InpIncludiCandelaRottura ? "si" : "no"),
               (InpAttesaCandeleZona ? "si" : "no"), RischioEffettivo(),
               (InpRischioMode == RISCHIO_COMPLESSIVO ? "complessivo" : "per operazione"), InpMagic);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| OnDeinit                                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(gWprHandle != INVALID_HANDLE) { IndicatorRelease(gWprHandle); gWprHandle = INVALID_HANDLE; }
   if(gAtrHandle != INVALID_HANDLE) { IndicatorRelease(gAtrHandle); gAtrHandle = INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| OnTick                                                            |
//|  - il BREAK-EVEN si controlla a ogni tick (il prezzo puo'         |
//|    raggiungere +1R in mezzo alla candela);                        |
//|  - il SEGNALE si valuta SOLO a candela chiusa (slide S4: il       |
//|    rettangolo si aggiorna a ogni chiusura di candela).            |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(InpBreakEven1R && SelezionaPosizione()) GestisciBreakEven();

   datetime tBarra = iTime(_Symbol, InpTF, 0);
   if(tBarra == 0 || tBarra == gUltimaBarra) return;
   gUltimaBarra = tBarra;

   int barreServono = InpWilliamsPeriod + InpCandeleRettangolo + ST_BARRE + 5;
   if(Bars(_Symbol, InpTF) < barreServono) return;

   //--- Williams sulla candela di segnale (shift 1 = ultima chiusa)
   double W = 0.0;
   if(!LeggiWilliams(W)) return;

   //--- SuperTrend sulla candela di segnale
   double stDir = 0.0;
   if(!DirezioneSuperTrend(stDir)) return;

   //--- se la posizione e' sparita (SL/TP) si azzerano i livelli
   if(!SelezionaPosizione() && gSigClose != 0.0) AzzeraLivelli();

   //--- stato della zona del Williams (spec par.4 R1/R3)
   AggiornaZona(W);

   //--- segnale della candela appena chiusa
   int    dirSeg = 0;
   double sl = 0.0, tp = 0.0, R = 0.0, chiusura = 0.0;
   bool   segnale = CalcolaSegnale(W, stDir, dirSeg, chiusura, sl, tp, R);

   //--- POSIZIONE APERTA: le uscite del corso (oltre a SL e TP)
   if(SelezionaPosizione())
     {
      long tipo = PositionGetInteger(POSITION_TYPE);

      // spec par.7.4 - NON e' nel PDF: default OFF, resta come asse A/B dichiarato
      if(InpChiudiSuWilliamsOpposto)
        {
         if(tipo == POSITION_TYPE_SELL && W <= InpZonaOS) { Chiudi("Williams all'estremo opposto"); return; }
         if(tipo == POSITION_TYPE_BUY  && W >= InpZonaOB) { Chiudi("Williams all'estremo opposto"); return; }
        }

      // slide S8: l'operazione SI CHIUDE su segnale direzionale contrario
      if(InpChiudiSuSegnaleContrario && segnale &&
         ((tipo == POSITION_TYPE_SELL && dirSeg > 0) || (tipo == POSITION_TYPE_BUY && dirSeg < 0)))
        {
         Chiudi("segnale direzionale contrario");
         if(InpApriSuSegnaleContrario) Apri(dirSeg, chiusura, sl, tp, R);
         return;
        }
      return;   // niente trailing: si tiene fino a SL / TP / segnale contrario
     }

   //--- NESSUNA POSIZIONE: apertura
   if(segnale && !(InpUnaOperazionePerZona && gSetupConsumato))
      Apri(dirSeg, chiusura, sl, tp, R);
  }

//+------------------------------------------------------------------+
//| Williams %R sulla candela di segnale (shift 1)                    |
//+------------------------------------------------------------------+
bool LeggiWilliams(double &W)
  {
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(gWprHandle, 0, 0, 3, buf) < 3) return(false);
   W = buf[1];
   return(true);
  }

//+------------------------------------------------------------------+
//| SuperTrend classico: hl2 +/- mult*ATR con bande che si stringono. |
//| Routine ripresa da ABTG_AltaVelocita.mq5 (pattern gia' in casa).  |
//| Restituisce la DIREZIONE sulla candela di segnale (shift 1):      |
//|   +1 = verde/rialzista, -1 = rosso/ribassista.                    |
//+------------------------------------------------------------------+
bool DirezioneSuperTrend(double &dirOut)
  {
   double atr[];
   ArraySetAsSeries(atr, true);
   int gotA = CopyBuffer(gAtrHandle, 0, 0, ST_BARRE, atr);
   if(gotA < ST_MINIME) return(false);

   MqlRates r[];
   ArraySetAsSeries(r, true);
   int gotR = CopyRates(_Symbol, InpTF, 0, gotA, r);
   if(gotR < gotA) return(false);          // serie disallineate: si riprova alla barra dopo

   double finalUpper = 0.0, finalLower = 0.0;
   int    dir = +1;
   for(int i = gotA - 2; i >= 1; i--)      // dalla piu' vecchia utile alla candela di segnale
     {
      double hl2 = (r[i].high + r[i].low) / 2.0;
      double bUp = hl2 + InpSuperTrendMult * atr[i];
      double bLo = hl2 - InpSuperTrendMult * atr[i];
      double prevFU = (finalUpper == 0.0) ? bUp : finalUpper;
      double prevFL = (finalLower == 0.0) ? bLo : finalLower;
      double pc = r[i + 1].close;
      double fU = (bUp < prevFU || pc > prevFU) ? bUp : prevFU;
      double fL = (bLo > prevFL || pc < prevFL) ? bLo : prevFL;
      if(r[i].close > (dir == -1 ? prevFU : fU))      dir = +1;
      else if(r[i].close < (dir == +1 ? prevFL : fL)) dir = -1;
      finalUpper = fU;
      finalLower = fL;
     }
   dirOut = (double)dir;
   return(true);
  }

//+------------------------------------------------------------------+
//| Stato della zona del Williams (spec par.4 R1/R3 e ASSUNZIONE A3)     |
//| L'ancoraggio e' il PRIMO ingresso in zona: da li' si contano le   |
//| candele dell'attesa (spec par.4.5).                                  |
//+------------------------------------------------------------------+
void AggiornaZona(double W)
  {
   datetime tSeg = iTime(_Symbol, InpTF, 1);

   if(W >= InpZonaOB)
     {
      if(gZona != ZONA_OB)
        {
         gZona = ZONA_OB;
         gTimeIngressoZona = tSeg;
         gSetupConsumato = false;
         if(InpLog) PrintFormat("[BRK] ingresso IPERCOMPRATO W=%.1f", W);
        }
      return;
     }
   if(W <= InpZonaOS)
     {
      if(gZona != ZONA_OS)
        {
         gZona = ZONA_OS;
         gTimeIngressoZona = tSeg;
         gSetupConsumato = false;
         if(InpLog) PrintFormat("[BRK] ingresso IPERVENDUTO W=%.1f", W);
        }
      return;
     }
   if(!InpAnnullaSottoMediana) return;
   if(gZona == ZONA_OB && W <= InpMediana)
     { gZona = ZONA_NESSUNA; gTimeIngressoZona = 0; if(InpLog) PrintFormat("[BRK] setup OB annullato W=%.1f", W); }
   else if(gZona == ZONA_OS && W >= InpMediana)
     { gZona = ZONA_NESSUNA; gTimeIngressoZona = 0; if(InpLog) PrintFormat("[BRK] setup OS annullato W=%.1f", W); }
  }

//+------------------------------------------------------------------+
//| Candele trascorse DOPO la candela di ingresso in zona, contate    |
//| fino alla candela di segnale compresa (spec par.4.5).                |
//+------------------------------------------------------------------+
int BarreDaIngressoZona()
  {
   if(gTimeIngressoZona == 0) return(-1);
   int shiftIngresso = iBarShift(_Symbol, InpTF, gTimeIngressoZona, false);
   if(shiftIngresso < 0) return(-1);
   return(shiftIngresso - 1);      // shift 1 = candela di segnale
  }

//+------------------------------------------------------------------+
//| Rettangolo di congestione (spec par.4, ASSUNZIONE A2).               |
//| I LIVELLI si misurano SEMPRE su candele chiuse che PRECEDONO la   |
//| candela di segnale (shift >= 2): altrimenti la candela di rottura |
//| non potrebbe rompere se stessa.                                   |
//| InpIncludiCandelaRottura agisce sul CONTEGGIO: se true, la        |
//| candela di segnale conta come ventesima e i livelli si prendono   |
//| sulle 19 precedenti.                                              |
//+------------------------------------------------------------------+
bool CalcolaRettangolo(double &alto, double &basso)
  {
   int n = InpCandeleRettangolo - (InpIncludiCandelaRottura ? 1 : 0);
   if(n < 2) return(false);
   int iH = iHighest(_Symbol, InpTF, MODE_HIGH, n, 2);
   int iL = iLowest (_Symbol, InpTF, MODE_LOW,  n, 2);
   if(iH < 0 || iL < 0) return(false);
   alto  = iHigh(_Symbol, InpTF, iH);
   basso = iLow (_Symbol, InpTF, iL);
   return(alto > basso);
  }

//+------------------------------------------------------------------+
//| Livelli dell'operazione, TUTTI dalla chiusura della candela di    |
//| segnale (spec par.6.1). Funzione PURA: e' quella che il test-case    |
//| numerico del corso deve riprodurre.                               |
//+------------------------------------------------------------------+
void LivelliDaSegnale(bool isSell, double rettAlto, double rettBasso, double chiusura,
                      double pip, double &sl, double &tp, double &R)
  {
   if(isSell)
     {
      sl = rettAlto + InpStopBufferPip * pip;
      R  = MathAbs(chiusura - sl);
      tp = chiusura - InpTargetR * R;
     }
   else
     {
      sl = rettBasso - InpStopBufferPip * pip;
      R  = MathAbs(chiusura - sl);
      tp = chiusura + InpTargetR * R;
     }
  }

//+------------------------------------------------------------------+
//| SEGNALE (spec par.5.1): le TRE condizioni, simultanee, sulla candela |
//| di segnale. In piu' il vincolo R7 delle candele di attesa.        |
//+------------------------------------------------------------------+
bool CalcolaSegnale(double W, double stDir, int &dir, double &chiusura,
                    double &sl, double &tp, double &R)
  {
   dir = 0;
   if(gZona == ZONA_NESSUNA) return(false);

   // spec par.4.5 - il vincolo che il vecchio EA NON aveva
   if(InpAttesaCandeleZona)
     {
      int attesa = (InpCandeleAttesa > 0 ? InpCandeleAttesa : InpCandeleRettangolo);
      int passate = BarreDaIngressoZona();
      if(passate < attesa) return(false);
     }

   double alto = 0.0, basso = 0.0;
   if(!CalcolaRettangolo(alto, basso)) return(false);

   chiusura = iClose(_Symbol, InpTF, 1);
   if(chiusura <= 0.0) return(false);

   bool sell = (gZona == ZONA_OB) &&           // par.5.2: ipercomprato => SOLO sell
               (chiusura < basso)  &&          // C1: chiusura sotto il minimo del rettangolo
               (stDir < 0)         &&          // C2: SuperTrend rosso
               (W < InpZonaOB)     && (W > InpMediana);   // C3: uscito, ma fra -50 e -20

   bool buy  = (gZona == ZONA_OS) &&           // par.5.2: ipervenduto => SOLO buy
               (chiusura > alto)   &&          // C1: chiusura sopra il massimo del rettangolo
               (stDir > 0)         &&          // C2: SuperTrend verde
               (W > InpZonaOS)     && (W < InpMediana);   // C3: uscito, ma fra -80 e -50

   if(!sell && !buy) return(false);

   dir = (sell ? -1 : +1);
   LivelliDaSegnale(sell, alto, basso, chiusura, PipSize(), sl, tp, R);
   return(R > 0.0);
  }

//+------------------------------------------------------------------+
//| Apertura a mercato (spec par.6.5): il corso vieta i pendenti.        |
//| SL e TP restano quelli ancorati alla candela di segnale.          |
//+------------------------------------------------------------------+
void Apri(int dir, double chiusura, double sl, double tp, double R)
  {
   if(dir == 0 || R <= 0.0) return;

   // Guardia: una sola posizione per volta. Serve davvero, perche' Apri()
   // viene chiamata subito dopo Chiudi() sul segnale contrario: se quella
   // chiusura fosse fallita, su un conto HEDGING (il nostro) resterebbero
   // aperte due posizioni opposte.
   if(SelezionaPosizione())
     { if(InpLog) Print("[BRK] posizione gia' aperta: niente ingresso."); return; }

   bool isSell = (dir < 0);

   //--- filtro spread
   double pip = PipSize();
   if(InpMaxSpreadPip > 0.0 && pip > 0.0)
     {
      double sp = (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) / pip;
      if(sp > InpMaxSpreadPip)
        { if(InpLog) PrintFormat("[BRK] spread %.2f pip > %.2f: salto.", sp, InpMaxSpreadPip); return; }
     }

   double prezzo = isSell ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if(prezzo <= 0.0) return;

   //--- lo stop deve stare dalla parte giusta del prezzo, sempre
   if(( isSell && prezzo >= sl) || (!isSell && prezzo <= sl))
     { if(InpLog) Print("[BRK] prezzo gia' oltre lo stop: salto."); return; }

   //--- R:R minimo dal prezzo VERO (spec par.6.4): SL e TP non si ricalcolano
   double dSL = MathAbs(prezzo - sl);
   double dTP = MathAbs(tp - prezzo);
   if(dSL <= 0.0) return;
   if(( isSell && tp >= prezzo) || (!isSell && tp <= prezzo))
     { if(InpLog) Print("[BRK] target gia' superato: salto."); return; }
   double rr = dTP / dSL;
   if(rr < InpMinRR)
     { if(InpLog) PrintFormat("[BRK] R:R %.2f < %.2f: salto.", rr, InpMinRR); return; }

   //--- vincoli del broker su distanza minima di SL/TP
   double minDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   if(minDist > 0.0 && (dSL < minDist || dTP < minDist))
     { if(InpLog) Print("[BRK] SL/TP dentro lo STOPS_LEVEL: salto."); return; }

   //--- volume dal rischio, misurato sulla distanza REALE prezzo-stop (lez.37)
   double lotti = LottoDaRischio(dSL);
   if(lotti <= 0.0)
     { if(InpLog) Print("[BRK] volume non calcolabile: salto."); return; }

   double slN = NormalizeDouble(sl, _Digits);
   double tpN = NormalizeDouble(tp, _Digits);

   bool ok = isSell ? gTrade.Sell(lotti, _Symbol, 0.0, slN, tpN, InpComment)
                    : gTrade.Buy (lotti, _Symbol, 0.0, slN, tpN, InpComment);
   uint rc = gTrade.ResultRetcode();
   if(!ok || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_PLACED))
     {
      PrintFormat("[BRK] ordine RIFIUTATO rc=%u (%s)", rc, gTrade.ResultRetcodeDescription());
      return;
     }

   gSigClose = chiusura;
   gSigSL    = slN;
   gSigTP    = tpN;
   gSigR     = R;
   gBeFatto  = false;
   gTicket   = gTrade.ResultOrder();
   gSetupConsumato = true;

   if(InpLog)
      PrintFormat("[BRK] %s %.2f lotti | segnale %.5f | SL %.5f | TP %.5f | R %.1f pip | R:R %.2f",
                  (isSell ? "SELL" : "BUY"), lotti, chiusura, slN, tpN, R / PipSize(), rr);
  }

//+------------------------------------------------------------------+
//| BREAK-EVEN (spec par.7.1): a +1R MISURATO DALLA CHIUSURA DEL SEGNALE |
//| lo stop va SULLA CHIUSURA DEL SEGNALE, non sul prezzo di fill.    |
//| E' il dettaglio piu' sottile del corso (lez.38).                  |
//+------------------------------------------------------------------+
void GestisciBreakEven()
  {
   if(gBeFatto || gSigR <= 0.0 || gSigClose == 0.0) return;

   long   tipo  = PositionGetInteger(POSITION_TYPE);
   ulong  tkt   = (ulong)PositionGetInteger(POSITION_TICKET);
   double slOra = PositionGetDouble(POSITION_SL);
   double tpOra = PositionGetDouble(POSITION_TP);
   double bid   = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double nuovo = NormalizeDouble(gSigClose, _Digits);
   double minDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;

   if(tipo == POSITION_TYPE_SELL)
     {
      if(bid > gSigClose - gSigR) return;                 // +1R non ancora percorso
      if(slOra != 0.0 && nuovo >= slOra) { gBeFatto = true; return; }
      if(minDist > 0.0 && (nuovo - ask) < minDist) return; // troppo vicino: si riprova al tick dopo
     }
   else if(tipo == POSITION_TYPE_BUY)
     {
      if(ask < gSigClose + gSigR) return;
      if(slOra != 0.0 && nuovo <= slOra) { gBeFatto = true; return; }
      if(minDist > 0.0 && (bid - nuovo) < minDist) return;
     }
   else return;

   if(gTrade.PositionModify(tkt, nuovo, tpOra) && gTrade.ResultRetcode() == TRADE_RETCODE_DONE)
     {
      gBeFatto = true;
      if(InpLog) PrintFormat("[BRK] BE: stop sulla chiusura del segnale %.5f", nuovo);
     }
  }

//+------------------------------------------------------------------+
//| Chiusura a mercato della posizione dell'EA                        |
//+------------------------------------------------------------------+
void Chiudi(string motivo)
  {
   if(!SelezionaPosizione()) return;
   ulong tkt = (ulong)PositionGetInteger(POSITION_TICKET);
   if(gTrade.PositionClose(tkt))
     {
      if(InpLog) Print("[BRK] chiusura: ", motivo);
      AzzeraLivelli();
     }
   else
      PrintFormat("[BRK] chiusura FALLITA rc=%u (%s)", gTrade.ResultRetcode(), gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Volume dal rischio. La distanza e' quella REALE prezzo-stop:      |
//| lez.37 "in base al livello di entrata che avete effettuato,       |
//| abbiamo calcolato la distanza tra l'entrata e il nostro stop".    |
//+------------------------------------------------------------------+
double LottoDaRischio(double distanzaPrezzo)
  {
   if(distanzaPrezzo <= 0.0) return(0.0);
   double soldi = AccountInfoDouble(ACCOUNT_BALANCE) * RischioEffettivo() / 100.0;
   double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0.0 || ts <= 0.0 || soldi <= 0.0) return(0.0);

   double perditaPerLotto = (distanzaPrezzo / ts) * tv;
   if(perditaPerLotto <= 0.0) return(0.0);

   double lotti = soldi / perditaPerLotto;
   double vMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double vMax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double vStp = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(vStp <= 0.0) vStp = 0.01;

   lotti = MathFloor(lotti / vStp) * vStp;
   if(lotti < vMin)
     {
      // il lotto minimo porta il rischio SOPRA quello richiesto: lo si dice.
      if(InpLog) PrintFormat("[BRK] lotto calcolato %.4f < minimo %.2f: uso il minimo (rischio reale piu' alto).", lotti, vMin);
      lotti = vMin;
     }
   if(lotti > vMax) lotti = vMax;
   return(NormalizeDouble(lotti, DecimaliVolume(vStp)));
  }

//+------------------------------------------------------------------+
//| Rischio % effettivo: le DUE letture della slide S10 (spec par.8.1)   |
//+------------------------------------------------------------------+
double RischioEffettivo()
  {
   if(InpRischioMode == RISCHIO_COMPLESSIVO && InpCrossFamiglia > 1)
      return(InpRiskPercent / (double)InpCrossFamiglia);
   return(InpRiskPercent);
  }

//+------------------------------------------------------------------+
//| Utilita'                                                          |
//+------------------------------------------------------------------+
bool SelezionaPosizione()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tkt = PositionGetTicket(i);
      if(tkt == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) == InpMagic &&
         PositionGetString(POSITION_SYMBOL) == _Symbol)
         return(true);
     }
   return(false);
  }

void AzzeraLivelli()
  {
   gSigClose = 0.0; gSigSL = 0.0; gSigTP = 0.0; gSigR = 0.0;
   gBeFatto = false; gTicket = 0;
  }

double PipSize()
  {
   int d = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double p = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   return((d == 3 || d == 5) ? p * 10.0 : p);
  }

int DecimaliVolume(double step)
  {
   if(step <= 0.0) return(2);
   int d = 0;
   double s = step;
   while(d < 8 && MathAbs(s - MathRound(s)) > 1e-9) { s *= 10.0; d++; }
   return(d);
  }

ENUM_ORDER_TYPE_FILLING FillingBroker()
  {
   long modi = SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if((modi & SYMBOL_FILLING_FOK) != 0) return(ORDER_FILLING_FOK);
   if((modi & SYMBOL_FILLING_IOC) != 0) return(ORDER_FILLING_IOC);
   return(ORDER_FILLING_RETURN);
  }

//+------------------------------------------------------------------+
//| TEST-CASE NUMERICO DEL CORSO (spec par.6.2, lez.37 su USDJPY)        |
//|   massimo congestione 155,95 -> SL 155,96 (1 pip sopra)           |
//|   chiusura del segnale  155,57                                    |
//|   il corso dichiara R = 40 pip e TP = 154,37                      |
//| Si stampa il confronto in chiaro: 155,96 - 155,57 = 0,39, cioe'   |
//| 39 pip, non 40. Il TP del corso (154,37) e' coerente con 40 pip,  |
//| non con la sua stessa aritmetica. L'EA usa il valore ESATTO.      |
//+------------------------------------------------------------------+
void TestCasoDelCorso()
  {
   double pip = 0.01;                 // pip su JPY (spec par.6.3)
   double sl = 0.0, tp = 0.0, R = 0.0;
   LivelliDaSegnale(true, 155.95, 0.0, 155.57, pip, sl, tp, R);

   PrintFormat("[BRK][AUTOTEST] SL: corso 155.96 | EA %.5f | %s",
               sl, (MathAbs(sl - 155.96) < 1e-8 ? "COINCIDE" : "DIVERGE"));
   PrintFormat("[BRK][AUTOTEST] R : corso 40.0 pip | EA %.1f pip | scarto %.1f pip",
               R / pip, R / pip - 40.0);
   PrintFormat("[BRK][AUTOTEST] TP: corso 154.37 | EA %.5f | scarto %.1f pip",
               tp, (tp - 154.37) / pip);
   Print("[BRK][AUTOTEST] lo scarto NON e' un difetto dell'EA: 155,96-155,57 = 0,39 (39 pip).",
         " Il corso arrotonda a 40 e da li' calcola il target. Vedi referto del torneo JPY.");
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                 //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione)//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE: una riga per ogni trade chiuso, nella cartella  |
//| COMUNE. Serve al DD di portafoglio (dd_portafoglio.py).           |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0, TimeCurrent())) return;
   string fn = "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + "_" + _Symbol + "_" + IntegerToString((long)InpMagic) + ".csv";
   int h = FileOpen(fn, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h, "close_time", "symbol", "magic", "position_id", "deal_type", "volume", "price", "net_profit");
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk == 0) continue;
      long entry = HistoryDealGetInteger(tk, DEAL_ENTRY);
      if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_OUT_BY) continue;
      double net = HistoryDealGetDouble(tk, DEAL_PROFIT) + HistoryDealGetDouble(tk, DEAL_SWAP) + HistoryDealGetDouble(tk, DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk, DEAL_TIME), TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                HistoryDealGetString(tk, DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk, DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_VOLUME), 2),
                DoubleToString(HistoryDealGetDouble(tk, DEAL_PRICE), _Digits),
                DoubleToString(net, 2));
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];              // Recovery Factor (robusto)
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
