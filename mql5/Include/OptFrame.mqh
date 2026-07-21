//+------------------------------------------------------------------+
//|                                                    OptFrame.mqh    |
//|                                                                  |
//|  Raccoglie i risultati dell'OTTIMIZZAZIONE MT5 e li scrive in un |
//|  CSV, in automatico, usando le "frame functions" native.        |
//|                                                                  |
//|  Il CSV ha le stesse colonne dell'export XML del Tester, quindi  |
//|  e' leggibile direttamente da:                                   |
//|      python optimizer/batch_analyze.py <cartella>               |
//|                                                                  |
//|  USO (una riga per ogni EA, in cima al file .mq5):              |
//|      #include <OptFrame.mqh>                                     |
//|                                                                  |
//|  ATTENZIONE:                                                     |
//|   - Se l'EA definisce GIA' OnTester/OnTesterInit/OnTesterPass/   |
//|     OnTesterDeinit, NON includere: si integra a mano (avresti   |
//|     "function already defined"). La maggior parte degli EA       |
//|     semplici non le definisce.                                   |
//|   - Compilare in MetaEditor e segnalare eventuali errori: alcune|
//|     firme API vanno confermate sulla tua build MT5.             |
//+------------------------------------------------------------------+
#property strict

// nome logico del frame (qualsiasi stringa)
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

// file CSV di output (nella cartella MQL5\Files del terminale principale)
string OptFrame_FileName()
  {
   // un file per simbolo/EA: es. OptResults_NasdaqMasterEA_NAS100.csv
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| Lato AGENTE: a fine di ogni passata impacchetta le statistiche   |
//| in un frame e lo invia al terminale principale.                 |
//+------------------------------------------------------------------+
double OnTester()
  {
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);                 // Profit
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);        // Expected Payoff
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);          // Profit Factor
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);        // Recovery Factor
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);           // Sharpe Ratio
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);   // Equity DD %
   stats[6] = TesterStatistics(STAT_TRADES);                 // Trades

   // criterio restituito all'ottimizzatore: recovery factor (robusto).
   // Cambialo se vuoi ordinare l'ottimizzazione per un'altra metrica.
   double criterion = stats[3];

   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

//+------------------------------------------------------------------+
//| Lato TERMINALE: inizio ottimizzazione                            |
//+------------------------------------------------------------------+
int OnTesterInit()
  {
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Lato TERMINALE: a fine ottimizzazione, scarica TUTTI i frame     |
//| e scrive il CSV (una riga per passata).                          |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     {
      PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError());
      return;
     }

   // riavvolge il flusso dei frame di questa ottimizzazione
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);

   ulong  pass;
   string name;
   long   id;
   double value;
   double data[];
   bool   header_scritto = false;
   int    righe = 0;

   while(FrameNext(pass, name, id, value, data))
     {
      // parametri di input di QUESTA passata: array di stringhe "nome=valore"
      string params[];
      uint   pcount = 0;
      FrameInputs(pass, params, pcount);

      // --- intestazione (scritta alla prima passata, quando conosco i nomi) ---
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           {
            string kv[];
            if(StringSplit(params[i], '=', kv) == 2)
               head += "," + kv[0];
           }
         FileWrite(h, head);
         header_scritto = true;
        }

      // --- riga dei valori ---
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2],
                                data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        {
         string kv[];
         if(StringSplit(params[i], '=', kv) == 2)
            row += "," + kv[1];
        }
      FileWrite(h, row);
      righe++;
     }

   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//+------------------------------------------------------------------+
