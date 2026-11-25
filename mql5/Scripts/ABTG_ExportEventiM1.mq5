//+------------------------------------------------------------------+
//|                                    ABTG_ExportEventiM1.mq5       |
//|  v1.00 (01/11/2026) -- SOLA LETTURA. NON COMPILATA da agenti.    |
//|  NESSUNA funzione di trading: esporta le barre M1 di un ELENCO   |
//|  di simboli su un ELENCO di finestre (ora del SERVER), un file   |
//|  per simbolo e finestra, nella cartella Common\Files:            |
//|    ABTG_EV_<SIMBOLO>_<ANNO>.csv   (finestra di un anno)          |
//|    ABTG_EV_<SIMBOLO>.csv          (finestra lunga, oltre 400     |
//|                                    giorni: es. 2025.01-2026.10)  |
//|  Formato di ogni riga IDENTICO a ABTG_ExportM1 (oro):            |
//|    time;open;high;low;close;tickvol;spread                       |
//|  Prima di esportare scrive ABTG_SIMBOLI_BCM.txt con TUTTI i      |
//|  simboli che il broker offre e la mappatura voce -> simbolo      |
//|  scelto (o NON TROVATO). A fine corsa scrive                     |
//|  ABTG_EV_FINE.txt con un riepilogo per file. Durante la    |
//|  corsa aggiorna ABTG_EV_PROGRESSO.txt.                           |
//|  Logica di esportazione = ABTG_ExportM1 v1.01: CopyRates a       |
//|  settimane con ritentativi. TerminalClose SOLO se                |
//|  InpChiudiTerminale=true (lancio automatico).                    |
//|                                                                  |
//|  ELENCO SIMBOLI: voci separate da virgola; ogni voce puo avere   |
//|  alias separati da | e si usa il PRIMO che il broker offre.      |
//|  ELENCO FINESTRE: da-a separate da virgola, date AAAA.MM.GG,     |
//|  la data finale e ESCLUSA, ora del server (es. 2013.01.01-       |
//|  2014.01.01).                                                    |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpSimboli  = "EURUSD,GBPUSD,USDJPY"; // voci (alias con |)
input string InpFinestre = "2013.01.01-2014.01.01,2014.01.01-2015.01.01,2015.01.01-2016.01.01,2016.01.01-2017.01.01,2017.01.01-2018.01.01,2018.01.01-2019.01.01,2019.01.01-2020.01.01,2020.01.01-2021.01.01,2021.01.01-2022.01.01,2022.01.01-2023.01.01,2023.01.01-2024.01.01,2024.01.01-2025.01.01,2025.01.01-2026.01.01,2026.01.01-2026.11.21"; // finestre da-a (a esclusa)
input bool   InpChiudiTerminale = false;   // true SOLO nel lancio automatico

#define F_SIMBOLI   "ABTG_SIMBOLI_BCM.txt"
#define F_FINE      "ABTG_EV_FINE.txt"
#define F_PROGRESSO "ABTG_EV_PROGRESSO.txt"

// finestre valide
datetime g_d0[];
datetime g_d1[];
string   g_da[];
string   g_a[];
string   g_suf[];
// avanzamento
string   g_prog[];
string   g_nomi_usati[];

// ELENCO EVENTI (ora server BCM, GMT+1 fisso): conferenze stampa BCE e FOMC dal calendario abtg_news_hist_G8 (195)
string g_evtxt =
  "2013.01.10 14:30,2013.02.07 14:30,2013.03.07 14:30,2013.04.04 13:30,2013.05.02 13:30,2013.06.06 13:30,2013.07.04 13:30,2013.08.01 13:30,2013.09.05 13:30,2013.10.02 13:30,2013.11.07 14:30,2013.12.05 14:30,2014.01.09 14:30,2014.02.06 14:30,2014.03.06 14:30,2014.04.03 13:30,2014.05.08 13:30,2014.06.05 13:30,2014.07.03 13:30,2014.08.07 13:30,"
  +"2014.09.04 13:30,2014.10.02 13:30,2014.11.06 14:30,2014.12.04 14:30,2015.01.22 14:30,2015.03.05 14:30,2015.04.15 13:30,2015.06.03 13:30,2015.07.16 13:30,2015.09.03 13:30,2015.10.22 13:30,2015.12.03 14:30,2016.01.21 14:30,2016.03.10 14:30,2016.04.21 13:30,2016.06.02 13:30,2016.06.15 19:30,2016.07.21 13:30,2016.09.08 13:30,2016.09.21 19:30,"
  +"2016.10.20 13:30,2016.12.08 14:30,2016.12.14 20:30,2017.01.19 14:30,2017.03.09 14:30,2017.03.15 19:30,2017.04.27 13:30,2017.06.08 13:30,2017.06.14 19:30,2017.07.20 13:30,2017.09.07 13:30,2017.09.20 19:30,2017.10.26 13:30,2017.12.13 20:30,2017.12.14 14:30,2018.01.25 14:30,2018.03.08 14:30,2018.03.21 19:30,2018.04.26 13:30,2018.06.13 19:30,"
  +"2018.06.14 13:30,2018.07.26 13:30,2018.09.13 13:30,2018.09.26 19:30,2018.10.25 13:30,2018.12.13 14:30,2018.12.19 20:30,2019.01.24 14:30,2019.01.30 20:30,2019.03.07 14:30,2019.03.20 19:30,2019.04.10 13:30,2019.05.01 19:30,2019.06.06 13:30,2019.06.19 19:30,2019.07.25 13:30,2019.07.31 19:30,2019.09.12 13:30,2019.09.18 19:30,2019.10.24 13:30,"
  +"2019.10.30 19:30,2019.12.11 20:30,2019.12.12 14:30,2020.01.23 14:30,2020.01.29 20:30,2020.03.03 17:00,2020.03.12 14:30,2020.03.15 23:30,2020.04.29 19:30,2020.04.30 13:30,2020.06.04 13:30,2020.06.10 19:30,2020.07.16 13:30,2020.07.29 19:30,2020.09.10 13:30,2020.09.16 19:30,2020.10.29 14:30,2020.11.05 20:30,2020.12.10 14:30,2020.12.16 20:30,"
  +"2021.01.21 14:30,2021.01.27 20:30,2021.03.11 14:30,2021.03.17 19:30,2021.04.22 13:30,2021.04.28 19:30,2021.06.10 13:30,2021.06.16 19:30,2021.07.22 13:30,2021.07.28 19:30,2021.09.09 13:30,2021.09.22 19:30,2021.10.28 13:30,2021.11.03 19:30,2021.12.15 20:30,2021.12.16 14:30,2022.01.26 20:30,2022.02.03 14:30,2022.03.10 14:30,2022.03.16 19:30,"
  +"2022.04.14 13:30,2022.05.04 19:30,2022.06.09 13:30,2022.06.15 19:30,2022.07.21 13:30,2022.07.27 19:30,2022.09.08 13:30,2022.09.21 19:30,2022.10.27 13:30,2022.11.02 19:30,2022.12.14 20:30,2022.12.15 14:30,2023.02.01 20:30,2023.02.02 14:45,2023.03.16 14:45,2023.03.22 19:30,2023.05.03 19:30,2023.05.04 13:45,2023.06.14 19:30,2023.06.15 13:45,"
  +"2023.07.26 19:30,2023.07.27 13:45,2023.09.14 13:45,2023.09.20 19:30,2023.10.26 13:45,2023.11.01 19:30,2023.12.13 20:30,2023.12.14 14:45,2024.01.25 14:45,2024.01.31 20:30,2024.03.07 14:45,2024.03.20 19:30,2024.04.11 13:45,2024.05.01 19:30,2024.06.06 13:45,2024.06.12 19:30,2024.07.18 13:45,2024.07.31 19:30,2024.09.12 13:45,2024.09.18 19:30,"
  +"2024.10.17 13:45,2024.11.07 20:30,2024.12.12 14:45,2024.12.18 20:30,2025.01.29 14:45,2025.01.29 20:30,2025.01.30 14:45,2025.03.06 14:45,2025.03.19 19:30,2025.04.17 13:45,2025.05.07 19:30,2025.06.05 13:45,2025.06.18 19:30,2025.07.24 13:45,2025.07.30 19:30,2025.09.11 13:45,2025.09.17 19:30,2025.10.29 19:30,2025.10.30 14:45,2025.12.10 20:30,"
  +"2025.12.18 14:45,2026.01.28 20:30,2026.02.05 14:45,2026.03.18 19:30,2026.03.19 14:45,2026.04.29 19:30,2026.04.30 13:45,2026.06.11 13:45,2026.06.17 19:30,2026.07.23 13:45,2026.07.29 19:30,2026.09.10 13:45,2026.09.16 19:30,2026.10.28 19:30,2026.10.29 14:45,";
datetime g_ev[];
int g_i0=0;
#define PRE_SEC  3600
#define POST_SEC 25200
void CaricaEventi()
  {
   string p[]; int n=StringSplit(g_evtxt,',',p); ArrayResize(g_ev,0);
   for(int i=0;i<n;i++){ if(StringLen(p[i])<10) continue; int k=ArraySize(g_ev); ArrayResize(g_ev,k+1); g_ev[k]=StringToTime(p[i]); }
   PrintFormat("EVENTI caricati: %d",ArraySize(g_ev));
  }
bool EventoInIntervallo(datetime a,datetime b)
  {
   for(int i=0;i<ArraySize(g_ev);i++) if(g_ev[i]+POST_SEC>=a && g_ev[i]-PRE_SEC<b) return true;
   return false;
  }
bool InEvento(datetime t)
  {
   int n=ArraySize(g_ev);
   while(g_i0<n && g_ev[g_i0]+POST_SEC<t) g_i0++;
   return (g_i0<n && t>=g_ev[g_i0]-PRE_SEC);
  }

//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringTrimLeft(s);
   StringTrimRight(s);
   return s;
  }

//+------------------------------------------------------------------+
// nome adatto a un file: lettere, cifre, _ . - #; il resto diventa _
string NomeFile(string s)
  {
   int n=StringLen(s);
   for(int i=0;i<n;i++)
     {
      ushort c=StringGetCharacter(s,i);
      bool ok=(c>='A' && c<='Z') || (c>='a' && c<='z') || (c>='0' && c<='9') || c=='_' || c=='.' || c=='-' || c=='#';
      if(!ok) StringSetCharacter(s,i,'_');
     }
   return s;
  }

//+------------------------------------------------------------------+
// AAAA.MM.GG
bool DataValida(const string s)
  {
   if(StringLen(s)!=10) return false;
   for(int i=0;i<10;i++)
     {
      ushort c=StringGetCharacter(s,i);
      if(i==4 || i==7) { if(c!='.') return false; }
      else if(c<'0' || c>'9') return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
void Accoda(string &lista[],const string x)
  {
   int n=ArraySize(lista);
   ArrayResize(lista,n+1);
   lista[n]=x;
  }

//+------------------------------------------------------------------+
bool GiaUsato(const string x)
  {
   for(int i=0;i<ArraySize(g_nomi_usati);i++)
      if(g_nomi_usati[i]==x) return true;
   return false;
  }

//+------------------------------------------------------------------+
// il simbolo e nell elenco COMPLETO del broker (non solo Market Watch)?
// ritorna il nome esatto del broker (maiuscole del broker)
bool NelElenco(const string nome,string &esatto)
  {
   int tot=SymbolsTotal(false);
   for(int i=0;i<tot;i++)
     {
      string n=SymbolName(i,false);
      if(StringCompare(n,nome,false)==0)
        {
         esatto=n;
         return true;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
// prova gli alias di una voce nell ordine; ritorna il simbolo scelto o ""
string Risolvi(const string voce,string &provati)
  {
   string parti[];
   provati="";
   int n=StringSplit(voce,'|',parti);
   for(int i=0;i<n;i++)
     {
      string a=Pulisci(parti[i]);
      if(StringLen(a)==0) continue;
      if(StringLen(provati)>0) provati+="|";
      provati+=a;
      string esatto="";
      if(NelElenco(a,esatto) && SymbolSelect(esatto,true))
         return esatto;
     }
   return "";
  }

//+------------------------------------------------------------------+
// aspetta (fino a ~15 s) che le barre M1 del simbolo siano sincronizzate
bool Sincronizza(const string sim)
  {
   for(int k=0;k<30;k++)
     {
      if((bool)SeriesInfoInteger(sim,PERIOD_M1,SERIES_SYNCHRONIZED)) return true;
      Sleep(500);
     }
   return false;
  }

//+------------------------------------------------------------------+
// riscrive il file di avanzamento con tutte le righe finora
void ScriviProgresso()
  {
   int h=FileOpen(F_PROGRESSO,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(h==INVALID_HANDLE) return;
   for(int i=0;i<ArraySize(g_prog);i++)
      FileWriteString(h,g_prog[i]+"\r\n");
   FileClose(h);
  }

//+------------------------------------------------------------------+
// legge InpFinestre; riempie le finestre valide; ritorna il testo del problema ("" se tutto ok)
string LeggiFinestre()
  {
   string problemi="";
   string voci[];
   int n=StringSplit(InpFinestre,',',voci);
   for(int i=0;i<n;i++)
     {
      string v=Pulisci(voci[i]);
      if(StringLen(v)==0) continue;
      string p[];
      int m=StringSplit(v,'-',p);
      if(m!=2)
        {
         problemi+="finestra '"+v+"' scartata (formato atteso AAAA.MM.GG-AAAA.MM.GG); ";
         continue;
        }
      string da=Pulisci(p[0]);
      string a=Pulisci(p[1]);
      if(!DataValida(da) || !DataValida(a))
        {
         problemi+="finestra '"+v+"' scartata (data non valida); ";
         continue;
        }
      datetime d0=StringToTime(da+" 00:00");
      datetime d1=StringToTime(a+" 00:00");
      if(d0<=0 || d1<=d0)
        {
         problemi+="finestra '"+v+"' scartata (la fine deve seguire l inizio); ";
         continue;
        }
      // suffisso: anno di inizio per le finestre fino a 400 giorni, niente per quelle lunghe
      string suf="";
      if(d1-d0<=400*86400)
        {
         MqlDateTime st;
         TimeToStruct(d0,st);
         suf="_"+IntegerToString(st.year);
        }
      // se il suffisso e gia preso da un altra finestra, uso la data di inizio compatta
      bool doppio=false;
      for(int j=0;j<ArraySize(g_suf);j++)
         if(g_suf[j]==suf) doppio=true;
      if(doppio)
        {
         string compatta=da;
         StringReplace(compatta,".","");
         suf="_"+compatta;
        }
      int k=ArraySize(g_d0);
      ArrayResize(g_d0,k+1);
      ArrayResize(g_d1,k+1);
      ArrayResize(g_da,k+1);
      ArrayResize(g_a,k+1);
      ArrayResize(g_suf,k+1);
      g_d0[k]=d0;
      g_d1[k]=d1;
      g_da[k]=da;
      g_a[k]=a;
      g_suf[k]=suf;
     }
   return problemi;
  }

//+------------------------------------------------------------------+
// esporta le barre M1 di `sim` fra d0 e d1 nel file `nome`; ritorna la riga di riepilogo
string Esporta(const string sim,const string da,const string a,const datetime d0,const datetime d1,const string nome)
  {
   int dig=(int)SymbolInfoInteger(sim,SYMBOL_DIGITS);
   datetime primo_server=(datetime)SeriesInfoInteger(sim,PERIOD_M1,SERIES_SERVER_FIRSTDATE);
   int h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   long totale=0; g_i0=0;
   datetime primo=0, ultimo=0;
   int settimane_vuote=0, errori=0;
   if(h==INVALID_HANDLE)
     {
      PrintFormat("EXPORT: impossibile aprire %s, err=%d",nome,GetLastError());
      errori++;
     }
   else
     {
      FileWriteString(h,"time;open;high;low;close;tickvol;spread\r\n");
      datetime cur=d0;
      while(cur<d1)
        {
         datetime nxt=cur+7*86400;
         if(nxt>d1) nxt=d1;
         if(!EventoInIntervallo(cur,nxt)){ cur=nxt; continue; }
         MqlRates r[];
         int got=-1;
         for(int k=0;k<40;k++)
           {
            ResetLastError();
            got=CopyRates(sim,PERIOD_M1,cur,nxt-1,r);
            if(got>0) break;
            if(got==0 && k>=3) break;     // settimana senza barre (weekend, festivi, storico assente)
            Sleep(500);
           }
         if(got>0)
           {
            long kept=0; datetime pk=0, uk=0;
            for(int i=0;i<got;i++)
              {
               if(!InEvento(r[i].time)) continue;
               string riga=TimeToString(r[i].time,TIME_DATE|TIME_MINUTES)+";"+DoubleToString(r[i].open,dig)+";"+DoubleToString(r[i].high,dig)+";"+DoubleToString(r[i].low,dig)+";"+DoubleToString(r[i].close,dig)+";"+IntegerToString((long)r[i].tick_volume)+";"+IntegerToString(r[i].spread)+"\r\n";
               FileWriteString(h,riga);
               kept++; if(pk==0) pk=r[i].time; uk=r[i].time;
              }
            totale+=kept;
            if(primo==0 && pk>0) primo=pk;
            if(uk>0) ultimo=uk;
           }
         else if(got==0) settimane_vuote++;
         else
           {
            errori++;
            PrintFormat("EXPORT: CopyRates fallita su %s dal %s, err=%d",sim,TimeToString(cur),GetLastError());
           }
         cur=nxt;
        }
      FileClose(h);
     }
   string s=StringFormat("%s simbolo=%s finestra=%s..%s righe=%I64d prima=%s ultima=%s settimane_vuote=%d errori=%d primo_dato_server=%s",
                         nome,sim,da,a,totale,TimeToString(primo),TimeToString(ultimo),settimane_vuote,errori,TimeToString(primo_server));
   PrintFormat("EXPORT %s",s);
   return s;
  }

//+------------------------------------------------------------------+
void Chiudi()
  {
   if(InpChiudiTerminale)
     {
      Sleep(2000);
      TerminalClose(0);
     }
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   Print("ABTG_ExportEventiM1 v1.00: SOLA LETTURA, nessun ordine.");
   CaricaEventi();
   string problemi=LeggiFinestre();

   // 1) elenco completo del broker + mappatura delle voci
   string voci[];
   int nv=StringSplit(InpSimboli,',',voci);
   string scelti[];
   string mappa[];
   for(int i=0;i<nv;i++)
     {
      string voce=Pulisci(voci[i]);
      if(StringLen(voce)==0) continue;
      string provati="";
      string sim=Risolvi(voce,provati);
      if(StringLen(sim)==0)
         Accoda(mappa,voce+"  ->  NON TROVATO (provati: "+provati+")");
      else
        {
         bool dup=false;
         for(int j=0;j<ArraySize(scelti);j++)
            if(scelti[j]==sim) dup=true;
         if(dup)
            Accoda(mappa,voce+"  ->  "+sim+"  (gia scelto da un altra voce: esportato una volta sola)");
         else
           {
            Accoda(mappa,voce+"  ->  "+sim);
            Accoda(scelti,sim);
           }
        }
     }

   int hs=FileOpen(F_SIMBOLI,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hs!=INVALID_HANDLE)
     {
      int tot=SymbolsTotal(false);
      FileWriteString(hs,"ABTG_ExportEventiM1 v1.00 -- elenco simboli del broker "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n");
      FileWriteString(hs,"server="+AccountInfoString(ACCOUNT_SERVER)+"  azienda="+AccountInfoString(ACCOUNT_COMPANY)+"\r\n");
      FileWriteString(hs,"MAPPATURA voce -> simbolo scelto:\r\n");
      for(int i=0;i<ArraySize(mappa);i++)
         FileWriteString(hs,"  "+mappa[i]+"\r\n");
      FileWriteString(hs,"FINESTRE valide: "+IntegerToString(ArraySize(g_d0))+"\r\n");
      for(int i=0;i<ArraySize(g_d0);i++)
         FileWriteString(hs,"  "+g_da[i]+" .. "+g_a[i]+"  (a esclusa)  suffisso file='"+g_suf[i]+"'\r\n");
      if(StringLen(problemi)>0)
         FileWriteString(hs,"PROBLEMI sulle finestre: "+problemi+"\r\n");
      FileWriteString(hs,"SIMBOLI OFFERTI DAL BROKER: "+IntegerToString(tot)+"  (nome;descrizione;percorso)\r\n");
      for(int i=0;i<tot;i++)
        {
         string n=SymbolName(i,false);
         FileWriteString(hs,n+";"+SymbolInfoString(n,SYMBOL_DESCRIPTION)+";"+SymbolInfoString(n,SYMBOL_PATH)+"\r\n");
        }
      FileClose(hs);
     }
   else
      PrintFormat("EXPORT: impossibile scrivere %s, err=%d",F_SIMBOLI,GetLastError());

   // 2) esportazione: un file per simbolo e finestra
   string riepilogo[];
   int fatti=0;
   int previsti=ArraySize(scelti)*ArraySize(g_d0);
   for(int i=0;i<ArraySize(scelti);i++)
     {
      string sim=scelti[i];
      bool sinc=Sincronizza(sim);
      if(!sinc)
         Accoda(riepilogo,"ATTENZIONE: "+sim+" non risulta sincronizzato dopo 15 s: provo comunque (i ritentativi di CopyRates lo aspettano)");
      for(int w=0;w<ArraySize(g_d0);w++)
        {
         string nome="ABTG_EV_"+NomeFile(sim)+g_suf[w]+".csv";
         if(GiaUsato(nome))
           {
            Accoda(riepilogo,"SALTATO "+nome+": nome gia usato in questa corsa");
            continue;
           }
         Accoda(g_nomi_usati,nome);
         string r=Esporta(sim,g_da[w],g_a[w],g_d0[w],g_d1[w],nome);
         Accoda(riepilogo,r);
         fatti++;
         Accoda(g_prog,TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+" file "+IntegerToString(fatti)+" di "+IntegerToString(previsti)+": "+r);
         ScriviProgresso();
        }
     }

   // 3) file di fine con il riepilogo
   int hf=FileOpen(F_FINE,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hf!=INVALID_HANDLE)
     {
      FileWriteString(hf,"FINE "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n");
      FileWriteString(hf,"file previsti="+IntegerToString(previsti)+" scritti="+IntegerToString(fatti)+"\r\n");
      FileWriteString(hf,"MAPPATURA:\r\n");
      for(int i=0;i<ArraySize(mappa);i++)
         FileWriteString(hf,"  "+mappa[i]+"\r\n");
      if(StringLen(problemi)>0)
         FileWriteString(hf,"PROBLEMI sulle finestre: "+problemi+"\r\n");
      if(ArraySize(scelti)==0)
         FileWriteString(hf,"NESSUN simbolo trovato: niente da esportare.\r\n");
      if(ArraySize(g_d0)==0)
         FileWriteString(hf,"NESSUNA finestra valida: niente da esportare.\r\n");
      FileWriteString(hf,"RIEPILOGO PER FILE:\r\n");
      for(int i=0;i<ArraySize(riepilogo);i++)
         FileWriteString(hf,riepilogo[i]+"\r\n");
      FileClose(hf);
     }
   Chiudi();
  }
