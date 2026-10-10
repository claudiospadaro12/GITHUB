//+------------------------------------------------------------------+
//|                              ABTG_GoldBreakoutATR_Ottimizzato.mq5 |
//|                                                                   |
//|  v1.20 _OTTIMIZZATO: copia della v1.10 (SHA 1381E3DC...) con il   |
//|  SOLO filtro di momentum allineato ST1/ST5 dietro input a default |
//|  NEUTRO. Gira IN PARALLELO all'originale (magic diverso), MAI al  |
//|  suo posto. BOZZA, NON passata dal cancello.                      |
//|                                                                   |
//|  GBA -- rottura di canale + filtro EMA + gestione in ATR, oro.    |
//|                                                                   |
//|  PATERNITA': L'IDEA E' DI EMILIANO, IL CODICE E' NOSTRO.          |
//|  Fonte: live di Emiliano del 09/10/2026 (parte finale, "gold      |
//|  breakout ... EA trend following a rottura di un canale") e la    |
//|  foto del pannello Input di GoldBreakoutATR_v120 1.20 su XAUUSD.  |
//|  Specifica: report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md.       |
//|  Il suo codice NON lo abbiamo e NON lo copiamo: questo EA e'      |
//|  ricreato dalla DESCRIZIONE. Nessun numero e' misurato da noi:    |
//|  "non ha chiuso una notte negativa" e' DICHIARATO (~7 notti).     |
//|                                                                   |
//|  LA LOGICA (una riga per regola, con la funzione che la fa):      |
//|   R1 segnale alla CHIUSURA di una barra del TF del segnale        |
//|      (OnTick: primo tick della barra nuova -> GbaNuovaBarra)      |
//|   R2 BUY se close > massimo delle N barre PRECEDENTI, ESCLUSA la   |
//|      barra di segnale, e close > EMA; SELL specchio               |
//|      (GbaCanale + GbaDirezione)                                   |
//|   R3 ingresso a mercato all'apertura della barra successiva       |
//|      (cioe' al primo tick della barra nuova: GbaApri)             |
//|   R4 filtro spread: salta se spread > InpSpreadMaxATR x ATR       |
//|      (GbaSpreadOk)                                                |
//|   R5 SL iniziale = InpSL_ATR x ATR dal prezzo d'ingresso (GbaApri)|
//|   R6 trailing = estremo dall'ingresso -/+ InpTrail_ATR x ATR,     |
//|      solo a favore (GbaSLProposto + GbaSLMigliore)                |
//|   R7 uscita a tempo dopo InpTimeExitBars barre del TF del segnale |
//|      (GbaUscitaTempo)                                             |
//|   R8 breakeven opzionale: si arma a +InpBE_TriggerATR x ATR, SL = |
//|      ingresso +/- InpBE_OffsetATR x ATR (GbaBeArmato)             |
//|   R9 una sola posizione per magic e simbolo (GbaPosizioneAperta)  |
//|   R10 perdita giornaliera massima in valuta, 0 = spenta           |
//|      (GbaPnlGiorno + GbaGiornoBloccato): blocca i NUOVI ingressi  |
//|   R11 margine libero verificato prima dell'ordine (GbaMargineOk)  |
//|   R12 filtro orario sulle ore SERVER dei NUOVI ingressi (GbaOraOk)|
//|   R13 Guardian (firme B1/C1) IMMEDIATAMENTE prima di trade.Buy /  |
//|      trade.Sell (GbaApri). Mai sulle chiusure ne' sullo stop.     |
//|   R14 lati LONG/SHORT accendibili (pannello "LONG ON / SHORT ON"; |
//|      default entrambi accesi = nessun effetto) (GbaDecidi)        |
//|   R15 tetto di operazioni APERTE per giorno SERVER (audit del     |
//|      dossier Gold Breakout PRO, spec. par. 12): InpMaxTradesPerDay|
//|      0 = nessun limite (replica). Blocca solo i NUOVI ingressi,   |
//|      si azzera a mezzanotte server (GbaTroppeOggi, GbaAperteOggi) |
//|                                                                   |
//|  ASSE SPREAD (spec. par. 9): InpSpreadMaxATR 0,05 = REPLICA del   |
//|  file Input; 0,10 / 0,20 / 0,35 = celle di MISURA (alle 08:52 il  |
//|  pannello di Emiliano era a 0,35). Contatore [GBA-CONTA] dei      |
//|  segnali scartati per spread in OnDeinit; ogni segnale scartato   |
//|  stampa spread/ATR in % e il rapporto stop/spread.                |
//|                                                                   |
//|  OROLOGIO: le ore sono ORA SERVER. BCM e' UTC+1 FISSO (misura del |
//|  24/09): d'estate = ora italiana - 1, d'INVERNO = ora italiana.   |
//|  Il giorno della perdita massima si azzera a mezzanotte SERVER.   |
//|                                                                   |
//|  NIENTE WebRequest, SendMail, notifiche, #import: l'EA parla solo |
//|  col giornale.                                                    |
//+------------------------------------------------------------------+
//  CHANGELOG
//  v1.20  10/10/2026 -- _Ottimizzato (file NUOVO, l'originale resta
//         v1.10 intatto). R16: filtro di momentum ALLINEATO, dal
//         dossier report/GBA_PROPOSTA_STRATEGIST_2026-10-10.md:
//          - ST1 (sez. 4.2): RSI(InpMomPeriod) su InpMomTF letto sulla
//            barra CHIUSA a t0 (GbaShiftChiusa, nessun guardare
//            avanti). BUY solo se RSI >= InpRsiMinAligned, SELL solo se
//            100 - RSI >= InpRsiMinAligned. Celle del dossier: 60 e 65;
//            0 = SPENTO (neutro, handle NON creato).
//          - ST5 (sez. 4.6): Stocastico(14,3,3) linea K (MAIN_LINE,
//            MODE_SMA, STO_LOWHIGH) sullo stesso InpMomTF, stessa regola
//            allineata; celle del dossier 70 e 80; 0 = SPENTO.
//          - ST6 (pendenza EMA, InpSlopeMinATR) NON implementato: il
//            dossier non fissa senza ambiguita' quale ATR normalizza la
//            pendenza (ATR M1? quello di InpAtrTF?) ne' la definizione
//            esatta delle "5 barre". Va chiesto, non inventato.
//         Il filtro si valuta DOPO tutti i cancelli esistenti (solo sui
//         segnali che sarebbero diventati un ingresso): rifiuto =
//         motivo GBA_MOMENTO, contatore a parte [GBA-CONTA-MOMENTO],
//         riga [GBA] MOMENTO col valore letto (gate G0 del dossier).
//         Magic 775900 (blocco 7759xx libero, verificato con git grep
//         --untracked il 10/10). NON compilata, NON testata nel tester:
//         collaudo a tavolino backtest_pipeline/collaudo_gba_ottimizzato.py.
//  v1.10  09/10/2026 -- R15: InpMaxTradesPerDay (default 0 = nessun
//         effetto), motivo GBA_TETTO nel conto [GBA-CONTA] e nel log.
//         GbaInizioGiorno unica per perdita giornaliera e tetto.
//  v1.00  09/10/2026 -- prima stesura, dalla specifica. NON compilata
//         (MetaEditor assente nell'ambiente di scrittura), NON
//         testata nel tester. Il collaudo a tavolino e'
//         backtest_pipeline/collaudo_gba.py; le note (fedele / nostra
//         scelta / non verificato) sono in
//         report/EA_GBA_NOTE_2026-10-09.md.
//
//  PUNTI APERTI (spec. par. 4) -- resi INPUT col default dichiarato,
//  NON decisi:
//   A1 TF dell'EMA e dell'ATR: InpTrendTF / InpAtrTF, default
//      PERIOD_CURRENT = UGUALE AL TF DEL SEGNALE (NON al grafico:
//      semantica nostra, dichiarata). La foto e' su un grafico M15.
//   A2 ATR usato da trailing e breakeven: InpTrailAtrMode, default 0
//      = ATR dell'ultima barra CHIUSA (si aggiorna); 1 = ATR della
//      barra di segnale (fisso per tutta la vita della posizione).
//   A3 Lotti: decisione di Claudio del 09/10 riportata dal
//      coordinatore: InpLots = 1,00 fisso (la foto era sfocata fra
//      10,0 e 0,10). 1,00 lotto XAUUSD = 100 oz: 1 USD di movimento
//      = 100 USD. La perdita a SL dipende dall'ATR del momento.
//   A4 Ore notturne: InpHourStart/InpHourEnd, default 0-24 = nessun
//      filtro (come la foto). La "notte" si MISURA, non si assume.
//   A5 Breakeven: acceso come nella foto (InpUseBreakeven = true).
//+------------------------------------------------------------------+
#property strict
#property copyright "ABTG -- GBA ricreato dalla descrizione di Emiliano (live 09/10/2026)"
#property version   "1.20"

#include <Trade\Trade.mqh>
//--- firme B1/C1 del 18/08: la guardia del conto, lato EA.
//    Fail-open: input spento, conto senza Guardian o Strategy Tester
//    -> l'EA si comporta come se la riga non ci fosse.
#include <ABTG_PausaGuardian.mqh>
CTrade trade;

//==================================================================
// CODICI (motivo del rifiuto di un segnale, azione di gestione)
//==================================================================
#define GBA_OK          0
#define GBA_NO_SEGNALE  1
#define GBA_POSIZIONE   2
#define GBA_ORA         3
#define GBA_GIORNO      4
#define GBA_SPREAD      5
#define GBA_DATI        6
#define GBA_LATO        7
#define GBA_TETTO       8
#define GBA_N_MOTIVI    9
//--- v1.20: motivo del filtro di momentum. Vale GBA_N_MOTIVI apposta:
//    resta FUORI da g_conta[] (la riga [GBA-CONTA] dei lettori non
//    cambia formato) e ha il suo contatore g_contaMomento.
#define GBA_MOMENTO     9
//--- v1.20 ST5: parametri dello Stocastico, PIN del dossier (14,3,3).
#define GBA_STOCH_K     14
#define GBA_STOCH_D     3
#define GBA_STOCH_SLOW  3

#define GBA_AZ_NULLA    0
#define GBA_AZ_SPOSTA   1
#define GBA_AZ_CHIUDI   2

//==================================================================
// INPUT -- SIMBOLO E TIMEFRAME
//==================================================================
input group "=== Simbolo e timeframe ==="
input string          InpSymbol   = "";             // Simbolo ("" = simbolo del grafico)
input ENUM_TIMEFRAMES InpSignalTF = PERIOD_M1;      // TF del segnale (foto: M1; a voce anche M3; asse M5)
input ENUM_TIMEFRAMES InpTrendTF  = PERIOD_CURRENT; // TF dell'EMA [APERTO]: CURRENT = TF del SEGNALE (non del grafico)
input ENUM_TIMEFRAMES InpAtrTF    = PERIOD_CURRENT; // TF dell'ATR [APERTO]: CURRENT = TF del SEGNALE (non del grafico)

//==================================================================
// INPUT -- SEGNALE (valori della foto)
//==================================================================
input group "=== Segnale: rottura del canale + EMA ==="
input int    InpChannelBars  = 48;   // N barre del canale, ESCLUSA la barra di segnale
input int    InpEmaPeriod    = 100;  // EMA del filtro di trend (a voce anche 50)
input int    InpAtrPeriod    = 14;   // Periodo ATR
//--- InpSpreadMaxATR e' un ASSE PRINCIPALE (spec. par. 9): 0,05 e' la
//    REPLICA dichiarata (valore del file Input di Emiliano); 0,10 /
//    0,20 / 0,35 sono celle di MISURA (alle 08:52 il suo pannello
//    mostrava 0,35, cambiato a mano a runtime). Lo stop/spread minimo
//    garantito vale InpSL_ATR / InpSpreadMaxATR: 50x a 0,05, 7,1x a
//    0,35 (sotto la frontiera di casa stop >= 40 x spread).
input double InpSpreadMaxATR = 0.05; // Spread massimo come frazione dell'ATR (0 = filtro spento). ASSE: 0,05 replica / 0,10 / 0,20 / 0,35
input bool   InpAllowLong    = true; // Lato LONG consentito (pannello: "LONG ON")
input bool   InpAllowShort   = true; // Lato SHORT consentito (pannello: "SHORT ON")

//==================================================================
// INPUT -- v1.20 FILTRO DI MOMENTUM ALLINEATO (dossier Strategist
// 10/10, ST1 sez. 4.2 e ST5 sez. 4.6). DEFAULT = SPENTO: con 0.0 su
// entrambe le soglie l'EA e' IDENTICO alla v1.10 (nessun handle,
// nessuna lettura, nessun rifiuto). Verso OPPOSTO al RSI classico:
// qui RSI alto = continuazione della rottura, non ipercomprato.
//==================================================================
input group "=== v1.20 Filtro momentum allineato (0 = spento) ==="
input double          InpRsiMinAligned   = 0.0;        // ST1: RSI allineato minimo (0 = SPENTO). BUY: RSI >= x; SELL: 100-RSI >= x. Celle dossier: 60 / 65
input ENUM_TIMEFRAMES InpMomTF           = PERIOD_M15; // TF di RSI e Stocastico (pin del dossier: M15; CURRENT = TF del segnale)
input int             InpMomPeriod       = 14;         // Periodo RSI (pin del dossier: 14)
input double          InpStochMinAligned = 0.0;        // ST5: Stocastico K(14,3,3) allineato minimo (0 = SPENTO). BUY: K >= x; SELL: 100-K >= x. Celle dossier: 70 / 80

//==================================================================
// INPUT -- USCITE (valori della foto)
//==================================================================
input group "=== Uscite ==="
input double InpSL_ATR        = 2.5;  // SL iniziale = kSL x ATR
input double InpTrail_ATR     = 2.5;  // Trailing = estremo dall'ingresso -/+ kTrail x ATR (0 = spento)
input int    InpTrailAtrMode  = 0;    // ATR di trailing/BE [APERTO]: 0 = ultima barra chiusa, 1 = barra di segnale
input int    InpTimeExitBars  = 48;   // Uscita a tempo dopo N barre del TF del segnale (0 = spenta)
input bool   InpUseBreakeven  = true; // Breakeven (acceso come nella foto)
input double InpBE_TriggerATR = 1.0;  // Breakeven: si arma a +X ATR di profitto
input double InpBE_OffsetATR  = 0.0;  // Breakeven: SL = ingresso +/- X ATR (0 = pareggio esatto)

//==================================================================
// INPUT -- ESECUZIONE E PROTEZIONI
//==================================================================
input group "=== Esecuzione e protezioni ==="
input int    InpSlippagePoints  = 30;   // Slippage massimo (punti)
input double InpMaxDailyLoss    = 0.0;  // Perdita giornaliera massima, valuta del conto (0 = spenta)
input int    InpMaxTradesPerDay = 0;    // Tetto di operazioni APERTE per giorno SERVER (0 = nessun limite, replica)
input bool   InpCheckFreeMargin = true; // Verifica il margine libero prima dell'ordine
input int    InpHourStart       = 0;    // Ora SERVER di inizio dei NUOVI ingressi (inclusa, 0-23)
input int    InpHourEnd         = 24;   // Ora SERVER di fine (esclusa, 0-24). Start > End = a cavallo della mezzanotte

//==================================================================
// INPUT -- RISCHIO
//==================================================================
input group "=== Rischio ==="
input int    InpLotMode = 0;    // 0 = lotto fisso (InpLots) | 1 = rischio % del saldo con lo SL
input double InpLots    = 1.00; // Lotto fisso: decisione di Claudio 09/10 (1,00 lotto oro = 100 oz)
input double InpRiskPct = 0.25; // Rischio % per trade (modo 1): SEGNAPOSTO DA FIRMARE DA CLAUDIO

//==================================================================
// INPUT -- IDENTITA' E STANDARD DI CASA
//==================================================================
input group "=== Identita' e standard di casa ==="
//--- Magic 775800: blocco 7758xx LIBERO, verificato il 09/10 con
//    git grep --untracked su TUTTO il repo (zero occorrenze di un
//    numero a 6 cifre 7758xx). 7745xx Azzurra, 7746xx-7748xx,
//    7753xx/7755xx/7757xx occupati; 7751xx preso lo stesso giorno da
//    ABTG_Bulge_Telemetria mentre questo file era in stesura. Il magic della foto (20261105) NON si usa:
//    e' l'identita' dell'EA di Emiliano, non della nostra sedia.
//--- v1.20 _Ottimizzato: magic 775900, blocco 7759xx LIBERO verificato
//    il 10/10 con git grep --untracked (zero numeri a 6 cifre 7759xx).
//    Il commento qui sopra e' quello della v1.10 (magic 775800, che
//    resta all'originale; 7758xx e' anche del driver R0): NON usarli.
input long   InpMagic       = 775900; // Magic Number (v1.20 _Ottimizzato; l'originale v1.10 e' 775800)
input string InpComment     = "GBA";  // Prefisso commento (commento = prefisso + "_L"/"_S", max 21 caratteri)
input bool   InpUsaGuardian = true;   // Guardian: ferma i NUOVI ingressi (firme B1/C1)
input bool   InpVerbose     = true;   // Stampe informative (gli errori si stampano sempre)
input bool   InpAutoTest    = true;   // Stampa le righe [GBA][AUTOTEST] in avvio

//==================================================================
// VARIABILI GLOBALI
//==================================================================
string          g_sym     = "";
ENUM_TIMEFRAMES g_tfSig   = PERIOD_M1;
ENUM_TIMEFRAMES g_tfTrend = PERIOD_M1;
ENUM_TIMEFRAMES g_tfAtr   = PERIOD_M1;
int             g_hEma    = INVALID_HANDLE;
int             g_hAtr    = INVALID_HANDLE;
datetime        g_lastBar = 0;
//--- contatori dei SEGNALI (barre con rottura + lato EMA) per motivo:
//    g_conta[GBA_OK] = ingressi tentati, g_conta[GBA_SPREAD] = scartati
//    per spread, ecc. Stampati in OnDeinit: nel tester dicono quanto
//    morde il filtro di spread su ogni cella dell'asse.
int             g_conta[GBA_N_MOTIVI];
//--- v1.20: stato del filtro di momentum. Handle creati SOLO se la
//    rispettiva soglia e' > 0 (OnInit), rilasciati in OnDeinit.
ENUM_TIMEFRAMES g_tfMom          = PERIOD_M15;
int             g_hRsi           = INVALID_HANDLE;
int             g_hSto           = INVALID_HANDLE;
int             g_contaMomento   = 0;   // segnali scartati dal filtro di momentum (incluse le letture fallite)
int             g_contaMomDati   = 0;   // di cui: RSI/Stocastico non leggibili
bool            g_momStampato    = false; // G0: la PRIMA riga MOMENTO si stampa sempre

void Log(string m) { if(InpVerbose) Print("[GBA] ", m); }

//==================================================================
// NUCLEO PURO -- niente mercato, niente conto. Sono le funzioni che
// l'autotest interroga in avvio e che il collaudo compila in C++.
//==================================================================

//--- R2: massimo e minimo delle N barre PRECEDENTI alla barra di
//    segnale. Convenzione degli array: indice 0 = barra di SEGNALE
//    (ESCLUSA dal canale), indici 1..n = le n barre prima di lei.
bool GbaCanale(const double &h[], const double &l[], const int n, double &hh, double &ll)
{
   if(n < 1) return false;
   if(ArraySize(h) < n + 1 || ArraySize(l) < n + 1) return false;
   hh = h[1];
   ll = l[1];
   for(int k = 2; k <= n; k++)
   {
      if(h[k] > hh) hh = h[k];
      if(l[k] < ll) ll = l[k];
   }
   return true;
}

//--- R2: direzione. Rottura STRETTA del canale (uguale = niente) e
//    lato STRETTO dell'EMA. +1 = BUY, -1 = SELL, 0 = niente.
int GbaDirezione(const double close1, const double hh, const double ll, const double ema)
{
   if(close1 > hh && close1 > ema) return 1;
   if(close1 < ll && close1 < ema) return -1;
   return 0;
}

//--- R4: spread ammesso se <= kMax x ATR. kMax <= 0 = filtro spento.
bool GbaSpreadOk(const double spread, const double atr, const double kMax)
{
   if(kMax <= 0.0) return true;
   if(atr <= 0.0) return false;
   return (spread <= kMax * atr);
}

//--- R12: ora SERVER ammessa. Start < End: [Start, End). Start > End:
//    a cavallo della mezzanotte (es. 22-6 = 22..23 e 0..5).
//    Start == End: nessun filtro (scelta nostra, dichiarata in avvio).
bool GbaOraOk(const int ora, const int hStart, const int hEnd)
{
   if(hStart == hEnd) return true;
   if(hStart < hEnd) return (ora >= hStart && ora < hEnd);
   return (ora >= hStart || ora < hEnd);
}

//--- R10: giornata bloccata se il risultato del giorno (chiuso +
//    aperto) e' arrivato a -maxPerdita. maxPerdita <= 0 = spenta.
bool GbaGiornoBloccato(const double pnlGiorno, const double maxPerdita)
{
   return (maxPerdita > 0.0 && pnlGiorno <= -maxPerdita);
}

//--- R10 + R15: inizio del giorno SERVER (mezzanotte server) di t.
//    Unica per la perdita giornaliera e per il tetto di operazioni.
datetime GbaInizioGiorno(const datetime t)
{
   return (datetime)(((long)t / 86400) * 86400);
}

bool GbaStessoGiorno(const datetime a, const datetime b)
{
   return (GbaInizioGiorno(a) == GbaInizioGiorno(b));
}

//--- R15: tetto raggiunto se le operazioni APERTE oggi sono gia'
//    maxGiorno. maxGiorno <= 0 = nessun limite.
bool GbaTroppeOggi(const int aperteOggi, const int maxGiorno)
{
   return (maxGiorno > 0 && aperteOggi >= maxGiorno);
}

//--- R1..R12: la decisione su una barra chiusa. Ritorna la direzione
//    da aprire (0 = nessun ordine) e in motivo il perche'.
int GbaDecidi(const double close1, const double hh, const double ll, const double ema,
              const double atr, const double spread, const double kSpread,
              const int ora, const int hStart, const int hEnd,
              const bool posAperta, const bool giornoBloccato,
              const bool allowLong, const bool allowShort,
              const int aperteOggi, const int maxGiorno, int &motivo)
{
   int dir = GbaDirezione(close1, hh, ll, ema);
   if(dir == 0)                           { motivo = GBA_NO_SEGNALE; return 0; }
   if((dir > 0 && !allowLong) || (dir < 0 && !allowShort)) { motivo = GBA_LATO; return 0; }
   if(posAperta)                        { motivo = GBA_POSIZIONE;  return 0; }
   if(!GbaOraOk(ora, hStart, hEnd))       { motivo = GBA_ORA;        return 0; }
   if(giornoBloccato)                     { motivo = GBA_GIORNO;     return 0; }
   if(GbaTroppeOggi(aperteOggi, maxGiorno)) { motivo = GBA_TETTO;    return 0; }
   if(atr <= 0.0)                         { motivo = GBA_DATI;       return 0; }
   if(!GbaSpreadOk(spread, atr, kSpread)) { motivo = GBA_SPREAD;     return 0; }
   motivo = GBA_OK;
   return dir;
}

//--- v1.20 R16 (ST1/ST5, dossier Strategist sez. 4.2 e 4.6): momentum
//    ALLINEATO alla direzione della rottura. valore = RSI o K dello
//    Stocastico (scala 0-100) sulla barra CHIUSA di InpMomTF.
//    soglia <= 0 = filtro SPENTO: passa SEMPRE, senza guardare valore
//    (e' il default neutro, e copre anche valore -1 = "non letto").
//    BUY: valore >= soglia. SELL: 100 - valore >= soglia (specchio).
//    dir 0: non c'e' niente da filtrare -> false.
bool GbaMomentoOk(const int dir, const double valore, const double soglia)
{
   if(soglia <= 0.0) return true;
   if(dir > 0) return (valore >= soglia);
   if(dir < 0) return (100.0 - valore >= soglia);
   return false;
}

//--- R6: estremo dall'ingresso. Array con indice 0 = barra in corso,
//    count-1 = barra d'ingresso. Long = massimo dei massimi, short =
//    minimo dei minimi (prezzi Bid, come le barre di MT5).
double GbaEstremo(const double &h[], const double &l[], const int count, const bool isLong)
{
   double e = isLong ? h[0] : l[0];
   for(int k = 1; k < count; k++)
   {
      if(isLong) { if(h[k] > e) e = h[k]; }
      else       { if(l[k] < e) e = l[k]; }
   }
   return e;
}

//--- R8: breakeven armato quando il profitto (sul prezzo di chiusura:
//    Bid per il long, Ask per lo short) raggiunge trig x ATR.
bool GbaBeArmato(const bool isLong, const double openPx, const double prezzo,
                 const double atr, const double trig)
{
   if(isLong) return (prezzo - openPx >= trig * atr);
   return (openPx - prezzo >= trig * atr);
}

//--- R6 + R8: lo SL proposto, il piu' favorevole fra trailing e
//    breakeven (0 = nessuna proposta). NON lo confronta ancora con lo
//    SL attuale: quello lo fa GbaSLMigliore.
double GbaSLProposto(const bool isLong, const double openPx, const double prezzo,
                     const double estremo, const double atr, const double kTrail,
                     const bool useBE, const double beTrig, const double beOff)
{
   if(atr <= 0.0) return 0.0;
   double best = 0.0;
   bool   ha   = false;
   if(kTrail > 0.0)
   {
      best = isLong ? (estremo - kTrail * atr) : (estremo + kTrail * atr);
      ha   = true;
   }
   if(useBE && GbaBeArmato(isLong, openPx, prezzo, atr, beTrig))
   {
      double be = isLong ? (openPx + beOff * atr) : (openPx - beOff * atr);
      if(!ha || (isLong ? (be > best) : (be < best))) best = be;
      ha = true;
   }
   return ha ? best : 0.0;
}

//--- arrotonda al passo di prezzo (tick size). passo <= 0 = invariato.
double GbaArrotonda(const double x, const double passo)
{
   if(passo <= 0.0) return x;
   return MathRound(x / passo) * passo;
}

//--- R6: SOLO A FAVORE. Lo SL nuovo deve migliorare l'attuale di
//    almeno mezzo passo (niente modifiche per rumore di virgola).
//    curSL <= 0 = posizione senza SL: qualunque SL e' meglio.
bool GbaSLMigliore(const bool isLong, const double nuovo, const double curSL, const double passo)
{
   if(nuovo <= 0.0) return false;
   if(curSL <= 0.0) return true;
   double m = (passo > 0.0) ? passo * 0.5 : 0.0;
   if(isLong) return (nuovo > curSL + m);
   return (nuovo < curSL - m);
}

//--- SYMBOL_TRADE_STOPS_LEVEL: lo SL deve stare dal lato giusto del
//    prezzo di chiusura e ad almeno minDist (prezzo) da esso.
bool GbaSLValido(const bool isLong, const double sl, const double bid, const double ask,
                 const double minDist)
{
   if(isLong) return (sl < bid && (bid - sl) >= minDist);
   return (sl > ask && (sl - ask) >= minDist);
}

//--- R7: uscita a tempo. barre = barre del TF del segnale trascorse
//    dalla barra d'ingresso (0 = siamo ancora nella barra d'ingresso).
bool GbaUscitaTempo(const int barre, const int maxBarre)
{
   return (maxBarre > 0 && barre >= maxBarre);
}

//--- R6 + R7 + R8: l'azione di gestione su un tick. Prima il tempo
//    (chiude), poi lo SL (sposta solo a favore e solo se valido).
int GbaAzione(const bool isLong, const double openPx, const double curSL,
              const double bid, const double ask, const double estremo, const double atr,
              const int barre, const int maxBarre,
              const double kTrail, const bool useBE, const double beTrig, const double beOff,
              const double minDist, const double passo, double &nuovoSL)
{
   nuovoSL = 0.0;
   if(GbaUscitaTempo(barre, maxBarre)) return GBA_AZ_CHIUDI;
   double prezzo = isLong ? bid : ask;
   double cand = GbaSLProposto(isLong, openPx, prezzo, estremo, atr, kTrail, useBE, beTrig, beOff);
   if(cand <= 0.0) return GBA_AZ_NULLA;
   cand = GbaArrotonda(cand, passo);
   if(!GbaSLMigliore(isLong, cand, curSL, passo)) return GBA_AZ_NULLA;
   if(!GbaSLValido(isLong, cand, bid, ask, minDist)) return GBA_AZ_NULLA;
   nuovoSL = cand;
   return GBA_AZ_SPOSTA;
}

//--- lotti a rischio: saldo x pct% diviso la perdita di 1 lotto allo SL.
double GbaLottiRischio(const double saldo, const double pct, const double slDist,
                       const double tickValue, const double tickSize)
{
   if(saldo <= 0.0 || pct <= 0.0 || slDist <= 0.0 || tickValue <= 0.0 || tickSize <= 0.0) return 0.0;
   double perdita1 = slDist / tickSize * tickValue;
   return (saldo * pct / 100.0) / perdita1;
}

//--- vincoli di volume: arrotonda IN GIU' al passo; sotto il minimo
//    NON si alza (si salta l'ordine, ritorna 0); sopra il massimo si
//    taglia al massimo.
double GbaLottiNorm(const double lots, const double step, const double vmin, const double vmax)
{
   if(step <= 0.0 || lots <= 0.0) return 0.0;
   double v = MathFloor(lots / step + 1e-9) * step;
   if(v < vmin - 1e-12) return 0.0;
   if(vmax > 0.0 && v > vmax) v = vmax;
   return v;
}

//==================================================================
// LETTURE DI MERCATO (cablaggio): tutte le letture passano da qui.
//==================================================================

//--- la barra del TF tf CHIUSA all'istante t (t = apertura della barra
//    in corso del TF del segnale). Vale per ogni TF, piu' alto o piu'
//    basso del segnale: la barra che contiene t e' in formazione, la
//    precedente e' chiusa. Con tf == TF del segnale da' 1.
int GbaShiftChiusa(const ENUM_TIMEFRAMES tf, const datetime t)
{
   int s = iBarShift(g_sym, tf, t, false);
   if(s < 0) return -1;
   return s + 1;
}

bool GbaLeggiBuffer(const int handle, const int shift, double &v)
{
   if(handle == INVALID_HANDLE || shift < 0) return false;
   double b[];
   if(CopyBuffer(handle, 0, shift, 1, b) != 1) return false;
   v = b[0];
   return (v != EMPTY_VALUE);
}

//--- R1 + R2: legge la barra di segnale (indice 1 del TF del segnale),
//    il canale delle N barre prima di lei, EMA e ATR chiusi a t0.
bool GbaLeggiSegnale(const datetime t0, double &close1, double &hh, double &ll,
                     double &ema, double &atr)
{
   int n = InpChannelBars;
   double h[], l[], c[];
   ArraySetAsSeries(h, true);
   ArraySetAsSeries(l, true);
   ArraySetAsSeries(c, true);
   if(CopyHigh(g_sym, g_tfSig, 1, n + 1, h) != n + 1) return false;
   if(CopyLow(g_sym, g_tfSig, 1, n + 1, l) != n + 1) return false;
   if(CopyClose(g_sym, g_tfSig, 1, 1, c) != 1) return false;
   close1 = c[0];
   if(!GbaCanale(h, l, n, hh, ll)) return false;
   if(!GbaLeggiBuffer(g_hEma, GbaShiftChiusa(g_tfTrend, t0), ema)) return false;
   if(!GbaLeggiBuffer(g_hAtr, GbaShiftChiusa(g_tfAtr, t0), atr)) return false;
   return true;
}

//--- R6 + R7: barre trascorse, estremo dall'ingresso e ATR di gestione.
//    SENZA STATO: tutto si ricava dall'ora d'apertura della posizione,
//    quindi un riavvio del terminale non perde niente.
//    barre = -1 se l'ora non si ritrova (allora niente uscita a tempo).
bool GbaLeggiGestione(const datetime tOpen, const bool isLong, const datetime t0,
                      int &barre, double &estremo, double &atr)
{
   barre = iBarShift(g_sym, g_tfSig, tOpen, false);
   if(barre < 0) { barre = -1; return false; }
   int cnt = barre + 1;
   double h[], l[];
   ArraySetAsSeries(h, true);
   ArraySetAsSeries(l, true);
   if(CopyHigh(g_sym, g_tfSig, 0, cnt, h) != cnt) return false;
   if(CopyLow(g_sym, g_tfSig, 0, cnt, l) != cnt) return false;
   estremo = GbaEstremo(h, l, cnt, isLong);
   datetime tRif = t0;
   if(InpTrailAtrMode == 1)
   {
      tRif = iTime(g_sym, g_tfSig, barre);
      if(tRif <= 0) return false;
   }
   return GbaLeggiBuffer(g_hAtr, GbaShiftChiusa(g_tfAtr, tRif), atr);
}

//--- v1.20 R16: il filtro di momentum e' acceso se ALMENO una soglia
//    e' > 0. Con i default (0.0 e 0.0) e' false: tutto il codice v1.20
//    che legge, scarta o stampa il momentum sta dietro questa riga.
bool GbaMomentoAcceso()
{
   return (InpRsiMinAligned > 0.0 || InpStochMinAligned > 0.0);
}

//--- v1.20 R16: RSI e/o K stocastico sulla barra di InpMomTF CHIUSA
//    all'istante t0 (stessa GbaShiftChiusa di EMA e ATR: nessun
//    guardare avanti; con t0 = apertura esatta di una barra M15 la
//    barra letta e' la M15 appena chiusa). Legge SOLO gli indicatori
//    accesi; quelli spenti restano a -1 e GbaMomentoOk li fa passare.
//    tBarra = apertura della barra letta (solo per il log G0).
bool GbaLeggiMomento(const datetime t0, double &rsi, double &sto, datetime &tBarra)
{
   rsi    = -1.0;
   sto    = -1.0;
   tBarra = 0;
   if(InpRsiMinAligned > 0.0)
   {
      if(!GbaLeggiBuffer(g_hRsi, GbaShiftChiusa(g_tfMom, t0), rsi)) return false;
   }
   if(InpStochMinAligned > 0.0)
   {
      if(!GbaLeggiBuffer(g_hSto, GbaShiftChiusa(g_tfMom, t0), sto)) return false;
   }
   int s = GbaShiftChiusa(g_tfMom, t0);
   if(s >= 0) tBarra = iTime(g_sym, g_tfMom, s);
   return true;
}

//==================================================================
// FILLING ADATTIVO -- sceglie FOK/IOC/RETURN dal simbolo (come Bulge)
//==================================================================
ENUM_ORDER_TYPE_FILLING GetFillingMode(string sym)
{
   long modes = (long)SymbolInfoInteger(sym, SYMBOL_FILLING_MODE);
   if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
   if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

//==================================================================
// CONTO E POSIZIONI
//==================================================================
bool GbaPosizioneAperta()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) == g_sym &&
         PositionGetInteger(POSITION_MAGIC) == InpMagic) return true;
   }
   return false;
}

//--- R10: risultato del giorno SERVER di questo magic su questo
//    simbolo: deal chiusi (profitto + swap + commissioni + fee) piu'
//    l'aperto (profitto + swap) della posizione viva.
double GbaPnlGiorno()
{
   datetime ora = TimeCurrent();
   datetime ini = GbaInizioGiorno(ora);   // mezzanotte SERVER
   double pnl = 0.0;
   if(HistorySelect(ini, ora + 60))
   {
      int nd = HistoryDealsTotal();
      for(int i = 0; i < nd; i++)
      {
         ulong dk = HistoryDealGetTicket(i);
         if(dk == 0) continue;
         if(HistoryDealGetInteger(dk, DEAL_MAGIC) != InpMagic) continue;
         if(HistoryDealGetString(dk, DEAL_SYMBOL) != g_sym) continue;
         pnl += HistoryDealGetDouble(dk, DEAL_PROFIT) + HistoryDealGetDouble(dk, DEAL_SWAP) +
                HistoryDealGetDouble(dk, DEAL_COMMISSION) + HistoryDealGetDouble(dk, DEAL_FEE);
      }
   }
   else
      Print("[GBA] ERRORE HistorySelect per la perdita giornaliera: ", GetLastError());
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      pnl += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   }
   return pnl;
}

//--- R15: operazioni APERTE oggi (giorno SERVER di t) da questo magic
//    su questo simbolo = deal d'INGRESSO (DEAL_ENTRY_IN) dello storico.
//    Senza stato: sopravvive a un riavvio del terminale.
int GbaAperteOggi(const datetime t)
{
   int n = 0;
   if(!HistorySelect(GbaInizioGiorno(t), TimeCurrent() + 60))
   {
      Print("[GBA] ERRORE HistorySelect per il tetto giornaliero: ", GetLastError());
      return n;
   }
   int nd = HistoryDealsTotal();
   for(int i = 0; i < nd; i++)
   {
      ulong dk = HistoryDealGetTicket(i);
      if(dk == 0) continue;
      if(HistoryDealGetInteger(dk, DEAL_MAGIC) != InpMagic) continue;
      if(HistoryDealGetString(dk, DEAL_SYMBOL) != g_sym) continue;
      if(HistoryDealGetInteger(dk, DEAL_ENTRY) != DEAL_ENTRY_IN) continue;
      if(!GbaStessoGiorno((datetime)HistoryDealGetInteger(dk, DEAL_TIME), t)) continue;
      n++;
   }
   return n;
}

//--- R11: margine libero sufficiente per il volume all'ingresso.
bool GbaMargineOk(const bool isLong, const double lots, const double price)
{
   double margine = 0.0;
   if(!OrderCalcMargin(isLong ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, g_sym, lots, price, margine))
   {
      Print("[GBA] ERRORE OrderCalcMargin: ", GetLastError(), " -- ordine saltato");
      return false;
   }
   double libero = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   if(margine > libero)
   {
      PrintFormat("[GBA] MARGINE INSUFFICIENTE: servono %.2f, liberi %.2f -- ordine saltato", margine, libero);
      return false;
   }
   return true;
}

double GbaTickValue()
{
   double tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tv <= 0.0) tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
   return tv;
}

double GbaLotti(const double slDist)
{
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   double vmin = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   double grezzi = InpLots;
   if(InpLotMode == 1)
      grezzi = GbaLottiRischio(AccountInfoDouble(ACCOUNT_BALANCE), InpRiskPct, slDist,
                               GbaTickValue(), SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE));
   double v = GbaLottiNorm(grezzi, step, vmin, vmax);
   if(v > 0.0 && v < grezzi - 1e-9 && InpLotMode == 0)
      PrintFormat("[GBA] ATTENZIONE: lotto richiesto %.2f ridotto a %.2f dai vincoli del simbolo (passo %.2f, max %.2f)",
                  grezzi, v, step, vmax);
   return NormalizeDouble(v, 2);
}

//==================================================================
// R3 + R5 + R11 + R13: L'INGRESSO
//==================================================================
void GbaApri(const bool isLong, const double atr, const double spread)
{
   int    digits   = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   double point    = SymbolInfoDouble(g_sym, SYMBOL_POINT);
   double tickSize = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   double ask      = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid      = SymbolInfoDouble(g_sym, SYMBOL_BID);
   double minDist  = (double)SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL) * point;
   double slDist   = InpSL_ATR * atr;
   if(slDist <= 0.0 || ask <= 0.0 || bid <= 0.0) { Print("[GBA] ERRORE prezzi/ATR non validi -- ordine saltato"); return; }

   double price = isLong ? ask : bid;
   double sl    = isLong ? (price - slDist) : (price + slDist);
   sl = NormalizeDouble(GbaArrotonda(sl, tickSize), digits);
   if(!GbaSLValido(isLong, sl, bid, ask, minDist))
   {
      PrintFormat("[GBA] SL %s troppo vicino (stops level %s) -- ordine saltato",
                  DoubleToString(sl, digits), DoubleToString(minDist, digits));
      return;
   }
   double lots = GbaLotti(slDist);
   if(lots <= 0.0) { Print("[GBA] lotto nullo dopo i vincoli del simbolo -- ordine saltato"); return; }
   if(InpCheckFreeMargin && !GbaMargineOk(isLong, lots, price)) return;

   string cmt = InpComment + (isLong ? "_L" : "_S");
   trade.SetTypeFilling(GetFillingMode(g_sym));
   bool inviato = false;
   if(isLong)
   {
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_GoldBreakoutATR")) return;
      inviato = trade.Buy(lots, g_sym, ask, sl, 0.0, cmt);
   }
   else
   {
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_GoldBreakoutATR")) return;
      inviato = trade.Sell(lots, g_sym, bid, sl, 0.0, cmt);
   }
   uint rc = trade.ResultRetcode();
   if(!inviato || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_DONE_PARTIAL && rc != TRADE_RETCODE_PLACED))
   {
      PrintFormat("[GBA] ERRORE ordine %s: retcode %u (%s)", (isLong ? "BUY" : "SELL"), rc,
                  trade.ResultRetcodeDescription());
      return;
   }
   double rischio = lots * slDist / tickSize * GbaTickValue();
   if(InpVerbose)
      PrintFormat("[GBA] %s %.2f lotti @ %s | SL %s (%.2f x ATR %s) | spread %s | perdita a SL ~%.2f %s",
                  (isLong ? "BUY" : "SELL"), lots, DoubleToString(trade.ResultPrice(), digits),
                  DoubleToString(sl, digits), InpSL_ATR, DoubleToString(atr, digits),
                  DoubleToString(spread, digits), rischio, AccountInfoString(ACCOUNT_CURRENCY));
}

//==================================================================
// R1..R12: LA BARRA NUOVA
//==================================================================
void GbaNuovaBarra(const datetime t0)
{
   double close1 = 0.0, hh = 0.0, ll = 0.0, ema = 0.0, atr = 0.0;
   if(!GbaLeggiSegnale(t0, close1, hh, ll, ema, atr))
   {
      Print("[GBA] dati non pronti sulla barra ", TimeToString(t0), " -- segnale non valutato");
      return;
   }
   //--- la perdita giornaliera si calcola solo se c'e' un segnale
   //    (legge lo storico: inutile farlo a ogni barra).
   bool giorno = false;
   if(InpMaxDailyLoss > 0.0 && GbaDirezione(close1, hh, ll, ema) != 0)
      giorno = GbaGiornoBloccato(GbaPnlGiorno(), InpMaxDailyLoss);
   int aperteOggi = 0;
   if(InpMaxTradesPerDay > 0 && GbaDirezione(close1, hh, ll, ema) != 0)
      aperteOggi = GbaAperteOggi(t0);

   MqlDateTime dt;
   TimeToStruct(t0, dt);
   double spread = SymbolInfoDouble(g_sym, SYMBOL_ASK) - SymbolInfoDouble(g_sym, SYMBOL_BID);
   int motivo = GBA_NO_SEGNALE;
   int dir = GbaDecidi(close1, hh, ll, ema, atr, spread, InpSpreadMaxATR,
                       dt.hour, InpHourStart, InpHourEnd,
                       GbaPosizioneAperta(), giorno, InpAllowLong, InpAllowShort,
                       aperteOggi, InpMaxTradesPerDay, motivo);
   //--- v1.20 R16 (ST1/ST5): filtro di momentum ALLINEATO. Gira SOLO
   //    se acceso (una soglia > 0) e SOLO su un segnale che i cancelli
   //    v1.10 hanno gia' promosso a ingresso (dir != 0): da spento la
   //    v1.10 e' esatta. Lettura fallita = segnale scartato (fail-closed:
   //    un filtro acceso che non legge non deve far entrare).
   if(dir != 0 && GbaMomentoAcceso())
   {
      double   momRsi   = -1.0;
      double   momSto   = -1.0;
      datetime momBarra = 0;
      bool momLetto = GbaLeggiMomento(t0, momRsi, momSto, momBarra);
      bool momOk    = momLetto && GbaMomentoOk(dir, momRsi, InpRsiMinAligned) &&
                      GbaMomentoOk(dir, momSto, InpStochMinAligned);
      if(InpVerbose || !g_momStampato)
         GbaLogMomento(dir > 0, momLetto, momOk, momRsi, momSto, momBarra);
      g_momStampato = true;
      if(!momOk)
      {
         g_contaMomento++;
         if(!momLetto) g_contaMomDati++;
         motivo = GBA_MOMENTO;
         dir    = 0;
      }
   }
   if(motivo == GBA_NO_SEGNALE) return;
   if(motivo >= 0 && motivo < GBA_N_MOTIVI) g_conta[motivo]++;

   //--- spec. par. 9: in OGNI riga di segnale, spread/ATR in % e il
   //    rapporto stop/spread (stop = InpSL_ATR x ATR). E' la misura
   //    che dice se la cella dell'asse spread sta sopra la frontiera
   //    di casa (stop >= 40 x spread).
   double spreadPct = (atr > 0.0) ? (100.0 * spread / atr) : -1.0;
   double stopSpread = (spread > 0.0) ? (InpSL_ATR * atr / spread) : -1.0;
   string lato = (GbaDirezione(close1, hh, ll, ema) > 0 ? "BUY" : "SELL");
   if(dir == 0)
   {
      //--- R15: ogni segnale scartato per il tetto ha la sua riga, sempre.
      if(motivo == GBA_TETTO)
         PrintFormat("[GBA] TETTO GIORNALIERO: segnale %s scartato, %d operazioni aperte oggi (giorno server %s, max %d)",
                     lato, aperteOggi, TimeToString(GbaInizioGiorno(t0), TIME_DATE), InpMaxTradesPerDay);
      if(InpVerbose || motivo == GBA_SPREAD)
         PrintFormat("[GBA] segnale %s SALTATO (%s) | close %.2f canale %.2f-%.2f EMA %.2f ATR %.2f spread %.2f = %.1f%% ATR (max %.1f%%) | stop/spread %.1fx | ora server %d",
                     lato, GbaMotivoTesto(motivo), close1, ll, hh, ema, atr, spread, spreadPct,
                     100.0 * InpSpreadMaxATR, stopSpread, dt.hour);
      return;
   }
   if(InpVerbose)
      PrintFormat("[GBA] segnale %s | close %.2f canale %.2f-%.2f EMA %.2f ATR %.2f spread %.2f = %.1f%% ATR (max %.1f%%) | stop/spread %.1fx | ora server %d",
                  lato, close1, ll, hh, ema, atr, spread, spreadPct, 100.0 * InpSpreadMaxATR, stopSpread, dt.hour);
   GbaApri(dir > 0, atr, spread);
}

void GbaStampaConta(const string quando)
{
   int segnali = 0;
   for(int i = 0; i < GBA_N_MOTIVI; i++) if(i != GBA_NO_SEGNALE) segnali += g_conta[i];
   PrintFormat("[GBA-CONTA] %s | segnali %d | ingressi tentati %d | scartati: SPREAD %d (spread max %.2f x ATR) | posizione aperta %d | ora %d | perdita giornaliera %d | lato spento %d | ATR non valido %d | tetto giornaliero %d (max %d)",
               quando, segnali, g_conta[GBA_OK], g_conta[GBA_SPREAD], InpSpreadMaxATR, g_conta[GBA_POSIZIONE],
               g_conta[GBA_ORA], g_conta[GBA_GIORNO], g_conta[GBA_LATO], g_conta[GBA_DATI],
               g_conta[GBA_TETTO], InpMaxTradesPerDay);
}

string GbaMotivoTesto(const int m)
{
   if(m == GBA_OK)         return "ok";
   if(m == GBA_NO_SEGNALE) return "nessun segnale";
   if(m == GBA_POSIZIONE)  return "posizione gia' aperta";
   if(m == GBA_ORA)        return "fuori orario";
   if(m == GBA_GIORNO)     return "perdita giornaliera raggiunta";
   if(m == GBA_SPREAD)     return "spread oltre il limite";
   if(m == GBA_DATI)       return "ATR non valido";
   if(m == GBA_LATO)       return "lato spento";
   if(m == GBA_TETTO)      return "tetto di operazioni del giorno";
   if(m == GBA_MOMENTO)    return "momentum non allineato (v1.20)";
   return "?";
}

//--- v1.20 R16: testo di un valore di momentum per il log. soglia <= 0
//    = indicatore spento; valore < 0 = non letto.
string GbaMomTesto(const bool isLong, const double valore, const double soglia)
{
   if(soglia <= 0.0) return "spento";
   if(valore < 0.0)  return "NON LETTO";
   return StringFormat("%.2f (allineato %.2f, min %.1f)", valore, (isLong ? valore : 100.0 - valore), soglia);
}

//--- v1.20 R16: riga del filtro di momentum. La PRIMA si stampa sempre
//    (gate G0 del dossier: il valore letto dal terminale si confronta
//    con quello ricostruito da HistData entro 3 punti), le altre solo
//    con InpVerbose.
void GbaLogMomento(const bool isLong, const bool letto, const bool ok,
                   const double rsi, const double sto, const datetime tBarra)
{
   PrintFormat("[GBA] MOMENTO %s %s | TF %s barra chiusa %s | RSI(%d) %s | Stoc K(%d,%d,%d) %s",
               (isLong ? "BUY" : "SELL"), (ok ? "OK" : (letto ? "SCARTATO" : "SCARTATO (lettura fallita)")),
               EnumToString(g_tfMom), (tBarra > 0 ? TimeToString(tBarra) : "?"),
               InpMomPeriod, GbaMomTesto(isLong, rsi, InpRsiMinAligned),
               GBA_STOCH_K, GBA_STOCH_D, GBA_STOCH_SLOW, GbaMomTesto(isLong, sto, InpStochMinAligned));
}

//--- v1.20 R16: contatore del filtro, riga A PARTE (prefisso diverso:
//    la regex [GBA-CONTA] di leggi_gba_r0.py non la prende).
void GbaStampaContaMomento(const string quando)
{
   PrintFormat("[GBA-CONTA-MOMENTO] %s | scartati per momentum %d (di cui lettura fallita %d) | InpRsiMinAligned=%.2f | InpStochMinAligned=%.2f | InpMomTF=%s | InpMomPeriod=%d",
               quando, g_contaMomento, g_contaMomDati, InpRsiMinAligned, InpStochMinAligned,
               EnumToString(g_tfMom), InpMomPeriod);
}

//==================================================================
// R6 + R7 + R8: GESTIONE DELLA POSIZIONE (a ogni tick)
//==================================================================
void GbaGestisci()
{
   int    digits   = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   double point    = SymbolInfoDouble(g_sym, SYMBOL_POINT);
   double tickSize = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   double minDist  = (double)MathMax(SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL),
                                     SymbolInfoInteger(g_sym, SYMBOL_TRADE_FREEZE_LEVEL)) * point;
   datetime t0 = iTime(g_sym, g_tfSig, 0);
   static datetime ultimoErr = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      bool     isLong = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      double   openPx = PositionGetDouble(POSITION_PRICE_OPEN);
      double   curSL  = PositionGetDouble(POSITION_SL);
      double   curTP  = PositionGetDouble(POSITION_TP);
      datetime tOpen  = (datetime)PositionGetInteger(POSITION_TIME);
      double   bid    = SymbolInfoDouble(g_sym, SYMBOL_BID);
      double   ask    = SymbolInfoDouble(g_sym, SYMBOL_ASK);

      int barre = -1;
      double estremo = 0.0, atr = 0.0;
      //--- se le letture falliscono, ATR = 0 -> nessuno spostamento di
      //    SL; l'uscita a tempo resta viva se le barre si sono lette.
      if(!GbaLeggiGestione(tOpen, isLong, t0, barre, estremo, atr)) { estremo = 0.0; atr = 0.0; }

      double nuovo = 0.0;
      int az = GbaAzione(isLong, openPx, curSL, bid, ask, estremo, atr,
                         barre, InpTimeExitBars,
                         InpTrail_ATR, InpUseBreakeven, InpBE_TriggerATR, InpBE_OffsetATR,
                         minDist, tickSize, nuovo);
      if(az == GBA_AZ_CHIUDI)
      {
         if(trade.PositionClose(tk, (ulong)InpSlippagePoints))
            Log(StringFormat("uscita a tempo: ticket %I64u dopo %d barre", tk, barre));
         else if(TimeCurrent() - ultimoErr >= 60)
         {
            PrintFormat("[GBA] ERRORE chiusura a tempo ticket %I64u: retcode %u (%s)", tk,
                        trade.ResultRetcode(), trade.ResultRetcodeDescription());
            ultimoErr = TimeCurrent();
         }
      }
      else if(az == GBA_AZ_SPOSTA)
      {
         double sl = NormalizeDouble(nuovo, digits);
         if(!trade.PositionModify(tk, sl, curTP) && TimeCurrent() - ultimoErr >= 60)
         {
            PrintFormat("[GBA] ERRORE spostamento SL ticket %I64u a %s: retcode %u (%s)", tk, DoubleToString(sl, digits),
                        trade.ResultRetcode(), trade.ResultRetcodeDescription());
            ultimoErr = TimeCurrent();
         }
      }
   }
}

//==================================================================
// INIT / DEINIT / TICK
//==================================================================
int OnInit()
{
   g_sym = (StringLen(InpSymbol) > 0) ? InpSymbol : _Symbol;
   if(!SymbolSelect(g_sym, true))
   {
      Print("[GBA] ERRORE simbolo non disponibile: ", g_sym);
      return(INIT_FAILED);
   }
   g_tfSig   = (InpSignalTF == PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)_Period : InpSignalTF;
   g_tfTrend = (InpTrendTF  == PERIOD_CURRENT) ? g_tfSig : InpTrendTF;
   g_tfAtr   = (InpAtrTF    == PERIOD_CURRENT) ? g_tfSig : InpAtrTF;

   //--- validazione: un input assurdo ferma l'EA invece di girare storto
   string err = "";
   if(InpChannelBars < 1 || InpChannelBars > 5000) err += " InpChannelBars";
   if(InpEmaPeriod < 1)                            err += " InpEmaPeriod";
   if(InpAtrPeriod < 1)                            err += " InpAtrPeriod";
   if(InpSpreadMaxATR < 0.0)                       err += " InpSpreadMaxATR";
   if(InpSL_ATR <= 0.0)                            err += " InpSL_ATR";
   if(InpTrail_ATR < 0.0)                          err += " InpTrail_ATR";
   if(InpTrailAtrMode != 0 && InpTrailAtrMode != 1) err += " InpTrailAtrMode";
   if(InpTimeExitBars < 0)                         err += " InpTimeExitBars";
   if(InpBE_TriggerATR < 0.0)                      err += " InpBE_TriggerATR";
   if(InpSlippagePoints < 0)                       err += " InpSlippagePoints";
   if(InpMaxDailyLoss < 0.0)                       err += " InpMaxDailyLoss";
   if(InpMaxTradesPerDay < 0)                      err += " InpMaxTradesPerDay";
   if(InpHourStart < 0 || InpHourStart > 23)       err += " InpHourStart";
   if(InpHourEnd < 0 || InpHourEnd > 24)           err += " InpHourEnd";
   if(InpLotMode != 0 && InpLotMode != 1)          err += " InpLotMode";
   if(InpLotMode == 0 && InpLots <= 0.0)           err += " InpLots";
   if(InpLotMode == 1 && InpRiskPct <= 0.0)        err += " InpRiskPct";
   if(StringLen(InpComment) + 2 > 21)              err += " InpComment(>19 caratteri)";
   //--- v1.20 R16: validazione degli input del momentum (i default 0 / 0
   //    / 14 passano: nessun effetto sull'avvio della v1.10).
   if(InpRsiMinAligned < 0.0 || InpRsiMinAligned > 100.0)     err += " InpRsiMinAligned";
   if(InpStochMinAligned < 0.0 || InpStochMinAligned > 100.0) err += " InpStochMinAligned";
   if(InpMomPeriod < 1)                                        err += " InpMomPeriod";
   if(err != "")
   {
      Print("[GBA] ERRORE input non validi:", err);
      return(INIT_PARAMETERS_INCORRECT);
   }

   g_hEma = iMA(g_sym, g_tfTrend, InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   g_hAtr = iATR(g_sym, g_tfAtr, InpAtrPeriod);
   if(g_hEma == INVALID_HANDLE || g_hAtr == INVALID_HANDLE)
   {
      Print("[GBA] ERRORE creazione handle EMA/ATR: ", GetLastError());
      return(INIT_FAILED);
   }
   //--- v1.20 R16: stato e handle del momentum SOLO se il filtro e'
   //    acceso; da spento nessun indicatore in piu' viene caricato.
   if(GbaMomentoAcceso())
   {
      g_tfMom        = (InpMomTF == PERIOD_CURRENT) ? g_tfSig : InpMomTF;
      g_contaMomento = 0;
      g_contaMomDati = 0;
      g_momStampato  = false;
      if(InpRsiMinAligned > 0.0)
      {
         g_hRsi = iRSI(g_sym, g_tfMom, InpMomPeriod, PRICE_CLOSE);
         if(g_hRsi == INVALID_HANDLE)
         {
            Print("[GBA] ERRORE creazione handle RSI del momentum: ", GetLastError());
            return(INIT_FAILED);
         }
      }
      if(InpStochMinAligned > 0.0)
      {
         g_hSto = iStochastic(g_sym, g_tfMom, GBA_STOCH_K, GBA_STOCH_D, GBA_STOCH_SLOW, MODE_SMA, STO_LOWHIGH);
         if(g_hSto == INVALID_HANDLE)
         {
            Print("[GBA] ERRORE creazione handle Stocastico del momentum: ", GetLastError());
            return(INIT_FAILED);
         }
      }
   }

   ArrayInitialize(g_conta, 0);
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints((ulong)InpSlippagePoints);
   trade.SetTypeFilling(GetFillingMode(g_sym));

   //--- il primo segnale si valuta alla PROSSIMA barra nuova: un
   //    avvio a meta' barra non deve entrare in ritardo.
   g_lastBar = iTime(g_sym, g_tfSig, 0);

   GbaLogAvvio();
   if(InpAutoTest) AutoTestGba();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   GbaStampaConta("FINE");
   if(g_hEma != INVALID_HANDLE) IndicatorRelease(g_hEma);
   if(g_hAtr != INVALID_HANDLE) IndicatorRelease(g_hAtr);
   g_hEma = INVALID_HANDLE;
   g_hAtr = INVALID_HANDLE;
   //--- v1.20 R16: contatore del momentum (solo se acceso) e rilascio
   //    dei suoi handle (da spento sono INVALID_HANDLE: nessuna azione).
   if(GbaMomentoAcceso())
   {
      GbaStampaContaMomento("FINE");
   }
   if(g_hRsi != INVALID_HANDLE) IndicatorRelease(g_hRsi);
   if(g_hSto != INVALID_HANDLE) IndicatorRelease(g_hSto);
   g_hRsi = INVALID_HANDLE;
   g_hSto = INVALID_HANDLE;
   Print("[GBA] Deinit reason=", reason);
}

void OnTick()
{
   //--- prima la gestione (uscita a tempo, breakeven, trailing), poi
   //    il segnale: se l'uscita a tempo chiude sulla barra nuova, il
   //    segnale della stessa barra puo' aprire (scelta dichiarata).
   GbaGestisci();
   datetime t0 = iTime(g_sym, g_tfSig, 0);
   if(t0 <= 0) return;
   if(g_lastBar == 0) { g_lastBar = t0; return; }
   if(t0 == g_lastBar) return;
   g_lastBar = t0;
   GbaNuovaBarra(t0);
}

//==================================================================
// LOG DI AVVIO: TUTTI i parametri, cosi' un numero si lega al motore
//==================================================================
void GbaLogAvvio()
{
   PrintFormat("[GBA] AVVIO v1.20 | InpSymbol=\"%s\" -> simbolo %s | InpSignalTF=%s -> %s | InpTrendTF=%s -> %s | InpAtrTF=%s -> %s",
               InpSymbol, g_sym, EnumToString(InpSignalTF), EnumToString(g_tfSig),
               EnumToString(InpTrendTF), EnumToString(g_tfTrend), EnumToString(InpAtrTF), EnumToString(g_tfAtr));
   PrintFormat("[GBA] SEGNALE | InpChannelBars=%d (esclusa la barra di segnale) | InpEmaPeriod=%d | InpAtrPeriod=%d | InpSpreadMaxATR=%.3f",
               InpChannelBars, InpEmaPeriod, InpAtrPeriod, InpSpreadMaxATR);
   PrintFormat("[GBA] SPREAD (ASSE) | InpSpreadMaxATR=%.2f%s | stop/spread minimo garantito = InpSL_ATR / InpSpreadMaxATR = %s | celle: 0,05 replica, 0,10 / 0,20 / 0,35 misura",
               InpSpreadMaxATR, (InpSpreadMaxATR > 0.0 ? "" : " (filtro SPENTO)"),
               (InpSpreadMaxATR > 0.0 ? DoubleToString(InpSL_ATR / InpSpreadMaxATR, 1) + "x" : "nessun limite"));
   PrintFormat("[GBA] LATI | InpAllowLong=%s | InpAllowShort=%s",
               (InpAllowLong ? "true" : "false"), (InpAllowShort ? "true" : "false"));
   //--- v1.20 R16: i quattro input nuovi, sempre (anche da spento).
   PrintFormat("[GBA] MOMENTO (v1.20, ST1/ST5) | InpRsiMinAligned=%.2f%s | InpStochMinAligned=%.2f%s | InpMomTF=%s -> %s | InpMomPeriod=%d | Stoc K/D/slow=%d/%d/%d (pin) | barra CHIUSA di InpMomTF",
               InpRsiMinAligned, (InpRsiMinAligned > 0.0 ? "" : " (SPENTO)"),
               InpStochMinAligned, (InpStochMinAligned > 0.0 ? "" : " (SPENTO)"),
               EnumToString(InpMomTF), (GbaMomentoAcceso() ? EnumToString(g_tfMom) : "non usato (filtro spento)"),
               InpMomPeriod, GBA_STOCH_K, GBA_STOCH_D, GBA_STOCH_SLOW);
   PrintFormat("[GBA] USCITE | InpSL_ATR=%.2f | InpTrail_ATR=%.2f | InpTrailAtrMode=%d (%s) | InpTimeExitBars=%d",
               InpSL_ATR, InpTrail_ATR, InpTrailAtrMode,
               (InpTrailAtrMode == 1 ? "ATR della barra di segnale, fisso" : "ATR dell'ultima barra chiusa"), InpTimeExitBars);
   PrintFormat("[GBA] BREAKEVEN | InpUseBreakeven=%s | InpBE_TriggerATR=%.2f | InpBE_OffsetATR=%.2f",
               (InpUseBreakeven ? "true" : "false"), InpBE_TriggerATR, InpBE_OffsetATR);
   PrintFormat("[GBA] ESECUZIONE | InpSlippagePoints=%d | InpMaxDailyLoss=%.2f%s | InpMaxTradesPerDay=%d%s | InpCheckFreeMargin=%s | InpHourStart=%d | InpHourEnd=%d%s",
               InpSlippagePoints, InpMaxDailyLoss, (InpMaxDailyLoss > 0.0 ? "" : " (spenta)"),
               InpMaxTradesPerDay, (InpMaxTradesPerDay > 0 ? " (giorno SERVER)" : " (nessun limite)"),
               (InpCheckFreeMargin ? "true" : "false"), InpHourStart, InpHourEnd,
               ((InpHourStart == InpHourEnd || (InpHourStart == 0 && InpHourEnd == 24)) ? " (nessun filtro orario)" : ""));
   PrintFormat("[GBA] RISCHIO | InpLotMode=%d (%s) | InpLots=%.2f | InpRiskPct=%.2f (SEGNAPOSTO DA FIRMARE)",
               InpLotMode, (InpLotMode == 1 ? "rischio % del saldo" : "lotto fisso"), InpLots, InpRiskPct);
   if(InpLotMode == 0)
      PrintFormat("[GBA] RISCHIO | lotto fisso %.2f: su XAUUSD 1,00 lotto = 100 oz, 1 USD di movimento = 100 USD per lotto. "
                  "La perdita a SL = %.2f x ATR x 100 x lotti: dipende dall'ATR del momento; il rischio in %% dipende dal conto.",
                  InpLots, InpSL_ATR);
   PrintFormat("[GBA] IDENTITA' | InpMagic=%s | InpComment=\"%s\" (ordini \"%s_L\"/\"%s_S\") | InpUsaGuardian=%s | InpVerbose=%s | InpAutoTest=%s",
               IntegerToString(InpMagic), InpComment, InpComment, InpComment,
               (InpUsaGuardian ? "true" : "false"), (InpVerbose ? "true" : "false"), (InpAutoTest ? "true" : "false"));
   Print("[GBA] OROLOGIO | le ore sono ORA SERVER. BCM = UTC+1 fisso: d'estate ora italiana - 1, d'inverno = ora italiana. ",
         "La perdita giornaliera e il tetto di operazioni si azzerano a mezzanotte SERVER.");
   if(g_tfSig != PERIOD_M1 && g_tfSig != PERIOD_M3 && g_tfSig != PERIOD_M5)
      Print("[GBA] ATTENZIONE: TF del segnale fuori dagli assi dichiarati (M1/M3/M5): ", EnumToString(g_tfSig));
   if(InpLotMode == 1 && InpRiskPct > 1.0)
      PrintFormat("[GBA] ATTENZIONE: InpRiskPct=%.2f oltre 1%% -- il rischio e' una firma di Claudio", InpRiskPct);
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
      Print("[GBA] ATTENZIONE: conto NON hedging -- l'EA e' scritto per HEDGING (in netting si somma ad altri EA sullo stesso simbolo)");
}

//==================================================================
// AUTOTEST (puro): i mattoni della logica su numeri sintetici.
// Nessun ordine, nessuna lettura di conto. Si legge ESEGUENDO l'EA.
//==================================================================
bool GbaCaso(const string nome, const bool ok, int &fall)
{
   if(!ok) fall++;
   if(!ok || InpVerbose) PrintFormat("[GBA][AUTOTEST] %s %s", (ok ? "PASS" : "*** FAIL ***"), nome);
   return ok;
}

int GbaAutotestNucleo()
{
   int fall = 0;
   double hh = 0.0, ll = 0.0;

   //--- R2 CANALE: indice 0 = barra di segnale (ESCLUSA, ha il massimo
   //    e il minimo piu' estremi apposta), 1..4 = canale (estremi
   //    sull'ULTIMA barra del canale, indice 4), indice 5 = FUORI.
   double ch[6] = {2012.0, 2003.0, 2005.0, 2004.0, 2008.0, 2100.0};
   double cl[6] = {1980.0, 1996.0, 1995.0, 1997.0, 1993.0, 1900.0};
   bool okC = GbaCanale(ch, cl, 4, hh, ll);
   GbaCaso("canale: esclusa la barra di segnale, inclusa la N-esima, fuori la N+1 (hh=2008 ll=1993)",
           okC && MathAbs(hh - 2008.0) < 1e-9 && MathAbs(ll - 1993.0) < 1e-9, fall);
   GbaCaso("canale: array troppo corto -> false", !GbaCanale(ch, cl, 6, hh, ll), fall);

   //--- R2 DIREZIONE: rottura stretta e lato stretto dell'EMA
   GbaCaso("rottura al rialzo sopra EMA -> BUY",       GbaDirezione(2009.0, 2008.0, 1993.0, 2000.0) == 1, fall);
   GbaCaso("close == massimo -> niente (stretto)",      GbaDirezione(2008.0, 2008.0, 1993.0, 2000.0) == 0, fall);
   GbaCaso("rottura al rialzo SOTTO l'EMA -> niente",   GbaDirezione(2009.0, 2008.0, 1993.0, 2010.0) == 0, fall);
   GbaCaso("rottura al rialzo con close == EMA -> niente", GbaDirezione(2009.0, 2008.0, 1993.0, 2009.0) == 0, fall);
   GbaCaso("rottura al ribasso sotto EMA -> SELL",      GbaDirezione(1992.0, 2008.0, 1993.0, 2000.0) == -1, fall);
   GbaCaso("close == minimo -> niente (stretto)",       GbaDirezione(1993.0, 2008.0, 1993.0, 2000.0) == 0, fall);
   GbaCaso("rottura al ribasso SOPRA l'EMA -> niente",  GbaDirezione(1992.0, 2008.0, 1993.0, 1990.0) == 0, fall);

   //--- R4 SPREAD
   GbaCaso("spread == 0,05 x ATR -> passa",   GbaSpreadOk(0.05, 1.0, 0.05), fall);
   GbaCaso("spread > 0,05 x ATR -> salta",    !GbaSpreadOk(0.051, 1.0, 0.05), fall);
   GbaCaso("filtro spread spento (k=0)",      GbaSpreadOk(10.0, 1.0, 0.0), fall);
   GbaCaso("ATR nullo -> salta",              !GbaSpreadOk(0.01, 0.0, 0.05), fall);

   //--- R12 ORA SERVER
   GbaCaso("0-24: ore 0 e 23 ammesse",         GbaOraOk(0, 0, 24) && GbaOraOk(23, 0, 24), fall);
   GbaCaso("8-17: 8 si', 17 no, 7 no",         GbaOraOk(8, 8, 17) && !GbaOraOk(17, 8, 17) && !GbaOraOk(7, 8, 17), fall);
   GbaCaso("22-6: 22, 23, 0, 5 si'; 6 e 21 no", GbaOraOk(22, 22, 6) && GbaOraOk(23, 22, 6) && GbaOraOk(0, 22, 6) &&
           GbaOraOk(5, 22, 6) && !GbaOraOk(6, 22, 6) && !GbaOraOk(21, 22, 6), fall);
   GbaCaso("start == end -> nessun filtro",    GbaOraOk(12, 5, 5), fall);

   //--- R10 PERDITA GIORNALIERA
   GbaCaso("giorno: -100 con tetto 100 -> bloccato",   GbaGiornoBloccato(-100.0, 100.0), fall);
   GbaCaso("giorno: -99,99 con tetto 100 -> libero",   !GbaGiornoBloccato(-99.99, 100.0), fall);
   GbaCaso("giorno: tetto 0 -> spento",                !GbaGiornoBloccato(-1000000.0, 0.0), fall);

   //--- R15 TETTO DI OPERAZIONI E MEZZANOTTE SERVER
   //    1767225600 = 2026.01.01 00:00:00 (ora server)
   GbaCaso("tetto: 2 aperte con max 2 -> bloccato",     GbaTroppeOggi(2, 2), fall);
   GbaCaso("tetto: 1 aperta con max 2 -> libero",       !GbaTroppeOggi(1, 2), fall);
   GbaCaso("tetto: max 0 = nessun limite",              !GbaTroppeOggi(1000, 0), fall);
   GbaCaso("mezzanotte: 12:34:56 -> 00:00:00",          GbaInizioGiorno((datetime)(1767225600 + 45296)) == (datetime)1767225600, fall);
   GbaCaso("mezzanotte: 23:59:59 e 00:00:00 dopo sono giorni DIVERSI",
           !GbaStessoGiorno((datetime)(1767225600 + 86399), (datetime)(1767225600 + 86400)), fall);
   GbaCaso("mezzanotte: 00:00:00 e 23:59:59 stesso giorno", GbaStessoGiorno((datetime)1767225600, (datetime)(1767225600 + 86399)), fall);

   //--- DECISIONE COMPLETA (ordine dei cancelli)
   int mot = -1;
   int d1 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: BUY pulito", d1 == 1 && mot == GBA_OK, fall);
   int d2 = GbaDecidi(1992.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: SELL pulito", d2 == -1 && mot == GBA_OK, fall);
   int d3 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, true, false, true, true, 0, 0, mot);
   GbaCaso("decisione: posizione aperta -> niente", d3 == 0 && mot == GBA_POSIZIONE, fall);
   int d4 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 12, 22, 6, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: fuori orario -> niente", d4 == 0 && mot == GBA_ORA, fall);
   int d5 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, true, true, true, 0, 0, mot);
   GbaCaso("decisione: giornata bloccata -> niente", d5 == 0 && mot == GBA_GIORNO, fall);
   int d6 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.06, 0.05, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: spread largo -> niente", d6 == 0 && mot == GBA_SPREAD, fall);
   int d7 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 0.0, 0.03, 0.0, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: ATR nullo -> niente anche a filtro spread spento", d7 == 0 && mot == GBA_DATI, fall);
   int d8 = GbaDecidi(2005.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: dentro il canale -> nessun segnale", d8 == 0 && mot == GBA_NO_SEGNALE, fall);
   int d9 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, false, true, 0, 0, mot);
   GbaCaso("decisione: BUY con LONG spento -> niente", d9 == 0 && mot == GBA_LATO, fall);
   int d10 = GbaDecidi(1992.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, false, 0, 0, mot);
   GbaCaso("decisione: SELL con SHORT spento -> niente", d10 == 0 && mot == GBA_LATO, fall);
   int d11 = GbaDecidi(1992.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, false, true, 0, 0, mot);
   GbaCaso("decisione: SELL con LONG spento -> passa", d11 == -1 && mot == GBA_OK, fall);
   int d12 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.30, 0.35, 3, 0, 24, false, false, true, true, 0, 0, mot);
   GbaCaso("decisione: asse spread 0,35 -> spread 30% ATR passa", d12 == 1 && mot == GBA_OK, fall);
   int d13 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 3, 3, mot);
   GbaCaso("decisione: 3 aperte oggi con tetto 3 -> niente", d13 == 0 && mot == GBA_TETTO, fall);
   int d14 = GbaDecidi(1992.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 2, 3, mot);
   GbaCaso("decisione: 2 aperte oggi con tetto 3 -> passa", d14 == -1 && mot == GBA_OK, fall);
   int d15 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, false, false, true, true, 50, 0, mot);
   GbaCaso("decisione: tetto 0 -> nessun effetto anche a 50 aperte", d15 == 1 && mot == GBA_OK, fall);
   int d16 = GbaDecidi(2009.0, 2008.0, 1993.0, 2000.0, 1.0, 0.03, 0.05, 3, 0, 24, true, false, true, true, 3, 3, mot);
   GbaCaso("decisione: posizione aperta viene prima del tetto", d16 == 0 && mot == GBA_POSIZIONE, fall);

   //--- R7 USCITA A TEMPO
   GbaCaso("tempo: 47 barre su 48 -> resta",  !GbaUscitaTempo(47, 48), fall);
   GbaCaso("tempo: 48 barre su 48 -> chiude", GbaUscitaTempo(48, 48), fall);
   GbaCaso("tempo: 0 = spenta",               !GbaUscitaTempo(100000, 0), fall);
   GbaCaso("tempo: barre ignote (-1) -> resta", !GbaUscitaTempo(-1, 48), fall);

   //--- R6 + R8 TRAILING E BREAKEVEN (long: ingresso 2000, ATR 2, k 2,5)
   double ns = 0.0;
   int a1 = GbaAzione(true, 2000.0, 1995.0, 2002.5, 2002.8, 2003.0, 2.0, 5, 48, 2.5, false, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("trailing long: estremo 2003 -> SL 1998", a1 == GBA_AZ_SPOSTA && MathAbs(ns - 1998.0) < 1e-9, fall);
   int a2 = GbaAzione(true, 2000.0, 1995.0, 2001.99, 2002.29, 2002.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("BE non armato a +0,995 ATR: resta il trailing 1997", a2 == GBA_AZ_SPOSTA && MathAbs(ns - 1997.0) < 1e-9, fall);
   int a3 = GbaAzione(true, 2000.0, 1995.0, 2002.0, 2002.3, 2002.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("BE armato a +1,0 ATR esatto: SL a pareggio 2000", a3 == GBA_AZ_SPOSTA && MathAbs(ns - 2000.0) < 1e-9, fall);
   int a4 = GbaAzione(true, 2000.0, 2000.5, 2002.0, 2002.3, 2002.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("solo a favore: SL attuale 2000,5 > proposto 2000 -> fermo", a4 == GBA_AZ_NULLA, fall);
   int a5 = GbaAzione(true, 2000.0, 1995.0, 2002.0, 2002.3, 2002.0, 2.0, 5, 48, 2.5, true, 1.0, 0.5, 0.0, 0.01, ns);
   GbaCaso("BE con offset +0,5 ATR: SL 2001", a5 == GBA_AZ_SPOSTA && MathAbs(ns - 2001.0) < 1e-9, fall);
   int a6 = GbaAzione(false, 2000.0, 2005.0, 1998.2, 1998.5, 1997.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("trailing short: estremo 1997 -> SL 2002 (BE non armato a +0,75 ATR)", a6 == GBA_AZ_SPOSTA && MathAbs(ns - 2002.0) < 1e-9, fall);
   int a7 = GbaAzione(false, 2000.0, 2005.0, 1997.7, 1998.0, 1997.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("BE short armato (Ask a +1,0 ATR): SL 2000", a7 == GBA_AZ_SPOSTA && MathAbs(ns - 2000.0) < 1e-9, fall);
   int a8 = GbaAzione(true, 2000.0, 1995.0, 2002.5, 2002.8, 2003.0, 2.0, 5, 48, 2.5, true, 1.0, 0.0, 3.0, 0.01, ns);
   GbaCaso("stops level 3,0: SL 2000 a 2,5 dal Bid -> non si sposta", a8 == GBA_AZ_NULLA, fall);
   int a9 = GbaAzione(true, 2000.0, 1995.0, 2002.5, 2002.8, 2003.0, 2.0, 48, 48, 2.5, true, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("tempo scaduto: chiude prima di toccare lo SL", a9 == GBA_AZ_CHIUDI, fall);
   int a10 = GbaAzione(true, 2000.0, 1995.0, 2002.5, 2002.8, 2003.0, 2.0, 5, 48, 0.0, false, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("trailing 0 e BE spento: niente", a10 == GBA_AZ_NULLA, fall);
   int a11 = GbaAzione(true, 2000.0, 0.0, 2002.5, 2002.8, 2003.0, 2.0, 5, 48, 2.5, false, 1.0, 0.0, 0.0, 0.01, ns);
   GbaCaso("posizione senza SL: il trailing ne mette uno", a11 == GBA_AZ_SPOSTA && MathAbs(ns - 1998.0) < 1e-9, fall);

   //--- R6 ESTREMO DALL'INGRESSO (indice 0 = barra in corso)
   double eh[3] = {2010.0, 2005.0, 2012.0};
   double el[3] = {1990.0, 1985.0, 1992.0};
   GbaCaso("estremo long su 3 barre = 2012", MathAbs(GbaEstremo(eh, el, 3, true) - 2012.0) < 1e-9, fall);
   GbaCaso("estremo long su 2 barre = 2010", MathAbs(GbaEstremo(eh, el, 2, true) - 2010.0) < 1e-9, fall);
   GbaCaso("estremo short su 3 barre = 1985", MathAbs(GbaEstremo(eh, el, 3, false) - 1985.0) < 1e-9, fall);

   //--- LOTTI
   GbaCaso("rischio 0,25% di 10000 con SL 5 USD (tick 0,01 = 1) -> 0,05",
           MathAbs(GbaLottiRischio(10000.0, 0.25, 5.0, 1.0, 0.01) - 0.05) < 1e-9, fall);
   GbaCaso("lotti 0,0599 -> 0,05 (in giu')", MathAbs(GbaLottiNorm(0.0599, 0.01, 0.01, 100.0) - 0.05) < 1e-9, fall);
   GbaCaso("lotti sotto il minimo -> 0 (non si alza)", GbaLottiNorm(0.005, 0.01, 0.01, 100.0) == 0.0, fall);
   GbaCaso("lotti sopra il massimo -> massimo", MathAbs(GbaLottiNorm(150.0, 0.01, 0.01, 100.0) - 100.0) < 1e-9, fall);
   GbaCaso("lotto fisso 1,00 resta 1,00", MathAbs(GbaLottiNorm(1.0, 0.01, 0.01, 100.0) - 1.0) < 1e-9, fall);

   return fall;
}

//--- v1.20 R16: la funzione pura del filtro di momentum (ST1/ST5).
int GbaAutotestMomento()
{
   int fall = 0;
   GbaCaso("momento: soglia 0 = spento, passa BUY a 0, SELL a 100, valore non letto (-1)",
           GbaMomentoOk(1, 0.0, 0.0) && GbaMomentoOk(-1, 100.0, 0.0) && GbaMomentoOk(1, -1.0, 0.0) &&
           GbaMomentoOk(-1, -1.0, 0.0), fall);
   GbaCaso("momento: BUY soglia 60, RSI 60 passa (>=), 59,99 no",
           GbaMomentoOk(1, 60.0, 60.0) && !GbaMomentoOk(1, 59.99, 60.0), fall);
   GbaCaso("momento: SELL soglia 60, RSI 40 passa (100-40 = 60), 40,01 no",
           GbaMomentoOk(-1, 40.0, 60.0) && !GbaMomentoOk(-1, 40.01, 60.0), fall);
   GbaCaso("momento: SELL soglia 65 con RSI 70 (contro) -> no; BUY con RSI 30 -> no",
           !GbaMomentoOk(-1, 70.0, 65.0) && !GbaMomentoOk(1, 30.0, 65.0), fall);
   GbaCaso("momento: valore non letto (-1) con soglia accesa -> BUY no",
           !GbaMomentoOk(1, -1.0, 60.0), fall);
   GbaCaso("momento: dir 0 con soglia accesa -> no", !GbaMomentoOk(0, 99.0, 60.0), fall);
   return fall;
}

void AutoTestGba()
{
   PrintFormat("[GBA][AUTOTEST] magic %s | commento \"%s_L\" (%d caratteri, max 21) | simbolo %s | TF segnale %s",
               IntegerToString(InpMagic), InpComment, StringLen(InpComment) + 2, g_sym, EnumToString(g_tfSig));
   int fall = GbaAutotestNucleo();
   fall += GbaAutotestMomento();   // v1.20 R16: funzione pura del filtro
   int fallG = ABTG_AutotestGuardia();
   if(fall == 0 && fallG == 0)
      Print("[GBA][AUTOTEST] VERDETTO: PASS (canale, lato EMA, spread, ora, perdita giornaliera, tetto giornaliero, trailing, tempo, breakeven, lotti, Guardian)");
   else
      PrintFormat("[GBA][AUTOTEST] *** FAIL *** nucleo %d casi falliti, Guardian %d -- NON mettere in campo.", fall, fallG);
}
//+------------------------------------------------------------------+
