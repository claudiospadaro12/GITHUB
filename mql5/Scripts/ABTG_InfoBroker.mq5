//+------------------------------------------------------------------+
//|                                            ABTG_InfoBroker.mq5    |
//|                                                                  |
//|  IL RICOGNITORE DI UN BROKER (va lanciato su TUTTI E DUE i        |
//|  terminali: BCM e quello esterno).                                |
//|                                                                  |
//|  PERCHE' ESISTE (14/08/2026):                                    |
//|  lo storico BCM sugli INDICI parte dal 26/09/2024. Per la prova   |
//|  di regime (prove\PROVA_REGIME_CRITERI.md) servono il 2022 e il   |
//|  2020, quindi un SECONDO terminale (demo Pepperstone) che quegli  |
//|  anni ce li ha. Prima di scaricare gigabyte e di lanciare test    |
//|  bisogna sapere TRE cose, e nessuna delle tre si puo' indovinare: |
//|                                                                  |
//|   1. I NOMI DEI SIMBOLI. Su BCM il DAX e' D30EUR, altrove e'      |
//|      GER40 / DE40 / GER30... Qui NON si inventa nessuna mappa:    |
//|      si ELENCA quello che il broker ha davvero, con descrizione,  |
//|      digits, point, contract size, tick value e la PRIMA DATA     |
//|      disponibile. La mappa la compila un umano guardando questo   |
//|      elenco (docs\BROKER_ESTERNO_MAPPA.md).                       |
//|                                                                  |
//|   2. IL FUSO DEL SERVER, ADESSO. Tutti i nostri EA hanno gli      |
//|      orari in ORA SERVER (DAX InpSessionHour=8, apertura USA      |
//|      14:30, box notturno 23:00-04:59...). Se il broker nuovo ha   |
//|      un offset diverso e non si rimappa, l'EA opera a un'ora che  |
//|      non c'entra niente con l'apertura di borsa: OGNI VERDETTO    |
//|      E' SPAZZATURA. Qui l'offset si MISURA (TimeTradeServer -     |
//|      TimeGMT), non si stima.                                      |
//|                                                                  |
//|   3. IL FUSO NEL PASSATO, che e' un'ALTRA cosa. TimeGMT dice solo |
//|      com'e' oggi. Pepperstone segue il DST AMERICANO (GMT+3 da    |
//|      marzo a novembre, GMT+2 il resto), l'Europa cambia in DATE   |
//|      DIVERSE: per 2-3 settimane l'anno la differenza fra i due    |
//|      server vale 1 ora invece di 2, e succede OGNI ANNO del       |
//|      backtest. Quindi qui si misura il fuso ANCHE SUI DATI:       |
//|       a) si esportano le chiusure H1 di due finestre (una in ora  |
//|          solare, una in ora legale) -> ABTG_InfoBroker_H1.csv.    |
//|          Lanciato sui due terminali, il driver PowerShell prova   |
//|          gli shift da -6 a +6 e trova quello che minimizza la     |
//|          differenza: SHIFT MISURATO SU DATI, non dedotto.         |
//|       b) si misura l'ORA SERVER DELLA PRIMA BARRA della giornata  |
//|          in date campione sparse su tutto l'anno (sezione         |
//|          [SESSIONI]). Se l'apertura cade a ore server diverse fra |
//|          gennaio e luglio, quel server NON segue il DST del       |
//|          mercato -> gli EA a orario fisso sono sbagliati per      |
//|          meta' anno. Vale anche per BCM, sui SOLDI VERI: la       |
//|          nostra regola "server BCM = ora italiana -1" non e' mai  |
//|          stata verificata d'inverno.                              |
//|                                                                  |
//|  USO: trascina lo script su un grafico qualsiasi e premi OK.      |
//|       Con InpFiltro restringi (es. "GER", "US", "XAU").           |
//|       Per i punti 3a/3b metti in InpSimboloFuso un INDICE (il     |
//|       DAX): sui cambi, che girano 24h, la "prima barra del        |
//|       giorno" e' sempre 00:00 e non dice niente.                  |
//|                                                                  |
//|  PRODUCE: log nella scheda ESPERTI +                               |
//|    MQL5\Files\ABTG_InfoBroker.csv     ([SERVER],[SIMBOLI],[SESSIONI])
//|    MQL5\Files\ABTG_InfoBroker_H1.csv  (chiusure H1 delle 2 finestre)
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
input string          InpSimboloFuso     = "";        // simbolo per fuso/sessioni: METTI UN INDICE (vuoto = il primo esaminato)
input ENUM_TIMEFRAMES InpTFSessione      = PERIOD_M5; // TF con cui si cerca la prima barra della giornata
input int             InpAnniSessione    = 3;         // quanti anni indietro nella tabella per stagione
input string          InpDateCampione    = "01.15,03.20,04.15,07.15,10.15,10.28,11.20"; // mese.giorno: 03.20 e 10.28 sono le settimane di DISALLINEAMENTO USA/EU
input bool            InpNonBloccare     = true;      // true = NON chiamare CopyRates nella scansione (vedi nota sotto)
input int             InpMaxSecScansione = 600;       // tetto di tempo per la scansione dei simboli (0 = nessuno)
input bool            InpEsportaH1       = true;      // esporta le chiusure H1 per il confronto fra broker
input string          InpFinestraSolare  = "2025.01.06-2025.01.31"; // finestra in ORA SOLARE (dentro lo storico BCM: dal 26/09/2024)
input string          InpFinestraLegale  = "2025.07.01-2025.07.31"; // finestra in ORA LEGALE

#define ABTG_INFO_FILE "ABTG_InfoBroker.csv"
#define ABTG_H1_FILE   "ABTG_InfoBroker_H1.csv"
#define ABTG_TOLL_DST_MIN 30  // minuti di scarto sotto i quali NON si grida al DST
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
//| L'OFFSET DEL SERVER, MISURATO (ma valido SOLO OGGI).             |
//|  TimeTradeServer() = ora corrente del server CALCOLATA dal        |
//|  terminale: vale anche a mercato chiuso, mentre TimeCurrent()     |
//|  resta ferma all'ultimo tick (venerdi' sera). Usare TimeCurrent() |
//|  per l'offset di sabato darebbe un valore sballato di due giorni. |
//|  Arrotondo a passi di 15 minuti per togliere il jitter fra i due  |
//|  orologi.                                                         |
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

string OraDiBarra(datetime t)
  {
   MqlDateTime d; TimeToStruct(t, d);
   return StringFormat("%02d:%02d", d.hour, d.min);
  }

int MinutiDiBarra(datetime t)
  {
   MqlDateTime d; TimeToStruct(t, d);
   return d.hour*60 + d.min;
  }

//+------------------------------------------------------------------+
//| Misura una serie: barre locali, prima data locale, prima data    |
//| che il SERVER dichiara di avere. Funziona anche se lo storico    |
//| non e' mai stato scaricato: la CopyRates sveglia il download e   |
//| SERIES_SERVER_FIRSTDATE risponde comunque.                       |
//+------------------------------------------------------------------+
void MisuraSerie(string sym, ENUM_TIMEFRAMES tf, long &barre, datetime &primaLoc, datetime &primaSrv)
  {
   // ATTENZIONE (15/08/2026) - PERCHE' QUI NON SI CHIAMA CopyRates.
   //  Dentro uno SCRIPT, CopyRates su una serie non sincronizzata NON
   //  torna subito: ASPETTA. Il 15/08, a mercato chiuso, e' costata
   //   - 69,5 secondi su AUDCHF  (1a ricognizione, tagliata a 9/1722)
   //   - 312,9 secondi su US30   (2a ricognizione, tagliata a 7/120)
   //  cioe' oltre 5 minuti per UN simbolo. Con 120 simboli sarebbero
   //  dieci ore, e non e' un problema di pazienza del driver: e' che
   //  la scansione bloccante non e' praticabile.
   //  SeriesInfoInteger invece NON blocca: torna 0 se il dato non c'e'
   //  ancora, e la richiesta al server parte lo stesso. Le date che
   //  mancano si rileggono nel secondo giro, alla fine della scansione.
   //  Con InpNonBloccare=false si torna al vecchio comportamento (utile
   //  solo su pochi simboli, con -Filtro stretto e mercato aperto).
   primaSrv = (datetime)SeriesInfoInteger(sym, tf, SERIES_SERVER_FIRSTDATE);
   if(primaSrv <= 0)
     {
      if(InpNonBloccare)
        {
         // una sveglia sola, senza bloccare: se il server risponde in
         // fretta bene, altrimenti si riprova nel secondo giro
         Sleep(50);
         primaSrv = (datetime)SeriesInfoInteger(sym, tf, SERIES_SERVER_FIRSTDATE);
        }
      else
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
        }
     }
   primaLoc = (datetime)SeriesInfoInteger(sym, tf, SERIES_FIRSTDATE);
   barre    = SeriesInfoInteger(sym, tf, SERIES_BARS_COUNT);
  }

string DataOTrattino(datetime t){ return (t>0 ? TimeToString(t, TIME_DATE) : "-"); }

//+------------------------------------------------------------------+
//| Il verdetto per un simbolo, sul TF richiesto.                     |
//|  "da scaricare" NON e' un errore: e' lo stato normale su un       |
//|  terminale appena installato. Serve a distinguerlo da "il broker  |
//|  questo simbolo non ce l'ha proprio".                             |
//+------------------------------------------------------------------+
string Verdetto(long barre, datetime primaLoc, datetime primaSrv)
  {
   // con InpNonBloccare non si puo' dire "NESSUN DATO": si puo' solo
   // dire che il server non ha ancora risposto. Confondere le due cose
   // vorrebbe dire cancellare dal catalogo simboli che esistono.
   if(primaSrv <= 0 && barre <= 0) return (InpNonBloccare ? "da svegliare (server non ha ancora risposto)" : "NESSUN DATO");
   if(barre <= 0)                  return "da scaricare";
   if(primaSrv <= 0)               return "server non risponde";
   if(primaLoc <= 0)               return "da scaricare";
   if(primaLoc > primaSrv + 2*86400) return "da scaricare (parziale)";
   return "COMPLETO";
  }

//+------------------------------------------------------------------+
//| "2025.01.06-2025.01.31" -> due datetime. Torna false se non si   |
//| capisce: meglio saltare l'export che esportare una finestra a    |
//| caso.                                                            |
//+------------------------------------------------------------------+
bool LeggiFinestra(string s, datetime &da, datetime &a)
  {
   string p[];
   if(StringSplit(s, '-', p) != 2) return false;
   StringTrimLeft(p[0]); StringTrimRight(p[0]);
   StringTrimLeft(p[1]); StringTrimRight(p[1]);
   da = StringToTime(p[0] + " 00:00");
   a  = StringToTime(p[1] + " 23:59");
   return (da > 0 && a > da);
  }

//+------------------------------------------------------------------+
//| ESPORTA LE CHIUSURE H1 DI UNA FINESTRA.                          |
//|  Il confronto fra i due broker NON si puo' fare qui: un          |
//|  terminale vede un solo server. Quindi ognuno dei due esporta le |
//|  sue chiusure e il driver PowerShell prova gli shift -6..+6 e    |
//|  stampa la tabella. E' la stessa logica di ABTG_ImportaStorico-  |
//|  Esterno.mq5 (CalibraShift), spostata di la' dove i due feed     |
//|  possono stare nella stessa stanza.                              |
//+------------------------------------------------------------------+
int EsportaH1(int fh2, string sym, string nomeFinestra, string finestra)
  {
   datetime da=0, a=0;
   if(!LeggiFinestra(finestra, da, a))
     {
      PrintFormat("  finestra '%s' non interpretabile (formato: 2025.01.06-2025.01.31): salto.", finestra);
      return 0;
     }
   MqlRates r[];
   int got = -1;
   // ALMENO UN TENTATIVO, SEMPRE (15/08/2026). Prima la condizione
   // !IsStopped() stava nell'intestazione del ciclo: se il terminale era
   // gia' in chiusura, il corpo non veniva eseguito NEMMENO UNA VOLTA e
   // usciva "NESSUNA BARRA H1" anche quando le barre c'erano tutte in
   // cache. E' successo in entrambe le ricognizioni Pepperstone del
   // 15/08: EURUSD aveva 22.524 barre H1 dal 2023.01.02, e il file e'
   // uscito con la sola intestazione.
   for(int tent=0; tent<60; tent++)
     {
      got = CopyRates(sym, PERIOD_H1, da, a, r);
      if(got > 0) break;
      if(IsStopped()) break;
      Sleep(250);
     }
   if(got <= 0)
     {
      PrintFormat("  %-8s %s -> NESSUNA BARRA H1 (storico da scaricare, o il broker non arriva li').",
                  nomeFinestra, finestra);
      return 0;
     }
   int digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   for(int i=0; i<got; i++)
      FileWrite(fh2, nomeFinestra, sym,
                TimeToString(r[i].time, TIME_DATE|TIME_MINUTES),
                DoubleToString(r[i].close, digits));
   PrintFormat("  %-8s %s -> %d barre H1 esportate (dal %s al %s, ORA SERVER)",
               nomeFinestra, finestra, got,
               TimeToString(r[0].time, TIME_DATE|TIME_MINUTES),
               TimeToString(r[got-1].time, TIME_DATE|TIME_MINUTES));
   return got;
  }

//+------------------------------------------------------------------+
//| APERTURA DI SESSIONE PER STAGIONE.                                |
//|                                                                  |
//| La domanda: "a che ora, SULL'OROLOGIO DEL SERVER, apre il mercato |
//| a gennaio? e a luglio?".                                          |
//|  - se e' la STESSA ora -> il server segue il DST del mercato, e   |
//|    un InpSessionHour fisso va bene tutto l'anno;                  |
//|  - se CAMBIA -> quel server ha offset fisso (o un calendario DST  |
//|    diverso) e per meta' anno i nostri EA a orario fisso operano   |
//|    all'ora sbagliata. Sui soldi veri, non solo nel backtest.      |
//|                                                                  |
//| Le date 03.20 e 10.28 sono li' apposta: cadono nelle settimane in |
//| cui USA ed Europa NON sono d'accordo (USA cambia 2a dom. di marzo |
//| e 1a dom. di novembre, Europa ultima dom. di marzo e ultima dom.  |
//| di ottobre).                                                      |
//+------------------------------------------------------------------+
void TabellaSessioni(int fh, string sym, int &minSolare, int &minLegale, int &minDisall)
  {
   minSolare = -1; minLegale = -1; minDisall = -1;

   string campioni[];
   int nd = StringSplit(InpDateCampione, ',', campioni);
   if(nd <= 0) return;

   MqlDateTime oggiSt; TimeToStruct(TimeTradeServer(), oggiSt);
   int annoFine = oggiSt.year;
   int annoDa   = annoFine - InpAnniSessione + 1;

   // non si va piu' indietro di quello che il broker ha davvero
   datetime srvD1 = (datetime)SeriesInfoInteger(sym, PERIOD_D1, SERIES_SERVER_FIRSTDATE);
   if(srvD1 > 0)
     {
      MqlDateTime st; TimeToStruct(srvD1, st);
      if(st.year > annoDa) annoDa = st.year;
     }

   string tfn = StringSubstr(EnumToString(InpTFSessione), 7);
   Print("--- APERTURA DI SESSIONE PER STAGIONE (", sym, ", TF ", tfn, ") ---");
   Print("    data        prima barra   ultima barra   barre   nota");

   // somme per gruppo: il valore rappresentativo e' la MODA grezza, cioe'
   // il primo valore visto che si ripete; con poche date basta la media
   // arrotondata dei valori uguali, quindi tengo semplicemente il piu'
   // frequente con due array paralleli.
   int valori[64]; int quante[64]; int gruppi[64]; int nv = 0;

   for(int anno = annoDa; anno <= annoFine; anno++)
     {
      for(int i=0; i<nd; i++)
        {
         string g = campioni[i];
         StringTrimLeft(g); StringTrimRight(g);
         string md[];
         if(StringSplit(g, '.', md) != 2) continue;
         int mese = (int)StringToInteger(md[0]);
         int gior = (int)StringToInteger(md[1]);
         if(mese < 1 || mese > 12 || gior < 1 || gior > 31) continue;

         datetime giorno = StringToTime(StringFormat("%04d.%02d.%02d 00:00", anno, mese, gior));
         if(giorno <= 0) continue;
         if(giorno > TimeTradeServer()) continue;      // date future: non esistono ancora

         // se e' festivo/weekend si scivola in avanti, fino a 4 giorni
         MqlRates r[];
         int got = 0, spost = 0;
         datetime usato = giorno;
         for(spost = 0; spost <= 4; spost++)
           {
            usato = giorno + spost*86400;
            got = CopyRates(sym, InpTFSessione, usato, usato + 86399, r);
            if(got > 0) break;
            Sleep(150);
            got = CopyRates(sym, InpTFSessione, usato, usato + 86399, r);
            if(got > 0) break;
           }

         string nota = "";
         if(got <= 0)
           {
            PrintFormat("    %04d.%02d.%02d   %-13s %-14s %5s   %s",
                        anno, mese, gior, "-", "-", "-", "da scaricare / nessun dato");
            if(fh != INVALID_HANDLE)
               FileWrite(fh, sym, StringFormat("%04d.%02d.%02d", anno, mese, gior),
                         "-", "-", "0", tfn, "da scaricare / nessun dato");
            continue;
           }
         if(spost > 0) nota = StringFormat("giorno spostato di +%d (festivo/weekend)", spost);

         int mPrima = MinutiDiBarra(r[0].time);
         PrintFormat("    %04d.%02d.%02d   %-13s %-14s %5d   %s",
                     anno, mese, gior, OraDiBarra(r[0].time), OraDiBarra(r[got-1].time), got, nota);
         if(fh != INVALID_HANDLE)
            FileWrite(fh, sym, StringFormat("%04d.%02d.%02d", anno, mese, gior),
                      OraDiBarra(r[0].time), OraDiBarra(r[got-1].time), (string)got, tfn,
                      (nota=="" ? "ok" : nota));

         // gruppo: 0 = ora solare (gen, nov), 1 = ora legale (apr, lug, ott15),
         //         2 = settimane di disallineamento USA/EU (20 marzo, 28 ottobre)
         int gruppo = 1;
         if(mese == 1 || mese == 11) gruppo = 0;
         if((mese == 3) || (mese == 10 && gior >= 25)) gruppo = 2;
         if(spost > 0 && gruppo == 2) continue;   // se e' scivolata, non e' piu' la settimana giusta

         bool trovato = false;
         for(int k=0; k<nv; k++)
            if(valori[k] == mPrima && gruppi[k] == gruppo){ quante[k]++; trovato = true; break; }
         if(!trovato && nv < 64){ valori[nv]=mPrima; quante[nv]=1; gruppi[nv]=gruppo; nv++; }
        }
     }

   // il valore piu' frequente per gruppo
   for(int gr=0; gr<3; gr++)
     {
      int best = -1, bestN = 0;
      for(int k=0; k<nv; k++)
         if(gruppi[k]==gr && quante[k] > bestN){ bestN = quante[k]; best = valori[k]; }
      if(gr==0) minSolare = best;
      if(gr==1) minLegale = best;
      if(gr==2) minDisall = best;
     }
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
   // SEZIONE 1: IL SERVER (il fuso di OGGI)
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
   Print("  OFFSET SERVER-GMT: ", OreMinuti(offMin), "   (", DoubleToString(offMin/60.0, 2), " ore)  <== IL NUMERO DI OGGI");
   Print("  Ora legale sul PC: ", (dstPC != 0 ? "SI" : "NO"),
         "   (TimeDaylightSavings e' del PC, NON del server: sul server si deduce dalle sezioni sotto)");
   Print("  Simboli broker   : ", (string)totB, "   in Market Watch: ", (string)totM);
   Print("---------------------------------------------------------------------");
   Print("  ATTENZIONE: l'offset qui sopra vale OGGI. Non e' l'offset storico.");
   Print("  Pepperstone segue il DST AMERICANO, l'Europa cambia in date diverse:");
   Print("  per 2-3 settimane l'anno la differenza fra i due server e' di 1 ora");
   Print("  invece di 2, e succede ogni anno del backtest. Il numero che vale");
   Print("  per il PASSATO e' quello misurato sui dati (ABTG_InfoBroker_H1.csv +");
   Print("  sezione [SESSIONI]). Vedi docs\\BROKER_ESTERNO_MAPPA.md.");
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
   PrintFormat("%-16s %-6s %-10s %-10s %-12s %-12s %s",
               "SIMBOLO","DIGITS","POINT","CONTRACT","PRIMA "+tfn,"PRIMA D1","STATO | DESCRIZIONE");

   int    esaminati = 0;
   string primoSym  = "";
   //  Il CSV NON si scrive dentro il ciclo: le righe si mettono da parte e
   //  si scrivono DOPO il secondo giro, con le date aggiornate. Scriverle
   //  subito vorrebbe dire congelare nel referto dei "non ha risposto" che
   //  tre secondi dopo sono diventati date vere.
   int     cap = (tot > 0 ? tot : 1);
   string  bSym[],  bDesc[], bStato[];
   int     bDig[],  bSpread[];
   double  bPoint[], bCsize[], bTval[], bTsize[];
   long    bBarTF[], bBarD1[];
   datetime bSrvTF[], bLocTF[], bSrvD1[];
   ArrayResize(bSym,cap);   ArrayResize(bDesc,cap);  ArrayResize(bStato,cap);
   ArrayResize(bDig,cap);   ArrayResize(bSpread,cap);
   ArrayResize(bPoint,cap); ArrayResize(bCsize,cap); ArrayResize(bTval,cap); ArrayResize(bTsize,cap);
   ArrayResize(bBarTF,cap); ArrayResize(bBarD1,cap);
   ArrayResize(bSrvTF,cap); ArrayResize(bLocTF,cap); ArrayResize(bSrvD1,cap);
   int     nBuf = 0;
   uint    tScan0   = GetTickCount();
   bool    tagliato = false;
   for(int i=0; i<tot && !IsStopped(); i++)
     {
      // TETTO DI TEMPO: meglio un elenco dichiaratamente parziale che una
      // corsa infinita che poi qualcuno spegne credendo sia finita.
      if(InpMaxSecScansione > 0 &&
         (int)((GetTickCount() - tScan0) / 1000) >= InpMaxSecScansione)
        {
         tagliato = true;
         PrintFormat("!!! SCANSIONE FERMATA DAL TETTO DI TEMPO (%d s) a %d simboli su %d.",
                     InpMaxSecScansione, esaminati, tot);
         Print("    L'elenco qui sotto e' PARZIALE e va dichiarato tale.");
         break;
        }
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
      if(primoSym == "") primoSym = sym;

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
      PrintFormat("%-16s %-6d %-10s %-10s %-12s %-12s %s | %s",
                  sym, digits, DoubleToString(point, 8), DoubleToString(csize, 2),
                  DataOTrattino(srvTF), DataOTrattino(srvD1), stato, desc);

      if(nBuf < cap)
        {
         bSym[nBuf]=sym;      bDesc[nBuf]=desc;    bStato[nBuf]=stato;
         bDig[nBuf]=digits;   bSpread[nBuf]=(int)spread;
         bPoint[nBuf]=point;  bCsize[nBuf]=csize;  bTval[nBuf]=tval;  bTsize[nBuf]=tsize;
         bBarTF[nBuf]=barTF;  bBarD1[nBuf]=barD1;
         bSrvTF[nBuf]=srvTF;  bLocTF[nBuf]=locTF;  bSrvD1[nBuf]=srvD1;
         nBuf++;
        }
     }

   //================================================================
   // SECONDO GIRO: le date che al primo passaggio non erano ancora
   // arrivate. La richiesta al server e' partita durante la scansione;
   // qui le si rilegge, sempre senza bloccare.
   //================================================================
   int corrette = 0, restano = 0;
   if(InpNonBloccare && nBuf > 0 && !IsStopped())
     {
      Print("--- SECONDO GIRO: rileggo le date che non erano ancora arrivate ---");
      Sleep(3000);
      for(int j=0; j<nBuf && !IsStopped(); j++)
        {
         if(bSrvTF[j] > 0) continue;
         datetime s2 = (datetime)SeriesInfoInteger(bSym[j], InpTF,     SERIES_SERVER_FIRSTDATE);
         datetime d2 = (datetime)SeriesInfoInteger(bSym[j], PERIOD_D1, SERIES_SERVER_FIRSTDATE);
         if(s2 > 0)
           {
            bSrvTF[j]  = s2;
            if(d2 > 0) bSrvD1[j] = d2;
            bBarTF[j]  = SeriesInfoInteger(bSym[j], InpTF,     SERIES_BARS_COUNT);
            bBarD1[j]  = SeriesInfoInteger(bSym[j], PERIOD_D1, SERIES_BARS_COUNT);
            bLocTF[j]  = (datetime)SeriesInfoInteger(bSym[j], InpTF, SERIES_FIRSTDATE);
            bStato[j]  = Verdetto(bBarTF[j], bLocTF[j], bSrvTF[j]);
            corrette++;
            PrintFormat("    %-16s -> %s  (%s)", bSym[j], DataOTrattino(s2), bStato[j]);
           }
         else restano++;
        }
      PrintFormat("    date recuperate: %d   ancora senza risposta: %d", corrette, restano);
      if(restano > 0)
        {
         Print("    ATTENZIONE: 'da svegliare' NON vuol dire che il simbolo non esiste.");
         Print("    A mercato chiuso il server puo' non rispondere: la prima data si");
         Print("    rimisura a mercato aperto, o con -Filtro su pochi simboli.");
        }
     }

   // --- adesso, e solo adesso, il CSV ---
   if(fh != INVALID_HANDLE)
      for(int j=0; j<nBuf; j++)
         FileWrite(fh, bSym[j], bDesc[j], (string)bDig[j],
                   DoubleToString(bPoint[j], 8), DoubleToString(bCsize[j], 2),
                   DoubleToString(bTval[j], 5),  DoubleToString(bTsize[j], 8),
                   (string)bSpread[j], tfn, (string)bBarTF[j], DataOTrattino(bSrvTF[j]),
                   (string)bBarD1[j], DataOTrattino(bSrvD1[j]), bStato[j]);

   //================================================================
   // SEZIONE 3: LE SESSIONI PER STAGIONE (il DST del server, sui dati)
   //================================================================
   string symFuso = InpSimboloFuso;
   StringTrimLeft(symFuso); StringTrimRight(symFuso);
   if(symFuso == "") symFuso = primoSym;

   if(symFuso != "" && SymbolSelect(symFuso, true))
     {
      if(fh != INVALID_HANDLE)
        {
         FileWrite(fh, "[SESSIONI]");
         FileWrite(fh, "Simbolo","Data","PrimaBarra","UltimaBarra","NBarre","TF","Nota");
        }
      int mSol=-1, mLeg=-1, mDis=-1;
      TabellaSessioni(fh, symFuso, mSol, mLeg, mDis);

      Print("--- LETTURA DELLA TABELLA ---");
      if(mSol < 0 || mLeg < 0)
        {
         Print("    DATI INSUFFICIENTI: manca lo storico su una delle due stagioni.");
         Print("    Scarica lo storico e rilancia: senza questa misura il fuso");
         Print("    storico resta una supposizione.");
         if(fh != INVALID_HANDLE)
            FileWrite(fh, symFuso, "VERDETTO_DST", "-", "-", "0", "-", "DATI INSUFFICIENTI");
        }
      else
        {
         string oraSol = StringFormat("%02d:%02d", mSol/60, mSol%60);
         string oraLeg = StringFormat("%02d:%02d", mLeg/60, mLeg%60);
         PrintFormat("    apertura tipica in ORA SOLARE (gen/nov) : %s", oraSol);
         PrintFormat("    apertura tipica in ORA LEGALE (apr/lug) : %s", oraLeg);
         if(mDis >= 0)
            PrintFormat("    settimane di disallineamento USA/EU     : %02d:%02d (20 marzo / 28 ottobre)", mDis/60, mDis%60);
         // TOLLERANZA (15/08/2026): il 15/08 questo blocco ha gridato
         // "ATTENZIONE: CAMBIA DI +0 ORE" su AUDUSD perche' l'apertura
         // risultava 00:00 in alcuni giorni e 00:05 in altri. Cinque
         // minuti non sono un cambio di fuso: e' la prima barra M5 che
         // manca. Con la divisione intera quei 5 minuti diventavano
         // "+0 ORE", cioe' un allarme che diceva "non cambia niente".
         // Sotto la mezz'ora si considera la stessa ora; sopra, il
         // numero si stampa in ore E minuti, mai troncato.
         string verdetto;
         int scarto = mLeg - mSol;
         if(MathAbs(scarto) <= ABTG_TOLL_DST_MIN)
           {
            verdetto = "SERVER ALLINEATO AL DST DEL MERCATO";
            Print("    -> ", verdetto, ": l'apertura cade alla STESSA ora server tutto");
            Print("       l'anno. Un InpSessionHour fisso e' corretto sempre.");
            if(scarto != 0)
               PrintFormat("       (scarto misurato: %+d minuti, sotto la tolleranza di %d: e'",
                           scarto, ABTG_TOLL_DST_MIN);
            if(scarto != 0)
               Print("       una barra mancante all'apertura, non un cambio di fuso.)");
           }
         else
           {
            int diffOre = scarto / 60;
            int diffMin = MathAbs(scarto) % 60;
            verdetto = StringFormat("ATTENZIONE: L'ORA DI APERTURA CAMBIA DI %+d ORE E %d MINUTI FRA LE STAGIONI",
                                    diffOre, diffMin);
            Print("    -> ", verdetto);
            Print("       QUESTO SERVER NON SEGUE IL DST DEL MERCATO (offset fisso, o");
            Print("       calendario diverso). Gli EA con orari fissi operano all'ora");
            Print("       SBAGLIATA per meta' anno: sul backtest e SUI SOLDI VERI.");
            Print("       Va deciso: due set di orari stagionali, oppure un input di");
            Print("       correzione DST nell'EA. Non e' un dettaglio.");
           }
         if(mDis >= 0 && mDis != mLeg && mDis != mSol)
           {
            Print("    -> Le settimane di disallineamento hanno un'ora ANCORA DIVERSA:");
            Print("       in quei giorni i risultati degli EA a fascia oraria non sono");
            Print("       validi e vanno esclusi o dichiarati.");
           }
         // riga di sintesi: nelle colonne PrimaBarra/UltimaBarra ci sono le
         // due ORE DI APERTURA (solare / legale), non le barre di un giorno.
         // E' il modo per farla leggere al driver PowerShell senza inventare
         // una terza sezione nel CSV.
         if(fh != INVALID_HANDLE)
            FileWrite(fh, symFuso, "VERDETTO_DST", oraSol, oraLeg, "0",
                      StringSubstr(EnumToString(InpTFSessione), 7), verdetto);
        }
     }
   else
     {
      Print("--- SESSIONI: nessun simbolo utilizzabile per la misura del DST. ---");
      Print("    Passa un indice in InpSimboloFuso (es. GER40 su Pepperstone,");
      Print("    D30EUR su BCM): sui cambi 24h la prima barra e' sempre 00:00.");
     }

   if(fh != INVALID_HANDLE) FileClose(fh);

   //================================================================
   // SEZIONE 4: LE CHIUSURE H1 PER IL CONFRONTO FRA BROKER
   //================================================================
   if(InpEsportaH1 && symFuso != "")
     {
      int fh2 = FileOpen(ABTG_H1_FILE, FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
      if(fh2 == INVALID_HANDLE)
         Print("ATTENZIONE: non riesco a scrivere ", ABTG_H1_FILE, " (errore ", GetLastError(), ").");
      else
        {
         FileWrite(fh2, "Finestra","Simbolo","DataOra","Close");
         Print("--- EXPORT CHIUSURE H1 (per misurare lo shift SUI DATI) ---");
         Print("  simbolo: ", symFuso, "   (le stesse due finestre vanno esportate anche sull'ALTRO terminale)");
         int n1 = EsportaH1(fh2, symFuso, "SOLARE", InpFinestraSolare);
         int n2 = EsportaH1(fh2, symFuso, "LEGALE", InpFinestraLegale);
         FileClose(fh2);
         PrintFormat("  totale esportato: %d barre H1 in MQL5\\Files\\%s", n1+n2, ABTG_H1_FILE);
         Print("  Il confronto lo fa prepara_broker_esterno.ps1: prova gli shift");
         Print("  da -6 a +6 ore e sceglie quello che minimizza la differenza media.");
         Print("  Se lo shift della finestra SOLARE e quello della LEGALE sono");
         Print("  DIVERSI, l'offset fra i due broker NON e' costante: e' la prova.");
        }
     }

   if(tagliato)
      PrintFormat("=== ELENCO PARZIALE: fermato dal tetto di %d s. NON usarlo per dire che un simbolo non esiste. ===",
                  InpMaxSecScansione);
   PrintFormat("=== FINITO: %d simboli esaminati su %d. Referto in MQL5\\Files\\%s ===",
               esaminati, tot, ABTG_INFO_FILE);
   Print("  Le colonne PrimaData sono quelle che il BROKER dichiara di avere:");
   Print("  se dicono 2018 lo storico e' raggiungibile, se dicono 2024 non lo e'.");
   Print("  Lo stato 'da scaricare' significa solo che sul disco non c'e' ancora.");
   Comment("ABTG_InfoBroker: fatto. Vedi la scheda ESPERTI e MQL5\\Files\\" + ABTG_INFO_FILE);
  }
//+------------------------------------------------------------------+
