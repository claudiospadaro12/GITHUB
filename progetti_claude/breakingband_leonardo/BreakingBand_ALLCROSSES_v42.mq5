//+------------------------------------------------------------------+
//|  BREAKING BAND EA v4.2                                           |
//|                                                                  |
//|  LOGICA:                                                         |
//|  1. Prezzo tocca una banda BB → BULGE rilevato                   |
//|     Salvati: livello banda impulso, livello banda opposta,        |
//|     mediana e ATR al momento del bulge (valori fissi)            |
//|                                                                  |
//|  2. CONTINUAZIONE (1a e 2a bulge nella stessa dir.):             |
//|     Attende che il prezzo raggiunga il livello SALVATO           |
//|     della banda opposta (non la banda corrente che si            |
//|     contrae!). Entry LIMIT li. Dir. = dir. del bulge.            |
//|     SL = 3×ATR(salvato) | TP = mediana corrente                 |
//|                                                                  |
//|  3. INVERSIONE (3a bulge nella stessa dir.):                     |
//|     Prezzo esausto. Attende ritorno alla banda originale         |
//|     (livello salvato) dopo aver toccato la mediana.             |
//|     Entry LIMIT li CONTRO il bulge.                              |
//|     SL = 3×ATR(salvato) | TP = mediana corrente                 |
//|                                                                  |
//|  CONTATORE: incrementa SOLO se dall'ultimo bulge il prezzo      |
//|  ha raggiunto la banda opposta (retrace reale confermato).       |
//|  Timeout senza retrace → hard reset contatore.                  |
//+------------------------------------------------------------------+
#property copyright "Breaking Band EA v4.2"
#property version   "4.20"
#property description "Livelli salvati al bulge | 1a/2a=CONT | 3a=INV | 28 pair"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>

//============================================================
//  PAIR
//============================================================
input group "=== MAJORS ==="
input bool P_EURUSD=true; input bool P_GBPUSD=true;
input bool P_USDJPY=true; input bool P_USDCHF=true;
input bool P_USDCAD=true; input bool P_AUDUSD=true; input bool P_NZDUSD=true;
input group "=== EUR CROSS ==="
input bool P_EURGBP=true; input bool P_EURJPY=true; input bool P_EURCHF=true;
input bool P_EURCAD=true; input bool P_EURAUD=true; input bool P_EURNZD=true;
input group "=== GBP CROSS ==="
input bool P_GBPJPY=true; input bool P_GBPCHF=true; input bool P_GBPCAD=true;
input bool P_GBPAUD=true; input bool P_GBPNZD=true;
input group "=== JPY CROSS ==="
input bool P_CADJPY=true; input bool P_AUDJPY=true;
input bool P_NZDJPY=true; input bool P_CHFJPY=true;
input group "=== AUD CROSS ==="
input bool P_AUDCAD=true; input bool P_AUDCHF=true; input bool P_AUDNZD=true;
input group "=== ALTRI ==="
input bool P_NZDCAD=true; input bool P_NZDCHF=true; input bool P_CADCHF=true;

//============================================================
//  PARAMETRI
//============================================================
input group "=== BOLLINGER BANDS (Protocollo v.11) ==="
input int    InpBBPer   = 20;
input double InpBBDev   = 2.0;
input group "=== ATR ==="
input int    InpATRPer  = 14;
input group "=== RISK MANAGEMENT ==="
input double InpRiskPct = 2.0;   // 2% per trade (Protocollo)
input double InpSLMult  = 3.0;   // SL = 3×ATR (Protocollo v.11)
input int    InpMaxPos  = 10;
input bool   InpBE      = true;
input double InpBEMult  = 1.0;   // BE attivo a 1×ATR di profitto
input group "=== TIMEOUT ==="
input int    InpTimeout = 40;    // Barre max attesa
input group "=== GENERALE ==="
input long   InpMagic   = 20250001;
input bool   InpDebug   = false;
input bool   InpLog     = true;

//============================================================
//  STRUTTURE
//============================================================
#define MAX_SYM 28

enum SYM_STATE { SS_SCAN, SS_CONT, SS_INV_MED, SS_INV_RET, SS_ACTIVE };

struct SymState {
   string    name;
   bool      on;
   int       hBB, hATR;
   SYM_STATE state;
   int       cnt;

   // Contatore bulge
   int    bulgeDir;        // Direzione sequenza corrente (+1/-1/0)
   int    bulgeCount;      // Bulge consecutivi nella stessa dir.
   bool   oppReached;      // Il prezzo ha raggiunto oppBand? (retrace reale)

   // Valori SALVATI al momento del bulge (NON aggiornati dopo)
   double impBand;    // Livello banda rotta dal bulge
   double oppBand;    // Livello banda opposta al momento del bulge
   double medAtBulge; // Mediana al momento del bulge (riferimento)
   double atrSaved;   // ATR al momento del bulge (per SL)

   ulong    ticket;
   datetime lastBar;
   int      wins, losses, sigs, ords;
   double   profit, loss;
};

//============================================================
//  GLOBALI
//============================================================
SymState      sym[MAX_SYM];
int           nSym=0;
CTrade        trade;
CPositionInfo posInfo;
COrderInfo    ordInfo;

//============================================================
//  OnInit
//============================================================
int OnInit(){
   Print("================================================");
   Print("BREAKING BAND v4.2 | Livelli salvati al bulge");
   Print("1a/2a=CONT | 3a=INV | SL=3xATR | Risk=2%");
   Print("================================================");
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints(20);
   trade.SetTypeFilling(ORDER_FILLING_IOC);

   string nm[MAX_SYM]={"EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
      "EURGBP","EURJPY","EURCHF","EURCAD","EURAUD","EURNZD",
      "GBPJPY","GBPCHF","GBPCAD","GBPAUD","GBPNZD",
      "CADJPY","AUDJPY","NZDJPY","CHFJPY",
      "AUDCAD","AUDCHF","AUDNZD","NZDCAD","NZDCHF","CADCHF"};
   bool fl[MAX_SYM]={P_EURUSD,P_GBPUSD,P_USDJPY,P_USDCHF,P_USDCAD,P_AUDUSD,P_NZDUSD,
      P_EURGBP,P_EURJPY,P_EURCHF,P_EURCAD,P_EURAUD,P_EURNZD,
      P_GBPJPY,P_GBPCHF,P_GBPCAD,P_GBPAUD,P_GBPNZD,
      P_CADJPY,P_AUDJPY,P_NZDJPY,P_CHFJPY,
      P_AUDCAD,P_AUDCHF,P_AUDNZD,P_NZDCAD,P_NZDCHF,P_CADCHF};

   nSym=0;
   for(int i=0;i<MAX_SYM;i++){
      if(!fl[i]) continue;
      if(!SymbolSelect(nm[i],true)){Print("SKIP: ",nm[i]);continue;}
      ZeroMemory(sym[nSym]);
      sym[nSym].name =nm[i]; sym[nSym].on=true; sym[nSym].state=SS_SCAN;
      sym[nSym].hBB  =iBands(nm[i],PERIOD_CURRENT,InpBBPer,0,InpBBDev,PRICE_CLOSE);
      sym[nSym].hATR =iATR  (nm[i],PERIOD_CURRENT,InpATRPer);
      if(sym[nSym].hBB==INVALID_HANDLE||sym[nSym].hATR==INVALID_HANDLE)
         {Print("ERR: ",nm[i]);continue;}
      Print("ON: ",nm[i]); nSym++;
   }
   if(nSym==0){Alert("Nessun pair!");return INIT_FAILED;}
   Print("Pair: ",nSym);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason){
   CollectStats();
   Print("==============================================");
   Print("RANKING — BREAKING BAND v4.2");
   Print("==============================================");
   for(int i=0;i<nSym;i++){IndicatorRelease(sym[i].hBB);IndicatorRelease(sym[i].hATR);}
   PrintRank();
   Comment("");
}

//============================================================
//  INDICATORI
//============================================================
double BBU(SymState &s,int sh=1){double b[1];CopyBuffer(s.hBB,1,sh,1,b);return b[0];}
double BBL(SymState &s,int sh=1){double b[1];CopyBuffer(s.hBB,2,sh,1,b);return b[0];}
double BBM(SymState &s,int sh=1){double b[1];CopyBuffer(s.hBB,0,sh,1,b);return b[0];}
double ATR(SymState &s,int sh=1){double b[1];CopyBuffer(s.hATR,0,sh,1,b);return b[0];}
double Hi (SymState &s,int sh)  {return iHigh(s.name,PERIOD_CURRENT,sh);}
double Lo (SymState &s,int sh)  {return iLow (s.name,PERIOD_CURRENT,sh);}
double Cl (SymState &s,int sh)  {return iClose(s.name,PERIOD_CURRENT,sh);}

//============================================================
//  OnTick
//============================================================
void OnTick(){
   if(InpBE) DoBreakEven();
   UpdateTP();
   for(int i=0;i<nSym;i++){
      if(!sym[i].on) continue;
      datetime bar=iTime(sym[i].name,PERIOD_CURRENT,0);
      if(bar==sym[i].lastBar) continue;
      sym[i].lastBar=bar;
      if(sym[i].state==SS_ACTIVE){CheckActive(sym[i]);continue;}
      if(CountPos()>=InpMaxPos) continue;
      switch(sym[i].state){
         case SS_SCAN:    DoScan   (sym[i]); break;
         case SS_CONT:    DoCont   (sym[i]); break;
         case SS_INV_MED: DoInvMed (sym[i]); break;
         case SS_INV_RET: DoInvRet (sym[i]); break;
         default: Reset(sym[i]); break;
      }
      sym[i].cnt++;
   }
   ShowDash();
}

//============================================================
//  SS_SCAN
//  Rileva quando il prezzo tocca una banda.
//  Salva i livelli al momento del tocco (impBand, oppBand,
//  medAtBulge, atrSaved) — questi non cambieranno mai.
//
//  CONTATORE:
//  - Stessa dir + oppReached=true  → onda separata, count++
//  - Stessa dir + oppReached=false → stesso trend, count=1
//  - Direzione opposta             → nuova sequenza, count=1
//  - Timeout precedente (count=0)  → fresh start, count=1
//============================================================
void DoScan(SymState &s){
   double bu=BBU(s,1), bl=BBL(s,1), med=BBM(s,1), atr=ATR(s,1);
   double hi=Hi(s,1),  lo=Lo(s,1);

   bool bUp=(hi>=bu);
   bool bDn=(lo<=bl);
   if(!bUp && !bDn) return;

   int newDir = bUp ? 1 : -1;

   // Aggiorna contatore
   if(s.bulgeDir==0 || newDir!=s.bulgeDir){
      // Prima volta o cambio di direzione
      s.bulgeDir   = newDir;
      s.bulgeCount = 1;
   } else if(s.oppReached){
      // Stessa direzione E il prezzo aveva raggiunto la banda opposta
      // → questa e' una vera seconda/terza onda separata
      s.bulgeCount++;
      if(s.bulgeCount>3) s.bulgeCount=3;
   } else {
      // Stessa direzione ma senza retrace confermato → stesso trend
      s.bulgeCount=1;
   }

   // Salva i livelli CORRENTI come riferimento fisso
   s.impBand    = (newDir==1) ? bu  : bl;
   s.oppBand    = (newDir==1) ? bl  : bu;
   s.medAtBulge = med;
   s.atrSaved   = atr;
   s.oppReached = false;  // Reset: serve nuovo retrace prima di contare prossimo

   s.sigs++; s.cnt=0;

   if(InpDebug)
      PrintFormat("%s BULGE #%d dir=%d | imp=%.5f opp=%.5f med=%.5f atr=%.5f",
                  s.name,s.bulgeCount,newDir,s.impBand,s.oppBand,s.medAtBulge,s.atrSaved);

   s.state = (s.bulgeCount<=2) ? SS_CONT : SS_INV_MED;
}

//============================================================
//  SS_CONT — CONTINUAZIONE (1a e 2a bulge)
//
//  Attende che il prezzo raggiunga s.oppBand (livello FISSO
//  salvato al momento del bulge, NON la banda corrente).
//
//  Perche' il livello salvato e non quello corrente?
//  Dopo il bulge le bande si CONTRAGGONO durante il retrace.
//  La banda corrente si avvicina al prezzo, generando falsi
//  tocchi. Il livello salvato richiede un retrace completo.
//
//  Bulge up   → attende Lo(1) <= s.oppBand → BuyLimit
//  Bulge down → attende Hi(1) >= s.oppBand → SellLimit
//  SL = s.atrSaved × 3 oltre s.oppBand
//  TP = mediana corrente (si aggiorna ogni barra)
//============================================================
void DoCont(SymState &s){
   if(s.cnt>InpTimeout){
      // Timeout: nessun retrace → hard reset contatore
      s.bulgeCount=0; s.bulgeDir=0; s.oppReached=false;
      Reset(s); return;
   }

   double med=BBM(s,1); // TP dinamico: mediana corrente

   bool reached=false;
   int  dir=0;
   double ent=0, sl=0, tp=0;

   if(s.bulgeDir==1 && Lo(s,1)<=s.oppBand){
      // Prezzo ha raggiunto il livello SALVATO della banda inferiore
      reached=true; dir=1;
      ent = s.oppBand;
      sl  = ent - InpSLMult*s.atrSaved;
      tp  = med;
   }
   else if(s.bulgeDir==-1 && Hi(s,1)>=s.oppBand){
      // Prezzo ha raggiunto il livello SALVATO della banda superiore
      reached=true; dir=-1;
      ent = s.oppBand;
      sl  = ent + InpSLMult*s.atrSaved;
      tp  = med;
   }

   if(!reached) return;

   // Segna che il retrace e' avvenuto (per contatore del prossimo bulge)
   s.oppReached=true;

   // RR minimo: TP deve essere almeno 0.5×ATR dall'entry
   if(MathAbs(tp-ent)<s.atrSaved*0.5){Reset(s);return;}

   if(PlaceOrder(s,dir,ent,sl,tp,"CONT"))
      {s.state=SS_ACTIVE;s.cnt=0;s.ords++;}
   else
      Reset(s);
}

//============================================================
//  SS_INV_MED — INVERSIONE fase 1 (3a bulge)
//
//  Prezzo esausto. Attende che rientri verso la mediana
//  SENZA toccare s.oppBand (livello salvato).
//  Se tocca s.oppBand → non e' esaurimento → reset.
//  Quando raggiunge la mediana corrente → SS_INV_RET.
//============================================================
void DoInvMed(SymState &s){
   if(s.cnt>InpTimeout){
      s.bulgeCount=0; s.bulgeDir=0; s.oppReached=false;
      Reset(s); return;
   }

   double med=BBM(s,1);
   double hi=Hi(s,1), lo=Lo(s,1), cl=Cl(s,1);

   // Invalidazione: raggiunge il livello salvato della banda opposta
   if(s.bulgeDir== 1 && lo<=s.oppBand){Reset(s);return;}
   if(s.bulgeDir==-1 && hi>=s.oppBand){Reset(s);return;}

   // Il prezzo tocca la mediana corrente → passa a fase 2
   bool atMed=(s.bulgeDir==1)?(lo<=med||cl<=med*1.001)
                              :(hi>=med||cl>=med*0.999);
   if(atMed){
      s.state=SS_INV_RET; s.cnt=0;
      if(InpDebug) PrintFormat("%s INV_MED→INV_RET",s.name);
   }
}

//============================================================
//  SS_INV_RET — INVERSIONE fase 2 (3a bulge)
//
//  Prezzo ha toccato la mediana. Ora torna verso s.impBand
//  (livello SALVATO della banda originale).
//  Quando lo raggiunge → LIMIT CONTRO il bulge.
//
//  Bulge up   → prezzo torna a s.impBand → SellLimit
//  Bulge down → prezzo torna a s.impBand → BuyLimit
//  SL = s.atrSaved × 3 oltre s.impBand
//  TP = mediana corrente
//============================================================
void DoInvRet(SymState &s){
   if(s.cnt>InpTimeout){
      s.bulgeCount=0; s.bulgeDir=0; s.oppReached=false;
      Reset(s); return;
   }

   double med=BBM(s,1);
   double hi=Hi(s,1), lo=Lo(s,1);

   // Invalidazione: tocca la banda opposta (ancora forza)
   if(s.bulgeDir== 1 && lo<=s.oppBand){Reset(s);return;}
   if(s.bulgeDir==-1 && hi>=s.oppBand){Reset(s);return;}

   bool reached=false;
   int  dir=0;
   double ent=0, sl=0, tp=0;

   if(s.bulgeDir==1 && hi>=s.impBand){
      // Prezzo torna al livello salvato della banda superiore → SellLimit (CONTRO)
      reached=true; dir=-1;
      ent = s.impBand;
      sl  = ent + InpSLMult*s.atrSaved;
      tp  = med;
   }
   else if(s.bulgeDir==-1 && lo<=s.impBand){
      // Prezzo torna al livello salvato della banda inferiore → BuyLimit (CONTRO)
      reached=true; dir=1;
      ent = s.impBand;
      sl  = ent - InpSLMult*s.atrSaved;
      tp  = med;
   }

   if(!reached) return;
   if(MathAbs(tp-ent)<s.atrSaved*0.5){Reset(s);return;}

   if(PlaceOrder(s,dir,ent,sl,tp,"INV"))
      {s.state=SS_ACTIVE;s.cnt=0;s.ords++;}
   else
      Reset(s);
}

//============================================================
//  ORDINE LIMIT (unico tipo — mai market)
//============================================================
bool PlaceOrder(SymState &s,int dir,double ent,double sl,double tp,string tag){
   int    dg=(int)SymbolInfoInteger(s.name,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(s.name,SYMBOL_POINT);
   ent=NormalizeDouble(ent,dg); sl=NormalizeDouble(sl,dg); tp=NormalizeDouble(tp,dg);
   double lots=CalcLots(s.name,ent,sl);
   if(lots<=0) return false;
   double ask=SymbolInfoDouble(s.name,SYMBOL_ASK);
   double bid=SymbolInfoDouble(s.name,SYMBOL_BID);
   long   stlv=SymbolInfoInteger(s.name,SYMBOL_TRADE_STOPS_LEVEL);
   double mind=stlv*pt;
   string cmt="BB|"+tag+"|"+s.name+"|"+IntegerToString(InpMagic);
   bool ok=false;
   if(dir==1){
      if(ent>=bid-mind) ent=NormalizeDouble(bid-mind-pt*2,dg);
      sl=NormalizeDouble(ent-InpSLMult*s.atrSaved,dg);
      ok=trade.BuyLimit(lots,ent,s.name,sl,tp,ORDER_TIME_GTC,0,cmt);
   } else {
      if(ent<=ask+mind) ent=NormalizeDouble(ask+mind+pt*2,dg);
      sl=NormalizeDouble(ent+InpSLMult*s.atrSaved,dg);
      ok=trade.SellLimit(lots,ent,s.name,sl,tp,ORDER_TIME_GTC,0,cmt);
   }
   if(ok){
      s.ticket=trade.ResultOrder();
      if(InpLog) PrintFormat("[%s] %s %s lot=%.2f ent=%.5f sl=%.5f tp=%.5f",
                  s.name,(dir==1?"BuyLimit":"SellLimit"),tag,lots,ent,sl,tp);
   } else {
      PrintFormat("[%s] ERR %s: %s",s.name,tag,trade.ResultRetcodeDescription());
   }
   return ok;
}

//============================================================
//  CALCOLO LOTTI — 2% del saldo
//============================================================
double CalcLots(string sym_,double ent,double sl_){
   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double risk=bal*InpRiskPct/100.0;
   double tv=SymbolInfoDouble(sym_,SYMBOL_TRADE_TICK_VALUE);
   double ts=SymbolInfoDouble(sym_,SYMBOL_TRADE_TICK_SIZE);
   double pt=SymbolInfoDouble(sym_,SYMBOL_POINT);
   double dist=MathAbs(ent-sl_);
   if(dist<=0||ts<=0||tv<=0) return 0;
   double vpl=(tv/ts)*pt;
   if(vpl<=0) return 0;
   double lots=risk/(dist/pt*vpl);
   double mn=SymbolInfoDouble(sym_,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(sym_,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(sym_,SYMBOL_VOLUME_STEP);
   if(st>0) lots=MathFloor(lots/st)*st;
   return MathMax(mn,MathMin(mx,lots));
}

//============================================================
//  BREAK-EVEN
//============================================================
void DoBreakEven(){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(!posInfo.SelectByIndex(i)) continue;
      if(posInfo.Magic()!=InpMagic) continue;
      int idx=-1;
      for(int j=0;j<nSym;j++) if(sym[j].name==posInfo.Symbol()){idx=j;break;}
      if(idx<0) continue;
      double op=posInfo.PriceOpen(), curSL=posInfo.StopLoss();
      int dg=(int)SymbolInfoInteger(posInfo.Symbol(),SYMBOL_DIGITS);
      double pt=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_POINT);
      double atr=sym[idx].atrSaved; if(atr==0) atr=ATR(sym[idx],1);
      double bid=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_BID);
      double ask=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_ASK);
      if(posInfo.PositionType()==POSITION_TYPE_BUY){
         if((bid-op)>=InpBEMult*atr&&curSL<op)
            trade.PositionModify(posInfo.Ticket(),NormalizeDouble(op+pt,dg),posInfo.TakeProfit());
      } else {
         if((op-ask)>=InpBEMult*atr&&curSL>op)
            trade.PositionModify(posInfo.Ticket(),NormalizeDouble(op-pt,dg),posInfo.TakeProfit());
      }
   }
}

//============================================================
//  TP DINAMICO — mediana aggiornata ogni barra
//============================================================
void UpdateTP(){
   static datetime lc=0;
   datetime cb=iTime(_Symbol,PERIOD_CURRENT,0);
   if(cb==lc) return; lc=cb;
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(!posInfo.SelectByIndex(i)) continue;
      if(posInfo.Magic()!=InpMagic) continue;
      int idx=-1;
      for(int j=0;j<nSym;j++) if(sym[j].name==posInfo.Symbol()){idx=j;break;}
      if(idx<0) continue;
      double ntp=BBM(sym[idx],1);
      int dg=(int)SymbolInfoInteger(posInfo.Symbol(),SYMBOL_DIGITS);
      double ctp=posInfo.TakeProfit();
      bool ok=false;
      if(posInfo.PositionType()==POSITION_TYPE_BUY  &&NormalizeDouble(ntp,dg)>ctp) ok=true;
      if(posInfo.PositionType()==POSITION_TYPE_SELL &&NormalizeDouble(ntp,dg)<ctp) ok=true;
      if(ok) trade.PositionModify(posInfo.Ticket(),posInfo.StopLoss(),NormalizeDouble(ntp,dg));
   }
}

//============================================================
//  UTILITA'
//============================================================
void CheckActive(SymState &s){
   bool oo=false,po=false;
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(ordInfo.SelectByIndex(i)&&ordInfo.Magic()==InpMagic&&ordInfo.Symbol()==s.name){oo=true;break;}
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(posInfo.SelectByIndex(i)&&posInfo.Magic()==InpMagic&&posInfo.Symbol()==s.name){po=true;break;}
   if(!oo&&!po) Reset(s);
}

int CountPos(){
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
      if(posInfo.SelectByIndex(i)&&posInfo.Magic()==InpMagic) n++;
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(ordInfo.SelectByIndex(i)&&ordInfo.Magic()==InpMagic) n++;
   return n;
}

void Reset(SymState &s){
   s.state=SS_SCAN; s.cnt=0;
   s.impBand=0; s.oppBand=0; s.medAtBulge=0; s.atrSaved=0;
   s.ticket=0;
   // bulgeDir, bulgeCount, oppReached NON resettati qui
   // (si resettano solo su timeout o cambio direzione)
}

//============================================================
//  DASHBOARD
//============================================================
void ShowDash(){
   string sn[]={"SCAN","CONT","INV-M","INV-R","ACT"};
   string t="=== BB v4.2 | 1a/2a=CONT | 3a=INV ===\n";
   t+=StringFormat("Pair:%d | Pos:%d/%d | Risk:%.0f%% | SL:%.0fxATR\n",
                   nSym,CountPos(),InpMaxPos,InpRiskPct,InpSLMult);
   t+="---\n";
   for(int i=0;i<nSym;i++){
      int tot=sym[i].wins+sym[i].losses;
      double wr=(tot>0)?100.0*sym[i].wins/tot:0;
      t+=StringFormat("%-8s|%-5s|#%d|s:%d|o:%d|WR:%.0f%%\n",
                      sym[i].name,sn[(int)sym[i].state],
                      sym[i].bulgeCount,sym[i].sigs,sym[i].ords,wr);
   }
   Comment(t);
}

//============================================================
//  STATS E RANKING
//============================================================
void CollectStats(){
   if(!HistorySelect(0,TimeCurrent())) return;
   for(int d=0;d<HistoryDealsTotal();d++){
      ulong tk=HistoryDealGetTicket(d);
      if(!tk) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_OUT) continue;
      string ds=HistoryDealGetString(tk,DEAL_SYMBOL);
      double pnl=HistoryDealGetDouble(tk,DEAL_PROFIT)
                +HistoryDealGetDouble(tk,DEAL_SWAP)
                +HistoryDealGetDouble(tk,DEAL_COMMISSION);
      int idx=-1;
      for(int j=0;j<nSym;j++) if(sym[j].name==ds){idx=j;break;}
      if(idx<0) continue;
      if(pnl>0){sym[idx].wins++;sym[idx].profit+=pnl;}
      else      {sym[idx].losses++;sym[idx].loss+=pnl;}
   }
}

void PrintRank(){
   Print("--- WIN RATE ---");
   PrintFormat("%-10s %5s %5s %8s %8s %8s","PAIR","N","WR%","AVGW","AVGL","NET");
   int o[MAX_SYM]; for(int i=0;i<nSym;i++) o[i]=i;
   for(int i=0;i<nSym-1;i++)
      for(int j=0;j<nSym-i-1;j++){
         int a=o[j],b=o[j+1];
         int ta=sym[a].wins+sym[a].losses, tb=sym[b].wins+sym[b].losses;
         double wa=(ta>0)?100.0*sym[a].wins/ta:0;
         double wb=(tb>0)?100.0*sym[b].wins/tb:0;
         if(wa<wb){int tmp=o[j];o[j]=o[j+1];o[j+1]=tmp;}
      }
   for(int r=0;r<nSym;r++){
      int i=o[r];
      int n=sym[i].wins+sym[i].losses;
      if(n==0) continue;
      double wr=100.0*sym[i].wins/n;
      double aw=(sym[i].wins>0)?sym[i].profit/sym[i].wins:0;
      double al=(sym[i].losses>0)?sym[i].loss/sym[i].losses:0;
      PrintFormat("%-10s %5d %5.1f%% %8.2f %8.2f %8.2f",
                  sym[i].name,n,wr,aw,al,sym[i].profit+sym[i].loss);
   }
}
//+------------------------------------------------------------------+
