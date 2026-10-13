//+------------------------------------------------------------------+
//|                                     CLAU12_ORO_CESTO_CAPATO.mq5   |
//|                                                                   |
//|  C12OC -- cesto di ingressi a scala sull'oro, con CODA CAPATA.    |
//|                                                                   |
//|  PATERNITA': IL MECCANISMO E' OSSERVATO, IL CODICE E' NOSTRO.     |
//|  Fonte: un giorno di ordini (13/10/2026) di un EA di terzi del    |
//|  Market sul demo, scatola nera, NESSUN sorgente, nessuna          |
//|  decompilazione. Schede: report/MARKET_SCHEDA_FINLABX_CF_DZR_     |
//|  2026-10-13.md e report/MARKET_MOTORE_FINLABX_RICOSTRUZIONE_      |
//|  2026-10-13.md. Specifica: report/PROGETTO_CLAU12_ORO_CESTO_      |
//|  CAPATO_2026-10-13.md. Il segnale d'avvio dell'EA di terzi NON e' |
//|  noto: qui ci sono DUE avvii nostri e un CONTROLLO NULLO.         |
//|                                                                   |
//|  LA LOGICA (una riga per regola, con la funzione che la fa):      |
//|   R1 avvio alla CHIUSURA di una barra del TF d'avvio (primo tick   |
//|      della barra nuova -> C12NuovaBarra). Tre modi:               |
//|      0 = CONTROLLO NULLO: istante e lato pseudo-casuali, seme      |
//|          fisso, chiave = ora della barra (C12Nullo)               |
//|      1 = ROTTURA: close > massimo delle N barre prima della barra  |
//|          di segnale -> lungo; < minimo -> corto (C12SegnaleRottura)|
//|      2 = RITORNO: close < EMA - k x ATR -> lungo; > EMA + k x ATR  |
//|          -> corto (C12SegnaleRitorno)                             |
//|      InpDirezioneCasuale: modi 1/2 con il LATO pseudo-casuale     |
//|      (stessi istanti, direzione a moneta): secondo controllo.     |
//|   R2 livello 1 a mercato, lotto base, SL DI CESTO gia' sul primo   |
//|      ticket: SL = P1 -/+ ((Lmax-1) x passo + InpSLOltreUltimoUSD) |
//|      (C12SLCesto). Nessuna posizione nasce senza SL.              |
//|   R3 livelli 2..Lmax a mercato quando il prezzo d'ingresso (Ask    |
//|      lungo, Bid corto) entra nella finestra [Lk - passo/2, Lk]    |
//|      (lungo), Lk = P1 - (k-1) x passo (C12LivelloPrezzo,          |
//|      C12InFinestra). Un livello per tick. Saltato se il prezzo e' |
//|      oltre la finestra (gap): mai ingressi ammucchiati vicino allo |
//|      SL. TETTO: al massimo InpLivelliMax posizioni per cesto.     |
//|   R4 lotto del livello k = base x min(1 + (k-1) x incremento,      |
//|      tetto) arrotondato IN GIU' al passo (C12LottoLivello).       |
//|      Default incremento 0 = scala PIATTA. Nessun raddoppio.       |
//|   R5 uscita a cesto: TP di TUTTE le posizioni = media ponderata    |
//|      d'ingresso +/- InpTargetUSD, rimesso a ogni livello nuovo    |
//|      (C12Target, C12TargetDopo; sincronizzazione in               |
//|      C12GestisciLato). SL e TP stanno sul SERVER: se l'EA muore   |
//|      il cesto resta protetto.                                     |
//|   R6 rischio pianificato del cesto (a SL, tutti i livelli pieni)   |
//|      calcolato PRIMA del primo ticket (C12RischioPrezzoLotti);    |
//|      se supera InpRischioMaxCesto (valuta del conto, 0 = spento)  |
//|      il cesto NON parte.                                          |
//|   R7 un solo cesto per lato; InpDueLatiInsieme=false = un solo     |
//|      cesto in tutto (niente lungo e corto insieme).               |
//|   R8 PAUSE DI SESSIONE (giornaliera E weekend): niente cesti nuovi |
//|      da InpPausaStopNuoviMin minuti prima della fine della         |
//|      sessione in corso, chiusura di tutto da InpPausaChiudiMin    |
//|      minuti prima (C12StatoPausa, C12FineSessioneCorrente). Le    |
//|      sessioni si LEGGONO dalle specifiche del simbolo (nessuna ora |
//|      fissa d'ingresso). Il venerdi' la fine e' anche TAGLIATA a   |
//|      InpVenerdiFineMax (ora server, 22 = chiusura estiva dell'oro |
//|      con BCM a UTC+1 fisso): tetto di SICUREZZA contro le         |
//|      specifiche che non seguono l'ora legale di New York.         |
//|      PERCHE': nel proxy i cesti oltre la perdita pianificata sono |
//|      TUTTI gap (weekend, pausa delle 22-23, buchi di dati):       |
//|      lo SL sul server non protegge da un gap.                     |
//|   R9 filtro spread: niente avvio e niente livello nuovo con        |
//|      spread > InpSpreadMaxUSD (C12SpreadOk).                      |
//|   R10 Guardian (firme B1/C1) IMMEDIATAMENTE prima di ogni          |
//|      trade.Buy / trade.Sell (C12Apri). Mai sulle chiusure.        |
//|   R11 margine libero verificato prima dell'ordine (C12MargineOk)   |
//|                                                                   |
//|  MISURE NEL GIORNALE (per il lettore, formato chiave=valore):     |
//|   [C12OC-AVVIO]  ogni cesto che parte: lato, P1, SL, rischio       |
//|                  pianificato, spread, SL/spread, target/spread    |
//|   [C12OC-CESTO]  ogni cesto chiuso: profondita', lotti, netto      |
//|                  (profitto+swap+commissioni), MAE in valuta,      |
//|                  durata, motivo (TP/SL/PAUSA/SUP/ALTRO), e        |
//|                  oltre_rischio=SI se il netto e' peggio del       |
//|                  rischio pianificato (la CODA: gap, slippage)     |
//|   [C12OC-PAUSA-ATTRAVERSATA] un cesto vivo attraverso un buco di  |
//|                  tick > 45 minuti (weekend, pausa): DIFETTO       |
//|   [C12OC-CONTA]  in OnDeinit: totali, per profondita', scarti      |
//|                                                                   |
//|  OROLOGIO: ore SERVER. BCM e' UTC+1 FISSO (misura del 24/09).     |
//|  NIENTE WebRequest, SendMail, notifiche, #import.                 |
//|  NIENTE IN FORWARD: nasce solo per lo Strategy Tester. Portarlo   |
//|  su un conto e' una firma di Claudio; taglie e rischio pure.      |
//|  REGOLA DI CASA: anche capato, con InpLivelliMax > 1 questo e' un |
//|  cesto che MEDIA a prezzo peggiore (scheda par. 4: "proibita per  |
//|  la challenge di casa"). E' uno STRUMENTO DI MISURA. Con          |
//|  InpLivelliMax = 1 non media: un ingresso, SL e TP fissi.         |
//+------------------------------------------------------------------+
//  CHANGELOG
//  v1.00  13/10/2026 -- prima stesura, dalla specifica. NON compilata
//         (MetaEditor assente nell'ambiente di scrittura), NON
//         testata nel tester. Il nucleo puro e' stato compilato in
//         C++ e confrontato col proxy Python a tavolino (specifica,
//         AUTOVERIFICA).
//+------------------------------------------------------------------+
#property strict
#property copyright "CLAU12 -- cesto capato sull'oro: meccanismo osservato, codice nostro"
#property version   "1.00"

#include <Trade\Trade.mqh>
//--- firme B1/C1 del 18/08: la guardia del conto, lato EA.
//    Fail-open: input spento, conto senza Guardian o Strategy Tester
//    -> l'EA si comporta come se la riga non ci fosse.
#include <ABTG_PausaGuardian.mqh>
CTrade trade;

//==================================================================
// CODICI
//==================================================================
#define C12_LATO_L       1
#define C12_LATO_S      -1

#define C12_OK           0
#define C12_NO_SEGNALE   1
#define C12_CESTO_VIVO   2
#define C12_ALTRO_LATO   3
#define C12_PAUSA        4
#define C12_SPREAD       5
#define C12_RISCHIO      6
#define C12_LATO_SPENTO  7
#define C12_DATI         8
#define C12_ORDINE_KO    9
#define C12_N_MOTIVI    10

#define C12_PAUSA_LIBERO 0
#define C12_PAUSA_STOP   1
#define C12_PAUSA_CHIUDI 2

#define C12_MAX_SESSIONI 8

#define C12_MAX_LIVELLI 10

//==================================================================
// INPUT -- SIMBOLO E TIMEFRAME
//==================================================================
input group "=== Simbolo e timeframe ==="
input string          InpSymbol  = "";        // Simbolo ("" = simbolo del grafico)
input ENUM_TIMEFRAMES InpTFAvvio = PERIOD_M1; // TF del segnale d'avvio (l'EA osservato era su M1)

//==================================================================
// INPUT -- AVVIO DEL CESTO (il punto debole: NON osservato)
//==================================================================
input group "=== Avvio del cesto ==="
input int    InpModoAvvio        = 1;     // 0 = CONTROLLO NULLO (casuale) | 1 = ROTTURA di N barre | 2 = RITORNO verso l'EMA
input bool   InpDirezioneCasuale = false; // Modi 1/2: stessi istanti, LATO pseudo-casuale (secondo controllo nullo)
input int    InpSemeNullo        = 1;     // Seme del generatore pseudo-casuale (modo 0 e direzione casuale)
input double InpProbNullo        = 0.0;   // Modo 0: probabilita' di avvio per barra (0 < p <= 1; si fissa dalla FREQUENZA dei modi 1/2, mai dal PF)
input int    InpRotturaBarre     = 20;    // Modo 1: N barre del canale, ESCLUSA la barra di segnale
input int    InpRitornoEma       = 50;    // Modo 2: periodo dell'EMA
input int    InpRitornoAtr       = 14;    // Modo 2: periodo dell'ATR
input double InpRitornoK         = 2.0;   // Modo 2: distanza minima close-EMA in ATR
input bool   InpAllowLong        = true;  // Lato LUNGO consentito
input bool   InpAllowShort       = true;  // Lato CORTO consentito
input bool   InpDueLatiInsieme   = true;  // true = un cesto per lato (lungo e corto possono convivere) | false = un solo cesto in tutto

//==================================================================
// INPUT -- IL CESTO (tutto CAPATO)
//==================================================================
input group "=== Cesto: scala, tetto, uscita ==="
input int    InpLivelliMax       = 4;     // Profondita' MASSIMA del cesto (posizioni), 1..10. ASSE 3 / 4 / 6
input double InpPassoUSD         = 1.5;   // Passo fra i livelli, USD di prezzo. ASSE 1,0 / 1,5 / 2,0
input double InpSLOltreUltimoUSD = 8.0;   // SL di cesto: distanza OLTRE l'ultimo livello, USD (8 = 40 x spread 0,20)
input double InpTargetUSD        = 1.0;   // Uscita: media ponderata d'ingresso +/- X USD (TP comune)
input double InpLottoBase        = 0.01;  // Lotto del livello 1 (0,01 = quello osservato; NON e' una taglia proposta)
input double InpScalaIncremento  = 0.0;   // Lotto livello k = base x (1 + (k-1) x incr.). 0 = PIATTA. Osservato ~0,5. Max 1,0
input double InpScalaTettoMult   = 3.0;   // Tetto del lotto di un livello, in multipli del base (1..5)
input double InpRischioMaxCesto  = 0.0;   // Rischio MASSIMO pianificato per cesto, valuta del conto (0 = spento). DA DECIDERE CON CLAUDIO
input double InpCommStimaLotto   = 0.0;   // Commissione A/R per lotto, valuta del conto: SOLO per la stima del rischio nei log (il tester applica la sua)

//==================================================================
// INPUT -- PROTEZIONI
//==================================================================
input group "=== Protezioni ==="
input double InpSpreadMaxUSD        = 0.40; // Spread massimo per avvii e livelli nuovi, USD (0 = filtro spento)
input int    InpPausaStopNuoviMin   = 120;  // Niente cesti nuovi da N minuti prima della fine della sessione in corso (pausa giornaliera e weekend)
input int    InpPausaChiudiMin      = 90;   // Chiusura di TUTTI i cesti da N minuti prima della fine della sessione in corso
input int    InpVenerdiFineMax      = 22;   // Tetto di sicurezza: ora SERVER oltre la quale la sessione del venerdi' si considera finita (1-24)
input int    InpSlippagePoints      = 30;   // Slippage massimo (punti)
input bool   InpCheckFreeMargin     = true; // Verifica il margine libero prima dell'ordine

//==================================================================
// INPUT -- IDENTITA' E STANDARD DI CASA
//==================================================================
input group "=== Identita' e standard di casa ==="
//--- Magic 775600: blocco 7756xx LIBERO, verificato il 13/10/2026 con
//    git grep su TUTTO origin/lavoro (2dacbe64) e sui file non
//    tracciati del checkout principale: zero occorrenze di 7756xx.
//    7755xx e 7757xx/7758xx sono occupati. Il magic dell'EA osservato
//    NON si usa: e' la sua identita', non la nostra.
input long   InpMagic       = 775600;  // Magic Number
input string InpComment     = "C12OC"; // Prefisso commento (commento = prefisso + "_L3"/"_S10", max 21 caratteri)
input bool   InpUsaGuardian = true;    // Guardian: ferma i NUOVI ingressi (firme B1/C1)
input bool   InpVerbose     = true;    // Stampe informative (AVVIO/CESTO/errori si stampano sempre)
input bool   InpAutoTest    = true;    // Stampa le righe [C12OC][AUTOTEST] in avvio

//==================================================================
// VARIABILI GLOBALI
//==================================================================
string          g_sym     = "";
string          g_nome    = "";
ENUM_TIMEFRAMES g_tf      = PERIOD_M1;
int             g_hEma    = INVALID_HANDLE;
int             g_hAtr    = INVALID_HANDLE;
datetime        g_lastBar = 0;
//--- sessioni di trading del simbolo per giorno (0 = domenica), in
//    secondi dalla mezzanotte server, lette UNA volta in OnInit
int             g_sesDa[7][C12_MAX_SESSIONI];
int             g_sesA[7][C12_MAX_SESSIONI];
int             g_sesN[7];
bool            g_sesLette = false;
datetime        g_ultimoTick = 0;

//--- memoria del cesto, indice 0 = LUNGO, 1 = CORTO. NON e' critica:
//    SL, livelli e target si ricavano dalle posizioni (riavvio sicuro).
//    Si perdono a un riavvio solo MAE, ora di partenza e rischio
//    pianificato, che servono ai LOG (dichiarato nella riga CESTO).
bool     g_vivo[2];
bool     g_ricostruito[2];
datetime g_t0[2];
double   g_sl[2];
double   g_mae[2];
double   g_rischio[2];
double   g_spread0[2];
int      g_avvio[2];
bool     g_inChiusura[2];
string   g_motivoChiusura[2];
datetime g_ultimoErr[2];
datetime g_ultimoSalto[2];     // barra dell'ultimo livello saltato per gap (conteggio)
datetime g_tentativoKO[2];     // barra dell'ultimo livello NON partito: si ritenta alla barra dopo
ulong    g_idsL[];
ulong    g_idsS[];

//--- contatori
int      g_conta[C12_N_MOTIVI];
int      g_statN[C12_MAX_LIVELLI + 1];
double   g_statNet[C12_MAX_LIVELLI + 1];
int      g_statNeg[C12_MAX_LIVELLI + 1];
double   g_statPeggiore[C12_MAX_LIVELLI + 1];
double   g_profLordi = 0.0;
double   g_perdLorde = 0.0;
double   g_maePeggiore = 0.0;
int      g_motTP = 0, g_motSL = 0, g_motPAUSA = 0, g_motSUP = 0, g_motALTRO = 0;
int      g_pauseAttraversate = 0;
int      g_oltreRischio = 0;
double   g_oltreRischioSomma = 0.0;
int      g_livelliSaltati = 0;

void Log(string m) { if(InpVerbose) Print("[C12OC] ", m); }

//==================================================================
// NUCLEO PURO -- niente mercato, niente conto. Sono le funzioni che
// l'autotest interroga in avvio e che il collaudo compila in C++.
// MARCATORE_NUCLEO_INIZIO
//==================================================================

//--- R1 modo 0: mescolatore a 32 bit (moltiplicazioni modulo 2^32).
uint C12Mix(uint x)
{
   x = x ^ (x >> 16);
   x = x * (uint)0x7feb352d;
   x = x ^ (x >> 15);
   x = x * (uint)0x2c1b3c6d;
   x = x ^ (x >> 16);
   return x;
}

//--- R1 modo 0: la barra con ora tBarra fa partire un cesto con
//    probabilita' p, lato a moneta. La chiave e' l'ORA DELLA BARRA
//    (minuti), non un contatore: lo stesso seme da' gli stessi
//    istanti qualunque cosa sia successo prima (cesti vivi, riavvii).
bool C12Nullo(const int seme, const long tBarra, const double p, int &lato)
{
   uint k  = (uint)(tBarra / 60);
   uint s  = C12Mix((uint)(seme * 2 + 1));
   uint h1 = C12Mix(k ^ s);
   uint h2 = C12Mix(h1 ^ (uint)0x5bd1e995);
   double u = (double)(h1 >> 8) / 16777216.0;
   lato = ((h2 >> 31) == 0) ? C12_LATO_L : C12_LATO_S;
   return (u < p);
}

//--- R1 modo 1: rottura STRETTA del canale delle N barre PRECEDENTI
//    alla barra di segnale (uguale = niente). +1 / -1 / 0.
int C12SegnaleRottura(const double close1, const double hh, const double ll)
{
   if(close1 > hh) return C12_LATO_L;
   if(close1 < ll) return C12_LATO_S;
   return 0;
}

//--- R1 modo 2: close lontano dall'EMA piu' di k x ATR -> si punta
//    sul RITORNO (sotto -> lungo, sopra -> corto). ATR <= 0 -> niente.
int C12SegnaleRitorno(const double close1, const double ema, const double atr, const double k)
{
   if(atr <= 0.0 || k <= 0.0) return 0;
   if(close1 < ema - k * atr) return C12_LATO_L;
   if(close1 > ema + k * atr) return C12_LATO_S;
   return 0;
}

//--- R3: prezzo del livello k (k = 1 e' P1).
double C12LivelloPrezzo(const int lato, const double p1, const int k, const double passo)
{
   return p1 - lato * (k - 1) * passo;
}

//--- R2: SL di cesto, uguale per tutte le posizioni del cesto.
double C12SLCesto(const int lato, const double p1, const int lmax, const double passo, const double oltre)
{
   return p1 - lato * ((lmax - 1) * passo + oltre);
}

//--- R3: il prezzo d'ingresso (Ask lungo, Bid corto) sta nella
//    finestra del livello: da Lk fino a mezzo passo OLTRE Lk.
bool C12InFinestra(const int lato, const double prezzo, const double lk, const double passo, const double eps)
{
   if(lato > 0) return (prezzo <= lk + eps && prezzo >= lk - 0.5 * passo - eps);
   return (prezzo >= lk - eps && prezzo <= lk + 0.5 * passo + eps);
}

//--- livello (1..) di una posizione aperta al prezzo x.
int C12LivelloDaPrezzo(const int lato, const double p1, const double x, const double passo)
{
   if(passo <= 0.0) return 1;
   double d = (lato > 0) ? (p1 - x) : (x - p1);
   int k = (int)MathRound(d / passo) + 1;
   if(k < 1) k = 1;
   return k;
}

//--- R3: il livello da riempire adesso (0 = nessuno). maxK = livello
//    piu' profondo gia' riempito, nPos = posizioni vive. Si cerca fra
//    maxK+1..lmax la finestra che contiene il prezzo: le finestre non
//    si sovrappongono, quindi al massimo una risponde.
int C12LivelloDaRiempire(const int lato, const double p1, const double prezzo, const double passo,
                         const int maxK, const int nPos, const int lmax, const double eps)
{
   if(nPos >= lmax) return 0;
   for(int k = maxK + 1; k <= lmax; k++)
      if(C12InFinestra(lato, prezzo, C12LivelloPrezzo(lato, p1, k, passo), passo, eps)) return k;
   return 0;
}

//--- R4: lotto del livello k, arrotondato IN GIU' al passo di volume;
//    sotto il minimo -> 0 (si salta, non si alza); sopra il massimo ->
//    massimo. Moltiplicatore = 1 + (k-1) x incr, tagliato al tetto.
double C12LottoLivello(const int k, const double base, const double incr, const double tetto,
                       const double step, const double vmin, const double vmax)
{
   if(k < 1 || base <= 0.0 || step <= 0.0) return 0.0;
   double mult = 1.0 + (k - 1) * incr;
   if(mult > tetto) mult = tetto;
   if(mult < 1.0) mult = 1.0;
   double v = MathFloor(base * mult / step + 1e-9) * step;
   if(v < vmin - 1e-12) return 0.0;
   if(vmax > 0.0 && v > vmax) v = vmax;
   return v;
}

//--- R6: rischio pianificato del cesto in PREZZO x LOTTI (tutti i
//    livelli pieni ai loro prezzi di griglia, tutti chiusi allo SL).
//    Per avere la valuta si moltiplica per il valore di 1,0 di prezzo
//    su 1 lotto. Il livello k sta a (lmax-k) x passo + oltre dallo SL.
double C12RischioPrezzoLotti(const int lmax, const double passo, const double oltre,
                             const double base, const double incr, const double tetto,
                             const double step, const double vmin, const double vmax)
{
   double r = 0.0;
   for(int k = 1; k <= lmax; k++)
      r += C12LottoLivello(k, base, incr, tetto, step, vmin, vmax) * ((lmax - k) * passo + oltre);
   return r;
}

//--- somma dei lotti pianificati (per la commissione stimata).
double C12LottiPianificati(const int lmax, const double base, const double incr, const double tetto,
                           const double step, const double vmin, const double vmax)
{
   double r = 0.0;
   for(int k = 1; k <= lmax; k++) r += C12LottoLivello(k, base, incr, tetto, step, vmin, vmax);
   return r;
}

//--- R5: target del cesto dalla media ponderata.
double C12Target(const int lato, const double media, const double t)
{
   return media + lato * t;
}

//--- R5: target se si aggiunge un lotto al prezzo px.
double C12TargetDopo(const int lato, const double sommaPxVol, const double sommaVol,
                     const double px, const double lotto, const double t)
{
   double v = sommaVol + lotto;
   if(v <= 0.0) return 0.0;
   return C12Target(lato, (sommaPxVol + px * lotto) / v, t);
}

//--- R5: target gia' superato dal prezzo di CHIUSURA (Bid lungo, Ask
//    corto): il TP non si puo' piu' mettere, si chiude a mercato.
bool C12TargetSuperato(const int lato, const double prezzoChiusura, const double target)
{
   if(lato > 0) return (prezzoChiusura >= target);
   return (prezzoChiusura <= target);
}

//--- R9: spread ammesso. maxUSD <= 0 = filtro spento.
bool C12SpreadOk(const double spread, const double maxUSD)
{
   if(maxUSD <= 0.0) return true;
   return (spread <= maxUSD + 1e-9);
}

//--- R8: stato rispetto alla prossima PAUSA. sec = secondi dalla
//    mezzanotte server; fine = secondi (dalla STESSA mezzanotte, puo'
//    superare 86400 se la sessione continua nel giorno dopo) in cui
//    finisce la sessione in corso con una pausa VERA dopo; fine < 0 =
//    nessuna pausa in vista o sessioni non lette (allora: libero).
//    sec oltre la fine (tick fuori sessione) -> chiudere.
int C12StatoPausa(const int sec, const int fine, const int minStop, const int minChiudi)
{
   if(fine < 0) return C12_PAUSA_LIBERO;
   if(sec >= fine - minChiudi * 60) return C12_PAUSA_CHIUDI;
   if(sec >= fine - minStop * 60)   return C12_PAUSA_STOP;
   return C12_PAUSA_LIBERO;
}

//--- R8: il tetto del venerdi'. fine < 0 (ignota) o oltre il tetto ->
//    tetto. dow 5 = venerdi'; negli altri giorni non tocca niente.
int C12TettoVenerdi(const int dow, const int fine, const int tettoOra)
{
   if(dow != 5 || tettoOra <= 0) return fine;
   int tetto = tettoOra * 3600;
   if(fine < 0 || fine > tetto) return tetto;
   return fine;
}

//--- R7: un cesto puo' partire sul lato?
bool C12LatoLibero(const int lato, const bool vivoL, const bool vivoS, const bool dueLati)
{
   bool proprio = (lato > 0) ? vivoL : vivoS;
   bool altro   = (lato > 0) ? vivoS : vivoL;
   if(proprio) return false;
   if(!dueLati && altro) return false;
   return true;
}

//--- R1 + R6..R9: la decisione d'avvio su una barra chiusa (0 = niente).
int C12DecidiAvvio(const int segnale, const bool allowL, const bool allowS,
                   const bool vivoL, const bool vivoS, const bool dueLati,
                   const int statoPausa, const double spread, const double maxSpread,
                   const double rischio, const double maxRischio, int &motivo)
{
   if(segnale == 0)                                         { motivo = C12_NO_SEGNALE;  return 0; }
   if((segnale > 0 && !allowL) || (segnale < 0 && !allowS)) { motivo = C12_LATO_SPENTO; return 0; }
   bool proprio = (segnale > 0) ? vivoL : vivoS;
   if(proprio)                                              { motivo = C12_CESTO_VIVO;  return 0; }
   if(!C12LatoLibero(segnale, vivoL, vivoS, dueLati))       { motivo = C12_ALTRO_LATO;  return 0; }
   if(statoPausa != C12_PAUSA_LIBERO)                       { motivo = C12_PAUSA;       return 0; }
   if(!C12SpreadOk(spread, maxSpread))                      { motivo = C12_SPREAD;      return 0; }
   if(maxRischio > 0.0 && rischio > maxRischio)             { motivo = C12_RISCHIO;     return 0; }
   motivo = C12_OK;
   return segnale;
}
//==================================================================
// MARCATORE_NUCLEO_FINE
//==================================================================

//==================================================================
// LETTURE DI MERCATO E DI CONTO
//==================================================================
int C12Idx(const int lato) { return (lato > 0) ? 0 : 1; }

ENUM_ORDER_TYPE_FILLING GetFillingMode(string sym)
{
   long modes = (long)SymbolInfoInteger(sym, SYMBOL_FILLING_MODE);
   if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
   if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

double C12ValorePrezzoLotto()
{
   double ts = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   double tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tv <= 0.0) tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
   if(ts <= 0.0 || tv <= 0.0) return 0.0;
   return tv / ts;
}

//--- R6: rischio pianificato in valuta del conto (price risk + stima
//    commissione). 0 se i dati del simbolo non si leggono.
double C12RischioValuta()
{
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   double vmin = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   double pl = C12RischioPrezzoLotti(InpLivelliMax, InpPassoUSD, InpSLOltreUltimoUSD, InpLottoBase,
                                     InpScalaIncremento, InpScalaTettoMult, step, vmin, vmax);
   double lotti = C12LottiPianificati(InpLivelliMax, InpLottoBase, InpScalaIncremento, InpScalaTettoMult,
                                      step, vmin, vmax);
   return pl * C12ValorePrezzoLotto() + lotti * InpCommStimaLotto;
}

//--- R8: legge le sessioni di trading del simbolo per i 7 giorni.
//    Una sessione che arriva a mezzanotte ha fine 86400 (MT5 la da'
//    come 24:00 = 86400 s). Ritorna true se almeno un giorno ne ha.
bool C12LeggiSessioni()
{
   bool qualcuna = false;
   for(int d = 0; d < 7; d++)
   {
      g_sesN[d] = 0;
      for(uint i = 0; i < C12_MAX_SESSIONI; i++)
      {
         datetime da = 0, a = 0;
         if(!SymbolInfoSessionTrade(g_sym, (ENUM_DAY_OF_WEEK)d, i, da, a)) break;
         int s0 = (int)((long)da % 86400);
         int s1 = ((long)a >= 86400) ? 86400 : (int)((long)a % 86400);
         if(s1 <= s0) continue;   // sessione vuota o malformata: ignorata
         g_sesDa[d][g_sesN[d]] = s0;
         g_sesA[d][g_sesN[d]]  = s1;
         g_sesN[d]++;
         qualcuna = true;
      }
   }
   return qualcuna;
}

//--- R8: fine (secondi dalla mezzanotte di OGGI) della sessione in
//    corso, se dopo c'e' una pausa VERA. -1 = sessioni non lette o
//    nessuna pausa in vista. Fuori da ogni sessione del giorno ->
//    ritorna sec (siamo IN pausa: niente cesti, chiudere).
//    Se la sessione arriva a mezzanotte e il giorno dopo ne parte una
//    da 00:00, si prosegue UNA volta nel giorno dopo (+86400).
int C12FineSessioneCorrente(const int dow, const int sec)
{
   if(!g_sesLette || dow < 0 || dow > 6 || g_sesN[dow] == 0) return -1;
   int fine = -2;
   for(int i = 0; i < g_sesN[dow]; i++)
      if(sec >= g_sesDa[dow][i] && sec < g_sesA[dow][i]) { fine = g_sesA[dow][i]; break; }
   if(fine == -2) return sec;            // fuori sessione: in pausa
   if(fine < 86400) return fine;         // pausa dentro la giornata
   int dd = (dow + 1) % 7;
   for(int i = 0; i < g_sesN[dd]; i++)
      if(g_sesDa[dd][i] == 0)
      {
         if(g_sesA[dd][i] >= 86400) return -1;   // due giorni pieni di fila: nessuna pausa in vista
         return 86400 + g_sesA[dd][i];
      }
   return 86400;                         // dopo mezzanotte non si riparte subito: pausa vera
}

int C12StatoPausaOra()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int sec  = dt.hour * 3600 + dt.min * 60 + dt.sec;
   int fine = C12TettoVenerdi(dt.day_of_week, C12FineSessioneCorrente(dt.day_of_week, sec), InpVenerdiFineMax);
   return C12StatoPausa(sec, fine, InpPausaStopNuoviMin, InpPausaChiudiMin);
}

bool C12MargineOk(const bool isLong, const double lots, const double price)
{
   double margine = 0.0;
   if(!OrderCalcMargin(isLong ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, g_sym, lots, price, margine))
   {
      Print("[C12OC] ERRORE OrderCalcMargin: ", GetLastError(), " -- ordine saltato");
      return false;
   }
   double libero = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(margine > libero)
   {
      PrintFormat("[C12OC] MARGINE INSUFFICIENTE: servono %.2f, liberi %.2f -- ordine saltato", margine, libero);
      return false;
   }
   return true;
}

//--- posizioni vive del lato (magic + simbolo + tipo), in array.
int C12Raccogli(const int lato, ulong &tk[], ulong &ids[], double &px[], double &vol[],
                double &sl[], double &tp[], datetime &tm[])
{
   int n = 0;
   ArrayResize(tk, 0); ArrayResize(ids, 0); ArrayResize(px, 0); ArrayResize(vol, 0);
   ArrayResize(sl, 0); ArrayResize(tp, 0); ArrayResize(tm, 0);
   long tipo = (lato > 0) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetInteger(POSITION_TYPE) != tipo) continue;
      ArrayResize(tk, n + 1); ArrayResize(ids, n + 1); ArrayResize(px, n + 1); ArrayResize(vol, n + 1);
      ArrayResize(sl, n + 1); ArrayResize(tp, n + 1); ArrayResize(tm, n + 1);
      tk[n]  = t;
      ids[n] = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
      px[n]  = PositionGetDouble(POSITION_PRICE_OPEN);
      vol[n] = PositionGetDouble(POSITION_VOLUME);
      sl[n]  = PositionGetDouble(POSITION_SL);
      tp[n]  = PositionGetDouble(POSITION_TP);
      tm[n]  = (datetime)PositionGetInteger(POSITION_TIME);
      n++;
   }
   return n;
}

double C12FlottanteLato(const int lato)
{
   double f = 0.0;
   long tipo = (lato > 0) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetInteger(POSITION_TYPE) != tipo) continue;
      f += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return f;
}

void C12RegistraId(const int lato, const ulong id)
{
   if(lato > 0)
   {
      for(int i = 0; i < ArraySize(g_idsL); i++) if(g_idsL[i] == id) return;
      int n = ArraySize(g_idsL); ArrayResize(g_idsL, n + 1); g_idsL[n] = id;
   }
   else
   {
      for(int i = 0; i < ArraySize(g_idsS); i++) if(g_idsS[i] == id) return;
      int n = ArraySize(g_idsS); ArrayResize(g_idsS, n + 1); g_idsS[n] = id;
   }
}

bool C12IdDelCesto(const int lato, const ulong id)
{
   if(lato > 0) { for(int i = 0; i < ArraySize(g_idsL); i++) if(g_idsL[i] == id) return true; }
   else         { for(int i = 0; i < ArraySize(g_idsS); i++) if(g_idsS[i] == id) return true; }
   return false;
}

int C12NumIds(const int lato) { return (lato > 0) ? ArraySize(g_idsL) : ArraySize(g_idsS); }

//==================================================================
// ORDINI
//==================================================================
//--- R2/R3 + R10 + R11: un ordine a mercato con SL di cesto e TP.
bool C12Apri(const int lato, const double lots, const double sl, const double tp, const int livello)
{
   int    digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   double ask    = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid    = SymbolInfoDouble(g_sym, SYMBOL_BID);
   double price  = (lato > 0) ? ask : bid;
   if(InpCheckFreeMargin && !C12MargineOk(lato > 0, lots, price)) return false;
   string cmt = InpComment + ((lato > 0) ? "_L" : "_S") + IntegerToString(livello);
   double slN = NormalizeDouble(sl, digits);
   double tpN = NormalizeDouble(tp, digits);
   trade.SetTypeFilling(GetFillingMode(g_sym));
   bool inviato = false;
   if(lato > 0)
   {
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, g_nome)) return false;
      inviato = trade.Buy(lots, g_sym, ask, slN, tpN, cmt);
   }
   else
   {
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, g_nome)) return false;
      inviato = trade.Sell(lots, g_sym, bid, slN, tpN, cmt);
   }
   uint rc = trade.ResultRetcode();
   if(!inviato || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_DONE_PARTIAL && rc != TRADE_RETCODE_PLACED))
   {
      PrintFormat("[C12OC] ERRORE ordine %s livello %d: retcode %u (%s)", (lato > 0 ? "BUY" : "SELL"), livello, rc,
                  trade.ResultRetcodeDescription());
      return false;
   }
   Log(StringFormat("livello %d %s %.2f lotti @ %s | SL cesto %s | TP %s", livello, (lato > 0 ? "BUY" : "SELL"), lots,
                    DoubleToString(trade.ResultPrice(), digits), DoubleToString(slN, digits), DoubleToString(tpN, digits)));
   return true;
}

//--- chiude TUTTE le posizioni del lato (weekend, target superato).
//    Le chiusure non passano dal Guardian (firma C1: mai bloccare una
//    chiusura). Quelle fallite si ritentano al tick dopo.
void C12ChiudiLato(const int lato, const string motivo)
{
   int ix = C12Idx(lato);
   g_inChiusura[ix] = true;
   if(g_motivoChiusura[ix] == "") g_motivoChiusura[ix] = motivo;
   ulong tk[], ids[]; double px[], vol[], sl[], tp[]; datetime tm[];
   int n = C12Raccogli(lato, tk, ids, px, vol, sl, tp, tm);
   for(int i = 0; i < n; i++)
   {
      if(!trade.PositionClose(tk[i], (ulong)InpSlippagePoints) && TimeCurrent() - g_ultimoErr[ix] >= 60)
      {
         PrintFormat("[C12OC] ERRORE chiusura (%s) ticket %I64u: retcode %u (%s)", motivo, tk[i],
                     trade.ResultRetcode(), trade.ResultRetcodeDescription());
         g_ultimoErr[ix] = TimeCurrent();
      }
   }
}

//==================================================================
// IL CESTO CHIUSO: netto dallo storico, riga CESTO, contatori
//==================================================================
void C12ChiudiContabilita(const int lato)
{
   int ix = C12Idx(lato);
   double netto = 0.0, lotti = 0.0;
   int nSL = 0, nTP = 0, nEA = 0, nAltro = 0;
   datetime da = (g_t0[ix] > 0) ? g_t0[ix] - 3600 : TimeCurrent() - 30 * 86400;
   bool okStorico = HistorySelect(da, TimeCurrent() + 60);
   if(okStorico)
   {
      int nd = HistoryDealsTotal();
      for(int i = 0; i < nd; i++)
      {
         ulong dk = HistoryDealGetTicket(i);
         if(dk == 0) continue;
         if(HistoryDealGetInteger(dk, DEAL_MAGIC) != InpMagic) continue;
         if(HistoryDealGetString(dk, DEAL_SYMBOL) != g_sym) continue;
         if(!C12IdDelCesto(lato, (ulong)HistoryDealGetInteger(dk, DEAL_POSITION_ID))) continue;
         netto += HistoryDealGetDouble(dk, DEAL_PROFIT) + HistoryDealGetDouble(dk, DEAL_SWAP) +
                  HistoryDealGetDouble(dk, DEAL_COMMISSION) + HistoryDealGetDouble(dk, DEAL_FEE);
         long entry = HistoryDealGetInteger(dk, DEAL_ENTRY);
         if(entry == DEAL_ENTRY_IN) lotti += HistoryDealGetDouble(dk, DEAL_VOLUME);
         if(entry == DEAL_ENTRY_OUT || entry == DEAL_ENTRY_OUT_BY)
         {
            long r = HistoryDealGetInteger(dk, DEAL_REASON);
            if(r == DEAL_REASON_SL)          nSL++;
            else if(r == DEAL_REASON_TP)     nTP++;
            else if(r == DEAL_REASON_EXPERT) nEA++;
            else                             nAltro++;
         }
      }
   }
   else
      Print("[C12OC] ERRORE HistorySelect per il netto del cesto: ", GetLastError());

   int prof = C12NumIds(lato);
   string motivo = "ALTRO";
   if(g_motivoChiusura[ix] != "")           motivo = g_motivoChiusura[ix];
   else if(nSL > 0 && nTP == 0 && nEA == 0) motivo = "SL";
   else if(nTP > 0 && nSL == 0 && nEA == 0) motivo = "TP";
   if(motivo == "TP") g_motTP++;
   else if(motivo == "SL") g_motSL++;
   else if(motivo == "PAUSA") g_motPAUSA++;
   else if(motivo == "SUP") g_motSUP++;
   else g_motALTRO++;

   double durata = (g_t0[ix] > 0) ? (double)(TimeCurrent() - g_t0[ix]) / 60.0 : -1.0;
   //--- la CODA: un netto peggiore del rischio pianificato (+5% di
   //    tolleranza) e' un gap o uno slippage che lo SL non ha fermato.
   //    Con rischio non noto (cesto ricostruito) -> "?".
   string oltre = "?";
   if(g_rischio[ix] > 0.0)
   {
      oltre = (netto < -1.05 * g_rischio[ix]) ? "SI" : "NO";
      if(oltre == "SI") { g_oltreRischio++; g_oltreRischioSomma += netto; }
   }
   PrintFormat("[C12OC-CESTO] lato=%s prof=%d lotti=%.2f netto=%.2f mae=%.2f durata_min=%.1f motivo=%s uscite_sl=%d uscite_tp=%d uscite_ea=%d uscite_altro=%d avvio=%d rischio_pian=%.2f oltre_rischio=%s spread_avvio=%.2f t0=%s ricostruito=%s storico=%s",
               (lato > 0 ? "L" : "S"), prof, lotti, netto, g_mae[ix], durata, motivo, nSL, nTP, nEA, nAltro,
               g_avvio[ix], g_rischio[ix], oltre, g_spread0[ix], (g_t0[ix] > 0 ? TimeToString(g_t0[ix], TIME_DATE | TIME_SECONDS) : "?"),
               (g_ricostruito[ix] ? "SI" : "NO"), (okStorico ? "OK" : "KO"));

   int d = prof;
   if(d < 0) d = 0;
   if(d > C12_MAX_LIVELLI) d = C12_MAX_LIVELLI;
   g_statN[d]++;
   g_statNet[d] += netto;
   if(netto < 0.0) g_statNeg[d]++;
   if(g_statN[d] == 1 || netto < g_statPeggiore[d]) g_statPeggiore[d] = netto;
   if(netto > 0.0) g_profLordi += netto; else g_perdLorde += -netto;
   if(g_mae[ix] < g_maePeggiore) g_maePeggiore = g_mae[ix];

   //--- azzera la memoria del lato
   g_vivo[ix] = false; g_ricostruito[ix] = false; g_t0[ix] = 0; g_sl[ix] = 0.0; g_mae[ix] = 0.0;
   g_rischio[ix] = 0.0; g_spread0[ix] = 0.0; g_avvio[ix] = -1; g_inChiusura[ix] = false;
   g_motivoChiusura[ix] = "";
   if(lato > 0) ArrayResize(g_idsL, 0); else ArrayResize(g_idsS, 0);
}

//==================================================================
// R3 + R5 + R8: GESTIONE DI UN LATO (a ogni tick)
//==================================================================
void C12GestisciLato(const int lato, const int statoPausa)
{
   int ix = C12Idx(lato);
   ulong tk[], ids[]; double px[], vol[], sl[], tp[]; datetime tm[];
   int n = C12Raccogli(lato, tk, ids, px, vol, sl, tp, tm);

   if(n == 0)
   {
      if(g_vivo[ix]) C12ChiudiContabilita(lato);
      return;
   }

   int    digits   = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   double point    = SymbolInfoDouble(g_sym, SYMBOL_POINT);
   double tickSize = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   double eps      = (tickSize > 0.0) ? tickSize * 0.5 : point * 0.5;
   double minDist  = (double)MathMax(SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL),
                                     SymbolInfoInteger(g_sym, SYMBOL_TRADE_FREEZE_LEVEL)) * point;
   double ask = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid = SymbolInfoDouble(g_sym, SYMBOL_BID);
   if(ask <= 0.0 || bid <= 0.0) return;

   //--- P1 = la posizione piu' vecchia (a parita' di ora, ticket minore)
   int i1 = 0;
   for(int i = 1; i < n; i++)
      if(tm[i] < tm[i1] || (tm[i] == tm[i1] && tk[i] < tk[i1])) i1 = i;
   double p1 = px[i1];

   //--- memoria: dopo un riavvio si ricostruisce dalle posizioni
   if(!g_vivo[ix])
   {
      g_vivo[ix] = true;
      g_ricostruito[ix] = true;
      g_t0[ix] = tm[i1];
      g_mae[ix] = 0.0;
      g_avvio[ix] = -1;
      g_sl[ix] = (sl[i1] > 0.0) ? sl[i1] : C12SLCesto(lato, p1, InpLivelliMax, InpPassoUSD, InpSLOltreUltimoUSD);
      PrintFormat("[C12OC] cesto %s RICOSTRUITO dalle posizioni (%d vive, P1 %s, SL %s): MAE e rischio pianificato NON noti",
                  (lato > 0 ? "LUNGO" : "CORTO"), n, DoubleToString(p1, digits), DoubleToString(g_sl[ix], digits));
   }
   for(int i = 0; i < n; i++) C12RegistraId(lato, ids[i]);

   //--- MAE del cesto (flottante peggiore, valuta del conto)
   double fl = C12FlottanteLato(lato);
   if(fl < g_mae[ix]) g_mae[ix] = fl;

   //--- R8: chiusura prima di una pausa, o chiusura gia' in corso
   if(statoPausa == C12_PAUSA_CHIUDI) { C12ChiudiLato(lato, "PAUSA"); return; }
   if(g_inChiusura[ix])           { C12ChiudiLato(lato, g_motivoChiusura[ix]); return; }

   //--- R5: media, target, sincronizzazione di SL e TP
   double sPV = 0.0, sV = 0.0;
   int maxK = 1;
   for(int i = 0; i < n; i++)
   {
      sPV += px[i] * vol[i];
      sV  += vol[i];
      int k = C12LivelloDaPrezzo(lato, p1, px[i], InpPassoUSD);
      if(k > maxK) maxK = k;
   }
   if(sV <= 0.0) return;
   double target = NormalizeDouble(C12Target(lato, sPV / sV, InpTargetUSD), digits);
   double prezzoChiusura = (lato > 0) ? bid : ask;
   if(C12TargetSuperato(lato, prezzoChiusura, target))
   {
      Log(StringFormat("target %s gia' superato (prezzo di chiusura %s): chiudo il cesto a mercato",
                       DoubleToString(target, digits), DoubleToString(prezzoChiusura, digits)));
      C12ChiudiLato(lato, "SUP");
      return;
   }
   double slC = NormalizeDouble(g_sl[ix], digits);
   bool tpValido = (lato > 0) ? (target - bid >= minDist) : (ask - target >= minDist);
   bool slValido = (lato > 0) ? (bid - slC >= minDist) : (slC - ask >= minDist);
   for(int i = 0; i < n; i++)
   {
      bool cambiaTP = (MathAbs(tp[i] - target) > eps) && tpValido;
      bool cambiaSL = (sl[i] <= 0.0 || MathAbs(sl[i] - slC) > eps) && slValido;
      if(!cambiaTP && !cambiaSL) continue;
      double nTP = cambiaTP ? target : tp[i];
      double nSL = cambiaSL ? slC : sl[i];
      if(!trade.PositionModify(tk[i], nSL, nTP) && TimeCurrent() - g_ultimoErr[ix] >= 60)
      {
         PrintFormat("[C12OC] ERRORE sincronizzazione ticket %I64u (SL %s TP %s): retcode %u (%s)", tk[i],
                     DoubleToString(nSL, digits), DoubleToString(nTP, digits),
                     trade.ResultRetcode(), trade.ResultRetcodeDescription());
         g_ultimoErr[ix] = TimeCurrent();
      }
   }

   //--- R3: un livello nuovo?
   double prezzoIngresso = (lato > 0) ? ask : bid;
   int k = C12LivelloDaRiempire(lato, p1, prezzoIngresso, InpPassoUSD, maxK, n, InpLivelliMax, eps);
   if(k == 0)
   {
      //--- conteggio dei livelli saltati per gap: il prezzo e' oltre la
      //    finestra del livello successivo e non dentro nessun'altra
      int kNext = maxK + 1;
      if(n < InpLivelliMax && kNext <= InpLivelliMax)
      {
         double lk = C12LivelloPrezzo(lato, p1, kNext, InpPassoUSD);
         bool oltre = (lato > 0) ? (prezzoIngresso < lk - 0.5 * InpPassoUSD - eps)
                                 : (prezzoIngresso > lk + 0.5 * InpPassoUSD + eps);
         if(oltre && iTime(g_sym, g_tf, 0) != g_ultimoSalto[ix])
         {
            g_ultimoSalto[ix] = iTime(g_sym, g_tf, 0);
            g_livelliSaltati++;
         }
      }
      return;
   }
   double spread = ask - bid;
   if(!C12SpreadOk(spread, InpSpreadMaxUSD)) return;
   //--- lo SL di cesto deve restare valido per il nuovo ingresso
   if(!slValido) return;
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   double vmin = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   double lotto = NormalizeDouble(C12LottoLivello(k, InpLottoBase, InpScalaIncremento, InpScalaTettoMult, step, vmin, vmax), 2);
   if(lotto <= 0.0) return;
   //--- un livello rifiutato (margine, Guardian, broker) si ritenta
   //    alla barra dopo, non a ogni tick: niente raffiche di ordini
   //    ne' di righe d'errore
   datetime barra = iTime(g_sym, g_tf, 0);
   if(barra == g_tentativoKO[ix]) return;
   double tpNuovo = C12TargetDopo(lato, sPV, sV, prezzoIngresso, lotto, InpTargetUSD);
   if(!C12Apri(lato, lotto, slC, tpNuovo, k)) g_tentativoKO[ix] = barra;
}

//==================================================================
// R1 + R2 + R6..R9: LA BARRA NUOVA -- forse un cesto nuovo
//==================================================================
bool C12LeggiSegnale(int &segnale)
{
   segnale = 0;
   datetime t1 = iTime(g_sym, g_tf, 1);
   if(t1 <= 0) return false;
   double c[];
   ArraySetAsSeries(c, true);
   if(CopyClose(g_sym, g_tf, 1, 1, c) != 1) return false;
   double close1 = c[0];

   if(InpModoAvvio == 0)
   {
      int lato = 0;
      if(C12Nullo(InpSemeNullo, (long)t1, InpProbNullo, lato)) segnale = lato;
      return true;
   }
   if(InpModoAvvio == 1)
   {
      int nb = InpRotturaBarre;
      double h[], l[];
      ArraySetAsSeries(h, true);
      ArraySetAsSeries(l, true);
      if(CopyHigh(g_sym, g_tf, 2, nb, h) != nb) return false;
      if(CopyLow(g_sym, g_tf, 2, nb, l) != nb) return false;
      double hh = h[0], ll = l[0];
      for(int i = 1; i < nb; i++) { if(h[i] > hh) hh = h[i]; if(l[i] < ll) ll = l[i]; }
      segnale = C12SegnaleRottura(close1, hh, ll);
   }
   else
   {
      double e[], a[];
      if(CopyBuffer(g_hEma, 0, 1, 1, e) != 1) return false;
      if(CopyBuffer(g_hAtr, 0, 1, 1, a) != 1) return false;
      if(e[0] == EMPTY_VALUE || a[0] == EMPTY_VALUE) return false;
      segnale = C12SegnaleRitorno(close1, e[0], a[0], InpRitornoK);
   }
   //--- secondo controllo: stessi istanti, lato a moneta
   if(segnale != 0 && InpDirezioneCasuale)
   {
      int lato = 0;
      C12Nullo(InpSemeNullo, (long)t1, 1.0, lato);
      segnale = lato;
   }
   return true;
}

void C12NuovaBarra(const int statoPausa)
{
   int segnale = 0;
   if(!C12LeggiSegnale(segnale))
   {
      g_conta[C12_DATI]++;
      Log("dati non pronti sulla barra " + TimeToString(iTime(g_sym, g_tf, 0)) + " -- segnale non valutato");
      return;
   }
   if(segnale == 0) return;

   double ask = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid = SymbolInfoDouble(g_sym, SYMBOL_BID);
   if(ask <= 0.0 || bid <= 0.0) { g_conta[C12_DATI]++; return; }
   double spread = ask - bid;
   double rischio = C12RischioValuta();
   int motivo = C12_NO_SEGNALE;
   int lato = C12DecidiAvvio(segnale, InpAllowLong, InpAllowShort, g_vivo[0], g_vivo[1], InpDueLatiInsieme,
                             statoPausa, spread, InpSpreadMaxUSD, rischio, InpRischioMaxCesto, motivo);
   if(motivo >= 0 && motivo < C12_N_MOTIVI) g_conta[motivo]++;
   if(lato == 0)
   {
      if(motivo == C12_RISCHIO)
         PrintFormat("[C12OC] avvio %s SALTATO: rischio pianificato %.2f oltre il tetto %.2f", (segnale > 0 ? "LUNGO" : "CORTO"),
                     rischio, InpRischioMaxCesto);
      return;
   }

   int    digits   = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   double point    = SymbolInfoDouble(g_sym, SYMBOL_POINT);
   double tickSize = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   double minDist  = (double)SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL) * point;
   double p1  = (lato > 0) ? ask : bid;
   double slC = C12SLCesto(lato, p1, InpLivelliMax, InpPassoUSD, InpSLOltreUltimoUSD);
   if(tickSize > 0.0) slC = MathRound(slC / tickSize) * tickSize;
   slC = NormalizeDouble(slC, digits);
   double tp1 = NormalizeDouble(C12Target(lato, p1, InpTargetUSD), digits);
   bool slOk = (lato > 0) ? (bid - slC >= minDist) : (slC - ask >= minDist);
   bool tpOk = (lato > 0) ? (tp1 - bid >= minDist) : (ask - tp1 >= minDist);
   if(!slOk || !tpOk)
   {
      g_conta[C12_ORDINE_KO]++;
      PrintFormat("[C12OC] avvio SALTATO: SL %s o TP %s troppo vicini (stops level %s)", DoubleToString(slC, digits),
                  DoubleToString(tp1, digits), DoubleToString(minDist, digits));
      return;
   }
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   double vmin = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   double lotto = NormalizeDouble(C12LottoLivello(1, InpLottoBase, InpScalaIncremento, InpScalaTettoMult, step, vmin, vmax), 2);
   if(lotto <= 0.0)
   {
      g_conta[C12_ORDINE_KO]++;
      Print("[C12OC] lotto base nullo dopo i vincoli del simbolo -- avvio saltato");
      return;
   }
   if(!C12Apri(lato, lotto, slC, tp1, 1)) { g_conta[C12_ORDINE_KO]++; return; }

   int ix = C12Idx(lato);
   g_vivo[ix] = true; g_ricostruito[ix] = false; g_t0[ix] = TimeCurrent(); g_sl[ix] = slC; g_mae[ix] = 0.0;
   g_rischio[ix] = rischio; g_spread0[ix] = spread; g_avvio[ix] = InpModoAvvio; g_inChiusura[ix] = false;
   g_motivoChiusura[ix] = "";
   if(lato > 0) ArrayResize(g_idsL, 0); else ArrayResize(g_idsS, 0);
   double distSL = MathAbs(p1 - slC);
   PrintFormat("[C12OC-AVVIO] lato=%s avvio=%d direzione_casuale=%s p1=%s sl=%s dist_sl=%.2f ultimo_livello_sl=%.2f target=%.2f livelli=%d passo=%.2f lotto1=%.2f rischio_pian=%.2f spread=%.2f sl_su_spread=%.1f target_su_spread=%.1f",
               (lato > 0 ? "L" : "S"), InpModoAvvio, (InpDirezioneCasuale ? "SI" : "NO"), DoubleToString(p1, digits),
               DoubleToString(slC, digits), distSL, InpSLOltreUltimoUSD, InpTargetUSD, InpLivelliMax, InpPassoUSD, lotto,
               rischio, spread, (spread > 0.0 ? distSL / spread : -1.0), (spread > 0.0 ? InpTargetUSD / spread : -1.0));
}

//==================================================================
// INIT / DEINIT / TICK
//==================================================================
int OnInit()
{
   g_sym  = (StringLen(InpSymbol) > 0) ? InpSymbol : _Symbol;
   g_nome = MQLInfoString(MQL_PROGRAM_NAME);
   if(!SymbolSelect(g_sym, true))
   {
      Print("[C12OC] ERRORE simbolo non disponibile: ", g_sym);
      return(INIT_FAILED);
   }
   g_tf = (InpTFAvvio == PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)_Period : InpTFAvvio;

   //--- validazione: un input assurdo ferma l'EA invece di girare storto
   string err = "";
   if(InpModoAvvio < 0 || InpModoAvvio > 2)                     err += " InpModoAvvio";
   if(InpModoAvvio == 0 && (InpProbNullo <= 0.0 || InpProbNullo > 1.0)) err += " InpProbNullo(modo 0: 0<p<=1)";
   if(InpSemeNullo < 0)                                         err += " InpSemeNullo";
   if(InpRotturaBarre < 1 || InpRotturaBarre > 5000)            err += " InpRotturaBarre";
   if(InpRitornoEma < 1)                                        err += " InpRitornoEma";
   if(InpRitornoAtr < 1)                                        err += " InpRitornoAtr";
   if(InpRitornoK <= 0.0)                                       err += " InpRitornoK";
   if(!InpAllowLong && !InpAllowShort)                          err += " InpAllowLong/InpAllowShort(entrambi spenti)";
   if(InpLivelliMax < 1 || InpLivelliMax > C12_MAX_LIVELLI)     err += " InpLivelliMax(1..10)";
   if(InpPassoUSD <= 0.0)                                       err += " InpPassoUSD";
   if(InpSLOltreUltimoUSD <= 0.0)                               err += " InpSLOltreUltimoUSD";
   if(InpTargetUSD <= 0.0)                                      err += " InpTargetUSD";
   if(InpLottoBase <= 0.0)                                      err += " InpLottoBase";
   if(InpScalaIncremento < 0.0 || InpScalaIncremento > 1.0)     err += " InpScalaIncremento(0..1)";
   if(InpScalaTettoMult < 1.0 || InpScalaTettoMult > 5.0)       err += " InpScalaTettoMult(1..5)";
   if(InpRischioMaxCesto < 0.0)                                 err += " InpRischioMaxCesto";
   if(InpCommStimaLotto < 0.0)                                  err += " InpCommStimaLotto";
   if(InpSpreadMaxUSD < 0.0)                                    err += " InpSpreadMaxUSD";
   if(InpPausaChiudiMin < 0 || InpPausaChiudiMin > 720)         err += " InpPausaChiudiMin(0..720)";
   if(InpPausaStopNuoviMin < InpPausaChiudiMin || InpPausaStopNuoviMin > 720) err += " InpPausaStopNuoviMin(>= chiudi, <= 720)";
   if(InpVenerdiFineMax < 1 || InpVenerdiFineMax > 24)          err += " InpVenerdiFineMax(1..24)";
   if(InpSlippagePoints < 0)                                    err += " InpSlippagePoints";
   if(StringLen(InpComment) + 4 > 21)                           err += " InpComment(>17 caratteri)";
   if(err != "")
   {
      Print("[C12OC] ERRORE input non validi:", err);
      return(INIT_PARAMETERS_INCORRECT);
   }
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {
      Print("[C12OC] ERRORE conto NON hedging: il cesto vive di posizioni separate con SL/TP propri -- EA fermato");
      return(INIT_FAILED);
   }

   if(InpModoAvvio == 2)
   {
      g_hEma = iMA(g_sym, g_tf, InpRitornoEma, 0, MODE_EMA, PRICE_CLOSE);
      g_hAtr = iATR(g_sym, g_tf, InpRitornoAtr);
      if(g_hEma == INVALID_HANDLE || g_hAtr == INVALID_HANDLE)
      {
         Print("[C12OC] ERRORE creazione handle EMA/ATR: ", GetLastError());
         return(INIT_FAILED);
      }
   }

   //--- R8: sessioni di trading dalle specifiche del simbolo
   g_sesLette = C12LeggiSessioni();

   ArrayInitialize(g_conta, 0);
   ArrayInitialize(g_statN, 0);
   ArrayInitialize(g_statNet, 0.0);
   ArrayInitialize(g_statNeg, 0);
   ArrayInitialize(g_statPeggiore, 0.0);
   for(int i = 0; i < 2; i++)
   {
      g_vivo[i] = false; g_ricostruito[i] = false; g_t0[i] = 0; g_sl[i] = 0.0; g_mae[i] = 0.0; g_rischio[i] = 0.0;
      g_spread0[i] = 0.0; g_avvio[i] = -1; g_inChiusura[i] = false; g_motivoChiusura[i] = ""; g_ultimoErr[i] = 0;
      g_ultimoSalto[i] = 0; g_tentativoKO[i] = 0;
   }
   ArrayResize(g_idsL, 0);
   ArrayResize(g_idsS, 0);

   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints((ulong)InpSlippagePoints);
   trade.SetTypeFilling(GetFillingMode(g_sym));

   //--- il primo segnale si valuta alla PROSSIMA barra nuova
   g_lastBar = iTime(g_sym, g_tf, 0);

   C12LogAvvio();
   if(InpAutoTest) AutoTestC12();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   C12StampaConta("FINE");
   if(g_hEma != INVALID_HANDLE) IndicatorRelease(g_hEma);
   if(g_hAtr != INVALID_HANDLE) IndicatorRelease(g_hAtr);
   g_hEma = INVALID_HANDLE;
   g_hAtr = INVALID_HANDLE;
   Print("[C12OC] Deinit reason=", reason);
}

void OnTick()
{
   //--- difetto da misurare: un cesto vivo attraverso un buco di tick
   //    piu' lungo di 45 minuti (weekend, pausa giornaliera, mercato
   //    fermo). Lo SL sul server non protegge da un gap: la difesa e'
   //    R8, e questa riga dice se ha funzionato.
   datetime ora = TimeCurrent();
   if(g_ultimoTick > 0 && ora - g_ultimoTick > 45 * 60 && (g_vivo[0] || g_vivo[1]))
   {
      g_pauseAttraversate++;
      PrintFormat("[C12OC-PAUSA-ATTRAVERSATA] cesto vivo attraverso %d minuti senza tick: ultimo tick %s, tick %s, lungo=%s corto=%s (sessioni %s)",
                  (int)((ora - g_ultimoTick) / 60), TimeToString(g_ultimoTick, TIME_DATE | TIME_SECONDS),
                  TimeToString(ora, TIME_DATE | TIME_SECONDS), (g_vivo[0] ? "SI" : "NO"), (g_vivo[1] ? "SI" : "NO"),
                  (g_sesLette ? "lette" : "NON lette"));
   }
   g_ultimoTick = ora;

   //--- prima la gestione (chiusure, SL/TP, livelli), poi l'avvio
   int statoPausa = C12StatoPausaOra();
   C12GestisciLato(C12_LATO_L, statoPausa);
   C12GestisciLato(C12_LATO_S, statoPausa);

   datetime t0 = iTime(g_sym, g_tf, 0);
   if(t0 <= 0) return;
   if(g_lastBar == 0) { g_lastBar = t0; return; }
   if(t0 == g_lastBar) return;
   g_lastBar = t0;
   C12NuovaBarra(statoPausa);
}

//==================================================================
// LOG DI AVVIO E CONTATORI
//==================================================================
void C12LogAvvio()
{
   int digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   PrintFormat("[C12OC] AVVIO v1.00 %s | InpSymbol=\"%s\" -> %s | InpTFAvvio=%s -> %s | digits %d",
               g_nome, InpSymbol, g_sym, EnumToString(InpTFAvvio), EnumToString(g_tf), digits);
   PrintFormat("[C12OC] AVVIO DEL CESTO | InpModoAvvio=%d (%s) | InpDirezioneCasuale=%s | InpSemeNullo=%d | InpProbNullo=%.6f | InpRotturaBarre=%d | InpRitornoEma=%d | InpRitornoAtr=%d | InpRitornoK=%.2f",
               InpModoAvvio, (InpModoAvvio == 0 ? "CONTROLLO NULLO" : (InpModoAvvio == 1 ? "ROTTURA" : "RITORNO")),
               (InpDirezioneCasuale ? "true" : "false"), InpSemeNullo, InpProbNullo, InpRotturaBarre, InpRitornoEma,
               InpRitornoAtr, InpRitornoK);
   PrintFormat("[C12OC] LATI | InpAllowLong=%s | InpAllowShort=%s | InpDueLatiInsieme=%s",
               (InpAllowLong ? "true" : "false"), (InpAllowShort ? "true" : "false"), (InpDueLatiInsieme ? "true" : "false"));
   PrintFormat("[C12OC] CESTO | InpLivelliMax=%d | InpPassoUSD=%.2f | InpSLOltreUltimoUSD=%.2f | SL dal livello 1 = %.2f | InpTargetUSD=%.2f",
               InpLivelliMax, InpPassoUSD, InpSLOltreUltimoUSD, (InpLivelliMax - 1) * InpPassoUSD + InpSLOltreUltimoUSD, InpTargetUSD);
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   double vmin = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   string scala = "";
   for(int k = 1; k <= InpLivelliMax; k++)
      scala += (k > 1 ? " / " : "") + DoubleToString(C12LottoLivello(k, InpLottoBase, InpScalaIncremento, InpScalaTettoMult, step, vmin, vmax), 2);
   PrintFormat("[C12OC] LOTTI | InpLottoBase=%.2f | InpScalaIncremento=%.2f | InpScalaTettoMult=%.2f | scala per livello: %s",
               InpLottoBase, InpScalaIncremento, InpScalaTettoMult, scala);
   PrintFormat("[C12OC] RISCHIO | rischio pianificato per cesto (tutti i livelli, tutti allo SL) = %.2f %s (valore di 1,0 di prezzo su 1 lotto = %.2f; commissione stimata %.2f/lotto) | InpRischioMaxCesto=%.2f%s",
               C12RischioValuta(), AccountInfoString(ACCOUNT_CURRENCY), C12ValorePrezzoLotto(), InpCommStimaLotto,
               InpRischioMaxCesto, (InpRischioMaxCesto > 0.0 ? "" : " (SPENTO: DA DECIDERE CON CLAUDIO)"));
   PrintFormat("[C12OC] RISCHIO | cesti vivi insieme al massimo %d -> rischio simultaneo pianificato %.2f %s. "
               "NON comprende i GAP: lo SL sul server non ferma un salto di prezzo (vedi oltre_rischio nelle righe CESTO)",
               (InpDueLatiInsieme ? 2 : 1), (InpDueLatiInsieme ? 2.0 : 1.0) * C12RischioValuta(), AccountInfoString(ACCOUNT_CURRENCY));
   PrintFormat("[C12OC] PROTEZIONI | InpSpreadMaxUSD=%.2f%s | InpPausaStopNuoviMin=%d | InpPausaChiudiMin=%d | InpVenerdiFineMax=%d (tetto di sicurezza) | sessioni %s | InpSlippagePoints=%d | InpCheckFreeMargin=%s",
               InpSpreadMaxUSD, (InpSpreadMaxUSD > 0.0 ? "" : " (filtro SPENTO)"), InpPausaStopNuoviMin, InpPausaChiudiMin,
               InpVenerdiFineMax, (g_sesLette ? "LETTE dalle specifiche del simbolo" : "NON LETTE: resta solo il tetto del venerdi'"),
               InpSlippagePoints, (InpCheckFreeMargin ? "true" : "false"));
   string nomi[7] = {"dom", "lun", "mar", "mer", "gio", "ven", "sab"};
   for(int d = 0; d < 7; d++)
   {
      string riga = "";
      for(int i = 0; i < g_sesN[d]; i++)
         riga += StringFormat("%s%02d:%02d-%02d:%02d", (i > 0 ? " " : ""), g_sesDa[d][i] / 3600, (g_sesDa[d][i] % 3600) / 60,
                              g_sesA[d][i] / 3600, (g_sesA[d][i] % 3600) / 60);
      PrintFormat("[C12OC] SESSIONI %s | %s", nomi[d], (riga == "" ? "nessuna" : riga));
   }
   PrintFormat("[C12OC] IDENTITA' | InpMagic=%s | InpComment=\"%s\" (ordini \"%s_L1\"..\"%s_S%d\") | InpUsaGuardian=%s | InpVerbose=%s | InpAutoTest=%s",
               IntegerToString(InpMagic), InpComment, InpComment, InpComment, InpLivelliMax,
               (InpUsaGuardian ? "true" : "false"), (InpVerbose ? "true" : "false"), (InpAutoTest ? "true" : "false"));
   Print("[C12OC] OROLOGIO | ore SERVER. BCM = UTC+1 fisso: d'estate ora italiana - 1, d'inverno = ora italiana. ",
         "Le chiusure prima delle pause si agganciano alle SESSIONI del simbolo; il tetto del venerdi' e' solo una rete.");
   if(InpModoAvvio == 0)
      Print("[C12OC] ATTENZIONE: modo 0 = CONTROLLO NULLO (ingressi pseudo-casuali). Serve SOLO nel tester come termine di paragone.");
   if(InpScalaIncremento > 0.0)
      PrintFormat("[C12OC] ATTENZIONE: scala dei lotti CRESCENTE (incremento %.2f, tetto %.1fx): il rischio cresce coi livelli", InpScalaIncremento, InpScalaTettoMult);
   if(InpSpreadMaxUSD > 0.0 && InpSLOltreUltimoUSD < 40.0 * InpSpreadMaxUSD)
      PrintFormat("[C12OC] NOTA: lo stop dell'ultimo livello (%.2f) e' sotto 40 x lo spread massimo ammesso (%.2f): la frontiera si legge sugli ingressi veri",
                  InpSLOltreUltimoUSD, 40.0 * InpSpreadMaxUSD);
   if(!MQLInfoInteger(MQL_TESTER))
      Print("[C12OC] ATTENZIONE: EA NATO PER IL TESTER. Metterlo su un conto e' una FIRMA DI CLAUDIO (taglie e rischio compresi).");
}

string C12MotivoTesto(const int m)
{
   if(m == C12_OK)          return "ok";
   if(m == C12_NO_SEGNALE)  return "nessun segnale";
   if(m == C12_CESTO_VIVO)  return "cesto gia' vivo sul lato";
   if(m == C12_ALTRO_LATO)  return "cesto vivo sull'altro lato";
   if(m == C12_PAUSA)       return "vicino a una pausa di sessione";
   if(m == C12_SPREAD)      return "spread oltre il limite";
   if(m == C12_RISCHIO)     return "rischio oltre il tetto";
   if(m == C12_LATO_SPENTO) return "lato spento";
   if(m == C12_DATI)        return "dati non pronti";
   if(m == C12_ORDINE_KO)   return "ordine non partito";
   return "?";
}

void C12StampaConta(const string quando)
{
   int segnali = 0;
   for(int i = 0; i < C12_N_MOTIVI; i++) if(i != C12_NO_SEGNALE && i != C12_DATI) segnali += g_conta[i];
   int cesti = 0;
   double netto = 0.0;
   for(int d = 0; d <= C12_MAX_LIVELLI; d++) { cesti += g_statN[d]; netto += g_statNet[d]; }
   double pf = (g_perdLorde > 0.0) ? g_profLordi / g_perdLorde : -1.0;
   PrintFormat("[C12OC-CONTA] %s | segnali %d | avvii riusciti %d | scartati: cesto vivo %d | altro lato %d | pausa %d | spread %d | rischio %d | lato spento %d | dati %d | ordine KO %d",
               quando, segnali, g_conta[C12_OK] - g_conta[C12_ORDINE_KO], g_conta[C12_CESTO_VIVO], g_conta[C12_ALTRO_LATO],
               g_conta[C12_PAUSA], g_conta[C12_SPREAD], g_conta[C12_RISCHIO], g_conta[C12_LATO_SPENTO], g_conta[C12_DATI],
               g_conta[C12_ORDINE_KO]);
   PrintFormat("[C12OC-CONTA] %s | cesti chiusi %d | netto %.2f | PF per cesto %.3f | MAE peggiore %.2f | motivi TP %d SL %d PAUSA %d SUP %d ALTRO %d | pause attraversate %d | oltre il rischio pianificato %d (somma %.2f) | livelli saltati per gap %d",
               quando, cesti, netto, pf, g_maePeggiore, g_motTP, g_motSL, g_motPAUSA, g_motSUP, g_motALTRO, g_pauseAttraversate,
               g_oltreRischio, g_oltreRischioSomma, g_livelliSaltati);
   for(int d = 1; d <= C12_MAX_LIVELLI; d++)
      if(g_statN[d] > 0)
         PrintFormat("[C12OC-CONTA] %s | profondita' %d | cesti %d | netto %.2f | in perdita %d | peggiore %.2f",
                     quando, d, g_statN[d], g_statNet[d], g_statNeg[d], g_statPeggiore[d]);
}

//==================================================================
// AUTOTEST (puro): i mattoni della logica su numeri sintetici.
// Nessun ordine, nessuna lettura di conto. Si legge ESEGUENDO l'EA.
//==================================================================
bool C12Caso(const string nome, const bool ok, int &fall)
{
   if(!ok) fall++;
   if(!ok || InpVerbose) PrintFormat("[C12OC][AUTOTEST] %s %s", (ok ? "PASS" : "*** FAIL ***"), nome);
   return ok;
}

int C12AutotestNucleo()
{
   int fall = 0;
   int lato = 0;
   int mot = -1;

   //--- R1 nullo: deterministico, p = 0 mai, p = 1 sempre
   int l1 = 0, l2 = 0;
   bool a1 = C12Nullo(1, 1767225600, 0.3, l1);
   bool a2 = C12Nullo(1, 1767225600, 0.3, l2);
   C12Caso("nullo: stessa barra e stesso seme -> stessa risposta", a1 == a2 && l1 == l2, fall);
   C12Caso("nullo: p = 0 -> mai", !C12Nullo(1, 1767225600, 0.0, lato), fall);
   C12Caso("nullo: p = 1 -> sempre", C12Nullo(7, 1767225660, 1.0, lato) && (lato == 1 || lato == -1), fall);
   //--- 0x477107AE: calcolato fuori dall'EA (Python mix32 e g++ sul nucleo
   //    estratto, 13/10/2026, identici): se MQL5 non fa le moltiplicazioni
   //    uint modulo 2^32 come C, questo caso fallisce e il nullo NON e' quello del proxy
   C12Caso("mix: valore di riferimento C12Mix(1) = 0x477107AE", C12Mix(1) == (uint)0x477107AE, fall);
   //--- tre esiti presi dal generatore del proxy Python (stessi numeri):
   //    seme 0, p 0,25: 1720569600 -> no; 1720569900 -> si' LUNGO;
   //    1720570320 -> si' CORTO
   int lr = 0;
   bool ar = C12Nullo(0, 1720569600, 0.25, lr);
   C12Caso("nullo come il proxy: seme 0, t 1720569600 -> nessun avvio", !ar, fall);
   ar = C12Nullo(0, 1720569900, 0.25, lr);
   C12Caso("nullo come il proxy: seme 0, t 1720569900 -> avvio LUNGO", ar && lr == 1, fall);
   ar = C12Nullo(0, 1720570320, 0.25, lr);
   C12Caso("nullo come il proxy: seme 0, t 1720570320 -> avvio CORTO", ar && lr == -1, fall);

   //--- R1 rottura e ritorno
   C12Caso("rottura: close > canale -> lungo", C12SegnaleRottura(2010.0, 2009.99, 2000.0) == 1, fall);
   C12Caso("rottura: close == massimo -> niente", C12SegnaleRottura(2009.99, 2009.99, 2000.0) == 0, fall);
   C12Caso("rottura: close < minimo -> corto", C12SegnaleRottura(1999.99, 2009.99, 2000.0) == -1, fall);
   C12Caso("ritorno: sotto EMA - 2 ATR -> lungo", C12SegnaleRitorno(1995.9, 2000.0, 2.0, 2.0) == 1, fall);
   C12Caso("ritorno: a EMA - 2 ATR esatto -> niente", C12SegnaleRitorno(1996.0, 2000.0, 2.0, 2.0) == 0, fall);
   C12Caso("ritorno: sopra EMA + 2 ATR -> corto", C12SegnaleRitorno(2004.1, 2000.0, 2.0, 2.0) == -1, fall);
   C12Caso("ritorno: ATR nullo -> niente", C12SegnaleRitorno(1900.0, 2000.0, 0.0, 2.0) == 0, fall);

   //--- R2 + R3 griglia (lungo: P1 2000, passo 1,5, 4 livelli, oltre 8)
   C12Caso("SL cesto lungo = 2000 - (3 x 1,5 + 8) = 1987,5", MathAbs(C12SLCesto(1, 2000.0, 4, 1.5, 8.0) - 1987.5) < 1e-9, fall);
   C12Caso("SL cesto corto = 2000 + 12,5 = 2012,5", MathAbs(C12SLCesto(-1, 2000.0, 4, 1.5, 8.0) - 2012.5) < 1e-9, fall);
   C12Caso("livello 3 lungo = 1997", MathAbs(C12LivelloPrezzo(1, 2000.0, 3, 1.5) - 1997.0) < 1e-9, fall);
   C12Caso("livello 3 corto = 2003", MathAbs(C12LivelloPrezzo(-1, 2000.0, 3, 1.5) - 2003.0) < 1e-9, fall);
   C12Caso("da riempire: Ask 1998,5 -> livello 2", C12LivelloDaRiempire(1, 2000.0, 1998.5, 1.5, 1, 1, 4, 0.005) == 2, fall);
   C12Caso("da riempire: Ask 1998,6 (sopra L2) -> niente", C12LivelloDaRiempire(1, 2000.0, 1998.6, 1.5, 1, 1, 4, 0.005) == 0, fall);
   C12Caso("da riempire: Ask 1997,6 (oltre la finestra di L2, sopra L3) -> niente", C12LivelloDaRiempire(1, 2000.0, 1997.6, 1.5, 1, 1, 4, 0.005) == 0, fall);
   C12Caso("da riempire: gap a 1996,5 -> livello 3 (L2 saltato)", C12LivelloDaRiempire(1, 2000.0, 1996.5, 1.5, 1, 1, 4, 0.005) == 3, fall);
   C12Caso("da riempire: L2 gia' preso, 4 posizioni su 4 -> niente", C12LivelloDaRiempire(1, 2000.0, 1995.5, 1.5, 3, 4, 4, 0.005) == 0, fall);
   C12Caso("da riempire: oltre l'ultimo livello -> niente", C12LivelloDaRiempire(1, 2000.0, 1994.0, 1.5, 3, 3, 4, 0.005) == 0, fall);
   C12Caso("da riempire corto: Bid 2001,5 -> livello 2", C12LivelloDaRiempire(-1, 2000.0, 2001.5, 1.5, 1, 1, 4, 0.005) == 2, fall);
   C12Caso("livello da prezzo: 1997,02 -> 3", C12LivelloDaPrezzo(1, 2000.0, 1997.02, 1.5) == 3, fall);
   C12Caso("livello da prezzo corto: 2001,49 -> 2", C12LivelloDaPrezzo(-1, 2000.0, 2001.49, 1.5) == 2, fall);
   C12Caso("livello da prezzo: sopra P1 -> 1", C12LivelloDaPrezzo(1, 2000.0, 2000.4, 1.5) == 1, fall);

   //--- R4 lotti
   C12Caso("scala piatta: livello 4 = 0,01", MathAbs(C12LottoLivello(4, 0.01, 0.0, 3.0, 0.01, 0.01, 100.0) - 0.01) < 1e-9, fall);
   C12Caso("scala 0,5: livello 2 = 0,01 (0,015 in giu')", MathAbs(C12LottoLivello(2, 0.01, 0.5, 3.0, 0.01, 0.01, 100.0) - 0.01) < 1e-9, fall);
   C12Caso("scala 0,5: livello 5 = 0,03", MathAbs(C12LottoLivello(5, 0.01, 0.5, 3.0, 0.01, 0.01, 100.0) - 0.03) < 1e-9, fall);
   C12Caso("scala 0,5: livello 10 tagliato al tetto 3x = 0,03", MathAbs(C12LottoLivello(10, 0.01, 0.5, 3.0, 0.01, 0.01, 100.0) - 0.03) < 1e-9, fall);
   C12Caso("lotto sotto il minimo -> 0", C12LottoLivello(1, 0.005, 0.0, 3.0, 0.01, 0.01, 100.0) == 0.0, fall);

   //--- R6 rischio: 4 livelli piatti 0,01, passo 1,5, oltre 8:
   //    distanze 12,5 / 11 / 9,5 / 8 -> 41 x 0,01 = 0,41 prezzo x lotti
   C12Caso("rischio pianificato 4 x 0,01 = 0,41", MathAbs(C12RischioPrezzoLotti(4, 1.5, 8.0, 0.01, 0.0, 3.0, 0.01, 0.01, 100.0) - 0.41) < 1e-9, fall);
   C12Caso("lotti pianificati 4 x 0,01 = 0,04", MathAbs(C12LottiPianificati(4, 0.01, 0.0, 3.0, 0.01, 0.01, 100.0) - 0.04) < 1e-9, fall);

   //--- R5 target
   C12Caso("target lungo: media 1999,25 + 1 = 2000,25", MathAbs(C12TargetDopo(1, 2000.0 * 0.01, 0.01, 1998.5, 0.01, 1.0) - 2000.25) < 1e-9, fall);
   C12Caso("target corto: media 2000,75 - 1 = 1999,75", MathAbs(C12TargetDopo(-1, 2000.0 * 0.01, 0.01, 2001.5, 0.01, 1.0) - 1999.75) < 1e-9, fall);
   C12Caso("target superato lungo: Bid 2000,25 >= 2000,25", C12TargetSuperato(1, 2000.25, 2000.25), fall);
   C12Caso("target non superato corto: Ask 1999,76", !C12TargetSuperato(-1, 1999.76, 1999.75), fall);

   //--- R8 pause (fine sessione 23:00 = 82800 s, stop 120, chiudi 90)
   C12Caso("pausa: 20:59 -> libero", C12StatoPausa(20 * 3600 + 59 * 60, 82800, 120, 90) == C12_PAUSA_LIBERO, fall);
   C12Caso("pausa: 21:00 -> niente cesti nuovi", C12StatoPausa(21 * 3600, 82800, 120, 90) == C12_PAUSA_STOP, fall);
   C12Caso("pausa: 21:30 -> chiudere", C12StatoPausa(21 * 3600 + 30 * 60, 82800, 120, 90) == C12_PAUSA_CHIUDI, fall);
   C12Caso("pausa: tick oltre la fine -> chiudere", C12StatoPausa(23 * 3600 + 10 * 60, 82800, 120, 90) == C12_PAUSA_CHIUDI, fall);
   C12Caso("pausa: fine ignota (-1) -> libero", C12StatoPausa(23 * 3600, -1, 120, 90) == C12_PAUSA_LIBERO, fall);
   C12Caso("pausa: sessione che continua fino alle 01:00 del giorno dopo, alle 21:30 -> libero",
           C12StatoPausa(21 * 3600 + 30 * 60, 86400 + 3600, 120, 90) == C12_PAUSA_LIBERO, fall);
   C12Caso("pausa: sessione che continua fino alle 01:00 del giorno dopo, alle 23:30 -> chiudere",
           C12StatoPausa(23 * 3600 + 30 * 60, 86400 + 3600, 120, 90) == C12_PAUSA_CHIUDI, fall);
   C12Caso("venerdi': fine 23:00 tagliata a 22:00", C12TettoVenerdi(5, 82800, 22) == 79200, fall);
   C12Caso("venerdi': fine 21:00 resta 21:00", C12TettoVenerdi(5, 75600, 22) == 75600, fall);
   C12Caso("venerdi': fine ignota -> 22:00", C12TettoVenerdi(5, -1, 22) == 79200, fall);
   C12Caso("giovedi': il tetto non tocca", C12TettoVenerdi(4, 82800, 22) == 82800, fall);
   C12Caso("venerdi' estate col tetto: 20:30 server -> chiudere", C12StatoPausa(20 * 3600 + 30 * 60, C12TettoVenerdi(5, 82800, 22), 120, 90) == C12_PAUSA_CHIUDI, fall);

   //--- R9 spread (bordo: uguale al massimo PASSA)
   C12Caso("spread 0,40 con massimo 0,40 -> passa", C12SpreadOk(0.40, 0.40), fall);
   C12Caso("spread 0,41 con massimo 0,40 -> no", !C12SpreadOk(0.41, 0.40), fall);
   C12Caso("spread con filtro spento (0) -> passa", C12SpreadOk(5.0, 0.0), fall);

   //--- R7 + decisione
   C12Caso("lato libero: nessun cesto", C12LatoLibero(1, false, false, true), fall);
   C12Caso("lato occupato", !C12LatoLibero(1, true, false, true), fall);
   C12Caso("due lati spenti: corto vivo blocca il lungo", !C12LatoLibero(1, false, true, false), fall);
   C12Caso("due lati accesi: corto vivo non blocca il lungo", C12LatoLibero(1, false, true, true), fall);
   int d1 = C12DecidiAvvio(1, true, true, false, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: lungo pulito", d1 == 1 && mot == C12_OK, fall);
   int d2 = C12DecidiAvvio(-1, true, false, false, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: corto con lato spento", d2 == 0 && mot == C12_LATO_SPENTO, fall);
   int d3 = C12DecidiAvvio(1, true, true, true, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: cesto gia' vivo", d3 == 0 && mot == C12_CESTO_VIVO, fall);
   int d4 = C12DecidiAvvio(1, true, true, false, false, true, C12_PAUSA_STOP, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: vicino a una pausa", d4 == 0 && mot == C12_PAUSA, fall);
   int d5 = C12DecidiAvvio(1, true, true, false, false, true, C12_PAUSA_LIBERO, 0.41, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: spread 0,41 > 0,40", d5 == 0 && mot == C12_SPREAD, fall);
   int d6 = C12DecidiAvvio(1, true, true, false, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 50.0, 40.0, mot);
   C12Caso("decisione: rischio 50 oltre il tetto 40", d6 == 0 && mot == C12_RISCHIO, fall);
   int d7 = C12DecidiAvvio(1, true, true, false, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 50.0, 0.0, mot);
   C12Caso("decisione: tetto 0 = spento", d7 == 1 && mot == C12_OK, fall);
   int d8 = C12DecidiAvvio(1, true, true, false, true, false, C12_PAUSA_LIBERO, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: un solo cesto in tutto, corto vivo", d8 == 0 && mot == C12_ALTRO_LATO, fall);
   int d9 = C12DecidiAvvio(0, true, true, false, false, true, C12_PAUSA_LIBERO, 0.20, 0.40, 0.41, 0.0, mot);
   C12Caso("decisione: nessun segnale", d9 == 0 && mot == C12_NO_SEGNALE, fall);
   return fall;
}

void AutoTestC12()
{
   PrintFormat("[C12OC][AUTOTEST] %s | magic %s | commento \"%s_L%d\" (%d caratteri, max 21) | simbolo %s | TF %s",
               g_nome, IntegerToString(InpMagic), InpComment, InpLivelliMax,
               StringLen(InpComment) + 2 + (InpLivelliMax >= 10 ? 2 : 1), g_sym, EnumToString(g_tf));
   int fall  = C12AutotestNucleo();
   int fallG = ABTG_AutotestGuardia();
   if(fall == 0 && fallG == 0)
      Print("[C12OC][AUTOTEST] VERDETTO: PASS (nullo, rottura, ritorno, griglia, finestre, lotti, rischio, target, pause e venerdi', decisione, Guardian)");
   else
      PrintFormat("[C12OC][AUTOTEST] *** FAIL *** nucleo %d casi falliti, Guardian %d -- NON usare i numeri di questa passata.", fall, fallG);
}
//+------------------------------------------------------------------+
