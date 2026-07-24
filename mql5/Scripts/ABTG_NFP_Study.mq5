//+------------------------------------------------------------------+
//|                                            ABTG_NFP_Study.mq5     |
//|                                                                  |
//|  STUDIO del comportamento del NASDAQ (o altro) sull'uscita del    |
//|  Non-Farm Payrolls (NFP), per capire PRIMA di costruire un EA:    |
//|    - la candela di rilascio parte forte e continua?               |
//|    - oppure spikes, ritraccia e poi parte?                        |
//|    - oppure si ribalta (whipsaw)?                                 |
//|                                                                  |
//|  Per ogni NFP (primo venerdi' del mese) misura, dalla candela di  |
//|  rilascio, quanto e' andata a favore (MFE) e quanto contro (MAE)  |
//|  nei minuti successivi, e dove ha chiuso. Scrive tutto in         |
//|  MQL5\Files\ABTG_NFP_Study.csv (da mandare a Claude).             |
//|                                                                  |
//|  USO: trascina lo script su un grafico NASUSD, premi OK.          |
//|  ⚠️ Orario in ORA SERVER. NFP = 14:30 IT. Se sul TUO server la    |
//|     candela del rilascio non e' alle 13:30, correggi Inp Release. |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSymbol        = "NASUSD";     // simbolo da studiare
input ENUM_TIMEFRAMES InpTF   = PERIOD_M5;    // TF della candela di rilascio (prova M5 o M1)
input int    InpReleaseHour   = 13;           // ORA SERVER del rilascio NFP (14:30 IT = 13:30 server BCM)
input int    InpReleaseMin    = 30;           // minuti (controlla sul TUO grafico dove spara!)
input int    InpMinutesAfter  = 60;           // quanti minuti seguire dopo il rilascio
input int    InpFromYear      = 2024;         // da che anno cercare gli NFP

//+------------------------------------------------------------------+
double Pt(){ double p=SymbolInfoDouble(InpSymbol,SYMBOL_POINT); return (p>0?p:_Point); }

// primo venerdi' del mese (y,m) all'orario di rilascio (server)
datetime FirstFriday(int y,int m)
  {
   for(int d=1; d<=7; d++)
     {
      MqlDateTime t; t.year=y; t.mon=m; t.day=d; t.hour=InpReleaseHour; t.min=InpReleaseMin; t.sec=0;
      datetime dt=StructToTime(t);
      MqlDateTime c; TimeToStruct(dt,c);
      if(c.day_of_week==5) return dt;   // 5 = venerdi'
     }
   return 0;
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   if(!SymbolSelect(InpSymbol,true)){ Print("Simbolo non disponibile: ",InpSymbol); return; }
   double point=Pt();

   int fh=FileOpen("ABTG_NFP_Study.csv",FILE_WRITE|FILE_CSV|FILE_ANSI,",");
   if(fh!=INVALID_HANDLE)
      FileWrite(fh,"Data","Dir","RangeRilascioPt","CorpoPt","MFE_pt","MAE_pt",
                "Close15_pt","Close30_pt","Close60_pt","Esito");

   MqlDateTime nowdt; TimeToStruct(TimeCurrent(),nowdt);
   int done=0, skip=0;

   for(int y=InpFromYear; y<=nowdt.year; y++)
     for(int m=1; m<=12 && !IsStopped(); m++)
       {
        if(y==nowdt.year && m>nowdt.mon) break;
        datetime rel=FirstFriday(y,m);
        if(rel<=0 || rel>=TimeCurrent()) continue;

        // candele dal rilascio in avanti
        MqlRates r[];
        int got=CopyRates(InpSymbol,InpTF,rel,rel+(InpMinutesAfter+10)*60,r);
        if(got<3){ skip++; continue; }
        // r[0] deve essere la candela di rilascio (apre all'orario)
        if(MathAbs((long)r[0].time-(long)rel) > 5*60){ skip++; continue; } // dati mancanti/gap

        double relOpen=r[0].open, relClose=r[0].close, relHi=r[0].high, relLo=r[0].low;
        int dir = (relClose>=relOpen) ? +1 : -1;               // direzione del candelone
        double rangePt=(relHi-relLo)/point;
        double bodyPt =MathAbs(relClose-relOpen)/point;

        // MFE/MAE nei minuti successivi, rispetto alla direzione del candelone
        double maxHi=relClose, minLo=relClose;
        double close15=relClose, close30=relClose, close60=relClose;
        for(int i=1;i<got;i++)
          {
           if((long)r[i].time - (long)rel > InpMinutesAfter*60) break;
           if(r[i].high>maxHi) maxHi=r[i].high;
           if(r[i].low <minLo) minLo=r[i].low;
           long mins=((long)r[i].time-(long)rel)/60 + (PeriodSeconds(InpTF)/60); // fine candela
           if(mins<=15) close15=r[i].close;
           if(mins<=30) close30=r[i].close;
           if(mins<=60) close60=r[i].close;
          }
        double mfe = (dir>0 ? (maxHi-relClose) : (relClose-minLo))/point;   // a favore
        double mae = (dir>0 ? (relClose-minLo) : (maxHi-relClose))/point;   // contro
        double c60dir = (dir>0 ? (close60-relClose) : (relClose-close60))/point;

        // classificazione grezza (la fine la faccio io sul CSV)
        string esito;
        if(c60dir<0)                          esito="REVERSAL";        // a +60 e' andato contro
        else if(mae<=rangePt*0.5 && mfe>=rangePt) esito="CONTINUA_FORTE"; // poco ritraccia, molto va
        else if(mae>=rangePt*0.8 && mfe>=rangePt) esito="RITRACCIA_POI_PARTE";
        else                                   esito="MISTO";

        if(fh!=INVALID_HANDLE)
           FileWrite(fh,TimeToString(rel,TIME_DATE|TIME_MINUTES),(dir>0?"UP":"DOWN"),
                     DoubleToString(rangePt,0),DoubleToString(bodyPt,0),
                     DoubleToString(mfe,0),DoubleToString(mae,0),
                     DoubleToString((dir>0?close15-relClose:relClose-close15)/point,0),
                     DoubleToString((dir>0?close30-relClose:relClose-close30)/point,0),
                     DoubleToString(c60dir,0),esito);
        PrintFormat("%s  dir=%s range=%.0f MFE=%.0f MAE=%.0f close60=%.0f -> %s",
                    TimeToString(rel,TIME_DATE),(dir>0?"UP":"DOWN"),rangePt,mfe,mae,c60dir,esito);
        done++;
       }

   if(fh!=INVALID_HANDLE) FileClose(fh);
   PrintFormat("=== STUDIO NFP FINITO: %d eventi misurati, %d saltati (dati mancanti). CSV in MQL5\\Files\\ABTG_NFP_Study.csv ===",done,skip);
   Comment("Studio NFP completato. Manda ABTG_NFP_Study.csv a Claude.");
  }
//+------------------------------------------------------------------+
