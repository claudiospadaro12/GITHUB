#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Collaudo STRATO 1 di mql5/Experts/ABTG_BulgeAzzurra.mq5 ("BULGE AZZURRA", la CONTINUAZIONE, 08/10/2026),
nello stile di collaudo_natcla.py.

Qui NON c'e' MetaEditor: niente compila l'MQL5, niente gira nel tester. Si prova quello che si puo' provare
a tavolino, e si dice cosa resta fuori.

  Z) ZONE DEL DIFF: ABTG_BulgeAzzurra.mq5 deve essere ABTG_Bulge.mq5 + SOLO le zone dichiarate. Il diff
     (difflib, riga per riga) viene spezzato in blocchi; ogni blocco deve cadere dentro UNA zona dichiarata
     (ancorata a righe di ABTG_Bulge.mq5) e ogni zona dichiarata deve avere il suo blocco.
  S) STATICO sul sorgente vero: ASCII puro; parentesi bilanciate fuori da commenti/stringhe; TUTTE le
     funzioni di ABTG_Bulge.mq5 identiche byte per byte tranne quelle dichiarate; OpenOrder identica a meno
     del nome passato al Guardian; CheckSignal SENZA il blocco AZZURRA identica a quella di ABTG_Bulge
     (VIOLA, BLU, ARANCIO non toccati); AdxFilterOk ed ExtractSignalTag identiche a meno della riga AZZURRA;
     funzioni nuove = esattamente {AzureOrderedRetrace, AzureCore}; input: stessi nomi, tipi e default
     dell'EA attuale tranne i quattro dichiarati (Use_Blue, Use_Purple, InpMagic, InpComment) + i quattro
     nuovi (Use_Azure, Azure_MaxRetraceRangeATR, Azure_FirstTouchOnly, ADX_Apply_On_Azure); magic di
     default assente da TUTTO il repo fuori dai file AZZURRA; ogni trade.Buy/trade.Sell preceduto dalla
     riga del Guardian; PrintFormat: segnaposto == argomenti; contatore e nome del CSV riconoscono AZZURRA.
  P) FUNZIONI PURE VERE estratte dal .mq5 e compilate C++: AzureCore, AzureOrderedRetrace (con i bordi
     esatti), PurpleReactionCore (VIOLA: stessa tabella su ABTG_Bulge e su AZZURRA), ExtractSignalTag (i
     tranelli del prefisso "BULGE_AZZURRA"), AdxFilterOk (mappa AZZURRA), e il PEZZO VERO dell'autotest
     dell'EA (le sue attese devono uscire PASS).
  X) CheckSignal VERA (di tutti e due gli EA) compilata in C++ con le letture di mercato sostituite da
     scenari: (1) scenari scritti a mano (long valido, short specchiato, candela impulsiva, ritracciamento
     disordinato, banda sbagliata, impulso nel verso sbagliato, mediana non attraversata, primo tocco,
     finestra 40/41, spike sulla candela di test, ADX, variante Pine del VIOLA che NON deve toccare
     l'AZZURRA, Use_Azure spento) con l'ordine atteso (lato, commento, ATR, mediana); (2) DIFFERENZIALE su
     serie casuali: con Use_Azure spento AZZURRA e ABTG_Bulge aprono GLI STESSI ordini (BLU/VIOLA/ARANCIO,
     offset 0 e 1, VIOLA-EA e VIOLA-PINE), e con Use_Azure acceso gli ordini non-AZZURRA restano quelli;
     (3) specchio Python INDIPENDENTE della regola AZZURRA scritto dalla specifica, confrontato ordine per
     ordine sulle stesse serie.
  M) MUTANTI CIECHI applicati a una COPIA fuori dal repo: per ognuno si rigira la suite (S+Z+P+X ridotto);
     deve fallire almeno un controllo, e i mutanti di LOGICA devono essere presi da P o X (non solo dal
     diff), cosi' si prova che i controlli di comportamento mordono davvero.

Uso:   python3 backtest_pipeline/collaudo_bulge_azzurra.py [--senza-mutanti]
Esce con 0 solo se tutto passa. NON prova: compilazione MQL5 (MetaEditor assente), CTrade/riempimenti,
Guardian (fuori dalla sua riga), iBands/iATR/iADX del terminale, tick reali, NESSUN backtest.
"""
import difflib
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_NEW = os.path.join(ROOT, "mql5/Experts/ABTG_BulgeAzzurra.mq5")
SRC_OLD = os.path.join(ROOT, "mql5/Experts/ABTG_Bulge.mq5")
PROPRI = {"mql5/Experts/ABTG_BulgeAzzurra.mq5", "backtest_pipeline/collaudo_bulge_azzurra.py",
          "report/BULGE_AZZURRA_SPECIFICA_2026-10-08.md"}
SENZA_MUTANTI = "--senza-mutanti" in sys.argv
FAILS = []


def check(cond, msg, bag=None, quiet=False):
    if not quiet:
        print(("  ok   " if cond else "  FAIL ") + msg)
    if not cond:
        (FAILS if bag is None else bag).append(msg)
    return cond


def leggi(p):
    with open(p, "rb") as f:
        return f.read()


# ===========================================================================
# utilita' di lettura del sorgente
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
    """nome -> (tipo, default) di ogni 'input' (fuori dai commenti)."""
    code = maschera(src)
    out = {}
    for m in re.finditer(r"(?m)^input\s+(\w+)\s+(\w+)\s*=\s*([^;]+);", code):
        val = src[m.start(3):m.end(3)].strip()
        out[m.group(2)] = (m.group(1), val)
    return out


# ===========================================================================
# Z) ZONE DEL DIFF
# ===========================================================================
# (nome, regex della PRIMA riga, regex dell'ULTIMA riga, quante occorrenze) -- ancorate a ABTG_Bulge.mq5
ZONE = [
    ("intestazione: nome file + blocco AZZURRA", r"^//\+-+\+$", r"BULGE -- mean-reversion su Bollinger", 1),
    ("input dei segnali (Use_Blue/Use_Purple spenti, Use_Azure e i 2 input AZZURRA)",
     r'^input group "=== Segnali ==="', r"^input bool   Use_Purple = ", 1),
    ("input ADX_Apply_On_Azure", r"^input bool   ADX_Apply_On_Orange", r"^input bool   ADX_Apply_On_Orange", 1),
    ("identita': InpMagic + InpComment", r"^//--- 772700: blocco verificato", r"^input string InpComment", 1),
    ("ExtractSignalTag: tag AZZURRA", r'_ARANCIO_"\) >= 0\) tag = "ARANCIO";', r'_ARANCIO_"\) >= 0\) tag', 1),
    ("OnInit: ADX su AZZURRA", r"if\(ADX_Apply_On_Orange\) adx_msg", r"if\(ADX_Apply_On_Orange\) adx_msg", 1),
    ("OnInit: riga di configurazione AZZURRA", r'\(g_sigOff == 0 \? " \(R92', r'\(g_sigOff == 0 \? " \(R92', 1),
    ("AutoTest: intestazione segnali", r'PrintFormat\("\[BULGE\]\[AUTOTEST\] magic', r'\(Use_Purple \? "VIOLA" : ""\)\);', 1),
    ("AutoTest: tag AZZURRA", r"^   bool t5 = ", r"^   if\(!\(t1 && t2 && t3 && t4 && t5\)\)", 1),
    ("AutoTest B): caso eLargo corretto (difetto dell'autotest ereditato da ABTG_Bulge)",
     r"^   bool eLargo  = PurpleReactionCore\(true,  1\.10000, 1\.10020", r"^   bool eLargo  = ", 1),
    ("AutoTest: blocco AZZURRA + VIOLA invariato",r"^   int fallitiGuardia = ABTG_AutotestGuardia", r"^   int fallitiGuardia", 1),
    ("AdxFilterOk: mappa AZZURRA", r'signalType == "ARANCIO" && ADX_Apply_On_Orange', r'signalType == "ARANCIO"', 1),
    ("OpenOrder: nome al Guardian", r'ABTG_GuardiaIngresso\(InpUsaGuardian, "ABTG_Bulge"\)', r'ABTG_GuardiaIngresso\(InpUsaGuardian, "ABTG_Bulge"\)', 2),
    ("funzioni pure AzureOrderedRetrace + AzureCore", r"return PurpleReactionCore\(isLong, open0, close0, atr1, Use_Purple_PineReaction\);", r"^\}$", 1),
    ("CheckSignal: blocco AZZURRA dopo il VIOLA", r'InpComment \+ "_VIOLA_S"\);', r"^   \}$", 1),
    ("ExportTrades: variante AZZURRA nel nome del CSV", r'\+\(Use_Purple_PineReaction\?"PINE":"EA"\)\+"\.csv";', r'"\.csv";', 1),
    ("PrintContaSegnali: dichiarazione nAzzurra", r"^   int nBlu=0, nViola=0", r"^   int nBlu=0", 1),
    ("PrintContaSegnali: conteggio e stampa AZZURRA", r'else if\(StringFind\(c,"_ARANCIO_"\)>=0\) nArancio\+\+;', r'\(Use_Purple\?"VIOLA":""\)\);', 1),
]


def zone_istanze(old_lines):
    """per ogni zona: la riga i che fa 'a' e la PRIMA riga j >= i (entro 60) che fa 'b'."""
    ist = []
    for nome, a, b, quante in ZONE:
        trovate = 0
        for i, ln in enumerate(old_lines):
            if trovate == quante:
                break
            if not re.search(a, ln):
                continue
            j = next((j for j in range(i, min(i + 61, len(old_lines))) if re.search(b, old_lines[j])), None)
            if j is None:
                continue
            ist.append((nome, i, j))
            trovate += 1
        ist.append(("__CONTA__" + nome, trovate, quante))
    return ist


def controlla_zone(old, new, bag, quiet=False):
    old_lines, new_lines = old.split("\n"), new.split("\n")
    ist = zone_istanze(old_lines)
    zone = [z for z in ist if not z[0].startswith("__CONTA__")]
    for z in ist:
        if z[0].startswith("__CONTA__"):
            check(z[1] == z[2], "zona ancorata in ABTG_Bulge.mq5 %d/%d volte: %s" % (z[1], z[2], z[0][9:]), bag, quiet=True)
    sm = difflib.SequenceMatcher(a=old_lines, b=new_lines, autojunk=False)
    usate = {}
    blocchi = 0
    tolte = aggiunte = 0
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        blocchi += 1
        tolte += i2 - i1
        aggiunte += j2 - j1
        dove = None
        for k, (nome, s, e) in enumerate(zone):
            if i1 == i2:
                ok = s - 1 <= i1 <= e + 1     # difflib puo' attaccare l'inserimento prima della riga vuota
            else:
                ok = s <= i1 and i2 - 1 <= e
            if ok:
                dove = k
                break
        if dove is None:
            check(False, "blocco del diff FUORI dalle zone dichiarate: righe ABTG_Bulge %d-%d (%s) -> %r"
                  % (i1 + 1, i2, tag, "\n".join(new_lines[j1:j2])[:160]), bag)
        else:
            usate[dove] = usate.get(dove, 0) + 1
    for k, (nome, s, e) in enumerate(zone):
        check(k in usate, "zona dichiarata con il suo blocco nel diff: %s (riga %d di ABTG_Bulge)" % (nome, s + 1), bag, quiet=quiet)
    if not quiet:
        print("  ..   diff: %d blocchi, %d righe di ABTG_Bulge toccate, %d righe nuove" % (blocchi, tolte, aggiunte))
    check(tolte <= 30, "righe di ABTG_Bulge toccate <= 30 (sono %d)" % tolte, bag, quiet=quiet)
    return blocchi, tolte, aggiunte


# ===========================================================================
# S) STATICO
# ===========================================================================
DIFFERENTI = {"ExtractSignalTag", "OnInit", "AutoTestBulge", "AdxFilterOk", "OpenOrder", "CheckSignal",
              "ExportTrades", "PrintContaSegnali"}
NUOVE = {"AzureOrderedRetrace", "AzureCore"}
INPUT_CAMBIATI = {"Use_Blue": ("bool", "false"), "Use_Purple": ("bool", "false"),
                  "InpMagic": ("long", "774500"), "InpComment": ("string", '"BULGE_AZZURRA"')}
INPUT_NUOVI = {"Use_Azure": ("bool", "true"), "Azure_MaxRetraceRangeATR": ("double", "1.5"),
               "Azure_FirstTouchOnly": ("bool", "false"), "ADX_Apply_On_Azure": ("bool", "false")}
RIGA_GUARDIAN = 'if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_BulgeAzzurra")) return;'
INIZIO_AZZ = "\n\n   //----------------------------------------------------------------\n   // AZZURRA 08/10 -- CONTINUAZIONE"
_CACHE_MAGIC = {}


def magic_libero(val):
    """file del repo (tracciati + non tracciati) che contengono il numero, TOLTI i file che parlano
    dell'AZZURRA (questo EA, il suo collaudo, la sua specifica e le future note di memoria che la citano):
    un magic e' 'libero' se nessun ALTRO EA, preset, riga o referto lo usa."""
    if val in _CACHE_MAGIC:
        return _CACHE_MAGIC[val]
    r = subprocess.run(["git", "grep", "-lE", "--untracked", "(^|[^0-9])%s([^0-9]|$)" % val],
                       cwd=ROOT, capture_output=True, text=True)
    altri = []
    for x in sorted(set(x for x in r.stdout.split("\n") if x.strip()) - PROPRI):
        try:
            with open(os.path.join(ROOT, x), "rb") as f:
                if b"azzurra" in f.read().lower():
                    continue
        except OSError:
            pass
        altri.append(x)
    _CACHE_MAGIC[val] = altri
    return altri


def statico(raw, old, bag, quiet=False):
    try:
        src = raw.decode("ascii")
    except UnicodeDecodeError as ex:
        bag.append("non ASCII puro: %s" % ex)
        src = raw.decode("latin-1")
    check("\r" not in src, "fine riga LF come ABTG_Bulge.mq5", bag, quiet=quiet)
    code = maschera(src)
    for a, b in ("()", "[]", "{}"):
        check(code.count(a) == code.count(b), "parentesi %s%s bilanciate" % (a, b), bag, quiet=quiet)
    fo, fn = funzioni(old), funzioni(src)
    check(set(fn) - set(fo) == NUOVE, "funzioni nuove = %s (trovate %s)" % (sorted(NUOVE), sorted(set(fn) - set(fo))), bag, quiet=quiet)
    check(not (set(fo) - set(fn)), "nessuna funzione di ABTG_Bulge sparita (%s)" % sorted(set(fo) - set(fn)), bag, quiet=quiet)
    diverse = sorted(n for n in fo if n in fn and fo[n] != fn[n] and n not in DIFFERENTI)
    check(not diverse, "tutte le funzioni non dichiarate identiche byte per byte (%d su %d) %s"
          % (len(fo) - len(DIFFERENTI), len(fo), diverse if diverse else ""), bag, quiet=quiet)
    # OpenOrder: identica a meno del nome al Guardian
    oo = fn.get("OpenOrder", "")
    check(oo.count('"ABTG_BulgeAzzurra"') == 2 and oo.replace('"ABTG_BulgeAzzurra"', '"ABTG_Bulge"') == fo["OpenOrder"],
          "OpenOrder identica a ABTG_Bulge a meno del nome al Guardian (SL = ATR x SL_ATR_Mult, TP = mediana, controlli)", bag, quiet=quiet)
    # CheckSignal senza il blocco AZZURRA == ABTG_Bulge
    cs = fn.get("CheckSignal", "")
    p = cs.find(INIZIO_AZZ)
    check(p > 0 and cs[:p] + "\n}" == fo["CheckSignal"],
          "CheckSignal SENZA il blocco AZZURRA identica a ABTG_Bulge (VIOLA/BLU/ARANCIO e misure condivise intatte)", bag, quiet=quiet)
    check(p > 0 and cs[p:].count("OpenOrder(") == 2 and cs[p:].count("if(Use_Azure)") == 1,
          "blocco AZZURRA in coda a CheckSignal: un solo if(Use_Azure), due OpenOrder", bag, quiet=quiet)
    ax = fn.get("AdxFilterOk", "")
    riga_adx = '   if(signalType == "AZZURRA" && ADX_Apply_On_Azure)  applyFilter = true;\n'
    check(ax.count(riga_adx) == 1 and ax.replace(riga_adx, "") == fo["AdxFilterOk"],
          "AdxFilterOk = ABTG_Bulge + la sola riga AZZURRA", bag, quiet=quiet)
    et = fn.get("ExtractSignalTag", "")
    m = re.search(r"   //--- AZZURRA 08/10: per ULTIMA.*?tag = \"AZZURRA\";\n", et, re.S)
    check(m is not None and (et[:m.start()] + et[m.end():]) == fo["ExtractSignalTag"],
          "ExtractSignalTag = ABTG_Bulge + il ramo AZZURRA, messo per ULTIMO", bag, quiet=quiet)
    # input
    io, inew = inputs(old), inputs(src)
    atteso = dict(io)
    atteso.update(INPUT_CAMBIATI)
    atteso.update(INPUT_NUOVI)
    diff_in = sorted(k for k in set(atteso) | set(inew) if atteso.get(k) != inew.get(k))
    check(not diff_in, "input: stessi nomi/tipi/default di ABTG_Bulge tranne i 4 dichiarati, + i 4 nuovi (%d input) %s"
          % (len(inew), ["%s: atteso %s, trovato %s" % (k, atteso.get(k), inew.get(k)) for k in diff_in]), bag, quiet=quiet)
    # magic libero
    mg = inew.get("InpMagic", ("", ""))[1]
    altri = magic_libero(mg) if re.fullmatch(r"\d+", mg) else ["(magic non numerico)"]
    check(not altri, "magic %s assente da tutto il repo fuori dai file AZZURRA (git grep --untracked) %s" % (mg, altri[:5]), bag, quiet=quiet)
    blocco = mg[:4] if len(mg) == 6 else "?"
    altri_b = magic_libero("%s[0-9]{2}" % blocco) if blocco != "?" else ["?"]
    check(not altri_b, "blocco %sxx assente da tutto il repo fuori dai file AZZURRA %s" % (blocco, altri_b[:5]), bag, quiet=quiet)
    # Guardian prima di ogni invio di apertura
    righe = src.split("\n")
    mrighe = code.split("\n")
    invii = 0
    for i, ln in enumerate(mrighe):
        if re.search(r"\btrade\.(Buy|Sell)\s*\(", ln):
            invii += 1
            j = i - 1
            while j >= 0 and righe[j].strip() == "":
                j -= 1
            check(righe[j].strip() == RIGA_GUARDIAN, "riga %d: trade.Buy/Sell preceduto dal Guardian" % (i + 1), bag, quiet=quiet)
    check(invii == 2, "esattamente 2 invii di apertura (trade.Buy + trade.Sell, in OpenOrder): %d" % invii, bag, quiet=quiet)
    # PrintFormat/StringFormat: segnaposto == argomenti
    nfmt = 0
    for mm in re.finditer(r"\b(PrintFormat|StringFormat)\s*\(", code):
        i = code.index("(", mm.start())
        j = chiusa(code, i)
        args = argomenti(code, i, j)
        fmt = src[args[0][0]:args[0][1]].strip()
        if not (fmt.startswith('"') and fmt.endswith('"')):
            continue
        n = len(re.findall(r"%(?!%)[-+ 0#]*\d*(?:\.\d+)?[sdifgeExXcu]", fmt.replace("%%", "")))
        nfmt += 1
        if n != len(args) - 1:
            check(False, "PrintFormat riga %d: %d segnaposto, %d argomenti" % (src[:i].count("\n") + 1, n, len(args) - 1), bag)
    check(nfmt >= 15, "PrintFormat/StringFormat controllati: %d" % nfmt, bag, quiet=quiet)
    # contatore e CSV
    pc = fn.get("PrintContaSegnali", "")
    check('else if(StringFind(c,"_AZZURRA_L")>=0 || StringFind(c,"_AZZURRA_S")>=0) nAzzurra++;' in pc
          and "AZZURRA=%d" in pc and "nArancio, nAzzurra, nAltro" in pc and '(Use_Azure?"AZZURRA":"")' in pc,
          "[BULGE-CONTA] conta e stampa AZZURRA (stesso riconoscimento di ExtractSignalTag)", bag, quiet=quiet)
    ex = fn.get("ExportTrades", "")
    check('+"_azzurra"+(Azure_FirstTouchOnly?"PRIMO":"OGNI")+".csv";' in ex and "ExtractSignalTag(comIn,false)" in ex,
          "CSV per-trade: colonna signal da ExtractSignalTag + variante del tocco nel nome", bag, quiet=quiet)
    oi = fn.get("OnInit", "")
    check('if(ADX_Apply_On_Azure)  adx_msg += " AZZURRA";' in oi and "AzureCore" not in oi,
          "OnInit: ADX su AZZURRA nel riepilogo", bag, quiet=quiet)
    at = fn.get("AutoTestBulge", "")
    check("AzureCore(" in at and "AzureOrderedRetrace(" in at and "aViola" in at,
          "AutoTest: blocco AZZURRA + prova VIOLA invariato presenti", bag, quiet=quiet)
    return src


# ===========================================================================
# C++: shim, estrazione, driver
# ===========================================================================
SHIM = r"""
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
#include <initializer_list>
#include <iostream>
#include <sstream>
typedef std::string string;
struct Arr {
  std::vector<double> v;
  Arr() {}
  Arr(std::initializer_list<double> l) : v(l) {}
  void chk(int i) const { if(i < 0 || i >= (int)v.size()) { std::printf("OOR %d %d\n", i, (int)v.size()); std::fflush(stdout); std::exit(3); } }
  double &operator[](int i) { chk(i); return v[i]; }
  const double &operator[](int i) const { chk(i); return v[i]; }
};
static double MathAbs(double x) { return std::fabs(x); }
static int StringFind(const string &s, const string &t, int st = 0) { size_t p = s.find(t, st); return p == string::npos ? -1 : (int)p; }
static int StringLen(const string &s) { return (int)s.size(); }
static string StringSubstr(const string &s, int st, int len = -1) { if(st >= (int)s.size()) return ""; return len < 0 ? s.substr(st) : s.substr(st, len); }
static string DoubleToString(double v, int d = 8) { char b[64]; std::snprintf(b, 64, "%.*f", d, v); return b; }
template<typename... T> static void Print(T...) {}
template<typename... T> static void PrintFormat(T...) {}
int    Lookback_Bars = 20;      double Bulge_Multi = 1.1;
bool   Use_Orange = false, Use_Blue = false, Use_Purple = false, Use_Azure = true, Use_Purple_PineReaction = false;
double Azure_MaxRetraceRangeATR = 1.5; bool Azure_FirstTouchOnly = false;
string InpComment = "BULGE_AZZURRA";
int    g_sigOff = 1;
string g_symbols[1] = {"EURUSD"};
bool   Use_ADX_Filter = true; double ADX_Threshold = 30.0;
bool   ADX_Apply_On_Blue = true, ADX_Apply_On_Purple = false, ADX_Apply_On_Orange = false, ADX_Apply_On_Azure = false;
bool   InpVerbose = false;
struct Scn { int n = 0; std::vector<double> H, L, O, C, U, W, B, A; double widthMA = 1.0; bool atrOk = true; double adx = -1.0; } S;
static bool cp(const std::vector<double> &src, int start, int count, Arr &dst) {
  if(start < 0 || start + count > (int)src.size()) return false;
  dst.v.assign(src.begin() + start, src.begin() + start + count); return true; }
bool GetBars(string, int count, Arr &h, Arr &l, Arr &o, Arr &c) {
  return cp(S.H, 0, count, h) && cp(S.L, 0, count, l) && cp(S.O, 0, count, o) && cp(S.C, 0, count, c); }
bool GetBBSeries(int, int start, int count, Arr &u, Arr &l, Arr &b) {
  return cp(S.U, start, count, u) && cp(S.W, start, count, l) && cp(S.B, start, count, b); }
bool GetBB(int, int idx, double &u, double &l, double &b) {
  if(idx < 0 || idx >= S.n) return false; u = S.U[idx]; l = S.W[idx]; b = S.B[idx]; return true; }
bool GetATRSeries(int, int start, int count, Arr &a) { return cp(S.A, start, count, a); }
double GetATR(int, int idx = 1) { if(idx < 0 || idx >= S.n) return 0.0; return S.A[idx]; }
bool AtrOk(int) { return S.atrOk; }
double GetBBWidthMA(int) { return S.widthMA; }
double GetADX(int, int = 1) { return S.adx; }
void OpenOrder(string sym, bool isLong, double atr, double bbBasis, string comment) {
  std::printf("ORD %d %.17g %.17g %s\n", isLong ? 1 : 0, atr, bbBasis, comment.c_str()); }
"""

DRIVER = r"""
#include "shim.h"
#include "pure.h"
static std::vector<double> rd(std::istream &is, int n) { std::vector<double> v(n); for(int i = 0; i < n; i++) is >> v[i]; return v; }
int main() {
  std::string cmd;
  while(std::cin >> cmd) {
    if(cmd == "CFG") {
      int a, b, c, d, e, f, g, h, i, j, k, l, m; double r, t;
      std::cin >> a >> b >> c >> d >> e >> f >> g >> r >> h >> i >> t >> j >> k >> l >> m;
      g_sigOff = a; Lookback_Bars = b; Use_Orange = c; Use_Blue = d; Use_Purple = e;
#ifdef NUOVO
      Use_Azure = f; Azure_MaxRetraceRangeATR = r; Azure_FirstTouchOnly = h; ADX_Apply_On_Azure = m;
#else
      (void)f; (void)h; (void)m;
#endif
      Use_Purple_PineReaction = g; Use_ADX_Filter = i; ADX_Threshold = t;
      ADX_Apply_On_Blue = j; ADX_Apply_On_Purple = k; ADX_Apply_On_Orange = l;
    } else if(cmd == "SCN") {
      std::string id; std::cin >> id >> S.n >> S.widthMA >> S.atrOk >> S.adx;
      S.H = rd(std::cin, S.n); S.L = rd(std::cin, S.n); S.O = rd(std::cin, S.n); S.C = rd(std::cin, S.n);
      S.U = rd(std::cin, S.n); S.W = rd(std::cin, S.n); S.B = rd(std::cin, S.n); S.A = rd(std::cin, S.n);
      std::printf("BEGIN %s\n", id.c_str());
      CheckSignal(0);
      std::printf("END\n");
    } else if(cmd == "RC") {
      int il, pine; double o, c, a; std::cin >> il >> o >> c >> a >> pine;
      std::printf("%d\n", PurpleReactionCore(il, o, c, a, pine) ? 1 : 0);
    } else if(cmd == "TAG") {
      std::string c; int dir; std::cin >> c >> dir;
      std::printf("%s|\n", ExtractSignalTag(c, dir).c_str());
    } else if(cmd == "AUTOB") {
      AUTOB_CHUNK
    } else if(cmd == "ADX") {
      std::string t; std::cin >> t >> S.adx;
      std::printf("%d\n", AdxFilterOk(0, "EURUSD", t) ? 1 : 0);
#ifdef NUOVO
    } else if(cmd == "AC") {
      int il, ru, rdn, mu, md, ou, od, ordu, ordd, re, lb, ft; double lc, hc, bl, bu;
      std::cin >> il >> ru >> rdn >> mu >> md >> ou >> od >> lc >> hc >> bl >> bu >> ordu >> ordd >> re >> lb >> ft;
      std::printf("%d\n", AzureCore(il, ru, rdn, mu, md, ou, od, lc, hc, bl, bu, ordu, ordd, re, lb, ft) ? 1 : 0);
    } else if(cmd == "OR") {
      int n, from, to; double atr, mx; std::cin >> n; Arr h, l; h.v = rd(std::cin, n); l.v = rd(std::cin, n);
      std::cin >> from >> to >> atr >> mx;
      std::printf("%d\n", AzureOrderedRetrace(h, l, from, to, atr, mx) ? 1 : 0);
    } else if(cmd == "AUTOTEST") {
      AUTOTEST_CHUNK
#endif
    }
  }
  return 0;
}
"""


def to_cxx(block):
    out = re.sub(r"(const\s+)?double\s*&\s*(\w+)\[\]", lambda m: (m.group(1) or "") + "Arr &" + m.group(2), block)
    out = re.sub(r"\bdouble\s+(\w+\[\](?:\s*,\s*\w+\[\])*)\s*;",
                 lambda m: "Arr " + m.group(1).replace("[]", "") + ";", out)
    out = re.sub(r"\bdouble\s+(\w+)\[\d+\]\s*=", r"Arr \1 =", out)
    return out


def togli_stampe(block):
    """toglie le istruzioni Print/PrintFormat (anche su piu' righe) e gli 'if(...)' che le reggono."""
    code = maschera(block)
    out, i = [], 0
    for m in re.finditer(r"(?m)^[ \t]*(?:if\s*\([^\n]*\)\s*\n[ \t]*)?(?:Print|PrintFormat)\s*\(", code):
        if m.start() < i:
            continue
        k = code.index("(", m.end() - 1)
        j = chiusa(code, k)
        e = code.index(";", j) + 1
        out.append(block[i:m.start()])
        i = e
    out.append(block[i:])
    return "".join(out)


def pezzo_b(src):
    """la prova B) dell'autotest (VIOLA-EA su barra chiusa), cosi' com'e' scritta nel sorgente."""
    at = funzioni(src)["AutoTestBulge"]
    a = at.index("   bool eImpuls")
    b = at.index(";", at.index("   bool aEA")) + 1
    return to_cxx(togli_stampe(at[a:b])) + '\n      std::printf("%d %d\\n", eLargo ? 1 : 0, aEA ? 1 : 0);\n'


def pezzo_autotest(src):
    at = funzioni(src)["AutoTestBulge"]
    a = at.index("   bool pVerdeL")
    b = at.index("   bool aR92")
    b = at.index(";", b) + 1
    c = at.index("   double azH[5]")
    d = at.index("   if(!(aAzz && aViola))")
    pezzo = at[a:b] + "\n" + at[c:d]
    pezzo = togli_stampe(pezzo)
    return to_cxx(pezzo) + '\n      std::printf("%d %d\\n", aAzz ? 1 : 0, aViola ? 1 : 0);\n'


class Cxx:
    def __init__(self, src, tmp, nuovo):
        self.ok, self.err = False, ""
        cxx = shutil.which("g++") or shutil.which("clang++")
        if not cxx:
            self.err = "compilatore C++ assente"
            return
        fn = funzioni(src)
        nomi = ["ExtractSignalTag", "AdxFilterOk", "PurpleReactionCore", "PurpleReactionOk"]
        if nuovo:
            nomi += ["AzureOrderedRetrace", "AzureCore"]
        nomi += ["CheckSignal"]
        try:
            pure = "\n\n".join(to_cxx(fn[n]) for n in nomi)
            drv = DRIVER.replace("AUTOTEST_CHUNK", pezzo_autotest(src) if nuovo else "")
            drv = drv.replace("AUTOB_CHUNK", pezzo_b(src))
        except (KeyError, ValueError) as ex:
            self.err = "estrazione fallita: %s" % ex
            return
        for nm, txt in (("shim.h", SHIM), ("pure.h", pure), ("drv.cpp", drv)):
            with open(os.path.join(tmp, nm), "w") as f:
                f.write(txt)
        self.exe = os.path.join(tmp, "drv")
        cmd = [cxx, "-std=c++17", "-O1", "-ffp-contract=off", "-Wall", "-Wno-unused-variable",
               "-Wno-unused-but-set-variable", "-Wno-misleading-indentation", "-o", self.exe, os.path.join(tmp, "drv.cpp")]
        if nuovo:
            cmd.insert(1, "-DNUOVO")
        r = subprocess.run(cmd, capture_output=True, text=True)
        self.err = r.stderr
        self.ok = r.returncode == 0

    def run(self, text):
        r = subprocess.run([self.exe], input=text, capture_output=True, text=True)
        if r.returncode != 0:
            return None
        return r.stdout.split("\n")


# ===========================================================================
# scenari
# ===========================================================================
class Cfg:
    def __init__(self, **kw):
        self.off, self.lb = 1, 20
        self.orange, self.blue, self.purple, self.azure, self.pine = 0, 0, 0, 1, 0
        self.maxr, self.first = 1.5, 0
        self.adx_use, self.adx_thr, self.a_blue, self.a_purple, self.a_orange, self.a_azure = 1, 30.0, 1, 0, 0, 0
        self.__dict__.update(kw)

    def riga(self):
        return "CFG %d %d %d %d %d %d %d %r %d %d %r %d %d %d %d\n" % (
            self.off, self.lb, self.orange, self.blue, self.purple, self.azure, self.pine, self.maxr, self.first,
            self.adx_use, self.adx_thr, self.a_blue, self.a_purple, self.a_orange, self.a_azure)


class Win:
    def __init__(self, n):
        self.n = n
        self.H, self.L, self.O, self.C = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
        self.U, self.W, self.B, self.A = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
        self.widthMA, self.atrOk, self.adx = 0.015, 1, -1.0

    def riga(self, wid):
        s = "SCN %s %d %r %d %r\n" % (wid, self.n, self.widthMA, self.atrOk, self.adx)
        for arr in (self.H, self.L, self.O, self.C, self.U, self.W, self.B, self.A):
            s += " ".join(repr(float(x)) for x in arr) + "\n"
        return s

    def copia(self):
        w = Win(self.n)
        for k in ("H", "L", "O", "C", "U", "W", "B", "A"):
            setattr(w, k, list(getattr(self, k)))
        w.widthMA, w.atrOk, w.adx = self.widthMA, self.atrOk, self.adx
        return w

    def specchio(self):
        """prezzo p -> 2 - p: rialzo <-> ribasso, banda alta <-> banda bassa."""
        w = Win(self.n)
        w.H = [2.0 - x for x in self.L]
        w.L = [2.0 - x for x in self.H]
        w.O = [2.0 - x for x in self.O]
        w.C = [2.0 - x for x in self.C]
        w.U = [2.0 - x for x in self.W]
        w.W = [2.0 - x for x in self.U]
        w.B = [2.0 - x for x in self.B]
        w.A = list(self.A)
        w.widthMA, w.atrOk, w.adx = self.widthMA, self.atrOk, self.adx
        return w

    def barra(self, k, o, c, h, l):
        self.O[k], self.C[k], self.H[k], self.L[k] = o, c, h, l


def base_long(imp=6, n=60):
    """LONG AZZURRA valido, scritto a mano. Indici come le serie MT5: 0 = barra in formazione, 1 = iCnf,
    2 = iSig. Bande piatte: alta 1.010, bassa 0.990, mediana 1.000; ATR 0.004 (1,5 x ATR = 0.006).
    Barra 1 e 2 hanno mediana/ATR/banda bassa DIVERSE dalle altre, cosi' un indice sbagliato si vede."""
    w = Win(n)
    for k in range(n):
        w.barra(k, 1.005, 1.005, 1.007, 1.003)            # neutre: corpo 0, sopra la mediana, range 0.004
        w.U[k], w.W[k], w.B[k], w.A[k] = 1.010, 0.990, 1.000, 0.004
    w.A[1] = 0.0041                                         # ATR della conferma != ATR del segnale
    w.B[1] = 0.9993                                         # mediana della conferma != del segnale
    w.W[2] = 0.985                                          # banda bassa del segnale != della conferma
    w.barra(imp, 1.000, 1.008, 1.011, 1.000)               # IMPULSO RIALZISTA: tocca 1.010, corpo 0.008, range 0.011
    w.barra(5, 1.007, 1.005, 1.008, 1.004) if imp > 5 else None
    w.barra(4, 1.005, 1.002, 1.006, 1.001) if imp > 4 else None
    w.barra(3, 1.002, 0.999, 1.003, 0.998)                 # attraversa la mediana (1.000)
    w.barra(2, 0.999, 0.995, 0.999, 0.994)                 # iSig
    w.barra(1, 0.993, 0.991, 0.994, 0.989)                 # iCnf: ROSSA, corpo 0.002, tocca 0.990
    w.barra(0, 0.991, 0.991, 0.991, 0.991)
    return w


def scenari_a_mano():
    """(id, cfg, finestra, ordini attesi) -- ordini come (lato, commento, atr, mediana)."""
    L = (1, "BULGE_AZZURRA_AZZURRA_L", 0.004, 0.9993)
    S = (0, "BULGE_AZZURRA_AZZURRA_S", 0.004, 2.0 - 0.9993)
    out = []
    c0 = Cfg()
    out.append(("long_valido", c0, base_long(), [L]))
    out.append(("short_specchiato", c0, base_long().specchio(), [S]))
    w = base_long(); w.barra(1, 0.998, 0.989, 0.999, 0.988)
    out.append(("candela_test_impulsiva", c0, w, []))
    w = base_long(); w.barra(4, 1.005, 1.002, 1.009, 1.001)
    out.append(("ritracciamento_disordinato", c0, w, []))
    out.append(("ritracciamento_disordinato_controllo_spento", Cfg(maxr=0.0), w, [L]))
    out.append(("disordinato_specchiato", c0, w.specchio(), []))
    w = base_long(); w.barra(1, 1.006, 1.008, 1.011, 1.005)
    out.append(("tocca_la_banda_sbagliata", c0, w, []))
    w = base_long(); w.barra(6, 1.000, 0.992, 1.001, 0.989); w.W[6] = 0.990
    out.append(("impulso_nel_verso_sbagliato", c0, w, []))
    w = base_long(); w.B[2] = 0.9935; w.B[3] = 0.997
    out.append(("mediana_non_attraversata", c0, w, []))
    out.append(("mediana_non_attraversata_specchiato", c0, w.specchio(), []))
    w = base_long(); w.W[3] = 0.998
    out.append(("tocco_precedente_ogni_tocco", c0, w, [L]))
    out.append(("tocco_precedente_solo_primo", Cfg(first=1), w, []))
    out.append(("tocco_precedente_solo_primo_specchiato", Cfg(first=1), w.specchio(), []))
    out.append(("primo_tocco_vero_solo_primo", Cfg(first=1), base_long(), [L]))
    out.append(("finestra_rel40", c0, base_long(imp=41), [L]))
    out.append(("finestra_rel41", c0, base_long(imp=42), []))
    out.append(("finestra_rel41_specchiato", c0, base_long(imp=42).specchio(), []))
    w = base_long(); w.barra(1, 0.993, 0.991, 1.000, 0.985)
    out.append(("spike_sulla_candela_di_test", c0, w, [L]))
    out.append(("candela_test_rossa_con_viola_pine", Cfg(pine=1), base_long(), [L]))
    out.append(("candela_test_rossa_short_viola_pine", Cfg(pine=1), base_long().specchio(), [S]))
    w = base_long(); w.adx = 35.0
    out.append(("adx_alto_azzurra_spento", c0, w, [L]))
    out.append(("adx_alto_azzurra_acceso", Cfg(a_azure=1), w, []))
    out.append(("adx_alto_azzurra_acceso_short", Cfg(a_azure=1), w.specchio(), []))
    out.append(("adx_alto_solo_viola_acceso", Cfg(a_purple=1, a_blue=1, a_orange=1), w, [L]))
    w = base_long(); w.adx = 25.0
    out.append(("adx_basso_azzurra_acceso", Cfg(a_azure=1), w, [L]))
    out.append(("use_azure_spento", Cfg(azure=0), base_long(), []))
    w = base_long(); w.atrOk = 0
    out.append(("filtro_atr_chiuso", c0, w, []))
    return out


def e_azzurra(commento):
    """un ordine e' AZZURRA dal SUFFISSO: il prefisso "BULGE_AZZURRA" contiene gia' "_AZZURRA_" anche negli
    ordini VIOLA/BLU/ARANCIO (e' il tranello che ExtractSignalTag evita: ci era caduto anche questo collaudo)."""
    return commento.endswith("_AZZURRA_L") or commento.endswith("_AZZURRA_S")


def parse_ordini(lines):
    res, cur = {}, None
    for ln in lines:
        if ln.startswith("BEGIN "):
            cur = ln[6:]
            res[cur] = []
        elif ln.startswith("ORD ") and cur is not None:
            p = ln.split()
            res[cur].append((int(p[1]), p[4], float(p[2]), float(p[3])))
        elif ln.startswith("OOR"):
            res.setdefault("__OOR__", []).append(ln)
    return res


# --- serie casuali: random walk a regimi, BB(20,2) e ATR(14) calcolati qui ---
def serie(seed, n=2500):
    rnd = random.Random(seed)
    o, h, l, c = [], [], [], []
    p, sig = 1.0, 0.002
    for i in range(n):
        if rnd.random() < 0.03:
            sig = rnd.choice([0.001, 0.002, 0.004, 0.006])
        op = p + rnd.gauss(0, sig * 0.05)
        cl = op + rnd.gauss(0, sig) + (rnd.choice([-1, 1]) * sig * 2.5 if rnd.random() < 0.04 else 0.0)
        hi = max(op, cl) + abs(rnd.gauss(0, sig * 0.4))
        lo = min(op, cl) - abs(rnd.gauss(0, sig * 0.4))
        o.append(op); h.append(hi); l.append(lo); c.append(cl)
        p = cl
    up, dn, md, at = [0.0] * n, [0.0] * n, [0.0] * n, [0.0] * n
    for i in range(n):
        a = max(0, i - 19)
        win = c[a:i + 1]
        m = sum(win) / len(win)
        sd = (sum((x - m) ** 2 for x in win) / len(win)) ** 0.5
        md[i], up[i], dn[i] = m, m + 2 * sd, m - 2 * sd
        trs = []
        for k in range(max(0, i - 13), i + 1):
            pc = c[k - 1] if k > 0 else o[k]
            trs.append(max(h[k] - l[k], abs(h[k] - pc), abs(l[k] - pc)))
        at[i] = sum(trs) / len(trs)
    return o, h, l, c, up, dn, md, at


def finestre(seed, quante, n=60):
    rnd = random.Random(seed * 7 + 1)
    o, h, l, c, up, dn, md, at = serie(seed)
    out = []
    for _ in range(quante):
        t = rnd.randrange(80, len(c))
        w = Win(n)
        for k in range(n):
            j = t - k
            w.O[k], w.H[k], w.L[k], w.C[k] = o[j], h[j], l[j], c[j]
            w.U[k], w.W[k], w.B[k], w.A[k] = up[j], dn[j], md[j], at[j]
        w.adx = rnd.uniform(15.0, 45.0)
        w.atrOk = 1 if rnd.random() < 0.9 else 0
        out.append(w)
    return out


def py_azzurra(w, cfg):
    """specchio Python della regola AZZURRA, scritto dalla specifica (non tradotto dal C++)."""
    B = cfg.off
    iCnf, iSig = B, B + 1
    N = cfg.lb * 2 + 10 + B
    if not cfg.azure or w.n < N or not w.atrOk:
        return []
    atrSig = w.A[iSig]
    if atrSig <= 0 or w.widthMA <= 0:
        return []
    up = dn = -1
    for k in range(iSig, N - 1):
        corpo = abs(w.C[k] - w.O[k])
        if up < 0 and w.H[k] >= w.U[k] and w.C[k] > w.O[k] and corpo >= w.A[k] * 0.2:
            up = k
        if dn < 0 and w.L[k] <= w.W[k] and w.C[k] < w.O[k] and corpo >= w.A[k] * 0.2:
            dn = k
    out = []
    candela_ok = abs(w.C[iCnf] - w.O[iCnf]) <= atrSig * 1.5
    for lungo in (True, False):
        imp = up if lungo else dn
        if imp < 0 or not (1 <= imp - B <= cfg.lb * 2):
            continue
        fra = range(iSig, imp)
        if not any(w.H[k] >= w.B[k] and w.L[k] <= w.B[k] for k in fra):
            continue
        tocco_prima = any((w.L[k] <= w.W[k]) if lungo else (w.H[k] >= w.U[k]) for k in fra)
        if cfg.first and tocco_prima:
            continue
        if not ((w.L[iCnf] <= w.W[iCnf]) if lungo else (w.H[iCnf] >= w.U[iCnf])):
            continue
        if cfg.maxr > 0 and any(w.H[k] - w.L[k] > atrSig * cfg.maxr for k in fra):
            continue
        if not candela_ok:
            continue
        if cfg.adx_use and cfg.a_azure and w.adx >= 0 and w.adx >= cfg.adx_thr:
            continue
        out.append((1 if lungo else 0, "BULGE_AZZURRA_AZZURRA_" + ("L" if lungo else "S"), atrSig, w.B[iCnf]))
    return out


# ===========================================================================
# P + X
# ===========================================================================
def casi_puri(cx, bag, quiet=False):
    # AzureCore: (attesa, argomenti) -- caso base LONG valido, poi una condizione rotta alla volta
    B = [1, 5, -1, 1, 0, 0, 0, 0.9890, 1.0010, 0.9900, 1.0100, 1, 1, 1, 20, 0]
    Sh = [0, -1, 5, 0, 1, 0, 0, 0.9990, 1.0110, 0.9900, 1.0100, 1, 1, 1, 20, 0]

    def v(base, **kw):
        a = list(base)
        idx = {"lato": 0, "ru": 1, "rd": 2, "mu": 3, "md": 4, "ou": 5, "od": 6, "lc": 7, "hc": 8, "bl": 9, "bu": 10,
               "ordu": 11, "ordd": 12, "re": 13, "lb": 14, "ft": 15}
        for k, x in kw.items():
            a[idx[k]] = x
        return a
    casi = [
        ("long valido", 1, B), ("short valido", 1, Sh),
        ("long con le misure dello short", 0, v(Sh, lato=1)), ("short con le misure del long", 0, v(B, lato=0)),
        ("candela di test impulsiva (long)", 0, v(B, re=0)), ("candela di test impulsiva (short)", 0, v(Sh, re=0)),
        ("ritracciamento disordinato (long)", 0, v(B, ordu=0)), ("ritracciamento disordinato (short)", 0, v(Sh, ordd=0)),
        ("long: il disordine dell'ALTRO verso non conta", 1, v(B, ordd=0)),
        ("short: il disordine dell'ALTRO verso non conta", 1, v(Sh, ordu=0)),
        ("long: banda bassa non toccata (sopra di 1 pip)", 0, v(B, lc=0.9901)),
        ("long: tocco esatto della banda bassa", 1, v(B, lc=0.9900)),
        ("long: tocca la banda ALTA invece della bassa", 0, v(B, lc=0.9950, hc=1.0100)),
        ("short: tocca la banda BASSA invece dell'alta", 0, v(Sh, hc=1.0050, lc=0.9900)),
        ("long con impulso RIBASSISTA", 0, v(B, ru=-1, rd=5, mu=0, md=1)),
        ("short con impulso RIALZISTA", 0, v(Sh, ru=5, rd=-1, mu=1, md=0)),
        ("long senza mediana", 0, v(B, mu=0)), ("long: la mediana dell'altro verso non basta", 0, v(B, mu=0, md=1)),
        ("short senza mediana", 0, v(Sh, md=0)), ("short: la mediana dell'altro verso non basta", 0, v(Sh, md=0, mu=1)),
        ("long, tocco precedente, ogni tocco", 1, v(B, ou=1)), ("long, tocco precedente, solo il primo", 0, v(B, ou=1, ft=1)),
        ("long, nessun tocco precedente, solo il primo", 1, v(B, ft=1)),
        ("long: il tocco precedente dell'ALTRO verso non conta", 1, v(B, od=1, ft=1)),
        ("short, tocco precedente, solo il primo", 0, v(Sh, od=1, ft=1)), ("short, tocco precedente, ogni tocco", 1, v(Sh, od=1)),
        ("finestra rel 0", 0, v(B, ru=0)), ("finestra rel 1", 1, v(B, ru=1)), ("finestra rel 40", 1, v(B, ru=40)),
        ("finestra rel 41", 0, v(B, ru=41)), ("finestra short rel 41", 0, v(Sh, rd=41)),
        ("finestra con Lookback 10: rel 20", 1, v(B, ru=20, lb=10)), ("finestra con Lookback 10: rel 21", 0, v(B, ru=21, lb=10)),
    ]
    txt = "".join("AC " + " ".join(repr(x) if isinstance(x, float) else str(x) for x in a) + "\n" for _, _, a in casi)
    # AzureOrderedRetrace: atr 1.0 => soglie esatte in binario
    H = [10.0, 10.0, 10.0, 10.0, 10.0, 99.0]
    Lr = [8.5, 9.0, 9.0, 9.0, 9.0, 0.0]          # [0] range 1.5 esatto, [5] = impulso enorme
    orc = [
        ("range = 1,5 x ATR esatto: ammesso", 1, H, Lr, 0, 5, 1.0, 1.5),
        ("range 1,5 x ATR con soglia 1,49: respinto", 0, H, Lr, 0, 5, 1.0, 1.49),
        ("l'impulso (toExcl) e' escluso", 1, H, Lr, 0, 5, 1.0, 1.5),
        ("l'impulso dentro la finestra respinge", 0, H, Lr, 0, 6, 1.0, 1.5),
        ("la barra 'from' e' inclusa", 0, H, [8.4] + Lr[1:], 0, 5, 1.0, 1.5),
        ("barre prima di 'from' escluse", 1, H, [8.4] + Lr[1:], 1, 5, 1.0, 1.5),
        ("soglia 0 = controllo spento", 1, H, Lr, 0, 6, 1.0, 0.0),
        ("soglia negativa = controllo spento", 1, H, Lr, 0, 6, 1.0, -1.0),
        ("finestra vuota (impulso assente, toExcl -1)", 1, H, Lr, 2, -1, 1.0, 1.5),
    ]
    for _, _, h, l, a, b, at, mx in orc:
        txt += "OR %d %s %s %d %d %r %r\n" % (len(h), " ".join(map(repr, h)), " ".join(map(repr, l)), a, b, at, mx)
    tags = [("BULGE_AZZURRA_AZZURRA_L", 1, "AZZURRA LONG"), ("BULGE_AZZURRA_AZZURRA_S", 1, "AZZURRA SHORT"),
            ("BULGE_AZZURRA_AZZURRA_L", 0, "AZZURRA"), ("BULGE_AZZURRA_VIOLA_L", 1, "VIOLA LONG"),
            ("BULGE_AZZURRA_BLU_S", 1, "BLU SHORT"), ("BULGE_AZZURRA_ARANCIO_L", 1, "ARANCIO LONG"),
            ("BULGE_AZZURRA_VIO", 0, "?"), ("BULGE_AZZURRA", 1, "?"), ("BULGE_VIOLA_S", 1, "VIOLA SHORT"),
            ("BULGE_AZZURRA_L", 1, "AZZURRA LONG"), ("commento_di_un_altro", 1, "?")]
    for c, d, _ in tags:
        txt += "TAG %s %d\n" % (c, d)
    adx = [("AZZURRA", 35.0, 1), ("AZZURRA", 25.0, 1), ("VIOLA", 35.0, 1), ("BLU", 35.0, 0)]
    txt0 = txt + "CFG 1 20 0 0 0 1 0 1.5 0 1 30.0 1 0 0 0\n" + "".join("ADX %s %r\n" % (t, a) for t, a, _ in adx)
    txt0 += "CFG 1 20 0 0 0 1 0 1.5 0 1 30.0 1 0 0 1\n" + "ADX AZZURRA 35.0\nADX AZZURRA 25.0\nADX VIOLA 35.0\n"
    txt0 += "AUTOTEST\nAUTOB\n"
    out = cx.run(txt0)
    if out is None:
        check(False, "driver C++ dei casi puri uscito con errore", bag)
        return
    out = [x for x in out if x != ""]
    k = 0
    ok_ac = 0
    for nome, att, _ in casi:
        if check(out[k] == str(att), "AzureCore: %s -> %s" % (nome, "entra" if att else "no"), bag, quiet=True):
            ok_ac += 1
        k += 1
    check(ok_ac == len(casi), "AzureCore: %d/%d casi scritti a mano" % (ok_ac, len(casi)), bag, quiet=quiet)
    ok_or = 0
    for nome, att, *_ in orc:
        if check(out[k] == str(att), "AzureOrderedRetrace: %s" % nome, bag, quiet=True):
            ok_or += 1
        k += 1
    check(ok_or == len(orc), "AzureOrderedRetrace: %d/%d casi (bordo esatto, finestra [from,toExcl), soglia 0)" % (ok_or, len(orc)), bag, quiet=quiet)
    ok_t = 0
    for c, d, att in tags:
        if check(out[k] == att + "|", "ExtractSignalTag(%s,%d) = %s (trovato %s)" % (c, d, att, out[k]), bag, quiet=True):
            ok_t += 1
        k += 1
    check(ok_t == len(tags), "ExtractSignalTag: %d/%d (prefisso BULGE_AZZURRA, VIOLA dentro AZZURRA, troncato -> ?)" % (ok_t, len(tags)), bag, quiet=quiet)
    att_adx = ["1", "1", "1", "0", "0", "1", "1"]   # ADX_Apply_On_Azure=false: AZZURRA mai bloccata; poi acceso
    got = out[k:k + 7]
    k += 7
    check(got == att_adx, "AdxFilterOk: AZZURRA bloccata SOLO con ADX_Apply_On_Azure e ADX >= soglia (%s)" % got, bag, quiet=quiet)
    check(out[k] == "1 1", "autotest dell'EA (pezzo vero, compilato): AZZURRA=PASS e VIOLA invariato=PASS (%s)" % out[k], bag, quiet=quiet)
    check(out[k + 1] == "0 1", "autotest B) nella copia AZZURRA: eLargo scartato, aEA=PASS (%s)" % out[k + 1], bag, quiet=quiet)


def viola_pura(cx_old, cx_new, bag, quiet=False):
    grid = []
    for il in (0, 1):
        for pine in (0, 1):
            for o, c in ((1.1, 1.1), (1.1, 1.1002), (1.1002, 1.1), (1.1, 1.1015), (1.1, 1.10151), (1.1, 1.102)):
                grid.append("RC %d %r %r 0.001 %d\n" % (il, o, c, pine))
    a, b = cx_old.run("".join(grid)), cx_new.run("".join(grid))
    check(a is not None and a == b and len([x for x in a if x]) == len(grid),
          "PurpleReactionCore (VIOLA): stessa tabella su ABTG_Bulge e AZZURRA (%d casi, EA e PINE, long e short)" % len(grid), bag, quiet=quiet)


def scenari(cx_new, cx_old, bag, quiet=False, ridotto=False):
    # (1) a mano
    sc = scenari_a_mano()
    txt = "".join(c.riga() + w.riga(nome) for nome, c, w, _ in sc)
    out = cx_new.run(txt)
    if out is None:
        check(False, "CheckSignal AZZURRA (C++) uscita con errore sugli scenari a mano", bag)
        return
    res = parse_ordini(out)
    check("__OOR__" not in res, "nessun indice fuori dagli array negli scenari a mano", bag, quiet=quiet)
    nok = 0
    for nome, c, w, att in sc:
        got = res.get(nome)
        ok = got is not None and len(got) == len(att) and all(
            g[0] == a[0] and g[1] == a[1] and abs(g[2] - a[2]) < 1e-12 and abs(g[3] - a[3]) < 1e-12 for g, a in zip(got, att))
        if check(ok, "scenario %s: atteso %s, trovato %s" % (nome, att, got), bag, quiet=True):
            nok += 1
        if not ok and quiet:
            pass
    check(nok == len(sc), "CheckSignal VERA, scenari a mano: %d/%d (lato, commento, ATR del segnale, mediana della conferma)"
          % (nok, len(sc)), bag, quiet=quiet)
    # (2) differenziale e (3) specchio Python, su serie casuali
    quante = 250 if ridotto else 1500
    semi = (11, 23) if ridotto else (11, 23, 37, 51)
    wins = []
    for s in semi:
        wins += finestre(s, quante)
    tutti_vecchi = [Cfg(off=1, orange=1, blue=1, purple=1, azure=0, pine=0),
                    Cfg(off=1, orange=1, blue=1, purple=1, azure=0, pine=1),
                    Cfg(off=0, orange=1, blue=1, purple=1, azure=0, pine=0),
                    Cfg(off=1, orange=1, blue=1, purple=1, azure=0, pine=0, a_purple=1, a_orange=1)]
    conta = {"VIOLA": 0, "BLU": 0, "ARANCIO": 0}
    for ci, c in enumerate(tutti_vecchi):
        cv = Cfg(**dict(c.__dict__)); cv.azure = 0
        old_c = Cfg(**dict(c.__dict__))
        body = "".join(w.riga("d%d_%d" % (ci, i)) for i, w in enumerate(wins))
        r_new = cx_new.run(cv.riga() + body)
        r_old = cx_old.run(old_c.riga() + body)
        if r_new is None or r_old is None:
            check(False, "differenziale cfg %d: un driver e' uscito con errore" % ci, bag)
            continue
        pn, po = parse_ordini(r_new), parse_ordini(r_old)
        # il commento di ABTG_Bulge nel driver e' quello della shim ("BULGE_AZZURRA"): stesso prefisso per tutti e due
        uguali = pn == po
        for v in po.values():
            for o in v:
                for t in conta:
                    if "_%s_" % t in o[1]:
                        conta[t] += 1
        check(uguali and "__OOR__" not in pn, "differenziale cfg %d (offset %d, viola %s, ADX viola %d): Use_Azure spento -> stessi ordini di ABTG_Bulge su %d finestre"
              % (ci, c.off, "PINE" if c.pine else "EA", c.a_purple, len(wins)), bag, quiet=quiet)
        # con AZZURRA accesa, gli ordini non-AZZURRA restano quelli
        ca = Cfg(**dict(c.__dict__)); ca.azure = 1
        r_acc = cx_new.run(ca.riga() + body)
        pa = parse_ordini(r_acc) if r_acc is not None else {}
        filtrati = {k: [o for o in v if not e_azzurra(o[1])] for k, v in pa.items()}
        check(r_acc is not None and filtrati == po,
              "differenziale cfg %d: Use_Azure ACCESO non sposta nessun ordine BLU/VIOLA/ARANCIO" % ci, bag, quiet=quiet)
    check(min(conta.values()) > 0, "il differenziale MORDE: ordini di ABTG_Bulge nelle finestre casuali %s" % conta, bag, quiet=quiet)
    # (3) specchio Python
    tot = {0: 0, 1: 0}
    disaccordi = 0
    for ci, c in enumerate([Cfg(), Cfg(first=1), Cfg(maxr=0.0), Cfg(off=0), Cfg(a_azure=1), Cfg(lb=10),
                            Cfg(orange=1, blue=1, purple=1, pine=1)]):
        body = "".join(w.riga("p%d_%d" % (ci, i)) for i, w in enumerate(wins))
        r = cx_new.run(c.riga() + body)
        if r is None:
            check(False, "specchio cfg %d: driver uscito con errore" % ci, bag)
            continue
        pr = parse_ordini(r)
        for i, w in enumerate(wins):
            got = [o for o in pr.get("p%d_%d" % (ci, i), []) if e_azzurra(o[1])]
            att = py_azzurra(w, c)
            for o in att:
                tot[o[0]] += 1
            if got != att:
                disaccordi += 1
                if disaccordi <= 3:
                    print("        disaccordo cfg %d finestra %d: C++ %s / Python %s" % (ci, i, got, att))
    check(disaccordi == 0, "specchio Python indipendente == CheckSignal VERA su %d finestre x 7 configurazioni (disaccordi %d)"
          % (len(wins), disaccordi), bag, quiet=quiet)
    soglia = 10 if ridotto else 40
    check(tot[1] >= soglia and tot[0] >= soglia, "lo specchio MORDE: AZZURRA long %d, short %d (>= %d ciascuno)"
          % (tot[1], tot[0], soglia), bag, quiet=quiet)


def suite(raw, old, cx_old, tmp, bag, quiet=False, ridotto=False):
    """ritorna il dizionario strato -> numero di difetti"""
    strati = {}
    b = []
    statico(raw, old, b, quiet=quiet)
    strati["S"] = b
    b = []
    try:
        controlla_zone(old, raw.decode("latin-1"), b, quiet=quiet)
    except Exception as ex:          # noqa: BLE001
        b.append("zone: %s" % ex)
    strati["Z"] = b
    cx = Cxx(raw.decode("latin-1"), tmp, nuovo=True)
    bp, bx = [], []
    if not cx.ok:
        bp.append("compilazione C++ fallita: %s" % cx.err[:400])
        bx.append("compilazione C++ fallita")
    else:
        casi_puri(cx, bp, quiet=quiet)
        viola_pura(cx_old, cx, bp, quiet=quiet)
        scenari(cx, cx_old, bx, quiet=quiet, ridotto=ridotto)
    strati["P"], strati["X"] = bp, bx
    return strati


# ===========================================================================
# M) MUTANTI
# ===========================================================================
G = 'if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_BulgeAzzurra")) return;\n'
MUTANTI = [
    # (id, descrizione, vecchio, nuovo, occorrenza, tipo)   tipo L = logica (deve prenderlo P o X)
    ("L01", "lato LONG invertito", 'OpenOrder(sym, true,  atrSig, bbBasisCnf, InpComment + "_AZZURRA_L")',
     'OpenOrder(sym, false, atrSig, bbBasisCnf, InpComment + "_AZZURRA_L")', 0, "L"),
    ("L02", "lato SHORT invertito", 'OpenOrder(sym, false, atrSig, bbBasisCnf, InpComment + "_AZZURRA_S")',
     'OpenOrder(sym, true, atrSig, bbBasisCnf, InpComment + "_AZZURRA_S")', 0, "L"),
    ("L03", "long testa la banda ALTA", "             lowCnf <= bbLowerCnf &&", "             highCnf >= bbUpperCnf &&", 0, "L"),
    ("L04", "short testa la banda BASSA", "          highCnf >= bbUpperCnf &&", "          lowCnf <= bbLowerCnf &&", 0, "L"),
    ("L05", "long dopo impulso RIBASSISTA", "      return relImpUp >= 1 && relImpUp <= lookback * 2 &&",
     "      return relImpDown >= 1 && relImpDown <= lookback * 2 &&", 0, "L"),
    ("L06", "short dopo impulso RIALZISTA", "   return relImpDown >= 1 && relImpDown <= lookback * 2 &&",
     "   return relImpUp >= 1 && relImpUp <= lookback * 2 &&", 0, "L"),
    ("L07", "mediana non richiesta (long)", "             midAfterImpUp &&\n", "             true &&\n", 0, "L"),
    ("L08", "mediana non richiesta (short)", "          midAfterImpDown &&\n", "          true &&\n", 0, "L"),
    ("L09", "short usa la mediana del rialzo", "          midAfterImpDown &&\n", "          midAfterImpUp &&\n", 0, "L"),
    ("L10", "ordinato tolto (long)", "             orderedUp && reactionCnf;", "             reactionCnf;", 0, "L"),
    ("L11", "ordinato tolto (short)", "          orderedDown && reactionCnf;", "          reactionCnf;", 0, "L"),
    ("L12", "short usa l'ordinato del rialzo", "          orderedDown && reactionCnf;", "          orderedUp && reactionCnf;", 0, "L"),
    ("L13", "FirstTouch invertito (long)", "(!firstTouchOnly || !oppAfterImpUp)", "(firstTouchOnly || !oppAfterImpUp)", 0, "L"),
    ("L14", "FirstTouch invertito (short)", "(!firstTouchOnly || !oppAfterImpDown)", "(!firstTouchOnly || oppAfterImpDown)", 0, "L"),
    ("L15", "FirstTouch ignorato (long)", "(!firstTouchOnly || !oppAfterImpUp)", "(true)", 0, "L"),
    ("L16", "finestra Lookback invece di Lookback*2", "relImpUp <= lookback * 2", "relImpUp <= lookback", 0, "L"),
    ("L17", "relImp >= 0 invece di >= 1", "relImpUp >= 1 && relImpUp", "relImpUp >= 0 && relImpUp", 0, "L"),
    ("L18", "soglia dell'ordinato con >= invece di >", "if(highs[k] - lows[k] > atrSig * maxRangeATR)",
     "if(highs[k] - lows[k] >= atrSig * maxRangeATR)", 0, "L"),
    ("L19", "finestra dell'ordinato include la candela di test", "AzureOrderedRetrace(highs, lows, iSig, barsSinceImpUp,",
     "AzureOrderedRetrace(highs, lows, iCnf, barsSinceImpUp,", 0, "L"),
    ("L20", "finestra dell'ordinato include l'impulso", "for(int k = from; k < toExcl; k++)", "for(int k = from; k <= toExcl; k++)", 0, "L"),
    ("L21", "soglia 0 non spegne piu' il controllo", "   if(maxRangeATR <= 0.0) return true;\n", "", 0, "L"),
    ("L22", "candela di test segue la variante PINE del VIOLA",
     "PurpleReactionCore(true, opens[iCnf], closes[iCnf], atrSig, false)", "PurpleReactionOk(true, opens[iCnf], closes[iCnf], atrSig)", 0, "L"),
    ("L23", "candela di test non controllata", "             orderedUp && reactionCnf;", "             orderedUp;", 0, "L"),
    ("L24", "commento VIOLA sull'ordine AZZURRA", 'bbBasisCnf, InpComment + "_AZZURRA_L"', 'bbBasisCnf, InpComment + "_VIOLA_L"', 0, "L"),
    ("L25", "TP sulla mediana del SEGNALE invece che della conferma",
     'OpenOrder(sym, true,  atrSig, bbBasisCnf, InpComment + "_AZZURRA_L")', 'OpenOrder(sym, true,  atrSig, bbBasisSig, InpComment + "_AZZURRA_L")', 0, "L"),
    ("L26", "SL su ATR della conferma", 'OpenOrder(sym, false, atrSig, bbBasisCnf, InpComment + "_AZZURRA_S")',
     'OpenOrder(sym, false, atrSeries[iCnf], bbBasisCnf, InpComment + "_AZZURRA_S")', 0, "L"),
    ("L27", "ADX con l'etichetta VIOLA", 'if(azureLong  && AdxFilterOk(symIdx, sym, "AZZURRA"))', 'if(azureLong  && AdxFilterOk(symIdx, sym, "VIOLA"))', 0, "L"),
    ("L28", "AdxFilterOk non conosce AZZURRA", '   if(signalType == "AZZURRA" && ADX_Apply_On_Azure)  applyFilter = true;\n', "", 0, "L"),
    ("L29", "ADX tolto dallo short", 'if(azureShort && AdxFilterOk(symIdx, sym, "AZZURRA"))', "if(azureShort)", 0, "L"),
    ("L30", "long legge la banda del SEGNALE", "bbLowerCnf, bbUpperCnf, orderedUp, orderedDown,", "bbLowerSig, bbUpperSig, orderedUp, orderedDown,", 0, "L"),
    ("L31", "Azure_FirstTouchOnly non passato (long)", "reactionAzCnf, Lookback_Bars, Azure_FirstTouchOnly);",
     "reactionAzCnf, Lookback_Bars, false);", 0, "L"),
    ("L32", "Use_Azure ignorato", "   if(Use_Azure)\n   {", "   if(true)\n   {", 0, "L"),
    ("L33", "VIOLA toccato: banda piatta tolta", "lows[iCnf] <= bbLowerCnf && lowerFlat &&", "lows[iCnf] <= bbLowerCnf &&", 0, "L"),
    ("L34", "ordine dei tag: AZZURRA prima del VIOLA", '   if(StringFind(comment, "_BLU_")     >= 0) tag = "BLU";',
     '   if(StringFind(comment, "_AZZURRA") >= 0) tag = "AZZURRA";\n   else if(StringFind(comment, "_BLU_")     >= 0) tag = "BLU";', 0, "L"),
    ("L35", "tag AZZURRA tolto",
     '   else if(StringFind(comment, "_AZZURRA_L") >= 0 || StringFind(comment, "_AZZURRA_S") >= 0) tag = "AZZURRA";\n', "", 0, "L"),
    ("L36", "attesa dell'autotest sbagliata", "!aPrimo && aFin40", "aPrimo && aFin40", 0, "L"),
    ("L37", "ordinato del long sull'impulso ribassista", "AzureOrderedRetrace(highs, lows, iSig, barsSinceImpUp,",
     "AzureOrderedRetrace(highs, lows, iSig, barsSinceImpDown,", 0, "L"),
    ("L38", "caso eLargo dell'autotest riportato al valore difettoso di ABTG_Bulge",
     "PurpleReactionCore(true,  1.10000, 1.10170, 0.0010, false)", "PurpleReactionCore(true,  1.10000, 1.10020, 0.0010, false)", 0, "L"),
    ("S01", "BLU toccato", "bool confirmLong  = (closes[iCnf] > opens[iCnf]", "bool confirmLong  = (closes[iCnf] >= opens[iCnf]", 0, "S"),
    ("S02", "Guardian tolto prima del Buy", G + "      if(trade.Buy(", "      if(trade.Buy(", 0, "S"),
    ("S03", "Guardian spostato DOPO il Sell", G + "      if(trade.Sell(lots, sym, bid, sl, tp, comment))",
     "      if(trade.Sell(lots, sym, bid, sl, tp, comment) && ABTG_GuardiaIngresso(InpUsaGuardian, \"ABTG_BulgeAzzurra\"))", 0, "S"),
    ("S04", "InpUsaGuardian spento di default", "input bool   InpUsaGuardian = true;", "input bool   InpUsaGuardian = false;", 0, "S"),
    ("S05", "magic di ABTG_Bulge", "= 774500;", "= 772700;", 0, "S"),
    ("S06", "magic nel blocco occupato 7728xx", "= 774500;", "= 772800;", 0, "S"),
    ("S07", "commento di default BULGE", '"BULGE_AZZURRA";   // Prefisso', '"BULGE";   // Prefisso', 0, "S"),
    ("S08", "Use_Azure spento di default", "input bool   Use_Azure  = true;", "input bool   Use_Azure  = false;", 0, "S"),
    ("S09", "Use_Purple acceso di default", "input bool   Use_Purple = false;", "input bool   Use_Purple = true;", 0, "S"),
    ("S10", "Use_Blue acceso di default", "input bool   Use_Blue   = false;", "input bool   Use_Blue   = true;", 0, "S"),
    ("S11", "Azure_MaxRetraceRangeATR 1.0", "Azure_MaxRetraceRangeATR = 1.5;", "Azure_MaxRetraceRangeATR = 1.0;", 0, "S"),
    ("S12", "Azure_FirstTouchOnly acceso di default", "Azure_FirstTouchOnly = false;", "Azure_FirstTouchOnly = true;", 0, "S"),
    ("S13", "ADX_Apply_On_Azure acceso di default", "ADX_Apply_On_Azure  = false;", "ADX_Apply_On_Azure  = true;", 0, "S"),
    ("S14", "SL_ATR_Mult 2", "SL_ATR_Mult    = 3.0;", "SL_ATR_Mult    = 2.0;", 0, "S"),
    ("S15", "rischio 1%", "Risk_Percent          = 0.8;", "Risk_Percent          = 1.0;", 0, "S"),
    ("S16", "SL dimezzato in OpenOrder", "double slDist = atr * SL_ATR_Mult;", "double slDist = atr * SL_ATR_Mult * 0.5;", 0, "S"),
    ("S17", "TP spostato in OpenOrder", "double tp = NormalizeDouble(bbBasis, digits);", "double tp = NormalizeDouble(bbBasis + atr, digits);", 0, "S"),
    ("S18", "UpdateAllTP sulla barra in formazione", "if(!GetBB(symIdx, 1, bbU, bbL, bbMid)) continue;\n      double newTP",
     "if(!GetBB(symIdx, 0, bbU, bbL, bbMid)) continue;\n      double newTP", 0, "S"),
    ("S19", "conteggio AZZURRA tolto", 'else if(StringFind(c,"_AZZURRA_L")>=0 || StringFind(c,"_AZZURRA_S")>=0) nAzzurra++;',
     "else if(false) nAzzurra++;", 0, "S"),
    ("S20", "variante AZZURRA tolta dal nome del CSV", '+"_azzurra"+(Azure_FirstTouchOnly?"PRIMO":"OGNI")+".csv";', '+".csv";', 0, "S"),
    ("S21", "kill switch spento di default", "Use_Kill_Switch     = true;", "Use_Kill_Switch     = false;", 0, "S"),
    ("S22", "Signal_Bar_Offset 0 di default", "Signal_Bar_Offset = 1;", "Signal_Bar_Offset = 0;", 0, "S"),
    ("S23", "Lookback_Bars 10", "Lookback_Bars = 20;", "Lookback_Bars = 10;", 0, "S"),
    ("S24", "PrintFormat con un argomento in meno", "(Use_Purple ? \" VIOLA\" : \"\"), (Use_Azure ? \" AZZURRA\" : \"\"));",
     "(Use_Purple ? \" VIOLA\" : \"\"));", 0, "S"),
    ("S25", "Max_Trades 6", "Max_Trades            = 4;", "Max_Trades            = 6;", 0, "S"),
]


def applica(src, vecchio, nuovo, occ):
    n = src.count(vecchio)
    if n <= occ:
        return None
    p = -1
    for _ in range(occ + 1):
        p = src.find(vecchio, p + 1)
    return src[:p] + nuovo + src[p + len(vecchio):]


def mutanti(src, old, cx_old):
    print("\nM) MUTANTI CIECHI (%d), su copie fuori dal repo" % len(MUTANTI))
    presi = 0
    for mid, desc, v, n, occ, tipo in MUTANTI:
        mut = applica(src, v, n, occ)
        if mut is None:
            check(False, "%s %s: il punto da mutare non esiste (collaudo da aggiornare)" % (mid, desc))
            continue
        tmp = tempfile.mkdtemp(prefix="azz_mut_")
        try:
            strati = suite(mut.encode("latin-1"), old, cx_old, tmp, [], quiet=True, ridotto=True)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
        chi = "".join(k for k in "SZPX" if strati[k])
        comportamento = any(strati[k] for k in "PX")
        ok = bool(chi) and (tipo != "L" or comportamento)
        if ok:
            presi += 1
        print(("  ok   " if ok else "  FAIL ") + "%s %-55s preso da [%s]%s" % (
            mid, desc, chi or "-", "" if ok or not chi else "  <- logica presa SOLO dallo statico/diff"))
        if not ok:
            FAILS.append("mutante %s (%s) non preso come richiesto" % (mid, desc))
    check(presi == len(MUTANTI), "mutanti presi: %d/%d (logica: tutti presi da P o X)" % (presi, len(MUTANTI)))


# ===========================================================================
def main():
    raw = leggi(SRC_NEW)
    old = leggi(SRC_OLD).decode("ascii")
    print("collaudo ABTG_BulgeAzzurra.mq5 contro ABTG_Bulge.mq5\n")
    tmp_old = tempfile.mkdtemp(prefix="azz_old_")
    tmp_new = tempfile.mkdtemp(prefix="azz_new_")
    try:
        cx_old = Cxx(old, tmp_old, nuovo=False)
        check(cx_old.ok, "ABTG_Bulge: CheckSignal/PurpleReactionCore/AdxFilterOk/ExtractSignalTag compilate in C++ %s"
              % ("" if cx_old.ok else cx_old.err[:300]))
        if not cx_old.ok:
            raise SystemExit(1)
        rb = cx_old.run("AUTOB\n")
        print("INFO ABTG_Bulge.mq5 (NON toccato): prova B) dell'autotest compilata dal sorgente vero -> eLargo=%s aEA=%s "
              "(%s)" % (tuple((rb or ["? ?"])[0].split()) + ("aEA=0: la B) stampa *** FAIL *** a ogni avvio, difetto "
              "dell'AUTOTEST, non della logica; corretto SOLO nella copia AZZURRA" if rb and rb[0] == "1 0" else "come atteso",)))
        print("S) STATICO")
        b = []
        statico(raw, old, b)
        FAILS.extend(b)
        print("\nZ) ZONE DEL DIFF")
        b = []
        controlla_zone(old, raw.decode("ascii", "replace"), b)
        FAILS.extend(b)
        print("\nP) FUNZIONI PURE (C++)")
        cx = Cxx(raw.decode("ascii", "replace"), tmp_new, nuovo=True)
        check(cx.ok, "AZZURRA: funzioni pure + CheckSignal + pezzo dell'autotest compilati in C++ (g++ -Wall) %s"
              % ("" if cx.ok else cx.err[:600]))
        if cx.ok:
            b = []
            casi_puri(cx, b)
            viola_pura(cx_old, cx, b)
            FAILS.extend(b)
            print("\nX) CheckSignal VERA su scenari")
            b = []
            scenari(cx, cx_old, b)
            FAILS.extend(b)
        if not SENZA_MUTANTI and not FAILS:
            mutanti(raw.decode("ascii"), old, cx_old)
    finally:
        shutil.rmtree(tmp_old, ignore_errors=True)
        shutil.rmtree(tmp_new, ignore_errors=True)
    print("\nNON PROVATO: compilazione MQL5 (MetaEditor assente), CTrade, Guardian oltre la sua riga, indicatori del "
          "terminale, tick reali, NESSUN backtest.")
    if FAILS:
        print("\nESITO: FAIL (%d)" % len(FAILS))
        for f in FAILS[:30]:
            print("  - " + f)
        sys.exit(1)
    print("\nESITO: PASS")


if __name__ == "__main__":
    main()
