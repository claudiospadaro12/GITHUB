//+------------------------------------------------------------------+
//|                                        ABTG_BreakingBand.mq5     |
//|                                                                  |
//|  EA di LABORATORIO "BREAKING BAND" - MT5 - TUTTO-IN-UNO          |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  FONTI NORMATIVE (gerarchia dichiarata dal corso stesso)         |
//|   1. docs/breaking_band/GUIDA_OPERATIVA_11.txt  (PRIMARIA)       |
//|   2. docs/breaking_band/CHECKLIST.txt (vincolante: SI/NO + pesi) |
//|   3. docs/breaking_band/PROMPT.txt (regole tecniche vincolanti:  |
//|      tocco della banda, deviazione standard in espansione/calo)  |
//|   4. docs/breaking_band/PROTOCOLLI_LEONARDO.md (In-/Post-Bulge)  |
//|   5. docs/breaking_band/ESEMPI_OPERATIVI.txt (non normativo)     |
//|   6. backtest_pipeline/prove/BREAKING_BAND_TESI.md (contesto     |
//|      storico: la guida ufficiale VINCE - bande 20/2, non 37/3)   |
//|                                                                  |
//|  COSA FA (mappa REGOLA -> CODICE)                                |
//|   FASE 1 - BULGE (obbligatoria per entrambi i pattern)           |
//|     TryStartBulge / AccumulaBulge / ValidateBulge                |
//|      - espansione evidente delle bande 20/2 (larghezza >= N x    |
//|        larghezza media delle barre precedenti);                  |
//|      - deviazione standard SOPRA la sua SMA50 (criterio          |
//|        ufficiale, obbligatorio, non disattivabile);              |
//|      - candele impulsive (range >= 1.5 x ATR);                   |
//|      - movimento netto e unidirezionale;                         |
//|      - prezzo lontano dalla mediana;                             |
//|      - fase autonoma di almeno N candele (un singolo spike NON   |
//|        e' un bulge) e non oltre 20 candele (band riding).        |
//|     Il bulge FINISCE quando l'espansione non e' piu' verificata  |
//|     (candele piu' piccole / deviazione standard non piu' sopra   |
//|     la SMA50): da li' parte la fase post-bulge.                  |
//|                                                                  |
//|   PATTERN 1 - CONTINUAZIONE (In-Bulge)                           |
//|     UpdatePost + CheckEntryContinuazione                         |
//|      - ritracciamento ORDINATO e diretto verso la banda OPPOSTA; |
//|      - ENTRY al TOCCO della banda opposta (corpo o spike che     |
//|        INTERSECA la banda - regola tecnica del PROMPT);          |
//|      - direzione del trade = direzione dell'impulso originario;  |
//|      - bande in fase di chiusura + deviazione standard in calo.  |
//|      - invalidazioni assolute: candela > 1.5 x ATR, zig-zag,     |
//|        spike profondi, band riding > 20 candele.                 |
//|                                                                  |
//|   PATTERN 2 - INVERSIONE (Post-Bulge / contro-bulge)             |
//|     UpdatePost + CheckEntryInversione                            |
//|      - RIENTRO verso la mediana (puo' superarla) SENZA MAI       |
//|        toccare la banda opposta (se la tocca: pattern morto);    |
//|      - poi RETEST della banda dell'impulso (buffer opzionale);   |
//|      - al retest: banda dell'impulso PIATTA o inclinata A FAVORE |
//|        (valutata sulle 3 candele precedenti il test), bande in   |
//|        restringimento, deviazione standard in calo, banda che    |
//|        NON si rigonfia;                                          |
//|      - ENTRY CONTRO l'impulso;                                   |
//|      - invalidazioni assolute: candela > 1 x ATR nel rientro/    |
//|        retest, banda inclinata contro, banda che si rigonfia,    |
//|        tocco della banda opposta, band riding.                   |
//|                                                                  |
//|   GESTIONE COMUNE (guida cap. "GESTIONE DELLA POSIZIONE")        |
//|      - SL = 3 x ATR (regola fissa);                              |
//|      - TP SEMPRE sulla MEDIANA, aggiornato a ogni barra: la      |
//|        mediana si muove, il TP la segue. Se la mediana e' gia'   |
//|        raggiunta si chiude a mercato ("si chiude alla mediana"); |
//|      - opzionale a +1 x ATR: SL a meta' rischio o a pari;        |
//|      - MAI allargare lo stop loss (controllo esplicito);         |
//|      - filtro news rosse opzionale (standard abtg_news.csv).     |
//|                                                                  |
//|   VARIANTE "DUE TAKE PROFIT" (InpTPMode = 1) - NON e' il default |
//|     Emiliano (il docente) usa una variante della stessa          |
//|     strategia con DUE target: TP1 sulla MEDIANA (come la guida   |
//|     ufficiale / Leonardo) e un SECONDO target sulla BANDA        |
//|     OPPOSTA all'ingresso, lasciando correre un runner.           |
//|     NON l'ha mai approfondita: qui e' implementata come          |
//|     VARIANTE OPZIONALE MISURABILE (default 0 = Leonardo puro,    |
//|     cioe' la guida ufficiale), da misurare in A/B contro il      |
//|     default sullo stesso periodo e sugli stessi simboli.         |
//|     Con InpTPMode=1: parziale InpTP1Pct% al tocco della mediana  |
//|     + SL del runner a pari; il runner ha come TP la banda        |
//|     opposta CORRENTE (aggiornata a ogni barra come la mediana).  |
//|     Vale per ENTRAMBI i pattern (continuazione e inversione).    |
//|                                                                  |
//|  CHECKLIST PESATA (25/25/20/15/10/5): CalcSolidita() calcola la  |
//|  solidita' % con i pesi ufficiali. InpMinSolidita = 0 di default |
//|  (nessun filtro: default neutro, la solidita' viene solo         |
//|  loggata). Le INVALIDAZIONI ASSOLUTE non sono disattivabili: e'  |
//|  vietato ammorbidirle.                                           |
//|                                                                  |
//|  SCELTE NOSTRE (dove la guida e' VISIVA): ogni soglia            |
//|  quantitativa non dichiarata dal corso e' un input marcato       |
//|  "SCELTA NOSTRA" nel commento. Nessun criterio, filtro o peso    |
//|  non presente nei documenti e' stato introdotto.                 |
//|                                                                  |
//|  RELOAD-SAFE: al riavvio la macchina a stati riparte da IDLE     |
//|  (nessuno stato ricostruito dal passato); le posizioni aperte    |
//|  continuano a essere gestite leggendo SOLO i dati della          |
//|  posizione. SL e TP sono ordini VERI sul server: niente stealth. |
//|                                                                  |
//|  Mercati: coppie forex MAJOR/MINOR. TF: D1/H4/H1/M30.            |
//|  DEMO. Nessuna garanzia. Non compilato ne' testato dall'autore   |
//|  del codice: compilare in MetaEditor e validare nel tester.      |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.01 - AUTOPSIA DELLA CASCATA DI RILEVAMENTO.                    |
//|    Il primo scan OHLC (48 simboli x H1/H4 x 3 modi pattern, ~21   |
//|    mesi) ha prodotto mediana 0 trade per cella e 153/288 celle a  |
//|    zero: la macchina non sparava. Diagnosi e correzioni:          |
//|                                                                   |
//|    [A] BUG DI MAPPATURA REGOLA->CODICE (corretti)                 |
//|     A1. INVERSIONE uccisa da UNA candela > 1 x ATR nel rientro.   |
//|         La guida dice l'opposto: "Nell'inversione NON e' richiesto|
//|         rientro ordinato"; l'invalidazione e' "il rientro E'      |
//|         VIOLENTO composto da candelE impulsivE" (plurale) e       |
//|         "impulsiva" nella guida vale > 1.5 x ATR. Ora serve un    |
//|         NUMERO di candele impulsive (InpInvViolentBars).          |
//|     A2. Direzione del bulge presa dal COLORE della prima candela  |
//|         della fase: se quella candela era di segno opposto al     |
//|         movimento, il bulge moriva dopo per "movimento non        |
//|         unidirezionale". Ora si puo' derivare dal movimento netto |
//|         della fase (InpBulgeDirMode).                             |
//|     A3. Il tetto di 20 candele della guida (band riding) era      |
//|         applicato alla durata della fase misurata come "larghezza |
//|         >= 1.5 x riferimento congelato". Ma la larghezza delle    |
//|         bande e' una deviazione standard a 20 periodi: dopo un    |
//|         impulso resta alta ~20 barre PER COSTRUZIONE, quindi la   |
//|         fase sforava il tetto e il setup veniva distrutto.        |
//|         Nuovo InpBulgeEndMode=1: la fase finisce quando           |
//|         l'espansione si esaurisce (larghezza che si contrae),     |
//|         come dice la guida ("candele piu' piccole, deviazione     |
//|         standard in calo, perdita di spinta").                    |
//|                                                                   |
//|    [B] SOGLIE STRUTTURALMENTE TROPPO SEVERE (default rivisti,     |
//|        vecchio valore dichiarato nel commento dell'input)         |
//|     B1. InpZigZagATR   1.0 -> 1.5 (la guida ammette micro-        |
//|         rotazioni e piccoli rimbalzi; "impulso" = 1.5 x ATR).     |
//|     B2. InpDeepSpikeATR 1.0 -> 1.5 (in guida il retest "pulito"   |
//|         e' un SEGNALE DI QUALITA', non un'invalidazione).         |
//|     B3. InpRientroMaxATR 1.0 -> 1.5 (definizione di impulsiva).   |
//|     B4. InpReinflateTolPct 1.00 -> 1.05 (tolleranza zero = un     |
//|         solo tick sopra il massimo del bulge uccideva tutto).     |
//|     B5. InpPostATRRef=1: le invalidazioni della fase post usano   |
//|         l'ATR CONGELATO a fine bulge. Con l'ATR corrente le       |
//|         soglie si stringevano da sole man mano che il mercato si  |
//|         calmava (effetto cricchetto: piu' il rientro era          |
//|         ordinato, piu' era facile invalidarlo).                   |
//|                                                                   |
//|    [C] SEVERITA' LEGITTIMA DELLA GUIDA (NON toccata, solo resa    |
//|        misurabile nel funnel): candela > 1.5 x ATR nel            |
//|        ritracciamento, fase >= 3 candele, candele impulsive       |
//|        obbligatorie nel bulge, divieto di toccare la banda        |
//|        opposta nell'inversione, band riding > 20 candele,         |
//|        tocco della banda opposta obbligatorio (continuazione).    |
//|                                                                   |
//|    [D] Bande in chiusura / deviazione standard in calo per la     |
//|        CONTINUAZIONE: la guida si contraddice (tabella "REGOLE    |
//|        UFFICIALI" le pretende, sezione C dice "nella             |
//|        continuazione le bande possono essere ancora gonfie, il    |
//|        ritracciamento e' il vero filtro"). Restano ACCESE di      |
//|        default ma sono ora due input, per poterle misurare in A/B.|
//|                                                                   |
//|    [E] DIAGNOSTICA: contatori del funnel di mortalita' stampati   |
//|        da OnTester (PrintFunnel). Nessun impatto sul CSV.         |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.01"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF operativo (guida: D1/H4/H1/M30)

input group "=== Indicatori (parametri UFFICIALI della guida) ==="
input int    InpBBPeriod       = 20;    // Bollinger: periodo (guida: 20)
input double InpBBDev          = 2.0;   // Bollinger: deviazioni standard (guida: 2)
input int    InpStdPeriod      = 20;    // Deviazione standard: periodo
input int    InpStdSmaPeriod   = 50;    // SMA sulla deviazione standard (guida: 50)
input int    InpAtrPeriod      = 14;    // ATR per tutte le misure (SCELTA NOSTRA: 14 standard)

input group "=== Pattern da operare ==="
input int    InpPatternMode    = 2;     // 0=SOLO CONTINUAZIONE, 1=SOLO INVERSIONE, 2=ENTRAMBI

input group "=== FASE 1: riconoscimento del BULGE ==="
input double InpBulgeWidthMult = 1.5;   // SCELTA NOSTRA: larghezza bande >= N x media delle barre precedenti
input int    InpBulgeRefBars   = 20;    // SCELTA NOSTRA: barre di riferimento per la larghezza media
input int    InpBulgeMinBars   = 3;     // SCELTA NOSTRA: candele minime (un singolo spike NON e' bulge)
input int    InpBulgeMaxBars   = 20;    // GUIDA: impulso <= 20 candele (oltre = band riding)
input int    InpBulgeMinImpBars= 1;     // SCELTA NOSTRA: candele impulsive minime dentro il bulge
input double InpBulgeCandleMaxATR = 0.0;// GUIDA "1.5-3 x ATR": 0 = nessun tetto (il 3x e' 'tipico', non un limite)
input double InpBulgeNetMoveATR= 1.5;   // SCELTA NOSTRA: movimento netto minimo del bulge (in ATR)
input double InpBulgeMedianDistPct = 0.75; // SCELTA NOSTRA: max allontanamento dalla mediana in frazione di semiampiezza (0.75 = 1.5 sigma, e' un MASSIMO sulla fase: non e' il collo di bottiglia)
input int    InpBulgeEndMode   = 1;     // [1.01 - era 0] fine della fase: 0=larghezza sotto la soglia (v1.00: dura ~20 barre PER COSTRUZIONE e sfora il tetto della guida) 1=espansione esaurita, larghezza che si contrae
input int    InpBulgeDirMode   = 1;     // [1.01 - era 0] direzione del bulge: 0=colore della PRIMA candela della fase (v1.00) 1=segno del movimento NETTO della fase

input group "=== FASE 2: ritracciamento / rientro (invalidazioni) ==="
input double InpImpulseATR     = 1.5;   // GUIDA (invalidazione assoluta, NON ammorbidita): candela > 1.5 x ATR nel ritracciamento -> CONTINUAZIONE invalida
input double InpRientroMaxATR  = 1.5;   // [1.01 - era 1.0] candela "impulsiva" nel rientro/retest: la guida definisce impulsiva > 1.5 x ATR
input int    InpInvViolentBars = 3;     // [1.01 - era 1 di fatto] quante candele impulsive rendono il rientro "VIOLENTO" (guida: "il rientro e' violento composto da candelE impulsivE"; "nell'inversione NON e' richiesto rientro ordinato")
input double InpZigZagATR      = 1.5;   // [1.01 - era 1.0] SCELTA NOSTRA: candela CONTRARIA al ritracciamento >= N x ATR = zig-zag. Con 1.0 uccideva il 37% dei setup: la guida ammette micro-rotazioni e piccoli rimbalzi
input double InpDeepSpikeATR   = 1.5;   // [1.01 - era 1.0] SCELTA NOSTRA: ombra >= N x ATR = "spike profondo". In guida il retest "pulito" e' un SEGNALE DI QUALITA', non un'invalidazione
input int    InpPostATRRef     = 1;     // [1.01 - era 0 di fatto] ATR di riferimento nella fase post: 0=ATR corrente (si stringe da solo mentre il mercato si calma) 1=ATR congelato a fine bulge
input int    InpBandRidingMaxBars = 20; // GUIDA: band riding oltre 20 candele sulla banda dell'impulso
input int    InpPostBulgeMaxBars  = 30; // SCELTA NOSTRA: durata massima della fase post-bulge (poi setup scaduto)
input double InpReinflateTolPct= 1.05;  // [1.01 - era 1.00] SCELTA NOSTRA: la larghezza non deve superare N x il massimo del bulge (1.00 = tolleranza ZERO)
input bool   InpUseShadowFilter= false; // GUIDA (facoltativo): ombre <= 1.5 x corpo nel ritracciamento
input double InpShadowBodyMult = 1.5;   // ombra massima in multipli del corpo
input bool   InpUseRangeReduction = false; // GUIDA (facoltativo): range medio ridotto vs bulge
input double InpRangeReductionPct = 30.0;  // riduzione minima % del range medio (guida: 30-50%)
input bool   InpContNoImpulseBandReturn = false; // LEONARDO: la continuazione muore se torna sulla banda dell'impulso dopo la mediana

input group "=== FASE 3: condizioni di ENTRATA ==="
input int    InpNarrowBars     = 2;     // SCELTA NOSTRA: bande "in chiusura" se larghezza[1] < larghezza[1+N]
input int    InpStdDownMode    = 0;     // 0 = 2 candele giu' OPPURE sotto SMA50 (PROMPT); 1 = sotto SMA50 obbligatorio (guida conferme)
input double InpFlatSlopeATR   = 0.05;  // SCELTA NOSTRA: pendenza massima per dire banda "piatta" (frazione di ATR per barra)
input int    InpSlopeSource    = 0;     // 0 = banda dell'impulso (tabella/filtri); 1 = mediana (nota "definizione operativa")
input double InpRetestBufferATR= 0.15;  // LEONARDO: buffer del limit sul retest (0.1-0.2 x ATR) - solo INVERSIONE
input bool   InpContRequireNarrow  = true; // CONTINUAZIONE: pretendi bande in chiusura. La guida si contraddice (tabella REGOLE UFFICIALI: si; sezione C: "le bande possono essere ancora gonfie"). Esposto per A/B
input bool   InpContRequireStdDown = true; // CONTINUAZIONE: pretendi deviazione standard in calo (idem: regola dichiarata per l'inversione, dedotta per la continuazione). Esposto per A/B
input bool   InpUseReversalCandle = false; // GUIDA (regola OPZIONALE): candela di inversione sul livello di test
input double InpRevBodyMaxPct  = 33.0;  // SCELTA NOSTRA: corpo massimo % del range per dirla "di rigetto"
input double InpRevShadowMinPct= 50.0;  // SCELTA NOSTRA: ombra di rigetto minima % del range
input double InpMinSolidita    = 0.0;   // 0 = nessun filtro; altrimenti solidita' % minima (checklist pesata)

input group "=== Stop loss / take profit / gestione ==="
input double InpSL_ATRmult     = 3.0;   // GUIDA: SL = 3 x ATR (regola fissa)
input int    InpTPMode         = 0;     // Gestione TP: 0=mediana secca (Leonardo, ufficiale) 1=parziale su mediana + runner su banda opposta (variante Emiliano)
input double InpTP1Pct         = 50.0;  // TPMode 1: % chiusa al tocco della mediana (poi SL a pari)
input int    InpTPRefreshBars  = 1;     // Aggiornamento del TP sulla mediana ogni N barre (guida: ogni 2-3 candele)
input double InpBEatATR        = 1.0;   // GUIDA (opzionale): a +N x ATR riduci il rischio. 0 = spento
input int    InpBEMode         = 0;     // 0 = SL a META' rischio; 1 = SL a PARI (breakeven)
input double InpMinTPatATR     = 0.0;   // SCELTA NOSTRA: distanza minima del TP in ATR. 0 = solo il minimo del broker

input group "=== Congestione iniziale (CS / CDA - peso 25% della checklist) ==="
input bool   InpUseCongestionFilter = false; // default SPENTO: la guida valida il bulge anche senza congestione
input int    InpCongBars       = 15;    // CHECKLIST: 10-15 candele di fase preparatoria
input int    InpCongCSMin      = 4;     // CHECKLIST: CS valida con almeno 4/5 criteri
input int    InpCongCDAStdBars = 10;    // CHECKLIST CDA: deviazione standard in calo per >= 10-15 candele
input double InpCongWidthDropPct = 15.0;// CHECKLIST CDA: ampiezza bande in calo del 15-30%
input double InpCongLateralATR = 1.0;   // SCELTA NOSTRA: lateralita' = spostamento netto <= N x ATR

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;   // Rischio % per operazione (sullo SL)
input int    InpMaxPositions   = 1;     // Un solo trade per volta (niente griglie, niente martingala)
input int    InpMaxTradesPerDay= 0;     // 0 = illimitati

input group "=== Filtro notizie (guida: evitare news rosse su H1/M30) ==="
input bool   InpUseNewsFilter  = false;
input string InpNewsFile       = "abtg_news.csv";
input int    InpNewsMinImpact  = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment        = "BB";  // commento ordini
input long   InpMagic          = 772101;
input int    InpMaxSpread      = 0;     // 0 = nessun limite (in points)
input bool   InpVerbose        = true;

//==================================================================
//  COSTANTI / STATO
//==================================================================
#define ST_IDLE   0     // in attesa di un bulge
#define ST_BULGE  1     // fase di espansione in corso
#define ST_POST   2     // bulge concluso: ritracciamento / rientro

#define PAT_CONT  0     // continuazione (In-Bulge)
#define PAT_INV   1     // inversione (Post-Bulge / contro-bulge)

int hBB=INVALID_HANDLE, hStd=INVALID_HANDLE, hStdSma=INVALID_HANDLE, hAtr=INVALID_HANDLE;

//--- serie ricopiate a ogni nuova barra (indice 0 = barra in corso: si legge da 1)
MqlRates gR[];
double   gMid[], gUp[], gLo[], gStd[], gStdSma[], gAtr[];
int      gNeed=200;

datetime gLastBar=0;
int      gDay=-1, gTradesToday=0;
long     gBarSeq=0;

//--- macchina a stati del pattern
int      gState=ST_IDLE;
int      gBulgeDir=0;          // +1 bulge rialzista, -1 ribassista
int      gBulgeBars=0;         // candele della fase di bulge
int      gBulgeImpBars=0;      // candele impulsive dentro il bulge
double   gBulgeRefWidth=0.0;   // larghezza di riferimento congelata all'inizio del bulge
double   gBulgeMaxWidth=0.0;   // massima larghezza raggiunta (riferimento anti-rigonfiamento)
double   gBulgeEndWidth=0.0;   // larghezza all'ultima candela di bulge
double   gBulgeStartPrice=0.0; // apertura della prima candela di bulge
double   gBulgeEndClose=0.0;   // chiusura dell'ultima candela di bulge
double   gBulgeRangeSum=0.0;   // somma dei range del bulge (per il confronto col ritracciamento)
double   gBulgeMaxMedDist=0.0; // massimo allontanamento dalla mediana (frazione di semiampiezza)
double   gCongScore=0.0;       // esito della congestione iniziale (0 o 1, regola della checklist)

int      gPostBars=0;          // candele trascorse dalla fine del bulge
bool     gContAlive=false;     // pattern di CONTINUAZIONE ancora valido
bool     gInvAlive=false;      // pattern di INVERSIONE ancora valido
bool     gTouchedOpposite=false;
bool     gReachedMedian=false;
int      gMedianBar=-1;        // gPostBars in cui e' stata raggiunta la mediana
double   gWidthAtMedian=0.0;
double   gRetrRangeSum=0.0;
int      gRetrBars=0;
int      gRetrShadowViol=0;    // candele con ombra > InpShadowBodyMult x corpo
int      gRideBars=0;          // candele consecutive appoggiate alla banda dell'impulso
double   gPostAtrRef=0.0;      // 1.01: ATR congelato a fine bulge (InpPostATRRef=1)
int      gInvViolBars=0;       // 1.01: candele impulsive contate nel rientro (rientro "violento")

//--- 1.01 CONTATORI DEL FUNNEL DI MORTALITA' (solo diagnostica, stampati da
//    OnTester: servono a capire DOVE muore la cascata, senza toccare il CSV)
long cB_start=0, cB_maxbars=0, cB_riding=0, cB_end=0, cB_short=0, cB_noimp=0,
     cB_dir=0, cB_net=0, cB_med=0, cB_valid=0;
long cP_expired=0, cX_contImp=0, cX_contZig=0, cX_contSpike=0, cX_contReinf=0,
     cX_contRide=0, cX_contRitorno=0, cX_invViol=0, cX_invSpike=0, cX_invReinf=0,
     cX_invRide=0, cX_invOpp=0;
long cInv_mediana=0, cInv_retest=0, cCont_test=0;
long cE_contNarrow=0, cE_contStd=0, cE_contShadow=0, cE_contRange=0, cE_contRev=0,
     cE_contSolid=0, cE_contBlocked=0;
long cE_invSlope=0, cE_invNarrow=0, cE_invStd=0, cE_invReinf=0, cE_invShadow=0,
     cE_invRange=0, cE_invRev=0, cE_invSolid=0, cE_invBlocked=0;
long cO_cont=0, cO_inv=0, cO_failTP=0, cO_failSL=0, cO_failLot=0, cO_failSend=0;

//--- stato per posizione (SL iniziale: serve alla riduzione del rischio, che
//    deve essere IDEMPOTENTE e non trasformarsi in un trailing barra per barra;
//    gPosTP1 = parziale sulla mediana gia' eseguito nella variante InpTPMode=1)
ulong    gPosTicket[];
double   gPosSlInit[];
bool     gPosTP1[];

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[BB] ", m); }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   if(InpPatternMode<0 || InpPatternMode>2)
     { Print("ERRORE: InpPatternMode deve essere 0, 1 o 2."); return(INIT_FAILED); }
   if(InpBulgeMinBars<1 || InpBulgeMaxBars<InpBulgeMinBars)
     { Print("ERRORE: InpBulgeMinBars/InpBulgeMaxBars incoerenti."); return(INIT_FAILED); }
   if(InpBulgeRefBars<2 || InpNarrowBars<1)
     { Print("ERRORE: InpBulgeRefBars/InpNarrowBars troppo piccoli."); return(INIT_FAILED); }
   //--- 1.01: i nuovi selettori devono restare nel dominio dichiarato, altrimenti
   //    si ricadrebbe di nascosto in comportamenti non voluti (es. InpInvViolentBars
   //    a 0 farebbe morire l'inversione ancora prima di v1.00).
   if(InpBulgeEndMode<0 || InpBulgeEndMode>1)
     { Print("ERRORE: InpBulgeEndMode deve essere 0 o 1."); return(INIT_FAILED); }
   if(InpBulgeDirMode<0 || InpBulgeDirMode>1)
     { Print("ERRORE: InpBulgeDirMode deve essere 0 o 1."); return(INIT_FAILED); }
   if(InpPostATRRef<0 || InpPostATRRef>1)
     { Print("ERRORE: InpPostATRRef deve essere 0 o 1."); return(INIT_FAILED); }
   if(InpInvViolentBars<1)
     { Print("ERRORE: InpInvViolentBars deve essere >= 1 (1 = comportamento v1.00)."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   hBB  = iBands(_Symbol,InpTF,InpBBPeriod,0,InpBBDev,PRICE_CLOSE);
   hStd = iStdDev(_Symbol,InpTF,InpStdPeriod,0,MODE_SMA,PRICE_CLOSE);
   hAtr = iATR(_Symbol,InpTF,InpAtrPeriod);
   if(hBB==INVALID_HANDLE || hStd==INVALID_HANDLE || hAtr==INVALID_HANDLE)
     { Print("ERRORE: creazione handle Bollinger/StdDev/ATR."); return(INIT_FAILED); }

   //--- SMA50 calcolata SUI DATI della deviazione standard (guida: "Standard
   //    Deviation with SMA 50"): in MQL5 si passa l'handle come 'applied_price'.
   hStdSma = iMA(_Symbol,InpTF,InpStdSmaPeriod,0,MODE_SMA,hStd);
   if(hStdSma==INVALID_HANDLE)
     { Print("ERRORE: creazione handle SMA sulla deviazione standard."); return(INIT_FAILED); }

   int need = InpCongBars + InpBulgeRefBars + InpStdSmaPeriod + 40;
   gNeed = (int)MathMax(150.0, (double)need);

   if(InpTPMode<0 || InpTPMode>1)
     { Print("ERRORE: InpTPMode deve essere 0 (mediana secca) o 1 (parziale + runner)."); return(INIT_FAILED); }

   ResetPattern("avvio");
   ArrayResize(gPosTicket,0);
   ArrayResize(gPosSlInit,0);
   ArrayResize(gPosTP1,0);
   RegisterExistingPositions();     // reload-safe: riaggancio delle posizioni aperte

   if(InpUseNewsFilter) LoadNews();

   Log(StringFormat("avviato su %s %s. Bollinger %d/%.1f, StdDev %d con SMA%d, ATR %d. Modo pattern: %s.",
       _Symbol,EnumToString(InpTF),InpBBPeriod,InpBBDev,InpStdPeriod,InpStdSmaPeriod,InpAtrPeriod,
       (InpPatternMode==0?"SOLO CONTINUAZIONE":(InpPatternMode==1?"SOLO INVERSIONE":"ENTRAMBI"))));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[4]={hBB,hStd,hStdSma,hAtr};
   for(int i=0;i<4;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del giorno.
   //    Sta QUI e non dopo il filtro della nuova barra: su H4/D1 la caduta
   //    peggiore di giornata succede in mezzo alla candela.
   {
    MqlDateTime _n; TimeToStruct(TimeCurrent(), _n);
    double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
    if(_n.day_of_year != gDayEqStamp)
      { gDayEqStamp = _n.day_of_year; gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(gDayStartEquity <= 0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(_eq < gDayMinEquity)  gDayMinEquity = _eq;
    double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
    if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
   }

   //--- riduzione del rischio: reagisce dentro la candela (a +1 x ATR)
   ManageRiskReduction();
   //--- variante Emiliano: il parziale sulla mediana NON e' un ordine sul
   //    server (il TP e' la banda opposta), quindi va sorvegliato a ogni tick
   ManagePartialAtMedian();

   //--- TUTTA la logica di pattern gira su BARRA CHIUSA (niente ripaint)
   datetime t=iTime(_Symbol,InpTF,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   if(!RefreshData()){ Log("dati non pronti: riprovo alla prossima barra."); return; }

   gBarSeq++;
   PosCleanup();

   //--- 1) la mediana si muove: il TP la segue (o si chiude a mercato)
   if(InpTPRefreshBars>0 && (gBarSeq%(long)InpTPRefreshBars)==0) RefreshTakeProfit();

   //--- 2) macchina a stati del pattern (puo' aprire)
   AdvanceMachine();
  }

//==================================================================
//  DATI
//==================================================================
bool CopyInd(int handle,int buffer,double &dst[])
  {
   ArraySetAsSeries(dst,true);
   if(CopyBuffer(handle,buffer,0,gNeed,dst)<gNeed) return(false);
   return(true);
  }

bool RefreshData()
  {
   ArraySetAsSeries(gR,true);
   if(CopyRates(_Symbol,InpTF,0,gNeed,gR)<gNeed) return(false);
   if(!CopyInd(hBB ,0,gMid))    return(false);   // 0 = BASE_LINE  (mediana)
   if(!CopyInd(hBB ,1,gUp))     return(false);   // 1 = UPPER_BAND
   if(!CopyInd(hBB ,2,gLo))     return(false);   // 2 = LOWER_BAND
   if(!CopyInd(hStd,0,gStd))    return(false);
   if(!CopyInd(hStdSma,0,gStdSma)) return(false);
   if(!CopyInd(hAtr,0,gAtr))    return(false);
   //--- warm-up: la SMA50 costruita SUI DATI della deviazione standard vale 0
   //    finche' non ha abbastanza campioni. Senza questo controllo, all'inizio
   //    della storia "StdDev > SMA50" sarebbe sempre vero e nascerebbero bulge
   //    fantasma nelle prime candele del backtest.
   if(gStdSma[1]<=0.0 || gStd[1]<=0.0 || gAtr[1]<=0.0) return(false);
   return(true);
  }

//==================================================================
//  MISURE ELEMENTARI
//==================================================================
double Width(int i)
  {
   if(i<0 || i>=ArraySize(gUp) || i>=ArraySize(gLo)) return(0.0);
   return(gUp[i]-gLo[i]);
  }

double AvgWidth(int from,int count)
  {
   if(from<0 || count<1) return(0.0);
   if(from+count>=ArraySize(gUp)) return(0.0);
   double s=0.0;
   for(int j=from;j<from+count;j++) s+=Width(j);
   return(s/count);
  }

//--- REGOLA TECNICA DEL TOCCO (PROMPT, vincolante): il corpo o lo SPIKE
//    deve INTERSECARE la linea della banda. La semplice prossimita' non basta.
bool TouchUpper(int i,double buffer){ return(gR[i].high >= gUp[i]-buffer); }
bool TouchLower(int i,double buffer){ return(gR[i].low  <= gLo[i]+buffer); }

//--- banda dell'impulso / banda opposta in funzione della direzione del bulge
bool TouchImpulseBand(int i,double buffer)
  { return(gBulgeDir>0 ? TouchUpper(i,buffer) : TouchLower(i,buffer)); }
bool TouchOppositeBand(int i)
  { return(gBulgeDir>0 ? TouchLower(i,0.0) : TouchUpper(i,0.0)); }
//--- rientro alla mediana: il prezzo la raggiunge tornando indietro
bool TouchMedian(int i)
  { return(gBulgeDir>0 ? (gR[i].low<=gMid[i]) : (gR[i].high>=gMid[i])); }

//--- REGOLA TECNICA DELLA DEVIAZIONE STANDARD (PROMPT, vincolante):
//    IN CALO se mostra almeno 2 candele consecutive di discesa OPPURE
//    e' sotto la SMA50. Modo 1: si pretende SOTTO la SMA50 (conferme
//    tecniche fondamentali della guida / protocollo di Leonardo).
bool StdInCalo(int i)
  {
   if(i+2>=ArraySize(gStd)) return(false);
   bool sotto = (gStd[i] < gStdSma[i]);
   if(InpStdDownMode==1) return(sotto);
   bool dueGiu = (gStd[i]<gStd[i+1] && gStd[i+1]<gStd[i+2]);
   return(sotto || dueGiu);
  }

//--- bande in fase di CHIUSURA / restringimento dopo il bulge
bool BandeInChiusura(int i)
  {
   int j=i+InpNarrowBars;
   if(j>=ArraySize(gUp)) return(false);
   return(Width(i) < Width(j));
  }

//--- pendenza della banda da valutare sulle 3 candele PRECEDENTI il test
//    (regola vincolante della guida). Positiva = banda che sale.
double SlopeBandaTest(int i)
  {
   int a=i+1, b=i+3;
   if(b>=ArraySize(gUp)) return(0.0);
   double va,vb;
   if(InpSlopeSource==1){ va=gMid[a]; vb=gMid[b]; }
   else if(gBulgeDir>0) { va=gUp[a];  vb=gUp[b];  }
   else                 { va=gLo[a];  vb=gLo[b];  }
   return((va-vb)/2.0);   // pendenza media per barra
  }

//--- candela di inversione sul livello di test (REGOLA OPZIONALE della guida:
//    pin bar / doji di rigetto / piccolo engulfing NON impulsivo)
bool CandelaDiInversione(int i,bool isLong,double atr)
  {
   double range=gR[i].high-gR[i].low;
   if(range<=0.0) return(false);
   if(range > InpRientroMaxATR*atr) return(false);              // non deve essere impulsiva
   double body=MathAbs(gR[i].close-gR[i].open);
   if(body > InpRevBodyMaxPct/100.0*range) return(false);
   double upSh=gR[i].high-MathMax(gR[i].open,gR[i].close);
   double dnSh=MathMin(gR[i].open,gR[i].close)-gR[i].low;
   double rigetto = isLong ? dnSh : upSh;                        // ombra dal lato del test
   return(rigetto >= InpRevShadowMinPct/100.0*range);
  }

bool ModoConsente(int pattern)
  {
   if(InpPatternMode==2) return(true);
   return(InpPatternMode==pattern);
  }

//==================================================================
//  CONGESTIONE INIZIALE (CS / CDA) - peso 25% della checklist
//  Valutata sulle InpCongBars candele PRIMA della prima candela di
//  bulge. La guida e' esplicita: la congestione NON definisce il
//  bulge e la sua assenza non lo invalida -> filtro di default OFF.
//  Ritorna 1.0 (sezione valida) oppure 0.0, come vuole la checklist:
//  CS < 4/5 -> si valuta la CDA; CDA anche un solo NO -> 0%.
//==================================================================
double CongestionScore(int from)
  {
   int n=InpCongBars;
   if(n<3 || from+n+2>=ArraySize(gR)) return(0.0);
   double atr=gAtr[from];
   if(atr<=0.0) return(0.0);

   double sumRange=0.0, maxRange=0.0;
   bool   nessunImpulso=true, stdSempreSotto=true;
   int    stdGiu=0;
   double netto=gR[from].close-gR[from+n-1].close;
   int    dirCanale=(netto>=0.0)?+1:-1;
   bool   canalePulito=true;

   for(int j=from;j<from+n;j++)
     {
      double rg=gR[j].high-gR[j].low;
      sumRange+=rg;
      if(rg>maxRange) maxRange=rg;
      if(rg > InpImpulseATR*atr) nessunImpulso=false;
      if(!(gStd[j]<gStdSma[j])) stdSempreSotto=false;
      if(j+1<ArraySize(gStd) && gStd[j]<gStd[j+1]) stdGiu++;
      bool contraria = (dirCanale>0) ? (gR[j].close<gR[j].open) : (gR[j].close>gR[j].open);
      if(contraria && rg>=InpZigZagATR*atr) canalePulito=false;
     }
   double mediaRange=sumRange/n;
   double wIni=Width(from+n-1), wFin=Width(from);

   //--- CONGESTIONE STANDARD (CS): valida con almeno InpCongCSMin criteri su 5
   int cs=0;
   if(wIni>0.0 && wFin<wIni)                                cs++;   // bande in compressione progressiva
   if(mediaRange<=atr && maxRange<=1.5*mediaRange)          cs++;   // range ridotto e omogeneo
   if(MathAbs(netto)<=InpCongLateralATR*atr)                cs++;   // lateralita'
   if(nessunImpulso)                                        cs++;   // nessun micro-impulso
   if(stdSempreSotto)                                       cs++;   // deviazione standard bassa e stabile
   if(cs>=InpCongCSMin) return(1.0);

   //--- CONGESTIONE DIREZIONALE AMMISSIBILE (CDA): TUTTI i criteri o zero
   bool c1=(stdGiu>=InpCongCDAStdBars);
   bool c2=(gStd[from]<gStdSma[from]);
   bool c3=(wIni>0.0 && (wIni-wFin)/wIni >= InpCongWidthDropPct/100.0);
   bool c4=nessunImpulso;
   bool c5=canalePulito;
   if(c1 && c2 && c3 && c4 && c5) return(1.0);
   return(0.0);
  }

//==================================================================
//  MACCHINA A STATI
//==================================================================
void ResetPattern(string motivo)
  {
   if(gState!=ST_IDLE && StringLen(motivo)>0) Log("pattern azzerato: "+motivo);
   gState=ST_IDLE;
   gBulgeDir=0; gBulgeBars=0; gBulgeImpBars=0;
   gBulgeRefWidth=0.0; gBulgeMaxWidth=0.0; gBulgeEndWidth=0.0;
   gBulgeStartPrice=0.0; gBulgeEndClose=0.0; gBulgeRangeSum=0.0; gBulgeMaxMedDist=0.0;
   gCongScore=0.0;
   gPostBars=0; gContAlive=false; gInvAlive=false;
   gTouchedOpposite=false; gReachedMedian=false; gMedianBar=-1; gWidthAtMedian=0.0;
   gRetrRangeSum=0.0; gRetrBars=0; gRetrShadowViol=0; gRideBars=0;
   gPostAtrRef=0.0; gInvViolBars=0;
  }

void AdvanceMachine()
  {
   int i=1;                                   // ultima barra CHIUSA
   if(ArraySize(gAtr)<=i+InpBulgeRefBars+3) return;
   double atr=gAtr[i];
   if(atr<=0.0) return;
   double w=Width(i);
   if(w<=0.0) return;

   if(gState==ST_IDLE)  { TryStartBulge(i,atr,w); return; }
   if(gState==ST_BULGE) { UpdateBulge(i,atr,w);   return; }
   if(gState==ST_POST)  { UpdatePost(i,atr,w);    return; }
  }

//--- FASE 1a: nasce la fase di espansione?
void TryStartBulge(int i,double atr,double w)
  {
   double ref=AvgWidth(i+1,InpBulgeRefBars);
   if(ref<=0.0) return;
   if(w < InpBulgeWidthMult*ref) return;             // espansione evidente delle bande
   if(!(gStd[i] > gStdSma[i])) return;               // deviazione standard SOPRA la SMA50 (obbligatorio)

   double cong=CongestionScore(i+1);
   if(InpUseCongestionFilter && cong<=0.0) return;   // filtro opzionale (default OFF)

   gState=ST_BULGE;
   cB_start++;
   gCongScore=cong;
   gBulgeRefWidth=ref;
   //--- direzione PROVVISORIA (serve solo al conteggio del band riding dentro
   //    la fase): con InpBulgeDirMode=1 viene riscritta in ValidateBulge dal
   //    movimento netto. In v1.00 restava quella del colore della prima
   //    candela e mandava a morte i bulge nati su una candela di segno opposto.
   gBulgeDir=(gR[i].close>=gR[i].open)?+1:-1;
   gBulgeStartPrice=gR[i].open;
   gBulgeBars=0; gBulgeImpBars=0; gBulgeRangeSum=0.0;
   gBulgeMaxWidth=0.0; gBulgeMaxMedDist=0.0; gRideBars=0;
   AccumulaBulge(i,atr,w);
   Log(StringFormat("BULGE in formazione (%s) alle %s: larghezza %.5f vs media %.5f.",
       (gBulgeDir>0?"rialzista":"ribassista"),
       TimeToString(gR[i].time,TIME_DATE|TIME_MINUTES), w, ref));
  }

//--- FASE 1b: accumula le misure di UNA candela di bulge
void AccumulaBulge(int i,double atr,double w)
  {
   gBulgeBars++;
   double rg=gR[i].high-gR[i].low;
   gBulgeRangeSum+=rg;
   bool impulsiva=(rg >= InpImpulseATR*atr) &&
                  (InpBulgeCandleMaxATR<=0.0 || rg <= InpBulgeCandleMaxATR*atr);
   if(impulsiva) gBulgeImpBars++;
   if(w>gBulgeMaxWidth) gBulgeMaxWidth=w;
   gBulgeEndWidth=w;
   gBulgeEndClose=gR[i].close;
   double semi=gUp[i]-gMid[i];
   if(semi>0.0)
     {
      double d=MathAbs(gR[i].close-gMid[i])/semi;
      if(d>gBulgeMaxMedDist) gBulgeMaxMedDist=d;
     }
   if(TouchImpulseBand(i,0.0)) gRideBars++; else gRideBars=0;
  }

//--- FASE 1c: la fase continua o e' finita?
void UpdateBulge(int i,double atr,double w)
  {
   //--- QUANDO FINISCE LA FASE DI ESPANSIONE (bug A3 della v1.00)
   //    Modo 0 (v1.00): la fase dura finche' la larghezza resta >= 1.5 x il
   //    riferimento congelato. Ma la larghezza delle bande E' una deviazione
   //    standard a 20 periodi: dopo un impulso resta alta finche' le candele
   //    grandi non escono dalla finestra, cioe' ~20 barre PER COSTRUZIONE.
   //    Risultato: la fase sforava sistematicamente InpBulgeMaxBars e il
   //    setup veniva DISTRUTTO prima ancora di essere validato.
   //    Modo 1 (default 1.01): la fase finisce quando l'espansione si
   //    esaurisce, cioe' quando la larghezza smette di crescere - che e'
   //    esattamente quello che dice la guida ("candele piu' piccole,
   //    deviazione standard in calo, perdita di spinta direzionale").
   bool ancoraInEspansione;
   if(InpBulgeEndMode==1) ancoraInEspansione = (w >= Width(i+1))                    && (gStd[i] > gStdSma[i]);
   else                   ancoraInEspansione = (w >= InpBulgeWidthMult*gBulgeRefWidth) && (gStd[i] > gStdSma[i]);

   if(ancoraInEspansione)
     {
      AccumulaBulge(i,atr,w);
      if(gBulgeBars>InpBulgeMaxBars)
        { cB_maxbars++; ResetPattern(StringFormat("impulso oltre %d candele (limite della guida).",InpBulgeMaxBars)); return; }
      if(gRideBars>InpBandRidingMaxBars)
        { cB_riding++; ResetPattern("band riding prolungato sulla banda dell'impulso."); return; }
      return;
     }

   //--- il bulge si e' CONCLUSO sulla candela precedente: validazione ufficiale
   ValidateBulge(i,atr,w);
  }

void ValidateBulge(int i,double atr,double w)
  {
   //--- criteri UFFICIALI del bulge (checklist: tutti obbligatori)
   cB_end++;
   if(gBulgeBars<InpBulgeMinBars)
     { cB_short++; ResetPattern(StringFormat("fase troppo corta (%d candele): un singolo spike non e' un bulge.",gBulgeBars)); return; }
   if(gBulgeImpBars<InpBulgeMinImpBars)
     { cB_noimp++; ResetPattern("nessuna candela impulsiva dentro la fase."); return; }
   double netto=gBulgeEndClose-gBulgeStartPrice;
   //--- DIREZIONE DELLA FASE (bug A2 della v1.00): con InpBulgeDirMode=1 la
   //    direzione e' quella del movimento NETTO della fase, non il colore
   //    della prima candela. Il requisito di direzionalita' resta comunque
   //    garantito dal controllo sul movimento netto minimo qui sotto.
   if(InpBulgeDirMode==1 && netto!=0.0) gBulgeDir=(netto>0.0)?+1:-1;
   if((gBulgeDir>0 && netto<=0.0) || (gBulgeDir<0 && netto>=0.0))
     { cB_dir++; ResetPattern("movimento non unidirezionale."); return; }
   if(MathAbs(netto) < InpBulgeNetMoveATR*atr)
     { cB_net++; ResetPattern("movimento netto insufficiente."); return; }
   if(gBulgeMaxMedDist < InpBulgeMedianDistPct)
     { cB_med++; ResetPattern("il prezzo non si e' allontanato abbastanza dalla mediana."); return; }
   cB_valid++;

   Log(StringFormat("BULGE VALIDO (%s): %d candele, %d impulsive, netto %.5f, distanza mediana %.2f, "
                    "larghezza max %.5f / a fine fase %.5f. Congestione iniziale: %s.",
       (gBulgeDir>0?"rialzista":"ribassista"),gBulgeBars,gBulgeImpBars,netto,gBulgeMaxMedDist,
       gBulgeMaxWidth,gBulgeEndWidth,
       (gCongScore>0.0?"valida":"assente/non valida")));

   //--- si apre la fase post-bulge: entrambi i pattern sono ancora possibili
   gState=ST_POST;
   gPostBars=0;
   gContAlive=true; gInvAlive=true;
   gTouchedOpposite=false; gReachedMedian=false; gMedianBar=-1; gWidthAtMedian=0.0;
   gRetrRangeSum=0.0; gRetrBars=0; gRetrShadowViol=0; gRideBars=0;
   //--- ATR CONGELATO a fine bulge: e' il metro con cui la guida misura le
   //    candele del ritracciamento ("grandi rispetto all'impulso"). Con l'ATR
   //    corrente le soglie si stringono da sole mentre il mercato si calma:
   //    piu' il rientro e' ordinato, piu' diventa facile invalidarlo.
   gPostAtrRef=atr; gInvViolBars=0;

   //--- la candela corrente e' gia' la prima del ritracciamento/rientro
   UpdatePost(i,atr,w);
  }

//--- FASE 2/3: ritracciamento (continuazione) e rientro/retest (inversione)
void UpdatePost(int i,double atr,double w)
  {
   gPostBars++;
   if(gPostBars>InpPostBulgeMaxBars)
     { cP_expired++; ResetPattern("fase post-bulge scaduta senza test valido."); return; }

   //--- metro di misura della fase post (vedi InpPostATRRef)
   double aref = (InpPostATRRef==1 && gPostAtrRef>0.0) ? gPostAtrRef : atr;

   double rg   = gR[i].high-gR[i].low;
   double body = MathAbs(gR[i].close-gR[i].open);
   double upSh = gR[i].high-MathMax(gR[i].open,gR[i].close);
   double dnSh = MathMin(gR[i].open,gR[i].close)-gR[i].low;
   double ombra= MathMax(upSh,dnSh);

   gRetrBars++;
   gRetrRangeSum+=rg;
   if(body>0.0 && ombra > InpShadowBodyMult*body) gRetrShadowViol++;

   //--- INVALIDAZIONE ASSOLUTA DELLA CONTINUAZIONE (guida, categoria C:
   //    "Nessuna candela con range > 1.5 x ATR nel ritracciamento"). NON si tocca.
   if(rg > InpImpulseATR*aref && gContAlive)
     { gContAlive=false; cX_contImp++; Log("continuazione invalidata: candela > 1.5 x ATR nel ritracciamento/test."); }

   //--- INVERSIONE (bug A1 della v1.00). La guida dice testualmente
   //    "Nell'inversione NON e' richiesto rientro ordinato" e l'invalidazione
   //    e' "il rientro E' VIOLENTO composto da candelE impulsivE": e' una
   //    QUALITA' DELLA FASE, non una singola candela. In v1.00 bastava UNA
   //    candela > 1 x ATR e il 99% delle inversioni moriva li' dentro.
   if(rg > InpRientroMaxATR*aref && gInvAlive)
     {
      gInvViolBars++;
      if(gInvViolBars>=InpInvViolentBars)
        { gInvAlive=false; cX_invViol++;
          Log(StringFormat("inversione invalidata: rientro VIOLENTO (%d candele impulsive > %.2f x ATR).",
              gInvViolBars,InpRientroMaxATR)); }
     }

   if(ombra >= InpDeepSpikeATR*aref)
     {
      if(gContAlive||gInvAlive) Log("pattern invalidato: spike profondo (struttura sporca).");
      if(gContAlive) cX_contSpike++;
      if(gInvAlive)  cX_invSpike++;
      gContAlive=false; gInvAlive=false;
     }
   //--- zig-zag: impulso CONTRARIO al ritracciamento (torna verso la banda dell'impulso)
   bool contraria=(gBulgeDir>0)?(gR[i].close>gR[i].open):(gR[i].close<gR[i].open);
   if(contraria && rg >= InpZigZagATR*aref && gContAlive)
     { gContAlive=false; cX_contZig++; Log("continuazione invalidata: zig-zag (impulso contrario nel ritracciamento)."); }
   //--- espansione contraria / la banda si gonfia di nuovo
   if(gBulgeMaxWidth>0.0 && w > InpReinflateTolPct*gBulgeMaxWidth)
     {
      if(gContAlive||gInvAlive) Log("pattern invalidato: le bande si gonfiano di nuovo (espansione contraria).");
      if(gContAlive) cX_contReinf++;
      if(gInvAlive)  cX_invReinf++;
      gContAlive=false; gInvAlive=false;
     }
   //--- band riding sulla banda dell'impulso
   if(TouchImpulseBand(i,0.0)) gRideBars++; else gRideBars=0;
   if(gRideBars>InpBandRidingMaxBars)
     {
      if(gContAlive||gInvAlive) Log("pattern invalidato: band riding prolungato.");
      if(gContAlive) cX_contRide++;
      if(gInvAlive)  cX_invRide++;
      gContAlive=false; gInvAlive=false;
     }
   if(!gContAlive && !gInvAlive){ ResetPattern(""); return; }

   //--- TEST DELLA BANDA OPPOSTA: obbligatorio per la continuazione,
   //    PROIBITO per l'inversione (se la tocca, non e' piu' inversione).
   if(TouchOppositeBand(i))
     {
      gTouchedOpposite=true;
      if(gInvAlive){ gInvAlive=false; cX_invOpp++; Log("inversione invalidata: il prezzo ha toccato la banda opposta."); }
      if(gContAlive)
        {
         cCont_test++;
         if(ModoConsente(PAT_CONT)) CheckEntryContinuazione(i,aref);
         //--- il test obbligatorio e' avvenuto: il setup di continuazione e' consumato
         gContAlive=false;
        }
      ResetPattern("");
      return;
     }

   //--- RIENTRO ALLA MEDIANA (inversione): puo' superarla, mai la banda opposta
   if(gInvAlive && !gReachedMedian && TouchMedian(i))
     {
      gReachedMedian=true; gMedianBar=gPostBars; gWidthAtMedian=w; cInv_mediana++;
      Log("rientro: mediana raggiunta senza toccare la banda opposta.");
     }

   //--- LEONARDO (opzionale): la continuazione muore se, dopo la mediana, il
   //    prezzo torna sulla banda dell'impulso e solo dopo ritesta l'opposta.
   if(InpContNoImpulseBandReturn && gContAlive && gReachedMedian && TouchImpulseBand(i,0.0))
     { gContAlive=false; cX_contRitorno++; Log("continuazione invalidata (regola Leonardo): ritorno sulla banda dell'impulso."); }

   //--- RETEST DELLA BANDA DELL'IMPULSO (inversione)
   if(gInvAlive && gReachedMedian && gPostBars>gMedianBar &&
      TouchImpulseBand(i,InpRetestBufferATR*aref))
     {
      cInv_retest++;
      if(ModoConsente(PAT_INV)) CheckEntryInversione(i,aref);
      gInvAlive=false;                  // il retest e' avvenuto: setup consumato
     }

   if(!gContAlive && !gInvAlive) ResetPattern("");
  }

//==================================================================
//  CONDIZIONI DI ENTRATA
//==================================================================
bool TradingConsentito()
  {
   if(CountPositions()>=InpMaxPositions) return(false);
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return(false);
   if(!SpreadOK()){ Log("spread fuori limite: nessun ingresso."); return(false); }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())){ Log("news rossa in finestra: nessun ingresso."); return(false); }
   return(true);
  }

//--- CONTINUAZIONE: entry al tocco della banda OPPOSTA, nella direzione
//    dell'impulso originario. Bande in fase di chiusura + volatilita' rientrata.
void CheckEntryContinuazione(int i,double atr)
  {
   if(!TradingConsentito()){ cE_contBlocked++; return; }
   //--- [D] la guida si contraddice sulla continuazione: la tabella delle
   //    REGOLE UFFICIALI pretende le bande in chiusura, la sezione C dice
   //    "nella continuazione le bande possono essere ancora gonfie, il
   //    ritracciamento e' il vero filtro". Restano accese ma sono input.
   if(InpContRequireNarrow && !BandeInChiusura(i))
     { cE_contNarrow++; Log("continuazione scartata: bande NON in fase di chiusura."); return; }
   if(InpContRequireStdDown && !StdInCalo(i))
     { cE_contStd++; Log("continuazione scartata: deviazione standard non in calo (bulge non finito)."); return; }
   if(InpUseShadowFilter && gRetrShadowViol>0)
     { cE_contShadow++; Log("continuazione scartata: ombre oltre il limite nel ritracciamento."); return; }
   if(InpUseRangeReduction && !RangeRidotto())
     { cE_contRange++; Log("continuazione scartata: range del ritracciamento non ridotto abbastanza."); return; }

   bool isLong=(gBulgeDir>0);
   if(InpUseReversalCandle && !CandelaDiInversione(i,isLong,atr))
     { cE_contRev++; Log("continuazione scartata: nessuna candela di rigetto sul test (regola opzionale attiva)."); return; }

   string det="";
   double solid=CalcSolidita(true,i,true,det);
   if(InpMinSolidita>0.0 && solid<InpMinSolidita)
     { cE_contSolid++; Log(StringFormat("continuazione scartata: solidita' %.1f%% < %.1f%%. %s",solid,InpMinSolidita,det)); return; }
   cO_cont++;

   Log(StringFormat("CONTINUAZIONE valida (%s). Solidita' %.1f%%. %s",(isLong?"LONG":"SHORT"),solid,det));
   Enter(isLong,PAT_CONT,solid);
  }

//--- INVERSIONE: entry CONTRO l'impulso sul retest della banda dell'impulso,
//    che deve essere piatta o inclinata a favore (3 candele pre-test).
void CheckEntryInversione(int i,double atr)
  {
   if(!TradingConsentito()){ cE_invBlocked++; return; }
   //--- guardia RIDONDANTE per costruzione (chi tocca la banda opposta esce
   //    con gInvAlive=false e non arriva mai qui): resta come rete di
   //    sicurezza esplicita sulla regola assoluta della guida. NON e' lei a
   //    uccidere i setup - il contatore lo dimostra.
   if(gTouchedOpposite){ Log("inversione scartata: banda opposta gia' toccata."); return; }

   bool isLong=(gBulgeDir<0);                     // contro-bulge
   double slope=SlopeBandaTest(i);
   double tol=InpFlatSlopeATR*atr;
   bool bandaOk = isLong ? (slope >= -tol) : (slope <= tol);
   if(!bandaOk)
     { cE_invSlope++; Log("inversione scartata: banda dell'impulso inclinata CONTRO il trade (3 candele pre-test)."); return; }
   if(!BandeInChiusura(i))
     { cE_invNarrow++; Log("inversione scartata: bande non in restringimento."); return; }
   if(!StdInCalo(i))
     { cE_invStd++; Log("inversione scartata: deviazione standard non in calo (bulge non finito)."); return; }
   if(gWidthAtMedian>0.0 && Width(i) > InpReinflateTolPct*gWidthAtMedian)
     { cE_invReinf++; Log("inversione scartata: la banda si e' rigonfiata durante il retest."); return; }
   if(InpUseShadowFilter && gRetrShadowViol>0)
     { cE_invShadow++; Log("inversione scartata: ombre oltre il limite nel rientro."); return; }
   if(InpUseRangeReduction && !RangeRidotto())
     { cE_invRange++; Log("inversione scartata: range del rientro non ridotto abbastanza."); return; }
   if(InpUseReversalCandle && !CandelaDiInversione(i,isLong,atr))
     { cE_invRev++; Log("inversione scartata: nessuna candela di rigetto sul retest (regola opzionale attiva)."); return; }

   string det="";
   double solid=CalcSolidita(false,i,true,det);
   if(InpMinSolidita>0.0 && solid<InpMinSolidita)
     { cE_invSolid++; Log(StringFormat("inversione scartata: solidita' %.1f%% < %.1f%%. %s",solid,InpMinSolidita,det)); return; }
   cO_inv++;

   Log(StringFormat("INVERSIONE valida (%s). Pendenza banda %.6f. Solidita' %.1f%%. %s",
       (isLong?"LONG":"SHORT"),slope,solid,det));
   Enter(isLong,PAT_INV,solid);
  }

bool RangeRidotto()
  {
   if(gRetrBars<1 || gBulgeBars<1) return(false);
   double mr=gRetrRangeSum/gRetrBars;
   double mb=gBulgeRangeSum/gBulgeBars;
   if(mb<=0.0) return(false);
   return(mr <= (1.0-InpRangeReductionPct/100.0)*mb);
  }

//==================================================================
//  SOLIDITA' DEL PATTERN - modello pesato UFFICIALE della checklist
//  25% congestione | 25% bulge | 20% ritracciamento/rientro |
//  15% comportamento delle bande | 10% test | 5% conferme tecniche
//  (nessun peso inventato: sono quelli del documento)
//==================================================================
double CalcSolidita(bool isCont,int i,bool bandaTestOk,string &det)
  {
   //--- 1) CONGESTIONE INIZIALE: 0 oppure 1 (regola della checklist)
   double s1=gCongScore;

   //--- 2) BULGE: se siamo qui i sei criteri obbligatori sono tutti verificati
   double s2=1.0;

   //--- 3) RITRACCIAMENTO / RIENTRO (4 criteri della sezione A)
   int ok3=0;
   if(RangeRidotto())        ok3++;   // range ridotto del 30-50% rispetto al bulge
   ok3++;                             // nessuna candela oltre la soglia (invalidazione assoluta gia' superata)
   if(gRetrShadowViol==0)    ok3++;   // ombre <= 1.5 x corpo
   ok3++;                             // assenza di spike profondi (invalidazione assoluta gia' superata)
   double s3=(double)ok3/4.0;

   //--- 4) COMPORTAMENTO DELLE BANDE (3 criteri)
   int ok4=2;                         // restringimento + nessuna espansione contraria (verificati)
   if(bandaTestOk) ok4++;             // banda del test piatta o a favore
   double s4=(double)ok4/3.0;

   //--- 5) TEST CHIAVE: verificato per costruzione (tocco valido + candela non impulsiva)
   double s5=1.0;

   //--- 6) CONFERME TECNICHE (4 criteri)
   int ok6=0;
   if(StdInCalo(i))                                  ok6++;
   if(i<ArraySize(gStd) && gStd[i]<gStdSma[i])       ok6++;
   if(i+1<ArraySize(gStdSma) && gStdSma[i]<gStdSma[i+1]) ok6++;   // SMA50 che si normalizza
   if(!(InpUseNewsFilter && InNewsBlackout(TimeCurrent()))) ok6++;
   double s6=(double)ok6/4.0;

   double tot=25.0*s1+25.0*s2+20.0*s3+15.0*s4+10.0*s5+5.0*s6;
   string cat = (tot>=85.0?"Ottimo":(tot>=70.0?"Buono":(tot>=55.0?"Medio":"Debole")));
   det=StringFormat("[%s] cong %.0f%% ritr %.0f%% bande %.0f%% conferme %.0f%% -> %s",
                    (isCont?"CONT":"INV"),s1*100.0,s3*100.0,s4*100.0,s6*100.0,cat);
   return(tot);
  }

//==================================================================
//  ESECUZIONE
//==================================================================
void Enter(bool isLong,int pattern,double solid)
  {
   double atr=gAtr[1];
   if(atr<=0.0){ Log("ATR non disponibile: nessun ingresso."); return; }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;

   //--- SL = 3 x ATR (regola fissa della guida)
   double sl = isLong ? entry-InpSL_ATRmult*atr : entry+InpSL_ATRmult*atr;
   sl=NormalizePrice(sl);

   //--- TP: la MEDIANA corrente resta l'obiettivo ufficiale (aggiornata ogni
   //    barra). Nella variante Emiliano (InpTPMode=1) l'ordine sul server
   //    punta alla BANDA OPPOSTA (il runner) e la mediana diventa il livello
   //    del parziale, sorvegliato dal codice.
   double mediana=NormalizePrice(gMid[1]);
   double bandaRunner=NormalizePrice(isLong?gUp[1]:gLo[1]);
   double tp=(InpTPMode==1)?bandaRunner:mediana;

   double minDist=StopsMinDist();
   double risk=isLong?(entry-sl):(sl-entry);
   if(risk<=minDist){ cO_failSL++; Log("SL troppo vicino al prezzo (stops level): nessun ingresso."); return; }

   bool tpOk = isLong ? (mediana > entry+minDist) : (mediana < entry-minDist);
   if(!tpOk){ cO_failTP++; Log("mediana troppo vicina/gia' superata: nessun ingresso."); return; }
   if(InpMinTPatATR>0.0 && MathAbs(mediana-entry) < InpMinTPatATR*atr)
     { cO_failTP++; Log("distanza dalla mediana sotto il minimo richiesto: nessun ingresso."); return; }
   if(InpTPMode==1)
     {
      bool bandaOk = isLong ? (bandaRunner > entry+minDist) : (bandaRunner < entry-minDist);
      if(!bandaOk){ cO_failTP++; Log("banda opposta troppo vicina/gia' superata: nessun ingresso (variante TPMode 1)."); return; }
     }

   double lot=LotByRisk(risk);
   if(lot<=0.0){ cO_failLot++; Log("lotto nullo: nessun ingresso."); return; }

   string cm=InpComment+((pattern==PAT_CONT)?" CONT":" INV")+(isLong?" L":" S");
   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(!ok)
     { cO_failSend++; Log("apertura FALLITA: "+gTrade.ResultRetcodeDescription()); return; }

   gTradesToday++;
   ulong tk=gTrade.ResultOrder();
   PosRegisterBySearch(sl);
   Log(StringFormat("%s %s @ %s SL %s TP(%s) %s lot %.2f solidita' %.1f%% (ordine %s)",
       (pattern==PAT_CONT?"CONTINUAZIONE":"INVERSIONE"),(isLong?"LONG":"SHORT"),
       DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),
       (InpTPMode==1?"banda opposta, parziale sulla mediana":"mediana"),
       DoubleToString(tp,_Digits),lot,solid,IntegerToString((long)tk)));
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE
//  - TP sempre sulla MEDIANA corrente (aggiornato ogni N barre);
//  - se la mediana e' gia' raggiunta si chiude a mercato: la guida
//    dice che il trade si chiude SEMPRE sulla mediana (o in stop);
//  - a +N x ATR: SL a meta' rischio o a pari. MAI allargare lo stop.
//==================================================================
void RefreshTakeProfit()
  {
   if(ArraySize(gMid)<2 || ArraySize(gUp)<2 || ArraySize(gLo)<2) return;
   double mid=NormalizePrice(gMid[1]);
   double minDist=StopsMinDist();
   double tick=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);

      //--- VARIANTE EMILIANO: l'ordine sul server insegue la BANDA OPPOSTA.
      //    Il parziale sulla mediana e' gestito da ManagePartialAtMedian().
      if(InpTPMode==1)
        {
         double banda=NormalizePrice(isLong?gUp[1]:gLo[1]);
         //--- runner: banda opposta gia' raggiunta -> chiusura totale
         if(isLong ? (bid >= banda-minDist) : (ask <= banda+minDist))
           {
            if(gTrade.PositionClose(tk)) Log("chiusura sulla BANDA OPPOSTA (runner, variante TPMode 1).");
            else                         Log("chiusura sulla banda opposta fallita: "+gTrade.ResultRetcodeDescription());
            continue;
           }
         if(MathAbs(tp-banda) < tick) continue;
         if(!gTrade.PositionModify(tk,sl,banda))
            Log("aggiornamento TP (banda opposta) fallito: "+gTrade.ResultRetcodeDescription());
         continue;
        }

      //--- DEFAULT UFFICIALE: obiettivo gia' raggiunto (o a meno del minimo di
      //    distanza) -> si chiude a mercato ("si chiude sempre sulla mediana")
      if(isLong ? (bid >= mid-minDist) : (ask <= mid+minDist))
        {
         if(gTrade.PositionClose(tk)) Log("chiusura sulla MEDIANA (obiettivo raggiunto).");
         else                         Log("chiusura sulla mediana fallita: "+gTrade.ResultRetcodeDescription());
         continue;
        }
      if(MathAbs(tp-mid) < tick) continue;
      if(!gTrade.PositionModify(tk,sl,mid))
         Log("aggiornamento TP fallito: "+gTrade.ResultRetcodeDescription());
     }
  }

//--- VARIANTE EMILIANO (InpTPMode=1), su ogni tick: al tocco della MEDIANA si
//    chiude InpTP1Pct% e si porta lo SL del runner a PARI. Come sull'EA PTE, lo
//    stop in pari NON dipende dalla riuscita del parziale: al lotto minimo la
//    frazione arrotonda a zero e senza questa nota il breakeven salterebbe.
void ManagePartialAtMedian()
  {
   if(InpTPMode!=1) return;
   if(ArraySize(gMid)<2 || ArraySize(gUp)<2 || ArraySize(gLo)<2) return;
   double mid=NormalizePrice(gMid[1]);
   double minDist=StopsMinDist();
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double op =PositionGetDouble(POSITION_PRICE_OPEN);
      double sl =PositionGetDouble(POSITION_SL);
      double vol=PositionGetDouble(POSITION_VOLUME);

      bool slAlPari = isLong ? (sl>0.0 && sl>=op) : (sl>0.0 && sl<=op);
      if(PosGetTP1(tk,slAlPari)) continue;                 // parziale gia' fatto

      bool mediana = isLong ? (bid >= mid-minDist) : (ask <= mid+minDist);
      if(!mediana) continue;

      double cv=NormVol(vol*InpTP1Pct/100.0);
      bool parz=(cv>0.0 && cv<vol && gTrade.PositionClosePartial(tk,cv));

      double be=NormalizePrice(op);
      double banda=NormalizePrice(isLong?gUp[1]:gLo[1]);
      bool bePossibile = isLong ? (be>sl && be<bid-minDist) : ((sl<=0.0||be<sl) && be>ask+minDist);
      if(bePossibile && !gTrade.PositionModify(tk,be,banda))
         Log("stop a pari del runner fallito: "+gTrade.ResultRetcodeDescription());

      PosSetTP1(tk);
      Log(parz ? "TPMode 1: parziale sulla MEDIANA + stop a pari, runner verso la banda opposta."
               : "TPMode 1: mediana raggiunta, stop a pari (parziale impossibile al lotto minimo).");
     }
  }

void ManageRiskReduction()
  {
   if(InpBEatATR<=0.0) return;
   if(ArraySize(gAtr)<2) return;
   double atr=gAtr[1];
   if(atr<=0.0) return;
   double minDist=StopsMinDist();
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double op=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      if(sl<=0.0) continue;

      double avanti = isLong ? (bid-op) : (op-ask);
      if(avanti < InpBEatATR*atr) continue;

      double slInit=PosGetSlInit(tk,sl);
      double target;
      if(InpBEMode==1) target=op;                                   // stop a PARI
      else             target=isLong ? op-0.5*(op-slInit)           // stop a META' rischio
                                     : op+0.5*(slInit-op);
      target=NormalizePrice(target);

      //--- MAI allargare lo stop: si muove solo a favore
      bool megliore = isLong ? (target>sl) : (target<sl);
      if(!megliore) continue;
      //--- rispetto della distanza minima dal prezzo corrente
      if(isLong  && target >= bid-minDist) continue;
      if(!isLong && target <= ask+minDist) continue;

      if(gTrade.PositionModify(tk,target,tp))
         Log(StringFormat("rischio ridotto: SL a %s (%s).",DoubleToString(target,_Digits),
             (InpBEMode==1?"pari":"meta' rischio")));
     }
  }

//==================================================================
//  STATO PER POSIZIONE (SL iniziale)
//==================================================================
void PosRegister(ulong tk,double slInit)
  {
   for(int j=0;j<ArraySize(gPosTicket);j++)
      if(gPosTicket[j]==tk){ gPosSlInit[j]=slInit; return; }
   int n=ArraySize(gPosTicket);
   ArrayResize(gPosTicket,n+1); ArrayResize(gPosSlInit,n+1); ArrayResize(gPosTP1,n+1);
   gPosTicket[n]=tk; gPosSlInit[n]=slInit; gPosTP1[n]=false;
  }

//--- variante InpTPMode=1: il parziale sulla mediana e' gia' stato fatto?
//    Reload-safe: se lo stato in memoria manca (riavvio), lo si deduce dallo
//    SL gia' portato a pari, che nella variante viene messo solo li'.
bool PosGetTP1(ulong tk,bool slAlPari)
  {
   for(int j=0;j<ArraySize(gPosTicket);j++)
      if(gPosTicket[j]==tk) return(gPosTP1[j] || slAlPari);
   return(slAlPari);
  }

void PosSetTP1(ulong tk)
  {
   for(int j=0;j<ArraySize(gPosTicket);j++)
      if(gPosTicket[j]==tk){ gPosTP1[j]=true; return; }
  }

//--- dopo l'invio dell'ordine la posizione non ha lo stesso ticket dell'ordine
//    su tutti i broker: si cerca la posizione aperta di questo magic senza
//    stato registrato e le si assegna lo SL iniziale appena impostato.
void PosRegisterBySearch(double slInit)
  {
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool nota=false;
      for(int j=0;j<ArraySize(gPosTicket);j++) if(gPosTicket[j]==tk) nota=true;
      if(!nota) PosRegister(tk,slInit);
     }
  }

double PosGetSlInit(ulong tk,double fallback)
  {
   for(int j=0;j<ArraySize(gPosTicket);j++)
      if(gPosTicket[j]==tk) return(gPosSlInit[j]);
   //--- reload-safe: dopo un riavvio lo SL iniziale non e' piu' noto e si usa
   //    quello corrente. Approssimazione DICHIARATA: al massimo lo stop viene
   //    stretto una volta in piu', mai allargato.
   PosRegister(tk,fallback);
   return(fallback);
  }

void RegisterExistingPositions()
  {
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      PosRegister(tk,PositionGetDouble(POSITION_SL));
     }
  }

void PosCleanup()
  {
   for(int j=ArraySize(gPosTicket)-1;j>=0;j--)
     {
      if(PositionSelectByTicket(gPosTicket[j])) continue;
      int n=ArraySize(gPosTicket);
      for(int q=j;q<n-1;q++)
        { gPosTicket[q]=gPosTicket[q+1]; gPosSlInit[q]=gPosSlInit[q+1]; gPosTP1[q]=gPosTP1[q+1]; }
      ArrayResize(gPosTicket,n-1); ArrayResize(gPosSlInit,n-1); ArrayResize(gPosTP1,n-1);
     }
  }

//==================================================================
//  UTILITY
//==================================================================
double StopsMinDist()
  {
   double d=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double sp=(double)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)*_Point;
   return(MathMax(d,sp));
  }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0.0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0.0) return(0.0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  Perdita per lotto dal BROKER, non dal tick value nudo (lezione 08/08/2026:
   //  su alcuni simboli il tick value arriva non convertito e il lotto finisce
   //  sempre al minimo). OrderCalcProfit converte correttamente.
   double lossPerLot=0.0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0.0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0.0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0.0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0.0||tsz<=0.0) return(0.0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0.0) return(0.0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0.0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0.0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0.0:v);
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

int CountPositions()
  {
   int n=0;
   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) - standard di famiglia
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

//==================================================================
//  1.01 - FUNNEL DI MORTALITA' (solo Print a fine test).
//  Un singolo run nel tester dice DOVE muore la cascata: quanti bulge
//  vengono tentati, quanti validati, per quale invalidazione muore
//  ogni setup e quanti ingressi ne escono. Nessun impatto sul CSV
//  (il CSV nasce da FrameAdd/OnTesterDeinit, che qui non si toccano).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[BB-FUNNEL] %s %s  pattern=%d  endMode=%d dirMode=%d postAtrRef=%d",
               _Symbol,EnumToString(InpTF),InpPatternMode,InpBulgeEndMode,InpBulgeDirMode,InpPostATRRef);
   PrintFormat("[BB-FUNNEL] FASE 1  tentati=%d | morti in fase: oltre%dcandele=%d bandriding=%d",
               (int)cB_start,InpBulgeMaxBars,(int)cB_maxbars,(int)cB_riding);
   PrintFormat("[BB-FUNNEL] FASE 1  arrivati a validazione=%d | scartati: corti=%d senzaImpulsive=%d "
               "nonUnidirezionali=%d nettoScarso=%d vicinoMediana=%d  ==> BULGE VALIDI=%d",
               (int)cB_end,(int)cB_short,(int)cB_noimp,(int)cB_dir,(int)cB_net,(int)cB_med,(int)cB_valid);
   PrintFormat("[BB-FUNNEL] FASE 2 CONT  morti: candela>%.2fxATR=%d zigzag=%d spike=%d rigonfio=%d "
               "bandriding=%d ritornoBanda=%d",
               InpImpulseATR,(int)cX_contImp,(int)cX_contZig,(int)cX_contSpike,(int)cX_contReinf,
               (int)cX_contRide,(int)cX_contRitorno);
   PrintFormat("[BB-FUNNEL] FASE 2 INV   morti: rientroViolento(%d cand>%.2fxATR)=%d spike=%d rigonfio=%d "
               "bandriding=%d toccoBandaOpposta=%d",
               InpInvViolentBars,InpRientroMaxATR,(int)cX_invViol,(int)cX_invSpike,(int)cX_invReinf,
               (int)cX_invRide,(int)cX_invOpp);
   PrintFormat("[BB-FUNNEL] FASE 2  scaduti(>%d barre)=%d | mediana raggiunta=%d | retest banda impulso=%d | "
               "tocco banda opposta=%d",
               InpPostBulgeMaxBars,(int)cP_expired,(int)cInv_mediana,(int)cInv_retest,(int)cCont_test);
   PrintFormat("[BB-FUNNEL] FASE 3 CONT  scarti: bandeNonChiuse=%d stdNonInCalo=%d ombre=%d range=%d "
               "candelaRigetto=%d solidita=%d bloccati=%d  ==> OK=%d",
               (int)cE_contNarrow,(int)cE_contStd,(int)cE_contShadow,(int)cE_contRange,(int)cE_contRev,
               (int)cE_contSolid,(int)cE_contBlocked,(int)cO_cont);
   PrintFormat("[BB-FUNNEL] FASE 3 INV   scarti: pendenzaContro=%d bandeNonChiuse=%d stdNonInCalo=%d "
               "rigonfioRetest=%d ombre=%d range=%d candelaRigetto=%d solidita=%d bloccati=%d  ==> OK=%d",
               (int)cE_invSlope,(int)cE_invNarrow,(int)cE_invStd,(int)cE_invReinf,(int)cE_invShadow,
               (int)cE_invRange,(int)cE_invRev,(int)cE_invSolid,(int)cE_invBlocked,(int)cO_inv);
   PrintFormat("[BB-FUNNEL] ORDINI  segnali=%d | scartati in Enter: tp=%d sl=%d lotto=%d invioFallito=%d | "
               "trade eseguiti=%d",
               (int)(cO_cont+cO_inv),(int)cO_failTP,(int)cO_failSL,(int)cO_failLot,(int)cO_failSend,
               (int)TesterStatistics(STAT_TRADES));
  }

double OnTester()
  {
   PrintFunnel();
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
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
