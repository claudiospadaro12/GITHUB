// Simulatore a secco per mql5/Indicators/ABTG_ST_MTF_Unico.mq5 (10/10/2026).
// Usato da backtest_pipeline/collaudo_st_mtf_unico.py: il .mq5 VERO viene tradotto in C++ con
// sostituzioni meccaniche e incluso qui ("ind_tradotto.cpp"), sopra uno strato di FINTI MQL5:
// archivio oggetti del grafico, CopyRates su dati sintetici, array dinamici CON controllo dei limiti,
// timer e tick finti. NON e' MetaEditor: prova la LOGICA del codice intero (clic, timer, cambio TF,
// fughe di oggetti, accessi fuori array), non la compatibilita' esatta con il compilatore MQL5.
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <sstream>
#include <string>
#include <vector>

typedef std::string string;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef long long datetime;
typedef unsigned int color;

static int g_fail = 0;
#define CHECK(c, msg) do { if(c) printf("  ok   %s\n", msg); else { printf("  FAIL %s\n", msg); g_fail++; } } while(0)

//--- array dinamico con controllo dei limiti (un accesso fuori array = arresto immediato)
template <typename T> struct DArr {
  std::vector<T> v;
  T &operator[](int i) { if(i < 0 || i >= (int)v.size()) { printf("FUORI ARRAY: indice %d su %d\n", i, (int)v.size()); abort(); } return v[i]; }
  const T &operator[](int i) const { if(i < 0 || i >= (int)v.size()) { printf("FUORI ARRAY: indice %d su %d\n", i, (int)v.size()); abort(); } return v[i]; }
};
template <typename T> int ArraySize(const DArr<T> &a) { return (int)a.v.size(); }
template <typename T> int ArrayResize(DArr<T> &a, int n) { a.v.resize(n); return n; }
template <typename T> bool ArraySetAsSeries(DArr<T> &, bool s) { return !s; }

//--- enum e costanti (solo quelli usati)
enum ENUM_BASE_CORNER { CORNER_LEFT_UPPER = 0, CORNER_LEFT_LOWER = 1, CORNER_RIGHT_LOWER = 2, CORNER_RIGHT_UPPER = 3 };
enum ENUM_LINE_STYLE { STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT };
enum ENUM_TIMEFRAMES { PERIOD_CURRENT = 0, PERIOD_M1 = 1, PERIOD_M3 = 3, PERIOD_M5 = 5, PERIOD_M15 = 15, PERIOD_M30 = 30,
                       PERIOD_H1 = 16385, PERIOD_H4 = 16388, PERIOD_H12 = 16396, PERIOD_D1 = 16408, PERIOD_W1 = 32769,
                       PERIOD_MN1 = 49153 };
enum ENUM_OBJECT { OBJ_HLINE = 1, OBJ_LABEL = 23, OBJ_BUTTON = 25 };
enum ENUM_OBJECT_PROPERTY_INTEGER { OBJPROP_CORNER, OBJPROP_XDISTANCE, OBJPROP_YDISTANCE, OBJPROP_XSIZE, OBJPROP_YSIZE,
                                    OBJPROP_FONTSIZE, OBJPROP_COLOR, OBJPROP_BGCOLOR, OBJPROP_BORDER_COLOR, OBJPROP_STATE,
                                    OBJPROP_SELECTABLE, OBJPROP_HIDDEN, OBJPROP_BACK, OBJPROP_ZORDER, OBJPROP_TIMEFRAMES,
                                    OBJPROP_ANCHOR, OBJPROP_STYLE, OBJPROP_WIDTH };
enum ENUM_OBJECT_PROPERTY_DOUBLE { OBJPROP_PRICE };
enum ENUM_OBJECT_PROPERTY_STRING { OBJPROP_TEXT, OBJPROP_FONT, OBJPROP_TOOLTIP };
enum ENUM_ANCHOR_POINT { ANCHOR_LEFT_UPPER, ANCHOR_LEFT, ANCHOR_LEFT_LOWER, ANCHOR_LOWER, ANCHOR_RIGHT_LOWER, ANCHOR_RIGHT,
                         ANCHOR_RIGHT_UPPER, ANCHOR_UPPER, ANCHOR_CENTER };
enum ENUM_CHART_PROPERTY_INTEGER { CHART_HEIGHT_IN_PIXELS };
enum ENUM_SERIES_INFO_INTEGER { SERIES_SYNCHRONIZED };
enum ENUM_CUSTOMIND_PROPERTY_STRING { INDICATOR_SHORTNAME };
#define OBJ_NO_PERIODS 0
#define OBJ_ALL_PERIODS 0x001fffff
#define CHARTEVENT_OBJECT_CLICK 1
#define CHARTEVENT_CHART_CHANGE 9
#define REASON_REMOVE 1
#define REASON_CHARTCHANGE 3
#define REASON_PARAMETERS 5
#define INIT_SUCCEEDED 0
// colori: valori MQL5 veri (0x00BBGGRR), servono distinti
const color clrSilver = 0xC0C0C0, clrDeepSkyBlue = 0xFFBF00, clrWhite = 0xFFFFFF, clrYellow = 0x00FFFF, clrTan = 0x8CB4D2,
            clrRoyalBlue = 0xE16941, clrRed = 0x0000FF, clrLightCoral = 0x8080F0, clrLime = 0x00FF00, clrOrange = 0x00A5FF,
            clrAqua = 0xFFFF00, clrDimGray = 0x696969, clrForestGreen = 0x228B22, clrCrimson = 0x3C14DC,
            clrDarkViolet = 0xD30094;

struct MqlRates { datetime time; double open, high, low, close; long long tick_volume; int spread; long long real_volume; };

//--- ambiente finto
string _Symbol = "XAUUSD";
ENUM_TIMEFRAMES _Period = PERIOD_M5;
int _Digits = 2;
uint g_tick = 1000;
int g_lastErr = 0;
int g_redraws = 0;
bool g_fail_copy[64];          // per indice di TF della simulazione
int g_bars_avail = 2000;       // barre disponibili per TF
bool g_synced = true;
double g_lo = 1900.0, g_hi = 2100.0;   // prezzi visibili nel grafico finto (400 px)

struct Obj { int type; std::map<int, long long> i; double price; std::map<int, string> s; };
std::map<string, Obj> OBJ;

int tf_index(ENUM_TIMEFRAMES tf) {
  ENUM_TIMEFRAMES all[11] = {PERIOD_M1, PERIOD_M3, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_H12,
                             PERIOD_D1, PERIOD_W1, PERIOD_MN1};
  for(int k = 0; k < 11; k++) if(all[k] == tf) return k;
  return -1;
}

int ObjectFind(long long, const string &n) { return OBJ.count(n) ? 0 : -1; }
bool ObjectCreate(long long, const string &n, ENUM_OBJECT t, int, datetime, double p) {
  if(OBJ.count(n)) return false;            // piu' severo di MT5: una doppia creazione e' un errore del codice
  Obj o; o.type = t; o.price = p; o.i[OBJPROP_TIMEFRAMES] = OBJ_ALL_PERIODS; OBJ[n] = o; return true;
}
bool ObjectDelete(long long, const string &n) { return OBJ.erase(n) > 0; }
bool ObjectSetInteger(long long, const string &n, ENUM_OBJECT_PROPERTY_INTEGER p, long long v) {
  if(!OBJ.count(n)) { printf("SET su oggetto inesistente %s\n", n.c_str()); g_fail++; return false; } OBJ[n].i[p] = v; return true; }
bool ObjectSetDouble(long long, const string &n, ENUM_OBJECT_PROPERTY_DOUBLE, double v) {
  if(!OBJ.count(n)) { printf("SET su oggetto inesistente %s\n", n.c_str()); g_fail++; return false; } OBJ[n].price = v; return true; }
bool ObjectSetString(long long, const string &n, ENUM_OBJECT_PROPERTY_STRING p, const string &v) {
  if(!OBJ.count(n)) { printf("SET su oggetto inesistente %s\n", n.c_str()); g_fail++; return false; } OBJ[n].s[p] = v; return true; }
string ObjectGetString(long long, const string &n, ENUM_OBJECT_PROPERTY_STRING p) { return OBJ.count(n) ? OBJ[n].s[p] : string(""); }

long long ChartGetInteger(long long, ENUM_CHART_PROPERTY_INTEGER, int) { return 400; }
bool ChartTimePriceToXY(long long, int, datetime, double price, int &x, int &y) {
  x = 500; y = (int)std::floor((g_hi - price) / (g_hi - g_lo) * 400.0); return true; }
void ChartRedraw(long long) { g_redraws++; }
bool EventSetTimer(int s) { return s >= 1; }
void EventKillTimer() {}
uint GetTickCount() { return g_tick; }
int GetLastError() { return g_lastErr; }
void ResetLastError() { g_lastErr = 0; }
bool IndicatorSetString(ENUM_CUSTOMIND_PROPERTY_STRING, const string &) { return true; }
datetime TimeCurrent() { return 1760000000LL; }
datetime iTime(const string &, ENUM_TIMEFRAMES, int) { return 1760000000LL; }
long long SeriesInfoInteger(const string &, ENUM_TIMEFRAMES, ENUM_SERIES_INFO_INTEGER) { return g_synced ? 1 : 0; }

// dati sintetici: passeggiata deterministica per TF, con un "seme" che cambia per simulare i tick
int g_tickshift = 0;
int CopyRates(const string &, ENUM_TIMEFRAMES tf, int start, int count, DArr<MqlRates> &r) {
  int k = tf_index(tf);
  if(k < 0 || g_fail_copy[k]) { g_lastErr = 4401; return -1; }
  int n = count < g_bars_avail ? count : g_bars_avail;
  if(start != 0) { printf("CopyRates con start %d inatteso\n", start); g_fail++; }
  r.v.resize(n);
  double p = 2000.0;
  unsigned s = 12345u + 977u * (unsigned)k;
  for(int b = 0; b < n; b++) {
    s = s * 1103515245u + 12345u;
    double step = ((double)((s >> 8) % 2001) - 1000.0) / 1000.0 * (1.0 + k);
    double o = p, c = p + step;
    if(b == n - 1) c += 0.01 * g_tickshift;         // la barra in formazione si muove ai tick
    double h = std::max(o, c) + 0.5 * (1 + k), l = std::min(o, c) - 0.5 * (1 + k);
    r.v[b].time = 1700000000LL + 60LL * b; r.v[b].open = o; r.v[b].high = h; r.v[b].low = l; r.v[b].close = c;
    p = c;
  }
  return n;
}

double MathAbs(double a) { return std::fabs(a); }
double MathRound(double a) { return std::round(a); }
double MathMax(double a, double b) { return a > b ? a : b; }
double MathMin(double a, double b) { return a < b ? a : b; }
bool MathIsValidNumber(double a) { return std::isfinite(a); }
string DoubleToString(double v, int d) { char b[64]; snprintf(b, sizeof b, "%.*f", d, v); return b; }
string IntegerToString(long long v) { return std::to_string(v); }
int StringLen(const string &s) { return (int)s.size(); }
string StringSubstr(const string &s, int a, int n) { if(a < 0 || a > (int)s.size()) { printf("StringSubstr fuori\n"); abort(); } return s.substr(a, n); }
ushort StringGetCharacter(const string &s, int p) { if(p < 0 || p >= (int)s.size()) { printf("StringGetCharacter fuori: %d su %d\n", p, (int)s.size()); abort(); } return (ushort)s[p]; }
int StringFind(const string &s, const string &f) { size_t p = s.find(f); return p == string::npos ? -1 : (int)p; }
template <typename... A> void Print(A... a) { std::ostringstream o; (void)std::initializer_list<int>{((o << a), 0)...}; printf("    [Esperti] %s\n", o.str().c_str()); }

#include "ind_tradotto.cpp"

//================================================================== simulazione
static const char *TFN[11] = {"M1", "M3", "M5", "M15", "M30", "H1", "H4", "H12", "D1", "W1", "MN1"};
int count_prefix(const string &p, int type = -1) {
  int n = 0; for(auto &kv : OBJ) if(kv.first.compare(0, p.size(), p) == 0 && (type < 0 || kv.second.type == type)) n++; return n; }
long long I(const string &n, int p) { return OBJ.count(n) ? OBJ[n].i[p] : -999; }
void click(const string &n) { OnChartEvent(CHARTEVENT_OBJECT_CLICK, 0, 0.0, n); }
void timer(int k = 1) { for(int a = 0; a < k; a++) { g_tick += 1000; OnTimer(); } }
// valore atteso del Supertrend di un TF: ultima barra (in formazione) e penultima (chiusa)
void expected(ENUM_TIMEFRAMES tf, double mult, double &vLast, double &vPrev) {
  DArr<MqlRates> r; int n = CopyRates(_Symbol, tf, 0, 500, r);
  DArr<double> h, l, c, a, u, d, di, v; h.v.resize(n); l.v.resize(n); c.v.resize(n); a.v.resize(n); u.v.resize(n);
  d.v.resize(n); di.v.resize(n); v.v.resize(n);
  for(int b = 0; b < n; b++) { h[b] = r[b].high; l[b] = r[b].low; c[b] = r[b].close; }
  SW_STCore(h, l, c, n, 0, 10, mult, a, u, d, di, v);
  vLast = v[n - 1]; vPrev = v[n - 2];
}
string snapshot() {
  std::ostringstream o;
  for(auto &kv : OBJ) { o << kv.first << "#" << kv.second.price; for(auto &q : kv.second.i) o << "," << q.first << "=" << q.second;
    for(auto &q : kv.second.s) o << "," << q.first << "=" << q.second; o << ";"; }
  return o.str(); }
int visible_labels() { int n = 0; for(auto &kv : OBJ) if(kv.first.compare(0, 9, "ABTGSTU_T") == 0 && kv.second.i[OBJPROP_TIMEFRAMES] != OBJ_NO_PERIODS) n++; return n; }

int main() {
  char m[512];
  // un oggetto ALTRUI sul grafico: non deve MAI essere toccato
  ObjectCreate(0, "ALTRUI_linea", OBJ_HLINE, 0, 0, 1234.5);
  ObjectSetInteger(0, "ALTRUI_linea", OBJPROP_COLOR, 777);

  printf("D1) avvio\n");
  CHECK(OnInit() == INIT_SUCCEEDED, "OnInit = INIT_SUCCEEDED");
#ifndef VAR_ST2_OFF
  CHECK(count_prefix("ABTGSTU_B_", OBJ_BUTTON) == 17, "17 tasti: ST MTF + 11 TF + 3 ST + UNICO + DEFAULT");
#else
  CHECK(count_prefix("ABTGSTU_B_", OBJ_BUTTON) == 16, "ST2 disabilitato: 16 tasti (niente tasto ST 3.0)");
  CHECK(ObjectFind(0, "ABTGSTU_B_ST1") < 0, "ST2 disabilitato: il suo tasto non esiste");
#endif
  // ordine e posizioni
  std::vector<string> order = {"ABTGSTU_B_MAIN"};
  for(int i = 0; i < 11; i++) order.push_back("ABTGSTU_B_TF" + std::to_string(i));
  for(int j = 0; j < 3; j++) if(ObjectFind(0, "ABTGSTU_B_ST" + std::to_string(j)) >= 0) order.push_back("ABTGSTU_B_ST" + std::to_string(j));
  order.push_back("ABTGSTU_B_UNICO"); order.push_back("ABTGSTU_B_DEF");
  bool seq = true, contig = true;
  (void)seq;
  for(size_t k = 1; k < order.size(); k++) {
    long long xa = I(order[k - 1], OBJPROP_XDISTANCE), xb = I(order[k], OBJPROP_XDISTANCE);
    long long ya = I(order[k - 1], OBJPROP_YDISTANCE), yb = I(order[k], OBJPROP_YDISTANCE);
    long long wa = I(order[k - 1], OBJPROP_XSIZE), ha = I(order[k - 1], OBJPROP_YSIZE);
#if defined(VAR_VERTICALE)
    if(!(yb == ya + ha + 1 && xb == xa)) contig = false;
#elif defined(VAR_DESTRA)
    // bordo sinistro a schermo = larghezza grafico - distanza: adiacenti se xa - xb == larghezza(a) + 1
    if(!(xa - xb == wa + 1 && yb == ya)) contig = false;
    if(!(xb < xa)) seq = false;
#else
    if(!(xb == xa + wa + 1 && yb == ya)) contig = false;
#endif
  }
#if defined(VAR_VERTICALE)
  CHECK(contig, "in colonna: ogni tasto SOTTO il precedente (stessa x, y + 24 + 1) - UNICO sotto ST 3.5");
#elif defined(VAR_DESTRA)
  CHECK(seq, "angolo DESTRO: distanza dal bordo destro decrescente lungo l'elenco (ordine sinistra->destra conservato)");
  CHECK(contig, "angolo DESTRO: tasti adiacenti (1 px), stessa y - UNICO subito a destra di ST 3.5");
  CHECK(I("ABTGSTU_B_DEF", OBJPROP_XDISTANCE) == 10 + I("ABTGSTU_B_DEF", OBJPROP_XSIZE),
        "angolo DESTRO: DEFAULT (ultimo) a 10 px dal bordo destro col suo lato destro");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_XDISTANCE) - I("ABTGSTU_B_DEF", OBJPROP_XDISTANCE) == 64 + 1,
        "angolo DESTRO: UNICO subito a sinistra di DEFAULT (64 + 1 px)");
#else
  CHECK(contig, "in riga: ogni tasto subito a DESTRA del precedente (x + larghezza + 1), stessa y");
  snprintf(m, sizeof m, "UNICO a x=%lld, dopo ST 3.5 (x=%lld, larghezza %lld): adiacente",
           I("ABTGSTU_B_UNICO", OBJPROP_XDISTANCE), I(order[order.size() - 3], OBJPROP_XDISTANCE), I(order[order.size() - 3], OBJPROP_XSIZE));
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_XDISTANCE) == I(order[order.size() - 3], OBJPROP_XDISTANCE) + I(order[order.size() - 3], OBJPROP_XSIZE) + 1, m);
  CHECK(I("ABTGSTU_B_MAIN", OBJPROP_XDISTANCE) == 10 && I("ABTGSTU_B_MAIN", OBJPROP_YDISTANCE) == 50, "primo tasto a (10, 50)");
#endif
  CHECK(OBJ["ABTGSTU_B_UNICO"].s[OBJPROP_TEXT] == "UNICO" && I("ABTGSTU_B_UNICO", OBJPROP_XSIZE) == 64, "UNICO: testo 'UNICO', 64 px");
  bool tfok = true;
  for(int i = 0; i < 11; i++) {
    bool on = (i == 5 || i == 6 || i == 7 || i == 8);
    if(I("ABTGSTU_B_TF" + std::to_string(i), OBJPROP_BGCOLOR) != (long long)(on ? clrLime : clrDimGray)) tfok = false;
    if(OBJ["ABTGSTU_B_TF" + std::to_string(i)].s[OBJPROP_TEXT] != TFN[i]) tfok = false;
  }
  CHECK(tfok, "TF di default: H1 H4 H12 D1 accesi (Lime), gli altri spenti (DimGray), etichette M1..MN1");
  CHECK(I("ABTGSTU_B_ST2", OBJPROP_BGCOLOR) == clrCrimson && I("ABTGSTU_B_ST0", OBJPROP_BGCOLOR) == clrDimGray,
        "ST di default: solo 3.5 acceso (Crimson)");
  CHECK(OBJ["ABTGSTU_B_ST0"].s[OBJPROP_TEXT] == "ST 2.5" && OBJ["ABTGSTU_B_ST2"].s[OBJPROP_TEXT] == "ST 3.5", "testi 'ST 2.5' / 'ST 3.5'");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDimGray, "UNICO all'avvio GRIGIO (non tutti accesi)");
  CHECK(count_prefix("ABTGSTU_L") == 0, "nessuna linea prima del primo giro del timer (nessun calcolo in OnInit)");

  printf("D2) primo giro del timer\n");
  timer();
  CHECK(count_prefix("ABTGSTU_L", OBJ_HLINE) == 4, "4 linee = 4 TF accesi x 1 ST acceso");
  CHECK(count_prefix("ABTGSTU_T", OBJ_LABEL) == 4, "4 etichette");
  CHECK(I("ABTGSTU_L5_2", OBJPROP_COLOR) == clrRoyalBlue && I("ABTGSTU_L6_2", OBJPROP_COLOR) == clrRed &&
        I("ABTGSTU_L7_2", OBJPROP_COLOR) == clrLightCoral && I("ABTGSTU_L8_2", OBJPROP_COLOR) == clrLime,
        "colori linee: H1 RoyalBlue, H4 Red, H12 LightCoral, D1 Lime");
  CHECK(I("ABTGSTU_L5_2", OBJPROP_STYLE) == STYLE_DASH && I("ABTGSTU_L5_2", OBJPROP_WIDTH) == 1 && I("ABTGSTU_L5_2", OBJPROP_BACK) == 0,
        "stile DASH, spessore 1, in primo piano");
  {
    string t = OBJ["ABTGSTU_T5_2"].s[OBJPROP_TEXT];
    bool up = (gLd[5][2] > 0);
    snprintf(m, sizeof m, "etichetta H1 = '%s' (trend %s), colore %s", t.c_str(), up ? "su" : "giu", up ? "Lime" : "Red");
    CHECK(t == string("H1 3.5 ") + (up ? "VERDE" : "ROSSO") && I("ABTGSTU_T5_2", OBJPROP_COLOR) == (long long)(up ? clrLime : clrRed), m);
    CHECK(I("ABTGSTU_T5_2", OBJPROP_XDISTANCE) == 280 && I("ABTGSTU_T5_2", OBJPROP_CORNER) == CORNER_RIGHT_UPPER,
          "etichetta a 280 px dal bordo destro");
    int x, y; ChartTimePriceToXY(0, 0, 0, OBJ["ABTGSTU_L5_2"].price, x, y);
    bool vis = (y >= 0 && y <= 400);
    snprintf(m, sizeof m, "etichetta H1: y = y linea - 8 se visibile (linea a y=%d), nascosta se fuori schermo", y);
    CHECK(vis ? (I("ABTGSTU_T5_2", OBJPROP_YDISTANCE) == std::max(0, y - 8) && I("ABTGSTU_T5_2", OBJPROP_TIMEFRAMES) == OBJ_ALL_PERIODS)
              : (I("ABTGSTU_T5_2", OBJPROP_TIMEFRAMES) == OBJ_NO_PERIODS), m);
  }
  // il livello disegnato = valore di SW_STCore sull'ultima barra di quel TF, calcolato qui a parte
  {
    DArr<MqlRates> r; int n = CopyRates(_Symbol, PERIOD_H4, 0, 500, r);
    DArr<double> h, l, c, a, u, d, di, v; h.v.resize(n); l.v.resize(n); c.v.resize(n); a.v.resize(n); u.v.resize(n);
    d.v.resize(n); di.v.resize(n); v.v.resize(n);
    for(int b = 0; b < n; b++) { h[b] = r[b].high; l[b] = r[b].low; c[b] = r[b].close; }
    SW_STCore(h, l, c, n, 0, 10, 3.5, a, u, d, di, v);
    CHECK(OBJ["ABTGSTU_L6_2"].price == v[n - 1], "prezzo della linea H4 3.5 = SW_STCore sull'ultima barra H4 (barra in formazione)");
  }
  int r0 = g_redraws; timer();
  CHECK(g_redraws == r0, "giro del timer senza cambiamenti: NESSUN ChartRedraw");
  // ridisegno SE E SOLO SE e' cambiato almeno un oggetto (un tick piccolo puo' non muovere il livello:
  // le bande del Supertrend si stringono soltanto, quindi "nessun ridisegno" puo' essere giusto)
  bool iff = true, moved = false;
  for(int ts = 1; ts <= 40; ts++) {
    g_tickshift = ts * ts * 37;                 // da piccoli a molto grandi
    string before = snapshot(); r0 = g_redraws; timer();
    bool changed = (snapshot() != before);
    if(changed != (g_redraws == r0 + 1) || g_redraws > r0 + 1) iff = false;
    if(changed) moved = true;
  }
  CHECK(iff, "40 tick di ampiezza crescente: ChartRedraw (uno solo) SE E SOLO SE e' cambiato un oggetto");
  CHECK(moved, "...e almeno un tick ha davvero mosso un livello (il test non e' vuoto)");

  printf("D3) tasto UNICO, lo STESSO tasto accende e spegne\n");
#ifndef VAR_ST2_OFF
  click("ABTGSTU_B_UNICO");
  CHECK(gStOn[0] && gStOn[1] && gStOn[2], "1o clic (uno acceso): ACCENDE tutti e tre");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDarkViolet, "UNICO VIOLA");
  CHECK(I("ABTGSTU_B_ST0", OBJPROP_BGCOLOR) == clrCrimson && I("ABTGSTU_B_ST1", OBJPROP_BGCOLOR) == clrCrimson, "tasti ST 2.5 e 3.0 ora Crimson");
  CHECK(count_prefix("ABTGSTU_L", OBJ_HLINE) == 12, "12 linee subito al clic (4 TF x 3 ST), senza aspettare il timer");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_STATE) == 0, "stato premuto del tasto rimesso a false");
  click("ABTGSTU_B_UNICO");
  CHECK(!gStOn[0] && !gStOn[1] && !gStOn[2], "2o clic (tutti accesi): SPEGNE tutti e tre");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDimGray && count_prefix("ABTGSTU_L") == 0 && count_prefix("ABTGSTU_T") == 0,
        "UNICO grigio, zero linee e zero etichette");
  click("ABTGSTU_B_ST1");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDimGray, "a mano: acceso solo 3.0 -> UNICO resta grigio");
  click("ABTGSTU_B_ST0"); click("ABTGSTU_B_ST2");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDarkViolet, "a mano: accesi tutti e tre coi tasti ST -> UNICO diventa VIOLA da solo");
  click("ABTGSTU_B_ST0");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDimGray, "a mano: spento il 2.5 -> UNICO torna grigio");
  click("ABTGSTU_B_UNICO");
  CHECK(gStOn[0] && gStOn[1] && gStOn[2] && I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDarkViolet, "due accesi + clic UNICO -> tutti accesi");
  {
    // ogni linea = valore sulla barra IN FORMAZIONE del suo TF, per 4 TF x 3 ST x 30 tick
    ENUM_TIMEFRAMES tfs[4] = {PERIOD_H1, PERIOD_H4, PERIOD_H12, PERIOD_D1};
    double mults[3] = {2.5, 3.0, 3.5};
    bool all = true, distinguishes = false;
    for(int ts = 0; ts < 30; ts++) {
      g_tickshift = ts * ts * 53 - 4000; timer();
      for(int a = 0; a < 4; a++) for(int j = 0; j < 3; j++) {
        double vl, vp; expected(tfs[a], mults[j], vl, vp);
        string n = "ABTGSTU_L" + std::to_string(5 + a) + "_" + std::to_string(j);
        if(ObjectFind(0, n) < 0 || OBJ[n].price != vl) all = false;
        if(vl != vp) distinguishes = true;
      }
    }
    CHECK(all, "360 confronti: ogni linea = SW_STCore sulla barra IN FORMAZIONE del suo TF");
    CHECK(distinguishes, "...e in almeno un caso la barra chiusa avrebbe dato un valore diverso (il test non e' vuoto)");
  }
#else
  click("ABTGSTU_B_UNICO");
  CHECK(gStOn[0] && !gStOn[1] && gStOn[2], "ST2 disabilitato: clic UNICO accende 2.5 e 3.5, il 3.0 resta fuori");
  CHECK(I("ABTGSTU_B_UNICO", OBJPROP_BGCOLOR) == clrDarkViolet, "ST2 disabilitato: UNICO VIOLA con i due abilitati accesi");
  CHECK(count_prefix("ABTGSTU_L", OBJ_HLINE) == 8, "8 linee (4 TF x 2 ST abilitati)");
  click("ABTGSTU_B_UNICO");
  CHECK(!gStOn[0] && !gStOn[1] && !gStOn[2], "ST2 disabilitato: secondo clic spegne i due");
  click("ABTGSTU_B_UNICO");
#endif

  printf("D4) pulsantiera, DEFAULT, TF\n");
  click("ABTGSTU_B_MAIN");
  CHECK(count_prefix("ABTGSTU_B_", OBJ_BUTTON) == 1 && I("ABTGSTU_B_MAIN", OBJPROP_BGCOLOR) == clrRed,
        "ST MTF: pulsantiera chiusa, resta solo il tasto principale (rosso)");
  CHECK(count_prefix("ABTGSTU_L", OBJ_HLINE) > 0, "pulsantiera chiusa: le linee restano");
  click("ABTGSTU_B_MAIN");
  CHECK(I("ABTGSTU_B_MAIN", OBJPROP_BGCOLOR) == clrForestGreen && ObjectFind(0, "ABTGSTU_B_UNICO") >= 0, "riaperta: verde, UNICO di nuovo li'");
  click("ABTGSTU_B_TF0");
  CHECK(gTfOn[0] && I("ABTGSTU_B_TF0", OBJPROP_BGCOLOR) == clrLime, "clic M1: acceso, Lime");
  CHECK(ObjectFind(0, "ABTGSTU_L0_2") >= 0 && I("ABTGSTU_L0_2", OBJPROP_COLOR) == clrSilver, "linea M1 3.5 subito, colore Silver");
  click("ABTGSTU_B_DEF");
  CHECK(!gTfOn[0] && gTfOn[5] && !gStOn[0] && gStOn[2] && count_prefix("ABTGSTU_L", OBJ_HLINE) == 4, "DEFAULT: torna a H1 H4 H12 D1 x ST 3.5");

  printf("D5) dati che mancano: mai una linea inventata o vecchia\n");
  g_fail_copy[6] = true; g_tickshift = 50; timer();
  CHECK(ObjectFind(0, "ABTGSTU_L6_2") >= 0, "H4: lettura fallita DOPO una buona -> resta l'ultimo valore buono");
  click("ABTGSTU_B_TF6"); click("ABTGSTU_B_TF6");
  CHECK(ObjectFind(0, "ABTGSTU_L6_2") < 0, "H4 spento e riacceso con dati che mancano -> NESSUNA linea (niente valore vecchio)");
  timer(61);
  g_fail_copy[6] = false; timer();
  CHECK(ObjectFind(0, "ABTGSTU_L6_2") >= 0, "dati tornati -> linea H4 di nuovo");
  g_bars_avail = 30; g_synced = false; click("ABTGSTU_B_TF0");
  CHECK(ObjectFind(0, "ABTGSTU_L0_2") < 0, "finestra corta (30/500) e serie NON sincronizzata -> nessuna linea");
  g_synced = true; timer();
  CHECK(ObjectFind(0, "ABTGSTU_L0_2") >= 0, "finestra corta ma serie sincronizzata (tutto lo storico che c'e') -> linea");
  g_bars_avail = 5; click("ABTGSTU_B_TF0"); click("ABTGSTU_B_TF0");
  CHECK(ObjectFind(0, "ABTGSTU_L0_2") < 0, "solo 5 barre (< periodo + 2) -> nessuna linea, nessun crash");
  g_bars_avail = 2000; click("ABTGSTU_B_TF0");

  printf("D6) cambio di TF del grafico: stato conservato, niente fughe\n");
  click("ABTGSTU_B_TF9");          // W1 acceso: stato diverso dai default
  bool sw9 = gTfOn[9];
  string altruiPrima = std::to_string(I("ALTRUI_linea", OBJPROP_COLOR)) + "|" + std::to_string(OBJ["ALTRUI_linea"].price);
  OnDeinit(REASON_CHARTCHANGE);
  CHECK(count_prefix("ABTGSTU_") == 1 && ObjectFind(0, "ABTGSTU_STATO") >= 0, "OnDeinit(cambio TF): resta SOLO l'oggetto invisibile STATO");
  for(int i = 0; i < 11; i++) gTfOn[i] = false;     // istanza nuova: memoria del programma da capo
  gStOn[0] = gStOn[1] = gStOn[2] = false;
  OnInit();
  CHECK(gTfOn[9] == sw9 && gTfOn[5], "OnInit dopo cambio TF: stato dei tasti RIPRESO (W1 acceso come prima)");
  printf("D7) gara: OnDeinit della vecchia istanza DOPO OnInit della nuova\n");
  timer();
  int nl = count_prefix("ABTGSTU_L", OBJ_HLINE);
  // la VECCHIA istanza (memoria sua, separata) cancella per nome gli oggetti della nuova, tranne STATO:
  // si toglie direttamente dall'archivio, cosi' le cache della NUOVA restano quelle vere (test non addomesticato)
  for(auto it = OBJ.begin(); it != OBJ.end();) {
    if(it->first.compare(0, 8, "ABTGSTU_") == 0 && it->first != "ABTGSTU_STATO") it = OBJ.erase(it); else ++it; }
  CHECK(count_prefix("ABTGSTU_B_") == 0, "la vecchia istanza ha tolto i tasti della nuova");
  timer();
  CHECK(count_prefix("ABTGSTU_B_", OBJ_BUTTON) >= 16 && count_prefix("ABTGSTU_L", OBJ_HLINE) == nl,
        "un giro di timer dopo: tasti e linee RIPARATI da soli");
  printf("D8) rimozione\n");
  OnDeinit(REASON_REMOVE);
  CHECK(count_prefix("ABTGSTU_") == 0, "OnDeinit(rimozione): ZERO oggetti col prefisso (nessuna fuga)");
  CHECK(OBJ.size() == 1 && ObjectFind(0, "ALTRUI_linea") >= 0 &&
        std::to_string(I("ALTRUI_linea", OBJPROP_COLOR)) + "|" + std::to_string(OBJ["ALTRUI_linea"].price) == altruiPrima,
        "l'oggetto ALTRUI e' intatto e unico rimasto");
  printf("D9) stato conservato illeggibile\n");
  ObjectCreate(0, "ABTGSTU_STATO", OBJ_LABEL, 0, 0, 0); ObjectSetString(0, "ABTGSTU_STATO", OBJPROP_TEXT, "STU1|1|0000|x");
  CHECK(OnInit() == INIT_SUCCEEDED && gTfOn[5] && !gTfOn[9], "testo storto: riparte dai DEFAULT, nessun crash");
  ObjectSetString(0, "ABTGSTU_STATO", OBJPROP_TEXT, "STU1|1|00000111100|10");
  OnDeinit(REASON_PARAMETERS);
  CHECK(count_prefix("ABTGSTU_") == 0, "OnDeinit(parametri cambiati): via anche STATO (si riparte dai nuovi DEFAULT)");

  printf("\nSIM: %s (%d FAIL)\n", g_fail ? "FAIL" : "TUTTO OK", g_fail);
  return g_fail ? 1 : 0;
}
