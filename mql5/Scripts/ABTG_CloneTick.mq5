//+------------------------------------------------------------------+
//|                                          ABTG_CloneTick.mq5      |
//|  v1.00 (22/11/2026) -- NESSUN ORDINE. NON COMPILATA da agenti.   |
//|  Copia i TICK REALI di un simbolo del broker nel suo clone       |
//|  personalizzato (creato da ABTG_CloneIndiciTick), un giorno per  |
//|  volta, cosi il tester puo usare il Modello 4 (tick reali) sul   |
//|  clone con tick size 0,01. File (Common\Files):                  |
//|  ABTG_TICKCLONI_PROGRESSO.txt e a fine corsa                     |
//|  ABTG_TICKCLONI_FINE.txt. TerminalClose SOLO se                  |
//|  InpChiudiTerminale=true.                                        |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpCoppie = "U30USD>U30USD_T";
input string InpDa = "2024.09.20";        // inizio (incluso)
input string InpA  = "2025.01.01";        // fine (esclusa)
input bool   InpChiudiTerminale = false;

const string F_PROGRESSO = "ABTG_TICKCLONI_PROGRESSO.txt";
const string F_FINE      = "ABTG_TICKCLONI_FINE.txt";
string g_righe[];

//+------------------------------------------------------------------+
void Riga(const string s)
  {
   int n=ArraySize(g_righe);
   ArrayResize(g_righe,n+1);
   g_righe[n]=s;
   int h=FileOpen(F_PROGRESSO,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(h!=INVALID_HANDLE)
     {
      for(int i=0;i<=n;i++) FileWriteString(h,g_righe[i]+"\r\n");
      FileClose(h);
     }
   Print(s);
  }

//+------------------------------------------------------------------+
void Chiudi()
  {
   if(InpChiudiTerminale)
     {
      Sleep(2000);
      TerminalClose(0);
     }
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   ArrayResize(g_righe,0);
   Riga("COPIA TICK NEI CLONI - "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+" ora locale; da "+InpDa+" a "+InpA+" (esclusa)");
   string coppie[];
   int n=StringSplit(InpCoppie,',',coppie);
   datetime d0=StringToTime(InpDa+" 00:00");
   datetime d1=StringToTime(InpA+" 00:00");
   int ok=0, problemi=0;
   for(int i=0;i<n;i++)
     {
      string p[];
      if(StringSplit(coppie[i],'>',p)!=2) { Riga("COPPIA NON VALIDA: "+coppie[i]); problemi++; continue; }
      string src=p[0], dst=p[1];
      StringTrimLeft(src); StringTrimRight(src); StringTrimLeft(dst); StringTrimRight(dst);
      Riga("--- "+src+" -> "+dst);
      bool custom=false;
      if(!SymbolExist(dst,custom) || !custom) { Riga("  ERRORE: il clone "+dst+" non esiste (va creato prima con ABTG_CloneIndiciTick)"); problemi++; continue; }
      if(!SymbolSelect(src,true)) { Riga("  NON TROVATO: "+src); problemi++; continue; }
      SymbolSelect(dst,true);
      long totale=0; int giorni=0; int errori=0;
      for(datetime d=d0; d<d1; d+=86400)
        {
         long a=(long)d*1000;
         long b=(long)(d+86400)*1000-1;
         MqlTick tk[];
         int c=-1;
         for(int k=0;k<4;k++)
           {
            c=CopyTicksRange(src,tk,COPY_TICKS_ALL,(ulong)a,(ulong)b);
            if(c>=0) break;
            Sleep(300);
           }
         if(c<=0) continue;
         int r=CustomTicksReplace(dst,a,b,tk);
         if(r<0) { errori++; Riga("  ERRORE: CustomTicksReplace giorno "+TimeToString(d,TIME_DATE)+" err="+IntegerToString(GetLastError())); if(errori>=5) break; continue; }
         totale+=r; giorni++;
         if(giorni%20==0) Riga("  "+TimeToString(d,TIME_DATE)+": giorni copiati="+IntegerToString(giorni)+" tick="+IntegerToString((int)(totale/1000))+"k");
        }
      // controllo: ultimi 3 giorni, origine contro clone
      long a2=(long)(d1-3*86400)*1000, b2=(long)d1*1000-1;
      MqlTick t1[],t2[];
      int c1=CopyTicksRange(src,t1,COPY_TICKS_ALL,(ulong)a2,(ulong)b2);
      int c2=CopyTicksRange(dst,t2,COPY_TICKS_ALL,(ulong)a2,(ulong)b2);
      string esito=(totale>0 && errori==0 && c1>0 && c1==c2)?"OK":"PROBLEMI";
      Riga("  "+esito+";"+src+";"+dst+";giorni="+IntegerToString(giorni)+";tick="+IntegerToString((int)(totale/1000))+"k;errori="+IntegerToString(errori)+";controllo_ultimi3gg_origine="+IntegerToString(c1)+";clone="+IntegerToString(c2));
      if(esito=="OK") ok++; else problemi++;
     }
   Riga("RIEPILOGO: ok="+IntegerToString(ok)+" problemi="+IntegerToString(problemi));
   int hf=FileOpen(F_FINE,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(hf!=INVALID_HANDLE)
     {
      for(int i=0;i<ArraySize(g_righe);i++) FileWriteString(hf,g_righe[i]+"\r\n");
      FileClose(hf);
     }
   Chiudi();
  }
//+------------------------------------------------------------------+
