//+------------------------------------------------------------------+
//|                                      ABTG_CanarinoGuardian.mq5    |
//|                                                                   |
//|   IL CANARINO DEL GUARDIAN -- SCRIPT DI SOLA LETTURA.             |
//|                                                                   |
//|   SCOPO (proposta P-C1, rilievo R4 del pacchetto                  |
//|   report/COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md):               |
//|   i criteri 5 (pausa B1), 7 (cap C1) e 8 (fail-open) del collaudo |
//|   enforcement sono OPPORTUNISTICI: la riga di blocco compare solo |
//|   se, mentre la bandiera e' alzata, un EA aveva davvero deciso di |
//|   entrare. Il silenzio nel log e' compatibile sia con             |
//|   "l'enforcement funziona" sia con "l'enforcement e' morto".      |
//|   Questo script rende DETERMINISTICA la parte misurabile: legge   |
//|   le bandiere del Guardian a comando e ricalcola il verdetto CON  |
//|   LE STESSE FUNZIONI che usano gli EA (l'include e' lo stesso     |
//|   file), stampando il valore GREZZO accanto al RICALCOLATO.       |
//|                                                                   |
//|   FIRMA: decisione D2 del 02/09/2026 -- report/FIRME_2026-09-02.md|
//|   ("D2 -- CANARINO: SI'. Si costruisce lo Script di sola lettura  |
//|   P-C1 [...] per rendere deterministici i criteri 5/7/8. Va a     |
//|   collaudo come ogni artefatto nuovo").                           |
//|   Verbale delle firme: commit a9bd2df sul branch 'lavoro'.        |
//|                                                                   |
//|   IL VINCOLO -- NON NEGOZIABILE, e' la ragione per cui questo     |
//|   artefatto puo' girare sul 100k senza rischio:                   |
//|    1. MAI UN ORDINE. Nessun #include <Trade\Trade.mqh>, nessun    |
//|       CTrade, nessun OrderSend/OrderSendAsync/OrderModify/        |
//|       PositionClose. Non e' una promessa: e' che quelle chiamate  |
//|       QUI NON CI SONO. Se un giorno qualcuno le aggiunge, ha      |
//|       cambiato la natura dell'artefatto e la firma D2 non lo      |
//|       copre piu'.                                                 |
//|    2. MAI UNA SCRITTURA DI GlobalVariable. Solo                   |
//|       GlobalVariableCheck / GlobalVariableGet / GlobalVariableTime|
//|       (e ABTG_GVLeggi dell'include, che e' Check+Get e basta).    |
//|       NON si chiamano le funzioni dell'include che SCRIVONO:      |
//|       ABTG_GVScrivi, ABTG_GVCancella, ABTG_ObiettivoTimbra,       |
//|       ABTG_ObiettivoResetta, ne' ABTG_GuardiaIngresso con gli     |
//|       argomenti S1 valorizzati (il latch S1 scrive una GV).       |
//|    3. MAI LE STRINGHE CHE FANNO FEDE PER GLI EA. Il canarino NON  |
//|       stampa il prefisso "[GUARDIA]" e NON stampa la frase di     |
//|       blocco degli EA. Motivo misurato, non estetico:             |
//|       backtest_pipeline/attese_enforcement_fase1.txt cerca quelle |
//|       sottostringhe per i criteri 5, 7 e 9 (righe C5.EA, C7.EA,   |
//|       C9.BLOCCO). Se le stampasse anche il canarino, il censimento|
//|       del criterio 9 conterebbe blocchi che nessun EA ha mai      |
//|       subito -- cioe' il collaudo si racconterebbe una bugia.     |
//|       TUTTE le righe di qui iniziano con "[CANARINO]".            |
//|       E LO STESSO VALE PER IL TOKEN DI FALLIMENTO DEL PROPRIO     |
//|       AUTOTEST (v1.01): l'artefatto ha una riga VIETATA           |
//|       STOP.AUTOTEST che cerca la sottostringa "*** FAIL ***",     |
//|       prodotta da ABTG_AutotestCaso() dell'include (riga 1074).   |
//|       Il prefisso "[CANARINO]" NON protegge, perche' la ricerca   |
//|       e' per SOTTOSTRINGA e non per inizio riga: un blocco rosso  |
//|       del canarino verrebbe letto come "l'autotest dell'include   |
//|       e' rotto, fermare tutto" -- allarme vero ma sull'artefatto  |
//|       SBAGLIATO, proprio mentre la fase 1 vieta di ricompilare.   |
//|       Percio' qui il fallimento si chiama "*** ROSSO CANARINO ***"|
//|       e non collide con nessun testo dell'artefatto.              |
//|       CONSEGUENZA DICHIARATA: e' per questo che il canarino NON   |
//|       chiama ABTG_GuardiaIngresso() come proponeva l'R4, ma       |
//|       ricalcola con le funzioni _Calc che quella stessa funzione  |
//|       usa dentro. Il pensiero misurato e' identico; a cambiare e' |
//|       solo l'etichetta della riga, che resta distinguibile.       |
//|    4. UN SOLO FILE SCRITTO: il referto testuale in MQL5\Files,    |
//|       nome con timestamp, ASCII puro. Ripete esattamente cio' che |
//|       finisce nel Giornale/Esperti, cosi' la raccolta del         |
//|       verificatore non dipende dal copia-incolla di una scheda.   |
//|                                                                   |
//|   COME SI USA: si trascina su UN grafico qualsiasi dell'istanza   |
//|   del terminale da esaminare e si preme OK. Gira UNA VOLTA,       |
//|   stampa, scrive il referto ed esce. Nessun timer, nessuna attesa.|
//|   Per il criterio 8 (fail-open) lo si lancia DUE volte: prima     |
//|   della rimozione del Guardian e oltre 120 s dopo -- i due        |
//|   referti, con i loro timestamp, SONO la prova.                   |
//|                                                                   |
//|   SU VPS / CONTO 100k GIRA SOLO SE LO LANCIA A MANO CLAUDIO.      |
//|   Nessuna automazione lo avvia, non sta su nessun grafico, non ha |
//|   OnTick ne' OnTimer: finita la stampa, il programma e' finito.   |
//|                                                                   |
//|   LIMITE DICHIARATO (lo stesso dell'R4, ripetuto qui perche' un   |
//|   limite scritto solo nel referto e' un limite che si dimentica): |
//|   il canarino prova IL CANALE e L'INCLUDE, non prova che i binari |
//|   dei 5 mirror in campo chiamino davvero la guardia. Quella prova |
//|   resta la riga "[GUARDIA]" di un EA vero, scritta da un EA vero. |
//|   SERVONO ENTRAMBI: questo strumento riduce il "NON MISURATO",    |
//|   non lo abolisce.                                                |
//|                                                                   |
//|   ASCII puro: niente accenti e niente emoji, nemmeno nei commenti.|
//+------------------------------------------------------------------+
//  v1.00 -- 02/09/2026. Prima stesura (P-C1 / D2). NON compilata in
//           sessione: qui non esistono MetaEditor ne' Strategy Tester.
//           La compilazione e la prima corsa le fa Claudio.
//  v1.01 -- 02/09/2026, dalla verifica pre-invio. Due correzioni
//           MECCANICHE, nessun cambio di contratto e nessuna misura
//           diversa:
//           1) il token di fallimento dell'autotest era "*** FAIL ***",
//              che e' ESATTAMENTE la riga VIETATA STOP.AUTOTEST
//              dell'artefatto attese_enforcement_fase1.txt (la produce
//              ABTG_AutotestCaso() dell'include). Rinominato in
//              "*** ROSSO CANARINO ***": il verdetto e' identico, ma
//              non si spaccia piu' per un fallimento dell'include.
//           2) il separatore dei titoli era una riga VUOTA, e smentiva
//              l'invariante dichiarata "tutte le righe iniziano con
//              [CANARINO]". Ora l'invariante e' vera alla lettera e
//              diventa collaudabile: contare le righe del referto che
//              iniziano con [CANARINO] deve dare TUTTE le righe.
#property script_show_inputs
#property strict
#property description "CANARINO DEL GUARDIAN (P-C1, firma D2 del 02/09/2026): SOLA LETTURA."
#property description "Legge le bandiere del Guardian e ricalcola il verdetto con le funzioni dell'include."
#property description "NON manda ordini, NON scrive GlobalVariable. Scrive un solo referto in MQL5\\Files."

//--- l'include degli EA: si legge con LO STESSO CODICE che decide in campo.
//    Non ha #property, non crea handle, non tocca niente da solo.
#include <ABTG_PausaGuardian.mqh>

//====================================================================
//  COSTANTI
//====================================================================
#define CANARINO_VERSIONE           "v1.01"
#define CANARINO_BLOCCHI_ATTESI     8          // autotest: blocchi eseguiti = attesi
#define CANARINO_LOGIN_COLLAUDO     50504263   // il 100k della fase 1

//--- I NOMI CHE FANNO FEDE, COPIATI A MANO DALL'ARTEFATTO
//    backtest_pipeline/attese_enforcement_fase1.txt (righe GV.1 ... GV.6).
//    Sono HARDCODED apposta: se un domani qualcuno rinomina una radice
//    dentro ABTG_PausaGuardian.mqh, il confronto qui sotto FALLISCE e il
//    canarino lo urla. Un rename silenzioso dell'include spegnerebbe il
//    canale senza un solo messaggio d'errore -- e' il difetto X2/X3 della
//    matrice dei rischi, e questo blocco e' la sua spia.
#define ART_GV1 "ABTG_PAUSA_GIORNO_50504263"
#define ART_GV2 "ABTG_PAUSA_FINO_50504263"
#define ART_GV3 "ABTG_CAP_RISCHIO_50504263"
#define ART_GV4 "ABTG_RISCHIO_APERTO_50504263"
#define ART_GV5 "ABTG_GUARDIAN_BATTITO_50504263"
#define ART_GV6 "ABTG_GUARD_50504263_BLOCKDAY"

//--- LE DUE FRASI che l'artefatto cerca nel giornale degli EA
//    (righe C5.EA e C7.EA). Le produce ABTG_MotivoTesto() dell'include:
//    se cambiassero, le righe di raccolta del verificatore troverebbero
//    zero blocchi e il collaudo direbbe "PASS" per assenza di prove.
#define ART_TESTO_B1 "PAUSA GIORNALIERA del Guardian (firma B1)"
#define ART_TESTO_C1 "CAP RISCHIO APERTO raggiunto (firma C1)"

//====================================================================
//  INPUT -- uno solo, e con default neutro.
//====================================================================
input int InpGiornoOffset = 0;   // 0=oggi. -1=ieri: sposta SOLO le finestre di giorno stampate (le GlobalVariable sono stato ISTANTANEO, non hanno storia)

//====================================================================
//  STATO INTERNO (nessuno di questi tocca il terminale)
//====================================================================
int    gFile   = INVALID_HANDLE;   // referto
int    gRighe  = 0;                // righe stampate (Journal e referto)
string gRilievi[];                 // i rilievi, per il riepilogo finale

//--- aggregati per magic: POSIZIONI
long   gPosMagic[];  int gPosNum[];  double gPosVol[];
double gPosRisk0[];  double gPosRisk1[];  int gPosNoSL[];
//--- aggregati per magic: PENDENTI (quelli che il cap NON vede -- buco B6)
long   gOrdMagic[];  int gOrdNum[];  double gOrdVol[];
double gOrdRisk[];   int gOrdNoSL[];

//====================================================================
//  STAMPA -- una riga va SEMPRE in due posti: Giornale e referto.
//====================================================================
void Riga(const string testo)
  {
   Print(testo);
   gRighe++;
   if(gFile!=INVALID_HANDLE) FileWrite(gFile,testo);
  }

void Titolo(const string testo)
  {
   Riga("[CANARINO]");     // separatore: mai una riga VUOTA, altrimenti
                           // l'invariante "ogni riga inizia con [CANARINO]"
                           // non e' piu' vera e non si puo' collaudare.
   Riga("[CANARINO] ==================================================================");
   Riga("[CANARINO] "+testo);
  }

//--- un RILIEVO: si stampa IN MAIUSCOLO e si ripete nel riepilogo finale.
//    Un rilievo che scorre via in mezzo a cento righe non l'ha visto nessuno.
void Rilievo(const string testo)
  {
   string urlo=testo;
   StringToUpper(urlo);
   int n=ArraySize(gRilievi)+1;
   ArrayResize(gRilievi,n);
   gRilievi[n-1]=urlo;
   Riga("[CANARINO] *** RILIEVO *** "+urlo);
  }

string SN(const bool b){ return(b ? "SI" : "NO"); }

//====================================================================
//  NUCLEO PURO DEL CANARINO -- niente terminale, cosi' l'autotest
//  lo puo' interrogare a tavolino.
//====================================================================

//--- percentuale sull'equity, con i casi degeneri dichiarati:
//    equity <= 0 -> 0 (non si divide per zero e non si inventa un numero);
//    perdita <= 0 -> 0 (uno stop gia' in profitto non "finanzia" altro
//    rischio: e' la stessa convenzione di LossIfStopHit del Guardian).
double PctSuEquity_Calc(const double perdita,const double equity)
  {
   if(equity<=0.0)  return(0.0);
   if(perdita<=0.0) return(0.0);
   return(100.0*perdita/equity);
  }

//--- chiave del giorno, copia dichiarata di ABTG_Guardian.mq5 riga 83.
int ChiaveGiorno_Calc(const datetime t)
  {
   MqlDateTime s; TimeToStruct(t,s);
   return(s.year*1000+s.day_of_year);
  }

//--- chiave del giorno PROP, copia dichiarata di PropDayKey() (riga 88):
//    l'orologio si sposta indietro dell'ora di reset.
int ChiaveGiornoProp_Calc(const datetime t,const int ora_reset)
  {
   int h=ora_reset; if(h<0) h=0; if(h>23) h=23;
   return(ChiaveGiorno_Calc((datetime)((long)t-(long)h*3600)));
  }

//====================================================================
//  IL FILO -- lettura del conto. Nessuna scrittura, mai.
//====================================================================

//--- Perdita in valuta se lo SL venisse colpito.
//    COPIA DICHIARATA di LossIfStopHit() (ABTG_Guardian.mq5 righe 120-140):
//    si ripete qui perche' quella funzione sta dentro un EA e uno Script
//    non puo' includerla. Se un giorno cambia li', va cambiata anche qui:
//    e' l'unico pezzo duplicato di questo file, ed e' dichiarato.
double PerditaSeSLColpito(const string sym,const bool lato_buy,const double vol,
                          const double da_prezzo,const double sl)
  {
   if(sl<=0.0 || vol<=0.0 || da_prezzo<=0.0) return(0.0);

   ENUM_ORDER_TYPE ot=(lato_buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   double profitto=0.0;
   if(OrderCalcProfit(ot,sym,vol,da_prezzo,sl,profitto))
      return(profitto<0.0 ? -profitto : 0.0);

   //--- ripiego aritmetico: distanza in tick per valore del tick
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   double tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tv<=0.0) tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   if(ts<=0.0 || tv<=0.0) return(0.0);

   double dist=(lato_buy ? (da_prezzo-sl) : (sl-da_prezzo));
   if(dist<=0.0) return(0.0);
   return(dist/ts*tv*vol);
  }

//--- il lato di un tipo d'ordine (i pendenti hanno 6 tipi, non 2)
bool OrdineLatoBuy(const long tipo)
  {
   return(tipo==ORDER_TYPE_BUY       || tipo==ORDER_TYPE_BUY_LIMIT ||
          tipo==ORDER_TYPE_BUY_STOP  || tipo==ORDER_TYPE_BUY_STOP_LIMIT);
  }

string NomeTipoOrdine(const long tipo)
  {
   if(tipo==ORDER_TYPE_BUY)             return("BUY");
   if(tipo==ORDER_TYPE_SELL)            return("SELL");
   if(tipo==ORDER_TYPE_BUY_LIMIT)       return("BUY LIMIT");
   if(tipo==ORDER_TYPE_SELL_LIMIT)      return("SELL LIMIT");
   if(tipo==ORDER_TYPE_BUY_STOP)        return("BUY STOP");
   if(tipo==ORDER_TYPE_SELL_STOP)       return("SELL STOP");
   if(tipo==ORDER_TYPE_BUY_STOP_LIMIT)  return("BUY STOP LIMIT");
   if(tipo==ORDER_TYPE_SELL_STOP_LIMIT) return("SELL STOP LIMIT");
   return("TIPO ?");
  }

//--- slot per magic (posizioni): trova o crea, tenendo allineati
//    tutti gli array paralleli. I magic di un conto sono un pugno:
//    la ricerca lineare qui costa niente ed e' leggibile.
int SlotPos(const long magic)
  {
   int n=ArraySize(gPosMagic);
   for(int i=0;i<n;i++) if(gPosMagic[i]==magic) return(i);
   ArrayResize(gPosMagic,n+1); ArrayResize(gPosNum,n+1); ArrayResize(gPosVol,n+1);
   ArrayResize(gPosRisk0,n+1); ArrayResize(gPosRisk1,n+1); ArrayResize(gPosNoSL,n+1);
   gPosMagic[n]=magic; gPosNum[n]=0; gPosVol[n]=0.0;
   gPosRisk0[n]=0.0;   gPosRisk1[n]=0.0; gPosNoSL[n]=0;
   return(n);
  }

int SlotOrd(const long magic)
  {
   int n=ArraySize(gOrdMagic);
   for(int i=0;i<n;i++) if(gOrdMagic[i]==magic) return(i);
   ArrayResize(gOrdMagic,n+1); ArrayResize(gOrdNum,n+1); ArrayResize(gOrdVol,n+1);
   ArrayResize(gOrdRisk,n+1);  ArrayResize(gOrdNoSL,n+1);
   gOrdMagic[n]=magic; gOrdNum[n]=0; gOrdVol[n]=0.0;
   gOrdRisk[n]=0.0;    gOrdNoSL[n]=0;
   return(n);
  }

//--- una riga di GlobalVariable: nome, esistenza, VALORE GREZZO e lettura
//    umana. tipo: 0=timestamp . 1=percentuale . 2=chiave giorno prop
//                 3=valuta del conto . 4=bandiera 0/1
void RigaGV(const string chiave,const string nome,const int tipo,const string significato)
  {
   bool     c = GlobalVariableCheck(nome);
   double   v = (c ? GlobalVariableGet(nome)  : 0.0);
   datetime m = (c ? GlobalVariableTime(nome) : (datetime)0);

   string lettura;
   if(tipo==0)
      lettura=(v>0.0 ? TimeToString((datetime)v,TIME_DATE|TIME_SECONDS)+" srv" : "0 = spenta / mai scritta");
   else if(tipo==1)
      lettura=StringFormat("%.2f%% dell'equity",v);
   else if(tipo==3)
      lettura=StringFormat("%.2f in valuta del conto",v);
   else if(tipo==4)
      lettura=(v>0.0 ? "1 = BANDIERA ALZATA" : "0 = spenta");
   else
      lettura=StringFormat("chiave giorno prop %d",(int)v);

   Riga(StringFormat("[CANARINO] GV %-5s %-32s esiste=%-3s grezzo=%16.4f  lettura=%-26s modificata=%s",
                     chiave,nome,SN(c),v,lettura,
                     (m>0 ? TimeToString(m,TIME_DATE|TIME_SECONDS) : "-")));
   Riga(StringFormat("[CANARINO] GV %-5s    significato: %s",chiave,significato));
  }

//--- il confronto GREZZO contro RICALCOLATO, in una riga sola
void RigaConfronto(const string etichetta,const string come_grezzo,const bool grezzo,
                   const string funzione,const bool calcolato)
  {
   Riga(StringFormat("[CANARINO] %-14s grezzo(%s)=%-3s  %-26s=%-3s  -> %s",
                     etichetta,come_grezzo,SN(grezzo),funzione,SN(calcolato),
                     (grezzo==calcolato ? "coerenti" : "DIVERGONO (vedi rilievo)")));
  }

//====================================================================
//  AUTOTEST INTERNI -- puri: non leggono GlobalVariable, non toccano
//  il conto. Contati con #define secondo il pattern di casa
//  (CHECKLIST 98-99, stampo di ABTG_SondaLondonFx): i BLOCCHI ESEGUITI
//  devono essere quelli ATTESI, altrimenti un blocco cancellato per
//  sbaglio passerebbe per "tutto verde".
//====================================================================
int AutotestCanarino()
  {
   int falliti=0;
   int blocchi=0;

   long   login = AccountInfoInteger(ACCOUNT_LOGIN);
   string coda  = StringFormat("_%I64d",login);

   Titolo("10) AUTOTEST INTERNI (nucleo puro: nessuna GlobalVariable, nessun ordine)");

   //--- BLOCCO 1: i nomi che l'include GENERA rispettano il pattern
   //    "radice_login"? Se ABTG_GVNome cambiasse formato, gli EA
   //    leggerebbero un canale vuoto senza un solo errore.
   blocchi++;
   string b1_n1=ABTG_GVNome("ABTG_PAUSA_GIORNO");
   string b1_n2=ABTG_GVNome("ABTG_PAUSA_FINO");
   string b1_n3=ABTG_GVNome("ABTG_CAP_RISCHIO");
   string b1_n4=ABTG_GVNome("ABTG_RISCHIO_APERTO");
   string b1_n5=ABTG_GVNome("ABTG_GUARDIAN_BATTITO");
   if(b1_n1!="ABTG_PAUSA_GIORNO"+coda      || b1_n2!="ABTG_PAUSA_FINO"+coda ||
      b1_n3!="ABTG_CAP_RISCHIO"+coda       || b1_n4!="ABTG_RISCHIO_APERTO"+coda ||
      b1_n5!="ABTG_GUARDIAN_BATTITO"+coda)
     {
      falliti++;
      Rilievo("BLOCCO 1 FALLITO: ABTG_GVNome NON produce piu' 'radice_login'. IL CANALE E' ROTTO.");
     }
   Riga(StringFormat("[CANARINO] AUTOTEST 1 pattern dei nomi (radice_login) su 5 radici: %s",
                     (falliti==0 ? "PASS" : "*** ROSSO CANARINO ***")));

   //--- BLOCCO 2: i nomi generati combaciano con quelli SCRITTI A MANO
   //    nell'artefatto attese_enforcement_fase1.txt (righe GV.1-GV.6)?
   //    Vale solo sul conto del collaudo: su un altro login i nomi sono
   //    legittimamente diversi, e allora il confronto si DICHIARA sospeso
   //    invece di essere silenziosamente saltato.
   blocchi++;
   string b2_blockday=StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",login);
   if(login==CANARINO_LOGIN_COLLAUDO)
     {
      int b2_diff=0;
      if(b1_n1!=ART_GV1) b2_diff++;
      if(b1_n2!=ART_GV2) b2_diff++;
      if(b1_n3!=ART_GV3) b2_diff++;
      if(b1_n4!=ART_GV4) b2_diff++;
      if(b1_n5!=ART_GV5) b2_diff++;
      if(b2_blockday!=ART_GV6) b2_diff++;
      if(b2_diff>0)
        {
         falliti++;
         Rilievo(StringFormat("BLOCCO 2 FALLITO: %d nomi su 6 NON combaciano con l'artefatto attese_enforcement_fase1.txt. RENAME SILENZIOSO DELL'INCLUDE.",b2_diff));
        }
      Riga(StringFormat("[CANARINO] AUTOTEST 2 confronto coi 6 nomi HARDCODED dell'artefatto: %s (%d differenze)",
                        (b2_diff==0 ? "PASS" : "*** ROSSO CANARINO ***"),b2_diff));
     }
   else
     {
      Riga(StringFormat("[CANARINO] AUTOTEST 2 confronto con l'artefatto NON ESEGUITO: questo conto e' %I64d, "
                        "l'artefatto e' scritto per il %d. Il blocco e' stato percorso, "
                        "il verdetto e' SOSPESO (che NON e' un PASS).",
                        login,CANARINO_LOGIN_COLLAUDO));
     }

   //--- BLOCCO 3: nucleo della PAUSA B1 (la stessa funzione che decide
   //    negli EA). ORA finta: nessuna dipendenza dall'orologio vero.
   blocchi++;
   datetime b3_ora=(datetime)1000000;
   bool b3_a=ABTG_PausaAttiva_Calc(0,0,b3_ora);                                        // mai accesa
   bool b3_b=ABTG_PausaAttiva_Calc((double)(b3_ora-60),(double)(b3_ora+3600),b3_ora);  // scadenza futura
   bool b3_c=ABTG_PausaAttiva_Calc((double)(b3_ora-7200),(double)(b3_ora-60),b3_ora);  // scadenza passata
   bool b3_d=ABTG_PausaAttiva_Calc((double)(b3_ora-25*3600),0,b3_ora);                 // ripiego 24h scaduto
   if(b3_a || !b3_b || b3_c || b3_d)
     { falliti++; Rilievo("BLOCCO 3 FALLITO: ABTG_PausaAttiva_Calc non risponde come il collaudo si aspetta."); }
   Riga(StringFormat("[CANARINO] AUTOTEST 3 nucleo PAUSA B1 (4 casi): %s",
                     ((!b3_a && b3_b && !b3_c && !b3_d) ? "PASS" : "*** ROSSO CANARINO ***")));

   //--- BLOCCO 4: nucleo del CAP C1, compreso il fail-open per anzianita'
   //    del timbro (e' il meccanismo che il criterio 8 va a provare).
   blocchi++;
   datetime b4_ora=(datetime)1000000;
   bool b4_a=ABTG_CapAttivo_Calc(0,b4_ora,120);                     // mai timbrato
   bool b4_b=ABTG_CapAttivo_Calc((double)(b4_ora-1),b4_ora,120);    // timbro fresco
   bool b4_c=ABTG_CapAttivo_Calc((double)(b4_ora-300),b4_ora,120);  // Guardian morto -> scade
   if(b4_a || !b4_b || b4_c)
     { falliti++; Rilievo("BLOCCO 4 FALLITO: ABTG_CapAttivo_Calc non scade piu' per anzianita': IL FAIL-OPEN DEL CAP NON C'E'."); }
   Riga(StringFormat("[CANARINO] AUTOTEST 4 nucleo CAP C1 + fail-open (3 casi): %s",
                     ((!b4_a && b4_b && !b4_c) ? "PASS" : "*** ROSSO CANARINO ***")));

   //--- BLOCCO 5: nucleo del BATTITO (Guardian vivo).
   blocchi++;
   datetime b5_ora=(datetime)1000000;
   bool b5_a=ABTG_GuardianVivo_Calc(0,b5_ora,120);
   bool b5_b=ABTG_GuardianVivo_Calc((double)(b5_ora-2),b5_ora,120);
   bool b5_c=ABTG_GuardianVivo_Calc((double)(b5_ora-600),b5_ora,120);
   if(b5_a || !b5_b || b5_c)
     { falliti++; Rilievo("BLOCCO 5 FALLITO: ABTG_GuardianVivo_Calc non distingue piu' un guardiano morto."); }
   Riga(StringFormat("[CANARINO] AUTOTEST 5 nucleo BATTITO (3 casi): %s",
                     ((!b5_a && b5_b && !b5_c) ? "PASS" : "*** ROSSO CANARINO ***")));

   //--- BLOCCO 6: la DECISIONE completa e la sua precedenza (pausa prima
   //    del cap). E' il numero che il canarino stampa in campo: se qui
   //    sbaglia, la riga "motivo" del referto non vuol dire niente.
   blocchi++;
   datetime b6_ora=(datetime)1000000;
   int b6_libero =ABTG_MotivoStop_Calc(0,0,0,(double)(b6_ora-1),b6_ora,120,false);
   int b6_pausa  =ABTG_MotivoStop_Calc((double)(b6_ora-60),(double)(b6_ora+3600),0,(double)(b6_ora-1),b6_ora,120,false);
   int b6_cap    =ABTG_MotivoStop_Calc(0,0,(double)(b6_ora-1),(double)(b6_ora-1),b6_ora,120,false);
   int b6_ent    =ABTG_MotivoStop_Calc((double)(b6_ora-60),(double)(b6_ora+3600),(double)(b6_ora-1),(double)(b6_ora-1),b6_ora,120,false);
   int b6_morto  =ABTG_MotivoStop_Calc(0,0,0,0,b6_ora,120,true);
   if(b6_libero!=0 || b6_pausa!=1 || b6_cap!=2 || b6_ent!=1 || b6_morto!=3)
     { falliti++; Rilievo("BLOCCO 6 FALLITO: ABTG_MotivoStop_Calc ha cambiato numeri o precedenza."); }
   Riga(StringFormat("[CANARINO] AUTOTEST 6 decisione completa e precedenza (5 casi): %s [libero=%d pausa=%d cap=%d entrambi=%d morto=%d]",
                     ((b6_libero==0 && b6_pausa==1 && b6_cap==2 && b6_ent==1 && b6_morto==3) ? "PASS" : "*** ROSSO CANARINO ***"),
                     b6_libero,b6_pausa,b6_cap,b6_ent,b6_morto));

   //--- BLOCCO 7: le DUE FRASI che il verificatore cerca nei log degli EA
   //    (righe C5.EA e C7.EA dell'artefatto) le produce ancora l'include?
   //    Se cambiassero, la raccolta troverebbe ZERO blocchi e il collaudo
   //    concluderebbe "PASS" per assenza di prove: il modo peggiore di
   //    sbagliare, perche' sembra un successo.
   blocchi++;
   string b7_t1=ABTG_MotivoTesto(1);
   string b7_t2=ABTG_MotivoTesto(2);
   bool   b7_ok=(StringFind(b7_t1,ART_TESTO_B1)>=0 && StringFind(b7_t2,ART_TESTO_C1)>=0);
   if(!b7_ok)
     {
      falliti++;
      Rilievo("BLOCCO 7 FALLITO: i testi di ABTG_MotivoTesto NON contengono piu' le frasi "
              "cercate dall'artefatto. Le righe di raccolta del collaudo troverebbero ZERO blocchi.");
     }
   Riga(StringFormat("[CANARINO] AUTOTEST 7 frasi C5.EA/C7.EA prodotte dall'include: %s",
                     (b7_ok ? "PASS" : "*** ROSSO CANARINO ***")));
   Riga(StringFormat("[CANARINO] AUTOTEST 7    motivo 1 = '%s'",b7_t1));
   Riga(StringFormat("[CANARINO] AUTOTEST 7    motivo 2 = '%s'",b7_t2));

   //--- BLOCCO 8: l'aritmetica del canarino (percentuale sull'equity),
   //    coi casi degeneri che altrimenti si scoprono in campo.
   blocchi++;
   bool b8_ok=(MathAbs(PctSuEquity_Calc(650.0,100000.0)-0.65)<0.000001 &&
               MathAbs(PctSuEquity_Calc(0.0,100000.0))<0.000001 &&
               MathAbs(PctSuEquity_Calc(-50.0,100000.0))<0.000001 &&
               MathAbs(PctSuEquity_Calc(650.0,0.0))<0.000001 &&
               MathAbs(PctSuEquity_Calc(650.0,-100.0))<0.000001);
   if(!b8_ok)
     { falliti++; Rilievo("BLOCCO 8 FALLITO: PctSuEquity_Calc sbaglia i casi degeneri (equity 0 o negativa)."); }
   Riga(StringFormat("[CANARINO] AUTOTEST 8 aritmetica delle percentuali (5 casi): %s",
                     (b8_ok ? "PASS" : "*** ROSSO CANARINO ***")));

   //--- IL CONTROLLO SUL CONTROLLO: i blocchi eseguiti sono quelli attesi?
   if(blocchi!=CANARINO_BLOCCHI_ATTESI)
     {
      falliti++;
      Rilievo(StringFormat("AUTOTEST INCOMPLETO: eseguiti %d blocchi ma ne erano attesi %d. MANCA UN BLOCCO: l'autotest si dichiara FALLITO.",
                           blocchi,CANARINO_BLOCCHI_ATTESI));
     }

   Riga(StringFormat("[CANARINO] AUTOTEST: %d blocchi su %d passati (falliti %d, attesi %d).",
                     blocchi-falliti,blocchi,falliti,CANARINO_BLOCCHI_ATTESI));
   return(falliti);
  }

//====================================================================
//  SEZIONE: ORE (la trappola gia' pagata il 06/08)
//====================================================================
void SezioneOre(const datetime oraS)
  {
   datetime oraL=TimeLocal();
   datetime oraG=TimeGMT();
   long scarto=((long)oraL-(long)oraS)/60;

   Titolo("1) ORE -- quale orologio sta parlando");
   Riga(StringFormat("[CANARINO] ora SERVER   (grafico, GlobalVariable, TimeCurrent) : %s",
                     TimeToString(oraS,TIME_DATE|TIME_SECONDS)));
   Riga(StringFormat("[CANARINO] ora LOCALE   (schede Esperti/Giornale, orologio VPS): %s",
                     TimeToString(oraL,TIME_DATE|TIME_SECONDS)));
   Riga(StringFormat("[CANARINO] ora GMT                                             : %s",
                     TimeToString(oraG,TIME_DATE|TIME_SECONDS)));
   Riga(StringFormat("[CANARINO] scarto LOCALE - SERVER = %I64d minuti. Regola di casa: il server BCM e' UN'ORA INDIETRO sull'ora italiana.",
                     scarto));
   Riga("[CANARINO] Conseguenza da ricordare quando si cerca una riga: un tentativo delle 07:59 SERVER");
   Riga("[CANARINO] si cerca alle 08:59 nel Giornale (che e' in ora locale). Errore gia' fatto il 06/08.");
  }

//====================================================================
//  SEZIONE: CONTO
//====================================================================
void SezioneConto(const long login)
  {
   Titolo("2) CONTO -- se il login e' sbagliato, tutto il resto e' teatro");
   Riga(StringFormat("[CANARINO] login=%I64d  server='%s'  broker='%s'  valuta=%s  leva=1:%I64d",
                     login,
                     AccountInfoString(ACCOUNT_SERVER),
                     AccountInfoString(ACCOUNT_COMPANY),
                     AccountInfoString(ACCOUNT_CURRENCY),
                     AccountInfoInteger(ACCOUNT_LEVERAGE)));

   long mm=AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   string modo=(mm==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING ? "HEDGING" :
               (mm==ACCOUNT_MARGIN_MODE_RETAIL_NETTING ? "NETTING" : "EXCHANGE"));
   Riga(StringFormat("[CANARINO] tipo conto=%s  (il conteggio per POSIZIONE del freno P1 vale in hedging)",modo));

   if(login==CANARINO_LOGIN_COLLAUDO)
      Riga(StringFormat("[CANARINO] questo E' il conto del collaudo fase 1 (%d): i nomi delle GlobalVariable dell'artefatto valgono.",
                        CANARINO_LOGIN_COLLAUDO));
   else
      Rilievo(StringFormat("QUESTO NON E' IL CONTO DEL COLLAUDO (%d): il referto vale come prova di FUNZIONAMENTO DELLO STRUMENTO, non come misura della fase 1.",
                           CANARINO_LOGIN_COLLAUDO));
  }

//====================================================================
//  SEZIONE: IL GIORNO PROP
//  Il canarino NON puo' leggere InpDailyResetHour del Guardian (e' un
//  input di un altro programma). Allora fa la cosa onesta: stampa le
//  DUE letture possibili e DEDUCE quale sia, confrontandole con la
//  chiave che il Guardian ha davvero scritto.
//====================================================================
void SezioneGiornoProp(const datetime oraS,const long login)
  {
   Titolo("3) GIORNO PROP -- quale giornata sta contando il Guardian");

   datetime rif=(datetime)((long)oraS+(long)InpGiornoOffset*86400);
   if(InpGiornoOffset!=0)
     {
      Rilievo(StringFormat("LETTURA CON OFFSET %d GIORNI: le GlobalVariable sono uno STATO ISTANTANEO "
                           "e NON hanno storia. L'offset sposta SOLO le finestre di giorno stampate "
                           "qui sotto, non i valori letti.",
                           InpGiornoOffset));
     }

   datetime ini0 =ABTG_InizioGiornoServer_Calc(rif,0);
   datetime ini23=ABTG_InizioGiornoServer_Calc(rif,23);
   Riga(StringFormat("[CANARINO] finestra con reset 0  (mezzanotte server): da %s a %s",
                     TimeToString(ini0,TIME_DATE|TIME_MINUTES),
                     TimeToString(ini0+86400,TIME_DATE|TIME_MINUTES)));
   Riga(StringFormat("[CANARINO] finestra con reset 23 (giorno prop 23:00): da %s a %s",
                     TimeToString(ini23,TIME_DATE|TIME_MINUTES),
                     TimeToString(ini23+86400,TIME_DATE|TIME_MINUTES)));

   string nDayKey=StringFormat("ABTG_GUARD_%I64d_DAYKEY",login);
   bool   cDayKey=GlobalVariableCheck(nDayKey);
   int    letta  =(cDayKey ? (int)GlobalVariableGet(nDayKey) : 0);
   int    k0 =ChiaveGiornoProp_Calc(oraS,0);
   int    k23=ChiaveGiornoProp_Calc(oraS,23);

   Riga(StringFormat("[CANARINO] chiave giorno prop: scritta dal Guardian=%d  (calcolata con reset 0=%d, con reset 23=%d)",
                     letta,k0,k23));

   if(!cDayKey || letta==0)
      Rilievo("IL GUARDIAN NON HA MAI SCRITTO LA CHIAVE DEL GIORNO SU QUESTO CONTO: o non e' mai stato avviato qui, o e' un altro login.");
   else if(k0==k23)
      Riga("[CANARINO] a quest'ora le due letture COINCIDONO: l'ora di reset NON e' distinguibile adesso (lo diventa fra le 23:00 e la mezzanotte server).");
   else if(letta==k0)
      Riga("[CANARINO] ora di reset DEDOTTA = 0 (mezzanotte server): la chiave scritta combacia con quella a reset 0.");
   else if(letta==k23)
      Riga("[CANARINO] ora di reset DEDOTTA = 23 (giorno prop, firma del 18/08): la chiave scritta combacia con quella a reset 23.");
   else
      Rilievo(StringFormat("LA CHIAVE SCRITTA (%d) NON COMBACIA NE' CON RESET 0 (%d) NE' CON RESET 23 (%d): "
                           "il Guardian usa un'altra ora di reset, oppure la chiave e' vecchia. "
                           "Da dichiarare nel verbale.",
                           letta,k0,k23));

   //--- gli altri numeri interni del Guardian, in sola lettura
   RigaGV("D-KEY",nDayKey,2,"chiave del giorno prop in corso, scritta dal Guardian");
   RigaGV("D-STA",StringFormat("ABTG_GUARD_%I64d_DAYSTART",login),3,
          "saldo a inizio giornata prop: e' la BASELINE su cui si misura la perdita del giorno (pausa B1)");
   RigaGV("START",StringFormat("ABTG_GUARD_%I64d_START",login),3,
          "saldo iniziale della challenge (base dei limiti 4,9 / 9,9)");
   RigaGV("PEAK", StringFormat("ABTG_GUARD_%I64d_PEAK",login),3,
          "picco di equity, serve al DD trailing se InpDDMode=1");
   RigaGV("FAIL", StringFormat("ABTG_GUARD_%I64d_FAILED",login),4,
          "challenge dichiarata FALLITA dal Guardian (DD totale sfondato). 0 = no");
  }

//====================================================================
//  SEZIONE: LE GLOBALVARIABLE DEL CANALE
//  I nomi vengono dall'include (ABTG_GVNome), cosi' si legge dove
//  leggono gli EA; le chiavi GV.1-GV.6 sono quelle dell'artefatto.
//====================================================================
void SezioneGlobalVariable(const long login)
  {
   Titolo("4) LE GLOBALVARIABLE DEL CANALE (chiavi GV.1-GV.6 dell'artefatto attese_enforcement_fase1.txt)");

   RigaGV("GV.1",ABTG_GVNome("ABTG_PAUSA_GIORNO"),0,
          "timestamp accensione pausa B1. E' un LATCH: non si spegne rialzando la soglia (rilievo R2)");
   RigaGV("GV.2",ABTG_GVNome("ABTG_PAUSA_FINO"),0,
          "scadenza dichiarata della pausa: e' la rete se il guardiano muore con la pausa accesa");
   RigaGV("GV.3",ABTG_GVNome("ABTG_CAP_RISCHIO"),0,
          "timestamp RI-TIMBRATO ogni secondo finche' il cap C1 morde; 0 = rientrato");
   RigaGV("GV.4",ABTG_GVNome("ABTG_RISCHIO_APERTO"),1,
          "rischio aperto in % misurato dal Guardian (informativo, CIECO SUI PENDENTI: buco B6)");
   RigaGV("GV.5",ABTG_GVNome("ABTG_GUARDIAN_BATTITO"),0,
          "battito del guardiano, tolleranza 120 s (ABTG_BATTITO_TOLLERANZA)");
   RigaGV("GV.6",StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",login),2,
          "NON e' del canale: e' il BLOCCO DURO. Se resta timbrato e InpAction=0 il Guardian chiude tutto al primo timer");

   //--- il canale esiste? E' la spia X1/X3: se non esiste, tutti gli EA
   //    passano in silenzio (fail-open totale) e nessuno se ne accorge.
   bool canale=ABTG_CanaleEsiste();
   Riga(StringFormat("[CANARINO] ABTG_CanaleEsiste() = %s  (la stessa funzione che usano gli EA prima di leggere le bandiere)",
                     SN(canale)));
   if(!canale)
      Rilievo("IL CANALE NON ESISTE SU QUESTO CONTO: ABTG_CanaleEsiste() = NO. Gli EA vanno in "
              "fail-open totale, cioe' aprono SENZA chiedere niente, e non lo scrivono da nessuna "
              "parte. Se il Guardian dovrebbe essere acceso, questo e' un difetto grave.");
  }

//====================================================================
//  SEZIONE: IL VERDETTO -- valore GREZZO accanto al RICALCOLATO.
//  E' il cuore del canarino: il Guardian decide guardando "timestamp
//  > 0"; gli EA decidono con le funzioni _Calc dell'include, che
//  tengono conto della SCADENZA (pausa) e dell'ANZIANITA' (cap).
//  Quando i due non dicono la stessa cosa, non e' un dettaglio: e'
//  esattamente la finestra in cui la protezione c'e' da una parte e
//  non c'e' dall'altra.
//====================================================================
void SezioneVerdetto(const datetime oraS)
  {
   Titolo("5) IL VERDETTO -- valore GREZZO contro RICALCOLATO CON LE FUNZIONI DELL'INCLUDE");

   double ts_pausa   = ABTG_GVLeggi("ABTG_PAUSA_GIORNO");
   double ts_fino    = ABTG_GVLeggi("ABTG_PAUSA_FINO");
   double ts_cap     = ABTG_GVLeggi("ABTG_CAP_RISCHIO");
   double ts_battito = ABTG_GVLeggi("ABTG_GUARDIAN_BATTITO");

   //--- il GREZZO: e' cosi' che il Guardian stesso legge le sue bandiere
   //    (ABTG_Guardian.mq5 riga 406 per la pausa, righe 416/425 per il cap).
   bool pausa_grezza = (ts_pausa>0.0);
   bool cap_grezzo   = (ts_cap>0.0);
   bool vivo_grezzo  = (ts_battito>0.0);

   //--- il RICALCOLATO: e' cosi' che decidono gli EA, con lo stesso codice.
   bool pausa_calc = ABTG_PausaAttiva_Calc(ts_pausa,ts_fino,oraS);
   bool cap_calc   = ABTG_CapAttivo_Calc(ts_cap,oraS,ABTG_BATTITO_TOLLERANZA);
   bool vivo_calc  = ABTG_GuardianVivo_Calc(ts_battito,oraS,ABTG_BATTITO_TOLLERANZA);

   RigaConfronto("PAUSA B1","ts>0",pausa_grezza,"ABTG_PausaAttiva_Calc",pausa_calc);
   RigaConfronto("CAP C1","ts>0",cap_grezzo,"ABTG_CapAttivo_Calc",cap_calc);
   RigaConfronto("GUARDIAN VIVO","ts>0",vivo_grezzo,"ABTG_GuardianVivo_Calc",vivo_calc);

   if(pausa_grezza!=pausa_calc)
     {
      Rilievo("PAUSA: IL GREZZO E IL RICALCOLATO DIVERGONO. La bandiera e' scritta ma per l'include "
              "la pausa e' SCADUTA (o viceversa): in questa finestra il pannello del Guardian direbbe "
              "'ATTIVA' e gli EA aprirebbero lo stesso.");
      Riga(StringFormat("[CANARINO]   dettaglio: accensione=%s  scadenza=%s  adesso=%s",
                        (ts_pausa>0 ? TimeToString((datetime)ts_pausa,TIME_DATE|TIME_MINUTES) : "mai"),
                        (ts_fino>0  ? TimeToString((datetime)ts_fino, TIME_DATE|TIME_MINUTES) : "non dichiarata (ripiego 24h)"),
                        TimeToString(oraS,TIME_DATE|TIME_MINUTES)));
     }

   if(cap_grezzo!=cap_calc)
     {
      Rilievo("CAP: IL GREZZO E IL RICALCOLATO DIVERGONO. Il timbro c'e' ma e' VECCHIO: per l'include il cap e' gia' scaduto per anzianita'.");
      Riga(StringFormat("[CANARINO]   dettaglio: ultimo timbro %s, cioe' %I64d secondi fa (tolleranza %d s).",
                        (ts_cap>0 ? TimeToString((datetime)ts_cap,TIME_DATE|TIME_SECONDS) : "mai"),
                        (long)((long)oraS-(long)ts_cap),ABTG_BATTITO_TOLLERANZA));
      Riga("[CANARINO]   ATTENZIONE ALLA LETTURA: durante la prova del CRITERIO 8 questa divergenza NON e' un difetto,");
      Riga("[CANARINO]   e' ESATTAMENTE il fail-open che si sta collaudando (Guardian rimosso, cap che scade da solo).");
      Riga("[CANARINO]   Fuori da quella prova, invece, vuol dire che il Guardian ha smesso di timbrare: allora e' un difetto.");
     }

   if(vivo_grezzo!=vivo_calc)
     {
      Rilievo("BATTITO: IL GREZZO E IL RICALCOLATO DIVERGONO. La GV del battito esiste ma e' FERMA: per l'include il guardiano e' MORTO.");
      Riga(StringFormat("[CANARINO]   dettaglio: ultimo battito %s, cioe' %I64d secondi fa (tolleranza %d s).",
                        (ts_battito>0 ? TimeToString((datetime)ts_battito,TIME_DATE|TIME_SECONDS) : "mai"),
                        (long)((long)oraS-(long)ts_battito),ABTG_BATTITO_TOLLERANZA));
     }

   //--- la decisione completa, coi due modi in cui un EA la puo' chiedere
   int motivo_std =ABTG_MotivoStop_Calc(ts_pausa,ts_fino,ts_cap,ts_battito,oraS,ABTG_BATTITO_TOLLERANZA,false);
   int motivo_pret=ABTG_MotivoStop_Calc(ts_pausa,ts_fino,ts_cap,ts_battito,oraS,ABTG_BATTITO_TOLLERANZA,true);

   Riga(StringFormat("[CANARINO] MOTIVO con pretendi_guardian=false (come i 5 mirror): %d = %s",
                     motivo_std,ABTG_MotivoTesto(motivo_std)));
   Riga(StringFormat("[CANARINO] MOTIVO con pretendi_guardian=true  (nessuno dei 5 lo usa): %d = %s",
                     motivo_pret,ABTG_MotivoTesto(motivo_pret)));
   Riga(StringFormat("[CANARINO] ESITO PER UN EA ADESSO: un ingresso sarebbe %s.",
                     (motivo_std==0 ? "PERMESSO" : "FERMATO")));
   Riga("[CANARINO] NOTA: il canarino NON ripete ne' il prefisso di giornale degli EA ne' la loro frase di blocco");
   Riga("[CANARINO] (vincolo 3 in testa al file), cosi' il censimento del criterio 9 non conta come blocco");
   Riga("[CANARINO] una riga che nessun EA ha mai subito.");

   //--- il rischio aperto come lo vede il Guardian (informativo)
   double risk_gv=RischioApertoPct();
   Riga(StringFormat("[CANARINO] rischio aperto scritto dal Guardian (RischioApertoPct dell'include) = %.2f%%",risk_gv));
  }

//====================================================================
//  SEZIONE: SOLDI (sola lettura, AccountInfoDouble)
//====================================================================
double SezioneSoldi()
  {
   double bal   =AccountInfoDouble(ACCOUNT_BALANCE);
   double eq    =AccountInfoDouble(ACCOUNT_EQUITY);
   double marg  =AccountInfoDouble(ACCOUNT_MARGIN);
   double libero=AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double livello=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   double prof  =AccountInfoDouble(ACCOUNT_PROFIT);

   Titolo("6) SOLDI -- sola lettura");
   Riga(StringFormat("[CANARINO] balance=%.2f  equity=%.2f  profitto aperto=%.2f",bal,eq,prof));
   Riga(StringFormat("[CANARINO] margine usato=%.2f  margine libero=%.2f  livello margine=%.2f%%",
                     marg,libero,livello));
   if(eq<=0.0)
      Rilievo("EQUITY NON POSITIVA: tutte le percentuali di rischio qui sotto sono forzate a 0 e NON vogliono dire niente.");
   return(eq);
  }

//====================================================================
//  SEZIONE: POSIZIONI PER MAGIC
//  Il rischio si calcola nei DUE modi del Guardian (InpRiskMode 0 e 1),
//  perche' il canarino non puo' sapere quale sia impostato: stampando
//  entrambi, il confronto con la GV dice anche QUALE modo e' in uso.
//====================================================================
void SezionePosizioni(const double equity,double &tot_risk0,double &tot_risk1,int &tot_nosl)
  {
   Titolo("7) POSIZIONI APERTE PER MAGIC (queste il cap LE VEDE)");

   tot_risk0=0.0; tot_risk1=0.0; tot_nosl=0;
   int totale=PositionsTotal();
   Riga(StringFormat("[CANARINO] posizioni aperte sul conto: %d",totale));

   for(int i=0;i<totale;i++)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;

      string sym  =PositionGetString(POSITION_SYMBOL);
      long   magic=PositionGetInteger(POSITION_MAGIC);
      long   tipo =PositionGetInteger(POSITION_TYPE);
      double vol  =PositionGetDouble(POSITION_VOLUME);
      double apert=PositionGetDouble(POSITION_PRICE_OPEN);
      double corr =PositionGetDouble(POSITION_PRICE_CURRENT);
      double sl   =PositionGetDouble(POSITION_SL);
      bool   buy  =(tipo==POSITION_TYPE_BUY);

      double r0=PerditaSeSLColpito(sym,buy,vol,apert,sl);
      double r1=PerditaSeSLColpito(sym,buy,vol,corr, sl);

      int s=SlotPos(magic);
      gPosNum[s]++;  gPosVol[s]+=vol;
      gPosRisk0[s]+=r0; gPosRisk1[s]+=r1;
      if(sl<=0.0) { gPosNoSL[s]++; tot_nosl++; }

      tot_risk0+=r0; tot_risk1+=r1;

      Riga(StringFormat("[CANARINO]   pos #%I64u magic=%I64d %-10s %-4s vol=%.2f apert=%.5f corr=%.5f sl=%s rischio_da_ingresso=%.2f rischio_da_prezzo=%.2f",
                        tk,magic,sym,(buy?"BUY":"SELL"),vol,apert,corr,
                        (sl>0.0 ? DoubleToString(sl,5) : "NESSUNO"),r0,r1));
     }

   int nm=ArraySize(gPosMagic);
   for(int m=0;m<nm;m++)
      Riga(StringFormat("[CANARINO]   TOTALE magic %I64d: %d posizioni, vol %.2f, rischio %.2f (%.2f%% eq) da ingresso / %.2f (%.2f%% eq) da prezzo, senza SL %d",
                        gPosMagic[m],gPosNum[m],gPosVol[m],
                        gPosRisk0[m],PctSuEquity_Calc(gPosRisk0[m],equity),
                        gPosRisk1[m],PctSuEquity_Calc(gPosRisk1[m],equity),
                        gPosNoSL[m]));

   Riga(StringFormat("[CANARINO] RISCHIO APERTO ricalcolato dal canarino: modo 0 (da ingresso) = %.2f%%  |  modo 1 (da prezzo corrente) = %.2f%%",
                     PctSuEquity_Calc(tot_risk0,equity),PctSuEquity_Calc(tot_risk1,equity)));
   if(tot_nosl>0)
      Rilievo(StringFormat("%d POSIZIONI SENZA SL: rischio IGNOTO, escluso dal cap e da questi totali. Il numero del cancello e' un LIMITE INFERIORE anche per questo.",
                           tot_nosl));
  }

//====================================================================
//  SEZIONE: PENDENTI PER MAGIC -- IL BUCO B6.
//  OpenRiskPct() del Guardian (riga 159) cicla SOLO PositionsTotal():
//  un ordine pendente con SL e' rischio gia' promesso che il cap conta
//  ZERO. Il canarino lo conta e lo stampa: e' l'unica misura del buco
//  che il collaudo puo' portare a casa senza toccare il Guardian.
//====================================================================
void SezionePendenti(const double equity,double &tot_risk,int &tot_nosl)
  {
   Titolo("8) ORDINI PENDENTI PER MAGIC (questi il cap NON LI VEDE -- buco B6)");

   tot_risk=0.0; tot_nosl=0;
   int totale=OrdersTotal();
   Riga(StringFormat("[CANARINO] ordini pendenti sul conto: %d",totale));

   for(int i=0;i<totale;i++)
     {
      ulong tk=OrderGetTicket(i);
      if(tk==0) continue;

      string sym  =OrderGetString(ORDER_SYMBOL);
      long   magic=OrderGetInteger(ORDER_MAGIC);
      long   tipo =OrderGetInteger(ORDER_TYPE);
      double vol  =OrderGetDouble(ORDER_VOLUME_CURRENT);
      double prezzo=OrderGetDouble(ORDER_PRICE_OPEN);
      double stoplim=OrderGetDouble(ORDER_PRICE_STOPLIMIT);
      double sl   =OrderGetDouble(ORDER_SL);
      bool   buy  =OrdineLatoBuy(tipo);

      // su uno stop-limit il prezzo d'ingresso VERO e' il secondo prezzo
      double ingresso=((stoplim>0.0) ? stoplim : prezzo);

      double r=PerditaSeSLColpito(sym,buy,vol,ingresso,sl);

      int s=SlotOrd(magic);
      gOrdNum[s]++; gOrdVol[s]+=vol; gOrdRisk[s]+=r;
      if(sl<=0.0) { gOrdNoSL[s]++; tot_nosl++; }

      tot_risk+=r;

      Riga(StringFormat("[CANARINO]   ord #%I64u magic=%I64d %-10s %-16s vol=%.2f ingresso=%.5f sl=%s rischio_se_eseguito=%.2f",
                        tk,magic,sym,NomeTipoOrdine(tipo),vol,ingresso,
                        (sl>0.0 ? DoubleToString(sl,5) : "NESSUNO"),r));
     }

   int nm=ArraySize(gOrdMagic);
   for(int m=0;m<nm;m++)
      Riga(StringFormat("[CANARINO]   TOTALE magic %I64d: %d pendenti, vol %.2f, rischio se eseguiti %.2f (%.2f%% eq), senza SL %d",
                        gOrdMagic[m],gOrdNum[m],gOrdVol[m],gOrdRisk[m],
                        PctSuEquity_Calc(gOrdRisk[m],equity),gOrdNoSL[m]));

   Riga(StringFormat("[CANARINO] rischio pendente non visto dal cap = %.2f%% dell'equity (%.2f in valuta, su %d ordini)",
                     PctSuEquity_Calc(tot_risk,equity),tot_risk,totale));
   if(tot_nosl>0)
      Riga(StringFormat("[CANARINO] di questi, %d pendenti SENZA SL: rischio non calcolabile, NON compreso nel numero qui sopra.",
                        tot_nosl));
  }

//====================================================================
//  SEZIONE: IL CONFRONTO CHE INTERESSA AL CANCELLO DELLA FASE 1
//====================================================================
void SezioneCancello(const double equity,const double risk0,const double risk1,const double risk_pend)
  {
   Titolo("9) IL NUMERO DEL CANCELLO -- rischio aperto contro cap 3,25% (firma C1 del 18/08)");

   double gv    =RischioApertoPct();
   double p0    =PctSuEquity_Calc(risk0,equity);
   double p1    =PctSuEquity_Calc(risk1,equity);
   double ppend =PctSuEquity_Calc(risk_pend,equity);

   Riga(StringFormat("[CANARINO] scritto dal Guardian (GV.4)          : %.2f%%",gv));
   Riga(StringFormat("[CANARINO] ricalcolato dal canarino, modo 0     : %.2f%%   (distanza INGRESSO->SL, la convenzione della misura M2)",p0));
   Riga(StringFormat("[CANARINO] ricalcolato dal canarino, modo 1     : %.2f%%   (distanza PREZZO CORRENTE->SL)",p1));
   Riga(StringFormat("[CANARINO] rischio PENDENTE non visto dal cap   : %.2f%%   (buco B6)",ppend));
   Riga(StringFormat("[CANARINO] SOMMA posizioni(modo 0) + pendenti   : %.2f%%   <-- questo e' il rischio DAVVERO promesso al mercato",
                     p0+ppend));

   //--- quale modo e' in uso? Lo dice il confronto, non un'opinione.
   double d0=MathAbs(gv-p0);
   double d1=MathAbs(gv-p1);
   if(gv<=0.0 && p0<=0.0 && p1<=0.0)
      Riga("[CANARINO] tutto a zero: nessuna posizione con SL. Il modo del Guardian (InpRiskMode) NON e' deducibile adesso.");
   else if(d0<=0.05 && d1>0.05)
      Riga("[CANARINO] InpRiskMode DEDOTTO = 0 (dall'ingresso): il valore del Guardian combacia col modo 0.");
   else if(d1<=0.05 && d0>0.05)
      Riga("[CANARINO] InpRiskMode DEDOTTO = 1 (dal prezzo corrente): il valore del Guardian combacia col modo 1.");
   else if(d0<=0.05 && d1<=0.05)
      Riga("[CANARINO] i due modi danno lo stesso numero adesso: InpRiskMode non e' distinguibile (succede a posizioni appena aperte).");
   else
      Rilievo(StringFormat("IL RISCHIO SCRITTO DAL GUARDIAN (%.2f%%) NON COMBACIA CON NESSUNO DEI DUE "
                           "MODI (%.2f%% / %.2f%%). O la GV e' vecchia (Guardian fermo), o le due misure "
                           "sono su insiemi diversi di posizioni. Da dichiarare.",
                           gv,p0,p1));

   if((p0+ppend)>3.25)
      Rilievo(StringFormat("RISCHIO TOTALE PROMESSO %.2f%% OLTRE IL CAP FIRMATO 3,25%%: la parte oltre il "
                           "cap e' fatta di PENDENTI, che il Guardian non conta (buco B6). Non e' una "
                           "violazione del codice: e' il buco dichiarato, misurato.",
                           p0+ppend));

   Riga("[CANARINO] CAVEAT DA RIPETERE SEMPRE INSIEME AL NUMERO (R7):");
   Riga("[CANARINO]  (a) la GV del Guardian nel log e' campionata ogni 300 s: i picchi fra due campioni non si vedono;");
   Riga("[CANARINO]  (b) il cap e' CIECO SUI PENDENTI (B6): il suo numero e' un LIMITE INFERIORE del rischio impegnato;");
   Riga("[CANARINO]  (c) questa e' UNA fotografia, presa adesso: non e' il massimo della giornata.");
  }

//====================================================================
//  IL PROGRAMMA -- gira una volta, stampa, esce.
//====================================================================
void OnStart()
  {
   datetime oraS =TimeCurrent();
   long     login=AccountInfoInteger(ACCOUNT_LOGIN);

   //--- il referto: UN solo file, nome con timestamp SERVER, ASCII puro.
   MqlDateTime s; TimeToStruct(oraS,s);
   string nome=StringFormat("ABTG_Canarino_%I64d_%04d%02d%02d_%02d%02d%02d_srv.txt",
                            login,s.year,s.mon,s.day,s.hour,s.min,s.sec);
   gFile=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI);

   Riga("[CANARINO] ==================================================================");
   Riga(StringFormat("[CANARINO] CANARINO DEL GUARDIAN %s -- SOLA LETTURA (P-C1, firma D2 del 02/09/2026)",
                     CANARINO_VERSIONE));
   Riga("[CANARINO] Non manda ordini, non scrive GlobalVariable, non tocca nessun EA.");
   Riga("[CANARINO] Rende deterministici i criteri 5/7/8 del collaudo enforcement fase 1.");
   Riga("[CANARINO] LIMITE DICHIARATO: prova IL CANALE e L'INCLUDE, non che i binari dei 5 mirror");
   Riga("[CANARINO] chiamino la guardia. Quella prova resta la riga di giornale di un EA vero.");
   if(gFile==INVALID_HANDLE)
      Rilievo(StringFormat("REFERTO NON SCRITTO: FileOpen('%s') fallito, errore %d. Resta il Giornale: copiarlo a mano.",
                           nome,GetLastError()));
   else
      Riga(StringFormat("[CANARINO] referto: MQL5\\Files\\%s",nome));

   //--- 1-9: le sezioni, nell'ordine in cui servono a chi legge il verbale
   SezioneOre(oraS);
   SezioneConto(login);
   SezioneGiornoProp(oraS,login);
   SezioneGlobalVariable(login);
   SezioneVerdetto(oraS);

   double equity=SezioneSoldi();

   double risk0=0.0, risk1=0.0, risk_pend=0.0;
   int    nosl_pos=0, nosl_ord=0;
   SezionePosizioni(equity,risk0,risk1,nosl_pos);
   SezionePendenti(equity,risk_pend,nosl_ord);
   SezioneCancello(equity,risk0,risk1,risk_pend);

   //--- 10: gli autotest interni
   int falliti=AutotestCanarino();

   //--- 11: il riepilogo. I rilievi si ripetono qui perche' un rilievo
   //    in mezzo a cento righe non l'ha letto nessuno.
   Titolo("11) RIEPILOGO");
   int nr=ArraySize(gRilievi);
   if(nr==0)
      Riga("[CANARINO] nessun rilievo: grezzo e ricalcolato coincidono su tutte e tre le bandiere, "
           "i nomi delle GlobalVariable sono quelli dell'artefatto e gli autotest sono tutti verdi.");
   else
     {
      Riga(StringFormat("[CANARINO] RILIEVI: %d",nr));
      for(int i=0;i<nr;i++)
         Riga(StringFormat("[CANARINO]   R%d) %s",i+1,gRilievi[i]));
     }
   Riga(StringFormat("[CANARINO] autotest: %d falliti su %d blocchi attesi.",
                     falliti,CANARINO_BLOCCHI_ATTESI));
   Riga(StringFormat("[CANARINO] righe stampate: %d. Ora server di fine: %s.",
                     gRighe+1,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS)));
   Riga("[CANARINO] FINE. Nessun ordine inviato, nessuna GlobalVariable scritta, nessun EA toccato.");

   if(gFile!=INVALID_HANDLE) FileClose(gFile);
  }
//+------------------------------------------------------------------+
