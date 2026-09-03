//+------------------------------------------------------------------+
//|                                             ABTG_PostNews.mq5     |
//|                                                                  |
//|  EA "POST-NEWS" (ECB / FOMC press conference) - MT5 TUTTO-IN-UNO |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Strategia POST-NEWS totalmente MECCANICA (Christian Bertacchi). |
//|  Su una conferenza stampa (ECB o FOMC), a un orario preciso,     |
//|  prende max/min delle due candele M5 di riferimento e piazza:   |
//|    BUY STOP = max + 3 pip, SELL STOP = min - 2 pip.             |
//|    OCO configurabile (InpUseOCO): al 1o scatto cancella l'altra. |
//|  Ogni ordine: TP 50 pip, SL 25 pip. Scadenza pendenti a orario. |
//|  Size col rischio calcolato su 50 pip (worst case doppio stop). |
//|  Un UNICO motore per ECB ed FOMC: cambiano solo i PRESET         |
//|  (simbolo, orari, magic). Vedi i .set ECB / FOMC.              |
//|                                                                  |
//|  ORARI IN ORA SERVER (BCM = ora italiana - 1). Aggiorna gli     |
//|  orari se cambia l'ora legale. DEMO. Nessuna garanzia.         |
//+------------------------------------------------------------------+
//  v1.10 -- 03/09/2026. DUE CORREZIONI DI MECCANISMO, ZERO DI STRATEGIA.
//  Coi default il comportamento LIVE e' identico alla 1.00 (vedi sotto).
//
//  (1) IL CALENDARIO NON ARRIVAVA AGLI AGENTI DEL TESTER.
//      Il verdetto "PostNews: nessun edge" del 07/08 e' NULLO: i quattro
//      CSV di risultato hanno Trades=0. Due cause SOMMATE, e vanno
//      tolte tutte e due o il round rimisura il nulla:
//        (a) il DATO: abtg_news.csv aveva 17 righe datate 2026-2027, il
//            periodo testato non le conteneva. Risolto FUORI dall'EA,
//            con backtest_pipeline/costruisci_news_postnews.py ->
//            mql5/Files/abtg_news_postnews_2010_2025_UTC.csv, 599 eventi.
//        (b) il CANALE: nel tester OGNI AGENTE ha la SUA sandbox
//            MQL5\Files e i driver di casa non ci copiano niente
//            (verificato riga per riga in lancia_r93.ps1). FileOpen
//            senza FILE_COMMON falliva, LoadNews tornava con 0 eventi e
//            il filtro si SPEGNEVA DA SOLO, in silenzio. Adesso si
//            prova prima Common\Files (condiviso dagli agenti), poi la
//            sandbox, e si DICE quale delle due ha risposto.
//            LIVE NON CAMBIA NIENTE: sul VPS il file sta in MQL5\Files,
//            Common\Files non ce l'ha, quindi si ripiega sulla sandbox
//            esattamente come prima.
//      + CANARINO ROSSO: filtro acceso e calendario cieco -> l'EA lo
//        STAMPA IN CHIARO. Una passata con "eventi utili 0" NON e'
//        "la strategia non ha edge": e' "la strategia non e' girata".
//
//  (2) InpAutoTest (default true): in avvio l'EA verifica la propria
//      aritmetica sui casi di accettazione della SPEC (par. 7) e sulla
//      slide NFP/USDJPY del corso. Non piazza ordini, stampa e basta.
//      Si legge ESEGUENDO (test singolo nel tester), non compilando.
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.10"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Orari (ORA SERVER = ora italiana - 1) ==="
input int    InpActionHour = 14;   // Ora d'azione (server): quando calcola il range e piazza
input int    InpActionMin  = 0;    // ECB: 15:00 IT = 14:00 server. FOMC (news+10): imposta di conseguenza
input int    InpExpiryHour = 17;   // Ora scadenza pendenti (server). ECB: 18:15 IT = 17:15 server
input int    InpExpiryMin  = 15;   // FOMC: news+75min (in server)

input group "=== Restrizione ai giorni della notizia ==="
input bool   InpRestrictToNews = true; // opera SOLO se c'e' la notizia nel CSV (backtest e sicurezza live)
input bool   InpUseNewsFilter  = true; // carica il CSV degli eventi (date ECB/FOMC)
input string InpNewsFile       = "abtg_news.csv";
// true = cerca il CSV PRIMA in Common\Files (l'unica cartella che gli
// agenti del tester condividono), poi ripiega sulla sandbox MQL5\Files.
// Default true: NON cambia il live (sul VPS il file sta in MQL5\Files e
// Common non ce l'ha, quindi si ripiega), ma nel tester e' la differenza
// fra misurare la strategia e misurare il nulla.
input bool   InpNewsCommon     = true;
input int    InpNewsMinImpact  = 3;
input string InpNewsCurrencies = "EUR"; // ECB=EUR, FOMC=USD
input string InpNewsTitleMatch = "ECB"; // il titolo dell'evento deve contenerlo (ECB / FOMC)
input int    InpNewsShiftMinutes = 0;

input group "=== Ordini pendenti ==="
input double InpBuyOffsetPips  = 3.0;  // BUY STOP = max + 3 pip
input double InpSellOffsetPips = 3.0;  // SELL STOP = min - 3 pip (strategia: 3 pip)
input double InpTPpips         = 50.0; // take profit (pip)
input double InpSLpips         = 25.0; // stop loss (pip)
input bool   InpUseOCO         = true; // OCO: al 1o ordine che scatta, cancella l'altra gamba
input bool   InpCloseAtExpiry  = true; // chiudi la posizione all'orario di scadenza (21:45 IT), come da strategia

input group "=== Trailing (solo ECB) ==="
input bool   InpUseTrail25     = true; // se +25 pip di profitto, accorcia lo SL
input double InpTrailTriggerPips = 25.0;
input double InpTrailNewSLpips   = 15.0; // nuovo SL (pip dal prezzo d'ingresso)

input group "=== Chiusura di fine settimana ==="
input bool   InpFridayClose    = true; // chiudi ordini ancora aperti venerdi sera
input int    InpFridayCloseHour = 21;  // server (22:50 IT = 21:50 server)
input int    InpFridayCloseMin  = 50;

input group "=== Rischio ==="
input double InpRiskPercent    = 3.0;  // rischio % (documento: 3%)
input double InpRiskRefSLpips  = 50.0; // riferimento SL per la size (50 = worst case doppio stop)

input group "=== Generali ==="
input string InpComment   = "ECB PostNews"; // commento ordini (ECB=... / FOMC=...) per riconoscerli
input long   InpMagic     = 771201;    // ECB=771201, FOMC=771202
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
input bool   InpAutoTest  = true;  // in avvio verifica l'aritmetica sui casi della SPEC (nessun ordine)

//==================================================================
//  STATO
//==================================================================
datetime gLastBar=0;
int      gPlacedDay=-1;
int      gNewsLoadedDay=-1;   // giorno in cui ho letto il file news l'ultima volta

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; string gNewsTitle[]; int gNewsCount=0;
string   gNewsDove="(non letto)";   // quale delle due cartelle ha risposto
int      gNewsUtili=0;              // eventi che passano i filtri di QUESTO preset

void Log(string m){ if(InpVerbose) Print("[PostNews] ", m); }

//+------------------------------------------------------------------+
double PipSize()
  {
   int d=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   return (d==3 || d==5) ? _Point*10.0 : _Point;
  }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   MqlDateTime _di; TimeToStruct(TimeCurrent(),_di); gNewsLoadedDay=_di.day_of_year;
   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest) AutoTest();
   Log(StringFormat("avviato su %s. Azione %02d:%02d server, scadenza %02d:%02d server. 1 pip=%.5f",
       _Symbol,InpActionHour,InpActionMin,InpExpiryHour,InpExpiryMin,PipSize()));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| AUTOTEST -- si ESEGUE, non si compila. F7 non lo fa vedere:      |
//| serve un test singolo nel tester (o l'avvio su grafico).         |
//| Nessun ordine, nessun effetto sullo stato: solo stampe.          |
//|                                                                  |
//| I casi 1 e 2 sono i TEST DI ACCETTAZIONE della SPEC par. 7 (i    |
//| due esempi dettati dal relatore, verificati numero per numero).  |
//| Il caso 3 e' la slide NFP/USDJPY: serve a dimostrare che i suoi  |
//| 22/23 e 33/32 escono dagli input 25/30 senza aggiungere niente.  |
//+------------------------------------------------------------------+
void AutoTest()
  {
   int falliti=0;
   Print("[PostNews][AUTOTEST] ---- inizio ----");
   //--- caso 1: ECB 07/03/2024 EUR/JPY (pip 0.010, off 3/-2, SL25 TP50)
   falliti+=AT_Caso("T1 ECB EURJPY 07/03/2024",160.780,160.607,0.010,3.0,2.0,25.0,50.0,
                    160.810,160.560,161.310, 160.587,160.837,160.087, 3);
   //--- caso 2: FOMC 20/03/2024 EUR/USD (pip 0.00010)
   falliti+=AT_Caso("T2 FOMC EURUSD 20/03/2024",1.08892,1.08656,0.00010,3.0,2.0,25.0,50.0,
                    1.08922,1.08672,1.09422, 1.08636,1.08886,1.08136, 5);
   //--- caso 3: slide NFP/USDJPY. Attesi scritti COME LI SCRIVE LA SLIDE
   //    (dal livello X/Y), non come li calcola l'EA (dall'ingresso):
   //    BUY X+3 / SL X-22 / TP X+33 -- SELL Y-2 / SL Y+23 / TP Y-32
   //    con X=150.500 Y=150.000. Se tornano, gli input 25/30 bastano.
   falliti+=AT_Caso("T3 slide NFP USDJPY",150.500,150.000,0.010,3.0,2.0,25.0,30.0,
                    150.530,150.280,150.830, 149.980,150.230,149.680, 3);
   //--- caso 4: il pip del simbolo su cui gira davvero
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   double pipAtteso=(dg==3||dg==5)?_Point*10.0:_Point;
   bool okPip=(MathAbs(PipSize()-pipAtteso)<1e-12);
   if(!okPip) falliti++;
   PrintFormat("[PostNews][AUTOTEST] [%s] pip di %s (digits %d): %.5f",
               okPip?"ok ":"NO ",_Symbol,dg,PipSize());
   //--- caso 5: il calendario. Non e' aritmetica, e' la causa del round nullo.
   if(InpUseNewsFilter)
     {
      bool okNews=(gNewsUtili>0 || !InpRestrictToNews);
      if(!okNews) falliti++;
      PrintFormat("[PostNews][AUTOTEST] [%s] calendario: %d eventi utili da %s "
                  "(InpRestrictToNews=%s)",okNews?"ok ":"NO ",gNewsUtili,gNewsDove,
                  InpRestrictToNews?"true":"false");
     }
   PrintFormat("[PostNews][AUTOTEST] ---- fine: %d casi falliti ----",falliti);
  }

//--- un caso dell'autotest. Torna 1 se e' fallito, 0 se e' passato.
int AT_Caso(string nome,double hi,double lo,double pip,
            double offBuy,double offSell,double slP,double tpP,
            double aBuy,double aBuySL,double aBuyTP,
            double aSell,double aSellSL,double aSellTP,int dg)
  {
   double bP,bSL,bTP,sP,sSL,sTP;
   CalcLivelli(hi,lo,pip,offBuy,offSell,slP,tpP,bP,bSL,bTP,sP,sSL,sTP);
   double tol=pip*0.05;                        // 1/20 di pip: gli attesi hanno 3/5 decimali
   bool ok = MathAbs(bP-aBuy)<tol && MathAbs(bSL-aBuySL)<tol && MathAbs(bTP-aBuyTP)<tol
          && MathAbs(sP-aSell)<tol && MathAbs(sSL-aSellSL)<tol && MathAbs(sTP-aSellTP)<tol;
   PrintFormat("[PostNews][AUTOTEST] [%s] %s | BUY %s/%s/%s (attesi %s/%s/%s) | SELL %s/%s/%s (attesi %s/%s/%s)",
               ok?"ok ":"NO ",nome,
               DoubleToString(bP,dg),DoubleToString(bSL,dg),DoubleToString(bTP,dg),
               DoubleToString(aBuy,dg),DoubleToString(aBuySL,dg),DoubleToString(aBuyTP,dg),
               DoubleToString(sP,dg),DoubleToString(sSL,dg),DoubleToString(sTP,dg),
               DoubleToString(aSell,dg),DoubleToString(aSellSL,dg),DoubleToString(aSellTP,dg));
   return(ok?0:1);
  }

void OnDeinit(const int reason){}

//+------------------------------------------------------------------+
void OnTick()
  {
   // Ricarica il file news una volta al giorno: l'agente lo aggiorna ogni
   // mattina, cosi' l'EA vede sempre gli eventi nuovi senza riavviarlo.
   MqlDateTime _tc; TimeToStruct(TimeCurrent(),_tc);
   if(InpUseNewsFilter && _tc.day_of_year!=gNewsLoadedDay)
     { LoadNews(); gNewsLoadedDay=_tc.day_of_year; }

   OcoCheck();
   ManageTrailing();
   ExpiryCloseCheck();
   FridayCloseCheck();

   datetime t0=iTime(_Symbol,PERIOD_M5,0);
   if(t0==gLastBar) return;
   gLastBar=t0;

   MqlDateTime now; TimeToStruct(t0,now);
   // barra d'azione = quella che si apre all'orario impostato
   if(now.hour!=InpActionHour || now.min!=InpActionMin) return;
   if(now.day_of_year==gPlacedDay) return;             // gia' operato oggi
   //--- GUARDIA ANTI-DUPLICATO (reload-safe)
   { bool _has=false;
     for(int _i=OrdersTotal()-1;_i>=0 && !_has;_i--){ ulong _t=OrderGetTicket(_i); if(_t>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) _has=true; }
     for(int _j=PositionsTotal()-1;_j>=0 && !_has;_j--){ ulong _p=PositionGetTicket(_j); if(_p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) _has=true; }
     if(_has){ gPlacedDay=now.day_of_year; return; } }

   if(InpRestrictToNews && !NewsToday(t0)){ Log("nessuna notizia nel CSV oggi: niente ordini."); return; }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return; }

   PlaceOrders(t0);
   gPlacedDay=now.day_of_year;
  }

//+------------------------------------------------------------------+
//| Oggi e' giorno di evento? (stessa DATA + valuta + impatto)       |
//| Match sul giorno, non sull'ora: robusto a convenzioni orarie del |
//| CSV. Il QUANDO operare e' dato da InpActionHour/Min.            |
//+------------------------------------------------------------------+
bool NewsToday(datetime nowBar)
  {
   if(!InpUseNewsFilter || gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   MqlDateTime a; TimeToStruct(nowBar,a);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(StringLen(InpNewsTitleMatch)>0 && StringFind(gNewsTitle[i],InpNewsTitleMatch)<0) continue;
      MqlDateTime e; TimeToStruct(gNewsTime[i],e);
      if(e.year==a.year && e.mon==a.mon && e.day==a.day) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| I SEI LIVELLI DELL'EVENTO, IN UN SOLO POSTO.                     |
//| Ci passano sia PlaceOrders sia l'autotest: se il test girasse su  |
//| una COPIA della formula non proverebbe niente.                   |
//|                                                                  |
//| SL e TP si misurano DALL'INGRESSO, non dal livello. E' la stessa  |
//| cosa scritta in due modi, e vale la pena vederlo una volta sola   |
//| perche' la slide NFP/USDJPY del corso usa l'ALTRO modo e sembra   |
//| asimmetrica mentre non lo e':                                     |
//|   slide: BUY a X+3, SL X-22, TP X+33 | SELL a Y-2, SL Y+23, TP Y-32
//|   qui  : ingresso X+3 -> SL a -25 e TP a +30 (X+3-25 = X-22 ok)   |
//|          ingresso Y-2 -> SL a +25 e TP a -30 (Y-2+25 = Y+23 ok)   |
//| Cioe' 22/23 e 33/32 sono 25 e 30 visti dal livello: gli unici     |
//| numeri davvero asimmetrici sono gli offset d'ingresso (+3 / -2),  |
//| e per quelli l'EA ha gia' due input separati.                     |
//+------------------------------------------------------------------+
void CalcLivelli(double hi,double lo,double pip,
                 double offBuy,double offSell,double slPips,double tpPips,
                 double &buyPx,double &buySL,double &buyTP,
                 double &sellPx,double &sellSL,double &sellTP)
  {
   buyPx  = hi + offBuy*pip;
   buySL  = buyPx - slPips*pip;
   buyTP  = buyPx + tpPips*pip;
   sellPx = lo - offSell*pip;
   sellSL = sellPx + slPips*pip;
   sellTP = sellPx - tpPips*pip;
  }

//+------------------------------------------------------------------+
//| Piazza i due ordini pendenti sul range delle candele [1] e [2]   |
//+------------------------------------------------------------------+
void PlaceOrders(datetime nowBar)
  {
   double pip=PipSize();
   double h1=iHigh(_Symbol,PERIOD_M5,1), h2=iHigh(_Symbol,PERIOD_M5,2);
   double l1=iLow(_Symbol,PERIOD_M5,1),  l2=iLow(_Symbol,PERIOD_M5,2);
   double hi=MathMax(h1,h2), lo=MathMin(l1,l2);
   if(hi<=0 || lo<=0 || hi<=lo){ Log("range non valido."); return; }

   double buyPx,buySL,buyTP,sellPx,sellSL,sellTP;
   CalcLivelli(hi,lo,pip,InpBuyOffsetPips,InpSellOffsetPips,InpSLpips,InpTPpips,
               buyPx,buySL,buyTP,sellPx,sellSL,sellTP);
   buyPx =NormalizePrice(buyPx);  buySL =NormalizePrice(buySL);  buyTP =NormalizePrice(buyTP);
   sellPx=NormalizePrice(sellPx); sellSL=NormalizePrice(sellSL); sellTP=NormalizePrice(sellTP);

   double lot=LotByRisk(InpRiskRefSLpips*pip);
   if(lot<=0){ Log("lotto nullo."); return; }

   // scadenza: oggi all'orario server impostato
   MqlDateTime e; TimeToStruct(nowBar,e); e.hour=InpExpiryHour; e.min=InpExpiryMin; e.sec=0;
   datetime exp=StructToTime(e);
   if(exp<=TimeCurrent()) exp=TimeCurrent()+3600;      // salvaguardia

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double minStop=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_PostNews")) return;
   string cBuy=InpComment+" BUY", cSell=InpComment+" SELL";
   // BUY STOP valido solo se sopra il prezzo attuale (+ stops level)
   if(buyPx>ask+minStop)
     {
      if(gTrade.BuyStop(lot,buyPx,_Symbol,buySL,buyTP,ORDER_TIME_SPECIFIED,exp,cBuy))
         Log(StringFormat("BUY STOP @ %s SL %s TP %s lot %.2f",DoubleToString(buyPx,_Digits),
             DoubleToString(buySL,_Digits),DoubleToString(buyTP,_Digits),lot));
      else Log("BUY STOP fallito: "+gTrade.ResultRetcodeDescription());
     }
   else Log("prezzo gia' sopra il range: niente BUY STOP.");

   // SELL STOP valido solo se sotto il prezzo attuale (- stops level)
   if(sellPx<bid-minStop)
     {
      if(gTrade.SellStop(lot,sellPx,_Symbol,sellSL,sellTP,ORDER_TIME_SPECIFIED,exp,cSell))
         Log(StringFormat("SELL STOP @ %s SL %s TP %s lot %.2f",DoubleToString(sellPx,_Digits),
             DoubleToString(sellSL,_Digits),DoubleToString(sellTP,_Digits),lot));
      else Log("SELL STOP fallito: "+gTrade.ResultRetcodeDescription());
     }
   else Log("prezzo gia' sotto il range: niente SELL STOP.");
  }

//+------------------------------------------------------------------+
//| OCO: appena una gamba diventa POSIZIONE, cancella il pendente    |
//| dell'altra gamba (stesso magic). Un solo trade per evento.       |
//+------------------------------------------------------------------+
void OcoCheck()
  {
   if(!InpUseOCO) return;
   // ho una posizione aperta del mio magic?
   bool hasPos=false;
   for(int i=PositionsTotal()-1;i>=0 && !hasPos;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         hasPos=true;
     }
   if(!hasPos) return;
   // si': cancello ogni pendente residuo del mio magic (l'altra gamba)
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic)
        { if(gTrade.OrderDelete(tk)) Log("OCO: cancellata la gamba opposta (ticket "+(string)tk+")."); }
     }
  }

//+------------------------------------------------------------------+
//| Trailing ECB: se +Trigger pip di profitto, accorcia lo SL        |
//+------------------------------------------------------------------+
void ManageTrailing()
  {
   if(!InpUseTrail25) return;
   double pip=PipSize();
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double profitPips = isLong ? (bid-openP)/pip : (openP-ask)/pip;
      if(profitPips < InpTrailTriggerPips) continue;
      double newSL = isLong ? NormalizePrice(openP-InpTrailNewSLpips*pip)
                            : NormalizePrice(openP+InpTrailNewSLpips*pip);
      if(isLong && newSL>sl) gTrade.PositionModify(tk,newSL,PositionGetDouble(POSITION_TP));
      if(!isLong && (newSL<sl||sl==0)) gTrade.PositionModify(tk,newSL,PositionGetDouble(POSITION_TP));
     }
  }

//+------------------------------------------------------------------+
//| Chiude TUTTE le mie posizioni e cancella i miei pendenti         |
//+------------------------------------------------------------------+
int CloseAllMine()
  {
   int acted=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic)
        { if(gTrade.OrderDelete(t)) acted++; }
     }
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong t=PositionGetTicket(i);
      if(t==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
        { if(gTrade.PositionClose(t)) acted++; }
     }
   return(acted);
  }

//+------------------------------------------------------------------+
//| Chiusura a SCADENZA (strategia: tenere fino alle 21:45 IT =      |
//| 20:45 server, poi chiudere). Chiude SEMPRE la posizione aperta   |
//| se non e' gia' andata a TP/SL, e cancella i pendenti residui.    |
//+------------------------------------------------------------------+
void ExpiryCloseCheck()
  {
   if(!InpCloseAtExpiry) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   int nowMin = now.hour*60+now.min;
   int expMin = InpExpiryHour*60+InpExpiryMin;
   // finestra: dall'orario di scadenza fino a fine giornata (evita di
   // toccare le posizioni prima della scadenza; l'azione e' alle 19:40).
   if(nowMin < expMin) return;
   if(CloseAllMine()>0)
      Log(StringFormat("scadenza %02d:%02d server: chiuse posizioni/pendenti (fine finestra strategia).",
          InpExpiryHour,InpExpiryMin));
  }

//+------------------------------------------------------------------+
//| Chiusura venerdi sera: niente ordini/posizioni nel weekend       |
//+------------------------------------------------------------------+
void FridayCloseCheck()
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_week!=5) return;                       // 5 = venerdi
   if(now.hour*60+now.min < InpFridayCloseHour*60+InpFridayCloseMin) return;
   CloseAllMine();
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

//==================================================================
//  FILTRO NOTIZIE (CSV in Common\Files, con ripiego su MQL5\Files)
//  Formato atteso, separatore ';' :
//      Data Ora;Impatto;Valuta;Titolo
//      2010.01.08 13:30;High;USD;Unemployment Rate
//  L'intestazione non va tolta: StringToTime("Data Ora") torna 0 e la
//  riga viene saltata da sola.
//  NewsToday() confronta SOLO anno/mese/giorno -> il FUSO del file e'
//  ininfluente finche' gli eventi non sono a ridosso della mezzanotte
//  (questa famiglia sta fra le 12:15 e le 20:00 UTC). Il calendario di
//  casa lo produce backtest_pipeline/costruisci_news_postnews.py.
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0); ArrayResize(gNewsTitle,0);

   // NEL TESTER OGNI AGENTE HA LA SUA SANDBOX MQL5\Files e i driver di
   // casa non ci copiano niente: senza FILE_COMMON il FileOpen falliva,
   // il calendario restava vuoto e il filtro si spegneva IN SILENZIO.
   // E' la causa (b) del round nullo del 07/08. Prima Common, poi la
   // sandbox, e si dice quale ha risposto.
   int h=INVALID_HANDLE;
   gNewsDove="(non trovato)";
   if(InpNewsCommon)
     {
      h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
      if(h!=INVALID_HANDLE) gNewsDove="Common\\Files";
     }
   if(h==INVALID_HANDLE)
     {
      h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
      if(h!=INVALID_HANDLE) gNewsDove="MQL5\\Files (sandbox)";
     }
   if(h==INVALID_HANDLE)
     {
      Print("[PostNews][NEWS] CALENDARIO CIECO: '",InpNewsFile,
            "' non trovato ne' in Common\\Files ne' nella sandbox. ",
            "Con InpRestrictToNews=true NON verra' piazzato UN SOLO ORDINE: ",
            "una passata cosi' NON misura la strategia, misura il nulla. ",
            "NON leggerla come 'niente edge'.");
      return;
     }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      string sTitle=FileIsLineEnding(h)?"":FileReadString(h);   // 4a colonna = titolo
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1); ArrayResize(gNewsTitle,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsTitle[n]=sTitle; gNewsCount=n+1;
     }
   FileClose(h);

   // Quanti eventi passano DAVVERO i filtri di questo preset, e in che
   // finestra di date. E' la riga che avrebbe evitato il round nullo:
   // 17 eventi tutti del 2026 su un backtest 2024 si vedevano subito.
   int utili=0; datetime dmin=0,dmax=0;
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(StringLen(InpNewsTitleMatch)>0 && StringFind(gNewsTitle[i],InpNewsTitleMatch)<0) continue;
      utili++;
      if(dmin==0 || gNewsTime[i]<dmin) dmin=gNewsTime[i];
      if(gNewsTime[i]>dmax) dmax=gNewsTime[i];
     }
   gNewsUtili=utili;
   PrintFormat("[PostNews][NEWS] letto da %s | righe %d | UTILI per questo preset %d "
               "(impatto>=%d, valuta '%s', titolo contiene '%s') | dal %s al %s",
               gNewsDove,gNewsCount,utili,InpNewsMinImpact,InpNewsCurrencies,InpNewsTitleMatch,
               (dmin>0?TimeToString(dmin,TIME_DATE):"-"),(dmax>0?TimeToString(dmax,TIME_DATE):"-"));
   if(utili==0)
      Print("[PostNews][NEWS] CANARINO ROSSO: il calendario si legge ma per QUESTO ",
            "preset non contiene NEMMENO UN evento. Con InpRestrictToNews=true la ",
            "passata fara' ZERO trade. Controlla InpNewsTitleMatch / InpNewsCurrencies ",
            "e che il file copra il periodo del test. UNA PASSATA COSI' SI BUTTA.");
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

double OnTester()
  {
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
