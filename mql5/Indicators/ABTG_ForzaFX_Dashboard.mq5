//+------------------------------------------------------------------+
//|                                   ABTG_ForzaFX_Dashboard.mq5     |
//|  Dashboard di SOLA VISIONE (nessun ordine, nessuna rete, nessun  |
//|  file, nessun accesso al conto):                                 |
//|  - MATRICE coppie x 9 TF (M1..MN): per ogni cella lo STATO della |
//|    candela IN CORSO di quel TF contro la candela precedente      |
//|    (riempimento) e la posizione rispetto all'apertura (bordo);   |
//|  - FORZA delle 8 valute (barre + numero a 2 decimali) con pesi e |
//|    periodo scritti in chiaro;                                    |
//|  - PUNTEGGIO di confluenza per coppia (colonna SEGNALE), le TOP  |
//|    coppie per punteggio e il controllo delle correlazioni.       |
//|  Specifica e scelte dove la fonte era ambigua:                   |
//|  docs/FORZA_FX_SPEC_2026-10-02.md. Collaudo (senza MetaEditor):  |
//|  backtest_pipeline/collaudo_forza_fx.py. NON misura performance, |
//|  NON da' consigli operativi.                                     |
//|                                                                  |
//|  Dati: CopyRates SOLO quando si apre una candela nuova di quel TF|
//|  (a rotazione, con un tetto per secondo), piu' una lettura di 3  |
//|  candele M1 per simbolo ogni InpCorrezioneSec secondi per non    |
//|  perdere gli estremi che il prezzo tocca fra un secondo e l'altro|
//|  (senza, una rottura respinta in mezzo secondo resterebbe        |
//|  invisibile). Fra una candela e l'altra: solo SymbolInfoTick.    |
//|  Una cella senza dati NON si azzera: tiene l'ultimo stato valido.|
//|                                                                  |
//|  Click: simbolo -> D1, cella -> quel TF, riga TOP -> D1, valuta  |
//|  -> filtra la matrice (di nuovo = tutte), titolo -> diagnosi nel |
//|  Journal. Il grafico che ospita la dashboard NON cambia MAI      |
//|  (niente ricarica): si apre/riusa un grafico di lettura separato,|
//|  e se quel grafico ha un EA non si tocca (classe 930); dopo ogni |
//|  apertura si controlla per 10 s che non abbia ereditato un EA dal|
//|  template (classe 951).                                         |
//|  Unico effetto sul terminale: SymbolSelect() aggiunge i simboli  |
//|  della lista al Market Watch (servono i prezzi).                 |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//--- costanti generali
#define FFX_NTF     9
#define FFX_NVAL    8
#define FFX_MAXSYM  64
//--- stati della cella (spec. sez. 2.2)
#define FFX_S_ND      -1
#define FFX_S_NEUTRO   0
#define FFX_S_UP       1
#define FFX_S_UPBRK    2
#define FFX_S_DN       3
#define FFX_S_DNBRK    4
#define FFX_S_FAILUP   5
#define FFX_S_FAILDN   6
#define FFX_S_FAIL2    7
//--- pesi del punteggio di confluenza (spec. sez. 5)
#define FFX_W_ALLIN   40.0
#define FFX_W_DIFF    30.0
#define FFX_W_ROTT    20.0
#define FFX_W_SAN     10.0
//--- esiti del caricamento di una cella
#define FFX_C_OK       0
#define FFX_C_POCHI    1
#define FFX_C_INDIETRO 2
#define FFX_C_FERIALE  3

input group "Simboli"
input string InpSimboli  = "EURGBP,EURAUD,EURNZD,EURUSD,EURCAD,EURCHF,EURJPY,GBPAUD,GBPNZD,GBPUSD,GBPCAD,GBPCHF,GBPJPY,AUDNZD,AUDUSD,AUDCAD,AUDCHF,AUDJPY,NZDUSD,NZDCAD,NZDCHF,NZDJPY,USDCAD,USDCHF,USDJPY,CADCHF,CADJPY,CHFJPY"; // coppie (nomi BCM, senza suffisso)
input string InpSuffisso = "";      // suffisso del broker aggiunto a OGNI coppia (es. ".m"); vuoto su BCM
input group "Timeframe accesi (uno spento esce anche da forza e confluenza)"
input bool InpUsaM1  = true;
input bool InpUsaM5  = true;
input bool InpUsaM15 = true;
input bool InpUsaM30 = true;
input bool InpUsaH1  = true;
input bool InpUsaH4  = true;
input bool InpUsaD1  = true;
input bool InpUsaW1  = true;
input bool InpUsaMN  = true;
input group "Pesi della forza per TF (guida: 1,1,2,3,4,6,10,15,20 = somma 62)"
input double InpPesoM1  = 1;
input double InpPesoM5  = 1;
input double InpPesoM15 = 2;
input double InpPesoM30 = 3;
input double InpPesoH1  = 4;
input double InpPesoH4  = 6;
input double InpPesoD1  = 10;
input double InpPesoW1  = 15;
input double InpPesoMN  = 20;
input group "Punteggio di confluenza"
input double InpSogliaForte   = 90;  // |punteggio| >= : STRONG BUY / STRONG SELL
input double InpSogliaNormale = 70;  // |punteggio| >= : BUY / SELL
input double InpSogliaDebole  = 40;  // |punteggio| >= : WEAK + / WEAK -
input int    InpTopOpp        = 5;   // righe del pannello TOP (0 = nascosto)
input group "Controllo correlazioni"
input bool            InpMostraSanity = true;
input ENUM_TIMEFRAMES InpSanityTF     = PERIOD_D1; // TF su cui si confrontano le direzioni
input string          InpSanityMappa  = "D30EUR>EURUSD:+,100GBP>GBPUSD:-,225JPY>USDJPY:+,200AUD>AUDUSD:+,USOIL>USDCAD:-"; // STRUMENTO>COPPIA:segno (nome strumento esatto, senza suffisso)
input group "Dati"
input bool InpD1SaltaWeekend = true; // D1: la candela precedente e' l'ultima da lunedi' a venerdi' (classe 1065)
input int  InpCaricaMax      = 40;   // tetto di CopyRates per secondo (candele nuove a rotazione)
input int  InpCorrezioneSec  = 60;   // ogni quanti secondi si rileggono 3 candele M1 per simbolo (0 = mai)
input int  InpDiagMinuti     = 15;   // diagnosi nel Journal ogni N minuti (0 = solo a richiesta)
input group "Aspetto"
input int  InpCellaPx     = 18;   // lato della cella in px a 96 DPI
input int  InpX           = 8;    // distanza dal bordo sinistro (px)
input int  InpY           = 24;   // distanza dal bordo alto (px)
input bool InpRiusaGrafico = true; // i click riusano lo stesso grafico di lettura (mai quello della dashboard)

//--- timeframe e nomi
ENUM_TIMEFRAMES FFX_TF[FFX_NTF]   = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
string          FFX_TFN[FFX_NTF]  = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
string          FFX_VAL[FFX_NVAL] = {"EUR","GBP","AUD","NZD","USD","CAD","CHF","JPY"};
#define FFX_IDX_D1 6

//@@FFX_PURE_BEGIN
//--- stato della candela in corso (spec. 2.2): rottura > doppio fail > fail > sopra/sotto apertura
int FFX_Stato(const double c,const double o0,const double h0,const double l0,const double h1,const double l1)
  {
   if(c>h1) return FFX_S_UPBRK;
   if(c<l1) return FFX_S_DNBRK;
   bool fu=(h0>h1);
   bool fd=(l0<l1);
   if(fu && fd) return FFX_S_FAIL2;
   if(fu) return FFX_S_FAILUP;
   if(fd) return FFX_S_FAILDN;
   if(c>o0) return FFX_S_UP;
   if(c<o0) return FFX_S_DN;
   return FFX_S_NEUTRO;
  }
//--- bordo: +1 sopra l'apertura, -1 sotto, 0 pari
int FFX_Bordo(const double c,const double o0)
  {
   if(c>o0) return 1;
   if(c<o0) return -1;
   return 0;
  }
//--- valore dello stato nella forza (guida p.13); neutro, doppio fail e n/d = 0
double FFX_Valore(const int s)
  {
   switch(s)
     {
      case FFX_S_UPBRK:  return 2.0;
      case FFX_S_UP:     return 1.0;
      case FFX_S_FAILDN: return 0.5;
      case FFX_S_FAILUP: return -0.5;
      case FFX_S_DN:     return -1.0;
      case FFX_S_DNBRK:  return -2.0;
     }
   return 0.0;
  }
//--- direzione per l'allineamento: i fail contano come il verso opposto a quello respinto
double FFX_Dir(const int s)
  {
   if(s==FFX_S_UP || s==FFX_S_UPBRK || s==FFX_S_FAILDN) return 1.0;
   if(s==FFX_S_DN || s==FFX_S_DNBRK || s==FFX_S_FAILUP) return -1.0;
   return 0.0;
  }
//--- contributo alle rotture: solo rotture vere (+-1) e fail (-+0,5); il rialzo/ribasso semplice no
double FFX_Rottura(const int s)
  {
   if(s==FFX_S_UPBRK)  return 1.0;
   if(s==FFX_S_DNBRK)  return -1.0;
   if(s==FFX_S_FAILUP) return -0.5;
   if(s==FFX_S_FAILDN) return 0.5;
   return 0.0;
  }
//--- direzione per il controllo correlazioni: neutro e fail = 0 (MIXED)
int FFX_DirSanity(const int s)
  {
   if(s==FFX_S_UP || s==FFX_S_UPBRK) return 1;
   if(s==FFX_S_DN || s==FFX_S_DNBRK) return -1;
   return 0;
  }
//--- FORZA (guida p.13): base +v*peso, quotata -v*peso; forza = num / den,
//    den = 2 x somma dei pesi delle celle CON DATI (= n_coppie x sumPesi x 2 a copertura piena)
void FFX_Forza(const int &st[],const int ns,const int &base[],const int &quot[],const double &peso[],
               double &num[],double &den[],double &forza[])
  {
   for(int v=0;v<FFX_NVAL;v++)
     {
      num[v]=0.0;
      den[v]=0.0;
      forza[v]=0.0;
     }
   for(int s=0;s<ns;s++)
     {
      int b=base[s];
      int q=quot[s];
      if(b<0 || q<0 || b==q) continue;
      for(int c=0;c<FFX_NTF;c++)
        {
         int x=st[s*FFX_NTF+c];
         if(x==FFX_S_ND || peso[c]<=0.0) continue;
         double val=FFX_Valore(x)*peso[c];
         num[b]+=val;
         num[q]-=val;
         den[b]+=2.0*peso[c];
         den[q]+=2.0*peso[c];
        }
     }
   for(int k=0;k<FFX_NVAL;k++)
      forza[k]=(den[k]>0.0) ? num[k]/den[k] : 0.0;
  }
//--- ordine dalla piu' forte alla piu' debole (stabile: a pari forza vale l'ordine EUR..JPY)
void FFX_Ordina(const double &forza[],const int n,int &ord[])
  {
   for(int i=0;i<n;i++) ord[i]=i;
   for(int i=1;i<n;i++)
     {
      int x=ord[i];
      int j=i-1;
      while(j>=0 && forza[ord[j]]<forza[x])
        {
         ord[j+1]=ord[j];
         j--;
        }
      ord[j+1]=x;
     }
  }
//--- allineamento (media di FFX_Dir sui TF strategici accesi) e rotture (media di FFX_Rottura
//    sui TF accesi). false se manca anche una sola cella accesa.
bool FFX_Componenti(const int &st[],const int off,const int &on[],const int &strat[],double &allin,double &rott)
  {
   int na=0;
   int nb=0;
   double sa=0.0;
   double sb=0.0;
   allin=0.0;
   rott=0.0;
   for(int c=0;c<FFX_NTF;c++)
     {
      if(on[c]==0) continue;
      int x=st[off+c];
      if(x==FFX_S_ND) return false;
      sb+=FFX_Rottura(x);
      nb++;
      if(strat[c]!=0)
        {
         sa+=FFX_Dir(x);
         na++;
        }
     }
   if(nb==0) return false;
   allin=(na>0) ? sa/na : 0.0;
   rott=sb/nb;
   return true;
  }
//--- esito della correlazione: +1 ALIGN, -1 DIVERGE, 0 MIXED / non applicabile
int FFX_Sanity(const int dCoppia,const int dStrum,const int segno)
  {
   if(dCoppia==0 || dStrum==0 || segno==0) return 0;
   return (dCoppia==segno*dStrum) ? 1 : -1;
  }
//--- somma pesata 40/30/20/10 (= la formula della guida "(...)/100*100", senza il giro inutile)
double FFX_Confluenza(const double allin,const double diff,const double rott,const double san)
  {
   return allin*FFX_W_ALLIN+diff*FFX_W_DIFF+rott*FFX_W_ROTT+san*FFX_W_SAN;
  }
//--- punteggio completo di una coppia. sanTF = indice del TF della correlazione (-1 = nessuna);
//    segno = segno atteso (0 = nessuna correlazione per questa coppia)
bool FFX_Punteggio(const int &st[],const int off,const int &on[],const int &strat[],
                   const double fBase,const double fQuot,const int sanTF,const int dStrum,const int segno,
                   double &score,double &allin,double &diff,double &rott,double &san)
  {
   score=0.0;
   diff=0.0;
   san=0.0;
   if(!FFX_Componenti(st,off,on,strat,allin,rott)) return false;
   diff=(fBase-fQuot)/2.0;
   int dC=(sanTF>=0) ? FFX_DirSanity(st[off+sanTF]) : 0;
   san=(double)(FFX_Sanity(dC,dStrum,segno)*dC);
   score=FFX_Confluenza(allin,diff,rott,san);
   return true;
  }
//--- etichetta: decisa sul numero ARROTONDATO (quello che si vede): 3 STRONG BUY .. -3 STRONG SELL
int FFX_Etichetta(const double score,const double forte,const double normale,const double debole)
  {
   double r=MathRound(score);
   if(r>=forte)    return 3;
   if(r>=normale)  return 2;
   if(r>=debole)   return 1;
   if(r<=-forte)   return -3;
   if(r<=-normale) return -2;
   if(r<=-debole)  return -1;
   return 0;
  }
//--- TOP: le topN con |punteggio arrotondato| piu' alto (>= soglia; a pari valore l'ordine
//    della lista), poi in ordine di punteggio con segno decrescente. Ritorna quante.
int FFX_TopOpp(const double &score[],const int &ok[],const int n,const int topN,const double soglia,int &out[])
  {
   int m=0;
   for(int t=0;t<topN;t++)
     {
      int best=-1;
      double bestA=0.0;
      for(int i=0;i<n;i++)
        {
         if(ok[i]==0) continue;
         double a=MathAbs(MathRound(score[i]));
         if(a<soglia) continue;
         bool usata=false;
         for(int j=0;j<m;j++)
            if(out[j]==i) { usata=true; break; }
         if(usata) continue;
         if(best<0 || a>bestA) { best=i; bestA=a; }
        }
      if(best<0) break;
      out[m]=best;
      m++;
     }
   for(int i=1;i<m;i++)
     {
      int x=out[i];
      int j=i-1;
      while(j>=0 && MathRound(score[out[j]])<MathRound(score[x]))
        {
         out[j+1]=out[j];
         j--;
        }
      out[j+1]=x;
     }
   return m;
  }
//--- giorno della settimana (0 = domenica) di un orario server
int FFX_Dow(const long t)
  {
   long d=t/86400;
   int w=(int)((d+4)%7);
   if(w<0) w+=7;
   return w;
  }
//--- indice della candela precedente quella in corso (t crescente, t[n-1] = in corso);
//    con saltaWE si salta sabato e domenica (la candela di un'ora della domenica sera).
//    Classe 1069: se fra le candele lette c'e' un SABATO il simbolo quota tutti i giorni
//    (cripto) e allora ogni giorno conta: lo dicono i dati, non la sessione del broker.
int FFX_PrecFeriale(const datetime &t[],const int n,const bool saltaWE)
  {
   bool sab=false;
   for(int i=0;i<n;i++)
      if(FFX_Dow((long)t[i])==6) sab=true;
   for(int i=n-2;i>=0;i--)
     {
      if(!saltaWE || sab) return i;
      int w=FFX_Dow((long)t[i]);
      if(w>=1 && w<=5) return i;
     }
   return -1;
  }
//--- calendario civile <-> giorni dal 1970 (algoritmo di H. Hinnant, solo interi)
long FFX_GiorniDaCivile(const int anno,const int mese,const int giorno)
  {
   long y=anno;
   if(mese<=2) y--;
   long era=(y>=0 ? y : y-399)/400;
   long yoe=y-era*400;
   long mp=(mese>2) ? mese-3 : mese+9;
   long doy=(153*mp+2)/5+giorno-1;
   long doe=yoe*365+yoe/4-yoe/100+doy;
   return era*146097+doe-719468;
  }
void FFX_CivileDaGiorni(const long z0,int &anno,int &mese,int &giorno)
  {
   long z=z0+719468;
   long era=(z>=0 ? z : z-146096)/146097;
   long doe=z-era*146097;
   long yoe=(doe-doe/1460+doe/36524-doe/146096)/365;
   long doy=doe-(365*yoe+yoe/4-yoe/100);
   long mp=(5*doy+2)/153;
   giorno=(int)(doy-(153*mp+2)/5+1);
   mese=(int)(mp<10 ? mp+3 : mp-9);
   anno=(int)(yoe+era*400+(mese<=2 ? 1 : 0));
  }
//--- apertura della candela SUCCESSIVA (MN: primo giorno del mese dopo, alle 00:00)
datetime FFX_Prossima(const datetime t0,const int tfSec,const bool mensile)
  {
   if(!mensile) return (datetime)((long)t0+tfSec);
   int a=0,m=0,g=0;
   FFX_CivileDaGiorni((long)t0/86400,a,m,g);
   m++;
   if(m>12) { m=1; a++; }
   return (datetime)(FFX_GiorniDaCivile(a,m,1)*86400);
  }
//--- estende massimo/minimo della candela in corso con un prezzo che le appartiene
bool FFX_Estendi(const datetime tt,const double p,const datetime t0,const datetime tNext,double &h0,double &l0)
  {
   if(p<=0.0 || tt<t0 || tt>=tNext) return false;
   bool ch=false;
   if(p>h0) { h0=p; ch=true; }
   if(p<l0) { l0=p; ch=true; }
   return ch;
  }
//--- correzione degli estremi con le candele M1 che stanno DENTRO la candela in corso
bool FFX_CorreggiDaM1(const datetime &mt[],const double &mh[],const double &ml[],const int n,
                      const datetime t0,const datetime tNext,double &h0,double &l0)
  {
   bool ch=false;
   for(int i=0;i<n;i++)
     {
      if(mt[i]<t0 || mt[i]>=tNext) continue;
      if(mh[i]>h0) { h0=mh[i]; ch=true; }
      if(ml[i]<l0) { l0=ml[i]; ch=true; }
     }
   return ch;
  }
//--- un passo del timer per UNA cella: 2 = da (ri)caricare (mai caricata o candela nuova),
//    1 = prezzo/estremi cambiati, 0 = niente. Il tick di un'altra candela non tocca niente.
int FFX_PassoTick(const datetime tt,const double bid,const bool caricata,const datetime t0,const datetime tNext,
                  double &h0,double &l0,double &cl)
  {
   if(!caricata) return 2;
   if(tt>=tNext) return 2;
   if(bid<=0.0 || tt<t0) return 0;
   bool ch=FFX_Estendi(tt,bid,t0,tNext,h0,l0);
   if(bid!=cl) { cl=bid; ch=true; }
   return ch ? 1 : 0;
  }
//--- dai dati di CopyRates (crescenti, l'ultima = in corso) ai livelli della cella.
//    Esito: FFX_C_OK, _POCHI (meno di 2 candele), _INDIETRO (l'ultimo tick sta oltre la
//    candela copiata: la serie non e' ancora aggiornata), _FERIALE (nessuna precedente feriale).
//    Se l'esito non e' OK i livelli NON si toccano (la cella tiene l'ultimo stato valido).
int FFX_DaRates(const datetime &t[],const double &o[],const double &h[],const double &l[],const double &c[],
                const int got,const datetime tTick,const int tfSec,const bool mensile,const bool d1Feriale,
                datetime &t0,datetime &tNext,double &o0,double &h0,double &l0,double &cl,double &h1,double &l1)
  {
   if(got<2) return FFX_C_POCHI;
   int last=got-1;
   datetime tn=FFX_Prossima(t[last],tfSec,mensile);
   if(tTick>0 && tTick>=tn) return FFX_C_INDIETRO;
   int ip=d1Feriale ? FFX_PrecFeriale(t,got,true) : last-1;
   if(ip<0) return FFX_C_FERIALE;
   t0=t[last];
   tNext=tn;
   o0=o[last];
   h0=h[last];
   l0=l[last];
   cl=c[last];
   h1=h[ip];
   l1=l[ip];
   return FFX_C_OK;
  }
//--- quali celle caricare in questo giro: al massimo 'budget', a rotazione da 'rot',
//    solo quelle che servono e non sono in attesa di un nuovo tentativo
int FFX_Pianifica(const int &serve[],const long &dopo[],const int n,const int rot,const int budget,
                  const long now,int &out[],int &rotOut)
  {
   int m=0;
   rotOut=rot;
   if(n<=0) return 0;
   for(int j=0;j<n && m<budget;j++)
     {
      int k=(rot+j)%n;
      if(serve[k]!=0 && dopo[k]<=now)
        {
         out[m]=k;
         m++;
         rotOut=(k+1)%n;
        }
     }
   return m;
  }
//--- testi della diagnosi (il valore numerico dello stato, "?" = cella senza dati)
string FFX_TestoStato(const int s)
  {
   switch(s)
     {
      case FFX_S_UPBRK:  return "+2";
      case FFX_S_UP:     return "+1";
      case FFX_S_FAILDN: return "+0.5";
      case FFX_S_FAILUP: return "-0.5";
      case FFX_S_DN:     return "-1";
      case FFX_S_DNBRK:  return "-2";
      case FFX_S_ND:     return "?";
     }
   return "0";
  }
string FFX_RigaCoppia(const string sym,const int &st[],const int off)
  {
   string r=sym+"[";
   for(int c=0;c<FFX_NTF;c++)
     {
      if(c>0) r+=",";
      r+=FFX_TestoStato(st[off+c]);
     }
   return r+"]";
  }
//--- numero col segno esplicito; -0.0 (es. MathRound(-0.3)) diventa +0, mai "+-0"
string FFX_Segnato(const double x,const int dg)
  {
   double y=x+0.0;
   string s=DoubleToString(y,dg);
   if(StringSubstr(s,0,1)!="-") s="+"+s;
   return s;
  }
//--- caricamento completo di una cella: livelli da CopyRates + il prezzo di questo giro se sta
//    nella candela appena caricata. Se l'esito non e' OK i livelli NON si toccano.
int FFX_Carica(const datetime &t[],const double &o[],const double &h[],const double &l[],const double &c[],
               const int got,const datetime tTick,const double bid,const int tfSec,const bool mensile,const bool d1Feriale,
               datetime &t0,datetime &tNext,double &o0,double &h0,double &l0,double &cl,double &h1,double &l1)
  {
   datetime a0=0,an=0;
   double ao=0.0,ah=0.0,al=0.0,ac=0.0,ah1=0.0,al1=0.0;
   int e=FFX_DaRates(t,o,h,l,c,got,tTick,tfSec,mensile,d1Feriale,a0,an,ao,ah,al,ac,ah1,al1);
   if(e!=FFX_C_OK) return e;
   if(tTick>=a0 && tTick<an && bid>0.0)
     {
      FFX_Estendi(tTick,bid,a0,an,ah,al);
      ac=bid;
     }
   t0=a0; tNext=an; o0=ao; h0=ah; l0=al; cl=ac; h1=ah1; l1=al1;
   return FFX_C_OK;
  }
//--- stato e bordo di una cella dai suoi livelli; true se uno dei due e' cambiato
bool FFX_StatoCella(const double cl,const double o0,const double h0,const double l0,const double h1,const double l1,
                    int &st,int &bo)
  {
   int s2=FFX_Stato(cl,o0,h0,l0,h1,l1);
   int b2=FFX_Bordo(cl,o0);
   bool ch=(s2!=st || b2!=bo);
   st=s2;
   bo=b2;
   return ch;
  }
//--- valute dalle prime 6 lettere del nome (il suffisso non conta). false (e -1,-1) se non sono
//    due DIVERSE fra le 8: la coppia resta in matrice ma fuori dalla forza
bool FFX_ValuteDaNome(const string nome,const string &val[],int &b,int &q)
  {
   b=-1;
   q=-1;
   if(StringLen(nome)<6) return false;
   string sb=StringSubstr(nome,0,3);
   string sq=StringSubstr(nome,3,3);
   for(int i=0;i<FFX_NVAL;i++)
     {
      if(val[i]==sb) b=i;
      if(val[i]==sq) q=i;
     }
   if(b<0 || q<0 || b==q)
     {
      b=-1;
      q=-1;
      return false;
     }
   return true;
  }
//--- una voce di InpSanityMappa, "STRUMENTO>COPPIA:+" (spazi ignorati); false se scritta male
bool FFX_ParseCorrelazione(const string voce,string &strum,string &coppia,int &segno)
  {
   strum="";
   coppia="";
   segno=0;
   string v=voce;
   StringReplace(v," ","");
   int a=StringFind(v,">");
   int b=StringFind(v,":");
   int n=StringLen(v);
   if(a<=0 || b<=a+1 || b!=n-2) return false;
   string sg=StringSubstr(v,b+1,1);
   if(sg=="+") segno=1;
   else if(sg=="-") segno=-1;
   else return false;
   strum=StringSubstr(v,0,a);
   coppia=StringSubstr(v,a+1,b-a-1);
   return true;
  }
//--- tutto il ricalcolo di un giro: forza, ordine, esiti delle correlazioni, punteggi, TOP.
//    st[] contiene ns coppie e poi ni strumenti di correlazione (FFX_NTF celle ciascuno).
int FFX_RicalcolaTutto(const int &st[],const int ns,const int ni,const int &base[],const int &quot[],const double &peso[],
                       const int &on[],const int &strat[],const int sanTF,const int &sanCoppia[],const int &sanSegno[],
                       const int &coppiaSan[],const int topN,const double soglia,
                       double &num[],double &den[],double &forza[],int &ord[],int &sanEsito[],
                       double &score[],double &al[],double &df[],double &ro[],double &sa[],int &scOk[],int &top[])
  {
   FFX_Forza(st,ns,base,quot,peso,num,den,forza);
   FFX_Ordina(forza,FFX_NVAL,ord);
   for(int i=0;i<ni;i++)
     {
      int dS=(sanTF>=0) ? FFX_DirSanity(st[(ns+i)*FFX_NTF+sanTF]) : 0;
      int dC=(sanTF>=0) ? FFX_DirSanity(st[sanCoppia[i]*FFX_NTF+sanTF]) : 0;
      sanEsito[i]=FFX_Sanity(dC,dS,sanSegno[i]);
     }
   for(int s=0;s<ns;s++)
     {
      score[s]=0.0;
      al[s]=0.0;
      df[s]=0.0;
      ro[s]=0.0;
      sa[s]=0.0;
      scOk[s]=0;
      int b=base[s];
      int q=quot[s];
      if(b<0 || q<0) continue;
      int ii=coppiaSan[s];
      int dS=0,sg=0,sTF=-1;
      if(ii>=0 && sanTF>=0)
        {
         dS=FFX_DirSanity(st[(ns+ii)*FFX_NTF+sanTF]);
         sg=sanSegno[ii];
         sTF=sanTF;
        }
      double x1=0.0,x2=0.0,x3=0.0,x4=0.0,x5=0.0;
      bool ok=FFX_Punteggio(st,s*FFX_NTF,on,strat,forza[b],forza[q],sTF,dS,sg,x1,x2,x3,x4,x5);
      scOk[s]=ok ? 1 : 0;
      score[s]=x1;
      al[s]=x2;
      df[s]=x3;
      ro[s]=x4;
      sa[s]=x5;
     }
   int tn=(topN<0) ? 0 : topN;
   if(tn>ns) tn=ns;
   return FFX_TopOpp(score,scOk,ns,tn,soglia,top);
  }
//--- click: nome dell'oggetto SENZA prefisso -> azione. 1 simbolo (D1), 2 cella (a=coppia, b=TF),
//    3 riga TOP (a=posizione), 4 correlazione (a=strumento), 5 valuta (a=riga del pannello),
//    6 titolo (diagnosi), 0 = nessuna azione
int FFX_LeggiClick(const string body,int &a,int &b)
  {
   a=-1;
   b=-1;
   if(body=="tit") return 6;
   int p1=StringFind(body,"_");
   if(p1<=0) return 0;
   string tipo=StringSubstr(body,0,p1);
   string resto=StringSubstr(body,p1+1);
   if(StringLen(resto)==0) return 0;
   int p2=StringFind(resto,"_");
   a=(int)StringToInteger((p2<0) ? resto : StringSubstr(resto,0,p2));
   if(p2>=0) b=(int)StringToInteger(StringSubstr(resto,p2+1));
   if(tipo=="s" || tipo=="gb" || tipo=="gt") return 1;
   if(tipo=="c") return (p2>=0) ? 2 : 0;
   if(tipo=="to") return 3;
   if(tipo=="sr") return 4;
   if(tipo=="fv" || tipo=="fb" || tipo=="fn") return 5;
   return 0;
  }
//--- numero della forza come si vede nel pannello: due decimali, segno, virgola
string FFX_TestoForza(const double f)
  {
   string s=FFX_Segnato(f,2);
   StringReplace(s,".",",");
   return s;
  }
//--- riga visibile col filtro valuta (-1 = tutte): la valuta come base O come quotata
bool FFX_RigaVisibile(const int b,const int q,const int filtro)
  {
   if(filtro<0) return true;
   return (b==filtro || q==filtro);
  }
//--- barra della forza dall'asse zero xz: larghezza |f| x meta (minimo 1 px). true = positiva
//    (si disegna a DESTRA dell'asse, in verde), false = negativa (a SINISTRA, in rosso)
bool FFX_Barra(const double f,const int xz,const int meta,int &x,int &w)
  {
   w=(int)MathRound(MathAbs(f)*meta);
   if(w<1) w=1;
   bool pos=(f>=0.0);
   x=pos ? xz : xz-w;
   return pos;
  }
string FFX_TestoEtichetta(const int e)
  {
   switch(e)
     {
      case 3:  return "STRONG BUY";
      case 2:  return "BUY";
      case 1:  return "WEAK +";
      case -1: return "WEAK -";
      case -2: return "SELL";
      case -3: return "STRONG SELL";
     }
   return "";
  }
//--- testo della colonna SEGNALE: etichetta (se c'e') e numero ARROTONDATO col segno
string FFX_TestoSegnale(const double score,const double forte,const double normale,const double debole)
  {
   int e=FFX_Etichetta(score,forte,normale,debole);
   string lab=FFX_TestoEtichetta(e);
   string num=FFX_Segnato(MathRound(score),0);
   if(lab=="") return num;
   return lab+" "+num;
  }
string FFX_TestoEsito(const int e)
  {
   if(e>0) return "ALIGN";
   if(e<0) return "DIVERGE";
   return "MIXED";
  }
//--- celle con dati sulle celle attive delle prime ns coppie
void FFX_Copertura(const int &st[],const int &attiva[],const int ns,int &cov,int &tot)
  {
   cov=0;
   tot=0;
   for(int k=0;k<ns*FFX_NTF;k++)
     {
      if(attiva[k]==0) continue;
      tot++;
      if(st[k]!=FFX_S_ND) cov++;
     }
  }
//--- riga "somma" della diagnosi: la somma delle forze e se i denominatori sono tutti uguali
string FFX_RigaSomma(const double &forza[],const double &den[])
  {
   double somma=0.0;
   bool uguali=true;
   for(int v=0;v<FFX_NVAL;v++)
     {
      somma+=forza[v];
      if(den[v]!=den[0]) uguali=false;
     }
   return "somma forze="+FFX_Segnato(somma,6)+" denominatori uguali="+(uguali ? "si" : "no")+
          " (somma zero attesa solo con denominatori uguali)";
  }
//--- click sulla riga 'riga' del pannello forza: filtra la valuta che sta IN QUELLA RIGA
//    (l'ordine cambia col mercato), lo stesso click di nuovo = tutte
int FFX_FiltroDopoClick(const int filtro,const int &ord[],const int riga)
  {
   if(riga<0 || riga>=FFX_NVAL) return filtro;
   int v=ord[riga];
   return (filtro==v) ? -1 : v;
  }
//--- per ogni coppia l'indice dello strumento di correlazione che la riguarda (-1 = nessuno)
void FFX_CollegaCorrelazioni(const int &sanCoppia[],const int ni,const int ns,int &coppiaSan[])
  {
   for(int s=0;s<ns;s++) coppiaSan[s]=-1;
   for(int i=0;i<ni;i++)
      if(sanCoppia[i]>=0 && sanCoppia[i]<ns) coppiaSan[sanCoppia[i]]=i;
  }
//--- l'ID di un grafico supera 2^53 e un double (GlobalVariable) non lo tiene esatto: si salva in
//    due meta' da 32 bit. Divisione intera, niente maschere esadecimali (il tipo del letterale
//    0xFFFFFFFF in MQL5 non e' verificabile qui)
void FFX_MetaDaId(const long id,double &hi,double &lo)
  {
   ulong u=(ulong)id;
   ulong b=(ulong)4294967296;
   hi=(double)(u/b);
   lo=(double)(u%b);
  }
long FFX_IdDaMeta(const double hi,const double lo)
  {
   ulong b=(ulong)4294967296;
   ulong h=(ulong)hi;
   ulong l=(ulong)lo;
   return (long)(h*b+l);
  }
//--- diagnosi: la riga di 'perRiga' coppie si stampa quando e' piena O all'ultima coppia
bool FFX_FineRiga(const int nr,const int s,const int ns,const int perRiga)
  {
   return (nr>=perRiga || s==ns-1);
  }
//@@FFX_PURE_END

//+------------------------------------------------------------------+
//| Stato globale                                                     |
//+------------------------------------------------------------------+
string   P="FFX_";
int      gNS=0;              // coppie della matrice
int      gNI=0;              // strumenti della correlazione (dopo le coppie)
int      gNT=0;              // gNS+gNI
string   gNome[];            // nome senza suffisso (mostrato)
string   gSym[];             // nome completo usato col terminale
int      gBase[],gQuot[];    // indici valuta (-1 = non riconosciuta)
bool     gSymOk[];
long     gSymRetry[];
int      gDig[];
double   gBid[];
datetime gTick[];
long     gCorrNext[];
//--- correlazioni: per strumento i (slot gNS+i)
int      gSanCoppia[];       // indice della coppia nella matrice
int      gSanSegno[];
//--- per coppia: indice dello strumento correlato (-1 nessuno)
int      gCoppiaSan[];
//--- celle (slot s, TF c): k = s*FFX_NTF+c
int      gServe[];           // 1 = la cella va caricata (attiva)
bool     gCar[];             // caricata almeno una volta
datetime gT0[],gNext[];
double   gO0[],gH0[],gL0[],gCl[],gH1[],gL1[];
long     gDopo[];            // ms: non ritentare prima di
string   gNd[];              // motivo dell'ultimo caricamento fallito ("" = ok)
int      gSt[];              // stato (FFX_S_ND = mai calcolato)
int      gBo[];
string   gStDa[];            // ora del cambio di stato (per il tooltip)
int      gAttiva[];          // la cella esiste (TF acceso / TF della correlazione)
//--- TF
int      gOn[FFX_NTF];
int      gStrat[FFX_NTF];
double   gPeso[FFX_NTF];
double   gSumPesi=0.0;
int      gSanTF=-1;
//--- risultati
double   gNum[FFX_NVAL],gDen[FFX_NVAL],gForza[FFX_NVAL];
int      gOrd[FFX_NVAL];
double   gScore[],gAl[],gDf[],gRo[],gSa[];
int      gScOk[];
int      gTop[];
int      gNTop=0;
int      gSanEsito[];        // per strumento
//--- giro
int      gRot=0;
int      gLoadBuf[];
int      gCopie=0,gCopieDiag=0;
bool     gDirty=true;
bool     gCompleta=false;
datetime gDiagNext=0;
string   gUltimoCambio="-";
//--- impaginazione
double   gK=1.0;
int      gFiltro=-1;         // valuta filtrata (-1 = tutte)
string   gLayoutKey="";
int      gXz=0;              // x dell'asse zero delle barre di forza
//--- cache dei colori/testi gia' scritti (niente ObjectSet se non cambia)
color    gCF[],gCB[];
string   gCT[];
string   gGT[],gGTip[];
color    gGC[];
string   gFxT[];
//--- grafico di lettura
long     gVisore=0;
long     gWatchId=0;
long     gWatchFino=0;
string   gWatchSym="";

//+------------------------------------------------------------------+
//| Utilita'                                                         |
//+------------------------------------------------------------------+
string Trim(string s)
  {
   StringTrimLeft(s);
   StringTrimRight(s);
   return s;
  }
int TfIdx(const ENUM_TIMEFRAMES tf)
  {
   ENUM_TIMEFRAMES t=(tf==PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)_Period : tf;
   for(int c=0;c<FFX_NTF;c++)
      if(FFX_TF[c]==t) return c;
   return -1;
  }
string NomeStato(const int s)
  {
   switch(s)
     {
      case FFX_S_UPBRK:  return "UP_BREAK (+2) - chiude sopra il massimo precedente";
      case FFX_S_UP:     return "UP (+1) - sopra l'apertura, dentro il range precedente";
      case FFX_S_FAILDN: return "FAIL_DN (+0,5) - ha rotto il minimo precedente ed e' rientrato";
      case FFX_S_FAILUP: return "FAIL_UP (-0,5) - ha rotto il massimo precedente ed e' rientrato";
      case FFX_S_DN:     return "DN (-1) - sotto l'apertura, dentro il range precedente";
      case FFX_S_DNBRK:  return "DN_BREAK (-2) - chiude sotto il minimo precedente";
      case FFX_S_FAIL2:  return "FAIL doppio (0) - ha rotto massimo E minimo precedenti ed e' rientrato";
      case FFX_S_NEUTRO: return "NEUTRO (0) - prezzo uguale all'apertura";
     }
   return "nessun dato";
  }
color ColoreStato(const int s)
  {
   switch(s)
     {
      case FFX_S_UPBRK:  return C'22,163,74';     // #16A34A verde scuro
      case FFX_S_UP:     return C'34,197,94';     // #22C55E verde chiaro
      case FFX_S_DN:     return C'239,68,68';     // #EF4444 rosso chiaro
      case FFX_S_DNBRK:  return C'185,28,28';     // #B91C1C rosso scuro
      case FFX_S_FAILUP: return C'28,28,28';      // #1C1C1C nero
      case FFX_S_FAILDN: return C'107,114,128';   // #6B7280 grigio
      case FFX_S_FAIL2:  return clrDimGray;
      case FFX_S_NEUTRO: return clrWhite;
     }
   return C'255,243,196';                         // senza dati: giallo pallido
  }
color ColoreBordo(const int b,const int s)
  {
   if(s==FFX_S_ND) return clrSilver;
   if(b>0) return C'34,197,94';
   if(b<0) return C'239,68,68';
   return clrSilver;
  }
color ColoreEtichetta(const int e)
  {
   switch(e)
     {
      case 3:  return C'22,163,74';
      case 2:  return C'34,197,94';
      case 1:  return C'139,148,158';
      case -1: return C'139,148,158';
      case -2: return C'239,68,68';
      case -3: return C'185,28,28';
     }
   return C'236,236,236';
  }
long OraMs()
  {
   return (long)GetTickCount64();
  }

//+------------------------------------------------------------------+
//| Stato persistente (GlobalVariable per grafico): filtro e grafico |
//| di lettura. L'ID del grafico e' oltre 2^53: si salva in 2 meta'. |
//+------------------------------------------------------------------+
string GvKey(const string w)
  {
   return "FFX_"+IntegerToString(ChartID())+"_"+w;
  }
void GvSave(const string w,const double v)
  {
   if(GlobalVariableSet(GvKey(w),v)==0)
      Print("[ForzaFX] GlobalVariableSet fallita (",w,"), errore ",GetLastError(),": lo stato non sopravvivera' a una ricarica.");
  }
double GvGet(const string w,const double def)
  {
   string k=GvKey(w);
   if(!GlobalVariableCheck(k)) return def;
   return GlobalVariableGet(k);
  }
void SalvaVisore()
  {
   double hi=0.0, lo=0.0;
   FFX_MetaDaId(gVisore,hi,lo);
   GvSave("vis_hi",hi);
   GvSave("vis_lo",lo);
  }
bool GraficoEsiste(const long id)
  {
   if(id<=0) return false;
   long c=ChartFirst();
   int guard=0;
   while(c>=0 && guard<1000)
     {
      if(c==id) return true;
      c=ChartNext(c);
      guard++;
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- TF accesi, pesi, TF strategici (H4, D1, W1, MN)
   bool usa[FFX_NTF];
   usa[0]=InpUsaM1; usa[1]=InpUsaM5; usa[2]=InpUsaM15; usa[3]=InpUsaM30; usa[4]=InpUsaH1;
   usa[5]=InpUsaH4; usa[6]=InpUsaD1; usa[7]=InpUsaW1; usa[8]=InpUsaMN;
   double pw[FFX_NTF];
   pw[0]=InpPesoM1; pw[1]=InpPesoM5; pw[2]=InpPesoM15; pw[3]=InpPesoM30; pw[4]=InpPesoH1;
   pw[5]=InpPesoH4; pw[6]=InpPesoD1; pw[7]=InpPesoW1; pw[8]=InpPesoMN;
   gSumPesi=0.0;
   int nOn=0;
   for(int c=0;c<FFX_NTF;c++)
     {
      gOn[c]=usa[c] ? 1 : 0;
      gStrat[c]=(c>=5) ? 1 : 0;
      gPeso[c]=(usa[c] && pw[c]>0.0) ? pw[c] : 0.0;
      gSumPesi+=gPeso[c];
      if(usa[c]) nOn++;
     }
   if(nOn==0)
     {
      Print("[ForzaFX] nessun timeframe acceso: accendine almeno uno.");
      return INIT_PARAMETERS_INCORRECT;
     }
   //--- coppie
   string parts[];
   int np=StringSplit(InpSimboli,',',parts);
   gNS=0;
   string nomi[];
   ArrayResize(nomi,0);
   for(int i=0;i<np;i++)
     {
      string n=Trim(parts[i]);
      if(n=="") continue;
      bool dup=false;
      for(int j=0;j<gNS;j++) if(nomi[j]==n) dup=true;
      if(dup) { Print("[ForzaFX] ",n," ripetuto nella lista: tenuto una volta."); continue; }
      if(gNS>=FFX_MAXSYM) { Print("[ForzaFX] piu' di ",FFX_MAXSYM," coppie: le altre sono ignorate."); break; }
      ArrayResize(nomi,gNS+1);
      nomi[gNS]=n;
      gNS++;
     }
   if(gNS==0)
     {
      Print("[ForzaFX] lista simboli vuota.");
      return INIT_PARAMETERS_INCORRECT;
     }
   //--- strumenti della correlazione
   string snomi[];
   int    scop[],sseg[];
   ArrayResize(snomi,0); ArrayResize(scop,0); ArrayResize(sseg,0);
   gNI=0;
   gSanTF=-1;
   if(InpMostraSanity)
     {
      gSanTF=TfIdx(InpSanityTF);
      if(gSanTF<0 || gOn[gSanTF]==0)
        {
         Print("[ForzaFX] correlazioni: il TF ",EnumToString(InpSanityTF)," non e' fra i 9 accesi: controllo correlazioni SPENTO.");
         gSanTF=-1;
        }
     }
   string voci[];
   int nv=(gSanTF>=0) ? StringSplit(InpSanityMappa,',',voci) : 0;
   for(int i=0;i<nv;i++)
     {
      string v=Trim(voci[i]);
      if(v=="") continue;
      string st="", cp="";
      int seg=0;
      if(!FFX_ParseCorrelazione(v,st,cp,seg)) { Print("[ForzaFX] correlazione '",v,"' scritta male (serve STRUMENTO>COPPIA:+ o :-): ignorata."); continue; }
      int idx=-1;
      for(int j=0;j<gNS;j++) if(nomi[j]==cp) idx=j;
      if(idx<0) { Print("[ForzaFX] correlazione '",v,"': la coppia ",cp," non e' nella lista: ignorata."); continue; }
      ArrayResize(snomi,gNI+1); ArrayResize(scop,gNI+1); ArrayResize(sseg,gNI+1);
      snomi[gNI]=st; scop[gNI]=idx; sseg[gNI]=seg;
      gNI++;
     }
   gNT=gNS+gNI;
   //--- array per simbolo
   ArrayResize(gNome,gNT); ArrayResize(gSym,gNT); ArrayResize(gBase,gNT); ArrayResize(gQuot,gNT);
   ArrayResize(gSymOk,gNT); ArrayResize(gSymRetry,gNT); ArrayResize(gDig,gNT); ArrayResize(gBid,gNT);
   ArrayResize(gTick,gNT); ArrayResize(gCorrNext,gNT);
   ArrayResize(gSanCoppia,gNI); ArrayResize(gSanSegno,gNI); ArrayResize(gSanEsito,gNI);
   ArrayResize(gCoppiaSan,gNS);
   for(int s=0;s<gNT;s++)
     {
      if(s<gNS)
        {
         gNome[s]=nomi[s];
         gSym[s]=nomi[s]+InpSuffisso;
         int vb=-1, vq=-1;
         if(!FFX_ValuteDaNome(nomi[s],FFX_VAL,vb,vq))
            Print("[ForzaFX] ",nomi[s],": le prime 6 lettere non sono due delle 8 valute: in matrice ma FUORI dalla forza.");
         gBase[s]=vb;
         gQuot[s]=vq;
        }
      else
        {
         int i=s-gNS;
         gNome[s]=snomi[i];
         gSym[s]=snomi[i];             // nome esatto, senza suffisso (indici/materie prime)
         gBase[s]=-1; gQuot[s]=-1;
         gSanCoppia[i]=scop[i];
         gSanSegno[i]=sseg[i];
         gSanEsito[i]=0;
        }
      ResetLastError();
      gSymOk[s]=SymbolSelect(gSym[s],true);
      if(!gSymOk[s])
         Print("[ForzaFX] ",gSym[s]," non trovato su questo terminale (errore ",GetLastError(),"). ",
               (s<gNS ? "Se il broker usa un suffisso (es. EURUSD.m), scrivilo in InpSuffisso." : "Correlazione: resta MIXED."));
      gSymRetry[s]=OraMs();
      gDig[s]=(int)SymbolInfoInteger(gSym[s],SYMBOL_DIGITS);
      gBid[s]=0.0;
      gTick[s]=0;
      gCorrNext[s]=OraMs()+(long)(s%60)*1000;   // correzioni M1 sparse sul minuto
     }
   FFX_CollegaCorrelazioni(gSanCoppia,gNI,gNS,gCoppiaSan);
   //--- celle
   int nc=gNT*FFX_NTF;
   ArrayResize(gServe,nc); ArrayResize(gCar,nc); ArrayResize(gT0,nc); ArrayResize(gNext,nc);
   ArrayResize(gO0,nc); ArrayResize(gH0,nc); ArrayResize(gL0,nc); ArrayResize(gCl,nc);
   ArrayResize(gH1,nc); ArrayResize(gL1,nc); ArrayResize(gDopo,nc); ArrayResize(gNd,nc);
   ArrayResize(gSt,nc); ArrayResize(gBo,nc); ArrayResize(gStDa,nc); ArrayResize(gAttiva,nc);
   ArrayResize(gLoadBuf,nc);
   ArrayResize(gCF,nc); ArrayResize(gCB,nc); ArrayResize(gCT,nc);
   for(int k=0;k<nc;k++)
     {
      int s=k/FFX_NTF, c=k%FFX_NTF;
      gAttiva[k]=(s<gNS) ? gOn[c] : ((c==gSanTF) ? 1 : 0);
      gServe[k]=0; gCar[k]=false; gT0[k]=0; gNext[k]=0;
      gO0[k]=0; gH0[k]=0; gL0[k]=0; gCl[k]=0; gH1[k]=0; gL1[k]=0;
      gDopo[k]=0; gNd[k]="in attesa del primo caricamento"; gSt[k]=FFX_S_ND; gBo[k]=0; gStDa[k]="";
      gCF[k]=clrNONE; gCB[k]=clrNONE; gCT[k]="";
     }
   ArrayResize(gScore,gNS); ArrayResize(gAl,gNS); ArrayResize(gDf,gNS); ArrayResize(gRo,gNS); ArrayResize(gSa,gNS);
   ArrayResize(gScOk,gNS); ArrayResize(gTop,gNS); ArrayResize(gGT,gNS); ArrayResize(gGTip,gNS); ArrayResize(gGC,gNS);
   ArrayInitialize(gScOk,0);
   for(int s=0;s<gNS;s++) { gGT[s]="#init#"; gGTip[s]="#init#"; gGC[s]=clrNONE; gScore[s]=0; }
   ArrayResize(gFxT,5+3*FFX_NVAL+gNS+gNI+1);
   for(int i=0;i<ArraySize(gFxT);i++) gFxT[i]="#init#";
   for(int v=0;v<FFX_NVAL;v++) { gNum[v]=0; gDen[v]=0; gForza[v]=0; gOrd[v]=v; }
   //--- stato persistente
   gFiltro=(int)GvGet("filtro",-1.0);
   if(gFiltro<-1 || gFiltro>=FFX_NVAL) gFiltro=-1;
   gVisore=FFX_IdDaMeta(GvGet("vis_hi",0.0),GvGet("vis_lo",0.0));
   if(!GraficoEsiste(gVisore) || gVisore==ChartID()) gVisore=0;
   //--- grafica
   gK=(double)TerminalInfoInteger(TERMINAL_SCREEN_DPI)/96.0;
   if(gK<1.0) gK=1.0;
   CreaOggetti();
   gLayoutKey="";
   Layout();
   gDiagNext=TimeLocal()+(datetime)(InpDiagMinuti>0 ? InpDiagMinuti*60 : 0);
   if(!EventSetTimer(1))
      Print("[ForzaFX] EventSetTimer fallito (errore ",GetLastError(),"): la dashboard non si aggiornera'.");
   Print("[ForzaFX] avvio: ",gNS," coppie, ",gNI," strumenti di correlazione, TF accesi ",nOn,
         ", pesi ",TestoPesi(),". Periodo: la candela IN CORSO di ogni TF (oggi per D1, la settimana per W1, il mese per MN).");
   ChartRedraw(0);
   return INIT_SUCCEEDED;
  }
string TestoPesi()
  {
   string t="";
   for(int c=0;c<FFX_NTF;c++)
     {
      if(gOn[c]==0) continue;
      if(t!="") t+=" ";
      t+=FFX_TFN[c]+"="+DoubleToString(gPeso[c],(gPeso[c]==MathRound(gPeso[c])) ? 0 : 2);
     }
   return t+" (somma "+DoubleToString(gSumPesi,(gSumPesi==MathRound(gSumPesi)) ? 0 : 2)+")";
  }
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0,P);
   if(reason==REASON_REMOVE)
     {
      GlobalVariableDel(GvKey("filtro"));
      GlobalVariableDel(GvKey("vis_hi"));
      GlobalVariableDel(GvKey("vis_lo"));
     }
   ChartRedraw(0);
  }
int OnCalculate(const int rates_total,const int prev_calculated,const int begin,const double &price[])
  {
   return rates_total;      // tutto il lavoro e' nel timer: il grafico ospite non serve
  }

//+------------------------------------------------------------------+
//| TIMER: tick -> stati; candele nuove -> CopyRates a rotazione;    |
//| correzione estremi M1; ricalcolo e ridisegno SOLO se cambia.     |
//+------------------------------------------------------------------+
void OnTimer()
  {
   bool redraw=false;
   long now=OraMs();
   ControllaGraficoNuovo(now);
   //--- 1) prezzi: un SymbolInfoTick per simbolo, poi le sue celle
   for(int s=0;s<gNT;s++)
     {
      if(!gSymOk[s])
        {
         if(now-gSymRetry[s]>=60000)
           {
            gSymOk[s]=SymbolSelect(gSym[s],true);       // ritenta una volta al minuto
            gSymRetry[s]=now;
            if(gSymOk[s]) gDig[s]=(int)SymbolInfoInteger(gSym[s],SYMBOL_DIGITS);
           }
         if(!gSymOk[s])
           {
            for(int c=0;c<FFX_NTF;c++)
              {
               int k=s*FFX_NTF+c;
               if(gAttiva[k]!=0) gNd[k]="simbolo non trovato su questo terminale";
              }
            continue;
           }
        }
      MqlTick tk;
      if(SymbolInfoTick(gSym[s],tk) && tk.bid>0.0)
        {
         gBid[s]=tk.bid;
         gTick[s]=tk.time;
        }
      for(int c=0;c<FFX_NTF;c++)
        {
         int k=s*FFX_NTF+c;
         if(gAttiva[k]==0) continue;
         double h0=gH0[k], l0=gL0[k], cl=gCl[k];
         int r=FFX_PassoTick(gTick[s],gBid[s],gCar[k],gT0[k],gNext[k],h0,l0,cl);
         gServe[k]=(r==2) ? 1 : 0;
         if(r==1)
           {
            gH0[k]=h0; gL0[k]=l0; gCl[k]=cl;
            AggiornaStato(k);
           }
        }
     }
   //--- 2) candele nuove: CopyRates solo per le celle che lo chiedono, al massimo InpCaricaMax
   int budget=(InpCaricaMax<1) ? 1 : InpCaricaMax;
   int nl=FFX_Pianifica(gServe,gDopo,gNT*FFX_NTF,gRot,budget,now,gLoadBuf,gRot);
   for(int j=0;j<nl;j++)
      CaricaCella(gLoadBuf[j],now);
   //--- 3) correzione degli estremi con 3 candele M1 (al massimo 2 simboli per secondo)
   if(InpCorrezioneSec>0)
     {
      int fatte=0;
      for(int s=0;s<gNT && fatte<2;s++)
        {
         if(!gSymOk[s] || now<gCorrNext[s]) continue;
         CorreggiSimbolo(s);
         gCorrNext[s]=now+(long)InpCorrezioneSec*1000;
         fatte++;
        }
     }
   //--- 4) ricalcolo e disegno solo se qualcosa e' cambiato
   if(gDirty)
     {
      Ricalcola();
      if(Disegna()) redraw=true;
      gDirty=false;
     }
   //--- 5) diagnosi
   int cov=0,tot=0;
   Copertura(cov,tot);
   if(!gCompleta && tot>0 && cov==tot)
     {
      gCompleta=true;
      DiagStampa("prima copertura completa");
     }
   if(InpDiagMinuti>0 && TimeLocal()>=gDiagNext)
     {
      DiagStampa("periodica");
      gDiagNext=TimeLocal()+(datetime)(InpDiagMinuti*60);
     }
   if(redraw) ChartRedraw(0);
  }
//--- ricalcola stato e bordo di una cella dai suoi livelli; segna il cambio
void AggiornaStato(const int k)
  {
   int st=gSt[k], bo=gBo[k];
   int prima=st;
   if(FFX_StatoCella(gCl[k],gO0[k],gH0[k],gL0[k],gH1[k],gL1[k],st,bo))
     {
      if(st!=prima) gStDa[k]=TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS);
      gSt[k]=st;
      gBo[k]=bo;
      gDirty=true;
      gUltimoCambio=TimeToString(TimeCurrent(),TIME_SECONDS);
     }
  }
//--- carica una cella (candela in corso + precedente). Se i dati non sono pronti la cella
//    TIENE il suo stato (non si azzera) e si ritenta piu' tardi.
void CaricaCella(const int k,const long now)
  {
   int s=k/FFX_NTF, c=k%FFX_NTF;
   ENUM_TIMEFRAMES tf=FFX_TF[c];
   bool d1=(c==FFX_IDX_D1 && InpD1SaltaWeekend);
   int nb=d1 ? 7 : 2;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   ResetLastError();
   int got=CopyRates(gSym[s],tf,0,nb,r);
   gCopie++;
   int err=GetLastError();
   if(got<0) got=0;
   datetime t[]; double o[],h[],l[],cc[];
   ArrayResize(t,got); ArrayResize(o,got); ArrayResize(h,got); ArrayResize(l,got); ArrayResize(cc,got);
   for(int i=0;i<got;i++) { t[i]=r[i].time; o[i]=r[i].open; h[i]=r[i].high; l[i]=r[i].low; cc[i]=r[i].close; }
   datetime t0=0, tn=0;
   double o0=0, h0=0, l0=0, cl=0, h1=0, l1=0;
   int e=FFX_Carica(t,o,h,l,cc,got,gTick[s],gBid[s],PeriodSeconds(tf),(tf==PERIOD_MN1),d1,
                    t0,tn,o0,h0,l0,cl,h1,l1);
   if(e!=FFX_C_OK)
     {
      string why;
      if(e==FFX_C_POCHI)    why="CopyRates ha dato "+IntegerToString(got)+" candele (errore "+IntegerToString(err)+"): storico non ancora scaricato";
      else if(e==FFX_C_INDIETRO) why="la serie non contiene ancora la candela dell'ultimo tick";
      else why="nessuna candela feriale precedente nelle ultime "+IntegerToString(got);
      gNd[k]=why+" (stato precedente mantenuto)";
      gDopo[k]=now+((e==FFX_C_INDIETRO) ? 1000 : 5000);
      return;
     }
   gT0[k]=t0; gNext[k]=tn; gO0[k]=o0; gH0[k]=h0; gL0[k]=l0; gCl[k]=cl; gH1[k]=h1; gL1[k]=l1;
   gCar[k]=true;
   gServe[k]=0;
   gDopo[k]=0;
   gNd[k]="";
   gCT[k]="#init#";            // tooltip da riscrivere (livelli nuovi)
   AggiornaStato(k);
   gDirty=true;
  }
//--- 3 candele M1: gli estremi toccati fra un secondo e l'altro rientrano nelle celle del simbolo
void CorreggiSimbolo(const int s)
  {
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(gSym[s],PERIOD_M1,0,3,r);
   gCopie++;
   if(got<=0) return;
   datetime mt[]; double mh[],ml[];
   ArrayResize(mt,got); ArrayResize(mh,got); ArrayResize(ml,got);
   for(int i=0;i<got;i++) { mt[i]=r[i].time; mh[i]=r[i].high; ml[i]=r[i].low; }
   for(int c=0;c<FFX_NTF;c++)
     {
      int k=s*FFX_NTF+c;
      if(gAttiva[k]==0 || !gCar[k] || gServe[k]!=0) continue;
      double h0=gH0[k], l0=gL0[k];
      if(FFX_CorreggiDaM1(mt,mh,ml,got,gT0[k],gNext[k],h0,l0))
        {
         gH0[k]=h0; gL0[k]=l0;
         AggiornaStato(k);
        }
     }
  }
void Copertura(int &cov,int &tot)
  {
   FFX_Copertura(gSt,gAttiva,gNS,cov,tot);
  }
//--- forza, ordine, punteggi, correlazioni, TOP
void Ricalcola()
  {
   gNTop=FFX_RicalcolaTutto(gSt,gNS,gNI,gBase,gQuot,gPeso,gOn,gStrat,gSanTF,gSanCoppia,gSanSegno,gCoppiaSan,
                            InpTopOpp,InpSogliaDebole,gNum,gDen,gForza,gOrd,gSanEsito,
                            gScore,gAl,gDf,gRo,gSa,gScOk,gTop);
  }

//+------------------------------------------------------------------+
//| Oggetti grafici                                                  |
//+------------------------------------------------------------------+
void MkRect(const string n,const int zord)
  {
   if(ObjectFind(0,n)<0) ObjectCreate(0,n,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,n,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,n,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,n,OBJPROP_BACK,false);
   ObjectSetInteger(0,n,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,n,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,n,OBJPROP_ZORDER,zord);
   ObjectSetString(0,n,OBJPROP_TOOLTIP,"\n");
  }
void MkLabel(const string n,const int fs,const color col,const string font,const int zord)
  {
   if(ObjectFind(0,n)<0) ObjectCreate(0,n,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,n,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,n,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0,n,OBJPROP_FONTSIZE,fs);
   ObjectSetInteger(0,n,OBJPROP_COLOR,col);
   ObjectSetString(0,n,OBJPROP_FONT,font);
   ObjectSetInteger(0,n,OBJPROP_BACK,false);
   ObjectSetInteger(0,n,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,n,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,n,OBJPROP_ZORDER,zord);
   ObjectSetString(0,n,OBJPROP_TEXT," ");
   ObjectSetString(0,n,OBJPROP_TOOLTIP,"\n");
  }
void Pos(const string n,const int x,const int y)
  {
   ObjectSetInteger(0,n,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,n,OBJPROP_YDISTANCE,y);
  }
void Size(const string n,const int w,const int h)
  {
   ObjectSetInteger(0,n,OBJPROP_XSIZE,w<1 ? 1 : w);
   ObjectSetInteger(0,n,OBJPROP_YSIZE,h<1 ? 1 : h);
  }
void Vis(const string n,const bool on)
  {
   ObjectSetInteger(0,n,OBJPROP_TIMEFRAMES,on ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
  }
void SetText(const string n,const string t)
  {
   ObjectSetString(0,n,OBJPROP_TEXT,(t=="") ? " " : t);
  }
void CreaOggetti()
  {
   color ink=C'40,40,40';
   MkRect(P+"bg",0);
   ObjectSetInteger(0,P+"bg",OBJPROP_BGCOLOR,C'248,248,246');
   ObjectSetInteger(0,P+"bg",OBJPROP_COLOR,C'200,200,200');
   MkRect(P+"bgR",0);
   ObjectSetInteger(0,P+"bgR",OBJPROP_BGCOLOR,C'248,248,246');
   ObjectSetInteger(0,P+"bgR",OBJPROP_COLOR,C'200,200,200');
   MkLabel(P+"tit",9,ink,"Arial Bold",2);
   SetText(P+"tit","FORZA FX - stato della candela IN CORSO per TF");
   ObjectSetString(0,P+"tit",OBJPROP_TOOLTIP,"Click: stampa la diagnosi (28 coppie x 9 stati e le 8 forze) nella scheda Esperti");
   MkLabel(P+"hS",8,ink,"Arial Bold",2);
   SetText(P+"hS","SIMBOLO");
   for(int c=0;c<FFX_NTF;c++)
     {
      MkLabel(P+"h_"+IntegerToString(c),8,ink,"Arial Bold",2);
      SetText(P+"h_"+IntegerToString(c),FFX_TFN[c]);
     }
   MkLabel(P+"hG",8,ink,"Arial Bold",2);
   SetText(P+"hG","SEGNALE");
   for(int s=0;s<gNS;s++)
     {
      string ss=IntegerToString(s);
      MkLabel(P+"s_"+ss,8,ink,"Arial",2);
      SetText(P+"s_"+ss,gNome[s]);
      ObjectSetString(0,P+"s_"+ss,OBJPROP_TOOLTIP,"Click: apre "+gSym[s]+" in D1 (grafico di lettura separato)");
      for(int c=0;c<FFX_NTF;c++)
        {
         string n=P+"c_"+ss+"_"+IntegerToString(c);
         MkRect(n,1);
         ObjectSetInteger(0,n,OBJPROP_BGCOLOR,ColoreStato(FFX_S_ND));
         ObjectSetInteger(0,n,OBJPROP_COLOR,clrSilver);
        }
      MkRect(P+"gb_"+ss,1);
      ObjectSetInteger(0,P+"gb_"+ss,OBJPROP_BGCOLOR,C'236,236,236');
      ObjectSetInteger(0,P+"gb_"+ss,OBJPROP_COLOR,C'210,210,210');
      MkLabel(P+"gt_"+ss,8,ink,"Arial Bold",2);
      SetText(P+"gt_"+ss,"...");
     }
   //--- pannello forza
   MkLabel(P+"ft",9,ink,"Arial Bold",2);
   SetText(P+"ft","FORZA VALUTE  (click = filtra la matrice)");
   for(int i=1;i<=4;i++) MkLabel(P+"fi"+IntegerToString(i),7,C'90,90,90',"Arial",2);
   MkRect(P+"fz",1);
   ObjectSetInteger(0,P+"fz",OBJPROP_BGCOLOR,C'150,150,150');
   ObjectSetInteger(0,P+"fz",OBJPROP_COLOR,C'150,150,150');
   for(int r=0;r<FFX_NVAL;r++)
     {
      string rr=IntegerToString(r);
      MkLabel(P+"fv_"+rr,9,ink,"Arial Bold",2);
      MkRect(P+"fb_"+rr,1);
      MkLabel(P+"fn_"+rr,9,ink,"Consolas",2);
     }
   //--- TOP
   MkLabel(P+"tt",9,ink,"Arial Bold",2);
   SetText(P+"tt","TOP per punteggio di confluenza");
   for(int i=0;i<gNS;i++) MkLabel(P+"to_"+IntegerToString(i),8,ink,"Consolas",2);
   //--- correlazioni
   MkLabel(P+"st",9,ink,"Arial Bold",2);
   SetText(P+"st","CORRELAZIONI ("+(gSanTF>=0 ? FFX_TFN[gSanTF] : "spento")+")");
   for(int i=0;i<gNI;i++) MkLabel(P+"sr_"+IntegerToString(i),8,ink,"Consolas",2);
  }
//--- impaginazione: celle scalate coi DPI e rimpicciolite se il grafico e' basso (classe 952)
bool Layout()
  {
   int chH=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   int vis=0;
   for(int s=0;s<gNS;s++) if(RigaVisibile(s)) vis++;
   int cell=(int)MathRound(InpCellaPx*gK);
   int step=cell+(int)MathRound(3*gK);
   int top=InpY+(int)MathRound(44*gK);
   if(chH>0 && vis>0 && top+vis*step+(int)MathRound(10*gK)>chH)
     {
      int st2=(chH-top-(int)MathRound(10*gK))/vis;
      if(st2<12) st2=12;
      if(st2<step) { step=st2; cell=step-2; }
     }
   string key=IntegerToString(vis)+"_"+IntegerToString(step)+"_"+IntegerToString(gFiltro)+"_"+IntegerToString(chH);
   if(key==gLayoutKey) return false;
   gLayoutKey=key;
   int x0=InpX, y0=InpY;
   int pad=(int)MathRound(6*gK);
   int symW=(int)MathRound(64*gK);
   int sigW=(int)MathRound(112*gK);
   int bw=(int)MathRound(2*gK); if(bw<2) bw=2;
   int nOn=0;
   for(int c=0;c<FFX_NTF;c++) if(gOn[c]!=0) nOn++;
   int matW=pad+symW+nOn*step+(int)MathRound(4*gK)+sigW+pad;
   int matH=(top-y0)+vis*step+pad;
   Pos(P+"bg",x0,y0); Size(P+"bg",matW,matH);
   Pos(P+"tit",x0+pad,y0+(int)MathRound(4*gK));
   int yh=y0+(int)MathRound(24*gK);
   Pos(P+"hS",x0+pad,yh);
   int xc=x0+pad+symW;
   for(int c=0;c<FFX_NTF;c++)
     {
      string hn=P+"h_"+IntegerToString(c);
      Vis(hn,gOn[c]!=0);
      if(gOn[c]==0) continue;
      Pos(hn,xc,yh);
      xc+=step;
     }
   int xs=xc+(int)MathRound(4*gK);
   Pos(P+"hG",xs,yh);
   int row=0;
   for(int s=0;s<gNS;s++)
     {
      string ss=IntegerToString(s);
      bool v=RigaVisibile(s);
      int y=top+row*step;
      Vis(P+"s_"+ss,v); Vis(P+"gb_"+ss,v); Vis(P+"gt_"+ss,v);
      Pos(P+"s_"+ss,x0+pad,y+(int)MathRound(2*gK));
      int x=x0+pad+symW;
      for(int c=0;c<FFX_NTF;c++)
        {
         string n=P+"c_"+ss+"_"+IntegerToString(c);
         Vis(n,v && gOn[c]!=0);
         if(gOn[c]==0) continue;
         Pos(n,x,y); Size(n,cell,cell);
         ObjectSetInteger(0,n,OBJPROP_WIDTH,bw);
         x+=step;
        }
      Pos(P+"gb_"+ss,xs,y); Size(P+"gb_"+ss,sigW,cell);
      Pos(P+"gt_"+ss,xs+(int)MathRound(4*gK),y+(int)MathRound(2*gK));
      if(v) row++;
     }
   //--- colonna destra: forza, TOP, correlazioni
   int xr=x0+matW+(int)MathRound(8*gK);
   int rw=(int)MathRound(300*gK);
   int lh=(int)MathRound(15*gK);
   int y=y0+pad;
   Pos(P+"ft",xr+pad,y); y+=lh+(int)MathRound(3*gK);
   for(int i=1;i<=4;i++) { Pos(P+"fi"+IntegerToString(i),xr+pad,y); y+=lh-(int)MathRound(2*gK); }
   y+=(int)MathRound(4*gK);
   int xz=xr+pad+(int)MathRound(40*gK)+(int)MathRound(90*gK);
   gXz=xz;
   Pos(P+"fz",xz,y-(int)MathRound(2*gK)); Size(P+"fz",1,FFX_NVAL*lh+(int)MathRound(2*gK));
   for(int r=0;r<FFX_NVAL;r++)
     {
      string rr=IntegerToString(r);
      Pos(P+"fv_"+rr,xr+pad,y);
      Pos(P+"fn_"+rr,xz+(int)MathRound(96*gK),y);
      ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_YDISTANCE,y+(int)MathRound(2*gK));
      ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_YSIZE,lh-(int)MathRound(5*gK));
      y+=lh;
     }
   y+=(int)MathRound(8*gK);
   bool topOn=(InpTopOpp>0);
   Vis(P+"tt",topOn);
   Pos(P+"tt",xr+pad,y); if(topOn) y+=lh+(int)MathRound(2*gK);
   for(int i=0;i<gNS;i++)
     {
      string n=P+"to_"+IntegerToString(i);
      bool v=topOn && i<InpTopOpp;
      Vis(n,v);
      Pos(n,xr+pad,y);
      if(v) y+=lh;
     }
   y+=(int)MathRound(8*gK);
   bool sanOn=(gSanTF>=0);
   Vis(P+"st",sanOn);
   Pos(P+"st",xr+pad,y); if(sanOn) y+=lh+(int)MathRound(2*gK);
   for(int i=0;i<gNI;i++) { Pos(P+"sr_"+IntegerToString(i),xr+pad,y); y+=lh; }
   Pos(P+"bgR",xr,y0); Size(P+"bgR",rw,y-y0+pad);
   //--- dopo un cambio di impaginazione tutti i testi si riscrivono
   for(int i=0;i<ArraySize(gFxT);i++) gFxT[i]="#init#";
   return true;
  }
bool RigaVisibile(const int s)
  {
   return FFX_RigaVisibile(gBase[s],gQuot[s],gFiltro);
  }
string Px(const int s,const double v)
  {
   return DoubleToString(v,gDig[s]);
  }
//--- scrive colori e testi; true se ha cambiato qualcosa
bool Disegna()
  {
   bool ch=false;
   for(int s=0;s<gNS;s++)
     {
      string ss=IntegerToString(s);
      for(int c=0;c<FFX_NTF;c++)
        {
         int k=s*FFX_NTF+c;
         if(gAttiva[k]==0) continue;
         string n=P+"c_"+ss+"_"+IntegerToString(c);
         color cf=ColoreStato(gSt[k]);
         color cb=ColoreBordo(gBo[k],gSt[k]);
         if(cf!=gCF[k]) { ObjectSetInteger(0,n,OBJPROP_BGCOLOR,cf); gCF[k]=cf; ch=true; }
         if(cb!=gCB[k]) { ObjectSetInteger(0,n,OBJPROP_COLOR,cb); gCB[k]=cb; ch=true; }
         string tip=TipCella(s,c,k);
         if(tip!=gCT[k]) { ObjectSetString(0,n,OBJPROP_TOOLTIP,tip); gCT[k]=tip; }
        }
      //--- segnale
      string t, tip;
      color col;
      if(gScOk[s]==0)
        {
         t="...";
         col=C'236,236,236';
         tip=(gBase[s]<0) ? "Coppia fuori dalla forza (valute non riconosciute)" : "In attesa dei dati di tutti i TF accesi";
        }
      else
        {
         int e=FFX_Etichetta(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);
         double r=MathRound(gScore[s]);
         string lab=FFX_TestoEtichetta(e);
         t=FFX_TestoSegnale(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);
         col=ColoreEtichetta(e);
         tip="Allineamento "+FFX_Segnato(gAl[s],2)+" x40 = "+FFX_Segnato(gAl[s]*FFX_W_ALLIN,1)+
             "\nDiff. forza "+FFX_Segnato(gDf[s],3)+" x30 = "+FFX_Segnato(gDf[s]*FFX_W_DIFF,1)+
             "\nRotture "+FFX_Segnato(gRo[s],3)+" x20 = "+FFX_Segnato(gRo[s]*FFX_W_ROTT,1)+
             "\nCorrelazione "+FFX_Segnato(gSa[s],0)+" x10 = "+FFX_Segnato(gSa[s]*FFX_W_SAN,1)+
             "\nTotale "+FFX_Segnato(gScore[s],2)+" -> "+FFX_Segnato(r,0)+" "+lab+
             "\n(confluenza di colori, NON un segnale misurato)";
        }
      if(t!=gGT[s]) { SetText(P+"gt_"+ss,t); gGT[s]=t; ch=true; }
      if(col!=gGC[s])
        {
         ObjectSetInteger(0,P+"gb_"+ss,OBJPROP_BGCOLOR,col);
         ObjectSetInteger(0,P+"gt_"+ss,OBJPROP_COLOR,(col==C'236,236,236') ? C'40,40,40' : clrWhite);
         gGC[s]=col; ch=true;
        }
      if(tip!=gGTip[s])
        {
         ObjectSetString(0,P+"gb_"+ss,OBJPROP_TOOLTIP,tip);
         ObjectSetString(0,P+"gt_"+ss,OBJPROP_TOOLTIP,tip);
         gGTip[s]=tip;
        }
     }
   if(DisegnaForza()) ch=true;
   if(DisegnaTop()) ch=true;
   if(DisegnaSanity()) ch=true;
   string tt="FORZA FX - candela IN CORSO per TF - ultimo cambio "+gUltimoCambio;
   if(SetTextC(P+"tit",tt,0)) ch=true;
   return ch;
  }
//--- testo con cache (slot nella tabella gFxT)
bool SetTextC(const string n,const string t,const int slot)
  {
   if(gFxT[slot]==t) return false;
   SetText(n,t);
   gFxT[slot]=t;
   return true;
  }
string TipCella(const int s,const int c,const int k)
  {
   string t=gNome[s]+" "+FFX_TFN[c]+": "+NomeStato(gSt[k]);
   if(gCar[k])
     {
      t+="\nbordo: "+(gBo[k]>0 ? "sopra" : (gBo[k]<0 ? "sotto" : "pari a"))+" l'apertura "+Px(s,gO0[k])+
         "\nprecedente: max "+Px(s,gH1[k])+" min "+Px(s,gL1[k])+
         "\ncandela in corso dalle "+TimeToString(gT0[k],TIME_DATE|TIME_MINUTES)+(gStDa[k]!="" ? ", stato dal "+gStDa[k] : "");
      if(c==FFX_IDX_D1 && InpD1SaltaWeekend) t+="\n(D1: precedente = ultimo giorno lun-ven)";
     }
   if(gNd[k]!="") t+="\n["+gNd[k]+"]";
   if(gServe[k]!=0 && gCar[k]) t+="\n[candela nuova in caricamento: stato della candela prima]";
   return t;
  }
bool DisegnaForza()
  {
   bool ch=false;
   int cov=0,tot=0;
   Copertura(cov,tot);
   double somma=0.0;
   for(int v=0;v<FFX_NVAL;v++) somma+=gForza[v];
   if(SetTextC(P+"fi1","pesi "+TestoPesi(),1)) ch=true;
   if(SetTextC(P+"fi2","forza = somma(stato x peso x segno) / (2 x somma pesi usati), in [-1,+1]",2)) ch=true;
   if(SetTextC(P+"fi3","stato: +2 rottura su, +1 su, +0,5 fail giu', -0,5 fail su, -1 giu', -2 rottura giu'",3)) ch=true;
   string cv="copertura "+IntegerToString(cov)+"/"+IntegerToString(tot)+" celle"+(cov<tot ? " - PARZIALE" : "")+
             "  |  somma forze "+FFX_Segnato(somma,4);
   if(SetTextC(P+"fi4",cv,4)) ch=true;
   int half=(int)MathRound(90*gK);
   int xz=gXz;
   for(int r=0;r<FFX_NVAL;r++)
     {
      int v=gOrd[r];
      string rr=IntegerToString(r);
      double f=gForza[v];
      string lab=(v==gFiltro) ? "["+FFX_VAL[v]+"]" : FFX_VAL[v];
      if(SetTextC(P+"fv_"+rr,lab,5+r)) ch=true;
      if(SetTextC(P+"fn_"+rr,FFX_TestoForza(f),5+FFX_NVAL+r)) ch=true;
      int x=0, w=1;
      bool pos=FFX_Barra(f,xz,half,x,w);
      color col=pos ? C'34,197,94' : C'239,68,68';
      string key=IntegerToString(x)+"_"+IntegerToString(w)+"_"+IntegerToString((int)col);
      if(gFxT[5+2*FFX_NVAL+r]!=key)
        {
         ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_XDISTANCE,x);
         ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_XSIZE,w);
         ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_BGCOLOR,col);
         ObjectSetInteger(0,P+"fb_"+rr,OBJPROP_COLOR,col);
         gFxT[5+2*FFX_NVAL+r]=key;
         ch=true;
        }
      string tip=FFX_VAL[v]+": numeratore "+FFX_Segnato(gNum[v],1)+" / denominatore "+DoubleToString(gDen[v],0)+
                 " = "+FFX_Segnato(f,4)+"\nClick: mostra solo le coppie con "+FFX_VAL[v]+" (di nuovo: tutte)";
      ObjectSetString(0,P+"fv_"+rr,OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,P+"fb_"+rr,OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,P+"fn_"+rr,OBJPROP_TOOLTIP,tip);
     }
   return ch;
  }
int SlotTop()
  {
   if(InpTopOpp<=0) return 0;
   return (InpTopOpp<gNS) ? InpTopOpp : gNS;
  }
bool DisegnaTop()
  {
   bool ch=false;
   if(InpTopOpp<=0) return false;
   int base=5+3*FFX_NVAL;
   int nmax=SlotTop();
   for(int i=0;i<nmax;i++)
     {
      string n=P+"to_"+IntegerToString(i);
      string t=" ";
      color col=C'120,120,120';
      if(i<gNTop)
        {
         int s=gTop[i];
         int e=FFX_Etichetta(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);
         t="#"+IntegerToString(i+1)+" "+gNome[s]+" "+FFX_TestoSegnale(gScore[s],InpSogliaForte,InpSogliaNormale,InpSogliaDebole);
         col=(e>0) ? C'22,130,60' : C'185,28,28';
        }
      else if(i==0) t="(nessuna coppia oltre "+DoubleToString(InpSogliaDebole,0)+")";
      if(i+base<ArraySize(gFxT) && SetTextC(n,t,i+base))
        {
         ObjectSetInteger(0,n,OBJPROP_COLOR,col);
         ObjectSetString(0,n,OBJPROP_TOOLTIP,(i<gNTop) ? "Click: apre la coppia in D1" : "\n");
         ch=true;
        }
     }
   return ch;
  }
bool DisegnaSanity()
  {
   bool ch=false;
   if(gSanTF<0) return false;
   int base=5+3*FFX_NVAL+SlotTop();
   for(int i=0;i<gNI;i++)
     {
      string n=P+"sr_"+IntegerToString(i);
      int sc=gSanCoppia[i];
      int ks=(gNS+i)*FFX_NTF+gSanTF;
      int kc=sc*FFX_NTF+gSanTF;
      string esito=FFX_TestoEsito(gSanEsito[i]);
      string t=gNome[gNS+i]+" "+(gSanSegno[i]>0 ? "(+)" : "(-)")+" "+gNome[sc]+": "+esito;
      if(!gSymOk[gNS+i]) t+=" (assente)";
      else if(gSt[ks]==FFX_S_ND) t+=" (senza dati)";
      color col=(gSanEsito[i]>0) ? C'22,130,60' : ((gSanEsito[i]<0) ? C'185,28,28' : C'120,120,120');
      int slot=base+i;
      if(slot<ArraySize(gFxT) && SetTextC(n,t,slot))
        {
         ObjectSetInteger(0,n,OBJPROP_COLOR,col);
         ObjectSetString(0,n,OBJPROP_TOOLTIP,gNome[gNS+i]+" "+FFX_TFN[gSanTF]+": "+NomeStato(gSt[ks])+"\n"+
                         gNome[sc]+" "+FFX_TFN[gSanTF]+": "+NomeStato(gSt[kc])+
                         "\nALIGN/DIVERGE solo se nessuno dei due e' neutro o in fail. Entra nel punteggio di "+gNome[sc]+
                         " con peso 10.\nCorrelazione dichiarata dalla fonte, NON misurata.");
         ch=true;
        }
     }
   return ch;
  }

//+------------------------------------------------------------------+
//| Diagnosi nel Journal: con queste righe la forza si ricalcola a   |
//| mano (o con collaudo_forza_fx.py --diag file.txt)                |
//+------------------------------------------------------------------+
void DiagStampa(const string motivo)
  {
   int cov=0,tot=0;
   Copertura(cov,tot);
   string pre="[ForzaFX diag] ";
   Print(pre,"motivo=",motivo," ora server ",TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
         " | TF ",TestoTFDiag()," | pesi ",TestoPesi()," | copertura ",cov,"/",tot,
         " | CopyRates dall'ultima diagnosi ",gCopie-gCopieDiag);
   gCopieDiag=gCopie;
   string riga="";
   int nr=0;
   for(int s=0;s<gNS;s++)
     {
      riga+=(riga=="" ? "" : " ")+FFX_RigaCoppia(gNome[s],gSt,s*FFX_NTF);
      nr++;
      if(FFX_FineRiga(nr,s,gNS,7))
        {
         Print(pre,"celle ",riga);
         riga="";
         nr=0;
        }
     }
   string f="";
   for(int v=0;v<FFX_NVAL;v++)
      f+=(f=="" ? "" : " | ")+FFX_VAL[v]+" num="+FFX_Segnato(gNum[v],2)+" den="+DoubleToString(gDen[v],2)+" forza="+FFX_Segnato(gForza[v],4);
   Print(pre,"forze ",f);
   Print(pre,FFX_RigaSomma(gForza,gDen));
   string sc="";
   nr=0;
   for(int s=0;s<gNS;s++)
     {
      string x=gNome[s]+"=";
      if(gScOk[s]==0) x+="n/d";
      else x+=FFX_Segnato(gScore[s],2)+"(A"+FFX_Segnato(gAl[s],4)+" D"+FFX_Segnato(gDf[s],4)+
              " R"+FFX_Segnato(gRo[s],4)+" C"+FFX_Segnato(gSa[s],0)+")";
      sc+=(sc=="" ? "" : " ")+x;
      nr++;
      if(FFX_FineRiga(nr,s,gNS,7))
        {
         Print(pre,"punteggi ",sc);
         sc="";
         nr=0;
        }
     }
  }
string TestoTFDiag()
  {
   string t="";
   for(int c=0;c<FFX_NTF;c++) t+=(c>0 ? "," : "")+FFX_TFN[c]+(gOn[c]!=0 ? "" : "(spento)");
   return t;
  }

//+------------------------------------------------------------------+
//| Click. Il grafico della dashboard NON cambia mai (classe 930):   |
//| si apre o si riusa un grafico di lettura separato.               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      if(Layout()) { gDirty=true; ChartRedraw(0); }
      return;
     }
   if(id!=CHARTEVENT_OBJECT_CLICK) return;
   if(StringFind(sparam,P)!=0) return;
   string body=StringSubstr(sparam,StringLen(P));
   int a=-1, b=-1;
   int azione=FFX_LeggiClick(body,a,b);
   if(azione==6) { DiagStampa("click sul titolo"); return; }
   if(azione==1)
     {
      if(a>=0 && a<gNS) ApriGrafico(gSym[a],PERIOD_D1);
      return;
     }
   if(azione==2)
     {
      if(a>=0 && a<gNS && b>=0 && b<FFX_NTF) ApriGrafico(gSym[a],FFX_TF[b]);
      return;
     }
   if(azione==3)
     {
      if(a>=0 && a<gNTop) ApriGrafico(gSym[gTop[a]],PERIOD_D1);
      return;
     }
   if(azione==4)
     {
      if(a>=0 && a<gNI && gSanTF>=0) ApriGrafico(gSym[gNS+a],FFX_TF[gSanTF]);
      return;
     }
   if(azione==5)
     {
      if(a<0 || a>=FFX_NVAL) return;
      gFiltro=FFX_FiltroDopoClick(gFiltro,gOrd,a);   // stesso click = tutte le coppie
      GvSave("filtro",(double)gFiltro);
      Layout();
      gDirty=true;
      Ricalcola();
      Disegna();
      gDirty=false;
      ChartRedraw(0);
      return;
     }
  }
//--- apre sym/tf su un grafico di lettura: mai il grafico della dashboard, mai un grafico con un EA
void ApriGrafico(const string sym,const ENUM_TIMEFRAMES tf)
  {
   long me=ChartID();
   long id=0;
   if(InpRiusaGrafico && gVisore>0 && gVisore!=me && GraficoEsiste(gVisore)) id=gVisore;
   if(id>0)
     {
      string ea=ChartGetString(id,CHART_EXPERT_NAME);
      if(StringLen(ea)>0)
        {
         Print("[ForzaFX] sul grafico di lettura ora gira l'EA '",ea,"': NON lo tocco, apro un grafico nuovo per ",sym,".");
         id=0;
        }
     }
   if(id>0)
     {
      if(ChartSymbol(id)!=sym || ChartPeriod(id)!=tf)
         if(!ChartSetSymbolPeriod(id,sym,tf))
            Print("[ForzaFX] cambio del grafico di lettura fallito per ",sym," (errore ",GetLastError(),").");
      ChartSetInteger(id,CHART_BRING_TO_TOP,true);
      return;
     }
   ResetLastError();
   long nid=ChartOpen(sym,tf);
   if(nid==0)
     {
      Print("[ForzaFX] ChartOpen fallito per ",sym," (errore ",GetLastError(),").");
      return;
     }
   gVisore=nid;
   SalvaVisore();
   gWatchId=nid;
   gWatchFino=OraMs()+10000;
   gWatchSym=sym;
  }
//--- classe 951: per 10 s dopo ChartOpen si guarda se il template ha portato un EA
void ControllaGraficoNuovo(const long now)
  {
   if(gWatchId<=0) return;
   if(!GraficoEsiste(gWatchId)) { gWatchId=0; return; }
   string ea=ChartGetString(gWatchId,CHART_EXPERT_NAME);
   if(StringLen(ea)>0)
     {
      Alert("[ForzaFX] ATTENZIONE: il grafico ",gWatchSym," aperto dalla dashboard contiene l'EA '",ea,
            "' (arrivato dal template default.tpl). Chiudi quel grafico o togli l'EA. La dashboard non lo usera'.");
      if(gVisore==gWatchId) { gVisore=0; SalvaVisore(); }
      gWatchId=0;
      return;
     }
   if(now>gWatchFino) gWatchId=0;
  }
//+------------------------------------------------------------------+
