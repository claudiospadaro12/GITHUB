//+------------------------------------------------------------------+
//|                                            ABTG_InfoBroker.mq5    |
//|                                                                  |
//|  IL RICOGNITORE DI UN BROKER NUOVO.                              |
//|                                                                  |
//|  PERCHE' ESISTE (14/08/2026):                                    |
//|  lo storico BCM sugli INDICI parte dal 26/09/2024. Per la prova   |
//|  di regime (prove\PROVA_REGIME_CRITERI.md) servono il 2022 e il   |
//|  2020, quindi un SECONDO terminale (demo Pepperstone) che quegli  |
//|  anni ce li ha. Prima di scaricare gigabyte e di lanciare test,   |
//|  bisogna sapere DUE cose, e nessuna delle due si puo' indovinare: |
//|                                                                  |
//|   1. IL FUSO DEL SERVER. Tutti i nostri EA hanno gli orari in ORA |
//|      SERVER (DAX InpSessionHour=8, Nasdaq 14:30, box notturno     |
//|      23:00-04:59...). Se il broker nuovo ha un offset diverso e   |
//|      non si rimappa, l'EA opera a un'ora che non c'entra niente   |
//|      con l'apertura di borsa: OGNI VERDETTO E' SPAZZATURA.        |
//|      Qui l'offset si MISURA (TimeTradeServer - TimeGMT), non si   |
//|      stima. Lo stesso script va lanciato anche su BCM: cosi' la   |
//|      DIFFERENZA fra i due server e' misurata, non supposta.       |
//|                                                                  |
//|   2. I NOMI DEI SIMBOLI. Su BCM il DAX e' D30EUR, altrove e'      |
//|      GER40 / DE40 / GER30... Qui NON si inventa nessuna mappa:    |
//|      si ELENCA quello che il broker ha davvero, con descrizione,  |
//|      digits, point, contract size, tick value e la PRIMA DATA     |
//|      disponibile. La mappa la compila un umano, guardando questo  |
//|      elenco (docs\BROKER_ESTERNO_MAPPA.md).                       |
//|                                                                  |
//|  USO: trascina lo script su un grafico qualsiasi e premi OK.      |
//|       Con InpFiltro restringi (es. "GER", "US", "XAU").           |
//|                                                                  |
//|  PRODUCE: log nella scheda ESPERTI + MQL5\Files\ABTG_InfoBroker.csv|
//|           in due sezioni: [SERVER] e [SIMBOLI].                   |
//|                                                                  |
//|  NOTA: i simboli esaminati vengono AGGIUNTI al Market Watch (per  |
//|  interrogarne le serie storiche serve che siano selezionati). Se  |
//|  non lo vuoi, usa InpSoloMarketWatch=true o un InpFiltro stretto. |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string          InpFiltro          = "";        // sottostringa nel nome o nella descrizione (vuoto = TUTTI)
input bool            InpSoloMarketWatch = false;     // true = solo i simboli gia' in Market Watch
input ENUM_TIMEFRAMES InpTF              = PERIOD_H1; // TF su cui misurare la prima data (D1 e' sempre misurato)

#define ABTG_INFO_FILE "ABTG_InfoBroker.csv"
#define ABTG_ATTESA_GIRI 8      // 8 x 250ms = 2 secondi per serie: bastano per la
                                // risposta del server, senza far durare ore un
                                // elenco di 1000 simboli

//+------------------------------------------------------------------+
//| Toglie i caratteri che romperebbero il CSV (virgole e apici):    |
//| le descrizioni dei broker ne sono piene ("Dax 40 Index, cash")   |
//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringReplace(s, ",", " ");
   StringReplace(s, ";", " ");
   StringReplace(s, "\"", " ");
   StringReplace(s, "\r", " ");
   StringReplace(s, "\n", " ");
   StringTrimLeft(s); StringTrimRight(s);
   return s;
  }

string Maiuscolo(string s){ StringToUpper(s); return s; }

//+------------------------------------------------------------------+
//| L'OFFSET DEL SERVER, MISURATO.                                   |
//|  TimeTradeServer() = ora corrente del server CALCOLATA dal        |
//|  terminale: vale anche a mercato chiuso, mentre TimeCurrent()     |
//|  resta ferma all'ultimo tick (venerdi' sera). Usare TimeCurrent() |
//|  per l'offset di sabato darebbe un valore sballato di due giorni. |
//|  Arrotondo a passi di 15 minuti per togliere il jitter di qualche |
//|  secondo fra i due orologi.                                       |
//+------------------------------------------------------------------+
int OffsetServerGMTMinuti()
  {
   datetime srv = TimeTradeServer();
   datetime gmt = TimeGMT();
   double   mm  = (double)((long)srv - (long)gmt) / 60.0;
   return (int)(MathRound(mm / 15.0) * 15);
  }

string OreMinuti(int minuti)
  {
   string segno = (minuti < 0 ? "-" : "+");
   int a = (int)MathAbs(minuti);
   return StringFormat("%s%02d:%02d", segno, a/60, a%60);
  }

//+------------------------------------------------------------------+
//| Misura una serie: barre locali, prima data locale, prima data    |
//| che il SERVER dichiara di avere. Funziona anche se lo storico    |
//| non e' mai stato scaricato: la CopyRates sveglia il download e   |
//| SERIES_SERVER_FIRSTDATE risponde comunque.                       |
//+------------------------------------------------------------------+
void MisuraSerie(string sym, ENUM_TIMEFRAMES tf, long &barre, datetime &primaLoc, datetime &primaSrv)
  {
   MqlRates r[];
   CopyRates(sym, tf, 0, 2, r);
   primaSrv = (datetime)SeriesInfoInteger(sym, tf, SERIES_SERVER_FIRSTDATE);
   for(int k=0; k<ABTG_ATTESA_GIRI && primaSrv<=0 && !IsStopped(); k++)
     {
      Sleep(250);
      CopyRates(sym, tf, 0, 2, r);
      primaSrv = (datetime)SeriesInfoInteger(sym, tf, SERIES_SERVER_FIRSTDATE);
     }
   primaLoc = (datetime)SeriesInfoInteger(sym, tf, SERIES_FIRSTDATE);
   barre    = SeriesInfoInteger(sym, tf, SERIES_BARS_COUNT);
  }

string DataOTrattino(datetime t){ return (t>0 ? TimeToString(t, TIME_DATE) : "-"); }

//+------------------------------------------------------------------+
//| Il verdetto per un simbolo, sul TF richiesto.                     |
//|  "DA SCARICARE" NON e' un errore: e' lo stato normale su un       |
//|  terminale appena installato. Serve a distinguerlo da "il broker  |
//|  questo simbolo non ce l'ha proprio".                             |
//+------------------------------------------------------------------+
string Verdetto(long barre, datetime primaLoc, datetime primaSrv)
  {
   if(primaSrv <= 0 && barre <= 0) return "NESSUN DATO";
   if(barre <= 0)                  return "da scaricare";
   if(primaSrv <= 0)               return "server non risponde";
   if(primaLoc <= 0)               return "da scaricare";
   if(primaLoc > primaSrv + 2*86400) return "da scaricare (parziale)";
   return "COMPLETO";
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   bool mw   = InpSoloMarketWatch;
   int  tot  = SymbolsTotal(mw);
   int  totB = SymbolsTotal(false);
   int  totM = SymbolsTotal(true);
   string filtro = Maiuscolo(InpFiltro);

   int fh = FileOpen(ABTG_INFO_FILE, FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh == INVALID_HANDLE)
      Print("ATTENZIONE: non riesco a scrivere ", ABTG_INFO_FILE, " (errore ", GetLastError(), "). Continuo solo a schermo.");

   //================================================================
   // SEZIONE 1: IL SERVER (il fuso, che e' meta' del lavoro)
   //================================================================
   datetime srv    = TimeTradeServer();
   datetime tick   = TimeCurrent();
   datetime gmt    = TimeGMT();
   datetime loc    = TimeLocal();
   int      offMin = OffsetServerGMTMinuti();
   long     dstPC  = (long)TimeDaylightSavings();   // ATTENZIONE: e' del PC, non del server
   long     gapTick= (long)srv - (long)tick;
   string   aperto = (MathAbs((double)gapTick) < 600 ? "SI" : "NO (ultimo tick vecchio: mercato chiuso o simbolo fermo)");

   Print("=====================================================================");
   Print("=== ABTG_InfoBroker - RICOGNIZIONE BROKER ===");
   Print("  Broker           : ", AccountInfoString(ACCOUNT_COMPANY));
   Print("  Server           : ", AccountInfoString(ACCOUNT_SERVER));
   Print("  Conto            : ", (string)AccountInfoInteger(ACCOUNT_LOGIN),
         "  (", (AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_DEMO ? "DEMO" : "REALE/CONTEST"), ")");
   Print("  Ora server       : ", TimeToString(srv, TIME_DATE|TIME_SECONDS));
   Print("  Ora ultimo tick  : ", TimeToString(tick, TIME_DATE|TIME_SECONDS), "   mercato aperto: ", aperto);
   Print("  Ora GMT          : ", TimeToString(gmt, TIME_DATE|TIME_SECONDS));
   Print("  Ora locale PC    : ", TimeToString(loc, TIME_DATE|TIME_SECONDS));
   Print("  OFFSET SERVER-GMT: ", OreMinuti(offMin), "   (", DoubleToString(offMin/60.0, 2), " ore)  <== IL NUMERO CHE CONTA");
   Print("  Ora legale sul PC: ", (dstPC != 0 ? "SI" : "NO"),
         "   (TimeDaylightSavings e' del PC, NON del server: sul server si deduce dall'offset)");
   Print("  Simboli broker   : ", (string)totB, "   in Market Watch: ", (string)totM);
   Print("---------------------------------------------------------------------");
   Print("  L'offset qui sopra e' quello di OGGI. Se il broker segue un");
   Print("  calendario di ora legale diverso da BCM, la differenza fra i due");
   Print("  server CAMBIA due volte l'anno: vedi docs\\BROKER_ESTERNO_MAPPA.md.");
   Print("=====================================================================");

   if(fh != INVALID_HANDLE)
     {
      FileWrite(fh, "[SERVER]");
      FileWrite(fh, "Campo", "Valore");
      FileWrite(fh, "Broker",               Pulisci(AccountInfoString(ACCOUNT_COMPANY)));
      FileWrite(fh, "Server",               Pulisci(AccountInfoString(ACCOUNT_SERVER)));
      FileWrite(fh, "Conto",                (string)AccountInfoInteger(ACCOUNT_LOGIN));
      FileWrite(fh, "TipoConto",            (AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_DEMO ? "DEMO" : "REALE/CONTEST"));
      FileWrite(fh, "Valuta",               Pulisci(AccountInfoString(ACCOUNT_CURRENCY)));
      FileWrite(fh, "OraServer",            TimeToString(srv,  TIME_DATE|TIME_SECONDS));
      FileWrite(fh, "OraUltimoTick",        TimeToString(tick, TIME_DATE|TIME_SECONDS));
      FileWrite(fh, "OraGMT",               TimeToString(gmt,  TIME_DATE|TIME_SECONDS));
      FileWrite(fh, "OraLocalePC",          TimeToString(loc,  TIME_DATE|TIME_SECONDS));
      FileWrite(fh, "OffsetServerGMT_min",  (string)offMin);
      FileWrite(fh, "OffsetServerGMT_ore",  DoubleToString(offMin/60.0, 2));
      FileWrite(fh, "OffsetServerGMT_hhmm", OreMinuti(offMin));
      FileWrite(fh, "OraLegalePC",          (dstPC != 0 ? "SI" : "NO"));
      FileWrite(fh, "MercatoAperto",        (MathAbs((double)gapTick) < 600 ? "SI" : "NO"));
      FileWrite(fh, "SimboliBroker",        (string)totB);
      FileWrite(fh, "SimboliMarketWatch",   (string)totM);
      FileWrite(fh, "TF_Misurato",          StringSubstr(EnumToString(InpTF), 7));
      FileWrite(fh, "Filtro",               Pulisci(InpFiltro));
      FileWrite(fh, "MisuratoIl",           TimeToString(loc, TIME_DATE));
     }

   //================================================================
   // SEZIONE 2: I SIMBOLI (i nomi veri, non quelli che immaginiamo)
   //================================================================
   if(fh != INVALID_HANDLE)
     {
      FileWrite(fh, "[SIMBOLI]");
      FileWrite(fh, "Simbolo","Descrizione","Digits","Point","ContractSize","TickValue","TickSize",
                    "SpreadPt","TF","BarreTF","PrimaDataTF","BarreD1","PrimaDataD1","Stato");
     }

   string tfn = StringSubstr(EnumToString(InpTF), 7);
   PrintFormat("=== SIMBOLI (%s) - TF misurato: %s - filtro: '%s' ===",
               (mw ? "solo Market Watch" : "TUTTO IL BROKER"), tfn, InpFiltro);
   PrintFormat("%-16s %-6s %-8s %-10s %-12s %-12s %s",
               "SIMBOLO","DIGITS","POINT","CONTRACT","PRIMA "+tfn,"PRIMA D1","STATO / DESCRIZIONE");

   int esaminati = 0;
   for(int i=0; i<tot && !IsStopped(); i++)
     {
      string sym = SymbolName(i, mw);
      if(StringLen(sym) == 0) continue;

      // il filtro guarda ANCHE la descrizione: su certi broker il DAX si
      // chiama "GER40" ma su altri "DE40.cash", e la parola "dax" sta solo
      // nella descrizione.
      string desc = Pulisci(SymbolInfoString(sym, SYMBOL_DESCRIPTION));
      if(StringLen(filtro) > 0)
        {
         if(StringFind(Maiuscolo(sym), filtro) < 0 && StringFind(Maiuscolo(desc), filtro) < 0)
            continue;
        }

      // per interrogare le serie il simbolo deve essere selezionato
      if(!SymbolSelect(sym, true))
        {
         PrintFormat("%-16s : impossibile selezionarlo (salto)", sym);
         continue;
        }
      esaminati++;

      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      double csize  = SymbolInfoDouble(sym, SYMBOL_TRADE_CONTRACT_SIZE);
      double tval   = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
      double tsize  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
      long   spread = SymbolInfoInteger(sym, SYMBOL_SPREAD);

      long     barTF=0, barD1=0;
      datetime locTF=0, srvTF=0, locD1=0, srvD1=0;
      MisuraSerie(sym, InpTF,      barTF, locTF, srvTF);
      MisuraSerie(sym, PERIOD_D1,  barD1, locD1, srvD1);

      string stato = Verdetto(barTF, locTF, srvTF);

      // PrimaData: si scrive quella del SERVER (quello che il broker POSSIEDE),
      // perche' e' l'unica che dice se il 2018 e' raggiungibile o no. Quella
      // locale conta solo per sapere se resta da scaricare.
      PrintFormat("%-16s %-6d %-8s %-10s %-12s %-12s %s | %s",
                  sym, digits, DoubleToString(point, 8), DoubleToString(csize, 2),
                  DataOTrattino(srvTF), DataOTrattino(srvD1), stato, desc);

      if(fh != INVALID_HANDLE)
         FileWrite(fh, sym, desc, (string)digits,
                   DoubleToString(point, 8), DoubleToString(csize, 2),
                   DoubleToString(tval, 5),  DoubleToString(tsize, 8),
                   (string)spread, tfn, (string)barTF, DataOTrattino(srvTF),
                   (string)barD1, DataOTrattino(srvD1), stato);
     }

   if(fh != INVALID_HANDLE) FileClose(fh);

   PrintFormat("=== FINITO: %d simboli esaminati su %d. Referto in MQL5\\Files\\%s ===",
               esaminati, tot, ABTG_INFO_FILE);
   Print("  Le colonne PrimaData sono quelle che il BROKER dichiara di avere:");
   Print("  se dicono 2018 lo storico e' raggiungibile, se dicono 2024 non lo e'.");
   Print("  Lo stato 'da scaricare' significa solo che sul disco non c'e' ancora.");
   Comment("ABTG_InfoBroker: fatto. Vedi la scheda ESPERTI e MQL5\\Files\\" + ABTG_INFO_FILE);
  }
//+------------------------------------------------------------------+
