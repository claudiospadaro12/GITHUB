//+------------------------------------------------------------------+
//|                                          ABTG_ManagerMediana.mq5 |
//|  v1.00 (23/11/2026) -- EA semiautomatico NOSTRO (ABTG).           |
//|  NON apre ordini. Gestisce le posizioni aperte A MANO:            |
//|   - STOP LOSS = ATR(14) x 3 dal prezzo di apertura, impostato UNA |
//|     volta (se la posizione non ha gia lo stop) e mai spostato;    |
//|   - TAKE PROFIT = MEDIANA delle Bollinger (SMA 20 della chiusura) |
//|     sul timeframe scelto, riletta e aggiornata AL CAMBIO DI       |
//|     CANDELA (barra chiusa, shift 1). Tf=0: timeframe del grafico. |
//|  NIENTE trailing, niente break even, niente chiusure parziali.    |
//|  Regola: strategia Breaking Band di Leonardo (stop 3 ATR, target  |
//|  sulla mediana). Solo tester e demo.                              |
//+------------------------------------------------------------------+
#property copyright "ABTG - Claudio Spadaro (nostro)"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>

input long             InpMagicGestito  = 0;      // magic delle posizioni da gestire (0 = aperte a mano; -1 = tutte)
input bool             InpTuttiSimboli  = false;  // false = solo il simbolo del grafico; true = tutti i simboli
input ENUM_TIMEFRAMES  InpTF            = PERIOD_CURRENT; // timeframe di ATR e mediana (CURRENT = grafico)
input int              InpBBPeriodo     = 20;     // periodo della mediana (SMA della chiusura)
input int              InpATRPeriodo    = 14;     // periodo ATR
input double           InpATRMoltSL     = 3.0;    // stop = ATR x moltiplicatore
input bool             InpImpostaSL     = true;   // metti lo stop se manca
input bool             InpSovrascriviSL = false;  // true = metti lo stop 3 ATR anche se ne hai gia messo uno tuo (una sola volta)
input bool             InpAggiornaTP    = true;   // TP = mediana, aggiornato al cambio candela
input bool             InpDiarioCSV     = true;   // scrive MQL5\Files\ABTG_Manager_diario.csv

CTrade trade;
datetime g_ultimaBarra[];   // per simbolo (indice in g_nomi)
string   g_nomi[];

//--- indice del simbolo nell'elenco delle barre viste
int Idx(const string s)
  {
   for(int i=0;i<ArraySize(g_nomi);i++) if(g_nomi[i]==s) return i;
   int n=ArraySize(g_nomi);
   ArrayResize(g_nomi,n+1); ArrayResize(g_ultimaBarra,n+1);
   g_nomi[n]=s; g_ultimaBarra[n]=0;
   return n;
  }

ENUM_TIMEFRAMES TF(){ return (InpTF==PERIOD_CURRENT)?(ENUM_TIMEFRAMES)Period():InpTF; }

//--- mediana = SMA(periodo) delle chiusure delle ULTIME barre CHIUSE (shift 1..periodo)
bool Mediana(const string s,double &m)
  {
   double c[];
   if(CopyClose(s,TF(),1,InpBBPeriodo,c)!=InpBBPeriodo) return false;
   double sum=0; for(int i=0;i<InpBBPeriodo;i++) sum+=c[i];
   m=sum/InpBBPeriodo; return true;
  }

//--- ATR (come iATR di MT5: media semplice del True Range) sulle barre chiuse
bool ATR(const string s,double &a)
  {
   MqlRates r[];
   if(CopyRates(s,TF(),1,InpATRPeriodo+1,r)!=InpATRPeriodo+1) return false;   // r[0] = la piu vecchia
   double sum=0;
   for(int i=1;i<=InpATRPeriodo;i++)
     {
      double tr=MathMax(r[i].high-r[i].low,MathMax(MathAbs(r[i].high-r[i-1].close),MathAbs(r[i].low-r[i-1].close)));
      sum+=tr;
     }
   a=sum/InpATRPeriodo; return true;
  }

void Diario(const string s,ulong tk,const string tipo,const string azione,double sl,double tp,const string nota)
  {
   PrintFormat("[ABTG_Manager] %s #%I64u %s: %s SL=%.5f TP=%.5f %s",s,tk,tipo,azione,sl,tp,nota);
   if(!InpDiarioCSV) return;
   int h=FileOpen("ABTG_Manager_diario.csv",FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ|FILE_SHARE_WRITE,';');
   if(h==INVALID_HANDLE) return;
   if(FileSize(h)==0) FileWrite(h,"ora_server","simbolo","ticket","tipo","azione","sl","tp","nota");
   FileSeek(h,0,SEEK_END);
   FileWrite(h,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),s,(string)tk,tipo,azione,DoubleToString(sl,8),DoubleToString(tp,8),nota);
   FileClose(h);
  }

double Norm(const string s,double p)
  {
   double ts=SymbolInfoDouble(s,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(s,SYMBOL_DIGITS);
   if(ts>0) p=MathRound(p/ts)*ts;
   return NormalizeDouble(p,dg);
  }

void Gestisci(const string s,ulong tk,bool nuovaBarra)
  {
   if(!PositionSelectByTicket(tk)) return;
   long tipo=PositionGetInteger(POSITION_TYPE);
   double apertura=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL), tp=PositionGetDouble(POSITION_TP);
   string t=(tipo==POSITION_TYPE_BUY)?"BUY":"SELL";
   double pt=SymbolInfoDouble(s,SYMBOL_POINT);
   double stopLiv=SymbolInfoInteger(s,SYMBOL_TRADE_STOPS_LEVEL)*pt;
   double bid=SymbolInfoDouble(s,SYMBOL_BID), ask=SymbolInfoDouble(s,SYMBOL_ASK);
   string gv="ABTGM_SL_"+(string)tk;
   string gvv="ABTGM_V_"+(string)tk;
   bool primo=!GlobalVariableCheck(gvv);          // prima volta che vedo questa posizione
   if(primo) GlobalVariableSet(gvv,1.0);
   if(!primo && !nuovaBarra) return;              // il resto avviene solo alla prima visita o al cambio di candela (niente spam nel diario)

   //--- STOP: una sola volta, mai spostato
   double nuovoSL=sl;
   bool giaFatto=GlobalVariableCheck(gv);
   if(InpImpostaSL && !giaFatto && (sl==0.0 || InpSovrascriviSL))
     {
      double a;
      if(ATR(s,a))
        {
         double cand=(tipo==POSITION_TYPE_BUY)?apertura-InpATRMoltSL*a:apertura+InpATRMoltSL*a;
         cand=Norm(s,cand);
         bool ok=(tipo==POSITION_TYPE_BUY)?(cand<bid-stopLiv):(cand>ask+stopLiv);
         if(ok){ nuovoSL=cand; }
         else Diario(s,tk,t,"SL non valido (troppo vicino al prezzo)",cand,tp,"");
        }
     }

   //--- TARGET: mediana, aggiornata al cambio di candela (o subito alla prima volta)
   double nuovoTP=tp;
   if(InpAggiornaTP)
     {
      double m;
      if(Mediana(s,m))
        {
         m=Norm(s,m);
         bool ok=(tipo==POSITION_TYPE_BUY)?(m>bid+stopLiv):(m<ask-stopLiv);
         if(ok) nuovoTP=m;
         else Diario(s,tk,t,"TP non aggiornato (mediana dal lato sbagliato o troppo vicina)",nuovoSL,m,"");
        }
     }

   bool cambiaSL=(MathAbs(nuovoSL-sl)>pt*0.5), cambiaTP=(MathAbs(nuovoTP-tp)>pt*0.5);
   if(!cambiaSL && !cambiaTP) return;
   if(trade.PositionModify(tk,nuovoSL,nuovoTP))
     {
      if(cambiaSL) GlobalVariableSet(gv,1.0);
      Diario(s,tk,t,(cambiaSL?"SL impostato ":"")+(cambiaTP?"TP aggiornato":""),nuovoSL,nuovoTP,"");
     }
   else Diario(s,tk,t,"MODIFICA RIFIUTATA errore "+(string)GetLastError(),nuovoSL,nuovoTP,"");
  }

int OnInit()
  {
   trade.SetDeviationInPoints(20);
   EventSetTimer(1);
   Print("[ABTG_Manager] v1.00 avviato: gestisce solo posizioni (magic ",InpMagicGestito,"), niente ingressi, niente trailing.");
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason){ EventKillTimer(); }

void Ciclo()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i); if(tk==0) continue;
      string s=PositionGetString(POSITION_SYMBOL);
      if(!InpTuttiSimboli && s!=_Symbol) continue;
      if(InpMagicGestito>=0 && PositionGetInteger(POSITION_MAGIC)!=InpMagicGestito) continue;
      int k=Idx(s);
      datetime b0=iTime(s,TF(),0);
      bool nuova=(b0!=0 && b0!=g_ultimaBarra[k]);
      Gestisci(s,tk,nuova);
     }
   // aggiorna le barre viste DOPO aver gestito tutte le posizioni
   for(int k=0;k<ArraySize(g_nomi);k++){ datetime b=iTime(g_nomi[k],TF(),0); if(b!=0) g_ultimaBarra[k]=b; }
  }

void OnTimer(){ Ciclo(); }
void OnTick(){ Ciclo(); }
