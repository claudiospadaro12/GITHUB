//+------------------------------------------------------------------+
//|  ABTG_ORB_Semi.mq5  v1.01  (25/11/2026)                           |
//|  EXPERT SEMI-AUTOMATICO PER L'ORB (oro, Nasdaq, Dow, altri).      |
//|  1) Orario del range in ORA ITALIANA (conversione automatica).    |
//|  2) Traccia il massimo/minimo della candela (finestra) del range. |
//|  3) Modo 0: mette BuyStop e SellStop oltre i livelli; quando uno  |
//|     entra, cancella l'altro. Modo 1: solo linee e AVVISO alla     |
//|     rottura: entra Claudio a mano.                                |
//|  4) Gestisce la posizione (sua o aperta a mano, magic 0):        |
//|     stop dal range, parziale + stop a pari, trailing, chiusura    |
//|     a fine giornata. Diario CSV in Common\Files.                  |
//|  v1.01: REGISTRAZIONE "OMBRA" a fine giornata (nessun ordine):   |
//|  scrive nel diario cosa avrebbero fatto le regole (pendenti,      |
//|  chiusura M5 nuda e con filtri; stop a meta range e sul lato     |
//|  opposto) e, a parte, gli ingressi e le uscite REALI (tuoi).     |
//|  Regole di partenza dalle live di Emiliano/Paolo (registro unico) |
//|  Le regole MANCANTI nelle live sono input MODIFICABILI, non fatti.|
//|  SOLO DEMO/TESTER finche Claudio non decide altro. Nessun consiglio|
//|  su lotti: il lotto lo sceglie Claudio.                           |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.01"
#property strict
#include <Trade\Trade.mqh>

input group "=== PRESET (0 = usa i valori sotto; 1 = ORO; 2 = INDICE USA) ==="
input int      InpPreset        = 1;        // 1 ORO: range 15:30-15:35 IT, ordini dalle 15:35. 2 INDICE: range 15:30-15:45, ordini dalle 15:45
input group "=== RANGE (ORA ITALIANA) ==="
input int      InpRangeStartH   = 15;       // inizio finestra del range (ora IT)
input int      InpRangeStartM   = 30;
input int      InpRangeMinutes  = 5;        // durata della finestra in minuti (5 oro, 15 indici; il webinar usa 30)
input double   InpMinRange      = 0.0;      // range minimo in prezzo (0 = spento). Emiliano sul Nasdaq: 17-40 punti
input double   InpMaxRange      = 0.0;      // range massimo in prezzo (0 = spento)
input group "=== INGRESSO ==="
input int      InpEntryMode     = 0;        // 0 = ordini pendenti Buy/Sell stop (OCO); 1 = solo linee e avviso, entra Claudio a mano; 2 = INGRESSO A MERCATO fatto dall'Expert quando una candela M5 CHIUDE oltre il livello (con i filtri sotto)
input double   InpBuffer        = 0.0;      // distanza oltre i livelli in PREZZO (Emiliano: 7 punti Nasdaq, 10 punti notte; Paolo 5 punti) MANCA per l'oro
input int      InpCancelMin     = 90;       // cancella i pendenti dopo N minuti dalla fine del range
input bool     InpNoSecond      = true;     // quando uno entra si cancella l'altro (OCO)
input group "=== MODO 2: INGRESSO A MERCATO (regole di Emiliano, i valori sono modificabili) ==="
input bool     InpUseVol        = true;     // volume (tick) della candela di rottura >= InpVolMult x media delle precedenti (Emiliano: +50%; volumi affidabili sugli indici, NON sul forex)
input double   InpVolMult       = 1.5;
input int      InpVolBars       = 20;
input bool     InpUseEma        = true;     // medie 9 e 21 su M5 allineate e inclinate nel verso (buy: prezzo>EMA9>EMA21)
input int      InpEmaA          = 9;
input int      InpEmaB          = 21;
input double   InpMaxChase      = 0.0;      // se il prezzo e gia oltre il livello di piu di N (prezzo) NON inseguo (0 = spento). Emiliano: entrare sul retest, mai inseguire
input bool     InpRetest        = false;    // true: dopo la rottura valida aspetto il RETEST del livello e una chiusura M5 di conferma, poi entro
input double   InpRetestTol     = 0.0;      // tolleranza del retest in prezzo
input bool     InpOneTrade      = true;     // un solo ingresso per sessione
input group "=== STOP E TARGET ==="
input int      InpStopMode      = 1;        // 0 = lato opposto del range; 1 = META del range (Emiliano); 2 = distanza fissa
input double   InpStopExtra     = 0.0;      // extra oltre lo stop in prezzo (Emiliano: 5-10 punti oltre il riferimento)
input double   InpStopFixed     = 0.0;      // per StopMode 2: distanza in prezzo
input double   InpTpR           = 0.0;      // target = N volte il rischio (0 = nessun TP; webinar: R/R minimo 2)
input group "=== LOTTO (decide Claudio) ==="
input int      InpLotMode       = 0;        // 0 = lotto fisso; 1 = % del saldo sullo stop
input double   InpLots          = 0.10;
input double   InpRiskPct       = 0.5;
input group "=== PARZIALE E TRAILING ==="
input int      InpPartialMode   = 0;        // 0 = nessun parziale; 1 = a N punti di prezzo; 2 = a N volte il rischio
input double   InpPartialDist   = 25.0;     // per modo 1: distanza in prezzo (Emiliano: 20-30 punti; Paolo 30-40)
input double   InpPartialR      = 1.0;      // per modo 2
input double   InpPartialPct    = 50.0;     // % del volume da chiudere
input bool     InpBEAfterPartial= true;     // dopo il parziale stop a pari
input double   InpBEPlus        = 0.0;      // sopra/sotto il pari in prezzo
input int      InpTrailMode     = 0;        // 0 = nessuno; 1 = stop dietro la EMA di M5 (dopo il parziale); 2 = chiude se una M5 chiude oltre la EMA veloce (webinar)
input int      InpTrailEma      = 21;       // periodo EMA per il modo 1 (Paolo: EMA 21/50)
input int      InpFastEma       = 9;        // periodo EMA per il modo 2
input double   InpTrailBuf      = 0.0;      // distanza dalla EMA in prezzo
input group "=== CHIUSURA GIORNATA (ORA ITALIANA) ==="
input int      InpCloseH        = 21;       // chiude tutto e cancella i pendenti (mai overnight)
input int      InpCloseM        = 30;
input group "=== GESTIONE E AVVISI ==="
input bool     InpManageManual  = true;     // gestisce anche le posizioni aperte a mano (magic 0) su questo simbolo
input bool     InpPush          = false;    // invia anche notifica push (serve l'ID MetaQuotes)
input long     InpMagic         = 770701;
input string   InpComment       = "ORB-S";
input bool     InpDiary         = true;

CTrade   trade;
int      hEma=INVALID_HANDLE, hFast=INVALID_HANDLE, hA=INVALID_HANDLE, hB=INVALID_HANDLE;
datetime gDay=0;                 // giorno italiano (mezzanotte) gia elaborato
bool     gTraded=false, gShadowDone=false; int gBreakDir=0; double gBreakLevel=0;
bool     gRangeDone=false, gOrdersDone=false, gAlertBuy=false, gAlertSell=false, gSkipDay=false;
double   gHi=0, gLo=0, gBuyTrg=0, gSellTrg=0;
datetime gRangeEndSrv=0, gCancelSrv=0, gCloseSrv=0;
datetime gLastM5=0;
int      gTries=0;
double   P_buf, P_minR, P_maxR, P_part, P_stopExtra, P_stopFixed;
int      P_min, P_sh, P_sm; bool P_useVol=true;

//------------------------------------------------ tempo italiano
datetime LastSunday(int y,int m)
  { MqlDateTime s; s.year=y; s.mon=m; s.day=31; s.hour=0; s.min=0; s.sec=0; datetime t=StructToTime(s); TimeToStruct(t,s); return t-(datetime)(s.day_of_week*86400); }
int ItalyOffset(datetime gmt)
  { MqlDateTime d; TimeToStruct(gmt,d); datetime a=LastSunday(d.year,3)+3600, b=LastSunday(d.year,10)+3600; return (gmt>=a && gmt<b)?7200:3600; }
int SrvOffset() { int o=(int)(TimeCurrent()-TimeGMT()); return (int)(MathRound(o/1800.0)*1800); }
// ora italiana H:M di OGGI (giorno italiano) -> datetime del SERVER
datetime ItToSrv(datetime itDay0,int h,int m)
  {
   datetime itT=itDay0+h*3600+m*60;
   datetime gmt=itT-ItalyOffset(itT-7200);       // stima: l'offset al mattino/pomeriggio non cambia nelle ore del trading
   return gmt+SrvOffset();
  }
datetime ItalyDay0()
  { datetime g=TimeGMT(); datetime it=g+ItalyOffset(g); return it-(it%86400); }

//------------------------------------------------ diario e avvisi
void Diary(string ev,string det)
  {
   if(!InpDiary) return;
   int h=FileOpen("ABTG_ORB_Semi_diario.csv",FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(h==INVALID_HANDLE) return;
   FileSeek(h,0,SEEK_END);
   FileWriteString(h,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS)+";"+_Symbol+";"+ev+";"+det+"\r\n");
   FileClose(h);
  }
void Say(string s){ Print("ORB-S: ",s); if(InpPush) SendNotification("ORB-S "+_Symbol+": "+s); }
void Line(string name,double price,color c,string txt)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_HLINE,0,0,price);
   ObjectSetDouble(0,name,OBJPROP_PRICE,price); ObjectSetInteger(0,name,OBJPROP_COLOR,c); ObjectSetString(0,name,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DASH);
  }

//------------------------------------------------ lotto
double NormLot(double lot)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP), mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN), mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   if(st<=0) st=0.01; lot=MathFloor(lot/st+1e-9)*st; if(lot<mn) lot=mn; if(lot>mx) lot=mx; return NormalizeDouble(lot,2);
  }
double CalcLot(double entry,double sl,bool isBuy)
  {
   if(InpLotMode==0) return NormLot(InpLots);
   double prof=0.0, dist=MathAbs(entry-sl); if(dist<=0) return NormLot(InpLots);
   if(!OrderCalcProfit(isBuy?ORDER_TYPE_BUY:ORDER_TYPE_SELL,_Symbol,1.0,entry,isBuy?entry-dist:entry+dist,prof) || MathAbs(prof)<=0) return NormLot(InpLots);
   return NormLot(AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPct/100.0/MathAbs(prof));
  }

//------------------------------------------------ range e ordini
double StopFor(bool isBuy,double entry)
  {
   double mid=(gHi+gLo)/2.0, sl;
   if(InpStopMode==0)      sl = isBuy ? gLo-P_stopExtra : gHi+P_stopExtra;
   else if(InpStopMode==1) sl = isBuy ? mid-P_stopExtra : mid+P_stopExtra;
   else                    sl = isBuy ? entry-P_stopFixed : entry+P_stopFixed;
   return NormalizeDouble(sl,_Digits);
  }
bool ComputeRange(datetime itDay0)
  {
   datetime s=ItToSrv(itDay0,P_sh,P_sm), e=s+P_min*60; gRangeEndSrv=e;
   MqlRates r[]; ArraySetAsSeries(r,false);
   int n=CopyRates(_Symbol,PERIOD_M1,s,e-60,r);
   if(n<MathMax(1,P_min-1)) return false;
   double hi=-1e18, lo=1e18; for(int i=0;i<n;i++){ if(r[i].high>hi) hi=r[i].high; if(r[i].low<lo) lo=r[i].low; }
   gHi=hi; gLo=lo; return true;
  }
void PlaceOrders()
  {
   double rg=gHi-gLo;
   gBuyTrg=NormalizeDouble(gHi+P_buf,_Digits); gSellTrg=NormalizeDouble(gLo-P_buf,_Digits);
   Line("ORBS_hi",gHi,clrDodgerBlue,"ORB massimo"); Line("ORBS_lo",gLo,clrDodgerBlue,"ORB minimo");
   Line("ORBS_buy",gBuyTrg,clrLimeGreen,"BUY trigger"); Line("ORBS_sell",gSellTrg,clrTomato,"SELL trigger");
   Say(StringFormat("range %.2f-%.2f (ampiezza %.2f) trigger BUY %.2f SELL %.2f",gLo,gHi,rg,gBuyTrg,gSellTrg));
   Diary("RANGE",StringFormat("hi=%.5f;lo=%.5f;ampiezza=%.5f;buy=%.5f;sell=%.5f",gHi,gLo,rg,gBuyTrg,gSellTrg));
   if((P_minR>0 && rg<P_minR) || (P_maxR>0 && rg>P_maxR)){ Say("range fuori dai limiti: oggi non si opera"); Diary("SALTA","range fuori limiti"); gSkipDay=true; return; }
   if(InpEntryMode==1){ Say("modo AVVISO: entra tu quando rompe; li gestisco io dopo"); return; }
   if(InpEntryMode==2){ Say("modo MERCATO: entro io alla chiusura M5 oltre il livello, con i filtri"); return; }
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   datetime expT=gCancelSrv;
   if(gBuyTrg>ask+minD)
     {
      double sl=StopFor(true,gBuyTrg), tp=(InpTpR>0)?NormalizeDouble(gBuyTrg+InpTpR*(gBuyTrg-sl),_Digits):0.0;
      if(trade.BuyStop(CalcLot(gBuyTrg,sl,true),gBuyTrg,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expT,InpComment+" Buy")) Diary("ORDINE","BuyStop "+DoubleToString(gBuyTrg,_Digits)+" sl "+DoubleToString(sl,_Digits)); else Say("BuyStop rifiutato: "+trade.ResultRetcodeDescription());
     } else Say("livello BUY gia superato o troppo vicino: nessun BuyStop");
   if(gSellTrg<bid-minD)
     {
      double sl=StopFor(false,gSellTrg), tp=(InpTpR>0)?NormalizeDouble(gSellTrg-InpTpR*(sl-gSellTrg),_Digits):0.0;
      if(trade.SellStop(CalcLot(gSellTrg,sl,false),gSellTrg,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expT,InpComment+" Sell")) Diary("ORDINE","SellStop "+DoubleToString(gSellTrg,_Digits)+" sl "+DoubleToString(sl,_Digits)); else Say("SellStop rifiutato: "+trade.ResultRetcodeDescription());
     } else Say("livello SELL gia superato o troppo vicino: nessun SellStop");
  }
void CancelPendings(string why)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i); if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol || OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      if(trade.OrderDelete(t)) Diary("CANCELLA",why+" ticket "+IntegerToString((long)t));
     }
  }
bool HasMyPendings()
  { for(int i=OrdersTotal()-1;i>=0;i--){ ulong t=OrderGetTicket(i); if(t==0) continue; if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) return true; } return false; }

//------------------------------------------------ ingresso a mercato (modo 2)
double EmaVal(int handle,int shift){ double b[1]; if(handle==INVALID_HANDLE || CopyBuffer(handle,0,shift,1,b)!=1) return 0.0; return b[0]; }
bool VolumeOk()
  {
   if(!P_useVol) return true;
   long v1=iVolume(_Symbol,PERIOD_M5,1); double sum=0; int n=0;
   for(int i=2;i<2+InpVolBars;i++){ long v=iVolume(_Symbol,PERIOD_M5,i); if(v>0){ sum+=(double)v; n++; } }
   if(n<5) return true;
   return (double)v1>=InpVolMult*(sum/n);
  }
bool EmaOk(bool isBuy)
  {
   if(!InpUseEma) return true;
   double a1=EmaVal(hA,1), b1=EmaVal(hB,1), a2=EmaVal(hA,2), b2=EmaVal(hB,2), c=iClose(_Symbol,PERIOD_M5,1);
   if(a1<=0 || b1<=0 || a2<=0 || b2<=0) return true;
   if(isBuy) return (c>a1 && a1>b1 && a1>a2 && b1>=b2);
   return (c<a1 && a1<b1 && a1<a2 && b1<=b2);
  }
void MarketEntry(bool isBuy,string why)
  {
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), px=isBuy?ask:bid;
   double lvl=isBuy?gBuyTrg:gSellTrg;
   if(InpMaxChase>0 && MathAbs(px-lvl)>InpMaxChase){ Say("prezzo troppo lontano dal livello: non inseguo"); Diary("SALTA","troppo lontano "+DoubleToString(px,_Digits)); return; }
   double sl=StopFor(isBuy,px), minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if((isBuy && sl>=bid-minD) || (!isBuy && sl<=ask+minD)){ Say("stop troppo vicino al prezzo: salto"); Diary("SALTA","stop troppo vicino"); return; }
   double tp=0.0; if(InpTpR>0) tp=NormalizeDouble(isBuy?px+InpTpR*(px-sl):px-InpTpR*(sl-px),_Digits);
   double lot=CalcLot(px,sl,isBuy);
   bool ok=isBuy?trade.Buy(lot,_Symbol,0,sl,tp,InpComment+" Buy"):trade.Sell(lot,_Symbol,0,sl,tp,InpComment+" Sell");
   if(ok){ gTraded=true; Say(StringFormat("ENTRATO %s a %.2f stop %.2f (%s)",isBuy?"BUY":"SELL",px,sl,why)); Diary("INGRESSO",StringFormat("%s;%.5f;sl=%.5f;lot=%.2f;%s",isBuy?"BUY":"SELL",px,sl,lot,why)); }
   else Say("ordine a mercato rifiutato: "+trade.ResultRetcodeDescription());
  }
void CheckMarketEntry()
  {
   if(InpOneTrade && gTraded) return;
   double c=iClose(_Symbol,PERIOD_M5,1), lo=iLow(_Symbol,PERIOD_M5,1), hi=iHigh(_Symbol,PERIOD_M5,1);
   if(iTime(_Symbol,PERIOD_M5,1)<gRangeEndSrv) return;                  // solo candele dopo la fine del range
   double mid=(gHi+gLo)/2.0;
   if(gBreakDir!=0)                                                    // aspetto il retest
     {
      bool buy=(gBreakDir>0);
      if(buy && c<mid){ gBreakDir=0; Say("setup annullato: chiusura sotto meta range"); return; }
      if(!buy && c>mid){ gBreakDir=0; Say("setup annullato: chiusura sopra meta range"); return; }
      bool touched=buy?(lo<=gBreakLevel+InpRetestTol):(hi>=gBreakLevel-InpRetestTol);
      bool conf=buy?(c>gBreakLevel):(c<gBreakLevel);
      if(touched && conf){ MarketEntry(buy,"retest confermato"); gBreakDir=0; }
      return;
     }
   if(c>gBuyTrg && VolumeOk() && EmaOk(true))
     { if(InpRetest){ gBreakDir=1; gBreakLevel=gBuyTrg; Say("rottura BUY valida: aspetto il retest"); Diary("ROTTURA","BUY in attesa di retest"); } else MarketEntry(true,"chiusura M5 oltre il massimo"); }
   else if(c<gSellTrg && VolumeOk() && EmaOk(false))
     { if(InpRetest){ gBreakDir=-1; gBreakLevel=gSellTrg; Say("rottura SELL valida: aspetto il retest"); Diary("ROTTURA","SELL in attesa di retest"); } else MarketEntry(false,"chiusura M5 sotto il minimo"); }
  }

//------------------------------------------------ gestione posizioni
string GV(ulong t,string k){ return "ORBS_"+IntegerToString((long)t)+"_"+k; }
void ManagePositions(bool newM5)
  {
   double ema=0, fast=0, lastClose=0;
   if(newM5)
     { double b[1]; if(hEma!=INVALID_HANDLE && CopyBuffer(hEma,0,1,1,b)==1) ema=b[0]; if(hFast!=INVALID_HANDLE && CopyBuffer(hFast,0,1,1,b)==1) fast=b[0]; lastClose=iClose(_Symbol,PERIOD_M5,1); }
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i); if(tk==0 || !PositionSelectByTicket(tk)) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      long mg=PositionGetInteger(POSITION_MAGIC); if(!(mg==InpMagic || (InpManageManual && mg==0))) continue;
      bool isBuy=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double op=PositionGetDouble(POSITION_PRICE_OPEN), sl=PositionGetDouble(POSITION_SL), tp=PositionGetDouble(POSITION_TP), vol=PositionGetDouble(POSITION_VOLUME);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), cur=isBuy?bid:ask;
      double minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
      // OCO: dopo il fill si cancella l'altro
      if(InpNoSecond && mg==InpMagic) CancelPendings("OCO");
      // stop mancante (ingresso a mano): lo metto dal range di oggi
      if(sl<=0.0)
        {
         if(gRangeDone && gHi>gLo){ double ns=StopFor(isBuy,op); if(trade.PositionModify(tk,ns,tp)){ sl=ns; Diary("STOP",StringFormat("ticket %I64u stop dal range %.5f",tk,ns)); } }
         else continue;
        }
      if(!GlobalVariableCheck(GV(tk,"R"))) GlobalVariableSet(GV(tk,"R"),MathAbs(op-sl));
      double R=GlobalVariableGet(GV(tk,"R")); double prof=isBuy?(cur-op):(op-cur);
      bool partDone=GlobalVariableCheck(GV(tk,"P"));
      // parziale
      if(!partDone && InpPartialMode>0)
        {
         double need=(InpPartialMode==1)?InpPartialDist:InpPartialR*R;
         if(need>0 && prof>=need)
           {
            double cv=NormLot(vol*InpPartialPct/100.0); double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
            if(vol-cv>=mn && cv>=mn && trade.PositionClosePartial(tk,cv)) { Diary("PARZIALE",StringFormat("ticket %I64u chiuso %.2f a %.5f",tk,cv,cur)); Say(StringFormat("parziale %.2f lotti",cv)); }
            GlobalVariableSet(GV(tk,"P"),1); partDone=true;
            if(InpBEAfterPartial && PositionSelectByTicket(tk))
              {
               double be=NormalizeDouble(isBuy?op+InpBEPlus:op-InpBEPlus,_Digits);
               if((isBuy && be>sl && be<=bid-minD) || (!isBuy && (sl<=0 || be<sl) && be>=ask+minD)) { if(trade.PositionModify(tk,be,tp)) Diary("PARI",StringFormat("ticket %I64u stop a %.5f",tk,be)); }
              }
           }
        }
      if(!PositionSelectByTicket(tk)) continue;
      sl=PositionGetDouble(POSITION_SL);
      // trailing / uscita su M5 (solo dopo il parziale, oppure sempre se il parziale e spento)
      if(newM5 && (partDone || InpPartialMode==0))
        {
         if(InpTrailMode==1 && ema>0)
           {
            double ns=NormalizeDouble(isBuy?ema-InpTrailBuf:ema+InpTrailBuf,_Digits);
            if(isBuy && ns>sl && ns<=bid-minD) { if(trade.PositionModify(tk,ns,tp)) Diary("TRAIL",StringFormat("ticket %I64u sl %.5f",tk,ns)); }
            if(!isBuy && (sl<=0 || ns<sl) && ns>=ask+minD) { if(trade.PositionModify(tk,ns,tp)) Diary("TRAIL",StringFormat("ticket %I64u sl %.5f",tk,ns)); }
           }
         if(InpTrailMode==2 && fast>0 && ((isBuy && lastClose<fast) || (!isBuy && lastClose>fast)))
           { if(trade.PositionClose(tk)) Diary("USCITA_EMA",StringFormat("ticket %I64u chiuso su chiusura M5 oltre EMA%d",tk,InpFastEma)); }
        }
     }
  }
void CloseAll(string why)
  {
   CancelPendings(why);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i); if(tk==0 || !PositionSelectByTicket(tk)) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      long mg=PositionGetInteger(POSITION_MAGIC); if(!(mg==InpMagic || (InpManageManual && mg==0))) continue;
      if(trade.PositionClose(tk)) Diary("CHIUDE",why+" ticket "+IntegerToString((long)tk));
     }
  }


//------------------------------------------------ registrazione "ombra" (NESSUN ordine)
void SimExit(MqlRates &m1[],int n1,int startIdx,bool isBuy,double sl,string &reason,double &exitPx,datetime &exitT)
  {
   reason="EOD"; exitPx=m1[n1-1].close; exitT=m1[n1-1].time;
   for(int i=startIdx;i<n1;i++)
     {
      if(isBuy && m1[i].low<=sl)  { reason="STOP"; exitPx=sl; exitT=m1[i].time; return; }
      if(!isBuy && m1[i].high>=sl){ reason="STOP"; exitPx=sl; exitT=m1[i].time; return; }
     }
  }
void LogVariant(string name,bool isBuy,datetime et,double entry,double sl,string reason,double exitPx,datetime xt)
  {
   double risk=MathAbs(entry-sl), pts=isBuy?exitPx-entry:entry-exitPx, rr=(risk>0)?pts/risk:0.0;
   Diary("OMBRA",StringFormat("%s;%s;ingresso=%s;prezzo=%.5f;stop=%.5f;uscita=%s;%s;prezzo_uscita=%.5f;punti=%.2f;R=%.2f",name,isBuy?"BUY":"SELL",TimeToString(et,TIME_MINUTES),entry,sl,reason,TimeToString(xt,TIME_MINUTES),exitPx,pts,rr));
  }
void ShadowOne(string tag,MqlRates &m1[],int n1,MqlRates &m5[],int n5,int bar,int dir,double mid)
  {
   if(bar<0 || bar+1>=n5){ Diary("OMBRA",tag+";nessun ingresso"); return; }
   bool isBuy=(dir>0); double en=m5[bar+1].open; datetime et=m5[bar+1].time; int idx=-1;
   for(int i=0;i<n1;i++) if(m1[i].time>=et){ idx=i; break; }
   if(idx<0){ Diary("OMBRA",tag+";dati M1 mancanti"); return; }
   for(int k=0;k<2;k++)
     {
      double sl=(k==0)?(isBuy?mid-P_stopExtra:mid+P_stopExtra):(isBuy?gLo-P_stopExtra:gHi+P_stopExtra);
      string rs; double xp; datetime xt; SimExit(m1,n1,idx,isBuy,sl,rs,xp,xt);
      LogVariant(tag+(k==0?"_STOP_META":"_STOP_OPPOSTO"),isBuy,et,en,sl,rs,xp,xt);
     }
  }
void ShadowDay()
  {
   gShadowDone=true;
   if(!gRangeDone || gHi<=gLo) return;
   datetime t0=gRangeEndSrv, t1=gCloseSrv;
   MqlRates m1[], m5[]; ArraySetAsSeries(m1,false); ArraySetAsSeries(m5,false);
   int n1=CopyRates(_Symbol,PERIOD_M1,t0,t1,m1), n5=CopyRates(_Symbol,PERIOD_M5,t0-200*300,t1,m5);
   if(n1<20 || n5<40){ Diary("OMBRA","dati insufficienti per la registrazione ombra"); return; }
   double mid=(gHi+gLo)/2.0;
   // modo 0: primo tocco dei livelli (a precisione di minuto)
   int fi=-1, fdir=0, si=-1; bool amb=false;
   for(int i=0;i<n1;i++)
     {
      bool ub=(m1[i].high>=gBuyTrg), us=(m1[i].low<=gSellTrg);
      if(fi<0 && (ub||us)){ fi=i; if(ub&&us) amb=true; else fdir=ub?1:-1; }
      else if(fi>=0 && si<0 && fdir!=0){ if((fdir==1 && us) || (fdir==-1 && ub)) si=i; }
     }
   double px=m1[n1-1].close;
   Diary("OMBRA_GIORNO",StringFormat("ampiezza=%.2f;pct_prezzo=%.2f;primo_tocco=%s@%s;secondo_tocco=%s;chiusura_giornata=%.5f",gHi-gLo,100.0*(gHi-gLo)/px,fi<0?"nessuno":(amb?"ambiguo":(fdir>0?"BUY":"SELL")),fi<0?"-":TimeToString(m1[fi].time,TIME_MINUTES),si<0?"nessuno":TimeToString(m1[si].time,TIME_MINUTES),px));
   if(fi>=0 && !amb)
     {
      bool isBuy=(fdir>0); double en=isBuy?gBuyTrg:gSellTrg;
      for(int k=0;k<2;k++)
        {
         double sl=(k==0)?(isBuy?mid-P_stopExtra:mid+P_stopExtra):(isBuy?gLo-P_stopExtra:gHi+P_stopExtra);
         string rs; double xp; datetime xt; SimExit(m1,n1,fi,isBuy,sl,rs,xp,xt);
         LogVariant(k==0?"M0_STOP_META":"M0_STOP_OPPOSTO",isBuy,m1[fi].time,en,sl,rs,xp,xt);
        }
     }
   else Diary("OMBRA",amb?"M0;ambiguo: entrambi i livelli nello stesso minuto":"M0;nessun tocco dei livelli");
   // modo 2: prima chiusura M5 oltre il livello, nuda e con i filtri (volume sugli indici, EMA)
   double ea=0, eb=0, pea=0, peb=0, ka=2.0/(InpEmaA+1), kb=2.0/(InpEmaB+1);
   int barN=-1, dirN=0, barF=-1, dirF=0;
   for(int j=0;j<n5;j++)
     {
      pea=ea; peb=eb;
      if(j==0){ ea=m5[0].close; eb=m5[0].close; pea=ea; peb=eb; } else { ea=m5[j].close*ka+ea*(1.0-ka); eb=m5[j].close*kb+eb*(1.0-kb); }
      if(m5[j].time<t0) continue;
      bool up=(m5[j].close>gBuyTrg), dn=(m5[j].close<gSellTrg); if(!up && !dn) continue;
      if(barN<0){ barN=j; dirN=up?1:-1; }
      if(barF<0)
        {
         bool volOk=true;
         if(P_useVol){ double sv=0; int cv=0; for(int q=j-InpVolBars;q<j;q++){ if(q>=0){ sv+=(double)m5[q].tick_volume; cv++; } } volOk=(cv<5) || ((double)m5[j].tick_volume>=InpVolMult*sv/cv); }
         bool emaOk=true;
         if(InpUseEma){ if(up) emaOk=(m5[j].close>ea && ea>eb && ea>pea && eb>=peb); else emaOk=(m5[j].close<ea && ea<eb && ea<pea && eb<=peb); }
         if(volOk && emaOk){ barF=j; dirF=up?1:-1; }
        }
      if(barN>=0 && barF>=0) break;
     }
   ShadowOne("M2_NUDO",m1,n1,m5,n5,barN,dirN,mid);
   ShadowOne("M2_FILTRI",m1,n1,m5,n5,barF,dirF,mid);
  }
//------------------------------------------------ ingressi e uscite REALI (tuoi o dell'Expert) nel diario
void OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &req,const MqlTradeResult &res)
  {
   if(trans.type!=TRADE_TRANSACTION_DEAL_ADD) return;
   if(!HistoryDealSelect(trans.deal)) return;
   if(HistoryDealGetString(trans.deal,DEAL_SYMBOL)!=_Symbol) return;
   long mg=HistoryDealGetInteger(trans.deal,DEAL_MAGIC); if(!(mg==InpMagic || mg==0)) return;
   long ty=HistoryDealGetInteger(trans.deal,DEAL_TYPE); if(ty!=DEAL_TYPE_BUY && ty!=DEAL_TYPE_SELL) return;
   long en=HistoryDealGetInteger(trans.deal,DEAL_ENTRY);
   double pr=HistoryDealGetDouble(trans.deal,DEAL_PRICE), vol=HistoryDealGetDouble(trans.deal,DEAL_VOLUME);
   double pf=HistoryDealGetDouble(trans.deal,DEAL_PROFIT)+HistoryDealGetDouble(trans.deal,DEAL_SWAP)+HistoryDealGetDouble(trans.deal,DEAL_COMMISSION);
   string chi=(mg==0)?"manuale":"expert";
   if(en==DEAL_ENTRY_IN) Diary("REALE_INGRESSO",StringFormat("%s;%s;lotti=%.2f;prezzo=%.5f;posizione=%I64u",ty==DEAL_TYPE_BUY?"BUY":"SELL",chi,vol,pr,(ulong)HistoryDealGetInteger(trans.deal,DEAL_POSITION_ID)));
   else if(en==DEAL_ENTRY_OUT || en==DEAL_ENTRY_OUT_BY) Diary("REALE_USCITA",StringFormat("%s;%s;lotti=%.2f;prezzo=%.5f;profitto_netto=%.2f;posizione=%I64u",ty==DEAL_TYPE_BUY?"chiude SELL":"chiude BUY",chi,vol,pr,pf,(ulong)HistoryDealGetInteger(trans.deal,DEAL_POSITION_ID)));
  }

//------------------------------------------------ eventi
int OnInit()
  {
   P_buf=InpBuffer; P_minR=InpMinRange; P_maxR=InpMaxRange; P_stopExtra=InpStopExtra; P_stopFixed=InpStopFixed;
   P_sh=InpRangeStartH; P_sm=InpRangeStartM; P_min=InpRangeMinutes;
   if(InpPreset==1){ P_sh=15; P_sm=30; P_min=5; }
   if(InpPreset==2){ P_sh=15; P_sm=30; P_min=15; }
   if(P_min<1) P_min=1;
   P_useVol=InpUseVol && (InpPreset!=1);   // sull'oro (CFD) il volume tick non e affidabile (Paolo): filtro volumi spento col preset ORO
   trade.SetExpertMagicNumber(InpMagic); trade.SetDeviationInPoints(30);
   hEma=iMA(_Symbol,PERIOD_M5,InpTrailEma,0,MODE_EMA,PRICE_CLOSE); hFast=iMA(_Symbol,PERIOD_M5,InpFastEma,0,MODE_EMA,PRICE_CLOSE);
   hA=iMA(_Symbol,PERIOD_M5,InpEmaA,0,MODE_EMA,PRICE_CLOSE); hB=iMA(_Symbol,PERIOD_M5,InpEmaB,0,MODE_EMA,PRICE_CLOSE);
   Say(StringFormat("avviato su %s: range %02d:%02d IT per %d minuti; modo %s",_Symbol,P_sh,P_sm,P_min,InpEntryMode==0?"ordini pendenti":InpEntryMode==2?"ingresso a mercato dell'Expert":"avviso (entri tu)"));
   return INIT_SUCCEEDED;
  }
void OnDeinit(const int reason){ if(hEma!=INVALID_HANDLE) IndicatorRelease(hEma); if(hFast!=INVALID_HANDLE) IndicatorRelease(hFast); if(hA!=INVALID_HANDLE) IndicatorRelease(hA); if(hB!=INVALID_HANDLE) IndicatorRelease(hB); }
void OnTick()
  {
   datetime it0=ItalyDay0();
   if(it0!=gDay)   // nuovo giorno italiano
     {
      gDay=it0; gRangeDone=false; gShadowDone=false; gTraded=false; gBreakDir=0; gBreakLevel=0; gOrdersDone=false; gAlertBuy=false; gAlertSell=false; gSkipDay=false; gTries=0; gHi=0; gLo=0;
      gCloseSrv=ItToSrv(it0,InpCloseH,InpCloseM);
      ObjectsDeleteAll(0,"ORBS_");
     }
   datetime now=TimeCurrent();
   datetime m5=iTime(_Symbol,PERIOD_M5,0); bool newM5=(m5!=gLastM5); if(newM5) gLastM5=m5;
   MqlDateTime dt; TimeToStruct(TimeGMT()+ItalyOffset(TimeGMT()),dt);
   if(dt.day_of_week==0 || dt.day_of_week==6) return;
   // calcolo del range a fine finestra
   datetime endSrv=ItToSrv(it0,P_sh,P_sm)+P_min*60;
   if(!gRangeDone && !gSkipDay && now>=endSrv+5 && now<gCloseSrv)
     {
      if(ComputeRange(it0)){ gRangeDone=true; gCancelSrv=endSrv+InpCancelMin*60; PlaceOrders(); }
      else if(++gTries>200){ Say("range non calcolabile (mancano le barre M1): oggi niente"); gSkipDay=true; }
     }
   // modo avviso: segnalo la rottura
   if(gRangeDone && !gSkipDay && InpEntryMode==1 && now<gCancelSrv)
     {
      double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      if(!gAlertBuy && ask>=gBuyTrg){ gAlertBuy=true; Say(StringFormat("ROTTO IL MASSIMO %.2f: ingresso BUY a mercato, stop suggerito %.2f",gBuyTrg,StopFor(true,ask))); Alert("ORB-S ",_Symbol," BUY rottura ",DoubleToString(gBuyTrg,_Digits)); Diary("AVVISO","BUY "+DoubleToString(ask,_Digits)); }
      if(!gAlertSell && bid<=gSellTrg){ gAlertSell=true; Say(StringFormat("ROTTO IL MINIMO %.2f: ingresso SELL a mercato, stop suggerito %.2f",gSellTrg,StopFor(false,bid))); Alert("ORB-S ",_Symbol," SELL rottura ",DoubleToString(gSellTrg,_Digits)); Diary("AVVISO","SELL "+DoubleToString(bid,_Digits)); }
     }
   // modo 2: ingresso a mercato alla chiusura della candela M5
   if(newM5 && InpEntryMode==2 && gRangeDone && !gSkipDay && now<gCancelSrv) CheckMarketEntry();
   // OCO + gestione
   if(InpNoSecond) { bool pos=false; for(int i=PositionsTotal()-1;i>=0;i--){ ulong tk=PositionGetTicket(i); if(tk!=0 && PositionSelectByTicket(tk) && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic){ pos=true; break; } } if(pos && HasMyPendings()) CancelPendings("OCO"); }
   ManagePositions(newM5);
   // chiusura di fine giornata
   if(gCloseSrv>0 && now>=gCloseSrv && now<gCloseSrv+600) CloseAll("fine giornata");
   // registrazione ombra a fine giornata (nessun ordine)
   if(!gShadowDone && gCloseSrv>0 && now>=gCloseSrv+60 && now<gCloseSrv+7200) ShadowDay();
  }
