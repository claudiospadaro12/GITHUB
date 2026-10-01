//+------------------------------------------------------------------+
//|                                     ABTG_EMA200_Multi_BANCO.mq5   |
//|                                                                  |
//|  =============================================================== |
//|  README -- LEGGERE PRIMA DI TUTTO                                |
//|  =============================================================== |
//|  >>> DEMO/TESTER, NON E' UNA SEDIA, NON HA TAGLIA APPROVATA. <<< |
//|                                                                  |
//|  COPIA DI BANCO di ABTG_EMA200.mq5 (la sedia viva 771531 NON e'  |
//|  stata toccata, ne' il sorgente ne' i suoi preset). Serve SOLO  |
//|  al banco (Strategy Tester). Mandato di Claudio del 01/10/2026: |
//|  "due ordini pendenti con size stabilite appena vede la EMA     |
//|  200, che gestisca la posizione, che metta TP e SL", "CON       |
//|  INDICI E ORO".                                                  |
//|                                                                  |
//|  BLOCCHI DI SICUREZZA SCRITTI NEL CODICE (non sono input):      |
//|   - su un conto REALE l'EA RIFIUTA di partire (INIT_FAILED);     |
//|   - fuori dal tester parte solo su conto DEMO e solo se          |
//|     InpConsentiDemo=true (default false);                        |
//|   - niente martingala, griglia, recovery, hedging fra conti;    |
//|   - nessuna chiamata di rete (niente WebRequest).                |
//|                                                                  |
//|  COSA FA (cuore identico all'EA vivo, per ogni simbolo x TF):   |
//|   - direzione dal lato del prezzo vs EMA200 (+ opz. EMA14);      |
//|   - due ordini LIMITE: 1o a InpOrder1Atr*ATR oltre la EMA200     |
//|     verso il prezzo, 2o overshoot a InpOrder2Atr*ATR;            |
//|   - SL a InpSLatr*ATR oltre il 2o; TP in R; parziale su EMA14 + |
//|     stop in pari; trailing su EMA14; scadenza pendenti; cutoff;  |
//|     Guardian (fail-open nel tester, come nell'EA vivo).          |
//|                                                                  |
//|  COSA AGGIUNGE:                                                  |
//|   - MULTI-SIMBOLO e MULTI-TF da un solo grafico (InpSymbols,     |
//|     InpTFs). Una coppia di pendenti / una posizione per          |
//|     simbolo-TF; opzione "niente sovrapposizione fra TF sullo     |
//|     stesso simbolo" (InpNoOverlapTF, default true).              |
//|   - DIMENSIONAMENTO a scelta: rischio % (come l'EA vivo) oppure  |
//|     LOTTI FISSI per ordine (InpLotMode). I valori dei lotti li   |
//|     sceglie Claudio: qui ci sono solo default prudenti (0 = il   |
//|     lotto MINIMO del simbolo).                                   |
//|   - TETTO per setup (InpMaxRiskPctPerSetup) e TETTO di rischio   |
//|     aperto TOTALE dell'EA (InpMaxOpenRiskPctTotale) che SOMMA il |
//|     rischio dell'ingresso NUOVO prima di inviare (lezione del    |
//|     01/10: il C1 del Guardian non lo somma, vedi                 |
//|     report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md).                  |
//|   - CSV degli ordini e dei rifiuti (causa per causa) e CSV       |
//|     per-trade che contiene ANCHE l'ora d'INGRESSO (classe 933).  |
//|                                                                  |
//|  MAGIC: InpMagicBase + 10*indice_simbolo + codice_TF.            |
//|   indice_simbolo = posizione (0..9) del simbolo nella lista      |
//|   InpSymbols, contando i token non vuoti (un simbolo che non si  |
//|   seleziona NON fa scalare gli altri).                           |
//|   codice_TF FISSO (non dipende dall'ordine della lista):         |
//|   M1=0 M5=1 M15=2 M30=3 H1=4 H2=5 H4=6 H8=7 D1=8 W1=9            |
//|   Base 785100 -> intervallo 785100..785199, verificato LIBERO    |
//|   con git grep il 01/10/2026 (zero occorrenze nel repo).         |
//|   Con i default: D30EUR H1=785104 H4=785106 | U30USD 785114/116  |
//|   | NASUSD 785124/126 | SPXUSD 785134/136 | XAUUSD 785144/146.     |
//|                                                                  |
//|  NOMI DEI SIMBOLI: i default sono quelli BCM. Su FTMO i nomi     |
//|  sono DIVERSI: D30EUR->GER40.cash  U30USD->US30.cash             |
//|  NASUSD->US100.cash  SPXUSD->US500.cash  XAUUSD->XAUUSD.         |
//|                                                                  |
//|  OROLOGIO: tutte le ore (cutoff, venerdi') sono ORA SERVER.      |
//|  BCM oggi e' UTC+1 FISSO (report/OROLOGIO_BCM_2026-09-24.md):    |
//|  d'estate = ora italiana - 1, d'inverno = ora italiana.          |
//|                                                                  |
//|  NEL TESTER: mettere il grafico sul simbolo con l'orario piu'    |
//|  largo (XAUUSD). OnTick arriva SOLO dal simbolo del grafico: per |
//|  questo c'e' anche un timer (InpTimerSec) che fa girare la       |
//|  stessa routine quando il simbolo del grafico e' fermo.          |
//|  Gli altri simboli hanno dati solo dopo il primo tick: finche'   |
//|  la serie non e' sincronizzata e gli indicatori non sono         |
//|  calcolati, il simbolo-TF e' "NON PRONTO" e non opera (contato   |
//|  nell'imbuto, mai in silenzio).                                  |
//|                                                                  |
//|  Fonte della logica: ABTG_EMA200.mq5 a HEAD del 01/10/2026.      |
//|  Scostamenti VOLUTI dall'EA vivo, tutti dichiarati nel codice   |
//|  con la sigla [SCOSTAMENTO].                                     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "0.10"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO (firme B1/C1 del 18/08/2026), come nell'EA vivo.
//    Nel tester le sue GlobalVariable non esistono: fail-open totale.
input bool InpUsaGuardian = true;  // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)

//==================================================================
//  INPUT
//==================================================================
enum ENUM_MODO_LOTTO
  {
   LOTTO_RISCHIO = 0,   // lotto dal rischio % (come l'EA vivo)
   LOTTO_FISSO   = 1    // lotti fissi per ordine (InpLotOrder1/2)
  };

input group "=== Banco: sicurezza ==="
input bool   InpConsentiDemo = false; // fuori dal tester: parte SOLO su DEMO e solo se true. Sul REALE mai.

input group "=== Simboli e timeframe (multi) ==="
input string InpSymbols     = "D30EUR;U30USD;NASUSD;SPXUSD;XAUUSD"; // lista simboli (; o ,), max 10. Nomi BCM
input string InpTFs         = "H1,H4";  // lista TF: M1 M5 M15 M30 H1 H2 H4 H8 D1 W1
input bool   InpNoOverlapTF = true;     // niente nuovo setup se un altro TF dello stesso simbolo e' occupato
input int    InpTimerSec    = 30;       // timer di servizio (s). 0 = solo OnTick del grafico

input group "=== EMA e distanza operativa ==="
input int    InpEmaPeriod  = 200;
input int    InpEma14Period = 14;          // primo target
input int    InpAtrPeriod  = 14;
input double InpMinDistAtr  = 0.3;         // prezzo non gia' sulla media (dist. minima)
input double InpMaxDistAtr  = 1.5;         // prezzo abbastanza vicino (dist. massima)
input bool   InpUseEma14Bias = true;       // richiedi EMA14 dallo stesso lato
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Filtro ADR-distanza (opt-in) ==="
input bool   InpUseAdrFilter = false;
input int    InpAdrDays      = 50;
input double InpAdrDistMin   = 0.0;
input double InpAdrDistMax   = 0.8;

input group "=== Ordini pendenti (limite) ==="
input double InpOrder1Atr   = 0.10; // 1o ordine: verso il prezzo, oltre la EMA200 di N*ATR
input double InpOrder2Atr   = 0.35; // 2o ordine: oltre la EMA200 (overshoot) di N*ATR
input bool   InpUseOrder2    = true;
input int    InpPendingExpiryBars = 6; // scadenza pendenti non eseguiti (barre del TF del setup)

input group "=== Stop / target ==="
input double InpSLatr       = 1.0;  // SL = N*ATR oltre il 2o ordine
input double InpMinRR       = 1.0;  // salta se RR < questo
input double InpTP_RR       = 2.0;  // TP finale in R
input double InpTP1_ATRmult = 0.0;  // 0 = TP1 su EMA14; altrimenti N*ATR
input double InpTP1Pct      = 50;
input bool   InpBreakeven   = true;
input bool   InpUseTrailing = true; // trailing su EMA14 dopo il 1o target

input group "=== Cutoff (ORA SERVER) ==="
input bool   InpUseCutoff   = false;
input int    InpCutoffHour  = 19;
input int    InpCutoffMin   = 0;

input group "=== Dimensionamento e tetti di rischio ==="
input ENUM_MODO_LOTTO InpLotMode = LOTTO_RISCHIO; // rischio % oppure lotti fissi
input double InpRiskPercent = 0.5;   // [LOTTO_RISCHIO] rischio % per SETUP (diviso tra gli ordini)
input double InpLotOrder1   = 0.0;   // [LOTTO_FISSO] lotti 1o ordine. 0 = lotto minimo del simbolo
input double InpLotOrder2   = 0.0;   // [LOTTO_FISSO] lotti 2o ordine. 0 = lotto minimo del simbolo
input double InpMaxRiskPctPerSetup   = 1.0; // tetto: rischio EFFETTIVO del setup (somma degli ordini), % di min(saldo,equity)
input double InpMaxOpenRiskPctTotale = 3.0; // tetto: rischio aperto di TUTTO l'EA + setup nuovo, % di min(saldo,equity)
input int    InpMaxTradesPerDay = 0;        // per simbolo-TF, come l'EA vivo (0 = nessun tetto)

input group "=== Filtro notizie ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "EMA200M";
input bool   InpFridayClose     = false;
input int    InpFridayCloseHour  = 20;     // ORA SERVER
input long   InpMagicBase = 785100;        // intervallo usato: base .. base+99
input int    InpMaxSpread = 0;             // in punti del simbolo; UNO per tutti: 0 = spento
input bool   InpVerbose   = true;
input bool   InpLogImbuto = true;          // riepilogo giornaliero dei rifiuti nel Giornale
input bool   InpLogCsvOrdini = true;       // CSV ordini/rifiuti in Common\Files (spento in ottimizzazione)
input int    InpCsvLivello   = 2;          // 1 = gambe/setup/invii; 2 = anche le candidate scartate

//==================================================================
//  STATO PER SIMBOLO x TF ("slot")
//==================================================================
struct Slot
  {
   string          sym;
   ENUM_TIMEFRAMES tf;
   int             tfCode;
   int             symIdx;
   long            magic;
   int             hEma;
   int             hEma14;
   int             hAtr;
   datetime        lastBarDone;  // ultima barra VALUTATA
   datetime        lastBarNP;    // ultima barra contata come NON PRONTA
   int             day;
   int             tradesToday;
   int             piazzati;     // ordini piazzati (riepilogo a fine corsa)
  };

Slot     gS[];
int      gNS=0;
CTrade   gTrade;
int      gCsv=INVALID_HANDLE;
ulong    gParz[];               // ticket che hanno gia' fatto il parziale
datetime gUltimoLogMod=0;       // log degli errori di modifica: max 1/minuto

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void LogM(string m){ if(InpVerbose) Print("[EMA200M] ", m); }

//==================================================================
//  IMBUTO -- SOLO DIAGNOSTICA (nessun contatore entra in una
//  condizione). QUATTRO stadi, QUATTRO quadrature:
//   stadio 1 CANDIDATE (per barra nuova di ogni simbolo-TF):
//       valutate = rifiuti + ARMATE
//   stadio 2 GAMBE (1 o 2 per candidata armata):
//       gambe tentate = rifiuti di gamba + GAMBE OK
//   stadio 3 SETUP (uno per candidata armata, sulle sole gambe OK):
//       ARMATE = rifiuti di setup + SETUP OK
//   stadio 4 INVII (una per gamba OK di un setup OK):
//       invii tentati = guardian + invio fallito + PIAZZATI
//  Fuori quadratura, informativo: barre rimandate per dati NON PRONTI
//  (la barra e' rivalutata quando i dati arrivano, se e' ancora la
//  stessa).
//==================================================================
#define IMB_VALUTATE      0
#define IMB_OCCUPATA      1
#define IMB_OVERLAP       2
#define IMB_MAXDAY        3
#define IMB_NEWS          4
#define IMB_SPREAD        5
#define IMB_IND           6
#define IMB_FASCIA        7
#define IMB_ADR           8
#define IMB_LATO          9
#define IMB_EMA14        10
#define IMB_ARMATE       11
#define IMB_G_TENTATE    12
#define IMB_G_SL         13
#define IMB_G_RR         14
#define IMB_G_PREZZO     15
#define IMB_G_LOTTO      16
#define IMB_G_RISCHIO_NC 17
#define IMB_G_OK         18
#define IMB_S_NESSUNA    19
#define IMB_S_CONTO_NC   20
#define IMB_S_TETTO_SET  21
#define IMB_S_APERTO_NC  22
#define IMB_S_TETTO_TOT  23
#define IMB_S_OK         24
#define IMB_O_TENTATI    25
#define IMB_O_GUARDIAN   26
#define IMB_O_INVIO      27
#define IMB_O_PIAZZATI   28
#define IMB_NONPRONTO    29
#define IMB_N            30

long     gC[IMB_N];
long     gImbSnap[IMB_N];
int      gImbGiorno=-1;
datetime gImbData=0;

string NomeImb(const int k)
  {
   switch(k)
     {
      case IMB_VALUTATE:     return("CANDIDATE valutate");
      case IMB_OCCUPATA:     return("occupata");
      case IMB_OVERLAP:      return("overlap TF");
      case IMB_MAXDAY:       return("tetto giornaliero");
      case IMB_NEWS:         return("news");
      case IMB_SPREAD:       return("spread");
      case IMB_IND:          return("indicatori n/d");
      case IMB_FASCIA:       return("fuori fascia ATR");
      case IMB_ADR:          return("filtro ADR");
      case IMB_LATO:         return("lato spento");
      case IMB_EMA14:        return("bias EMA14");
      case IMB_ARMATE:       return("ARMATE");
      case IMB_G_TENTATE:    return("GAMBE tentate");
      case IMB_G_SL:         return("SL non valido");
      case IMB_G_RR:         return("RR sotto il minimo");
      case IMB_G_PREZZO:     return("prezzo/stops level");
      case IMB_G_LOTTO:      return("lotto (nullo/min/max)");
      case IMB_G_RISCHIO_NC: return("rischio non calcolabile");
      case IMB_G_OK:         return("GAMBE OK");
      case IMB_S_NESSUNA:    return("nessuna gamba OK");
      case IMB_S_CONTO_NC:   return("saldo/equity non validi");
      case IMB_S_TETTO_SET:  return("tetto per setup");
      case IMB_S_APERTO_NC:  return("rischio aperto non misurabile");
      case IMB_S_TETTO_TOT:  return("tetto rischio aperto totale");
      case IMB_S_OK:         return("SETUP OK");
      case IMB_O_TENTATI:    return("INVII tentati");
      case IMB_O_GUARDIAN:   return("guardian");
      case IMB_O_INVIO:      return("invio fallito");
      case IMB_O_PIAZZATI:   return("PIAZZATI");
      case IMB_NONPRONTO:    return("barre rimandate: dati NON PRONTI");
     }
   return("?");
  }

string ImbTratto(const long &d[],const int da,const int a)
  {
   string s="";
   for(int k=da;k<=a;k++) s+=" | "+NomeImb(k)+" "+IntegerToString(d[k]);
   return(s);
  }

string ImbQuadra(const long somma,const long atteso,const string cosa)
  {
   if(somma==atteso) return(" | quadratura OK");
   return(" | quadratura ROTTA: somma "+IntegerToString(somma)+" contro "+cosa+" "+IntegerToString(atteso));
  }

void ImbutoStampa(const string quando)
  {
   if(!InpLogImbuto) return;
   long d[IMB_N];
   bool vuoto=true;
   for(int k=0;k<IMB_N;k++){ d[k]=gC[k]-gImbSnap[k]; if(d[k]!=0) vuoto=false; }
   if(vuoto) return;
   long s1=0; for(int k=IMB_OCCUPATA;k<=IMB_ARMATE;k++)      s1+=d[k];
   long s2=0; for(int k=IMB_G_SL;k<=IMB_G_OK;k++)            s2+=d[k];
   long s3=0; for(int k=IMB_S_NESSUNA;k<=IMB_S_OK;k++)       s3+=d[k];
   long s4=0; for(int k=IMB_O_GUARDIAN;k<=IMB_O_PIAZZATI;k++) s4+=d[k];
   Print("[EMA200M-IMBUTO] "+quando+" S1"+ImbTratto(d,IMB_VALUTATE,IMB_ARMATE)+ImbQuadra(s1,d[IMB_VALUTATE],"valutate"));
   Print("[EMA200M-IMBUTO] "+quando+" S2"+ImbTratto(d,IMB_G_TENTATE,IMB_G_OK)+ImbQuadra(s2,d[IMB_G_TENTATE],"gambe tentate"));
   Print("[EMA200M-IMBUTO] "+quando+" S3 | ARMATE "+IntegerToString(d[IMB_ARMATE])+ImbTratto(d,IMB_S_NESSUNA,IMB_S_OK)+ImbQuadra(s3,d[IMB_ARMATE],"armate"));
   Print("[EMA200M-IMBUTO] "+quando+" S4"+ImbTratto(d,IMB_O_TENTATI,IMB_O_PIAZZATI)+ImbQuadra(s4,d[IMB_O_TENTATI],"invii tentati")+
         " | "+NomeImb(IMB_NONPRONTO)+" "+IntegerToString(d[IMB_NONPRONTO]));
  }

void ImbutoFoto(){ for(int k=0;k<IMB_N;k++) gImbSnap[k]=gC[k]; }

void ImbutoGiro()
  {
   if(!InpLogImbuto) return;
   datetime ora=TimeCurrent();
   MqlDateTime t; TimeToStruct(ora,t);
   if(gImbGiorno<0){ gImbGiorno=t.day_of_year; gImbData=ora; ImbutoFoto(); return; }
   if(t.day_of_year==gImbGiorno) return;
   ImbutoStampa("giorno "+TimeToString(gImbData,TIME_DATE));
   ImbutoFoto();
   gImbGiorno=t.day_of_year; gImbData=ora;
  }

//==================================================================
//  TABELLA DEI TIMEFRAME (codice FISSO -> magic deterministico)
//==================================================================
ENUM_TIMEFRAMES TfDaCodice(const int c)
  {
   switch(c)
     {
      case 0: return(PERIOD_M1);
      case 1: return(PERIOD_M5);
      case 2: return(PERIOD_M15);
      case 3: return(PERIOD_M30);
      case 4: return(PERIOD_H1);
      case 5: return(PERIOD_H2);
      case 6: return(PERIOD_H4);
      case 7: return(PERIOD_H8);
      case 8: return(PERIOD_D1);
      case 9: return(PERIOD_W1);
     }
   return(PERIOD_CURRENT);
  }

string NomeTfCodice(const int c)
  {
   switch(c)
     {
      case 0: return("M1");
      case 1: return("M5");
      case 2: return("M15");
      case 3: return("M30");
      case 4: return("H1");
      case 5: return("H2");
      case 6: return("H4");
      case 7: return("H8");
      case 8: return("D1");
      case 9: return("W1");
     }
   return("?");
  }

int CodiceDaNomeTf(const string nome)
  {
   for(int c=0;c<10;c++) if(NomeTfCodice(c)==nome) return(c);
   return(-1);
  }

//--- lista "A;B,C" -> token non vuoti (spazi tolti)
int Spezza(const string lista,string &uscita[])
  {
   string s=lista;
   StringReplace(s,",",";");
   StringReplace(s," ","");
   StringReplace(s,"\t","");
   string p[];
   int n=StringSplit(s,';',p);
   ArrayResize(uscita,0);
   int k=0;
   for(int i=0;i<n;i++)
     {
      if(StringLen(p[i])==0) continue;
      ArrayResize(uscita,k+1); uscita[k]=p[i]; k++;
     }
   return(k);
  }

bool MagicMio(const long mg){ return(mg>=InpMagicBase && mg<=InpMagicBase+99); }

//+------------------------------------------------------------------+
int OnInit()
  {
   ArrayInitialize(gC,0);
   ArrayInitialize(gImbSnap,0);
   ArrayResize(gParz,0);

   //--- BLOCCHI DI SICUREZZA (scritti nel codice, non sono input)
   bool tester=(MQLInfoInteger(MQL_TESTER)!=0);
   if(!tester)
     {
      long modo=AccountInfoInteger(ACCOUNT_TRADE_MODE);
      if(modo==ACCOUNT_TRADE_MODE_REAL)
        { Print("[EMA200M] RIFIUTO: conto REALE. Questo e' un EA di BANCO, non una sedia."); return(INIT_FAILED); }
      if(modo!=ACCOUNT_TRADE_MODE_DEMO || !InpConsentiDemo)
        { Print("[EMA200M] RIFIUTO: fuori dal tester serve un conto DEMO e InpConsentiDemo=true."); return(INIT_FAILED); }
     }

   //--- controlli sugli input (fail-closed: input incoerente = non parte)
   if(InpMagicBase<=0)
     { Print("[EMA200M] InpMagicBase non valido."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpMagicBase!=785100)
      LogM("ATTENZIONE: InpMagicBase="+IntegerToString(InpMagicBase)+" diverso da 785100: l'intervallo "
           "base..base+99 NON e' stato verificato libero nel repo.");
   if(InpLotMode==LOTTO_RISCHIO && InpRiskPercent<=0)
     { Print("[EMA200M] InpRiskPercent deve essere > 0 in modo rischio."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpLotOrder1<0 || InpLotOrder2<0)
     { Print("[EMA200M] lotti fissi negativi."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpMaxRiskPctPerSetup<=0 || InpMaxOpenRiskPctTotale<=0)
     { Print("[EMA200M] i due tetti di rischio devono essere > 0."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpSLatr<=0 || InpTP_RR<=0 || InpAtrPeriod<1 || InpEmaPeriod<1 || InpEma14Period<1)
     { Print("[EMA200M] SL/TP/periodi non validi."); return(INIT_PARAMETERS_INCORRECT); }

   //--- TF: codici fissi, duplicati scartati
   string tfTok[]; int ntf=Spezza(InpTFs,tfTok);
   int tfCod[]; int nTfOk=0;
   for(int i=0;i<ntf;i++)
     {
      string u=tfTok[i]; StringToUpper(u);
      int c=CodiceDaNomeTf(u);
      if(c<0){ LogM("TF sconosciuto scartato: '"+tfTok[i]+"' (ammessi M1 M5 M15 M30 H1 H2 H4 H8 D1 W1)."); continue; }
      bool dup=false; for(int j=0;j<nTfOk;j++) if(tfCod[j]==c) dup=true;
      if(dup){ LogM("TF duplicato scartato: "+u); continue; }
      ArrayResize(tfCod,nTfOk+1); tfCod[nTfOk]=c; nTfOk++;
     }
   if(nTfOk==0){ Print("[EMA200M] nessun TF valido in InpTFs."); return(INIT_PARAMETERS_INCORRECT); }

   //--- simboli: indice = posizione del token nella lista (max 10)
   string symTok[]; int nsy=Spezza(InpSymbols,symTok);
   if(nsy>10){ LogM("piu' di 10 simboli: oltre il decimo vengono scartati (il magic ha una cifra sola)."); nsy=10; }
   gNS=0; ArrayResize(gS,0);
   for(int i=0;i<nsy;i++)
     {
      string sy=symTok[i];
      bool dup=false; for(int j=0;j<i;j++) if(symTok[j]==sy) dup=true;
      if(dup){ LogM("simbolo duplicato scartato: "+sy); continue; }
      if(!SymbolSelect(sy,true)){ LogM("simbolo NON selezionabile, scartato: "+sy+" (nome giusto per questo broker?)"); continue; }
      for(int t=0;t<nTfOk;t++)
        {
         ENUM_TIMEFRAMES tf=TfDaCodice(tfCod[t]);
         int h1=iMA(sy,tf,InpEmaPeriod,0,MODE_EMA,PRICE_CLOSE);
         int h2=iMA(sy,tf,InpEma14Period,0,MODE_EMA,PRICE_CLOSE);
         int h3=iATR(sy,tf,InpAtrPeriod);
         if(h1==INVALID_HANDLE||h2==INVALID_HANDLE||h3==INVALID_HANDLE)
           {
            LogM("handle indicatori non creati per "+sy+" "+NomeTfCodice(tfCod[t])+": slot scartato.");
            if(h1!=INVALID_HANDLE) IndicatorRelease(h1);
            if(h2!=INVALID_HANDLE) IndicatorRelease(h2);
            if(h3!=INVALID_HANDLE) IndicatorRelease(h3);
            continue;
           }
         ArrayResize(gS,gNS+1);
         gS[gNS].sym=sy;
         gS[gNS].tf=tf;
         gS[gNS].tfCode=tfCod[t];
         gS[gNS].symIdx=i;
         gS[gNS].magic=InpMagicBase+10*i+tfCod[t];
         gS[gNS].hEma=h1;
         gS[gNS].hEma14=h2;
         gS[gNS].hAtr=h3;
         gS[gNS].lastBarDone=0;
         gS[gNS].lastBarNP=0;
         gS[gNS].day=-1;
         gS[gNS].tradesToday=0;
         gS[gNS].piazzati=0;
         gNS++;
        }
     }
   if(gNS==0){ Print("[EMA200M] nessuno slot simbolo-TF valido."); return(INIT_FAILED); }

   gTrade.SetDeviationInPoints(30);
   if(InpUseNewsFilter) LoadNews();
   CsvApri();
   if(InpTimerSec>0) EventSetTimer(InpTimerSec);

   //--- MAPPA DEI MAGIC, stampata sempre (non dipende da InpVerbose)
   Print("[EMA200M] BANCO -- non e' una sedia, non ha taglia approvata. Slot: "+IntegerToString(gNS)+
         " | modo lotto "+(InpLotMode==LOTTO_RISCHIO?"RISCHIO "+DoubleToString(InpRiskPercent,2)+"%":"FISSO")+
         " | tetto setup "+DoubleToString(InpMaxRiskPctPerSetup,2)+"% | tetto totale "+DoubleToString(InpMaxOpenRiskPctTotale,2)+"%");
   for(int s=0;s<gNS;s++)
      Print("[EMA200M] MAGIC "+IntegerToString(gS[s].magic)+" = "+gS[s].sym+" "+NomeTfCodice(gS[s].tfCode));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   ImbutoStampa("parziale del "+TimeToString(gImbData,TIME_DATE));
   for(int s=0;s<gNS;s++)
     {
      Print("[EMA200M] fine corsa: "+gS[s].sym+" "+NomeTfCodice(gS[s].tfCode)+" magic "+IntegerToString(gS[s].magic)+
            " ordini piazzati "+IntegerToString(gS[s].piazzati));
      if(gS[s].hEma!=INVALID_HANDLE)   IndicatorRelease(gS[s].hEma);
      if(gS[s].hEma14!=INVALID_HANDLE) IndicatorRelease(gS[s].hEma14);
      if(gS[s].hAtr!=INVALID_HANDLE)   IndicatorRelease(gS[s].hAtr);
     }
   EventKillTimer();
   if(gCsv!=INVALID_HANDLE){ FileClose(gCsv); gCsv=INVALID_HANDLE; }
  }

void OnTick()  { Processa(); }
void OnTimer() { Processa(); }

//+------------------------------------------------------------------+
//| Routine unica (OnTick del grafico + timer): l'ordine e' quello   |
//| dell'EA vivo -- venerdi', gestione, cutoff, poi barra nuova.     |
//+------------------------------------------------------------------+
void Processa()
  {
   ImbutoGiro();
   ParzPulisci();
   for(int i=0;i<gNS;i++)
     {
      if(FridayCloseCheck(i)) continue;
      ManageSlot(i);
      ScadenzaManuale(i);
      CutoffCheck(i);
      NuovaBarra(i);
     }
  }

//--- dati pronti per questo simbolo-TF? (multi-simbolo nel tester:
//    gli altri simboli si sincronizzano solo dopo il primo tick)
bool SlotPronto(const int i)
  {
   if(SeriesInfoInteger(gS[i].sym,gS[i].tf,SERIES_SYNCHRONIZED)==0) return(false);
   if(BarsCalculated(gS[i].hEma)   < InpEmaPeriod+2)   return(false);
   if(BarsCalculated(gS[i].hEma14) < InpEma14Period+2) return(false);
   if(BarsCalculated(gS[i].hAtr)   < InpAtrPeriod+2)   return(false);
   return(true);
  }

void NuovaBarra(const int i)
  {
   datetime t=iTime(gS[i].sym,gS[i].tf,0);
   if(t==0) return;                         // serie non ancora disponibile
   if(t==gS[i].lastBarDone) return;
   if(!SlotPronto(i))
     {
      if(t!=gS[i].lastBarNP){ gS[i].lastBarNP=t; gC[IMB_NONPRONTO]++; }
      return;                               // si riprova al prossimo giro sulla stessa barra
     }
   gS[i].lastBarDone=t;
   MqlDateTime now; TimeToStruct(t,now);
   if(now.day_of_year!=gS[i].day){ gS[i].day=now.day_of_year; gS[i].tradesToday=0; }
   OnNewBarSlot(i);
  }

//+------------------------------------------------------------------+
double EmaVal(const int handle){ double e[1]; if(CopyBuffer(handle,0,1,1,e)!=1) return(0); return(e[0]); }

double AdrValue(const string sym)
  {
   int n=InpAdrDays; if(n<1) n=1;
   double h[],l[];
   if(CopyHigh(sym,PERIOD_D1,1,n,h)<n) return(0);
   if(CopyLow(sym,PERIOD_D1,1,n,l)<n) return(0);
   double s=0; for(int k=0;k<n;k++) s+=(h[k]-l[k]);
   return(s/n);
  }

//--- un rifiuto di stadio 1: contatore + riga CSV (livello 2)
void Scarta(const int i,const int causa)
  {
   gC[causa]++;
   if(InpCsvLivello>=2)
      CsvRiga(i,"CANDIDATA_SCARTATA",NomeImb(causa),"","",-1,-1,-1,-1,-1,-1,-1,-1,-1,"");
  }

void OnNewBarSlot(const int i)
  {
   string sym=gS[i].sym; ENUM_TIMEFRAMES tf=gS[i].tf;
   gC[IMB_VALUTATE]++;
   if(HasPosition(i) || HasPending(i)){ Scarta(i,IMB_OCCUPATA); return; }
   if(InpNoOverlapTF && AltroTfOccupato(i)){ Scarta(i,IMB_OVERLAP); return; }
   if(InpMaxTradesPerDay>0 && gS[i].tradesToday>=InpMaxTradesPerDay){ Scarta(i,IMB_MAXDAY); return; }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())){ Scarta(i,IMB_NEWS); return; }
   if(!SpreadOK(sym)){ Scarta(i,IMB_SPREAD); return; }

   double ema=EmaVal(gS[i].hEma), atr=EmaVal(gS[i].hAtr);   // shift 1, come l'EA vivo
   double close1=iClose(sym,tf,1);
   if(ema<=0 || atr<=0 || close1<=0){ Scarta(i,IMB_IND); return; }
   double dist=MathAbs(close1-ema);
   if(dist < InpMinDistAtr*atr || dist > InpMaxDistAtr*atr){ Scarta(i,IMB_FASCIA); return; }
   if(InpUseAdrFilter)
     {
      double adr=AdrValue(sym);
      if(adr>0 && (dist < InpAdrDistMin*adr || dist > InpAdrDistMax*adr)){ Scarta(i,IMB_ADR); return; }
     }
   bool up=(close1>ema);
   if(up && !InpAllowLong){ Scarta(i,IMB_LATO); return; }
   if(!up && !InpAllowShort){ Scarta(i,IMB_LATO); return; }
   if(InpUseEma14Bias)
     {
      double e14=EmaVal(gS[i].hEma14);
      if(e14>0 && ((up && e14<ema)||(!up && e14>ema))){ Scarta(i,IMB_EMA14); return; }
     }
   gC[IMB_ARMATE]++;
   PiazzaSetup(i,up,ema,atr);
  }

//+------------------------------------------------------------------+
//| UNA GAMBA (un ordine limite) gia' calcolata                      |
//+------------------------------------------------------------------+
struct Gamba
  {
   bool   ok;
   string tag;
   double px;
   double sl;
   double tp;
   double lot;
   double rischio;   // in valuta del conto, ingresso->SL al lotto scelto
   string nota;      // causa del rifiuto oppure nota (arrotondato / alzato al minimo)
  };

//+------------------------------------------------------------------+
//| Due ordini LIMITE vicino alla EMA200 (stessa geometria del vivo) |
//+------------------------------------------------------------------+
void PiazzaSetup(const int i,const bool isLong,const double ema,const double atr)
  {
   string sym=gS[i].sym;
   double o1 = isLong ? NormalizePrice(sym,ema+InpOrder1Atr*atr) : NormalizePrice(sym,ema-InpOrder1Atr*atr);
   double o2 = isLong ? NormalizePrice(sym,ema-InpOrder2Atr*atr) : NormalizePrice(sym,ema+InpOrder2Atr*atr);
   double sl = isLong ? NormalizePrice(sym,o2-InpSLatr*atr)      : NormalizePrice(sym,o2+InpSLatr*atr);
   string lato=(isLong?"LONG":"SHORT");

   int nOrd=(InpUseOrder2?2:1);
   Gamba g[2];
   int nOk=0; double rischioSetup=0;
   for(int k=0;k<nOrd;k++)
     {
      ValutaGamba(i,isLong,(k==0?o1:o2),sl,k,nOrd,g[k]);
      if(g[k].ok){ nOk++; rischioSetup+=g[k].rischio; }
      else CsvRiga(i,"GAMBA_RIFIUTATA",g[k].nota,lato,g[k].tag,g[k].px,g[k].lot,g[k].sl,g[k].tp,-1,-1,-1,-1,-1,"");
     }

   //--- stadio 3: il SETUP, sulle sole gambe OK
   if(nOk==0){ gC[IMB_S_NESSUNA]++; LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+": setup senza gambe valide."); return; }

   double bal=AccountInfoDouble(ACCOUNT_BALANCE), eq=AccountInfoDouble(ACCOUNT_EQUITY);
   double base=MathMin(bal,eq);
   if(base<=0){ gC[IMB_S_CONTO_NC]++; SetupRifiutato(i,g,nOrd,lato,"SALDO_EQUITY_NON_VALIDI",-1,-1,-1); return; }

   double setupPct=rischioSetup/base*100.0;
   if(setupPct>InpMaxRiskPctPerSetup+1e-9)
     {
      gC[IMB_S_TETTO_SET]++;
      SetupRifiutato(i,g,nOrd,lato,"TETTO_SETUP",setupPct,-1,-1);
      LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+": RIFIUTATO, rischio setup "+DoubleToString(setupPct,3)+
           "% oltre il tetto "+DoubleToString(InpMaxRiskPctPerSetup,3)+"%.");
      return;
     }

   double aperto=0; string notaAp="";
   if(!RischioApertoEA(aperto,notaAp))
     {
      gC[IMB_S_APERTO_NC]++;
      SetupRifiutato(i,g,nOrd,lato,"RISCHIO_APERTO_NON_MISURABILE",setupPct,-1,-1);
      LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+": RIFIUTATO, rischio aperto non misurabile ("+notaAp+").");
      return;
     }
   double primaPct=aperto/base*100.0;
   double dopoPct=(aperto+rischioSetup)/base*100.0;   // SOMMA l'ingresso nuovo PRIMA di inviare
   if(dopoPct>InpMaxOpenRiskPctTotale+1e-9)
     {
      gC[IMB_S_TETTO_TOT]++;
      SetupRifiutato(i,g,nOrd,lato,"TETTO_RISCHIO_APERTO_TOTALE",setupPct,primaPct,dopoPct);
      LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+": RIFIUTATO, rischio aperto "+DoubleToString(primaPct,3)+
           "% + setup "+DoubleToString(setupPct,3)+"% = "+DoubleToString(dopoPct,3)+"% oltre il tetto "+
           DoubleToString(InpMaxOpenRiskPctTotale,3)+"%.");
      return;
     }
   gC[IMB_S_OK]++;

   //--- stadio 4: invio delle gambe OK
   for(int k=0;k<nOrd;k++)
     {
      if(!g[k].ok) continue;
      InviaGamba(i,isLong,g[k],base,setupPct,primaPct,dopoPct);
     }
  }

void SetupRifiutato(const int i,Gamba &g[],const int nOrd,const string lato,const string causa,
                    const double setupPct,const double primaPct,const double dopoPct)
  {
   double base=MathMin(AccountInfoDouble(ACCOUNT_BALANCE),AccountInfoDouble(ACCOUNT_EQUITY));
   for(int k=0;k<nOrd;k++)
     {
      if(!g[k].ok) continue;
      double rp=(base>0 ? g[k].rischio/base*100.0 : -1);
      CsvRiga(i,"SETUP_RIFIUTATO",causa,lato,g[k].tag,g[k].px,g[k].lot,g[k].sl,g[k].tp,g[k].rischio,rp,
              setupPct,primaPct,dopoPct,g[k].nota);
     }
  }

//+------------------------------------------------------------------+
//| Stadio 2: geometria, prezzo, lotto, rischio di UNA gamba         |
//+------------------------------------------------------------------+
void ValutaGamba(const int i,const bool isLong,const double px,const double sl,
                 const int k,const int nOrd,Gamba &g)
  {
   string sym=gS[i].sym;
   g.ok=false; g.tag=(k==0?"1":"2"); g.px=px; g.sl=sl; g.tp=0; g.lot=0; g.rischio=0; g.nota="";
   gC[IMB_G_TENTATE]++;

   double risk=isLong?(px-sl):(sl-px);
   if(risk<=0){ gC[IMB_G_SL]++; g.nota="SL_NON_VALIDO"; return; }
   if(InpTP_RR<InpMinRR){ gC[IMB_G_RR]++; g.nota="RR_SOTTO_MINIMO"; return; }
   g.tp = isLong ? NormalizePrice(sym,px+risk*InpTP_RR) : NormalizePrice(sym,px-risk*InpTP_RR);

   string np="";
   if(!PrezzoOk(sym,isLong,px,sl,g.tp,np)){ gC[IMB_G_PREZZO]++; g.nota=np; return; }

   double lot=0; string nl="";
   int esito=CalcolaLotto(i,isLong,px,sl,k,nOrd,lot,nl);
   g.lot=lot;
   if(esito==1){ gC[IMB_G_LOTTO]++;      g.nota=nl; return; }
   if(esito==2){ gC[IMB_G_RISCHIO_NC]++; g.nota=nl; return; }

   double rv=RischioValuta(sym,isLong,lot,px,sl);
   if(rv<=0){ gC[IMB_G_RISCHIO_NC]++; g.nota="RISCHIO_NON_CALCOLABILE"; return; }
   g.rischio=rv; g.nota=nl; g.ok=true;
   gC[IMB_G_OK]++;
  }

//--- 0 = ok, 1 = lotto non ammesso, 2 = rischio per lotto non calcolabile
int CalcolaLotto(const int i,const bool isLong,const double px,const double sl,
                 const int k,const int nOrd,double &lot,string &nota)
  {
   string sym=gS[i].sym;
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(sym,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   if(mn<=0) mn=st;
   lot=0; nota="";

   if(InpLotMode==LOTTO_FISSO)
     {
      double voluto=(k==0?InpLotOrder1:InpLotOrder2);
      if(voluto<=0){ lot=FloorStep(sym,mn); nota="FISSO_AL_MINIMO"; return(0); }
      lot=FloorStep(sym,voluto);
      if(lot<mn-1e-12){ nota="LOTTO_FISSO_SOTTO_IL_MINIMO ("+DoubleToString(voluto,4)+" < "+DoubleToString(mn,4)+")"; return(1); }
      if(lot>mx+1e-12){ nota="LOTTO_FISSO_SOPRA_IL_MASSIMO ("+DoubleToString(voluto,4)+" > "+DoubleToString(mx,4)+")"; return(1); }
      if(MathAbs(lot-voluto)>1e-9) nota="FISSO_ARROTONDATO_AL_PASSO ("+DoubleToString(voluto,4)+" -> "+DoubleToString(lot,4)+")";
      else                         nota="FISSO";
      return(0);
     }

   //--- LOTTO_RISCHIO: come l'EA vivo, rischio % del SALDO diviso tra gli ordini.
   //    [SCOSTAMENTO] la perdita per lotto si misura con OrderCalcProfit
   //    al prezzo d'INGRESSO vero e nella DIREZIONE vera (il vivo usa l'ask
   //    e sempre BUY): stessa unita', differenza solo di conversione.
   double perLot=RischioValuta(sym,isLong,1.0,px,sl);
   if(perLot<=0){ nota="RISCHIO_PER_LOTTO_NON_CALCOLABILE"; return(2); }
   double riskMoney=AccountInfoDouble(ACCOUNT_BALANCE)*(InpRiskPercent/nOrd)/100.0;
   lot=FloorStep(sym,riskMoney/perLot);
   nota="RISCHIO";
   if(lot<mn){ lot=FloorStep(sym,mn); nota="RISCHIO_ALZATO_AL_MINIMO"; }   // come il vivo (MathMax(mn,...)): il tetto per setup decide
   if(lot>mx){ lot=FloorStep(sym,mx); nota="RISCHIO_TAGLIATO_AL_MASSIMO"; }
   if(lot<=0){ nota="LOTTO_NULLO"; return(1); }
   return(0);
  }

//--- controlli di prezzo che il broker farebbe comunque: qui diventano
//    una CAUSA leggibile invece di un "invio fallito" generico.
bool PrezzoOk(const string sym,const bool isLong,const double px,const double sl,const double tp,string &causa)
  {
   double ask=SymbolInfoDouble(sym,SYMBOL_ASK), bid=SymbolInfoDouble(sym,SYMBOL_BID);
   if(ask<=0 || bid<=0){ causa="PREZZO_NON_DISPONIBILE"; return(false); }
   double pt=SymbolInfoDouble(sym,SYMBOL_POINT);
   double minD=(double)SymbolInfoInteger(sym,SYMBOL_TRADE_STOPS_LEVEL)*pt;
   if(isLong)
     {
      if(px>=ask-minD){ causa="LIMITE_NON_SOTTO_ASK"; return(false); }
      if(px-sl<minD)  { causa="SL_DENTRO_STOPS_LEVEL"; return(false); }
      if(tp-px<minD)  { causa="TP_DENTRO_STOPS_LEVEL"; return(false); }
     }
   else
     {
      if(px<=bid+minD){ causa="LIMITE_NON_SOPRA_BID"; return(false); }
      if(sl-px<minD)  { causa="SL_DENTRO_STOPS_LEVEL"; return(false); }
      if(px-tp<minD)  { causa="TP_DENTRO_STOPS_LEVEL"; return(false); }
     }
   return(true);
  }

void InviaGamba(const int i,const bool isLong,Gamba &g,const double base,
                const double setupPct,const double primaPct,const double dopoPct)
  {
   string sym=gS[i].sym;
   string lato=(isLong?"LONG":"SHORT");
   double rp=(base>0 ? g.rischio/base*100.0 : -1);
   gC[IMB_O_TENTATI]++;
   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Chiamata IMMEDIATAMENTE prima dell'invio, come nell'EA vivo.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_EMA200_Multi_BANCO"))
     {
      gC[IMB_O_GUARDIAN]++;
      CsvRiga(i,"INVIO_RIFIUTATO","GUARDIAN",lato,g.tag,g.px,g.lot,g.sl,g.tp,g.rischio,rp,setupPct,primaPct,dopoPct,g.nota);
      return;
     }
   gTrade.SetExpertMagicNumber(gS[i].magic);
   gTrade.SetTypeFillingBySymbol(sym);

   //--- scadenza: ORDER_TIME_SPECIFIED se il simbolo la ammette (come il
   //    vivo); altrimenti GTC + cancellazione a mano in ScadenzaManuale().
   //    [SCOSTAMENTO] InpPendingExpiryBars<=0 = nessuna scadenza (il vivo
   //    manderebbe una scadenza = adesso, che il broker rifiuta).
   ENUM_ORDER_TYPE_TIME tt=ORDER_TIME_GTC; datetime scad=0;
   long modi=SymbolInfoInteger(sym,SYMBOL_EXPIRATION_MODE);
   if(InpPendingExpiryBars>0 && (modi & SYMBOL_EXPIRATION_SPECIFIED)!=0)
     {
      tt=ORDER_TIME_SPECIFIED;
      scad=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(gS[i].tf);
     }
   string cm=InpComment+" "+sym+" "+NomeTfCodice(gS[i].tfCode)+(isLong?" L":" S")+g.tag;
   bool ok=isLong ? gTrade.BuyLimit(g.lot,g.px,sym,g.sl,g.tp,tt,scad,cm)
                  : gTrade.SellLimit(g.lot,g.px,sym,g.sl,g.tp,tt,scad,cm);
   uint rc=gTrade.ResultRetcode();
   if(ok && (rc==TRADE_RETCODE_DONE || rc==TRADE_RETCODE_PLACED))
     {
      gC[IMB_O_PIAZZATI]++; gS[i].tradesToday++; gS[i].piazzati++;
      CsvRiga(i,"PIAZZATO","OK",lato,g.tag,g.px,g.lot,g.sl,g.tp,g.rischio,rp,setupPct,primaPct,dopoPct,
              g.nota+" ticket "+IntegerToString((long)gTrade.ResultOrder()));
      LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+" "+(isLong?"BUY":"SELL")+" LIMIT "+g.tag+" @ "+
           DoubleToString(g.px,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS))+" SL "+
           DoubleToString(g.sl,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS))+" TP "+
           DoubleToString(g.tp,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS))+" lot "+DoubleToString(g.lot,VolDigits(sym))+
           " rischio "+DoubleToString(rp,3)+"% (aperto dopo "+DoubleToString(dopoPct,3)+"%) magic "+IntegerToString(gS[i].magic));
     }
   else
     {
      gC[IMB_O_INVIO]++;
      CsvRiga(i,"INVIO_FALLITO","RETCODE_"+IntegerToString((long)rc),lato,g.tag,g.px,g.lot,g.sl,g.tp,g.rischio,rp,
              setupPct,primaPct,dopoPct,gTrade.ResultRetcodeDescription());
      LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+" ordine "+g.tag+" fallito: "+IntegerToString((long)rc)+" "+gTrade.ResultRetcodeDescription());
     }
  }

//+------------------------------------------------------------------+
//| Gestione posizioni: parziale EMA14 + pari; trailing su EMA14     |
//| (come l'EA vivo, per simbolo-TF)                                 |
//+------------------------------------------------------------------+
void ManageSlot(const int i)
  {
   string sym=gS[i].sym;
   double bid=SymbolInfoDouble(sym,SYMBOL_BID), ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   double e14=EmaVal(gS[i].hEma14); double atr=EmaVal(gS[i].hAtr);

   for(int p=PositionsTotal()-1;p>=0;p--)
     {
      ulong tk=PositionGetTicket(p);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=sym || PositionGetInteger(POSITION_MAGIC)!=gS[i].magic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      double vol=PositionGetDouble(POSITION_VOLUME);
      bool beDone = isLong ? (sl>=openP) : (sl<=openP && sl>0);

      if(!beDone && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt;
         if(InpTP1_ATRmult>0 && atr>0) tgt=isLong?openP+atr*InpTP1_ATRmult:openP-atr*InpTP1_ATRmult;
         else if(e14>0)                tgt=e14;
         else                          tgt=0;
         if(tgt>0)
           {
            bool hit=isLong?(bid>=tgt):(ask<=tgt);
            if(hit)
              {
               //--- [SCOSTAMENTO] il parziale si fa UNA volta per ticket.
               //    Nel vivo, se lo stop in pari fallisce (o InpBreakeven=false)
               //    beDone resta falso e il parziale si ripete a ogni tick
               //    sul residuo. Qui no. A esecuzione riuscita il comportamento
               //    e' identico al vivo.
               bool gia=ParzFatto(tk);
               bool parz=false;
               if(!gia)
                 {
                  double cv=NormVol(sym,vol*InpTP1Pct/100.0);
                  if(cv>0 && cv<vol)
                    {
                     gTrade.SetExpertMagicNumber(gS[i].magic);
                     gTrade.SetTypeFillingBySymbol(sym);
                     parz=gTrade.PositionClosePartial(tk,cv);
                     if(parz) ParzSegna(tk);      // fallito = si riprova al prossimo giro, come il vivo
                    }
                  else ParzSegna(tk);             // impossibile al lotto minimo: non si riprova
                 }
               // Lo STOP IN PARI non dipende dalla riuscita del parziale (fix del vivo, 04/08/2026)
               if(InpBreakeven)
                 {
                  if(!gTrade.PositionModify(tk,NormalizePrice(sym,openP),tp)) LogModFallita(sym,"stop in pari");
                 }
               if(!gia) LogM(sym+" "+NomeTfCodice(gS[i].tfCode)+(parz ? ": 1o target, parziale + stop in pari."
                                                                    : ": 1o target, stop in pari (parziale non eseguito)."));
              }
           }
        }

      if(InpUseTrailing && beDone && e14>0)
        {
         if(!PositionSelectByTicket(tk)) continue;   // dati freschi dopo eventuali modifiche
         double n=NormalizePrice(sym,e14);
         double slNow=PositionGetDouble(POSITION_SL);
         double tpNow=PositionGetDouble(POSITION_TP);
         if(isLong && n>slNow && n<bid)
           { if(!gTrade.PositionModify(tk,n,tpNow)) LogModFallita(sym,"trailing"); }
         if(!isLong && (n<slNow||slNow==0) && n>ask)
           { if(!gTrade.PositionModify(tk,n,tpNow)) LogModFallita(sym,"trailing"); }
        }
     }
  }

void LogModFallita(const string sym,const string cosa)
  {
   if(TimeCurrent()-gUltimoLogMod<60) return;
   gUltimoLogMod=TimeCurrent();
   LogM(sym+": modifica "+cosa+" fallita: "+IntegerToString((long)gTrade.ResultRetcode())+" "+gTrade.ResultRetcodeDescription());
  }

//--- registro dei parziali gia' fatti (per ticket di posizione)
bool ParzFatto(const ulong tk){ for(int k=0;k<ArraySize(gParz);k++) if(gParz[k]==tk) return(true); return(false); }
void ParzSegna(const ulong tk){ if(ParzFatto(tk)) return; int n=ArraySize(gParz); ArrayResize(gParz,n+1); gParz[n]=tk; }
void ParzPulisci()
  {
   int n=ArraySize(gParz); if(n==0) return;
   ulong tieni[]; int m=0;
   for(int k=0;k<n;k++)
     {
      if(!PositionSelectByTicket(gParz[k])) continue;   // posizione chiusa: via dal registro
      ArrayResize(tieni,m+1); tieni[m]=gParz[k]; m++;
     }
   ArrayResize(gParz,m);
   for(int k=0;k<m;k++) gParz[k]=tieni[k];
  }

//+------------------------------------------------------------------+
void CutoffCheck(const int i)
  {
   if(!InpUseCutoff) return;
   if(HasPosition(i)) return;                 // se e' entrato, si gestisce
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.hour*60+now.min < InpCutoffHour*60+InpCutoffMin) return;
   if(HasPending(i)){ CancelPendings(i); LogM(gS[i].sym+" "+NomeTfCodice(gS[i].tfCode)+": cutoff, pendenti cancellati."); }
  }

//--- scadenza a mano SOLO per i pendenti piazzati GTC (simbolo che non
//    ammette ORDER_TIME_SPECIFIED). Quelli con scadenza li toglie il server.
void ScadenzaManuale(const int i)
  {
   if(InpPendingExpiryBars<=0) return;
   int durata=InpPendingExpiryBars*PeriodSeconds(gS[i].tf);
   for(int o=OrdersTotal()-1;o>=0;o--)
     {
      ulong t=OrderGetTicket(o);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=gS[i].sym || OrderGetInteger(ORDER_MAGIC)!=gS[i].magic) continue;
      if(OrderGetInteger(ORDER_TYPE_TIME)!=ORDER_TIME_GTC) continue;
      datetime setup=(datetime)OrderGetInteger(ORDER_TIME_SETUP);
      if(TimeCurrent()>=setup+durata)
        {
         if(gTrade.OrderDelete(t)) LogM(gS[i].sym+" "+NomeTfCodice(gS[i].tfCode)+": pendente GTC scaduto a mano.");
        }
     }
  }

bool FridayCloseCheck(const int i)
  {
   if(!InpFridayClose) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(t.day_of_week!=5 || t.hour<InpFridayCloseHour) return(false);
   for(int o=OrdersTotal()-1;o>=0;o--)
     {
      ulong ot=OrderGetTicket(o);
      if(ot>0 && OrderGetString(ORDER_SYMBOL)==gS[i].sym && OrderGetInteger(ORDER_MAGIC)==gS[i].magic) gTrade.OrderDelete(ot);
     }
   for(int p=PositionsTotal()-1;p>=0;p--)
     {
      ulong pt=PositionGetTicket(p);
      if(pt>0 && PositionGetString(POSITION_SYMBOL)==gS[i].sym && PositionGetInteger(POSITION_MAGIC)==gS[i].magic)
        { gTrade.SetTypeFillingBySymbol(gS[i].sym); gTrade.PositionClose(pt); }
     }
   return(true);
  }

//==================================================================
//  RISCHIO IN VALUTA DEL CONTO
//==================================================================
//--- perdita (>=0) se il prezzo va da entry a sl con 'vol' lotti.
//    0 = SL in pari o oltre (nessuna perdita). -1 = non calcolabile.
double RischioValuta(const string sym,const bool isLong,const double vol,const double entry,const double sl)
  {
   if(vol<=0) return(-1);
   double dist=isLong?(entry-sl):(sl-entry);
   if(dist<=0) return(0);
   double prof=0;
   if(OrderCalcProfit(isLong?ORDER_TYPE_BUY:ORDER_TYPE_SELL,sym,vol,entry,sl,prof) && prof<0)
      return(-prof);
   //--- ripiego (come il vivo): valore del tick dichiarato dal simbolo
   double tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tv<=0) tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   double tsz=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   if(tv<=0 || tsz<=0) return(-1);
   return(dist/tsz*tv*vol);
  }

//--- rischio aperto di TUTTO questo EA (magic base..base+99): posizioni
//    allo SL CORRENTE (in pari = 0) + pendenti al loro SL. false = non
//    misurabile (una posizione/pendente senza SL, o valore non calcolabile):
//    in quel caso il chiamante NON apre (fail-closed).
bool RischioApertoEA(double &tot,string &nota)
  {
   tot=0; nota="";
   for(int p=PositionsTotal()-1;p>=0;p--)
     {
      ulong tk=PositionGetTicket(p);
      if(tk==0) continue;
      if(!MagicMio(PositionGetInteger(POSITION_MAGIC))) continue;
      string s=PositionGetString(POSITION_SYMBOL);
      bool L=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double v=PositionGetDouble(POSITION_VOLUME), op=PositionGetDouble(POSITION_PRICE_OPEN), sl=PositionGetDouble(POSITION_SL);
      if(sl<=0){ nota="posizione "+IntegerToString((long)tk)+" senza SL"; return(false); }
      double r=RischioValuta(s,L,v,op,sl);
      if(r<0){ nota="posizione "+IntegerToString((long)tk)+" rischio non calcolabile"; return(false); }
      tot+=r;
     }
   for(int o=OrdersTotal()-1;o>=0;o--)
     {
      ulong ot=OrderGetTicket(o);
      if(ot==0) continue;
      if(!MagicMio(OrderGetInteger(ORDER_MAGIC))) continue;
      string s=OrderGetString(ORDER_SYMBOL);
      ENUM_ORDER_TYPE ty=(ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
      bool L=(ty==ORDER_TYPE_BUY_LIMIT || ty==ORDER_TYPE_BUY_STOP || ty==ORDER_TYPE_BUY_STOP_LIMIT || ty==ORDER_TYPE_BUY);
      double v=OrderGetDouble(ORDER_VOLUME_CURRENT), op=OrderGetDouble(ORDER_PRICE_OPEN), sl=OrderGetDouble(ORDER_SL);
      if(sl<=0){ nota="pendente "+IntegerToString((long)ot)+" senza SL"; return(false); }
      double r=RischioValuta(s,L,v,op,sl);
      if(r<0){ nota="pendente "+IntegerToString((long)ot)+" rischio non calcolabile"; return(false); }
      tot+=r;
     }
   return(true);
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(const string sym,const double price)
  {
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

int VolDigitsDaPasso(const double step)
  {
   int d=0; double s=step;
   while(d<8 && MathAbs(s-MathRound(s))>1e-9){ s*=10.0; d++; }
   return(d);
  }

int VolDigits(const string sym)
  {
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   return(VolDigitsDaPasso(st));
  }

//--- arrotondamento PER DIFETTO al passo, con la tolleranza che serve:
//    0.29/0.01 in virgola mobile fa 28.999999999999996 e senza epsilon
//    MathFloor darebbe 0.28 (un lotto fisso scelto da Claudio cambiato
//    in silenzio).
double FloorStep(const string sym,const double v)
  {
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   if(v<=0) return(0);
   double n=MathFloor(v/st+1e-7);
   return(NormalizeDouble(n*st,VolDigitsDaPasso(st)));
  }

//--- volume del parziale (come il vivo): per difetto al passo, 0 se sotto il minimo
double NormVol(const string sym,const double v)
  {
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   double r=FloorStep(sym,v);
   return(r<mn?0:r);
  }

bool SpreadOK(const string sym){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(sym,SYMBOL_SPREAD)<=InpMaxSpread); }

bool HasPosition(const int i)
  {
   for(int p=PositionsTotal()-1;p>=0;p--)
     {
      ulong tk=PositionGetTicket(p);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==gS[i].sym && PositionGetInteger(POSITION_MAGIC)==gS[i].magic) return(true);
     }
   return(false);
  }

bool HasPending(const int i)
  {
   for(int o=OrdersTotal()-1;o>=0;o--)
     {
      ulong t=OrderGetTicket(o);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==gS[i].sym && OrderGetInteger(ORDER_MAGIC)==gS[i].magic) return(true);
     }
   return(false);
  }

//--- un ALTRO TF dello stesso simbolo ha posizione o pendenti?
bool AltroTfOccupato(const int i)
  {
   for(int j=0;j<gNS;j++)
     {
      if(j==i || gS[j].sym!=gS[i].sym) continue;
      if(HasPosition(j) || HasPending(j)) return(true);
     }
   return(false);
  }

void CancelPendings(const int i)
  {
   for(int o=OrdersTotal()-1;o>=0;o--)
     {
      ulong t=OrderGetTicket(o);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=gS[i].sym || OrderGetInteger(ORDER_MAGIC)!=gS[i].magic) continue;
      gTrade.OrderDelete(t);
     }
  }

//==================================================================
//  CSV DEGLI ORDINI E DEI RIFIUTI (Common\Files)
//  abtg_ordini_<EA>_<magicBase>.csv -- una riga per: candidata scartata
//  (livello 2), gamba rifiutata, setup rifiutato, invio rifiutato/fallito,
//  ordine piazzato. Nel tester il file si RISCRIVE a ogni corsa; fuori
//  dal tester si accoda. Spento in ottimizzazione (agenti paralleli sullo
//  stesso file = righe mescolate).
//==================================================================
void CsvApri()
  {
   gCsv=INVALID_HANDLE;
   if(!InpLogCsvOrdini) return;
   if(MQLInfoInteger(MQL_OPTIMIZATION)!=0) return;
   bool tester=(MQLInfoInteger(MQL_TESTER)!=0);
   string fn="abtg_ordini_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+IntegerToString(InpMagicBase)+".csv";
   int fl=FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON|FILE_SHARE_READ;
   if(!tester) fl|=FILE_READ;
   gCsv=FileOpen(fn,fl,';');
   if(gCsv==INVALID_HANDLE){ Print("[EMA200M] CSV ordini non apribile: "+fn+" err "+IntegerToString(GetLastError())); return; }
   if(!tester) FileSeek(gCsv,0,SEEK_END);
   if(FileSize(gCsv)==0)
      FileWrite(gCsv,"ora_server","barra","evento","causa","simbolo","tf","magic","lato","gamba",
                "prezzo","lotti","sl","tp","rischio_valuta","rischio_pct","rischio_setup_pct",
                "rischio_aperto_prima_pct","rischio_aperto_dopo_pct","nota");
   LogM("CSV ordini: Common\\Files\\"+fn);
  }

string NumONd(const double v,const int dg){ return(v<0 ? "" : DoubleToString(v,dg)); }

void CsvRiga(const int i,const string evento,const string causa,const string lato,const string gamba,
             const double px,const double lot,const double sl,const double tp,
             const double rischioVal,const double rischioPct,const double setupPct,
             const double primaPct,const double dopoPct,const string nota)
  {
   if(gCsv==INVALID_HANDLE) return;
   int dg=(int)SymbolInfoInteger(gS[i].sym,SYMBOL_DIGITS);
   string nt=nota; StringReplace(nt,";",",");   // il separatore non deve finire dentro un campo
   FileWrite(gCsv,
             TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
             TimeToString(gS[i].lastBarDone,TIME_DATE|TIME_MINUTES),
             evento,causa,gS[i].sym,NomeTfCodice(gS[i].tfCode),IntegerToString(gS[i].magic),lato,gamba,
             NumONd(px,dg),NumONd(lot,VolDigits(gS[i].sym)),NumONd(sl,dg),NumONd(tp,dg),
             NumONd(rischioVal,2),NumONd(rischioPct,4),NumONd(setupPct,4),NumONd(primaPct,4),NumONd(dopoPct,4),
             nt);
   if(evento!="CANDIDATA_SCARTATA") FileFlush(gCsv);
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- identico all'EA vivo
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ LogM("file news non trovato: filtro di fatto spento."); return; }
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
   LogM("news caricate: "+IntegerToString(gNewsCount)+".");
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
   for(int k=0;k<gNewsCount;k++)
     {
      if(gNewsImpact[k]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[k])<0) continue;
      if(now>=gNewsTime[k]-InpNewsBeforeMin*60 && now<=gNewsTime[k]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }

//==================================================================//
//  OPTFRAME (inlined, come nell'EA vivo) + EXPORT PER-TRADE         //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return("OptResults_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+".csv");
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE -- Common\Files\                                 |
//|   abtg_trades_<EA>_<SimboloGrafico>_<magicBase>.csv              |
//| Le prime 8 colonne sono IDENTICHE al formato di casa (una riga    |
//| per deal d'USCITA): i lettori esistenti non cambiano. In CODA     |
//| ci sono le colonne nuove, a cominciare dall'ora d'INGRESSO della  |
//| posizione (classe 933: i per-trade di casa avevano solo l'uscita).|
//| entry_order = ticket dell'ordine d'ingresso: si incrocia con la   |
//| colonna 'nota' del CSV ordini ("ticket N") per avere il rischio   |
//| effettivo calcolato al piazzamento.                               |
//| net_profit: come il formato di casa, NON contiene la commissione  |
//| del deal d'ingresso.                                              |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString(InpMagicBase)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit",
             "open_time","open_price","open_deal_type","tf","entry_order","sl_iniziale","tp_iniziale");
   int n=HistoryDealsTotal();
   //--- passata 1: i deal d'INGRESSO, per posizione
   ulong    inPos[]; datetime inTime[]; double inPrice[]; long inType[]; ulong inOrd[];
   int m=0;
   for(int k=0;k<n;k++)
     {
      ulong tk=HistoryDealGetTicket(k);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      if(!MagicMio(HistoryDealGetInteger(tk,DEAL_MAGIC))) continue;
      ArrayResize(inPos,m+1); ArrayResize(inTime,m+1); ArrayResize(inPrice,m+1); ArrayResize(inType,m+1); ArrayResize(inOrd,m+1);
      inPos[m]  =(ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      inTime[m] =(datetime)HistoryDealGetInteger(tk,DEAL_TIME);
      inPrice[m]=HistoryDealGetDouble(tk,DEAL_PRICE);
      inType[m] =HistoryDealGetInteger(tk,DEAL_TYPE);
      inOrd[m]  =(ulong)HistoryDealGetInteger(tk,DEAL_ORDER);
      m++;
     }
   //--- passata 2: una riga per deal d'USCITA (formato di casa + coda)
   for(int k=0;k<n;k++)
     {
      ulong tk=HistoryDealGetTicket(k);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      long mg=HistoryDealGetInteger(tk,DEAL_MAGIC);
      if(!MagicMio(mg)) continue;
      string ds=HistoryDealGetString(tk,DEAL_SYMBOL);
      int dg=(int)SymbolInfoInteger(ds,SYMBOL_DIGITS);
      ulong pid=(ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      string oT="",oP="",oTy="",oOrd="",oSl="",oTp="";
      for(int j=0;j<m;j++)
        {
         if(inPos[j]!=pid) continue;
         oT  =TimeToString(inTime[j],TIME_DATE|TIME_MINUTES|TIME_SECONDS);
         oP  =DoubleToString(inPrice[j],dg);
         oTy =IntegerToString(inType[j]);
         oOrd=IntegerToString((long)inOrd[j]);
         //  niente HistoryOrderSelect: azzererebbe la lista ordini selezionata
         //  da HistorySelect; l'ordine d'ingresso e' gia' dentro quella lista.
         double vSl=0, vTp=0;
         if(HistoryOrderGetDouble(inOrd[j],ORDER_SL,vSl)) oSl=DoubleToString(vSl,dg);
         if(HistoryOrderGetDouble(inOrd[j],ORDER_TP,vTp)) oTp=DoubleToString(vTp,dg);
         break;
        }
      int code=(int)((mg-InpMagicBase)%10);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                ds,
                IntegerToString(mg),
                IntegerToString((long)pid),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),dg),
                DoubleToString(net,2),
                oT,oP,oTy,NomeTfCodice(code),oOrd,oSl,oTp);
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];              // Recovery Factor, come il vivo
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { Print("OptFrame: impossibile creare "+fname+" err "+IntegerToString(GetLastError())); return; }
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
         for(uint k = 0; k < pcount; k++)
           { string kv[]; if(StringSplit(params[k], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = IntegerToString((long)pass)+","+DoubleToString(data[0],2)+","+DoubleToString(data[1],5)+","+
                   DoubleToString(data[2],5)+","+DoubleToString(data[3],5)+","+DoubleToString(data[4],5)+","+
                   DoubleToString(data[5],4)+","+DoubleToString(data[6],0);
      for(uint k = 0; k < pcount; k++)
        { string kv[]; if(StringSplit(params[k], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   Print("OptFrame: scritte "+IntegerToString(righe)+" passate in MQL5\\Files\\"+fname);
  }
//================== fine OPTFRAME inlined ==========================//
