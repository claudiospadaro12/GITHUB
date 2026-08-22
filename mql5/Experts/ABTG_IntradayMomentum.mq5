//+------------------------------------------------------------------+
//|                                     ABTG_IntradayMomentum.mq5     |
//|                                                                   |
//|  EA "A1" - MARKET INTRADAY MOMENTUM.                              |
//|  Il rendimento della PRIMA mezz'ora di cassa predice il verso      |
//|  dell'ULTIMA mezz'ora: si misura all'apertura, si opera alla       |
//|  chiusura, si esce con la campanella. Trenta minuti di             |
//|  esposizione al giorno, zero overnight per costruzione.            |
//|                                                                   |
//|  DA DOVE VIENE (fonte dichiarata, non inventata qui):              |
//|    Gao, Han, Li, Zhou - "Intraday Momentum: The First Half-Hour    |
//|    Return Predicts the Last Half-Hour Return" (poi "Market         |
//|    Intraday Momentum", Journal of Financial Economics).            |
//|    Scheda in casa: report/SWEEP_MECCANISMI_LIBERI_2026-08-22.md    |
//|    par. A1 (punteggio 9/10, candidato promosso dallo sweep).       |
//|                                                                   |
//|  PERCHE' ESISTE (contesto, non marketing):                         |
//|    R97 ha bocciato l'ORB sul Nasdaq 0/4                            |
//|    (backtest_pipeline/risultati_archivio/R97_REFERTO.md): le 4     |
//|    celle avevano GLI STESSI INGRESSI e perdevano tutte in OOS,     |
//|    quindi il problema erano gli INGRESSI, non la geometria delle   |
//|    uscite. Regola della SECONDA CACCIA (CLAUDE.md, 19/08): motore  |
//|    senza edge -> si cerca un MECCANISMO DIVERSO sulla stessa       |
//|    inefficienza, mai un'altra griglia dello stesso motore morto.   |
//|    Questo e' un meccanismo diverso: non entra sulla rottura        |
//|    d'apertura, la MISURA e opera otto ore dopo.                    |
//|                                                                   |
//|  I NUMERI DEL PAPER SONO [DICHIARATI NEL PAPER, NON MISURATI DA    |
//|  NOI]: 6,67% annuo OOS, Sharpe 1,08, success rate 54,37% col solo  |
//|  r1 e 77,05% col doppio predittore, R2 fuori campione 1,2%, costi  |
//|  di transazione -1,22 punti percentuali. Su SPY 1993-2013.         |
//|  Il nostro edge su NASUSD e' ZERO finche' non lo misuriamo noi.    |
//|                                                                   |
//|  IL LIMITE CHE IL PAPER STESSO DICHIARA: l'intraday momentum       |
//|  esiste sugli indici azionari con una campanella vera (FTSE 100,   |
//|  EuroStoxx 50) e NON esiste su valute e materie prime, perche'     |
//|  li' apertura e chiusura del giorno non sono ben definite.         |
//|  Quindi: Nasdaq si', DAX si', Nikkei si'. Oro NO, forex NO.        |
//|  Chi lo spalma sul paniere sta gia' pescando.                      |
//|                                                                   |
//|  IL MOTORE, in tre righe (e non c'e' altro):                       |
//|    1. r1 = rendimento della prima mezz'ora di cassa USA            |
//|       (14:30-15:00 ORA SERVER BCM).                                |
//|    2. all'inizio dell'ultima mezz'ora (20:30 SERVER) si apre NEL   |
//|       VERSO di r1: r1 > 0 -> LONG, r1 < 0 -> SHORT.                |
//|    3. si chiude entro la chiusura di cassa (21:00 SERVER).         |
//|       Sempre. Mai overnight. Non c'e' un input per spegnerlo.      |
//|                                                                   |
//|  ORARI: TUTTI IN ORA SERVER. Regola fissa di casa (CLAUDE.md):     |
//|  il server BCM e' 1 ORA INDIETRO rispetto all'ora italiana.        |
//|    apertura cassa USA  15:30 IT = 14:30 SERVER                     |
//|    chiusura cassa USA  22:00 IT = 21:00 SERVER                     |
//|  Un orario scritto in ora italiana dentro un input di questo EA    |
//|  sposta tutto di un'ora e il round misura un'altra cosa.           |
//|                                                                   |
//|  IL TF DEL GRAFICO NON CONTA: le misure si fanno su barre M1 e     |
//|  l'ATR del guardrail ha il suo TF (InpAtrTF). L'EA gira sul        |
//|  grafico a cui e' attaccato ed e' simbolo-agnostico: il bersaglio  |
//|  del primo round e' NASUSD, ma il codice non lo nomina.            |
//|                                                                   |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in         |
//|  forward finche' un round a TICK REALI non lo promuove con         |
//|  criteri firmati PRIMA dei numeri. Bozza dei criteri:              |
//|  backtest_pipeline/risultati_archivio/R98_CRITERI_BOZZA.md         |
//|                                                                   |
//|  DEMO. Nessun EA garantisce profitti. ASCII puro: niente accenti   |
//|  e niente emoji dentro le stringhe (regola di casa dei .ps1,       |
//|  estesa qui perche' i log finiscono negli stessi strumenti).       |
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
//    false = comportamento identico a un EA non migrato.
//    Il default true NON cambia niente da solo: se il Guardian non gira su
//    questo conto -- e nel Strategy Tester, dove le sue GlobalVariable non
//    esistono -- la guardia lascia passare tutto (fail-open totale). I
//    backtest restano quindi confrontabili con quelli degli altri EA.
//    Non tocca MAI le posizioni gia' aperte e non tocca MAI l'uscita di
//    fine cassa: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Segnale: la PRIMA mezz'ora (ORARI IN ORA SERVER) ==="
//  14:30 server = 15:30 IT = apertura cassa USA. Non e' un parametro da
//  spazzolare: e' la campanella. Resta un input solo perche' un altro
//  mercato (DAX 08:00 server, Nikkei) ha un'altra campanella.
input int    InpSignalStartHour = 14;   // Ora SERVER di inizio finestra segnale (14 = 15 IT, apertura USA)
input int    InpSignalStartMin  = 30;   // Minuto di inizio finestra segnale
input int    InpSignalMinutes   = 30;   // Durata della finestra del segnale in minuti (il paper: 30)

//--- IL RENDIMENTO OVERNIGHT DENTRO IL PREDITTORE. Scelta DICHIARATA.
//  Il paper definisce r1 come il rendimento della prima mezz'ora
//  MISURATO DALLA CHIUSURA DI IERI (scheda A1: "r1 = rendimento della
//  prima mezz'ora dalla chiusura di ieri"): dentro r1 c'e' quindi anche
//  il gap overnight. Il default true e' la definizione DEL PAPER, non
//  una nostra variante: si parte fedeli alla fonte, e la variante
//  intraday pura (open 14:30 -> close 15:00, senza gap) resta a portata
//  di un input per il round di ablazione.
//  ATTENZIONE: sono due predittori DIVERSI, non due tarature dello
//  stesso. Vanno confrontati a parita' di tutto il resto, mai mischiati.
input bool   InpUseOvernightInR1 = true; // r1 dalla CHIUSURA DI IERI (definizione del paper). false = intraday puro
input int    InpMaxGiorniIndietro = 5;   // (solo se overnight) quanti giorni indietro cercare l'ultima chiusura di cassa

//--- SOGLIA MINIMA. Il paper opera SEMPRE (soglia zero): il segno basta.
//  Default 0 = fedele al paper. Alzarla e' un filtro NOSTRO, da misurare
//  come tale (meno operazioni, e va verificato se il lordo per operazione
//  sale abbastanza da coprire lo spread: e' il CANCELLO ZERO del round).
input double InpMinAbsR1Pct = 0.0;      // Soglia minima |r1| in % (0 = opera sempre, come il paper)

input group "=== Secondo segnale r12 (variante del paper, default SPENTO) ==="
//  Il paper offre una variante: si guarda anche r12, il rendimento della
//  PENULTIMA mezz'ora (qui: 20:00-20:30 server, la mezz'ora appena prima
//  dell'ingresso) e si opera SOLO se i due concordano. Dichiarato dal
//  paper: success rate 77,05% ma rendimento medio annuo piu' basso
//  (2,10% contro 6,67%) [DICHIARATO NEL PAPER, NON MISURATO DA NOI].
//  Default SPENTO: la cella nuda del round e' il motore a un segnale
//  solo. Un default acceso sarebbe mezza strategia nascosta nel codice.
input bool   InpUseSecondSignal = false; // Opera solo se r1 e r12 concordano (variante del paper)

input group "=== Ingresso e uscita: l'ULTIMA mezz'ora (ORARI IN ORA SERVER) ==="
input int    InpEntryHour     = 20;     // Ora SERVER di ingresso (20:30 server = 21:30 IT)
input int    InpEntryMin      = 30;     // Minuto di ingresso
input int    InpEntryWindowMin = 5;     // Tolleranza in minuti sull'ingresso: oltre, la giornata si salta
input int    InpExitHour      = 21;     // Ora SERVER della chiusura di cassa (21:00 server = 22:00 IT)
input int    InpExitMin       = 0;      // Minuto della chiusura di cassa
//  MARGINE DI SICUREZZA sulla chiusura. Si esce PRIMA della campanella,
//  non sulla campanella: l'ultimo minuto e' quello in cui lo spread si
//  allarga e il riempimento e' peggiore. Un minuto di anticipo e' una
//  NOSTRA scelta di prudenza, non una regola del paper.
input int    InpExitSafetyMin = 1;      // Minuti di anticipo sulla chiusura di cassa (0 = sulla campanella)
input bool   InpAllowLong     = true;   // Ammetti i LONG
input bool   InpAllowShort    = true;   // Ammetti gli SHORT

input group "=== Guardrail di rischio -- NON FA PARTE DEL PAPER ==="
//  DICHIARAZIONE, prima del codice: il paper NON ha stop loss. E' uno
//  studio sui rendimenti, non un EA. Lo stop lo mettiamo noi, e CAMBIA
//  LA DISTRIBUZIONE dei risultati: uno stop stretto taglia proprio la
//  coda che paga. Per questo qui e' pensato LARGO -- un guardrail contro
//  la mezz'ora catastrofica, non un livello tecnico.
//  E serve anche a un'altra cosa, altrettanto concreta: senza una
//  distanza di stop il LOTTO non si dimensiona. La distanza ATR qui
//  sotto e' quindi SEMPRE usata per calcolare il lotto al rischio %,
//  anche con InpUseStopLoss = false. In quel caso pero' il rischio NON
//  e' limitato da nessun ordine: si misura, non si protegge.
input bool   InpUseStopLoss  = true;    // Piazza lo stop di protezione (NOSTRO, non del paper)
input ENUM_TIMEFRAMES InpAtrTF = PERIOD_M30; // TF dell'ATR: M30 = l'unita' naturale di questo motore
input int    InpAtrPeriod    = 14;      // Periodo ATR
input double InpSLatr        = 2.0;     // Distanza stop = X * ATR(InpAtrTF). Largo apposta

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;     // Rischio per trade, % del saldo

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
//  Stesso formato degli altri EA di casa (ORB, FiboH4, CrossEma).
//  Per riga, separatore ';':  YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
//  Qui blocca soltanto l'INGRESSO: non chiude la posizione, perche'
//  l'uscita di questo motore e' l'ORARIO e non va scavalcata da un
//  filtro d'ingresso.
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "USD";

input group "=== Generali ==="
input string InpComment   = "A1 MIM";   // Commento sugli ordini
//  MAGIC NUOVO, scelto controllando tutti i numeri gia' presenti nel repo
//  (report/CONTRATTI_SEDIE.md, FLOTTA_ATTIVA.md e ogni .mq5/.set/.ini):
//  il blocco 7728xx e' libero. MAI 770201 (Nasdaq apertura, sedia spenta),
//  MAI 770611 (ORB live sul Dow), MAI 7797xx (appena usati da R97).
input long   InpMagic     = 772800;     // Numero magico (blocco 7728xx: libero, verificato nel repo)
input int    InpMaxSpread = 0;          // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose   = true;       // Messaggi nel log
input bool   InpAutoTest  = true;       // Stampa le righe [A1][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

input group "=== Slippage stimato (R55: quanto scala questa cella) ==="
//  PERCHE' (15/08/2026, R55). Tutti i backtest del progetto girano con
//  riempimento PERFETTO. Qui l'ingresso e' A MERCATO a un'ora fissa --
//  caso piu' gentile del pendente STOP dell'ORB, ma non gratis.
//  LIMITE DICHIARATO, e va letto prima di usare questo asse: in questo
//  EA lo slippage si puo' modellare SOLO sullo stop di protezione
//  (spostandolo di X punti nel verso sfavorevole). L'uscita del motore
//  e' A MERCATO all'orario, e nel tester non si puo' peggiorare quel
//  riempimento. Quindi qui il numero MISURA MENO di quanto misura
//  nell'ORB: e' un limite inferiore del costo, non il costo.
//  DEFAULT 0 = comportamento pulito, confrontabile con gli altri round.
input double InpSlippagePts = 0;        // R55: slippage stimato in PUNTI sullo stop (0 = off)

//==================================================================
//  STATO
//==================================================================
int      hAtr = INVALID_HANDLE;

int      gDay = -1;              // day_of_year della giornata in corso
bool     gR1Misurato = false;    // la finestra del segnale e' stata letta?
bool     gR1Ok       = false;    // ...e i dati erano completi?
double   gR1         = 0.0;      // il rendimento della prima mezz'ora (frazione, non %)
bool     gDecisionePresa = false;// la direzione della giornata e' stata decisa?
int      gDir        = 0;        // +1 long, -1 short, 0 niente
bool     gTradeFatto = false;    // UN SOLO trade al giorno, per costruzione
bool     gChiusuraFatta = false; // log della chiusura di cassa una volta sola

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[A1] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST interroga a tavolino, senza mercato, come fa
//   ABTG_PausaGuardian col suo freno. Se una regola non sta qui
//   dentro, non e' verificabile: e allora non e' una regola, e' una
//   speranza.
//
//==================================================================

//+------------------------------------------------------------------+
//| Il rendimento fra due prezzi. riferimento <= 0 = dato non         |
//| utilizzabile: si risponde 0, e sara' il chiamante a sapere (dal   |
//| suo flag "dati ok") che quello zero non e' un rendimento nullo    |
//| ma un dato mancante. Le due cose NON vanno confuse: uno zero      |
//| vero significa "niente trade", un dato mancante pure, ma per      |
//| motivi diversi e vanno letti diversi nel log.                     |
//+------------------------------------------------------------------+
double MIM_Rendimento(const double riferimento,const double chiusura)
  {
   if(riferimento<=0.0) return(0.0);
   return((chiusura-riferimento)/riferimento);
  }

//+------------------------------------------------------------------+
//| LA REGOLA DEL PAPER, tradotta in un verso.                        |
//|   r1 > 0  -> LONG                                                 |
//|   r1 < 0  -> SHORT                                                |
//|   r1 = 0  -> NIENTE                                               |
//|                                                                   |
//| DEVIAZIONE DICHIARATA DAL PAPER: il paper scrive "LONG se r1 > 0, |
//| SHORT se r1 <= 0", cioe' mette lo zero esatto dalla parte degli   |
//| short. Qui lo zero esatto NON opera. Motivo: r1 esattamente zero  |
//| non e' un segnale, e' l'assenza di segnale (su un indice a 2      |
//| decimali capita, e capita di piu' quando il dato e' sporco).      |
//| Regalare quei giorni agli short sarebbe un pezzo di strategia     |
//| deciso dall'arrotondamento.                                       |
//|                                                                   |
//| soglia = frazione (0.001 = 0,10%), NON percentuale. Confronto     |
//| con >= : esattamente sulla soglia si opera.                       |
//| I due lati sono indipendenti e servono alle DUE PASSATE           |
//| DIAGNOSTICHE (malattia R52: un lato non si spegne MAI guardando   |
//| i risultati; lo si misura da solo e si dichiara).                 |
//+------------------------------------------------------------------+
int MIM_Direzione(const double r1,const bool datiOk,const double sogliaAbs,
                  const bool allowLong,const bool allowShort)
  {
   if(!datiOk) return(0);                                  // dati incompleti = nessuna operazione
   if(sogliaAbs>0.0 && MathAbs(r1)<sogliaAbs) return(0);   // sotto soglia = si sta fuori
   if(r1>0.0) return(allowLong  ? +1 : 0);
   if(r1<0.0) return(allowShort ? -1 : 0);
   return(0);                                              // r1 esattamente 0 = niente
  }

//+------------------------------------------------------------------+
//| Concordanza dei due predittori (variante r1+r12 del paper).       |
//| Due zeri NON concordano: nessun verso vuol dire nessun trade.     |
//+------------------------------------------------------------------+
bool MIM_Concordi(const int dir1,const int dir2)
  {
   if(dir1==0 || dir2==0) return(false);
   return(dir1==dir2);
  }

//+------------------------------------------------------------------+
//| LA DECISIONE DELLA GIORNATA, tutta qui e tutta pura.              |
//| Mette insieme il segnale primario, l'eventuale secondo segnale e  |
//| i lati ammessi. Ritorna +1 / -1 / 0.                              |
//| E' la funzione che l'EA chiama davvero: l'autotest quindi non     |
//| verifica un pezzo di logica "simile" a quella operativa, verifica |
//| ESATTAMENTE quella operativa.                                     |
//+------------------------------------------------------------------+
int MIM_DecisioneGiornata(const double r1,const bool r1Ok,
                          const double r12,const bool r12Ok,
                          const bool usaSecondo,const double sogliaAbs,
                          const bool allowLong,const bool allowShort)
  {
   int d1=MIM_Direzione(r1,r1Ok,sogliaAbs,allowLong,allowShort);
   if(d1==0) return(0);
   if(!usaSecondo) return(d1);
   //--- il secondo segnale e' una CONFERMA: si guarda solo il suo segno,
   //    senza soglia (la soglia e' del predittore primario) e senza i
   //    lati (i lati li ha gia' applicati d1).
   int d2=MIM_Direzione(r12,r12Ok,0.0,true,true);
   return(MIM_Concordi(d1,d2) ? d1 : 0);
  }

//+------------------------------------------------------------------+
//| Completezza dei dati della finestra di misura.                    |
//| barreAttese <= 0 = domanda malposta -> falso.                     |
//| pctMin = percentuale minima di barre M1 effettivamente presenti.  |
//| COMPORTAMENTO DICHIARATO: finestra incompleta -> NIENTE TRADE.    |
//| Non si "stima" il rendimento di una mezz'ora che non c'e'.        |
//+------------------------------------------------------------------+
bool MIM_DatiCompleti(const int barreLette,const int barreAttese,const double pctMin)
  {
   if(barreAttese<=0) return(false);
   if(barreLette<=0)  return(false);
   return((double)barreLette >= barreAttese*pctMin/100.0);
  }

//+------------------------------------------------------------------+
//| ORARI -- tutti in MINUTI DALLA MEZZANOTTE, ORA SERVER.            |
//+------------------------------------------------------------------+
int MIM_Minuti(const int ora,const int minuto){ return(ora*60+minuto); }

//--- la finestra del segnale e' chiusa? (estremo incluso: alle 15:00
//    esatte la mezz'ora 14:30-15:00 e' finita e si puo' leggere)
bool MIM_FinestraSegnaleChiusa(const int oraMin,const int fineSegnaleMin)
  {
   return(oraMin>=fineSegnaleMin);
  }

//--- si puo' entrare adesso? Tre condizioni, tutte necessarie:
//    1. e' arrivata l'ora d'ingresso;
//    2. non e' passata la tolleranza (un ingresso in ritardo non e'
//       l'operazione del paper: e' un'altra operazione, piu' corta);
//    3. non e' gia' ora di uscire (mai aprire cio' che va chiuso subito).
bool MIM_FinestraIngressoAperta(const int oraMin,const int ingressoMin,
                                const int tolleranzaMin,const int uscitaMin)
  {
   if(oraMin<ingressoMin) return(false);
   if(oraMin>ingressoMin+tolleranzaMin) return(false);
   if(oraMin>=uscitaMin) return(false);
   return(true);
  }

//--- e' ora di chiudere? (estremo incluso)
bool MIM_OraDiUscita(const int oraMin,const int uscitaMin)
  {
   return(oraMin>=uscitaMin);
  }

//==================================================================
//  ORARI DERIVATI (leggono gli input, non il mercato)
//==================================================================
int MinutiInizioSegnale(){ return(MIM_Minuti(InpSignalStartHour,InpSignalStartMin)); }
int MinutiFineSegnale() { return(MinutiInizioSegnale()+InpSignalMinutes); }
int MinutiIngresso()    { return(MIM_Minuti(InpEntryHour,InpEntryMin)); }
int MinutiCassa()       { return(MIM_Minuti(InpExitHour,InpExitMin)); }
//  L'uscita EFFETTIVA e' la campanella meno il margine di sicurezza.
int MinutiUscita()      { return(MinutiCassa()-InpExitSafetyMin); }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   //--- controlli di coerenza: meglio un INIT_FAILED che un round che
   //    misura un motore diverso da quello che credi di aver lanciato.
   if(InpSignalStartHour<0 || InpSignalStartHour>23 || InpEntryHour<0 || InpEntryHour>23 ||
      InpExitHour<0 || InpExitHour>23)
     { Print("ERRORE: le ore devono stare fra 0 e 23 (e sono ORE SERVER)."); return(INIT_FAILED); }
   if(InpSignalStartMin<0 || InpSignalStartMin>59 || InpEntryMin<0 || InpEntryMin>59 || InpExitMin<0 || InpExitMin>59)
     { Print("ERRORE: i minuti devono stare fra 0 e 59."); return(INIT_FAILED); }
   if(InpSignalMinutes<1 || InpSignalMinutes>240)
     { Print("ERRORE: InpSignalMinutes deve stare fra 1 e 240."); return(INIT_FAILED); }
   if(MinutiFineSegnale()>MinutiIngresso())
     { Print("ERRORE: la finestra del segnale finisce DOPO l'ora di ingresso: il motore non ha senso."); return(INIT_FAILED); }
   if(InpExitSafetyMin<0 || InpExitSafetyMin>30)
     { Print("ERRORE: InpExitSafetyMin deve stare fra 0 e 30 minuti."); return(INIT_FAILED); }
   if(MinutiUscita()<=MinutiIngresso())
     { Print("ERRORE: l'uscita (meno il margine) cade prima o sopra l'ingresso: nessuna operazione sarebbe possibile."); return(INIT_FAILED); }
   if(InpEntryWindowMin<0 || InpEntryWindowMin>60)
     { Print("ERRORE: InpEntryWindowMin deve stare fra 0 e 60 minuti."); return(INIT_FAILED); }
   if(InpSLatr<=0)
     { Print("ERRORE: InpSLatr deve essere > 0: senza distanza di stop il lotto non si dimensiona."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMinAbsR1Pct<0)
     { Print("ERRORE: InpMinAbsR1Pct non puo' essere negativa."); return(INIT_FAILED); }
   if(InpMaxGiorniIndietro<1 || InpMaxGiorniIndietro>15)
     { Print("ERRORE: InpMaxGiorniIndietro deve stare fra 1 e 15."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non farebbe niente."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, InpAtrTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione. Se una variante e' accesa, la
   //    cella NON e' la cella nuda del round. Non la spegne l'EA
   //    (sarebbe un default nascosto): la DICE, e il file prova la pinna.
   if(InpUseSecondSignal || InpMinAbsR1Pct>0 || !InpUseOvernightInR1 || InpUseNewsFilter || !InpAllowLong || !InpAllowShort)
      Log("ATTENZIONE: c'e' almeno una VARIANTE accesa (secondo segnale / soglia / r1 senza overnight / news / un lato spento). Questa cella NON e' la cella nuda del round.");
   if(!InpUseStopLoss)
      Log("ATTENZIONE: stop di protezione SPENTO. Il lotto si dimensiona lo stesso sulla distanza ATR, ma la perdita NON e' limitata da nessun ordine.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestA1();

   Log(StringFormat("avviato su %s. Segnale %02d:%02d + %d min (server) | ingresso %02d:%02d (+%d min) | uscita %02d:%02d meno %d min | overnight in r1: %s | soglia %.3f%% | rischio %.2f%% | magic %I64d",
       _Symbol, InpSignalStartHour, InpSignalStartMin, InpSignalMinutes,
       InpEntryHour, InpEntryMin, InpEntryWindowMin,
       InpExitHour, InpExitMin, InpExitSafetyMin,
       (InpUseOvernightInR1?"SI (definizione del paper)":"NO (intraday puro)"),
       InpMinAbsR1Pct, InpRiskPercent, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
//| LA MACCHINA A STATI, e non c'e' altro.                            |
//|   1. cambio giorno   -> azzera tutto                              |
//|   2. ora di uscita   -> CHIUDE, e non si discute (prima di tutto  |
//|                          il resto: l'uscita non deve mai poter    |
//|                          essere saltata da un return di sopra)    |
//|   3. finestra chiusa -> misura r1                                 |
//|   4. ora d'ingresso  -> decide e apre (una volta sola al giorno)  |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetGiorno(); }

   int oraMin=MIM_Minuti(now.hour,now.min);

   //--- 2. USCITA DI CASSA. Obbligatoria, senza input per spegnerla:
   //    "zero overnight" non e' un'opzione di questo motore, e' il
   //    motore. Vale anche per una posizione ereditata da un riavvio.
   if(MIM_OraDiUscita(oraMin,MinutiUscita())){ ChiusuraCassa(); return; }

   //--- 3. MISURA DEL SEGNALE, a finestra CHIUSA (mai intrabar).
   if(!gR1Misurato && MIM_FinestraSegnaleChiusa(oraMin,MinutiFineSegnale()))
      MisuraSegnale();

   //--- 4. INGRESSO
   if(!gR1Misurato || gTradeFatto) return;
   if(!MIM_FinestraIngressoAperta(oraMin,MinutiIngresso(),InpEntryWindowMin,MinutiUscita())) return;
   if(!gDecisionePresa) DecidiGiornata();
   if(gDir==0) return;
   TentaIngresso();
  }

void ResetGiorno()
  {
   gR1Misurato=false; gR1Ok=false; gR1=0.0;
   gDecisionePresa=false; gDir=0;
   gTradeFatto=false; gChiusuraFatta=false;
  }

//==================================================================
//  MISURA -- lettura del mercato, poi la decisione la prende il
//  nucleo puro. Qui dentro non c'e' nessuna regola di strategia.
//==================================================================

//+------------------------------------------------------------------+
//| Legge una finestra di barre M1 [tStart, tStart+minuti).           |
//| Ritorna false se non c'e' NIENTE. Riempie:                        |
//|   apertura       = open della prima barra presente                |
//|   chiusura       = close dell'ultima barra presente               |
//|   barre          = quante barre M1 ci sono davvero                |
//|   aperturaEsatta = la prima barra e' proprio quella di tStart?    |
//| Il chiamante decide quanto pretendere: per r1 intraday puro       |
//| l'apertura esatta serve, per r1 col gap overnight no.             |
//+------------------------------------------------------------------+
bool LeggiFinestraM1(const datetime tStart,const int minuti,
                     double &apertura,double &chiusura,int &barre,bool &aperturaEsatta)
  {
   apertura=0; chiusura=0; barre=0; aperturaEsatta=false;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   datetime tEnd=tStart+(datetime)minuti*60;
   int n=CopyRates(_Symbol,PERIOD_M1,tStart,tEnd-1,r);
   if(n<=0) return(false);
   barre=n;
   apertura=r[0].open;
   chiusura=r[n-1].close;
   aperturaEsatta=(r[0].time==tStart);
   return(apertura>0 && chiusura>0);
  }

//+------------------------------------------------------------------+
//| L'ultima CHIUSURA DI CASSA precedente (serve solo se r1 include   |
//| il gap overnight, cioe' nella definizione del paper).             |
//| Si cerca all'indietro giorno per giorno l'ultima barra M1 che     |
//| finisce all'orario di chiusura cassa: cosi' il weekend e i        |
//| festivi si saltano da soli, senza tabelle da mantenere.           |
//| Se in InpMaxGiorniIndietro giorni non si trova -> false, e la     |
//| giornata si salta (comportamento dichiarato: dati mancanti =      |
//| niente trade).                                                    |
//+------------------------------------------------------------------+
bool ChiusuraCassaPrecedente(const datetime tCassaOggi,double &px,datetime &quando)
  {
   px=0; quando=0;
   for(int k=1;k<=InpMaxGiorniIndietro;k++)
     {
      datetime t=tCassaOggi-(datetime)k*86400-60;   // ultima barra M1 della cassa di quel giorno
      int i=iBarShift(_Symbol,PERIOD_M1,t,true);    // esatta: se quel minuto non esiste, si va indietro
      if(i<0) continue;
      double c=iClose(_Symbol,PERIOD_M1,i);
      if(c>0){ px=c; quando=t; return(true); }
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| MISURA DI r1 -- la prima mezz'ora. Si esegue una volta al giorno. |
//+------------------------------------------------------------------+
void MisuraSegnale()
  {
   gR1Misurato=true;    // il tentativo si fa UNA volta: se fallisce, la giornata e' persa e va detto
   gR1Ok=false; gR1=0.0;

   MqlDateTime st; TimeToStruct(TimeCurrent(),st); st.sec=0;
   st.hour=InpSignalStartHour; st.min=InpSignalStartMin; datetime tSig=StructToTime(st);
   st.hour=InpExitHour;        st.min=InpExitMin;        datetime tCassa=StructToTime(st);

   double ap=0,ch=0; int barre=0; bool apEsatta=false;
   if(!LeggiFinestraM1(tSig,InpSignalMinutes,ap,ch,barre,apEsatta))
     { Log("finestra del segnale VUOTA (nessuna barra M1): niente trade oggi."); return; }

   if(!MIM_DatiCompleti(barre,InpSignalMinutes,80.0))
     { Log(StringFormat("finestra del segnale INCOMPLETA (%d barre M1 su %d attese, soglia 80%%): niente trade oggi.",
                        barre,InpSignalMinutes)); return; }

   double riferimento=0;
   if(InpUseOvernightInR1)
     {
      datetime quando=0;
      if(!ChiusuraCassaPrecedente(tCassa,riferimento,quando))
        { Log("chiusura di cassa precedente NON trovata: niente trade oggi (r1 del paper la richiede)."); return; }
     }
   else
     {
      if(!apEsatta)
        { Log("manca la barra M1 di apertura esatta della finestra: niente trade oggi (r1 intraday la richiede)."); return; }
      riferimento=ap;
     }

   gR1=MIM_Rendimento(riferimento,ch);
   gR1Ok=(riferimento>0);
   Log(StringFormat("r1 misurato: %.4f%% (riferimento %.2f -> chiusura finestra %.2f, %d barre M1, overnight %s).",
                    gR1*100.0, riferimento, ch, barre, (InpUseOvernightInR1?"SI":"NO")));
  }

//+------------------------------------------------------------------+
//| MISURA DI r12 -- la penultima mezz'ora (variante del paper).      |
//| Finestra: [ingresso - InpSignalMinutes, ingresso).                |
//+------------------------------------------------------------------+
bool MisuraSecondoSegnale(double &r12)
  {
   r12=0.0;
   MqlDateTime st; TimeToStruct(TimeCurrent(),st); st.sec=0;
   st.hour=InpEntryHour; st.min=InpEntryMin; datetime tIng=StructToTime(st);
   datetime tStart=tIng-(datetime)InpSignalMinutes*60;

   double ap=0,ch=0; int barre=0; bool apEsatta=false;
   if(!LeggiFinestraM1(tStart,InpSignalMinutes,ap,ch,barre,apEsatta)) return(false);
   if(!apEsatta) return(false);
   if(!MIM_DatiCompleti(barre,InpSignalMinutes,80.0)) return(false);
   r12=MIM_Rendimento(ap,ch);
   return(true);
  }

//+------------------------------------------------------------------+
//| LA DECISIONE. Legge i numeri, poi chiama il nucleo puro.          |
//+------------------------------------------------------------------+
void DecidiGiornata()
  {
   gDecisionePresa=true;

   double r12=0.0; bool r12Ok=true;
   if(InpUseSecondSignal)
     {
      r12Ok=MisuraSecondoSegnale(r12);
      if(!r12Ok) Log("secondo segnale r12 NON misurabile (dati incompleti): niente trade oggi.");
     }

   double soglia=InpMinAbsR1Pct/100.0;   // il nucleo puro lavora in FRAZIONE, non in %
   gDir=MIM_DecisioneGiornata(gR1,gR1Ok,r12,r12Ok,InpUseSecondSignal,soglia,InpAllowLong,InpAllowShort);

   if(gDir==0)
      Log(StringFormat("decisione: NESSUN TRADE (r1 %.4f%% ok=%d | r12 %.4f%% ok=%d | secondo segnale %d | soglia %.3f%%).",
                       gR1*100.0,(int)gR1Ok,r12*100.0,(int)r12Ok,(int)InpUseSecondSignal,InpMinAbsR1Pct));
   else
      Log(StringFormat("decisione: %s (r1 %.4f%%%s).", (gDir>0?"LONG":"SHORT"), gR1*100.0,
                       (InpUseSecondSignal?StringFormat(", r12 %.4f%% concorde",r12*100.0):"")));
  }

//==================================================================
//  ESECUZIONE
//==================================================================

//+------------------------------------------------------------------+
//| Apre la posizione dell'ultima mezz'ora.                           |
//| Ordine dei controlli VOLUTO: prima le ragioni per cui NON si      |
//| opera (posizione gia' aperta, spread, news, dati dello stop),     |
//| poi -- ultima, subito prima dell'invio -- la guardia del conto.   |
//+------------------------------------------------------------------+
void TentaIngresso()
  {
   if(SelPos()){ gTradeFatto=true; return; }        // gia' dentro: un trade al giorno, per costruzione
   if(!SpreadOK()){ Log("spread oltre il tetto: ingresso saltato (riprovo dentro la finestra)."); return; }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent()))
     { Log("blackout notizie: ingresso saltato."); return; }

   double atr=AtrVal();
   if(atr<=0){ Log("ATR non disponibile: niente trade (senza distanza non si dimensiona il lotto)."); return; }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ Log("prezzi non disponibili: ingresso saltato."); return; }

   double slDist=InpSLatr*atr;
   //--- rispetto esplicito dello STOPS_LEVEL del broker: uno stop piu'
   //    vicino del minimo consentito viene RIFIUTATO, e un rifiuto in
   //    questa fascia oraria vuol dire giornata persa in silenzio.
   double minDist=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(slDist<minDist) slDist=minDist;
   if(slDist<=0){ Log("distanza di stop nulla: ingresso saltato."); return; }

   double lot=LotByRisk(slDist);   // lotto dal rischio ORIGINALE, prima dello slippage
   if(lot<=0){ Log("lotto calcolato 0: ingresso saltato."); return; }

   bool isLong=(gDir>0);
   double entry=(isLong?ask:bid);
   double sl=0.0;
   if(InpUseStopLoss)
     {
      sl=NormalizePrice(isLong ? entry-slDist : entry+slDist);
      //--- R55: lo slippage stimato sposta lo stop nel verso sfavorevole.
      if(InpSlippagePts>0)
        { double sp=InpSlippagePts*_Point; sl=NormalizePrice(isLong ? sl-sp : sl+sp); }
     }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_IntradayMomentum")) return;

   //--- NESSUN take profit: l'uscita di questo motore e' l'ORARIO.
   //    Metterne uno sarebbe un'altra strategia, non una taratura.
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,0.0,sl,0.0,InpComment+" LONG")
                    : gTrade.Sell(lot,_Symbol,0.0,sl,0.0,InpComment+" SHORT");
   if(ok)
     {
      gTradeFatto=true;
      Log(StringFormat("%s a mercato @ %.2f lot %.2f SL %.2f (dist %.2f = %.2f x ATR) -- uscita prevista alle %02d:%02d server.",
                       (isLong?"LONG":"SHORT"), entry, lot, sl, slDist, InpSLatr,
                       MinutiUscita()/60, MinutiUscita()%60));
     }
   else
      Log("ingresso FALLITO: "+gTrade.ResultRetcodeDescription()+" (retcode "+IntegerToString(gTrade.ResultRetcode())+"). Riprovo dentro la finestra.");
  }

//+------------------------------------------------------------------+
//| CHIUSURA DI CASSA. Non e' un'opzione: e' la terza riga del motore.|
//+------------------------------------------------------------------+
void ChiusuraCassa()
  {
   if(!SelPos()){ gChiusuraFatta=true; return; }
   if(gTrade.PositionClose(_Symbol))
     {
      if(!gChiusuraFatta) Log("chiusura di cassa: posizione chiusa (zero overnight, per costruzione).");
      gChiusuraFatta=true;
     }
   else if(!gChiusuraFatta)
      Log("chiusura di cassa FALLITA: "+gTrade.ResultRetcodeDescription()+". Riprovo al tick successivo.");
  }

//==================================================================
//  UTILITY (identiche di comportamento a quelle degli altri EA)
//==================================================================
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)<1) return(0); return(a[0]); }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026).
   //  Su 225JPY il tick value arriva non convertito in valuta conto e il
   //  lotto finiva sempre al minimo. OrderCalcProfit converte
   //  correttamente; il tick value resta come ripiego. Sui simboli sani i
   //  due calcoli coincidono: cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//
//  Tutti i casi qui sotto interrogano IL NUCLEO PURO, cioe' le
//  stesse funzioni che OnTick usa per decidere. Non c'e' una copia
//  "di prova" della logica: se l'autotest passa, la regola che ha
//  passato l'esame e' quella che manda gli ordini.
//==================================================================
void A1_Caso(const string nome,const bool ottenuto,const bool atteso,int &falliti)
  {
   bool ok=(ottenuto==atteso);
   if(!ok) falliti++;
   PrintFormat("[A1][AUTOTEST] %-56s atteso=%s ottenuto=%s  %s",
               nome,(atteso?"SI":"NO"),(ottenuto?"SI":"NO"),(ok?"PASS":"*** FAIL ***"));
  }

void A1_CasoInt(const string nome,const int ottenuto,const int atteso,int &falliti)
  {
   bool ok=(ottenuto==atteso);
   if(!ok) falliti++;
   PrintFormat("[A1][AUTOTEST] %-56s atteso=%d ottenuto=%d  %s",
               nome,atteso,ottenuto,(ok?"PASS":"*** FAIL ***"));
  }

void A1_CasoDbl(const string nome,const double ottenuto,const double atteso,int &falliti)
  {
   bool ok=(MathAbs(ottenuto-atteso)<1e-9);
   if(!ok) falliti++;
   PrintFormat("[A1][AUTOTEST] %-56s atteso=%.8f ottenuto=%.8f  %s",
               nome,atteso,ottenuto,(ok?"PASS":"*** FAIL ***"));
  }

void AutoTestA1()
  {
   int falliti=0;

   PrintFormat("[A1][AUTOTEST] ABTG_IntradayMomentum v1.00 -- nucleo puro, nessuna lettura di mercato. %s | magic %I64d",
               _Symbol, InpMagic);
   Print("[A1][AUTOTEST] --- 1. IL RENDIMENTO (r1 grezzo) ---");
   A1_CasoDbl("rif 100 -> chiusura 101 = +1%",            MIM_Rendimento(100.0,101.0), 0.01,  falliti);
   A1_CasoDbl("rif 100 -> chiusura 99  = -1%",            MIM_Rendimento(100.0, 99.0),-0.01,  falliti);
   A1_CasoDbl("rif 100 -> chiusura 100 = 0 (nessun moto)",MIM_Rendimento(100.0,100.0), 0.0,   falliti);
   A1_CasoDbl("riferimento 0 (dato mancante) -> 0",       MIM_Rendimento(  0.0,101.0), 0.0,   falliti);

   Print("[A1][AUTOTEST] --- 2. LA DIREZIONE (la regola del paper) ---");
   A1_CasoInt("r1 +0,40% soglia 0 -> LONG",              MIM_Direzione( 0.0040,true,0.0,   true,true), +1, falliti);
   A1_CasoInt("r1 -0,40% soglia 0 -> SHORT",             MIM_Direzione(-0.0040,true,0.0,   true,true), -1, falliti);
   A1_CasoInt("r1 ESATTAMENTE 0 -> NIENTE (deviazione dichiarata)",
                                                          MIM_Direzione( 0.0,   true,0.0,   true,true),  0, falliti);
   A1_CasoInt("r1 +0,05% sotto soglia 0,10% -> NIENTE", MIM_Direzione( 0.0005,true,0.0010,true,true),  0, falliti);
   A1_CasoInt("r1 -0,05% sotto soglia 0,10% -> NIENTE", MIM_Direzione(-0.0005,true,0.0010,true,true),  0, falliti);
   A1_CasoInt("r1 esattamente sulla soglia 0,10% -> LONG",
                                                          MIM_Direzione( 0.0010,true,0.0010,true,true), +1, falliti);
   A1_CasoInt("r1 -0,10% esattamente sulla soglia -> SHORT",
                                                          MIM_Direzione(-0.0010,true,0.0010,true,true), -1, falliti);
   A1_CasoInt("dati INCOMPLETI (datiOk=false) -> NIENTE",  MIM_Direzione( 0.0040,false,0.0,  true,true),  0, falliti);
   A1_CasoInt("long vietato dai lati -> NIENTE",           MIM_Direzione( 0.0040,true,0.0,  false,true),  0, falliti);
   A1_CasoInt("short vietato dai lati -> NIENTE",          MIM_Direzione(-0.0040,true,0.0,  true,false),  0, falliti);
   A1_CasoInt("solo short ammessi, r1 negativo -> SHORT (lati indipendenti)",
                                                           MIM_Direzione(-0.0040,true,0.0, false,true),  -1, falliti);

   Print("[A1][AUTOTEST] --- 3. LA CONCORDANZA r1/r12 (variante del paper) ---");
   A1_Caso("+1 e +1 concordi",            MIM_Concordi(+1,+1), true,  falliti);
   A1_Caso("-1 e -1 concordi",            MIM_Concordi(-1,-1), true,  falliti);
   A1_Caso("+1 e -1 discordi",            MIM_Concordi(+1,-1), false, falliti);
   A1_Caso("+1 e 0 (secondo assente)",    MIM_Concordi(+1, 0), false, falliti);
   A1_Caso("0 e 0 (nessun verso)",        MIM_Concordi( 0, 0), false, falliti);

   Print("[A1][AUTOTEST] --- 4. LA DECISIONE DELLA GIORNATA (la funzione che apre davvero) ---");
   A1_CasoInt("r1 + , secondo segnale SPENTO -> LONG",
              MIM_DecisioneGiornata( 0.004,true, 0.0,true,false,0.0,true,true), +1, falliti);
   A1_CasoInt("r1 - , secondo segnale SPENTO -> SHORT",
              MIM_DecisioneGiornata(-0.004,true, 0.0,true,false,0.0,true,true), -1, falliti);
   A1_CasoInt("r1 + , r12 + , secondo ACCESO -> LONG",
              MIM_DecisioneGiornata( 0.004,true, 0.002,true,true,0.0,true,true), +1, falliti);
   A1_CasoInt("r1 + , r12 - , secondo ACCESO -> NIENTE",
              MIM_DecisioneGiornata( 0.004,true,-0.002,true,true,0.0,true,true),  0, falliti);
   A1_CasoInt("r1 - , r12 - , secondo ACCESO -> SHORT",
              MIM_DecisioneGiornata(-0.004,true,-0.002,true,true,0.0,true,true), -1, falliti);
   A1_CasoInt("r1 + , r12 NON misurabile, secondo ACCESO -> NIENTE",
              MIM_DecisioneGiornata( 0.004,true, 0.0,false,true,0.0,true,true),   0, falliti);
   A1_CasoInt("r1 NON misurabile -> NIENTE (qualunque r12)",
              MIM_DecisioneGiornata( 0.004,false,0.004,true,true,0.0,true,true),  0, falliti);
   A1_CasoInt("r1 sotto soglia, secondo ACCESO e concorde -> NIENTE",
              MIM_DecisioneGiornata( 0.0005,true,0.004,true,true,0.0010,true,true), 0, falliti);

   Print("[A1][AUTOTEST] --- 5. COMPLETEZZA DEI DATI (barre mancanti = niente trade) ---");
   A1_Caso("30 barre su 30 attese, soglia 80%",  MIM_DatiCompleti(30,30,80.0), true,  falliti);
   A1_Caso("24 barre su 30 attese (esatto 80%)", MIM_DatiCompleti(24,30,80.0), true,  falliti);
   A1_Caso("23 barre su 30 attese (sotto 80%)",  MIM_DatiCompleti(23,30,80.0), false, falliti);
   A1_Caso("0 barre lette",                       MIM_DatiCompleti( 0,30,80.0), false, falliti);
   A1_Caso("0 barre ATTESE (domanda malposta)",   MIM_DatiCompleti(30, 0,80.0), false, falliti);

   Print("[A1][AUTOTEST] --- 6. GLI ORARI, IN ORA SERVER (14:30 = apertura USA) ---");
   A1_CasoInt("14:30 in minuti",                  MIM_Minuti(14,30), 870, falliti);
   A1_CasoInt("21:00 in minuti",                  MIM_Minuti(21, 0),1260, falliti);
   A1_Caso("15:00 -> finestra segnale CHIUSA",    MIM_FinestraSegnaleChiusa(MIM_Minuti(15,0),MIM_Minuti(15,0)), true,  falliti);
   A1_Caso("14:59 -> finestra segnale APERTA",    MIM_FinestraSegnaleChiusa(MIM_Minuti(14,59),MIM_Minuti(15,0)),false, falliti);
   A1_Caso("20:30 -> si puo' entrare",            MIM_FinestraIngressoAperta(MIM_Minuti(20,30),MIM_Minuti(20,30),5,MIM_Minuti(20,59)), true,  falliti);
   A1_Caso("20:29 -> troppo presto",              MIM_FinestraIngressoAperta(MIM_Minuti(20,29),MIM_Minuti(20,30),5,MIM_Minuti(20,59)), false, falliti);
   A1_Caso("20:35 con tolleranza 5 -> ancora si", MIM_FinestraIngressoAperta(MIM_Minuti(20,35),MIM_Minuti(20,30),5,MIM_Minuti(20,59)), true,  falliti);
   A1_Caso("20:36 con tolleranza 5 -> troppo tardi",
                                                  MIM_FinestraIngressoAperta(MIM_Minuti(20,36),MIM_Minuti(20,30),5,MIM_Minuti(20,59)), false, falliti);
   A1_Caso("21:00 con tolleranza larga -> MAI (si esce, non si entra)",
                                                  MIM_FinestraIngressoAperta(MIM_Minuti(21, 0),MIM_Minuti(20,30),60,MIM_Minuti(20,59)),false, falliti);
   A1_Caso("20:59 -> ora di USCIRE",              MIM_OraDiUscita(MIM_Minuti(20,59),MIM_Minuti(20,59)), true,  falliti);
   A1_Caso("20:58 -> non ancora",                 MIM_OraDiUscita(MIM_Minuti(20,58),MIM_Minuti(20,59)), false, falliti);
   A1_Caso("23:30 -> ora di USCIRE (posizione ereditata)",
                                                  MIM_OraDiUscita(MIM_Minuti(23,30),MIM_Minuti(20,59)), true,  falliti);

   if(falliti==0)
      Print("[A1][AUTOTEST] ESITO: TUTTI I CASI PASSATI. La regola ragiona come la scheda A1.");
   else
      PrintFormat("[A1][AUTOTEST] ESITO: %d CASI FALLITI -- non usare i risultati, c'e' da guardare il codice.",falliti);

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- blocco standard ABTG
//  Formato per riga (separatore ';'):
//    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
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

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE (09/08/2026) - serve al DD di PORTAFOGLIO.       |
//| A fine test scrive nella cartella COMUNE (Files comuni) un CSV    |
//| con una riga per ogni trade CHIUSO (ora di chiusura e netto):     |
//| con le serie di piu' EA si calcolano DD combinato e Monte Carlo   |
//| (backtest_pipeline/dd_portafoglio.py). Solo tester. In            |
//| ottimizzazione ogni pass sovrascrive il file del proprio magic:   |
//| usarlo su run singoli / magic-sweep, non sulle griglie larghe.    |
//+------------------------------------------------------------------+
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

double OnTester()
  {
   ExportTrades();   // per-trade per il DD di portafoglio (ROTTA_PROP punto 4)
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
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
