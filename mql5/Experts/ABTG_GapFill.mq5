//+------------------------------------------------------------------+
//|                                            ABTG_GapFill.mq5      |
//|                                                                  |
//|  EA di LABORATORIO "GAP-FILL DEL WEEKEND" - MT5 - TUTTO-IN-UNO   |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  FONTE NORMATIVA                                                 |
//|   1. backtest_pipeline/prove/GAP_FILL_TESI.md (VINCOLANTE:       |
//|      tesi scritta PRIMA di qualunque numero, 13/08/2026)         |
//|   2. Emiliano, live 19.04 (CATALOGO_STRATEGIE_CORSO): i gap di   |
//|      apertura domenicale "si devono riallineare".                |
//|                                                                  |
//|  ATTENZIONE - LA FONTE E' PARZIALE. Il corso da' SOLO:           |
//|      - direzione: SEMPRE CONTRO il gap;                          |
//|      - obiettivo: il riallineamento (chiusura del venerdi').     |
//|   Ingresso, stop, tempi, filtri NON sono specificati dal corso.  |
//|   Tutto il resto e' marcato "SCELTA NOSTRA" nei commenti degli   |
//|   input: sono PARAMETRI DA MISURARE, non verita' del corso.      |
//|                                                                  |
//|  IL MECCANISMO (ipotesi della tesi)                              |
//|   Il gap del weekend e' un dislivello di prezzo SENZA scambi:    |
//|   nessun volume l'ha costruito, quindi nessun volume lo difende. |
//|   La chiusura del venerdi' e' l'ultimo prezzo "vero" contrattato:|
//|   il mercato tende a tornarci per riprezzare in continuita'.     |
//|   ATTESA DICHIARATA: il fill e' un fenomeno RAPIDO o non e' - se |
//|   il gap non chiude nelle prime ore/giorni e' un gap di rottura  |
//|   (news, repricing) e insistere e' controtrend puro. Da qui il   |
//|   time-stop e il tetto massimo sulla dimensione del gap.         |
//|                                                                  |
//|  COSA FA (mappa REGOLA -> CODICE)                                |
//|   WeekId / OnNewBar / StartWeek                                  |
//|     - rilevamento del CAMBIO SETTIMANA sulle barre di InpTF:     |
//|       robusto sia per i simboli che riaprono la domenica sera    |
//|       (forex) sia per quelli che riaprono il lunedi' (indici),   |
//|       perche' il confine della settimana e' fissato al SABATO a  |
//|       meta' giornata, quando NESSUN mercato e' aperto;           |
//|     - venClose = close dell'ultima barra della settimana         |
//|       precedente; weekOpen = open della prima barra della nuova; |
//|     - gap = weekOpen - venClose.                                 |
//|   StartWeek (filtro dimensione, SCELTA NOSTRA)                   |
//|     - |gap| >= InpGapMinATR x ATR(D1): sotto il minimo lo        |
//|       spread si mangia tutto il movimento;                       |
//|     - |gap| <= InpGapMaxATR x ATR(D1): sopra il massimo e' un    |
//|       gap di ROTTURA e il riallineamento non e' il caso base.    |
//|   TryEnter (GUIDA: direzione SEMPRE contro il gap)               |
//|     - gap UP   -> SELL;  gap DOWN -> BUY;                        |
//|     - ordine a MERCATO, una sola finestra d'ingresso per         |
//|       settimana: se il filtro dimensione boccia, quella          |
//|       settimana non si opera piu' (niente rincorse);             |
//|     - FILTRO SPREAD (trappola n.1 della tesi): la domenica sera  |
//|       lo spread e' enorme PROPRIO quando l'EA vuole entrare.     |
//|       Se lo spread e' sopra soglia NON si entra subito: si       |
//|       riprova sulle barre successive entro InpEntryWindowBars.   |
//|   TryEnter (target e stop)                                       |
//|     - TP = weekOpen - gap x InpFillPct/100                       |
//|       (100 = fill PIENO, cioe' esattamente il close del venerdi';|
//|        la formula vale identica per gap positivi e negativi);    |
//|     - SL modo 0 = multiplo del gap OLTRE l'apertura              |
//|       (SL = weekOpen + gap x InpSLGapMult: 1.0 = rischio         |
//|        simmetrico al gap); modo 1 = InpAtrSlMult x ATR(D1).      |
//|   ManageTimeStop                                                 |
//|     - se il fill non arriva entro InpMaxHours ore: flat a        |
//|       mercato. E' la traduzione operativa di "rapido o niente".  |
//|                                                                  |
//|  UN SOLO CICLO A SETTIMANA PER SIMBOLO. RELOAD-SAFE: al riavvio  |
//|  la settimana in corso viene marcata COME GIA' CONSUMATA (non    |
//|  ne abbiamo osservato l'apertura), e in piu' si controlla lo     |
//|  storico dei deal della settimana col magic. Non si entra mai    |
//|  due volte nella stessa settimana. SL e TP sono ordini VERI sul  |
//|  server: niente stealth.                                         |
//|                                                                  |
//|  DIAGNOSTICA: funnel [GAP-FUNNEL] stampato da OnTester. Con ~52  |
//|  eventi l'anno per simbolo il campione e' strutturalmente        |
//|  piccolo: se l'EA resta muto il funnel dice SUBITO dove muore    |
//|  (gap troppo piccoli? troppo grandi? spread?) senza autopsie.    |
//|                                                                  |
//|  AVVERTENZA DELLA TESI (regola di sempre, qui vale doppio):      |
//|  l'OHLC NON vede lo spread della riapertura -> l'OHLC serve SOLO |
//|  per frequenza/screening, i VERDETTI SOLO a tick reali.          |
//|                                                                  |
//|  Mercati: forex (gap della domenica sera) e indici (gap del      |
//|  lunedi'): sono fenomeni DIVERSI, lo scan multi-simbolo dira'    |
//|  chi ce l'ha. TF: H1 (default) / M30 / H4 / D1.                  |
//|  DEMO. Nessuna garanzia. Non compilato ne' testato dall'autore   |
//|  del codice: compilare in MetaEditor e validare nel tester.      |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                        |
//|                                                                   |
//|  1.00 - Prima stesura, dalla tesi GAP_FILL_TESI.md.               |
//|    Nessun numero misurato ancora: TUTTI i default sono valori di  |
//|    partenza ragionevoli, non tarature. In particolare:            |
//|      - InpGapMinATR 0.3 e InpGapMaxATR 2.0 (ATR D1) delimitano    |
//|        "gap tecnico" contro "gap di rottura": sono la prima       |
//|        ipotesi da falsificare nello scan.                         |
//|      - InpFillPct 100 = fill pieno (il target del corso). 50/75   |
//|        sono le varianti da misurare in A/B.                       |
//|      - InpMaxHours 48 traduce "rapido o niente": due giorni di    |
//|        mercato aperto e poi flat.                                 |
//|      - InpMaxSpreadPts 0 (spento) per NON falsare lo screening    |
//|        OHLC, dove lo spread modellato non e' quello vero. Va      |
//|        ACCESO nei run a tick reali: e' li' che il filtro serve.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Timeframe ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;      // TF operativo su cui si rileva il cambio settimana (SCELTA NOSTRA: H1)

input group "=== Misura del gap (SCELTA NOSTRA: il corso non quantifica) ==="
input int    InpAtrPeriodD1    = 14;    // SCELTA NOSTRA: periodo ATR su PERIOD_D1 (metro della dimensione del gap)
input double InpGapMinATR      = 0.3;   // SCELTA NOSTRA: gap MINIMO in frazioni di ATR(D1). Sotto, lo spread si mangia tutto. 0 = filtro spento
input double InpGapMaxATR      = 2.0;   // SCELTA NOSTRA: gap MASSIMO in frazioni di ATR(D1). Sopra, e' un gap di ROTTURA (news). 0 = nessun tetto

input group "=== Obiettivo (GUIDA: il riallineamento) ==="
input double InpFillPct        = 100.0; // % del gap da riempire. GUIDA: il target e' il riallineamento; 100 = close del venerdi' esatto. 50/75 = SCELTA NOSTRA da misurare

input group "=== Stop loss (SCELTA NOSTRA: il corso non lo specifica) ==="
input int    InpSLMode         = 0;     // 0 = multiplo del GAP oltre l'apertura; 1 = ATR(D1)
input double InpSLGapMult      = 1.0;   // SLMode 0: SL = weekOpen + gap x N (1.0 = rischio simmetrico al gap)
input double InpAtrSlMult      = 1.5;   // SLMode 1: SL = N x ATR(D1) dal prezzo d'ingresso

input group "=== Time-stop (SCELTA NOSTRA: il fill e' rapido, o non e') ==="
input int    InpMaxHours       = 48;    // ore massime in posizione, poi flat a mercato. 0 = spento

input group "=== Finestra d'ingresso e spread (trappola n.1 della tesi) ==="
input int    InpMaxSpreadPts   = 0;     // spread massimo in POINTS all'ingresso. 0 = filtro spento (obbligatorio ACCENDERLO nei run a tick reali)
input int    InpEntryWindowBars= 3;     // SCELTA NOSTRA: barre di InpTF entro cui riprovare se lo spread e' sopra soglia (poi la settimana e' persa)

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;   // Rischio % per operazione (sulla distanza di stop)

input group "=== Generali ==="
input long   InpMagic          = 772201;    // magic number
input string InpComment        = "GAPFILL"; // commento ordini
input bool   InpVerbose        = true;      // log estesi

//==================================================================
//  COSTANTI / STATO
//==================================================================
#define WK_IDLE     0   // nessuna settimana tracciata (avvio a settimana in corso)
#define WK_PENDING  1   // gap valido, in attesa di uno spread accettabile
#define WK_DONE     2   // settimana consumata (entrata fatta, bocciata o finestra esaurita)

//--- confine della settimana: l'epoch 0 e' un GIOVEDI' 00:00, quindi
//    t/604800 taglierebbe la settimana di GIOVEDI', in pieno mercato.
//    Spostando di 2 giorni e mezzo (216000 s) il confine cade il SABATO
//    a meta' giornata, quando nessun mercato e' aperto: cosi' la domenica
//    sera (forex) e il lunedi' mattina (indici) finiscono nello STESSO
//    bucket, che e' esattamente quello che serve al gap del weekend.
#define WEEK_SECONDS   604800
#define WEEK_ANCHOR    216000

int      hAtrD1=INVALID_HANDLE;

datetime gLastBar=0;

//--- stato della settimana in corso
int      gState=WK_IDLE;
long     gWeekId=0;          // identificativo della settimana tracciata
int      gWeekBars=0;        // barre di InpTF gia' aperte in questa settimana (la prima vale 1)
double   gVenClose=0.0;      // close dell'ultima barra della settimana precedente
double   gWeekOpen=0.0;      // open della prima barra della nuova settimana
double   gGap=0.0;           // gGap = gWeekOpen - gVenClose
double   gAtrRef=0.0;        // ATR(D1) congelato al rilevamento del gap

//--- CONTATORI DEL FUNNEL [GAP-FUNNEL] (solo diagnostica, stampati da
//    OnTester: nessun impatto sul CSV, che nasce da FrameAdd/OnTesterDeinit)
long cW_weeks=0, cW_noatr=0, cW_zero=0, cW_min=0, cW_max=0, cW_spread=0, cW_busy=0;
long cO_failTP=0, cO_failSL=0, cO_failLot=0, cO_failSend=0;
long cW_entered=0, cW_buy=0, cW_sell=0;
long cE_tp=0, cE_sl=0, cE_other=0, cO_timestop=0;

//--- METRICHE DA PROP (schema di famiglia): l'Equity DD dice se il conto
//    sopravvive; una prop invece chiude per il LIMITE GIORNALIERO, che e'
//    un'altra cosa. Qui si segue l'equity dentro la giornata e si tiene la
//    caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[GAP] ", m); }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   //--- validazione degli input: meglio un INIT_FAILED che un EA che
   //    opera di nascosto con parametri fuori dominio.
   int secTF=PeriodSeconds(InpTF);
   if(secTF<=0 || secTF>86400)
     { Print("ERRORE: InpTF deve essere <= D1 (il cambio settimana si rileva sulle barre intrasettimanali)."); return(INIT_FAILED); }
   if(InpAtrPeriodD1<1)
     { Print("ERRORE: InpAtrPeriodD1 deve essere >= 1."); return(INIT_FAILED); }
   if(InpGapMinATR<0.0 || InpGapMaxATR<0.0)
     { Print("ERRORE: InpGapMinATR/InpGapMaxATR non possono essere negativi."); return(INIT_FAILED); }
   if(InpGapMaxATR>0.0 && InpGapMaxATR<=InpGapMinATR)
     { Print("ERRORE: InpGapMaxATR deve essere 0 (nessun tetto) oppure maggiore di InpGapMinATR."); return(INIT_FAILED); }
   if(InpFillPct<=0.0 || InpFillPct>100.0)
     { Print("ERRORE: InpFillPct deve stare in (0, 100]."); return(INIT_FAILED); }
   if(InpSLMode<0 || InpSLMode>1)
     { Print("ERRORE: InpSLMode deve essere 0 (multiplo del gap) o 1 (ATR D1)."); return(INIT_FAILED); }
   if(InpSLMode==0 && InpSLGapMult<=0.0)
     { Print("ERRORE: InpSLGapMult deve essere > 0."); return(INIT_FAILED); }
   if(InpSLMode==1 && InpAtrSlMult<=0.0)
     { Print("ERRORE: InpAtrSlMult deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxHours<0)
     { Print("ERRORE: InpMaxHours deve essere >= 0 (0 = time-stop spento)."); return(INIT_FAILED); }
   if(InpMaxSpreadPts<0)
     { Print("ERRORE: InpMaxSpreadPts deve essere >= 0 (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpEntryWindowBars<1)
     { Print("ERRORE: InpEntryWindowBars deve essere >= 1 (1 = solo la prima barra della settimana)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0.0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- ATR su PERIOD_D1: il metro della dimensione del gap deve essere
   //    GIORNALIERO, non del TF operativo (un ATR H1 misura il respiro
   //    di un'ora, non quello che un weekend puo' spostare).
   hAtrD1 = iATR(_Symbol,PERIOD_D1,InpAtrPeriodD1);
   if(hAtrD1==INVALID_HANDLE)
     { Print("ERRORE: creazione handle ATR su D1."); return(INIT_FAILED); }

   //--- RELOAD-SAFE: la settimana in corso al momento dell'avvio viene
   //    marcata come GIA' CONSUMATA. Motivo dichiarato: la sua apertura
   //    NON l'abbiamo osservata (o l'abbiamo gia' operata prima del
   //    riavvio), quindi entrare adesso sarebbe o un ingresso in ritardo
   //    su un gap gia' vecchio o un DOPPIONE. Si costa al massimo una
   //    settimana saltata all'avvio; si evita di raddoppiare il rischio.
   gState=WK_IDLE; gWeekBars=0;
   datetime t0=iTime(_Symbol,InpTF,0);
   if(t0>0)
     {
      gWeekId=WeekId(t0);
      gState=WK_DONE;
      Log(StringFormat("avvio a settimana in corso (id %d): settimana saltata per sicurezza%s.",
          (int)gWeekId, (GiaOperatoQuestaSettimana(gWeekId)?" (risultano gia' deal del magic in questa settimana)":"")));
     }

   Log(StringFormat("avviato su %s %s. ATR(D1,%d). Gap ammesso: %.2f - %s x ATR. Fill %.0f%%. "
                    "SL %s. Time-stop %s. Spread max %s points, finestra %d barre.",
       _Symbol,EnumToString(InpTF),InpAtrPeriodD1,InpGapMinATR,
       (InpGapMaxATR>0.0?DoubleToString(InpGapMaxATR,2):"illimitato"),InpFillPct,
       (InpSLMode==0?StringFormat("%.2f x gap oltre l'apertura",InpSLGapMult)
                    :StringFormat("%.2f x ATR(D1)",InpAtrSlMult)),
       (InpMaxHours>0?StringFormat("%d ore",InpMaxHours):"spento"),
       (InpMaxSpreadPts>0?IntegerToString(InpMaxSpreadPts):"spento"),InpEntryWindowBars));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtrD1!=INVALID_HANDLE){ IndicatorRelease(hAtrD1); hAtrD1=INVALID_HANDLE; }
  }

//==================================================================
//  TICK / NUOVA BARRA
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del
   //    giorno. Sta QUI e non dopo il filtro della nuova barra: la caduta
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

   //--- il time-stop conta ORE, non barre: va sorvegliato a ogni tick
   ManageTimeStop();

   //--- il resto della logica scatta all'APERTURA di una nuova barra di
   //    InpTF: la prima barra della settimana e' l'evento che ci interessa
   //    e la vogliamo al suo primo tick, non a candela chiusa (il gap si
   //    opera alla riapertura, non un'ora dopo).
   datetime t=iTime(_Symbol,InpTF,0);
   if(t<=0 || t==gLastBar) return;
   gLastBar=t;

   OnNewBar();
  }

//==================================================================
//  RILEVAMENTO DEL CAMBIO SETTIMANA
//==================================================================
//--- identificativo della settimana di trading (confine al sabato a meta'
//    giornata, vedi WEEK_ANCHOR). Nessun uso di day_of_week: cosi' funziona
//    identico per chi riapre la domenica sera e per chi riapre il lunedi'.
long WeekId(datetime t)
  {
   return((long)MathFloor(((double)t - (double)WEEK_ANCHOR) / (double)WEEK_SECONDS));
  }

datetime WeekStart(long w)
  {
   return((datetime)(w*(long)WEEK_SECONDS + (long)WEEK_ANCHOR));
  }

void OnNewBar()
  {
   datetime t0=iTime(_Symbol,InpTF,0);   // barra APPENA aperta
   datetime t1=iTime(_Symbol,InpTF,1);   // barra precedente (gia' chiusa)
   if(t0<=0 || t1<=0) return;

   long w0=WeekId(t0);
   if(w0!=WeekId(t1))
     {
      //--- la barra 0 e' la PRIMA della nuova settimana di trading e la
      //    barra 1 e' l'ULTIMA della settimana precedente: e' esattamente
      //    la coppia che definisce il gap del weekend.
      StartWeek(w0, iOpen(_Symbol,InpTF,0), iClose(_Symbol,InpTF,1), t0);
      return;                              // StartWeek ha gia' fatto il 1o tentativo
     }

   if(gState!=WK_PENDING) return;          // niente da fare in questa settimana
   if(gWeekId!=w0) return;                 // settimana non tracciata (paranoia)

   gWeekBars++;                            // altra barra dentro la finestra d'ingresso
   TryEnter();
  }

//==================================================================
//  APERTURA DELLA SETTIMANA: misura del gap e filtri di dimensione
//==================================================================
void StartWeek(long w,double weekOpen,double venClose,datetime tOpen)
  {
   gWeekId=w; gWeekBars=1; gState=WK_DONE;      // di default la settimana e' consumata
   gWeekOpen=weekOpen; gVenClose=venClose;
   gGap=weekOpen-venClose;
   gAtrRef=0.0;
   cW_weeks++;

   //--- guardia anti-doppione (reload-safe, ridondante ma a costo zero):
   //    posizione aperta del mio magic o deal gia' fatti in questa settimana
   if(CountPositions()>0 || GiaOperatoQuestaSettimana(w))
     { cW_busy++; Log("settimana gia' operata / posizione aperta: nessun nuovo ciclo."); return; }

   //--- prezzi non disponibili (storico bucato): nessuna misura possibile
   if(weekOpen<=0.0 || venClose<=0.0)
     { cW_zero++; Log("prezzi di riferimento non disponibili: settimana saltata."); return; }

   double atr=AtrD1();
   if(atr<=0.0)
     { cW_noatr++; Log("ATR(D1) non disponibile: settimana saltata."); return; }
   gAtrRef=atr;

   double ag=MathAbs(gGap);
   //--- gap nullo: nessuna direzione da prendere (e nessuna divisione da fare)
   if(ag<=0.0)
     { cW_zero++; Log("nessun gap alla riapertura: niente da riallineare."); return; }

   if(InpGapMinATR>0.0 && ag < InpGapMinATR*atr)
     {
      cW_min++;
      Log(StringFormat("gap %s (%.2f x ATR) sotto il minimo %.2f x ATR: lo spread se lo mangerebbe.",
          DoubleToString(gGap,_Digits),ag/atr,InpGapMinATR));
      return;
     }
   if(InpGapMaxATR>0.0 && ag > InpGapMaxATR*atr)
     {
      cW_max++;
      Log(StringFormat("gap %s (%.2f x ATR) sopra il massimo %.2f x ATR: gap di ROTTURA, il riallineamento non e' il caso base.",
          DoubleToString(gGap,_Digits),ag/atr,InpGapMaxATR));
      return;
     }

   gState=WK_PENDING;
   Log(StringFormat("GAP VALIDO %s alle %s: venClose %s -> weekOpen %s (gap %s = %.2f x ATR D1). Direzione: %s.",
       (gGap>0.0?"UP":"DOWN"),TimeToString(tOpen,TIME_DATE|TIME_MINUTES),
       DoubleToString(gVenClose,_Digits),DoubleToString(gWeekOpen,_Digits),
       DoubleToString(gGap,_Digits),ag/atr,
       (gGap>0.0?"SELL (contro il gap)":"BUY (contro il gap)")));

   TryEnter();
  }

//==================================================================
//  INGRESSO
//  GUIDA: direzione SEMPRE contro il gap, target il riallineamento.
//  SCELTA NOSTRA: tutto il resto (spread, stop, normalizzazioni).
//==================================================================
void TryEnter()
  {
   //--- TRAPPOLA N.1 DELLA TESI: alla riapertura lo spread e' enorme
   //    PROPRIO quando l'EA vuole entrare. Non si entra "comunque": si
   //    riprova sulle barre successive finche' la finestra regge, poi la
   //    settimana e' persa (meglio zero trade che un trade nato gia' sotto).
   if(!SpreadOK())
     {
      if(gWeekBars>=InpEntryWindowBars)
        {
         cW_spread++; gState=WK_DONE;
         Log(StringFormat("spread %d points sopra il limite %d per tutta la finestra (%d barre): settimana persa.",
             SpreadPoints(),InpMaxSpreadPts,InpEntryWindowBars));
        }
      else
         Log(StringFormat("spread %d points sopra il limite %d: rinvio alla barra successiva (barra %d di %d).",
             SpreadPoints(),InpMaxSpreadPts,gWeekBars,InpEntryWindowBars));
      return;
     }

   //--- da qui in poi la settimana e' comunque consumata: una sola
   //    finestra d'ingresso, nessuna rincorsa (regola dichiarata).
   gState=WK_DONE;

   bool isLong=(gGap<0.0);                 // gap DOWN -> BUY ; gap UP -> SELL
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0.0 || bid<=0.0){ cO_failSend++; Log("prezzi non disponibili: nessun ingresso."); return; }
   double entry=isLong?ask:bid;

   //--- TARGET: TP = weekOpen - gap x InpFillPct/100.
   //    La formula e' UNICA per entrambi i segni del gap:
   //      gap UP  (gGap>0): TP = weekOpen - |gap| x pct  (scende verso venClose)
   //      gap DOWN(gGap<0): TP = weekOpen + |gap| x pct  (sale  verso venClose)
   //    Con InpFillPct=100 il TP e' esattamente il close del venerdi'.
   double tp = gWeekOpen - gGap*InpFillPct/100.0;

   //--- STOP: modo 0 = multiplo del gap OLTRE l'apertura (stesso trucco di
   //    segno: SL = weekOpen + gap x N sta sempre dalla parte giusta);
   //    modo 1 = ATR(D1) dal prezzo d'ingresso.
   //    NOTA DICHIARATA: nel modo 0 lo stop e' ancorato a weekOpen, non al
   //    prezzo d'ingresso. Se abbiamo aspettato lo spread ed entriamo una o
   //    due barre dopo, il rischio reale non e' piu' esattamente N x gap:
   //    e' un livello STRUTTURALE, ed e' voluto cosi'.
   double sl;
   if(InpSLMode==0) sl = gWeekOpen + gGap*InpSLGapMult;
   else             sl = isLong ? entry-InpAtrSlMult*gAtrRef : entry+InpAtrSlMult*gAtrRef;

   sl=NormalizePrice(sl);
   tp=NormalizePrice(tp);

   double minDist=StopsMinDist();

   //--- lo stop deve stare dalla parte giusta E oltre lo stops level
   bool slOk = isLong ? (sl < entry-minDist) : (sl > entry+minDist);
   if(!slOk)
     {
      cO_failSL++;
      Log(StringFormat("SL non valido (%s contro entry %s, distanza minima %s): nessun ingresso.",
          DoubleToString(sl,_Digits),DoubleToString(entry,_Digits),DoubleToString(minDist,_Digits)));
      return;
     }
   //--- il target deve essere ancora DAVANTI: se il gap si e' gia' richiuso
   //    mentre aspettavamo lo spread, il trade non ha piu' ragione di esistere
   bool tpOk = isLong ? (tp > entry+minDist) : (tp < entry-minDist);
   if(!tpOk)
     {
      cO_failTP++;
      Log(StringFormat("target gia' raggiunto o troppo vicino (%s contro entry %s): nessun ingresso.",
          DoubleToString(tp,_Digits),DoubleToString(entry,_Digits)));
      return;
     }

   double risk=isLong?(entry-sl):(sl-entry);
   double lot=LotByRisk(risk);
   if(lot<=0.0){ cO_failLot++; Log("lotto nullo: nessun ingresso."); return; }

   string cm=InpComment+(isLong?" L":" S");
   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(!ok)
     { cO_failSend++; Log("apertura FALLITA: "+gTrade.ResultRetcodeDescription()); return; }

   cW_entered++;
   if(isLong) cW_buy++; else cW_sell++;
   Log(StringFormat("GAP-FILL %s @ %s  SL %s  TP %s  lot %.2f  (gap %s = %.2f x ATR D1, spread %d pts, barra %d della settimana, ordine %s)",
       (isLong?"BUY":"SELL"),DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),
       DoubleToString(tp,_Digits),lot,DoubleToString(gGap,_Digits),
       (gAtrRef>0.0?MathAbs(gGap)/gAtrRef:0.0),SpreadPoints(),gWeekBars,
       IntegerToString((long)gTrade.ResultOrder())));
  }

//==================================================================
//  TIME-STOP: "il fill e' rapido o non e'". Se il riallineamento non
//  arriva entro InpMaxHours, si esce a mercato: oltre quel punto non
//  e' piu' un gap tecnico, e' controtrend puro.
//==================================================================
void ManageTimeStop()
  {
   if(InpMaxHours<=0) return;
   long limite=(long)InpMaxHours*3600;
   datetime tNow=TimeCurrent();

   for(int k=PositionsTotal()-1;k>=0;k--)
     {
      ulong tk=PositionGetTicket(k);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      datetime opened=(datetime)PositionGetInteger(POSITION_TIME);
      if(opened<=0) continue;
      if((long)tNow-(long)opened < limite) continue;

      if(gTrade.PositionClose(tk))
        {
         cO_timestop++;
         Log(StringFormat("TIME-STOP: posizione aperta da oltre %d ore chiusa a mercato (fill non arrivato).",InpMaxHours));
        }
      else
         Log("chiusura per time-stop FALLITA: "+gTrade.ResultRetcodeDescription());
     }
  }

//==================================================================
//  ESITI (per il funnel): TP e SL li dichiara il server, il time-stop
//  lo contiamo noi in ManageTimeStop. Qui NON si contano i time-stop,
//  per non contarli due volte.
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
   if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) return;

   long reason=HistoryDealGetInteger(d,DEAL_REASON);
   if(reason==(long)DEAL_REASON_TP)      cE_tp++;
   else if(reason==(long)DEAL_REASON_SL) cE_sl++;
   else                                  cE_other++;   // include i time-stop, contati a parte
  }

//==================================================================
//  UTILITY
//==================================================================
//--- ATR(D1) allo shift 1: la barra giornaliera CHIUSA. Lo shift 0 alla
//    riapertura e' la candela della domenica sera, lunga pochi minuti:
//    usarla darebbe un metro sbagliato proprio nel momento della misura.
double AtrD1()
  {
   double a[];
   ArraySetAsSeries(a,true);
   int got=CopyBuffer(hAtrD1,0,0,3,a);
   if(got<2) return(0.0);
   double v=a[1];
   if(v<=0.0) v=a[0];
   if(v<=0.0) return(0.0);
   return(v);
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

//--- guardia reload-safe: esiste gia' un ingresso del mio magic dentro la
//    settimana w? Serve dopo un riavvio, quando lo stato in memoria e' perso.
bool GiaOperatoQuestaSettimana(long w)
  {
   datetime tFrom=WeekStart(w);
   datetime tTo  =(datetime)((long)tFrom+(long)WEEK_SECONDS);
   if(!HistorySelect(tFrom,tTo)) return(false);
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
//  FUNNEL DI MORTALITA' [GAP-FUNNEL] (solo Print a fine test).
//  Con ~52 eventi l'anno per simbolo il campione e' piccolo PER
//  COSTRUZIONE: se l'EA resta muto bisogna sapere SUBITO se e'
//  perche' i gap erano sotto soglia, sopra soglia, o perche' lo
//  spread della riapertura ha bruciato la finestra d'ingresso.
//  Nessun impatto sul CSV (che nasce da FrameAdd/OnTesterDeinit).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[GAP-FUNNEL] %s %s  gapMin=%.2f gapMax=%s xATR(D1,%d)  fill=%.0f%%  slMode=%d  maxHours=%d  maxSpread=%d  finestra=%d barre",
               _Symbol,EnumToString(InpTF),InpGapMinATR,
               (InpGapMaxATR>0.0?DoubleToString(InpGapMaxATR,2):"off"),InpAtrPeriodD1,
               InpFillPct,InpSLMode,InpMaxHours,InpMaxSpreadPts,InpEntryWindowBars);
   PrintFormat("[GAP-FUNNEL] SETTIMANE osservate=%d | scartate: gapNullo=%d sottoMin=%d sopraMax=%d atrMancante=%d giaOperata=%d",
               (int)cW_weeks,(int)cW_zero,(int)cW_min,(int)cW_max,(int)cW_noatr,(int)cW_busy);
   PrintFormat("[GAP-FUNNEL] SPREAD  bocciate con finestra esaurita=%d (limite %d points su %d barre)",
               (int)cW_spread,InpMaxSpreadPts,InpEntryWindowBars);
   PrintFormat("[GAP-FUNNEL] ORDINI  scartati in ingresso: tp=%d sl=%d lotto=%d invioFallito=%d  ==> ENTRATE=%d (buy=%d sell=%d)",
               (int)cO_failTP,(int)cO_failSL,(int)cO_failLot,(int)cO_failSend,
               (int)cW_entered,(int)cW_buy,(int)cW_sell);
   PrintFormat("[GAP-FUNNEL] ESITI   fill/TP=%d  SL=%d  altre chiusure=%d (di cui time-stop richiesti=%d) | trade eseguiti=%d",
               (int)cE_tp,(int)cE_sl,(int)cE_other,(int)cO_timestop,
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
