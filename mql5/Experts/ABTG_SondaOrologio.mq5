//+------------------------------------------------------------------+
//|                                        ABTG_SondaOrologio.mq5     |
//|                                                                  |
//|  LA SONDA DELL'OROLOGIO -- STRUMENTO DI MISURA, NON STRATEGIA     |
//|  (metti in MQL5\Experts e compila con F7: nessun include di casa) |
//|                                                                  |
//|  ==============================================================  |
//|  QUESTO FILE NON E' UN EA DA MANDARE IN CAMPO.                    |
//|  E' il METRO del PASSO 0 del candidato P1 della caccia intraday   |
//|  forex/oro del 28/08/2026. Produce una TABELLA, non un P/L.       |
//|    dossier : caccia_strategie/CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md
//|              (sezione "L'OROLOGIO", P1, voto 9/10)                |
//|    prova   : backtest_pipeline/prove/SONDA_OROLOGIO_FX.txt        |
//|              (ipotesi, criteri C1-C7 e specifica, CONGELATI)      |
//|  C7 dei criteri: "Nessuna promozione da questa corsa. Questa      |
//|  sonda non promuove niente e non tocca nessuna sedia viva:        |
//|  produce una tabella."                                            |
//|  ==============================================================  |
//|                                                                  |
//|  L'IPOTESI CHE MISURA (scritta PRIMA di qualunque numero)         |
//|    Una valuta tende a deprezzarsi durante le proprie ore di       |
//|    contrattazione locali, perche' in quelle ore i partecipanti    |
//|    locali sono compratori netti di valuta estera: pagano          |
//|    l'estero quando i loro uffici sono aperti. Non e' un pattern   |
//|    di prezzo, e' un flusso d'ordini che ha un orario d'ufficio.   |
//|    Fonti (scheda bibliografica verificata, TESTO NON LETTO):      |
//|      Breedon & Ranaldo, JMCB 2013, 45(5), 953-965.               |
//|      Krohn, Mueller, Whelan, Journal of Finance 2024.            |
//|                                                                  |
//|  LA DOMANDA, IN UNA RIGA                                          |
//|    "Il LORDO medio di un blocco di ore vale almeno TRE VOLTE lo   |
//|     spread mediano misurato IN QUELLA STESSA ORA?"                |
//|    Il rapporto NON si calcola a valle: esce come COLONNA          |
//|    ("Rapporto Lordo Su Spread"), cosi' nessuno lo puo' sbagliare  |
//|    in un foglio.                                                  |
//|                                                                  |
//|  L'UNICO INGRESSO E' L'OROLOGIO DEL SERVER. E' il vincolo che     |
//|  rende la misura una misura:                                      |
//|    - nessuna media, nessuna banda, nessun ADX, nessun livello;    |
//|    - NESSUNA condizione di prezzo di nessun tipo per entrare;     |
//|    - nessun filtro di volatilita', di notizie o di spread acceso. |
//|  Se entrasse UNA SOLA condizione di prezzo, la sonda smetterebbe  |
//|  di misurare l'orologio e comincerebbe a misurare un motore --    |
//|  che e' un altro round.                                            |
//|                                                                  |
//|  >>> L'UNICO INDICATORE DEL FILE E' L'ATR, E NON TOCCA            |
//|      L'INGRESSO. Serve a due cose sole: dimensionare lo STOP DI   |
//|      SOLA PROTEZIONE (10 x ATR, praticamente mai toccato: serve   |
//|      a non lasciare una posizione nuda se il broker salta         |
//|      un'uscita) e, di conseguenza, il LOTTO. La decisione di      |
//|      entrare non lo legge mai.                                     |
//|                                                                  |
//|  L'ORA E' SEMPRE ORA SERVER (BCM = ora italiana - 1).             |
//|  SCELTA FIRMATA, con l'errore noto DICHIARATO (criterio C6):      |
//|  la sonda misura in ORA SERVER FISSA, non in ora locale della     |
//|  piazza. Gli uffici di Londra e New York si spostano rispetto     |
//|  all'ora server per ~4 settimane l'anno (ora legale USA e UE non  |
//|  coincidenti; il Giappone non cambia). L'errore c'e', e' noto, e  |
//|  il referto lo scrive. Non e' nascosto: e' il prezzo della        |
//|  versione semplice, pagato consapevolmente.                       |
//|                                                                  |
//|  ---------------------------------------------------------------- |
//|  LA CHIUSURA FORZATA DI FINE GIORNATA -- NON DISATTIVABILE        |
//|  ---------------------------------------------------------------- |
//|  Nasce dal mandato FTMO del 28/08/2026: MAI OVERNIGHT. E' scritta |
//|  in modo che NESSUN INPUT possa spegnerla, nemmeno per errore di  |
//|  configurazione:                                                   |
//|    1. non esiste nessun bool che la accenda o la spenga;          |
//|    2. l'unico input vicino, InpFlatAnticipoMin, sposta il flat     |
//|       PIU' PRESTO (mai piu' tardi) ed e' ammesso solo fra 0 e     |
//|       720 minuti (OnInit rifiuta il resto);                        |
//|    3. anche con un valore fuori range MinutiFlat_Calc lo tosa     |
//|       comunque, quindi il flat esiste per aritmetica, non per     |
//|       disciplina di chi configura;                                 |
//|    4. con anticipo 0 il flat cade alle 23:59 ORA SERVER: cioe'    |
//|       l'ultimo minuto della giornata di contrattazione.            |
//|  L'idea del flat ANTICIPATO di N minuti (invece che sull'ultima   |
//|  barra) e' rubata a "SP500 Session Gap Fade Strategy" (c exlux,   |
//|  MPL 2.0, TradingView J1U1NNgx): l'ultima mezz'ora ha lo spread   |
//|  peggiore e i riempimenti peggiori.                                |
//|                                                                    |
//|  >>> IL LIMITE VERO DEL FLAT, DICHIARATO: vive dentro OnTick. Se  |
//|      il simbolo smette di mandare tick prima dell'ora di flat, la |
//|      chiusura slitta al primo tick utile. Per questo esiste la    |
//|      colonna "Notti Attraversate": conta le volte in cui una      |
//|      posizione era ancora viva al cambio di giornata del server.  |
//|      DEVE essere ZERO. Se non lo e', il flat non e' ermetico su   |
//|      quel simbolo e va detto, non interpretato.                   |
//|                                                                    |
//|  ---------------------------------------------------------------- |
//|  COME SI LEGGE IL "LORDO" -- definizione, perche' senza e' aria   |
//|  ---------------------------------------------------------------- |
//|  LORDO = deriva del mercato fra l'istante d'ingresso e l'istante  |
//|  d'uscita, misurata SEMPRE SUL BID (stesso riferimento nei due    |
//|  versi):                                                           |
//|      long : (bid_uscita - bid_ingresso) / _Point                   |
//|      short: (bid_ingresso - bid_uscita) / _Point                   |
//|  Usare il bid da tutte e due le parti toglie lo spread DALLA      |
//|  MISURA: quello che resta e' la deriva pura, che e' esattamente   |
//|  la grandezza che il criterio C1 vuole confrontare con 3 x lo     |
//|  spread. Se misurassimo il risultato ESEGUITO (ask->bid) lo       |
//|  spread sarebbe gia' dentro, e il confronto lo conterebbe DUE     |
//|  VOLTE.                                                            |
//|  Il LORDO IN VALUTA e' lo stesso numero convertito:                |
//|      punti x valore-per-punto x lotti  della singola operazione.   |
//|  Dipende quindi dalla TAGLIA, e la taglia esce da un rischio       |
//|  calcolato su uno stop di 10 ATR: e' un numero CONDIZIONATO, non  |
//|  il rendimento di una strategia. Va letto insieme ai punti.        |
//|                                                                    |
//|  ---------------------------------------------------------------- |
//|  LO SPREAD SI MISURA NELL'ISTANTE IN CUI SI PAGA (lezione R55)    |
//|  ---------------------------------------------------------------- |
//|  Il campione dello spread e' preso (ask-bid)/_Point ESATTAMENTE   |
//|  nell'istante dell'ingresso, un campione per operazione. Non e'   |
//|  la media della giornata e non e' la media dell'ora: e' il prezzo |
//|  che quella sonda ha davvero pagato. Escono MEDIANA e P95         |
//|  (rango piu' vicino) come due colonne separate.                    |
//|  E' UNA SPESA SOLA PER OPERAZIONE, non due: si entra all'ask e si |
//|  esce al bid (o viceversa), quindi il giro completo costa uno     |
//|  spread, quello d'ingresso.                                        |
//|                                                                    |
//|  ---------------------------------------------------------------- |
//|  PERCHE' LA DIAGNOSTICA E' IN COLONNE E NON IN Print              |
//|  ---------------------------------------------------------------- |
//|  In OTTIMIZZAZIONE le Print girano SUGLI AGENT e non le legge     |
//|  nessuno (CHECKLIST punto 34, ribadito al punto 99). Un autotest  |
//|  che stampasse "DIVERGE" su un agent non fermerebbe niente. Qui   |
//|  TUTTO quello che serve a giudicare -- compreso l'esito           |
//|  dell'autotest -- esce nell'OPTFRAME, cioe' in colonne del CSV.   |
//|                                                                    |
//|  E NON C'E' NESSUN EXPORT PER-TRADE: con 72 celle che condividono |
//|  lo stesso magic ogni passata sovrascriverebbe la precedente (e'  |
//|  la trappola gia' scritta nel referto FVGRET). Tutto quello che   |
//|  serve sta in colonna.                                             |
//|                                                                    |
//|  ---------------------------------------------------------------- |
//|  NON HA IL GUARDIAN, ED E' VOLUTO                                 |
//|  ---------------------------------------------------------------- |
//|  Nessun #include <ABTG_PausaGuardian.mqh>: questa sonda NON VA    |
//|  MAI ATTACCATA A UN GRAFICO VIVO. Vive nel tester e basta (C7).   |
//|  Aggiungere il Guardian avrebbe aggiunto una dipendenza da        |
//|  installare per una macchina che non deve mai operare.            |
//|                                                                    |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le     |
//|  stringhe, niente emoji (regola di casa dei .ps1, estesa qui      |
//|  perche' i log finiscono negli stessi strumenti).                 |
//|  NON compilato ne' testato da chi ha scritto il file: in          |
//|  quell'ambiente non esistono MetaEditor ne' Strategy Tester.      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - sonda di misura, non strategia"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//--- tetto di sicurezza al numero di campioni di spread conservati.
//    15,5 anni x ~250 giornate = ~3.900 operazioni: 8.000 e' abbondante
//    e non alloca a caso.
#define SO_MAX_CAMPIONI 8000

//--- i tre motivi d'uscita, e sono TUTTI e SOLI questi.
#define SO_USCITA_ORA   0
#define SO_USCITA_FLAT  1
#define SO_USCITA_STOP  2

//==================================================================
//  INPUT
//  I NOMI SONO QUELLI PINNATI DAL FILE PROVA CONGELATO
//  (prove/SONDA_OROLOGIO_FX.txt). Non si rinominano: il driver
//  generico si ferma se un nome del file prova non esiste nell'EA,
//  e -- peggio -- MT5 ignorerebbe in silenzio un nome sbagliato.
//==================================================================
input group "=== L'OROLOGIO -- l'UNICO ingresso della sonda ==="
input int    InpOraIngresso     = 8;      // Ora SERVER d'ingresso (0-23). E' l'asse spazzolato
input int    InpOreDurata       = 4;      // Durata del blocco in ORE. Secondo asse (4/8/12)
input bool   InpAllowLong       = true;   // Lato LONG  (i due lati si misurano in DUE CORSE SEPARATE)
input bool   InpAllowShort      = false;  // Lato SHORT (esattamente UNO dei due dev'essere acceso)

input group "=== Stop di SOLA PROTEZIONE (mai un target) ==="
input double InpSLatrMult       = 10.0;   // Stop = X * ATR. 10 = praticamente mai toccato
input int    InpATRPeriod       = 14;     // Periodo ATR (serve SOLO allo stop e al lotto)
input double InpTPatrMult       = 0.0;    // Take = X * ATR. 0 = NESSUN TAKE: si esce all'ORA, mai al prezzo

input group "=== Perimetro operativo ==="
input int    InpMaxPositions    = 1;      // Posizioni contemporanee di questo magic
input int    InpMaxTradesPerDay = 1;      // Ingressi al giorno
input int    InpMaxSpreadPts    = 0;      // Filtro spread in punti MT5. 0 = SPENTO: lo spread si MISURA, non si filtra

input group "=== CHIUSURA FORZATA DI FINE GIORNATA (non disattivabile) ==="
//--- NON esiste un interruttore. Questo input sposta il flat solo PIU'
//    PRESTO, e OnInit rifiuta qualunque valore fuori da 0..720.
input int    InpFlatAnticipoMin = 30;     // Minuti PRIMA di fine giornata server in cui si chiude comunque (0..720)

input group "=== Rischio ==="
input double InpRiskPercent     = 1.0;    // Rischio per operazione, % dell'equity, sulla distanza dello stop

input group "=== Generali ==="
input string InpComment         = "OROLOGIO"; // Commento sugli ordini
input long   InpMagic           = 777200;     // Numero magico (blocco 7772xx: VERGINE, verificato nel repo il 28/08/2026)
input bool   InpVerbose         = true;       // Messaggi nel log (in ottimizzazione NON li legge nessuno: vedi le colonne)
input bool   InpAutoTest        = true;       // Esegue l'autotest del nucleo puro in OnInit (l'esito esce in COLONNA)

//==================================================================
//  STATO
//==================================================================
int      hAtr = INVALID_HANDLE;

datetime gLastBar        = 0;
int      gDayOper        = -1;      // giorno di calendario per il cap giornaliero
int      gTradesToday    = 0;

//--- IL LATO DELLA CORSA, deciso UNA VOLTA in OnInit a partire da
//    ENTRAMBI gli interruttori. Non si rilegge InpAllowLong da solo
//    nel giro operativo: il lato della misura e' una proprieta' della
//    corsa, e dev'essere la stessa cosa che finisce nella colonna.
bool     gLatoLong       = true;

//--- la posizione viva
ulong    gTicket         = 0;
bool     gIsLong         = true;
datetime gTimeIngresso   = 0;
double   gBidIngresso    = 0.0;
double   gLottoIngresso  = 0.0;
int      gDayIngresso    = -1;
bool     gNotteContata   = false;

//--- GLI ACCUMULATORI DELLA MISURA. Tutti finiscono in COLONNA.
int      gNOper              = 0;    // giornate operate
double   gSommaDriftPunti    = 0.0;
double   gSommaDriftValuta   = 0.0;
int      gNPositive          = 0;
double   gSommaOreTenuta     = 0.0;
int      gUsciteOra          = 0;
int      gUsciteFlat         = 0;
int      gUsciteStop         = 0;    // stop 10 ATR oppure posizione ORFANA: attesa ~0
int      gNottiAttraversate  = 0;    // DEVE essere 0: il flat non e' ermetico se non lo e'
int      gLottiAlMinimo      = 0;    // volte in cui il lotto da rischio era sotto il minimo del broker
int      gGiorniSaltatiSpread= 0;    // canarino: con InpMaxSpreadPts=0 DEVE essere 0

double   gSpread[];                  // un campione per operazione, preso quando si paga
int      gNSpread            = 0;

//--- COLLAUDO. -1 = autotest non eseguito (che NON e' "passato").
int      gAutotestFalliti    = -1;

//--- peggior giornata in % di equity (numero NEGATIVO) -- criterio C4
double   gDayStartEquity = 0.0;
double   gDayMinEquity   = 0.0;
double   gWorstDayPct    = 0.0;
int      gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[OROLOGIO] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| L'INGRESSO, PER INTERO. Non c'e' altro: si confronta l'ora della  |
//| barra con l'ora voluta. Nessun prezzo entra in questa funzione,   |
//| e non ci sono altri parametri da passarle.                         |
//+------------------------------------------------------------------+
bool OraDiIngresso_Calc(const int oraBarra, const int oraIngresso)
  {
   if(oraBarra < 0 || oraBarra > 23)       return(false);
   if(oraIngresso < 0 || oraIngresso > 23) return(false);
   return(oraBarra == oraIngresso);
  }

//+------------------------------------------------------------------+
//| L'USCITA A TEMPO: sono passate almeno oreDurata ore dall'ingresso?|
//| Il confronto e' in SECONDI, non in barre: cosi' una barra mancante|
//| (festivo, buco del feed) non allunga il blocco in silenzio.        |
//| oreDurata <= 0 vorrebbe dire "chiudi subito": si esce vero, cosi'  |
//| una configurazione assurda non lascia una posizione eterna.        |
//+------------------------------------------------------------------+
bool DurataScaduta_Calc(const datetime adesso, const datetime ingresso, const int oreDurata)
  {
   if(oreDurata <= 0) return(true);
   return((long)adesso - (long)ingresso >= (long)oreDurata*3600);
  }

//+------------------------------------------------------------------+
//| MINUTO DEL GIORNO (ora server) OLTRE IL QUALE SI E' FLAT.          |
//| 24*60-1 = 1439 = 23:59, cioe' l'ultimo minuto della giornata.      |
//| L'anticipo viene TOSATO qui dentro a 0..720: e' la terza delle     |
//| quattro difese che rendono il flat non disattivabile. Anche        |
//| chiamandola con -99999 o con 99999 il flat esiste comunque.        |
//+------------------------------------------------------------------+
int MinutiFlat_Calc(const int anticipoMin)
  {
   int a = anticipoMin;
   if(a < 0)   a = 0;
   if(a > 720) a = 720;
   return(24*60 - 1 - a);
  }

//+------------------------------------------------------------------+
//| SIAMO NELLA FINESTRA DI FLAT? Vale per la CHIUSURA (si chiude) e  |
//| per l'INGRESSO (non si apre): aprire dentro la finestra vorrebbe  |
//| dire pagare uno spread per una posizione che muore nello stesso   |
//| istante, e sarebbe rumore, non misura.                             |
//+------------------------------------------------------------------+
bool DevoFlat_Calc(const int ora, const int minuto, const int anticipoMin)
  {
   return(ora*60 + minuto >= MinutiFlat_Calc(anticipoMin));
  }

//+------------------------------------------------------------------+
//| IL LORDO IN PUNTI -- misurato SEMPRE SUL BID nei due versi, cosi'  |
//| lo spread resta FUORI dalla misura (vedi il blocco in testa).      |
//+------------------------------------------------------------------+
double DriftPunti_Calc(const bool isLong, const double bidIn, const double bidOut, const double punto)
  {
   if(punto <= 0) return(0.0);
   double d = (bidOut - bidIn)/punto;
   return(isLong ? d : -d);
  }

//+------------------------------------------------------------------+
//| LOTTO GREZZO dal rischio: quanto rischio in valuta diviso quanto  |
//| costa un lotto se lo stop viene preso.                             |
//| Qualunque ingrediente non valido -> 0 (nessun ordine), mai un      |
//| numero inventato.                                                  |
//+------------------------------------------------------------------+
double LottoGrezzo_Calc(const double equity, const double riskPct,
                        const double distPrezzo, const double valorePerPunto,
                        const double punto)
  {
   if(equity <= 0 || riskPct <= 0 || distPrezzo <= 0 || valorePerPunto <= 0 || punto <= 0) return(0.0);
   double punti    = distPrezzo/punto;
   double perLotto = punti*valorePerPunto;
   if(perLotto <= 0) return(0.0);
   return((equity*riskPct/100.0)/perLotto);
  }

//+------------------------------------------------------------------+
//| NORMALIZZAZIONE AI VINCOLI DI VOLUME DEL SIMBOLO.                  |
//| alMinimo esce VERO quando il lotto da rischio era SOTTO il minimo  |
//| del broker: in quel caso il rischio REALE e' piu' alto di quello   |
//| dichiarato, e il fatto va contato in colonna, non nascosto.        |
//+------------------------------------------------------------------+
double NormalizzaLotto_Calc(const double lotto, const double volMin,
                            const double volMax, const double volStep,
                            bool &alMinimo)
  {
   alMinimo = false;
   if(volStep <= 0 || volMin <= 0) return(0.0);
   double n = MathFloor(lotto/volStep)*volStep;
   if(n < volMin){ n = volMin; alMinimo = true; }
   if(volMax > 0 && n > volMax) n = volMax;
   return(n);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei due centrali|
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| PERCENTILE di un vettore GIA' ORDINATO, metodo del RANGO PIU'      |
//| VICINO (nearest-rank): indice = ceil(p*n)-1. Nessuna              |
//| interpolazione, cosi' il numero che esce e' UNO SPREAD DAVVERO     |
//| VISTO, non una media fra due.                                      |
//+------------------------------------------------------------------+
double PercentileOrdinato_Calc(const double &v[], const int n, const double p)
  {
   if(n <= 0) return(0.0);
   if(p <= 0) return(v[0]);
   if(p >= 1) return(v[n-1]);
   int idx = (int)MathCeil(p*n) - 1;
   if(idx < 0)   idx = 0;
   if(idx > n-1) idx = n-1;
   return(v[idx]);
  }

//+------------------------------------------------------------------+
//| IL CANCELLO C1 IN UNA FUNZIONE: |lordo medio| / spread mediano.    |
//| Spread mediano <= 0 (dato mancante) -> 0, che si legge "non        |
//| misurato", non "rapporto nullo": la colonna e' accompagnata dalla  |
//| colonna dello spread, che in quel caso e' 0 e lo dichiara.         |
//+------------------------------------------------------------------+
double RapportoC1_Calc(const double lordoMedioPunti, const double spreadMediano)
  {
   if(spreadMediano <= 0) return(0.0);
   return(MathAbs(lordoMedioPunti)/spreadMediano);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- I CANCELLI DI CONFIGURAZIONE. Rifiutano, non correggono in
   //    silenzio: un default nascosto e' una misura che dice un'altra
   //    cosa da quella che c'e' scritta nel file prova.
   if(InpOraIngresso < 0 || InpOraIngresso > 23)
     { Print("ERRORE: InpOraIngresso deve stare fra 0 e 23 (ORA SERVER)."); return(INIT_FAILED); }
   if(InpOreDurata < 1 || InpOreDurata > 24)
     { Print("ERRORE: InpOreDurata deve stare fra 1 e 24 ore."); return(INIT_FAILED); }
   if(InpAllowLong == InpAllowShort)
     { Print("ERRORE: dev'essere acceso ESATTAMENTE UN LATO. La regola dei due lati (25/08) vuole DUE CORSE SEPARATE, non una corsa con tutti e due: con tutti e due la colonna 'Lato' non vorrebbe dire niente."); return(INIT_FAILED); }
   if(InpSLatrMult <= 0)
     { Print("ERRORE: InpSLatrMult deve essere > 0: una posizione senza stop di protezione e' una posizione nuda."); return(INIT_FAILED); }
   if(InpATRPeriod < 1)
     { Print("ERRORE: InpATRPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpTPatrMult < 0)
     { Print("ERRORE: InpTPatrMult non puo' essere negativo (0 = nessun take)."); return(INIT_FAILED); }
   if(InpMaxPositions < 1)
     { Print("ERRORE: InpMaxPositions deve essere >= 1."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay < 1)
     { Print("ERRORE: InpMaxTradesPerDay deve essere >= 1."); return(INIT_FAILED); }
   if(InpMaxSpreadPts < 0)
     { Print("ERRORE: InpMaxSpreadPts non puo' essere negativo (0 = filtro spento)."); return(INIT_FAILED); }
   if(InpRiskPercent <= 0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   //--- SECONDA DIFESA DEL FLAT: il range e' un cancello, non un consiglio.
   if(InpFlatAnticipoMin < 0 || InpFlatAnticipoMin > 720)
     { Print("ERRORE: InpFlatAnticipoMin deve stare fra 0 e 720 minuti. La chiusura forzata di fine giornata NON e' disattivabile: questo input la sposta solo piu' presto."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, PERIOD_CURRENT, InpATRPeriod);
   if(hAtr == INVALID_HANDLE)
     { Print("ERRORE: handle ATR non creato."); return(INIT_FAILED); }

   ArrayResize(gSpread, SO_MAX_CAMPIONI);
   gNSpread = 0;

   //--- il lato della corsa: vero solo se il long e' acceso E lo short
   //    e' spento. Il cancello qui sopra ha gia' escluso gli altri due
   //    casi, ma il lato si calcola comunque da tutti e due, cosi' non
   //    esiste nessun percorso in cui la colonna "Lato" dica una cosa
   //    e l'EA ne faccia un'altra.
   gLatoLong = (InpAllowLong && !InpAllowShort);

   //--- DICHIARAZIONI, non correzioni. Se qualcuno accende una di
   //    queste due cose la sonda smette di essere la sonda, e deve
   //    dirlo a voce alta invece di spegnersele da sola.
   if(InpTPatrMult > 0)
      Log("ATTENZIONE: TAKE PROFIT ACCESO. Questa NON e' piu' la sonda dell'orologio: si uscirebbe al PREZZO, e il punto della sonda e' che si esce SOLO all'ORA.");
   if(InpMaxSpreadPts > 0)
      Log("ATTENZIONE: FILTRO DI SPREAD ACCESO. La sonda smette di MISURARE lo spread e comincia a sceglierselo: le ore 'buone' sarebbero le ore di uno spread che ci siamo scelti noi (lezione R55). La colonna 'Giorni Saltati Spread' dira' quante giornate sono sparite.");

   int mf = MinutiFlat_Calc(InpFlatAnticipoMin);
   Log(StringFormat("CHIUSURA FORZATA DI FINE GIORNATA alle %02d:%02d ORA SERVER, incondizionata e NON disattivabile da nessun input (mandato FTMO del 28/08: mai overnight).", mf/60, mf%60));

   if(InpAutoTest) AutoTestOrologio();

   Log(StringFormat("SONDA DI MISURA avviata su %s %s. Ingresso alle %02d:00 ORA SERVER, blocco di %d ore, lato %s, stop di protezione %.1f x ATR(%d), rischio %.2f%%, magic %I64d. NESSUNA condizione di prezzo in ingresso.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpOraIngresso, InpOreDurata, (gLatoLong ? "LONG" : "SHORT"),
       InpSLatrMult, InpATRPeriod, InpRiskPercent, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr != INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
//| L'ORDINE DEI GESTI IN OnTick E' PARTE DELLA SPECIFICA:            |
//|   1. la peggior giornata si aggiorna PRIMA di qualunque chiusura, |
//|      altrimenti una caduta chiusa d'ufficio non verrebbe contata; |
//|   2. la posizione si gestisce a OGNI TICK (il flat e l'uscita a   |
//|      tempo non possono aspettare la barra successiva);            |
//|   3. dentro la gestione il FLAT viene PRIMA dell'uscita a tempo:  |
//|      il flat vince sempre, e' incondizionato;                     |
//|   4. l'ingresso si valuta SOLO all'apertura di una barra nuova.   |
//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   GestisciPosizione();

   if(!NuovaBarra()) return;

   MqlDateTime tn; TimeToStruct(TimeCurrent(), tn);
   if(tn.day_of_year != gDayOper){ gDayOper = tn.day_of_year; gTradesToday = 0; }

   ValutaIngresso();
  }

//+------------------------------------------------------------------+
bool NuovaBarra()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t != gLastBar){ gLastBar = t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| CRITERIO C4 -- la peggior giornata in % di equity. Si aggiorna a  |
//| ogni tick, non a fine giornata: la caduta peggiore succede in     |
//| mezzo a un blocco, non alla sua chiusura.                          |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(), t);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(t.day_of_year != gDayEqStamp)
     {
      gDayEqStamp     = t.day_of_year;
      gDayStartEquity = eq;
      gDayMinEquity   = eq;
     }
   if(eq < gDayMinEquity) gDayMinEquity = eq;
   if(gDayStartEquity > 0)
     {
      double pct = (gDayMinEquity - gDayStartEquity)/gDayStartEquity*100.0;
      if(pct < gWorstDayPct) gWorstDayPct = pct;
     }
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE -- due sole uscite volute (l'ora e il
//  flat) piu' una terza non voluta (lo stop di protezione), che
//  esiste solo per non lasciare mai una posizione nuda.
//==================================================================
void GestisciPosizione()
  {
   //--- caso ORFANO: nessun ticket in memoria ma una posizione di
   //    questo magic esiste comunque (riavvio, chiusura fallita e
   //    ticket perso). Si chiude SUBITO: "mai overnight" viene prima
   //    di qualunque eleganza. Il fatto finisce in colonna insieme
   //    agli stop, che devono essere ~0 tutti e due.
   if(gTicket == 0)
     {
      ulong orfana = TrovaPosizione();
      if(orfana != 0)
        {
         Log("posizione ORFANA trovata senza ticket in memoria: la chiudo subito.");
         if(gTrade.PositionClose(orfana)) gUsciteStop++;
        }
      return;
     }

   if(!PositionSelectByTicket(gTicket))
     {
      //--- la posizione non c'e' piu' e non l'abbiamo chiusa noi:
      //    l'ha presa lo stop di protezione. Rilevato al primo tick
      //    successivo, quindi il bid usato e' quello di QUESTO tick:
      //    scostamento di un tick, dichiarato. La colonna
      //    "Uscite Stop O Orfane" dice quante volte e' successo.
      RegistraOperazione(SymbolInfoDouble(_Symbol, SYMBOL_BID), SO_USCITA_STOP);
      return;
     }

   MqlDateTime tn; TimeToStruct(TimeCurrent(), tn);

   //--- il canarino del flat: una posizione viva al cambio di giornata
   //    del server vuol dire che il flat NON e' stato ermetico.
   if(tn.day_of_year != gDayIngresso && !gNotteContata)
     {
      gNottiAttraversate++;
      gNotteContata = true;
      Log("ATTENZIONE: posizione ancora viva al cambio di giornata del server. Il flat non ha trovato tick in tempo.");
     }

   //--- IL FLAT VIENE PRIMA. Sempre. Incondizionato.
   if(DevoFlat_Calc(tn.hour, tn.min, InpFlatAnticipoMin)){ Chiudi(SO_USCITA_FLAT); return; }

   //--- poi l'uscita a tempo, che e' il gesto normale della sonda.
   if(DurataScaduta_Calc(TimeCurrent(), gTimeIngresso, InpOreDurata)) Chiudi(SO_USCITA_ORA);
  }

//+------------------------------------------------------------------+
//| Chiusura: il bid si legge PRIMA di mandare l'ordine, cosi' il     |
//| lordo e' misurato sul mercato che c'era, non su quello che c'e'   |
//| dopo il riempimento. Se la chiusura fallisce NON si registra      |
//| niente e si ritenta al tick dopo (e se dovesse fallire fino al    |
//| cambio giorno, "Notti Attraversate" lo dice).                      |
//+------------------------------------------------------------------+
void Chiudi(const int motivo)
  {
   double bidOut = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!gTrade.PositionClose(gTicket))
     {
      Log(StringFormat("chiusura NON riuscita (retcode %d): ritento al tick successivo.", gTrade.ResultRetcode()));
      return;
     }
   RegistraOperazione(bidOut, motivo);
  }

//+------------------------------------------------------------------+
//| REGISTRA L'OPERAZIONE NELLA MISURA. E' l'unico posto in cui gli   |
//| accumulatori crescono: un solo punto da leggere per capire cosa   |
//| finisce in tabella.                                                |
//+------------------------------------------------------------------+
void RegistraOperazione(const double bidOut, const int motivo)
  {
   double drift = DriftPunti_Calc(gIsLong, gBidIngresso, bidOut, _Point);

   gNOper++;
   gSommaDriftPunti  += drift;
   gSommaDriftValuta += drift*ValorePerPunto()*gLottoIngresso;
   if(drift > 0) gNPositive++;
   gSommaOreTenuta   += (double)((long)TimeCurrent() - (long)gTimeIngresso)/3600.0;

   if(motivo == SO_USCITA_ORA)       gUsciteOra++;
   else if(motivo == SO_USCITA_FLAT) gUsciteFlat++;
   else                              gUsciteStop++;

   gTicket = 0;
  }

//==================================================================
//  INGRESSO -- l'orologio, e NIENTE ALTRO.
//==================================================================
void ValutaIngresso()
  {
   if(ContaPosizioni() >= InpMaxPositions) return;
   if(gTradesToday >= InpMaxTradesPerDay)  return;

   //--- L'UNICA CONDIZIONE D'INGRESSO DI TUTTO IL FILE.
   MqlDateTime tb; TimeToStruct(iTime(_Symbol, PERIOD_CURRENT, 0), tb);
   if(!OraDiIngresso_Calc(tb.hour, InpOraIngresso)) return;

   //--- non si apre dentro la finestra di flat: sarebbe uno spread
   //    pagato per una posizione che muore nello stesso istante.
   MqlDateTime tn; TimeToStruct(TimeCurrent(), tn);
   if(DevoFlat_Calc(tn.hour, tn.min, InpFlatAnticipoMin)) return;

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0 || ask < bid) return;

   //--- LO SPREAD SI LEGGE QUI, NELL'ISTANTE IN CUI SI PAGA (R55).
   double spreadPts = (ask - bid)/_Point;
   if(InpMaxSpreadPts > 0 && spreadPts > InpMaxSpreadPts){ gGiorniSaltatiSpread++; return; }

   double atr = AtrVal(1);
   if(atr <= 0) return;                     // senza ATR non c'e' stop di protezione: non si apre nuda

   double dist = InpSLatrMult*atr;
   //--- rispetto esplicito di SYMBOL_TRADE_STOPS_LEVEL: con 10 ATR non
   //    morde mai, ma un ordine rifiutato dal broker non e' un dato.
   double minStop = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(dist < minStop) dist = minStop;
   if(dist <= 0) return;

   bool   isLong = gLatoLong;
   double vpp    = ValorePerPunto();
   if(vpp <= 0) return;

   bool   alMinimo = false;
   double lotto    = NormalizzaLotto_Calc(
                        LottoGrezzo_Calc(AccountInfoDouble(ACCOUNT_EQUITY), InpRiskPercent, dist, vpp, _Point),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX),
                        SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP),
                        alMinimo);
   if(lotto <= 0) return;

   double sl = isLong ? NormalizeDouble(ask - dist, _Digits) : NormalizeDouble(bid + dist, _Digits);
   double tp = 0.0;
   if(InpTPatrMult > 0)
      tp = isLong ? NormalizeDouble(ask + InpTPatrMult*atr, _Digits)
                  : NormalizeDouble(bid - InpTPatrMult*atr, _Digits);

   bool ok = isLong ? gTrade.Buy (lotto, _Symbol, 0.0, sl, tp, InpComment)
                    : gTrade.Sell(lotto, _Symbol, 0.0, sl, tp, InpComment);
   if(!ok)
     {
      Log(StringFormat("ordine NON eseguito (retcode %d, lotto %.2f): questa giornata non entra nella misura.",
                       gTrade.ResultRetcode(), lotto));
      return;
     }

   ulong tk = TrovaPosizione();
   if(tk == 0)
     {
      Log("ordine eseguito ma posizione non trovata: la giornata NON viene registrata.");
      return;
     }

   gTicket        = tk;
   gIsLong        = isLong;
   gTimeIngresso  = TimeCurrent();
   gBidIngresso   = bid;
   gLottoIngresso = lotto;
   gDayIngresso   = tn.day_of_year;
   gNotteContata  = false;
   gTradesToday++;
   if(alMinimo) gLottiAlMinimo++;

   if(gNSpread < SO_MAX_CAMPIONI){ gSpread[gNSpread] = spreadPts; gNSpread++; }
  }

//==================================================================
//  LETTURE DAL TERMINALE (il pensiero sta nel nucleo puro)
//==================================================================
double AtrVal(const int shift)
  {
   double a[1];
   if(CopyBuffer(hAtr, 0, shift, 1, a) != 1) return(0.0);
   return(a[0]);
  }

//--- valore in valuta del conto di UN punto per UN lotto.
double ValorePerPunto()
  {
   double tickVal  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickVal <= 0 || tickSize <= 0) return(0.0);
   return(tickVal*(_Point/tickSize));
  }

int ContaPosizioni()
  {
   int n = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      n++;
     }
   return(n);
  }

ulong TrovaPosizione()
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      return(tk);
     }
   return(0);
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit e NON stampa un verdetto che nessuno legge: il
//  numero di blocchi falliti finisce nella colonna "Autotest
//  Falliti" del CSV di ottimizzazione (CHECKLIST punto 99).
//  REGOLA DI SCRITTURA (CHECKLIST punto 98): ogni blocco usa nomi
//  di variabile con il PROPRIO PREFISSO (a1_, a2_, ...). In MQL5
//  due dichiarazioni dello stesso nome nello stesso scope sono un
//  errore secco di compilazione, e nessuna rilettura lo vede.
//==================================================================
void AutoTestOrologio()
  {
   int falliti = 0;

   //--- BLOCCO 1: l'ora d'ingresso. L'unica condizione d'ingresso.
   bool a1_ok  = OraDiIngresso_Calc(8, 8);
   bool a1_no1 = OraDiIngresso_Calc(7, 8);
   bool a1_no2 = OraDiIngresso_Calc(24, 8);   // ora impossibile
   bool a1_no3 = OraDiIngresso_Calc(8, -1);   // ora voluta impossibile
   if(!(a1_ok && !a1_no1 && !a1_no2 && !a1_no3))
     { falliti++; Log("[AUTOTEST] 1 OraDiIngresso_Calc DIVERGE"); }

   //--- BLOCCO 2: l'uscita a tempo, in secondi.
   datetime a2_in = (datetime)1000000;
   bool a2_no  = DurataScaduta_Calc(a2_in + 4*3600 - 1, a2_in, 4);
   bool a2_si  = DurataScaduta_Calc(a2_in + 4*3600,     a2_in, 4);
   bool a2_si2 = DurataScaduta_Calc(a2_in + 12*3600,    a2_in, 12);
   bool a2_deg = DurataScaduta_Calc(a2_in,              a2_in, 0);  // durata assurda -> esce subito
   if(!(!a2_no && a2_si && a2_si2 && a2_deg))
     { falliti++; Log("[AUTOTEST] 2 DurataScaduta_Calc DIVERGE"); }

   //--- BLOCCO 3: il flat NON E' DISATTIVABILE. E' il collaudo che
   //    conta piu' di tutti: qualunque anticipo, anche fuori range,
   //    alle 23:59 il flat DEVE essere vero.
   bool a3_tutte = true;
   int  a3_val[5]; a3_val[0]=-999999; a3_val[1]=0; a3_val[2]=30; a3_val[3]=720; a3_val[4]=999999;
   for(int a3_i = 0; a3_i < 5; a3_i++)
      if(!DevoFlat_Calc(23, 59, a3_val[a3_i])) a3_tutte = false;
   if(!a3_tutte)
     { falliti++; Log("[AUTOTEST] 3 DevoFlat_Calc NON e' ermetico alle 23:59: LA CHIUSURA FORZATA E' DISATTIVABILE"); }

   //--- BLOCCO 4: la geometria del flat con l'anticipo di casa (30').
   bool a4_prima = DevoFlat_Calc(23, 28, 30);   // 23:28 -> ancora no
   bool a4_esatt = DevoFlat_Calc(23, 29, 30);   // 23:29 -> si'
   bool a4_mezzo = DevoFlat_Calc(12, 0,  30);   // meta' giornata -> no
   int  a4_min   = MinutiFlat_Calc(30);
   if(!(!a4_prima && a4_esatt && !a4_mezzo && a4_min == 1409))
     { falliti++; Log("[AUTOTEST] 4 geometria del flat DIVERGE"); }

   //--- BLOCCO 5: il lordo in punti, misurato sul bid nei due versi.
   double a5_l = DriftPunti_Calc(true,  1.10000, 1.10100, 0.00001);   // +100 punti
   double a5_s = DriftPunti_Calc(false, 1.10000, 1.10100, 0.00001);   // -100 punti
   double a5_z = DriftPunti_Calc(true,  1.10000, 1.10100, 0.0);       // punto invalido -> 0
   if(MathAbs(a5_l - 100.0) > 0.001 || MathAbs(a5_s + 100.0) > 0.001 || MathAbs(a5_z) > 0.001)
     { falliti++; Log("[AUTOTEST] 5 DriftPunti_Calc DIVERGE"); }

   //--- BLOCCO 6: il lotto dal rischio, e la sua normalizzazione.
   //    1.000 di rischio, stop 100 punti, 1 valuta per punto -> 10 lotti.
   double a6_g = LottoGrezzo_Calc(100000.0, 1.0, 0.00100, 1.0, 0.00001);
   bool   a6_alMin = false;
   double a6_n = NormalizzaLotto_Calc(a6_g, 0.01, 100.0, 0.01, a6_alMin);
   bool   a6_alMin2 = false;
   double a6_p = NormalizzaLotto_Calc(0.001, 0.01, 100.0, 0.01, a6_alMin2);
   double a6_bad = LottoGrezzo_Calc(100000.0, 1.0, 0.0, 1.0, 0.00001);   // stop nullo -> 0
   if(MathAbs(a6_g - 10.0) > 0.001 || MathAbs(a6_n - 10.0) > 0.001 || a6_alMin ||
      MathAbs(a6_p - 0.01) > 0.0001 || !a6_alMin2 || MathAbs(a6_bad) > 0.0001)
     { falliti++; Log("[AUTOTEST] 6 lotto da rischio DIVERGE"); }

   //--- BLOCCO 7: mediana e percentile su un vettore ordinato noto.
   double a7_v[]; ArrayResize(a7_v, 5);
   a7_v[0]=1.0; a7_v[1]=2.0; a7_v[2]=3.0; a7_v[3]=10.0; a7_v[4]=100.0;
   double a7_med = MedianaOrdinata_Calc(a7_v, 5);          // 3
   double a7_p95 = PercentileOrdinato_Calc(a7_v, 5, 0.95); // ceil(4,75)-1 = 4 -> 100
   double a7_p50 = PercentileOrdinato_Calc(a7_v, 5, 0.50); // ceil(2,5)-1  = 2 -> 3
   double a7_pari[]; ArrayResize(a7_pari, 4);
   a7_pari[0]=1.0; a7_pari[1]=2.0; a7_pari[2]=4.0; a7_pari[3]=8.0;
   double a7_medp = MedianaOrdinata_Calc(a7_pari, 4);      // (2+4)/2 = 3
   double a7_vuoto = MedianaOrdinata_Calc(a7_v, 0);        // niente dati -> 0
   if(MathAbs(a7_med-3.0)>0.001 || MathAbs(a7_p95-100.0)>0.001 || MathAbs(a7_p50-3.0)>0.001 ||
      MathAbs(a7_medp-3.0)>0.001 || MathAbs(a7_vuoto)>0.001)
     { falliti++; Log("[AUTOTEST] 7 mediana/percentile DIVERGONO"); }

   //--- BLOCCO 8: il cancello C1 calcolato dall'EA.
   double a8_tre  = RapportoC1_Calc(6.0, 2.0);    // 3,0 esatto
   double a8_neg  = RapportoC1_Calc(-6.0, 2.0);   // il segno non conta: e' un modulo
   double a8_nd   = RapportoC1_Calc(6.0, 0.0);    // spread non misurato -> 0
   if(MathAbs(a8_tre-3.0)>0.001 || MathAbs(a8_neg-3.0)>0.001 || MathAbs(a8_nd)>0.001)
     { falliti++; Log("[AUTOTEST] 8 RapportoC1_Calc DIVERGE"); }

   gAutotestFalliti = falliti;
   Log(StringFormat("esito motore: %d BLOCCHI SU 8 PASSATI (falliti %d). L'esito vero esce nella colonna 'Autotest Falliti' del CSV: in ottimizzazione questa riga NON la legge nessuno.",
                    8 - falliti, falliti));
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.      //
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
//| MEDIANA e P95 dello spread d'ingresso. Ordina una COPIA: il       |
//| vettore dei campioni non si tocca (non serve piu' a nessuno qui,  |
//| ma un ordinamento distruttivo e' il genere di cosa che poi        |
//| qualcuno riusa credendola innocua).                                |
//+------------------------------------------------------------------+
void StatSpread(double &mediana, double &p95)
  {
   mediana = 0.0; p95 = 0.0;
   if(gNSpread <= 0) return;
   double c[];
   ArrayResize(c, gNSpread);
   for(int i = 0; i < gNSpread; i++) c[i] = gSpread[i];
   ArraySort(c);
   mediana = MedianaOrdinata_Calc(c, gNSpread);
   p95     = PercentileOrdinato_Calc(c, gNSpread, 0.95);
  }

double OnTester()
  {
   double medSpread = 0.0, p95Spread = 0.0;
   StatSpread(medSpread, p95Spread);

   double lordoPunti  = (gNOper > 0) ? gSommaDriftPunti /(double)gNOper : 0.0;
   double lordoValuta = (gNOper > 0) ? gSommaDriftValuta/(double)gNOper : 0.0;
   double pctPositive = (gNOper > 0) ? 100.0*(double)gNPositive/(double)gNOper : 0.0;
   double oreMedie    = (gNOper > 0) ? gSommaOreTenuta  /(double)gNOper : 0.0;

   //--- ATTENZIONE: 'stats', l'header e lo StringFormat di
   //    OnTesterDeinit SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta
   //    a uno solo dei tre sfasa tutto il CSV e chi legge trova il
   //    numero sbagliato sotto il nome giusto.
   double stats[26];
   stats[0]  = TesterStatistics(STAT_PROFIT);
   stats[1]  = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2]  = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3]  = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4]  = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5]  = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6]  = TesterStatistics(STAT_TRADES);
   //--- LA MISURA VERA -- e' per queste colonne che la sonda esiste.
   stats[7]  = gWorstDayPct;                       // C4: il rischio, sempre riportato
   stats[8]  = (double)gNOper;                     // giornate operate
   stats[9]  = lordoPunti;                         // LORDO medio, punti MT5 (bid->bid)
   stats[10] = lordoValuta;                        // LORDO medio, valuta del conto
   stats[11] = medSpread;                          // spread MEDIANO nell'istante del pagamento
   stats[12] = p95Spread;                          // spread P95, stesso istante
   stats[13] = RapportoC1_Calc(lordoPunti, medSpread);  // IL CANCELLO C1, gia' calcolato
   stats[14] = pctPositive;                        // % di giornate positive (drift > 0)
   stats[15] = oreMedie;                           // quanto il flat tronca il blocco
   //--- ANATOMIA DELLE USCITE: dice se la sonda ha misurato l'orologio
   //    o qualcos'altro. Uscite Ora deve dominare.
   stats[16] = (double)gUsciteOra;
   stats[17] = (double)gUsciteFlat;
   stats[18] = (double)gUsciteStop;                // stop 10 ATR o orfane: attesa ~0
   stats[19] = (double)gNottiAttraversate;         // DEVE essere 0
   stats[20] = (double)gLottiAlMinimo;             // rischio piu' alto del dichiarato, quante volte
   //--- ECO DELLA CONFIGURAZIONE: l'ora e la durata escono anche come
   //    colonne di FrameInputs, ma qui sono numeri che l'EA ha DAVVERO
   //    usato, non quello che l'.ini credeva di passargli.
   stats[21] = (double)InpOraIngresso;
   stats[22] = (double)InpOreDurata;
   stats[23] = (gLatoLong ? 1.0 : -1.0);           // Lato: +1 long, -1 short
   //--- COLLAUDO
   stats[24] = (double)gAutotestFalliti;           // 0 = tutti passati; >0 DIVERGE; -1 non eseguito
   stats[25] = (double)gGiorniSaltatiSpread;       // canarino: con il filtro spento DEVE essere 0

   //--- criterio di ottimizzazione: qui NON si sceglie niente (C7), ma
   //    MT5 ne vuole uno. Si dichiara il profitto, che e' il piu'
   //    innocuo da leggere per sbaglio: nessuna cella viene promossa.
   double criterion = stats[0];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
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
         //--- 28 nomi = Pass + Simbolo + 26 valori di stats[].
         string head = "Pass,Simbolo,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Giornate Operate,Lordo Medio Punti,Lordo Medio Valuta,Spread Mediano Ingresso,Spread P95 Ingresso,Rapporto Lordo Su Spread,Giornate Positive %,Ore Medie Tenuta,Uscite Ora,Uscite Flat,Uscite Stop O Orfane,Notti Attraversate,Lotti Al Minimo,Ora Ingresso,Ore Durata,Lato,Autotest Falliti,Giorni Saltati Spread";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 28 specificatori = 28 argomenti (pass, _Symbol, data[0..25]).
      string row = StringFormat("%d,%s,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.2f,%.2f,%.2f,%.3f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, _Symbol,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
