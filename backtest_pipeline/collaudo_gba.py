#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STRATO 1 di mql5/Experts/ABTG_GoldBreakoutATR.mq5 ("GBA", rottura di canale sull'oro, 09/10/2026),
nello stile di collaudo_bulge_azzurra.py.

Qui NON c'e' MetaEditor: niente compila l'MQL5, niente gira nel tester. Si prova quello che si puo' provare
a tavolino, e si dice cosa resta fuori.

  S) STATICO sul sorgente vero: ASCII puro, LF, parentesi bilanciate fuori da commenti/stringhe; niente
     WebRequest/SendMail/SendNotification/SendFTP/#import/OrderSend; input = esattamente i nomi, tipi e
     default dichiarati (valori della foto + decisioni dichiarate); magic di default e il suo blocco 7758xx
     assenti da TUTTO il repo fuori dai file del GBA; ogni trade.Buy/trade.Sell preceduto dalla riga del
     Guardian (esattamente 2 invii, dentro GbaApri); chiusure e modifiche solo in GbaGestisci; SL iniziale
     = InpSL_ATR x ATR; slippage passato a CTrade; commento <= 21 caratteri; handle rilasciati; OnTick
     gestisce PRIMA e valuta il segnale DOPO; log di avvio con TUTTI gli input; contatore e log dello
     spread (spec. par. 9); PrintFormat/StringFormat: segnaposto == argomenti.
  P) FUNZIONI VERE estratte dal .mq5 e compilate C++ (g++ -Wall): il nucleo dell'autotest dell'EA deve dare
     0 casi falliti; ogni funzione pura (canale, direzione, spread, ora, giorno, decisione, estremo, azione
     di gestione, lotti) confrontata con uno SPECCHIO PYTHON scritto dalla specifica su migliaia di casi
     casuali (prezzi sulla griglia 0,01 per provocare i pareggi) piu' casi di bordo a mano.
  X) SIMULAZIONE: le letture di mercato VERE dell'EA (GbaLeggiSegnale, GbaLeggiGestione, GbaShiftChiusa,
     GbaLeggiBuffer, con CopyHigh/CopyLow/CopyClose/CopyBuffer/iBarShift/iTime e ArraySetAsSeries
     simulati con la semantica MQL5) guidate barra per barra e tick per tick (O, poi L/H, poi C) su serie
     casuali, con EMA e ATR anche su un TF diverso dal segnale (M5); lo specchio Python indipendente fa la
     stessa simulazione dalla specifica; le operazioni (lato, barra, prezzi, SL iniziale, uscita, motivo,
     numero di spostamenti dello SL, SL finale) e i contatori dei segnali scartati devono coincidere.
  M) MUTANTI CIECHI applicati a una COPIA fuori dal repo: per ognuno si rigira la suite ridotta; deve
     fallire almeno un controllo, e i mutanti di LOGICA devono essere presi da P o X (non solo dallo
     statico), cosi' si prova che i controlli di comportamento mordono davvero.

Uso:   python3 backtest_pipeline/collaudo_gba.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5 (MetaEditor assente), CTrade e riempimenti,
Guardian (fuori dalla sua riga), GbaApri/GbaGestisci/GbaPnlGiorno/GbaMargineOk (API di conto), iMA/iATR del
terminale, tick reali, spread reale BCM, NESSUN backtest.
"""
import math
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "mql5/Experts/ABTG_GoldBreakoutATR.mq5")
PROPRI = {"mql5/Experts/ABTG_GoldBreakoutATR.mq5", "backtest_pipeline/collaudo_gba.py",
          "report/EA_GBA_NOTE_2026-10-09.md", "report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md"}
SENZA_MUTANTI = "--senza-mutanti" in sys.argv
FAILS = []


def check(cond, msg, bag=None, quiet=False):
    if not quiet:
        print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        (FAILS if bag is None else bag).append(msg)
    return cond


# ===========================================================================
# utilita' di lettura del sorgente (come collaudo_bulge_azzurra.py)
# ===========================================================================
def maschera(src):
    """stessa lunghezza del sorgente: commenti -> spazi, contenuto delle stringhe -> 'x' (virgolette tenute)."""
    out = list(src)
    i, n = 0, len(src)
    while i < n:
        if src.startswith("//", i):
            j = src.find("\n", i)
            j = n if j < 0 else j
            for k in range(i, j):
                out[k] = " "
            i = j
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            j = n if j < 0 else j + 2
            for k in range(i, j):
                if out[k] != "\n":
                    out[k] = " "
            i = j
            continue
        if src[i] == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            for k in range(i + 1, min(j, n)):
                out[k] = "x"
            i = j + 1
            continue
        if src[i] == "'":
            j = i + 1
            while j < n and src[j] != "'":
                j += 2 if src[j] == "\\" else 1
            for k in range(i + 1, min(j, n)):
                out[k] = "x"
            i = j + 1
            continue
        i += 1
    return "".join(out)


def funzioni(src):
    """nome -> testo (dalla riga della firma alla graffa che chiude), solo funzioni a colonna 0."""
    code = maschera(src)
    out = {}
    for m in re.finditer(r"(?m)^(?:[A-Za-z_]\w*\s+)+?(\w+)\s*\([^;{}]*\)\s*\{", code):
        nome = m.group(1)
        if nome in ("if", "for", "while", "switch"):
            continue
        i = code.index("{", m.start())
        d = 0
        for j in range(i, len(code)):
            if code[j] == "{":
                d += 1
            elif code[j] == "}":
                d -= 1
                if d == 0:
                    out[nome] = src[m.start():j + 1]
                    break
    return out


def chiusa(code, i):
    d = 0
    for j in range(i, len(code)):
        if code[j] == "(":
            d += 1
        elif code[j] == ")":
            d -= 1
            if d == 0:
                return j
    return -1


def argomenti(code, i, j):
    inner = code[i + 1:j]
    if inner.strip() == "":
        return []
    out, d, start = [], 0, 0
    for k, ch in enumerate(inner):
        if ch in "([{":
            d += 1
        elif ch in ")]}":
            d -= 1
        elif ch == "," and d == 0:
            out.append((i + 1 + start, i + 1 + k))
            start = k + 1
    out.append((i + 1 + start, j))
    return out


def inputs(src):
    code = maschera(src)
    out = {}
    for m in re.finditer(r"(?m)^input\s+(\w+)\s+(\w+)\s*=\s*([^;]+);", code):
        out[m.group(2)] = (m.group(1), src[m.start(3):m.end(3)].strip())
    return out


# ===========================================================================
# S) STATICO
# ===========================================================================
INPUT_ATTESI = {
    "InpSymbol": ("string", '""'), "InpSignalTF": ("ENUM_TIMEFRAMES", "PERIOD_M1"),
    "InpTrendTF": ("ENUM_TIMEFRAMES", "PERIOD_CURRENT"), "InpAtrTF": ("ENUM_TIMEFRAMES", "PERIOD_CURRENT"),
    "InpChannelBars": ("int", "48"), "InpEmaPeriod": ("int", "100"), "InpAtrPeriod": ("int", "14"),
    "InpSpreadMaxATR": ("double", "0.05"), "InpAllowLong": ("bool", "true"), "InpAllowShort": ("bool", "true"),
    "InpSL_ATR": ("double", "2.5"), "InpTrail_ATR": ("double", "2.5"), "InpTrailAtrMode": ("int", "0"),
    "InpTimeExitBars": ("int", "48"), "InpUseBreakeven": ("bool", "true"), "InpBE_TriggerATR": ("double", "1.0"),
    "InpBE_OffsetATR": ("double", "0.0"), "InpSlippagePoints": ("int", "30"), "InpMaxDailyLoss": ("double", "0.0"),
    "InpCheckFreeMargin": ("bool", "true"), "InpHourStart": ("int", "0"), "InpHourEnd": ("int", "24"),
    "InpLotMode": ("int", "0"), "InpLots": ("double", "1.00"), "InpRiskPct": ("double", "0.25"),
    "InpMagic": ("long", "775800"), "InpComment": ("string", '"GBA"'), "InpUsaGuardian": ("bool", "true"),
    "InpVerbose": ("bool", "true"), "InpAutoTest": ("bool", "true"),
}
FUNZIONI_ATTESE = {
    "Log", "GbaCanale", "GbaDirezione", "GbaSpreadOk", "GbaOraOk", "GbaGiornoBloccato", "GbaDecidi",
    "GbaEstremo", "GbaBeArmato", "GbaSLProposto", "GbaArrotonda", "GbaSLMigliore", "GbaSLValido",
    "GbaUscitaTempo", "GbaAzione", "GbaLottiRischio", "GbaLottiNorm", "GbaShiftChiusa", "GbaLeggiBuffer",
    "GbaLeggiSegnale", "GbaLeggiGestione", "GetFillingMode", "GbaPosizioneAperta", "GbaPnlGiorno",
    "GbaMargineOk", "GbaTickValue", "GbaLotti", "GbaApri", "GbaNuovaBarra", "GbaStampaConta", "GbaMotivoTesto",
    "GbaGestisci", "OnInit", "OnDeinit", "OnTick", "GbaLogAvvio", "GbaCaso", "GbaAutotestNucleo", "AutoTestGba",
}
RIGA_GUARDIAN = 'if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_GoldBreakoutATR")) return;'
_CACHE_MAGIC = {}


def magic_libero(val):
    """file del repo (tracciati + non tracciati) che contengono il numero, TOLTI i file del GBA."""
    if val in _CACHE_MAGIC:
        return _CACHE_MAGIC[val]
    r = subprocess.run(["git", "grep", "-lE", "--untracked", "(^|[^0-9])%s([^0-9]|$)" % val],
                       cwd=ROOT, capture_output=True, text=True)
    altri = []
    for x in sorted(set(x for x in r.stdout.split("\n") if x.strip()) - PROPRI):
        try:
            with open(os.path.join(ROOT, x), "rb") as f:
                if b"ABTG_GoldBreakoutATR" in f.read():
                    continue
        except OSError:
            pass
        altri.append(x)
    _CACHE_MAGIC[val] = altri
    return altri


def conta_segnaposto(fmt):
    return len(re.findall(r"%[-+ 0#]*\d*(?:\.\d+)?(?:I64|ll|l|h)?[sdifgeExXcu]", fmt.replace("%%", "")))


def statico(raw, bag, quiet=False):
    try:
        src = raw.decode("ascii")
    except UnicodeDecodeError as ex:
        bag.append("non ASCII puro: %s" % ex)
        src = raw.decode("latin-1")
    check("\r" not in src, "fine riga LF", bag, quiet=quiet)
    code = maschera(src)
    for a, b in ("()", "[]", "{}"):
        check(code.count(a) == code.count(b), "parentesi %s%s bilanciate" % (a, b), bag, quiet=quiet)
    vietati = re.findall(r"\b(WebRequest|SendMail|SendNotification|SendFTP|OrderSend|OrderSendAsync)\b|#import", code)
    check(not vietati, "niente WebRequest/SendMail/SendNotification/SendFTP/OrderSend/#import %s" % vietati, bag, quiet=quiet)
    check("#include <ABTG_PausaGuardian.mqh>" in src and "#include <Trade\\Trade.mqh>" in src,
          "include: Trade.mqh + ABTG_PausaGuardian.mqh", bag, quiet=quiet)
    fn = funzioni(src)
    check(set(fn) == FUNZIONI_ATTESE, "funzioni = insieme dichiarato (in piu' %s, mancanti %s)"
          % (sorted(set(fn) - FUNZIONI_ATTESE), sorted(FUNZIONI_ATTESE - set(fn))), bag, quiet=quiet)
    # input
    ii = inputs(src)
    diff_in = sorted(k for k in set(INPUT_ATTESI) | set(ii) if INPUT_ATTESI.get(k) != ii.get(k))
    check(not diff_in, "input: nomi/tipi/default dichiarati (%d input) %s"
          % (len(ii), ["%s: atteso %s, trovato %s" % (k, INPUT_ATTESI.get(k), ii.get(k)) for k in diff_in]),
          bag, quiet=quiet)
    # magic
    mg = ii.get("InpMagic", ("", ""))[1]
    altri = magic_libero(mg) if re.fullmatch(r"\d{6}", mg) else ["(magic non a 6 cifre)"]
    check(not altri, "magic %s assente da tutto il repo fuori dai file GBA (git grep --untracked) %s" % (mg, altri[:5]),
          bag, quiet=quiet)
    altri_b = magic_libero("%s[0-9]{2}" % mg[:4]) if re.fullmatch(r"\d{6}", mg) else ["?"]
    check(not altri_b, "blocco %sxx assente da tutto il repo fuori dai file GBA %s" % (mg[:4], altri_b[:5]),
          bag, quiet=quiet)
    # commento
    cm = ii.get("InpComment", ("", '""'))[1].strip('"')
    check(len(cm) + 2 <= 21, "commento ordini \"%s_L\" <= 21 caratteri (%d)" % (cm, len(cm) + 2), bag, quiet=quiet)
    # Guardian prima di ogni invio di apertura, solo in GbaApri
    righe = src.split("\n")
    mrighe = code.split("\n")
    invii = 0
    for i, ln in enumerate(mrighe):
        if re.search(r"\btrade\.(Buy|Sell)\s*\(", ln):
            invii += 1
            j = i - 1
            while j >= 0 and righe[j].strip() == "":
                j -= 1
            check(righe[j].strip() == RIGA_GUARDIAN, "riga %d: trade.Buy/Sell preceduto dal Guardian" % (i + 1),
                  bag, quiet=quiet)
    ap = fn.get("GbaApri", "")
    check(invii == 2 and len(re.findall(r"\btrade\.(?:Buy|Sell)\s*\(", maschera(ap))) == 2,
          "esattamente 2 invii di apertura, tutti in GbaApri (%d)" % invii, bag, quiet=quiet)
    check(ap.count(RIGA_GUARDIAN) == 2, "GbaApri: due righe del Guardian (BUY e SELL)", bag, quiet=quiet)
    ge = fn.get("GbaGestisci", "")
    for op in ("PositionClose", "PositionModify"):
        check(len(re.findall(r"\btrade\.%s\s*\(" % op, code)) == 1 and ("trade.%s(" % op) in ge,
              "trade.%s una volta sola, in GbaGestisci (mai Guardian sulle chiusure)" % op, bag, quiet=quiet)
    check("ABTG_GuardiaIngresso" not in ge, "GbaGestisci non chiama il Guardian", bag, quiet=quiet)
    check("double slDist   = InpSL_ATR * atr;" in ap and "sl = NormalizeDouble(GbaArrotonda(sl, tickSize), digits);" in ap
          and "GbaSLValido(isLong, sl, bid, ask, minDist)" in ap and "SYMBOL_TRADE_STOPS_LEVEL" in ap,
          "GbaApri: SL = InpSL_ATR x ATR, arrotondato al tick, normalizzato, controllato contro STOPS_LEVEL", bag, quiet=quiet)
    check("rc != TRADE_RETCODE_DONE" in ap and "trade.ResultRetcode()" in ap, "GbaApri: retcode controllato", bag, quiet=quiet)
    check("InpCheckFreeMargin && !GbaMargineOk(" in ap, "GbaApri: margine libero verificato", bag, quiet=quiet)
    oi = fn.get("OnInit", "")
    check("trade.SetDeviationInPoints((ulong)InpSlippagePoints);" in oi and "trade.SetExpertMagicNumber(InpMagic);" in oi,
          "OnInit: magic e slippage a CTrade", bag, quiet=quiet)
    check("iMA(g_sym, g_tfTrend, InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE)" in oi and "iATR(g_sym, g_tfAtr, InpAtrPeriod)" in oi,
          "OnInit: EMA sul TF di trend, ATR sul TF dell'ATR", bag, quiet=quiet)
    check("g_tfTrend = (InpTrendTF  == PERIOD_CURRENT) ? g_tfSig : InpTrendTF;" in oi
          and "g_tfAtr   = (InpAtrTF    == PERIOD_CURRENT) ? g_tfSig : InpAtrTF;" in oi,
          "OnInit: PERIOD_CURRENT di EMA/ATR = TF del SEGNALE (semantica dichiarata)", bag, quiet=quiet)
    check("StringLen(InpComment) + 2 > 21" in oi and "INIT_PARAMETERS_INCORRECT" in oi,
          "OnInit: commento troppo lungo e input assurdi fermano l'EA", bag, quiet=quiet)
    check("ArrayInitialize(g_conta, 0);" in oi, "OnInit: contatori azzerati", bag, quiet=quiet)
    od = fn.get("OnDeinit", "")
    check("IndicatorRelease(g_hEma)" in od and "IndicatorRelease(g_hAtr)" in od and 'GbaStampaConta("FINE")' in od,
          "OnDeinit: handle rilasciati + contatori stampati", bag, quiet=quiet)
    ot = fn.get("OnTick", "")
    pg, pn = ot.find("GbaGestisci();"), ot.find("GbaNuovaBarra(t0);")
    check(0 <= pg < pn and "if(g_lastBar == 0) { g_lastBar = t0; return; }" in ot,
          "OnTick: gestione PRIMA del segnale; prima barra vista non valutata", bag, quiet=quiet)
    # log di avvio: tutti gli input
    la = fn.get("GbaLogAvvio", "")
    mancano = sorted(k for k in INPUT_ATTESI if (k + "=") not in la)
    check(not mancano, "log di avvio con TUTTI gli input (mancano %s)" % mancano, bag, quiet=quiet)
    check("100 oz" in la and "SPREAD (ASSE)" in la and "ORA SERVER" in la,
          "log di avvio: 1 lotto = 100 oz, asse spread, orologio server", bag, quiet=quiet)
    # spread: contatore e righe dei segnali (spec. par. 9)
    sc = fn.get("GbaStampaConta", "")
    check("g_conta[GBA_SPREAD]" in sc and "g_conta[GBA_OK]" in sc, "contatore dei segnali scartati per spread",
          bag, quiet=quiet)
    nb = fn.get("GbaNuovaBarra", "")
    mm = maschera(nb)
    salt = [m.start() for m in re.finditer(r"PrintFormat\s*\(", mm)]
    righe_ok = 0
    for s0 in salt:
        j = chiusa(mm, mm.index("(", s0))
        corpo = nb[s0:j]
        if "spreadPct" in corpo and "stopSpread" in corpo and "stop/spread" in corpo and "% ATR" in corpo:
            righe_ok += 1
    check(righe_ok == 2 and "g_conta[motivo]++" in nb and "motivo == GBA_SPREAD" in nb,
          "righe di segnale (presa e scartata) con spread/ATR %% e stop/spread; lo scarto per spread si stampa sempre (%d)"
          % righe_ok, bag, quiet=quiet)
    # autotest
    at = fn.get("AutoTestGba", "")
    check("GbaAutotestNucleo()" in at and "ABTG_AutotestGuardia()" in at, "autotest: nucleo + Guardian", bag, quiet=quiet)
    check("if(InpAutoTest) AutoTestGba();" in oi and "GbaLogAvvio();" in oi, "OnInit: log di avvio + autotest", bag, quiet=quiet)
    # PrintFormat/StringFormat
    nfmt = 0
    for mm2 in re.finditer(r"\b(PrintFormat|StringFormat)\s*\(", code):
        i = code.index("(", mm2.start())
        j = chiusa(code, i)
        args = argomenti(code, i, j)
        # formato = concatenazione di letterali adiacenti
        fmt_txt = src[args[0][0]:args[0][1]].strip()
        lett = re.findall(r'"((?:[^"\\]|\\.)*)"', fmt_txt)
        if not lett or re.sub(r'"(?:[^"\\]|\\.)*"', "", fmt_txt).strip():
            continue
        n = conta_segnaposto("".join(lett))
        nfmt += 1
        if n != len(args) - 1:
            check(False, "PrintFormat riga %d: %d segnaposto, %d argomenti" % (src[:i].count("\n") + 1, n, len(args) - 1),
                  bag, quiet=quiet)
    check(nfmt >= 20, "PrintFormat/StringFormat controllati: %d" % nfmt, bag, quiet=quiet)
    return src


# ===========================================================================
# C++: shim (API MQL5 simulate), estrazione, driver
# ===========================================================================
SHIM = r"""
#include <cmath>
#include <cfloat>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
#include <map>
#include <initializer_list>
#include <iostream>
#include <algorithm>
typedef std::string string;
typedef int ENUM_TIMEFRAMES;
typedef long long datetime;
#define INVALID_HANDLE (-1)
#define EMPTY_VALUE DBL_MAX
struct Arr {
  std::vector<double> v; bool series = false;
  Arr() {}
  Arr(std::initializer_list<double> l) : v(l) {}
  int ix(int i) const { if(i < 0 || i >= (int)v.size()) { std::printf("OOR %d %d\n", i, (int)v.size()); std::fflush(stdout); std::exit(3); }
                        return series ? (int)v.size() - 1 - i : i; }
  double &operator[](int i) { return v[ix(i)]; }
  const double &operator[](int i) const { return v[ix(i)]; }
};
static int ArraySize(const Arr &a) { return (int)a.v.size(); }
static bool ArraySetAsSeries(Arr &a, bool f) { a.series = f; return true; }
static double MathAbs(double x) { return std::fabs(x); }
static double MathRound(double x) { return std::round(x); }
static double MathFloor(double x) { return std::floor(x); }
static double MathMax(double a, double b) { return a > b ? a : b; }
static double MathMin(double a, double b) { return a < b ? a : b; }
template<typename... T> static void Print(T...) {}
template<typename... T> static void PrintFormat(T...) {}
// --- globali dell'EA che il cablaggio legge
string g_sym = "XAUUSD";
ENUM_TIMEFRAMES g_tfSig = 1, g_tfTrend = 1, g_tfAtr = 1;
int g_hEma = 10, g_hAtr = 11;
int InpChannelBars = 48, InpTrailAtrMode = 0;
bool InpVerbose = false;
// --- mercato simulato: per TF, barre in ordine cronologico; la barra "in corso" del TF del segnale e' parziale
struct Serie { std::vector<long long> T; std::vector<double> H, L, C; };
std::map<int, Serie> TFS;
std::map<int, std::pair<int, std::vector<double> > > BUF;
long long NOW = 0; double PH = 0, PL = 0, PC = 0;
static int curIdx(int tf) { Serie &s = TFS[tf]; int c = -1; for(int j = 0; j < (int)s.T.size(); j++) if(s.T[j] <= NOW) c = j; return c; }
int iBarShift(const string &, int tf, datetime t, bool exact = false) {
  (void)exact; Serie &s = TFS[tf]; int c = curIdx(tf); for(int j = c; j >= 0; j--) if(s.T[j] <= t) return c - j; return -1; }
datetime iTime(const string &, int tf, int sh) { int c = curIdx(tf); int j = c - sh; if(c < 0 || sh < 0 || j < 0) return 0; return TFS[tf].T[j]; }
static int copia(int tf, int start, int count, Arr &a, int quale) {
  int c = curIdx(tf); if(c < 0 || count <= 0 || start < 0) return -1;
  int nuovo = c - start, vecchio = nuovo - count + 1; if(vecchio < 0) return -1;
  Serie &s = TFS[tf]; a.v.clear();
  for(int j = vecchio; j <= nuovo; j++) {
    double x;
    if(j == c && tf == g_tfSig) x = (quale == 0 ? PH : quale == 1 ? PL : PC);
    else x = (quale == 0 ? s.H[j] : quale == 1 ? s.L[j] : s.C[j]);
    a.v.push_back(x); }
  return count; }
int CopyHigh(const string &, int tf, int start, int count, Arr &a) { return copia(tf, start, count, a, 0); }
int CopyLow(const string &, int tf, int start, int count, Arr &a) { return copia(tf, start, count, a, 1); }
int CopyClose(const string &, int tf, int start, int count, Arr &a) { return copia(tf, start, count, a, 2); }
int CopyBuffer(int h, int, int start, int count, Arr &a) {
  if(!BUF.count(h)) return -1; int tf = BUF[h].first; std::vector<double> &v = BUF[h].second;
  int c = curIdx(tf); if(c < 0 || count <= 0 || start < 0) return -1;
  int nuovo = c - start, vecchio = nuovo - count + 1; if(vecchio < 0 || nuovo >= (int)v.size()) return -1;
  a.v.assign(v.begin() + vecchio, v.begin() + nuovo + 1); return count; }
"""

DRIVER = r"""
#include "shim.h"
#include "pure.h"
static std::vector<double> rd(int n) { std::vector<double> v(n); for(int i = 0; i < n; i++) std::cin >> v[i]; return v; }
static std::vector<long long> rdl(int n) { std::vector<long long> v(n); for(int i = 0; i < n; i++) std::cin >> v[i]; return v; }
static void sim() {
  int N, mode, tex, useBE, hS, hE, aL, aS, tfT, tfA; double kSL, kTr, trig, off, kSp, passo;
  std::cin >> N >> kSL >> kTr >> mode >> tex >> useBE >> trig >> off >> kSp >> hS >> hE >> aL >> aS >> tfT >> tfA >> passo;
  InpChannelBars = N; InpTrailAtrMode = mode; g_tfSig = 1; g_tfTrend = tfT; g_tfAtr = tfA;
  int n; std::cin >> n; Serie s1; s1.T = rdl(n); std::vector<double> O = rd(n); s1.H = rd(n); s1.L = rd(n); s1.C = rd(n);
  std::vector<double> S = rd(n);
  int n5; std::cin >> n5; Serie s5; s5.T = rdl(n5); s5.H.assign(n5, 0); s5.L.assign(n5, 0); s5.C.assign(n5, 0);
  TFS.clear(); TFS[1] = s1; TFS[5] = s5;
  int ne; std::cin >> ne; std::vector<double> E = rd(ne); int na; std::cin >> na; std::vector<double> A = rd(na);
  BUF.clear(); BUF[g_hEma] = std::make_pair(tfT, E); BUF[g_hAtr] = std::make_pair(tfA, A);
  bool on = false, isL = false; double op = 0, sl = 0, sl0 = 0; long long tO = 0; int iE = 0, mods = 0;
  int conta[GBA_N_MOTIVI] = {0};
  auto esci = [&](int i, int k, const char *why, double px) {
    std::printf("TR %d %d %.17g %.17g %d %d %s %.17g %d %.17g\n", isL ? 1 : -1, iE, op, sl0, i, k, why, px, mods, sl); on = false; };
  for(int i = 0; i < n; i++) {
    NOW = s1.T[i];
    double path[4]; path[0] = O[i];
    if(s1.C[i] >= O[i]) { path[1] = s1.L[i]; path[2] = s1.H[i]; } else { path[1] = s1.H[i]; path[2] = s1.L[i]; }
    path[3] = s1.C[i];
    for(int k = 0; k < 4; k++) {
      double bid = path[k], ask = bid + S[i];
      if(k == 0) { PH = PL = PC = bid; } else { PH = std::max(PH, bid); PL = std::min(PL, bid); PC = bid; }
      if(on) {
        if(isL && bid <= sl) esci(i, k, "SL", k == 0 ? bid : sl);
        else if(!isL && ask >= sl) esci(i, k, "SL", k == 0 ? ask : sl);
      }
      if(on) {
        int barre = -1; double est = 0, atr = 0;
        if(!GbaLeggiGestione(tO, isL, s1.T[i], barre, est, atr)) { est = 0; atr = 0; }
        double ns = 0;
        int az = GbaAzione(isL, op, sl, bid, ask, est, atr, barre, tex, kTr, useBE != 0, trig, off, 0.0, passo, ns);
        if(az == GBA_AZ_CHIUDI) esci(i, k, "TEMPO", isL ? bid : ask);
        else if(az == GBA_AZ_SPOSTA) { sl = ns; mods++; }
      }
      if(k == 0 && i >= 1) {
        double c1 = 0, hh = 0, ll = 0, ema = 0, atr = 0;
        if(GbaLeggiSegnale(s1.T[i], c1, hh, ll, ema, atr)) {
          int mot = GBA_NO_SEGNALE; int ora = (int)((s1.T[i] % 86400) / 3600);
          int dir = GbaDecidi(c1, hh, ll, ema, atr, S[i], kSp, ora, hS, hE, on, false, aL != 0, aS != 0, mot);
          if(mot != GBA_NO_SEGNALE) conta[mot]++;
          if(dir != 0) {
            bool L = dir > 0; double px = L ? ask : bid;
            double s0 = GbaArrotonda(L ? px - kSL * atr : px + kSL * atr, passo);
            if(GbaSLValido(L, s0, bid, ask, 0.0)) { on = true; isL = L; op = px; sl = s0; sl0 = s0; tO = s1.T[i]; iE = i; mods = 0; }
          }
        }
      }
    }
  }
  if(on) esci(n - 1, 3, "FINE", isL ? s1.C[n - 1] : s1.C[n - 1] + S[n - 1]);
  std::printf("CONTA");
  for(int m = 0; m < GBA_N_MOTIVI; m++) std::printf(" %d", conta[m]);
  std::printf("\nENDSIM\n");
}
int main() {
  std::string cmd;
  while(std::cin >> cmd) {
    if(cmd == "AUTO") { std::printf("%d\n", GbaAutotestNucleo()); }
    else if(cmd == "CAN") { int nn, m; std::cin >> nn >> m; Arr h, l; h.v = rd(m); l.v = rd(m); double hh = -1, ll = -1;
      bool ok = GbaCanale(h, l, nn, hh, ll); std::printf("%d %.17g %.17g\n", ok ? 1 : 0, ok ? hh : 0.0, ok ? ll : 0.0); }
    else if(cmd == "DEC") { double c, hh, ll, e, a, sp, k; int o, hs, he, p, g, al, as;
      std::cin >> c >> hh >> ll >> e >> a >> sp >> k >> o >> hs >> he >> p >> g >> al >> as; int mot = -1;
      int d = GbaDecidi(c, hh, ll, e, a, sp, k, o, hs, he, p, g, al, as, mot); std::printf("%d %d\n", d, mot); }
    else if(cmd == "AZ") { int il, br, mb, ube; double op, cs, b, a, es, at, kt, tr, of, md, ps;
      std::cin >> il >> op >> cs >> b >> a >> es >> at >> br >> mb >> kt >> ube >> tr >> of >> md >> ps; double ns = -1;
      int az = GbaAzione(il, op, cs, b, a, es, at, br, mb, kt, ube, tr, of, md, ps, ns); std::printf("%d %.17g\n", az, ns); }
    else if(cmd == "EST") { int c, il, m; std::cin >> c >> il >> m; Arr h, l; h.v = rd(m); l.v = rd(m);
      std::printf("%.17g\n", GbaEstremo(h, l, c, il)); }
    else if(cmd == "LR") { double s, p, d, tv, ts; std::cin >> s >> p >> d >> tv >> ts; std::printf("%.17g\n", GbaLottiRischio(s, p, d, tv, ts)); }
    else if(cmd == "LN") { double l, st, mi, ma; std::cin >> l >> st >> mi >> ma; std::printf("%.17g\n", GbaLottiNorm(l, st, mi, ma)); }
    else if(cmd == "GIO") { double p, m; std::cin >> p >> m; std::printf("%d\n", GbaGiornoBloccato(p, m) ? 1 : 0); }
    else if(cmd == "SIM") { sim(); }
  }
  return 0;
}
"""

NOMI_ESTRATTI = ["GbaCanale", "GbaDirezione", "GbaSpreadOk", "GbaOraOk", "GbaGiornoBloccato", "GbaDecidi",
                 "GbaEstremo", "GbaBeArmato", "GbaSLProposto", "GbaArrotonda", "GbaSLMigliore", "GbaSLValido",
                 "GbaUscitaTempo", "GbaAzione", "GbaLottiRischio", "GbaLottiNorm", "GbaShiftChiusa",
                 "GbaLeggiBuffer", "GbaLeggiSegnale", "GbaLeggiGestione", "GbaCaso", "GbaAutotestNucleo"]


def to_cxx(block):
    out = re.sub(r"(const\s+)?double\s*&\s*(\w+)\[\]", lambda m: (m.group(1) or "") + "Arr &" + m.group(2), block)
    out = re.sub(r"\bdouble\s+(\w+\[\](?:\s*,\s*\w+\[\])*)\s*;", lambda m: "Arr " + m.group(1).replace("[]", "") + ";", out)
    out = re.sub(r"\bdouble\s+(\w+)\[\d+\]\s*=", r"Arr \1 =", out)
    return out


class Cxx:
    def __init__(self, src, tmp):
        self.ok, self.err = False, ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            self.err = "compilatore C++ assente"
            return
        fn = funzioni(src)
        try:
            defs = "\n".join(re.findall(r"(?m)^#define GBA_\w+\s+\d+\s*$", src))
            pure = defs + "\n\n" + "\n\n".join(to_cxx(fn[n]) for n in NOMI_ESTRATTI)
        except KeyError as ex:
            self.err = "estrazione fallita: %s" % ex
            return
        for nm, txt in (("shim.h", SHIM), ("pure.h", pure), ("drv.cpp", DRIVER)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        r = subprocess.run([cxx, "-std=c++17", "-O1", "-ffp-contract=off", "-Wall", "-Wno-unused-variable",
                            "-Wno-unused-but-set-variable", "-Wno-unused-function", "-o", self.exe,
                            os.path.join(tmp, "drv.cpp")], capture_output=True, text=True)
        self.err = r.stderr
        self.ok = r.returncode == 0

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            return None
        return r.stdout.split("\n")


def g(x):
    return repr(float(x))


# ===========================================================================
# SPECCHIO PYTHON -- scritto dalla SPECIFICA (report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md), non dall'EA
# ===========================================================================
OK, NO_SEGNALE, POSIZIONE, ORA, GIORNO, SPREAD, DATI, LATO = 0, 1, 2, 3, 4, 5, 6, 7
AZ_NULLA, AZ_SPOSTA, AZ_CHIUDI = 0, 1, 2


def py_canale(h, l, n):
    """h[0] = barra di segnale (esclusa); il canale sono le n barre precedenti, h[1..n]."""
    if n < 1 or len(h) < n + 1 or len(l) < n + 1:
        return None
    return max(h[1:n + 1]), min(l[1:n + 1])


def py_direzione(c, hh, ll, ema):
    if c > hh and c > ema:
        return 1
    if c < ll and c < ema:
        return -1
    return 0


def py_ora_ok(o, s, e):
    if s == e:
        return True
    return s <= o < e if s < e else (o >= s or o < e)


def py_decidi(c, hh, ll, ema, atr, spr, k, ora, hs, he, pos, gio, al, ash):
    d = py_direzione(c, hh, ll, ema)
    if d == 0:
        return 0, NO_SEGNALE
    if (d > 0 and not al) or (d < 0 and not ash):
        return 0, LATO
    if pos:
        return 0, POSIZIONE
    if not py_ora_ok(ora, hs, he):
        return 0, ORA
    if gio:
        return 0, GIORNO
    if atr <= 0:
        return 0, DATI
    if k > 0 and not (spr <= k * atr):
        return 0, SPREAD
    return d, OK


def py_giorno(p, m):
    return m > 0 and p <= -m


def tick_round(x, p):
    if p <= 0:
        return x
    q = x / p
    return (math.floor(q + 0.5) if q >= 0 else -math.floor(-q + 0.5)) * p


def py_azione(il, op, cs, bid, ask, est, atr, barre, maxb, kt, ube, trig, off, md, passo):
    if maxb > 0 and barre >= maxb:
        return AZ_CHIUDI, 0.0
    if atr <= 0:
        return AZ_NULLA, 0.0
    cands = []
    if kt > 0:
        cands.append(est - kt * atr if il else est + kt * atr)
    prezzo = bid if il else ask
    if ube and ((prezzo - op >= trig * atr) if il else (op - prezzo >= trig * atr)):
        cands.append(op + off * atr if il else op - off * atr)
    if not cands:
        return AZ_NULLA, 0.0
    c = max(cands) if il else min(cands)
    if c <= 0:
        return AZ_NULLA, 0.0
    c = tick_round(c, passo)
    half = passo * 0.5 if passo > 0 else 0.0
    if cs > 0 and not ((c > cs + half) if il else (c < cs - half)):
        return AZ_NULLA, 0.0
    if not ((c < bid and bid - c >= md) if il else (c > ask and c - ask >= md)):
        return AZ_NULLA, 0.0
    return AZ_SPOSTA, c


def py_lotti_rischio(s, p, d, tv, ts):
    if s <= 0 or p <= 0 or d <= 0 or tv <= 0 or ts <= 0:
        return 0.0
    return (s * p / 100.0) / (d / ts * tv)


def py_lotti_norm(lots, step, vmin, vmax):
    if step <= 0 or lots <= 0:
        return 0.0
    v = math.floor(lots / step + 1e-9) * step
    if v < vmin - 1e-12:
        return 0.0
    if vmax > 0 and v > vmax:
        v = vmax
    return v


# ===========================================================================
# P) FUNZIONI PURE
# ===========================================================================
def griglia(r, lo, hi):
    return round(r.uniform(lo, hi), 2)


def casi_puri(cx, bag, quiet=False, ridotto=False):
    r = random.Random(20261009)
    out = cx.run("AUTO\n")
    check(out is not None and out[0].strip() == "0", "nucleo dell'autotest VERO dell'EA: 0 casi falliti (%s)"
          % (out[0] if out else "crash"), bag, quiet=quiet)
    giri = 300 if ridotto else 3000
    # canale
    righe, attese = [], []
    for _ in range(giri):
        m = r.randint(1, 12)
        n = r.randint(0, m)
        h = [griglia(r, 1990, 2010) for _ in range(m)]
        l = [x - griglia(r, 0, 3) for x in h]
        righe.append("CAN %d %d %s %s" % (n, m, " ".join(map(g, h)), " ".join(map(g, l))))
        attese.append(py_canale(h, l, n))
    res = cx.run("\n".join(righe) + "\n") or []
    bad = 0
    for a, o in zip(attese, res):
        p = o.split()
        if a is None:
            bad += p[0] != "0"
        else:
            bad += not (p[0] == "1" and float(p[1]) == a[0] and float(p[2]) == a[1])
    check(len(res) >= giri and bad == 0, "GbaCanale = specchio su %d casi (esclusa la barra di segnale, n e n+1): %d diversi"
          % (giri, bad), bag, quiet=quiet)
    # decisione
    righe, attese = [], []
    for _ in range(giri):
        hh = griglia(r, 2000, 2010)
        ll = hh - griglia(r, 1, 15)
        c = r.choice([hh, ll, griglia(r, ll - 3, hh + 3), hh + 0.01, ll - 0.01])
        ema = r.choice([c, griglia(r, ll - 5, hh + 5)])
        atr = r.choice([0.0, 1.0, griglia(r, 0.2, 3.0)])
        k = r.choice([0.0, 0.05, 0.10, 0.20, 0.35])
        spr = r.choice([round(k * atr, 2), griglia(r, 0.0, 0.5)])
        if r.random() < 0.15:
            spr = k * atr
        ora, hs, he = r.randint(0, 23), r.randint(0, 23), r.randint(0, 24)
        pos, gio, al, ash = (r.random() < 0.2), (r.random() < 0.2), (r.random() < 0.85), (r.random() < 0.85)
        righe.append("DEC %s %s %s %s %s %s %s %d %d %d %d %d %d %d" % (g(c), g(hh), g(ll), g(ema), g(atr), g(spr), g(k),
                                                                         ora, hs, he, pos, gio, al, ash))
        attese.append(py_decidi(c, hh, ll, ema, atr, spr, k, ora, hs, he, pos, gio, al, ash))
    res = cx.run("\n".join(righe) + "\n") or []
    bad = sum(1 for a, o in zip(attese, res) if tuple(map(int, o.split())) != a)
    check(len(res) >= giri and bad == 0, "GbaDecidi (canale, EMA, lato, posizione, ora, giorno, ATR, spread) = specchio su %d casi: %d diversi"
          % (giri, bad), bag, quiet=quiet)
    # azione di gestione
    righe, attese = [], []
    for _ in range(giri):
        il = r.random() < 0.5
        op = griglia(r, 1995, 2005)
        atr = r.choice([0.0, 2.0, griglia(r, 0.3, 3.0), r.uniform(0.3, 3.0)])
        bid = griglia(r, op - 4, op + 6) if il else griglia(r, op - 6, op + 4)
        if r.random() < 0.2:
            bid = round(op + (1 if il else -1) * r.choice([1.0, 0.5]) * atr - (0 if il else 0.3), 2)
        ask = round(bid + r.choice([0.0, 0.05, 0.3]), 2)
        est = round(max(bid, op) + griglia(r, 0, 4), 2) if il else round(min(bid, op) - griglia(r, 0, 4), 2)
        cs = r.choice([0.0, griglia(r, op - 6, op + 6)])
        barre, maxb = r.randint(-1, 60), r.choice([0, 48, 12])
        kt, ube = r.choice([0.0, 2.5, 1.0]), r.random() < 0.6
        trig, off = r.choice([1.0, 0.0, 0.5]), r.choice([0.0, 0.3, -0.2])
        md, ps = r.choice([0.0, 0.0, 0.5, 3.0]), r.choice([0.01, 0.01, 0.0])
        righe.append("AZ %d %s %s %s %s %s %s %d %d %s %d %s %s %s %s" % (il, g(op), g(cs), g(bid), g(ask), g(est), g(atr), barre, maxb,
                                                                          g(kt), ube, g(trig), g(off), g(md), g(ps)))
        attese.append(py_azione(il, op, cs, bid, ask, est, atr, barre, maxb, kt, ube, trig, off, md, ps))
    res = cx.run("\n".join(righe) + "\n") or []
    bad = 0
    for a, o in zip(attese, res):
        p = o.split()
        bad += not (int(p[0]) == a[0] and (a[0] != AZ_SPOSTA or abs(float(p[1]) - a[1]) < 1e-9))
    check(len(res) >= giri and bad == 0, "GbaAzione (tempo, trailing, breakeven, solo a favore, stops level) = specchio su %d casi: %d diversi"
          % (giri, bad), bag, quiet=quiet)
    # estremo, lotti, giorno
    righe, attese = [], []
    for _ in range(giri // 3):
        m = r.randint(1, 10)
        c = r.randint(1, m)
        il = r.random() < 0.5
        h = [griglia(r, 1990, 2010) for _ in range(m)]
        l = [x - griglia(r, 0, 3) for x in h]
        righe.append("EST %d %d %d %s %s" % (c, il, m, " ".join(map(g, h)), " ".join(map(g, l))))
        attese.append(("E", max(h[:c]) if il else min(l[:c])))
        lots = r.choice([r.uniform(0, 5), 1.0, 0.0599, 0.005, 150.0, 10.0])
        righe.append("LN %s 0.01 0.01 100" % g(lots))
        attese.append(("V", py_lotti_norm(lots, 0.01, 0.01, 100.0)))
        s, p, d = r.choice([10000.0, 5400.0, 0.0]), r.choice([0.25, 1.0, 0.0]), griglia(r, 0, 8)
        righe.append("LR %s %s %s 1 0.01" % (g(s), g(p), g(d)))
        attese.append(("V", py_lotti_rischio(s, p, d, 1.0, 0.01)))
        pn, mx = r.choice([-100.0, -99.99, griglia(r, -300, 100)]), r.choice([0.0, 100.0])
        righe.append("GIO %s %s" % (g(pn), g(mx)))
        attese.append(("B", 1 if py_giorno(pn, mx) else 0))
    res = cx.run("\n".join(righe) + "\n") or []
    bad = 0
    for (t, a), o in zip(attese, res):
        bad += (int(o) != a) if t == "B" else (abs(float(o) - a) > 1e-9)
    check(len(res) >= len(attese) and bad == 0, "GbaEstremo, GbaLottiNorm, GbaLottiRischio, GbaGiornoBloccato = specchio su %d casi: %d diversi"
          % (len(attese), bad), bag, quiet=quiet)


# ===========================================================================
# X) SIMULAZIONE
# ===========================================================================
T0 = 1767225600  # 2026-01-01 00:00 (ora server simulata)


def serie(seed, n):
    r = random.Random(seed)
    p, T, O, H, L, C, S = 2000.0, [], [], [], [], [], []
    drift = 0.0
    for i in range(n):
        if i % 200 == 0:
            drift = r.choice([-0.25, -0.1, 0.0, 0.1, 0.25])
        o = round(p + r.gauss(0, 0.05), 2)
        c = round(o + drift + r.gauss(0, 0.6), 2)
        h = round(max(o, c) + abs(r.gauss(0, 0.4)), 2)
        lo = round(min(o, c) - abs(r.gauss(0, 0.4)), 2)
        T.append(T0 + 60 * i)
        O.append(o)
        H.append(h)
        L.append(lo)
        C.append(c)
        S.append(r.choice([0.03, 0.04, 0.05, 0.06, 0.08, 0.12, 0.3]))
        p = c
    return T, O, H, L, C, S


def ema(xs, per):
    out, k, e = [], 2.0 / (per + 1.0), None
    for x in xs:
        e = x if e is None else e + k * (x - e)
        out.append(e)
    return out


def atr_wilder(H, L, C, per):
    out, a = [], None
    for i in range(len(C)):
        tr = H[i] - L[i] if i == 0 else max(H[i] - L[i], abs(H[i] - C[i - 1]), abs(L[i] - C[i - 1]))
        a = tr if a is None else (a * (per - 1) + tr) / per
        out.append(a)
    return out


def m5(T, H, L, C):
    T5, H5, L5, C5 = [], [], [], []
    for i in range(len(T)):
        t5 = T[i] - (T[i] % 300)
        if not T5 or T5[-1] != t5:
            T5.append(t5)
            H5.append(H[i])
            L5.append(L[i])
            C5.append(C[i])
        else:
            H5[-1] = max(H5[-1], H[i])
            L5[-1] = min(L5[-1], L[i])
            C5[-1] = C[i]
    return T5, H5, L5, C5


class Cfg:
    def __init__(self, nome, **kw):
        self.nome = nome
        self.N, self.kSL, self.kTr, self.mode, self.tex = 48, 2.5, 2.5, 0, 48
        self.useBE, self.trig, self.off, self.kSp = 1, 1.0, 0.0, 0.05
        self.hS, self.hE, self.aL, self.aS = 0, 24, 1, 1
        self.tfT, self.tfA, self.passo, self.emaP, self.atrP = 1, 1, 0.01, 100, 14
        self.__dict__.update(kw)


CFGS = [
    Cfg("default (replica foto)"),
    Cfg("spread 0,35", kSp=0.35),
    Cfg("spread 0,10, BE spento, ATR fisso", kSp=0.10, useBE=0, mode=1),
    Cfg("spread 0,20, trailing 0, tempo 0, ore 22-6", kSp=0.20, kTr=0.0, tex=0, hS=22, hE=6),
    Cfg("N=10 EMA20 tempo 12 BE+0,3 solo long", N=10, emaP=20, tex=12, off=0.3, aS=0, kSp=0.35),
    Cfg("EMA su M5, ATR su M1", tfT=5, N=20, kSp=0.35),
    Cfg("EMA su M1, ATR su M5, ATR fisso", tfA=5, mode=1, N=20, kSp=0.20, trig=0.5),
    Cfg("solo short, spread spento, ore 3-11", aL=0, kSp=0.0, hS=3, hE=11, N=24),
]


def buffer_tf(tf, cfg, T, H, L, C):
    if tf == 1:
        return T, ema(C, cfg.emaP), atr_wilder(H, L, C, cfg.atrP)
    T5, H5, L5, C5 = m5(T, H, L, C)
    return T5, ema(C5, cfg.emaP), atr_wilder(H5, L5, C5, cfg.atrP)


def chiusa_a(Ttf, t):
    """indice cronologico della barra del TF CHIUSA all'istante t (la barra che contiene t e' in formazione)."""
    j = max(i for i in range(len(Ttf)) if Ttf[i] <= t) if Ttf and Ttf[0] <= t else -1
    return j - 1 if j >= 0 else -2


def py_sim(dati, cfg):
    T, O, H, L, C, S = dati
    TT, ET, _ = buffer_tf(cfg.tfT, cfg, T, H, L, C)
    TA, _, AT = buffer_tf(cfg.tfA, cfg, T, H, L, C)
    n = len(T)
    trades, conta = [], [0] * 8
    pos = None
    for i in range(n):
        path = [O[i]] + ([L[i], H[i]] if C[i] >= O[i] else [H[i], L[i]]) + [C[i]]
        ph = pl = None
        for k, bid in enumerate(path):
            ask = bid + S[i]
            ph = bid if k == 0 else max(ph, bid)
            pl = bid if k == 0 else min(pl, bid)
            if pos is not None:
                if pos["L"] and bid <= pos["sl"]:
                    trades.append(chiudi(pos, i, k, "SL", bid if k == 0 else pos["sl"]))
                    pos = None
                elif not pos["L"] and ask >= pos["sl"]:
                    trades.append(chiudi(pos, i, k, "SL", ask if k == 0 else pos["sl"]))
                    pos = None
            if pos is not None:
                barre = i - pos["i"]
                if pos["L"]:
                    est = max(H[pos["i"]:i] + [ph])
                else:
                    est = min(L[pos["i"]:i] + [pl])
                ja = chiusa_a(TA, T[pos["i"]] if cfg.mode == 1 else T[i])
                atr = AT[ja] if ja >= 0 else 0.0
                if ja < 0:
                    est = 0.0
                az, ns = py_azione(pos["L"], pos["op"], pos["sl"], bid, ask, est, atr, barre, cfg.tex, cfg.kTr,
                                   cfg.useBE, cfg.trig, cfg.off, 0.0, cfg.passo)
                if az == AZ_CHIUDI:
                    trades.append(chiudi(pos, i, k, "TEMPO", bid if pos["L"] else ask))
                    pos = None
                elif az == AZ_SPOSTA:
                    pos["sl"] = ns
                    pos["mods"] += 1
            if k == 0 and i >= 1:
                s = i - 1  # barra di segnale
                je, ja = chiusa_a(TT, T[i]), chiusa_a(TA, T[i])
                if s - cfg.N < 0 or je < 0 or ja < 0:
                    continue
                hh, ll = max(H[s - cfg.N:s]), min(L[s - cfg.N:s])
                ora = (T[i] % 86400) // 3600
                d, mot = py_decidi(C[s], hh, ll, ET[je], AT[ja], S[i], cfg.kSp, ora, cfg.hS, cfg.hE,
                                   pos is not None, False, cfg.aL, cfg.aS)
                if mot != NO_SEGNALE:
                    conta[mot] += 1
                if d != 0:
                    lng = d > 0
                    px = ask if lng else bid
                    s0 = tick_round(px - cfg.kSL * AT[ja] if lng else px + cfg.kSL * AT[ja], cfg.passo)
                    if (s0 < bid) if lng else (s0 > ask):
                        pos = {"L": lng, "op": px, "sl": s0, "sl0": s0, "i": i, "mods": 0}
    if pos is not None:
        trades.append(chiudi(pos, n - 1, 3, "FINE", C[n - 1] if pos["L"] else C[n - 1] + S[n - 1]))
    return trades, conta


def chiudi(pos, i, k, why, px):
    return (1 if pos["L"] else -1, pos["i"], pos["op"], pos["sl0"], i, k, why, px, pos["mods"], pos["sl"])


def cx_sim(cx, dati, cfg):
    T, O, H, L, C, S = dati
    TT, ET, _ = buffer_tf(cfg.tfT, cfg, T, H, L, C)
    TA, _, AT = buffer_tf(cfg.tfA, cfg, T, H, L, C)
    T5 = m5(T, H, L, C)[0]
    j = lambda xs: " ".join(map(g, xs))
    ji = lambda xs: " ".join(str(int(x)) for x in xs)
    txt = ("SIM %d %s %s %d %d %d %s %s %s %d %d %d %d %d %d %s\n" % (
        cfg.N, g(cfg.kSL), g(cfg.kTr), cfg.mode, cfg.tex, cfg.useBE, g(cfg.trig), g(cfg.off), g(cfg.kSp),
        cfg.hS, cfg.hE, cfg.aL, cfg.aS, cfg.tfT, cfg.tfA, g(cfg.passo)))
    txt += "%d %s %s %s %s %s %s\n" % (len(T), ji(T), j(O), j(H), j(L), j(C), j(S))
    txt += "%d %s\n" % (len(T5), ji(T5))
    txt += "%d %s\n%d %s\n" % (len(ET), j(ET), len(AT), j(AT))
    out = cx.run(txt)
    if out is None:
        return None
    trades, conta = [], None
    for ln in out:
        p = ln.split()
        if not p:
            continue
        if p[0] == "TR":
            trades.append((int(p[1]), int(p[2]), float(p[3]), float(p[4]), int(p[5]), int(p[6]), p[7], float(p[8]),
                           int(p[9]), float(p[10])))
        elif p[0] == "CONTA":
            conta = list(map(int, p[1:]))
    return trades, conta


def uguali(a, b):
    if len(a) != len(b):
        return False
    for x, y in zip(a, b):
        for u, v in zip(x, y):
            if isinstance(u, float):
                if abs(u - v) > 1e-6:
                    return False
            elif u != v:
                return False
    return True


def simulazioni(cx, bag, quiet=False, ridotto=False):
    semi = [11] if ridotto else [11, 22, 33]
    n = 900 if ridotto else 1800
    tot_tr, tot_motivi = 0, [0] * 8
    tutti_ok = True
    uscite = set()
    for cfg in CFGS:
        for sd in semi:
            dati = serie(sd * 1000 + CFGS.index(cfg), n)
            pa, pc = py_sim(dati, cfg)
            r = cx_sim(cx, dati, cfg)
            if r is None:
                check(False, "SIM [%s] seme %d: il driver C++ e' andato in crash (indice fuori dall'array?)" % (cfg.nome, sd),
                      bag, quiet=quiet)
                tutti_ok = False
                continue
            ca, cc = r
            ok = uguali(pa, ca) and pc == cc
            tutti_ok &= ok
            tot_tr += len(pa)
            tot_motivi = [a + b for a, b in zip(tot_motivi, pc)]
            uscite |= {t[6] for t in pa}
            if not ok:
                diff = next((k for k, (x, y) in enumerate(zip(pa, ca)) if not uguali([x], [y])), min(len(pa), len(ca)))
                check(False, "SIM [%s] seme %d: EA %d operazioni, specchio %d; prima differenza #%d EA=%s specchio=%s; conta EA=%s specchio=%s"
                      % (cfg.nome, sd, len(ca), len(pa), diff, ca[diff] if diff < len(ca) else "-",
                         pa[diff] if diff < len(pa) else "-", cc, pc), bag, quiet=quiet)
    check(tutti_ok, "simulazione: EA (letture vere + nucleo) = specchio Python su %d configurazioni x %d semi, %d operazioni"
          % (len(CFGS), len(semi), tot_tr), bag, quiet=quiet)
    if not ridotto:
        check(tot_tr >= 100 and {"SL", "TEMPO"} <= uscite,
              "copertura: >= 100 operazioni e uscite sia a SL sia a TEMPO (%d, %s)" % (tot_tr, sorted(uscite)), bag, quiet=quiet)
        check(tot_motivi[SPREAD] > 0 and tot_motivi[POSIZIONE] > 0 and tot_motivi[ORA] > 0 and tot_motivi[LATO] > 0,
              "copertura: scarti per spread %d, posizione %d, ora %d, lato %d (tutti > 0)"
              % (tot_motivi[SPREAD], tot_motivi[POSIZIONE], tot_motivi[ORA], tot_motivi[LATO]), bag, quiet=quiet)


def suite(raw, tmp, bag, quiet=False, ridotto=False):
    strati = {"S": False, "P": False, "X": False}
    b = []
    src = statico(raw, b, quiet=quiet)
    strati["S"] = bool(b)
    bag.extend(b)
    cx = Cxx(src, tmp)
    if not cx.ok:
        check(False, "funzioni dell'EA compilate in C++ %s" % cx.err[:600], bag, quiet=quiet)
        strati["P"] = strati["X"] = True
        return strati
    if not quiet:
        print("  ok   funzioni dell'EA (nucleo + letture di mercato + autotest) compilate in C++ (g++ -Wall)")
    b = []
    if not quiet:
        print("\nP) FUNZIONI PURE (C++ contro specchio Python)")
    casi_puri(cx, b, quiet=quiet, ridotto=ridotto)
    strati["P"] = bool(b)
    bag.extend(b)
    b = []
    if not quiet:
        print("\nX) SIMULAZIONE (letture di mercato VERE dell'EA)")
    simulazioni(cx, b, quiet=quiet, ridotto=ridotto)
    strati["X"] = bool(b)
    bag.extend(b)
    return strati


# ===========================================================================
# M) MUTANTI
# ===========================================================================
G = '      if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_GoldBreakoutATR")) return;\n'
MUTANTI = [
    # (id, descrizione, vecchio, nuovo, occorrenza, tipo)   tipo L = logica (deve prenderlo P o X)
    ("L01", "canale include la barra di segnale", "for(int k = 2; k <= n; k++)", "for(int k = 0; k <= n; k++)", 0, "L"),
    ("L02", "canale con una barra in meno", "for(int k = 2; k <= n; k++)", "for(int k = 2; k < n; k++)", 0, "L"),
    ("L03", "rottura long non stretta", "if(close1 > hh && close1 > ema) return 1;", "if(close1 >= hh && close1 > ema) return 1;", 0, "L"),
    ("L04", "EMA tolta dal long", "if(close1 > hh && close1 > ema) return 1;", "if(close1 > hh) return 1;", 0, "L"),
    ("L05", "EMA invertita sullo short", "if(close1 < ll && close1 < ema) return -1;", "if(close1 < ll && close1 > ema) return -1;", 0, "L"),
    ("L06", "spread: < invece di <=", "return (spread <= kMax * atr);", "return (spread < kMax * atr);", 0, "L"),
    ("L07", "filtro spread spento = blocca tutto", "if(kMax <= 0.0) return true;", "if(kMax <= 0.0) return false;", 0, "L"),
    ("L08", "ora di fine inclusa", "return (ora >= hStart && ora < hEnd);", "return (ora >= hStart && ora <= hEnd);", 0, "L"),
    ("L09", "fascia a cavallo della mezzanotte rotta", "return (ora >= hStart || ora < hEnd);", "return (ora >= hStart && ora < hEnd);", 0, "L"),
    ("L10", "perdita giornaliera: < invece di <=", "pnlGiorno <= -maxPerdita", "pnlGiorno < -maxPerdita", 0, "L"),
    ("L11", "posizione aperta ignorata", "if(posAperta)  ", "if(false && posAperta)  ", 0, "L"),
    ("L12", "lato LONG spento ignorato", "(dir > 0 && !allowLong)", "(dir > 0 && false)", 0, "L"),
    ("L13", "lato SHORT legge allowLong", "(dir < 0 && !allowShort)", "(dir < 0 && !allowLong)", 0, "L"),
    ("L14", "ATR nullo non fermato", "if(atr <= 0.0)                         { motivo = GBA_DATI;",
     "if(false)                              { motivo = GBA_DATI;", 0, "L"),
    ("L15", "trailing long dal lato sbagliato", "(estremo - kTrail * atr)", "(estremo + kTrail * atr)", 0, "L"),
    ("L16", "trailing short dal lato sbagliato", ": (estremo + kTrail * atr);", ": (estremo - kTrail * atr);", 0, "L"),
    ("L17", "long: solo-a-favore tolto", "if(isLong) return (nuovo > curSL + m);", "if(isLong) return true;", 0, "L"),
    ("L18", "short: solo-a-favore tolto", "return (nuovo < curSL - m);", "return true;", 0, "L"),
    ("L19", "BE: > invece di >=", "return (prezzo - openPx >= trig * atr);", "return (prezzo - openPx > trig * atr);", 0, "L"),
    ("L20", "BE: offset col segno sbagliato", "(openPx + beOff * atr)", "(openPx - beOff * atr)", 0, "L"),
    ("L21", "BE ignora l'interruttore", "if(useBE && GbaBeArmato(", "if(GbaBeArmato(", 0, "L"),
    ("L22", "BE prende il peggiore fra BE e trailing", "(isLong ? (be > best) : (be < best))", "(isLong ? (be < best) : (be > best))", 0, "L"),
    ("L23", "uscita a tempo: > invece di >=", "return (maxBarre > 0 && barre >= maxBarre);", "return (maxBarre > 0 && barre > maxBarre);", 0, "L"),
    ("L24", "uscita a tempo 0 non spegne", "return (maxBarre > 0 && barre >= maxBarre);", "return (barre >= maxBarre);", 0, "L"),
    ("L25", "estremo long sui minimi", "if(isLong) { if(h[k] > e) e = h[k]; }", "if(isLong) { if(l[k] > e) e = l[k]; }", 0, "L"),
    ("L26", "estremo senza la barra d'ingresso", "for(int k = 1; k < count; k++)", "for(int k = 1; k < count - 1; k++)", 0, "L"),
    ("L27", "stops level ignorato", "(bid - sl) >= minDist", "(bid - sl) >= 0.0", 0, "L"),
    ("L28", "canale letto dalla barra in formazione", "CopyHigh(g_sym, g_tfSig, 1, n + 1, h)", "CopyHigh(g_sym, g_tfSig, 0, n + 1, h)", 0, "L"),
    ("L29", "serie del massimo non invertita", "   ArraySetAsSeries(h, true);\n   ArraySetAsSeries(l, true);\n   ArraySetAsSeries(c, true);",
     "   ArraySetAsSeries(l, true);\n   ArraySetAsSeries(c, true);", 0, "L"),
    ("L30", "EMA/ATR sulla barra in formazione", "   return s + 1;\n", "   return s;\n", 0, "L"),
    ("L31", "ATR fisso (modo 1) ignorato", "if(InpTrailAtrMode == 1)", "if(false)", 0, "L"),
    ("L32", "estremo sulla sola barra in corso", "int cnt = barre + 1;", "int cnt = 1;", 0, "L"),
    ("L33", "close della barra in formazione", "CopyClose(g_sym, g_tfSig, 1, 1, c)", "CopyClose(g_sym, g_tfSig, 0, 1, c)", 0, "L"),
    # NB: "EMA letta con GbaShiftChiusa(g_tfAtr, t0)" e' un mutante EQUIVALENTE e non sta qui: con t0 = istante
    #     corrente iBarShift da' 0 su QUALUNQUE TF, quindi lo shift chiuso vale 1 comunque. Il TF conta solo per un
    #     istante passato (ATR fisso del modo 1): e' L34.
    ("L34", "ATR fisso (modo 1) cercato sul TF del segnale", "GbaShiftChiusa(g_tfAtr, tRif), atr)", "GbaShiftChiusa(g_tfSig, tRif), atr)", 0, "L"),
    ("L43", "EMA letta dall'handle dell'ATR", "GbaLeggiBuffer(g_hEma, GbaShiftChiusa(g_tfTrend, t0), ema)",
     "GbaLeggiBuffer(g_hAtr, GbaShiftChiusa(g_tfTrend, t0), ema)", 0, "L"),
    ("L35", "lotti arrotondati invece che troncati", "MathFloor(lots / step + 1e-9)", "MathRound(lots / step + 1e-9)", 0, "L"),
    ("L36", "rischio senza /100", "(saldo * pct / 100.0)", "(saldo * pct)", 0, "L"),
    ("L37", "lotti sotto il minimo alzati al minimo", "if(v < vmin - 1e-12) return 0.0;", "if(v < vmin - 1e-12) v = vmin;", 0, "L"),
    ("L38", "attesa dell'autotest sbagliata", "GbaDirezione(2008.0, 2008.0, 1993.0, 2000.0) == 0", "GbaDirezione(2008.0, 2008.0, 1993.0, 2000.0) == 1", 0, "L"),
    ("L39", "arrotondamento al tick tolto", "   cand = GbaArrotonda(cand, passo);\n", "", 0, "L"),
    ("L40", "tempo controllato dopo lo SL", "   if(GbaUscitaTempo(barre, maxBarre)) return GBA_AZ_CHIUDI;\n   double prezzo",
     "   double prezzo", 0, "L"),
    ("L41", "ATR di gestione dalla barra d'ingresso anche in modo 0", "   datetime tRif = t0;\n", "   datetime tRif = iTime(g_sym, g_tfSig, barre);\n", 0, "L"),
    ("L42", "giornata bloccata ignorata", "   if(giornoBloccato)  ", "   if(false)  ", 0, "L"),
    ("S01", "Guardian tolto prima del Buy", G + "      inviato = trade.Buy(", "      inviato = trade.Buy(", 0, "S"),
    ("S02", "Guardian dopo il Sell", G + "      inviato = trade.Sell(lots, g_sym, bid, sl, 0.0, cmt);",
     "      inviato = trade.Sell(lots, g_sym, bid, sl, 0.0, cmt) && ABTG_GuardiaIngresso(InpUsaGuardian, \"ABTG_GoldBreakoutATR\");", 0, "S"),
    ("S03", "InpUsaGuardian spento di default", "InpUsaGuardian = true;", "InpUsaGuardian = false;", 0, "S"),
    ("S04", "magic dell'Azzurra", "= 775800;", "= 774500;", 0, "S"),
    ("S05", "magic nel blocco occupato 7753xx", "= 775800;", "= 775399;", 0, "S"),
    # il numero della Telemetria si COSTRUISCE: scritto per intero farebbe scattare il controllo "magic libero"
    # del collaudo di quell'EA.
    ("S05b", "magic della Bulge_Telemetria (blocco 7751xx)", "= 775800;", "= " + "7751" + "00;", 0, "S"),
    ("S06", "canale 47", "InpChannelBars  = 48;", "InpChannelBars  = 47;", 0, "S"),
    ("S07", "EMA 50 di default", "InpEmaPeriod    = 100;", "InpEmaPeriod    = 50;", 0, "S"),
    ("S08", "kSL 2,0", "InpSL_ATR        = 2.5;", "InpSL_ATR        = 2.0;", 0, "S"),
    ("S09", "kTrail 2,0", "InpTrail_ATR     = 2.5;", "InpTrail_ATR     = 2.0;", 0, "S"),
    ("S10", "uscita a tempo 47", "InpTimeExitBars  = 48;", "InpTimeExitBars  = 47;", 0, "S"),
    ("S11", "breakeven spento di default", "InpUseBreakeven  = true;", "InpUseBreakeven  = false;", 0, "S"),
    ("S12", "BE a 1,5 ATR", "InpBE_TriggerATR = 1.0;", "InpBE_TriggerATR = 1.5;", 0, "S"),
    ("S13", "slippage 10", "InpSlippagePoints  = 30;", "InpSlippagePoints  = 10;", 0, "S"),
    ("S14", "spread 0,35 di default (non la replica)", "InpSpreadMaxATR = 0.05;", "InpSpreadMaxATR = 0.35;", 0, "S"),
    ("S15", "lotti 10 di default", "InpLots    = 1.00;", "InpLots    = 10.0;", 0, "S"),
    ("S16", "modo rischio di default", "InpLotMode = 0;", "InpLotMode = 1;", 0, "S"),
    ("S17", "rischio 1%", "InpRiskPct = 0.25;", "InpRiskPct = 1.0;", 0, "S"),
    ("S18", "ore 22 di default", "InpHourStart       = 0;", "InpHourStart       = 22;", 0, "S"),
    ("S19", "EMA su M15 di default", "InpTrendTF  = PERIOD_CURRENT;", "InpTrendTF  = PERIOD_M15;", 0, "S"),
    ("S20", "WebRequest aggiunto", "void Log(string m)", "void Rete() { char d[]; char r[]; string h; WebRequest(\"GET\", \"x\", \"\", 0, d, r, h); }\nvoid Log(string m)", 0, "S"),
    ("S21", "PrintFormat con un argomento in meno", "InpSpreadMaxATR, (InpSpreadMaxATR > 0.0 ? \"\" : \" (filtro SPENTO)\"),",
     "(InpSpreadMaxATR > 0.0 ? \"\" : \" (filtro SPENTO)\"),", 0, "S"),
    ("S22", "commento troppo lungo", 'InpComment     = "GBA";', 'InpComment     = "GBA_GOLD_BREAKOUT_ATR";', 0, "S"),
    ("S23", "handle ATR non rilasciato", "   if(g_hAtr != INVALID_HANDLE) IndicatorRelease(g_hAtr);\n", "", 0, "S"),
    ("S24", "OnTick: segnale prima della gestione", "   GbaGestisci();\n   datetime t0 = iTime(g_sym, g_tfSig, 0);\n   if(t0 <= 0) return;",
     "   datetime t0 = iTime(g_sym, g_tfSig, 0);\n   if(t0 <= 0) return;\n   GbaNuovaBarra(t0);\n   GbaGestisci();", 0, "S"),
    ("S25", "TF del segnale M15 di default", "InpSignalTF = PERIOD_M1;", "InpSignalTF = PERIOD_M15;", 0, "S"),
    ("S26", "slippage non passato a CTrade", "   trade.SetDeviationInPoints((ulong)InpSlippagePoints);\n", "", 0, "S"),
    ("S27", "log di avvio senza un input", "InpBE_TriggerATR=%.2f | InpBE_OffsetATR=%.2f", "InpBE_TriggerATR=%.2f | offset=%.2f", 0, "S"),
    ("S28", "contatore spread tolto dalla stampa", "SPREAD %d (spread max %.2f x ATR) | posizione aperta %d", "posizione aperta %d", 0, "S"),
    ("S29", "riga dello scarto senza stop/spread", "| stop/spread %.1fx | ora server %d\",\n                     lato,",
     "| ora server %d\",\n                     lato,", 0, "S"),
    ("S30", "SL iniziale col moltiplicatore del trailing", "double slDist   = InpSL_ATR * atr;", "double slDist   = InpTrail_ATR * atr;", 0, "S"),
    ("S31", "Guardian chiamato anche in chiusura", "         if(trade.PositionClose(tk, (ulong)InpSlippagePoints))",
     "         if(ABTG_GuardiaIngresso(InpUsaGuardian, \"ABTG_GoldBreakoutATR\") && trade.PositionClose(tk, (ulong)InpSlippagePoints))", 0, "S"),
    ("S32", "margine libero non verificato", "if(InpCheckFreeMargin && !GbaMargineOk(isLong, lots, price)) return;", "", 0, "S"),
]


def applica(src, vecchio, nuovo, occ):
    if src.count(vecchio) <= occ:
        return None
    p = -1
    for _ in range(occ + 1):
        p = src.find(vecchio, p + 1)
    return src[:p] + nuovo + src[p + len(vecchio):]


def mutanti(src):
    print("\nM) MUTANTI CIECHI (%d), su copie fuori dal repo" % len(MUTANTI))
    presi = 0
    for mid, desc, v, n, occ, tipo in MUTANTI:
        mut = applica(src, v, n, occ)
        if mut is None:
            check(False, "%s %s: il punto da mutare non esiste (collaudo da aggiornare)" % (mid, desc))
            continue
        tmp = tempfile.mkdtemp(prefix="gba_mut_")
        try:
            strati = suite(mut.encode("latin-1"), tmp, [], quiet=True, ridotto=True)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
        chi = "".join(k for k in "SPX" if strati[k])
        ok = bool(chi) and (tipo != "L" or strati["P"] or strati["X"])
        presi += ok
        print(("  ok   " if ok else "  FAIL ") + "%s %-55s preso da [%s]%s" % (
            mid, desc, chi or "-", "" if ok or not chi else "  <- logica presa SOLO dallo statico"))
        if not ok:
            FAILS.append("mutante %s (%s) non preso come richiesto" % (mid, desc))
    check(presi == len(MUTANTI), "mutanti presi: %d/%d (logica: tutti presi da P o X)" % (presi, len(MUTANTI)))


# ===========================================================================
def main():
    with open(SRC, "rb") as f:
        raw = f.read()
    print("collaudo ABTG_GoldBreakoutATR.mq5\n")
    print("S) STATICO")
    tmp = tempfile.mkdtemp(prefix="gba_")
    try:
        b = []
        suite(raw, tmp, b)
        FAILS.extend(b)
        if not SENZA_MUTANTI and not FAILS:
            mutanti(raw.decode("ascii"))
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    print("\nNON PROVATO: compilazione MQL5 (MetaEditor assente), CTrade e riempimenti, Guardian oltre la sua riga, "
          "GbaApri/GbaGestisci/GbaPnlGiorno/GbaMargineOk (API di conto), iMA/iATR del terminale, tick e spread reali, "
          "NESSUN backtest.")
    if FAILS:
        print("\nESITO: FAIL (%d)" % len(FAILS))
        for f in FAILS[:40]:
            print("  - " + f)
        sys.exit(1)
    print("\nESITO: PASS")


if __name__ == "__main__":
    main()
