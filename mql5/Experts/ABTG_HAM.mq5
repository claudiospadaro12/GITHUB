//+------------------------------------------------------------------+
//|                                                   ABTG_HAM.mq5   |
//|  Porting fedele dello script Pine "HAM Style EMA+ST+HA - Claudio |
//|  v10" (e "HAM TEST WIDE") per il TESTER. Motore (Emiliano):      |
//|   EMA 9/21 incrocio + Supertrend(10; 3,5) concorde, filtro HA    |
//|   senza mecha contraria (2 candele), corpo >= 55% del range,     |
//|   distanza e pendenza EMA in ATR, ATR minimo in punti, conferme  |
//|   H1 (EMA 9/21), H4 e D1 (prezzo vs EMA21), punteggio, orario    |
//|   8-18 ora italiana, stop and reverse, SL 1,5 ATR, TP 2,5 ATR.   |
//|  DIFFERENZA VOLUTA dal Pine: i filtri H1/H4/D1 usano SOLO l'     |
//|  ultima candela CHIUSA (il Pine su storico vede la chiusura      |
//|  finale della candela superiore: informazione del futuro).       |
//|  Rischio 1% per operazione (solo per leggere R).                 |
//|  Criteri: report/HAM_CRITERI_2026-11-20.md                       |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gT;

input group "=== Motore (Emiliano) ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_M15;
input int    InpFastEMA   = 9;
input int    InpSlowEMA   = 21;
input int    InpStPeriod  = 10;
input double InpStMult    = 3.5;

input group "=== Heikin-Ashi e corpo ==="
input bool   InpUseHA     = true;
input int    InpHABars    = 2;
input double InpHAWick    = 0.3;
input bool   InpUseBody   = true;
input double InpMinBodyPct = 55.0;

input group "=== Qualita' ==="
input bool   InpUseEMADist = true;
input double InpMinEMADist = 0.08;
input bool   InpUseSlope   = true;
input int    InpSlopeBars  = 5;
input double InpMinSlope   = 0.03;
input bool   InpUseATRMin  = true;
input int    InpAtrLen     = 14;
input double InpMinATRPts  = 25.0;

input group "=== Multi-timeframe (ultima candela CHIUSA) ==="
input bool   InpUseMTF    = true;
input bool   InpUseH1     = true;
input bool   InpUseH4     = true;
input bool   InpUseD1     = true;

input group "=== Punteggio ==="
input bool   InpUseScore  = true;
input int    InpMinScore  = 70;

input group "=== Stop e target ==="
input bool   InpSAR       = true;
input double InpSLatr     = 1.5;
input double InpTPatr     = 2.5;
input double InpRiskPct   = 1.0;

input group "=== Orario (ora italiana) ==="
input bool   InpUseTime   = true;
input int    InpStartHour = 8;
input int    InpEndHour   = 18;

input group "=== Generali ==="
input long   InpMagic     = 771601;

int hF=INVALID_HANDLE,hS=INVALID_HANDLE,hAtr=INVALID_HANDLE,hStAtr=INVALID_HANDLE;
int hF1=INVALID_HANDLE,hS1=INVALID_HANDLE,hS4=INVALID_HANDLE,hSD=INVALID_HANDLE;
double stFU=0,stFL=0; int stDir=0;
double haOp=0,haCp=0; bool haInit=false;
double aO[6],aC[6],aH[6],aL[6];   // HA delle ultime barre chiuse, indice 0 = barra 1
bool   ready=false;
datetime lastBar=0;

int OnInit()
  {
   hF=iMA(_Symbol,InpTF,InpFastEMA,0,MODE_EMA,PRICE_CLOSE);
   hS=iMA(_Symbol,InpTF,InpSlowEMA,0,MODE_EMA,PRICE_CLOSE);
   hAtr=iATR(_Symbol,InpTF,InpAtrLen);
   hStAtr=iATR(_Symbol,InpTF,InpStPeriod);
   hF1=iMA(_Symbol,PERIOD_H1,InpFastEMA,0,MODE_EMA,PRICE_CLOSE);
   hS1=iMA(_Symbol,PERIOD_H1,InpSlowEMA,0,MODE_EMA,PRICE_CLOSE);
   hS4=iMA(_Symbol,PERIOD_H4,InpSlowEMA,0,MODE_EMA,PRICE_CLOSE);
   hSD=iMA(_Symbol,PERIOD_D1,InpSlowEMA,0,MODE_EMA,PRICE_CLOSE);
   if(hF==INVALID_HANDLE||hS==INVALID_HANDLE||hAtr==INVALID_HANDLE||hStAtr==INVALID_HANDLE||
      hF1==INVALID_HANDLE||hS1==INVALID_HANDLE||hS4==INVALID_HANDLE||hSD==INVALID_HANDLE) return(INIT_FAILED);
   gT.SetExpertMagicNumber(InpMagic);
   gT.SetDeviationInPoints(50);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hF!=INVALID_HANDLE) IndicatorRelease(hF);
   if(hS!=INVALID_HANDLE) IndicatorRelease(hS);
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hStAtr!=INVALID_HANDLE) IndicatorRelease(hStAtr);
   if(hF1!=INVALID_HANDLE) IndicatorRelease(hF1);
   if(hS1!=INVALID_HANDLE) IndicatorRelease(hS1);
   if(hS4!=INVALID_HANDLE) IndicatorRelease(hS4);
   if(hSD!=INVALID_HANDLE) IndicatorRelease(hSD);
  }

void StStep(double h,double l,double c,double prevClose,double atr)
  {
   double hl2=(h+l)/2.0;
   double bU=hl2+InpStMult*atr,bL=hl2-InpStMult*atr;
   double pFU=(stFU==0)?bU:stFU, pFL=(stFL==0)?bL:stFL;
   double fU=(bU<pFU||prevClose>pFU)?bU:pFU;
   double fL=(bL>pFL||prevClose<pFL)?bL:pFL;
   if(c>pFU) stDir=1; else if(c<pFL) stDir=-1;
   stFU=fU; stFL=fL;
  }

//--- aggiorna lo stato HA con una barra chiusa (o,h,l,c); sposta le ultime barre
void HAStep(double o,double h,double l,double c)
  {
   double hc=(o+h+l+c)/4.0;
   double ho=haInit?(haOp+haCp)/2.0:(o+c)/2.0;
   haInit=true; haOp=ho; haCp=hc;
   for(int i=5;i>0;i--){ aO[i]=aO[i-1]; aC[i]=aC[i-1]; aH[i]=aH[i-1]; aL[i]=aL[i-1]; }
   aO[0]=ho; aC[0]=hc; aH[0]=MathMax(h,MathMax(ho,hc)); aL[0]=MathMin(l,MathMin(ho,hc));
  }

bool Warm()
  {
   int need=700;
   MqlRates r[]; ArraySetAsSeries(r,true);
   if(CopyRates(_Symbol,InpTF,0,need,r)<need) return(false);
   double a[]; ArraySetAsSeries(a,true);
   if(CopyBuffer(hStAtr,0,0,need,a)<need) return(false);
   stFU=0; stFL=0; stDir=0; haInit=false;
   ArrayInitialize(aO,0); ArrayInitialize(aC,0); ArrayInitialize(aH,0); ArrayInitialize(aL,0);
   for(int i=need-2;i>=1;i--)
     {
      StStep(r[i].high,r[i].low,r[i].close,r[i+1].close,a[i]);
      HAStep(r[i].open,r[i].high,r[i].low,r[i].close);
     }
   return(true);
  }

bool IsEuDst(datetime utc)
  {
   MqlDateTime d; TimeToStruct(utc,d);
   if(d.mon<3||d.mon>10) return(false);
   if(d.mon>3&&d.mon<10) return(true);
   MqlDateTime x; x.year=d.year; x.mon=d.mon; x.day=31; x.hour=1; x.min=0; x.sec=0;
   datetime t=StructToTime(x);
   TimeToStruct(t,x);
   int back=x.day_of_week; // 0 = domenica
   t-=back*86400;
   if(d.mon==3) return(utc>=t);
   return(utc<t);
  }

int RomeHour(datetime serverTime)
  {
   datetime utc=serverTime-3600;                 // server BCM = GMT+1 fisso
   datetime rome=utc+(IsEuDst(utc)?7200:3600);
   MqlDateTime d; TimeToStruct(rome,d); return(d.hour);
  }

bool HavePos(int &type,ulong &ticket)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i); if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      type=(int)PositionGetInteger(POSITION_TYPE); ticket=tk; return(true);
     }
   return(false);
  }

double LotFor(bool buy,double entry,double sl)
  {
   double pf=0;
   if(!OrderCalcProfit(buy?ORDER_TYPE_BUY:ORDER_TYPE_SELL,_Symbol,1.0,entry,sl,pf)) return(0);
   double lossLot=-pf; if(lossLot<=0) return(0);
   double lot=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPct/100.0/lossLot;
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN),mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   if(lot<mn) return(0);
   if(lot>mx) lot=mx;
   return(NormalizeDouble(lot,2));
  }

bool HAok(bool wantLong)
  {
   if(!InpUseHA) return(true);
   for(int i=0;i<InpHABars&&i<6;i++)
     {
      double body=MathAbs(aC[i]-aO[i]);
      if(body<=0) return(false);
      if(wantLong)
        {
         if(!(aC[i]>aO[i])) return(false);
         double lw=MathMin(aO[i],aC[i])-aL[i];
         if(!((lw/body)<InpHAWick)) return(false);
        }
      else
        {
         if(!(aC[i]<aO[i])) return(false);
         double uw=aH[i]-MathMax(aO[i],aC[i]);
         if(!((uw/body)<InpHAWick)) return(false);
        }
     }
   return(true);
  }

void OnTick()
  {
   if(!ready){ if(!Warm()) return; ready=true; lastBar=iTime(_Symbol,InpTF,0); return; }
   datetime t0=iTime(_Symbol,InpTF,0);
   if(t0==lastBar) return;
   lastBar=t0;

   MqlRates r[]; ArraySetAsSeries(r,true);
   if(CopyRates(_Symbol,InpTF,0,3,r)<3) return;
   double sa[]; ArraySetAsSeries(sa,true);
   if(CopyBuffer(hStAtr,0,0,3,sa)<3) return;
   StStep(r[1].high,r[1].low,r[1].close,r[2].close,sa[1]);
   HAStep(r[1].open,r[1].high,r[1].low,r[1].close);

   double f[],s[],at[]; ArraySetAsSeries(f,true); ArraySetAsSeries(s,true); ArraySetAsSeries(at,true);
   int nsl=InpSlopeBars+1;
   if(CopyBuffer(hF,0,1,3,f)<3) return;
   if(CopyBuffer(hS,0,1,nsl+1,s)<nsl+1) return;
   if(CopyBuffer(hAtr,0,1,2,at)<2) return;
   double atr=at[0]; if(atr<=0) return;
   // f[0]=barra 1, f[1]=barra 2 ; s[0]=barra 1, s[InpSlopeBars]=barra 1+slope
   bool crossUp=(f[1]<=s[1]) && (f[0]>s[0]);
   bool crossDn=(f[1]>=s[1]) && (f[0]<s[0]);
   if(!crossUp && !crossDn) { /* nessun incrocio: niente segnale, ma lo stato e' aggiornato */ return; }
   bool wantLong=crossUp;
   // supertrend concorde
   if(wantLong && stDir!=1) return;
   if(!wantLong && stDir!=-1) return;

   // filtri
   bool haOK=HAok(wantLong);
   double range=r[1].high-r[1].low, body=MathAbs(r[1].close-r[1].open);
   double bodyPct=(range>0)?body/range*100.0:0;
   bool bodyOK=(!InpUseBody)||(bodyPct>=InpMinBodyPct);
   double dist=MathAbs(f[0]-s[0])/atr;
   bool distOK=(!InpUseEMADist)||(dist>=InpMinEMADist);
   double slope=s[0]-s[InpSlopeBars];
   bool slopeOK=(!InpUseSlope)||((MathAbs(slope)/atr>=InpMinSlope)&&(wantLong?slope>0:slope<0));
   bool atrOK=(!InpUseATRMin)||(atr/_Point>=InpMinATRPts);
   bool h1OK=true,h4OK=true,d1OK=true;
   if(InpUseMTF)
     {
      double a1[],b1[],c4[],cD[]; ArraySetAsSeries(a1,true); ArraySetAsSeries(b1,true); ArraySetAsSeries(c4,true); ArraySetAsSeries(cD,true);
      if(InpUseH1)
        {
         if(CopyBuffer(hF1,0,1,1,a1)<1||CopyBuffer(hS1,0,1,1,b1)<1) return;
         h1OK=wantLong?(a1[0]>b1[0]):(a1[0]<b1[0]);
        }
      if(InpUseH4)
        {
         if(CopyBuffer(hS4,0,1,1,c4)<1) return;
         double cl4=iClose(_Symbol,PERIOD_H4,1); if(cl4<=0) return;
         h4OK=wantLong?(cl4>c4[0]):(cl4<c4[0]);
        }
      if(InpUseD1)
        {
         if(CopyBuffer(hSD,0,1,1,cD)<1) return;
         double clD=iClose(_Symbol,PERIOD_D1,1); if(clD<=0) return;
         d1OK=wantLong?(clD>cD[0]):(clD<cD[0]);
        }
     }
   bool timeOK=(!InpUseTime)||(RomeHour(r[1].time)>=InpStartHour && RomeHour(r[1].time)<InpEndHour);
   int score=0;
   score+=distOK?10:0; score+=slopeOK?10:0; score+=atrOK?10:0; score+=bodyOK?10:0;
   score+=haOK?15:0; score+=h1OK?15:0; score+=h4OK?15:0; score+=d1OK?15:0;
   bool scoreOK=(!InpUseScore)||(score>=InpMinScore);
   if(!(haOK&&bodyOK&&distOK&&slopeOK&&atrOK&&h1OK&&h4OK&&d1OK&&scoreOK&&timeOK)) return;

   int type; ulong tk;
   if(HavePos(type,tk))
     {
      bool opposite=(wantLong&&type==POSITION_TYPE_SELL)||(!wantLong&&type==POSITION_TYPE_BUY);
      if(!opposite) return;
      if(!InpSAR) return;
      gT.PositionClose(tk);
     }
   double sigClose=r[1].close;
   if(wantLong)
     {
      double sl=sigClose-atr*InpSLatr, tp=sigClose+atr*InpTPatr;
      double entry=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      if(sl>=entry) return;
      double lot=LotFor(true,entry,sl); if(lot<=0) return;
      gT.Buy(lot,_Symbol,0,NormalizeDouble(sl,_Digits),NormalizeDouble(tp,_Digits),"HAM");
     }
   else
     {
      double sl=sigClose+atr*InpSLatr, tp=sigClose-atr*InpTPatr;
      double entry=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      if(sl<=entry) return;
      double lot=LotFor(false,entry,sl); if(lot<=0) return;
      gT.Sell(lot,_Symbol,0,NormalizeDouble(sl,_Digits),NormalizeDouble(tp,_Digits),"HAM");
     }
  }
