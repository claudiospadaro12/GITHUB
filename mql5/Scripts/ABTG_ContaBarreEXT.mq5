//+------------------------------------------------------------------+
//|  ABTG_ContaBarreEXT.mq5                                          |
//|  MARCATORE: CONTA-EXT-v1                                         |
//|                                                                  |
//|  A COSA SERVE (25/08/2026)                                       |
//|  Dopo un import di storico esterno (_EXT) la domanda non e'      |
//|  "il simbolo c'e'?" ma "QUANTI ANNI ci sono davvero dentro, e    |
//|  ce n'e' qualcuno VUOTO in mezzo?".                              |
//|  ABTG_HistoryDownloader dice Barre + PrimaDataLocale: non dice   |
//|  l'ULTIMA barra e non dice niente anno per anno. Un simbolo che  |
//|  parte dal 2010 e finisce oggi puo' avere il 2014 a zero, e da   |
//|  quel referto non si vedrebbe.                                   |
//|                                                                  |
//|  COSA FA                                                         |
//|   per ogni SIMBOLO chiesto e per ogni TIMEFRAME chiesto:         |
//|     - prima barra, ultima barra, barre totali                    |
//|     - il conteggio BARRE PER ANNO, anno per anno                 |
//|     - gli anni VUOTI dentro l'intervallo, elencati per nome      |
//|   e scrive tutto in MQL5\Files\<InpFileCsv> + scheda Esperti.    |
//|                                                                  |
//|  NESSUNA ASSENZA SILENZIOSA (il difetto gia' pagato due volte)   |
//|  OGNI simbolo chiesto compare nel CSV con la sua riga, anche se  |
//|  non esiste, anche se non ha barre. Un simbolo che sparisce dal  |
//|  referto si legge come una domanda mai fatta.                    |
//|                                                                  |
//|  IL CANARINO DEL TETTO (checklist 36)                            |
//|  MT5 ritaglia le serie a "Max barre nel grafico". Un conteggio   |
//|  che esce ESATTAMENTE 100.000 (o il tetto impostato) non e' il   |
//|  dato: e' l'impostazione. Qui viene marcato a parte, perche' il  |
//|  17/08 cinque simboli con profondita' reali diversissime         |
//|  (1971, 1993, 2004) sono usciti tutti allo stesso numero tondo.  |
//|                                                                  |
//|  NON TOCCA NIENTE: nessun ordine, nessuna posizione, nessun      |
//|  file di MT5 fuori da MQL5\Files. Legge e conta.                 |
//|                                                                  |
//|  STATO: SCRITTO IN CLOUD, **NON COMPILATO E NON PROVATO**.       |
//|  In questo ambiente non c'e' MetaEditor. Il primo che lo compila |
//|  e' Claudio: se non compila, e' un difetto mio, non suo.         |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimboli   = "NASUSD_EXT";                 // simboli, separati da virgola
input string InpTF        = "M15,H1";                     // timeframe, separati da virgola
input string InpFileCsv   = "ABTG_ContaBarreEXT.csv";     // referto in MQL5\Files
input int    InpAttesaSec = 30;                           // attesa max per la sincronizzazione di ogni serie
input int    InpTettoAtteso = 100000;                     // il tetto "Max barre nel grafico" da smascherare
input bool   InpAutoTest  = false;                        // giro a vuoto: nessuna lettura, solo i controlli interni

//--- una riga di referto per SIMBOLO x TIMEFRAME
struct RigaEXT
  {
   string            simbolo;
   string            tf;
   long              barre;
   datetime          prima;
   datetime          ultima;
   string            anniVuoti;
   string            esito;
  };

//+------------------------------------------------------------------+
//|  utilita' minime                                                  |
//+------------------------------------------------------------------+
string Trim(const string s)
  {
   string t=s;
   StringTrimLeft(t);
   StringTrimRight(t);
   return(t);
  }

ENUM_TIMEFRAMES TFDaNome(const string nome,bool &ok)
  {
   ok=true;
   string n=Trim(nome);
   StringToUpper(n);
   if(n=="M1")  return(PERIOD_M1);
   if(n=="M5")  return(PERIOD_M5);
   if(n=="M15") return(PERIOD_M15);
   if(n=="M30") return(PERIOD_M30);
   if(n=="H1")  return(PERIOD_H1);
   if(n=="H4")  return(PERIOD_H4);
   if(n=="D1")  return(PERIOD_D1);
   ok=false;
   return(PERIOD_H1);
  }

int Anno(const datetime t)
  {
   MqlDateTime d;
   TimeToStruct(t,d);
   return(d.year);
  }

//+------------------------------------------------------------------+
//|  IL CONTEGGIO VERO                                                |
//|  Si legge a BLOCCHI: sedici anni di M15 sono ~400.000 barre e     |
//|  chiedere tutto in un colpo solo e' un modo di far cadere il      |
//|  terminale senza dire perche'.                                    |
//+------------------------------------------------------------------+
bool ContaSerie(const string sym,const ENUM_TIMEFRAMES tf,RigaEXT &r)
  {
   r.barre=0;
   r.prima=0;
   r.ultima=0;
   r.anniVuoti="";
   r.esito="";

//--- 1. la serie va SVEGLIATA: sul simbolo custom appena importato
//       la prima CopyRates puo' tornare -1 mentre MT5 costruisce.
   MqlRates prova[];
   int tent=0;
   int got=-1;
   while(tent<InpAttesaSec)
     {
      got=CopyRates(sym,tf,0,1,prova);
      if(got>0)
         break;
      Sleep(1000);
      tent++;
     }
   if(got<=0)
     {
      r.esito="NESSUNA BARRA (serie non disponibile dopo "+IntegerToString(tent)+" s)";
      return(false);
     }
   r.ultima=prova[0].time;

//--- 2. quante barre dice il terminale
   long tot=(long)Bars(sym,tf);
   if(tot<=0)
     {
      r.esito="Bars() = 0 (ma una barra si legge: serie in costruzione, riprova)";
      return(false);
     }
   r.barre=tot;

//--- 3. scorsa a blocchi, contando per anno
   int annoMin=99999,annoMax=0;
   int cont[];
   ArrayResize(cont,200);      // indice = anno - 1900, tetto 2099
   ArrayInitialize(cont,0);

   const int BLOCCO=50000;
   long letti=0;
   MqlRates rate[];
   while(letti<tot)
     {
      int quanti=(int)MathMin((long)BLOCCO,tot-letti);
      int n=CopyRates(sym,tf,(int)letti,quanti,rate);
      if(n<=0)
        {
         // NON e' un dettaglio: vuol dire che il terminale non ci da'
         // tutta la serie che dice di avere. Si dichiara e ci si ferma.
         r.esito="LETTURA INTERROTTA a "+IntegerToString((int)letti)+
                 " barre su "+IntegerToString((int)tot)+" (CopyRates ha reso "+IntegerToString(n)+")";
         r.barre=letti;
         break;
        }
      for(int i=0;i<n;i++)
        {
         int a=Anno(rate[i].time);
         int idx=a-1900;
         if(idx>=0 && idx<200)
           {
            cont[idx]++;
            if(a<annoMin) annoMin=a;
            if(a>annoMax) annoMax=a;
           }
         if(r.prima==0 || rate[i].time<r.prima) r.prima=rate[i].time;
         if(rate[i].time>r.ultima)              r.ultima=rate[i].time;
        }
      letti+=n;
     }

//--- 4. gli anni VUOTI dentro l'intervallo: dichiarati, mai silenziosi
   if(annoMax>=annoMin)
     {
      for(int a=annoMin;a<=annoMax;a++)
        {
         if(cont[a-1900]==0)
            r.anniVuoti+=(r.anniVuoti==""?"":" ")+IntegerToString(a);
        }
     }

//--- 5. il canarino del tetto (checklist 36)
   if(r.esito=="")
     {
      if(InpTettoAtteso>0 && (long)tot==(long)InpTettoAtteso)
         r.esito="ATTENZIONE: barre = ESATTAMENTE il tetto ("+IntegerToString(InpTettoAtteso)+
                 "). Non e' il dato, e' 'Max barre nel grafico'. Mettilo a ILLIMITATO e rileggi.";
      else if(r.anniVuoti!="")
         r.esito="ANNI VUOTI: "+r.anniVuoti;
      else
         r.esito="OK";
     }

//--- 6. la tabella per anno finisce nella scheda Esperti (il CSV tiene
//       il riassunto: una riga per serie, o diventa illeggibile)
   PrintFormat("   %s %s : %d barre, dal %s al %s",
               sym,EnumToString(tf),(int)r.barre,
               TimeToString(r.prima,TIME_DATE|TIME_MINUTES),
               TimeToString(r.ultima,TIME_DATE|TIME_MINUTES));
   for(int a=annoMin;a<=annoMax && annoMax>=annoMin;a++)
      PrintFormat("      %d: %d barre%s",a,cont[a-1900],(cont[a-1900]==0?"   <-- ANNO VUOTO":""));

   return(true);
  }

//+------------------------------------------------------------------+
//|  AUTOTEST: quello che si puo' provare senza dati                  |
//+------------------------------------------------------------------+
int AutoTest()
  {
   int rotti=0;
   bool ok=false;
   if(TFDaNome("M15",ok)!=PERIOD_M15 || !ok) { Print("[AUTOTEST] ROTTO: M15"); rotti++; }
   if(TFDaNome("h1",ok)!=PERIOD_H1  || !ok)  { Print("[AUTOTEST] ROTTO: h1 minuscolo"); rotti++; }
   TFDaNome("PIPPO",ok);
   if(ok)                                    { Print("[AUTOTEST] ROTTO: un TF inventato doveva fallire"); rotti++; }
   if(Trim("  ciao  ")!="ciao")              { Print("[AUTOTEST] ROTTO: Trim"); rotti++; }
   if(Anno(D'2020.03.16 12:00')!=2020)       { Print("[AUTOTEST] ROTTO: Anno()"); rotti++; }
   PrintFormat("[AUTOTEST] %d ROTTI",rotti);
   return(rotti);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   Print("=== ABTG_ContaBarreEXT (CONTA-EXT-v1) ===");
   PrintFormat("letto il %s (ora del server)",TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS));

   if(InpAutoTest)
     {
      // ramo che ESCE (checklist 26 punto 2): l'autotest non deve essere
      // "un pezzo di strada", o non si sa piu' cosa ha girato davvero.
      AutoTest();
      Print("MODO AUTOTEST: NON e' stato letto nessun simbolo, NESSUN referto scritto.");
      return;
     }

//--- le due liste
   string sym[],tfn[];
   int nsym=StringSplit(InpSimboli,',',sym);
   int ntf =StringSplit(InpTF,',',tfn);
   if(nsym<=0 || ntf<=0)
     {
      Print("!! InpSimboli o InpTF vuoti: non ho niente da contare.");
      return;
     }

//--- il file si apre PRIMA: un referto che nasce solo se tutto va bene
//    e' un referto che non c'e' proprio quando serve.
   int fh=FileOpen(InpFileCsv,FILE_WRITE|FILE_CSV|FILE_ANSI,',');
   if(fh==INVALID_HANDLE)
     {
      PrintFormat("!! non riesco a scrivere MQL5\\Files\\%s (errore %d)",InpFileCsv,GetLastError());
      return;
     }
   FileWrite(fh,"Simbolo","Timeframe","Barre","PrimaBarra","UltimaBarra","AnniVuoti","Esito");

   int problemi=0;
   for(int i=0;i<nsym;i++)
     {
      string s=Trim(sym[i]);
      if(s=="")
         continue;

      //--- il simbolo esiste? Se no, la riga si scrive LO STESSO.
      bool custom=false;
      bool esiste=SymbolExist(s,custom);
      if(!esiste)
        {
         for(int k=0;k<ntf;k++)
            FileWrite(fh,s,Trim(tfn[k]),"0","-","-","-","SIMBOLO NON ESISTE (import non fatto, o MT5 chiuso male dopo l'import)");
         PrintFormat("!! %s: NON ESISTE. Se l'import c'e' stato, e' la chiusura sporca di MT5: le barre si salvano, la registrazione del simbolo no.",s);
         problemi++;
         continue;
        }
      if(!SymbolSelect(s,true))
         PrintFormat("   %s: SymbolSelect ha fallito (errore %d): provo a leggere lo stesso.",s,GetLastError());

      for(int k=0;k<ntf;k++)
        {
         bool tfok=false;
         ENUM_TIMEFRAMES tf=TFDaNome(tfn[k],tfok);
         if(!tfok)
           {
            FileWrite(fh,s,Trim(tfn[k]),"0","-","-","-","TIMEFRAME NON RICONOSCIUTO");
            problemi++;
            continue;
           }
         RigaEXT r;
         r.simbolo=s;
         r.tf=EnumToString(tf);
         bool letto=ContaSerie(s,tf,r);
         FileWrite(fh,s,r.tf,IntegerToString((int)r.barre),
                   (r.prima==0?"-":TimeToString(r.prima,TIME_DATE|TIME_MINUTES)),
                   (r.ultima==0?"-":TimeToString(r.ultima,TIME_DATE|TIME_MINUTES)),
                   (r.anniVuoti==""?"-":r.anniVuoti),
                   r.esito);
         if(!letto || r.esito!="OK")
            problemi++;
        }
     }

   FileClose(fh);
   Print("---------------------------------------------------------------");
   PrintFormat("REFERTO: MQL5\\Files\\%s   -- righe con problemi: %d",InpFileCsv,problemi);
   if(problemi>0)
      Print("ESITO: CON PROBLEMI -- leggi la colonna Esito, riga per riga.");
   else
      Print("ESITO: OK");
   Print("PROMEMORIA: i dati _EXT sono di un ALTRO broker e servono SOLO come");
   Print("PROVA DI REGIME a parametri CONGELATI. Qui non si tara niente.");
  }
//+------------------------------------------------------------------+
