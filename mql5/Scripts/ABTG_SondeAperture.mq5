//+------------------------------------------------------------------+
//|                                       ABTG_SondeAperture.mq5     |
//|  v1.00 (23/10/2026) -- SONDA DI SOLA LETTURA. NON COMPILATA.     |
//|  NESSUNA funzione di trading: non apre, non modifica, non chiude |
//|  ordini. Legge storia e indicatori e scrive CSV in Common\Files. |
//|  Criteri congelati PRIMA dei numeri:                              |
//|  report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md               |
//|   S1  filtro S&P del MaxMin (CorrBias) : ABTG_SONDA_SPX.csv      |
//|   S2  barra di fine range dell'ORB     : ABTG_SONDA_ORB.csv      |
//|   S3  box notturno del MaxMin          : ABTG_SONDA_BOX.csv      |
//|   S3b la barra della sera cambia il box? : ABTG_SONDA_BOX2.csv     |
//|  Si lancia a mano: trascinare lo script su un grafico QUALSIASI  |
//|  (non attaccare EA, non toccare Algo Trading). Orari = SERVER.   |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpSymOrb   = "U30USD";   // S2: simbolo dell'ORB
input string InpSymBox   = "D30EUR";   // S3: simbolo del MaxMin
input string InpSymSpx   = "SPXUSD";   // S1: simbolo del filtro
input int    InpGiorni   = 450;        // S2/S3: quanti giorni di calendario indietro
input int    InpOrbIniH  = 14;         // S2: inizio range (server)
input int    InpOrbIniM  = 30;
input int    InpOrbFinH  = 14;         // S2: la barra che INIZIA qui e' quella da misurare
input int    InpOrbFinM  = 45;
input int    InpBoxIniH  = 23;         // S3: inizio box (giorno prima)
input int    InpBoxIniM  = 0;
input int    InpBoxFinH  = 4;          // S3: fine box
input int    InpBoxFinM  = 59;
input int    InpIter     = 20;         // S1: iterazioni
input int    InpEmaVeloce= 14;
input int    InpEmaLenta = 100;
input int    InpAttesaMs = 8000;       // S1: attesa massima che gli handle siano pronti
input bool   InpChiudiTerminale = false; // true SOLO nel lancio automatico: a fine lavoro chiude il terminale

//--- seleziona il simbolo e aspetta che la storia M1 sia caricata (richiesta dei dati piu vecchi)
bool Prepara(const string sym)
  {
   if(!SymbolSelect(sym,true)) return(false);
   datetime vecchio=TimeCurrent()-(datetime)InpGiorni*86400;
   MqlRates tmp[];
   for(int k=0;k<60;k++)
     {
      if(CopyRates(sym,PERIOD_M1,vecchio,vecchio+7200,tmp)>0) break;
      if(Bars(sym,PERIOD_M1)>100000) break;
      Sleep(500);
     }
   PrintFormat("PREPARA %s: barre M1 disponibili %d",sym,Bars(sym,PERIOD_M1));
   return(true);
  }

//--- apre un CSV in Common\Files
int ApriCsv(const string nome,const string intestazione)
  {
   int h=FileOpen(nome,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE){ PrintFormat("SONDA: impossibile aprire %s, err=%d",nome,GetLastError()); return(INVALID_HANDLE); }
   FileWriteString(h,intestazione+"\r\n");
   return(h);
  }

//+------------------------------------------------------------------+
//| S2: la barra che inizia a fine range estende il range?            |
//+------------------------------------------------------------------+
void SondaOrb()
  {
   if(!Prepara(InpSymOrb)){ PrintFormat("S2: simbolo %s non selezionabile",InpSymOrb); return; }
   int h=ApriCsv("ABTG_SONDA_ORB.csv","data;dow;n_barre;prima;ultima;hiR;loR;hiBarra;loBarra;ext_su;ext_giu;ampiezza;completo");
   if(h==INVALID_HANDLE) return;
   datetime oggi=TimeCurrent(); MqlDateTime t0; TimeToStruct(oggi,t0); t0.hour=0; t0.min=0; t0.sec=0;
   datetime base=StructToTime(t0);
   int scritti=0;
   for(int g=InpGiorni; g>=1; g--)
     {
      datetime d0=base-(datetime)g*86400;
      MqlDateTime d; TimeToStruct(d0,d);
      if(d.day_of_week==0 || d.day_of_week==6) continue;
      datetime tS=d0+InpOrbIniH*3600+InpOrbIniM*60;
      datetime tF=d0+InpOrbFinH*3600+InpOrbFinM*60;      // inizio della barra di fine range
      MqlRates r[];
      int n=CopyRates(InpSymOrb,PERIOD_M1,tS,tF,r);        // barre con tempo in [tS, tF]
      if(n<=0) continue;
      bool completo=(r[0].time==tS && r[n-1].time==tF && n==(int)((tF-tS)/60)+1);
      double hiR=-1e18, loR=1e18;
      for(int i=0;i<n-1;i++){ if(r[i].high>hiR) hiR=r[i].high; if(r[i].low<loR) loR=r[i].low; }
      if(n<2) continue;
      double hiB=r[n-1].high, loB=r[n-1].low;
      double extSu=MathMax(0.0,hiB-hiR), extGiu=MathMax(0.0,loR-loB);
      FileWriteString(h,StringFormat("%s;%d;%d;%s;%s;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%d\r\n",
         TimeToString(d0,TIME_DATE),d.day_of_week,n,TimeToString(r[0].time,TIME_MINUTES),TimeToString(r[n-1].time,TIME_MINUTES),
         hiR,loR,hiB,loB,extSu,extGiu,hiR-loR,(completo?1:0)));
      scritti++;
     }
   FileClose(h);
   PrintFormat("S2: %d giorni scritti in ABTG_SONDA_ORB.csv",scritti);
  }

//+------------------------------------------------------------------+
//| S3: replica ComputeBox() del MaxMin (iBarShift exact=false)       |
//+------------------------------------------------------------------+
void SondaBox()
  {
   if(!Prepara(InpSymBox)){ PrintFormat("S3: simbolo %s non selezionabile",InpSymBox); return; }
   int h=ApriCsv("ABTG_SONDA_BOX.csv","data;dow;t_inizio_richiesto;t_barra_inizio;contaminato;n_barre;hi;lo;ampiezza");
   if(h==INVALID_HANDLE) return;
   datetime oggi=TimeCurrent(); MqlDateTime t0; TimeToStruct(oggi,t0); t0.hour=0; t0.min=0; t0.sec=0;
   datetime base=StructToTime(t0);
   int scritti=0;
   for(int g=InpGiorni; g>=1; g--)
     {
      datetime d0=base-(datetime)g*86400;
      MqlDateTime d; TimeToStruct(d0,d);
      if(d.day_of_week==0 || d.day_of_week==6) continue;
      datetime tEnd=d0+InpBoxFinH*3600+InpBoxFinM*60;
      datetime tStart=d0+InpBoxIniH*3600+InpBoxIniM*60-86400;   // come l'EA: il giorno prima, sempre
      int iS=iBarShift(InpSymBox,PERIOD_M1,tStart,false);
      int iE=iBarShift(InpSymBox,PERIOD_M1,tEnd,false);
      if(iS<0 || iE<0) continue;
      int start=MathMin(iS,iE);
      int count=MathAbs(iS-iE)+1;
      int hIdx=iHighest(InpSymBox,PERIOD_M1,MODE_HIGH,count,start);
      int lIdx=iLowest (InpSymBox,PERIOD_M1,MODE_LOW, count,start);
      if(hIdx<0 || lIdx<0) continue;
      double hi=iHigh(InpSymBox,PERIOD_M1,hIdx), lo=iLow(InpSymBox,PERIOD_M1,lIdx);
      datetime tB=iTime(InpSymBox,PERIOD_M1,iS);
      FileWriteString(h,StringFormat("%s;%d;%s;%s;%d;%d;%.2f;%.2f;%.2f\r\n",
         TimeToString(d0,TIME_DATE),d.day_of_week,TimeToString(tStart,TIME_DATE|TIME_MINUTES),TimeToString(tB,TIME_DATE|TIME_MINUTES),
         (tB<tStart?1:0),count,hi,lo,hi-lo));
      scritti++;
     }
   FileClose(h);
   PrintFormat("S3: %d giorni scritti in ABTG_SONDA_BOX.csv",scritti);
  }

//+------------------------------------------------------------------+
//| S3b: come S3, ma separa le barre "contaminanti" (prima di inizio) |
//+------------------------------------------------------------------+
void SondaBox2()
  {
   if(!Prepara(InpSymBox)){ PrintFormat("S3b: simbolo %s non selezionabile",InpSymBox); return; }
   int h=ApriCsv("ABTG_SONDA_BOX2.csv","data;dow;n_cont;t_cont;hi_cont;lo_cont;n_nom;hi_box;lo_box;hi_nom;lo_nom;cambia_alto;cambia_basso;delta_alto;delta_basso;ampiezza_nom");
   if(h==INVALID_HANDLE) return;
   datetime oggi=TimeCurrent(); MqlDateTime t0; TimeToStruct(oggi,t0); t0.hour=0; t0.min=0; t0.sec=0;
   datetime base=StructToTime(t0);
   int scritti=0;
   for(int g=InpGiorni; g>=1; g--)
     {
      datetime d0=base-(datetime)g*86400;
      MqlDateTime d; TimeToStruct(d0,d);
      if(d.day_of_week==0 || d.day_of_week==6) continue;
      datetime tEnd=d0+InpBoxFinH*3600+InpBoxFinM*60;
      datetime tStart=d0+InpBoxIniH*3600+InpBoxIniM*60-86400;
      int iS=iBarShift(InpSymBox,PERIOD_M1,tStart,false);
      int iE=iBarShift(InpSymBox,PERIOD_M1,tEnd,false);
      if(iS<0 || iE<0) continue;
      int start=MathMin(iS,iE);
      int count=MathAbs(iS-iE)+1;
      int hIdx=iHighest(InpSymBox,PERIOD_M1,MODE_HIGH,count,start);
      int lIdx=iLowest (InpSymBox,PERIOD_M1,MODE_LOW, count,start);
      if(hIdx<0 || lIdx<0) continue;
      double hiBox=iHigh(InpSymBox,PERIOD_M1,hIdx), loBox=iLow(InpSymBox,PERIOD_M1,lIdx);
      // barre contaminanti: dall'indice iS (la piu vecchia) verso le piu nuove, finche' il tempo e' prima di tStart
      int nCont=0; double hiC=-1e18, loC=1e18; datetime tC=0;
      int j=iS;
      while(j>=iE && j>=0 && iTime(InpSymBox,PERIOD_M1,j)<tStart)
        {
         double hh=iHigh(InpSymBox,PERIOD_M1,j), ll=iLow(InpSymBox,PERIOD_M1,j);
         if(hh>hiC) hiC=hh;
         if(ll<loC) loC=ll;
         if(nCont==0) tC=iTime(InpSymBox,PERIOD_M1,j);
         nCont++;
         j--;
        }
      int nNom=0; double hiN=0, loN=0;
      if(j>=iE && j>=0)
        {
         nNom=j-iE+1;
         int hN=iHighest(InpSymBox,PERIOD_M1,MODE_HIGH,nNom,iE);
         int lN=iLowest (InpSymBox,PERIOD_M1,MODE_LOW, nNom,iE);
         if(hN>=0 && lN>=0){ hiN=iHigh(InpSymBox,PERIOD_M1,hN); loN=iLow(InpSymBox,PERIOD_M1,lN); }
         else nNom=0;
        }
      int cAlto=0, cBasso=0; double dAlto=0, dBasso=0;
      if(nNom>0)
        {
         if(hiBox>hiN){ cAlto=1; dAlto=hiBox-hiN; }
         if(loBox<loN){ cBasso=1; dBasso=loN-loBox; }
        }
      FileWriteString(h,StringFormat("%s;%d;%d;%s;%.2f;%.2f;%d;%.2f;%.2f;%.2f;%.2f;%d;%d;%.2f;%.2f;%.2f\r\n",
         TimeToString(d0,TIME_DATE),d.day_of_week,nCont,(nCont>0?TimeToString(tC,TIME_DATE|TIME_MINUTES):""),
         (nCont>0?hiC:0.0),(nCont>0?loC:0.0),nNom,hiBox,loBox,hiN,loN,cAlto,cBasso,dAlto,dBasso,(nNom>0?hiN-loN:0.0)));
      scritti++;
     }
   FileClose(h);
   PrintFormat("S3b: %d giorni scritti in ABTG_SONDA_BOX2.csv",scritti);
  }

//--- bias dal confronto fra le due EMA (+1 se veloce>lenta, -1 se minore, 0 uguali)
int Segno(const double f,const double s){ return((f>s)?+1:((f<s)?-1:0)); }

//--- EMA a mano dalle chiusure (la piu' vecchia e' l'indice 0); restituisce il valore all'ultima barra
double EmaMano(const double &c[],const int n,const int periodo)
  {
   if(n<=0) return(0.0);
   double k=2.0/(periodo+1.0), e=c[0];
   for(int i=1;i<n;i++) e=c[i]*k+e*(1.0-k);
   return(e);
  }

//+------------------------------------------------------------------+
//| S1: CorrBias() con handle appena creati, lettura immediata        |
//+------------------------------------------------------------------+
void SondaSpx()
  {
   if(!Prepara(InpSymSpx)){ PrintFormat("S1: simbolo %s non selezionabile",InpSymSpx); return; }
   int h=ApriCsv("ABTG_SONDA_SPX.csv","iter;handle_ok;imm_f;imm_s;imm_ok;ms_pronto;pronto_ok;f_pronto;s_pronto;bias_pronto;f_mano;s_mano;bias_mano;gap_rel");
   if(h==INVALID_HANDLE) return;
   // chiusure H1 per il calcolo a mano: barre CHIUSE (si scarta la barra in formazione, indice 0 della serie)
   double cl[]; ArraySetAsSeries(cl,false);
   int nc=CopyClose(InpSymSpx,PERIOD_H1,1,1500,cl);        // dalla barra 1 (ultima chiusa) indietro 1500, in ordine cronologico
   for(int it=1; it<=InpIter; it++)
     {
      int hf=iMA(InpSymSpx,PERIOD_H1,InpEmaVeloce,0,MODE_EMA,PRICE_CLOSE);
      int hs=iMA(InpSymSpx,PERIOD_H1,InpEmaLenta, 0,MODE_EMA,PRICE_CLOSE);
      bool hok=(hf!=INVALID_HANDLE && hs!=INVALID_HANDLE);
      double f[1], s[1]; f[0]=0; s[0]=0;
      int immOk=0; double fi=0, si=0;
      if(hok)
        {
         int a=CopyBuffer(hf,0,1,1,f), b=CopyBuffer(hs,0,1,1,s);   // lettura IMMEDIATA, come CorrBias()
         immOk=(a==1 && b==1)?1:0; fi=f[0]; si=s[0];
        }
      // attesa che siano pronti
      uint t0=GetTickCount(); int prontoOk=0; double fp=0, sp=0; int msPronto=-1;
      if(hok)
        {
         while((int)(GetTickCount()-t0)<InpAttesaMs)
           {
            double f2[1], s2[1];
            if(BarsCalculated(hf)>0 && BarsCalculated(hs)>0 && CopyBuffer(hf,0,1,1,f2)==1 && CopyBuffer(hs,0,1,1,s2)==1)
              { prontoOk=1; fp=f2[0]; sp=s2[0]; msPronto=(int)(GetTickCount()-t0); break; }
            Sleep(50);
           }
        }
      double fm=0, sm=0; int biasM=0;
      if(nc>0){ fm=EmaMano(cl,nc,InpEmaVeloce); sm=EmaMano(cl,nc,InpEmaLenta); biasM=Segno(fm,sm); }
      int biasP=prontoOk?Segno(fp,sp):0;
      double gap=(sm!=0.0)?MathAbs(fm-sm)/sm:0.0;
      FileWriteString(h,StringFormat("%d;%d;%.4f;%.4f;%d;%d;%d;%.4f;%.4f;%d;%.4f;%.4f;%d;%.6f\r\n",
         it,(hok?1:0),fi,si,immOk,msPronto,prontoOk,fp,sp,biasP,fm,sm,biasM,gap));
      if(hf!=INVALID_HANDLE) IndicatorRelease(hf);
      if(hs!=INVALID_HANDLE) IndicatorRelease(hs);
      Sleep(500);
     }
   FileClose(h);
   Print("S1: scritto ABTG_SONDA_SPX.csv");
  }

void OnStart()
  {
   Print("ABTG_SondeAperture v1.00: SOLA LETTURA, nessun ordine. Orari = server.");
   SondaSpx();
   SondaOrb();
   SondaBox();
   SondaBox2();
   Print("ABTG_SondeAperture: finito. File in Common\\Files: ABTG_SONDA_SPX.csv, ABTG_SONDA_ORB.csv, ABTG_SONDA_BOX.csv, ABTG_SONDA_BOX2.csv");
   int hf=FileOpen("ABTG_SONDA_FINE.txt",FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hf!=INVALID_HANDLE){ FileWriteString(hf,"FINE "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n"); FileClose(hf); }
   if(InpChiudiTerminale){ Sleep(2000); TerminalClose(0); }
  }
