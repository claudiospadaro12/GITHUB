//+------------------------------------------------------------------+
//|                                        ABTG_SuperWave_EA.mq5      |
//|                                                                  |
//|  Versione EA (backtestabile) della strategia SUPERWAVE - variante A:|
//|   - DIREZIONE: Supertrend (ATR 10, molt. 3.5) su H4               |
//|   - INGRESSO: quando il Supertrend M3 si INVERTE nella stessa     |
//|     direzione dell'H4 (confluenza), a mercato                    |
//|   - STOP: linea del Supertrend M3, con FLOOR minimo = N*ATR       |
//|   - 3 TARGET: sui livelli di PRICE ACTION (riserva a multipli R)  |
//|   - SIZE: rischio % diviso 40/30/30 su 3 ordini; break-even       |
//|     sui restanti dopo che il TP1 e' stato preso                  |
//|                                                                  |
//|  Si lancia nello Strategy Tester (Periodo = M3) per avere i       |
//|  numeri: profitto, win rate, profit factor, drawdown.            |
//|  ⚠️ Nessun EA garantisce profitti. TESTA SU DEMO.                 |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#include <Trade/Trade.mqh>

input group "=== Strategia ==="
input ENUM_TIMEFRAMES InpDirTF    = PERIOD_H4;  // Timeframe DIREZIONE (trend)
input ENUM_TIMEFRAMES InpEntryTF  = PERIOD_M3;  // Timeframe INGRESSO
input int    InpAtrPeriod   = 10;    // ATR del Supertrend
input double InpStMult      = 3.5;   // Moltiplicatore Supertrend
input int    InpEntryFlipBars = 1;   // entra se M3 ha invertito entro N barre chiuse
input bool   InpAllowLong   = true;  // consenti long
input bool   InpAllowShort  = true;  // consenti short
input group "=== Stop / Target ==="
input double InpStopAtrFloor= 1.0;   // stop minimo = N*ATR (0=solo Supertrend)
input bool   InpUsePAtp     = true;  // TP sui livelli di price action (altrimenti multipli R)
input int    InpFractal     = 2;     // ampiezza swing per i livelli
input int    InpLevelsLook  = 300;   // barre analizzate per i livelli
input double InpTP1_R       = 1.0;   // TP1 in R (riserva / modo R)
input double InpTP2_R       = 2.0;   // TP2 in R
input double InpTP3_R       = 3.0;   // TP3 in R
input group "=== Rischio ==="
input double InpRiskPct     = 1.0;   // rischio per operazione, % del conto
input double InpSize1       = 40;    // % size sul TP1
input double InpSize2       = 30;    // % size sul TP2
input double InpSize3       = 30;    // % size sul TP3
input bool   InpBEafterTP1  = true;  // stop a pari sui restanti dopo il TP1
input group "=== Generali ==="
input long   InpMagic       = 990001;
input int    InpMaxSpreadPts= 0;     // spread max in punti (0 = nessun limite)
input bool   InpVerbose     = false;

CTrade   gTrade;
datetime gLastBar=0;
ulong    gT1=0,gT2=0,gT3=0;
double   gEntry=0;
int      gDir=0;
bool     gBEdone=false;
int      hAtrEntry=INVALID_HANDLE;

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(20);
   hAtrEntry=iATR(_Symbol,InpEntryTF,InpAtrPeriod);
   if(hAtrEntry==INVALID_HANDLE) return(INIT_FAILED);
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason){ if(hAtrEntry!=INVALID_HANDLE) IndicatorRelease(hAtrEntry); }

//+------------------------------------------------------------------+
//| Supertrend su sym/tf: ritorna dir, valore linea, barre dal flip  |
//+------------------------------------------------------------------+
bool STcalc(string sym,ENUM_TIMEFRAMES tf,int &dir,double &line,int &barsSince)
  {
   dir=0; line=0; barsSince=-1;
   int need=InpAtrPeriod+80;
   MqlRates r[];
   int n=CopyRates(sym,tf,0,need,r);
   if(n<InpAtrPeriod+10) return false;
   double atr[]; ArrayResize(atr,n); double sum=0;
   for(int i=1;i<n;i++)
     {
      double hl=r[i].high-r[i].low, hc=MathAbs(r[i].high-r[i-1].close), lc=MathAbs(r[i].low-r[i-1].close);
      double tr=MathMax(hl,MathMax(hc,lc));
      if(i<=InpAtrPeriod){ sum+=tr; atr[i]=sum/InpAtrPeriod; }
      else atr[i]=(atr[i-1]*(InpAtrPeriod-1)+tr)/InpAtrPeriod;
     }
   double up[],dn[],val[]; int d[];
   ArrayResize(up,n);ArrayResize(dn,n);ArrayResize(val,n);ArrayResize(d,n);
   int start=InpAtrPeriod+1;
   for(int i=start;i<n;i++)
     {
      double mid=(r[i].high+r[i].low)/2.0, ub=mid+InpStMult*atr[i], lb=mid-InpStMult*atr[i];
      if(i==start){ up[i]=ub; dn[i]=lb; d[i]=(r[i].close>=mid)?1:-1; val[i]=lb; continue; }
      up[i]=(ub<up[i-1] || r[i-1].close>up[i-1]) ? ub : up[i-1];
      dn[i]=(lb>dn[i-1] || r[i-1].close<dn[i-1]) ? lb : dn[i-1];
      if(r[i].close>up[i-1])      d[i]=1;
      else if(r[i].close<dn[i-1]) d[i]=-1;
      else                        d[i]=d[i-1];
      val[i]=(d[i]>0)?dn[i]:up[i];
     }
   int last=n-2;
   if(last<start+1) return false;
   dir=d[last]; line=val[last];
   int bs=0; for(int i=last;i>start;i--){ if(d[i]==dir) bs++; else break; }
   barsSince=bs-1;
   return true;
  }
//+------------------------------------------------------------------+
bool NearAny(double &arr[],double p,double tol)
  { for(int i=0;i<ArraySize(arr);i++) if(MathAbs(arr[i]-p)<tol) return true; return false; }
//+------------------------------------------------------------------+
void ComputeTPs(int dir,double entry,double risk,double &t1,double &t2,double &t3)
  {
   double rr[3]; rr[0]=InpTP1_R; rr[1]=InpTP2_R; rr[2]=InpTP3_R;
   t1=(dir>0)?entry+rr[0]*risk:entry-rr[0]*risk;   // riserva a multipli R
   t2=(dir>0)?entry+rr[1]*risk:entry-rr[1]*risk;
   t3=(dir>0)?entry+rr[2]*risk:entry-rr[2]*risk;
   if(!InpUsePAtp) return;

   MqlRates r[];
   int want=MathMin(InpLevelsLook+InpFractal+2,2000);
   int n=CopyRates(_Symbol,InpEntryTF,0,want,r);
   int k=InpFractal; if(k<1) k=1;
   if(n<k*2+5) return;
   double res[],sup[]; ArrayResize(res,0); ArrayResize(sup,0);
   for(int i=k;i<n-k;i++)
     {
      bool sh=true, sl=true;
      for(int j=1;j<=k;j++)
        { if(r[i].high<r[i-j].high || r[i].high<r[i+j].high) sh=false;
          if(r[i].low >r[i-j].low  || r[i].low >r[i+j].low)  sl=false; }
      if(sh && r[i].high>entry){ int m=ArraySize(res); ArrayResize(res,m+1); res[m]=r[i].high; }
      if(sl && r[i].low <entry){ int m=ArraySize(sup); ArrayResize(sup,m+1); sup[m]=r[i].low; }
     }
   ArraySort(res); ArraySort(sup);
   double cand[]; ArrayResize(cand,0); double tol=risk*0.4;
   if(dir>0)
      for(int i=0;i<ArraySize(res) && ArraySize(cand)<3;i++)
        { double p=res[i]; if(p<=entry+risk*0.2 || NearAny(cand,p,tol)) continue;
          int m=ArraySize(cand);ArrayResize(cand,m+1);cand[m]=p; }
   else
      for(int i=ArraySize(sup)-1;i>=0 && ArraySize(cand)<3;i--)
        { double p=sup[i]; if(p>=entry-risk*0.2 || NearAny(cand,p,tol)) continue;
          int m=ArraySize(cand);ArrayResize(cand,m+1);cand[m]=p; }
   for(int i=0;i<3 && ArraySize(cand)<3;i++)
     { double p=(dir>0)?entry+rr[i]*risk:entry-rr[i]*risk;
       if(NearAny(cand,p,tol)) continue; int m=ArraySize(cand);ArrayResize(cand,m+1);cand[m]=p; }
   for(int a=0;a<ArraySize(cand);a++) for(int b=a+1;b<ArraySize(cand);b++)
      if(MathAbs(cand[b]-entry)<MathAbs(cand[a]-entry)){ double t=cand[a];cand[a]=cand[b];cand[b]=t; }
   if(ArraySize(cand)>0) t1=cand[0];
   if(ArraySize(cand)>1) t2=cand[1];
   if(ArraySize(cand)>2) t3=cand[2];
  }
//+------------------------------------------------------------------+
double NormLots(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st+0.0000001)*st;
   if(v<mn) v=0.0;
   return v;
  }
//+------------------------------------------------------------------+
int CountOpen()
  {
   int c=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetInteger(POSITION_MAGIC)==InpMagic && PositionGetString(POSITION_SYMBOL)==_Symbol) c++;
     }
   return c;
  }
//+------------------------------------------------------------------+
void MoveSL(ulong tk,double newSL)
  {
   if(tk==0 || !PositionSelectByTicket(tk)) return;
   double tp=PositionGetDouble(POSITION_TP);
   gTrade.PositionModify(tk,NormalizeDouble(newSL,_Digits),tp);
  }
//+------------------------------------------------------------------+
void ManageBE()
  {
   if(!InpBEafterTP1 || gBEdone || gT1==0) return;
   if(!PositionSelectByTicket(gT1))   // il primo ordine (TP1) non c'e' piu'
     {
      double px=(gDir>0)?SymbolInfoDouble(_Symbol,SYMBOL_BID):SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      bool tp1hit=(gDir>0)? (px>=gEntry) : (px<=gEntry);   // chiuso in profitto = TP1 preso
      if(tp1hit){ MoveSL(gT2,gEntry); MoveSL(gT3,gEntry); }
      gBEdone=true;
     }
  }
//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpreadPts<=0) return true;
   double sp=(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-SymbolInfoDouble(_Symbol,SYMBOL_BID))/_Point;
   return (sp<=InpMaxSpreadPts);
  }
//+------------------------------------------------------------------+
void TryEnter()
  {
   int dH4,dM3,bsH4,bsM3; double lH4,lM3;
   if(!STcalc(_Symbol,InpDirTF,dH4,lH4,bsH4)) return;
   if(!STcalc(_Symbol,InpEntryTF,dM3,lM3,bsM3)) return;
   if(dM3==0 || dH4==0 || dM3!=dH4) return;                 // serve confluenza H4/M3
   if(bsM3<0 || bsM3>=InpEntryFlipBars) return;             // M3 appena invertito (fresco)
   int dir=dM3;
   if(dir>0 && !InpAllowLong)  return;
   if(dir<0 && !InpAllowShort) return;
   if(!SpreadOK()) return;

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=(dir>0)?ask:bid;
   double stop=lM3;
   double ab[]; double atrv=0;
   if(CopyBuffer(hAtrEntry,0,1,1,ab)==1 && ab[0]>0 && ab[0]<entry) atrv=ab[0];
   double fl=InpStopAtrFloor*atrv;
   if(fl>0 && MathAbs(entry-stop)<fl) stop=(dir>0)?entry-fl:entry+fl;
   if((dir>0 && stop>=entry) || (dir<0 && stop<=entry)) return;   // stop non valido
   double risk=MathAbs(entry-stop);
   if(risk<=0) return;

   double tp1,tp2,tp3; ComputeTPs(dir,entry,risk,tp1,tp2,tp3);

   double riskMoney=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPct/100.0;
   double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE), ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double lossPerLot=(ts>0)?(risk/ts)*tv:0;
   double tot=(lossPerLot>0)?riskMoney/lossPerLot:0;
   double L1=NormLots(tot*InpSize1/100.0), L2=NormLots(tot*InpSize2/100.0), L3=NormLots(tot*InpSize3/100.0);
   if(L1<=0 && L2<=0 && L3<=0) return;

   gEntry=entry; gDir=dir; gBEdone=false; gT1=0;gT2=0;gT3=0;
   double sl=NormalizeDouble(stop,_Digits);
   if(L1>0){ if(dir>0?gTrade.Buy(L1,_Symbol,0,sl,NormalizeDouble(tp1,_Digits),"SW1"):gTrade.Sell(L1,_Symbol,0,sl,NormalizeDouble(tp1,_Digits),"SW1")) gT1=gTrade.ResultOrder(); }
   if(L2>0){ if(dir>0?gTrade.Buy(L2,_Symbol,0,sl,NormalizeDouble(tp2,_Digits),"SW2"):gTrade.Sell(L2,_Symbol,0,sl,NormalizeDouble(tp2,_Digits),"SW2")) gT2=gTrade.ResultOrder(); }
   if(L3>0){ if(dir>0?gTrade.Buy(L3,_Symbol,0,sl,NormalizeDouble(tp3,_Digits),"SW3"):gTrade.Sell(L3,_Symbol,0,sl,NormalizeDouble(tp3,_Digits),"SW3")) gT3=gTrade.ResultOrder(); }
   if(InpVerbose) PrintFormat("[SuperWave] %s entry %.5f stop %.5f tp %.5f/%.5f/%.5f lots %.2f/%.2f/%.2f",
                              (dir>0?"BUY":"SELL"),entry,stop,tp1,tp2,tp3,L1,L2,L3);
  }
//+------------------------------------------------------------------+
void OnTick()
  {
   ManageBE();
   datetime bt=iTime(_Symbol,InpEntryTF,0);
   if(bt==gLastBar) return;      // solo alla nuova barra dell'entry-TF
   gLastBar=bt;
   if(CountOpen()>0) return;     // un set di ordini alla volta
   TryEnter();
  }
//+------------------------------------------------------------------+
