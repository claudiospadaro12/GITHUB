//+------------------------------------------------------------------+
//|                                           ABTG_StopManuale.mq5   |
//|                                                                  |
//|  GUARDIA DELLO STOP PER LE OPERAZIONI MANUALI                    |
//|                                                                  |
//|  Richiesta di Claudio (25/09/2026), testuale:                    |
//|   "un EA semi automatico che si attiva appena entro io a mercato |
//|    e stoppa gli ordini non appena gli ordini vanno sotto di 2    |
//|    pip x esempio"                                                |
//|                                                                  |
//|  COSA FA                                                         |
//|   - Sorveglia le posizioni aperte A MANO (magic 0) sul simbolo   |
//|     del grafico (opzione: tutti i simboli).                      |
//|   - Appena ne vede una senza SL, o con uno SL piu' largo della   |
//|     distanza N, mette lo SL SUL SERVER a ingresso - N (BUY) /    |
//|     ingresso + N (SELL). Lo stop sul server resta anche se il    |
//|     VPS o il terminale si spengono.                              |
//|   - Stop virtuale di riserva: se lo SL sul server non c'e' (o e' |
//|     piu' largo di N per il minimo del broker) chiude a mercato   |
//|     quando il prezzo supera la soglia (Bid per BUY, Ask per SELL)|
//|   - Opzionali, spenti di default: TP, breakeven, trailing, SL    |
//|     sugli ordini pendenti.                                       |
//|                                                                  |
//|  COSA NON FA, MAI                                                |
//|   - NON APRE OPERAZIONI. Nel codice non esiste nessuna chiamata  |
//|     Buy/Sell/OrderOpen: solo PositionModify, PositionClose,      |
//|     OrderModify.                                                 |
//|   - Non allarga mai uno SL gia' piu' stretto (tuo, o breakeven). |
//|   - Non tocca le posizioni degli EA (magic diverso da 0), ne'    |
//|     quelle con magic in InpIgnoreMagics.                         |
//|   - Non tocca gli ordini pendenti, salvo InpAlsoPendings=true.   |
//|                                                                  |
//|  DOVE VA                                                         |
//|   Pensato per il conto DEMO MANUALE 50503635 (C:\MT5_MANUALE).   |
//|   Dove attaccarlo lo decide Claudio. Sul conto REALE 10105439    |
//|   l'EA RIFIUTA DI PARTIRE (blocco in OnInit): serve la firma di  |
//|   Claudio, e allora si toglie il blocco e si ricompila.          |
//|                                                                  |
//|  LEZIONE DI CASA APPLICATA (modify a raffica, 25/09/2026)        |
//|   Mai ritentare la stessa modifica rifiutata a ogni tick: dopo   |
//|   un rifiuto si aspetta InpBackoffSec (30 s), poi l'attesa       |
//|   RADDOPPIA a ogni rifiuto di fila fino a 15 min (si azzera al   |
//|   primo successo) e si logga UNA volta; in piu' tetto di         |
//|   InpMaxModifyPerMin modifiche al minuto per posizione. E mai    |
//|   uno stop dal lato sbagliato del prezzo: ogni SL viene          |
//|   confrontato col Bid/Ask PRIMA di spedirlo.                     |
//|   Solo conti HEDGING: in netting l'EA rifiuta di partire.        |
//|                                                                  |
//|  Scritto il 25/09/2026. NON COMPILATO in questo ambiente (niente |
//|  MetaEditor): va compilato e provato su DEMO prima di tutto.     |
//|                                                                  |
//|  1.01 (25/09/2026) - correzioni del cancello:                    |
//|   D1 back-off con raddoppio (modify: 30 s -> 15 min; chiusura:   |
//|      2 s -> 60 s per rifiuti di prezzo, 60 s -> 15 min per gli   |
//|      altri, es. mercato chiuso), azzerato al successo.           |
//|   D2 pendente con SL gia' piu' stretto del minimo del broker:    |
//|      non lo allarga piu' (prima lo portava al minimo).           |
//|   D3 guardia spread: ricontrolla a ogni tick (log ogni 60 s),    |
//|      Alert alla prima volta, riga "!!! N POSIZIONI SENZA STOP"   |
//|      sul grafico, avviso in OnInit se N non supera lo spread.    |
//|   D4 solo conti HEDGING: in netting l'EA non parte.              |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.02"
#property description "Guardia dello stop per le operazioni MANUALI. NON apre mai operazioni."
#property description "SL sul server a ingresso -/+ N, stop virtuale di riserva, log [STOPMANUALE]."

#include <Trade\Trade.mqh>

//==================================================================
// COSTANTI
//==================================================================
#define SM_PREFISSO          "[STOPMANUALE] "
#define SM_CONTO_REALE       10105439      // conto REALE: l'EA non parte (firma di Claudio)
#define SM_TIMER_MS          250           // scansione anche senza tick (serve per ALL_SYMBOLS)
#define SM_BACKOFF_CLOSE_MS  2000          // attesa dopo una chiusura a mercato rifiutata
#define SM_LOG_RIPETI_MS     300000        // stesso rifiuto: si riscrive nel log al massimo ogni 5 min
#define SM_GUARDIA_RIPROVA_MS 60000        // simbolo bloccato dalla guardia spread: si riscrive nel log ogni 60 s
#define SM_BACKOFF_MAX_S     900           // tetto del back-off con raddoppio: 15 minuti

//==================================================================
// ENUM
//==================================================================
enum ENUM_SM_UNITA
  {
   SM_PIPS   = 0,   // PIPS
   SM_POINTS = 1    // POINTS (punti MT5)
  };

enum ENUM_SM_PERIMETRO
  {
   SM_CHART_ONLY  = 0, // CHART_ONLY (solo il simbolo del grafico)
   SM_ALL_SYMBOLS = 1  // ALL_SYMBOLS (tutti i simboli del conto)
  };

//==================================================================
// INPUT
//==================================================================
input group "=== Distanza dello stop ==="
input double            InpStopPips      = 2.0;      // Distanza stop N (nell'unita' di InpUnit)
input ENUM_SM_UNITA     InpUnit          = SM_PIPS;  // Unita' di N: PIPS o POINTS (punti MT5)
input int               InpPipPoints     = 0;        // Punti per 1 pip. 0=auto: Digits 3/5 -> 10; Digits 2/4 e altri -> 1 (INDICI/ORO a 2 decimali: 1 pip = 1 punto = 0.01!)

input group "=== Cosa fa ==="
input bool              InpServerSL      = true;     // Mette lo SL sul server del broker (resta anche a VPS spento)
input bool              InpSoftStop      = true;     // Stop virtuale di riserva: chiude a mercato se lo SL sul server manca o e' piu' largo di N
input bool              InpSpreadGuard   = true;     // Blocca il simbolo se N <= spread (chiuderebbe ogni operazione per il solo spread)
input bool              InpCloseOnAttach = false;    // Posizione GIA' oltre la soglia quando l'EA parte: false=la segnala e non la chiude
input double            InpTakePips      = 0.0;      // TP a N (stessa unita'), messo solo se il TP manca. 0 = spento
input double            InpBEPips        = 0.0;      // Breakeven: SL a pareggio dopo +N (stessa unita'). 0 = spento
input double            InpTrailPips     = 0.0;      // Trailing: distanza dal prezzo (stessa unita'). 0 = spento
input double            InpTrailStartPips= 0.0;      // Trailing: parte dopo +N di guadagno (stessa unita')
input double            InpTrailStepPips = 1.0;      // Trailing: sposta solo se migliora di almeno N (stessa unita')

input group "=== Perimetro ==="
input ENUM_SM_PERIMETRO InpSymbolScope   = SM_CHART_ONLY; // Simboli sorvegliati
input bool              InpOnlyManual    = true;     // true = SOLO magic 0 (operazioni a mano). false = tutte le magic non in lista
input string            InpIgnoreMagics  = "";       // Magic da NON toccare MAI, separate da virgola (es. 770101,771531)
input bool              InpAlsoPendings  = false;    // Mette SL (e TP) anche sugli ordini pendenti manuali

input group "=== Sicurezza ==="
input int               InpDeviationPts  = 50;       // Scostamento massimo sulle chiusure a mercato (punti MT5)
input int               InpBackoffSec    = 30;       // Dopo una modifica rifiutata: attesa prima di riprovare (s)
input int               InpMaxModifyPerMin = 4;      // Tetto modifiche per posizione al minuto
input long              InpMagic         = 779900;   // Magic dell'EA: NON apre ordini, marca solo le sue chiusure
input bool              InpVerbose       = false;    // Log dettagliato

//==================================================================
// STATO PER TICKET (back-off e tetto). Si ricostruisce da solo:
// dopo un riavvio parte vuoto, e la scansione rifa' tutto dai dati
// del server (nessuno stato che si rompe al riavvio).
//==================================================================
struct SMStato
  {
   ulong             ticket;
   ulong             nextModMs;    // prima modifica consentita (back-off dopo un rifiuto)
   ulong             nextCloseMs;  // prima chiusura consentita (back-off dopo un rifiuto)
   ulong             winStartMs;   // inizio della finestra di 60 s del tetto modifiche
   int               winCount;     // modifiche tentate nella finestra
   bool              capLogged;    // tetto gia' segnalato in questa finestra
   uint              lastRet;      // ultimo retcode scritto nel log
   ulong             lastLogMs;    // ora dell'ultimo log di rifiuto
   ulong             lastInfoMs;   // ora dell'ultimo log informativo (anti-ripetizione)
   int               modFails;     // modifiche rifiutate di fila (back-off con raddoppio)
   int               closeFails;   // chiusure a mercato rifiutate di fila (back-off con raddoppio)
  };

CTrade   g_trade;
SMStato  g_st[];
long     g_ignora[];               // magic da ignorare (lista parsata)
ulong    g_preesistenti[];         // posizioni gia' oltre la soglia all'avvio (non si chiudono)
string   g_guardSym[];             // guardia spread: simbolo
bool     g_guardOk[];              //                 esito
ulong    g_guardNextMs[];          //                 prossimo ricontrollo se bloccato

bool     g_tradeOk      = false;
ulong    g_tradeLogMs   = 0;
ulong    g_pruneMs      = 0;
int      g_nPos         = 0;
int      g_nPend        = 0;
int      g_nBloccate    = 0;
int      g_nPreesist    = 0;
string   g_ultima       = "nessuna";

void UpdateComment();   // prototipo: chiamata da Scan() prima della definizione

//==================================================================
// LOG
//==================================================================
void Log(const string s)  { Print(SM_PREFISSO, s); }
void LogV(const string s) { if(InpVerbose) Print(SM_PREFISSO, s); }

void Azione(const string s)
  {
   g_ultima = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS) + "  " + s;
   Log(s);
  }

//==================================================================
// UNITA': pip, punti, prezzo
//------------------------------------------------------------------
// Pip "robusto" per simbolo: Digits 3 e 5 (forex quotato col decimale
// frazionario) -> 1 pip = 10 punti; Digits 2 e 4, e ogni altro caso
// (indici, CFD, oro a 2 decimali) -> 1 pip = 1 punto. Su un indice a 2
// decimali 1 punto e' 0.01: "2 pip" vuol dire 0.02, DENTRO lo spread.
// Per questo esiste InpPipPoints (forzatura) e la guardia spread.
//==================================================================
int PipPoints(const string sym)
  {
   if(InpPipPoints > 0)
      return InpPipPoints;
   int dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   if(dg == 3 || dg == 5)
      return 10;
   return 1;
  }

// Converte un valore nell'unita' di InpUnit in distanza di PREZZO.
double DistPrice(const string sym, const double valore)
  {
   double pt = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(pt <= 0.0 || valore <= 0.0)
      return 0.0;
   double punti = (InpUnit == SM_PIPS) ? valore * PipPoints(sym) : valore;
   return punti * pt;
  }

double PassoPrezzo(const string sym)
  {
   double ts = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   if(ts <= 0.0)
      ts = SymbolInfoDouble(sym, SYMBOL_POINT);
   return ts;
  }

// Arrotonda al passo di prezzo VERSO IL BASSO e normalizza ai Digits.
double RoundDown(const string sym, const double prezzo)
  {
   double ts = PassoPrezzo(sym);
   int    dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   if(ts <= 0.0)
      return NormalizeDouble(prezzo, dg);
   return NormalizeDouble(MathFloor(prezzo / ts + 1e-7) * ts, dg);
  }

// Arrotonda al passo di prezzo VERSO L'ALTO e normalizza ai Digits.
double RoundUp(const string sym, const double prezzo)
  {
   double ts = PassoPrezzo(sym);
   int    dg = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   if(ts <= 0.0)
      return NormalizeDouble(prezzo, dg);
   return NormalizeDouble(MathCeil(prezzo / ts - 1e-7) * ts, dg);
  }

// Distanza minima dal prezzo per un NUOVO SL/TP: max(stops level,
// freeze level) + 1 punto. Il +1 evita lo stop "attaccato" al prezzo,
// che il server rifiuta o fa scattare subito (con stops level 0 lo SL
// deve comunque stare STRETTAMENTE sotto il Bid / sopra l'Ask).
double MinDistPrice(const string sym)
  {
   double pt  = SymbolInfoDouble(sym, SYMBOL_POINT);
   long   stp = SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   long   frz = SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL);
   long   mx  = MathMax(stp, frz);
   return (double)(mx + 1) * pt;
  }

string Px(const string sym, const double p)
  {
   return DoubleToString(p, (int)SymbolInfoInteger(sym, SYMBOL_DIGITS));
  }

//==================================================================
// PERIMETRO: simbolo e magic
//==================================================================
bool SymbolInScope(const string sym)
  {
   if(InpSymbolScope == SM_ALL_SYMBOLS)
      return true;
   return (sym == _Symbol);
  }

bool MagicIgnorata(const long magic)
  {
   for(int i = 0; i < ArraySize(g_ignora); i++)
      if(g_ignora[i] == magic)
         return true;
   return false;
  }

bool MagicAllowed(const long magic)
  {
   if(MagicIgnorata(magic))
      return false;
   if(InpOnlyManual)
      return (magic == 0);
   return true;
  }

// Lista magic: SOLO cifre separate da virgola. Un refuso non deve
// trasformarsi in "0" e far toccare una sedia: si rifiuta di partire.
bool ParseIgnore()
  {
   ArrayResize(g_ignora, 0);
   string s = InpIgnoreMagics;
   StringTrimLeft(s);
   StringTrimRight(s);
   if(s == "")
      return true;
   string parti[];
   int n = StringSplit(s, ',', parti);
   for(int i = 0; i < n; i++)
     {
      string p = parti[i];
      StringTrimLeft(p);
      StringTrimRight(p);
      if(p == "")
         continue;
      for(int c = 0; c < StringLen(p); c++)
        {
         ushort ch = StringGetCharacter(p, c);
         if(ch < '0' || ch > '9')
           {
            Log("InpIgnoreMagics NON VALIDO: '" + p + "' non e' un numero. L'EA non parte.");
            return false;
           }
        }
      int k = ArraySize(g_ignora);
      ArrayResize(g_ignora, k + 1);
      g_ignora[k] = StringToInteger(p);
     }
   return true;
  }

//==================================================================
// TRADING CONSENTITO
//==================================================================
bool TradingAllowed()
  {
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
      return false;
   if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
      return false;
   if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))
      return false;
   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
      return false;
   return true;
  }

//==================================================================
// STATO PER TICKET
//==================================================================
int StIdx(const ulong ticket)
  {
   int n = ArraySize(g_st);
   for(int i = 0; i < n; i++)
      if(g_st[i].ticket == ticket)
         return i;
   ArrayResize(g_st, n + 1);
   g_st[n].ticket      = ticket;
   g_st[n].nextModMs   = 0;
   g_st[n].nextCloseMs = 0;
   g_st[n].winStartMs  = 0;
   g_st[n].winCount    = 0;
   g_st[n].capLogged   = false;
   g_st[n].lastRet     = 0;
   g_st[n].lastLogMs   = 0;
   g_st[n].lastInfoMs  = 0;
   g_st[n].modFails    = 0;
   g_st[n].closeFails  = 0;
   return n;
  }

// Toglie dalla memoria i ticket che non esistono piu' (ne' posizione
// ne' ordine pendente). Solo pulizia: non cambia nessuna decisione.
void StPrune()
  {
   int n = ArraySize(g_st);
   for(int i = n - 1; i >= 0; i--)
     {
      ulong t = g_st[i].ticket;
      bool vivo = PositionSelectByTicket(t) || OrderSelect(t);
      if(!vivo)
        {
         int last = ArraySize(g_st) - 1;
         if(i != last)
            g_st[i] = g_st[last];
         ArrayResize(g_st, last);
        }
     }
  }

// Log informativo con anti-ripetizione (una volta ogni 5 min per ticket).
void InfoOnce(const ulong ticket, const string s)
  {
   int   i   = StIdx(ticket);
   ulong now = GetTickCount64();
   if(g_st[i].lastInfoMs == 0 || now - g_st[i].lastInfoMs >= SM_LOG_RIPETI_MS)
     {
      g_st[i].lastInfoMs = now;
      Log(s);
     }
  }

// Puo' partire una modifica per questo ticket? Rispetta back-off e tetto.
bool CanModify(const ulong ticket)
  {
   int   i   = StIdx(ticket);
   ulong now = GetTickCount64();
   if(now < g_st[i].nextModMs)
      return false;
   if(g_st[i].winStartMs == 0 || now - g_st[i].winStartMs >= 60000)
     {
      g_st[i].winStartMs = now;
      g_st[i].winCount   = 0;
      g_st[i].capLogged  = false;
     }
   if(g_st[i].winCount >= InpMaxModifyPerMin)
     {
      if(!g_st[i].capLogged)
        {
         g_st[i].capLogged = true;
         Log(StringFormat("TETTO: ticket %I64u ha gia' %d modifiche in questo minuto. Mi fermo fino alla fine della finestra.",
                          ticket, g_st[i].winCount));
        }
      return false;
     }
   g_st[i].winCount++;
   return true;
  }

// Back-off con raddoppio: baseMs al primo rifiuto, poi x2 a ogni rifiuto
// di fila, mai oltre maxMs. Un rifiuto che non cambia (mercato chiuso,
// stop invalido) non deve generare una richiesta ogni 30 s per ore.
ulong BackoffMs(const ulong baseMs, const int fails, const ulong maxMs)
  {
   ulong w = baseMs;
   for(int k = 1; k < fails && w < maxMs; k++)
      w *= 2;
   return (w > maxMs ? maxMs : w);
  }

void NoteModifyFailure(const ulong ticket, const uint rc, const string cosa)
  {
   int   i   = StIdx(ticket);
   ulong now = GetTickCount64();
   g_st[i].modFails++;
   ulong w = BackoffMs((ulong)InpBackoffSec * 1000, g_st[i].modFails, (ulong)SM_BACKOFF_MAX_S * 1000);
   g_st[i].nextModMs = now + w;
   if(rc != g_st[i].lastRet || g_st[i].lastLogMs == 0 || now - g_st[i].lastLogMs >= SM_LOG_RIPETI_MS)
     {
      g_st[i].lastRet   = rc;
      g_st[i].lastLogMs = now;
      Log(StringFormat("RIFIUTATA %s ticket %I64u: retcode %u (%s). Rifiuto n.%d di fila: riprovo fra %I64u s.",
                       cosa, ticket, rc, g_trade.ResultRetcodeDescription(), g_st[i].modFails, w / 1000));
     }
  }

//==================================================================
// GUARDIA SPREAD (per simbolo)
//------------------------------------------------------------------
// Se N <= spread la regola "chiudi appena va sotto di N" chiude OGNI
// operazione subito, per il solo spread: e' quasi sempre un'unita'
// sbagliata (es. 2 pip = 0.02 sul DAX a 2 decimali). Il simbolo resta
// fermo (nessuno SL, nessuna chiusura) e si ricontrolla a ogni tick; il
// log si riscrive ogni 60 s, e alla prima volta parte un Alert (1.01).
// Una volta passato, non si ricontrolla piu' in questa sessione: cosi'
// un allargamento dello spread durante una notizia NON spegne la
// protezione di una posizione gia' aperta.
//==================================================================
bool GuardOk(const string sym, const double D, const MqlTick &tk)
  {
   if(!InpSpreadGuard)
      return true;
   int n = ArraySize(g_guardSym);
   int k = -1;
   for(int i = 0; i < n; i++)
      if(g_guardSym[i] == sym)
        {
         k = i;
         break;
        }
   ulong now = GetTickCount64();
   if(k >= 0)
     {
      if(g_guardOk[k])
         return true;
     }
   else
     {
      k = n;
      ArrayResize(g_guardSym, n + 1);
      ArrayResize(g_guardOk, n + 1);
      ArrayResize(g_guardNextMs, n + 1);
      g_guardSym[k]    = sym;
      g_guardOk[k]     = false;
      g_guardNextMs[k] = 0;
     }
   double spread = tk.ask - tk.bid;
   double pt     = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(spread <= 0.0) return false;   // tick anomalo (ask<=bid): non si sblocca su un campione senza spread (cancello 1.01, R1)
   if(D > spread)
     {
      if(g_guardNextMs[k] != 0)
         Log(StringFormat("GUARDIA SPREAD superata su %s: N=%s > spread %s. Riprendo a proteggere.",
                          sym, Px(sym, D), Px(sym, spread)));
      g_guardOk[k] = true;
      return true;
     }
   g_guardOk[k] = false;
   if(now >= g_guardNextMs[k])
     {
      bool primo = (g_guardNextMs[k] == 0);
      g_guardNextMs[k] = now + SM_GUARDIA_RIPROVA_MS;
      Log(StringFormat("GUARDIA SPREAD: su %s N = %s (%.0f punti) NON supera lo spread %s (%.0f punti). "
                       "La regola chiuderebbe ogni operazione per il solo spread: NON agisco su %s. "
                       "Controlla InpUnit / InpPipPoints (1 pip qui = %d punti). Ricontrollo a ogni tick, riscrivo fra 60 s.",
                       sym, Px(sym, D), (pt > 0 ? D / pt : 0.0), Px(sym, spread), (pt > 0 ? spread / pt : 0.0),
                       sym, PipPoints(sym)));
      if(primo)
         Alert(SM_PREFISSO + "GUARDIA SPREAD su " + sym + ": la posizione NON ha stop (N dentro lo spread). Vedi Esperti.");
     }
   return false;
  }

//==================================================================
// POSIZIONI PREESISTENTI GIA' OLTRE LA SOGLIA
//------------------------------------------------------------------
// Attaccare l'EA non deve chiudere di colpo una posizione che Claudio
// sta tenendo apposta sotto di 50 pip. All'avvio si segnano quelle gia'
// oltre la soglia: non si chiudono e non si mette uno SL (sarebbe dal
// lato sbagliato del prezzo). Se il prezzo rientra sopra la soglia,
// escono dall'elenco e vengono protette come tutte le altre.
// Con InpCloseOnAttach=true l'elenco resta vuoto e si chiudono subito.
//==================================================================
int PreIdx(const ulong ticket)
  {
   for(int i = 0; i < ArraySize(g_preesistenti); i++)
      if(g_preesistenti[i] == ticket)
         return i;
   return -1;
  }

void PreDel(const int i)
  {
   int last = ArraySize(g_preesistenti) - 1;
   if(i < 0 || i > last)
      return;
   if(i != last)
      g_preesistenti[i] = g_preesistenti[last];
   ArrayResize(g_preesistenti, last);
  }

void InitPreesistenti()
  {
   ArrayResize(g_preesistenti, 0);
   if(InpCloseOnAttach)
      return;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t))
         continue;
      string sym = PositionGetString(POSITION_SYMBOL);
      if(!SymbolInScope(sym) || !MagicAllowed(PositionGetInteger(POSITION_MAGIC)))
         continue;
      MqlTick tk;
      if(!SymbolInfoTick(sym, tk) || tk.bid <= 0.0 || tk.ask <= 0.0)
         continue;
      double D = DistPrice(sym, InpStopPips);
      if(D <= 0.0)
         continue;
      bool   isBuy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      double thr   = isBuy ? RoundDown(sym, entry - D) : RoundUp(sym, entry + D);
      bool   oltre = isBuy ? (tk.bid <= thr) : (tk.ask >= thr);
      if(!oltre)
         continue;
      int k = ArraySize(g_preesistenti);
      ArrayResize(g_preesistenti, k + 1);
      g_preesistenti[k] = t;
      Log(StringFormat("PREESISTENTE: ticket %I64u %s %s ingresso %s e' GIA' oltre la soglia %s all'avvio. "
                       "NON la chiudo (InpCloseOnAttach=false): decidi tu. La proteggo se rientra sopra la soglia.",
                       t, sym, (isBuy ? "BUY" : "SELL"), Px(sym, entry), Px(sym, thr)));
     }
  }

//==================================================================
// STOP VIRTUALE: chiusura a mercato
//==================================================================
void SoftClose(const ulong ticket, const string sym, const bool isBuy,
               const double entry, const double thr, const double px)
  {
   if(!g_tradeOk)
      return;
   int   i   = StIdx(ticket);
   ulong now = GetTickCount64();
   if(now < g_st[i].nextCloseMs)
      return;
   g_trade.SetTypeFillingBySymbol(sym);
   bool ok = g_trade.PositionClose(ticket);
   uint rc = g_trade.ResultRetcode();
   if(ok && (rc == TRADE_RETCODE_DONE || rc == TRADE_RETCODE_DONE_PARTIAL || rc == TRADE_RETCODE_PLACED))
     {
      g_st[i].closeFails = 0;
      g_st[i].nextCloseMs = now + SM_BACKOFF_CLOSE_MS;   // la chiusura puo' essere ancora in volo: niente secondo close al tick dopo (cancello 1.01, R2)
      Azione(StringFormat("STOP VIRTUALE: chiusa a mercato %s ticket %I64u %s ingresso %s, soglia %s, prezzo %s (retcode %u)",
                          sym, ticket, (isBuy ? "BUY" : "SELL"), Px(sym, entry), Px(sym, thr), Px(sym, px), rc));
      return;
     }
   if(rc == TRADE_RETCODE_POSITION_CLOSED)
     {
      LogV(StringFormat("ticket %I64u gia' chiuso dal server (SL scattato prima di me).", ticket));
      return;
     }
   // Back-off con raddoppio: i rifiuti di PREZZO sono transitori (2 s -> 60 s),
   // gli altri (es. mercato chiuso) no: 60 s -> 15 min, niente raffica per ore.
   g_st[i].closeFails++;
   bool transitorio = (rc == TRADE_RETCODE_REQUOTE || rc == TRADE_RETCODE_PRICE_CHANGED || rc == TRADE_RETCODE_PRICE_OFF);
   ulong w = transitorio ? BackoffMs(SM_BACKOFF_CLOSE_MS, g_st[i].closeFails, 60000)
                         : BackoffMs(60000, g_st[i].closeFails, (ulong)SM_BACKOFF_MAX_S * 1000);
   g_st[i].nextCloseMs = now + w;
   if(rc != g_st[i].lastRet || g_st[i].lastLogMs == 0 || now - g_st[i].lastLogMs >= SM_LOG_RIPETI_MS)
     {
      g_st[i].lastRet   = rc;
      g_st[i].lastLogMs = now;
      Log(StringFormat("RIFIUTATA chiusura a mercato ticket %I64u %s: retcode %u (%s). Riprovo fra %I64u s.",
                       ticket, sym, rc, g_trade.ResultRetcodeDescription(), w / 1000));
     }
  }

//==================================================================
// GESTIONE DI UNA POSIZIONE
//==================================================================
void ManagePosition(const ulong ticket)
  {
   if(!PositionSelectByTicket(ticket))
      return;
   string sym   = PositionGetString(POSITION_SYMBOL);
   long   magic = PositionGetInteger(POSITION_MAGIC);
   if(!SymbolInScope(sym) || !MagicAllowed(magic))
      return;
   g_nPos++;

   bool   isBuy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
   double entry = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl    = PositionGetDouble(POSITION_SL);
   double tp    = PositionGetDouble(POSITION_TP);

   MqlTick tk;
   if(!SymbolInfoTick(sym, tk) || tk.bid <= 0.0 || tk.ask <= 0.0)
      return;
   double pt = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(pt <= 0.0)
      return;
   double D = DistPrice(sym, InpStopPips);
   if(D <= 0.0)
      return;
   if(!GuardOk(sym, D, tk))
     {
      g_nBloccate++;
      return;
     }

   // Soglia: BUY ingresso-N (arrotondata in basso), SELL ingresso+N (in alto).
   // Il prezzo che chiude la posizione: Bid per BUY, Ask per SELL.
   double thr   = isBuy ? RoundDown(sym, entry - D) : RoundUp(sym, entry + D);
   double px    = isBuy ? tk.bid : tk.ask;
   bool   oltre = isBuy ? (px <= thr) : (px >= thr);

   int pIdx = PreIdx(ticket);
   if(pIdx >= 0)
     {
      if(oltre)
        {
         g_nPreesist++;
         return;
        }
      PreDel(pIdx);
      Log(StringFormat("PREESISTENTE ticket %I64u rientrata sopra la soglia %s: da ora la proteggo.", ticket, Px(sym, thr)));
     }

   // Lo SL sul server fa gia' il lavoro? (a soglia o piu' stretto, entro 1 punto)
   bool slCopre = (sl > 0.0) && (isBuy ? (sl >= thr - pt) : (sl <= thr + pt));

   if(!g_tradeOk)
      return;

   // 1) STOP VIRTUALE: soglia superata e nessuno SL sul server che la copra.
   if(InpSoftStop && oltre && !slCopre)
     {
      SoftClose(ticket, sym, isBuy, entry, thr, px);
      return;
     }

   // 2) SL SUL SERVER (+ BE, trailing, TP) -- mai dal lato sbagliato del prezzo.
   int    stpLv = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   int    frzLv = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL);
   double minD  = MinDistPrice(sym);
   // lim = lo SL piu' vicino al prezzo che il broker accetta adesso
   double lim   = isBuy ? RoundDown(sym, tk.bid - minD) : RoundUp(sym, tk.ask + minD);
   double newSL = sl;
   double newTP = tp;
   string motivo = "";

   if(InpServerSL && !slCopre)
     {
      bool piazzabile = isBuy ? (thr <= lim) : (thr >= lim);
      if(piazzabile)
        {
         newSL  = thr;
         motivo = StringFormat("SL a %s (ingresso %s %s N)", Px(sym, thr), Px(sym, entry), (isBuy ? "-" : "+"));
        }
      else if(sl <= 0.0)
        {
         // Nessuno SL e la soglia non si puo' piazzare: metto lo SL al minimo
         // consentito e LO DICO. Lo stop virtuale resta sulla soglia esatta.
         newSL  = lim;
         motivo = StringFormat("SL ALLARGATO al minimo consentito: richiesto %s, messo %s "
                               "(stops level %d punti, freeze level %d punti, %s). Lo stop virtuale resta a %s.",
                               Px(sym, thr), Px(sym, lim), stpLv, frzLv,
                               (oltre ? "prezzo gia' oltre la soglia" : "soglia troppo vicina al prezzo"),
                               Px(sym, thr));
        }
      else
        {
         // SL esistente piu' largo e soglia non piazzabile ora: NON inseguo il
         // prezzo con una modifica a ogni tick. Riprovo quando torna piazzabile.
         InfoOnce(ticket, StringFormat("ticket %I64u %s: SL attuale %s piu' largo della soglia %s, ma la soglia ora e' "
                                       "troppo vicina al prezzo (minimo broker %d punti). Lo lascio, lo stop virtuale copre la soglia.",
                                       ticket, sym, Px(sym, sl), Px(sym, thr), (int)MathRound(minD / pt)));
        }
     }

   double guadagno = isBuy ? (tk.bid - entry) : (entry - tk.ask);

   // Breakeven (spento di default)
   if(InpBEPips > 0.0)
     {
      double be   = DistPrice(sym, InpBEPips);
      double cand = isBuy ? RoundUp(sym, entry) : RoundDown(sym, entry);
      bool migliora = (newSL <= 0.0) || (isBuy ? (cand > newSL + pt * 0.5) : (cand < newSL - pt * 0.5));
      bool valido   = isBuy ? (cand <= lim) : (cand >= lim);
      if(guadagno >= be && migliora && valido)
        {
         newSL  = cand;
         motivo = StringFormat("BREAKEVEN: SL a %s dopo +%s", Px(sym, cand), Px(sym, guadagno));
        }
     }

   // Trailing (spento di default): muove solo a favore, a passi di almeno InpTrailStepPips.
   if(InpTrailPips > 0.0)
     {
      double tr   = DistPrice(sym, InpTrailPips);
      double st   = DistPrice(sym, InpTrailStartPips);
      double step = MathMax(pt, DistPrice(sym, InpTrailStepPips));
      if(guadagno >= st)
        {
         double cand = isBuy ? RoundDown(sym, tk.bid - tr) : RoundUp(sym, tk.ask + tr);
         bool migliora = (newSL <= 0.0) || (isBuy ? (cand >= newSL + step) : (cand <= newSL - step));
         bool valido   = isBuy ? (cand <= lim) : (cand >= lim);
         if(migliora && valido)
           {
            newSL  = cand;
            motivo = StringFormat("TRAILING: SL a %s", Px(sym, cand));
           }
        }
     }

   // TP (spento di default): solo se manca, mai sopra un TP tuo.
   if(InpTakePips > 0.0 && tp <= 0.0)
     {
      double T     = DistPrice(sym, InpTakePips);
      double cand  = isBuy ? RoundUp(sym, entry + T) : RoundDown(sym, entry - T);
      double limTP = isBuy ? RoundUp(sym, tk.bid + minD) : RoundDown(sym, tk.ask - minD);
      bool   valido = isBuy ? (cand >= limTP) : (cand <= limTP);
      if(valido)
        {
         newTP  = cand;
         motivo = (motivo == "" ? "" : motivo + " + ") + StringFormat("TP a %s", Px(sym, cand));
        }
      else
         InfoOnce(ticket, StringFormat("ticket %I64u %s: TP %s non piazzabile (prezzo gia' oltre o troppo vicino). Non lo metto.",
                                       ticket, sym, Px(sym, cand)));
     }

   bool cambiaSL = (MathAbs(newSL - sl) >= pt * 0.5);
   bool cambiaTP = (MathAbs(newTP - tp) >= pt * 0.5);
   if(!cambiaSL && !cambiaTP)
      return;

   // Freeze level: se il prezzo e' troppo vicino allo SL/TP esistente il
   // server rifiuta QUALSIASI modifica. Non si spedisce.
   if(frzLv > 0)
     {
      double fz = frzLv * pt;
      if((sl > 0.0 && MathAbs(px - sl) <= fz) || (tp > 0.0 && MathAbs(px - tp) <= fz))
        {
         InfoOnce(ticket, StringFormat("ticket %I64u %s: SL/TP dentro il freeze level (%d punti), modifica rimandata.",
                                       ticket, sym, frzLv));
         return;
        }
     }

   if(!CanModify(ticket))
      return;
   bool ok = g_trade.PositionModify(ticket, newSL, newTP);
   uint rc = g_trade.ResultRetcode();
   if(ok && rc == TRADE_RETCODE_DONE)
     {
      g_st[StIdx(ticket)].modFails = 0;
      Azione(StringFormat("%s ticket %I64u %s: %s", sym, ticket, (isBuy ? "BUY" : "SELL"), motivo));
      return;
     }
   if(rc == TRADE_RETCODE_NO_CHANGES)
     {
      g_st[StIdx(ticket)].modFails = 0;
      LogV(StringFormat("ticket %I64u: il server dice 'nessuna modifica' (gia' a posto).", ticket));
      return;
     }
   NoteModifyFailure(ticket, rc, StringFormat("modifica SL/TP (%s)", motivo));
  }

//==================================================================
// GESTIONE DI UN ORDINE PENDENTE (solo con InpAlsoPendings=true)
//==================================================================
void ManagePending(const ulong ticket)
  {
   if(!OrderSelect(ticket))
      return;
   string sym   = OrderGetString(ORDER_SYMBOL);
   long   magic = OrderGetInteger(ORDER_MAGIC);
   if(!SymbolInScope(sym) || !MagicAllowed(magic))
      return;
   ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
   bool isBuy = false;
   switch(type)
     {
      case ORDER_TYPE_BUY_LIMIT:
      case ORDER_TYPE_BUY_STOP:
      case ORDER_TYPE_BUY_STOP_LIMIT:
         isBuy = true;
         break;
      case ORDER_TYPE_SELL_LIMIT:
      case ORDER_TYPE_SELL_STOP:
      case ORDER_TYPE_SELL_STOP_LIMIT:
         isBuy = false;
         break;
      default:
         return;   // ordini a mercato in esecuzione ecc.: non sono pendenti
     }
   g_nPend++;

   bool   stopLimit = (type == ORDER_TYPE_BUY_STOP_LIMIT || type == ORDER_TYPE_SELL_STOP_LIMIT);
   double price     = OrderGetDouble(ORDER_PRICE_OPEN);
   double stoplimit = OrderGetDouble(ORDER_PRICE_STOPLIMIT);
   double entry     = stopLimit ? stoplimit : price;   // prezzo a cui si aprira' la posizione
   double sl        = OrderGetDouble(ORDER_SL);
   double tp        = OrderGetDouble(ORDER_TP);
   ENUM_ORDER_TYPE_TIME tt = (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);
   datetime exp     = (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);

   MqlTick tk;
   if(!SymbolInfoTick(sym, tk) || tk.bid <= 0.0 || tk.ask <= 0.0)
      return;
   double pt = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(pt <= 0.0 || entry <= 0.0)
      return;
   double D = DistPrice(sym, InpStopPips);
   if(D <= 0.0)
      return;
   if(!GuardOk(sym, D, tk))
     {
      g_nBloccate++;
      return;
     }
   if(!g_tradeOk)
      return;

   int stpLv = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL);
   int frzLv = (int)SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL);
   double minD = MinDistPrice(sym);

   // Sul pendente SL e TP si misurano dal prezzo dell'ordine, non dal mercato.
   double thr   = isBuy ? RoundDown(sym, entry - D) : RoundUp(sym, entry + D);
   double limSL = isBuy ? RoundDown(sym, entry - minD) : RoundUp(sym, entry + minD);
   bool slCopre = (sl > 0.0) && (isBuy ? (sl >= thr - pt) : (sl <= thr + pt));
   double newSL = sl;
   double newTP = tp;
   string motivo = "";

   if(!slCopre)
     {
      bool piazzabile = isBuy ? (thr <= limSL) : (thr >= limSL);
      if(piazzabile)
        {
         newSL  = thr;
         motivo = StringFormat("SL a %s sul pendente (prezzo ordine %s)", Px(sym, thr), Px(sym, entry));
        }
      else if(sl <= 0.0 || (isBuy ? (limSL > sl + pt * 0.5) : (limSL < sl - pt * 0.5)))
        {
         // Nessuno SL, oppure SL piu' largo del minimo del broker: lo porto al
         // minimo consentito. Se lo SL attuale e' gia' piu' stretto del minimo,
         // si va al ramo sotto e NON lo si allarga.
         newSL  = limSL;
         motivo = StringFormat("SL %s al minimo consentito sul pendente: richiesto %s, messo %s (stops level %d punti, freeze level %d punti)",
                               (sl <= 0.0 ? "ALLARGATO" : "STRETTO"), Px(sym, thr), Px(sym, limSL), stpLv, frzLv);
        }
      else
         InfoOnce(ticket, StringFormat("pendente %I64u %s: SL attuale %s gia' piu' stretto del minimo del broker %s. Non lo allargo.",
                                       ticket, sym, Px(sym, sl), Px(sym, limSL)));
     }

   if(InpTakePips > 0.0 && tp <= 0.0)
     {
      double T     = DistPrice(sym, InpTakePips);
      double cand  = isBuy ? RoundUp(sym, entry + T) : RoundDown(sym, entry - T);
      double limTP = isBuy ? RoundUp(sym, entry + minD) : RoundDown(sym, entry - minD);
      newTP  = isBuy ? MathMax(cand, limTP) : MathMin(cand, limTP);
      motivo = (motivo == "" ? "" : motivo + " + ") + StringFormat("TP a %s sul pendente", Px(sym, newTP));
      if(MathAbs(newTP - cand) >= pt * 0.5)
         motivo += " (ALLARGATO al minimo del broker)";
     }

   bool cambiaSL = (MathAbs(newSL - sl) >= pt * 0.5);
   bool cambiaTP = (MathAbs(newTP - tp) >= pt * 0.5);
   if(!cambiaSL && !cambiaTP)
      return;

   // Freeze: se il mercato e' vicino al prezzo dell'ordine, l'ordine e' congelato.
   if(frzLv > 0)
     {
      double mkt = isBuy ? tk.ask : tk.bid;
      if(MathAbs(mkt - price) <= frzLv * pt)
        {
         InfoOnce(ticket, StringFormat("pendente %I64u %s dentro il freeze level (%d punti): modifica rimandata.",
                                       ticket, sym, frzLv));
         return;
        }
     }

   if(!CanModify(ticket))
      return;
   bool ok = g_trade.OrderModify(ticket, price, newSL, newTP, tt, exp, stoplimit);
   uint rc = g_trade.ResultRetcode();
   if(ok && rc == TRADE_RETCODE_DONE)
     {
      g_st[StIdx(ticket)].modFails = 0;
      Azione(StringFormat("%s pendente %I64u: %s", sym, ticket, motivo));
      return;
     }
   if(rc == TRADE_RETCODE_NO_CHANGES)
     {
      g_st[StIdx(ticket)].modFails = 0;
      return;
     }
   NoteModifyFailure(ticket, rc, StringFormat("modifica pendente (%s)", motivo));
  }

//==================================================================
// SCANSIONE
//==================================================================
void Scan()
  {
   g_tradeOk   = TradingAllowed();
   g_nPos      = 0;
   g_nPend     = 0;
   g_nBloccate = 0;
   g_nPreesist = 0;

   ulong now = GetTickCount64();
   if(!g_tradeOk && (g_tradeLogMs == 0 || now - g_tradeLogMs >= 60000))
     {
      g_tradeLogMs = now;
      Log("TRADING ALGORITMICO NON CONSENTITO (pulsante Algo Trading, opzioni EA o conto): NON PROTEGGO NULLA finche' non torna verde.");
     }

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0)
         continue;
      ManagePosition(t);
     }

   // I pendenti hanno solo lo SL sul server (lo stop virtuale non puo' agire
   // su un ordine non eseguito): quindi solo con InpServerSL=true.
   if(InpAlsoPendings && InpServerSL)
     {
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         ulong t = OrderGetTicket(i);
         if(t == 0)
            continue;
         ManagePending(t);
        }
     }

   if(now - g_pruneMs >= 60000)
     {
      g_pruneMs = now;
      StPrune();
     }
   UpdateComment();
  }

//==================================================================
// PANNELLO SUL GRAFICO
//==================================================================
void UpdateComment()
  {
   string sym = _Symbol;
   double D   = DistPrice(sym, InpStopPips);
   double pt  = SymbolInfoDouble(sym, SYMBOL_POINT);
   string ig  = (StringLen(InpIgnoreMagics) > 0 ? InpIgnoreMagics : "-");
   string s = "ABTG_StopManuale  " + SM_PREFISSO + "  (NON apre operazioni)\n";
   s += StringFormat("Perimetro: %s | %s | ignora magic: %s\n",
                     (InpSymbolScope == SM_CHART_ONLY ? "CHART_ONLY (" + sym + ")" : "ALL_SYMBOLS"),
                     (InpOnlyManual ? "solo manuali (magic 0)" : "tutte le magic non in lista"), ig);
   s += StringFormat("N = %.2f %s = %.0f punti = %s su %s (1 pip = %d punti)\n",
                     InpStopPips, (InpUnit == SM_PIPS ? "PIPS" : "POINTS"),
                     (pt > 0 ? D / pt : 0.0), Px(sym, D), sym, PipPoints(sym));
   s += StringFormat("Stops level %d punti | freeze level %d punti\n",
                     (int)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL),
                     (int)SymbolInfoInteger(sym, SYMBOL_TRADE_FREEZE_LEVEL));
   s += StringFormat("SL sul server: %s | Stop virtuale: %s | TP: %s | BE: %s | Trailing: %s | Pendenti: %s\n",
                     (InpServerSL ? "SI" : "NO"), (InpSoftStop ? "SI" : "NO"),
                     (InpTakePips > 0 ? DoubleToString(InpTakePips, 2) : "off"),
                     (InpBEPips > 0 ? DoubleToString(InpBEPips, 2) : "off"),
                     (InpTrailPips > 0 ? DoubleToString(InpTrailPips, 2) : "off"),
                     (InpAlsoPendings ? "SI" : "off"));
   s += StringFormat("Posizioni sorvegliate: %d | pendenti: %d | bloccate dalla guardia spread: %d | preesistenti oltre soglia: %d\n",
                     g_nPos, g_nPend, g_nBloccate, g_nPreesist);
   if(g_nBloccate > 0)
      s += StringFormat("!!! %d POSIZIONI SENZA STOP: N dentro lo spread (guardia spread). Controlla InpUnit / InpPipPoints !!!\n", g_nBloccate);
   s += "Trading algoritmico: " + (g_tradeOk ? "OK" : "NON CONSENTITO - NON PROTEGGO NULLA") + "\n";
   s += "Ultima azione: " + g_ultima;
   Comment(s);
  }

//==================================================================
// EVENTI
//==================================================================
int OnInit()
  {
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(login == SM_CONTO_REALE)
     {
      Log(StringFormat("CONTO REALE %I64d: l'EA NON PARTE. Serve la firma di Claudio (e allora si toglie il blocco in OnInit).", login));
      return INIT_FAILED;
     }
   // Solo HEDGING: in netting la posizione del simbolo e' una sola, e una
   // posizione a magic 0 puo' contenere volume aperto da un EA.
   if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
     {
      Log("Conto NON in modo HEDGING: in netting una posizione a magic 0 puo' contenere volume di un EA. L'EA non parte.");
      return INIT_FAILED;
     }
   if(InpStopPips <= 0.0)
     {
      Log("InpStopPips deve essere > 0. L'EA non parte.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(InpTakePips < 0.0 || InpBEPips < 0.0 || InpTrailPips < 0.0 || InpTrailStartPips < 0.0 || InpTrailStepPips < 0.0)
     {
      Log("TP / BE / trailing non possono essere negativi. L'EA non parte.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(InpPipPoints < 0 || InpBackoffSec < 1 || InpBackoffSec > SM_BACKOFF_MAX_S || InpMaxModifyPerMin < 1 || InpDeviationPts < 0)
     {
      Log("InpPipPoints >= 0, InpBackoffSec fra 1 e 900, InpMaxModifyPerMin >= 1, InpDeviationPts >= 0. L'EA non parte.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(!InpServerSL && !InpSoftStop)
     {
      Log("InpServerSL=false E InpSoftStop=false: l'EA non proteggerebbe niente. L'EA non parte.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(!ParseIgnore())
      return INIT_PARAMETERS_INCORRECT;
   if(!InpOnlyManual)
      Log("ATTENZIONE: InpOnlyManual=false -> tocco TUTTE le magic non elencate in InpIgnoreMagics, anche quelle degli EA. "
          "Su un conto con sedie attive elenca le loro magic.");

   g_trade.SetExpertMagicNumber((ulong)InpMagic);
   g_trade.SetDeviationInPoints((ulong)InpDeviationPts);
   g_trade.SetAsyncMode(false);
   g_trade.LogLevel(LOG_LEVEL_ERRORS);

   ArrayResize(g_st, 0);
   ArrayResize(g_guardSym, 0);
   ArrayResize(g_guardOk, 0);
   ArrayResize(g_guardNextMs, 0);

   double pt = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double D  = DistPrice(_Symbol, InpStopPips);
   Log(StringFormat("AVVIO su conto %I64d, grafico %s. N = %.2f %s = %.0f punti = %s (1 pip = %d punti, Digits %d). "
                    "Stops level %d punti, freeze level %d punti, spread ora %d punti. Perimetro %s, %s.",
                    login, _Symbol, InpStopPips, (InpUnit == SM_PIPS ? "PIPS" : "POINTS"),
                    (pt > 0 ? D / pt : 0.0), Px(_Symbol, D), PipPoints(_Symbol),
                    (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS),
                    (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL),
                    (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL),
                    (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD),
                    (InpSymbolScope == SM_CHART_ONLY ? "CHART_ONLY" : "ALL_SYMBOLS"),
                    (InpOnlyManual ? "solo magic 0" : "tutte le magic non in lista")));

   // Avviso PRIMA che Claudio apra: se N non supera gia' lo spread del grafico,
   // le posizioni a mano su questo simbolo resterebbero senza stop.
   MqlTick tk0;
   if(InpSpreadGuard && D > 0.0 && SymbolInfoTick(_Symbol, tk0) && tk0.ask > tk0.bid && D <= tk0.ask - tk0.bid)
     {
      string w = StringFormat("ATTENZIONE: su %s N = %s NON supera lo spread attuale %s. Le posizioni a mano su %s resterebbero SENZA STOP (guardia spread). Controlla InpUnit / InpPipPoints PRIMA di aprire.",
                              _Symbol, Px(_Symbol, D), Px(_Symbol, tk0.ask - tk0.bid), _Symbol);
      Log(w);
      Alert(SM_PREFISSO + w);
     }

   InitPreesistenti();
   EventSetMillisecondTimer(SM_TIMER_MS);
   Scan();
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   Comment("");
   Log(StringFormat("FERMATO (motivo %d). Gli SL gia' messi restano sul server; lo stop virtuale NON c'e' piu'.", reason));
  }

void OnTick()
  {
   Scan();
  }

void OnTimer()
  {
   Scan();
  }
//+------------------------------------------------------------------+
