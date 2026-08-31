//+------------------------------------------------------------------+
//|                                    ABTG_ImportaTickEsterno.mq5    |
//|                                                                   |
//|  ============ PASSO 0: BOZZA, NON COMPILATA, NON LANCIATA ======= |
//|  Scritta il 31/08/2026 come parte del PASSO 0 Dukascopy tick      |
//|  (backtest_pipeline/dukascopy/DUKASCOPY_PASSO0.md). Le righe di   |
//|  lancio arriveranno con verificatore quando Claudio decidera'.    |
//|  Come la v2 dell'importer M1: dichiarato NON COMPILATO -- il      |
//|  primo compile e' un passo del lancio, non un dato di fatto.      |
//|  =============================================================== |
//|                                                                   |
//|  IMPORTA TICK ESTERNI (CSV di dukascopy_tick.py) dentro MT5 come  |
//|  CUSTOM SYMBOL con TICK VERI, clonando le proprieta' dal simbolo  |
//|  BCM corrispondente. Solo cosi' il tester Modello 4 ("ogni tick   |
//|  basato su tick reali") ha tick reali su un simbolo custom: la    |
//|  v1/v2 M1 (CustomRatesUpdate) vietava esplicitamente il Modello 4 |
//|  sui suoi _EXT ("i tick reali NON esistono per un simbolo         |
//|  costruito da barre").                                            |
//|                                                                   |
//|  PERCHE' (i due verdetti parcheggiati):                           |
//|   1. NY Session Retest: cella slope75 PF 1.37-1.43, n=114 < muro  |
//|      R59. Tick Dow pre-2024 -> campione allungato.                |
//|   2. CRT Turtle Soup: vive nel chop 2022-2023, il tick BCM parte  |
//|      dal 2024.09.26 -> verdetto nel SUO regime impossibile.       |
//|                                                                   |
//|  ### REGOLA D'USO, CONGELATA - NON NEGOZIABILE ###                |
//|  I simboli *_DK servono SOLO per VERDETTI A PARAMETRI CONGELATI   |
//|  (prova di regime; allungamento del campione di una cella gia'    |
//|  tarata su BCM). NON si ottimizza MAI su dati di un altro feed.   |
//|                                                                   |
//|  ### CANCELLO ZERO DEI _DK (congelato PRIMA di ogni corsa) ###    |
//|  Nessun _DK entra in un round senza la SONDA passata:             |
//|   - giorni campione di sovrapposizione (il tick BCM nativo parte  |
//|     dal 2024.09.26: la sovrapposizione c'e' ed e' lunga);         |
//|   - mediana |diff bid| al minuto <= 0,05% del prezzo;             |
//|   - copertura minuti >= 80%;                                      |
//|   - spread mediano dichiarato (non giudicato: il tester usa il    |
//|     SUO spread, R55, ma il numero va nel referto);                |
//|   - discriminante DST: nei giorni delle settimane sfasate la      |
//|     diff decide il calendario (usa/europa), vedi PASSO0.md.       |
//|  Precedente che obbliga: gli _EXT HistData sono IN FRIGO perche'  |
//|  il loro cancello (0,061-0,101% > 0,05%) non e' mai passato.      |
//|  Un _DK che fallisce la sonda fa la stessa fine, senza sconti.    |
//|                                                                   |
//|  FORMATO CSV (congelato, scritto da dukascopy_tick.py):           |
//|      Time,Msec,Bid,Ask                                            |
//|      2022.03.14 15:30:07,842,32941.5,32944.0                      |
//|  Timestamp GIA' in ORA SERVER (conversione dichiarata NEL         |
//|  convertitore Python, mai a mano): qui NESSUNO shift.             |
//|  Un file per MESE: InpMascheraCsv li trova con FileFindFirst.     |
//|                                                                   |
//|  TRAPPOLE NOTE, dichiarate:                                       |
//|   - SPREAD/COMMISSIONI del tester restano quelli impostati, non   |
//|     quelli storici (R55: 1,5 punti indice spostano un verdetto).  |
//|     Pero' coi tick veri lo spread STORICO e' NEI PREZZI bid/ask:  |
//|     il tester Modello 4 lo usa. E' il vantaggio vero del tick.    |
//|   - iADX/iATR con handle su D1 NON popolano nel tester tick       |
//|     (misurato 30/08, corsa 23:07): gli EA con gate su TF alto     |
//|     devono usare CopyRates (v3 del CRT). Vale anche sui _DK.      |
//|   - Chiusura PULITA di MT5 a fine import (lezione 14/08: kill     |
//|     forzato = dati salvati ma simbolo non registrato).            |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

#define VERSIONE "IMP-TICK-v0-BOZZA"

input string InpSimboloSorgente   = "U30USD";                 // simbolo BCM da CLONARE (proprieta' e sonda)
input string InpSimboloNuovo      = "";                       // nome custom (vuoto = sorgente + "_DK")
input string InpMascheraCsv       = "U30USD_DK_ticks_*.csv";  // maschera dentro MQL5\Files
input bool   InpCancellaEsistente = true;                     // azzera i tick del custom prima di riempirlo
input int    InpBloccoTick        = 100000;                   // tick per chiamata a CustomTicksReplace
input bool   InpSoloSonda         = false;                    // true = NIENTE import, solo confronto col nativo
input string InpGiorniSonda       = "";                       // giorni campione "YYYY.MM.DD;..." (vuoto = lista di default)
input double InpSogliaDiffPct     = 0.05;                     // cancello: mediana |diff bid| al minuto, in % prezzo
input double InpSogliaCopertura   = 80.0;                     // cancello: % minuti coperti da entrambi i feed

#define REFERTO "ABTG_ImportTick_referto.csv"

//--- giorni campione di default della SONDA, scelti PRIMA di misurare:
//    2 giorni "normali" (allineamento base), i 4 gruppi delle settimane
//    SFASATE USA/EU dentro la sovrapposizione (27/10-03/11/2024,
//    09/03-30/03/2025, 26/10-02/11/2025, 08/03-29/03/2026: e' il
//    discriminante del calendario DST) e 1 giorno vicino a fine
//    sovrapposizione. Tutti giorni di borsa aperta.
#define GIORNI_SONDA_DEFAULT "2024.11.20;2025.06.16;2024.10.29;2024.10.31;2025.03.12;2025.03.25;2025.10.28;2026.03.11;2026.03.24;2026.06.15"

//+------------------------------------------------------------------+
//| utilita'                                                          |
//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringTrimLeft(s); StringTrimRight(s);
   return s;
  }

void CopiaIntero(string dst, string src, ENUM_SYMBOL_INFO_INTEGER p)
  { CustomSymbolSetInteger(dst, p, SymbolInfoInteger(src, p)); }
void CopiaDouble(string dst, string src, ENUM_SYMBOL_INFO_DOUBLE p)
  { CustomSymbolSetDouble(dst, p, SymbolInfoDouble(src, p)); }
void CopiaStringa(string dst, string src, ENUM_SYMBOL_INFO_STRING p)
  { CustomSymbolSetString(dst, p, SymbolInfoString(src, p)); }

bool VerificaDouble(string etichetta, string src, string dst, ENUM_SYMBOL_INFO_DOUBLE p, double tolleranza = 1e-9)
  {
   double a = SymbolInfoDouble(src, p);
   double b = SymbolInfoDouble(dst, p);
   double rif = MathMax(MathAbs(a), 1e-12);
   bool   ok  = (MathAbs(a - b) / rif) < tolleranza;
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
//| Crea (o riusa) il custom symbol e ne allinea le proprieta'.       |
//| Identico per costruzione alla v1 M1 (catena promossa 8/8 forex).  |
//| Ritorna il numero di proprieta' CRITICHE non allineate, -1 guasto.|
//+------------------------------------------------------------------+
int PreparaSimbolo(string src, string dst)
  {
   bool esiste = false;
   if(!CustomSymbolCreate(dst, "ABTG_DK", src))
     {
      int err = GetLastError();
      if(err == 5304)
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
   if(!esiste) PrintFormat("Creato custom symbol %s (gruppo ABTG_DK) clonando %s.", dst, src);

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
                         "ABTG tick Dukascopy clonato da " + src + " - SOLO verdetti a parametri congelati");

   SymbolSelect(dst, true);   // Market Watch, o il tester non lo vede

   Print("--- CONFRONTO PROPRIETA' (trappola 'unita' e valore punto') ---");
   int guasti = 0;
   if(!VerificaIntero("digits",        src, dst, SYMBOL_DIGITS))                 guasti++;
   if(!VerificaDouble("point",         src, dst, SYMBOL_POINT))                  guasti++;
   if(!VerificaDouble("tick_size",     src, dst, SYMBOL_TRADE_TICK_SIZE))        guasti++;
   if(!VerificaDouble("tick_value",    src, dst, SYMBOL_TRADE_TICK_VALUE, 1e-3)) guasti++;
   if(!VerificaDouble("contract_size", src, dst, SYMBOL_TRADE_CONTRACT_SIZE))    guasti++;
   VerificaDouble("volume_min",  src, dst, SYMBOL_VOLUME_MIN);
   VerificaDouble("volume_step", src, dst, SYMBOL_VOLUME_STEP);
   VerificaIntero("calc_mode",   src, dst, SYMBOL_TRADE_CALC_MODE);

   if(guasti > 0)
      PrintFormat("*** ERRORE: %d proprieta' CRITICHE non coincidono. NON usare "
                  "questo simbolo finche' non e' risolto. ***", guasti);
   else
      Print("   -> proprieta' critiche allineate: i P&L sono confrontabili con BCM.");
   return guasti;
  }

//+------------------------------------------------------------------+
//| PARSING di una riga tick: "YYYY.MM.DD HH:MM:SS,mmm,bid,ask"       |
//| Ritorna false su riga malformata (contata, mai ignorata zitta).   |
//+------------------------------------------------------------------+
bool LeggiRigaTick(const string linea, MqlTick &t)
  {
   string campi[];
   if(StringSplit(linea, ',', campi) != 4) return false;
   datetime sec = StringToTime(Pulisci(campi[0]));
   if(sec <= 0) return false;
   long ms = StringToInteger(Pulisci(campi[1]));
   if(ms < 0 || ms > 999) return false;
   double bid = StringToDouble(campi[2]);
   double ask = StringToDouble(campi[3]);
   if(bid <= 0.0 || ask <= 0.0) return false;
   t.time     = sec;
   t.time_msc = (long)sec * 1000 + ms;
   t.bid      = bid;
   t.ask      = ask;
   t.last     = 0.0;
   t.volume   = 0;
   t.flags    = TICK_FLAG_BID | TICK_FLAG_ASK;
   return true;
  }

//+------------------------------------------------------------------+
//| Scrive un blocco di tick con CustomTicksReplace (idempotente:     |
//| sostituisce l'intervallo [primo,ultimo] del blocco, quindi un     |
//| re-import dello stesso mese non duplica).                         |
//+------------------------------------------------------------------+
bool ScriviBlocco(string dst, MqlTick &blocco[], int n, long &scritti)
  {
   if(n <= 0) return true;
   ArrayResize(blocco, n);
   int esito = (int)CustomTicksReplace(dst, blocco[0].time_msc, blocco[n-1].time_msc, blocco);
   if(esito < 0)
     {
      PrintFormat("ERRORE: CustomTicksReplace fallito (errore %d) su blocco che parte da %s.",
                  GetLastError(), TimeToString(blocco[0].time, TIME_DATE|TIME_MINUTES));
      return false;
     }
   scritti += esito;
   return true;
  }

//+------------------------------------------------------------------+
//| IMPORT di un file CSV mensile, in streaming a blocchi.            |
//| I tick DEVONO essere in ordine cronologico (il convertitore li    |
//| scrive cosi'): un tick fuori ordine si CONTA e si scarta.         |
//+------------------------------------------------------------------+
bool ImportaFile(string dst, string nomeFile, long &scritti, long &scartate, long &fuoriOrdine,
                 long &askMinoreBid, datetime &primo, datetime &ultimo)
  {
   int fh = FileOpen(nomeFile, FILE_READ|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(fh == INVALID_HANDLE)
     {
      PrintFormat("ERRORE: non apro MQL5\\Files\\%s (errore %d).", nomeFile, GetLastError());
      return false;
     }
   MqlTick blocco[];
   ArrayResize(blocco, InpBloccoTick);
   int  n = 0;
   long ultimoMsc = 0;
   int  riga = 0;
   while(!FileIsEnding(fh) && !IsStopped())
     {
      string linea = Pulisci(FileReadString(fh));
      riga++;
      if(StringLen(linea) == 0) continue;
      if(riga == 1 && StringFind(linea, "Time") == 0) continue;   // intestazione
      MqlTick t;
      if(!LeggiRigaTick(linea, t)) { scartate++; continue; }
      if(t.time_msc < ultimoMsc)   { fuoriOrdine++; continue; }
      if(t.ask < t.bid) askMinoreBid++;   // si conta, non si corregge: dato del feed
      ultimoMsc = t.time_msc;
      if(primo == 0) primo = t.time;
      ultimo = t.time;
      blocco[n] = t;
      n++;
      if(n >= InpBloccoTick)
        {
         if(!ScriviBlocco(dst, blocco, n, scritti)) { FileClose(fh); return false; }
         ArrayResize(blocco, InpBloccoTick);
         n = 0;
        }
     }
   FileClose(fh);
   if(!ScriviBlocco(dst, blocco, n, scritti)) return false;
   return true;
  }

//+------------------------------------------------------------------+
//| SONDA: confronto tick _DK contro tick NATIVI BCM sui giorni       |
//| campione. Metro AL MINUTO: ultimo bid del minuto, |diff| in % del |
//| prezzo nativo. Mediana <= InpSogliaDiffPct e copertura >=         |
//| InpSogliaCopertura = cancello. I giorni delle settimane sfasate   |
//| USA/EU sono il discriminante del calendario DST: se li' la diff   |
//| esplode (~ampiezza di un'ora di mercato), il calendario usato dal |
//| convertitore e' quello sbagliato -> si riconverte (--solo-cache   |
//| --dst europa) e si rifa' la sonda. Deciso PRIMA, non dopo.        |
//+------------------------------------------------------------------+
void SondaGiorno(string src, string dst, datetime giorno,
                 double &mediaDiffPct, double &coperturaPct, long &nNat, long &nDk,
                 double &spreadNat, double &spreadDk, bool &ok)
  {
   ok = false;
   mediaDiffPct = 0; coperturaPct = 0; nNat = 0; nDk = 0; spreadNat = 0; spreadDk = 0;
   datetime da = giorno;
   datetime a  = giorno + 86400;
   MqlTick nat[], dk[];
   int gn = CopyTicksRange(src, nat, COPY_TICKS_INFO, (long)da * 1000, (long)a * 1000 - 1);
   int gd = CopyTicksRange(dst, dk,  COPY_TICKS_INFO, (long)da * 1000, (long)a * 1000 - 1);
   if(gn <= 0 || gd <= 0)
     {
      PrintFormat("   %s: tick nativi=%d, DK=%d -> giorno NON confrontabile.",
                  TimeToString(giorno, TIME_DATE), gn, gd);
      return;
     }
   nNat = gn; nDk = gd;

   //--- ultimo bid per minuto, 1440 celle, e spread medio
   double bidNat[1440], bidDk[1440];
   ArrayInitialize(bidNat, 0.0);
   ArrayInitialize(bidDk, 0.0);
   double sN = 0, sD = 0;
   for(int i = 0; i < gn; i++)
     {
      int k = (int)(((long)nat[i].time - (long)da) / 60);
      if(k >= 0 && k < 1440 && nat[i].bid > 0) bidNat[k] = nat[i].bid;
      if(nat[i].ask > 0 && nat[i].bid > 0) sN += (nat[i].ask - nat[i].bid);
     }
   for(int i = 0; i < gd; i++)
     {
      int k = (int)(((long)dk[i].time - (long)da) / 60);
      if(k >= 0 && k < 1440 && dk[i].bid > 0) bidDk[k] = dk[i].bid;
      if(dk[i].ask > 0 && dk[i].bid > 0) sD += (dk[i].ask - dk[i].bid);
     }
   spreadNat = sN / gn;
   spreadDk  = sD / gd;

   //--- diff percentuale sui minuti coperti da ENTRAMBI
   double diffs[];
   ArrayResize(diffs, 1440);
   int cnt = 0, minutiNat = 0;
   for(int k = 0; k < 1440; k++)
     {
      if(bidNat[k] <= 0) continue;
      minutiNat++;
      if(bidDk[k] <= 0) continue;
      diffs[cnt] = 100.0 * MathAbs(bidDk[k] - bidNat[k]) / bidNat[k];
      cnt++;
     }
   if(cnt < 30)
     {
      PrintFormat("   %s: solo %d minuti confrontabili -> campione troppo sottile.",
                  TimeToString(giorno, TIME_DATE), cnt);
      return;
     }
   ArrayResize(diffs, cnt);
   ArraySort(diffs);
   mediaDiffPct = diffs[cnt / 2];                       // MEDIANA (robusta agli eventi tipo 23/03)
   coperturaPct = (minutiNat > 0 ? 100.0 * cnt / minutiNat : 0);
   ok = true;
  }

//+------------------------------------------------------------------+
//| ordinamento nomi file (ArraySort non ordina le stringhe):         |
//| insertion sort, i file mensili sono poche decine                  |
//+------------------------------------------------------------------+
void OrdinaNomi(string &nomi[], int n)
  {
   for(int i = 1; i < n; i++)
     {
      string chiave = nomi[i];
      int j = i - 1;
      while(j >= 0 && StringCompare(nomi[j], chiave) > 0)
        {
         nomi[j + 1] = nomi[j];
         j--;
        }
      nomi[j + 1] = chiave;
     }
  }

//+------------------------------------------------------------------+
//| REFERTO in coda, una riga per esecuzione                          |
//+------------------------------------------------------------------+
void ScriviReferto(string dst, string src, long scritti, long scartate, long fuoriOrdine,
                   datetime primo, datetime ultimo, int guasti, int fileImportati,
                   string esitoSonda, string verdetto)
  {
   int fh = FileOpen(REFERTO, FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh == INVALID_HANDLE)
     { PrintFormat("ATTENZIONE: non scrivo %s (errore %d).", REFERTO, GetLastError()); return; }
   if(FileSize(fh) == 0)
      FileWrite(fh, "Versione","SimboloDK","SimboloSorgente","Maschera","FileImportati",
                    "TickScritti","RigheScartate","TickFuoriOrdine","PrimoTick","UltimoTick",
                    "ProprietaGuaste","EsitoSonda","Verdetto");
   FileSeek(fh, 0, SEEK_END);
   FileWrite(fh, VERSIONE, dst, src, InpMascheraCsv, (string)fileImportati,
             (string)scritti, (string)scartate, (string)fuoriOrdine,
             (primo  > 0 ? TimeToString(primo,  TIME_DATE|TIME_MINUTES) : "-"),
             (ultimo > 0 ? TimeToString(ultimo, TIME_DATE|TIME_MINUTES) : "-"),
             (string)guasti, esitoSonda, verdetto);
   FileClose(fh);
   PrintFormat("Referto aggiornato: MQL5\\Files\\%s", REFERTO);
  }

//+------------------------------------------------------------------+
void OnStart()
  {
   string src = Pulisci(InpSimboloSorgente);
   string dst = Pulisci(InpSimboloNuovo);
   if(StringLen(dst) == 0) dst = src + "_DK";

   Print("==============================================================");
   PrintFormat("=== IMPORT TICK ESTERNI (%s): %s -> %s ===", VERSIONE, InpMascheraCsv, dst);
   Print("=== REGOLA D'USO: verdetti a parametri CONGELATI. Qui non ===");
   Print("=== si ottimizza NULLA. Cancello: sonda passata, PRIMA.   ===");
   Print("==============================================================");

   if(!SymbolSelect(src, true))
     { PrintFormat("ERRORE: il simbolo sorgente %s non esiste su questo broker.", src); return; }

   //--- 1. custom symbol + proprieta' ---------------------------------
   int guasti = PreparaSimbolo(src, dst);
   if(guasti < 0) return;

   long scritti = 0, scartate = 0, fuoriOrdine = 0, askMinoreBid = 0;
   datetime primo = 0, ultimo = 0;
   int fileImportati = 0;

   if(!InpSoloSonda)
     {
      //--- 2. azzeramento dichiarato ----------------------------------
      if(InpCancellaEsistente)
        {
         long tolte = CustomTicksDelete(dst, 0, LONG_MAX);
         PrintFormat("Azzerati i tick di %s: %I64d rimossi.", dst, tolte);
        }

      //--- 3. i file mensili, in ordine alfabetico = cronologico ------
      //    (il nome e' <BCM>_DK_ticks_YYYY-MM.csv: l'ordine dei nomi
      //     E' l'ordine dei mesi, per costruzione del convertitore)
      string nomi[];
      int nNomi = 0;
      string trovato;
      long handle = FileFindFirst(InpMascheraCsv, trovato);
      if(handle == INVALID_HANDLE)
        { PrintFormat("ERRORE: nessun file per la maschera %s in MQL5\\Files.", InpMascheraCsv); return; }
      do
        {
         ArrayResize(nomi, nNomi + 1);
         nomi[nNomi] = trovato;
         nNomi++;
        }
      while(FileFindNext(handle, trovato));
      FileFindClose(handle);
      OrdinaNomi(nomi, nNomi);
      PrintFormat("Trovati %d file mensili.", nNomi);

      for(int i = 0; i < nNomi && !IsStopped(); i++)
        {
         PrintFormat("   [%d/%d] %s ...", i + 1, nNomi, nomi[i]);
         if(!ImportaFile(dst, nomi[i], scritti, scartate, fuoriOrdine, askMinoreBid, primo, ultimo))
           { Print("Import INTERROTTO."); return; }
         fileImportati++;
        }
      PrintFormat("Scritti %I64d tick su %s (%I64d righe scartate, %I64d fuori ordine, %I64d con ask<bid).",
                  scritti, dst, scartate, fuoriOrdine, askMinoreBid);
      if(primo > 0)
         PrintFormat("Periodo: %s -> %s.",
                     TimeToString(primo, TIME_DATE|TIME_MINUTES),
                     TimeToString(ultimo, TIME_DATE|TIME_MINUTES));
     }

   //--- 4. SONDA sui giorni campione ----------------------------------
   string listaGiorni = (StringLen(Pulisci(InpGiorniSonda)) > 0 ? InpGiorniSonda : GIORNI_SONDA_DEFAULT);
   string gg[];
   int ng = StringSplit(listaGiorni, ';', gg);
   Print("--- SONDA DI SOVRAPPOSIZIONE (cancello congelato PRIMA) ---");
   PrintFormat("   soglie: mediana diff <= %.3f%%, copertura >= %.0f%%", InpSogliaDiffPct, InpSogliaCopertura);
   int    giorniOk = 0, giorniMisurati = 0;
   double peggioreDiff = 0;
   string peggioreGiorno = "-";
   for(int i = 0; i < ng; i++)
     {
      datetime g = StringToTime(Pulisci(gg[i]));
      if(g <= 0) continue;
      double diffPct, copPct, sprN, sprD;
      long   nN, nD;
      bool   valido;
      SondaGiorno(src, dst, g, diffPct, copPct, nN, nD, sprN, sprD, valido);
      if(!valido) continue;
      giorniMisurati++;
      bool passa = (diffPct <= InpSogliaDiffPct && copPct >= InpSogliaCopertura);
      if(passa) giorniOk++;
      if(diffPct > peggioreDiff) { peggioreDiff = diffPct; peggioreGiorno = TimeToString(g, TIME_DATE); }
      PrintFormat("   %s: diff mediana %.4f%%  copertura %5.1f%%  tick nat/DK %I64d/%I64d  spread medio nat/DK %.2f/%.2f  %s",
                  TimeToString(g, TIME_DATE), diffPct, copPct, nN, nD, sprN, sprD,
                  (passa ? "OK" : "<<< FUORI SOGLIA"));
     }

   string esitoSonda;
   if(giorniMisurati == 0)
      esitoSonda = "SONDA NON MISURABILE (nessun giorno confrontabile)";
   else
      esitoSonda = StringFormat("%d/%d giorni dentro soglia (peggiore %.4f%% il %s)",
                                giorniOk, giorniMisurati, peggioreDiff, peggioreGiorno);
   Print("   -> " + esitoSonda);
   Print("   NOTA DST: se i giorni FUORI SOGLIA sono solo quelli delle settimane");
   Print("   sfasate USA/EU, il calendario del convertitore e' sbagliato: si");
   Print("   riconverte con --solo-cache --dst <altro> e si rifa' la sonda.");

   //--- 5. verdetto ---------------------------------------------------
   string verdetto;
   if(guasti > 0)                              verdetto = "ERRORE UNITA: NON USARE";
   else if(giorniMisurati == 0)                verdetto = "SONDA MANCANTE: NON USARE";
   else if(giorniOk == giorniMisurati)         verdetto = "OK: CANCELLO PASSATO";
   else if(giorniOk >= giorniMisurati - 2)     verdetto = "QUASI: leggere QUALI giorni falliscono (DST?)";
   else                                        verdetto = "CANCELLO CHIUSO: NON USARE (come gli _EXT in frigo)";
   PrintFormat("   VERDETTO ............ %s", verdetto);

   ScriviReferto(dst, src, scritti, scartate, fuoriOrdine, primo, ultimo,
                 guasti, fileImportati, esitoSonda, verdetto);

   Print("Per testare: tester su " + dst + ", Modello 4 (ogni tick basato su tick");
   Print("reali). Chiudere MT5 in modo PULITO a fine import (lezione 14/08).");
   Comment("Import tick " + dst + ": " + verdetto);
  }
//+------------------------------------------------------------------+
