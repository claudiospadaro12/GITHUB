//+------------------------------------------------------------------+
//|                                          ABTG_Notte_Study.mq5     |
//|                                                                  |
//|  STUDIO DEL MOVIMENTO NOTTURNO - "prima i dati".                  |
//|                                                                  |
//|  Domanda di Claudio (05/08): "Emiliano racconta che l'oro di      |
//|  notte fa dei bei movimenti, dice intorno alle 3 di notte (2 su   |
//|  BCM). Dovremmo capire quante volte fa il movimento min e max     |
//|  della notte."                                                    |
//|                                                                  |
//|  Qui NON si tradano: si MISURANO tre cose distinte.               |
//|                                                                  |
//|   1) A CHE ORA nascono il massimo e il minimo della notte.        |
//|      Se il racconto e' vero, l'istogramma deve avere una gobba    |
//|      sull'ora indicata. Se e' piatto, l'ora non conta.            |
//|                                                                  |
//|   2) QUANTO VALE LO SWING fra i due estremi (dal primo che si     |
//|      forma al secondo). E' il movimento "min -> max" di cui       |
//|      parla Claudio: quello che uno vorrebbe prendere.             |
//|                                                                  |
//|   3) COSA FA POI LA SESSIONE: dopo l'apertura, il prezzo rompe    |
//|      prima il massimo o prima il minimo della notte, e di quanto  |
//|      va oltre. E' il presupposto del ABTG_MaxMinNotte, mai        |
//|      misurato a parte.                                            |
//|                                                                  |
//|  ⚠️ ORE IN ORA SERVER. Regola BCM: ora italiana - 1.              |
//|     Le "3 di notte" italiane sono le 2 del server.                |
//|                                                                  |
//|  USO: trascina lo script sul grafico del simbolo (XAUUSD per      |
//|  l'oro) e premi OK. Scrive ABTG_Notte_Study_<simbolo>.csv in      |
//|  MQL5\Files e stampa gli aggregati nel tab "Esperti".             |
//|                                                                  |
//|  Serve lo storico M5: se manca, lancia prima                      |
//|  ABTG_HistoryDownloader.                                          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#property script_show_inputs

input group "=== Finestra notturna (ORA SERVER!) ==="
input int    InpNightStartHour = 22;   // Inizio notte (server). BCM: 22 = 23:00 IT
input int    InpNightEndHour   = 7;    // Fine notte (server, esclusa). BCM: 7 = 08:00 IT
input int    InpFocusHour      = 2;    // Ora "sospetta" da verificare (server). 2 = 3:00 IT (Emiliano)
input int    InpFocusWidth     = 1;    // Ampiezza della finestra sospetta, in ore (1 = solo quell'ora)

input group "=== Sessione del giorno dopo (ORA SERVER) ==="
input int    InpSessStartHour  = 8;    // Apertura sessione (server)
input int    InpSessEndHour    = 17;   // Fine sessione (server)
input int    InpSessEndMin     = 30;   // Minuti

input group "=== Soglia di 'movimento buono' ==="
input double InpSwingMinPts    = 0;    // Swing minimo in PUNTI per contare come "buono" (0 = auto: mediana)

input group "=== Storico ==="
input int    InpDaysBack       = 730;  // Giorni di calendario indietro

//--- una notte misurata
struct Notte
  {
   datetime dataKey;      // giorno di riferimento (quello della SERA)
   double   hi, lo;       // estremi della notte
   int      hiHour, loHour;   // ora server in cui si sono formati
   bool     loPrima;      // true = prima il minimo, poi il massimo (swing al rialzo)
   double   rangePts;     // ampiezza della notte = anche lo swing dal 1o al 2o estremo
   double   focusPts;     // escursione dentro la finestra sospetta, in punti
   int      rottura;      // sessione: +1 rompe il max, -1 rompe il min, 0 nessuno
   double   oltrePts;     // quanto va oltre l'estremo rotto, in punti
   bool     valida;
  };

//+------------------------------------------------------------------+
int OraDi(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.hour; }
int MinutiDi(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.hour*60+s.min; }

//--- chiave della notte: sposto indietro di InpNightStartHour ore.
//    Cosi' il "giorno logico" parte alle 22:00 e finisce alle 21:59 del
//    giorno dopo: dentro ci sta PRIMA la notte (a cavallo di mezzanotte,
//    non spezzata) e POI la sessione che la segue. L'ordine conta: la
//    domanda e' cosa fa la sessione DOPO quella notte, non prima.
datetime ChiaveNotte(datetime t)
  {
   datetime shifted = t - (datetime)InpNightStartHour*3600;
   return (datetime)((long)shifted/86400*86400);
  }

//--- la barra appartiene alla finestra notturna?
bool InNotte(int ora)
  {
   if(InpNightStartHour <= InpNightEndHour)          // notte "dentro" la giornata
      return(ora>=InpNightStartHour && ora<InpNightEndHour);
   return(ora>=InpNightStartHour || ora<InpNightEndHour);  // a cavallo di mezzanotte
  }

//--- la barra e' nella finestra sospetta (es. le 2 del server)?
bool InFocus(int ora)
  {
   for(int k=0;k<InpFocusWidth;k++)
      if(ora == (InpFocusHour+k)%24) return(true);
   return(false);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   double pt = _Point;
   datetime to   = TimeCurrent();
   datetime from = to - (datetime)InpDaysBack*24*60*60;

   MqlRates m5[];
   int n = CopyRates(_Symbol, PERIOD_M5, from, to, m5);
   if(n<=0){ Print("Nessun dato M5 su ",_Symbol,". Lancia prima ABTG_HistoryDownloader."); return; }
   Print("== Studio notte ",_Symbol,": ",n," barre M5 caricate ==");

   Notte notti[]; ArrayResize(notti,0);

   int i=0;
   while(i<n)
     {
      datetime key = ChiaveNotte(m5[i].time);

      //--- 1) scorro tutte le barre di questo giorno logico e misuro la notte
      double hi=0, lo=0; bool have=false;
      int    hiIdx=-1, loIdx=-1;
      double fHi=0, fLo=0; bool haveF=false;
      int    j=i;
      for(; j<n && ChiaveNotte(m5[j].time)==key; j++)
        {
         int ora = OraDi(m5[j].time);
         if(!InNotte(ora)) continue;
         if(!have){ hi=m5[j].high; lo=m5[j].low; hiIdx=j; loIdx=j; have=true; }
         else
           {
            if(m5[j].high>hi){ hi=m5[j].high; hiIdx=j; }
            if(m5[j].low <lo){ lo=m5[j].low;  loIdx=j; }
           }
         if(InFocus(ora))
           {
            if(!haveF){ fHi=m5[j].high; fLo=m5[j].low; haveF=true; }
            else { if(m5[j].high>fHi) fHi=m5[j].high; if(m5[j].low<fLo) fLo=m5[j].low; }
           }
        }
      int fineGiorno = j;   // prima barra del giorno logico successivo

      if(!have || hi<=lo){ i=fineGiorno; continue; }

      Notte nt;
      nt.dataKey  = m5[i].time;
      nt.hi       = hi;  nt.lo = lo;
      nt.hiHour   = OraDi(m5[hiIdx].time);
      nt.loHour   = OraDi(m5[loIdx].time);
      nt.loPrima  = (loIdx < hiIdx);
      // lo swing dal primo estremo al secondo coincide con l'ampiezza: se il
      // minimo viene prima, il movimento e' lo-hi; se viene prima il massimo,
      // e' hi-lo. In entrambi i casi vale (hi-lo). Un campo solo, non due.
      nt.rangePts = (hi-lo)/pt;
      nt.focusPts = haveF ? (fHi-fLo)/pt : 0.0;
      nt.rottura  = 0;
      nt.oltrePts = 0.0;
      nt.valida   = true;

      //--- 2) la sessione del giorno dopo: rompe prima il max o prima il min?
      int sStart = InpSessStartHour*60;
      int sEnd   = InpSessEndHour*60+InpSessEndMin;
      double estremoOltre = 0.0;
      for(int b=i; b<fineGiorno; b++)
        {
         int mm = MinutiDi(m5[b].time);
         int ora= OraDi(m5[b].time);
         if(InNotte(ora)) continue;              // la notte l'ho gia' usata
         if(mm<sStart || mm>=sEnd) continue;
         if(nt.rottura==0)
           {
            bool su = (m5[b].high>hi), giu = (m5[b].low<lo);
            if(su && !giu)      nt.rottura=+1;
            else if(giu && !su) nt.rottura=-1;
            else if(su && giu)  nt.rottura = (m5[b].close>=m5[b].open)?+1:-1;  // ambigua
            if(nt.rottura!=0) estremoOltre = (nt.rottura>0)? m5[b].high : m5[b].low;
           }
         else
           {
            if(nt.rottura>0 && m5[b].high>estremoOltre) estremoOltre=m5[b].high;
            if(nt.rottura<0 && m5[b].low <estremoOltre) estremoOltre=m5[b].low;
           }
        }
      if(nt.rottura>0) nt.oltrePts = (estremoOltre-hi)/pt;
      if(nt.rottura<0) nt.oltrePts = (lo-estremoOltre)/pt;

      int sz=ArraySize(notti); ArrayResize(notti,sz+1); notti[sz]=nt;
      i = fineGiorno;
     }

   int N = ArraySize(notti);
   if(N==0){ Print("Nessuna notte completa trovata. Controlla le ore server e lo storico."); return; }

   //--- CSV
   int fh=FileOpen("ABTG_Notte_Study_"+_Symbol+".csv", FILE_WRITE|FILE_CSV|FILE_ANSI, ';');
   if(fh!=INVALID_HANDLE)
     {
      FileWrite(fh,"data","ampiezza_notte_pts","ora_massimo","ora_minimo","ordine",
                "escursione_ora_"+IntegerToString(InpFocusHour)+"_pts","quota_su_notte_%",
                "sessione_rompe","punti_oltre");
      for(int k=0;k<N;k++)
        {
         double quota = (notti[k].rangePts>0)? 100.0*notti[k].focusPts/notti[k].rangePts : 0.0;
         FileWrite(fh, TimeToString(notti[k].dataKey,TIME_DATE),
                   DoubleToString(notti[k].rangePts,0),
                   IntegerToString(notti[k].hiHour), IntegerToString(notti[k].loHour),
                   (notti[k].loPrima?"MIN poi MAX":"MAX poi MIN"),
                   DoubleToString(notti[k].focusPts,0), DoubleToString(quota,1),
                   (notti[k].rottura>0?"MAX":(notti[k].rottura<0?"MIN":"nessuno")),
                   DoubleToString(notti[k].oltrePts,0));
        }
      FileClose(fh);
     }

   //--- 1. A CHE ORA nascono gli estremi
   Print("");
   Print("--- 1) A CHE ORA (server) nascono massimo e minimo della notte  [",N," notti] ---");
   Print("    ora | massimi | minimi | estremi totali");
   int totEstremi = 2*N;
   for(int h=0;h<24;h++)
     {
      if(!InNotte(h)) continue;
      int cH=0,cL=0;
      for(int k=0;k<N;k++){ if(notti[k].hiHour==h) cH++; if(notti[k].loHour==h) cL++; }
      if(cH==0 && cL==0) continue;
      double perc = 100.0*(cH+cL)/totEstremi;
      string barra=""; for(int b=0;b<(int)(perc/2);b++) barra+="#";
      Print(StringFormat("    %02d:00 | %5d | %5d | %5.1f%% %s", h, cH, cL, perc, barra));
     }
   //--- quanto pesa la finestra sospetta
   int inFocus=0;
   for(int k=0;k<N;k++)
     {
      if(InFocus(notti[k].hiHour)) inFocus++;
      if(InFocus(notti[k].loHour)) inFocus++;
     }
   int oreNotte=0; for(int h=0;h<24;h++) if(InNotte(h)) oreNotte++;
   double atteso = 100.0*InpFocusWidth/MathMax(1,oreNotte);
   double reale  = 100.0*inFocus/totEstremi;
   Print(StringFormat("    -> nella finestra %02d:00-%02d:00 server cade il %.1f%% degli estremi (a caso sarebbe %.1f%%)",
                      InpFocusHour,(InpFocusHour+InpFocusWidth)%24, reale, atteso));
   if(reale > atteso*1.3)      Print("       LETTURA: c'e' davvero una concentrazione. Il racconto regge.");
   else if(reale < atteso*0.8) Print("       LETTURA: in quell'ora ci sono MENO estremi del caso. Il racconto non regge.");
   else                        Print("       LETTURA: distribuzione piatta. L'ora, da sola, non e' un'informazione.");

   //--- 2. QUANTO VALE lo swing della notte
   double sw[]; ArrayResize(sw,N);
   for(int k=0;k<N;k++) sw[k]=notti[k].rangePts;
   ArraySort(sw);
   double med = sw[N/2];
   double q25 = sw[N/4], q75 = sw[(3*N)/4];
   double soglia = (InpSwingMinPts>0)? InpSwingMinPts : med;
   int sopra=0; for(int k=0;k<N;k++) if(notti[k].rangePts>=soglia) sopra++;
   int suRialzo=0; for(int k=0;k<N;k++) if(notti[k].loPrima) suRialzo++;
   Print("");
   Print("--- 2) QUANTO VALE il movimento min<->max della notte ---");
   Print(StringFormat("    ampiezza mediana: %.0f punti  (25%%: %.0f · 75%%: %.0f · max: %.0f)",
                      med, q25, q75, sw[N-1]));
   Print(StringFormat("    notti sopra %.0f punti: %d su %d (%.1f%%)", soglia, sopra, N, 100.0*sopra/N));
   Print(StringFormat("    ordine degli estremi: MIN poi MAX (swing al rialzo) nel %.1f%% delle notti", 100.0*suRialzo/N));
   Print("    NB: e' l'escursione MASSIMA teorica. Nessuno prende minimo e massimo esatti:");
   Print("        e' il tetto di quello che un EA notturno potrebbe sperare, non il suo profitto.");

   //--- 3. COSA FA LA SESSIONE dopo
   int rMax=0,rMin=0,rNo=0; double sommaOltre=0;
   for(int k=0;k<N;k++)
     {
      if(notti[k].rottura>0){ rMax++; sommaOltre+=notti[k].oltrePts; }
      else if(notti[k].rottura<0){ rMin++; sommaOltre+=notti[k].oltrePts; }
      else rNo++;
     }
   int rotte = rMax+rMin;
   Print("");
   Print(StringFormat("--- 3) COSA FA LA SESSIONE %02d:00-%02d:%02d (server) dopo quella notte ---",
                      InpSessStartHour, InpSessEndHour, InpSessEndMin));
   Print(StringFormat("    rompe il MASSIMO notte per primo: %d (%.1f%%)", rMax, 100.0*rMax/N));
   Print(StringFormat("    rompe il MINIMO  notte per primo: %d (%.1f%%)", rMin, 100.0*rMin/N));
   Print(StringFormat("    resta DENTRO la notte:            %d (%.1f%%)", rNo,  100.0*rNo/N));
   if(rotte>0)
      Print(StringFormat("    quando rompe, va oltre in media %.0f punti (= quanto puo' prendere il MaxMinNotte)",
                         sommaOltre/rotte));

   Print("");
   Print("== CSV: MQL5\\Files\\ABTG_Notte_Study_",_Symbol,".csv ==");
   Print("   Ore in ORA SERVER. Regola BCM: ora italiana - 1.");
  }
//+------------------------------------------------------------------+
