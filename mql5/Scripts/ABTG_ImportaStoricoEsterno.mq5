//+------------------------------------------------------------------+
//|                                 ABTG_ImportaStoricoEsterno.mq5    |
//|                                                                   |
//|  IMPORTA storico ESTERNO (CSV M1) dentro MT5 come CUSTOM SYMBOL,  |
//|  clonando le proprieta' dal simbolo BCM corrispondente, cosi'     |
//|  walkforward_generico.ps1 puo' testarci sopra gli EA ESISTENTI    |
//|  senza toccare una riga di codice.                                |
//|                                                                   |
//|  PERCHE' ESISTE (14/08/2026, report/ASPETTATIVE_REALISTICHE.md):  |
//|  lo storico BCM degli INDICI parte dal 26/09/2024 -> la nostra    |
//|  finestra di walk-forward e' di 21 mesi e contiene UN SOLO        |
//|  REGIME (indici in salita). Niente 2022 (orso), niente 2020       |
//|  (crollo). Questo script serve a portare dentro gli anni che      |
//|  mancano, per rispondere a UNA domanda sola:                      |
//|                                                                   |
//|      "la strategia sopravvive a un mercato orso?"                 |
//|                                                                   |
//|  ### REGOLA D'USO, CONGELATA - NON NEGOZIABILE ###                |
//|  I simboli *_EXT servono SOLO come PROVA DI REGIME, a celle e     |
//|  parametri CONGELATI. NON si ottimizza MAI su dati di un altro    |
//|  feed: la taratura resta sui simboli BCM nativi, dove si opera.   |
//|  Un parametro pescato qui e' peggio di nessun test, perche'       |
//|  sembra validato e non lo e'.                                     |
//|                                                                   |
//|  LE TRAPPOLE CHE QUESTO SCRIPT DISINNESCA:                        |
//|   1. FUSO E DST -> auto-calibrazione dello shift orario contro    |
//|      lo storico NATIVO BCM, con tabella ispezionabile.            |
//|   2. UNITA' E VALORE PUNTO -> clonazione + ricopia esplicita +    |
//|      verifica di digits/point/tick value/contract size.           |
//|      (trappola gia' pagata col v21: uno stop di "50 punti" che    |
//|      su BCM valeva mezzo punto indice)                            |
//|  LA TRAPPOLA CHE NON PUO' DISINNESCARE:                           |
//|   3. SPREAD E COMMISSIONI restano quelli che imposti nel tester,  |
//|      non quelli storici del feed. Su strategie a stop stretto     |
//|      questo puo' spostare il verdetto: dichiararlo sempre.        |
//|                                                                   |
//|  USO: trascina lo script su un grafico qualsiasi, carica il .set  |
//|  scritto da backtest_pipeline\importa_storico_esterno.ps1.        |
//|  Il CSV va messo in MQL5\Files.                                   |
//|                                                                   |
//|  REFERTO: MQL5\Files\ABTG_ImportEsterno_referto.csv (in coda, una |
//|  riga per simbolo importato). SENZA quel referto l'import non     |
//|  vale niente: e' la prova che i due feed sono confrontabili.      |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string InpSimboloSorgente   = "EURUSD";        // simbolo BCM da CLONARE (proprieta' e confronto)
input string InpSimboloNuovo      = "";              // nome custom symbol (vuoto = sorgente + "_EXT")
input string InpFileCsv           = "EURUSD_M1.csv"; // file dentro MQL5\Files
input int    InpFormato           = 0;               // 0 = HistData M1 ASCII  |  1 = CSV generico con intestazione
input int    InpShiftOre          = 0;               // shift orario da applicare ai timestamp del file
input bool   InpAutoShift         = true;            // true = calibra lo shift da solo (ignora InpShiftOre)
input int    InpShiftMax          = 6;               // ampiezza della scansione automatica (+/- ore)
input bool   InpCancellaEsistente = true;            // true = azzera il custom symbol prima di riempirlo

#define REFERTO "ABTG_ImportEsterno_referto.csv"
#define BLOCCO  50000     // barre per chiamata a CustomRatesUpdate

//--- risultato della calibrazione, cosi' il referto e il log leggono
//    gli stessi numeri e non possono raccontare due storie diverse
struct EsitoConfronto
  {
   int      shift;          // ore applicate
   double   diffMediaPti;   // differenza media assoluta chiusure H1, in points
   double   diffMaxPti;     // differenza massima, in points
   double   diffMediaPct;   // la stessa media, in % del prezzo (confrontabile fra strumenti)
   datetime quandoMax;      // data della differenza massima (spesso e' una settimana di DST)
   int      barre;          // barre H1 confrontate
   int      barreNative;    // barre H1 native nella sovrapposizione
   double   coperturaPct;   // 100 * barre / barreNative
   bool     valido;         // false = nessuna sovrapposizione utile
  };

//+------------------------------------------------------------------+
//| utilita' di base                                                 |
//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringTrimLeft(s); StringTrimRight(s);
   return s;
  }

//--- ora piena (troncamento al bucket H1)
datetime OraPiena(datetime t) { return (datetime)((long)t - ((long)t % 3600)); }

//+------------------------------------------------------------------+
//| PARSING DELLE DATE                                               |
//| formato 0: "YYYYMMDD HHMMSS"  (HistData M1 ASCII)                |
//| formato 1: "YYYY.MM.DD HH:MM" (CSV generico; si tollerano anche  |
//|            i separatori "-" e la "T" ISO)                        |
//+------------------------------------------------------------------+
datetime LeggiData(string campo, int formato)
  {
   campo = Pulisci(campo);
   if(StringLen(campo) < 8) return 0;

   if(formato == 0)
     {
      // "20220103 170000" -> "2022.01.03 17:00:00"
      if(StringLen(campo) < 15) return 0;
      string d = StringSubstr(campo, 0, 4) + "." + StringSubstr(campo, 4, 2) + "." + StringSubstr(campo, 6, 2);
      string h = StringSubstr(campo, 9, 2) + ":" + StringSubstr(campo, 11, 2) + ":" + StringSubstr(campo, 13, 2);
      return StringToTime(d + " " + h);
     }

   StringReplace(campo, "-", ".");
   StringReplace(campo, "T", " ");
   StringReplace(campo, "/", ".");
   return StringToTime(campo);
  }

//+------------------------------------------------------------------+
//| CLONAZIONE DELLE PROPRIETA'                                      |
//| CustomSymbolCreate con simbolo di riferimento eredita tutto,     |
//| ma NON ci si fida: si ricopiano a mano le proprieta' che         |
//| decidono il P&L e poi si RILEGGONO per confronto.                |
//+------------------------------------------------------------------+
void CopiaIntero(string dst, string src, ENUM_SYMBOL_INFO_INTEGER p)
  {
   CustomSymbolSetInteger(dst, p, SymbolInfoInteger(src, p));
  }
void CopiaDouble(string dst, string src, ENUM_SYMBOL_INFO_DOUBLE p)
  {
   CustomSymbolSetDouble(dst, p, SymbolInfoDouble(src, p));
  }
void CopiaStringa(string dst, string src, ENUM_SYMBOL_INFO_STRING p)
  {
   CustomSymbolSetString(dst, p, SymbolInfoString(src, p));
  }

//--- confronto con stampa: ritorna true se coincidono
bool VerificaDouble(string etichetta, string src, string dst, ENUM_SYMBOL_INFO_DOUBLE p)
  {
   double a = SymbolInfoDouble(src, p);
   double b = SymbolInfoDouble(dst, p);
   //  tolleranza relativa: i double non si confrontano con ==
   double rif = MathMax(MathAbs(a), 1e-12);
   bool   ok  = (MathAbs(a - b) / rif) < 1e-9;
   PrintFormat("   %-22s sorgente=%.10g   nuovo=%.10g   %s",
               etichetta, a, b, (ok ? "OK" : "<<< DIVERSO"));
   return ok;
  }
bool VerificaIntero(string etichetta, string src, string dst, ENUM_SYMBOL_INFO_INTEGER p)
  {
   long a = SymbolInfoInteger(src, p);
   long b = SymbolInfoInteger(dst, p);
   bool ok = (a == b);
   PrintFormat("   %-22s sorgente=%I64d   nuovo=%I64d   %s",
               etichetta, a, b, (ok ? "OK" : "<<< DIVERSO"));
   return ok;
  }

//+------------------------------------------------------------------+
//| Crea (o riusa) il custom symbol e ne allinea le proprieta'.      |
//| Ritorna il numero di proprieta' CRITICHE non allineate.          |
//+------------------------------------------------------------------+
int PreparaSimbolo(string src, string dst)
  {
   bool esiste = false;
   if(!CustomSymbolCreate(dst, "ABTG_EXT", src))
     {
      int err = GetLastError();
      if(err == 5304)   // ERR_CUSTOM_SYMBOL_EXIST: gia' creato in un giro precedente
        {
         esiste = true;
         ResetLastError();
         PrintFormat("Il custom symbol %s esiste gia': lo riuso.", dst);
        }
      else
        {
         PrintFormat("ERRORE: CustomSymbolCreate(%s) fallito, errore %d.", dst, err);
         return -1;
        }
     }
   if(!esiste) PrintFormat("Creato custom symbol %s (gruppo ABTG_EXT) clonando %s.", dst, src);

   //--- ricopia esplicita (la clonazione da sola non basta se il simbolo
   //    esisteva gia' da un import precedente con un sorgente diverso)
   CopiaIntero(dst, src, SYMBOL_DIGITS);
   CopiaIntero(dst, src, SYMBOL_TRADE_CALC_MODE);
   CopiaIntero(dst, src, SYMBOL_TRADE_MODE);
   CopiaIntero(dst, src, SYMBOL_TRADE_EXEMODE);
   CopiaIntero(dst, src, SYMBOL_SWAP_MODE);
   CopiaIntero(dst, src, SYMBOL_SWAP_ROLLOVER3DAYS);
   CopiaIntero(dst, src, SYMBOL_TRADE_STOPS_LEVEL);
   CopiaIntero(dst, src, SYMBOL_TRADE_FREEZE_LEVEL);
   CopiaIntero(dst, src, SYMBOL_FILLING_MODE);
   CopiaIntero(dst, src, SYMBOL_EXPIRATION_MODE);
   CopiaIntero(dst, src, SYMBOL_ORDER_MODE);
   CopiaIntero(dst, src, SYMBOL_CHART_MODE);
   CopiaIntero(dst, src, SYMBOL_SPREAD_FLOAT);

   CopiaDouble(dst, src, SYMBOL_POINT);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_SIZE);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   CopiaDouble(dst, src, SYMBOL_TRADE_TICK_VALUE_LOSS);
   CopiaDouble(dst, src, SYMBOL_TRADE_CONTRACT_SIZE);
   CopiaDouble(dst, src, SYMBOL_VOLUME_MIN);
   CopiaDouble(dst, src, SYMBOL_VOLUME_MAX);
   CopiaDouble(dst, src, SYMBOL_VOLUME_STEP);
   CopiaDouble(dst, src, SYMBOL_VOLUME_LIMIT);
   CopiaDouble(dst, src, SYMBOL_MARGIN_INITIAL);
   CopiaDouble(dst, src, SYMBOL_MARGIN_MAINTENANCE);
   CopiaDouble(dst, src, SYMBOL_SWAP_LONG);
   CopiaDouble(dst, src, SYMBOL_SWAP_SHORT);

   CopiaStringa(dst, src, SYMBOL_CURRENCY_BASE);
   CopiaStringa(dst, src, SYMBOL_CURRENCY_PROFIT);
   CopiaStringa(dst, src, SYMBOL_CURRENCY_MARGIN);
   CustomSymbolSetString(dst, SYMBOL_DESCRIPTION,
                         "ABTG storico esterno clonato da " + src + " - SOLO prova di regime");

   SymbolSelect(dst, true);   // deve stare in Market Watch o il tester non lo vede

   //--- LA VERIFICA CHE CONTA: se questi quattro numeri non coincidono,
   //    ogni P&L calcolato sul simbolo importato e' un numero inventato.
   Print("--- CONFRONTO PROPRIETA' (trappola 'unita' e valore punto') ---");
   int guasti = 0;
   if(!VerificaIntero("digits",          src, dst, SYMBOL_DIGITS))               guasti++;
   if(!VerificaDouble("point",           src, dst, SYMBOL_POINT))                guasti++;
   if(!VerificaDouble("tick_size",       src, dst, SYMBOL_TRADE_TICK_SIZE))      guasti++;
   if(!VerificaDouble("tick_value",      src, dst, SYMBOL_TRADE_TICK_VALUE))     guasti++;
   if(!VerificaDouble("contract_size",   src, dst, SYMBOL_TRADE_CONTRACT_SIZE))  guasti++;
   //--- questi non bloccano ma vanno visti
   VerificaDouble("volume_min",     src, dst, SYMBOL_VOLUME_MIN);
   VerificaDouble("volume_step",    src, dst, SYMBOL_VOLUME_STEP);
   VerificaIntero("calc_mode",      src, dst, SYMBOL_TRADE_CALC_MODE);
   PrintFormat("   valuta profitto        sorgente=%s   nuovo=%s",
               SymbolInfoString(src, SYMBOL_CURRENCY_PROFIT),
               SymbolInfoString(dst, SYMBOL_CURRENCY_PROFIT));

   if(guasti > 0)
      PrintFormat("*** ERRORE: %d proprieta' CRITICHE non coincidono. NON usare questo "
                  "simbolo per misurare P&L finche' non e' risolto. ***", guasti);
   else
      Print("   -> le proprieta' critiche coincidono: i P&L sono confrontabili con BCM.");

   return guasti;
  }

//+------------------------------------------------------------------+
//| LETTURA DEL CSV                                                  |
//| Accetta sia ';' sia ',' come separatore (HistData usa ';', i CSV |
//| generici la virgola). Le righe malformate si CONTANO, non si     |
//| ignorano in silenzio: un file rotto deve vedersi nel referto.    |
//+------------------------------------------------------------------+
int LeggiCsv(string nomeFile, int formato, int shiftOre, MqlRates &out[], int &scartate)
  {
   scartate = 0;
   int fh = FileOpen(nomeFile, FILE_READ|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE)
     {
      PrintFormat("ERRORE: non trovo MQL5\\Files\\%s (errore %d).", nomeFile, GetLastError());
      return -1;
     }

   int n = 0;
   int capienza = 600000;              // ~4 anni di M1 forex: si ridimensiona a blocchi
   ArrayResize(out, capienza, 600000);
   long shiftSec = (long)shiftOre * 3600;
   int  riga = 0;

   while(!FileIsEnding(fh) && !IsStopped())
     {
      string linea = FileReadString(fh);
      riga++;
      linea = Pulisci(linea);
      if(StringLen(linea) == 0) continue;

      // separatore unico: la data non contiene mai virgole in nessuno dei due formati
      StringReplace(linea, ";", ",");
      string campi[];
      int nc = StringSplit(linea, ',', campi);
      if(nc < 5) { scartate++; continue; }

      datetime t = LeggiData(campi[0], formato);
      if(t <= 0)
        {
         // riga di intestazione del formato generico: non e' uno scarto
         if(riga == 1 || StringFind(Pulisci(campi[0]), "time") >= 0
                      || StringFind(Pulisci(campi[0]), "Time") >= 0
                      || StringFind(Pulisci(campi[0]), "Date") >= 0) continue;
         scartate++;
         continue;
        }

      double o = StringToDouble(campi[1]);
      double h = StringToDouble(campi[2]);
      double l = StringToDouble(campi[3]);
      double c = StringToDouble(campi[4]);
      long   v = (nc >= 6 ? (long)StringToInteger(campi[5]) : 0);

      // controllo di sanita': OHLC coerenti e positivi
      if(o <= 0.0 || h <= 0.0 || l <= 0.0 || c <= 0.0 || h < l ||
         h < o - 1e-12 || h < c - 1e-12 || l > o + 1e-12 || l > c + 1e-12)
        { scartate++; continue; }

      if(n >= capienza)
        {
         capienza += 600000;
         if(ArrayResize(out, capienza, 600000) < 0)
           { Print("ERRORE: memoria insufficiente per l'array delle barre."); FileClose(fh); return -1; }
        }

      out[n].time         = (datetime)((long)t + shiftSec);
      out[n].open         = o;
      out[n].high         = h;
      out[n].low          = l;
      out[n].close        = c;
      out[n].tick_volume  = (v > 0 ? v : 1);   // 0 tick volume manda in confusione alcuni indicatori
      out[n].real_volume  = 0;
      out[n].spread       = 0;
      n++;
     }
   FileClose(fh);
   ArrayResize(out, n);
   PrintFormat("CSV letto: %d righe totali, %d barre valide, %d righe scartate.", riga, n, scartate);
   return n;
  }

//+------------------------------------------------------------------+
//| ordinamento (serve solo se i file annuali sono stati concatenati |
//| in ordine sbagliato: nel caso normale non si esegue nemmeno)     |
//+------------------------------------------------------------------+
void OrdinaPerTempo(MqlRates &r[], int lo, int hi)
  {
   while(lo < hi)
     {
      datetime pivot = r[(lo + hi) / 2].time;
      int i = lo, j = hi;
      while(i <= j)
        {
         while(r[i].time < pivot) i++;
         while(r[j].time > pivot) j--;
         if(i <= j)
           {
            if(i != j) { MqlRates tmp = r[i]; r[i] = r[j]; r[j] = tmp; }
            i++; j--;
           }
        }
      // ricorsione sul lato piccolo, iterazione sul grande: niente stack overflow
      if(j - lo < hi - i) { OrdinaPerTempo(r, lo, j); lo = i; }
      else                { OrdinaPerTempo(r, i, hi); hi = j; }
     }
  }

//--- toglie i timestamp doppi (file annuali sovrapposti): tiene l'ultimo
int TogliDoppioni(MqlRates &r[], int n)
  {
   if(n <= 1) return n;
   int w = 0;
   for(int i = 1; i < n; i++)
     {
      if(r[i].time == r[w].time) r[w] = r[i];   // il piu' recente vince
      else { w++; if(w != i) r[w] = r[i]; }
     }
   int nuovo = w + 1;
   if(nuovo != n) PrintFormat("Rimossi %d timestamp doppi (file annuali sovrapposti).", n - nuovo);
   return nuovo;
  }

//+------------------------------------------------------------------+
//| AUTO-CALIBRAZIONE DELLO SHIFT ORARIO                             |
//|                                                                  |
//| Idea: nel periodo in cui il file importato e lo storico NATIVO   |
//| BCM si sovrappongono, la chiusura H1 e' la STESSA cosa vista da  |
//| due feed. Se il fuso e' giusto le due serie quasi coincidono; se |
//| e' sbagliato di un'ora, la differenza esplode.                   |
//|                                                                  |
//| Trucco che rende la scansione gratis: uno shift di ORE INTERE    |
//| mappa ogni bucket H1 in un altro bucket H1. Quindi si aggregano  |
//| le chiusure H1 importate UNA VOLTA SOLA e ogni shift diventa uno |
//| scorrimento dell'indice. Nessuna approssimazione, tredici        |
//| passate in un decimo di secondo.                                 |
//|                                                                  |
//| La tabella si stampa TUTTA: la scelta dev'essere ispezionabile,  |
//| non magica. Se il minimo non e' netto, il file e' sospetto.      |
//+------------------------------------------------------------------+
EsitoConfronto CalibraShift(string src, const MqlRates &imp[], int n, int shiftMin, int shiftMax, bool scegli, int shiftFisso)
  {
   EsitoConfronto res;
   res.shift = shiftFisso; res.diffMediaPti = 0; res.diffMaxPti = 0; res.diffMediaPct = 0;
   res.quandoMax = 0; res.barre = 0; res.barreNative = 0; res.coperturaPct = 0; res.valido = false;
   if(n <= 0) return res;

   double point = SymbolInfoDouble(src, SYMBOL_POINT);
   if(point <= 0) point = 1.0;

   //--- 1. storico NATIVO H1 del simbolo BCM (con attesa: la prima
   //       risposta di CopyRates e' solo la cache, il resto arriva dopo)
   MqlRates nat[];
   int got = -1;
   for(int tent = 0; tent < 240 && !IsStopped(); tent++)
     {
      got = CopyRates(src, PERIOD_H1, imp[0].time, TimeCurrent(), nat);
      if(got > 0) break;
      Sleep(250);
     }
   if(got <= 0)
     {
      Print("ATTENZIONE: nessuno storico H1 nativo su " + src + ": impossibile calibrare.");
      return res;
     }
   PrintFormat("Storico nativo H1 di %s: %d barre, dal %s al %s.",
               src, got, TimeToString(nat[0].time, TIME_DATE), TimeToString(nat[got-1].time, TIME_DATE|TIME_MINUTES));

   //--- 2. mappa delle chiusure native per ora piena
   datetime natBase = OraPiena(nat[0].time);
   int      natSpan = (int)(((long)OraPiena(nat[got-1].time) - (long)natBase) / 3600) + 1;
   if(natSpan <= 0) return res;
   double natClose[]; ArrayResize(natClose, natSpan); ArrayInitialize(natClose, 0.0);
   for(int i = 0; i < got; i++)
     {
      int k = (int)(((long)OraPiena(nat[i].time) - (long)natBase) / 3600);
      if(k >= 0 && k < natSpan) natClose[k] = nat[i].close;
     }

   //--- 3. chiusure H1 IMPORTATE: close dell'ultima M1 di ogni ora
   datetime impBase = OraPiena(imp[0].time);
   int      impSpan = (int)(((long)OraPiena(imp[n-1].time) - (long)impBase) / 3600) + 1;
   if(impSpan <= 0) return res;
   double impClose[];  ArrayResize(impClose,  impSpan); ArrayInitialize(impClose,  0.0);
   long   impUltimo[]; ArrayResize(impUltimo, impSpan); ArrayInitialize(impUltimo, 0);
   for(int i = 0; i < n; i++)
     {
      int k = (int)(((long)OraPiena(imp[i].time) - (long)impBase) / 3600);
      if(k < 0 || k >= impSpan) continue;
      if((long)imp[i].time >= impUltimo[k]) { impUltimo[k] = (long)imp[i].time; impClose[k] = imp[i].close; }
     }

   //--- 4. scansione degli shift
   Print("--- CALIBRAZIONE FUSO ORARIO (trappola 'fuso e DST') ---");
   Print("   shift |  diff media (points) |  diff media (%)  |  barre H1 confrontate");
   int    migliore = shiftFisso;
   double miglioreDiff = -1;
   int    miglioreBarre = 0;
   for(int s = shiftMin; s <= shiftMax; s++)
     {
      double somma = 0, sommaPrezzo = 0;
      int    cnt = 0;
      for(int k = 0; k < impSpan; k++)
        {
         if(impClose[k] <= 0) continue;
         long tnat = (long)impBase + (long)k * 3600 + (long)s * 3600;
         int  kn = (int)((tnat - (long)natBase) / 3600);
         if(kn < 0 || kn >= natSpan) continue;
         if(natClose[kn] <= 0) continue;
         somma += MathAbs(impClose[k] - natClose[kn]);
         sommaPrezzo += natClose[kn];
         cnt++;
        }
      if(cnt <= 0)
        { PrintFormat("   %+5d |          (nessuna sovrapposizione)", s); continue; }
      double media = somma / cnt;
      double pct   = (sommaPrezzo > 0 ? 100.0 * somma / sommaPrezzo : 0.0);
      PrintFormat("   %+5d | %20.1f | %15.4f%% | %8d", s, media / point, pct, cnt);
      // si sceglie solo fra shift con un campione decente: 50 barre H1 non
      // fanno statistica, e un minimo trovato su 3 barre e' rumore
      if(cnt >= 50 && (miglioreDiff < 0 || media < miglioreDiff))
        { miglioreDiff = media; migliore = s; miglioreBarre = cnt; }
     }

   if(miglioreDiff < 0)
     {
      Print("   -> NESSUNA SOVRAPPOSIZIONE UTILE fra importato e nativo.");
      Print("      Lo shift NON e' verificabile: si usa InpShiftOre e lo si dichiara nel referto.");
      res.shift = shiftFisso;
      return res;
     }

   res.shift = (scegli ? migliore : shiftFisso);
   PrintFormat("   -> shift scelto: %+d ore (su %d barre H1 confrontate).%s",
               res.shift, miglioreBarre,
               (scegli ? "" : "  [InpAutoShift=false: si usa comunque InpShiftOre]"));

   //--- 5. statistiche finali SULLO SHIFT CHE SI USA DAVVERO
   double somma = 0, sommaPrezzo = 0, maxd = 0;
   int    cnt = 0, natInSovr = 0;
   datetime qmax = 0;
   for(int k = 0; k < impSpan; k++)
     {
      if(impClose[k] <= 0) continue;
      long tnat = (long)impBase + (long)k * 3600 + (long)res.shift * 3600;
      int  kn = (int)((tnat - (long)natBase) / 3600);
      if(kn < 0 || kn >= natSpan) continue;
      natInSovr++;                       // ora H1 coperta dall'importato E dentro il range nativo
      if(natClose[kn] <= 0) continue;    // ora senza barra nativa (weekend/festivo/gap del broker)
      double d = MathAbs(impClose[k] - natClose[kn]);
      somma += d; sommaPrezzo += natClose[kn]; cnt++;
      if(d > maxd) { maxd = d; qmax = (datetime)tnat; }
     }
   res.barre        = cnt;
   res.barreNative  = natInSovr;
   res.diffMediaPti = (cnt > 0 ? (somma / cnt) / point : 0);
   res.diffMaxPti   = maxd / point;
   res.diffMediaPct = (sommaPrezzo > 0 ? 100.0 * somma / sommaPrezzo : 0);
   res.coperturaPct = (natInSovr > 0 ? 100.0 * cnt / natInSovr : 0);
   res.quandoMax    = qmax;
   res.valido       = (cnt >= 50);
   return res;
  }

//+------------------------------------------------------------------+
//| scrittura delle barre sul custom symbol, a blocchi               |
//+------------------------------------------------------------------+
bool ScriviBarre(string dst, const MqlRates &r[], int n)
  {
   if(InpCancellaEsistente)
     {
      int tolte = CustomRatesDelete(dst, (datetime)0, D'2100.01.01');
      PrintFormat("Azzerato %s: %d barre rimosse.", dst, tolte);
     }
   int scritte = 0;
   MqlRates blocco[];
   for(int i = 0; i < n && !IsStopped(); i += BLOCCO)
     {
      int q = ((n - i) < BLOCCO ? (n - i) : BLOCCO);
      ArrayResize(blocco, q);
      for(int j = 0; j < q; j++) blocco[j] = r[i + j];
      int esito = CustomRatesUpdate(dst, blocco, (uint)q);
      if(esito < 0)
        {
         PrintFormat("ERRORE: CustomRatesUpdate fallito al blocco %d (errore %d).", i / BLOCCO, GetLastError());
         return false;
        }
      scritte += esito;
      if((i / BLOCCO) % 10 == 0) PrintFormat("   ... %d / %d barre scritte", i + q, n);
     }
   PrintFormat("Scritte %d barre M1 su %s (i TF superiori li ricostruisce MT5 da solo).", scritte, dst);
   return true;
  }

//+------------------------------------------------------------------+
//| REFERTO: si scrive IN CODA, una riga per simbolo importato       |
//+------------------------------------------------------------------+
void ScriviReferto(string dst, string src, int nBarre, int scartate,
                   datetime prima, datetime ultima, const EsitoConfronto &e,
                   int guasti, string verdetto)
  {
   int fh = FileOpen(REFERTO, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh == INVALID_HANDLE)
     { PrintFormat("ATTENZIONE: non riesco a scrivere %s (errore %d).", REFERTO, GetLastError()); return; }
   if(FileSize(fh) == 0)
      FileWrite(fh, "SimboloEXT","SimboloSorgente","FileCsv","Formato","Barre","RigheScartate",
                    "PrimaData","UltimaData","ShiftOre","ShiftAuto","DiffMediaPunti","DiffMaxPunti",
                    "DiffMediaPct","QuandoDiffMax","BarreH1Confrontate","CoperturaPct","ProprietaGuaste","Verdetto");
   FileSeek(fh, 0, SEEK_END);
   FileWrite(fh, dst, src, InpFileCsv, (string)InpFormato, (string)nBarre, (string)scartate,
             TimeToString(prima, TIME_DATE|TIME_MINUTES),
             TimeToString(ultima, TIME_DATE|TIME_MINUTES),
             StringFormat("%+d", e.shift), (InpAutoShift ? "SI" : "NO"),
             StringFormat("%.1f", e.diffMediaPti),
             StringFormat("%.1f", e.diffMaxPti),
             StringFormat("%.4f", e.diffMediaPct),
             (e.quandoMax > 0 ? TimeToString(e.quandoMax, TIME_DATE|TIME_MINUTES) : "-"),
             (string)e.barre,
             StringFormat("%.1f", e.coperturaPct),
             (string)guasti, verdetto);
   FileClose(fh);
   PrintFormat("Referto aggiornato: MQL5\\Files\\%s", REFERTO);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   string src = Pulisci(InpSimboloSorgente);
   string dst = Pulisci(InpSimboloNuovo);
   if(StringLen(dst) == 0) dst = src + "_EXT";

   Print("==============================================================");
   PrintFormat("=== IMPORT STORICO ESTERNO: %s -> %s ===", InpFileCsv, dst);
   Print("=== REGOLA D'USO: prova di regime a parametri CONGELATI.  ===");
   Print("=== Su questi dati NON si ottimizza NULLA.                ===");
   Print("==============================================================");

   if(!SymbolSelect(src, true))
     { PrintFormat("ERRORE: il simbolo sorgente %s non esiste su questo broker.", src); return; }

   //--- 1. custom symbol + proprieta' ------------------------------------
   int guasti = PreparaSimbolo(src, dst);
   if(guasti < 0) return;

   //--- 2. lettura CSV (senza shift: lo shift si applica DOPO la calibrazione)
   MqlRates rates[];
   int scartate = 0;
   int n = LeggiCsv(InpFileCsv, InpFormato, 0, rates, scartate);
   if(n <= 0) { Print("ERRORE: nessuna barra utile nel file. Import annullato."); return; }

   //--- ordine e doppioni
   bool disordinato = false;
   for(int i = 1; i < n; i++) if(rates[i].time < rates[i-1].time) { disordinato = true; break; }
   if(disordinato)
     {
      Print("ATTENZIONE: il file NON e' in ordine cronologico: riordino.");
      OrdinaPerTempo(rates, 0, n - 1);
     }
   n = TogliDoppioni(rates, n);
   ArrayResize(rates, n);

   PrintFormat("Barre importate: %d, dal %s al %s (ora del FILE, ancora senza shift).",
               n, TimeToString(rates[0].time, TIME_DATE|TIME_MINUTES),
               TimeToString(rates[n-1].time, TIME_DATE|TIME_MINUTES));

   //--- 3. calibrazione dello shift --------------------------------------
   EsitoConfronto esito = CalibraShift(src, rates, n, -InpShiftMax, InpShiftMax,
                                       InpAutoShift, InpShiftOre);
   int shiftUsato = esito.shift;

   //--- 4. applica lo shift e scrive -------------------------------------
   if(shiftUsato != 0)
     {
      long sec = (long)shiftUsato * 3600;
      for(int i = 0; i < n; i++) rates[i].time = (datetime)((long)rates[i].time + sec);
      PrintFormat("Applicato shift di %+d ore a tutti i timestamp.", shiftUsato);
     }
   else Print("Shift applicato: 0 ore.");

   datetime prima = rates[0].time, ultima = rates[n-1].time;
   if(!ScriviBarre(dst, rates, n)) { Print("Import INTERROTTO in scrittura."); return; }

   //--- 5. verdetto e referto --------------------------------------------
   //  La soglia e' in PERCENTUALE di prezzo, cosi' vale sia su EURUSD sia
   //  sull'oro sia su un indice: due feed onesti sullo stesso strumento
   //  stanno sotto lo 0,05% sulle chiusure H1.
   string verdetto;
   if(guasti > 0)                    verdetto = "ERRORE UNITA: NON USARE";
   else if(!esito.valido)            verdetto = "SHIFT NON VERIFICATO (nessuna sovrapposizione)";
   else if(esito.diffMediaPct <= 0.05) verdetto = "OK CONFRONTABILE";
   else if(esito.diffMediaPct <= 0.20) verdetto = "DIFFERENZE FEED APPREZZABILI";
   else                              verdetto = "SOSPETTO: shift o simbolo sbagliato";

   Print("--- REFERTO ---");
   PrintFormat("   simbolo EXT ......... %s (da %s)", dst, src);
   PrintFormat("   barre M1 ............ %d", n);
   PrintFormat("   righe scartate ...... %d", scartate);
   PrintFormat("   periodo ............. %s -> %s",
               TimeToString(prima, TIME_DATE|TIME_MINUTES), TimeToString(ultima, TIME_DATE|TIME_MINUTES));
   PrintFormat("   shift applicato ..... %+d ore (%s)", shiftUsato, (InpAutoShift ? "automatico" : "manuale"));
   if(esito.valido)
     {
      PrintFormat("   diff media H1 ....... %.1f points (%.4f%% del prezzo)", esito.diffMediaPti, esito.diffMediaPct);
      PrintFormat("   diff massima H1 ..... %.1f points il %s", esito.diffMaxPti, TimeToString(esito.quandoMax, TIME_DATE|TIME_MINUTES));
      PrintFormat("   copertura ........... %.1f%% (%d barre H1 presenti in ENTRAMBI su %d)",
                  esito.coperturaPct, esito.barre, esito.barreNative);
      Print("   NOTA: il picco di differenza massima cade quasi sempre nelle due");
      Print("   settimane l'anno in cui l'ora legale USA e quella europea non");
      Print("   coincidono. Uno shift COSTANTE non le puo' correggere: se una");
      Print("   strategia dipende dall'orario al minuto, tienine conto.");
     }
   else
      Print("   confronto con il nativo: NON DISPONIBILE (nessuna sovrapposizione)");
   PrintFormat("   VERDETTO ............ %s", verdetto);

   ScriviReferto(dst, src, n, scartate, prima, ultima, esito, guasti, verdetto);

   Print("Per testare: nel tester scegli il simbolo " + dst + " e usa il modello");
   Print("'OHLC su M1' (walkforward_generico -Modello 1) oppure 'ogni tick' generato");
   Print("dalle M1 (-Modello 0). MAI il modello 4 (tick reali): i tick reali NON");
   Print("esistono per un simbolo costruito da barre, e il tester li inventerebbe.");
   Comment("Import " + dst + " COMPLETATO: " + verdetto);
  }
//+------------------------------------------------------------------+
