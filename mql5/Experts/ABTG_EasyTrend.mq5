//+------------------------------------------------------------------+
//|                                            ABTG_EasyTrend.mq5    |
//|                                                                  |
//|  EA di LABORATORIO "EASY TREND" (Leonardo Fasciano, Master ABTG) |
//|  TUTTO-IN-UNO (metti in MQL5\Experts e compila con F7: niente    |
//|  cartelle, niente include oltre a Trade.mqh, nessun indicatore   |
//|  custom da installare).                                          |
//|                                                                  |
//|  FONTE NORMATIVA                                                 |
//|   1. backtest_pipeline/prove/EASY_TREND_TESI.md (VINCOLANTE:     |
//|      tesi scritta PRIMA di qualunque numero, 14/08/2026, dalle   |
//|      trascrizioni dei video 11-17 del capitolo).                 |
//|   2. Gli indicatori NOMINATI dalla fonte: "Linear Regression     |
//|      Candles" (UGUR-VU) e "CCI Divergences" (TISTA), entrambi    |
//|      TradingView. NON sono disponibili qui: la loro meccanica e' |
//|      RICOSTRUITA internamente e i parametri interni, che i video |
//|      non citano MAI, sono ESPOSTI COME INPUT.                    |
//|                                                                  |
//|  ATTENZIONE - COSA E' FONTE E COSA E' NOSTRO                     |
//|   [FONTE]  = detto esplicitamente nei video (tesi, sezioni       |
//|              "checklist" e "ingresso/stop/target");              |
//|   [SCELTA NOSTRA] = la fonte non quantifica: numero di partenza  |
//|              esposto come input, DA MISURARE, non verita' del    |
//|              corso.                                              |
//|   Ogni input qui sotto porta la sua etichetta. Chi legge il      |
//|   codice deve poter distinguere in un secondo la regola del      |
//|   corso dal nostro riempitivo.                                   |
//|                                                                  |
//|  IL MECCANISMO (ipotesi della tesi)                              |
//|   Inversione su DIVERGENZA: la divergenza CCI dichiara che il    |
//|   movimento e' esaurito, ma da sola non basta (puo' durare a     |
//|   lungo). La conferma tecnica e' la PRIMA candela Linear         |
//|   Regression che taglia il "plot" (la media dell'indicatore) nel |
//|   verso del segnale. Ingresso alla CHIUSURA di quella candela,   |
//|   stop oltre l'estremo della figura, target a rischio-rendimento |
//|   1:1.                                                           |
//|                                                                  |
//|  COSA FA (mappa REGOLA -> CODICE)                                |
//|   AggiornaLinReg  (CANDELE LINEAR REGRESSION, ricostruite)       |
//|     - per ogni barra CHIUSA: linO/linH/linL/linC = valore della  |
//|       retta di regressione lineare di open/high/low/close su     |
//|       InpLinRegLen barre, valutata nel punto corrente (identico  |
//|       a ta.linreg(src,len,0) del Pine);                          |
//|     - COLORE della candela linreg: verde se linC > linO, rossa   |
//|       se linC < linO (0 = doji, non e' in tinta con nessuno);    |
//|     - PLOT = media (SMA o EMA) di linC su InpPlotLen barre.      |
//|   RilevaPivot  (DIVERGENZE CCI, ricostruite)                     |
//|     - pivot frattali InpPivotL a sinistra / InpPivotR a destra;  |
//|     - un pivot e' CONFERMATO solo dopo InpPivotR barre CHIUSE:   |
//|       zero repaint, e il ritardo se lo prende l'EA (nei video    |
//|       l'indicatore di TradingView ridipinge e la divergenza      |
//|       "appare" subito: qui NON puo' succedere);                  |
//|     - BULL = due pivot-minimi consecutivi con prezzo Lower Low e |
//|       CCI Higher Low; BEAR = prezzo Higher High e CCI Lower      |
//|       High; distanza massima fra i due pivot InpMaxPivotDist.    |
//|   ValutaSegnale  (CHECKLIST [FONTE], nell'ordine dei video)      |
//|     a. divergenza attiva, non consumata e non invalidata;        |
//|     b. PRIMA candela linreg che taglia il plot nel verso giusto  |
//|        (o che APRE gia' oltre);                                  |
//|     c. la candela del segnale sta in [InpHourStart,InpHourEnd];  |
//|        se e' FUORI ORARIO la divergenza MUORE li' [FONTE, v.16]: |
//|        non si aspetta la candela buona, si aspetta una           |
//|        divergenza nuova;                                         |
//|     d. colore linreg in tinta con la divergenza [FONTE, v.16];   |
//|     e. le InpPrevBars candele precedenti tutte dal lato opposto  |
//|        del plot (anti-lateralita').                              |
//|   TryEnter  (INGRESSO [FONTE], spread e vincoli del broker)      |
//|     - livello d'ingresso = CHIUSURA della candela del segnale;   |
//|     - se il prezzo e' gia' scappato VERSO IL TP -> ordine LIMIT  |
//|       su quel livello, valido InpEntryWindowBars barre;          |
//|     - se il prezzo e' piu' conveniente (verso lo SL) -> MERCATO; |
//|     - filtro spread con riprova entro InpEntryWindowBars barre.  |
//|   Stop e target ([FONTE])                                        |
//|     - SL = estremo (minimo per long / massimo per short) fra la  |
//|       barra d'INIZIO DIVERGENZA (primo pivot della coppia) e la  |
//|       candela del segnale inclusa, +/- InpSLBufferPts points     |
//|       ("+3 pips" della fonte);                                   |
//|     - TP = InpTP_R x (distanza ingresso->SL) dal prezzo          |
//|       d'ingresso (RR 1:1 [FONTE]);                               |
//|     - SL e TP sono ordini VERI sul server: niente stealth.       |
//|   Gestione: UNA sola posizione/ordine alla volta per magic.      |
//|     NESSUN trailing, NESSUNA parziale, NESSUN time-stop: la      |
//|     fonte non li prevede e non li inventiamo.                    |
//|                                                                  |
//|  RELOAD-SAFE: all'avvio lo stato (candele linreg, plot, pivot,   |
//|  divergenze) viene RICOSTRUITO scorrendo le ultime               |
//|  InpWarmupBars barre CHIUSE. I segnali trovati nel warmup NON    |
//|  generano ordini (non li abbiamo osservati dal vivo) ma          |
//|  CONSUMANO le divergenze, altrimenti l'EA riaperto entrerebbe su |
//|  un segnale gia' vecchio. In piu' si controlla lo storico dei    |
//|  deal del magic prima di ogni ingresso e si adotta l'eventuale   |
//|  pendente orfano rimasto da prima del riavvio.                   |
//|                                                                  |
//|  DIAGNOSTICA: funnel [EZ-FUNNEL], riga giornaliera (se           |
//|  InpVerbose) piu' il totale stampato da OnTester. Serve alla     |
//|  CAL: quante divergenze nascono, quante muoiono per orario,      |
//|  quante per colore, quante per le 3 candele, quanti ordini       |
//|  restano. Se l'EA resta muto il funnel dice SUBITO dove muore,   |
//|  senza autopsie.                                                 |
//|                                                                  |
//|  AVVERTENZE DELLA TESI (da leggere PRIMA dei numeri)             |
//|   - RR 1:1 con win rate DICHIARATO 70%: se il win rate reale e'  |
//|     ~50% il motore muore di costi. E' IL numero da guardare.     |
//|   - I numeri della fonte (198% da gen 2022, DD 8%) sono un CLAIM |
//|     DA FALSIFICARE, non un'aspettativa (edgeful docet).          |
//|   - Il RITARDO DEI PIVOT (InpPivotR barre) e' strutturale: nei   |
//|     video la divergenza si vede prima perche' quell'indicatore   |
//|     ridipinge. Se il motore muore per il ritardo, va scritto nel |
//|     referto invece di truccare i pivot.                          |
//|   - L'OHLC non vede lo spread: OHLC SOLO per frequenza e         |
//|     screening, i VERDETTI SOLO a tick reali.                     |
//|                                                                  |
//|  DEMO. Nessuna garanzia. Non compilato ne' testato dall'autore   |
//|  del codice: compilare in MetaEditor e validare nel tester.      |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.00 - Prima stesura, dalla tesi EASY_TREND_TESI.md.             |
//|    Nessun numero misurato ancora: tutti i default [SCELTA NOSTRA] |
//|    sono valori di partenza ragionevoli, non tarature.             |
//|      - InpLinRegLen 11 / InpPlotLen 11 / InpPlotMode SMA = i      |
//|        default pubblici del Pine di Ugur. I video NON citano mai  |
//|        i parametri: se Claudio ritrova il Pine vero, la           |
//|        calibrazione e' un cambio di NUMERI, non di codice.        |
//|      - InpCciPeriod 20 = CCI standard da manuale.                 |
//|      - InpPivotL/R 5 = frattale classico. ATTENZIONE: piu' e'     |
//|        grande InpPivotR, piu' tardi arriva la divergenza.         |
//|      - InpPivotSource 2 (ENTRAMBI) = lettura LETTERALE della      |
//|        consegna: il pivot deve essere pivot sul PREZZO E sul CCI  |
//|        sulla stessa barra. E' il modo piu' severo: se il funnel   |
//|        della CAL mostra pochissime divergenze, il primo bottone   |
//|        da girare e' questo (modo 0 = pivot sul CCI, che e' come   |
//|        lavora davvero il Pine di TISTA; modo 1 = sul prezzo).     |
//|        Il funnel conta i pivot dei TRE modi proprio per far       |
//|        vedere quanto costa la severita'.                          |
//|      - InpMaxPivotDist 60 barre = tetto alla distanza fra i due   |
//|        pivot della coppia: oltre, i due minimi non appartengono   |
//|        piu' alla stessa figura.                                   |
//|      - InpHourStart 8 / InpHourEnd 18 = fascia oraria LETTERALE   |
//|        della fonte, in ORA SERVER. Il fuso e' [INCERTO] nella     |
//|        tesi: su BCM (server 1 ora indietro sull'Italia) se la     |
//|        fonte intendeva ora italiana la fascia giusta e' 7-17.     |
//|        DA RIMAPPARE IN CALIBRAZIONE.                              |
//|      - InpSLBufferPts 30 points = i "3 pips" della fonte su       |
//|        simbolo a 5 decimali.                                      |
//|      - InpTP_R 1.0 = RR 1:1 [FONTE].                              |
//|      - InpRiskPercent 1.0 = standard di famiglia (il corso dice   |
//|        2%: si spazzola dopo, non si parte col rischio alto).      |
//|      - InpMaxSpreadPts 300 = tetto di sicurezza gia' ACCESO       |
//|        (questa strategia entra su chiusura di candela H1, dove    |
//|        gli allargamenti di fine ora sono la norma).               |
//|      - InpWarmupBars 500 = barre chiuse rilette all'avvio.        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // [FONTE] TF di lavoro: EURUSD H1 e' il banco della strategia

input group "=== Candele Linear Regression (parametri [INCERTO] nella fonte) ==="
input int    InpLinRegLen      = 11;    // SCELTA NOSTRA: barre della regressione lineare (default pubblico del Pine di Ugur)
input int    InpPlotMode       = 0;     // SCELTA NOSTRA: media del plot. 0 = SMA, 1 = EMA
input int    InpPlotLen        = 11;    // SCELTA NOSTRA: periodo della media del plot (calcolata sul close linreg)

input group "=== Divergenze CCI (parametri [INCERTO] nella fonte) ==="
input int    InpCciPeriod      = 20;    // SCELTA NOSTRA: periodo del CCI (standard da manuale)
input int    InpPivotL         = 5;     // SCELTA NOSTRA: barre a SINISTRA del pivot frattale
input int    InpPivotR         = 5;     // SCELTA NOSTRA: barre a DESTRA del pivot (= ritardo di conferma, ZERO repaint)
input int    InpPivotSource    = 2;     // SCELTA NOSTRA: dove si cercano i pivot. 0 = solo CCI (come il Pine di TISTA), 1 = solo PREZZO, 2 = ENTRAMBI sulla stessa barra (lettura letterale della consegna, il piu' severo)
input int    InpMaxPivotDist   = 60;    // SCELTA NOSTRA: distanza massima in barre fra i due pivot della coppia
input int    InpDivMaxBars     = 0;     // SCELTA NOSTRA: vita massima di una divergenza in barre. 0 = ILLIMITATA (comportamento della fonte: si aspetta la candela che taglia, quanto serve)
input bool   InpDivDieOnFail   = false; // SCELTA NOSTRA: la divergenza muore anche quando la candela che taglia fallisce colore/3-candele? false = resta viva e si riprova alla prossima rottura del plot. Il default e' false perche' la fonte dichiara la morte SOLO per il fuori orario: se valesse sempre, non avrebbe avuto bisogno di dirlo

input group "=== Checklist del segnale ([FONTE]) ==="
input int    InpHourStart      = 8;     // [FONTE] inizio fascia oraria della candela del segnale, ORA SERVER (fuso [INCERTO]: da rimappare in calibrazione)
input int    InpHourEnd        = 18;    // [FONTE] fine fascia oraria, ORA SERVER, estremo INCLUSO
input int    InpPrevBars       = 3;     // [FONTE] candele precedenti al segnale che devono stare dal lato OPPOSTO del plot

input group "=== Ingresso ([FONTE] il livello, SCELTA NOSTRA la finestra) ==="
input int    InpEntryWindowBars= 3;     // SCELTA NOSTRA (convenzione di famiglia): barre di InpTF di validita' del LIMIT e di riprova sullo spread
input bool   InpMarketIfTooClose = true;// SCELTA NOSTRA: se il livello del LIMIT e' piu' vicino della distanza minima del broker, si entra a MERCATO invece di perdere il segnale

input group "=== Stop loss e take profit ([FONTE]) ==="
input int    InpSLBufferPts    = 30;    // [FONTE] "+3 pips" oltre l'estremo della figura, qui in POINTS (30 = 3 pips su 5 decimali)
input double InpTP_R           = 1.0;   // [FONTE] rischio-rendimento 1:1

input group "=== Ricostruzione dello stato all'avvio ==="
input int    InpWarmupBars     = 500;   // barre CHIUSE rilette all'avvio (i segnali del warmup NON generano ordini ma consumano le divergenze)

input group "=== Lati (LATI SEPARATI OBBLIGATORI, convenzione di famiglia) ==="
input bool   InpAllowLong      = true;  // abilita gli ingressi LONG (divergenze bull)
input bool   InpAllowShort     = true;  // abilita gli ingressi SHORT (divergenze bear)

input group "=== Spread ==="
input int    InpMaxSpreadPts   = 300;   // spread massimo in POINTS all'ingresso. 0 = filtro spento

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;   // Rischio % per operazione (sulla distanza di stop)

input group "=== Generali ==="
input long   InpMagic          = 772401;    // magic number
input string InpComment        = "EZ TREND";// commento ordini
input bool   InpVerbose        = true;      // log estesi (compresa la riga giornaliera del funnel)

//==================================================================
//  STATO
//==================================================================
int      hCci=INVALID_HANDLE;

datetime gLastBar=0;          // ora della barra InpTF in formazione, per il rilevamento della nuova barra
datetime gLastProcessed=0;    // ora dell'ultima barra CHIUSA gia' passata dentro ProcessBar
bool     gWarmup=false;       // true durante la ricostruzione all'avvio: nessun ordine

//--- STORIA DELLE CANDELE LINREG (buffer circolare sulle barre CHIUSE).
//    Serve perche' il plot (media di linC) e la regola delle
//    InpPrevBars candele precedenti hanno bisogno dei valori LINREG
//    delle barre passate, che non sono un buffer di indicatore ma una
//    nostra ricostruzione. Le barre entrano SEMPRE in ordine, una alla
//    volta: la contiguita' e' verificata a ogni inserimento.
#define EZ_HIST 512
datetime gHT[EZ_HIST];
double   gHLinO[EZ_HIST], gHLinH[EZ_HIST], gHLinL[EZ_HIST], gHLinC[EZ_HIST], gHPlot[EZ_HIST];
int      gHCol[EZ_HIST];      // +1 verde (linC>linO), -1 rossa (linC<linO), 0 doji
bool     gHPlotOk[EZ_HIST];   // il plot di quella barra e' calcolabile? (serve lo storico della media)
long     gHN=0;               // barre inserite in totale (contatore assoluto, mai azzerato se non dal warmup)
long     gSeqCount=0;         // barre CONTIGUE inserite dall'ultimo salto: sotto InpPlotLen il plot non esiste

//--- stato della media del plot
double   gEmaVal=0.0;         // valore corrente dell'EMA (InpPlotMode = 1)
double   gSeedSum=0.0;        // somma di seed per l'EMA (prime InpPlotLen barre)

//--- PIVOT CONFERMATI (ultimi due per lato). Un pivot entra qui solo
//    dopo InpPivotR barre chiuse alla sua destra: e' il prezzo del
//    "niente repaint".
bool     gLowHas=false;   datetime gLowT=0;   double gLowP=0.0, gLowC=0.0;   // ultimo pivot-minimo confermato
bool     gHighHas=false;  datetime gHighT=0;  double gHighP=0.0, gHighC=0.0; // ultimo pivot-massimo confermato

//--- DIVERGENZE ATTIVE (una per verso: la fonte dice "bull o bear")
bool     gDivBull=false;  datetime gDivBullStart=0;  datetime gDivBullDetect=0;
bool     gDivBear=false;  datetime gDivBearStart=0;  datetime gDivBearDetect=0;

//--- SEGNALE ARMATO (checklist superata, in attesa di uno spread
//    accettabile: stessa meccanica di riprova degli altri EA di famiglia)
bool     gSigArmed=false;
int      gSigDir=0;           // +1 = LONG, -1 = SHORT
double   gSigLevel=0.0;       // CHIUSURA della candela del segnale = livello d'ingresso [FONTE]
double   gSigSL=0.0;          // stop gia' calcolato sull'estremo della figura + buffer
datetime gSigBarTime=0;       // ora della candela del segnale
int      gSigBars=0;          // barre trascorse nella finestra di riprova (la barra del segnale vale 1)

//--- PENDENTE VIVO (ordine LIMIT sul livello di chiusura)
ulong    gPendTicket=0;
int      gPendBars=0;         // barre di InpTF trascorse dal piazzamento
bool     gJustFilled=false;   // riempimento segnalato da OnTradeTransaction

//--- CONTATORI DEL FUNNEL [EZ-FUNNEL] (solo diagnostica, nessun impatto
//    sul CSV, che nasce da FrameAdd/OnTesterDeinit)
long cW_bars=0, cB_bars=0, cF_data=0;
long cPv_low=0,      cPv_high=0;        // pivot confermati SECONDO InpPivotSource
long cPv_lowPrice=0, cPv_highPrice=0;   // pivot che sarebbero passati col solo PREZZO
long cPv_lowCci=0,   cPv_highCci=0;     // pivot che sarebbero passati col solo CCI
long cD_bull=0, cD_bear=0, cD_dist=0, cD_repl=0, cD_exp=0;
long cX_cross=0;
long cInv_hour=0, cF_color=0, cF_prev=0;
long cS_long=0, cS_short=0;
long cF_side=0, cF_busy=0, cF_late=0;
long cO_spread=0, cO_failLevel=0, cO_failTp=0, cO_failLot=0, cO_failSend=0;
long cO_market=0, cO_limit=0;
long cP_filled=0, cP_expired=0;
long cI_long=0, cI_short=0;
long cE_tp=0, cE_sl=0, cE_other=0;

//--- contatori GIORNALIERI del funnel (riga stampata al cambio giorno)
int  gFunnelDay=-1;
long dD_bull=0, dD_bear=0, dInv_hour=0, dS_sig=0, dO_placed=0;

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[EZ] ", m); }

string PlotModeName(int m){ return(m==1 ? "EMA" : "SMA"); }

string PivotSourceName(int m)
  {
   if(m==0) return("CCI");
   if(m==1) return("PREZZO");
   return("PREZZO+CCI");
  }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   //--- validazione degli input: meglio un INIT_FAILED che un EA che
   //    opera di nascosto con parametri fuori dominio.
   if(PeriodSeconds(InpTF)<=0)
     { Print("ERRORE: InpTF non valido."); return(INIT_FAILED); }
   if(InpLinRegLen<2)
     { Print("ERRORE: InpLinRegLen deve essere >= 2 (con 1 sola barra la retta non esiste)."); return(INIT_FAILED); }
   if(InpPlotMode<0 || InpPlotMode>1)
     { Print("ERRORE: InpPlotMode deve essere 0 (SMA) o 1 (EMA)."); return(INIT_FAILED); }
   if(InpPlotLen<1 || InpPlotLen>400)
     { Print("ERRORE: InpPlotLen deve stare fra 1 e 400 (limite del buffer di storia)."); return(INIT_FAILED); }
   if(InpCciPeriod<2)
     { Print("ERRORE: InpCciPeriod deve essere >= 2."); return(INIT_FAILED); }
   if(InpPivotL<1 || InpPivotR<1)
     { Print("ERRORE: InpPivotL e InpPivotR devono essere >= 1."); return(INIT_FAILED); }
   if(InpPivotL>100 || InpPivotR>100)
     { Print("ERRORE: InpPivotL e InpPivotR oltre 100 barre non hanno senso operativo."); return(INIT_FAILED); }
   if(InpPivotSource<0 || InpPivotSource>2)
     { Print("ERRORE: InpPivotSource deve essere 0 (CCI), 1 (PREZZO) o 2 (ENTRAMBI)."); return(INIT_FAILED); }
   if(InpMaxPivotDist<1)
     { Print("ERRORE: InpMaxPivotDist deve essere >= 1."); return(INIT_FAILED); }
   if(InpDivMaxBars<0)
     { Print("ERRORE: InpDivMaxBars deve essere >= 0 (0 = vita illimitata)."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpHourStart>InpHourEnd)
     { Print("ERRORE: InpHourStart deve essere <= InpHourEnd (fascia oraria non a cavallo della mezzanotte)."); return(INIT_FAILED); }
   if(InpPrevBars<0 || InpPrevBars>100)
     { Print("ERRORE: InpPrevBars deve stare fra 0 e 100 (0 = regola delle candele precedenti SPENTA)."); return(INIT_FAILED); }
   if(InpEntryWindowBars<1)
     { Print("ERRORE: InpEntryWindowBars deve essere >= 1 (1 = solo la barra del segnale)."); return(INIT_FAILED); }
   if(InpSLBufferPts<0)
     { Print("ERRORE: InpSLBufferPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpTP_R<=0.0)
     { Print("ERRORE: InpTP_R deve essere > 0."); return(INIT_FAILED); }
   if(InpWarmupBars<0)
     { Print("ERRORE: InpWarmupBars deve essere >= 0."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati disabilitati: l'EA non avrebbe nulla da fare."); return(INIT_FAILED); }
   if(InpMaxSpreadPts<0)
     { Print("ERRORE: InpMaxSpreadPts deve essere >= 0 (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0.0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   //--- il buffer di storia deve contenere il plot e le candele precedenti
   if(InpPlotLen+InpPrevBars+2 >= EZ_HIST)
     { Print("ERRORE: InpPlotLen + InpPrevBars troppo grandi per il buffer di storia."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- CCI standard sul TF di lavoro. La fonte nomina un indicatore di
   //    divergenze CCI ma non ne dichiara il periodo: 20 e' lo standard.
   hCci = iCCI(_Symbol,InpTF,InpCciPeriod,PRICE_TYPICAL);
   if(hCci==INVALID_HANDLE)
     { Print("ERRORE: creazione handle CCI su InpTF."); return(INIT_FAILED); }

   //--- RELOAD-SAFE: lo stato si RICOSTRUISCE dalle barre chiuse. Senza
   //    questo, dopo un riavvio l'EA resterebbe cieco finche' non nasce
   //    una divergenza nuova (decine di barre).
   RicostruisciStato();

   //--- adozione dell'eventuale pendente orfano del nostro magic: dopo un
   //    riavvio un LIMIT rimasto sul server non ha piu' nessuno che lo
   //    scade. Lo riprendiamo in carico facendo ripartire la finestra
   //    (SCELTA NOSTRA: meglio una finestra un po' piu' lunga che un
   //    ordine dimenticato sul book).
   gPendTicket=0; gPendBars=0;
   for(int k=OrdersTotal()-1;k>=0;k--)
     {
      ulong tk=OrderGetTicket(k);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gPendTicket=tk; gPendBars=0;
      Log(StringFormat("pendente orfano %s adottato all'avvio: la finestra di validita' riparte da adesso.",
          IntegerToString((long)tk)));
      break;
     }

   gSigArmed=false; gSigDir=0; gSigBars=0;
   gLastBar=iTime(_Symbol,InpTF,0);

   Log(StringFormat("avviato su %s %s. LinReg %d, plot %s(%d). CCI(%d), pivot %d/%d su %s, distanza max %d barre. "
                    "Orario %02d-%02d (server), %d candele precedenti. SL estremo figura +%d points, TP %.2f R. "
                    "Finestra %d barre. Lati: %s%s. Spread max %s points. Rischio %.2f%%. Warmup %d barre.",
       _Symbol,EnumToString(InpTF),InpLinRegLen,PlotModeName(InpPlotMode),InpPlotLen,
       InpCciPeriod,InpPivotL,InpPivotR,PivotSourceName(InpPivotSource),InpMaxPivotDist,
       InpHourStart,InpHourEnd,InpPrevBars,InpSLBufferPts,InpTP_R,InpEntryWindowBars,
       (InpAllowLong?"LONG ":""),(InpAllowShort?"SHORT":""),
       (InpMaxSpreadPts>0?IntegerToString(InpMaxSpreadPts):"spento"),
       InpRiskPercent,InpWarmupBars));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hCci!=INVALID_HANDLE){ IndicatorRelease(hCci); hCci=INVALID_HANDLE; }
  }

//==================================================================
//  RICOSTRUZIONE DELLO STATO ALL'AVVIO
//  Scorre le ultime InpWarmupBars barre CHIUSE (shift 1 = ultima
//  chiusa) senza mai leggere barre inesistenti. La barra in
//  formazione (shift 0) NON entra: tutta la strategia e' definita su
//  chiusure.
//  I segnali trovati qui NON aprono ordini ma CONSUMANO le
//  divergenze: e' la differenza fra un riavvio innocuo e un EA che
//  riparte entrando su un setup di tre giorni fa.
//==================================================================
void RicostruisciStato()
  {
   gHN=0; gSeqCount=0; gEmaVal=0.0; gSeedSum=0.0;
   gLowHas=false; gHighHas=false;
   gDivBull=false; gDivBear=false;
   gLastProcessed=0;

   int disponibili=Bars(_Symbol,InpTF);
   //--- margine tecnico: la regressione, la media del plot e il frattale
   //    hanno bisogno di barre PRIMA della prima barra del warmup.
   int margine=InpLinRegLen+InpPlotLen+InpPivotL+InpPivotR+InpPrevBars+InpCciPeriod+10;
   if(disponibili<margine+5)
     { Log("storico troppo corto per la ricostruzione: lo stato si costruira' dal vivo."); return; }

   int da=InpWarmupBars;
   if(da>disponibili-margine) da=disponibili-margine;
   if(da<1) da=1;

   gWarmup=true;
   for(int s=da;s>=1;s--)
     {
      cW_bars++;
      ProcessBar(s);
     }
   gWarmup=false;

   gLastProcessed=iTime(_Symbol,InpTF,1);

   Log(StringFormat("stato ricostruito su %d barre chiuse: pivot minimi=%d massimi=%d, divergenze bull=%d bear=%d. "
                    "Divergenze ancora attive: bull %s, bear %s.",
       da,(int)cPv_low,(int)cPv_high,(int)cD_bull,(int)cD_bear,
       (gDivBull?"SI":"no"),(gDivBear?"SI":"no")));
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del
   //    giorno. Sta QUI e non dopo il filtro della nuova barra: su H1 la
   //    caduta peggiore di giornata succede in mezzo alla candela.
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

   //--- TUTTA la logica lavora su barre CHIUSE di InpTF: candele linreg,
   //    plot, pivot e checklist sono definiti su chiusure, non sui tick.
   datetime t=iTime(_Symbol,InpTF,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   OnNewBar(t);
  }

void OnNewBar(datetime tNuova)
  {
   //--- riga giornaliera del funnel (serve alla CAL: si vede giorno per
   //    giorno se le divergenze nascono e dove muoiono)
   StampaFunnelGiornaliero(tNuova);

   //--- si annota QUALE segnale era gia' armato prima di toccare lo stato:
   //    solo per quello vale la riprova sullo spread (un segnale nuovo
   //    riparte con la sua finestra, non con quella vecchia).
   datetime sigPrima = (gSigArmed ? gSigBarTime : 0);

   //--- 1) il pendente si gestisce PER PRIMO: se scade adesso, il posto si
   //       libera per l'eventuale segnale di questa stessa barra.
   ManagePending();

   //--- 2) stato + checklist sulle barre chiuse nuove (puo' armare un
   //       segnale e provare subito l'ingresso).
   ProcessNuoveBarre();

   //--- 3) segnale VECCHIO ancora armato (aspettava uno spread
   //       accettabile): si consuma una barra della finestra e si riprova.
   if(gSigArmed && sigPrima>0 && gSigBarTime==sigPrima)
     {
      gSigBars++;
      TryEnter();
     }
  }

//==================================================================
//  AVANZAMENTO SULLE BARRE CHIUSE NUOVE
//  Normalmente e' una barra sola (shift 1). Il recupero di piu' barre
//  serve se l'EA e' rimasto senza tick per un pezzo: lo stato non
//  deve MAI saltare barre, altrimenti candele linreg, plot e pivot
//  diventano un'altra cosa.
//==================================================================
void ProcessNuoveBarre()
  {
   datetime tUltima=iTime(_Symbol,InpTF,1);
   if(tUltima<=0) return;

   int da=1;
   if(gLastProcessed>0)
     {
      int sh=iBarShift(_Symbol,InpTF,gLastProcessed,false);
      if(sh==0)  return;          // gia' allineati (o storico incoerente): niente da fare
      if(sh>0)   da=sh-1;
      if(da<1)   return;          // nessuna barra chiusa nuova
     }

   //--- tetto di sicurezza: dopo una lunga assenza non si rilegge la storia
   //    intera a ogni barra (e comunque il warmup ha gia' fatto il grosso).
   int tetto=InpWarmupBars; if(tetto<50) tetto=50;
   if(da>tetto) da=tetto;

   for(int s=da;s>=1;s--)
     {
      cB_bars++;
      ProcessBar(s);
     }

   gLastProcessed=tUltima;
  }

//==================================================================
//  UNA BARRA CHIUSA: ordine dei passi
//   1) candela linreg + plot (la nostra ricostruzione dell'indicatore);
//   2) conferma pivot e nascita di eventuali divergenze;
//   3) checklist del segnale.
//  Il passo 2 sta PRIMA del 3 di proposito: una divergenza confermata
//  su questa barra puo' gia' essere valutata su questa stessa barra,
//  perche' tutti i dati usati sono di barre CHIUSE (nessun repaint).
//  SCELTA NOSTRA dichiarata: la fonte non dice se la candela della
//  conferma possa essere anche la candela del segnale.
//==================================================================
void ProcessBar(const int s)
  {
   if(!AggiornaLinReg(s)){ cF_data++; return; }
   RilevaPivot(s);
   ScadenzaDivergenze(s);
   ValutaSegnale(s);
  }

//==================================================================
//  1) CANDELA LINEAR REGRESSION + PLOT
//  linO/linH/linL/linC = retta di regressione lineare della rispettiva
//  serie su InpLinRegLen barre, VALUTATA NEL PUNTO CORRENTE (identico
//  a ta.linreg(src,len,0) del Pine).
//  Le regole usano linC (contro il plot) e il COLORE (linC vs linO);
//  linH e linL si calcolano lo stesso perche' fanno parte della
//  candela dell'indicatore e finiscono nel log diagnostico del
//  segnale: servono a confrontare a occhio il grafico dell'EA con
//  quello di TradingView in fase di calibrazione.
//==================================================================
bool AggiornaLinReg(const int s)
  {
   double lo=0.0,lh=0.0,ll=0.0,lc=0.0;
   if(!CalcLinRegBar(s,lo,lh,ll,lc)) return(false);

   datetime t=iTime(_Symbol,InpTF,s);
   if(t<=0) return(false);

   //--- contiguita': la barra nuova deve essere quella subito dopo
   //    l'ultima inserita. Se non lo e' (riavvio, buco di storico, tetto
   //    di recupero) la sequenza riparte e il plot torna "non calcolabile"
   //    finche' non ci sono di nuovo InpPlotLen barre in fila.
   bool contigua=false;
   if(gHN>0)
     {
      int idxPrev=(int)((gHN-1)%EZ_HIST);
      datetime tPrev=iTime(_Symbol,InpTF,s+1);
      if(tPrev>0 && gHT[idxPrev]==tPrev) contigua=true;
     }
   if(!contigua){ gSeqCount=0; gSeedSum=0.0; gEmaVal=0.0; }

   int idx=(int)(gHN%EZ_HIST);
   gHT[idx]=t; gHLinO[idx]=lo; gHLinH[idx]=lh; gHLinL[idx]=ll; gHLinC[idx]=lc;
   gHCol[idx] = (lc>lo ? +1 : (lc<lo ? -1 : 0));
   gHN++;
   gSeqCount++;

   //--- PLOT: media di linC. SMA = media delle ultime InpPlotLen; EMA =
   //    ricorsiva, innescata dalla SMA delle prime InpPlotLen (il seed e'
   //    una SCELTA NOSTRA: il Pine parte dal primo valore disponibile del
   //    grafico, che qui non esiste. Con InpWarmupBars 500 la memoria del
   //    seed e' esaurita da un pezzo quando si comincia a operare).
   bool plotOk=false;
   double plot=0.0;

   if(InpPlotMode==0)
     {
      if(gSeqCount>=(long)InpPlotLen)
        {
         double sum=0.0; bool ok=true;
         for(int k=0;k<InpPlotLen;k++)
           {
            double v=0.0;
            if(!HistLinC(k,v)){ ok=false; break; }
            sum+=v;
           }
         if(ok){ plot=sum/(double)InpPlotLen; plotOk=true; }
        }
     }
   else
     {
      if(gSeqCount<(long)InpPlotLen)
        {
         gSeedSum+=lc;                       // accumulo del seed, plot ancora inesistente
        }
      else if(gSeqCount==(long)InpPlotLen)
        {
         gSeedSum+=lc;
         gEmaVal=gSeedSum/(double)InpPlotLen;
         plot=gEmaVal; plotOk=true;
        }
      else
        {
         double alpha=2.0/((double)InpPlotLen+1.0);
         gEmaVal=alpha*lc+(1.0-alpha)*gEmaVal;
         plot=gEmaVal; plotOk=true;
        }
     }

   gHPlot[idx]=plot;
   gHPlotOk[idx]=plotOk;
   return(true);
  }

//==================================================================
//  2) PIVOT FRATTALI E DIVERGENZE
//  La barra candidata a pivot e' quella a shift s+InpPivotR: ha
//  InpPivotR barre CHIUSE alla sua destra e InpPivotL alla sinistra.
//  Prima di quel momento il pivot NON esiste per l'EA: e' il costo
//  del "niente repaint", ed e' esattamente il ritardo che su
//  TradingView non si vede perche' quegli indicatori ridipingono.
//==================================================================
void RilevaPivot(const int s)
  {
   int L=InpPivotL, R=InpPivotR;
   int n=L+R+1;

   MqlRates rr[];
   ArraySetAsSeries(rr,true);
   if(CopyRates(_Symbol,InpTF,s,n,rr)!=n) return;      // storico insufficiente: nessun pivot

   double cc[];
   ArraySetAsSeries(cc,true);
   if(CopyBuffer(hCci,0,s,n,cc)!=n) return;            // CCI non pronto: nessun pivot

   //--- rr[0] = barra a shift s (la piu' recente del blocco)
   //    rr[R] = CANDIDATA a pivot
   //    rr[R+L] = barra piu' vecchia del blocco
   int c=R;

   bool lowPrice=true, lowCci=true, highPrice=true, highCci=true;
   for(int i=0;i<n;i++)
     {
      if(i==c) continue;
      //--- confronto STRETTO su entrambi i lati (SCELTA NOSTRA): con la
      //    disuguaglianza larga un tratto piatto genererebbe una raffica
      //    di pivot identici e divergenze fantasma.
      if(!(rr[c].low  < rr[i].low ))  lowPrice=false;
      if(!(cc[c]      < cc[i]     ))  lowCci=false;
      if(!(rr[c].high > rr[i].high))  highPrice=false;
      if(!(cc[c]      > cc[i]     ))  highCci=false;
      if(!lowPrice && !lowCci && !highPrice && !highCci) break;
     }

   if(lowPrice)  cPv_lowPrice++;
   if(lowCci)    cPv_lowCci++;
   if(highPrice) cPv_highPrice++;
   if(highCci)   cPv_highCci++;

   bool isLow=false, isHigh=false;
   if(InpPivotSource==0)      { isLow=lowCci;              isHigh=highCci; }
   else if(InpPivotSource==1) { isLow=lowPrice;            isHigh=highPrice; }
   else                       { isLow=(lowPrice&&lowCci);  isHigh=(highPrice&&highCci); }

   if(isLow)  RegistraPivotLow (rr[c].time,rr[c].low ,cc[c]);
   if(isHigh) RegistraPivotHigh(rr[c].time,rr[c].high,cc[c]);
  }

//------------------------------------------------------------------
//  Nuovo PIVOT-MINIMO confermato: si confronta con il precedente.
//  DIVERGENZA BULL = prezzo Lower Low + CCI Higher Low.
//  La divergenza NASCE sulla barra del PRIMO pivot della coppia
//  (quello vecchio): e' da li' che parte la ricerca dell'estremo per
//  lo stop [FONTE: "l'estremo compreso tra l'inizio della divergenza
//  e la candela del segnale"].
//------------------------------------------------------------------
void RegistraPivotLow(datetime t,double px,double cci)
  {
   cPv_low++;

   if(gLowHas)
     {
      int dist=BarDist(gLowT,t);
      if(dist<=0 || dist>InpMaxPivotDist)
        {
         cD_dist++;
        }
      else if(px<gLowP && cci>gLowC)
        {
         if(gDivBull) cD_repl++;      // una divergenza bull piu' fresca sostituisce la vecchia (SCELTA NOSTRA)
         gDivBull=true;
         gDivBullStart=gLowT;         // barra del PRIMO pivot = inizio della divergenza
         gDivBullDetect=t;            // il secondo pivot: la conferma arriva InpPivotR barre dopo
         cD_bull++; dD_bull++;
         if(!gWarmup)
            Log(StringFormat("DIVERGENZA BULL: minimi prezzo %s -> %s (LL), CCI %.1f -> %.1f (HL), distanza %d barre. "
                             "Inizio figura %s.",
                DoubleToString(gLowP,_Digits),DoubleToString(px,_Digits),gLowC,cci,dist,
                TimeToString(gLowT,TIME_DATE|TIME_MINUTES)));
        }
     }

   gLowT=t; gLowP=px; gLowC=cci; gLowHas=true;
  }

//------------------------------------------------------------------
//  Nuovo PIVOT-MASSIMO confermato: specchio esatto.
//  DIVERGENZA BEAR = prezzo Higher High + CCI Lower High.
//------------------------------------------------------------------
void RegistraPivotHigh(datetime t,double px,double cci)
  {
   cPv_high++;

   if(gHighHas)
     {
      int dist=BarDist(gHighT,t);
      if(dist<=0 || dist>InpMaxPivotDist)
        {
         cD_dist++;
        }
      else if(px>gHighP && cci<gHighC)
        {
         if(gDivBear) cD_repl++;
         gDivBear=true;
         gDivBearStart=gHighT;
         gDivBearDetect=t;
         cD_bear++; dD_bear++;
         if(!gWarmup)
            Log(StringFormat("DIVERGENZA BEAR: massimi prezzo %s -> %s (HH), CCI %.1f -> %.1f (LH), distanza %d barre. "
                             "Inizio figura %s.",
                DoubleToString(gHighP,_Digits),DoubleToString(px,_Digits),gHighC,cci,dist,
                TimeToString(gHighT,TIME_DATE|TIME_MINUTES)));
        }
     }

   gHighT=t; gHighP=px; gHighC=cci; gHighHas=true;
  }

//------------------------------------------------------------------
//  SCADENZA DELLE DIVERGENZE (SCELTA NOSTRA, default SPENTA)
//  La fonte non mette un limite di tempo: si aspetta la candela che
//  taglia il plot, quanto serve. InpDivMaxBars > 0 accende un tetto,
//  misurato dalla barra di NASCITA della divergenza (primo pivot).
//------------------------------------------------------------------
void ScadenzaDivergenze(const int s)
  {
   if(InpDivMaxBars<=0) return;
   datetime t=iTime(_Symbol,InpTF,s);
   if(t<=0) return;

   if(gDivBull && BarDist(gDivBullStart,t)>InpDivMaxBars)
     { gDivBull=false; cD_exp++; if(!gWarmup) Log("divergenza BULL scaduta per limite di barre: nessun trade."); }
   if(gDivBear && BarDist(gDivBearStart,t)>InpDivMaxBars)
     { gDivBear=false; cD_exp++; if(!gWarmup) Log("divergenza BEAR scaduta per limite di barre: nessun trade."); }
  }

//==================================================================
//  3) CHECKLIST DEL SEGNALE [FONTE], nell'ordine dei video.
//  Tutti i dati vengono da barre CHIUSE: la barra s e' gia' chiusa,
//  le precedenti pure. Nessun valore ridipinge.
//==================================================================
void ValutaSegnale(const int s)
  {
   //--- una divergenza per verso: la fonte dice "bull o bear", quindi le
   //    due possono coesistere e si valutano tutte e due.
   if(gDivBull) ValutaLato(s,+1);
   if(gDivBear) ValutaLato(s,-1);
  }

void ValutaLato(const int s,const int dir)
  {
   bool isLong=(dir>0);

   //--- servono la candela del segnale e almeno la precedente, con plot
   //    calcolabile e storia contigua (verificata per TEMPO, non per
   //    posizione: se il buffer si e' disallineato non si tira a indovinare).
   double lo0,lh0,ll0,lc0,pl0; int col0;
   double lc1,pl1;
   if(!HistBar(s,0,lo0,lh0,ll0,lc0,pl0,col0)) return;
   if(!HistCP (s,1,lc1,pl1))                  return;

   //--- (a) la divergenza deve essere gia' NOTA: il secondo pivot e'
   //    confermato InpPivotR barre dopo la sua barra, quindi la candela
   //    del segnale non puo' essere anteriore a quella conferma.
   datetime tSig=iTime(_Symbol,InpTF,s);
   if(tSig<=0) return;
   datetime tDet = isLong ? gDivBullDetect : gDivBearDetect;
   if(BarDist(tDet,tSig)<InpPivotR) return;    // la conferma non era ancora arrivata su questa barra

   //--- (b) PRIMA candela linreg che taglia il plot nel verso del segnale.
   //    "Prima" e' garantito dalla condizione sulla barra precedente: se
   //    quella stava gia' oltre, questa non e' la prima.
   //    Due varianti [FONTE]: la candela CHIUDE oltre il plot, oppure
   //    APRE gia' oltre.
   bool prevOpposta = isLong ? (lc1<=pl1) : (lc1>=pl1);
   if(!prevOpposta) return;
   bool taglia = isLong ? (lc0>pl0 || lo0>pl0) : (lc0<pl0 || lo0<pl0);
   if(!taglia) return;

   cX_cross++;

   //--- (c) FASCIA ORARIA della candela del segnale [FONTE].
   //    REGOLA DI INVALIDAZIONE [FONTE, video 16]: se la PRIMA candela che
   //    taglia il plot e' fuori orario, la divergenza e' NULLA. Non si
   //    aspetta la candela buona: si aspetta una divergenza nuova.
   MqlDateTime dt; TimeToStruct(tSig,dt);
   if(dt.hour<InpHourStart || dt.hour>InpHourEnd)
     {
      cInv_hour++; dInv_hour++;
      ConsumaDivergenza(dir);
      if(!gWarmup)
         Log(StringFormat("divergenza %s INVALIDATA: la prima candela che taglia il plot e' delle %02d:%02d, "
                          "fuori dalla fascia %02d-%02d. Si aspetta una divergenza nuova.",
             (isLong?"BULL":"BEAR"),dt.hour,dt.min,InpHourStart,InpHourEnd));
      return;
     }

   //--- (d) COLORE LINREG in tinta con la divergenza [FONTE, video 16]:
   //    verde per il bull, rossa per il bear. Sono i colori delle candele
   //    LINREG, non di quelle giapponesi.
   int colRichiesto = isLong ? +1 : -1;
   if(col0!=colRichiesto)
     {
      cF_color++;
      if(InpDivDieOnFail) ConsumaDivergenza(dir);
      if(!gWarmup)
         Log(StringFormat("segnale %s scartato: candela linreg non in tinta (colore %s).",
             (isLong?"BULL":"BEAR"),(col0>0?"verde":(col0<0?"rossa":"doji"))));
      return;
     }

   //--- (e) le InpPrevBars candele PRECEDENTI tutte dal lato opposto del
   //    plot (anti-lateralita' [FONTE]).
   for(int k=1;k<=InpPrevBars;k++)
     {
      double lcK,plK;
      if(!HistCP(s,k,lcK,plK)) return;               // storia insufficiente: non si tira a indovinare
      bool opposta = isLong ? (lcK<plK) : (lcK>plK);
      if(!opposta)
        {
         cF_prev++;
         if(InpDivDieOnFail) ConsumaDivergenza(dir);
         if(!gWarmup)
            Log(StringFormat("segnale %s scartato: la candela -%d non stava dal lato opposto del plot.",
                (isLong?"BULL":"BEAR"),k));
         return;
        }
     }

   //--- CHECKLIST SUPERATA: da qui in poi il pattern esiste. Quello che
   //    segue sono i NOSTRI vincoli (lati, posto occupato, freschezza):
   //    contati a parte, cosi' il funnel separa la frequenza del pattern
   //    dalle nostre bocciature.
   if(isLong) cS_long++; else cS_short++;
   dS_sig++;

   //--- lo STOP si calcola adesso, sull'estremo della figura fra la barra
   //    d'inizio divergenza e la candela del segnale INCLUSA [FONTE].
   datetime tStart = isLong ? gDivBullStart : gDivBearStart;
   double estremo=0.0;
   bool estremoOk=EstremoFigura(s,tStart,isLong,estremo);

   //--- la divergenza e' CONSUMATA: la sua candela di conferma e'
   //    arrivata. Che poi il trade parta o no dipende da noi, non da lei.
   ConsumaDivergenza(dir);

   if(gWarmup) return;                     // nel warmup si aggiorna lo stato, non si opera

   if(s!=1){ cF_late++; Log("segnale su barra non fresca (recupero barre): nessun ingresso."); return; }

   if((isLong && !InpAllowLong) || (!isLong && !InpAllowShort))
     { cF_side++; return; }

   //--- UNA sola posizione/ordine alla volta per magic.
   if(CountPositions()>0 || CountPendings()>0)
     { cF_busy++; Log("segnale valido ma posizione o pendente gia' attivo: nessun ingresso."); return; }

   if(!estremoOk)
     { cO_failLevel++; Log("estremo della figura non calcolabile: nessun ingresso."); return; }

   double livello=iClose(_Symbol,InpTF,s);          // [FONTE] ingresso alla CHIUSURA della candela del segnale
   if(livello<=0.0)
     { cO_failLevel++; Log("chiusura della candela del segnale non disponibile: nessun ingresso."); return; }

   double buf=(double)InpSLBufferPts*_Point;
   double sl = isLong ? (estremo-buf) : (estremo+buf);
   sl=NormalizePrice(sl);

   gSigArmed=true;
   gSigDir=dir;
   gSigLevel=livello;
   gSigSL=sl;
   gSigBarTime=tSig;
   gSigBars=1;

   Log(StringFormat("SEGNALE %s alle %02d:%02d: livello d'ingresso %s (chiusura candela segnale), estremo figura %s, "
                    "SL %s. Candela linreg O=%s H=%s L=%s C=%s, plot %s.",
       (isLong?"LONG":"SHORT"),dt.hour,dt.min,
       DoubleToString(livello,_Digits),DoubleToString(estremo,_Digits),DoubleToString(sl,_Digits),
       DoubleToString(lo0,_Digits),DoubleToString(lh0,_Digits),DoubleToString(ll0,_Digits),
       DoubleToString(lc0,_Digits),DoubleToString(pl0,_Digits)));

   TryEnter();
  }

void ConsumaDivergenza(const int dir)
  {
   if(dir>0) gDivBull=false; else gDivBear=false;
  }

//------------------------------------------------------------------
//  ESTREMO DELLA FIGURA [FONTE]: minimo dei low (long) o massimo dei
//  high (short) fra la barra d'INIZIO DIVERGENZA e la candela del
//  segnale INCLUSA. Prezzi GREZZI, non linreg: lo stop si mette dove
//  il mercato e' arrivato davvero.
//------------------------------------------------------------------
bool EstremoFigura(const int sSig,datetime tStart,const bool isLong,double &estremo)
  {
   estremo=0.0;
   if(tStart<=0) return(false);

   int sStart=iBarShift(_Symbol,InpTF,tStart,false);
   if(sStart<sSig) return(false);

   int n=sStart-sSig+1;
   //--- tetto di sicurezza: la figura non puo' essere piu' lunga della
   //    distanza massima fra i pivot piu' il ritardo di conferma.
   int tetto=InpMaxPivotDist+InpPivotR+InpPivotL+5;
   if(n>tetto) n=tetto;
   if(n<1) return(false);

   MqlRates rr[];
   ArraySetAsSeries(rr,true);
   if(CopyRates(_Symbol,InpTF,sSig,n,rr)!=n) return(false);

   double v = isLong ? rr[0].low : rr[0].high;
   for(int i=1;i<n;i++)
     {
      if(isLong){ if(rr[i].low <v) v=rr[i].low;  }
      else      { if(rr[i].high>v) v=rr[i].high; }
     }
   estremo=v;
   return(estremo>0.0);
  }

//==================================================================
//  INGRESSO [FONTE]
//   - livello = CHIUSURA della candela del segnale;
//   - prezzo gia' scappato VERSO IL TP -> ordine LIMIT su quel livello
//     (si aspetta il ritorno), valido InpEntryWindowBars barre;
//   - prezzo piu' conveniente (verso lo SL) -> ingresso a MERCATO.
//  Filtro spread con riprova entro la finestra (stile di famiglia).
//  SL e TP sono ordini VERI sul server: niente stealth.
//==================================================================
void TryEnter()
  {
   if(!gSigArmed) return;

   //--- il posto puo' essersi occupato fra il segnale e la riprova
   if(CountPositions()>0 || CountPendings()>0)
     { cF_busy++; DisarmaSegnale(); return; }

   //--- guardia reload-safe: se lo storico dei deal dice che su questo
   //    stesso segnale abbiamo gia' aperto (riavvio a cavallo della
   //    barra), non si raddoppia.
   if(GiaOperatoDallaBarra(gSigBarTime))
     { Log("risultano gia' deal del magic da questo segnale: nessun ingresso."); DisarmaSegnale(); return; }

   //--- filtro spread: non si entra dentro un allargamento. Si riprova
   //    sulle barre successive finche' la finestra regge; poi il segnale
   //    e' perso (la candela del segnale invecchia, non si insegue).
   if(!SpreadOK())
     {
      if(gSigBars>=InpEntryWindowBars)
        {
         cO_spread++;
         Log(StringFormat("spread %d points sopra il limite %d per tutta la finestra (%d barre): segnale perso.",
             SpreadPoints(),InpMaxSpreadPts,InpEntryWindowBars));
         DisarmaSegnale();
        }
      else
         Log(StringFormat("spread %d points sopra il limite %d: rinvio alla barra successiva (barra %d di %d).",
             SpreadPoints(),InpMaxSpreadPts,gSigBars,InpEntryWindowBars));
      return;
     }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0)
     { cO_failSend++; Log("prezzi non disponibili: nessun ordine."); DisarmaSegnale(); return; }

   bool   isLong=(gSigDir>0);
   double livello=gSigLevel;
   double minDist=StopsMinDist();

   //--- prezzo eseguibile ADESSO nel verso del trade: e' con questo che si
   //    decide mercato o limit (il confronto va fatto sul prezzo che si
   //    pagherebbe davvero, non sulla chiusura bid della candela).
   double pxOra = isLong ? ask : bid;

   //--- il prezzo e' scappato VERSO IL TP? (long: sopra il livello;
   //    short: sotto). In quel caso il livello e' un LIMIT da aspettare.
   bool versoTp = isLong ? (pxOra>livello) : (pxOra<livello);

   bool usaLimit=false;
   if(versoTp)
     {
      double dist = isLong ? (pxOra-livello) : (livello-pxOra);
      if(dist>minDist) usaLimit=true;
      else if(!InpMarketIfTooClose)
        {
         //--- SCELTA NOSTRA (spenta di default): il livello e' dentro la
         //    distanza minima del broker e non si vuole surrogare
         //    l'ingresso col mercato: segnale perso, contato nel funnel.
         cO_failLevel++;
         Log(StringFormat("livello LIMIT %s troppo vicino al prezzo (distanza minima %s): segnale perso.",
             DoubleToString(livello,_Digits),DoubleToString(minDist,_Digits)));
         DisarmaSegnale(); return;
        }
      //--- altrimenti: il livello coincide di fatto col prezzo -> mercato
     }

   //--- prezzo d'ingresso di riferimento per stop, target e lotto
   double entry = usaLimit ? livello : pxOra;

   //--- STOP LOSS gia' calcolato alla checklist (estremo figura + buffer):
   //    qui si verifica solo che rispetti la distanza minima del broker.
   double sl=gSigSL;
   bool slOk = isLong ? (sl < entry-minDist) : (sl > entry+minDist);
   if(!slOk)
     {
      cO_failLevel++;
      Log(StringFormat("SL non valido (%s contro ingresso %s, distanza minima %s): nessun ordine.",
          DoubleToString(sl,_Digits),DoubleToString(entry,_Digits),DoubleToString(minDist,_Digits)));
      DisarmaSegnale(); return;
     }

   double riskDist = isLong ? (entry-sl) : (sl-entry);
   if(riskDist<=0.0)
     { cO_failLevel++; Log("distanza di stop nulla: nessun ordine."); DisarmaSegnale(); return; }

   //--- TAKE PROFIT: InpTP_R x rischio [FONTE: RR 1:1]. Se non passa la
   //    distanza minima del broker il trade NON si fa (non si sposta il
   //    target per farcelo stare) e finisce nel funnel.
   double tp = isLong ? (entry+InpTP_R*riskDist) : (entry-InpTP_R*riskDist);
   tp=NormalizePrice(tp);
   bool tpOk = isLong ? (tp > entry+minDist) : (tp < entry-minDist);
   if(!tpOk)
     {
      cO_failTp++;
      Log(StringFormat("TP %s troppo vicino all'ingresso %s (distanza minima %s): trade saltato.",
          DoubleToString(tp,_Digits),DoubleToString(entry,_Digits),DoubleToString(minDist,_Digits)));
      DisarmaSegnale(); return;
     }

   double lot=LotByRisk(riskDist);
   if(lot<=0.0)
     { cO_failLot++; Log("lotto nullo: nessun ordine."); DisarmaSegnale(); return; }

   string cm=InpComment+(isLong?" L":" S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_EasyTrend")) return;
   if(usaLimit)
     {
      double px=NormalizePrice(livello);
      //--- il LIMIT resta GTC sul server: la scadenza la facciamo
      //    rispettare noi in ManagePending, contando le barre di InpTF
      //    (la fonte ragiona in candele, non in orologio).
      bool ok = isLong ? gTrade.BuyLimit (lot,px,_Symbol,sl,tp,ORDER_TIME_GTC,0,cm)
                       : gTrade.SellLimit(lot,px,_Symbol,sl,tp,ORDER_TIME_GTC,0,cm);
      if(!ok)
        { cO_failSend++; Log("piazzamento LIMIT FALLITO: "+gTrade.ResultRetcodeDescription()); DisarmaSegnale(); return; }

      gPendTicket=gTrade.ResultOrder();
      gPendBars=0;
      cO_limit++; dO_placed++;
      Log(StringFormat("%s LIMIT @ %s  SL %s  TP %s  lot %.2f  (prezzo gia' a %s, validita' %d barre, ordine %s)",
          (isLong?"BUY":"SELL"),DoubleToString(px,_Digits),DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits),lot,DoubleToString(pxOra,_Digits),InpEntryWindowBars,
          IntegerToString((long)gPendTicket)));
      DisarmaSegnale();
      return;
     }

   bool ok = isLong ? gTrade.Buy (lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(!ok)
     { cO_failSend++; Log("apertura a mercato FALLITA: "+gTrade.ResultRetcodeDescription()); DisarmaSegnale(); return; }

   cO_market++; dO_placed++;
   if(isLong) cI_long++; else cI_short++;

   //--- nel log finisce anche lo SCARTO fra la chiusura della candela del
   //    segnale e il prezzo davvero eseguito: e' il costo di eseguire su
   //    chiusura di candela, e va misurato, non intuito.
   Log(StringFormat("%s a MERCATO @ %s  SL %s  TP %s  lot %.2f  (livello segnale %s, scarto %s, rischio %s)",
       (isLong?"LONG":"SHORT"),DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),
       DoubleToString(tp,_Digits),lot,DoubleToString(livello,_Digits),
       DoubleToString(isLong?(entry-livello):(livello-entry),_Digits),
       DoubleToString(riskDist,_Digits)));

   DisarmaSegnale();
  }

void DisarmaSegnale()
  {
   gSigArmed=false; gSigDir=0; gSigBars=0;
  }

//==================================================================
//  SORVEGLIANZA DEL PENDENTE
//  Nessun trailing, nessuna parziale, nessun time-stop sulla
//  POSIZIONE: la fonte non li prevede. L'unica gestione e' la
//  scadenza del LIMIT non riempito entro InpEntryWindowBars barre.
//==================================================================
void ManagePending()
  {
   //--- riempimento segnalato da OnTradeTransaction (fonte unica: cosi'
   //    non si conta due volte un fill gia' visto)
   if(gJustFilled)
     {
      gJustFilled=false;
      cP_filled++;
      gPendTicket=0; gPendBars=0;
     }

   if(gPendTicket==0) return;

   //--- l'ordine non e' piu' fra gli attivi e nessun fill e' stato
   //    segnalato: e' stato riempito fra due controlli oppure cancellato.
   if(!OrderSelect(gPendTicket))
     {
      gPendTicket=0; gPendBars=0;
      if(CountPositions()>0) cP_filled++;
      else                 { cP_expired++; Log("pendente non piu' attivo (cancellato o scaduto lato broker)."); }
      return;
     }

   gPendBars++;
   if(gPendBars<InpEntryWindowBars) return;

   //--- finestra esaurita: il prezzo non e' tornato sul livello di
   //    chiusura. Il segnale e' perso, non si insegue.
   if(gTrade.OrderDelete(gPendTicket))
     {
      cP_expired++;
      Log(StringFormat("LIMIT non riempito entro %d barre: ordine cancellato, segnale consumato.",InpEntryWindowBars));
     }
   else
      Log("cancellazione del LIMIT scaduto FALLITA: "+gTrade.ResultRetcodeDescription());

   gPendTicket=0; gPendBars=0;
  }

//==================================================================
//  ESITI (per il funnel) e riempimento del pendente.
//  TP e SL li dichiara il server: qui si legge solo la ragione.
//==================================================================
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
   if(trans.type!=TRADE_TRANSACTION_DEAL_ADD) return;
   ulong d=trans.deal;
   if(d==0) return;
   if(!HistoryDealSelect(d)) return;
   if(HistoryDealGetInteger(d,DEAL_MAGIC)!=InpMagic) return;
   if(HistoryDealGetString(d,DEAL_SYMBOL)!=_Symbol) return;

   long entry=HistoryDealGetInteger(d,DEAL_ENTRY);

   if(entry==DEAL_ENTRY_IN)
     {
      //--- se avevamo un LIMIT vivo, questo e' il suo riempimento
      if(gPendTicket!=0)
        {
         gJustFilled=true;
         long tipo=HistoryDealGetInteger(d,DEAL_TYPE);
         if(tipo==(long)DEAL_TYPE_BUY) cI_long++; else if(tipo==(long)DEAL_TYPE_SELL) cI_short++;
        }
      return;
     }

   if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) return;

   long reason=HistoryDealGetInteger(d,DEAL_REASON);
   if(reason==(long)DEAL_REASON_TP)      cE_tp++;
   else if(reason==(long)DEAL_REASON_SL) cE_sl++;
   else                                  cE_other++;
  }

//==================================================================
//  UTILITY
//==================================================================
//--- REGRESSIONE LINEARE su InpLinRegLen barre, valutata nel punto
//    corrente (offset 0), per open/high/low/close in una sola lettura
//    dello storico. E' il calcolo di ta.linreg(src,len,0):
//    retta ai minimi quadrati sulle ultime len barre, valore all'ultima.
bool CalcLinRegBar(const int shift,double &vO,double &vH,double &vL,double &vC)
  {
   vO=0.0; vH=0.0; vL=0.0; vC=0.0;
   int n=InpLinRegLen;

   MqlRates r[];
   ArraySetAsSeries(r,true);
   if(CopyRates(_Symbol,InpTF,shift,n,r)!=n) return(false);

   double dn=(double)n;
   double sx=0.0,sxx=0.0;
   double sO=0.0,sH=0.0,sL=0.0,sC=0.0;
   double sxO=0.0,sxH=0.0,sxL=0.0,sxC=0.0;

   //--- r[0] e' la barra a shift (la piu' RECENTE): in ascissa le si da'
   //    x = n-1, alla piu' vecchia x = 0. Il valore cercato e' quello
   //    della retta in x = n-1.
   for(int j=0;j<n;j++)
     {
      double x=(double)(n-1-j);
      sx+=x; sxx+=x*x;
      sO+=r[j].open;  sxO+=x*r[j].open;
      sH+=r[j].high;  sxH+=x*r[j].high;
      sL+=r[j].low;   sxL+=x*r[j].low;
      sC+=r[j].close; sxC+=x*r[j].close;
     }

   double den=dn*sxx-sx*sx;
   if(den==0.0) return(false);
   double xl=dn-1.0;
   double b;

   b=(dn*sxO-sx*sO)/den; vO=(sO-b*sx)/dn+b*xl;
   b=(dn*sxH-sx*sH)/den; vH=(sH-b*sx)/dn+b*xl;
   b=(dn*sxL-sx*sL)/den; vL=(sL-b*sx)/dn+b*xl;
   b=(dn*sxC-sx*sC)/den; vC=(sC-b*sx)/dn+b*xl;
   return(true);
  }

//--- linC della barra inserita "back" posizioni fa (0 = l'ultima).
bool HistLinC(const int back,double &v)
  {
   v=0.0;
   if(back<0 || back>=EZ_HIST) return(false);
   if((long)back>=gHN || (long)back>=gSeqCount) return(false);
   int idx=(int)((gHN-1-(long)back)%EZ_HIST);
   v=gHLinC[idx];
   return(true);
  }

//--- candela linreg completa della barra a shift s+back, con verifica
//    che la storia sia davvero allineata (confronto per TEMPO) e che il
//    plot di quella barra fosse calcolabile.
bool HistBar(const int s,const int back,
             double &lo,double &lh,double &ll,double &lc,double &plot,int &col)
  {
   lo=0.0; lh=0.0; ll=0.0; lc=0.0; plot=0.0; col=0;
   if(back<0 || back>=EZ_HIST) return(false);
   if((long)back>=gHN || (long)back>=gSeqCount) return(false);

   int idx=(int)((gHN-1-(long)back)%EZ_HIST);
   if(!gHPlotOk[idx]) return(false);

   datetime tAtteso=iTime(_Symbol,InpTF,s+back);
   if(tAtteso<=0 || gHT[idx]!=tAtteso) return(false);   // storia disallineata: si rinuncia

   lo=gHLinO[idx]; lh=gHLinH[idx]; ll=gHLinL[idx]; lc=gHLinC[idx];
   plot=gHPlot[idx]; col=gHCol[idx];
   return(true);
  }

//--- scorciatoia per i due soli valori che servono ai confronti con il
//    plot (chiusura linreg e plot della stessa barra): stessi controlli
//    di HistBar, meno rumore nel chiamante.
bool HistCP(const int s,const int back,double &lc,double &plot)
  {
   double lo,lh,ll,c,p; int col;
   lc=0.0; plot=0.0;
   if(!HistBar(s,back,lo,lh,ll,c,p,col)) return(false);
   lc=c; plot=p;
   return(true);
  }

//--- distanza in BARRE fra due tempi di barra (positiva se t2 e' piu'
//    recente di t1). Si usa iBarShift e non la differenza di orario:
//    fine settimana e festivi renderebbero il conto sbagliato.
int BarDist(datetime t1,datetime t2)
  {
   if(t1<=0 || t2<=0) return(-1);
   int s1=iBarShift(_Symbol,InpTF,t1,false);
   int s2=iBarShift(_Symbol,InpTF,t2,false);
   if(s1<0 || s2<0) return(-1);
   return(s1-s2);
  }

//--- spread corrente in POINTS, calcolato da ask/bid: e' l'unica misura
//    che vale su tutti i simboli (2, 3 o 5 decimali) e in tutte le
//    modalita' del tester, dove SYMBOL_SPREAD puo' restare fermo.
int SpreadPoints()
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0 || _Point<=0.0)
      return((int)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
   return((int)MathRound((ask-bid)/_Point));
  }

bool SpreadOK()
  {
   if(InpMaxSpreadPts<=0) return(true);
   return(SpreadPoints()<=InpMaxSpreadPts);
  }

double StopsMinDist()
  {
   double d=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   double sp=(double)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)*_Point;
   return(MathMax(d,sp));
  }

//--- normalizzazione al TICK SIZE prima che ai decimali: su alcuni simboli
//    (indici, metalli) il tick non e' 1 point e un prezzo "giusto" ma non
//    allineato al tick fa rifiutare l'ordine.
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
   //  NOTA (comportamento di famiglia, identico agli altri EA): il lotto viene
   //  comunque riportato al MINIMO del simbolo. Su conti piccoli o stop molto
   //  larghi il rischio effettivo puo' quindi superare InpRiskPercent: e' un
   //  limite del broker, non una scelta di money management.
   return(MathMax(mn,MathMin(mx,lot)));
  }

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

int CountPendings()
  {
   int n=0;
   for(int k=OrdersTotal()-1;k>=0;k--)
     {
      ulong tk=OrderGetTicket(k);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//--- guardia reload-safe: esiste gia' un ingresso del mio magic FATTO SU
//    QUESTO segnale? Si guarda dalla CHIUSURA della candela del segnale
//    in avanti: prima di quell'istante il segnale non esisteva ancora,
//    quindi un deal precedente appartiene a un altro setup e non deve
//    bloccare questo ingresso.
bool GiaOperatoDallaBarra(datetime barTime)
  {
   if(barTime<=0) return(false);
   datetime tDa=(datetime)((long)barTime+(long)PeriodSeconds(InpTF));
   datetime tTo=(datetime)((long)TimeCurrent()+60);
   if(tDa>tTo) return(false);
   if(!HistorySelect(tDa,tTo)) return(false);
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetString(tk,DEAL_SYMBOL)!=_Symbol) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      return(true);
     }
   return(false);
  }

//==================================================================
//  RIGA GIORNALIERA DEL FUNNEL: serve alla CAL per vedere il ritmo
//  del motore giorno per giorno (quante divergenze nascono, quante
//  muoiono per orario, quanti segnali passano la checklist, quanti
//  ordini restano). Si stampa solo se nella giornata e' successo
//  qualcosa, per non allagare il log nei mesi morti.
//==================================================================
void StampaFunnelGiornaliero(datetime tNuova)
  {
   MqlDateTime dt; TimeToStruct(tNuova,dt);
   if(gFunnelDay<0){ gFunnelDay=dt.day_of_year; return; }
   if(dt.day_of_year==gFunnelDay) return;

   if(InpVerbose && (dD_bull+dD_bear+dInv_hour+dS_sig+dO_placed)>0)
      PrintFormat("[EZ-FUNNEL] GIORNO chiuso: divergenze bull=%d bear=%d | invalidate per orario=%d | segnali validati=%d | ordini piazzati=%d",
                  (int)dD_bull,(int)dD_bear,(int)dInv_hour,(int)dS_sig,(int)dO_placed);

   dD_bull=0; dD_bear=0; dInv_hour=0; dS_sig=0; dO_placed=0;
   gFunnelDay=dt.day_of_year;
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
//  FUNNEL DI MORTALITA' [EZ-FUNNEL] (solo Print a fine test).
//  La divergenza arriva in ritardo PER COSTRUZIONE (InpPivotR barre)
//  e la checklist ha cinque cancelli in fila: se l'EA resta muto
//  bisogna sapere SUBITO se e' perche' i pivot non nascono (modo
//  troppo severo?), perche' le divergenze non si formano, perche'
//  l'orario le uccide (fuso sbagliato?), perche' il colore o le tre
//  candele le bocciano, o perche' le bocciamo noi con spread e
//  vincoli del broker.
//  Nessun impatto sul CSV (che nasce da FrameAdd/OnTesterDeinit).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[EZ-FUNNEL] %s %s  linreg=%d  plot=%s(%d)  CCI=%d  pivot=%d/%d su %s  distMax=%d  orario=%02d-%02d  prevBars=%d  slBuf=%d pt  TP=%.2f R  finestra=%d  lati: L=%s S=%s  maxSpread=%d  warmup=%d  divMaxBars=%s  dieOnFail=%s",
               _Symbol,EnumToString(InpTF),InpLinRegLen,PlotModeName(InpPlotMode),InpPlotLen,
               InpCciPeriod,InpPivotL,InpPivotR,PivotSourceName(InpPivotSource),InpMaxPivotDist,
               InpHourStart,InpHourEnd,InpPrevBars,InpSLBufferPts,InpTP_R,InpEntryWindowBars,
               (InpAllowLong?"ON":"OFF"),(InpAllowShort?"ON":"OFF"),
               InpMaxSpreadPts,InpWarmupBars,
               (InpDivMaxBars>0?IntegerToString(InpDivMaxBars):"off"),
               (InpDivDieOnFail?"ON":"OFF"));
   PrintFormat("[EZ-FUNNEL] BARRE     elaborate=%d (warmup=%d) | barre scartate per dati insufficienti=%d",
               (int)cB_bars,(int)cW_bars,(int)cF_data);
   //--- NOTA sui conteggi: pivot, divergenze e checklist includono anche le
   //    barre del WARMUP (lo stato si ricostruisce davvero, quindi si conta
   //    davvero). Gli ORDINI no: nel warmup non si opera per costruzione.
   PrintFormat("[EZ-FUNNEL] PIVOT     confermati col modo attivo (%s), warmup incluso: minimi=%d massimi=%d | solo PREZZO: min=%d max=%d | solo CCI: min=%d max=%d",
               PivotSourceName(InpPivotSource),(int)cPv_low,(int)cPv_high,
               (int)cPv_lowPrice,(int)cPv_highPrice,(int)cPv_lowCci,(int)cPv_highCci);
   PrintFormat("[EZ-FUNNEL] DIVERGENZE rilevate (warmup incluso): bull=%d bear=%d | coppie scartate per distanza=%d | sostituite da una nuova=%d | scadute=%d",
               (int)cD_bull,(int)cD_bear,(int)cD_dist,(int)cD_repl,(int)cD_exp);
   PrintFormat("[EZ-FUNNEL] CHECKLIST rotture del plot esaminate=%d | INVALIDATE PER ORARIO=%d | scartate per colore=%d | scartate per le %d candele=%d ==> SEGNALI VALIDATI=%d (long=%d short=%d)",
               (int)cX_cross,(int)cInv_hour,(int)cF_color,InpPrevBars,(int)cF_prev,
               (int)(cS_long+cS_short),(int)cS_long,(int)cS_short);
   PrintFormat("[EZ-FUNNEL] SCARTI    lato spento=%d | posizione/pendente occupato=%d | segnale non fresco=%d",
               (int)cF_side,(int)cF_busy,(int)cF_late);
   PrintFormat("[EZ-FUNNEL] ORDINI    scartati: spread=%d livello/stopsLevel=%d TP sotto stopsLevel=%d lotto=%d invioFallito=%d | piazzati: mercato=%d limit=%d | limit riempiti=%d non riempiti (finestra)=%d",
               (int)cO_spread,(int)cO_failLevel,(int)cO_failTp,(int)cO_failLot,(int)cO_failSend,
               (int)cO_market,(int)cO_limit,(int)cP_filled,(int)cP_expired);
   PrintFormat("[EZ-FUNNEL] ESITI     ingressi long=%d short=%d | TP=%d SL=%d altre chiusure=%d | trade eseguiti=%d",
               (int)cI_long,(int)cI_short,(int)cE_tp,(int)cE_sl,(int)cE_other,
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
