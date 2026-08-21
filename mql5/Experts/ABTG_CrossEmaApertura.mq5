//+------------------------------------------------------------------+
//|                                      ABTG_CrossEmaApertura.mq5    |
//|                                                                   |
//|  EA "INCROCIO DELLE MEDIE DI SESSIONE" - l'apertura americana      |
//|  COSTRUISCE il segnale, non lo filtra.                             |
//|                                                                   |
//|  v1.00 - 21/08/2026 - ROUND R96 (candidato, mai girato)            |
//+------------------------------------------------------------------+
//
//  DA DOVE VIENE
//  ---------------------------------------------------------------------
//  Osservazione di Claudio del 21/08/2026, dopo un alert TradingView:
//    "quando c'e' l'incrocio e' un segnale forte soprattutto quando apre
//     il mercato americano".
//
//  LA DISTINZIONE CHE FA ESISTERE QUESTO EA (e che va letta PRIMA del codice)
//  ---------------------------------------------------------------------
//  In questa casa "motore gia' tarato + filtro orario appiccicato sopra"
//  ha un punteggio misurato di ZERO SUCCESSI SU CINQUE (R20 ADX, R12,
//  R26, R45, R54). Quindi questo EA NON e' - e non deve diventare -
//  "ABTG_CrossEma acceso solo dalle 14:30".
//
//  La differenza sta in UNA riga di algebra:
//
//    ABTG_CrossEma (R86, BOCCIATO)  la EMA 9/21 e' calcolata sulla serie
//                                    CONTINUA. Alle 03:00 quel numero
//                                    esiste gia'. Limitarne l'uso a
//                                    un'ora e' un FILTRO.
//
//    QUESTO EA                       le due medie sono RI-SEMINATE
//                                    all'apertura e vivono SOLO dentro la
//                                    sessione: alle 03:00 non esistono
//                                    affatto. Senza l'apertura non c'e'
//                                    nessuna media, quindi non c'e'
//                                    nessun incrocio da filtrare.
//                                    L'apertura E' il motore.
//
//  Prova secca della distinzione, ed e' dentro l'EA: InpAncoraSessione.
//    true  = medie di sessione (il motore di R96)
//    false = medie continue nella stessa finestra oraria, cioe' ESATTAMENTE
//            lo schema vietato. Serve come CONTROLLO NEGATIVO del round,
//            e NON puo' essere promosso in nessun caso: vedi R96_CRITERI.md.
//
//  MAPPA REGOLA <-> CODICE (verificabile riga per riga)
//  ---------------------------------------------------------------------
//  # | regola                                    | dove sta nel codice
//  --|-------------------------------------------|---------------------
//  1 | l'ANCORA: ogni giorno alle HH:MM SERVER    | InpOpenHour / InpOpenMin
//    | (Dow e Nasdaq: 14:30 server = 15:30 IT)    | InizioSessione()
//  2 | le due medie NASCONO li': la prima barra   | RaccogliChiusureSessione()
//    | della sessione le semina, e ricominciano   | EmaSessione_Calc()
//    | da capo ogni giorno                        | (InpAncoraSessione=true)
//  3 | il SEGNALE: incrocio delle medie DI        | SegnaleSessione()
//    | SESSIONE su barra CHIUSA, mai intrabar     | + CrossDirezione()
//  4 | serve un minimo di barre di sessione,      | InpMinBarreSessione
//    | altrimenti si legge l'artefatto del seme   | (2 = primo confronto possibile)
//  5 | gli INGRESSI vivono solo dentro la         | InpSessioneMinuti
//    | finestra aperta dall'ancora                | DentroFinestra_Calc()
//  6 | la posizione MUORE con la sessione che     | InpChiudiAFineSessione
//    | l'ha generata (niente overnight)           | ChiusuraFineSessione()
//  7 | stop = N x ATR, target in R                | InpSLatr / InpTP_RR
//  8 | lotto dal rischio % sulla distanza di stop | LotByRisk()
//  9 | una posizione alla volta per magic         | CountPositions()
// 10 | CONTROLLO NEGATIVO: medie continue,        | InpAncoraSessione=false
//    | stessa finestra = lo schema vietato        | SegnaleContinuo()
//
//  QUELLO CHE QUESTO EA NON FA, e non e' una dimenticanza
//  ---------------------------------------------------------------------
//   - NON costruisce nessun range di apertura e NON entra sulla rottura
//     di un livello. Il breakout M5 in apertura e' un capitolo CHIUSO in
//     questa casa (REGISTRO_TEST.md par. 2, 26.07.2026: "Non costruire
//     altri v2 M5"), e sul Nasdaq l'apertura USA e' morta (test A4,
//     PF 0,91). Appiccicare un incrocio a QUEL motore sarebbe lo stesso
//     errore visto dall'altra parte. Qui non c'e' nessun livello: c'e'
//     una media che nasce con la campanella.
//   - NON gestisce sessioni che scavalcano la mezzanotte: OnInit rifiuta
//     apertura + durata > 24h. E' una limitazione dichiarata, non un bug:
//     toglie di mezzo un'intera famiglia di errori di data.
//   - NON ha filtri di volume, ne' EMA di trend, ne' filtro news acceso.
//     Sono domande di ALTRI round.
//   - Il TF operativo e' il Period del tester (PERIOD_CURRENT), come in
//     ABTG_CrossEma: lo fissa @PERIODO nel file prova.
//
//  GLI ORARI SONO IN ORA SERVER. SEMPRE. Il server BCM sta UN'ORA INDIETRO
//  rispetto all'ora italiana: Dow/Nasdaq 15:30 IT = 14:30 SERVER, DAX
//  09:00 IT = 08:00 SERVER. Un orario italiano scritto qui dentro misura
//  un'altra strategia.
//
//  ATTENZIONE, il DAX non e' il bersaglio di questo EA con i default:
//  il DAX alle 14:30 server e' aperto da sei ore e mezza, quindi li'
//  l'ancora non "nasce" con la campanella. Per il DAX si mette
//  InpOpenHour=8 / InpOpenMin=0, ed e' un ALTRO round.
//
//  NON COMPILATO NE' BACKTESTATO da chi lo ha scritto: questo ambiente non
//  ha MetaEditor. Si compila prima di qualunque corsa.
//  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le stringhe,
//  niente emoji (regola di casa).
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property description "Incrocio delle medie DI SESSIONE ancorate all'apertura USA - candidato R96"
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
//    Non tocca MAI le posizioni gia' aperte, i parziali, il trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== ANCORA DI SESSIONE: e' il MOTORE, non un filtro ==="
//  Questo blocco NON limita un segnale che esisterebbe comunque: lo
//  COSTRUISCE. Con InpAncoraSessione=true le medie ricominciano da capo
//  a ogni apertura, quindi fuori dalla sessione non esiste proprio
//  nessun numero da incrociare.
input bool   InpAncoraSessione   = true; // Medie RI-SEMINATE all'apertura (false = medie continue: CONTROLLO NEGATIVO)
input int    InpOpenHour         = 14;   // Ora SERVER dell'apertura (Dow/Nasdaq 15:30 IT = 14 server)
input int    InpOpenMin          = 30;   // Minuto SERVER dell'apertura (30 = 14:30 server)
input int    InpSessioneMinuti   = 180;  // Durata della finestra operativa dall'apertura (minuti)
input bool   InpChiudiAFineSessione = true; // A fine finestra chiudo tutto: la posizione muore con la sua sessione

input group "=== Le due medie (ricetta di Claudio: 9 e 21) ==="
input int    InpEmaFast          = 9;    // Media veloce
input int    InpEmaSlow          = 21;   // Media lenta
input int    InpMinBarreSessione = 2;    // Barre di sessione minime perche' un incrocio conti (2 = primo confronto possibile)
//  PERCHE' 2 E NON 5: alla prima barra le due medie valgono ENTRAMBE la
//  chiusura del seme, quindi coincidono. Il primo confronto possibile e'
//  alla seconda barra, e li' l'incrocio dice "da che parte e' andata la
//  sessione appena aperta". Alzando questo numero si cambia CLASSE di
//  evento (non piu' la spinta d'apertura ma il primo ribaltamento della
//  deriva intraday): e' una domanda di un altro round, non una manopola
//  da spazzolare in questo.
input bool   InpSoloPrimoIngresso = false; // Un solo INGRESSO per sessione (opt-in, default: tutti quelli in finestra)
//  Si chiama "ingresso" e non "incrocio" perche' il contatore scatta
//  quando un ordine PARTE davvero: se il segnale c'era ma lo spread lo ha
//  fermato, la sessione resta disponibile. Il nome dice cosa fa il codice.

input group "=== Direzione ==="
input bool   InpAllowLong        = true;  // Ammetti i LONG
input bool   InpAllowShort       = true;  // Ammetti gli SHORT

input group "=== Stop, target, gestione ==="
input int    InpAtrPeriod   = 14;    // Periodo ATR per lo stop (ATR resta sulla serie CONTINUA: e' sizing, non segnale)
input double InpSLatr       = 1.5;   // SL = X * ATR
input double InpTP_RR       = 2.0;   // TP = X volte R (0 = nessun TP)
input double InpTP1_RR      = 1.0;   // Primo target del parziale, in R
input double InpTP1Pct      = 0;     // % chiusa al primo target (0 = parziale SPENTO)
input bool   InpBreakeven   = true;  // Stop in pari dopo il primo target
input bool   InpUseOppositeExit = false; // Chiudi la posizione all'incrocio OPPOSTO di sessione (opt-in)

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay = 0;     // Max ingressi al giorno (0 = illimitato)
input double InpRiskPercent     = 1.0;   // Rischio per trade, % del saldo

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "XEMAAP";   // Commento sugli ordini
input long   InpMagic     = 779600;     // Numero magico (blocco 7796xx: mai usato prima nel repo)
input int    InpMaxSpread = 0;          // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose   = true;       // Messaggi nel log
input bool   InpAutoTest  = true;       // Stampa le righe [XEMAAP][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hEmaF = INVALID_HANDLE;        // usati SOLO nel controllo negativo (medie continue)
int      hEmaS = INVALID_HANDLE;
int      hAtr  = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;

//--- l'ancora, e i suoi canarini
datetime gSessioneCorrente = 0;   // inizio della sessione a cui appartiene l'ultima barra vista
datetime gUltimaSessioneContata = 0;
bool     gIngressoFattoOggi = false;

//--- CANARINI CHE DEVONO VIAGGIARE COI DATI, NON COLLO SCHERMO
//    (checklist punto 34: in ottimizzazione le Print degli agent non le
//    legge nessuno). Finiscono come COLONNE del CSV via FrameAdd.
//    Il piu' importante e' gSessioniViste: se esce 0, la cella NON HA
//    GIRATO -- l'ora dell'ancora non corrisponde a nessuna barra di
//    questo simbolo -- e i suoi numeri non sono "brutti", sono ASSENTI.
long     gSessioniViste   = 0;
long     gIncrociVisti    = 0;
long     gIngressiAperti  = 0;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[XEMAAP] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| L'INCROCIO. fPrev/sPrev = barra precedente, fNow/sNow = barra di  |
//| segnale. Ritorna +1 (long), -1 (short), 0 (niente).                |
//| Il "<=" e il ">=" sul lato precedente servono a NON perdere        |
//| l'incrocio quando le due medie coincidono su una barra -- e qui    |
//| NON e' un caso raro: alla PRIMA barra di sessione le due medie     |
//| valgono per costruzione lo stesso numero (il seme).                |
//| Ripresa alla lettera da ABTG_CrossEma: la regola dell'incrocio non |
//| si reinventa, cambia la SERIE su cui e' calcolata.                 |
//+------------------------------------------------------------------+
int CrossDirezione(const double fPrev,const double sPrev,
                   const double fNow, const double sNow,
                   const bool allowLong,const bool allowShort)
  {
   bool su  = (fPrev<=sPrev && fNow>sNow);
   bool giu = (fPrev>=sPrev && fNow<sNow);
   if(su  && allowLong)  return(+1);
   if(giu && allowShort) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno. Serve a confrontare orari SERVER   |
//| senza toccare le date (e senza inciampare nel fuso).               |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto){ return(ora*60+minuto); }

//+------------------------------------------------------------------+
//| La barra sta dentro la finestra aperta dall'ancora?               |
//| Estremo sinistro INCLUSO (la barra dell'apertura conta), estremo   |
//| destro ESCLUSO (a fine finestra non si entra piu').                |
//+------------------------------------------------------------------+
bool DentroFinestra_Calc(const int minBarra,const int minApertura,const int durata)
  {
   return(minBarra>=minApertura && minBarra<minApertura+durata);
  }

//+------------------------------------------------------------------+
//| LA MEDIA DI SESSIONE -- il cuore dell'EA.                          |
//| chiusure[] in ordine CRONOLOGICO (la [0] e' la prima barra della   |
//| sessione, cioe' il SEME). Restituisce il valore sull'ultima barra  |
//| e su quella prima, che sono i due numeri che servono all'incrocio. |
//|                                                                    |
//| Perche' il seme e' la prima chiusura e non una media di storia     |
//| precedente: se prendessimo lo stato della EMA continua all'ora     |
//| dell'apertura, ci porteremmo dentro la notte -- e la notte e'      |
//| esattamente quello che questa strategia vuole NON guardare. Con    |
//| questo seme la media misura SOLO lo spostamento dall'apertura.     |
//| Conseguenza dichiarata: alla prima barra veloce e lenta            |
//| COINCIDONO, quindi il primo confronto possibile e' alla seconda    |
//| (vedi InpMinBarreSessione).                                        |
//+------------------------------------------------------------------+
bool EmaSessione_Calc(const double &chiusure[],const int n,const int periodo,
                      double &penultimo,double &ultimo)
  {
   if(n<2 || periodo<1) return(false);
   double a = 2.0/((double)periodo+1.0);
   double e = chiusure[0];
   double prec = e;
   for(int i=1;i<n;i++)
     {
      prec = e;
      e = chiusure[i]*a + e*(1.0-a);
     }
   penultimo = prec;
   ultimo    = e;
   return(true);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpEmaFast<1 || InpEmaSlow<1)
     { Print("ERRORE: i periodi delle medie devono essere >= 1."); return(INIT_FAILED); }
   if(InpEmaFast>=InpEmaSlow)
     { Print("ERRORE: InpEmaFast deve essere MINORE di InpEmaSlow (9/21, non il contrario)."); return(INIT_FAILED); }
   if(InpOpenHour<0 || InpOpenHour>23 || InpOpenMin<0 || InpOpenMin>59)
     { Print("ERRORE: InpOpenHour 0-23 e InpOpenMin 0-59. E sono ORE SERVER, non italiane."); return(INIT_FAILED); }
   if(InpSessioneMinuti<5)
     { Print("ERRORE: InpSessioneMinuti deve essere >= 5."); return(INIT_FAILED); }
   //--- limitazione DICHIARATA: niente sessioni a cavallo della mezzanotte.
   if(MinutiDelGiorno_Calc(InpOpenHour,InpOpenMin)+InpSessioneMinuti > 1440)
     {
      Print("ERRORE: apertura + durata scavalcano la mezzanotte. Questo EA non lo gestisce, ",
            "ed e' una limitazione voluta: accorcia InpSessioneMinuti.");
      return(INIT_FAILED);
     }
   if(InpMinBarreSessione<2)
     { Print("ERRORE: InpMinBarreSessione deve essere >= 2 (con una barra sola le due medie coincidono)."); return(INIT_FAILED); }
   if(InpSLatr<=0)
     { Print("ERRORE: InpSLatr deve essere > 0: senza stop non si dimensiona il lotto."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE){ Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- i due handle servono SOLO al controllo negativo (medie continue).
   //    Si creano comunque: costano niente e tengono un solo ramo di codice.
   hEmaF = iMA(_Symbol, gTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
   hEmaS = iMA(_Symbol, gTF, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
   if(hEmaF==INVALID_HANDLE || hEmaS==INVALID_HANDLE)
     { Print("ERRORE: handle medie continue."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione. Se l'ancora e' spenta questa NON e'
   //    la cella del motore R96: e' il CONTROLLO NEGATIVO, cioe' lo schema
   //    "motore gia' bocciato + filtro orario" che in questa casa fa
   //    0 successi su 5. Non lo corregge l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova lo pinna.
   if(!InpAncoraSessione)
      Log("ATTENZIONE: InpAncoraSessione=false. Medie CONTINUE dentro una finestra oraria: "
          "questa e' la CELLA DI CONTROLLO NEGATIVO, non il motore. Non promuovibile.");
   if(InpUseNewsFilter || InpTP1Pct>0 || InpUseOppositeExit || InpSoloPrimoIngresso)
      Log("ATTENZIONE: c'e' almeno un FILTRO/GESTIONE opzionale acceso: questa cella non e' quella base.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestApertura();

   Log(StringFormat("avviato su %s %s. Ancora %02d:%02d SERVER + %d min, medie %d/%d %s, SL %.2f ATR(%d), rischio %.2f%%, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpOpenHour, InpOpenMin, InpSessioneMinuti,
       InpEmaFast, InpEmaSlow, (InpAncoraSessione?"DI SESSIONE":"CONTINUE (controllo)"),
       InpSLatr, InpAtrPeriod, InpRiskPercent, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[3]={hEmaF,hEmaS,hAtr};
   for(int i=0;i<3;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari: a ogni tick
   ChiusuraFineSessione();             // la posizione muore con la sua sessione

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//==================================================================
//  L'ANCORA
//==================================================================

//+------------------------------------------------------------------+
//| L'istante di apertura della sessione del GIORNO di t, in ora      |
//| SERVER. Non guarda il calendario di borsa: se quel giorno il      |
//| mercato e' chiuso semplicemente non ci saranno barre, e il        |
//| canarino gSessioniViste lo dira'.                                 |
//+------------------------------------------------------------------+
datetime InizioSessione(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   d.hour = InpOpenHour; d.min = InpOpenMin; d.sec = 0;
   return(StructToTime(d));
  }

//+------------------------------------------------------------------+
//| Le chiusure delle barre GIA' CHIUSE che appartengono alla         |
//| sessione, in ordine CRONOLOGICO. Parte dalla barra [1] e va       |
//| indietro finche' resta dentro la sessione.                        |
//| Il tetto a 2000 barre non e' un limite di strategia: e' una rete  |
//| contro un ciclo che non finisce se lo storico e' sporco.          |
//+------------------------------------------------------------------+
int RaccogliChiusureSessione(const datetime inizioSess,double &out[])
  {
   double tmp[]; ArrayResize(tmp,0);
   int n=0;
   for(int sh=1; sh<=2000; sh++)
     {
      datetime t = iTime(_Symbol,gTF,sh);
      if(t<=0)          break;         // storico finito
      if(t < inizioSess) break;        // siamo usciti dalla sessione
      double c = iClose(_Symbol,gTF,sh);
      if(c<=0)          break;
      ArrayResize(tmp,n+1); tmp[n]=c; n++;
     }
   ArrayResize(out,n);
   for(int i=0;i<n;i++) out[i]=tmp[n-1-i];   // dal piu' vecchio al piu' recente
   return(n);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE CON L'ANCORA ACCESA (il motore di R96).                |
//| nBarre esce valorizzato col numero di barre di sessione viste.    |
//+------------------------------------------------------------------+
int SegnaleSessione(int &nBarre)
  {
   nBarre = 0;
   datetime tSeg = iTime(_Symbol,gTF,1);
   if(tSeg<=0) return(0);

   datetime inizio = InizioSessione(tSeg);
   if(tSeg < inizio) return(0);          // la barra di segnale e' PRIMA dell'apertura di oggi

   double chiusure[];
   int n = RaccogliChiusureSessione(inizio, chiusure);
   nBarre = n;
   if(n < InpMinBarreSessione) return(0);

   double fPrev=0,fNow=0,sPrev=0,sNow=0;
   if(!EmaSessione_Calc(chiusure,n,InpEmaFast,fPrev,fNow)) return(0);
   if(!EmaSessione_Calc(chiusure,n,InpEmaSlow,sPrev,sNow)) return(0);

   return(CrossDirezione(fPrev,sPrev,fNow,sNow,true,true));
  }

//+------------------------------------------------------------------+
//| IL SEGNALE CON L'ANCORA SPENTA (controllo negativo): la EMA 9/21  |
//| CONTINUA, identica a quella di ABTG_CrossEma. Qui l'orario e' un  |
//| filtro appiccicato -- ed e' esattamente cio' che il round vuole   |
//| mettere a confronto, non promuovere.                              |
//+------------------------------------------------------------------+
int SegnaleContinuo()
  {
   double f[], s[];
   ArraySetAsSeries(f,true); ArraySetAsSeries(s,true);
   if(CopyBuffer(hEmaF,0,1,2,f)!=2) return(0);
   if(CopyBuffer(hEmaS,0,1,2,s)!=2) return(0);
   // f[0]/s[0] = barra chiusa [1]; f[1]/s[1] = barra [2]
   return(CrossDirezione(f[1],s[1],f[0],s[0],true,true));
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   datetime tSeg = iTime(_Symbol,gTF,1);
   if(tSeg<=0) return;

   //--- a quale sessione appartiene la barra di segnale?
   datetime inizio = InizioSessione(tSeg);
   MqlDateTime b; TimeToStruct(tSeg,b);
   int minBarra = MinutiDelGiorno_Calc(b.hour,b.min);
   bool inFinestra = DentroFinestra_Calc(minBarra,
                                         MinutiDelGiorno_Calc(InpOpenHour,InpOpenMin),
                                         InpSessioneMinuti);

   if(inizio!=gSessioneCorrente){ gSessioneCorrente=inizio; gIngressoFattoOggi=false; }

   //--- il segnale grezzo, secondo la modalita' scelta
   int grezzo = 0;
   int nBarre = 0;
   if(InpAncoraSessione) grezzo = SegnaleSessione(nBarre);
   else                  grezzo = SegnaleContinuo();

   //--- CANARINO: la sessione e' stata davvero "vista"? Si conta UNA volta
   //    per sessione, alla prima barra in finestra con abbastanza storia.
   //    Se a fine corsa questo numero e' 0, la cella non ha girato: l'ora
   //    dell'ancora non corrisponde a nessuna barra di questo simbolo.
   if(inFinestra && inizio!=gUltimaSessioneContata)
     {
      bool contabile = InpAncoraSessione ? (nBarre>=InpMinBarreSessione) : true;
      if(contabile){ gSessioniViste++; gUltimaSessioneContata=inizio; }
     }

   if(grezzo!=0 && inFinestra) gIncrociVisti++;

   //--- 1. USCITA sull'incrocio opposto (opt-in). PRIMA dell'ingresso.
   if(InpUseOppositeExit && grezzo!=0) ChiudiSeOpposto(grezzo);

   //--- 2. INGRESSO. Fuori dalla finestra NON si entra mai: fuori dalla
   //    finestra, con l'ancora accesa, non esiste nemmeno il segnale.
   if(grezzo==0)   return;
   if(!inFinestra) return;
   if(InpSoloPrimoIngresso && gIngressoFattoOggi) return;
   if(grezzo>0 && !InpAllowLong)  return;
   if(grezzo<0 && !InpAllowShort) return;

   if(CountPositions()>0) return;                      // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!SpreadOK()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;

   Enter(grezzo>0);
  }

//==================================================================
//  INGRESSO
//==================================================================
void Enter(bool isLong)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1 || a[0]<=0){ Log("ATR non disponibile: salto."); return; }
   double atr = a[0];

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry = isLong ? ask : bid;

   double sl = NormalizePrice(isLong ? entry-atr*InpSLatr : entry+atr*InpSLatr);
   double R  = isLong ? (entry-sl) : (sl-entry);

   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=0 || R<=minDist){ Log("SL troppo vicino al prezzo (stops level): salto."); return; }

   double tp = 0;
   if(InpTP_RR>0)
     {
      tp = NormalizePrice(isLong ? entry+R*InpTP_RR : entry-R*InpTP_RR);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return; }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_CrossEmaApertura")) return;

   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      gIngressiAperti++;
      gIngressoFattoOggi = true;
      Log(StringFormat("%s @ %s SL %s TP %s lot %.2f (R %s)",
          isLong?"LONG":"SHORT",
          DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits)));
     }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//==================================================================
//  USCITE E GESTIONE
//==================================================================

//+------------------------------------------------------------------+
//| A FINE FINESTRA SI CHIUDE TUTTO. Non e' una "uscita a tempo"      |
//| appiccicata: e' la conseguenza dell'ancora. Se il segnale esiste  |
//| solo perche' l'apertura lo ha generato, non ha senso portarselo   |
//| dentro la notte. Gira a ogni tick perche' l'ora di fine cade in   |
//| mezzo a una barra.                                                |
//+------------------------------------------------------------------+
void ChiusuraFineSessione()
  {
   if(!InpChiudiAFineSessione) return;
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   int m = MinutiDelGiorno_Calc(t.hour,t.min);
   if(m < MinutiDelGiorno_Calc(InpOpenHour,InpOpenMin)+InpSessioneMinuti) return;

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(p)) Log("fine sessione: posizione chiusa.");
     }
  }

//+------------------------------------------------------------------+
//| Chiude la posizione se l'incrocio va CONTRO di lei (opt-in).      |
//+------------------------------------------------------------------+
void ChiudiSeOpposto(int grezzo)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      bool contro = (isLong && grezzo<0) || (!isLong && grezzo>0);
      if(!contro) continue;

      if(gTrade.PositionClose(tk)) Log("incrocio opposto: posizione chiusa.");
      else                         Log("incrocio opposto: chiusura fallita: "+gTrade.ResultRetcodeDescription());
     }
  }

//+------------------------------------------------------------------+
//| Parziale al primo target + stop in pari. Gira a OGNI tick: il     |
//| target si tocca in mezzo alla barra.                              |
//| NOTA SUL DEFAULT: con InpTP1Pct=0 questo blocco NON fa niente.    |
//| E' voluto: la cella base del round dev'essere SL/TP e basta.      |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      double vol    = PositionGetDouble(POSITION_VOLUME);
      if(sl<=0) continue;                       // senza stop non so quanto vale 1 R

      double R = isLong ? (openP-sl) : (sl-openP);
      bool   beFatto = isLong ? (sl>=openP) : (sl<=openP);

      if(!beFatto && InpTP1Pct>0 && R>0)
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            //  LEZIONE PTE (04/08/2026): lo STOP IN PARI non deve dipendere
            //  dalla riuscita del parziale. Al lotto minimo NormVol()
            //  arrotonda a 0, il parziale non parte, e prima di quella
            //  lezione con lui saltava anche il breakeven.
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
            Log(parz ? "primo target: parziale eseguito."
                     : "primo target: parziale impossibile al lotto minimo.");
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
//| Sta fuori dal filtro della barra nuova apposta: la caduta         |
//| peggiore di giornata succede in mezzo a una candela.              |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;              // conto a zero: niente da dividere
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

//--- Lotto dalla distanza dello stop, come negli altri EA ABTG.
//    PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026):
//    su 225JPY il tick value arriva non convertito in valuta conto e il
//    lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit converte
//    correttamente; il tick value resta come ripiego. Sui simboli sani i
//    due calcoli coincidono: cambia SOLO dove il tick value mente.
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

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

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): la compilazione non stampa
//  niente. E MAI attaccando l'EA a un grafico del PC di backtest:
//  quel terminale e' collegato al conto vivo.
//==================================================================
void AutoTestApertura()
  {
   int falliti=0;

   PrintFormat("[XEMAAP][AUTOTEST] ancora=%d | apertura %02d:%02d SERVER + %d min | medie %d/%d | minbarre %d | magic %I64d | %s",
               (int)InpAncoraSessione, InpOpenHour, InpOpenMin, InpSessioneMinuti,
               InpEmaFast, InpEmaSlow, InpMinBarreSessione, InpMagic, _Symbol);

   //--- 1. L'INCROCIO (medie finte, cosi' il caso e' leggibile a occhio)
   int c1 = CrossDirezione( 9.0,10.0, 11.0,10.0, true,true);   // sotto -> sopra  = +1
   int c2 = CrossDirezione(11.0,10.0,  9.0,10.0, true,true);   // sopra -> sotto  = -1
   int c3 = CrossDirezione(11.0,10.0, 12.0,10.0, true,true);   // gia' sopra, resta sopra = 0
   int c4 = CrossDirezione(10.0,10.0, 11.0,10.0, true,true);   // partenza dal SEME poi sopra = +1
   PrintFormat("[XEMAAP][AUTOTEST] incrocio: su=%d (atteso +1) | giu=%d (atteso -1) | nessuno=%d (atteso 0) | dal seme=%d (atteso +1)",
               c1,c2,c3,c4);
   if(!(c1==1 && c2==-1 && c3==0 && c4==1)) falliti++;

   //--- 2. LA FINESTRA (estremo sinistro incluso, destro escluso)
   int ap = MinutiDelGiorno_Calc(14,30);      // 870
   bool w1 = DentroFinestra_Calc(MinutiDelGiorno_Calc(14,30), ap, 180);  // la barra dell'apertura: DENTRO
   bool w2 = DentroFinestra_Calc(MinutiDelGiorno_Calc(17,25), ap, 180);  // ultima utile: DENTRO
   bool w3 = DentroFinestra_Calc(MinutiDelGiorno_Calc(17,30), ap, 180);  // fine esatta: FUORI
   bool w4 = DentroFinestra_Calc(MinutiDelGiorno_Calc( 3, 0), ap, 180);  // le 3 di notte: FUORI
   bool w5 = DentroFinestra_Calc(MinutiDelGiorno_Calc(14,25), ap, 180);  // 5 min prima: FUORI
   PrintFormat("[XEMAAP][AUTOTEST] finestra 14:30+180: apertura=%d (1) | 17:25=%d (1) | 17:30=%d (0) | 03:00=%d (0) | 14:25=%d (0)",
               (int)w1,(int)w2,(int)w3,(int)w4,(int)w5);
   if(!(w1 && w2 && !w3 && !w4 && !w5)) falliti++;

   //--- 3. LA MEDIA DI SESSIONE, con numeri calcolati a mano.
   //    Serie 100,101,102,103 e periodo 3 -> alfa 0,5:
   //      e0=100  e1=100,5  e2=101,25  e3=102,125
   double serie[4]; serie[0]=100.0; serie[1]=101.0; serie[2]=102.0; serie[3]=103.0;
   double pen=0,ult=0;
   bool okE = EmaSessione_Calc(serie,4,3,pen,ult);
   PrintFormat("[XEMAAP][AUTOTEST] media di sessione: ok=%d (1) | penultimo=%.4f (atteso 101.2500) | ultimo=%.4f (atteso 102.1250)",
               (int)okE,pen,ult);
   if(!(okE && MathAbs(pen-101.25)<0.0001 && MathAbs(ult-102.125)<0.0001)) falliti++;

   //--- 4. IL SEME: alla PRIMA barra le due medie coincidono, quindi con
   //    una barra sola non si puo' calcolare niente. E' la ragione per cui
   //    InpMinBarreSessione non puo' scendere sotto 2.
   double una[1]; una[0]=100.0;
   double p1=0,u1=0;
   bool okUna = EmaSessione_Calc(una,1,9,p1,u1);
   //    e con DUE barre veloce e lenta partono dallo stesso seme e si
   //    separano: la veloce reagisce di piu'.
   double due[2]; due[0]=100.0; due[1]=110.0;
   double pf=0,uf=0,ps=0,us=0;
   bool okF = EmaSessione_Calc(due,2,9,pf,uf);      // alfa 0,2  -> 102,0
   bool okS = EmaSessione_Calc(due,2,21,ps,us);     // alfa ~0,0909 -> ~100,909
   int cSeme = CrossDirezione(pf,ps,uf,us,true,true);
   PrintFormat("[XEMAAP][AUTOTEST] seme: una barra ok=%d (atteso 0) | due barre veloce=%.4f lenta=%.4f incrocio=%d (atteso +1)",
               (int)okUna,uf,us,cSeme);
   if(!(!okUna && okF && okS && uf>us && cSeme==1)) falliti++;

   //--- 5. LA SESSIONE A CAVALLO DELLA MEZZANOTTE e' RIFIUTATA in OnInit:
   //    qui si verifica solo l'aritmetica che la rifiuta.
   bool mz1 = (MinutiDelGiorno_Calc(14,30)+180 <= 1440);   // 1050: ammessa
   bool mz2 = (MinutiDelGiorno_Calc(23, 0)+180 <= 1440);   // 1560: rifiutata
   PrintFormat("[XEMAAP][AUTOTEST] mezzanotte: 14:30+180 ammessa=%d (1) | 23:00+180 ammessa=%d (0)",(int)mz1,(int)mz2);
   if(!(mz1 && !mz2)) falliti++;

   Print("[XEMAAP][AUTOTEST] esito motore: ", (falliti==0
         ? "CINQUE BLOCCHI SU CINQUE, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   if(!InpAncoraSessione)
      Print("[XEMAAP][AUTOTEST] MODO: ANCORA SPENTA = CONTROLLO NEGATIVO (medie continue in finestra oraria). NON promuovibile.");
   else
      Print("[XEMAAP][AUTOTEST] MODO: ANCORA ACCESA = motore R96 (medie di sessione).");

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

//  I QUATTRO CANARINI IN CODA ALLE DIECI METRICHE STANDARD.
//  Stanno in una COLONNA e non in una Print perche' in ottimizzazione le
//  Print girano sugli agent e non le legge nessuno (checklist punto 34).
//  header e StringFormat si toccano INSIEME, o le colonne scalano di posto.
double OnTester()
  {
   //--- IL CANARINO ANCHE A SCHERMO, e serve davvero.
   //    In OTTIMIZZAZIONE questa riga gira sull'AGENTE e non la legge nessuno
   //    (checklist punto 34): per quello i numeri stanno ANCHE nelle colonne.
   //    Ma in una PASSATA SINGOLA -- che e' il gate del PASSO 0 -- le colonne
   //    NON esistono, perche' OnTesterDeinit (che scrive il CSV) gira solo in
   //    ottimizzazione. Li' questa riga e' l'unico modo di leggere se l'ancora
   //    ha trovato le sessioni. Le due strade non si sostituiscono: servono
   //    tutte e due, e ognuna copre la modalita' in cui l'altra e' muta.
   PrintFormat("[XEMAAP][CONTEGGIO] sessioni=%I64d incroci=%I64d ingressi=%I64d ancora=%d apertura=%02d:%02d durata=%d",
               gSessioniViste, gIncrociVisti, gIngressiAperti, (int)InpAncoraSessione,
               InpOpenHour, InpOpenMin, InpSessioneMinuti);

   ExportTrades();
   double stats[14];
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
   //--- i canarini dell'ancora
   stats[10] = (double)gSessioniViste;                  // 0 = la cella NON HA GIRATO
   stats[11] = (double)gIncrociVisti;                   // incroci grezzi dentro la finestra
   stats[12] = (double)gIngressiAperti;                 // quanti sono diventati un trade
   stats[13] = (InpAncoraSessione ? 1.0 : 0.0);         // il MODO, scritto dentro il dato
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Sessioni Viste,Incroci Sessione,Ingressi Aperti,Ancora Sessione";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9], data[10], data[11], data[12], data[13]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
//+------------------------------------------------------------------+
