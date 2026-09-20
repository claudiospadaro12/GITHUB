//+------------------------------------------------------------------+
//|                              ABTG_PrevoloFTMO_Specifiche.mq5     |
//|                                                                  |
//|  IL LETTORE DELLE SPECIFICHE FTMO -- SCRIPT DI SOLA LETTURA.     |
//|                                                                  |
//|  PERCHE' ESISTE (20/09/2026)                                     |
//|  La sonda backtest_pipeline\righe\PREVOLO_FTMO.ps1 chiude da     |
//|  disco UNA CASELLA E MEZZA su sei. Le altre le deve leggere un    |
//|  umano da Market Watch, a mezzanotte, ricopiando numeri da una    |
//|  finestra. Quel referto lo dice da solo (r.615-628): se esiste    |
//|  MQL5\Files\PREVOLO_FTMO_specifiche.csv, le caselle 3-4-5 si      |
//|  chiudono DA SOLE. Questo script e' il produttore di quel file.   |
//|                                                                  |
//|  IL CONSUMATORE COMANDA SUL FORMATO, NON IO                      |
//|  PREVOLO_FTMO.ps1 r.618-628 fa tre cose e solo tre:               |
//|    1. Test-Path su <dati>\MQL5\Files\PREVOLO_FTMO_specifiche.csv  |
//|       -> il nome e' ESATTO e la cartella e' quella NON comune:    |
//|          quindi NIENTE FILE_COMMON, che scriverebbe in            |
//|          Terminal\Common\Files e la sonda non troverebbe niente;  |
//|    2. spezza il testo su "\n" e tiene le righe non vuote; se ne   |
//|       conta UNA SOLA (o zero) considera il file assente           |
//|       -> servono ALMENO DUE righe non vuote, sempre;              |
//|    3. stampa ogni riga dopo aver tolto i caratteri non ASCII e    |
//|       fatto Trim. NON spezza sul separatore, NON cerca nomi di    |
//|       colonna, NON converte niente.                               |
//|  Conclusione misurata: il SEPARATORE e l'INTESTAZIONE non sono    |
//|  vincolati dal consumatore. Allora si sceglie quello di casa      |
//|  (ABTG_InfoBroker.mq5 r.407: FILE_CSV|FILE_ANSI, virgola) e si    |
//|  sceglie un layout che si LEGGA in un referto di testo, perche'   |
//|  e' li' che queste righe vanno a finire, una per una.             |
//|  ANSI (=ASCII qui) e non Unicode di proposito: la Leggi-Testo     |
//|  della sonda regge tutte e due, ma il referto lo legge un umano.  |
//|                                                                  |
//|  SOLA LETTURA -- e si verifica cercando nel sorgente:             |
//|    nessun OrderSend, nessun CTrade, nessun #include <Trade\...>,  |
//|    nessun PositionModify, nessun ObjectCreate, nessun FileDelete. |
//|    L'unica scrittura e' il FileWrite sul CSV qui sopra.           |
//|    OrderCalcMargin NON manda niente al server: e' il calcolatore  |
//|    di margine del terminale (serve per la casella 3).             |
//|    SymbolSelect e' dietro un input DEFAULT FALSE: aggiungere un   |
//|    simbolo a Market Watch non e' un ordine, ma e' comunque un     |
//|    cambio di stato del terminale, e qui il mandato dice NO.       |
//|                                                                  |
//|  LA TRAPPOLA DI STASERA, ed e' DOMENICA (contro-esempio)          |
//|  TimeCurrent() a mercato CHIUSO NON dice che ore sono: dice       |
//|  quando e' arrivato l'ULTIMO TICK, che stasera puo' essere di     |
//|  VENERDI'. Chi misurasse il fuso con TimeCurrent()-TimeGMT()      |
//|  oggi otterrebbe uno scarto sbagliato di GIORNI, non di ore -- ed |
//|  e' esattamente la trappola che PREVOLO_FTMO.ps1 (r.455-459)      |
//|  dichiara di NON saper chiudere. Qui il delta si misura con       |
//|  TimeTradeServer(), che il terminale CALCOLA e che vale anche a   |
//|  mercato fermo; TimeCurrent() viene scritto lo stesso, ma come    |
//|  "ultimo tick", con accanto il verdetto MercatoAperto SI/NO.      |
//|  Cosi' la casella 1 si chiude DAVVERO, e non per fortuna.         |
//|                                                                  |
//|  NON COMPILATO: qui non c'e' MetaEditor. Il PRIMO F7 E' ANCHE IL  |
//|  PRIMO COLLAUDO. Quello che si poteva verificare senza compilare  |
//|  e' stato verificato (esistenza e firma di ogni funzione usata,   |
//|  graffe bilanciate, nessun identificatore non dichiarato), ma un  |
//|  errore di compilazione resta possibile e va dichiarato.          |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property script_show_inputs
#property description "Legge le specifiche dei simboli e del conto e scrive MQL5\\Files\\PREVOLO_FTMO_specifiche.csv. SOLA LETTURA: non manda nessun ordine."

//--- il nome NON e' una scelta: lo cerca PREVOLO_FTMO.ps1 r.618
#define ABTG_FILE_SPEC "PREVOLO_FTMO_specifiche.csv"

input bool InpTuttiISimboli   = false;  // scrivi anche l'elenco GREZZO di tutti i simboli del broker
input bool InpSelezionaSimboli= false;  // ATTENZIONE: se true AGGIUNGE i simboli a Market Watch (non e' piu' sola lettura)
input int  InpBcmOffsetUTC    = 1;      // offset UTC del server BCM oggi (regola di casa: ora italiana -1 -> +1 d'estate)
input int  InpDeltaAtteso     = 2;      // delta FTMO-BCM su cui sono rimappati i 10 preset

//+------------------------------------------------------------------+
//| I CINQUE MERCATI DELLA ROSA.                                     |
//|  I nomi candidati sono la TRADUZIONE FEDELE delle regex di        |
//|  PREVOLO_FTMO.ps1 r.108-114: produttore e consumatore devono      |
//|  chiamare "simile" la stessa cosa, altrimenti la sonda cerchereb- |
//|  be un simbolo che questo script non ha mai guardato.             |
//|  MQL5 non ha le regex: il suffisso ([._#+-]XX) lo fa Combacia().  |
//+------------------------------------------------------------------+
string   gMercatoNome[5];
string   gMercatoNostro[5];
string   gMercatoCand[5];     // candidati separati da spazio

void CaricaDizionario()
  {
   gMercatoNome[0]   = "DAX";
   gMercatoNostro[0] = "D30EUR";
   gMercatoCand[0]   = "DAX DAX30 DAX40 GER30 GER40 GER30CASH GER40CASH GER30EUR GER40EUR "
                       + "DE30 DE40 DE30EUR DE40EUR DE30CASH DE40CASH D30EUR D40EUR "
                       + "GERMAN30 GERMAN40 GERMANY30 GERMANY40 GERMAN30CASH GERMAN40CASH "
                       + "GERMANY30CASH GERMANY40CASH FDAX";

   gMercatoNome[1]   = "DOW";
   gMercatoNostro[1] = "U30USD";
   gMercatoCand[1]   = "US30 US30CASH USA30 USA30CASH DJ DJ30 DJI DJIA DJUSD DJ30USD "
                       + "DJIUSD DJIAUSD WS30 DOW DOW30 DOWJONES U30USD YM US30USD";

   gMercatoNome[2]   = "NASDAQ";
   gMercatoNostro[2] = "NASUSD";
   gMercatoCand[2]   = "NAS NAS100 NASDAQ NASUSD NAS100CASH US100 USTEC US100CASH "
                       + "USTECCASH USATEC NDX NDX100 TECH100 US100USD";

   gMercatoNome[3]   = "ORO";
   gMercatoNostro[3] = "XAUUSD";
   gMercatoCand[3]   = "XAUUSD GOLD GOLDUSD XAU";

   gMercatoNome[4]   = "USDJPY";
   gMercatoNostro[4] = "USDJPY";
   gMercatoCand[4]   = "USDJPY";
  }

//+------------------------------------------------------------------+
//| Toglie dal testo tutto quello che romperebbe il CSV o il referto.|
//|  La virgola PRIMA di tutto: FileWrite con FILE_CSV non mette le   |
//|  virgolette, quindi una descrizione tipo "Dow Jones, cash" spos-  |
//|  terebbe di una colonna tutta la riga. Non e' teoria: e' il       |
//|  motivo per cui ABTG_InfoBroker.mq5 ha la stessa Pulisci().       |
//|  Fuori dall'ASCII stampabile si sostituisce: la sonda toglie i    |
//|  non-ASCII comunque, ma li toglie SENZA lasciare lo spazio, e     |
//|  due parole si attaccherebbero.                                   |
//+------------------------------------------------------------------+
string Pulisci(string s)
  {
   StringReplace(s, ",",  " ");
   StringReplace(s, ";",  " ");
   StringReplace(s, "\"", " ");
   StringReplace(s, "\r", " ");
   StringReplace(s, "\n", " ");
   StringReplace(s, "\t", " ");
   string o = "";
   int n = StringLen(s);
   for(int i = 0; i < n; i++)
     {
      ushort c = StringGetCharacter(s, i);
      if(c >= 32 && c <= 126) o += ShortToString(c);
      else                    o += " ";
     }
   StringTrimLeft(o);
   StringTrimRight(o);
   if(StringLen(o) == 0) o = "-";
   return o;
  }

string Maiuscolo(string s){ StringToUpper(s); return s; }

//+------------------------------------------------------------------+
//| "sym combacia con cand?" -- la stessa regola della regex della    |
//| sonda: nome UGUALE, oppure nome + UN separatore fra . _ # + -     |
//| seguito da 1..6 caratteri A-Z0-9 (le varianti .cash .raw + ecc.). |
//+------------------------------------------------------------------+
bool Combacia(string sym, string cand)
  {
   int ls = StringLen(sym);
   int lc = StringLen(cand);
   if(lc <= 0) return false;
   if(sym == cand) return true;
   if(ls <= lc)    return false;
   if(StringSubstr(sym, 0, lc) != cand) return false;

   ushort sep = StringGetCharacter(sym, lc);
   if(sep != '.' && sep != '_' && sep != '#' && sep != '+' && sep != '-') return false;

   int coda = ls - lc - 1;
   if(coda < 1 || coda > 6) return false;
   for(int i = lc + 1; i < ls; i++)
     {
      ushort c = StringGetCharacter(sym, i);
      bool ok = ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'));
      if(!ok) return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Il simbolo appartiene al mercato idx?                            |
//+------------------------------------------------------------------+
bool DelMercato(string symUp, int idx)
  {
   string c[];
   int n = StringSplit(gMercatoCand[idx], ' ', c);
   for(int i = 0; i < n; i++)
     {
      string cc = c[i];
      StringTrimLeft(cc); StringTrimRight(cc);
      if(StringLen(cc) == 0) continue;
      if(Combacia(symUp, cc)) return true;
     }
   return false;
  }

string OreMinuti(int minuti)
  {
   string segno = (minuti < 0 ? "-" : "+");
   int a = (int)MathAbs(minuti);
   return StringFormat("%s%02d:%02d", segno, a/60, a%60);
  }

//+------------------------------------------------------------------+
//| Un double stampato in modo che si LEGGA: i tick size valgono      |
//| 0.00001, i margini 3067.45. Una sola F non va bene per tutti e    |
//| due, e un numero illeggibile e' un numero che nessuno controlla.  |
//+------------------------------------------------------------------+
string Num(double v)
  {
   double a = MathAbs(v);
   if(a == 0.0)    return "0";
   if(a < 0.001)   return DoubleToString(v, 8);
   if(a < 1.0)     return DoubleToString(v, 5);
   if(a < 1000.0)  return DoubleToString(v, 3);
   return DoubleToString(v, 2);
  }

//+------------------------------------------------------------------+
//| SCRIVE UNA RIGA SIMBOLO.                                         |
//|  stato = TROVATO | CANDIDATO | ASSENTE.                           |
//|  Una riga ASSENTE si scrive COMUNQUE (mandato): un file parziale  |
//|  e' utile, un file che non c'e' no.                               |
//+------------------------------------------------------------------+
void RigaSimbolo(int fh, string mercato, string sym, string stato)
  {
   if(stato == "ASSENTE")
     {
      FileWrite(fh, mercato, sym, "ASSENTE",
                "NESSUN CANDIDATO SUL BROKER - leggilo a mano in Ctrl+U",
                "-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-");
      return;
     }

   string desc   = Pulisci(SymbolInfoString(sym, SYMBOL_DESCRIPTION));
   string path   = Pulisci(SymbolInfoString(sym, SYMBOL_PATH));
   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
   double tsize  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   double tval   = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double csize  = SymbolInfoDouble(sym, SYMBOL_TRADE_CONTRACT_SIZE);
   double vmin   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double vmax   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   double vstep  = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double mini   = SymbolInfoDouble(sym, SYMBOL_MARGIN_INITIAL);
   long   stops  = SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   long   freeze = SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL);
   long   spread = SymbolInfoInteger(sym, SYMBOL_SPREAD);
   bool   sfloat = (SymbolInfoInteger(sym, SYMBOL_SPREAD_FLOAT) != 0);
   bool   inMW   = (SymbolInfoInteger(sym, SYMBOL_SELECT) != 0);
   string curP   = Pulisci(SymbolInfoString(sym, SYMBOL_CURRENCY_PROFIT));
   string curM   = Pulisci(SymbolInfoString(sym, SYMBOL_CURRENCY_MARGIN));
   int    calc   = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_CALC_MODE);
   int    tmode  = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_MODE);
   double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
   double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);

   //--- CASELLA 3: il margine per 1 lotto.
   //    SYMBOL_MARGIN_INITIAL vale 0 su quasi tutti i broker (vuol dire
   //    "calcolalo dalla leva"), quindi il numero vero lo da'
   //    OrderCalcMargin, che NON manda niente al server: calcola e basta.
   //    Senza prezzo (mercato chiuso, simbolo non sottoscritto) non si
   //    puo' calcolare, e si scrive "n.d." invece di inventare.
   double marg1 = 0.0;
   string marg1s = "n.d. (serve un prezzo: simbolo non in Market Watch o mercato fermo)";
   double px = (ask > 0.0 ? ask : bid);
   if(px > 0.0)
     {
      if(OrderCalcMargin(ORDER_TYPE_BUY, sym, 1.0, px, marg1)) marg1s = Num(marg1);
      else                                                     marg1s = StringFormat("errore %d", GetLastError());
     }
   else if(mini > 0.0)
      marg1s = Num(mini) + " (da SYMBOL_MARGIN_INITIAL)";

   FileWrite(fh,
             mercato,
             sym,
             stato,
             desc,
             (string)digits,
             Num(point),
             Num(tsize),
             Num(tval),
             Num(csize),
             Num(vmin),
             Num(vmax),
             Num(vstep),
             marg1s,
             Num(mini),
             curM,
             (string)stops,
             (string)freeze,
             (string)spread,
             (sfloat ? "FLOTTANTE" : "FISSO"),
             curP,
             EnumToString((ENUM_SYMBOL_CALC_MODE)calc),
             EnumToString((ENUM_SYMBOL_TRADE_MODE)tmode),
             (inMW ? "SI" : "NO"),
             (bid > 0.0 ? Num(bid) : "n.d."),
             (ask > 0.0 ? Num(ask) : "n.d."),
             path);
  }

//+------------------------------------------------------------------+
//| OnStart -- questo e' uno SCRIPT: niente OnTick, niente OnInit.   |
//+------------------------------------------------------------------+
void OnStart()
  {
   uint t0 = GetTickCount();
   CaricaDizionario();

   int fh = FileOpen(ABTG_FILE_SPEC, FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_SHARE_READ, ",");
   if(fh == INVALID_HANDLE)
     {
      Print("PREVOLO SPECIFICHE: NON riesco ad aprire ", ABTG_FILE_SPEC,
            " in MQL5\\Files (errore ", GetLastError(), "). NON HO MISURATO NIENTE.");
      return;
     }

   //================================================================
   // TESTA
   //================================================================
   FileWrite(fh, "ABTG_PREVOLO_FTMO_SPECIFICHE", "v1",
             TimeToString(TimeLocal(), TIME_DATE|TIME_SECONDS),
             "prodotto da mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5 - SOLA LETTURA");
   FileWrite(fh, "SE QUESTA DATA NON E DI ADESSO STAI LEGGENDO UN CSV VECCHIO: rilancia lo script.");

   //================================================================
   // CASELLA 1 -- L'OROLOGIO. Il delta si misura con TimeTradeServer,
   // non con TimeCurrent: vedi l'intestazione (trappola della domenica).
   //================================================================
   datetime srv  = TimeTradeServer();
   datetime tick = TimeCurrent();
   datetime gmt  = TimeGMT();
   datetime loc  = TimeLocal();

   int offMin   = (int)(MathRound(((double)((long)srv - (long)gmt) / 60.0) / 15.0) * 15);
   int offLocMin= (int)(MathRound(((double)((long)loc - (long)gmt) / 60.0) / 15.0) * 15);
   long gapTick = (long)srv - (long)tick;
   bool aperto  = (MathAbs((double)gapTick) < 600.0);

   int attesoMin = (InpBcmOffsetUTC + InpDeltaAtteso) * 60;
   int scartoMin = offMin - attesoMin;

   string verdetto;
   if(!aperto)
      verdetto = StringFormat("MISURATO CON TimeTradeServer (mercato FERMO: l ultimo tick e vecchio di %d min). "
                              + "Delta reale %s = BCM %+d. ", (int)(gapTick/60), OreMinuti(offMin), (offMin/60) - InpBcmOffsetUTC);
   else
      verdetto = StringFormat("MISURATO a mercato APERTO. Delta reale %s = BCM %+d. ",
                              OreMinuti(offMin), (offMin/60) - InpBcmOffsetUTC);

   if(scartoMin == 0)
      verdetto += "COME PREVISTO: i 10 preset FTMO gia rimappati vanno bene cosi.";
   else
      verdetto += StringFormat("NON COME PREVISTO: i preset FTMO vanno spostati di %s (adesso sono su BCM %+d).",
                               OreMinuti(-scartoMin), InpDeltaAtteso);

   FileWrite(fh, "");
   FileWrite(fh, "[OROLOGIO]");
   FileWrite(fh, "Campo", "Valore", "Nota");
   FileWrite(fh, "OraServer_TimeTradeServer", TimeToString(srv,  TIME_DATE|TIME_SECONDS), "orologio CALCOLATO del server: vale anche a mercato chiuso. E QUESTO che misura il fuso.");
   FileWrite(fh, "OraServer_TimeCurrent",     TimeToString(tick, TIME_DATE|TIME_SECONDS), "ora dell ULTIMO TICK. Di domenica puo essere di VENERDI: NON usarla per il fuso.");
   FileWrite(fh, "OraGMT",                    TimeToString(gmt,  TIME_DATE|TIME_SECONDS), "UTC ricavato dall orologio di questo PC");
   FileWrite(fh, "OraLocalePC",               TimeToString(loc,  TIME_DATE|TIME_SECONDS), "orologio di Windows su questa macchina");
   FileWrite(fh, "MercatoAperto",             (aperto ? "SI" : "NO"), StringFormat("scarto TimeTradeServer-TimeCurrent = %d s", (int)gapTick));
   FileWrite(fh, "DeltaServerGMT_min",        (string)offMin,  "arrotondato a 15 min per togliere il jitter fra i due orologi");
   FileWrite(fh, "DeltaServerGMT_ore",        DoubleToString(offMin/60.0, 2), "positivo = server AVANTI rispetto a UTC");
   FileWrite(fh, "DeltaServerGMT_hhmm",       OreMinuti(offMin), "IL NUMERO DELLA CASELLA 1");
   FileWrite(fh, "DeltaLocalePC_UTC_hhmm",    OreMinuti(offLocMin), "fuso di Windows: se e sbagliato sono sbagliati TUTTI i numeri qui sopra");
   FileWrite(fh, "TimeGMTOffset_sec",         (string)TimeGMTOffset(), "controprova indipendente del fuso di Windows");
   FileWrite(fh, "Assunto_BCM_UTC",           StringFormat("%+d", InpBcmOffsetUTC), "NON misurato qui: e la regola di casa (ora italiana -1). Input InpBcmOffsetUTC.");
   FileWrite(fh, "Atteso_FTMO_UTC",           StringFormat("%+d", InpBcmOffsetUTC + InpDeltaAtteso), StringFormat("BCM %+d su cui sono rimappati i 10 preset", InpDeltaAtteso));
   FileWrite(fh, "Scarto_vs_atteso_hhmm",     OreMinuti(scartoMin), "ZERO = non si tocca niente");
   FileWrite(fh, "VERDETTO_OROLOGIO",         Pulisci(verdetto), "-");

   //================================================================
   // CASELLA 6 -- CONTO, SERVER, LEVA
   //================================================================
   long lev = AccountInfoInteger(ACCOUNT_LEVERAGE);
   FileWrite(fh, "");
   FileWrite(fh, "[CONTO]");
   FileWrite(fh, "Campo", "Valore", "Nota");
   FileWrite(fh, "Conto",       (string)AccountInfoInteger(ACCOUNT_LOGIN), "CONFRONTALO col numero della mail FTMO: se non coincide sei sul terminale sbagliato");
   FileWrite(fh, "Broker",      Pulisci(AccountInfoString(ACCOUNT_COMPANY)), "-");
   FileWrite(fh, "Server",      Pulisci(AccountInfoString(ACCOUNT_SERVER)),  "-");
   FileWrite(fh, "Intestatario",Pulisci(AccountInfoString(ACCOUNT_NAME)),    "-");
   FileWrite(fh, "TipoConto",   (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO ? "DEMO" : "REALE/CONTEST"), "-");
   FileWrite(fh, "Leva",        StringFormat("1:%d", (int)lev), "IL NUMERO DELLA CASELLA 6. Standard 1:100 o Swing 1:15?");
   FileWrite(fh, "Valuta",      Pulisci(AccountInfoString(ACCOUNT_CURRENCY)), "-");
   FileWrite(fh, "Saldo",       Num(AccountInfoDouble(ACCOUNT_BALANCE)), "-");
   FileWrite(fh, "Equity",      Num(AccountInfoDouble(ACCOUNT_EQUITY)),  "-");
   FileWrite(fh, "MargineLibero", Num(AccountInfoDouble(ACCOUNT_MARGIN_FREE)), "-");
   FileWrite(fh, "StopOutLivello", Num(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO)), "-");
   FileWrite(fh, "SimboliBroker", (string)SymbolsTotal(false), "tutto l albero del broker");
   FileWrite(fh, "SimboliMarketWatch", (string)SymbolsTotal(true), "solo quelli in finestra");
   FileWrite(fh, "SolaLettura", (InpSelezionaSimboli ? "NO: InpSelezionaSimboli=true ha AGGIUNTO simboli a Market Watch" : "SI: non ho toccato niente"), "-");

   //================================================================
   // CASELLE 2-3-4-5 -- I SIMBOLI
   //================================================================
   FileWrite(fh, "");
   FileWrite(fh, "[SIMBOLI]");
   FileWrite(fh, "Mercato","Simbolo","Stato","Descrizione","Digits","Point","TickSize","TickValue",
             "ContractSize","VolMin","VolMax","VolStep","Margine1Lotto","MargineIniziale","ValutaMargine",
             "StopsLevelPts","FreezeLevelPts","SpreadPts","SpreadTipo","ValutaProfitto","ModoCalcoloMargine",
             "ModoTrading","InMarketWatch","Bid","Ask","Percorso");

   int totale = SymbolsTotal(false);
   int trovatiPerMercato[5];
   for(int m = 0; m < 5; m++) trovatiPerMercato[m] = 0;

   //--- primo giro: conta (serve per sapere se un mercato e' ASSENTE
   //    PRIMA di scrivere le righe, cosi' l'ordine del file resta per
   //    mercato e non per indice di simbolo).
   for(int m = 0; m < 5; m++)
     {
      for(int i = 0; i < totale; i++)
        {
         string sym = SymbolName(i, false);
         if(DelMercato(Maiuscolo(sym), m)) trovatiPerMercato[m]++;
        }
     }

   int righeScritte = 0;
   int mercatiUnici = 0;
   int mercatiAssenti = 0;
   for(int m = 0; m < 5; m++)
     {
      if(trovatiPerMercato[m] == 0)
        {
         RigaSimbolo(fh, gMercatoNome[m], gMercatoNostro[m], "ASSENTE");
         righeScritte++;
         mercatiAssenti++;
         continue;
        }
      if(trovatiPerMercato[m] == 1) mercatiUnici++;

      for(int i = 0; i < totale; i++)
        {
         string sym = SymbolName(i, false);
         if(!DelMercato(Maiuscolo(sym), m)) continue;
         if(InpSelezionaSimboli && SymbolInfoInteger(sym, SYMBOL_SELECT) == 0)
            SymbolSelect(sym, true);
         RigaSimbolo(fh, gMercatoNome[m], sym,
                     (trovatiPerMercato[m] == 1 ? "TROVATO" : "CANDIDATO"));
         righeScritte++;
        }
     }

   //--- l'elenco grezzo, se richiesto: 12 nomi per riga per non fare
   //    righe chilometriche dentro il referto della sonda.
   if(InpTuttiISimboli)
     {
      FileWrite(fh, "");
      FileWrite(fh, "[UNIVERSO]");
      FileWrite(fh, StringFormat("tutti i %d simboli del broker, 12 per riga", totale));
      string acc = "";
      int q = 0;
      for(int i = 0; i < totale; i++)
        {
         acc += (q > 0 ? " " : "") + SymbolName(i, false);
         q++;
         if(q >= 12) { FileWrite(fh, Pulisci(acc)); acc = ""; q = 0; }
        }
      if(q > 0) FileWrite(fh, Pulisci(acc));
     }

   FileWrite(fh, "");
   FileWrite(fh, "[FINE]", StringFormat("righe simbolo: %d", righeScritte),
             StringFormat("mercati con candidato unico: %d/5", mercatiUnici),
             StringFormat("mercati ASSENTI: %d/5", mercatiAssenti));
   FileClose(fh);

   //================================================================
   // IL RIASSUNTO IN CONSOLE -- TRE RIGHE, come da mandato.
   //================================================================
   Print(StringFormat("PREVOLO SPECIFICHE 1/3  OROLOGIO: server %s = UTC%s (misurato con TimeTradeServer, mercato %s). Atteso UTC%+d -> scarto %s.",
                      TimeToString(srv, TIME_DATE|TIME_MINUTES), OreMinuti(offMin),
                      (aperto ? "APERTO" : "FERMO"), InpBcmOffsetUTC + InpDeltaAtteso, OreMinuti(scartoMin)));
   Print(StringFormat("PREVOLO SPECIFICHE 2/3  CONTO %d su %s, leva 1:%d, %s %s. Simboli broker %d, Market Watch %d.",
                      (int)AccountInfoInteger(ACCOUNT_LOGIN), AccountInfoString(ACCOUNT_SERVER),
                      (int)lev, Num(AccountInfoDouble(ACCOUNT_BALANCE)), AccountInfoString(ACCOUNT_CURRENCY),
                      totale, SymbolsTotal(true)));
   Print(StringFormat("PREVOLO SPECIFICHE 3/3  SIMBOLI: %d righe scritte, %d/5 mercati con candidato unico, %d/5 ASSENTI. File MQL5\\Files\\%s (%d ms). SOLA LETTURA: nessun ordine inviato.",
                      righeScritte, mercatiUnici, mercatiAssenti, ABTG_FILE_SPEC, (int)(GetTickCount() - t0)));
  }
//+------------------------------------------------------------------+
