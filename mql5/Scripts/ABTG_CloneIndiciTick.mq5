//+------------------------------------------------------------------+
//|                                  ABTG_CloneIndiciTick.mq5        |
//|  v1.00 (22/11/2026) -- NESSUN ORDINE. NON COMPILATA da agenti.   |
//|  Crea simboli PERSONALIZZATI clonati dagli indici BCM con passo  |
//|  prezzo (tick size) 0,01 invece di 0,1: l'EA UBS manda stop con  |
//|  2 decimali e sugli indici BCM (tick size 0,1) il server li      |
//|  rifiuta ("Invalid stops"). Copia le barre M1 (spread incluso)   |
//|  dal simbolo di origine al clone. NON copia i tick.              |
//|  Coppie origine>clone (separate da virgola):                     |
//|   U30USD>U30USD_T, SPXUSD>SPXUSD_T, NASUSD>NASUSD_T,            |
//|   NASUSD_EXT>NASUSD_EXT_T, SPXUSD_EXT>SPXUSD_EXT_T              |
//|  File (cartella Common\Files): ABTG_CLONI_PROGRESSO.txt e a fine |
//|  corsa ABTG_CLONI_FINE.txt. TerminalClose SOLO se                |
//|  InpChiudiTerminale=true (lancio automatico).                    |
//+------------------------------------------------------------------+
#property script_show_inputs
#property version "1.00"

input string InpCoppie = "U30USD>U30USD_T,SPXUSD>SPXUSD_T,NASUSD>NASUSD_T,NASUSD_EXT>NASUSD_EXT_T,SPXUSD_EXT>SPXUSD_EXT_T";
input double InpTickSize = 0.01;      // nuovo passo prezzo del clone
input bool   InpChiudiTerminale = false;

const string F_PROGRESSO = "ABTG_CLONI_PROGRESSO.txt";
const string F_FINE      = "ABTG_CLONI_FINE.txt";
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
bool Sincronizza(const string sim)
  {
   for(int k=0;k<40;k++)
     {
      if((bool)SeriesInfoInteger(sim,PERIOD_M1,SERIES_SYNCHRONIZED)) return true;
      Sleep(500);
     }
   return false;
  }

//+------------------------------------------------------------------+
// copia le barre M1 di src in dst, a blocchi di 30 giorni
bool CopiaBarre(const string src,const string dst,long &totale,datetime &prima,datetime &ultima)
  {
   totale=0; prima=0; ultima=0;
   if(!SymbolSelect(src,true)) { Riga("  ERRORE: SymbolSelect("+src+") fallita"); return false; }
   Sincronizza(src);
   datetime t0=(datetime)SeriesInfoInteger(src,PERIOD_M1,SERIES_FIRSTDATE);
   datetime t1=(datetime)SeriesInfoInteger(src,PERIOD_M1,SERIES_LASTBAR_DATE);
   if(t0<=0 || t1<=0 || t1<t0) { Riga("  ERRORE: intervallo barre M1 non valido per "+src); return false; }
   datetime passo=30*86400;
   for(datetime t=t0; t<=t1; t+=passo)
     {
      datetime a=t;
      datetime b=(datetime)MathMin((double)(t+passo-1),(double)t1);
      MqlRates r[];
      int c=-1;
      for(int k=0;k<10;k++)
        {
         c=CopyRates(src,PERIOD_M1,a,b,r);
         if(c>0) break;
         if(c==0) break;   // intervallo senza barre
         Sleep(400);
        }
      if(c<=0) continue;
      int rr=CustomRatesReplace(dst,r[0].time,r[c-1].time,r);
      if(rr<0) { Riga("  ERRORE: CustomRatesReplace("+dst+") err="+IntegerToString(GetLastError())); return false; }
      totale+=c;
      if(prima==0) prima=r[0].time;
      ultima=r[c-1].time;
     }
   return (totale>0);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   ArrayResize(g_righe,0);
   Riga("CLONI INDICI (tick size "+DoubleToString(InpTickSize,4)+") - "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+" ora locale");
   string coppie[];
   int n=StringSplit(InpCoppie,',',coppie);
   int ok=0, problemi=0;
   for(int i=0;i<n;i++)
     {
      string p[];
      if(StringSplit(coppie[i],'>',p)!=2) { Riga("COPPIA NON VALIDA: "+coppie[i]); problemi++; continue; }
      string src=p[0], dst=p[1];
      StringTrimLeft(src); StringTrimRight(src); StringTrimLeft(dst); StringTrimRight(dst);
      Riga("--- "+src+" -> "+dst);
      if(!SymbolSelect(src,true)) { Riga("  NON TROVATO: "+src); problemi++; continue; }
      double ts=SymbolInfoDouble(src,SYMBOL_TRADE_TICK_SIZE);
      double tv=SymbolInfoDouble(src,SYMBOL_TRADE_TICK_VALUE);
      double tvp=SymbolInfoDouble(src,SYMBOL_TRADE_TICK_VALUE_PROFIT);
      double tvl=SymbolInfoDouble(src,SYMBOL_TRADE_TICK_VALUE_LOSS);
      int dg=(int)SymbolInfoInteger(src,SYMBOL_DIGITS);
      double pt=SymbolInfoDouble(src,SYMBOL_POINT);
      Riga("  origine: digits="+IntegerToString(dg)+" point="+DoubleToString(pt,8)+" tick_size="+DoubleToString(ts,8)+" tick_value="+DoubleToString(tv,8)+" tick_value_profit="+DoubleToString(tvp,8)+" tick_value_loss="+DoubleToString(tvl,8));
      if(ts<=0.0) { Riga("  ERRORE: tick size origine nullo"); problemi++; continue; }
      bool custom=false;
      if(SymbolExist(dst,custom))
        {
         if(!custom) { Riga("  ERRORE: "+dst+" esiste ed e un simbolo del broker: non lo tocco"); problemi++; continue; }
         Riga("  il clone esiste gia: lo aggiorno");
        }
      else
        {
         if(!CustomSymbolCreate(dst,"",src)) { Riga("  ERRORE: CustomSymbolCreate("+dst+") err="+IntegerToString(GetLastError())); problemi++; continue; }
        }
      double k=InpTickSize/ts;
      bool pr=true;
      pr=pr && CustomSymbolSetDouble(dst,SYMBOL_TRADE_TICK_SIZE,InpTickSize);
      pr=pr && CustomSymbolSetDouble(dst,SYMBOL_TRADE_TICK_VALUE,tv*k);
      pr=pr && CustomSymbolSetDouble(dst,SYMBOL_TRADE_TICK_VALUE_PROFIT,tvp*k);
      pr=pr && CustomSymbolSetDouble(dst,SYMBOL_TRADE_TICK_VALUE_LOSS,tvl*k);
      CustomSymbolSetString(dst,SYMBOL_DESCRIPTION,"ABTG clone di "+src+" con tick size "+DoubleToString(InpTickSize,4)+" (solo tester)");
      if(!pr) { Riga("  ERRORE: impostazione delle proprieta fallita err="+IntegerToString(GetLastError())); problemi++; continue; }
      SymbolSelect(dst,true);
      long tot; datetime pri,ult;
      bool cp=CopiaBarre(src,dst,tot,pri,ult);
      int dgc=(int)SymbolInfoInteger(dst,SYMBOL_DIGITS);
      double ptc=SymbolInfoDouble(dst,SYMBOL_POINT);
      double tsc=SymbolInfoDouble(dst,SYMBOL_TRADE_TICK_SIZE);
      double tvc=SymbolInfoDouble(dst,SYMBOL_TRADE_TICK_VALUE);
      int stl=(int)SymbolInfoInteger(dst,SYMBOL_TRADE_STOPS_LEVEL);
      // controllo: barre degli ultimi 20 giorni, origine contro clone
      MqlRates a1[],a2[];
      datetime fine=ult;
      int c1=CopyRates(src,PERIOD_M1,fine-20*86400,fine,a1);
      int c2=CopyRates(dst,PERIOD_M1,fine-20*86400,fine,a2);
      string esito=(cp && c1>0 && c1==c2 && dgc==dg && MathAbs(tsc-InpTickSize)<1e-12)?"OK":"PROBLEMI";
      Riga("  "+esito+";"+src+";"+dst+";barre="+IntegerToString((int)tot)+";prima="+TimeToString(pri,TIME_DATE|TIME_MINUTES)+";ultima="+TimeToString(ult,TIME_DATE|TIME_MINUTES)+";digits="+IntegerToString(dgc)+";point="+DoubleToString(ptc,8)+";tick_size="+DoubleToString(tsc,8)+";tick_value="+DoubleToString(tvc,8)+";stops_level="+IntegerToString(stl)+";controllo_20gg_origine="+IntegerToString(c1)+";clone="+IntegerToString(c2));
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
