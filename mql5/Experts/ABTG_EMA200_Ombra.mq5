//+------------------------------------------------------------------+
//|                                          ABTG_EMA200_Ombra.mq5   |
//|                                                                  |
//|  MODALITA' OMBRA della tabella ABTG_EMA200_Dashboard v4.03       |
//|  (decisione di Claudio del 05/10/2026: "VA BENE L'OMBRA SULLA    |
//|  TABELLA").                                                      |
//|                                                                  |
//|  COSA FA                                                         |
//|   - Scansiona da UN solo grafico tutti i simboli della tabella   |
//|     (stessi default della dashboard) su tutti i TF accesi        |
//|     (default M15, H1, H4, D1 = le colonne della dashboard).      |
//|   - A ogni barra NUOVA del TF valuta il segnale del PIANO della  |
//|     dashboard, che e' quello di ABTG_EMA200 (r.319-349):         |
//|     chiusura della barra precedente sopra/sotto la EMA200, sua   |
//|     distanza dentro la fascia 0,30-1,50 ATR(14), EMA14 dallo     |
//|     stesso lato (valori a shift 1, barra chiusa).                |
//|   - SIMULA i due ordini del PIANO (BUY LIMIT se sopra la EMA,    |
//|     SELL LIMIT se sotto): limit 1 a EMA +/- 0,20 ATR verso il    |
//|     prezzo, limit 2 a EMA -/+ 0,30 ATR oltre la EMA (cella della |
//|     sedia 771531), SL 1 ATR oltre il limit 2, TP 2R per gamba,   |
//|     parziale 50% sulla EMA14 + pareggio + trailing sulla EMA14   |
//|     come ABTG_EMA200, scadenza 6 barre del TF d'ingresso.        |
//|   - Scrive l'esito SIMULATO in R (1R = rischio del setup intero, |
//|     2 gambe da 0,5R ciascuna) in MQL5\Files\ABTG_Ombra\.         |
//|                                                                  |
//|  COSA NON FA (e' il motivo per cui e' sicuro su ogni conto)      |
//|   - NESSUNA chiamata di trading: non apre, non modifica, non     |
//|     chiude, non cancella niente. Non include la libreria Trade.  |
//|   - Non legge posizioni ne' ordini del conto: nessun magic.      |
//|   - Non legge ne' scrive il Guardian (nessuna variabile globale  |
//|     del terminale, nessun include del Guardian).                 |
//|   - Non disegna oggetti sul grafico. Nessuna chiamata di rete.   |
//|   - Non aggiunge simboli al Market Watch, A MENO che             |
//|     InpAggiungiMW=true (unica eccezione, dichiarata; default     |
//|     false: i simboli assenti si saltano e si scrive nel log).    |
//|  Unici effetti: file in MQL5\Files\ABTG_Ombra\ e righe di Print. |
//|                                                                  |
//|  OROLOGIO: tutte le ore scritte sono ORA SERVER (BCM oggi UTC+1  |
//|  fisso, report/OROLOGIO_BCM_2026-09-24.md).                      |
//|                                                                  |
//|  Documento: report/EA_EMA200_OMBRA_2026-10-05.md                 |
//|  Lettore:   backtest_pipeline/leggi_ombra_ema200.py              |
//|  Simulazione != realta': fill, spread variabile e slippage veri  |
//|  si vedono solo con ordini veri.                                 |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.02"
#property strict

#define OMBRA_VER     "1.02"
#define NTF7          7
#define NCNT          11
#define W_GAMBA       0.5       // peso di ogni gamba nell'R del setup (2 ordini da 0,5)

//--- stato di una gamba simulata
#define ST_VUOTA      0
#define ST_PEND       1
#define ST_APERTA     2
#define ST_CHIUSA     3
#define ST_SCADUTA    4
#define ST_RIFIUTATA  5

//--- come e' uscita una gamba
#define EX_NESSUNO    0
#define EX_SL         1
#define EX_TP         2
#define EX_P_BE       3
#define EX_P_TRAIL    4
#define EX_P_TP       5
#define EX_P_SL       6

//--- contatori dell'imbuto (per slot simbolo x TF, per giorno)
#define C_VAL     0
#define C_ND      1
#define C_FASCIA  2
#define C_LATO    3
#define C_E14     4
#define C_TRIG    5
#define C_ARM     6
#define C_OCC     7
#define C_RIF     8
#define C_RIT     9
#define C_SPENTO  10

//--- esito della valutazione del segnale
#define SIG_ND     -1
#define SIG_FASCIA  0
#define SIG_LATO    1
#define SIG_E14     2
#define SIG_TRIG    3

//--- fonte dei prezzi usati per simulare
#define F_TICK  1
#define F_M1    2
#define F_BUCO  4

//--- intestazioni dei file
#define HDR_ESITI 0
#define HDR_TRIG  1
#define HDR_IMB   2

//==================================================================
//  INPUT
//==================================================================
input group "=== Simboli (default = quelli della dashboard v4.03) ==="
input bool   InpForex      = true;     // FOREX
input string InpSymForex   = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"; // Lista forex (virgola)
input bool   InpIndici     = true;     // INDICI
input string InpSymIndici  = "D30EUR,U30USD,NASUSD,SPXUSD,200AUD,225JPY"; // Lista indici (nomi BCM)
input bool   InpMetalli    = true;     // METALLI
input string InpSymMetalli = "XAUUSD,XAGUSD"; // Lista metalli
input string InpSuffix     = "";       // Suffisso broker (se serve)
input bool   InpAggiungiMW = false;    // true = aggiunge al Market Watch i simboli mancanti. false = li salta e lo scrive

input group "=== TF d'ingresso (colonne della dashboard) ==="
input bool   InpTfM5  = false;         // M5
input bool   InpTfM15 = true;          // M15
input bool   InpTfM30 = false;         // M30
input bool   InpTfH1  = true;          // H1
input bool   InpTfH4  = true;          // H4
input bool   InpTfD1  = true;          // D1

input group "=== Segnale (filtri di ABTG_EMA200 / piano della dashboard) ==="
input int    InpEmaPeriod    = 200;    // Periodo EMA lenta
input int    InpEma14Period  = 14;     // Periodo EMA14 (bias, parziale, trailing)
input int    InpAtrPeriod    = 14;     // Periodo ATR
input double InpMinDistAtr   = 0.30;   // Fascia: distanza minima chiusura-EMA (ATR)
input double InpMaxDistAtr   = 1.50;   // Fascia: distanza massima chiusura-EMA (ATR)
input bool   InpUseEma14Bias = true;   // EMA14 dallo stesso lato della chiusura
input bool   InpAllowLong    = true;   // Lato long
input bool   InpAllowShort   = true;   // Lato short

input group "=== Piano simulato: 2 limit (cella 771531) ==="
input double InpOrder1Atr    = 0.20;   // Limit 1: dalla EMA verso il prezzo di N ATR
input double InpOrder2Atr    = 0.30;   // Limit 2: oltre la EMA (overshoot) di N ATR
input double InpSLatr        = 1.0;    // SL: N ATR oltre il limit 2 (stesso SL per le 2 gambe)
input double InpTP_RR        = 2.0;    // TP finale di ogni gamba in R della gamba
input double InpTP1Pct       = 50;     // Parziale (%) quando il prezzo tocca la EMA14
input bool   InpBreakeven    = true;   // Stop in pari dopo il parziale
input bool   InpUseTrailing  = true;   // Trailing sulla EMA14 dopo il pareggio
input int    InpExpiryBars   = 6;      // Scadenza dei limit non riempiti (barre del TF d'ingresso)
input double InpRischioTeoricoPct = 1.0; // Solo etichetta: 1R = questa % (in 2 gambe da meta'). Nessun lotto.
input bool   InpUnoPerLato   = false;  // false = un setup per simbolo-TF come la sedia; true = uno per lato
input bool   InpRispettaStops = true;  // SL/pareggio/trailing/limit rispettano SYMBOL_TRADE_STOPS_LEVEL

input group "=== Costo di casa ==="
input double InpCostoMult    = 40.0;   // Frontiera: stop >= N x spread (si scrive il flag, si logga TUTTO)

input group "=== Motore (leggerezza: il VPS ospita sedie vive) ==="
input int    InpTimerMs      = 1000;   // Giro del timer (ms)
input int    InpBudgetMs     = 150;    // Tetto di tempo per giro, per ciascuna delle 2 fasi (ms)
input int    InpGraceSec     = 300;    // Barra vista dopo questi secondi (es. al riavvio) = PERSO_RITARDO
input int    InpFinestraMin  = 60;     // Recupero dopo un buco: tick letti a finestre di N minuti
input int    InpMaxRecuperoBarre = 300; // Barre perse a EA spento rivalutate SOLO come trigger (denominatore)
input int    InpStatoSec     = 15;     // Salvataggio dello stato ogni N secondi (se cambiato)
input string InpTag          = "";     // Etichetta cartella (serve SOLO per una seconda istanza sullo stesso terminale)

//==================================================================
//  STRUTTURE E STATO
//==================================================================
struct SimSetup
  {
   bool     act;
   string   id;
   int      slot;
   int      side;          // +1 long, -1 short
   datetime tBar;          // apertura della barra del TF su cui si arma
   datetime tArm;          // ora server dell'ultimo tick del simbolo all'armo
   long     armMsc;
   datetime tExp;
   double   ema;
   double   atr;
   double   e14a;
   double   c1;
   double   dAtr;
   double   dLive;
   double   dHtf;
   string   conc;
   double   sprArm;
   double   stopPts;
   double   ratio;
   bool     costOk;
   double   sMae;
   double   sMfe;
   bool     sFilled;
   int      fonte;
   datetime e14Bar;
   double   e14Cur;
   int      st[2];
   double   px[2];
   double   sl[2];
   double   slIni[2];
   double   tp[2];
   double   risk[2];
   double   vol[2];
   double   rr[2];
   bool     parz[2];
   bool     trl[2];
   long     fMsc[2];
   long     cMsc[2];
   double   sprF[2];
   double   mae[2];
   double   mfe[2];
   int      ex[2];
  };

struct Segnale
  {
   int      side;
   double   ema;
   double   atr;
   double   c1;
   double   e14;
   double   dAtr;
   double   dLive;
   double   dHtf;
   string   conc;
   string   htf;
   double   sprPts;
   double   stopPts;
   double   ratio;
   bool     costOk;
   double   o1;
   double   o2;
   double   sl;
  };

ENUM_TIMEFRAMES gTF7[NTF7] = {PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1};
string          gTFN[NTF7] = {"M5", "M15", "M30", "H1", "H4", "D1", "W1"};
// TF superiore per la concordanza: M5->M30, M15->H1, M30->H4, H1->H4, H4->D1, D1->W1
int             gHTF[6]    = {2, 3, 4, 4, 5, 6};

//--- simboli
string   gSym[];
int      gN = 0;
double   gPt[];
int      gDig[];
double   gTsz[];
bool     gPtrOk[];
long     gLastMsc[];
int      gNAt[];
int      gErr[];
int      gZero[];
int      gE14Wait[];     // [REV 05/10] giri consecutivi in attesa della EMA14 di gestione
int      gHE[];         // EMA lenta   [s*NTF7+k]
int      gHA[];          // ATR         [s*NTF7+k]
int      gH14[];         // EMA14       [s*NTF7+k] (solo TF d'ingresso)

//--- slot simbolo x TF d'ingresso
int      gNSl = 0;
int      gSlS[];
int      gSlK[];
datetime gSlLastBar[];
long     gSlSeen[];      // orologio MONOTONO (MonoSec) dell'ultima volta che si e' vista la barra vecchia
long     gCnt[][NCNT];

//--- setup simulati: indice = slot*2 + (InpUnoPerLato ? lato : 0)
SimSetup gSU[];
datetime gStClose[];

//--- coda delle righe da scrivere (file aperto da altri, es. Excel)
string   gQF[];
int      gQH[];
string   gQL[];
int      gNQ = 0;

Segnale  gSg;
string   gDir = "";
bool     gDirty = false;
bool     gInitOk = false;  // [REV 05/10] false = OnInit fallita: OnDeinit NON riscrive lo stato su disco
long     gLastSave = 0;    // MonoSec
int      gRRt = 0;
int      gRRb = 0;
long     gDayKey = 0;
datetime gDayDate = 0;
long     gLastBeat = 0;    // MonoSec
ulong    gGiroMaxUs = 0;
ulong    gGiroLastUs = 0;
long     gNTick = 0;
long     gNGiri = 0;
long     gNOver = 0;
int      gNSkip = 0;

//==================================================================
//  UTILITA'
//==================================================================
int IMax(const int a, const int b) { return (a > b) ? a : b; }

// [REV 05/10] orologio MONOTONO in secondi per gli INTERVALLI interni (salvataggio, battito,
// tolleranza di ritardo). TimeLocal() salta di -1h al cambio d'ora legale del PC (25/10/2026):
// TimeLocal()-gLastSave restava negativo per un'ora = niente salvataggio periodico ne' battito.
long MonoSec() { return (long)(GetTickCount64() / 1000); }
int IMin(const int a, const int b) { return (a < b) ? a : b; }

string D(const double x)  { return DoubleToString(x, 10); }
string Dn(const double x, const int d) { return DoubleToString(x, d); }
string Ts(const datetime t) { return (t > 0) ? TimeToString(t, TIME_DATE | TIME_SECONDS) : ""; }
string TsMsc(const long m) { return (m > 0) ? TimeToString((datetime)(m / 1000), TIME_DATE | TIME_SECONDS) : ""; }

string Mese(const datetime t)
  {
   MqlDateTime d;
   TimeToStruct(t, d);
   return StringFormat("%04d%02d", d.year, d.mon);
  }

string Sig()
  {
   return StringFormat("O%.2f-%.2f_SL%.2f_TP%.2f_P%.0f_BE%d_TR%d_X%d_F%.2f-%.2f_E%d_EMA%d-%d-%d_ST%d_UL%d",
                       InpOrder1Atr, InpOrder2Atr, InpSLatr, InpTP_RR, InpTP1Pct, (int)InpBreakeven,
                       (int)InpUseTrailing, InpExpiryBars, InpMinDistAtr, InpMaxDistAtr, (int)InpUseEma14Bias,
                       InpEmaPeriod, InpEma14Period, InpAtrPeriod, (int)InpRispettaStops, (int)InpUnoPerLato);
  }

string Hdr(const int k)
  {
   if(k == HDR_ESITI)
      return "id;data_arm_server;barra_tf;simbolo;tf;lato;dist_atr;dist_live_atr;conc_htf;htf;dist_htf_atr;" +
             string("ema200;atr;ema14;o1;o2;sl;tp_l1;tp_l2;spread_arm_pts;stop_pts;stop_su_spread;costo_ok;") +
             "esito;R_finale;pct_teorico;esito1;R1;fill1;spread_fill1;mae1_R;mfe1_R;" +
             "esito2;R2;fill2;spread_fill2;mae2_R;mfe2_R;mae_R;mfe_R;attesa_min;durata_min;chiusura_server;fonte;parametri;versione";
   if(k == HDR_TRIG)
      return "barra_tf;valutato_server;simbolo;tf;lato;dist_atr;dist_live_atr;conc_htf;htf;dist_htf_atr;" +
             string("spread_pts;stop_pts;stop_su_spread;costo_ok;stato;id;parametri;versione");
   return "giorno;simbolo;tf;valutate;non_pronte;fuori_fascia;lato_spento;ema14_contraria;trigger;" +
          string("armati;occupati;rifiutati;persi_ritardo;persi_spento");
  }

//--- scrive una riga in coda a un file (intestazione se il file e' vuoto)
bool AppendLine(const string fname, const int hdr, const string line)
  {
   int h = FileOpen(fname, FILE_READ | FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(h == INVALID_HANDLE)
      return false;
   // v1.01 (cancello 05/10): si controlla quanto e' stato scritto. A disco pieno FileOpen riesce
   // ma la scrittura no: prima la riga risultava scritta ed era PERSA; ora resta in coda.
   bool ok = true;
   if(FileSize(h) == 0)
      ok = (FileWriteString(h, Hdr(hdr) + "\r\n") > 0);
   FileSeek(h, 0, SEEK_END);
   if(ok)
      ok = (FileWriteString(h, line + "\r\n") > 0);
   FileClose(h);
   return ok;
  }

void LogEv(const string msg)
  {
   Print("[OMBRA] ", msg);
   int h = FileOpen(gDir + "\\ombra_log.txt", FILE_READ | FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(h == INVALID_HANDLE)
      return;
   FileSeek(h, 0, SEEK_END);
   FileWriteString(h, TimeToString(TimeTradeServer(), TIME_DATE | TIME_SECONDS) + " server | " + msg + "\r\n");
   FileClose(h);
  }

//--- coda: le righe non si perdono se il file e' momentaneamente bloccato
void FlushQueue()
  {
   if(gNQ == 0)
      return;
   string nf[];
   int    nh[];
   string nl[];
   int    m = 0;
   string bloccato = "";
   for(int q = 0; q < gNQ; q++)
     {
      bool ok = false;
      if(StringFind(bloccato, "|" + gQF[q] + "|") < 0)
         ok = AppendLine(gQF[q], gQH[q], gQL[q]);
      if(!ok)
        {
         // ordine preservato: dopo un fallimento le righe dello stesso file restano in coda
         if(StringFind(bloccato, "|" + gQF[q] + "|") < 0)
            bloccato += "|" + gQF[q] + "|";
         ArrayResize(nf, m + 1, gNQ);   // v1.01: riserva = niente riallocazione a ogni riga
         ArrayResize(nh, m + 1, gNQ);
         ArrayResize(nl, m + 1, gNQ);
         nf[m] = gQF[q];
         nh[m] = gQH[q];
         nl[m] = gQL[q];
         m++;
        }
     }
   ArrayResize(gQF, m);
   ArrayResize(gQH, m);
   ArrayResize(gQL, m);
   for(int q = 0; q < m; q++)
     {
      gQF[q] = nf[q];
      gQH[q] = nh[q];
      gQL[q] = nl[q];
     }
   if(m != gNQ)
      gDirty = true;
   gNQ = m;
  }

void Enqueue(const string fname, const int hdr, const string line)
  {
   if(gNQ >= 20000)
     {
      LogEv("coda righe piena (20000): scarto la piu' vecchia di " + gQF[0]);
      for(int q = 1; q < gNQ; q++)
        {
         gQF[q - 1] = gQF[q];
         gQH[q - 1] = gQH[q];
         gQL[q - 1] = gQL[q];
        }
      gNQ--;
     }
   bool vuota = (gNQ == 0);
   ArrayResize(gQF, gNQ + 1, 1024);
   ArrayResize(gQH, gNQ + 1, 1024);
   ArrayResize(gQL, gNQ + 1, 1024);
   gQF[gNQ] = fname;
   gQH[gNQ] = hdr;
   gQL[gNQ] = line;
   gNQ++;
   gDirty = true;
   // v1.01 (cancello 05/10): si scrive subito SOLO se la coda era vuota. Con righe gia' in attesa
   // (un CSV bloccato) si riprova una volta per giro in OnTimer: prima ogni riga nuova ripassava
   // tutta la coda, un costo che cresceva col quadrato e fuori dal tetto di tempo.
   if(vuota)
      FlushQueue();
  }

double NormPx(const int s, const double p)
  {
   double ts = gTsz[s];
   if(ts <= 0.0)
      return NormalizeDouble(p, gDig[s]);
   return NormalizeDouble(MathRound(p / ts) * ts, gDig[s]);
  }

double StopsDist(const int s)
  {
   if(!InpRispettaStops)
      return 0.0;
   return (double)SymbolInfoInteger(gSym[s], SYMBOL_TRADE_STOPS_LEVEL) * gPt[s];
  }

// uno stop nuovo sarebbe accettato dal server? (lato giusto del prezzo + distanza minima)
bool SlOk(const int s, const bool L, const double nsl, const double bid, const double ask)
  {
   double d = StopsDist(s);
   if(L)
      return (nsl < bid && bid - nsl >= d);
   return (nsl > ask && nsl - ask >= d);
  }

double CurSpread(const int s)
  {
   return (double)SymbolInfoInteger(gSym[s], SYMBOL_SPREAD) * gPt[s];
  }

double Buf(const int h, const int shift)
  {
   if(h == INVALID_HANDLE || shift < 0)
      return 0.0;
   double b[1];
   if(CopyBuffer(h, 0, shift, 1, b) != 1)
      return 0.0;
   if(b[0] == EMPTY_VALUE || b[0] <= 0.0)
      return 0.0;
   return b[0];
  }

bool Over(const ulong t0)
  {
   return (GetMicrosecondCount() - t0) > (ulong)IMax(10, InpBudgetMs) * 1000;
  }

int StorIdx(const int j, const int side)
  {
   if(!InpUnoPerLato)
      return j * 2;
   return j * 2 + ((side > 0) ? 0 : 1);
  }

int FindSym(const string sym)
  {
   for(int s = 0; s < gN; s++)
      if(gSym[s] == sym)
         return s;
   return -1;
  }

int FindSlot(const string sym, const string tfn)
  {
   for(int j = 0; j < gNSl; j++)
      if(gSym[gSlS[j]] == sym && gTFN[gSlK[j]] == tfn)
         return j;
   return -1;
  }

void ResetSetup(const int i)
  {
   gSU[i].act = false;
   gSU[i].id = "";
   gSU[i].slot = -1;
   gSU[i].side = 0;
   gSU[i].tBar = 0;
   gSU[i].tArm = 0;
   gSU[i].armMsc = 0;
   gSU[i].tExp = 0;
   gSU[i].ema = 0.0;
   gSU[i].atr = 0.0;
   gSU[i].e14a = 0.0;
   gSU[i].c1 = 0.0;
   gSU[i].dAtr = 0.0;
   gSU[i].dLive = 0.0;
   gSU[i].dHtf = 0.0;
   gSU[i].conc = "";
   gSU[i].sprArm = 0.0;
   gSU[i].stopPts = 0.0;
   gSU[i].ratio = 0.0;
   gSU[i].costOk = false;
   gSU[i].sMae = 0.0;
   gSU[i].sMfe = 0.0;
   gSU[i].sFilled = false;
   gSU[i].fonte = 0;
   gSU[i].e14Bar = 0;
   gSU[i].e14Cur = 0.0;
   for(int k = 0; k < 2; k++)
     {
      gSU[i].st[k] = ST_VUOTA;
      gSU[i].px[k] = 0.0;
      gSU[i].sl[k] = 0.0;
      gSU[i].slIni[k] = 0.0;
      gSU[i].tp[k] = 0.0;
      gSU[i].risk[k] = 0.0;
      gSU[i].vol[k] = 0.0;
      gSU[i].rr[k] = 0.0;
      gSU[i].parz[k] = false;
      gSU[i].trl[k] = false;
      gSU[i].fMsc[k] = 0;
      gSU[i].cMsc[k] = 0;
      gSU[i].sprF[k] = 0.0;
      gSU[i].mae[k] = 0.0;
      gSU[i].mfe[k] = 0.0;
      gSU[i].ex[k] = EX_NESSUNO;
     }
  }

//==================================================================
//  INIZIALIZZAZIONE
//==================================================================
int OnInit()
  {
   gDir = "ABTG_Ombra" + ((StringLen(InpTag) > 0) ? "_" + InpTag : "");
   FolderCreate(gDir);

   //--- TF d'ingresso accesi (indici nella tabella a 7)
   bool on[6];
   on[0] = InpTfM5;
   on[1] = InpTfM15;
   on[2] = InpTfM30;
   on[3] = InpTfH1;
   on[4] = InpTfH4;
   on[5] = InpTfD1;
   int ks[];
   int nk = 0;
   for(int k = 0; k < 6; k++)
     {
      if(!on[k])
         continue;
      ArrayResize(ks, nk + 1);
      ks[nk] = k;
      nk++;
     }
   if(nk == 0)
     {
      Print("[OMBRA] nessun TF d'ingresso acceso.");
      return INIT_FAILED;
     }

   //--- simboli: stessi elenchi della dashboard; i mancanti si saltano e si scrive perche'
   string lista = "";
   if(InpForex)
      lista += InpSymForex + ",";
   if(InpIndici)
      lista += InpSymIndici + ",";
   if(InpMetalli)
      lista += InpSymMetalli + ",";
   string parts[];
   int np = StringSplit(lista, ',', parts);
   gN = 0;
   string saltati = "";
   for(int i = 0; i < np; i++)
     {
      string sy = parts[i];
      StringTrimLeft(sy);
      StringTrimRight(sy);
      if(StringLen(sy) == 0)
         continue;
      sy = sy + InpSuffix;
      if(FindSym(sy) >= 0)
         continue;
      bool cust = false;
      if(!SymbolExist(sy, cust))
        {
         saltati += sy + "(inesistente) ";
         continue;
        }
      if(!(bool)SymbolInfoInteger(sy, SYMBOL_SELECT))
        {
         if(!InpAggiungiMW)
           {
            saltati += sy + "(non nel Market Watch) ";
            continue;
           }
         if(!SymbolSelect(sy, true))
           {
            saltati += sy + "(Market Watch rifiuta) ";
            continue;
           }
        }
      ArrayResize(gSym, gN + 1);
      gSym[gN] = sy;
      gN++;
     }
   if(gN == 0)
     {
      Print("[OMBRA] nessun simbolo utilizzabile. Saltati: ", saltati);
      return INIT_FAILED;
     }

   ArrayResize(gPt, gN);
   ArrayResize(gDig, gN);
   ArrayResize(gTsz, gN);
   ArrayResize(gPtrOk, gN);
   ArrayResize(gLastMsc, gN);
   ArrayResize(gNAt, gN);
   ArrayResize(gErr, gN);
   ArrayResize(gZero, gN);
   ArrayResize(gE14Wait, gN);
   ArrayResize(gHE, gN * NTF7);
   ArrayResize(gHA, gN * NTF7);
   ArrayResize(gH14, gN * NTF7);
   for(int q = 0; q < gN * NTF7; q++)
     {
      gHE[q] = INVALID_HANDLE;
      gHA[q] = INVALID_HANDLE;
      gH14[q] = INVALID_HANDLE;
     }
   int nHandle = 0, nHandleKo = 0;
   for(int s = 0; s < gN; s++)
     {
      gPt[s]  = SymbolInfoDouble(gSym[s], SYMBOL_POINT);
      gDig[s] = (int)SymbolInfoInteger(gSym[s], SYMBOL_DIGITS);
      gTsz[s] = SymbolInfoDouble(gSym[s], SYMBOL_TRADE_TICK_SIZE);
      gPtrOk[s] = false;
      gLastMsc[s] = 0;
      gNAt[s] = 0;
      gErr[s] = 0;
      gZero[s] = 0;
      gE14Wait[s] = 0;
      for(int u = 0; u < nk; u++)
        {
         int k  = ks[u];
         int hk = gHTF[k];
         int a  = s * NTF7 + k;
         int b  = s * NTF7 + hk;
         if(gHE[a] == INVALID_HANDLE)
           {
            gHE[a] = iMA(gSym[s], gTF7[k], InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
            gHA[a] = iATR(gSym[s], gTF7[k], InpAtrPeriod);
            nHandle += 2;
           }
         if(gH14[a] == INVALID_HANDLE)
           {
            gH14[a] = iMA(gSym[s], gTF7[k], InpEma14Period, 0, MODE_EMA, PRICE_CLOSE);
            nHandle++;
           }
         if(gHE[b] == INVALID_HANDLE)
           {
            gHE[b] = iMA(gSym[s], gTF7[hk], InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
            gHA[b] = iATR(gSym[s], gTF7[hk], InpAtrPeriod);
            nHandle += 2;
           }
         if(gHE[a] == INVALID_HANDLE || gHA[a] == INVALID_HANDLE || gH14[a] == INVALID_HANDLE)
            nHandleKo++;
        }
     }

   //--- slot
   gNSl = gN * nk;
   ArrayResize(gSlS, gNSl);
   ArrayResize(gSlK, gNSl);
   ArrayResize(gSlLastBar, gNSl);
   ArrayResize(gSlSeen, gNSl);
   ArrayResize(gCnt, gNSl);
   ArrayResize(gSU, gNSl * 2);
   ArrayResize(gStClose, gNSl * 2);
   int j = 0;
   for(int s = 0; s < gN; s++)
      for(int u = 0; u < nk; u++)
        {
         gSlS[j] = s;
         gSlK[j] = ks[u];
         gSlLastBar[j] = 0;
         gSlSeen[j] = 0;
         for(int c = 0; c < NCNT; c++)
            gCnt[j][c] = 0;
         j++;
        }
   for(int i = 0; i < gNSl * 2; i++)
     {
      ResetSetup(i);
      gStClose[i] = 0;
     }
   gNQ = 0;
   ArrayResize(gQF, 0);
   ArrayResize(gQH, 0);
   ArrayResize(gQL, 0);

   LoadState();

   string tfs = "";
   for(int u = 0; u < nk; u++)
      tfs += gTFN[ks[u]] + "(sup. " + gTFN[gHTF[ks[u]]] + ") ";
   LogEv(StringFormat("AVVIO v%s: %d simboli x %d TF = %d slot; handle %d (slot con handle KO %d); TF %s; parametri %s",
                      OMBRA_VER, gN, nk, gNSl, nHandle, nHandleKo, tfs, Sig()));
   if(StringLen(saltati) > 0)
      LogEv("simboli SALTATI: " + saltati);
   LogEv("modalita' OMBRA: nessun ordine, sola simulazione; unico effetto file in MQL5\\Files\\" + gDir);

   if(!EventSetMillisecondTimer(IMax(200, InpTimerMs)))
     {
      Print("[OMBRA] timer non impostato.");
      return INIT_FAILED;
     }
   gInitOk = true;
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   // [REV 05/10] MT5 chiama OnDeinit anche dopo INIT_FAILED (es. al riavvio nessun simbolo nel
   // Market Watch): senza questa guardia SaveState riscriveva uno stato VUOTO sopra quello buono
   // e i setup aperti erano persi per sempre.
   if(gInitOk)
     {
      FlushQueue();
      SaveState();
     }
   for(int q = 0; q < ArraySize(gHE); q++)
     {
      if(gHE[q] != INVALID_HANDLE)
         IndicatorRelease(gHE[q]);
      if(gHA[q] != INVALID_HANDLE)
         IndicatorRelease(gHA[q]);
      if(gH14[q] != INVALID_HANDLE)
         IndicatorRelease(gH14[q]);
     }
   LogEv("ARRESTO (motivo " + IntegerToString(reason) + "): stato salvato, " + IntegerToString(gNQ) + " righe in coda salvate nello stato");
  }

// L'EA lavora solo a timer: il tick del grafico non serve (scansiona tutti i simboli).
void OnTick()
  {
  }

//==================================================================
//  GIRO DEL TIMER
//==================================================================
void OnTimer()
  {
   ulong t0 = GetMicrosecondCount();
   gNGiri++;
   FlushQueue();
   DayRollover();
   ProcessTicksAll(t0);
   ulong t1 = GetMicrosecondCount();
   ScanBars(t1);
   if(gDirty && MonoSec() - gLastSave >= IMax(1, InpStatoSec))
      SaveState();
   gGiroLastUs = GetMicrosecondCount() - t0;
   if(gGiroLastUs > gGiroMaxUs)
      gGiroMaxUs = gGiroLastUs;
   if(MonoSec() - gLastBeat >= 60)
      Battito();
  }

void Battito()
  {
   gLastBeat = MonoSec();
   int att = 0;
   for(int i = 0; i < ArraySize(gSU); i++)
      if(gSU[i].act)
         att++;
   int h = FileOpen(gDir + "\\ombra_battito.txt", FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(h == INVALID_HANDLE)
      return;
   FileWriteString(h, "versione " + OMBRA_VER + "\r\n");
   FileWriteString(h, "ora_server " + TimeToString(TimeTradeServer(), TIME_DATE | TIME_SECONDS) + "\r\n");
   FileWriteString(h, "ora_locale " + TimeToString(TimeLocal(), TIME_DATE | TIME_SECONDS) + "\r\n");
   FileWriteString(h, "simboli " + IntegerToString(gN) + " slot " + IntegerToString(gNSl) + "\r\n");
   FileWriteString(h, "setup_attivi " + IntegerToString(att) + "\r\n");
   FileWriteString(h, "giri " + IntegerToString(gNGiri) + " tick_processati " + IntegerToString(gNTick) + "\r\n");
   FileWriteString(h, "giro_ultimo_ms " + DoubleToString(gGiroLastUs / 1000.0, 2) +
                   " giro_massimo_ms " + DoubleToString(gGiroMaxUs / 1000.0, 2) + "\r\n");
   FileWriteString(h, "giri_oltre_tetto " + IntegerToString(gNOver) + " righe_in_coda " + IntegerToString(gNQ) + "\r\n");
   FileWriteString(h, "parametri " + Sig() + "\r\n");
   FileClose(h);
  }

//==================================================================
//  IMBUTO GIORNALIERO
//==================================================================
void DayRollover()
  {
   datetime now = TimeTradeServer();
   if(now <= 0)
      return;
   MqlDateTime d;
   TimeToStruct(now, d);
   long key = (long)d.year * 10000 + d.mon * 100 + d.day;
   if(gDayKey == 0)
     {
      gDayKey = key;
      gDayDate = (datetime)((long)now - (long)now % 86400);
      gDirty = true;
      return;
     }
   if(key == gDayKey)
      return;
   ScriviImbuto(gDayDate);
   for(int j = 0; j < gNSl; j++)
      for(int c = 0; c < NCNT; c++)
         gCnt[j][c] = 0;
   gDayKey = key;
   gDayDate = (datetime)((long)now - (long)now % 86400);
   gDirty = true;
  }

void ScriviImbuto(const datetime giorno)
  {
   string fn = gDir + "\\ombra_imbuto_" + Mese(giorno) + ".csv";
   for(int j = 0; j < gNSl; j++)
     {
      long tot = 0;
      for(int c = 0; c < NCNT; c++)
         tot += gCnt[j][c];
      if(tot == 0)
         continue;
      string r = TimeToString(giorno, TIME_DATE) + ";" + gSym[gSlS[j]] + ";" + gTFN[gSlK[j]];
      for(int c = 0; c < NCNT; c++)
         r += ";" + IntegerToString(gCnt[j][c]);
      Enqueue(fn, HDR_IMB, r);
     }
  }

//==================================================================
//  SEGNALE: identico ai filtri di ABTG_EMA200 (OnNewBar) e al PIANO
//  della dashboard (DrawPlan). Valori della barra CHIUSA (shift+1).
//==================================================================
int EvalSignal(const int j, const int shift)
  {
   int s = gSlS[j];
   int k = gSlK[j];
   int a = s * NTF7 + k;
   string sym = gSym[s];
   ENUM_TIMEFRAMES tf = gTF7[k];
   if(gHE[a] == INVALID_HANDLE || gHA[a] == INVALID_HANDLE)
      return SIG_ND;
   if(SeriesInfoInteger(sym, tf, SERIES_SYNCHRONIZED) == 0)
      return SIG_ND;
   int need = shift + 1;
   if(BarsCalculated(gHE[a]) < InpEmaPeriod + need + 1 || BarsCalculated(gHA[a]) < InpAtrPeriod + need + 1)
      return SIG_ND;
   // v1.01 (cancello 05/10): su un ALTRO simbolo l'indicatore si ricalcola nel suo thread; appena nata
   // la barra, CopyBuffer a shift 1 puo' dare ancora la barra di PRIMA mentre iClose(...,1) da' gia'
   // quella appena chiusa (segnale con EMA/ATR di una barra e chiusura di un'altra). Si aspetta che
   // l'indicatore abbia calcolato tutte le barre della serie; altrimenti "non pronta" e si riprova.
   int nb = Bars(sym, tf);
   if(nb <= 0 || BarsCalculated(gHE[a]) < nb || BarsCalculated(gHA[a]) < nb)
      return SIG_ND;
   if(InpUseEma14Bias && gH14[a] != INVALID_HANDLE && BarsCalculated(gH14[a]) >= InpEma14Period + need + 1 &&
      BarsCalculated(gH14[a]) < nb)
      return SIG_ND;
   double ema = Buf(gHE[a], need);
   double atr = Buf(gHA[a], need);
   double c1  = iClose(sym, tf, need);
   if(ema <= 0.0 || atr <= 0.0 || c1 <= 0.0)
      return SIG_ND;
   bool up = (c1 > ema);
   gSg.side = up ? 1 : -1;
   gSg.ema = ema;
   gSg.atr = atr;
   gSg.c1 = c1;
   gSg.dAtr = (c1 - ema) / atr;
   gSg.e14 = 0.0;
   if(gH14[a] != INVALID_HANDLE && BarsCalculated(gH14[a]) >= InpEma14Period + need + 1)
      gSg.e14 = Buf(gH14[a], need);
   double dist = MathAbs(c1 - ema);
   if(dist < InpMinDistAtr * atr || dist > InpMaxDistAtr * atr)
      return SIG_FASCIA;
   if(up && !InpAllowLong)
      return SIG_LATO;
   if(!up && !InpAllowShort)
      return SIG_LATO;
   // come l'EA: EMA14 non disponibile = filtro non applicato
   if(InpUseEma14Bias && gSg.e14 > 0.0 && ((up && gSg.e14 < ema) || (!up && gSg.e14 > ema)))
      return SIG_E14;
   return SIG_TRIG;
  }

//--- concordanza col TF superiore: lato del prezzo px (all'istante tRef) rispetto alla
//    EMA lenta del TF superiore dell'ULTIMA barra CHIUSA prima di tRef. Stesso lato della
//    EMA "viva" della dashboard: EMA_viva = EMA_prec + a*(px - EMA_prec) ha il lato di px
//    identico a quello rispetto a EMA_prec (a < 1). Niente sguardo nel futuro.
void Concordanza(const int j, const double px, const datetime tRef)
  {
   int s  = gSlS[j];
   int hk = gHTF[gSlK[j]];
   int b  = s * NTF7 + hk;
   string sym = gSym[s];
   ENUM_TIMEFRAMES tfH = gTF7[hk];
   gSg.htf  = gTFN[hk];
   gSg.conc = gTFN[hk] + "?";
   gSg.dHtf = 0.0;
   if(gHE[b] == INVALID_HANDLE || gHA[b] == INVALID_HANDLE || px <= 0.0)
      return;
   int idx = iBarShift(sym, tfH, tRef, false);
   if(idx < 0)
      return;
   datetime tb = iTime(sym, tfH, idx);
   if(tb == 0)
      return;
   if(tb > tRef)
      idx++;
   int prev = idx + 1;            // la barra che contiene tRef e' in corso: si usa la precedente
   if(BarsCalculated(gHE[b]) < InpEmaPeriod + prev + 1)
      return;
   int nbH = Bars(sym, tfH);      // v1.01: indicatore del TF superiore gia' allineato alla serie
   if(nbH <= 0 || BarsCalculated(gHE[b]) < nbH)
      return;
   double e = Buf(gHE[b], prev);
   double a = Buf(gHA[b], prev);
   if(e <= 0.0)
      return;
   bool conc = ((px > e && gSg.side > 0) || (px < e && gSg.side < 0));
   gSg.conc = gTFN[hk] + (conc ? "+" : "-");
   gSg.dHtf = (a > 0.0) ? (px - e) / a : 0.0;
  }

//--- livelli del piano, come PlaceOrders() dell'EA e DrawPlan() della dashboard
void Livelli(const int s)
  {
   bool L = (gSg.side > 0);
   gSg.o1 = NormPx(s, L ? gSg.ema + InpOrder1Atr * gSg.atr : gSg.ema - InpOrder1Atr * gSg.atr);
   gSg.o2 = NormPx(s, L ? gSg.ema - InpOrder2Atr * gSg.atr : gSg.ema + InpOrder2Atr * gSg.atr);
   gSg.sl = NormPx(s, L ? gSg.o2 - InpSLatr * gSg.atr : gSg.o2 + InpSLatr * gSg.atr);
   // costo: lo stop della gamba DEBOLE (limit 2 -> SL = InpSLatr x ATR), in punti
   gSg.stopPts = (gPt[s] > 0.0) ? MathAbs(gSg.o2 - gSg.sl) / gPt[s] : 0.0;
   if(gSg.sprPts > 0.0)
     {
      gSg.ratio  = gSg.stopPts / gSg.sprPts;
      gSg.costOk = (gSg.ratio >= InpCostoMult);
     }
   else
     {
      gSg.ratio  = -1.0;            // spread ignoto o nullo: non si dichiara "ok"
      gSg.costOk = false;
     }
  }

void RigaTrigger(const int j, const datetime barra, const datetime valutato, const string stato, const string id)
  {
   int s = gSlS[j];
   string r = Ts(barra) + ";" + Ts(valutato) + ";" + gSym[s] + ";" + gTFN[gSlK[j]] + ";" +
              ((gSg.side > 0) ? "LONG" : "SHORT") + ";" + Dn(gSg.dAtr, 3) + ";" + Dn(gSg.dLive, 3) + ";" +
              gSg.conc + ";" + gSg.htf + ";" + Dn(gSg.dHtf, 3) + ";" +
              ((gSg.sprPts >= 0.0) ? Dn(gSg.sprPts, 1) : "") + ";" + Dn(gSg.stopPts, 1) + ";" +
              ((gSg.ratio >= 0.0) ? Dn(gSg.ratio, 1) : "") + ";" + (gSg.costOk ? "1" : "0") + ";" +
              stato + ";" + id + ";" + Sig() + ";" + OMBRA_VER;
   Enqueue(gDir + "\\ombra_trigger_" + Mese(barra) + ".csv", HDR_TRIG, r);
  }

//==================================================================
//  SCANSIONE DELLE BARRE NUOVE
//==================================================================
void ScanBars(const ulong t1)
  {
   if(gNSl == 0)
      return;
   for(int c = 0; c < gNSl; c++)
     {
      if(Over(t1))
        {
         gNOver++;
         return;                       // si riprende da qui al giro dopo
        }
      int j = gRRb;
      gRRb = (gRRb + 1) % gNSl;
      int s = gSlS[j];
      string sym = gSym[s];
      ENUM_TIMEFRAMES tf = gTF7[gSlK[j]];
      datetime b0 = iTime(sym, tf, 0);
      if(b0 == 0)
         continue;
      if(gSlLastBar[j] == 0)
        {
         // primissimo avvio (nessuno stato): la barra in corso NON si valuta a posteriori
         gSlLastBar[j] = b0;
         gSlSeen[j] = MonoSec();
         gDirty = true;
         continue;
        }
      if(b0 == gSlLastBar[j])
        {
         gSlSeen[j] = MonoSec();
         continue;
        }
      if(b0 < gSlLastBar[j])
         continue;                     // serie non ancora aggiornata dopo un riavvio
      // indice dell'ultima barra valutata, letto PRIMA di toccare gSlLastBar (serve alle barre perse)
      int iOld = iBarShift(sym, tf, gSlLastBar[j], true);
      //--- barra nuova
      MqlTick tk;
      if(!SymbolInfoTick(sym, tk) || tk.bid <= 0.0 || tk.ask <= 0.0)
         continue;
      long lag = (long)tk.time - (long)b0;
      bool prompt = (gSlSeen[j] > 0 && MonoSec() - gSlSeen[j] <= InpGraceSec);
      bool late = (!prompt && lag > InpGraceSec);
      bool fatto = EvalLive(j, b0, late, tk);
      if(!fatto)
        {
         // dati non pronti: si riprova al giro dopo, ma non oltre la tolleranza
         if(lag <= InpGraceSec)
            continue;
         gCnt[j][C_VAL]++;
         gCnt[j][C_ND]++;
        }
      //--- barre perse mentre l'EA era spento: SOLO trigger, nessuna simulazione.
      //    Si fanno UNA volta, quando la barra nuova e' chiusa nei conti (non a ogni riprova).
      if(iOld > 1)
        {
         int da = IMin(iOld - 1, IMax(0, InpMaxRecuperoBarre));
         for(int q = da; q >= 1; q--)
            EvalRetro(j, q);
        }
      gSlLastBar[j] = b0;
      gSlSeen[j] = MonoSec();
      gDirty = true;
     }
  }

void EvalRetro(const int j, const int q)
  {
   int r = EvalSignal(j, q);
   if(r != SIG_TRIG)
      return;
   int s = gSlS[j];
   string sym = gSym[s];
   ENUM_TIMEFRAMES tf = gTF7[gSlK[j]];
   datetime tq = iTime(sym, tf, q);
   double po = iOpen(sym, tf, q);
   // distanza all'apertura della barra persa, rispetto alla EMA della barra chiusa prima
   // (la EMA della barra q conterrebbe la sua chiusura: futuro rispetto alla sua apertura)
   gSg.dLive = (gSg.atr > 0.0 && po > 0.0) ? (po - gSg.ema) / gSg.atr : 0.0;
   Concordanza(j, po, tq);
   gSg.sprPts = -1.0;               // spread di allora: non noto
   Livelli(s);
   gCnt[j][C_SPENTO]++;
   RigaTrigger(j, tq, TimeTradeServer(), "PERSO_SPENTO", "");
  }

bool EvalLive(const int j, const datetime b0, const bool late, const MqlTick &tk)
  {
   int r = EvalSignal(j, 0);
   if(r == SIG_ND)
      return false;
   gCnt[j][C_VAL]++;
   if(r == SIG_FASCIA)
     {
      gCnt[j][C_FASCIA]++;
      return true;
     }
   if(r == SIG_LATO)
     {
      gCnt[j][C_LATO]++;
      return true;
     }
   if(r == SIG_E14)
     {
      gCnt[j][C_E14]++;
      return true;
     }
   gCnt[j][C_TRIG]++;

   int s = gSlS[j];
   int a = s * NTF7 + gSlK[j];
   // distanza "viva" come la mostra la dashboard: (bid - EMA[0]) / ATR[1]
   double e0 = Buf(gHE[a], 0);
   gSg.dLive = (e0 > 0.0 && gSg.atr > 0.0) ? (tk.bid - e0) / gSg.atr : 0.0;
   Concordanza(j, tk.bid, tk.time);
   gSg.sprPts = (gPt[s] > 0.0) ? (tk.ask - tk.bid) / gPt[s] : -1.0;
   Livelli(s);

   int si = StorIdx(j, gSg.side);
   string stato = "";
   string id = "";
   if(gSU[si].act || gStClose[si] >= b0)
     {
      stato = "OCCUPATO";
      gCnt[j][C_OCC]++;
     }
   else
      if(late)
        {
         stato = "PERSO_RITARDO";
         gCnt[j][C_RIT]++;
        }
      else
        {
         if(Arma(j, si, b0, tk))
           {
            stato = "ARMATO";
            id = gSU[si].id;
            gCnt[j][C_ARM]++;
            gSlLastBar[j] = b0;       // nello stato la barra risulta gia' valutata
            SaveState();              // prima lo stato (il setup sopravvive), poi la riga
           }
         else
           {
            stato = "RIFIUTATO";
            gCnt[j][C_RIF]++;
           }
        }
   RigaTrigger(j, b0, tk.time, stato, id);
   return true;
  }

//--- crea il setup simulato. false = entrambi i limit sarebbero rifiutati dal server.
bool Arma(const int j, const int si, const datetime b0, const MqlTick &tk)
  {
   int s = gSlS[j];
   bool L = (gSg.side > 0);
   ResetSetup(si);
   gSU[si].id = gSym[s] + "_" + gTFN[gSlK[j]] + "_" + IntegerToString((long)b0) + (L ? "_L" : "_S");
   gSU[si].slot = j;
   gSU[si].side = gSg.side;
   gSU[si].tBar = b0;
   gSU[si].tArm = tk.time;
   gSU[si].armMsc = tk.time_msc;
   gSU[si].tExp = tk.time + IMax(1, InpExpiryBars) * PeriodSeconds(gTF7[gSlK[j]]);
   gSU[si].ema = gSg.ema;
   gSU[si].atr = gSg.atr;
   gSU[si].e14a = gSg.e14;
   gSU[si].c1 = gSg.c1;
   gSU[si].dAtr = gSg.dAtr;
   gSU[si].dLive = gSg.dLive;
   gSU[si].dHtf = gSg.dHtf;
   gSU[si].conc = gSg.conc;
   gSU[si].sprArm = gSg.sprPts;
   gSU[si].stopPts = gSg.stopPts;
   gSU[si].ratio = gSg.ratio;
   gSU[si].costOk = gSg.costOk;
   double d = StopsDist(s);
   int vivi = 0;
   for(int k = 0; k < 2; k++)
     {
      double px = (k == 0) ? gSg.o1 : gSg.o2;
      double rk = L ? (px - gSg.sl) : (gSg.sl - px);
      gSU[si].px[k] = px;
      gSU[si].sl[k] = gSg.sl;
      gSU[si].slIni[k] = gSg.sl;
      gSU[si].risk[k] = rk;
      gSU[si].tp[k] = (rk > 0.0) ? NormPx(s, L ? px + rk * InpTP_RR : px - rk * InpTP_RR) : 0.0;
      // il server rifiuta un BUY LIMIT non sotto l'Ask (SELL LIMIT non sopra il Bid) o troppo vicino
      bool ok = (rk > 0.0);
      if(ok)
        {
         if(L)
            ok = (px < tk.ask && tk.ask - px >= d && px - gSg.sl >= d && gSU[si].tp[k] - px >= d);
         else
            ok = (px > tk.bid && px - tk.bid >= d && gSg.sl - px >= d && px - gSU[si].tp[k] >= d);
        }
      if(ok)
        {
         gSU[si].st[k] = ST_PEND;
         vivi++;
        }
      else
        {
         gSU[si].st[k] = ST_RIFIUTATA;
         gSU[si].cMsc[k] = tk.time_msc;
        }
     }
   if(vivi == 0)
     {
      ResetSetup(si);
      return false;
     }
   gSU[si].act = true;
   if(!gPtrOk[s])
     {
      gLastMsc[s] = tk.time_msc;
      gNAt[s] = 1000000;            // i tick di quel millisecondo sono anteriori all'armo
      gPtrOk[s] = true;
     }
   gDirty = true;
   return true;
  }

//==================================================================
//  SIMULAZIONE DELLE GAMBE
//==================================================================
void ApriGamba(const int i, const int k, const long msc, const double bid, const double ask, const int f)
  {
   int s = gSlS[gSU[i].slot];
   bool L = (gSU[i].side > 0);
   gSU[i].st[k] = ST_APERTA;
   gSU[i].fMsc[k] = msc;
   gSU[i].vol[k] = 1.0;
   gSU[i].rr[k] = 0.0;
   gSU[i].sprF[k] = (gPt[s] > 0.0) ? (ask - bid) / gPt[s] : 0.0;
   double mark = L ? bid : ask;
   double px = gSU[i].px[k];
   double exc = (L ? mark - px : px - mark) / gSU[i].risk[k];
   gSU[i].mae[k] = exc;
   gSU[i].mfe[k] = exc;
   gSU[i].fonte |= f;
   gDirty = true;
  }

void Escursione(const int i, const int k, const double mark)
  {
   bool L = (gSU[i].side > 0);
   double px = gSU[i].px[k];
   double exc = (L ? mark - px : px - mark) / gSU[i].risk[k];
   if(exc < gSU[i].mae[k])
      gSU[i].mae[k] = exc;
   if(exc > gSU[i].mfe[k])
      gSU[i].mfe[k] = exc;
  }

void Parziale(const int i, const int k, const double price)
  {
   bool L = (gSU[i].side > 0);
   double px = gSU[i].px[k];
   double f = gSU[i].vol[k] * InpTP1Pct / 100.0;
   gSU[i].rr[k] += f * (L ? price - px : px - price) / gSU[i].risk[k];
   gSU[i].vol[k] -= f;
   gSU[i].parz[k] = true;
   gDirty = true;
  }

void ChiudiGamba(const int i, const int k, const double price, const long msc, const bool isStop)
  {
   bool L = (gSU[i].side > 0);
   double px = gSU[i].px[k];
   gSU[i].rr[k] += gSU[i].vol[k] * (L ? price - px : px - price) / gSU[i].risk[k];
   gSU[i].vol[k] = 0.0;
   gSU[i].st[k] = ST_CHIUSA;
   gSU[i].cMsc[k] = msc;
   if(isStop)
     {
      if(!gSU[i].parz[k])
         gSU[i].ex[k] = EX_SL;
      else
         if(gSU[i].sl[k] == gSU[i].slIni[k])
            gSU[i].ex[k] = EX_P_SL;
         else
            if(gSU[i].trl[k])
               gSU[i].ex[k] = EX_P_TRAIL;
            else
               gSU[i].ex[k] = EX_P_BE;
     }
   else
      gSU[i].ex[k] = gSU[i].parz[k] ? EX_P_TP : EX_TP;
   gDirty = true;
  }

//--- R del setup "in corso" (realizzato + non realizzato), per MAE/MFE del setup
void AggiornaRun(const int i, const double bid, const double ask)
  {
   bool L = (gSU[i].side > 0);
   double run = 0.0;
   bool any = false;
   for(int k = 0; k < 2; k++)
     {
      if(gSU[i].st[k] == ST_APERTA)
        {
         double mark = L ? bid : ask;
         double px = gSU[i].px[k];
         run += W_GAMBA * (gSU[i].rr[k] + gSU[i].vol[k] * (L ? mark - px : px - mark) / gSU[i].risk[k]);
         any = true;
        }
      else
         if(gSU[i].st[k] == ST_CHIUSA)
           {
            run += W_GAMBA * gSU[i].rr[k];
            any = true;
           }
     }
   if(!any)
      return;
   if(!gSU[i].sFilled)
     {
      gSU[i].sMae = run;
      gSU[i].sMfe = run;
      gSU[i].sFilled = true;
      return;
     }
   if(run < gSU[i].sMae)
      gSU[i].sMae = run;
   if(run > gSU[i].sMfe)
      gSU[i].sMfe = run;
  }

//--- EMA14 della barra CHIUSA che precede l'istante tt (quella che l'EA legge a shift 1)
double E14For(const int i, const datetime tt)
  {
   int j = gSU[i].slot;
   int s = gSlS[j];
   int k = gSlK[j];
   ENUM_TIMEFRAMES tf = gTF7[k];
   int h = gH14[s * NTF7 + k];
   if(h == INVALID_HANDLE)
      return 0.0;
   int P = PeriodSeconds(tf);
   if(P <= 0)
      return 0.0;
   datetime bs = (datetime)((long)tt - ((long)tt % P));   // M5..D1 allineati alla mezzanotte server
   if(gSU[i].e14Bar == bs && gSU[i].e14Cur > 0.0)
      return gSU[i].e14Cur;
   // v1.01: niente valore (e niente cache) finche' l'indicatore non ha calcolato tutta la serie:
   // altrimenti l'indice punterebbe alla barra sbagliata per TUTTA la barra in cache.
   int nb = Bars(gSym[s], tf);
   if(nb <= 0 || BarsCalculated(h) < nb)
      return 0.0;
   int idx = iBarShift(gSym[s], tf, bs - 1, false);
   if(idx < 0)
      return 0.0;
   datetime ti = iTime(gSym[s], tf, idx);
   if(ti == 0)
      return 0.0;
   if(ti > bs - 1)
      idx++;
   double v = Buf(h, idx);
   if(v <= 0.0)
      return 0.0;
   gSU[i].e14Bar = bs;
   gSU[i].e14Cur = v;
   return v;
  }

//--- un tick (bid/ask veri). Ordine: prima il server (scadenza, riempimento, SL, TP),
//    poi la gestione dell'EA (parziale + pareggio, poi trailing), come ManageAll().
void SimTick(const int i, const MqlTick &t)
  {
   if(t.time_msc <= gSU[i].armMsc)
      return;
   double bid = t.bid, ask = t.ask;
   if(bid <= 0.0 || ask <= 0.0)
      return;
   int s = gSlS[gSU[i].slot];
   bool L = (gSU[i].side > 0);
   double e14 = -1.0;
   for(int k = 0; k < 2; k++)
     {
      int st = gSU[i].st[k];
      if(st == ST_PEND)
        {
         if(t.time >= gSU[i].tExp)
           {
            gSU[i].st[k] = ST_SCADUTA;
            gSU[i].cMsc[k] = (long)gSU[i].tExp * 1000;
            gDirty = true;
            continue;
           }
         bool fill = L ? (ask <= gSU[i].px[k]) : (bid >= gSU[i].px[k]);
         if(fill)
            ApriGamba(i, k, t.time_msc, bid, ask, F_TICK);   // al prezzo del limit, mai meglio
         continue;
        }
      if(st != ST_APERTA)
         continue;
      double px = gSU[i].px[k];
      double mark = L ? bid : ask;
      Escursione(i, k, mark);
      bool hitSL = L ? (bid <= gSU[i].sl[k]) : (ask >= gSU[i].sl[k]);
      if(hitSL)
        {
         ChiudiGamba(i, k, mark, t.time_msc, true);     // al prezzo del tick (oltre lo stop se c'e' un buco)
         continue;
        }
      bool hitTP = L ? (bid >= gSU[i].tp[k]) : (ask <= gSU[i].tp[k]);
      if(hitTP)
        {
         ChiudiGamba(i, k, gSU[i].tp[k], t.time_msc, false);  // al TP, mai meglio
         continue;
        }
      bool beDone = L ? (gSU[i].sl[k] >= px) : (gSU[i].sl[k] <= px && gSU[i].sl[k] > 0.0);
      if(e14 < 0.0)
         e14 = E14For(i, t.time);
      if(!beDone && InpTP1Pct > 0.0 && InpTP1Pct < 100.0 && e14 > 0.0)
        {
         bool hit = L ? (bid >= e14) : (ask <= e14);
         if(hit)
           {
            // [SCOSTAMENTO dichiarato, come ABTG_EMA200_Multi_BANCO] il parziale si fa UNA volta;
            // nel vivo, se il pareggio fallisce, si ripeterebbe sul residuo a ogni tick.
            if(!gSU[i].parz[k])
               Parziale(i, k, mark);
            if(InpBreakeven)
              {
               double nsl = NormPx(s, px);
               if(SlOk(s, L, nsl, bid, ask))
                 {
                  gSU[i].sl[k] = nsl;
                  gDirty = true;
                 }
              }
           }
        }
      if(InpUseTrailing && beDone && e14 > 0.0)
        {
         double n = NormPx(s, e14);
         double cur = gSU[i].sl[k];
         bool mv = L ? (n > cur && n < bid) : ((n < cur || cur == 0.0) && n > ask);
         if(mv && SlOk(s, L, n, bid, ask))
           {
            gSU[i].sl[k] = n;
            gSU[i].trl[k] = true;
            gDirty = true;
           }
        }
     }
   AggiornaRun(i, bid, ask);
  }

//--- RIPIEGO su barre M1 (solo se i tick di un tratto passato mancano). Regole CONSERVATIVE:
//    la barra che contiene l'armo si salta; Ask = Bid + spread della barra; se nella stessa
//    barra si toccano SL e TP vince lo SL; nella barra del riempimento non si accredita il TP;
//    il parziale si fa al livello della EMA14 (non meglio) e nella sua barra non si accredita
//    il TP del residuo; pareggio e trailing si valutano sulla chiusura della barra.
void SimBarM1(const int i, const MqlRates &r, const int s)
  {
   datetime primo = (datetime)((long)gSU[i].tArm - ((long)gSU[i].tArm % 60) + 60);
   if(r.time < primo)
      return;
   double spr = (r.spread > 0) ? r.spread * gPt[s] : CurSpread(s);
   bool L = (gSU[i].side > 0);
   long mEnd = (long)r.time * 1000 + 59000;
   for(int k = 0; k < 2; k++)
     {
      int st = gSU[i].st[k];
      double px = gSU[i].px[k];
      if(st == ST_PEND)
        {
         if(r.time >= gSU[i].tExp)
           {
            gSU[i].st[k] = ST_SCADUTA;
            gSU[i].cMsc[k] = (long)gSU[i].tExp * 1000;
            gDirty = true;
            continue;
           }
         bool fill = L ? (r.low + spr <= px) : (r.high >= px);
         if(!fill)
            continue;
         ApriGamba(i, k, (long)r.time * 1000, L ? px - spr : px, L ? px : px + spr, F_M1);
         Escursione(i, k, L ? r.low : r.high + spr);
         bool slQui = L ? (r.low <= gSU[i].sl[k]) : (r.high + spr >= gSU[i].sl[k]);
         if(slQui)
            ChiudiGamba(i, k, gSU[i].sl[k], mEnd, true);
         continue;
        }
      if(st != ST_APERTA)
         continue;
      gSU[i].fonte |= F_M1;
      Escursione(i, k, L ? r.low : r.high + spr);
      Escursione(i, k, L ? r.high : r.low + spr);
      double sl = gSU[i].sl[k];
      bool hitSL = L ? (r.low <= sl) : (r.high + spr >= sl);
      if(hitSL)
        {
         double p = L ? MathMin(sl, r.open) : MathMax(sl, r.open + spr);   // buco all'apertura = peggio
         ChiudiGamba(i, k, p, mEnd, true);
         continue;
        }
      bool beDone = L ? (sl >= px) : (sl <= px && sl > 0.0);
      double e14 = E14For(i, r.time);
      bool parzQui = false;
      double cb = r.close, ca = r.close + spr;
      if(!beDone && InpTP1Pct > 0.0 && InpTP1Pct < 100.0 && e14 > 0.0)
        {
         bool hit = L ? (r.high >= e14) : (r.low + spr <= e14);
         if(hit)
           {
            if(!gSU[i].parz[k])
              {
               Parziale(i, k, e14);
               parzQui = true;
              }
            if(InpBreakeven)
              {
               double nsl = NormPx(s, px);
               if(SlOk(s, L, nsl, cb, ca))
                  gSU[i].sl[k] = nsl;
              }
           }
        }
      bool hitTP = L ? (r.high >= gSU[i].tp[k]) : (r.low + spr <= gSU[i].tp[k]);
      if(hitTP && !parzQui)
        {
         ChiudiGamba(i, k, gSU[i].tp[k], mEnd, false);
         continue;
        }
      if(InpUseTrailing && beDone && e14 > 0.0)
        {
         double n = NormPx(s, e14);
         double cur = gSU[i].sl[k];
         bool mv = L ? (n > cur && n < cb) : ((n < cur || cur == 0.0) && n > ca);
         if(mv && SlOk(s, L, n, cb, ca))
           {
            gSU[i].sl[k] = n;
            gSU[i].trl[k] = true;
           }
        }
     }
   AggiornaRun(i, r.low, r.low + spr);
   AggiornaRun(i, r.high, r.high + spr);
   gDirty = true;
  }

bool Completo(const int i)
  {
   for(int k = 0; k < 2; k++)
     {
      int st = gSU[i].st[k];
      if(st == ST_PEND || st == ST_APERTA || st == ST_VUOTA)
         return false;
     }
   return true;
  }

string ExName(const int ex)
  {
   switch(ex)
     {
      case EX_SL:      return "SL";
      case EX_TP:      return "TP";
      case EX_P_BE:    return "PARZIALE+BE";
      case EX_P_TRAIL: return "PARZIALE+TRAIL";
      case EX_P_TP:    return "PARZIALE+TP";
      case EX_P_SL:    return "PARZIALE+SL";
     }
   return "?";
  }

string LegName(const int i, const int k)
  {
   int st = gSU[i].st[k];
   if(st == ST_RIFIUTATA)
      return "RIFIUTATO";
   if(st == ST_SCADUTA)
      return "SCADUTO";
   if(st == ST_CHIUSA)
      return ExName(gSU[i].ex[k]);
   return "?";
  }

string FonteName(const int f)
  {
   string r = "";
   if((f & F_TICK) != 0)
      r += "TICK";
   if((f & F_M1) != 0)
      r += ((StringLen(r) > 0) ? "+" : "") + "M1";
   if((f & F_BUCO) != 0)
      r += ((StringLen(r) > 0) ? "+" : "") + "BUCO";
   if(StringLen(r) == 0)
      r = "NESSUNA";
   return r;
  }

void ScriviEsito(const int i)
  {
   int j = gSU[i].slot;
   int s = gSlS[j];
   int dg = gDig[s];
   int nf = 0;
   int ex0 = -1;
   bool uguali = true;
   double R = 0.0;
   long firstFill = 0, lastClose = 0;
   for(int k = 0; k < 2; k++)
     {
      if(gSU[i].cMsc[k] > lastClose)
         lastClose = gSU[i].cMsc[k];
      if(gSU[i].st[k] != ST_CHIUSA)
         continue;
      nf++;
      R += W_GAMBA * gSU[i].rr[k];
      if(firstFill == 0 || gSU[i].fMsc[k] < firstFill)
         firstFill = gSU[i].fMsc[k];
      if(ex0 < 0)
         ex0 = gSU[i].ex[k];
      else
         if(gSU[i].ex[k] != ex0)
            uguali = false;
     }
   string esito = "NON_RIEMPITO";
   if(nf > 0)
      esito = uguali ? ExName(ex0) : "MISTO";
   double attesa = (firstFill > 0) ? (firstFill - gSU[i].armMsc) / 60000.0 : 0.0;
   double durata = (firstFill > 0) ? (lastClose - firstFill) / 60000.0 : 0.0;
   datetime tChiusura = (datetime)(lastClose / 1000);
   if(tChiusura <= 0)
      tChiusura = TimeTradeServer();
   string r = gSU[i].id + ";" + Ts(gSU[i].tArm) + ";" + Ts(gSU[i].tBar) + ";" + gSym[s] + ";" + gTFN[gSlK[j]] + ";" +
              ((gSU[i].side > 0) ? "LONG" : "SHORT") + ";" + Dn(gSU[i].dAtr, 3) + ";" + Dn(gSU[i].dLive, 3) + ";" +
              gSU[i].conc + ";" + gTFN[gHTF[gSlK[j]]] + ";" + Dn(gSU[i].dHtf, 3) + ";" +
              Dn(gSU[i].ema, dg) + ";" + Dn(gSU[i].atr, dg) + ";" + Dn(gSU[i].e14a, dg) + ";" +
              Dn(gSU[i].px[0], dg) + ";" + Dn(gSU[i].px[1], dg) + ";" + Dn(gSU[i].slIni[0], dg) + ";" +
              Dn(gSU[i].tp[0], dg) + ";" + Dn(gSU[i].tp[1], dg) + ";" +
              ((gSU[i].sprArm >= 0.0) ? Dn(gSU[i].sprArm, 1) : "") + ";" + Dn(gSU[i].stopPts, 1) + ";" +
              ((gSU[i].ratio >= 0.0) ? Dn(gSU[i].ratio, 1) : "") + ";" + (gSU[i].costOk ? "1" : "0") + ";" +
              esito + ";" + Dn(R, 4) + ";" + Dn(R * InpRischioTeoricoPct, 4);
   for(int k = 0; k < 2; k++)
     {
      bool f = (gSU[i].st[k] == ST_CHIUSA);
      r += ";" + LegName(i, k) + ";" + (f ? Dn(gSU[i].rr[k], 4) : "") + ";" + (f ? TsMsc(gSU[i].fMsc[k]) : "") + ";" +
           (f ? Dn(gSU[i].sprF[k], 1) : "") + ";" + (f ? Dn(gSU[i].mae[k], 4) : "") + ";" + (f ? Dn(gSU[i].mfe[k], 4) : "");
     }
   r += ";" + (gSU[i].sFilled ? Dn(gSU[i].sMae, 4) : "") + ";" + (gSU[i].sFilled ? Dn(gSU[i].sMfe, 4) : "") + ";" +
        Dn(attesa, 1) + ";" + Dn(durata, 1) + ";" + Ts(tChiusura) + ";" + FonteName(gSU[i].fonte) + ";" + Sig() + ";" + OMBRA_VER;
   Enqueue(gDir + "\\ombra_esiti_" + Mese(tChiusura) + ".csv", HDR_ESITI, r);
   gStClose[i] = tChiusura;
  }

void Chiudi(const int i)
  {
   ScriviEsito(i);                  // prima la riga (un doppione lo toglie il lettore), poi lo stato
   ResetSetup(i);
   gDirty = true;
   SaveState();
  }

//==================================================================
//  TICK: lettura per simbolo, solo dove c'e' un setup attivo
//==================================================================
void ProcessTicksAll(const ulong t0)
  {
   for(int c = 0; c < gN; c++)
     {
      if(Over(t0))
        {
         gNOver++;
         return;
        }
      int s = gRRt;
      gRRt = (gRRt + 1) % gN;
      ProcessSym(s);
     }
  }

void ProcessSym(const int s)
  {
   int lst[];
   int nl = 0;
   long mn = LONG_MAX;
   for(int i = 0; i < ArraySize(gSU); i++)
     {
      if(!gSU[i].act || gSlS[gSU[i].slot] != s)
         continue;
      ArrayResize(lst, nl + 1);
      lst[nl] = i;
      nl++;
      if(gSU[i].armMsc < mn)
         mn = gSU[i].armMsc;
     }
   if(nl == 0)
     {
      gPtrOk[s] = false;
      return;
     }
   if(!gPtrOk[s])
     {
      gLastMsc[s] = mn;
      gNAt[s] = 1000000;
      gPtrOk[s] = true;
     }
   // [REV 05/10] dalla v1.01 E14For restituisce 0 finche' l'indicatore EMA14 non ha calcolato tutta
   // la serie: i tick letti in quel momento sarebbero CONSUMATI senza parziale/pareggio/trailing,
   // e non si rileggono piu'. Si aspetta l'indicatore SENZA avanzare il puntatore; dopo 120 giri
   // di attesa si procede lo stesso e lo si scrive nel log.
   if(!E14Pronta(s, lst, nl))
     {
      gE14Wait[s]++;
      if(gE14Wait[s] < 120)
         return;
      if(gE14Wait[s] == 120)
         LogEv(gSym[s] + ": EMA14 non pronta da 120 giri: simulo lo stesso (senza gestione finche' manca)");
     }
   else
      gE14Wait[s] = 0;
   long nowMsc = (long)TimeTradeServer() * 1000;
   long from = gLastMsc[s];
   long win = (long)IMax(1, InpFinestraMin) * 60000;
   bool catchUp = (nowMsc - from > win);
   long to = catchUp ? from + win : nowMsc + 120000;
   MqlTick tk[];
   ResetLastError();
   int n = CopyTicksRange(gSym[s], tk, COPY_TICKS_INFO, (ulong)from, (ulong)to);
   int errCT = GetLastError();
   // [REV 05/10] con ERR_HISTORY_TIMEOUT CopyTicksRange restituisce n>=0 ma solo i tick che aveva
   // (storia non ancora sincronizzata): consumarli avanzerebbe il puntatore oltre un tratto mai
   // letto = buco MUTO. Si tratta come un errore: si riprova, e in recupero dopo 3 volte si va su M1.
   if(n < 0 || errCT == ERR_HISTORY_TIMEOUT)
     {
      gErr[s]++;
      if(catchUp && gErr[s] >= 3)
        {
         LogEv(gSym[s] + ": tick non leggibili (errore " + IntegerToString(errCT) + ") fra " +
               TsMsc(from) + " e " + TsMsc(to) + ": ripiego su barre M1");
         FallbackM1(s, lst, nl, from, to);
         gErr[s] = 0;
        }
      FinisciChiusi(lst, nl);
      return;
     }
   gErr[s] = 0;
   int skip = 0, nuovi = 0;
   for(int q = 0; q < n; q++)
     {
      if(tk[q].time_msc < from)
         continue;
      if(tk[q].time_msc == from && skip < gNAt[s])
        {
         skip++;
         continue;
        }
      nuovi++;
      for(int u = 0; u < nl; u++)
         if(gSU[lst[u]].act && Completo(lst[u]) == false)
            SimTick(lst[u], tk[q]);
     }
   gNTick += nuovi;
   if(n > 0)
     {
      long last = tk[n - 1].time_msc;
      int cnt = 0;
      for(int q = n - 1; q >= 0 && tk[q].time_msc == last; q--)
         cnt++;
      if(last == from)
         gNAt[s] = IMax(gNAt[s], cnt);
      else
        {
         gLastMsc[s] = last;
         gNAt[s] = cnt;
        }
      if(nuovi > 0)
         gDirty = true;
     }
   if(nuovi == 0 && catchUp)
     {
      gZero[s]++;
      if(gZero[s] >= 3)
        {
         gZero[s] = 0;
         datetime a = (datetime)((from / 1000) - ((from / 1000) % 60) + 60);
         datetime b = (datetime)(to / 1000 - 1);
         if(b >= a && Bars(gSym[s], PERIOD_M1, a, b) > 0)
           {
            LogEv(gSym[s] + ": tratto senza tick ma con barre M1 fra " + Ts(a) + " e " + Ts(b) + ": ripiego su M1");
            FallbackM1(s, lst, nl, from, to);
           }
         else
           {
            gLastMsc[s] = to;         // mercato chiuso: tratto vuoto davvero
            gNAt[s] = 0;
            gDirty = true;
           }
        }
     }
   else
      gZero[s] = 0;
   FinisciChiusi(lst, nl);
  }

//--- [REV 05/10] EMA14 di gestione calcolata su tutta la serie per ogni setup attivo del simbolo
bool E14Pronta(const int s, const int &lst[], const int nl)
  {
   for(int u = 0; u < nl; u++)
     {
      int k = gSlK[gSU[lst[u]].slot];
      int h = gH14[s * NTF7 + k];
      if(h == INVALID_HANDLE)
         continue;                  // senza handle E14For da' sempre 0: aspettare non serve
      int nb = Bars(gSym[s], gTF7[k]);
      if(nb <= 0 || BarsCalculated(h) < nb)
         return false;
     }
   return true;
  }

void FinisciChiusi(const int &lst[], const int nl)
  {
   for(int u = 0; u < nl; u++)
     {
      int i = lst[u];
      if(gSU[i].act && Completo(i))
         Chiudi(i);
     }
  }

void FallbackM1(const int s, const int &lst[], const int nl, const long fromMsc, const long toMsc)
  {
   datetime a = (datetime)((fromMsc / 1000) - ((fromMsc / 1000) % 60) + 60);   // dal minuto intero DOPO l'ultimo tick letto
   datetime b = (datetime)(toMsc / 1000 - 1);
   // [REV 05/10] la barra M1 ANCORA IN FORMAZIONE non si simula: il puntatore andrebbe a fine
   // minuto e i tick che devono ancora arrivare in quel minuto verrebbero saltati.
   datetime adesso = TimeTradeServer();
   datetime lim = (datetime)((long)adesso - ((long)adesso % 60) - 1);
   long fineMsc = toMsc;
   bool tagliato = false;
   if(b > lim)
     {
      b = lim;
      fineMsc = (long)(lim + 1) * 1000;
      tagliato = true;
     }
   if(b < a)
     {
      if(tagliato)
         return;                    // tutto nel minuto in corso: si riprova al giro dopo
      gLastMsc[s] = toMsc;
      gNAt[s] = 0;
      gDirty = true;
      return;
     }
   MqlRates r[];
   int n = CopyRates(gSym[s], PERIOD_M1, a, b, r);
   if(n <= 0)
     {
      LogEv(gSym[s] + ": BUCO senza tick e senza M1 fra " + Ts(a) + " e " + Ts(b) + ": setup marcati BUCO");
      for(int u = 0; u < nl; u++)
         gSU[lst[u]].fonte |= F_BUCO;
      gLastMsc[s] = fineMsc;
      gNAt[s] = 0;
      gDirty = true;
      return;
     }
   for(int q = 0; q < n; q++)
      for(int u = 0; u < nl; u++)
         if(gSU[lst[u]].act && !Completo(lst[u]))
            SimBarM1(lst[u], r[q], s);
   gLastMsc[s] = (long)(r[n - 1].time + 60) * 1000;
   gNAt[s] = 0;
   gDirty = true;
  }

//==================================================================
//  STATO SU FILE (reload-safe). Scrittura atomica: .tmp poi rinomina.
//==================================================================
string SerSetup(const int i)
  {
   string r = gSU[i].id + ";" + IntegerToString(gSU[i].side) + ";" + IntegerToString((long)gSU[i].tBar) + ";" +
              IntegerToString((long)gSU[i].tArm) + ";" + IntegerToString(gSU[i].armMsc) + ";" +
              IntegerToString((long)gSU[i].tExp) + ";" + D(gSU[i].ema) + ";" + D(gSU[i].atr) + ";" + D(gSU[i].e14a) + ";" +
              D(gSU[i].c1) + ";" + D(gSU[i].dAtr) + ";" + D(gSU[i].dLive) + ";" + D(gSU[i].dHtf) + ";" + gSU[i].conc + ";" +
              D(gSU[i].sprArm) + ";" + D(gSU[i].stopPts) + ";" + D(gSU[i].ratio) + ";" + (gSU[i].costOk ? "1" : "0") + ";" +
              D(gSU[i].sMae) + ";" + D(gSU[i].sMfe) + ";" + (gSU[i].sFilled ? "1" : "0") + ";" + IntegerToString(gSU[i].fonte);
   for(int k = 0; k < 2; k++)
      r += ";" + IntegerToString(gSU[i].st[k]) + ";" + D(gSU[i].px[k]) + ";" + D(gSU[i].sl[k]) + ";" + D(gSU[i].slIni[k]) + ";" +
           D(gSU[i].tp[k]) + ";" + D(gSU[i].risk[k]) + ";" + D(gSU[i].vol[k]) + ";" + D(gSU[i].rr[k]) + ";" +
           (gSU[i].parz[k] ? "1" : "0") + ";" + (gSU[i].trl[k] ? "1" : "0") + ";" + IntegerToString(gSU[i].fMsc[k]) + ";" +
           IntegerToString(gSU[i].cMsc[k]) + ";" + D(gSU[i].sprF[k]) + ";" + D(gSU[i].mae[k]) + ";" + D(gSU[i].mfe[k]) + ";" +
           IntegerToString(gSU[i].ex[k]);
   return r;
  }

#define N_SER_TESTA  22
#define N_SER_GAMBA  16

bool DesSetup(const int i, const string &p[], const int c0)
  {
   if(ArraySize(p) < c0 + N_SER_TESTA + 2 * N_SER_GAMBA)
      return false;
   int c = c0;
   gSU[i].id = p[c++];
   gSU[i].side = (int)StringToInteger(p[c++]);
   gSU[i].tBar = (datetime)StringToInteger(p[c++]);
   gSU[i].tArm = (datetime)StringToInteger(p[c++]);
   gSU[i].armMsc = StringToInteger(p[c++]);
   gSU[i].tExp = (datetime)StringToInteger(p[c++]);
   gSU[i].ema = StringToDouble(p[c++]);
   gSU[i].atr = StringToDouble(p[c++]);
   gSU[i].e14a = StringToDouble(p[c++]);
   gSU[i].c1 = StringToDouble(p[c++]);
   gSU[i].dAtr = StringToDouble(p[c++]);
   gSU[i].dLive = StringToDouble(p[c++]);
   gSU[i].dHtf = StringToDouble(p[c++]);
   gSU[i].conc = p[c++];
   gSU[i].sprArm = StringToDouble(p[c++]);
   gSU[i].stopPts = StringToDouble(p[c++]);
   gSU[i].ratio = StringToDouble(p[c++]);
   gSU[i].costOk = (p[c++] == "1");
   gSU[i].sMae = StringToDouble(p[c++]);
   gSU[i].sMfe = StringToDouble(p[c++]);
   gSU[i].sFilled = (p[c++] == "1");
   gSU[i].fonte = (int)StringToInteger(p[c++]);
   for(int k = 0; k < 2; k++)
     {
      gSU[i].st[k] = (int)StringToInteger(p[c++]);
      gSU[i].px[k] = StringToDouble(p[c++]);
      gSU[i].sl[k] = StringToDouble(p[c++]);
      gSU[i].slIni[k] = StringToDouble(p[c++]);
      gSU[i].tp[k] = StringToDouble(p[c++]);
      gSU[i].risk[k] = StringToDouble(p[c++]);
      gSU[i].vol[k] = StringToDouble(p[c++]);
      gSU[i].rr[k] = StringToDouble(p[c++]);
      gSU[i].parz[k] = (p[c++] == "1");
      gSU[i].trl[k] = (p[c++] == "1");
      gSU[i].fMsc[k] = StringToInteger(p[c++]);
      gSU[i].cMsc[k] = StringToInteger(p[c++]);
      gSU[i].sprF[k] = StringToDouble(p[c++]);
      gSU[i].mae[k] = StringToDouble(p[c++]);
      gSU[i].mfe[k] = StringToDouble(p[c++]);
      gSU[i].ex[k] = (int)StringToInteger(p[c++]);
     }
   for(int k = 0; k < 2; k++)
      if(gSU[i].st[k] != ST_RIFIUTATA && gSU[i].risk[k] <= 0.0)
         return false;
   gSU[i].e14Bar = 0;
   gSU[i].e14Cur = 0.0;
   return true;
  }

void SaveState()
  {
   string tmp = gDir + "\\ombra_stato.tmp";
   string fin = gDir + "\\ombra_stato.txt";
   int h = FileOpen(tmp, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
     {
      Print("[OMBRA] stato non salvato: errore ", GetLastError());
      return;
     }
   // v1.01 (cancello 05/10): ogni scrittura si controlla. A disco pieno il .tmp esce troncato e
   // prima la rinomina lo metteva AL POSTO dello stato buono (setup aperti persi al riavvio).
   bool ok = true;
   ok = ok && (FileWriteString(h, "V;1;" + Sig() + "\r\n") > 0);
   ok = ok && (FileWriteString(h, "D;" + IntegerToString(gDayKey) + ";" + IntegerToString((long)gDayDate) + "\r\n") > 0);
   for(int s = 0; s < gN; s++)
      if(gPtrOk[s])
         ok = ok && (FileWriteString(h, "P;" + gSym[s] + ";" + IntegerToString(gLastMsc[s]) + ";" + IntegerToString(gNAt[s]) + "\r\n") > 0);
   for(int j = 0; j < gNSl; j++)
     {
      string r = "B;" + gSym[gSlS[j]] + ";" + gTFN[gSlK[j]] + ";" + IntegerToString((long)gSlLastBar[j]) + ";" +
                 IntegerToString((long)gStClose[j * 2]) + ";" + IntegerToString((long)gStClose[j * 2 + 1]);
      for(int c = 0; c < NCNT; c++)
         r += ";" + IntegerToString(gCnt[j][c]);
      ok = ok && (FileWriteString(h, r + "\r\n") > 0);
     }
   for(int i = 0; i < ArraySize(gSU); i++)
      if(gSU[i].act)
         ok = ok && (FileWriteString(h, "S;" + IntegerToString(i % 2) + ";" + gSym[gSlS[gSU[i].slot]] + ";" +
                         gTFN[gSlK[gSU[i].slot]] + ";" + SerSetup(i) + "\r\n") > 0);
   for(int q = 0; q < gNQ; q++)
      ok = ok && (FileWriteString(h, "Q;" + IntegerToString(gQH[q]) + ";" + gQF[q] + ";" + gQL[q] + "\r\n") > 0);
   ok = ok && (FileWriteString(h, "FINE\r\n") > 0);
   FileClose(h);
   if(!ok)
     {
      Print("[OMBRA] stato NON salvato (scrittura fallita, disco pieno?): resta valido quello precedente");
      gLastSave = MonoSec();        // si riprova fra InpStatoSec, non a ogni giro
      return;                       // gDirty resta true
     }
   if(!FileMove(tmp, 0, fin, FILE_REWRITE))
      Print("[OMBRA] stato: rinomina fallita, errore ", GetLastError());
   gDirty = false;
   gLastSave = MonoSec();
  }

void LoadState()
  {
   string fin = gDir + "\\ombra_stato.txt";
   if(!FileIsExist(fin))
     {
      LogEv("nessuno stato precedente: partenza pulita");
      return;
     }
   int h = FileOpen(fin, FILE_READ | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
     {
      LogEv("stato presente ma non leggibile (errore " + IntegerToString(GetLastError()) + "): partenza pulita");
      return;
     }
   int nS = 0, nB = 0, nP = 0, nQ = 0, nScart = 0;
   bool fine = false;
   string sigFile = "";
   while(!FileIsEnding(h))
     {
      string line = FileReadString(h);
      if(StringLen(line) == 0)
         continue;
      if(line == "FINE")
        {
         fine = true;
         continue;
        }
      string p[];
      int np = StringSplit(line, ';', p);
      if(np < 1)
         continue;
      if(p[0] == "V" && np >= 3)
         sigFile = p[2];
      else
         if(p[0] == "D" && np >= 3)
           {
            gDayKey = StringToInteger(p[1]);
            gDayDate = (datetime)StringToInteger(p[2]);
           }
         else
            if(p[0] == "P" && np >= 4)
              {
               int s = FindSym(p[1]);
               if(s >= 0)
                 {
                  gLastMsc[s] = StringToInteger(p[2]);
                  gNAt[s] = (int)StringToInteger(p[3]);
                  gPtrOk[s] = true;
                  nP++;
                 }
              }
            else
               if(p[0] == "B" && np >= 6 + NCNT)
                 {
                  int j = FindSlot(p[1], p[2]);
                  if(j >= 0)
                    {
                     gSlLastBar[j] = (datetime)StringToInteger(p[3]);
                     gStClose[j * 2] = (datetime)StringToInteger(p[4]);
                     gStClose[j * 2 + 1] = (datetime)StringToInteger(p[5]);
                     for(int c = 0; c < NCNT; c++)
                        gCnt[j][c] = StringToInteger(p[6 + c]);
                     nB++;
                    }
                 }
               else
                  if(p[0] == "S" && np >= 4)
                    {
                     int j = FindSlot(p[2], p[3]);
                     int lato = (int)StringToInteger(p[1]);
                     if(j < 0)
                       {
                        nScart++;
                        LogEv("stato: setup su " + p[2] + " " + p[3] + " non piu' in lista: scartato (non simulato)");
                        continue;
                       }
                     // l'indice salvato si riprende com'era (con InpUnoPerLato cambiato fra due avvii
                     // un setup in posizione 1 resta simulato ma non blocca: lo dice l'avviso dei parametri)
                     int i = j * 2 + ((lato == 1) ? 1 : 0);
                     ResetSetup(i);
                     if(DesSetup(i, p, 4))
                       {
                        gSU[i].slot = j;
                        gSU[i].act = true;
                        nS++;
                       }
                     else
                       {
                        ResetSetup(i);
                        nScart++;
                        LogEv("stato: riga di setup illeggibile, scartata");
                       }
                    }
                  else
                     if(p[0] == "Q" && np >= 4)
                       {
                        // la riga in coda contiene ';': si ricostruisce dopo il terzo separatore
                        int p1 = StringFind(line, ";", 0);
                        int p2 = StringFind(line, ";", p1 + 1);
                        int p3 = StringFind(line, ";", p2 + 1);
                        if(p1 > 0 && p2 > p1 && p3 > p2)
                          {
                           ArrayResize(gQF, gNQ + 1);
                           ArrayResize(gQH, gNQ + 1);
                           ArrayResize(gQL, gNQ + 1);
                           gQH[gNQ] = (int)StringToInteger(StringSubstr(line, p1 + 1, p2 - p1 - 1));
                           gQF[gNQ] = StringSubstr(line, p2 + 1, p3 - p2 - 1);
                           gQL[gNQ] = StringSubstr(line, p3 + 1);
                           gNQ++;
                           nQ++;
                          }
                       }
     }
   FileClose(h);
   if(!fine)
      LogEv("ATTENZIONE: stato senza riga FINE (scrittura interrotta?): letto quello che c'era");
   if(sigFile != Sig())
      LogEv("ATTENZIONE: parametri cambiati rispetto allo stato (" + sigFile + " -> " + Sig() +
            "): i setup ripresi tengono i LORO livelli, la gestione usa i parametri NUOVI");
   LogEv(StringFormat("stato ripreso: %d setup attivi, %d slot, %d puntatori tick, %d righe in coda, %d scartati",
                      nS, nB, nP, nQ, nScart));
  }
//+------------------------------------------------------------------+
