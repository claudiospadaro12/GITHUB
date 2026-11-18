//+------------------------------------------------------------------+
//|                                          ABTG_VolSpread.mq5      |
//|  v1.00 (18/11/2026) -- SOLA LETTURA, NESSUNA funzione di trading. |
//|  Per i 22 cross del paniere Bulge e gli anni 2022-2025 misura,    |
//|  dalle barre H1 della cronologia del broker:                      |
//|   - range vero medio (TR medio = proxy dell'ATR medio), in pip    |
//|   - spread medio e mediano delle barre (campo spread, in punti)   |
//|   - costo dello spread in multipli del rischio R, con SL = 3 ATR  |
//|  Scrive ABTG_VOLSPREAD.csv (cartella Files locale e Common) e     |
//|  ABTG_VOLSPREAD_FINE.txt, poi chiude il terminale.                |
//|  LIMITE: lo spread di cronologia NON include le commissioni.      |
//+------------------------------------------------------------------+
#property version "1.00"
#property strict

void Scrivi(const string nome, const string testo)
  {
   int h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(h!=INVALID_HANDLE){ FileWriteString(h,testo); FileClose(h); }
   h=FileOpen(nome,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(h!=INVALID_HANDLE){ FileWriteString(h,testo); FileClose(h); }
  }

void OnStart()
  {
   string simboli[22]={"EURUSD","GBPUSD","AUDUSD","NZDUSD","USDCAD","USDCHF","USDJPY","EURGBP","EURNZD","GBPJPY","GBPAUD",
                       "GBPCAD","GBPNZD","AUDJPY","AUDCAD","AUDNZD","NZDJPY","NZDCAD","NZDCHF","CADJPY","CADCHF","CHFJPY"};
   int anni[4]={2022,2023,2024,2025};
   string out="simbolo;anno;barre_H1;digits;pip;ATR_medio_pip;spread_medio_pip;spread_mediano_pip;barre_spread_zero_pct;costo_spread_R_con_SL3ATR\r\n";
   for(int s=0;s<22;s++)
     {
      string sym=simboli[s];
      SymbolSelect(sym,true);
      double point=SymbolInfoDouble(sym,SYMBOL_POINT);
      int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
      double pip=(dg==3 || dg==5) ? point*10.0 : point;
      for(int a=0;a<4;a++)
        {
         datetime t0=StringToTime(IntegerToString(anni[a])+".01.01");
         datetime t1=StringToTime(IntegerToString(anni[a]+1)+".01.01")-1;
         MqlRates r[];
         int n=-1;
         for(int tentativo=0;tentativo<15;tentativo++)
           {
            n=CopyRates(sym,PERIOD_H1,t0,t1,r);
            if(n>200) break;
            Sleep(2000);
           }
         if(n<=200 || pip<=0.0 || point<=0.0)
           {
            out+=sym+";"+IntegerToString(anni[a])+";"+IntegerToString(n)+";"+IntegerToString(dg)+";;;;;;\r\n";
            continue;
           }
         double trSomma=0.0; int cnt=0; int zeri=0;
         double sp[]; ArrayResize(sp,n);
         double spSomma=0.0;
         for(int i=1;i<n;i++)
           {
            double tr=MathMax(r[i].high-r[i].low,MathMax(MathAbs(r[i].high-r[i-1].close),MathAbs(r[i].low-r[i-1].close)));
            trSomma+=tr;
            sp[cnt]=(double)r[i].spread;
            spSomma+=sp[cnt];
            if(r[i].spread==0) zeri++;
            cnt++;
           }
         if(cnt<=0) continue;
         ArrayResize(sp,cnt);
         ArraySort(sp);
         double atr=trSomma/cnt;
         double spMedio=spSomma/cnt;
         double spMediano=sp[cnt/2];
         double costoR=(atr>0.0) ? (spMedio*point)/(3.0*atr) : 0.0;
         out+=sym+";"+IntegerToString(anni[a])+";"+IntegerToString(n)+";"+IntegerToString(dg)+";"+DoubleToString(pip,5)+";"
              +DoubleToString(atr/pip,2)+";"+DoubleToString(spMedio*point/pip,2)+";"+DoubleToString(spMediano*point/pip,2)+";"
              +DoubleToString(100.0*zeri/cnt,1)+";"+DoubleToString(costoR,4)+"\r\n";
        }
      Scrivi("ABTG_VOLSPREAD.csv",out);   // salvataggio progressivo
     }
   Scrivi("ABTG_VOLSPREAD.csv",out);
   Scrivi("ABTG_VOLSPREAD_FINE.txt","fine "+TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS)+"\r\n");
   TerminalClose(0);
  }
