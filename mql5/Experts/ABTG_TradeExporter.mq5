//+------------------------------------------------------------------+
//|                                       ABTG_TradeExporter.mq5      |
//|                                                                  |
//|  Esporta AUTOMATICAMENTE lo storico dei trade CHIUSI in un CSV,   |
//|  cosi' il report settimanale non ha piu' bisogno dell'export      |
//|  manuale da MT5.                                                  |
//|                                                                  |
//|  - gira su un grafico qualsiasi del VPS (NON invia ordini: legge  |
//|    solo lo storico). Mettilo su un grafico di scorta.             |
//|  - riesporta ogni InpExportMinutes minuti (anche nel weekend,     |
//|    via timer, non dipende dai tick).                              |
//|  - scrive in Common\Files (FILE_COMMON) cosi' lo script PowerShell |
//|    lo trova sempre, da qualunque terminale.                       |
//|                                                                  |
//|  Formato CSV (;) — una riga per POSIZIONE chiusa:                 |
//|   pid;symbol;side;volume;open_time;open_price;close_time;         |
//|   close_price;commission;swap;profit;strategy                     |
//|                                                                  |
//|  Lo legge agent/statement.py (report settimanale del sabato).     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

input string InpFile          = "ABTG_Trades.csv"; // nome file (in Common\Files)
input int    InpFromYear      = 2024;              // esporta i trade da questo anno
input int    InpExportMinutes = 30;                // ogni quanti minuti riesportare
input bool   InpUseCommon     = true;              // scrivi in Common\Files (consigliato)

struct PRec
  {
   long     pid;
   string   sym;
   string   side;
   double   vol;
   datetime otime;
   datetime ctime;
   double   oprice;
   double   cprice;
   double   comm;
   double   swap;
   double   profit;
   string   strat;
   bool     hasIn;
   bool     hasOut;
  };

//+------------------------------------------------------------------+
int OnInit()
  {
   ExportAll();
   EventSetTimer(MathMax(60, InpExportMinutes*60));
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason){ EventKillTimer(); ExportAll(); }
void OnTimer(){ ExportAll(); }

//+------------------------------------------------------------------+
int FindRec(PRec &recs[], long pid)
  {
   for(int i=ArraySize(recs)-1; i>=0; i--)
      if(recs[i].pid==pid) return(i);
   return(-1);
  }

//+------------------------------------------------------------------+
void ExportAll()
  {
   MqlDateTime f; f.year=InpFromYear; f.mon=1; f.day=1; f.hour=0; f.min=0; f.sec=0;
   datetime from = StructToTime(f);
   if(!HistorySelect(from, TimeCurrent()))
     { Print("[TradeExporter] HistorySelect fallita"); return; }

   PRec recs[]; ArrayResize(recs,0);
   int total = HistoryDealsTotal();
   for(int i=0; i<total; i++)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk==0) continue;
      long pid = (long)HistoryDealGetInteger(tk, DEAL_POSITION_ID);
      if(pid==0) continue;   // deal di bilancio/deposito
      long dtype = (long)HistoryDealGetInteger(tk, DEAL_TYPE);
      if(dtype!=DEAL_TYPE_BUY && dtype!=DEAL_TYPE_SELL) continue; // salta balance/credit
      long entry = (long)HistoryDealGetInteger(tk, DEAL_ENTRY);

      int idx = FindRec(recs, pid);
      if(idx<0)
        {
         idx = ArraySize(recs); ArrayResize(recs, idx+1);
         recs[idx].pid=pid; recs[idx].sym=""; recs[idx].side=""; recs[idx].vol=0;
         recs[idx].otime=0; recs[idx].ctime=0; recs[idx].oprice=0; recs[idx].cprice=0;
         recs[idx].comm=0; recs[idx].swap=0; recs[idx].profit=0; recs[idx].strat="";
         recs[idx].hasIn=false; recs[idx].hasOut=false;
        }
      // accumulo sempre i costi/profitto del deal
      recs[idx].comm   += HistoryDealGetDouble(tk, DEAL_COMMISSION);
      recs[idx].swap   += HistoryDealGetDouble(tk, DEAL_SWAP);
      recs[idx].profit += HistoryDealGetDouble(tk, DEAL_PROFIT);

      if(entry==DEAL_ENTRY_IN)
        {
         recs[idx].sym   = HistoryDealGetString(tk, DEAL_SYMBOL);
         recs[idx].side  = (dtype==DEAL_TYPE_BUY) ? "buy" : "sell";
         recs[idx].vol   = HistoryDealGetDouble(tk, DEAL_VOLUME);
         recs[idx].otime = (datetime)HistoryDealGetInteger(tk, DEAL_TIME);
         recs[idx].oprice= HistoryDealGetDouble(tk, DEAL_PRICE);
         string cmt = HistoryDealGetString(tk, DEAL_COMMENT);
         if(cmt!="") recs[idx].strat = cmt;
         recs[idx].hasIn = true;
        }
      else // DEAL_ENTRY_OUT / OUT_BY / INOUT: chiusura (l'ultima vince)
        {
         recs[idx].ctime = (datetime)HistoryDealGetInteger(tk, DEAL_TIME);
         recs[idx].cprice= HistoryDealGetDouble(tk, DEAL_PRICE);
         if(recs[idx].sym=="") recs[idx].sym = HistoryDealGetString(tk, DEAL_SYMBOL);
         recs[idx].hasOut = true;
        }
     }

   int flags = FILE_WRITE|FILE_CSV|FILE_ANSI;
   if(InpUseCommon) flags |= FILE_COMMON;
   int fh = FileOpen(InpFile, flags, ';');
   if(fh==INVALID_HANDLE){ Print("[TradeExporter] impossibile aprire ",InpFile); return; }
   FileWrite(fh,"pid","symbol","side","volume","open_time","open_price",
             "close_time","close_price","commission","swap","profit","strategy");
   int written=0;
   for(int i=0; i<ArraySize(recs); i++)
     {
      if(!recs[i].hasIn || !recs[i].hasOut) continue; // solo posizioni CHIUSE
      int dg = 2;
      if(recs[i].sym!="") dg = (int)SymbolInfoInteger(recs[i].sym, SYMBOL_DIGITS);
      if(dg<=0) dg=2;
      FileWrite(fh,
                (string)recs[i].pid,
                recs[i].sym,
                recs[i].side,
                DoubleToString(recs[i].vol,2),
                TimeToString(recs[i].otime, TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                DoubleToString(recs[i].oprice,dg),
                TimeToString(recs[i].ctime, TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                DoubleToString(recs[i].cprice,dg),
                DoubleToString(recs[i].comm,2),
                DoubleToString(recs[i].swap,2),
                DoubleToString(recs[i].profit,2),
                recs[i].strat);
      written++;
     }
   FileClose(fh);
   Print("[TradeExporter] esportati ",written," trade chiusi in ",
         (InpUseCommon?"Common\\Files\\":""),InpFile);
  }
//+------------------------------------------------------------------+
