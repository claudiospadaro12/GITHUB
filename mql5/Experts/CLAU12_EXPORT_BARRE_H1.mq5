//+------------------------------------------------------------------+
//|                                       CLAU12_EXPORT_BARRE_H1.mq5 |
//|  Esporta le barre H1 CHIUSE del simbolo del tester in un CSV.     |
//|  NESSUN ORDINE, NESSUN MAGIC, NESSUNA LETTURA DEL CONTO.          |
//+------------------------------------------------------------------+
//==================================================================
// PERCHE' ESISTE (11/10/2026)
//   La scheda report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md (sez. 1.8)
//   dice che per l'IS della sedia 771531 (U30USD H1, 2024.09.26 ->
//   2025.06.09) "non c'e' nessuna serie di prezzi in repo": il regime
//   dell'IS e' [NON MISURATO]. La regola di etichettatura di
//   report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md (par. 1.3) vuole le
//   CHIUSURE H1 del feed. Questo EA le scrive, e basta.
//
// COME LAVORA (e perche' cosi')
//   - Gira SOLO nello Strategy Tester (conto virtuale): fuori dal tester,
//     in ottimizzazione o in modalita' visuale RIFIUTA l'avvio. Non puo'
//     quindi finire su un grafico di un terminale con conto vivo.
//   - A ogni barra H1 nuova scrive le barre CHIUSE non ancora scritte
//     (recupero per intervallo di tempo: se un passaggio salta, quello
//     dopo le riprende). La barra in formazione non si scrive mai.
//   - Scrive in avanti, a piccoli pezzi: non chiede mai tutto lo storico
//     in una volta, quindi il tetto "Max barre nel grafico" (100.000)
//     non lo tocca [INFERITO: il tetto limita la serie visibile, qui se
//     ne leggono poche barre alla volta].
//   - Il file ha nome con l'identificativo della corsa e NON si
//     sovrascrive: se esiste gia', l'EA si ferma.
//   - Ultima riga #FINE scritta in OnDeinit: un file senza #FINE e' un
//     file troncato (il collaudo lo boccia).
//
// OROLOGIO
//   La colonna time_server e' l'ora del SERVER del feed, come la registra
//   il terminale (apertura della barra). Nessuna conversione. Quale
//   orologio abbia il feed lo dice il referto (report/OROLOGIO_BCM_
//   2026-09-24.md par. 3.2: indici BCM UTC+1 fisso dal 2024.09.26) e lo
//   VERIFICA il collaudo backtest_pipeline/collaudo_export_barre_h1.py,
//   non questo file. Nel tester TimeGMT() e' simulato e non misura
//   niente: per questo l'EA non prova a dichiarare un offset.
//==================================================================
#property copyright "CLAU12"
#property version   "1.00"
#property description "Esporta le barre H1 chiuse del simbolo del tester (Common\\Files). Solo Strategy Tester, nessun ordine."

#define EXP_VER   "1.00"
#define EXP_MARCA "CLAU12_EXPORT_BARRE_H1"
#define EXP_TAG   "[CLAU12_EXPORT]"

//--- l'unico input: l'identificativo della corsa, lo passa il driver (12 caratteri esadecimali minuscoli)
input string InpRunId = "";

int      g_fh            = INVALID_HANDLE;
string   g_nome          = "";
int      g_digits        = 2;
datetime g_ultimaScritta = 0;   // apertura dell'ultima barra scritta
datetime g_ultimaVista   = 0;   // apertura dell'ultima barra in formazione vista
datetime g_prima         = 0;   // apertura della prima barra scritta
long     g_scritte       = 0;
long     g_errCopia      = 0;
long     g_scartate      = 0;

//+------------------------------------------------------------------+
//| identificativo: esattamente 12 caratteri 0-9 a-f                 |
//+------------------------------------------------------------------+
bool RunIdValido(const string s)
  {
   if(StringLen(s) != 12)
      return(false);
   for(int i = 0; i < 12; i++)
     {
      ushort c = StringGetCharacter(s, i);
      bool cifra = (c >= '0' && c <= '9');
      bool lett  = (c >= 'a' && c <= 'f');
      if(!cifra && !lett)
         return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
void Riga(const string s)
  {
   FileWriteString(g_fh, s + "\r\n");
  }

//+------------------------------------------------------------------+
//| scrive le barre CHIUSE con apertura in (g_ultimaScritta, tLimite) |
//| tLimite = apertura della barra in formazione (esclusa)            |
//+------------------------------------------------------------------+
void ScriviFinoA(const datetime tLimite)
  {
   MqlRates r[];
   ArraySetAsSeries(r, false);
   int n = 0;
   if(g_ultimaScritta == 0)
     {
      // primo giro: tutte le barre chiuse che il tester rende visibili (anche la pre-storia, se c'e')
      int nb = Bars(_Symbol, PERIOD_H1);
      if(nb < 2)
         return;                       // solo la barra in formazione: niente da scrivere ancora
      n = CopyRates(_Symbol, PERIOD_H1, 1, nb - 1, r);
     }
   else
     {
      if(tLimite - 1 < g_ultimaScritta + 1)
         return;
      n = CopyRates(_Symbol, PERIOD_H1, g_ultimaScritta + 1, tLimite - 1, r);
     }
   if(n <= 0)
     {
      // dopo una barra nuova c'e' SEMPRE almeno la barra appena chiusa: 0 o -1 e' un errore, il giro dopo recupera
      g_errCopia++;
      Print(EXP_TAG, " ERRORE CopyRates n=", n, " err=", GetLastError(), " limite ", TimeToString(tLimite, TIME_DATE | TIME_MINUTES));
      return;
     }
   for(int i = 0; i < n; i++)
     {
      if(r[i].time <= g_ultimaScritta || r[i].time >= tLimite)
        {
         g_scartate++;                 // gia' scritta o ancora in formazione: non si riscrive mai
         continue;
        }
      Riga(TimeToString(r[i].time, TIME_DATE | TIME_MINUTES) + ";" +
           DoubleToString(r[i].open,  g_digits) + ";" +
           DoubleToString(r[i].high,  g_digits) + ";" +
           DoubleToString(r[i].low,   g_digits) + ";" +
           DoubleToString(r[i].close, g_digits) + ";" +
           IntegerToString(r[i].tick_volume) + ";" +
           IntegerToString(r[i].spread) + ";" +
           IntegerToString(r[i].real_volume));
      if(g_prima == 0)
         g_prima = r[i].time;
      g_ultimaScritta = r[i].time;
      g_scritte++;
     }
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   // le tre guardie: solo tester, mai ottimizzazione, mai visuale (nessun grafico)
   if(!MQLInfoInteger(MQL_TESTER))
     {
      Print(EXP_TAG, " RIFIUTATO: gira SOLO nello Strategy Tester (qui non e' il tester). Nessun file scritto.");
      return(INIT_FAILED);
     }
   if(MQLInfoInteger(MQL_OPTIMIZATION))
     {
      Print(EXP_TAG, " RIFIUTATO: niente ottimizzazione (ogni passata riscriverebbe la stessa serie).");
      return(INIT_FAILED);
     }
   if(MQLInfoInteger(MQL_VISUAL_MODE))
     {
      Print(EXP_TAG, " RIFIUTATO: niente modalita' visuale (il tester non deve essere un grafico).");
      return(INIT_FAILED);
     }
   if(_Period != PERIOD_H1)
     {
      Print(EXP_TAG, " RIFIUTATO: il periodo del tester deve essere H1 (e' ", EnumToString((ENUM_TIMEFRAMES)_Period), ").");
      return(INIT_FAILED);
     }
   if(!RunIdValido(InpRunId))
     {
      Print(EXP_TAG, " RIFIUTATO: InpRunId deve essere di 12 caratteri 0-9 a-f (e' '", InpRunId, "').");
      return(INIT_FAILED);
     }
   g_digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   g_nome = EXP_MARCA + "_" + _Symbol + "_" + InpRunId + ".csv";
   if(FileIsExist(g_nome, FILE_COMMON))
     {
      Print(EXP_TAG, " RIFIUTATO: ", g_nome, " esiste gia' in Common\\Files e non si sovrascrive.");
      return(INIT_FAILED);
     }
   g_fh = FileOpen(g_nome, FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_COMMON | FILE_SHARE_READ);
   if(g_fh == INVALID_HANDLE)
     {
      Print(EXP_TAG, " ERRORE: FileOpen ", g_nome, " fallito, err=", GetLastError());
      return(INIT_FAILED);
     }
   // intestazione: niente conto, niente login, niente saldo. Il feed si riconosce dalla societa' del TERMINALE.
   Riga("#" + EXP_MARCA + ";v" + EXP_VER);
   Riga("#run;" + InpRunId);
   Riga("#simbolo;" + _Symbol);
   Riga("#periodo;H1");
   Riga("#digits;" + IntegerToString(g_digits));
   Riga("#point;" + DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_POINT), 8));
   Riga("#feed;" + TerminalInfoString(TERMINAL_COMPANY));
   Riga("#orologio;ORA_SERVER_DEL_FEED_NON_CONVERTITA");
   Riga("#nota_orologio;time_server = apertura della barra in ora del server del feed come registrata dal terminale. Nessuna conversione. L'orologio del feed lo dichiara il referto e lo verifica il collaudo.");
   Riga("#solo_barre_chiuse;si");
   Riga("time_server;open;high;low;close;tick_volume;spread;real_volume");
   Print(EXP_TAG, " AVVIO v", EXP_VER, " | ", _Symbol, " H1 | run ", InpRunId, " | file Common\\Files\\", g_nome);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(g_fh == INVALID_HANDLE)
      return;
   datetime t0 = iTime(_Symbol, PERIOD_H1, 0);
   if(t0 <= 0 || t0 == g_ultimaVista)
      return;
   g_ultimaVista = t0;
   ScriviFinoA(t0);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(g_fh == INVALID_HANDLE)
      return;
   // l'ultima barra vista si scrive SOLO se all'ora simulata della fine e' gia' chiusa
   // (di norma non lo e': il tester si ferma dentro di lei, e allora resta fuori, dichiarato)
   if(g_ultimaVista > 0 && TimeCurrent() >= g_ultimaVista + PeriodSeconds(PERIOD_H1))
      ScriviFinoA(g_ultimaVista + PeriodSeconds(PERIOD_H1));
   string fine = "#FINE;n=" + IntegerToString(g_scritte) +
                 ";prima=" + (g_prima > 0 ? TimeToString(g_prima, TIME_DATE | TIME_MINUTES) : "-") +
                 ";ultima=" + (g_ultimaScritta > 0 ? TimeToString(g_ultimaScritta, TIME_DATE | TIME_MINUTES) : "-") +
                 ";errori_copia=" + IntegerToString(g_errCopia) +
                 ";scartate=" + IntegerToString(g_scartate) +
                 ";motivo_deinit=" + IntegerToString(reason);
   Riga(fine);
   FileClose(g_fh);
   g_fh = INVALID_HANDLE;
   Print(EXP_TAG, " FINE ", StringSubstr(fine, 6), " | file Common\\Files\\", g_nome);
  }
//+------------------------------------------------------------------+
