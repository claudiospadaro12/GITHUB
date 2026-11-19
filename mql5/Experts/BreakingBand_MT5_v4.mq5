//+------------------------------------------------------------------+
//|                     BreakingBand_MT5_v4.mq5                      |
//|  BULGE di Fasciano - CONTINUAZIONE + INVERSIONE                 |
//|  v4: aggiunti i pattern di inversione (piu' occasioni)          |
//|  Criteri di qualita' mantenuti (il segreto della strategia)     |
//+------------------------------------------------------------------+
#property copyright "Massimo & Claudio"
#property version   "4.00"
#include <Trade/Trade.mqh>
CTrade trade;

//==== PARAMETRI ====
input int    BB_Period        = 20;
input double BB_Dev           = 2.0;
//--- Bulge
input double Bulge_BWexp      = 1.12;
input double Bulge_ImpATR     = 1.5;
input int    Bulge_MaxBars    = 20;
input double Bulge_DistMid    = 0.40;
//--- Ritracciamento
input double Retr_MaxCandleATR= 1.5;
input double Retr_ShadowBody  = 1.5;
input int    Retr_MaxBars     = 40;
//--- Conferma (filtro qualita')
input bool   UseStdDevCut     = true;   // taglio StdDev sotto SMA50
input int    StdDevSMA        = 50;
//--- Pattern abilitati
input bool   EnableContinuation = true; // continuazione
input bool   EnableReversal     = true; // INVERSIONE (nuovo)
input int    Reversal_MinBulges = 2;    // inversione: almeno N bulge nel trend prima
//--- Rischio
input double SL_ATRmult       = 3.0;
input int    TP_Mode          = 1;      // 1=mediana 2=banda opp 3=atr
input double TP_ATRmult       = 2.0;
input double RiskPercent      = 0.5;
input int    ATR_Period       = 14;
input int    MagicNumber      = 20261119;

int hBB, hATR, hStdDev;
double upB[], miB[], loB[], atrB[], sdB[];

int OnInit()
{
   hBB=iBands(_Symbol,PERIOD_CURRENT,BB_Period,0,BB_Dev,PRICE_CLOSE);
   hATR=iATR(_Symbol,PERIOD_CURRENT,ATR_Period);
   hStdDev=iStdDev(_Symbol,PERIOD_CURRENT,BB_Period,0,MODE_SMA,PRICE_CLOSE);
   if(hBB==INVALID_HANDLE||hATR==INVALID_HANDLE||hStdDev==INVALID_HANDLE) return INIT_FAILED;
   return INIT_SUCCEEDED;
}
bool Load(int need)
{
   if(CopyBuffer(hBB,0,0,need,miB)<need) return false;
   if(CopyBuffer(hBB,1,0,need,upB)<need) return false;
   if(CopyBuffer(hBB,2,0,need,loB)<need) return false;
   if(CopyBuffer(hATR,0,0,need,atrB)<need) return false;
   if(CopyBuffer(hStdDev,0,0,need,sdB)<need) return false;
   ArraySetAsSeries(miB,true);ArraySetAsSeries(upB,true);ArraySetAsSeries(loB,true);
   ArraySetAsSeries(atrB,true);ArraySetAsSeries(sdB,true);
   return true;
}
double SMAofSD(int s){ double x=0; for(int k=s;k<s+StdDevSMA;k++) x+=sdB[k]; return x/StdDevSMA; }
double BW(int s){ return upB[s]-loB[s]; }

// rileva bulge a shift end, ritorna direzione
int DetectBulge(int end)
{
   double bwm=0; for(int k=end;k<end+20;k++) bwm+=BW(k); bwm/=20.0;
   if(BW(end)<Bulge_BWexp*bwm) return 0;
   if(sdB[end]<=SMAofSD(end)) return 0;
   for(int lb=3;lb<=Bulge_MaxBars;lb++)
   { int st=end+lb;
     double ce=iClose(_Symbol,PERIOD_CURRENT,end), cs=iClose(_Symbol,PERIOD_CURRENT,st);
     double mv=ce-cs; bool imp=false;
     for(int k=end;k<=st;k++){ double r=iHigh(_Symbol,PERIOD_CURRENT,k)-iLow(_Symbol,PERIOD_CURRENT,k); if(r>Bulge_ImpATR*atrB[k]){imp=true;break;} }
     if(!imp) continue;
     if(MathAbs(ce-miB[end])>Bulge_DistMid*(BW(end)/2.0)) return (mv>0)?1:-1;
   }
   return 0;
}
// conta bulge recenti nella stessa direzione (per inversione in trend)
int CountRecentBulges(int dir, int lookback)
{
   int n=0;
   for(int s=2;s<lookback;s++){ if(DetectBulge(s)==dir){ n++; s+=Bulge_MaxBars; } }
   return n;
}
bool RetracementOK(int bulgeShift)
{
   for(int k=1;k<bulgeShift;k++)
   { double rng=iHigh(_Symbol,PERIOD_CURRENT,k)-iLow(_Symbol,PERIOD_CURRENT,k);
     if(rng>Retr_MaxCandleATR*atrB[k]) return false;
     double body=MathAbs(iClose(_Symbol,PERIOD_CURRENT,k)-iOpen(_Symbol,PERIOD_CURRENT,k));
     if(body>0 && (rng-body)>Retr_ShadowBody*body) return false; }
   return true;
}

datetime lastBar=0;
int bDir=0, bBar=-1; bool bReversal=false;

void OnTick()
{
   datetime t=iTime(_Symbol,PERIOD_CURRENT,0);
   if(t==lastBar) return; lastBar=t;
   if(!Load(StdDevSMA+Bulge_MaxBars+60)) return;
   if(HasPos()) return;

   if(bBar<0)
   {
      int d=DetectBulge(1);
      if(d!=0)
      {
         // decido se continuazione o inversione dal contesto
         int prevBulges=CountRecentBulges(d, 60);
         if(EnableReversal && prevBulges>=Reversal_MinBulges)
         { bDir=-d; bBar=1; bReversal=true; }     // inversione: entro CONTRO il bulge
         else if(EnableContinuation)
         { bDir=d; bBar=1; bReversal=false; }      // continuazione: entro A FAVORE
      }
      return;
   }
   bBar++;
   if(bBar>Retr_MaxBars){ bBar=-1; bDir=0; return; }
   if(!RetracementOK(bBar)) return;

   bool cut=(sdB[1]<SMAofSD(1) && sdB[2]>=SMAofSD(2));
   bool narrowing=(BW(1)<BW(2));
   if(UseStdDevCut && !(cut && narrowing)) return;

   double atr=atrB[1];
   double entry=(bDir>0)?SymbolInfoDouble(_Symbol,SYMBOL_ASK):SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double sl=(bDir>0)?entry-SL_ATRmult*atr:entry+SL_ATRmult*atr;
   double tp;
   if(TP_Mode==1) tp=miB[1];
   else if(TP_Mode==2) tp=(bDir>0)?upB[1]:loB[1];
   else tp=(bDir>0)?entry+TP_ATRmult*atr:entry-TP_ATRmult*atr;
   if(bDir>0 && tp<=entry) tp=entry+TP_ATRmult*atr;
   if(bDir<0 && tp>=entry) tp=entry-TP_ATRmult*atr;
   double lot=CalcLot(MathAbs(entry-sl));
   if(lot<=0){ bBar=-1; bDir=0; return; }
   trade.SetExpertMagicNumber(MagicNumber);
   if(bDir>0) trade.Buy(lot,_Symbol,entry,sl,tp,"BB");
   else trade.Sell(lot,_Symbol,entry,sl,tp,"BB");
   bBar=-1; bDir=0;
}
bool HasPos()
{ for(int i=PositionsTotal()-1;i>=0;i--){ ulong tk=PositionGetTicket(i);
    if(PositionSelectByTicket(tk)&&PositionGetString(POSITION_SYMBOL)==_Symbol&&PositionGetInteger(POSITION_MAGIC)==MagicNumber) return true; } return false; }
double CalcLot(double slDist)
{ double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
  if(tv<=0||ts<=0||slDist<=0) return 0;
  double lot=AccountInfoDouble(ACCOUNT_EQUITY)*RiskPercent/100.0/((slDist/ts)*tv);
  double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP),mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
  lot=MathFloor(lot/step)*step; if(lot<mn)lot=mn; return NormalizeDouble(lot,2); }
