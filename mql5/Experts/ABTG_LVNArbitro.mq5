//+------------------------------------------------------------------+
//|                                    ABTG_LVNArbitro.mq5            |
//|                                                                  |
//|  L'ARBITRO DEL LIVELLO - MT5 - TUTTO-IN-UNO                      |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle,        |
//|   serve solo Include\ABTG_PausaGuardian.mqh, gia' in casa)        |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria - e qui la licenza C'E')             |
//|    Meccanica derivata da "LVN Rejection / Acceptance Strategy"    |
//|    di AIScripts (TradingView, slug j35ygZIm, creato 06/05/2026,   |
//|    57 righe Pine v6, scriptAccess open_no_auth).                  |
//|      https://www.tradingview.com/script/j35ygZIm-LVN-Rejection-Acceptance-Strategy/
//|    LICENZA DEL SORGENTE: Mozilla Public License 2.0 (MPL 2.0),    |
//|    DICHIARATA in testa al sorgente [VERIFICATO l'08/09/2026]:     |
//|      https://mozilla.org/MPL/2.0/                                 |
//|    Copia archiviata in casa:                                      |
//|      backtest_pipeline\caccia_strategie\biblioteca\sorgenti\      |
//|      LvnRejectionAcceptance_AIScripts-MPL2_tvj35ygZIm_2026-09-08.pine
//|    NESSUNA RIGA E' STATA COPIATA: il sorgente e' stato LETTO      |
//|    riga per riga e questo .mq5 e' scritto DA SPECIFICA (referto   |
//|    report\CACCIA_M30_INDICI_2026-09-08.md, candidato P2, e file   |
//|    prova backtest_pipeline\prove\LVNARBITRO_M30_BOZZA.txt).       |
//|    Gestione, prop-hardening, orari, flat di seduta, sizing a      |
//|    rischio e diagnostica sono di casa e NON vengono dalla fonte.  |
//|                                                                  |
//|  !!! IL NOME DELLA FONTE MENTE, E LO DICO SUBITO !!!               |
//|    Nel sorgente NON c'e' nessun Volume Profile e nessun Low       |
//|    Volume Node. La "zona LVN" e' una banda SMA(40) +/- 0,8xATR.   |
//|    Chi promuovesse questo motore PER IL NOME comprerebbe una      |
//|    cosa che non esiste: e' promosso per le SEI RIGHE che lo       |
//|    definiscono, non per il titolo.                                |
//|                                                                  |
//|  COS'E' - LO STESSO BORDO VUOL DIRE DUE COSE OPPOSTE.             |
//|    RIFIUTO      il prezzo perfora il bordo e RIENTRA nella        |
//|                 stessa barra, con volume SOTTO la media: nessuno  |
//|                 lo voleva davvero  ->  si opera IL RITORNO (fade) |
//|    ACCETTAZIONE il prezzo chiude oltre il bordo DUE volte di      |
//|                 fila: il livello e' stato accettato               |
//|                                    ->  si opera LA CONTINUAZIONE  |
//|    L'ARBITRO E' IL MOTORE: togliendo la condizione non resta un   |
//|    motore peggiore, non resta NIENTE - nemmeno la direzione       |
//|    dell'operazione. E' la condizione B di ROBUSTEZZA.md (filtro   |
//|    che E' la strategia: 30 celle su 30) e non la condizione A     |
//|    (filtro appiccicato dopo: 0 successi su 5).                    |
//|                                                                  |
//|  IL LATO NON E' UN INPUT: LO DECIDE IL BORDO.                     |
//|    Bordo BASSO perforato e rientrato   -> LONG  (rifiuto)         |
//|    Bordo ALTO  perforato e rientrato   -> SHORT (rifiuto)         |
//|    Due chiusure sopra il bordo ALTO    -> LONG  (accettazione)    |
//|    Due chiusure sotto il bordo BASSO   -> SHORT (accettazione)    |
//|    InpAllowLong/InpAllowShort e InpUsaRamo* servono a MISURARE i  |
//|    rami e i lati SEPARATAMENTE (regola dei due lati, 25/08, e     |
//|    cancelli C4/C5 del file prova), non a scegliere a tavolino.    |
//|                                                                  |
//|  #### LIMITE NOTO N.1, DICHIARATO IN TESTA: IL VOLUME. ####       |
//|    Il sorgente usa `volume`, che su TradingView per i futures e'  |
//|    VOLUME SCAMBIATO. Su BCM, sugli indici CFD, MT5 espone         |
//|    TICK VOLUME: conta i CAMBI DI PREZZO, non i contratti.         |
//|    >>> NON E' LA STESSA VARIABILE. Il ramo "rifiuto" poggia su un |
//|        numero che sul nostro feed significa un'altra cosa, e puo' |
//|        cambiare segno per questo motivo e per nessun altro.       |
//|    Per questo la soglia e' un INPUT (InpVolFrazione) e il filtro  |
//|    si puo' SPEGNERE (InpUsaFiltroVolume) per misurare quanto pesa |
//|    davvero. E per questo i due rami hanno CONTATORI SEPARATI nel  |
//|    CSV: un risultato aggregato non saprebbe dire se ha fallito il |
//|    meccanismo o la variabile.                                     |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. Il server BCM e' ORA ITALIANA - 1.        |
//|    InpOraInizio/InpOraFine/InpOraFlat sono SEMPRE in ORA SERVER.  |
//|    Un'ora sbagliata qui non da' errore: MISURA UN'ALTRA           |
//|    STRATEGIA (CLAUDE.md, regola fissa).                           |
//|                                                                  |
//|  PROP-HARDENING (di casa, NON del sorgente esterno)               |
//|    - STOP LOSS VERO AL BROKER, allegato all'ordine di mercato.    |
//|      MAI un ingresso senza stop. Nel Pine `strategy.exit` e'      |
//|      chiamato FUORI dal blocco d'ingresso e usa                   |
//|      `strategy.position_avg_price`, che sulla barra d'ingresso    |
//|      vale ancora `na`: LA PRIMA BARRA E' SCOPERTA (su M30 sono    |
//|      30 minuti senza stop). Qui il problema non puo' esistere:    |
//|      lo stop viaggia DENTRO l'ordine.                             |
//|    - PAVIMENTO DI STOP InpMinStopPts (lezione R109) in PUNTI      |
//|      INDICE, MAI zero: OnInit RIFIUTA se e' 0.                    |
//|    - GATE DI SPREAD IN % DELLO STOP (R55): un cancello in punti   |
//|      fissi mente cambiando simbolo, questo no.                    |
//|    - FLAT DI FINE SEDUTA (ora server): ZERO overnight. Il         |
//|      sorgente esterno non ce l'aveva.                             |
//|    - RISCHIO IN % (InpRiskPercent), MAI lotto fisso e MAI         |
//|      percent_of_equity (il Pine usa 5% dell'equity per trade).    |
//|      UNA SOLA posizione, UNA SOLA TRANCHE: il difetto del lotto   |
//|      in tranche (report/FIX_LOTTO_PENDENTE_2026-09-08.md) qui     |
//|      NON PUO' esistere, perche' non c'e' nessuna seconda tranche. |
//|    - GUARDIAN (firme B1/C1 del 18/08) chiamato IMMEDIATAMENTE     |
//|      prima dell'invio, come negli altri EA di casa.               |
//|    - NIENTE martingala, griglia, recovery, averaging,             |
//|      piramidazione, stop virtuali. Ingresso SINGOLO.              |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. La barra si valuta allo shift 1      |
//|    (appena chiusa) e si entra a mercato all'apertura della barra  |
//|    successiva. Niente look-ahead, niente repaint.                 |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola    |
//|  di casa). NON COMPILATO NE' TESTATO da chi ha scritto il file:   |
//|  qui non c'e' MetaEditor. Compilare in MetaEditor (F7) e          |
//|  validare nello Strategy Tester prima di qualunque verdetto.      |
//+------------------------------------------------------------------+
#property copyright "Progetto ABTG - Arbitro del livello (da specifica; meccanica derivata da LVN Rejection/Acceptance di AIScripts, MPL 2.0)"
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

input group "=== MOTORE: la banda e l'arbitro (default = quelli della fonte) ==="
input int    InpBandaLen            = 40;     // Lunghezza SMA della banda E della media dei volumi (fonte: 40)
input double InpBandaAtr            = 0.8;    // Semiampiezza della banda in ATR (fonte: 0,8)
input int    InpAtrLen              = 14;     // Periodo ATR della banda e dello stop (fonte: 14)
input double InpVolFrazione         = 0.8;    // Volume BASSO = tick volume < X x media (fonte: 0,8) -- vedi LIMITE NOTO N.1
input bool   InpUsaFiltroVolume     = true;   // true = come la fonte. false = misura quanto pesa il tick volume (rischio n.1)

input group "=== I DUE RAMI (si misurano SEPARATAMENTE, cancello C5) ==="
input bool   InpUsaRamoRifiuto      = true;   // Ramo RIFIUTO (fade): perforazione + rientro nella stessa barra + volume basso
input bool   InpUsaRamoAccettazione = true;   // Ramo ACCETTAZIONE (breakout): due chiusure di fila oltre lo stesso bordo

input group "=== LATI (regola di casa dei due lati, 25/08) ==="
input bool   InpAllowLong           = true;   // Consenti il ramo LONG
input bool   InpAllowShort          = true;   // Consenti il ramo SHORT

input group "=== SESSIONE (ORA SERVER BCM = ora italiana - 1) ==="
//  DECISIONE DICHIARATA, NON E' DELLA FONTE: il Pine opera 24 ore.
//  La finestra esiste per il costo, non per il motore: fuori sessione
//  lo spread misurato sugli indici BCM raddoppia (DAX 3,5-3,9 punti
//  contro 1,6-1,7 in sessione) e la frontiera stop >= 40 x spread
//  salterebbe. Allargare la finestra e' un input, non una riscrittura.
input int    InpOraInizio           = 8;      // ORA SERVER di apertura della finestra di ingresso (8 = 09:00 IT)
input int    InpMinInizio           = 0;      // MINUTO SERVER di apertura della finestra
input int    InpOraFine             = 20;     // ORA SERVER dell'ULTIMO ingresso ammesso (20:30 = 21:30 IT)
input int    InpMinFine             = 30;     // MINUTO SERVER dell'ultimo ingresso ammesso
input bool   InpUsaFlatSeduta       = true;   // true = ZERO overnight (regola di casa). false = SOLO per esperimenti dichiarati
input int    InpOraFlat             = 21;     // ORA SERVER del flat di fine seduta
input int    InpMinFlat             = 0;      // MINUTO SERVER del flat di fine seduta

input group "=== STOP LOSS (vero, al broker; pavimento R109) ==="
input double InpStopAtr             = 1.5;    // Stop = X x ATR(InpAtrLen) della barra di segnale (fonte: 1,5)
input int    InpMinStopPts          = 25;     // PAVIMENTO SL in PUNTI INDICE (MAI 0: OnInit rifiuta)
input double InpMT5PerPuntoIndice   = 100;    // Punti MT5 (_Point) per 1 punto indice (D30EUR/NASUSD/U30USD: 100)

input group "=== USCITA ==="
input double InpRR                  = 2.0;    // Take profit = InpRR x rischio (R). Fonte: 2,0
input double InpBEatR               = 0.0;    // Breakeven a questo R (0 = SPENTO = come la fonte). E' una MODIFICA dell'ordine

input group "=== Rischio ==="
input double InpRiskPercent         = 0.65;   // Rischio per trade in % (contratto di casa: 0,65)
input double InpMaxSpreadPctOfStop  = 2.5;    // Gate di spread (R55): spread <= X% dello stop, altrimenti si salta
//  0 = ILLIMITATO, cioe' come la fonte (nessun tetto giornaliero).
//  E' il rischio dichiarato di questo candidato: niente gli impedisce
//  3-4 operazioni nello stesso pomeriggio. Si MISURA prima (colonna
//  "Peggior Giornata %" del CSV) e SOLO POI, se serve, si tappa.
input int    InpMaxTradesPerDay     = 0;      // Tetto ingressi per giorno server (0 = illimitato, come la fonte)

input group "=== Generali ==="
input long   InpMagic               = 769900; // Numero magico (VERIFICATO LIBERO nel repo l'08/09/2026)
input string InpComment             = "LVN";  // Commento sugli ordini
input bool   InpVerbose             = true;   // Messaggi nel log

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;

int      gAtrH     = INVALID_HANDLE;
datetime gLastBar  = 0;

//--- marcatore della barra gia' VALUTATA: si timbra PRIMA di mandare
//    l'ordine, cosi' un rifiuto del broker NON produce un secondo
//    tentativo sulla stessa barra. Niente inseguimenti.
long     gBarraValutata = -1;

//--- tetto giornaliero (solo se InpMaxTradesPerDay > 0)
int      gGiornoStamp   = -1;
int      gTradeOggi     = 0;

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

//--- DIAGNOSTICA (solo misura: e' il PASSO 0 letto dal CSV)
long gCntBarre        = 0;   // barre chiuse valutate dentro la finestra
long gCntNoDati       = 0;   // banda/ATR non disponibili (campione incompleto)
long gCntRifiutoLong  = 0;   // segnali GREZZI di rifiuto rialzista
long gCntRifiutoShort = 0;   // segnali GREZZI di rifiuto ribassista
long gCntAccettLong   = 0;   // segnali GREZZI di accettazione rialzista
long gCntAccettShort  = 0;   // segnali GREZZI di accettazione ribassista
long gCntAmbiguo      = 0;   // la barra ha acceso ENTRAMBE le direzioni: si sta fuori
long gCntRamoNo       = 0;   // segnale valido ma quel RAMO e' spento
long gCntLatoNo       = 0;   // segnale valido ma quel LATO e' spento
long gCntGiaAperta    = 0;   // c'era gia' una posizione di questo magic
long gCntFuoriOrario  = 0;   // barre chiuse FUORI dalla finestra di ingresso
long gCntTettoGiorno  = 0;   // ingressi bloccati dal tetto giornaliero
long gCntLong         = 0;   // ingressi LONG eseguiti
long gCntShort        = 0;   // ingressi SHORT eseguiti
long gCntReject       = 0;   // ingressi scartati (spread/geometria/lotto/broker)
long gCntGuardian     = 0;   // ingressi bloccati dal Guardian
long gCntBE           = 0;   // breakeven applicati
long gFlatChiusure    = 0;   // posizioni chiuse dal flat di fine seduta

void Log(string m){ if(InpVerbose) Print("[LVN] ", m); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   Stanno separate apposta: sono quelle che si possono verificare
//   a tavolino contro la specifica, senza MT5.
//
//==================================================================

//--- esito completo dell'arbitro su una barra: i quattro segnali
//    GREZZI (per la diagnostica) e la decisione (per operare).
struct SegnaleLVN
  {
   bool  bullRifiuto;
   bool  bearRifiuto;
   bool  bullAccetta;
   bool  bearAccetta;
   int   dir;        // +1 long, -1 short, 0 niente
   int   ramo;       // 0 nessuno, 1 RIFIUTO, 2 ACCETTAZIONE
   bool  ambiguo;    // entrambe le direzioni accese: si sta fuori
  };

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno.                                    |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| Siamo dentro la finestra di INGRESSO? Estremi compresi. La        |
//| finestra NON attraversa la mezzanotte (garantito da OnInit).      |
//+------------------------------------------------------------------+
bool DentroFinestra_Calc(const int ora,const int minuto,
                         const int daOra,const int daMin,
                         const int aOra,const int aMin)
  {
   int m = ora*60+minuto;
   return(m >= daOra*60+daMin && m <= aOra*60+aMin);
  }

//+------------------------------------------------------------------+
//| Siamo all'ora del flat (o oltre)?                                 |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| L'ARBITRO, in una funzione sola e senza terminale.                |
//|                                                                   |
//| Portato DALLA FONTE alla lettera (righe 27-35 del Pine):          |
//|   bullReject = low < basso  E close > basso E volume basso        |
//|   bearReject = high > alto  E close < alto  E volume basso        |
//|   bullAccept = close > alto  E close[1] > alto                    |
//|   bearAccept = close < basso E close[1] < basso                   |
//|                                                                   |
//| >>> NOTA DI FEDELTA', ed e' una scelta DICHIARATA: nel Pine       |
//|     `close[1] > lvnUpper` confronta la chiusura PRECEDENTE con la |
//|     banda CORRENTE (lvnUpper non e' indicizzato). Qui si fa lo    |
//|     stesso: c2 si confronta con il bordo della barra di segnale,  |
//|     non con il bordo di due barre fa. E' "due chiusure sopra lo   |
//|     STESSO bordo", che e' anche la lettura piu' sensata.          |
//|                                                                   |
//| >>> DECISIONE MIA, non della fonte: se la barra accende ENTRAMBE  |
//|     le direzioni (una barra enorme che perfora i due bordi e      |
//|     chiude dentro), NON SI OPERA. Nel Pine quel caso manda due    |
//|     ordini opposti sulla stessa barra, che non e' una strategia:  |
//|     e' un ribaltamento involontario.                              |
//| >>> DECISIONE MIA: se sulla stessa barra e sullo stesso lato si   |
//|     accendono rifiuto E accettazione, l'operazione si CONTA come  |
//|     RIFIUTO (e' la condizione piu' rara e piu' informativa).      |
//+------------------------------------------------------------------+
void Arbitro_Calc(const double h1,const double l1,const double c1,const double c2,
                  const double bordoAlto,const double bordoBasso,
                  const bool volBasso,
                  const bool usaRifiuto,const bool usaAccettazione,
                  SegnaleLVN &s)
  {
   s.bullRifiuto = false; s.bearRifiuto = false;
   s.bullAccetta = false; s.bearAccetta = false;
   s.dir = 0; s.ramo = 0; s.ambiguo = false;

   if(bordoAlto<=bordoBasso) return;          // banda degenere: niente

   //--- i quattro segnali GREZZI (indipendenti dagli interruttori:
   //    servono ai contatori, che devono dire quante OCCASIONI c'erano)
   s.bullRifiuto = (l1 < bordoBasso && c1 > bordoBasso && volBasso);
   s.bearRifiuto = (h1 > bordoAlto  && c1 < bordoAlto  && volBasso);
   s.bullAccetta = (c1 > bordoAlto  && c2 > bordoAlto);
   s.bearAccetta = (c1 < bordoBasso && c2 < bordoBasso);

   //--- la DECISIONE tiene conto dei rami accesi
   bool bRif = s.bullRifiuto && usaRifiuto;
   bool sRif = s.bearRifiuto && usaRifiuto;
   bool bAcc = s.bullAccetta && usaAccettazione;
   bool sAcc = s.bearAccetta && usaAccettazione;

   bool vaLong  = (bRif || bAcc);
   bool vaShort = (sRif || sAcc);

   if(vaLong && vaShort){ s.ambiguo = true; return; }   // barra contraddittoria: fuori
   if(vaLong) { s.dir = +1; s.ramo = (bRif ? 1 : 2); return; }
   if(vaShort){ s.dir = -1; s.ramo = (sRif ? 1 : 2); return; }
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

   if(InpBandaLen<2)
     { Print("ERRORE: InpBandaLen deve essere >= 2 (e' la SMA della banda e della media dei volumi)."); return(INIT_FAILED); }
   if(InpBandaAtr<=0)
     { Print("ERRORE: InpBandaAtr deve essere > 0. Con banda a larghezza zero il motore non esiste."); return(INIT_FAILED); }
   if(InpAtrLen<2)
     { Print("ERRORE: InpAtrLen deve essere >= 2."); return(INIT_FAILED); }
   if(InpUsaFiltroVolume && InpVolFrazione<=0)
     { Print("ERRORE: con InpUsaFiltroVolume=true serve InpVolFrazione > 0."); return(INIT_FAILED); }
   if(!InpUsaRamoRifiuto && !InpUsaRamoAccettazione)
     { Print("ERRORE: entrambi i rami sono spenti: l'arbitro non potrebbe mai decidere niente."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati sono spenti: l'EA non potrebbe mai operare."); return(INIT_FAILED); }
   if(InpStopAtr<=0)
     { Print("ERRORE: InpStopAtr deve essere > 0. Un ingresso senza stop non si testa."); return(INIT_FAILED); }
   //--- R109: il pavimento dello stop NON puo' essere zero.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0."); return(INIT_FAILED); }
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
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpOraInizio<0 || InpOraInizio>23 || InpMinInizio<0 || InpMinInizio>59)
     { Print("ERRORE: ora/minuto di inizio finestra fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpOraFine<0 || InpOraFine>23 || InpMinFine<0 || InpMinFine>59)
     { Print("ERRORE: ora/minuto di fine finestra fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpOraFlat<0 || InpOraFlat>23 || InpMinFlat<0 || InpMinFlat>59)
     { Print("ERRORE: ora/minuto del flat fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpOraInizio,InpMinInizio) >= MinutiDelGiorno_Calc(InpOraFine,InpMinFine))
     { Print("ERRORE: la finestra NON attraversa la mezzanotte: l'inizio deve precedere la fine."); return(INIT_FAILED); }
   if(InpUsaFlatSeduta && MinutiDelGiorno_Calc(InpOraFine,InpMinFine) >= MinutiDelGiorno_Calc(InpOraFlat,InpMinFlat))
     { Print("ERRORE: il flat deve venire DOPO l'ultimo ingresso ammesso, altrimenti si apre e si chiude nello stesso istante."); return(INIT_FAILED); }

   gAtrH = iATR(_Symbol, gTF, InpAtrLen);
   if(gAtrH==INVALID_HANDLE)
     { Print("ERRORE: handle ATR non creato."); return(INIT_FAILED); }

   gBarraValutata = -1;
   gTicketCorrente = 0;
   gRischioPrezzo  = 0.0;
   gBEfatto        = false;
   gGiornoStamp    = -1;
   gTradeOggi      = 0;

   Log(StringFormat("avviato su %s %s. CONFIG IN USO -> banda SMA(%d) +/- %.2f x ATR(%d) | volume: %s (soglia %.2f x media, TICK VOLUME) | rami: rifiuto=%s accettazione=%s | lati=%s | finestra ingressi %02d:%02d-%02d:%02d SERVER | flat=%s %02d:%02d SERVER | SL=%.2f x ATR | pavimento SL %d pti indice (x%.0f MT5) | TP=%.2fR | BE=%.2fR | rischio=%.2f%% | spread max %.2f%% dello stop | tetto giorno=%d | magic %I64d",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpBandaLen, InpBandaAtr, InpAtrLen,
       (InpUsaFiltroVolume ? "ACCESO" : "SPENTO"), InpVolFrazione,
       (InpUsaRamoRifiuto ? "ON" : "OFF"), (InpUsaRamoAccettazione ? "ON" : "OFF"),
       (InpAllowLong && InpAllowShort ? "long+short" : (InpAllowLong ? "SOLO LONG" : "SOLO SHORT")),
       InpOraInizio, InpMinInizio, InpOraFine, InpMinFine,
       (InpUsaFlatSeduta ? "ON" : "OFF"), InpOraFlat, InpMinFlat,
       InpStopAtr, InpMinStopPts, InpMT5PerPuntoIndice,
       InpRR, InpBEatR, InpRiskPercent, InpMaxSpreadPctOfStop,
       InpMaxTradesPerDay, InpMagic));
   Log("RICORDA: gli orari sono quelli del SERVER (BCM = ora italiana - 1). Un'ora sbagliata non da' errore: misura un'altra strategia.");
   Log("LIMITE NOTO N.1: su CFD il 'volume' e' TICK VOLUME, non volume scambiato. Il ramo RIFIUTO poggia su quella variabile: i due rami hanno contatori separati nel CSV apposta.");
   Log("Ingresso SINGOLO a mercato, una posizione per magic, stop VERO allegato all'ordine. Nessuna aggiunta, media, griglia, recovery o piramidazione.");
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

   ValutaBarra();
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
//| Si valuta la barra allo SHIFT 1 (appena chiusa) e, se l'arbitro   |
//| ha deciso, si entra a mercato adesso: cioe' all'apertura della    |
//| barra successiva. Niente look-ahead, niente repaint.              |
//+------------------------------------------------------------------+
void ValutaBarra()
  {
   datetime t1 = iTime(_Symbol, gTF, 1);
   if(t1<=0) return;

   //--- UNA SOLA VALUTAZIONE PER BARRA: si timbra PRIMA di qualunque
   //    invio, cosi' un rifiuto del broker non fa un secondo tentativo.
   long stamp = (long)t1;
   if(gBarraValutata==stamp) return;
   gBarraValutata = stamp;

   //--- la finestra si giudica sull'ORA DI INGRESSO (adesso), non
   //    sull'ora della barra di segnale.
   MqlDateTime dNow; TimeToStruct(TimeCurrent(),dNow);
   if(!DentroFinestra_Calc(dNow.hour,dNow.min,InpOraInizio,InpMinInizio,InpOraFine,InpMinFine))
     { gCntFuoriOrario++; return; }

   gCntBarre++;

   //--- NOTA DI MISURA, ed e' una scelta: il segnale si CALCOLA anche
   //    quando una posizione e' gia' aperta, e i contatori grezzi lo
   //    registrano lo stesso. Il PASSO 0 deve dire quante OCCASIONI
   //    c'erano, non quante ne abbiamo prese: se le due cifre divergono
   //    molto, il collo di bottiglia e' l'OCCUPAZIONE (una posizione
   //    alla volta), non il motore -- e si legge dal CSV invece di
   //    doverlo indovinare al round dopo.

   //--- servono InpBandaLen chiusure a partire dallo shift 1, piu' la
   //    chiusura allo shift 2 per il ramo accettazione.
   int totali = Bars(_Symbol,gTF);
   if(totali < InpBandaLen + InpAtrLen + 5){ gCntNoDati++; return; }

   double h1 = iHigh (_Symbol,gTF,1);
   double l1 = iLow  (_Symbol,gTF,1);
   double c1 = iClose(_Symbol,gTF,1);
   double c2 = iClose(_Symbol,gTF,2);
   if(h1<=0 || l1<=0 || c1<=0 || c2<=0 || h1<l1){ gCntNoDati++; return; }

   double basis = SmaChiusure(1,InpBandaLen);
   if(basis<=0){ gCntNoDati++; return; }

   double atr = AtrShift(1);
   if(atr<=0){ gCntNoDati++; return; }

   double bordoAlto  = basis + InpBandaAtr*atr;
   double bordoBasso = basis - InpBandaAtr*atr;

   //--- VOLUME BASSO. Su CFD e' TICK VOLUME (limite noto n.1): la
   //    media si calcola sulla stessa finestra della banda, e include
   //    la barra di segnale, esattamente come nella fonte.
   bool volBasso = true;
   if(InpUsaFiltroVolume)
     {
      double mediaVol = MediaTickVolume(1,InpBandaLen);
      if(mediaVol<=0){ gCntNoDati++; return; }
      volBasso = ((double)iTickVolume(_Symbol,gTF,1) < InpVolFrazione*mediaVol);
     }

   SegnaleLVN s;
   Arbitro_Calc(h1,l1,c1,c2,bordoAlto,bordoBasso,volBasso,
                InpUsaRamoRifiuto,InpUsaRamoAccettazione,s);

   //--- contatori dei segnali GREZZI: dicono quante OCCASIONI c'erano,
   //    a prescindere dagli interruttori. E' il PASSO 0.
   if(s.bullRifiuto) gCntRifiutoLong++;
   if(s.bearRifiuto) gCntRifiutoShort++;
   if(s.bullAccetta) gCntAccettLong++;
   if(s.bearAccetta) gCntAccettShort++;

   //--- UNA POSIZIONE PER MAGIC. Il segnale e' gia' stato contato:
   //    qui si rinuncia solo a operarlo.
   if(HoPosizione()){ gCntGiaAperta++; return; }

   if(s.ambiguo){ gCntAmbiguo++; return; }
   if(s.dir==0)
     {
      //--- c'era un segnale grezzo ma il suo RAMO e' spento?
      bool cEraQualcosa = (s.bullRifiuto || s.bearRifiuto || s.bullAccetta || s.bearAccetta);
      if(cEraQualcosa) gCntRamoNo++;
      return;
     }

   if(s.dir>0 && !InpAllowLong ){ gCntLatoNo++; return; }
   if(s.dir<0 && !InpAllowShort){ gCntLatoNo++; return; }

   //--- tetto giornaliero (0 = illimitato, come la fonte)
   if(InpMaxTradesPerDay>0)
     {
      if(dNow.day_of_year != gGiornoStamp){ gGiornoStamp = dNow.day_of_year; gTradeOggi = 0; }
      if(gTradeOggi >= InpMaxTradesPerDay){ gCntTettoGiorno++; return; }
     }

   Entra(s.dir>0, atr, s.ramo);
  }

//+------------------------------------------------------------------+
//| SMA delle chiusure su 'len' barre a partire dallo shift 'da'      |
//| (incluso). Ritorna 0 se i dati non ci sono.                       |
//+------------------------------------------------------------------+
double SmaChiusure(const int da,const int len)
  {
   if(len<1) return(0);
   double somma=0;
   for(int i=0;i<len;i++)
     {
      double c = iClose(_Symbol,gTF,da+i);
      if(c<=0) return(0);
      somma += c;
     }
   return(somma/len);
  }

//+------------------------------------------------------------------+
//| Media del TICK VOLUME su 'len' barre dallo shift 'da' (incluso).  |
//| >>> LIMITE NOTO N.1: sui CFD questo NON e' volume scambiato.      |
//+------------------------------------------------------------------+
double MediaTickVolume(const int da,const int len)
  {
   if(len<1) return(0);
   double somma=0;
   for(int i=0;i<len;i++)
     {
      long v = iTickVolume(_Symbol,gTF,da+i);
      if(v<=0) return(0);
      somma += (double)v;
     }
   return(somma/len);
  }

//+------------------------------------------------------------------+
//| ATR allo shift richiesto (barra CHIUSA).                          |
//+------------------------------------------------------------------+
double AtrShift(const int shift)
  {
   if(gAtrH==INVALID_HANDLE) return(0);
   double a[1];
   if(CopyBuffer(gAtrH,0,shift,1,a)<1) return(0);
   return(a[0]);
  }

//+------------------------------------------------------------------+
//| INGRESSO A MERCATO con STOP VERO allegato all'ordine.             |
//| Nessun ingresso senza stop, mai. E' il difetto della fonte che    |
//| qui non puo' esistere.                                            |
//+------------------------------------------------------------------+
bool Entra(const bool isLong,const double atr,const int ramo)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ gCntReject++; Log("prezzi non disponibili: salto."); return(false); }

   double point    = _Point;
   double stopsLvl = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double pav      = MathMax((double)InpMinStopPts*InpMT5PerPuntoIndice*point, stopsLvl);
   if(pav<=0){ gCntReject++; Log("pavimento SL nullo: salto (R109)."); return(false); }

   double entry = isLong ? ask : bid;

   //--- STOP dalla fonte: InpStopAtr x ATR della barra di segnale.
   double slGrezzo = isLong ? (entry - InpStopAtr*atr) : (entry + InpStopAtr*atr);
   double slFinal  = SlFloor_Calc(isLong, entry, slGrezzo, pav);
   double slDist   = isLong ? (entry-slFinal) : (slFinal-entry);
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
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_LVNArbitro"))
     { gCntGuardian++; return(false); }

   string tag = (ramo==1 ? " RIF" : " ACC");
   string cm  = InpComment + tag + (isLong ? " L" : " S");
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
   if(InpMaxTradesPerDay>0) gTradeOggi++;

   Log(StringFormat("%s ramo %s: lot %.2f | SL %s | TP %s | rischio %.1f pti indice | ATR %.1f pti indice",
       (isLong?"BUY":"SELL"),
       (ramo==1 ? "RIFIUTO (fade del bordo)" : "ACCETTAZIONE (continuazione)"),
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
//| DEFAULT SPENTO (0): la fonte non ce l'ha, e il primo round misura |
//| il motore nudo. Acceso e' un asse in piu' da girare, non un       |
//| miglioramento gia' dimostrato.                                    |
//|                                                                   |
//| NIENTE PARZIALI, ed e' una scelta dichiarata: una posizione, una  |
//| tranche. Il difetto del lotto in tranche corretto oggi in 15      |
//| sorgenti (report/FIX_LOTTO_PENDENTE_2026-09-08.md) qui non puo'   |
//| nemmeno presentarsi.                                              |
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
//| esterno non aveva (il Pine tiene la posizione finche' non prende  |
//| stop o target, anche per giorni).                                 |
//+------------------------------------------------------------------+
bool FlatFineSedutaCheck()
  {
   if(!InpUsaFlatSeduta) return(false);

   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpOraFlat,InpMinFlat)) return(false);

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
                       InpOraFlat, InpMinFlat, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//| Colonna prop: il muro giornaliero non si legge dal DD totale.     |
//| Su QUESTO candidato e' la misura piu' importante del round: e'    |
//| l'unico dei tre promossi senza tetto naturale di operazioni.      |
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
//| sovrapposizione con le sedie vive.                                |
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
   //--- DIAGNOSTICA: e' il PASSO 0 letto dal CSV. I DUE RAMI SONO
   //    SEPARATI apposta (cancello C5 + limite noto n.1 sul volume):
   //    un numero aggregato non saprebbe dire se ha fallito il
   //    meccanismo o la variabile.
   //    L'ordine QUI e l'intestazione in OnTesterDeinit si toccano
   //    SEMPRE INSIEME.
   stats[10] = (double)gCntBarre;
   stats[11] = (double)gCntRifiutoLong;
   stats[12] = (double)gCntRifiutoShort;
   stats[13] = (double)gCntAccettLong;
   stats[14] = (double)gCntAccettShort;
   stats[15] = (double)gCntLong;
   stats[16] = (double)gCntShort;
   stats[17] = (double)gCntReject;
   stats[18] = (double)gCntGuardian;
   stats[19] = (double)gFlatChiusure;

   PrintFormat("[LVN][DIAG] barre=%I64d | rifiutoL=%I64d rifiutoS=%I64d accettL=%I64d accettS=%I64d | ambiguo=%I64d ramoNo=%I64d latoNo=%I64d | long=%I64d short=%I64d | reject=%I64d guardian=%I64d BE=%I64d flat=%I64d noDati=%I64d giaAperta=%I64d fuoriOrario=%I64d tettoGiorno=%I64d",
               gCntBarre, gCntRifiutoLong, gCntRifiutoShort, gCntAccettLong, gCntAccettShort,
               gCntAmbiguo, gCntRamoNo, gCntLatoNo,
               gCntLong, gCntShort, gCntReject, gCntGuardian, gCntBE,
               gFlatChiusure, gCntNoDati, gCntGiaAperta, gCntFuoriOrario, gCntTettoGiorno);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Barre Valutate,Rifiuto Long,Rifiuto Short,Accett Long,Accett Short,Long,Short,Reject,Guardian,Flat Chiusure";
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
