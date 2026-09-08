//+------------------------------------------------------------------+
//|                                    ABTG_ImpulsoApertura.mq5       |
//|                                                                  |
//|  IMPULSO D'APERTURA - MT5 - TUTTO-IN-UNO                         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle,        |
//|   serve solo Include\ABTG_PausaGuardian.mqh, gia' in casa)        |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria, e la licenza NON c'e'):             |
//|    Motore ispirato a "Market Open Impulse [LuciTech]" di          |
//|    @TradesLuci (TradingView, id fd3aaa16c57f4a75b712fa311c62594a, |
//|    creato 12/08/2025, 205 righe Pine v5, scriptAccess             |
//|    open_no_auth). Il sorgente NON dichiara nessuna licenza:       |
//|    e' stato LETTO, non copiato. Questo .mq5 e' scritto DA         |
//|    SPECIFICA (referto report/CACCIA_APERTURE_ORO_2026-09-08.md e  |
//|    file prova backtest_pipeline/prove/ABTG_ImpulsoApertura.txt),  |
//|    non tradotto riga per riga. Gestione, prop-hardening, orari,   |
//|    flat di seduta, sizing e diagnostica sono di casa.             |
//|                                                                  |
//|  COS'E' - LA CANDELA D'APERTURA E' IL SEGNALE, MA SOLO SE E'      |
//|  IMPULSIVA.                                                      |
//|    Alla campanella arriva insieme tutto l'ordine accumulato       |
//|    fuori sessione. Se la PRIMA barra della seduta e' ANOMALA      |
//|    (range >= K x ATR) e chiude nella meta' del suo range dalla    |
//|    parte del movimento, l'ordine non e' stato assorbito: si va    |
//|    A FAVORE del drive. Se la barra e' una qualunque, NON SI       |
//|    OPERA: senza il gate di ampiezza non esiste nessun segnale.    |
//|    E' la condizione B di ROBUSTEZZA.md - il filtro E' il motore,  |
//|    non un cerotto appiccicato dopo.                              |
//|                                                                  |
//|  IL LATO NON E' UN INPUT: LO DECIDE LA BARRA.                     |
//|    close > punto medio E close > open  -> LONG                   |
//|    close < punto medio E close < open  -> SHORT                  |
//|    altrimenti nessun trade.                                      |
//|    Per questo il motore produce NATIVAMENTE il DAX SHORT e il     |
//|    NASDAQ LONG, i due lati che le cacce precedenti non trovavano. |
//|    InpAllowLong / InpAllowShort servono a MISURARE i due rami     |
//|    SEPARATAMENTE (regola di casa dei due lati, 25/08), non a      |
//|    scegliere una direzione a tavolino.                            |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. Il server BCM e' ORA ITALIANA - 1.        |
//|    DAX (D30EUR)          apertura 09:00 IT = 08:00 SERVER         |
//|    Nasdaq/Dow (NAS/U30)  apertura 15:30 IT = 14:30 SERVER         |
//|    InpOpenHour/InpOpenMinute e InpFlatHour/InpFlatMinute sono     |
//|    SEMPRE in ORA SERVER. Un'ora sbagliata qui non da' errore:     |
//|    MISURA UN'ALTRA STRATEGIA (CLAUDE.md, regola fissa).           |
//|                                                                  |
//|  IL TF LO DECIDE IL CANCELLO DI COSTO, NON IL GUSTO.              |
//|    Frontiera di casa: pavimento DURO stop >= 13,3 x spread, DI    |
//|    LAVORO stop >= 40 x spread. Su D30EUR/NASUSD/U30USD lo stop    |
//|    naturale misurato e' 20 punti indice a M5 e 17,4 a M15: sotto  |
//|    la soglia. M30 e' il primo TF che entra nella banda utile, ed  |
//|    e' per questo che il file prova dice @PERIODO M30.             |
//|                                                                  |
//|  PROP-HARDENING (di casa, NON del sorgente esterno)               |
//|    - STOP LOSS VERO AL BROKER, allegato all'ordine di mercato.    |
//|      MAI un ingresso senza stop, mai uno stop solo nel codice.    |
//|    - PAVIMENTO DI STOP InpMinStopPts (lezione R109) in PUNTI      |
//|      INDICE, MAI zero: OnInit RIFIUTA se e' 0.                    |
//|    - GATE DI SPREAD IN % DELLO STOP (R55): lo spread al momento   |
//|      dell'ingresso non puo' superare InpMaxSpreadPctOfStop% dello |
//|      stop. Un cancello in punti fissi mente cambiando simbolo.    |
//|    - FLAT DI FINE SEDUTA obbligatorio (ora server): ZERO          |
//|      overnight. Il sorgente esterno NON ce l'aveva: e' il suo     |
//|      unico difetto vero, e questa e' la parte che sappiamo rifare.|
//|    - RISCHIO IN % (InpRiskPercent), MAI lotto fisso. UNA SOLA     |
//|      posizione, UNA sola tranche: il difetto del lotto in tranche |
//|      (report/FIX_LOTTO_PENDENTE_2026-09-08.md) qui NON PUO'       |
//|      esistere, perche' non c'e' nessuna seconda tranche.          |
//|    - UN SOLO TENTATIVO PER SEDUTA, anche in caso di rifiuto del   |
//|      broker: il marcatore di seduta si timbra PRIMA di mandare    |
//|      l'ordine. Niente inseguimenti.                              |
//|    - GUARDIAN (firme B1/C1 del 18/08) chiamato IMMEDIATAMENTE     |
//|      prima dell'invio, come negli altri EA di casa.               |
//|    - NIENTE martingala, griglia, recovery, averaging,             |
//|      piramidazione, stop virtuali. Ingresso SINGOLO.              |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. La barra d'apertura si valuta allo   |
//|    shift 1 (barra appena chiusa) e si entra a mercato all'apertura|
//|    della barra successiva. Niente look-ahead, niente repaint.     |
//|    Equivale al calc_on_every_tick=false del sorgente Pine.        |
//|                                                                  |
//|  NOTA CORRELAZIONE (non e' codice, e' un cancello del round).     |
//|    Alla campanella gia' operano 770101 (DAX Apertura, SOLO LONG), |
//|    770202 (Dow Apertura, SOLO LONG) e 770611 (ORB-EMA200 Dow,     |
//|    SOLO LONG). Il cancello C4 del file prova pretende che i       |
//|    GIORNI-SEGNALE del ramo LONG siano confrontati con quelli      |
//|    delle sedie vive PRIMA del verdetto: se coincidono, il ramo    |
//|    long non diversifica e va scartato. Il ramo SHORT non collide  |
//|    con nessuno: e' li' che sta il valore atteso del round.        |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola    |
//|  di casa). NON COMPILATO NE' TESTATO da chi ha scritto il file:   |
//|  qui non c'e' MetaEditor. Compilare in MetaEditor (F7) e          |
//|  validare nello Strategy Tester prima di qualunque verdetto.      |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG - Impulso d'Apertura (da specifica, motore ispirato a Market Open Impulse [LuciTech], nessuna licenza dichiarata)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Guardian del conto (firme B1/C1 del 18/08) ==="
//  true = prima di APRIRE chiede il via libera al guardiano del conto.
//  Nel tester le sue GlobalVariable non esistono: la guardia lascia
//  passare tutto (fail-open), quindi i backtest restano confrontabili.
input bool   InpUsaGuardian         = true;   // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)

input group "=== MOTORE: la barra d'apertura impulsiva ==="
input double InpImpulseATRMult      = 1.5;    // GATE COSTITUTIVO: range della barra >= K x ATR (senza, nessun segnale)
input int    InpATRPeriod           = 14;     // Quante barre di riferimento per l'ATR
//  DECISIONE DICHIARATA (non e' del sorgente esterno, e' nostra).
//  true  = il riferimento e' la MEDIA DEI RANGE (high-low) delle ultime
//          InpATRPeriod BARRE D'APERTURA delle sedute precedenti. E' la
//          lettura naturale di "quanto e' anomala QUESTA apertura
//          rispetto alle aperture normali", e tiene il gate MORDENTE.
//  false = ATR standard di Wilder sul TF del grafico, letto alla barra
//          PRECEDENTE l'impulso (shift 2: la barra non entra nel metro
//          che la giudica).
//  PERCHE' il default e' true: su un CFD che quota ~23 ore l'ATR di TF
//  attorno all'apertura e' fatto di barre notturne sottili, e la barra
//  d'apertura le supera QUASI SEMPRE -> il gate diventerebbe decorativo
//  e il cancello C5 boccerebbe il motore per colpa del metro, non del
//  motore. Con InpATRSuAperture=false si misura anche l'altra lettura.
input bool   InpATRSuAperture       = true;   // Riferimento ATR: true=media range delle aperture precedenti, false=ATR di TF (shift 2)

input group "=== LATI (regola di casa dei due lati, 25/08) ==="
//  Si gira DUE VOLTE, una corsa per ramo, e si riporta separato.
input bool   InpAllowLong           = true;   // Consenti il ramo LONG
input bool   InpAllowShort          = true;   // Consenti il ramo SHORT

input group "=== SESSIONE (ORA SERVER BCM = ora italiana - 1) ==="
input int    InpOpenHour            = 8;      // ORA SERVER della barra d'apertura (DAX 8, Nasdaq/Dow 14)
input int    InpOpenMinute          = 0;      // MINUTO SERVER della barra d'apertura (DAX 0, Nasdaq/Dow 30)
input int    InpFlatHour            = 21;     // ORA SERVER del flat di fine seduta (zero overnight)
input int    InpFlatMinute          = 0;      // MINUTO SERVER del flat di fine seduta

input group "=== STOP LOSS (vero, al broker; pavimento R109) ==="
input int    InpSLMode              = 0;      // 0 = CANDELA (min/max della barra d'impulso, strutturale) | 1 = ATR
input double InpSLAtrMult           = 0.5;    // (solo InpSLMode=1) stop = X x ATR di riferimento
input int    InpMinStopPts          = 25;     // PAVIMENTO SL in PUNTI INDICE (MAI 0: OnInit rifiuta)
input double InpMT5PerPuntoIndice   = 100;    // Punti MT5 (_Point) per 1 punto indice (D30EUR/NASUSD/U30USD: 100)

input group "=== USCITA ==="
input double InpRR                  = 3.0;    // Take profit = InpRR x rischio (R)
input double InpBEatR               = 2.0;    // Breakeven a questo R (0 = spento). E' una MODIFICA dell'ordine, non chiude niente

input group "=== Rischio ==="
input double InpRiskPercent         = 0.65;   // Rischio per trade in % (contratto di casa: 0,65)
input double InpMaxSpreadPctOfStop  = 2.5;    // Gate di spread (R55): spread <= X% dello stop, altrimenti si salta

input group "=== Generali ==="
input long   InpMagic               = 769800; // Numero magico (blocco 7698xx: VERIFICATO LIBERO nel repo l'08/09/2026)
input string InpComment             = "IMPULSO"; // Commento sugli ordini
input bool   InpVerbose             = true;   // Messaggi nel log

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;

int      gAtrH     = INVALID_HANDLE;   // usato SOLO se InpATRSuAperture=false
datetime gLastBar  = 0;

//--- marcatore della seduta gia' TENTATA: e' l'ora della barra
//    d'apertura valutata. Si timbra PRIMA di mandare l'ordine, cosi'
//    un rifiuto del broker NON produce un secondo tentativo.
long     gSessioneTentata = -1;

//--- breakeven: una volta sola per posizione, legata al ticket
ulong    gTicketCorrente  = 0;
double   gRischioPrezzo   = 0.0;   // R in PREZZO della posizione viva
bool     gBEfatto         = false;

int      gFlatLogGiorno   = -1;

//--- peggior giornata in % (colonna prop)
double   gDayStartEquity  = 0.0;
double   gDayMinEquity    = 0.0;
double   gWorstDayPct     = 0.0;
int      gDayEqStamp      = -1;

//--- DIAGNOSTICA (solo misura: e' il PASSO 0 che si legge dal CSV)
long gCntAperture   = 0;   // barre d'apertura valutate
long gCntNoDati     = 0;   // riferimento ATR non disponibile (campione incompleto)
long gCntGateOk     = 0;   // barre che PASSANO il gate di ampiezza
long gCntGateNo     = 0;   // barre che NON passano il gate
long gCntDirNo      = 0;   // gate passato ma chiusura ambigua (nessuna direzione)
long gCntLatoNo     = 0;   // direzione buona ma quel lato e' spento
long gCntGiaAperta  = 0;   // c'era gia' una posizione di questo magic
long gCntLong       = 0;   // ingressi LONG eseguiti
long gCntShort      = 0;   // ingressi SHORT eseguiti
long gCntReject     = 0;   // ingressi scartati (spread/geometria/lotto/broker)
long gCntGuardian   = 0;   // ingressi bloccati dal Guardian
long gCntBE         = 0;   // breakeven applicati
long gFlatChiusure  = 0;   // posizioni chiuse dal flat di fine seduta

void Log(string m){ if(InpVerbose) Print("[IMPULSO] ", m); }

bool LatoLongOk()  { return(InpAllowLong);  }
bool LatoShortOk() { return(InpAllowShort); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Stanno separate apposta: sono quelle che si possono verificare
//   a tavolino contro la specifica, senza MT5.
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
//| Siamo all'ora del flat (o oltre)? La seduta NON attraversa la     |
//| mezzanotte: apertura < flat e' garantito da OnInit.               |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| IL MOTORE, in una funzione sola e senza terminale.                |
//|   1. il GATE: range >= mult x atr   (se no: nessun segnale)       |
//|   2. la DIREZIONE la decide la barra, non un input:               |
//|      close > medio E close > open -> +1                           |
//|      close < medio E close < open -> -1                           |
//|      altrimenti 0.                                                |
//| Ritorna +1 (long), -1 (short), 0 (niente).                        |
//| 'gatePassato' dice se e' stato il GATE a fermare tutto: serve a    |
//| separare "barra non impulsiva" da "barra impulsiva ma ambigua".   |
//+------------------------------------------------------------------+
int DirezioneImpulso_Calc(const double o,const double h,const double l,const double c,
                          const double atr,const double mult,bool &gatePassato)
  {
   gatePassato = false;
   if(atr<=0 || mult<=0) return(0);
   double range = h-l;
   if(range<=0) return(0);
   if(range < mult*atr) return(0);          // barra qualunque: NON SI OPERA
   gatePassato = true;
   double medio = l + range/2.0;
   if(c>medio && c>o) return(+1);
   if(c<medio && c<o) return(-1);
   return(0);                                // impulsiva ma ambigua: si sta fuori
  }

//+------------------------------------------------------------------+
//| PAVIMENTO DI STOP (R109). Se lo stop grezzo e' piu' stretto del   |
//| pavimento, lo si allarga; non lo si stringe mai.                  |
//+------------------------------------------------------------------+
double SlFloor_Calc(const bool isLong,const double entry,
                    const double slGrezzo,const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R>=pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE (per i log).      |
//+------------------------------------------------------------------+
double PrezzoInPuntiIndice_Calc(const double distPrezzo,
                                const double mt5PerIdx,const double point)
  {
   double den = mt5PerIdx*point;
   if(den<=0) return(0);
   return(distPrezzo/den);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpImpulseATRMult<=0)
     { Print("ERRORE: InpImpulseATRMult deve essere > 0. Senza il gate di ampiezza questo motore non esiste."); return(INIT_FAILED); }
   if(InpATRPeriod<2)
     { Print("ERRORE: InpATRPeriod deve essere >= 2."); return(INIT_FAILED); }
   if(InpSLMode<0 || InpSLMode>1)
     { Print("ERRORE: InpSLMode deve essere 0 (CANDELA) o 1 (ATR)."); return(INIT_FAILED); }
   if(InpSLMode==1 && InpSLAtrMult<=0)
     { Print("ERRORE: con InpSLMode=1 (ATR) serve InpSLAtrMult > 0."); return(INIT_FAILED); }
   //--- R109: il pavimento dello stop NON puo' essere zero.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un ingresso senza pavimento non si testa."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0 (indici BCM: 100)."); return(INIT_FAILED); }
   if(InpRR<=0)
     { Print("ERRORE: InpRR deve essere > 0."); return(INIT_FAILED); }
   if(InpBEatR<0)
     { Print("ERRORE: InpBEatR non puo' essere negativo (0 = breakeven spento)."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0. Il lotto fisso qui non esiste."); return(INIT_FAILED); }
   if(InpMaxSpreadPctOfStop<=0)
     { Print("ERRORE: InpMaxSpreadPctOfStop deve essere > 0 (R55: il cancello di spread e' in % dello stop)."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati sono spenti: l'EA non potrebbe mai operare."); return(INIT_FAILED); }
   if(InpOpenHour<0 || InpOpenHour>23 || InpOpenMinute<0 || InpOpenMinute>59)
     { Print("ERRORE: ora/minuto di apertura fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpFlatHour<0 || InpFlatHour>23 || InpFlatMinute<0 || InpFlatMinute>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpOpenHour,InpOpenMinute) >= MinutiDelGiorno_Calc(InpFlatHour,InpFlatMinute))
     { Print("ERRORE: la seduta NON attraversa la mezzanotte: l'apertura deve precedere il flat."); return(INIT_FAILED); }

   //--- L'ORA D'APERTURA DEVE CADERE SU UN CONFINE DI BARRA, altrimenti
   //    la barra d'apertura non esiste e l'EA non opererebbe MAI, in
   //    silenzio. Un EA che non puo' operare deve dirlo in avvio.
   long per = PeriodSeconds(gTF);
   if(per<=0)
     { Print("ERRORE: periodo del grafico non leggibile."); return(INIT_FAILED); }
   if(((long)MinutiDelGiorno_Calc(InpOpenHour,InpOpenMinute)*60) % per != 0)
     {
      PrintFormat("ERRORE: l'ora d'apertura %02d:%02d NON cade su un confine di barra del TF %s: la barra d'apertura non esisterebbe MAI e l'EA non opererebbe, in silenzio. Cambia TF o orario.",
                  InpOpenHour, InpOpenMinute, EnumToString((ENUM_TIMEFRAMES)Period()));
      return(INIT_FAILED);
     }

   if(!InpATRSuAperture)
     {
      gAtrH = iATR(_Symbol, gTF, InpATRPeriod);
      if(gAtrH==INVALID_HANDLE)
        { Print("ERRORE: handle ATR non creato."); return(INIT_FAILED); }
     }

   gSessioneTentata = -1;
   gTicketCorrente  = 0;
   gRischioPrezzo   = 0.0;
   gBEfatto         = false;

   Log(StringFormat("avviato su %s %s. CONFIG IN USO -> gate=%.2f x ATR(%d) [rif=%s] | lati=%s | apertura %02d:%02d SERVER | flat %02d:%02d SERVER | SL=%s (atrMult %.2f) | pavimento SL %d pti indice (x%.0f MT5) | TP=%.2fR | BE=%.2fR | rischio=%.2f%% | spread max %.2f%% dello stop | magic %I64d",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpImpulseATRMult, InpATRPeriod,
       (InpATRSuAperture ? "media range aperture" : "ATR di TF shift 2"),
       (InpAllowLong && InpAllowShort ? "long+short" : (InpAllowLong ? "SOLO LONG" : "SOLO SHORT")),
       InpOpenHour, InpOpenMinute, InpFlatHour, InpFlatMinute,
       (InpSLMode==0 ? "CANDELA (strutturale)" : "ATR"), InpSLAtrMult,
       InpMinStopPts, InpMT5PerPuntoIndice,
       InpRR, InpBEatR, InpRiskPercent, InpMaxSpreadPctOfStop, InpMagic));
   Log("RICORDA: gli orari sono quelli del SERVER (BCM = ora italiana - 1). DAX 08:00, Nasdaq/Dow 14:30. Un'ora sbagliata non da' errore: misura un'altra strategia.");
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione: motore intraday, niente overnight. Ingresso SINGOLO a mercato, una posizione per magic, stop VERO allegato all'ordine. Nessuna aggiunta, media, griglia o recovery.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(gAtrH!=INVALID_HANDLE)
     {
      IndicatorRelease(gAtrH);
      gAtrH = INVALID_HANDLE;
     }
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   GestisciBreakeven();                 // la gestione della posizione viva NON passa dal Guardian

   if(FlatFineSedutaCheck()) return;    // fine seduta: chiudo, niente overnight

   if(!IsNewBar()) return;              // le DECISIONI solo a barra chiusa

   ValutaBarraApertura();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t<=0) return(false);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//==================================================================
//  IL MOTORE, lato terminale
//==================================================================

//+------------------------------------------------------------------+
//| Si valuta la barra allo SHIFT 1 (appena chiusa). Se e' LA barra   |
//| d'apertura della seduta, si decide e si entra a mercato adesso,   |
//| cioe' all'apertura della barra successiva.                        |
//+------------------------------------------------------------------+
void ValutaBarraApertura()
  {
   datetime t1 = iTime(_Symbol, gTF, 1);
   if(t1<=0) return;

   MqlDateTime d; TimeToStruct(t1,d);
   if(d.hour!=InpOpenHour || d.min!=InpOpenMinute) return;   // non e' la barra d'apertura

   //--- UN SOLO TENTATIVO PER SEDUTA: si timbra PRIMA di qualunque
   //    invio, cosi' un rifiuto del broker non fa un secondo tentativo.
   long stamp = (long)t1;
   if(gSessioneTentata==stamp) return;
   gSessioneTentata = stamp;

   gCntAperture++;

   if(HoPosizione()){ gCntGiaAperta++; return; }   // una posizione per magic

   double o = iOpen (_Symbol,gTF,1);
   double h = iHigh (_Symbol,gTF,1);
   double l = iLow  (_Symbol,gTF,1);
   double c = iClose(_Symbol,gTF,1);
   if(o<=0 || h<=0 || l<=0 || c<=0 || h<l){ gCntNoDati++; return; }

   double atr = RiferimentoATR();
   if(atr<=0){ gCntNoDati++; return; }             // campione incompleto: NON si opera

   bool gatePassato=false;
   int dir = DirezioneImpulso_Calc(o,h,l,c,atr,InpImpulseATRMult,gatePassato);

   if(!gatePassato){ gCntGateNo++; return; }
   gCntGateOk++;
   if(dir==0){ gCntDirNo++; return; }

   if(dir>0 && !LatoLongOk() ){ gCntLatoNo++; return; }
   if(dir<0 && !LatoShortOk()){ gCntLatoNo++; return; }

   Entra(dir>0, h, l, atr);
  }

//+------------------------------------------------------------------+
//| RIFERIMENTO ATR per il gate (e, in InpSLMode=1, per lo stop).      |
//|                                                                   |
//|  InpATRSuAperture=true  -> media dei range (high-low) delle ultime |
//|    InpATRPeriod BARRE D'APERTURA precedenti. Se il campione non e' |
//|    completo si ritorna 0 e NON SI OPERA (le prime sedute della     |
//|    finestra restano fuori: e' voluto e va dichiarato nel referto). |
//|  InpATRSuAperture=false -> ATR di Wilder sul TF, letto allo SHIFT 2|
//|    cioe' alla barra PRECEDENTE l'impulso: la barra non entra nel   |
//|    metro che la giudica.                                          |
//+------------------------------------------------------------------+
double RiferimentoATR()
  {
   if(!InpATRSuAperture)
     {
      if(gAtrH==INVALID_HANDLE) return(0);
      double a[1];
      if(CopyBuffer(gAtrH,0,2,1,a)<1) return(0);
      return(a[0]);
     }

   int totali = Bars(_Symbol,gTF);
   if(totali<10) return(0);

   //--- quanto indietro guardare: InpATRPeriod sedute + margine per
   //    weekend e festivi. Il ciclo gira UNA volta al giorno.
   int perGiorno = BarrePerGiornoPieno();
   int limite = 2 + perGiorno*(InpATRPeriod+8) + 10;
   if(limite > totali-1) limite = totali-1;

   double somma=0; int trovate=0;
   for(int s=2; s<=limite && trovate<InpATRPeriod; s++)
     {
      datetime tt = iTime(_Symbol,gTF,s);
      if(tt<=0) break;
      MqlDateTime dd; TimeToStruct(tt,dd);
      if(dd.hour!=InpOpenHour || dd.min!=InpOpenMinute) continue;
      double hh = iHigh(_Symbol,gTF,s);
      double ll = iLow (_Symbol,gTF,s);
      if(hh<=0 || ll<=0 || hh<ll) continue;
      somma += (hh-ll);
      trovate++;
     }
   if(trovate<InpATRPeriod) return(0);   // campione incompleto: si sta fuori
   return(somma/trovate);
  }

//+------------------------------------------------------------------+
//| INGRESSO A MERCATO con STOP VERO allegato all'ordine.             |
//| Nessun ingresso senza stop, mai.                                  |
//+------------------------------------------------------------------+
bool Entra(const bool isLong,const double barHigh,const double barLow,const double atr)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ gCntReject++; Log("prezzi non disponibili: salto."); return(false); }

   double point    = _Point;
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double pav      = MathMax((double)InpMinStopPts*InpMT5PerPuntoIndice*point, stopsLvl);
   if(pav<=0){ gCntReject++; Log("pavimento SL nullo: salto (R109)."); return(false); }

   double entry = isLong ? ask : bid;

   //--- STOP: strutturale sulla barra d'impulso (default) oppure ATR.
   double slGrezzo;
   if(InpSLMode==0) slGrezzo = isLong ? barLow : barHigh;
   else             slGrezzo = isLong ? (entry - InpSLAtrMult*atr) : (entry + InpSLAtrMult*atr);

   double slFinal = SlFloor_Calc(isLong, entry, slGrezzo, pav);
   double slDist  = isLong ? (entry-slFinal) : (slFinal-entry);
   if(slDist<=0){ gCntReject++; Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- GATE DI SPREAD IN % DELLO STOP (R55): un cancello in punti
   //    fissi mente cambiando simbolo, questo no.
   double spreadPrezzo = ask-bid;
   if(spreadPrezzo > (InpMaxSpreadPctOfStop/100.0)*slDist)
     {
      gCntReject++;
      Log(StringFormat("spread %.1f pti indice = oltre il %.2f%% dello stop (%.1f pti indice): salto.",
          PrezzoInPuntiIndice_Calc(spreadPrezzo,InpMT5PerPuntoIndice,point),
          InpMaxSpreadPctOfStop,
          PrezzoInPuntiIndice_Calc(slDist,InpMT5PerPuntoIndice,point)));
      return(false);
     }

   double tp = isLong ? (entry + InpRR*slDist) : (entry - InpRR*slDist);

   double sP = NormalizePrice(slFinal);
   double tP = NormalizePrice(tp);

   //--- lo stops-level e' gia' dentro il pavimento; il TP lo si
   //    controlla comunque, perche' InpRR potrebbe essere piccolo.
   if(MathAbs(tP-entry) < stopsLvl)
     {
      tP = isLong ? (entry+stopsLvl) : (entry-stopsLvl);
      tP = NormalizePrice(tP);
     }

   double lot = LotByRisk(slDist);
   if(lot<=0){ gCntReject++; Log("lotto nullo (rischio troppo piccolo o simbolo non calcolabile): salto."); return(false); }

   //--- GUARDIAN: IMMEDIATAMENTE prima dell'invio, mai in cima
   //    all'imbuto (regola del referto di migrazione, par. 1.3).
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ImpulsoApertura"))
     { gCntGuardian++; return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sP,tP,cm)
                    : gTrade.Sell(lot,_Symbol,0.0,sP,tP,cm);
   if(!ok)
     {
      gCntReject++;
      Log(StringFormat("ingresso %s FALLITO: %s (retcode %d)",
          (isLong?"BUY":"SELL"), gTrade.ResultRetcodeDescription(), (int)gTrade.ResultRetcode()));
      return(false);
     }

   if(isLong) gCntLong++; else gCntShort++;
   Log(StringFormat("%s a mercato: lot %.2f | SL %s | TP %s | rischio %.1f pti indice | ATR rif %.1f pti indice",
       (isLong?"BUY (apertura impulsiva al rialzo)":"SELL (apertura impulsiva al ribasso)"),
       lot, DoubleToString(sP,_Digits), DoubleToString(tP,_Digits),
       PrezzoInPuntiIndice_Calc(slDist,InpMT5PerPuntoIndice,point),
       PrezzoInPuntiIndice_Calc(atr,InpMT5PerPuntoIndice,point)));
   return(true);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE VIVA
//==================================================================

//+------------------------------------------------------------------+
//| BREAKEVEN a InpBEatR volte R, come MODIFICA dell'ordine: non      |
//| chiude niente, non tocca il TP. Una volta sola per posizione.     |
//|                                                                   |
//| Il valore di R si prende dallo stop VERO del broker la prima volta|
//| che si vede il ticket: cosi' funziona anche dopo un riavvio del   |
//| terminale con la posizione gia' aperta (allora lo stop e' ancora  |
//| quello iniziale, perche' il BE non e' stato fatto).               |
//+------------------------------------------------------------------+
void GestisciBreakeven()
  {
   if(InpBEatR<=0) return;

   ulong tk = TicketMio();
   if(tk==0){ gTicketCorrente=0; gRischioPrezzo=0.0; gBEfatto=false; return; }

   double apert = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl    = PositionGetDouble(POSITION_SL);
   double tp    = PositionGetDouble(POSITION_TP);
   long   tipo  = PositionGetInteger(POSITION_TYPE);
   bool   isLong = (tipo==POSITION_TYPE_BUY);

   if(tk!=gTicketCorrente)
     {
      gTicketCorrente = tk;
      gRischioPrezzo  = isLong ? (apert-sl) : (sl-apert);
      //--- se lo stop e' gia' a pari (o oltre) il BE e' gia' stato fatto
      gBEfatto = (gRischioPrezzo<=0);
     }
   if(gBEfatto || gRischioPrezzo<=0) return;

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return;

   double avanzamento = isLong ? (bid-apert) : (apert-ask);
   if(avanzamento < InpBEatR*gRischioPrezzo) return;

   //--- lo stop nuovo deve rispettare lo stops-level, altrimenti il
   //    broker rifiuta: se non ci sta ancora, si riprova al tick dopo.
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(isLong  && apert > bid-stopsLvl) return;
   if(!isLong && apert < ask+stopsLvl) return;

   double nuovoSL = NormalizePrice(apert);
   if(gTrade.PositionModify(tk,nuovoSL,tp))
     {
      gBEfatto = true;
      gCntBE++;
      Log(StringFormat("BREAKEVEN a %.2fR: stop portato a pari (%s). Nessuna chiusura, il TP resta.",
          InpBEatR, DoubleToString(nuovoSL,_Digits)));
     }
   else
      Log("breakeven FALLITO: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA: zero overnight. E' la parte che il sorgente  |
//| esterno non aveva.                                                |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpFlatHour,InpFlatMinute)) return(false);

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

   if(chiuse>0 && t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
                       InpFlatHour, InpFlatMinute, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//| Colonna prop: il muro giornaliero non si legge dal DD totale.     |
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

//--- barre di un GIORNO PIENO (~24h / TF): dimensiona la ricerca storica.
int BarrePerGiornoPieno()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=1800;
   int b = (int)(86400/per);
   return(b<10?10:b);
  }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int    dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//+------------------------------------------------------------------+
//| LOTTO DAL RISCHIO, in UNA SOLA TRANCHE.                           |
//|  Il difetto del 08/09 (pavimento del lotto minimo applicato DOPO  |
//|  il calcolo della seconda tranche, che raddoppiava il volume) qui |
//|  NON PUO' esistere: non c'e' nessuna seconda tranche. E' la forma |
//|  semplice, scelta apposta.                                        |
//|  Perdita per lotto chiesta al BROKER (OrderCalcProfit converte in |
//|  valuta conto); il tick value resta come ripiego, perche' su certi|
//|  simboli arriva non convertito e il lotto uscirebbe al minimo.    |
//+------------------------------------------------------------------+
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   if(risk<=0) return(0);

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

//+------------------------------------------------------------------+
//| Il ticket della MIA posizione sul simbolo (hedge-safe: simbolo +  |
//| magic, mai PositionSelect(_Symbol) che prende la prima qualunque).|
//| Se ritorna != 0 la posizione e' anche SELEZIONATA.                |
//+------------------------------------------------------------------+
ulong TicketMio()
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

bool HoPosizione(){ return(TicketMio()!=0); }

//==================================================================
//  OPTFRAME (incorporato) - raccolta risultati -> CSV
//  L'EA deve avere OnTester: senza, il driver rifiuta di partire.
//==================================================================
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE nella cartella COMUNE: una riga per posizione    |
//| chiusa. Serve al DD di PORTAFOGLIO e alla misura della            |
//| sovrapposizione con le sedie vive (cancelli C4 e C9).             |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","comment");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
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
                DoubleToString(net,2),
                HistoryDealGetString(tk,DEAL_COMMENT));
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[20];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne "va bene per una prop?"
   stats[7] = gWorstDayPct;
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);
   //--- DIAGNOSTICA: e' il PASSO 0 (cancelli C0 e C5) letto dal CSV.
   //    L'ordine QUI e l'intestazione in OnTesterDeinit si toccano
   //    SEMPRE INSIEME.
   stats[10] = (double)gCntAperture;
   stats[11] = (double)gCntGateOk;
   stats[12] = (double)gCntGateNo;
   stats[13] = (double)gCntDirNo;
   stats[14] = (double)gCntLatoNo;
   stats[15] = (double)gCntLong;
   stats[16] = (double)gCntShort;
   stats[17] = (double)gCntReject;
   stats[18] = (double)gCntGuardian;
   stats[19] = (double)gFlatChiusure;

   PrintFormat("[IMPULSO][DIAG] aperture=%I64d | gateOk=%I64d gateNo=%I64d dirNo=%I64d latoNo=%I64d | long=%I64d short=%I64d | reject=%I64d guardian=%I64d BE=%I64d flat=%I64d noDati=%I64d giaAperta=%I64d",
               gCntAperture, gCntGateOk, gCntGateNo, gCntDirNo, gCntLatoNo,
               gCntLong, gCntShort, gCntReject, gCntGuardian, gCntBE,
               gFlatChiusure, gCntNoDati, gCntGiaAperta);

   double criterion = stats[3];     // Recovery Factor (robusto), come gli altri EA di casa
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Aperture Valutate,Gate OK,Gate NO,Dir Ambigua,Lato Spento,Long,Short,Reject,Guardian,Flat Chiusure";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12], data[13], data[14],
                                data[15], data[16], data[17], data[18], data[19]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
