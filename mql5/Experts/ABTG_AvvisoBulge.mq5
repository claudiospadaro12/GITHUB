//+------------------------------------------------------------------+
//|                                              ABTG_AvvisoBulge.mq5 |
//|  v1.00 (23/11/2026) -- AVVISO NOSTRO (ABTG). NON apre ordini.     |
//|  Segue la macchina a stati della Breaking Band v4.2 di Leonardo   |
//|  (bulge = la barra CHIUSA tocca una banda Bollinger 20/2; 1a e 2a |
//|  bulge = CONTINUAZIONE, 3a = INVERSIONE; livelli della banda e    |
//|  ATR SALVATI al bulge) ma invece di piazzare ordini limit AVVISA: |
//|   1) BULGE RILEVATA   2) ZONA DI INGRESSO RAGGIUNTA               |
//|   3) SETUP INVALIDATO (banda opposta toccata o timeout).          |
//|  Per la zona di ingresso stampa i controlli della guida: SI / NO. |
//|  Un EA su UN solo grafico controlla tutti i simboli dell'elenco.  |
//+------------------------------------------------------------------+
#property copyright "ABTG - Claudio Spadaro (nostro)"
#property version   "1.00"
#property strict

input string          InpSimboli   = "EURUSD,GBPUSD,USDJPY,USDCHF,USDCAD,AUDUSD,NZDUSD,EURGBP,EURJPY,EURCHF,EURCAD,EURAUD,EURNZD,GBPJPY,GBPCHF,GBPCAD,GBPAUD,GBPNZD,CADJPY,AUDJPY,NZDJPY,CHFJPY,AUDCAD,AUDCHF,AUDNZD,NZDCAD,NZDCHF,CADCHF,XAUUSD,XAGUSD,D30EUR,U30USD,NASUSD,SPXUSD,225JPY";
input ENUM_TIMEFRAMES InpTF        = PERIOD_H1;  // timeframe fisso (non quello del grafico)
input int             InpBBPer     = 20;
input double          InpBBDev     = 2.0;
input int             InpATRPer    = 14;
input double          InpSLMult    = 3.0;        // SL = 3 x ATR salvato al bulge
input int             InpTimeout   = 40;         // barre massime di attesa
input bool            InpAvvisoTerminale = true; // finestra di avviso + suono
input bool            InpPushZona  = true;       // notifica push per la ZONA DI INGRESSO (serve ID MetaQuotes)
input bool            InpPushBulge = false;      // push anche per la bulge rilevata
input bool            InpPushInval = false;      // push anche per setup invalidato
input bool            InpMail      = false;      // mail per la zona di ingresso
input int             InpMaxZonaOra = 1;         // massimo avvisi di zona per simbolo e per ora
input bool            InpCSV       = true;       // MQL5\Files\ABTG_Avvisi.csv

enum STATO { ST_SCAN, ST_CONT, ST_INV_MED, ST_INV_RET };

struct Sim
  {
   string   nome;
   bool     ok;
   STATO    st;
   int      cnt;
   int      bDir, bCount;
   bool     oppReached;
   double   impBand, oppBand, medBulge, atrSaved;
   datetime ultimaBarra;
   datetime oraZona;     // ora (arrotondata) dell'ultimo avviso di zona
   int      nZonaOra;
  };

Sim S[];
int NS=0;

//--- barre
bool Barre(const string s,MqlRates &r[],int n)
  { ArraySetAsSeries(r,true); return CopyRates(s,InpTF,0,n,r)==n; }

double Media(const MqlRates &r[],int sh,int per)
  { double x=0; for(int i=0;i<per;i++) x+=r[sh+i].close; return x/per; }

double Dev(const MqlRates &r[],int sh,int per)
  { double m=Media(r,sh,per),v=0; for(int i=0;i<per;i++){double d=r[sh+i].close-m; v+=d*d;} return MathSqrt(v/per); }

double ATRv(const MqlRates &r[],int sh,int per)
  { double x=0; for(int i=0;i<per;i++){ int k=sh+i; double tr=MathMax(r[k].high-r[k].low,MathMax(MathAbs(r[k].high-r[k+1].close),MathAbs(r[k].low-r[k+1].close))); x+=tr;} return x/per; }

string Pr(const string s,double p){ return DoubleToString(p,(int)SymbolInfoInteger(s,SYMBOL_DIGITS)); }

void Scrivi(const string s,const string liv,const string testo)
  {
   if(!InpCSV) return;
   int h=FileOpen("ABTG_Avvisi.csv",FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ|FILE_SHARE_WRITE,';');
   if(h==INVALID_HANDLE) return;
   if(FileSize(h)==0) FileWrite(h,"ora_server","simbolo","livello","testo");
   FileSeek(h,0,SEEK_END);
   FileWrite(h,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),s,liv,testo);
   FileClose(h);
  }

void Avvisa(const string s,const string liv,const string testo,bool push,bool mail)
  {
   string t="["+liv+"] "+testo;
   Print("[ABTG_Avviso] ",t);
   if(InpAvvisoTerminale) Alert(t);
   if(push) SendNotification(StringSubstr(t,0,255));
   if(mail) SendMail("ABTG avviso "+s,t);
   Scrivi(s,liv,testo);
  }

void Reset(Sim &x){ x.st=ST_SCAN; x.cnt=0; }

void Azzera(Sim &x){ x.bCount=0; x.bDir=0; x.oppReached=false; Reset(x); }

//--- controlli della guida per la zona di ingresso; ritorna il testo
string Controlli(Sim &x,const MqlRates &r[],bool inversione,int dirIngresso)
  {
   string o="";
   double a=x.atrSaved;
   // ultima candela non grande (arrivo sulla banda senza forza eccessiva)
   double rng1=r[1].high-r[1].low;
   o+= (rng1<=1.5*a) ? "candela di arrivo non grande SI; " : "candela di arrivo GRANDE NO; ";
   // ritorno ordinato: poche barre contro la direzione del ritorno (ultime 8 barre chiuse)
   int cont=0,tot=0;
   for(int i=1;i<=8;i++)
     {
      double mov=r[i].close-r[i+1].close; tot++;
      bool controDir=(x.bDir==1)? (mov>0) : (mov<0);   // contro il ritorno (il ritorno e' opposto al bulge)
      if(controDir) cont++;
     }
   o+= (cont<=3) ? "ritorno ordinato SI; " : "ritorno NON lineare NO; ";
   // bande ristrette rispetto al bulge e StdDev sotto la sua SMA 50
   double w=2*InpBBDev*Dev(r,1,InpBBPer);
   double sd[]; ArrayResize(sd,50); for(int i=0;i<50;i++) sd[i]=Dev(r,1+i,InpBBPer);
   double sma=0; for(int i=0;i<50;i++) sma+=sd[i]; sma/=50;
   o+= (sd[0]<sma) ? "StdDev sotto la media50 SI; " : "StdDev sopra la media50 NO; ";
   if(inversione)
     {
      // banda dell'impulso piatta o in lieve discesa/salita (ultime 3 barre)
      double b1,b4;
      if(x.bDir==1){ b1=Media(r,1,InpBBPer)+InpBBDev*Dev(r,1,InpBBPer); b4=Media(r,4,InpBBPer)+InpBBDev*Dev(r,4,InpBBPer); o+=(b1-b4<=0.1*a)?"banda sup. piatta o in discesa SI; ":"banda sup. si ALLARGA NO; "; }
      else { b1=Media(r,1,InpBBPer)-InpBBDev*Dev(r,1,InpBBPer); b4=Media(r,4,InpBBPer)-InpBBDev*Dev(r,4,InpBBPer); o+=(b4-b1<=0.1*a)?"banda inf. piatta o in salita SI; ":"banda inf. si ALLARGA NO; "; }
     }
   o+="news: da verificare";
   return o;
  }

//--- stati (una volta per barra chiusa; shift 1 = ultima barra chiusa)
void DoScan(Sim &x,const MqlRates &r[])
  {
   double m=Media(r,1,InpBBPer), d=Dev(r,1,InpBBPer);
   double bu=m+InpBBDev*d, bl=m-InpBBDev*d;
   bool up=(r[1].high>=bu), dn=(r[1].low<=bl);
   if(!up && !dn) return;
   int nd=up?1:-1;
   if(x.bDir==0 || nd!=x.bDir){ x.bDir=nd; x.bCount=1; }
   else if(x.oppReached){ x.bCount++; if(x.bCount>3) x.bCount=3; }
   else x.bCount=1;
   x.impBand=(nd==1)?bu:bl; x.oppBand=(nd==1)?bl:bu; x.medBulge=m; x.atrSaved=ATRv(r,1,InpATRPer);
   x.oppReached=false; x.cnt=0;
   x.st=(x.bCount<=2)?ST_CONT:ST_INV_MED;
   string tipo=(x.bCount<=2)?"CONTINUAZIONE":"INVERSIONE possibile";
   string t=StringFormat("%s %s | BULGE %s (%da nella stessa direzione) | banda imp. salvata %s | banda opposta salvata %s | mediana %s | ATR %s | tipo: %s",
            x.nome,EnumToString(InpTF),(nd==1?"al RIALZO":"al RIBASSO"),x.bCount,Pr(x.nome,x.impBand),Pr(x.nome,x.oppBand),Pr(x.nome,m),Pr(x.nome,x.atrSaved),tipo);
   Avvisa(x.nome,"1 BULGE",t,InpPushBulge,false);
  }

void Invalida(Sim &x,const string motivo,bool azzeraContatori)
  {
   string t=StringFormat("%s %s | setup annullato: %s",x.nome,EnumToString(InpTF),motivo);
   Avvisa(x.nome,"3 INVALIDATO",t,InpPushInval,false);
   if(azzeraContatori) Azzera(x); else Reset(x);
  }

void Zona(Sim &x,const MqlRates &r[],bool inv,int dir,double ent)
  {
   // limite di avvisi per ora
   datetime h0=(datetime)(TimeCurrent()/3600*3600);
   if(x.oraZona!=h0){ x.oraZona=h0; x.nZonaOra=0; }
   if(x.nZonaOra>=InpMaxZonaOra) return;
   x.nZonaOra++;
   double sl=(dir==1)?ent-InpSLMult*x.atrSaved:ent+InpSLMult*x.atrSaved;
   double tp=Media(r,1,InpBBPer);   // mediana corrente (barra chiusa)
   double rr=(InpSLMult*x.atrSaved>0)?MathAbs(tp-ent)/(InpSLMult*x.atrSaved):0;
   string tipo=inv?"INVERSIONE":"CONTINUAZIONE";
   string t=StringFormat("%s %s | %s %s | livello %s | SL 3xATR %s | TP mediana %s | R:R 1:%.2f | %s",
            x.nome,EnumToString(InpTF),tipo,(dir==1?"LONG":"SHORT"),Pr(x.nome,ent),Pr(x.nome,sl),Pr(x.nome,tp),rr,Controlli(x,r,inv,dir));
   Avvisa(x.nome,"2 ZONA INGRESSO",t,InpPushZona,InpMail);
  }

//--- controllo sulla barra chiusa
void NuovaBarra(Sim &x)
  {
   MqlRates r[]; int n=InpBBPer+60;
   if(!Barre(x.nome,r,n+2)) return;
   x.cnt++;
   switch(x.st)
     {
      case ST_SCAN: DoScan(x,r); break;
      case ST_CONT:
         if(x.cnt>InpTimeout){ Invalida(x,"tempo scaduto senza ritorno alla banda opposta",true); break; }
         if(x.bDir==1 && r[1].low<=x.oppBand){ x.oppReached=true; Zona(x,r,false,1,x.oppBand); Reset(x); }
         else if(x.bDir==-1 && r[1].high>=x.oppBand){ x.oppReached=true; Zona(x,r,false,-1,x.oppBand); Reset(x); }
         break;
      case ST_INV_MED:
        {
         if(x.cnt>InpTimeout){ Invalida(x,"tempo scaduto",true); break; }
         if(x.bDir==1 && r[1].low<=x.oppBand){ Invalida(x,"toccata la banda opposta (il movimento non era esaurito)",false); break; }
         if(x.bDir==-1 && r[1].high>=x.oppBand){ Invalida(x,"toccata la banda opposta (il movimento non era esaurito)",false); break; }
         double med=Media(r,1,InpBBPer);
         bool atMed=(x.bDir==1)?(r[1].low<=med||r[1].close<=med*1.001):(r[1].high>=med||r[1].close>=med*0.999);
         if(atMed){ x.st=ST_INV_RET; x.cnt=0; }
         break;
        }
      case ST_INV_RET:
        {
         if(x.cnt>InpTimeout){ Invalida(x,"tempo scaduto senza retest",true); break; }
         if(x.bDir==1 && r[1].low<=x.oppBand){ Invalida(x,"toccata la banda opposta",false); break; }
         if(x.bDir==-1 && r[1].high>=x.oppBand){ Invalida(x,"toccata la banda opposta",false); break; }
         if(x.bDir==1 && r[1].high>=x.impBand){ Zona(x,r,true,-1,x.impBand); Reset(x); }
         else if(x.bDir==-1 && r[1].low<=x.impBand){ Zona(x,r,true,1,x.impBand); Reset(x); }
         break;
        }
     }
  }

//--- controllo in corso di barra solo per la ZONA di ingresso (livello fisso)
void Intrabar(Sim &x)
  {
   if(x.st!=ST_CONT && x.st!=ST_INV_RET) return;
   double bid=SymbolInfoDouble(x.nome,SYMBOL_BID), ask=SymbolInfoDouble(x.nome,SYMBOL_ASK);
   if(bid<=0||ask<=0) return;
   MqlRates r[]; if(!Barre(x.nome,r,InpBBPer+62)) return;
   if(x.st==ST_CONT)
     {
      if(x.bDir==1 && bid<=x.oppBand){ x.oppReached=true; Zona(x,r,false,1,x.oppBand); Reset(x); }
      else if(x.bDir==-1 && ask>=x.oppBand){ x.oppReached=true; Zona(x,r,false,-1,x.oppBand); Reset(x); }
     }
   else
     {
      if(x.bDir==1 && bid>=x.impBand){ Zona(x,r,true,-1,x.impBand); Reset(x); }
      else if(x.bDir==-1 && ask<=x.impBand){ Zona(x,r,true,1,x.impBand); Reset(x); }
     }
  }

int OnInit()
  {
   string v[]; int n=StringSplit(InpSimboli,',',v);
   ArrayResize(S,n); NS=0; string mancanti="";
   for(int i=0;i<n;i++)
     {
      string s=v[i]; StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      if(!SymbolSelect(s,true)){ mancanti+=s+" "; continue; }
      S[NS].nome=s; S[NS].ok=true; S[NS].st=ST_SCAN; S[NS].cnt=0; S[NS].bDir=0; S[NS].bCount=0; S[NS].oppReached=false;
      S[NS].ultimaBarra=0; S[NS].oraZona=0; S[NS].nZonaOra=0;
      NS++;
     }
   ArrayResize(S,NS);
   EventSetTimer(1);
   Print("[ABTG_Avviso] v1.00: ",NS," simboli, timeframe ",EnumToString(InpTF),". Simboli non trovati: ",(mancanti==""?"nessuno":mancanti));
   Comment("ABTG_AvvisoBulge v1.00: ",NS," simboli, ",EnumToString(InpTF),". Solo avvisi, nessun ordine.");
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason){ EventKillTimer(); Comment(""); }

void OnTimer()
  {
   for(int i=0;i<NS;i++)
     {
      datetime b=iTime(S[i].nome,InpTF,0);
      if(b==0) continue;
      if(S[i].ultimaBarra==0){ S[i].ultimaBarra=b; continue; }   // la prima volta si parte dalla barra attuale
      if(b!=S[i].ultimaBarra){ S[i].ultimaBarra=b; NuovaBarra(S[i]); }
      Intrabar(S[i]);
     }
  }

void OnTick(){}
